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
// | 碎片位验证器
// +----------------------------------------------------------------------
namespace app\admin\validate\cms;

use think\Validate;

class DebrisPos extends Validate
{
	protected $rule = [
		'name' => 'require|max:64|unique:adtype',
		'description' => 'max:255',
		'sort' => 'require|number|between:0,99999',
	];
	protected $message = [
		'name.require' => '碎片位名称必须填写',
		'name.max' => '碎片位名称最多不能超过64个字符',
		'name.unique' => '碎片位名称已经存在',
		'description.max' => '描述内容最多不能超过255个字符',
		'sort.require' => '排序值必须填写',
		'sort.number' => '排序值必须是数字',
		'sort.max' => '排序值过大',
	];
	protected $scene = [
		'add' => ['name', 'description', 'sort'],
		'edit' => ['name', 'description', 'sort'],
	];
}
