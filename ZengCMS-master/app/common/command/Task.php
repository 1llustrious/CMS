<?php
declare(strict_types=1);

namespace app\common\command;

use think\console\Command;
use think\console\Input;
use think\console\input\Argument;
use think\console\input\Option;
use think\console\Output;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

class Task extends Command
{
    protected function configure()
    {
        // 设置名称为task
        $this->setName('task')
        // 增加一个命令参数
        ->addArgument('action', Argument::OPTIONAL, "action", '')
        ->addArgument('force', Argument::OPTIONAL, "force", '');
    }
    protected function execute(Input $input, Output $output)
    {
        // 获取输入参数
        $action = trim($input->getArgument('action'));
        $force = trim($input->getArgument('force'));
        // 初始化
        $task = new \EasyTask\Task();
        // 设置常驻内存
        $task->setDaemon(true);
        // 设置系统时区
        $task->setTimeZone('Asia/Shanghai');
        // 设置子进程挂掉自动重启
        $task->setAutoRecover(true);
        // 设置PHP运行路径,一般Window系统才需要设置,当系统无法找到才需要您手动设置
        // $task->setPhpPath('C:/phpEnv/php/php-7.0/php.exe');
        // 设置记录运行时目录(日志或缓存目录)
        $task->setRunTimePath('./runtime/');
        /**
         * 设置关闭标准输出的STD文件记录
         */
        $task->setCloseStdOutLog(true);
        /**
         * 关闭EasyTask的异常注册
         * EasyTask将不再监听set_error_handler/set_exception_handler/register_shutdown_function事件
         */
        // $task->setCloseErrorRegister(true);

        /**
         * 设置接收运行中的错误或者异常(方式1)
         * 您可以自定义处理异常信息,例如将它们发送到您的邮件中,短信中,作为预警处理
         * (不推荐的写法,除非您的代码健壮)
         */
        $task->setErrorRegisterNotify(function ($ex) {
            //获取错误信息|错误行|错误文件
            $message = $ex->getMessage();
            $file = $ex->getFile();
            $line = $ex->getLine();
        });

        /**
         * 设置接收运行中的错误或者异常的Http地址(方式2)
         * Easy_Task会POST通知这个url并传递以下参数:
         * errStr:错误信息
         * errFile:错误文件
         * errLine:错误行
         * 您的Url收到POST请求可以编写代码发送邮件或短信通知您
         * (推荐的写法)
         */
        $task->setErrorRegisterNotify('https://www.gaojiufeng.cn/rev.php');
        
        // 配置任务，每隔20秒访问2次网站
        $task->addFunc(function () {
            $url = 'https://www.gaojiufeng.cn/?id=327';
            $content = file_get_contents($url);
            $rand = './runtime/'.mt_rand(10000,99999).'.txt';
            file_put_contents($rand, $content);
        }, 'request', 20, 2);;

        // 1.添加闭包函数类型定时任务(开启2个进程,每隔10秒执行1次你写闭包方法中的代码)
        $task->addFunc(function () {
            $url = 'https://www.gaojiufeng.cn/?id=243';
            @file_get_contents($url);
        }, 'request2', 10, 2);

        // 2.添加类的方法类型定时任务(同时支持静态方法)(开启1个进程,每隔20秒执行一次你设置的类的方法)
        // $task->addClass(Sms::class, 'send', 'sendsms', 20, 1);

        // 3.添加指令类型的定时任务(开启1个进程,每隔10秒执行1次)
        $command = 'php /www/web/orderAutoCancel.php';
        // $task->addCommand($command,'orderCancel',10,1);

        // 4.添加闭包函数任务,不需要定时器,立即执行(开启1个进程)
        $task->addFunc(function () {
            while(true)
            {
                //todo
            }
        }, 'request3', 0, 1);

        // 添加任务定时执行闭包函数
        $task->addFunc(function () {
            echo 'Success3' . PHP_EOL;
        }, 'fucn', 20, 1);   

        // 添加执行定时器
        $time = 1;
        $task->addFunc(function () {
            // 连接本地的Redis 服务
            $redis = new \Redis();
            $redis->connect('127.0.0.1', 6379);
            // 提取队列中的数据
            $data = $redis->rPop('send_captcha');
            if ($data){
                // 提取数据中的手机号和验证码
                $arr = json_decode($data, true);
                // $mobile = $data['mobile'];
                // $captcha = $data['captcha'];
                // 进行发送,此处为伪代码
                $res = $this->sendCode($arr);
                if($res){
                    // 输出日志
                     echo "向{$data}发送邮箱成功！" . PHP_EOL;
                }else{
                    // 输出日志
                    echo "向{$data}发送邮箱失败！" . PHP_EOL;
                }
            }
        }, 'send_captcha_timer', $time, 1);

        // 根据命令执行
        if ($action == 'start') {
            $task->start();
        } elseif ($action == 'status') {
            $task->status();
        } elseif ($action == 'stop') {
            // 是否强制停止
            $force = ($force == 'force');
            $task->stop($force);
        } else {
            exit('Command is not exist');
        }
    }
    // 发送邮箱
    private function sendCode($data)
    {
        $email = $data['email'];
        $title = $data['title'];
        $content = $data['content'];
        $mail = new PHPMailer(true);                   // Passing `true` enables exceptions 
        try {
            //服务器配置 
            $mail->CharSet = "UTF-8";                  //设定邮件编码 
            $mail->SMTPDebug = 1;                      // 调试模式输出 
            $mail->isSMTP();                           // 使用SMTP 
            $mail->Host = 'smtp.qq.com';              // SMTP服务器 
            $mail->SMTPAuth = true;                    // 允许 SMTP 认证 
            $mail->Username = 'zengcms@qq.com';   // SMTP 用户名  即邮箱的用户名 
            $mail->Password = 'aqwshzskztjmfffi';             // SMTP 密码  部分邮箱是授权码(例如163邮箱) 
            $mail->SMTPSecure = 'ssl';                 // 允许 TLS 或者ssl协议 
            $mail->Port = 465;                         // 服务器端口 25 或者465 具体要看邮箱服务器支持 
            $mail->setFrom('zengcms@qq.com', 'zeng');  //发件人 
            // $mail->addAddress('zengcms@qq.com');    // 收件人 
            // $mail->addAddress('ellen@example.com');    // 可添加多个收件人 
            foreach($email as $v){
                $mail->addAddress($v);   // 收件人 
            }
            $mail->addReplyTo('zengcms@qq.com', 'info'); //回复的时候回复给哪个邮箱 建议和发件人一致 
            $mail->isHTML(true);                              // 是否以HTML文档格式发送  发送后客户端可直接显示对应HTML内容 
            $mail->Subject = $title;
            $mail->Body    = $content;
            $mail->AltBody = '如果邮件客户端不支持HTML则显示此内容';
            $mail->send();
            return true;
        } catch (Exception $e) {
            return false;
        }
    }
    // 发送邮箱案例
    private function sendemail()
    {
        // 实例化PHPMailer核心类
        $mail = new PHPMailer();
        // 是否启用smtp的debug进行调试 开发环境建议开启 生产环境注释掉即可 默认关闭debug调试模式
        $mail->SMTPDebug = 1;
        // 使用smtp鉴权方式发送邮件
        $mail->isSMTP();
        // smtp需要鉴权 这个必须是true
        $mail->SMTPAuth = true;
        // 链接qq域名邮箱的服务器地址
        $mail->Host = 'smtp.qq.com';
        // 设置使用ssl加密方式登录鉴权
        $mail->SMTPSecure = 'ssl';
        // 设置ssl连接smtp服务器的远程服务器端口号
        $mail->Port = 465;
        // 设置发送的邮件的编码
        $mail->CharSet = 'UTF-8';
        // 设置发件人昵称 显示在收件人邮件的发件人邮箱地址前的发件人姓名
        $mail->FromName = '发件人昵称';
        // smtp登录的账号 QQ邮箱即可
        $mail->Username = 'zengcms@qq.com';
        // smtp登录的密码 使用生成的授权码
        $mail->Password = 'aqwshzskztjmfffi';
        // 设置发件人邮箱地址 同登录账号
        $mail->From = 'zengcms@qq.com';
        // 邮件正文是否为html编码 注意此处是一个方法
        $mail->isHTML(true);
        // 设置收件人邮箱地址
        $mail->addAddress('2392979955@qq.com');
        // 添加多个收件人 则多次调用方法即可
        $mail->addAddress('ayanhaiai@163.com');
        // 添加该邮件的主题
        $mail->Subject = '邮件主题';
        // 添加邮件正文
        $mail->Body = '<h1>Hello World</h1>';
        // 为该邮件添加附件
        // $mail->addAttachment('./example.pdf');
        // 发送邮件 返回状态
        $status = $mail->send();
    }
}
// 执行命令(windows请使用cmd):
// php think task start  启动命令
// php think task status 查询命令
// php think task stop   关闭命令
// php think task stop force 强制关闭命令