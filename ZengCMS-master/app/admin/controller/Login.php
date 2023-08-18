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
// | 后台admin登录控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\Request;
use app\admin\model\Admin;

class Login extends Base
{
    // 初始化
    public function initialize()
    {
        parent::initialize();
    }
    /**
     * [index 后台登录]
     * @param Request $request
     * @return void
     */
    public function index(Request $request)
    {
        if (request()->isAjax()) {
            $data = input('post.');
            $check = $request->checkToken('__token__', $request->param());
            if(false === $check) {
                config('logs.admin/Login/index', '后台登录-invalid token');
                return json(['code' => 0, 'msg' =>'invalid token', 'url' => (string)url('admin_login')]);
            }
            // 验证码验证
            if (!captcha_check($data['verify'])) {
                config('logs.admin/Login/index', '后台登录-验证码错误！');
                return json(['code' => 0, 'msg' => '验证码错误！', 'url' => (string)url('admin_login')]);
            };
            $admin = new Admin();
            // 判断是否记住密码
            $rememberMe = isset($data['rememberMe']) ? 1 : 0;
            $uid = $admin->login($data['name'], $data['password'], $rememberMe); //登录
            if ($uid > 0) {
                config('logs.admin/Login/index', '后台登录-登录成功！');
                return json(['code' => 1, 'msg' => '登录成功！', 'url' => (string)url('Index/index')]);
            } else {
                switch ($uid) {
                    case -1:
                        config('logs.admin/Login/index', '后台登录-用户不存在或被禁用！');
                        $error = '用户不存在或被禁用！';
                        break;
                    case -2:
                        config('logs.admin/Login/index', '后台登录-密码错误！');
                        $error = '密码错误！';
                        break;
                    case -3:
                        config('logs.admin/Login/index', '后台登录-操作频繁，请稍后再登录！');
                        $error = '操作频繁，请稍后再登录！';
                        break;
                    default:
                        config('logs.admin/Login/index', '后台登录-未知错误！');
                        $error = '未知错误！';
                        break;
                }
                return json(['code' => 0, 'msg' => $error, 'url' => '']);
            }
        }
        if (is_login() > 0) {
            return redirect('Index/index');
        }
        return view('index',[
            'meta_title' => '后台登录 | 系统管理平台',
        ]);
    }
}
