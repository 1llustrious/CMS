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
// | 模型属性(字段)控制器
// +----------------------------------------------------------------------
namespace app\admin\controller\cms;
use think\facade\Db;
use think\facade\View;
use think\facade\Config;
use app\admin\model\cms\Form;
use app\admin\controller\Base;
use app\admin\model\cms\Models;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
use app\admin\validate\cms\Attribute as AttributeValidate;
/**
 * @ControllerAnnotation(title="模型属性(字段)管理")
 * Class Attribute
 * @package app\admin\controller\cms
 */
class Attribute extends Base
{
    /**
     * @NodeAnotation(title="列表")
     */
    public function index()
    {
        $map = array();
        $query = array();
        $model_id = input('model_id',0);
        $table_name = input('table_name','');
        $status = trim(input('status'));
        $group_id = trim(input('group_id'));
        $title = trim(input('title'));
        $map[] = ['model_id', '=', $model_id];
        $query['model_id'] = $model_id;
        $map[] = ['table_name', '=', $table_name];
        $query['table_name'] = $table_name;
        if ($status !== '' && ($status == 0 || $status == 1)) {
            $map[] = ['status', '=', $status];
            $query['status'] = $status;
        }
        if ($group_id !== '' && ($group_id == 1 || $group_id == 2)) {
            $map[] = ['group_id', '=', $group_id];
            $query['group_id'] = $group_id;
        }
        if ($title) {
            $map[] = ['name|title', 'like', "%$title%"];
            $query['title'] = $title;
        }
        $order = ['sort' => 'desc', 'id' => 'asc']; //排序
        $list = Db::name('attribute')
        ->where($map)
        ->order($order)
        ->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query])
        ->each(function ($item, $key) {
            int_to_string($item,array('status' => array('0' => '禁用', '1' => '正常')));
            return $item;
        });
        if($table_name){
            $meta_title = $table_name.'表字段';
        }else{
            $form = Db::name('model')->where('id',$model_id)->value('form');
            $meta_title = '['. get_model_by_id($model_id). '] '.$form?'表单':'模型'.'属性(字段)';
        }
        // dump($list->all());die;
        // dump($list->toArray());die;
        View::assign([
            'meta_title' => $meta_title,//标题
            'status' => $status,//状态
            'group_id' => $group_id,//分组
            'model_id' => $model_id,//模型id
            'table_name' => $table_name,//表名
            'list' => $list,//列表
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
            $validate = new AttributeValidate();
            if (!$validate->scene('add')->check($data)) {
                return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
            }
            // 检查字段是否合法
            if (!preg_match('/^[a-zA-Z][\w_]{1,29}$/', $data['name'])) {
                return json(['code'=>0,'msg'=>'字段名称不合法','url'=>'']);
            }
            // 检查同一张表或和上级基础字段是否有相同的字段
            if ($this->check_name($data['name'], $data['model_id'],$data['table_name'])) {
                return json(['code'=>0,'msg'=>'字段已存在！','url'=>'']);
            }
            // 检查默认值是否设置正确
            if (!$this->check_value($data['type'], $data['value'])) {
                return json(['code'=>0,'msg'=>'默认值设置不正确','url'=>'']);
            }
            // 新增字段不能和栏目表重要字段冲突
            $not_name = ['name', 'typename', 'typename_en']; 
            if (in_array($data['name'], $not_name)) {
                return json(['code'=>0,'msg'=>'字段和栏目表字段冲突！','url'=>'']);
            }
            $data['create_time'] = time();
            $data['update_time'] = time();
            $data['status'] = 1;
            // 创建表字段
            $res = $this->add_field($data);
            if (!$res) {
                return json(['code'=>0,'msg'=>'创建字段出错！','url'=>'']);
            }
            // 新增字段表字段信息
            $id = Db::name('attribute')->insertGetId($data);
            if (!$id) {
                return json(['code'=>0,'msg'=>'新增模型属性出错','url'=>'']);
            }
            // 记录新增后行为
            action_log($id, 'attribute', 1);
            return json(['code'=>1,'msg'=>'新增成功','url'=>cookie('__forward__')]);
        } else {
            View::assign([
                'meta_title' => '新增字段',
                'info' => null,
                'model_id' => input('model_id',0),
                'table_name' => input('table_name',''),
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
        $info = Db::name('attribute')->field(true)->find($id); // 当前信息
        if (request()->isAjax()) {
            $data = input('post.');
            // 数据验证
            $validate = new AttributeValidate();
            if (!$validate->scene('edit')->check($data)) {
                return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
            }
            // 字段不能和栏目表重要字段冲突
            $not_name = ['name', 'typename', 'typename_en'];
            if (in_array($data['name'], $not_name)) {
                return json(['code'=>0,'msg'=>'字段和栏目表字段冲突！','url'=>'']);
            }
            $res = $this->update_field($data); //更新表字段
            if ($res['code'] == 0) {
                return json(['code'=>0,'msg'=>$res['msg'],'url'=>'']);
            }
            action_log($data['id'], 'attribute', 2);//记录修改前行为
            $res = Db::name('attribute')->update($data);
            if ($res === false) {
                return json(['code'=>0,'msg'=>'更新失败','url'=>'']);
            }
            action_log($data['id'],'attribute',2);//记录修改后行为
            return json(['code'=>1,'msg'=>'更新成功','url'=>cookie('__forward__')]);
        } else {
            if (!$info) {
                return json(['code'=>0,'msg'=>'信息错误！','url'=>'']);
            }
            View::assign([
                'meta_title' => '编辑字段', //标题 title
                'info' => $info, //当前信息
                'model_id' => $info['model_id'], //模型id
                'table_name' => $info['table_name'], //模型id
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
        foreach ($ids as $k => $id) {
            $info = Db::name('attribute')->find($id);
            if (empty($info)) {
                return json(['code'=>0,'msg'=>'该字段不存在！','url'=>'']);
            }
            // 不能删除基础文档模型的必要字段
            if(!$info['table_name']){
                $form = Db::name('model')->where('id',$info['model_id'])->value('form');
                if($form){ //表单
                    $not_del_field = ['id','uid','username','ip','status','sort','create_time','update_time'];
                }else{ //模型
                    $not_del_field = ['id','category_id','title','title_en','flags','tags','thumb','source','uid','writer','keywords','description','content','view','status','sort','create_time','update_time'];
                }
            }else{
                $not_del_field = [];
            }
            if($info['model_id'] && in_array($info['name'],$not_del_field)){
                return json(['code'=>0,'msg'=>'必要字段不能删除！','url'=>'']);
            }
            // 记录删除行为
            action_log($id, 'attribute',3);
            $res = Db::name('attribute')->delete($id); //删除字段表字段信息
            $this->delete_field($info); //删除表字段
            if (!$res) {
                return json(['code'=>0,'msg'=>'删除失败','url'=>'']);
            }
            // 判断字段是否是联动类型 是 删除联动信息
            if ($info['type'] == 'stepselect') {
                Db::name('stepselect')->where('tid', $id)->delete();
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
    public function setStatus($model = 'Attribute', $data = array(), $type = 2)
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
    public function sort($model = 'Attribute', $data = array())
    {
        $data['sort'] = input('sort');
        return parent::sort($model, $data);
    }
    /**
     * [check_name 检查同一张表或和上级基础字段是否有相同的字段]
     * @param  [type] $name       [字段名]
     * @param  [type] $model_id   [模型id]
     * @param  [type] $table_name [表名]
     * @param  [type] $id         [字段id]
     * @return [type]             [description]
     */
    protected function check_name($name, $model_id = 0, $table_name = '', $id = null)
    {
        if($table_name){
            $map[] = ['table_name', '=', $table_name];
        }
        $map[] = ['name', '=', $name];
        $map[] = ['model_id', '=', $model_id];
        if (!empty($id)) {
            $map[] = ['id', '<>', $id];
        }
        $res1 = Db::name('attribute')->where($map)->find();
        if($res1){
            return true;
        }
        if($model_id){
            // 如果当前字段没有冲突，继续查找上级继承字段是否有冲突
            $ext[] = ['id', '=', $model_id];
            $extend_id = Db::name('model')->field('extend')->where($ext)->find();
            $map2[] = ['name', '=', $name];
            $map2[] = ['model_id', '=', $extend_id['extend']];
            $res2 = Db::name('attribute')->where($map2)->find();
            if($res2){
                return true;//存在
            }
            // 如果当前和上级都没有冲突，那么继续查找下级
            $son_model_id = Db::name('model')
            ->field('id')
            ->where([['extend','=',$model_id]])
            ->select()
            ->toArray();
            // 有下级模型
            if($son_model_id){
                $son_model_id_arr = array_column($son_model_id,'id');
                $res3 = Db::name('attribute')
                ->field('id,model_id,name,title')
                ->where('model_id','in',$son_model_id_arr)
                ->where('name','=',$name)
                ->select()
                ->toArray();
                if($res3){
                    return true;//存在
                }
            }
        }
        return false;//不存在
    }
    /**
     * [check_value 检查默认值是否设置正确]
     * @param [type] $type
     * @param [type] $value
     * @return void
     */
    protected function check_value($type, $value = null)
    {
        if (empty($value)) {
            return true;
        }
        if (!empty($type)) {
            switch ($type) {
                case 'num':
                    $bool = is_numeric($value) ? true : false;
                    return $bool;
                    break;
                case 'float':
                    $bool = is_numeric($value) ? true : false;
                    return $bool;
                    break;
                case 'decimal':
                    $bool = is_numeric($value) ? true : false;
                    return $bool;
                    break;
                case 'string':
                    $bool = is_string($value) ? true : false;
                    return $bool;
                    break;
                case 'textarea':
                    $bool = empty($value) ? true : false;
                    return $bool;
                    break;
                case 'datetime':
                    $bool = is_numeric($value) ? true : false;
                    return $bool;
                    break;
                case 'bool':
                    $bool = is_bool($value) ? true : false;
                    return $bool;
                    break;
                case 'editor':
                    $bool = is_string($value) ? true : false;
                    return $bool;
                    break;
                case 'picture':
                    $bool = is_string($value) ? true : false;
                    return $bool;
                    break;
                case 'piclist':
                    $bool = is_string($value) ? true : false;
                    return $bool;
                    break;
                case 'file':
                    $bool = is_string($value) ? true : false;
                    return $bool;
                    break;
                default:
                    return true;
                    break;
            }
        }
    }
    /**
     * [add_field 添加字段]
     * @param array $field 需要新建的字段属性
     * @return boolean true 成功 ， false 失败
     */
    protected function add_field($field)
    {
        // 检查表是否存在
        $table_exist = $this->checkTableExist($field['model_id'],$field['table_name']);
        if ($field['value'] === '') {
            $default = '';
        } elseif (is_numeric($field['value'])) {
            $field['field'] = str_replace(stristr($field['field'], 'DEFAULT'), '', $field['field']); //先去掉字段定义的默认
            $default = ' DEFAULT ' . $field['value'];
        } elseif (is_string($field['value'])) {
            $field['field'] = str_replace(stristr($field['field'], 'DEFAULT'), '', $field['field']); //先去掉字段定义的默认
            $default = 'DEFAULT \'' . $field['value'] . '\'';
        } else {
            $default = '';
        }
        $db = Db::connect();
        //如果表存在添加字段  如果表不存在添加表、字段
        if ($table_exist['code']) { //表存在
            //先判断字段是否存在
            //获取表所有字段
            $database_name = Config::get('database.connections.mysql.database'); //获取数据库名
            $field_name = $db->query("select GROUP_CONCAT(COLUMN_NAME) as fields from information_schema.COLUMNS where table_name = '{$table_exist['table_name']}' and table_schema ='{$database_name}'");
            $field_arr = explode(',', $field_name[0]['fields']);
            if (in_array($field['name'], $field_arr)) { //字段已经存在
                return true;
            } else {
                $sql = <<<sql
                ALTER TABLE `{$table_exist['table_name']}`
                ADD COLUMN `{$field['name']}` {$field['field']} {$default} COMMENT '{$field['title']}';
sql;
            }
        } else { //表不存在
            //先创建表
            $this->createTable($field['model_id'], $table_exist['table_name']);
            //再新建字段
            $sql = <<<sql
            ALTER TABLE `{$table_exist['table_name']}`
            ADD COLUMN `{$field['name']}` {$field['field']} {$default} COMMENT '{$field['title']}';
sql;
        }
        $res = $db->execute($sql);
        return $res !== false;
    }
    /**
     * [update_field 更新一个字段]
     * @param [type] $field 需要更新的字段属性
     * @return void
     */
    protected function update_field($field)
    {
        $db = Db::connect();
        // 检查表是否存在
        $table_exist = $this->checkTableExist($field['model_id'],$field['table_name']);
        // 获取默认值
        if ($field['value'] === '') {
            $default = '';
        } elseif (is_numeric($field['value'])) {
            $field['field'] = str_replace(stristr($field['field'], 'DEFAULT'), '', $field['field']); //先去掉字段定义的默认
            $default = ' DEFAULT ' . $field['value'];
        } elseif (is_string($field['value'])) {
            $field['field'] = str_replace(stristr($field['field'], 'DEFAULT'), '', $field['field']); //先去掉字段定义的默认
            $default = 'DEFAULT \'' . $field['value'] . '\'';
        } else {
            $default = '';
        }
        if ($table_exist['code'] == 0) { //表不存在
            $this->createTable($field['model_id'], $table_exist['table_name']); //先创建表
            //再创建字段
            $sql = <<<sql
            ALTER TABLE `{$table_exist['table_name']}`
            ADD COLUMN `{$field['name']}` {$field['field']} {$default} COMMENT '{$field['title']}';
sql;
        } else { //表已存在
            //获取原字段
            $attribute_info = Db::name('attribute')->field('name,model_id')->where('id', $field['id'])->find();
            // 判断是否和原字段一样且字段是否已经存在
            if($attribute_info['name'] != $field['name'] && $this->check_name($field['name'], $attribute_info['model_id'],$field['table_name'])){
                return ['code'=>0,'msg'=>'更新失败，该字段已存在！'];
            }
            //判断字段是否是主键
            $ispk = $this->ispk($table_exist['table_name'],$attribute_info['name']);
            if(!$ispk){ //非主键字段修改
                $old_field = $attribute_info['name'];
                $sql = <<<sql
                ALTER TABLE `{$table_exist['table_name']}`
                CHANGE COLUMN `{$old_field}` `{$field['name']}` {$field['field']} {$default} COMMENT '{$field['title']}';
sql;
            }else{
                // 先去掉自动增长属性
                $sql = <<<sql
                ALTER TABLE `{$table_exist['table_name']}` MODIFY {$field['name']} int(10) COMMENT '非主键id';
sql;
                $db->execute($sql);
                // 去掉主键
                $sql = <<<sql
                ALTER TABLE `{$table_exist['table_name']}` DROP PRIMARY KEY;
sql;
                $db->execute($sql);
                // 更新字段
                $old_field = $attribute_info['name'];
                $sql = <<<sql
                ALTER TABLE `{$table_exist['table_name']}`
                CHANGE COLUMN `{$old_field}` `{$field['name']}` {$field['field']} {$default} COMMENT '{$field['title']}';
sql;
            }
            $res = $db->execute($sql);
            if($res !== false){
                return ['code'=>1,'msg'=>'更新字段成功！'];
            }
            return ['code'=>0,'msg'=>'更新字段失败！'];
        }
    }
    /**
     * [delete_field 删除字段]
     * @param [type] $field 需要删除的字段属性
     * @return void
     */
    protected function delete_field($field)
    {
        $table_exist = $this->checkTableExist($field['model_id'],$field['table_name']);
        if ($table_exist['code'] == 0) {
            return false;
        }
        // 判断表字段是否存在
        if(!$this->checkTableFieldExist($field['name'],$table_exist['table_name'])){
            return true;//表字段不存在不用删除
        }
        $sql = <<<sql
        ALTER TABLE `{$table_exist['table_name']}`
        DROP COLUMN `{$field['name']}`;
sql;
        $db = Db::connect();
        $res = $db->execute($sql);
        return $res !== false;
    }
    /**
     * [ispk 判断某字段是否是主键]
     * @param [type] $table_name 表名
     * @param [type] $field_name 字段名
     * @return void
     */
    protected function ispk($table_name,$field_name)
    {
        $database_name = Config::get('database.connections.mysql.database');
        $sql = <<<sql
        select column_key
        from information_schema.columns
        where table_schema='{$database_name}' and table_name='{$table_name}' and column_name='{$field_name}';
sql;
        $db = Db::connect();
        $res = $db->query($sql);
        // 判断是否是主键
        if($res[0]['column_key'] == 'PRI'){
            return true;//是主键
        }
        return false;//不是主键
    }
    /**
     * [checkTableExist 检查表是否存在]
     * @param [type] $model_id   模型id
     * @param [type] $table_name 表名
     * @return void
     */
    protected function checkTableExist($model_id,$table_name)
    {
        if(!$model_id){ //非模型和表单
            return ['code' => 1, 'table_name' => Config::get('database.connections.mysql.prefix') . $table_name];
        }
        $model = Db::name('model')->field('name,extend')->find($model_id);
        if ($model['extend'] == 0) {  //独立模型表名
            $table_name = Config::get('database.connections.mysql.prefix') . strtolower($model['name']);
        } else { //继承模型表名
            $extend_model = Db::name('model')->where('id', $model['extend'])->field('name')->find();
            $table_name = Config::get('database.connections.mysql.prefix') . strtolower($extend_model['name']) . '_' . strtolower($model['name']);
        }
        // dump($table_name);die;
        $sql = <<<sql
        SHOW TABLES LIKE '{$table_name}';
sql;
        $db = Db::connect();
        $res = $db->query($sql);
        // dump($res);die;
        if (count($res)) {
            return ['code' => 1, 'table_name' => $table_name];//表已存在
        }
        return ['code' => 0, 'table_name' => $table_name];//表还未创建
    }
    /**
     * [checkTableFieldExist 检查表字段是否存在]
     * @param [type] $field 字段
     * @param [type] $table_name 表名
     * @return void
     */
    protected function checkTableFieldExist($field,$table_name)
    {
        $db = Db::connect();
        //获取表所有字段
        $database_name = Config::get('database.connections.mysql.database'); //获取数据库名
        $field_name = $db->query("select GROUP_CONCAT(COLUMN_NAME) as fields from information_schema.COLUMNS where table_name = '{$table_name}' and table_schema ='{$database_name}'");
        $field_arr = explode(',', $field_name[0]['fields']);
        if (in_array($field, $field_arr)) { //字段已经存在
            return true;
        }
        return false;
    }
    /**
     * [createTable 根据模型ID创建对接模型表]
     * @param [type] $model_id 模型ID
     * @param [type] $table_name 表名
     * @return void
     */
    protected function createTable($model_id, $table_name)
    {
        if($model_id){
            $form = Db::name('model')->where('id',$model_id)->value('form');
            if($form){
                (new Form())->createTable($model_id, $table_name);
            }else{
                (new Models())->createTable($model_id, $table_name);
            }
        }
        return true;
    }
}
