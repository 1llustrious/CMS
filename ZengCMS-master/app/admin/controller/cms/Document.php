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
// | 文档控制器
// +----------------------------------------------------------------------
namespace app\admin\controller\cms;
use tree\Tree;
use think\facade\Db;
use think\facade\View;
use app\admin\controller\Base;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
use app\admin\model\cms\Document as DocumentModel;
/**
 * @ControllerAnnotation(title="文档管理")
 * Class Document
 * @package app\admin\controller\cms
 */
class Document extends Base
{
    /**
     * @NodeAnotation(title="新增")
     */
    public function add()
    {
        if (request()->isPost()) {
            $data = input('post.');
            // 检查权限
            if(!$this->CheckPermissions($data['category_id'],'add')){
                $this->error('您没有权限！');
            }
            try {   
                $result = (new DocumentModel())->add($data);
            } catch (\Exception $e) {   
               $this->error($e->getMessage(),null,[],3);
            }
            if ($result['code'] == 1) {
                $this->success('新增成功！', cookie('__forward__'));
            }
            $this->error($result['msg']);
        }
        $category_id = input('category_id', 0);//栏目id
        $model_id = input('model_id', 0);//模型id
        empty($model_id) && $this->error('该分类未绑定模型！');
        // 是否表单
        $form = input('form',0);
        if(!$form){
            // 检查该分类是否允许发布
            $allow_publish = check_category($category_id);
            !$allow_publish && $this->error('该分类不允许发布内容！');
        }
        // 获取当前的模型或表单信息
        $model = get_document_model($model_id,null,$form);
        if (!$model) {
            $this->error($form?'表单不存在！':'该分类的所属模型不存在！');
        }
        if ($model['extend']) { //非独立模型时
            $extend = Db::name('model')->field('name')->find($model['extend']);
            if (!$extend) {
                $this->error('该分类所属模型所继承的模型不存在!');
            }
        }
        // 处理结果
        $info['model_id'] = $model_id;
        $info['category_id'] = $category_id;
        // 获取表单字段排序
        $fields = get_model_attribute($model['id']);
        View::assign([
            'meta_title' => '新增【' . $model['title'] . '】文档',//模型名称
            'info' => $info,//模型ID和栏目ID信息
            'form' => $form,//是否表单
            'model' => $model,//模型或表单信息
            'fields' => $fields,//字段信息
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="编辑")
     */
    public function edit()
    {
        if (request()->isPost()) {
            $data = input('post.');
            // 检查权限
            if(!$this->CheckPermissions($data['category_id'],'edit')){
                $this->error('您没有权限！');
            }
            try {
                $result = (new DocumentModel())->edit($data);
            } catch (\Exception $e) {   
               $this->error($e->getMessage(),null,[],3);
            }
            if($result['code'] == 0){
                $this->error($result['msg']);
            }
            $this->success('编辑成功！',cookie('__forward__'));
        }
        $id = input('id', '');
        if (empty($id)) {
            $this->error('参数不能为空！');
        }
        // 是否表单
        $form = input('form',0);
        $model_id = input('model_id', 0);
        empty($model_id) && $this->error($form?'表单不存在！':'该分类未绑定模型！');
        // 获取当前的模型或表单信息
        $model = get_document_model($model_id,null,$form);
        if (!$model) {
            $this->error($form?'表单不存在！':'该文档所属分类的所属模型不存在!');
        }
        if ($model['extend']) { //非独立模型
            $extend = Db::name('model')->field('name')->find($model['extend']);
            if (!$extend) {
                $this->error('该文档所属分类的所属模型的继承模型不存在!!');
            }
            $document = Db::name($extend['name'])->where('id', $id)->find();
            $extenDocument = Db::name($extend['name'] . '_' . $model['name'])->where('id', $id)->find();
            $data = array_merge($document, $extenDocument);
        } else { //独立模型
            $document = Db::name($model['name'])->where('id', $id)->find();
            $data = $document;
        }
        // 获取表单字段排序
        $fields = get_model_attribute($model['id']);
        View::assign([
            'meta_title' => '编辑【' . $model['title'] . '】文档',
            'model_id' => $model['id'],
            'form' => $form,
            'model' => $model,
            'data' => $data,
            'fields' => $fields,
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="复制")
     */
    public function copy()
    {
        if (request()->isPost()) {
            $data = input('post.');
            // 检查权限
            if(!$this->CheckPermissions($data['category_id'],'copy')){
                $this->error('您没有权限！');
            }
            $res = (new DocumentModel())->add($data);
            if ($res['code'] == 1) {
                $this->success('复制成功！', cookie('__forward__'));
            } else {
                $this->error(empty($res['msg']) ? '未知错误！' : $res['msg']);
            }
        }
        $id = input('id', '');
        if (empty($id)) {
            $this->error('参数不能为空！');
        }
        // 是否表单
        $form = input('form',0);
        $model_id = input('model_id', 0);
        empty($model_id) && $this->error('该分类未绑定模型！');
        // 获取当前的模型信息
        $model = get_document_model($model_id);
        if (!$model) {
            $this->error('该文档所属分类的所属模型不存在!');
        }
        if ($model['extend']) { //非独立模型
            $extend = Db::name('model')->field('name')->find($model['extend']);
            if (!$extend) {
                $this->error('该文档所属分类的所属模型的继承模型不存在!!');
            }
            $document = Db::name($extend['name'])->where('id', $id)->find();
            $extenDocument = Db::name($extend['name'] . '_' . $model['name'])->where('id', $id)->find();
            $data = array_merge($document, $extenDocument);
        } else { //独立模型
            $document = Db::name($model['name'])->where('id', $id)->find();
            $data = $document;
        }
        // 获取表单字段排序
        $fields = get_model_attribute($model['id']);
        View::assign([
            'meta_title' => '编辑【' . $model['title'] . '】文档',
            'model_id' => $model['id'],
            'form' => $form,
            'model' => $model,
            'data' => $data,
            'fields' => $fields,
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="移动")
     */
    public function move()
    {
        $tree = new Tree();
        if (request()->isAjax()) {
            $data = input('post.');
            if(!$data['category_id']){
                $this->error('请选择目标栏目！');
            }
            $ids = $data['ids'];
            // 检查权限
            $idsArr = explode('|',$ids);
            foreach($idsArr as $k=>$v){
                list($id,$cid) = explode('-',$v);
                if(!$this->CheckPermissions($cid,'move')){
                    $this->error('您没有"'.get_nav($cid,'typename').'"栏目的文档移动权限！');
                }
            }
            $model_id = $data['model_id'];
            // 获取当前的模型信息
            $model = get_document_model($model_id);
            if ($model['extend']) { //非独立模型
                $table_name = get_document_model($model['extend'], 'name');
            } else { //独立模型
                $table_name = $model['name'];
            }
            foreach($idsArr as $k=>$v){
                list($id,$cid) = explode('-',$v);
                Db::name($table_name)->where('id', $id)->update(['category_id' => $data['category_id']]);
            }
            $this->success('移动成功！');
        }
        $ids = input('ids');
        $model_id = input('model_id');
        $list = Db::name('arctype')->order(['sort' => 'desc', 'id' => 'asc'])->select()->toArray();
        int_to_string2($list, array('status' => array('0' => '隐藏', '1' => '显示')));
        $arctypeRes = $tree->ChildrenTree($list, 0, 0);
        View::assign([
            'meta_title' => '移动文档',
            'ids' => $ids,
            'model_id'=>$model_id,
            'arctypeRes' => $arctypeRes,//所有栏目信息
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="删除")
     */
    public function del($ids = NULL)
    {
        $ids = !empty($ids) ? $ids : input('ids', 0);
        $form = input('form',0);
        if (empty($ids)) {
            $this->error('参数不能为空！');
        }
        $arr = array();
        if (!is_array($ids)) {
            $arr[$ids] = $ids;
            $ids = $arr;
        }
        foreach ($ids as $k => $v) {
            list($id, $model_id) = explode('-', $k);
            $model = get_document_model($model_id,null,$form);
            if ($model['extend']) { //非独立模型
                $extend_name = get_document_model($model['extend'], 'name',$form);
                $category_id = Db::name($extend_name)->where('id', $id)->value('category_id');//获取栏目id
                // 检查权限
                if(!$this->CheckPermissions($category_id,'delete')){
                    $this->error('您没有权限！');
                }
                $info = Db::name($extend_name)->find($id);
                // 删除编辑器图片
                if (isset($info['content'])) {
                    editor1($info['content']);
                }
                if (isset($info['content_en'])) {
                    editor1($info['content_en']);
                }
                action_log($id,$extend_name,3);
                Db::name($extend_name)->where('id', $id)->delete();//先删除基础信息
                action_log($id,$extend_name . '_' . $model['name'],3);
                Db::name($extend_name . '_' . $model['name'])->where('id', $id)->delete();//后删除扩展信息
                (new DocumentModel())->tag_handle('', $model_id, $category_id ,$id);
            } else { //独立模型(表单)
                if(!$form){
                    // 获取栏目id
                    $category_id = Db::name($model['name'])->where('id', $id)->value('category_id');
                }
                // 检查权限
                if(!$this->CheckPermissions($category_id,'delete')){
                    $this->error('您没有权限！');
                }
                $info = Db::name($model['name'])->where('id', $id)->find($id);
                // 删除编辑器图片
                if (isset($info['content'])) {
                    editor1($info['content']);
                }
                if (isset($info['content_en'])) {
                    editor1($info['content_en']);
                }
                action_log($id,$model['name'],3);
                Db::name($model['name'])->where('id', $id)->delete();//删除数据
                if(!$form){
                    (new DocumentModel())->tag_handle('', $model_id, $category_id ,$id);
                }
            }
        }
        $this->success('删除成功!');
    }
    /**
     * @NodeAnotation(title="状态")
     */
    public function set_status($ids = NULL)
    {
        $status = input('status');
        $form = input('form',0);
        $ids = !empty($ids) ? $ids : input('ids', 0);
        if (empty($ids)) {
            $this->error('参数不能为空！');
        }
        $arr = array();
        if (!is_array($ids)) {
            $arr[$ids] = $ids;
            $ids = $arr;
        }
        foreach ($ids as $k => $v) {
            list($id, $model_id) = explode('-', $k);
            if (!$model_id) {
                $status = 4;
                break;
            }
            $model = get_document_model($model_id,null,$form);
            if ($model['extend']) { //非独立模型
                $extend_name = get_document_model($model['extend'], 'name',$form);
                $category_id = Db::name($extend_name)->where('id',$id)->value('category_id');
                if(!$this->CheckPermissions($category_id,'status')){
                    $this->error('您没有权限！');
                }
                action_log($id, $extend_name, 2);//记录修改前
                Db::name($extend_name)->where('id', $id)->update(['status' => $status]);
                action_log($id, $extend_name, 2);//记录修改后
            } else { //独立模型
                $category_id = Db::name($model['name'])->where('id',$id)->value('category_id');
                if(!$this->CheckPermissions($category_id,'status')){
                    $this->error('您没有权限！');
                }
                action_log($id, $model['name'], 2);//记录修改前
                Db::name($model['name'])->where('id', $id)->update(['status' => $status]);
                action_log($id, $model['name'], 2);//记录修改后
            }
        }
        if ($status == 1) {
            $msg = '显示成功!';
        } elseif ($status == 0) {
            $msg = '隐藏成功!';
        } elseif ($status == 2) {
            $msg = '设置为待审核成功!';
        } elseif ($status == 3) {
            $msg = '设置为草稿成功!';
        } elseif ($status == '-1') {
            $msg = '设置为删除成功!';
        } elseif ($status == 4) {
            $msg = '文档本身有误！请查看其所属分类及模型！';
            return $this->error($msg);
        }
        return $this->success($msg);
    }
    /**
     * @NodeAnotation(title="排序")
     */
    public function set_sort()
    {
        $data = input('sort');
        $form = input('form',0);
        foreach ($data as $k => $v) {
            list($id, $model_id) = explode('-', $k);
            $model = get_document_model($model_id,null,$form);
            if ($model['extend']) { //非独立模型
                $extend_name = get_document_model($model['extend'], 'name',$form);
                $category_id = Db::name($extend_name)->where('id',$id)->value('category_id');
                if(!$this->CheckPermissions($category_id,'sort')){
                    $this->error('您没有权限！');
                }
                action_log($id, $extend_name, 2);//记录修改前
                Db::name($extend_name)->where('id', $id)->update(['sort' => $v]);
                action_log($id, $extend_name, 2);//记录修改后
            } else { //独立模型
                $category_id = Db::name($model['name'])->where('id',$id)->value('category_id');
                if(!$this->CheckPermissions($category_id,'sort')){
                    $this->error('您没有权限！');
                }
                action_log($id, $model['name'], 2);//记录修改前
                Db::name($model['name'])->where('id', $id)->update(['sort' => $v]);
                action_log($id, $model['name'], 2);//记录修改后
            }
        }
        return $this->success('排序成功!');
    }
    /**
     * @NodeAnotation(title="管理内容")
     */
    public function content()
    {
        View::assign([
            'meta_title'=>'管理内容',
        ]);
        return view();
    } 
    /**
     * @NodeAnotation(title="左侧栏目")
     */
    public function arctype()
    {
        $json = [];
        $categorys = Db::name('arctype')
        ->order(['sort'=>'desc','id'=>'asc'])
        ->select()
        ->toArray();
        foreach ($categorys as $rs) {
            $rs['child'] = 0;
            /* $res = Db::name('arctype')
            ->where('pid',$rs['id'])
            ->select()
            ->toArray();
            if($res){
                $rs['child'] = 1;
            }else{
                $rs['child'] = 0;
            } */
            // 剔除无子栏目外部链接
            if ($rs['ispart'] == 3 && $rs['child'] == 0) {
                continue;
            }
            $data = array(
                'id' => $rs['id'],
                'parentid' => $rs['pid'],
                'catname' => $rs['typename'],
                'type' => $rs['ispart'],
            );
            // 终极栏目
            if ($rs['child'] == 0) {
                $data['target'] = 'right';
                $data['url'] = (string)url('cms.Document/document', array('category_id' => $rs['id']));
            } else {
                $data['isParent'] = true;
            }
            // 单页
            if ($rs['ispart'] == 2) {
                $data['target'] = 'right';
                $data['url'] = (string)url('cms.Arctype/edit_content', array('id' => $rs['id']));
            }
            $json[] = $data;
        }
        View::assign('json', json_encode($json));
        return view();
    }
    /**
     * @NodeAnotation(title="右侧面板")
     */
    public function panl()
    {
        if ($this->request->isPost()) {
            $date                         = $this->request->post('date');
            list($xAxisData, $seriesData) = $this->getAdminPostData($date);
            $this->success('', '', ['xAxisData' => $xAxisData, 'seriesData' => $seriesData]);
        }else{
            $info['category']  = Db::name('arctype')->count();
            $info['model']    = Db::name('model')->count();
            $info['tags']     = Db::name('tag')->count();
            $info['doc']      = 0;
            $AllExtendModel = Db::name('model')->field('id,name')->where('extend', 0)->where('form',0)->select()->toArray();
            foreach ($AllExtendModel as $k => $v) {
                $tmp = Db::name($v['name'])->count();
                $info['doc'] += $tmp;
            }
            list($xAxisData, $seriesData) = $this->getAdminPostData();
            View::assign('xAxisData', $xAxisData);
            View::assign('seriesData', $seriesData);
            View::assign([
                'meta_title'=>'面板',
                'info'=>$info
            ]);
            return View::fetch();
        }
    }
    protected function getAdminPostData($date = '')
    {
        if ($date) {
            list($start, $end) = explode(' - ', $date);
            $start_time        = strtotime($start);
            $end_time          = strtotime($end);
        } else {
            $start_time = \util\Date::unixtime('day', 0, 'begin');
            $end_time   = \util\Date::unixtime('day', 0, 'end');
        }
        $diff_time = $end_time - $start_time;
        $format    = '%Y-%m-%d';
        if ($diff_time > 86400 * 30 * 2) {
            $format = '%Y-%m';
        } else {
            if ($diff_time > 86400) {
                $format = '%Y-%m-%d';
            } else {
                $format = '%H:00';
            }
        }
        // 获取所有表名
        $models = Db::name('model')
        ->field('name')
        ->where('form',0)
        ->where('extend',0)
        ->select()
        ->toArray();
        $list   = $xAxisData   = $seriesData   = [];
        if (count($models) > 0) {
            $table1 = $models[0]['name'];
            unset($models[0]);
            $field = 'a.name,b.uid,FROM_UNIXTIME(b.create_time, "' . $format . '") as inputtimes,COUNT(*) AS num';
            $dbObj = Db::name($table1)->alias('b')->field($field)
            ->whereTime('b.create_time', 'between', [$start_time, $end_time])
            ->join('admin a', 'a.id = b.uid');
            foreach ($models as $k => $v) {
                $dbObj->union(function ($query) use ($field, $start_time, $end_time, $v) {
                    $query->name($v['name'])->alias('b')->field($field)
                    ->whereTime('b.create_time', 'between', [$start_time, $end_time])
                    ->join('admin a', 'a.id = b.uid')
                    ->group('uid,inputtimes');
                });
            }
            $res = $dbObj->group('uid,inputtimes')->select()->toArray();
            if ($diff_time > 84600 * 30 * 2) {
                $start_time = strtotime('last month', $start_time);
                while (($start_time = strtotime('next month', $start_time)) <= $end_time) {
                    $column[] = date('Y-m', $start_time);
                }
            } else {
                if ($diff_time > 86400) {
                    for ($time = $start_time; $time <= $end_time;) {
                        $column[] = date("Y-m-d", $time);
                        $time += 86400;
                    }
                } else {
                    for ($time = $start_time; $time <= $end_time;) {
                        $column[] = date("H:00", $time);
                        $time += 3600;
                    }
                }
            }
            $xAxisData = array_fill_keys($column, 0);
            foreach ($res as $k => $v) {
                if (!isset($list[$v['name']])) {
                    $list[$v['name']] = $xAxisData;
                }
                $list[$v['name']][$v['inputtimes']] = $v['num'];
            }
            foreach ($list as $index => $item) {
                $seriesData[] = [
                    'name'      => $index,
                    'type'      => 'line',
                    'smooth'    => true,
                    'areaStyle' => [],
                    'data'      => array_values($item),
                ];
            }
        }
        return [array_keys($xAxisData), $seriesData];
    }
    /**
     * @NodeAnotation(title="右侧文档")
     */
    public function document()
    {
        $map = array();
        $date = input('date');//日期范围
        $status = trim(input('status'));//状态
        $category_id = trim(input('get.category_id') ? input('get.category_id') : input('category_id'));//栏目
        // 检查权限
        if(!$this->CheckPermissions($category_id,'select')){
            $this->error('无权限查看！');
        }
        $flags = trim(input('flags'));//flags
        $title = trim(input('title'));//关键词
        // 栏目条件处理
        $arctype = Db::name('arctype')->field('model_id')->find($category_id);
        $model = Db::name('model')->field('id,extend,name')->find($arctype['model_id']);
        if ($model['extend']) { //判断是否是独立模型，否
            $tableName = Db::name('model')->field('id,extend')->where('id',$model['extend'])->value('name');
        } else {
            $tableName = $model['name'];
        }
        // 获取所有子栏目ID包含自身-相同模型
        $typeids = getAllChildcateIds_same_model($category_id);
        if (!empty($typeids)) {
            $typeids = explode(',', $typeids);
            $map[] = ['category_id', 'in', $typeids];
        }
        // 日期条件处理
        if($date){
            $dateArr = explode(' - ',$date);
            $start_time = strtotime($dateArr[0]); 
            $end_time = strtotime($dateArr[1]); 
            $map[] = ['update_time','between',[$start_time,$end_time]];
        }
        // 状态条件处理
        if ($status !== '' && ($status == 0 || $status == 1 || $status == 2 || $status == 3 || $status == '-1')) {
            $map[] = ['status', '=', $status];
        }
        // 关键词条件处理
        if ($title) {
            $map[] = ['title', 'like', "%$title%"];
        }
        // 排序条件处理
        $sort = input('sort');
        if ($sort) {
            $sort_arr = explode('-', $sort);
            if ($sort_arr[1] == 'up') {
                $order = [$sort_arr[0] => 'asc'];
            } else {
                $order = [$sort_arr[0] => 'desc'];
            }
        } else {
            $order = ['sort' => 'desc','update_time' => 'desc','id' => 'desc'];
        }
        // flags条件处理
        $flags_where = "";
        if($flags){
            $flags_where = "find_in_set('{$flags}',flags)";
        }
        $curr = input('page',1);//当前页码
        $limit = input('limit',5);//每页显示的数目
        $ceshi = '';
        $list = Db::name($tableName)
        ->field(true)
        ->where($map)
        ->where($flags_where)
        ->order($order)
        ->paginate(['list_rows'=> $limit,'var_page' => 'page','query' => request()->param()])
        ->each(function ($item, $key) use($ceshi) {
            $ceshi = '测试use';
            // 根据栏目ID获取模型ID
            $model_id = get_modelId_by_categoryId($item['category_id']);
            $item['model_id'] = $model_id;
            $flags_arr = get_field_attr('flags', $model_id);
            $item['flags_str'] = '&nbsp;';
            if ($item['flags']) {
                foreach (explode(',', $item['flags']) as $k => $v) {
                    $item['flags_str'] .= $v . ':' . $flags_arr[$v] . '&nbsp;';
                }
                $item['flags_str'] = "<font color='red'>" . $item['flags_str'] . "</font>";
            }
            int_to_string($item, array('status' => array('0' => '隐藏', '1' => '显示', '2' => '待审核', '3' => '草稿', '-1' => '已删除')));
            return $item;
        });
        // 记录当前列表页的cookie
        cookie('__forward__', $_SERVER['REQUEST_URI']);
        return view('document',[
            'meta_title' => '文档管理',//标题
            'status' => $status,//状态
            'sort' => $sort,//排序
            'category_id' => $category_id,//栏目id
            'model_id' => get_modelId_by_categoryId($category_id),//模型id
            'list' => $list->all(),//分页后列表
            // 每页显示数目、总数目、当前页码
            'page' => ['limit'=>$limit,'count'=>$list->total(),'curr'=>$curr],
            'flags' => $flags,//自定义属性
        ]);
    }
    // 检查权限
    protected function CheckPermissions($category_id,$action)
    {
        if(UID !== 1){
            $group_id_arr = Db::name('auth_group_access')->where('uid',UID)->column('group_id');
            $catidPrv = Db::name('arctype_priv')
            ->where([
                ['catid','=',$category_id],
                ['roleid','in',$group_id_arr],
                ['is_admin','=',1],
                ['action','=',$action],
            ])->find();
            if (empty($catidPrv)) {
                return false;
            }
            return true;
        }
        return true;
    }
}