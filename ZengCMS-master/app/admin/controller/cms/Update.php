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
// | 更新控制器
// +----------------------------------------------------------------------
namespace app\admin\controller\cms;

use tree\Tree;
use think\facade\Db;
use think\facade\View;
use app\admin\controller\Base;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="更新管理")
 * Class Update
 * @package app\admin\controller\cms
 */
class Update extends Base
{
    /**
     * @NodeAnotation(title="更新主页HTML")
     */
    public function index()
    {
        if (request()->isAjax()) {
            // 首页模式,动态或静态
            $showmod = input('showmod') ? 1 : 0;
            Db::name('config')->where('ename','WEB_INDEX_VISIT')->update(['value' => $showmod]);
            if (get_one_cache_config('WEB_INDEX_VISIT') != $showmod) {
                $this->clear_cache();//清除缓存
            }
            $public = !PUBLIC_DIR?'public/':'';
            // 获取前台语言数组
            $lang_arr = $this->get_index_lang_arr();
            foreach ($lang_arr as $lang) {
                $lang = $lang ? $lang . '/' : '';
                @unlink(PROJECT_PATH . '/' . $public . $lang . 'index.' . get_one_config('index_suffix','html'));
                if (!$showmod) { //静态模式
                    curl_get(request()->domain() . '/' . $lang . 'index.' . get_one_config('index_suffix','html'));
                }
            }
            $this->success('更新主页HTML成功！');
        }
        View::assign([
            'meta_title' => '更新主页HTML',
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="更新栏目HTML")
     */
    public function category()
    {
        set_time_limit(0);
        $tree = new Tree();
        if (request()->isAjax()) {
            if (!get_one_config('WEB_CATEGORY_VISIT')) { //静态模式
                $this->clear_cache();//清除缓存
                $lang_arr = $this->get_index_lang_arr();//获取前台语言数组
                $category_id = input('category_id');//更新的栏目ID，如果为0更新所有栏目
                $update_children = input('update_children');//是否更新所选栏目的子栏目
                $start_page = intval(input('start_page'));//起始页码(对列表栏目有效)
                $end_page = intval(input('end_page'));//结束页码(对列表栏目有效)
                $map[] = ['status', '=', 1];//状态
                if ($category_id == 0) { //更新所有栏目
                    $arctype = Db::name('arctype')->field('id,name,ispart,isfirst,pid')->where($map)->select()->toArray();
                } else {
                    if ($update_children) { //更新所选栏目和其子栏目
                        $ChildrenIdsArr = $tree->ChildrenIdsArr(Db::name('arctype'), $category_id);
                        $ChildrenIdsArr[] = $category_id;
                        $map[] = ['id', 'in', $ChildrenIdsArr];
                    } else { //更新所选栏目
                        $map[] = ['id', '=', $category_id];
                    }
                    $arctype = Db::name('arctype')->field('id,name,ispart,isfirst,pid')->where($map)->select()->toArray();
                }
                // 获取已地区优化栏目
                $seo_categoy = get_one_config('WEB_SEO_MENU');
                $seo_categoy = json_decode($seo_categoy);
                if (!$seo_categoy) {
                    $seo_categoy = array();
                }
                // 获取已优化城市
                $seo_city = get_one_config('WEB_SEO_CITY');
                $seo_city = json_decode($seo_city);
                if (!$seo_city) {
                    $seo_city = array();
                }
                if ($arctype) {
                    $public = !PUBLIC_DIR?'public/':'';
                    foreach ($arctype as $v) {
                        // 所选择的所有栏目处理
                        foreach ($lang_arr as $lang) {
                            $lang = $lang ? $lang . '/' : '';
                            if(get_one_config('category_suffix')){
                                @unlink(PROJECT_PATH . '/' . $public . $lang . $v['name'] . '.' . get_one_config('category_suffix'));
                                curl_get(request()->domain() . '/'  . $lang . $v['name'] . '.' .get_one_config('category_suffix'));
                            }else{
                                @unlink(PROJECT_PATH . '/'. $public . $lang . $v['name'] . '/index.' . get_one_config('category_suffix','html'));
                                curl_get(request()->domain() . '/' . $lang . $v['name'] . '/');
                            }
                        }
                        // 所选择的所有列表类型的栏目分页处理
                        if ($end_page >= $start_page && $start_page >= 1) {
                            // 判断是否默认显示第一个子栏目内容
                            if (isset($v['isfirst']) && $v['isfirst'] == 1 && $v['pid'] == 0) {
                                $AllChildcateIdsArr = getAllChildcateIdsArr($v['id']);
                                if (isset($AllChildcateIdsArr[1])) {
                                    $v = get_nav($AllChildcateIdsArr[1]);
                                }
                            }
                            // 列表栏目
                            if ($v['ispart'] == 1) {
                                // 根据栏目ID获取模型表信息
                                $model_table_info = get_document_table_info($v['id']);
                                if ($model_table_info['extend_table_name']) {
                                    // 获取所有子栏目ID包含自身-相同模型
                                    $typeids = getAllChildcateIdsArr_same_model($v['id']);
                                    // 获取栏目文档数量
                                    $doc_number = Db::name($model_table_info['extend_table_name'])
                                    ->where([['status','=',1],['category_id', 'in', $typeids]])
                                    ->count();
                                    if ($doc_number) {
                                        $page_num = ceil($doc_number / get_one_config('CATEGORY_PAGE_NUMBER'));
                                        if ($page_num <= $end_page) {
                                            $end_page = $page_num;
                                        }
                                        for ($i = $start_page; $i <= $end_page; $i++) {
                                            foreach ($lang_arr as $lang) {
                                                $lang = $lang ? $lang . '/' : '';
                                                @unlink(PROJECT_PATH . '/' . $public . $lang . $v['name'] . '/list_' . $v['id'] . '_' . $i . '.' . get_one_config('category_suffix','html'));
                                                curl_get(request()->domain() . '/' . $lang . $v['name'] . '/list_' . $v['id'] . '_' . $i . '.' . get_one_config('category_suffix','html'));
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        // 优化栏目及城市处理
                        if ($seo_categoy && $seo_city && in_array($v['id'], $seo_categoy)) {
                            foreach ($seo_city as $v2) {
                                $region = Db::name('region')->field('pinyin')->where('id', $v2)->find();
                                foreach ($lang_arr as $lang) {
                                    $lang = $lang ? $lang . '/' : '';
                                    if(get_one_config('category_suffix')){
                                        @unlink(PROJECT_PATH . '/' . $public . $lang . $region['pinyin'] . '/' . $v['name'] . '.' . get_one_config('category_suffix'));
                                        curl_get(request()->domain() . '/'  . $lang . $region['pinyin'] . '/' . $v['name'] . '.' .get_one_config('category_suffix'));
                                    }else{
                                        @unlink(PROJECT_PATH . '/'. $public . $lang . $region['pinyin'] . '/' . $v['name'] . '/index.' . get_one_config('category_suffix','html'));
                                        curl_get(request()->domain() . '/' . $lang . $region['pinyin'] . '/' . $v['name'] . '/');
                                    }
                                }
                                // 优化栏目及城市分页的处理
                                if ($end_page >= $start_page && $start_page >= 1) {
                                    // 判断是否默认显示第一个子栏目内容
                                    if (isset($v['isfirst']) && $v['isfirst'] == 1 && $v['pid'] == 0) {
                                        $AllChildcateIdsArr = getAllChildcateIdsArr($v['id']);
                                        if (isset($AllChildcateIdsArr[1])) {
                                            $v = get_nav($AllChildcateIdsArr[1]);
                                        }
                                    }
                                    // 根据栏目标识获取栏目属性
                                    if ($v['ispart'] == 1) {
                                        // 根据栏目ID获取模型表信息
                                        $model_table_info = get_document_table_info($v['id']);
                                        if ($model_table_info['extend_table_name']) {
                                            // 获取所有子栏目ID包含自身-相同模型
                                            $typeids = getAllChildcateIdsArr_same_model($v['id']);
                                            // 获取栏目文档数量
                                            $doc_number = Db::name($model_table_info['extend_table_name'])
                                            ->where([['status','=',1],['category_id', 'in', $typeids]])
                                            ->count();
                                            if ($doc_number) {
                                                $page_num = ceil($doc_number / get_one_config('CATEGORY_PAGE_NUMBER'));
                                                if ($page_num <= $end_page) {
                                                    $end_page = $page_num;
                                                }
                                                for ($i = $start_page; $i <= $end_page; $i++) {
                                                    foreach ($lang_arr as $lang) {
                                                        $lang = $lang ? $lang . '/' : '';
                                                        @unlink(PROJECT_PATH . '/' . $public . $lang . $region['pinyin'] . '/' . $v['name'] . '/list_' . $v['id'] . '_' . $i . '.' . get_one_cache_config('category_suffix','html'));
                                                        curl_get(request()->domain() . '/' . $lang . $region['pinyin'] . '/' . $v['name'] . '/list_' . $v['id'] . '_' . $i . '.' . get_one_cache_config('category_suffix','html'));
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return json(['code' => 1, 'msg' => '更新栏目HTML成功！']);
        }
        // 所有栏目信息
        $allArctypeRes = Db::name('arctype')
        ->order(['sort' => 'desc', 'id' => 'asc'])
        ->field('id,pid,typename')
        ->select()
        ->toArray();
        // 所有栏目信息-分级
        $allArctypeRes = $tree->ChildrenTree($allArctypeRes, 0, 0);
        View::assign([
            'meta_title' => '更新栏目HTML',
            'allArctypeRes' => $allArctypeRes,
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="更新文档HTML")
     */
    public function document()
    {
        set_time_limit(0);
        $tree = new Tree();
        if (request()->isAjax()) {
            if (!get_one_config('WEB_ARTICLE_VISIT')) { //静态模式
                $this->clear_cache();//清除缓存
                // 获取前台语言数组
                $lang_arr = $this->get_index_lang_arr();
                $category_id = input('category_id');
                $update_children = input('update_children');
                $page = input('page/d',1);
                $limit = input('limit/d',get_one_config('CATEGORY_PAGE_NUMBER'));
                $map[] = ['status', '=', 1];
                $map[] = ['ispart', '=', 1];
                if ($category_id == 0) { //更新所有栏目文档
                    $arctype = Db::name('arctype')->field('id,name')->where($map)->select()->toArray();
                } else {
                    if ($update_children) { //更新所选栏目文档和子栏目文档
                        $ChildrenIdsArr = $tree->ChildrenIdsArr(Db::name('arctype'), $category_id);
                        array_unshift($ChildrenIdsArr, $category_id);
                        $map[] = ['id', 'in', $ChildrenIdsArr];
                    } else { //更新所选栏目文档
                        $map[] = ['id', '=', $category_id];
                    }
                    $arctype = Db::name('arctype')->field('id,name')->where($map)->select()->toArray();
                }
                // 获取已地区优化栏目
                $seo_categoy = get_one_config('WEB_SEO_MENU');
                $seo_categoy = json_decode($seo_categoy);
                if (!$seo_categoy) {
                    $seo_categoy = array();
                }
                // 获取已优化城市
                $seo_city = get_one_config('WEB_SEO_CITY');
                $seo_city = json_decode($seo_city);
                if (!$seo_city) {
                    $seo_city = array();
                }
                if ($arctype) {
                    foreach ($arctype as $v) {
                        // 根据栏目ID或标识获取文档表名信息
                        $model_table_info = get_document_table_info($v['id']);
                        if (!$model_table_info['extend_table_name']) {
                            continue;
                        }
                        $document = Db::name($model_table_info['extend_table_name'])
                        ->field('id')
                        ->where([['category_id', '=', $v['id']], ['status', '=', 1]])
                        ->page($page,$limit)
                        ->order(['sort' => 'desc', 'id' => 'desc'])
                        ->select()
                        ->toArray();
                        if (!$document) {
                            continue;
                        }
                        // 先处理地区优化的文档
                        if ($seo_categoy && $seo_city && in_array($v['id'], $seo_categoy)) {
                            $this->extra_update_document($v['id'], $seo_city, $lang_arr);
                        }
                        $public = !PUBLIC_DIR?'public/':'';
                        foreach ($document as $v2) {
                            foreach ($lang_arr as $lang) {
                                $lang = $lang ? $lang . '/' : '';
                                @unlink(PROJECT_PATH . '/' . $public . $lang . $v['name'] . '/' . $v2['id'] . '.' . get_one_cache_config('article_suffix','html'));
                                curl_get(request()->domain() . '/' . $lang . $v['name'] . '/' . $v2['id'] . '.' . get_one_cache_config('article_suffix','html'));
                            }
                        }
                    }
                }
            }
            $this->success('更新文档HTML成功！');
        }
        // 所有栏目信息
        $allArctypeRes = Db::name('arctype')
        ->order(['sort' => 'desc', 'id' => 'asc'])
        ->field('id,pid,typename')
        ->where([['ispart','=',1]])
        ->select()
        ->toArray();
        // 所有栏目信息-分级
        $allArctypeRes = $tree->ChildrenTree($allArctypeRes, 0, 0);
        View::assign([
            'meta_title' => '更新文档HTML',
            'allArctypeRes' => $allArctypeRes,
        ]);
        return view();
    }
    /**
     * [extra_update_document 更新优化城市的文档]
     * @param  [type] $category_id [栏目ID]
     * @param  [type] $seo_city    [优化的城市]
     * @param  [type] $lang_arr    [语言组]
     * @return [type]              [description]
     */
    protected function extra_update_document($category_id, $seo_city, $lang_arr)
    {
        // 根据栏目ID或标识获取文档表名信息
        $model_table_info = get_document_table_info($category_id);
        if (!$model_table_info['extend_table_name']) {
            return true;
        }
        $page = input('page/d',1);
        $limit = input('limit/d',get_one_config('CATEGORY_PAGE_NUMBER'));
        // 获取所有子栏目ID包含自身-相同模型
        $typeids = getAllChildcateIdsArr_same_model($category_id);
        // 获取文档信息
        $document = Db::name($model_table_info['extend_table_name'])
        ->alias("d")
        ->field('d.id,c.name')
        ->join('arctype c','c.id=d.category_id')
        ->where([['d.category_id', 'in', $typeids], ['d.status', '=', 1]])
        ->page($page,$limit)
        ->order(['d.sort' => 'desc', 'd.id' => 'desc'])
        ->select()
        ->toArray();
        if (!$document) {
            return true;
        }
        $public = !PUBLIC_DIR?'public/':'';
        foreach ($document as $v2) {
            foreach ($seo_city as $v3) {
                $region = Db::name('region')->field('pinyin')->where('id', $v3)->find();
                foreach ($lang_arr as $lang) {
                    $lang = $lang ? $lang . '/' : '';
                    @unlink(PROJECT_PATH . '/' . $public . $lang . $region['pinyin'] . '/' . $v2['name'] . '/' . $v2['id'] . '.' . get_one_cache_config('article_suffix','html'));
                    curl_get(request()->domain() . '/' . $lang . $region['pinyin'] . '/' . $v2['name'] . '/' . $v2['id'] . '.' . get_one_cache_config('article_suffix','html'));
                }
            }
        }
    }
    /**
     * [get_index_lang_arr 获取语言数组]
     * @return [type] [description]
     */
    protected function get_index_lang_arr()
    {
        $lang_arr = array();
        $lang_str = get_one_config('WEB_INDEX_LANG');
        if (!$lang_str) {
            array_push($lang_arr, '');
        } else {
            $lang_arr = explode('|', $lang_str);
            array_unshift($lang_arr, '');
        }
        return $lang_arr;
    }
}
