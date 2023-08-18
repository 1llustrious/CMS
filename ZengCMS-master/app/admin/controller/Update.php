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
// | 在线更新控制器，更新包手动压缩时注意：是选择根目录下所有文件压缩至根目录而不是选择根目录直接压缩
// +----------------------------------------------------------------------
namespace app\admin\controller;

use file\File;
use think\facade\Db;
use think\facade\View;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="在线更新管理")
 * Class Update
 * @package app\admin\controller
 */
class Update extends Base
{
    // 检查版本地址
    protected $check_url;
    // 下载更新包地址
    protected $updated_url;
    // 初始化页面
    protected function initialize()
    {
        $this->check_url = $_SERVER['SERVER_NAME'] . '/Update/checkVersion';
        $this->updated_url = $_SERVER['SERVER_NAME'] . '/Update/getDownloadUrl';
        parent::initialize();
    }
    /**
     * @NodeAnotation(title="检查更新")
     */
    public function index()
    {
        if (request()->isPost()) {
            $this->showMsg('正在检测版本...');
            // 在线更新
            $this->update();
        } else {
            // 获取服务器信息
            $serverinfo = server_info();
            // 检查版本
            $version = $this->checkVersion();
            View::assign([
                'meta_title' => '检查更新',
                'serverinfo' => $serverinfo,
                'new_version' => $version,
            ]);
            return view();
        }
    }
    /**
     * @NodeAnotation(title="在线更新")
     * 弹出选择是否备份的弹窗
     */
    public function isbackupfile()
    {
        View::assign([
            'meta_title' => '在线更新',
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="上传更新包")
     */
    public function upload()
    {
        return view();
    }
    /**
     * @NodeAnotation(title="接收更新包")
     * 大文件切割上传，把每次上传的数据合并成一个文件
     */
    public function receive_upload()
    {
        $name = $_POST['filename'];
        // 确定上传的文件名
        if(PUBLIC_DIR){
            $filename = iconv("UTF-8", "gb2312", PROJECT_PATH . '/' . $name);
        }else{
            $filename = iconv("UTF-8", "gb2312", PROJECT_PATH . '/public/' . $name);
        }
        // 第一次上传时没有文件，就创建文件，此后上传只需要把数据追加到此文件中
        if (!file_exists($filename)) {
            $filenameArr = explode('.', $name);
            $ext = end($filenameArr);
            // 系统新版本号更新
            $file = File::read_file(PROJECT_PATH . '/app/common.php');
            $file = str_replace(NEW_ZENGCMS_VERSION, 'new@' . str_replace('.'.$ext,'',$name), $file);
            File::write_file(PROJECT_PATH . '/app/common.php', $file);
            move_uploaded_file($_FILES['part']['tmp_name'], $filename);
        } else {
            file_put_contents($filename, file_get_contents($_FILES['part']['tmp_name']), FILE_APPEND);
        }
    }
    // 检查新版本
    protected function checkVersion()
    {
        // extension_loaded检查php扩展是否加载
        if (extension_loaded('curl')) {
            $url = $this->check_url;
            $params = array(
                'version' => ZENGCMS_VERSION,//当前版本
                'domain' => $_SERVER['HTTP_HOST'],//当前域名
                'auth' => sha1(get_one_config('WEB_DATA_AUTH_KEY')),
            );
            $vars = http_build_query($params);
            // 获取版本数据
            $json = $this->getRemoteUrl($url, 'post', $vars);
            $data = json_decode($json,true);
            return $data['version'];
        } else {
            $this->error('请配置支持curl');
        }
    }
    // 在线更新
    protected function update()
    {
        // 检查新版本
        $version = $this->checkVersion();
        if (empty($version)) {
            $this->showMsg("当前版本为最新版本", 'success');
            exit;
        }
        $this->showMsg("正在为您更新" . $version . '版本！', 'success');
        sleep(1);
        // PclZip类库不支持命名空间
        include_once PROJECT_PATH . '/data/plugins/pclzip/PclZip.php';
        $date = date('YmdHis');
        $backupFile = input('post.backupfile');
        // $backupDatabase = input('post.backupdatabase');
        sleep(1);
        // 建立更新文件夹
        $folder = PROJECT_PATH . '/data/' . $this->getUpdateFolder();
        ini_set("max_execution_time", "360");
        ini_set('memory_limit', '100M');
        File::mk_dir($folder);
        $folder = $folder . '/' . $date;
        File::mk_dir($folder);
        // 备份重要文件
        if ($backupFile) {
            $this->showMsg('开始备份重要程序文件...');
            $backupallPath = $folder . '/backupall.zip';
            $zip = new \PclZip($backupallPath);
            if (!PUBLIC_DIR) {
                $back_dir = '../addons,../app,../config,../data,../extend,../install,../public,../route,../vendor,../view';
                $back_file = ',../.env,../.htaccess,../.travis.yml,../composer.json,../composer.lock,../think';
            } else {
                $back_dir = 'addons,app,config,data,extend,install,public,route,vendor,view';
                $back_file = ',.env,.htaccess,.travis.yml,composer.json,composer.lock,think';
            }
            $zip->create($back_dir . $back_file);
            $this->showMsg('成功完成重要程序备份！', 'success');
        }
        // 获取更新包
        $updatedUrl = $this->updated_url;
        $params = array('version' => $version);
        $_updatedUrl_json = $this->getRemoteUrl($updatedUrl, 'post', http_build_query($params));
        $_updatedUrl = json_decode($_updatedUrl_json,true);
        if (empty($_updatedUrl) || empty($_updatedUrl['url'])) {
            $this->showMsg('未获取到更新包的下载地址', 'error');
            exit;
        }
        $updatedUrl = $_updatedUrl['url'];
        // 下载并保存
        $this->showMsg('开始获取远程更新包...');
        sleep(1);
        $zipPath = $folder . '/update.zip';
        $downZip = $this->Downloadfile($updatedUrl);
        if (empty($downZip)) {
            $this->showMsg('下载更新包出错，请重试！', 'error');
            exit;
        }
        File::write_file($zipPath, $downZip);
        $this->showMsg('获取远程更新包成功！', 'success');
        sleep(1);
        // 解压缩更新包
        $this->showMsg('更新包解压缩...');
        sleep(1);
        $zip = new \PclZip($zipPath);
        $res = $zip->extract(PCLZIP_OPT_PATH, $folder . '/update');
        if ($res === 0) {
            $this->showMsg('解压缩失败：' . $zip->errorInfo(true) . '------更新终止', 'error');
            exit;
        }
        sleep(1);
        copyFolder($folder . '/update', PROJECT_PATH);
        rm_dir_files($folder . '/update');
        $this->showMsg('更新包解压缩成功', 'success');
        sleep(1);
        // 更新数据库
        $updatesql = PROJECT_PATH . '/update.sql';
        if (is_file($updatesql)) {
            $this->showMsg('更新数据库开始...');
            if (file_exists($updatesql)) {
                $db = Db::connect();
                $sql = File::read_file($updatesql);
                $sql = str_replace("\r\n", "\n", $sql);
                foreach (explode(";\n", trim($sql)) as $query) {
                    $db->query(trim($query));
                }
            }
            unlink($updatesql);
            $this->showMsg('更新数据库完毕', 'success');
        }
        // 系统版本号更新
        $file = File::read_file(PROJECT_PATH . '/app/common.php');
        $file = str_replace(ZENGCMS_VERSION, $version, $file);
        $res = File::write_file(PROJECT_PATH . '/app/common.php', $file);
        if ($res === false) {
            $this->showMsg('更新系统版本号失败', 'error');
        } else {
            $this->showMsg('更新系统版本号成功', 'success');
        }
        sleep(1);
        $this->showMsg('在线更新全部完成，请关闭弹窗', 'success');
    }
    // 获取远程数据
    protected function getRemoteUrl($url = '', $method = '', $param = '')
    {
        $opts = array(
            CURLOPT_TIMEOUT => 20,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_URL => $url,
            CURLOPT_USERAGENT => $_SERVER['HTTP_USER_AGENT'], //获取浏览器相关参数
        );
        if ($method === 'post') {
            $opts[CURLOPT_POST] = 1;
            $opts[CURLOPT_POSTFIELDS] = $param;
        }
        // 初始化并执行curl请求
        $ch = curl_init();
        curl_setopt_array($ch, $opts);
        $data = curl_exec($ch);
        $error = curl_error($ch);
        curl_close($ch);
        return $data;
    }
    // 远程下载数据
    protected function Downloadfile($url = '', $method = '', $param = '')
    {
        $opts = array(
            // CURLOPT_TIMEOUT        => 20,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_URL => $url,
            CURLOPT_USERAGENT => $_SERVER['HTTP_USER_AGENT'],
            CURLOPT_NOPROGRESS => 0,
            CURLOPT_FOLLOWLOCATION => TRUE,
            CURLOPT_PROGRESSFUNCTION => 'fun_Progress', // 用来显示进度的回调函数
        );
        if ($method === 'post') {
            $opts[CURLOPT_POST] = 1;
            $opts[CURLOPT_POSTFIELDS] = $param;
        }
        // 初始化并执行curl请求
        $ch = curl_init();
        curl_setopt_array($ch, $opts);
        $data = curl_exec($ch);
        $error = curl_error($ch);
        if ($error) {
            $this->showMsg('下载更新包失败，请重试！', 'error');
            exit;
        }
        curl_close($ch);
        return $data;
    }
    /**
     * 实时显示提示信息
     * @param  string $msg 提示信息
     * @param  string $class 输出样式（success:成功，error:失败）
     */
    protected function showMsg($msg, $class = '')
    {
        // echo "<script type=\"text/javascript\">showmsg(\"{$msg}\",\"{$class}\")</script>";
        echo $msg . "<br/>";
        flush();
        ob_flush();
    }
    /**
     * [getUpdateFolder 生成更新文件夹名]
     * @return [type] [description]
     */
    protected function getUpdateFolder()
    {
        $key = sha1(get_one_config('WEB_DATA_AUTH_KEY'));
        return 'update_' . $key;
    }
}
