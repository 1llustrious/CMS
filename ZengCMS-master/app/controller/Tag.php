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
// | tag标签控制器
// +----------------------------------------------------------------------
namespace app\controller;

use think\facade\Db;
use think\facade\View;

class Tag extends Base
{
    // tag所有标签分页路由?page=x&keywords=x
    public function index()
    {
        $where = array();
        $keywords = input('keywords');
        if($keywords){
            $where[] = ['name|seotitle|keywords|description','like',"%$keywords%"];
        }
        // 搜索历史记录
        $shistory = unserialize(cookie('search_tag_shistory'));
        if (!$shistory) {
            $shistory = array();
        }
        if($keywords){
            array_unshift($shistory, $keywords);
        }
        $shistory = array_slice(array_unique($shistory), 0, 10);
        // 加入搜索历史
        cookie('search_tag_shistory', serialize($shistory));
        // 分类列表数据
        $order = 'view desc,update_time desc,id desc';
        // 绑定类库标识
        bind('think\Paginator', get_paging_class_name(LANG_DIR));
        // 地址静态处理
        $pages = input('param.page/d');
        $list = Db::name('tag')
        ->field(true)
        ->where($where)
        ->order($order)
        ->paginate([
            'list_rows'=> get_one_cache_config('CATEGORY_PAGE_NUMBER'),
            'var_page' => 'page',
            'page' => $pages,
            'path' => (string)url(LANG_URL_DIR . "/tag", [], get_one_cache_config('other_suffix','html'), get_one_cache_config('WEB_PATH_PATTERN')?false:true) . "?page=[PAGE]&keywords=" . $keywords,
        ])->each(function ($item, $key) {
            return $item;
        });
        $data = array();
        $data = $list->all();
        if ($data) {
            foreach ($data as $k => $v) {
                // 标签地址
                $data[$k]['tagurl'] = get_tag($v['name'],'tagurl');
                // 标签名称
                $name = str_replace($keywords, "<font color='red'>" . $keywords . "</font>", $v['name']);
                $data[$k]['name'] = $name;
                // seo标题
                $seotitle = str_replace($keywords, "<font color='red'>" . $keywords . "</font>", $v['seotitle']);
                $data[$k]['seotitle'] = $seotitle;
                // 关键字
                $keywords = str_replace($keywords, "<font color='red'>" . $keywords . "</font>", $v['keywords']);
                $data[$k]['keywords'] = $keywords;
                // 描述
                $description = str_replace($keywords, "<font color='red'>" . $keywords . "</font>", $v['description']);
                $data[$k]['description'] = $description;
            }
        }
        View::assign([
            'list' => $list,//分页
            'data' => $data,//数据
            'shistory'=>$shistory,//搜索记录
        ]);
        $tpl = 'z-tag';
        $tpl = LANG_URL_DIR . '/' . $tpl;
        return View::fetch(config('view.view_path') . $this->get_config['WEB_DEFAULT_THEME'] . $tpl . '.html');
    }
    // tag某标签所有信息分页路由
    public function detail($tag='')
    {
        // 完全静态 开始
        if (!$this->get_config['WEB_CATEGORY_VISIT']) { //静态模式
            $city_ename = input('city', '') ? '/' . input('city') : '';//城市英文
            if (input('page')) { //分页时
                $file = VIEW_PATH . LANG_URL_DIR . $city_ename . '/tag/'. $tag . '/' . input('page') . '.' .get_one_cache_config('other_suffix','html');
            } else {
                $file = VIEW_PATH . LANG_URL_DIR . $city_ename . '/tag/' . $tag  . '.' .get_one_cache_config('other_suffix','html');
            }
            // 如果静态文件是存在，直接渲染
            if (file_exists($file)) {
                return View::fetch($file);
            }
        }
        // 完全静态 结束
        // 更新点击次数
        if (session('tag') != md5($tag)) {
            Db::name('tag')->where('name', $tag)->strict(false)->inc('view')->update();
            session('tag', md5($tag));
        }
        // 获取城市信息
        $city = input('city', '');
        $pinyin = '';
        if ($city) {
            $cinfo = get_city_bypinyin($city);
            if ($cinfo) {
                $pinyin = '/' . $cinfo['pinyin'];
            }
        }
        // 绑定类库标识-绑定分页类
        bind('think\Paginator', get_paging_class_name(LANG_DIR));
        // 地址静态处理
        $pages = input('param.page/d',1);
        $options = [
            'list_rows'=> get_one_cache_config('CATEGORY_PAGE_NUMBER'),
            'var_page' => 'page',
            'page' => $pages,
            'path' => (string)url(LANG_URL_DIR . $pinyin . "/tag/" . $tag . "/[PAGE]", [], get_one_cache_config('other_suffix','html'), get_one_cache_config('WEB_PATH_PATTERN')?false:true)
        ];
        $cache_name = 'tag_' . md5($tag) . '_' . $pages;
        if (get_cache($cache_name)) {
            $list = get_cache($cache_name);
        } else {
            $list = Db::name('tagmap')
            ->alias('tm')
            ->field('tm.category_id,tm.document_id')
            ->LeftJoin('tag t','t.id=tm.tag_id')
            ->where('t.name',$tag)
            ->paginate($options)
            ->each(function ($item, $key) {
                $data = get_doc($item['category_id'],$item['document_id']);
                if($data){
                    foreach($data as $k=>$v){
                        $item[$k] = $v;
                    }
                }
                return $item;
            });
            set_cache($cache_name,$list);
        }
        $info = get_tag($tag);
        View::assign([
            'tag' => $info,//当前tag信息
            'docList' => $list,//文章列表
        ]);
        if($info && 1 == $info['status']){
            if (!$list->all()) { //判断文档是否有数据
                // abort(404, '页面异常');
                $this->error('暂无数据！');
            }
            $tpl = LANG_URL_DIR . '/z-tag_list';
            $dt_file_path = config('view.view_path'). $this->get_config['WEB_DEFAULT_THEME'] . $tpl . '.html';//拼接动态文件绝对路径
            // 判断是动态访问还是静态访问
            if ($this->get_config['WEB_CATEGORY_VISIT']) { //动态访问
                return View::fetch($dt_file_path);
            } else { //静态访问
                if (input('page')) { //分页时
                    $page = input('page');//获取分页页码
                    if (!empty($pinyin)) {//判断是否有地区
                        $path = VIEW_PATH . LANG_URL_DIR . $pinyin . '/tag/' . $tag . '/';
                    } else {
                        $path = VIEW_PATH . LANG_URL_DIR . '/tag/' . $tag . '/';
                    }
                    //拼接静态文件绝对路径
                    $jt_file_path = $path . $page . '.'.get_one_cache_config('other_suffix','html');
                    //如果存放静态文件的目录不存在，先创建目录，再生成静态文件
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
                } else { //不分页时
                    if (!empty($pinyin)) {//判断是否有地区
                        $path = VIEW_PATH . LANG_URL_DIR . $pinyin . '/tag/' . $tag . '/';
                    } else {
                        $path = VIEW_PATH . LANG_URL_DIR . '/tag/' . $tag . '/';
                    }
                    //拼接静态文件绝对路径
                    if(get_one_cache_config('category_suffix')){
                        $jt_file_path = rtrim($path,'/') . '.' .get_one_cache_config('category_suffix');
                    }else{
                        $jt_file_path = $path . 'index.'.get_one_cache_config('category_suffix','html');
                    }
                    if (!is_dir($path)) {
                        mkdir($path, 0777, true);
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
        }else{
            $this->error('标签不存在或被禁用！');
        }
    }
}
