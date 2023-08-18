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
// | 后台首页控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\facade\Db;

class Index extends Base
{
    // 首页
    public function index()
    {
        return view('index',[
            'meta_title' => '后台管理',
        ]);
    }
    // 欢迎页
    public function welcome()
    {
        // 系统基本参数(tp框架内置方法获取)
        // $webinfo = request()->server();
        $serverinfo = server_info();//获取服务器信息
        // 查询管理员总数
        $adminNum = Db::name('admin')->count();
        // 查询网站配置总数
        $configNum = Db::name('config')->count();
        // 附件总数
        $attachmentNum = Db::name('attachment')->count();
        return view('welcome',[
            'meta_title' => '后台管理',//标题
            // 'webinfo' =>$webinfo,//系统基本参数
            'serverinfo' => $serverinfo,//获取服务器信息
            'adminNum' => $adminNum,//管理员总数
            'configNum' => $configNum,//网站配置总数
            'attachmentNum' => $attachmentNum,//附件总数
        ]);
    }
}
