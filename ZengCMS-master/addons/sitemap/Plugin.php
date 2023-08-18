<?php
namespace addons\sitemap;

use think\Addons;

class Plugin extends Addons
{
    // 该插件的基础信息
    public $info = [
        'name' => 'sitemap',
        'title' => '网站地图',
        'description' => 'sitemap网站地图让搜索引擎对您网站的更快、更完整地进行索引，为您进行网站推广带来极大的方便',
        'status' => 1,
        'author' => 'ZengCMS',
        'require' => '1.0.0',
        'version' => '1.0.0',
        'website' => '',
        'images'=>'addons/sitemap/images/sitemap.jpg',
        'group'=>'',
        'is_hook'=>0,
    ];
    public $menu = [
        'is_nav' => 0,
        'menu' => [
            "title" => '生成网站地图',
            "title_en" => 'Create Site Map',
            'name'=>'admin/cms.Sitemap/index',
            'type'=>1,
            'condition'=>'',
            "status" => 1,
            'show'=>1,
            "icon" =>'bug',
            'remark'=>'',
            "sort" => 50,
        ]
    ];
    /**
     * 插件安装方法
     * @return bool
     */
    public function install()
    {
        return true;
    }
    /**
     * 插件卸载方法
     * @return bool
     */
    public function uninstall()
    {
        return true;
    }
    /**
     * 插件使用方法
     * @return bool
     */
    public function enabled()
    {
        return true;
    }
    /**
     * 插件禁用方法
     * @return bool
     */
    public function disabled()
    {
        return true;
    }
}
