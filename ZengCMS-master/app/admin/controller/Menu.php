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
// | 菜单(规则)控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use tree\Tree;
use think\facade\Db;
use think\facade\View;
use app\common\auth\Node as NodeService;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="菜单(规则)管理")
 * Class Menu
 * @package app\admin\controller
 */
class Menu extends Base 
{
	/**
     * @NodeAnotation(title="列表")
     */
	public function index() 
	{
		$map = array();
		if (!isset($_GET['pid'])) {
			// 从左侧栏点击过来的
			$map[] = ['pid', '=', 0];
			$pid = 0; // 用于搜索框里的选择 顶级菜单
			$current_pid = 0; // 用于找到上级菜单从而返回上级菜单
		} elseif (isset($_GET['pid']) && $_GET['pid'] !== 'all') {
			// 搜索(条件是顶级菜单)或点菜单中文名称过来的
			$map[] = ['pid', '=', (int) $_GET['pid']];
			$pid = 0; // 无论是多少都设置为零，用于搜索框里的选择 顶级菜单
			$current_pid = (int) $_GET['pid']; // 用于找到上级菜单从而返回上级菜单
		} else { // 搜索过来的(条件是全部菜单，不是顶级菜单)
			$pid = 'all'; // 用于搜索框里的选择，全部菜单
			$current_pid = 0; //用于找到上级菜单从而返回上级菜单
		}
		$status = trim(input('status'));
		$show = trim(input('show'));
		$title = trim(input('title'));
		if ($status !== '' && ($status == 0 || $status == 1)) {
			$map[] = ['status', '=', $status];
		}
		if ($show !== '' && ($show == 0 || $show == 1)) {
			$map[] = ['show', '=', $show];
		}
		if ($title) {
			$map[] = ['name|title', 'like', "%$title%"];
		}
		$order = ['sort' => 'desc', 'id' => 'asc']; //排序
		$mList = Db::name('auth_rule')->where($map)->order($order)->select()->toArray();
		foreach ($mList as $k => $v) {
			if ($v['pid'] == 0) {
				$mList[$k]['pid_title'] = '顶级栏目';
			} else {
				$mList[$k]['pid_title'] = Db::name('auth_rule')->where('id',$v['pid'])->value('title');
			}
			if(Db::name('auth_rule')->where('pid',$v['id'])->find()){
				$mList[$k]['child'] = '有';
			}else{
				$mList[$k]['child'] = '无';
			}
		}
		int_to_string2($mList,array('status' => array('0' => '禁用', '1' => '正常')));
		int_to_string2($mList,array('show' => array('0' => '隐藏', '1' => '显示')));
		$prev_pid = Db::name('auth_rule')->where('id',$current_pid)->value('pid'); //返回上级菜单
		if ($prev_pid) {
			$prev_pid = $prev_pid;
		} else {
			$prev_pid = 0;
		}
		View::assign([
			'status' => $status, //启用状态
			'show' => $show, //显示状态
			'meta_title' => '菜单列表', //标题
			'list' => $mList, // 菜单列表
			'pid' => $pid, //用于搜索框里的选择 全部或顶级菜单
			'prev_pid' => $prev_pid, //返回上级菜单
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
		$pid = input('pid', 0);
		if (request()->isAjax()) {
			$data = input('post.');
			// 数据验证
			$validate = validate('AuthRule');
			if (!$validate->scene('add')->check($data)) {
				return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
			}
			$data['create_time'] = time(); // 创建时间
			$id = Db::name('auth_rule')->strict(false)->insertGetId($data); // 新增基础内容
			if (!$id) {
				return json(['code'=>0,'msg'=>'新增出错！','url'=>'']);
			}
			// 记录新增后行为
			action_log($id,'auth_rule',1);
			return json(['code'=>1,'msg'=>'新增成功！','url'=>(string)url('Menu/index') . '?pid=' . $pid]);
		} else {
			$info = null; // 设置空信息
			$order = ['sort' => 'desc', 'id' => 'asc'];
			$menuRes = Db::name('auth_rule')->order($order)->select()->toArray();
			$tree = new Tree();
			$menuRes = $tree->ChildrenTree($menuRes,0, 0);
			View::assign([
				'meta_title' => '新增菜单', // 标题title
				'info' => $info, // 空信息
				'menuRes' => $menuRes, // 所有菜单(规则)信息
				'pid' => $pid, // 上级菜单id
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
			return json(['code'=>0,'msg'=>'参数错误！','url'=>'']);
		}
		$id = intval($id);
		$tree = new Tree();
		// 当前信息
		$info = Db::name('auth_rule')->field(true)->find($id);
		if (request()->isAjax()) {
			$data = input('post.');
			// 数据验证
			$validate = validate('AuthRule');
			if (!$validate->scene('edit')->check($data)) {
				return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
			}
			// 找该菜单的所有子菜单
			$ChildrenIdsArr = $tree->ChildrenIdsArr(Db::name('auth_rule'), $id);
			$ChildrenIdsArr[] = $id;
			if (in_array($data['pid'], $ChildrenIdsArr)) {
				return json(['code'=>0,'msg'=>'上级菜单不能为其子菜单或自身！','url'=>'']);
			}
			$data['id'] = intval($data['id']);
			if ($data['id'] == 0) {
				return json(['code'=>0,'msg'=>'非法操作！','url'=>'']);
			}
			$data['update_time'] = time(); //最后一次修改时间
			action_log($data['id'],'auth_rule',2); // 记录修改前行为
			$res = Db::name('auth_rule')->strict(false)->where('id',$data['id'])->update($data); //更新基础内容
			if (!$res) {
				return json(['code'=>0,'msg'=>'更新出错！','url'=>'']);
			}
			action_log($data['id'], 'auth_rule', 2); // 记录修改后行为
			if ($info['sort'] == $data['sort']) {
				// 判断是否修改排序值如果修改就跳转到列表页，没有修改就跳转当前页
				return json(['code'=>1,'msg'=>'更新成功！','url'=>cookie('__forward__')]);
			} else {
				return json(['code'=>1,'msg'=>'更新成功！','url'=>'index']);
			}
		} else {
			if (!$info) {
				return json(['code'=>0,'msg'=>'信息错误！','url'=>'']);
			}
			$order = ['sort' => 'desc', 'id' => 'asc'];
			$menuRes = Db::name('auth_rule')->order($order)->select()->toArray();
			// 所有菜单信息
			$menuRes = $tree->ChildrenTree($menuRes,0,0);
			View::assign([
				'meta_title' => '编辑菜单', //标题 title
				'info' => $info, //当前信息
				'menuRes' => $menuRes, //所有菜单信息
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
			return json(['code'=>0,'msg'=>'参数不能为空！','url'=>'']);
		}
		if (!is_array($ids)) {
			$ids = array(intval($ids));
		}
		//判断该菜单有没有子菜单，有就不能删除
		$map[] = ['pid', 'in', $ids];
		$menuRes = Db::name('auth_rule')->field('id')->where($map)->select()->toArray();
		if (!empty($menuRes)) {
			return json(['code'=>0,'msg'=>'请先删除该菜单下的所有子菜单！','url'=>'']);
		} else {
			foreach ($ids as $k => $v) {
				// 记录删除行为
				action_log($v,'auth_rule',3);
				// 删除该菜单信息
				Db::name('auth_rule')->delete($v);
			}
			return json(['code'=>1,'msg'=>'删除成功！','url'=>'']);
		}
	}
	/**
     * @NodeAnotation(title="显示/隐藏")
     */
	public function setShow($model = 'auth_rule', $data = array(), $type = 1) 
	{
		$ids = input('ids');
		$show = input('show');
		$data['ids'] = $ids;
		$data['show'] = $show;
		return $this->setStatus($model, $data, $type);
	}
	/**
     * @NodeAnotation(title="状态")
     */
	public function setStatus($model = 'auth_rule', $data = array(), $type = 2) 
	{
		$ids = input('ids');
		$status = input('status');
		$data['ids'] = $ids;
		$data['status'] = $status;
		return parent::setStatus($model, $data, $type);
	}
	/**
     * @NodeAnotation(title="排序")
     */
	public function sort($model = 'auth_rule', $data = array()) 
	{
		$data['sort'] = input('sort');
		return parent::sort($model, $data);
	}
	/**
     * @NodeAnotation(title="移动菜单")
     */
	public function move() 
	{
		$id = input('id', 0);
		$id = intval($id);
		if (empty($id)) {
			return json(['code'=>0,'msg'=>'参数错误！','url'=>'']);
		}
		$info = Db::name('auth_rule')->field('title,pid')->find($id);
		$tree = new Tree();
		if (request()->isAjax()) {
			$data = input('post.');
			//找该菜单的所有子菜单
			$ChildrenIdsArr = $tree->ChildrenIdsArr(Db::name('auth_rule'), $id);
			$ChildrenIdsArr[] = $id;
			if (in_array($data['pid'], $ChildrenIdsArr)) {
				return json(['code'=>0,'msg'=>'目标菜单不能为其子菜单或自身！','url'=>'']);
			}
			$res = Db::name('auth_rule')->where('id',$id)->update(['pid' => $data['pid']]);
			if ($res !== false) {
				return json(['code'=>1,'msg'=>'移动成功！','url'=>cookie('__forward__')]);
			} else {
				return json(['code'=>0,'msg'=>'移动失败！','url'=>'']);
			}
		}
		$order = ['sort' => 'desc', 'id' => 'asc'];
		// 所有菜单信息
		$menuRes = Db::name('auth_rule')->order($order)->select()->toArray();
		// 所有菜单信息，$id去掉因为上面也有$id会覆盖
		$menuRes = $tree->ChildrenTree($menuRes, 0, 0); 
		View::assign([
			'meta_title' => '移动菜单',
			'id' => $id, // 当前菜单(规则)id
			'menuRes' => $menuRes, // 所有菜单信息
			'info' => $info, // 当前菜单信息，即菜单中文名称和pid
		]);
		return view();
	}
	/**
     * @NodeAnotation(title="菜单搜索")
     */
	public function search() 
	{
		$keywords = input('keywords');
		$list = Db::name('auth_rule')->where([['title|remark|name', 'like', "%$keywords%"]])
		->paginate(get_one_config('WEB_ONE_PAGE_NUMBER'), false, ['query' => request()->param()]);
		View::assign([
			'meta_title'=>'搜索菜单',
			'list' => $list,
		]);
		return view();
	}
	// 测试还有哪些菜单没有添加
	public function update_menu()
	{
		$nodeList = (new NodeService())->getNodelist();
		$m = app('http')->getName();
		foreach($nodeList as $k=>$v){
			if($v['type'] == 2){
				// 取/前面内容
				$c = substr($v['node'],0,strpos($v['node'], '/'));
				// 插件菜单过滤
				if(strpos($c,'.') !== false){
					$cArr = explode('.',$c);
					$c = $cArr[0].'.'.ucfirst(camelize($cArr[1]));
				}else{
					// 下划线转驼峰,并第一个字母大写
					$c = ucfirst(camelize($c));
				}
				// 取/后面内容
				$a = substr($v['node'],strripos($v['node'],"/")+1);
				if(!Db::name('auth_rule')->where('name',$m.'/'.$c.'/'.$a)->find()){
					// 判断还有哪些菜单没有添加
					echo $m.'/'.$c.'/'.$a.'<br>';
					// $title = $m.'/'.$c;
					// $pidmenu = Db::name('auth_rule')->where([['name','like',"%$title%"]])->order('id asc')->limit(1)->find();
					// if($pidmenu){
					// 	Db::name('auth_rule')->insert([
					// 		'pid'=>$pidmenu['id'],
					// 		'title'=>$v['title'],
					// 		'name'=>$m.'/'.$c.'/'.$a,
					// 		'show'=>0,
					// 		'create_time'=>time(),
					// 		'update_time'=>time(),
					// 	]);
					// }
				}
			}
		}
		// return $this->success('更新成功！');
	}
	/**
     * @NodeAnotation(title="测试菜单")
     */
	public function ceshicaidan() 
	{
		// 
	}
}
