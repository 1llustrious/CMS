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
// | admin公共函数
// +----------------------------------------------------------------------
use think\facade\Db;
/**
 * [getDirectorySize PHP统计目录总大小、文件和子目录个数]
 * @param    [type]                   $path [description]
 * @return   [type]                         [description]
 */
function getDirectorySize($path)
{
    $totalsize = 0;
    $totalcount = 0;
    $dircount = 0;
    if ($handle = opendir($path)) {
        while (false !== ($file = readdir($handle))) {
            $nextpath = $path . '/' . $file;
            if ($file != '.' && $file != '..' && !is_link($nextpath)) {
                if (is_dir($nextpath)) {
                    $dircount++;
                    $result = getDirectorySize($nextpath);
                    $totalsize += $result['size'];
                    $totalcount += $result['count'];
                    $dircount += $result['dircount'];
                } elseif (is_file($nextpath)) {
                    $totalsize += filesize($nextpath);
                    $totalcount++;
                }
            }
        }
    }
    closedir($handle);
    $total['size'] = $totalsize;
    $total['count'] = $totalcount;
    $total['dircount'] = $dircount;
    return $total;
}
/* $path="D:/wamp/www/bak/tools";
$ar=getDirectorySize($path);
echo "路径 : $path";
echo "目录大小 : ".sizeFormat($ar['size'])."";
echo "文件数 : ".$ar['count']."";
echo "目录术 : ".$ar['dircount']."";
print_r($ar); */
/**
 * [copyFolder 复制文件夹]
 * @param    [type]                   $file   [description]
 * @param    [type]                   $folder [description]
 * @return   [type]                           [description]
 */
function copyFolder($file, $folder)
{
    if (!file_exists($folder)) {
        mkdir($folder, 0777, true);
    }
    if (is_file($file)) {
        copy($file, $folder . "/" . $file);
        return true;
    }
    $handle = opendir($file);
    while (($item = readdir($handle)) !== false) {
        if ($item != "." && $item != "..") {
            if (is_file($file . "/" . $item)) {
                copy($file . "/" . $item, $folder . "/" . $item);
            }
            if (is_dir($file . "/" . $item)) {
                copyFolder($file . "/" . $item, $folder . "/" . $item);
            }
        }
    }
    closedir($handle);
    return true;
}
/**
 * [get_field_group 获取字段分组]
 * @param    string                   $type [description]
 * @return   [type]                         [description]
 */
function get_field_group($type = '')
{
    static $_type = array(
        '1' => '基础设置',
        '2' => '拓展设置',
    );
    return $type ? $_type[$type] : $_type;
}
/**
 * [get_attribute_type 获取属性类型信息]
 * @param  string $type [description]
 * @return [type] [description]
 */
function get_attribute_type($type = '')
{
    static $_type = array(
        'num' => array("数字", "int(10) UNSIGNED NOT NULL DEFAULT '0'"),
        'float' => array("小数类型", "float(10,2) NOT NULL DEFAULT '0.00'"),
        'decimal' => array("金额类型", "decimal(10,2) NOT NULL DEFAULT '0.00'"),
        'string' => array("字符串", "varchar(255) NOT NULL DEFAULT ''"),
        'tags' => array("标签", "varchar(255) NOT NULL DEFAULT ''"),
        'array' => array("数组", "varchar(255) NOT NULL DEFAULT ''"),
        'textarea' => array("文本框", "text DEFAULT NULL"),
        'editor' => array('编辑器', "text DEFAULT NULL"),
        'markdown' => array('markdown编辑器', "text DEFAULT NULL"),
        'colorpicker' => array("取色器", "varchar(64) NOT NULL DEFAULT ''"),
        'datetime' => array("时间", "int(10) UNSIGNED NOT NULL DEFAULT '0'"),
        // 'bool'  =>  array('bool布尔','tinyint(2) NOT NULL'),
        'radio' => array('单选', "char(10) NOT NULL DEFAULT ''"),
        'checkbox' => array('多选', "varchar(100) NOT NULL DEFAULT ''"),
        'select' => array('option下拉', "char(50) NOT NULL DEFAULT ''"),
        'selecto' => array('高级下拉单选', "char(50) NOT NULL DEFAULT ''"),
        'selects' => array('高级下拉多选', "varchar(255) NOT NULL DEFAULT ''"),
        'region' => array('地区', "varchar(100) NOT NULL DEFAULT ''"),
        'map' => array('地图', "varchar(100) NOT NULL DEFAULT ''"),
        'stepselect' => array('联动类型', "char(50) NOT NULL DEFAULT ''"),
        'picture' => array('上传单图', "varchar(100) NOT NULL DEFAULT ''"),
        'piclist' => array('上传多图', "text DEFAULT NULL"),
        'file' => array('上传单文件', "varchar(100) NOT NULL DEFAULT ''"),
        'filelist' => array('上传多文件', "text DEFAULT NULL"),
        'onevideo' => array('上传单视频', "varchar(100) NOT NULL DEFAULT ''"),
        'videolist' => array('上传多视频', "text DEFAULT NULL"),
    );
    return $type ? $_type[$type][0] : $_type;
}
// 获取验证方式
function get_validate_type($type = '')
{
    static $_type = array(
        'regex' =>      array("正则验证", "[ 根据验证方式定义相关验证规则，例：/(\d+)[a-z]+(\d+)/ ]"),
        'function' =>   array("函数验证", "[ 根据验证方式定义相关验证规则，例：is_numeric ]"),
        'unique' =>     array("唯一验证", "[ 根据验证方式定义相关验证规则 ]"),
        'length' =>     array("长度验证", "[ 根据验证方式定义相关验证规则，例：6,12或6，12或6 12 ]"),
        'in' =>         array("验证在范围内", "[ 根据验证方式定义相关验证规则，例：6,12,24或6，12，24或6 12 24]"),
        'notin' =>      array("验证不在范围内", "[ 根据验证方式定义相关验证规则，例：6,12,24或6，12，24或6 12 24]"),
        'between' =>    array("区间验证", "[ 根据验证方式定义相关验证规则，例：6,12或6，12或6 12]"),
        'notbetween' => array("不在区间验证", "[ 根据验证方式定义相关验证规则，例：6,12或6，12或6 12]"),
    );
    return $type ? $_type[$type][0] : $_type;
}
// 获取自动完成方式
function get_auto_type($type = '')
{
    static $_type = array(
        'function' => array("函数", "[ 自动完成规则 - 根据完成方式订阅相关规则，例：time ]"),
        'field'    => array("字段", "[ 自动完成规则 - 根据完成方式订阅相关规则，例：title ]"),
        'string'   => array("字符串", "[ 自动完成规则 - 根据完成方式订阅相关规则 ]"),
    );
    return $type ? $_type[$type][0] : $_type;
}
/**
 * [get_model_by_id 根据模型ID获取模型名称]
 * @param    [type]                   $id [description]
 * @return   [type]                       [description]
 */
function get_model_by_id($id)
{
    if ($id == '-1') {
        return '系统字段';
    } else {
        $modelinfo = Db::name('model')->field('title')->find($id);
        $model_name = $modelinfo['title'];
        return $model_name;
    }
}
/**
 * 字符串命名风格转换 thinkphp框架本身已经有了
 * type 0 将Java风格转换为C的风格 1 将C风格转换为Java的风格
 * @param string $name 字符串
 * @param integer $type 转换类型
 * @return string
 */
/* function parse_name($name, $type = 0)
{
    if ($type) {
        return ucfirst(preg_replace_callback('/_([a-zA-Z])/', function ($match) {
            return strtoupper($match[1]);
        }, $name));
    } else {
        return strtolower(trim(preg_replace("/[A-Z]/", "_\\0", $name), "_"));
    }
} */
/**
 * 根据栏目ID获取栏目名称
 * @param int $id
 * @return array 文档类型数组
 */
function get_cate($cate_id = null)
{
    if ($cate_id == 0) {
        return '顶级栏目';
    }
    if (empty($cate_id)) {
        return false;
    }
    $cate = Db::name('arctype')->field('typename')->where('id', $cate_id)->find();
    return $cate['typename'];
}
/**
 * [Description 电子面单]
 * @DateTime 2020-03-05 20:05:25
 * @param [type] $eorder
 * @return void
 */
function KdApiEOrder($eorder)
{
    $options['EBusinessID'] = Config::get('setting.EBusinessID');
    $options['AppKey'] = Config::get('setting.AppKey');
    $options['ReqURL'] = Config::get('setting.miandan_ReqURL');
    include_once PROJECT_PATH . '/data/plugins/PHPkdniao/KdApiEOrderDemo.php';
    $KdApiEOrder = new KdApiEOrderDemo($options);
    // 构造电子面单提交信息
    /*   
    $eorder = [];
    $eorder["ShipperCode"] = "EMS"; //快递公司编码 
    $eorder["OrderCode"] = "012657700387";//订单编号(自定义，不可重复)
    $eorder["PayType"] = 1;//邮费支付方式:1-现付，2-到付，3-月结，4-第三方支付(仅SF支持)
    $eorder["ExpType"] = 1; //快递类型：1-标准快件 
    $eorder["IsReturnPrintTemplate"] = 1; //返回电子面单模板：0-不需要；1-需要

    $sender = [];
    $sender["Name"] = "李先生";//发件人
    $sender["Mobile"] = "18888888888";//发件人手机
    $sender["ProvinceName"] = "广东省";//发件省
    $sender["CityName"] = "深圳市";//发件市
    $sender["ExpAreaName"] = "福田区";//发件区/县
    $sender["Address"] = "赛格广场5401AB";//发件人详细地址

    $receiver = [];
    $receiver["Name"] = "李先生";//收件人
    $receiver["Mobile"] = "18888888888";//收件人手机
    $receiver["ProvinceName"] = "广东省";//收件省
    $receiver["CityName"] = "深圳市";//收件市
    $receiver["ExpAreaName"] = "福田区";//收件区/县
    $receiver["Address"] = "赛格广场5401AB";//收件人详细地址

    $commodityOne = [];
    $commodityOne["GoodsName"] = "电脑";//商品名称
    $commodityOne["GoodsCode"] = "97879";//商品编码
    $commodityOne["Goodsquantity"] = "2";//商品数量
    $commodityOne["GoodsPrice"] = "2";//商品价格

    $commodity = [];
    $commodity[] = $commodityOne;

    $eorder["Sender"] = $sender;
    $eorder["Receiver"] = $receiver;
    $eorder["Commodity"] = $commodity; 
    */
    // 调用电子面单
    $jsonParam = json_encode($eorder, JSON_UNESCAPED_UNICODE);
    //$jsonParam = JSON($eorder);//兼容php5.2（含）以下
    // echo "电子面单接口提交内容：<br/>".$jsonParam;
    $jsonResult = $KdApiEOrder->submitEOrder($jsonParam);
    // echo "<br/><br/>电子面单提交结果:<br/>".$jsonResult;
    //解析电子面单返回结果
    $result = json_decode($jsonResult, true);
    // var_dump($result);die;
    // echo $result['PrintTemplate'];die;
    return $result;
    /* echo "<br/><br/>返回码:" . $result["ResultCode"];
    if ($result["ResultCode"] == "100") {
        echo "<br/>是否成功:" . $result["Success"];
        die;
    } else {
        echo "<br/>电子面单下单失败";
    } */
}
/**
 * [Description 快递查询]
 * @DateTime 2020-03-05 20:06:01
 * @param [type] $requestData
 * @return void
 */
function KdApiSearch($requestData)
{
    include_once PROJECT_PATH . '/data/plugins/PHPkdniao/KdApiSearchDemo.php';
    $options['EBusinessID'] = Config::get('setting.EBusinessID');
    $options['AppKey'] = Config::get('setting.AppKey');
    $options['ReqURL'] = Config::get('setting.chaxun_ReqURL');
    $KdApiSearch = new KdApiSearchDemo($options);
    $logisticResult = $KdApiSearch->getOrderTracesByJson($requestData);
    return $logisticResult;
}
/**
 * 根据文件名来赋图标
 * $filename 文件名
 */
function seticon($filename){
    // 查找 "php" 在字符串中最后一次出现的位置：strrpos() 函数对大小写敏感。
    // substr() 函数返回字符串的一部分。如果 start 参数是负数且 length 小于或等于 start，则 length 为 0。
    // strtoupper转为大写，而 strtolower() 函数是把字符串转换为小写。
    $ext = strtoupper(substr($filename, strrpos($filename, '.')));
    $icon = '';
    switch ($ext) {
        case '.HTML':
            $icon = '#iconHTML1';
            break;
        case '.PHP':
            $icon = '#iconPHP';
            break;
        case '.JS':
            $icon = '#iconJS';
            break;
        case '.BMP':
            $icon = '#iconBMPs';
            break;
        case '.PNG':
            $icon = '#iconpng';
            break;
        case '.JPEG':
            $icon = '#iconjpeg';
            break;
        case '.GIF':
            $icon = '#iconGIF';
            break;
        case '.CSS':
            $icon = '#iconcss';
            break;
        case '.JPG':
            $icon = '#iconjpg';
            break;
        case '.JSON':
            $icon = '#iconjson';
            break;
        case '.SQL':
            $icon = '#iconSQL';
            break;
        case '.ZIP':
            $icon = '#iconzip';
            break;
        case '.RAR':
            $icon = '#iconrar';
            break;
        case '.HTACCESS':
            $icon = '#iconhtaccess';
            break;
        case '.ENV':
            $icon = '#iconENV';
            break;
        case '.BAT':
            $icon = '#iconBAT';
            break;
        case '.HTM':
            $icon = '#iconhtm';
            break;
        case '.MD':
            $icon = '#iconmd';
            break;
        case '.LOCK':
            $icon = '#iconlock';
            break;
        case '.XML':
            $icon = '#iconXML';
            break;
        case '.TXT':
            $icon = '#iconTXT';
            break;
        case '.GITIGNORE':
            $icon = '#icongitignore';
            break;
        case '.YML':
            $icon = '#iconyml';
            break;
        case '.ICO':
            $icon = '#iconpng1';
            break;
        default:
            $icon = '#iconwenjian'; // 默认文件图标
            break;
    }
    return $icon;
}
if (!function_exists('array_format_key')) {
    /**
     * 二位数组重新组合数据
     * @param $array
     * @param $key
     * @return array
     */
    function array_format_key($array, $key)
    {
        $newArray = [];
        foreach ($array as $vo) {
            $newArray[$vo[$key]] = $vo;
        }
        return $newArray;
    }
}
if (!function_exists('__url')) {
    /**
     * 构建URL地址
     * @param string $url
     * @param array $vars
     * @param bool $suffix
     * @param bool $domain
     * @return string
     */
    function __url(string $url = '', array $vars = [], $suffix = true, $domain = false)
    {
        return url($url, $vars, $suffix, $domain)->build();
    }
}
/**
 * 字符串命名风格转换
 * type 0 将Java风格转换为C的风格 1 将C风格转换为Java的风格
 * @access public
 * @param  string  $name 字符串
 * @param  integer $type 转换类型
 * @param  bool    $ucfirst 首字母是否大写（驼峰规则）
 * @return string
 */
function parseName($name, $type = 0, $ucfirst = true)
{
    if ($type) {
        $name = preg_replace_callback('/_([a-zA-Z])/', function ($match) {
            return strtoupper($match[1]);
        }, $name);
        return $ucfirst ? ucfirst($name) : lcfirst($name);
    }
    return strtolower(trim(preg_replace("/[A-Z]/", "_\\0", $name), "_"));
}
/**
 * 获取插件类的类名
 * @param $name 插件名
 * @param string $type 返回命名空间类型
 * @param string $class 当前类名
 * @return string
 */
function get_addon_class($name, $type = 'hook', $class = null)
{
    $name = parseName($name);
    // 处理多级控制器情况
    if (!is_null($class) && strpos($class, '.')) {
        $class = explode('.', $class);
        $class[count($class) - 1] = parseName(end($class), 1);
        $class = implode('\\', $class);
    } else {
        $class = parseName(is_null($class) ? $name : $class, 1);
    }
    switch ($type) {
        case 'controller':
            $namespace = "\\addons\\" . $name . "\\controller\\" . $class;
            break;
        default:
            // $namespace = "\\addons\\" . $name . "\\" . $class; //tp5
            $namespace = "\\addons\\" . $name . "\\" . 'Plugin';    //tp6 Plugin
    }
    return class_exists($namespace) ? $namespace : '';
}
/**
 * [cc_format 将大写命名转换成下划线分割命名]
 * @param  [type] $name [description]
 * @return [type]       [description]
 */
function cc_format($name)
{
    $name_arr = explode('/', $name);
    $module = $name_arr[0];
    $name = $name_arr[1];
    unset($name_arr[0]);
    unset($name_arr[1]);
    $temp_array = array();
    // 判断是否多级控制器带点.的
    $is_duo = 0;
    if(strpos($name,'.')!==false){
        $is_duo = 1;
        $prefix =  substr($name,0,strrpos($name ,"."));//截取点前面的内容
        $name =  substr($name,strripos($name,".")+1);//截取点后面的内容
    }
    // 对控制器名进行大写命名转换成下划线分割命名 开始
    for ($i = 0; $i < strlen($name); $i++) {
        $ascii_code = ord($name[$i]);
        if ($ascii_code >= 65 && $ascii_code <= 90) {
            if ($i == 0) {
                $temp_array[] = chr($ascii_code + 32);
            } else {
                $temp_array[] = '_' . chr($ascii_code + 32);
            }
        } else {
            $temp_array[] = $name[$i];
        }
    }
    $str = implode('', $temp_array);
    if (!empty($name_arr)) {
        $action_str = '/' . implode('/', $name_arr);
    } else {
        $action_str = '';
    }
    // 对控制器名进行大写命名转换成下划线分割命名 结束
    if($is_duo){
        $url = $module.'/'.$prefix.'.'.$str.$action_str;
    }else{
        $url = $module.'/'.$str.$action_str;
    }
    // 如果规则后面带有参数则$query便是?号后面的参数不包括?号(例子：status=1&type=1)
    $query = preg_replace('/^.+\?/U', '', $url);
    if($query != $url){
        // 去掉规则后面的参数
        $url = preg_replace('/\?.*$/U', '', $url);
        return (string)url($url,[],false).'?'.$query;   
    }
    return (string)url($url,[],false);
}
/**
 * 下划线转驼峰
 * 思路:
 * step1.原字符串转小写,原字符串中的分隔符用空格替换,在字符串开头加上分隔符
 * step2.将字符串中每个单词的首字母转换为大写,再去空格,去字符串首部附加的分隔符.
 */
function camelize($uncamelized_words,$separator='_')
{
    $uncamelized_words = $separator. str_replace($separator, " ", strtolower($uncamelized_words));
    return ltrim(str_replace(" ", "", ucwords($uncamelized_words)), $separator );
}
/**
 * 驼峰命名转下划线命名
 * 思路:
 * 小写和大写紧挨一起的地方,加上分隔符,然后全部转小写
 */
function uncamelize($camelCaps,$separator='_')
{
    return strtolower(preg_replace('/([a-z])([A-Z])/', "$1" . $separator . "$2", $camelCaps));
}
/**
 * 导入插件SQL
 * @param string $name    插件名称
 * @param string $sqlname sql文件名称
 * @return  boolean
 */
function importaddonsql($name,$sqlname)
{
    $sqlFile = ADDONS_PATH . '/' .$name . DIRECTORY_SEPARATOR . $sqlname .'.sql';
    if (is_file($sqlFile)) {
        $lines = file($sqlFile);
        $templine = '';
        foreach ($lines as $line) {
            if (substr($line, 0, 2) == '--' || $line == '' || substr($line, 0, 2) == '/*')
                continue;

            $templine .= $line;
            if (substr(trim($line), -1, 1) == ';') {
                $templine = str_ireplace('__PREFIX__', config('database.connections.mysql.prefix'), $templine);
                $templine = str_ireplace('INSERT INTO ', 'INSERT IGNORE INTO ', $templine);
                try {
                    Db::query($templine);
                } catch (\PDOException $e) {
                    throw new PDOException($e->getMessage());
                }
                $templine = '';
            }
        }
    }
    return true;
}


