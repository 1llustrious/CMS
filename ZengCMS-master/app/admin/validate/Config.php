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
// | 配置验证器
// +----------------------------------------------------------------------
namespace app\admin\validate;

use think\Validate;

class Config extends Validate
{
	protected $rule = [
		'cname' => 'require|max:32|unique:config',
		'ename' => 'require|max:32|unique:config',
		'form_type' => 'require|in:input,tags,array,markdown,colorpicker,datetime,selects,selecto,map,region,radio,checkbox,select,textarea,file,editor,picture,piclist,onefile,filelist,onevideo,videolist',
		'config_type_id' => 'require|number',
		'values' => 'max:255',
		'value' => 'max:255',
		'remark' => 'max:255',
		'is_core_configuration' => 'require|in:0,1',
		'status' => 'require|in:0,1',
		'sort' => 'require|number',
	];
	protected $message = [
		'cname.require' => '配置中文名称必须填写',
		'cname.max' => '配置中文名称最多不能超过32个字符',
		'cname.unique' => '配置中文名称已经存在',
		'ename.require' => '配置英文名称必须填写',
		'ename.max' => '配置英文名称最多不能超过32个字符',
		'ename.unique' => '配置英文名称已经存在',
		'form_type.require' => '表单类型必须选择！',
		'form_type.in' => '表单类型选择有误！',
		'config_type_id.require' => '配置类型必须选择！',
		'config_type_id.number' => '配置类型选择有误！',
		'values.max' => '可选值最多不能超过255个字符',
		'value.max' => '默认值最多不能超过255个字符',
		'remark.max' => '配置说明最多不能超过255个字符',
		'is_core_configuration.require' => '核心配置必须选择！',
		'is_core_configuration.in' => '核心配置必须是0或1',
		'status.require' => '状态必须选择！',
		'status.in' => '状态必须是0或1',
		'sort.require' => '排序必须填写！',
		'sort.number' => '排序值必须是数字',
	];
	protected $scene = [
		'add' => ['cname', 'ename', 'form_type', 'config_type_id', 'values', 'value', 'remark', 'is_core_configuration', 'status', 'sort'],
		'edit' => ['cname', 'ename', 'form_type', 'config_type_id', 'values', 'value', 'remark', 'is_core_configuration', 'status', 'sort'],
	];
}
