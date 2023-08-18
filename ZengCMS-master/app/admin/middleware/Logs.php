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
// | 管理员操作记录
// +----------------------------------------------------------------------
declare (strict_types = 1);

namespace app\admin\middleware;

use think\facade\Db;
use think\facade\Config;
use think\facade\Request;

class Logs
{
    /**
     * [Description 记录行为日志-前置中间件]
     * @DateTime 2020-04-21 17:46:04
     * @param [type] $request
     * @param \Closure $next
     * @return void
     */
    public function handle($request, \Closure $next)
    {
        // 添加中间件执行代码
        
        // 判断是否记录行为日志
        if(get_one_cache_config('is_recording_behavior_log')){
            // 获取当前应用名
            $m = app('http')->getName();
            // 获取当前访问的控制器
            $c = Request::controller();
            // 获取当前访问的方法
            $a = Request::action();
            if(!$c && !$a){
                $url = request()->url();
                $parse = parse_url($url);
                $path = $parse['path'];
                $path_arr = explode('/',$path);
                $path_arr = array_values(array_filter($path_arr));
                $num = count($path_arr);
                if($num == 3){
                    $c = $this->convertUnderline($path_arr[1]);
                    $_a = explode('.',$path_arr[2]);
                    $a = $_a[0];
                    $data['url'] = $m."/".$c."/".$a;
                }else{
                    $data['url'] = $url;
                }
            }else{
                $data['url'] = $m."/".$c."/".$a;   
            }
            $uid = is_login();
            $data['operator']=$uid>0?$uid:0;
            // 获取admin/config/logs.php配置里面的所有信息(array)
            $logs = Config::get("logs");
            if(isset($logs[$data['url']])){
                $description = $logs[$data['url']];
            }else{
                // $description = Db::name("auth_rule")->where("name",$data['url'])->value("title");
                $description = Db::name("auth_rule")->where([['name','like',$data['url'].'%']])->value("title");
            }
            $data['description']=$description?$description:"未知";
            $data['operate_time']=time();
            $data['operate_ip']=request()->ip();
            $data['operate_area']=ip_IpLocation($data['operate_ip']);
            // 以下数组中的不用记录
            $not_insert_logs = Config::get("logs.not_insert_logs");
            if(!in_array($data['url'],$not_insert_logs)){
                Db::name('logs')->insert($data);   
            }
        }

        return $next($request);
    }
    /**
     * [Description 将下划线命名转换为驼峰式命名]
     * @DateTime 2020-04-23 13:02:06
     * @param [type] $str
     * @param boolean $ucfirst
     * @return void
     */
    private function convertUnderline($str,$ucfirst = true)
    {
        while(($pos = strpos($str , '_'))!==false){
            $str = substr($str , 0 , $pos).ucfirst(substr($str , $pos+1));
        }
        return $ucfirst ? ucfirst($str) : $str;
    }
}