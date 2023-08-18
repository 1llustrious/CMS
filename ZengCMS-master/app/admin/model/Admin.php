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
// | admin管理员模型
// +----------------------------------------------------------------------
namespace app\admin\model;

use think\Model;
use think\facade\Db;
use think\facade\Session;
use think\facade\Cookie;

class Admin extends Model
{
    /**
     * 用户登录认证
     * @param  string $username 用户名
     * @param  string $password 用户密码
     * @param  integer $rememberMe 记住密码 （0-不记住，1-记住）
     * @param  integer $type       用户名类型 （1-用户名，2-邮箱，3-手机，4-UID）
     * @return integer             登录成功-用户ID，登录失败-错误编号
     */
    public function login($username, $password, $rememberMe=0, $type = 1)
    {
        $map = array();
        switch ($type) {
            case 1:
                $map[] = ['name', '=', $username];
                break;
            case 2:
                $map[] = ['email', '=', $username];
                break;
            case 3:
                $map[] = ['phone', '=', $username];
            case 4:
                $map[] = ['id', '=', $username];
            default:
                return 0;//未知错误
        }
        //获取用户数据
        $admin = $this->where($map)->find();
        //密码错误超过次数及以上的
        if ($admin['error_logins'] >= get_one_config('ERROR_LOGINS')) {
            //最后错误时间距离现在未超过某段时间的(禁止登录)
            if (time() - $admin['error_login_time'] < get_one_config('ERROR_TIME_DUAN')) {
                return -3;//操作频繁，请稍后再登录！
            } else {
                //最后错误时间距离现在超过后台设置时间的把错误次数改为0，时间改为0
                Db::name('admin')->where('id', $admin['id'])->update(['error_logins' => 0, 'error_login_time' => 0]);
            }
        }
        if ($admin && $admin['status']) {
            if (md6($password) == $admin['password']) {
                //登录成功生成随机数
                $random_number = mt_rand(10000, 99999);
                //更新用户登录信息
                $this->updateLogin($admin['id'], $random_number);
                /* 记录登录SESSION和COOKIES */
                $auth = array(
                    'uid' => $admin['id'], //管理员ID
                    'username' => $admin['name'],//登录用户名
                    'relname' => $admin['relname'],//真实名称
                    'last_login_time' => $admin['last_login_time'],//最后登录时间
                    'random_number' => $random_number,//登录成功随机数
                    //加密后台设置的NO_OPERATE_TIME秒，如果是0或不填就是永久
                    'online_state' => think_encrypt($admin['name'], '', get_one_config('NO_OPERATE_TIME')),
                    'rememberMe'=>$rememberMe,//记住密码
                );
                //记住密码
                if($rememberMe){
                    $day = get_one_cache_config('WEB_ADMIN_REMEMBER_ME');
                    $time = $day*24*60*60;
                    cookie('admin_auth_cookie',think_encrypt(serialize($auth)),$time);
                }else{
                    session('admin_auth', $auth);
                }
                return $admin['id']; //登录成功，返回用户ID
            } else {
                //登录错误次数加1，最后错误登录时间改为现在
                Db::name('admin')->where('id', $admin['id'])->update(['error_logins' => Db::raw('error_logins+1'), 'error_login_time' => time()]);
                return -2; // 密码错误
            }
        } else {
            return -1;  // 用户名不存在或禁用
        }
	}
	/**
     * [updateLogin 更新用户登录信息]
     * @param [type] $uid 管理员ID
     * @param [type] $random_number 随机数
     * @return void
     */
    private function updateLogin($uid, $random_number)
    {
        $admin = $this::where('id', $uid)->find();
        $admin->success_logins = Db::raw('success_logins+1'); //成功登录次数加1
        $admin->random_number = $random_number; //成功登录随机数
        $admin->last_login_time = time(); //登录时间
        $admin->error_logins = 0; //错误登录次数改为0
        $admin->error_login_time = 0; //错误时间改为0
        $admin->last_login_ip = get_client_ip(0); //登录ip
        $admin->save();
	}
	/**
     * [logout 注销当前用户]
     * @return void
     */
    public function logout()
    {
        Cookie::delete('admin_auth_cookie');
        // 删除session
        Session::delete('admin_auth');
        Session::clear();
        return true;
    }
}