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
// | 后台清除统计控制器
// +----------------------------------------------------------------------
declare (strict_types = 1);

namespace app\admin\middleware;

class Crstat
{
    /**
     * [handle 后台清理统计-后置中间件]
     * @param [type] $request
     * @param \Closure $next
     * @return void
     */
    public function handle($request, \Closure $next)
    {
        $response = $next($request);
        // 添加中间件执行代码
        
        // 开始清理
        hook('ClearStats');

        return $response;
    }
}
?>