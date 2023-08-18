<?php
header('Content-type:text/html;charset=utf-8');
session_start();
// 检测是否已安装
if (!file_exists('../install.lock')) {
    header('Location:/install/');
    exit;
}
?>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>安装完成 - ZengCMS内容管理系统安装</title>
    <link rel="stylesheet" href="style/layui/css/layui.css">
    <link rel="stylesheet" href="style/css/install.css">
</head>
<body>
<div class="layui-main">
    <h1 class="site-h1">安装完成</h1>
    <blockquote class="layui-elem-quote">
        <h1>安装已经成功</h1>
        <p>账号:&nbsp;<?php echo $_SESSION['admin_account']; ?>&nbsp;密码:&nbsp;<?php echo $_SESSION['admin_password']; ?>&nbsp;</p>
        <p style="color: red;">请一定要删除或重命名/install文件夹!!!</p>
    </blockquote>
    <div class="btn-box">
        <a href="/" class="layui-btn layui-btn-small">前往前台浏览</a>
        <a href="/admin/login.php" class="layui-btn layui-btn-small">前往后台登录</a>
    </div>
</div>
</body>
</html>