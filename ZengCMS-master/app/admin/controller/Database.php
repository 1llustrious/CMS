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
// | 数据库备份控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use backup\Backup;
use think\facade\Db;
use think\facade\View;
use think\facade\Config;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="数据库备份管理")
 * Class Database
 * @package app\admin\controller
 */
class Database extends Base
{
    protected $config = [];
    /**
     * [initialize 初始化方法]
     * @return void
     */
    public function initialize()
    {
        // 防止还原时，随机数改为原来的与现在冲突，所以改为以前的随机数
        if (session('admin_auth')) {
            $admin = session('admin_auth');
            $admin['random_number'] = Db::name('admin')->where('id', $admin['uid'])->value('random_number');
            session('admin_auth', $admin);
        }
        $this->config['path'] = PROJECT_PATH . get_one_config('DATA_BACKUP_PATH') . '/';//路径
        $this->config['part'] = get_one_config('DATA_BACKUP_PART_SIZE');//大小
        $this->config['compress'] = get_one_config('DATA_BACKUP_COMPRESS');//是否压缩
        $this->config['level'] = get_one_config('DATA_BACKUP_COMPRESS_LEVEL');//压缩级别
        parent::initialize();
    }
    /**
     * @NodeAnotation(title="获取数据库中表的列表信息")
     */
    public function index()
    {
        $backup = new Backup($this->config);
        $list = $backup->dataList();
        // dump($list);die;
        // array_multisort(array_column($list,'create_time'),SORT_DESC,$list);
        $prefix = Config::get('database.connections.mysql.prefix'); // 获取表前缀
        $notBackupTable[] = $prefix . 'backup';
        $notBackupTable[] = $prefix . 'log';
        $notBackupTable[] = $prefix . 'log_content';
        // 不能备份会出错因为它是自动添加数据的auto_increment= 自增起步值出错
        $notBackupTable[] = $prefix . 'logs'; 
        View::assign([
            'meta_title' => '数据库备份',
            'list' => $list,
            'notBackupTable' => $notBackupTable,
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="表的修复")
     */
    public function repair()
    {
        if (request()->isPost()) {
            $table = input('post.tablename');
            if (!empty($table)) {
                // 不是myisam引擎不能操作
                $tableInfo = Db::query("SHOW CREATE TABLE `{$table}`");
                $table_info_str = trim($tableInfo[0]['Create Table']);
                if (stripos($table_info_str, 'myisam') !== false) {
                    $backup = new Backup($this->config);
                    $result = $backup->repair($table);
                    if ($result[0]['Msg_text'] == "OK") {
                        // return returnjson(1,"修复成功");
                        return json(['code' => 1, 'msg' => '修复成功']);
                    }
                    return json(['code' => 0, 'msg' => '修复失败']);
                } else {
                    return json(['code' => 0, 'msg' => '不能执行修复']);
                }
            }
        } else {
            return json(['code' => 0, 'msg' => '请求异常']);
        }
    }
    /**
     * @NodeAnotation(title="表的优化")
     */
    public function optimize()
    {
        if (request()->isPost()) {
            $table = input('post.tablename');
            if (!empty($table)) {
                //不是myisam引擎不能操作
                $tableInfo = Db::query("SHOW CREATE TABLE `{$table}`");
                $table_info_str = trim($tableInfo[0]['Create Table']);
                if (stripos($table_info_str, 'myisam') !== false) {
                    $backup = new Backup($this->config);
                    $result = $backup->optimize($table);
                    if ($result == $table) {
                        // return returnjson(1,"优化成功");
                        return json(['code' => 1, 'msg' => '优化成功']);
                    }
                    // return returnjson(0,"优化失败");
                    return json(['code' => 0, 'msg' => '优化失败']);
                } else {
                    return json(['code' => 0, 'msg' => '不能执行优化']);
                }
            }
        } else {
            // return returnjson(0,"请求异常");
            return json(['code' => 0, 'msg' => '请求异常']);
        }
    }
    /**
     * @NodeAnotation(title="批量修复")
     */
    public function repairAll()
    {
        if (request()->isPost()) {
            $tables = input('post.tables');
            if (empty($tables)) {
                return json(['code' => 0, 'msg' => '请选择要修复的表']);
            }
            $tables = explode(",", $tables);
            if (is_array($tables)) {
                //不是myisam引擎不能操作
                foreach ($tables as $k => $v) {
                    $tableInfo = Db::query("SHOW CREATE TABLE `{$v}`");
                    $table_info_str = trim($tableInfo[0]['Create Table']);
                    if (stripos($table_info_str, 'myisam') === false) {
                        unset($tables[$k]);
                    }
                }
                $backup = new Backup($this->config);
                foreach ($tables as $v) {
                    $backup->repair($v);
                }
                // return returnjson(1,"修复完成");
                return json(['code' => 1, 'msg' => '修复完成']);
            }
            // return returnjson(0,"修复失败");
            return json(['code' => 0, 'msg' => '修复失败']);
        }
        // return returnjson(0,"请求异常");
        return json(['code' => 0, 'msg' => '请求异常']);
    }
    /**
     * @NodeAnotation(title="批量优化")
     */
    public function optimizeAll()
    {
        if (request()->isPost()) {
            $tables = input('post.tables');
            if (empty($tables)) {
                return json(['code' => 0, 'msg' => '请选择要优化的表']);
            }
            $tables = explode(",", $tables);
            if (is_array($tables)) {
                //不是myisam引擎不能操作
                foreach ($tables as $k => $v) {
                    $tableInfo = Db::query("SHOW CREATE TABLE `{$v}`");
                    $table_info_str = trim($tableInfo[0]['Create Table']);
                    if (stripos($table_info_str, 'myisam') === false) {
                        unset($tables[$k]);
                    }
                }
                $backup = new Backup($this->config);
                foreach ($tables as $v) {
                    $backup->optimize($v);
                }
                return json(['code' => 1, 'msg' => '优化完成']);
            }
            return json(['code' => 0, 'msg' => '优化失败']);
        }
        return json(['code' => 0, 'msg' => '请求异常']);
    }
    /**
     * @NodeAnotation(title="获取备份列表")
     */
    public function backuplst()
    {
        $table = input("t"); //表名
        $this->config['path'] = $this->config['path'] . md5($table) . '/';
        $db = new Backup($this->config);
        // halt($db->getFile('',1541398287));
        $list = $db->fileList(); //数据库备份文件列表
        $data = [];
        foreach ($list as $v) {
            $res = $db->getFile('time', $v['time']); //获取备份名称 看Backup类里的getFile方法
            $filename = "未知";
            if (isset($res[0])) {
                $filename = basename($res[0]);
            }
            $v['filename'] = $filename;
            $data[] = $v;
        }

        View::assign("table", $table);
        View::assign("list", $data);
        // dump($data);die;
        View::assign([
            'meta_title' => '数据还原',
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="备份")
     */
    public function dbbackup($tables = null, $id = null, $start = null)
    {
        if (request()->isPost() && !empty($tables) && is_array($tables)) { //初始化
            $table = implode(',', $tables);
            $this->config['path'] = $this->config['path'] . md5($table) . '/';
            //检查是否有正在执行的任务
            $lock = realpath($this->config['path']) . DIRECTORY_SEPARATOR . "backup.lock";
            // print_r($lock);die;
            if (is_file($lock)) {
                $this->error('检测到有一个备份任务正在执行，请稍后再试！');
            } else {
                //创建锁文件
                $time = time();
                file_put_contents($lock, $time);
            }

            //检查备份目录是否可写
            // is_writeable(realpath($this->config['path']) . DIRECTORY_SEPARATOR) || $this->error('备份目录不存在或不可写，请检查后重试！');
            is_writeable($this->config['path']) || $this->error('备份目录不存在或不可写，请检查后重试！');
            session('backup_config', $this->config);

            //生成备份文件信息
            $file = ['name' => date('Ymd-His', $time), 'part' => 1];
            session('backup_file', $file);

            //缓存要备份的表
            session('backup_tables', $tables);

            //创建备份文件
            $Database = new Backup($this->config);

            if (false !== $Database->Backup_Init()) {
                $tab = array('id' => 0, 'start' => 0);
                $this->success('初始化成功！', '', array('tables' => $tables, 'tab' => $tab));
            } else {
                $this->error('初始化失败，备份文件创建失败！');
            }
        } elseif (request()->isGet() && is_numeric($id) && is_numeric($start)) { //备份数据
            $tables = session('backup_tables');
            //备份指定表
            $Database = new Backup(session('backup_config'));
            $start = $Database->setFile(session('backup_file'))->backup($tables[$id], $start);
            if (false === $start) { //出错
                $this->error('备份出错！');
            } elseif (0 === $start) { //下一表
                if (isset($tables[++$id])) {
                    $tab = array('id' => $id, 'start' => 0);
                    $this->success('备份完成！', '', array('tab' => $tab));
                } else { //备份完成，清空缓存
                    // unlink(realpath(session('backup_config.path')) . DIRECTORY_SEPARATOR . 'backup.lock');
                    @unlink(session('backup_config.path') . 'backup.lock');
                    session('backup_tables', NULL);
                    session('backup_file', NULL);
                    session('backup_config', NULL);
                    $this->success('备份完成！');
                }
            } else {
                $tab = array('id' => $id, 'start' => $start[0]);
                $rate = floor(100 * ($start[0] / $start[1]));
                $this->success("正在备份123...({$rate}%)", '', array('tab' => $tab));
            }
        } else { //出错
            $this->error('参数错误！');
        }
    }
    /**
     * @NodeAnotation(title="数据还原")
     */
    public function restore($time = 0, $table = null, $part = null, $start = null)
    {
        if (is_numeric($time) && is_null($part) && is_null($start)) { //初始化
            // 获取备份文件信息
            $name = date('Ymd-His', $time) . '-*.sql*';
            // $path = realpath($this->config['path']) . DIRECTORY_SEPARATOR . $name;
            $path = $this->config['path'] . md5($table) . '/' . $name;
            $files = glob($path);
            $list = array();
            foreach ($files as $name) {
                $basename = basename($name);
                $match = sscanf($basename, '%4s%2s%2s-%2s%2s%2s-%d');
                $gz = preg_match('/^\d{8,8}-\d{6,6}-\d+\.sql.gz$/', $basename);
                $list[$match[6]] = array($match[6], $name, $gz);
            }
            // dump($list);die;
            ksort($list);
            // 检测文件正确性
            $last = end($list);
            if (count($list) === $last[0]) {
                session('backup_list', $list);//缓存备份列表
                $this->success('初始化完成！', '', array('part' => 1, 'start' => 0));
            } else {
                $this->error('备份文件可能已经损坏，请检查！');
            }
        } elseif (is_numeric($part) && is_numeric($start)) {
            $list = session('backup_list');
            $this->config['path'] = $this->config['path'] . md5($table) . '/';
            $this->config['compress'] = $list[$part][2]; //数据库备份文件是否启用压缩 0不压缩 1 压缩
            $db = new Backup($this->config);
            $file = ['name' => date('Ymd-His', $time), 'part' => 1];
            // $arr = $db->getFile('time', $time);
            $file[1] = $list[$part][1];
            $start = $db->setFile($file)->import($start);
            if (false === $start) {
                $this->error('还原数据出错！');
            } elseif (0 === $start) { //下一卷
                if (isset($list[++$part])) {
                    $data = array('part' => $part, 'start' => 0);
                    $this->success("正在还原...#{$part}", '', $data);
                } else {
                    session('backup_list', null);
                    $this->success('还原完成！');
                }
            } else {
                $data = array('part' => $part, 'start' => $start[0]);
                if ($start[1]) {
                    $rate = floor(100 * ($start[0] / $start[1]));
                    $this->success("正在还原...#{$part} ({$rate}%)", '', $data);
                } else {
                    $data['gz'] = 1;
                    $this->success("正在还原...#{$part}", '', $data);
                }
            }
        } else {
            $this->error('参数错误！');
        }
    }
    /**
     * @NodeAnotation(title="删除备份")
     */
    public function del($table = null, $time = 0)
    {
        $this->config['path'] = $this->config['path'] . md5($table) . '/';
        // $this->config['compress'] = 1;
        $db = new Backup($this->config);
        $result = $db->delFile($time); //删除备份
        if ($result == $time) {
            // return returnjson(1,"删除成功");
            return json(['code' => 1, 'msg' => '删除成功']);
        }
        // return returnjson(0,"删除失败");
        return json(['code' => 0, 'msg' => '删除失败']);
    }
    /**
     * @NodeAnotation(title="批量删除备份")
     */
    public function delall($table, $times = null)
    {
        if (empty($times)) {
            $this->error('请选择要删除的文件');
        }
        $timeArr = explode(',', $times);
        foreach ($timeArr as $k => $v) {
            $this->del($table, $v);
        }
        $this->success('删除成功');
    }
    /**
     * @NodeAnotation(title="备份下载")
     * 下载备份，实现批量打包下载文件，PHP提供了ZipArchive，类可为我们实现这一功能
     */
    public function download()
    {
        $time = input('time');
        $table = input('t');
        $name = date('Ymd-His', $time) . '-*.sql*';
        $path = $this->config['path'] . md5($table) . '/' . $name;
        $dirname = dirname($path);
        $files = glob($path); //把要下载的备份文件详细组合到$files数组中
        if (empty($files)) {
            $this->error('备份文件已损坏，请删除该数据！');
        }
        $zipname = $dirname . '/' . date('Ymd-His', $time) . '.zip'; //压缩文件名
        $zipname = str_replace('\\', '/', $zipname);
        $zip = new \ZipArchive;
        $res = $zip->open($zipname, \ZipArchive::CREATE);
        if ($res === TRUE) {
            foreach ($files as $file) {
                if (file_exists($file)) {
                    $file = str_replace('\\', '/', $file);
                    $new_filename = substr($file, strrpos($file, '/') + 1);
                    // echo $new_filename;die;
                    $zip->addFile($file, $new_filename);
                    // $zip->renameName($file,$new_filename);
                }
            }
            $zip->close();
            // 这里是下载zip文件
            header("Content-Type: application/zip");
            header("Content-Transfer-Encoding: Binary");
            header("Content-Length: " . filesize($zipname));
            header("Content-Disposition: attachment; filename=\"" . basename($zipname) . "\"");
            ob_clean();
            flush();
            readfile($zipname);
            // 删除压缩文件
            @unlink($zipname);
            exit;
        } else {
            $this->error('下载失败！');
        }
    }
    /**
     * @NodeAnotation(title="上传备份")
     */
    public function upload()
    {
        if (request()->isAjax()) {
            $table = input('table');
            if ($_FILES['backup_file']['tmp_name']) {
                $upload_file_path = 'database/' . md5($table); //文件上传路径设置，注意
                $path = $upload_file_path; // 文件上传路径设置
                $fileSrc = upload('backup_file', $path,1, 20, 'zip');
                if ($fileSrc['code'] == 0) {
                    $this->error($fileSrc['msg']);
                } else {
                    $original_file_name = basename($fileSrc['name']);
                    $ofn = explode('.', $original_file_name);
                    $str = array_shift($ofn); //弹出数组第一个元素
                    $strArr = explode('-', $str);
                    $timeStr = implode('', $strArr);
                    $time = strtotime($timeStr);
                    // 解压文件到的位置
                    $root_file_path = $this->config['path'] . md5($table) . '/';
                    $pathx = STATIC_PATH . '/' . $fileSrc['name'];
                    // 解压文件，PclZip类库不支持命名空间
                    include_once PROJECT_PATH . '/data/plugins/pclzip/PclZip.php';
                    $zip = new \PclZip($pathx);
                    $res = $zip->extract(PCLZIP_OPT_PATH, $root_file_path);
                    if ($res === 0) {
                        $this->error('解压失败');
                    }
                    // @unlink($pathx);// 删除上传文件
                    rm_dir_files(STATIC_PATH . '/uploads/database/'); //删除上传文件
                    $this->success('上传成功！');
                }
            } else {
                $this->error('请选择文件上传！');
            }
        }
    }
}
