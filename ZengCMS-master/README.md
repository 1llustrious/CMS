# ZengCMS1.0.0 后台开发框架

[![ZengCMS](https://img.shields.io/badge/license-Apache%202-blue.svg)](http://bbs.zengcms.cn/)
[![ZengCMS](https://img.shields.io/badge/ZengCMS-1.0.0-brightgreen.svg)](http://bbs.zengcms.cn/)
[![star](https://gitee.com/ZengCMS/ZengCMS/badge/star.svg?theme=dark)](https://gitee.com/ZengCMS/ZengCMS/stargazers)
[![fork](https://gitee.com/ZengCMS/ZengCMS/badge/fork.svg?theme=dark)](https://gitee.com/ZengCMS/ZengCMS/members)

## [插件清单]
| 名称 | 简介 | 类型 | 价格 |
|---|---|---|---|
|网站地图|sitemap网站地图让搜索引擎对您网站的更快、更完整地进行索引，为您进行网站推广带来极大的方便|插件|免费|
|返回顶部|回到顶部美化，随机或指定显示，几十款样式，每天一种换，天天都用新样式|插件|免费|
|邮箱插件|验证码、消息通知|插件|免费|
|访问统计|访问量概况、来源搜索引擎分析、统计搜索引擎来源数据、来访分析、访问明细|插件|授权|
|微信公众号助手|便于管理微信公众号的插件，包括如下功能：推送文档、设置公众号菜单、自动回复关键词、素材管理、查看及回复关注者发送的消息|插件|授权|

## [项目介绍]
```
ZengCMS是基于最新TP6.0.x框架和Layui2.5.x的后台管理系统。
它能够快速开发多端（PC&WAP）、多语言、多城市利于SEO优化的CMS建站系统。
框架易于功能扩展，代码维护，方便二次开发，帮助开发者简单高效降低二次开发成本，满足专注业务深度开发的需求。
系统集成了完善的权限管理，强大的RESTful API，功能插件化开发，期待更多的功能加QQ群 930328106

手册地址：https://www.kancloud.cn/zengcms/zengcms
项目合作QQ：185789392
```
## [环境要求]
```
支持系统：Windows/Linux/Mac
WEB服务器：Apache/Nginx/ISS
PHP版本：php >= 7.2.0 (推荐php7.2+)
数据库：MySQL >= 5.6 (推荐MySQL5.7+)
```
## [安装教程]
```
安装方式一：
第一步：修改数据库配置，/根目录/config/database.php
第二步：将/根目录/data/zengcms.sql文件导入数据库即可
第三步：后台入口 http://您的域名/admin/login.php 默认账号密码（超级管理员：admin 123456)

安装方式二：
删除install.lock文件然后按界面步骤安装（注意如果 /根目录/runtime 目录不存在就手动新建runtime空目录）

注：1、为了安全起见最好将域名绑定到/根目录/public目录。
    2、如果您使用的工具是PHPstudy会把.htaccess文件内容清空，出现地址错误，那么把内容粘贴回来。
    2、如果你还是不会搭建，可以将FTP，服务器信息发送给邮箱 zengcms@qq.com 进行免费搭建（仅限点赞用户）
```

## [必看教程]
```
URL重写：https://www.kancloud.cn/zengcms/zengcms/2084408
```
```
更多的常见问题和教程见手册
```
## [截图预览]
![输入图片说明](https://images.gitee.com/uploads/images/2020/1222/221134_db7f4773_8474392.png "常规.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/1222/221150_48236d7a_8474392.png "CMS.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/1222/221201_39483b24_8474392.png "插件.png")

## [友情捐赠]
![输入图片说明](https://images.gitee.com/uploads/images/2020/1221/093632_9387b6b0_8474392.jpeg "224351_b00fe228_1272259.jpeg")
![输入图片说明](https://images.gitee.com/uploads/images/2020/1221/093639_74f88cd4_8474392.jpeg "224404_233a2e0e_1272259.jpeg")

## [开源协议]
HuoCMS遵循Apache2开源协议发布，并提供免费使用。 
部分代码来自互联网，若有异议，可以联系作者进行删除。