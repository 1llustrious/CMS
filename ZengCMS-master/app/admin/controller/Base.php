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
// | 后台基础控制器，其它控制器需继承该继承控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\App;
use tree\Tree;
use auth\Auth;
use think\facade\Db;
use think\facade\View;
use think\facade\Lang;
use app\BaseController;
use think\facade\Cache;
use think\facade\Config;
use think\facade\Request;
use app\common\service\AuthService;
use app\admin\model\Admin as AdminModel;

class Base extends BaseController
{
    // 配置信息(缓存)继承Base控制器用$this->get_config['英文名称'];获取配置信息
    public $get_config = array();
    // 初始化
    protected function initialize()
    // public function __construct(App $app)
    {
        // 获取缓存配置
        // $this->get_config = get_all_config();
        $this->get_config = get_all_cache_config();
        // 模板中用$get_config['英文名称'];获取配置信息
        $get_config = get_all_cache_config();
        // 获取当前应用名
        $m = app('http')->getName();
        // 获取当前访问的控制器
        $c = Request::controller();
        // 获取当前访问的方法
        $a = Request::action();
        // 获取当前登录的管理员ID
        if(!defined('UID')){define('UID', is_login());}
        if (!UID) {
            $no_login_controller = Config::get('setting.no_login_controller');
            $no_login_node = Config::get('setting.no_login_node');
            if (!in_array(lcfirst($c), $no_login_controller) && !in_array(lcfirst($c.'/'.$a), $no_login_node)) {
                abort(401,'未登录！');
            }
        } elseif (UID == -1) { //已在其它地方再次登录
            (new AdminModel())->logout();
            $this->error('已在其它地方再次登录，已强制退出！', (string)url('admin_login'));
        } elseif (UID == -2) { //超过多少时间未做任何操作
            (new AdminModel())->logout();
            $this->error('超过' . get_one_cache_config('NO_OPERATE_TIME') . '秒未做任何操作，已强制退出！', (string)url('admin_login'));
        } elseif (UID == -3) { //用户不存在!
            (new AdminModel())->logout();
            $this->error('此用户不存在！', (string)url('admin_login'));
        } elseif (UID == -4) { //您已被禁止登录！
            (new AdminModel())->logout();
            $this->error('您已被禁止登录！', (string)url('admin_login'));
        }
        // 后台禁止ip访问
        if (get_one_cache_config('WEB_BANNED_IP')) {
            $iplist = str_replace(array("\r\n", "\r", "\n"), ",",get_one_config('WEB_BANNED_IP'));
            if (in_host(get_userip(), $iplist)) {
                if (UID !== 1) {
                    exit('403: You don\'t have permission to access!');
                }
            }
        }
        // 判断是否关闭站点
        if (!get_one_cache_config('WEB_ENABLE_SITE')) {
            // 超超级管理员才能访问
            if (UID !== 1) {
                exit(get_one_cache_config('WEB_CLOSE_SITE_TITLE'));
            }
        }
        // 加载语言包 start
        $controller = $this->request->controller();
        if(strpos($controller,'.') !== false){
            $module = explode('.',$controller)[0];
        }else{
            $module = $controller;
        }
        // echo $this->app->getAppPath() . 'lang'.DIRECTORY_SEPARATOR. Lang::getLangset().DIRECTORY_SEPARATOR. strtolower($module) .'.php';die;
        Lang::load([
            $this->app->getAppPath() . 'lang'.DIRECTORY_SEPARATOR. Lang::getLangset().DIRECTORY_SEPARATOR. strtolower($module).'.php'
        ]);
        // 加载语言包 end
        // 检查auth权限 start
        // 模块/控制器/方法
        $name = $m . '/' . $c . '/' . $a;
        // 检查权限-并获取权限规则
        $rulesArr = $this->check_auth($name);
        // 菜单列表显示
        $menu = $this->menu(0,$rulesArr);
        // 获取选中菜单的家谱
        $parent_menu_id_arr = $this->get_parent_menu_id_arr($name);
        // 检查auth权限 end
        // 检查node节点权限 start
        $currentController = parse_name($c);
        // 权限类型
        $permission_type = get_one_cache_config('PERMISSION_TYPE');
        $no_auth_controller = Config::get('setting.no_auth_controller');
        $no_auth_node = Config::get('setting.no_auth_node');
        $authService = new AuthService(UID);
        $currentNode = $authService->getCurrentNode();
        if (in_array($permission_type,[2,3]) && !in_array($currentController, $no_auth_controller) && !in_array($currentNode, $no_auth_node)) {
            $check = $authService->checkNode($currentNode);
            // !$check && $this->error('无权限访问',(string)url('Index/welcome'));
            !$check && abort(401,'无权限操作！');
            // 判断是否为演示环境
            // if(env('zengcms.is_demo', false) && request()->isPost()){
            if(env('zengcms.is_demo', false) && request()->isAjax()){
                $this->error('演示环境下不允许修改！');
            }
        }
        // 检查node节点权限 end
        View::assign([
            'm' => $m, //当前访问的模块
            'c' => $c, //当前访问的控制器
            'a' => $a, //当前访问的方法
            'get_config' => $get_config, //配置信息
            'menu' => $menu, //菜单显示
            'parent_menu_id_arr' => $parent_menu_id_arr, //获取选中菜单的家谱
            'ZENGCMS_VERSION' => ZENGCMS_VERSION, //系统版本
            'UID' => UID, //管理员ID
        ]);
        parent::initialize();
        // parent::__construct($app);
    }
    /**
     * [check_auth 检查Auth权限]
     * @param  [type] $name [模块/控制器/方法]
     * @param  [type] $m    [模块]
     * @return [type]       [description]
     */
    protected function check_auth($name)
    {
        $auth = new Auth();
        // 根据用户id获取用户组,返回值为数组
        $getGroups = $auth->getGroups(UID);
        // array_column()返回输入数组中某个单一列的值
        $rulesArr = array_column($getGroups, 'rules');
        // 权限类型
        $permission_type = get_one_cache_config('PERMISSION_TYPE');
        // 判断是否为超级管理员，*代表拥有所有权限
        if (in_array($permission_type,[1,3]) && !in_array('*', $rulesArr)) { //不是超级管理员
            // 不需要检查的规则
            $currentController = parse_name(Request::controller());
            $no_auth_controller = Config::get('setting.no_auth_controller');
            $no_auth_node = Config::get('setting.no_auth_node');
            $authService = new AuthService(UID);
            $currentNode = $authService->getCurrentNode();
            if(!in_array($currentController, $no_auth_controller) && !in_array($currentNode, $no_auth_node)){
                // $name为需要验证的规则列表,支持逗号分隔的权限规则或索引数组
                // UID为认证用户的id
                // $type为如果type为1， condition字段就可以定义规则表达式
                // $model为执行check的模式，默认url模式即?号后面参数也校验
                // $relation为如果为 'or' 表示满足任一条规则即通过验证;如果为 'and'则表示需满足所有规则才能通过验证
                if (!$auth->check($name, UID, $type = 1, $mode = 'url', $relation = 'or')) {
                    // $this->error('无权操作！',(string)url('Index/welcome'));
                    abort(401,'无权限操作！');
                }
                // 判断是否为演示环境
                // if(env('zengcms.is_demo', false) && request()->isPost()){
                if(env('zengcms.is_demo', false) && request()->isAjax()){
                    $this->error('演示环境下不允许修改！');
                }
            }
        }
        return $rulesArr;
    }
    /**
     * [get_parent_menu_id_arr 获取选中菜单的家谱]
     * @param  [type] $name [模块/控制器/方法]
     * @return [type]       [description]
     */
    protected function get_parent_menu_id_arr($name)
    {
        static $idsArr;
        $cache_name = 'get_parent_menu_id_arr_' . $name;
        // 读取缓存数据
        if (empty($idsArr)) {
            $idsArr = get_cache($cache_name);
            if ($idsArr) {
                return $idsArr;
            }
        }
        $data = Db::name('auth_rule')->field('id,pid')->select()->toArray();
        $id = Db::name('auth_rule')->where('name',$name)->value('id');
        if ($id) {
            $tree = new Tree();
            $idsArr = $tree->ParentTree($data, $id);
            $idsArr = array_column($idsArr, 'id');
        } else {
            $idsArr = array();
        }
        set_cache($cache_name, $idsArr);
        return $idsArr;
    }
    /**
     * [setStatus 设置一条或者多条数据的状态或删除一条或多条数据的基本信息]
     * @param [type]  $model [表名]
     * @param [type]  $data  [数据]
     * @param integer $type  [类型]
     */
    public function setStatus($model, $data, $type = 1)
    {
        $ids = $data['ids'];
        unset($data['ids']);
        $keyArr = array_keys($data);
        $key = $keyArr[0];
        $valueArr = array_values($data);
        $value = $valueArr[0];
        $tips = array();
        if ($type == 1) {
            $tips[0] = '隐藏成功！';
            $tips[1] = '显示成功！';
        } elseif ($type == 2) {
            $tips[0] = '禁用成功!';
            $tips[1] = '启用成功!';
        } else {
            $tips[0] = '操作成功!';
            $tips[1] = '操作成功!';
        }
        if (empty($ids)) {
            return json(['code'=>0,'msg'=>'请选择要操作的数据！','url'=>'']);
        }
        if (!is_array($ids)) {
            $ids = array(intval($ids));
        }
        foreach ($ids as $k => $v) {
            if ($value == 0 || $value == 1) {
                action_log($v, $model, 2); //记录修改前
                Db::name($model)->where('id',$v)->update([$key => $value]);
                action_log($v, $model, 2); //记录修改后
            } elseif ($value == '-1') {
                action_log($v, $model, 3); //记录删除
                Db::name($model)->where('id',$v)->delete();
            } else {
                $value = '-2'; //参数错误
            }
        }
        switch ($value) {
            case 0:
                return json(['code'=>1,'msg'=>$tips[0],'url'=>'']);
                break;
            case 1:
                return json(['code'=>1,'msg'=>$tips[1],'url'=>'']);
                break;
            case -1:
                return json(['code'=>1,'msg'=>'成功删除！','url'=>'']);
                break;
            default:
                return json(['code'=>0,'msg'=>'参数错误！','url'=>'']);
                break;
        }
    }
    /**
     * [sort 排序]
     * @param  [type] $model [表名]
     * @param  [type] $data  [数据]
     * @return [type]        [json数据]
     */
    public function sort($model, $data)
    {
        foreach ($data['sort'] as $k => $v) {
            $v = intval($v);
            action_log($k, $model, 2); //记录修改前
            Db::name($model)->where('id',$k)->update(['sort' => $v]);
            action_log($k, $model, 2); //记录修改后
        }
        return json(['code'=>1,'msg'=>'排序成功！','url'=>'']);
    }
    /**
     * [menu 获取菜单]
     * @param [type] $type 菜单类型：0：非接口(列表)，1：接口
     * @return void
     */
    public function menu($type=0,$rulesArr=[])
    {
        static $menu;
        $cache_name = 'menu_' . UID;
        // 读取缓存数据
        if (empty($menu)) {
            $menu = get_cache($cache_name);
        }
        if(!$menu){
            if(!$rulesArr){
                // 根据用户id获取用户组,返回值为数组
                $getGroups = (new Auth())->getGroups(UID); 
                $rulesArr = array_column($getGroups, 'rules');
            }
            // 权限类型
            $permission_type = get_one_cache_config('PERMISSION_TYPE');
            if ($permission_type==1 && !in_array('*', $rulesArr)) { //非超级管理员
                $rulesStr = implode(',', $rulesArr); //转为字符串
                $rulesArr = explode(',', $rulesStr); //转为数组
                $rulesArr = array_map('intval', $rulesArr); //把值转为整型
                $rulesArr = array_unique($rulesArr); //去掉重复值
                $map = [
                    ['pid', '=', 0],
                    ['show', '=', 1],
                    ['id', 'in', $rulesArr],
                ];
                $map2 = [
                    ['show', '=', 1],
                    ['id', 'in', $rulesArr],
                ];
            } else { //超级管理员
                $map = [
                    ['pid', '=', 0],
                    ['show', '=', 1],
                ];
                $map2 = [
                    ['show', '=', 1],
                ];
            }
            $order = ['sort' => 'desc', 'id' => 'asc']; //排序
            // 获取一级菜单
            $menu = Db::name('auth_rule')->where($map)->order($order)->select()->toArray();
            foreach ($menu as $k => $v) {
                // 获取二级菜单
                $menu[$k]['children'] = Db::name('auth_rule')->where($map2)->where('pid',$v['id'])->order($order)->select()->toArray();
                foreach ($menu[$k]['children'] as $k2 => $v2) {
                    // 获取三级菜单
                    $menu[$k]['children'][$k2]['children'] = Db::name('auth_rule')->where($map2)->where('pid',$v2['id'])->order($order)->select()->toArray();
                    foreach ($menu[$k]['children'][$k2]['children'] as $k3 => $v3) {
                        // 获取四级菜单
                        $menu[$k]['children'][$k2]['children'][$k3]['children'] = Db::name('auth_rule')->where($map2)->where('pid',$v3['id'])->order($order)->select()->toArray();
                    }
                }
            }
            // 设置缓存
            set_cache($cache_name, $menu);
        }
        // 列表菜单不是接口菜单，直接返回数组数据
        if($type == 0){
            return $menu;
        }
        // 接口菜单
        $_menu = $menu;
        foreach ($_menu as $k => $v) {
            $_menu[$k]['title'] = cookie('think_lang') == 'en-us' ? $v['title_en'] : $v['title'];
            $_menu[$k]['icon'] = 'fa fa-' . $v['icon'];
            $_menu[$k]['href'] = cc_format($v['name']);
            $_menu[$k]['target'] = '_self';
            $_menu[$k]['child'] = $v['children'];
            unset($_menu[$k]['children']);
            if ($_menu[$k]['child']) {
                $_menu[$k]['href'] = '';
                foreach ($_menu[$k]['child'] as $k2 => $v2) {
                    $_menu[$k]['child'][$k2]['title'] = cookie('think_lang') == 'en-us' ? $v2['title_en'] : $v2['title'];
                    $_menu[$k]['child'][$k2]['icon'] = !empty($v2['icon']) ? 'fa fa-' . $v2['icon'] : 'fa fa-navicon';
                    $_menu[$k]['child'][$k2]['href'] = cc_format($v2['name']);
                    $_menu[$k]['child'][$k2]['target'] = '_self';
                    $_menu[$k]['child'][$k2]['child'] = $v2['children'];
                    unset($_menu[$k]['child'][$k2]['children']);
                    if ($_menu[$k]['child'][$k2]['child']) {
                        $_menu[$k]['child'][$k2]['href'] = '';
                        foreach ($_menu[$k]['child'][$k2]['child'] as $k3 => $v3) {
                            $_menu[$k]['child'][$k2]['child'][$k3]['title'] = cookie('think_lang') == 'en-us' ? $v3['title_en'] : $v3['title'];
                            $_menu[$k]['child'][$k2]['child'][$k3]['child'] = $v3['children'];
                            $_menu[$k]['child'][$k2]['child'][$k3]['href'] = cc_format($v3['name']);
                            $_menu[$k]['child'][$k2]['child'][$k3]['icon'] = !empty($v3['icon']) ? 'fa fa-' . $v3['icon'] : 'fa fa-navicon';
                            $_menu[$k]['child'][$k2]['child'][$k3]['target'] = '_self';
                            if ($_menu[$k]['child'][$k2]['child'][$k3]['child']) {
                                $_menu[$k]['child'][$k2]['child'][$k3]['href'] = '';
                                foreach ($_menu[$k]['child'][$k2]['child'][$k3]['child'] as $k4 => $v4) {
                                    $_menu[$k]['child'][$k2]['child'][$k3]['child'][$k4]['title'] = cookie('think_lang') == 'en-us' ? $v4['title_en'] : $v4['title'];
                                    $_menu[$k]['child'][$k2]['child'][$k3]['child'][$k4]['href'] = cc_format($v4['name']);
                                    $_menu[$k]['child'][$k2]['child'][$k3]['child'][$k4]['icon'] = !empty($v4['icon']) ? 'fa fa-' . $v4['icon'] : 'fa fa-navicon';
                                    $_menu[$k]['child'][$k2]['child'][$k3]['child'][$k4]['target'] = '_self';
                                }
                            } else {
                                unset($_menu[$k]['child'][$k2]['child'][$k3]['child']);
                            }
                        }
                    } else {
                        unset($_menu[$k]['child'][$k2]['child']);
                    }
                }
            } else {
                unset($_menu[$k]['child']);
            }
        }
        $new_menu['homeInfo'] = array('title' => cookie('think_lang') == 'en-us' ? 'System Home Page' : '系统主页', 'icon' => 'fa fa-home', 'href' => (string)url('Index/welcome'));
        $new_menu['logoInfo'] = array('title' => cookie('think_lang') == 'en-us' ? ucfirst(app('http')->getName()) : '后台管理', 'image' => Config::get('view.tpl_replace_string.__STATIC__').'/../favicon.ico', 'href' => '');
        $new_menu['menuInfo'] = $_menu;
        return json($new_menu);
    }
    /**
     * [clear_cache 清除所有缓存]
     * @return void
     */
    public function clear_cache()
    {
        // 清除日志的session
        session(is_login().'_log_content', null);
        // 递归清除uploads目录下面的所有空文件夹
        clear_empty_file_dir(PROJECT_PATH . '/public/static/uploads/');
        Cache::store(get_one_cache_config('WEB_CACHE_TYPE'))->clear();
        Cache::clear();
        // 删除runtime目录
        rm_dir_files(PROJECT_PATH . '/runtime/');
        return json(['code' => 1, 'msg' => '清除缓存成功！', 'url' => '']);
    }
    /**
     * [clear_static 清除静态]
     * @return void
     */
    public function clear_static()
    {
        // 获取网站根目录下面的所有文件及文件夹
        $file = getDirContent(PROJECT_PATH.'/public');
        // 不能删除的文件
        $not_del_file = ['.htaccess','favicon.ico',
        'index.php','install.lock','robots.txt','router.php','sitemap.html','sitemap.xml','sitemap.txt'];
        // 不能删除的文件夹
        $not_del_file_folder = ['install','static'];
        $prefix = PROJECT_PATH.'/public';
        foreach($file as $k=>$v){
            if(is_file($prefix.'/'.$v) && !in_array($v,$not_del_file)){
                @unlink($prefix.'/'.$v);
            }else if(is_dir($prefix.'/'.$v) && !in_array($v,$not_del_file_folder)){
                rm_dir_files($prefix.'/'.$v);
            }
        }
        sleep(1);
        // 获取网站根目录下面的所有文件及文件夹
        $file = getDirContent(PROJECT_PATH);
        // 不能删除的文件
        $not_del_file = ['.htaccess','.env','.gitignore','.htaccess','.travis.yml','composer.json','composer.lock','favicon.ico',
        'index.php','install.lock','LICENSE','README.md','robots.txt','sitemap.html','sitemap.xml','sitemap.txt','think'];
        // 不能删除的文件夹
        $not_del_file_folder = ['.git','addons','app','config','data','extend','install','public',
        'route','runtime','vendor','view'];
        $prefix = PROJECT_PATH;
        foreach($file as $k=>$v){
            if(is_file($prefix.'/'.$v) && !in_array($v,$not_del_file)){
                @unlink($prefix.'/'.$v);
            }else if(is_dir($prefix.'/'.$v) && !in_array($v,$not_del_file_folder)){
                rm_dir_files($prefix.'/'.$v);
            }
        }
        return json(['code' => 1, 'msg' => '清除静态成功！', 'url' => '']);
    }
    /**
     * [ajaxGetCity 获取城市]
     * @return void
     */
    public function ajaxGetCity()
    {
        if (request()->isAjax()) {
            $id = input('id');
            $type = input('type');
            $data = Db::name('region')
            ->field('id,name')
            ->where('pid' , $id)
            ->where('leveltype' , $type)
            ->select()
            ->toArray();
            return json($data);
        }
    }
    /**
     * [get_city 根据省获取城市]
     * @return void
     */
    public function get_city()
    {
        if (request()->isAjax()) {
            $pid = input('pid', '100000');
            $parent_id[] = ['pid', '=', $pid];
            $region = Db::name('region')
            ->field('id,shortname,pid')
            ->where($parent_id)
            ->select()
            ->toArray();
            config('logs.admin/Common/get_city', '根据省获取城市');
            if (request()->isAjax()) {
                return json($region);
            } else {
                return $region;
            }
        } else {
            config('logs.admin/Common/get_city', '根据省获取城市-' . '非法操作！');
            return json(['code'=>0,'msg'=>'非法操作！','url'=>'']);
        }
    }
}
