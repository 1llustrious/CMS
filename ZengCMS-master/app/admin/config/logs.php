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
// | 管理员行为日志
// +----------------------------------------------------------------------
return [
    'admin/Login/index' => '后台登录',
    'admin/Common/verify' => '登录验证码',
    'admin/Admin/logout' => '退出登录',
    'admin/Base/clear_static' => '清除缓存',
    'admin/Base/clear_static' => '清除静态',
    'admin/Base/menu' => '菜单接口',
    // 不用记录
    'not_insert_logs' => [
        'admin/Logs/index',
        '/admin/login.php'
    ],
];
