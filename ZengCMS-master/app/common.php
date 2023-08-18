<?php
/**
 * 系统公共模块，主要定义系统公共函数
 * ==============================================
 *  ZengCMS内容管理系统
 * ----------------------------------------------
 * Copyright  (C)  2020  http://www.zengcms.cn
 * ==============================================
 * @date: 2020-10-23
 * @author: zeng
 * @version: v1.0.1
 */
use tree\Tree;
use think\facade\Db;
use think\facade\App;
use think\facade\Cache;
use think\facade\Config;
use think\facade\Request;
use uploadtool\UploadTool;
// 版本号
const ZENGCMS_VERSION = '1.0.0';
// 新版本号
const NEW_ZENGCMS_VERSION = 'new@1.0.0';
// 获取项目名称等信息
$project_arr = get_project_dir();
// 定义项目名称
define('PROJECT_NAME', basename(str_replace('/app', '', str_replace('\\', '/', __DIR__))));
// 定义EXTRA_DIR用于静态文件路径拼凑
define('EXTRA_DIR', $project_arr['extra_dir']);
// 定义PUBLIC_DIR用于静态文件路径拼凑
define('PUBLIC_DIR', $project_arr['public_dir']);
// 定义项目根路径
define('PROJECT_PATH', str_replace('/app', '', str_replace('\\', '/', __DIR__)));
define('ROOT_PATH', str_replace('/app', '', str_replace('\\', '/', __DIR__)));
define('APP_PATH', str_replace('\\', '/', __DIR__));
define('ADDONS_PATH', str_replace('/app', '', str_replace('\\', '/', __DIR__)) . '/addons');
define('PUBLIC_PATH', str_replace('/app', '', str_replace('\\', '/', __DIR__)) . '/public');
define('STATIC_PATH', str_replace('/app', '', str_replace('\\', '/', __DIR__)) . '/public/static');
// 动态获取项目目录信息
function get_project_dir()
{
    if (stripos($_SERVER['DOCUMENT_ROOT'], 'public') !== false && rtrim($_SERVER['DOCUMENT_ROOT'], '/') == rtrim(str_replace('\\', '/', getcwd()), '/')) {
        // 说明网站目录指向tp默认入口文件所在public目录下
        $extra_dir = '';
        $public_dir = '';
    } else {
        if (rtrim(str_replace('\\', '/', getcwd()), '/') == rtrim($_SERVER['DOCUMENT_ROOT'], '/')) {
            // 说明网站目录指向app所在同级目录下
            $extra_dir = '';
            $public_dir = '/public';
        } elseif (str_replace(rtrim($_SERVER['DOCUMENT_ROOT'], '/'), '', rtrim(str_replace('\\', '/', getcwd()), '/')) == '/public') {
            // 说明网站目录指向app所在同级目录下 但通过public目录下的入口文件访问
            $extra_dir = '/public';
            $public_dir = '';
        } else {
            // 说明网站目录指向app所在目录的上级或上上级
            $arr = explode(DIRECTORY_SEPARATOR, rtrim(getcwd(), DIRECTORY_SEPARATOR));
            $end = end($arr);
            if ($end == 'public') {
                // 说明网站目录指向app所在目录的上级或上上级 但通过public目录下的入口文件访问
                $extra_dir = str_replace(rtrim($_SERVER['DOCUMENT_ROOT'], '/'), '', rtrim(str_replace('\\', '/', getcwd()), '/'));
                $public_dir = '';
            } else {
                $extra_dir = str_replace(rtrim($_SERVER['DOCUMENT_ROOT'], '/'), '', rtrim(str_replace('\\', '/', getcwd()), '/'));
                $public_dir = '/public';
            }
        }
    }
    $project_arr['extra_dir'] = $extra_dir;
    $project_arr['public_dir'] = $public_dir;
    return $project_arr;
}
/**
 * 检测用户是否登录
 * @return integer 0-未登录，大于0-当前登录用户ID
 */
function is_login()
{
    // 记住密码
    if(cookie('admin_auth_cookie')){
        $admin_auth_cookie = think_decrypt(cookie('admin_auth_cookie'));
        if($admin_auth_cookie){
            $admin_auth = unserialize($admin_auth_cookie);
            if(is_array($admin_auth) && isset($admin_auth['uid'])){
                session('admin_auth',$admin_auth);
            }
        }
    }
    $user = session('admin_auth');
    if (empty($user)) { //未登陆
        return 0;
    } else {
        $admin = Db::name('admin')->field('random_number,status')->where('id', $user['uid'])->find();
        if (!$admin) {
            return -3; //用户不存在
        }
        if (!$admin['status']) {
            return -4; //用户已被禁止登录
        }
        if ($admin['random_number'] !== $user['random_number']) {
            return -1; //在其它地方再登录
        }
        if (!think_decrypt($user['online_state'])) {
            return -2; //超过规定时间未做任何操作
        } else {
            $user['online_state'] = think_encrypt($user['username'], '', get_one_config('NO_OPERATE_TIME'));
            /* //记住密码
            if($user['rememberMe']){
                $day = get_one_cache_config('WEB_ADMIN_REMEMBER_ME');
                $time = $day*24*60*60;
                cookie('admin_auth_cookie',think_encrypt(serialize($user)),$time);
            }else{
                session('admin_auth', $user);
            } */
            session('admin_auth', $user);
        }
        return $user ? $user['uid'] : 0;
    }
}
/**
 * [is_super_administrator 根据管理员ID检查管理员是否为超级管理员]
 * @param  [type]  $uid [description]
 * @return boolean      [description]
 */
function is_super_administrator($uid)
{
    // 根据管理员ID获取用户组明细表信息即用户组ID
    $groupAccessRes = Db::name('auth_group_access')->field('group_id')->where(['uid' => $uid])->select()->toArray();
    // 获取用户组ID数组
    $groupIdArr = array_column($groupAccessRes, 'group_id');
    $map[] = ['id', 'in', $groupIdArr];
    // 根据用户组ID获取所有规则ID字符串
    $authGroupRes = Db::name('auth_group')->field('rules')->where($map)->select()->toArray();
    // 规则ID字符串数组
    $rulesArr = array_column($authGroupRes, 'rules');
    // 数组拆分成字符串
    $rulesStr = implode(',', $rulesArr);
    // 字符串拆分成数组
    $rulesArr = explode(',', $rulesStr);
    if (in_array('*', $rulesArr)) {
        return true;//超级管理员
    } else {
        return false;//非超级管理员
    }
}
/**
 * 记录日志
 * @param  $pk 表主键自增id值
 * @param  $table_name ;表名称
 * @param  $type 操作类型；1：新增；2：修改；3：删除
 */
function action_log($table_pk_id, $table_name, $type)
{
    if (!get_one_cache_config('is_record_operation_log')) {
        // 判断是否记录操作日志
        return;
    }
    $table_name = strtolower($table_name);//大写转小写
    $admin_ip = get_userip();//管理员ip
    $admin_id = is_login();//管理员id
    $prefix = config('database.connections.mysql.prefix');//表前缀
    $tableName = $prefix . $table_name;//加前缀的表名
    if ($type == 1 || $type == 3) {
        // 新增、删除操作
        // 查询表注释
        $tableInfoRes = Db::query('show table status where name = "' . $tableName . '"');
        $tableInfoRes = array_map('array_change_key_case', $tableInfoRes);//将数组的键转换为小写字母。
        // 插入日志主表
        $data['admin_ip'] = $admin_ip;
        $data['admin_id'] = $admin_id;
        $data['type'] = $type;
        $data['table_pk_id'] = $table_pk_id;
        $data['table_name'] = $table_name;
        $data['comment'] = $tableInfoRes[0]['comment'];
        $data['status'] = 0;
        $data['dtime'] = time();
        $log_id = Db::name('log')->insertGetId($data);
        // 查询字段注释和字段数据类型
        $fieldInfoRes = Db::query('show full columns from ' . $tableName);
        $fieldInfoRes = array_map('array_change_key_case', $fieldInfoRes);//将数组的键转换为小写字母。
        foreach ($fieldInfoRes as $k => $v) {
            $fieldCommentArray[$v['field']] = $v['comment'];//字段注释
        }
        foreach ($fieldInfoRes as $k => $v) {
            $fieldTypeArray[$v['field']] = $v['type'];//字段数据类型
        }
        // 查询所有字段信息，插入日志从表
        $res = Db::name($table_name)->find($table_pk_id);
        $fields = array_keys($res);
        $values = array_values($res);
        for ($i = 0; $i < count($fields); $i++) {
            $data2['log_id'] = $log_id;
            $data2['field_name'] = $fields[$i];
            $data2['field_type'] = $fieldTypeArray[$fields[$i]];
            $data2['field_value'] = $values[$i];
            $data2['comment'] = $fieldCommentArray[$fields[$i]];
            Db::name('log_content')->insert($data2);
        }
    } elseif ($type == 2) {
        // 修改操作
        if (!session($admin_id.'_log_content')) {
            // 查询表注释
            $tableInfoRes = Db::query('show table status where name = "' . $tableName . '"');
            $tableInfoRes = array_map('array_change_key_case', $tableInfoRes);//将数组的键转换为小写字母。
            // 插入日志主表
            $data['admin_ip'] = $admin_ip;
            $data['admin_id'] = $admin_id;
            $data['type'] = $type;
            $data['table_pk_id'] = $table_pk_id;
            $data['table_name'] = $table_name;
            $data['comment'] = $tableInfoRes[0]['comment'];
            $data['status'] = 0;
            $data['dtime'] = time();
            $log_id = Db::name('log')->insertGetId($data);
            // 查询修改前数据信息
            $res = Db::name($table_name)->find($table_pk_id);
            $fields = array_keys($res);
            $values = array_values($res);
            $log_content['log_id'] = $log_id;
            $log_content['fields'] = $fields;
            $log_content['values'] = $values;
            session($admin_id.'_log_content', $log_content);
        } else {
            // 查询字段注释和字段数据类型
            $fieldInfoRes = Db::query('show full columns from ' . $tableName);
            $fieldInfoRes = array_map('array_change_key_case', $fieldInfoRes);//将数组的键转换为小写字母。
            foreach ($fieldInfoRes as $k => $v) {
                $fieldCommentArray[$v['field']] = $v['comment'];//字段注释
            }
            foreach ($fieldInfoRes as $k => $v) {
                $fieldTypeArray[$v['field']] = $v['type'];//字段数据类型
            }
            // 查询修改后数据信息
            $res = Db::name($table_name)->find($table_pk_id);
            $current_values = array_values($res);
            // 获取修改前数据信息
            $log_content = session($admin_id.'_log_content');
            $log_id = $log_content['log_id'];
            $fields = $log_content['fields'];
            $values = $log_content['values'];
            // 前后信息进行比较
            for ($i = 0; $i < count($current_values); $i++) {
                if ($values[$i] !== $current_values[$i]) {
                    $data['log_id'] = $log_id;
                    $data['field_name'] = $fields[$i];
                    $data['field_type'] = $fieldTypeArray[$fields[$i]];
                    $data['field_value'] = $values[$i];
                    $data['current_field_value'] = $current_values[$i];
                    $data['comment'] = $fieldCommentArray[$fields[$i]];
                    Db::name('log_content')->insert($data);
                }
            }
            session($admin_id.'_log_content', null);
        }
    }
}
/**
 * [get_one_config 根据配置英文名称获取单个配置信息]
 * @param  [type] $ename   [英文名称]
 * @param  [type] $default [默认值]
 * @return [type]        [description]
 */
function get_one_config($ename,$default = '')
{
    $config = Db::name('config')->field('value')->where(['ename' => $ename])->find();
    if ($config) {
        return $config['value'];
    } else {
        return $default;
    }
}
/**
 * [Description 获取所有配置信息]
 * @return void
 */
function get_all_config()
{
    $configRes = array();
    $_configRes = Db::name('config')->field('ename,value')->select()->toArray();
    foreach ($_configRes as $k => $v) {
        $configRes[$v['ename']] = $v['value'];
    }
    return $configRes;
}
/**
 * [get_one_cache_config 根据配置英文名称获取单个缓存配置信息]
 * @param  [type] $name    [英文名称]
 * @param  [type] $default [默认值]
 * @return [type] [description]
 */
function get_one_cache_config($ename,$default = "")
{
    // 第一种方案：
    /* $configRes = get_all_cache_config();
    return isset($configRes[$ename])?$configRes[$ename]:''; */
    // 第二种方案：
    $cache_name = 'get_one_cache_config_' . strtolower($ename);
    $value = Cache::get($cache_name);
    if ($value) {
        return $value;
    }
    $prefix = Config::get('database.connections.mysql.prefix'); //获取表前缀
    $table_name = $prefix . 'config';
    $config = Db::query("select value from {$table_name} where ename='{$ename}'");
    if (!isset($config[0])) {
        exit($ename . '参数不正确！');
    }
    $value = $config[0]['value'];
    if (get_one_config('WEB_ENABLE_CACHE')) {
        Cache::set($cache_name, $value, get_one_config('WEB_CACHE_TIME'));
    }
    if(!$value){
        return $default;
    }
    return $value;
}
/**
 * [Description 获取所有缓存配置信息]
 * @return void
 */
function get_all_cache_config()
{
    $configRes = Cache::get('get_all_cache_config');
    if ($configRes) {
        return $configRes;
    } else {
        $_configRes = Db::name('config')->field('ename,value')->select()->toArray();
        foreach ($_configRes as $k => $v) {
            $configRes[$v['ename']] = $v['value'];
        }
        if (get_one_config('WEB_ENABLE_CACHE')) {
            Cache::set('get_all_cache_config', $configRes, get_one_config('WEB_CACHE_TIME'));
        }
        return $configRes;
    }
}
/**
 * [is_cache 判断是否要开启缓存]
 * @return boolean [description]
 */
function is_cache()
{
    if (get_one_cache_config('WEB_ENABLE_CACHE')) {
        return true;
    }
    return false;
}
/**
 * [set_cache 设置缓存]
 * @param [type]  $name    [缓存名称]
 * @param [type]  $value   [缓存内容]
 * @param integer $time    [缓存时间，默认为0即永久]
 */
function set_cache($name, $value, $time = 0)
{
    if(!get_one_config('WEB_ENABLE_CACHE')){
        return false;
    }
    $time = $time ? $time : (int)get_one_cache_config('WEB_CACHE_TIME');
    if($time == 0){
        $result = Cache::store(get_one_cache_config('WEB_CACHE_TYPE'))->set($name,$value);
    }else{
        $result = Cache::store(get_one_cache_config('WEB_CACHE_TYPE'))->set($name,$value,$time);
    }
    if (!$result) {
        return false;
    }
    return true;
}
/**
 * [Description 获取缓存]
 * @param [type] $name 缓存名称
 * @return void
 */
function get_cache($name)
{
    return Cache::store(get_one_cache_config('WEB_CACHE_TYPE'))->get($name);
}
/**
 * [Description 系统非常规MD5加密方法]
 * @param [type] $str 要加密的字符串
 * @param string $key 秘钥key
 * @return void
 */
function md6($str, $key = '')
{
    return $str === '' ? '' : md5(md5(sha1($str)) . (!empty($key) ? md5(md5($key)) : ''));
}
/**
 * [encryption cookie加密和解密算法]
 * @param [type] $value 加密的字符串不能是纯数字要加双冒号或双单冒号
 * @param integer $type 类型type：0：加密；1：解密
 * @return void
 */
function encryption($value, $type = 0)
{
    $key = md5(md5(get_one_cache_config('WEB_DATA_AUTH_KEY')));
    if ($type == 0) { //加密
        return str_replace('=', '', base64_encode($value ^ $key)); //先加密后去掉=等号
    } else { //解密
        $value = base64_decode($value);
        return $value ^ $key;
    }
}
/**
 * 系统加密方法
 * @param string $string 要加密的字符串
 * @param string $key 加密密钥
 * @param int $expire 过期时间 单位 秒
 * @return string
 */
function think_encrypt($string, $key = '', $expiry = 0)
{
    // 动态密匙长度，相同的明文会生成不同密文就是依靠动态密匙
    $ckey_length = 0;
    // 密匙
    $key = sha1(md5(empty($key) ? get_one_cache_config('WEB_DATA_AUTH_KEY') : $key));
    // 密匙a会参与加解密
    $keya = sha1(md5(substr($key, 0, 16)));
    // 密匙b会用来做数据完整性验证
    $keyb = sha1(md5(substr($key, 16, 16)));
    // 密匙c用于变化生成的密文
    $keyc = $ckey_length ? substr(md5(microtime()), -$ckey_length) : '';
    // 参与运算的密匙
    $cryptkey = $keya . md5($keya . $keyc);
    $key_length = strlen($cryptkey);
    // 明文，前10位用来保存时间戳，解密时验证数据有效性，10到26位用来保存$keyb(密匙b)，解密时会通过这个密匙验证数据完整性
    // 如果是解码的话，会从第$ckey_length位开始，因为密文前$ckey_length位保存 动态密匙，以保证解密正确
    $string = sprintf('%010d', $expiry ? $expiry + time() : 0) . substr(md5($string . $keyb), 0, 16) . $string;
    $string_length = strlen($string);
    $result = '';
    $box = range(0, 255);
    $rndkey = array();
    // 产生密匙簿
    for ($i = 0; $i <= 255; $i++) {
        $rndkey[$i] = ord($cryptkey[$i % $key_length]);
    }
    // 用固定的算法，打乱密匙簿，增加随机性，好像很复杂，实际上对并不会增加密文的强度
    for ($j = $i = 0; $i < 256; $i++) {
        $j = ($j + $box[$i] + $rndkey[$i]) % 256;
        $tmp = $box[$i];
        $box[$i] = $box[$j];
        $box[$j] = $tmp;
    }
    // 核心加解密部分
    for ($a = $j = $i = 0; $i < $string_length; $i++) {
        $a = ($a + 1) % 256;
        $j = ($j + $box[$a]) % 256;
        $tmp = $box[$a];
        $box[$a] = $box[$j];
        $box[$j] = $tmp;
        // 从密匙簿得出密匙进行异或，再转成字符
        $result .= chr(ord($string[$i]) ^ ($box[($box[$a] + $box[$j]) % 256]));
    }
    return $keyc . str_replace(array('+', '/', '='), array('-', '_', ''), base64_encode($result));
}
/**
 * 系统解密方法
 * @param  string $string 要解密的字符串 （必须是think_encrypt方法加密的字符串）
 * @param  string $key 加密密钥
 * @return string
 */
function think_decrypt($string, $key = '')
{
    // 动态密匙长度，相同的明文会生成不同密文就是依靠动态密匙
    $ckey_length = 0;
    // 密匙
    $key = sha1(md5(empty($key) ? get_one_cache_config('WEB_DATA_AUTH_KEY') : $key));
    $string = str_replace(array('-', '_'), array('+', '/'), $string);
    // 密匙a会参与加解密
    $keya = sha1(md5(substr($key, 0, 16)));
    // 密匙b会用来做数据完整性验证
    $keyb = sha1(md5(substr($key, 16, 16)));
    // 密匙c用于变化生成的密文
    $keyc = $ckey_length ? substr($string, 0, $ckey_length) : '';
    // 参与运算的密匙
    $cryptkey = $keya . md5($keya . $keyc);
    $key_length = strlen($cryptkey);
    // 明文，前10位用来保存时间戳，解密时验证数据有效性，10到26位用来保存$keyb(密匙b)，解密时会通过这个密匙验证数据完整性
    // 如果是解码的话，会从第$ckey_length位开始，因为密文前$ckey_length位保存 动态密匙，以保证解密正确
    $string = base64_decode(substr($string, $ckey_length));
    $string_length = strlen($string);
    $result = '';
    $box = range(0, 255);
    $rndkey = array();
    // 产生密匙簿
    for ($i = 0; $i <= 255; $i++) {
        $rndkey[$i] = ord($cryptkey[$i % $key_length]);
    }
    // 用固定的算法，打乱密匙簿，增加随机性，好像很复杂，实际上对并不会增加密文的强度
    for ($j = $i = 0; $i < 256; $i++) {
        $j = ($j + $box[$i] + $rndkey[$i]) % 256;
        $tmp = $box[$i];
        $box[$i] = $box[$j];
        $box[$j] = $tmp;
    }
    // 核心加解密部分
    for ($a = $j = $i = 0; $i < $string_length; $i++) {
        $a = ($a + 1) % 256;
        $j = ($j + $box[$a]) % 256;
        $tmp = $box[$a];
        $box[$a] = $box[$j];
        $box[$j] = $tmp;
        // 从密匙簿得出密匙进行异或，再转成字符
        $result .= chr(ord($string[$i]) ^ ($box[($box[$a] + $box[$j]) % 256]));
    }
    if ((substr($result, 0, 10) == 0 || substr($result, 0, 10) - time() > 0) && substr($result, 10, 16) == substr(md5(substr($result, 26) . $keyb), 0, 16)) {
        return substr($result, 26);
    } else {
        return '';
    }
}
/**
 * [Description 递归创建目录]
 * @param [type] $dir
 * @return void
 */
function mk_dirs($dir)
{
    if(!is_dir($dir)){
        if(!mk_dirs(dirname($dir))){
            return false;
        }
        if(!mkdir($dir,0777)){
            return false;
        }
    }
    return true;
}
/**
 * [Description 递归清空空文件夹]
 * @param [type] $path
 * @return void
 */
function clear_empty_file_dir($path)
{
    // 方案一：
    if (is_dir($path) && ($handle = opendir($path)) !== false) {
        while (($file = readdir($handle)) !== false) { // 遍历文件夹 
            if ($file != '.' && $file != '..') {
                $curfile = $path . '/' . $file; // 当前目录 
                if (is_dir($curfile)) { // 目录 
                    clear_empty_file_dir($curfile); // 如果是目录则继续遍历 
                    if (count(scandir($curfile)) == 2) { //目录为空,=2是因为.和..存在
                        @rmdir($curfile); // 删除空目录 
                    }
                }
            }
        }
        closedir($handle);
    }
    // 方案二：
    /* if (!is_dir($path)) {
        return false;
    }
    $dh = opendir($path);
    while (($row = readdir($dh)) !== false) {
        if ($row == '.' || $row == '..') {
            continue;
        }
        if (is_dir($path . '/' . $row)) {
            clear_empty_file_dir($path . '/' . $row);
            if (count(scandir($path . '/' . $row)) == 2) {
                @rmdir($path . '/' . $row);
            }
        }
    }
    closedir($dh);
    return true; */
}
/**
 * 获取某目录下所有子文件和子目录
 */
function getDirContent($path)
{
    if(!is_dir($path)){
        return false;
    }
    //readdir方法
    /* $dir = opendir($path);
    $arr = array();
    while($content = readdir($dir)){
        if($content != '.' && $content != '..'){
        $arr[] = $content;
        }
    }
    closedir($dir); */

    //scandir方法
    $arr = array();
    $data = scandir($path);
    foreach ($data as $value){
        if($value != '.' && $value != '..'){
        $arr[] = $value;
        }
    }
    return $arr;
}
/**
 * [rm_dir_files 删除目录及目录下所有文件]
 * @param  [type] $indir [目录路径]
 * @return [type]        [description]
 */
function rm_dir_files($indir)
{
    if (!is_dir($indir)) {
        return false;
    }
    $dh = dir($indir);
    while ($infile = $dh->read()) { //.或..
        if ($infile == "." || $infile == "..") {
            continue;
        } else if (is_file($indir . "/" . $infile)) { //文件
            @unlink($indir."/".$infile);
        } else { //目录
            rm_dir_files($indir . "/" . $infile);
        }
    }
    $dh->close();
    // 删除空根目录
    if (count(scandir($indir)) == 2) {
        @rmdir($indir);
    }
    return true;
}
/**
 * select返回的数组进行整数映射转换
 * @param array $map 映射关系二维数组  
 * array(
 *    '字段名1'=>array(映射关系数组),
 *    '字段名2'=>array(映射关系数组),
 *    ......
 * )
 * @return array
 * array(
 *    array('id'=>1,'title'=>'标题','status'=>'1','status_text'=>'正常')
 *    ....
 * )
 */
//对二维数组起作用
function int_to_string2(&$data, $map = array('status' => array(1 => '正常', -1 => '删除', 0 => '<span class="text-warning">禁用</span>', 2 => '未审核', 3 => '草稿')))
{
    if ($data === false || $data === null) {
        return $data;
    }
    $data = (array) $data;
    foreach ($data as $key => $row) {
        foreach ($map as $col => $pair) {
            if (isset($row[$col]) && isset($pair[$row[$col]])) {
                $data[$key][$col . '_text'] = $pair[$row[$col]];
            }
        }
    }
    return $data;
}
// 对一维数组起作用
function int_to_string(&$data, $map = array('status' => array(1 => '正常', -1 => '删除', 0 => '<span class="text-warning">禁用</span>', 2 => '未审核', 3 => '草稿')))
{
    if ($data === false || $data === null) {
        return $data;
    }
    $data = (array) $data;
    foreach ($map as $col => $pair) {
        if (isset($data[$col]) && isset($pair[$data[$col]])) {
            $data[$col . '_text'] = $pair[$data[$col]];
        }
    }
    return $data;
}
/**
 * [Description 字符串截取]
 * @param [type] $sourcestr 要截取的字符串
 * @param [type] $cutlength 截取长度
 * @return void
 */
function cut_str($sourcestr, $cutlength)
{
    $returnstr = '';
    $i = 0;
    $n = 0;
    $str_length = strlen($sourcestr); //字符串的字节数
    while (($n < $cutlength) and ($i <= $str_length)) {
        $temp_str = substr($sourcestr, $i, 1);
        $ascnum = Ord($temp_str); //得到字符串中第$i位字符的ascii码
        if ($ascnum >= 224) //如果ASCII位高与224，
        {
            $returnstr = $returnstr . substr($sourcestr, $i, 3); //根据UTF-8编码规范，将3个连续的字符计为单个字符
            $i = $i + 3; //实际Byte计为3
            $n++; //字串长度计1
        } elseif ($ascnum >= 192) //如果ASCII位高与192，
        {
            $returnstr = $returnstr . substr($sourcestr, $i, 2); //根据UTF-8编码规范，将2个连续的字符计为单个字符
            $i = $i + 2; //实际Byte计为2
            $n++; //字串长度计1
        } elseif ($ascnum >= 65 && $ascnum <= 90) //如果是大写字母，
        {
            $returnstr = $returnstr . substr($sourcestr, $i, 1);
            $i = $i + 1; //实际的Byte数仍计1个
            $n++; //但考虑整体美观，大写字母计成一个高位字符
        } else //其他情况下，包括小写字母和半角标点符号，
        {
            $returnstr = $returnstr . substr($sourcestr, $i, 1);
            $i = $i + 1; //实际的Byte数计1个
            $n = $n + 0.5; //小写字母和半角标点等与半个高位字符宽...
        }
    }
    if ($str_length > $i) {
        $returnstr = $returnstr . "..."; //超过长度时在尾处加上省略号
    }
    return $returnstr;
}
/**
 * [Description 截取字符串长度]
 * @param [type] $str
 * @param integer $start
 * @param [type] $length
 * @param string $charset
 * @param boolean $suffix
 * @return void
 */
function msubstr($str, $start = 0, $length, $charset = "utf-8", $suffix = true)
{
    if (function_exists("mb_substr")) {
        $slice = mb_substr($str, $start, $length, $charset);
    } elseif (function_exists('iconv_substr')) {
        $slice = iconv_substr($str, $start, $length, $charset);
        if (false === $slice) {
            $slice = '';
        }
    } else {
        $re['utf-8'] = "/[\x01-\x7f]|[\xc2-\xdf][\x80-\xbf]|[\xe0-\xef][\x80-\xbf]{2}|[\xf0-\xff][\x80-\xbf]{3}/";
        $re['gb2312'] = "/[\x01-\x7f]|[\xb0-\xf7][\xa0-\xfe]/";
        $re['gbk'] = "/[\x01-\x7f]|[\x81-\xfe][\x40-\xfe]/";
        $re['big5'] = "/[\x01-\x7f]|[\x81-\xfe]([\x40-\x7e]|\xa1-\xfe])/";
        preg_match_all($re[$charset], $str, $match);
        $slice = join("", array_slice($match[0], $start, $length));
    }
    $fix = '';
    if (strlen($slice) < strlen($str)) {
        $fix = '...';
    }
    return $suffix ? $slice . $fix : $slice;
}
/**
 * 格式化字节大小(数据库备份用到这里)
 * @param  number $size 字节数
 * @param  string $delimiter 数字和单位分隔符
 * @return string            格式化后的带单位的大小
 */
function format_bytes($size, $delimiter = '')
{
    $units = array('B', 'KB', 'MB', 'GB', 'TB', 'PB');
    for ($i = 0; $size >= 1024 && $i < 5; $i++) {
        $size /= 1024;
    }
    return round($size, 2) . $delimiter . $units[$i];
}
/**
 * [sizeFormat 字节大小转换]
 * @param  [type] $size [字节数]
 * @return [type]       [description]
 */
function sizeFormat($size)
{
    if ($size < 1024) {
        return $size . " bytes";
    } else if ($size < (1024 * 1024)) {
        $size = round($size / 1024, 1);
        return $size . " KB";
    } else if ($size < (1024 * 1024 * 1024)) {
        $size = round($size / (1024 * 1024), 1);
        return $size . " MB";
    } else {
        $size = round($size / (1024 * 1024 * 1024), 1);
        return $size . " GB";
    }
}
/**
 * [size_format 文件大小的人性化显示]
 * @param  integer $size [文件大小单位B]
 * @param  integer $num  [小数点位数]
 * @return [type]        [description]
 */
function size_format($size = 0, $num = 0)
{
    $unit = ['B', 'KB', 'MB', 'GB', 'TB'];
    $i = 0;
    while ($size > 1024) {
        $size /= 1024; //$size=$size/1024
        $i++;
    }
    return round($size, $num) . $unit[$i];
}
/**
 * [Description 获取用户真实地址]
 * @return string 返回用户ip
 */
function GetIP()
{
    static $realip = null;
    if ($realip !== null) {
        return $realip;
    }
    if (isset($_SERVER)) {
        if (isset($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $arr = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
            // 取X-Forwarded-For中第x个非unknown的有效IP字符?
            foreach ($arr as $ip) {
                $ip = trim($ip);
                if ($ip != 'unknown') {
                    $realip = $ip;
                    break;
                }
            }
        } elseif (isset($_SERVER['HTTP_CLIENT_IP'])) {
            $realip = $_SERVER['HTTP_CLIENT_IP'];
        } else {
            if (isset($_SERVER['REMOTE_ADDR'])) {
                $realip = $_SERVER['REMOTE_ADDR'];
            } else {
                $realip = '0.0.0.0';
            }
        }
    } else {
        if (getenv('HTTP_X_FORWARDED_FOR')) {
            $realip = getenv('HTTP_X_FORWARDED_FOR');
        } elseif (getenv('HTTP_CLIENT_IP')) {
            $realip = getenv('HTTP_CLIENT_IP');
        } else {
            $realip = getenv('REMOTE_ADDR');
        }
    }
    preg_match("/[\d\.]{7,15}/", $realip, $onlineip);
    $realip = !empty($onlineip[0]) ? $onlineip[0] : '0.0.0.0';
    return $realip;
}
/**
 * 获取客户端IP地址
 * @param integer $type 返回类型 0 返回IP地址 1 返回IPV4地址数字
 * @param boolean $adv 是否进行高级模式获取（有可能被伪装）
 * @return mixed
 */
function get_client_ip($type = 0, $adv = false)
{
    $type = $type ? 1 : 0;
    static $ip = null;
    if ($ip !== null) {
        return $ip[$type];
    }
    if ($adv) {
        if (isset($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $arr = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
            $pos = array_search('unknown', $arr);
            if (false !== $pos) {
                unset($arr[$pos]);
            }
            $ip = trim($arr[0]);
        } elseif (isset($_SERVER['HTTP_CLIENT_IP'])) {
            $ip = $_SERVER['HTTP_CLIENT_IP'];
        } elseif (isset($_SERVER['REMOTE_ADDR'])) {
            $ip = $_SERVER['REMOTE_ADDR'];
        }
    } elseif (isset($_SERVER['REMOTE_ADDR'])) {
        $ip = $_SERVER['REMOTE_ADDR'];
    }
    // IP地址合法验证
    $long = sprintf("%u", ip2long($ip));
    $ip = $long ? array($ip, $long) : array('0.0.0.0', 0);
    return $ip[$type];
}
/**
 * 获取ip
 * @return string 返回当前用户ip
 */
function get_userip()
{
    if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
        $ip = $_SERVER['HTTP_CLIENT_IP'];
    } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
    } else {
        $ip = $_SERVER['REMOTE_ADDR'];
    }
    if ($ip == '::1') {
        $ip = '127.0.0.1';
    }
    return $ip;
}
/**
 * 获取ip 基本能拿到用户真实IP
 * @return string 返回当前用户ip
 */
function get_reluser_ip()
{
    if (!empty($_SERVER["HTTP_CLIENT_IP"])) {
        $cip = $_SERVER["HTTP_CLIENT_IP"];
    } else if (!empty($_SERVER["HTTP_X_FORWARDED_FOR"])) {
        $cip = $_SERVER["HTTP_X_FORWARDED_FOR"];
    } else if (!empty($_SERVER["REMOTE_ADDR"])) {
        $cip = $_SERVER["REMOTE_ADDR"];
    } else {
        $cip = '';
    }
    preg_match("/[\d\.]{7,15}/", $cip, $cips);
    $cip = isset($cips[0]) ? $cips[0] : 'unknown';
    unset($cips);
    return $cip;
}
/**
 * HOST访问限制 支持 IP(单IP,多IP,*通配符,IP段) 域名(单域名,多域名,*通配符)
 * 根据判断实现IP地址 白名单黑名单
 * Author：70(qq781787584)
 * @param unknown $host 当前host 127.0.0.2
 * @param unknown $list 允许的host列表 127.0.0.*,192.168.1.1,192.168.1.70,127.1.1.33-127.1.1.100
 * @return boolean
 */
function in_host($host, $list)
{
    $list = ',' . $list . ',';
    $is_in = false;
    // 1.判断最简单的情况
    $is_in = strpos($list, ',' . $host . ',') === false ? false : true;
    // 2.判断通配符情况
    if (!$is_in && strpos($list, '*') !== false) {
        $hosts = array();
        $hosts = explode('.', $host);
        // 组装每个 * 通配符的情况
        foreach ($hosts as $k1 => $v1) {
            $host_now = '';
            foreach ($hosts as $k2 => $v2) {
                $host_now .= ($k2 == $k1 ? '*' : $v2) . '.';
            }
            // 组装好后进行判断
            if (strpos($list, ',' . substr($host_now, 0, -1) . ',') !== false) {
                $is_in = true;
                break;
            }
        }
    }
    // 3.判断IP段限制
    if (!$is_in && strpos($list, '-') !== false) {
        $lists = explode(',', trim($list, ','));
        $host_long = ip2long($host);
        foreach ($lists as $k => $v) {
            if (strpos($v, '-') !== false) {
                list($host1, $host2) = explode('-', $v);
                if ($host_long >= ip2long($host1) && $host_long <= ip2long($host2)) {
                    $is_in = true;
                    break;
                }
            }
        }
    }
    return $is_in;
}
/**
 * 根据IP获取ip所在的地区 (失灵尽量不用这个，用ip_IpLocation())
 * @param ip
 * @return adr 所在地区
 */
function ip_address($ip)
{
    // $adr = 'unknown';
    $adr = '本机地址-';
    if (empty($ip) || $ip == '127.0.0.1') {
        return $adr;
    }
    $ch = curl_init();
    $url = 'http://ip.taobao.com/service/getIpInfo.php?ip=' . $ip;
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    $res = curl_exec($ch);
    curl_close($ch);
    $data = json_decode($res, true);
    if ($data['code'] == 0) {
        $adr = $data['data']['region'] . $data['data']['city'] . '-' . $data['data']['isp'];
    }
    return $adr;
}
/**
 * 根据IP获取ip所在的地区
 * @param ip
 * @return adr 所在地区
 */
function ip_IpLocation($ip)
{
    $adr = 'unknown';
    if (empty($ip)) {
        return $adr;
    }
    include_once PROJECT_PATH . '/data/plugins/iplocation/IpLocation.php';
    $Ip = new \IpLocation();
    $data = $Ip->getlocation($ip); // 获取某个IP地址所在的位置
    if (is_utf8($data['country'])) {
        //判断是否是utf8编码
        $str1 = $data['country'];
    } else {
        $str1 = iconv('GB2312', 'UTF-8', $data['country']);
    }
    if (is_utf8($data['area'])) {
        //判断是否是utf8编码
        $str2 = $data['area'];
    } else {
        $str2 = iconv('GB2312', 'UTF-8', $data['area']);
    }
    $adr = $str1 . '-' . $str2;
    return $adr;
}
/**
 * 获取服务器信息
 * @return array 返回服务器信息
 */
function server_info()
{
    $serverinfo = array();
    // ZengCMS版本
    $serverinfo['zengcms_ver'] = ZENGCMS_VERSION;
    // PHP版本
    $serverinfo['php_ver'] = PHP_VERSION;
    // ThinkPHP框架版本
    $serverinfo['tp_ver'] = App::version();
    // 数据库版本
    $serverinfo['mysql_ver'] = Db::query('select version() as ver')[0]['ver'];
    // 获取数据库名称
    $serverinfo['db_name'] = Db::query("select DATABASE()")[0]['DATABASE()'];
    // 服务器域名/主机名
    $serverinfo['host'] = isset($_SERVER['SERVER_NAME'])?$_SERVER['SERVER_NAME']:'';
    // 当前运行脚本所在的服务器的IP地址。
    $serverinfo['ip'] = gethostbyname(isset($_SERVER['SERVER_NAME'])?$_SERVER['SERVER_NAME']:'');
    // 服务器时间
    $serverinfo['time'] = date("Y年n月j日 H:i:s");
    // 北京时间
    $serverinfo['beijing_time'] = gmdate("Y年n月j日 H:i:s", time() + 8 * 3600);
    // 程序目录
    $serverinfo['program_dir'] = isset($_SERVER['DOCUMENT_ROOT'])?preg_replace('/(.*)\/{1}([^\/]*)/i', '$1', $_SERVER['DOCUMENT_ROOT']):'';
    // 获取系统类型
    $serverinfo['system'] = php_uname('s');//或PHP_OS
    // 获取运行环境-服务引擎
    $serverinfo['server'] = isset($_SERVER["SERVER_SOFTWARE"])?$_SERVER["SERVER_SOFTWARE"]:'';
    // 服务器端口
    $serverinfo['port'] = isset($_SERVER['SERVER_PORT'])?$_SERVER['SERVER_PORT']:'';
     // 剩余空间
     $serverinfo['remaining_space'] = round((disk_free_space(".") / (1024 * 1024)), 2) . 'M';
    // 最大占用内存
    $serverinfo['memory_limit'] = ini_get('memory_limit');
    // 最大上传
    $serverinfo['upload_max_filesize'] = ini_get("file_uploads") ? ini_get("upload_max_filesize") : "Disabled";
    // 脚本最大执行时间
    $serverinfo['max_execution_time'] = ini_get('max_execution_time') . '秒';
    return $serverinfo;
}
/**
 * [sql_field 给sql字段名前后加``]
 * @param  [type] $field [description]
 * @return [type]        [description]
 */
function sql_field($field)
{
    return "`{$field}`";
}
/**
 * [my_scandir ueditor编辑器图片处理(自己的，利用递归) 一维数组]
 * @param [type] $dir
 * @return void
 */
function my_scandir($dir = PROJECT_PATH)
{
    static $files = array();
    $arr = scandir($dir);
    foreach ($arr as $k => $v) {
        $path = $dir . '/' . $v;
        if ($v == '.' || $v == '..') {
            continue;
        } elseif (is_file($path)) {
            $files[] = $path;
        } else {
            $files = my_scandir($path);
        }
    }
    return $files;
}
/**
 * [my_scandir ueditor编辑器图片处理 (别人的) 多维数组]
 * @param [type] $dir
 * @return void
 */
/* function my_scandir($dir=UEDITOR){
    $files=array();
    $dir_list=scandir($dir);
    foreach ($dir_list as $file) {
        if($file != '.' && $file != '..'){
            if(is_dir($dir.'/'.$file)){
                $files[$file]=my_scandir($dir.'/'.$file);
            }else{
                $files[]=$dir.'/'.$file;
            }
        }
    }
    return $files;
} */
/* 处理富文本编辑器，用于添加数据时数据验证失败的时候和添加数据失败的时候和删除数据成功的时候（添加数据时add和删除数据del） */
// 参数$content是表单提交过来的编辑器内容也可能是数据库的编辑器内容
// 判断内容有没有图片，有就删
function editor1($content)
{
    $preg = '/<img.*?src=[\"|\']?(.*?)[\"|\']?\s.*?>/i';
    preg_match_all($preg, $content, $imgArr);
    if (!empty($imgArr)) {
        unset($imgArr[0]);
        foreach ($imgArr as $k => $v) {
            if (!empty($v)) {
                foreach ($v as $v1 => $v2) {
                    $file = $_SERVER['DOCUMENT_ROOT'] . $v2;
                    if (file_exists($file)) {
                        @unlink($file);
                    }
                }
            }
        }
    }
}
/* 第一种情况：参数$content1是数据库的编辑器内容，参数content2是表单提交过来的编辑器内容，用于编辑数据数据验证失败时和tp图片上传失败时和数据更新失败时（编辑数据时edit）*/
// 这里只考虑提交过来的文章内容增加了图片，提交过来
// 不考虑提交过来的文章内容减少了图片，提交过来
// 提交过来的所有内容图片路径和数据库中原所有路径对比
// 如果提交过来是原来没有的路径就把这些没有的路径根据其路径删除图片
/* 第二种情况：参数$content1是表单提交过来的编辑器内容，参数$content2是数据库的编辑器内容用在在数据更新成功前，数据验证和图片验证成功之后（编辑数据时edit）*/
// 只能在数据更新成功前，数据验证和图片验证成功之后
// 不能在数据更新后因为数据都变了判断不了（更新后所有路径对比都相同）
// 所以特别注意数据验证和图片验证一定要谨慎不然更新失败删除了图片但数据库中的路径依然存在（因为数据更新失败原来所有路径一直在但图片已经在这删了）
// 这里只考虑提交过来的文章内容减少了图片，提交过来
// 不考虑提交过来的文章内容增加了图片，提交过来
// 提交过来的所有内容图片路径和数据库中原所有路径对比
// 如果原来的某些路径不在提交过来的路径中就把这些路径根据其路径删除图片
function editor2($content1, $content2)
{
    $preg = '/<img.*?src=[\"|\']?(.*?)[\"|\']?\s.*?>/i';
    preg_match_all($preg, $content1, $imgArr1);
    preg_match_all($preg, $content2, $imgArr2);
    if (!empty($imgArr2)) {
        unset($imgArr2[0]);
        foreach ($imgArr2 as $k2 => $v2) {
            $imgArr4 = $v2;
        }
        if (!empty($imgArr1)) {
            unset($imgArr1[0]);
            foreach ($imgArr1 as $k1 => $v1) {
                $imgArr3 = $v1;
            }
        }
        if (!empty($imgArr4)) {
            foreach ($imgArr4 as $k3 => $v3) {
                if (!in_array($v3, $imgArr3)) {
                    $file = $_SERVER['DOCUMENT_ROOT'] . $v3;
                    if (file_exists($file)) {
                        @unlink($file);
                    }
                }
            }
        }
    }
}
/**
 * 二维数组按照指定键值去重
 * @param   $arr  需要去重的二维数组
 * @param   $key  需要去重所根据的索引
 * @return  mixed
 */
function assoc_unique($arr, $key)
{
    $tmp_arr = array();
    foreach ($arr as $k => $v) {
        if (in_array($v[$key], $tmp_arr)) {
            //搜索$v[$key]是否在$tmp_arr数组中存在，若存在返回true
            unset($arr[$k]);
        } else {
            $tmp_arr[] = $v[$key];
        }
    }
    sort($arr); //sort函数对数组进行排序
    return $arr;
}
/**
 * 判断是否UTF8编码格式
 * @param $word 字符串
 * @return boolean
 */
function is_utf8($word)
{
    // 方案一：
    if (preg_match("/^([" . chr(228) . "-" . chr(233) . "]{1}[" . chr(128) . "-" . chr(191) . "]{1}[" . chr(128) . "-" . chr(191) . "]{1}){1}/", $word) == true || preg_match("/([" . chr(228) . "-" . chr(233) . "]{1}[" . chr(128) . "-" . chr(191) . "]{1}[" . chr(128) . "-" . chr(191) . "]{1}){1}$/", $word) == true || preg_match("/([" . chr(228) . "-" . chr(233) . "]{1}[" . chr(128) . "-" . chr(191) . "]{1}[" . chr(128) . "-" . chr(191) . "]{1}){2,}/", $word) == true) {
        return true;
    } else {
        return false;
    }
    // 方案二：
    /* if (function_exists('mb_detect_encoding')) {
        return (mb_detect_encoding($str) == 'UTF-8');
    }
    $c = 0;
    $b = 0;
    $bits = 0;
    $len = strlen($str);
    for ($i = 0; $i < $len; $i++) {
        $c = ord($str[$i]);
        if ($c > 128) {
            if (($c >= 254)) {
                return false;
            } elseif ($c >= 252) {
                $bits = 6;
            } elseif ($c >= 248) {
                $bits = 5;
            } elseif ($c >= 240) {
                $bits = 4;
            } elseif ($c >= 224) {
                $bits = 3;
            } elseif ($c >= 192) {
                $bits = 2;
            } else {
                return false;
            }
            if (($i + $bits) > $len) {
                return false;
            }
            while ($bits > 1) {
                $i++;
                $b = ord($str[$i]);
                if ($b < 128 || $b > 191) {
                    return false;
                }

                $bits--;
            }
        }
    }
    return true; */
}
/**
 * POST 方式请求数据
 * @param $url 请求地址
 * @return $res 结果
 */
function curl_post($url, $data)
{
    // 创建一个新cURL资源
    $ch = curl_init();
    // 设置URL和相应的选项
    curl_setopt($ch, CURLOPT_URL, $url); //需要获取的 URL 地址，也可以在curl_init() 初始化会话的时候。
    //TRUE 时会发送 POST 请求，类型为：application/x-www-form-urlencoded，是 HTML 表单提交时最常见的一种。
    curl_setopt($ch, CURLOPT_POST, 1);
    //启用时会将头文件的信息作为数据流输出。
    curl_setopt($ch, CURLOPT_HEADER, 0);
    //设为 TRUE ，将在启用 CURLOPT_RETURNTRANSFER 时，返回原生的（Raw）输出。从 PHP 5.1.3 开始，此选项不再有效果：使用 CURLOPT_RETURNTRANSFER 后总是会返回原生的（Raw）内容。
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    //全部数据使用HTTP协议中的 "POST" 操作来发送。 要发送文件，在文件名前面加上@前缀并使用完整路径。 文件类型可在文件名后以 ';type=mimetype' 的格式指定。 这个参数可以是 urlencoded 后的字符串，类似'para1=val1&para2=val2&...'，也可以使用一个以字段名为键值，字段数据为值的数组。 如果value是一个数组，Content-Type头将会被设置成multipart/form-data。 从 PHP 5.2.0 开始，使用 @ 前缀传递文件时，value 必须是个数组。 从 PHP 5.5.0 开始, @ 前缀已被废弃，文件可通过 CURLFile 发送。 设置 CURLOPT_SAFE_UPLOAD 为 TRUE 可禁用 @ 前缀发送文件，以增加安全性。
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    // 抓取URL并把它传递给浏览器，成功时返回 TRUE， 或者在失败时返回 FALSE。 然而，如果 设置了 CURLOPT_RETURNTRANSFER 选项，函数执行成功时会返回执行的结果，失败时返回 FALSE 。Warning此函数可能返回布尔值 FALSE，但也可能返回等同于 FALSE 的非布尔值。请阅读 布尔类型章节以获取更多信息。应使用 === 运算符来测试此函数的返回值。
    $res = curl_exec($ch);
    // 关闭cURL资源，并且释放系统资源
    curl_close($ch);
    return $res;
}
/**
 * 写两个简单的函数用curl来发送POST和GET请求
 * curl_setopt_array() 为cURL传输回话批量设置选项
 * Send a POST request using cURL
 * @param string $url to request
 * @param array $post values to send
 * @param array $options for url
 */
function curl_post2($url, array $post = null, array $options = array())
{
    $defaults = array(
        CURLOPT_POST => 1,
        CURLOPT_HEADER => 0,
        CURLOPT_URL => $url,
        CURLOPT_FRESH_CONNECT => 1,
        CURLOPT_RETURNTRANSFER => 1,
        CURLOPT_FORBID_REUSE => 1,
        CURLOPT_TIMEOUT => 4,
        CURLOPT_POSTFIELDS => http_build_query($post),
    );
    $ch = curl_init();
    curl_setopt_array($ch, $options + $defaults); //数组相加 根据key将在后一个数组而不再前一个数组中的item加入第一个数组中(任意一个数组不是数组导致Faltal error)
    if (false === $result = curl_exec($ch)) {
        trigger_error(curl_error($ch));
    }
    curl_close($ch);
    return $result;
}
/**
 * get方式请求数据
 * @param $url 请求地址
 * @return $res 结果
 */
function curl_get($url)
{
    // 创建一个新cURL资源
    $ch = curl_init();
    // 设置URL和相应的选项
    curl_setopt($ch, CURLOPT_URL, $url); //需要获取的 URL 地址，也可以在curl_init() 初始化会话的时候。
    //设为 TRUE ，将在启用 CURLOPT_RETURNTRANSFER 时，返回原生的（Raw）输出。从 PHP 5.1.3 开始，此选项不再有效果：使用 CURLOPT_RETURNTRANSFER 后总是会返回原生的（Raw）内容。
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    //启用时会将头文件的信息作为数据流输出。
    curl_setopt($ch, CURLOPT_HEADER, 0);
    // 抓取URL并把它传递给浏览器，成功时返回 TRUE， 或者在失败时返回 FALSE。 然而，如果 设置了 CURLOPT_RETURNTRANSFER 选项，函数执行成功时会返回执行的结果，失败时返回 FALSE 。Warning此函数可能返回布尔值 FALSE，但也可能返回等同于 FALSE 的非布尔值。请阅读 布尔类型章节以获取更多信息。应使用 === 运算符来测试此函数的返回值。
    $res = curl_exec($ch);
    // 关闭cURL资源，并且释放系统资源
    curl_close($ch);
    return $res;
}
/**
 * Send a GET request using cURL
 * @param string $url to request
 * @param array $get values to send
 * @param array $options for cURL
 */
function curl_get2($url, array $get = null, array $options = array())
{
    $defaults = array(
        CURLOPT_URL => $url . ($get ? (strpos($url, '?') === false ? '?' : '&') . http_build_query($get) : ''),
        CURLOPT_HEADER => 0,
        CURLOPT_RETURNTRANSFER => 1,
        CURLOPT_TIMEOUT => 4,
    );
    $ch = curl_init();
    curl_setopt_array($ch, $options + $defaults);
    if (false === $result = curl_exec($ch)) {
        trigger_error(curl_error($ch));
    }
    curl_close($ch);
    return $result;
}
/**
 * [Description 通过cURL上传文件]
 * @return void
 */
function curl_upload()
{
    $url = 'http://localhost/log.php';
    $post_data = array(
        'name' => 'myname',
        'file' => '@d:\test.jpg', //上传的本地文件要加@符号
    );
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_POST, 1); //可有可无
    curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
    if (false === $result = curl_exec($ch)) {
        trigger_error(curl_error($ch));
    }
    curl_close($ch);
}
/**
 * 通过代理服务器来访问外网
 * 最近项目遇到一个问题:由于项目部署的环境是内网，
 * 但是业务中需要访问外部网络的接口 
 * 所以通过代理服务器来访问外网。
 * 废话不多说直接上代码
 * @param $url 请求地址
 * @return $res 结果
 */
function curl_daili()
{
    // 接口地址
    $requestUrl = 'http://api.t.sina.com.cn/short_url/shorten.json';
    $type = 'http';
    // 创建一个新cURL资源
    $cUrl = curl_init();
    curl_setopt($cUrl, CURLOPT_URL, $requestUrl); //需要获取的 URL 地址，也可以在curl_init() 初始化会话的时候。
    curl_setopt($cUrl, CURLOPT_HEADER, 1); //启用时会将头文件的信息作为数据流输出。
    //设为 TRUE ，将在启用 CURLOPT_RETURNTRANSFER 时，返回原生的（Raw）输出。从 PHP 5.1.3 开始，此选项不再有效果：使用 CURLOPT_RETURNTRANSFER 后总是会返回原生的（Raw）内容。
    curl_setopt($cUrl, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($cUrl, CURLOPT_TIMEOUT, 10); //允许 cURL 函数执行的最长秒数。
    curl_setopt($cUrl, CURLOPT_HTTPPROXYTUNNEL, 1); //TRUE 会通过指定的 HTTP 代理来传输。
    curl_setopt($cUrl, CURLOPT_PROXY, '80.25.198.25:8080'); //代理的ip和端口,HTTP 代理通道。
    // curl_setopt($cUrl,CURLOPT_PROXYPORT,'8080');//代理服务器的端口。端口也可以在CURLOPT_PROXY中设置。
    curl_setopt($cUrl, CURLOPT_PROXYUSERPWD, 'user:password'); //一个用来连接到代理的"[username]:[password]"格式的字符串。
    if ($type == 'https') {
        //不使用证书
        //FALSE 禁止 cURL 验证对等证书（peer's certificate）。要验证的交换证书可以在 CURLOPT_CAINFO 选项中设置，或在 CURLOPT_CAPATH中设置证书目录。自cURL 7.10开始默认为 TRUE。从 cURL 7.10开始默认绑定安装。
        curl_setopt($cUrl, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($cUrl, CURLOPT_SSL_VERIFYHOST, false);
    }
    // 抓取URL并把它传递给浏览器，成功时返回 TRUE， 或者在失败时返回 FALSE。 然而，如果 设置了 CURLOPT_RETURNTRANSFER 选项，函数执行成功时会返回执行的结果，失败时返回 FALSE 。Warning此函数可能返回布尔值 FALSE，但也可能返回等同于 FALSE 的非布尔值。请阅读 布尔类型章节以获取更多信息。应使用 === 运算符来测试此函数的返回值。
    $pageContent = curl_exec($cUrl);
    // 关闭cURL资源，并且释放系统资源
    curl_close($cUrl);
    return $pageContent;
}
/**
 * 多个数组排序组合
 * @param $arr = array($arr1,$arr2,....);  需要组合的数组
 * @return $arr 组合之后的数组
 */
function array_zuhe($arr)
{
    if (count($arr) >= 2) {
        $tmparr = array();
        $arr1 = array_shift($arr);
        $arr2 = array_shift($arr);
        foreach ($arr1 as $k1 => $v1) {
            foreach ($arr2 as $k2 => $v2) {
                $tmparr[] = $v1 . $v2;
            }
        }
        array_unshift($arr, $tmparr);
        $arr = array_zuhe($arr);
    } else {
        return $arr;
    }
    return $arr;
}
/**
 * 对字符串进行SQL注入过滤
 * @param  string/array $string 处理的字符串或数组
 * @return array   返回处理好的字符串或数组
 */
function sqlinsert($string)
{
    if (is_array($string)) {
        foreach ($string as $key => $val) {
            $string[$key] = sqlinsert($val);
        }
    } else {
        $string_old = $string;
        $string = str_ireplace("\\", "/", $string);
        $string = str_ireplace("\"", "/", $string);
        $string = str_ireplace("'", "/", $string);
        $string = str_ireplace("*", "/", $string);
        $string = str_ireplace("%5C", "/", $string);
        $string = str_ireplace("%22", "/", $string);
        $string = str_ireplace("%27", "/", $string);
        $string = str_ireplace("%2A", "/", $string);
        $string = str_ireplace("~", "/", $string);
        $string = str_ireplace("select", "\sel\ect", $string);
        $string = str_ireplace("insert", "\ins\ert", $string);
        $string = str_ireplace("update", "\up\date", $string);
        $string = str_ireplace("delete", "\de\lete", $string);
        $string = str_ireplace("union", "\un\ion", $string);
        $string = str_ireplace("into", "\in\to", $string);
        $string = str_ireplace("load_file", "\load\_\file", $string);
        $string = str_ireplace("outfile", "\out\file", $string);
        $string = str_ireplace("sleep", "\sle\ep", $string);
        $string = strip_tags($string);
        if ($string_old != $string) {
            $string = '';
        }
        $string = trim($string);
    }
    return $string;
}
/**
 * 判断是否手机访问
 * @return boolean
 */
function is_mobile()
{
    // 如果有HTTP_X_WAP_PROFILE则一定是移动设备
    if (isset($_SERVER['HTTP_X_WAP_PROFILE'])) {
        return true;
    }
    //此条摘自TPM智能切换模板引擎，适合TPM开发
    if (isset($_SERVER['HTTP_CLIENT']) && 'PhoneClient' == $_SERVER['HTTP_CLIENT']) {
        return true;
    }
    //如果via信息含有wap则一定是移动设备,部分服务商会屏蔽该信息
    if (isset($_SERVER['HTTP_VIA']))
    //找不到为flase,否则为true
    {
        return stristr($_SERVER['HTTP_VIA'], 'wap') ? true : false;
    }
    //判断手机发送的客户端标志,兼容性有待提高
    if (isset($_SERVER['HTTP_USER_AGENT'])) {
        $clientkeywords = array(
            'nokia', 'sony', 'ericsson', 'mot', 'samsung', 'htc', 'sgh', 'lg', 'sharp', 'sie-', 'philips', 'panasonic', 'alcatel', 'lenovo', 'iphone', 'ipod', 'blackberry', 'meizu', 'android', 'netfront', 'symbian', 'ucweb', 'windowsce', 'palm', 'operamini', 'operamobi', 'openwave', 'nexusone', 'cldc', 'midp', 'wap', 'mobile',
        );
        //从HTTP_USER_AGENT中查找手机浏览器的关键字
        if (preg_match("/(" . implode('|', $clientkeywords) . ")/i", strtolower($_SERVER['HTTP_USER_AGENT']))) {
            return true;
        }
    }
    //协议法，因为有可能不准确，放到最后判断
    if (isset($_SERVER['HTTP_ACCEPT'])) {
        // 如果只支持wml并且不支持html那一定是移动设备
        // 如果支持wml和html但是wml在html之前则是移动设备
        if ((strpos($_SERVER['HTTP_ACCEPT'], 'vnd.wap.wml') !== false) && (strpos($_SERVER['HTTP_ACCEPT'], 'text/html') === false || (strpos($_SERVER['HTTP_ACCEPT'], 'vnd.wap.wml') < strpos($_SERVER['HTTP_ACCEPT'], 'text/html')))) {
            return true;
        }
    }
    return false;
}
/**
 * 获取当前页面完整URL地址
 * @return url 路径
 */
function get_url()
{
    $sys_protocal = isset($_SERVER['SERVER_PORT']) && $_SERVER['SERVER_PORT'] == '443' ? 'https://' : 'http://';
    // $php_self = $_SERVER['PHP_SELF'] ? $_SERVER['PHP_SELF'] : $_SERVER['SCRIPT_NAME'];
    if(isset($_SERVER['PHP_SELF']) && $_SERVER['PHP_SELF']){
        $php_self = $_SERVER['PHP_SELF'];
    }else if(isset($_SERVER['SCRIPT_NAME']) && $_SERVER['SCRIPT_NAME']){
        $php_self =  $_SERVER['SCRIPT_NAME'];
    }else{
        $php_self = '';
    }
    $path_info = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : '';
    $relate_url = isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : $php_self . (isset($_SERVER['QUERY_STRING']) ? '?' . $_SERVER['QUERY_STRING'] : $path_info);
    return $sys_protocal . (isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : '') . $relate_url;
}
/**
 * 获取浏览器版本
 * @return string 浏览器
 */
function getbrowser()
{
    $agent = $_SERVER['HTTP_USER_AGENT'];
    $browser = '';
    $browser_ver = '';
    if (preg_match('/OmniWeb\/(v*)([^\s|;]+)/i', $agent, $return)) {
        $browser = 'OmniWeb';
        $browser_ver = $return[2];
    }
    if (preg_match('/Netscape([\d]*)\/([^\s]+)/i', $agent, $return)) {
        $browser = 'Netscape';
        $browser_ver = $return[2];
    }
    if (preg_match('/safari\/([^\s]+)/i', $agent, $return)) {
        $browser = 'Safari';
        $browser_ver = $return[1];
    }
    if (preg_match('/Chrome\/([^\s]+)/i', $agent, $return)) {
        $browser = 'Chrome';
        $browser_ver = $return[1];
    }
    if (preg_match('/MSIE\s([^\s|;]+)/i', $agent, $return)) {
        $browser = 'Internet Explorer';
        $browser_ver = $return[1];
    }
    if (preg_match('/Opera[\s|\/]([^\s]+)/i', $agent, $return)) {
        $browser = 'Opera';
        $browser_ver = $return[1];
    }
    if (preg_match('/NetCaptor\s([^\s|;]+)/i', $agent, $return)) {
        $browser = '(Internet Explorer ' . $browser_ver . ') NetCaptor';
        $browser_ver = $return[1];
    }
    if (preg_match('/Maxthon/i', $agent, $return)) {
        $browser = '(Internet Explorer ' . $browser_ver . ') Maxthon';
        $browser_ver = '';
    }
    if (preg_match('/360SE/i', $agent, $return)) {
        $browser = '(Internet Explorer ' . $browser_ver . ') 360SE';
        $browser_ver = '';
    }
    if (preg_match('/SE 2.x/i', $agent, $return)) {
        $browser = '(Internet Explorer ' . $browser_ver . ') sougou';
        $browser_ver = '';
    }
    if (preg_match('/FireFox\/([^\s]+)/i', $agent, $return)) {
        $browser = 'FireFox';
        $browser_ver = $return[1];
    }
    if (preg_match('/Lynx\/([^\s]+)/i', $agent, $return)) {
        $browser = 'Lynx';
        $browser_ver = $return[1];
    }
    if (preg_match('/MicroMessenger\/([^\s]+)/i', $agent, $return)) {
        $browser = 'MicroMessenger';
        $browser_ver = $return[1];
    }
    if ($browser != '') {
        return $browser . ' ' . $browser_ver;
    } else {
        return false;
    }
}
/**
 * [get_visit_lang 获得访客浏览器语言]
 * @return [type] [description]
 */
function get_visit_lang()
{
    if (!empty($_SERVER['HTTP_ACCEPT_LANGUAGE'])) {
        $lang = $_SERVER['HTTP_ACCEPT_LANGUAGE'];
        $lang = substr($lang, 0, 5);
        if (preg_match("/zh-cn/i", $lang)) {
            $lang = "简体中文";
        } elseif (preg_match("/zh/i", $lang)) {
            $lang = "繁体中文";
        } else {
            $lang = "English";
        }
        return $lang;
    } else {
        return "获取浏览器语言失败！";
    }
}
/**
 * [get_visit_os 获取访客操作系统]
 * @return [type] [description]
 */
function get_visit_os()
{
    if (!empty($_SERVER['HTTP_USER_AGENT'])) {
        $OS = $_SERVER['HTTP_USER_AGENT'];
        if (preg_match('/win/i', $OS)) {
            $OS = 'Windows';
        } elseif (preg_match('/mac/i', $OS)) {
            $OS = 'MAC';
        } elseif (preg_match('/linux/i', $OS)) {
            $OS = 'Linux';
        } elseif (preg_match('/unix/i', $OS)) {
            $OS = 'Unix';
        } elseif (preg_match('/bsd/i', $OS)) {
            $OS = 'BSD';
        } else {
            $OS = 'Other';
        }
        return $OS;
    } else {
        return "获取访客操作系统信息失败！";
    }
}
/**
 * [checkadd 检查URL或者IP是否正确]
 * @param  [type] $p        [1:检查IP，2：检查URL]
 * @param  [type] $ipaddres [IP地址或URL]
 * @return [type]           [description]
 */
function checkadd($p, $ipaddres)
{
    $preg = "/\A((([0-9]?[0-9])|(1[0-9]{2})|(2[0-4][0-9])|(25[0-5]))\.){3}(([0-9]?[0-9])|(1[0-9]{2})|(2[0-4][0-9])|(25[0-5]))\Z/";
    if ($p == 2) {
        $preg = "/^http:\/\/[A-Za-z0-9\-]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"])*$/";
        if (substr($ipaddres, 0, 16) == 'http://localhost' || substr($ipaddres, 0, 11) == 'http://xn--') {
            return true;
        }
    }
    return preg_match($preg, $ipaddres);
}
/**
 * [Description 阿拉伯数字转中文数字]
 * @param [type] $num
 * @return void
 */
function ToChinaseNum($num)
{
    $char = array("零", "一", "二", "三", "四", "五", "六", "七", "八", "九");
    $dw = array("", "十", "百", "千", "万", "亿", "兆");
    $retval = "";
    $proZero = false;
    for ($i = 0; $i < strlen($num); $i++) {
        if ($i > 0) {
            $temp = (int) (($num % pow(10, $i + 1)) / pow(10, $i));
        } else {
            $temp = (int) ($num % pow(10, 1));
        }
        if ($proZero == true && $temp == 0) {
            continue;
        }
        if ($temp == 0) {
            $proZero = true;
        } else {
            $proZero = false;
        }
        if ($proZero) {
            if ($retval == "") {
                continue;
            }
            $retval = $char[$temp] . $retval;
        } else {
            $retval = $char[$temp] . $dw[$i] . $retval;
        }
    }
    if ($retval == "一十") {
        $retval = "十";
    }
    return $retval;
}
/**
 * 字符串转换为数组，主要用于把分隔符调整到第二个参数
 * @param  string $str 要分割的字符串
 * @param  string $glue 分割符
 * @return array
 */
function str2arr($str, $glue = ',')
{
    return explode($glue, $str);
}
/**
 * 数组转换为字符串，主要用于把分隔符调整到第二个参数
 * @param  array $arr 要连接的数组
 * @param  string $glue 分割符
 * @return string
 */
function arr2str($arr, $glue = ',')
{
    if (empty($arr)) {
        return '';
    }
    return implode($glue, $arr);
}
/**
 * 时间戳格式化
 * @param int $time
 * @return string 完整的时间显示
 */
function time_format($time = null, $format = 'Y-m-d H:i:s')
{
    $time = $time === null ? $_SERVER['REQUEST_TIME'] : intval($time);
    return date($format, $time);
}
/**
 * 是否是AJAx提交的
 * PHP自定义函数判断是否为AJAX提交的方法
 * @return bool
 */
function is_ajax()
{
    if (isset($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
        return true;
    } else {
        return false;
    }
}
/**
 * 是否是GET提交的
 * PHP自定义函数判断是否为Get提交的方法
 */
function is_get()
{
    return $_SERVER['REQUEST_METHOD'] == 'GET' ? true : false;
}
/**
 * 是否是POST提交
 * PHP自定义函数判断是否为Post提交的方法
 * @return int
 */
function is_post()
{
    return ($_SERVER['REQUEST_METHOD'] == 'POST' && checkurlHash($GLOBALS['verify']) && (empty($_SERVER['HTTP_REFERER']) || preg_replace("~https?:\/\/([^\:\/]+).*~i", "\\1", $_SERVER['HTTP_REFERER']) == preg_replace("~([^\:]+).*~", "\\1", $_SERVER['HTTP_HOST']))) ? 1 : 0;
}
/**
 * 根据拼音获取城市信息
 * @param $cityname 城市拼音
 * @return $info 城市信息
 */
function get_city_bypinyin($cityname = null)
{
    $info = '';
    if (preg_match("/^[a-zA-Z\s]+$/", $cityname)) {
        $map[] = ['pinyin', 'like', $cityname];
        $list = Db::name('region')->field('id,shortname,pinyin')->where($map)->select()->toArray();
        if ($list) {
            $data = array();
            $city = array();
            foreach ($list as $key => $vl) {
                $data[$vl['id']] = $vl;
                $city[$key] = $vl['id'];
            };
            $seocity = json_decode(get_one_cache_config('WEB_SEO_CITY'));
            if (!$seocity) {
                return $info;
            }
            $result = array_intersect($city, $seocity);
            if (!empty($result)) {
                return $data[isset($result[0]) ? $result[0] : array_shift($result)];
            }
            return $info;
        }
        return $info;
    }
    return $info;
}
/**
 * 根据PID获取下级城市信息
 * @param $pid 上级ID
 * @return array 城市信息
 */
function get_region($pid = 100000)
{
    $parent_id[] = ['pid', '=', $pid];
    $region = Db::name('region')
    ->field('id,name,shortname,pid')
    ->where($parent_id)
    ->select()
    ->toArray();
    /*if ($this->isAjax()) {
        return json($region);
    }else{
        return $region;
    }*/
    if (is_ajax()) {
        return json($region);
    } else {
        return $region;
    }
}
/**
 * 根据字符串分割获得城市信息，用于文章(文档)地区编辑
 * @param  string $str [文章(文档)地区信息字符串]
 * @param  string $level [需要获取的城市等级province、city、area]
 * @return array 城市信息
 */
function get_region_tostr($str = '', $level = '')
{
    $parent_id = [];
    $reglist = explode(',', $str);
    switch ($level) {
        case 'province':
            $parent_id[] = ['pid', '=', 100000];
            break;
        case 'city':
            if (isset($reglist[0])) {
                $parent_id[] = ['pid', '=', $reglist[0]];
            }
            break;
        case 'area':
            if (isset($reglist[1])) {
                $parent_id[] = ['pid', '=', $reglist[1]];
            }
            break;
        default:
            break;
    }
    $region = Db::name('region')->field('id,name,shortname,pid')->where($parent_id)->select()->toArray();
    /*if ($this->isAjax()) {
        return json($region);
    }else{
        return $region;
    }*/
    if (is_ajax()) {
        return json($region);
    } else {
        return $region;
    }
}
/**
 * 根据来访也路径，判断搜索引擎的来路以及用户搜索输入的关键字
 * @param url 来源路径
 * @return array  [关键词/搜索引擎]
 */
function keytype($search_url)
{
    $config = get_engine_type();
    $arr_key = array('', '');
    foreach ($config as $key => $item) {
        $sh = preg_match("/\b{$item['domain']}\b/", $search_url);
        if ($sh) {
            $query = $item['kw'] . "=";
            $s_s_keyword = get_keyword($search_url, $query);
            $F_Skey = urldecode($s_s_keyword);
            $agwe = 0;
            if ($key == '百度') {
                $agwe = get_keyword($search_url, 'ie=');
                $item['charset'] = $agwe == '' ? $item['charset'] : $agwe;
            }
            if ($item['charset'] != "utf-8" && !is_utf8($F_Skey)) {
                $F_Skey = iconv("gb2312//IGNORE", "UTF-8", $F_Skey);
            }
            $arr_key[0] = $F_Skey;
            $arr_key[1] = $item['type'];
        }
    }
    return $arr_key;
}
/**
 * [Description 获取搜索引擎类型信息]
 * @param string $type
 * @return void
 */
function get_engine_type($type = '')
{
    static $_type = array(
        '1' => array("name" => "谷歌", "domain" => "www.google.", "kw" => "q", "charset" => "utf-8", 'type' => 1),
        '2' => array("name" => "百度", "domain" => "www.baidu.", "kw" => "wd", "charset" => "utf-8", 'type' => 2),
        '3' => array("name" => "搜搜", "domain" => "soso.", "kw" => "query", "charset" => "gbk", 'type' => 3),
        '4' => array("name" => "雅虎", "domain" => "yahoo.", "kw" => "p", "charset" => "utf-8", 'type' => 4),
        '5' => array("name" => "必应", "domain" => "bing.", "kw" => "q", "charset" => "utf-8", 'type' => 5),
        '6' => array("name" => "搜狗", "domain" => "sogou.", "kw" => "query", "charset" => "gbk", 'type' => 6),
        '7' => array("name" => "有道", "domain" => "youdao.", "kw" => "q", "charset" => "utf-8", 'type' => 7),
        '8' => array("name" => "360搜索", "domain" => "www.so.", "kw" => "q", "charset" => "utf-8", 'type' => 8),
        '9' => array("name" => "神马搜索", "domain" => "sm.cn", "kw" => "q", "charset" => "utf-8", 'type' => 9),
    );
    return $type ? $_type[$type] : $_type;
}
/**
 * 字符串截取获取关键词
 * @return string
 */
function get_keyword($url, $kw_start)
{
    $start = stripos($url, $kw_start);
    if ($start) {
        $url = substr($url, $start + strlen($kw_start));
        $start = stripos($url, '&');
        if ($start > 0) {
            if ($start > 0) {
                $start = stripos($url, '&');
                $s_s_keyword = substr($url, 0, $start);
            } else {
                $s_s_keyword = substr($url, 0);
            }
        } else {
            $s_s_keyword = '';
        }
    } else {
        $s_s_keyword = '';
    }
    return $s_s_keyword;
}
/**
 * 正则获取关键词
 * @return string 关键词
 */
function get_keyword_reg($url, $kw_start)
{
    preg_match('/' . $kw_start . '([^&]*)/i', $url, $vl);
    $keyword = '';
    if ($vl[1]) {
        $keyword = $vl[1];
    }
    return $keyword;
}
/**
 * 文件下载进度显示
 * @param unknown $dltotal 下载文件总大小
 * @param unknown $dlnow 当前已经下载大小
 */
function fun_Progress($ch, $dltotal, $dlnow)
{
    $percent = "0";
    if (!empty($dltotal)) {
        // $percent = round(($dlnow / $dltotal) * 100);
        $percent = round($dlnow / $dltotal, 2) * 100;
        // $percent = $dlnow / $dltotal * 100;
    }
    $percent = "正在下载..." . $percent . "%";
    // echo "<script type=\"text/javascript\">showmsg(\"{$percent}\")</script>";
    echo $percent . "<br/>";
    ob_flush();
    flush();
    return (0);
}
/**
 * 24小时流量情况
 * @param $g 当前小时时
 * @param $value 之前的24小时流量情况
 * @param $a PV值
 * @param $b IP值
 * @param $c 独立访客
 * @return string  重新组合后的24小时流量情况
 */
function parttime($g, $value, $a, $b, $c)
{
    $value = explode('|', $value);
    $now = $a . '-' . $b . '-' . $c;
    $str = '';
    for ($i = 0; $i < 24; $i++) {
        if ($i == $g) {
            if (!$value[$i]) {
                $str .= $now;
            } else {
                $k = explode('-', $value[$i]);
                $a = $k[0] + $a;
                $b = $k[1] + $b;
                $c = $k[2] + $c;
                $str .= $a . '-' . $b . '-' . $c;
            }
        } else {
            $str .= $value[$i];
        }
        $str .= '|';
    }
    return $str;
}
/**
 * 调用系统的API接口方法（静态方法）没有用到但可以借鉴
 * api('User/getName','id=5'); 调用公共模块的User接口的getName方法
 * api('Admin/User/getName','id=5');  调用Admin模块的User接口
 * @param  string $name 格式 [模块名]/接口名/方法名
 * @param  array|string $vars 参数
 */
function api($name, $vars = array())
{
    $array = explode('/', $name);
    $method = array_pop($array);
    $classname = array_pop($array);
    $module = $array ? array_pop($array) : 'Common';
    $callback = $module . '\\Api\\' . $classname . 'Api::' . $method;
    if (is_string($vars)) {
        parse_str($vars, $vars);
    }
    return call_user_func_array($callback, $vars);
}
/**
 * [Description 转为多文件数组]
 * @param [type] $file $_FILE
 * @param [type] $name 表单name
 * @return void
 */
function to_more_file_arr($file,$name){
    $NEW_FILES = [];
    $arr = [];
    foreach ($file[$name]['name'] as $k => $v) {
        if ($v) {
            $arr['name'] = $v;
            $arr['type'] = $file[$name]['type'][$k];
            $arr['tmp_name'] = $file[$name]['tmp_name'][$k];
            $arr['error'] = $file[$name]['error'][$k];
            $arr['size'] = $file[$name]['size'][$k];
            $NEW_FILES[] = $arr;
        }
    }
    return $NEW_FILES;
}
/**
 * 文件上传
 * @param $file 文件内容$_FILES或表单name
 * @param $dir  文件保存目录
 * @param $isoldname =0 是否使用原文件名，0否，1是
 * @param $size 上传文件大小(不能超过这值单位MB)
 * @param $ext  允许上传文件类型后缀
 */
function upload($file,$dir='default',$isoldname=0,$size=2,$ext='jpg,jpeg,png,gif')
{
    if ($file) {
        $config = [
            'ext' => $ext, 
            'size' => $size, 
            'path' => STATIC_PATH . '/uploads/'.$dir.'/', 
            'is_old_name' => $isoldname
        ];
        $UploadTool = new UploadTool($config);
        if(is_array($file)){
            $res = $UploadTool->upload($file);
        }else{
            if(isset($_FILES[$file])){
                $res = $UploadTool->upload($_FILES[$file]);
            }else{
                return ['code'=>0,'msg'=>'文件上传失败！','name'=>''];
            }
        }
        if ($res) {
            $name = str_replace(STATIC_PATH . '/','',$config['path'].$res);
            return ['code'=>1,'msg'=>'上传成功！','name'=>$name];
        } else {
            return ['code'=>0,'msg'=>$UploadTool->getError(),'name'=>''];
        }
    }else{
        return ['code'=>0,'msg'=>'文件上传失败！','name'=>''];
    }
}
/**
 * 返回数组的维度
 * @param  [type] $arr [description]
 * @return [type]      [description]
 */
function array_level($arr){
    if(!is_array($arr)) {
        return 0;
    }else{
        $max1 = 0;
        foreach($arr as $item1){
            $t1 = array_level($item1);
            if($t1 > $max1) {
                $max1 = $t1;
            }
        }
        return $max1 + 1;
    }
}
/**
 * [Description 图片预览通用(不依赖于地址；只对路径)]
 * @param [type] $file
 * @return void
 */
function getpic($file)
{
    //文件路径解码并进行编码转换
    // $file=iconv('UTF-8','GB2312',urldecode($file));
    $file = mb_convert_encoding(urldecode($file), 'GB2312', 'UTF-8');
    if ($file_info = @getimagesize($file)) {
        //判断文件是否是有效的图像文件
        $filecontent = file_get_contents($file); //获取图像文件内容
        //chunk_split使用此函数将字符串分割成小块非常有用。例如将 base64_encode() 的输出转换成符合 RFC 2045 语义的字符串。它会在每 chunklen 个字符后边插入 end。
        $base64_file = chunk_split(base64_encode($filecontent)); //对图像文件编码并转换
        $pic = "data:" . $file_info['mime'] . ";base64," . $base64_file; //组织方便页面显示的图像数据
        // return "<img src='".$pic."' height=".$height.">";//返回可直接显示的图像数据
        return $pic;
    }
    return "";
}
/**
 * 防止低版本php不能使用array_column(PHP 5 >= 5.5.0, PHP 7)
 * This file is part of the array_column library
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 *
 * @copyright Copyright (c) Ben Ramsey (http://benramsey.com)
 * @license http://opensource.org/licenses/MIT MIT
 */
if (!function_exists('array_column')) {
    /**
     * Returns the values from a single column of the input array, identified by
     * the $columnKey.
     *
     * Optionally, you may provide an $indexKey to index the values in the returned
     * array by the values from the $indexKey column in the input array.
     *
     * @param array $input A multi-dimensional array (record set) from which to pull
     *                     a column of values.
     * @param mixed $columnKey The column of values to return. This value may be the
     *                         integer key of the column you wish to retrieve, or it
     *                         may be the string key name for an associative array.
     * @param mixed $indexKey (Optional.) The column to use as the index/keys for
     *                        the returned array. This value may be the integer key
     *                        of the column, or it may be the string key name.
     * @return array
     */
    function array_column($input = null, $columnKey = null, $indexKey = null)
    {
        // Using func_get_args() in order to check for proper number of
        // parameters and trigger errors exactly as the built-in array_column()
        // does in PHP 5.5.
        $argc = func_num_args();
        $params = func_get_args();
        if ($argc < 2) {
            trigger_error("array_column() expects at least 2 parameters, {$argc} given", E_USER_WARNING);
            return null;
        }
        if (!is_array($params[0])) {
            trigger_error(
                'array_column() expects parameter 1 to be array, ' . gettype($params[0]) . ' given',
                E_USER_WARNING
            );
            return null;
        }
        if (
            !is_int($params[1])
            && !is_float($params[1])
            && !is_string($params[1])
            && $params[1] !== null
            && !(is_object($params[1]) && method_exists($params[1], '__toString'))
        ) {
            trigger_error('array_column(): The column key should be either a string or an integer', E_USER_WARNING);
            return false;
        }
        if (
            isset($params[2])
            && !is_int($params[2])
            && !is_float($params[2])
            && !is_string($params[2])
            && !(is_object($params[2]) && method_exists($params[2], '__toString'))
        ) {
            trigger_error('array_column(): The index key should be either a string or an integer', E_USER_WARNING);
            return false;
        }
        $paramsInput = $params[0];
        $paramsColumnKey = ($params[1] !== null) ? (string) $params[1] : null;
        $paramsIndexKey = null;
        if (isset($params[2])) {
            if (is_float($params[2]) || is_int($params[2])) {
                $paramsIndexKey = (int) $params[2];
            } else {
                $paramsIndexKey = (string) $params[2];
            }
        }
        $resultArray = array();
        foreach ($paramsInput as $row) {
            $key = $value = null;
            $keySet = $valueSet = false;
            if ($paramsIndexKey !== null && array_key_exists($paramsIndexKey, $row)) {
                $keySet = true;
                $key = (string) $row[$paramsIndexKey];
            }
            if ($paramsColumnKey === null) {
                $valueSet = true;
                $value = $row;
            } elseif (is_array($row) && array_key_exists($paramsColumnKey, $row)) {
                $valueSet = true;
                $value = $row[$paramsColumnKey];
            }
            if ($valueSet) {
                if ($keySet) {
                    $resultArray[$key] = $value;
                } else {
                    $resultArray[] = $value;
                }
            }
        }
        return $resultArray;
    }
}
/**
 * [Description basename中文支持]
 * @param [type] $file
 * @return void
 */
function basenamecn($file)
{
    // $file = iconv('UTF-8', 'GB2312', $file);
    $file = mb_convert_encoding($file, 'GB2312', 'UTF-8');
    // if(file_exists($file)){
    $file = str_replace('\\', '/', $file);
    // $arr = explode(DIRECTORY_SEPARATOR, $file); //DIRECTORY_SEPARATOR分隔符/或\
    $arr = explode('/', $file); //DIRECTORY_SEPARATOR分隔符/或\
    //end()获取数组最后一个元素
    // return iconv('GB2312', 'UTF-8', end($arr));
    return mb_convert_encoding(end($arr), 'UTF-8', 'GB2312');
    // }
}
/**
 * [Description 文件管理，上级目录]
 * @param [type] $dir
 * @return void
 */
function pre_dir($dir)
{
    //php中的dirname等函数无法处理中文路径,解决办法是将\分隔符改成/即可。
    $dir = str_replace('\\', '/', $dir);
    $dir = dirname($dir);
    //DIRECTORY_SEPARATOR 分隔符linux为/ window为\
    // $dir = str_replace('/', DIRECTORY_SEPARATOR, $dir);
    //转为UTF-8编码
    /*$newdir = mb_convert_encoding($dir,'UTF-8','GB2312');
    return $newdir;*/
    return $dir;
}
/**
 * 把返回的数据集转换成Tree
 * @param array $list 要转换的数据集
 * @param string $pid parent标记字段
 * @param string $level level标记字段
 * @return array
 */
function list_to_tree($list, $pk = 'id', $pid = 'pid', $child = '_child', $root = 0)
{
    // 创建Tree
    $tree = array();
    if (is_array($list)) {
        // 创建基于主键的数组引用
        $refer = array();
        foreach ($list as $key => $data) {
            $refer[$data[$pk]] = &$list[$key];
        }
        foreach ($list as $key => $data) {
            // 判断是否存在parent
            $parentId = $data[$pid];
            if ($root == $parentId) {
                $tree[] = &$list[$key];
            } else {
                if (isset($refer[$parentId])) {
                    $parent = &$refer[$parentId];
                    $parent[$child][] = &$list[$key];
                }
            }
        }
    }
    return $tree;
}
/**
 * [get_stepsclect 联动]
 * @param  string $fields [description]
 * @param  integer $pid   [description]
 * @return [type]         [description]
 */
function get_stepsclect($fields = '', $pid = 0)
{
    if ($pid === '' || empty($fields)) {
        return false;
    }
    $map[] = ['pid', '=', $pid];
    $map[] = ['fields', '=', $fields];
    $data = Db::name('stepselect')->where($map)->select()->toArray();
    return $data;
}
/**
 * 检查$pos(推荐位的值)是否包含指定推荐位$contain 也用于多选时的判断 文档编辑时用到
 * @param number $pos 推荐位的值，多个以逗号隔开。
 * @param number $contain 指定推荐位
 * @return boolean true 包含 ， false 不包含
 */
function check_document_position($pos = 0, $contain = 0)
{
    if (empty($pos) || !isset($contain)) {
        return false;
    }
    $arrt = explode(",", $pos);
    if (empty($arrt)) {
        return false;
    }
    $contain = (string) $contain;
    if (in_array($contain, $arrt)) {
        return true;
    } else {
        return false;
    }
}
##################################################################################################################
##########################################重点方法如下#############################################################
##################################################################################################################
/**
 * 根据模型id或模型标识name获取文档模型信息
 * @param  integer $id   模型id或模型标识
 * @param  string $field 模型字段
 * @param  string $form  是否表单
 * @return array
 */
function get_document_model($id = null, $field = null, $form = 0)
{
    // 获取缓存
    $list_id = get_cache('DOCUMENT_MODEL_LIST_BY_ID');
    $list_name = get_cache('DOCUMENT_MODEL_LIST_BY_NAME');
    // 获取模型名称
    if (empty($list_id)) {
        $map[] = ['status', '=', 1];
        $map[] = ['form', '=', $form];
        $model = Db::name('model')->where($map)->field(true)->select()->toArray();
        if ($model) {
            foreach ($model as $value) {
                $list_id[$value['id']] = $value;
                $list_name[$value['name']] = $value;
            }
            // 设置缓存
            set_cache('DOCUMENT_MODEL_LIST_BY_ID', $list_id);
            set_cache('DOCUMENT_MODEL_LIST_BY_NAME', $list_name);
        } else {
            return '';
        }
    }
    // 根据条件返回数据
    if (is_null($id) || empty($id)) {
        return !empty($list_id) ? $list_id : '';
    } elseif (is_null($field)) {
        return isset($list_id[$id]) ? $list_id[$id] : (isset($list_name[$id])?$list_name[$id]:'');
    } else {
        return isset($list_id[$id][$field]) ? $list_id[$id][$field] : (isset($list_name[$id][$field])?$list_name[$id][$field]:'');
    }
}
/**
 * [get_document_table_info 根据栏目ID或标识获取文档表名信息]
 * @param  [type] $category_id_or_name [description]
 * @return [type]                      [array]
 */
function get_document_table_info($category_id_or_name)
{
    if (is_numeric($category_id_or_name)) {
        $model_id = get_category_byid($category_id_or_name, 'model_id'); //根据栏目ID获取模型ID
    } else {
        $model_id = get_category_byname($category_id_or_name, 'model_id'); //根据栏目标识获取模型ID
    }
    if(!$model_id){
        return ['extend' => 0, 'extend_table_name' => '', 'table_name' => ''];
    }
    // 根据模型ID获取模型信息
    $model = get_document_model($model_id);
    $model_table_info = array();
    if ($model) {
        // 获取文档表名
        if ($model['extend']) { //非独立模型
            $extend_table_name = get_document_model($model['extend'], 'name');
            $table_name = $extend_table_name . '_' . $model['name'];
            $model_table_info = ['extend' => $model['extend'], 'extend_table_name' => $extend_table_name, 'table_name' => $table_name];
        } else { //独立模型
            $table_name = $model['name'];//表名
            $model_table_info = ['extend' => 0, 'extend_table_name' => $table_name, 'table_name' => $table_name];
        }
    } else {
        $model_table_info = ['extend' => 0, 'extend_table_name' => '', 'table_name' => ''];
    }
    return $model_table_info;
}
/**
 * [get_model_attribute 根据模型ID获取模型属性(字段)信息并缓存]
 * @param  array  $model_id  [模型ID]
 * @param  boolean $group    [是否分组-总共有两组 基础设置和拓展设置]
 * @return [type]            [description]
 */
function get_model_attribute($model_id, $group = true)
{
    // 非法ID
    if (empty($model_id) || !is_numeric($model_id)) {
        return '';
    }
    // 获取缓存数据
    $list = get_cache('attribute_list');
    if (!isset($list[$model_id])) {
        $info = Db::name('model')->field(true)->find($model_id);
        // 获取该模型所有字段
        $fields = Db::name('attribute')
        ->where('model_id', $info['id'])
        ->field(true)->select()
        ->toArray();
        if ($info['extend'] != 0) {
            // 非独立模型字段=该模型所有字段+继承模型所有字段(基础文档模型)
            $extend_fields = Db::name('attribute')
            ->where('model_id', $info['extend'])
            ->field(true)->select()->toArray();
            $fields = array_merge($fields, $extend_fields);
        }
        $list[$model_id]['info'] = $info;
        $list[$model_id]['fields'] = $fields;
        set_cache('attribute_list', $list); //更新缓存
    } else {
        $info = $list[$model_id]['info'];
        $fields = $list[$model_id]['fields'];
    }
    if ($group) { //分组
        // 获取模型排序字段
        $field_sort = json_decode($info['fields'], true); //起到分组作用
        // 对数组进行排序
        $i = 0;
        foreach ($field_sort as $k => $v) {
            if (empty($v)) {
                $i += 1;
            }
        }
        if ($i >= 1) {
            // (实际上只有两组 基础设置和拓展设置，如果至少有一组为空那么不按$info['fields']的值来判断即$field_sort为空)
            $field_sort = '';
        }
        if (!empty($field_sort)) {
            // 分组
            // 对字段数组重新整理
            $fields_f = array();
            foreach ($fields as $v) {
                $fields_f[$v['id']] = $v;
            }
            $fields = array();
            foreach ($field_sort as $key => $groups) {
                if (!empty($groups)) {
                    foreach ($groups as $group) {
                        if (!isset($fields_f[$group['id']])) {
                            continue;
                        }
                        $fields_f[$group['id']]['group'] = $key;
                        $fields[$key][$group['id']] = $fields_f[$group['id']];
                        /* $fields[$key][$group['id']] = array(
                            'id' => $fields_f[$group['id']]['id'],
                            'name' => $fields_f[$group['id']]['name'],
                            'title' => $fields_f[$group['id']]['title'],
                            'is_show' => $fields_f[$group['id']]['is_show'],
                            'status' => $fields_f[$group['id']]['status'],
                            'type' => $fields_f[$group['id']]['type'],
                            'group' => $key
                        ); */
                        unset($fields_f[$group['id']]);
                    }
                } else {
                    // 对剩下字段进行处理
                    if (!empty($fields_f)) {
                        // 好像这里多余
                        $fields[$key] = $fields_f;
                        unset($fields_f);
                    }
                }
            }
            // 对剩下字段进行处理 赋给拓展设置
            if (!empty($fields_f)) {
                if (isset($fields[1])) {
                    $fields[1] = $fields[1] + $fields_f;
                } else {
                    $fields[1] = $fields_f;
                }
                ksort($fields);
            }
        } else {
            // 不分组
            if (!empty($fields)) {
                $fields2 = array();
                foreach ($fields as $field) {
                    $fields2[$field["group_id"]][$field['id']] = $field;
                }
                $fields = $fields2;
            }
            //对数组的键按照升序排列(krsort降序) 保留键值关系 基础设置在前，拓展设置在后
            ksort($fields);
        }
        return $fields;
    }else{ //不分组
        // 方法一：不排序的
        /* $fields_f = array();
        foreach ($fields as $v) {
            $fields_f[$v['id']] = $v;
        }
        return $fields_f; */
        // 方法二：排序的
        // 获取模型排序字段
        $field_sort = json_decode($info['fields'], true); //起到分组作用
        // 对数组进行排序
        $i = 0;
        foreach ($field_sort as $k => $v) {
            if (empty($v)) {
                $i += 1;
            }
        }
        if ($i >= 1) {
            // (实际上只有两组 基础设置和拓展设置，如果至少有一组为空那么不按$info['fields']的值来判断即$field_sort为空)
            $field_sort = '';
        }
        if (!empty($field_sort)) {
            // 分组
            // 对字段数组重新整理
            $fields_f = array();
            foreach ($fields as $v) {
                $fields_f[$v['id']] = $v;
            }
            $fields = array();
            foreach ($field_sort as $key => $groups) {
                if (!empty($groups)) {
                    foreach ($groups as $group) {
                        if (!isset($fields_f[$group['id']])) {
                            continue;
                        }
                        $fields_f[$group['id']]['group'] = $key;
                        $fields[$key][$group['id']] = $fields_f[$group['id']];
                        /* $fields[$key][$group['id']] = array(
                            'id' => $fields_f[$group['id']]['id'],
                            'name' => $fields_f[$group['id']]['name'],
                            'title' => $fields_f[$group['id']]['title'],
                            'is_show' => $fields_f[$group['id']]['is_show'],
                            'status' => $fields_f[$group['id']]['status'],
                            'type' => $fields_f[$group['id']]['type'],
                            'group' => $key
                        ); */
                        unset($fields_f[$group['id']]);
                    }
                } else {
                    // 对剩下字段进行处理
                    if (!empty($fields_f)) {
                        // 好像这里多余
                        $fields[$key] = $fields_f;
                        unset($fields_f);
                    }
                }
            }
            // 对剩下字段进行处理 赋给拓展设置
            if (!empty($fields_f)) {
                if (isset($fields[1])) {
                    $fields[1] = $fields[1] + $fields_f;
                } else {
                    $fields[1] = $fields_f;
                }
                ksort($fields);
            }
        } else {
            // 不分组
            if (!empty($fields)) {
                $fields2 = array();
                foreach ($fields as $field) {
                    $fields2[$field["group_id"]][$field['id']] = $field;
                }
                $fields = $fields2;
            }
            //对数组的键按照升序排列(krsort降序) 保留键值关系 基础设置在前，拓展设置在后
            ksort($fields);
        }
        $_fields = [];
        foreach($fields as $v){
            foreach($v as $v2){
                $_fields[] = $v2;
            }
        }
        return $_fields;
    }
}
/**
 * 获取当前访问栏目类型，访问栏目列表还是访问文档内容Category和Article控制器
 * @param URL 路径
 * @return array type 类型 / cateid 栏目ID / artid 文章ID
 */
function get_cate_art()
{
    $id = input('id');
    // if (!is_numeric($id)) { //不是栏目ID，而是栏目标识
    //     $id = get_category_byname($id,'id');//获取栏目ID
    // }
    $data = array(
        'type' => '0',
        'city' => '',
        'cateid' => '0',
        'artid' => '0',
    );
    if ($id) {
        // if (strstr(request()->controller(), 'Category')) {
        if (!is_numeric($id)) { //如果id是字符串即栏目标识时时访问栏目，如果ID是数字访问文章(文档)
            $data['type'] = 'Category'; //栏目
            $data['city'] = input('city'); //城市id
            $data['cateid'] = get_category_byname($id, 'id'); //栏目ID
            $data['artid'] = '0'; //文章id设置为0
        } else {
            $data['type'] = 'Article'; //文章
            $data['city'] = input('city'); //城市id
            $catename = input('catename'); //栏目标识
            $data['cateid'] = get_category_byname($catename, 'id'); //获取栏目ID
            $data['artid'] = input('id'); //文章id
        }
    }
    return $data;
}
/**
 * [getAllChildcateIds 获取指定栏目ID分类的所有子分类ID号]
 * @param  [type] $categoryID [栏目ID]
 * @return [type]             [返回所有ID字符串]
 */
function getAllChildcateIds($categoryID = null)
{
    if (is_null($categoryID)) {
        return '';
    }
    // 初始化ID数组
    $array[] = $categoryID;
    do {
        $ids = '';
        $cate = Db::name('arctype')->where([['pid', 'in', $categoryID]])->order('sort desc,id asc')->select()->toArray();
        foreach ($cate as $k => $v) {
            $array[] = $v['id'];
            $ids .= ',' . $v['id'];
        }
        $ids = substr($ids, 1, strlen($ids)); //1不要逗号
        $categoryID = $ids;
    } while (!empty($cate));
    $ids = implode(',', $array);
    return $ids; //返回字符串
}
/**
 * [getAllChildcateIds 获取指定栏目ID或栏目标识的所有子分类ID号]
 * @param  [type] $category_id_or_name [栏目ID或标识]
 * @return [type]                      [返回所有ID数组]
 */
function getAllChildcateIdsArr($category_id_or_name = null)
{
    if (empty($category_id_or_name)) {
        return '';
    }
    if (!is_numeric($category_id_or_name)) {
        $category_id = get_category_byname($category_id_or_name, 'id');
    } else {
        $category_id = $category_id_or_name;
    }
    $cache_name = 'getAllChildcateIdsArr_' . $category_id;
    $ChildrenIdsArr = get_cache($cache_name);
    if(!$ChildrenIdsArr){
        // 找该栏目的所有子栏目
        $tree = new Tree();
        $ChildrenIdsArr = $tree->ChildrenIdsArr(Db::name('arctype')->order('sort desc,id asc'), $category_id);
        array_unshift($ChildrenIdsArr, $category_id);
        set_cache($cache_name, $ChildrenIdsArr); //更新缓存
    }
    return $ChildrenIdsArr;
}
/**
 * [getAllChildcateIds_same_model 获取指定栏目ID分类的所有子分类ID号-都是属于同一个模型]
 * @param  [type] $categoryID [栏目ID]
 * @return [type]             [返回所有ID字符串]
 */
function getAllChildcateIds_same_model($categoryID = null)
{
    if (empty($categoryID)) {
        return '';
    }
    $category_id = intval($categoryID);
    // 初始化ID数组
    $array[] = $categoryID;
    do {
        $ids = '';
        $categoryID = (string) $categoryID;
        $cate = Db::name('arctype')->where([['pid', 'in', $categoryID], ['status', '=', 1]])->order('sort desc,id asc')->select()->toArray();
        foreach ($cate as $k => $v) {
            $array[] = $v['id'];
            $ids .= ',' . $v['id'];
        }
        $ids = substr($ids, 1, strlen($ids)); //1 不要逗号
        $categoryID = $ids;
    } while (!empty($cate));
    $model_id = get_modelId_by_categoryId($category_id); //根据栏目ID获取模型ID
    $data = array();
    foreach ($array as $k => $v) {
        if (get_modelId_by_categoryId($v) == $model_id) {
            $data[] = $v;
        }
    }
    $ids = implode(',', $data);
    return $ids;
}
/**
 * [getAllChildcateIdsArr_same_model 获取指定栏目ID或标识的所有子分类ID号-都是属于同一个模型]
 * @param  [type] $category_id_or_name [栏目ID或标识]
 * @return [type]                      [返回所有ID数组]
 */
function getAllChildcateIdsArr_same_model($category_id_or_name = null)
{
    if (empty($category_id_or_name)) {
        return '';
    }
    if (!is_numeric($category_id_or_name)) {
        $category_id = get_category_byname($category_id_or_name, 'id');
    } else {
        $category_id = $category_id_or_name;
    }
    $cache_name = 'getAllChildcateIdsArr_' . $category_id;
    $ChildrenIdsArr = get_cache($cache_name);
    if (!$ChildrenIdsArr) {
        //找该栏目的所有子栏目
        $tree = new Tree();
        $ChildrenIdsArr = $tree->ChildrenIdsArr(Db::name('arctype')->order('sort desc,id asc'), $category_id);
        array_unshift($ChildrenIdsArr, $category_id);
        set_cache($cache_name, $ChildrenIdsArr); //更新缓存
    }
    $model_id = get_modelId_by_categoryId($category_id); //根据栏目ID获取模型ID
    $data = array();
    foreach ($ChildrenIdsArr as $k => $v) {
        if (get_modelId_by_categoryId($v) == $model_id) {
            $data[] = $v;
        }
    }
    return $data;
}
/**
 * [get_top_Cateid 获得当前顶级栏目的id]
 * @return [type] [description]
 */
function get_top_Cateid()
{
    $data = get_cate_art();
    $cateid = 0;
    if (!empty($data['cateid'])) {
        $par_cate = get_parent_category($data['cateid']);
        if ($par_cate[0]) {
            $cateid = $par_cate[0]['id'];
        }
    }
    return $cateid;
}
/**
 * [get_category_byname 根据栏目标识获取栏目信息]
 * @param  [type] $name  [栏目标识]
 * @param  [type] $field [字段]
 * @return [type]        [description]
 */
function get_category_byname($name, $field = null)
{
    // 非法分类ID
    if (empty($name) || is_numeric($name)) {
        return '';
    }
    // 读取缓存数据
    $list = get_cache('sys_category_list');
    // 获取分类名称
    if (!isset($list[$name])) {
        $cate = Db::name('arctype')->where('name', $name)->find();
        // if (!$cate || 1 != $cate['status']) { //不存在分类，或分类被禁用
        if (!$cate) {
            // 不存在分类
            return '';
        }
        $list[$name] = $cate;
        // 更新缓存
        set_cache('sys_category_list', $list);
    }
    return is_null($field) ? $list[$name] : $list[$name][$field];
}
/**
 * 根据栏目ID获取分类信息并缓存分类
 * @param  integer $id   分类ID
 * @param  string $field 要获取的字段名
 * @return string        分类信息
 */
function get_category_byid($id, $field = null)
{
    // 非法分类ID
    if (empty($id) || !is_numeric($id)) {
        return '';
    }
    // 读取缓存数据
    $list = get_cache('sys_category_list');
    // 获取分类名称
    if (!isset($list[$id])) {
        $cate = Db::name('arctype')->find($id);
        // if(!$cate || 1 != $cate['status']){ //不存在分类，或分类被禁用
        if (!$cate) {
            // 不存在分类
            return '';
        }
        $list[$id] = $cate;
        set_cache('sys_category_list', $list); //更新缓存
    }
    if (is_null($field)) {
        return $list[$id];
    } else {
        if (isset($list[$id][$field])) {
            return $list[$id][$field];
        } else {
            return '';
        }
    }
}
/**
 * [get_category_title 根据栏目ID获取分类名称(栏目名称typename)]
 * @param  [type] $id [description]
 * @return [type]     [description]
 */
function get_category_title($id)
{
    return get_category_byid($id, 'typename');
}
/**
 * [get_parent_category 根据栏目ID获取其所有父级分类信息 - 内置标签文件（app\common\taglib\Huo.php）里用到]
 * @param  [type] $cid [栏目ID]
 * @return [type]      [参数分类和父类的信息集合]
 */
function get_parent_category($cid)
{
    if (empty($cid)) {
        return false;
    }
    $cates = get_cache('category_all');
    if (!$cates) {
        $cates = Db::name('arctype')->field('id,pid')->where('status', 1)->order('sort')->select()->toArray();
        set_cache('category_all', $cates); //更新缓存
    }
    $child = get_category_byid($cid); //根据栏目ID获取栏目分类的信息
    $pid = $child['pid'];
    $res[] = $child;
    while (true) {
        foreach ($cates as $key => $cate) {
            if ($cate['id'] == $pid) {
                $pid = $cate['pid'];
                array_unshift($res, $cate); //将父分类插入到数组第一个元素前
            }
        }
        if ($pid == 0) {
            break;
        }
    }
    return $res;
}
/**
 * 验证分类是否允许发布内容
 * @param  integer $id 分类ID
 * @return boolean true-允许发布内容，false-不允许发布内容
 */
function check_category($id)
{
    if (is_array($id)) {
        $id['allow_publish'] = !empty($id['allow_publish']) ? $id['allow_publish'] : 2;
        $type = get_category_byid($id['category_id'], 'allow_publish'); //获取栏目分类信息
        $type = explode(",", $type);
        return in_array($id['allow_publish'], $type);
    } else {
        $publish = get_category_byid($id, 'allow_publish'); //获取栏目分类信息
        return $publish ? true : false;
    }
}
/**
 * [get_modelId_by_categoryId 根据栏目ID获取所属模型ID]
 * @param  [type] $category_id [description]
 * @return [type]              [模型ID int]
 */
function get_modelId_by_categoryId($category_id)
{
    $model_id = get_category_byid($category_id, 'model_id');
    return $model_id;
}
/**
 * [get_article_title 根据文章ID和栏目ID获取标题-用于访问统计Stats.php文件中使用]
 * @param  [type] $id          [description]
 * @param  [type] $category_id [description]
 * @return [type]              [description]
 */
function get_article_title($id, $category_id = null)
{
    // 非法分类ID
    if (empty($id) || !is_numeric($id) || empty($category_id) || !is_numeric($category_id)) {
        return '';
    }
    // 根据栏目ID获取模型ID
    $model_id = get_modelId_by_categoryId($category_id);
    // 根据模型ID获取模型信息
    $model = get_document_model($model_id);
    if (!$model) {
        return '';
    }
    if ($model['extend']) {
        // 非独立模型
        $extend_name = get_document_model($model['extend'], 'name');
        $info = Db::name($extend_name)->field('title')->find($id);
    } else {
        // 独立模型
        $info = Db::name($model['name'])->field('title')->find($id);
    }
    if (!$info) {
        return '';
    }
    return $info['title'];
}
// 分析枚举类型配置值，格式：a:名称1,b:名称2
function parse_config_attr($string)
{
	$array = preg_split('/[,;\r\n]+/', trim($string, ",;\r\n"));
	if(strpos($string,':')){
		$value  =   array();
		foreach ($array as $val) {
			list($k, $v) = explode(':', $val);
			$value[$k]   = $v;
		}
	}else{
		$value = $array;
	}
	return $value;
}
// 分析枚举类型字段值，格式：a:名称1,b:名称2
// 暂时和 parse_config_attr功能相同
// 但请不要互相使用，后期会调整
function parse_field_attr($string)
{
    if (0 === strpos($string, ':')) {
        // 采用函数定义，eval和echo作用差不多，最后必须带分号结尾
        return eval(substr($string, 1) . ';');
    }
    $array = preg_split('/[,;\r\n]+/', trim($string, ",;\r\n"));
    if (strpos($string, ':')) {
        $value = array();
        foreach ($array as $val) {
            list($k, $v) = explode(':', $val);
            $value[$k] = $v;
        }
    } else {
        $value = $array;
    }
    return $value;
}
// 高级下拉单、多选
function parse_field_json($string,$val='',$type='selects')
{
    $arr = parse_field_attr($string);
    $valarr = [];
    $valarr = explode(',',$val);
    $_arr = [];
    if($arr){
        $i = 0;
        foreach($arr as $k=>$v){
            $_arr[$i]['name'] = $v;
            $_arr[$i]['value'] = $k;
            /* if($val === ""){
                $_arr[$i]['selected'] = false;
            }elseif(in_array($k,$valarr)){
                $_arr[$i]['selected'] = true;
            }else{
                $_arr[$i]['selected'] = false;
            } */
            $k = (string)$k;
            if($type == 'selects'){
                if(in_array($k,$valarr)){
                    $_arr[$i]['selected'] = true;
                }else{
                    $_arr[$i]['selected'] = false;
                }
            }else{
                if($k == $val){
                    $_arr[$i]['selected'] = true;
                }else{
                    $_arr[$i]['selected'] = false;
                }  
            }
            
            $i++;
        }
    }
    echo json_encode($_arr);
}
/**
 * [get_field_attr 获取字段值数组]
 * @param  [type] $field_name  [字段名]
 * @param  [type] $category_id [模型id或模型标识name]
 * @return [type] [description]
 */
function get_field_attr($field_name = 'flags', $model_id = null)
{
    if (!$model_id) {
        $cache_model_id_name = '*';
    } else {
        $cache_model_id_name = $model_id;
    }
    // 拼接缓存名称
    $cache_name = 'get_field_attr_'.$field_name . '_' . $cache_model_id_name;
    $array = get_cache($cache_name);
    if ($array) {
        return $array;
    }
    if ($model_id) {
        if(!is_numeric($model_id)){
            $model_id = get_document_model($model_id, 'id');
        }
        //根据模型ID获取模型信息
        $extend = get_document_model($model_id, 'extend');
        if ($extend) {
            $map[] = ['model_id', 'in', [$extend, $model_id]];
        } else {
            $map[] = ['model_id', '=', $model_id];
        }
        $map[] = ['name', '=', $field_name];
        $data = Db::name('attribute')->field('extra')->where($map)->find();
        $array = parse_field_attr($data['extra']);
    } else {
        $array = array();
        $data = Db::name('attribute')->field('extra')->where('name', $field_name)->select()->toArray();
        foreach ($data as $k => $v) {
            $array = array_merge($array, parse_field_attr($v['extra']));
        }
    }
    // 更新缓存
    set_cache($cache_name, $array);
    return $array;
}
/**
 * [get_field_str 获取字段字符串]
 * @param  [type] $id  [模型id或模型标识name]
 * @return [type] [description]
 */
function get_field_str($id){
    if(!is_numeric($id)){
        $id = get_document_model($id,'id');
    }
    $extend = get_document_model($id,'extend');
    $field_str = '';
    if($extend){
        $a = Db::name('attribute')->field('name')->where('model_id',$extend)->select()->toArray();
        foreach($a as $k=>$v){
            $field_str .= 'a.'.$v['name'].','; 
        }
        $b = Db::name('attribute')->field('name')->where('model_id',$id)->where('name','<>','id')->select()->toArray();
        foreach($b as $k=>$v){
            $field_str .= 'b.'.$v['name'].','; 
        }
    }else{
        $a = Db::name('attribute')->field('name')->where('model_id',$id)->select()->toArray();
        foreach($a as $k=>$v){
            $field_str .= $v['name'].','; 
        }
    }
    return $field_str?rtrim($field_str,','):true;
}
/**
 * [get_all_category_name 获取所有栏目标识-用于路由]
 * @return [type] [description]
 */
function get_all_category_name()
{
    $rule = get_cache('route_arctype_name');
    if ($rule) {
        return $rule;
    }
    $_arctype = Db::name('arctype')->field('name')->select()->toArray();
    if (!$_arctype) {
        $rule = '[a-zA-Z0-9]+';
    } else {
        foreach ($_arctype as $k => $v) {
            if ($k == 0) {
                $rule = $v['name'];
            } else {
                $rule .= '|' . $v['name'];
            }
        }
    }
    // 更新缓存
    set_cache('route_arctype_name', $rule);
    return $rule;
}
/**
 * [get_city 根据城市id获取城市名，用于编辑网点]
 * @param  [int]    $id   [根据城市id]
 * @return [string] $name [城市名]
 */
function get_city($id)
{
    $name = Db::name('region')->where('id',$id)->value('name');
    return $name;
}
/**
 * [get_index_lang 获取前台访问的语言]
 * m主要用于后台更新管理（中文手机版）里用到
 * en主要用于后台更新管理（英文PC版）里用到
 * en_m主要用于后台更新管理（后缀带_m是非中文手机版，en_m是英文手机版）里用到
 * @return [type] [description]
 */
function get_index_lang()
{
    $lang = input('lang');
    $data['lang'] = '';//PC端语言en或其它，空为中文，注意没有m和en_m
    $data['lang_url_dir'] = '';//各语言PC或手机url目录，/m或/en或/en_m
    $data['is_url_mobile'] = 0;//是否通过网址访问手机模板的http://www.zengcms.cn/m/index.html或http://www.zengcms.cn/en_m/index.html
    $data['is_chinese'] = 1;//用于tag_seomenu()，判断是否通过网址访问中文模板的http://www.zengcms.cn/m/index.html或http://www.zengcms.cn/index.html
    $data['is_browser_mobile'] = is_mobile();//是否通过设备或浏览器(非通过网址的)手机访问，true或false
    if ($lang) {
        // 后台设置的可使用的前台语言
        if (!empty(get_one_cache_config('WEB_INDEX_LANG')) && in_array($lang, explode('|', get_one_cache_config('WEB_INDEX_LANG')))) {
            if ($lang == 'm') {
                // 通过网址访问手机版中文模板
                $data['is_url_mobile'] = 1;
                $data['lang_url_dir'] = '/m';
            } elseif (strstr($lang, '_m')) {
                // 通过网址访问手机版非中文模板
                $data['is_url_mobile'] = 1;
                $arr = explode('_', $lang);
                $data['lang'] = $arr[0];//非中文语言
                $data['lang_url_dir'] = '/' . $lang;
                $data['is_chinese'] = 0;
            } else {
                $data['lang'] = $lang;//非中文语言
                $data['lang_url_dir'] = '/' . $lang;
                $data['is_chinese'] = 0;
            }
        }
    }
    // 有一种情况，不是通过网址访问手机模板，而是通过设备或浏览器访问手机模板(不做考虑了)
    /* if($data['is_browser_mobile']){
        if($lang){
            if($lang != 'm'){
                if(strstr($lang, '_m')){
                    $arr = explode('_', $lang);
                    $data['lang'] = $arr[0];//非中文语言
                    $data['lang_url_dir'] = '/' . $lang;
                    $data['is_url_mobile'] = 0;
                    $data['is_chinese'] = 0;
                }else{
                    $data['lang'] = $lang;
                    $data['lang_url_dir'] = '/' . $lang . '_m';
                    $data['is_url_mobile'] = 0;
                    $data['is_chinese'] = 0;
                }
            }else{
                $data['lang'] = '';
                $data['lang_url_dir'] = '/m';
                $data['is_url_mobile'] = 0;
                $data['is_chinese'] = 1;
            }
        }else{
            $data['lang'] = '';
            $data['lang_url_dir'] = '/m';
            $data['is_url_mobile'] = 0;
            $data['is_chinese'] = 1;
        }
    } */
    return $data;
}
/**
 * 获取当前文档的分类 可以获取所有文档的分类
 * @param int $id
 * @return array 文档类型数组
 */
function get_list_cate()
{
    $cate = '';
    $cate = Db::name('arctype')
    ->field('id,pid,typename,model_id,ispart')
    ->order('sort Desc,id Asc')
    ->select()
    ->toArray();
    if ($cate) {
        $cate = cate_level($cate); //栏目层级归类
    }
    return $cate;
}
/**
 * 栏目层级归类
 * @param data 需要归类数组
 * @return $array 完成归类的数据
 */
function cate_level($data, $pid = 0, $level = 0)
{
    $array = array();
    foreach ($data as $vl) {
        if ($vl['pid'] == $pid) {
            $vl['level'] = $level + 1;
            $array[] = $vl;
            $array = array_merge($array, cate_level($data, $vl['id'], $level + 1));
        }
    }
    return $array;
}
/**
 * [get_paging_class_name 获取不同模板分页类名]
 * 每个单词的首字母转换为大写：ucwords()
 * 第一个单词首字母变大写：ucfirst()
 * 第一个单词首字母变小写：lcfirst()
 * 所有 字母变大写：strtoupper()
 * 所有 字母变小写：strtolower()
 * @param  [type] $lang [description]
 * @return [type]       [description]
 */
function get_paging_class_name($lang)
{
    $moban = get_one_cache_config('WEB_DEFAULT_THEME');
    if ($lang) {
        $pcn = ucwords($moban . $lang);
    } else {
        $pcn = ucwords($moban);
    }
    if(!class_exists('paginator\\' . $pcn)){
        return 'paginator\\Bootstrap';
    }
    return 'paginator\\' . $pcn;
}
/**
 * @title 获取插件信息
 * @param string $name 插件名
 * @param bool $field  字段名
 * @return array|mixed|null
 */
function getAddonInfo($name,$field=null)
{
    $data = Db::name('addon')->where('name',$name)->find();
    if (is_null($field)) {
        return $data;
    } else {
        return isset($data[$field]) ? $data[$field] : '';
    }
}
/**
 * @title 获取插件的配置数组
 * @param string $name 可选插件名
 * @param bool $type 是否获取完整配置
 * @return array|mixed|null
 */
function getAddonConfig($name,$type = false)
{
    static $_config = [];
    if (isset($_config[$name])) {
        return $_config[$name];
    }
    $map[] = ['name','=',$name];
    $map[] = ['status','=',1];
    $config = Db::name('addon')->where($map)->value('config');
    if ($config) {
        $configArr = unserialize($config);
        if($type){
            $config = $configArr;
        }else{
            $_configArr = [];
            foreach($configArr as $k=>$v){
                if($v['type'] == 'array'){
                    $_configArr[$k] = $v['content'];
                }else{
                    $_configArr[$k] = $v['value'];
                }
            }
            $config = $_configArr;
        }
    } else {
        $config_file = PROJECT_PATH . '/addons/' . $name . '/config.php';
        if (is_file($config_file)) {
            $temp_arr = include $config_file;
            foreach ($temp_arr as $key => $value) {
                if ($value['type'] == 'group') {
                    foreach ($value['content'] as $gkey => $gvalue) {
                        foreach ($gvalue['content'] as $ikey => $ivalue) {
                            $config[$ikey] = $ivalue['value'];
                        }
                    }
                } elseif($value['type'] == 'array') {
                    $config[$key] = $temp_arr[$key]['content'];
                } else {
                    $config[$key] = $temp_arr[$key]['value'];
                }
            }
            if($type){
                $config = $temp_arr;
            }
            unset($temp_arr);
        }
    }
    if($type){
        $_config[$name] = $config;
    }
    return $config;
}
/**
 * 检查插件是否已经安装
 * @param type $addonName 插件名称
 * @return boolean
 */
function isAddonInstall($addonName)
{
    $addonInfo = getAddonInfo($addonName);
    if(!$addonInfo || !$addonInfo['status']){
        return false;
    }
    return true;
}
/**
 * 对用户的密码进行加密
 * @param $password
 * @param $encrypt 传入加密串，在修改密码时做认证
 * @return array/password
 */
function encrypt_password($password, $encrypt = '')
{
    $pwd             = array();
    $pwd['encrypt']  = $encrypt ? $encrypt : genRandomString();
    $pwd['password'] = md5(trim($password) . $pwd['encrypt']);
    return $encrypt ? $pwd['password'] : $pwd;
}
/**
 * 产生一个指定长度的随机字符串,并返回给用户
 * @param type $len 产生字符串的长度
 * @return string 随机字符串
 */
function genRandomString($len = 6)
{
    $chars = array(
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
        "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v",
        "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G",
        "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
        "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2",
        "3", "4", "5", "6", "7", "8", "9",
    );
    $charsLen = count($chars) - 1;
    // 将数组打乱
    shuffle($chars);
    $output = "";
    for ($i = 0; $i < $len; $i++) {
        $output .= $chars[mt_rand(0, $charsLen)];
    }
    return $output;
}
/**
 * 数据签名认证
 * @param  array  $data 被认证的数据
 * @return string       签名
 */
function data_auth_sign($data)
{
    // 数据类型检测
    if (!is_array($data)) {
        $data = (array) $data;
    }
    ksort($data); //排序
    $code = http_build_query($data); //url编码并生成query字符串
    $sign = sha1($code); //生成签名
    return $sign;
}
/**
 * 字符串加密、解密函数
 * @param    string    $txt        字符串
 * @param    string    $operation    ENCODE为加密，DECODE为解密，可选参数，默认为ENCODE，
 * @param    string    $key        密钥：数字、字母、下划线
 * @param    string    $expiry        过期时间
 * @return    string
 */
function sys_auth($string, $operation = 'ENCODE', $key = '', $expiry = 0)
{
    $ckey_length = 4;
    $key         = md5($key != '' ? $key : config('data_auth_key'));
    $keya        = md5(substr($key, 0, 16));
    $keyb        = md5(substr($key, 16, 16));
    $keyc        = $ckey_length ? ($operation == 'DECODE' ? substr($string, 0, $ckey_length) : substr(md5(microtime()), -$ckey_length)) : '';

    $cryptkey   = $keya . md5($keya . $keyc);
    $key_length = strlen($cryptkey);

    $string        = $operation == 'DECODE' ? base64_decode(strtr(substr($string, $ckey_length), '-_', '+/')) : sprintf('%010d', $expiry ? $expiry + time() : 0) . substr(md5($string . $keyb), 0, 16) . $string;
    $string_length = strlen($string);

    $result = '';
    $box    = range(0, 255);

    $rndkey = array();
    for ($i = 0; $i <= 255; $i++) {
        $rndkey[$i] = ord($cryptkey[$i % $key_length]);
    }

    for ($j = $i = 0; $i < 256; $i++) {
        $j       = ($j + $box[$i] + $rndkey[$i]) % 256;
        $tmp     = $box[$i];
        $box[$i] = $box[$j];
        $box[$j] = $tmp;
    }

    for ($a = $j = $i = 0; $i < $string_length; $i++) {
        $a       = ($a + 1) % 256;
        $j       = ($j + $box[$a]) % 256;
        $tmp     = $box[$a];
        $box[$a] = $box[$j];
        $box[$j] = $tmp;
        $result .= chr(ord($string[$i]) ^ ($box[($box[$a] + $box[$j]) % 256]));
    }

    if ($operation == 'DECODE') {
        if ((substr($result, 0, 10) == 0 || substr($result, 0, 10) - time() > 0) && substr($result, 10, 16) == substr(md5(substr($result, 26) . $keyb), 0, 16)) {
            return substr($result, 26);
        } else {
            return '';
        }
    } else {
        return $keyc . rtrim(strtr(base64_encode($result), '+/', '-_'), '=');
    }
}
/**
 * [page_array 数组分页]
 * @param  [type]  $arr   [要分页的数组]
 * @param  integer $limit [每页显示数目]
 * @param  [type]  $curr  [当前页码]
 * @return [type]         [description]
 */
function page_array($arr, $limit = 10, $curr)
{
    $total = ceil(count($arr) / $limit);//总页数，向上取整
    if ($curr <= 0) {
        $curr = 1;
    }
    if ($curr > $total) {
        $curr = $total;
    }
    $data = array_slice($arr, ($curr - 1) * $limit, $limit);
    return [
        'data' => $data,//每页的数据
        'page' => [
            'count' => count($arr),//总数目
            'limit' => $limit,//每页显示数目
            'curr' => $curr,//当前页码
        ],
    ];
}
// 重构返回json数据
function json_encode_h($code = 0, $msg = '', $url = '')
{
    echo json_encode(['code'=>$code,'msg'=>$msg,'url'=>$url],JSON_UNESCAPED_UNICODE);exit;
}
// 获取服务网点-network插件用到
function get_service_network()
{
    $provinceRes = Db::name('network')
    ->alias('sn')
    ->field('distinct r.name,sn.province')
    ->LeftJoin('region r','sn.province = r.id')
    ->select()
    ->toArray();
    return $provinceRes;
}
// kindeditor排序
function cmp_func($a, $b)
{
    global $order;
    if ($a['is_dir'] && !$b['is_dir']) {
        return -1;
    } else if (!$a['is_dir'] && $b['is_dir']) {
        return 1;
    } else {
        if ($order == 'size') {
            if ($a['filesize'] > $b['filesize']) {
                return 1;
            } else if ($a['filesize'] < $b['filesize']) {
                return -1;
            } else {
                return 0;
            }
        } else if ($order == 'type') {
            return strcmp($a['filetype'], $b['filetype']);
        } else {
            return strcmp($a['filename'], $b['filename']);
        }
    }
}
// kindeditor
function alert($msg)
{
    header('Content-type: text/html; charset=UTF-8');
    echo json_encode(array('error' => 1, 'message' => $msg),JSON_UNESCAPED_UNICODE);exit;
}
/**
 * [checkFieldAttr 检测字段属性的自动验证和自动完成属性]
 * @param array  $_data      数据
 * @param int    $model_id   模型ID
 * @param string $table_name 表名
 * @return void
 */
function checkFieldAttr($_data, $model_id = 0, $table_name = '')
{
    $data = [];
    // 处理数组、多选字段属性的值
    foreach ($_data as $k => $v) {
        if(is_array($v)){
            if(array_level($v) == 2){ //数组字段值转为json数据
                $_arr = [];
                foreach($v[0] as $k2=>$v2){
                    if($v2){
                        $_arr[$v2] = $v[1][$k2];
                    }
                }
                $data[$k] = json_encode($_arr);
            }else{ //多选，把数组转为字符串以逗号隔开
                if(in_array($k,['priv_groupid','priv_auth_groupid'])){ //栏目会员组投稿权限和后台权限不用数组转字符串
                    $data[$k] = $v;
                }else{
                    $data[$k] = implode(',', $v);
                }
            }
        }else{
            $data[$k] = $v;
        }
    }
    if($model_id){ //模型或表单字段
        $fields = get_model_attribute($model_id, false);
    }else{ //栏目或者其他功能模块的扩展字段
        $fields = Db::name('attribute')
        ->field(true)
        ->where('model_id',0)
        ->where('table_name',$table_name)
        ->select()->toArray();
        array_multisort(array_column($fields, 'group_id'),SORT_ASC,array_column($fields, 'sort'),SORT_DESC,array_column($fields, 'id'),SORT_ASC,$fields);
    }
    $arr['code'] = 1;
    foreach ($fields as $key => $attr) {
        // 特殊字段类型的值处理
        switch ($attr['type']) {
            case 'datetime': //时间
                if(isset($data[$attr['name']])){
                    $data[$attr['name']] = is_int($data[$attr['name']])?$data[$attr['name']]:strtotime($data[$attr['name']]);
                }else{
                    $data[$attr['name']] = 0;
                }
                break;
            case 'checkbox': //多选
                $data[$attr['name']] = isset($data[$attr['name']])?$data[$attr['name']]:'';
                break;
            default:
                break;
        }
        // 必填字段
        if ($attr['is_must']) {
            if (!isset($data[$attr['name']])) {
                $arr['code'] = 0;
                $arr['msg'] = $attr['title'] . '不存在此表单!';
                break;
            }
            if (empty($data[$attr['name']])) {
                $arr['code'] = 0;
                $arr['msg'] = $attr['title'] . '必须填写';
                break;
            }
        }
        // 自动验证规则
        if (!empty($attr['validate_type']) && !empty($attr['validate_rule']) && $attr['validate_time']) {
            if (!isset($data[$attr['name']])) { //判断提交表单字段是否存在
                $arr['code'] = 0;
                $arr['msg'] = $attr['title'] . '不存在此表单';
                break;
            }
            switch ($attr['validate_type']) {
                // 正则验证
                case 'regex':
                    if ($attr['validate_time'] == 3) { //始终验证
                        if (!preg_match($attr['validate_rule'], $data[$attr['name']])) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '出错';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 1 && (!isset($data['id']) || empty($data['id']))) { //新增时验证
                        if (!preg_match($attr['validate_rule'], $data[$attr['name']])) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '出错';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 2 && (isset($data['id']) && !empty($data['id']))) { //编辑时验证
                        if (!preg_match($attr['validate_rule'], $data[$attr['name']])) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '出错';
                            break 2;
                        }
                    }
                    break;
                // 函数验证
                case 'function':
                    if ($attr['validate_time'] == 3) { //始终验证
                        if (!$attr['validate_rule']($data[$attr['name']])) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '出错';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 1 && (!isset($data['id']) || empty($data['id']))) { //新增时验证
                        if (!$attr['validate_rule']($data[$attr['name']])) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '出错';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 2 && (isset($data['id']) && !empty($data['id']))) { //编辑时验证
                        if (!$attr['validate_rule']($data[$attr['name']])) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '出错';
                            break 2;
                        }
                    }
                    break;
                // 唯一验证
                case 'unique':
                    if(!$attr['table_name']){ //模型或表单
                        $model = Db::name('model')->field('extend,name')->where('id',$attr['model_id'])->find();
                        if(!$model){
                            $arr['code'] = 0;
                            $arr['msg'] = $attr['title'] . '字段模型不存在';
                            break 2;
                        }
                        if($model['extend']){
                            $extendName = Db::name('model')->where('id',$model['extend'])->value('name');
                            if(!$extendName){
                                $arr['code'] = 0;
                                $arr['msg'] = $attr['title'] . '字段继承模型不存在';
                                break 2;
                            } 
                            $tableName = $extendName.'_'.$model['name'];
                        }else{
                            $tableName = $model['name'];
                        }
                    }else{
                        $tableName = $attr['table_name'];
                    }
                    if ($attr['validate_time'] == 3) { //始终验证
                        if (!isset($data['id']) || empty($data['id'])) { //新增时
                            $res = Db::name($tableName)->where($attr['name'], $data[$attr['name']])->find();
                            if ($res) {
                                $arr['code'] = 0;
                                $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '已存在';
                                break 2;
                            }
                        } else { //编辑时
                            $res = Db::name($tableName)->where([['id', '<>', $data['id']]])->where($attr['name'], $data[$attr['name']])->find();
                            if ($res) {
                                $arr['code'] = 0;
                                $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '已存在';
                                break 2;
                            }
                        }
                    } elseif ($attr['validate_time'] == 1 && (!isset($data['id']) || empty($data['id']))) { //新增时验证
                        $res = Db::name($tableName)->where($attr['name'], $data[$attr['name']])->find();
                        if ($res) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '已存在';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 2 && (isset($data['id']) && !empty($data['id']))) { //编辑时验证
                        $res = Db::name($tableName)->where([['id', '<>', $data['id']]])->where($attr['name'], $data[$attr['name']])->find();
                        if ($res) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '已存在';
                            break 2;
                        }
                    }
                    break;
                // 长度验证
                case 'length':
                    if ($attr['validate_time'] == 3) { //始终验证
                        // /[\s,，]+/ 表示值是空格或，或,隔开，例：值1,值2
                        $lengthArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if (mb_strlen($data[$attr['name']]) < $lengthArr[0]) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '不能少于' . $lengthArr[0] . '个字符';
                            break 2;
                        } elseif (mb_strlen($data[$attr['name']]) > $lengthArr[1]) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '不能大于' . $lengthArr[1] . '个字符';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 1 && (!isset($data['id']) || empty($data['id']))) { //新增时验证
                        $lengthArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if (mb_strlen($data[$attr['name']]) < $lengthArr[0]) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '不能少于' . $lengthArr[0] . '个字符';
                            break 2;
                        } elseif (mb_strlen($data[$attr['name']]) > $lengthArr[1]) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '不能大于' . $lengthArr[1] . '个字符';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 2 && (isset($data['id']) && !empty($data['id']))) { //编辑时验证
                        $lengthArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if (mb_strlen($data[$attr['name']]) < $lengthArr[0]) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '不能少于' . $lengthArr[0] . '个字符';
                            break 2;
                        } elseif (mb_strlen($data[$attr['name']]) > $lengthArr[1]) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '不能大于' . $lengthArr[1] . '个字符';
                            break 2;
                        }
                    }
                    break;
                // 验证在范围内
                case 'in':
                    if ($attr['validate_time'] == 3) { //始终验证
                        $inArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if (!in_array($data[$attr['name']], $inArr)) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '必须在' . $attr['validate_rule'] . '里';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 1 && (!isset($data['id']) || empty($data['id']))) { //新增时验证
                        $inArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if (!in_array($data[$attr['name']], $inArr)) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '必须在' . $attr['validate_rule'] . '里';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 2 && (isset($data['id']) && !empty($data['id']))) { //编辑时验证
                        $inArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if (!in_array($data[$attr['name']], $inArr)) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '必须在' . $attr['validate_rule'] . '里';
                            break 2;
                        }
                    }
                    break;
                // 验证不在范围内
                case 'notin':
                    if ($attr['validate_time'] == 3) { //始终验证
                        $inArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if (in_array($data[$attr['name']], $inArr)) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '不能在' . $attr['validate_rule'] . '里';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 1 && (!isset($data['id']) || empty($data['id']))) { //新增时验证
                        $inArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if (in_array($data[$attr['name']], $inArr)) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '不能在' . $attr['validate_rule'] . '里';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 2 && (isset($data['id']) && !empty($data['id']))) { //编辑时验证
                        $inArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if (in_array($data[$attr['name']], $inArr)) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '不能在' . $attr['validate_rule'] . '里';
                            break 2;
                        }
                    }
                    break;
                // 区间验证
                case 'between':
                    if ($attr['validate_time'] == 3) { //始终验证
                        $betweenArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if ($data[$attr['name']] < $betweenArr[0] || $data[$attr['name']] > $betweenArr[1]) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '必须在' . $attr['validate_rule'] . '区间里';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 1 && (!isset($data['id']) || empty($data['id']))) { //新增时验证
                        $betweenArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if ($data[$attr['name']] < $betweenArr[0] || $data[$attr['name']] > $betweenArr[1]) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '必须在' . $attr['validate_rule'] . '区间里';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 2 && (isset($data['id']) && !empty($data['id']))) { //编辑时验证
                        $betweenArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if ($data[$attr['name']] < $betweenArr[0] || $data[$attr['name']] > $betweenArr[1]) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '必须在' . $attr['validate_rule'] . '区间里';
                            break 2;
                        }
                    }
                    break;
                // 不在区间验证
                case 'notbetween':
                    if ($attr['validate_time'] == 3) { //始终验证
                        $betweenArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if ($data[$attr['name']] < $betweenArr[1] && $data[$attr['name']] > $betweenArr[0]) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '不能在' . $attr['validate_rule'] . '区间里';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 1 && (!isset($data['id']) || empty($data['id']))) { //新增时验证
                        $betweenArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if ($data[$attr['name']] < $betweenArr[1] && $data[$attr['name']] > $betweenArr[0]) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '不能在' . $attr['validate_rule'] . '区间里';
                            break 2;
                        }
                    } elseif ($attr['validate_time'] == 2 && (isset($data['id']) && !empty($data['id']))) { //编辑时验证
                        $betweenArr = preg_split("/[\s,，]+/", $attr['validate_rule']);
                        if ($data[$attr['name']] < $betweenArr[1] && $data[$attr['name']] > $betweenArr[0]) {
                            $arr['code'] = 0;
                            $arr['msg'] = !empty($attr['error_info']) ? $attr['title'] . $attr['error_info'] : $attr['title'] . '不能在' . $attr['validate_rule'] . '区间里';
                            break 2;
                        }
                    }
                    break;
                default:
                    $arr['code'] = 1;
                    break 2;
            }
        }
        // 自动完成规则
        if (!empty($attr['auto_type']) && !empty($attr['auto_rule']) && $attr['auto_time']) {
            switch ($attr['auto_type']) {
                case 'function':
                    if ($attr['auto_time'] == 3) { // 始终完成
                        if(!isset($data[$attr['name']]) || empty($data[$attr['name']])){
                            $data[$attr['name']] = $attr['auto_rule']();
                        }
                    } elseif ($attr['auto_time'] == 1 && (!isset($data['id']) || empty($data['id']))) { //新增时完成
                        if(!isset($data[$attr['name']]) || empty($data[$attr['name']])){
                            $data[$attr['name']] = $attr['auto_rule']();
                        }
                    } elseif ($attr['auto_time'] == 2 && (isset($data['id']) && !empty($data['id']))) { //编辑时完成
                        if(!isset($data[$attr['name']]) || empty($data[$attr['name']])){
                            $data[$attr['name']] = $attr['auto_rule']();
                        }
                    }
                    break;
                case 'field':
                    if ($attr['auto_time'] == 3) { // 始终完成
                        if(!isset($data[$attr['name']]) || empty($data[$attr['name']])){
                            $data[$attr['name']] = $data[$attr['auto_rule']];
                        }
                    } elseif ($attr['auto_time'] == 1 && (!isset($data['id']) || empty($data['id']))) { //新增时完成
                        if(!isset($data[$attr['name']]) || empty($data[$attr['name']])){
                            $data[$attr['name']] = $data[$attr['auto_rule']];
                        }
                    } elseif ($attr['auto_time'] == 2 && (isset($data['id']) && !empty($data['id']))) { //编辑时完成
                        if(!isset($data[$attr['name']]) || empty($data[$attr['name']])){
                            $data[$attr['name']] = $data[$attr['auto_rule']];
                        }
                    }
                    break;
                case 'string':
                    if ($attr['auto_time'] == 3) { //始终完成
                        if(!isset($data[$attr['name']]) || empty($data[$attr['name']])){
                            $data[$attr['name']] = $attr['auto_rule'];
                        }
                    } elseif ($attr['auto_time'] == 1 && (!isset($data['id']) || empty($data['id']))) { //新增时完成
                        if(!isset($data[$attr['name']]) || empty($data[$attr['name']])){
                            $data[$attr['name']] = $attr['auto_rule'];
                        }
                    } elseif ($attr['auto_time'] == 2 && (isset($data['id']) && !empty($data['id']))) { //编辑时完成
                        if(!isset($data[$attr['name']]) || empty($data[$attr['name']])){
                            $data[$attr['name']] = $attr['auto_rule'];
                        }
                    }
                    break;
                default:
                    # code...
                    break;
            }
        }
    }
    // 处理
    if ($arr['code'] == 0) {
        return $arr;
    }
    $arr2['code'] = 1;
    $arr2['data'] = $data;
    return $arr2;
}
##################################################################################################################
###############################################标签调用开始########################################################
##################################################################################################################
/**
 * [get_file_path 根据文件名或文件记录获名称取文件路径]
 * @param [type] $file 文件名或文件记录值
 * @param [type] $action 1相对路径，2绝对路径
 * @return void
 */
function get_file_path($file,$action=1)
{
    if(empty($file)){
        // return Config::get('view.tpl_replace_string.__STATIC__') . '/common/images/nopicture.jpg';
        return '';
    }
    if(strpos($file,'http') !== false){
        $x_path = $file;
        $j_path = $file;
    }elseif(strpos($file,'/') !== false){
        $x_path = Config::get('view.tpl_replace_string.__STATIC__').'/'.$file;
        $j_path = STATIC_PATH.'/'.$file;
    }else{
        $res = Db::name('attachment')->field('upload_mode')->where('file_name',$file)->find();
        if($res){
            if($res['upload_mode'] == 1){ //本地
                $x_path = Config::get('view.tpl_replace_string.__STATIC__').'/uploads/'.get_one_cache_config('upload_position').'/'.$file;
                $j_path = STATIC_PATH.'/uploads/'.get_one_cache_config('upload_position').'/'.$file;
            }elseif($res['upload_mode'] == 2){ //阿里云
                $x_path = 'https://' . get_one_cache_config('bucket') . '.' . get_one_cache_config('endpoint') . '/' . $file;
                $j_path = 'https://' . get_one_cache_config('bucket') . '.' . get_one_cache_config('endpoint') . '/' . $file;
            }
        }else{
            $x_path='';
            $j_path='';
        }
    }
    if($action==1){
        return $x_path;
    }
    return $j_path;
}
/**
 * [get_file_url 根据文件值获取文件url]
 * @param [type] $file 文件值
 * @param [type] $type 1单文件，返回字符串 ；2多文件，返回数组
 * @param [type] $action 1相对路径，2绝对路径
 * @return void
 */
function get_file_url($value, $type=1, $action=1)
{
    if($type == 1){
        if(!$value){
            return '';
        }
        return get_file_path($value,$action);
    }
    $data = [];
    if($value){
        $arr = explode(',',$value);
        foreach($arr as $k=>$v){
            $data[$k] = get_file_path($v,$action);
        }
    }
    return $data;
}
/**
 * [get_search_field 获取搜索字段标签]
 * 
 * 用例：{:get_search_field('模型id或模型标识name')}
 * 
 * @param  [type] $id   [模型id或模型标识name]
 * @param  [type] $type [类型，1：获取所有；0：获取extra有值的]
 * @return [type]     [返回地址]
 */
function get_search_field($id,$type=0)
{
    if(!is_numeric($id)){
        $id = get_document_model($id,'id');
    }
    $cache_name = 'get_search_field_'.$id.'_'.$type;
    $list = get_cache($cache_name);
    if($list){
        return $list;
    }
    $extend = get_document_model($id,'extend');
    if($extend){
        $where[] = ['model_id','in',[$extend,$id]];
    }else{
        $where[] = ['model_id','=',$id];
    }
    $where[] = ['is_search','=',1];
    $_list = Db::name('attribute')->field('name,title,extra')->where($where)->select()->toArray();
    $list = array();
    foreach($_list as $k=>$v){
        $list[$k] = $v;
        if(!$v['extra']){
            unset($_list[$k]);
        }else{
            $v['extra'] = parse_field_attr($v['extra']);
            $_list[$k] = $v;
        }
    }
    if($type){
        return $list;
    }
    return $_list;
    set_cache($cache_name,$type?$list:$_list);
    return $list;
}
/**
 * [get_search_url 拼接搜索地址url]
 * 
 * 用例：{:get_search_url('字段名','字段值')}
 * 
 * @param  [type] $name  [字段名]
 * @param  [type] $value [字段值]
 * @return [type]        [返回地址]
 */
function get_search_url($name, $value)
{
    // $param = request()->param();
    $parseArr = parse_url(get_url());
    if(isset($parseArr['query'])){
        parse_str($parseArr['query'],$queryArr);
        if($name){
            $queryArr[$name] = $value;
        }
        $queryStr = http_build_query($queryArr);
    }else{
        $queryStr = 'id=' . input('id') . '&' . $name . '=' . $value;
    }
    if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
        return (string)url(get_index_lang()['lang_url_dir'] . "/search", [], get_one_cache_config('other_suffix','html'), false) . "?" . $queryStr;
    } else { //绝对路径，带域名的
        return (string)url(get_index_lang()['lang_url_dir'] . "/search", [], get_one_cache_config('other_suffix','html'), true) . "?" . $queryStr;
    }
}
/**
 * [get_demo_url 获取模板演示地址]
 * 
 * 用例：{:get_demo_url('栏目ID','文档ID')}
 * 
 * @param  [type] $category_id [栏目ID]
 * @param  [type] $document_id [文档ID]
 * @return [type]              [返回地址]
 */
function get_demo_url($category_id, $document_id)
{
    $city = input('city', '');
    $cinfo = '';
    if ($city) {
        $cinfo = get_city_bypinyin($city);
    }
    $doc = get_doc($category_id, $document_id,'id');
    if ($cinfo && $doc) {
        if (get_one_cache_config('WEB_PATH_PATTERN')) {
            $demourl = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/demo/" . $category_id . '_' . $document_id, [], get_one_cache_config('other_suffix','html'), false);
        } else {
            $demourl = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/demo/" . $category_id . '_' . $document_id, [], get_one_cache_config('other_suffix','html'), true);
        }
    }else{
        if (get_one_cache_config('WEB_PATH_PATTERN')) {
            $demourl = (string)url(get_index_lang()['lang_url_dir'] . "/demo/" . $category_id . '_' . $document_id, [], get_one_cache_config('other_suffix','html'), false);
        } else {
            $demourl = (string)url(get_index_lang()['lang_url_dir'] . "/demo/" . $category_id . '_' . $document_id, [], get_one_cache_config('other_suffix','html'), true);
        }
    }
    return $demourl;
}
/**
 * [get_download_url 获取模板下载地址]
 * 
 * 用例：{:get_download_url('栏目ID','文档ID','文件字段名')}
 * 
 * @param  [type] $category_id [栏目ID]
 * @param  [type] $document_id [文档ID]
 * @param  [type] $field       [文件字段名]
 * @return [type]              [返回地址]
 */
function get_download_url($category_id, $document_id, $field='file')
{
    $file = get_doc($category_id, $document_id, $field);
    $file_path = get_file_path($file,2);
    $file_path = urlencode(base64_encode($file_path));
    if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
        return (string)url(get_index_lang()['lang_url_dir'] . "/download", [], get_one_cache_config('other_suffix','html'), false) . "?cid=" . $category_id . "&id=" . $document_id . "&file=" . $file_path;
    } else { //绝对路径，带域名的
        return (string)url(get_index_lang()['lang_url_dir'] . "/download", [], get_one_cache_config('other_suffix','html'), true) . "?cid=" . $category_id . "&id=" . $document_id . "&file=" . $file_path;
    }
}
/**
 * jump_by_lang 根据语言和name获取跳转地址标签
 * 用例：{:jump_by_lang('en','chenggonganli')}
 * 参数说明：
 * @param $lang   语言字符，例：pc端中文$lang='en'，wap端中文$lang='m'，wap端英文$lang='en_m'，如果不填默认跳转pc端中文
 * @param $name   跳转name，例：$name='chenggonganli'，如果不填默认跳转到首页index
 * @return string 返回字符串
 */
function jump_by_lang($lang = '',$name = '')
{
    if ($lang) {
        if (!strstr($lang, '/')) {
            $lang = '/' . $lang;
        }
    }
    if (empty($name)) {
        $city = input('city', '');
        $pinyin = '';
        if ($city) {
            $cinfo = get_city_bypinyin($city);
            if ($cinfo) {
                $pinyin = '/' . $cinfo['pinyin'];
            }
        }
        // 当前控制器名称
        $controller = Request::controller();
        if($controller == 'Category'){
            $id = input('id');
            // 根据栏目标识获取当前栏目信息
            $category = get_nav($id);
            $page = input('page');
            if($page){ //分页
                if (!empty($pinyin)) {
                    $name = $pinyin . '/' . $id . '/'.'list_' . $category['id'] . '_' . $page;
                } else {
                    $name = '/' . $id . '/'.'list_' . $category['id'] . '_' . $page;
                }
                if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                    return (string)url($lang . $name, [], get_one_cache_config('category_page_suffix','html'), false); 
                } else { //绝对路径，带域名的
                    return (string)url($lang . $name, [], get_one_cache_config('category_page_suffix','html'), true);
                }
            }else{
                if (!empty($pinyin)) {
                    $name = $pinyin . '/' . $id;
                } else {
                    $name = '/' . $id;
                }
                if (get_one_cache_config('WEB_PATH_PATTERN')) {
                    if(get_one_cache_config('category_suffix')){
                        return (string)url($lang . $name, [], get_one_cache_config('category_suffix'), false);
                    }else{
                        return (string)url($lang . $name.'/', [], "", "");
                    }
                } else {
                    if(get_one_cache_config('category_suffix')){
                        return (string)url($lang . $name, [], get_one_cache_config('category_suffix'), true);
                    }else{
                        return (string)url($lang . $name."/", [], "", true);
                    }
                }
            }
        }else if($controller == 'Article'){
            // 获取栏目标识
            $catename = input('catename');
            $id = input('id');
            if($pinyin){
                $name = '/' . $cinfo['pinyin'] . '/' . $catename . '/' . $id;
            }else{
                $name = '/' . $catename . '/' . $id;
            }
            if (get_one_cache_config('WEB_PATH_PATTERN')) {
                return (string)url($lang . $name, [], get_one_cache_config('article_suffix','html'), false);
            } else {
                return (string)url($lang . $name, [], get_one_cache_config('article_suffix','html'), true);
            }
        }else{
            $name = '/index';
            if (get_one_cache_config('WEB_PATH_PATTERN')) {
                return (string)url($lang . $name, [], get_one_cache_config('index_suffix','html'), false);
            } else {
                return (string)url($lang . $name, [], get_one_cache_config('index_suffix','html'), true);
            }
        }
    }else{ //像list
        if($name == 'index'){
            $name = '/index';
            if (get_one_cache_config('WEB_PATH_PATTERN')) {
                return (string)url($lang . $name, [], get_one_cache_config('index_suffix','html'), false);
            } else {
                return (string)url($lang . $name, [], get_one_cache_config('index_suffix','html'), true);
            }
        }
        $name = '/' . $name;
        if (get_one_cache_config('WEB_PATH_PATTERN')) {
            return (string)url($lang . $name, [], get_one_cache_config('other_suffix','html'), false);
        } else {
            return (string)url($lang . $name, [], get_one_cache_config('other_suffix','html'), true);
        }
    }
}
/**
 * tag_ad 广告函数标签，循环读取广告列表
 * 
 * 用例：{volist name=":tag_ad($typeid = '1', $limit = '', $where = '', $field = '', $order = '')" id="vo" key="k"}
 * 注意如果没有指定key属性的话，默认使用循环变量i，即{$i}从1开始循环自增1的变量。
 * 注意如果要输出数组的索引，可以直接使用key变量，即{$key}和循环变量不同的是，这个key是由数据本身决定，而不是循环控制的
 * {volist name=":tag_ad($typeid = '1')" id="vo" key="k"}
 *    {$k}                            自增变量，从1开始自增1的变量
 *    {$vo.name}                      广告名称
 *    {$vo.description}               广告描述
 *    {$vo.content}                   广告内容
 *    {$vo.url}                       广告链接
 *    {:get_file_url($vo['thumb'])}   广告图片
 *    其它'字段名'可在后台广告新增或编辑页面查看
 * {/volist}
 * 
 * 参数说明：
 * @param $typeid 广告位id，例$typeid='1'
 * @param $limit  数据数量，例$limit='10'
 * @param $where  条件，例$where=[['id','in',[1,2,9,11]]]
 * @param $field  字段，例$field='name,description'
 * @param $order  排序，例$order='sort desc,update_time desc,id desc'
 * @return array  返回数组
 */
function tag_ad($typeid = '', $limit = '', $where = '', $field = '', $order = '')
{
    // 广告位id
    $typeid = !empty($typeid) ? $typeid : '';
    if(!empty($typeid)){
        $cache_typeid = $typeid;
    }else{
        $cache_typeid = '';
    }
    // limit条数
    $limit = !empty($limit) ? $limit : '10';
    $limit = intval($limit);
    // where条件
    $where = !empty($where) ? $where : array();
    // 拼接缓存名称where
    if (!empty($where)) {
        $cache_where = '';
        if (is_array($where)) {
            // 数组 格式：[['id','in',[9,10,11,12,13]],['title','like','%网站%']]
            foreach ($where as $k => $v) {
                if (is_array($v[2])) {
                    $v[2] = implode('', $v[2]);
                }
                $cache_where .= $v[0] . $v[1] . $v[2];
            }
        } else { //字符串 格式：'id in (1,2,3)'
            $cache_where = str_replace(' ', '', $where); //去掉空格
        }
    } else {
        $cache_where = "*";
    }
    // $order条件
    if (empty($order)) {
        $order = 'sort desc,update_time desc,id desc';
    }
    $cache_order = $order;
    // 拼凑缓存名字
    $cache_name = 'AD_' . $cache_typeid . '_' . $cache_where . '_' . $cache_order;
    $cache_name = str_replace(' ', '', $cache_name); //去掉所有空格
    // 读取缓存数据
    $list = get_cache($cache_name);
    // 字段
    $field = !empty($field) ? $field : true;
    if($typeid){
        $whereArr = [['status', '=', 1], ['typeid', '=', $typeid]];
    }else{
        $whereArr = [['status', '=', 1]];
    }
    $time = time();
    if(!$list){
        $list = Db::name('advert')
        ->field($field)
        ->where($whereArr)
        ->where("timeset=0 or (timeset=1 and starttime<".$time." and endtime>".$time.")")
        ->order($order)
        ->limit($limit)
        ->select()
        ->toArray();
        set_cache($cache_name, $list); //更新缓存
    }
    return $list;
}
/**
 * tag_debris 碎片函数标签，循环读取碎片列表
 * 
 * 用例：{volist name=":tag_debris($typeid = '1', $limit = '', $where = '', $field = '', $order = '')" id="vo" key="k"}
 * 注意如果没有指定key属性的话，默认使用循环变量i，即{$i}从1开始循环自增1的变量。
 * 注意如果要输出数组的索引，可以直接使用key变量，即{$key}和循环变量不同的是，这个key是由数据本身决定，而不是循环控制的
 * {volist name=":tag_debris($typeid = '1')" id="vo" key="k"}
 *    {$k}                            自增变量，从1开始自增1的变量
 *    {$vo.title}                     碎片标题
 *    {$vo.description}               碎片描述
 *    {$vo.content}                   碎片内容
 *    {$vo.link}                      碎片链接
 *    {:get_file_url($vo['image'])} 碎片图片
 *    其它'字段名'可在后台碎片新增或编辑页面查看
 * {/volist}
 * 
 * 参数说明：
 * @param $typeid 碎片位id，例$typeid='1'
 * @param $limit  数据数量，例$limit='10'
 * @param $where  条件，例$where=[['id','in',[1,2,9,11]]]
 * @param $field  字段，例$field='title,description'
 * @param $order  排序，例$order='sort desc,update_time desc,id desc'
 * @return array  返回数组
 */
function tag_debris($typeid = '', $limit = '', $where = '', $field = '', $order = ''){
    // 碎片位id
    $typeid = !empty($typeid) ? $typeid : '';
    if(!empty($typeid)){
        $cache_typeid = $typeid;
    }else{
        $cache_typeid = '';
    }
    // limit条数
    $limit = !empty($limit) ? $limit : '10';
    $limit = intval($limit);
    // where条件
    $where = !empty($where) ? $where : array();
    // 拼接缓存名称where
    if (!empty($where)) {
        $cache_where = '';
        if (is_array($where)) {
            // 数组 格式：[['id','in',[9,10,11,12,13]],['title','like','%网站%']]
            foreach ($where as $k => $v) {
                if (is_array($v[2])) {
                    $v[2] = implode('', $v[2]);
                }
                $cache_where .= $v[0] . $v[1] . $v[2];
            }
        } else { //字符串 格式：'id in (1,2,3)'
            $cache_where = str_replace(' ', '', $where); //去掉空格
        }
    } else {
        $cache_where = "*";
    }
    // $order条件
    if (empty($order)) {
        $order = 'sort desc,update_time desc,id desc';
    }
    $cache_order = $order;
    // 拼凑缓存名字
    $cache_name = 'AD_' . $cache_typeid . '_' . $cache_where . '_' . $cache_order;
    $cache_name = str_replace(' ', '', $cache_name); //去掉所有空格
    // 读取缓存数据
    $list = get_cache($cache_name);
    // 字段
    $field = !empty($field) ? $field : true;
    if($typeid){
        $whereArr = [['status', '=', 1], ['debris_pos_id', '=', $typeid]];
    }else{
        $whereArr = [['status', '=', 1]];
    }
    if(!$list){
        $list = Db::name('debris')
        ->field($field)
        ->where($whereArr)
        ->order($order)
        ->limit($limit)
        ->select()
        ->toArray();
        set_cache($cache_name, $list); //更新缓存
    }
    return $list;
}
/**
 * tag_links 友链函数标签，循环读取友链列表
 * 用例：{volist name=":tag_links($limit = '', $typeid = '1', $show_way = '1')" id="vo" key="k"}
 * 注意如果没有指定key属性的话，默认使用循环变量i，即{$i}从1开始循环自增1的变量。
 * 注意如果要输出数组的索引，可以直接使用key变量，即{$key}和循环变量不同的是，这个key是由数据本身决定，而不是循环控制的
 * {volist name=":tag_links('10','1','1')" id="vo" key="k"}
 *    {$k}                          自增变量，从1开始自增1的变量
 *    {$vo.url}                     链接地址
 *    {$vo.name}                    链接名称
 *    {$vo.description}             链接描述
 *    {:get_file_url($vo['thumb'])} 链接图片
 *    其它'字段名'可在后台链接新增或编辑页面查看
 * {/volist}
 * 参数说明：
 * @param $limit     读取多少条记录，例$limit='10'
 * @param $typeid    链接类型id，例$typeid='1'
 * @param $show_way  显示方式，例：文字链接：$show_way='1'；图片链接：$show_way='2'
 * @return array     返回数组
 */
function tag_links($limit = '', $typeid = '', $show_way = '')
{
    // 读取缓存数据
    $list = get_cache('sys_links_list');
    if (!isset($list[$typeid][$show_way])) {
        if ($typeid) {
            $typeid = intval($typeid);
            $map[] = ['typeid', '=', $typeid];
        }
        $map[] = ['status', '=', 1];
        if ($show_way) {
            $show_way = intval($show_way);
            $map[] = ['show_way', '=', $show_way];
        }
        $linksRes = Db::name('links')
        ->where($map)
        ->order(['sort'=>'desc','update_time'=>'desc','id'=>'desc'])
        ->select()
        ->toArray();
        $list[$typeid][$show_way] = $linksRes;
        set_cache('sys_links_list', $list);
    }
    if (!empty($limit) && is_numeric($limit)) {
        return array_slice($list[$typeid][$show_way], 0, $limit, false);
    }
    return $list[$typeid][$show_way];
}
/**
 * tag_seomenu 多城市优化栏目，开启地区优化必须在适当位置加入标签
 * 
 * 用例：{:tag_seomenu()}
 * 
 * 会循环输出地区栏目
 * @return string 返回字符串
 */
function tag_seomenu()
{
    $str = '';
    $mmap[] = ['ename', '=', 'WEB_SEO_MENU'];
    $cmap[] = ['ename', '=', 'WEB_SEO_CITY'];
    $tpinfo = Db::name('config')->where($mmap)->field('value')->find(); //获取优化栏目
    $cityinfo = Db::name('config')->where($cmap)->field('value')->find(); //获取优化城市
    if ($tpinfo['value'] && $tpinfo['value'] !== 'null') {
        $tid = implode(',', json_decode($tpinfo['value']));
    } else {
        $tid = '';
    }
    if ($tid) {
        $tmap[] = ['status', '=', 1];
        $tmap[] = ['id', 'in', $tid];
        // 获取优化栏目信息
        $arctype = Db::name("arctype")->field("id,typename,typename_en,name")->where($tmap)->order("sort desc,id desc")->select()->toArray();
        if ($arctype) {
            $cid = implode(',', json_decode($cityinfo['value']));
            if ($cid) {
                $ctmap[] = ['id', 'in', $cid];
                // 获取优化城市信息
                $city = Db::name('region')->field('id,shortname,pinyin')->where($ctmap)->select()->toArray();
                if (!get_index_lang()['is_chinese']) {
                    // 非中文访问都是用拼音
                    $cityname = array_column($city, 'pinyin');
                } else {
                    $cityname = array_column($city, 'shortname');
                }
                $citypinyin = array_column($city, 'pinyin');
            } else {
                $cityname = null;
            }
            foreach ($arctype as $vl) {
                if (!empty($cityname)) {
                    if (!get_index_lang()['is_chinese']) {
                        $cityname = array_map("cityname_function", $cityname);
                        $seomenu = array_zuhe(array($cityname, array($vl['typename_en'])));
                    } else {
                        $seomenu = array_zuhe(array($cityname, array($vl['typename'])));
                    }
                    if ($seomenu[0]) {
                        foreach ($seomenu[0] as $k => $mu) {
                            if (!get_index_lang()['is_chinese']) {
                                if (get_one_cache_config('WEB_PATH_PATTERN')) {
                                    if(get_one_cache_config('category_suffix')){
                                        $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $citypinyin[$k] . '/' . $vl['name'], [], get_one_cache_config('category_suffix'),false) . "'>" . $mu . "</a>";
                                    }else{
                                        $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $citypinyin[$k] . '/' . $vl['name'] . '/',[],'',false) . "'>" . $mu . "</a>";
                                    }
                                } else {
                                    if(get_one_cache_config('category_suffix')){
                                        $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $citypinyin[$k] . '/' . $vl['name'], [], get_one_cache_config('category_suffix'), true) . "'>" . $mu . "</a>";
                                    }else{
                                        $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $citypinyin[$k] . '/' . $vl['name'] . '/', [], '', true) . "'>" . $mu . "</a>";
                                    }
                                }
                            } else {
                                if (get_one_cache_config('WEB_PATH_PATTERN')) {
                                    if(get_one_cache_config('category_suffix')){
                                        $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $citypinyin[$k] . '/' . $vl['name'], [], get_one_cache_config('category_suffix'),false) . "'>" . $mu . "</a>";
                                    }else{
                                        $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $citypinyin[$k] . '/' . $vl['name'] . '/',[],'',false) . "'>" . $mu . "</a>";
                                    }
                                } else {
                                    if(get_one_cache_config('category_suffix')){
                                        $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $citypinyin[$k] . '/' . $vl['name'], [], get_one_cache_config('category_suffix'), true) . "'>" . $mu . "</a>";
                                    }else{
                                        $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $citypinyin[$k] . '/' . $vl['name'] . '/', [], '', true) . "'>" . $mu . "</a>";
                                    }
                                }
                            }
                        }
                    }
                } else {
                    if (!get_index_lang()['is_chinese']) {
                        if (get_one_cache_config('WEB_PATH_PATTERN')) {
                            if(get_one_cache_config('category_suffix')){
                                $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $vl['name'] . "/" . $vl['id'], [], get_one_cache_config('category_suffix'),false) . "'>" . $vl['typename_en'] . "</a> ";
                            }else{
                                $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $vl['name'] . "/" . $vl['id'] . '/',[],'',false) . "'>" . $vl['typename_en'] . "</a> ";
                            }
                        } else {
                            if(get_one_cache_config('category_suffix')){
                                $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $vl['name'] . "/" . $vl['id'], [], get_one_cache_config('category_suffix'), true) . "'>" . $vl['typename_en'] . "</a> ";
                            }else{
                                $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $vl['name'] . "/" . $vl['id'] . '/', [], '', true) . "'>" . $vl['typename_en'] . "</a> ";
                            }
                        }
                    } else {
                        if (get_one_cache_config('WEB_PATH_PATTERN')) {
                            if(get_one_cache_config('category_suffix')){
                                $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $vl['name'] . "/" . $vl['id'], [], get_one_cache_config('category_suffix'),false) . "'>" . $vl['typename'] . "</a> ";
                            }else{
                                $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $vl['name'] . "/" . $vl['id'] . '/',[],'',false) . "'>" . $vl['typename'] . "</a> ";
                            }
                        } else {
                            if(get_one_cache_config('category_suffix')){
                                $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $vl['name'] . "/" . $vl['id'], [], get_one_cache_config('category_suffix'), true) . "'>" . $vl['typename'] . "</a> ";
                            }else{
                                $str .= " <a href='" . (string)url(get_index_lang()['lang_url_dir'] . '/' . $vl['name'] . "/" . $vl['id'] . '/', [], '', true) . "'>" . $vl['typename'] . "</a> ";
                            }
                        }
                    }
                }
            }
        }
    }
    return $str;
}
/**
 * [cityname_function 使用array_map英文城市拼音后面加空格]
 * @param  [type] $v [description]
 * @return [type]    [description]
 */
function cityname_function($v)
{
    return $v . " ";
}
/**
 * tag_tag Tag函数标签,循环读取Tag列表
 * 
 * 固定字段用例：{volist name=":tag_tag($limit='5',$where=[['id','in',[1,2,9,11]],['description','<>','']],$field='name,tagurl',$order='id desc')" id="vo" key="k"}
 * 注意如果没有指定key属性的话，默认使用循环变量i，即{$i}从1开始循环自增1的变量。
 * 注意如果要输出数组的索引，可以直接使用key变量，即{$key}和循环变量不同的是，这个key 是由数据本身决定，而不是循环控制的
 * {volist name=":tag_tag($limit='5',$where=[['id','in',[1,2,9,11]],['description','<>','']],$field='',$order='id desc')" id="vo" key="k"}
 *    {$k}                                 自增变量，从1开始自增1的变量
 *    {$vo.id}                             Tag标签id
 *    {$vo.name}                           TAG标签名称
 *    {$vo.tagurl}                         TAG标签地址【特殊拼凑的后台没此字段】
 *    {$vo.status}                         TAG标签状态
 *    {$vo.sort}                           TAG标签排序
 *    {$vo.view}                           TAG标签点击数
 *    其它'字段名'可在后台TAG编辑页面查看
 * {/volist}
 * 
 * 参数说明：
 * $limit    读取多少条记录，例：$limit='10'，如果不填默认10条
 * $where    自定义条件，例：$where=[['id','in',[9,10,11,12,13]]]注意不能带""即不能是"[['id','in',[9,10,11,12,13]]]"是字符串了。
 * $field    字段，读取指定字段，例：$field='id,name,description'，如果不填写将默认获取所有字段
 * $order    排序，例：$order='id desc'或$order='sort desc,id desc'
 * @return array 返回数组
 */
function tag_tag($limit = '', $where = '', $field = '', $order = '')
{
    // limit条数
    $limit = !empty($limit) ? $limit : '10';
    $limit = intval($limit);
    // where条件
    $where = !empty($where) ? $where : array();
    // 拼接缓存名称where
    if (!empty($where)) {
        $cache_where = '';
        if (is_array($where)) {
            // 数组，格式：[['id','in',[9,10,11,12,13]],['title','like','%网站%']]
            foreach ($where as $k => $v) {
                if (is_array($v[2])) {
                    $v[2] = implode('', $v[2]);
                }
                $cache_where .= $v[0] . $v[1] . $v[2];
            }
        } else { //字符串，格式：'id in (1,2,3)'
            $cache_where = str_replace(' ', '', $where); //去掉空格
        }
    } else {
        $cache_where = "*";
    }
    // $order条件
    if (empty($order)) {
        $order = 'sort desc,view desc,update_time desc,id desc';
    }
    $orderArr = explode(',',$order);
    foreach($orderArr as $k=>$v){
        $orderArr[$k] = 't.'.$v;
    }
    $order = implode(',',$orderArr);
    $cache_order = $order;
    // 拼凑缓存名字
    $cache_name = 'TAG_' .$cache_where . '_' . $cache_order;
    $cache_name = str_replace(' ', '', $cache_name); //去掉所有空格
    $list = get_cache($cache_name);
    if (!$list) {
        $map[] = ['t.status','=',1];
        if(get_curr_art_id()){
            $map[] = ['tm.document_id','=',get_curr_art_id()];
            if(get_curr_nav_id()){
                $map[] = ['tm.category_id','=',get_curr_nav_id()];
            }
        }else{
            $typeid = get_curr_nav_id();
            if($typeid){
                // 获取所有子栏目id包含自身-相同模型
                $typeids = getAllChildcateIdsArr_same_model($typeid);
                $map[] = ['tm.category_id', 'in', $typeids];
            }
        }
        $list = Db::name('tag')
        ->alias('t')
        ->join('tagmap tm','t.id=tm.tag_id')
        ->distinct(true)
        ->field(true)
        ->where($where)
        ->where($map)
        ->limit(100)
        ->order($order)
        ->select()
        ->toArray();
        set_cache($cache_name, $list); //更新缓存
    }
    $city = input('city', '');
    $cinfo = '';
    if ($city) {
        $cinfo = get_city_bypinyin($city);
    }
    foreach($list as $k=>$v){
        if ($cinfo && $v) {
            // if (!strstr($v['name'], $cinfo["shortname"])) {
            //     $v['name'] = $cinfo['shortname'] . $v['name'];
            // }
            if (get_one_cache_config('WEB_PATH_PATTERN')) {
                $v['tagurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/tag/" . $v['name'], [], get_one_cache_config('other_suffix','html'), false);
            } else {
                $v['tagurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/tag/" . $v['name'], [], get_one_cache_config('other_suffix','html'), true);
            }
        } else {
            if (get_one_cache_config('WEB_PATH_PATTERN')) {
                $v['tagurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/tag/" . $v['name'], [], get_one_cache_config('other_suffix','html'), false);
            } else {
                $v['tagurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/tag/" . $v['name'], [], get_one_cache_config('other_suffix','html'), true);
            }
        }
        $list[$k] = $v;
    }
    // 限制条数
    if ($limit) {
        $list = array_slice($list, 0, $limit, false);
    }
    if (!empty($field)) {
        $fieldArr = explode(',', $field);
    } else {
        $fieldArr = array();
    }
    // 去掉多余字段
    if (!empty($fieldArr)) {
        foreach ($list as $k => $v) {
            foreach ($v as $k2 => $v2) {
                if (!in_array($k2, $fieldArr)) {
                    unset($list[$k][$k2]);
                }
            }
        }
    }
    return $list;
}
// 更多tag
function tag_all_tag()
{
    $city = input('city', '');
    $cinfo = '';
    if ($city) {
        $cinfo = get_city_bypinyin($city);
    }
    if ($cinfo) {
        if (get_one_cache_config('WEB_PATH_PATTERN')) {
            $vtagurl = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/tag", [], get_one_cache_config('other_suffix','html'), false);
        } else {
            $tagurl = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/tag", [], get_one_cache_config('other_suffix','html'), true);
        }
    } else {
        if (get_one_cache_config('WEB_PATH_PATTERN')) {
            $tagurl = (string)url(get_index_lang()['lang_url_dir'] . "/tag", [], get_one_cache_config('other_suffix','html'), false);
        } else {
            $tagurl = (string)url(get_index_lang()['lang_url_dir'] . "/tag", [], get_one_cache_config('other_suffix','html'), true);
        }
    }
    return $tagurl;
}
/**
 * get_tag 获取指定tag信息函数标签
 * 
 * 固定字段用例：{:get_tag('标签名称','字段名')}
 * {:get_nav('标签名称','tagurl')}         Tag标签地址【特殊拼凑的后台没此字段】
 * {:get_nav('标签名称','seo_title')}      Tag标签seo标题
 * 其它'字段名'可在后台Tag标签编辑页面查看
 * 
 * 参数说明：
 * @param  $name             tag标签名称    
 * @param  $field            tag标签字段，如果为null就获取一条栏目记录的所有字段值return array，如果不为空则获取单个字段值return string
 * @return array or string   返回数组或字符串
 */
function get_tag($name='',$field=null)
{
    // 判断是否查找栏目地址
    if ($field == 'tagurl') {
        $_field = 'name';
    } else {
        $_field = $field;
    }
    $city = input('city', '');
    $cinfo = '';
    if ($city) {
        $cinfo = get_city_bypinyin($city);
    }
    if(!$name){
        if ($cinfo) {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
               return (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/tag", [], get_one_cache_config('other_suffix','html'), false);
            } else { //绝对路径，带域名的
                return (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/tag", [], get_one_cache_config('other_suffix','html'), true);
            }
        } else {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                return (string)url(get_index_lang()['lang_url_dir'] . "/tag", [], get_one_cache_config('other_suffix','html'), false);
            } else { //绝对路径，带域名的
                return (string)url(get_index_lang()['lang_url_dir'] . "/tag", [], get_one_cache_config('other_suffix','html'), true);
            }
        }
    }
    $cache_name = md5($name);
    $info = get_cache($cache_name);
    if(!$info){
        $map[] = ['name','=',$name];
        $info = Db::name('tag')->where($map)->find();
        set_cache($cache_name,$info);
    }
    // 获取所有字段
    if (is_null($field) && $info) {
        // 获取tag名称
        // if ($cinfo && isset($info['name']) && !strstr($info['name'], $cinfo["shortname"])) {
        //     $info['name'] = $cinfo['shortname'] . $info['name'];
        // }
        // 获取tag地址tagurl
        if ($cinfo) {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                $info['tagurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/tag/" . $info['name'], [], get_one_cache_config('other_suffix','html'), false);
            } else { //绝对路径，带域名的
                $info['tagurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/tag/" . $info['name'], [], get_one_cache_config('other_suffix','html'), true);
            }
        } else {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                $info['tagurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/tag/" . $info['name'], [], get_one_cache_config('other_suffix','html'), false);
            } else { //绝对路径，带域名的
                $info['tagurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/tag/" . $info['name'], [], get_one_cache_config('other_suffix','html'), true);
            }
        }
    } elseif ($field == 'tagurl' && $info) { //单获取tag地址tagurl
        if ($cinfo) {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                $info = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/tag/" . $info['name'], [], get_one_cache_config('other_suffix','html'), false);
            } else { //绝对路径，带域名的
                $info = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/tag/" . $info['name'], [], get_one_cache_config('other_suffix','html'), true);
            }
        } else {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                $info = (string)url(get_index_lang()['lang_url_dir'] . "/tag/" . $info['name'], [], get_one_cache_config('other_suffix','html'), false);
            } else { //绝对路径，带域名的
                $info = (string)url(get_index_lang()['lang_url_dir'] . "/tag/" . $info['name'], [], get_one_cache_config('other_suffix','html'), true);
            }
        }
    }else{
        $info = isset($info[$field])?$info[$field]:'';
    }
    return $info;
}
/**
 * tag_nav 导航(栏目)函数标签,循环读取导航(栏目)列表
 * 
 * 固定字段用例：{volist name=":tag_nav($typeid = '', $type = 'top', $thisclass = 'on',$where='', $level = '', $field = '', $limit = '', $order = '')" id="vo" key="k"}
 * 注意如果没有指定key属性的话，默认使用循环变量i，即{$i}从1开始循环自增1的变量。
 * 注意如果要输出数组的索引，可以直接使用key变量，即{$key}和循环变量不同的是，这个key 是由数据本身决定，而不是循环控制的
 * {volist name=":tag_nav($typeid = '', $type = 'top', $thisclass = 'on',$where='', $level = '', $field = '', $limit = '', $order = '')" id="vo" key="k"}
 *    {$k}                                 自增变量，从1开始自增1的变量
 *    {$vo.id}                             栏目id
 *    {$vo.typename}                       栏目名称
 *    {$vo.typename_en}                    栏目英文名称
 *    {$vo.name}                           栏目标识
 *    {$vo.seotitle}                       栏目seo标题
 *    {$vo.seotitle_en}                    栏目英文seo标题
 *    {$vo.keywords}                       栏目关键词
 *    {$vo.keywords_en}                    栏目英文关键词
 *    {$vo.description}                    栏目描述
 *    {$vo.description_en}                 栏目英文描述
 *    {$vo.content}                        栏目内容
 *    {$vo.content_en}                     栏目英文内容
 *    {$vo.create_time|date="Y-m-d H:i:s"} 栏目创建时间
 *    {$vo.update_time|date="Y-m-d H:i:s"} 栏目更新时间
 *    其它'字段名'可在后台文档新增或编辑页面查看
 *    {$vo.thisclass}                      栏目选择中样式默认为空【特殊拼凑的后台没此字段】
 *    {$vo.typeurl}                        栏目地址【特殊拼凑的后台没此字段】
 * 
 *    {$vo.children}                       栏目的子栏目数组array【特殊拼凑的后台没此字段】
 *    {volist name="$vo['children']" id="vo2"}
 *       {$vo2.栏目字段名}
 *       同理......
 *    {/volist}
 * 
 *    单文件、单视频、单文件的路径获取
 *    {:get_file_url($vo['字段名'])}
 * 
 *    多图片、多视频、多文件的路径获取
 *    {volist name=":get_file_url($vo['字段名'],2)" id="info"}
 *       {$info}
 *    {/volist}
 * {/volist}
 * 
 * 参数说明：
 * $typeid    栏目id或栏目标识name字符串，例$typeid='1,3' 或 $typeid='product,news'等，如果不填获取所有栏目
 * $type      栏目类型：顶级栏目top或子栏目son，例：$type='top'或$type='son'
 * $thisclass 样式代码，例：$thisclass='on'
 * $where     自定义条件，例：$where=[['id','in',[9,10,11,12,13]]]注意不能带""即不能是"[['id','in',[9,10,11,12,13]]]"是字符串了。
 * $level     获取多少级栏目，例：$level='3'，如果不填默认获取3级栏目导航
 * $field     字段，读取指定字段，例：$field='id,title,content'，如果不填写将默认获取所有字段
 * $limit     读取多少条记录，例：$limit='10'，限制多少个顶级栏目，如果不填默认获取所有一级栏目
 * $order     排序，例：$order='id desc'或$order='sort desc,id desc'
 * @return array 返回数组
 */
function tag_nav($typeid = '', $type = '', $thisclass = '', $where = '', $level = '', $field = '', $limit = '', $order = '')
{
    $type = !empty($type) ? $type : 'top';
    $thisclass = !empty($thisclass) ? $thisclass : '';
    $where = !empty($where) ? $where : array();
    $level = !empty($level) ? $level : '3';
    $field = !empty($field) ? $field : true;
    $order = !empty($order) ? $order : 'sort desc,id asc';
    $limit = !empty($limit) ? $limit : '';
    $limit = intval($limit);
    $level = intval($level);
    // 获取选择栏目id字符串
    if (!empty($typeid)) {
        $typeidArr = explode(',', $typeid);
        foreach ($typeidArr as $k => $v) {
            if (!is_numeric($v)) {
                $typeidArr[$k] = get_category_byname($v, 'id'); //通过栏目标识获取栏目id
            }
        }
        $typeid = implode(',', $typeidArr);
    }
    $currTopCateId = get_top_nav_id(); //获取顶级栏目id
    $currid = get_curr_nav_id(); //获取当前栏目id
    if (!empty($typeid)) {
        // 判断要查找的栏目 为空表示查询所有
        $typeid = explode(",", $typeid);
        if (!empty($type) && $type == 'son') {
            // 判断查询其子栏目还是所选栏目
            $map[] = ["pid", "in", $typeid];
        } else {
            $map[] = ["id", "in", $typeid];
        }
    } else {
        // 为空表示查询所有顶级栏目
        $map[] = ["pid", "=", 0];
    }
    // 状态
    $map[] = ["status", "=", 1];
    // 拼接缓存名称cache_typeid
    if (is_array($typeid)) {
        $cache_typeid = implode(',', $typeid);
    } else {
        $cache_typeid = $typeid;
    }
    // 拼接缓存名称cache_where
    if (!empty($where)) {
        $cache_where = '';
        foreach ($where as $k => $v) {
            if (is_array($v[2])) {
                $v[2] = implode(',', $v[2]);
            }
            $cache_where .= $v[0] . $v[1] . $v[2];
        }
    } else {
        $cache_where = "*";
    }
    $tag_nav_cache_name = "tag_nav_" . $cache_typeid . "*_" . $type . "*_" . $cache_where . "*_" . $field . "*_" . $order;
    $list = get_cache($tag_nav_cache_name);
    if (!$list) {
        $list = Db::name("arctype")->field($field)->where($map)->where($where)->order($order)->select()->toArray();
        set_cache($tag_nav_cache_name, $list); //更新缓存
    }
    if (!empty($limit) && !is_numeric($list)) {
        $list = array_slice($list, 0, $limit, false);
    }
    //获取城市信息
    $city = input('city', '');
    $cinfo = '';
    if ($city) {
        $cinfo = get_city_bypinyin($city);
    }
    foreach ($list as $k => $v) {
        if ($v['id'] == $currTopCateId || $v['id'] == $currid || in_array($currid, getAllChildcateIdsArr($v['id']))) {
            $v['thisclass'] = $thisclass;
        } else {
            $v['thisclass'] = '';
        }
        // 获取栏目中文typename
        if ($cinfo && isset($v['typename']) && !strstr($v['typename'], $cinfo["shortname"])) {
            $v['typename'] = $cinfo['shortname'] . $v['typename'];
        }
        // 获取栏目英文名称typename_en
        if ($cinfo && isset($v['typename_en']) && !empty($v['typename_en']) && !strstr($v['typename_en'], $cinfo["pinyin"])) {
            $v['typename_en'] = $cinfo['pinyin'] . ' ' . $v['typename_en'];
        }
        // 获取栏目地址typeurl
        if ($cinfo && $v) {
            if (get_one_cache_config('WEB_PATH_PATTERN')) {
                if(get_one_cache_config('category_suffix')){
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v['name'], [], get_one_cache_config('category_suffix'), false);
                }else{
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v['name'] . "/", [], "", false);
                }
            } else {
                if(get_one_cache_config('category_suffix')){
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v['name'], [], get_one_cache_config('category_suffix'), true);
                }else{
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v['name'] . "/", [], "", true);
                }
            }
        } else {
            if (get_one_cache_config('WEB_PATH_PATTERN')) {
                if(get_one_cache_config('category_suffix')){
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v['name'], [], get_one_cache_config('category_suffix'), false);
                }else{
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v['name'] . "/", [], "", false);
                }
            } else {
                if(get_one_cache_config('category_suffix')){
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v['name'], [], get_one_cache_config('category_suffix'), true);
                }else{
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v['name'] . "/", [], "", true);
                }
            }
        }
        $v['children'] = array(); //先设置为空数组
        $list[$k] = $v;
    }
    if ($level > 1) {
        $list = level_nav($list, $level, $currid, $thisclass, $where, $cache_where, $field, $order);
    }
    return $list;
}
/**
 * [level_nav 获取多级栏目信息]
 * @param  [type] $list      [一级栏目数据]
 * @param  [type] $level     [级别数]
 * @param  [type] $currid    [当前栏目ID]
 * @param  [type] $thisclass [样式]
 * @param  [type] $where     [自定义条件]
 * @param  [type] $field     [要查询的字段]
 * @param  [type] $order     [排序]
 * @return [type]            [array]
 */
function level_nav($list, $level, $currid, $thisclass, $where, $cache_where, $field, $order)
{
    foreach ($list as $k => $v) {
        $level_nav_cache_name = "level_nav_" . $v['id'] . "*_" . $cache_where . "*_" . $field . "*_" . $order;
        $children = get_cache($level_nav_cache_name);
        if (!$children) {
            $children = Db::name("arctype")->field($field)->where('pid', $v['id'])->where('status', 1)->where($where)->order($order)->select()->toArray();
            set_cache($level_nav_cache_name, $children); //更新缓存
        }
        // 获取城市信息
        $city = input('city', '');
        $cinfo = '';
        if ($city) {
            $cinfo = get_city_bypinyin($city);
        }
        foreach ($children as $k2 => $v2) {
            if ($v2['id'] == $currid || in_array($currid, getAllChildcateIdsArr($v2['id']))) {
                $v2['thisclass'] = $thisclass;
            } else {
                $v2['thisclass'] = '';
            }
            // 获取栏目中文名称typename
            if ($cinfo && isset($v2['typename']) && !strstr($v2['typename'], $cinfo["shortname"])) {
                $v2['typename'] = $cinfo['shortname'] . $v2['typename'];
            }
            // 获取栏目英文名称typename_en
            if ($cinfo && isset($v2['typename_en']) && !empty($v2['typename_en']) && !strstr($v2['typename_en'], $cinfo["pinyin"])) {
                $v2['typename_en'] = $cinfo['pinyin'] . ' ' . $v2['typename_en'];
            }
            // 获取栏目地址typeurl
            if ($cinfo && $v2) {
                if (get_one_cache_config('WEB_PATH_PATTERN')) {
                    if(get_one_cache_config('category_suffix')){
                        $v2['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v2['name'], [], get_one_cache_config('category_suffix'), false);
                    }else{
                        $v2['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v2['name'] . "/", [], "", false);
                    }
                } else {
                    if(get_one_cache_config('category_suffix')){
                        $v2['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v2['name'], [], get_one_cache_config('category_suffix'), true);
                    }else{
                        $v2['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v2['name'] . "/", [], "", true);
                    }
                }
            } else {
                if (get_one_cache_config('WEB_PATH_PATTERN')) {
                    if(get_one_cache_config('category_suffix')){
                        $v2['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v2['name'], [], get_one_cache_config('category_suffix'), false);
                    }else{
                        $v2['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v2['name'] . "/", [], "", false);
                    }
                } else {
                    if(get_one_cache_config('category_suffix')){
                        $v2['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v2['name'], [], get_one_cache_config('category_suffix'), true);
                    }else{
                        $v2['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v2['name'] . "/", [], "", true);
                    }
                }
            }
            $v2['children'] = array(); //先设置为空数组
            $children[$k2] = $v2;
        }
        $list[$k]['children'] = $children;
        if ($level > 2) {
            $list[$k]['children'] = level_nav($children, $level - 1, $currid, $thisclass, $where, $cache_where, $field, $order);
        }
    }
    return $list;
}
/**
 * tag_doc 文档函数标签,循环读取文档列表
 * 
 * 固定字段用例：{volist name=":tag_doc($typeid='3',$limit='5',$where=[['id','in',[1,2,9,11]],['content','<>','']],$flags='a',$field='title,typeurl,arturl',$order='id desc',$titlelen='10',$desclen ='10')" id="vo" key="k"}
 * 注意如果没有指定key属性的话，默认使用循环变量i，即{$i}从1开始循环自增1的变量。
 * 注意如果要输出数组的索引，可以直接使用key变量，即{$key}和循环变量不同的是，这个key 是由数据本身决定，而不是循环控制的
 * {volist name=":tag_doc($typeid='3',$limit='5',$where=[['id','in',[1,2,9,11]],['content','<>','']],$flags='a',$field='',$order='id desc',$titlelen='10',$desclen ='10')" id="vo" key="k"}
 *    {$k}                                 自增变量，从1开始自增1的变量
 *    {$vo.category_id}                    文档所属栏目id
 *    {$vo.id}                             文档id
 *    {$vo.title}                          文档标题，可使用{$vo.title|cut_str=###,10}或{:cut_str($vo['title'],10)}截取长度
 *    {$vo.title_en}                       文档英文标题
 *    {$vo.description}                    文档描述
 *    {$vo.description_en}                 文档英文描述
 *    {$vo.create_time|date="Y-m-d H:i:s"} 文档创建时间
 *    {$vo.update_time|date="Y-m-d H:i:s"} 文档更新时间
 *    {$vo.status}                         文档状态
 *    {$vo.sort}                           文档排序
 *    {$vo.name}                           文档所属栏目标识【表连接查询获取的字段】
 *    {$vo.typename}                       文档所属栏目名称【表连接查询获取的字段】
 *    {$vo.typename_en}                    文档所属栏目英文名称【表连接查询获取的字段】
 *    {$vo.typeurl}                        文档所属栏目地址【特殊拼凑的后台没此字段】
 *    {$vo.arturl}                         文档地址【特殊拼凑的后台没此字段】
 *    其它'字段名'可在后台文档新增或编辑页面查看
 * 
 *    单文件、单视频、单文件的路径获取
 *    {:get_file_url($vo['文档字段'])}
 * 
 *    多图片、多视频、多文件的路径获取
 *    {volist name=":get_file_url($vo['文档字段'],2)" id="info"}
 *       {$info}
 *    {/volist}
 * {/volist}
 * 
 * 参数说明：
 * $typeid   栏目id或栏目标识name，例$typeid='1'或$typeid='product'等，如果不填默认为当前栏目id
 * $limit    读取多少条记录，例：$limit='10'，如果不填默认10条
 * $where    自定义条件，例：$where=[['id','in',[9,10,11,12,13]]]注意不能带""即不能是"[['id','in',[9,10,11,12,13]]]"是字符串了。
 * $flags    自定义属性，例：$flags='a'特推
 * $field    字段，读取指定字段，例：$field='id,title,content'，如果不填写将默认获取所有字段
 * $order    排序，例：$order='id desc'或$order='sort desc,id desc'，浏览量排序(热点)$order='view desc'
 * $titlelen 标题指定长度，例：$titlelen='10'
 * $desclen  描述指定长度，例：$desclen='10'
 * @return array 返回数组
 */
function tag_doc($typeid = '', $limit = '', $where = '', $flags = '', $field = '', $order = '', $titlelen = '', $desclen = '')
{
    // 栏目id，如果不输入栏目，即默认当前栏目
    $typeid = !empty($typeid) ? $typeid : get_curr_nav_id();
    if (!is_numeric($typeid)) {
        $typeid = get_category_byname($typeid, 'name');
    }
    $cache_typeid = $typeid;
    // 根据栏目id获取模型表信息
    $model_table_info = get_document_table_info($typeid);
    if (!$model_table_info['table_name']) {
        return array();
    }
    // 获取所有子栏目id包含自身-相同模型
    $typeids = getAllChildcateIdsArr_same_model($typeid);
    $map[] = ['category_id', 'in', $typeids];
    // 状态
    $map[] = ['status', '=', 1];
    // limit条数
    $limit = !empty($limit) ? $limit : '10';
    $limit = intval($limit);
    // where条件
    $where = !empty($where) ? $where : array();
    // 拼接缓存名称where
    if (!empty($where)) {
        $cache_where = '';
        if (is_array($where)) {
            // 数组，格式：[['id','in',[9,10,11,12,13]],['title','like','%网站%']]
            foreach ($where as $k => $v) {
                if (is_array($v[2])) {
                    $v[2] = implode('', $v[2]);
                }
                $cache_where .= $v[0] . $v[1] . $v[2];
            }
        } else { //字符串，格式：'id in (1,2,3)'
            $cache_where = str_replace(' ', '', $where); //去掉空格
        }
    } else {
        $cache_where = "*";
    }
    // flags属性
    if ($flags) {
        $fmap = "FIND_IN_SET('$flags',flags)";
        $cache_flags = $flags;
    } else {
        $fmap = array();
        $cache_flags = '*';
    }
    // $order条件
    if (empty($order)) {
        $order = 'sort desc,update_time desc,id desc';
    }
    $cache_order = $order;
    // 拼凑缓存名字
    $cache_name = 'DOCUMENT_' . $cache_typeid . '_' . $cache_where . '_' . $cache_flags . '_' . $cache_order;
    $cache_name = str_replace(' ', '', $cache_name); //去掉所有空格
    // 读取缓存数据
    $list = get_cache($cache_name);
    if (!$list) {
        $list = Db::name($model_table_info['extend_table_name'])->field(true)->where($where)->where($map)->where($fmap)->limit(100)->order($order)->select()->toArray();
        foreach ($list as $k => $v) {
            $list[$k]['name'] = get_category_byid($v['category_id'], 'name');
            $list[$k]['typename'] = get_category_byid($v['category_id'], 'typename');
            $list[$k]['typename_en'] = get_category_byid($v['category_id'], 'typename_en');
        }
        set_cache($cache_name, $list); //更新缓存
    }
    $city = input('city', '');
    $cinfo = '';
    if ($city) {
        $cinfo = get_city_bypinyin($city);
    }
    foreach ($list as $k => $v) {
        // 获取栏目中文名称typename、栏目英文名称typename_en、栏目地址typeurl、文档地址arturl
        if ($cinfo && $v) {
            if (!strstr($v['typename'], $cinfo["shortname"])) {
                $v['typename'] = $cinfo['shortname'] . $v['typename'];
            }
            if (!strstr($v['typename_en'], $cinfo["pinyin"])) {
                $v['typename_en'] = $cinfo['pinyin'] . ' ' . $v['typename_en'];
            }
            if (get_one_cache_config('WEB_PATH_PATTERN')) {
                if(get_one_cache_config('category_suffix')){
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v['name'], [], get_one_cache_config('category_suffix'), false);
                }else{
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v['name'] . '/', [], "", false);
                }
                $v['arturl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v["name"] . "/" . $v['id'], [], get_one_cache_config('article_suffix','html'), false);
            } else {
                if(get_one_cache_config('category_suffix')){
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v['name'], [], get_one_cache_config('category_suffix'), true);
                }else{
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v['name'] . '/', [], "", true);
                }
                $v['arturl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v["name"] . "/" . $v['id'], [], get_one_cache_config('article_suffix','html'), true);
            }
        } else {
            if (get_one_cache_config('WEB_PATH_PATTERN')) {
                if(get_one_cache_config('category_suffix')){
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v['name'], [], get_one_cache_config('category_suffix'), false);
                }else{
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v['name'] . '/', [], "", false);
                }
                $v['arturl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v["name"] . "/" . $v['id'], [], get_one_cache_config('article_suffix','html'), false);
            } else {
                if(get_one_cache_config('category_suffix')){
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v['name'], [], get_one_cache_config('category_suffix'), true);
                }else{
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v['name'] . '/', [], "", true);
                }
                $v['arturl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v["name"] . "/" . $v['id'], [], get_one_cache_config('article_suffix','html'), true);
            }
        }
        // 截取中文标题
        $title = isset($v['title']) ? $v['title'] : '';
        if ($titlelen && is_numeric($titlelen) && isset($v['title'])) {
            $title = mb_substr($v['title'], 0, $titlelen, "utf-8");
        }
        $v['title'] = $title; //文章中文标题
        if ($cinfo && !empty($v['title']) && !strstr($v['title'], $cinfo["shortname"])) {
            $v['title'] = $cinfo['shortname'] . $v['title'];
        }
        // 截取英文标题
        $title_en = isset($v['title_en']) ? $v['title_en'] : '';
        if ($titlelen && is_numeric($titlelen) && isset($v['title_en'])) {
            $title_en = mb_substr($v['title_en'], 0, $titlelen, "utf-8");
        }
        $v['title_en'] = $title_en; //文章英文标题
        if ($cinfo && !empty($v['title_en']) && !strstr($v['title_en'], $cinfo["pinyin"])) {
            $v['title_en'] = $cinfo['pinyin'] . ' ' . $v['title_en'];
        }
        // 截取中文描述
        $description = isset($v['description']) ? $v['description'] : '';
        if ($desclen && is_numeric($desclen) && isset($v['description'])) {
            $description = mb_substr($v['description'], 0, $desclen, "utf-8");
        }
        $v['description'] = $description; //文章中文描述
        // 截取英文描述
        $description_en = isset($v['description_en']) ? $v['description_en'] : '';
        if ($desclen && is_numeric($desclen) && isset($v['description_en'])) {
            $description_en = mb_substr($v['description_en'], 0, $desclen, "utf-8");
        }
        $v['description_en'] = $description_en; //文章英文描述

        $list[$k] = $v;
    }
    // 限制条数
    if ($limit) {
        $list = array_slice($list, 0, $limit, false);
    }
    if (!empty($field)) {
        $fieldArr = explode(',', $field);
    } else {
        $fieldArr = array();
    }
    // 去掉多余字段
    if (!empty($fieldArr)) {
        foreach ($list as $k => $v) {
            foreach ($v as $k2 => $v2) {
                if (!in_array($k2, $fieldArr)) {
                    unset($list[$k][$k2]);
                }
            }
        }
    }
    return $list;
}
/**
 * tag_record 文档浏览记录函数标签，循环读取文档浏览记录列表
 * 
 * 固定字段用例：{volist name=":tag_record('获取记录数')" id="vo" key="k"}
 * 注意如果没有指定key属性的话，默认使用循环变量i，即{$i}从1开始循环自增1的变量。
 * 注意如果要输出数组的索引，可以直接使用key变量，即{$key}和循环变量不同的是，这个key是由数据本身决定，而不是循环控制的
 * {volist name=":tag_record('获取记录数')" id="vo" key="k"}
 *    {$vo.record_time|date="Y-m-d"} 浏览记录时间
 *    {$vo.id}                       文档id
 *    {$vo.category_id}              文档所属栏目id
 *    {$vo.title}                    文档中文标题
 *    {$vo.arturl}                   文档地址arturl
 *    单文件、单视频、单文件的路径获取
 *    {:get_file_url($vo['文档的图片字段'])}
 * {/volist}
 * 
 * 参数说明：
 * @param $limit 获取记录数
 * @return array 返回数组
 */
function tag_record($limit = '')
{
    if (!cookie('browse_records')) {
        return array();
    }
    $browse_records = unserialize(cookie('browse_records'));
    if($browse_records){
        foreach($browse_records as $k=>$v){
            $browse_records[$k] = get_doc($v['category_id'],$v['id']);
        }
        if (!empty($limit) && is_numeric($limit)) {
            return array_slice($browse_records, 0, $limit, false);
        }
    }
    return $browse_records;
}
/**
 * tag_pos 当前位置函数标签，循环读取当前位置列表
 * 
 * 固定字段用例：{volist name=":tag_pos('栏目id或栏目标识name', '栏目字段名,栏目字段名...')" id="vo" key="k"}
 * 注意如果没有指定key属性的话，默认使用循环变量i，即{$i}从1开始循环自增1的变量。
 * 注意如果要输出数组的索引，可以直接使用key变量，即{$key}它和循环变量不同的是，这个key是由数据本身决定，而不是循环控制的
 * {volist name=":tag_pos('88')" id="vo" key="k"}
 *    {$vo.栏目字段名}
 *    {$vo.typeurl} 栏目地址【特殊拼凑的后台没此字段】
 *    其它'栏目字段名'可在后台栏目新增或编辑页面查看
 * 
 *    单文件、单视频、单文件的路径获取
 *    {:get_file_url($vo['icon'])}
 * 
 *    多图片、多视频、多文件的路径获取
 *    {volist name=":get_file_url($vo['picname'],2)" id="info"}
 *       {$info}
 *    {/volist}
 * {/volist}
 * 
 * 参数说明：
 * @param $category_id_or_name 栏目id或栏目标识name
 * @param $field               栏目字段字符串，即多个字段以英文逗号隔开
 * @return array               返回数组
 */
function tag_pos($category_id_or_name = '', $field = '')
{
    if (empty($category_id_or_name)) {
        $category_id_or_name = get_curr_nav_id(); //当前栏目id
    }
    if (!is_numeric($category_id_or_name)) {
        // 根据栏目标识获取栏目id
        $category_id = get_category_byname($category_id_or_name, 'id');
    } else {
        $category_id = intval($category_id_or_name);
    }
    $cache_name = 'POSITION_' . $category_id;
    // 读取缓存数据
    $position = get_cache($cache_name);
    if (empty($position)) {
        $arctype = Db::name('arctype')->field(true)->select()->toArray();
        $tree = new Tree();
        $position = $tree->ParentTree($arctype, $category_id);
        set_cache($cache_name, $position); //更新缓存
    }
    $city = input('city', '');
    $cinfo = '';
    if ($city) {
        $cinfo = get_city_bypinyin($city);
    }
    foreach ($position as $k => $v) {
        // 获取栏目中文名称typename
        if ($cinfo && isset($v['typename']) && !strstr($v['typename'], $cinfo["shortname"])) {
            $v['typename'] = $cinfo['shortname'] . $v['typename'];
        }
        // 获取栏目英文名称typename_en
        if ($cinfo && isset($v['typename_en']) && !empty($v['typename_en']) && !strstr($v['typename_en'], $cinfo["pinyin"])) {
            $v['typename_en'] = $cinfo['pinyin'] . ' ' . $v['typename_en'];
        }
        // 获取栏目地址typeurl
        if ($cinfo && $v) {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v['name'], [], get_one_cache_config('category_suffix'), false);   
                }else{ //栏目地址不带后缀
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v['name'] . '/', [], "", false);   
                }
            } else { //绝对路径，带域名的
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v['name'], [], get_one_cache_config('category_suffix'), true);
                }else{ //栏目地址不带后缀
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $v['name'] . '/', [], "", true);   
                }
            }
        } else {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v['name'], [], get_one_cache_config('category_suffix'), false);
                }else{ //栏目地址不带后缀
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v['name'] . '/', [], "", false);   
                }
            } else { //绝对路径，带域名的
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v['name'], [], get_one_cache_config('category_suffix'), true);
                }else{ //栏目地址不带后缀
                    $v['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $v['name'] . '/', [], "", true);   
                }
            }
        }
        $position[$k] = $v;
    }
    // 去掉多余字段
    if (!empty($field)) { //获取指定字段的值
        $fieldArr = explode(',', $field);
        foreach ($position as $k => $v) {
            foreach ($v as $k2 => $v2) {
                if (!in_array($k2, $fieldArr)) {
                    unset($position[$k][$k2]);
                }
            }
        }
    }
    return $position;
}
/**
 * [get_top_nav_id 获取当前栏目的顶级栏目id]
 * 用例：{:get_top_nav_id()}
 * @return [type] [description]
 */
function get_top_nav_id()
{
    return get_top_Cateid();
}
/**
 * [get_top_nav_name 获取当前栏目的顶级栏目标识name]
 * 用例：{:get_top_nav_name()}
 * @return [type] [description]
 */
function get_top_nav_name(){
    return get_nav(get_top_nav_id(),'name');
}
/**
 * [get_curr_nav_id 获取当前栏目id]
 * 用例：{:get_curr_nav_id()}
 * @return [type] [description]
 */
function get_curr_nav_id()
{
    return get_cate_art()['cateid'];
}
/**
 * [get_curr_nav_name 获取当前栏目标识name]
 * 用例：{:get_curr_nav_name()}
 * @return [type] [description]
 */
function get_curr_nav_name()
{
    return get_nav(get_curr_nav_id(),'name');
}
/**
 * [get_curr_art_id 获取当前文档id]
 * 用例：{:get_curr_art_id()}
 * @return [type] [description]
 */
function get_curr_art_id()
{
    return get_cate_art()['artid'];
}
/**
 * get_nav 获取指定栏目信息函数标签
 * 
 * 固定字段用例：{:get_nav('栏目id或栏目标识name','字段名')}
 * {:get_nav('1','typeurl')}                         栏目地址【特殊拼凑的后台没此字段】
 * {:get_nav('1','typename')}                        栏目名称
 * {:get_nav('1','typename_en')}                     栏目英文名称
 * {:get_nav('1','name')}                            栏目标识
 * {:get_nav('1','seotitle')}                        栏目seo标题
 * {:get_nav('1','seotitle_en')}                     栏目英文seo标题
 * {:get_nav('1','keywords')}                        栏目关键词
 * {:get_nav('1','keywords_en')}                     栏目英文关键词
 * {:get_nav('1','description')}                     栏目描述
 * {:get_nav('1','description_en')}                  栏目英文描述
 * {:get_nav('1','content')}                         栏目内容
 * {:get_nav('1','content_en')}                      栏目英文内容
 * {:date('Y-m-d H:i:s',get_nav('1','create_time'))} 栏目创建时间
 * {:date('Y-m-d H:i:s',get_nav('1','update_time'))} 栏目更新时间
 * 其它'字段名'可在后台栏目新增或编辑页面查看
 * 
 * 单文件、单视频、单文件的路径获取
 * {:get_file_url(get_nav('栏目id或栏目标识name','字段名'))}
 * 
 * 多图片、多视频、多文件的路径获取
 * {volist name=":get_file_url(get_nav('栏目id或栏目标识name','字段名'),2)" id="info"}
 *    {$info}
 * {/volist}
 * 
 * 参数说明：
 * @param  $category_id_or_name 栏目id或栏目标识name，如果为空就默认是当前栏目id
 * @param  $field               栏目字段，如果为null就获取一条栏目记录的所有字段值return array，如果不为空则获取单个字段值return string
 * @return array or string      返回数组或字符串
 */
function get_nav($category_id_or_name = '', $field = null)
{
    $info = '';
    // 判断是否查找栏目地址
    if ($field == 'typeurl') {
        $_field = 'name';
    } else {
        $_field = $field;
    }
    if (empty($category_id_or_name)) {
        // 当前栏目id
        $category_id_or_name = get_curr_nav_id();
    }
    if (is_numeric($category_id_or_name)) {
        // 根据栏目id获取栏目某字段信息
        $info = get_category_byid($category_id_or_name, $_field);
    } else {
        // 根据栏目标识获取栏目某字段信息
        $info = get_category_byname($category_id_or_name, $_field);
    }
    $city = input('city', '');
    $cinfo = '';
    if ($city) {
        $cinfo = get_city_bypinyin($city);
    }
    // 获取所有字段
    if (is_null($field) && $info) {
        // 获取栏目中文名称typename
        if ($cinfo && isset($info['typename']) && !strstr($info['typename'], $cinfo["shortname"])) {
            $info['typename'] = $cinfo['shortname'] . $info['typename'];
        }
        // 获取栏目英文名称typename_en
        if ($cinfo && isset($info['typename_en']) && !empty($info['typename_en']) && !strstr($info['typename_en'], $cinfo["pinyin"])) {
            $info['typename_en'] = $cinfo['pinyin'] . ' ' . $info['typename_en'];
        }
        // 获取栏目地址typeurl
        if ($cinfo) {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $info['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $info['name'], [], get_one_cache_config('category_suffix'), false);
                }else{ //栏目地址不带后缀
                    $info['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $info['name'] . '/', [], "", false);   
                }
            } else { //绝对路径，带域名的
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $info['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $info['name'], [], get_one_cache_config('category_suffix'), true);
                }else{ //栏目地址不带后缀
                    $info['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $info['name'] . '/', [], "", true);   
                }
            }
        } else {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $info['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $info['name'], [], get_one_cache_config('category_suffix'), false); //不带域名的
                }else{ //栏目地址不带后缀
                    $info['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $info['name'] . '/', [], "", false); //不带域名的   
                }
            } else { //绝对路径，带域名的
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $info['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $info['name'], [], get_one_cache_config('category_suffix'), true); //带域名的
                }else{ //栏目地址不带后缀
                    $info['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $info['name'] . '/', [], "", true); //带域名的   
                }
            }
        }
    } elseif ($field == 'typename' && $info) { //单获取栏目中文名称typename
        if ($cinfo && !strstr($info, $cinfo["shortname"])) {
            $info = $cinfo['shortname'] . $info;
        }
    } elseif ($field == 'typename_en' && $info) { //单获取栏目英文名称typename_en
        if ($cinfo && !strstr($info, $cinfo["pinyin"])) {
            $info = $cinfo['pinyin'] . ' ' . $info;
        }
    } elseif ($field == 'typeurl' && $info) { //单获取栏目地址typeurl
        if ($cinfo) {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $info = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $info, [], get_one_cache_config('category_suffix'), false);
                }else{ //栏目地址不带后缀
                    $info = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $info . '/', [], "", false);   
                }
            } else { //绝对路径，带域名的
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $info = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $info, [], get_one_cache_config('category_suffix'), true);
                }else{ //栏目地址不带后缀
                    $info = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $info . '/', [], "", true);   
                }
            }
        } else {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $info = (string)url(get_index_lang()['lang_url_dir'] . "/" . $info, [], get_one_cache_config('category_suffix'), false);
                }else{ //栏目地址不带后缀
                    $info = (string)url(get_index_lang()['lang_url_dir'] . "/" . $info . '/', [], "", false);   
                }
            } else { //绝对路径，带域名的
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $info = (string)url(get_index_lang()['lang_url_dir'] . "/" . $info, [], get_one_cache_config('category_suffix'), true);
                }else{ //栏目地址不带后缀
                    $info = (string)url(get_index_lang()['lang_url_dir'] . "/" . $info . '/', [], "", true);   
                }
            }
        }
    }
    return $info;
}
/**
 * get_doc 获取指定文档信息函数标签
 * 
 * 固定字段用例：{:get_doc('栏目id或栏目标识name','文档id','字段名')}
 * 文档所属栏目id：{:get_doc('1','5','category_id')}
 * 文档中文标题：{:get_doc('1','5','title')}
 * 文档英文标题：{:get_doc('1','5','title_en')}
 * 文档创建时间：{:date('Y-m-d H:i:s',get_doc('1','5','create_time'))}
 * 文档更新时间：{:date('Y-m-d H:i:s',get_doc('1','5','update_time'))}
 * 文档状态：{:get_doc('1','5','status')}
 * 文档排序：{:get_doc('1','5','sort')}
 * 文档所属栏目标识【表连接查询获取的字段】：{:get_doc('1','5','name')}
 * 文档所属栏目中文名称【表连接查询获取的字段】：{:get_doc('1','5','typename')}
 * 文档所属栏目英文名称【表连接查询获取的字段】：{:get_doc('1','5','typename_en')}
 * 文档所属栏目地址【特殊拼凑的后台没此字段】：{:get_doc('1','5','typeurl')}
 * 文档地址【特殊拼凑的后台没此字段】：{:get_doc('1','5','arturl')}
 * 其它'字段名'可在后台文档新增或编辑页面查看
 * 
 * 单文件、单视频、单文件的路径获取
 * {:get_file_url(get_doc('栏目id或栏目标识name','文档id','文档字段'))}
 * 
 * 多图片、多视频、多文件的路径获取
 * {volist name=":get_file_url(get_doc('栏目id或栏目标识name','文档id','文档字段'),2)" id="info"}
 *    {$info}
 * {/volist}
 * 
 * 参数说明：
 * @param  $category_id_or_name 栏目id或栏目标识name，如果为空就默认是当前栏目id
 * @param  $document_id         文档id，如果为空默认是当前文档id
 * @param  $field               文档字段，如果为null就获取一条文档记录的所有字段值return array，如果不为空则获取单个字段值return string
 * @return array or string      返回数组或字符串
 */
function get_doc($category_id_or_name = '', $document_id = '', $field = null)
{
    if (empty($category_id_or_name) || empty($document_id)) {
        $category_id_or_name = get_curr_nav_id(); //当前栏目id
        $document_id = get_curr_art_id(); //当前文档id
    }
    // 获取栏目ID
    if (!is_numeric($category_id_or_name)) {
        $category_id = get_category_byname($category_id_or_name, 'id'); //根据栏目标识获取栏目ID
    } else {
        $category_id = $category_id_or_name; //获取栏目ID
    }
    // 缓存名称
    $cache_name = 'DOCUMENT' . '_' . $category_id . '_' . $document_id;
    // 读取缓存数据
    $document = get_cache($cache_name);
    // 获取数据
    if (empty($document)) {
        // 根据栏目ID获取表名信息array
        $model_table_info = get_document_table_info($category_id);
        if (!$model_table_info['table_name']) {
            // 模型表不存在
            return is_null($field)?[]:'';
        }
        if ($model_table_info['extend']) {
            // 非独立模型
            $extend_info = Db::name($model_table_info['extend_table_name'])
            ->alias('d')
            ->field('d.*,c.name,c.typename,c.typename_en')
            ->join('arctype c', 'c.id=d.category_id')
            ->find($document_id); //基础信息
            $info = Db::name($model_table_info['table_name'])->field(true)->find($document_id); //扩展信息
            if (!$extend_info) {
                $extend_info = array();
            }
            if (!$info) {
                $info = array();
            }
            $document = array_merge($extend_info, $info);
        } else {
            // 独立模型
            $document = Db::name($model_table_info['table_name'])
            ->alias('d')
            ->field('d.*,c.name,c.typename,c.typename_en')
            ->join('arctype c', 'c.id=d.category_id')
            ->where('d.status', 1)
            ->find($document_id);
        }
        if ($document && $document['status'] == 0) {
            $document = [];
        }
        set_cache($cache_name, $document); //更新缓存
    }
    // 拼凑数据，获取城市信息
    $city = input('city', '');
    $cinfo = '';
    if ($city) {
        $cinfo = get_city_bypinyin($city);
    }
    if ($document) {
        // 获取栏目中文名称typename
        if ($cinfo && isset($document['typename']) && !strstr($document['typename'], $cinfo["shortname"])) {
            $document['typename'] = $cinfo['shortname'] . $document['typename'];
        }
        // 获取栏目英文名称typename_en
        if ($cinfo && isset($document['typename_en']) && !strstr($document['typename_en'], $cinfo["pinyin"])) {
            $document['typename_en'] = $cinfo['pinyin'] . ' ' . $document['typename_en'];
        }
        // 获取文档中文标题title
        if ($cinfo && isset($document['title']) && !strstr($document['title'], $cinfo["shortname"])) {
            $document['title'] = $cinfo['shortname'] . $document['title'];
        }
        // 获取文档英文标题title_en
        if ($cinfo && isset($document['title_en']) && !strstr($document['title_en'], $cinfo["pinyin"])) {
            $document['title_en'] = $cinfo['pinyin'] . ' ' . $document['title_en'];
        }
        // 获取栏目地址typeurl、文档地址arturl
        if ($cinfo) {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                // 栏目地址typeurl
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $document['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $document['name'], [], get_one_cache_config('category_suffix'), false);
                }else{ //栏目地址不带后缀
                    $document['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $document['name'] . '/', [], "", false);
                }
                // 文档地址arturl
                $document['arturl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $document["name"] . "/" . $document['id'], [], get_one_cache_config('article_suffix','html'), false);
            } else { //绝对路径，带域名的
                // 栏目地址typeurl
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $document['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $document['name'], [], get_one_cache_config('category_suffix'), true);
                }else{ //栏目地址不带后缀
                    $document['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $document['name'] . '/', [], "", true);   
                }
                // 文档地址arturl
                $document['arturl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $cinfo["pinyin"] . "/" . $document["name"] . "/" . $document['id'], [], get_one_cache_config('article_suffix','html'), true);
            }
        } else {
            if (get_one_cache_config('WEB_PATH_PATTERN')) { //相对路径，不带域名的
                // 栏目地址typeurl
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $document['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $document['name'], [], get_one_cache_config('category_suffix'), false);
                }else{ //栏目地址不带后缀
                    $document['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $document['name'].'/', [], "", "");   
                }
                // 文档地址arturl
                $document['arturl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $document["name"] . "/" . $document['id'], [], get_one_cache_config('article_suffix','html'), false);
            } else { //绝对路径，带域名的
                // 栏目地址typeurl
                if(get_one_cache_config('category_suffix')){ //栏目地址带后缀
                    $document['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $document['name'], [], get_one_cache_config('category_suffix'), true);
                }else{ //栏目地址不带后缀
                    $document['typeurl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $document['name'] . '/', [], "", true);
                }
                // 文档地址arturl
                $document['arturl'] = (string)url(get_index_lang()['lang_url_dir'] . "/" . $document["name"] . "/" . $document['id'], [], get_one_cache_config('article_suffix','html'), true);
            }
        }
    }
    // 返回数据
    if (is_null($field)) {
        return $document;
    } else {
        return isset($document[$field]) ? $document[$field] : '';
    }
}
/**
 * get_debris 获取指定碎片信息函数标签
 * 
 * 固定字段用例：{:get_debris('碎片id','字段名')}
 * 其它'字段名'可在后台碎片新增或编辑页面查看
 * 
 * 单文件、单视频、单文件的路径获取
 * {:get_file_url(get_debris('碎片id','image'))}
 * 
 * 参数说明：
 * @param  $debris_id      碎片id
 * @param  $field          碎片字段，如果为null就获取一条碎片记录的所有字段值return array，如果不为空则获取单个字段值return string
 * @return array or string 返回数组或字符串
 */
function get_debris($debris_id = '', $field = null)
{
    if (empty($debris_id) || !is_numeric($debris_id)) {
        return is_null($field)?[]:'';
    }
    // 缓存名称
    $cache_name = 'DEBRIS' . '_' . $debris_id;
    // 读取缓存数据
    $debris = get_cache($cache_name);
    if(!$debris){
        $debris = Db::name('debris')->field(true)->find($debris_id);
        set_cache($cache_name,$debris);
    }
    // 返回数据
    if (is_null($field)) {
        return $debris;
    } else {
        return isset($debris[$field]) ? $debris[$field] : '';
    }
}
/**
 * baidu_position_js 百度地图定位浏览器坐标
 * 
 * 用例：{:baidu_position_js('百度地图Api-AK')}
 *
 * 参数说明：
 * @param  $ak  百度地图Api-AK
 * @return string 
 */
function baidu_position_js($ak = '')
{
    !$ak && $ak = get_one_cache_config('SYS_BDMAP_API');
    $code = 'http://api.map.baidu.com/api?v=2.0&ak='.$ak;
    $code = '<script type=\'text/javascript\' src=\''.$code.'\'></script>';
	$code.= '<script type="text/javascript">';
	$code.= '// 百度地图定位坐标
   var geolocation = new BMap.Geolocation();
   geolocation.getCurrentPosition(function(r){
      if(this.getStatus() == BMAP_STATUS_SUCCESS){
         $.ajax({type: "GET", url: "'.(string)url('admin/Common/baidu_position').'?value="+r.point.lng+\',\'+r.point.lat, dataType:"jsonp"});
      } else {
         alert(\'定位失败：\'+this.getStatus());
      }
   },{enableHighAccuracy: true});';
	$code.= '</script>';
	return $code;
}
/**
 * baidu_map_form_hidden 百度地图定位浏览器坐标并设置为隐藏表单域
 * 
 * 用例：{:baidu_map_form_hidden('字段名','百度地图Api-AK')}
 *
 * 参数说明：
 * @param  $field 字段名
 * @param  $ak    百度地图Api-AK
 * @return string 
 */
function baidu_map_form_hidden($field, $ak = '')
{
    !$ak && $ak = get_one_cache_config('SYS_BDMAP_API');
    $code = 'http://api.map.baidu.com/api?v=2.0&ak='.$ak;
    $code = '<script type=\'text/javascript\' src=\''.$code.'\'></script>';
	$code.= '<input type="hidden" id="dr_'.$field.'" name="data['.$field.']" value="">';
	$code.= '<script type="text/javascript">';
	$code.= '// 百度地图定位坐标
    var geolocation = new BMap.Geolocation();
    geolocation.getCurrentPosition(function(r){
        if(this.getStatus() == BMAP_STATUS_SUCCESS){
		    $("#dr_'.$field.'").val(r.point.lng+\',\'+r.point.lat);
            $.ajax({type: "GET", url: "'.(string)url('admin/Common/baidu_position').'?value="+r.point.lng+\',\'+r.point.lat, dataType:"jsonp"});
        } else {
            alert(\'定位失败：\'+this.getStatus());
        }
    },{enableHighAccuracy: true});';
	$code.= '</script>';
	return $code;
}
/**
 * baidu_map 百度地图调用
 * 
 * 用例：{:baidu_map($字段名, 17, '100%', '400', 'SYS_BDMAP_API', 'class', '这里是标注显示信息')}
 *
 * 参数说明：
 * @param  $value  必填：字段
 * @param  $zoom   必填：17是缩放大小
 * @param  $width  必填：100%是宽度，可以填写200表示200px
 * @param  $height 必填：400是高度，表示400px
 * @param  $ak     可选：百度地图KEY
 * @param  $class  可选：div的class名称
 * @param  $tips   可选：地图上的标注信息，例如填写公司地址等，支持html标签
 * @return string 
 */
function baidu_map($value, $zoom = 15, $width = 600, $height = 400, $ak = '', $class= '', $tips = '')
{
    if (!$value) {
        return '没有坐标值';
    }
    $id = 'dr_map_'.rand(0, 99);
    !$ak && $ak = get_one_cache_config('SYS_BDMAP_API');
    $width = $width ? $width : '100%';
    list($lngX, $latY) = explode(',', $value);
    $js = 'http://api.map.baidu.com/api?v=2.0&ak='.$ak;
    $js = '<script type=\'text/javascript\' src=\''.$js.'\'></script>';
    return $js.'<div class="'.$class.'" id="' . $id . '" style="width:' . $width . 'px; height:' . $height . 'px; overflow:hidden"></div>
	<script type="text/javascript">
	var mapObj=null;
	lngX = "' . $lngX . '";
	latY = "' . $latY . '";
	zoom = "' . $zoom . '";		
	var mapObj = new BMap.Map("'.$id.'");
	var ctrl_nav = new BMap.NavigationControl({anchor:BMAP_ANCHOR_TOP_LEFT,type:BMAP_NAVIGATION_CONTROL_LARGE});
	mapObj.addControl(ctrl_nav);
	mapObj.enableDragging();
	mapObj.enableScrollWheelZoom();
	mapObj.enableDoubleClickZoom();
	mapObj.enableKeyboard();//启用键盘上下左右键移动地图
	mapObj.centerAndZoom(new BMap.Point(lngX,latY),zoom);
	drawPoints();
	function drawPoints(){
		var myIcon = new BMap.Icon("' . Config::get('view.tpl_replace_string.__STATIC__') . '/common/images/mak.png", new BMap.Size(27, 45));
		var center = mapObj.getCenter();
		var point = new BMap.Point(lngX,latY);
		var marker = new BMap.Marker(point, {icon: myIcon});
		mapObj.addOverlay(marker);
		'.($tips ? 'mapObj.openInfoWindow(new BMap.InfoWindow("'.str_replace('"', '\'', $tips).'",{offset:new BMap.Size(0,-17)}),point);' : '').'
	}
	</script>';
}
/**
 * qq_map 腾讯地图调用
 * 
 * 调用百度地图：{:qq_map($value, $zoom = 10, $width = 600, $height = 400, $ui = 0, $class = '')}
 *
 * 参数说明：
 * @param  $value  必填：地图坐标
 * @param  $zoom   必填：显示等级，越高越详细，默认15
 * @param  $width  必填：地图宽度
 * @param  $height 必填：地图高度
 * @param  $ui     可选：1表示不显示动态坐标移动标识
 * @param  $ak     可选：腾讯地图KEY
 * @param  $class  可选：div的class名称
 * @return string 
 */
function qq_map($value, $zoom = 10, $width = 600, $height = 400, $ui = 0, $ak = '', $class = '') 
{
    if (!$value) {
        return '没有坐标值';
    }
    $ui = !$ui ? 'false' : 'true';
    $id = 'dr_qq_map_'.rand(0, 99);
    $width = $width ? $width : '100%';
    !$ak && $ak = get_one_cache_config('SYS_QQMAP_API');
    list($lngX, $latY) = explode(',', $value);
    $js = 'http://map.qq.com/api/js?v=2.exp&key='.$ak;
    $js = '<script type=\'text/javascript\' src=\''.$js.'\'></script>';
    return $js.'<div class="'.$class.'" id="' . $id . '" style="width:' . $width . 'px; height:' . $height . 'px; overflow:hidden"></div>
	<script type="text/javascript">
        var center = new qq.maps.LatLng('.$latY.','.$lngX.');
        var map = new qq.maps.Map(document.getElementById(\''.$id.'\'),{
            center: center,
            disableDefaultUI: '.$ui.',
            zoom: '.$zoom.'
        });
         var anchor = new qq.maps.Point(6, 6),
            size = new qq.maps.Size(27, 45),
            origin = new qq.maps.Point(0, 0),
            icon = new qq.maps.MarkerImage(\'' . Config::get('view.tpl_replace_string.__STATIC__') . '/common/images/mak.png\', size, origin, anchor);
        var marker = new qq.maps.Marker({
            icon: icon,
            map: map,
            position:map.getCenter()});
	</script>';
}
/**
 * tag_markdown markdown调用
 * 用例：{:tag_markdown(字段名,值,'100%','400')}
 * 参数说明：
 * @param  $name   必填：字段
 * @param  $value  必填：值
 * @param  $width  必填：100%是宽度，可以填写200表示200px
 * @param  $height 必填：400是高度，表示400px
 * @return string 
 */
function tag_markdown($name, $value, $width = 600, $height = '')
{
    $width = $width ? $width : '100%';
    $height = $height ? $height : '100%';
    $css = '<link rel=\'stylesheet\' href=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/examples/css/style.css'.'\'></link>'
    .'<link rel=\'stylesheet\' href=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/css/editormd.preview.css'.'\'></link>'
    ;
    $js = '<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/marked.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/prettify.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/raphael.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/underscore.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/sequence-diagram.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/flowchart.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/jquery.flowchart.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/editormd.js'.'\'></script>'
    ;
    return $css.$js.'<div class="js-editormd" id="' . $name . '" style="width:' . $width . 'px; height:' . $height . 'px; overflow:hidden">
    <textarea style="display:none;" name="'.$name.'">'.$value.'</textarea>
    </div>
	<script type="text/javascript">
    var testEditormdView;
    $(function () {
        testEditormdView = editormd.markdownToHTML("'.$name.'", {
            htmlDecode      : "style,script,iframe",  // you can filter tags decode
            // emoji           : true,
            taskList        : true,
            tex             : true,  // 默认不解析
            flowChart       : true,  // 默认不解析
            sequenceDiagram : true,  // 默认不解析
        });
    });
	</script>';
}
/**
 * tag_markdown_container markdown容器调用
 * 用例：{:tag_markdown_container(字段名,值,'100%','400')}
 * 参数说明：
 * @param  $name   必填：字段
 * @param  $value  必填：值
 * @param  $width  必填：100%是宽度，可以填写200表示200px
 * @param  $height 必填：400是高度，表示400px
 * @return string 
 */
function tag_markdown_container($name, $value, $width = 600, $height = '')
{
    $width = $width ? $width : '100%';
    $height = $height ? $height : '100%';
    $css = '<link rel=\'stylesheet\' href=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/examples/css/style.css'.'\'></link>'
    .'<link rel=\'stylesheet\' href=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/css/editormd.preview.css'.'\'></link>'
    ;
    $js = '<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/marked.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/prettify.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/raphael.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/underscore.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/sequence-diagram.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/flowchart.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/jquery.flowchart.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/editormd.js'.'\'></script>'
    ;
    return $css.$js.
    '
    <style>
        #sidebar {
            width: 400px;
            height: 100%;
            position: fixed;
            top: 0;
            right: 0;
            overflow: hidden;
            background: #fff;
            z-index: 100;
            padding: 18px; 
            border: 1px solid #ddd;
            border-top: none;
            border-bottom: none;
        }
        #sidebar:hover {
            overflow: auto;
        }
        #sidebar h1 {
            font-size: 16px;
        }
        #custom-toc-container {
            padding-left: 0;
        }
        #test-editormd-view {
            padding-left: 0;
            padding-right: 430px;
            margin: 0;
        }
    </style>
    <div id="layout">
        <div id="sidebar">
            <div class="markdown-body editormd-preview-container" id="custom-toc-container">#custom-toc-container</div>
        </div>
        <div id="test-editormd-view">
            <textarea style="display:none;" name="test-editormd-markdown-doc">'.$value.'</textarea>               
        </div>
    </div>
	<script type="text/javascript">
    var testEditormdView;
    $(function () {
        testEditormdView = editormd.markdownToHTML("test-editormd-view", {
            //htmlDecode      : true,       // 开启 HTML 标签解析，为了安全性，默认不开启
            htmlDecode      : "style,script,iframe",  // you can filter tags decode
            //toc             : false,
            tocm            : true,    // Using [TOCM]
            tocContainer    : "#custom-toc-container", // 自定义 ToC 容器层
            //gfm             : false,
            //tocDropdown     : true,
            // markdownSourceCode : true, // 是否保留 Markdown 源码，即是否删除保存源码的 Textarea 标签
            emoji           : true,
            taskList        : true,
            tex             : true,  // 默认不解析
            flowChart       : true,  // 默认不解析
            sequenceDiagram : true,  // 默认不解析
        });
    });
	</script>';
}
/**
 * tag_markdown_container_by_url markdown容器调用
 * 用例：{:tag_markdown_container_by_url(字段名,值,'100%','400')}
 * 参数说明：
 * @param  $name   必填：字段
 * @param  $url    必填：值
 * @param  $width  必填：100%是宽度，可以填写200表示200px
 * @param  $height 必填：400是高度，表示400px
 * @return string 
 */
function tag_markdown_container_by_url($name, $url, $width = 600, $height = '')
{
    $width = $width ? $width : '100%';
    $height = $height ? $height : '100%';
    $css = '<link rel=\'stylesheet\' href=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/examples/css/style.css'.'\'></link>'
    .'<link rel=\'stylesheet\' href=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/css/editormd.preview.css'.'\'></link>'
    ;
    $js = '<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/marked.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/prettify.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/raphael.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/underscore.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/sequence-diagram.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/flowchart.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/lib/jquery.flowchart.min.js'.'\'></script>'
    .'<script type=\'text/javascript\' src=\''.Config::get('view.tpl_replace_string.__STATIC__').'/common/lib/editormd/editormd.js'.'\'></script>'
    ;
    return $css.$js.
    '
    <style>
        #sidebar {
            width: 400px;
            height: 100%;
            position: fixed;
            top: 0;
            right: 0;
            overflow: hidden;
            background: #fff;
            z-index: 100;
            padding: 18px; 
            border: 1px solid #ddd;
            border-top: none;
            border-bottom: none;
        }
        #sidebar:hover {
            overflow: auto;
        }
        #sidebar h1 {
            font-size: 16px;
        }
        #custom-toc-container {
            padding-left: 0;
        }
        #test-editormd-view {
            padding-left: 0;
            padding-right: 430px;
            margin: 0;
        }
    </style>
    <div id="layout">
        <div id="sidebar">
            <div class="markdown-body editormd-preview-container" id="custom-toc-container">#custom-toc-container</div>
        </div>
        <div id="test-editormd-view">
            <textarea style="display:none;" name="test-editormd-markdown-doc">###Hello world!</textarea>               
        </div>
    </div>
	<script type="text/javascript">
    $(function () {
        var testEditormdView;
        $.get("'.$url.'", function(markdown) {           
            testEditormdView = editormd.markdownToHTML("test-editormd-view", {
                markdown        : markdown ,//+ "\r\n" + $("#append-test").text(),
                //htmlDecode      : true,       // 开启 HTML 标签解析，为了安全性，默认不开启
                htmlDecode      : "style,script,iframe",  // you can filter tags decode
                //toc             : false,
                tocm            : true,    // Using [TOCM]
                tocContainer    : "#custom-toc-container", // 自定义 ToC 容器层
                //gfm             : false,
                //tocDropdown     : true,
                // markdownSourceCode : true, // 是否保留 Markdown 源码，即是否删除保存源码的 Textarea 标签
                emoji           : true,
                taskList        : true,
                tex             : true,  // 默认不解析
                flowChart       : true,  // 默认不解析
                sequenceDiagram : true,  // 默认不解析
            });
            
            //console.log("返回一个 jQuery 实例 =>", testEditormdView);
            
            // 获取Markdown源码
            //console.log(testEditormdView.getMarkdown());
            
            //alert(testEditormdView.getMarkdown());
        });
    });
	</script>';
}
##################################################################################################################
#############################################标签调用结束##########################################################
##################################################################################################################