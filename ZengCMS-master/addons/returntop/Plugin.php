<?php
namespace addons\returntop;

use think\Addons;
use app\common\annotation\HooksAnotation;

class Plugin extends Addons
{
    // 该插件的基础信息
    public $info = [
        'name' => 'returntop',
        'title' => '返回顶部',
        'description' => '回到顶部美化，随机或指定显示，100款样式，每天一种换，天天都用新样式',
        'status' => 1,
        'author' => 'ZengCMS',
        'require' => '1.0.0',
        'version' => '1.0.0',
        'website' => "",
        'images'=>'addons/returntop/img/returntop.jpg',
        'group'=>'',
        'is_hook'=>1,
    ];
    public $menu = [
        'is_nav' => 0,
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
    /**
     * @HooksAnotation(description="例：{:hook('PageFooter')}",type="1")
     * @param array('name'=>'表单name','value'=>'表单对应的值')
     */
    public function PageFooter($data)
    {
        // 判断是否安装
        if(!isAddonInstall($this->name)){
            return false;
        }
        $this->assign('addons_data', $data);
        $config = getAddonConfig($this->name);
        if ($config['random']) {
            $config['current'] = rand(1, 99);
        }
        $this->assign('addons_config', $config);
        return $this->fetch('/content');
    }
}
