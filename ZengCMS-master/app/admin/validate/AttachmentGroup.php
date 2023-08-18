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
// | 附件分组验证器
// +----------------------------------------------------------------------
namespace app\admin\validate;

use think\Validate;

class AttachmentGroup extends Validate
{
	protected $rule = [
		'name' => 'require|max:32|unique:attachment_group',
		'sort' => 'require|number',
	];
	protected $message = [
		'name.require' => '名称必须填写',
		'name.max' => '名称最多不能超过60个字符',
		'name.unique' => '名称已经存在',
		'sort.require' => '排序必须填写',
		'sort.number' => '排序必须是数字',
	];
	protected $scene = [
		'add' => ['name', 'sort'],
		'edit' => ['name', 'sort'],
	];
}
