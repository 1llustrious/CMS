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
// | 前台首页控制器
// +----------------------------------------------------------------------
namespace app\controller;

use think\facade\View;

class Index extends Base
{
    /**
     * [Description 首页]
     * @DateTime 2020-04-28 20:50:37
     * @return void
     */
    public function index()
    {
        // 完全静态 开始
        $static_file_path = VIEW_PATH . LANG_URL_DIR . '/index.'.get_one_cache_config('index_suffix','html'); //拼接静态文件绝对路径
        if (!$this->get_config['WEB_INDEX_VISIT'] && file_exists($static_file_path)) {
            return View::fetch($static_file_path);
        }
        // 完全静态 结束

        // 拼接动态文件绝对路径
        $dt_file_path = config('view.view_path') . $this->get_config['WEB_DEFAULT_THEME'] . LANG_URL_DIR . '/index.html'; 
        // 判断是动态访问还是静态访问
        if ($this->get_config['WEB_INDEX_VISIT']) { //动态访问
            return View::fetch($dt_file_path);
        } else { //静态访问
            $path = VIEW_PATH . LANG_URL_DIR;
            $jt_file_path = VIEW_PATH . LANG_URL_DIR . '/index.' . get_one_cache_config('index_suffix','html'); // 拼接静态文件绝对路径
            // 如果存放静态文件的目录不存在，先创建目录，再生成静态文件
            if (!is_dir($path)) {
                mkdir($path, 0777, true);
                $html = View::fetch($dt_file_path);
                file_put_contents($jt_file_path, $html);
            }
            //如果存放静态文件的目录存在，但静态文件不存在，那么先生成静态文件
            if (!file_exists($jt_file_path)) {
                $html = View::fetch($dt_file_path);
                file_put_contents($jt_file_path, $html);
            }
            //如果存放静态文件的目录存在，且静态文件存在，直接渲染静态文件
            return View::fetch($jt_file_path);
        }
    }
}
