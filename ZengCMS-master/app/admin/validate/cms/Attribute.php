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
// | 模型字段验证器
// +----------------------------------------------------------------------
namespace app\admin\validate\cms;

use think\Validate;

class Attribute extends Validate
{
	protected $rule = [
		'title' => 'require|max:100',
		'name' => 'require|max:32',
		'field' => 'require|max:100',
		'remark' => 'max:100',
		'model_id' => 'require|number',
		// 'status' => 'require|in:0,1',
		'sort' => 'require|number',
	];
	protected $message = [
		'title.require' => '字段标题必须填写',
		'title.max' => '字段标题最多不能超过100个字符',
		'name.require' => '字段名称必须填写',
		'name.max' => '字段名称最多不能超过32个字符',
		'field.require' => '字段定义不能为空',
		'field.max' => '字段定义最多不能超过100个字符',
		'remark.max' => '字段备注最多不能超过100个字符',
		// 'status.require' => '状态必须选择',
		// 'status.in' => '状态必须是0或1',
		'model_id.require' => '未绑定模型',
		'model_id.number' => '绑定的模型值有误',
		'sort.require' => '排序必须填写',
		'sort.number' => '排序必须是数字',
	];
	protected $scene = [
		'add' => ['title', 'name', 'field', 'remark', 'model_id', 'sort'],
		'edit' => ['title', 'name', 'field', 'remark', 'model_id', 'sort'],
	];
}
