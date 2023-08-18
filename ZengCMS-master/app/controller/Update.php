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
// | 更新系统控制器
// +----------------------------------------------------------------------
namespace app\controller;

use app\BaseController;

class Update extends BaseController
{
    // 初始化方法
    public function initialize()
    {
        parent::initialize();
    }
    // 检查版本
    public function checkVersion()
    {
        if (request()->isPost()) {
            $data = input('post.');
            $new_version = NEW_ZENGCMS_VERSION;
            $arr = explode('@', $new_version);
            if (version_compare($arr[1], $data['version'], '>')) {
                return json(['version'=>$arr[1]]);
            } else {
                return json(['version'=>'']);
            }
        }
        return json(['version'=>'']);
    }
    // 获取更新包下载地址
    public function getDownloadUrl()
    {
        if (request()->isPost()) {
            $version = input('version');
            return json(['url'=>request()->domain() . '/' . $version . '.zip']);
        } else {
            return json(['url'=>'']);
        }
        return json(['url'=>'']);
    }
}
