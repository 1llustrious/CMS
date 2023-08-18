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
// | 友链验证器
// +----------------------------------------------------------------------
namespace app\admin\validate\cms;

use think\Validate;

class Links extends Validate
{
	protected $rule = [
		'typeid' => 'require|number',
		'url' => 'require|max:60',
		'name' => 'require|max:60',
		'description' => 'max:255',
		'status' => 'require|in:0,1',
		'sort' => 'require|number|between:0,99999',
	];
	protected $message = [
		'typeid.require' => '友链类型必须选择',
		'typeid.number' => '友链类型选择有误',
		'url.require' => '链接地址必须填写',
		'url.max' => '链接地址太长',
		'description.max' => '描述内容太长',
		'status.require' => '请选择状态',
		'status.in' => '状态选择有误',
		'sort.require' => '排序值必须填写',
		'sort.number' => '排序值必须是数字',
		'sort.max' => '排序值过大',
	];
	protected $scene = [
		'add' => ['typeid', 'url', 'name', 'content', 'status', 'sort'],
		'edit' => ['typeid', 'url', 'name', 'content', 'status', 'sort'],
	];
}
