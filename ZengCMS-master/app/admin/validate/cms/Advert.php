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
// | 广告验证器
// +----------------------------------------------------------------------
namespace app\admin\validate\cms;

use think\Validate;

class Advert extends Validate
{
	protected $rule = [
		'name' => 'require|max:60',
		'typeid' => 'require|number',
		'status' => 'require|in:0,1',
		'sort' => 'require|number|between:0,99999',
	];
	protected $message = [
		'name.require' => '广告名称必须填写',
		'name.max' => '广告名称最多不能超过60个字符',
		'typeid.require' => '请选择所属广告位',
		'typeid.number' => '选择所属广告位有误',
		'status.require' => '请选择状态',
		'status.in' => '状态选择有误',
		'sort.require' => '排序值必须填写',
		'sort.number' => '排序值必须是数字',
		'sort.max' => '排序值过大',
	];
	protected $scene = [
		'add' => ['name', 'typeid', 'status', 'sort'],
		'edit' => ['name', 'typeid', 'status', 'sort'],
	];
}
