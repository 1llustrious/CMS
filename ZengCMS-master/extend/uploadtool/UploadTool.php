<?php
namespace uploadtool;
/*
其值为 0，没有错误发生，文件上传成功。

UPLOAD_ERR_INI_SIZE
其值为 1，上传的文件超过了 php.ini 中 upload_max_filesize 选项限制的值。

UPLOAD_ERR_FORM_SIZE
其值为 2，上传文件的大小超过了 HTML 表单中 MAX_FILE_SIZE 选项指定的值。

UPLOAD_ERR_PARTIAL
其值为 3，文件只有部分被上传。

UPLOAD_ERR_NO_FILE
其值为 4，没有文件被上传。

UPLOAD_ERR_NO_TMP_DIR
其值为 6，找不到临时文件夹。PHP 4.3.10 和 PHP 5.0.3 引进。

UPLOAD_ERR_CANT_WRITE
其值为 7，文件写入失败。PHP 5.1.0 引进。
*/
class UploadTool{
    //允许文件格式
    private $AllowExt='jpg,jpeg,gif,bmp,png';
    //文件最大值
    private $AllowMaxSize=1;
    //文件路径
    private $path;
    //是否使用原文件名 默认不使用
    private $is_old_name=0;
    //错误代号
    private $errno=null;
    //错误信息
    private $error=array(
        0=>'文件上传成功',
        1=>'上传的文件超过了 php.ini 中 upload_max_filesize 选项限制的值',
        2=>'上传文件的大小超过了 HTML 表单中 MAX_FILE_SIZE 选项指定的值',
        3=>'文件只有部分被上传',
        4=>'没有文件被上传',
        6=>'找不到临时文件夹。PHP 4.3.10 和 PHP 5.0.3 引进',
        7=>'文件写入失败。PHP 5.1.0 引进',
        // 8=>'表单文件name不存在',
        9=>'文件格式不对',
        10=>'文件太大',
        11=>'文件目录创建失败',
        12=>'文件移动失败'
    );
    /**
     * [Description 构造方法]
     * @DateTime 2020-04-04 22:36:30
     * @param [type] $config
     */
    public function __construct($config){
        if(isset($config['ext'])&&!empty($config['ext'])){
            $this->AllowExt = $config['ext'];
        }
        if(isset($config['size'])&&!empty($config['size'])){
            $this->AllowMaxSize = $config['size'];
        }
        if(isset($config['path'])&&!empty($config['path'])){
            $this->path = $config['path'];
        }
        if(isset($config['is_old_name']) && $config['is_old_name']==1){
            $this->is_old_name = 1;
        }
    }
    /**
     * [Description 文件上传]
     * @DateTime 2020-04-04 22:32:06
     * @param [type] $file
     * @return void
     */
    public function upload($file){
        //检验上传有没有成功
        if($file['error']){
            $this->errno=$file['error'];
            return false;
        }
        // 获取后缀
        $ext=$this->getExt($file['name']);
        // 检查后缀
        if(!$this->isAllowExt($ext)){
            $this->errno=9;
            return false;
        }
        //检查大小
        if(!$this->isAllowSize($file['size'])){
            $this->errno=10;
            return false;
        }
        //创建文件存储目录
        $path=$this->mk_dir($this->path.date('Ymd',time()));
        //判断创建文件存储目录是否成功
        if(!$path){
            $this->errno=11;
            return false;
        }
        if(!$this->is_old_name){
            // 创建随机文件名
            $newname=$this->randName(6).date('Ymd',time()).'.'.$ext;
        }else{
            if(!$this->is_utf8($file['name'])){
                $newname = mb_convert_encoding($file['name'],'UTF-8');
            }else{
                $newname = $file['name'];
            }
        }
        $path=$path.'/'.$newname;
        //判断文件移动是否成功
        if(!move_uploaded_file($file['tmp_name'],$path)){
            $this->errno=12;
            return false;
        }
        // return str_replace(ROOT,'',$path);
        return date('Ymd',time()).'/'.basename($path);
    }
    /**
     * [Description 获取错误信息]
     * @DateTime 2020-04-04 22:31:01
     * @return void
     */
    public function getError(){
        return $this->error[$this->errno];
    }
    /**
     * [Description 判断文件后缀是否符合]
     * @DateTime 2020-04-04 22:31:35
     * @param [type] $ext
     * @return boolean
     */
    private function isAllowExt($ext){
        return in_array(strtolower($ext),explode(',',strtolower($this->AllowExt)));
    }
    /**
     * [Description 判断文件大小是否符合]
     * @DateTime 2020-04-04 22:31:29
     * @param [type] $size
     * @return boolean
     */
    private function isAllowSize($size){
        if($this->AllowMaxSize *1024*1024>=$size){
            return true;
        }else{
            return false;
        }
    }
    /**
     * [Description 获取文件后缀名]
     * @DateTime 2020-04-04 22:30:41
     * @param [type] $filename
     * @return void
     */
    private function getExt($filename){
        $tmp=explode('.',$filename);
        return end($tmp);
    }
    /**
     * [Description 创建级联目录]
     * @DateTime 2020-04-04 22:30:32
     * @param [type] $path
     * @return void
     */
    private function mk_dir($path){
        if(is_dir($path) || mkdir($path,0777,true)){
            return $path;
        }else{
            return false;
        }
    }
    /**
     * [Description 创建随机文件名]
     * @DateTime 2020-04-04 22:29:49
     * @param integer $length
     * @return void
     */
    private function randName($length=6){
        $str='abcdefghijklmnopqrstuvwzxyABCDEFGHIJKLMNOPQRSTUVWZXY';
        return substr(str_shuffle($str),0,$length);
    }
   /**
    * [Description 判断是否为utf8格式]
    * @DateTime 2020-04-04 22:30:00
    * @param [type] $gonten
    * @return boolean
    */
    private function is_utf8($gonten){
        if(preg_match("/^([".chr(228)."-".chr(233)."]{1}[".chr(128)."-".chr(191)."]{1}[".chr(128)."-".chr(191)."]{1}){1}/",$gonten) == true || preg_match("/([".chr(228)."-".chr(233)."]{1}[".chr(128)."-".chr(191)."]{1}[".chr(128)."-".chr(191)."]{1}){1}$/",$gonten) == true || preg_match("/([".chr(228)."-".chr(233)."]{1}[".chr(128)."-".chr(191)."]{1}[".chr(128)."-".chr(191)."]{1}){2,}/",$gonten) == true){
            return true;
        }else{
            return false;
        }
    }
}
