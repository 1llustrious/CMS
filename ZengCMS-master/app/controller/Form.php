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
// | 表单控制器
// +----------------------------------------------------------------------
namespace app\controller;

use think\facade\Db;
use think\facade\View;

class Form extends Base
{
    // 表单信息
    protected $formInfo = array();
    // 配置
    protected $setting = array();
    // 初始化方法
    public function initialize()
    {
        $name = input('formname');
        // 获取当前的表单信息
        $form = get_document_model($name,null,1);
        if(!$form){
            $this->error('表单不存在或禁用！');
        }
        // 表单信息
        $this->formInfo = $form;
        // 配置
        $this->formInfo['setting'] = $this->setting = unserialize($form['setting']);
        View::assign([
            'formname'=>$name,//表单标识(名称)
        ]);
        parent::initialize();
    }
    // 显示表单
    public function index()
    {
        // 获取表单字段排序
        $fields = get_model_attribute($this->formInfo['id'],false);
        foreach($fields as $k=>$v){
            if($v['name'] == 'status' || $v['name'] == 'ip' || $v['name'] == 'username'){
                unset($fields[$k]);
            }
        }
        View::assign([
            'title'=>$this->formInfo['title'] . "_自定义表单",
            'keywords'=>$this->formInfo['title'] . "_自定义表单",
            'description'=>$this->formInfo['title'] . "_自定义表单",
            'formInfo'=>$this->formInfo,
            'fields'=>$fields,
        ]);
        $tpl = LANG_URL_DIR . '/z-form';
        return view(config('view.view_path') . $this->get_config['WEB_DEFAULT_THEME'] . $tpl . '.html');
    }
    // 表单提交
    public function dopost()
    {
        if(request()->isPost()){
            /* $scount = $this->doPostCount();
            if ($scount > 8) { //为防止恶意留言，每小时只能留言10次
                $this->error('提交频繁！', null, ['__token__' => $this->request->buildToken('__token__','md5')]);
            } */
            // 验证Token
            $check = $this->request->checkToken('__token__', $this->request->param());
            if(false === $check) {
                $this->error('令牌错误！', null, ['__token__' => $this->request->buildToken('__token__','md5')]);
            }
            // 验证权限
            $this->competence();
            // 提交间隔
            if ($this->setting['interval']) {
                $formguide = cookie('formguide_' . $this->formInfo['name']);
                if ($formguide) {
                    $this->error("操作过快，请歇息后再次提交！", null, ['__token__' => $this->request->buildToken('__token__')]);
                }
            }
            $data = $this->request->post();
            // 开启验证码
            if ($this->setting['isverify']) {
                // 验证码
                if (!captcha_check($data['verify'])) {
                    $this->error('验证码错误或失效', null, ['__token__' => $this->request->buildToken('__token__')]);
                }
            }
            $result = checkFieldAttr($data, $this->formInfo['id']);
            if($result['code'] == 0){
                $this->error($result['msg']);
            }
            $data = $result['data'];
            $data['create_time'] = time();
            $data['update_time'] = time();
            $uid = 0;
            $username = "游客";
            if (isAddonInstall('member')) {
                $uid = \app\member\service\User::instance()->id ?: 0;
                $username = \app\member\service\User::instance()->username ?: '游客';
            }
            $data['uid'] = $uid;
            $data['username'] = $username;
            $data['ip'] = request()->ip();
            $res = Db::name($this->formInfo['name'])->strict(false)->insert($data);
            if (!$res) {
                $this->error('提交失败！');
            }
            if ($this->setting['interval']) {
                cookie('formguide_' . $this->formInfo['name'], 1, $this->setting['interval']);
            }
            // 发送邮件
            if ($this->setting['mails']) {
                $this->setting['mails'] = str_replace('，',',',$this->setting['mails']);
                $ems['email'] = explode(",", $this->setting['mails']);
                // $ems['email'] = $this->setting['mails'];
                $ems['title'] = "[" . $this->formInfo['title'] . "]表单消息提醒！";
                $ems['msg']   = "刚刚有人在[" . $this->formInfo['title'] . "]中提交了新的信息，请进入后台查看！";
                $result       = hook('EmsNotice', $ems, false);
            }
            // 跳转地址
            $forward = $this->setting['forward'] ? ((strpos($this->setting['forward'], '://') !== false) ? $this->setting['forward'] : (string)url($this->setting['forward'])) : null;
            $this->success('提交成功！', $forward);
        }
    }
    // 验证提交权限
    protected function competence()
    {
        // 是否允许游客提交
        if (isAddonInstall('member') && (int) $this->setting['allowunreg'] == 0) {
            // 判断是否登陆
            if (!\app\member\service\User::instance()->id) {
                $this->error('该表单不允许游客提交，请登陆后操作！', (string)url('member/Index/login'));
            }
        }
        // 是否允许同一IP多次提交
        if ((int) $this->setting['allowmultisubmit'] == 0) {
            $ip    = $this->request->ip(1);
            $count = Db::name($this->formInfo['name'])->where("ip", $ip)->count();
            if ($count) {
                $this->error('你已经提交过了！');
            }
        }
    }
    /**
     * [doPostCount 记录提交次数]
     * @return [type] [description]
     */
    protected function doPostCount()
    {
        $value = md5('FORMCOOKIE:' . get_userip());
        if (!cookie($value)) {
            cookie($value, 1, 3600);
        } else {
            cookie($value, cookie($value) + 1, 3600);
        }
        return cookie($value);
    }
}