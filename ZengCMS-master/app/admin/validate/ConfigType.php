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
// | 配置类型验证器
// +----------------------------------------------------------------------
namespace app\admin\validate;

use think\Validate;

class ConfigType extends Validate
{
	protected $rule = [
		'config_type_name' => 'require|max:60|unique:config_type',
		'description' => 'max:255',
		'status' => 'require|in:0,1',
		'sort' => 'require|number',
	];
	protected $message = [
		'config_type_name.require' => '配置类型名称必须填写',
		'config_type_name.max' => '配置类型名称最多不能超过60个字符',
		'config_type_name.unique' => '配置类型名称已经存在',
		'description.max' => '描述最多不能超过255个字符',
		'status.require' => '状态必须选择',
		'status.in' => '状态必须是0或1',
		'sort.require' => '排序必须填写',
		'sort.number' => '排序必须是数字',
	];
	protected $scene = [
		'add' => ['config_type_name', 'description', 'status', 'sort'],
		'edit' => ['config_type_name', 'description', 'status', 'sort'],
	];
}
