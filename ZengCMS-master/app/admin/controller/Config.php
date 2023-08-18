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
// | 配置控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\facade\Db;
use think\facade\View;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="配置管理")
 * Class Config
 * @package app\admin\controller
 */
class Config extends Base 
{
	/**
     * @NodeAnotation(title="列表")
     */
	public function index() 
	{
		$map = array();
		$query = array();
		$config_type_id = trim(input('config_type_id'));
		$form_type = trim(input('form_type'));
		$status = trim(input('status'));
		$title = trim(input('title'));
		if ($config_type_id !== '' && is_numeric($config_type_id)) {
			$map[] = ['config_type_id', '=', $config_type_id];
			$query['config_type_id'] = $config_type_id;
		}
		if($form_type){
			$map[] = ['form_type', '=', $form_type];
			$query['form_type'] = $form_type;
		}
		if ($status !== '' && ($status == 0 || $status == 1)) {
			$map[] = ['c.status', '=', $status];
			$query['status'] = $status;
		}
		if ($title) {
			$map[] = ['ename|cname', 'like', "%$title%"];
			$query['title'] = $title;
		}
		$order = ['c.sort' => 'desc', 'c.id' => 'asc']; //排序
		$list = Db::name('config')->alias('c')->field('c.*,ct.config_type_name')->leftJoin('config_type ct', 'c.config_type_id=ct.id')->where($map)->order($order)
		->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query])->each(function ($item, $key) {
			int_to_string($item, array('status' => array('0' => '隐藏', '1' => '显示')));
			int_to_string($item, array('form_type' => array('input' => '单行文本','tags'=>'标签','markdown'=>'markdown编辑器','colorpicker'=>'取色器','datetime'=>'时间','selects'=>'高级下拉多选','selecto'=>'高级下拉单选','map'=>'地图','region'=>'地区','array'=>'数组','radio' => '单选按钮', 'checkbox' => '复选框', 'select' => '下拉菜单', 'textarea' => '文本域', 'file' => '附件','editor'=>'编辑器','picture'=>'单图','piclist'=>'多图','onefile'=>'单文件','filelist'=>'多文件','onevideo'=>'单视频','videolist'=>'多视频')));
			int_to_string($item, array('is_core_configuration' => array('0' => '否', '1' => '是')));
			return $item;
		});
		$configTypeRes = Db::name('config_type')->order('sort desc,id desc')->select()->toArray(); //所有配置类型信息
		View::assign([
			'meta_title' => '配置列表', //标题
			'list' => $list, //列表
			'status' => $status, //状态
			'configTypeRes' => $configTypeRes, //所有配置类型信息
			'config_type_id' => $config_type_id, //配置类型id 搜索条件
			'form_type' => $form_type, //配置类型id 搜索条件
		]);
		// 记录当前列表页的cookie
		cookie('__forward__', $_SERVER['REQUEST_URI']);
		return view();
	}
	/**
     * @NodeAnotation(title="新增")
     */
	public function add() 
	{
		if (request()->isAjax()) {
			$data = input('post.');
			// 数据验证
			$validate = validate('Config');
			if (!$validate->scene('add')->check($data)) {
				return json(['code'=>'0','msg'=>$validate->getError(),'url'=>'']);
			}
			// 可选值处理
			$data['values'] =  str_replace('，', ',', $data['values']); //把中文逗号改为英文逗号
			$data['values'] =  str_replace('：', ':', $data['values']); //把中文冒号改为英文冒号
			// 默认值处理
			$data['value'] =  str_replace('，', ',', $data['value']); //把中文逗号改为英文逗号
			$data['value'] =  str_replace('：', ':', $data['value']); //把中文冒号改为英文冒号
			// 配置说明的处理
			// strpos() 函数查找字符串在另一字符串中第一次出现的位置。（区分大小写）
			// stripos() - 查找字符串在另一字符串中第一次出现的位置（不区分大小写）
			// strripos() - 查找字符串在另一字符串中最后一次出现的位置（不区分大小写）
			// strrpos() - 查找字符串在另一字符串中最后一次出现的位置（区分大小写）
			if (strpos($data['remark'], "@") !== false) {
				$remarkArr = explode('@', $data['remark']);
				if (stripos($remarkArr[1], 'http://') === false && stripos($remarkArr[1], 'https://') === false) {
					$remarkArr[1] =  'https://' . $remarkArr[1];
					$data['remark'] = $remarkArr[0] . '@' . $remarkArr[1];
				}
			}
			$data['create_time'] = time(); //创建时间
			$id = Db::name('config')->strict(false)->insertGetId($data); //新增基础内容
			if (!$id) {
				return json(['code'=>'0','msg'=>'新增出错！','url'=>'']);
			}
			// 记录新增后行为
			action_log($id, 'config', 1);
			return json(['code'=>'1','msg'=>'新增成功','url'=>(string)url('Config/index', array('config_type_id' => $data['config_type_id']))]);
		} else {
			$info = null; //设置空信息
			$config_type_id = trim(input('config_type_id')); //配置类型id
			$configTypeRes = Db::name('config_type')->select()->toArray(); //所有配置类型信息
			View::assign([
				'meta_title' => '新增配置', //标题title
				'info' => $info, //空信息
				'configTypeRes' => $configTypeRes, //所有配置类型信息
				'config_type_id' => $config_type_id, //配置类型id
			]);
			return view('edit');
		}
	}
	/**
     * @NodeAnotation(title="编辑")
     */
	public function edit($id = null) 
	{
		if (empty($id)) {
			return json(['code'=>'0','msg'=>'参数错误！','url'=>'']);
		}
		$info = Db::name('config')->find($id); //当前信息
		if (request()->isAjax()) {
			$data = input('post.');
			// 数据验证
			$validate = validate('Config');
			if (!$validate->scene('edit')->check($data)) {
				return json(['code'=>'0','msg'=>$validate->getError(),'url'=>'']);
			}
			// 可选值处理
			$data['values'] =  str_replace('，', ',', $data['values']); //把中文逗号改为英文逗号
			$data['values'] =  str_replace('：', ':', $data['values']); //把中文冒号改为英文冒号
			// 默认值处理
			$data['value'] =  str_replace('，', ',', $data['value']); //把中文逗号改为英文逗号
			$data['value'] =  str_replace('：', ':', $data['value']); //把中文冒号改为英文冒号
			// 配置说明的处理
			// strpos() 函数查找字符串在另一字符串中第一次出现的位置。（区分大小写）
			// stripos() - 查找字符串在另一字符串中第一次出现的位置（不区分大小写）
			// strripos() - 查找字符串在另一字符串中最后一次出现的位置（不区分大小写）
			// strrpos() - 查找字符串在另一字符串中最后一次出现的位置（区分大小写）
			if (strpos($data['remark'], "@") !== false) {
				$remarkArr = explode('@', $data['remark']);
				if (stripos($remarkArr[1], 'http://') === false && stripos($remarkArr[1], 'https://') === false) {
					$remarkArr[1] =  'https://' . $remarkArr[1];
					$data['remark'] = $remarkArr[0] . '@' . $remarkArr[1];
				}
			}
			$data['id'] = intval($data['id']);
			if ($data['id'] == 0) {
				return json(['code'=>'0','msg'=>'非法操作！','url'=>'']);
			}
			$data['update_time'] = time(); //最后一次更新时间
			action_log($data['id'], 'config', 2); //记录修改前行为
			$res = Db::name('config')->strict(false)->where('id',$data['id'])->update($data); //更新基础内容
			if (!$res) {
				return json(['code'=>'0','msg'=>'更新出错！','url'=>'']);
			}
			action_log($data['id'], 'config', 2); //记录修改后行为
			if ($info['sort'] == $data['sort']) {
				// 判断是否修改排序值如果修改就跳转到列表页，没有修改就跳转当前页
				return json(['code'=>1,'msg'=>'更新成功！','url'=>cookie('__forward__')]);
			} else {
				return json(['code'=>1,'msg'=>'更新成功！','url'=>'Config/index']);
			}
		} else {
			if (!$info) {
				return json(['code'=>'0','msg'=>'信息错误！','url'=>'']);
			}
			$configTypeRes = Db::name('config_type')->select()->toArray(); //所有配置类型信息
			View::assign([
				'meta_title' => '编辑配置', //标题 title
				'info' => $info, //当前信息
				'configTypeRes' => $configTypeRes, //所有配置类型信息
			]);
			return view();
		}
	}
	/**
     * @NodeAnotation(title="删除")
     */
	public function del($ids = NULL) 
	{
		$ids = !empty($ids) ? $ids : input('ids', 0);
		if (empty($ids)) {
			return json(['code'=>'0','msg'=>'参数不能为空！','url'=>'']);
		}
		if (!is_array($ids)) {
			$ids = array(intval($ids));
		}
		$map = [
			['is_core_configuration', '=', 1],
			['id', 'in', $ids],
		];
		$core_configuration_number = Db::name('config')->field('value')->where($map)->count();
		if ($core_configuration_number) {
			return json(['code'=>'0','msg'=>'核心配置不能删除！','url'=>'']);
		}
		foreach ($ids as $k => $v) {
			$config = Db::name('config')->field('value')->where('form_type','file')->find($v);
			if (!empty($config['value'])) {
				$img = STATIC_PATH . '/' . $config['value'];
				if (file_exists($img)) {
					@unlink($img);
				}
			}
			// 记录删除行为
			action_log($v, 'config', 3);
			$res = Db::name('config')->delete($v);
			if (!$res) {
				return json(['code'=>'0','msg'=>'删除失败！','url'=>'']);
			}
		}
		return json(['code'=>'1','msg'=>'删除成功！','url'=>'']);
	}
	/**
	 * @NodeAnotation(title="状态")
	 * [setStatus 设置一条或者多条数据的状态 或 删除一条或多条数据的基本信息]
	 * @param string  $model [表名]
	 * @param array   $data  [数据]
	 * @param integer $type  [类型]
	 */
	public function setStatus($model = 'config', $data = array(), $type = 1) 
	{
		$ids = input('ids');
		$status = input('status');
		$data['ids'] = $ids;
		$data['status'] = $status;
		return parent::setStatus($model, $data, $type);
	}
	/**
	 * @NodeAnotation(title="排序")
	 * @param  string $model [表名]
	 * @param  array  $data  [数据]
	 * @return [type]        [description]
	 */
	public function sort($model = 'config', $data = array()) 
	{
		$data['sort'] = input('sort');
		return parent::sort($model, $data);
	}
	/**
     * @NodeAnotation(title="网站配置")
     */
	public function configuration() 
	{
		if (request()->isAjax()) {
			$data = input('post.');
			$ename = array_keys($data);
			$allCheck = Db::name('config')
			->field('ename')
			->where([['form_type' ,'=', 'checkbox'],['config_type_id' ,'=', $data['config_type_id']]])
			->select()
			->toArray();
			// 如果复选框没有选就把复选框的默认值设置为空
			if ($allCheck) {
				foreach ($allCheck as $k => $v) {
					if (!in_array($v['ename'], $ename)) {
						$data[$v['ename']] = '';
					}
				}
			}
			// dump($data);die;
			// 把复选框的可选值用逗号分隔
			foreach ($data as $k => $v) {
				// if (is_array($v)) {
				// 	$v = implode(',', $v);
				// }
				if(is_array($v)){
					if(array_level($v) == 2){ //数组字段值转为json数据
						// dump($v);die;
                        $arr = [];
                        foreach($v[0] as $k2=>$v2){
                            if($v2){
                                $arr[$v2] = $v[1][$k2];
                            }
                        }
                        $data[$k] = json_encode($arr);
                    }else{ //多选，把数组转为字符串以逗号隔开
                        $data[$k] = implode(',', $v);
                    }
                }else{
                    $data[$k] = $v;
                }
				Db::name('config')->where('ename' , $k)->update(['value' => $data[$k]]);
			}
			// 文件批量上传
			if (!empty($_FILES)) {
				foreach ($_FILES as $k => $v) {
					if ($v['tmp_name']) {
						$file = $k;
						$ext = get_one_config('WEB_CONFIG_FILE_EXT') ?: 'jpg,jpeg,png';//上传文件类型设置
						$size = get_one_config('WEB_CONFIG_FILE_SIZE') ?: 20;//上传文件大小设置
						$fileSrc = upload($file,'config',0,$size,$ext);
						$img = Db::name('config')->field('cname,value')->where('ename', $k)->find();
						if ($fileSrc['code'] == 0) {
							return json(['code'=>0,'msg'=>$img['cname'] . $fileSrc['msg'],'url'=>'']);
						} else {
							if (!empty($img['value'])) {
								// 删除旧文件
								$oldimg = STATIC_PATH . '/' . $img['value'];
								$oldimg = iconv('utf-8', 'gbk', $oldimg);
								if (file_exists($oldimg)) {
									@unlink($oldimg);
								}
							}
							Db::name('config')->where('ename',$k)->update(['value' =>$fileSrc['name']]);
						}
					}
				}
			}
			return json(['code'=>1,'msg'=>'更新配置成功!','url'=>'']);
		}
		$id = input('id', 0); //获取选中配置类型id
		if (!$id) {
			$id = Db::name('config_type')->where('status' , 1)->order('sort desc,id desc')->limit(1)->value('id');
		}
		$configTypeRes = Db::name('config_type')->field('id,config_type_name')->where('status',1)->order('sort DESC')->select()->toArray();
		$config_type_name = Db::name('config_type')->where('id',$id)->value('config_type_name');
		$list = Db::name('config')->where([['config_type_id' ,'=', $id], ['status' ,'=', 1]])->order('sort desc,id asc')->select()->toArray();
		if ($config_type_name) {
			$meta_title = $config_type_name;
			if (!$list) {
				$list = '';
			}
		} else {
			$meta_title = '请设置好配置类型';
			$list = '';
		}
		View::assign([
			'meta_title' => $meta_title, //标题 title
			'id' => $id, //当前选中配置类型id
			'configTypeRes' => $configTypeRes, //所有配置类型信息
			'list' => $list, //当前选中的配置类型的所有配置
			'STATIC_PATH' => STATIC_PATH, //上传文件根路径
		]);
		return view();
	}
	/**
     * @NodeAnotation(title="下载文件或图片")
     */
	public function download() 
	{
		$ename = input('ename');
		$config = Db::name('config')->field('cname,value')->where('ename',$ename)->find();
		if ($config['value']) {
			$xpath = STATIC_PATH . '/' . $config['value'];
			$xpath = iconv('utf-8', 'gbk', $xpath);
			if (file_exists($xpath)) {
				$arr = explode('.', basename($xpath));
				$ext = end($arr); //文件后缀
				header('Content-Description: File Transfer');
				header('Content-Type: application/octet-stream');
				// header ('Content-Disposition: attachment; filename='.basename ($xpath));
				// 文件名取配置的中文名称吧
				header('Content-Disposition: attachment; filename=' . $config['cname'] . '.' . $ext);
				header('Content-Transfer-Encoding: binary');
				header('Expires: 0');
				header('Cache-Control: must-revalidate');
				header('Pragma: public');
				header('Content-Length:' . filesize($xpath));
				ob_clean();
				flush();
				readfile($xpath);
				exit;
			} else {
				return json(['code'=>0,'msg'=>'文件或图片不存在！','url'=>'']);
			}
		} else {
			return json(['code'=>0,'msg'=>'文件或图片不存在！','url'=>'']);
		}
	}
	/**
     * @NodeAnotation(title="ajax异步删除文件或图片")
     */
	public function delete_file() 
	{
		if (request()->isAjax()) {
			$ename = input('ename');
			$REQUEST_URI = input('REQUEST_URI');
			$path = Db::name('config')->where('ename',$ename)->value('value');
			if ($path) {
				$xpath = STATIC_PATH . '/' . $path;
				$xpath = iconv('utf-8', 'gbk', $xpath);
				if (file_exists($xpath)) {
					@unlink($xpath);
					Db::name('config')->where('ename',$ename)->update(['value' => '']);
					return json(['code'=>1,'msg'=>'删除成功！','url'=>'']);
				} else {
					Db::name('config')->where('ename',$ename)->update(['value' => '']);
					return json(['code'=>0,'msg'=>'文件不存在！','url'=>$REQUEST_URI]);
				}
			} else {
				return json(['code'=>0,'msg'=>'文件不存在！','url'=>$REQUEST_URI]);
			}
		}
	}
}
