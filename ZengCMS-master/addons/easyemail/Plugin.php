<?php
namespace addons\easyemail;

use think\Addons;
use think\facade\Db;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use app\common\annotation\HooksAnotation;

class Plugin extends Addons
{
    // 该插件的基础信息
    public $info = [
        'name' => 'easyemail',
        'title' => '邮箱管理',
        'description' => '验证码、消息通知',
        'status' => 1,
        'author' => 'ZengCMS',
        'require' => '1.0.0',
        'version' => '1.0.0',
        'website' => '',
        'images'=>'addons/easyemail/images/easyemail.jpg',
        'group'=>'',
        'is_hook'=>1,
        'tables' => [
            'ems',
        ],
    ];
    public $menu = [
        'is_nav' => 0,
    ];
    /**
     * 插件安装方法
     * @return bool
     */
    public function install()
    {
        return true;
    }
    /**
     * 插件卸载方法
     * @return bool
     */
    public function uninstall()
    {
        return true;
    }
    /**
     * 插件使用方法
     * @return bool
     */
    public function enabled()
    {
        return true;
    }
    /**
     * 插件禁用方法
     * @return bool
     */
    public function disabled()
    {
        return true;
    }
    /**
     * @HooksAnotation(description="邮箱发送验证码，例：hook('EmsSend',['email'=>'zengcms@qq.com','code'=>'123456'])",type="2")
     * @return [type] [description]
     */
    public function EmsSend($params)
    {
        // 判断是否安装
        if(!isAddonInstall($this->name)){
            return false;
        }
        $config = getAddonConfig($this->name);
        // dump($config);
        // dump($params);
        // dump($this->config);die;
        $mail = new PHPMailer(true);                          //Passing `true` enables exceptions 
        try {
            $email = $params['email'];
            $email = is_array($email)?$email:array($email);
            $title = '验证码';
            $content = '你的验证码是：'.$params['code'];
            // 服务器配置 
            $mail->CharSet = "UTF-8";                         //设定邮件编码 
            $mail->SMTPDebug = 0;                             //调试模式输出 
            $mail->isSMTP();                                  //使用SMTP 
            $mail->Host = $config['SMTP_SERVER'];             //SMTP服务器 
            $mail->SMTPAuth = true;                           //允许 SMTP 认证 
            $mail->Username = $config['SMTP_USER'];           //SMTP 用户名  即邮箱的用户名 
            $mail->Password = $config['SMTP_PWD'];            //SMTP 密码  部分邮箱是授权码(例如163邮箱) 
            $mail->SMTPSecure = 'ssl';                        //允许 TLS 或者ssl协议 
            $mail->Port = $config['SMTP_PORT'];               //服务器端口 25 或者465 具体要看邮箱服务器支持 
            $mail->setFrom($config['SMTP_USER'], 'ZengCMS');   //发件人 
            // $mail->addAddress('zengcms@qq.com');         //收件人
            // $mail->addAddress($email);                     //可添加多个收件人 
            foreach($email as $v){
                $mail->addAddress($v);                        //收件人 
            }
            $mail->addReplyTo($config['SMTP_USER'], 'ZengCMS');//回复的时候回复给哪个邮箱 建议和发件人一致 
            $mail->isHTML(true);                              //是否以HTML文档格式发送  发送后客户端可直接显示对应HTML内容 
            $mail->Subject = $title;
            $mail->Body    = $content;
            $mail->AltBody = '如果邮件客户端不支持HTML则显示此内容';
            $mail->send();
            return true;
        } catch (Exception $e) {
            return false;
        }
    }
    /**
     * @HooksAnotation(description="邮箱发送通知，例：hook('EmsNotice',['email'=>'zengcms@qq.com','title'=>'通知','msg'=>'给您发送通知'])",type="2")
     * @return [type] [description]
     */
    public function EmsNotice($params)
    {
        // 判断是否安装
        if(!isAddonInstall($this->name)){
            return false;
        }
        $config = getAddonConfig($this->name);
        $mail = new PHPMailer(true);                         //Passing `true` enables exceptions 
        try {
            $email = $params['email'];
            $email = is_array($email)?$email:array($email);
            $title = $params['title'];
            $content = $params['msg'];
            // 服务器配置 
            $mail->CharSet = "UTF-8";                         //设定邮件编码 
            $mail->SMTPDebug = 0;                             //调试模式输出 
            $mail->isSMTP();                                  //使用SMTP 
            $mail->Host = $config['SMTP_SERVER'];             //SMTP服务器 
            $mail->SMTPAuth = true;                           //允许 SMTP 认证 
            $mail->Username = $config['SMTP_USER'];           //SMTP 用户名  即邮箱的用户名 
            $mail->Password = $config['SMTP_PWD'];            //SMTP 密码  部分邮箱是授权码(例如163邮箱) 
            $mail->SMTPSecure = 'ssl';                        //允许 TLS 或者ssl协议 
            $mail->Port = $config['SMTP_PORT'];               //服务器端口 25 或者465 具体要看邮箱服务器支持 
            $mail->setFrom($config['SMTP_USER'], 'ZengCMS');   //发件人 
            // $mail->addAddress('zengcms@qq.com');         //收件人 
            // $mail->addAddress('ellen@example.com');        //可添加多个收件人 
            foreach($email as $v){
                $mail->addAddress($v);                        //收件人 
            }
            $mail->addReplyTo($config['SMTP_USER'], 'ZengCMS');//回复的时候回复给哪个邮箱 建议和发件人一致 
            $mail->isHTML(true);                              //是否以HTML文档格式发送  发送后客户端可直接显示对应HTML内容 
            $mail->Subject = $title;
            $mail->Body    = $content;
            $mail->AltBody = '如果邮件客户端不支持HTML则显示此内容';
            $result = $mail->send();
            if($result){
                return true;
            }
        } catch (Exception $exception) {
            return false;
        }
    }
    /**
     * @HooksAnotation(description="检测验证码是否正确，例：hook('EmsCheck',['email'=>'zengcms@qq.com','code'=>'123456','event'=>'actmobile'])",type="2")
     * @return [type] [description]
     */
    public function EmsCheck($params)
    {
        // 判断是否安装
        if(!isAddonInstall($this->name)){
            return false;
        }
        $email = $params['email'];
        $code = $params['code'];
        $event = $params['event']?$params['event']:'default';
        $expire = 120;//验证码有效时长120秒
        $time = time() - $expire;
        $ems  = Db::name('ems')
        ->where(['email' => $email, 'event' => $event])
        ->order('id', 'DESC')
        ->find();
        $maxCheckNums = 10;//最大允许检测的次数
        if ($ems) {
            if ($ems['create_time'] > $time && $ems['times'] <= $maxCheckNums) {
                $correct = $code == $ems['code'];
                if (!$correct) {
                    $times = $ems['times'] + 1;
                    Db::name('ems')
                    ->where('id',$ems['id'])
                    ->update(['times'=>$times]);
                    return false;
                } else {
                    return true;
                }
            } else {
                // 过期则清空该手机验证码
                $this->flush($email, $event);
                return false;
            }
        } else {
            return false;
        }
    }
    /**
     * 清空指定邮箱验证码
     * @param  int    $email 邮箱
     * @param  string $event 事件
     * @return boolean
     */
    protected function flush($email, $event = 'default')
    {
        Db::name('ems')
        ->where([['email' ,'=', $email],['event' ,'=', $event]])
        ->delete();
        return true;
    }
}
