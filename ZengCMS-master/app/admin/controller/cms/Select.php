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
// | 联动类别控制器
// +----------------------------------------------------------------------
namespace app\admin\controller\cms;

use tree\Tree;
use think\facade\Db;
use think\facade\View;
use TreeModel\TreeModel;
use app\admin\controller\Base;
use app\admin\validate\cms\Stepselect;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="联动类别管理")
 * Class Select
 * @package app\admin\controller\cms
 */
class Select extends Base
{
    /**
     * @NodeAnotation(title="列表")
     */
    public function index()
    {
        $map = array();
        $query = array();
        $model_id = trim(input('model_id'));
        $title = trim(input('title'));
        $map[] = ['type', 'like', "%stepselect%"];
        if ($model_id !== '' && is_numeric($model_id)) {
            $map[] = ['a.model_id', '=', $model_id];
            $query['model_id'] = $model_id;
        }
        if ($title) {
            $map[] = ['a.title|a.name', 'like', "%$title%"];
            $query['title'] = $title;
        }
        $order = ['m.sort' => 'desc', 'a.id' => 'desc']; //排序
        $list = Db::name('attribute')->alias('a')
        ->join('model m', 'm.id = a.model_id')
        ->field('a.*,m.title as model')
        ->where($map)
        ->order($order)
        ->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query]);
        $model = Db::name('model')->select()->toArray();
        // 记录当前列表页的cookie
        cookie('__forward__', $_SERVER['REQUEST_URI']);
        View::assign([
            'meta_title' => '联动类别',
            'list' => $list,//联动字段信息列表
            'model_id' => $model_id,//模型ID
            'model' => $model,//所有模型信息
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="新增")
     */
    public function add()
    {
        if (request()->isPost()) {
            $data = input('post.');
            //数据验证
            $validate = new Stepselect();
            if (!$validate->scene('add')->check($data)) {
                $this->error($validate->getError());
            }
            $id = Db::name('stepselect')->insertGetId($data);
            if ($id) {
                action_log($table_pk_id = $id, $table_name = 'stepselect', $type = 1);//记录新增后行为
                $this->success('添加子分类成功！', cookie('__forward__'));
            } else {
                $this->error('添加子分类失败');
            }
        } else {
            $tid = input('tid');//字段表的字段ID
            $pid = input('pid');//联动上级ID
            $attrInfo = Db::name('attribute')->where('id', $tid)->find();//获取字段信息
            $fields = $attrInfo['name'];//字段名称

            $native = Db::name('stepselect')->field(true)->where('tid', $tid)->select()->toArray();//获取某字段的所有联动信息
            $tree = new TreeModel();
            $native = $tree->toFormatTree($native);//将格式数组转换为树
            $native = array_merge(array(0 => array('id' => 0, 'title_show' => '顶级类别')), $native);
            View::assign([
                'meta_title' => '添加子分类',
                'info' => array('tid' => $tid, 'pid' => $pid, 'fields' => $fields),
                'native' => $native,
            ]);
            return view('edit');
        }
    }
    /**
     * @NodeAnotation(title="编辑")
     */
    public function edit()
    {
        if (request()->isPost()) {
            $data = input('post.');
            //数据验证
            $validate = new Stepselect();
            if (!$validate->scene('edit')->check($data)) {
                $this->error($validate->getError());
            }
            $tree = new Tree();
            //找该联动的所有子联动
            $ChildrenIdsArr = $tree->ChildrenIdsArr(Db::name('stepselect'), $data['id']);
            $ChildrenIdsArr[] = $data['id'];
            if (in_array($data['pid'], $ChildrenIdsArr)) {
                $this->error('上级菜单不能为其子菜单或自身！');
            }
            action_log($data['id'], 'stepselect', 2);//记录修改前行为
            $res = Db::name('stepselect')->update($data);
            if ($res) {
                action_log($data['id'], 'stepselect', 2);//记录修改后行为
                $this->success('编辑子分类成功！', cookie('__forward__'));
            } else {
                $this->error('编辑子分类失败');
            }
        } else {
            $id = input('id');//联动ID
            $tid = input('tid');//字段表的字段ID
            $info = array();
            /*获取菜单数据*/
            $info = Db::name('stepselect')->field(true)->find($id);//获取当前联动信息
            $native = Db::name('stepselect')->field(true)->where('tid', $tid)->select()->toArray();//获取该字段所有联动信息
            $tree = new TreeModel();
            $native = $tree->toFormatTree($native);
            $native = array_merge(array(0 => array('id' => 0, 'title_show' => '顶级类别')), $native);
            View::assign('native', $native);
            View::assign('info', $info);
            View::assign('meta_title', '编辑子分类');
            return view();
        }
    }
    /**
     * @NodeAnotation(title="删除")
     */
    public function del()
    {
        $slid = input('id');
        if (empty($slid)) {
            $this->error('参数错误!');
        }
        //判断该分类下有没有子分类，有则不允许删除
        $child = Db::name('stepselect')->where('pid', $slid)->field('id')->select()->toArray();
        if (!empty($child)) {
            $this->error('请先删除该分类下的子分类');
        }

        //删除该分类信息
        action_log($slid, 'stepselect', 3);//记录删除行为
        $res = Db::name('stepselect')->delete($slid);
        if ($res !== false) {
            //记录行为
            // action_log('del_stepselect', 'Stepselect', $slid, UID);
            $this->success('删除分类成功！');
        } else {
            $this->error('删除分类失败！');
        }
    }
    /**
     * @NodeAnotation(title="查看子分类")
     */
    public function list_select()
    {
        $tid = input('tid', 0);//字段id
        $pid = input('pid', 0);//上级ID
        if (empty($tid)) {
            $this->error('参数错误！');
            exit();
        }
        /*初始化查询条件**/
        $map[] = ['tid', '=', $tid];//字段表的字段id
        $map[] = ['pid', '=', $pid];//上级id

        $title = trim(input('title'));
        if ($title) {
            $map[] = ['title', 'like', "%$title%"];
        }
        $page_list = Db::name('stepselect')->where($map)->order('sort Desc')
        ->paginate(get_one_config('WEB_ONE_PAGE_NUMBER'), false, ['query' => request()->param()]);
        $list = $page_list->all();
        // int_to_string2($list);
        $list2 = array();
        foreach ($list as $vl) {
            $list2[$vl['id']] = $vl;
            if ($vl['pid'] == 0) {
                $list2[$vl['id']]['level'] = '1';
            } else {
                $list2[$vl['id']]['level'] = $this->get_level($vl['pid']);
            }
            $list2[$vl['id']]['up_title'] = $this->get_up_title($vl['pid']);
        }
        // dump($list2);die;
        // 记录当前列表页的cookie
        cookie('__forward__', $_SERVER['REQUEST_URI']);
        View::assign([
            'meta_title' => '查看子分类',
            // 'list'=>$list2,
            'list' => $list2,//数据列表
            'page' => $page_list,//分页
            'tid' => $tid,//字段ID
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="根据pid获取下一级联动信息")
     */
    public function getStep()
    {
        $pid = input('pid');
        $data = null;
        if ($pid) {
            $map[] = ['pid', '=', $pid];
            $data = Db::name('stepselect')->where($map)->select()->toArray();
        }
        return json($data);
    }
    /**
     * 获得当前等级
     */
    protected function get_level($id, $level = 2)
    {
        $sel = Db::name('stepselect')->field(true)->find($id);
        if ($sel['pid'] != 0) {
            $this->get_level($sel['pid'], $level + 1);
        }
        return $level;
    }
    /**
     * 获得上级菜单
     */
    protected function get_up_title($pid)
    {
        if ($pid == 0) {
            return '';
        }
        $sel = Db::name('stepselect')->field(true)->find($pid);
        return $sel['title'];
    }
}
