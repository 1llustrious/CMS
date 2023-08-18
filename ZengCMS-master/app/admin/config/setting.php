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
// | setting配置
// +----------------------------------------------------------------------
return [
    // 权限类型：1：Auth，2：Node，3：Auth+Node
    'permission_type'=>1,
    // Auth权限配置
    'auth_config'=>[
        'auth_on' => true,//认证开关
		'auth_type' => 1,//认证方式，1为实时认证；2为登录认证。
		'auth_group' => 'auth_group',//用户组数据表名
		'auth_group_access' => 'auth_group_access',//用户-用户组关系表
		'auth_rule' => 'auth_rule',//权限规则表
		'auth_user' => 'admin',//用户信息表
    ],
    // 不需要验证登录的控制器
    'no_login_controller' => [
        'login',
    ],
    // 不需要验证登录的节点
    'no_login_node'       => [
        'login/index',
    ],
    // 不需要验证权限的控制器
    'no_auth_controller'  => [
        'login',
        'common',
        'index',
    ],
    // 不需要验证权限的节点
    'no_auth_node'        => [
        'base/menu',
        'base/clear_cache',
        'base/clear_static',
        'base/ajaxGetCity',
        'base/get_city',
        'admin/logout'
    ],
    // 快递鸟官网：http://www.kdniao.com/
    // 快递鸟-商户ID
    'EBusinessID'=>'1381194',
    // 快递鸟-API key
    'AppKey'=>'fb7a2906-cd4d-4e4b-ad8a-38ec69c34e84',
    // 电子面单请求URL
    'miandan_ReqURL'=>'http://testapi.kdniao.cc:8081/api/Eorderservice',
    // 查询请求URL
    'chaxun_ReqURL'=>'http://api.kdniao.cc/Ebusiness/EbusinessOrderHandle.aspx',
];
