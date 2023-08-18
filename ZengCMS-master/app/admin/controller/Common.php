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
// | 共有的、公共的控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\facade\Cookie;

class Common extends Base
{
    /**
     * [initialize 初始化]
     * @return void
     */
    protected function initialize()
    {
        // $nwe = new 控制器($this->app);//只能在本模块使用
        // $new  = new Order($this->app);
        // 调用其他模块中的方法
        // $test = new \app\apitest\controller\Order($this->app);
        // 格式为  文件位置 模块 控制器
        // $all = $test->eee('sdfdsfds');
        parent::initialize();
    }
    /**
     * [enlang 设置语言]
     * @return void
     */
    public function enlang()
    {
        $lang = input('lang');
        switch ($lang) {
            case 'zh-cn':
                Cookie::set('think_lang', 'zh-cn');
                break;
            case 'en-us':
                Cookie::set('think_lang', 'en-us');
                break;
            default:
                Cookie::set('think_lang', 'zh-cn');
                break;
        }
        $this->success(lang('change language success'));
    }
    /**
     * [get_city 保存浏览器定位坐标]
     * @return void
     */
    public function baidu_position() 
    {
        $value = input('value');
        $cookie = cookie('baidu_position');
        if ($cookie != $value) {
            cookie('baidu_position',$value,10000);
            exit('ok');
        }
        exit('none');
    }
}