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
// | 搜索控制器
// +----------------------------------------------------------------------
namespace app\controller;

use think\facade\Db;
use think\facade\View;

class Search extends Base
{
    // 开始搜索
    public function index()
    {
        $where = array();
        // 搜索类型-模型标识
        $name = input('type','');
        $suffix = ''; //搜索
        // 筛选栏目id条件
        if(!$name){ //筛选
            // 搜索栏目分类
            $category_id = input('id');
            if (!is_numeric($category_id)) {
                $category_id = get_category_byname($category_id, 'id');
            }
            // 获取所有子栏目ID包含自身-相同模型
            $typeids = getAllChildcateIdsArr_same_model($category_id);
            $where[] = ['category_id', 'in', $typeids];
            // 获取模型标识
            $name = get_document_model(get_category_byid($category_id)['model_id'],'name');
            $suffix = '_list'; //筛选
        }
        // 筛选排序条件
        $order = ['sort'=>'desc','create_time' => 'desc', 'id' => 'desc'];
        $_order = input('order');
        // 1时间排序，2浏览量排序
        if($_order){
            if($_order == 1){
                $order = ['update_time' => 'desc'];
            }elseif($_order == 2){
                $order = ['view' => 'desc'];
            }else{
                // 默认排序
                $order = ['sort'=>'desc','create_time' => 'desc', 'id' => 'desc'];
            }
        }
        // 筛选或搜索关键词条件
        $keywords = input('keywords');
        if ($keywords) {
            $search_keywords = array_column(get_search_field($name,1),'name');
            if($search_keywords){
                $where[] = [implode('|',$search_keywords).'|title|keywords|description', 'like', "%$keywords%"];
            }else{
                $where[] = ['title','like',"%$keywords%"];
            }
        }
        // 获取地址参数数组
        $parseArr = parse_url(get_url());
        if(isset($parseArr['query'])){
            parse_str($parseArr['query'],$param);
            if(isset($param['page'])){
                unset($param['page']);
            }
        }else{
            $param = [];
        }
        // 筛选字段条件
        $search_field_arr = array_column(get_search_field($name),'name');
        foreach($search_field_arr as $k=>$v){
            if(isset($param[$v]) && $param[$v]){
                $where[] = [$v, '=', $param[$v]];
            }
        }
        // 地址静态处理
        $pages = input('param.page/d');
        // 绑定类库标识
        bind('think\Paginator', get_paging_class_name(LANG_DIR));
        $options = [
            'list_rows'=> $this->get_config['SEARCH_PAGE_NUMBER'],
            'var_page' => 'page',
            'page' => $pages,
            'path' => (string)url(LANG_URL_DIR . "/search", [], get_one_cache_config('other_suffix','html'), get_one_cache_config('WEB_PATH_PATTERN')?false:true) . "?page=[PAGE]" ."&" .http_build_query($param). "#miao",
        ];
        $extend = get_document_model($name,'extend');
        if($extend === ''){
            abort(400,'参数错误！');
        }
        // dump($where);die;
        $fieldStr = get_field_str($name);
        if($extend){
            $extend_name = get_document_model($extend,'name');
            $list = Db::name($extend_name)
            ->alias('a')
            ->join($extend_name.'_'.$name.' b','a.id = b.id')
            ->field($fieldStr)
            ->where($where)
            ->order($order)
            ->paginate($options);
        }else{
            $list = Db::name($name)
            ->field(true)
            ->where($where)
            ->order($order)
            ->paginate($options);
        }
        $data = array();
        $data = $list->all();
        if ($data) {
            foreach ($data as $k => $v) {
                // 中文标题
                $title = str_replace($keywords, "<font color='red'>" . $keywords . "</font>", $v['title']);
                $data[$k]['title'] = $title;
                // 英文标题
                $title_en = str_replace($keywords, "<font color='red'>" . $keywords . "</font>", $v['title_en']);
                $data[$k]['title_en'] = $title_en;
                // 中文描述
                $description = str_replace($keywords, "<font color='red'>" . $keywords . "</font>", $v['description']);
                $data[$k]['description'] = $description;
                // 英文描述
                $description_en = str_replace($keywords, "<font color='red'>" . $keywords . "</font>", $v['description_en']);
                $data[$k]['description_en'] = $description_en;
                // 栏目中文名称
                $data[$k]['typename'] = get_category_byid($v['category_id'], 'typename');
                // 栏目英文名称
                $data[$k]['typename_en'] = get_category_byid($v['category_id'], 'typename_en');
                // 栏目地址
                $data[$k]['typeurl'] = get_nav($v['category_id'],'typeurl');
                // 内容地址
                $data[$k]['arturl'] = get_doc($v['category_id'],$v['id'],'arturl');
            }
        }
        // 搜索历史记录
        $shistory = array();
        if($name && $keywords){
            $_shistory = unserialize(cookie('search_document_shistory'));
            if (!isset($_shistory[$name])) {
                $_shistory[$name] = array();
            }
            // dump($_shistory);die;
            array_unshift($_shistory[$name], $keywords);
            $shistory = array_slice(array_unique($_shistory[$name]), 0, 10);
            // 加入搜索历史
            cookie('search_document_shistory', serialize($_shistory));
        }else{
            $_shistory[$name] = array();
        }
        View::assign([
            'keywords' => $keywords,//关键词
            'list' => $list,//分页
            'data' => $data,//数据
            'shistory'=>$shistory,//搜索记录
        ]);
        $tpl = 'z-search_'.$name.$suffix;
        $tpl = LANG_URL_DIR . '/' . $tpl;
        return View::fetch(config('view.view_path') . $this->get_config['WEB_DEFAULT_THEME'] . $tpl . '.html');
    }
}
