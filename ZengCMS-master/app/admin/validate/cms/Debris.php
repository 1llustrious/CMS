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
// | 碎片验证器
// +----------------------------------------------------------------------
namespace app\admin\validate\cms;

use think\Validate;

class Debris extends Validate
{
	protected $rule = [
		'title' => 'require|max:60',
		'posid' => 'require|number',
		'status' => 'require|in:0,1',
		'sort' => 'require|number|between:0,99999',
	];
	protected $message = [
		'title.require' => '碎片标题必须填写',
		'title.max' => '碎片标题最多不能超过60个字符',
		'posid.require' => '请选择所属碎片位',
		'posid.number' => '选择所属碎片位有误',
		'status.require' => '请选择状态',
		'status.in' => '状态选择有误',
		'sort.require' => '排序值必须填写',
		'sort.number' => '排序值必须是数字',
		'sort.max' => '排序值过大',
	];
	protected $scene = [
		'add' => ['title', 'posid', 'status', 'sort'],
		'edit' => ['title', 'posid', 'status', 'sort'],
	];
}
