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
// | 文档控制器
// +----------------------------------------------------------------------
namespace app\controller;

use think\facade\Db;
use think\facade\View;

class Article extends Base
{
    // 文档详细信息
    public function index($id = 0)
    {
        // 完全静态 start
        $city_ename = input('city', '') ? '/' . input('city') : '';//城市英文
        // 拼接静态文件绝对路径
        $static_file_path = VIEW_PATH . LANG_URL_DIR . $city_ename . '/' . input('catename') . '/' . input('id') . '.'. get_one_cache_config('article_suffix','html');
        // 开启栏目静态访问，且静态文件存在
        if (!$this->get_config['WEB_ARTICLE_VISIT'] && file_exists($static_file_path)) {
            return View::fetch($static_file_path);
        }
        // 完全静态 end
        // 文档ID正确性检测
        if (!($id && is_numeric($id))) {
            $this->error('文档ID错误！');
        }
        // 获取栏目标识
        $catename = input('catename');
        // 根据栏目标识获取文档所属栏目信息即当前栏目信息
        $nav = get_category_byname($catename);
        if (!$nav) {
            $this->error('文档所属栏目不存在！');
        }
        // 获取当前文档信息
        $doc = get_doc($catename, $id);
        if (!$doc) {
            $this->error('文档不存在！');
        }
        // 获取文档所属的当前位置
        $pos = tag_pos($nav['id']);
        // 浏览记录 start
        if (cookie('browse_records')) {
            $arr['category_id'] = $doc['category_id'];
            $arr['id'] = $doc['id'];
            $arr['arturl'] = $doc['arturl'];
            $arr['record_time'] = time();//浏览时间
            $browse_records = unserialize(cookie('browse_records'));
            if (in_array($doc['arturl'], array_column($browse_records, 'arturl'))) {
                foreach($browse_records as $k=>$v){
                    if($v['arturl'] == $doc['arturl']){
                        unset($browse_records[$k]);
                    }
                }
            }
            array_unshift($browse_records, $arr);
            if (count($browse_records) >= get_one_cache_config('browse_records_number')) {
                array_pop($browse_records);
            }
            cookie('browse_records', serialize(array_values($browse_records)));
        } else {
            $arr['category_id'] = $doc['category_id'];
            $arr['id'] = $doc['id'];
            $arr['arturl'] = $doc['arturl'];
            $arr['record_time'] = time();//浏览时间
            $browse_records[] = $arr;
            cookie('browse_records', serialize($browse_records));
        }
        // 浏览记录 end
        // 根据栏目标识获取模型表信息
        $model_tables_info = get_document_table_info($catename);
        if (!$model_tables_info['table_name']) {
            $this->error('文档所属模型不存在!');
        }
        // 获取表名
        if ($model_tables_info['extend']) { //非独立模型
            $table_name = $model_tables_info['extend_table_name'];
        } else { //独立模型
            $table_name = $model_tables_info['table_name'];
        }
        // 更新浏览次数
        if (session('view') != md5($doc['id'])) {
            Db::name($table_name)->where('id', $doc['id'])->strict(false)->inc('view')->update();
            session('view', md5($doc['id']));
        }
        // 上一篇
        $preDoc = tag_doc($catename, 1, $where = [['id', '<', $id], ['category_id', '=', $nav['id']]], $flags = '', $field = '', $order = 'id desc', $titlelen = '', $desclen = '');
        if ($preDoc) {
            $preDoc = $preDoc[0];
        }
        // 下一篇
        $nextDoc = tag_doc($catename, 1, $where = [['id', '>', $id], ['category_id', '=', $nav['id']]], $flags = '', $field = '', $order = 'id asc', $titlelen = '', $desclen = '');
        if ($nextDoc) {
            $nextDoc = $nextDoc[0];
        }
        // 单页模式
        $tpl = str_replace(array('.html', '.htm', '.tpl'), array('', '', ''), $nav['article_template']);
        $tpl = LANG_URL_DIR . '/' . $tpl;//LANG_URL_DIR语言、WEB_MOBILE_THEME_SUFFIX手机模板后缀
        // 拼接动态文件绝对路径
        $dt_file_path = config('view.view_path') . $this->get_config['WEB_DEFAULT_THEME'] . $tpl . '.html';
        View::assign([
            'nav' => $nav,//当前栏目信息
            'pos' => $pos,//当前栏目位置
            'doc' => $doc,//当前文档信息
            'preDoc' => $preDoc,//上一篇
            'nextDoc' => $nextDoc,//下一篇
        ]);
        // 获取城市信息
        $city = input('city', '');
        $cinfo = '';
        if ($city) {
            $cinfo = get_city_bypinyin($city);
        }
        // 判断是动态访问还是静态访问
        if ($this->get_config['WEB_ARTICLE_VISIT']) { //动态访问
            return View::fetch($dt_file_path);
        } else { //静态访问
            if ($cinfo) { //判断是否有地区
                $path = VIEW_PATH . LANG_URL_DIR . '/' . $cinfo['pinyin'] . '/' . $catename . '/';
            } else {
                $path = VIEW_PATH . LANG_URL_DIR . '/' . $catename . '/';
            }
            // 拼接静态文件绝对路径
            $jt_file_path = $path . $id . '.'.get_one_cache_config('article_suffix','html');
            // 如果存放静态文件的目录不存在，先创建目录，再生成静态文件
            if (!is_dir($path)) {
                mkdir($path, 0777, true);
                $html = View::fetch($dt_file_path);
                file_put_contents($jt_file_path, $html);
            }
            // 如果存放静态文件的目录存在，但静态文件不存在，那么先生成静态文件
            if (!file_exists($jt_file_path)) {
                $html = View::fetch($dt_file_path);
                file_put_contents($jt_file_path, $html);
            }
            // 如果存放静态文件的目录存在，且静态文件存在，直接渲染静态文件
            return View::fetch($jt_file_path);
        }
    }
}
