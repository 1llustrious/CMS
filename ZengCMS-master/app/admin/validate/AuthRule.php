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
// | 菜单(规则)验证器
// +----------------------------------------------------------------------
namespace app\admin\validate;

use think\Validate;

class AuthRule extends Validate
{
    protected $rule = [
        // 'title' => 'require|max:20|unique:auth_rule',
        'title' => 'require|max:20',
        'name' => 'require|max:255|unique:auth_rule',
        'pid' => 'require|number',
        'status' => 'require|in:1,0',
        'show' => 'require|in:1,0',
        'icon' => 'max:25',
        'remark' => 'max:255',
        'sort' => 'require|number',
    ];
    protected $message = [
        'title.require' => '菜单中文名称不能为空',
        'title.max' => '菜单中文名称太长',
        'title.unique' => '菜单中文名称已经存在',
        'name.require' => '菜单url地址不能为空',
        'name.max' => '菜单url地址太长',
        'name.unique' => '菜单url地址已经存在',
        'pid.require' => '上级菜单不能为空',
        'pid.number' => '上级菜单值必须是数字',
        'status.require' => '状态必须选择！',
        'status.in' => '状态必须是0或1',
        'show.require' => '菜单显示状态必须选择！',
        'show.in' => '菜单显示状态值必须是0或1',
        'icon.max' => '图标太长',
        'remark.max' => '说明太长',
        'sort.require' => '排序必须填写！',
        'sort.number' => '排序值必须是数字',
    ];
    protected $scene = [
        'add' => ['title', 'name', 'pid', 'status', 'show', 'icon', 'remark', 'sort'],
        'edit' => ['title', 'name', 'pid', 'status', 'show', 'icon', 'remark', 'sort'],
    ];
}
