<?php
namespace addons\easyemail\controller;

use think\facade\Db;
use think\facade\Validate;
use think\addons\Controller;
use app\member\model\Member;

class Ems extends Controller
{
    protected function init()
    {
        // 判断插件是否安装
        $addonInfo = getAddonInfo($this->addon);
        if(!$addonInfo || !$addonInfo['status']){
            $this->error($addonInfo?'插件已禁用！':'插件未安装！');
        }
    }
    /**
     * 发送验证码接口
     * @url {:addons_url('easyemail://Ems/send')}
     * @url http://域名/addons/easyemail/ems/send
     * @HTTP POST
     * @param email 邮箱
     * @param event 事件
     * @return void
     */
    public function send()
    {
        $this->init();
        $email = $this->request->request("email");
        $event = $this->request->request("event");
        if (!$email || !Validate::isEmail($email)) {
            $this->error('邮箱不正确！');
        }
        $last = $this->get($email, $event);
        // 60秒内只能发送1次
        if ($last && time() - $last['create_time'] < 60) {
            $this->error('发送频繁！');
        }
        // 查询一个小时内的
        $ipSendTotal = Db::name('ems')
        ->where(['ip' => $this->request->ip()])
        ->whereTime('create_time', '-1 hours')
        ->count();
        // 同一个ip一个小时内不能发送超过5次
        if ($ipSendTotal >= 5) {
            $this->error('发送频繁！');
        }
        if ($event) {
            $userinfo = Member::where('email',$email)->find();
            if ($event == 'register' && $userinfo) {
                $this->error('已被注册！');
            } elseif (in_array($event, ['changemobile']) && $userinfo) {
                $this->error('已被占用！');
            } elseif (in_array($event, ['changepwd', 'resetpwd']) && !$userinfo) {
                $this->error('未注册！');
            }
        }
        $ret = $this->dosend($email,null,$event);
        if ($ret) {
            $this->success('发送成功！');
        } else {
            $this->error('发送失败！');
        }
    }
    /**
     * 获取最后一次邮箱发送的数据
     * @param  int    $email 邮箱
     * @param  string $event 事件
     * @return Sms
     */
    protected function get($email, $event = 'default')
    {
        $ems = Db::name('ems')
        ->where([['email' ,'=', $email],['event' ,'=', $event]])
        ->order('id', 'DESC')
        ->find();
        return $ems ? $ems : null;
    }
    /**
     * 发送验证码
     * @param  int    $email 邮箱
     * @param  int    $code  验证码,为空时将自动生成4位数字
     * @param  string $event 事件
     * @return boolean
     */
    protected function dosend($email, $code = null, $event = 'default')
    {
        $code = is_null($code) ? mt_rand(1000, 9999) : $code;
        $ip = request()->ip();
        $time = time();
        $id = Db::name('ems')
        ->insertGetId(['event' => $event, 'email' => $email, 'code' => $code,'ip'=>$ip,'create_time' => $time]);
        $result = hook('EmsSend',['email' => $email, 'code' => $code], false);
        if (!$result) {
            Db::name('ems')->delete($id);
            return false;
        }
        return true;
    }
}
