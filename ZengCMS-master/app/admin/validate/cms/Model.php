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
// | 模型验证器
// +----------------------------------------------------------------------
namespace app\admin\validate\cms;

use think\Validate;

class Model extends Validate
{
    protected $rule = [
        'title' => 'require|max:100|unique:model',
        'name' => 'require|max:100|unique:model',
        'extend' => 'require|in:0,1',
        'sort' => 'require|number',
    ];
    protected $message = [
        'title.require' => '模型名称必须填写',
        'title.unique' => '模型名称已经存在',
        'title.max' => '模型名称最多不能超过100个字符',
        'name.require' => '模型标识必须填写',
        'name.unique' => '模型标识已经存在',
        'name.max' => '模型标识最多不能超过100个字符',
        'extend.require' => '模型性质必须选择',
        'extend.in' => '模型性质选择有误',
        'sort.require' => '排序必须填写',
        'sort.number' => '排序必须是数字',
    ];
    protected $scene = [
        'add' => ['title', 'name', 'extend', 'sort'],
        'edit' => ['title', 'name', 'extend', 'sort'],
    ];
}
