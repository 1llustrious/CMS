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
// | 插件控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\Exception;
use think\facade\Db;
use think\facade\View;
use think\facade\Cache;
use think\facade\Request;
use think\addons\Service;
use app\admin\model\Hooks;
use lemo\helper\FileHelper;
use think\db\exception\PDOException;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="插件管理")
 * Class Addon
 * @package app\admin\controller
 */
class Addon extends Base
{
    /**
     * @NodeAnotation(title="列表")
     */
    public function index()
    {
        $list = get_addons_list();
        // 如果要返回完整数据，并且添加一个索引值的话，可以使用
        // 指定name字段的值作为索引 返回所有数据
        $addons =  Db::name('addon')->order('id desc')->column('*', 'name');
        foreach ($list as $key => $value) {
            // 是否已经安装过
            if (!isset($addons[$key])) {
                $class = get_addons_instance($key);
                $addons[$key] = $class->getInfo();
                $config = $class->getConfig(true);
                $addons[$key]['config'] = $config;
                if ($addons[$key]) {
                    $addons[$key]['install'] = 0;
                    $addons[$key]['status'] = 0;
                }
            } else {
                $addons[$key]['install'] = 1;
                $addons[$key]['config'] = unserialize($addons[$key]['config']);
            }
        }
        $install = trim(input('install'));
		$title = trim(input('title'));
        $list = array();
        foreach($addons as $k=>$v){
            if($install === ''){
                if($title){
                    if(strpos($v['title'],$title) !== false || strpos($v['description'],$title) !== false){
                        $list[$k] = $v;
                    }
                    continue;
                }else{
                    $list[$k] = $v;
                }
            }else{
                if($install == $v['install']){
                    if($title){
                        if(strpos($v['title'],$title) !== false || strpos($v['description'],$title) !== false){
                            $list[$k] = $v;
                        }
                        continue;
                    }else{
                        $list[$k] = $v;
                    }
                }
            }
        }
        $curr = input('page');//当前页面
        $limit = input('limit',10);//每页显示数目
        $currpage = page_array($list, $limit, $curr);//数组分页
        $_list = $currpage['data'];
        View::assign([
            'meta_title'=>'插件列表',
            'install'=>$install,
            'list' => $_list,//分页后列表
            'page' => $currpage['page'],//每页显示数目、总数目、当前页码
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="安装插件")
     */
    public function install()
    {
        $name = input('name');
        // 插件名是否为空
        if (!$name) {
            $this->error(lang('parameter %s can not be empty', ['name']));
        }
        // 插件名是否符合规范
        if (!preg_match("/^[a-zA-Z0-9]+$/", $name)) {
            $this->error(lang('Addon name incorrect'));
        }
        // 检查插件是否安装
        if ($this->isInstall($name)) {
            $this->error(lang('addons %s is already installed', ['name']));
        }
        // Plugin.php
        $class = get_addons_instance($name);
        if (empty($class)) {
            $this->error(lang('addons %s is not ready', ['name']));
        }
        if(request()->isPost()){
            // dump(input('post.'));die;
            // 安装插件Plugin.php的install()
            $install = $class->install();
            // 安装菜单Plugin.php的$menu
            $menu_config=$this->get_menu_config($class);
            if(isset($menu_config['is_nav']) && $menu_config['is_nav']==1){
                if(isset($menu_config['pid'])){
                    $pid = $menu_config['pid'];
                }else{
                    $pid = 0;
                }
            }else{
                $pid = $this->addAddonManager($menu_config);
            }
            if(isset($menu_config['menu'])){
                $menu[] = $menu_config['menu'];
                $this->addAddonMenu($menu,$pid);
            }
            // 添加数据库Plugin.php的$info
            $info = get_addons_info($name);
            $info['status'] = 1;
            // config.php的配置
            $info['config'] =  serialize($class->getConfig(true));
            if(!Db::name('addon')->where('name',$info['name'])->find()){
                $info['create_time'] = time();
                $info['update_time'] = time();
                $res =  Db::name('addon')->strict(false)->insert($info);
                if (!$res) {
                    $this->error(lang('addon install fail'));
                }
            }
            // 是否清除旧数据
            if(input('clear')){
                // 卸载sql;
                uninstallsql($name);
            }
            // install.php
            importsql($name);// 导入数据库
            // 安装演示数据
            if(input('demo')){
                importaddonsql($name,'demo');
            }
            $sourceAssetsDir = Service::getSourceAssetsDir($name);// 插件public
            $destAssetsDir = Service::getDestAssetsDir($name);// 获取插件目标资源文件夹
            if (is_dir($sourceAssetsDir)) {
                // 复制文件到指定文件
                FileHelper::copyDir($sourceAssetsDir, $destAssetsDir);
            }
            // 复制文件到目录 固定app下面的所有
            if(Service::getCheckDirs()){
                foreach (Service::getCheckDirs() as $k => $dir) {
                    $sourcedir = Service::getAddonsNamePath($name). $dir;
                    if (is_dir($sourcedir)) {
                        FileHelper::copyDir($sourcedir, app()->getRootPath() . $dir);
                    }
                }
            }
            try {
                // 更新缓存中插件状态
                Service::updateAddonsInfo($name,1);
                // 更新addons 文件；
                Service::updateAdddonsConfig();
            }catch (\Exception $e){
                $this->error($e->getMessage());
            }
            //更新插件行为实现
            $hooks = new Hooks();
            $hooks_update = $hooks->updateHooks($name);
            if (!$hooks_update) {
                Db::name('addon')->where('name',$name)->delete();
                $this->error('更新钩子处插件失败,请卸载后尝试重新安装！');
            }
            Cache::set('Hooks', null);
            $this->success(lang('Install success'),'index');
            // $this->success('模块安装成功！一键清理缓存后生效！','index');
        }else{
            $info = get_addons_info($name);
            // 版本检查
            if ($info['require']) {
                if (version_compare(ZENGCMS_VERSION, $info['require'], '>=') == false) {
                    $version_check = '<svg class="icon icon-danger" aria-hidden="true">
                    <use xlink:href="#iconcuowu"></use>
                    </svg>';
                } else {
                    $version_check = '<svg class="icon" aria-hidden="true">
                    <use xlink:href="#icongou"></use>
                    </svg>';
                }
            }
            $need_plugin = [];
            $table_check = [];
            // 检查插件依赖
            if (isset($info['need_plugin']) && !empty($info['need_plugin'])) {
                $need_plugin = $this->checkDependence($info['need_plugin']);
            }
            // 检查目录权限
            // 检查数据表
            if (isset($info['tables']) && !empty($info['tables'])) {
                foreach ($info['tables'] as $table) {
                    if (Db::query("SHOW TABLES LIKE '" . config('database.connections.mysql.prefix') . "{$table}'")) {
                        $table_check[] = [
                            'table' => config('database.connections.mysql.prefix') . "{$table}",
                            'result' => '<span class="text-danger">存在同名</span>',
                        ];
                    } else {
                        $table_check[] = [
                            'table' => config('database.connections.mysql.prefix') . "{$table}",
                            'result' => '<svg class="icon" aria-hidden="true">
                            <use xlink:href="#icongou"></use>
                            </svg>',
                        ];
                    }
                }
            }
            View::assign([
                'meta_title'=>'安装插件',
                'need_plugin'=>$need_plugin,
                'version_check'=>$version_check,
                'table_check'=>$table_check,
                'config'=>$info,
            ]);
            return view();
        }
    }
    /**
     * @NodeAnotation(title="卸载插件")
     */
    public function uninstall()
    {
        $name = input("name");
        if (!$name) {
            $this->error(lang('parameter Addon name can not be empty'));
        }
        // 插件名匹配
        if (!preg_match("/^[a-zA-Z0-9]+$/", $name)) {
            $this->error(lang('Addon name is not correct'));
        }
        // 获取插件信息
        $info =  Db::name('addon')->where('name', $name)->find();
        if (empty($info)) {
            $this->error(lang('addon is not exist'));
        }
        if(request()->isPost()){
            if (!Db::name('addon')->where('name', $name)->delete()) {
                $this->error(lang('addon uninstall fail'));
            }
            // 卸载插件
            $class = get_addons_instance($name);
            $uninstall = $class->uninstall();
            // 删除菜单
            $menu_config = $this->get_menu_config($class);
            if(isset($menu_config['menu'])){
                $menu[] = $menu_config['menu'];
                $this->delAddonMenu($menu);
            }
            if(input('clear')){
                // 卸载sql;
                uninstallsql($name);
            }
            // 移除插件基础资源目录
            $destAssetsDir = Service::getDestAssetsDir($name);
            if (is_dir($destAssetsDir)) {
                FileHelper::delDir($destAssetsDir);
            }
            //  获取插件在全局的文件并删除文件app下匹配的
            $list = Service::getGlobalAddonsFiles($name);
            foreach ($list as $k => $v) {
                @unlink(app()->getRootPath() . $v);
            }
            // 更新缓存中的插件状态
            Service::updateAddonsInfo($name,0);
            try {
                // 更新addons 文件；
                Service::updateAdddonsConfig();
            }catch (\Exception $e){
                $this->error($e->getMessage());
            }
            $hooks = new Hooks();
            $hooks_update = $hooks->removeHooks($name);
            if ($hooks_update === false) {
                $this->error = '卸载插件所挂载的钩子数据失败！';
            }
            Cache::set('Hooks', null);
            $this->success(lang('Uninstall successful'),'index');
        }else{
            View::assign([
                'meta_title'=>'卸载插件',
            ]);
            return view();
        }
    }
    /**
     * @NodeAnotation(title="禁启插件")
     */
    public function state()
    {
        $id = input("id");
        $name = input("name");
        if (!$id) {
            $this->error(lang('parameter %s can not be empty', ['id']));
        }
        if (!preg_match("/^[a-zA-Z0-9]+$/", $name)) {
            $this->error(lang('Addon name is not correct'));
        }
        $info =  Db::name('addon')->find($id);
        $info['status'] = $info['status'] == 1 ? 0 : 1;
        // Plugin.php
        $class = get_addons_instance($name);
        if (empty($class)) {
            $this->error(lang('addons %s is not ready', ['name']));
        }
        if($info['status'] == 1){
            $class->enabled();
        }else{
            $class->disabled();
        }
        $info['update_time'] = time();
        if (Db::name('addon')->where('id',$id)->update($info)) {
            // 修改钩子状态
            Db::name('hooks')->where("find_in_set('{$name}',addons)")->update(['status'=>$info['status']]);
            // Plugin.php
            $class = get_addons_instance($name);
            // 菜单Plugin.php的$menu
            $menu_config=$this->get_menu_config($class);
            // 修改菜单状态
            if(isset($menu_config['menu'])){
                $menu[] = $menu_config['menu'];
                $this->update_menu($menu,$info['status']);
            }
            $this->success(lang('edit success'));
        } else {
            $this->error(lang(lang('edit fail')));
        }
    }
    /**
     * @NodeAnotation(title="插件配置")
     */
    public function config()
    {
        if (Request::isPost()) {
            $params = $this->request->post('config/a',[],'trim');
            $name   =  $this->request->get("name");
            $info =  Db::name('addon')->find(input('id'));
            if ($params) {
                $config = @unserialize($info['config']);
                foreach ($config as $k => &$v) {
                    if (isset($params[$k])) {
                        if ($v['type'] == 'array') {
                            // 方法一：
                            /* $arr = [];
                            $params[$k] = is_array($params[$k]) ? $params[$k] :serialize($params[$k]);
                            foreach ($params[$k] as $kk=>$vv){
                                $arr[$vv['key']] =  $vv['value'];
                            }
                            $params[$k] = $arr;
                            $value = $params[$k];
                            $v['content'] = $value; */
                            // 方法二：
                            $arr = [];
                            $params[$k] = is_array($params[$k]) ? $params[$k] :serialize($params[$k]);
                            foreach($params[$k][0] as $k2=>$v2){
                                if($v2){
                                    $arr[$v2] = $params[$k][1][$k2];
                                }
                            }
                            $params[$k] = $arr;
                            $value = $params[$k];
                            $v['content'] = $value;
                        } else {
                            $value = is_array($params[$k]) ? serialize($params[$k]) : $params[$k];
                        }
                        $v['value'] = $value;
                    }
                }
                $config = serialize($config);
                $res = Db::name('addon')->where('id',input('id'))->update(['config'=>$config,'update_time'=>time()]);
                if($res !== false){
                    Service::updateAdddonsConfig();
                    $this->success(lang('edit success'));
                }else{
                    $this->error(lang('edit fail'));
                }
            }
            $this->error(lang('parameter can not be empty'));
        }
        $name = input("name");
        $id = input("id");
        if (!$name) {
            $this->error(lang('addon name can not be empty'));
        }
        if (!preg_match("/^[a-zA-Z0-9]+$/", $name)) {
            $this->error(lang('addon name is not correct'));
        }
        $info =  Db::name('addon')->find($id);
        if (!$info) {
            $this->error(lang('addon config is not found'));
        }
        $info['config'] = $info['config'] ? unserialize($info['config']):get_addons_instance($name)->getConfig(true);
        View::assign([
            "meta_title"=>'插件配置-'.$info['title'],
            "info"=>$info
        ]);
        // 方法一：
        /* $configFile = app()->getRootPath() . 'addons' . DIRECTORY_SEPARATOR . $name . DIRECTORY_SEPARATOR . 'config.html';
        $viewFile = is_file($configFile) ? $configFile : '';
        return view($viewFile); */
        // 方法二：
        $configFile = app()->getRootPath() . 'addons' . DIRECTORY_SEPARATOR . $name . DIRECTORY_SEPARATOR . 'config.html';
        if (is_file($configFile)) {
            View::assign('custom_config', View::fetch($configFile));
        }
        return View::fetch();
    }
    /**
     * @NodeAnotation(title="删除插件")
     */
    public function del()
    {
        $name = input('name');
        // 删除数据
        $res = Db::name('addon')->where('name',$name)->delete();
        rm_dir_files(PROJECT_PATH . '/addons/' .$name);
        // rm_dir_files(PROJECT_PATH . '/runtime'); //删除runtime目录
        // Cache::clear();
        Cache::delete('addonslist');
        return $this->success('删除成功！');
    }
    /**
     * @NodeAnotation(title="上传插件")
     */
    public function local()
    {
        if (!empty($_FILES) && $_FILES['file']['tmp_name']) {
            if (strtolower(substr($_FILES['file']['name'], -3, 3)) != 'zip') {
                $this->error("上传的文件格式有误！");
            }
            $addonName = substr($_FILES['file']['name'],0,strrpos($_FILES['file']['name'] ,"."));
            // 检查插件目录是否存在
            if (is_dir(PROJECT_PATH . '/addons/' . $addonName)) {
                $this->error('该插件目录已经存在！');
            }
            // 上传文件
            $fileSrc = upload('file','addon',0,100,'zip');
            if($fileSrc['code'] == 0){
                $this->error($fileSrc['msg']);
            }
            include_once PROJECT_PATH . '/data/plugins/pclzip/PclZip.php';
            $zip = new \PclZip(STATIC_PATH . '/' . $fileSrc['name']);
            $res = $zip->extract(PCLZIP_OPT_PATH, PROJECT_PATH . '/addons' );
            if ($res === 0) {
                return json(['code'=>0,'msg'=>'解压失败!','url'=>'']);
            }
            @unlink(STATIC_PATH . '/' . $fileSrc['name']);
            $this->clear_cache();
            return json(['code'=>1,'msg'=>'上传成功!','url'=>'']);
        }
        $this->error('请选择上传文件！');
    }
    /**
     * 检查依赖
     * @param array $data 检查数据
     * @return array
     */
    protected function checkDependence($data = [])
    {
        $need = [];
        foreach ($data as $key => $value) {
            if (!isset($value[2])) {
                $value[2] = '=';
            }
            // 当前版本
            $curr_version = Db::name('Addon')->where('name', $value[0])->value('version');
            $result = version_compare($curr_version, $value[1], $value[2]);
            $need[$key] = [
                'plugin' => $value[0],
                'version' => $curr_version ? $curr_version : '未安装',
                'version_need' => $value[2] . $value[1],
                'result' => $result ? '<svg class="icon" aria-hidden="true">
                <use xlink:href="#icongou"></use>
                </svg>' : '<svg class="icon icon-danger" aria-hidden="true">
                <use xlink:href="#iconcuowu"></use>
                </svg>',
            ];
        }
        return $need;
    }
    // 是否安装
    protected function isInstall($name)
    {
        if (empty($name)) {
            return false;
        }
        $addons =  Db::name('addon')->where('name', $name)->find();
        return $addons;
    }
    // 获取菜单配置
    protected function get_menu_config($class)
    {
        $menu = $class->menu;
        return $menu;
    }
    // 添加菜单
    protected function addAddonMenu($menu,$pid = 0)
    {
        foreach ($menu as $k=>$v){
            $hasChild = isset($v['menulist']) && $v['menulist'] ? true : false;
            try {
                $v['pid'] = $pid;
                $v['create_time'] = time();
                $v['update_time'] = time();
                if(strpos(trim($v['name'],'/'),'admin/')===false){
                    $v['name'] = 'admin/'.trim($v['name'],'/');
                }
                if(Db::name('auth_rule')->where('name',$v['name'])->find()){
                    continue;
                }
                $menu_id = Db::name('auth_rule')->strict(false)->insertGetId($v);
                if ($hasChild) {
                    $this->addAddonMenu($v['menulist'], $menu_id);
                }
            } catch (PDOException $e) {
                throw new Exception($e->getMessage());
            }
        }
    }
    // 循环删除菜单
    protected function delAddonMenu($menu)
    {
        foreach ($menu as $k=>$v){
            $hasChild = isset($v['menulist']) && $v['menulist'] ? true : false;
            try {
                if(strpos(trim($v['name'],'/'),'admin/')===false){
                    $v['name'] = 'admin/'.trim($v['name'],'/');
                }
                $menu_rule = Db::name('auth_rule')->where('name',$v['name'])->find();
                if($menu_rule){
                    Db::name('auth_rule')->where('name',$v['name'])->delete();
                    if ($hasChild) {
                        $this->delAddonMenu($v['menulist']);
                    }
                }
                // 隐藏插件管理菜单-不做删除了
                $manager = Db::name('auth_rule')->where('name','admin/Addon/manager')->find();
                if($manager){
                    $manager_child =  Db::name('auth_rule')->where('pid',$manager['id'])->find();
                    if(!$manager_child){
                        Db::name('auth_rule')->where('name','admin/Addon/manager')->update(['show'=>0]);
                    }
                }
            } catch (PDOException $e) {
                throw new Exception($e->getMessage());
            }
        }
    }
    // 添加插件管理菜单
    protected function addAddonManager($menu_config)
    {
        $addon_auth =  Db::name('auth_rule')
        ->where('name','admin/Addon')
        ->cache(3600)
        ->find();
        $data = array(
            "title" => '插件管理',
            "title_en" => 'addonmanager',
            'name'=>'admin/Addon/manager',
            'type'=>1,
            'condition'=>'',
            "pid" => $addon_auth['id'],
            "status" => 1,
            'show'=>1,
            "icon" =>'circle-o',
            'remark'=>'',
            "sort" => 50,
            'create_time'=>time(),
            'update_time'=>time(),
        );
        $manager = Db::name('auth_rule')->where('name','admin/Addon/manager')->find();
        if(!$manager){
            $id = Db::name('auth_rule')->insertGetId($data);
        }elseif($manager and $manager['show'] == 0 && isset($menu_config['menu'])){
            Db::name('auth_rule')->where('id',$manager['id'])->update(['show'=>1,'status'=>1]);
            $id = $manager['id'];
        }else{
            $id = $manager['id'];
        }
        return $id;
    }
    // 修改菜单状态
    protected function update_menu($menu,$status)
    {
        foreach ($menu as $kupdate_menu=>$v){
            $hasChild = isset($v['menulist']) && $v['menulist'] ? true : false;
            try {
                if(strpos(trim($v['name'],'/'),'admin/')===false){
                    $v['name'] = 'admin/'.trim($v['name'],'/');
                }
                $menu_rule = Db::name('auth_rule')->where('name',$v['name'])->find();
                if($menu_rule){
                    Db::name('auth_rule')->where('name',$v['name'])->update(['show'=>$status,'status'=>$status]);
                    if ($hasChild) {
                        $this->update_menu($v['menulist'],$status);
                    }
                }
                // 修改主菜单
                $manager = Db::name('auth_rule')->where('name','admin/Addon/manager')->find();
                if($manager){
                    $manager_child =  Db::name('auth_rule')->where('pid',$manager['id'])->column('show');
                    if(array_sum($manager_child)==0 && $status == 0){
                        $status = 0;
                    }else{
                        $status = 1;
                    }
                    Db::name('auth_rule')->where('name','admin/Addon/manager')->update(['show'=>$status,'status'=>$status]);
                }
            } catch (PDOException $e) {
                throw new Exception($e->getMessage());
            }
        }
    }
}