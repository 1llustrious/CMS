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
// | 栏目验证器
// +----------------------------------------------------------------------
namespace app\admin\validate\cms;

use think\Validate;

class Arctype extends Validate
{
    protected $rule = [
        'typename' => 'require|max:150|unique:arctype',
        'name' => 'require|notName|max:255|unique:arctype',
        // 'description' => 'max:255',
        // 'status' => 'require|in:0,1',
        'sort' => 'require|number',
    ];
    protected $message = [
        'typename.require' => '栏目名称必须填写',
        'typename.max' => '栏目名称最多不能超过150个字符',
        'typename.unique' => '栏目名称已经存在',
        'name.require' => '栏目标识必须填写',
        'name.max' => '栏目标识最多不能超过255个字符',
        'name.unique' => '栏目标识已经存在',
        // 'description.max' => '描述最多不能超过255个字符',
        // 'status.require' => '状态必须选择',
        // 'status.in' => '状态必须是0或1',
        'sort.require' => '排序必须填写',
        'sort.number' => '排序必须是数字',
    ];
    protected $scene = [
        'add' => ['typename', 'name', 'sort'],
        'edit' => ['typename', 'name', 'sort'],
    ];
    /**
     * [notName 自定义-不能设置的标识-的验证规则]
     * 验证方法可以传入的参数共有5个（后面三个根据情况选用），依次为：
     * @param  [type]  $value [验证数据]
     * @param  string  $rule  [验证规则]
     * @param  string  $data  [全部数据（数组）]
     * @param  string  $field [字段名]
     * @param  string  $title [字段描述]
     * 自定义的验证规则方法名不能和已有的规则冲突。
     * @return boolean        [description]
     */
    protected function notName($value, $rule, $data = [], $field = '', $title = '')
    {
        $not_name = ['addons','app','config','data','extend','install','public','route',
        'runtime','vendor','view','.env','.htaccess','.travis.yml','composer.json','composer.lock',
        'index.php','install.lock','index.php','sitemap.html','sitemap.xml','sitemap.txt','think'];
        if (in_array($value,$not_name)) {
            return $field . '标识设置有误！';
        } else {
            return true;
        }
    }
}
