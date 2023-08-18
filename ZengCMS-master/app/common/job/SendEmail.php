<?php
namespace app\common\job;

use think\queue\Job;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

// 这是一个消费者类，用于处理队列中的任务
class SendEmail
{
    /**
     * fire方法是消息队列默认调用的方法
     * @param Job         $job  当前的任务对象
     * @param array|mixed $data 发布任务时自定义的数据
     */
    public function fire(Job $job, $data)
    {
        // 有些消息在到达消费者时,可能已经不再需要执行了
        $isJobStillNeedToBeDone = $this->checkDatabaseToSeeIfJobNeedToBeDone($data);
        if (!$isJobStillNeedToBeDone) {
            $job->delete();
            return;
        }
        // 执行发送邮件
        $isJobDone = $this->doJob($data);
        if ($isJobDone) {
            // 如果任务执行成功，删除任务
            print("<warn>邮件队列已执行完成并且已删除！" . "</warn>\n");
            $job->delete();
        } else {
            print("<warn>任务执行失败！" . "</warn>\n");
            if ($job->attempts() > 3) {
                // 通过这个方法可以检查这个任务已经重试了几次了
                print("<warn>邮件队列已经重试超过3次，现在已经删除该任务" . "</warn>\n");
                $job->delete();
            } else {
                print("<info>重新执行该任务!第" . $job->attempts() . "次</info>\n");
                $job->release(); // 重发任务
            }
        }
    }
    /**
     * 该方法用于接收任务执行失败的通知
     * @param $data  string|array|... 发布任务时传递的数据
     */
    public function failed($data)
    {
        // 可以发送邮件给相应的负责人员
        /* $email = new Email;
        $email->to('adamlyxxx@163.com')
        ->subject(__('邮件发送任务失败'))
        ->message('邮件发送任务失败,对方邮箱是：' . $data['email'])
        ->send(); */
        print("Warning: Job failed after max retries. job data is :".var_export($data,true)."\n");
    }
    /**
     * 有些消息在到达消费者时,可能已经不再需要执行了
     * @param array|mixed    $data     发布任务时自定义的数据
     * @return boolean                 任务执行的结果
     */
    private function checkDatabaseToSeeIfJobNeedToBeDone($data)
    {
        return true;
    }
    /**
     * 根据消息中的数据进行实际的业务处理...
     */
    private function doJob($data)
    {
        $email = $data['email'];
        $title = $data['title'];
        $content = $data['content'];
        $mail = new PHPMailer(true);                   // Passing `true` enables exceptions 
        try {
            //服务器配置 
            $mail->CharSet = "UTF-8";                  //设定邮件编码 
            $mail->SMTPDebug = 2;                      // 调试模式输出 
            $mail->isSMTP();                           // 使用SMTP 
            $mail->Host = 'smtp.163.com';              // SMTP服务器 
            $mail->SMTPAuth = true;                    // 允许 SMTP 认证 
            $mail->Username = '18269297995@163.com';   // SMTP 用户名  即邮箱的用户名 
            $mail->Password = '8643092qq';             // SMTP 密码  部分邮箱是授权码(例如163邮箱) 
            $mail->SMTPSecure = 'ssl';                 // 允许 TLS 或者ssl协议 
            $mail->Port = 465;                         // 服务器端口 25 或者465 具体要看邮箱服务器支持 

            $mail->setFrom('18269297995@163.com', 'zeng');  //发件人 

            // $mail->addAddress('zengcms@qq.com');    // 收件人 
            // $mail->addAddress('ellen@example.com');    // 可添加多个收件人 
            foreach($email as $v){
                $mail->addAddress($v);   // 收件人 
            }

            $mail->addReplyTo('18269297995@163.com', 'info'); //回复的时候回复给哪个邮箱 建议和发件人一致 
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
    /* public function send()
    {
        $mail = new PHPMailer(true);                   // Passing `true` enables exceptions 
        try {
            //服务器配置 
            $mail->CharSet = "UTF-8";                  //设定邮件编码 
            $mail->SMTPDebug = 2;                      // 调试模式输出 
            $mail->isSMTP();                           // 使用SMTP 
            $mail->Host = 'smtp.163.com';              // SMTP服务器 
            $mail->SMTPAuth = true;                    // 允许 SMTP 认证 
            $mail->Username = '18269297995@163.com';   // SMTP 用户名  即邮箱的用户名 
            $mail->Password = '8643092qq';             // SMTP 密码  部分邮箱是授权码(例如163邮箱) 
            $mail->SMTPSecure = 'ssl';                 // 允许 TLS 或者ssl协议 
            $mail->Port = 465;                         // 服务器端口 25 或者465 具体要看邮箱服务器支持 

            $mail->setFrom('18269297995@163.com', 'Mailer');  //发件人 
            $mail->addAddress('zengcms@qq.com', 'Joe');  // 收件人 
            // $mail->addAddress('ellen@example.com'); // 可添加多个收件人 
            $mail->addReplyTo('18269297995@163.com', 'info'); //回复的时候回复给哪个邮箱 建议和发件人一致 
            // $mail->addCC('cc@example.com');         //抄送 
            // $mail->addBCC('bcc@example.com');       //密送 

            // 发送附件 
            // $mail->addAttachment('../xy.zip');      // 添加附件 
            // $mail->addAttachment('../thumb-1.jpg', 'new.jpg'); // 发送附件并且重命名 

            // Content 
            $mail->isHTML(true);                                  // 是否以HTML文档格式发送  发送后客户端可直接显示对应HTML内容 
            $mail->Subject = '这里是邮件标题' . time();
            $mail->Body    = '<h1>这里是邮件内容</h1>' . date('Y-m-d H:i:s');
            $mail->AltBody = '如果邮件客户端不支持HTML则显示此内容';
            $mail->send();
            echo '邮件发送成功';
        } catch (Exception $e) {
            echo '邮件发送失败: ', $mail->ErrorInfo;
        }
    } */
}
// 监听任务并执行
// php think queue:listen

// php think queue:work

// 两种，具体的可选参数可以输入命令加 --help 查看

// 可配合supervisor使用，保证进程常驻
