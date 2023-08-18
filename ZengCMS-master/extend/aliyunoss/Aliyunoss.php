<?php
// +----------------------------------------------------------------------
// | ZengCMS [ 火火 ]
// +----------------------------------------------------------------------
// | Copyright (c) 2018 http://zengcms.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: 火火 <zengcms@qq.com>
// +----------------------------------------------------------------------

// +----------------------------------------------------------------------
// | 阿里云aliyun的oss使用
// +----------------------------------------------------------------------
namespace aliyunoss;

use OSS\OssClient;
use OSS\Core\OssException;
use OSS\Core\OssUtil;

class Aliyunoss
{
	private $accessKeyId;
	private $accessKeySecret;
	private $endpoint;
	private $bucket;
	public function __construct()
	{
		// 阿里云主账号AccessKey拥有所有API的访问权限，风险很高。
		// 强烈建议您创建并使用RAM账号进行API访问或日常运维，
		// 请登录 https://ram.console.aliyun.com 创建RAM账号。
		$this->accessKeyId = get_one_cache_config('AccessKeyID');
		$this->accessKeySecret = get_one_cache_config('AccessKeySecret');
		// Endpoint以杭州为例，其它Region请按实际情况填写。
		$this->endpoint = get_one_cache_config('Endpoint');
		// 存储空间名称
		$this->bucket = get_one_cache_config('Bucket');
	}
	/**
	 * [uploadFile 文件上传]
	 * @param  [type] $filename [文件名称]
	 * @param  [type] $filepath [文件临时位置]
	 * @return [type]           [description]
	 */
	// static声明的静态方法里不可以使用$this 需要使用self来引用当前类中的方法或是变量。
	public function uploadFile($filename, $filepath)
	{
		try {
			$ossClient = new OssClient($this->accessKeyId, $this->accessKeySecret, $this->endpoint);
			$res = $ossClient->uploadFile($this->bucket, $filename, $filepath);
			return $res['info']['url'];
		} catch (OssException $e) {
			printf(__FUNCTION__ . ": FAILED\n");
			printf($e->getMessage() . "\n");
			return false;
		}
	}
	/**
	 * [multiuploadFile 分片上传]
	 * @param  [type] $object [文件名称]
	 * @param  [type] $file [文件地址]
	 * @return void
	 */
	public function multiuploadFile($object, $file)
	{
		// 方法一：分片上传本地文件
		/* $options = array(
			OssClient::OSS_CHECK_MD5 => true,
			OssClient::OSS_PART_SIZE => 1000,
		);
		try{
			$ossClient = new OssClient($this->accessKeyId, $this->accessKeySecret, $this->endpoint);
			$ossClient->multiuploadFile($this->bucket, $object, $file, $options);
		} catch(OssException $e) {
			printf(__FUNCTION__ . ": FAILED\n");
			printf($e->getMessage() . "\n");
			return false;
		}
		// print(__FUNCTION__ . ":  OK" . "\n");
		return true; */
		// 方法二：分片上传完整示例
		/**
		 *  步骤1：初始化一个分片上传事件，获取uploadId。
		 */
		try{
			$ossClient = new OssClient($this->accessKeyId, $this->accessKeySecret, $this->endpoint);
			//返回uploadId。uploadId是分片上传事件的唯一标识，您可以根据uploadId发起相关的操作，如取消分片上传、查询分片上传等。
			$uploadId = $ossClient->initiateMultipartUpload($this->bucket, $object);
		} catch(OssException $e) {
			printf(__FUNCTION__ . ": initiateMultipartUpload FAILED\n");
			printf($e->getMessage() . "\n");
			return false;
		}
		// print(__FUNCTION__ . ": initiateMultipartUpload OK" . "\n");
		/**
		 * 步骤2：上传分片。
		 */
		// set_time_limit(0);
		// ini_set('memory_limit', '1280000000M');
		$partSize = 10 * 1024 * 1024;
		$uploadFileSize = filesize($file);
		$pieces = $ossClient->generateMultiuploadParts($uploadFileSize, $partSize);
		$responseUploadPart = array();
		$uploadPosition = 0;
		$isCheckMd5 = true;
		foreach ($pieces as $i => $piece) {
			$fromPos = $uploadPosition + (integer)$piece[$ossClient::OSS_SEEK_TO];
			$toPos = (integer)$piece[$ossClient::OSS_LENGTH] + $fromPos - 1;
			$upOptions = array(
				// 上传文件。
				$ossClient::OSS_FILE_UPLOAD => $file,
				// 设置分片号。
				$ossClient::OSS_PART_NUM => ($i + 1),
				// 指定分片上传起始位置。
				$ossClient::OSS_SEEK_TO => $fromPos,
				// 指定文件长度。
				$ossClient::OSS_LENGTH => $toPos - $fromPos + 1,
				// 是否开启MD5校验，true为开启。
				$ossClient::OSS_CHECK_MD5 => $isCheckMd5,
			);
			// 开启MD5校验。
			if ($isCheckMd5) {
				$contentMd5 = OssUtil::getMd5SumForFile($file, $fromPos, $toPos);
				$upOptions[$ossClient::OSS_CONTENT_MD5] = $contentMd5;
			}
			try {
				// 上传分片。
				$responseUploadPart[] = $ossClient->uploadPart($this->bucket, $object, $uploadId, $upOptions);
			} catch(OssException $e) {
				printf(__FUNCTION__ . ": initiateMultipartUpload, uploadPart - part#{$i} FAILED\n");
				printf($e->getMessage() . "\n");
				return false;
			}
			// printf(__FUNCTION__ . ": initiateMultipartUpload, uploadPart - part#{$i} OK\n");
		}
		// $uploadParts是由每个分片的ETag和分片号（PartNumber）组成的数组。
		$uploadParts = array();
		foreach ($responseUploadPart as $i => $eTag) {
			$uploadParts[] = array(
				'PartNumber' => ($i + 1),
				'ETag' => $eTag,
			);
		}
		/**
		 * 步骤3：完成上传。
		 */
		try {
			// 执行completeMultipartUpload操作时，需要提供所有有效的$uploadParts。OSS收到提交的$uploadParts后，会逐一验证每个分片的有效性。当所有的数据分片验证通过后，OSS将把这些分片组合成一个完整的文件。
			$ossClient->completeMultipartUpload($this->bucket, $object, $uploadId, $uploadParts);
		}  catch(OssException $e) {
			printf(__FUNCTION__ . ": completeMultipartUpload FAILED\n");
			printf($e->getMessage() . "\n");
			return false;
		}
		// printf(__FUNCTION__ . ": completeMultipartUpload OK\n");
		return true;
	}
	/**
	 * [deleteFile 删除文件]
	 * @param  [type] $object [文件名称]
	 * @return void
	 */
	public function deleteFile($object)
	{
		try{
			$ossClient = new OssClient($this->accessKeyId, $this->accessKeySecret, $this->endpoint);
			$ossClient->deleteObject($this->bucket, $object);
			return true;
		} catch(OssException $e) {
			printf(__FUNCTION__ . ": FAILED\n");
			printf($e->getMessage() . "\n");
			return false;
		}
	}
}
