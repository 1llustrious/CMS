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
// | 下载控制器
// +----------------------------------------------------------------------
namespace app\controller;

class Download extends Base
{
    /**
     * [index 下载]
     * @return void
     */
    public function index()
    {
        /* //更新下载次数
        //栏目ID
        $cid = input('cid');
        $cid = isset($cid) && is_numeric($cid) ? $cid : 0;
        //文档ID
        $id = input('id');
        $id = isset($id) && is_numeric($id) ? $id : 0; */
        $file_path = input('file');
        $file_path = base64_decode(urldecode($file_path));
        if (!$file_path) {
            echo"<script>alert('文件不存在！');window.close();</script>";die;
            // echo"<script>alert('文件不存在！');window.reload();</script>";die;
            // echo "<script>alert('文件不存在！');history.go(-1);</script>";die;
        }
        // 这里是下载zip文件
        header("Content-Type: application/zip");
        header("Content-Transfer-Encoding: Binary");
        header("Content-Length: " . filesize($file_path));
        header("Content-Disposition: attachment; filename=\"" . basename($file_path) . "\"");
        ob_clean();
        flush();
        readfile($file_path);
        exit;
    }
}