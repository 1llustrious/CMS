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
// | 文件管理器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\facade\View;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="文件管理器")
 * Class File
 * @package app\admin\controller
 */
class File extends Base
{
    /**
     * @NodeAnotation(title="文件列表")
     */
    public function index($currdir=null)
    {
        if(!$currdir) {
            $currdir = str_replace('\\', '/', getcwd()).'/static/uploads';
        }
        if($currdir) {
            // 在file_exists前加@防止在linux下没有权限报错
            if(@file_exists($currdir)) { //判断文件或文件夹（即目录）名称的绝对路径是否存在，不存在就默认打开当前根路径getcwd();
                // 判断传过来的路径是否在站点根目录下面
                // stripos函数，查找字符串首次出现的位置不区分大小写找不到返回false，0代表在头部第一位置找到
                if(stripos($currdir, PROJECT_PATH . '/') === 0 && stripos($currdir, PROJECT_PATH . "/..") === false) { //判断传来的路径是否包含项目根路径即
                    chdir($currdir);//切换目录，相当于linux下的cd命令
                }
            }
        }
        $rootdir = str_replace('\\', '/', getcwd());//获取当前根路径
        $dir = opendir($rootdir);//打开目录，获取句柄资源
        $data = [];
        $num['dir'] = 0;//统计目录数目
        $num['file'] = 0;//统计文件数目
        while($filename = readdir($dir)){
            if($filename != '.' && $filename != '..'){
                if(is_dir($filename)){ //判断是文件夹(即目录)还是文件，目录
                    $arr['icon'] = "#iconfile1";//文件夹(即目录)图标
                    $arr['flag'] = 1;//1代表是文件夹(即目录)
                    $num['dir']++;//目录数目
                    $arr['size'] = getDirectorySize($rootdir.'/'.$filename)['size'];//目录大小
                    $arr['dircount'] = getDirectorySize($rootdir.'/'.$filename)['dircount'];//目录数
                    $arr['count'] = getDirectorySize($rootdir.'/'.$filename)['count'];//文件数
                    $arr['ext'] = '';//后缀
                }else{ //文件
                    $arr['icon'] = seticon($filename);//文件图标
                    $arr['flag'] = 0;//0代表是文件
                    $num['file']++;//文件数目
                    $arr['size'] = filesize($rootdir.'/'.$filename);//文件大小
                    $arr['ext'] = strtolower(substr($filename, strrpos($filename, '.')+1));//获取扩展名
                }
                $arr['currdir'] = str_replace('\\', '/', getcwd().DIRECTORY_SEPARATOR.$filename);
                // 图片裁剪需要
                $arr['filevalue'] = strstr(urldecode($arr['currdir']), 'uploads');//uploads之后的路径(包含uploads)
                $arr['name_md5'] = md5($filename);//文件或文件夹名称md5
                $arr['name'] = $filename;//文件或文件夹名称
                $arr['ctime'] = filectime($rootdir.'/'.$filename);//文件或文件夹(即目录)创建时间
                $arr['mtime'] = filemtime($rootdir.'/'.$filename);//文件或文件夹(即目录)修改时间
                $arr['atime'] = fileatime($rootdir.'/'.$filename);//文件或文件夹(即目录)访问时间
                $arr['is_readable'] = is_readable($rootdir.'/'.$filename);//文件或文件夹(即目录)是否可读
                $arr['is_writable'] = is_writable($rootdir.'/'.$filename);//文件或文件夹(即目录)是否可写
                $arr['is_executable'] = is_executable($rootdir.'/'.$filename);//文件或文件夹(即目录)是否执行
                $data[] = $arr;
            }
        }
        // 数组排序，文件夹(即目录)排在文件前面
        array_multisort(array_column($data, 'flag'),SORT_DESC,array_column($data, 'name'),SORT_ASC,array_column($data, 'size'),SORT_DESC,$data);
        $curr = input('page');//当前页面
        $limit = input('limit',5);//每页数目
        $currpage = page_array($data,$limit,$curr);//数组分页
        View::assign([
            'meta_title'=>'文件列表',//标题
            'curdir' => $rootdir,//当前目录路径
            'dirs' => $currpage['data'], //当前目录下所有文件及文件夹
            'page'=>$currpage['page'], //每页显示数目、总数目、当前页码
            'num'=>$num,//统计目录和文件数目
            'PROJECT_PATH'=>PROJECT_PATH.'/',//根目录
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="文件内容编辑")
     */
    public function edit()
    {
        $file = urldecode(input('file'));
        if(empty($file) || !file_exists($file)){
            $this->error('操作异常！');
        }
        $currdir = dirname(str_replace('\\','/',urldecode(input('file'))));
        $arr = ['.php','.css','.js','.xml','.html','.htaccess','.txt'];//设置可编辑的文件扩展名
        // strrpos获取最后出现的位置 substr从哪个位置开始截取 strtoupper小写转为大写
        $ext = strtolower(substr($file, strrpos($file, '.')));//获取扩展名
        if(!in_array($ext, $arr)){
            $this->error('该文件类型不支持编辑！',(string)url('File/index')."?currdir=".$currdir."&filename=".input('filename'));
        }
        if(request()->isPost()){
            $content = input('code');
            // 第一种修改
            /* if(file_put_contents($file, $content)){
                $this->success('保存成功！');
            }else{
                $this->error('保存失败！');
            } */
            // 打开要编辑的文件
            $fp = fopen($file, 'w');
            // 写入新内容
            fwrite($fp, $content);//fputs和fwrite一样的
            // 关闭文件
            fclose($fp);
            $this->success('保存成功！',(string)url('File/index')."?currdir=".$currdir."&filename=".input('filename'));
        }
        // htmlentities 把字符转换为 HTML 实体： ENT_COMPAT - 默认。仅编码双引号。
        $code = htmlentities(file_get_contents($file),ENT_COMPAT,'UTF-8');//获取文件内容
        View::assign('currfile',$file);//当前编辑文件
        View::assign('code',$code);//文件内容
        View::assign('ext',$ext);//扩展名
        View::assign('meta_title','编辑文件');//标题
        return view();
    }
    /**
     * @NodeAnotation(title="复制文件夹")
     */
    public function copy_folder()
    {
        if(request()->isAjax()){
            $file = input('curdir');
            // 移动到的文件夹
            $folder = input('folder');
            if(!is_dir($folder)){
                $this->error('目标文件夹不存在！');
            }
            if($file == $folder){
                $this->error('存在同名文件夹！');
            }
            $folder = $folder. '/' .basenamecn($file);
            copyFolder($file,$folder);
            $this->success('复制文件夹成功！');
        }
    }
    /**
     * @NodeAnotation(title="复制文件")
     */
    public function copy_file()
    {
        if(request()->isAjax()){
            $file = input('curdir');
            $folder = input('folder');
            if(is_dir($folder)){
                if(!file_exists($folder."/".basenamecn($file))){
                    if(copy($file, $folder."/".basenamecn($file))){
                        $this->success('复制文件成功！');
                    }else{
                        $this->error('复制文件失败！');
                    }
                }else{
                    $this->error('存在同名文件！');
                }
            }else{
                $this->error('目标文件夹不存在！');
            }
        }
    }
    /**
     * @NodeAnotation(title="剪切文件夹")
     */
    public function cut_folder()
    {
        if(request()->isAjax()){
            $file = input('curdir');
            // 剪切到的文件夹
            $folder = input('folder');
            if(is_dir($folder)){
                if($file == $folder){
                    $this->error('存在同名文件夹！');
                }
                if(!is_dir($folder."/".basenamecn($file))){
                    if(@rename($file,$folder."/".basenamecn($file))){
                        $this->success('剪切成功！');
                    }else{
                        $this->error('剪切失败！');
                    }
                }else{
                    $this->error('存在同名文件夹！');
                }
            }else{
                $this->error('目标文件夹不存在！');
            }
        }
    }
    /**
     * @NodeAnotation(title="剪切文件")
     */
    public function cut_file()
    {
        if(request()->isAjax()){
            $file = input('curdir');
            $folder = input('folder');
            if(is_dir($folder)){
                if(!file_exists($folder."/".basenamecn($file))){
                    if(@rename($file,$folder."/".basenamecn($file))){
                        $this->success('剪切文件成功！');
                    }else{
                        $this->error('剪切文件失败！');
                    }
                }else{
                    $this->error('存在同名文件！');
                }
            }else{
                $this->error('目标文件夹不存在！');
            }
        }
    }
    /**
     * @NodeAnotation(title="重命名")
     */
    public function renames()
    {
        if(request()->isAjax()){
            $file = urldecode(input('file'));
            $file = str_replace('\\', '/', $file);
            $filename = input('filename');//新文件名或文件夹名
            // 验证文件名的合法性，是否包含/,*,<>,?,
            $pattern = "/[\/,\*,<>,\?\|]/";
            if(preg_match($pattern, $filename)){
                $this->error('非法文件名！');
            }
            $newfile = dirname(str_replace('\\','/',urldecode(input('file')))).'/'.$filename;
            if(file_exists($newfile)){ //判断是否已经存在文件或文件夹名
                $this->error('文件已存在(重名)！');
            }
            if(@rename($file, $newfile)){
                $this->success('重命名成功！');
            }else{
                $this->error('重命名失败！');
            }
        }
    }
    /**
     * @NodeAnotation(title="文件下载")
     */
    public function download($currdir=null)
    {
        $file=urldecode($currdir);
        if(!file_exists($file)){
            $this->error('文件不存在！');
        }
        header('Content-Description: File Transfer');
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename=' . basenamecn($file));
        header('Content-Transfer-Encoding: binary');
        header('Expires: 0');
        header('Cache-Control: must-revalidate');
        header('Pragma: public');
        header('Content-Length:' . filesize($file));
        ob_clean();
        flush();
        readfile($file);
    }
    /**
     * @NodeAnotation(title="删除")
     */
    public function del($ids = NULL)
    {
        if(request()->isAjax()){
            $ids = !empty($ids) ? $ids :input('ids',0);
            if (empty($ids)) {
                $this->error('请选择要删除的文件！');
            }
            if(!is_array($ids)){
                $ids = array($ids);
            }
            foreach ($ids as $v) {
                $v = urldecode($v);
                if(is_file($v)){
                    @unlink($v);
                }
                if(is_dir($v)){
                    // scandir() 函数返回指定目录中的文件和目录的数组。
                    $arr = scandir($v);
                    if(count($arr) === 2){
                        @rmdir($v);
                    }else{
                        $this->RmDirFiles($v);
                    }
                }
            }
            $this->success('删除成功！');
        }
    }
    /**
     * @NodeAnotation(title="新建文件夹")
     */
    public function new_folder()
    {
        if(request()->isAjax()){
            $file = urldecode(input('curdir'));
            $folder = input('folder');//新文件名或文件夹名
            $pattern = "/[\/,\*,<>,\?\|]/";
            if(preg_match($pattern, $folder)){
                $this->error('非法文件名！');
            }
            $newfolder = $file.DIRECTORY_SEPARATOR.$folder;//已知原编码为UTF-8，转换为GB2312
            if(file_exists($newfolder)){ //判断是否已经存在文件或文件夹名
                $this->error('文件已存在(重名)！');
            }
            if(mkdir($newfolder,0777,true)){
                $this->success('新建文件夹成功！');
            }else{
                $this->error('新建文件夹失败！');
            }
        }
    }
    /**
     * @NodeAnotation(title="新建文件")
     */
    public function new_file()
    {
        if(request()->isPost()){
            $curdir = urldecode(input('curdir'));//当前目录
            $code = input('code');//内容
            $file = input('file');//文件名
            $file=str_replace("..","",$file);//替换文件中的".."字符串
            // 验证文件名的合法性，是否包含/,*,<>,?,
            $pattern = "/[\/,\*,<>,\?\|]/";
            if(preg_match($pattern, $file)){
                $this->error('非法文件名！',(string)url('File/index')."?currdir=".$curdir."&filename=".input('filename'));
            }
            $file=$curdir.'/'.$file;//文件的绝对地址
            // 判断文件是否已经存在
            if(file_exists($file)){
                $this->error('文件已存在！',(string)url('File/index')."?currdir=".$curdir."&filename=".input('filename'));
            }
            // 通过touch($file)来创建文件  touch 如果指定的文件不存在，则会被创建。
            if(!touch($file)){
                $this->error('创建文件失败！',(string)url('File/index')."?currdir=".$curdir."&filename=".input('filename'));
            }
            $code=stripslashes($code);
            $fp=fopen($file,"w");//以写的方式打开文件，并返回文件句柄
            if(fwrite($fp,$code)) {//写入文件(覆盖掉原有的文本内容)
                fclose($fp);//关闭文件句柄
                $this->success('新建文件成功！',(string)url('File/index')."?currdir=".$curdir."&filename=".input('filename'));
            } else {
                fclose($fp);//关闭文件句柄
                $this->error('新建文件失败！',(string)url('File/index')."?currdir=".$curdir."&filename=".input('filename'));
            }
        }
        View::assign([
            'meta_title'=>'新建文件',
            'curdir'=>input('curdir'),
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="文件上传")
     */
    public function upload_file()
    {
        if(request()->isPost()){
            $curdir = input('curdir');
            for($i=0;$i<count($_FILES['upload']['name']);$i++){
                if(empty($_FILES['upload']['name'][$i])){
                    continue;
                }
                if(empty($_FILES['upload']['tmp_name'][$i])){
                    continue;
                }
                if($_FILES['upload']['size'][$i] > 300*1024*1024){
                    continue;
                }
                if($_FILES['upload']['error'][$i] > 0){
                    continue;
                }
                move_uploaded_file($_FILES['upload']['tmp_name'][$i], urldecode(input('curdir')).'/'.$_FILES['upload']['name'][$i]);
            }
            $this->success('文件上传成功!',(string)url('File/index')."?currdir=".urldecode($curdir)."&filename=".input('filename'));
        }
        View::assign([
            'meta_title'=>'文件上传',
            'curdir'=> urldecode(input('curdir')),
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="大文件上传")
     */
    public function upload_max_file()
    {
        if(request()->isPost()){
            // 大文件切割上传，把每次上传的数据合并成一个文件
            $filename = urldecode(input('curdir')).'/' . $_POST['filename'];//确定上传的文件名
            $filename = iconv("UTF-8", "gb2312", $filename);
            // 第一次上传时没有文件，就创建文件，此后上传只需要把数据追加到此文件中
            if (!file_exists($filename)) {
                move_uploaded_file($_FILES['part']['tmp_name'], $filename);
            } else {
                file_put_contents($filename, file_get_contents($_FILES['part']['tmp_name']), FILE_APPEND);
            }
            return;
        }
        View::assign([
            'meta_title'=>'大文件上传',
            'curdir'=> urldecode(input('curdir')),
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="压缩文件")
     */
    public function compress()
    {
        if(request()->isAjax()){
            $ids = urldecode(input('ids'));
            $ids = str_replace('\\', '/', $ids);
            $fileArr = explode(',',$ids);
            $filename = input('filename');
            $compressPath = dirname($fileArr[0]).'/'.$filename.'.zip';
            if(is_file($compressPath)){ //判断是否已经存在文件或文件夹名
                $this->error('压缩文件已存在(重名)！');
            }
            $zip = new \ZipArchive();
            $res = $zip->open($compressPath, \ZipArchive::OVERWRITE | \ZipArchive::CREATE);
            if($res){
                foreach($fileArr as $v){
                    if(is_file($v)){
                        $this->compressFile($v,$zip);
                    }else if(is_dir($v)){
                        $this->compressDir($v,$zip);
                    }
                }
                $zip->close();
            }
            $this->success('压缩成功！');
        }
    }
    /**
     * @NodeAnotation(title="解压文件")
     */
    public function decompression_file()
    {
        if(request()->isAjax()){
            $file = input('curdir');//文件
            $folder = input('folder');//解压到的文件夹
            // 解压文件
            include_once PROJECT_PATH . '/data/plugins/pclzip/PclZip.php';
            $zip = new \PclZip($file);
            $res = $zip->extract(PCLZIP_OPT_PATH, $folder);
            if ($res === 0) {
                return json(['code'=>0,'msg'=>'解压失败!','url'=>'']);
            }
            return json(['code'=>1,'msg'=>'解压成功!','url'=>'']);
        }
    }
    /**
     * [getDirSize 获取目录大小]
     * @param [type] $dirpath
     * @return void
     */
    protected function getDirSize($dirpath)
    {
        global $size;
        if(is_file($dirpath)) {
            $size+=filesize($dirpath);
        } else {
            $dh=dir($dirpath);
            while($infile=$dh->read()) {
                if($infile=="."||$infile=="..") {
                    continue;
                } else if(is_file("$dirpath/$infile")) {
                    $size+=filesize("$dirpath/$infile");
                } else {
                    $this->getDirSize("$dirpath/$infile");
                }
            }
            $dh->close();
        }
        return $size;
    }
    /**
     * @param $dir 目标目录路径
     * @param $zip ZipArchive类对象
     * @param $prev
     */
    protected function compressDir($dir, $zip, $prev='.')
    {
        $handler = opendir($dir);
        $basename = basename($dir);
        $zip->addEmptyDir($prev . '/' . $basename);
        while($file = readdir($handler)){
            $realpath = $dir . '/' . $file;
            if(is_dir($realpath)){
                if($file !== '.' && $file !== '..'){
                    $zip->addEmptyDir($prev . '/' . $basename . '/' . $file);
                    $this->compressDir($realpath, $zip, $prev . '/' . $basename);
                }
            }else{
                $zip->addFile($realpath, $prev. '/' . $basename . '/' . $file);
            }
        }
        closedir($handler);
        return null;
    }
    /**
     * @param $file 目标文件路径
     * @param $zip ZipArchive类对象
     * @param $prev
     */
    protected function compressFile($file, $zip, $prev='.')
    {
        $basename = basename($file);
        // 将指定文件添加到zip中
        $zip->addFile($file,$prev.'/'.$basename);
    }
    /**
     * [RmDirFiles 删除目录下所有文件]
     * @param [type] $indir
     * @return void
     */
    protected function RmDirFiles($indir)
    {
        if(!is_dir($indir)){
            return 0;
        }
        $dh=dir($indir);
        while($infile=$dh->read()){
            if($infile=="."||$infile==".."){
                continue;
            }else if(is_file("$indir/$infile")){
                unlink("$indir/$infile");
            }else{
                $this->RmDirFiles("$indir/$infile");
            }
        }
        $dh->close();
        rmdir($indir);
        return 1;
    }
}