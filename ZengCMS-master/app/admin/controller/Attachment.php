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
// | 附件控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\facade\Db;
use think\facade\View;
use think\facade\Config;
use aliyunoss\Aliyunoss;
use imagetool\ImageTool;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="附件管理")
 * Class Attachment
 * @package app\admin\controller
 */
class Attachment extends Base
{
    /**
     * @NodeAnotation(title="列表")
     */
    public function index()
    {
        $map = array();
        $query = array();
        $group_id = trim(input('group_id'));
        $file_type = trim(input('file_type'));
        $title = trim(input('title'));
        if ($group_id !== '') {
            $map[] = ['group_id', '=', $group_id];
            $query['group_id'] = $group_id;
        }
        if ($title) {
            $map[] = ['file_name', 'like', "%$title%"];
            $query['title'] = $title;
        }
        if ($file_type) {
            $map[] = ['file_type', '=', $file_type];
            $query['file_type'] = $file_type;
        }
        $order = ['sort' => 'desc', 'id' => 'desc']; // 排序
        // ['query'=>$query] 可以改为 ['query'=>request()->param()] 方便多了
        $list = Db::name('attachment')->where($map)->order($order)
        // ->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query])
        ->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => request()->param()])
        ->each(function ($item, $key) {
            if ($item['upload_mode'] == 1) { //本地
                $item['filevalue'] = 'uploads/' . get_one_cache_config('upload_position') . '/' . $item['file_name'];
                $item['filepath'] = Config::get('view.tpl_replace_string.__STATIC__') . '/uploads/' . get_one_cache_config('upload_position') . '/' . $item['file_name'];
            } elseif ($item['upload_mode'] == 2) { //阿里云oss
                $item['filevalue'] = 'https://' . get_one_cache_config('bucket') . '.' . get_one_cache_config('endpoint') . '/' . $item['file_name'];
                $item['filepath'] = 'https://' . get_one_cache_config('bucket') . '.' . get_one_cache_config('endpoint') . '/' . $item['file_name'];
            }
            return $item;
        });
        $grouplist = Db::name('attachment_group')->select()->toArray();
        View::assign([
            'meta_title' => '文件管理',//标题
            'group_id' => $group_id,//分组id
            'grouplist' => $grouplist,//所有分组
            'file_type' => $file_type,//文件类型
            'list' => $list,//列表
        ]);
        // 记录当前列表页的cookie
        // cookie('__forward__', $_SERVER['REQUEST_URI']);
        return view();
    }
    /**
     * @NodeAnotation(title="上传文件")
     */
    public function upload_file()
    {
        $db = Db::connect();
        $group_id = input('group_id', 0);//分组ID
        // 上传服务器:1本地,2阿里云,3腾讯云,4七牛云
        $upload_mode = get_one_cache_config('upserver');
        if ($upload_mode == '1') { //本地
            if (isset($_FILES)) {
                $name = '';
                foreach ($_FILES as $key => $value) {
                    $name = $key;
                }
                $error = $_FILES[$name]['error'];
                switch ($_FILES[$name]['error']) {
                    case 0:
                        $msg = '';
                        break;
                    case 1:
                        $msg = '超出了php.ini中文件大小';
                        break;
                    case 2:
                        $msg = '超出了MAX_FILE_SIZE的文件大小';
                        break;
                    case 3:
                        $msg = '文件被部分上传';
                        break;
                    case 4:
                        $msg = '没有文件上传';
                        break;
                    case 5:
                        $msg = '文件大小为0';
                        break;
                    default:
                        $msg = '上传失败';
                        break;
                }
                // 获取文件后缀
                $arr = explode('.',  $_FILES[$name]['name']);
                $ext = end($arr);
                // 获取文件类型
                if (strpos($_FILES[$name]['type'], 'image/') !== false) {
                    $type = 'image';
                } elseif (strpos($_FILES[$name]['type'], 'video/') !== false) {
                    $type = 'video';
                }else{
                    $type = 'file';
                }
                // 获取新文件名
                $file_name = time() . mt_rand(1, 1000) . '.' . $ext;
                $file_path = STATIC_PATH . '/uploads/' . get_one_cache_config('upload_position');
                if(!is_dir($file_path)){
                    mkdir($file_path,0777,true);
                }
                move_uploaded_file($_FILES[$name]['tmp_name'], $file_path .'/'. $file_name);
                $url = request()->domain() . '/' . Config::get('view.tpl_replace_string.__STATIC__') . '/uploads/' . get_one_cache_config('upload_position') . '/' . $file_name;
                $data = array('extension' => $ext, 'size' => $_FILES[$name]['size'], 'type' => $type, 'url' => $url);
                // 上传文件记录表
                $fsql = " INSERT INTO `hh_attachment` (`group_id`, `upload_mode`, `file_name`,`file_type`) VALUES ('$group_id', '$upload_mode', '$file_name','$type') ";
                $db->query($fsql);
            } else {
                $error = 5;
                $msg = '文件大小为0';
                $url = '';
                $data = array();
            }
            echo json_encode(array("code" => $error, 'msg' => $msg, 'name' => $file_name, "url" => $url, 'data' => $data));
            exit();
        } else if ($upload_mode == '2') {
            $this->OSSupload();
        }
    }
    /**
     * @NodeAnotation(title="接收大文件")
     */
    public function upload_max_file()
    {
        // 大文件切割上传，把每次上传的数据合并成一个文件
        $filepath = STATIC_PATH . '/uploads/' . get_one_cache_config('upload_position') . '/' . $_POST['filepath'];
        $filepath = iconv("UTF-8", "gb2312", $filepath);
        mk_dirs(dirname($filepath));
        // 第一次上传时没有文件，就创建文件，此后上传只需要把数据追加到此文件中
        if (!file_exists($filepath)) {
            move_uploaded_file($_FILES['part']['tmp_name'], $filepath);
        } else {
            file_put_contents($filepath, file_get_contents($_FILES['part']['tmp_name']), FILE_APPEND);
        }
        $ext = input('ext');
        if(in_array(strtolower($ext),['bmp','jpg','png','tif','gif','pcx','tga','exif','fpx','svg','psd','cdr','pcd','dxf','ufo','eps','ai','raw','WMF','webp'])){
            $file_type = 'image';
        }elseif(in_array(strtolower($ext),['mp4','m4v','vob','wmv','avi','rm','rmvb','flv','mpg','mpeg','mpe','divx','asf','mov','mkv'])){
            $file_type = 'video';
        }else{
            $file_type = 'file';
        }
        // 上传服务器:1本地,2阿里云,3腾讯云,4七牛云
        // $upload_mode = get_one_cache_config('upserver');
        $upload_mode = 1;
        $group_id = input('group_id', 0);//分组ID
        // 上传文件记录表
        $res = Db::name('attachment')->where([
            ['group_id','=',$group_id],
            ['upload_mode','=',$upload_mode],
            ['file_name','=',basename($filepath)],
            ['file_type','=',$file_type],
        ])->find();
        if(!$res){
            Db::name('attachment')->insert([
                'group_id'=>$group_id,
                'upload_mode'=>$upload_mode,
                'file_name'=>basename($filepath),
                'file_type'=>$file_type,
            ]);
        }
        if ($upload_mode == '2') { //阿里云 
            $totalsize = input('totalsize');
            $end = input('end');
            if($totalsize <= $end){
                $ossClient = new Aliyunoss();
                $ossClient->multiuploadFile($_POST['filepath'], $filepath);
                @unlink($filepath);
            }
        }
    }
    /**
     * @NodeAnotation(title="删除")
     */
    public function del($ids = NULL)
    {
        $ids = !empty($ids) ? $ids : input('ids', 0);
        if (empty($ids)) {
            return json(['code'=>0,'msg'=>'参数不能为空！','url'=>'']);
        }
        if (!is_array($ids)) {
            $ids = array(intval($ids));
        }
        $ossClient = new Aliyunoss();
        foreach ($ids as $k => $v) {
            $fileRes = Db::name('attachment')->field('file_name,upload_mode')->find($v);
            if ($fileRes['upload_mode'] == 1) { //删除本地的
                $file_path = get_file_path($fileRes['file_name'], 2);
                if (file_exists($file_path)) {
                    @unlink($file_path);
                }
            } elseif ($fileRes['upload_mode'] == 2) { //删除阿里云图片
                $ossClient->deleteFile($fileRes['file_name']);
            }
        }
        $res = Db::name('attachment')->delete($ids);
        if ($res) {
            return json(['code'=>1,'msg'=>'删除成功！','url'=>'']);
        } else {
            return json(['code'=>0,'msg'=>'删除失败！','url'=>'']);
        }
    }
    /**
	 * @NodeAnotation(title="排序")
	 * @param  string $model [表名]
	 * @param  array  $data  [数据]
	 * @return [type]        [description]
	 */
    public function sort($model = 'attachment', $data = array())
    {
        $data['sort'] = input('sort');
        return parent::sort($model, $data);
    }
    /**
     * @NodeAnotation(title="移动")
     */
    public function move()
    {
        $data = input('get.');
        if ($data['group_id'] && isset($data['ids'])) {
            $res = Db::name('attachment')
            ->where([['id', 'in', $data['ids']]])
            ->update(['group_id' => $data['group_id']]);
            if ($res) {
                return json(['code'=>1,'msg'=>'移动成功','url'=>'']);
            } else {
                return json(['code'=>0,'msg'=>'移动失败','url'=>'']);
            }
        } else {
            return json(['code'=>0,'msg'=>'请选择移动分组或要移动的文件','url'=>'']);
        }
    }
    /**
     * @NodeAnotation(title="kindeditor上传")
     */
    public function kindeditor_upload()
    {
        $php_url = dirname($_SERVER['PHP_SELF']) . '/';
        // 文件保存目录路径
        $save_path = STATIC_PATH . '/uploads/kindeditor/';
        // 文件保存目录URL
        $save_url = Config::get('view.tpl_replace_string.__STATIC__') . '/uploads/kindeditor/';
        //定义允许上传的文件扩展名
        $ext_arr = array(
            'image' => array('gif', 'jpg', 'jpeg', 'png', 'bmp'),
            'flash' => array('swf', 'flv'),
            // 'media' => array('swf', 'flv', 'mp3', 'wav', 'wma', 'wmv', 'mid', 'avi', 'mpg', 'asf', 'rm', 'rmvb'),
            'media' => array('swf', 'flv', 'mp3', 'wav', 'wma', 'wmv', 'mid', 'avi', 'mpg', 'asf', 'rm', 'rmvb','mp4'),
            'file' => array('doc', 'docx', 'xls', 'xlsx', 'ppt', 'txt', 'zip', 'rar', 'gz', 'bz2'),
        );
        //最大文件大小
        // $max_size = 1000000;
        $max_size = 30000000;// 30M吧
        $save_path = realpath($save_path) . '/';
        //PHP上传失败
        if (!empty($_FILES['imgFile']['error'])) {
            switch($_FILES['imgFile']['error']){
                case '1':
                    $error = '超过php.ini允许的大小。';
                    break;
                case '2':
                    $error = '超过表单允许的大小。';
                    break;
                case '3':
                    $error = '图片只有部分被上传。';
                    break;
                case '4':
                    $error = '请选择图片。';
                    break;
                case '6':
                    $error = '找不到临时目录。';
                    break;
                case '7':
                    $error = '写文件到硬盘出错。';
                    break;
                case '8':
                    $error = 'File upload stopped by extension。';
                    break;
                case '999':
                default:
                    $error = '未知错误。';
            }
            alert($error);
        }
        //有上传文件时
        if (empty($_FILES) === false) {
            //原文件名
            $file_name = $_FILES['imgFile']['name'];
            //服务器上临时文件名
            $tmp_name = $_FILES['imgFile']['tmp_name'];
            //文件大小
            $file_size = $_FILES['imgFile']['size'];
            //检查文件名
            if (!$file_name) {
                alert("请选择文件。");
            }
            //检查目录
            if (@is_dir($save_path) === false) {
                alert("上传目录不存在。");
            }
            //检查目录写权限
            if (@is_writable($save_path) === false) {
                alert("上传目录没有写权限。");
            }
            //检查是否已上传
            if (@is_uploaded_file($tmp_name) === false) {
                alert("上传失败。");
            }
            //检查文件大小
            if ($file_size > $max_size) {
                alert("上传文件大小超过限制。");
            }
            //检查目录名
            $dir_name = empty($_GET['dir']) ? 'image' : trim($_GET['dir']);
            if (empty($ext_arr[$dir_name])) {
                alert("目录名不正确。");
            }
            //获得文件扩展名
            $temp_arr = explode(".", $file_name);
            $file_ext = array_pop($temp_arr);
            $file_ext = trim($file_ext);
            $file_ext = strtolower($file_ext);
            //检查扩展名
            if (in_array($file_ext, $ext_arr[$dir_name]) === false) {
                alert("上传文件扩展名是不允许的扩展名。\n只允许" . implode(",", $ext_arr[$dir_name]) . "格式。");
            }
            //创建文件夹
            if ($dir_name !== '') {
                $save_path .= $dir_name . "/";
                $save_url .= $dir_name . "/";
                if (!file_exists($save_path)) {
                    mkdir($save_path);
                }
            }
            $ymd = date("Ymd");
            $save_path .= $ymd . "/";
            $save_url .= $ymd . "/";
            if (!file_exists($save_path)) {
                mkdir($save_path);
            }
            //新文件名
            $new_file_name = date("YmdHis") . '_' . rand(10000, 99999) . '.' . $file_ext;
            //移动文件
            $file_path = $save_path . $new_file_name;
            if (move_uploaded_file($tmp_name, $file_path) === false) {
                alert("上传文件失败。");
            }
            @chmod($file_path, 0644);
            $file_url = $save_url . $new_file_name;
            header('Content-type: text/html; charset=UTF-8');
            echo json_encode(array('error' => 0, 'url' => $file_url),JSON_UNESCAPED_UNICODE);exit;
        }
    }
    /**
     * @NodeAnotation(title="kindeditor文件管理")
     */
    public function kindeditor_file_manager()
    {
        //根目录路径，可以指定绝对路径
        $root_path = STATIC_PATH . '/uploads/kindeditor/';
        // 根目录URL，可以指定绝对路径，比如 http://www.yoursite.com/attached/
        $root_url = Config::get('view.tpl_replace_string.__STATIC__') . '/uploads/kindeditor/';
        //图片扩展名
        $ext_arr = array('gif', 'jpg', 'jpeg', 'png', 'bmp');
        //目录名
        $dir_name = empty($_GET['dir']) ? '' : trim($_GET['dir']);
        if (!in_array($dir_name, array('', 'image', 'flash', 'media', 'file'))) {
            echo "Invalid Directory name.";
            exit;
        }
        if ($dir_name !== '') {
            $root_path .= $dir_name . "/";
            $root_url .= $dir_name . "/";
            if (!file_exists($root_path)) {
                mkdir($root_path);
            }
        }
        //根据path参数，设置各路径和URL
        if (empty($_GET['path'])) {
            $current_path = realpath($root_path) . '/';
            $current_url = $root_url;
            $current_dir_path = '';
            $moveup_dir_path = '';
        } else {
            $current_path = realpath($root_path) . '/' . $_GET['path'];
            $current_url = $root_url . $_GET['path'];
            $current_dir_path = $_GET['path'];
            $moveup_dir_path = preg_replace('/(.*?)[^\/]+\/$/', '$1', $current_dir_path);
        }
        //echo realpath($root_path);
        //排序形式，name or size or type
        $order = empty($_GET['order']) ? 'name' : strtolower($_GET['order']);
        //不允许使用..移动到上一级目录
        if (preg_match('/\.\./', $current_path)) {
            echo 'Access is not allowed.';
            exit;
        }
        //最后一个字符不是/
        if (!preg_match('/\/$/', $current_path)) {
            echo 'Parameter is not valid.';
            exit;
        }
        //目录不存在或不是目录
        if (!file_exists($current_path) || !is_dir($current_path)) {
            echo 'Directory does not exist.';
            exit;
        }
        //遍历目录取得文件信息
        $file_list = array();
        if ($handle = opendir($current_path)) {
            $i = 0;
            while (false !== ($filename = readdir($handle))) {
                if ($filename{0} == '.') continue;
                $file = $current_path . $filename;
                if (is_dir($file)) {
                    $file_list[$i]['is_dir'] = true; //是否文件夹
                    $file_list[$i]['has_file'] = (count(scandir($file)) > 2); //文件夹是否包含文件
                    $file_list[$i]['filesize'] = 0; //文件大小
                    $file_list[$i]['is_photo'] = false; //是否图片
                    $file_list[$i]['filetype'] = ''; //文件类别，用扩展名判断
                } else {
                    $file_list[$i]['is_dir'] = false;
                    $file_list[$i]['has_file'] = false;
                    $file_list[$i]['filesize'] = filesize($file);
                    $file_list[$i]['dir_path'] = '';
                    $file_ext = strtolower(pathinfo($file, PATHINFO_EXTENSION));
                    $file_list[$i]['is_photo'] = in_array($file_ext, $ext_arr);
                    $file_list[$i]['filetype'] = $file_ext;
                }
                $file_list[$i]['filename'] = $filename; //文件名，包含扩展名
                $file_list[$i]['datetime'] = date('Y-m-d H:i:s', filemtime($file)); //文件最后修改时间
                $i++;
            }
            closedir($handle);
        }
        usort($file_list, 'cmp_func');
        $result = array();
        //相对于根目录的上一级目录
        $result['moveup_dir_path'] = $moveup_dir_path;
        //相对于根目录的当前目录
        $result['current_dir_path'] = $current_dir_path;
        //当前目录的URL
        $result['current_url'] = $current_url;
        //文件数
        $result['total_count'] = count($file_list);
        //文件列表数组
        $result['file_list'] = $file_list;
        //输出JSON字符串
        // header('Content-type: application/json; charset=UTF-8');
        // $json = new Services_JSON();
        // echo $json->encode($result);
        return json($result);
    }
    /**
     * @NodeAnotation(title="kindeditor图片删除")
     */
    public function kindeditor_image_del()
    {
        if ($_POST["action"] == "delete") { //如果action=delete
            $url = $_POST["url"];
            if (empty($url)) { //如果url为空
                die(0);
            }
            $url = $_SERVER['DOCUMENT_ROOT'] . '/' .$url;
            if (file_exists($url)) { //检查文件是否存在
                $result = unlink($url); //删除文件
                if ($result) { //如果成功删除
                    echo 1;
                } else {
                    echo 0;
                }
            } else {
                echo 0;
            }
            exit();
        }
    }
    /**
     * [markdown_image_upload markdown图片上传]
     * @return void
     */
    public function markdown_image_upload()
    {
        $fileSrc = upload('editormd-image-file','markdown',0);
        if ($fileSrc['code'] == 0) {
            return json(['success'=>0,'message'=>$fileSrc['msg'],'url'=>'']);
        }else{
            return json(['success'=>1,'message'=>'上传成功','url'=>config('view.tpl_replace_string.__STATIC__').'/'.$fileSrc['name']]);
        }
    }
    /**
     * @NodeAnotation(title="上传本地文件")
     */
    public function native_upload()
    {
        if (request()->isAjax()) {
            // 上传文件存储目录名称
            $dirname = input('name', 'default');
            // 上传图片是否添加水印
            $iswater = input('iswater', '0');
            // 上传图片是否缩略
            $isthumb = input('isthumb', '0');
            // 缩略宽度
            $thumbwidth = input('thumbwidth', '');
            // 缩略高度
            $thumbheight = input('thumbheight', '');
            // 文件
            $name = array_keys($_FILES)[0];
            // $fileSrc = upload($_FILES[$name], $dirname);//方法一
            $fileSrc = upload($name, $dirname);//方法二
            $data['code'] = $fileSrc['code'];//状态
            $data['path'] = $fileSrc['name'];//注意
            // 判断是否缩略
            if ($isthumb && get_one_cache_config('WEB_ENABLE_THUMB')) {
                $res = ImageTool::thumb($data['path'], $type = '', $thumbwidth, $thumbheight, $save_type = '', $quality = '', $interlace = '', $del = true);
                if ($res['code']) {
                    $data['path'] = $res['path'];
                } else {
                    return json(['code' => 0, 'msg' => $res['msg']]);
                }
            }
            // 判断是否加水印
            if ($iswater && get_one_cache_config('WEB_ENABLE_WATER')) {
                $res = ImageTool::water($data['path'], $type = '', $water_img = '', $water_text = '', $text_size = '', $text_color = '', $water_tmd = '', $water_pos = '', $del = true);
                if ($res['code']) {
                    $data['path'] = $res['path'];
                } else {
                    return json(['code' => 0, 'msg' => $res['msg']]);
                }
            }
            $data['msg'] = $fileSrc['msg'];
            $data['filename'] = $name;
            return json($data);
        }
    }
    /**
     * @NodeAnotation(title="本地图片裁剪")
     */
    public function crop()
    {
        // More info: http://deepliquid.com/content/Jcrop_Implementation_Theory.html
        if (request()->isPost()) {
            if ($_SERVER['REQUEST_METHOD'] == 'POST') {
                $targ_w = $_POST['w'];
                $targ_h = $_POST['h'];
                if (!$targ_h && !$targ_w) {
                    return json(['code'=>0,'msg'=>'请选择裁剪尺寸！','url'=>'']);
                }
                $jpeg_quality = 90;
                $src = STATIC_PATH . '/' . input('filevalue');
                $img_data = getimagesize($src);
                $filename = basename($src); //文件名
                $filenameArr = explode('.', $filename);
                $i = 1;
                do {
                    $newfilename = str_replace('.' . end($filenameArr), '', $filename) . '-' . $i . '.' . end($filenameArr);
                    $newsrc = dirname($src) . '/' . $newfilename;
                    $i++;
                } while (file_exists($newsrc));
                $img_data_arr = explode('/', $img_data['mime']);
                $ext = end($img_data_arr);
                switch ($ext) {
                    case 'png':
                        $jpeg_quality = 9; // 取值0-9
                        $img_r = imagecreatefrompng($src);
                        $dst_r = ImageCreateTrueColor($targ_w, $targ_h);
                        imagecopyresampled($dst_r, $img_r, 0, 0, $_POST['x1'], $_POST['y1'], $targ_w, $targ_h, $_POST['w'], $_POST['h']);
                        header('Content-type: image/png');
                        imagepng($dst_r, $newsrc, $jpeg_quality);
                        break;

                    case 'jpeg':
                        $jpeg_quality = 90; // 取值0-99
                        $img_r = imagecreatefromjpeg($src);
                        $dst_r = ImageCreateTrueColor($targ_w, $targ_h);
                        imagecopyresampled($dst_r, $img_r, 0, 0, $_POST['x1'], $_POST['y1'], $targ_w, $targ_h, $_POST['w'], $_POST['h']);
                        header('Content-type: image/jpeg');
                        imagejpeg($dst_r, $newsrc, $jpeg_quality);
                        break;
                    default:
                        $jpeg_quality = 90;
                        $create_function = 'imagecreatefrom' . $ext;
                        $img_r = $create_function($src);
                        $dst_r = ImageCreateTrueColor($targ_w, $targ_h);
                        imagecopyresampled($dst_r, $img_r, 0, 0, $_POST['x1'], $_POST['y1'], $targ_w, $targ_h, $_POST['w'], $_POST['h']);
                        header('Content-type: image/' . $ext);
                        $image_function = 'image' . $ext;
                        $image_function($dst_r, $newsrc, $jpeg_quality);
                        break;
                }
                $filevalue = str_replace(STATIC_PATH . '/', '', $newsrc);
                View::assign(['filevalue'=>$filevalue]);
            }
        }
        return view('crop');
    }
    /**
     * @NodeAnotation(title="删除文件")
     * @param string $url 文件地址
     */
    public function delimg($url = "")
    {
        if ($url !== "" || !empty($url)) {
            // 获取路径
            $file = get_file_path($url,2);
            if(strpos($file,'http') === false){ //本地的图片删除
                $arr = explode('/',$file);
                $end = end($arr);
                $r = Db::name('attachment')->field('id')->where('file_name',$end)->find();
                if($r){
                    Db::name('attachment')->delete($r['id']);
                }
                if (file_exists($file)) {
                    $res = @unlink($file);
                    if ($res) {
                        return json(['code' => 1, 'msg' => '删除成功']);
                    }
                    return json(['code' => 0, 'msg' => '删除失败']);
                }
                return json(['code' => 2, 'msg' => '文件不存在']);
            }else{ // 云端图片删除，真正删除由文件控制台操作
                return json(['code'=>1,'msg'=>'删除成功！']);
            }
        }
        return json(['code'=>0,'msg'=>'图片地址不能为空！']);
    }
    /**
     * [OSSupload 阿里云oss上传]
     * @return void
     */
    protected function OSSupload()
    {
        $group_id = input('group_id', 0);//分组ID
        if (!empty($_FILES)) {
            $name = '';
            foreach ($_FILES as $key => $value) {
                $name = $key;
            }
            $error = $_FILES[$name]['error'];
            switch ($_FILES[$name]['error']) {
                case 0:
                    $msg = '';
                    break;
                case 1:
                    $msg = '超出了php.ini中文件大小';
                    break;
                case 2:
                    $msg = '超出了MAX_FILE_SIZE的文件大小';
                    break;
                case 3:
                    $msg = '文件被部分上传';
                    break;
                case 4:
                    $msg = '没有文件上传';
                    break;
                case 5:
                    $msg = '文件大小为0';
                    break;
                default:
                    $msg = '上传失败';
                    break;
            }
            // 获取文件后缀
            $arr = explode('.',  $_FILES[$name]['name']);
            $ext = end($arr);
            // 获取文件类型
            if (strpos($_FILES[$name]['type'], 'image/') !== false) {
                $type = 'image';
            } elseif (strpos($_FILES[$name]['type'], 'video/') !== false) {
                $type = 'video';
            }else{
                $type = 'file';
            }
            $file_name = time() . mt_rand(1, 1000) . '.' .$ext;
            $ossClient = new Aliyunoss();
            $url = $ossClient->uploadFile($file_name, $_FILES[$name]['tmp_name']);
            $data = array('extension' => $ext, 'size' => $_FILES[$name]['size'], 'type' => $type, 'url' => $url);
            $db = Db::connect();
            $fsql = " INSERT INTO `hh_attachment` (`group_id`, `upload_mode`, `file_name`,`file_type`) VALUES ('$group_id', '2', '$file_name','$type') ";
            $db->query($fsql);
            echo json_encode(array("code" => $error, 'msg' => $msg, 'name' => $file_name, "url" => $url, 'data' => $data));
            exit();
        }
    }
}
