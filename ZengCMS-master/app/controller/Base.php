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
// | 基础控制器
// +----------------------------------------------------------------------
namespace app\controller;

use think\App;
use think\facade\View;
use app\BaseController;

header("Content-type:text/html;charset=utf-8");

class Base extends BaseController
{
    public $get_config = array();
    // 中间件别名
    protected $middleware = [
        // 统计Stats
        'Stats'=>['except'=>['hello']],
        // 'Stats'=>['only'=>['hello']],
        // 限制访问频率
        'Throttle'=>['except'=>['hello']],
    ];
    // 初始化方法
    // protected function initialize()
    public function __construct(App $app)
    {
        // 获取缓存配置
        $this->get_config = get_all_cache_config();
        // 模板中用$get_config['英文名称'];获取配置信息
        $get_config = get_all_cache_config();
        // 前台禁止ip访问
        if ($this->get_config['WEB_BANNED_IP']) {
            $iplist = str_replace(array("\r\n", "\r", "\n"), ",",$this->get_config['WEB_BANNED_IP']);
            if (in_host(get_userip(),$iplist)) {
                exit('403: You don\'t have permission to access!');
            }
        }
        // 判断是否关闭站点
        if (!$this->get_config['WEB_ENABLE_SITE']) {
            exit($this->get_config['WEB_CLOSE_SITE_TITLE']);
        }
        // 记录访问者cookie
        if (!cookie('UVCOOKIE')) {
            $value = md5(microtime() . get_userip() . rand());
            $overTime = mktime(0, 0, 0, date('m'), date('d') + 1, date('Y')) - time();
            cookie('UVCOOKIE', $value, $overTime);
        }
        // 定义PC模板路径
        if(!PUBLIC_DIR){
            $this->isdefine("VIEW_PATH", str_replace('/static/template/','',config('view.view_path')));
        }else{
            $this->isdefine("VIEW_PATH", str_replace('/public/static/template/','',config('view.view_path')));
        }
        // 各语言PC或手机url目录，/m或/en或/en_m或空
        $this->isdefine("LANG_URL_DIR", get_index_lang()['lang_url_dir']);
        // m或en或enm或空
        $this->isdefine("LANG_DIR", str_replace(['/','_'],'',LANG_URL_DIR));
        View::assign([
            'get_config' => $get_config,//配置信息
        ]);
        // parent::initialize();
        parent::__construct($app);
    }
    // 判断是否定义
    protected function isdefine($name,$value)
    {
        if(!defined($name)){
            define($name,$value);
        }
    }
}
