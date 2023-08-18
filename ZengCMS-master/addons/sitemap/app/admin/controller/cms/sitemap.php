<?php
namespace app\admin\controller\cms;

use think\facade\Db;
use think\facade\View;
use app\admin\controller\Base;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="网站地图管理")
 * Class Sitemap
 * @package app\admin\controller\cms
 */
class Sitemap extends Base
{
    // 初始化
    protected function initialize()
    {
        // 判断插件是否安装
        $addonInfo = getAddonInfo('sitemap');
        if(!$addonInfo || !$addonInfo['status']){
            $this->error($addonInfo?'插件已禁用！':'插件未安装！');
        }
        parent::initialize();
    }
    /**
     * @NodeAnotation(title="生成网站地图")
     */
    public function index()
    {
        $public = !PUBLIC_DIR?'public/':'';
        if (request()->isAjax()) {
            // 更新频率
            $sitemap_changefreq_index = input('sitemap_changefreq_index');//更新首页频率
            $sitemap_changefreq_list = input('sitemap_changefreq_list');//更新列表页频率
            $sitemap_changefreq_view = input('sitemap_changefreq_view');//更新内容页频率
            // 优先级别
            $sitemap_priority_index = input('sitemap_priority_index');//首页优先级
            $sitemap_priority_list = input('sitemap_priority_list');//列表页优先级
            $sitemap_priority_view = input('sitemap_priority_view');//内容页优先级
            $data = [];
            require_once APP_PATH . '/common/addons/libs/mimvp-sitemap-php-master/sitemap.php';
            // 初始化类对象
            $sitemap = new \Sitemap(request()->domain());
            // 设置保存路径
            $sitemap->setXmlFile(PROJECT_PATH . '/' . $public . "sitemap");
            // 设置是否更多头部
            $sitemap->setIsChemaMore(true);
            // 添加Item
            /* $sitemap->addItem('/', '1.0', 'daily', 'Today');
            $sitemap->addItem('/hr.php', '0.8', 'monthly', time());
            $sitemap->addItem('/index.php', '1.0', 'daily', 'Jun 25');
            $sitemap->addItem('/about.php', '0.8', 'monthly', '2017-06-26'); */
            // 首页地图
            $sitemap->addItem('/index.' . get_one_config('index_suffix','html'), $sitemap_priority_index, $sitemap_changefreq_index, time());
            $data[] = request()->domain() . '/index.' . get_one_config('index_suffix','html');
            // 获取所有栏目标识
            $arctype = Db::name('arctype')
            ->field('id,name,ispart,update_time,ispart')
            ->where([['status','=',1],['ispart','in',[1,2]]])
            ->order(['sort'=>'desc','id'=>'asc'])
            ->select()
            ->toArray();
            if ($arctype) {
                // 获取前台语言数组
                $lang_arr = $this->get_index_lang_arr();
                foreach ($arctype as $v) {
                    // 栏目地图
                    foreach ($lang_arr as $lang) {
                        $lang = $lang ? $lang . '/' : '';
                        if(get_one_config('category_suffix')){
                            $sitemap->addItem('/' . $lang . $v['name'] . '.' . get_one_config('category_suffix'), $sitemap_priority_list, $sitemap_changefreq_list, $v['update_time']);
                            $data[] = request()->domain() . '/' . $lang . $v['name'] . '.' . get_one_config('category_suffix');
                        }else{
                            $sitemap->addItem('/' . $lang . $v['name'] . '/', $sitemap_priority_list, $sitemap_changefreq_list, $v['update_time']);
                            $data[] = request()->domain() . '/' . $lang . $v['name'] . '/';
                        }
                    }
                    if ($v['ispart'] == 1) { //栏目属性是列表
                        // 根据栏目ID或标识获取文档表名信息
                        $model_table_info = get_document_table_info($v['id']);
                        if (!$model_table_info['extend_table_name']) {
                            continue;
                        }
                        $model_table = $model_table_info['extend_table_name'];
                        $document = Db::name($model_table)
                        ->field('id,update_time')
                        ->where([['category_id', '=', $v['id']], ['status', '=', 1]])
                        ->order(['sort' => 'desc','update_time'=>'desc','id' => 'desc'])
                        ->limit(input('num',500))
                        ->select()
                        ->toArray();
                        if ($document) {
                            foreach ($document as $v2) {
                                // 文档地图
                                foreach ($lang_arr as $lang) {
                                    $lang = $lang ? $lang . '/' : '';
                                    $sitemap->addItem('/' . $lang . $v['name'] . '/' . $v2['id'] . '.' . get_one_config('article_suffix','html'), $sitemap_priority_view, $sitemap_changefreq_view, $v2['update_time']);
                                    $data[] = request()->domain() . '/' . $lang . $v['name'] . '/' . $v2['id'] . '.' . get_one_config('article_suffix','html');
                                }
                            }
                        }
                    }
                }
            }
            // 结束文档
            $sitemap->endSitemap();
            // 获取当前写入的sitemap文件
            // echo $sitemap->getCurrXmlFileFullPath();
            // xml转html文件
            createXSL2Html($sitemap->getCurrXmlFileFullPath(), APP_PATH . '/common/addons/libs/mimvp-sitemap-php-master/sitemap-xml.xsl',PROJECT_PATH . '/' . $public . 'sitemap.html');
            // 生成txt文件
            if($data){
                $str  = $this->_txt_format($data);
                @file_put_contents(PROJECT_PATH . '/' . $public . 'sitemap.txt', $str);
            }
            // 更新缓存
            $this->clear_cache();
            // 删除所有静态
            $this->clear_static();
            $this->success('更新网站地图成功！');
        }
        if (is_file(PROJECT_PATH . '/' . $public . 'sitemap.xml')) {
            $make_xml_time = date('Y-m-d H:i:s', filemtime(PROJECT_PATH . '/' . $public . 'sitemap.xml'));
            View::assign('make_xml_time', $make_xml_time);
        }
        if (is_file(PROJECT_PATH . '/' . $public . 'sitemap.html')) {
            $make_html_time = date('Y-m-d H:i:s', filemtime(PROJECT_PATH . '/' . $public . 'sitemap.html'));
            View::assign('make_html_time', $make_html_time);
        }
        if (is_file(PROJECT_PATH . '/' . $public . 'sitemap.txt')) {
            $make_txt_time = date('Y-m-d H:i:s', filemtime(PROJECT_PATH . '/' . $public . 'sitemap.txt'));
            View::assign('make_txt_time', $make_txt_time);
        }
        View::assign([
            'meta_title' => '更新网站地图',
        ]);
        return view();
    }
    // 生成txt格式
    private function _txt_format($data)
    {
        $str = '';
        foreach ($data as $val) {
            $str .= $val . PHP_EOL;
        }
        return $str;
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
