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
// | 模型模型
// +----------------------------------------------------------------------
namespace app\admin\model\cms;

use think\Model;
use think\facade\Db;

class Models extends Model
{
    protected $name = 'model';
    /**
     * [createTable 根据模型ID，创建对接模型表]
     * @param int $model_id 模型ID
     * @param string $table_name 表名
     * @return int
     */
    protected function createTable($model_id, $table_name)
    {
        if (empty($model_id)) {
            return false;
        }
        $sql = '';
        $model_info = Db::name('model')->field('title,engine_type,need_pk,name,extend')->find($model_id);
        $model_info['title'] = $model_info['title'] . '表(模型)';
        if ($model_info['need_pk']) { //创建表的id是主键
            if ($model_info['extend'] == 0) { //判断是否是独立模型，是
                // 增加主键id字段、增加category_id(栏目表的id)字段、增加标题title字段、增加英文标题title_en字段、
                // 增加自定义属性flags字段、增加TAG标签tags字段、增加缩略图thumb字段、增加来源source字段
                // 增加uid(管理员ID)字段、增加作者writer字段、增加关键词keywords字段、增加描述description字段
                // 增加内容content字段、增加浏览量view字段
                // 增加状态status字段、增加排序sort字段、增加创建时间create_time字段、增加修改时间update_time字段
                $sql = <<<sql
                CREATE TABLE IF NOT EXISTS `{$table_name}` (
                    `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID' ,
                    `category_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '所属分类ID',
                    `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
                    `title_en` varchar(255) NOT NULL DEFAULT '' COMMENT '英文标题',
                    `flags` varchar(100) NOT NULL DEFAULT '' COMMENT '自定义属性',
                    `tags` varchar(255) NOT NULL DEFAULT '' COMMENT 'TAG标签',
                    `thumb` varchar(100) NOT NULL DEFAULT '' COMMENT '缩略图',
                    `source` varchar(255) NOT NULL DEFAULT '' COMMENT '来源',
                    `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
                    `writer` varchar(255) NOT NULL DEFAULT '' COMMENT '作者',
                    `keywords` varchar(255) NOT NULL DEFAULT '' COMMENT '关键词',
                    `description` text DEFAULT NULL COMMENT '描述',
                    `content` text DEFAULT NULL COMMENT '内容',
                    `view` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '浏览量',
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
            } else {
                $sql = <<<sql
                CREATE TABLE IF NOT EXISTS `{$table_name}` (
                    `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                    PRIMARY KEY (`id`)
                )
                ENGINE={$model_info['engine_type']}
                DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci COMMENT='{$model_info['title']}'
                CHECKSUM=0
                ROW_FORMAT=DYNAMIC
                DELAY_KEY_WRITE=0
                ;
sql;
            }
        } else { //创建表的id不是主键
            if ($model_info['extend'] == 0) { //判断是否是独立模型，是
                // 增加非主键id字段、增加category_id(栏目表的id)字段、增加标题title字段、增加英文标题title_en字段、
                // 增加自定义属性flags字段、增加TAG标签tags字段、增加缩略图thumb字段、增加来源source字段
                // 增加uid(管理员ID)字段、增加作者writer字段、增加关键词keywords字段、增加描述description字段
                // 增加内容content字段、增加浏览量view字段
                // 增加状态status字段、增加排序sort字段、增加创建时间create_time字段、增加修改时间update_time字段
                $sql = <<<sql
                CREATE TABLE IF NOT EXISTS `{$table_name}` (
                    `id` int(10) UNSIGNED UNIQUE NOT NULL COMMENT '非主键ID',
                    `category_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '所属分类ID',
                    `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
                    `title_en` varchar(255) NOT NULL DEFAULT '' COMMENT '英文标题',
                    `flags` varchar(100) NOT NULL DEFAULT '' COMMENT '自定义属性',
                    `tags` varchar(255) NOT NULL DEFAULT '' COMMENT 'TAG标签',
                    `thumb` varchar(100) NOT NULL DEFAULT '' COMMENT '缩略图',
                    `source` varchar(255) NOT NULL DEFAULT '' COMMENT '来源',
                    `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '管理员ID',
                    `writer` varchar(255) NOT NULL DEFAULT '' COMMENT '作者',
                    `keywords` varchar(255) NOT NULL DEFAULT '' COMMENT '关键词',
                    `description` text DEFAULT NULL COMMENT '描述',
                    `content` text DEFAULT NULL COMMENT '内容',
                    `view` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '浏览量',
                    `status` char(50) NOT NULL DEFAULT '1' COMMENT '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)',
                    `sort` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
                    `create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
                    `update_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时间'
                )
                ENGINE={$model_info['engine_type']}
                DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci COMMENT='{$model_info['title']}'
                CHECKSUM=0
                ROW_FORMAT=DYNAMIC
                DELAY_KEY_WRITE=0
                ;
sql;
            } else {
                $sql = <<<sql
                CREATE TABLE IF NOT EXISTS `{$table_name}` (
                    `id` int(10) UNSIGNED UNIQUE NOT NULL COMMENT '非主键ID'
                )
                ENGINE={$model_info['engine_type']}
                DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci COMMENT='{$model_info['title']}'
                CHECKSUM=0
                ROW_FORMAT=DYNAMIC
                DELAY_KEY_WRITE=0
                ;
sql;
            }
        }
        $db = Db::connect();//连接数据库
        $res = $db->execute($sql);//创建表
        if ($res !== false) {
            // 判断模型字段表是否有此字段即id字段
            $map[] = ['model_id', '=', $model_id];
            $map[] = ['name', '=', 'id'];
            $field_exist = Db::name('attribute')->where($map)->find();
            // 处理id字段
            if (!$field_exist) { //字段表attribute未有该模型对应表的字段id，字段表新增id字段
                if ($model_info['need_pk']) { //id注释是主键
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 2, 'name' => 'id', 'title' => '主键ID', 'field' => 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'type' => 'num', 'remark' => '主键ID', 'is_show' => 0, 'create_time' => time(), 'update_time' => time(), 'sort' => 100]);
                } else { //id注释是非主键
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 2, 'name' => 'id', 'title' => '非主键ID', 'field' => 'int(10) UNSIGNED UNIQUE NOT NULL', 'type' => 'num', 'remark' => '非主键ID', 'is_show' => 0, 'create_time' => time(), 'update_time' => time(), 'sort' => 100]);
                }
            } else { //字段表attribute已有该模型对应表的字段id,对字段表的id进行修改
                if ($model_info['need_pk']) { //把id注释为主键
                    Db::name('attribute')->where($map)->update(['group_id' => 2, 'title' => '主键ID', 'field' => 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'type' => 'num', 'remark' => '主键ID', 'update_time' => time()]);
                } else { //把id注释为非主键
                    Db::name('attribute')->where($map)->update(['group_id' => 2, 'title' => '非主键ID', 'field' => 'int(10) UNSIGNED UNIQUE NOT NULL', 'type' => 'num', 'remark' => '非主键ID', 'update_time' => time()]);
                }
            }
            // 判断是否是独立模型如果是增加category_id、title、create_time、update_time、status字段
            if ($model_info['extend'] == 0) {
                // 判断栏目category_id是否存在
                $category_id_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'category_id']])->find();
                if (!$category_id_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'category_id', 'title' => '所属分类ID', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'num', 'value' => '0', 'is_show' => 0, 'remark' => '所属分类ID', 'create_time' => time(), 'update_time' => time(), 'sort' => 90]);
                }
                // 判断标题title是否存在
                $title_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'title']])->find();
                if (!$title_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'title', 'title' => '标题', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'string', 'is_must' => 1, 'remark' => '标题', 'create_time' => time(), 'update_time' => time(), 'sort' => 80]);
                }
                // 判断英文标题title_en是否存在
                $title_en_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'title_en']])->find();
                if (!$title_en_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'title_en', 'title' => '英文标题', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'string', 'is_must' => 0, 'remark' => '英文标题', 'create_time' => time(), 'update_time' => time(), 'sort' => 80]);
                }
                // 判断自定义属性flags是否存在
                $flags_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'flags']])->find();
                if (!$flags_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'flags', 'title' => '自定义属性', 'field' => "varchar(100) NOT NULL DEFAULT ''", 'type' => 'checkbox', 'is_must' => 0, 'remark' => '自定义属性', 'extra'=>'h:头条,c:推荐,f:幻灯,a:特荐,s:滚动,b:加粗,p:图片,j:跳转;','create_time' => time(), 'update_time' => time(), 'sort' => 70]);
                }
                // 判断TAG标签tags是否存在
                $tags_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'tags']])->find();
                if (!$tags_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'tags', 'title' => 'TAG标签', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'tags', 'is_must' => 0, 'remark' => 'TAG标签', 'create_time' => time(), 'update_time' => time(), 'sort' => 60]);
                }
                // 判断缩略图thumb是否存在
                $thumb_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'thumb']])->find();
                if (!$thumb_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'thumb', 'title' => '缩略图', 'field' => "varchar(100) NOT NULL DEFAULT ''", 'type' => 'picture', 'is_must' => 0, 'remark' => '缩略图', 'create_time' => time(), 'update_time' => time(), 'sort' => 50]);
                }
                // 判断来源source是否存在
                $source_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'source']])->find();
                if (!$source_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'source', 'title' => '来源', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'string', 'is_must' => 0, 'remark' => '来源', 'create_time' => time(), 'update_time' => time(), 'sort' => 40]);
                }
                // 判断uid管理员ID是否存在
                $uid_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'uid']])->find();
                if (!$uid_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'uid', 'title' => '管理员ID', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'num', 'value' => '0', 'is_show' => 0, 'remark' => '管理员ID', 'create_time' => time(), 'update_time' => time(), 'sort' => 30]);
                }
                // 判断作者writer是否存在
                $writer_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'writer']])->find();
                if (!$writer_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'writer', 'title' => '作者', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'string', 'is_must' => 0, 'remark' => '作者', 'create_time' => time(), 'update_time' => time(), 'sort' => 29]);
                }
                // 判断关键词keywords是否存在
                $keywords_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'keywords']])->find();
                if (!$keywords_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'keywords', 'title' => '关键词', 'field' => "varchar(255) NOT NULL DEFAULT ''", 'type' => 'string', 'is_must' => 0, 'remark' => '关键词', 'create_time' => time(), 'update_time' => time(), 'sort' => 28]);
                }
                // 判断描述description是否存在
                $description_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'description']])->find();
                if (!$description_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'description', 'title' => '描述', 'field' => "text DEFAULT NULL", 'type' => 'textarea', 'is_must' => 0, 'remark' => '描述', 'create_time' => time(), 'update_time' => time(), 'sort' => 27]);
                }
                // 判断内容content是否存在
                $content_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'content']])->find();
                if (!$content_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'content', 'title' => '内容', 'field' => "text DEFAULT NULL", 'type' => 'editor', 'is_must' => 0, 'remark' => '内容', 'create_time' => time(), 'update_time' => time(), 'sort' => 26]);
                }
                // 判断浏览量view是否存在
                $view_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'view']])->find();
                if (!$view_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'view', 'title' => '浏览量', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'num', 'value' => '0', 'is_show' => 1, 'remark' => '浏览量', 'create_time' => time(), 'update_time' => time(), 'sort' => 25]);
                }
                // 判断状态status是否存在
                $status_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'status']])->find();
                if (!$status_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'status', 'title' => '状态', 'field' => "char(50) NOT NULL DEFAULT '1'", 'type' => 'select', 'value' => '1', 'extra' => "-1:删除,0:隐藏,1:显示,2:待审核,3:草稿", 'remark' => '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)', 'create_time' => time(), 'update_time' => time(), 'sort' => 24]);
                }
                // 判断排序sort是否存在
                $sort_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'sort']])->find();
                if (!$sort_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'sort', 'title' => '排序', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'num', 'value' => '0', 'remark' => '排序', 'create_time' => time(), 'update_time' => time(), 'sort' => 23]);
                }
                // 判断创建时间create_time是否存在
                $create_time_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'create_time']])->find();
                if (!$create_time_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'create_time', 'title' => '创建时间', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'datetime', 'value' => '0', 'is_show' => 3, 'remark' => '创建时间', 'create_time' => time(), 'update_time' => time(), 'sort' => 22]);
                }
                // 判断修改时间update_time是否存在
                $update_time_exist = Db::name('attribute')->where([['model_id', '=', $model_id], ['name', '=', 'update_time']])->find();
                if (!$update_time_exist) {
                    Db::name('attribute')->insert(['model_id' => $model_id, 'group_id' => 1, 'name' => 'update_time', 'title' => '更新时间', 'field' => "int(10) UNSIGNED NOT NULL DEFAULT '0'", 'type' => 'datetime', 'value' => '0', 'is_show' => 0, 'remark' => '更新时间', 'create_time' => time(), 'update_time' => time(), 'sort' => 21]);
                }
            }
        }
        return $res !== false;
    }
}