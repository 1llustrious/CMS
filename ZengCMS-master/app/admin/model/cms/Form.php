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
// | 表单模型
// +----------------------------------------------------------------------
namespace app\admin\model\cms;

use think\Model;
use think\facade\Db;

class Form extends Model
{
    // 表名
    protected $name = 'model';
    /**
     * [createTable 根据表单ID 创建对接表单表]
     * @param int $model_id 表单ID
     * @param string $table_name 表名
     * @return int
     */
    public function createTable($model_id, $table_name)
    {
        if (empty($model_id)) {
            return false;
        }
        $sql = '';
        $model_info = Db::name('model')->field('title,engine_type,need_pk,name,extend')->find($model_id);
        $model_info['title'] = $model_info['title'] . '表(表单)';
        $sql = <<<sql
        CREATE TABLE IF NOT EXISTS `{$table_name}` (
            `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID' ,
            `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
            `username` varchar(255) NOT NULL DEFAULT '' COMMENT '用户名',
            `ip` varchar(255) NOT NULL DEFAULT '' COMMENT 'IP',
            `status` char(50) NOT NULL DEFAULT '1' COMMENT '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)',
            `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
            `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
            `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间',
            PRIMARY KEY (`id`)
        )
        ENGINE={$model_info['engine_type']}
        DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci COMMENT='{$model_info['title']}'
        CHECKSUM=0
        ROW_FORMAT=DYNAMIC
        DELAY_KEY_WRITE=0
        ;
sql;
        $db = Db::connect();//连接数据库
        $res = $db->execute($sql);//创建表
        if ($res !== false) {
            //判断表单字段表是否有此字段即id字段
            $map[] = ['model_id', '=', $model_id];
            $map[] = ['name', '=', 'id'];
            $field_exist = Db::name('attribute')->where($map)->find();
            if (!$field_exist) { //字段表未有该表单对应表的字段id，字段表新增id字段
                Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 2, 'name' => 'id', 'title' => '主键ID', 'field' => 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'type' => 'num', 'remark' => '主键ID', 'is_show' => 0, 'create_time' => time(), 'update_time' => time(), 'sort' => 100]);
            } else { //字段表已有该表单对应表的字段id,对字段表的id进行修改
                Db::name('attribute')->where($map)->update(['group_id' => 2, 'title' => '主键ID', 'field' => 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'type' => 'num', 'remark' => '主键ID', 'update_time' => time()]);
            }
            //判断用户uid是否存在
            $category_id_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'uid']])->find();
            if (!$category_id_exist) {
                Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'uid', 'title' => '用户ID', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'num', 'value' => '0', 'is_show' => 0, 'remark' => '用户ID', 'create_time' => time(), 'update_time' => time(), 'sort' => 90]);
            }
            //判断用户名username是否存在
            $title_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'username']])->find();
            if (!$title_exist) {
                Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'username', 'title' => '用户名', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'string', 'value' => '', 'is_show' => 1, 'remark' => '用户名', 'create_time' => time(), 'update_time' => time(), 'sort' => 80]);
            }
            //判断ip是否存在
            $title_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'ip']])->find();
            if (!$title_exist) {
                Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'ip', 'title' => 'IP', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'string', 'value' => '', 'is_show' => 1, 'is_search'=>1,'remark' => 'IP', 'create_time' => time(), 'update_time' => time(), 'sort' => 70]);
            }
            // 判断状态status是否存在
            $status_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'status']])->find();
            if (!$status_exist) {
                Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'status', 'title' => '状态', 'field' => "char(50) NOT NULL DEFAULT '1'", 'type' => 'select', 'value' => '1', 'extra' => "-1:删除,0:隐藏,1:显示,2:待审核,3:草稿", 'remark' => '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)', 'create_time' => time(), 'update_time' => time(), 'sort' => 60]);
            }
            // 判断排序sort是否存在
            $sort_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'sort']])->find();
            if (!$sort_exist) {
                Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'sort', 'title' => '排序', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'num', 'value' => '0', 'remark' => '排序', 'create_time' => time(), 'update_time' => time(), 'sort' => 50]);
            }
            //判断创建时间create_time是否存在
            $create_time_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'create_time']])->find();
            if (!$create_time_exist) {
                Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'create_time', 'title' => '创建时间', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'datetime', 'value' => '0', 'is_show' => 3, 'is_search'=>0, 'remark' => '创建时间', 'create_time' => time(), 'update_time' => time(), 'sort' => 40]);
            }
            //判断修改时间update_time是否存在
            $update_time_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'update_time']])->find();
            if (!$update_time_exist) {
                Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'update_time', 'title' => '更新时间', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'datetime', 'value' => '0', 'is_show' => 0, 'remark' => '更新时间', 'create_time' => time(), 'update_time' => time(), 'sort' => 30]);
            }
        }
        return $res !== false;
    }
}