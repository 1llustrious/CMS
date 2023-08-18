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
// | 栏目控制器
// +----------------------------------------------------------------------
namespace app\admin\controller\cms;

use tree\Tree;
use pinyin\Pinyin;
use think\facade\Db;
use think\facade\View;
use app\admin\controller\Base;
use app\admin\model\cms\ArctypePriv;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
use app\admin\validate\cms\Arctype as ArctypeValidate;
/**
 * @ControllerAnnotation(title="栏目管理")
 * Class Arctype
 * @package app\admin\controller\cms
 */
class Arctype extends Base
{
    /**
     * @NodeAnotation(title="列表")
     */
    public function index()
    {
        $map = array();
        $status = trim(input('status'));
        $title = trim(input('title'));
        $tree = new Tree();
        if ($status !== '' && ($status == 0 || $status == 1)) {
            $map[] = ['status', '=', $status];
        }
        if ($title) {
            $where[] = ['typename', 'like', "%$title%"];
            $data = Db::name('arctype')->field('id,pid')->select()->toArray();
            $ids = Db::name('arctype')->field('id,pid')->where($map)->where($where)->select()->toArray();
            $ids_arr = array_column($ids, 'id');
            if ($ids_arr) {
                $all_id_arr = array();
                foreach ($ids_arr as $k => $v) {
                    $parents = $tree->ParentTree($data, $v);
                    foreach ($parents as $k2 => $v2) {
                        $all_id_arr[] = $v2['id'];
                    }
                }
                $all_id_arr = array_unique($all_id_arr);
                $map[] = ['id', 'in', $all_id_arr];
            } else {
                $map[] = ['id', '=', -1];//不存在的
            }
        }
        $order = ['sort' => 'desc', 'id' => 'asc']; //排序
        $list = Db::name('arctype')->where($map)->order($order)->select()->toArray();
        int_to_string2($list,array('status' => array('0' => '隐藏', '1' => '显示')));
        $info = $tree->ChildrenTree($list, $id = 0, $level = 0);
        // 获取各栏目文档数量
        foreach ($info as $k => $v) {
            // 根据栏目ID或标识获取文档表名信息
            $model_table_info = get_document_table_info($v['id']);
            if (!$model_table_info['extend_table_name']) {
                $v['document_number'] = 0; //文档数设置为0
            } else {
                $v['document_number'] = Db::name($model_table_info['extend_table_name'])
                ->where('category_id', $v['id'])
                ->count();
            }
            $info[$k] = $v;
        }
        // 记录当前列表页的cookie
        cookie('__forward__', $_SERVER['REQUEST_URI']);
        return view('index',[
            'meta_title' => '栏目管理',//标题
            'status' => $status,//状态
            'title' => $title,//搜索关键词
            'list' => $info, //列表
        ]);
    }
    /**
     * @NodeAnotation(title="新增")
     */
    public function add()
    {
        if (request()->isAjax()) {
            $data = input('post.');
            // 数据验证
            $validate = new ArctypeValidate();
            if (!$validate->scene('add')->check($data)) {
                // 编辑器图片处理
                editor1($data['content']);
                editor1($data['content_en']);
                return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
            }
            $data['status'] = 0;
            $data['create_time'] = time();
            $data['update_time'] = time();
            $result = checkFieldAttr($data, 0, 'arctype');
            $data = isset($result['data'])?$result['data']:$data;
            if($result['code'] == 0){
                // 编辑器图片处理
                editor1(isset($data['content']) ? $data['content'] : '');
                editor1(isset($data['content_en']) ? $data['content_en'] : '');
                $this->error($result['msg']);
            }
            $id = Db::name('arctype')->strict(false)->insertGetId($data);
            if (!$id) {
                // 编辑器图片处理
                editor1($data['content']);
                editor1($data['content_en']);
                return json(['code'=>0,'msg'=>'新增失败！','url'=>'']);
            }
            if (isAddonInstall('member')) {
                // 更新会员组权限
                (new ArctypePriv())->update_priv($id, $data['priv_groupid'], 0);
            }
            if(isset($data['priv_auth_groupid']) && UID == 1){
                // 更新角色组权限
                (new ArctypePriv())->update_priv($id, $data['priv_auth_groupid'], 1);
            }
            action_log($id, 'arctype', 1);//记录新增行为
            return json(['code'=>1,'msg'=>'新增成功！','url'=>'index']);
        } else {
            $id = input('id/d', 0);//上级栏目id
            $model_id = input('model_id/d', 2);
            $order = ['sort' => 'desc', 'id' => 'asc'];//排序
            // 所有栏目信息
            $allArctypeRes = Db::name('arctype')->order($order)->field('id,pid,typename,name')->select()->toArray();
            $allArctypeRes = (new Tree())->ChildrenTree($allArctypeRes, 0, 0);//所有栏目信息-分级
            // 获取所有字段
            $_fields = Db::name('attribute')->field(true)
            ->where('model_id',0)->where('table_name', 'arctype')
            ->order(['sort'=>'desc','id'=>'asc'])
            ->select()->toArray();
            $fields = array();
            foreach ($_fields as $v) {
                $fields[$v['group_id']][] = $v;
            }
            ksort($fields);
            if (isAddonInstall('member')) {
                // 会员组
                View::assign("Member_Group", $this->get_member_group());
            }
            if(UID == 1){
                // 角色组
                View::assign("auth_group", Db::name('auth_group')->select()->toArray());
            }
            View::assign([
                'meta_title' => '新增栏目分类',//标题title
                'id' => $id,//上级栏目id
                'info' => null,//栏目信息
                'model_id' => $model_id,//模型id
                'allArctypeRes' => $allArctypeRes,//所有栏目信息
                'fields'=>$fields,//字段信息
                'UID'=>UID,
            ]);
            return view();
        }
    }
    /**
     * @NodeAnotation(title="编辑")
     */
    public function edit($id = null)
    {
        if (empty($id)) {
            $this->error('参数错误！');
        }
        $id = intval($id);
        $tree = new Tree();
        $info = Db::name('arctype')->field(true)->find($id);//当前信息
        if (request()->isAjax()) {
            $data = input('post.');
            if($data['model_id'] != $info['model_id']){ //更改绑定模型
                // 根据模型ID获取模型信息
                $model = get_document_model($info['model_id']);
                if ($model) {
                    // 获取文档表名
                    if ($model['extend']) { //非独立模型
                        $extend_name = get_document_model($model['extend'], 'name');
                        $model_table = $extend_name.'_'.$model['name'];//表名
                    } else { //独立模型
                        $model_table = $model['name'];//表名
                    }
                    $res = Db::name($model_table)->where('category_id', $info['id'])->select()->toArray();
                    if ($res) {
                        return json(['code'=>0,'msg'=>'该栏目下有文档不能更改绑定模型！','url'=>'']);
                    }
                }
            }
            $data['update_time'] = time();
            // 数据验证
            $validate = new ArctypeValidate();
            if (!$validate->scene('edit')->check($data)) {
                // 编辑器图片处理
                editor2($info['content'], $data['content']);
                editor2($info['content_en'], $data['content_en']);
                return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
            }
            // 找该栏目的所有子栏目
            $ChildrenIdsArr = $tree->ChildrenIdsArr(Db::name('arctype'), $id);
            $ChildrenIdsArr[] = $id;
            if (in_array($data['pid'], $ChildrenIdsArr)) {
                // 编辑器图片处理
                editor2($info['content'], $data['content']);
                editor2($info['content_en'], $data['content_en']);
                return json(['code'=>0,'msg'=>'上级分类不能为其子分类或自身！','url'=>'']);
            }
            $result = checkFieldAttr($data, 0, 'arctype');
            $data = isset($result['data'])?$result['data']:$data;
            if ($result['code'] == 0) {
                // 编辑器图片处理
                if (isset($data['content']) && isset($info['content'])) {
                    editor2($info['content'], $data['content']);
                }
                if (isset($data['content_en']) && isset($info['content_en'])) {
                    editor2($info['content_en'], $data['content_en']);
                }
                return ['code'=>0,'msg'=>$result['msg']];
            }
            // 编辑器图片处理
            editor2($data['content'], $info['content']);
            editor2($data['content_en'], $info['content_en']);
            action_log($data['id'], 'arctype', 2);//记录修改前行为
            $res = Db::name('arctype')->strict(false)->update($data);
            if ($res !== false) {
                action_log($data['id'], 'arctype', 2);//记录修改后行为
                if (isAddonInstall('member')) {
                    // 更新会员组权限
                    (new ArctypePriv())->update_priv($id, $data['priv_groupid'], 0);
                }
                $data['priv_auth_groupid'] = $data['priv_auth_groupid']??'';
                if(UID == 1){
                    // 更新角色组权限
                    (new ArctypePriv())->update_priv($id, $data['priv_auth_groupid'], 1);
                }
                if (isset($data['upnext'])) { //判断是否继承选项，所有子栏目改模板
                    $data2['ispart'] = $data['ispart'];
                    $data2['index_template'] = $data['index_template'];
                    $data2['list_template'] = $data['list_template'];
                    $data2['article_template'] = $data['article_template'];
                    $data2['article_rule'] = $data['article_rule'];
                    $data2['list_rule'] = $data['list_rule'];
                    $data2['update_time'] = time();
                    // Db::name('arctype')->where([['id','in',$ChildrenIdsArr]])->update($data2);
                    foreach ($ChildrenIdsArr as $k => $v) {
                        action_log($v, 'arctype', 2);//记录修改前行为
                        Db::name('arctype')->where('id', $v)->update($data2);
                        action_log($v, 'arctype', 2);//记录修改后行为
                    }
                }
                if ($info['sort'] == $data['sort']) { //判断是否修改排序值如果修改就跳转到列表页，没有修改就跳转当前页
                    return json(['code'=>1,'msg'=>'更新成功！','url'=>cookie('__forward__')]);
                } else {
                    return json(['code'=>1,'msg'=>'更新成功！','url'=>'index']);
                }
            }
            // 编辑器图片处理
            editor2($info['content'], $data['content']);
            editor2($info['content_en'], $data['content_en']);
            return json(['code'=>0,'msg'=>'修改失败！','url'=>'']);
        } else {
            if (!$info) {
                $this->error('信息错误！');
            }
            $order = ['sort' => 'desc', 'id' => 'asc'];//排序
            // 所有栏目信息
            $allArctypeRes = Db::name('arctype')->field('id,pid,typename,name')->order($order)->select()->toArray();
            $allArctypeRes = $tree->ChildrenTree($allArctypeRes, 0, 0);
            // 获取所有字段
            $_fields = Db::name('attribute')
            ->field(true)
            ->where('model_id',0)
            ->where('table_name', 'arctype')
            ->order(['sort'=>'desc','id'=>'asc'])
            ->select()->toArray();
            $fields = array();
            foreach ($_fields as $v) {
                $fields[$v['group_id']][] = $v;
            }
            ksort($fields);
            if (isAddonInstall('member')) {
                // 会员组
                View::assign("Member_Group", $this->get_member_group());
                // 权限数据
                View::assign("privs", (new ArctypePriv())->where('catid' , $info['id'])->select()->toArray());
            }
            if(UID == 1){
                // 角色组
                View::assign("auth_group", Db::name('auth_group')->select()->toArray());
                // 权限数据
                View::assign("privs", (new ArctypePriv())->where('catid' , $info['id'])->select()->toArray());
            }
            View::assign([
                'meta_title' => '编辑栏目',//标题title
                'info' => $info,
                'data' => $info,
                'allArctypeRes' => $allArctypeRes,
                'fields'=>$fields,
                'UID'=>UID,
            ]);
            return view();
        }
    }
    /**
     * @NodeAnotation(title="编辑内容")
     */
    public function edit_content($id = null)
    {
        if (empty($id)) {
            $this->error('参数错误！');
        }
        $id = intval($id);
        $tree = new Tree();
        $info = Db::name('arctype')->field(true)->find($id);//当前信息
        if (request()->isAjax()) {
            $data = input('post.');
            $data['update_time'] = time();
            // 编辑器图片处理
            editor2($data['content'], $info['content']);
            editor2($data['content_en'], $info['content_en']);
            action_log($data['id'], 'arctype', 2);//记录修改前行为
            $res = Db::name('arctype')->strict(false)->update($data);
            if ($res !== false) {
                action_log($data['id'], 'arctype', 2);//记录修改后行为
                $this->success('修改成功！');
            }
            // 编辑器图片处理
            editor2($info['content'], $data['content']);
            editor2($info['content_en'], $data['content_en']);
            return json(['code'=>0,'msg'=>'修改失败！','url'=>'']);
        } else {
            if (!$info) {
                $this->error('信息错误！');
            }
            $order = ['sort' => 'desc', 'id' => 'asc'];//排序
            // 所有栏目信息
            $allArctypeRes = Db::name('arctype')->field('id,pid,typename,name')->order($order)->select()->toArray();
            $allArctypeRes = $tree->ChildrenTree($allArctypeRes, 0, 0);
            View::assign([
                'meta_title' => '编辑栏目',//标题title
                'info' => $info,
                'allArctypeRes' => $allArctypeRes,
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
        $ids = !empty($ids) ? $ids : input('ids', 0);
        if (empty($ids)) {
            return json(['code'=>0,'msg'=>'参数不能为空！','url'=>'']);
        }
        if (!is_array($ids)) {
            $ids = array($ids);
        }
        // 判断该菜单有没有子菜单，有就不能删除
        $map[] = ['pid', 'in', $ids];
        $menuRes = Db::name('arctype')->field('id')->where($map)->select()->toArray();
        if (!empty($menuRes)) {
            return json(['code'=>0,'msg'=>'请先删除栏目下的所有子栏目！','url'=>'']);
        } else {
            foreach ($ids as $k => $v) {
                $info = Db::name('arctype')->field('id,content,content_en')->find($v);
                // 根据栏目ID获取模型ID
                $model_id = get_modelId_by_categoryId($v);
                // 根据模型ID获取模型信息
                $model = get_document_model($model_id);
                if ($model) {
                    // 获取文档表名
                    if ($model['extend']) { //非独立模型
                        $extend_name = get_document_model($model['extend'], 'name');
                        $model_table = $extend_name; //表名
                    } else { //独立模型
                        $model_table = $model['name']; //表名
                    }
                    $res = Db::name($model_table)->where('category_id', $info['id'])->select()->toArray();
                    if ($res) {
                        return json(['code'=>0,'msg'=>'请先删除栏目下的所有文档信息！','url'=>'']);
                    }
                }
                // 删除编辑器的图片
                editor1($info['content']);
                editor1($info['content_en']);
                // 记录删除行为
                action_log($v, 'arctype', 3);
                (new ArctypePriv())->where('catid',$v)->delete();
                Db::name('arctype')->delete($v);
            }
            return json(['code'=>1,'msg'=>'删除成功！','url'=>'']);
        }
    }
    /**
     * @NodeAnotation(title="状态")
     * [setStatus 设置一条或者多条数据的状态 或 删除一条或多条数据的基本信息]
     * @param string $model
     * @param array $data
     * @param integer $type
     * @return void
     */
    public function setStatus($model = 'arctype', $data = array(), $type = 1)
    {
        $ids = input('ids');
        $status = input('status');
        $data['ids'] = $ids;
        $data['status'] = $status;
        return parent::setStatus($model, $data, $type);
    }
    /**
     * @NodeAnotation(title="排序")
     * @param string $model
     * @param array $data
     * @return void
     */
    public function sort($model = 'arctype', $data = array())
    {
        $data['sort'] = input('sort');
        return parent::sort($model, $data);
    }
    /**
     * @NodeAnotation(title="中文转拼音")
     */
    public function get_pinyin()
    {
        if (request()->isAjax()) {
            $typename = input('typename');
            $pidname = input('pidname');
            $pid = input('pid');
            $py = new Pinyin();
            $pinyin = $py->getpy($typename, true);
            if($pid){
                $prefix = Db::name('arctype')->where('id',$pid)->value('name');
                $pinyin = $prefix.'-'.$pinyin;
            }
            config('logs.admin/Common/get_pinyin', '根据中文获取拼音');
            return json($pinyin);
        } else {
            config('logs.admin/Common/get_pinyin', '根据中文获取拼音-' . '非法操作！');
            return json(['code'=>0,'msg'=>'非法操作！','url'=>'']);
        }
    }
    /**
     * @NodeAnotation(title="展示 / 折叠")
     */
    public function arctype_show()
    {
        if (request()->isAjax()) {
            if (input('arctype_show') == 1) {
                cookie('arctype_show', 1);//折叠
            } else {
                cookie('arctype_show', null);//展示
            }
            return json(['code'=>1,'msg'=>'操作成功','url'=>'']);
        } else {
            return json(['code'=>0,'msg'=>'非法操作！','url'=>'']);
        }
    }
    // 获取会员组
    protected function get_member_group()
    {
        $data = Db::name('member_group')->select();
        if ($data) {
            $data = $data->toArray();
        } else {
            return;
        }
        $return = array();
        foreach ($data as $k => $v) {
            if ($v['expand']) {
                $v['expand'] = unserialize($v['expand']);
            } else {
                $v['expand'] = array();
            }
            $return[$v['id']] = $v;
        }
        return $return;
    }
}
