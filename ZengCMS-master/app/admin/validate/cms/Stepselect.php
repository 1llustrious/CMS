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
// | 联动类别证器
// +----------------------------------------------------------------------
namespace app\admin\validate\cms;

use think\Validate;

class Stepselect extends Validate
{
    protected $rule = [
        'title' => 'require|max:255',
        'sort' => 'require|number',
    ];
    protected $message = [
        'title.require' => '组类别名必须填写',
        'title.max' => '组类别名最多不能超过255个字符',
        'sort.require' => '排序必须填写',
        'sort.number' => '排序必须是数字',
    ];
    protected $scene = [
        'add' => ['title', 'sort'],
        'edit' => ['title', 'sort'],
    ];
}
