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
// | 管理员验证器
// +----------------------------------------------------------------------
namespace app\admin\validate;

use think\Validate;

class Admin extends Validate
{
	protected $rule = [
		'name' => 'require|max:60|unique:admin',
		'relname' => 'require|max:32',
		'password' => 'require|min:6|max:32',
		'confirm_password' => 'require|confirm:password',
		'phone' => 'mobile',
		'email' => 'email',
		'sex' => 'require|in:1,2',
		'status' => 'in:1,0',
		'sort' => 'number|between:0,99999',
	];
	protected $message = [
		'name.require' => '管理员账号必须填写',
		'name.max' => '管理员账号最多不能超过60个字符',
		'name.unique' => '管理员账号已经存在',
		'relname.require' => '真实名称必须填写',
		'relname.max' => '真实名称过长',
		'password.require' => '密码必须填写',
		'password.min' => '密码长度不能少于6个字符',
		'password.max' => '密码最多不能超过32个字符',
		'confirm_password.require' => '请输入确认密码',
		'confirm_password.confirm' => '两次密码不一致',
		'phone.mobile' => '手机号码不正确',
		'email.email' => '邮箱格式不正确',
		'sex.require' => '请选择性别',
		'sex.in' => '性别选择有误',
		'status.in' => '状态选择有误',
		'sort.number' => '排序值必须是数值',
		'sort.between' => '排序值过大',
	];
	protected $scene = [
		'add' => ['name', 'relname', 'password', 'confirm_password', 'phone', 'email', 'sex', 'status', 'sort'],
		'edit' => ['name', 'relname', 'phone', 'email', 'sex', 'status', 'sort'],
	];
}
