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
// | 模型控制器
// +----------------------------------------------------------------------
namespace app\admin\controller\cms;
use think\facade\Db;
use think\facade\View;
use think\facade\Config;
use app\admin\controller\Base;
use app\admin\model\cms\Models;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
use app\admin\validate\cms\Model as ModelValidate;
/**
 * @ControllerAnnotation(title="模型管理")
 * Class Model
 * @package app\admin\controller\cms
 */
class Model extends Base
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
        $map[] = ['form','=',0];
        if ($status !== '' && ($status == 0 || $status == 1)) {
            $map[] = ['status', '=', $status];
            $query['status'] = $status;
        }
        if ($title) {
            $map[] = ['title', 'like', "%$title%"];
            $query['title'] = $title;
        }
        $order = ['sort' => 'desc', 'id' => 'asc'];
        $list = Db::name('model')
        ->where($map)
        ->order($order)
        ->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query])
        ->each(function ($item, $key) {
            int_to_string($item, $map = array('status' => array('0' => '禁用', '1' => '启用')));
            return $item;
        });
        View::assign([
            'status' => $status,//状态
            'meta_title' => '模型列表',//标题
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
            // 判断基础文档模型是否已经新增
            $document_model = Db::name('model')->find(1);
            if (!$document_model) {
                $data['is_system'] = 1;//基础文档模型永远是系统模型
                $data['extend'] == 0;//基础文档模型永远是独立模型
                $data['name'] = 'document';//基础文档模型标识暂时只能是document
            }
            if ($data['extend'] == 0) { //独立模型需要主键id
                $data['need_pk'] = 1;
            }
            // 栏目标识转为小写
            $data['name'] = strtolower($data['name']);
            // 数据验证
            $validate = new ModelValidate();
            if (!$validate->scene('add')->check($data)) {
                $this->error($validate->getError());
            }
            if ($data['extend'] == 0) { //独立模型
                $data['fields'] = '{"1":' . '[]' . ',"2":' . '[]' . '}';//字段列表
            } else { //继承基础文档模型
                $fields = Db::name('model')->field('fields')->find($data['extend']);
                if ($fields) {
                    $data['fields'] = $fields['fields'];//字段列表
                } else {
                    $data['fields'] = '{"1":' . '[]' . ',"2":' . '[]' . '}';//字段列表
                }
            }
            $data['list_template'] = $this->field_prefix('list', $data['name']);//列表页模板
            $data['index_template'] = $this->field_prefix('index', $data['name']);//频道封面页模板
            $data['article_template'] = $this->field_prefix('article', $data['name']);//文章内容页模板
            $data['article_rule'] = '{Y}/{M}{D}/{aid}.html';//文章命名规则
            $data['list_rule'] = 'list_{tid}_{page}.html';//列表命名规则
            $data['create_time'] = time();//创建时间
            $data['update_time'] = time();//更新时间
            $data['status'] = 1;//状态
            $id = Db::name('model')->insertGetId($data);
            if (!$id) {
                $this->error('新增模型出错!');
            } else {
                action_log($id, 'model', 1);//记录新增后行为
                $table_exist = $this->checkTableExist($id); //检查模型对应的表是否存在
                if ($table_exist['code'] == 0) { //表未创建
                    $createtable = (new Models())->createTable($id, $table_exist['table_name']); //创建模型对应的表
                    if (!$createtable) {
                        $this->error('创建模型对应的表出错!');
                    }
                }
                $this->success('新增模型成功!', 'index');
            }
            return;
        }
        View::assign([
            'meta_title' => '新增模型',//标题title息
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="编辑")
     */
    public function edit($id = null)
    {
        $id = input('id', '');
        if (empty($id)) {
            $this->error('参数不能为空！');
        }
        // 获取一条记录的详细数据
        $info = Db::name('model')->field(true)->find($id);
        if (!$info) {
            $this->error('模型不存在!');
        }
        if (request()->isAjax()) {
            $data = input('post.');
            if ($id == 1) { //基础文档模型的is_system永远是1不能修改且永远是独立模型
                $data['extend'] == 0;
                $data['is_system'] = 1;
                $data['name'] = 'document';//基础文档模型标识暂时只能是document
            }
            if ($data['extend'] == 0) { //独立模型需要主键id
                $data['need_pk'] = 1;
            }
            // 如果之前是独立模型 判断是否修改模型标识如果修改 判断是否有继承模型 有就不能修改 因为表名会错乱
            if ($info['extend'] == 0 || $data['extend'] == 0) {
                if ($info['name'] !== $data['name']) {
                    $child_model = Db::name('model')->where('extend', $id)->select()->toArray();
                    if ($child_model) {
                        $this->error('有继承它的模型，模型标识不能修改！');
                    }
                }
            }
            $data['name'] = strtolower($data['name']);
            // 数据验证
            $validate = new ModelValidate();
            if (!$validate->scene('edit')->check($data)) {
                $this->error($validate->getError());
            }
            // 判断和继承的模型字段是否冲突,除id外
            $old_model_attr_info = Db::name('attribute')->field('name')->where('model_id', $data['id'])->select()->toArray();
            $old_model_attr_arr = [];
            $old_model_attr_arr = array_column($old_model_attr_info, 'name');//该模型的所有字段数组
            $extend_model_info = Db::name('attribute')->field('name')->where('model_id', $data['extend'])->select()->toArray();
            $extend_model_attr_arr = [];
            $extend_model_attr_arr = array_column($extend_model_info, 'name');//该模型所继承模型的所有字段数组
            // array_intersect() 函数用于比较两个（或更多个）数组的键值，并返回交集。
            $comm_model_attr_arr = array_intersect($old_model_attr_arr, $extend_model_attr_arr);
            foreach ($comm_model_attr_arr as $k => $v) { //去除id字段它不在考虑范围之内
                if ($v == 'id') {
                    unset($comm_model_attr_arr[$k]);
                }
            }
            if (!empty($comm_model_attr_arr)) {
                $this->error('模型属性字段冲突不能修改！'.implode($comm_model_attr_arr,'|'),'',3);
            }
            $data['update_time'] = time();//更新时间
            if (empty($data['fields'])) {
                $data['fields'] = "[]";
            }
            if (empty($data['fields2'])) {
                $data['fields2'] = "[]";
            }
            /* if($data['extend'] == 0 && $data['id'] !=1){ //独立模型(除基础文档模型外)
                $fields = '{"1":'."[]".',"2":'."[]".'}';
            }else{
                $fields = '{"1":'.$data['fields'].',"2":'.$data['fields2'].'}';
            } */
            $fields = '{"1":' . $data['fields'] . ',"2":' . $data['fields2'] . '}';
            unset($data['fields2']);
            $data['fields'] = $fields;
            // 获取旧表名
            if ($info['extend'] == 0) { //该模型属于独立模型
                $old_table_name = Config::get('database.connections.mysql.prefix') . strtolower($info['name']);
            } else {
                // 所继承模型信息
                $extend_model = Db::name('model')->where('id', $info['extend'])->field('name,extend')->find();
                $old_table_name = Config::get('database.connections.mysql.prefix') . strtolower($extend_model['name']) . '_' . strtolower($info['name']);
            }
            action_log($data['id'], 'model', 2);//记录修改前行为
            $res = Db::name('model')->update($data);
            if ($res !== false) {
                // 判断新表是否存在
                $table_exist = $this->checkTableExist($id); //检查模型对应的表是否存在
                if ($table_exist['code'] == 0) { //表不存在，说明要修改表名而(不是重新新建表)
                    $createtable = $this->updateTable($id, $old_table_name); //更新模型对应的表
                    if (!$createtable) {
                        $this->error('修改模型对应的表出错!');
                    }
                }
                //判断是否需要修改引擎
                if ($info['engine_type'] !== $data['engine_type']) {
                    $this->updateEngine($id, $data['engine_type']);
                }
                // 判断是否增加主键
                if ($info['need_pk'] !== $data['need_pk']) {
                    $this->updatePk($id);
                }
                // 判断栏目category_id、title、title_en、flags、tags、thumb、source、uid、writer、keywords
                // description、content、view、status、sort、create_time、update_time是增加或删除
                $this->checkField($id, 'category_id');
                $this->checkField($id, 'title');
                $this->checkField($id, 'title_en');
                $this->checkField($id, 'flags');
                $this->checkField($id, 'tags');
                $this->checkField($id, 'thumb');
                $this->checkField($id, 'source');
                $this->checkField($id, 'uid');
                $this->checkField($id, 'writer');
                $this->checkField($id, 'keywords');
                $this->checkField($id, 'description');
                $this->checkField($id, 'content');
                $this->checkField($id, 'view');
                $this->checkField($id, 'status');
                $this->checkField($id, 'sort');
                $this->checkField($id, 'create_time');
                $this->checkField($id, 'update_time');
                // 记录修改后行为
                action_log($data['id'], 'model', 2);
                $this->success('更新模型成功', 'index');
            }
            $this->error('更新模型失败');
            return;
        }
        // 获取该模型所有字段
        $fields = Db::name('attribute')->where('model_id', $info['id'])->field('id,name,title,is_show,model_id,group_id')->select()->toArray();
        // dump($fields);die;
        if ($info['extend'] != 0) { //非独立模型 字段=该模型所有字段+继承模型所有字段(基础文档模型)
            $extend_fields = Db::name('attribute')->where('model_id', $info['extend'])->field('id,name,title,is_show,model_id,group_id')->select()->toArray();
            $fields = array_merge($fields, $extend_fields);
            // $fields += $extend_fields;
        }
        // dump($fields);die;
        // 获取模型排序字段
        // $info['fields'] ='{"1":[{"id":1},{"id":3},{"id":25},{"id":7},{"id":6},{"id":4},{"id":19},{"id":5},{"id":9},{"id":20}],"2":[{"id":8},{"id":10},{"id":14},{"id":12},{"id":13},{"id":15},{"id":11},{"id":16},{"id":17},{"id":2},{"id":18}]}';
        $field_sort = json_decode($info['fields'], true);//起到分组作用
        // dump($field_sort);die;
        /* array(2) {
          [1] => array(2) {
            [0] => array(1) {
              ["id"] => int(32)
            }
            [1] => array(1) {
              ["id"] => int(34)
            }
          }
          [2] => array(21) {
            [0] => array(1) {
              ["id"] => int(1)
            }
            [1] => array(1) {
              ["id"] => int(2)
            }
          }
        } */
        // dump($field_sort);die;
        // dump($info['fields']);
        // dump($field_sort);die;
        // 对数组进行排序
        $i = 0;
        foreach ($field_sort as $k => $v) {
            if (empty($v)) {
                $i += 1;
            }
        }
        if ($i >= 1) { //实际上只有两组 基础设置和拓展设置，如果至少有一组为空那么不按$info['fields']的值来判断即$field_sort为空
            $field_sort = '';
        }
        // dump($field_sort);die;
        if (!empty($field_sort)) { //分组
            // dump($field_sort);die;
            // 对字段数组重新整理
            $fields_f = array();
            foreach ($fields as $v) {
                $fields_f[$v['id']] = $v;
            }
            // dump($fields_f);die;
            $fields = array();
            foreach ($field_sort as $key => $groups) {
                if (!empty($groups)) {
                    foreach ($groups as $group) {
                        if (!isset($fields_f[$group['id']])) {
                            continue;
                        }
                        $fields[$key][$group['id']] = array(
                            'id' => $fields_f[$group['id']]['id'],
                            'name' => $fields_f[$group['id']]['name'],
                            'title' => $fields_f[$group['id']]['title'],
                            'is_show' => $fields_f[$group['id']]['is_show'],
                            'group' => $key
                        );
                        unset($fields_f[$group['id']]);
                    }
                } else {
                    // 对剩下字段进行处理
                    if (!empty($fields_f)) { //好像这里多余
                        $fields[$key] = $fields_f;
                        unset($fields_f);
                    }
                }
            }
            // dump($fields);die;
            // 对剩下字段进行处理 赋给拓展设置
            if (!empty($fields_f)) {
                // dump($fields_f);die;
                if (isset($fields[1])) {
                    $fields[1] = $fields[1] + $fields_f;
                } else {
                    $fields[1] = $fields_f;
                }
                ksort($fields);
            }
        } else { //不分组
            // dump($fields);die;
            if (!empty($fields)) {
                $fields2 = array();
                foreach ($fields as $field) {
                    $fields2[$field["group_id"]][$field['id']] = $field;
                }
                $fields = $fields2;
            }
            ksort($fields);//对数组的键按照升序排列(krsort降序)保留键值关系，基础设置在前，拓展设置在后
        }
        View::assign([
            'meta_title' => '编辑模型',
            'fields' => $fields,
            'info' => $info,
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="删除")
     */
    public function del($ids = NULL)
    {
        $ids = !empty($ids) ? $ids : input('ids', 0);
        if (empty($ids)) {
            $this->error('参数不能为空！');
        }
        if (!is_array($ids)) {
            $ids = array(intval($ids));
        }
        // 判断是否有系统模型，系统模型不能删除
        $model_info = Db::name('model')->field('is_system')->where([['id', 'in', $ids]])->select()->toArray();
        $is_system_arr = array_column($model_info, 'is_system');
        if (in_array('1', $is_system_arr)) {
            $this->error('系统模型不能删除!');
        }
        // 判断模型下是否存在栏目
        $arctype = Db::name('arctype')->where([['model_id', 'in', $ids]])->find();
        if ($arctype) {
            $this->error('请先删除模型下的所有栏目！');
        }
        // 判断模型下是否存在字段
        $field = Db::name('attribute')->where([['model_id', 'in', $ids]])->find();
        if ($field) {
            $this->error('请先删除模型下对应的属性(字段)！');
        }
        foreach ($ids as $id) {
            $model = Db::name('model')->field('is_system,name,extend')->find($id);
            if($id == 1){ //基础文档模型不能删除
                $this->error($model['title'].'模型不能删除！');
                break;
            }
            if ($model['is_system'] == 1) {
                $this->error('系统模型不能删除！');
                break;
            } else {
                $cate = Db::name('arctype')->where('model_id', $id)->find();
                if ($cate) {
                    $this->error('请先删除该模型下对应的栏目！');
                    break;
                }
                $field = Db::name('attribute')->where('model_id', $id)->find();
                if ($field) {
                    $this->error('请先删除该模型下对应的属性！');
                    break;
                }
                if ($model['extend'] == 0) { //获取独立模型表名
                    $table_name = Config::get('database.connections.mysql.prefix') . strtolower($model['name']);
                } else { //获取非独立模型表名
                    $extend_model = Db::name('model')->where('id', $model['extend'])->field('name,extend')->find();
                    $table_name = Config::get('database.connections.mysql.prefix') . strtolower($extend_model['name']) . '_' . strtolower($model['name']);
                }
                action_log($id, 'model', 3);//记录删除行为
                $res = Db::name('model')->delete($id);
                if (!$res) {
                    break;
                }
                $db = Db::connect();
                $res2 = $db->execute("DROP TABLE IF EXISTS `{$table_name}`");
                if (!$res) {
                    break;
                }
            }
        }
        if (!$res) {
            $this->error('删除模型失败');
        } else {
            if ($res2 !== false) {
                $this->success('删除模型成功');
            }
            $this->error('删除模型成功，但删除模型对应表失败');
        }
    }
    /**
     * @NodeAnotation(title="状态")
     */
    public function setStatus($model = 'model', $data = array(), $type = 2)
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
    public function sort($model = 'model', $data = array())
    {
        $data['sort'] = input('sort');
        return parent::sort($model, $data);
    }
    /**
     * [field_prefix 模板添加后缀]
     * @param  $str1
     * @param  $str2
     * @return string
     */
    protected function field_prefix($str1, $str2)
    {
        $str = '';
        if (!empty($str1) && !empty($str2)) {
            $str = $str1 . '_' . $str2 . '.html';
        }
        return $str;
    }
    /**
     * [checkTableExist 检查表是否存在]
     * @param intger $model_id 模型id
     * @return intger 是否存在
     */
    protected function checkTableExist($model_id)
    {
        $model = Db::name('model')->field('name,extend')->find($model_id);
        if ($model['extend'] == 0) { //独立模型表名
            $table_name = Config::get('database.connections.mysql.prefix') . strtolower($model['name']);
        } else { //继承基础文档模型表名
            $extend_model = Db::name('model')->where('id', $model['extend'])->field('name')->find();
            $table_name = Config::get('database.connections.mysql.prefix') . strtolower($extend_model['name']) . '_' . strtolower($model['name']);
        }
        $sql = <<<sql
        SHOW TABLES LIKE '{$table_name}';
sql;
        $db = Db::connect();
        $res = $db->query($sql);
        if (count($res)) {
            return ['code' => 1];//表已创建
        }
        return ['code' => 0, 'table_name' => $table_name];//表还未创建
    }
    /**
     * [updateTable 根据模型ID修改对接模型表]
     * @param int $model_id 模型ID
     * @param string $old_table_name 旧表名
     * @return int
     */
    protected function updateTable($model_id, $old_table_name)
    {
        if (empty($model_id)) {
            return false;
        }
        $sql = '';
        $model_info = Db::name('model')->field('engine_type,extend,name,need_pk')->find($model_id);
        if ($model_info['extend'] == 0) {  //独立模型表名
            $new_table_name = Config::get('database.connections.mysql.prefix') . strtolower($model_info['name']);
        } else { //继承模型表名
            $extend_model = Db::name('model')->where('id', $model_info['extend'])->field('name,extend')->find();
            $new_table_name = Config::get('database.connections.mysql.prefix') . strtolower($extend_model['name']) . '_' . strtolower($model_info['name']);
        }
        if ($old_table_name == $new_table_name) { //表相同不用修改
            return true;
        }
        $sql = <<<sql
        RENAME TABLE `{$old_table_name}` TO `{$new_table_name}`
        ;
sql;
        $db = Db::connect();
        $res = $db->execute($sql);
        return $res !== false;
    }
    /**
     * [updateEngine 修改引擎]
     * @return [type] [description]
     */
    protected function updateEngine($model_id, $new_engine)
    {
        if (empty($model_id)) {
            return false;
        }
        $sql = '';
        $model_info = Db::name('model')->field('engine_type,extend,name,need_pk')->find($model_id);
        if ($model_info['extend'] == 0) {  //独立模型表名
            $table_name = Config::get('database.connections.mysql.prefix') . strtolower($model_info['name']);
        } else { //继承模型表名
            $extend_model = Db::name('model')->where('id', $model_info['extend'])->field('name,extend')->find();
            $table_name = Config::get('database.connections.mysql.prefix') . strtolower($extend_model['name']) . '_' . strtolower($model_info['name']);
        }
        $sql = <<<sql
            ALTER TABLE `{$table_name}` ENGINE={$new_engine}
            ;
sql;
        $db = Db::connect();
        $res = $db->execute($sql);
        return $res !== false;
    }
    /**
     * [updatePk 修改主键]
     * @return [type] [description]
     */
    protected function updatePk($model_id)
    {
        if (empty($model_id)) {
            return false;
        }
        $sql = '';
        $model_info = Db::name('model')->field('extend,name,need_pk')->find($model_id);
        if ($model_info['extend'] == 0) { //独立模型表名
            $table_name = Config::get('database.connections.mysql.prefix') . strtolower($model_info['name']);
        } else { //继承模型表名
            $extend_model = Db::name('model')->where('id', $model_info['extend'])->field('name,extend')->find();
            $table_name = Config::get('database.connections.mysql.prefix') . strtolower($extend_model['name']) . '_' . strtolower($model_info['name']);
        }
        $db = Db::connect();
        // 获取表所有字段
        $database_name = Config::get('database.connections.mysql.database');//获取数据库名
        $field_name = $db->query("select GROUP_CONCAT(COLUMN_NAME) as fields from information_schema.COLUMNS where table_name = '{$table_name}' and table_schema ='{$database_name}'");
        $field_arr = explode(',', $field_name[0]['fields']);
        // 判断是否有主键
        $sql = <<<sql
        SELECT count(*) PrimaryNum
        FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE t
        where t.TABLE_NAME ='{$table_name}'
        and t.CONSTRAINT_NAME = 'PRIMARY'
        ;
sql;
        $count = $db->query($sql);
        if ($count[0]['PrimaryNum'] >= 1) { //说明存在主键
            $pk = true;//存在主键
        } else {
            $pk = false;//不存在主键
        }
        if (!$model_info['need_pk']) { //判断是否需要主键，不需要
            if (in_array('id', $field_arr)) { //判断id字段是否存在，存在
                if ($pk) { //判断是否有主键，有自增长AUTO_INCREMENT不能直接删除主键，删除主键
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` MODIFY id int(10) UNSIGNED UNIQUE NOT NULL COMMENT '非主键ID'
                    ;
sql;
                    // 先去掉自动增长属性
                    $res1 = $db->execute($sql);
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` DROP PRIMARY KEY
                    ;
sql;
                    // 再去掉主键
                    $res2 = $db->execute($sql);
                    // return $res2 !== false;
                }
                /* else{
                    return true;
                } */
            } else { //id字段不存在，新建非主键ID字段
                $sql = <<<sql
                ALTER TABLE `{$table_name}` ADD `id` int(10) UNSIGNED UNIQUE NOT NULL COMMENT '非主键ID'
                ;
sql;
                $res1 = $db->execute($sql);//增加字段
                // return true;
            }
            // 判断模型字段表是否有此字段
            $map[] = ['model_id', '=', $model_id];
            $map[] = ['name', '=', 'id'];
            $field_exist = Db::name('attribute')->where($map)->find();
            if (!$field_exist) {
                Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 2, 'name' => 'id', 'title' => '非主键ID', 'field' => 'int(10) UNSIGNED UNIQUE NOT NULL', 'type' => 'num', 'remark' => '非主键ID', 'is_show' => 0, 'create_time' => time(), 'update_time' => time(), 'sort' => 100]);
            } else {
                Db::name('attribute')->where($map)->update(['group_id' => 2, 'title' => '非主键ID', 'field' => 'int(10) UNSIGNED UNIQUE NOT NULL', 'type' => 'num', 'remark' => '非主键ID', 'update_time' => time()]);
            }
        } else {
            if (in_array('id', $field_arr)) { //判断id字段是否存在，存在
                if (!$pk) { //增加主键
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` MODIFY  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID'
                    ;
sql;
                    $res1 = $db->execute($sql); //增加主键
                    /* $sql = <<<sql
                    ALTER TABLE `{$new_table_name}` ADD PRIMARY KEY(id)
                    ;
sql;
                    $res2 = $db->execute($sql); //后增加主键 */
                }
            } else { //id字段不存在，新建字段
                $sql = <<<sql
                ALTER TABLE `{$table_name}` ADD `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID'
                ;
sql;
                // 增加主键id自动
                $res1 = $db->execute($sql);
                /* $sql = <<<sql
                    ALTER TABLE `{$new_table_name}` ADD PRIMARY KEY(id)
                    ;
sql;
                $res1 = $db->execute($sql);//后增加主键 */
            }
            // 判断模型字段表是否有此字段
            $map[] = ['model_id', '=', $model_id];
            $map[] = ['name', '=', 'id'];
            $field_exist = Db::name('attribute')->where($map)->find();
            if (!$field_exist) {
                Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 2, 'name' => 'id', 'title' => '主键ID', 'field' => 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'type' => 'num', 'remark' => '主键ID', 'is_show' => 0, 'create_time' => time(), 'update_time' => time(), 'sort' => 100]);
            } else {
                Db::name('attribute')->where($map)->update(['group_id' => 2, 'title' => '主键ID', 'field' => 'int(10) UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY', 'type' => 'num', 'remark' => '主键ID', 'update_time' => time()]);
            }
            // return true;
        }
        // $res = $db->execute($sql);
        // return $res !== false;
        return true;
    }
    /**
     * [checkField 判断字段增加或删除]
     * @param  [type] $model_id    [模型ID]
     * @param  [type] $check_field [字段]
     * @return [type]              [description]
     */
    protected function checkField($model_id, $check_field)
    {
        $model_info = Db::name('model')->field('extend,name')->find($model_id);
        if ($model_info['extend'] == 0) { //独立模型表名
            $table_name = Config::get('database.connections.mysql.prefix') . strtolower($model_info['name']);
        } else { //继承模型表名
            $extend_model = Db::name('model')->where('id', $model_info['extend'])->field('name,extend')->find();
            $table_name = Config::get('database.connections.mysql.prefix') . strtolower($extend_model['name']) . '_' . strtolower($model_info['name']);
        }
        $db = Db::connect();
        $map[] = ['model_id', '=', $model_id];
        $map[] = ['name', '=', $check_field];
        $field_exist = Db::name('attribute')->where($map)->find();
        // 获取表所有字段
        $database_name = Config::get('database.connections.mysql.database');//获取数据库名
        $field_name = $db->query("select GROUP_CONCAT(COLUMN_NAME) as fields from information_schema.COLUMNS where table_name = '{$table_name}' and table_schema ='{$database_name}'");
        $field_arr = explode(',', $field_name[0]['fields']);
        if ($model_info['extend'] == 0) { //判断是否独立模型，是，如果是需要字段
            if (!in_array($check_field, $field_arr)) { //判断字段是否存在，不存在
                if ($check_field == 'category_id') { //category_id所属分类ID
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '所属分类ID';
sql;
                } elseif ($check_field == 'title') { //标题title
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` varchar(255) NOT NULL DEFAULT '' COMMENT '标题';
sql;
                } elseif ($check_field == 'title_en') { //英文标题title_en
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` varchar(255) NOT NULL DEFAULT '' COMMENT '英文标题';
sql;
                } elseif ($check_field == 'flags') { //自定义属性flags
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` varchar(100) NOT NULL DEFAULT '' COMMENT '自定义属性';
sql;
                } elseif ($check_field == 'tags') { //TAG标签tags
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` varchar(255) NOT NULL DEFAULT '' COMMENT 'TAG标签';
sql;
                } elseif ($check_field == 'thumb') { //缩略图thumb
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` varchar(100) NOT NULL DEFAULT '' COMMENT '缩略图';
sql;
                } elseif ($check_field == 'source') { //来源source
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` varchar(255) NOT NULL DEFAULT '' COMMENT '来源';
sql;
                } elseif ($check_field == 'uid') { //uid管理员ID
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '管理员ID';
sql;
                } elseif ($check_field == 'writer') { //作者writer
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` varchar(255) NOT NULL DEFAULT '' COMMENT '作者';
sql;
                } elseif ($check_field == 'keywords') { //关键词keywords
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` varchar(255) NOT NULL DEFAULT '' COMMENT '关键词';
sql;
                } elseif ($check_field == 'description') { //描述description
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` text DEFAULT NULL COMMENT '描述';
sql;
                } elseif ($check_field == 'content') { //内容content
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` text DEFAULT NULL COMMENT '内容';
sql;
                } elseif ($check_field == 'view') { //浏览量view
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '浏览量';
sql;
                } elseif ($check_field == 'status') { //状态status
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` char(50) NOT NULL DEFAULT '1' COMMENT '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)';
sql;
                } elseif ($check_field == 'sort') { //排序sort
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '排序';
sql;
                } elseif ($check_field == 'create_time') { //创建时间create_time
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间';
sql;
                } elseif ($check_field == 'update_time') { //更新时间update_time
                    $sql = <<<sql
                    ALTER TABLE `{$table_name}` ADD `{$check_field}` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间';
sql;
                }
                $db->execute($sql);//增加字段
            }
            if (!$field_exist) { //判断字段表是否存在，不存在，增加
                if ($check_field == 'category_id') { //所属分类ID
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'category_id', 'title' => '所属分类ID', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'num', 'value' => '0', 'is_show' => 0, 'remark' => '所属分类ID', 'create_time' => time(), 'update_time' => time(), 'sort' => 90]);
                } elseif ($check_field == 'title') { //标题title
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'title', 'title' => '标题', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'string', 'is_must' => 1, 'remark' => '标题', 'create_time' => time(), 'update_time' => time(), 'sort' => 80]);
                } elseif ($check_field == 'title_en') { //英文标题title_en
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'title_en', 'title' => '英文标题', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'string', 'is_must' => 0, 'remark' => '英文标题', 'create_time' => time(), 'update_time' => time(), 'sort' => 80]);
                } elseif ($check_field == 'flags') { //自定义属性flags
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'flags', 'title' => '自定义属性', 'field' => "varchar(100) NOT NULL DEFAULT ''", 'type' => 'checkbox', 'is_must' => 0, 'remark' => '自定义属性', 'extra'=>'h:头条,c:推荐,f:幻灯,a:特荐,s:滚动,b:加粗,p:图片,j:跳转;','create_time' => time(), 'update_time' => time(), 'sort' => 70]);
                } elseif ($check_field == 'tags') { //TAG标签tags
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'tags', 'title' => 'TAG标签', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'tags', 'is_must' => 0, 'remark' => 'TAG标签', 'create_time' => time(), 'update_time' => time(), 'sort' => 60]);
                } elseif ($check_field == 'thumb') { //缩略图thumb
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'thumb', 'title' => '缩略图', 'field' => "varchar(100) NOT NULL DEFAULT ''", 'type' => 'picture', 'is_must' => 0, 'remark' => '缩略图', 'create_time' => time(), 'update_time' => time(), 'sort' => 50]);
                } elseif ($check_field == 'source') { //来源source
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'source', 'title' => '来源', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'string', 'is_must' => 0, 'remark' => '来源', 'create_time' => time(), 'update_time' => time(), 'sort' => 40]);
                } elseif ($check_field == 'uid') { //uid管理员ID
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'uid', 'title' => '管理员ID', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'num', 'value' => '0', 'is_show' => 0, 'remark' => '管理员ID', 'create_time' => time(), 'update_time' => time(), 'sort' => 30]);
                } elseif ($check_field == 'writer') { //作者writer
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'writer', 'title' => '作者', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'string', 'is_must' => 0, 'remark' => '作者', 'create_time' => time(), 'update_time' => time(), 'sort' => 29]);
                } elseif ($check_field == 'keywords') { //关键词keywords
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'keywords', 'title' => '关键词', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'string', 'is_must' => 0, 'remark' => '关键词', 'create_time' => time(), 'update_time' => time(), 'sort' => 28]);
                } elseif ($check_field == 'description') { //描述description
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'description', 'title' => '描述', 'field' => "text DEFAULT NULL", 'type' => 'textarea', 'is_must' => 0, 'remark' => '描述', 'create_time' => time(), 'update_time' => time(), 'sort' => 27]);
                } elseif ($check_field == 'content') { //内容content
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'content', 'title' => '内容', 'field' => "text DEFAULT NULL", 'type' => 'editor', 'is_must' => 0, 'remark' => '内容', 'create_time' => time(), 'update_time' => time(), 'sort' => 26]);
                } elseif ($check_field == 'view') { //浏览量view
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'view', 'title' => '浏览量', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'num', 'value' => '0', 'is_show' => 1, 'remark' => '浏览量', 'create_time' => time(), 'update_time' => time(), 'sort' => 25]);
                } elseif ($check_field == 'status') { //状态status
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'status', 'title' => '状态', 'field' => "char(50) NOT NULL DEFAULT '1'", 'type' => 'select', 'value' => '1', 'extra' => "-1:删除,0:隐藏,1:显示,2:待审核,3:草稿", 'remark' => '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)', 'create_time' => time(), 'update_time' => time(), 'sort' => 70]);
                } elseif ($check_field == 'sort') { //排序sort
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'sort', 'title' => '排序', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'num', 'value' => '0', 'remark' => '排序', 'create_time' => time(), 'update_time' => time(), 'sort' => 40]);
                } elseif ($check_field == 'create_time') { //创建时间
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'create_time', 'title' => '创建时间', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'datetime', 'value' => '0', 'is_show' => 3, 'remark' => '创建时间', 'create_time' => time(), 'update_time' => time(), 'sort' => 60]);
                } elseif ($check_field == 'update_time') { //更新时间
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'update_time', 'title' => '更新时间', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'datetime', 'value' => '0', 'is_show' => 0, 'remark' => '更新时间', 'create_time' => time(), 'update_time' => time(), 'sort' => 50]);
                }
            }
        } else { //判断是否独立模型，否
            if (in_array($check_field, $field_arr)) { //如果存在删除
                $sql = <<<sql
                ALTER TABLE `{$table_name}` DROP column `{$check_field}`;
sql;
                $db->execute($sql);//删除字段
            }
            if ($field_exist) { //判断字段表是否存在，存在，删除
                Db::name('attribute')->delete($field_exist['id']);
            }
        }
    }
}