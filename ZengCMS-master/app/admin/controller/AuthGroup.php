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
// | 角色(用户组)控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;
use tree\Tree;
use think\facade\Db;
use think\facade\View;
use app\admin\service\TriggerService;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="角色(用户组)管理")
 * Class AuthGroup
 * @package app\admin\controller
 */
class AuthGroup extends Base
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
        if ($status !== '' && ($status == 0 || $status == 1)) {
            $map[] = ['status', '=', $status];
            $query['status'] = $status;
        }
        if ($title) {
            $map[] = ['title', 'like', "%$title%"];
            $query['title'] = $title;
        }
        $order = ['sort' => 'desc', 'id' => 'desc']; //排序
        $list = Db::name('auth_group')->where($map)->order($order)
        ->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query])->each(function ($item, $key) {
            // 注意int_to_string()对一维数组起注意int_to_string2()二维数组起作用
            int_to_string($item, $map = array('status' => array('0' => '禁用', '1' => '正常')));
            return $item;
        });
        View::assign([
            'status' => $status, //状态
            'meta_title' => '角色管理', //标题
            'list' => $list, //列表
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
            $validate = validate('AuthGroup');
            if (!$validate->scene('add')->check($data)) {
                return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
            }
            $data['create_time'] = time(); //创建时间
			$id = Db::name('auth_group')->insertGetId($data); //新增基础内容
			if (!$id) {
                return json(['code'=>0,'msg'=>'新增出错！','url'=>'']);
			}
			// 记录新增后行为
			action_log($id, 'auth_group', 1);
            return json(['code'=>1,'msg'=>'新增成功！','url'=>'index']);
        } else {
            View::assign([
                'meta_title' => '新增角色', //标题title
                'info' => null, //空信息
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
        if ($id == 1) {
            return json(['code'=>0,'msg'=>'非法操作！','url'=>'']);
        }
        $info = Db::name('auth_group')->find($id); // 当前信息
        if (request()->isAjax()) { //提交表单
            $data = input('post.');
            $validate = validate('AuthGroup');
            if (!$validate->scene('edit')->check($data)) {
                return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
            }
            $data['id'] = intval($data['id']);
			if ($data['id'] == 0) {
                return json(['code'=>0,'msg'=>'非法操作！','url'=>'']);
			}
			$data['update_time'] = time(); //最后一次修改时间
			action_log($data['id'],'auth_group',2); //记录修改前行为
			$res = Db::name('auth_group')->where('id',$data['id'])->update($data); //更新基础内容
			if (!$res) {
                return json(['code'=>0,'msg'=>'更新出错！','url'=>'']);
			}
			action_log($data['id'],'auth_group',2); //记录修改后行为
            if ($info['sort'] == $data['sort']) { // 判断是否修改排序值如果修改就跳转到列表页，没有修改就跳转当前页
                return json(['code'=>1,'msg'=>'更新成功！','url'=>cookie('__forward__')]);
            } else {
                return json(['code'=>1,'msg'=>'更新成功！','url'=>'index']);
            }
        } else {
            if (!$info) {
                return json(['code'=>0,'msg'=>'信息错误！','url'=>'']);
            }
            View::assign([
                'meta_title' => '编辑【' . $info['title'] . '】角色', //标题 title
                'info' => $info, //当前信息
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
            action_log($v, 'auth_group', 3);
            $res = Db::name('auth_group')->delete($v);
            if (!$res) {
                return json(['code'=>0,'msg'=>'删除失败！','url'=>'']);
            } else {
                $map[] = ['group_id', '=', $v];
                Db::name('auth_group_access')->where($map)->delete();
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
    public function setStatus($model = 'auth_group', $data = array(), $type = 2)
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
    public function sort($model = 'auth_group', $data = array())
    {
        $data['sort'] = input('sort');
        return parent::sort($model, $data);
    }
    /**
     * @NodeAnotation(title="节点授权")
     */
    public function node()
    {
        if (request()->isAjax()) {
            $id = $this->request->post('group_id');
            $node = input('ids');
            // dump($node);die;
            $row = Db::name('auth_group')->find($id);
            empty($row) && $this->error('数据不存在');
            try {
                Db::name('SystemAuthNode')->where('auth_id', $id)->delete();
                if (!empty($node)) {
                    $saveAll = [];
                    foreach ($node as $vo) {
                        $saveAll[] = [
                            'auth_id' => $id,
                            'node_id' => $vo,
                        ];
                    }
                    Db::name('SystemAuthNode')->insertAll($saveAll);
                }
                TriggerService::updateMenu();
            } catch (\Exception $e) {
                $this->error('保存失败');
            }
            $this->success('保存成功');
        }
        $group_id = input('group_id');
        $list = $this->getAuthorizeNodeListByAdminId($group_id);
        // dump($list);die;
        return view('',[
            'meta_title'=>'节点授权',
            'group_id'=>$group_id,
            'list'=>$list,
        ]);
    }
    /**
     * 根据角色ID获取授权节点
     * @param $authId
     * @return array
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\DbException
     * @throws \think\db\exception\ModelNotFoundException
     */
    protected function getAuthorizeNodeListByAdminId($authId)
    {
        $checkNodeList = Db::name('system_auth_node')
        ->where('auth_id', $authId)
        ->column('node_id');
        $systemNode = Db::name('SystemNode');
        $nodelList = $systemNode
        ->where('is_auth', 1)
        ->field('id,node,title,type,is_auth')
        ->select()
        ->toArray();
        $newNodeList = [];
        foreach ($nodelList as $vo) {
            if ($vo['type'] == 1) {
                $vo = array_merge($vo, ['field' => 'node', 'spread' => true]);
                // $vo['checked'] = false;
                $vo['checked'] = in_array($vo['id'], $checkNodeList) ? true : false;
                $vo['title'] = "{$vo['title']}【{$vo['node']}】";
                $vo['pid'] = 0;
                $vo['level'] = 0;
                $children = [];
                foreach ($nodelList as $v) {
                    if ($v['type'] == 2 && strpos($v['node'], $vo['node'] . '/') !== false) {
                        $v = array_merge($v, ['field' => 'node', 'spread' => true]);
                        $v['checked'] = in_array($v['id'], $checkNodeList) ? true : false;
                        $v['title'] = "{$v['title']}【{$v['node']}】";
                        $v['pid'] = $vo['id'];
                        $v['level'] = 1;
                        $children[] = $v;
                    }
                }
                !empty($children) && $vo['children'] = $children;
                $newNodeList[] = $vo;
            }
        }
        return $newNodeList;
    }
    /**
     * @NodeAnotation(title="访问授权")
     */
    public function access()
    {
        if (request()->isAjax()) {
            $ids = input('ids', 0);
            $group_id = input('group_id');
            if (is_array($ids)) {
                $rules = implode(',', $ids);
            } else {
                $rules = '';
            }
            $res = Db::name('auth_group')->where('id' , $group_id)->update(['rules' => $rules]);
            if ($res === false) {
                return json(['code'=>0,'msg'=>'权限分配失败！','url'=>'']);
            } else {
                return json(['code'=>1,'msg'=>'权限分配成功！','url'=>cookie('__forward__')]);
            }
        }
        $group_id = input('group_id', 0);
        if (empty($group_id)) {
            return json(['code'=>0,'msg'=>'参数错误！','url'=>'']);
        }
        if ($group_id == 1) { //超级管理员用户组不能操作
            return json(['code'=>0,'msg'=>'非法操作！','url'=>'']);
        }
        $group_title = Db::name('auth_group')->where('id' , $group_id)->value('title'); //当前用户组(角色)名称
        $rules = Db::name('auth_group')->where('id' , $group_id)->value('rules');
        $rulesArr = explode(',', $rules);
        $order = ['sort' => 'desc', 'id' => 'desc']; //排序
        $menuRes = Db::name('auth_rule')->order($order)->select()->toArray();
        $tree = new Tree();
        $menuRes = $tree->ChildrenTree($menuRes, 0, 0);
        View::assign([
            'meta_title' => '角色【' . $group_title . '】访问授权', //标题 title
            'group_id' => $group_id, //当前角色(用户组)id
            'rulesArr' => $rulesArr, //当前角色(用户组)的rules(菜单或规则)信息array
            'menuRes' => $menuRes, //所有菜单(规则)信息
            'group_title' => $group_title, //当前角色(用户组)名称
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="成员授权")
     */
    public function user()
    {
        $group_id = input('group_id', 0);
        if (empty($group_id)) {
            return json(['code'=>0,'msg'=>'参数错误！','url'=>'']);
        }
        $group_title = Db::name('auth_group')->where('id' , $group_id)->value('title'); //当前用户组(角色)名称
        $uidRes = Db::name('auth_group_access')->field('uid')->where('group_id' , $group_id)->select()->toArray();
        $uidArr = array_column($uidRes, 'uid');
        $map[] = ['id', 'in', $uidArr];
        $query['group_id'] = $group_id;
        $currentGroupAdminRes = Db::name('admin')->where($map)
        ->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query])->each(function ($item, $key) {
            int_to_string($item, array('status' => array('0' => '禁用', '1' => '正常'))); //对一维数组起作用
            return $item;
        });; //拥有当前角色(用户组)所有管理员
        // int_to_string2($currentGroupAdminRes,$map=array('status'=>array('0'=>'禁用','1'=>'正常'))); //对二维数组起作用
        $allAdminRes = Db::name('admin')->select()->toArray(); //所有管理员信息
        $allAuthGroupRes = Db::name('auth_group')->select()->toArray(); //所有角色(用户组)信息
        View::assign([
            'meta_title' => '角色【' . $group_title . '】成员授权', //标题 title
            'currentGroupAdminRes' => $currentGroupAdminRes, //拥有当前角色(用户组)所有管理员
            'allAdminRes' => $allAdminRes, //所有管理员信息
            'allAuthGroupRes' => $allAuthGroupRes, //所有角色(用户组)信息
            'group_id' => $group_id, //当前角色(用户组)id
            'group_title' => $group_title, //当前角色(用户组)名称
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="解除成员授权(绑定)")
     */
    public function remove_user()
    {
        // 单个解绑
        if (request()->isGet()) {
            $uid = input('uid');
            $group_id = input('group_id');
            // 超级管理员用户组(角色)不能解绑超级管理员
            if ($uid == 1 && $group_id == 1) {
                return json(['code'=>0,'msg'=>'超级管理员不能解绑！','url'=>'']);
            }
            $res = Db::name('auth_group_access')->where([['uid','=', $uid],['group_id','=',$group_id]])->delete();
            if (!$res) {
                return json(['code'=>0,'msg'=>'解绑失败！','url'=>'']);
            } else {
                return json(['code'=>1,'msg'=>'解绑成功！','url'=>'']);
            }
        }
        // 多个解绑
        if (request()->isPost()) {
            $ids = input('ids');
            if (!$ids) {
                return json(['code'=>0,'msg'=>'参数有误！','url'=>'']);
            }
            $group_id = input('group_id');
            // 超级管理员用户组(角色)不能解绑超级管理员
            if (in_array(1, $ids) && $group_id == 1) {
                return json(['code'=>0,'msg'=>'超级管理员不能解绑！','url'=>'']);
            }
            $map[] = [
                ['uid', 'in', $ids],
                ['group_id', '=', $group_id],
            ];
            $res = Db::name('auth_group_access')->where($map)->delete();
            if (!$res) {
                return json(['code'=>0,'msg'=>'解绑失败！','url'=>'']);
            } else {
                return json(['code'=>1,'msg'=>'解绑成功！','url'=>'']);
            }
        }
    }
    /**
     * @NodeAnotation(title="新增成员")
     */
    public function add_to_group_access()
    {
        $data = input('post.');
        if (empty($data['uid'])) {
            return json(['code'=>0,'msg'=>'请选择管理员！','url'=>'']);
        }
        $count = Db::name('auth_group_access')->where([['uid' ,'=', $data['uid']],['group_id','=',$data['group_id']]])->count();
        if ($count) {
            return json(['code'=>0,'msg'=>'已经新增！','url'=>'']);
        }
        $res = Db::name('auth_group_access')->strict(false)->insert($data);
        if (!$res) {
            return json(['code'=>0,'msg'=>'新增成员失败！','url'=>'']);
        } else {
            return json(['code'=>1,'msg'=>'新增成员成功！','url'=>'']);
        }
    }
    /**
     * @NodeAnotation(title="ajax规则收缩")
     */
    public function shrink()
    {
        if (request()->isAjax()) {
            $id = input('id');
            $tree = new Tree();
            $sonids = $tree->ChildrenIdsArr(Db::name('auth_rule'), $id);
            echo json_encode($sonids);
        } else {
            return json(['code'=>0,'msg'=>'非法操作！','url'=>'']);
        }
    }
}
