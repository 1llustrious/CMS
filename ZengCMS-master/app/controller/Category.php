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
// | 栏目控制器
// +----------------------------------------------------------------------
namespace app\controller;

use think\facade\Db;
use think\facade\View;

class Category extends Base
{
    // 详情
    public function index($id = 0)
    {
        // 完全静态 start
        if (!$this->get_config['WEB_CATEGORY_VISIT']) { //静态模式
            $city_ename = input('city', '') ? '/' . input('city') : '';//城市英文
            if (input('page')) { //分页时
                $category_id = get_category_byname(input('id'), 'id');//根据栏目标识获取栏目ID
                $file = VIEW_PATH . LANG_URL_DIR . $city_ename . '/' . input('id') . '/list_' . $category_id . '_' . input('page') . '.' .get_one_cache_config('category_page_suffix','html');
            } else {
                if(get_one_cache_config('category_suffix')){
                    $file = VIEW_PATH . LANG_URL_DIR . $city_ename . '/' . input('id') . '.' .get_one_cache_config('category_suffix');
                }else{
                    $file = VIEW_PATH . LANG_URL_DIR . $city_ename . '/' . input('id') . '/index' . '.html';
                }
            }
            // 如果静态文件是存在，直接渲染
            if (file_exists($file)) {
                return View::fetch($file);
            }
        }
        // 完全静态 end
        // 标识正确性检测
        $id = $id ? $id : input('id', 0);
        if (empty($id)) {
            $this->error('没有指定文档分类！');
        }
        // 根据栏目标识获取当前栏目信息
        $category = get_nav($id);
        // 判断栏目是否存在
        if (empty($category)) {
            $this->error(" <strong>Error 404 </strong>  <br /><br />抱歉，该网页不存在。");
        }
        // 判断是否默认显示第一个子栏目内容
        if (isset($category['isfirst']) && $category['isfirst'] == 1 && $category['pid'] == 0) {
            $AllChildcateIdsArr = getAllChildcateIdsArr($category['id']);
            if (isset($AllChildcateIdsArr[1])) {
                $category = get_nav($AllChildcateIdsArr[1]);
            }
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
        // 获取所有子栏目ID包含自身-相同模型
        $typeids = getAllChildcateIdsArr_same_model($category['id']);
        $where[] = ['d.category_id', 'in', $typeids];
        // 状态
        $where[] = ['d.status', '=', 1];
        // 根据栏目ID获取模型表信息
        $model_table_info = get_document_table_info($category['id']);
        if (!$model_table_info['extend_table_name']) {
            $this->error('栏目所属模型不存在！');
        }
        // 绑定类库标识-绑定分页类
        bind('think\Paginator', get_paging_class_name(LANG_DIR));
        // 地址静态处理
        $pages = input('param.page/d',1);
        $options = [
            'list_rows'=> get_one_cache_config('CATEGORY_PAGE_NUMBER'),
            'var_page' => 'page',
            'page' => $pages,
            'path' => (string)url(LANG_URL_DIR . $pinyin . "/$id/list_" . $category['id'] . "_[PAGE]", [], get_one_cache_config('category_page_suffix','html'), get_one_cache_config('WEB_PATH_PATTERN')?false:true)
        ];
        $order = ['sort' => 'desc', 'd.id' => 'desc']; //排序
        $cache_name = 'category_' . $category['id'] . '_' . $pages;
        if (get_cache($cache_name)) {
            $list = get_cache($cache_name);
        } else {
            $list = Db::name($model_table_info['extend_table_name'])
            ->alias("d")
            ->field('d.*,c.name,c.typename,c.typename_en')
            ->join('arctype c', 'c.id=d.category_id')
            ->where($where)
            ->order($order)
            ->paginate($options)
            ->each(function ($item, $key) {
                // 获取城市信息
                $city = input('city', '');
                $cinfo = '';
                if ($city) {
                    $cinfo = get_city_bypinyin($city);
                }
                // 获取栏目typename
                if ($cinfo && isset($item['typename']) && !strstr($item['typename'], $cinfo["shortname"])) {
                    $item['typename'] = $cinfo['shortname'] . $item['typename'];
                }
                // 获取栏目typename_en
                if ($cinfo && isset($item['typename_en']) && !strstr($item['typename_en'], $cinfo["pinyin"])) {
                    $item['typename_en'] = $cinfo['pinyin'] . ' ' . $item['typename_en'];
                }
                // 获取文档title
                if ($cinfo && isset($item['title']) && !strstr($item['title'], $cinfo["shortname"])) {
                    $item['title'] = $cinfo['shortname'] . $item['title'];
                }
                // 获取文档title_en
                if ($cinfo && isset($item['title_en']) && !strstr($item['title_en'], $cinfo["pinyin"])) {
                    $item['title_en'] = $cinfo['pinyin'] . ' ' . $item['title_en'];
                }
                // 获取栏目typeurl、文档arturl
                if ($cinfo) {
                    // 栏目typeurl
                    if(get_one_cache_config('category_suffix')){
                        $item['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $item['name'], [], get_one_cache_config('category_suffix'), false);
                    }else{
                        $item['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $item['name'] . "/", [], "", false);
                    }
                    // 文档arturl
                    $item['arturl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $item["name"] . "/" . $item['id'], [], get_one_cache_config('article_suffix','html'), false);
                } else {
                    // 栏目typeurl
                    if(get_one_cache_config('category_suffix')){
                        $item['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $item['name'], [], get_one_cache_config('category_suffix'), false);
                    }else{
                        $item['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $item['name']."/", [], "", "");
                    }
                    // 文档arturl
                    $item['arturl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $item["name"] . "/" . $item['id'], [], get_one_cache_config('article_suffix','html'), false);
                }
                return $item;
            });
            $WEB_CACHE_TIME = get_one_config('WEB_CACHE_TIME');
            set_cache($cache_name, $list, $WEB_CACHE_TIME);
        }
        // 留言时用到 防止非法提交留言
        $valicode = md5($this->get_config['WEB_DATA_AUTH_KEY'] . time());
        session('valicode', $valicode);
        View::assign([
            'nav' => $category,//当前栏目信息
            'docList' => $list,//文章列表
            'valicode' => $valicode,//网站秘钥
        ]);
        if ($category && 1 == $category['status']) {
            // TODO  判断显示模式  1列表栏目   2单页栏目   3外部链接
            switch ($category['ispart']) {
                case 1:
                    if (!$list->all()) { //判断文档是否有数据
                        $this->error('暂无数据！');
                    }
                    // 列表模式
                    $tpl = str_replace(array('.html', '.htm', '.tpl'), array('', '', ''), $category['list_template']);
                    $tpl = LANG_URL_DIR . '/' . $tpl;
                    $dt_file_path = config('view.view_path') . $this->get_config['WEB_DEFAULT_THEME'] . $tpl . '.html';//拼接动态文件绝对路径
                    // 判断是动态访问还是静态访问
                    if ($this->get_config['WEB_CATEGORY_VISIT']) { //动态访问
                        return View::fetch($dt_file_path);
                    } else { //静态访问
                        if (input('page')) { //分页时
                            $page = input('page'); //获取分页页码
                            if (!empty($pinyin)) { //判断是否有地区
                                $path = VIEW_PATH . LANG_URL_DIR . $pinyin . '/' . $id . '/';
                            } else {
                                $path = VIEW_PATH . LANG_URL_DIR . '/' . $id . '/';
                            }
                            // 拼接静态文件绝对路径
                            $jt_file_path = $path . 'list_' . $category['id'] . '_' . $page . '.'.get_one_cache_config('category_page_suffix','html');
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
                        } else { //不分页时
                            if (!empty($pinyin)) {//判断是否有地区
                                $path = VIEW_PATH . LANG_URL_DIR . $pinyin . '/' . $id . '/';
                            } else {
                                $path = VIEW_PATH . LANG_URL_DIR . '/' . $id . '/';
                            }
                            // 拼接静态文件绝对路径
                            if(get_one_cache_config('category_suffix')){
                                $jt_file_path = rtrim($path,'/') . '.' .get_one_cache_config('category_suffix');
                            }else{
                                $jt_file_path = $path . 'index.'.get_one_cache_config('category_suffix','html');
                            }
                            if (!is_dir($path)) {
                                mkdir($path, 0777, true);
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
                    break;
                case 2:
                    // 单页模式
                    $tpl = str_replace(array('.html', '.htm', '.tpl'), array('', '', ''), $category['index_template']);
                    $tpl = LANG_URL_DIR . '/' . $tpl;
                    $dt_file_path = config('view.view_path') . $this->get_config['WEB_DEFAULT_THEME'] . $tpl . '.html';//拼接动态文件绝对路径
                    // 判断是动态访问还是静态访问
                    if ($this->get_config['WEB_CATEGORY_VISIT']) { //动态访问
                        return View::fetch($dt_file_path);
                    } else { //静态访问
                        if (input('page')) { //分页时
                            $page = input('page');
                            if (!empty($pinyin)) { //判断是否有地区
                                $path = VIEW_PATH . LANG_URL_DIR . $pinyin . '/' . $id . '/';
                            } else {
                                $path = VIEW_PATH . LANG_URL_DIR . '/' . $id . '/';
                            }
                            // 拼接静态文件绝对路径
                            $jt_file_path = $path . 'list_' . $category['id'] . '_' . $page . '.'.get_one_cache_config('category_page_suffix','html');
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
                        } else { //不分页时
                            if (!empty($pinyin)) { //判断是否有地区
                                $path = VIEW_PATH . LANG_URL_DIR . $pinyin . '/' . $id . '/';
                            } else {
                                $path = VIEW_PATH . LANG_URL_DIR . '/' . $id . '/';
                            }
                            // 拼接静态文件绝对路径
                            if(get_one_cache_config('category_suffix')){
                                $jt_file_path = rtrim($path,'/') . '.' .get_one_cache_config('category_suffix');
                            }else{
                                $jt_file_path = $path . 'index.'.get_one_cache_config('category_suffix','html');
                            }
                            if (!is_dir($path)) {
                                mkdir($path, 0777, true);   
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
                    break;
                case 3:
                    // 跳转模式
                    header('Location:' . $category['typedir']);
                    break;
                default:
                    header('Location:' . '/index.'.get_one_cache_config('index_suffix','html'));
            }
        } else {
            $this->error('分类不存在或被禁用！');
        }
    }
}
