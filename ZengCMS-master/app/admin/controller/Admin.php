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
// | 管理员控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;
use think\facade\Db;
use think\facade\View;
use app\admin\model\Admin as AdminModel;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="管理员管理")
 * Class Admin
 * @package app\admin\controller
 */
class Admin extends Base
{
	/**
     * @NodeAnotation(title="列表")
     */
	public function index()
	{
		$map = array();
		$query = array();
		$status = trim(input('status'));
		$title = trim(input('title'));
		$group_id_arr = Db::name('auth_group_access')->where('uid',UID)->column('group_id');
		if(!in_array('1',$group_id_arr)){
			$where[] = ['id','=',UID];
		}else{
			$where = '';
		}
		if ($status !== '' && ($status == 0 || $status == 1)) {
			$map[] = ['status', '=', $status];
			$query['status'] = $status;
		}
		if ($title) {
			$map[] = ['name|relname|phone|email', 'like', "%$title%"];
			$query['title'] = $title;
		}
		$order = ['sort' => 'desc', 'id' => 'desc']; //排序
		$list = Db::name('admin')
		->where($map)
		->where($where)
		->order($order)
		->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query])->each(function ($item, $key) {
			int_to_string($item, $map = array('status' => array('0' => '禁用', '1' => '正常')));
			return $item;
		});
		View::assign([
			'meta_title' => '管理员', //标题
			'status' => $status, //状态
			'list' => $list, //列表
			'uid' => UID, //当前管理员ID
			// 判断是否超级管理员
			'is_super_administrator' => is_super_administrator(UID),
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
			//提交表单
			$data = input('post.');
			// 数据验证
			$validate = validate('Admin');
			if (!$validate->scene('add')->check($data)) {
				return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
			}
			$data['password'] = md6($data['password']);
            $data['create_time'] = time(); //创建时间
            $id = Db::name('admin')->strict(false)->insertGetId($data);
            if (!$id) {
				return json(['code'=>0,'msg'=>'新增出错！','url'=>'']);
            }
            // 记录新增后行为
            // $table_pk_id：表主键值；$table_name：表名；$type 1：新增，2：修改，3：删除；
			action_log($id,'admin',1);
			return json(['code'=>1,'msg'=>'新增成功！','url'=>'index']);
		} else {
			View::assign([
				'meta_title' => '新增管理员', //标题title
				'info' => null, // 空信息
				// 判断是否超级管理员
				'is_super_administrator' => is_super_administrator(UID),
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
		// 判断是否是超级管理员，如果不是超级管理员那么只能修改自身的信息
		// 超级管理员ID为1的只能是是自身才能修改其它超级管理员不能修改
		if (!is_super_administrator(UID) || ($id == 1 && UID !== 1)) {
			$id = UID;
		}
		// 当前管理员信息
		$info = Db::name('admin')->find($id);
		if (request()->isAjax()) {
			// 提交表单
			$updata_password = 0;
			$data = input('post.');
			// 数据验证
			$validate = validate('Admin');
			if (!$validate->scene('edit')->check($data)) {
				return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
			}
			if (isset($data['create_time'])) {
				$data['create_time'] = strtotime($data['create_time']); //注册时间
				$data['update_time'] = strtotime($data['update_time']); //最后登录时间
				$data['success_logins'] = intval($data['success_logins']); //成功登陆次数
				$data['last_login_time'] = strtotime($data['last_login_time']); //最后登录时间
				$data['error_login_time'] = strtotime($data['error_login_time']); //错误登录的时间
				$data['error_logins'] = intval($data['error_logins']); //错误登录次数
			}
			if (!empty($data['password']) || !empty($data['confirm_password'])) {
				if ($data['password'] !== $data['confirm_password']) {
					return json(['code'=>0,'msg'=>'两次密码不一致！','url'=>'']);
				} else {
					if (mb_strlen($data['password']) < 6) {
						return json(['code'=>0,'msg'=>'密码太短！','url'=>'']);
					} elseif (mb_strlen($data['password']) > 32) {
						return json(['code'=>0,'msg'=>'密码太长！','url'=>'']);
					} else {
						$data['password'] = md6($data['password']);
						$updata_password = 1;
					}
				}
			} else {
				unset($data['password']);
				unset($data['confirm_password']);
			}
			$data['update_time'] = time(); //最后一次修改时间
			action_log($data['id'],'admin',2);//记录修改前行为
			if($data['id'] == 1){ //超级管理员状态不能改为禁止
				$data['status'] = 1;
			}
            $res = Db::name('admin')->strict(false)->where('id',$data['id'])->update($data);//更新基础内容
            if($res){
				// $table_pk_id：表主键值；$table_name：表名；$type 1：新增，2：修改，3：删除；
				action_log($data['id'],'admin', 2);// 记录修改后行为
				if ($updata_password) {
					// 判断是否修改了密码修改就退出重新登录
					if ($info['id'] == UID) {
						(new AdminModel())->logout();
						return json(['code'=>1,'msg'=>'更新成功，请重新登录！','url'=>'']);
					} else {
						return json(['code'=>1,'msg'=>'更新成功！','url'=>cookie('__forward__')]);
					}
				}
				if ($id == UID) {
					session('admin_auth.username', $data['name']);
				}
				return json(['code'=>1,'msg'=>'更新成功！','url'=>cookie('__forward__')]);
			}
			return json(['code'=>0,'msg'=>'修改失败！','url'=>'']);
		} else {
			if (!$info) {
				return json(['code'=>0,'msg'=>'信息错误！','url'=>'']);
			}
			View::assign([
				'meta_title' => '编辑管理员【' . $info['name'] . '】信息', //标题 title
				'info' => $info, // 当前信息
				// 判断是否超级管理员
				'is_super_administrator' => is_super_administrator(UID),
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
		if (in_array(1, $ids)) {
			return json(['code'=>0,'msg'=>'超级管理员不能删除！','url'=>'']);
		}
		foreach ($ids as $k => $v) {
			// 记录删除行为
			// $table_pk_id：表主键值；$table_name：表名；$type 1：新增，2：修改，3：删除；
			action_log($v, 'admin', 3);
			$res = Db::name('admin')->delete($v);
			$res2 = Db::name('auth_group_access')->where('uid' , $v)->delete();
			if (!$res && !$res2) {
				return json(['code'=>0,'msg'=>'删除失败！','url'=>'']);
			}
		}
		return json(['code'=>1,'msg'=>'删除成功！','url'=>'']);
	}
	/**
	 * @NodeAnotation(title="状态")
	 * [setStatus 设置一条或者多条数据的状态 或 删除一条或多条数据的基本信息]
	 * @param string  $model [表名]
	 * @param array   $data  [数据]
	 * @param integer $type  [类型]
	 */
	public function setStatus($model = 'admin', $data = array(), $type = 2)
	{
		$ids = input('ids');
		if (is_array($ids) && in_array(1, $ids)) {
			return json(['code'=>0,'msg'=>'超级管理员状态不能设置！','url'=>'']);
		} elseif (!is_array($ids) && $ids == 1) {
			return json(['code'=>0,'msg'=>'超级管理员状态不能设置！','url'=>'']);
		}
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
	public function sort($model = 'admin', $data = array())
	{
		$data['sort'] = input('sort');
		return parent::sort($model, $data);
	}
	/**
	 * @NodeAnotation(title="所属角色")
	 */
	public function role()
	{
		if (request()->isAjax()) {
			$data = input('post.');
			if ($data['uid'] == 1 || UID !== 1) {
				// 只有超超级管理员才能分配角色,且超超级管理员所有人都不能操作其角色
				return json(['code'=>0,'msg'=>'非法操作！','url'=>'index']);
			}
			//先删除该管理员所有用户组明细表信息
			Db::name('auth_group_access')->where('uid' , $data['uid'])->delete();
			if (isset($data['ids'])) {
				foreach ($data['ids'] as $k => $v) {
					Db::name('auth_group_access')->insert(['uid' => $data['uid'],'group_id'=>$v]);
				}
			}
			return json(['code'=>1,'msg'=>'角色分配成功！','url'=>cookie('__forward__')]);
		}
		$uid = input('uid', 0);
		if (!$uid) {
			return json(['code'=>0,'msg'=>'参数有误！','url'=>'']);
		}
		if ($uid == 1 || UID !== 1) {
			//只有超超级管理员才能分配角色,且超超级管理员所有人都不能操作其角色
			return json(['code'=>0,'msg'=>'非法操作！','url'=>'index']);
		}
		$admin = Db::name('admin')->field('name')->find($uid);
		$allAuthGroupRes = Db::name('auth_group')->field('id,title')->select()->toArray(); //所有角色(用户组)
		// $currentAdmin = Db::name('admin')->find($uid); //当前管理员信息
		$map[] = ['uid', 'in', $uid];
		$currentAdminGroupAccess = Db::name('auth_group_access')->field('group_id')->where($map)->select()->toArray();
		$group_idArr = array_column($currentAdminGroupAccess, 'group_id');
		View::assign([
			'meta_title' => '管理员【' . $admin['name'] . '】所属角色', //标题 title
			'allAuthGroupRes' => $allAuthGroupRes, //所有角色(用户组)
			'group_idArr' => $group_idArr, //当前管理员所拥有的角色id(用户组id)数组
			'uid' => $uid, //管理员id
			'admin' => $admin, //当前管理员信息
		]);
		return view();
	}
    public function logout()
    {
        if (is_login()) {
            (new AdminModel())->logout();
            return json(['code'=>1,'msg'=>'退出成功！','url'=>(string)url('admin_login')]);
        } else {
            return redirect('/');
        }
    }
}
