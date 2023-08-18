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
// | 图片处理工具类
// +----------------------------------------------------------------------
namespace imagetool;

use think\Image;

class ImageTool
{
    /**
	 * [thumb 缩略图]
	 * @param  [type] $dst    [目标图片]
	 * @param  [type] $type   [缩略图类型1:等比例缩,2:缩放后填充,3:居中裁剪,4:左上角裁剪,5:右下角裁剪,6:固定尺寸缩放]
	 * @param  [type] $width  [缩略图宽度]
	 * @param  [type] $height [缩略图高度]
	 * @param null|string $save_type  图像保存类型
	 * @param int  $quality   	  图像质量
	 * @param bool $interlace     是否对JPEG类型图像设置隔行扫描 1:是 0：否
	 * @param  [type] $del    [是否删除原图]
	 * @return [type]         [返回缩略图路径]
	 */
	public static function thumb($dst, $type = '', $width = '', $height = '', $save_type = '', $quality = '', $interlace = '', $del = false)
	{
		//目标图片
		if (!$dst) {
			return ['code' => 0, 'msg' => '请选择目标图片!', 'path' => ''];
		}
		//缩略图类型1:等比例缩,2:缩放后填充,3:居中裁剪,4:左上角裁剪,5:右下角裁剪,6:固定尺寸缩放
		$type = intval($type);
		if (!$type) {
			$type = get_one_cache_config('WEB_THUMB_TYPE');
		}
		if (!$type) {
			$type = 1;
		}
		//缩略图宽度
		if (!$width) {
			$width = get_one_cache_config('WEB_THUMB_WIDTH');
		}
		$width = intval($width);
		if (!$width) {
			$width = 150;
		}
		//缩略图宽度
		if (!$height) {
			$height = get_one_cache_config('WEB_THUMB_HEIGHT');
		}
		$height = intval($height);
		if (!$height) {
			$height = 150;
		}
		//图像保存类型 png jpeg jpg gif
		if (!$save_type) {
			$save_type = get_one_cache_config('WEB_THUMB_SAVE_TYPE');
		}
		if (!$save_type) {
			$save_type = null;
		}
		//图像质量
		if (!$quality) {
			$quality = get_one_cache_config('WEB_THUMB_QUALITY');
		}
		$quality = intval($quality);
		if (!$quality) {
			$quality = 80;
		}
		//是否对JPEG类型图像设置隔行扫描
		if ($interlace == '') {
			$interlace = get_one_cache_config('WEB_THUMB_INTERLACE');
		}
		if ($interlace) {
			$interlace = true;
		} else {
			$interlace = false;
		}
		//目标图片根路径
		$dst_img_path = STATIC_PATH . '/' . $dst;
		$array = explode('.', basename($dst));
		//新图片根路径
		$new_img_path = dirname($dst_img_path) . '/' . time() . rand(10000, 99999) . '.' . end($array);
		//新图片存储路径
		$new_img_name = str_replace(STATIC_PATH . '/', '', $new_img_path);
		$image = Image::open($dst_img_path);
		// 按照原图的比例生成一个最大为150*150的缩略图并保存为thumb.png
		$image->thumb($width, $height, $type)->save($new_img_path, $save_type, $quality, $interlace);
		if ($del) {
			@unlink($dst_img_path);
		}
		return ['code' => 1, 'msg' => '缩略成功！', 'path' => $new_img_name];
	}
    /**
	 * [water 水印图片设置]
	 * @param  [type] $dst        [原图]
	 * @param  [type] $type       [水印类型 1：图片，2：文字]
	 * @param  [type] $water_img  [水印图片]
	 * @param  [type] $water_text [水印文字]
	 * @param  [type] $text_size  [水印文字大小]
	 * @param  [type] $text_color [水印文字颜色]
	 * @param  [type] $water_tmd  [水印透明度]
	 * @param  [type] $water_pos  [水印位置]
	 * @param  [type] $del        [是否删除原图]
	 * @return [type]             [description]
	 */
	public static function water($dst, $type = '', $water_img = '', $water_text = '', $text_size = '', $text_color = '', $water_tmd = '', $water_pos = '', $del = false)
	{
		//目标图片
		if (!$dst) {
			return ['code' => 0, 'msg' => '请选择目标图片!', 'path' => ''];
		}
		//水印类型1:图片,2:文字
		$type = intval($type);
		if (!$type) {
			$type = get_one_cache_config('WEB_WATER_TYPE');
		}
		if (!$type) {
			$type = 1;
		}
		//水印透明度
		if (!$water_tmd) {
			$water_tmd = get_one_cache_config('WEB_WATER_TMD');
		}
		if (!$water_tmd) {
			$water_tmd = 50;
		}
		//水印位置
		if (!$water_pos) {
			$water_pos = get_one_cache_config('WEB_WATER_POS');
		}
		if (!$water_pos) {
			$water_pos = 8;
		}
		//目标图片根路径
		$dst_img_path = STATIC_PATH . '/' . $dst;
		$array = explode('.', basename($dst));
		//新图片根路径
		$new_img_path = dirname($dst_img_path) . '/' . time() . rand(10000, 99999) . '.' . end($array);
		//新图片存储路径
		$new_img_name = str_replace(STATIC_PATH . '/', '', $new_img_path);
		if ($type == 1) { //图片水印
			//水印图片
			if (!$water_img) {
				$water_img = STATIC_PATH . '/' . get_one_cache_config('WEB_WATER_IMG');
			} else {
				$water_img = STATIC_PATH . '/' . $water_img;
			}
			if (!file_exists($water_img)) {
				@unlink($dst_img_path); //删除目标图
				return ['code' => 0, 'msg' => '水印图像不存在！'];
			}
			$image = Image::open($dst_img_path);
			// 给原图左上角添加透明度为50的水印并保存alpha_image.png
			$image->water($water_img, $water_pos, $water_tmd)->save($new_img_path);
		} else { //文字水印
			//文字
			if (!$water_text) {
				$water_text = get_one_cache_config('WEB_WATER_TEXT');
			}
			if (!$water_text) {
				$water_text = 'www.zengcms.cn';
			}
			//文字大小
			if (!$text_size) {
				$text_size = get_one_cache_config('WEB_WATER_TEXT_SIZE');
			}
			$text_size = intval($text_size);
			if (!$text_size) {
				$text_size = 20;
			}
			//文字颜色
			if (!$text_color) {
				$text_color = get_one_cache_config('WEB_WATER_TEXT_COLOR');
			}
			if (!$text_color) {
				$text_color = '#ffffff';
			}
			//文字透明度
			if (!$text_size) {
				$text_size = get_one_cache_config('WEB_WATER_TEXT_SIZE');
			}
			$text_size = intval($text_size);
			if (!$text_size) {
				$text_size = 20;
			}
			$image = Image::open($dst_img_path);
			// 给原图左上角添加水印并保存water_image.png
			$image->text($water_text, PROJECT_PATH . '/data/msyh.ttc', $text_size, $text_color, $water_pos)->save($new_img_path);
		}
		//判断是否删除原图
		if ($del) {
			@unlink($dst_img_path);
		}
		return ['code' => 1, 'msg' => '水印成功！', 'path' => $new_img_name];
	}
}
