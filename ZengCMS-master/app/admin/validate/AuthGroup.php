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
// | 角色(用户组)验证器
// +----------------------------------------------------------------------
namespace app\admin\validate;

use think\Validate;

class AuthGroup extends Validate
{
	protected $rule = [
		'title' => 'require|max:100|unique:auth_group',
		'remark' => 'max:255',
		'status' => 'require|in:1,0',
		'sort' => 'require|number',
	];
	protected $message = [
		'title.require' => '角色中文名称不能为空',
		'title.max' => '角色中文名称太长',
		'title.unique' => '角色中文名称已经存在',
		'remark.max' => '说明太长',
		'status.require' => '状态必须选择！',
		'status.in' => '状态必须是0或1',
		'sort.require' => '排序必须填写！',
		'sort.number' => '排序值必须是数字',
	];
	protected $scene = [
		'add' => ['title', 'remark', 'status', 'sort'],
		'edit' => ['title', 'remark', 'status', 'sort'],
	];
}
