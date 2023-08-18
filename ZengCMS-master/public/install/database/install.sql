/*
 Navicat Premium Data Transfer

 Source Server         : phpstudy
 Source Server Type    : MySQL
 Source Server Version : 50726
 Source Host           : localhost:3306
 Source Schema         : zengcms

 Target Server Type    : MySQL
 Target Server Version : 50726
 File Encoding         : 65001

 Date: 27/12/2020 19:43:03
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for hh_addon
-- ----------------------------
DROP TABLE IF EXISTS `hh_addon`;
CREATE TABLE `hh_addon`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '中文名',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '插件名或标识',
  `images` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '封面',
  `group` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '组别',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '插件描述',
  `author` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '作者',
  `version` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '版本号',
  `require` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '需求版本',
  `website` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '演示地址',
  `config` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '设置',
  `is_hook` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '钩子[0:不支持;1:支持]',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态[-1:删除;0:禁用;1启用]',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `name`(`name`) USING BTREE,
  INDEX `status`(`status`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 130 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '公用插件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hh_admin
-- ----------------------------
DROP TABLE IF EXISTS `hh_admin`;
CREATE TABLE `hh_admin`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '管理员id',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '用户名',
  `image` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '头像',
  `photo_album` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '相册',
  `file_one` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '单文件',
  `file_list` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '多文件',
  `video_one` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '单视频',
  `video_list` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '多视频',
  `password` char(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '密码',
  `relname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '真实姓名',
  `sex` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '性别：1：男；2：女',
  `phone` char(11) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '手机号码',
  `email` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `success_logins` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '成功登录次数',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '注册时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后修改时间',
  `last_login_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后登录时间',
  `last_login_ip` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0' COMMENT '最后登录IP',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '启用状态；1：正常；0：禁用',
  `random_number` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '每次登录成功插入的随机数',
  `error_login_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后错误登录时间',
  `error_logins` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '错误登录次数',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE,
  UNIQUE INDEX `phone`(`phone`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 18 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_admin
-- ----------------------------
INSERT INTO `hh_admin` VALUES (1, 'admin', '', '', '', '', '', '', '45917634c7cac19dcadcc247665f65a8', '火火', 1, '15577866218', '1414516561@qq.com', 1218, 1563874572, 1608621845, 1608621845, '127.0.0.1', 1, 97411, 0, 0, 6);
INSERT INTO `hh_admin` VALUES (17, 'admin2', '', '', '', '', '', '', '45917634c7cac19dcadcc247665f65a8', '火火2', 1, '', '', 13, 1600231514, 1608866760, 1608866760, '127.0.0.1', 1, 11627, 0, 0, 0);

-- ----------------------------
-- Table structure for hh_adtype
-- ----------------------------
DROP TABLE IF EXISTS `hh_adtype`;
CREATE TABLE `hh_adtype`  (
  `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id号，广告位编号',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '广告位名称',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '广告位描述',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '广告位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_adtype
-- ----------------------------
INSERT INTO `hh_adtype` VALUES (1, '首页广告位', '首页广告位', 0);

-- ----------------------------
-- Table structure for hh_advert
-- ----------------------------
DROP TABLE IF EXISTS `hh_advert`;
CREATE TABLE `hh_advert`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增id号，广告编号',
  `typeid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0 COMMENT '广告位id',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '广告名称',
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '广告链接地址',
  `thumb` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '缩略图',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '广告描述',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '广告内容',
  `timeset` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '0永不过期，1限定时间内',
  `starttime` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '开始时间',
  `endtime` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '结束时间',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否显示：1开启; 0关闭;关闭后广告将不再有效',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '广告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_advert
-- ----------------------------
INSERT INTO `hh_advert` VALUES (1, 1, '新浪', 'http://www.xinl.com', '', 'xlasdf', 'eeee', 1, 1608104711, 1608795913, 1, 0, 1608104717, 1608629565);

-- ----------------------------
-- Table structure for hh_arctype
-- ----------------------------
DROP TABLE IF EXISTS `hh_arctype`;
CREATE TABLE `hh_arctype`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键自增ID，栏目ID',
  `model_id` int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT '所属模型ID',
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级栏目ID',
  `typename` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '栏目名称',
  `typename_en` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '英文栏目名称',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '栏目标识(英文字母)',
  `ispart` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '栏目属性:1:最终列表栏目(允许在本栏目发布文档,并生成文档列表);2:频道封面(栏目本身不允许发布文档);3:外部链接(在\"文件保存目录\"处填写网址)',
  `typedir` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文件保存目录(栏目目录)',
  `list_template` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '列表页模板',
  `index_template` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '频道封面页模板',
  `article_template` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文章内容页模板',
  `article_rule` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文章命名规则',
  `list_rule` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '列表命名规则',
  `seotitle` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'SEO标题',
  `seotitle_en` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '英文SEO标题',
  `keywords` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '栏目关键词',
  `keywords_en` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '英文栏目关键词',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '栏目描述',
  `description_en` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '英文栏目描述',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '栏目内容',
  `content_en` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '英文栏目内容',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(0:隐藏,1:显示)',
  `allow_publish` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否允许发布内容(0-不允许,1-只允许后台发表,2-前后台都可以发表)',
  `check` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '发布的文章是否需要审核(0:不需要,1:需要)',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `thumb` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '栏目图片',
  `isfirst` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否默认显示第一个子栏目内容(1:是,0:否)',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `map` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '地图',
  `sign` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标志',
  `target` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '_self' COMMENT '窗口类型',
  `rel` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'rel 属性',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 85 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文章类型表(栏目表)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_arctype
-- ----------------------------
INSERT INTO `hh_arctype` VALUES (3, 3, 0, '案例展示', 'case', 'case', 1, '', 'list_product.html', 'index_product.html', 'article_product.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', '', '', '', '', '', '', '', '', 1, 1, 0, 1598749380, 1609063170, '', 0, 50, '', '', '_self', '');
INSERT INTO `hh_arctype` VALUES (6, 2, 0, '关于我们', 'about', 'about', 2, '', 'list_article.html', 'index_about.html', 'article_article.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', '关于我们', '', '', '', '', '', '', '', 1, 1, 0, 1598749540, 1608042583, '', 1, 10, '', '', '_self', '');
INSERT INTO `hh_arctype` VALUES (10, 2, 6, '公司简介', 'company', 'company', 2, '', 'list_article.html', 'index_about.html', 'article_article.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', '', '', '', '', '', '', '<div class=\"page_content content clearfix\"><p><span style=\"font-size:18px;background-color:#FFFFFF;color:#333333;font-family:微软雅黑, arial;\">我们的愿景：</span></p><ul class=\" list-paddingleft-2\" style=\"box-sizing:border-box;-webkit-tap-highlight-color:transparent;margin:0px;padding:0px;list-style:none;color:#333333;font-family:微软雅黑, arial;font-size:14px;white-space:normal;background-color:#FFFFFF;\"><li style=\"box-sizing:border-box;-webkit-tap-highlight-color:transparent;margin:0px;padding:0px;font-size:16px;line-height:3em;\"><p style=\"box-sizing:border-box;-webkit-tap-highlight-color:transparent;margin-top:0px;margin-bottom:0px;padding:0px;font-size:18px;line-height:2.4em;\">做最适合企业的CMS</p></li></ul><p><br /></p><p><br /></p></div>', 'Our vision:<br />To be the most suitable CMS for enterprises<br />', 1, 1, 0, 1598749690, 1608042599, '', 0, 20, '', '', '_self', '');
INSERT INTO `hh_arctype` VALUES (14, 2, 6, '联系我们', 'contact', 'contact', 2, '', 'list_article.html', 'index_contact.html', 'article_article.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', '', '', '', '', '', '', '<div class=\"page_content content clearfix\"><p><span style=\"color:#5A5A5A;font-family:微软雅黑, arial;font-size:14px;text-align:center;white-space:normal;\">某某网络科技有限公司</span></p><p>电话：xxxx-xxxxxxxx</p><p>地址：广州市天河区XXX园区</p><p>邮编：1414516561@qq.com</p></div>', 'Guangzhou XX Network Technology Co., Ltd<br />Tel: xxx-xxxxxxxx<br />Address: XXX Park, Tianhe District, Guangzhou<br />Postcode: XXXXXX<br />', 1, 1, 0, 1598749757, 1608284451, '', 0, 20, '114.06157,22.971802', '', '_self', '');
INSERT INTO `hh_arctype` VALUES (31, 2, 0, '新闻中心', 'news', 'news', 1, '', 'list_article.html', 'index_article.html', 'article_article.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', '', '', '', '', '', '', '', '', 1, 1, 0, 1598754701, 1608042619, '', 0, 20, '', '', '_self', '');
INSERT INTO `hh_arctype` VALUES (32, 2, 31, '公司新闻', 'company news', 'companynews', 1, '', 'list_article.html', 'index_article.html', 'article_article.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', '', '', '', '', '', '', '', '', 1, 1, 0, 1598754719, 1607958810, '', 0, 10, '', '', '_self', '');
INSERT INTO `hh_arctype` VALUES (33, 2, 31, '技术教程', 'technology', 'technology', 1, '', 'list_technology.html', 'index_article.html', 'article_article.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', '', '', '', '', '', '', '', '', 1, 1, 0, 1598754732, 1608868956, '', 0, 8, '', '', '_self', '');
INSERT INTO `hh_arctype` VALUES (58, 2, 0, '网站建设', 'site', 'wangzhanjianshe', 2, '', 'list_article.html', 'index_article.html', 'article_article.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', '', '', '', '', '', '', '<p><b>1、明确建站需求</b></p><p>  不管做什么，首先就是需要确定用户的需求，先拟定一个网站的大体框架，网站要做什么样，需要哪些栏目，需要展示什么信息。<br /><b>2、注册一个域名</b></p><p>  域名最好注册和公司名称或业务相关的，选择.com或.cn域名，建议不要太长，要不很不好记，域名越短越好记。</p><p><b>3、确定UI设计，落实网站风格</b></p><p>  根据建站的需求和框架后，制定网站的设计风格，详情页，首页，海报，网站框架图，图标等设计项目，找个专业的设计师来设计。</p><p><b>4、网站系统的选择</b></p><p>  选择一个好的网站系统来作为网站的管理后台非常重要，一个好的网站系统可以让网站修改，维护事半功倍，选择一个差的网站系统会导致后期各种问题。</p><p><b>5、网站上线测试<br /> </b>测试成功后，再发布到服务器上对外公布，这时候同步把网站提交到各大搜索引擎去收录，很多搜索引擎都有免费提交入口，大家可以自己搜索。</p><p><b>6、网站后期维护工作</b></p><p>  后期维护就是SEO的工作了，毕竟网站建设只是一个前期步骤而已，主要的吸引用户和推广品牌还是需要后期的SEO来进行操作的，因此后期的运营也是非常重要的，站长一定要重视起来。</p><p>如果真的想要做好一个网站，并且为了网站在后期有一个非常好的发展方向，最好在一开始就找专业、正规的网站建设公司进行制作以及优化才是最好的方法。而我们角点科技在此行业拥有着多年的网站搭建及网站优化经验，帮助了很多人解决网站的相关问题，如果对于网站还有什么问题或者有这方面的需求，都可以随时来找我们哦~</p>', '1. Clear station construction requirements<br />   no matter what to do, the first thing is to determine the needs of users. First, we should draw up the general framework of a website, what kind of website to do, what columns it needs, and what information needs to be displayed.<br />2. Register a domain name<br />    it is better to register a domain name related to the company name or business. Com or. CN domain name is recommended. It is not too long or hard to remember. The shorter the domain name, the better.<br />3. Determine UI design and implement website style<br />   according to the needs and framework of the website, formulate the website design style, detail page, home page, poster, website frame diagram, icon and other design projects, and find a professional designer to design.<br />4. Selection of website system<br />   it is very important to choose a good website system as the background of website management. A good website system can make website modification and maintenance get twice the result with half the effort. Choosing a poor website system will lead to various problems in the later stage.<br />5. Website online test<br />After the test is successful, it will be released to the server for public announcement. At this time, the website will be submitted to the major search engines for collection. Many search engines have Free submission portal, and you can search by yourself.<br />6. Website post maintenance<br />   post maintenance is the work of SEO, after all, the website construction is only a preliminary step, the main attraction of users and promotion of brand or need the later SEO to operate, so the later operation is also very important, the webmaster must pay attention to it.<br />If you really want to do a good website, and for the website has a very good development direction in the later stage, it is best to find a professional and regular website construction company to make and optimize at the beginning. Our corner technology in this industry has many years of experience in website construction and website optimization, which has helped many people solve the related problems of the website. If there are any problems or needs in this respect, you can come to us at any time~<br />', 1, 1, 0, 0, 1608779618, '', 0, 100, '', '2', '_self', '');
INSERT INTO `hh_arctype` VALUES (84, 2, 0, '开发手册', '', 'manual', 3, 'https://www.kancloud.cn/zengcms/zengcms', 'list_article.html', 'index_article.html', 'article_article.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', '', '', '', '', '', '', '', '', 1, 1, 0, 1608426214, 1608980896, '', 0, 0, '', '', '_blank', '');

-- ----------------------------
-- Table structure for hh_arctype_priv
-- ----------------------------
DROP TABLE IF EXISTS `hh_arctype_priv`;
CREATE TABLE `hh_arctype_priv`  (
  `catid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '栏目ID',
  `roleid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0 COMMENT '角色或者组ID',
  `is_admin` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否为管理员，1、管理员',
  `action` char(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '动作',
  INDEX `catid`(`catid`, `roleid`, `is_admin`, `action`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '栏目权限表' ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of hh_arctype_priv
-- ----------------------------
INSERT INTO `hh_arctype_priv` VALUES (3, 1, 1, 'add');
INSERT INTO `hh_arctype_priv` VALUES (3, 2, 1, 'add');
INSERT INTO `hh_arctype_priv` VALUES (3, 3, 1, 'edit');
INSERT INTO `hh_arctype_priv` VALUES (31, 3, 1, 'add');
INSERT INTO `hh_arctype_priv` VALUES (33, 3, 1, 'add');
INSERT INTO `hh_arctype_priv` VALUES (33, 3, 1, 'edit');
INSERT INTO `hh_arctype_priv` VALUES (33, 3, 1, 'select');
INSERT INTO `hh_arctype_priv` VALUES (58, 1, 1, 'add');
INSERT INTO `hh_arctype_priv` VALUES (58, 1, 1, 'copy');
INSERT INTO `hh_arctype_priv` VALUES (58, 1, 1, 'delete');
INSERT INTO `hh_arctype_priv` VALUES (58, 1, 1, 'edit');
INSERT INTO `hh_arctype_priv` VALUES (58, 1, 1, 'move');
INSERT INTO `hh_arctype_priv` VALUES (58, 1, 1, 'select');
INSERT INTO `hh_arctype_priv` VALUES (58, 2, 1, 'add');
INSERT INTO `hh_arctype_priv` VALUES (58, 2, 1, 'copy');
INSERT INTO `hh_arctype_priv` VALUES (58, 2, 1, 'delete');
INSERT INTO `hh_arctype_priv` VALUES (58, 2, 1, 'edit');
INSERT INTO `hh_arctype_priv` VALUES (58, 2, 1, 'move');
INSERT INTO `hh_arctype_priv` VALUES (58, 2, 1, 'select');
INSERT INTO `hh_arctype_priv` VALUES (58, 3, 1, 'edit');
INSERT INTO `hh_arctype_priv` VALUES (58, 3, 1, 'select');

-- ----------------------------
-- Table structure for hh_attachment
-- ----------------------------
DROP TABLE IF EXISTS `hh_attachment`;
CREATE TABLE `hh_attachment`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `group_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '分组ID',
  `upload_mode` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '上传方式 1:本地 2:阿里云',
  `file_name` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文件名称',
  `file_type` char(6) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'image' COMMENT 'image：图片，file：文件，video：视频',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 100 COMMENT '排序',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `file_name`(`file_name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '附件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hh_attachment_group
-- ----------------------------
DROP TABLE IF EXISTS `hh_attachment_group`;
CREATE TABLE `hh_attachment_group`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '分组id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '分组名称',
  `is_default` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否默认(0否,1是)',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 100 COMMENT '排序',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '附件分组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hh_attribute
-- ----------------------------
DROP TABLE IF EXISTS `hh_attribute`;
CREATE TABLE `hh_attribute`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键自增ID,字段id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '字段名称(即所属模型的表的字段名,英文字母)',
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '字段注释(字段标题,用于表单显示)',
  `field` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '字段定义',
  `type` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '字段类型(用于表单中的展示方式)',
  `value` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '默认值(字段的默认值)',
  `remark` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '字段备注(用于表单中的提示)',
  `is_show` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否显示(是否显示在表单中;0:始终不显示,1:始终显示,2:新增时显示,3:编辑时显示)',
  `is_search` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否搜索(0:否,1:是)',
  `extra` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '参数(布尔、枚举、多选字段类型的定义数据)\r\n两种方式：\r\n1、多个可选值用逗号隔开。注：必须加说明，例：值:说明,值:说明 \r\n2、如果是枚举型，需要配置该项，一行一个选项，例: \r\n0:选项1 \r\n2:选项2',
  `model_id` int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT '所属模型ID',
  `table_name` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '模型ID为0时，非模型表名',
  `group_id` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '分组ID(1:基础设置,2:拓展设置)',
  `is_must` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否必填(用于自动验证;0:否,1:是)',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(0:禁用,1:正常)',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `validate_type` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '验证方式',
  `validate_rule` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '验证规则(根据验证方式定义相关验证规则)',
  `validate_time` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '验证时间(0:不验证,1:新增时,2:编辑时,3:始终)',
  `error_info` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '出错提示',
  `auto_type` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '自动完成方式(function:函数,field:字段,string:字符串)',
  `auto_rule` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '自动完成规则(根据完成方式订阅相关规则)',
  `auto_time` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '自动完成时间(0:不完成,1:新增时,2:编辑时,3:始终)',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `model_id`(`model_id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 210 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '模型属性表(模型字段表)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_attribute
-- ----------------------------
INSERT INTO `hh_attribute` VALUES (1, 'id', '主键id', 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'num', '', '主键id', 0, 0, '', 1, '', 2, 0, 1, 1557843306, 1557843306, '', '', 0, '', '', '', 0, 100);
INSERT INTO `hh_attribute` VALUES (2, 'category_id', '所属分类ID', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '所属分类ID', 0, 0, '', 1, '', 1, 0, 1, 1557843306, 1557843306, '', '', 0, '', '', '', 0, 99);
INSERT INTO `hh_attribute` VALUES (3, 'title', '标题', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 1, '', 1, 1, 1, 1557843306, 1557843306, '', '', 0, '', '', '', 0, 98);
INSERT INTO `hh_attribute` VALUES (4, 'create_time', '创建时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '创建时间', 3, 0, '', 1, '', 1, 0, 1, 1557843306, 1557843306, '', '', 0, '', '', '', 0, 82);
INSERT INTO `hh_attribute` VALUES (5, 'update_time', '修改时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '修改时间', 0, 0, '', 1, '', 1, 0, 1, 1557843306, 1557843306, '', '', 0, '', '', '', 0, 81);
INSERT INTO `hh_attribute` VALUES (6, 'status', '状态', 'char(50) NOT NULL DEFAULT \'1\'', 'select', '1', '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)', 1, 0, '-1:删除,0:隐藏,1:显示,2:待审核,3:草稿', 1, '', 1, 0, 1, 1557843306, 1557843306, '', '', 0, '', '', '', 0, 84);
INSERT INTO `hh_attribute` VALUES (7, 'sort', '排序', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '', 1, 0, '', 1, '', 1, 0, 1, 1557843306, 1557843306, '', '', 0, '', '', '', 0, 83);
INSERT INTO `hh_attribute` VALUES (151, 'flags', '自定义属性', 'varchar(100) NOT NULL DEFAULT \'\'', 'checkbox', '', '自定义属性', 1, 0, 'h:头条,c:推荐,f:幻灯,a:特荐,s:滚动,b:加粗,p:图片,j:跳转;', 5, '', 1, 0, 1, 1603452597, 1603452597, '', '', 0, '', '', '', 0, 70);
INSERT INTO `hh_attribute` VALUES (9, 'flags', '自定义属性', 'varchar(100) NOT NULL DEFAULT \'\'', 'checkbox', '', '', 1, 0, 'h:头条,c:推荐,f:幻灯,a:特荐,s:滚动,b:加粗,p:图片,j:跳转;', 1, '', 1, 0, 1, 1557843425, 1557843425, '', '', 0, '', '', '', 0, 96);
INSERT INTO `hh_attribute` VALUES (10, 'tags', 'TAG标签', 'varchar(255) NOT NULL DEFAULT \'\'', 'tags', '', 'TAG标签', 1, 0, '', 1, '', 1, 0, 1, 1557843481, 1557843481, '', '', 0, '', '', '', 0, 95);
INSERT INTO `hh_attribute` VALUES (11, 'thumb', '缩略图', 'varchar(100) NOT NULL DEFAULT \'\'', 'picture', '', '图标', 1, 0, '', 1, '', 1, 0, 1, 1557843565, 1557843565, '', '', 0, '', '', '', 0, 94);
INSERT INTO `hh_attribute` VALUES (13, 'source', '来源', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 1, '', 1, 0, 1, 1557843674, 1557843674, '', '', 0, '', '', '', 0, 93);
INSERT INTO `hh_attribute` VALUES (14, 'uid', '管理员ID', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '', '', 0, 0, '', 1, '', 1, 0, 1, 1557843712, 1557843712, '', '', 0, '', '', '', 0, 92);
INSERT INTO `hh_attribute` VALUES (15, 'writer', '作者', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 1, '', 1, 0, 1, 1557843741, 1557843741, '', '', 0, '', '', '', 0, 91);
INSERT INTO `hh_attribute` VALUES (16, 'keywords', '关键词', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 1, '', 1, 0, 1, 1557843781, 1557843781, '', '', 0, '', '', '', 0, 90);
INSERT INTO `hh_attribute` VALUES (17, 'description', '描述', 'text DEFAULT NULL', 'textarea', '', '', 1, 0, '', 1, '', 1, 0, 1, 1557843812, 1557843812, '', '', 0, '', '', '', 0, 88);
INSERT INTO `hh_attribute` VALUES (18, 'content', '内容', 'text DEFAULT NULL', 'editor', '', '内容', 1, 0, '', 1, '', 1, 0, 1, 1557843844, 1557843844, '', '', 0, '', '', '', 0, 86);
INSERT INTO `hh_attribute` VALUES (19, 'view', '浏览量', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '', 1, 0, '', 1, '', 1, 0, 1, 1557843877, 1557843877, '', '', 0, '', '', '', 0, 85);
INSERT INTO `hh_attribute` VALUES (120, 'ceshitags', '测试数组', 'varchar(255) NOT NULL DEFAULT \'\'', 'array', '', '', 1, 0, '', 2, '', 1, 0, 0, 1601813195, 1601813195, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (21, 'id', '主键ID', 'int(10) UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY', 'num', '', '主键ID', 0, 0, '', 2, '', 2, 0, 1, 1607496268, 1557844112, '', '', 0, '', '', '', 0, 100);
INSERT INTO `hh_attribute` VALUES (22, 'id', '主键id', 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'num', '', '主键id', 0, 0, '', 3, '', 2, 0, 1, 1557844601, 1557844601, '', '', 0, '', '', '', 0, 100);
INSERT INTO `hh_attribute` VALUES (23, 'category_id', '所属分类ID', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '所属分类ID', 0, 0, '', 3, '', 1, 0, 1, 1557844601, 1557844601, '', '', 0, '', '', '', 0, 99);
INSERT INTO `hh_attribute` VALUES (24, 'title', '标题', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 1, '', 3, '', 1, 1, 1, 1557844601, 1557844601, '', '', 0, '', '', '', 0, 98);
INSERT INTO `hh_attribute` VALUES (25, 'create_time', '创建时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '', '创建时间', 3, 0, '', 3, '', 1, 0, 1, 1557844601, 1557844601, '', '', 0, '', '', '', 0, 81);
INSERT INTO `hh_attribute` VALUES (26, 'update_time', '修改时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '修改时间', 0, 0, '', 3, '', 1, 0, 1, 1557844601, 1557844601, '', '', 0, '', '', '', 0, 80);
INSERT INTO `hh_attribute` VALUES (27, 'status', '状态', 'char(50) NOT NULL DEFAULT \'1\'', 'select', '1', '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)', 1, 0, '-1:删除,0:隐藏,1:显示,2:待审核,3:草稿', 3, '', 1, 0, 1, 1557844601, 1557844601, '', '', 0, '', '', '', 0, 83);
INSERT INTO `hh_attribute` VALUES (28, 'sort', '排序', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '', 1, 0, '', 3, '', 1, 0, 1, 1557844601, 1557844601, '', '', 0, '', '', '', 0, 82);
INSERT INTO `hh_attribute` VALUES (29, 'description', '描述', 'text DEFAULT NULL', 'textarea', '', '', 1, 0, '', 3, '', 1, 0, 1, 1557846860, 1557846860, '', '', 0, '', '', '', 0, 88);
INSERT INTO `hh_attribute` VALUES (30, 'content', '内容', 'text DEFAULT NULL', 'editor', '', '内容', 1, 0, '', 3, '', 1, 0, 1, 1557846887, 1557846887, '', '', 0, '', '', '', 0, 86);
INSERT INTO `hh_attribute` VALUES (32, 'thumb', '缩略图', 'varchar(100) NOT NULL DEFAULT \'\'', 'picture', '', '图片', 1, 0, '', 3, '', 1, 0, 1, 1557880323, 1557880323, '', '', 0, '', '', '', 0, 94);
INSERT INTO `hh_attribute` VALUES (34, 'title_en', '英文标题', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 3, '', 1, 0, 1, 1560311179, 1560311179, '', '', 0, '', '', '', 0, 97);
INSERT INTO `hh_attribute` VALUES (85, 'keywords_en', '英文关键词', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 1, '', 1, 0, 1, 1598953584, 1598953584, '', '', 0, '', '', '', 0, 89);
INSERT INTO `hh_attribute` VALUES (86, 'description_en', '英文描述', 'text DEFAULT NULL', 'textarea', '', '', 1, 0, '', 1, '', 1, 0, 1, 1598953624, 1598953624, '', '', 0, '', '', '', 0, 87);
INSERT INTO `hh_attribute` VALUES (133, 'content_en', '英文内容', 'text DEFAULT NULL', 'editor', '', '', 1, 0, '', 1, '', 1, 0, 1, 1603281404, 1603281404, '', '', 0, '', '', '', 0, 86);
INSERT INTO `hh_attribute` VALUES (38, 'description_en', '英文描述', 'text DEFAULT NULL', 'textarea', '', '', 1, 0, '', 3, '', 1, 0, 1, 1560311706, 1560311706, '', '', 0, '', '', '', 0, 87);
INSERT INTO `hh_attribute` VALUES (39, 'content_en', '英文内容', 'text DEFAULT NULL', 'editor', '', '', 1, 0, '', 3, '', 1, 0, 1, 1560311726, 1560311726, '', '', 0, '', '', '', 0, 85);
INSERT INTO `hh_attribute` VALUES (43, 'diqu', '测试地区', 'varchar(100) NOT NULL DEFAULT \'\'', 'checkbox', '', '', 1, 0, '', 2, '', 1, 0, 0, 1561170840, 1561170840, '', '', 0, '', '', '', 0, 94);
INSERT INTO `hh_attribute` VALUES (46, 'view', '浏览量', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '', '', 1, 0, '', 3, '', 1, 0, 1, 1562213731, 1562213731, '', '', 0, '', '', '', 0, 84);
INSERT INTO `hh_attribute` VALUES (47, 'flags', '自定义属性', 'varchar(100) NOT NULL DEFAULT \'\'', 'checkbox', '', '', 1, 0, 'h:头条,c:推荐,f:幻灯,a:特荐,s:滚动,b:加粗,p:图片,j:跳转;', 3, '', 1, 0, 1, 1562391769, 1562391769, '', '', 0, '', '', '', 0, 96);
INSERT INTO `hh_attribute` VALUES (48, 'tags', 'TAG标签', 'varchar(255) NOT NULL DEFAULT \'\'', 'tags', '', 'TAG标签', 1, 0, '', 3, '', 1, 0, 1, 1562391822, 1562391822, '', '', 0, '', '', '', 0, 95);
INSERT INTO `hh_attribute` VALUES (49, 'yanshi', '演示地址', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 3, '', 1, 0, 1, 1562637847, 1562637847, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (50, 'hyfl', '行业分类', 'char(50) NOT NULL DEFAULT \'\'', 'select', '', '', 1, 1, '新闻资讯:新闻资讯,网络公司:网络公司,科技产品:科技产品,婚庆婚纱:婚庆婚纱,机械设备:机械设备,医院医疗:医院医疗,生活家居:生活家居,其他行业:其他行业', 3, '', 1, 0, 1, 1563112051, 1563112051, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (51, 'wzys', '网站颜色', 'char(50) NOT NULL DEFAULT \'\'', 'select', '', '', 1, 1, '红色:红色,灰色:灰色,白色:白色,黑色:黑色,粉色:粉色,紫色:紫色,蓝色:蓝色,绿色:绿色,黄色:黄色,橙色:橙色,棕色:棕色,其他 :其他 ', 3, '', 1, 0, 1, 1563112112, 1563112112, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (52, 'jrsb', '兼容设备', 'char(50) NOT NULL DEFAULT \'\'', 'select', '', '', 1, 1, 'PC:PC,WAP:WAP,M(PC+WAP):M(PC WAP),自适应:自适应', 3, '', 1, 0, 1, 1563112154, 1563112154, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (145, 'position', '推荐位', 'varchar(100) NOT NULL DEFAULT \'\'', 'checkbox', '', '', 1, 0, '1:列表页推荐\n2:频道页推荐\n3:首页推荐', 3, '', 1, 0, 0, 1603439037, 1603439037, '', '', 0, '', '', '', 0, 76);
INSERT INTO `hh_attribute` VALUES (54, 'yybm', '语言编码', 'char(50) NOT NULL DEFAULT \'\'', 'select', '', '', 1, 1, 'GBK简体:GBK简体,UTF8简体:UTF8简体,双版本:双版本 ', 3, '', 1, 0, 1, 1563112284, 1563112284, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (56, 'file', '程序文件', 'varchar(100) NOT NULL DEFAULT \'\'', 'file', '', '', 1, 0, '', 3, '', 1, 0, 1, 1563259499, 1563259499, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (72, 'uid', '管理员ID', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '', '', 0, 0, '', 3, '', 1, 0, 1, 1598499395, 1598499395, '', '', 0, '', '', '', 0, 92);
INSERT INTO `hh_attribute` VALUES (63, 'duowenjian', '测试多文件', 'text DEFAULT NULL', 'filelist', '', '', 1, 0, '', 2, '', 1, 0, 0, 1587660963, 1587660963, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (62, 'danwenjian', '测试单文件', 'varchar(100) NOT NULL DEFAULT \'\'', 'file', '', '', 1, 0, '', 2, '', 1, 0, 0, 1587660654, 1587660654, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (64, 'danshipin', '测试单视频', 'varchar(100) NOT NULL DEFAULT \'\'', 'onevideo', '', '', 1, 0, '', 2, '', 1, 0, 0, 1587660986, 1587660986, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (65, 'duoshipin', '测试多视频', 'text DEFAULT NULL', 'videolist', '', '', 1, 0, '', 2, '', 1, 0, 0, 1587661004, 1587661004, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (66, 'duoxuan', '测试多选', 'varchar(100) NOT NULL DEFAULT \'\'', 'checkbox', '1', '', 1, 0, '1:好的,2:不好的', 2, '', 1, 0, 0, 1588846050, 1588846050, '', '', 0, '', '', '', 0, 93);
INSERT INTO `hh_attribute` VALUES (68, 'keywords', '关键词', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 3, '', 1, 0, 1, 1598149947, 1598149947, '', '', 0, '', '', '', 0, 90);
INSERT INTO `hh_attribute` VALUES (69, 'keywords_en', '英文关键词', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 3, '', 1, 0, 1, 1598150000, 1598150000, '', '', 0, '', '', '', 0, 89);
INSERT INTO `hh_attribute` VALUES (70, 'target', '窗口类型', 'char(50) NOT NULL DEFAULT \'\'', 'select', '_self', '', 1, 0, '_blank:_blank在新窗口中打开被链接文档\n_self:_self默认。在相同的框架中打开被链接文档\n_parent:_parent在父框架集中打开被链接文档\n_top:_top在整个窗口中打开被链接文档\nframename:framename在指定的框架中打开被链接文档', 1, '', 1, 0, 1, 1598282575, 1598282575, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (71, 'target', '窗口类型', 'char(50) NOT NULL DEFAULT \'\'', 'select', '_self', '', 1, 0, '_blank:_blank在新窗口中打开被链接文档\n_self:_self默认。在相同的框架中打开被链接文档\n_parent:_parent在父框架集中打开被链接文档\n_top:_top在整个窗口中打开被链接文档\nframename:framename在指定的框架中打开被链接文档', 3, '', 1, 0, 1, 1598323089, 1598323089, '', '', 0, '', '', '', 0, 78);
INSERT INTO `hh_attribute` VALUES (135, 'rel', 'rel 属性', 'char(50) NOT NULL DEFAULT \'\'', 'select', '', '', 1, 0, 'nofllow:nofllow用于指定Google搜索引擎不要跟踪链接\nexternal:external属性的意思是告诉搜索引擎，这个链接不是本站链接\nnoopener noreferrer:noopener noreferrer在新打开的页面（baidu）中可以通过 window.opener获取到源页面的部分控制权， 即使新打开的页面是跨域的也照样可以（例如 location 就不存在跨域问题）', 1, '', 1, 0, 1, 1603291691, 1603291691, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (144, 'rel', 'rel 属性', 'char(50) NOT NULL DEFAULT \'\'', 'select', '', '', 1, 0, 'nofllow:nofllow用于指定Google搜索引擎不要跟踪链接\nexternal:external属性的意思是告诉搜索引擎，这个链接不是本站链接\nnoopener noreferrer:noopener noreferrer在新打开的页面（baidu）中可以通过 window.opener获取到源页面的部分控制权， 即使新打开的页面是跨域的也照样可以（例如 location 就不存在跨域问题）', 3, '', 1, 0, 1, 1603438604, 1603438604, '', '', 0, '', '', '', 0, 77);
INSERT INTO `hh_attribute` VALUES (82, 'source', '来源', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 3, '', 1, 0, 1, 1598840915, 1598840915, '', '', 0, '', '', '', 0, 93);
INSERT INTO `hh_attribute` VALUES (143, 'writer', '作者', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 3, '', 1, 0, 1, 1603438462, 1603438462, '', '', 0, '', '', '', 0, 91);
INSERT INTO `hh_attribute` VALUES (84, 'title_en', '英文标题', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 1, '', 1, 0, 1, 1598951542, 1598951542, '', '', 0, '', '', '', 0, 97);
INSERT INTO `hh_attribute` VALUES (87, 'id', '主键id', 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'num', '', '主键id', 0, 0, '', 4, '', 2, 0, 1, 1600301603, 1600301603, '', '', 0, '', '', '', 0, 100);
INSERT INTO `hh_attribute` VALUES (88, 'category_id', '所属分类ID', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '所属分类ID', 0, 0, '', 4, '', 1, 0, 1, 1600301603, 1600301603, '', '', 0, '', '', '', 0, 90);
INSERT INTO `hh_attribute` VALUES (89, 'title', '标题', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '标题', 1, 0, '', 4, '', 1, 1, 1, 1600301603, 1600301603, '', '', 0, '', '', '', 0, 80);
INSERT INTO `hh_attribute` VALUES (90, 'create_time', '创建时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '创建时间', 3, 0, '', 4, '', 1, 0, 1, 1600301603, 1600301603, '', '', 0, '', '', '', 0, 22);
INSERT INTO `hh_attribute` VALUES (91, 'update_time', '修改时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '修改时间', 0, 0, '', 4, '', 1, 0, 1, 1600301603, 1600301603, '', '', 0, '', '', '', 0, 21);
INSERT INTO `hh_attribute` VALUES (92, 'status', '状态', 'char(50) NOT NULL DEFAULT \'1\'', 'select', '1', '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)', 1, 0, '-1:删除,0:隐藏,1:显示,2:待审核,3:草稿', 4, '', 1, 0, 1, 1600301603, 1600301603, '', '', 0, '', '', '', 0, 24);
INSERT INTO `hh_attribute` VALUES (93, 'sort', '排序', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '排序', 1, 0, '', 4, '', 1, 0, 1, 1600301603, 1600301603, '', '', 0, '', '', '', 0, 23);
INSERT INTO `hh_attribute` VALUES (94, 'id', '主键id', 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'num', '', '主键id', 0, 0, '', 5, '', 2, 0, 1, 1600301812, 1600301812, '', '', 0, '', '', '', 0, 100);
INSERT INTO `hh_attribute` VALUES (95, 'category_id', '所属分类ID', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '所属分类ID', 0, 0, '', 5, '', 1, 0, 1, 1600301812, 1600301812, '', '', 0, '', '', '', 0, 90);
INSERT INTO `hh_attribute` VALUES (96, 'title', '标题', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '标题', 1, 0, '', 5, '', 1, 1, 1, 1600301812, 1600301812, '', '', 0, '', '', '', 0, 80);
INSERT INTO `hh_attribute` VALUES (97, 'create_time', '创建时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '创建时间', 3, 0, '', 5, '', 1, 0, 1, 1600301812, 1600301812, '', '', 0, '', '', '', 0, 22);
INSERT INTO `hh_attribute` VALUES (98, 'update_time', '修改时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '修改时间', 0, 0, '', 5, '', 1, 0, 1, 1600301812, 1600301812, '', '', 0, '', '', '', 0, 21);
INSERT INTO `hh_attribute` VALUES (99, 'status', '状态', 'char(50) NOT NULL DEFAULT \'1\'', 'select', '1', '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)', 1, 0, '-1:删除,0:隐藏,1:显示,2:待审核,3:草稿', 5, '', 1, 0, 1, 1600301812, 1600301812, '', '', 0, '', '', '', 0, 24);
INSERT INTO `hh_attribute` VALUES (100, 'sort', '排序', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '排序', 1, 0, '', 5, '', 1, 0, 1, 1600301812, 1600301812, '', '', 0, '', '', '', 0, 23);
INSERT INTO `hh_attribute` VALUES (101, 'id', '主键id', 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'num', '', '主键id', 0, 0, '', 7, '', 2, 0, 1, 1600747056, 1600747056, '', '', 0, '', '', '', 0, 100);
INSERT INTO `hh_attribute` VALUES (191, 'ip', 'IP', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', 'IP', 1, 1, '', 8, '', 1, 0, 1, 1606968730, 1606968730, '', '', 0, '', '', '', 0, 70);
INSERT INTO `hh_attribute` VALUES (104, 'create_time', '创建时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '创建时间', 3, 0, '', 7, '', 1, 0, 1, 1600747056, 1600747056, '', '', 0, '', '', '', 0, 50);
INSERT INTO `hh_attribute` VALUES (105, 'update_time', '修改时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '修改时间', 0, 0, '', 7, '', 1, 0, 1, 1600747056, 1600747056, '', '', 0, '', '', '', 0, 40);
INSERT INTO `hh_attribute` VALUES (106, 'status', '状态', 'char(50) NOT NULL DEFAULT \'1\'', 'select', '1', '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)', 1, 0, '-1:删除,0:隐藏,1:显示,2:待审核,3:草稿', 7, '', 1, 0, 1, 1600747056, 1600747056, '', '', 0, '', '', '', 0, 70);
INSERT INTO `hh_attribute` VALUES (107, 'sort', '排序', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '排序', 1, 0, '', 7, '', 1, 0, 1, 1600747056, 1600747056, '', '', 0, '', '', '', 0, 60);
INSERT INTO `hh_attribute` VALUES (108, 'remark', '简介', 'text DEFAULT NULL', 'textarea', '', '', 1, 1, '', 7, '', 1, 0, 1, 1600766917, 1600766917, 'length', '6,10', 3, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (109, 'id', '主键id', 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'num', '', '主键id', 0, 0, '', 8, '', 2, 0, 1, 1601004452, 1601004452, '', '', 0, '', '', '', 0, 100);
INSERT INTO `hh_attribute` VALUES (190, 'username', '用户名', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '用户名', 1, 0, '', 8, '', 1, 0, 1, 1606968730, 1606968730, '', '', 0, '', '', '', 0, 80);
INSERT INTO `hh_attribute` VALUES (189, 'uid', '用户ID', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '用户ID', 0, 0, '', 8, '', 1, 0, 1, 1606968730, 1606968730, '', '', 0, '', '', '', 0, 90);
INSERT INTO `hh_attribute` VALUES (112, 'create_time', '创建时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '创建时间', 3, 0, '', 8, '', 1, 0, 1, 1601004452, 1601004452, '', '', 0, '', '', '', 0, 50);
INSERT INTO `hh_attribute` VALUES (113, 'update_time', '修改时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '修改时间', 0, 0, '', 8, '', 1, 0, 1, 1601004452, 1601004452, '', '', 0, '', '', '', 0, 40);
INSERT INTO `hh_attribute` VALUES (114, 'status', '状态', 'char(50) NOT NULL DEFAULT \'1\'', 'select', '1', '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)', 1, 0, '-1:删除,0:隐藏,1:显示,2:待审核,3:草稿', 8, '', 1, 0, 1, 1601004452, 1601004452, '', '', 0, '', '', '', 0, 70);
INSERT INTO `hh_attribute` VALUES (115, 'sort', '排序', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '排序', 1, 0, '', 8, '', 1, 0, 1, 1601004452, 1601004452, '', '', 0, '', '', '', 0, 60);
INSERT INTO `hh_attribute` VALUES (116, 'phone', '手机号码', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 8, '', 1, 0, 1, 1601004532, 1601004532, 'regex', '/^1[34578]\\d{9}$/ims', 3, '格式错误', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (117, 'city', '意向合作城市', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 8, '', 1, 0, 1, 1601004582, 1601004582, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (118, 'content', '咨询留言', 'text DEFAULT NULL', 'textarea', '', '', 1, 0, '', 8, '', 1, 0, 1, 1601004629, 1601004629, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (119, 'quseqi', '测试取色器', 'varchar(255) NOT NULL DEFAULT \'\'', 'colorpicker', '', '', 1, 0, '', 2, '', 1, 0, 0, 1601132008, 1601132008, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (122, 'ceshibdditu', '测试百度地图', 'varchar(100) NOT NULL DEFAULT \'\'', 'map', '113.278283,23.164317', '', 1, 0, '', 2, '', 1, 0, 0, 1601910913, 1601910913, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (123, 'ceshiqqditu', '测试腾讯地图', 'varchar(100) NOT NULL DEFAULT \'\'', 'map', '', '', 1, 0, '', 2, '', 1, 0, 0, 1601949157, 1601949157, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (124, 'ceshiselectdx', '测试下拉框多选', 'varchar(255) NOT NULL DEFAULT \'\'', 'selects', '', '', 1, 0, '0:坏人\n1:好人\n2:美国人', 2, '', 1, 0, 0, 1602684842, 1602684842, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (125, 'ceshigjixldx', '测试高级下拉单选', 'char(50) NOT NULL DEFAULT \'\'', 'selecto', '', '', 1, 0, '0:火火\n1:火火2\n2:火火3', 2, '', 1, 0, 0, 1602691610, 1602691610, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (126, 'ceshimarkdown', '测试markdown编辑器', 'text DEFAULT NULL', 'markdown', '', '', 1, 0, '', 2, '', 1, 0, 0, 1602728956, 1602728956, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (205, 'map', '地图', 'varchar(100) NOT NULL DEFAULT \'\'', 'map', '', '', 1, 0, '', 0, 'arctype', 2, 0, 1, 1607588616, 1607588616, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (137, 'position', '推荐位', 'varchar(100) NOT NULL DEFAULT \'\'', 'checkbox', '', '', 1, 0, '1:列表页推荐\n2:频道页推荐\n3:首页推荐', 1, '', 1, 0, 0, 1603295378, 1603295378, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (138, 'redirecturl', '跳转地址', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 1, '', 1, 0, 0, 1603295497, 1603295497, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (141, 'color', '标题颜色', 'varchar(64) NOT NULL DEFAULT \'\'', 'colorpicker', '', '', 1, 0, '', 1, '', 1, 0, 1, 1603327531, 1603327531, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (146, 'redirecturl', '跳转地址', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 3, '', 1, 0, 0, 1603439084, 1603439084, '', '', 0, '', '', '', 0, 75);
INSERT INTO `hh_attribute` VALUES (148, 'color', '标题颜色', 'varchar(64) NOT NULL DEFAULT \'\'', 'colorpicker', '', '', 1, 0, '', 3, '', 1, 0, 1, 1603439184, 1603439184, '', '', 0, '', '', '', 0, 74);
INSERT INTO `hh_attribute` VALUES (150, 'title_en', '英文标题', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '英文标题', 1, 0, '', 5, '', 1, 0, 1, 1603452597, 1603452597, '', '', 0, '', '', '', 0, 80);
INSERT INTO `hh_attribute` VALUES (152, 'tags', 'TAG标签', 'varchar(255) NOT NULL DEFAULT \'\'', 'tags', '', 'TAG标签', 1, 0, '', 5, '', 1, 0, 1, 1603452597, 1603452597, '', '', 0, '', '', '', 0, 60);
INSERT INTO `hh_attribute` VALUES (153, 'thumb', '缩略图', 'varchar(100) NOT NULL DEFAULT \'\'', 'picture', '', '缩略图', 1, 0, '', 5, '', 1, 0, 1, 1603452598, 1603452598, '', '', 0, '', '', '', 0, 50);
INSERT INTO `hh_attribute` VALUES (154, 'source', '来源', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '来源', 1, 0, '', 5, '', 1, 0, 1, 1603452598, 1603452598, '', '', 0, '', '', '', 0, 40);
INSERT INTO `hh_attribute` VALUES (155, 'uid', '管理员ID', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '管理员ID', 0, 0, '', 5, '', 1, 0, 1, 1603452598, 1603452598, '', '', 0, '', '', '', 0, 30);
INSERT INTO `hh_attribute` VALUES (156, 'writer', '作者', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '作者', 1, 0, '', 5, '', 1, 0, 1, 1603452598, 1603452598, '', '', 0, '', '', '', 0, 29);
INSERT INTO `hh_attribute` VALUES (157, 'keywords', '关键词', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '关键词', 1, 0, '', 5, '', 1, 0, 1, 1603452598, 1603452598, '', '', 0, '', '', '', 0, 28);
INSERT INTO `hh_attribute` VALUES (158, 'description', '描述', 'text DEFAULT NULL', 'textarea', '', '描述', 1, 0, '', 5, '', 1, 0, 1, 1603452598, 1603452598, '', '', 0, '', '', '', 0, 27);
INSERT INTO `hh_attribute` VALUES (159, 'content', '内容', 'text DEFAULT NULL', 'editor', '', '内容', 1, 0, '', 5, '', 1, 0, 1, 1603452598, 1603452598, '', '', 0, '', '', '', 0, 26);
INSERT INTO `hh_attribute` VALUES (160, 'view', '浏览量', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '浏览量', 1, 0, '', 5, '', 1, 0, 1, 1603452598, 1603452598, '', '', 0, '', '', '', 0, 25);
INSERT INTO `hh_attribute` VALUES (161, 'title_en', '英文标题', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '英文标题', 1, 0, '', 4, '', 1, 0, 1, 1603452660, 1603452660, '', '', 0, '', '', '', 0, 80);
INSERT INTO `hh_attribute` VALUES (162, 'flags', '自定义属性', 'varchar(100) NOT NULL DEFAULT \'\'', 'checkbox', '', '自定义属性', 1, 0, 'h:头条,c:推荐,f:幻灯,a:特荐,s:滚动,b:加粗,p:图片,j:跳转;', 4, '', 1, 0, 1, 1603452660, 1603452660, '', '', 0, '', '', '', 0, 70);
INSERT INTO `hh_attribute` VALUES (163, 'tags', 'TAG标签', 'varchar(255) NOT NULL DEFAULT \'\'', 'tags', '', 'TAG标签', 1, 0, '', 4, '', 1, 0, 1, 1603452660, 1603452660, '', '', 0, '', '', '', 0, 60);
INSERT INTO `hh_attribute` VALUES (164, 'thumb', '缩略图', 'varchar(100) NOT NULL DEFAULT \'\'', 'picture', '', '缩略图', 1, 0, '', 4, '', 1, 0, 1, 1603452660, 1603452660, '', '', 0, '', '', '', 0, 50);
INSERT INTO `hh_attribute` VALUES (165, 'source', '来源', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '来源', 1, 0, '', 4, '', 1, 0, 1, 1603452660, 1603452660, '', '', 0, '', '', '', 0, 40);
INSERT INTO `hh_attribute` VALUES (166, 'uid', '管理员ID', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '管理员ID', 0, 0, '', 4, '', 1, 0, 1, 1603452660, 1603452660, '', '', 0, '', '', '', 0, 30);
INSERT INTO `hh_attribute` VALUES (167, 'writer', '作者', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '作者', 1, 0, '', 4, '', 1, 0, 1, 1603452660, 1603452660, '', '', 0, '', '', '', 0, 29);
INSERT INTO `hh_attribute` VALUES (168, 'keywords', '关键词', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '关键词', 1, 0, '', 4, '', 1, 0, 1, 1603452660, 1603452660, '', '', 0, '', '', '', 0, 28);
INSERT INTO `hh_attribute` VALUES (169, 'description', '描述', 'text DEFAULT NULL', 'textarea', '', '描述', 1, 0, '', 4, '', 1, 0, 1, 1603452660, 1603452660, '', '', 0, '', '', '', 0, 27);
INSERT INTO `hh_attribute` VALUES (170, 'content', '内容', 'text DEFAULT NULL', 'editor', '', '内容', 1, 0, '', 4, '', 1, 0, 1, 1603452660, 1603452660, '', '', 0, '', '', '', 0, 26);
INSERT INTO `hh_attribute` VALUES (171, 'view', '浏览量', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '浏览量', 1, 0, '', 4, '', 1, 0, 1, 1603452660, 1603452660, '', '', 0, '', '', '', 0, 25);
INSERT INTO `hh_attribute` VALUES (172, 'ceshidutu', '测试多图', 'text DEFAULT NULL', 'piclist', '', '', 1, 0, '', 2, '', 1, 0, 0, 1603805351, 1603805351, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (173, 'id', '主键ID', 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'num', '', '主键ID', 0, 0, '', 11, '', 2, 0, 1, 1604220449, 1604220449, '', '', 0, '', '', '', 0, 100);
INSERT INTO `hh_attribute` VALUES (176, 'status', '状态', 'char(50) NOT NULL DEFAULT \'1\'', 'select', '1', '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)', 1, 0, '-1:删除,0:隐藏,1:显示,2:待审核,3:草稿', 11, '', 1, 0, 1, 1604220449, 1604220449, '', '', 0, '', '', '', 0, 70);
INSERT INTO `hh_attribute` VALUES (177, 'sort', '排序', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '排序', 1, 0, '', 11, '', 1, 0, 1, 1604220449, 1604220449, '', '', 0, '', '', '', 0, 60);
INSERT INTO `hh_attribute` VALUES (178, 'create_time', '创建时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '创建时间', 3, 0, '', 11, '', 1, 0, 1, 1604220449, 1604220449, '', '', 0, '', '', '', 0, 50);
INSERT INTO `hh_attribute` VALUES (179, 'update_time', '更新时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '更新时间', 0, 0, '', 11, '', 1, 0, 1, 1604220449, 1604220449, '', '', 0, '', '', '', 0, 40);
INSERT INTO `hh_attribute` VALUES (180, 'username', '姓名', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 11, '', 1, 0, 1, 1604220648, 1604220648, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (181, 'phone', '手机号码', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 11, '', 1, 0, 1, 1604220673, 1604220673, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (182, 'type', '留言类型', 'char(50) NOT NULL DEFAULT \'\'', 'select', '评价', '', 1, 0, '评价:评价\n意见:意见', 11, '', 1, 0, 1, 1604220775, 1604220775, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (183, 'message', '留言内容', 'text DEFAULT NULL', 'textarea', '', '', 1, 0, '', 11, '', 1, 0, 1, 1604220804, 1604220804, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (185, 'jibie', '级别', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '9', '', 1, 1, '1:号\n2:吧', 2, '', 1, 0, 0, 1606360458, 1606360458, '', '', 0, '', 'function', 'time', 1, 0);
INSERT INTO `hh_attribute` VALUES (186, 'uid', '用户ID', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '用户ID', 0, 0, '', 7, '', 1, 0, 1, 1606968443, 1606968443, '', '', 0, '', '', '', 0, 90);
INSERT INTO `hh_attribute` VALUES (187, 'username', '用户名', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '用户名', 1, 0, '', 7, '', 1, 0, 1, 1606968443, 1606968443, '', '', 0, '', '', '', 0, 80);
INSERT INTO `hh_attribute` VALUES (188, 'ip', 'IP', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', 'IP', 1, 1, '', 7, '', 1, 0, 1, 1606968443, 1606968443, '', '', 0, '', '', '', 0, 70);
INSERT INTO `hh_attribute` VALUES (192, 'id', '主键ID', 'int(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY', 'num', '', '主键ID', 0, 0, '', 6, '', 2, 0, 1, 1607497298, 1607497298, '', '', 0, '', '', '', 0, 100);
INSERT INTO `hh_attribute` VALUES (193, 'uid', '用户ID', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '用户ID', 0, 0, '', 6, '', 1, 0, 1, 1607497298, 1607497298, '', '', 0, '', '', '', 0, 90);
INSERT INTO `hh_attribute` VALUES (194, 'username', '用户名', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '用户名', 1, 0, '', 6, '', 1, 0, 1, 1607497298, 1607497298, '', '', 0, '', '', '', 0, 80);
INSERT INTO `hh_attribute` VALUES (195, 'ip', 'IP', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', 'IP', 1, 1, '', 6, '', 1, 0, 1, 1607497298, 1607497298, '', '', 0, '', '', '', 0, 70);
INSERT INTO `hh_attribute` VALUES (196, 'status', '状态', 'char(50) NOT NULL DEFAULT \'1\'', 'select', '1', '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)', 1, 0, '-1:删除,0:隐藏,1:显示,2:待审核,3:草稿', 6, '', 1, 0, 1, 1607497298, 1607497298, '', '', 0, '', '', '', 0, 60);
INSERT INTO `hh_attribute` VALUES (197, 'sort', '排序', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'num', '0', '排序', 1, 0, '', 6, '', 1, 0, 1, 1607497298, 1607497298, '', '', 0, '', '', '', 0, 50);
INSERT INTO `hh_attribute` VALUES (198, 'create_time', '创建时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '', '创建时间', 3, 0, '', 6, '', 1, 0, 1, 1607497298, 1607497298, '', '', 0, '', '', '', 0, 40);
INSERT INTO `hh_attribute` VALUES (199, 'update_time', '更新时间', 'int(10) UNSIGNED NOT NULL DEFAULT \'0\'', 'datetime', '0', '更新时间', 0, 0, '', 6, '', 1, 0, 1, 1607497298, 1607497298, '', '', 0, '', '', '', 0, 30);
INSERT INTO `hh_attribute` VALUES (200, 'company', '公司名称', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 1, '', 6, '', 1, 0, 1, 1607501082, 1607501082, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (201, 'uname', '您的姓名', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 0, '', 6, '', 1, 1, 1, 1607501106, 1607501106, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (202, 'contact', '手机 / QQ', 'varchar(255) NOT NULL DEFAULT \'\'', 'string', '', '', 1, 1, '', 6, '', 1, 0, 1, 1607501179, 1607501179, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (203, 'title', '评价 / 意见', 'char(10) NOT NULL DEFAULT \'\'', 'radio', '评价', '', 1, 0, '评价:评价\n意见:意见', 6, '', 1, 0, 1, 1607501320, 1607501320, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (204, 'content', '留言内容', 'text DEFAULT NULL', 'textarea', '', '', 1, 0, '', 6, '', 1, 0, 1, 1607501356, 1607501356, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (207, 'sign', '标志', 'varchar(100) NOT NULL DEFAULT \'\'', 'checkbox', '', '', 1, 0, '1:热门\n2:最新', 0, 'arctype', 1, 0, 1, 1608022257, 1608022257, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (208, 'target', '窗口类型', 'char(50) NOT NULL DEFAULT \'\'', 'select', '_self', '', 1, 0, '_blank:_blank在新窗口中打开被链接文档\n_self:_self默认。在相同的框架中打开被链接文档\n_parent:_parent在父框架集中打开被链接文档\n_top:_top在整个窗口中打开被链接文档\nframename:framename在指定的框架中打开被链接文档', 0, 'arctype', 1, 0, 1, 1608042420, 1608042420, '', '', 0, '', '', '', 0, 0);
INSERT INTO `hh_attribute` VALUES (209, 'rel', 'rel 属性', 'char(50) NOT NULL DEFAULT \'\'', 'select', '', '', 1, 0, 'nofllow:nofllow用于指定Google搜索引擎不要跟踪链接\nexternal:external属性的意思是告诉搜索引擎，这个链接不是本站链接\nnoopener noreferrer:noopener noreferrer在新打开的页面（baidu）中可以通过 window.opener获取到源页面的部分控制权， 即使新打开的页面是跨域的也照样可以（例如 location 就不存在跨域问题）', 0, 'arctype', 1, 0, 1, 1608042483, 1608042483, '', '', 0, '', '', '', 0, 0);

-- ----------------------------
-- Table structure for hh_auth_group
-- ----------------------------
DROP TABLE IF EXISTS `hh_auth_group`;
CREATE TABLE `hh_auth_group`  (
  `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `title` char(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '用户组中文名称',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '说明',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态：为1正常，为0禁用',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `rules` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '用户组拥有的规则id，多个规则\",\"隔开，星号\"*\"代表拥有所有规则',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后一次修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户组(或角色)表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_auth_group
-- ----------------------------
INSERT INTO `hh_auth_group` VALUES (1, '超级管理员', '超级权限', 1, 100, '*', 1539677649, 1539681432);
INSERT INTO `hh_auth_group` VALUES (2, '栏目管理员', '栏目管理员', 1, 90, '137,138,475,371,365,180,179,178,177,176', 1539677661, 1586360648);
INSERT INTO `hh_auth_group` VALUES (3, '文档管理员', '文档管理员', 1, 80, '510,3,5,23,137,370,672,673,139,373,372,369,187,186,185,184,183,182', 1539757356, 1563942756);

-- ----------------------------
-- Table structure for hh_auth_group_access
-- ----------------------------
DROP TABLE IF EXISTS `hh_auth_group_access`;
CREATE TABLE `hh_auth_group_access`  (
  `uid` mediumint(8) UNSIGNED NOT NULL COMMENT '用户id',
  `group_id` mediumint(8) UNSIGNED NOT NULL COMMENT '用户组id',
  UNIQUE INDEX `uid_group_id`(`uid`, `group_id`) USING BTREE,
  INDEX `uid`(`uid`) USING BTREE,
  INDEX `group_id`(`group_id`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户组(或角色)明细表' ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of hh_auth_group_access
-- ----------------------------
INSERT INTO `hh_auth_group_access` VALUES (1, 1);
INSERT INTO `hh_auth_group_access` VALUES (17, 3);

-- ----------------------------
-- Table structure for hh_auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `hh_auth_rule`;
CREATE TABLE `hh_auth_rule`  (
  `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `pid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级规则id；0表示顶级规则',
  `title` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '规则中文名称',
  `title_en` char(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '规则英文名称',
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '规则唯一标识',
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '如果type为1， condition字段就可以定义规则表达式',
  `condition` char(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '规则附件条件,满足附加条件的规则,才认为是有效的规则',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：为1正常，为0禁用',
  `show` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '菜单是否显示；1：显示；0：不显示',
  `icon` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '图标名称',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '说明',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后一次修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 829 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '规则(或菜单)表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_auth_rule
-- ----------------------------
INSERT INTO `hh_auth_rule` VALUES (1, 510, '系统设置', 'System Settings', 'admin/SystemSettings', 1, '', 1, 1, 'cog', '系统设置', 98, 1539677434, 1606123900);
INSERT INTO `hh_auth_rule` VALUES (2, 510, '数据管理', 'Data Manager', 'admin/Database/Data', 1, '', 1, 1, 'database', '数据备份', 96, 1539677499, 1606574194);
INSERT INTO `hh_auth_rule` VALUES (3, 510, '系统管理', 'System Manager', 'admin/SystemManager', 1, '', 1, 1, 'user', '系统管理员', 97, 1539677567, 1606123937);
INSERT INTO `hh_auth_rule` VALUES (4, 510, '系统主页', 'System Home Page', 'admin/Index/welcome', 1, '', 1, 0, 'home', '', 99, 1539677605, 1606121981);
INSERT INTO `hh_auth_rule` VALUES (5, 3, '系管理员', 'Admin', 'admin/Admin/index', 1, '', 1, 1, '', '管理员', 100, 1539677748, 1606124686);
INSERT INTO `hh_auth_rule` VALUES (6, 3, '角色管理', 'Role Manager', 'admin/AuthGroup/index', 1, '', 1, 1, '', '角色管理', 90, 1539677780, 1606124696);
INSERT INTO `hh_auth_rule` VALUES (7, 5, '新增', '', 'admin/Admin/add', 1, '', 1, 0, '', '新增管理员', 1, 1539677828, 1606124745);
INSERT INTO `hh_auth_rule` VALUES (465, 385, '广告位', 'Adtype', 'admin/cms.Adtype/index', 1, '', 1, 0, '', '', 0, 1603623048, 1606006721);
INSERT INTO `hh_auth_rule` VALUES (672, 370, '左侧栏目', 'Arctype', 'admin/cms.Document/arctype', 1, '', 1, 0, '', '', 100, 1606534625, 0);
INSERT INTO `hh_auth_rule` VALUES (10, 6, '新增', '', 'admin/AuthGroup/add', 1, '', 1, 0, '', '', 0, 1539677925, 1606124973);
INSERT INTO `hh_auth_rule` VALUES (14, 510, '菜单管理', 'Menu Manager', 'admin/Menu/index', 1, '', 1, 1, 'window-maximize', 'navicon', 0, 1539678720, 1606573857);
INSERT INTO `hh_auth_rule` VALUES (15, 14, '新增', '', 'admin/Menu/add', 1, '', 1, 0, 'audio-description', '', 0, 1539678737, 1606122263);
INSERT INTO `hh_auth_rule` VALUES (17, 1, '配置类型', 'Configuration Type List', 'admin/ConfigType/index', 1, '', 1, 1, 'navicon', '', 80, 1539678800, 1582852940);
INSERT INTO `hh_auth_rule` VALUES (18, 17, '新增', '', 'admin/ConfigType/add', 1, '', 1, 0, 'audio-description', '', 0, 1539678819, 1606124537);
INSERT INTO `hh_auth_rule` VALUES (19, 1, '配置管理', 'Configuration Manager', 'admin/Config/index', 1, '', 1, 1, '', '', 90, 1539678842, 1606573943);
INSERT INTO `hh_auth_rule` VALUES (21, 19, '新增', '', 'admin/Config/add', 1, '', 1, 0, 'audio-description', '', 0, 1539678947, 1606124576);
INSERT INTO `hh_auth_rule` VALUES (23, 5, '编辑', '', 'admin/Admin/edit', 1, '', 1, 0, '', '', 0, 1539833970, 1606124751);
INSERT INTO `hh_auth_rule` VALUES (30, 3, '操作日志', 'Operational Log', 'admin/Log/index', 1, '', 1, 1, '', '', 0, 1541302717, 1563806750);
INSERT INTO `hh_auth_rule` VALUES (31, 5, '删除', '', 'admin/Admin/del', 1, '', 1, 0, '', '', 0, 1542983690, 1606124758);
INSERT INTO `hh_auth_rule` VALUES (32, 5, '状态', '', 'admin/Admin/setStatus', 1, '', 1, 0, '', '', 0, 1542983725, 1606124765);
INSERT INTO `hh_auth_rule` VALUES (33, 5, '所属角色', '', 'admin/Admin/role', 1, '', 1, 0, '', '', 0, 1542983759, 1606124773);
INSERT INTO `hh_auth_rule` VALUES (34, 5, '排序', '', 'admin/Admin/sort', 1, '', 1, 0, '', '', 0, 1542983793, 1606124780);
INSERT INTO `hh_auth_rule` VALUES (35, 6, '编辑', '', 'admin/AuthGroup/edit', 1, '', 1, 0, '', '', 0, 1542983866, 1606124980);
INSERT INTO `hh_auth_rule` VALUES (36, 6, '删除', '', 'admin/AuthGroup/del', 1, '', 1, 0, '', '', 0, 1542983890, 1606124986);
INSERT INTO `hh_auth_rule` VALUES (37, 6, '状态', '', 'admin/AuthGroup/setStatus', 1, '', 1, 0, '', '', 0, 1542983928, 1606124992);
INSERT INTO `hh_auth_rule` VALUES (38, 6, '排序', '', 'admin/AuthGroup/sort', 1, '', 1, 0, '', '', 0, 1542983948, 1606125012);
INSERT INTO `hh_auth_rule` VALUES (39, 6, '访问授权', '', 'admin/AuthGroup/access', 1, '', 1, 0, '', '', 0, 1542984012, 1606125020);
INSERT INTO `hh_auth_rule` VALUES (40, 6, '成员授权', '', 'admin/AuthGroup/user', 1, '', 1, 0, '', '', 0, 1542984046, 1606125027);
INSERT INTO `hh_auth_rule` VALUES (41, 6, '解除成员授权', '', 'admin/AuthGroup/remove_user', 1, '', 1, 0, '', '', 0, 1542984077, 1606125035);
INSERT INTO `hh_auth_rule` VALUES (42, 6, '新增成员', '', 'admin/AuthGroup/add_to_group_access', 1, '', 1, 0, '', '', 0, 1542984115, 1606125041);
INSERT INTO `hh_auth_rule` VALUES (43, 6, '角色收缩', '', 'admin/AuthGroup/shrink', 1, '', 1, 0, '', '', 0, 1542984149, 1606125050);
INSERT INTO `hh_auth_rule` VALUES (44, 30, '查看日志详情', '', 'admin/Log/log_content', 1, '', 1, 0, '', '', 0, 1542985443, 1606124185);
INSERT INTO `hh_auth_rule` VALUES (45, 30, '删除操作日志', '', 'admin/Log/del', 1, '', 1, 0, '', '', 0, 1542985472, 1606124191);
INSERT INTO `hh_auth_rule` VALUES (46, 30, '恢复操作日志', '', 'admin/Log/recover', 1, '', 1, 0, '', '', 0, 1542985494, 1606124197);
INSERT INTO `hh_auth_rule` VALUES (47, 30, '清空操作日志', '', 'admin/Log/clear_log', 1, '', 1, 0, '', '', 0, 1542985520, 1606124203);
INSERT INTO `hh_auth_rule` VALUES (59, 1, '网站配置', 'Website Configuration', 'admin/Config/configuration', 1, '', 1, 1, '', '', 100, 1543023807, 1606573937);
INSERT INTO `hh_auth_rule` VALUES (60, 19, '编辑', '', 'admin/Config/edit', 1, '', 1, 0, '', '', 0, 1543024263, 1606124581);
INSERT INTO `hh_auth_rule` VALUES (61, 19, '删除', '', 'admin/Config/del', 1, '', 1, 0, '', '', 0, 1543024279, 1606124586);
INSERT INTO `hh_auth_rule` VALUES (62, 19, '状态', '', 'admin/Config/setStatus', 1, '', 1, 0, '', '', 0, 1543024326, 1606124591);
INSERT INTO `hh_auth_rule` VALUES (63, 19, '排序', '', 'admin/Config/sort', 1, '', 1, 0, '', '', 0, 1543024349, 1606124597);
INSERT INTO `hh_auth_rule` VALUES (64, 59, '下载配置文件', '', 'admin/Config/download', 1, '', 1, 0, '', '', 0, 1543024395, 1606124312);
INSERT INTO `hh_auth_rule` VALUES (65, 59, '删除配置文件', '', 'admin/Config/delete_file', 1, '', 1, 0, '', '', 0, 1543024417, 1606124318);
INSERT INTO `hh_auth_rule` VALUES (66, 17, '编辑', '', 'admin/ConfigType/edit', 1, '', 1, 0, '', '', 0, 1543024462, 1606124544);
INSERT INTO `hh_auth_rule` VALUES (67, 17, '删除', '', 'admin/ConfigType/del', 1, '', 1, 0, '', '', 0, 1543024489, 1606124550);
INSERT INTO `hh_auth_rule` VALUES (68, 17, '状态', '', 'admin/ConfigType/setStatus', 1, '', 1, 0, '', '', 0, 1543024514, 1606124558);
INSERT INTO `hh_auth_rule` VALUES (69, 17, '排序', '', 'admin/ConfigType/sort', 1, '', 1, 0, '', '', 0, 1543024544, 1606124565);
INSERT INTO `hh_auth_rule` VALUES (70, 14, '编辑', '', 'admin/Menu/edit', 1, '', 1, 0, '', '', 0, 1543024589, 1606122270);
INSERT INTO `hh_auth_rule` VALUES (71, 14, '删除', '', 'admin/Menu/del', 1, '', 1, 0, '', '', 0, 1543024619, 1606122278);
INSERT INTO `hh_auth_rule` VALUES (72, 14, '正 / 禁', '', 'admin/Menu/setStatus', 1, '', 1, 0, '', '', 0, 1543024646, 1606122483);
INSERT INTO `hh_auth_rule` VALUES (73, 14, '显 / 隐', '', 'admin/Menu/setShow', 1, '', 1, 0, '', '', 0, 1543024695, 1606122333);
INSERT INTO `hh_auth_rule` VALUES (74, 14, '排序', '', 'admin/Menu/sort', 1, '', 1, 0, '', '', 0, 1543024708, 1606122383);
INSERT INTO `hh_auth_rule` VALUES (75, 14, '移动', '', 'admin/Menu/move', 1, '', 1, 0, '', '', 0, 1543024735, 1606122390);
INSERT INTO `hh_auth_rule` VALUES (78, 510, '文件管理', 'File Manager', 'admin/File/index', 1, '{id}>0 and {id}<18', 1, 1, 'folder-open', 'admin/File/index?status=1&type=1注意参数一定要小写\r\n例：admin/File/index?status=1&type=23&currdir=E:/www/thinkphp/tp6.0.x/layuimini/public/static/uploads', 94, 1552959460, 1606123339);
INSERT INTO `hh_auth_rule` VALUES (79, 2, '数据备份', 'Database Backup', 'admin/Database/index', 1, '', 1, 1, '', '', 96, 1553307587, 1606574184);
INSERT INTO `hh_auth_rule` VALUES (80, 3, '行为日志', 'Behavior Log', 'admin/Logs/index', 1, '', 1, 1, '', '', 1, 1553333609, 1606124717);
INSERT INTO `hh_auth_rule` VALUES (81, 510, '检查更新', 'Check For Updates', 'admin/Update/index', 1, '', 1, 1, 'paper-plane', '', 93, 1553352988, 1606573889);
INSERT INTO `hh_auth_rule` VALUES (86, 2, 'SQL工具', 'SQL Command Line Tool', 'admin/Data/sql_index', 1, '', 1, 1, '', 'SQL命令行工具', 0, 1553396428, 1601855814);
INSERT INTO `hh_auth_rule` VALUES (88, 78, '删除文件', '', 'admin/File/del', 1, '', 1, 0, '', '', 92, 1554514448, 1606123350);
INSERT INTO `hh_auth_rule` VALUES (89, 78, '重命名', '', 'admin/File/renames', 1, '', 1, 0, '', '', 95, 1554514493, 1606123362);
INSERT INTO `hh_auth_rule` VALUES (90, 78, '新建文件', '', 'admin/File/new_file', 1, '', 1, 0, '', '', 90, 1554514532, 1606123373);
INSERT INTO `hh_auth_rule` VALUES (91, 78, '新建文件夹', '', 'admin/File/new_folder', 1, '', 1, 0, '', '', 91, 1554514570, 1606123380);
INSERT INTO `hh_auth_rule` VALUES (92, 78, '文件上传', '', 'admin/File/upload_file', 1, '', 1, 0, '', '', 89, 1554514593, 1606123500);
INSERT INTO `hh_auth_rule` VALUES (95, 78, '文件内容编辑', '', 'admin/File/edit', 1, '', 1, 0, '', '', 100, 1554514711, 1607865078);
INSERT INTO `hh_auth_rule` VALUES (96, 78, '文件下载', '', 'admin/File/download', 1, '', 1, 0, '', '', 94, 1554514736, 1606123472);
INSERT INTO `hh_auth_rule` VALUES (99, 86, '执行sql语句', '', 'admin/Data/sql_query', 1, '', 1, 0, '', '', 0, 1554520109, 1606123627);
INSERT INTO `hh_auth_rule` VALUES (100, 86, '获取表结构和insert数据语句', '', 'admin/Data/get_table_insert', 1, '', 1, 0, '', '', 0, 1554520178, 1606123634);
INSERT INTO `hh_auth_rule` VALUES (101, 86, '单表修复', '', 'admin/Data/repair', 1, '', 1, 0, '', '', 0, 1554520222, 1606123640);
INSERT INTO `hh_auth_rule` VALUES (102, 86, '单表优化', '', 'admin/Data/optimize', 1, '', 1, 0, '', '', 0, 1554520240, 1606123646);
INSERT INTO `hh_auth_rule` VALUES (103, 86, '批量修复', '', 'admin/Data/repairAll', 1, '', 1, 0, '', '', 0, 1554520258, 1606123652);
INSERT INTO `hh_auth_rule` VALUES (104, 86, '批量优化', '', 'admin/Data/optimizeAll', 1, '', 1, 0, '', '', 0, 1554520279, 1606123677);
INSERT INTO `hh_auth_rule` VALUES (105, 80, '删除行为日志', '', 'admin/Logs/del', 1, '', 1, 0, '', '', 0, 1554520680, 1606125086);
INSERT INTO `hh_auth_rule` VALUES (106, 80, '清空行为日志', '', 'admin/Logs/clear_log', 1, '', 1, 0, '', '', 0, 1554520706, 1606125091);
INSERT INTO `hh_auth_rule` VALUES (107, 81, '在线更新', '', 'admin/Update/isbackupfile', 1, '', 1, 0, '', '', 0, 1554521009, 1606122514);
INSERT INTO `hh_auth_rule` VALUES (108, 79, '单表的修复', '', 'admin/Database/repair', 1, '', 1, 0, '', '', 0, 1554521541, 1606123786);
INSERT INTO `hh_auth_rule` VALUES (109, 79, '单表的优化', '', 'admin/Database/optimize', 1, '', 1, 0, '', '', 0, 1554521555, 1606123792);
INSERT INTO `hh_auth_rule` VALUES (110, 79, '表的批量修复', '', 'admin/Database/repairAll', 1, '', 1, 0, '', '', 0, 1554521570, 1606123798);
INSERT INTO `hh_auth_rule` VALUES (111, 79, '表的批量优化', '', 'admin/Database/optimizeAll', 1, '', 1, 0, '', '', 0, 1554521587, 1606123770);
INSERT INTO `hh_auth_rule` VALUES (112, 79, '备份列表', '', 'admin/Database/backuplst', 1, '', 1, 0, '', '', 0, 1554521601, 1606123763);
INSERT INTO `hh_auth_rule` VALUES (113, 79, '数据的备份', '', 'admin/Database/dbbackup', 1, '', 1, 0, '', '', 0, 1554521614, 1606123748);
INSERT INTO `hh_auth_rule` VALUES (114, 79, '数据的还原', '', 'admin/Database/restore', 1, '', 1, 0, '', '', 0, 1554521627, 1606123740);
INSERT INTO `hh_auth_rule` VALUES (115, 79, '删除数据备份', '', 'admin/Database/del', 1, '', 1, 0, '', '', 0, 1554521640, 1606123733);
INSERT INTO `hh_auth_rule` VALUES (116, 79, '备份下载', '', 'admin/Database/download', 1, '', 1, 0, '', '', 0, 1554521654, 1606123722);
INSERT INTO `hh_auth_rule` VALUES (117, 79, '备份上传', '', 'admin/Database/upload', 1, '', 1, 0, '', '', 0, 1554521667, 1606123708);
INSERT INTO `hh_auth_rule` VALUES (130, 137, '模型管理', 'Model Management', 'admin/cms.ModelManager', 1, '', 1, 1, 'maxcdn', '', 60, 1555729995, 1606014550);
INSERT INTO `hh_auth_rule` VALUES (131, 130, '模型列表', 'Model List', 'admin/cms.Model/index', 1, '', 1, 1, '', '', 20, 1555730031, 1606015487);
INSERT INTO `hh_auth_rule` VALUES (132, 131, '新增', '', 'admin/cms.Model/add', 1, '', 1, 0, '', '', 0, 1555810122, 1606015502);
INSERT INTO `hh_auth_rule` VALUES (133, 131, '编辑', '', 'admin/cms.Model/edit', 1, '', 1, 0, '', '', 0, 1555810133, 1606015512);
INSERT INTO `hh_auth_rule` VALUES (134, 131, '删除', '', 'admin/cms.Model/del', 1, '', 1, 0, '', '', 0, 1555810159, 1606015521);
INSERT INTO `hh_auth_rule` VALUES (135, 131, '状态', '', 'admin/cms.Model/setStatus', 1, '', 1, 0, '', '', 0, 1555810192, 1606015534);
INSERT INTO `hh_auth_rule` VALUES (136, 131, '排序', '', 'admin/cms.Model/sort', 1, '', 1, 0, '', '', 0, 1555810207, 1606015548);
INSERT INTO `hh_auth_rule` VALUES (137, 0, 'CMS', 'CMS', 'admin/Cms', 1, '', 1, 1, 'laptop', 'CMS管理', 80, 1555850475, 1605833965);
INSERT INTO `hh_auth_rule` VALUES (138, 137, '栏目管理', 'Arctype Manager', 'admin/cms.Arctype/index', 1, '', 1, 1, 'list', '', 84, 1555850506, 1606573680);
INSERT INTO `hh_auth_rule` VALUES (139, 370, '右侧文档', 'Document', 'admin/cms.Document/document', 1, '', 1, 0, 'file', '', 83, 1555916789, 1606534650);
INSERT INTO `hh_auth_rule` VALUES (141, 137, '友情链接', 'Friendship Links', 'admin/cms.Links/index', 1, '', 1, 1, 'link', '', 100, 1555916845, 1606003192);
INSERT INTO `hh_auth_rule` VALUES (144, 130, '联动类别', 'Select', 'admin/cms.Select/index', 1, '', 1, 1, '', '', 0, 1555940098, 1606015581);
INSERT INTO `hh_auth_rule` VALUES (145, 137, '优化设置', 'Optimize settings', 'admin/cms.Seoset', 1, '', 1, 1, 'wrench', '', 81, 1556853036, 1606011934);
INSERT INTO `hh_auth_rule` VALUES (146, 145, '首页优化', 'Index Optimization', 'admin/cms.Seoset/site', 1, '', 1, 1, '', '', 100, 1556853078, 1606011852);
INSERT INTO `hh_auth_rule` VALUES (147, 145, '栏目优化', 'Arctype Optimization', 'admin/cms.Seoset/category', 1, '', 1, 1, '', '', 90, 1556853111, 1606011861);
INSERT INTO `hh_auth_rule` VALUES (148, 145, '地区优化', 'Regional Optimization', 'admin/cms.Seoset/area', 1, '', 1, 1, '', '', 60, 1556853131, 1606011882);
INSERT INTO `hh_auth_rule` VALUES (149, 145, '长尾词优化', 'Long-tailed Word Optimization', 'admin/cms.Seoset/longKey', 1, '', 1, 0, '', '', 0, 1556863807, 1606011897);
INSERT INTO `hh_auth_rule` VALUES (167, 137, '更新管理', 'Update Manager', 'admin/cms.Update', 1, '', 1, 1, 'paper-plane', '', 80, 1560395598, 1606013109);
INSERT INTO `hh_auth_rule` VALUES (169, 167, '更新主页HTML', 'Update The Main HTML', 'admin/cms.Update/index', 1, '', 1, 1, '', '', 0, 1560399777, 1608439190);
INSERT INTO `hh_auth_rule` VALUES (170, 167, '更新栏目HTML', 'Update Arctype HTML', 'admin/cms.Update/category', 1, '', 1, 1, '', '', 0, 1560399816, 1608439200);
INSERT INTO `hh_auth_rule` VALUES (171, 167, '更新文档HTML', 'Update Document HTML', 'admin/cms.Update/document', 1, '', 1, 1, '', '', 0, 1560399851, 1608439211);
INSERT INTO `hh_auth_rule` VALUES (176, 138, '新增', '', 'admin/cms.Arctype/add', 1, '', 1, 0, '', '', 0, 1560849615, 1606009136);
INSERT INTO `hh_auth_rule` VALUES (177, 138, '编辑', '', 'admin/cms.Arctype/edit', 1, '', 1, 0, '', '', 0, 1560849651, 1606009217);
INSERT INTO `hh_auth_rule` VALUES (178, 138, '删除', '', 'admin/cms.Arctype/del', 1, '', 1, 0, '', '', 0, 1560849685, 1606009229);
INSERT INTO `hh_auth_rule` VALUES (179, 138, '状态', '', 'admin/cms.Arctype/setStatus', 1, '', 1, 0, '', '', 0, 1560849731, 1606009244);
INSERT INTO `hh_auth_rule` VALUES (180, 138, '排序', '', 'admin/cms.Arctype/sort', 1, '', 1, 0, '', '', 0, 1560849763, 1606009257);
INSERT INTO `hh_auth_rule` VALUES (182, 139, '新增', '', 'admin/cms.Document/add', 1, '', 1, 0, '', '', 0, 1560849915, 1606010517);
INSERT INTO `hh_auth_rule` VALUES (183, 139, '编辑', '', 'admin/cms.Document/edit', 1, '', 1, 0, '', '', 0, 1560849953, 1606010528);
INSERT INTO `hh_auth_rule` VALUES (184, 139, '删除', '', 'admin/cms.Document/del', 1, '', 1, 0, '', '', 0, 1560849995, 1606010537);
INSERT INTO `hh_auth_rule` VALUES (185, 139, '状态', '', 'admin/cms.Document/set_status', 1, '', 1, 0, '', '', 0, 1560850026, 1606010549);
INSERT INTO `hh_auth_rule` VALUES (186, 139, '排序', '', 'admin/cms.Document/set_sort', 1, '', 1, 0, '', '', 0, 1560850067, 1606010662);
INSERT INTO `hh_auth_rule` VALUES (187, 139, '移动', '', 'admin/cms.Document/move', 1, '', 1, 0, '', '', 0, 1560850097, 1606010716);
INSERT INTO `hh_auth_rule` VALUES (192, 141, '链接类型', 'Link Type', 'admin/cms.LinkType/index', 1, '', 1, 0, '', '', 0, 1560850594, 1606003761);
INSERT INTO `hh_auth_rule` VALUES (193, 192, '新增', '', 'admin/cms.LinkType/add', 1, '', 1, 1, '', '', 0, 1560850624, 1606006496);
INSERT INTO `hh_auth_rule` VALUES (194, 192, '编辑', '', 'admin/cms.LinkType/edit', 1, '', 1, 1, '', '', 0, 1560850660, 1606006502);
INSERT INTO `hh_auth_rule` VALUES (195, 192, '删除', '', 'admin/cms.LinkType/del', 1, '', 1, 1, '', '', 0, 1560850685, 1606006509);
INSERT INTO `hh_auth_rule` VALUES (196, 192, '排序', '', 'admin/cms.LinkType/sort', 1, '', 1, 1, '', '', 0, 1560850715, 1606006516);
INSERT INTO `hh_auth_rule` VALUES (197, 141, '新增', '', 'admin/cms.Links/add', 1, '', 1, 0, '', '', 0, 1560850764, 1606006485);
INSERT INTO `hh_auth_rule` VALUES (198, 141, '编辑', '', 'admin/cms.Links/edit', 1, '', 1, 0, '', '', 0, 1560850791, 1606006479);
INSERT INTO `hh_auth_rule` VALUES (199, 141, '删除', '', 'admin/cms.Links/del', 1, '', 1, 0, '', '', 0, 1560850816, 1606006472);
INSERT INTO `hh_auth_rule` VALUES (200, 141, '排序', '', 'admin/cms.Links/sort', 1, '', 1, 0, '', '', 0, 1560850848, 1606006466);
INSERT INTO `hh_auth_rule` VALUES (201, 141, '状态', '', 'admin/cms.Links/setStatus', 1, '', 1, 0, '', '', 0, 1560850892, 1606006459);
INSERT INTO `hh_auth_rule` VALUES (213, 144, '新增', '', 'admin/cms.Select/add', 1, '', 1, 0, '', '', 0, 1560852030, 1606024630);
INSERT INTO `hh_auth_rule` VALUES (214, 144, '编辑', '', 'admin/cms.Select/edit', 1, '', 1, 0, '', '', 0, 1560852101, 1606024646);
INSERT INTO `hh_auth_rule` VALUES (215, 144, '删除', '', 'admin/cms.Select/del', 1, '', 1, 0, '', '', 0, 1560852142, 1606024657);
INSERT INTO `hh_auth_rule` VALUES (216, 144, '查看子分类', '', 'admin/cms.Select/list_select', 1, '', 1, 0, '', '', 0, 1560852196, 1606024674);
INSERT INTO `hh_auth_rule` VALUES (225, 145, '优化操作', 'Optimizing Operation', 'admin/cms.Seoset/operate', 1, '', 1, 0, '', '', 0, 1560853526, 1606011912);
INSERT INTO `hh_auth_rule` VALUES (226, 147, '编辑栏目', '', 'admin/cms.Seoset/editCategory', 1, '', 1, 0, '', '', 0, 1560853595, 1606012016);
INSERT INTO `hh_auth_rule` VALUES (227, 86, '清空表数据', '', 'admin/Data/clear_table_data', 1, '', 1, 0, '', '', 0, 1560855006, 1606123672);
INSERT INTO `hh_auth_rule` VALUES (228, 86, '删除表', '', 'admin/Data/del_table', 1, '', 1, 0, '', '', 0, 1560855033, 1606123665);
INSERT INTO `hh_auth_rule` VALUES (229, 78, '图片裁剪', '', 'admin/File/crop', 1, '', 1, 0, '', '', 93, 1560858064, 1606123456);
INSERT INTO `hh_auth_rule` VALUES (230, 78, '剪切文件', '', 'admin/File/cut_file', 1, '', 1, 0, '', '', 96, 1560858118, 1606123447);
INSERT INTO `hh_auth_rule` VALUES (231, 78, '剪切文件夹', '', 'admin/File/cut_folder', 1, '', 1, 0, '', '', 97, 1560858146, 1606123439);
INSERT INTO `hh_auth_rule` VALUES (232, 78, '复制文件', '', 'admin/File/copy_file', 1, '', 1, 0, '', '', 98, 1560858177, 1606123431);
INSERT INTO `hh_auth_rule` VALUES (233, 78, '复制文件夹', '', 'admin/File/copy_folder', 1, '', 1, 0, '', '', 99, 1560858207, 1606123421);
INSERT INTO `hh_auth_rule` VALUES (296, 81, '上传更新包', '', 'admin/Update/upload', 1, '', 1, 0, '', '', 0, 1561909404, 1606122508);
INSERT INTO `hh_auth_rule` VALUES (297, 81, '接收更新包', '', 'admin/Update/receive_upload', 1, '', 1, 0, '', '', 0, 1561909451, 1606122525);
INSERT INTO `hh_auth_rule` VALUES (301, 299, '自动回复', 'Automatic response', 'admin/WechatHelper/wechat_keyword', 1, '', 1, 1, '', '', 0, 1564973866, 1567612012);
INSERT INTO `hh_auth_rule` VALUES (302, 299, '菜单设置', 'Menu Settings', 'admin/WechatHelper/wechat_menu', 1, '', 1, 1, '', '', 0, 1564973914, 1567612029);
INSERT INTO `hh_auth_rule` VALUES (303, 299, '素材管理', 'Material management', 'admin/WechatHelper/wechat_material', 1, '', 1, 1, '', '', 0, 1564973966, 1567612082);
INSERT INTO `hh_auth_rule` VALUES (304, 299, '消息列表', 'Message List', 'admin/WechatHelper/wechat_message', 1, '', 1, 1, '', '', 0, 1564974000, 1567612098);
INSERT INTO `hh_auth_rule` VALUES (306, 510, '系统首页', 'System Home Page', 'admin/Index/index', 1, '', 1, 0, 'home', '', 100, 1566787108, 0);
INSERT INTO `hh_auth_rule` VALUES (307, 300, '设置头尾模板', 'Setting Head and Tail Templates', 'admin/WechatHelper/wechat_edittemplate', 1, '', 1, 0, '', '', 0, 1567651858, 0);
INSERT INTO `hh_auth_rule` VALUES (308, 300, '推送列表', 'Push List', 'admin/WechatHelper/wechat_pushlist', 1, '', 1, 0, '', '', 0, 1567652125, 0);
INSERT INTO `hh_auth_rule` VALUES (309, 300, '正在推送', 'Pushing', 'admin/WechatHelper/wechat_dopush', 1, '', 1, 0, '', '', 0, 1567652643, 0);
INSERT INTO `hh_auth_rule` VALUES (310, 301, '新增或编辑关键词规则', 'Added or edited keyword rules', 'admin/WechatHelper/wechat_editkeyword', 1, '', 1, 0, '', '', 0, 1567653469, 0);
INSERT INTO `hh_auth_rule` VALUES (311, 301, '删除关键词规则', 'Delete keyword rules', 'admin/WechatHelper/wechat_delkeyword', 1, '', 1, 0, '', '', 0, 1567653573, 0);
INSERT INTO `hh_auth_rule` VALUES (312, 302, '编辑或添加菜单', 'Edit or add menus', 'admin/WechatHelper/wechat_editmenu', 1, '', 1, 0, '', '', 0, 1567655119, 0);
INSERT INTO `hh_auth_rule` VALUES (313, 302, '删除微信菜单', 'Delete the Wechat menu', 'admin/WechatHelper/wechat_delmenu', 1, '', 1, 0, '', '', 0, 1567655285, 0);
INSERT INTO `hh_auth_rule` VALUES (314, 302, '更新菜单到公众号', 'Update menu to public number', 'admin/WechatHelper/wechat_createmenu', 1, '', 1, 0, '', '', 0, 1567655351, 0);
INSERT INTO `hh_auth_rule` VALUES (315, 302, '删除公众号所有菜单', 'Delete all menus with public numbers', 'admin/WechatHelper/wechat_delallmenu', 1, '', 1, 0, '', '', 0, 1567655421, 0);
INSERT INTO `hh_auth_rule` VALUES (316, 304, '回复消息', 'Reply to the message', 'admin/WechatHelper/wechat_replymessage', 1, '', 1, 0, '', '', 0, 1567656968, 0);
INSERT INTO `hh_auth_rule` VALUES (317, 304, '删除消息', 'removal message', 'admin/WechatHelper/wechat_delmessage', 1, '', 1, 0, '', '', 0, 1567657142, 0);
INSERT INTO `hh_auth_rule` VALUES (318, 304, '查看用户详细信息', 'View user details', 'admin/WechatHelper/wechat_showuserinfo', 1, '', 1, 0, '', '', 0, 1567657278, 0);
INSERT INTO `hh_auth_rule` VALUES (319, 303, '获取素材列表', 'Get a list of materials', 'admin/WechatHelper/wechat_getmateriallist', 1, '', 1, 0, '', '', 0, 1567659123, 0);
INSERT INTO `hh_auth_rule` VALUES (320, 303, '新增素材', 'Additional material', 'admin/WechatHelper/wechat_addmaterial', 1, '', 1, 0, '', '', 0, 1567659858, 0);
INSERT INTO `hh_auth_rule` VALUES (321, 303, '预览素材', 'Preview material', 'admin/WechatHelper/wechat_getmaterial', 1, '', 1, 0, '', '', 0, 1567660767, 0);
INSERT INTO `hh_auth_rule` VALUES (322, 303, '删除素材', 'Delete material', 'admin/WechatHelper/wechat_delmaterial', 1, '', 1, 0, '', '', 0, 1567660856, 0);
INSERT INTO `hh_auth_rule` VALUES (323, 304, '下载临时素材', 'Download temporary material', 'admin/WechatHelper/downloadmaterial', 1, '', 1, 0, '', '', 0, 1567918524, 0);
INSERT INTO `hh_auth_rule` VALUES (326, 137, 'TAG管理', 'TAG Manager', 'admin/cms.Tag/index', 1, '', 1, 1, 'tag', 'TAG标签管理', 88, 1569831801, 1606574102);
INSERT INTO `hh_auth_rule` VALUES (366, 78, '文件压缩', '', 'admin/File/compress', 1, '', 1, 0, '', '', 87, 1599486520, 1606123402);
INSERT INTO `hh_auth_rule` VALUES (338, 510, '附件管理', 'Attachment Manager', 'admin/Attachment/index', 1, '', 1, 1, 'paperclip', '', 95, 1587692525, 1606123542);
INSERT INTO `hh_auth_rule` VALUES (339, 338, '上传文件', '', 'admin/Attachment/upload_file', 1, '', 1, 0, '', '', 0, 1587692658, 1606037181);
INSERT INTO `hh_auth_rule` VALUES (340, 338, '删除文件', '', 'admin/Attachment/del', 1, '', 1, 0, '', '', 0, 1587692705, 1606037333);
INSERT INTO `hh_auth_rule` VALUES (341, 338, '文件排序', '', 'admin/Attachment/sort', 1, '', 1, 0, '', '', 0, 1587692737, 1606037381);
INSERT INTO `hh_auth_rule` VALUES (342, 338, '移动文件', '', 'admin/Attachment/move', 1, '', 1, 0, '', '', 0, 1587692765, 1606037351);
INSERT INTO `hh_auth_rule` VALUES (343, 338, '附件分组', '', 'admin/AttachmentGroup/index', 1, '', 1, 0, '', '', 0, 1587692912, 1606038729);
INSERT INTO `hh_auth_rule` VALUES (344, 343, '新增', '', 'admin/AttachmentGroup/add', 1, '', 1, 0, '', '', 0, 1587692955, 1606038758);
INSERT INTO `hh_auth_rule` VALUES (345, 343, '编辑', '', 'admin/AttachmentGroup/edit', 1, '', 1, 0, '', '', 0, 1587692976, 1606038770);
INSERT INTO `hh_auth_rule` VALUES (346, 343, '删除', '', 'admin/AttachmentGroup/del', 1, '', 1, 0, '', '', 0, 1587693002, 1606038782);
INSERT INTO `hh_auth_rule` VALUES (347, 343, '排序', '', 'admin/AttachmentGroup/sort', 1, '', 1, 0, '', '', 0, 1587693019, 1606038793);
INSERT INTO `hh_auth_rule` VALUES (349, 78, '大文件上传', '', 'admin/File/upload_max_file', 1, '', 1, 0, '', '', 88, 1587776689, 1606123413);
INSERT INTO `hh_auth_rule` VALUES (365, 138, '中文转拼音', '', 'admin/cms.Arctype/get_pinyin', 1, '', 1, 0, '', '', 0, 1599426333, 1606009478);
INSERT INTO `hh_auth_rule` VALUES (460, 3, '节点管理', 'Node Manager', 'admin/Node/index', 1, '', 1, 1, '', '', 80, 1602588894, 1606124707);
INSERT INTO `hh_auth_rule` VALUES (461, 374, '钩子管理', 'Hooks Manager', 'admin/Hooks/index', 1, '', 1, 1, 'anchor', '', 60, 1602771807, 1606623050);
INSERT INTO `hh_auth_rule` VALUES (369, 139, '复制', '', 'admin/cms.Document/copy', 1, '', 1, 0, '', '', 0, 1600067941, 1606010740);
INSERT INTO `hh_auth_rule` VALUES (370, 137, '管理内容', 'Manager Content', 'admin/cms.Document/content', 1, '', 1, 1, 'clipboard', '', 82, 1600087820, 1606574788);
INSERT INTO `hh_auth_rule` VALUES (371, 138, '编辑内容', '', 'admin/cms.Arctype/edit_content', 1, '', 1, 0, '', '', 0, 1600094556, 1606009640);
INSERT INTO `hh_auth_rule` VALUES (372, 139, '左侧菜单', '', 'admin/cms.Document/public_arctype', 1, '', 1, 0, '', '', 0, 1600094681, 1606010892);
INSERT INTO `hh_auth_rule` VALUES (373, 139, '右侧内容', '', 'admin/cms.Document/public_document', 1, '', 1, 0, '', '', 0, 1600094720, 1606010920);
INSERT INTO `hh_auth_rule` VALUES (374, 0, '插件', 'addon', 'admin/Addon', 1, '', 1, 1, '', '', 70, 1600131756, 1600217533);
INSERT INTO `hh_auth_rule` VALUES (375, 374, '插件列表', 'Addon List', 'admin/Addon/index', 1, '', 1, 1, 'th-list', '', 80, 1600131982, 1606632762);
INSERT INTO `hh_auth_rule` VALUES (376, 374, '插件管理', 'Addon Manager', 'admin/Addon/manager', 1, '', 1, 0, 'circle-o', '', 50, 1600388240, 1606123023);
INSERT INTO `hh_auth_rule` VALUES (377, 375, '安装插件', '', 'admin/Addon/install', 1, '', 1, 0, '', '', 0, 1600411120, 1606123152);
INSERT INTO `hh_auth_rule` VALUES (378, 375, '卸载插件', '', 'admin/Addon/uninstall', 1, '', 1, 0, '', '', 0, 1600411156, 1606123147);
INSERT INTO `hh_auth_rule` VALUES (379, 375, '禁启插件', '', 'admin/Addon/state', 1, '', 1, 0, '', '', 0, 1600411193, 1606123141);
INSERT INTO `hh_auth_rule` VALUES (464, 375, '插件配置', '', 'admin/Addon/config', 1, '', 1, 0, '', '', 0, 1603621902, 1606123120);
INSERT INTO `hh_auth_rule` VALUES (381, 375, '上传插件', '', 'admin/Addon/local', 1, '', 1, 0, '', '', 0, 1600411282, 1606123134);
INSERT INTO `hh_auth_rule` VALUES (382, 375, '删除插件', '', 'admin/Addon/del', 1, '', 1, 0, '', '', 0, 1600411296, 1606123127);
INSERT INTO `hh_auth_rule` VALUES (383, 137, '表单管理', 'Form Manager', 'admin/cms.Form/index', 1, '', 1, 1, 'calendar', '', 70, 1600738803, 1606573720);
INSERT INTO `hh_auth_rule` VALUES (384, 137, '碎片管理', 'Debris Manager', 'admin/cms.Debris/index', 1, '', 1, 1, 'gift', '', 89, 1600924718, 1606006797);
INSERT INTO `hh_auth_rule` VALUES (385, 137, '广告管理', 'Advert Manager', 'admin/cms.Advert/index', 1, '', 1, 1, 'audio-description', '', 90, 1600924955, 1606573804);
INSERT INTO `hh_auth_rule` VALUES (462, 461, '详情', '', 'admin/Hooks/detail', 1, '', 1, 0, '', '', 0, 1603620257, 1606116215);
INSERT INTO `hh_auth_rule` VALUES (463, 461, '排序', '', 'admin/Hooks/sort', 1, '', 1, 0, '', '', 0, 1603620347, 1606116226);
INSERT INTO `hh_auth_rule` VALUES (466, 465, '新增', '', 'admin/cms.Adtype/add', 1, '', 1, 0, '', '', 0, 1603623093, 1606006729);
INSERT INTO `hh_auth_rule` VALUES (467, 465, '编辑', '', 'admin/cms.Adtype/edit', 1, '', 1, 0, '', '', 0, 1603623125, 1606006735);
INSERT INTO `hh_auth_rule` VALUES (468, 465, '删除', '', 'admin/cms.Adtype/del', 1, '', 1, 0, '', '', 0, 1603623202, 1606006741);
INSERT INTO `hh_auth_rule` VALUES (469, 465, '排序', '', 'admin/cms.Adtype/sort', 1, '', 1, 0, '', '', 0, 1603623225, 1606006748);
INSERT INTO `hh_auth_rule` VALUES (470, 385, '新增', '', 'admin/cms.Advert/add', 1, '', 1, 0, '', '', 0, 1603641352, 1606006633);
INSERT INTO `hh_auth_rule` VALUES (471, 385, '编辑', '', 'admin/cms.Advert/edit', 1, '', 1, 0, '', '', 0, 1603641376, 1606006639);
INSERT INTO `hh_auth_rule` VALUES (472, 385, '删除', '', 'admin/cms.Advert/del', 1, '', 1, 0, '', '', 0, 1603641527, 1606006645);
INSERT INTO `hh_auth_rule` VALUES (473, 385, '状态', '', 'admin/cms.Advert/setStatus', 1, '', 1, 0, '', '', 0, 1603641849, 1606006652);
INSERT INTO `hh_auth_rule` VALUES (474, 385, '排序', '', 'admin/cms.Advert/sort', 1, '', 1, 0, '', '', 0, 1603641881, 1606006662);
INSERT INTO `hh_auth_rule` VALUES (475, 138, '展示 / 折叠', '', 'admin/cms.Arctype/arctype_show', 1, '', 1, 0, '', '', 0, 1603648026, 1606009509);
INSERT INTO `hh_auth_rule` VALUES (522, 338, 'kindeditor上传', '', 'admin/Attachment/kindeditor_upload', 1, '', 1, 0, '', '', 0, 1606039681, 1607322165);
INSERT INTO `hh_auth_rule` VALUES (477, 338, '接收大文件', '', 'admin/Attachment/upload_max_file', 1, '', 1, 0, '', '', 0, 1603648026, 1606037470);
INSERT INTO `hh_auth_rule` VALUES (523, 338, 'kindeditor空间管理', '', 'admin/Attachment/kindeditor_file_manager', 1, '', 1, 0, '', '', 0, 1606039749, 1607241077);
INSERT INTO `hh_auth_rule` VALUES (481, 3, '节点授权', '', 'admin/AuthGroup/node', 1, '', 1, 0, '', '', 0, 1603648026, 1603648026);
INSERT INTO `hh_auth_rule` VALUES (482, 2, '获取表结构', '', 'admin/Data/sql_table', 1, '', 1, 0, '', '', 0, 1603648026, 1603648026);
INSERT INTO `hh_auth_rule` VALUES (483, 2, '获取insert语句', '', 'admin/Data/sql_insert', 1, '', 1, 0, '', '', 0, 1603648026, 1603648026);
INSERT INTO `hh_auth_rule` VALUES (484, 2, '批量删除备份', '', 'admin/Database/delall', 1, '', 1, 0, '', '', 0, 1603648026, 1603648026);
INSERT INTO `hh_auth_rule` VALUES (485, 384, '新增', '', 'admin/cms.Debris/add', 1, '', 1, 0, '', '', 0, 1603648026, 1606008135);
INSERT INTO `hh_auth_rule` VALUES (486, 384, '编辑', '', 'admin/cms.Debris/edit', 1, '', 1, 0, '', '', 0, 1603648026, 1606008144);
INSERT INTO `hh_auth_rule` VALUES (487, 384, '删除', '', 'admin/cms.Debris/del', 1, '', 1, 0, '', '', 0, 1603648026, 1606008152);
INSERT INTO `hh_auth_rule` VALUES (488, 384, '状态', '', 'admin/cms.Debris/setStatus', 1, '', 1, 0, '', '', 0, 1603648026, 1606008160);
INSERT INTO `hh_auth_rule` VALUES (489, 384, '排序', '', 'admin/cms.Debris/sort', 1, '', 1, 0, '', '', 0, 1603648026, 1606008169);
INSERT INTO `hh_auth_rule` VALUES (492, 78, '解压文件', '', 'admin/File/decompression_file', 1, '', 1, 0, '', '', 86, 1603648026, 1606123394);
INSERT INTO `hh_auth_rule` VALUES (493, 383, '新增', '', 'admin/cms.Form/add', 1, '', 1, 0, '', '', 0, 1603648026, 1606014076);
INSERT INTO `hh_auth_rule` VALUES (494, 383, '编辑', '', 'admin/cms.Form/edit', 1, '', 1, 0, '', '', 0, 1603648026, 1606014083);
INSERT INTO `hh_auth_rule` VALUES (495, 383, '删除', '', 'admin/cms.Form/del', 1, '', 1, 0, '', '', 0, 1603648026, 1606014105);
INSERT INTO `hh_auth_rule` VALUES (496, 383, '状态', '', 'admin/cms.Form/setStatus', 1, '', 1, 0, '', '', 0, 1603648026, 1606014006);
INSERT INTO `hh_auth_rule` VALUES (497, 383, '排序', '', 'admin/cms.Form/sort', 1, '', 1, 0, '', '', 0, 1603648026, 1606014130);
INSERT INTO `hh_auth_rule` VALUES (498, 383, '信息列表', '', 'admin/cms.Form/info', 1, '', 1, 0, '', '', 0, 1603648026, 1606014139);
INSERT INTO `hh_auth_rule` VALUES (499, 14, '搜索', '', 'admin/Menu/search', 1, '', 1, 0, '', '', 0, 1603648026, 1606122396);
INSERT INTO `hh_auth_rule` VALUES (501, 460, '系统节点更新', '', 'admin/Node/refreshNode', 1, '', 1, 0, '', '', 0, 1603648026, 1603648026);
INSERT INTO `hh_auth_rule` VALUES (502, 460, '清除失效节点', '', 'admin/Node/clearNode', 1, '', 1, 0, '', '', 0, 1603648026, 1603648026);
INSERT INTO `hh_auth_rule` VALUES (503, 460, '设置节点状态', '', 'admin/Node/setStatus', 1, '', 1, 0, '', '', 0, 1603648026, 1603648026);
INSERT INTO `hh_auth_rule` VALUES (504, 144, '根据pid获取下一级联动信息', '', 'admin/cms.Select/getStep', 1, '', 1, 0, '', '', 0, 1603648026, 1606024690);
INSERT INTO `hh_auth_rule` VALUES (505, 326, '编辑', '', 'admin/cms.Tag/edit', 1, '', 1, 0, '', '', 0, 1603648026, 1606003413);
INSERT INTO `hh_auth_rule` VALUES (506, 326, '重建', '', 'admin/cms.Tag/rebuilt', 1, '', 1, 0, '', '数据重建', 0, 1603648026, 1606003439);
INSERT INTO `hh_auth_rule` VALUES (507, 326, '删除', '', 'admin/cms.Tag/del', 1, '', 1, 0, '', '', 0, 1603648026, 1606003448);
INSERT INTO `hh_auth_rule` VALUES (508, 326, '状态', '', 'admin/cms.Tag/setStatus', 1, '', 1, 0, '', '', 0, 1603648026, 1606003456);
INSERT INTO `hh_auth_rule` VALUES (509, 326, '排序', '', 'admin/cms.Tag/sort', 1, '', 1, 0, '', '', 0, 1603648026, 1606003466);
INSERT INTO `hh_auth_rule` VALUES (510, 0, '常规', 'Routine', 'admin/Routine', 1, '', 1, 1, '', '', 100, 1605837654, 1605838684);
INSERT INTO `hh_auth_rule` VALUES (511, 384, '碎片位', 'DebrisPos', 'admin/cms.DebrisPos/index', 1, '', 1, 0, '', '', 1, 1606006885, 1606008128);
INSERT INTO `hh_auth_rule` VALUES (512, 511, '新增', '', 'admin/cms.DebrisPos/add', 1, '', 1, 0, '', '', 0, 1606006910, 1606008059);
INSERT INTO `hh_auth_rule` VALUES (513, 511, '编辑', '', 'admin/cms.DebrisPos/edit', 1, '', 1, 0, '', '', 0, 1606007986, 1606008067);
INSERT INTO `hh_auth_rule` VALUES (514, 511, '删除', '', 'admin/cms.DebrisPos/del', 1, '', 1, 0, '', '', 0, 1606008002, 1606008075);
INSERT INTO `hh_auth_rule` VALUES (515, 511, '排序', '', 'admin/cms.DebrisPos/sort', 1, '', 1, 0, '', '', 0, 1606008038, 1606008084);
INSERT INTO `hh_auth_rule` VALUES (516, 137, '字段管理', 'Attribute Manager', 'admin/cms.Attribute/index', 1, '', 1, 0, '', '', 0, 1606025359, 1606025707);
INSERT INTO `hh_auth_rule` VALUES (517, 516, '新增', '', 'admin/cms.Attribute/add', 1, '', 1, 0, '', '', 0, 1606025728, 1606025758);
INSERT INTO `hh_auth_rule` VALUES (518, 516, '编辑', '', 'admin/cms.Attribute/edit', 1, '', 1, 0, '', '', 0, 1606025742, 1606025772);
INSERT INTO `hh_auth_rule` VALUES (519, 516, '删除', '', 'admin/cms.Attribute/del', 1, '', 1, 0, '', '', 0, 1606025788, 0);
INSERT INTO `hh_auth_rule` VALUES (520, 516, '状态', '', 'admin/cms.Attribute/setStatus', 1, '', 1, 0, '', '', 0, 1606025820, 0);
INSERT INTO `hh_auth_rule` VALUES (521, 516, '排序', '', 'admin/cms.Attribute/sort', 1, '', 1, 0, '', '', 0, 1606025839, 0);
INSERT INTO `hh_auth_rule` VALUES (524, 338, 'kindeditor图片删除', '', 'admin/Attachment/kindeditor_image_del', 1, '', 1, 0, '', '', 0, 1606039832, 1607240997);
INSERT INTO `hh_auth_rule` VALUES (674, 338, 'markdown图片上传', '', 'admin/Attachment/markdown_image_upload', 1, '', 1, 0, '', '', 0, 1607241459, 0);
INSERT INTO `hh_auth_rule` VALUES (675, 338, '上传本地文件', '', 'admin/Attachment/native_upload', 1, '', 1, 0, '', '', 0, 1607351168, 0);
INSERT INTO `hh_auth_rule` VALUES (676, 338, '本地图片裁剪', '', 'admin/Attachment/crop', 1, '', 1, 0, '', '', 0, 1607351200, 0);
INSERT INTO `hh_auth_rule` VALUES (677, 338, '删除文件', '', 'admin/Attachment/delimg', 1, '', 1, 0, '', '', 0, 1607351236, 0);
INSERT INTO `hh_auth_rule` VALUES (673, 370, '右侧面板', 'Panl', 'admin/cms.Document/panl', 1, '', 1, 0, '', '', 90, 1606632897, 0);

-- ----------------------------
-- Table structure for hh_config
-- ----------------------------
DROP TABLE IF EXISTS `hh_config`;
CREATE TABLE `hh_config`  (
  `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '配置id',
  `ename` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '配置英文名称',
  `cname` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '配置中文名称',
  `form_type` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'input' COMMENT '表单类型；input：单行文本；radio：单选按钮；tags：标签；array：数组；markdown：编辑器；colorpicker：取色器；datetime：时间；selects：高级下拉多选；selecto：高级下拉单选；map：地图；region：地区；checkbox：复选框；select：下拉菜单；textarea：文本域；file：附件；editor：编辑器；picture：单图；piclist：多图；onefile：单文件；filelist：多文件；onevideo：单视频；videolist：多视频',
  `config_type_id` smallint(5) UNSIGNED NOT NULL COMMENT '配置类型id',
  `values` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '可选值，以下两种都可以：\r\n1、多个可选值用逗号隔开。注：必须加说明，例：值:说明,值:说明 \r\n2、如果是枚举型，需要配置该项，一行一个选项，例: \r\n0:选项1 \r\n2:选项2',
  `value` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '默认值，多个用逗号隔开',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '配置说明，如配置说明是个链接那么就在配置说明后面加@链接地址，链接地址必须带http://或https://',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后一次修改时间',
  `is_core_configuration` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否核心配置；1：是；0：否，是核心配置就不能删除',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态；1：显示；0：隐藏',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `ename`(`ename`) USING BTREE,
  UNIQUE INDEX `cname`(`cname`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 164 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_config
-- ----------------------------
INSERT INTO `hh_config` VALUES (1, 'WEB_SITE_TITLE', '网站标题', 'input', 4, '', 'ZengCMS后台开发框架', '网站标题前台显示标题', 0, 1544758785, 0, 99, 1);
INSERT INTO `hh_config` VALUES (87, 'WEB_SITE_DESCRIPTION_EN', '英文网站描述', 'textarea', 4, '', 'Zengcms is a background management system based on the latest tp6.0. X framework and layui2.5. X. It can rapidly develop a CMS station building system with multi terminal (PC & WAP), multi language and multi City, which is conducive to SEO optimization. The framework is easy to expand the function, maintain the code, facilitate the secondary development, help developers to reduce the cost of secondary development simply and efficiently, and meet the needs of focusing on business in-depth development. The system integrates perfect authority management, powerful restful API and plug-in development, expecting more functions plus QQ group 930328106', '英文网站搜索引擎描述', 1560329228, 1560329862, 0, 94, 1);
INSERT INTO `hh_config` VALUES (2, 'WEB_SITE_DESCRIPTION', '网站描述', 'textarea', 4, '', 'ZengCMS是基于最新TP6.0.x框架和Layui2.5.x的后台管理系统。它能够快速开发多端（PC&WAP）、多语言、多城市利于SEO优化的CMS建站系统。框架易于功能扩展，代码维护，方便二次开发，帮助开发者简单高效降低二次开发成本，满足专注业务深度开发的需求。系统集成了完善的权限管理，强大的RESTful API，功能插件化开发，期待更多的功能加QQ群 930328106', '网站搜索引擎描述', 0, 0, 0, 95, 1);
INSERT INTO `hh_config` VALUES (86, 'WEB_SITE_KEYWORDS_EN', '英文网站关键词', 'textarea', 4, '', 'Zeng CMS, CMS, Zeng CMS, content management system, CMS system', '英文网站搜索引擎关键字', 1560329189, 1604188491, 0, 96, 1);
INSERT INTO `hh_config` VALUES (3, 'WEB_SITE_KEYWORDS', '网站关键词', 'textarea', 4, '', '曾CMS,CMS,ZengCMS,内容管理系统,CMS系统', '网站搜索引擎关键字', 0, 1604188481, 0, 97, 1);
INSERT INTO `hh_config` VALUES (85, 'WEB_SITE_TITLE_EN', '英文网站标题', 'input', 4, '', 'Zengcms background development framework', '英文网站标题前台显示标题', 1560329150, 1560329734, 0, 98, 1);
INSERT INTO `hh_config` VALUES (163, 'SEARCH_PAGE_NUMBER', '前台搜索每页记录数', 'input', 13, '', '6', '前台搜索每页记录数', 1604366306, 0, 0, 38, 1);
INSERT INTO `hh_config` VALUES (5, 'WEB_SITE_LOGO', '网站logo', 'picture', 1, '', '', '', 0, 1608904368, 0, 80, 1);
INSERT INTO `hh_config` VALUES (6, 'WEB_SITE_EWM', '网站二维码', 'picture', 1, '', '', '', 0, 1608904357, 0, 75, 1);
INSERT INTO `hh_config` VALUES (7, 'WEB_ENABLE_SITE', '开启站点', 'radio', 2, '1:开启,0:关闭', '1', '开启站点', 0, 1586159347, 0, 99, 1);
INSERT INTO `hh_config` VALUES (8, 'WEB_ONE_PAGE_NUMBER', '后台每页记录数', 'select', 2, '1:一条,2:两条,3:三条,5:五条,8:八条,12:十二条,15:十五条,20:二十条,25:二十五条,30:三十条', '30', '后台每页记录数', 0, 1598599879, 0, 0, 1);
INSERT INTO `hh_config` VALUES (9, 'WEB_SITE_POWERBY', '网站版权信息', 'textarea', 1, '', 'Copyright © 2020 Powered by ZengCMS v1.0.0\n', '版权所有', 0, 1556170999, 0, 70, 1);
INSERT INTO `hh_config` VALUES (83, 'WEB_TEL', '电话', 'input', 1, '', 'xxx-xxxx-xxx', '', 1559376886, 0, 0, 65, 1);
INSERT INTO `hh_config` VALUES (13, 'WEB_CONFIG_FILE_EXT', '允许上传配置文件类型', 'checkbox', 5, 'jpg:jpg,png:png,gif:gif,jpeg:jpeg,docx:docx,txt:txt', 'jpg,png,gif,jpeg,docx,txt', '允许上传配置文件类型后缀', 0, 1598870252, 0, 0, 1);
INSERT INTO `hh_config` VALUES (14, 'WEB_CONFIG_FILE_SIZE', '允许上传配置文件的大小', 'input', 5, '', '20', '该值用于限制压缩后的分卷最大长度。单位：MB；建议设置20MB', 0, 1586161529, 0, 0, 1);
INSERT INTO `hh_config` VALUES (16, 'WEB_ENABLE_CACHE', '开启缓存', 'radio', 18, '1:开启\r\n0:关闭', '0', '1:开启,0:关闭', 0, 1598285860, 0, 100, 1);
INSERT INTO `hh_config` VALUES (17, 'WEB_CACHE_TIME', '缓存有效期', 'input', 18, '', '7200', '缓存有效期（秒），如果不设置则默认为永久缓存（默认为0 表示永久缓存）', 0, 1579072521, 0, 0, 1);
INSERT INTO `hh_config` VALUES (21, 'WEB_SITE_ICP', 'ICP备案证书号', 'input', 1, '', '粤ICP备xxxxxxxx号', '', 0, 0, 0, 68, 1);
INSERT INTO `hh_config` VALUES (23, 'DATA_BACKUP_PATH', '数据库备份根路径', 'input', 7, '', '/data/bak/database', '', 1539485540, 1562123811, 0, 33, 1);
INSERT INTO `hh_config` VALUES (24, 'DATA_BACKUP_COMPRESS', '数据库备份文件是否启用压缩', 'radio', 7, '1:是,0:否', '1', '数据库备份文件是否启用压缩', 1539485586, 1586221956, 0, 666, 1);
INSERT INTO `hh_config` VALUES (25, 'DATA_BACKUP_PART_SIZE', '数据库备份卷大小', 'input', 7, '', '20971520', '数据库备份卷大小，单位B', 1539486524, 1587692125, 0, 0, 1);
INSERT INTO `hh_config` VALUES (26, 'DATA_BACKUP_COMPRESS_LEVEL', '数据库备份文件压缩级别', 'radio', 7, '1:普通,4:一般,9:最高', '9', '数据库备份文件压缩级别', 1539486595, 1539487037, 0, 0, 1);
INSERT INTO `hh_config` VALUES (27, 'WEB_DATA_AUTH_KEY', '密匙', 'input', 2, '', '&%￥#@%&*￥%@*￥#', '密匙key', 1539743471, 1579151382, 0, 0, 1);
INSERT INTO `hh_config` VALUES (28, 'WEB_BANNED_IP', '禁止登录ip', 'textarea', 2, '', '47.25.25.1\n47.25.25.2\n47.25.25.3', '禁止登录ip，每行一个ip', 1539749093, 1601477642, 0, 0, 1);
INSERT INTO `hh_config` VALUES (51, 'WEB_SEO_CITY', '优化城市', 'textarea', 4, '', '[\"110100\",\"120100\",\"440100\",\"440300\"]', '地区优化设置', 1540538098, 1546929559, 0, 90, 0);
INSERT INTO `hh_config` VALUES (58, 'ERROR_LOGINS', '登录错误次数', 'input', 12, '', '3', '登录密码错误超过此数，就会在某一段时间段内不许再执行登录操作，会提示操作频繁，请稍后再登录！', 1544105664, 1544106385, 0, 3, 1);
INSERT INTO `hh_config` VALUES (59, 'ERROR_TIME_DUAN', '错误时间段', 'input', 12, '', '18000', '登录密码错误超过一定次数，要等这时间段后才能继续执行登录操作，单位秒。', 1544105891, 1544106430, 0, 2, 1);
INSERT INTO `hh_config` VALUES (60, 'NO_OPERATE_TIME', '未操作时间', 'input', 12, '', '36000000', '如果在这时间内未做任何操作会自动退出，单位秒。', 1544106012, 1607936133, 0, 1, 1);
INSERT INTO `hh_config` VALUES (61, 'WEB_CLOSE_SITE_TITLE', '关闭提示', 'input', 2, '', '网站维护中......', '关闭站点提示', 1553829640, 0, 0, 98, 1);
INSERT INTO `hh_config` VALUES (62, 'WEB_SITE_NAME', '网站名称', 'input', 1, '', 'ZengCMS内容管理系统', '', 1555601767, 0, 0, 100, 1);
INSERT INTO `hh_config` VALUES (63, 'WEB_DEFAULT_THEME', '默认模板', 'select', 13, 'normal:normal\r\ncloudcms:cloudcms', 'normal', '默认访问模板', 1556080901, 1606390088, 0, 60, 1);
INSERT INTO `hh_config` VALUES (66, 'WEB_SITE_EMAIL', '邮箱', 'input', 1, '', 'zengcms@qq.com', '', 1556171312, 0, 0, 64, 1);
INSERT INTO `hh_config` VALUES (67, 'WEB_SITE_PHONE', '手机', 'input', 1, '', 'xxxxxxxxxxx', '', 1556171344, 1559376857, 0, 66, 1);
INSERT INTO `hh_config` VALUES (68, 'WEB_SEO_MENU', '优化栏目', 'textarea', 4, '', '[\"31\",\"3\"]', '优化栏目', 1556857844, 0, 0, 82, 0);
INSERT INTO `hh_config` VALUES (71, 'WEB_INDEX_VISIT', '首页访问', 'radio', 13, '1:动态,0:静态', '1', '', 1557051182, 1586161661, 0, 100, 1);
INSERT INTO `hh_config` VALUES (69, 'WEB_LONGKEY_PREFIX', '长尾关键词前缀', 'textarea', 4, '', '广西,深圳,提供,最好的', '长尾关键词优化设置', 1556863571, 0, 0, 40, 0);
INSERT INTO `hh_config` VALUES (70, 'WEB_LONGKEY_SUFFIX', '长尾关键词后缀', 'textarea', 4, '', '服务,价格,公司,技术', '长尾关键词优化设置', 1556863613, 0, 0, 20, 0);
INSERT INTO `hh_config` VALUES (72, 'WEB_CATEGORY_VISIT', '栏目访问', 'radio', 13, '1:动态,0:静态', '1', '', 1557051337, 0, 0, 90, 1);
INSERT INTO `hh_config` VALUES (73, 'WEB_ARTICLE_VISIT', '内容访问', 'radio', 13, '1:动态,0:静态', '1', '', 1557051368, 0, 0, 80, 1);
INSERT INTO `hh_config` VALUES (74, 'QQ', 'QQ', 'input', 1, '', '185789392', '', 1557709784, 1603973929, 0, 63, 1);
INSERT INTO `hh_config` VALUES (77, 'SITE_DOMAIN', '网站域名', 'input', 1, '', 'www.zengcms.cn', '', 1557709980, 0, 0, 74, 1);
INSERT INTO `hh_config` VALUES (82, 'WEB_ADDRESS', '地址', 'input', 1, '', '广州市天河区某某园区', '', 1559376786, 0, 0, 67, 1);
INSERT INTO `hh_config` VALUES (88, 'WEB_SITE_NAME_EN', '英文网站名称', 'input', 1, '', 'ZengCMS Content Management System', '', 1560331144, 0, 0, 90, 1);
INSERT INTO `hh_config` VALUES (92, 'WEB_ENABLE_WATER', '开启水印', 'radio', 15, '1:开启,0:关闭', '1', '上传的图片是否使用图片水印功能', 1561993597, 1561996216, 0, 100, 1);
INSERT INTO `hh_config` VALUES (93, 'WEB_WATER_POS', '水印位置', 'select', 15, '1:顶部居左,2:顶部居中,3:顶部居右,4:左边居中,5:图片中心,6:右边居中,7:底部居左,8:底部居中,9:底部居右', '8', '', 1561995086, 1561995310, 0, 30, 1);
INSERT INTO `hh_config` VALUES (94, 'WEB_WATER_TYPE', '水印类型', 'radio', 15, '1:图片,2:文字', '1', '', 1561995622, 0, 0, 90, 1);
INSERT INTO `hh_config` VALUES (95, 'WEB_WATER_IMG', '水印图片', 'file', 15, '', 'uploads/config/20201208/WtBuIY20201208.png', '', 1561996026, 1562504975, 0, 80, 1);
INSERT INTO `hh_config` VALUES (96, 'WEB_WATER_TEXT', '水印图片文字', 'input', 15, '', 'www.huocms.cn', '请查看项目根目录字体库（msyh.ttc）是否存在', 1561996149, 1561997014, 0, 70, 1);
INSERT INTO `hh_config` VALUES (97, 'WEB_WATER_TEXT_SIZE', '水印图片文字字体大小', 'input', 15, '', '30', '水印图片文字字体大小', 1561996258, 0, 0, 60, 1);
INSERT INTO `hh_config` VALUES (98, 'WEB_WATER_TEXT_COLOR', '水印图片文字颜色', 'input', 15, '', '#FF0000', '水印图片文字颜色(默认#FF0000为红色)', 1561996357, 0, 0, 50, 1);
INSERT INTO `hh_config` VALUES (99, 'WEB_WATER_TMD', '水印透明度', 'input', 15, '', '50', '水印图片的透明度（0~100的整数，默认值是100）数值越大结构图片效果越好，但尺寸也越大', 1561996505, 0, 0, 40, 1);
INSERT INTO `hh_config` VALUES (100, 'WEB_ENABLE_THUMB', '开启缩略', 'radio', 16, '1:开启,0:关闭', '0', '', 1561997278, 0, 0, 0, 1);
INSERT INTO `hh_config` VALUES (101, 'WEB_THUMB_WIDTH', '缩略图宽度', 'input', 16, '', '360', '', 1561997314, 0, 0, 0, 1);
INSERT INTO `hh_config` VALUES (102, 'WEB_THUMB_HEIGHT', '缩略图高度', 'input', 16, '', '360', '', 1561997336, 0, 0, 0, 1);
INSERT INTO `hh_config` VALUES (103, 'WEB_THUMB_TYPE', '缩略图类型', 'radio', 16, '1:等比例缩,2:缩放后填充,3:居中裁剪,4:左上角裁剪,5:右下角裁剪,6:固定尺寸缩放', '6', '', 1561997531, 0, 0, 0, 1);
INSERT INTO `hh_config` VALUES (104, 'WEB_THUMB_SAVE_TYPE', '图像保存类型', 'select', 16, 'jpeg:jpeg,png:png,jpg:jpg,gif:gif', '', '', 1562042415, 1598870889, 0, 0, 1);
INSERT INTO `hh_config` VALUES (105, 'WEB_THUMB_QUALITY', '图像质量', 'input', 16, '', '80', '', 1562042533, 0, 0, 0, 1);
INSERT INTO `hh_config` VALUES (106, 'WEB_THUMB_INTERLACE', '是否对JPEG类型图像设置隔行扫描', 'radio', 16, '0:否,1:是', '1', '是否对JPEG类型图像设置隔行扫描', 1562042625, 1562045462, 0, 0, 1);
INSERT INTO `hh_config` VALUES (108, 'WEB_INDEX_LANG', '网站前台语言设置', 'input', 13, '', 'm|en|en_m', 'm是代表中文手机访问，en代表英文PC访问，en_m代表英文手机访问,默认为m|en|en_m即中文站、中文手机站、英文站、英文手机站', 1562584836, 1580016991, 0, 50, 1);
INSERT INTO `hh_config` VALUES (109, 'WEB_PATH_PATTERN', '路径模式', 'radio', 13, '1:相对路径,0:绝对路径', '1', '栏目和文章路径模式', 1563356025, 1601475837, 0, 40, 1);
INSERT INTO `hh_config` VALUES (110, 'CATEGORY_PAGE_NUMBER', '前台栏目每页记录数', 'input', 13, '', '6', '前台栏目分页每页显示的记录数', 1563460075, 1598844026, 0, 39, 1);
INSERT INTO `hh_config` VALUES (111, 'is_recording_behavior_log', '是否记录行为日志', 'radio', 2, '1:记录,0:不记录', '1', '是否记录行为日志', 1564237139, 1588515334, 0, 0, 1);
INSERT INTO `hh_config` VALUES (112, 'is_record_operation_log', '是否记录操作日志', 'radio', 2, '1:记录,0:不记录', '1', '是否记录操作日志', 1564237247, 1588515361, 0, 0, 1);
INSERT INTO `hh_config` VALUES (113, 'browse_records_number', '最大浏览记录数', 'input', 13, '', '10', '最大浏览记录数', 1564456442, 1601710654, 0, 0, 1);
INSERT INTO `hh_config` VALUES (120, 'WEB_CACHE_TYPE', '缓存类型', 'select', 18, 'default:默认文件缓存,redis:redis缓存,memcache:memcache缓存', 'default', '', 1579073469, 1579353894, 0, 60, 1);
INSERT INTO `hh_config` VALUES (122, 'WEB_ADMIN_REMEMBER_ME', '记住密码时间', 'select', 12, '1:1天,7:7天,10:10天,20:20天,30:30天', '7', '', 1579505605, 0, 0, 0, 1);
INSERT INTO `hh_config` VALUES (123, 'editor', '编辑器', 'editor', 1, '', '<img src=\"/static/uploads/kindeditor/image/20200423/20200423122958_32004.jpeg\" alt=\"\" />', '', 1581252198, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (124, 'dantu', '单图', 'picture', 1, '', 'uploads/config/20200429/158811694812004.jpeg', '', 1581253959, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (125, 'piclist', '多图', 'piclist', 1, '', 'uploads/admin/20200204/6e70208c591ffd6a057a3c0292263568-1.jpg,uploads/admin/20200203/68780d82bd89af995625c1f04473fb3a-1-1.jpg,1587692565164.jpeg', '', 1581254419, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (131, 'upload_position', '本地上传目录位置', 'input', 19, '', 'attachment', '', 1584838753, 1607325017, 0, 0, 1);
INSERT INTO `hh_config` VALUES (132, 'Bucket', '阿里云OSS-存储空间名称（Bucket）', 'input', 19, '', '', '阿里云OSS-存储空间名称（Bucket）', 1584838854, 1584839205, 0, 0, 1);
INSERT INTO `hh_config` VALUES (133, 'Endpoint', '阿里云OSS-Endpoint（或自定义域名）', 'input', 19, '', '', '阿里云OSS-Endpoint（或自定义域名）', 1584838888, 1584839196, 0, 0, 1);
INSERT INTO `hh_config` VALUES (134, 'isopenzdy', '阿里云OSS-是否开启自定义域名', 'radio', 19, '0:否,1:是', '0', '阿里云OSS-是否开启自定义域名', 1584838964, 1584839186, 0, 0, 1);
INSERT INTO `hh_config` VALUES (135, 'AccessKeyID', '阿里云OSS-Access Key ID', 'input', 19, '', '', '阿里云OSS-Access Key ID', 1584839004, 1584839175, 0, 0, 1);
INSERT INTO `hh_config` VALUES (136, 'AccessKeySecret', '阿里云OSS-Access Key Secret', 'input', 19, '', '', '阿里云OSS-Access Key Secret', 1584839029, 1584839165, 0, 0, 1);
INSERT INTO `hh_config` VALUES (137, 'imagestyle', '阿里云OSS-图片样式接口（选填）', 'input', 19, '', '', '阿里云OSS-图片样式接口（选填）', 1584839072, 1584839155, 0, 0, 1);
INSERT INTO `hh_config` VALUES (138, 'upserver', '上传服务器', 'radio', 19, '1:本地,2:阿里云', '1', '', 1584839295, 1585269874, 0, 1, 1);
INSERT INTO `hh_config` VALUES (139, 'danwenjian', '单文件', 'onefile', 1, '', 'uploads/admin/20190317/1-2-1.jpg', '', 1587640901, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (140, 'duowenjian', '多文件', 'filelist', 1, '', '1587638680838.jpeg,1587638614111.jpeg,1587638680838.jpeg,1587638614111.jpeg,1587642691781.jpeg', '', 1587640926, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (141, 'danshipin', '单视频', 'onevideo', 1, '', '1587643547412.mp4', '', 1587640951, 1587641142, 0, 0, 0);
INSERT INTO `hh_config` VALUES (142, 'duoshipin', '多视频', 'videolist', 1, '', '1587643547412.mp4,1587643547412.mp4', '', 1587640973, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (143, 'index_suffix', '首页后缀', 'select', 13, 'html:html\r\nhtm:htm', 'html', '如果不选择，默认是html后缀', 1598328886, 1598344243, 0, 46, 1);
INSERT INTO `hh_config` VALUES (144, 'category_suffix', '栏目后缀', 'select', 13, 'html:html\r\nhtm:htm', '', '', 1598328957, 0, 0, 45, 1);
INSERT INTO `hh_config` VALUES (145, 'article_suffix', '内容后缀', 'select', 13, 'html:html\r\nhtm:htm', 'html', '如果不选择，默认是html后缀', 1598329003, 1598344292, 0, 43, 1);
INSERT INTO `hh_config` VALUES (146, 'category_page_suffix', '栏目分页后缀', 'select', 13, 'html:html\r\nhtm:htm', 'html', '如果不选择，默认是html后缀', 1598340052, 1598344272, 0, 44, 1);
INSERT INTO `hh_config` VALUES (147, 'other_suffix', '其它后缀', 'select', 13, 'html:html\r\nhtm:htm', 'html', '如果不选择，默认是html后缀', 1598365415, 1598365431, 0, 42, 1);
INSERT INTO `hh_config` VALUES (150, 'SYS_BDMAP_API', '百度地图Api-AK', 'input', 13, '', 'DD279b2a90afdf0ae7a3796787a0742e', '', 1601909912, 0, 0, 0, 1);
INSERT INTO `hh_config` VALUES (151, 'SYS_QQMAP_API', '腾讯地图Api-AK', 'input', 13, '', 'VFEBZ-JYWWS-UVUOJ-633ZN-YQAB7-TABZU', '', 1601974512, 1601974554, 0, 0, 1);
INSERT INTO `hh_config` VALUES (152, 'ceshitags', '测试tags标签', 'tags', 1, '', '12121,555,fsdfsd,1212,fsdfsdf', '', 1603109471, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (154, 'ceshimarkdown', '测试markdown编辑器', 'markdown', 1, '', '21212![]\n![](/static/uploads/markdown/20201206/iHbsoE20201206.jpg)', '', 1603111627, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (155, 'ceshiquse', '测试取色器', 'colorpicker', 1, '', '#5b1515', '', 1603112111, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (156, 'ceshidatetime', '测试时间', 'datetime', 1, '', '2020-10-19 21:04:07', '', 1603112468, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (157, 'ceshixldx', '测试高级下拉多选', 'selects', 1, '1:好人\r\n2:坏人', '117.251767,34.208217', '', 1603113830, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (158, 'ceshigaojixldx', '测试高级下拉单选', 'selecto', 1, '1:美国\r\n2:中国', '1', '', 1603113915, 1603113944, 0, 0, 0);
INSERT INTO `hh_config` VALUES (159, 'ceshidutu', '测试地图', 'map', 1, '', '110.231024,22.678251', '', 1603114133, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (160, 'ceshiduqu', '测试地区', 'region', 1, '', '140000,140700,140726', '', 1603116233, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (161, 'ceshiarray', '测试数组', 'array', 1, '', '{\"88\":\"8\",\"2\":\"4\"}', '', 1603117188, 0, 0, 0, 0);
INSERT INTO `hh_config` VALUES (162, 'PERMISSION_TYPE', '权限类型', 'radio', 12, '1:Auth\r\n2:Node\r\n3:Auth+Node', '1', '', 1603267070, 1603267110, 0, 0, 1);

-- ----------------------------
-- Table structure for hh_config_type
-- ----------------------------
DROP TABLE IF EXISTS `hh_config_type`;
CREATE TABLE `hh_config_type`  (
  `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `config_type_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '配置类型名称',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '最后一次修改时间',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态；1：显示；0：隐藏',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `config_type_name`(`config_type_name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '配置类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_config_type
-- ----------------------------
INSERT INTO `hh_config_type` VALUES (1, '网站信息', '', 0, 1586181750, 100, 1);
INSERT INTO `hh_config_type` VALUES (2, '基本配置', '', 0, 1546930803, 99, 1);
INSERT INTO `hh_config_type` VALUES (4, 'SEO设置', '', 0, 1609033515, 97, 1);
INSERT INTO `hh_config_type` VALUES (5, '系统设置', '', 0, 0, 96, 1);
INSERT INTO `hh_config_type` VALUES (7, '备份配置', '数据备份配置', 1539485460, 1601642429, 95, 1);
INSERT INTO `hh_config_type` VALUES (12, '登录设置', '后台登录设置', 1544105416, 1601642400, 93, 1);
INSERT INTO `hh_config_type` VALUES (13, 'CMS设置', '', 1557051073, 1609033507, 98, 1);
INSERT INTO `hh_config_type` VALUES (15, '水印设置', '图片水印设置', 1561993136, 1601642410, 92, 1);
INSERT INTO `hh_config_type` VALUES (16, '缩略设置', '图片缩略设置', 1561997185, 1601642418, 91, 1);
INSERT INTO `hh_config_type` VALUES (18, '缓存设置', '', 1579072396, 0, 99, 1);
INSERT INTO `hh_config_type` VALUES (19, '上传配置', '', 1584838635, 0, 0, 1);

-- ----------------------------
-- Table structure for hh_debris
-- ----------------------------
DROP TABLE IF EXISTS `hh_debris`;
CREATE TABLE `hh_debris`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `posid` mediumint(8) UNSIGNED NOT NULL DEFAULT 0 COMMENT '碎片位id',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '碎片标题',
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '链接地址',
  `thumb` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '缩略图',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '碎片内容',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(1:显示,0:隐藏)',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '碎片表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_debris
-- ----------------------------
INSERT INTO `hh_debris` VALUES (1, 1, 'sfds', 'ewfwewef', '', 'sdfwerwer', 'ewrwerewrwe', 1, 0, 1608105589, 1608629574);

-- ----------------------------
-- Table structure for hh_debris_pos
-- ----------------------------
DROP TABLE IF EXISTS `hh_debris_pos`;
CREATE TABLE `hh_debris_pos`  (
  `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '碎片位名称',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '碎片位描述',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '碎片位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_debris_pos
-- ----------------------------
INSERT INTO `hh_debris_pos` VALUES (1, '首页碎片位', '首页碎片位', 100);

-- ----------------------------
-- Table structure for hh_document
-- ----------------------------
DROP TABLE IF EXISTS `hh_document`;
CREATE TABLE `hh_document`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `category_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '所属分类ID',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `status` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `flags` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '自定义属性',
  `tags` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'TAG标签',
  `thumb` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '缩略图',
  `source` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '来源',
  `uid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '管理员ID',
  `writer` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '作者',
  `keywords` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '关键词',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '描述',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '内容',
  `view` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  `target` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '_self' COMMENT '窗口类型',
  `title_en` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '英文标题',
  `keywords_en` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '英文关键词',
  `description_en` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '英文描述',
  `content_en` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '英文内容',
  `rel` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'rel 属性',
  `position` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '推荐位',
  `redirecturl` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '跳转地址',
  `color` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标题颜色',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '基础文档表(模型)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_document
-- ----------------------------
INSERT INTO `hh_document` VALUES (1, 33, 'js动态append或者html()添加的节点点击事件无效', '1', 0, 1607586623, 1607603627, '', 'js,append,html', '', '', 1, '火火', '节点,content,添加,事件,点击,his,strs,无效,插入,function', 'jQuery通过for循环添加的节点，再对各个节点添加点击事件无效', '<h2 style=\"box-sizing:border-box;margin-top:0px;margin-bottom:16px;color:#404040;text-rendering:optimizelegibility;font-size:24px;font-family:-apple-system, BlinkMacSystemFont, \" apple=\"\" color=\"\" emoji\",=\"\" \"segoe=\"\" ui=\"\" symbol\",=\"\" ui\",=\"\" \"pingfang=\"\" sc\",=\"\" \"hiragino=\"\" sans=\"\" gb\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;white-space:normal;background-color:#ffffff;\"=\"\">问题：</h2><p style=\"box-sizing:border-box;margin-top:0px;margin-bottom:20px;word-break:break-word;color:#404040;font-family:-apple-system, BlinkMacSystemFont, \" apple=\"\" color=\"\" emoji\",=\"\" \"segoe=\"\" ui=\"\" symbol\",=\"\" ui\",=\"\" \"pingfang=\"\" sc\",=\"\" \"hiragino=\"\" sans=\"\" gb\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:16px;white-space:normal;background-color:#ffffff;\"=\"\">jQuery通过for循环添加的节点，再对各个节点添加点击事件无效，如下代码：</p>\n<pre class=\"line-numbers language-php\"><code class=\"code language-php\"> //插入节点\n for (var i = 0; i < strs.length; i++) { s += \"<div class=\"div\">\" + strs[i] + \"</div>\";\n  }\n  $(\".his_content\").html(s);\n  //$(\".his_content\").append(s);\n//点击事件\n$(\'.his_content .div\').click(function(){\n    console.log(\'ok\')\n}) <span aria-hidden=\"true\" class=\"line-numbers-rows\"><span></span><span></span><span></span><span></span><span></span><span></span></span></code></pre>', 26, '_self', 'The node click event added by JS dynamic append or HTML () is invalid', 'Node, content, add, event, click, his, STRs, invalid, insert, function', 'JQuery adds nodes through the for loop, and then adds click events to each node', '<h2 apple=\"\" color=\"\" emoji\",=\"\" \"segoe=\"\" ui=\"\" symbol\",=\"\" ui\",=\"\" \"pingfang=\"\" sc\",=\"\" \"hiragino=\"\" sans=\"\" gb\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;white-space:normal;background-color:#ffffff;\"=\"\" style=\"white-space: normal; box-sizing: border-box; margin-top: 0px; margin-bottom: 16px; color: rgb(64, 64, 64); text-rendering: optimizelegibility; font-size: 24px;\">question：</h2><p apple=\"\" color=\"\" emoji\",=\"\" \"segoe=\"\" ui=\"\" symbol\",=\"\" ui\",=\"\" \"pingfang=\"\" sc\",=\"\" \"hiragino=\"\" sans=\"\" gb\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:16px;white-space:normal;background-color:#ffffff;\"=\"\" style=\"margin-top: 0px; margin-bottom: 20px; white-space: normal; box-sizing: border-box; word-break: break-word; color: rgb(64, 64, 64);\">JQuery adds nodes through the for loop, and then adds click events to each node, which is invalid, as shown in the following code：</p>\n<pre class=\"line-numbers language-php\"><code class=\"code language-php\"> //插入节点\n for (var i = 0; i < strs.length; i++) { s += \"<div class=\"div\">\" + strs[i] + \"</div>\";\n  }\n  $(\".his_content\").html(s);\n  //$(\".his_content\").append(s);\n//点击事件\n$(\'.his_content .div\').click(function(){\n    console.log(\'ok\')\n}) </code></pre>\n<br /><span style=\"white-space:normal;\"></span>', '', '', '', '');
INSERT INTO `hh_document` VALUES (2, 33, 'xampp的php怎么升级？', '1', 0, 1607599952, 1607603641, '', 'xampp,php', '', '', 1, '火火', 'XAMPP,备份,步骤,安装,选择,文件,文件夹,目录,这是,卸载', '一般来说，不建议单独升级XAMPP的PHP部分。', '一般来说，不建议单独升级XAMPP的PHP部分。你应该首先考虑升级XAMPP服务器包。<br /><br />步骤1：备份重要文件<br /><br />XAMPP安装之后，用户数据基本上涉及以下3个地方：<br /><br />1. xampp/htdocs 目录：这是所有网站的文件系统。<br /><br />2. xampp/mysql/data 目录：这是所有网站的数据库。<br /><br />3. xampp/apache/conf/extra/httpd-vhosts.conf文件：这是你的虚拟主机（假设你在XAMPP里面使用了虚拟主机）配置文件。<br /><br />你需要完整备份上述3个目录/文件。最后，将旧的xampp文件夹重命名为xampp_OLD或移除。<br /><br />步骤2：卸载旧的xampp<br /><br />如果你想要卸载旧的xampp，选择xampp/uninstall.exe。<br /><br />Remove htdocs folder? 若已备份则选择Yes，没有备份则选择No。<br /><br />Do you want to uninstall XAMPP and all itsmodules? 选择Yes。<br /><br />步骤3：下载安装新的xampp<br /><br />前往官网下载最新的XAMPP安装包（exe格式），一直按 Yes 继续，这时可以把XAMPP安装在xampp文件夹。<br /><br />步骤4：搬移备份<br /><br />把xampp/htdocs及xampp/mysql/data还原到新文件夹的对应位置。<br /><br />大功告成。<br /><br />', 4, '_self', 'How to upgrade xampp\'s PHP?', 'Xampp, backup, step, install, select, file, folder, directory, this is, uninstall', 'In general, it is not recommended to upgrade the PHP portion of xampp separately.', 'In general, it is not recommended to upgrade the PHP portion of xampp separately. You should first consider upgrading the xampp Server package.<br />Step 1: back up important files<br />After xampp is installed, user data basically involves the following three places:<br />1. Xampp / htdoc Directory: This is the file system of all websites.<br />2. Xampp / MySQL / data directory: This is the database of all websites.<br />3. xampp/apache/conf/extra/httpd- vhosts.conf File: This is the configuration file of your virtual host (assuming you use virtual host in xampp).<br />You need to back up the above three directories / files. Finally, rename the old xampp folder to xampp_ Old or remove.<br />Step 2: uninstall the old xampp<br />If you want to uninstall the old xampp, select xampp/ uninstall.exe 。<br />Remove HtDocs folder? Select Yes if it has been backed up, or no if there is no backup.<br />Do you want to install xampp and all its modules? Select Yes.<br />Step 3: Download and install the new xampp<br />Go to the official website to download the latest xampp installation package (EXE format), and press yes to continue. At this time, you can install xampp in the xampp folder.<br />Step 4: move the backup<br />Restore xampp / htdoc and xampp / MySQL / data to the corresponding location of the new folder.<br />be accomplished.<br />', '', '', '', '');
INSERT INTO `hh_document` VALUES (3, 33, 'jquery字符串转数组', '1', 0, 1607605176, 1607608095, '', 'jquery', '', '', 1, '火火', '数组,字符串,variinarr,jquery,vararr,split,alert,123,abc,arr', 'jquery字符串转数组vararr=\'123,abc,xy,hi\'.', 'jquery字符串转数组\n<pre class=\"line-numbers language-php\"><code class=\"code language-php\"> var arr = \'123,abc,xy,hi\'.split(\',\');\n  for(var i in arr){\n  alert(arr[i])\n  } <span aria-hidden=\"true\" class=\"line-numbers-rows\"><span></span><span></span><span></span><span></span><span></span><span></span></span></code></pre>', 12, '_self', 'JQuery string to array', 'This paper describes the method of PHP establishing FTP connection.', 'JQuery string to array vararr = 123, ABC, XY, hi \'', '<span style=\"white-space:normal;\">JQuery string to array</span> \n<pre class=\"line-numbers language-php\"><code class=\"code language-php\"> var arr = \'123,abc,xy,hi\'.split(\',\');\n  for(var i in arr){\n  alert(arr[i])\n  } </code></pre>', '', '', '', '');
INSERT INTO `hh_document` VALUES (4, 33, 'jQuery对指定元素中指定字符串进行替换的方法', '1', 0, 1607608210, 1608864975, '', 'jquery,html', '', '', 1, '火火', '字符串,元素,指定,如下,content,jQuery,大家,替换,html,本文', '本文实例讲述了jQuery对指定元素中指定字符串进行替换的方法。', '本文实例讲述了jQuery对指定元素中指定字符串进行替换的方法。分享给大家供大家参考。具体如下：<br /><br />这段JS代码可以将指定id的元素内容的字符串进行替换，例如西面的代码将id=content元素中的jb51字符串替换成空字符<br /><br />html部分如下：<br /><br /><div id=\"content\"><div id=\"content\">\n<pre class=\"prettyprint lang-html\"><div id=content>welcome to jb51</div></pre>\n<br /></div></div><br />jQuery部分如下：<br /><br />\n<pre class=\"prettyprint lang-js\">var el = $(\'#content\'); \nel.html(el.html().replace(/jb51/ig, \'\'));</pre>\n<br />希望本文所述对大家的jQuery程序设计有所帮助。<br />', 20, '_self', 'JQuery method to replace the specified string in the specified element', 'String, element, specification, content, jQuery, everybody, replace, HTML, this article', 'This article describes the jQuery method to replace the specified string in the specified element.', '本文实例讲述了jQuery对指定元素中指定字符串进行替换的方法。分享给大家供大家参考。具体如下：<br /><br />这段JS代码可以将指定id的元素内容的字符串进行替换，例如西面的代码将id=content元素中的jb51字符串替换成空字符<br /><br />html部分如下：<br /><br /><div id=\"content\"><div id=\"content\">\n<pre class=\"prettyprint lang-html\"><div id=content>welcome to jb51</div></pre>\n<br /></div></div><br />jQuery部分如下：<br /><br />\n<pre class=\"prettyprint lang-js\">var el = $(\'#content\'); \nel.html(el.html().replace(/jb51/ig, \'\'));</pre>\n<br />希望本文所述对大家的jQuery程序设计有所帮助。<br />', '', '', '', '');
INSERT INTO `hh_document` VALUES (5, 32, '不得不说，程序员兼职平台让我1年收入60w', '1', 0, 1607609240, 1607619633, '', '程序员', '', '', 1, '火火', '私活,如果,提升,时间,作者,野生,程序员,远比,考虑,一些', '关于程序员接私活，社会各界说法不一。', '<div><div><p>关于程序员接私活，社会各界说法不一。</p><p>按我的观点来说，如果你确实急用钱，价格又合适，那就去做。</p><p>如果不怎么缺钱，那就接私活之前要好好考虑。</p><p>私活的钱不好挣是一个方面，更重要的是如果你把做私活的时间花在提升自己上，产生的价值就要大得多。</p><p>等你提升了自己，提升了固定薪水，远比拿的这点私活的钱划算。</p><p>千万不要“捡了芝麻丢了西瓜”。</p><p>如果你主业上遇到了瓶颈，平时的时间比较充分，想有一些额外的收入，同时为了保持技术的熟练度，这种情况下，是可以考虑接一些私活的。对于那种投入时间巨大，回报很可怜的项目，千万不要接。</p><p>最近我有个同事，就是通过接私活，不仅帮他度过了疫情的窘境，还多很很多存款。</p><p>今天就来介绍一下我们程序员经常用的19个接私活平台吧</p><p>搜公众号【野生程序猿】，每天更新面试题干货 | 学习教程 | 面试技巧</p></div><br />作者：野生程序猿A<br />链接：https://www.jianshu.com/p/f0db1da647eb<br />来源：简书<br />著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。</div>', 36, '_self', 'Private work, if, promotion, time, author, wild, programmer, far more than, consider, some', 'There are different opinions from all walks of life about programmers taking private jobs.', '', '<p>There are different opinions from all walks of life about programmers taking private jobs.</p>', '', '', '', '');
INSERT INTO `hh_document` VALUES (6, 32, 'PHP开发工程师', '1', 0, 1607619300, 1607619599, '', 'php,开发,工程师', '', '', 1, '火火', '维护,开发,熟悉,负责,公司,功能,工作,系统,网站,经验', '竞争力分析收藏职位信息岗位职责:', '竞争力分析收藏\n职位信息\n岗位职责:\n1．负责公司旗下产品的程序功能的二次开发与维护工作\n2．负责平台后端代码的编写、维护和运行系统的跟踪维护，功能改进工作\n3．负责与合作游戏开发公司的系统对接，功能开发及日常维护工作\n4．负责公司网站改版、网站功能完善、新系统的开发工作\n5．公司网站数据库的管理与维护\n任职要求：\n1. 两年以上的PHP开发经验，熟悉MVC编程\n2. 熟悉Mysql的使用及语句优化\n3. 熟悉使用Laravel、ThinkPHP等任意一种主流框架\n4. 熟悉LNMP的搭建与维护开发经验的优先。', 10, '_self', 'PHP Development Engineer', 'Maintenance, development, familiarity, responsibility, company, function, work, system, website, experience', 'Competitiveness analysis and collection of position information post responsibilities:', 'Responsibilities: 1. Be responsible for the secondary development and maintenance of the program functions of the company\'s products; 2. Be responsible for the preparation and maintenance of the back-end code of the platform and the tracking and maintenance of the operation system; 3. Be responsible for the system docking, function development and daily maintenance of the cooperative game development company 4. Responsible for website revision, website function improvement and new system development. 5. Management and maintenance of the company\'s website database. Job requirements: 1. More than two years of PHP development experience, familiar with MVC programming 2. Familiar with the use of MySQL and sentence optimization 3. Familiar with the use of larravel, ThinkPHP and other mainstream frameworks. 4. Familiar with the construction and maintenance of LNMP development experience is preferred.', '', '', '', '');
INSERT INTO `hh_document` VALUES (7, 32, 'Java开发工程师', '1', 0, 1607619496, 1607619671, '', 'java,开发,工程师', '', '', 1, '火火', '完成,福利,工作,法定,联调,优先,生日卡,安排,员工,生育保险', '职位信息岗位职责', '职位信息\n岗位职责：\n1.按照计划完成分配的任务。\n2.根据设计完成后台java代码开发及单元测试编写。\n3.完成接口联调的工作。\n4.完成上级安排的其他工作。\n岗位要求\n1、大专以上学历，计算机专业优先\n2、对java开发感兴趣，吃苦耐劳，服从安排的优先\n员工福利\n1、工作时间：做五休二，周一到周五9:00-17:30。享受国家法定节假日，带薪年休假。\n2、法定福利：五险一金（养老保险、医疗保险、生育保险、失业保险、工伤保险、住房公积金）\n3、公司福利：节日礼品、公司活动、员工生日卡、团队建设等', 7, '_self', 'Java Development Engineer', 'Completion, welfare, work, statutory, joint commissioning, priority, birthday card, arrangement, employee, maternity insurance', 'Completion, welfare, work, statutory, joint commissioning, priority, birthday card, arrangement, employee, maternity insurance', 'Responsibilities: 1. Be responsible for the secondary development and maintenance of the program functions of the company\'s products; 2. Be responsible for the preparation and maintenance of the back-end code of the platform and the tracking and maintenance of the operation system; 3. Be responsible for the system docking, function development and daily maintenance of the cooperative game development company 4. Responsible for website revision, website function improvement and new system development. 5. Management and maintenance of the company\'s website database. Job requirements: 1. More than two years of PHP development experience, familiar with MVC programming 2. Familiar with the use of MySQL and sentence optimization 3. Familiar with the use of larravel, ThinkPHP and other mainstream frameworks. 4. Familiar with the construction and maintenance of LNMP development experience is preferred.', '', '', '', '');
INSERT INTO `hh_document` VALUES (8, 33, 'td 内容自动换行 table表格td设置宽度后文字太多自动换行', '1', 0, 1607656157, 1607656234, '', '', '', '', 1, '火火', '设置,table,style,word,即可,然后,layout,fixed,break,wrap', '设置table的style=\"table-layout:', '<span style=\"font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:15px;white-space:normal;background-color:#ffffff;\"=\"\">设置table 的 style=\"table-layout:fixed;\" 然后设置td的 style=\"word-wrap:break-word;\" 即可</span>', 7, '_self', 'TD content wrap table table TD too much text wrap after setting width', 'Set, table, style, word, then, layout, fixed, break, wrap', 'Set the style = table layout:', '<span style=\"white-space:normal;\">设置table 的 style=\"table-layout:fixed;\" 然后设置td的 style=\"word-wrap:break-word;\" 即可</span>', '', '', '', '');
INSERT INTO `hh_document` VALUES (9, 33, '关于php7的3本书分享，PHP7从入门到精通和PHP 7编程实战以及高性能php7', '1', 0, 1607656815, 1607668363, '', '', '', '', 1, '火火', 'php7,作者,本书,转载,链接,帮助,所有,分享,由浅入深,https', '关于php7的3本书分享，高性能php7和PHP7编程实战以及PHP7从入门到精通。', '<div><div><p>关于php7的3本书分享，高性能php7和PHP 7编程实战以及PHP7从入门到精通。</p><p>这3本书几乎涵盖了php7的所有知识点。可以帮助读者由浅入深，循序渐进的理解php7的优越性。是本人经过阅读后，分享给各位。愿对有需要的‘<b>Phper</b>’有所帮助。生活不易，好好学习。</p><p>百度网盘链接: https://pan.baidu.com/s/1XwqhzDoULAYIWgxZaPdJSw</p><p>提取码: 3828</p></div><br />作者：浅风拾月<br />链接：https://www.jianshu.com/p/6b90185134c4<br />来源：简书<br />著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。</div>', 8, '_self', 'About php7 share three books, php7 from entry to proficient and PHP 7 programming practice and high performance php7', 'Php7, author, this book, reprint, link, help, all, share, from shallow to deep, HTTPS', 'Three books about php7 sharing, high performance php7 and php7 programming practice, and php7 from entry to proficient.', 'Three books about php7 sharing, high performance php7 and PHP 7 programming practice, and php7 from entry to proficient.<br />These three books cover almost all the knowledge points of php7. It can help readers understand the advantages of php7 step by step. After reading, I share with you. I would like to help the \"PHPer\" in need. Life is not easy, study hard.<br />Baidu disk link: https://pan.baidu.com/s/1XwqhzDoULAYIWgxZaPdJSw<br />Extraction code: 3828<br />Author: shallow wind picks up the moon<br />Link: https://www.jianshu.com/p/6b90185134c4<br />Source: bamboo slips<br />The copyright belongs to the author. For commercial reprint, please contact the author for authorization. For non-commercial reprint, please indicate the source.<br />', '', '', '', '');
INSERT INTO `hh_document` VALUES (10, 33, 'PHP内置函数file_put_content()，将数据写入文件，使用FILE_APPEND 参数进行内容追加', '1', 0, 1607656821, 1607668278, '', '', '', '', 1, '火火', '写入,file,contents,文件,数据,APPEND,fileName,context,追加,put', 'file_put_contents(fileName,data,flags,context)入参说明：', '<p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\">file_put_contents(fileName,data,flags,context)</p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\">入参说明：</p><table border=\"2\" align=\"left\" style=\"border:1px solid #DFDFDF;word-break:break-word;color:#000000;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;background-color:#ffffff;height:84px;width:542px;\"=\"\"><tbody><tr><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">参数</td><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">说明</td></tr><tr><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">fileName</td><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">要写入数据的文件名</td></tr><tr><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">data</td><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">要写入的数据。类型可以是 string，array（但不能为多维数组），或者是 stream 资源</td></tr><tr><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">flags</td><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">可选，规定如何打开/写入文件。可能的值：<ol style=\"padding-left:40px;\"><li style=\"list-style-type:decimal;margin-left:10px;\">FILE_USE_INCLUDE_PATH：检查 filename 副本的内置路径</li><li style=\"list-style-type:decimal;margin-left:10px;\">FILE_APPEND：在文件末尾以追加的方式写入数据</li><li style=\"list-style-type:decimal;margin-left:10px;\">LOCK_EX：对文件上锁</li></ol></td></tr><tr><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">context</td><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">可选，Context是一组选项，可以通过它修改文本属性</td></tr></tbody></table><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\">file_put_contents默认的是重新写文件，会替换原先的值。当设置 flags 参数值为 FILE_APPEND 时，表示在已有文件内容后面追加内容的方式写入新数据。</p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\">file_put_contents() 的行为实际上等于依次调用 fopen()，fwrite() 以及 fclose() 功能一样。</p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\">eg.</p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><!--?php</p--></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\">file_put_contents(\"result.txt\", \"hello\", FILE_APPEND);</p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><em id=\"__mceDel\">file_put_contents(\"result.txt\", \"world\", FILE_APPEND);<br />?&gt;</em></p>', 21, '_self', 'Private work, if, promotion, time, author, wild, programmer, far more than, consider, some', 'Write, file, contents, file, data, append, put', 'file_ put_ Description of contents (file name, data, flags, context)', '<p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\">file_put_contents(fileName,data,flags,context)</p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\">入参说明：</p><table border=\"2\" align=\"left\" style=\"border:1px solid #DFDFDF;word-break:break-word;color:#000000;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;background-color:#ffffff;height:84px;width:542px;\"=\"\"><tbody><tr><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">参数</td><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">说明</td></tr><tr><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">fileName</td><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">要写入数据的文件名</td></tr><tr><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">data</td><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">要写入的数据。类型可以是 string，array（但不能为多维数组），或者是 stream 资源</td></tr><tr><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">flags</td><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">可选，规定如何打开/写入文件。可能的值：<ol style=\"padding-left:40px;\"><li style=\"list-style-type:decimal;margin-left:10px;\">FILE_USE_INCLUDE_PATH：检查 filename 副本的内置路径</li><li style=\"list-style-type:decimal;margin-left:10px;\">FILE_APPEND：在文件末尾以追加的方式写入数据</li><li style=\"list-style-type:decimal;margin-left:10px;\">LOCK_EX：对文件上锁</li></ol></td></tr><tr><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">context</td><td style=\"border:1px solid #C0C0C0;border-collapse:collapse;padding:8px 14px;min-width:50px;\">可选，Context是一组选项，可以通过它修改文本属性</td></tr></tbody></table><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><br /></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\">file_put_contents默认的是重新写文件，会替换原先的值。当设置 flags 参数值为 FILE_APPEND 时，表示在已有文件内容后面追加内容的方式写入新数据。</p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\">file_put_contents() 的行为实际上等于依次调用 fopen()，fwrite() 以及 fclose() 功能一样。</p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\">eg.</p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><!--?php</p--></p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\">file_put_contents(\"result.txt\", \"hello\", FILE_APPEND);</p><p style=\"margin:10px auto;font-family:\" pingfang=\"\" sc\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"helvetica=\"\" neue\",=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;white-space:normal;background-color:#ffffff;\"=\"\"><em id=\"__mceDel\">file_put_contents(\"result.txt\", \"world\", FILE_APPEND);<br />?&gt;</em></p>', '', '', '', '');
INSERT INTO `hh_document` VALUES (11, 33, 'PHP中try{}catch{}的具体用法详解', '1', 0, 1607656863, 1607863139, '', '', '', '', 17, '火火', '异常,语句,catch,代码,执行,可能,处理,try,getCommandObject,newCommandManage', 'PHP中try{}catch{}是异常处理，将要执行的代码放入TRY块中,如果这些代码执行过程中某一条语句发生异常，则程序直接跳转到CATCH块中，由$e收集错误信息和显示。', '<p style=\"box-sizing:border-box;outline:0px;margin-top:0px;margin-bottom:16px;padding:0px;font-size:16px;color:#4D4D4D;overflow:auto hidden;font-family:-apple-system, \" sf=\"\" ui=\"\" text\",=\"\" arial,=\"\" \"pingfang=\"\" sc\",=\"\" \"hiragino=\"\" sans=\"\" gb\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"wenquanyi=\"\" micro=\"\" hei\",=\"\" sans-serif,=\"\" simhei,=\"\" simsun;white-space:normal;background-color:#ffffff;line-height:26px=\"\" !important;\"=\"\">PHP中try{}catch{}是异常处理，将要执行的代码放入TRY块中,如果这些代码执行过程中某一条语句发生异常，则程序直接跳转到CATCH块中，由$e收集错误信息和显示。任何调用 可能抛出异常的方法的代码都应该使用try语句，Catch语句用来处理可能抛出的异常。</p>\n<pre style=\"box-sizing:border-box;outline:0px;margin-top:0px;margin-bottom:24px;padding:8px;position:relative;white-space:pre-wrap;overflow-wrap:break-word;overflow-x:auto;font-family:Consolas, Inconsolata, Courier, monospace;font-size:14px;line-height:22px;background-color:#FFFFFF;\"> < ?<span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\">php </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#0000FF;\">try</span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\"> { </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#800080;\">$mgr</span> = <span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#0000FF;\">new</span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\"> CommandManager(); </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#800080;\">$cmd</span> = <span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#800080;\">$mgr</span>->getCommandObject(\"realcommand\"<span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\">); </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#800080;\">$cmd</span>-><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\">execute();   \n} </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#0000FF;\">catch</span> (<span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#0000FF;\">Exception</span> <span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#800080;\">$e</span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\">) { </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#0000FF;\">print</span> <span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#800080;\">$e</span>-><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\">getMessage(); </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#0000FF;\">exit</span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\">();   \n} </span></pre>', 19, '_self', 'How to use try {} catch} in PHP', 'Exception, statement, catch, code, execute, possible, handle, try, getcommandobject, newcommandmanage', 'In PHP, try {} catch} is exception handling. The code to be executed is put into the try block. If an exception occurs in a statement during the execution of these codes, the program will jump to the catch block directly, and the error information will be collected and displayed by $E.', '<p sf=\"\" ui=\"\" text\",=\"\" arial,=\"\" \"pingfang=\"\" sc\",=\"\" \"hiragino=\"\" sans=\"\" gb\",=\"\" \"microsoft=\"\" yahei\",=\"\" \"wenquanyi=\"\" micro=\"\" hei\",=\"\" sans-serif,=\"\" simhei,=\"\" simsun;white-space:normal;background-color:#ffffff;line-height:26px=\"\" !important;\"=\"\" style=\"margin-top: 0px; margin-bottom: 16px; white-space: normal; box-sizing: border-box; outline: 0px; padding: 0px; font-size: 16px; color: rgb(77, 77, 77); overflow: auto hidden;\">PHP中try{}catch{}是异常处理，将要执行的代码放入TRY块中,如果这些代码执行过程中某一条语句发生异常，则程序直接跳转到CATCH块中，由$e收集错误信息和显示。任何调用 可能抛出异常的方法的代码都应该使用try语句，Catch语句用来处理可能抛出的异常。</p>\n<pre style=\"box-sizing:border-box;outline:0px;margin-top:0px;margin-bottom:24px;padding:8px;position:relative;white-space:pre-wrap;overflow-wrap:break-word;overflow-x:auto;font-family:Consolas, Inconsolata, Courier, monospace;font-size:14px;line-height:22px;background-color:#FFFFFF;\"> < ?<span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\">php </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#0000FF;\">try</span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\"> { </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#800080;\">$mgr</span> = <span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#0000FF;\">new</span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\"> CommandManager(); </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#800080;\">$cmd</span> = <span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#800080;\">$mgr</span>->getCommandObject(\"realcommand\"<span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\">); </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#800080;\">$cmd</span>-><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\">execute();   \n} </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#0000FF;\">catch</span> (<span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#0000FF;\">Exception</span> <span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#800080;\">$e</span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\">) { </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#0000FF;\">print</span> <span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#800080;\">$e</span>-><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\">getMessage(); </span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;color:#0000FF;\">exit</span><span style=\"box-sizing:border-box;outline:0px;margin:0px;padding:0px;overflow-wrap:break-word;\">();   \n} </span></pre>', '', '', '', '');

-- ----------------------------
-- Table structure for hh_document_article
-- ----------------------------
DROP TABLE IF EXISTS `hh_document_article`;
CREATE TABLE `hh_document_article`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `diqu` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '测试地区',
  `danwenjian` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '测试单文件',
  `duowenjian` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '测试多文件',
  `danshipin` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '测试单视频',
  `duoshipin` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '测试多视频',
  `duoxuan` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '测试多选',
  `quseqi` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '测试取色器',
  `ceshitags` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '测试数组',
  `ceshibdditu` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '113.278283,23.164317' COMMENT '测试百度地图',
  `ceshiqqditu` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '测试腾讯地图',
  `ceshiselectdx` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '测试下拉框多选',
  `ceshigjixldx` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '测试高级下拉单选',
  `ceshimarkdown` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '测试markdown编辑器',
  `ceshidutu` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '测试多图',
  `jibie` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '9' COMMENT '级别',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文章表(模型)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_document_article
-- ----------------------------
INSERT INTO `hh_document_article` VALUES (1, '', '', NULL, '', NULL, '', '', '', '113.278283,23.164317', '', '', '', NULL, NULL, '1607586623');
INSERT INTO `hh_document_article` VALUES (2, '', '', NULL, '', NULL, '', '', '', '113.278283,23.164317', '', '', '', NULL, NULL, '1607599952');
INSERT INTO `hh_document_article` VALUES (3, '', '', NULL, '', NULL, '', '', '', '113.278283,23.164317', '', '', '', NULL, NULL, '1607605176');
INSERT INTO `hh_document_article` VALUES (4, '', '', NULL, '', NULL, '', '', '', '113.278283,23.164317', '', '', '', NULL, NULL, '1607608210');
INSERT INTO `hh_document_article` VALUES (5, '', '', NULL, '', NULL, '', '', '', '113.278283,23.164317', '', '', '', NULL, NULL, '1607609240');
INSERT INTO `hh_document_article` VALUES (6, '', '', NULL, '', NULL, '', '', '', '113.278283,23.164317', '', '', '', NULL, NULL, '1607619300');
INSERT INTO `hh_document_article` VALUES (7, '', '', NULL, '', NULL, '', '', '', '113.278283,23.164317', '', '', '', NULL, NULL, '1607619496');
INSERT INTO `hh_document_article` VALUES (8, '', '', NULL, '', NULL, '', '', '', '113.278283,23.164317', '', '', '', NULL, NULL, '1607656157');
INSERT INTO `hh_document_article` VALUES (9, '', '', NULL, '', NULL, '', '', '', '113.278283,23.164317', '', '', '', NULL, NULL, '1607656815');
INSERT INTO `hh_document_article` VALUES (10, '', '', NULL, '', NULL, '', '', '', '113.278283,23.164317', '', '', '', NULL, NULL, '1607656821');
INSERT INTO `hh_document_article` VALUES (11, '', '', NULL, '', NULL, '', '', '', '113.278283,23.164317', '', '', '', NULL, NULL, '1607656863');

-- ----------------------------
-- Table structure for hh_download
-- ----------------------------
DROP TABLE IF EXISTS `hh_download`;
CREATE TABLE `hh_download`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `category_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '所属分类ID',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `status` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)',
  `sort` int(10) NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `title_en` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '英文标题',
  `flags` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '自定义属性',
  `tags` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'TAG标签',
  `thumb` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '缩略图',
  `source` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '来源',
  `uid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '管理员ID',
  `writer` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '作者',
  `keywords` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '关键词',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '描述',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '内容',
  `view` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '下载表(模型)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hh_hooks
-- ----------------------------
DROP TABLE IF EXISTS `hh_hooks`;
CREATE TABLE `hh_hooks`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '钩子名称',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '描述',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '类型(1:视图,2:控制器)',
  `addons` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '钩子挂载的插件\',\'分割',
  `system` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否系统',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 100 COMMENT '排序',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 44 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '插件钩子' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hh_image
-- ----------------------------
DROP TABLE IF EXISTS `hh_image`;
CREATE TABLE `hh_image`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `category_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '所属分类ID',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `status` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)',
  `sort` int(10) NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `title_en` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '英文标题',
  `flags` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '自定义属性',
  `tags` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'TAG标签',
  `thumb` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '缩略图',
  `source` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '来源',
  `uid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '管理员ID',
  `writer` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '作者',
  `keywords` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '关键词',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '描述',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '内容',
  `view` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '图片表(模型)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hh_link_type
-- ----------------------------
DROP TABLE IF EXISTS `hh_link_type`;
CREATE TABLE `hh_link_type`  (
  `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '类型名称',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '友情链接类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_link_type
-- ----------------------------
INSERT INTO `hh_link_type` VALUES (1, '首页友链', '首页友链', 0);

-- ----------------------------
-- Table structure for hh_links
-- ----------------------------
DROP TABLE IF EXISTS `hh_links`;
CREATE TABLE `hh_links`  (
  `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增ID',
  `typeid` smallint(5) NOT NULL COMMENT '类型编号，关联类型',
  `url` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '链接地址',
  `name` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '链接名称',
  `thumb` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '缩略图',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '链接描述',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '添加时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '修改时间',
  `show_way` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '显示方式 1：文字显示；2：图片显示',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否审核 0：未审核；1：审核；默认1',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '友情链接表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_links
-- ----------------------------
INSERT INTO `hh_links` VALUES (1, 1, 'http://www.baidu.com', '百度', '', '百度链接', 1608103725, 0, 2, 1, 0);

-- ----------------------------
-- Table structure for hh_log
-- ----------------------------
DROP TABLE IF EXISTS `hh_log`;
CREATE TABLE `hh_log`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `admin_id` int(10) NOT NULL DEFAULT 0 COMMENT '管理员id',
  `admin_ip` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '操作管理员IP',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '操作类型：1：新增；2：修改；3：删除',
  `table_pk_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '表主键id',
  `table_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '表名',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '表注释',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '恢复状态：1：已恢复；0：未恢复',
  `dtime` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '管理员操作日志主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hh_log_content
-- ----------------------------
DROP TABLE IF EXISTS `hh_log_content`;
CREATE TABLE `hh_log_content`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `log_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '日志主表id',
  `field_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '字段名',
  `field_type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '字段数据类型',
  `field_value` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '原来字段值',
  `current_field_value` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '当前字段值',
  `comment` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '字段注释',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '管理员操作日志从表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hh_logs
-- ----------------------------
DROP TABLE IF EXISTS `hh_logs`;
CREATE TABLE `hh_logs`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '操作节点-模型和控制器和方法',
  `operator` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '操作员，管理员id',
  `description` char(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `operate_time` int(10) NOT NULL DEFAULT 0 COMMENT '操作时间',
  `operate_ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '操作ip',
  `operate_area` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '操作地区',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '管理员行为日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_logs
-- ----------------------------
INSERT INTO `hh_logs` VALUES (1, 'admin/Log/index', 1, '操作日志', 1609069362, '127.0.0.1', '本机地址-');

-- ----------------------------
-- Table structure for hh_message
-- ----------------------------
DROP TABLE IF EXISTS `hh_message`;
CREATE TABLE `hh_message`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `uid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '用户名',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'IP',
  `status` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)',
  `sort` int(10) NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `company` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '公司名称',
  `uname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '您的姓名',
  `contact` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '手机 / QQ',
  `title` char(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '评价' COMMENT '评价 / 意见',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '留言内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '留言表(表单)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for hh_model
-- ----------------------------
DROP TABLE IF EXISTS `hh_model`;
CREATE TABLE `hh_model`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键自增ID',
  `form` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否表单(1:是,0:否)',
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '模型(表单)名称',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '简介',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '模型(表单)标识(即表名)只能使用英文且不能重复',
  `fields` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '字段列表',
  `extend` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '模型性质(目前仅支持1:文档模型,继承基础文档,0:独立模型)',
  `list_template` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '列表页模板',
  `index_template` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '频道封面页模板',
  `article_template` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文章内容页模板',
  `article_rule` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '文章命名规则',
  `list_rule` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '列表命名规则',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(1:启用,0:禁用)',
  `need_pk` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '新建表时增加的id字段是否是主键(1:是,0:否)',
  `engine_type` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'MyISAM' COMMENT '数据库引擎(MyISAM;InnoDB;MEMORY;BLACKHOLE;MRG_MYISAM;ARCHIVE)',
  `is_system` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否为系统模型,系统模型将不能删除(0:否,1:是)',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `setting` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '配置信息',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `title`(`title`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '模型(表单)表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_model
-- ----------------------------
INSERT INTO `hh_model` VALUES (1, 0, '基础文档', '', 'document', '{\"1\":[{\"id\":3},{\"id\":141},{\"id\":9},{\"id\":10},{\"id\":11},{\"id\":13},{\"id\":15},{\"id\":16},{\"id\":17},{\"id\":18},{\"id\":19},{\"id\":6},{\"id\":7},{\"id\":4},{\"id\":5}],\"2\":[{\"id\":1},{\"id\":2},{\"id\":14},{\"id\":84},{\"id\":85},{\"id\":86},{\"id\":133},{\"id\":70},{\"id\":135},{\"id\":137},{\"id\":138}]}', 0, 'list_document.html', 'index_document.html', 'article_document.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', 1557843306, 1607496240, 1, 1, 'MyISAM', 1, 100, NULL);
INSERT INTO `hh_model` VALUES (2, 0, '文章', '', 'article', '{\"1\":[{\"id\":21},{\"id\":3},{\"id\":141},{\"id\":9},{\"id\":10},{\"id\":11},{\"id\":13},{\"id\":15},{\"id\":16},{\"id\":17},{\"id\":18},{\"id\":19},{\"id\":6},{\"id\":7},{\"id\":4},{\"id\":5},{\"id\":185}],\"2\":[{\"id\":1},{\"id\":2},{\"id\":14},{\"id\":84},{\"id\":85},{\"id\":86},{\"id\":133},{\"id\":70},{\"id\":135},{\"id\":137},{\"id\":138},{\"id\":119},{\"id\":126},{\"id\":123},{\"id\":122},{\"id\":43},{\"id\":120},{\"id\":66},{\"id\":124},{\"id\":125},{\"id\":172},{\"id\":62},{\"id\":63},{\"id\":64},{\"id\":65}]}', 1, 'list_article.html', 'index_article.html', 'article_article.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', 1557844112, 1607496268, 1, 1, 'MyISAM', 1, 90, NULL);
INSERT INTO `hh_model` VALUES (3, 0, '产品', '', 'product', '{\"1\":[{\"id\":24},{\"id\":47},{\"id\":48},{\"id\":32},{\"id\":82},{\"id\":143},{\"id\":68},{\"id\":29},{\"id\":30},{\"id\":46},{\"id\":27},{\"id\":28},{\"id\":25},{\"id\":26},{\"id\":49},{\"id\":50},{\"id\":51},{\"id\":52},{\"id\":54},{\"id\":56}],\"2\":[{\"id\":22},{\"id\":23},{\"id\":72},{\"id\":34},{\"id\":69},{\"id\":38},{\"id\":39},{\"id\":71},{\"id\":144},{\"id\":145},{\"id\":146}]}', 0, 'list_product.html', 'index_product.html', 'article_product.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', 1557844601, 1607496105, 1, 1, 'MyISAM', 1, 80, NULL);
INSERT INTO `hh_model` VALUES (4, 0, '图片', '', 'image', '{\"1\":[{\"id\":88},{\"id\":89},{\"id\":90},{\"id\":91},{\"id\":92},{\"id\":93}],\"2\":[{\"id\":87}]}', 0, 'list_image.html', 'index_image.html', 'article_image.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', 1600301603, 1603452659, 0, 1, 'MyISAM', 0, 0, NULL);
INSERT INTO `hh_model` VALUES (5, 0, '下载', '', 'download', '{\"1\":[{\"id\":95},{\"id\":96},{\"id\":97},{\"id\":98},{\"id\":99},{\"id\":100}],\"2\":[{\"id\":94}]}', 0, 'list_download.html', 'index_download.html', 'article_download.html', '{Y}/{M}{D}/{aid}.html', 'list_{tid}_{page}.html', 1600301812, 1603452597, 0, 1, 'MyISAM', 0, 0, NULL);
INSERT INTO `hh_model` VALUES (6, 1, '留言', '留言表', 'message', '{\"1\":[{\"id\":193},{\"id\":194},{\"id\":195},{\"id\":196},{\"id\":197},{\"id\":198},{\"id\":199},{\"id\":200},{\"id\":201},{\"id\":202},{\"id\":203},{\"id\":204}],\"2\":[{\"id\":192}]}', 0, '', '', '', '', '', 1607497298, 1608516131, 1, 1, 'MyISAM', 0, 0, 'a:6:{s:16:\"allowmultisubmit\";s:1:\"1\";s:10:\"allowunreg\";s:1:\"1\";s:8:\"isverify\";s:1:\"0\";s:7:\"forward\";s:0:\"\";s:5:\"mails\";s:16:\"185789392@qq.com\";s:8:\"interval\";s:1:\"0\";}');

-- ----------------------------
-- Table structure for hh_product
-- ----------------------------
DROP TABLE IF EXISTS `hh_product`;
CREATE TABLE `hh_product`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `category_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '所属分类ID',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标题',
  `status` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '1' COMMENT '数据状态(-1:删除,0:隐藏-禁用,1:显示-正常,2:待审核,3:草稿)',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '修改时间',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '描述',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '内容',
  `thumb` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '缩略图',
  `title_en` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '英文标题',
  `description_en` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '英文描述',
  `content_en` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '英文内容',
  `view` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  `flags` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '自定义属性',
  `tags` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'TAG标签',
  `yanshi` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '演示地址',
  `hyfl` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '行业分类',
  `wzys` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '网站颜色',
  `jrsb` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '兼容设备',
  `yybm` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '语言编码',
  `file` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '程序文件',
  `keywords` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '关键词',
  `keywords_en` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '英文关键词',
  `target` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '_self' COMMENT '窗口类型',
  `uid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '管理员ID',
  `source` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '来源',
  `writer` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '作者',
  `rel` char(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'rel 属性',
  `position` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '推荐位',
  `redirecturl` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '跳转地址',
  `color` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标题颜色',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '产品表(模型)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_product
-- ----------------------------
INSERT INTO `hh_product` VALUES (1, 3, '响应式精密机械模具类网站织梦模板(自适应手机端)', '1', 0, 1607619849, 1608212286, '模板名称： 响应式精密机械模具类网站织梦模板(自适应手机端)+PC+wap+利于SEO优化', '模板名称：\n响应式精密机械模具类网站织梦模板(自适应手机端)+PC+wap+利于SEO优化\n模板介绍：\n织梦最新内核开发的模板，该模板属于企业通用、精密仪器、模具类企业都可使用，\n这款模板使用范围极广，不仅仅局限于一类型的企业，你只需要把图片和产品内容；\n换成你的，颜色都可以修改，改完让你耳目一新的感觉！\n自带最新的手机移动端，同一个后台，数据即时同步，简单适用！\n原创设计、手工书写DIV+CSS，\n完美兼容IE7+、Firefox、Chrome、360浏览器等；主流浏览器；\n页面简洁简单，容易管理，DEDE内核都可以使用；附带测试数据！\n模板特点：\n1.一款利于SEO的模板，手工CSS+DIV，图片ALT，H系列标签已合理运用。\n2.同步手机站功能，手机站很强大。\n使用程序：\n织梦DEDECMS版本都可以使用。\n模板页面：\nindex.htm 首页模板\nhead.htm\nfooter.htm \narticle_article.htm 文章内容\n这里不一一列出！\n 温馨提示：\n按照正常的织梦安装步骤来安装还原就可以用了，从后台重新点击保存下系统基本参数。 系统>系统基本参数> 保存（确定）。\n 后期bug修正：\n暂无', '', 'Responsive website dream weaving template for precision mechanical mould (self-adaptive mobile phone terminal)', 'Responsive website dream weaving', 'Template name:<br />Responsive precision mechanical mold website weaving template (adaptive mobile phone terminal) + PC + WAP + is conducive to SEO optimization<br />Template introduction:<br />It is a template developed by Zhimeng\'s latest kernel. The template belongs to the enterprise\'s general purpose, precision instruments and mold enterprises,<br />This template is widely used, not only limited to a type of enterprise, you only need to put pictures and product content;<br />Change to your, the color can be modified, change to let you refreshing feeling!<br />With the latest mobile phone mobile terminal, the same background, real-time data synchronization, simple and applicable!<br />Original design, handwritten div + CSS,<br />Perfect compatibility with IE7 +, Firefox, chrome, 360 browser, etc;<br />The page is simple, easy to manage, Dede kernel can be used; with test data!<br />Template features:<br />1. A template for SEO, manual CSS + div, picture alt, H series tags have been used reasonably.<br />2. Synchronous mobile station function, mobile station is very powerful.<br />Application procedure:<br />Both versions of dream weaving dedecms can be used.<br />Template page:<br />index.htm  Front page template<br />head.htm<br />footer.htm<br />article_ article.htm  Article content<br />I don\'t list them here!<br />reminder:<br />According to the normal Zhimeng installation steps to install and restore can be used, from the background to save the basic parameters of the system. System > system basic parameters > Save (OK).<br />Later bug correction:<br />Not yet<br />', 2, '', '', '', '新闻资讯', '红色', 'PC', 'GBK简体', '', '模板,使用,可以,手机,存下,系统,内核,企业,后台,手工', 'Template, use, can, mobile phone, save, system, kernel, enterprise, background, manual', '_self', 1, '', '火火', '', '', '', '');
INSERT INTO `hh_product` VALUES (2, 3, '家政月嫂保姆服务类网站织梦模板(带手机端)', '1', 0, 1607620131, 1608212299, '模板名称：', '模板名称：\n家政月嫂保姆服务类网站织梦模板(带手机端)+PC+移动端+利于SEO优化\n模板介绍：\n织梦最新内核开发的模板，该模板属于企业通用、家政服务、月嫂、保姆类企业使用，\n自带最新的手机移动端，同一个后台，数据即时同步，简单适用！\n原创设计、手工书写DIV+CSS，\n完美兼容IE7+、Firefox、Chrome、360浏览器等；主流浏览器；\n页面简洁简单，容易管理，DEDE内核都可以使用；附带测试数据！\n模板特点：\n1.一款利于SEO的模板，手工CSS+DIV，图片ALT，H系列标签已合理运用。\n2.同步手机站功能，手机站很强大。\n3.广告位完美布局，网站颜色搭配清晰，利于用户体验，利于SEO排名。\n4.带测试数据，带返回顶部，带同步数据手机站。\n 使用程序：\n织梦DEDECMS版本都可以使用。\n 模板页面：\nindex.htm 首页模板\nhead.htm\nfooter.htm \narticle_article.htm 文章内容\n这里不一一列出！\n 温馨提示：\n按照正常的织梦安装步骤来安装还原就可以用了，从后台重新点击保存下系统基本参数。 系统>系统基本参数> 保存（确定）。\n 后期bug修正：\n暂无', '', 'Dream weaving template (with mobile phone terminal) for homemakers and housewives', 'Dream weaving template (with mobile phone terminal) for homemakers and housewives', 'Template name: Zhimeng template (with mobile phone end) + PC + mobile terminal + conducive to SEO optimization template introduction: Zhimeng\'s latest kernel development template, the template belongs to enterprise general, housekeeping service, sister-in-law, nanny enterprises, with the latest mobile terminal, the same background, data synchronization, simple and applicable! Original design, handwritten div + CSS, perfectly compatible with IE7 +, Firefox, chrome, 360 browsers, etc.; the page is simple and easy to manage, Dede kernel can be used; with test data! Template features: 1. A template conducive to SEO, manual CSS + div, picture alt, H series tags have been used reasonably. 2. Synchronous mobile station function, mobile station is very powerful. 3. Perfect layout of advertising space and clear color matching of website are conducive to user experience and SEO ranking. 4. Mobile phone station with test data, return to the top and synchronous data. Use procedures: dream weaving dedecms version can be used. Template page: index.htm  Front page template head.htm  footer.htm  article_ article.htm  The content of the article is not listed here! Warm tips: according to the normal Zhimeng installation steps to install and restore can be used, from the background, click to save the basic parameters of the system. System > system basic parameters > Save (OK). Later bug correction: no', 5, '', '', '', '新闻资讯', '红色', 'PC', 'GBK简体', '', '模板,手机,利于,使用,数据,月嫂,同步,存下,可以,系统', 'Template, mobile phone, convenience, usage, data, monthly sister-in-law, synchronization, storage, yes, system', '_self', 1, '', '火火', '', '', '', '');
INSERT INTO `hh_product` VALUES (3, 3, 'HTML5智能锁具电子产片研发类网站织梦模板(自适应手机端)', '1', 0, 1607620314, 1608212315, '模板名称： HTML5智能锁具电子产片研发类网站织梦模板(自适应手机端)+PC+wap+利于SEO优化', '模板名称：\nHTML5智能锁具电子产片研发类网站织梦模板(自适应手机端)+PC+wap+利于SEO优化\n模板介绍：\n织梦最新内核开发的模板，该模板属于企业通用类、智能锁具、电子片研发类企业都可使用，\n这款模板使用范围极广，不仅仅局限于一类型的企业，你只需要把图片和产品内容；\n换成你的，颜色都可以修改，改完让你耳目一新的感觉！\n响应式自适应设计，同一个后台，数据即时同步，简单适用！\n原创设计、手工书写DIV+CSS，\n完美兼容IE7+、Firefox、Chrome、360浏览器等；主流浏览器；\n页面简洁简单，容易管理，DEDE内核都可以使用；附带测试数据！\n模板特点：\n1.一款利于SEO的模板，手工CSS+DIV，图片ALT，H系列标签已合理运用。\n2.同步手机站功能，手机站很强大。\n 使用程序：\n织梦DEDECMS版本都可以使用。\n 模板页面：\nindex.htm 首页模板\nhead.htm\nfooter.htm \narticle_article.htm 文章内容\n这里不一一列出！\n 温馨提示：\n按照正常的织梦安装步骤来安装还原就可以用了，从后台重新点击保存下系统基本参数。 系统>系统基本参数> 保存（确定）。\n 后期bug修正：\n暂无', '', 'HTML5 smart lock electronic product R & D website dream making template (adaptive mobile phone)', 'HTML5 smart lock electronic product', 'Template name:<br />HTML5 smart lock electronic production film R & D website dream making template (adaptive mobile terminal) + PC + WAP + conducive to SEO optimization<br />Template introduction:<br />The template developed by Zhimeng\'s latest kernel is applicable to enterprises of general use, intelligent locks and electronic chip R & D,<br />This template is widely used, not only limited to a type of enterprise, you only need to put pictures and product content;<br />Change to your, the color can be modified, change to let you refreshing feeling!<br />Responsive adaptive design, the same background, real-time data synchronization, simple and applicable!<br />Original design, handwritten div + CSS,<br />Perfect compatibility with IE7 +, Firefox, chrome, 360 browser, etc;<br />The page is simple, easy to manage, Dede kernel can be used; with test data!<br />Template features:<br />1. A template for SEO, manual CSS + div, picture alt, H series tags have been used reasonably.<br />2. Synchronous mobile station function, mobile station is very powerful.<br />Application procedure:<br />Both versions of dream weaving dedecms can be used.<br />Template page:<br />index.htm  Front page template<br />head.htm<br />footer.htm<br />article_ article.htm  Article content<br />I don\'t list them here!<br />reminder:<br />According to the normal Zhimeng installation steps to install and restore can be used, from the background to save the basic parameters of the system. System > system basic parameters > Save (OK).<br />Later bug correction:<br />Not yet<br />', 7, '', '', '', '新闻资讯', '红色', 'PC', 'GBK简体', '', '模板,使用,可以,存下,锁具,系统,内核,手机,企业,后台', 'Template, use, can, save, lock, system, kernel, mobile phone, enterprise, background', '_self', 1, '', '火火', '', '', '', '');
INSERT INTO `hh_product` VALUES (4, 3, '新闻时报资讯类网站织梦模板(带手机端)', '1', 0, 1607620524, 1608212334, '模板名称：', '模板名称：<br />新闻时报资讯类网站织梦模板(带手机端)+PC+移动端+利于SEO优化<br />模板介绍：<br />织梦最新内核开发的模板，该模板属于财新闻、时报、资讯料类企业使用，<br />自带最新的手机移动端，同一个后台，数据即时同步，简单适用！<br />原创设计、手工书写DIV+CSS，<br />完美兼容IE7+、Firefox、Chrome、360浏览器等；主流浏览器；<br />页面简洁简单，容易管理，DEDE内核都可以使用；附带测试数据！<br />模板特点：<br /><br />1.一款利于SEO的模板，手工CSS+DIV，图片ALT，H系列标签已合理运用。<br />2.同步手机站功能，手机站很强大。<br /><br /> 使用程序：<br />织梦DEDECMS版本都可以使用。<br /> 模板页面：<br />index.htm 首页模板<br />head.htm<br />footer.htm <br />article_article.htm 文章内容<br /><br />这里不一一列出！<br /> 温馨提示：<br />按照正常的织梦安装步骤来安装还原就可以用了，从后台重新点击保存下系统基本参数。 系统>系统基本参数> 保存（确定）。<br /> 后期bug修正：<br />暂无<br />', '', 'Dream weaving template of news times information website (with mobile terminal)', 'Dream weaving template of news times information website', 'Template name:<br />Dream weaving template of news times information website (with mobile terminal) + PC + mobile terminal + conducive to SEO optimization<br />Template introduction:<br />The template developed by Zhimeng\'s latest kernel is used by financial news, times and information material enterprises,<br />With the latest mobile phone mobile terminal, the same background, real-time data synchronization, simple and applicable!<br />Original design, handwritten div + CSS,<br />Perfect compatibility with IE7 +, Firefox, chrome, 360 browser, etc;<br />The page is simple, easy to manage, Dede kernel can be used; with test data!<br />Template features:<br />1. A template for SEO, manual CSS + div, picture alt, H series tags have been used reasonably.<br />2. Synchronous mobile station function, mobile station is very powerful.<br />Application procedure:<br />Both versions of dream weaving dedecms can be used.<br />Template page:<br />index.htm  Front page template<br />head.htm<br />footer.htm<br />article_ article.htm  Article content<br />I don\'t list them here!<br />reminder:<br />According to the normal Zhimeng installation steps to install and restore can be used, from the background to save the basic parameters of the system. System > system basic parameters > Save (OK).<br />Later bug correction:<br />Not yet<br />', 1, '', '', '', '新闻资讯', '红色', 'PC', 'GBK简体', '', '模板,使用,手机,存下,可以,系统,内核,后台,手工,时报', 'Template, use, mobile phone, save, can, system, kernel, background, manual, times', '_self', 1, '', '火火', '', '', '', '');
INSERT INTO `hh_product` VALUES (5, 3, '情感新闻资讯类网站织梦模板(带手机端)', '1', 0, 1607620686, 1608212269, '模板名称：', '模板名称：<br />情感新闻资讯类网站织梦模板(带手机端)+PC+移动端+利于SEO优化<br />模板介绍：<br />织梦最新内核开发的模板，该模板属于情感、新闻、资讯类企业使用，<br />自带最新的手机移动端，同一个后台，数据即时同步，简单适用！<br />原创设计、手工书写DIV+CSS，<br />完美兼容IE7+、Firefox、Chrome、360浏览器等；主流浏览器；<br />页面简洁简单，容易管理，DEDE内核都可以使用；附带测试数据！<br />模板特点：<br /><br />1.一款利于SEO的模板，手工CSS+DIV，图片ALT，H系列标签已合理运用。<br />2.同步手机站功能，手机站很强大。<br /><br /> 使用程序：<br />织梦DEDECMS版本都可以使用。<br /> 模板页面：<br />index.htm 首页模板<br />head.htm<br />footer.htm <br />article_article.htm 文章内容<br /><br />这里不一一列出！<br /> 温馨提示：<br />按照正常的织梦安装步骤来安装还原就可以用了，从后台重新点击保存下系统基本参数。 系统>系统基本参数> 保存（确定）。<br /> 后期bug修正：<br />暂无<br />', '', 'Dream weaving template for emotional news and information websites (with mobile terminal)', 'Dream weaving template for emotional news and information websites', 'Template name:<br />Emotional news information website dream weaving template (with mobile terminal) + PC + mobile terminal + conducive to SEO optimization<br />Template introduction:<br />The template developed by Zhimeng\'s latest kernel is used by emotional, news and information enterprises,<br />With the latest mobile phone mobile terminal, the same background, real-time data synchronization, simple and applicable!<br />Original design, handwritten div + CSS,<br />Perfect compatibility with IE7 +, Firefox, chrome, 360 browser, etc;<br />The page is simple, easy to manage, Dede kernel can be used; with test data!<br />Template features:<br />1. A template for SEO, manual CSS + div, picture alt, H series tags have been used reasonably.<br />2. Synchronous mobile station function, mobile station is very powerful.<br />Application procedure:<br />Both versions of dream weaving dedecms can be used.<br />Template page:<br />index.htm  Front page template<br />head.htm<br />footer.htm<br />article_ article.htm  Article content<br />I don\'t list them here!<br />reminder:<br />According to the normal Zhimeng installation steps to install and restore can be used, from the background to save the basic parameters of the system. System > system basic parameters > Save (OK).<br />Later bug correction:<br />Not yet<br />', 4, '', '', 'http://dema234.eyysz.cn/', '新闻资讯', '红色', 'PC', 'GBK简体', '', '模板,使用,手机,存下,可以,系统,内核,后台,手工,利于', 'Template, use, mobile phone, save, can, system, kernel, background, manual, conducive to', '_self', 1, '', '火火', '', '', '', '');
INSERT INTO `hh_product` VALUES (6, 3, '营销型压滤机过滤设备类网站织梦模板(带手机端) ', '1', 0, 1607620871, 1608212252, '模板名称：', '模板名称：<br />营销型压滤机过滤设备类网站织梦模板(带手机端)+PC+移动端+利于SEO优化<br />模板介绍：<br />织梦最新内核开发的模板，该模板属于企业通用、过滤机、过滤设备类企业使用，<br />自带最新的手机移动端，同一个后台，数据即时同步，简单适用！<br />原创设计、手工书写DIV+CSS，<br />完美兼容IE7+、Firefox、Chrome、360浏览器等；主流浏览器；<br />页面简洁简单，容易管理，DEDE内核都可以使用；附带测试数据！<br />模板特点：<br /><br />1.一款利于SEO的模板，手工CSS+DIV，图片ALT，H系列标签已合理运用。<br />2.同步手机站功能，手机站很强大。<br /><br /> 使用程序：<br />织梦DEDECMS版本都可以使用。<br /> 模板页面：<br />index.htm 首页模板<br />head.htm<br />footer.htm <br />article_article.htm 文章内容<br /><br />这里不一一列出！<br /> 温馨提示：<br />按照正常的织梦安装步骤来安装还原就可以用了，从后台重新点击保存下系统基本参数。 系统>系统基本参数> 保存（确定）。<br /> 后期bug修正：<br />暂无<br />', '', '', '', 'Template name:<br />Marketing filter press filtering equipment website weaving dream template (with mobile terminal) + PC + mobile terminal + conducive to SEO optimization<br />Template introduction:<br />The template is developed by Zhimeng\'s latest kernel. The template is used by enterprises of general use, filter and filter equipment,<br />With the latest mobile phone mobile terminal, the same background, real-time data synchronization, simple and applicable!<br />Original design, handwritten div + CSS,<br />Perfect compatibility with IE7 +, Firefox, chrome, 360 browser, etc;<br />The page is simple, easy to manage, Dede kernel can be used; with test data!<br />Template features:<br />1. A template for SEO, manual CSS + div, picture alt, H series tags have been used reasonably.<br />2. Synchronous mobile station function, mobile station is very powerful.<br />Application procedure:<br />Both versions of dream weaving dedecms can be used.<br />Template page:<br />index.htm  Front page template<br />head.htm<br />footer.htm<br />article_ article.htm  Article content<br />I don\'t list them here!<br />reminder:<br />According to the normal Zhimeng installation steps to install and restore can be used, from the background to save the basic parameters of the system. System > system basic parameters > Save (OK).<br />Later bug correction:<br />Not yet<br />', 3, '', '', 'http://dema233.eyysz.cn/', '新闻资讯', '红色', 'PC', 'GBK简体', '', '模板,使用,过滤设备,手机,存下,可以,过滤机,系统,内核,后台', '', '_self', 1, '', '火火', '', '', '', '');
INSERT INTO `hh_product` VALUES (7, 3, '中英双语科技新材料类网站织梦模板（带手机端）', '1', 0, 1607670272, 1608212356, '模板名称：', '<strong style=\"margin:0px;white-space:normal;background-color:#FFFFFF;line-height:24px;color:#FFFFFF;font-family:Arial;font-size:15px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板名称：</span></strong><br style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;line-height:26px;\"=\"\"><span style=\"margin:0px auto;color:#333333;font-family:Tahoma, 宋体, Geneva, sans-serif;font-size:14px;white-space:normal;background-color:#FFFFFF;\"><strong style=\"margin:0px auto;\">中英双语科技新材料类网站<a href=\"http://www.dede58.com/\" target=\"_blank\" style=\"margin:0px auto;color:#333333;text-decoration-line:none;cursor:pointer;\"><u style=\"margin:0px auto;\">织梦模板</u></a>（带手机端）+利于SEO优化</strong></span><br style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;line-height:26px;\"=\"\"><strong style=\"margin:0px;white-space:normal;background-color:#FFFFFF;line-height:24px;color:#FFFFFF;font-family:Arial;font-size:15px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板介绍：</span></strong><br style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;line-height:26px;\"=\"\"><h2 style=\"margin:0px;padding:0px;font-size:14px;font-weight:normal;white-space:normal;background-color:#FFFFFF;color:#444444;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" stheiti;line-height:24px;\"=\"\"><span style=\"margin:0px auto;color:#465160;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;line-height:26px;\"=\"\">织梦最新内核开发的模板，该模板属于科技新材料、中英双语类</span><span style=\"margin:0px auto;color:#465160;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;line-height:26px;\"=\"\">企业使用，一款适用性很强的模板，基本可以适合各行业的企业网站！<br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#FF0000;\">带织梦最新版手机端，同一个后台，数据即时同步，简单适用！</span><br style=\"margin:0px auto;\" />原创设计、手工书写DIV+CSS，<br style=\"margin:0px auto;\" />完美兼容IE7+、Firefox、Chrome、360浏览器等；主流浏览器；<br style=\"margin:0px auto;\" />页面简洁简单，容易管理，DEDE内核都可以使用；附带测试数据！</span></h2><br /><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;font-size:14px;white-space:normal;background-color:#FFFFFF;line-height:24px;color:#465160;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;transition:all=\"\" 0.2s=\"\" linear=\"\" 0s;width:708px;\"=\"\"><span style=\"margin:0px auto;color:#333333;font-family:Arial;font-size:15px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;color:#FFFFFF;\"><strong style=\"margin:0px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板特点：</span></strong></span></span></p><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#444444;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" stheiti;line-height:24px;\"=\"\">1：产品展示公司通用模板，代码简单干净，适合seo优化。</p><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#444444;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" stheiti;line-height:24px;\"=\"\">2：首页带炫酷的幻灯片，新闻展示，产品展示，首页布局十分漂亮并首页内容自动更新。</p><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#444444;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" stheiti;line-height:24px;\"=\"\">3：各个栏目设计简单，并已经进行代码优化，只要在后台修改相应的内容就能轻松实现修改网站内容。。</p><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#444444;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" stheiti;line-height:24px;\"=\"\">4：后台直接修改联系方式、地址、版权信息，网站内容等，修改更加方便。</p><div style=\"margin:0px auto;white-space:normal;background-color:#FFFFFF;line-height:24px;padding:0px;font-family:Arial;font-size:15px;\"><strong style=\"margin:0px;color:#FFFFFF;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\"> 使用程序：</span></strong></div><div style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;line-height:24px;color:#465160;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;padding:0px;\"=\"\"><span style=\"margin:0px auto;color:#000000;font-family:Arial;\"><span style=\"margin:0px auto;font-size:15px;\">织梦DEDECMS版本都可以使用。</span></span><br style=\"margin:0px auto;\" /><strong style=\"margin:0px;color:#000000;font-family:Arial;font-size:15px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;color:#FFFFFF;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\"> </span></span><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;color:#F0FFF0;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板页面：</span></span></strong><br style=\"margin:0px auto;\" />index.htm 首页模板<br style=\"margin:0px auto;\" />head.htm<br style=\"margin:0px auto;\" />footer.htm <br style=\"margin:0px auto;\" /><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;\">article_article.htm 文章内容</p><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;\">这里不一一列出！<br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#FFFFFF;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" stheiti;background-color:#339966;\"=\"\"> 温馨提示：</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#000000;font-family:Arial;\"><span style=\"margin:0px auto;font-size:15px;\">按照正常的织梦安装步骤来安装还原就可以用了，从后台重新点击保存下系统基本参数。 系统>系统基本参数> 保存（确定）。</span></span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#FFFFFF;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" stheiti;background-color:#339966;\"=\"\"> 后期bug修正：</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#000000;font-family:Arial;\"><span style=\"margin:0px auto;font-size:15px;\">暂无</span></span></p></div>', '', 'Chinese English bilingual website of new materials for science and technology', 'Chinese English bilingual website of new materials for science and technology', 'Template name:<br />Chinese English bilingual website of science and technology new materials weaving template (with mobile terminal) + conducive to SEO optimization<br />Template introduction:<br />Zhimeng the latest kernel development template, the template belongs to new scientific and technological materials, Chinese and English bilingual enterprises use, a template with strong applicability, basically can be suitable for the enterprise website of various industries!<br />With the latest version of Zhimeng mobile terminal, the same background, real-time data synchronization, simple and applicable!<br />Original design, handwritten div + CSS,<br />Perfect compatibility with IE7 +, Firefox, chrome, 360 browser, etc;<br />The page is simple, easy to manage, Dede kernel can be used; with test data!<br />Template features:<br />1: Product display company general template, code simple and clean, suitable for SEO optimization.<br />2: Home page with cool slides, news display, product display, home page layout is very beautiful, and the home page content is automatically updated.<br />3: Each column design is simple, and has been optimized code, as long as the corresponding content in the background can be easily modified website content..<br />4: Background directly modify the contact information, address, copyright information, website content, etc., which is more convenient to modify.<br />Application procedure:<br />Both versions of dream weaving dedecms can be used.<br />Template page:<br />index.htm  Front page template<br />head.htm<br />footer.htm<br />article_ article.htm  Article content<br />I don\'t list them here!<br />reminder:<br />According to the normal Zhimeng installation steps to install and restore can be used, from the background to save the basic parameters of the system. System > system basic parameters > Save (OK).<br />Later bug correction:<br />Not yet<br />', 6, '', '', '', '新闻资讯', '红色', 'PC', 'GBK简体', '', '模板,首页,内容,后台,修改,简单,可以,使用,优化,存下', 'Template, home page, content, background, modify, simple, can, use, optimize, save', '_self', 1, '', '火火', '', '', '', '');
INSERT INTO `hh_product` VALUES (8, 3, '科技新闻资讯类网站织梦模板(带移动端)', '1', 0, 1607670459, 1607670509, '模板名称：', '<strong style=\"white-space:normal;margin:0px;padding:0px;color:#FFFFFF;line-height:24px;font-family:Arial;font-size:15px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板名称：</span></strong><br style=\"color:#465160;white-space:normal;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;line-height:26px;\"=\"\"><strong style=\"color:#465160;font-family:微软雅黑, \" microsoft=\"\" yahei\",=\"\" arial,=\"\" simsun,=\"\" \"hiragino=\"\" sans=\"\" gb\",=\"\" tahoma,=\"\" 宋体;font-size:13px;white-space:normal;\"=\"\"><span style=\"font-size:14px;\">科技新闻资讯类网站<a href=\"http://www.dede58.com/\" target=\"_blank\" style=\"color:#747D87;text-decoration-line:none;\"><u>织梦模板</u></a>(带移动端)+PC+移动端+利于SEO优化</span></strong><br style=\"color:#465160;white-space:normal;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;line-height:26px;\"=\"\"><strong style=\"white-space:normal;margin:0px;padding:0px;color:#FFFFFF;line-height:24px;font-family:Arial;font-size:15px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板介绍：</span></strong><br style=\"color:#465160;white-space:normal;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;line-height:26px;\"=\"\"><span style=\"color:#465160;white-space:normal;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;line-height:26px;\"=\"\">织梦最新内核开发的模板，该模板属于新闻资讯</span><span style=\"color:#465160;white-space:normal;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;line-height:26px;\"=\"\">类企业都可使用，<br />这款模板使用范围极广，不仅仅局限于一类型的企业，你只需要把图片和产品内容，<br />换成你的，颜色都可以修改，改完让你耳目一新的感觉！<br /><span style=\"color:#FF0000;\">自带最新的手机移动端，同一个后台，数据即时同步，简单适用！</span><br />原创设计、手工书写DIV+CSS，<br />完美兼容IE7+、Firefox、Chrome、360浏览器等；主流浏览器；<br />页面简洁简单，容易管理，DEDE内核都可以使用；附带测试数据！</span><br style=\"color:#465160;white-space:normal;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;line-height:26px;\"=\"\"><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;color:#465160;white-space:normal;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;transition:all=\"\" 0.2s=\"\" linear=\"\" 0s;width:708px;line-height:24px;\"=\"\"><span style=\"color:#333333;font-family:Arial;font-size:15px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;color:#FFFFFF;\"><strong style=\"margin:0px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板特点：</span></strong></span></span></p><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;color:#465160;white-space:normal;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;line-height:26px;\"=\"\">1.一款利于SEO的模板，手工CSS+DIV，图片ALT，H系列标签已合理运用。<br />2.同步手机站功能，手机站很强大。</p><div style=\"white-space:normal;margin:0px auto;padding:0px;line-height:24px;font-family:Arial;font-size:15px;\"><strong style=\"margin:0px;padding:0px;color:#FFFFFF;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\"> 使用程序：</span></strong></div><div style=\"color:#465160;white-space:normal;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" helvetica,=\"\" arial,=\"\" sans-serif;font-size:14px;margin:0px=\"\" auto;padding:0px;line-height:24px;\"=\"\"><span style=\"font-size:15px;\">织梦DEDECMS版本都可以使用。</span><br /><strong style=\"margin:0px;padding:0px;color:#000000;font-family:Arial;font-size:15px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;color:#FFFFFF;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\"> </span></span><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;color:#F0FFF0;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板页面：</span></span></strong><br /><span style=\"color:#465160;font-family:\'Microsoft YaHei, Tahoma, Helvetica, Arial, sans-serif\';\">index.htm 首页模板</span><br /><span style=\"color:#465160;font-family:\'Microsoft YaHei, Tahoma, Helvetica, Arial, sans-serif\';\">head.htm</span><br /><span style=\"color:#465160;font-family:\'Microsoft YaHei, Tahoma, Helvetica, Arial, sans-serif\';\">footer.htm </span><br /><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;\">article_article.htm 文章内容</p><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;\"><span style=\"color:#465160;font-family:\'Microsoft YaHei, Tahoma, Helvetica, Arial, sans-serif\';\">这里不一一列出！</span><br /><span style=\"color:#FFFFFF;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" stheiti;background-color:#339966;\"=\"\">&nbsp;温馨提示：</span><br /><span style=\"font-size:15px;\">按照正常的织梦安装步骤来安装还原就可以用了，从后台重新点击保存下系统基本参数。 系统&gt;系统基本参数&gt; 保存（确定）。</span><br /><span style=\"color:#FFFFFF;font-family:\" microsoft=\"\" yahei\",=\"\" tahoma,=\"\" stheiti;background-color:#339966;\"=\"\">&nbsp;后期bug修正：</span><br /><span style=\"color:#ff0000;font-family:Arial;\"><span style=\"font-size:15px;\">暂无</span></span></p></div>', '', 'Dream weaving template for science and technology news and information websites (with mobile terminal)', 'Dream weaving template for science and technology news and information websites (with mobile terminal)', 'Template name:<br />Dream weaving template of science and technology news information website (with mobile terminal) + PC + mobile terminal + conducive to SEO optimization<br />Template introduction:<br />This is a template developed by Zhimeng\'s latest kernel. It belongs to news and information enterprises and can be used,<br />This template is widely used. It is not limited to one type of enterprise. You only need to put pictures and product content,<br />Change to your, the color can be modified, change to let you refreshing feeling!<br />With the latest mobile phone mobile terminal, the same background, real-time data synchronization, simple and applicable!<br />Original design, handwritten div + CSS,<br />Perfect compatibility with IE7 +, Firefox, chrome, 360 browser, etc;<br />The page is simple, easy to manage, Dede kernel can be used; with test data!<br />Template features:<br />1. A template for SEO, manual CSS + div, picture alt, H series tags have been used reasonably.<br />2. Synchronous mobile station function, mobile station is very powerful.<br />Application procedure:<br />Both versions of dream weaving dedecms can be used.<br />Template page:<br />index.htm&nbsp; Front page template<br />head.htm<br />footer.htm<br />article_ article.htm&nbsp; Article content<br />I don\'t list them here!<br />reminder:<br />According to the normal Zhimeng installation steps to install and restore can be used, from the background to save the basic parameters of the system. System &gt; system basic parameters &gt; Save (OK).<br />Later bug correction:<br />Not yet<br />', 4, '', '', '', '', '', '', '', '', '模板,使用,可以,存下,移动,系统,内核,手机,后台,手工', 'Template, use, can, save, move, system, kernel, mobile phone, background, manual', '_self', 1, '', '火火', '', '', '', '');
INSERT INTO `hh_product` VALUES (9, 3, '沙盘模型展示类网站织梦模板(带手机端)', '1', 0, 1607670671, 1607670713, '模板名称：', '<strong style=\"margin:0px;white-space:normal;background-color:#FFFFFF;line-height:24px;color:#FFFFFF;font-family:Arial;font-size:15px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板名称：</span></strong><br style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;line-height:26px;\" /><span style=\"margin:0px auto;color:#333333;font-family:Tahoma, 宋体, Geneva, sans-serif;font-size:14px;white-space:normal;background-color:#FFFFFF;\"><strong style=\"margin:0px auto;\">沙盘模型展示类网站<a href=\"http://www.dede58.com/\" target=\"_blank\" style=\"margin:0px auto;color:#333333;text-decoration-line:none;cursor:pointer;\"><u style=\"margin:0px auto;\">织梦模板</u></a>(带手机端)+PC+移动端+利于SEO优化</strong></span><br style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;line-height:26px;\" /><strong style=\"margin:0px;white-space:normal;background-color:#FFFFFF;line-height:24px;color:#FFFFFF;font-family:Arial;font-size:15px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板介绍：</span></strong><br style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;line-height:26px;\" /><span style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;line-height:26px;\">织梦最新内核开发的模板，该模板属于企业通用、沙盘、模型类企业使用，</span><br style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#444444;font-family:\"Microsoft Yahei\", Tahoma, STHeiti;line-height:24px;\" /><span style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;line-height:26px;\"><span style=\"margin:0px auto;color:#FF0000;\">自带最新的手机移动端，</span><span style=\"margin:0px auto;color:#FF0000;\">同一个后台，数据即时同步，简单适用！</span><br style=\"margin:0px auto;\" />原创设计、手工书写DIV+CSS，<br style=\"margin:0px auto;\" />完美兼容IE7+、Firefox、Chrome、360浏览器等；主流浏览器；<br style=\"margin:0px auto;\" />页面简洁简单，容易管理，DEDE内核都可以使用；附带测试数据！</span><br /><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;font-size:14px;white-space:normal;background-color:#FFFFFF;line-height:24px;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;transition:all 0.2s linear 0s;width:708px;\"><span style=\"margin:0px auto;color:#333333;font-family:Arial;font-size:15px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;color:#FFFFFF;\"><strong style=\"margin:0px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板特点：</span></strong></span></span></p><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;line-height:26px;\">1.一款利于SEO的模板，手工CSS+DIV，图片ALT，H系列标签已合理运用。<br style=\"margin:0px auto;\" />2.同步手机站功能，手机站很强大。<br style=\"margin:0px auto;\" />3.广告位完美布局，网站颜色搭配清晰，利于用户体验，利于SEO排名。<br style=\"margin:0px auto;\" />4.带测试数据，带返回顶部，带同步数据手机站。</p><div style=\"margin:0px auto;white-space:normal;background-color:#FFFFFF;line-height:24px;padding:0px;font-family:Arial;font-size:15px;\"><strong style=\"margin:0px;color:#FFFFFF;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\"> 使用程序：</span></strong></div><div style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#444444;font-family:\"Microsoft Yahei\", Tahoma, STHeiti;line-height:24px;padding:0px;\"><span style=\"margin:0px auto;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;font-size:15px;\">织梦DEDECMS版本都可以使用。</span><br style=\"margin:0px auto;\" /><strong style=\"margin:0px;color:#000000;font-family:Arial;font-size:15px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;color:#FFFFFF;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\"> </span></span><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;color:#F0FFF0;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板页面：</span></span></strong><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#465160;font-family:\'Microsoft YaHei, Tahoma, Helvetica, Arial, sans-serif\';\">index.htm 首页模板</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#465160;font-family:\'Microsoft YaHei, Tahoma, Helvetica, Arial, sans-serif\';\">head.htm</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#465160;font-family:\'Microsoft YaHei, Tahoma, Helvetica, Arial, sans-serif\';\">footer.htm </span><br style=\"margin:0px auto;\" /><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;\">article_article.htm 文章内容</p><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;\"><span style=\"margin:0px auto;color:#465160;font-family:\'Microsoft YaHei, Tahoma, Helvetica, Arial, sans-serif\';\">这里不一一列出！</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#FFFFFF;background-color:#339966;\"> 温馨提示：</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;font-size:15px;\">按照正常的织梦安装步骤来安装还原就可以用了，从后台重新点击保存下系统基本参数。 系统>系统基本参数> 保存（确定）。</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#FFFFFF;background-color:#339966;\"> 后期bug修正：</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#000000;font-family:Arial;\"><span style=\"margin:0px auto;font-size:15px;\">暂无</span></span></p></div>', '', 'Sand table model demonstration website dream weaving template (with mobile terminal)', 'Sand table model demonstration website dream weaving template (with mobile terminal)', 'Template name:<br />Sand table model demonstration website dream weaving template (with mobile phone terminal) + PC + mobile terminal + conducive to SEO optimization<br />Template introduction:<br />The template is developed by Zhimeng\'s latest kernel. The template belongs to enterprise general, sand table and model enterprises,<br />With the latest mobile phone mobile terminal, the same background, real-time data synchronization, simple and applicable!<br />Original design, handwritten div + CSS,<br />Perfect compatibility with IE7 +, Firefox, chrome, 360 browser, etc;<br />The page is simple, easy to manage, Dede kernel can be used; with test data!<br /><br />Template features:<br />1. A template for SEO, manual CSS + div, picture alt, H series tags have been used reasonably.<br />2. Synchronous mobile station function, mobile station is very powerful.<br />3. Perfect layout of advertising space and clear color matching of website are conducive to user experience and SEO ranking.<br />4. Mobile phone station with test data, return to the top and synchronous data.<br />Application procedure:<br />Both versions of dream weaving dedecms can be used.<br />Template page:<br />index.htm  Front page template<br />head.htm<br />footer.htm<br />article_ article.htm  Article content<br />I don\'t list them here!<br />reminder:<br />According to the normal Zhimeng installation steps to install and restore can be used, from the background to save the basic parameters of the system. System > system basic parameters > Save (OK).<br />Later bug correction:<br />Not yet<br />', 15, '', '', '', '', '', '', '', '', '模板,手机,利于,使用,数据,同步,存下,可以,系统,内核', 'Template, mobile phone, convenience, use, data, synchronization, save, can, system, kernel', '_self', 1, '', '火火', '', '', '', '');
INSERT INTO `hh_product` VALUES (10, 3, '电缆桥架定制生产类网站织梦模板(带手机端)', '1', 0, 1607670879, 1608185230, '模板名称：', '<strong style=\"margin:0px;white-space:normal;background-color:#FFFFFF;line-height:24px;color:#FFFFFF;font-family:Arial;font-size:15px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板名称：</span></strong><br style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;line-height:26px;\" /><span style=\"margin:0px auto;color:#333333;font-family:Tahoma, 宋体, Geneva, sans-serif;font-size:14px;white-space:normal;background-color:#FFFFFF;\"><strong style=\"margin:0px auto;\">电缆桥架定制生产类网站<a href=\"http://www.dede58.com/\" target=\"_blank\" style=\"margin:0px auto;color:#333333;text-decoration-line:none;cursor:pointer;\"><u style=\"margin:0px auto;\">织梦模板</u></a>(带手机端)+PC+移动端+利于SEO优化</strong></span><br style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;line-height:26px;\" /><strong style=\"margin:0px;white-space:normal;background-color:#FFFFFF;line-height:24px;color:#FFFFFF;font-family:Arial;font-size:15px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板介绍：</span></strong><br style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;line-height:26px;\" /><span style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;line-height:26px;\">织梦最新内核开发的模板，该模板属于电缆、桥架、桥梁类企业使用，</span><br style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#444444;font-family:\"Microsoft Yahei\", Tahoma, STHeiti;line-height:24px;\" /><span style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;line-height:26px;\"><span style=\"margin:0px auto;color:#FF0000;\">自带最新的手机移动端，</span><span style=\"margin:0px auto;color:#FF0000;\">同一个后台，数据即时同步，简单适用！</span><br style=\"margin:0px auto;\" />原创设计、手工书写DIV+CSS，<br style=\"margin:0px auto;\" />完美兼容IE7+、Firefox、Chrome、360浏览器等；主流浏览器；<br style=\"margin:0px auto;\" />页面简洁简单，容易管理，DEDE内核都可以使用；附带测试数据！</span><br /><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;font-size:14px;white-space:normal;background-color:#FFFFFF;line-height:24px;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;transition:all 0.2s linear 0s;width:708px;\"><span style=\"margin:0px auto;color:#333333;font-family:Arial;font-size:15px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;color:#FFFFFF;\"><strong style=\"margin:0px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板特点：</span></strong></span></span></p><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;line-height:26px;\">1.一款利于SEO的模板，手工CSS+DIV，图片ALT，H系列标签已合理运用。<br style=\"margin:0px auto;\" />2.同步手机站功能，手机站很强大。<br style=\"margin:0px auto;\" />3.广告位完美布局，网站颜色搭配清晰，利于用户体验，利于SEO排名。<br style=\"margin:0px auto;\" />4.带测试数据，带返回顶部，带同步数据手机站。</p><div style=\"margin:0px auto;white-space:normal;background-color:#FFFFFF;line-height:24px;padding:0px;font-family:Arial;font-size:15px;\"><strong style=\"margin:0px;color:#FFFFFF;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\"> 使用程序：</span></strong></div><div style=\"margin:0px auto;font-size:14px;white-space:normal;background-color:#FFFFFF;color:#444444;font-family:\"Microsoft Yahei\", Tahoma, STHeiti;line-height:24px;padding:0px;\"><span style=\"margin:0px auto;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;font-size:15px;\">织梦DEDECMS版本都可以使用。</span><br style=\"margin:0px auto;\" /><strong style=\"margin:0px;color:#000000;font-family:Arial;font-size:15px;padding:0px;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;color:#FFFFFF;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\"> </span></span><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;color:#F0FFF0;\"><span style=\"margin:0px;padding:0px;transition:all 0.2s linear 0s;background-color:#008000;\">模板页面：</span></span></strong><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#465160;font-family:\'Microsoft YaHei, Tahoma, Helvetica, Arial, sans-serif\';\">index.htm 首页模板</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#465160;font-family:\'Microsoft YaHei, Tahoma, Helvetica, Arial, sans-serif\';\">head.htm</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#465160;font-family:\'Microsoft YaHei, Tahoma, Helvetica, Arial, sans-serif\';\">footer.htm </span><br style=\"margin:0px auto;\" /><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;\">article_article.htm 文章内容</p><p style=\"margin-top:0px;margin-bottom:0px;padding:0px;\"><span style=\"margin:0px auto;color:#465160;font-family:\'Microsoft YaHei, Tahoma, Helvetica, Arial, sans-serif\';\">这里不一一列出！</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#FFFFFF;background-color:#339966;\"> 温馨提示：</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#465160;font-family:\"Microsoft YaHei\", Tahoma, Helvetica, Arial, sans-serif;font-size:15px;\">按照正常的织梦安装步骤来安装还原就可以用了，从后台重新点击保存下系统基本参数。 系统>系统基本参数> 保存（确定）。</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#FFFFFF;background-color:#339966;\"> 后期bug修正：</span><br style=\"margin:0px auto;\" /><span style=\"margin:0px auto;color:#000000;font-family:Arial;\"><span style=\"margin:0px auto;font-size:15px;\">暂无</span></span></p></div>', '', 'Customized production website dream weaving template for cable tray (with mobile phone terminal)', 'Customized production website dream weaving template for cable tray (with mobile phone terminal)', 'Template name:<br />Cable bridge customized production website weaving template (with mobile phone end) + PC + mobile terminal + conducive to SEO optimization<br />Template introduction:<br />The template developed by Zhimeng\'s latest kernel is used by cable, bridge and bridge enterprises,<br />With the latest mobile phone mobile terminal, the same background, real-time data synchronization, simple and applicable!<br />Original design, handwritten div + CSS,<br />Perfect compatibility with IE7 +, Firefox, chrome, 360 browser, etc;<br />The page is simple, easy to manage, Dede kernel can be used; with test data!<br /><br />Template features:<br />1. A template for SEO, manual CSS + div, picture alt, H series tags have been used reasonably.<br />2. Synchronous mobile station function, mobile station is very powerful.<br />3. Perfect layout of advertising space and clear color matching of website are conducive to user experience and SEO ranking.<br />4. Mobile phone station with test data, return to the top and synchronous data.<br />Application procedure:<br />Both versions of dream weaving dedecms can be used.<br />Template page:<br />index.htm  Front page template<br />head.htm<br />footer.htm<br />article_ article.htm  Article content<br />I don\'t list them here!<br />reminder:<br />According to the normal Zhimeng installation steps to install and restore can be used, from the background to save the basic parameters of the system. System > system basic parameters > Save (OK).<br />Later bug correction:<br />Not yet<br />', 19, '', '', 'https://www.lutongzx.com', '', '', '', '', '', '模板,手机,利于,使用,数据,同步,存下,可以,电缆桥架,桥架', 'Template, mobile phone, convenience, use, data, synchronization, storage, can, cable tray, bridge', '_self', 1, '', '火火', '', '', '', '');

-- ----------------------------
-- Table structure for hh_region
-- ----------------------------
DROP TABLE IF EXISTS `hh_region`;
CREATE TABLE `hh_region`  (
  `id` int(7) UNSIGNED NOT NULL COMMENT 'ID(编码)',
  `name` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '省市区名称',
  `pid` int(7) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级ID(编码)',
  `shortname` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '简称',
  `leveltype` tinyint(1) UNSIGNED NOT NULL DEFAULT 3 COMMENT '级别(0:中国,1:省份,2:市,3:区、县)',
  `citycode` varchar(7) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '城市代码',
  `zipcode` varchar(7) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '邮编',
  `lng` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '经度',
  `lat` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '纬度',
  `pinyin` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '拼音',
  `status` enum('0','1') CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '状态',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  UNIQUE INDEX `id`(`id`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '国/省/市/区、县表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_region
-- ----------------------------
INSERT INTO `hh_region` VALUES (100000, '中国', 0, '中国', 0, '', '', '116.3683244', '39.915085', 'China', '0', 0);
INSERT INTO `hh_region` VALUES (110000, '北京', 100000, '北京', 1, '', '', '116.405285', '39.904989', 'Beijing', '1', 0);
INSERT INTO `hh_region` VALUES (110100, '北京市', 110000, '北京', 2, '010', '100000', '116.405285', '39.904989', 'Beijing', '1', 0);
INSERT INTO `hh_region` VALUES (110101, '东城区', 110100, '东城', 3, '010', '100010', '116.41005', '39.93157', 'Dongcheng', '1', 0);
INSERT INTO `hh_region` VALUES (110102, '西城区', 110100, '西城', 3, '010', '100032', '116.36003', '39.9305', 'Xicheng', '1', 0);
INSERT INTO `hh_region` VALUES (110105, '朝阳区', 110100, '朝阳', 3, '010', '100020', '116.48548', '39.9484', 'Chaoyang', '1', 0);
INSERT INTO `hh_region` VALUES (110106, '丰台区', 110100, '丰台', 3, '010', '100071', '116.28625', '39.8585', 'Fengtai', '1', 0);
INSERT INTO `hh_region` VALUES (110107, '石景山区', 110100, '石景山', 3, '010', '100043', '116.2229', '39.90564', 'Shijingshan', '1', 0);
INSERT INTO `hh_region` VALUES (110108, '海淀区', 110100, '海淀', 3, '010', '100089', '116.29812', '39.95931', 'Haidian', '1', 0);
INSERT INTO `hh_region` VALUES (110109, '门头沟区', 110100, '门头沟', 3, '010', '102300', '116.10137', '39.94043', 'Mentougou', '1', 0);
INSERT INTO `hh_region` VALUES (110111, '房山区', 110100, '房山', 3, '010', '102488', '116.14257', '39.74786', 'Fangshan', '1', 0);
INSERT INTO `hh_region` VALUES (110112, '通州区', 110100, '通州', 3, '010', '101149', '116.65716', '39.90966', 'Tongzhou', '1', 0);
INSERT INTO `hh_region` VALUES (110113, '顺义区', 110100, '顺义', 3, '010', '101300', '116.65417', '40.1302', 'Shunyi', '1', 0);
INSERT INTO `hh_region` VALUES (110114, '昌平区', 110100, '昌平', 3, '010', '102200', '116.2312', '40.22072', 'Changping', '1', 0);
INSERT INTO `hh_region` VALUES (110115, '大兴区', 110100, '大兴', 3, '010', '102600', '116.34149', '39.72668', 'Daxing', '1', 0);
INSERT INTO `hh_region` VALUES (110116, '怀柔区', 110100, '怀柔', 3, '010', '101400', '116.63168', '40.31602', 'Huairou', '1', 0);
INSERT INTO `hh_region` VALUES (110117, '平谷区', 110100, '平谷', 3, '010', '101200', '117.12133', '40.14056', 'Pinggu', '1', 0);
INSERT INTO `hh_region` VALUES (110228, '密云县', 110100, '密云', 3, '010', '101500', '116.84295', '40.37618', 'Miyun', '1', 0);
INSERT INTO `hh_region` VALUES (110229, '延庆县', 110100, '延庆', 3, '010', '102100', '115.97494', '40.45672', 'Yanqing', '1', 0);
INSERT INTO `hh_region` VALUES (120000, '天津', 100000, '天津', 1, '', '', '117.190182', '39.125596', 'Tianjin', '1', 0);
INSERT INTO `hh_region` VALUES (120100, '天津市', 120000, '天津', 2, '022', '300000', '117.190182', '39.125596', 'Tianjin', '1', 0);
INSERT INTO `hh_region` VALUES (120101, '和平区', 120100, '和平', 3, '022', '300041', '117.21456', '39.11718', 'Heping', '1', 0);
INSERT INTO `hh_region` VALUES (120102, '河东区', 120100, '河东', 3, '022', '300171', '117.22562', '39.12318', 'Hedong', '1', 0);
INSERT INTO `hh_region` VALUES (120103, '河西区', 120100, '河西', 3, '022', '300202', '117.22327', '39.10959', 'Hexi', '1', 0);
INSERT INTO `hh_region` VALUES (120104, '南开区', 120100, '南开', 3, '022', '300110', '117.15074', '39.13821', 'Nankai', '1', 0);
INSERT INTO `hh_region` VALUES (120105, '河北区', 120100, '河北', 3, '022', '300143', '117.19697', '39.14816', 'Hebei', '1', 0);
INSERT INTO `hh_region` VALUES (120106, '红桥区', 120100, '红桥', 3, '022', '300131', '117.15145', '39.16715', 'Hongqiao', '1', 0);
INSERT INTO `hh_region` VALUES (120110, '东丽区', 120100, '东丽', 3, '022', '300300', '117.31436', '39.0863', 'Dongli', '1', 0);
INSERT INTO `hh_region` VALUES (120111, '西青区', 120100, '西青', 3, '022', '300380', '117.00927', '39.14123', 'Xiqing', '1', 0);
INSERT INTO `hh_region` VALUES (120112, '津南区', 120100, '津南', 3, '022', '300350', '117.38537', '38.99139', 'Jinnan', '1', 0);
INSERT INTO `hh_region` VALUES (120113, '北辰区', 120100, '北辰', 3, '022', '300400', '117.13217', '39.22131', 'Beichen', '1', 0);
INSERT INTO `hh_region` VALUES (120114, '武清区', 120100, '武清', 3, '022', '301700', '117.04443', '39.38415', 'Wuqing', '1', 0);
INSERT INTO `hh_region` VALUES (120115, '宝坻区', 120100, '宝坻', 3, '022', '301800', '117.3103', '39.71761', 'Baodi', '1', 0);
INSERT INTO `hh_region` VALUES (120116, '滨海新区', 120100, '滨海新区', 3, '022', '300451', '117.70162', '39.02668', 'Binhaixinqu', '1', 0);
INSERT INTO `hh_region` VALUES (120221, '宁河县', 120100, '宁河', 3, '022', '301500', '117.8255', '39.33048', 'Ninghe', '1', 0);
INSERT INTO `hh_region` VALUES (120223, '静海县', 120100, '静海', 3, '022', '301600', '116.97436', '38.94582', 'Jinghai', '1', 0);
INSERT INTO `hh_region` VALUES (120225, '蓟县', 120100, '蓟县', 3, '022', '301900', '117.40799', '40.04567', 'Jixian', '1', 0);
INSERT INTO `hh_region` VALUES (130000, '河北省', 100000, '河北', 1, '', '', '114.502461', '38.045474', 'Hebei', '1', 0);
INSERT INTO `hh_region` VALUES (130100, '石家庄市', 130000, '石家庄', 2, '0311', '050011', '114.502461', '38.045474', 'Shijiazhuang', '1', 0);
INSERT INTO `hh_region` VALUES (130102, '长安区', 130100, '长安', 3, '0311', '050011', '114.53906', '38.03665', 'Chang\'an', '1', 0);
INSERT INTO `hh_region` VALUES (130104, '桥西区', 130100, '桥西', 3, '0311', '050091', '114.46977', '38.03221', 'Qiaoxi', '1', 0);
INSERT INTO `hh_region` VALUES (130105, '新华区', 130100, '新华', 3, '0311', '050051', '114.46326', '38.05088', 'Xinhua', '1', 0);
INSERT INTO `hh_region` VALUES (130107, '井陉矿区', 130100, '井陉矿区', 3, '0311', '050100', '114.06518', '38.06705', 'Jingxingkuangqu', '1', 0);
INSERT INTO `hh_region` VALUES (130108, '裕华区', 130100, '裕华', 3, '0311', '050031', '114.53115', '38.00604', 'Yuhua', '1', 0);
INSERT INTO `hh_region` VALUES (130109, '藁城区', 130100, '藁城', 3, '0311', '052160', '114.84671', '38.02162', 'Gaocheng', '1', 0);
INSERT INTO `hh_region` VALUES (130110, '鹿泉区', 130100, '鹿泉', 3, '0311', '050200', '114.31347', '38.08782', 'Luquan', '1', 0);
INSERT INTO `hh_region` VALUES (130111, '栾城区', 130100, '栾城', 3, '0311', '051430', '114.64834', '37.90022', 'Luancheng', '1', 0);
INSERT INTO `hh_region` VALUES (130121, '井陉县', 130100, '井陉', 3, '0311', '050300', '114.14257', '38.03688', 'Jingxing', '1', 0);
INSERT INTO `hh_region` VALUES (130123, '正定县', 130100, '正定', 3, '0311', '050800', '114.57296', '38.14445', 'Zhengding', '1', 0);
INSERT INTO `hh_region` VALUES (130125, '行唐县', 130100, '行唐', 3, '0311', '050600', '114.55316', '38.43654', 'Xingtang', '1', 0);
INSERT INTO `hh_region` VALUES (130126, '灵寿县', 130100, '灵寿', 3, '0311', '050500', '114.38259', '38.30845', 'Lingshou', '1', 0);
INSERT INTO `hh_region` VALUES (130127, '高邑县', 130100, '高邑', 3, '0311', '051330', '114.61142', '37.61556', 'Gaoyi', '1', 0);
INSERT INTO `hh_region` VALUES (130128, '深泽县', 130100, '深泽', 3, '0311', '052560', '115.20358', '38.18353', 'Shenze', '1', 0);
INSERT INTO `hh_region` VALUES (130129, '赞皇县', 130100, '赞皇', 3, '0311', '051230', '114.38775', '37.66135', 'Zanhuang', '1', 0);
INSERT INTO `hh_region` VALUES (130130, '无极县', 130100, '无极', 3, '0311', '052460', '114.97509', '38.17653', 'Wuji', '1', 0);
INSERT INTO `hh_region` VALUES (130131, '平山县', 130100, '平山', 3, '0311', '050400', '114.186', '38.25994', 'Pingshan', '1', 0);
INSERT INTO `hh_region` VALUES (130132, '元氏县', 130100, '元氏', 3, '0311', '051130', '114.52539', '37.76668', 'Yuanshi', '1', 0);
INSERT INTO `hh_region` VALUES (130133, '赵县', 130100, '赵县', 3, '0311', '051530', '114.77612', '37.75628', 'Zhaoxian', '1', 0);
INSERT INTO `hh_region` VALUES (130181, '辛集市', 130100, '辛集', 3, '0311', '052360', '115.20626', '37.94079', 'Xinji', '1', 0);
INSERT INTO `hh_region` VALUES (130183, '晋州市', 130100, '晋州', 3, '0311', '052260', '115.04348', '38.03135', 'Jinzhou', '1', 0);
INSERT INTO `hh_region` VALUES (130184, '新乐市', 130100, '新乐', 3, '0311', '050700', '114.68985', '38.34417', 'Xinle', '1', 0);
INSERT INTO `hh_region` VALUES (130200, '唐山市', 130000, '唐山', 2, '0315', '063000', '118.175393', '39.635113', 'Tangshan', '1', 0);
INSERT INTO `hh_region` VALUES (130202, '路南区', 130200, '路南', 3, '0315', '063000', '118.15431', '39.62505', 'Lunan', '1', 0);
INSERT INTO `hh_region` VALUES (130203, '路北区', 130200, '路北', 3, '0315', '063000', '118.20079', '39.62436', 'Lubei', '1', 0);
INSERT INTO `hh_region` VALUES (130204, '古冶区', 130200, '古冶', 3, '0315', '063100', '118.45803', '39.71993', 'Guye', '1', 0);
INSERT INTO `hh_region` VALUES (130205, '开平区', 130200, '开平', 3, '0315', '063021', '118.26171', '39.67128', 'Kaiping', '1', 0);
INSERT INTO `hh_region` VALUES (130207, '丰南区', 130200, '丰南', 3, '0315', '063300', '118.11282', '39.56483', 'Fengnan', '1', 0);
INSERT INTO `hh_region` VALUES (130208, '丰润区', 130200, '丰润', 3, '0315', '064000', '118.12976', '39.8244', 'Fengrun', '1', 0);
INSERT INTO `hh_region` VALUES (130209, '曹妃甸区', 130200, '曹妃甸', 3, '0315', '063200', '118.460379', '39.273070', 'Caofeidian', '1', 0);
INSERT INTO `hh_region` VALUES (130223, '滦县', 130200, '滦县', 3, '0315', '063700', '118.70346', '39.74056', 'Luanxian', '1', 0);
INSERT INTO `hh_region` VALUES (130224, '滦南县', 130200, '滦南', 3, '0315', '063500', '118.6741', '39.5039', 'Luannan', '1', 0);
INSERT INTO `hh_region` VALUES (130225, '乐亭县', 130200, '乐亭', 3, '0315', '063600', '118.9125', '39.42561', 'Laoting', '1', 0);
INSERT INTO `hh_region` VALUES (130227, '迁西县', 130200, '迁西', 3, '0315', '064300', '118.31616', '40.14587', 'Qianxi', '1', 0);
INSERT INTO `hh_region` VALUES (130229, '玉田县', 130200, '玉田', 3, '0315', '064100', '117.7388', '39.90049', 'Yutian', '1', 0);
INSERT INTO `hh_region` VALUES (130281, '遵化市', 130200, '遵化', 3, '0315', '064200', '117.96444', '40.18741', 'Zunhua', '1', 0);
INSERT INTO `hh_region` VALUES (130283, '迁安市', 130200, '迁安', 3, '0315', '064400', '118.70068', '39.99833', 'Qian\'an', '1', 0);
INSERT INTO `hh_region` VALUES (130300, '秦皇岛市', 130000, '秦皇岛', 2, '0335', '066000', '119.586579', '39.942531', 'Qinhuangdao', '1', 0);
INSERT INTO `hh_region` VALUES (130302, '海港区', 130300, '海港', 3, '0335', '066000', '119.61046', '39.9345', 'Haigang', '1', 0);
INSERT INTO `hh_region` VALUES (130303, '山海关区', 130300, '山海关', 3, '0335', '066200', '119.77563', '39.97869', 'Shanhaiguan', '1', 0);
INSERT INTO `hh_region` VALUES (130304, '北戴河区', 130300, '北戴河', 3, '0335', '066100', '119.48388', '39.83408', 'Beidaihe', '1', 0);
INSERT INTO `hh_region` VALUES (130321, '青龙满族自治县', 130300, '青龙', 3, '0335', '066500', '118.95242', '40.40743', 'Qinglong', '1', 0);
INSERT INTO `hh_region` VALUES (130322, '昌黎县', 130300, '昌黎', 3, '0335', '066600', '119.16595', '39.70884', 'Changli', '1', 0);
INSERT INTO `hh_region` VALUES (130323, '抚宁县', 130300, '抚宁', 3, '0335', '066300', '119.24487', '39.87538', 'Funing', '1', 0);
INSERT INTO `hh_region` VALUES (130324, '卢龙县', 130300, '卢龙', 3, '0335', '066400', '118.89288', '39.89176', 'Lulong', '1', 0);
INSERT INTO `hh_region` VALUES (130400, '邯郸市', 130000, '邯郸', 2, '0310', '056002', '114.490686', '36.612273', 'Handan', '1', 0);
INSERT INTO `hh_region` VALUES (130402, '邯山区', 130400, '邯山', 3, '0310', '056001', '114.48375', '36.60006', 'Hanshan', '1', 0);
INSERT INTO `hh_region` VALUES (130403, '丛台区', 130400, '丛台', 3, '0310', '056002', '114.49343', '36.61847', 'Congtai', '1', 0);
INSERT INTO `hh_region` VALUES (130404, '复兴区', 130400, '复兴', 3, '0310', '056003', '114.45928', '36.61134', 'Fuxing', '1', 0);
INSERT INTO `hh_region` VALUES (130406, '峰峰矿区', 130400, '峰峰矿区', 3, '0310', '056200', '114.21148', '36.41937', 'Fengfengkuangqu', '1', 0);
INSERT INTO `hh_region` VALUES (130421, '邯郸县', 130400, '邯郸', 3, '0310', '056101', '114.53103', '36.59385', 'Handan', '1', 0);
INSERT INTO `hh_region` VALUES (130423, '临漳县', 130400, '临漳', 3, '0310', '056600', '114.6195', '36.33461', 'Linzhang', '1', 0);
INSERT INTO `hh_region` VALUES (130424, '成安县', 130400, '成安', 3, '0310', '056700', '114.66995', '36.44411', 'Cheng\'an', '1', 0);
INSERT INTO `hh_region` VALUES (130425, '大名县', 130400, '大名', 3, '0310', '056900', '115.15362', '36.27994', 'Daming', '1', 0);
INSERT INTO `hh_region` VALUES (130426, '涉县', 130400, '涉县', 3, '0310', '056400', '113.69183', '36.58072', 'Shexian', '1', 0);
INSERT INTO `hh_region` VALUES (130427, '磁县', 130400, '磁县', 3, '0310', '056500', '114.37387', '36.37392', 'Cixian', '1', 0);
INSERT INTO `hh_region` VALUES (130428, '肥乡县', 130400, '肥乡', 3, '0310', '057550', '114.79998', '36.54807', 'Feixiang', '1', 0);
INSERT INTO `hh_region` VALUES (130429, '永年县', 130400, '永年', 3, '0310', '057150', '114.48925', '36.78356', 'Yongnian', '1', 0);
INSERT INTO `hh_region` VALUES (130430, '邱县', 130400, '邱县', 3, '0310', '057450', '115.17407', '36.82082', 'Qiuxian', '1', 0);
INSERT INTO `hh_region` VALUES (130431, '鸡泽县', 130400, '鸡泽', 3, '0310', '057350', '114.8742', '36.92374', 'Jize', '1', 0);
INSERT INTO `hh_region` VALUES (130432, '广平县', 130400, '广平', 3, '0310', '057650', '114.94653', '36.48046', 'Guangping', '1', 0);
INSERT INTO `hh_region` VALUES (130433, '馆陶县', 130400, '馆陶', 3, '0310', '057750', '115.29913', '36.53719', 'Guantao', '1', 0);
INSERT INTO `hh_region` VALUES (130434, '魏县', 130400, '魏县', 3, '0310', '056800', '114.93518', '36.36171', 'Weixian', '1', 0);
INSERT INTO `hh_region` VALUES (130435, '曲周县', 130400, '曲周', 3, '0310', '057250', '114.95196', '36.77671', 'Quzhou', '1', 0);
INSERT INTO `hh_region` VALUES (130481, '武安市', 130400, '武安', 3, '0310', '056300', '114.20153', '36.69281', 'Wu\'an', '1', 0);
INSERT INTO `hh_region` VALUES (130500, '邢台市', 130000, '邢台', 2, '0319', '054001', '114.508851', '37.0682', 'Xingtai', '1', 0);
INSERT INTO `hh_region` VALUES (130502, '桥东区', 130500, '桥东', 3, '0319', '054001', '114.50725', '37.06801', 'Qiaodong', '1', 0);
INSERT INTO `hh_region` VALUES (130503, '桥西区', 130500, '桥西', 3, '0319', '054000', '114.46803', '37.05984', 'Qiaoxi', '1', 0);
INSERT INTO `hh_region` VALUES (130521, '邢台县', 130500, '邢台', 3, '0319', '054001', '114.56575', '37.0456', 'Xingtai', '1', 0);
INSERT INTO `hh_region` VALUES (130522, '临城县', 130500, '临城', 3, '0319', '054300', '114.50387', '37.43977', 'Lincheng', '1', 0);
INSERT INTO `hh_region` VALUES (130523, '内丘县', 130500, '内丘', 3, '0319', '054200', '114.51212', '37.28671', 'Neiqiu', '1', 0);
INSERT INTO `hh_region` VALUES (130524, '柏乡县', 130500, '柏乡', 3, '0319', '055450', '114.69332', '37.48242', 'Baixiang', '1', 0);
INSERT INTO `hh_region` VALUES (130525, '隆尧县', 130500, '隆尧', 3, '0319', '055350', '114.77615', '37.35351', 'Longyao', '1', 0);
INSERT INTO `hh_region` VALUES (130526, '任县', 130500, '任县', 3, '0319', '055150', '114.6842', '37.12575', 'Renxian', '1', 0);
INSERT INTO `hh_region` VALUES (130527, '南和县', 130500, '南和', 3, '0319', '054400', '114.68371', '37.00488', 'Nanhe', '1', 0);
INSERT INTO `hh_region` VALUES (130528, '宁晋县', 130500, '宁晋', 3, '0319', '055550', '114.92117', '37.61696', 'Ningjin', '1', 0);
INSERT INTO `hh_region` VALUES (130529, '巨鹿县', 130500, '巨鹿', 3, '0319', '055250', '115.03524', '37.21801', 'Julu', '1', 0);
INSERT INTO `hh_region` VALUES (130530, '新河县', 130500, '新河', 3, '0319', '055650', '115.24987', '37.52718', 'Xinhe', '1', 0);
INSERT INTO `hh_region` VALUES (130531, '广宗县', 130500, '广宗', 3, '0319', '054600', '115.14254', '37.0746', 'Guangzong', '1', 0);
INSERT INTO `hh_region` VALUES (130532, '平乡县', 130500, '平乡', 3, '0319', '054500', '115.03002', '37.06317', 'Pingxiang', '1', 0);
INSERT INTO `hh_region` VALUES (130533, '威县', 130500, '威县', 3, '0319', '054700', '115.2637', '36.9768', 'Weixian', '1', 0);
INSERT INTO `hh_region` VALUES (130534, '清河县', 130500, '清河', 3, '0319', '054800', '115.66479', '37.07122', 'Qinghe', '1', 0);
INSERT INTO `hh_region` VALUES (130535, '临西县', 130500, '临西', 3, '0319', '054900', '115.50097', '36.87078', 'Linxi', '1', 0);
INSERT INTO `hh_region` VALUES (130581, '南宫市', 130500, '南宫', 3, '0319', '055750', '115.39068', '37.35799', 'Nangong', '1', 0);
INSERT INTO `hh_region` VALUES (130582, '沙河市', 130500, '沙河', 3, '0319', '054100', '114.4981', '36.8577', 'Shahe', '1', 0);
INSERT INTO `hh_region` VALUES (130600, '保定市', 130000, '保定', 2, '0312', '071052', '115.482331', '38.867657', 'Baoding', '1', 0);
INSERT INTO `hh_region` VALUES (130602, '新市区', 130600, '新市', 3, '0312', '071051', '115.4587', '38.87751', 'Xinshi', '1', 0);
INSERT INTO `hh_region` VALUES (130603, '北市区', 130600, '北市', 3, '0312', '071000', '115.49715', '38.88322', 'Beishi', '1', 0);
INSERT INTO `hh_region` VALUES (130604, '南市区', 130600, '南市', 3, '0312', '071001', '115.52859', '38.85455', 'Nanshi', '1', 0);
INSERT INTO `hh_region` VALUES (130621, '满城县', 130600, '满城', 3, '0312', '072150', '115.32296', '38.94972', 'Mancheng', '1', 0);
INSERT INTO `hh_region` VALUES (130622, '清苑县', 130600, '清苑', 3, '0312', '071100', '115.49267', '38.76709', 'Qingyuan', '1', 0);
INSERT INTO `hh_region` VALUES (130623, '涞水县', 130600, '涞水', 3, '0312', '074100', '115.71517', '39.39404', 'Laishui', '1', 0);
INSERT INTO `hh_region` VALUES (130624, '阜平县', 130600, '阜平', 3, '0312', '073200', '114.19683', '38.84763', 'Fuping', '1', 0);
INSERT INTO `hh_region` VALUES (130625, '徐水县', 130600, '徐水', 3, '0312', '072550', '115.65829', '39.02099', 'Xushui', '1', 0);
INSERT INTO `hh_region` VALUES (130626, '定兴县', 130600, '定兴', 3, '0312', '072650', '115.80786', '39.26312', 'Dingxing', '1', 0);
INSERT INTO `hh_region` VALUES (130627, '唐县', 130600, '唐县', 3, '0312', '072350', '114.98516', '38.74513', 'Tangxian', '1', 0);
INSERT INTO `hh_region` VALUES (130628, '高阳县', 130600, '高阳', 3, '0312', '071500', '115.7788', '38.70003', 'Gaoyang', '1', 0);
INSERT INTO `hh_region` VALUES (130629, '容城县', 130600, '容城', 3, '0312', '071700', '115.87158', '39.0535', 'Rongcheng', '1', 0);
INSERT INTO `hh_region` VALUES (130630, '涞源县', 130600, '涞源', 3, '0312', '074300', '114.69128', '39.35388', 'Laiyuan', '1', 0);
INSERT INTO `hh_region` VALUES (130631, '望都县', 130600, '望都', 3, '0312', '072450', '115.1567', '38.70996', 'Wangdu', '1', 0);
INSERT INTO `hh_region` VALUES (130632, '安新县', 130600, '安新', 3, '0312', '071600', '115.93557', '38.93532', 'Anxin', '1', 0);
INSERT INTO `hh_region` VALUES (130633, '易县', 130600, '易县', 3, '0312', '074200', '115.4981', '39.34885', 'Yixian', '1', 0);
INSERT INTO `hh_region` VALUES (130634, '曲阳县', 130600, '曲阳', 3, '0312', '073100', '114.70123', '38.62154', 'Quyang', '1', 0);
INSERT INTO `hh_region` VALUES (130635, '蠡县', 130600, '蠡县', 3, '0312', '071400', '115.57717', '38.48974', 'Lixian', '1', 0);
INSERT INTO `hh_region` VALUES (130636, '顺平县', 130600, '顺平', 3, '0312', '072250', '115.1347', '38.83854', 'Shunping', '1', 0);
INSERT INTO `hh_region` VALUES (130637, '博野县', 130600, '博野', 3, '0312', '071300', '115.47033', '38.4564', 'Boye', '1', 0);
INSERT INTO `hh_region` VALUES (130638, '雄县', 130600, '雄县', 3, '0312', '071800', '116.10873', '38.99442', 'Xiongxian', '1', 0);
INSERT INTO `hh_region` VALUES (130681, '涿州市', 130600, '涿州', 3, '0312', '072750', '115.98062', '39.48622', 'Zhuozhou', '1', 0);
INSERT INTO `hh_region` VALUES (130682, '定州市', 130600, '定州', 3, '0312', '073000', '114.9902', '38.51623', 'Dingzhou', '1', 0);
INSERT INTO `hh_region` VALUES (130683, '安国市', 130600, '安国', 3, '0312', '071200', '115.32321', '38.41391', 'Anguo', '1', 0);
INSERT INTO `hh_region` VALUES (130684, '高碑店市', 130600, '高碑店', 3, '0312', '074000', '115.87368', '39.32655', 'Gaobeidian', '1', 0);
INSERT INTO `hh_region` VALUES (130700, '张家口市', 130000, '张家口', 2, '0313', '075000', '114.884091', '40.811901', 'Zhangjiakou', '1', 0);
INSERT INTO `hh_region` VALUES (130702, '桥东区', 130700, '桥东', 3, '0313', '075000', '114.8943', '40.78844', 'Qiaodong', '1', 0);
INSERT INTO `hh_region` VALUES (130703, '桥西区', 130700, '桥西', 3, '0313', '075061', '114.86962', '40.81945', 'Qiaoxi', '1', 0);
INSERT INTO `hh_region` VALUES (130705, '宣化区', 130700, '宣化', 3, '0313', '075100', '115.06543', '40.60957', 'Xuanhua', '1', 0);
INSERT INTO `hh_region` VALUES (130706, '下花园区', 130700, '下花园', 3, '0313', '075300', '115.28744', '40.50236', 'Xiahuayuan', '1', 0);
INSERT INTO `hh_region` VALUES (130721, '宣化县', 130700, '宣化', 3, '0313', '075100', '115.15497', '40.56618', 'Xuanhua', '1', 0);
INSERT INTO `hh_region` VALUES (130722, '张北县', 130700, '张北', 3, '0313', '076450', '114.71432', '41.15977', 'Zhangbei', '1', 0);
INSERT INTO `hh_region` VALUES (130723, '康保县', 130700, '康保', 3, '0313', '076650', '114.60031', '41.85225', 'Kangbao', '1', 0);
INSERT INTO `hh_region` VALUES (130724, '沽源县', 130700, '沽源', 3, '0313', '076550', '115.68859', '41.66959', 'Guyuan', '1', 0);
INSERT INTO `hh_region` VALUES (130725, '尚义县', 130700, '尚义', 3, '0313', '076750', '113.97134', '41.07782', 'Shangyi', '1', 0);
INSERT INTO `hh_region` VALUES (130726, '蔚县', 130700, '蔚县', 3, '0313', '075700', '114.58892', '39.84067', 'Yuxian', '1', 0);
INSERT INTO `hh_region` VALUES (130727, '阳原县', 130700, '阳原', 3, '0313', '075800', '114.15051', '40.10361', 'Yangyuan', '1', 0);
INSERT INTO `hh_region` VALUES (130728, '怀安县', 130700, '怀安', 3, '0313', '076150', '114.38559', '40.67425', 'Huai\'an', '1', 0);
INSERT INTO `hh_region` VALUES (130729, '万全县', 130700, '万全', 3, '0313', '076250', '114.7405', '40.76694', 'Wanquan', '1', 0);
INSERT INTO `hh_region` VALUES (130730, '怀来县', 130700, '怀来', 3, '0313', '075400', '115.51773', '40.41536', 'Huailai', '1', 0);
INSERT INTO `hh_region` VALUES (130731, '涿鹿县', 130700, '涿鹿', 3, '0313', '075600', '115.22403', '40.37636', 'Zhuolu', '1', 0);
INSERT INTO `hh_region` VALUES (130732, '赤城县', 130700, '赤城', 3, '0313', '075500', '115.83187', '40.91438', 'Chicheng', '1', 0);
INSERT INTO `hh_region` VALUES (130733, '崇礼县', 130700, '崇礼', 3, '0313', '076350', '115.27993', '40.97519', 'Chongli', '1', 0);
INSERT INTO `hh_region` VALUES (130800, '承德市', 130000, '承德', 2, '0314', '067000', '117.939152', '40.976204', 'Chengde', '1', 0);
INSERT INTO `hh_region` VALUES (130802, '双桥区', 130800, '双桥', 3, '0314', '067000', '117.9432', '40.97466', 'Shuangqiao', '1', 0);
INSERT INTO `hh_region` VALUES (130803, '双滦区', 130800, '双滦', 3, '0314', '067001', '117.74487', '40.95375', 'Shuangluan', '1', 0);
INSERT INTO `hh_region` VALUES (130804, '鹰手营子矿区', 130800, '鹰手营子矿区', 3, '0314', '067200', '117.65985', '40.54744', 'Yingshouyingzikuangqu', '1', 0);
INSERT INTO `hh_region` VALUES (130821, '承德县', 130800, '承德', 3, '0314', '067400', '118.17639', '40.76985', 'Chengde', '1', 0);
INSERT INTO `hh_region` VALUES (130822, '兴隆县', 130800, '兴隆', 3, '0314', '067300', '117.50073', '40.41709', 'Xinglong', '1', 0);
INSERT INTO `hh_region` VALUES (130823, '平泉县', 130800, '平泉', 3, '0314', '067500', '118.70196', '41.01839', 'Pingquan', '1', 0);
INSERT INTO `hh_region` VALUES (130824, '滦平县', 130800, '滦平', 3, '0314', '068250', '117.33276', '40.94148', 'Luanping', '1', 0);
INSERT INTO `hh_region` VALUES (130825, '隆化县', 130800, '隆化', 3, '0314', '068150', '117.7297', '41.31412', 'Longhua', '1', 0);
INSERT INTO `hh_region` VALUES (130826, '丰宁满族自治县', 130800, '丰宁', 3, '0314', '068350', '116.6492', '41.20481', 'Fengning', '1', 0);
INSERT INTO `hh_region` VALUES (130827, '宽城满族自治县', 130800, '宽城', 3, '0314', '067600', '118.49176', '40.60829', 'Kuancheng', '1', 0);
INSERT INTO `hh_region` VALUES (130828, '围场满族蒙古族自治县', 130800, '围场', 3, '0314', '068450', '117.7601', '41.94368', 'Weichang', '1', 0);
INSERT INTO `hh_region` VALUES (130900, '沧州市', 130000, '沧州', 2, '0317', '061001', '116.857461', '38.310582', 'Cangzhou', '1', 0);
INSERT INTO `hh_region` VALUES (130902, '新华区', 130900, '新华', 3, '0317', '061000', '116.86643', '38.31438', 'Xinhua', '1', 0);
INSERT INTO `hh_region` VALUES (130903, '运河区', 130900, '运河', 3, '0317', '061001', '116.85706', '38.31352', 'Yunhe', '1', 0);
INSERT INTO `hh_region` VALUES (130921, '沧县', 130900, '沧县', 3, '0317', '061000', '116.87817', '38.29361', 'Cangxian', '1', 0);
INSERT INTO `hh_region` VALUES (130922, '青县', 130900, '青县', 3, '0317', '062650', '116.80316', '38.58345', 'Qingxian', '1', 0);
INSERT INTO `hh_region` VALUES (130923, '东光县', 130900, '东光', 3, '0317', '061600', '116.53668', '37.8857', 'Dongguang', '1', 0);
INSERT INTO `hh_region` VALUES (130924, '海兴县', 130900, '海兴', 3, '0317', '061200', '117.49758', '38.13958', 'Haixing', '1', 0);
INSERT INTO `hh_region` VALUES (130925, '盐山县', 130900, '盐山', 3, '0317', '061300', '117.23092', '38.05647', 'Yanshan', '1', 0);
INSERT INTO `hh_region` VALUES (130926, '肃宁县', 130900, '肃宁', 3, '0317', '062350', '115.82971', '38.42272', 'Suning', '1', 0);
INSERT INTO `hh_region` VALUES (130927, '南皮县', 130900, '南皮', 3, '0317', '061500', '116.70224', '38.04109', 'Nanpi', '1', 0);
INSERT INTO `hh_region` VALUES (130928, '吴桥县', 130900, '吴桥', 3, '0317', '061800', '116.3847', '37.62546', 'Wuqiao', '1', 0);
INSERT INTO `hh_region` VALUES (130929, '献县', 130900, '献县', 3, '0317', '062250', '116.12695', '38.19228', 'Xianxian', '1', 0);
INSERT INTO `hh_region` VALUES (130930, '孟村回族自治县', 130900, '孟村', 3, '0317', '061400', '117.10412', '38.05338', 'Mengcun', '1', 0);
INSERT INTO `hh_region` VALUES (130981, '泊头市', 130900, '泊头', 3, '0317', '062150', '116.57824', '38.08359', 'Botou', '1', 0);
INSERT INTO `hh_region` VALUES (130982, '任丘市', 130900, '任丘', 3, '0317', '062550', '116.1033', '38.71124', 'Renqiu', '1', 0);
INSERT INTO `hh_region` VALUES (130983, '黄骅市', 130900, '黄骅', 3, '0317', '061100', '117.33883', '38.3706', 'Huanghua', '1', 0);
INSERT INTO `hh_region` VALUES (130984, '河间市', 130900, '河间', 3, '0317', '062450', '116.0993', '38.44549', 'Hejian', '1', 0);
INSERT INTO `hh_region` VALUES (131000, '廊坊市', 130000, '廊坊', 2, '0316', '065000', '116.713873', '39.529244', 'Langfang', '1', 0);
INSERT INTO `hh_region` VALUES (131002, '安次区', 131000, '安次', 3, '0316', '065000', '116.70308', '39.52057', 'Anci', '1', 0);
INSERT INTO `hh_region` VALUES (131003, '广阳区', 131000, '广阳', 3, '0316', '065000', '116.71069', '39.52278', 'Guangyang', '1', 0);
INSERT INTO `hh_region` VALUES (131022, '固安县', 131000, '固安', 3, '0316', '065500', '116.29916', '39.43833', 'Gu\'an', '1', 0);
INSERT INTO `hh_region` VALUES (131023, '永清县', 131000, '永清', 3, '0316', '065600', '116.50091', '39.32069', 'Yongqing', '1', 0);
INSERT INTO `hh_region` VALUES (131024, '香河县', 131000, '香河', 3, '0316', '065400', '117.00634', '39.76133', 'Xianghe', '1', 0);
INSERT INTO `hh_region` VALUES (131025, '大城县', 131000, '大城', 3, '0316', '065900', '116.65353', '38.70534', 'Daicheng', '1', 0);
INSERT INTO `hh_region` VALUES (131026, '文安县', 131000, '文安', 3, '0316', '065800', '116.45846', '38.87325', 'Wen\'an', '1', 0);
INSERT INTO `hh_region` VALUES (131028, '大厂回族自治县', 131000, '大厂', 3, '0316', '065300', '116.98916', '39.88649', 'Dachang', '1', 0);
INSERT INTO `hh_region` VALUES (131081, '霸州市', 131000, '霸州', 3, '0316', '065700', '116.39154', '39.12569', 'Bazhou', '1', 0);
INSERT INTO `hh_region` VALUES (131082, '三河市', 131000, '三河', 3, '0316', '065200', '117.07229', '39.98358', 'Sanhe', '1', 0);
INSERT INTO `hh_region` VALUES (131100, '衡水市', 130000, '衡水', 2, '0318', '053000', '115.665993', '37.735097', 'Hengshui', '1', 0);
INSERT INTO `hh_region` VALUES (131102, '桃城区', 131100, '桃城', 3, '0318', '053000', '115.67529', '37.73499', 'Taocheng', '1', 0);
INSERT INTO `hh_region` VALUES (131121, '枣强县', 131100, '枣强', 3, '0318', '053100', '115.72576', '37.51027', 'Zaoqiang', '1', 0);
INSERT INTO `hh_region` VALUES (131122, '武邑县', 131100, '武邑', 3, '0318', '053400', '115.88748', '37.80181', 'Wuyi', '1', 0);
INSERT INTO `hh_region` VALUES (131123, '武强县', 131100, '武强', 3, '0318', '053300', '115.98226', '38.04138', 'Wuqiang', '1', 0);
INSERT INTO `hh_region` VALUES (131124, '饶阳县', 131100, '饶阳', 3, '0318', '053900', '115.72558', '38.23529', 'Raoyang', '1', 0);
INSERT INTO `hh_region` VALUES (131125, '安平县', 131100, '安平', 3, '0318', '053600', '115.51876', '38.23388', 'Anping', '1', 0);
INSERT INTO `hh_region` VALUES (131126, '故城县', 131100, '故城', 3, '0318', '053800', '115.97076', '37.34773', 'Gucheng', '1', 0);
INSERT INTO `hh_region` VALUES (131127, '景县', 131100, '景县', 3, '0318', '053500', '116.26904', '37.6926', 'Jingxian', '1', 0);
INSERT INTO `hh_region` VALUES (131128, '阜城县', 131100, '阜城', 3, '0318', '053700', '116.14431', '37.86881', 'Fucheng', '1', 0);
INSERT INTO `hh_region` VALUES (131181, '冀州市', 131100, '冀州', 3, '0318', '053200', '115.57934', '37.55082', 'Jizhou', '1', 0);
INSERT INTO `hh_region` VALUES (131182, '深州市', 131100, '深州', 3, '0318', '053800', '115.55993', '38.00109', 'Shenzhou', '1', 0);
INSERT INTO `hh_region` VALUES (140000, '山西省', 100000, '山西', 1, '', '', '112.549248', '37.857014', 'Shanxi', '1', 0);
INSERT INTO `hh_region` VALUES (140100, '太原市', 140000, '太原', 2, '0351', '030082', '112.549248', '37.857014', 'Taiyuan', '1', 0);
INSERT INTO `hh_region` VALUES (140105, '小店区', 140100, '小店', 3, '0351', '030032', '112.56878', '37.73565', 'Xiaodian', '1', 0);
INSERT INTO `hh_region` VALUES (140106, '迎泽区', 140100, '迎泽', 3, '0351', '030002', '112.56338', '37.86326', 'Yingze', '1', 0);
INSERT INTO `hh_region` VALUES (140107, '杏花岭区', 140100, '杏花岭', 3, '0351', '030009', '112.56237', '37.88429', 'Xinghualing', '1', 0);
INSERT INTO `hh_region` VALUES (140108, '尖草坪区', 140100, '尖草坪', 3, '0351', '030023', '112.48709', '37.94193', 'Jiancaoping', '1', 0);
INSERT INTO `hh_region` VALUES (140109, '万柏林区', 140100, '万柏林', 3, '0351', '030024', '112.51553', '37.85923', 'Wanbailin', '1', 0);
INSERT INTO `hh_region` VALUES (140110, '晋源区', 140100, '晋源', 3, '0351', '030025', '112.47985', '37.72479', 'Jinyuan', '1', 0);
INSERT INTO `hh_region` VALUES (140121, '清徐县', 140100, '清徐', 3, '0351', '030400', '112.35888', '37.60758', 'Qingxu', '1', 0);
INSERT INTO `hh_region` VALUES (140122, '阳曲县', 140100, '阳曲', 3, '0351', '030100', '112.67861', '38.05989', 'Yangqu', '1', 0);
INSERT INTO `hh_region` VALUES (140123, '娄烦县', 140100, '娄烦', 3, '0351', '030300', '111.79473', '38.06689', 'Loufan', '1', 0);
INSERT INTO `hh_region` VALUES (140181, '古交市', 140100, '古交', 3, '0351', '030200', '112.16918', '37.90983', 'Gujiao', '1', 0);
INSERT INTO `hh_region` VALUES (140200, '大同市', 140000, '大同', 2, '0352', '037008', '113.295259', '40.09031', 'Datong', '1', 0);
INSERT INTO `hh_region` VALUES (140202, '城区', 140200, '城区', 3, '0352', '037008', '113.298', '40.07566', 'Chengqu', '1', 0);
INSERT INTO `hh_region` VALUES (140203, '矿区', 140200, '矿区', 3, '0352', '037003', '113.1772', '40.03685', 'Kuangqu', '1', 0);
INSERT INTO `hh_region` VALUES (140211, '南郊区', 140200, '南郊', 3, '0352', '037001', '113.14947', '40.00539', 'Nanjiao', '1', 0);
INSERT INTO `hh_region` VALUES (140212, '新荣区', 140200, '新荣', 3, '0352', '037002', '113.13504', '40.25618', 'Xinrong', '1', 0);
INSERT INTO `hh_region` VALUES (140221, '阳高县', 140200, '阳高', 3, '0352', '038100', '113.75012', '40.36256', 'Yanggao', '1', 0);
INSERT INTO `hh_region` VALUES (140222, '天镇县', 140200, '天镇', 3, '0352', '038200', '114.0931', '40.42299', 'Tianzhen', '1', 0);
INSERT INTO `hh_region` VALUES (140223, '广灵县', 140200, '广灵', 3, '0352', '037500', '114.28204', '39.76082', 'Guangling', '1', 0);
INSERT INTO `hh_region` VALUES (140224, '灵丘县', 140200, '灵丘', 3, '0352', '034400', '114.23672', '39.44043', 'Lingqiu', '1', 0);
INSERT INTO `hh_region` VALUES (140225, '浑源县', 140200, '浑源', 3, '0352', '037400', '113.69552', '39.69962', 'Hunyuan', '1', 0);
INSERT INTO `hh_region` VALUES (140226, '左云县', 140200, '左云', 3, '0352', '037100', '112.70266', '40.01336', 'Zuoyun', '1', 0);
INSERT INTO `hh_region` VALUES (140227, '大同县', 140200, '大同', 3, '0352', '037300', '113.61212', '40.04012', 'Datong', '1', 0);
INSERT INTO `hh_region` VALUES (140300, '阳泉市', 140000, '阳泉', 2, '0353', '045000', '113.583285', '37.861188', 'Yangquan', '1', 0);
INSERT INTO `hh_region` VALUES (140302, '城区', 140300, '城区', 3, '0353', '045000', '113.60069', '37.8474', 'Chengqu', '1', 0);
INSERT INTO `hh_region` VALUES (140303, '矿区', 140300, '矿区', 3, '0353', '045000', '113.55677', '37.86895', 'Kuangqu', '1', 0);
INSERT INTO `hh_region` VALUES (140311, '郊区', 140300, '郊区', 3, '0353', '045011', '113.58539', '37.94139', 'Jiaoqu', '1', 0);
INSERT INTO `hh_region` VALUES (140321, '平定县', 140300, '平定', 3, '0353', '045200', '113.65789', '37.78601', 'Pingding', '1', 0);
INSERT INTO `hh_region` VALUES (140322, '盂县', 140300, '盂县', 3, '0353', '045100', '113.41235', '38.08579', 'Yuxian', '1', 0);
INSERT INTO `hh_region` VALUES (140400, '长治市', 140000, '长治', 2, '0355', '046000', '113.113556', '36.191112', 'Changzhi', '1', 0);
INSERT INTO `hh_region` VALUES (140402, '城区', 140400, '城区', 3, '0355', '046011', '113.12308', '36.20351', 'Chengqu', '1', 0);
INSERT INTO `hh_region` VALUES (140411, '郊区', 140400, '郊区', 3, '0355', '046011', '113.12653', '36.19918', 'Jiaoqu', '1', 0);
INSERT INTO `hh_region` VALUES (140421, '长治县', 140400, '长治', 3, '0355', '047100', '113.04791', '36.04722', 'Changzhi', '1', 0);
INSERT INTO `hh_region` VALUES (140423, '襄垣县', 140400, '襄垣', 3, '0355', '046200', '113.05157', '36.53527', 'Xiangyuan', '1', 0);
INSERT INTO `hh_region` VALUES (140424, '屯留县', 140400, '屯留', 3, '0355', '046100', '112.89196', '36.31579', 'Tunliu', '1', 0);
INSERT INTO `hh_region` VALUES (140425, '平顺县', 140400, '平顺', 3, '0355', '047400', '113.43603', '36.20005', 'Pingshun', '1', 0);
INSERT INTO `hh_region` VALUES (140426, '黎城县', 140400, '黎城', 3, '0355', '047600', '113.38766', '36.50301', 'Licheng', '1', 0);
INSERT INTO `hh_region` VALUES (140427, '壶关县', 140400, '壶关', 3, '0355', '047300', '113.207', '36.11301', 'Huguan', '1', 0);
INSERT INTO `hh_region` VALUES (140428, '长子县', 140400, '长子', 3, '0355', '046600', '112.87731', '36.12125', 'Zhangzi', '1', 0);
INSERT INTO `hh_region` VALUES (140429, '武乡县', 140400, '武乡', 3, '0355', '046300', '112.86343', '36.83687', 'Wuxiang', '1', 0);
INSERT INTO `hh_region` VALUES (140430, '沁县', 140400, '沁县', 3, '0355', '046400', '112.69863', '36.75628', 'Qinxian', '1', 0);
INSERT INTO `hh_region` VALUES (140431, '沁源县', 140400, '沁源', 3, '0355', '046500', '112.33758', '36.50008', 'Qinyuan', '1', 0);
INSERT INTO `hh_region` VALUES (140481, '潞城市', 140400, '潞城', 3, '0355', '047500', '113.22888', '36.33414', 'Lucheng', '1', 0);
INSERT INTO `hh_region` VALUES (140500, '晋城市', 140000, '晋城', 2, '0356', '048000', '112.851274', '35.497553', 'Jincheng', '1', 0);
INSERT INTO `hh_region` VALUES (140502, '城区', 140500, '城区', 3, '0356', '048000', '112.85319', '35.50175', 'Chengqu', '1', 0);
INSERT INTO `hh_region` VALUES (140521, '沁水县', 140500, '沁水', 3, '0356', '048200', '112.1871', '35.69102', 'Qinshui', '1', 0);
INSERT INTO `hh_region` VALUES (140522, '阳城县', 140500, '阳城', 3, '0356', '048100', '112.41485', '35.48614', 'Yangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (140524, '陵川县', 140500, '陵川', 3, '0356', '048300', '113.2806', '35.77532', 'Lingchuan', '1', 0);
INSERT INTO `hh_region` VALUES (140525, '泽州县', 140500, '泽州', 3, '0356', '048012', '112.83947', '35.50789', 'Zezhou', '1', 0);
INSERT INTO `hh_region` VALUES (140581, '高平市', 140500, '高平', 3, '0356', '048400', '112.92288', '35.79705', 'Gaoping', '1', 0);
INSERT INTO `hh_region` VALUES (140600, '朔州市', 140000, '朔州', 2, '0349', '038500', '112.433387', '39.331261', 'Shuozhou', '1', 0);
INSERT INTO `hh_region` VALUES (140602, '朔城区', 140600, '朔城', 3, '0349', '036000', '112.43189', '39.31982', 'Shuocheng', '1', 0);
INSERT INTO `hh_region` VALUES (140603, '平鲁区', 140600, '平鲁', 3, '0349', '038600', '112.28833', '39.51155', 'Pinglu', '1', 0);
INSERT INTO `hh_region` VALUES (140621, '山阴县', 140600, '山阴', 3, '0349', '036900', '112.81662', '39.52697', 'Shanyin', '1', 0);
INSERT INTO `hh_region` VALUES (140622, '应县', 140600, '应县', 3, '0349', '037600', '113.19052', '39.55279', 'Yingxian', '1', 0);
INSERT INTO `hh_region` VALUES (140623, '右玉县', 140600, '右玉', 3, '0349', '037200', '112.46902', '39.99011', 'Youyu', '1', 0);
INSERT INTO `hh_region` VALUES (140624, '怀仁县', 140600, '怀仁', 3, '0349', '038300', '113.10009', '39.82806', 'Huairen', '1', 0);
INSERT INTO `hh_region` VALUES (140700, '晋中市', 140000, '晋中', 2, '0354', '030600', '112.736465', '37.696495', 'Jinzhong', '1', 0);
INSERT INTO `hh_region` VALUES (140702, '榆次区', 140700, '榆次', 3, '0354', '030600', '112.70788', '37.6978', 'Yuci', '1', 0);
INSERT INTO `hh_region` VALUES (140721, '榆社县', 140700, '榆社', 3, '0354', '031800', '112.97558', '37.0721', 'Yushe', '1', 0);
INSERT INTO `hh_region` VALUES (140722, '左权县', 140700, '左权', 3, '0354', '032600', '113.37918', '37.08235', 'Zuoquan', '1', 0);
INSERT INTO `hh_region` VALUES (140723, '和顺县', 140700, '和顺', 3, '0354', '032700', '113.56988', '37.32963', 'Heshun', '1', 0);
INSERT INTO `hh_region` VALUES (140724, '昔阳县', 140700, '昔阳', 3, '0354', '045300', '113.70517', '37.61863', 'Xiyang', '1', 0);
INSERT INTO `hh_region` VALUES (140725, '寿阳县', 140700, '寿阳', 3, '0354', '045400', '113.17495', '37.88899', 'Shouyang', '1', 0);
INSERT INTO `hh_region` VALUES (140726, '太谷县', 140700, '太谷', 3, '0354', '030800', '112.55246', '37.42161', 'Taigu', '1', 0);
INSERT INTO `hh_region` VALUES (140727, '祁县', 140700, '祁县', 3, '0354', '030900', '112.33358', '37.3579', 'Qixian', '1', 0);
INSERT INTO `hh_region` VALUES (140728, '平遥县', 140700, '平遥', 3, '0354', '031100', '112.17553', '37.1892', 'Pingyao', '1', 0);
INSERT INTO `hh_region` VALUES (140729, '灵石县', 140700, '灵石', 3, '0354', '031300', '111.7774', '36.84814', 'Lingshi', '1', 0);
INSERT INTO `hh_region` VALUES (140781, '介休市', 140700, '介休', 3, '0354', '032000', '111.91824', '37.02771', 'Jiexiu', '1', 0);
INSERT INTO `hh_region` VALUES (140800, '运城市', 140000, '运城', 2, '0359', '044000', '111.003957', '35.022778', 'Yuncheng', '1', 0);
INSERT INTO `hh_region` VALUES (140802, '盐湖区', 140800, '盐湖', 3, '0359', '044000', '110.99827', '35.0151', 'Yanhu', '1', 0);
INSERT INTO `hh_region` VALUES (140821, '临猗县', 140800, '临猗', 3, '0359', '044100', '110.77432', '35.14455', 'Linyi', '1', 0);
INSERT INTO `hh_region` VALUES (140822, '万荣县', 140800, '万荣', 3, '0359', '044200', '110.83657', '35.41556', 'Wanrong', '1', 0);
INSERT INTO `hh_region` VALUES (140823, '闻喜县', 140800, '闻喜', 3, '0359', '043800', '111.22265', '35.35553', 'Wenxi', '1', 0);
INSERT INTO `hh_region` VALUES (140824, '稷山县', 140800, '稷山', 3, '0359', '043200', '110.97924', '35.59993', 'Jishan', '1', 0);
INSERT INTO `hh_region` VALUES (140825, '新绛县', 140800, '新绛', 3, '0359', '043100', '111.22509', '35.61566', 'Xinjiang', '1', 0);
INSERT INTO `hh_region` VALUES (140826, '绛县', 140800, '绛县', 3, '0359', '043600', '111.56668', '35.49096', 'Jiangxian', '1', 0);
INSERT INTO `hh_region` VALUES (140827, '垣曲县', 140800, '垣曲', 3, '0359', '043700', '111.67166', '35.29923', 'Yuanqu', '1', 0);
INSERT INTO `hh_region` VALUES (140828, '夏县', 140800, '夏县', 3, '0359', '044400', '111.21966', '35.14121', 'Xiaxian', '1', 0);
INSERT INTO `hh_region` VALUES (140829, '平陆县', 140800, '平陆', 3, '0359', '044300', '111.21704', '34.83772', 'Pinglu', '1', 0);
INSERT INTO `hh_region` VALUES (140830, '芮城县', 140800, '芮城', 3, '0359', '044600', '110.69455', '34.69384', 'Ruicheng', '1', 0);
INSERT INTO `hh_region` VALUES (140881, '永济市', 140800, '永济', 3, '0359', '044500', '110.44537', '34.86556', 'Yongji', '1', 0);
INSERT INTO `hh_region` VALUES (140882, '河津市', 140800, '河津', 3, '0359', '043300', '110.7116', '35.59478', 'Hejin', '1', 0);
INSERT INTO `hh_region` VALUES (140900, '忻州市', 140000, '忻州', 2, '0350', '034000', '112.733538', '38.41769', 'Xinzhou', '1', 0);
INSERT INTO `hh_region` VALUES (140902, '忻府区', 140900, '忻府', 3, '0350', '034000', '112.74603', '38.40414', 'Xinfu', '1', 0);
INSERT INTO `hh_region` VALUES (140921, '定襄县', 140900, '定襄', 3, '0350', '035400', '112.95733', '38.47387', 'Dingxiang', '1', 0);
INSERT INTO `hh_region` VALUES (140922, '五台县', 140900, '五台', 3, '0350', '035500', '113.25256', '38.72774', 'Wutai', '1', 0);
INSERT INTO `hh_region` VALUES (140923, '代县', 140900, '代县', 3, '0350', '034200', '112.95913', '39.06717', 'Daixian', '1', 0);
INSERT INTO `hh_region` VALUES (140924, '繁峙县', 140900, '繁峙', 3, '0350', '034300', '113.26303', '39.18886', 'Fanshi', '1', 0);
INSERT INTO `hh_region` VALUES (140925, '宁武县', 140900, '宁武', 3, '0350', '036700', '112.30423', '39.00211', 'Ningwu', '1', 0);
INSERT INTO `hh_region` VALUES (140926, '静乐县', 140900, '静乐', 3, '0350', '035100', '111.94158', '38.3602', 'Jingle', '1', 0);
INSERT INTO `hh_region` VALUES (140927, '神池县', 140900, '神池', 3, '0350', '036100', '112.20541', '39.09', 'Shenchi', '1', 0);
INSERT INTO `hh_region` VALUES (140928, '五寨县', 140900, '五寨', 3, '0350', '036200', '111.8489', '38.90757', 'Wuzhai', '1', 0);
INSERT INTO `hh_region` VALUES (140929, '岢岚县', 140900, '岢岚', 3, '0350', '036300', '111.57388', '38.70452', 'Kelan', '1', 0);
INSERT INTO `hh_region` VALUES (140930, '河曲县', 140900, '河曲', 3, '0350', '036500', '111.13821', '39.38439', 'Hequ', '1', 0);
INSERT INTO `hh_region` VALUES (140931, '保德县', 140900, '保德', 3, '0350', '036600', '111.08656', '39.02248', 'Baode', '1', 0);
INSERT INTO `hh_region` VALUES (140932, '偏关县', 140900, '偏关', 3, '0350', '036400', '111.50863', '39.43609', 'Pianguan', '1', 0);
INSERT INTO `hh_region` VALUES (140981, '原平市', 140900, '原平', 3, '0350', '034100', '112.70584', '38.73181', 'Yuanping', '1', 0);
INSERT INTO `hh_region` VALUES (141000, '临汾市', 140000, '临汾', 2, '0357', '041000', '111.517973', '36.08415', 'Linfen', '1', 0);
INSERT INTO `hh_region` VALUES (141002, '尧都区', 141000, '尧都', 3, '0357', '041000', '111.5787', '36.08298', 'Yaodu', '1', 0);
INSERT INTO `hh_region` VALUES (141021, '曲沃县', 141000, '曲沃', 3, '0357', '043400', '111.47525', '35.64119', 'Quwo', '1', 0);
INSERT INTO `hh_region` VALUES (141022, '翼城县', 141000, '翼城', 3, '0357', '043500', '111.7181', '35.73881', 'Yicheng', '1', 0);
INSERT INTO `hh_region` VALUES (141023, '襄汾县', 141000, '襄汾', 3, '0357', '041500', '111.44204', '35.87711', 'Xiangfen', '1', 0);
INSERT INTO `hh_region` VALUES (141024, '洪洞县', 141000, '洪洞', 3, '0357', '041600', '111.67501', '36.25425', 'Hongtong', '1', 0);
INSERT INTO `hh_region` VALUES (141025, '古县', 141000, '古县', 3, '0357', '042400', '111.92041', '36.26688', 'Guxian', '1', 0);
INSERT INTO `hh_region` VALUES (141026, '安泽县', 141000, '安泽', 3, '0357', '042500', '112.24981', '36.14803', 'Anze', '1', 0);
INSERT INTO `hh_region` VALUES (141027, '浮山县', 141000, '浮山', 3, '0357', '042600', '111.84744', '35.96854', 'Fushan', '1', 0);
INSERT INTO `hh_region` VALUES (141028, '吉县', 141000, '吉县', 3, '0357', '042200', '110.68148', '36.09873', 'Jixian', '1', 0);
INSERT INTO `hh_region` VALUES (141029, '乡宁县', 141000, '乡宁', 3, '0357', '042100', '110.84652', '35.97072', 'Xiangning', '1', 0);
INSERT INTO `hh_region` VALUES (141030, '大宁县', 141000, '大宁', 3, '0357', '042300', '110.75216', '36.46624', 'Daning', '1', 0);
INSERT INTO `hh_region` VALUES (141031, '隰县', 141000, '隰县', 3, '0357', '041300', '110.93881', '36.69258', 'Xixian', '1', 0);
INSERT INTO `hh_region` VALUES (141032, '永和县', 141000, '永和', 3, '0357', '041400', '110.63168', '36.7584', 'Yonghe', '1', 0);
INSERT INTO `hh_region` VALUES (141033, '蒲县', 141000, '蒲县', 3, '0357', '041200', '111.09674', '36.41243', 'Puxian', '1', 0);
INSERT INTO `hh_region` VALUES (141034, '汾西县', 141000, '汾西', 3, '0357', '031500', '111.56811', '36.65063', 'Fenxi', '1', 0);
INSERT INTO `hh_region` VALUES (141081, '侯马市', 141000, '侯马', 3, '0357', '043000', '111.37207', '35.61903', 'Houma', '1', 0);
INSERT INTO `hh_region` VALUES (141082, '霍州市', 141000, '霍州', 3, '0357', '031400', '111.755', '36.5638', 'Huozhou', '1', 0);
INSERT INTO `hh_region` VALUES (141100, '吕梁市', 140000, '吕梁', 2, '0358', '033000', '111.134335', '37.524366', 'Lvliang', '1', 0);
INSERT INTO `hh_region` VALUES (141102, '离石区', 141100, '离石', 3, '0358', '033000', '111.15059', '37.5177', 'Lishi', '1', 0);
INSERT INTO `hh_region` VALUES (141121, '文水县', 141100, '文水', 3, '0358', '032100', '112.02829', '37.43841', 'Wenshui', '1', 0);
INSERT INTO `hh_region` VALUES (141122, '交城县', 141100, '交城', 3, '0358', '030500', '112.1585', '37.5512', 'Jiaocheng', '1', 0);
INSERT INTO `hh_region` VALUES (141123, '兴县', 141100, '兴县', 3, '0358', '033600', '111.12692', '38.46321', 'Xingxian', '1', 0);
INSERT INTO `hh_region` VALUES (141124, '临县', 141100, '临县', 3, '0358', '033200', '110.99282', '37.95271', 'Linxian', '1', 0);
INSERT INTO `hh_region` VALUES (141125, '柳林县', 141100, '柳林', 3, '0358', '033300', '110.88922', '37.42932', 'Liulin', '1', 0);
INSERT INTO `hh_region` VALUES (141126, '石楼县', 141100, '石楼', 3, '0358', '032500', '110.8352', '36.99731', 'Shilou', '1', 0);
INSERT INTO `hh_region` VALUES (141127, '岚县', 141100, '岚县', 3, '0358', '033500', '111.67627', '38.27874', 'Lanxian', '1', 0);
INSERT INTO `hh_region` VALUES (141128, '方山县', 141100, '方山', 3, '0358', '033100', '111.24011', '37.88979', 'Fangshan', '1', 0);
INSERT INTO `hh_region` VALUES (141129, '中阳县', 141100, '中阳', 3, '0358', '033400', '111.1795', '37.35715', 'Zhongyang', '1', 0);
INSERT INTO `hh_region` VALUES (141130, '交口县', 141100, '交口', 3, '0358', '032400', '111.18103', '36.98213', 'Jiaokou', '1', 0);
INSERT INTO `hh_region` VALUES (141181, '孝义市', 141100, '孝义', 3, '0358', '032300', '111.77362', '37.14414', 'Xiaoyi', '1', 0);
INSERT INTO `hh_region` VALUES (141182, '汾阳市', 141100, '汾阳', 3, '0358', '032200', '111.7882', '37.26605', 'Fenyang', '1', 0);
INSERT INTO `hh_region` VALUES (150000, '内蒙古自治区', 100000, '内蒙古', 1, '', '', '111.670801', '40.818311', 'Inner Mongolia', '1', 0);
INSERT INTO `hh_region` VALUES (150100, '呼和浩特市', 150000, '呼和浩特', 2, '0471', '010000', '111.670801', '40.818311', 'Hohhot', '1', 0);
INSERT INTO `hh_region` VALUES (150102, '新城区', 150100, '新城', 3, '0471', '010050', '111.66554', '40.85828', 'Xincheng', '1', 0);
INSERT INTO `hh_region` VALUES (150103, '回民区', 150100, '回民', 3, '0471', '010030', '111.62402', '40.80827', 'Huimin', '1', 0);
INSERT INTO `hh_region` VALUES (150104, '玉泉区', 150100, '玉泉', 3, '0471', '010020', '111.67456', '40.75227', 'Yuquan', '1', 0);
INSERT INTO `hh_region` VALUES (150105, '赛罕区', 150100, '赛罕', 3, '0471', '010020', '111.70224', '40.79207', 'Saihan', '1', 0);
INSERT INTO `hh_region` VALUES (150121, '土默特左旗', 150100, '土默特左旗', 3, '0471', '010100', '111.14898', '40.72229', 'Tumotezuoqi', '1', 0);
INSERT INTO `hh_region` VALUES (150122, '托克托县', 150100, '托克托', 3, '0471', '010200', '111.19101', '40.27492', 'Tuoketuo', '1', 0);
INSERT INTO `hh_region` VALUES (150123, '和林格尔县', 150100, '和林格尔', 3, '0471', '011500', '111.82205', '40.37892', 'Helingeer', '1', 0);
INSERT INTO `hh_region` VALUES (150124, '清水河县', 150100, '清水河', 3, '0471', '011600', '111.68316', '39.9097', 'Qingshuihe', '1', 0);
INSERT INTO `hh_region` VALUES (150125, '武川县', 150100, '武川', 3, '0471', '011700', '111.45785', '41.09289', 'Wuchuan', '1', 0);
INSERT INTO `hh_region` VALUES (150200, '包头市', 150000, '包头', 2, '0472', '014025', '109.840405', '40.658168', 'Baotou', '1', 0);
INSERT INTO `hh_region` VALUES (150202, '东河区', 150200, '东河', 3, '0472', '014040', '110.0462', '40.58237', 'Donghe', '1', 0);
INSERT INTO `hh_region` VALUES (150203, '昆都仑区', 150200, '昆都仑', 3, '0472', '014010', '109.83862', '40.64175', 'Kundulun', '1', 0);
INSERT INTO `hh_region` VALUES (150204, '青山区', 150200, '青山', 3, '0472', '014030', '109.90131', '40.64329', 'Qingshan', '1', 0);
INSERT INTO `hh_region` VALUES (150205, '石拐区', 150200, '石拐', 3, '0472', '014070', '110.27322', '40.67297', 'Shiguai', '1', 0);
INSERT INTO `hh_region` VALUES (150206, '白云鄂博矿区', 150200, '白云鄂博矿区', 3, '0472', '014080', '109.97367', '41.76968', 'Baiyunebokuangqu', '1', 0);
INSERT INTO `hh_region` VALUES (150207, '九原区', 150200, '九原', 3, '0472', '014060', '109.96496', '40.60554', 'Jiuyuan', '1', 0);
INSERT INTO `hh_region` VALUES (150221, '土默特右旗', 150200, '土默特右旗', 3, '0472', '014100', '110.52417', '40.5688', 'Tumoteyouqi', '1', 0);
INSERT INTO `hh_region` VALUES (150222, '固阳县', 150200, '固阳', 3, '0472', '014200', '110.06372', '41.01851', 'Guyang', '1', 0);
INSERT INTO `hh_region` VALUES (150223, '达尔罕茂明安联合旗', 150200, '达茂旗', 3, '0472', '014500', '110.43258', '41.69875', 'Damaoqi', '1', 0);
INSERT INTO `hh_region` VALUES (150300, '乌海市', 150000, '乌海', 2, '0473', '016000', '106.825563', '39.673734', 'Wuhai', '1', 0);
INSERT INTO `hh_region` VALUES (150302, '海勃湾区', 150300, '海勃湾', 3, '0473', '016000', '106.8222', '39.66955', 'Haibowan', '1', 0);
INSERT INTO `hh_region` VALUES (150303, '海南区', 150300, '海南', 3, '0473', '016030', '106.88656', '39.44128', 'Hainan', '1', 0);
INSERT INTO `hh_region` VALUES (150304, '乌达区', 150300, '乌达', 3, '0473', '016040', '106.72723', '39.505', 'Wuda', '1', 0);
INSERT INTO `hh_region` VALUES (150400, '赤峰市', 150000, '赤峰', 2, '0476', '024000', '118.956806', '42.275317', 'Chifeng', '1', 0);
INSERT INTO `hh_region` VALUES (150402, '红山区', 150400, '红山', 3, '0476', '024020', '118.95755', '42.24312', 'Hongshan', '1', 0);
INSERT INTO `hh_region` VALUES (150403, '元宝山区', 150400, '元宝山', 3, '0476', '024076', '119.28921', '42.04005', 'Yuanbaoshan', '1', 0);
INSERT INTO `hh_region` VALUES (150404, '松山区', 150400, '松山', 3, '0476', '024005', '118.9328', '42.28613', 'Songshan', '1', 0);
INSERT INTO `hh_region` VALUES (150421, '阿鲁科尔沁旗', 150400, '阿鲁科尔沁旗', 3, '0476', '025550', '120.06527', '43.87988', 'Alukeerqinqi', '1', 0);
INSERT INTO `hh_region` VALUES (150422, '巴林左旗', 150400, '巴林左旗', 3, '0476', '025450', '119.38012', '43.97031', 'Balinzuoqi', '1', 0);
INSERT INTO `hh_region` VALUES (150423, '巴林右旗', 150400, '巴林右旗', 3, '0476', '025150', '118.66461', '43.53387', 'Balinyouqi', '1', 0);
INSERT INTO `hh_region` VALUES (150424, '林西县', 150400, '林西', 3, '0476', '025250', '118.04733', '43.61165', 'Linxi', '1', 0);
INSERT INTO `hh_region` VALUES (150425, '克什克腾旗', 150400, '克什克腾旗', 3, '0476', '025350', '117.54562', '43.26501', 'Keshiketengqi', '1', 0);
INSERT INTO `hh_region` VALUES (150426, '翁牛特旗', 150400, '翁牛特旗', 3, '0476', '024500', '119.03042', '42.93147', 'Wengniuteqi', '1', 0);
INSERT INTO `hh_region` VALUES (150428, '喀喇沁旗', 150400, '喀喇沁旗', 3, '0476', '024400', '118.70144', '41.92917', 'Kalaqinqi', '1', 0);
INSERT INTO `hh_region` VALUES (150429, '宁城县', 150400, '宁城', 3, '0476', '024200', '119.34375', '41.59661', 'Ningcheng', '1', 0);
INSERT INTO `hh_region` VALUES (150430, '敖汉旗', 150400, '敖汉旗', 3, '0476', '024300', '119.92163', '42.29071', 'Aohanqi', '1', 0);
INSERT INTO `hh_region` VALUES (150500, '通辽市', 150000, '通辽', 2, '0475', '028000', '122.263119', '43.617429', 'Tongliao', '1', 0);
INSERT INTO `hh_region` VALUES (150502, '科尔沁区', 150500, '科尔沁', 3, '0475', '028000', '122.25573', '43.62257', 'Keerqin', '1', 0);
INSERT INTO `hh_region` VALUES (150521, '科尔沁左翼中旗', 150500, '科尔沁左翼中旗', 3, '0475', '029300', '123.31912', '44.13014', 'Keerqinzuoyizhongqi', '1', 0);
INSERT INTO `hh_region` VALUES (150522, '科尔沁左翼后旗', 150500, '科尔沁左翼后旗', 3, '0475', '028100', '122.35745', '42.94897', 'Keerqinzuoyihouqi', '1', 0);
INSERT INTO `hh_region` VALUES (150523, '开鲁县', 150500, '开鲁', 3, '0475', '028400', '121.31884', '43.60003', 'Kailu', '1', 0);
INSERT INTO `hh_region` VALUES (150524, '库伦旗', 150500, '库伦旗', 3, '0475', '028200', '121.776', '42.72998', 'Kulunqi', '1', 0);
INSERT INTO `hh_region` VALUES (150525, '奈曼旗', 150500, '奈曼旗', 3, '0475', '028300', '120.66348', '42.84527', 'Naimanqi', '1', 0);
INSERT INTO `hh_region` VALUES (150526, '扎鲁特旗', 150500, '扎鲁特旗', 3, '0475', '029100', '120.91507', '44.55592', 'Zhaluteqi', '1', 0);
INSERT INTO `hh_region` VALUES (150581, '霍林郭勒市', 150500, '霍林郭勒', 3, '0475', '029200', '119.65429', '45.53454', 'Huolinguole', '1', 0);
INSERT INTO `hh_region` VALUES (150600, '鄂尔多斯市', 150000, '鄂尔多斯', 2, '0477', '017004', '109.99029', '39.817179', 'Ordos', '1', 0);
INSERT INTO `hh_region` VALUES (150602, '东胜区', 150600, '东胜', 3, '0477', '017000', '109.96289', '39.82236', 'Dongsheng', '1', 0);
INSERT INTO `hh_region` VALUES (150621, '达拉特旗', 150600, '达拉特旗', 3, '0477', '014300', '110.03317', '40.4001', 'Dalateqi', '1', 0);
INSERT INTO `hh_region` VALUES (150622, '准格尔旗', 150600, '准格尔旗', 3, '0477', '017100', '111.23645', '39.86783', 'Zhungeerqi', '1', 0);
INSERT INTO `hh_region` VALUES (150623, '鄂托克前旗', 150600, '鄂托克前旗', 3, '0477', '016200', '107.48403', '38.18396', 'Etuokeqianqi', '1', 0);
INSERT INTO `hh_region` VALUES (150624, '鄂托克旗', 150600, '鄂托克旗', 3, '0477', '016100', '107.98226', '39.09456', 'Etuokeqi', '1', 0);
INSERT INTO `hh_region` VALUES (150625, '杭锦旗', 150600, '杭锦旗', 3, '0477', '017400', '108.72934', '39.84023', 'Hangjinqi', '1', 0);
INSERT INTO `hh_region` VALUES (150626, '乌审旗', 150600, '乌审旗', 3, '0477', '017300', '108.8461', '38.59092', 'Wushenqi', '1', 0);
INSERT INTO `hh_region` VALUES (150627, '伊金霍洛旗', 150600, '伊金霍洛旗', 3, '0477', '017200', '109.74908', '39.57393', 'Yijinhuoluoqi', '1', 0);
INSERT INTO `hh_region` VALUES (150700, '呼伦贝尔市', 150000, '呼伦贝尔', 2, '0470', '021008', '119.758168', '49.215333', 'Hulunber', '1', 0);
INSERT INTO `hh_region` VALUES (150702, '海拉尔区', 150700, '海拉尔', 3, '0470', '021000', '119.7364', '49.2122', 'Hailaer', '1', 0);
INSERT INTO `hh_region` VALUES (150703, '扎赉诺尔区', 150700, '扎赉诺尔', 3, '0470', '021410', '117.792702', '49.486943', 'Zhalainuoer', '1', 0);
INSERT INTO `hh_region` VALUES (150721, '阿荣旗', 150700, '阿荣旗', 3, '0470', '162750', '123.45941', '48.12581', 'Arongqi', '1', 0);
INSERT INTO `hh_region` VALUES (150722, '莫力达瓦达斡尔族自治旗', 150700, '莫旗', 3, '0470', '162850', '124.51498', '48.48055', 'Moqi', '1', 0);
INSERT INTO `hh_region` VALUES (150723, '鄂伦春自治旗', 150700, '鄂伦春', 3, '0470', '165450', '123.72604', '50.59777', 'Elunchun', '1', 0);
INSERT INTO `hh_region` VALUES (150724, '鄂温克族自治旗', 150700, '鄂温', 3, '0470', '021100', '119.7565', '49.14284', 'Ewen', '1', 0);
INSERT INTO `hh_region` VALUES (150725, '陈巴尔虎旗', 150700, '陈巴尔虎旗', 3, '0470', '021500', '119.42434', '49.32684', 'Chenbaerhuqi', '1', 0);
INSERT INTO `hh_region` VALUES (150726, '新巴尔虎左旗', 150700, '新巴尔虎左旗', 3, '0470', '021200', '118.26989', '48.21842', 'Xinbaerhuzuoqi', '1', 0);
INSERT INTO `hh_region` VALUES (150727, '新巴尔虎右旗', 150700, '新巴尔虎右旗', 3, '0470', '021300', '116.82366', '48.66473', 'Xinbaerhuyouqi', '1', 0);
INSERT INTO `hh_region` VALUES (150781, '满洲里市', 150700, '满洲里', 3, '0470', '021400', '117.47946', '49.58272', 'Manzhouli', '1', 0);
INSERT INTO `hh_region` VALUES (150782, '牙克石市', 150700, '牙克石', 3, '0470', '022150', '120.7117', '49.2856', 'Yakeshi', '1', 0);
INSERT INTO `hh_region` VALUES (150783, '扎兰屯市', 150700, '扎兰屯', 3, '0470', '162650', '122.73757', '48.01363', 'Zhalantun', '1', 0);
INSERT INTO `hh_region` VALUES (150784, '额尔古纳市', 150700, '额尔古纳', 3, '0470', '022250', '120.19094', '50.24249', 'Eerguna', '1', 0);
INSERT INTO `hh_region` VALUES (150785, '根河市', 150700, '根河', 3, '0470', '022350', '121.52197', '50.77996', 'Genhe', '1', 0);
INSERT INTO `hh_region` VALUES (150800, '巴彦淖尔市', 150000, '巴彦淖尔', 2, '0478', '015001', '107.416959', '40.757402', 'Bayan Nur', '1', 0);
INSERT INTO `hh_region` VALUES (150802, '临河区', 150800, '临河', 3, '0478', '015001', '107.42668', '40.75827', 'Linhe', '1', 0);
INSERT INTO `hh_region` VALUES (150821, '五原县', 150800, '五原', 3, '0478', '015100', '108.26916', '41.09631', 'Wuyuan', '1', 0);
INSERT INTO `hh_region` VALUES (150822, '磴口县', 150800, '磴口', 3, '0478', '015200', '107.00936', '40.33062', 'Dengkou', '1', 0);
INSERT INTO `hh_region` VALUES (150823, '乌拉特前旗', 150800, '乌拉特前旗', 3, '0478', '014400', '108.65219', '40.73649', 'Wulateqianqi', '1', 0);
INSERT INTO `hh_region` VALUES (150824, '乌拉特中旗', 150800, '乌拉特中旗', 3, '0478', '015300', '108.52587', '41.56789', 'Wulatezhongqi', '1', 0);
INSERT INTO `hh_region` VALUES (150825, '乌拉特后旗', 150800, '乌拉特后旗', 3, '0478', '015500', '106.98971', '41.43151', 'Wulatehouqi', '1', 0);
INSERT INTO `hh_region` VALUES (150826, '杭锦后旗', 150800, '杭锦后旗', 3, '0478', '015400', '107.15133', '40.88627', 'Hangjinhouqi', '1', 0);
INSERT INTO `hh_region` VALUES (150900, '乌兰察布市', 150000, '乌兰察布', 2, '0474', '012000', '113.114543', '41.034126', 'Ulanqab', '1', 0);
INSERT INTO `hh_region` VALUES (150902, '集宁区', 150900, '集宁', 3, '0474', '012000', '113.11452', '41.0353', 'Jining', '1', 0);
INSERT INTO `hh_region` VALUES (150921, '卓资县', 150900, '卓资', 3, '0474', '012300', '112.57757', '40.89414', 'Zhuozi', '1', 0);
INSERT INTO `hh_region` VALUES (150922, '化德县', 150900, '化德', 3, '0474', '013350', '114.01071', '41.90433', 'Huade', '1', 0);
INSERT INTO `hh_region` VALUES (150923, '商都县', 150900, '商都', 3, '0474', '013450', '113.57772', '41.56213', 'Shangdu', '1', 0);
INSERT INTO `hh_region` VALUES (150924, '兴和县', 150900, '兴和', 3, '0474', '013650', '113.83395', '40.87186', 'Xinghe', '1', 0);
INSERT INTO `hh_region` VALUES (150925, '凉城县', 150900, '凉城', 3, '0474', '013750', '112.49569', '40.53346', 'Liangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (150926, '察哈尔右翼前旗', 150900, '察右前旗', 3, '0474', '012200', '113.22131', '40.7788', 'Chayouqianqi', '1', 0);
INSERT INTO `hh_region` VALUES (150927, '察哈尔右翼中旗', 150900, '察右中旗', 3, '0474', '013550', '112.63537', '41.27742', 'Chayouzhongqi', '1', 0);
INSERT INTO `hh_region` VALUES (150928, '察哈尔右翼后旗', 150900, '察右后旗', 3, '0474', '012400', '113.19216', '41.43554', 'Chayouhouqi', '1', 0);
INSERT INTO `hh_region` VALUES (150929, '四子王旗', 150900, '四子王旗', 3, '0474', '011800', '111.70654', '41.53312', 'Siziwangqi', '1', 0);
INSERT INTO `hh_region` VALUES (150981, '丰镇市', 150900, '丰镇', 3, '0474', '012100', '113.10983', '40.4369', 'Fengzhen', '1', 0);
INSERT INTO `hh_region` VALUES (152200, '兴安盟', 150000, '兴安盟', 2, '0482', '137401', '122.070317', '46.076268', 'Hinggan', '1', 0);
INSERT INTO `hh_region` VALUES (152201, '乌兰浩特市', 152200, '乌兰浩特', 3, '0482', '137401', '122.06378', '46.06235', 'Wulanhaote', '1', 0);
INSERT INTO `hh_region` VALUES (152202, '阿尔山市', 152200, '阿尔山', 3, '0482', '137800', '119.94317', '47.17716', 'Aershan', '1', 0);
INSERT INTO `hh_region` VALUES (152221, '科尔沁右翼前旗', 152200, '科右前旗', 3, '0482', '137423', '121.95269', '46.0795', 'Keyouqianqi', '1', 0);
INSERT INTO `hh_region` VALUES (152222, '科尔沁右翼中旗', 152200, '科右中旗', 3, '0482', '029400', '121.46807', '45.05605', 'Keyouzhongqi', '1', 0);
INSERT INTO `hh_region` VALUES (152223, '扎赉特旗', 152200, '扎赉特旗', 3, '0482', '137600', '122.91229', '46.7267', 'Zhalaiteqi', '1', 0);
INSERT INTO `hh_region` VALUES (152224, '突泉县', 152200, '突泉', 3, '0482', '137500', '121.59396', '45.38187', 'Tuquan', '1', 0);
INSERT INTO `hh_region` VALUES (152500, '锡林郭勒盟', 150000, '锡林郭勒盟', 2, '0479', '026000', '116.090996', '43.944018', 'Xilin Gol', '1', 0);
INSERT INTO `hh_region` VALUES (152501, '二连浩特市', 152500, '二连浩特', 3, '0479', '011100', '111.98297', '43.65303', 'Erlianhaote', '1', 0);
INSERT INTO `hh_region` VALUES (152502, '锡林浩特市', 152500, '锡林浩特', 3, '0479', '026021', '116.08603', '43.93341', 'Xilinhaote', '1', 0);
INSERT INTO `hh_region` VALUES (152522, '阿巴嘎旗', 152500, '阿巴嘎旗', 3, '0479', '011400', '114.96826', '44.02174', 'Abagaqi', '1', 0);
INSERT INTO `hh_region` VALUES (152523, '苏尼特左旗', 152500, '苏尼特左旗', 3, '0479', '011300', '113.6506', '43.85687', 'Sunitezuoqi', '1', 0);
INSERT INTO `hh_region` VALUES (152524, '苏尼特右旗', 152500, '苏尼特右旗', 3, '0479', '011200', '112.65741', '42.7469', 'Suniteyouqi', '1', 0);
INSERT INTO `hh_region` VALUES (152525, '东乌珠穆沁旗', 152500, '东乌旗', 3, '0479', '026300', '116.97293', '45.51108', 'Dongwuqi', '1', 0);
INSERT INTO `hh_region` VALUES (152526, '西乌珠穆沁旗', 152500, '西乌旗', 3, '0479', '026200', '117.60983', '44.59623', 'Xiwuqi', '1', 0);
INSERT INTO `hh_region` VALUES (152527, '太仆寺旗', 152500, '太仆寺旗', 3, '0479', '027000', '115.28302', '41.87727', 'Taipusiqi', '1', 0);
INSERT INTO `hh_region` VALUES (152528, '镶黄旗', 152500, '镶黄旗', 3, '0479', '013250', '113.84472', '42.23927', 'Xianghuangqi', '1', 0);
INSERT INTO `hh_region` VALUES (152529, '正镶白旗', 152500, '正镶白旗', 3, '0479', '013800', '115.00067', '42.30712', 'Zhengxiangbaiqi', '1', 0);
INSERT INTO `hh_region` VALUES (152530, '正蓝旗', 152500, '正蓝旗', 3, '0479', '027200', '116.00363', '42.25229', 'Zhenglanqi', '1', 0);
INSERT INTO `hh_region` VALUES (152531, '多伦县', 152500, '多伦', 3, '0479', '027300', '116.48565', '42.203', 'Duolun', '1', 0);
INSERT INTO `hh_region` VALUES (152900, '阿拉善盟', 150000, '阿拉善盟', 2, '0483', '750306', '105.706422', '38.844814', 'Alxa', '1', 0);
INSERT INTO `hh_region` VALUES (152921, '阿拉善左旗', 152900, '阿拉善左旗', 3, '0483', '750306', '105.67532', '38.8293', 'Alashanzuoqi', '1', 0);
INSERT INTO `hh_region` VALUES (152922, '阿拉善右旗', 152900, '阿拉善右旗', 3, '0483', '737300', '101.66705', '39.21533', 'Alashanyouqi', '1', 0);
INSERT INTO `hh_region` VALUES (152923, '额济纳旗', 152900, '额济纳旗', 3, '0483', '735400', '101.06887', '41.96755', 'Ejinaqi', '1', 0);
INSERT INTO `hh_region` VALUES (210000, '辽宁省', 100000, '辽宁', 1, '', '', '123.429096', '41.796767', 'Liaoning', '1', 0);
INSERT INTO `hh_region` VALUES (210100, '沈阳市', 210000, '沈阳', 2, '024', '110013', '123.429096', '41.796767', 'Shenyang', '1', 0);
INSERT INTO `hh_region` VALUES (210102, '和平区', 210100, '和平', 3, '024', '110001', '123.4204', '41.78997', 'Heping', '1', 0);
INSERT INTO `hh_region` VALUES (210103, '沈河区', 210100, '沈河', 3, '024', '110011', '123.45871', '41.79625', 'Shenhe', '1', 0);
INSERT INTO `hh_region` VALUES (210104, '大东区', 210100, '大东', 3, '024', '110041', '123.46997', '41.80539', 'Dadong', '1', 0);
INSERT INTO `hh_region` VALUES (210105, '皇姑区', 210100, '皇姑', 3, '024', '110031', '123.42527', '41.82035', 'Huanggu', '1', 0);
INSERT INTO `hh_region` VALUES (210106, '铁西区', 210100, '铁西', 3, '024', '110021', '123.37675', '41.80269', 'Tiexi', '1', 0);
INSERT INTO `hh_region` VALUES (210111, '苏家屯区', 210100, '苏家屯', 3, '024', '110101', '123.34405', '41.66475', 'Sujiatun', '1', 0);
INSERT INTO `hh_region` VALUES (210112, '浑南区', 210100, '浑南', 3, '024', '110015', '123.457707', '41.719450', 'Hunnan', '1', 0);
INSERT INTO `hh_region` VALUES (210113, '沈北新区', 210100, '沈北新区', 3, '024', '110121', '123.52658', '42.05297', 'Shenbeixinqu', '1', 0);
INSERT INTO `hh_region` VALUES (210114, '于洪区', 210100, '于洪', 3, '024', '110141', '123.30807', '41.794', 'Yuhong', '1', 0);
INSERT INTO `hh_region` VALUES (210122, '辽中县', 210100, '辽中', 3, '024', '110200', '122.72659', '41.51302', 'Liaozhong', '1', 0);
INSERT INTO `hh_region` VALUES (210123, '康平县', 210100, '康平', 3, '024', '110500', '123.35446', '42.75081', 'Kangping', '1', 0);
INSERT INTO `hh_region` VALUES (210124, '法库县', 210100, '法库', 3, '024', '110400', '123.41214', '42.50608', 'Faku', '1', 0);
INSERT INTO `hh_region` VALUES (210181, '新民市', 210100, '新民', 3, '024', '110300', '122.82867', '41.99847', 'Xinmin', '1', 0);
INSERT INTO `hh_region` VALUES (210200, '大连市', 210000, '大连', 2, '0411', '116011', '121.618622', '38.91459', 'Dalian', '1', 0);
INSERT INTO `hh_region` VALUES (210202, '中山区', 210200, '中山', 3, '0411', '116001', '121.64465', '38.91859', 'Zhongshan', '1', 0);
INSERT INTO `hh_region` VALUES (210203, '西岗区', 210200, '西岗', 3, '0411', '116011', '121.61238', '38.91469', 'Xigang', '1', 0);
INSERT INTO `hh_region` VALUES (210204, '沙河口区', 210200, '沙河口', 3, '0411', '116021', '121.58017', '38.90536', 'Shahekou', '1', 0);
INSERT INTO `hh_region` VALUES (210211, '甘井子区', 210200, '甘井子', 3, '0411', '116033', '121.56567', '38.95017', 'Ganjingzi', '1', 0);
INSERT INTO `hh_region` VALUES (210212, '旅顺口区', 210200, '旅顺口', 3, '0411', '116041', '121.26202', '38.85125', 'Lvshunkou', '1', 0);
INSERT INTO `hh_region` VALUES (210213, '金州区', 210200, '金州', 3, '0411', '116100', '121.71893', '39.1004', 'Jinzhou', '1', 0);
INSERT INTO `hh_region` VALUES (210224, '长海县', 210200, '长海', 3, '0411', '116500', '122.58859', '39.27274', 'Changhai', '1', 0);
INSERT INTO `hh_region` VALUES (210281, '瓦房店市', 210200, '瓦房店', 3, '0411', '116300', '121.98104', '39.62843', 'Wafangdian', '1', 0);
INSERT INTO `hh_region` VALUES (210282, '普兰店市', 210200, '普兰店', 3, '0411', '116200', '121.96316', '39.39465', 'Pulandian', '1', 0);
INSERT INTO `hh_region` VALUES (210283, '庄河市', 210200, '庄河', 3, '0411', '116400', '122.96725', '39.68815', 'Zhuanghe', '1', 0);
INSERT INTO `hh_region` VALUES (210300, '鞍山市', 210000, '鞍山', 2, '0412', '114001', '122.995632', '41.110626', 'Anshan', '1', 0);
INSERT INTO `hh_region` VALUES (210302, '铁东区', 210300, '铁东', 3, '0412', '114001', '122.99085', '41.08975', 'Tiedong', '1', 0);
INSERT INTO `hh_region` VALUES (210303, '铁西区', 210300, '铁西', 3, '0413', '114013', '122.96967', '41.11977', 'Tiexi', '1', 0);
INSERT INTO `hh_region` VALUES (210304, '立山区', 210300, '立山', 3, '0414', '114031', '123.02948', '41.15008', 'Lishan', '1', 0);
INSERT INTO `hh_region` VALUES (210311, '千山区', 210300, '千山', 3, '0415', '114041', '122.96048', '41.07507', 'Qianshan', '1', 0);
INSERT INTO `hh_region` VALUES (210321, '台安县', 210300, '台安', 3, '0417', '114100', '122.43585', '41.41265', 'Tai\'an', '1', 0);
INSERT INTO `hh_region` VALUES (210323, '岫岩满族自治县', 210300, '岫岩', 3, '0418', '114300', '123.28875', '40.27996', 'Xiuyan', '1', 0);
INSERT INTO `hh_region` VALUES (210381, '海城市', 210300, '海城', 3, '0416', '114200', '122.68457', '40.88142', 'Haicheng', '1', 0);
INSERT INTO `hh_region` VALUES (210400, '抚顺市', 210000, '抚顺', 2, '024', '113008', '123.921109', '41.875956', 'Fushun', '1', 0);
INSERT INTO `hh_region` VALUES (210402, '新抚区', 210400, '新抚', 3, '024', '113008', '123.91264', '41.86205', 'Xinfu', '1', 0);
INSERT INTO `hh_region` VALUES (210403, '东洲区', 210400, '东洲', 3, '024', '113003', '124.03759', '41.8519', 'Dongzhou', '1', 0);
INSERT INTO `hh_region` VALUES (210404, '望花区', 210400, '望花', 3, '024', '113001', '123.78283', '41.85532', 'Wanghua', '1', 0);
INSERT INTO `hh_region` VALUES (210411, '顺城区', 210400, '顺城', 3, '024', '113006', '123.94506', '41.88321', 'Shuncheng', '1', 0);
INSERT INTO `hh_region` VALUES (210421, '抚顺县', 210400, '抚顺', 3, '024', '113006', '124.17755', '41.71217', 'Fushun', '1', 0);
INSERT INTO `hh_region` VALUES (210422, '新宾满族自治县', 210400, '新宾', 3, '024', '113200', '125.04049', '41.73409', 'Xinbin', '1', 0);
INSERT INTO `hh_region` VALUES (210423, '清原满族自治县', 210400, '清原', 3, '024', '113300', '124.92807', '42.10221', 'Qingyuan', '1', 0);
INSERT INTO `hh_region` VALUES (210500, '本溪市', 210000, '本溪', 2, '0414', '117000', '123.770519', '41.297909', 'Benxi', '1', 0);
INSERT INTO `hh_region` VALUES (210502, '平山区', 210500, '平山', 3, '0414', '117000', '123.76892', '41.2997', 'Pingshan', '1', 0);
INSERT INTO `hh_region` VALUES (210503, '溪湖区', 210500, '溪湖', 3, '0414', '117002', '123.76764', '41.32921', 'Xihu', '1', 0);
INSERT INTO `hh_region` VALUES (210504, '明山区', 210500, '明山', 3, '0414', '117021', '123.81746', '41.30827', 'Mingshan', '1', 0);
INSERT INTO `hh_region` VALUES (210505, '南芬区', 210500, '南芬', 3, '0414', '117014', '123.74523', '41.1006', 'Nanfen', '1', 0);
INSERT INTO `hh_region` VALUES (210521, '本溪满族自治县', 210500, '本溪', 3, '0414', '117100', '124.12741', '41.30059', 'Benxi', '1', 0);
INSERT INTO `hh_region` VALUES (210522, '桓仁满族自治县', 210500, '桓仁', 3, '0414', '117200', '125.36062', '41.26798', 'Huanren', '1', 0);
INSERT INTO `hh_region` VALUES (210600, '丹东市', 210000, '丹东', 2, '0415', '118000', '124.383044', '40.124296', 'Dandong', '1', 0);
INSERT INTO `hh_region` VALUES (210602, '元宝区', 210600, '元宝', 3, '0415', '118000', '124.39575', '40.13651', 'Yuanbao', '1', 0);
INSERT INTO `hh_region` VALUES (210603, '振兴区', 210600, '振兴', 3, '0415', '118002', '124.36035', '40.10489', 'Zhenxing', '1', 0);
INSERT INTO `hh_region` VALUES (210604, '振安区', 210600, '振安', 3, '0415', '118001', '124.42816', '40.15826', 'Zhen\'an', '1', 0);
INSERT INTO `hh_region` VALUES (210624, '宽甸满族自治县', 210600, '宽甸', 3, '0415', '118200', '124.78247', '40.73187', 'Kuandian', '1', 0);
INSERT INTO `hh_region` VALUES (210681, '东港市', 210600, '东港', 3, '0415', '118300', '124.16287', '39.86256', 'Donggang', '1', 0);
INSERT INTO `hh_region` VALUES (210682, '凤城市', 210600, '凤城', 3, '0415', '118100', '124.06671', '40.45302', 'Fengcheng', '1', 0);
INSERT INTO `hh_region` VALUES (210700, '锦州市', 210000, '锦州', 2, '0416', '121000', '121.135742', '41.119269', 'Jinzhou', '1', 0);
INSERT INTO `hh_region` VALUES (210702, '古塔区', 210700, '古塔', 3, '0416', '121001', '121.12832', '41.11725', 'Guta', '1', 0);
INSERT INTO `hh_region` VALUES (210703, '凌河区', 210700, '凌河', 3, '0416', '121000', '121.15089', '41.11496', 'Linghe', '1', 0);
INSERT INTO `hh_region` VALUES (210711, '太和区', 210700, '太和', 3, '0416', '121011', '121.10354', '41.10929', 'Taihe', '1', 0);
INSERT INTO `hh_region` VALUES (210726, '黑山县', 210700, '黑山', 3, '0416', '121400', '122.12081', '41.69417', 'Heishan', '1', 0);
INSERT INTO `hh_region` VALUES (210727, '义县', 210700, '义县', 3, '0416', '121100', '121.24035', '41.53458', 'Yixian', '1', 0);
INSERT INTO `hh_region` VALUES (210781, '凌海市', 210700, '凌海', 3, '0416', '121200', '121.35705', '41.1737', 'Linghai', '1', 0);
INSERT INTO `hh_region` VALUES (210782, '北镇市', 210700, '北镇', 3, '0416', '121300', '121.79858', '41.59537', 'Beizhen', '1', 0);
INSERT INTO `hh_region` VALUES (210800, '营口市', 210000, '营口', 2, '0417', '115003', '122.235151', '40.667432', 'Yingkou', '1', 0);
INSERT INTO `hh_region` VALUES (210802, '站前区', 210800, '站前', 3, '0417', '115002', '122.25896', '40.67266', 'Zhanqian', '1', 0);
INSERT INTO `hh_region` VALUES (210803, '西市区', 210800, '西市', 3, '0417', '115004', '122.20641', '40.6664', 'Xishi', '1', 0);
INSERT INTO `hh_region` VALUES (210804, '鲅鱼圈区', 210800, '鲅鱼圈', 3, '0417', '115007', '122.13266', '40.26865', 'Bayuquan', '1', 0);
INSERT INTO `hh_region` VALUES (210811, '老边区', 210800, '老边', 3, '0417', '115005', '122.37996', '40.6803', 'Laobian', '1', 0);
INSERT INTO `hh_region` VALUES (210881, '盖州市', 210800, '盖州', 3, '0417', '115200', '122.35464', '40.40446', 'Gaizhou', '1', 0);
INSERT INTO `hh_region` VALUES (210882, '大石桥市', 210800, '大石桥', 3, '0417', '115100', '122.50927', '40.64567', 'Dashiqiao', '1', 0);
INSERT INTO `hh_region` VALUES (210900, '阜新市', 210000, '阜新', 2, '0418', '123000', '121.648962', '42.011796', 'Fuxin', '1', 0);
INSERT INTO `hh_region` VALUES (210902, '海州区', 210900, '海州', 3, '0418', '123000', '121.65626', '42.01336', 'Haizhou', '1', 0);
INSERT INTO `hh_region` VALUES (210903, '新邱区', 210900, '新邱', 3, '0418', '123005', '121.79251', '42.09181', 'Xinqiu', '1', 0);
INSERT INTO `hh_region` VALUES (210904, '太平区', 210900, '太平', 3, '0418', '123003', '121.67865', '42.01065', 'Taiping', '1', 0);
INSERT INTO `hh_region` VALUES (210905, '清河门区', 210900, '清河门', 3, '0418', '123006', '121.4161', '41.78309', 'Qinghemen', '1', 0);
INSERT INTO `hh_region` VALUES (210911, '细河区', 210900, '细河', 3, '0418', '123000', '121.68013', '42.02533', 'Xihe', '1', 0);
INSERT INTO `hh_region` VALUES (210921, '阜新蒙古族自治县', 210900, '阜新', 3, '0418', '123100', '121.75787', '42.0651', 'Fuxin', '1', 0);
INSERT INTO `hh_region` VALUES (210922, '彰武县', 210900, '彰武', 3, '0418', '123200', '122.54022', '42.38625', 'Zhangwu', '1', 0);
INSERT INTO `hh_region` VALUES (211000, '辽阳市', 210000, '辽阳', 2, '0419', '111000', '123.18152', '41.269402', 'Liaoyang', '1', 0);
INSERT INTO `hh_region` VALUES (211002, '白塔区', 211000, '白塔', 3, '0419', '111000', '123.1747', '41.27025', 'Baita', '1', 0);
INSERT INTO `hh_region` VALUES (211003, '文圣区', 211000, '文圣', 3, '0419', '111000', '123.18521', '41.26267', 'Wensheng', '1', 0);
INSERT INTO `hh_region` VALUES (211004, '宏伟区', 211000, '宏伟', 3, '0419', '111003', '123.1929', '41.21852', 'Hongwei', '1', 0);
INSERT INTO `hh_region` VALUES (211005, '弓长岭区', 211000, '弓长岭', 3, '0419', '111008', '123.41963', '41.15181', 'Gongchangling', '1', 0);
INSERT INTO `hh_region` VALUES (211011, '太子河区', 211000, '太子河', 3, '0419', '111000', '123.18182', '41.25337', 'Taizihe', '1', 0);
INSERT INTO `hh_region` VALUES (211021, '辽阳县', 211000, '辽阳', 3, '0419', '111200', '123.10574', '41.20542', 'Liaoyang', '1', 0);
INSERT INTO `hh_region` VALUES (211081, '灯塔市', 211000, '灯塔', 3, '0419', '111300', '123.33926', '41.42612', 'Dengta', '1', 0);
INSERT INTO `hh_region` VALUES (211100, '盘锦市', 210000, '盘锦', 2, '0427', '124010', '122.06957', '41.124484', 'Panjin', '1', 0);
INSERT INTO `hh_region` VALUES (211102, '双台子区', 211100, '双台子', 3, '0427', '124000', '122.06011', '41.1906', 'Shuangtaizi', '1', 0);
INSERT INTO `hh_region` VALUES (211103, '兴隆台区', 211100, '兴隆台', 3, '0427', '124010', '122.07529', '41.12402', 'Xinglongtai', '1', 0);
INSERT INTO `hh_region` VALUES (211121, '大洼县', 211100, '大洼', 3, '0427', '124200', '122.08239', '41.00244', 'Dawa', '1', 0);
INSERT INTO `hh_region` VALUES (211122, '盘山县', 211100, '盘山', 3, '0427', '124000', '121.99777', '41.23805', 'Panshan', '1', 0);
INSERT INTO `hh_region` VALUES (211200, '铁岭市', 210000, '铁岭', 2, '024', '112000', '123.844279', '42.290585', 'Tieling', '1', 0);
INSERT INTO `hh_region` VALUES (211202, '银州区', 211200, '银州', 3, '024', '112000', '123.8573', '42.29507', 'Yinzhou', '1', 0);
INSERT INTO `hh_region` VALUES (211204, '清河区', 211200, '清河', 3, '024', '112003', '124.15911', '42.54679', 'Qinghe', '1', 0);
INSERT INTO `hh_region` VALUES (211221, '铁岭县', 211200, '铁岭', 3, '024', '112000', '123.77325', '42.22498', 'Tieling', '1', 0);
INSERT INTO `hh_region` VALUES (211223, '西丰县', 211200, '西丰', 3, '024', '112400', '124.7304', '42.73756', 'Xifeng', '1', 0);
INSERT INTO `hh_region` VALUES (211224, '昌图县', 211200, '昌图', 3, '024', '112500', '124.11206', '42.78428', 'Changtu', '1', 0);
INSERT INTO `hh_region` VALUES (211281, '调兵山市', 211200, '调兵山', 3, '024', '112700', '123.56689', '42.4675', 'Diaobingshan', '1', 0);
INSERT INTO `hh_region` VALUES (211282, '开原市', 211200, '开原', 3, '024', '112300', '124.03945', '42.54585', 'Kaiyuan', '1', 0);
INSERT INTO `hh_region` VALUES (211300, '朝阳市', 210000, '朝阳', 2, '0421', '122000', '120.451176', '41.576758', 'Chaoyang', '1', 0);
INSERT INTO `hh_region` VALUES (211302, '双塔区', 211300, '双塔', 3, '0421', '122000', '120.45385', '41.566', 'Shuangta', '1', 0);
INSERT INTO `hh_region` VALUES (211303, '龙城区', 211300, '龙城', 3, '0421', '122000', '120.43719', '41.59264', 'Longcheng', '1', 0);
INSERT INTO `hh_region` VALUES (211321, '朝阳县', 211300, '朝阳', 3, '0421', '122000', '120.17401', '41.4324', 'Chaoyang', '1', 0);
INSERT INTO `hh_region` VALUES (211322, '建平县', 211300, '建平', 3, '0421', '122400', '119.64392', '41.40315', 'Jianping', '1', 0);
INSERT INTO `hh_region` VALUES (211324, '喀喇沁左翼蒙古族自治县', 211300, '喀喇沁左翼', 3, '0421', '122300', '119.74185', '41.12801', 'Kalaqinzuoyi', '1', 0);
INSERT INTO `hh_region` VALUES (211381, '北票市', 211300, '北票', 3, '0421', '122100', '120.76977', '41.80196', 'Beipiao', '1', 0);
INSERT INTO `hh_region` VALUES (211382, '凌源市', 211300, '凌源', 3, '0421', '122500', '119.40148', '41.24558', 'Lingyuan', '1', 0);
INSERT INTO `hh_region` VALUES (211400, '葫芦岛市', 210000, '葫芦岛', 2, '0429', '125000', '120.856394', '40.755572', 'Huludao', '1', 0);
INSERT INTO `hh_region` VALUES (211402, '连山区', 211400, '连山', 3, '0429', '125001', '120.86393', '40.75554', 'Lianshan', '1', 0);
INSERT INTO `hh_region` VALUES (211403, '龙港区', 211400, '龙港', 3, '0429', '125003', '120.94866', '40.71919', 'Longgang', '1', 0);
INSERT INTO `hh_region` VALUES (211404, '南票区', 211400, '南票', 3, '0429', '125027', '120.74978', '41.10707', 'Nanpiao', '1', 0);
INSERT INTO `hh_region` VALUES (211421, '绥中县', 211400, '绥中', 3, '0429', '125200', '120.34451', '40.32552', 'Suizhong', '1', 0);
INSERT INTO `hh_region` VALUES (211422, '建昌县', 211400, '建昌', 3, '0429', '125300', '119.8377', '40.82448', 'Jianchang', '1', 0);
INSERT INTO `hh_region` VALUES (211481, '兴城市', 211400, '兴城', 3, '0429', '125100', '120.72537', '40.61492', 'Xingcheng', '1', 0);
INSERT INTO `hh_region` VALUES (211500, '金普新区', 210000, '金普新区', 2, '0411', '116100', '121.789627', '39.055451', 'Jinpuxinqu', '1', 0);
INSERT INTO `hh_region` VALUES (211501, '金州新区', 211500, '金州新区', 3, '0411', '116100', '121.784821', '39.052252', 'Jinzhouxinqu', '1', 0);
INSERT INTO `hh_region` VALUES (211502, '普湾新区', 211500, '普湾新区', 3, '0411', '116200', '121.812812', '39.330093', 'Puwanxinqu', '1', 0);
INSERT INTO `hh_region` VALUES (211503, '保税区', 211500, '保税区', 3, '0411', '116100', '121.94289', '39.224614', 'Baoshuiqu', '1', 0);
INSERT INTO `hh_region` VALUES (220000, '吉林省', 100000, '吉林', 1, '', '', '125.3245', '43.886841', 'Jilin', '1', 0);
INSERT INTO `hh_region` VALUES (220100, '长春市', 220000, '长春', 2, '0431', '130022', '125.3245', '43.886841', 'Changchun', '1', 0);
INSERT INTO `hh_region` VALUES (220102, '南关区', 220100, '南关', 3, '0431', '130022', '125.35035', '43.86401', 'Nanguan', '1', 0);
INSERT INTO `hh_region` VALUES (220103, '宽城区', 220100, '宽城', 3, '0431', '130051', '125.32635', '43.90182', 'Kuancheng', '1', 0);
INSERT INTO `hh_region` VALUES (220104, '朝阳区', 220100, '朝阳', 3, '0431', '130012', '125.2883', '43.83339', 'Chaoyang', '1', 0);
INSERT INTO `hh_region` VALUES (220105, '二道区', 220100, '二道', 3, '0431', '130031', '125.37429', '43.86501', 'Erdao', '1', 0);
INSERT INTO `hh_region` VALUES (220106, '绿园区', 220100, '绿园', 3, '0431', '130062', '125.25582', '43.88045', 'Lvyuan', '1', 0);
INSERT INTO `hh_region` VALUES (220112, '双阳区', 220100, '双阳', 3, '0431', '130600', '125.65631', '43.52803', 'Shuangyang', '1', 0);
INSERT INTO `hh_region` VALUES (220113, '九台区', 220100, '九台', 3, '0431', '130500', '125.8395', '44.15163', 'Jiutai', '1', 0);
INSERT INTO `hh_region` VALUES (220122, '农安县', 220100, '农安', 3, '0431', '130200', '125.18481', '44.43265', 'Nong\'an', '1', 0);
INSERT INTO `hh_region` VALUES (220182, '榆树市', 220100, '榆树', 3, '0431', '130400', '126.55688', '44.82523', 'Yushu', '1', 0);
INSERT INTO `hh_region` VALUES (220183, '德惠市', 220100, '德惠', 3, '0431', '130300', '125.70538', '44.53719', 'Dehui', '1', 0);
INSERT INTO `hh_region` VALUES (220200, '吉林市', 220000, '吉林', 2, '0432', '132011', '126.55302', '43.843577', 'Jilin', '1', 0);
INSERT INTO `hh_region` VALUES (220202, '昌邑区', 220200, '昌邑', 3, '0432', '132002', '126.57424', '43.88183', 'Changyi', '1', 0);
INSERT INTO `hh_region` VALUES (220203, '龙潭区', 220200, '龙潭', 3, '0432', '132021', '126.56213', '43.91054', 'Longtan', '1', 0);
INSERT INTO `hh_region` VALUES (220204, '船营区', 220200, '船营', 3, '0432', '132011', '126.54096', '43.83344', 'Chuanying', '1', 0);
INSERT INTO `hh_region` VALUES (220211, '丰满区', 220200, '丰满', 3, '0432', '132013', '126.56237', '43.82236', 'Fengman', '1', 0);
INSERT INTO `hh_region` VALUES (220221, '永吉县', 220200, '永吉', 3, '0432', '132200', '126.4963', '43.67197', 'Yongji', '1', 0);
INSERT INTO `hh_region` VALUES (220281, '蛟河市', 220200, '蛟河', 3, '0432', '132500', '127.34426', '43.72696', 'Jiaohe', '1', 0);
INSERT INTO `hh_region` VALUES (220282, '桦甸市', 220200, '桦甸', 3, '0432', '132400', '126.74624', '42.97206', 'Huadian', '1', 0);
INSERT INTO `hh_region` VALUES (220283, '舒兰市', 220200, '舒兰', 3, '0432', '132600', '126.9653', '44.40582', 'Shulan', '1', 0);
INSERT INTO `hh_region` VALUES (220284, '磐石市', 220200, '磐石', 3, '0432', '132300', '126.0625', '42.94628', 'Panshi', '1', 0);
INSERT INTO `hh_region` VALUES (220300, '四平市', 220000, '四平', 2, '0434', '136000', '124.370785', '43.170344', 'Siping', '1', 0);
INSERT INTO `hh_region` VALUES (220302, '铁西区', 220300, '铁西', 3, '0434', '136000', '124.37369', '43.17456', 'Tiexi', '1', 0);
INSERT INTO `hh_region` VALUES (220303, '铁东区', 220300, '铁东', 3, '0434', '136001', '124.40976', '43.16241', 'Tiedong', '1', 0);
INSERT INTO `hh_region` VALUES (220322, '梨树县', 220300, '梨树', 3, '0434', '136500', '124.33563', '43.30717', 'Lishu', '1', 0);
INSERT INTO `hh_region` VALUES (220323, '伊通满族自治县', 220300, '伊通', 3, '0434', '130700', '125.30596', '43.34434', 'Yitong', '1', 0);
INSERT INTO `hh_region` VALUES (220381, '公主岭市', 220300, '公主岭', 3, '0434', '136100', '124.82266', '43.50453', 'Gongzhuling', '1', 0);
INSERT INTO `hh_region` VALUES (220382, '双辽市', 220300, '双辽', 3, '0434', '136400', '123.50106', '43.52099', 'Shuangliao', '1', 0);
INSERT INTO `hh_region` VALUES (220400, '辽源市', 220000, '辽源', 2, '0437', '136200', '125.145349', '42.902692', 'Liaoyuan', '1', 0);
INSERT INTO `hh_region` VALUES (220402, '龙山区', 220400, '龙山', 3, '0437', '136200', '125.13641', '42.89714', 'Longshan', '1', 0);
INSERT INTO `hh_region` VALUES (220403, '西安区', 220400, '西安', 3, '0437', '136201', '125.14904', '42.927', 'Xi\'an', '1', 0);
INSERT INTO `hh_region` VALUES (220421, '东丰县', 220400, '东丰', 3, '0437', '136300', '125.53244', '42.6783', 'Dongfeng', '1', 0);
INSERT INTO `hh_region` VALUES (220422, '东辽县', 220400, '东辽', 3, '0437', '136600', '124.98596', '42.92492', 'Dongliao', '1', 0);
INSERT INTO `hh_region` VALUES (220500, '通化市', 220000, '通化', 2, '0435', '134001', '125.936501', '41.721177', 'Tonghua', '1', 0);
INSERT INTO `hh_region` VALUES (220502, '东昌区', 220500, '东昌', 3, '0435', '134001', '125.9551', '41.72849', 'Dongchang', '1', 0);
INSERT INTO `hh_region` VALUES (220503, '二道江区', 220500, '二道江', 3, '0435', '134003', '126.04257', '41.7741', 'Erdaojiang', '1', 0);
INSERT INTO `hh_region` VALUES (220521, '通化县', 220500, '通化', 3, '0435', '134100', '125.75936', '41.67928', 'Tonghua', '1', 0);
INSERT INTO `hh_region` VALUES (220523, '辉南县', 220500, '辉南', 3, '0435', '135100', '126.04684', '42.68497', 'Huinan', '1', 0);
INSERT INTO `hh_region` VALUES (220524, '柳河县', 220500, '柳河', 3, '0435', '135300', '125.74475', '42.28468', 'Liuhe', '1', 0);
INSERT INTO `hh_region` VALUES (220581, '梅河口市', 220500, '梅河口', 3, '0435', '135000', '125.71041', '42.53828', 'Meihekou', '1', 0);
INSERT INTO `hh_region` VALUES (220582, '集安市', 220500, '集安', 3, '0435', '134200', '126.18829', '41.12268', 'Ji\'an', '1', 0);
INSERT INTO `hh_region` VALUES (220600, '白山市', 220000, '白山', 2, '0439', '134300', '126.427839', '41.942505', 'Baishan', '1', 0);
INSERT INTO `hh_region` VALUES (220602, '浑江区', 220600, '浑江', 3, '0439', '134300', '126.422342', '41.945656', 'Hunjiang', '1', 0);
INSERT INTO `hh_region` VALUES (220605, '江源区', 220600, '江源', 3, '0439', '134700', '126.59079', '42.05664', 'Jiangyuan', '1', 0);
INSERT INTO `hh_region` VALUES (220621, '抚松县', 220600, '抚松', 3, '0439', '134500', '127.2803', '42.34198', 'Fusong', '1', 0);
INSERT INTO `hh_region` VALUES (220622, '靖宇县', 220600, '靖宇', 3, '0439', '135200', '126.81308', '42.38863', 'Jingyu', '1', 0);
INSERT INTO `hh_region` VALUES (220623, '长白朝鲜族自治县', 220600, '长白', 3, '0439', '134400', '128.20047', '41.41996', 'Changbai', '1', 0);
INSERT INTO `hh_region` VALUES (220681, '临江市', 220600, '临江', 3, '0439', '134600', '126.91751', '41.81142', 'Linjiang', '1', 0);
INSERT INTO `hh_region` VALUES (220700, '松原市', 220000, '松原', 2, '0438', '138000', '124.823608', '45.118243', 'Songyuan', '1', 0);
INSERT INTO `hh_region` VALUES (220702, '宁江区', 220700, '宁江', 3, '0438', '138000', '124.81689', '45.17175', 'Ningjiang', '1', 0);
INSERT INTO `hh_region` VALUES (220721, '前郭尔罗斯蒙古族自治县', 220700, '前郭尔罗斯', 3, '0438', '138000', '124.82351', '45.11726', 'Qianguoerluosi', '1', 0);
INSERT INTO `hh_region` VALUES (220722, '长岭县', 220700, '长岭', 3, '0438', '131500', '123.96725', '44.27581', 'Changling', '1', 0);
INSERT INTO `hh_region` VALUES (220723, '乾安县', 220700, '乾安', 3, '0438', '131400', '124.02737', '45.01068', 'Qian\'an', '1', 0);
INSERT INTO `hh_region` VALUES (220781, '扶余市', 220700, '扶余', 3, '0438', '131200', '126.042758', '44.986199', 'Fuyu', '1', 0);
INSERT INTO `hh_region` VALUES (220800, '白城市', 220000, '白城', 2, '0436', '137000', '122.841114', '45.619026', 'Baicheng', '1', 0);
INSERT INTO `hh_region` VALUES (220802, '洮北区', 220800, '洮北', 3, '0436', '137000', '122.85104', '45.62167', 'Taobei', '1', 0);
INSERT INTO `hh_region` VALUES (220821, '镇赉县', 220800, '镇赉', 3, '0436', '137300', '123.19924', '45.84779', 'Zhenlai', '1', 0);
INSERT INTO `hh_region` VALUES (220822, '通榆县', 220800, '通榆', 3, '0436', '137200', '123.08761', '44.81388', 'Tongyu', '1', 0);
INSERT INTO `hh_region` VALUES (220881, '洮南市', 220800, '洮南', 3, '0436', '137100', '122.78772', '45.33502', 'Taonan', '1', 0);
INSERT INTO `hh_region` VALUES (220882, '大安市', 220800, '大安', 3, '0436', '131300', '124.29519', '45.50846', 'Da\'an', '1', 0);
INSERT INTO `hh_region` VALUES (222400, '延边朝鲜族自治州', 220000, '延边', 2, '0433', '133000', '129.513228', '42.904823', 'Yanbian', '1', 0);
INSERT INTO `hh_region` VALUES (222401, '延吉市', 222400, '延吉', 3, '0433', '133000', '129.51357', '42.90682', 'Yanji', '1', 0);
INSERT INTO `hh_region` VALUES (222402, '图们市', 222400, '图们', 3, '0433', '133100', '129.84381', '42.96801', 'Tumen', '1', 0);
INSERT INTO `hh_region` VALUES (222403, '敦化市', 222400, '敦化', 3, '0433', '133700', '128.23242', '43.37304', 'Dunhua', '1', 0);
INSERT INTO `hh_region` VALUES (222404, '珲春市', 222400, '珲春', 3, '0433', '133300', '130.36572', '42.86242', 'Hunchun', '1', 0);
INSERT INTO `hh_region` VALUES (222405, '龙井市', 222400, '龙井', 3, '0433', '133400', '129.42584', '42.76804', 'Longjing', '1', 0);
INSERT INTO `hh_region` VALUES (222406, '和龙市', 222400, '和龙', 3, '0433', '133500', '129.01077', '42.5464', 'Helong', '1', 0);
INSERT INTO `hh_region` VALUES (222424, '汪清县', 222400, '汪清', 3, '0433', '133200', '129.77121', '43.31278', 'Wangqing', '1', 0);
INSERT INTO `hh_region` VALUES (222426, '安图县', 222400, '安图', 3, '0433', '133600', '128.90625', '43.11533', 'Antu', '1', 0);
INSERT INTO `hh_region` VALUES (230000, '黑龙江省', 100000, '黑龙江', 1, '', '', '126.642464', '45.756967', 'Heilongjiang', '1', 0);
INSERT INTO `hh_region` VALUES (230100, '哈尔滨市', 230000, '哈尔滨', 2, '0451', '150010', '126.642464', '45.756967', 'Harbin', '1', 0);
INSERT INTO `hh_region` VALUES (230102, '道里区', 230100, '道里', 3, '0451', '150010', '126.61705', '45.75586', 'Daoli', '1', 0);
INSERT INTO `hh_region` VALUES (230103, '南岗区', 230100, '南岗', 3, '0451', '150006', '126.66854', '45.75996', 'Nangang', '1', 0);
INSERT INTO `hh_region` VALUES (230104, '道外区', 230100, '道外', 3, '0451', '150020', '126.64938', '45.79187', 'Daowai', '1', 0);
INSERT INTO `hh_region` VALUES (230108, '平房区', 230100, '平房', 3, '0451', '150060', '126.63729', '45.59777', 'Pingfang', '1', 0);
INSERT INTO `hh_region` VALUES (230109, '松北区', 230100, '松北', 3, '0451', '150028', '126.56276', '45.80831', 'Songbei', '1', 0);
INSERT INTO `hh_region` VALUES (230110, '香坊区', 230100, '香坊', 3, '0451', '150036', '126.67968', '45.72383', 'Xiangfang', '1', 0);
INSERT INTO `hh_region` VALUES (230111, '呼兰区', 230100, '呼兰', 3, '0451', '150500', '126.58792', '45.88895', 'Hulan', '1', 0);
INSERT INTO `hh_region` VALUES (230112, '阿城区', 230100, '阿城', 3, '0451', '150300', '126.97525', '45.54144', 'A\'cheng', '1', 0);
INSERT INTO `hh_region` VALUES (230113, '双城区', 230100, '双城', 3, '0451', '150100', '126.308784', '45.377942', 'Shuangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (230123, '依兰县', 230100, '依兰', 3, '0451', '154800', '129.56817', '46.3247', 'Yilan', '1', 0);
INSERT INTO `hh_region` VALUES (230124, '方正县', 230100, '方正', 3, '0451', '150800', '128.82952', '45.85162', 'Fangzheng', '1', 0);
INSERT INTO `hh_region` VALUES (230125, '宾县', 230100, '宾县', 3, '0451', '150400', '127.48675', '45.75504', 'Binxian', '1', 0);
INSERT INTO `hh_region` VALUES (230126, '巴彦县', 230100, '巴彦', 3, '0451', '151800', '127.40799', '46.08148', 'Bayan', '1', 0);
INSERT INTO `hh_region` VALUES (230127, '木兰县', 230100, '木兰', 3, '0451', '151900', '128.0448', '45.94944', 'Mulan', '1', 0);
INSERT INTO `hh_region` VALUES (230128, '通河县', 230100, '通河', 3, '0451', '150900', '128.74603', '45.99007', 'Tonghe', '1', 0);
INSERT INTO `hh_region` VALUES (230129, '延寿县', 230100, '延寿', 3, '0451', '150700', '128.33419', '45.4554', 'Yanshou', '1', 0);
INSERT INTO `hh_region` VALUES (230183, '尚志市', 230100, '尚志', 3, '0451', '150600', '127.96191', '45.21736', 'Shangzhi', '1', 0);
INSERT INTO `hh_region` VALUES (230184, '五常市', 230100, '五常', 3, '0451', '150200', '127.16751', '44.93184', 'Wuchang', '1', 0);
INSERT INTO `hh_region` VALUES (230200, '齐齐哈尔市', 230000, '齐齐哈尔', 2, '0452', '161005', '123.953486', '47.348079', 'Qiqihar', '1', 0);
INSERT INTO `hh_region` VALUES (230202, '龙沙区', 230200, '龙沙', 3, '0452', '161000', '123.95752', '47.31776', 'Longsha', '1', 0);
INSERT INTO `hh_region` VALUES (230203, '建华区', 230200, '建华', 3, '0452', '161006', '124.0133', '47.36718', 'Jianhua', '1', 0);
INSERT INTO `hh_region` VALUES (230204, '铁锋区', 230200, '铁锋', 3, '0452', '161000', '123.97821', '47.34075', 'Tiefeng', '1', 0);
INSERT INTO `hh_region` VALUES (230205, '昂昂溪区', 230200, '昂昂溪', 3, '0452', '161031', '123.82229', '47.15513', 'Angangxi', '1', 0);
INSERT INTO `hh_region` VALUES (230206, '富拉尔基区', 230200, '富拉尔基', 3, '0452', '161041', '123.62918', '47.20884', 'Fulaerji', '1', 0);
INSERT INTO `hh_region` VALUES (230207, '碾子山区', 230200, '碾子山', 3, '0452', '161046', '122.88183', '47.51662', 'Nianzishan', '1', 0);
INSERT INTO `hh_region` VALUES (230208, '梅里斯达斡尔族区', 230200, '梅里斯', 3, '0452', '161021', '123.75274', '47.30946', 'Meilisi', '1', 0);
INSERT INTO `hh_region` VALUES (230221, '龙江县', 230200, '龙江', 3, '0452', '161100', '123.20532', '47.33868', 'Longjiang', '1', 0);
INSERT INTO `hh_region` VALUES (230223, '依安县', 230200, '依安', 3, '0452', '161500', '125.30896', '47.8931', 'Yi\'an', '1', 0);
INSERT INTO `hh_region` VALUES (230224, '泰来县', 230200, '泰来', 3, '0452', '162400', '123.42285', '46.39386', 'Tailai', '1', 0);
INSERT INTO `hh_region` VALUES (230225, '甘南县', 230200, '甘南', 3, '0452', '162100', '123.50317', '47.92437', 'Gannan', '1', 0);
INSERT INTO `hh_region` VALUES (230227, '富裕县', 230200, '富裕', 3, '0452', '161200', '124.47457', '47.77431', 'Fuyu', '1', 0);
INSERT INTO `hh_region` VALUES (230229, '克山县', 230200, '克山', 3, '0452', '161600', '125.87396', '48.03265', 'Keshan', '1', 0);
INSERT INTO `hh_region` VALUES (230230, '克东县', 230200, '克东', 3, '0452', '164800', '126.24917', '48.03828', 'Kedong', '1', 0);
INSERT INTO `hh_region` VALUES (230231, '拜泉县', 230200, '拜泉', 3, '0452', '164700', '126.09167', '47.60817', 'Baiquan', '1', 0);
INSERT INTO `hh_region` VALUES (230281, '讷河市', 230200, '讷河', 3, '0452', '161300', '124.87713', '48.48388', 'Nehe', '1', 0);
INSERT INTO `hh_region` VALUES (230300, '鸡西市', 230000, '鸡西', 2, '0467', '158100', '130.975966', '45.300046', 'Jixi', '1', 0);
INSERT INTO `hh_region` VALUES (230302, '鸡冠区', 230300, '鸡冠', 3, '0467', '158100', '130.98139', '45.30396', 'Jiguan', '1', 0);
INSERT INTO `hh_region` VALUES (230303, '恒山区', 230300, '恒山', 3, '0467', '158130', '130.90493', '45.21071', 'Hengshan', '1', 0);
INSERT INTO `hh_region` VALUES (230304, '滴道区', 230300, '滴道', 3, '0467', '158150', '130.84841', '45.35109', 'Didao', '1', 0);
INSERT INTO `hh_region` VALUES (230305, '梨树区', 230300, '梨树', 3, '0467', '158160', '130.69848', '45.09037', 'Lishu', '1', 0);
INSERT INTO `hh_region` VALUES (230306, '城子河区', 230300, '城子河', 3, '0467', '158170', '131.01132', '45.33689', 'Chengzihe', '1', 0);
INSERT INTO `hh_region` VALUES (230307, '麻山区', 230300, '麻山', 3, '0467', '158180', '130.47811', '45.21209', 'Mashan', '1', 0);
INSERT INTO `hh_region` VALUES (230321, '鸡东县', 230300, '鸡东', 3, '0467', '158200', '131.12423', '45.26025', 'Jidong', '1', 0);
INSERT INTO `hh_region` VALUES (230381, '虎林市', 230300, '虎林', 3, '0467', '158400', '132.93679', '45.76291', 'Hulin', '1', 0);
INSERT INTO `hh_region` VALUES (230382, '密山市', 230300, '密山', 3, '0467', '158300', '131.84625', '45.5297', 'Mishan', '1', 0);
INSERT INTO `hh_region` VALUES (230400, '鹤岗市', 230000, '鹤岗', 2, '0468', '154100', '130.277487', '47.332085', 'Hegang', '1', 0);
INSERT INTO `hh_region` VALUES (230402, '向阳区', 230400, '向阳', 3, '0468', '154100', '130.2943', '47.34247', 'Xiangyang', '1', 0);
INSERT INTO `hh_region` VALUES (230403, '工农区', 230400, '工农', 3, '0468', '154101', '130.27468', '47.31869', 'Gongnong', '1', 0);
INSERT INTO `hh_region` VALUES (230404, '南山区', 230400, '南山', 3, '0468', '154104', '130.27676', '47.31404', 'Nanshan', '1', 0);
INSERT INTO `hh_region` VALUES (230405, '兴安区', 230400, '兴安', 3, '0468', '154102', '130.23965', '47.2526', 'Xing\'an', '1', 0);
INSERT INTO `hh_region` VALUES (230406, '东山区', 230400, '东山', 3, '0468', '154106', '130.31706', '47.33853', 'Dongshan', '1', 0);
INSERT INTO `hh_region` VALUES (230407, '兴山区', 230400, '兴山', 3, '0468', '154105', '130.29271', '47.35776', 'Xingshan', '1', 0);
INSERT INTO `hh_region` VALUES (230421, '萝北县', 230400, '萝北', 3, '0468', '154200', '130.83346', '47.57959', 'Luobei', '1', 0);
INSERT INTO `hh_region` VALUES (230422, '绥滨县', 230400, '绥滨', 3, '0468', '156200', '131.86029', '47.2903', 'Suibin', '1', 0);
INSERT INTO `hh_region` VALUES (230500, '双鸭山市', 230000, '双鸭山', 2, '0469', '155100', '131.157304', '46.643442', 'Shuangyashan', '1', 0);
INSERT INTO `hh_region` VALUES (230502, '尖山区', 230500, '尖山', 3, '0469', '155100', '131.15841', '46.64635', 'Jianshan', '1', 0);
INSERT INTO `hh_region` VALUES (230503, '岭东区', 230500, '岭东', 3, '0469', '155120', '131.16473', '46.59043', 'Lingdong', '1', 0);
INSERT INTO `hh_region` VALUES (230505, '四方台区', 230500, '四方台', 3, '0469', '155130', '131.33593', '46.59499', 'Sifangtai', '1', 0);
INSERT INTO `hh_region` VALUES (230506, '宝山区', 230500, '宝山', 3, '0469', '155131', '131.4016', '46.57718', 'Baoshan', '1', 0);
INSERT INTO `hh_region` VALUES (230521, '集贤县', 230500, '集贤', 3, '0469', '155900', '131.14053', '46.72678', 'Jixian', '1', 0);
INSERT INTO `hh_region` VALUES (230522, '友谊县', 230500, '友谊', 3, '0469', '155800', '131.80789', '46.76739', 'Youyi', '1', 0);
INSERT INTO `hh_region` VALUES (230523, '宝清县', 230500, '宝清', 3, '0469', '155600', '132.19695', '46.32716', 'Baoqing', '1', 0);
INSERT INTO `hh_region` VALUES (230524, '饶河县', 230500, '饶河', 3, '0469', '155700', '134.01986', '46.79899', 'Raohe', '1', 0);
INSERT INTO `hh_region` VALUES (230600, '大庆市', 230000, '大庆', 2, '0459', '163000', '125.11272', '46.590734', 'Daqing', '1', 0);
INSERT INTO `hh_region` VALUES (230602, '萨尔图区', 230600, '萨尔图', 3, '0459', '163001', '125.08792', '46.59359', 'Saertu', '1', 0);
INSERT INTO `hh_region` VALUES (230603, '龙凤区', 230600, '龙凤', 3, '0459', '163711', '125.11657', '46.53273', 'Longfeng', '1', 0);
INSERT INTO `hh_region` VALUES (230604, '让胡路区', 230600, '让胡路', 3, '0459', '163712', '124.87075', '46.6522', 'Ranghulu', '1', 0);
INSERT INTO `hh_region` VALUES (230605, '红岗区', 230600, '红岗', 3, '0459', '163511', '124.89248', '46.40128', 'Honggang', '1', 0);
INSERT INTO `hh_region` VALUES (230606, '大同区', 230600, '大同', 3, '0459', '163515', '124.81591', '46.03295', 'Datong', '1', 0);
INSERT INTO `hh_region` VALUES (230621, '肇州县', 230600, '肇州', 3, '0459', '166400', '125.27059', '45.70414', 'Zhaozhou', '1', 0);
INSERT INTO `hh_region` VALUES (230622, '肇源县', 230600, '肇源', 3, '0459', '166500', '125.08456', '45.52032', 'Zhaoyuan', '1', 0);
INSERT INTO `hh_region` VALUES (230623, '林甸县', 230600, '林甸', 3, '0459', '166300', '124.87564', '47.18601', 'Lindian', '1', 0);
INSERT INTO `hh_region` VALUES (230624, '杜尔伯特蒙古族自治县', 230600, '杜尔伯特', 3, '0459', '166200', '124.44937', '46.86507', 'Duerbote', '1', 0);
INSERT INTO `hh_region` VALUES (230700, '伊春市', 230000, '伊春', 2, '0458', '153000', '128.899396', '47.724775', 'Yichun', '1', 0);
INSERT INTO `hh_region` VALUES (230702, '伊春区', 230700, '伊春', 3, '0458', '153000', '128.90752', '47.728', 'Yichun', '1', 0);
INSERT INTO `hh_region` VALUES (230703, '南岔区', 230700, '南岔', 3, '0458', '153100', '129.28362', '47.13897', 'Nancha', '1', 0);
INSERT INTO `hh_region` VALUES (230704, '友好区', 230700, '友好', 3, '0458', '153031', '128.84039', '47.85371', 'Youhao', '1', 0);
INSERT INTO `hh_region` VALUES (230705, '西林区', 230700, '西林', 3, '0458', '153025', '129.31201', '47.48103', 'Xilin', '1', 0);
INSERT INTO `hh_region` VALUES (230706, '翠峦区', 230700, '翠峦', 3, '0458', '153013', '128.66729', '47.72503', 'Cuiluan', '1', 0);
INSERT INTO `hh_region` VALUES (230707, '新青区', 230700, '新青', 3, '0458', '153036', '129.53653', '48.29067', 'Xinqing', '1', 0);
INSERT INTO `hh_region` VALUES (230708, '美溪区', 230700, '美溪', 3, '0458', '153021', '129.13708', '47.63513', 'Meixi', '1', 0);
INSERT INTO `hh_region` VALUES (230709, '金山屯区', 230700, '金山屯', 3, '0458', '153026', '129.43768', '47.41349', 'Jinshantun', '1', 0);
INSERT INTO `hh_region` VALUES (230710, '五营区', 230700, '五营', 3, '0458', '153033', '129.24545', '48.10791', 'Wuying', '1', 0);
INSERT INTO `hh_region` VALUES (230711, '乌马河区', 230700, '乌马河', 3, '0458', '153011', '128.79672', '47.728', 'Wumahe', '1', 0);
INSERT INTO `hh_region` VALUES (230712, '汤旺河区', 230700, '汤旺河', 3, '0458', '153037', '129.57226', '48.45182', 'Tangwanghe', '1', 0);
INSERT INTO `hh_region` VALUES (230713, '带岭区', 230700, '带岭', 3, '0458', '153106', '129.02352', '47.02553', 'Dailing', '1', 0);
INSERT INTO `hh_region` VALUES (230714, '乌伊岭区', 230700, '乌伊岭', 3, '0458', '153038', '129.43981', '48.59602', 'Wuyiling', '1', 0);
INSERT INTO `hh_region` VALUES (230715, '红星区', 230700, '红星', 3, '0458', '153035', '129.3887', '48.23944', 'Hongxing', '1', 0);
INSERT INTO `hh_region` VALUES (230716, '上甘岭区', 230700, '上甘岭', 3, '0458', '153032', '129.02447', '47.97522', 'Shangganling', '1', 0);
INSERT INTO `hh_region` VALUES (230722, '嘉荫县', 230700, '嘉荫', 3, '0458', '153200', '130.39825', '48.8917', 'Jiayin', '1', 0);
INSERT INTO `hh_region` VALUES (230781, '铁力市', 230700, '铁力', 3, '0458', '152500', '128.0317', '46.98571', 'Tieli', '1', 0);
INSERT INTO `hh_region` VALUES (230800, '佳木斯市', 230000, '佳木斯', 2, '0454', '154002', '130.361634', '46.809606', 'Jiamusi', '1', 0);
INSERT INTO `hh_region` VALUES (230803, '向阳区', 230800, '向阳', 3, '0454', '154002', '130.36519', '46.80778', 'Xiangyang', '1', 0);
INSERT INTO `hh_region` VALUES (230804, '前进区', 230800, '前进', 3, '0454', '154002', '130.37497', '46.81401', 'Qianjin', '1', 0);
INSERT INTO `hh_region` VALUES (230805, '东风区', 230800, '东风', 3, '0454', '154005', '130.40366', '46.82257', 'Dongfeng', '1', 0);
INSERT INTO `hh_region` VALUES (230811, '郊区', 230800, '郊区', 3, '0454', '154004', '130.32731', '46.80958', 'Jiaoqu', '1', 0);
INSERT INTO `hh_region` VALUES (230822, '桦南县', 230800, '桦南', 3, '0454', '154400', '130.55361', '46.23921', 'Huanan', '1', 0);
INSERT INTO `hh_region` VALUES (230826, '桦川县', 230800, '桦川', 3, '0454', '154300', '130.71893', '47.02297', 'Huachuan', '1', 0);
INSERT INTO `hh_region` VALUES (230828, '汤原县', 230800, '汤原', 3, '0454', '154700', '129.90966', '46.72755', 'Tangyuan', '1', 0);
INSERT INTO `hh_region` VALUES (230833, '抚远县', 230800, '抚远', 3, '0454', '156500', '134.29595', '48.36794', 'Fuyuan', '1', 0);
INSERT INTO `hh_region` VALUES (230881, '同江市', 230800, '同江', 3, '0454', '156400', '132.51095', '47.64211', 'Tongjiang', '1', 0);
INSERT INTO `hh_region` VALUES (230882, '富锦市', 230800, '富锦', 3, '0454', '156100', '132.03707', '47.25132', 'Fujin', '1', 0);
INSERT INTO `hh_region` VALUES (230900, '七台河市', 230000, '七台河', 2, '0464', '154600', '131.015584', '45.771266', 'Qitaihe', '1', 0);
INSERT INTO `hh_region` VALUES (230902, '新兴区', 230900, '新兴', 3, '0464', '154604', '130.93212', '45.81624', 'Xinxing', '1', 0);
INSERT INTO `hh_region` VALUES (230903, '桃山区', 230900, '桃山', 3, '0464', '154600', '131.01786', '45.76782', 'Taoshan', '1', 0);
INSERT INTO `hh_region` VALUES (230904, '茄子河区', 230900, '茄子河', 3, '0464', '154622', '131.06807', '45.78519', 'Qiezihe', '1', 0);
INSERT INTO `hh_region` VALUES (230921, '勃利县', 230900, '勃利', 3, '0464', '154500', '130.59179', '45.755', 'Boli', '1', 0);
INSERT INTO `hh_region` VALUES (231000, '牡丹江市', 230000, '牡丹江', 2, '0453', '157000', '129.618602', '44.582962', 'Mudanjiang', '1', 0);
INSERT INTO `hh_region` VALUES (231002, '东安区', 231000, '东安', 3, '0453', '157000', '129.62665', '44.58133', 'Dong\'an', '1', 0);
INSERT INTO `hh_region` VALUES (231003, '阳明区', 231000, '阳明', 3, '0453', '157013', '129.63547', '44.59603', 'Yangming', '1', 0);
INSERT INTO `hh_region` VALUES (231004, '爱民区', 231000, '爱民', 3, '0453', '157009', '129.59077', '44.59648', 'Aimin', '1', 0);
INSERT INTO `hh_region` VALUES (231005, '西安区', 231000, '西安', 3, '0453', '157000', '129.61616', '44.57766', 'Xi\'an', '1', 0);
INSERT INTO `hh_region` VALUES (231024, '东宁县', 231000, '东宁', 3, '0453', '157200', '131.12793', '44.0661', 'Dongning', '1', 0);
INSERT INTO `hh_region` VALUES (231025, '林口县', 231000, '林口', 3, '0453', '157600', '130.28393', '45.27809', 'Linkou', '1', 0);
INSERT INTO `hh_region` VALUES (231081, '绥芬河市', 231000, '绥芬河', 3, '0453', '157300', '131.15139', '44.41249', 'Suifenhe', '1', 0);
INSERT INTO `hh_region` VALUES (231083, '海林市', 231000, '海林', 3, '0453', '157100', '129.38156', '44.59', 'Hailin', '1', 0);
INSERT INTO `hh_region` VALUES (231084, '宁安市', 231000, '宁安', 3, '0453', '157400', '129.48303', '44.34016', 'Ning\'an', '1', 0);
INSERT INTO `hh_region` VALUES (231085, '穆棱市', 231000, '穆棱', 3, '0453', '157500', '130.52465', '44.919', 'Muling', '1', 0);
INSERT INTO `hh_region` VALUES (231100, '黑河市', 230000, '黑河', 2, '0456', '164300', '127.499023', '50.249585', 'Heihe', '1', 0);
INSERT INTO `hh_region` VALUES (231102, '爱辉区', 231100, '爱辉', 3, '0456', '164300', '127.50074', '50.25202', 'Aihui', '1', 0);
INSERT INTO `hh_region` VALUES (231121, '嫩江县', 231100, '嫩江', 3, '0456', '161400', '125.22607', '49.17844', 'Nenjiang', '1', 0);
INSERT INTO `hh_region` VALUES (231123, '逊克县', 231100, '逊克', 3, '0456', '164400', '128.47882', '49.57983', 'Xunke', '1', 0);
INSERT INTO `hh_region` VALUES (231124, '孙吴县', 231100, '孙吴', 3, '0456', '164200', '127.33599', '49.42539', 'Sunwu', '1', 0);
INSERT INTO `hh_region` VALUES (231181, '北安市', 231100, '北安', 3, '0456', '164000', '126.48193', '48.23872', 'Bei\'an', '1', 0);
INSERT INTO `hh_region` VALUES (231182, '五大连池市', 231100, '五大连池', 3, '0456', '164100', '126.20294', '48.51507', 'Wudalianchi', '1', 0);
INSERT INTO `hh_region` VALUES (231200, '绥化市', 230000, '绥化', 2, '0455', '152000', '126.99293', '46.637393', 'Suihua', '1', 0);
INSERT INTO `hh_region` VALUES (231202, '北林区', 231200, '北林', 3, '0455', '152000', '126.98564', '46.63735', 'Beilin', '1', 0);
INSERT INTO `hh_region` VALUES (231221, '望奎县', 231200, '望奎', 3, '0455', '152100', '126.48187', '46.83079', 'Wangkui', '1', 0);
INSERT INTO `hh_region` VALUES (231222, '兰西县', 231200, '兰西', 3, '0455', '151500', '126.28994', '46.2525', 'Lanxi', '1', 0);
INSERT INTO `hh_region` VALUES (231223, '青冈县', 231200, '青冈', 3, '0455', '151600', '126.11325', '46.68534', 'Qinggang', '1', 0);
INSERT INTO `hh_region` VALUES (231224, '庆安县', 231200, '庆安', 3, '0455', '152400', '127.50753', '46.88016', 'Qing\'an', '1', 0);
INSERT INTO `hh_region` VALUES (231225, '明水县', 231200, '明水', 3, '0455', '151700', '125.90594', '47.17327', 'Mingshui', '1', 0);
INSERT INTO `hh_region` VALUES (231226, '绥棱县', 231200, '绥棱', 3, '0455', '152200', '127.11584', '47.24267', 'Suileng', '1', 0);
INSERT INTO `hh_region` VALUES (231281, '安达市', 231200, '安达', 3, '0455', '151400', '125.34375', '46.4177', 'Anda', '1', 0);
INSERT INTO `hh_region` VALUES (231282, '肇东市', 231200, '肇东', 3, '0455', '151100', '125.96243', '46.05131', 'Zhaodong', '1', 0);
INSERT INTO `hh_region` VALUES (231283, '海伦市', 231200, '海伦', 3, '0455', '152300', '126.9682', '47.46093', 'Hailun', '1', 0);
INSERT INTO `hh_region` VALUES (232700, '大兴安岭地区', 230000, '大兴安岭', 2, '0457', '165000', '124.711526', '52.335262', 'DaXingAnLing', '1', 0);
INSERT INTO `hh_region` VALUES (232701, '加格达奇区', 232700, '加格达奇', 3, '0457', '165000', '124.30954', '51.98144', 'Jiagedaqi', '1', 0);
INSERT INTO `hh_region` VALUES (232702, '新林区', 232700, '新林', 3, '0457', '165000', '124.397983', '51.67341', 'Xinlin', '1', 0);
INSERT INTO `hh_region` VALUES (232703, '松岭区', 232700, '松岭', 3, '0457', '165000', '124.189713', '51.985453', 'Songling', '1', 0);
INSERT INTO `hh_region` VALUES (232704, '呼中区', 232700, '呼中', 3, '0457', '165000', '123.60009', '52.03346', 'Huzhong', '1', 0);
INSERT INTO `hh_region` VALUES (232721, '呼玛县', 232700, '呼玛', 3, '0457', '165100', '126.66174', '51.73112', 'Huma', '1', 0);
INSERT INTO `hh_region` VALUES (232722, '塔河县', 232700, '塔河', 3, '0457', '165200', '124.70999', '52.33431', 'Tahe', '1', 0);
INSERT INTO `hh_region` VALUES (232723, '漠河县', 232700, '漠河', 3, '0457', '165300', '122.53759', '52.97003', 'Mohe', '1', 0);
INSERT INTO `hh_region` VALUES (310000, '上海', 100000, '上海', 1, '', '', '121.472644', '31.231706', 'Shanghai', '1', 0);
INSERT INTO `hh_region` VALUES (310100, '上海市', 310000, '上海', 2, '021', '200000', '121.472644', '31.231706', 'Shanghai', '1', 0);
INSERT INTO `hh_region` VALUES (310101, '黄浦区', 310100, '黄浦', 3, '021', '200001', '121.49295', '31.22337', 'Huangpu', '1', 0);
INSERT INTO `hh_region` VALUES (310104, '徐汇区', 310100, '徐汇', 3, '021', '200030', '121.43676', '31.18831', 'Xuhui', '1', 0);
INSERT INTO `hh_region` VALUES (310105, '长宁区', 310100, '长宁', 3, '021', '200050', '121.42462', '31.22036', 'Changning', '1', 0);
INSERT INTO `hh_region` VALUES (310106, '静安区', 310100, '静安', 3, '021', '200040', '121.4444', '31.22884', 'Jing\'an', '1', 0);
INSERT INTO `hh_region` VALUES (310107, '普陀区', 310100, '普陀', 3, '021', '200333', '121.39703', '31.24951', 'Putuo', '1', 0);
INSERT INTO `hh_region` VALUES (310108, '闸北区', 310100, '闸北', 3, '021', '200070', '121.44636', '31.28075', 'Zhabei', '1', 0);
INSERT INTO `hh_region` VALUES (310109, '虹口区', 310100, '虹口', 3, '021', '200086', '121.48162', '31.27788', 'Hongkou', '1', 0);
INSERT INTO `hh_region` VALUES (310110, '杨浦区', 310100, '杨浦', 3, '021', '200082', '121.526', '31.2595', 'Yangpu', '1', 0);
INSERT INTO `hh_region` VALUES (310112, '闵行区', 310100, '闵行', 3, '021', '201100', '121.38162', '31.11246', 'Minhang', '1', 0);
INSERT INTO `hh_region` VALUES (310113, '宝山区', 310100, '宝山', 3, '021', '201900', '121.4891', '31.4045', 'Baoshan', '1', 0);
INSERT INTO `hh_region` VALUES (310114, '嘉定区', 310100, '嘉定', 3, '021', '201800', '121.2655', '31.37473', 'Jiading', '1', 0);
INSERT INTO `hh_region` VALUES (310115, '浦东新区', 310100, '浦东', 3, '021', '200135', '121.5447', '31.22249', 'Pudong', '1', 0);
INSERT INTO `hh_region` VALUES (310116, '金山区', 310100, '金山', 3, '021', '200540', '121.34164', '30.74163', 'Jinshan', '1', 0);
INSERT INTO `hh_region` VALUES (310117, '松江区', 310100, '松江', 3, '021', '201600', '121.22879', '31.03222', 'Songjiang', '1', 0);
INSERT INTO `hh_region` VALUES (310118, '青浦区', 310100, '青浦', 3, '021', '201700', '121.12417', '31.14974', 'Qingpu', '1', 0);
INSERT INTO `hh_region` VALUES (310120, '奉贤区', 310100, '奉贤', 3, '021', '201400', '121.47412', '30.9179', 'Fengxian', '1', 0);
INSERT INTO `hh_region` VALUES (310230, '崇明县', 310100, '崇明', 3, '021', '202150', '121.39758', '31.62278', 'Chongming', '1', 0);
INSERT INTO `hh_region` VALUES (320000, '江苏省', 100000, '江苏', 1, '', '', '118.767413', '32.041544', 'Jiangsu', '1', 0);
INSERT INTO `hh_region` VALUES (320100, '南京市', 320000, '南京', 2, '025', '210008', '118.767413', '32.041544', 'Nanjing', '1', 0);
INSERT INTO `hh_region` VALUES (320102, '玄武区', 320100, '玄武', 3, '025', '210018', '118.79772', '32.04856', 'Xuanwu', '1', 0);
INSERT INTO `hh_region` VALUES (320104, '秦淮区', 320100, '秦淮', 3, '025', '210001', '118.79815', '32.01112', 'Qinhuai', '1', 0);
INSERT INTO `hh_region` VALUES (320105, '建邺区', 320100, '建邺', 3, '025', '210004', '118.76641', '32.03096', 'Jianye', '1', 0);
INSERT INTO `hh_region` VALUES (320106, '鼓楼区', 320100, '鼓楼', 3, '025', '210009', '118.76974', '32.06632', 'Gulou', '1', 0);
INSERT INTO `hh_region` VALUES (320111, '浦口区', 320100, '浦口', 3, '025', '211800', '118.62802', '32.05881', 'Pukou', '1', 0);
INSERT INTO `hh_region` VALUES (320113, '栖霞区', 320100, '栖霞', 3, '025', '210046', '118.88064', '32.11352', 'Qixia', '1', 0);
INSERT INTO `hh_region` VALUES (320114, '雨花台区', 320100, '雨花台', 3, '025', '210012', '118.7799', '31.99202', 'Yuhuatai', '1', 0);
INSERT INTO `hh_region` VALUES (320115, '江宁区', 320100, '江宁', 3, '025', '211100', '118.8399', '31.95263', 'Jiangning', '1', 0);
INSERT INTO `hh_region` VALUES (320116, '六合区', 320100, '六合', 3, '025', '211500', '118.8413', '32.34222', 'Luhe', '1', 0);
INSERT INTO `hh_region` VALUES (320117, '溧水区', 320100, '溧水', 3, '025', '211200', '119.028732', '31.653061', 'Lishui', '1', 0);
INSERT INTO `hh_region` VALUES (320118, '高淳区', 320100, '高淳', 3, '025', '211300', '118.87589', '31.327132', 'Gaochun', '1', 0);
INSERT INTO `hh_region` VALUES (320200, '无锡市', 320000, '无锡', 2, '0510', '214000', '120.301663', '31.574729', 'Wuxi', '1', 0);
INSERT INTO `hh_region` VALUES (320202, '崇安区', 320200, '崇安', 3, '0510', '214001', '120.29975', '31.58002', 'Chong\'an', '1', 0);
INSERT INTO `hh_region` VALUES (320203, '南长区', 320200, '南长', 3, '0510', '214021', '120.30873', '31.56359', 'Nanchang', '1', 0);
INSERT INTO `hh_region` VALUES (320204, '北塘区', 320200, '北塘', 3, '0510', '214044', '120.29405', '31.60592', 'Beitang', '1', 0);
INSERT INTO `hh_region` VALUES (320205, '锡山区', 320200, '锡山', 3, '0510', '214101', '120.35699', '31.5886', 'Xishan', '1', 0);
INSERT INTO `hh_region` VALUES (320206, '惠山区', 320200, '惠山', 3, '0510', '214174', '120.29849', '31.68088', 'Huishan', '1', 0);
INSERT INTO `hh_region` VALUES (320211, '滨湖区', 320200, '滨湖', 3, '0510', '214123', '120.29461', '31.52162', 'Binhu', '1', 0);
INSERT INTO `hh_region` VALUES (320281, '江阴市', 320200, '江阴', 3, '0510', '214431', '120.2853', '31.91996', 'Jiangyin', '1', 0);
INSERT INTO `hh_region` VALUES (320282, '宜兴市', 320200, '宜兴', 3, '0510', '214200', '119.82357', '31.33978', 'Yixing', '1', 0);
INSERT INTO `hh_region` VALUES (320300, '徐州市', 320000, '徐州', 2, '0516', '221003', '117.184811', '34.261792', 'Xuzhou', '1', 0);
INSERT INTO `hh_region` VALUES (320302, '鼓楼区', 320300, '鼓楼', 3, '0516', '221005', '117.18559', '34.28851', 'Gulou', '1', 0);
INSERT INTO `hh_region` VALUES (320303, '云龙区', 320300, '云龙', 3, '0516', '221007', '117.23053', '34.24895', 'Yunlong', '1', 0);
INSERT INTO `hh_region` VALUES (320305, '贾汪区', 320300, '贾汪', 3, '0516', '221003', '117.45346', '34.44264', 'Jiawang', '1', 0);
INSERT INTO `hh_region` VALUES (320311, '泉山区', 320300, '泉山', 3, '0516', '221006', '117.19378', '34.24418', 'Quanshan', '1', 0);
INSERT INTO `hh_region` VALUES (320312, '铜山区', 320300, '铜山', 3, '0516', '221106', '117.183894', '34.19288', 'Tongshan', '1', 0);
INSERT INTO `hh_region` VALUES (320321, '丰县', 320300, '丰县', 3, '0516', '221700', '116.59957', '34.69972', 'Fengxian', '1', 0);
INSERT INTO `hh_region` VALUES (320322, '沛县', 320300, '沛县', 3, '0516', '221600', '116.93743', '34.72163', 'Peixian', '1', 0);
INSERT INTO `hh_region` VALUES (320324, '睢宁县', 320300, '睢宁', 3, '0516', '221200', '117.94104', '33.91269', 'Suining', '1', 0);
INSERT INTO `hh_region` VALUES (320381, '新沂市', 320300, '新沂', 3, '0516', '221400', '118.35452', '34.36942', 'Xinyi', '1', 0);
INSERT INTO `hh_region` VALUES (320382, '邳州市', 320300, '邳州', 3, '0516', '221300', '117.95858', '34.33329', 'Pizhou', '1', 0);
INSERT INTO `hh_region` VALUES (320400, '常州市', 320000, '常州', 2, '0519', '213000', '119.946973', '31.772752', 'Changzhou', '1', 0);
INSERT INTO `hh_region` VALUES (320402, '天宁区', 320400, '天宁', 3, '0519', '213000', '119.95132', '31.75211', 'Tianning', '1', 0);
INSERT INTO `hh_region` VALUES (320404, '钟楼区', 320400, '钟楼', 3, '0519', '213023', '119.90178', '31.80221', 'Zhonglou', '1', 0);
INSERT INTO `hh_region` VALUES (320405, '戚墅堰区', 320400, '戚墅堰', 3, '0519', '213025', '120.06106', '31.71956', 'Qishuyan', '1', 0);
INSERT INTO `hh_region` VALUES (320411, '新北区', 320400, '新北', 3, '0519', '213022', '119.97131', '31.83046', 'Xinbei', '1', 0);
INSERT INTO `hh_region` VALUES (320412, '武进区', 320400, '武进', 3, '0519', '213100', '119.94244', '31.70086', 'Wujin', '1', 0);
INSERT INTO `hh_region` VALUES (320481, '溧阳市', 320400, '溧阳', 3, '0519', '213300', '119.4837', '31.41538', 'Liyang', '1', 0);
INSERT INTO `hh_region` VALUES (320482, '金坛市', 320400, '金坛', 3, '0519', '213200', '119.57757', '31.74043', 'Jintan', '1', 0);
INSERT INTO `hh_region` VALUES (320500, '苏州市', 320000, '苏州', 2, '0512', '215002', '120.619585', '31.299379', 'Suzhou', '1', 0);
INSERT INTO `hh_region` VALUES (320505, '虎丘区', 320500, '虎丘', 3, '0512', '215004', '120.57345', '31.2953', 'Huqiu', '1', 0);
INSERT INTO `hh_region` VALUES (320506, '吴中区', 320500, '吴中', 3, '0512', '215128', '120.63211', '31.26226', 'Wuzhong', '1', 0);
INSERT INTO `hh_region` VALUES (320507, '相城区', 320500, '相城', 3, '0512', '215131', '120.64239', '31.36889', 'Xiangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (320508, '姑苏区', 320500, '姑苏', 3, '0512', '215031', '120.619585', '31.299379', 'Gusu', '1', 0);
INSERT INTO `hh_region` VALUES (320509, '吴江区', 320500, '吴江', 3, '0512', '215200', '120.638317', '31.159815', 'Wujiang', '1', 0);
INSERT INTO `hh_region` VALUES (320581, '常熟市', 320500, '常熟', 3, '0512', '215500', '120.75225', '31.65374', 'Changshu', '1', 0);
INSERT INTO `hh_region` VALUES (320582, '张家港市', 320500, '张家港', 3, '0512', '215600', '120.55538', '31.87532', 'Zhangjiagang', '1', 0);
INSERT INTO `hh_region` VALUES (320583, '昆山市', 320500, '昆山', 3, '0512', '215300', '120.98074', '31.38464', 'Kunshan', '1', 0);
INSERT INTO `hh_region` VALUES (320585, '太仓市', 320500, '太仓', 3, '0512', '215400', '121.10891', '31.4497', 'Taicang', '1', 0);
INSERT INTO `hh_region` VALUES (320600, '南通市', 320000, '南通', 2, '0513', '226001', '120.864608', '32.016212', 'Nantong', '1', 0);
INSERT INTO `hh_region` VALUES (320602, '崇川区', 320600, '崇川', 3, '0513', '226001', '120.8573', '32.0098', 'Chongchuan', '1', 0);
INSERT INTO `hh_region` VALUES (320611, '港闸区', 320600, '港闸', 3, '0513', '226001', '120.81778', '32.03163', 'Gangzha', '1', 0);
INSERT INTO `hh_region` VALUES (320612, '通州区', 320600, '通州', 3, '0513', '226300', '121.07293', '32.0676', 'Tongzhou', '1', 0);
INSERT INTO `hh_region` VALUES (320621, '海安县', 320600, '海安', 3, '0513', '226600', '120.45852', '32.54514', 'Hai\'an', '1', 0);
INSERT INTO `hh_region` VALUES (320623, '如东县', 320600, '如东', 3, '0513', '226400', '121.18942', '32.31439', 'Rudong', '1', 0);
INSERT INTO `hh_region` VALUES (320681, '启东市', 320600, '启东', 3, '0513', '226200', '121.65985', '31.81083', 'Qidong', '1', 0);
INSERT INTO `hh_region` VALUES (320682, '如皋市', 320600, '如皋', 3, '0513', '226500', '120.55969', '32.37597', 'Rugao', '1', 0);
INSERT INTO `hh_region` VALUES (320684, '海门市', 320600, '海门', 3, '0513', '226100', '121.16995', '31.89422', 'Haimen', '1', 0);
INSERT INTO `hh_region` VALUES (320700, '连云港市', 320000, '连云港', 2, '0518', '222002', '119.178821', '34.600018', 'Lianyungang', '1', 0);
INSERT INTO `hh_region` VALUES (320703, '连云区', 320700, '连云', 3, '0518', '222042', '119.37304', '34.75293', 'Lianyun', '1', 0);
INSERT INTO `hh_region` VALUES (320706, '海州区', 320700, '海州', 3, '0518', '222003', '119.13128', '34.56986', 'Haizhou', '1', 0);
INSERT INTO `hh_region` VALUES (320707, '赣榆区', 320700, '赣榆', 3, '0518', '222100', '119.128774', '34.839154', 'Ganyu', '1', 0);
INSERT INTO `hh_region` VALUES (320722, '东海县', 320700, '东海', 3, '0518', '222300', '118.77145', '34.54215', 'Donghai', '1', 0);
INSERT INTO `hh_region` VALUES (320723, '灌云县', 320700, '灌云', 3, '0518', '222200', '119.23925', '34.28391', 'Guanyun', '1', 0);
INSERT INTO `hh_region` VALUES (320724, '灌南县', 320700, '灌南', 3, '0518', '222500', '119.35632', '34.09', 'Guannan', '1', 0);
INSERT INTO `hh_region` VALUES (320800, '淮安市', 320000, '淮安', 2, '0517', '223001', '119.021265', '33.597506', 'Huai\'an', '1', 0);
INSERT INTO `hh_region` VALUES (320802, '清河区', 320800, '清河', 3, '0517', '223001', '119.00778', '33.59949', 'Qinghe', '1', 0);
INSERT INTO `hh_region` VALUES (320803, '淮安区', 320800, '淮安', 3, '0517', '223200', '119.021265', '33.597506', 'Huai\'an', '1', 0);
INSERT INTO `hh_region` VALUES (320804, '淮阴区', 320800, '淮阴', 3, '0517', '223300', '119.03485', '33.63171', 'Huaiyin', '1', 0);
INSERT INTO `hh_region` VALUES (320811, '清浦区', 320800, '清浦', 3, '0517', '223002', '119.02648', '33.55232', 'Qingpu', '1', 0);
INSERT INTO `hh_region` VALUES (320826, '涟水县', 320800, '涟水', 3, '0517', '223400', '119.26083', '33.78094', 'Lianshui', '1', 0);
INSERT INTO `hh_region` VALUES (320829, '洪泽县', 320800, '洪泽', 3, '0517', '223100', '118.87344', '33.29429', 'Hongze', '1', 0);
INSERT INTO `hh_region` VALUES (320830, '盱眙县', 320800, '盱眙', 3, '0517', '211700', '118.54495', '33.01086', 'Xuyi', '1', 0);
INSERT INTO `hh_region` VALUES (320831, '金湖县', 320800, '金湖', 3, '0517', '211600', '119.02307', '33.02219', 'Jinhu', '1', 0);
INSERT INTO `hh_region` VALUES (320900, '盐城市', 320000, '盐城', 2, '0515', '224005', '120.139998', '33.377631', 'Yancheng', '1', 0);
INSERT INTO `hh_region` VALUES (320902, '亭湖区', 320900, '亭湖', 3, '0515', '224005', '120.16583', '33.37825', 'Tinghu', '1', 0);
INSERT INTO `hh_region` VALUES (320903, '盐都区', 320900, '盐都', 3, '0515', '224055', '120.15441', '33.3373', 'Yandu', '1', 0);
INSERT INTO `hh_region` VALUES (320921, '响水县', 320900, '响水', 3, '0515', '224600', '119.56985', '34.20513', 'Xiangshui', '1', 0);
INSERT INTO `hh_region` VALUES (320922, '滨海县', 320900, '滨海', 3, '0515', '224500', '119.82058', '33.98972', 'Binhai', '1', 0);
INSERT INTO `hh_region` VALUES (320923, '阜宁县', 320900, '阜宁', 3, '0515', '224400', '119.80175', '33.78228', 'Funing', '1', 0);
INSERT INTO `hh_region` VALUES (320924, '射阳县', 320900, '射阳', 3, '0515', '224300', '120.26043', '33.77636', 'Sheyang', '1', 0);
INSERT INTO `hh_region` VALUES (320925, '建湖县', 320900, '建湖', 3, '0515', '224700', '119.79852', '33.47241', 'Jianhu', '1', 0);
INSERT INTO `hh_region` VALUES (320981, '东台市', 320900, '东台', 3, '0515', '224200', '120.32376', '32.85078', 'Dongtai', '1', 0);
INSERT INTO `hh_region` VALUES (320982, '大丰市', 320900, '大丰', 3, '0515', '224100', '120.46594', '33.19893', 'Dafeng', '1', 0);
INSERT INTO `hh_region` VALUES (321000, '扬州市', 320000, '扬州', 2, '0514', '225002', '119.421003', '32.393159', 'Yangzhou', '1', 0);
INSERT INTO `hh_region` VALUES (321002, '广陵区', 321000, '广陵', 3, '0514', '225002', '119.43186', '32.39472', 'Guangling', '1', 0);
INSERT INTO `hh_region` VALUES (321003, '邗江区', 321000, '邗江', 3, '0514', '225002', '119.39816', '32.3765', 'Hanjiang', '1', 0);
INSERT INTO `hh_region` VALUES (321012, '江都区', 321000, '江都', 3, '0514', '225200', '119.567481', '32.426564', 'Jiangdu', '1', 0);
INSERT INTO `hh_region` VALUES (321023, '宝应县', 321000, '宝应', 3, '0514', '225800', '119.31213', '33.23549', 'Baoying', '1', 0);
INSERT INTO `hh_region` VALUES (321081, '仪征市', 321000, '仪征', 3, '0514', '211400', '119.18432', '32.27197', 'Yizheng', '1', 0);
INSERT INTO `hh_region` VALUES (321084, '高邮市', 321000, '高邮', 3, '0514', '225600', '119.45965', '32.78135', 'Gaoyou', '1', 0);
INSERT INTO `hh_region` VALUES (321100, '镇江市', 320000, '镇江', 2, '0511', '212004', '119.452753', '32.204402', 'Zhenjiang', '1', 0);
INSERT INTO `hh_region` VALUES (321102, '京口区', 321100, '京口', 3, '0511', '212003', '119.46947', '32.19809', 'Jingkou', '1', 0);
INSERT INTO `hh_region` VALUES (321111, '润州区', 321100, '润州', 3, '0511', '212005', '119.41134', '32.19523', 'Runzhou', '1', 0);
INSERT INTO `hh_region` VALUES (321112, '丹徒区', 321100, '丹徒', 3, '0511', '212028', '119.43383', '32.13183', 'Dantu', '1', 0);
INSERT INTO `hh_region` VALUES (321181, '丹阳市', 321100, '丹阳', 3, '0511', '212300', '119.57525', '31.99121', 'Danyang', '1', 0);
INSERT INTO `hh_region` VALUES (321182, '扬中市', 321100, '扬中', 3, '0511', '212200', '119.79718', '32.2363', 'Yangzhong', '1', 0);
INSERT INTO `hh_region` VALUES (321183, '句容市', 321100, '句容', 3, '0511', '212400', '119.16482', '31.95591', 'Jurong', '1', 0);
INSERT INTO `hh_region` VALUES (321200, '泰州市', 320000, '泰州', 2, '0523', '225300', '119.915176', '32.484882', 'Taizhou', '1', 0);
INSERT INTO `hh_region` VALUES (321202, '海陵区', 321200, '海陵', 3, '0523', '225300', '119.91942', '32.49101', 'Hailing', '1', 0);
INSERT INTO `hh_region` VALUES (321203, '高港区', 321200, '高港', 3, '0523', '225321', '119.88089', '32.31833', 'Gaogang', '1', 0);
INSERT INTO `hh_region` VALUES (321204, '姜堰区', 321200, '姜堰', 3, '0523', '225500', '120.148208', '32.508483', 'Jiangyan', '1', 0);
INSERT INTO `hh_region` VALUES (321281, '兴化市', 321200, '兴化', 3, '0523', '225700', '119.85238', '32.90944', 'Xinghua', '1', 0);
INSERT INTO `hh_region` VALUES (321282, '靖江市', 321200, '靖江', 3, '0523', '214500', '120.27291', '32.01595', 'Jingjiang', '1', 0);
INSERT INTO `hh_region` VALUES (321283, '泰兴市', 321200, '泰兴', 3, '0523', '225400', '120.05194', '32.17187', 'Taixing', '1', 0);
INSERT INTO `hh_region` VALUES (321300, '宿迁市', 320000, '宿迁', 2, '0527', '223800', '118.293328', '33.945154', 'Suqian', '1', 0);
INSERT INTO `hh_region` VALUES (321302, '宿城区', 321300, '宿城', 3, '0527', '223800', '118.29141', '33.94219', 'Sucheng', '1', 0);
INSERT INTO `hh_region` VALUES (321311, '宿豫区', 321300, '宿豫', 3, '0527', '223800', '118.32922', '33.94673', 'Suyu', '1', 0);
INSERT INTO `hh_region` VALUES (321322, '沭阳县', 321300, '沭阳', 3, '0527', '223600', '118.76873', '34.11446', 'Shuyang', '1', 0);
INSERT INTO `hh_region` VALUES (321323, '泗阳县', 321300, '泗阳', 3, '0527', '223700', '118.7033', '33.72096', 'Siyang', '1', 0);
INSERT INTO `hh_region` VALUES (321324, '泗洪县', 321300, '泗洪', 3, '0527', '223900', '118.21716', '33.45996', 'Sihong', '1', 0);
INSERT INTO `hh_region` VALUES (330000, '浙江省', 100000, '浙江', 1, '', '', '120.153576', '30.287459', 'Zhejiang', '1', 0);
INSERT INTO `hh_region` VALUES (330100, '杭州市', 330000, '杭州', 2, '0571', '310026', '120.153576', '30.287459', 'Hangzhou', '1', 0);
INSERT INTO `hh_region` VALUES (330102, '上城区', 330100, '上城', 3, '0571', '310002', '120.16922', '30.24255', 'Shangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (330103, '下城区', 330100, '下城', 3, '0571', '310006', '120.18096', '30.28153', 'Xiacheng', '1', 0);
INSERT INTO `hh_region` VALUES (330104, '江干区', 330100, '江干', 3, '0571', '310016', '120.20517', '30.2572', 'Jianggan', '1', 0);
INSERT INTO `hh_region` VALUES (330105, '拱墅区', 330100, '拱墅', 3, '0571', '310011', '120.14209', '30.31968', 'Gongshu', '1', 0);
INSERT INTO `hh_region` VALUES (330106, '西湖区', 330100, '西湖', 3, '0571', '310013', '120.12979', '30.25949', 'Xihu', '1', 0);
INSERT INTO `hh_region` VALUES (330108, '滨江区', 330100, '滨江', 3, '0571', '310051', '120.21194', '30.20835', 'Binjiang', '1', 0);
INSERT INTO `hh_region` VALUES (330109, '萧山区', 330100, '萧山', 3, '0571', '311200', '120.26452', '30.18505', 'Xiaoshan', '1', 0);
INSERT INTO `hh_region` VALUES (330110, '余杭区', 330100, '余杭', 3, '0571', '311100', '120.29986', '30.41829', 'Yuhang', '1', 0);
INSERT INTO `hh_region` VALUES (330122, '桐庐县', 330100, '桐庐', 3, '0571', '311500', '119.68853', '29.79779', 'Tonglu', '1', 0);
INSERT INTO `hh_region` VALUES (330127, '淳安县', 330100, '淳安', 3, '0571', '311700', '119.04257', '29.60988', 'Chun\'an', '1', 0);
INSERT INTO `hh_region` VALUES (330182, '建德市', 330100, '建德', 3, '0571', '311600', '119.28158', '29.47603', 'Jiande', '1', 0);
INSERT INTO `hh_region` VALUES (330183, '富阳区', 330100, '富阳', 3, '0571', '311400', '119.96041', '30.04878', 'Fuyang', '1', 0);
INSERT INTO `hh_region` VALUES (330185, '临安市', 330100, '临安', 3, '0571', '311300', '119.72473', '30.23447', 'Lin\'an', '1', 0);
INSERT INTO `hh_region` VALUES (330200, '宁波市', 330000, '宁波', 2, '0574', '315000', '121.549792', '29.868388', 'Ningbo', '1', 0);
INSERT INTO `hh_region` VALUES (330203, '海曙区', 330200, '海曙', 3, '0574', '315000', '121.55106', '29.85977', 'Haishu', '1', 0);
INSERT INTO `hh_region` VALUES (330204, '江东区', 330200, '江东', 3, '0574', '315040', '121.57028', '29.86701', 'Jiangdong', '1', 0);
INSERT INTO `hh_region` VALUES (330205, '江北区', 330200, '江北', 3, '0574', '315020', '121.55681', '29.88776', 'Jiangbei', '1', 0);
INSERT INTO `hh_region` VALUES (330206, '北仑区', 330200, '北仑', 3, '0574', '315800', '121.84408', '29.90069', 'Beilun', '1', 0);
INSERT INTO `hh_region` VALUES (330211, '镇海区', 330200, '镇海', 3, '0574', '315200', '121.71615', '29.94893', 'Zhenhai', '1', 0);
INSERT INTO `hh_region` VALUES (330212, '鄞州区', 330200, '鄞州', 3, '0574', '315100', '121.54754', '29.81614', 'Yinzhou', '1', 0);
INSERT INTO `hh_region` VALUES (330225, '象山县', 330200, '象山', 3, '0574', '315700', '121.86917', '29.47758', 'Xiangshan', '1', 0);
INSERT INTO `hh_region` VALUES (330226, '宁海县', 330200, '宁海', 3, '0574', '315600', '121.43072', '29.2889', 'Ninghai', '1', 0);
INSERT INTO `hh_region` VALUES (330281, '余姚市', 330200, '余姚', 3, '0574', '315400', '121.15341', '30.03867', 'Yuyao', '1', 0);
INSERT INTO `hh_region` VALUES (330282, '慈溪市', 330200, '慈溪', 3, '0574', '315300', '121.26641', '30.16959', 'Cixi', '1', 0);
INSERT INTO `hh_region` VALUES (330283, '奉化市', 330200, '奉化', 3, '0574', '315500', '121.41003', '29.65537', 'Fenghua', '1', 0);
INSERT INTO `hh_region` VALUES (330300, '温州市', 330000, '温州', 2, '0577', '325000', '120.672111', '28.000575', 'Wenzhou', '1', 0);
INSERT INTO `hh_region` VALUES (330302, '鹿城区', 330300, '鹿城', 3, '0577', '325000', '120.65505', '28.01489', 'Lucheng', '1', 0);
INSERT INTO `hh_region` VALUES (330303, '龙湾区', 330300, '龙湾', 3, '0577', '325013', '120.83053', '27.91284', 'Longwan', '1', 0);
INSERT INTO `hh_region` VALUES (330304, '瓯海区', 330300, '瓯海', 3, '0577', '325005', '120.63751', '28.00714', 'Ouhai', '1', 0);
INSERT INTO `hh_region` VALUES (330322, '洞头县', 330300, '洞头', 3, '0577', '325700', '121.15606', '27.83634', 'Dongtou', '1', 0);
INSERT INTO `hh_region` VALUES (330324, '永嘉县', 330300, '永嘉', 3, '0577', '325100', '120.69317', '28.15456', 'Yongjia', '1', 0);
INSERT INTO `hh_region` VALUES (330326, '平阳县', 330300, '平阳', 3, '0577', '325400', '120.56506', '27.66245', 'Pingyang', '1', 0);
INSERT INTO `hh_region` VALUES (330327, '苍南县', 330300, '苍南', 3, '0577', '325800', '120.42608', '27.51739', 'Cangnan', '1', 0);
INSERT INTO `hh_region` VALUES (330328, '文成县', 330300, '文成', 3, '0577', '325300', '120.09063', '27.78678', 'Wencheng', '1', 0);
INSERT INTO `hh_region` VALUES (330329, '泰顺县', 330300, '泰顺', 3, '0577', '325500', '119.7182', '27.55694', 'Taishun', '1', 0);
INSERT INTO `hh_region` VALUES (330381, '瑞安市', 330300, '瑞安', 3, '0577', '325200', '120.65466', '27.78041', 'Rui\'an', '1', 0);
INSERT INTO `hh_region` VALUES (330382, '乐清市', 330300, '乐清', 3, '0577', '325600', '120.9617', '28.12404', 'Yueqing', '1', 0);
INSERT INTO `hh_region` VALUES (330400, '嘉兴市', 330000, '嘉兴', 2, '0573', '314000', '120.750865', '30.762653', 'Jiaxing', '1', 0);
INSERT INTO `hh_region` VALUES (330402, '南湖区', 330400, '南湖', 3, '0573', '314051', '120.78524', '30.74865', 'Nanhu', '1', 0);
INSERT INTO `hh_region` VALUES (330411, '秀洲区', 330400, '秀洲', 3, '0573', '314031', '120.70867', '30.76454', 'Xiuzhou', '1', 0);
INSERT INTO `hh_region` VALUES (330421, '嘉善县', 330400, '嘉善', 3, '0573', '314100', '120.92559', '30.82993', 'Jiashan', '1', 0);
INSERT INTO `hh_region` VALUES (330424, '海盐县', 330400, '海盐', 3, '0573', '314300', '120.9457', '30.52547', 'Haiyan', '1', 0);
INSERT INTO `hh_region` VALUES (330481, '海宁市', 330400, '海宁', 3, '0573', '314400', '120.6813', '30.5097', 'Haining', '1', 0);
INSERT INTO `hh_region` VALUES (330482, '平湖市', 330400, '平湖', 3, '0573', '314200', '121.02166', '30.69618', 'Pinghu', '1', 0);
INSERT INTO `hh_region` VALUES (330483, '桐乡市', 330400, '桐乡', 3, '0573', '314500', '120.56485', '30.6302', 'Tongxiang', '1', 0);
INSERT INTO `hh_region` VALUES (330500, '湖州市', 330000, '湖州', 2, '0572', '313000', '120.102398', '30.867198', 'Huzhou', '1', 0);
INSERT INTO `hh_region` VALUES (330502, '吴兴区', 330500, '吴兴', 3, '0572', '313000', '120.12548', '30.85752', 'Wuxing', '1', 0);
INSERT INTO `hh_region` VALUES (330503, '南浔区', 330500, '南浔', 3, '0572', '313009', '120.42038', '30.86686', 'Nanxun', '1', 0);
INSERT INTO `hh_region` VALUES (330521, '德清县', 330500, '德清', 3, '0572', '313200', '119.97836', '30.53369', 'Deqing', '1', 0);
INSERT INTO `hh_region` VALUES (330522, '长兴县', 330500, '长兴', 3, '0572', '313100', '119.90783', '31.00606', 'Changxing', '1', 0);
INSERT INTO `hh_region` VALUES (330523, '安吉县', 330500, '安吉', 3, '0572', '313300', '119.68158', '30.63798', 'Anji', '1', 0);
INSERT INTO `hh_region` VALUES (330600, '绍兴市', 330000, '绍兴', 2, '0575', '312000', '120.582112', '29.997117', 'Shaoxing', '1', 0);
INSERT INTO `hh_region` VALUES (330602, '越城区', 330600, '越城', 3, '0575', '312000', '120.5819', '29.98895', 'Yuecheng', '1', 0);
INSERT INTO `hh_region` VALUES (330603, '柯桥区', 330600, '柯桥', 3, '0575', '312030', '120.492736', '30.08763', 'Keqiao ', '1', 0);
INSERT INTO `hh_region` VALUES (330604, '上虞区', 330600, '上虞', 3, '0575', '312300', '120.476075', '30.078038', 'Shangyu', '1', 0);
INSERT INTO `hh_region` VALUES (330624, '新昌县', 330600, '新昌', 3, '0575', '312500', '120.90435', '29.49991', 'Xinchang', '1', 0);
INSERT INTO `hh_region` VALUES (330681, '诸暨市', 330600, '诸暨', 3, '0575', '311800', '120.23629', '29.71358', 'Zhuji', '1', 0);
INSERT INTO `hh_region` VALUES (330683, '嵊州市', 330600, '嵊州', 3, '0575', '312400', '120.82174', '29.58854', 'Shengzhou', '1', 0);
INSERT INTO `hh_region` VALUES (330700, '金华市', 330000, '金华', 2, '0579', '321000', '119.649506', '29.089524', 'Jinhua', '1', 0);
INSERT INTO `hh_region` VALUES (330702, '婺城区', 330700, '婺城', 3, '0579', '321000', '119.57135', '29.09521', 'Wucheng', '1', 0);
INSERT INTO `hh_region` VALUES (330703, '金东区', 330700, '金东', 3, '0579', '321000', '119.69302', '29.0991', 'Jindong', '1', 0);
INSERT INTO `hh_region` VALUES (330723, '武义县', 330700, '武义', 3, '0579', '321200', '119.8164', '28.89331', 'Wuyi', '1', 0);
INSERT INTO `hh_region` VALUES (330726, '浦江县', 330700, '浦江', 3, '0579', '322200', '119.89181', '29.45353', 'Pujiang', '1', 0);
INSERT INTO `hh_region` VALUES (330727, '磐安县', 330700, '磐安', 3, '0579', '322300', '120.45022', '29.05733', 'Pan\'an', '1', 0);
INSERT INTO `hh_region` VALUES (330781, '兰溪市', 330700, '兰溪', 3, '0579', '321100', '119.45965', '29.20841', 'Lanxi', '1', 0);
INSERT INTO `hh_region` VALUES (330782, '义乌市', 330700, '义乌', 3, '0579', '322000', '120.0744', '29.30558', 'Yiwu', '1', 0);
INSERT INTO `hh_region` VALUES (330783, '东阳市', 330700, '东阳', 3, '0579', '322100', '120.24185', '29.28942', 'Dongyang', '1', 0);
INSERT INTO `hh_region` VALUES (330784, '永康市', 330700, '永康', 3, '0579', '321300', '120.04727', '28.88844', 'Yongkang', '1', 0);
INSERT INTO `hh_region` VALUES (330800, '衢州市', 330000, '衢州', 2, '0570', '324002', '118.87263', '28.941708', 'Quzhou', '1', 0);
INSERT INTO `hh_region` VALUES (330802, '柯城区', 330800, '柯城', 3, '0570', '324100', '118.87109', '28.96858', 'Kecheng', '1', 0);
INSERT INTO `hh_region` VALUES (330803, '衢江区', 330800, '衢江', 3, '0570', '324022', '118.9598', '28.97977', 'Qujiang', '1', 0);
INSERT INTO `hh_region` VALUES (330822, '常山县', 330800, '常山', 3, '0570', '324200', '118.51025', '28.90191', 'Changshan', '1', 0);
INSERT INTO `hh_region` VALUES (330824, '开化县', 330800, '开化', 3, '0570', '324300', '118.41616', '29.13785', 'Kaihua', '1', 0);
INSERT INTO `hh_region` VALUES (330825, '龙游县', 330800, '龙游', 3, '0570', '324400', '119.17221', '29.02823', 'Longyou', '1', 0);
INSERT INTO `hh_region` VALUES (330881, '江山市', 330800, '江山', 3, '0570', '324100', '118.62674', '28.7386', 'Jiangshan', '1', 0);
INSERT INTO `hh_region` VALUES (330900, '舟山市', 330000, '舟山', 2, '0580', '316000', '122.106863', '30.016028', 'Zhoushan', '1', 0);
INSERT INTO `hh_region` VALUES (330902, '定海区', 330900, '定海', 3, '0580', '316000', '122.10677', '30.01985', 'Dinghai', '1', 0);
INSERT INTO `hh_region` VALUES (330903, '普陀区', 330900, '普陀', 3, '0580', '316100', '122.30278', '29.94908', 'Putuo', '1', 0);
INSERT INTO `hh_region` VALUES (330921, '岱山县', 330900, '岱山', 3, '0580', '316200', '122.20486', '30.24385', 'Daishan', '1', 0);
INSERT INTO `hh_region` VALUES (330922, '嵊泗县', 330900, '嵊泗', 3, '0580', '202450', '122.45129', '30.72678', 'Shengsi', '1', 0);
INSERT INTO `hh_region` VALUES (331000, '台州市', 330000, '台州', 2, '0576', '318000', '121.428599', '28.661378', 'Taizhou', '1', 0);
INSERT INTO `hh_region` VALUES (331002, '椒江区', 331000, '椒江', 3, '0576', '318000', '121.44287', '28.67301', 'Jiaojiang', '1', 0);
INSERT INTO `hh_region` VALUES (331003, '黄岩区', 331000, '黄岩', 3, '0576', '318020', '121.25891', '28.65077', 'Huangyan', '1', 0);
INSERT INTO `hh_region` VALUES (331004, '路桥区', 331000, '路桥', 3, '0576', '318050', '121.37381', '28.58016', 'Luqiao', '1', 0);
INSERT INTO `hh_region` VALUES (331021, '玉环县', 331000, '玉环', 3, '0576', '317600', '121.23242', '28.13637', 'Yuhuan', '1', 0);
INSERT INTO `hh_region` VALUES (331022, '三门县', 331000, '三门', 3, '0576', '317100', '121.3937', '29.1051', 'Sanmen', '1', 0);
INSERT INTO `hh_region` VALUES (331023, '天台县', 331000, '天台', 3, '0576', '317200', '121.00848', '29.1429', 'Tiantai', '1', 0);
INSERT INTO `hh_region` VALUES (331024, '仙居县', 331000, '仙居', 3, '0576', '317300', '120.72872', '28.84672', 'Xianju', '1', 0);
INSERT INTO `hh_region` VALUES (331081, '温岭市', 331000, '温岭', 3, '0576', '317500', '121.38595', '28.37176', 'Wenling', '1', 0);
INSERT INTO `hh_region` VALUES (331082, '临海市', 331000, '临海', 3, '0576', '317000', '121.13885', '28.85603', 'Linhai', '1', 0);
INSERT INTO `hh_region` VALUES (331100, '丽水市', 330000, '丽水', 2, '0578', '323000', '119.921786', '28.451993', 'Lishui', '1', 0);
INSERT INTO `hh_region` VALUES (331102, '莲都区', 331100, '莲都', 3, '0578', '323000', '119.9127', '28.44583', 'Liandu', '1', 0);
INSERT INTO `hh_region` VALUES (331121, '青田县', 331100, '青田', 3, '0578', '323900', '120.29028', '28.13897', 'Qingtian', '1', 0);
INSERT INTO `hh_region` VALUES (331122, '缙云县', 331100, '缙云', 3, '0578', '321400', '120.09036', '28.65944', 'Jinyun', '1', 0);
INSERT INTO `hh_region` VALUES (331123, '遂昌县', 331100, '遂昌', 3, '0578', '323300', '119.27606', '28.59291', 'Suichang', '1', 0);
INSERT INTO `hh_region` VALUES (331124, '松阳县', 331100, '松阳', 3, '0578', '323400', '119.48199', '28.4494', 'Songyang', '1', 0);
INSERT INTO `hh_region` VALUES (331125, '云和县', 331100, '云和', 3, '0578', '323600', '119.57287', '28.11643', 'Yunhe', '1', 0);
INSERT INTO `hh_region` VALUES (331126, '庆元县', 331100, '庆元', 3, '0578', '323800', '119.06256', '27.61842', 'Qingyuan', '1', 0);
INSERT INTO `hh_region` VALUES (331127, '景宁畲族自治县', 331100, '景宁', 3, '0578', '323500', '119.63839', '27.97393', 'Jingning', '1', 0);
INSERT INTO `hh_region` VALUES (331181, '龙泉市', 331100, '龙泉', 3, '0578', '323700', '119.14163', '28.0743', 'Longquan', '1', 0);
INSERT INTO `hh_region` VALUES (331200, '舟山群岛新区', 330000, '舟山新区', 2, '0580', '316000', '122.317657', '29.813242', 'Zhoushan', '1', 0);
INSERT INTO `hh_region` VALUES (331201, '金塘岛', 331200, '金塘', 3, '0580', '316000', '121.893373', '30.040641', 'Jintang', '1', 0);
INSERT INTO `hh_region` VALUES (331202, '六横岛', 331200, '六横', 3, '0580', '316000', '122.14265', '29.662938', 'Liuheng', '1', 0);
INSERT INTO `hh_region` VALUES (331203, '衢山岛', 331200, '衢山', 3, '0580', '316000', '122.358425', '30.442642', 'Qushan', '1', 0);
INSERT INTO `hh_region` VALUES (331204, '舟山本岛西北部', 331200, '舟山', 3, '0580', '316000', '122.03064', '30.140377', 'Zhoushan', '1', 0);
INSERT INTO `hh_region` VALUES (331205, '岱山岛西南部', 331200, '岱山', 3, '0580', '316000', '122.180123', '30.277269', 'Daishan', '1', 0);
INSERT INTO `hh_region` VALUES (331206, '泗礁岛', 331200, '泗礁', 3, '0580', '316000', '122.45803', '30.725112', 'Sijiao', '1', 0);
INSERT INTO `hh_region` VALUES (331207, '朱家尖岛', 331200, '朱家尖', 3, '0580', '316000', '122.390636', '29.916303', 'Zhujiajian', '1', 0);
INSERT INTO `hh_region` VALUES (331208, '洋山岛', 331200, '洋山', 3, '0580', '316000', '121.995891', '30.094637', 'Yangshan', '1', 0);
INSERT INTO `hh_region` VALUES (331209, '长涂岛', 331200, '长涂', 3, '0580', '316000', '122.284681', '30.24888', 'Changtu', '1', 0);
INSERT INTO `hh_region` VALUES (331210, '虾峙岛', 331200, '虾峙', 3, '0580', '316000', '122.244686', '29.752941', 'Xiazhi', '1', 0);
INSERT INTO `hh_region` VALUES (340000, '安徽省', 100000, '安徽', 1, '', '', '117.283042', '31.86119', 'Anhui', '1', 0);
INSERT INTO `hh_region` VALUES (340100, '合肥市', 340000, '合肥', 2, '0551', '230001', '117.283042', '31.86119', 'Hefei', '1', 0);
INSERT INTO `hh_region` VALUES (340102, '瑶海区', 340100, '瑶海', 3, '0551', '230011', '117.30947', '31.85809', 'Yaohai', '1', 0);
INSERT INTO `hh_region` VALUES (340103, '庐阳区', 340100, '庐阳', 3, '0551', '230001', '117.26452', '31.87874', 'Luyang', '1', 0);
INSERT INTO `hh_region` VALUES (340104, '蜀山区', 340100, '蜀山', 3, '0551', '230031', '117.26104', '31.85117', 'Shushan', '1', 0);
INSERT INTO `hh_region` VALUES (340111, '包河区', 340100, '包河', 3, '0551', '230041', '117.30984', '31.79502', 'Baohe', '1', 0);
INSERT INTO `hh_region` VALUES (340121, '长丰县', 340100, '长丰', 3, '0551', '231100', '117.16549', '32.47959', 'Changfeng', '1', 0);
INSERT INTO `hh_region` VALUES (340122, '肥东县', 340100, '肥东', 3, '0551', '231600', '117.47128', '31.88525', 'Feidong', '1', 0);
INSERT INTO `hh_region` VALUES (340123, '肥西县', 340100, '肥西', 3, '0551', '231200', '117.16845', '31.72143', 'Feixi', '1', 0);
INSERT INTO `hh_region` VALUES (340124, '庐江县', 340100, '庐江', 3, '0565', '231500', '117.289844', '31.251488', 'Lujiang', '1', 0);
INSERT INTO `hh_region` VALUES (340181, '巢湖市', 340100, '巢湖', 3, '0565', '238000', '117.874155', '31.600518', 'Chaohu', '1', 0);
INSERT INTO `hh_region` VALUES (340200, '芜湖市', 340000, '芜湖', 2, '0551', '241000', '118.376451', '31.326319', 'Wuhu', '1', 0);
INSERT INTO `hh_region` VALUES (340202, '镜湖区', 340200, '镜湖', 3, '0553', '241000', '118.38525', '31.34038', 'Jinghu', '1', 0);
INSERT INTO `hh_region` VALUES (340203, '弋江区', 340200, '弋江', 3, '0553', '241000', '118.37265', '31.31178', 'Yijiang', '1', 0);
INSERT INTO `hh_region` VALUES (340207, '鸠江区', 340200, '鸠江', 3, '0553', '241000', '118.39215', '31.36928', 'Jiujiang', '1', 0);
INSERT INTO `hh_region` VALUES (340208, '三山区', 340200, '三山', 3, '0553', '241000', '118.22509', '31.20703', 'Sanshan', '1', 0);
INSERT INTO `hh_region` VALUES (340221, '芜湖县', 340200, '芜湖', 3, '0553', '241100', '118.57525', '31.13476', 'Wuhu', '1', 0);
INSERT INTO `hh_region` VALUES (340222, '繁昌县', 340200, '繁昌', 3, '0553', '241200', '118.19982', '31.08319', 'Fanchang', '1', 0);
INSERT INTO `hh_region` VALUES (340223, '南陵县', 340200, '南陵', 3, '0553', '242400', '118.33688', '30.91969', 'Nanling', '1', 0);
INSERT INTO `hh_region` VALUES (340225, '无为县', 340200, '无为', 3, '0565', '238300', '117.911432', '31.303075', 'Wuwei', '1', 0);
INSERT INTO `hh_region` VALUES (340300, '蚌埠市', 340000, '蚌埠', 2, '0552', '233000', '117.36237', '32.934037', 'Bengbu', '1', 0);
INSERT INTO `hh_region` VALUES (340302, '龙子湖区', 340300, '龙子湖', 3, '0552', '233000', '117.39379', '32.94301', 'Longzihu', '1', 0);
INSERT INTO `hh_region` VALUES (340303, '蚌山区', 340300, '蚌山', 3, '0552', '233000', '117.36767', '32.94411', 'Bengshan', '1', 0);
INSERT INTO `hh_region` VALUES (340304, '禹会区', 340300, '禹会', 3, '0552', '233010', '117.35315', '32.93336', 'Yuhui', '1', 0);
INSERT INTO `hh_region` VALUES (340311, '淮上区', 340300, '淮上', 3, '0552', '233002', '117.35983', '32.96423', 'Huaishang', '1', 0);
INSERT INTO `hh_region` VALUES (340321, '怀远县', 340300, '怀远', 3, '0552', '233400', '117.20507', '32.97007', 'Huaiyuan', '1', 0);
INSERT INTO `hh_region` VALUES (340322, '五河县', 340300, '五河', 3, '0552', '233300', '117.89144', '33.14457', 'Wuhe', '1', 0);
INSERT INTO `hh_region` VALUES (340323, '固镇县', 340300, '固镇', 3, '0552', '233700', '117.31558', '33.31803', 'Guzhen', '1', 0);
INSERT INTO `hh_region` VALUES (340400, '淮南市', 340000, '淮南', 2, '0554', '232001', '117.025449', '32.645947', 'Huainan', '1', 0);
INSERT INTO `hh_region` VALUES (340402, '大通区', 340400, '大通', 3, '0554', '232033', '117.05255', '32.63265', 'Datong', '1', 0);
INSERT INTO `hh_region` VALUES (340403, '田家庵区', 340400, '田家庵', 3, '0554', '232000', '117.01739', '32.64697', 'Tianjiaan', '1', 0);
INSERT INTO `hh_region` VALUES (340404, '谢家集区', 340400, '谢家集', 3, '0554', '232052', '116.86377', '32.59818', 'Xiejiaji', '1', 0);
INSERT INTO `hh_region` VALUES (340405, '八公山区', 340400, '八公山', 3, '0554', '232072', '116.83694', '32.62941', 'Bagongshan', '1', 0);
INSERT INTO `hh_region` VALUES (340406, '潘集区', 340400, '潘集', 3, '0554', '232082', '116.81622', '32.78287', 'Panji', '1', 0);
INSERT INTO `hh_region` VALUES (340421, '凤台县', 340400, '凤台', 3, '0554', '232100', '116.71569', '32.70752', 'Fengtai', '1', 0);
INSERT INTO `hh_region` VALUES (340500, '马鞍山市', 340000, '马鞍山', 2, '0555', '243001', '118.507906', '31.689362', 'Ma\'anshan', '1', 0);
INSERT INTO `hh_region` VALUES (340503, '花山区', 340500, '花山', 3, '0555', '243000', '118.51231', '31.7001', 'Huashan', '1', 0);
INSERT INTO `hh_region` VALUES (340504, '雨山区', 340500, '雨山', 3, '0555', '243071', '118.49869', '31.68219', 'Yushan', '1', 0);
INSERT INTO `hh_region` VALUES (340506, '博望区', 340500, '博望', 3, '0555', '243131', '118.844387', '31.561871', 'Bowang', '1', 0);
INSERT INTO `hh_region` VALUES (340521, '当涂县', 340500, '当涂', 3, '0555', '243100', '118.49786', '31.57098', 'Dangtu', '1', 0);
INSERT INTO `hh_region` VALUES (340522, '含山县', 340500, '含山', 3, '0555', '238100', '118.105545', '31.727758', 'Hanshan ', '1', 0);
INSERT INTO `hh_region` VALUES (340523, '和县', 340500, '和县', 3, '0555', '238200', '118.351405', '31.741794', 'Hexian', '1', 0);
INSERT INTO `hh_region` VALUES (340600, '淮北市', 340000, '淮北', 2, '0561', '235000', '116.794664', '33.971707', 'Huaibei', '1', 0);
INSERT INTO `hh_region` VALUES (340602, '杜集区', 340600, '杜集', 3, '0561', '235000', '116.82998', '33.99363', 'Duji', '1', 0);
INSERT INTO `hh_region` VALUES (340603, '相山区', 340600, '相山', 3, '0561', '235000', '116.79464', '33.95979', 'Xiangshan', '1', 0);
INSERT INTO `hh_region` VALUES (340604, '烈山区', 340600, '烈山', 3, '0561', '235000', '116.81448', '33.89355', 'Lieshan', '1', 0);
INSERT INTO `hh_region` VALUES (340621, '濉溪县', 340600, '濉溪', 3, '0561', '235100', '116.76785', '33.91455', 'Suixi', '1', 0);
INSERT INTO `hh_region` VALUES (340700, '铜陵市', 340000, '铜陵', 2, '0562', '244000', '117.816576', '30.929935', 'Tongling', '1', 0);
INSERT INTO `hh_region` VALUES (340702, '铜官山区', 340700, '铜官山', 3, '0562', '244000', '117.81525', '30.93423', 'Tongguanshan', '1', 0);
INSERT INTO `hh_region` VALUES (340703, '狮子山区', 340700, '狮子山', 3, '0562', '244000', '117.89178', '30.92631', 'Shizishan', '1', 0);
INSERT INTO `hh_region` VALUES (340711, '郊区', 340700, '郊区', 3, '0562', '244000', '117.80868', '30.91976', 'Jiaoqu', '1', 0);
INSERT INTO `hh_region` VALUES (340721, '铜陵县', 340700, '铜陵', 3, '0562', '244100', '117.79113', '30.95365', 'Tongling', '1', 0);
INSERT INTO `hh_region` VALUES (340800, '安庆市', 340000, '安庆', 2, '0556', '246001', '117.053571', '30.524816', 'Anqing', '1', 0);
INSERT INTO `hh_region` VALUES (340802, '迎江区', 340800, '迎江', 3, '0556', '246001', '117.0493', '30.50421', 'Yingjiang', '1', 0);
INSERT INTO `hh_region` VALUES (340803, '大观区', 340800, '大观', 3, '0556', '246002', '117.03426', '30.51216', 'Daguan', '1', 0);
INSERT INTO `hh_region` VALUES (340811, '宜秀区', 340800, '宜秀', 3, '0556', '246003', '117.06127', '30.50783', 'Yixiu', '1', 0);
INSERT INTO `hh_region` VALUES (340822, '怀宁县', 340800, '怀宁', 3, '0556', '246100', '116.82968', '30.73376', 'Huaining', '1', 0);
INSERT INTO `hh_region` VALUES (340823, '枞阳县', 340800, '枞阳', 3, '0556', '246700', '117.22015', '30.69956', 'Zongyang', '1', 0);
INSERT INTO `hh_region` VALUES (340824, '潜山县', 340800, '潜山', 3, '0556', '246300', '116.57574', '30.63037', 'Qianshan', '1', 0);
INSERT INTO `hh_region` VALUES (340825, '太湖县', 340800, '太湖', 3, '0556', '246400', '116.3088', '30.4541', 'Taihu', '1', 0);
INSERT INTO `hh_region` VALUES (340826, '宿松县', 340800, '宿松', 3, '0556', '246500', '116.12915', '30.1536', 'Susong', '1', 0);
INSERT INTO `hh_region` VALUES (340827, '望江县', 340800, '望江', 3, '0556', '246200', '116.68814', '30.12585', 'Wangjiang', '1', 0);
INSERT INTO `hh_region` VALUES (340828, '岳西县', 340800, '岳西', 3, '0556', '246600', '116.35995', '30.84983', 'Yuexi', '1', 0);
INSERT INTO `hh_region` VALUES (340881, '桐城市', 340800, '桐城', 3, '0556', '231400', '116.95071', '31.05216', 'Tongcheng', '1', 0);
INSERT INTO `hh_region` VALUES (341000, '黄山市', 340000, '黄山', 2, '0559', '245000', '118.317325', '29.709239', 'Huangshan', '1', 0);
INSERT INTO `hh_region` VALUES (341002, '屯溪区', 341000, '屯溪', 3, '0559', '245000', '118.33368', '29.71138', 'Tunxi', '1', 0);
INSERT INTO `hh_region` VALUES (341003, '黄山区', 341000, '黄山', 3, '0559', '242700', '118.1416', '30.2729', 'Huangshan', '1', 0);
INSERT INTO `hh_region` VALUES (341004, '徽州区', 341000, '徽州', 3, '0559', '245061', '118.33654', '29.82784', 'Huizhou', '1', 0);
INSERT INTO `hh_region` VALUES (341021, '歙县', 341000, '歙县', 3, '0559', '245200', '118.43676', '29.86745', 'Shexian', '1', 0);
INSERT INTO `hh_region` VALUES (341022, '休宁县', 341000, '休宁', 3, '0559', '245400', '118.18136', '29.78607', 'Xiuning', '1', 0);
INSERT INTO `hh_region` VALUES (341023, '黟县', 341000, '黟县', 3, '0559', '245500', '117.94137', '29.92588', 'Yixian', '1', 0);
INSERT INTO `hh_region` VALUES (341024, '祁门县', 341000, '祁门', 3, '0559', '245600', '117.71847', '29.85723', 'Qimen', '1', 0);
INSERT INTO `hh_region` VALUES (341100, '滁州市', 340000, '滁州', 2, '0550', '239000', '118.316264', '32.303627', 'Chuzhou', '1', 0);
INSERT INTO `hh_region` VALUES (341102, '琅琊区', 341100, '琅琊', 3, '0550', '239000', '118.30538', '32.29521', 'Langya', '1', 0);
INSERT INTO `hh_region` VALUES (341103, '南谯区', 341100, '南谯', 3, '0550', '239000', '118.31222', '32.31861', 'Nanqiao', '1', 0);
INSERT INTO `hh_region` VALUES (341122, '来安县', 341100, '来安', 3, '0550', '239200', '118.43438', '32.45176', 'Lai\'an', '1', 0);
INSERT INTO `hh_region` VALUES (341124, '全椒县', 341100, '全椒', 3, '0550', '239500', '118.27291', '32.08524', 'Quanjiao', '1', 0);
INSERT INTO `hh_region` VALUES (341125, '定远县', 341100, '定远', 3, '0550', '233200', '117.68035', '32.52488', 'Dingyuan', '1', 0);
INSERT INTO `hh_region` VALUES (341126, '凤阳县', 341100, '凤阳', 3, '0550', '233100', '117.56454', '32.86507', 'Fengyang', '1', 0);
INSERT INTO `hh_region` VALUES (341181, '天长市', 341100, '天长', 3, '0550', '239300', '118.99868', '32.69124', 'Tianchang', '1', 0);
INSERT INTO `hh_region` VALUES (341182, '明光市', 341100, '明光', 3, '0550', '239400', '117.99093', '32.77819', 'Mingguang', '1', 0);
INSERT INTO `hh_region` VALUES (341200, '阜阳市', 340000, '阜阳', 2, '0558', '236033', '115.819729', '32.896969', 'Fuyang', '1', 0);
INSERT INTO `hh_region` VALUES (341202, '颍州区', 341200, '颍州', 3, '0558', '236001', '115.80694', '32.88346', 'Yingzhou', '1', 0);
INSERT INTO `hh_region` VALUES (341203, '颍东区', 341200, '颍东', 3, '0558', '236058', '115.85659', '32.91296', 'Yingdong', '1', 0);
INSERT INTO `hh_region` VALUES (341204, '颍泉区', 341200, '颍泉', 3, '0558', '236045', '115.80712', '32.9249', 'Yingquan', '1', 0);
INSERT INTO `hh_region` VALUES (341221, '临泉县', 341200, '临泉', 3, '0558', '236400', '115.26232', '33.06758', 'Linquan', '1', 0);
INSERT INTO `hh_region` VALUES (341222, '太和县', 341200, '太和', 3, '0558', '236600', '115.62191', '33.16025', 'Taihe', '1', 0);
INSERT INTO `hh_region` VALUES (341225, '阜南县', 341200, '阜南', 3, '0558', '236300', '115.58563', '32.63551', 'Funan', '1', 0);
INSERT INTO `hh_region` VALUES (341226, '颍上县', 341200, '颍上', 3, '0558', '236200', '116.26458', '32.62998', 'Yingshang', '1', 0);
INSERT INTO `hh_region` VALUES (341282, '界首市', 341200, '界首', 3, '0558', '236500', '115.37445', '33.25714', 'Jieshou', '1', 0);
INSERT INTO `hh_region` VALUES (341300, '宿州市', 340000, '宿州', 2, '0557', '234000', '116.984084', '33.633891', 'Suzhou', '1', 0);
INSERT INTO `hh_region` VALUES (341302, '埇桥区', 341300, '埇桥', 3, '0557', '234000', '116.97731', '33.64058', 'Yongqiao', '1', 0);
INSERT INTO `hh_region` VALUES (341321, '砀山县', 341300, '砀山', 3, '0557', '235300', '116.35363', '34.42356', 'Dangshan', '1', 0);
INSERT INTO `hh_region` VALUES (341322, '萧县', 341300, '萧县', 3, '0557', '235200', '116.94546', '34.1879', 'Xiaoxian', '1', 0);
INSERT INTO `hh_region` VALUES (341323, '灵璧县', 341300, '灵璧', 3, '0557', '234200', '117.55813', '33.54339', 'Lingbi', '1', 0);
INSERT INTO `hh_region` VALUES (341324, '泗县', 341300, '泗县', 3, '0557', '234300', '117.91033', '33.48295', 'Sixian', '1', 0);
INSERT INTO `hh_region` VALUES (341500, '六安市', 340000, '六安', 2, '0564', '237000', '116.507676', '31.752889', 'Lu\'an', '1', 0);
INSERT INTO `hh_region` VALUES (341502, '金安区', 341500, '金安', 3, '0564', '237005', '116.50912', '31.75573', 'Jin\'an', '1', 0);
INSERT INTO `hh_region` VALUES (341503, '裕安区', 341500, '裕安', 3, '0564', '237010', '116.47985', '31.73787', 'Yu\'an', '1', 0);
INSERT INTO `hh_region` VALUES (341521, '寿县', 341500, '寿县', 3, '0564', '232200', '116.78466', '32.57653', 'Shouxian', '1', 0);
INSERT INTO `hh_region` VALUES (341522, '霍邱县', 341500, '霍邱', 3, '0564', '237400', '116.27795', '32.353', 'Huoqiu', '1', 0);
INSERT INTO `hh_region` VALUES (341523, '舒城县', 341500, '舒城', 3, '0564', '231300', '116.94491', '31.46413', 'Shucheng', '1', 0);
INSERT INTO `hh_region` VALUES (341524, '金寨县', 341500, '金寨', 3, '0564', '237300', '115.93463', '31.7351', 'Jinzhai', '1', 0);
INSERT INTO `hh_region` VALUES (341525, '霍山县', 341500, '霍山', 3, '0564', '237200', '116.33291', '31.3929', 'Huoshan', '1', 0);
INSERT INTO `hh_region` VALUES (341600, '亳州市', 340000, '亳州', 2, '0558', '236802', '115.782939', '33.869338', 'Bozhou', '1', 0);
INSERT INTO `hh_region` VALUES (341602, '谯城区', 341600, '谯城', 3, '0558', '236800', '115.77941', '33.87532', 'Qiaocheng', '1', 0);
INSERT INTO `hh_region` VALUES (341621, '涡阳县', 341600, '涡阳', 3, '0558', '233600', '116.21682', '33.50911', 'Guoyang', '1', 0);
INSERT INTO `hh_region` VALUES (341622, '蒙城县', 341600, '蒙城', 3, '0558', '233500', '116.5646', '33.26477', 'Mengcheng', '1', 0);
INSERT INTO `hh_region` VALUES (341623, '利辛县', 341600, '利辛', 3, '0558', '236700', '116.208', '33.14198', 'Lixin', '1', 0);
INSERT INTO `hh_region` VALUES (341700, '池州市', 340000, '池州', 2, '0566', '247100', '117.489157', '30.656037', 'Chizhou', '1', 0);
INSERT INTO `hh_region` VALUES (341702, '贵池区', 341700, '贵池', 3, '0566', '247100', '117.48722', '30.65283', 'Guichi', '1', 0);
INSERT INTO `hh_region` VALUES (341721, '东至县', 341700, '东至', 3, '0566', '247200', '117.02719', '30.0969', 'Dongzhi', '1', 0);
INSERT INTO `hh_region` VALUES (341722, '石台县', 341700, '石台', 3, '0566', '245100', '117.48666', '30.21042', 'Shitai', '1', 0);
INSERT INTO `hh_region` VALUES (341723, '青阳县', 341700, '青阳', 3, '0566', '242800', '117.84744', '30.63932', 'Qingyang', '1', 0);
INSERT INTO `hh_region` VALUES (341800, '宣城市', 340000, '宣城', 2, '0563', '242000', '118.757995', '30.945667', 'Xuancheng', '1', 0);
INSERT INTO `hh_region` VALUES (341802, '宣州区', 341800, '宣州', 3, '0563', '242000', '118.75462', '30.94439', 'Xuanzhou', '1', 0);
INSERT INTO `hh_region` VALUES (341821, '郎溪县', 341800, '郎溪', 3, '0563', '242100', '119.17923', '31.12599', 'Langxi', '1', 0);
INSERT INTO `hh_region` VALUES (341822, '广德县', 341800, '广德', 3, '0563', '242200', '119.41769', '30.89371', 'Guangde', '1', 0);
INSERT INTO `hh_region` VALUES (341823, '泾县', 341800, '泾县', 3, '0563', '242500', '118.41964', '30.69498', 'Jingxian', '1', 0);
INSERT INTO `hh_region` VALUES (341824, '绩溪县', 341800, '绩溪', 3, '0563', '245300', '118.59765', '30.07069', 'Jixi', '1', 0);
INSERT INTO `hh_region` VALUES (341825, '旌德县', 341800, '旌德', 3, '0563', '242600', '118.54299', '30.28898', 'Jingde', '1', 0);
INSERT INTO `hh_region` VALUES (341881, '宁国市', 341800, '宁国', 3, '0563', '242300', '118.98349', '30.6238', 'Ningguo', '1', 0);
INSERT INTO `hh_region` VALUES (350000, '福建省', 100000, '福建', 1, '', '', '119.306239', '26.075302', 'Fujian', '1', 0);
INSERT INTO `hh_region` VALUES (350100, '福州市', 350000, '福州', 2, '0591', '350001', '119.306239', '26.075302', 'Fuzhou', '1', 0);
INSERT INTO `hh_region` VALUES (350102, '鼓楼区', 350100, '鼓楼', 3, '0591', '350001', '119.30384', '26.08225', 'Gulou', '1', 0);
INSERT INTO `hh_region` VALUES (350103, '台江区', 350100, '台江', 3, '0591', '350004', '119.30899', '26.06204', 'Taijiang', '1', 0);
INSERT INTO `hh_region` VALUES (350104, '仓山区', 350100, '仓山', 3, '0591', '350007', '119.31543', '26.04335', 'Cangshan', '1', 0);
INSERT INTO `hh_region` VALUES (350105, '马尾区', 350100, '马尾', 3, '0591', '350015', '119.4555', '25.98942', 'Mawei', '1', 0);
INSERT INTO `hh_region` VALUES (350111, '晋安区', 350100, '晋安', 3, '0591', '350011', '119.32828', '26.0818', 'Jin\'an', '1', 0);
INSERT INTO `hh_region` VALUES (350121, '闽侯县', 350100, '闽侯', 3, '0591', '350100', '119.13388', '26.15014', 'Minhou', '1', 0);
INSERT INTO `hh_region` VALUES (350122, '连江县', 350100, '连江', 3, '0591', '350500', '119.53433', '26.19466', 'Lianjiang', '1', 0);
INSERT INTO `hh_region` VALUES (350123, '罗源县', 350100, '罗源', 3, '0591', '350600', '119.5509', '26.48752', 'Luoyuan', '1', 0);
INSERT INTO `hh_region` VALUES (350124, '闽清县', 350100, '闽清', 3, '0591', '350800', '118.8623', '26.21901', 'Minqing', '1', 0);
INSERT INTO `hh_region` VALUES (350125, '永泰县', 350100, '永泰', 3, '0591', '350700', '118.936', '25.86816', 'Yongtai', '1', 0);
INSERT INTO `hh_region` VALUES (350128, '平潭县', 350100, '平潭', 3, '0591', '350400', '119.791197', '25.503672', 'Pingtan', '1', 0);
INSERT INTO `hh_region` VALUES (350181, '福清市', 350100, '福清', 3, '0591', '350300', '119.38507', '25.72086', 'Fuqing', '1', 0);
INSERT INTO `hh_region` VALUES (350182, '长乐市', 350100, '长乐', 3, '0591', '350200', '119.52313', '25.96276', 'Changle', '1', 0);
INSERT INTO `hh_region` VALUES (350200, '厦门市', 350000, '厦门', 2, '0592', '361003', '118.11022', '24.490474', 'Xiamen', '1', 0);
INSERT INTO `hh_region` VALUES (350203, '思明区', 350200, '思明', 3, '0592', '361001', '118.08233', '24.44543', 'Siming', '1', 0);
INSERT INTO `hh_region` VALUES (350205, '海沧区', 350200, '海沧', 3, '0592', '361026', '118.03289', '24.48461', 'Haicang', '1', 0);
INSERT INTO `hh_region` VALUES (350206, '湖里区', 350200, '湖里', 3, '0592', '361006', '118.14621', '24.51253', 'Huli', '1', 0);
INSERT INTO `hh_region` VALUES (350211, '集美区', 350200, '集美', 3, '0592', '361021', '118.09719', '24.57584', 'Jimei', '1', 0);
INSERT INTO `hh_region` VALUES (350212, '同安区', 350200, '同安', 3, '0592', '361100', '118.15197', '24.72308', 'Tong\'an', '1', 0);
INSERT INTO `hh_region` VALUES (350213, '翔安区', 350200, '翔安', 3, '0592', '361101', '118.24783', '24.61863', 'Xiang\'an', '1', 0);
INSERT INTO `hh_region` VALUES (350300, '莆田市', 350000, '莆田', 2, '0594', '351100', '119.007558', '25.431011', 'Putian', '1', 0);
INSERT INTO `hh_region` VALUES (350302, '城厢区', 350300, '城厢', 3, '0594', '351100', '118.99462', '25.41872', 'Chengxiang', '1', 0);
INSERT INTO `hh_region` VALUES (350303, '涵江区', 350300, '涵江', 3, '0594', '351111', '119.11621', '25.45876', 'Hanjiang', '1', 0);
INSERT INTO `hh_region` VALUES (350304, '荔城区', 350300, '荔城', 3, '0594', '351100', '119.01339', '25.43369', 'Licheng', '1', 0);
INSERT INTO `hh_region` VALUES (350305, '秀屿区', 350300, '秀屿', 3, '0594', '351152', '119.10553', '25.31831', 'Xiuyu', '1', 0);
INSERT INTO `hh_region` VALUES (350322, '仙游县', 350300, '仙游', 3, '0594', '351200', '118.69177', '25.36214', 'Xianyou', '1', 0);
INSERT INTO `hh_region` VALUES (350400, '三明市', 350000, '三明', 2, '0598', '365000', '117.635001', '26.265444', 'Sanming', '1', 0);
INSERT INTO `hh_region` VALUES (350402, '梅列区', 350400, '梅列', 3, '0598', '365000', '117.64585', '26.27171', 'Meilie', '1', 0);
INSERT INTO `hh_region` VALUES (350403, '三元区', 350400, '三元', 3, '0598', '365001', '117.60788', '26.23372', 'Sanyuan', '1', 0);
INSERT INTO `hh_region` VALUES (350421, '明溪县', 350400, '明溪', 3, '0598', '365200', '117.20498', '26.35294', 'Mingxi', '1', 0);
INSERT INTO `hh_region` VALUES (350423, '清流县', 350400, '清流', 3, '0598', '365300', '116.8146', '26.17144', 'Qingliu', '1', 0);
INSERT INTO `hh_region` VALUES (350424, '宁化县', 350400, '宁化', 3, '0598', '365400', '116.66101', '26.25874', 'Ninghua', '1', 0);
INSERT INTO `hh_region` VALUES (350425, '大田县', 350400, '大田', 3, '0598', '366100', '117.8471', '25.6926', 'Datian', '1', 0);
INSERT INTO `hh_region` VALUES (350426, '尤溪县', 350400, '尤溪', 3, '0598', '365100', '118.19049', '26.17002', 'Youxi', '1', 0);
INSERT INTO `hh_region` VALUES (350427, '沙县', 350400, '沙县', 3, '0598', '365500', '117.79266', '26.39615', 'Shaxian', '1', 0);
INSERT INTO `hh_region` VALUES (350428, '将乐县', 350400, '将乐', 3, '0598', '353300', '117.47317', '26.72837', 'Jiangle', '1', 0);
INSERT INTO `hh_region` VALUES (350429, '泰宁县', 350400, '泰宁', 3, '0598', '354400', '117.17578', '26.9001', 'Taining', '1', 0);
INSERT INTO `hh_region` VALUES (350430, '建宁县', 350400, '建宁', 3, '0598', '354500', '116.84603', '26.83091', 'Jianning', '1', 0);
INSERT INTO `hh_region` VALUES (350481, '永安市', 350400, '永安', 3, '0598', '366000', '117.36517', '25.94136', 'Yong\'an', '1', 0);
INSERT INTO `hh_region` VALUES (350500, '泉州市', 350000, '泉州', 2, '0595', '362000', '118.589421', '24.908853', 'Quanzhou', '1', 0);
INSERT INTO `hh_region` VALUES (350502, '鲤城区', 350500, '鲤城', 3, '0595', '362000', '118.56591', '24.88741', 'Licheng', '1', 0);
INSERT INTO `hh_region` VALUES (350503, '丰泽区', 350500, '丰泽', 3, '0595', '362000', '118.61328', '24.89119', 'Fengze', '1', 0);
INSERT INTO `hh_region` VALUES (350504, '洛江区', 350500, '洛江', 3, '0595', '362011', '118.67111', '24.93984', 'Luojiang', '1', 0);
INSERT INTO `hh_region` VALUES (350505, '泉港区', 350500, '泉港', 3, '0595', '362114', '118.91586', '25.12005', 'Quangang', '1', 0);
INSERT INTO `hh_region` VALUES (350521, '惠安县', 350500, '惠安', 3, '0595', '362100', '118.79687', '25.03059', 'Hui\'an', '1', 0);
INSERT INTO `hh_region` VALUES (350524, '安溪县', 350500, '安溪', 3, '0595', '362400', '118.18719', '25.05627', 'Anxi', '1', 0);
INSERT INTO `hh_region` VALUES (350525, '永春县', 350500, '永春', 3, '0595', '362600', '118.29437', '25.32183', 'Yongchun', '1', 0);
INSERT INTO `hh_region` VALUES (350526, '德化县', 350500, '德化', 3, '0595', '362500', '118.24176', '25.49224', 'Dehua', '1', 0);
INSERT INTO `hh_region` VALUES (350527, '金门县', 350500, '金门', 3, '', '', '118.32263', '24.42922', 'Jinmen', '1', 0);
INSERT INTO `hh_region` VALUES (350581, '石狮市', 350500, '石狮', 3, '0595', '362700', '118.64779', '24.73242', 'Shishi', '1', 0);
INSERT INTO `hh_region` VALUES (350582, '晋江市', 350500, '晋江', 3, '0595', '362200', '118.55194', '24.78141', 'Jinjiang', '1', 0);
INSERT INTO `hh_region` VALUES (350583, '南安市', 350500, '南安', 3, '0595', '362300', '118.38589', '24.96055', 'Nan\'an', '1', 0);
INSERT INTO `hh_region` VALUES (350600, '漳州市', 350000, '漳州', 2, '0596', '363005', '117.661801', '24.510897', 'Zhangzhou', '1', 0);
INSERT INTO `hh_region` VALUES (350602, '芗城区', 350600, '芗城', 3, '0596', '363000', '117.65402', '24.51081', 'Xiangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (350603, '龙文区', 350600, '龙文', 3, '0596', '363005', '117.70971', '24.50323', 'Longwen', '1', 0);
INSERT INTO `hh_region` VALUES (350622, '云霄县', 350600, '云霄', 3, '0596', '363300', '117.34051', '23.95534', 'Yunxiao', '1', 0);
INSERT INTO `hh_region` VALUES (350623, '漳浦县', 350600, '漳浦', 3, '0596', '363200', '117.61367', '24.11706', 'Zhangpu', '1', 0);
INSERT INTO `hh_region` VALUES (350624, '诏安县', 350600, '诏安', 3, '0596', '363500', '117.17501', '23.71148', 'Zhao\'an', '1', 0);
INSERT INTO `hh_region` VALUES (350625, '长泰县', 350600, '长泰', 3, '0596', '363900', '117.75924', '24.62526', 'Changtai', '1', 0);
INSERT INTO `hh_region` VALUES (350626, '东山县', 350600, '东山', 3, '0596', '363400', '117.42822', '23.70109', 'Dongshan', '1', 0);
INSERT INTO `hh_region` VALUES (350627, '南靖县', 350600, '南靖', 3, '0596', '363600', '117.35736', '24.51448', 'Nanjing', '1', 0);
INSERT INTO `hh_region` VALUES (350628, '平和县', 350600, '平和', 3, '0596', '363700', '117.3124', '24.36395', 'Pinghe', '1', 0);
INSERT INTO `hh_region` VALUES (350629, '华安县', 350600, '华安', 3, '0596', '363800', '117.54077', '25.00563', 'Hua\'an', '1', 0);
INSERT INTO `hh_region` VALUES (350681, '龙海市', 350600, '龙海', 3, '0596', '363100', '117.81802', '24.44655', 'Longhai', '1', 0);
INSERT INTO `hh_region` VALUES (350700, '南平市', 350000, '南平', 2, '0599', '353000', '118.178459', '26.635627', 'Nanping', '1', 0);
INSERT INTO `hh_region` VALUES (350702, '延平区', 350700, '延平', 3, '0600', '353000', '118.18189', '26.63745', 'Yanping', '1', 0);
INSERT INTO `hh_region` VALUES (350703, '建阳区', 350700, '建阳', 3, '0599', '354200', '118.12267', '27.332067', 'Jianyang', '1', 0);
INSERT INTO `hh_region` VALUES (350721, '顺昌县', 350700, '顺昌', 3, '0605', '353200', '117.8103', '26.79298', 'Shunchang', '1', 0);
INSERT INTO `hh_region` VALUES (350722, '浦城县', 350700, '浦城', 3, '0606', '353400', '118.54007', '27.91888', 'Pucheng', '1', 0);
INSERT INTO `hh_region` VALUES (350723, '光泽县', 350700, '光泽', 3, '0607', '354100', '117.33346', '27.54231', 'Guangze', '1', 0);
INSERT INTO `hh_region` VALUES (350724, '松溪县', 350700, '松溪', 3, '0608', '353500', '118.78533', '27.52624', 'Songxi', '1', 0);
INSERT INTO `hh_region` VALUES (350725, '政和县', 350700, '政和', 3, '0609', '353600', '118.85571', '27.36769', 'Zhenghe', '1', 0);
INSERT INTO `hh_region` VALUES (350781, '邵武市', 350700, '邵武', 3, '0601', '354000', '117.4924', '27.34033', 'Shaowu', '1', 0);
INSERT INTO `hh_region` VALUES (350782, '武夷山市', 350700, '武夷山', 3, '0602', '354300', '118.03665', '27.75543', 'Wuyishan', '1', 0);
INSERT INTO `hh_region` VALUES (350783, '建瓯市', 350700, '建瓯', 3, '0603', '353100', '118.29766', '27.02301', 'Jianou', '1', 0);
INSERT INTO `hh_region` VALUES (350800, '龙岩市', 350000, '龙岩', 2, '0597', '364000', '117.02978', '25.091603', 'Longyan', '1', 0);
INSERT INTO `hh_region` VALUES (350802, '新罗区', 350800, '新罗', 3, '0597', '364000', '117.03693', '25.09834', 'Xinluo', '1', 0);
INSERT INTO `hh_region` VALUES (350821, '长汀县', 350800, '长汀', 3, '0597', '366300', '116.35888', '25.82773', 'Changting', '1', 0);
INSERT INTO `hh_region` VALUES (350822, '永定区', 350800, '永定', 3, '0597', '364100', '116.73199', '24.72302', 'Yongding', '1', 0);
INSERT INTO `hh_region` VALUES (350823, '上杭县', 350800, '上杭', 3, '0597', '364200', '116.42022', '25.04943', 'Shanghang', '1', 0);
INSERT INTO `hh_region` VALUES (350824, '武平县', 350800, '武平', 3, '0597', '364300', '116.10229', '25.09244', 'Wuping', '1', 0);
INSERT INTO `hh_region` VALUES (350825, '连城县', 350800, '连城', 3, '0597', '366200', '116.75454', '25.7103', 'Liancheng', '1', 0);
INSERT INTO `hh_region` VALUES (350881, '漳平市', 350800, '漳平', 3, '0597', '364400', '117.41992', '25.29109', 'Zhangping', '1', 0);
INSERT INTO `hh_region` VALUES (350900, '宁德市', 350000, '宁德', 2, '0593', '352100', '119.527082', '26.65924', 'Ningde', '1', 0);
INSERT INTO `hh_region` VALUES (350902, '蕉城区', 350900, '蕉城', 3, '0593', '352100', '119.52643', '26.66048', 'Jiaocheng', '1', 0);
INSERT INTO `hh_region` VALUES (350921, '霞浦县', 350900, '霞浦', 3, '0593', '355100', '119.99893', '26.88578', 'Xiapu', '1', 0);
INSERT INTO `hh_region` VALUES (350922, '古田县', 350900, '古田', 3, '0593', '352200', '118.74688', '26.57682', 'Gutian', '1', 0);
INSERT INTO `hh_region` VALUES (350923, '屏南县', 350900, '屏南', 3, '0593', '352300', '118.98861', '26.91099', 'Pingnan', '1', 0);
INSERT INTO `hh_region` VALUES (350924, '寿宁县', 350900, '寿宁', 3, '0593', '355500', '119.5039', '27.45996', 'Shouning', '1', 0);
INSERT INTO `hh_region` VALUES (350925, '周宁县', 350900, '周宁', 3, '0593', '355400', '119.33837', '27.10664', 'Zhouning', '1', 0);
INSERT INTO `hh_region` VALUES (350926, '柘荣县', 350900, '柘荣', 3, '0593', '355300', '119.89971', '27.23543', 'Zherong', '1', 0);
INSERT INTO `hh_region` VALUES (350981, '福安市', 350900, '福安', 3, '0593', '355000', '119.6495', '27.08673', 'Fu\'an', '1', 0);
INSERT INTO `hh_region` VALUES (350982, '福鼎市', 350900, '福鼎', 3, '0593', '355200', '120.21664', '27.3243', 'Fuding', '1', 0);
INSERT INTO `hh_region` VALUES (360000, '江西省', 100000, '江西', 1, '', '', '115.892151', '28.676493', 'Jiangxi', '1', 0);
INSERT INTO `hh_region` VALUES (360100, '南昌市', 360000, '南昌', 2, '0791', '330008', '115.892151', '28.676493', 'Nanchang', '1', 0);
INSERT INTO `hh_region` VALUES (360102, '东湖区', 360100, '东湖', 3, '0791', '330006', '115.8988', '28.68505', 'Donghu', '1', 0);
INSERT INTO `hh_region` VALUES (360103, '西湖区', 360100, '西湖', 3, '0791', '330009', '115.87728', '28.65688', 'Xihu', '1', 0);
INSERT INTO `hh_region` VALUES (360104, '青云谱区', 360100, '青云谱', 3, '0791', '330001', '115.915', '28.63199', 'Qingyunpu', '1', 0);
INSERT INTO `hh_region` VALUES (360105, '湾里区', 360100, '湾里', 3, '0791', '330004', '115.73104', '28.71529', 'Wanli', '1', 0);
INSERT INTO `hh_region` VALUES (360111, '青山湖区', 360100, '青山湖', 3, '0791', '330029', '115.9617', '28.68206', 'Qingshanhu', '1', 0);
INSERT INTO `hh_region` VALUES (360121, '南昌县', 360100, '南昌', 3, '0791', '330200', '115.94393', '28.54559', 'Nanchang', '1', 0);
INSERT INTO `hh_region` VALUES (360122, '新建县', 360100, '新建', 3, '0791', '330100', '115.81546', '28.69248', 'Xinjian', '1', 0);
INSERT INTO `hh_region` VALUES (360123, '安义县', 360100, '安义', 3, '0791', '330500', '115.54879', '28.84602', 'Anyi', '1', 0);
INSERT INTO `hh_region` VALUES (360124, '进贤县', 360100, '进贤', 3, '0791', '331700', '116.24087', '28.37679', 'Jinxian', '1', 0);
INSERT INTO `hh_region` VALUES (360200, '景德镇市', 360000, '景德镇', 2, '0798', '333000', '117.214664', '29.29256', 'Jingdezhen', '1', 0);
INSERT INTO `hh_region` VALUES (360202, '昌江区', 360200, '昌江', 3, '0799', '333000', '117.18359', '29.27321', 'Changjiang', '1', 0);
INSERT INTO `hh_region` VALUES (360203, '珠山区', 360200, '珠山', 3, '0800', '333000', '117.20233', '29.30127', 'Zhushan', '1', 0);
INSERT INTO `hh_region` VALUES (360222, '浮梁县', 360200, '浮梁', 3, '0802', '333400', '117.21517', '29.35156', 'Fuliang', '1', 0);
INSERT INTO `hh_region` VALUES (360281, '乐平市', 360200, '乐平', 3, '0801', '333300', '117.12887', '28.96295', 'Leping', '1', 0);
INSERT INTO `hh_region` VALUES (360300, '萍乡市', 360000, '萍乡', 2, '0799', '337000', '113.852186', '27.622946', 'Pingxiang', '1', 0);
INSERT INTO `hh_region` VALUES (360302, '安源区', 360300, '安源', 3, '0800', '337000', '113.89135', '27.61653', 'Anyuan', '1', 0);
INSERT INTO `hh_region` VALUES (360313, '湘东区', 360300, '湘东', 3, '0801', '337016', '113.73294', '27.64007', 'Xiangdong', '1', 0);
INSERT INTO `hh_region` VALUES (360321, '莲花县', 360300, '莲花', 3, '0802', '337100', '113.96142', '27.12866', 'Lianhua', '1', 0);
INSERT INTO `hh_region` VALUES (360322, '上栗县', 360300, '上栗', 3, '0803', '337009', '113.79403', '27.87467', 'Shangli', '1', 0);
INSERT INTO `hh_region` VALUES (360323, '芦溪县', 360300, '芦溪', 3, '0804', '337053', '114.02951', '27.63063', 'Luxi', '1', 0);
INSERT INTO `hh_region` VALUES (360400, '九江市', 360000, '九江', 2, '0792', '332000', '115.992811', '29.712034', 'Jiujiang', '1', 0);
INSERT INTO `hh_region` VALUES (360402, '庐山区', 360400, '庐山', 3, '0792', '332005', '115.98904', '29.67177', 'Lushan', '1', 0);
INSERT INTO `hh_region` VALUES (360403, '浔阳区', 360400, '浔阳', 3, '0792', '332000', '115.98986', '29.72786', 'Xunyang', '1', 0);
INSERT INTO `hh_region` VALUES (360421, '九江县', 360400, '九江', 3, '0792', '332100', '115.91128', '29.60852', 'Jiujiang', '1', 0);
INSERT INTO `hh_region` VALUES (360423, '武宁县', 360400, '武宁', 3, '0792', '332300', '115.10061', '29.2584', 'Wuning', '1', 0);
INSERT INTO `hh_region` VALUES (360424, '修水县', 360400, '修水', 3, '0792', '332400', '114.54684', '29.02539', 'Xiushui', '1', 0);
INSERT INTO `hh_region` VALUES (360425, '永修县', 360400, '永修', 3, '0792', '330300', '115.80911', '29.02093', 'Yongxiu', '1', 0);
INSERT INTO `hh_region` VALUES (360426, '德安县', 360400, '德安', 3, '0792', '330400', '115.75601', '29.31341', 'De\'an', '1', 0);
INSERT INTO `hh_region` VALUES (360427, '星子县', 360400, '星子', 3, '0792', '332800', '116.04492', '29.44608', 'Xingzi', '1', 0);
INSERT INTO `hh_region` VALUES (360428, '都昌县', 360400, '都昌', 3, '0792', '332600', '116.20401', '29.27327', 'Duchang', '1', 0);
INSERT INTO `hh_region` VALUES (360429, '湖口县', 360400, '湖口', 3, '0792', '332500', '116.21853', '29.73818', 'Hukou', '1', 0);
INSERT INTO `hh_region` VALUES (360430, '彭泽县', 360400, '彭泽', 3, '0792', '332700', '116.55011', '29.89589', 'Pengze', '1', 0);
INSERT INTO `hh_region` VALUES (360481, '瑞昌市', 360400, '瑞昌', 3, '0792', '332200', '115.66705', '29.67183', 'Ruichang', '1', 0);
INSERT INTO `hh_region` VALUES (360482, '共青城市', 360400, '共青城', 3, '0792', '332020', '115.801939', '29.238785', 'Gongqingcheng', '1', 0);
INSERT INTO `hh_region` VALUES (360500, '新余市', 360000, '新余', 2, '0790', '338025', '114.930835', '27.810834', 'Xinyu', '1', 0);
INSERT INTO `hh_region` VALUES (360502, '渝水区', 360500, '渝水', 3, '0790', '338025', '114.944', '27.80098', 'Yushui', '1', 0);
INSERT INTO `hh_region` VALUES (360521, '分宜县', 360500, '分宜', 3, '0790', '336600', '114.69189', '27.81475', 'Fenyi', '1', 0);
INSERT INTO `hh_region` VALUES (360600, '鹰潭市', 360000, '鹰潭', 2, '0701', '335000', '117.033838', '28.238638', 'Yingtan', '1', 0);
INSERT INTO `hh_region` VALUES (360602, '月湖区', 360600, '月湖', 3, '0701', '335000', '117.03732', '28.23913', 'Yuehu', '1', 0);
INSERT INTO `hh_region` VALUES (360622, '余江县', 360600, '余江', 3, '0701', '335200', '116.81851', '28.21034', 'Yujiang', '1', 0);
INSERT INTO `hh_region` VALUES (360681, '贵溪市', 360600, '贵溪', 3, '0701', '335400', '117.24246', '28.2926', 'Guixi', '1', 0);
INSERT INTO `hh_region` VALUES (360700, '赣州市', 360000, '赣州', 2, '0797', '341000', '114.940278', '25.85097', 'Ganzhou', '1', 0);
INSERT INTO `hh_region` VALUES (360702, '章贡区', 360700, '章贡', 3, '0797', '341000', '114.94284', '25.8624', 'Zhanggong', '1', 0);
INSERT INTO `hh_region` VALUES (360703, '南康区', 360700, '南康', 3, '0797', '341400', '114.756933', '25.661721', 'Nankang', '1', 0);
INSERT INTO `hh_region` VALUES (360721, '赣县', 360700, '赣县', 3, '0797', '341100', '115.01171', '25.86149', 'Ganxian', '1', 0);
INSERT INTO `hh_region` VALUES (360722, '信丰县', 360700, '信丰', 3, '0797', '341600', '114.92279', '25.38612', 'Xinfeng', '1', 0);
INSERT INTO `hh_region` VALUES (360723, '大余县', 360700, '大余', 3, '0797', '341500', '114.35757', '25.39561', 'Dayu', '1', 0);
INSERT INTO `hh_region` VALUES (360724, '上犹县', 360700, '上犹', 3, '0797', '341200', '114.54138', '25.79567', 'Shangyou', '1', 0);
INSERT INTO `hh_region` VALUES (360725, '崇义县', 360700, '崇义', 3, '0797', '341300', '114.30835', '25.68186', 'Chongyi', '1', 0);
INSERT INTO `hh_region` VALUES (360726, '安远县', 360700, '安远', 3, '0797', '342100', '115.39483', '25.1371', 'Anyuan', '1', 0);
INSERT INTO `hh_region` VALUES (360727, '龙南县', 360700, '龙南', 3, '0797', '341700', '114.78994', '24.91086', 'Longnan', '1', 0);
INSERT INTO `hh_region` VALUES (360728, '定南县', 360700, '定南', 3, '0797', '341900', '115.02713', '24.78395', 'Dingnan', '1', 0);
INSERT INTO `hh_region` VALUES (360729, '全南县', 360700, '全南', 3, '0797', '341800', '114.5292', '24.74324', 'Quannan', '1', 0);
INSERT INTO `hh_region` VALUES (360730, '宁都县', 360700, '宁都', 3, '0797', '342800', '116.01565', '26.47227', 'Ningdu', '1', 0);
INSERT INTO `hh_region` VALUES (360731, '于都县', 360700, '于都', 3, '0797', '342300', '115.41415', '25.95257', 'Yudu', '1', 0);
INSERT INTO `hh_region` VALUES (360732, '兴国县', 360700, '兴国', 3, '0797', '342400', '115.36309', '26.33776', 'Xingguo', '1', 0);
INSERT INTO `hh_region` VALUES (360733, '会昌县', 360700, '会昌', 3, '0797', '342600', '115.78555', '25.60068', 'Huichang', '1', 0);
INSERT INTO `hh_region` VALUES (360734, '寻乌县', 360700, '寻乌', 3, '0797', '342200', '115.64852', '24.95513', 'Xunwu', '1', 0);
INSERT INTO `hh_region` VALUES (360735, '石城县', 360700, '石城', 3, '0797', '342700', '116.3442', '26.32617', 'Shicheng', '1', 0);
INSERT INTO `hh_region` VALUES (360781, '瑞金市', 360700, '瑞金', 3, '0797', '342500', '116.02703', '25.88557', 'Ruijin', '1', 0);
INSERT INTO `hh_region` VALUES (360800, '吉安市', 360000, '吉安', 2, '0796', '343000', '114.986373', '27.111699', 'Ji\'an', '1', 0);
INSERT INTO `hh_region` VALUES (360802, '吉州区', 360800, '吉州', 3, '0796', '343000', '114.97598', '27.10669', 'Jizhou', '1', 0);
INSERT INTO `hh_region` VALUES (360803, '青原区', 360800, '青原', 3, '0796', '343009', '115.01747', '27.10577', 'Qingyuan', '1', 0);
INSERT INTO `hh_region` VALUES (360821, '吉安县', 360800, '吉安', 3, '0796', '343100', '114.90695', '27.04048', 'Ji\'an', '1', 0);
INSERT INTO `hh_region` VALUES (360822, '吉水县', 360800, '吉水', 3, '0796', '331600', '115.1343', '27.21071', 'Jishui', '1', 0);
INSERT INTO `hh_region` VALUES (360823, '峡江县', 360800, '峡江', 3, '0796', '331409', '115.31723', '27.576', 'Xiajiang', '1', 0);
INSERT INTO `hh_region` VALUES (360824, '新干县', 360800, '新干', 3, '0796', '331300', '115.39306', '27.74092', 'Xingan', '1', 0);
INSERT INTO `hh_region` VALUES (360825, '永丰县', 360800, '永丰', 3, '0796', '331500', '115.44238', '27.31785', 'Yongfeng', '1', 0);
INSERT INTO `hh_region` VALUES (360826, '泰和县', 360800, '泰和', 3, '0796', '343700', '114.90789', '26.79113', 'Taihe', '1', 0);
INSERT INTO `hh_region` VALUES (360827, '遂川县', 360800, '遂川', 3, '0796', '343900', '114.51629', '26.32598', 'Suichuan', '1', 0);
INSERT INTO `hh_region` VALUES (360828, '万安县', 360800, '万安', 3, '0796', '343800', '114.78659', '26.45931', 'Wan\'an', '1', 0);
INSERT INTO `hh_region` VALUES (360829, '安福县', 360800, '安福', 3, '0796', '343200', '114.61956', '27.39276', 'Anfu', '1', 0);
INSERT INTO `hh_region` VALUES (360830, '永新县', 360800, '永新', 3, '0796', '343400', '114.24246', '26.94488', 'Yongxin', '1', 0);
INSERT INTO `hh_region` VALUES (360881, '井冈山市', 360800, '井冈山', 3, '0796', '343600', '114.28949', '26.74804', 'Jinggangshan', '1', 0);
INSERT INTO `hh_region` VALUES (360900, '宜春市', 360000, '宜春', 2, '0795', '336000', '114.391136', '27.8043', 'Yichun', '1', 0);
INSERT INTO `hh_region` VALUES (360902, '袁州区', 360900, '袁州', 3, '0795', '336000', '114.38246', '27.79649', 'Yuanzhou', '1', 0);
INSERT INTO `hh_region` VALUES (360921, '奉新县', 360900, '奉新', 3, '0795', '330700', '115.40036', '28.6879', 'Fengxin', '1', 0);
INSERT INTO `hh_region` VALUES (360922, '万载县', 360900, '万载', 3, '0795', '336100', '114.4458', '28.10656', 'Wanzai', '1', 0);
INSERT INTO `hh_region` VALUES (360923, '上高县', 360900, '上高', 3, '0795', '336400', '114.92459', '28.23423', 'Shanggao', '1', 0);
INSERT INTO `hh_region` VALUES (360924, '宜丰县', 360900, '宜丰', 3, '0795', '336300', '114.7803', '28.38555', 'Yifeng', '1', 0);
INSERT INTO `hh_region` VALUES (360925, '靖安县', 360900, '靖安', 3, '0795', '330600', '115.36279', '28.86167', 'Jing\'an', '1', 0);
INSERT INTO `hh_region` VALUES (360926, '铜鼓县', 360900, '铜鼓', 3, '0795', '336200', '114.37036', '28.52311', 'Tonggu', '1', 0);
INSERT INTO `hh_region` VALUES (360981, '丰城市', 360900, '丰城', 3, '0795', '331100', '115.77114', '28.15918', 'Fengcheng', '1', 0);
INSERT INTO `hh_region` VALUES (360982, '樟树市', 360900, '樟树', 3, '0795', '331200', '115.5465', '28.05332', 'Zhangshu', '1', 0);
INSERT INTO `hh_region` VALUES (360983, '高安市', 360900, '高安', 3, '0795', '330800', '115.3753', '28.4178', 'Gao\'an', '1', 0);
INSERT INTO `hh_region` VALUES (361000, '抚州市', 360000, '抚州', 2, '0794', '344000', '116.358351', '27.98385', 'Fuzhou', '1', 0);
INSERT INTO `hh_region` VALUES (361002, '临川区', 361000, '临川', 3, '0794', '344000', '116.35919', '27.97721', 'Linchuan', '1', 0);
INSERT INTO `hh_region` VALUES (361021, '南城县', 361000, '南城', 3, '0794', '344700', '116.64419', '27.55381', 'Nancheng', '1', 0);
INSERT INTO `hh_region` VALUES (361022, '黎川县', 361000, '黎川', 3, '0794', '344600', '116.90771', '27.28232', 'Lichuan', '1', 0);
INSERT INTO `hh_region` VALUES (361023, '南丰县', 361000, '南丰', 3, '0794', '344500', '116.5256', '27.21842', 'Nanfeng', '1', 0);
INSERT INTO `hh_region` VALUES (361024, '崇仁县', 361000, '崇仁', 3, '0794', '344200', '116.06021', '27.75962', 'Chongren', '1', 0);
INSERT INTO `hh_region` VALUES (361025, '乐安县', 361000, '乐安', 3, '0794', '344300', '115.83108', '27.42812', 'Le\'an', '1', 0);
INSERT INTO `hh_region` VALUES (361026, '宜黄县', 361000, '宜黄', 3, '0794', '344400', '116.23626', '27.55487', 'Yihuang', '1', 0);
INSERT INTO `hh_region` VALUES (361027, '金溪县', 361000, '金溪', 3, '0794', '344800', '116.77392', '27.90753', 'Jinxi', '1', 0);
INSERT INTO `hh_region` VALUES (361028, '资溪县', 361000, '资溪', 3, '0794', '335300', '117.06939', '27.70493', 'Zixi', '1', 0);
INSERT INTO `hh_region` VALUES (361029, '东乡县', 361000, '东乡', 3, '0794', '331800', '116.59039', '28.23614', 'Dongxiang', '1', 0);
INSERT INTO `hh_region` VALUES (361030, '广昌县', 361000, '广昌', 3, '0794', '344900', '116.32547', '26.8341', 'Guangchang', '1', 0);
INSERT INTO `hh_region` VALUES (361100, '上饶市', 360000, '上饶', 2, '0793', '334000', '117.971185', '28.44442', 'Shangrao', '1', 0);
INSERT INTO `hh_region` VALUES (361102, '信州区', 361100, '信州', 3, '0793', '334000', '117.96682', '28.43121', 'Xinzhou', '1', 0);
INSERT INTO `hh_region` VALUES (361121, '上饶县', 361100, '上饶', 3, '0793', '334100', '117.90884', '28.44856', 'Shangrao', '1', 0);
INSERT INTO `hh_region` VALUES (361122, '广丰县', 361100, '广丰', 3, '0793', '334600', '118.19158', '28.43766', 'Guangfeng', '1', 0);
INSERT INTO `hh_region` VALUES (361123, '玉山县', 361100, '玉山', 3, '0793', '334700', '118.24462', '28.6818', 'Yushan', '1', 0);
INSERT INTO `hh_region` VALUES (361124, '铅山县', 361100, '铅山', 3, '0793', '334500', '117.70996', '28.31549', 'Yanshan', '1', 0);
INSERT INTO `hh_region` VALUES (361125, '横峰县', 361100, '横峰', 3, '0793', '334300', '117.5964', '28.40716', 'Hengfeng', '1', 0);
INSERT INTO `hh_region` VALUES (361126, '弋阳县', 361100, '弋阳', 3, '0793', '334400', '117.45929', '28.37451', 'Yiyang', '1', 0);
INSERT INTO `hh_region` VALUES (361127, '余干县', 361100, '余干', 3, '0793', '335100', '116.69555', '28.70206', 'Yugan', '1', 0);
INSERT INTO `hh_region` VALUES (361128, '鄱阳县', 361100, '鄱阳', 3, '0793', '333100', '116.69967', '29.0118', 'Poyang', '1', 0);
INSERT INTO `hh_region` VALUES (361129, '万年县', 361100, '万年', 3, '0793', '335500', '117.06884', '28.69537', 'Wannian', '1', 0);
INSERT INTO `hh_region` VALUES (361130, '婺源县', 361100, '婺源', 3, '0793', '333200', '117.86105', '29.24841', 'Wuyuan', '1', 0);
INSERT INTO `hh_region` VALUES (361181, '德兴市', 361100, '德兴', 3, '0793', '334200', '117.57919', '28.94736', 'Dexing', '1', 0);
INSERT INTO `hh_region` VALUES (370000, '山东省', 100000, '山东', 1, '', '', '117.000923', '36.675807', 'Shandong', '1', 0);
INSERT INTO `hh_region` VALUES (370100, '济南市', 370000, '济南', 2, '0531', '250001', '117.000923', '36.675807', 'Jinan', '1', 0);
INSERT INTO `hh_region` VALUES (370102, '历下区', 370100, '历下', 3, '0531', '250014', '117.0768', '36.66661', 'Lixia', '1', 0);
INSERT INTO `hh_region` VALUES (370103, '市中区', 370100, '市中区', 3, '0531', '250001', '116.99741', '36.65101', 'Shizhongqu', '1', 0);
INSERT INTO `hh_region` VALUES (370104, '槐荫区', 370100, '槐荫', 3, '0531', '250117', '116.90075', '36.65136', 'Huaiyin', '1', 0);
INSERT INTO `hh_region` VALUES (370105, '天桥区', 370100, '天桥', 3, '0531', '250031', '116.98749', '36.67801', 'Tianqiao', '1', 0);
INSERT INTO `hh_region` VALUES (370112, '历城区', 370100, '历城', 3, '0531', '250100', '117.06509', '36.67995', 'Licheng', '1', 0);
INSERT INTO `hh_region` VALUES (370113, '长清区', 370100, '长清', 3, '0531', '250300', '116.75192', '36.55352', 'Changqing', '1', 0);
INSERT INTO `hh_region` VALUES (370124, '平阴县', 370100, '平阴', 3, '0531', '250400', '116.45587', '36.28955', 'Pingyin', '1', 0);
INSERT INTO `hh_region` VALUES (370125, '济阳县', 370100, '济阳', 3, '0531', '251400', '117.17327', '36.97845', 'Jiyang', '1', 0);
INSERT INTO `hh_region` VALUES (370126, '商河县', 370100, '商河', 3, '0531', '251600', '117.15722', '37.31119', 'Shanghe', '1', 0);
INSERT INTO `hh_region` VALUES (370181, '章丘市', 370100, '章丘', 3, '0531', '250200', '117.53677', '36.71392', 'Zhangqiu', '1', 0);
INSERT INTO `hh_region` VALUES (370200, '青岛市', 370000, '青岛', 2, '0532', '266001', '120.369557', '36.094406', 'Qingdao', '1', 0);
INSERT INTO `hh_region` VALUES (370202, '市南区', 370200, '市南', 3, '0532', '266001', '120.38773', '36.06671', 'Shinan', '1', 0);
INSERT INTO `hh_region` VALUES (370203, '市北区', 370200, '市北', 3, '0532', '266011', '120.37469', '36.08734', 'Shibei', '1', 0);
INSERT INTO `hh_region` VALUES (370211, '黄岛区', 370200, '黄岛', 3, '0532', '266500', '120.19775', '35.96065', 'Huangdao', '1', 0);
INSERT INTO `hh_region` VALUES (370212, '崂山区', 370200, '崂山', 3, '0532', '266100', '120.46923', '36.10717', 'Laoshan', '1', 0);
INSERT INTO `hh_region` VALUES (370213, '李沧区', 370200, '李沧', 3, '0532', '266021', '120.43286', '36.14502', 'Licang', '1', 0);
INSERT INTO `hh_region` VALUES (370214, '城阳区', 370200, '城阳', 3, '0532', '266041', '120.39621', '36.30735', 'Chengyang', '1', 0);
INSERT INTO `hh_region` VALUES (370281, '胶州市', 370200, '胶州', 3, '0532', '266300', '120.0335', '36.26442', 'Jiaozhou', '1', 0);
INSERT INTO `hh_region` VALUES (370282, '即墨市', 370200, '即墨', 3, '0532', '266200', '120.44699', '36.38907', 'Jimo', '1', 0);
INSERT INTO `hh_region` VALUES (370283, '平度市', 370200, '平度', 3, '0532', '266700', '119.95996', '36.78688', 'Pingdu', '1', 0);
INSERT INTO `hh_region` VALUES (370285, '莱西市', 370200, '莱西', 3, '0532', '266600', '120.51773', '36.88804', 'Laixi', '1', 0);
INSERT INTO `hh_region` VALUES (370286, '西海岸新区', 370200, '西海岸', 3, '0532', '266500', '120.19775', '35.96065', 'Xihai\'an', '1', 0);
INSERT INTO `hh_region` VALUES (370300, '淄博市', 370000, '淄博', 2, '0533', '255039', '118.047648', '36.814939', 'Zibo', '1', 0);
INSERT INTO `hh_region` VALUES (370302, '淄川区', 370300, '淄川', 3, '0533', '255100', '117.96655', '36.64339', 'Zichuan', '1', 0);
INSERT INTO `hh_region` VALUES (370303, '张店区', 370300, '张店', 3, '0533', '255022', '118.01788', '36.80676', 'Zhangdian', '1', 0);
INSERT INTO `hh_region` VALUES (370304, '博山区', 370300, '博山', 3, '0533', '255200', '117.86166', '36.49469', 'Boshan', '1', 0);
INSERT INTO `hh_region` VALUES (370305, '临淄区', 370300, '临淄', 3, '0533', '255400', '118.30966', '36.8259', 'Linzi', '1', 0);
INSERT INTO `hh_region` VALUES (370306, '周村区', 370300, '周村', 3, '0533', '255300', '117.86969', '36.80322', 'Zhoucun', '1', 0);
INSERT INTO `hh_region` VALUES (370321, '桓台县', 370300, '桓台', 3, '0533', '256400', '118.09698', '36.96036', 'Huantai', '1', 0);
INSERT INTO `hh_region` VALUES (370322, '高青县', 370300, '高青', 3, '0533', '256300', '117.82708', '37.17197', 'Gaoqing', '1', 0);
INSERT INTO `hh_region` VALUES (370323, '沂源县', 370300, '沂源', 3, '0533', '256100', '118.17105', '36.18536', 'Yiyuan', '1', 0);
INSERT INTO `hh_region` VALUES (370400, '枣庄市', 370000, '枣庄', 2, '0632', '277101', '117.557964', '34.856424', 'Zaozhuang', '1', 0);
INSERT INTO `hh_region` VALUES (370402, '市中区', 370400, '市中区', 3, '0632', '277101', '117.55603', '34.86391', 'Shizhongqu', '1', 0);
INSERT INTO `hh_region` VALUES (370403, '薛城区', 370400, '薛城', 3, '0632', '277000', '117.26318', '34.79498', 'Xuecheng', '1', 0);
INSERT INTO `hh_region` VALUES (370404, '峄城区', 370400, '峄城', 3, '0632', '277300', '117.59057', '34.77225', 'Yicheng', '1', 0);
INSERT INTO `hh_region` VALUES (370405, '台儿庄区', 370400, '台儿庄', 3, '0632', '277400', '117.73452', '34.56363', 'Taierzhuang', '1', 0);
INSERT INTO `hh_region` VALUES (370406, '山亭区', 370400, '山亭', 3, '0632', '277200', '117.4663', '35.09541', 'Shanting', '1', 0);
INSERT INTO `hh_region` VALUES (370481, '滕州市', 370400, '滕州', 3, '0632', '277500', '117.165', '35.10534', 'Tengzhou', '1', 0);
INSERT INTO `hh_region` VALUES (370500, '东营市', 370000, '东营', 2, '0546', '257093', '118.4963', '37.461266', 'Dongying', '1', 0);
INSERT INTO `hh_region` VALUES (370502, '东营区', 370500, '东营', 3, '0546', '257029', '118.5816', '37.44875', 'Dongying', '1', 0);
INSERT INTO `hh_region` VALUES (370503, '河口区', 370500, '河口', 3, '0546', '257200', '118.5249', '37.88541', 'Hekou', '1', 0);
INSERT INTO `hh_region` VALUES (370521, '垦利县', 370500, '垦利', 3, '0546', '257500', '118.54815', '37.58825', 'Kenli', '1', 0);
INSERT INTO `hh_region` VALUES (370522, '利津县', 370500, '利津', 3, '0546', '257400', '118.25637', '37.49157', 'Lijin', '1', 0);
INSERT INTO `hh_region` VALUES (370523, '广饶县', 370500, '广饶', 3, '0546', '257300', '118.40704', '37.05381', 'Guangrao', '1', 0);
INSERT INTO `hh_region` VALUES (370600, '烟台市', 370000, '烟台', 2, '0635', '264010', '121.391382', '37.539297', 'Yantai', '1', 0);
INSERT INTO `hh_region` VALUES (370602, '芝罘区', 370600, '芝罘', 3, '0635', '264001', '121.40023', '37.54064', 'Zhifu', '1', 0);
INSERT INTO `hh_region` VALUES (370611, '福山区', 370600, '福山', 3, '0635', '265500', '121.26812', '37.49841', 'Fushan', '1', 0);
INSERT INTO `hh_region` VALUES (370612, '牟平区', 370600, '牟平', 3, '0635', '264100', '121.60067', '37.38846', 'Muping', '1', 0);
INSERT INTO `hh_region` VALUES (370613, '莱山区', 370600, '莱山', 3, '0635', '264600', '121.44512', '37.51165', 'Laishan', '1', 0);
INSERT INTO `hh_region` VALUES (370634, '长岛县', 370600, '长岛', 3, '0635', '265800', '120.738', '37.91754', 'Changdao', '1', 0);
INSERT INTO `hh_region` VALUES (370681, '龙口市', 370600, '龙口', 3, '0635', '265700', '120.50634', '37.64064', 'Longkou', '1', 0);
INSERT INTO `hh_region` VALUES (370682, '莱阳市', 370600, '莱阳', 3, '0635', '265200', '120.71066', '36.98012', 'Laiyang', '1', 0);
INSERT INTO `hh_region` VALUES (370683, '莱州市', 370600, '莱州', 3, '0635', '261400', '119.94137', '37.17806', 'Laizhou', '1', 0);
INSERT INTO `hh_region` VALUES (370684, '蓬莱市', 370600, '蓬莱', 3, '0635', '265600', '120.75988', '37.81119', 'Penglai', '1', 0);
INSERT INTO `hh_region` VALUES (370685, '招远市', 370600, '招远', 3, '0635', '265400', '120.40481', '37.36269', 'Zhaoyuan', '1', 0);
INSERT INTO `hh_region` VALUES (370686, '栖霞市', 370600, '栖霞', 3, '0635', '265300', '120.85025', '37.33571', 'Qixia', '1', 0);
INSERT INTO `hh_region` VALUES (370687, '海阳市', 370600, '海阳', 3, '0635', '265100', '121.15976', '36.77622', 'Haiyang', '1', 0);
INSERT INTO `hh_region` VALUES (370700, '潍坊市', 370000, '潍坊', 2, '0536', '261041', '119.107078', '36.70925', 'Weifang', '1', 0);
INSERT INTO `hh_region` VALUES (370702, '潍城区', 370700, '潍城', 3, '0536', '261021', '119.10582', '36.7139', 'Weicheng', '1', 0);
INSERT INTO `hh_region` VALUES (370703, '寒亭区', 370700, '寒亭', 3, '0536', '261100', '119.21832', '36.77504', 'Hanting', '1', 0);
INSERT INTO `hh_region` VALUES (370704, '坊子区', 370700, '坊子', 3, '0536', '261200', '119.16476', '36.65218', 'Fangzi', '1', 0);
INSERT INTO `hh_region` VALUES (370705, '奎文区', 370700, '奎文', 3, '0536', '261031', '119.12532', '36.70723', 'Kuiwen', '1', 0);
INSERT INTO `hh_region` VALUES (370724, '临朐县', 370700, '临朐', 3, '0536', '262600', '118.544', '36.51216', 'Linqu', '1', 0);
INSERT INTO `hh_region` VALUES (370725, '昌乐县', 370700, '昌乐', 3, '0536', '262400', '118.83017', '36.7078', 'Changle', '1', 0);
INSERT INTO `hh_region` VALUES (370781, '青州市', 370700, '青州', 3, '0536', '262500', '118.47915', '36.68505', 'Qingzhou', '1', 0);
INSERT INTO `hh_region` VALUES (370782, '诸城市', 370700, '诸城', 3, '0536', '262200', '119.40988', '35.99662', 'Zhucheng', '1', 0);
INSERT INTO `hh_region` VALUES (370783, '寿光市', 370700, '寿光', 3, '0536', '262700', '118.74047', '36.88128', 'Shouguang', '1', 0);
INSERT INTO `hh_region` VALUES (370784, '安丘市', 370700, '安丘', 3, '0536', '262100', '119.2189', '36.47847', 'Anqiu', '1', 0);
INSERT INTO `hh_region` VALUES (370785, '高密市', 370700, '高密', 3, '0536', '261500', '119.75701', '36.38397', 'Gaomi', '1', 0);
INSERT INTO `hh_region` VALUES (370786, '昌邑市', 370700, '昌邑', 3, '0536', '261300', '119.39767', '36.86008', 'Changyi', '1', 0);
INSERT INTO `hh_region` VALUES (370800, '济宁市', 370000, '济宁', 2, '0537', '272119', '116.587245', '35.415393', 'Jining', '1', 0);
INSERT INTO `hh_region` VALUES (370811, '任城区', 370800, '任城', 3, '0537', '272113', '116.59504', '35.40659', 'Rencheng', '1', 0);
INSERT INTO `hh_region` VALUES (370812, '兖州区', 370800, '兖州', 3, '0537', '272000', '116.826546', '35.552305', 'Yanzhou ', '1', 0);
INSERT INTO `hh_region` VALUES (370826, '微山县', 370800, '微山', 3, '0537', '277600', '117.12875', '34.80712', 'Weishan', '1', 0);
INSERT INTO `hh_region` VALUES (370827, '鱼台县', 370800, '鱼台', 3, '0537', '272300', '116.64761', '34.99674', 'Yutai', '1', 0);
INSERT INTO `hh_region` VALUES (370828, '金乡县', 370800, '金乡', 3, '0537', '272200', '116.31146', '35.065', 'Jinxiang', '1', 0);
INSERT INTO `hh_region` VALUES (370829, '嘉祥县', 370800, '嘉祥', 3, '0537', '272400', '116.34249', '35.40836', 'Jiaxiang', '1', 0);
INSERT INTO `hh_region` VALUES (370830, '汶上县', 370800, '汶上', 3, '0537', '272501', '116.48742', '35.73295', 'Wenshang', '1', 0);
INSERT INTO `hh_region` VALUES (370831, '泗水县', 370800, '泗水', 3, '0537', '273200', '117.27948', '35.66113', 'Sishui', '1', 0);
INSERT INTO `hh_region` VALUES (370832, '梁山县', 370800, '梁山', 3, '0537', '272600', '116.09683', '35.80322', 'Liangshan', '1', 0);
INSERT INTO `hh_region` VALUES (370881, '曲阜市', 370800, '曲阜', 3, '0537', '273100', '116.98645', '35.58091', 'Qufu', '1', 0);
INSERT INTO `hh_region` VALUES (370883, '邹城市', 370800, '邹城', 3, '0537', '273500', '116.97335', '35.40531', 'Zoucheng', '1', 0);
INSERT INTO `hh_region` VALUES (370900, '泰安市', 370000, '泰安', 2, '0538', '271000', '117.129063', '36.194968', 'Tai\'an', '1', 0);
INSERT INTO `hh_region` VALUES (370902, '泰山区', 370900, '泰山', 3, '0538', '271000', '117.13446', '36.19411', 'Taishan', '1', 0);
INSERT INTO `hh_region` VALUES (370911, '岱岳区', 370900, '岱岳', 3, '0538', '271000', '117.04174', '36.1875', 'Daiyue', '1', 0);
INSERT INTO `hh_region` VALUES (370921, '宁阳县', 370900, '宁阳', 3, '0538', '271400', '116.80542', '35.7599', 'Ningyang', '1', 0);
INSERT INTO `hh_region` VALUES (370923, '东平县', 370900, '东平', 3, '0538', '271500', '116.47113', '35.93792', 'Dongping', '1', 0);
INSERT INTO `hh_region` VALUES (370982, '新泰市', 370900, '新泰', 3, '0538', '271200', '117.76959', '35.90887', 'Xintai', '1', 0);
INSERT INTO `hh_region` VALUES (370983, '肥城市', 370900, '肥城', 3, '0538', '271600', '116.76815', '36.18247', 'Feicheng', '1', 0);
INSERT INTO `hh_region` VALUES (371000, '威海市', 370000, '威海', 2, '0631', '264200', '122.116394', '37.509691', 'Weihai', '1', 0);
INSERT INTO `hh_region` VALUES (371002, '环翠区', 371000, '环翠', 3, '0631', '264200', '122.12344', '37.50199', 'Huancui', '1', 0);
INSERT INTO `hh_region` VALUES (371003, '文登区', 371000, '文登', 3, '0631', '266440', '122.057139', '37.196211', 'Wendeng', '1', 0);
INSERT INTO `hh_region` VALUES (371082, '荣成市', 371000, '荣成', 3, '0631', '264300', '122.48773', '37.1652', 'Rongcheng', '1', 0);
INSERT INTO `hh_region` VALUES (371083, '乳山市', 371000, '乳山', 3, '0631', '264500', '121.53814', '36.91918', 'Rushan', '1', 0);
INSERT INTO `hh_region` VALUES (371100, '日照市', 370000, '日照', 2, '0633', '276800', '119.461208', '35.428588', 'Rizhao', '1', 0);
INSERT INTO `hh_region` VALUES (371102, '东港区', 371100, '东港', 3, '0633', '276800', '119.46237', '35.42541', 'Donggang', '1', 0);
INSERT INTO `hh_region` VALUES (371103, '岚山区', 371100, '岚山', 3, '0633', '276808', '119.31884', '35.12203', 'Lanshan', '1', 0);
INSERT INTO `hh_region` VALUES (371121, '五莲县', 371100, '五莲', 3, '0633', '262300', '119.207', '35.75004', 'Wulian', '1', 0);
INSERT INTO `hh_region` VALUES (371122, '莒县', 371100, '莒县', 3, '0633', '276500', '118.83789', '35.58054', 'Juxian', '1', 0);
INSERT INTO `hh_region` VALUES (371200, '莱芜市', 370000, '莱芜', 2, '0634', '271100', '117.677736', '36.214397', 'Laiwu', '1', 0);
INSERT INTO `hh_region` VALUES (371202, '莱城区', 371200, '莱城', 3, '0634', '271199', '117.65986', '36.2032', 'Laicheng', '1', 0);
INSERT INTO `hh_region` VALUES (371203, '钢城区', 371200, '钢城', 3, '0634', '271100', '117.8049', '36.06319', 'Gangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (371300, '临沂市', 370000, '临沂', 2, '0539', '253000', '118.326443', '35.065282', 'Linyi', '1', 0);
INSERT INTO `hh_region` VALUES (371302, '兰山区', 371300, '兰山', 3, '0539', '276002', '118.34817', '35.06872', 'Lanshan', '1', 0);
INSERT INTO `hh_region` VALUES (371311, '罗庄区', 371300, '罗庄', 3, '0539', '276022', '118.28466', '34.99627', 'Luozhuang', '1', 0);
INSERT INTO `hh_region` VALUES (371312, '河东区', 371300, '河东', 3, '0539', '276034', '118.41055', '35.08803', 'Hedong', '1', 0);
INSERT INTO `hh_region` VALUES (371321, '沂南县', 371300, '沂南', 3, '0539', '276300', '118.47061', '35.55131', 'Yinan', '1', 0);
INSERT INTO `hh_region` VALUES (371322, '郯城县', 371300, '郯城', 3, '0539', '276100', '118.36712', '34.61354', 'Tancheng', '1', 0);
INSERT INTO `hh_region` VALUES (371323, '沂水县', 371300, '沂水', 3, '0539', '276400', '118.63009', '35.78731', 'Yishui', '1', 0);
INSERT INTO `hh_region` VALUES (371324, '兰陵县', 371300, '兰陵', 3, '0539', '277700', '117.856592', '34.738315', 'Lanling', '1', 0);
INSERT INTO `hh_region` VALUES (371325, '费县', 371300, '费县', 3, '0539', '273400', '117.97836', '35.26562', 'Feixian', '1', 0);
INSERT INTO `hh_region` VALUES (371326, '平邑县', 371300, '平邑', 3, '0539', '273300', '117.63867', '35.50573', 'Pingyi', '1', 0);
INSERT INTO `hh_region` VALUES (371327, '莒南县', 371300, '莒南', 3, '0539', '276600', '118.83227', '35.17539', 'Junan', '1', 0);
INSERT INTO `hh_region` VALUES (371328, '蒙阴县', 371300, '蒙阴', 3, '0539', '276200', '117.94592', '35.70996', 'Mengyin', '1', 0);
INSERT INTO `hh_region` VALUES (371329, '临沭县', 371300, '临沭', 3, '0539', '276700', '118.65267', '34.92091', 'Linshu', '1', 0);
INSERT INTO `hh_region` VALUES (371400, '德州市', 370000, '德州', 2, '0534', '253000', '116.307428', '37.453968', 'Dezhou', '1', 0);
INSERT INTO `hh_region` VALUES (371402, '德城区', 371400, '德城', 3, '0534', '253012', '116.29943', '37.45126', 'Decheng', '1', 0);
INSERT INTO `hh_region` VALUES (371403, '陵城区', 371400, '陵城', 3, '0534', '253500', '116.57601', '37.33571', 'Lingcheng', '1', 0);
INSERT INTO `hh_region` VALUES (371422, '宁津县', 371400, '宁津', 3, '0534', '253400', '116.79702', '37.65301', 'Ningjin', '1', 0);
INSERT INTO `hh_region` VALUES (371423, '庆云县', 371400, '庆云', 3, '0534', '253700', '117.38635', '37.77616', 'Qingyun', '1', 0);
INSERT INTO `hh_region` VALUES (371424, '临邑县', 371400, '临邑', 3, '0534', '251500', '116.86547', '37.19053', 'Linyi', '1', 0);
INSERT INTO `hh_region` VALUES (371425, '齐河县', 371400, '齐河', 3, '0534', '251100', '116.75515', '36.79532', 'Qihe', '1', 0);
INSERT INTO `hh_region` VALUES (371426, '平原县', 371400, '平原', 3, '0534', '253100', '116.43432', '37.16632', 'Pingyuan', '1', 0);
INSERT INTO `hh_region` VALUES (371427, '夏津县', 371400, '夏津', 3, '0534', '253200', '116.0017', '36.94852', 'Xiajin', '1', 0);
INSERT INTO `hh_region` VALUES (371428, '武城县', 371400, '武城', 3, '0534', '253300', '116.07009', '37.21403', 'Wucheng', '1', 0);
INSERT INTO `hh_region` VALUES (371481, '乐陵市', 371400, '乐陵', 3, '0534', '253600', '117.23141', '37.73164', 'Leling', '1', 0);
INSERT INTO `hh_region` VALUES (371482, '禹城市', 371400, '禹城', 3, '0534', '251200', '116.64309', '36.93444', 'Yucheng', '1', 0);
INSERT INTO `hh_region` VALUES (371500, '聊城市', 370000, '聊城', 2, '0635', '252052', '115.980367', '36.456013', 'Liaocheng', '1', 0);
INSERT INTO `hh_region` VALUES (371502, '东昌府区', 371500, '东昌府', 3, '0635', '252000', '115.97383', '36.44458', 'Dongchangfu', '1', 0);
INSERT INTO `hh_region` VALUES (371521, '阳谷县', 371500, '阳谷', 3, '0635', '252300', '115.79126', '36.11444', 'Yanggu', '1', 0);
INSERT INTO `hh_region` VALUES (371522, '莘县', 371500, '莘县', 3, '0635', '252400', '115.6697', '36.23423', 'Shenxian', '1', 0);
INSERT INTO `hh_region` VALUES (371523, '茌平县', 371500, '茌平', 3, '0635', '252100', '116.25491', '36.57969', 'Chiping', '1', 0);
INSERT INTO `hh_region` VALUES (371524, '东阿县', 371500, '东阿', 3, '0635', '252200', '116.25012', '36.33209', 'Dong\'e', '1', 0);
INSERT INTO `hh_region` VALUES (371525, '冠县', 371500, '冠县', 3, '0635', '252500', '115.44195', '36.48429', 'Guanxian', '1', 0);
INSERT INTO `hh_region` VALUES (371526, '高唐县', 371500, '高唐', 3, '0635', '252800', '116.23172', '36.86535', 'Gaotang', '1', 0);
INSERT INTO `hh_region` VALUES (371581, '临清市', 371500, '临清', 3, '0635', '252600', '115.70629', '36.83945', 'Linqing', '1', 0);
INSERT INTO `hh_region` VALUES (371600, '滨州市', 370000, '滨州', 2, '0543', '256619', '118.016974', '37.383542', 'Binzhou', '1', 0);
INSERT INTO `hh_region` VALUES (371602, '滨城区', 371600, '滨城', 3, '0543', '256613', '118.02026', '37.38524', 'Bincheng', '1', 0);
INSERT INTO `hh_region` VALUES (371603, '沾化区', 371600, '沾化', 3, '0543', '256800', '118.13214', '37.69832', 'Zhanhua', '1', 0);
INSERT INTO `hh_region` VALUES (371621, '惠民县', 371600, '惠民', 3, '0543', '251700', '117.51113', '37.49013', 'Huimin', '1', 0);
INSERT INTO `hh_region` VALUES (371622, '阳信县', 371600, '阳信', 3, '0543', '251800', '117.58139', '37.64198', 'Yangxin', '1', 0);
INSERT INTO `hh_region` VALUES (371623, '无棣县', 371600, '无棣', 3, '0543', '251900', '117.61395', '37.74009', 'Wudi', '1', 0);
INSERT INTO `hh_region` VALUES (371625, '博兴县', 371600, '博兴', 3, '0543', '256500', '118.1336', '37.14316', 'Boxing', '1', 0);
INSERT INTO `hh_region` VALUES (371626, '邹平县', 371600, '邹平', 3, '0543', '256200', '117.74307', '36.86295', 'Zouping', '1', 0);
INSERT INTO `hh_region` VALUES (371627, '北海新区', 371600, '北海新区', 3, '0543', '256200', '118.016974', '37.383542', 'Beihaixinqu', '1', 0);
INSERT INTO `hh_region` VALUES (371700, '菏泽市', 370000, '菏泽', 2, '0530', '274020', '115.469381', '35.246531', 'Heze', '1', 0);
INSERT INTO `hh_region` VALUES (371702, '牡丹区', 371700, '牡丹', 3, '0530', '274009', '115.41662', '35.25091', 'Mudan', '1', 0);
INSERT INTO `hh_region` VALUES (371721, '曹县', 371700, '曹县', 3, '0530', '274400', '115.54226', '34.82659', 'Caoxian', '1', 0);
INSERT INTO `hh_region` VALUES (371722, '单县', 371700, '单县', 3, '0530', '273700', '116.08703', '34.79514', 'Shanxian', '1', 0);
INSERT INTO `hh_region` VALUES (371723, '成武县', 371700, '成武', 3, '0530', '274200', '115.8897', '34.95332', 'Chengwu', '1', 0);
INSERT INTO `hh_region` VALUES (371724, '巨野县', 371700, '巨野', 3, '0530', '274900', '116.09497', '35.39788', 'Juye', '1', 0);
INSERT INTO `hh_region` VALUES (371725, '郓城县', 371700, '郓城', 3, '0530', '274700', '115.94439', '35.60044', 'Yuncheng', '1', 0);
INSERT INTO `hh_region` VALUES (371726, '鄄城县', 371700, '鄄城', 3, '0530', '274600', '115.50997', '35.56412', 'Juancheng', '1', 0);
INSERT INTO `hh_region` VALUES (371727, '定陶县', 371700, '定陶', 3, '0530', '274100', '115.57287', '35.07118', 'Dingtao', '1', 0);
INSERT INTO `hh_region` VALUES (371728, '东明县', 371700, '东明', 3, '0530', '274500', '115.09079', '35.28906', 'Dongming', '1', 0);
INSERT INTO `hh_region` VALUES (410000, '河南省', 100000, '河南', 1, '', '', '113.665412', '34.757975', 'Henan', '1', 0);
INSERT INTO `hh_region` VALUES (410100, '郑州市', 410000, '郑州', 2, '0371', '450000', '113.665412', '34.757975', 'Zhengzhou', '1', 0);
INSERT INTO `hh_region` VALUES (410102, '中原区', 410100, '中原', 3, '0371', '450007', '113.61333', '34.74827', 'Zhongyuan', '1', 0);
INSERT INTO `hh_region` VALUES (410103, '二七区', 410100, '二七', 3, '0371', '450052', '113.63931', '34.72336', 'Erqi', '1', 0);
INSERT INTO `hh_region` VALUES (410104, '管城回族区', 410100, '管城', 3, '0371', '450000', '113.67734', '34.75383', 'Guancheng', '1', 0);
INSERT INTO `hh_region` VALUES (410105, '金水区', 410100, '金水', 3, '0371', '450003', '113.66057', '34.80028', 'Jinshui', '1', 0);
INSERT INTO `hh_region` VALUES (410106, '上街区', 410100, '上街', 3, '0371', '450041', '113.30897', '34.80276', 'Shangjie', '1', 0);
INSERT INTO `hh_region` VALUES (410108, '惠济区', 410100, '惠济', 3, '0371', '450053', '113.61688', '34.86735', 'Huiji', '1', 0);
INSERT INTO `hh_region` VALUES (410122, '中牟县', 410100, '中牟', 3, '0371', '451450', '113.97619', '34.71899', 'Zhongmu', '1', 0);
INSERT INTO `hh_region` VALUES (410181, '巩义市', 410100, '巩义', 3, '0371', '451200', '113.022', '34.74794', 'Gongyi', '1', 0);
INSERT INTO `hh_region` VALUES (410182, '荥阳市', 410100, '荥阳', 3, '0371', '450100', '113.38345', '34.78759', 'Xingyang', '1', 0);
INSERT INTO `hh_region` VALUES (410183, '新密市', 410100, '新密', 3, '0371', '452300', '113.3869', '34.53704', 'Xinmi', '1', 0);
INSERT INTO `hh_region` VALUES (410184, '新郑市', 410100, '新郑', 3, '0371', '451100', '113.73645', '34.3955', 'Xinzheng', '1', 0);
INSERT INTO `hh_region` VALUES (410185, '登封市', 410100, '登封', 3, '0371', '452470', '113.05023', '34.45345', 'Dengfeng', '1', 0);
INSERT INTO `hh_region` VALUES (410200, '开封市', 410000, '开封', 2, '0378', '475001', '114.341447', '34.797049', 'Kaifeng', '1', 0);
INSERT INTO `hh_region` VALUES (410202, '龙亭区', 410200, '龙亭', 3, '0378', '475100', '114.35484', '34.79995', 'Longting', '1', 0);
INSERT INTO `hh_region` VALUES (410203, '顺河回族区', 410200, '顺河', 3, '0378', '475000', '114.36123', '34.79586', 'Shunhe', '1', 0);
INSERT INTO `hh_region` VALUES (410204, '鼓楼区', 410200, '鼓楼', 3, '0378', '475000', '114.35559', '34.79517', 'Gulou', '1', 0);
INSERT INTO `hh_region` VALUES (410205, '禹王台区', 410200, '禹王台', 3, '0378', '475003', '114.34787', '34.77693', 'Yuwangtai', '1', 0);
INSERT INTO `hh_region` VALUES (410212, '祥符区', 410200, '祥符', 3, '0378', '475100', '114.43859', '34.75874', 'Xiangfu', '1', 0);
INSERT INTO `hh_region` VALUES (410221, '杞县', 410200, '杞县', 3, '0378', '475200', '114.7828', '34.55033', 'Qixian', '1', 0);
INSERT INTO `hh_region` VALUES (410222, '通许县', 410200, '通许', 3, '0378', '475400', '114.46716', '34.47522', 'Tongxu', '1', 0);
INSERT INTO `hh_region` VALUES (410223, '尉氏县', 410200, '尉氏', 3, '0378', '475500', '114.19284', '34.41223', 'Weishi', '1', 0);
INSERT INTO `hh_region` VALUES (410225, '兰考县', 410200, '兰考', 3, '0378', '475300', '114.81961', '34.8235', 'Lankao', '1', 0);
INSERT INTO `hh_region` VALUES (410300, '洛阳市', 410000, '洛阳', 2, '0379', '471000', '112.434468', '34.663041', 'Luoyang', '1', 0);
INSERT INTO `hh_region` VALUES (410302, '老城区', 410300, '老城', 3, '0379', '471002', '112.46902', '34.68364', 'Laocheng', '1', 0);
INSERT INTO `hh_region` VALUES (410303, '西工区', 410300, '西工', 3, '0379', '471000', '112.4371', '34.67', 'Xigong', '1', 0);
INSERT INTO `hh_region` VALUES (410304, '瀍河回族区', 410300, '瀍河', 3, '0379', '471002', '112.50018', '34.67985', 'Chanhe', '1', 0);
INSERT INTO `hh_region` VALUES (410305, '涧西区', 410300, '涧西', 3, '0379', '471003', '112.39588', '34.65823', 'Jianxi', '1', 0);
INSERT INTO `hh_region` VALUES (410306, '吉利区', 410300, '吉利', 3, '0379', '471012', '112.58905', '34.90088', 'Jili', '1', 0);
INSERT INTO `hh_region` VALUES (410311, '洛龙区', 410300, '洛龙', 3, '0379', '471000', '112.46412', '34.61866', 'Luolong', '1', 0);
INSERT INTO `hh_region` VALUES (410322, '孟津县', 410300, '孟津', 3, '0379', '471100', '112.44351', '34.826', 'Mengjin', '1', 0);
INSERT INTO `hh_region` VALUES (410323, '新安县', 410300, '新安', 3, '0379', '471800', '112.13238', '34.72814', 'Xin\'an', '1', 0);
INSERT INTO `hh_region` VALUES (410324, '栾川县', 410300, '栾川', 3, '0379', '471500', '111.61779', '33.78576', 'Luanchuan', '1', 0);
INSERT INTO `hh_region` VALUES (410325, '嵩县', 410300, '嵩县', 3, '0379', '471400', '112.08526', '34.13466', 'Songxian', '1', 0);
INSERT INTO `hh_region` VALUES (410326, '汝阳县', 410300, '汝阳', 3, '0379', '471200', '112.47314', '34.15387', 'Ruyang', '1', 0);
INSERT INTO `hh_region` VALUES (410327, '宜阳县', 410300, '宜阳', 3, '0379', '471600', '112.17907', '34.51523', 'Yiyang', '1', 0);
INSERT INTO `hh_region` VALUES (410328, '洛宁县', 410300, '洛宁', 3, '0379', '471700', '111.65087', '34.38913', 'Luoning', '1', 0);
INSERT INTO `hh_region` VALUES (410329, '伊川县', 410300, '伊川', 3, '0379', '471300', '112.42947', '34.42205', 'Yichuan', '1', 0);
INSERT INTO `hh_region` VALUES (410381, '偃师市', 410300, '偃师', 3, '0379', '471900', '112.7922', '34.7281', 'Yanshi', '1', 0);
INSERT INTO `hh_region` VALUES (410400, '平顶山市', 410000, '平顶山', 2, '0375', '467000', '113.307718', '33.735241', 'Pingdingshan', '1', 0);
INSERT INTO `hh_region` VALUES (410402, '新华区', 410400, '新华', 3, '0375', '467002', '113.29402', '33.7373', 'Xinhua', '1', 0);
INSERT INTO `hh_region` VALUES (410403, '卫东区', 410400, '卫东', 3, '0375', '467021', '113.33511', '33.73472', 'Weidong', '1', 0);
INSERT INTO `hh_region` VALUES (410404, '石龙区', 410400, '石龙', 3, '0375', '467045', '112.89879', '33.89878', 'Shilong', '1', 0);
INSERT INTO `hh_region` VALUES (410411, '湛河区', 410400, '湛河', 3, '0375', '467000', '113.29252', '33.7362', 'Zhanhe', '1', 0);
INSERT INTO `hh_region` VALUES (410421, '宝丰县', 410400, '宝丰', 3, '0375', '467400', '113.05493', '33.86916', 'Baofeng', '1', 0);
INSERT INTO `hh_region` VALUES (410422, '叶县', 410400, '叶县', 3, '0375', '467200', '113.35104', '33.62225', 'Yexian', '1', 0);
INSERT INTO `hh_region` VALUES (410423, '鲁山县', 410400, '鲁山', 3, '0375', '467300', '112.9057', '33.73879', 'Lushan', '1', 0);
INSERT INTO `hh_region` VALUES (410425, '郏县', 410400, '郏县', 3, '0375', '467100', '113.21588', '33.97072', 'Jiaxian', '1', 0);
INSERT INTO `hh_region` VALUES (410481, '舞钢市', 410400, '舞钢', 3, '0375', '462500', '113.52417', '33.2938', 'Wugang', '1', 0);
INSERT INTO `hh_region` VALUES (410482, '汝州市', 410400, '汝州', 3, '0375', '467500', '112.84301', '34.16135', 'Ruzhou', '1', 0);
INSERT INTO `hh_region` VALUES (410500, '安阳市', 410000, '安阳', 2, '0372', '455000', '114.352482', '36.103442', 'Anyang', '1', 0);
INSERT INTO `hh_region` VALUES (410502, '文峰区', 410500, '文峰', 3, '0372', '455000', '114.35708', '36.09046', 'Wenfeng', '1', 0);
INSERT INTO `hh_region` VALUES (410503, '北关区', 410500, '北关', 3, '0372', '455001', '114.35735', '36.11872', 'Beiguan', '1', 0);
INSERT INTO `hh_region` VALUES (410505, '殷都区', 410500, '殷都', 3, '0372', '455004', '114.3034', '36.1099', 'Yindu', '1', 0);
INSERT INTO `hh_region` VALUES (410506, '龙安区', 410500, '龙安', 3, '0372', '455001', '114.34814', '36.11904', 'Long\'an', '1', 0);
INSERT INTO `hh_region` VALUES (410522, '安阳县', 410500, '安阳', 3, '0372', '455000', '114.36605', '36.06695', 'Anyang', '1', 0);
INSERT INTO `hh_region` VALUES (410523, '汤阴县', 410500, '汤阴', 3, '0372', '456150', '114.35839', '35.92152', 'Tangyin', '1', 0);
INSERT INTO `hh_region` VALUES (410526, '滑县', 410500, '滑县', 3, '0372', '456400', '114.52066', '35.5807', 'Huaxian', '1', 0);
INSERT INTO `hh_region` VALUES (410527, '内黄县', 410500, '内黄', 3, '0372', '456350', '114.90673', '35.95269', 'Neihuang', '1', 0);
INSERT INTO `hh_region` VALUES (410581, '林州市', 410500, '林州', 3, '0372', '456550', '113.81558', '36.07804', 'Linzhou', '1', 0);
INSERT INTO `hh_region` VALUES (410600, '鹤壁市', 410000, '鹤壁', 2, '0392', '458030', '114.295444', '35.748236', 'Hebi', '1', 0);
INSERT INTO `hh_region` VALUES (410602, '鹤山区', 410600, '鹤山', 3, '0392', '458010', '114.16336', '35.95458', 'Heshan', '1', 0);
INSERT INTO `hh_region` VALUES (410603, '山城区', 410600, '山城', 3, '0392', '458000', '114.18443', '35.89773', 'Shancheng', '1', 0);
INSERT INTO `hh_region` VALUES (410611, '淇滨区', 410600, '淇滨', 3, '0392', '458000', '114.29867', '35.74127', 'Qibin', '1', 0);
INSERT INTO `hh_region` VALUES (410621, '浚县', 410600, '浚县', 3, '0392', '456250', '114.54879', '35.67085', 'Xunxian', '1', 0);
INSERT INTO `hh_region` VALUES (410622, '淇县', 410600, '淇县', 3, '0392', '456750', '114.1976', '35.60782', 'Qixian', '1', 0);
INSERT INTO `hh_region` VALUES (410700, '新乡市', 410000, '新乡', 2, '0373', '453000', '113.883991', '35.302616', 'Xinxiang', '1', 0);
INSERT INTO `hh_region` VALUES (410702, '红旗区', 410700, '红旗', 3, '0373', '453000', '113.87523', '35.30367', 'Hongqi', '1', 0);
INSERT INTO `hh_region` VALUES (410703, '卫滨区', 410700, '卫滨', 3, '0373', '453000', '113.86578', '35.30211', 'Weibin', '1', 0);
INSERT INTO `hh_region` VALUES (410704, '凤泉区', 410700, '凤泉', 3, '0373', '453011', '113.91507', '35.38399', 'Fengquan', '1', 0);
INSERT INTO `hh_region` VALUES (410711, '牧野区', 410700, '牧野', 3, '0373', '453002', '113.9086', '35.3149', 'Muye', '1', 0);
INSERT INTO `hh_region` VALUES (410721, '新乡县', 410700, '新乡', 3, '0373', '453700', '113.80511', '35.19075', 'Xinxiang', '1', 0);
INSERT INTO `hh_region` VALUES (410724, '获嘉县', 410700, '获嘉', 3, '0373', '453800', '113.66159', '35.26521', 'Huojia', '1', 0);
INSERT INTO `hh_region` VALUES (410725, '原阳县', 410700, '原阳', 3, '0373', '453500', '113.93994', '35.06565', 'Yuanyang', '1', 0);
INSERT INTO `hh_region` VALUES (410726, '延津县', 410700, '延津', 3, '0373', '453200', '114.20266', '35.14327', 'Yanjin', '1', 0);
INSERT INTO `hh_region` VALUES (410727, '封丘县', 410700, '封丘', 3, '0373', '453300', '114.41915', '35.04166', 'Fengqiu', '1', 0);
INSERT INTO `hh_region` VALUES (410728, '长垣县', 410700, '长垣', 3, '0373', '453400', '114.66882', '35.20046', 'Changyuan', '1', 0);
INSERT INTO `hh_region` VALUES (410781, '卫辉市', 410700, '卫辉', 3, '0373', '453100', '114.06454', '35.39843', 'Weihui', '1', 0);
INSERT INTO `hh_region` VALUES (410782, '辉县市', 410700, '辉县', 3, '0373', '453600', '113.8067', '35.46307', 'Huixian', '1', 0);
INSERT INTO `hh_region` VALUES (410800, '焦作市', 410000, '焦作', 2, '0391', '454002', '113.238266', '35.23904', 'Jiaozuo', '1', 0);
INSERT INTO `hh_region` VALUES (410802, '解放区', 410800, '解放', 3, '0391', '454000', '113.22933', '35.24023', 'Jiefang', '1', 0);
INSERT INTO `hh_region` VALUES (410803, '中站区', 410800, '中站', 3, '0391', '454191', '113.18315', '35.23665', 'Zhongzhan', '1', 0);
INSERT INTO `hh_region` VALUES (410804, '马村区', 410800, '马村', 3, '0391', '454171', '113.3187', '35.26908', 'Macun', '1', 0);
INSERT INTO `hh_region` VALUES (410811, '山阳区', 410800, '山阳', 3, '0391', '454002', '113.25464', '35.21436', 'Shanyang', '1', 0);
INSERT INTO `hh_region` VALUES (410821, '修武县', 410800, '修武', 3, '0391', '454350', '113.44775', '35.22357', 'Xiuwu', '1', 0);
INSERT INTO `hh_region` VALUES (410822, '博爱县', 410800, '博爱', 3, '0391', '454450', '113.06698', '35.16943', 'Boai', '1', 0);
INSERT INTO `hh_region` VALUES (410823, '武陟县', 410800, '武陟', 3, '0391', '454950', '113.39718', '35.09505', 'Wuzhi', '1', 0);
INSERT INTO `hh_region` VALUES (410825, '温县', 410800, '温县', 3, '0391', '454850', '113.08065', '34.94022', 'Wenxian', '1', 0);
INSERT INTO `hh_region` VALUES (410882, '沁阳市', 410800, '沁阳', 3, '0391', '454550', '112.94494', '35.08935', 'Qinyang', '1', 0);
INSERT INTO `hh_region` VALUES (410883, '孟州市', 410800, '孟州', 3, '0391', '454750', '112.79138', '34.9071', 'Mengzhou', '1', 0);
INSERT INTO `hh_region` VALUES (410900, '濮阳市', 410000, '濮阳', 2, '0393', '457000', '115.041299', '35.768234', 'Puyang', '1', 0);
INSERT INTO `hh_region` VALUES (410902, '华龙区', 410900, '华龙', 3, '0393', '457001', '115.07446', '35.77736', 'Hualong', '1', 0);
INSERT INTO `hh_region` VALUES (410922, '清丰县', 410900, '清丰', 3, '0393', '457300', '115.10415', '35.88507', 'Qingfeng', '1', 0);
INSERT INTO `hh_region` VALUES (410923, '南乐县', 410900, '南乐', 3, '0393', '457400', '115.20639', '36.07686', 'Nanle', '1', 0);
INSERT INTO `hh_region` VALUES (410926, '范县', 410900, '范县', 3, '0393', '457500', '115.50405', '35.85178', 'Fanxian', '1', 0);
INSERT INTO `hh_region` VALUES (410927, '台前县', 410900, '台前', 3, '0393', '457600', '115.87158', '35.96923', 'Taiqian', '1', 0);
INSERT INTO `hh_region` VALUES (410928, '濮阳县', 410900, '濮阳', 3, '0393', '457100', '115.03057', '35.70745', 'Puyang', '1', 0);
INSERT INTO `hh_region` VALUES (411000, '许昌市', 410000, '许昌', 2, '0374', '461000', '113.826063', '34.022956', 'Xuchang', '1', 0);
INSERT INTO `hh_region` VALUES (411002, '魏都区', 411000, '魏都', 3, '0374', '461000', '113.8227', '34.02544', 'Weidu', '1', 0);
INSERT INTO `hh_region` VALUES (411023, '许昌县', 411000, '许昌', 3, '0374', '461100', '113.84707', '34.00406', 'Xuchang', '1', 0);
INSERT INTO `hh_region` VALUES (411024, '鄢陵县', 411000, '鄢陵', 3, '0374', '461200', '114.18795', '34.10317', 'Yanling', '1', 0);
INSERT INTO `hh_region` VALUES (411025, '襄城县', 411000, '襄城', 3, '0374', '461700', '113.48196', '33.84928', 'Xiangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (411081, '禹州市', 411000, '禹州', 3, '0374', '461670', '113.48803', '34.14054', 'Yuzhou', '1', 0);
INSERT INTO `hh_region` VALUES (411082, '长葛市', 411000, '长葛', 3, '0374', '461500', '113.77328', '34.21846', 'Changge', '1', 0);
INSERT INTO `hh_region` VALUES (411100, '漯河市', 410000, '漯河', 2, '0395', '462000', '114.026405', '33.575855', 'Luohe', '1', 0);
INSERT INTO `hh_region` VALUES (411102, '源汇区', 411100, '源汇', 3, '0395', '462000', '114.00647', '33.55627', 'Yuanhui', '1', 0);
INSERT INTO `hh_region` VALUES (411103, '郾城区', 411100, '郾城', 3, '0395', '462300', '114.00694', '33.58723', 'Yancheng', '1', 0);
INSERT INTO `hh_region` VALUES (411104, '召陵区', 411100, '召陵', 3, '0395', '462300', '114.09399', '33.58601', 'Zhaoling', '1', 0);
INSERT INTO `hh_region` VALUES (411121, '舞阳县', 411100, '舞阳', 3, '0395', '462400', '113.59848', '33.43243', 'Wuyang', '1', 0);
INSERT INTO `hh_region` VALUES (411122, '临颍县', 411100, '临颍', 3, '0395', '462600', '113.93661', '33.81123', 'Linying', '1', 0);
INSERT INTO `hh_region` VALUES (411200, '三门峡市', 410000, '三门峡', 2, '0398', '472000', '111.194099', '34.777338', 'Sanmenxia', '1', 0);
INSERT INTO `hh_region` VALUES (411202, '湖滨区', 411200, '湖滨', 3, '0398', '472000', '111.20006', '34.77872', 'Hubin', '1', 0);
INSERT INTO `hh_region` VALUES (411221, '渑池县', 411200, '渑池', 3, '0398', '472400', '111.76184', '34.76725', 'Mianchi', '1', 0);
INSERT INTO `hh_region` VALUES (411222, '陕县', 411200, '陕县', 3, '0398', '472100', '111.10333', '34.72052', 'Shanxian', '1', 0);
INSERT INTO `hh_region` VALUES (411224, '卢氏县', 411200, '卢氏', 3, '0398', '472200', '111.04782', '34.05436', 'Lushi', '1', 0);
INSERT INTO `hh_region` VALUES (411281, '义马市', 411200, '义马', 3, '0398', '472300', '111.87445', '34.74721', 'Yima', '1', 0);
INSERT INTO `hh_region` VALUES (411282, '灵宝市', 411200, '灵宝', 3, '0398', '472500', '110.8945', '34.51682', 'Lingbao', '1', 0);
INSERT INTO `hh_region` VALUES (411300, '南阳市', 410000, '南阳', 2, '0377', '473002', '112.540918', '32.999082', 'Nanyang', '1', 0);
INSERT INTO `hh_region` VALUES (411302, '宛城区', 411300, '宛城', 3, '0377', '473001', '112.53955', '33.00378', 'Wancheng', '1', 0);
INSERT INTO `hh_region` VALUES (411303, '卧龙区', 411300, '卧龙', 3, '0377', '473003', '112.53479', '32.98615', 'Wolong', '1', 0);
INSERT INTO `hh_region` VALUES (411321, '南召县', 411300, '南召', 3, '0377', '474650', '112.43194', '33.49098', 'Nanzhao', '1', 0);
INSERT INTO `hh_region` VALUES (411322, '方城县', 411300, '方城', 3, '0377', '473200', '113.01269', '33.25453', 'Fangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (411323, '西峡县', 411300, '西峡', 3, '0377', '474550', '111.48187', '33.29772', 'Xixia', '1', 0);
INSERT INTO `hh_region` VALUES (411324, '镇平县', 411300, '镇平', 3, '0377', '474250', '112.2398', '33.03629', 'Zhenping', '1', 0);
INSERT INTO `hh_region` VALUES (411325, '内乡县', 411300, '内乡', 3, '0377', '474350', '111.84957', '33.04671', 'Neixiang', '1', 0);
INSERT INTO `hh_region` VALUES (411326, '淅川县', 411300, '淅川', 3, '0377', '474450', '111.48663', '33.13708', 'Xichuan', '1', 0);
INSERT INTO `hh_region` VALUES (411327, '社旗县', 411300, '社旗', 3, '0377', '473300', '112.94656', '33.05503', 'Sheqi', '1', 0);
INSERT INTO `hh_region` VALUES (411328, '唐河县', 411300, '唐河', 3, '0377', '473400', '112.83609', '32.69453', 'Tanghe', '1', 0);
INSERT INTO `hh_region` VALUES (411329, '新野县', 411300, '新野', 3, '0377', '473500', '112.36151', '32.51698', 'Xinye', '1', 0);
INSERT INTO `hh_region` VALUES (411330, '桐柏县', 411300, '桐柏', 3, '0377', '474750', '113.42886', '32.37917', 'Tongbai', '1', 0);
INSERT INTO `hh_region` VALUES (411381, '邓州市', 411300, '邓州', 3, '0377', '474150', '112.0896', '32.68577', 'Dengzhou', '1', 0);
INSERT INTO `hh_region` VALUES (411400, '商丘市', 410000, '商丘', 2, '0370', '476000', '115.650497', '34.437054', 'Shangqiu', '1', 0);
INSERT INTO `hh_region` VALUES (411402, '梁园区', 411400, '梁园', 3, '0370', '476000', '115.64487', '34.44341', 'Liangyuan', '1', 0);
INSERT INTO `hh_region` VALUES (411403, '睢阳区', 411400, '睢阳', 3, '0370', '476100', '115.65338', '34.38804', 'Suiyang', '1', 0);
INSERT INTO `hh_region` VALUES (411421, '民权县', 411400, '民权', 3, '0370', '476800', '115.14621', '34.64931', 'Minquan', '1', 0);
INSERT INTO `hh_region` VALUES (411422, '睢县', 411400, '睢县', 3, '0370', '476900', '115.07168', '34.44539', 'Suixian', '1', 0);
INSERT INTO `hh_region` VALUES (411423, '宁陵县', 411400, '宁陵', 3, '0370', '476700', '115.30511', '34.45463', 'Ningling', '1', 0);
INSERT INTO `hh_region` VALUES (411424, '柘城县', 411400, '柘城', 3, '0370', '476200', '115.30538', '34.0911', 'Zhecheng', '1', 0);
INSERT INTO `hh_region` VALUES (411425, '虞城县', 411400, '虞城', 3, '0370', '476300', '115.86337', '34.40189', 'Yucheng', '1', 0);
INSERT INTO `hh_region` VALUES (411426, '夏邑县', 411400, '夏邑', 3, '0370', '476400', '116.13348', '34.23242', 'Xiayi', '1', 0);
INSERT INTO `hh_region` VALUES (411481, '永城市', 411400, '永城', 3, '0370', '476600', '116.44943', '33.92911', 'Yongcheng', '1', 0);
INSERT INTO `hh_region` VALUES (411500, '信阳市', 410000, '信阳', 2, '0376', '464000', '114.075031', '32.123274', 'Xinyang', '1', 0);
INSERT INTO `hh_region` VALUES (411502, '浉河区', 411500, '浉河', 3, '0376', '464000', '114.05871', '32.1168', 'Shihe', '1', 0);
INSERT INTO `hh_region` VALUES (411503, '平桥区', 411500, '平桥', 3, '0376', '464100', '114.12435', '32.10095', 'Pingqiao', '1', 0);
INSERT INTO `hh_region` VALUES (411521, '罗山县', 411500, '罗山', 3, '0376', '464200', '114.5314', '32.20277', 'Luoshan', '1', 0);
INSERT INTO `hh_region` VALUES (411522, '光山县', 411500, '光山', 3, '0376', '465450', '114.91873', '32.00992', 'Guangshan', '1', 0);
INSERT INTO `hh_region` VALUES (411523, '新县', 411500, '新县', 3, '0376', '465550', '114.87924', '31.64386', 'Xinxian', '1', 0);
INSERT INTO `hh_region` VALUES (411524, '商城县', 411500, '商城', 3, '0376', '465350', '115.40856', '31.79986', 'Shangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (411525, '固始县', 411500, '固始', 3, '0376', '465250', '115.68298', '32.18011', 'Gushi', '1', 0);
INSERT INTO `hh_region` VALUES (411526, '潢川县', 411500, '潢川', 3, '0376', '465150', '115.04696', '32.13763', 'Huangchuan', '1', 0);
INSERT INTO `hh_region` VALUES (411527, '淮滨县', 411500, '淮滨', 3, '0376', '464400', '115.4205', '32.46614', 'Huaibin', '1', 0);
INSERT INTO `hh_region` VALUES (411528, '息县', 411500, '息县', 3, '0376', '464300', '114.7402', '32.34279', 'Xixian', '1', 0);
INSERT INTO `hh_region` VALUES (411600, '周口市', 410000, '周口', 2, '0394', '466000', '114.649653', '33.620357', 'Zhoukou', '1', 0);
INSERT INTO `hh_region` VALUES (411602, '川汇区', 411600, '川汇', 3, '0394', '466000', '114.64202', '33.6256', 'Chuanhui', '1', 0);
INSERT INTO `hh_region` VALUES (411621, '扶沟县', 411600, '扶沟', 3, '0394', '461300', '114.39477', '34.05999', 'Fugou', '1', 0);
INSERT INTO `hh_region` VALUES (411622, '西华县', 411600, '西华', 3, '0394', '466600', '114.52279', '33.78548', 'Xihua', '1', 0);
INSERT INTO `hh_region` VALUES (411623, '商水县', 411600, '商水', 3, '0394', '466100', '114.60604', '33.53912', 'Shangshui', '1', 0);
INSERT INTO `hh_region` VALUES (411624, '沈丘县', 411600, '沈丘', 3, '0394', '466300', '115.09851', '33.40936', 'Shenqiu', '1', 0);
INSERT INTO `hh_region` VALUES (411625, '郸城县', 411600, '郸城', 3, '0394', '477150', '115.17715', '33.64485', 'Dancheng', '1', 0);
INSERT INTO `hh_region` VALUES (411626, '淮阳县', 411600, '淮阳', 3, '0394', '466700', '114.88848', '33.73211', 'Huaiyang', '1', 0);
INSERT INTO `hh_region` VALUES (411627, '太康县', 411600, '太康', 3, '0394', '461400', '114.83773', '34.06376', 'Taikang', '1', 0);
INSERT INTO `hh_region` VALUES (411628, '鹿邑县', 411600, '鹿邑', 3, '0394', '477200', '115.48553', '33.85931', 'Luyi', '1', 0);
INSERT INTO `hh_region` VALUES (411681, '项城市', 411600, '项城', 3, '0394', '466200', '114.87558', '33.4672', 'Xiangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (411700, '驻马店市', 410000, '驻马店', 2, '0396', '463000', '114.024736', '32.980169', 'Zhumadian', '1', 0);
INSERT INTO `hh_region` VALUES (411702, '驿城区', 411700, '驿城', 3, '0396', '463000', '113.99377', '32.97316', 'Yicheng', '1', 0);
INSERT INTO `hh_region` VALUES (411721, '西平县', 411700, '西平', 3, '0396', '463900', '114.02322', '33.3845', 'Xiping', '1', 0);
INSERT INTO `hh_region` VALUES (411722, '上蔡县', 411700, '上蔡', 3, '0396', '463800', '114.26825', '33.26825', 'Shangcai', '1', 0);
INSERT INTO `hh_region` VALUES (411723, '平舆县', 411700, '平舆', 3, '0396', '463400', '114.63552', '32.95727', 'Pingyu', '1', 0);
INSERT INTO `hh_region` VALUES (411724, '正阳县', 411700, '正阳', 3, '0396', '463600', '114.38952', '32.6039', 'Zhengyang', '1', 0);
INSERT INTO `hh_region` VALUES (411725, '确山县', 411700, '确山', 3, '0396', '463200', '114.02917', '32.80281', 'Queshan', '1', 0);
INSERT INTO `hh_region` VALUES (411726, '泌阳县', 411700, '泌阳', 3, '0396', '463700', '113.32681', '32.71781', 'Biyang', '1', 0);
INSERT INTO `hh_region` VALUES (411727, '汝南县', 411700, '汝南', 3, '0396', '463300', '114.36138', '33.00461', 'Runan', '1', 0);
INSERT INTO `hh_region` VALUES (411728, '遂平县', 411700, '遂平', 3, '0396', '463100', '114.01297', '33.14571', 'Suiping', '1', 0);
INSERT INTO `hh_region` VALUES (411729, '新蔡县', 411700, '新蔡', 3, '0396', '463500', '114.98199', '32.7502', 'Xincai', '1', 0);
INSERT INTO `hh_region` VALUES (419000, '直辖县级', 410000, ' ', 2, '', '', '113.665412', '34.757975', '', '1', 0);
INSERT INTO `hh_region` VALUES (419001, '济源市', 419000, '济源', 3, '0391', '454650', '112.590047', '35.090378', 'Jiyuan', '1', 0);
INSERT INTO `hh_region` VALUES (420000, '湖北省', 100000, '湖北', 1, '', '', '114.298572', '30.584355', 'Hubei', '1', 0);
INSERT INTO `hh_region` VALUES (420100, '武汉市', 420000, '武汉', 2, '', '430014', '114.298572', '30.584355', 'Wuhan', '1', 0);
INSERT INTO `hh_region` VALUES (420102, '江岸区', 420100, '江岸', 3, '027', '430014', '114.30943', '30.59982', 'Jiang\'an', '1', 0);
INSERT INTO `hh_region` VALUES (420103, '江汉区', 420100, '江汉', 3, '027', '430021', '114.27093', '30.60146', 'Jianghan', '1', 0);
INSERT INTO `hh_region` VALUES (420104, '硚口区', 420100, '硚口', 3, '027', '430033', '114.26422', '30.56945', 'Qiaokou', '1', 0);
INSERT INTO `hh_region` VALUES (420105, '汉阳区', 420100, '汉阳', 3, '027', '430050', '114.27478', '30.54915', 'Hanyang', '1', 0);
INSERT INTO `hh_region` VALUES (420106, '武昌区', 420100, '武昌', 3, '027', '430061', '114.31589', '30.55389', 'Wuchang', '1', 0);
INSERT INTO `hh_region` VALUES (420107, '青山区', 420100, '青山', 3, '027', '430080', '114.39117', '30.63427', 'Qingshan', '1', 0);
INSERT INTO `hh_region` VALUES (420111, '洪山区', 420100, '洪山', 3, '027', '430070', '114.34375', '30.49989', 'Hongshan', '1', 0);
INSERT INTO `hh_region` VALUES (420112, '东西湖区', 420100, '东西湖', 3, '027', '430040', '114.13708', '30.61989', 'Dongxihu', '1', 0);
INSERT INTO `hh_region` VALUES (420113, '汉南区', 420100, '汉南', 3, '027', '430090', '114.08462', '30.30879', 'Hannan', '1', 0);
INSERT INTO `hh_region` VALUES (420114, '蔡甸区', 420100, '蔡甸', 3, '027', '430100', '114.02929', '30.58197', 'Caidian', '1', 0);
INSERT INTO `hh_region` VALUES (420115, '江夏区', 420100, '江夏', 3, '027', '430200', '114.31301', '30.34653', 'Jiangxia', '1', 0);
INSERT INTO `hh_region` VALUES (420116, '黄陂区', 420100, '黄陂', 3, '027', '432200', '114.37512', '30.88151', 'Huangpi', '1', 0);
INSERT INTO `hh_region` VALUES (420117, '新洲区', 420100, '新洲', 3, '027', '431400', '114.80136', '30.84145', 'Xinzhou', '1', 0);
INSERT INTO `hh_region` VALUES (420200, '黄石市', 420000, '黄石', 2, '0714', '435003', '115.077048', '30.220074', 'Huangshi', '1', 0);
INSERT INTO `hh_region` VALUES (420202, '黄石港区', 420200, '黄石港', 3, '0714', '435000', '115.06604', '30.22279', 'Huangshigang', '1', 0);
INSERT INTO `hh_region` VALUES (420203, '西塞山区', 420200, '西塞山', 3, '0714', '435001', '115.11016', '30.20487', 'Xisaishan', '1', 0);
INSERT INTO `hh_region` VALUES (420204, '下陆区', 420200, '下陆', 3, '0714', '435005', '114.96112', '30.17368', 'Xialu', '1', 0);
INSERT INTO `hh_region` VALUES (420205, '铁山区', 420200, '铁山', 3, '0714', '435006', '114.90109', '30.20678', 'Tieshan', '1', 0);
INSERT INTO `hh_region` VALUES (420222, '阳新县', 420200, '阳新', 3, '0714', '435200', '115.21527', '29.83038', 'Yangxin', '1', 0);
INSERT INTO `hh_region` VALUES (420281, '大冶市', 420200, '大冶', 3, '0714', '435100', '114.97174', '30.09438', 'Daye', '1', 0);
INSERT INTO `hh_region` VALUES (420300, '十堰市', 420000, '十堰', 2, '0719', '442000', '110.785239', '32.647017', 'Shiyan', '1', 0);
INSERT INTO `hh_region` VALUES (420302, '茅箭区', 420300, '茅箭', 3, '0719', '442012', '110.81341', '32.59153', 'Maojian', '1', 0);
INSERT INTO `hh_region` VALUES (420303, '张湾区', 420300, '张湾', 3, '0719', '442001', '110.77067', '32.65195', 'Zhangwan', '1', 0);
INSERT INTO `hh_region` VALUES (420304, '郧阳区', 420300, '郧阳', 3, '0719', '442500', '110.81854', '32.83593', 'Yunyang', '1', 0);
INSERT INTO `hh_region` VALUES (420322, '郧西县', 420300, '郧西', 3, '0719', '442600', '110.42556', '32.99349', 'Yunxi', '1', 0);
INSERT INTO `hh_region` VALUES (420323, '竹山县', 420300, '竹山', 3, '0719', '442200', '110.23071', '32.22536', 'Zhushan', '1', 0);
INSERT INTO `hh_region` VALUES (420324, '竹溪县', 420300, '竹溪', 3, '0719', '442300', '109.71798', '32.31901', 'Zhuxi', '1', 0);
INSERT INTO `hh_region` VALUES (420325, '房县', 420300, '房县', 3, '0719', '442100', '110.74386', '32.05794', 'Fangxian', '1', 0);
INSERT INTO `hh_region` VALUES (420381, '丹江口市', 420300, '丹江口', 3, '0719', '442700', '111.51525', '32.54085', 'Danjiangkou', '1', 0);
INSERT INTO `hh_region` VALUES (420500, '宜昌市', 420000, '宜昌', 2, '0717', '443000', '111.290843', '30.702636', 'Yichang', '1', 0);
INSERT INTO `hh_region` VALUES (420502, '西陵区', 420500, '西陵', 3, '0717', '443000', '111.28573', '30.71077', 'Xiling', '1', 0);
INSERT INTO `hh_region` VALUES (420503, '伍家岗区', 420500, '伍家岗', 3, '0717', '443001', '111.3609', '30.64434', 'Wujiagang', '1', 0);
INSERT INTO `hh_region` VALUES (420504, '点军区', 420500, '点军', 3, '0717', '443006', '111.26828', '30.6934', 'Dianjun', '1', 0);
INSERT INTO `hh_region` VALUES (420505, '猇亭区', 420500, '猇亭', 3, '0717', '443007', '111.44079', '30.52663', 'Xiaoting', '1', 0);
INSERT INTO `hh_region` VALUES (420506, '夷陵区', 420500, '夷陵', 3, '0717', '443100', '111.3262', '30.76881', 'Yiling', '1', 0);
INSERT INTO `hh_region` VALUES (420525, '远安县', 420500, '远安', 3, '0717', '444200', '111.6416', '31.05989', 'Yuan\'an', '1', 0);
INSERT INTO `hh_region` VALUES (420526, '兴山县', 420500, '兴山', 3, '0717', '443711', '110.74951', '31.34686', 'Xingshan', '1', 0);
INSERT INTO `hh_region` VALUES (420527, '秭归县', 420500, '秭归', 3, '0717', '443600', '110.98156', '30.82702', 'Zigui', '1', 0);
INSERT INTO `hh_region` VALUES (420528, '长阳土家族自治县', 420500, '长阳', 3, '0717', '443500', '111.20105', '30.47052', 'Changyang', '1', 0);
INSERT INTO `hh_region` VALUES (420529, '五峰土家族自治县', 420500, '五峰', 3, '0717', '443413', '110.6748', '30.19856', 'Wufeng', '1', 0);
INSERT INTO `hh_region` VALUES (420581, '宜都市', 420500, '宜都', 3, '0717', '443300', '111.45025', '30.37807', 'Yidu', '1', 0);
INSERT INTO `hh_region` VALUES (420582, '当阳市', 420500, '当阳', 3, '0717', '444100', '111.78912', '30.8208', 'Dangyang', '1', 0);
INSERT INTO `hh_region` VALUES (420583, '枝江市', 420500, '枝江', 3, '0717', '443200', '111.76855', '30.42612', 'Zhijiang', '1', 0);
INSERT INTO `hh_region` VALUES (420600, '襄阳市', 420000, '襄阳', 2, '0710', '441021', '112.144146', '32.042426', 'Xiangyang', '1', 0);
INSERT INTO `hh_region` VALUES (420602, '襄城区', 420600, '襄城', 3, '0710', '441021', '112.13372', '32.01017', 'Xiangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (420606, '樊城区', 420600, '樊城', 3, '0710', '441001', '112.13546', '32.04482', 'Fancheng', '1', 0);
INSERT INTO `hh_region` VALUES (420607, '襄州区', 420600, '襄州', 3, '0710', '441100', '112.150327', '32.015088', 'Xiangzhou', '1', 0);
INSERT INTO `hh_region` VALUES (420624, '南漳县', 420600, '南漳', 3, '0710', '441500', '111.84603', '31.77653', 'Nanzhang', '1', 0);
INSERT INTO `hh_region` VALUES (420625, '谷城县', 420600, '谷城', 3, '0710', '441700', '111.65267', '32.26377', 'Gucheng', '1', 0);
INSERT INTO `hh_region` VALUES (420626, '保康县', 420600, '保康', 3, '0710', '441600', '111.26138', '31.87874', 'Baokang', '1', 0);
INSERT INTO `hh_region` VALUES (420682, '老河口市', 420600, '老河口', 3, '0710', '441800', '111.67117', '32.38476', 'Laohekou', '1', 0);
INSERT INTO `hh_region` VALUES (420683, '枣阳市', 420600, '枣阳', 3, '0710', '441200', '112.77444', '32.13142', 'Zaoyang', '1', 0);
INSERT INTO `hh_region` VALUES (420684, '宜城市', 420600, '宜城', 3, '0710', '441400', '112.25772', '31.71972', 'Yicheng', '1', 0);
INSERT INTO `hh_region` VALUES (420700, '鄂州市', 420000, '鄂州', 2, '0711', '436000', '114.890593', '30.396536', 'Ezhou', '1', 0);
INSERT INTO `hh_region` VALUES (420702, '梁子湖区', 420700, '梁子湖', 3, '0711', '436064', '114.68463', '30.10003', 'Liangzihu', '1', 0);
INSERT INTO `hh_region` VALUES (420703, '华容区', 420700, '华容', 3, '0711', '436030', '114.73568', '30.53328', 'Huarong', '1', 0);
INSERT INTO `hh_region` VALUES (420704, '鄂城区', 420700, '鄂城', 3, '0711', '436000', '114.89158', '30.40024', 'Echeng', '1', 0);
INSERT INTO `hh_region` VALUES (420800, '荆门市', 420000, '荆门', 2, '0724', '448000', '112.204251', '31.03542', 'Jingmen', '1', 0);
INSERT INTO `hh_region` VALUES (420802, '东宝区', 420800, '东宝', 3, '0724', '448004', '112.20147', '31.05192', 'Dongbao', '1', 0);
INSERT INTO `hh_region` VALUES (420804, '掇刀区', 420800, '掇刀', 3, '0724', '448124', '112.208', '30.97316', 'Duodao', '1', 0);
INSERT INTO `hh_region` VALUES (420821, '京山县', 420800, '京山', 3, '0724', '431800', '113.11074', '31.0224', 'Jingshan', '1', 0);
INSERT INTO `hh_region` VALUES (420822, '沙洋县', 420800, '沙洋', 3, '0724', '448200', '112.58853', '30.70916', 'Shayang', '1', 0);
INSERT INTO `hh_region` VALUES (420881, '钟祥市', 420800, '钟祥', 3, '0724', '431900', '112.58932', '31.1678', 'Zhongxiang', '1', 0);
INSERT INTO `hh_region` VALUES (420900, '孝感市', 420000, '孝感', 2, '0712', '432100', '113.926655', '30.926423', 'Xiaogan', '1', 0);
INSERT INTO `hh_region` VALUES (420902, '孝南区', 420900, '孝南', 3, '0712', '432100', '113.91111', '30.9168', 'Xiaonan', '1', 0);
INSERT INTO `hh_region` VALUES (420921, '孝昌县', 420900, '孝昌', 3, '0712', '432900', '113.99795', '31.25799', 'Xiaochang', '1', 0);
INSERT INTO `hh_region` VALUES (420922, '大悟县', 420900, '大悟', 3, '0712', '432800', '114.12564', '31.56176', 'Dawu', '1', 0);
INSERT INTO `hh_region` VALUES (420923, '云梦县', 420900, '云梦', 3, '0712', '432500', '113.75289', '31.02093', 'Yunmeng', '1', 0);
INSERT INTO `hh_region` VALUES (420981, '应城市', 420900, '应城', 3, '0712', '432400', '113.57287', '30.92834', 'Yingcheng', '1', 0);
INSERT INTO `hh_region` VALUES (420982, '安陆市', 420900, '安陆', 3, '0712', '432600', '113.68557', '31.25693', 'Anlu', '1', 0);
INSERT INTO `hh_region` VALUES (420984, '汉川市', 420900, '汉川', 3, '0712', '432300', '113.83898', '30.66117', 'Hanchuan', '1', 0);
INSERT INTO `hh_region` VALUES (421000, '荆州市', 420000, '荆州', 2, '0716', '434000', '112.23813', '30.326857', 'Jingzhou', '1', 0);
INSERT INTO `hh_region` VALUES (421002, '沙市区', 421000, '沙市', 3, '0716', '434000', '112.25543', '30.31107', 'Shashi', '1', 0);
INSERT INTO `hh_region` VALUES (421003, '荆州区', 421000, '荆州', 3, '0716', '434020', '112.19006', '30.35264', 'Jingzhou', '1', 0);
INSERT INTO `hh_region` VALUES (421022, '公安县', 421000, '公安', 3, '0716', '434300', '112.23242', '30.05902', 'Gong\'an', '1', 0);
INSERT INTO `hh_region` VALUES (421023, '监利县', 421000, '监利', 3, '0716', '433300', '112.89462', '29.81494', 'Jianli', '1', 0);
INSERT INTO `hh_region` VALUES (421024, '江陵县', 421000, '江陵', 3, '0716', '434101', '112.42468', '30.04174', 'Jiangling', '1', 0);
INSERT INTO `hh_region` VALUES (421081, '石首市', 421000, '石首', 3, '0716', '434400', '112.42636', '29.72127', 'Shishou', '1', 0);
INSERT INTO `hh_region` VALUES (421083, '洪湖市', 421000, '洪湖', 3, '0716', '433200', '113.47598', '29.827', 'Honghu', '1', 0);
INSERT INTO `hh_region` VALUES (421087, '松滋市', 421000, '松滋', 3, '0716', '434200', '111.76739', '30.16965', 'Songzi', '1', 0);
INSERT INTO `hh_region` VALUES (421100, '黄冈市', 420000, '黄冈', 2, '0713', '438000', '114.879365', '30.447711', 'Huanggang', '1', 0);
INSERT INTO `hh_region` VALUES (421102, '黄州区', 421100, '黄州', 3, '0713', '438000', '114.88008', '30.43436', 'Huangzhou', '1', 0);
INSERT INTO `hh_region` VALUES (421121, '团风县', 421100, '团风', 3, '0713', '438800', '114.87228', '30.64359', 'Tuanfeng', '1', 0);
INSERT INTO `hh_region` VALUES (421122, '红安县', 421100, '红安', 3, '0713', '438401', '114.6224', '31.28668', 'Hong\'an', '1', 0);
INSERT INTO `hh_region` VALUES (421123, '罗田县', 421100, '罗田', 3, '0713', '438600', '115.39971', '30.78255', 'Luotian', '1', 0);
INSERT INTO `hh_region` VALUES (421124, '英山县', 421100, '英山', 3, '0713', '438700', '115.68142', '30.73516', 'Yingshan', '1', 0);
INSERT INTO `hh_region` VALUES (421125, '浠水县', 421100, '浠水', 3, '0713', '438200', '115.26913', '30.45265', 'Xishui', '1', 0);
INSERT INTO `hh_region` VALUES (421126, '蕲春县', 421100, '蕲春', 3, '0713', '435300', '115.43615', '30.22613', 'Qichun', '1', 0);
INSERT INTO `hh_region` VALUES (421127, '黄梅县', 421100, '黄梅', 3, '0713', '435500', '115.94427', '30.07033', 'Huangmei', '1', 0);
INSERT INTO `hh_region` VALUES (421181, '麻城市', 421100, '麻城', 3, '0713', '438300', '115.00988', '31.17228', 'Macheng', '1', 0);
INSERT INTO `hh_region` VALUES (421182, '武穴市', 421100, '武穴', 3, '0713', '435400', '115.55975', '29.84446', 'Wuxue', '1', 0);
INSERT INTO `hh_region` VALUES (421200, '咸宁市', 420000, '咸宁', 2, '0715', '437000', '114.328963', '29.832798', 'Xianning', '1', 0);
INSERT INTO `hh_region` VALUES (421202, '咸安区', 421200, '咸安', 3, '0715', '437000', '114.29872', '29.8529', 'Xian\'an', '1', 0);
INSERT INTO `hh_region` VALUES (421221, '嘉鱼县', 421200, '嘉鱼', 3, '0715', '437200', '113.93927', '29.97054', 'Jiayu', '1', 0);
INSERT INTO `hh_region` VALUES (421222, '通城县', 421200, '通城', 3, '0715', '437400', '113.81582', '29.24568', 'Tongcheng', '1', 0);
INSERT INTO `hh_region` VALUES (421223, '崇阳县', 421200, '崇阳', 3, '0715', '437500', '114.03982', '29.55564', 'Chongyang', '1', 0);
INSERT INTO `hh_region` VALUES (421224, '通山县', 421200, '通山', 3, '0715', '437600', '114.48239', '29.6063', 'Tongshan', '1', 0);
INSERT INTO `hh_region` VALUES (421281, '赤壁市', 421200, '赤壁', 3, '0715', '437300', '113.90039', '29.72454', 'Chibi', '1', 0);
INSERT INTO `hh_region` VALUES (421300, '随州市', 420000, '随州', 2, '0722', '441300', '113.37377', '31.717497', 'Suizhou', '1', 0);
INSERT INTO `hh_region` VALUES (421303, '曾都区', 421300, '曾都', 3, '0722', '441300', '113.37128', '31.71614', 'Zengdu', '1', 0);
INSERT INTO `hh_region` VALUES (421321, '随县', 421300, '随县', 3, '0722', '441309', '113.82663', '31.6179', 'Suixian', '1', 0);
INSERT INTO `hh_region` VALUES (421381, '广水市', 421300, '广水', 3, '0722', '432700', '113.82663', '31.6179', 'Guangshui', '1', 0);
INSERT INTO `hh_region` VALUES (422800, '恩施土家族苗族自治州', 420000, '恩施', 2, '0718', '445000', '109.48699', '30.283114', 'Enshi', '1', 0);
INSERT INTO `hh_region` VALUES (422801, '恩施市', 422800, '恩施', 3, '0718', '445000', '109.47942', '30.29502', 'Enshi', '1', 0);
INSERT INTO `hh_region` VALUES (422802, '利川市', 422800, '利川', 3, '0718', '445400', '108.93591', '30.29117', 'Lichuan', '1', 0);
INSERT INTO `hh_region` VALUES (422822, '建始县', 422800, '建始', 3, '0718', '445300', '109.72207', '30.60209', 'Jianshi', '1', 0);
INSERT INTO `hh_region` VALUES (422823, '巴东县', 422800, '巴东', 3, '0718', '444300', '110.34066', '31.04233', 'Badong', '1', 0);
INSERT INTO `hh_region` VALUES (422825, '宣恩县', 422800, '宣恩', 3, '0718', '445500', '109.49179', '29.98714', 'Xuanen', '1', 0);
INSERT INTO `hh_region` VALUES (422826, '咸丰县', 422800, '咸丰', 3, '0718', '445600', '109.152', '29.67983', 'Xianfeng', '1', 0);
INSERT INTO `hh_region` VALUES (422827, '来凤县', 422800, '来凤', 3, '0718', '445700', '109.40716', '29.49373', 'Laifeng', '1', 0);
INSERT INTO `hh_region` VALUES (422828, '鹤峰县', 422800, '鹤峰', 3, '0718', '445800', '110.03091', '29.89072', 'Hefeng', '1', 0);
INSERT INTO `hh_region` VALUES (429000, '直辖县级', 420000, ' ', 2, '', '', '114.298572', '30.584355', '', '1', 0);
INSERT INTO `hh_region` VALUES (429004, '仙桃市', 429000, '仙桃', 3, '0728', '433000', '113.453974', '30.364953', 'Xiantao', '1', 0);
INSERT INTO `hh_region` VALUES (429005, '潜江市', 429000, '潜江', 3, '0728', '433100', '112.896866', '30.421215', 'Qianjiang', '1', 0);
INSERT INTO `hh_region` VALUES (429006, '天门市', 429000, '天门', 3, '0728', '431700', '113.165862', '30.653061', 'Tianmen', '1', 0);
INSERT INTO `hh_region` VALUES (429021, '神农架林区', 429000, '神农架', 3, '0719', '442400', '110.671525', '31.744449', 'Shennongjia', '1', 0);
INSERT INTO `hh_region` VALUES (430000, '湖南省', 100000, '湖南', 1, '', '', '112.982279', '28.19409', 'Hunan', '1', 0);
INSERT INTO `hh_region` VALUES (430100, '长沙市', 430000, '长沙', 2, '0731', '410005', '112.982279', '28.19409', 'Changsha', '1', 0);
INSERT INTO `hh_region` VALUES (430102, '芙蓉区', 430100, '芙蓉', 3, '0731', '410011', '113.03176', '28.1844', 'Furong', '1', 0);
INSERT INTO `hh_region` VALUES (430103, '天心区', 430100, '天心', 3, '0731', '410004', '112.98991', '28.1127', 'Tianxin', '1', 0);
INSERT INTO `hh_region` VALUES (430104, '岳麓区', 430100, '岳麓', 3, '0731', '410013', '112.93133', '28.2351', 'Yuelu', '1', 0);
INSERT INTO `hh_region` VALUES (430105, '开福区', 430100, '开福', 3, '0731', '410008', '112.98623', '28.25585', 'Kaifu', '1', 0);
INSERT INTO `hh_region` VALUES (430111, '雨花区', 430100, '雨花', 3, '0731', '410011', '113.03567', '28.13541', 'Yuhua', '1', 0);
INSERT INTO `hh_region` VALUES (430112, '望城区', 430100, '望城', 3, '0731', '410200', '112.819549', '28.347458', 'Wangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (430121, '长沙县', 430100, '长沙', 3, '0731', '410100', '113.08071', '28.24595', 'Changsha', '1', 0);
INSERT INTO `hh_region` VALUES (430124, '宁乡县', 430100, '宁乡', 3, '0731', '410600', '112.55749', '28.25358', 'Ningxiang', '1', 0);
INSERT INTO `hh_region` VALUES (430181, '浏阳市', 430100, '浏阳', 3, '0731', '410300', '113.64312', '28.16375', 'Liuyang', '1', 0);
INSERT INTO `hh_region` VALUES (430200, '株洲市', 430000, '株洲', 2, '0731', '412000', '113.151737', '27.835806', 'Zhuzhou', '1', 0);
INSERT INTO `hh_region` VALUES (430202, '荷塘区', 430200, '荷塘', 3, '0731', '412000', '113.17315', '27.85569', 'Hetang', '1', 0);
INSERT INTO `hh_region` VALUES (430203, '芦淞区', 430200, '芦淞', 3, '0731', '412000', '113.15562', '27.78525', 'Lusong', '1', 0);
INSERT INTO `hh_region` VALUES (430204, '石峰区', 430200, '石峰', 3, '0731', '412005', '113.11776', '27.87552', 'Shifeng', '1', 0);
INSERT INTO `hh_region` VALUES (430211, '天元区', 430200, '天元', 3, '0731', '412007', '113.12335', '27.83103', 'Tianyuan', '1', 0);
INSERT INTO `hh_region` VALUES (430221, '株洲县', 430200, '株洲', 3, '0731', '412100', '113.14428', '27.69826', 'Zhuzhou', '1', 0);
INSERT INTO `hh_region` VALUES (430223, '攸县', 430200, '攸县', 3, '0731', '412300', '113.34365', '27.00352', 'Youxian', '1', 0);
INSERT INTO `hh_region` VALUES (430224, '茶陵县', 430200, '茶陵', 3, '0731', '412400', '113.54364', '26.7915', 'Chaling', '1', 0);
INSERT INTO `hh_region` VALUES (430225, '炎陵县', 430200, '炎陵', 3, '0731', '412500', '113.77163', '26.48818', 'Yanling', '1', 0);
INSERT INTO `hh_region` VALUES (430281, '醴陵市', 430200, '醴陵', 3, '0731', '412200', '113.49704', '27.64615', 'Liling', '1', 0);
INSERT INTO `hh_region` VALUES (430300, '湘潭市', 430000, '湘潭', 2, '0731', '411100', '112.925083', '27.846725', 'Xiangtan', '1', 0);
INSERT INTO `hh_region` VALUES (430302, '雨湖区', 430300, '雨湖', 3, '0731', '411100', '112.90399', '27.86859', 'Yuhu', '1', 0);
INSERT INTO `hh_region` VALUES (430304, '岳塘区', 430300, '岳塘', 3, '0731', '411101', '112.9606', '27.85784', 'Yuetang', '1', 0);
INSERT INTO `hh_region` VALUES (430321, '湘潭县', 430300, '湘潭', 3, '0731', '411228', '112.9508', '27.77893', 'Xiangtan', '1', 0);
INSERT INTO `hh_region` VALUES (430381, '湘乡市', 430300, '湘乡', 3, '0731', '411400', '112.53512', '27.73543', 'Xiangxiang', '1', 0);
INSERT INTO `hh_region` VALUES (430382, '韶山市', 430300, '韶山', 3, '0731', '411300', '112.52655', '27.91503', 'Shaoshan', '1', 0);
INSERT INTO `hh_region` VALUES (430400, '衡阳市', 430000, '衡阳', 2, '0734', '421001', '112.607693', '26.900358', 'Hengyang', '1', 0);
INSERT INTO `hh_region` VALUES (430405, '珠晖区', 430400, '珠晖', 3, '0734', '421002', '112.62054', '26.89361', 'Zhuhui', '1', 0);
INSERT INTO `hh_region` VALUES (430406, '雁峰区', 430400, '雁峰', 3, '0734', '421001', '112.61654', '26.88866', 'Yanfeng', '1', 0);
INSERT INTO `hh_region` VALUES (430407, '石鼓区', 430400, '石鼓', 3, '0734', '421005', '112.61069', '26.90232', 'Shigu', '1', 0);
INSERT INTO `hh_region` VALUES (430408, '蒸湘区', 430400, '蒸湘', 3, '0734', '421001', '112.6033', '26.89651', 'Zhengxiang', '1', 0);
INSERT INTO `hh_region` VALUES (430412, '南岳区', 430400, '南岳', 3, '0734', '421900', '112.7384', '27.23262', 'Nanyue', '1', 0);
INSERT INTO `hh_region` VALUES (430421, '衡阳县', 430400, '衡阳', 3, '0734', '421200', '112.37088', '26.9706', 'Hengyang', '1', 0);
INSERT INTO `hh_region` VALUES (430422, '衡南县', 430400, '衡南', 3, '0734', '421131', '112.67788', '26.73828', 'Hengnan', '1', 0);
INSERT INTO `hh_region` VALUES (430423, '衡山县', 430400, '衡山', 3, '0734', '421300', '112.86776', '27.23134', 'Hengshan', '1', 0);
INSERT INTO `hh_region` VALUES (430424, '衡东县', 430400, '衡东', 3, '0734', '421400', '112.94833', '27.08093', 'Hengdong', '1', 0);
INSERT INTO `hh_region` VALUES (430426, '祁东县', 430400, '祁东', 3, '0734', '421600', '112.09039', '26.79964', 'Qidong', '1', 0);
INSERT INTO `hh_region` VALUES (430481, '耒阳市', 430400, '耒阳', 3, '0734', '421800', '112.85998', '26.42132', 'Leiyang', '1', 0);
INSERT INTO `hh_region` VALUES (430482, '常宁市', 430400, '常宁', 3, '0734', '421500', '112.4009', '26.40692', 'Changning', '1', 0);
INSERT INTO `hh_region` VALUES (430500, '邵阳市', 430000, '邵阳', 2, '0739', '422000', '111.46923', '27.237842', 'Shaoyang', '1', 0);
INSERT INTO `hh_region` VALUES (430502, '双清区', 430500, '双清', 3, '0739', '422001', '111.49715', '27.23291', 'Shuangqing', '1', 0);
INSERT INTO `hh_region` VALUES (430503, '大祥区', 430500, '大祥', 3, '0739', '422000', '111.45412', '27.23332', 'Daxiang', '1', 0);
INSERT INTO `hh_region` VALUES (430511, '北塔区', 430500, '北塔', 3, '0739', '422007', '111.45219', '27.24648', 'Beita', '1', 0);
INSERT INTO `hh_region` VALUES (430521, '邵东县', 430500, '邵东', 3, '0739', '422800', '111.74441', '27.2584', 'Shaodong', '1', 0);
INSERT INTO `hh_region` VALUES (430522, '新邵县', 430500, '新邵', 3, '0739', '422900', '111.46066', '27.32169', 'Xinshao', '1', 0);
INSERT INTO `hh_region` VALUES (430523, '邵阳县', 430500, '邵阳', 3, '0739', '422100', '111.27459', '26.99143', 'Shaoyang', '1', 0);
INSERT INTO `hh_region` VALUES (430524, '隆回县', 430500, '隆回', 3, '0739', '422200', '111.03216', '27.10937', 'Longhui', '1', 0);
INSERT INTO `hh_region` VALUES (430525, '洞口县', 430500, '洞口', 3, '0739', '422300', '110.57388', '27.05462', 'Dongkou', '1', 0);
INSERT INTO `hh_region` VALUES (430527, '绥宁县', 430500, '绥宁', 3, '0739', '422600', '110.15576', '26.58636', 'Suining', '1', 0);
INSERT INTO `hh_region` VALUES (430528, '新宁县', 430500, '新宁', 3, '0739', '422700', '110.85131', '26.42936', 'Xinning', '1', 0);
INSERT INTO `hh_region` VALUES (430529, '城步苗族自治县', 430500, '城步', 3, '0739', '422500', '110.3222', '26.39048', 'Chengbu', '1', 0);
INSERT INTO `hh_region` VALUES (430581, '武冈市', 430500, '武冈', 3, '0739', '422400', '110.63281', '26.72817', 'Wugang', '1', 0);
INSERT INTO `hh_region` VALUES (430600, '岳阳市', 430000, '岳阳', 2, '0730', '414000', '113.132855', '29.37029', 'Yueyang', '1', 0);
INSERT INTO `hh_region` VALUES (430602, '岳阳楼区', 430600, '岳阳楼', 3, '0730', '414000', '113.12942', '29.3719', 'Yueyanglou', '1', 0);
INSERT INTO `hh_region` VALUES (430603, '云溪区', 430600, '云溪', 3, '0730', '414009', '113.27713', '29.47357', 'Yunxi', '1', 0);
INSERT INTO `hh_region` VALUES (430611, '君山区', 430600, '君山', 3, '0730', '414005', '113.00439', '29.45941', 'Junshan', '1', 0);
INSERT INTO `hh_region` VALUES (430621, '岳阳县', 430600, '岳阳', 3, '0730', '414100', '113.11987', '29.14314', 'Yueyang', '1', 0);
INSERT INTO `hh_region` VALUES (430623, '华容县', 430600, '华容', 3, '0730', '414200', '112.54089', '29.53019', 'Huarong', '1', 0);
INSERT INTO `hh_region` VALUES (430624, '湘阴县', 430600, '湘阴', 3, '0730', '414600', '112.90911', '28.68922', 'Xiangyin', '1', 0);
INSERT INTO `hh_region` VALUES (430626, '平江县', 430600, '平江', 3, '0730', '414500', '113.58105', '28.70664', 'Pingjiang', '1', 0);
INSERT INTO `hh_region` VALUES (430681, '汨罗市', 430600, '汨罗', 3, '0730', '414400', '113.06707', '28.80631', 'Miluo', '1', 0);
INSERT INTO `hh_region` VALUES (430682, '临湘市', 430600, '临湘', 3, '0730', '414300', '113.4501', '29.47701', 'Linxiang', '1', 0);
INSERT INTO `hh_region` VALUES (430700, '常德市', 430000, '常德', 2, '0736', '415000', '111.691347', '29.040225', 'Changde', '1', 0);
INSERT INTO `hh_region` VALUES (430702, '武陵区', 430700, '武陵', 3, '0736', '415000', '111.69791', '29.02876', 'Wuling', '1', 0);
INSERT INTO `hh_region` VALUES (430703, '鼎城区', 430700, '鼎城', 3, '0736', '415101', '111.68078', '29.01859', 'Dingcheng', '1', 0);
INSERT INTO `hh_region` VALUES (430721, '安乡县', 430700, '安乡', 3, '0736', '415600', '112.16732', '29.41326', 'Anxiang', '1', 0);
INSERT INTO `hh_region` VALUES (430722, '汉寿县', 430700, '汉寿', 3, '0736', '415900', '111.96691', '28.90299', 'Hanshou', '1', 0);
INSERT INTO `hh_region` VALUES (430723, '澧县', 430700, '澧县', 3, '0736', '415500', '111.75866', '29.63317', 'Lixian', '1', 0);
INSERT INTO `hh_region` VALUES (430724, '临澧县', 430700, '临澧', 3, '0736', '415200', '111.65161', '29.44163', 'Linli', '1', 0);
INSERT INTO `hh_region` VALUES (430725, '桃源县', 430700, '桃源', 3, '0736', '415700', '111.48892', '28.90474', 'Taoyuan', '1', 0);
INSERT INTO `hh_region` VALUES (430726, '石门县', 430700, '石门', 3, '0736', '415300', '111.37966', '29.58424', 'Shimen', '1', 0);
INSERT INTO `hh_region` VALUES (430781, '津市市', 430700, '津市', 3, '0736', '415400', '111.87756', '29.60563', 'Jinshi', '1', 0);
INSERT INTO `hh_region` VALUES (430800, '张家界市', 430000, '张家界', 2, '0744', '427000', '110.479921', '29.127401', 'Zhangjiajie', '1', 0);
INSERT INTO `hh_region` VALUES (430802, '永定区', 430800, '永定', 3, '0744', '427000', '110.47464', '29.13387', 'Yongding', '1', 0);
INSERT INTO `hh_region` VALUES (430811, '武陵源区', 430800, '武陵源', 3, '0744', '427400', '110.55026', '29.34574', 'Wulingyuan', '1', 0);
INSERT INTO `hh_region` VALUES (430821, '慈利县', 430800, '慈利', 3, '0744', '427200', '111.13946', '29.42989', 'Cili', '1', 0);
INSERT INTO `hh_region` VALUES (430822, '桑植县', 430800, '桑植', 3, '0744', '427100', '110.16308', '29.39815', 'Sangzhi', '1', 0);
INSERT INTO `hh_region` VALUES (430900, '益阳市', 430000, '益阳', 2, '0737', '413000', '112.355042', '28.570066', 'Yiyang', '1', 0);
INSERT INTO `hh_region` VALUES (430902, '资阳区', 430900, '资阳', 3, '0737', '413001', '112.32447', '28.59095', 'Ziyang', '1', 0);
INSERT INTO `hh_region` VALUES (430903, '赫山区', 430900, '赫山', 3, '0737', '413002', '112.37265', '28.57425', 'Heshan', '1', 0);
INSERT INTO `hh_region` VALUES (430921, '南县', 430900, '南县', 3, '0737', '413200', '112.3963', '29.36159', 'Nanxian', '1', 0);
INSERT INTO `hh_region` VALUES (430922, '桃江县', 430900, '桃江', 3, '0737', '413400', '112.1557', '28.51814', 'Taojiang', '1', 0);
INSERT INTO `hh_region` VALUES (430923, '安化县', 430900, '安化', 3, '0737', '413500', '111.21298', '28.37424', 'Anhua', '1', 0);
INSERT INTO `hh_region` VALUES (430981, '沅江市', 430900, '沅江', 3, '0737', '413100', '112.35427', '28.84403', 'Yuanjiang', '1', 0);
INSERT INTO `hh_region` VALUES (431000, '郴州市', 430000, '郴州', 2, '0735', '423000', '113.032067', '25.793589', 'Chenzhou', '1', 0);
INSERT INTO `hh_region` VALUES (431002, '北湖区', 431000, '北湖', 3, '0735', '423000', '113.01103', '25.78405', 'Beihu', '1', 0);
INSERT INTO `hh_region` VALUES (431003, '苏仙区', 431000, '苏仙', 3, '0735', '423000', '113.04226', '25.80045', 'Suxian', '1', 0);
INSERT INTO `hh_region` VALUES (431021, '桂阳县', 431000, '桂阳', 3, '0735', '424400', '112.73364', '25.75406', 'Guiyang', '1', 0);
INSERT INTO `hh_region` VALUES (431022, '宜章县', 431000, '宜章', 3, '0735', '424200', '112.95147', '25.39931', 'Yizhang', '1', 0);
INSERT INTO `hh_region` VALUES (431023, '永兴县', 431000, '永兴', 3, '0735', '423300', '113.11242', '26.12646', 'Yongxing', '1', 0);
INSERT INTO `hh_region` VALUES (431024, '嘉禾县', 431000, '嘉禾', 3, '0735', '424500', '112.36935', '25.58795', 'Jiahe', '1', 0);
INSERT INTO `hh_region` VALUES (431025, '临武县', 431000, '临武', 3, '0735', '424300', '112.56369', '25.27602', 'Linwu', '1', 0);
INSERT INTO `hh_region` VALUES (431026, '汝城县', 431000, '汝城', 3, '0735', '424100', '113.68582', '25.55204', 'Rucheng', '1', 0);
INSERT INTO `hh_region` VALUES (431027, '桂东县', 431000, '桂东', 3, '0735', '423500', '113.9468', '26.07987', 'Guidong', '1', 0);
INSERT INTO `hh_region` VALUES (431028, '安仁县', 431000, '安仁', 3, '0735', '423600', '113.26944', '26.70931', 'Anren', '1', 0);
INSERT INTO `hh_region` VALUES (431081, '资兴市', 431000, '资兴', 3, '0735', '423400', '113.23724', '25.97668', 'Zixing', '1', 0);
INSERT INTO `hh_region` VALUES (431100, '永州市', 430000, '永州', 2, '0746', '425000', '111.608019', '26.434516', 'Yongzhou', '1', 0);
INSERT INTO `hh_region` VALUES (431102, '零陵区', 431100, '零陵', 3, '0746', '425100', '111.62103', '26.22109', 'Lingling', '1', 0);
INSERT INTO `hh_region` VALUES (431103, '冷水滩区', 431100, '冷水滩', 3, '0746', '425100', '111.59214', '26.46107', 'Lengshuitan', '1', 0);
INSERT INTO `hh_region` VALUES (431121, '祁阳县', 431100, '祁阳', 3, '0746', '426100', '111.84011', '26.58009', 'Qiyang', '1', 0);
INSERT INTO `hh_region` VALUES (431122, '东安县', 431100, '东安', 3, '0746', '425900', '111.3164', '26.39202', 'Dong\'an', '1', 0);
INSERT INTO `hh_region` VALUES (431123, '双牌县', 431100, '双牌', 3, '0746', '425200', '111.65927', '25.95988', 'Shuangpai', '1', 0);
INSERT INTO `hh_region` VALUES (431124, '道县', 431100, '道县', 3, '0746', '425300', '111.60195', '25.52766', 'Daoxian', '1', 0);
INSERT INTO `hh_region` VALUES (431125, '江永县', 431100, '江永', 3, '0746', '425400', '111.34082', '25.27233', 'Jiangyong', '1', 0);
INSERT INTO `hh_region` VALUES (431126, '宁远县', 431100, '宁远', 3, '0746', '425600', '111.94625', '25.56913', 'Ningyuan', '1', 0);
INSERT INTO `hh_region` VALUES (431127, '蓝山县', 431100, '蓝山', 3, '0746', '425800', '112.19363', '25.36794', 'Lanshan', '1', 0);
INSERT INTO `hh_region` VALUES (431128, '新田县', 431100, '新田', 3, '0746', '425700', '112.22103', '25.9095', 'Xintian', '1', 0);
INSERT INTO `hh_region` VALUES (431129, '江华瑶族自治县', 431100, '江华', 3, '0746', '425500', '111.58847', '25.1845', 'Jianghua', '1', 0);
INSERT INTO `hh_region` VALUES (431200, '怀化市', 430000, '怀化', 2, '0745', '418000', '109.97824', '27.550082', 'Huaihua', '1', 0);
INSERT INTO `hh_region` VALUES (431202, '鹤城区', 431200, '鹤城', 3, '0745', '418000', '109.96509', '27.54942', 'Hecheng', '1', 0);
INSERT INTO `hh_region` VALUES (431221, '中方县', 431200, '中方', 3, '0745', '418005', '109.94497', '27.43988', 'Zhongfang', '1', 0);
INSERT INTO `hh_region` VALUES (431222, '沅陵县', 431200, '沅陵', 3, '0745', '419600', '110.39633', '28.45548', 'Yuanling', '1', 0);
INSERT INTO `hh_region` VALUES (431223, '辰溪县', 431200, '辰溪', 3, '0745', '419500', '110.18942', '28.00406', 'Chenxi', '1', 0);
INSERT INTO `hh_region` VALUES (431224, '溆浦县', 431200, '溆浦', 3, '0745', '419300', '110.59384', '27.90836', 'Xupu', '1', 0);
INSERT INTO `hh_region` VALUES (431225, '会同县', 431200, '会同', 3, '0745', '418300', '109.73568', '26.88716', 'Huitong', '1', 0);
INSERT INTO `hh_region` VALUES (431226, '麻阳苗族自治县', 431200, '麻阳', 3, '0745', '419400', '109.80194', '27.866', 'Mayang', '1', 0);
INSERT INTO `hh_region` VALUES (431227, '新晃侗族自治县', 431200, '新晃', 3, '0745', '419200', '109.17166', '27.35937', 'Xinhuang', '1', 0);
INSERT INTO `hh_region` VALUES (431228, '芷江侗族自治县', 431200, '芷江', 3, '0745', '419100', '109.6849', '27.44297', 'Zhijiang', '1', 0);
INSERT INTO `hh_region` VALUES (431229, '靖州苗族侗族自治县', 431200, '靖州', 3, '0745', '418400', '109.69821', '26.57651', 'Jingzhou', '1', 0);
INSERT INTO `hh_region` VALUES (431230, '通道侗族自治县', 431200, '通道', 3, '0745', '418500', '109.78515', '26.1571', 'Tongdao', '1', 0);
INSERT INTO `hh_region` VALUES (431281, '洪江市', 431200, '洪江', 3, '0745', '418100', '109.83651', '27.20922', 'Hongjiang', '1', 0);
INSERT INTO `hh_region` VALUES (431300, '娄底市', 430000, '娄底', 2, '0738', '417000', '112.008497', '27.728136', 'Loudi', '1', 0);
INSERT INTO `hh_region` VALUES (431302, '娄星区', 431300, '娄星', 3, '0738', '417000', '112.00193', '27.72992', 'Louxing', '1', 0);
INSERT INTO `hh_region` VALUES (431321, '双峰县', 431300, '双峰', 3, '0738', '417700', '112.19921', '27.45418', 'Shuangfeng', '1', 0);
INSERT INTO `hh_region` VALUES (431322, '新化县', 431300, '新化', 3, '0738', '417600', '111.32739', '27.7266', 'Xinhua', '1', 0);
INSERT INTO `hh_region` VALUES (431381, '冷水江市', 431300, '冷水江', 3, '0738', '417500', '111.43554', '27.68147', 'Lengshuijiang', '1', 0);
INSERT INTO `hh_region` VALUES (431382, '涟源市', 431300, '涟源', 3, '0738', '417100', '111.67233', '27.68831', 'Lianyuan', '1', 0);
INSERT INTO `hh_region` VALUES (433100, '湘西土家族苗族自治州', 430000, '湘西', 2, '0743', '416000', '109.739735', '28.314296', 'Xiangxi', '1', 0);
INSERT INTO `hh_region` VALUES (433101, '吉首市', 433100, '吉首', 3, '0743', '416000', '109.69799', '28.26247', 'Jishou', '1', 0);
INSERT INTO `hh_region` VALUES (433122, '泸溪县', 433100, '泸溪', 3, '0743', '416100', '110.21682', '28.2205', 'Luxi', '1', 0);
INSERT INTO `hh_region` VALUES (433123, '凤凰县', 433100, '凤凰', 3, '0743', '416200', '109.60156', '27.94822', 'Fenghuang', '1', 0);
INSERT INTO `hh_region` VALUES (433124, '花垣县', 433100, '花垣', 3, '0743', '416400', '109.48217', '28.5721', 'Huayuan', '1', 0);
INSERT INTO `hh_region` VALUES (433125, '保靖县', 433100, '保靖', 3, '0743', '416500', '109.66049', '28.69997', 'Baojing', '1', 0);
INSERT INTO `hh_region` VALUES (433126, '古丈县', 433100, '古丈', 3, '0743', '416300', '109.94812', '28.61944', 'Guzhang', '1', 0);
INSERT INTO `hh_region` VALUES (433127, '永顺县', 433100, '永顺', 3, '0743', '416700', '109.85266', '29.00103', 'Yongshun', '1', 0);
INSERT INTO `hh_region` VALUES (433130, '龙山县', 433100, '龙山', 3, '0743', '416800', '109.4432', '29.45693', 'Longshan', '1', 0);
INSERT INTO `hh_region` VALUES (440000, '广东省', 100000, '广东', 1, '', '', '113.280637', '23.125178', 'Guangdong', '1', 0);
INSERT INTO `hh_region` VALUES (440100, '广州市', 440000, '广州', 2, '020', '510032', '113.280637', '23.125178', 'Guangzhou', '1', 0);
INSERT INTO `hh_region` VALUES (440103, '荔湾区', 440100, '荔湾', 3, '020', '510170', '113.2442', '23.12592', 'Liwan', '1', 0);
INSERT INTO `hh_region` VALUES (440104, '越秀区', 440100, '越秀', 3, '020', '510030', '113.26683', '23.12897', 'Yuexiu', '1', 0);
INSERT INTO `hh_region` VALUES (440105, '海珠区', 440100, '海珠', 3, '020', '510300', '113.26197', '23.10379', 'Haizhu', '1', 0);
INSERT INTO `hh_region` VALUES (440106, '天河区', 440100, '天河', 3, '020', '510665', '113.36112', '23.12467', 'Tianhe', '1', 0);
INSERT INTO `hh_region` VALUES (440111, '白云区', 440100, '白云', 3, '020', '510405', '113.27307', '23.15787', 'Baiyun', '1', 0);
INSERT INTO `hh_region` VALUES (440112, '黄埔区', 440100, '黄埔', 3, '020', '510700', '113.45895', '23.10642', 'Huangpu', '1', 0);
INSERT INTO `hh_region` VALUES (440113, '番禺区', 440100, '番禺', 3, '020', '511400', '113.38397', '22.93599', 'Panyu', '1', 0);
INSERT INTO `hh_region` VALUES (440114, '花都区', 440100, '花都', 3, '020', '510800', '113.22033', '23.40358', 'Huadu', '1', 0);
INSERT INTO `hh_region` VALUES (440115, '南沙区', 440100, '南沙', 3, '020', '511458', '113.60845', '22.77144', 'Nansha', '1', 0);
INSERT INTO `hh_region` VALUES (440117, '从化区', 440100, '从化', 3, '020', '510900', '113.587386', '23.545283', 'Conghua', '1', 0);
INSERT INTO `hh_region` VALUES (440118, '增城区', 440100, '增城', 3, '020', '511300', '113.829579', '23.290497', 'Zengcheng', '1', 0);
INSERT INTO `hh_region` VALUES (440200, '韶关市', 440000, '韶关', 2, '0751', '512002', '113.591544', '24.801322', 'Shaoguan', '1', 0);
INSERT INTO `hh_region` VALUES (440203, '武江区', 440200, '武江', 3, '0751', '512026', '113.58767', '24.79264', 'Wujiang', '1', 0);
INSERT INTO `hh_region` VALUES (440204, '浈江区', 440200, '浈江', 3, '0751', '512023', '113.61109', '24.80438', 'Zhenjiang', '1', 0);
INSERT INTO `hh_region` VALUES (440205, '曲江区', 440200, '曲江', 3, '0751', '512101', '113.60165', '24.67915', 'Qujiang', '1', 0);
INSERT INTO `hh_region` VALUES (440222, '始兴县', 440200, '始兴', 3, '0751', '512500', '114.06799', '24.94759', 'Shixing', '1', 0);
INSERT INTO `hh_region` VALUES (440224, '仁化县', 440200, '仁化', 3, '0751', '512300', '113.74737', '25.08742', 'Renhua', '1', 0);
INSERT INTO `hh_region` VALUES (440229, '翁源县', 440200, '翁源', 3, '0751', '512600', '114.13385', '24.3495', 'Wengyuan', '1', 0);
INSERT INTO `hh_region` VALUES (440232, '乳源瑶族自治县', 440200, '乳源', 3, '0751', '512700', '113.27734', '24.77803', 'Ruyuan', '1', 0);
INSERT INTO `hh_region` VALUES (440233, '新丰县', 440200, '新丰', 3, '0751', '511100', '114.20788', '24.05924', 'Xinfeng', '1', 0);
INSERT INTO `hh_region` VALUES (440281, '乐昌市', 440200, '乐昌', 3, '0751', '512200', '113.35653', '25.12799', 'Lechang', '1', 0);
INSERT INTO `hh_region` VALUES (440282, '南雄市', 440200, '南雄', 3, '0751', '512400', '114.30966', '25.11706', 'Nanxiong', '1', 0);
INSERT INTO `hh_region` VALUES (440300, '深圳市', 440000, '深圳', 2, '0755', '518035', '114.085947', '22.547', 'Shenzhen', '1', 0);
INSERT INTO `hh_region` VALUES (440303, '罗湖区', 440300, '罗湖', 3, '0755', '518021', '114.13116', '22.54836', 'Luohu', '1', 0);
INSERT INTO `hh_region` VALUES (440304, '福田区', 440300, '福田', 3, '0755', '518048', '114.05571', '22.52245', 'Futian', '1', 0);
INSERT INTO `hh_region` VALUES (440305, '南山区', 440300, '南山', 3, '0755', '518051', '113.93029', '22.53291', 'Nanshan', '1', 0);
INSERT INTO `hh_region` VALUES (440306, '宝安区', 440300, '宝安', 3, '0755', '518101', '113.88311', '22.55371', 'Bao\'an', '1', 0);
INSERT INTO `hh_region` VALUES (440307, '龙岗区', 440300, '龙岗', 3, '0755', '518172', '114.24771', '22.71986', 'Longgang', '1', 0);
INSERT INTO `hh_region` VALUES (440308, '盐田区', 440300, '盐田', 3, '0755', '518081', '114.23733', '22.5578', 'Yantian', '1', 0);
INSERT INTO `hh_region` VALUES (440309, '光明新区', 440300, '光明新区', 3, '0755', '518100', '113.896026', '22.777292', 'Guangmingxinqu', '1', 0);
INSERT INTO `hh_region` VALUES (440310, '坪山新区', 440300, '坪山新区', 3, '0755', '518000', '114.34637', '22.690529', 'Pingshanxinqu', '1', 0);
INSERT INTO `hh_region` VALUES (440311, '大鹏新区', 440300, '大鹏新区', 3, '0755', '518000', '114.479901', '22.587862', 'Dapengxinqu', '1', 0);
INSERT INTO `hh_region` VALUES (440312, '龙华新区', 440300, '龙华新区', 3, '0755', '518100', '114.036585', '22.68695', 'Longhuaxinqu', '1', 0);
INSERT INTO `hh_region` VALUES (440400, '珠海市', 440000, '珠海', 2, '0756', '519000', '113.552724', '22.255899', 'Zhuhai', '1', 0);
INSERT INTO `hh_region` VALUES (440402, '香洲区', 440400, '香洲', 3, '0756', '519000', '113.5435', '22.26654', 'Xiangzhou', '1', 0);
INSERT INTO `hh_region` VALUES (440403, '斗门区', 440400, '斗门', 3, '0756', '519110', '113.29644', '22.20898', 'Doumen', '1', 0);
INSERT INTO `hh_region` VALUES (440404, '金湾区', 440400, '金湾', 3, '0756', '519040', '113.36361', '22.14691', 'Jinwan', '1', 0);
INSERT INTO `hh_region` VALUES (440500, '汕头市', 440000, '汕头', 2, '0754', '515041', '116.708463', '23.37102', 'Shantou', '1', 0);
INSERT INTO `hh_region` VALUES (440507, '龙湖区', 440500, '龙湖', 3, '0754', '515041', '116.71641', '23.37166', 'Longhu', '1', 0);
INSERT INTO `hh_region` VALUES (440511, '金平区', 440500, '金平', 3, '0754', '515041', '116.70364', '23.36637', 'Jinping', '1', 0);
INSERT INTO `hh_region` VALUES (440512, '濠江区', 440500, '濠江', 3, '0754', '515071', '116.72659', '23.28588', 'Haojiang', '1', 0);
INSERT INTO `hh_region` VALUES (440513, '潮阳区', 440500, '潮阳', 3, '0754', '515100', '116.6015', '23.26485', 'Chaoyang', '1', 0);
INSERT INTO `hh_region` VALUES (440514, '潮南区', 440500, '潮南', 3, '0754', '515144', '116.43188', '23.25', 'Chaonan', '1', 0);
INSERT INTO `hh_region` VALUES (440515, '澄海区', 440500, '澄海', 3, '0754', '515800', '116.75589', '23.46728', 'Chenghai', '1', 0);
INSERT INTO `hh_region` VALUES (440523, '南澳县', 440500, '南澳', 3, '0754', '515900', '117.01889', '23.4223', 'Nanao', '1', 0);
INSERT INTO `hh_region` VALUES (440600, '佛山市', 440000, '佛山', 2, '0757', '528000', '113.122717', '23.028762', 'Foshan', '1', 0);
INSERT INTO `hh_region` VALUES (440604, '禅城区', 440600, '禅城', 3, '0757', '528000', '113.1228', '23.00842', 'Chancheng', '1', 0);
INSERT INTO `hh_region` VALUES (440605, '南海区', 440600, '南海', 3, '0757', '528251', '113.14299', '23.02877', 'Nanhai', '1', 0);
INSERT INTO `hh_region` VALUES (440606, '顺德区', 440600, '顺德', 3, '0757', '528300', '113.29394', '22.80452', 'Shunde', '1', 0);
INSERT INTO `hh_region` VALUES (440607, '三水区', 440600, '三水', 3, '0757', '528133', '112.89703', '23.15564', 'Sanshui', '1', 0);
INSERT INTO `hh_region` VALUES (440608, '高明区', 440600, '高明', 3, '0757', '528500', '112.89254', '22.90022', 'Gaoming', '1', 0);
INSERT INTO `hh_region` VALUES (440700, '江门市', 440000, '江门', 2, '0750', '529000', '113.094942', '22.590431', 'Jiangmen', '1', 0);
INSERT INTO `hh_region` VALUES (440703, '蓬江区', 440700, '蓬江', 3, '0750', '529000', '113.07849', '22.59515', 'Pengjiang', '1', 0);
INSERT INTO `hh_region` VALUES (440704, '江海区', 440700, '江海', 3, '0750', '529040', '113.11099', '22.56024', 'Jianghai', '1', 0);
INSERT INTO `hh_region` VALUES (440705, '新会区', 440700, '新会', 3, '0750', '529100', '113.03225', '22.45876', 'Xinhui', '1', 0);
INSERT INTO `hh_region` VALUES (440781, '台山市', 440700, '台山', 3, '0750', '529200', '112.79382', '22.2515', 'Taishan', '1', 0);
INSERT INTO `hh_region` VALUES (440783, '开平市', 440700, '开平', 3, '0750', '529337', '112.69842', '22.37622', 'Kaiping', '1', 0);
INSERT INTO `hh_region` VALUES (440784, '鹤山市', 440700, '鹤山', 3, '0750', '529700', '112.96429', '22.76523', 'Heshan', '1', 0);
INSERT INTO `hh_region` VALUES (440785, '恩平市', 440700, '恩平', 3, '0750', '529400', '112.30496', '22.18288', 'Enping', '1', 0);
INSERT INTO `hh_region` VALUES (440800, '湛江市', 440000, '湛江', 2, '0759', '524047', '110.405529', '21.195338', 'Zhanjiang', '1', 0);
INSERT INTO `hh_region` VALUES (440802, '赤坎区', 440800, '赤坎', 3, '0759', '524033', '110.36592', '21.26606', 'Chikan', '1', 0);
INSERT INTO `hh_region` VALUES (440803, '霞山区', 440800, '霞山', 3, '0759', '524011', '110.39822', '21.19181', 'Xiashan', '1', 0);
INSERT INTO `hh_region` VALUES (440804, '坡头区', 440800, '坡头', 3, '0759', '524057', '110.45533', '21.24472', 'Potou', '1', 0);
INSERT INTO `hh_region` VALUES (440811, '麻章区', 440800, '麻章', 3, '0759', '524094', '110.3342', '21.26333', 'Mazhang', '1', 0);
INSERT INTO `hh_region` VALUES (440823, '遂溪县', 440800, '遂溪', 3, '0759', '524300', '110.25003', '21.37721', 'Suixi', '1', 0);
INSERT INTO `hh_region` VALUES (440825, '徐闻县', 440800, '徐闻', 3, '0759', '524100', '110.17379', '20.32812', 'Xuwen', '1', 0);
INSERT INTO `hh_region` VALUES (440881, '廉江市', 440800, '廉江', 3, '0759', '524400', '110.28442', '21.60917', 'Lianjiang', '1', 0);
INSERT INTO `hh_region` VALUES (440882, '雷州市', 440800, '雷州', 3, '0759', '524200', '110.10092', '20.91428', 'Leizhou', '1', 0);
INSERT INTO `hh_region` VALUES (440883, '吴川市', 440800, '吴川', 3, '0759', '524500', '110.77703', '21.44584', 'Wuchuan', '1', 0);
INSERT INTO `hh_region` VALUES (440900, '茂名市', 440000, '茂名', 2, '0668', '525000', '110.919229', '21.659751', 'Maoming', '1', 0);
INSERT INTO `hh_region` VALUES (440902, '茂南区', 440900, '茂南', 3, '0668', '525000', '110.9187', '21.64103', 'Maonan', '1', 0);
INSERT INTO `hh_region` VALUES (440904, '电白区', 440900, '电白', 3, '0668', '525400', '111.007264', '21.507219', 'Dianbai', '1', 0);
INSERT INTO `hh_region` VALUES (440981, '高州市', 440900, '高州', 3, '0668', '525200', '110.85519', '21.92057', 'Gaozhou', '1', 0);
INSERT INTO `hh_region` VALUES (440982, '化州市', 440900, '化州', 3, '0668', '525100', '110.63949', '21.66394', 'Huazhou', '1', 0);
INSERT INTO `hh_region` VALUES (440983, '信宜市', 440900, '信宜', 3, '0668', '525300', '110.94647', '22.35351', 'Xinyi', '1', 0);
INSERT INTO `hh_region` VALUES (441200, '肇庆市', 440000, '肇庆', 2, '0758', '526040', '112.472529', '23.051546', 'Zhaoqing', '1', 0);
INSERT INTO `hh_region` VALUES (441202, '端州区', 441200, '端州', 3, '0758', '526060', '112.48495', '23.0519', 'Duanzhou', '1', 0);
INSERT INTO `hh_region` VALUES (441203, '鼎湖区', 441200, '鼎湖', 3, '0758', '526070', '112.56643', '23.15846', 'Dinghu', '1', 0);
INSERT INTO `hh_region` VALUES (441223, '广宁县', 441200, '广宁', 3, '0758', '526300', '112.44064', '23.6346', 'Guangning', '1', 0);
INSERT INTO `hh_region` VALUES (441224, '怀集县', 441200, '怀集', 3, '0758', '526400', '112.18396', '23.90918', 'Huaiji', '1', 0);
INSERT INTO `hh_region` VALUES (441225, '封开县', 441200, '封开', 3, '0758', '526500', '111.50332', '23.43571', 'Fengkai', '1', 0);
INSERT INTO `hh_region` VALUES (441226, '德庆县', 441200, '德庆', 3, '0758', '526600', '111.78555', '23.14371', 'Deqing', '1', 0);
INSERT INTO `hh_region` VALUES (441283, '高要市', 441200, '高要', 3, '0758', '526100', '112.45834', '23.02577', 'Gaoyao', '1', 0);
INSERT INTO `hh_region` VALUES (441284, '四会市', 441200, '四会', 3, '0758', '526200', '112.73416', '23.32686', 'Sihui', '1', 0);
INSERT INTO `hh_region` VALUES (441300, '惠州市', 440000, '惠州', 2, '0752', '516000', '114.412599', '23.079404', 'Huizhou', '1', 0);
INSERT INTO `hh_region` VALUES (441302, '惠城区', 441300, '惠城', 3, '0752', '516008', '114.3828', '23.08377', 'Huicheng', '1', 0);
INSERT INTO `hh_region` VALUES (441303, '惠阳区', 441300, '惠阳', 3, '0752', '516211', '114.45639', '22.78845', 'Huiyang', '1', 0);
INSERT INTO `hh_region` VALUES (441322, '博罗县', 441300, '博罗', 3, '0752', '516100', '114.28964', '23.17307', 'Boluo', '1', 0);
INSERT INTO `hh_region` VALUES (441323, '惠东县', 441300, '惠东', 3, '0752', '516300', '114.72009', '22.98484', 'Huidong', '1', 0);
INSERT INTO `hh_region` VALUES (441324, '龙门县', 441300, '龙门', 3, '0752', '516800', '114.25479', '23.72758', 'Longmen', '1', 0);
INSERT INTO `hh_region` VALUES (441400, '梅州市', 440000, '梅州', 2, '0753', '514021', '116.117582', '24.299112', 'Meizhou', '1', 0);
INSERT INTO `hh_region` VALUES (441402, '梅江区', 441400, '梅江', 3, '0753', '514000', '116.11663', '24.31062', 'Meijiang', '1', 0);
INSERT INTO `hh_region` VALUES (441403, '梅县区', 441400, '梅县', 3, '0753', '514787', '116.097753', '24.286739', 'Meixian', '1', 0);
INSERT INTO `hh_region` VALUES (441422, '大埔县', 441400, '大埔', 3, '0753', '514200', '116.69662', '24.35325', 'Dabu', '1', 0);
INSERT INTO `hh_region` VALUES (441423, '丰顺县', 441400, '丰顺', 3, '0753', '514300', '116.18219', '23.74094', 'Fengshun', '1', 0);
INSERT INTO `hh_region` VALUES (441424, '五华县', 441400, '五华', 3, '0753', '514400', '115.77893', '23.92417', 'Wuhua', '1', 0);
INSERT INTO `hh_region` VALUES (441426, '平远县', 441400, '平远', 3, '0753', '514600', '115.89556', '24.57116', 'Pingyuan', '1', 0);
INSERT INTO `hh_region` VALUES (441427, '蕉岭县', 441400, '蕉岭', 3, '0753', '514100', '116.17089', '24.65732', 'Jiaoling', '1', 0);
INSERT INTO `hh_region` VALUES (441481, '兴宁市', 441400, '兴宁', 3, '0753', '514500', '115.73141', '24.14001', 'Xingning', '1', 0);
INSERT INTO `hh_region` VALUES (441500, '汕尾市', 440000, '汕尾', 2, '0660', '516600', '115.364238', '22.774485', 'Shanwei', '1', 0);
INSERT INTO `hh_region` VALUES (441502, '城区', 441500, '城区', 3, '0660', '516600', '115.36503', '22.7789', 'Chengqu', '1', 0);
INSERT INTO `hh_region` VALUES (441521, '海丰县', 441500, '海丰', 3, '0660', '516400', '115.32336', '22.96653', 'Haifeng', '1', 0);
INSERT INTO `hh_region` VALUES (441523, '陆河县', 441500, '陆河', 3, '0660', '516700', '115.65597', '23.30365', 'Luhe', '1', 0);
INSERT INTO `hh_region` VALUES (441581, '陆丰市', 441500, '陆丰', 3, '0660', '516500', '115.64813', '22.94335', 'Lufeng', '1', 0);
INSERT INTO `hh_region` VALUES (441600, '河源市', 440000, '河源', 2, '0762', '517000', '114.697802', '23.746266', 'Heyuan', '1', 0);
INSERT INTO `hh_region` VALUES (441602, '源城区', 441600, '源城', 3, '0762', '517000', '114.70242', '23.7341', 'Yuancheng', '1', 0);
INSERT INTO `hh_region` VALUES (441621, '紫金县', 441600, '紫金', 3, '0762', '517400', '115.18365', '23.63867', 'Zijin', '1', 0);
INSERT INTO `hh_region` VALUES (441622, '龙川县', 441600, '龙川', 3, '0762', '517300', '115.26025', '24.10142', 'Longchuan', '1', 0);
INSERT INTO `hh_region` VALUES (441623, '连平县', 441600, '连平', 3, '0762', '517100', '114.49026', '24.37156', 'Lianping', '1', 0);
INSERT INTO `hh_region` VALUES (441624, '和平县', 441600, '和平', 3, '0762', '517200', '114.93841', '24.44319', 'Heping', '1', 0);
INSERT INTO `hh_region` VALUES (441625, '东源县', 441600, '东源', 3, '0762', '517583', '114.74633', '23.78835', 'Dongyuan', '1', 0);
INSERT INTO `hh_region` VALUES (441700, '阳江市', 440000, '阳江', 2, '0662', '529500', '111.975107', '21.859222', 'Yangjiang', '1', 0);
INSERT INTO `hh_region` VALUES (441702, '江城区', 441700, '江城', 3, '0662', '529500', '111.95488', '21.86193', 'Jiangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (441704, '阳东区', 441700, '阳东', 3, '0662', '529900', '112.01467', '21.87398', 'Yangdong', '1', 0);
INSERT INTO `hh_region` VALUES (441721, '阳西县', 441700, '阳西', 3, '0662', '529800', '111.61785', '21.75234', 'Yangxi', '1', 0);
INSERT INTO `hh_region` VALUES (441781, '阳春市', 441700, '阳春', 3, '0662', '529600', '111.78854', '22.17232', 'Yangchun', '1', 0);
INSERT INTO `hh_region` VALUES (441800, '清远市', 440000, '清远', 2, '0763', '511500', '113.036779', '23.704188', 'Qingyuan', '1', 0);
INSERT INTO `hh_region` VALUES (441802, '清城区', 441800, '清城', 3, '0763', '511515', '113.06265', '23.69784', 'Qingcheng', '1', 0);
INSERT INTO `hh_region` VALUES (441803, '清新区', 441800, '清新', 3, '0763', '511810', '113.015203', '23.736949', 'Qingxin', '1', 0);
INSERT INTO `hh_region` VALUES (441821, '佛冈县', 441800, '佛冈', 3, '0763', '511600', '113.53286', '23.87231', 'Fogang', '1', 0);
INSERT INTO `hh_region` VALUES (441823, '阳山县', 441800, '阳山', 3, '0763', '513100', '112.64129', '24.46516', 'Yangshan', '1', 0);
INSERT INTO `hh_region` VALUES (441825, '连山壮族瑶族自治县', 441800, '连山', 3, '0763', '513200', '112.0802', '24.56807', 'Lianshan', '1', 0);
INSERT INTO `hh_region` VALUES (441826, '连南瑶族自治县', 441800, '连南', 3, '0763', '513300', '112.28842', '24.71726', 'Liannan', '1', 0);
INSERT INTO `hh_region` VALUES (441881, '英德市', 441800, '英德', 3, '0763', '513000', '113.415', '24.18571', 'Yingde', '1', 0);
INSERT INTO `hh_region` VALUES (441882, '连州市', 441800, '连州', 3, '0763', '513400', '112.38153', '24.77913', 'Lianzhou', '1', 0);
INSERT INTO `hh_region` VALUES (441900, '东莞市', 440000, '东莞', 2, '0769', '523888', '113.760234', '23.048884', 'Dongguan', '1', 0);
INSERT INTO `hh_region` VALUES (441901, '莞城区', 441900, '莞城', 3, '0769', '523128', '113.751043', '23.053412', 'Guancheng', '1', 0);
INSERT INTO `hh_region` VALUES (441902, '南城区', 441900, '南城', 3, '0769', '523617', '113.752125', '23.02018', 'Nancheng', '1', 0);
INSERT INTO `hh_region` VALUES (441904, '万江区', 441900, '万江', 3, '0769', '523039', '113.739053', '23.043842', 'Wanjiang', '1', 0);
INSERT INTO `hh_region` VALUES (441905, '石碣镇', 441900, '石碣', 3, '0769', '523290', '113.80217', '23.09899', 'Shijie', '1', 0);
INSERT INTO `hh_region` VALUES (441906, '石龙镇', 441900, '石龙', 3, '0769', '523326', '113.876381', '23.107444', 'Shilong', '1', 0);
INSERT INTO `hh_region` VALUES (441907, '茶山镇', 441900, '茶山', 3, '0769', '523380', '113.883526', '23.062375', 'Chashan', '1', 0);
INSERT INTO `hh_region` VALUES (441908, '石排镇', 441900, '石排', 3, '0769', '523346', '113.919859', '23.0863', 'Shipai', '1', 0);
INSERT INTO `hh_region` VALUES (441909, '企石镇', 441900, '企石', 3, '0769', '523507', '114.013233', '23.066044', 'Qishi', '1', 0);
INSERT INTO `hh_region` VALUES (441910, '横沥镇', 441900, '横沥', 3, '0769', '523471', '113.957436', '23.025732', 'Hengli', '1', 0);
INSERT INTO `hh_region` VALUES (441911, '桥头镇', 441900, '桥头', 3, '0769', '523520', '114.01385', '22.939727', 'Qiaotou', '1', 0);
INSERT INTO `hh_region` VALUES (441912, '谢岗镇', 441900, '谢岗', 3, '0769', '523592', '114.141396', '22.959664', 'Xiegang', '1', 0);
INSERT INTO `hh_region` VALUES (441913, '东坑镇', 441900, '东坑', 3, '0769', '523451', '113.939835', '22.992804', 'Dongkeng', '1', 0);
INSERT INTO `hh_region` VALUES (441914, '常平镇', 441900, '常平', 3, '0769', '523560', '114.029627', '23.016116', 'Changping', '1', 0);
INSERT INTO `hh_region` VALUES (441915, '寮步镇', 441900, '寮步', 3, '0769', '523411', '113.884745', '22.991738', 'Liaobu', '1', 0);
INSERT INTO `hh_region` VALUES (441916, '大朗镇', 441900, '大朗', 3, '0769', '523770', '113.9271', '22.965748', 'Dalang', '1', 0);
INSERT INTO `hh_region` VALUES (441917, '麻涌镇', 441900, '麻涌', 3, '0769', '523143', '113.546177', '23.045315', 'Machong', '1', 0);
INSERT INTO `hh_region` VALUES (441918, '中堂镇', 441900, '中堂', 3, '0769', '523233', '113.654422', '23.090164', 'Zhongtang', '1', 0);
INSERT INTO `hh_region` VALUES (441919, '高埗镇', 441900, '高埗', 3, '0769', '523282', '113.735917', '23.068415', 'Gaobu', '1', 0);
INSERT INTO `hh_region` VALUES (441920, '樟木头镇', 441900, '樟木头', 3, '0769', '523619', '114.066298', '22.956682', 'Zhangmutou', '1', 0);
INSERT INTO `hh_region` VALUES (441921, '大岭山镇', 441900, '大岭山', 3, '0769', '523835', '113.782955', '22.885366', 'Dalingshan', '1', 0);
INSERT INTO `hh_region` VALUES (441922, '望牛墩镇', 441900, '望牛墩', 3, '0769', '523203', '113.658847', '23.055018', 'Wangniudun', '1', 0);
INSERT INTO `hh_region` VALUES (441923, '黄江镇', 441900, '黄江', 3, '0769', '523755', '113.992635', '22.877536', 'Huangjiang', '1', 0);
INSERT INTO `hh_region` VALUES (441924, '洪梅镇', 441900, '洪梅', 3, '0769', '523163', '113.613081', '22.992675', 'Hongmei', '1', 0);
INSERT INTO `hh_region` VALUES (441925, '清溪镇', 441900, '清溪', 3, '0769', '523660', '114.155796', '22.844456', 'Qingxi', '1', 0);
INSERT INTO `hh_region` VALUES (441926, '沙田镇', 441900, '沙田', 3, '0769', '523988', '113.760234', '23.048884', 'Shatian', '1', 0);
INSERT INTO `hh_region` VALUES (441927, '道滘镇', 441900, '道滘', 3, '0769', '523171', '113.760234', '23.048884', 'Daojiao', '1', 0);
INSERT INTO `hh_region` VALUES (441928, '塘厦镇', 441900, '塘厦', 3, '0769', '523713', '114.10765', '22.822862', 'Tangxia', '1', 0);
INSERT INTO `hh_region` VALUES (441929, '虎门镇', 441900, '虎门', 3, '0769', '523932', '113.71118', '22.82615', 'Humen', '1', 0);
INSERT INTO `hh_region` VALUES (441930, '厚街镇', 441900, '厚街', 3, '0769', '523960', '113.67301', '22.940815', 'Houjie', '1', 0);
INSERT INTO `hh_region` VALUES (441931, '凤岗镇', 441900, '凤岗', 3, '0769', '523690', '114.141194', '22.744598', 'Fenggang', '1', 0);
INSERT INTO `hh_region` VALUES (441932, '长安镇', 441900, '长安', 3, '0769', '523850', '113.803939', '22.816644', 'Chang\'an', '1', 0);
INSERT INTO `hh_region` VALUES (442000, '中山市', 440000, '中山', 2, '0760', '528403', '113.382391', '22.521113', 'Zhongshan', '1', 0);
INSERT INTO `hh_region` VALUES (442001, '石岐区', 442000, '石岐', 3, '0760', '528400', '113.378835', '22.52522', 'Shiqi', '1', 0);
INSERT INTO `hh_region` VALUES (442004, '南区', 442000, '南区', 3, '0760', '528400', '113.355896', '22.486568', 'Nanqu', '1', 0);
INSERT INTO `hh_region` VALUES (442005, '五桂山区', 442000, '五桂山', 3, '0760', '528458', '113.41079', '22.51968', 'Wuguishan', '1', 0);
INSERT INTO `hh_region` VALUES (442006, '火炬开发区', 442000, '火炬', 3, '0760', '528437', '113.480523', '22.566082', 'Huoju', '1', 0);
INSERT INTO `hh_region` VALUES (442007, '黄圃镇', 442000, '黄圃', 3, '0760', '528429', '113.342359', '22.715116', 'Huangpu', '1', 0);
INSERT INTO `hh_region` VALUES (442008, '南头镇', 442000, '南头', 3, '0760', '528421', '113.296358', '22.713907', 'Nantou', '1', 0);
INSERT INTO `hh_region` VALUES (442009, '东凤镇', 442000, '东凤', 3, '0760', '528425', '113.26114', '22.68775', 'Dongfeng', '1', 0);
INSERT INTO `hh_region` VALUES (442010, '阜沙镇', 442000, '阜沙', 3, '0760', '528434', '113.353024', '22.666364', 'Fusha', '1', 0);
INSERT INTO `hh_region` VALUES (442011, '小榄镇', 442000, '小榄', 3, '0760', '528415', '113.244235', '22.666951', 'Xiaolan', '1', 0);
INSERT INTO `hh_region` VALUES (442012, '东升镇', 442000, '东升', 3, '0760', '528400', '113.296298', '22.614003', 'Dongsheng', '1', 0);
INSERT INTO `hh_region` VALUES (442013, '古镇镇', 442000, '古镇', 3, '0760', '528422', '113.179745', '22.611019', 'Guzhen', '1', 0);
INSERT INTO `hh_region` VALUES (442014, '横栏镇', 442000, '横栏', 3, '0760', '528478', '113.265845', '22.523202', 'Henglan', '1', 0);
INSERT INTO `hh_region` VALUES (442015, '三角镇', 442000, '三角', 3, '0760', '528422', '113.423624', '22.677033', 'Sanjiao', '1', 0);
INSERT INTO `hh_region` VALUES (442016, '民众镇', 442000, '民众', 3, '0760', '528441', '113.486025', '22.623468', 'Minzhong', '1', 0);
INSERT INTO `hh_region` VALUES (442017, '南朗镇', 442000, '南朗', 3, '0760', '528454', '113.533939', '22.492378', 'Nanlang', '1', 0);
INSERT INTO `hh_region` VALUES (442018, '港口镇', 442000, '港口', 3, '0760', '528447', '113.382391', '22.521113', 'Gangkou', '1', 0);
INSERT INTO `hh_region` VALUES (442019, '大涌镇', 442000, '大涌', 3, '0760', '528476', '113.291708', '22.467712', 'Dayong', '1', 0);
INSERT INTO `hh_region` VALUES (442020, '沙溪镇', 442000, '沙溪', 3, '0760', '528471', '113.328369', '22.526325', 'Shaxi', '1', 0);
INSERT INTO `hh_region` VALUES (442021, '三乡镇', 442000, '三乡', 3, '0760', '528463', '113.4334', '22.352494', 'Sanxiang', '1', 0);
INSERT INTO `hh_region` VALUES (442022, '板芙镇', 442000, '板芙', 3, '0760', '528459', '113.320346', '22.415674', 'Banfu', '1', 0);
INSERT INTO `hh_region` VALUES (442023, '神湾镇', 442000, '神湾', 3, '0760', '528462', '113.359387', '22.312476', 'Shenwan', '1', 0);
INSERT INTO `hh_region` VALUES (442024, '坦洲镇', 442000, '坦洲', 3, '0760', '528467', '113.485677', '22.261269', 'Tanzhou', '1', 0);
INSERT INTO `hh_region` VALUES (445100, '潮州市', 440000, '潮州', 2, '0768', '521000', '116.632301', '23.661701', 'Chaozhou', '1', 0);
INSERT INTO `hh_region` VALUES (445102, '湘桥区', 445100, '湘桥', 3, '0768', '521000', '116.62805', '23.67451', 'Xiangqiao', '1', 0);
INSERT INTO `hh_region` VALUES (445103, '潮安区', 445100, '潮安', 3, '0768', '515638', '116.592895', '23.643656', 'Chao\'an', '1', 0);
INSERT INTO `hh_region` VALUES (445122, '饶平县', 445100, '饶平', 3, '0768', '515700', '117.00692', '23.66994', 'Raoping', '1', 0);
INSERT INTO `hh_region` VALUES (445200, '揭阳市', 440000, '揭阳', 2, '0633', '522000', '116.355733', '23.543778', 'Jieyang', '1', 0);
INSERT INTO `hh_region` VALUES (445202, '榕城区', 445200, '榕城', 3, '0633', '522000', '116.3671', '23.52508', 'Rongcheng', '1', 0);
INSERT INTO `hh_region` VALUES (445203, '揭东区', 445200, '揭东', 3, '0633', '515500', '116.412947', '23.569887', 'Jiedong', '1', 0);
INSERT INTO `hh_region` VALUES (445222, '揭西县', 445200, '揭西', 3, '0633', '515400', '115.83883', '23.42714', 'Jiexi', '1', 0);
INSERT INTO `hh_region` VALUES (445224, '惠来县', 445200, '惠来', 3, '0633', '515200', '116.29599', '23.03289', 'Huilai', '1', 0);
INSERT INTO `hh_region` VALUES (445281, '普宁市', 445200, '普宁', 3, '0633', '515300', '116.16564', '23.29732', 'Puning', '1', 0);
INSERT INTO `hh_region` VALUES (445300, '云浮市', 440000, '云浮', 2, '0766', '527300', '112.044439', '22.929801', 'Yunfu', '1', 0);
INSERT INTO `hh_region` VALUES (445302, '云城区', 445300, '云城', 3, '0766', '527300', '112.03908', '22.92996', 'Yuncheng', '1', 0);
INSERT INTO `hh_region` VALUES (445303, '云安区', 445300, '云安', 3, '0766', '527500', '112.00936', '23.07779', 'Yun\'an', '1', 0);
INSERT INTO `hh_region` VALUES (445321, '新兴县', 445300, '新兴', 3, '0766', '527400', '112.23019', '22.69734', 'Xinxing', '1', 0);
INSERT INTO `hh_region` VALUES (445322, '郁南县', 445300, '郁南', 3, '0766', '527100', '111.53387', '23.23307', 'Yunan', '1', 0);
INSERT INTO `hh_region` VALUES (445381, '罗定市', 445300, '罗定', 3, '0766', '527200', '111.56979', '22.76967', 'Luoding', '1', 0);
INSERT INTO `hh_region` VALUES (450000, '广西壮族自治区', 100000, '广西', 1, '', '', '108.320004', '22.82402', 'Guangxi', '1', 0);
INSERT INTO `hh_region` VALUES (450100, '南宁市', 450000, '南宁', 2, '0771', '530028', '108.320004', '22.82402', 'Nanning', '1', 0);
INSERT INTO `hh_region` VALUES (450102, '兴宁区', 450100, '兴宁', 3, '0771', '530023', '108.36694', '22.85355', 'Xingning', '1', 0);
INSERT INTO `hh_region` VALUES (450103, '青秀区', 450100, '青秀', 3, '0771', '530213', '108.49545', '22.78511', 'Qingxiu', '1', 0);
INSERT INTO `hh_region` VALUES (450105, '江南区', 450100, '江南', 3, '0771', '530031', '108.27325', '22.78127', 'Jiangnan', '1', 0);
INSERT INTO `hh_region` VALUES (450107, '西乡塘区', 450100, '西乡塘', 3, '0771', '530001', '108.31347', '22.83386', 'Xixiangtang', '1', 0);
INSERT INTO `hh_region` VALUES (450108, '良庆区', 450100, '良庆', 3, '0771', '530219', '108.41284', '22.74914', 'Liangqing', '1', 0);
INSERT INTO `hh_region` VALUES (450109, '邕宁区', 450100, '邕宁', 3, '0771', '530200', '108.48684', '22.75628', 'Yongning', '1', 0);
INSERT INTO `hh_region` VALUES (450122, '武鸣县', 450100, '武鸣', 3, '0771', '530100', '108.27719', '23.15643', 'Wuming', '1', 0);
INSERT INTO `hh_region` VALUES (450123, '隆安县', 450100, '隆安', 3, '0771', '532700', '107.69192', '23.17336', 'Long\'an', '1', 0);
INSERT INTO `hh_region` VALUES (450124, '马山县', 450100, '马山', 3, '0771', '530600', '108.17697', '23.70931', 'Mashan', '1', 0);
INSERT INTO `hh_region` VALUES (450125, '上林县', 450100, '上林', 3, '0771', '530500', '108.60522', '23.432', 'Shanglin', '1', 0);
INSERT INTO `hh_region` VALUES (450126, '宾阳县', 450100, '宾阳', 3, '0771', '530400', '108.81185', '23.2196', 'Binyang', '1', 0);
INSERT INTO `hh_region` VALUES (450127, '横县', 450100, '横县', 3, '0771', '530300', '109.26608', '22.68448', 'Hengxian', '1', 0);
INSERT INTO `hh_region` VALUES (450128, '埌东新区', 450100, '埌东', 3, '0771', '530000', '108.419094', '22.812976', 'Langdong', '1', 0);
INSERT INTO `hh_region` VALUES (450200, '柳州市', 450000, '柳州', 2, '0772', '545001', '109.411703', '24.314617', 'Liuzhou', '1', 0);
INSERT INTO `hh_region` VALUES (450202, '城中区', 450200, '城中', 3, '0772', '545001', '109.41082', '24.31543', 'Chengzhong', '1', 0);
INSERT INTO `hh_region` VALUES (450203, '鱼峰区', 450200, '鱼峰', 3, '0772', '545005', '109.4533', '24.31868', 'Yufeng', '1', 0);
INSERT INTO `hh_region` VALUES (450204, '柳南区', 450200, '柳南', 3, '0772', '545007', '109.38548', '24.33599', 'Liunan', '1', 0);
INSERT INTO `hh_region` VALUES (450205, '柳北区', 450200, '柳北', 3, '0772', '545002', '109.40202', '24.36267', 'Liubei', '1', 0);
INSERT INTO `hh_region` VALUES (450221, '柳江县', 450200, '柳江', 3, '0772', '545100', '109.33273', '24.25596', 'Liujiang', '1', 0);
INSERT INTO `hh_region` VALUES (450222, '柳城县', 450200, '柳城', 3, '0772', '545200', '109.23877', '24.64951', 'Liucheng', '1', 0);
INSERT INTO `hh_region` VALUES (450223, '鹿寨县', 450200, '鹿寨', 3, '0772', '545600', '109.75177', '24.47306', 'Luzhai', '1', 0);
INSERT INTO `hh_region` VALUES (450224, '融安县', 450200, '融安', 3, '0772', '545400', '109.39761', '25.22465', 'Rong\'an', '1', 0);
INSERT INTO `hh_region` VALUES (450225, '融水苗族自治县', 450200, '融水', 3, '0772', '545300', '109.25634', '25.06628', 'Rongshui', '1', 0);
INSERT INTO `hh_region` VALUES (450226, '三江侗族自治县', 450200, '三江', 3, '0772', '545500', '109.60446', '25.78428', 'Sanjiang', '1', 0);
INSERT INTO `hh_region` VALUES (450227, '柳东新区', 450200, '柳东', 3, '0772', '545000', '109.437053', '24.329204', 'Liudong', '1', 0);
INSERT INTO `hh_region` VALUES (450300, '桂林市', 450000, '桂林', 2, '0773', '541100', '110.299121', '25.274215', 'Guilin', '1', 0);
INSERT INTO `hh_region` VALUES (450302, '秀峰区', 450300, '秀峰', 3, '0773', '541001', '110.28915', '25.28249', 'Xiufeng', '1', 0);
INSERT INTO `hh_region` VALUES (450303, '叠彩区', 450300, '叠彩', 3, '0773', '541001', '110.30195', '25.31381', 'Diecai', '1', 0);
INSERT INTO `hh_region` VALUES (450304, '象山区', 450300, '象山', 3, '0773', '541002', '110.28108', '25.26168', 'Xiangshan', '1', 0);
INSERT INTO `hh_region` VALUES (450305, '七星区', 450300, '七星', 3, '0773', '541004', '110.31793', '25.2525', 'Qixing', '1', 0);
INSERT INTO `hh_region` VALUES (450311, '雁山区', 450300, '雁山', 3, '0773', '541006', '110.30911', '25.06038', 'Yanshan', '1', 0);
INSERT INTO `hh_region` VALUES (450312, '临桂区', 450300, '临桂', 3, '0773', '541100', '110.205487', '25.246257', 'Lingui', '1', 0);
INSERT INTO `hh_region` VALUES (450321, '阳朔县', 450300, '阳朔', 3, '0773', '541900', '110.49475', '24.77579', 'Yangshuo', '1', 0);
INSERT INTO `hh_region` VALUES (450323, '灵川县', 450300, '灵川', 3, '0773', '541200', '110.32949', '25.41292', 'Lingchuan', '1', 0);
INSERT INTO `hh_region` VALUES (450324, '全州县', 450300, '全州', 3, '0773', '541503', '111.07211', '25.92799', 'Quanzhou', '1', 0);
INSERT INTO `hh_region` VALUES (450325, '兴安县', 450300, '兴安', 3, '0773', '541300', '110.67144', '25.61167', 'Xing\'an', '1', 0);
INSERT INTO `hh_region` VALUES (450326, '永福县', 450300, '永福', 3, '0773', '541800', '109.98333', '24.98004', 'Yongfu', '1', 0);
INSERT INTO `hh_region` VALUES (450327, '灌阳县', 450300, '灌阳', 3, '0773', '541600', '111.15954', '25.48803', 'Guanyang', '1', 0);
INSERT INTO `hh_region` VALUES (450328, '龙胜各族自治县', 450300, '龙胜', 3, '0773', '541700', '110.01226', '25.79614', 'Longsheng', '1', 0);
INSERT INTO `hh_region` VALUES (450329, '资源县', 450300, '资源', 3, '0773', '541400', '110.65255', '26.04237', 'Ziyuan', '1', 0);
INSERT INTO `hh_region` VALUES (450330, '平乐县', 450300, '平乐', 3, '0773', '542400', '110.64175', '24.63242', 'Pingle', '1', 0);
INSERT INTO `hh_region` VALUES (450331, '荔浦县', 450300, '荔浦', 3, '0773', '546600', '110.3971', '24.49589', 'Lipu', '1', 0);
INSERT INTO `hh_region` VALUES (450332, '恭城瑶族自治县', 450300, '恭城', 3, '0773', '542500', '110.83035', '24.83286', 'Gongcheng', '1', 0);
INSERT INTO `hh_region` VALUES (450400, '梧州市', 450000, '梧州', 2, '0774', '543002', '111.316229', '23.472309', 'Wuzhou', '1', 0);
INSERT INTO `hh_region` VALUES (450403, '万秀区', 450400, '万秀', 3, '0774', '543000', '111.32052', '23.47298', 'Wanxiu', '1', 0);
INSERT INTO `hh_region` VALUES (450405, '长洲区', 450400, '长洲', 3, '0774', '543003', '111.27494', '23.48573', 'Changzhou', '1', 0);
INSERT INTO `hh_region` VALUES (450406, '龙圩区', 450400, '龙圩', 3, '0774', '543002', '111.316229', '23.472309', 'Longxu', '1', 0);
INSERT INTO `hh_region` VALUES (450421, '苍梧县', 450400, '苍梧', 3, '0774', '543100', '111.24533', '23.42049', 'Cangwu', '1', 0);
INSERT INTO `hh_region` VALUES (450422, '藤县', 450400, '藤县', 3, '0774', '543300', '110.91418', '23.37605', 'Tengxian', '1', 0);
INSERT INTO `hh_region` VALUES (450423, '蒙山县', 450400, '蒙山', 3, '0774', '546700', '110.52221', '24.20168', 'Mengshan', '1', 0);
INSERT INTO `hh_region` VALUES (450481, '岑溪市', 450400, '岑溪', 3, '0774', '543200', '110.99594', '22.9191', 'Cenxi', '1', 0);
INSERT INTO `hh_region` VALUES (450500, '北海市', 450000, '北海', 2, '0779', '536000', '109.119254', '21.473343', 'Beihai', '1', 0);
INSERT INTO `hh_region` VALUES (450502, '海城区', 450500, '海城', 3, '0779', '536000', '109.11744', '21.47501', 'Haicheng', '1', 0);
INSERT INTO `hh_region` VALUES (450503, '银海区', 450500, '银海', 3, '0779', '536000', '109.13029', '21.4783', 'Yinhai', '1', 0);
INSERT INTO `hh_region` VALUES (450512, '铁山港区', 450500, '铁山港', 3, '0779', '536017', '109.45578', '21.59661', 'Tieshangang', '1', 0);
INSERT INTO `hh_region` VALUES (450521, '合浦县', 450500, '合浦', 3, '0779', '536100', '109.20068', '21.66601', 'Hepu', '1', 0);
INSERT INTO `hh_region` VALUES (450600, '防城港市', 450000, '防城港', 2, '0770', '538001', '108.345478', '21.614631', 'Fangchenggang', '1', 0);
INSERT INTO `hh_region` VALUES (450602, '港口区', 450600, '港口', 3, '0770', '538001', '108.38022', '21.64342', 'Gangkou', '1', 0);
INSERT INTO `hh_region` VALUES (450603, '防城区', 450600, '防城', 3, '0770', '538021', '108.35726', '21.76464', 'Fangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (450621, '上思县', 450600, '上思', 3, '0770', '535500', '107.9823', '22.14957', 'Shangsi', '1', 0);
INSERT INTO `hh_region` VALUES (450681, '东兴市', 450600, '东兴', 3, '0770', '538100', '107.97204', '21.54713', 'Dongxing', '1', 0);
INSERT INTO `hh_region` VALUES (450700, '钦州市', 450000, '钦州', 2, '0777', '535099', '108.624175', '21.967127', 'Qinzhou', '1', 0);
INSERT INTO `hh_region` VALUES (450702, '钦南区', 450700, '钦南', 3, '0777', '535099', '108.61775', '21.95137', 'Qinnan', '1', 0);
INSERT INTO `hh_region` VALUES (450703, '钦北区', 450700, '钦北', 3, '0777', '535099', '108.63037', '21.95127', 'Qinbei', '1', 0);
INSERT INTO `hh_region` VALUES (450721, '灵山县', 450700, '灵山', 3, '0777', '535099', '109.29153', '22.4165', 'Lingshan', '1', 0);
INSERT INTO `hh_region` VALUES (450722, '浦北县', 450700, '浦北', 3, '0777', '535099', '109.55572', '22.26888', 'Pubei', '1', 0);
INSERT INTO `hh_region` VALUES (450800, '贵港市', 450000, '贵港', 2, '0775', '537100', '109.602146', '23.0936', 'Guigang', '1', 0);
INSERT INTO `hh_region` VALUES (450802, '港北区', 450800, '港北', 3, '0775', '537100', '109.57224', '23.11153', 'Gangbei', '1', 0);
INSERT INTO `hh_region` VALUES (450803, '港南区', 450800, '港南', 3, '0775', '537100', '109.60617', '23.07226', 'Gangnan', '1', 0);
INSERT INTO `hh_region` VALUES (450804, '覃塘区', 450800, '覃塘', 3, '0775', '537121', '109.44293', '23.12677', 'Qintang', '1', 0);
INSERT INTO `hh_region` VALUES (450821, '平南县', 450800, '平南', 3, '0775', '537300', '110.39062', '23.54201', 'Pingnan', '1', 0);
INSERT INTO `hh_region` VALUES (450881, '桂平市', 450800, '桂平', 3, '0775', '537200', '110.08105', '23.39339', 'Guiping', '1', 0);
INSERT INTO `hh_region` VALUES (450900, '玉林市', 450000, '玉林', 2, '0775', '537000', '110.154393', '22.63136', 'Yulin', '1', 0);
INSERT INTO `hh_region` VALUES (450902, '玉州区', 450900, '玉州', 3, '0775', '537000', '110.15114', '22.6281', 'Yuzhou', '1', 0);
INSERT INTO `hh_region` VALUES (450903, '福绵区', 450900, '福绵', 3, '0775', '537023', '110.064816', '22.583057', 'Fumian', '1', 0);
INSERT INTO `hh_region` VALUES (450904, '玉东新区', 450900, '玉东', 3, '0775', '537000', '110.154393', '22.63136', 'Yudong', '1', 0);
INSERT INTO `hh_region` VALUES (450921, '容县', 450900, '容县', 3, '0775', '537500', '110.55593', '22.85701', 'Rongxian', '1', 0);
INSERT INTO `hh_region` VALUES (450922, '陆川县', 450900, '陆川', 3, '0775', '537700', '110.26413', '22.32454', 'Luchuan', '1', 0);
INSERT INTO `hh_region` VALUES (450923, '博白县', 450900, '博白', 3, '0775', '537600', '109.97744', '22.27286', 'Bobai', '1', 0);
INSERT INTO `hh_region` VALUES (450924, '兴业县', 450900, '兴业', 3, '0775', '537800', '109.87612', '22.74237', 'Xingye', '1', 0);
INSERT INTO `hh_region` VALUES (450981, '北流市', 450900, '北流', 3, '0775', '537400', '110.35302', '22.70817', 'Beiliu', '1', 0);
INSERT INTO `hh_region` VALUES (451000, '百色市', 450000, '百色', 2, '0776', '533000', '106.616285', '23.897742', 'Baise', '1', 0);
INSERT INTO `hh_region` VALUES (451002, '右江区', 451000, '右江', 3, '0776', '533000', '106.61764', '23.9009', 'Youjiang', '1', 0);
INSERT INTO `hh_region` VALUES (451021, '田阳县', 451000, '田阳', 3, '0776', '533600', '106.91558', '23.73535', 'Tianyang', '1', 0);
INSERT INTO `hh_region` VALUES (451022, '田东县', 451000, '田东', 3, '0776', '531500', '107.12432', '23.60003', 'Tiandong', '1', 0);
INSERT INTO `hh_region` VALUES (451023, '平果县', 451000, '平果', 3, '0776', '531400', '107.59045', '23.32969', 'Pingguo', '1', 0);
INSERT INTO `hh_region` VALUES (451024, '德保县', 451000, '德保', 3, '0776', '533700', '106.61917', '23.32515', 'Debao', '1', 0);
INSERT INTO `hh_region` VALUES (451025, '靖西县', 451000, '靖西', 3, '0776', '533800', '106.41766', '23.13425', 'Jingxi', '1', 0);
INSERT INTO `hh_region` VALUES (451026, '那坡县', 451000, '那坡', 3, '0776', '533900', '105.84191', '23.40649', 'Napo', '1', 0);
INSERT INTO `hh_region` VALUES (451027, '凌云县', 451000, '凌云', 3, '0776', '533100', '106.56155', '24.34747', 'Lingyun', '1', 0);
INSERT INTO `hh_region` VALUES (451028, '乐业县', 451000, '乐业', 3, '0776', '533200', '106.56124', '24.78295', 'Leye', '1', 0);
INSERT INTO `hh_region` VALUES (451029, '田林县', 451000, '田林', 3, '0776', '533300', '106.22882', '24.29207', 'Tianlin', '1', 0);
INSERT INTO `hh_region` VALUES (451030, '西林县', 451000, '西林', 3, '0776', '533500', '105.09722', '24.48966', 'Xilin', '1', 0);
INSERT INTO `hh_region` VALUES (451031, '隆林各族自治县', 451000, '隆林', 3, '0776', '533400', '105.34295', '24.77036', 'Longlin', '1', 0);
INSERT INTO `hh_region` VALUES (451100, '贺州市', 450000, '贺州', 2, '0774', '542800', '111.552056', '24.414141', 'Hezhou', '1', 0);
INSERT INTO `hh_region` VALUES (451102, '八步区', 451100, '八步', 3, '0774', '542800', '111.55225', '24.41179', 'Babu', '1', 0);
INSERT INTO `hh_region` VALUES (451121, '昭平县', 451100, '昭平', 3, '0774', '546800', '110.81082', '24.1701', 'Zhaoping', '1', 0);
INSERT INTO `hh_region` VALUES (451122, '钟山县', 451100, '钟山', 3, '0774', '542600', '111.30459', '24.52482', 'Zhongshan', '1', 0);
INSERT INTO `hh_region` VALUES (451123, '富川瑶族自治县', 451100, '富川', 3, '0774', '542700', '111.27767', '24.81431', 'Fuchuan', '1', 0);
INSERT INTO `hh_region` VALUES (451124, '平桂管理区', 451100, '平桂', 3, '0774', '542800', '111.485651', '24.458041', 'Pingui', '1', 0);
INSERT INTO `hh_region` VALUES (451200, '河池市', 450000, '河池', 2, '0778', '547000', '108.062105', '24.695899', 'Hechi', '1', 0);
INSERT INTO `hh_region` VALUES (451202, '金城江区', 451200, '金城江', 3, '0779', '547000', '108.03727', '24.6897', 'Jinchengjiang', '1', 0);
INSERT INTO `hh_region` VALUES (451221, '南丹县', 451200, '南丹', 3, '0781', '547200', '107.54562', '24.9776', 'Nandan', '1', 0);
INSERT INTO `hh_region` VALUES (451222, '天峨县', 451200, '天峨', 3, '0782', '547300', '107.17205', '24.99593', 'Tiane', '1', 0);
INSERT INTO `hh_region` VALUES (451223, '凤山县', 451200, '凤山', 3, '0783', '547600', '107.04892', '24.54215', 'Fengshan', '1', 0);
INSERT INTO `hh_region` VALUES (451224, '东兰县', 451200, '东兰', 3, '0784', '547400', '107.37527', '24.51053', 'Donglan', '1', 0);
INSERT INTO `hh_region` VALUES (451225, '罗城仫佬族自治县', 451200, '罗城', 3, '0785', '546400', '108.90777', '24.77923', 'Luocheng', '1', 0);
INSERT INTO `hh_region` VALUES (451226, '环江毛南族自治县', 451200, '环江', 3, '0786', '547100', '108.26055', '24.82916', 'Huanjiang', '1', 0);
INSERT INTO `hh_region` VALUES (451227, '巴马瑶族自治县', 451200, '巴马', 3, '0787', '547500', '107.25308', '24.14135', 'Bama', '1', 0);
INSERT INTO `hh_region` VALUES (451228, '都安瑶族自治县', 451200, '都安', 3, '0788', '530700', '108.10116', '23.93245', 'Du\'an', '1', 0);
INSERT INTO `hh_region` VALUES (451229, '大化瑶族自治县', 451200, '大化', 3, '0789', '530800', '107.9985', '23.74487', 'Dahua', '1', 0);
INSERT INTO `hh_region` VALUES (451281, '宜州市', 451200, '宜州', 3, '0780', '546300', '108.65304', '24.49391', 'Yizhou', '1', 0);
INSERT INTO `hh_region` VALUES (451300, '来宾市', 450000, '来宾', 2, '0772', '546100', '109.229772', '23.733766', 'Laibin', '1', 0);
INSERT INTO `hh_region` VALUES (451302, '兴宾区', 451300, '兴宾', 3, '0772', '546100', '109.23471', '23.72731', 'Xingbin', '1', 0);
INSERT INTO `hh_region` VALUES (451321, '忻城县', 451300, '忻城', 3, '0772', '546200', '108.66357', '24.06862', 'Xincheng', '1', 0);
INSERT INTO `hh_region` VALUES (451322, '象州县', 451300, '象州', 3, '0772', '545800', '109.6994', '23.97355', 'Xiangzhou', '1', 0);
INSERT INTO `hh_region` VALUES (451323, '武宣县', 451300, '武宣', 3, '0772', '545900', '109.66284', '23.59474', 'Wuxuan', '1', 0);
INSERT INTO `hh_region` VALUES (451324, '金秀瑶族自治县', 451300, '金秀', 3, '0772', '545799', '110.19079', '24.12929', 'Jinxiu', '1', 0);
INSERT INTO `hh_region` VALUES (451381, '合山市', 451300, '合山', 3, '0772', '546500', '108.88586', '23.80619', 'Heshan', '1', 0);
INSERT INTO `hh_region` VALUES (451400, '崇左市', 450000, '崇左', 2, '0771', '532299', '107.353926', '22.404108', 'Chongzuo', '1', 0);
INSERT INTO `hh_region` VALUES (451402, '江州区', 451400, '江州', 3, '0771', '532299', '107.34747', '22.41135', 'Jiangzhou', '1', 0);
INSERT INTO `hh_region` VALUES (451421, '扶绥县', 451400, '扶绥', 3, '0771', '532199', '107.90405', '22.63413', 'Fusui', '1', 0);
INSERT INTO `hh_region` VALUES (451422, '宁明县', 451400, '宁明', 3, '0771', '532599', '107.07299', '22.13655', 'Ningming', '1', 0);
INSERT INTO `hh_region` VALUES (451423, '龙州县', 451400, '龙州', 3, '0771', '532499', '106.85415', '22.33937', 'Longzhou', '1', 0);
INSERT INTO `hh_region` VALUES (451424, '大新县', 451400, '大新', 3, '0771', '532399', '107.19821', '22.83412', 'Daxin', '1', 0);
INSERT INTO `hh_region` VALUES (451425, '天等县', 451400, '天等', 3, '0771', '532899', '107.13998', '23.077', 'Tiandeng', '1', 0);
INSERT INTO `hh_region` VALUES (451481, '凭祥市', 451400, '凭祥', 3, '0771', '532699', '106.75534', '22.10573', 'Pingxiang', '1', 0);
INSERT INTO `hh_region` VALUES (460000, '海南省', 100000, '海南', 1, '', '', '110.33119', '20.031971', 'Hainan', '1', 0);
INSERT INTO `hh_region` VALUES (460100, '海口市', 460000, '海口', 2, '0898', '570000', '110.33119', '20.031971', 'Haikou', '1', 0);
INSERT INTO `hh_region` VALUES (460105, '秀英区', 460100, '秀英', 3, '0898', '570311', '110.29345', '20.00752', 'Xiuying', '1', 0);
INSERT INTO `hh_region` VALUES (460106, '龙华区', 460100, '龙华', 3, '0898', '570145', '110.30194', '20.02866', 'Longhua', '1', 0);
INSERT INTO `hh_region` VALUES (460107, '琼山区', 460100, '琼山', 3, '0898', '571100', '110.35418', '20.00321', 'Qiongshan', '1', 0);
INSERT INTO `hh_region` VALUES (460108, '美兰区', 460100, '美兰', 3, '0898', '570203', '110.36908', '20.02864', 'Meilan', '1', 0);
INSERT INTO `hh_region` VALUES (460200, '三亚市', 460000, '三亚', 2, '0898', '572000', '109.508268', '18.247872', 'Sanya', '1', 0);
INSERT INTO `hh_region` VALUES (460202, '海棠区', 460200, '海棠', 3, '0898', '572000', '109.508268', '18.247872', 'Haitang', '1', 0);
INSERT INTO `hh_region` VALUES (460203, '吉阳区', 460200, '吉阳', 3, '0898', '572000', '109.508268', '18.247872', 'Jiyang', '1', 0);
INSERT INTO `hh_region` VALUES (460204, '天涯区', 460200, '天涯', 3, '0898', '572000', '109.508268', '18.247872', 'Tianya', '1', 0);
INSERT INTO `hh_region` VALUES (460205, '崖州区', 460200, '崖州', 3, '0898', '572000', '109.508268', '18.247872', 'Yazhou', '1', 0);
INSERT INTO `hh_region` VALUES (460300, '三沙市', 460000, '三沙', 2, '0898', '573199', '112.34882', '16.831039', 'Sansha', '1', 0);
INSERT INTO `hh_region` VALUES (460321, '西沙群岛', 460300, '西沙', 3, '0898', '572000', '112.025528', '16.331342', 'Xisha Islands', '1', 0);
INSERT INTO `hh_region` VALUES (460322, '南沙群岛', 460300, '南沙', 3, '0898', '573100', '116.749998', '11.471888', 'Nansha Islands', '1', 0);
INSERT INTO `hh_region` VALUES (460323, '中沙群岛', 460300, '中沙', 3, '0898', '573100', '117.740071', '15.112856', 'Zhongsha Islands', '1', 0);
INSERT INTO `hh_region` VALUES (469000, '直辖县级', 460000, ' ', 2, '', '', '109.503479', '18.739906', '', '1', 0);
INSERT INTO `hh_region` VALUES (469001, '五指山市', 469000, '五指山', 3, '0898', '572200', '109.516662', '18.776921', 'Wuzhishan', '1', 0);
INSERT INTO `hh_region` VALUES (469002, '琼海市', 469000, '琼海', 3, '0898', '571400', '110.466785', '19.246011', 'Qionghai', '1', 0);
INSERT INTO `hh_region` VALUES (469003, '儋州市', 469000, '儋州', 3, '0898', '571700', '109.576782', '19.517486', 'Danzhou', '1', 0);
INSERT INTO `hh_region` VALUES (469005, '文昌市', 469000, '文昌', 3, '0898', '571339', '110.753975', '19.612986', 'Wenchang', '1', 0);
INSERT INTO `hh_region` VALUES (469006, '万宁市', 469000, '万宁', 3, '0898', '571500', '110.388793', '18.796216', 'Wanning', '1', 0);
INSERT INTO `hh_region` VALUES (469007, '东方市', 469000, '东方', 3, '0898', '572600', '108.653789', '19.10198', 'Dongfang', '1', 0);
INSERT INTO `hh_region` VALUES (469021, '定安县', 469000, '定安', 3, '0898', '571200', '110.323959', '19.699211', 'Ding\'an', '1', 0);
INSERT INTO `hh_region` VALUES (469022, '屯昌县', 469000, '屯昌', 3, '0898', '571600', '110.102773', '19.362916', 'Tunchang', '1', 0);
INSERT INTO `hh_region` VALUES (469023, '澄迈县', 469000, '澄迈', 3, '0898', '571900', '110.007147', '19.737095', 'Chengmai', '1', 0);
INSERT INTO `hh_region` VALUES (469024, '临高县', 469000, '临高', 3, '0898', '571800', '109.687697', '19.908293', 'Lingao', '1', 0);
INSERT INTO `hh_region` VALUES (469025, '白沙黎族自治县', 469000, '白沙', 3, '0898', '572800', '109.452606', '19.224584', 'Baisha', '1', 0);
INSERT INTO `hh_region` VALUES (469026, '昌江黎族自治县', 469000, '昌江', 3, '0898', '572700', '109.053351', '19.260968', 'Changjiang', '1', 0);
INSERT INTO `hh_region` VALUES (469027, '乐东黎族自治县', 469000, '乐东', 3, '0898', '572500', '109.175444', '18.74758', 'Ledong', '1', 0);
INSERT INTO `hh_region` VALUES (469028, '陵水黎族自治县', 469000, '陵水', 3, '0898', '572400', '110.037218', '18.505006', 'Lingshui', '1', 0);
INSERT INTO `hh_region` VALUES (469029, '保亭黎族苗族自治县', 469000, '保亭', 3, '0898', '572300', '109.70245', '18.636371', 'Baoting', '1', 0);
INSERT INTO `hh_region` VALUES (469030, '琼中黎族苗族自治县', 469000, '琼中', 3, '0898', '572900', '109.839996', '19.03557', 'Qiongzhong', '1', 0);
INSERT INTO `hh_region` VALUES (500000, '重庆', 100000, '重庆', 1, '', '', '106.504962', '29.533155', 'Chongqing', '1', 0);
INSERT INTO `hh_region` VALUES (500100, '重庆市', 500000, '重庆', 2, '023', '400000', '106.504962', '29.533155', 'Chongqing', '1', 0);
INSERT INTO `hh_region` VALUES (500101, '万州区', 500100, '万州', 3, '023', '404000', '108.40869', '30.80788', 'Wanzhou', '1', 0);
INSERT INTO `hh_region` VALUES (500102, '涪陵区', 500100, '涪陵', 3, '023', '408000', '107.39007', '29.70292', 'Fuling', '1', 0);
INSERT INTO `hh_region` VALUES (500103, '渝中区', 500100, '渝中', 3, '023', '400010', '106.56901', '29.55279', 'Yuzhong', '1', 0);
INSERT INTO `hh_region` VALUES (500104, '大渡口区', 500100, '大渡口', 3, '023', '400080', '106.48262', '29.48447', 'Dadukou', '1', 0);
INSERT INTO `hh_region` VALUES (500105, '江北区', 500100, '江北', 3, '023', '400020', '106.57434', '29.60658', 'Jiangbei', '1', 0);
INSERT INTO `hh_region` VALUES (500106, '沙坪坝区', 500100, '沙坪坝', 3, '023', '400030', '106.45752', '29.54113', 'Shapingba', '1', 0);
INSERT INTO `hh_region` VALUES (500107, '九龙坡区', 500100, '九龙坡', 3, '023', '400050', '106.51107', '29.50197', 'Jiulongpo', '1', 0);
INSERT INTO `hh_region` VALUES (500108, '南岸区', 500100, '南岸', 3, '023', '400064', '106.56347', '29.52311', 'Nan\'an', '1', 0);
INSERT INTO `hh_region` VALUES (500109, '北碚区', 500100, '北碚', 3, '023', '400700', '106.39614', '29.80574', 'Beibei', '1', 0);
INSERT INTO `hh_region` VALUES (500110, '綦江区', 500100, '綦江', 3, '023', '400800', '106.926779', '28.960656', 'Qijiang', '1', 0);
INSERT INTO `hh_region` VALUES (500111, '大足区', 500100, '大足', 3, '023', '400900', '105.768121', '29.484025', 'Dazu', '1', 0);
INSERT INTO `hh_region` VALUES (500112, '渝北区', 500100, '渝北', 3, '023', '401120', '106.6307', '29.7182', 'Yubei', '1', 0);
INSERT INTO `hh_region` VALUES (500113, '巴南区', 500100, '巴南', 3, '023', '401320', '106.52365', '29.38311', 'Banan', '1', 0);
INSERT INTO `hh_region` VALUES (500114, '黔江区', 500100, '黔江', 3, '023', '409700', '108.7709', '29.5332', 'Qianjiang', '1', 0);
INSERT INTO `hh_region` VALUES (500115, '长寿区', 500100, '长寿', 3, '023', '401220', '107.08166', '29.85359', 'Changshou', '1', 0);
INSERT INTO `hh_region` VALUES (500116, '江津区', 500100, '江津', 3, '023', '402260', '106.25912', '29.29008', 'Jiangjin', '1', 0);
INSERT INTO `hh_region` VALUES (500117, '合川区', 500100, '合川', 3, '023', '401520', '106.27633', '29.97227', 'Hechuan', '1', 0);
INSERT INTO `hh_region` VALUES (500118, '永川区', 500100, '永川', 3, '023', '402160', '105.927', '29.35593', 'Yongchuan', '1', 0);
INSERT INTO `hh_region` VALUES (500119, '南川区', 500100, '南川', 3, '023', '408400', '107.09936', '29.15751', 'Nanchuan', '1', 0);
INSERT INTO `hh_region` VALUES (500120, '璧山区', 500100, '璧山', 3, '023', '402760', '106.231126', '29.593581', 'Bishan', '1', 0);
INSERT INTO `hh_region` VALUES (500151, '铜梁区', 500100, '铜梁', 3, '023', '402560', '106.054948', '29.839944', 'Tongliang', '1', 0);
INSERT INTO `hh_region` VALUES (500223, '潼南县', 500100, '潼南', 3, '023', '402660', '105.84005', '30.1912', 'Tongnan', '1', 0);
INSERT INTO `hh_region` VALUES (500226, '荣昌县', 500100, '荣昌', 3, '023', '402460', '105.59442', '29.40488', 'Rongchang', '1', 0);
INSERT INTO `hh_region` VALUES (500228, '梁平县', 500100, '梁平', 3, '023', '405200', '107.79998', '30.67545', 'Liangping', '1', 0);
INSERT INTO `hh_region` VALUES (500229, '城口县', 500100, '城口', 3, '023', '405900', '108.66513', '31.94801', 'Chengkou', '1', 0);
INSERT INTO `hh_region` VALUES (500230, '丰都县', 500100, '丰都', 3, '023', '408200', '107.73098', '29.86348', 'Fengdu', '1', 0);
INSERT INTO `hh_region` VALUES (500231, '垫江县', 500100, '垫江', 3, '023', '408300', '107.35446', '30.33359', 'Dianjiang', '1', 0);
INSERT INTO `hh_region` VALUES (500232, '武隆县', 500100, '武隆', 3, '023', '408500', '107.7601', '29.32548', 'Wulong', '1', 0);
INSERT INTO `hh_region` VALUES (500233, '忠县', 500100, '忠县', 3, '023', '404300', '108.03689', '30.28898', 'Zhongxian', '1', 0);
INSERT INTO `hh_region` VALUES (500234, '开县', 500100, '开县', 3, '023', '405400', '108.39306', '31.16095', 'Kaixian', '1', 0);
INSERT INTO `hh_region` VALUES (500235, '云阳县', 500100, '云阳', 3, '023', '404500', '108.69726', '30.93062', 'Yunyang', '1', 0);
INSERT INTO `hh_region` VALUES (500236, '奉节县', 500100, '奉节', 3, '023', '404600', '109.46478', '31.01825', 'Fengjie', '1', 0);
INSERT INTO `hh_region` VALUES (500237, '巫山县', 500100, '巫山', 3, '023', '404700', '109.87814', '31.07458', 'Wushan', '1', 0);
INSERT INTO `hh_region` VALUES (500238, '巫溪县', 500100, '巫溪', 3, '023', '405800', '109.63128', '31.39756', 'Wuxi', '1', 0);
INSERT INTO `hh_region` VALUES (500240, '石柱土家族自治县', 500100, '石柱', 3, '023', '409100', '108.11389', '30.00054', 'Shizhu', '1', 0);
INSERT INTO `hh_region` VALUES (500241, '秀山土家族苗族自治县', 500100, '秀山', 3, '023', '409900', '108.98861', '28.45062', 'Xiushan', '1', 0);
INSERT INTO `hh_region` VALUES (500242, '酉阳土家族苗族自治县', 500100, '酉阳', 3, '023', '409800', '108.77212', '28.8446', 'Youyang', '1', 0);
INSERT INTO `hh_region` VALUES (500243, '彭水苗族土家族自治县', 500100, '彭水', 3, '023', '409600', '108.16638', '29.29516', 'Pengshui', '1', 0);
INSERT INTO `hh_region` VALUES (500300, '两江新区', 500000, '两江新区', 2, '023', '400000', '106.463344', '29.729153', 'Liangjiangxinqu', '1', 0);
INSERT INTO `hh_region` VALUES (500301, '北部新区', 500300, '北部新区', 3, '023', '400000', '106.488841', '29.667062', 'Beibuxinqu', '1', 0);
INSERT INTO `hh_region` VALUES (500302, '保税港区', 500300, '保税港区', 3, '023', '400000', '106.638184', '29.716311', 'Baoshuigangqu', '1', 0);
INSERT INTO `hh_region` VALUES (500303, '工业园区', 500300, '工业园区', 3, '023', '400000', '106.626434', '29.55554', 'Gongyeyuanqu', '1', 0);
INSERT INTO `hh_region` VALUES (510000, '四川省', 100000, '四川', 1, '', '', '104.065735', '30.659462', 'Sichuan', '1', 0);
INSERT INTO `hh_region` VALUES (510100, '成都市', 510000, '成都', 2, '028', '610015', '104.065735', '30.659462', 'Chengdu', '1', 0);
INSERT INTO `hh_region` VALUES (510104, '锦江区', 510100, '锦江', 3, '028', '610021', '104.08347', '30.65614', 'Jinjiang', '1', 0);
INSERT INTO `hh_region` VALUES (510105, '青羊区', 510100, '青羊', 3, '028', '610031', '104.06151', '30.67387', 'Qingyang', '1', 0);
INSERT INTO `hh_region` VALUES (510106, '金牛区', 510100, '金牛', 3, '028', '610036', '104.05114', '30.69126', 'Jinniu', '1', 0);
INSERT INTO `hh_region` VALUES (510107, '武侯区', 510100, '武侯', 3, '028', '610041', '104.04303', '30.64235', 'Wuhou', '1', 0);
INSERT INTO `hh_region` VALUES (510108, '成华区', 510100, '成华', 3, '028', '610066', '104.10193', '30.65993', 'Chenghua', '1', 0);
INSERT INTO `hh_region` VALUES (510112, '龙泉驿区', 510100, '龙泉驿', 3, '028', '610100', '104.27462', '30.55658', 'Longquanyi', '1', 0);
INSERT INTO `hh_region` VALUES (510113, '青白江区', 510100, '青白江', 3, '028', '610300', '104.251', '30.87841', 'Qingbaijiang', '1', 0);
INSERT INTO `hh_region` VALUES (510114, '新都区', 510100, '新都', 3, '028', '610500', '104.15921', '30.82314', 'Xindu', '1', 0);
INSERT INTO `hh_region` VALUES (510115, '温江区', 510100, '温江', 3, '028', '611130', '103.84881', '30.68444', 'Wenjiang', '1', 0);
INSERT INTO `hh_region` VALUES (510121, '金堂县', 510100, '金堂', 3, '028', '610400', '104.41195', '30.86195', 'Jintang', '1', 0);
INSERT INTO `hh_region` VALUES (510122, '双流县', 510100, '双流', 3, '028', '610200', '103.92373', '30.57444', 'Shuangliu', '1', 0);
INSERT INTO `hh_region` VALUES (510124, '郫县', 510100, '郫县', 3, '028', '611730', '103.88717', '30.81054', 'Pixian', '1', 0);
INSERT INTO `hh_region` VALUES (510129, '大邑县', 510100, '大邑', 3, '028', '611330', '103.52075', '30.58738', 'Dayi', '1', 0);
INSERT INTO `hh_region` VALUES (510131, '蒲江县', 510100, '蒲江', 3, '028', '611630', '103.50616', '30.19667', 'Pujiang', '1', 0);
INSERT INTO `hh_region` VALUES (510132, '新津县', 510100, '新津', 3, '028', '611430', '103.8114', '30.40983', 'Xinjin', '1', 0);
INSERT INTO `hh_region` VALUES (510181, '都江堰市', 510100, '都江堰', 3, '028', '611830', '103.61941', '30.99825', 'Dujiangyan', '1', 0);
INSERT INTO `hh_region` VALUES (510182, '彭州市', 510100, '彭州', 3, '028', '611930', '103.958', '30.99011', 'Pengzhou', '1', 0);
INSERT INTO `hh_region` VALUES (510183, '邛崃市', 510100, '邛崃', 3, '028', '611530', '103.46283', '30.41489', 'Qionglai', '1', 0);
INSERT INTO `hh_region` VALUES (510184, '崇州市', 510100, '崇州', 3, '028', '611230', '103.67285', '30.63014', 'Chongzhou', '1', 0);
INSERT INTO `hh_region` VALUES (510300, '自贡市', 510000, '自贡', 2, '0813', '643000', '104.773447', '29.352765', 'Zigong', '1', 0);
INSERT INTO `hh_region` VALUES (510302, '自流井区', 510300, '自流井', 3, '0813', '643000', '104.77719', '29.33745', 'Ziliujing', '1', 0);
INSERT INTO `hh_region` VALUES (510303, '贡井区', 510300, '贡井', 3, '0813', '643020', '104.71536', '29.34576', 'Gongjing', '1', 0);
INSERT INTO `hh_region` VALUES (510304, '大安区', 510300, '大安', 3, '0813', '643010', '104.77383', '29.36364', 'Da\'an', '1', 0);
INSERT INTO `hh_region` VALUES (510311, '沿滩区', 510300, '沿滩', 3, '0813', '643030', '104.88012', '29.26611', 'Yantan', '1', 0);
INSERT INTO `hh_region` VALUES (510321, '荣县', 510300, '荣县', 3, '0813', '643100', '104.4176', '29.44445', 'Rongxian', '1', 0);
INSERT INTO `hh_region` VALUES (510322, '富顺县', 510300, '富顺', 3, '0813', '643200', '104.97491', '29.18123', 'Fushun', '1', 0);
INSERT INTO `hh_region` VALUES (510400, '攀枝花市', 510000, '攀枝花', 2, '0812', '617000', '101.716007', '26.580446', 'Panzhihua', '1', 0);
INSERT INTO `hh_region` VALUES (510402, '东区', 510400, '东区', 3, '0812', '617067', '101.7052', '26.54677', 'Dongqu', '1', 0);
INSERT INTO `hh_region` VALUES (510403, '西区', 510400, '西区', 3, '0812', '617068', '101.63058', '26.59753', 'Xiqu', '1', 0);
INSERT INTO `hh_region` VALUES (510411, '仁和区', 510400, '仁和', 3, '0812', '617061', '101.73812', '26.49841', 'Renhe', '1', 0);
INSERT INTO `hh_region` VALUES (510421, '米易县', 510400, '米易', 3, '0812', '617200', '102.11132', '26.88718', 'Miyi', '1', 0);
INSERT INTO `hh_region` VALUES (510422, '盐边县', 510400, '盐边', 3, '0812', '617100', '101.85446', '26.68847', 'Yanbian', '1', 0);
INSERT INTO `hh_region` VALUES (510500, '泸州市', 510000, '泸州', 2, '0830', '646000', '105.443348', '28.889138', 'Luzhou', '1', 0);
INSERT INTO `hh_region` VALUES (510502, '江阳区', 510500, '江阳', 3, '0830', '646000', '105.45336', '28.88934', 'Jiangyang', '1', 0);
INSERT INTO `hh_region` VALUES (510503, '纳溪区', 510500, '纳溪', 3, '0830', '646300', '105.37255', '28.77343', 'Naxi', '1', 0);
INSERT INTO `hh_region` VALUES (510504, '龙马潭区', 510500, '龙马潭', 3, '0830', '646000', '105.43774', '28.91308', 'Longmatan', '1', 0);
INSERT INTO `hh_region` VALUES (510521, '泸县', 510500, '泸县', 3, '0830', '646106', '105.38192', '29.15041', 'Luxian', '1', 0);
INSERT INTO `hh_region` VALUES (510522, '合江县', 510500, '合江', 3, '0830', '646200', '105.8352', '28.81005', 'Hejiang', '1', 0);
INSERT INTO `hh_region` VALUES (510524, '叙永县', 510500, '叙永', 3, '0830', '646400', '105.44473', '28.15586', 'Xuyong', '1', 0);
INSERT INTO `hh_region` VALUES (510525, '古蔺县', 510500, '古蔺', 3, '0830', '646500', '105.81347', '28.03867', 'Gulin', '1', 0);
INSERT INTO `hh_region` VALUES (510600, '德阳市', 510000, '德阳', 2, '0838', '618000', '104.398651', '31.127991', 'Deyang', '1', 0);
INSERT INTO `hh_region` VALUES (510603, '旌阳区', 510600, '旌阳', 3, '0838', '618000', '104.39367', '31.13906', 'Jingyang', '1', 0);
INSERT INTO `hh_region` VALUES (510623, '中江县', 510600, '中江', 3, '0838', '618100', '104.67861', '31.03297', 'Zhongjiang', '1', 0);
INSERT INTO `hh_region` VALUES (510626, '罗江县', 510600, '罗江', 3, '0838', '618500', '104.51025', '31.31665', 'Luojiang', '1', 0);
INSERT INTO `hh_region` VALUES (510681, '广汉市', 510600, '广汉', 3, '0838', '618300', '104.28234', '30.97686', 'Guanghan', '1', 0);
INSERT INTO `hh_region` VALUES (510682, '什邡市', 510600, '什邡', 3, '0838', '618400', '104.16754', '31.1264', 'Shifang', '1', 0);
INSERT INTO `hh_region` VALUES (510683, '绵竹市', 510600, '绵竹', 3, '0838', '618200', '104.22076', '31.33772', 'Mianzhu', '1', 0);
INSERT INTO `hh_region` VALUES (510700, '绵阳市', 510000, '绵阳', 2, '0816', '621000', '104.741722', '31.46402', 'Mianyang', '1', 0);
INSERT INTO `hh_region` VALUES (510703, '涪城区', 510700, '涪城', 3, '0816', '621000', '104.75719', '31.45522', 'Fucheng', '1', 0);
INSERT INTO `hh_region` VALUES (510704, '游仙区', 510700, '游仙', 3, '0816', '621022', '104.77092', '31.46574', 'Youxian', '1', 0);
INSERT INTO `hh_region` VALUES (510722, '三台县', 510700, '三台', 3, '0816', '621100', '105.09079', '31.09179', 'Santai', '1', 0);
INSERT INTO `hh_region` VALUES (510723, '盐亭县', 510700, '盐亭', 3, '0816', '621600', '105.3898', '31.22176', 'Yanting', '1', 0);
INSERT INTO `hh_region` VALUES (510724, '安县', 510700, '安县', 3, '0816', '622650', '104.56738', '31.53487', 'Anxian', '1', 0);
INSERT INTO `hh_region` VALUES (510725, '梓潼县', 510700, '梓潼', 3, '0816', '622150', '105.16183', '31.6359', 'Zitong', '1', 0);
INSERT INTO `hh_region` VALUES (510726, '北川羌族自治县', 510700, '北川', 3, '0816', '622750', '104.46408', '31.83286', 'Beichuan', '1', 0);
INSERT INTO `hh_region` VALUES (510727, '平武县', 510700, '平武', 3, '0816', '622550', '104.52862', '32.40791', 'Pingwu', '1', 0);
INSERT INTO `hh_region` VALUES (510781, '江油市', 510700, '江油', 3, '0816', '621700', '104.74539', '31.77775', 'Jiangyou', '1', 0);
INSERT INTO `hh_region` VALUES (510800, '广元市', 510000, '广元', 2, '0839', '628000', '105.829757', '32.433668', 'Guangyuan', '1', 0);
INSERT INTO `hh_region` VALUES (510802, '利州区', 510800, '利州', 3, '0839', '628017', '105.826194', '32.432276', 'Lizhou', '1', 0);
INSERT INTO `hh_region` VALUES (510811, '昭化区', 510800, '昭化', 3, '0839', '628017', '105.640491', '32.386518', 'Zhaohua', '1', 0);
INSERT INTO `hh_region` VALUES (510812, '朝天区', 510800, '朝天', 3, '0839', '628017', '105.89273', '32.64398', 'Chaotian', '1', 0);
INSERT INTO `hh_region` VALUES (510821, '旺苍县', 510800, '旺苍', 3, '0839', '628200', '106.29022', '32.22845', 'Wangcang', '1', 0);
INSERT INTO `hh_region` VALUES (510822, '青川县', 510800, '青川', 3, '0839', '628100', '105.2391', '32.58563', 'Qingchuan', '1', 0);
INSERT INTO `hh_region` VALUES (510823, '剑阁县', 510800, '剑阁', 3, '0839', '628300', '105.5252', '32.28845', 'Jiange', '1', 0);
INSERT INTO `hh_region` VALUES (510824, '苍溪县', 510800, '苍溪', 3, '0839', '628400', '105.936', '31.73209', 'Cangxi', '1', 0);
INSERT INTO `hh_region` VALUES (510900, '遂宁市', 510000, '遂宁', 2, '0825', '629000', '105.571331', '30.513311', 'Suining', '1', 0);
INSERT INTO `hh_region` VALUES (510903, '船山区', 510900, '船山', 3, '0825', '629000', '105.5809', '30.49991', 'Chuanshan', '1', 0);
INSERT INTO `hh_region` VALUES (510904, '安居区', 510900, '安居', 3, '0825', '629000', '105.46402', '30.35778', 'Anju', '1', 0);
INSERT INTO `hh_region` VALUES (510921, '蓬溪县', 510900, '蓬溪', 3, '0825', '629100', '105.70752', '30.75775', 'Pengxi', '1', 0);
INSERT INTO `hh_region` VALUES (510922, '射洪县', 510900, '射洪', 3, '0825', '629200', '105.38922', '30.87203', 'Shehong', '1', 0);
INSERT INTO `hh_region` VALUES (510923, '大英县', 510900, '大英', 3, '0825', '629300', '105.24346', '30.59434', 'Daying', '1', 0);
INSERT INTO `hh_region` VALUES (511000, '内江市', 510000, '内江', 2, '0832', '641000', '105.066138', '29.58708', 'Neijiang', '1', 0);
INSERT INTO `hh_region` VALUES (511002, '市中区', 511000, '市中区', 3, '0832', '641000', '105.0679', '29.58709', 'Shizhongqu', '1', 0);
INSERT INTO `hh_region` VALUES (511011, '东兴区', 511000, '东兴', 3, '0832', '641100', '105.07554', '29.59278', 'Dongxing', '1', 0);
INSERT INTO `hh_region` VALUES (511024, '威远县', 511000, '威远', 3, '0832', '642450', '104.66955', '29.52823', 'Weiyuan', '1', 0);
INSERT INTO `hh_region` VALUES (511025, '资中县', 511000, '资中', 3, '0832', '641200', '104.85205', '29.76409', 'Zizhong', '1', 0);
INSERT INTO `hh_region` VALUES (511028, '隆昌县', 511000, '隆昌', 3, '0832', '642150', '105.28738', '29.33937', 'Longchang', '1', 0);
INSERT INTO `hh_region` VALUES (511100, '乐山市', 510000, '乐山', 2, '0833', '614000', '103.761263', '29.582024', 'Leshan', '1', 0);
INSERT INTO `hh_region` VALUES (511102, '市中区', 511100, '市中区', 3, '0833', '614000', '103.76159', '29.55543', 'Shizhongqu', '1', 0);
INSERT INTO `hh_region` VALUES (511111, '沙湾区', 511100, '沙湾', 3, '0833', '614900', '103.54873', '29.41194', 'Shawan', '1', 0);
INSERT INTO `hh_region` VALUES (511112, '五通桥区', 511100, '五通桥', 3, '0833', '614800', '103.82345', '29.40344', 'Wutongqiao', '1', 0);
INSERT INTO `hh_region` VALUES (511113, '金口河区', 511100, '金口河', 3, '0833', '614700', '103.07858', '29.24578', 'Jinkouhe', '1', 0);
INSERT INTO `hh_region` VALUES (511123, '犍为县', 511100, '犍为', 3, '0833', '614400', '103.94989', '29.20973', 'Qianwei', '1', 0);
INSERT INTO `hh_region` VALUES (511124, '井研县', 511100, '井研', 3, '0833', '613100', '104.07019', '29.65228', 'Jingyan', '1', 0);
INSERT INTO `hh_region` VALUES (511126, '夹江县', 511100, '夹江', 3, '0833', '614100', '103.57199', '29.73868', 'Jiajiang', '1', 0);
INSERT INTO `hh_region` VALUES (511129, '沐川县', 511100, '沐川', 3, '0833', '614500', '103.90353', '28.95646', 'Muchuan', '1', 0);
INSERT INTO `hh_region` VALUES (511132, '峨边彝族自治县', 511100, '峨边', 3, '0833', '614300', '103.26339', '29.23004', 'Ebian', '1', 0);
INSERT INTO `hh_region` VALUES (511133, '马边彝族自治县', 511100, '马边', 3, '0833', '614600', '103.54617', '28.83593', 'Mabian', '1', 0);
INSERT INTO `hh_region` VALUES (511181, '峨眉山市', 511100, '峨眉山', 3, '0833', '614200', '103.4844', '29.60117', 'Emeishan', '1', 0);
INSERT INTO `hh_region` VALUES (511300, '南充市', 510000, '南充', 2, '0817', '637000', '106.082974', '30.795281', 'Nanchong', '1', 0);
INSERT INTO `hh_region` VALUES (511302, '顺庆区', 511300, '顺庆', 3, '0817', '637000', '106.09216', '30.79642', 'Shunqing', '1', 0);
INSERT INTO `hh_region` VALUES (511303, '高坪区', 511300, '高坪', 3, '0817', '637100', '106.11894', '30.78162', 'Gaoping', '1', 0);
INSERT INTO `hh_region` VALUES (511304, '嘉陵区', 511300, '嘉陵', 3, '0817', '637100', '106.07141', '30.75848', 'Jialing', '1', 0);
INSERT INTO `hh_region` VALUES (511321, '南部县', 511300, '南部', 3, '0817', '637300', '106.06738', '31.35451', 'Nanbu', '1', 0);
INSERT INTO `hh_region` VALUES (511322, '营山县', 511300, '营山', 3, '0817', '637700', '106.56637', '31.07747', 'Yingshan', '1', 0);
INSERT INTO `hh_region` VALUES (511323, '蓬安县', 511300, '蓬安', 3, '0817', '637800', '106.41262', '31.02964', 'Peng\'an', '1', 0);
INSERT INTO `hh_region` VALUES (511324, '仪陇县', 511300, '仪陇', 3, '0817', '637600', '106.29974', '31.27628', 'Yilong', '1', 0);
INSERT INTO `hh_region` VALUES (511325, '西充县', 511300, '西充', 3, '0817', '637200', '105.89996', '30.9969', 'Xichong', '1', 0);
INSERT INTO `hh_region` VALUES (511381, '阆中市', 511300, '阆中', 3, '0817', '637400', '106.00494', '31.55832', 'Langzhong', '1', 0);
INSERT INTO `hh_region` VALUES (511400, '眉山市', 510000, '眉山', 2, '028', '620020', '103.831788', '30.048318', 'Meishan', '1', 0);
INSERT INTO `hh_region` VALUES (511402, '东坡区', 511400, '东坡', 3, '028', '620010', '103.832', '30.04219', 'Dongpo', '1', 0);
INSERT INTO `hh_region` VALUES (511403, '彭山区', 511400, '彭山', 3, '028', '620860', '103.87268', '30.19283', 'Pengshan', '1', 0);
INSERT INTO `hh_region` VALUES (511421, '仁寿县', 511400, '仁寿', 3, '028', '620500', '104.13412', '29.99599', 'Renshou', '1', 0);
INSERT INTO `hh_region` VALUES (511423, '洪雅县', 511400, '洪雅', 3, '028', '620360', '103.37313', '29.90661', 'Hongya', '1', 0);
INSERT INTO `hh_region` VALUES (511424, '丹棱县', 511400, '丹棱', 3, '028', '620200', '103.51339', '30.01562', 'Danling', '1', 0);
INSERT INTO `hh_region` VALUES (511425, '青神县', 511400, '青神', 3, '028', '620460', '103.84771', '29.83235', 'Qingshen', '1', 0);
INSERT INTO `hh_region` VALUES (511500, '宜宾市', 510000, '宜宾', 2, '0831', '644000', '104.630825', '28.760189', 'Yibin', '1', 0);
INSERT INTO `hh_region` VALUES (511502, '翠屏区', 511500, '翠屏', 3, '0831', '644000', '104.61978', '28.76566', 'Cuiping', '1', 0);
INSERT INTO `hh_region` VALUES (511503, '南溪区', 511500, '南溪', 3, '0831', '644100', '104.981133', '28.839806', 'Nanxi', '1', 0);
INSERT INTO `hh_region` VALUES (511521, '宜宾县', 511500, '宜宾', 3, '0831', '644600', '104.53314', '28.68996', 'Yibin', '1', 0);
INSERT INTO `hh_region` VALUES (511523, '江安县', 511500, '江安', 3, '0831', '644200', '105.06683', '28.72385', 'Jiang\'an', '1', 0);
INSERT INTO `hh_region` VALUES (511524, '长宁县', 511500, '长宁', 3, '0831', '644300', '104.9252', '28.57777', 'Changning', '1', 0);
INSERT INTO `hh_region` VALUES (511525, '高县', 511500, '高县', 3, '0831', '645150', '104.51754', '28.43619', 'Gaoxian', '1', 0);
INSERT INTO `hh_region` VALUES (511526, '珙县', 511500, '珙县', 3, '0831', '644500', '104.71398', '28.44512', 'Gongxian', '1', 0);
INSERT INTO `hh_region` VALUES (511527, '筠连县', 511500, '筠连', 3, '0831', '645250', '104.51217', '28.16495', 'Junlian', '1', 0);
INSERT INTO `hh_region` VALUES (511528, '兴文县', 511500, '兴文', 3, '0831', '644400', '105.23675', '28.3044', 'Xingwen', '1', 0);
INSERT INTO `hh_region` VALUES (511529, '屏山县', 511500, '屏山', 3, '0831', '645350', '104.16293', '28.64369', 'Pingshan', '1', 0);
INSERT INTO `hh_region` VALUES (511600, '广安市', 510000, '广安', 2, '0826', '638000', '106.633369', '30.456398', 'Guang\'an', '1', 0);
INSERT INTO `hh_region` VALUES (511602, '广安区', 511600, '广安', 3, '0826', '638000', '106.64163', '30.47389', 'Guang\'an', '1', 0);
INSERT INTO `hh_region` VALUES (511603, '前锋区', 511600, '前锋', 3, '0826', '638019', '106.893537', '30.494572', 'Qianfeng', '1', 0);
INSERT INTO `hh_region` VALUES (511621, '岳池县', 511600, '岳池', 3, '0826', '638300', '106.44079', '30.53918', 'Yuechi', '1', 0);
INSERT INTO `hh_region` VALUES (511622, '武胜县', 511600, '武胜', 3, '0826', '638400', '106.29592', '30.34932', 'Wusheng', '1', 0);
INSERT INTO `hh_region` VALUES (511623, '邻水县', 511600, '邻水', 3, '0826', '638500', '106.92968', '30.33449', 'Linshui', '1', 0);
INSERT INTO `hh_region` VALUES (511681, '华蓥市', 511600, '华蓥', 3, '0826', '638600', '106.78466', '30.39007', 'Huaying', '1', 0);
INSERT INTO `hh_region` VALUES (511700, '达州市', 510000, '达州', 2, '0818', '635000', '107.502262', '31.209484', 'Dazhou', '1', 0);
INSERT INTO `hh_region` VALUES (511702, '通川区', 511700, '通川', 3, '0818', '635000', '107.50456', '31.21469', 'Tongchuan', '1', 0);
INSERT INTO `hh_region` VALUES (511703, '达川区', 511700, '达川', 3, '0818', '635000', '107.502262', '31.209484', 'Dachuan', '1', 0);
INSERT INTO `hh_region` VALUES (511722, '宣汉县', 511700, '宣汉', 3, '0818', '636150', '107.72775', '31.35516', 'Xuanhan', '1', 0);
INSERT INTO `hh_region` VALUES (511723, '开江县', 511700, '开江', 3, '0818', '636250', '107.86889', '31.0841', 'Kaijiang', '1', 0);
INSERT INTO `hh_region` VALUES (511724, '大竹县', 511700, '大竹', 3, '0818', '635100', '107.20855', '30.74147', 'Dazhu', '1', 0);
INSERT INTO `hh_region` VALUES (511725, '渠县', 511700, '渠县', 3, '0818', '635200', '106.97381', '30.8376', 'Quxian', '1', 0);
INSERT INTO `hh_region` VALUES (511781, '万源市', 511700, '万源', 3, '0818', '636350', '108.03598', '32.08091', 'Wanyuan', '1', 0);
INSERT INTO `hh_region` VALUES (511800, '雅安市', 510000, '雅安', 2, '0835', '625000', '103.001033', '29.987722', 'Ya\'an', '1', 0);
INSERT INTO `hh_region` VALUES (511802, '雨城区', 511800, '雨城', 3, '0835', '625000', '103.03305', '30.00531', 'Yucheng', '1', 0);
INSERT INTO `hh_region` VALUES (511803, '名山区', 511800, '名山', 3, '0835', '625100', '103.112214', '30.084718', 'Mingshan', '1', 0);
INSERT INTO `hh_region` VALUES (511822, '荥经县', 511800, '荥经', 3, '0835', '625200', '102.84652', '29.79402', 'Yingjing', '1', 0);
INSERT INTO `hh_region` VALUES (511823, '汉源县', 511800, '汉源', 3, '0835', '625300', '102.6784', '29.35168', 'Hanyuan', '1', 0);
INSERT INTO `hh_region` VALUES (511824, '石棉县', 511800, '石棉', 3, '0835', '625400', '102.35943', '29.22796', 'Shimian', '1', 0);
INSERT INTO `hh_region` VALUES (511825, '天全县', 511800, '天全', 3, '0835', '625500', '102.75906', '30.06754', 'Tianquan', '1', 0);
INSERT INTO `hh_region` VALUES (511826, '芦山县', 511800, '芦山', 3, '0835', '625600', '102.92791', '30.14369', 'Lushan', '1', 0);
INSERT INTO `hh_region` VALUES (511827, '宝兴县', 511800, '宝兴', 3, '0835', '625700', '102.81555', '30.36836', 'Baoxing', '1', 0);
INSERT INTO `hh_region` VALUES (511900, '巴中市', 510000, '巴中', 2, '0827', '636000', '106.753669', '31.858809', 'Bazhong', '1', 0);
INSERT INTO `hh_region` VALUES (511902, '巴州区', 511900, '巴州', 3, '0827', '636001', '106.76889', '31.85125', 'Bazhou', '1', 0);
INSERT INTO `hh_region` VALUES (511903, '恩阳区', 511900, '恩阳', 3, '0827', '636064', '106.753669', '31.858809', 'Enyang', '1', 0);
INSERT INTO `hh_region` VALUES (511921, '通江县', 511900, '通江', 3, '0827', '636700', '107.24398', '31.91294', 'Tongjiang', '1', 0);
INSERT INTO `hh_region` VALUES (511922, '南江县', 511900, '南江', 3, '0827', '636600', '106.84164', '32.35335', 'Nanjiang', '1', 0);
INSERT INTO `hh_region` VALUES (511923, '平昌县', 511900, '平昌', 3, '0827', '636400', '107.10424', '31.5594', 'Pingchang', '1', 0);
INSERT INTO `hh_region` VALUES (512000, '资阳市', 510000, '资阳', 2, '028', '641300', '104.641917', '30.122211', 'Ziyang', '1', 0);
INSERT INTO `hh_region` VALUES (512002, '雁江区', 512000, '雁江', 3, '028', '641300', '104.65216', '30.11525', 'Yanjiang', '1', 0);
INSERT INTO `hh_region` VALUES (512021, '安岳县', 512000, '安岳', 3, '028', '642350', '105.3363', '30.09786', 'Anyue', '1', 0);
INSERT INTO `hh_region` VALUES (512022, '乐至县', 512000, '乐至', 3, '028', '641500', '105.03207', '30.27227', 'Lezhi', '1', 0);
INSERT INTO `hh_region` VALUES (512081, '简阳市', 512000, '简阳', 3, '028', '641400', '104.54864', '30.3904', 'Jianyang', '1', 0);
INSERT INTO `hh_region` VALUES (513200, '阿坝藏族羌族自治州', 510000, '阿坝', 2, '0837', '624000', '102.221374', '31.899792', 'Aba', '1', 0);
INSERT INTO `hh_region` VALUES (513221, '汶川县', 513200, '汶川', 3, '0837', '623000', '103.59079', '31.47326', 'Wenchuan', '1', 0);
INSERT INTO `hh_region` VALUES (513222, '理县', 513200, '理县', 3, '0837', '623100', '103.17175', '31.43603', 'Lixian', '1', 0);
INSERT INTO `hh_region` VALUES (513223, '茂县', 513200, '茂县', 3, '0837', '623200', '103.85372', '31.682', 'Maoxian', '1', 0);
INSERT INTO `hh_region` VALUES (513224, '松潘县', 513200, '松潘', 3, '0837', '623300', '103.59924', '32.63871', 'Songpan', '1', 0);
INSERT INTO `hh_region` VALUES (513225, '九寨沟县', 513200, '九寨沟', 3, '0837', '623400', '104.23672', '33.26318', 'Jiuzhaigou', '1', 0);
INSERT INTO `hh_region` VALUES (513226, '金川县', 513200, '金川', 3, '0837', '624100', '102.06555', '31.47623', 'Jinchuan', '1', 0);
INSERT INTO `hh_region` VALUES (513227, '小金县', 513200, '小金', 3, '0837', '624200', '102.36499', '30.99934', 'Xiaojin', '1', 0);
INSERT INTO `hh_region` VALUES (513228, '黑水县', 513200, '黑水', 3, '0837', '623500', '102.99176', '32.06184', 'Heishui', '1', 0);
INSERT INTO `hh_region` VALUES (513229, '马尔康县', 513200, '马尔康', 3, '0837', '624000', '102.20625', '31.90584', 'Maerkang', '1', 0);
INSERT INTO `hh_region` VALUES (513230, '壤塘县', 513200, '壤塘', 3, '0837', '624300', '100.9783', '32.26578', 'Rangtang', '1', 0);
INSERT INTO `hh_region` VALUES (513231, '阿坝县', 513200, '阿坝', 3, '0837', '624600', '101.70632', '32.90301', 'Aba', '1', 0);
INSERT INTO `hh_region` VALUES (513232, '若尔盖县', 513200, '若尔盖', 3, '0837', '624500', '102.9598', '33.57432', 'Ruoergai', '1', 0);
INSERT INTO `hh_region` VALUES (513233, '红原县', 513200, '红原', 3, '0837', '624400', '102.54525', '32.78989', 'Hongyuan', '1', 0);
INSERT INTO `hh_region` VALUES (513300, '甘孜藏族自治州', 510000, '甘孜', 2, '0836', '626000', '101.963815', '30.050663', 'Garze', '1', 0);
INSERT INTO `hh_region` VALUES (513321, '康定县', 513300, '康定', 3, '0836', '626000', '101.96487', '30.05532', 'Kangding', '1', 0);
INSERT INTO `hh_region` VALUES (513322, '泸定县', 513300, '泸定', 3, '0836', '626100', '102.23507', '29.91475', 'Luding', '1', 0);
INSERT INTO `hh_region` VALUES (513323, '丹巴县', 513300, '丹巴', 3, '0836', '626300', '101.88424', '30.87656', 'Danba', '1', 0);
INSERT INTO `hh_region` VALUES (513324, '九龙县', 513300, '九龙', 3, '0836', '626200', '101.50848', '29.00091', 'Jiulong', '1', 0);
INSERT INTO `hh_region` VALUES (513325, '雅江县', 513300, '雅江', 3, '0836', '627450', '101.01492', '30.03281', 'Yajiang', '1', 0);
INSERT INTO `hh_region` VALUES (513326, '道孚县', 513300, '道孚', 3, '0836', '626400', '101.12554', '30.98046', 'Daofu', '1', 0);
INSERT INTO `hh_region` VALUES (513327, '炉霍县', 513300, '炉霍', 3, '0836', '626500', '100.67681', '31.3917', 'Luhuo', '1', 0);
INSERT INTO `hh_region` VALUES (513328, '甘孜县', 513300, '甘孜', 3, '0836', '626700', '99.99307', '31.62672', 'Ganzi', '1', 0);
INSERT INTO `hh_region` VALUES (513329, '新龙县', 513300, '新龙', 3, '0836', '626800', '100.3125', '30.94067', 'Xinlong', '1', 0);
INSERT INTO `hh_region` VALUES (513330, '德格县', 513300, '德格', 3, '0836', '627250', '98.58078', '31.80615', 'Dege', '1', 0);
INSERT INTO `hh_region` VALUES (513331, '白玉县', 513300, '白玉', 3, '0836', '627150', '98.82568', '31.20902', 'Baiyu', '1', 0);
INSERT INTO `hh_region` VALUES (513332, '石渠县', 513300, '石渠', 3, '0836', '627350', '98.10156', '32.97884', 'Shiqu', '1', 0);
INSERT INTO `hh_region` VALUES (513333, '色达县', 513300, '色达', 3, '0836', '626600', '100.33224', '32.26839', 'Seda', '1', 0);
INSERT INTO `hh_region` VALUES (513334, '理塘县', 513300, '理塘', 3, '0836', '627550', '100.27005', '29.99674', 'Litang', '1', 0);
INSERT INTO `hh_region` VALUES (513335, '巴塘县', 513300, '巴塘', 3, '0836', '627650', '99.10409', '30.00423', 'Batang', '1', 0);
INSERT INTO `hh_region` VALUES (513336, '乡城县', 513300, '乡城', 3, '0836', '627850', '99.79943', '28.93554', 'Xiangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (513337, '稻城县', 513300, '稻城', 3, '0836', '627750', '100.29809', '29.0379', 'Daocheng', '1', 0);
INSERT INTO `hh_region` VALUES (513338, '得荣县', 513300, '得荣', 3, '0836', '627950', '99.28628', '28.71297', 'Derong', '1', 0);
INSERT INTO `hh_region` VALUES (513400, '凉山彝族自治州', 510000, '凉山', 2, '0834', '615000', '102.258746', '27.886762', 'Liangshan', '1', 0);
INSERT INTO `hh_region` VALUES (513401, '西昌市', 513400, '西昌', 3, '0835', '615000', '102.26413', '27.89524', 'Xichang', '1', 0);
INSERT INTO `hh_region` VALUES (513422, '木里藏族自治县', 513400, '木里', 3, '0851', '615800', '101.2796', '27.92875', 'Muli', '1', 0);
INSERT INTO `hh_region` VALUES (513423, '盐源县', 513400, '盐源', 3, '0836', '615700', '101.5097', '27.42177', 'Yanyuan', '1', 0);
INSERT INTO `hh_region` VALUES (513424, '德昌县', 513400, '德昌', 3, '0837', '615500', '102.18017', '27.40482', 'Dechang', '1', 0);
INSERT INTO `hh_region` VALUES (513425, '会理县', 513400, '会理', 3, '0838', '615100', '102.24539', '26.65627', 'Huili', '1', 0);
INSERT INTO `hh_region` VALUES (513426, '会东县', 513400, '会东', 3, '0839', '615200', '102.57815', '26.63429', 'Huidong', '1', 0);
INSERT INTO `hh_region` VALUES (513427, '宁南县', 513400, '宁南', 3, '0840', '615400', '102.76116', '27.06567', 'Ningnan', '1', 0);
INSERT INTO `hh_region` VALUES (513428, '普格县', 513400, '普格', 3, '0841', '615300', '102.54055', '27.37485', 'Puge', '1', 0);
INSERT INTO `hh_region` VALUES (513429, '布拖县', 513400, '布拖', 3, '0842', '616350', '102.81234', '27.7079', 'Butuo', '1', 0);
INSERT INTO `hh_region` VALUES (513430, '金阳县', 513400, '金阳', 3, '0843', '616250', '103.24774', '27.69698', 'Jinyang', '1', 0);
INSERT INTO `hh_region` VALUES (513431, '昭觉县', 513400, '昭觉', 3, '0844', '616150', '102.84661', '28.01155', 'Zhaojue', '1', 0);
INSERT INTO `hh_region` VALUES (513432, '喜德县', 513400, '喜德', 3, '0845', '616750', '102.41336', '28.30739', 'Xide', '1', 0);
INSERT INTO `hh_region` VALUES (513433, '冕宁县', 513400, '冕宁', 3, '0846', '615600', '102.17108', '28.55161', 'Mianning', '1', 0);
INSERT INTO `hh_region` VALUES (513434, '越西县', 513400, '越西', 3, '0847', '616650', '102.5079', '28.64133', 'Yuexi', '1', 0);
INSERT INTO `hh_region` VALUES (513435, '甘洛县', 513400, '甘洛', 3, '0848', '616850', '102.77154', '28.96624', 'Ganluo', '1', 0);
INSERT INTO `hh_region` VALUES (513436, '美姑县', 513400, '美姑', 3, '0849', '616450', '103.13116', '28.32596', 'Meigu', '1', 0);
INSERT INTO `hh_region` VALUES (513437, '雷波县', 513400, '雷波', 3, '0850', '616550', '103.57287', '28.26407', 'Leibo', '1', 0);
INSERT INTO `hh_region` VALUES (520000, '贵州省', 100000, '贵州', 1, '', '', '106.713478', '26.578343', 'Guizhou', '1', 0);
INSERT INTO `hh_region` VALUES (520100, '贵阳市', 520000, '贵阳', 2, '0851', '550001', '106.713478', '26.578343', 'Guiyang', '1', 0);
INSERT INTO `hh_region` VALUES (520102, '南明区', 520100, '南明', 3, '0851', '550001', '106.7145', '26.56819', 'Nanming', '1', 0);
INSERT INTO `hh_region` VALUES (520103, '云岩区', 520100, '云岩', 3, '0851', '550001', '106.72485', '26.60484', 'Yunyan', '1', 0);
INSERT INTO `hh_region` VALUES (520111, '花溪区', 520100, '花溪', 3, '0851', '550025', '106.67688', '26.43343', 'Huaxi', '1', 0);
INSERT INTO `hh_region` VALUES (520112, '乌当区', 520100, '乌当', 3, '0851', '550018', '106.7521', '26.6302', 'Wudang', '1', 0);
INSERT INTO `hh_region` VALUES (520113, '白云区', 520100, '白云', 3, '0851', '550014', '106.63088', '26.68284', 'Baiyun', '1', 0);
INSERT INTO `hh_region` VALUES (520115, '观山湖区', 520100, '观山湖', 3, '0851', '550009', '106.625442', '26.618209', 'Guanshanhu', '1', 0);
INSERT INTO `hh_region` VALUES (520121, '开阳县', 520100, '开阳', 3, '0851', '550300', '106.9692', '27.05533', 'Kaiyang', '1', 0);
INSERT INTO `hh_region` VALUES (520122, '息烽县', 520100, '息烽', 3, '0851', '551100', '106.738', '27.09346', 'Xifeng', '1', 0);
INSERT INTO `hh_region` VALUES (520123, '修文县', 520100, '修文', 3, '0851', '550200', '106.59487', '26.83783', 'Xiuwen', '1', 0);
INSERT INTO `hh_region` VALUES (520181, '清镇市', 520100, '清镇', 3, '0851', '551400', '106.46862', '26.55261', 'Qingzhen', '1', 0);
INSERT INTO `hh_region` VALUES (520200, '六盘水市', 520000, '六盘水', 2, '0858', '553400', '104.846743', '26.584643', 'Liupanshui', '1', 0);
INSERT INTO `hh_region` VALUES (520201, '钟山区', 520200, '钟山', 3, '0858', '553000', '104.87848', '26.57699', 'Zhongshan', '1', 0);
INSERT INTO `hh_region` VALUES (520203, '六枝特区', 520200, '六枝', 3, '0858', '553400', '105.48062', '26.20117', 'Liuzhi', '1', 0);
INSERT INTO `hh_region` VALUES (520221, '水城县', 520200, '水城', 3, '0858', '553000', '104.95764', '26.54785', 'Shuicheng', '1', 0);
INSERT INTO `hh_region` VALUES (520222, '盘县', 520200, '盘县', 3, '0858', '561601', '104.47061', '25.7136', 'Panxian', '1', 0);
INSERT INTO `hh_region` VALUES (520300, '遵义市', 520000, '遵义', 2, '0852', '563000', '106.937265', '27.706626', 'Zunyi', '1', 0);
INSERT INTO `hh_region` VALUES (520302, '红花岗区', 520300, '红花岗', 3, '0852', '563000', '106.89404', '27.64471', 'Honghuagang', '1', 0);
INSERT INTO `hh_region` VALUES (520303, '汇川区', 520300, '汇川', 3, '0852', '563000', '106.9393', '27.70625', 'Huichuan', '1', 0);
INSERT INTO `hh_region` VALUES (520321, '遵义县', 520300, '遵义', 3, '0852', '563100', '106.83331', '27.53772', 'Zunyi', '1', 0);
INSERT INTO `hh_region` VALUES (520322, '桐梓县', 520300, '桐梓', 3, '0852', '563200', '106.82568', '28.13806', 'Tongzi', '1', 0);
INSERT INTO `hh_region` VALUES (520323, '绥阳县', 520300, '绥阳', 3, '0852', '563300', '107.19064', '27.94702', 'Suiyang', '1', 0);
INSERT INTO `hh_region` VALUES (520324, '正安县', 520300, '正安', 3, '0852', '563400', '107.44357', '28.5512', 'Zheng\'an', '1', 0);
INSERT INTO `hh_region` VALUES (520325, '道真仡佬族苗族自治县', 520300, '道真', 3, '0852', '563500', '107.61152', '28.864', 'Daozhen', '1', 0);
INSERT INTO `hh_region` VALUES (520326, '务川仡佬族苗族自治县', 520300, '务川', 3, '0852', '564300', '107.88935', '28.52227', 'Wuchuan', '1', 0);
INSERT INTO `hh_region` VALUES (520327, '凤冈县', 520300, '凤冈', 3, '0852', '564200', '107.71682', '27.95461', 'Fenggang', '1', 0);
INSERT INTO `hh_region` VALUES (520328, '湄潭县', 520300, '湄潭', 3, '0852', '564100', '107.48779', '27.76676', 'Meitan', '1', 0);
INSERT INTO `hh_region` VALUES (520329, '余庆县', 520300, '余庆', 3, '0852', '564400', '107.88821', '27.22532', 'Yuqing', '1', 0);
INSERT INTO `hh_region` VALUES (520330, '习水县', 520300, '习水', 3, '0852', '564600', '106.21267', '28.31976', 'Xishui', '1', 0);
INSERT INTO `hh_region` VALUES (520381, '赤水市', 520300, '赤水', 3, '0852', '564700', '105.69845', '28.58921', 'Chishui', '1', 0);
INSERT INTO `hh_region` VALUES (520382, '仁怀市', 520300, '仁怀', 3, '0852', '564500', '106.40152', '27.79231', 'Renhuai', '1', 0);
INSERT INTO `hh_region` VALUES (520400, '安顺市', 520000, '安顺', 2, '0853', '561000', '105.932188', '26.245544', 'Anshun', '1', 0);
INSERT INTO `hh_region` VALUES (520402, '西秀区', 520400, '西秀', 3, '0853', '561000', '105.96585', '26.24491', 'Xixiu', '1', 0);
INSERT INTO `hh_region` VALUES (520421, '平坝区', 520400, '平坝', 3, '0853', '561100', '106.25683', '26.40543', 'Pingba', '1', 0);
INSERT INTO `hh_region` VALUES (520422, '普定县', 520400, '普定', 3, '0853', '562100', '105.74285', '26.30141', 'Puding', '1', 0);
INSERT INTO `hh_region` VALUES (520423, '镇宁布依族苗族自治县', 520400, '镇宁', 3, '0853', '561200', '105.76513', '26.05533', 'Zhenning', '1', 0);
INSERT INTO `hh_region` VALUES (520424, '关岭布依族苗族自治县', 520400, '关岭', 3, '0853', '561300', '105.61883', '25.94248', 'Guanling', '1', 0);
INSERT INTO `hh_region` VALUES (520425, '紫云苗族布依族自治县', 520400, '紫云', 3, '0853', '550800', '106.08364', '25.75258', 'Ziyun', '1', 0);
INSERT INTO `hh_region` VALUES (520500, '毕节市', 520000, '毕节', 2, '0857', '551700', '105.28501', '27.301693', 'Bijie', '1', 0);
INSERT INTO `hh_region` VALUES (520502, '七星关区', 520500, '七星关', 3, '0857', '551700', '104.9497', '27.153556', 'Qixingguan', '1', 0);
INSERT INTO `hh_region` VALUES (520521, '大方县', 520500, '大方', 3, '0857', '551600', '105.609254', '27.143521', 'Dafang', '1', 0);
INSERT INTO `hh_region` VALUES (520522, '黔西县', 520500, '黔西', 3, '0857', '551500', '106.038299', '27.024923', 'Qianxi', '1', 0);
INSERT INTO `hh_region` VALUES (520523, '金沙县', 520500, '金沙', 3, '0857', '551800', '106.222103', '27.459693', 'Jinsha', '1', 0);
INSERT INTO `hh_region` VALUES (520524, '织金县', 520500, '织金', 3, '0857', '552100', '105.768997', '26.668497', 'Zhijin', '1', 0);
INSERT INTO `hh_region` VALUES (520525, '纳雍县', 520500, '纳雍', 3, '0857', '553300', '105.375322', '26.769875', 'Nayong', '1', 0);
INSERT INTO `hh_region` VALUES (520526, '威宁彝族回族苗族自治县', 520500, '威宁', 3, '0857', '553100', '104.286523', '26.859099', 'Weining', '1', 0);
INSERT INTO `hh_region` VALUES (520527, '赫章县', 520500, '赫章', 3, '0857', '553200', '104.726438', '27.119243', 'Hezhang', '1', 0);
INSERT INTO `hh_region` VALUES (520600, '铜仁市', 520000, '铜仁', 2, '0856', '554300', '109.191555', '27.718346', 'Tongren', '1', 0);
INSERT INTO `hh_region` VALUES (520602, '碧江区', 520600, '碧江', 3, '0856', '554300', '109.191555', '27.718346', 'Bijiang', '1', 0);
INSERT INTO `hh_region` VALUES (520603, '万山区', 520600, '万山', 3, '0856', '554200', '109.21199', '27.51903', 'Wanshan', '1', 0);
INSERT INTO `hh_region` VALUES (520621, '江口县', 520600, '江口', 3, '0856', '554400', '108.848427', '27.691904', 'Jiangkou', '1', 0);
INSERT INTO `hh_region` VALUES (520622, '玉屏侗族自治县', 520600, '玉屏', 3, '0856', '554004', '108.917882', '27.238024', 'Yuping', '1', 0);
INSERT INTO `hh_region` VALUES (520623, '石阡县', 520600, '石阡', 3, '0856', '555100', '108.229854', '27.519386', 'Shiqian', '1', 0);
INSERT INTO `hh_region` VALUES (520624, '思南县', 520600, '思南', 3, '0856', '565100', '108.255827', '27.941331', 'Sinan', '1', 0);
INSERT INTO `hh_region` VALUES (520625, '印江土家族苗族自治县', 520600, '印江', 3, '0856', '555200', '108.405517', '27.997976', 'Yinjiang', '1', 0);
INSERT INTO `hh_region` VALUES (520626, '德江县', 520600, '德江', 3, '0856', '565200', '108.117317', '28.26094', 'Dejiang', '1', 0);
INSERT INTO `hh_region` VALUES (520627, '沿河土家族自治县', 520600, '沿河', 3, '0856', '565300', '108.495746', '28.560487', 'Yuanhe', '1', 0);
INSERT INTO `hh_region` VALUES (520628, '松桃苗族自治县', 520600, '松桃', 3, '0856', '554100', '109.202627', '28.165419', 'Songtao', '1', 0);
INSERT INTO `hh_region` VALUES (522300, '黔西南布依族苗族自治州', 520000, '黔西南', 2, '0859', '562400', '104.897971', '25.08812', 'Qianxinan', '1', 0);
INSERT INTO `hh_region` VALUES (522301, '兴义市 ', 522300, '兴义', 3, '0859', '562400', '104.89548', '25.09205', 'Xingyi', '1', 0);
INSERT INTO `hh_region` VALUES (522322, '兴仁县', 522300, '兴仁', 3, '0859', '562300', '105.18652', '25.43282', 'Xingren', '1', 0);
INSERT INTO `hh_region` VALUES (522323, '普安县', 522300, '普安', 3, '0859', '561500', '104.95529', '25.78603', 'Pu\'an', '1', 0);
INSERT INTO `hh_region` VALUES (522324, '晴隆县', 522300, '晴隆', 3, '0859', '561400', '105.2192', '25.83522', 'Qinglong', '1', 0);
INSERT INTO `hh_region` VALUES (522325, '贞丰县', 522300, '贞丰', 3, '0859', '562200', '105.65454', '25.38464', 'Zhenfeng', '1', 0);
INSERT INTO `hh_region` VALUES (522326, '望谟县', 522300, '望谟', 3, '0859', '552300', '106.09957', '25.17822', 'Wangmo', '1', 0);
INSERT INTO `hh_region` VALUES (522327, '册亨县', 522300, '册亨', 3, '0859', '552200', '105.8124', '24.98376', 'Ceheng', '1', 0);
INSERT INTO `hh_region` VALUES (522328, '安龙县', 522300, '安龙', 3, '0859', '552400', '105.44268', '25.09818', 'Anlong', '1', 0);
INSERT INTO `hh_region` VALUES (522600, '黔东南苗族侗族自治州', 520000, '黔东南', 2, '0855', '556000', '107.977488', '26.583352', 'Qiandongnan', '1', 0);
INSERT INTO `hh_region` VALUES (522601, '凯里市', 522600, '凯里', 3, '0855', '556000', '107.98132', '26.56689', 'Kaili', '1', 0);
INSERT INTO `hh_region` VALUES (522622, '黄平县', 522600, '黄平', 3, '0855', '556100', '107.90179', '26.89573', 'Huangping', '1', 0);
INSERT INTO `hh_region` VALUES (522623, '施秉县', 522600, '施秉', 3, '0855', '556200', '108.12597', '27.03495', 'Shibing', '1', 0);
INSERT INTO `hh_region` VALUES (522624, '三穗县', 522600, '三穗', 3, '0855', '556500', '108.67132', '26.94765', 'Sansui', '1', 0);
INSERT INTO `hh_region` VALUES (522625, '镇远县', 522600, '镇远', 3, '0855', '557700', '108.42721', '27.04933', 'Zhenyuan', '1', 0);
INSERT INTO `hh_region` VALUES (522626, '岑巩县', 522600, '岑巩', 3, '0855', '557800', '108.81884', '27.17539', 'Cengong', '1', 0);
INSERT INTO `hh_region` VALUES (522627, '天柱县', 522600, '天柱', 3, '0855', '556600', '109.20718', '26.90781', 'Tianzhu', '1', 0);
INSERT INTO `hh_region` VALUES (522628, '锦屏县', 522600, '锦屏', 3, '0855', '556700', '109.19982', '26.67635', 'Jinping', '1', 0);
INSERT INTO `hh_region` VALUES (522629, '剑河县', 522600, '剑河', 3, '0855', '556400', '108.5913', '26.6525', 'Jianhe', '1', 0);
INSERT INTO `hh_region` VALUES (522630, '台江县', 522600, '台江', 3, '0855', '556300', '108.31814', '26.66916', 'Taijiang', '1', 0);
INSERT INTO `hh_region` VALUES (522631, '黎平县', 522600, '黎平', 3, '0855', '557300', '109.13607', '26.23114', 'Liping', '1', 0);
INSERT INTO `hh_region` VALUES (522632, '榕江县', 522600, '榕江', 3, '0855', '557200', '108.52072', '25.92421', 'Rongjiang', '1', 0);
INSERT INTO `hh_region` VALUES (522633, '从江县', 522600, '从江', 3, '0855', '557400', '108.90527', '25.75415', 'Congjiang', '1', 0);
INSERT INTO `hh_region` VALUES (522634, '雷山县', 522600, '雷山', 3, '0855', '557100', '108.07745', '26.38385', 'Leishan', '1', 0);
INSERT INTO `hh_region` VALUES (522635, '麻江县', 522600, '麻江', 3, '0855', '557600', '107.59155', '26.49235', 'Majiang', '1', 0);
INSERT INTO `hh_region` VALUES (522636, '丹寨县', 522600, '丹寨', 3, '0855', '557500', '107.79718', '26.19816', 'Danzhai', '1', 0);
INSERT INTO `hh_region` VALUES (522700, '黔南布依族苗族自治州', 520000, '黔南', 2, '0854', '558000', '107.517156', '26.258219', 'Qiannan', '1', 0);
INSERT INTO `hh_region` VALUES (522701, '都匀市', 522700, '都匀', 3, '0854', '558000', '107.51872', '26.2594', 'Duyun', '1', 0);
INSERT INTO `hh_region` VALUES (522702, '福泉市', 522700, '福泉', 3, '0854', '550500', '107.51715', '26.67989', 'Fuquan', '1', 0);
INSERT INTO `hh_region` VALUES (522722, '荔波县', 522700, '荔波', 3, '0854', '558400', '107.88592', '25.4139', 'Libo', '1', 0);
INSERT INTO `hh_region` VALUES (522723, '贵定县', 522700, '贵定', 3, '0854', '551300', '107.23654', '26.57812', 'Guiding', '1', 0);
INSERT INTO `hh_region` VALUES (522725, '瓮安县', 522700, '瓮安', 3, '0854', '550400', '107.4757', '27.06813', 'Weng\'an', '1', 0);
INSERT INTO `hh_region` VALUES (522726, '独山县', 522700, '独山', 3, '0854', '558200', '107.54101', '25.8245', 'Dushan', '1', 0);
INSERT INTO `hh_region` VALUES (522727, '平塘县', 522700, '平塘', 3, '0854', '558300', '107.32428', '25.83294', 'Pingtang', '1', 0);
INSERT INTO `hh_region` VALUES (522728, '罗甸县', 522700, '罗甸', 3, '0854', '550100', '106.75186', '25.42586', 'Luodian', '1', 0);
INSERT INTO `hh_region` VALUES (522729, '长顺县', 522700, '长顺', 3, '0854', '550700', '106.45217', '26.02299', 'Changshun', '1', 0);
INSERT INTO `hh_region` VALUES (522730, '龙里县', 522700, '龙里', 3, '0854', '551200', '106.97662', '26.45076', 'Longli', '1', 0);
INSERT INTO `hh_region` VALUES (522731, '惠水县', 522700, '惠水', 3, '0854', '550600', '106.65911', '26.13389', 'Huishui', '1', 0);
INSERT INTO `hh_region` VALUES (522732, '三都水族自治县', 522700, '三都', 3, '0854', '558100', '107.87464', '25.98562', 'Sandu', '1', 0);
INSERT INTO `hh_region` VALUES (530000, '云南省', 100000, '云南', 1, '', '', '102.712251', '25.040609', 'Yunnan', '1', 0);
INSERT INTO `hh_region` VALUES (530100, '昆明市', 530000, '昆明', 2, '0871', '650500', '102.712251', '25.040609', 'Kunming', '1', 0);
INSERT INTO `hh_region` VALUES (530102, '五华区', 530100, '五华', 3, '0871', '650021', '102.70786', '25.03521', 'Wuhua', '1', 0);
INSERT INTO `hh_region` VALUES (530103, '盘龙区', 530100, '盘龙', 3, '0871', '650051', '102.71994', '25.04053', 'Panlong', '1', 0);
INSERT INTO `hh_region` VALUES (530111, '官渡区', 530100, '官渡', 3, '0871', '650200', '102.74362', '25.01497', 'Guandu', '1', 0);
INSERT INTO `hh_region` VALUES (530112, '西山区', 530100, '西山', 3, '0871', '650118', '102.66464', '25.03796', 'Xishan', '1', 0);
INSERT INTO `hh_region` VALUES (530113, '东川区', 530100, '东川', 3, '0871', '654100', '103.18832', '26.083', 'Dongchuan', '1', 0);
INSERT INTO `hh_region` VALUES (530114, '呈贡区', 530100, '呈贡', 3, '0871', '650500', '102.801382', '24.889275', 'Chenggong', '1', 0);
INSERT INTO `hh_region` VALUES (530122, '晋宁县', 530100, '晋宁', 3, '0871', '650600', '102.59393', '24.6665', 'Jinning', '1', 0);
INSERT INTO `hh_region` VALUES (530124, '富民县', 530100, '富民', 3, '0871', '650400', '102.4985', '25.22119', 'Fumin', '1', 0);
INSERT INTO `hh_region` VALUES (530125, '宜良县', 530100, '宜良', 3, '0871', '652100', '103.14117', '24.91705', 'Yiliang', '1', 0);
INSERT INTO `hh_region` VALUES (530126, '石林彝族自治县', 530100, '石林', 3, '0871', '652200', '103.27148', '24.75897', 'Shilin', '1', 0);
INSERT INTO `hh_region` VALUES (530127, '嵩明县', 530100, '嵩明', 3, '0871', '651700', '103.03729', '25.33986', 'Songming', '1', 0);
INSERT INTO `hh_region` VALUES (530128, '禄劝彝族苗族自治县', 530100, '禄劝', 3, '0871', '651500', '102.4671', '25.55387', 'Luquan', '1', 0);
INSERT INTO `hh_region` VALUES (530129, '寻甸回族彝族自治县 ', 530100, '寻甸', 3, '0871', '655200', '103.2557', '25.55961', 'Xundian', '1', 0);
INSERT INTO `hh_region` VALUES (530181, '安宁市', 530100, '安宁', 3, '0871', '650300', '102.46972', '24.91652', 'Anning', '1', 0);
INSERT INTO `hh_region` VALUES (530300, '曲靖市', 530000, '曲靖', 2, '0874', '655000', '103.797851', '25.501557', 'Qujing', '1', 0);
INSERT INTO `hh_region` VALUES (530302, '麒麟区', 530300, '麒麟', 3, '0874', '655000', '103.80504', '25.49515', 'Qilin', '1', 0);
INSERT INTO `hh_region` VALUES (530321, '马龙县', 530300, '马龙', 3, '0874', '655100', '103.57873', '25.42521', 'Malong', '1', 0);
INSERT INTO `hh_region` VALUES (530322, '陆良县', 530300, '陆良', 3, '0874', '655600', '103.6665', '25.02335', 'Luliang', '1', 0);
INSERT INTO `hh_region` VALUES (530323, '师宗县', 530300, '师宗', 3, '0874', '655700', '103.99084', '24.82822', 'Shizong', '1', 0);
INSERT INTO `hh_region` VALUES (530324, '罗平县', 530300, '罗平', 3, '0874', '655800', '104.30859', '24.88444', 'Luoping', '1', 0);
INSERT INTO `hh_region` VALUES (530325, '富源县', 530300, '富源', 3, '0874', '655500', '104.25387', '25.66587', 'Fuyuan', '1', 0);
INSERT INTO `hh_region` VALUES (530326, '会泽县', 530300, '会泽', 3, '0874', '654200', '103.30017', '26.41076', 'Huize', '1', 0);
INSERT INTO `hh_region` VALUES (530328, '沾益县', 530300, '沾益', 3, '0874', '655331', '103.82135', '25.60715', 'Zhanyi', '1', 0);
INSERT INTO `hh_region` VALUES (530381, '宣威市', 530300, '宣威', 3, '0874', '655400', '104.10409', '26.2173', 'Xuanwei', '1', 0);
INSERT INTO `hh_region` VALUES (530400, '玉溪市', 530000, '玉溪', 2, '0877', '653100', '102.543907', '24.350461', 'Yuxi', '1', 0);
INSERT INTO `hh_region` VALUES (530402, '红塔区', 530400, '红塔', 3, '0877', '653100', '102.5449', '24.35411', 'Hongta', '1', 0);
INSERT INTO `hh_region` VALUES (530421, '江川县', 530400, '江川', 3, '0877', '652600', '102.75412', '24.28863', 'Jiangchuan', '1', 0);
INSERT INTO `hh_region` VALUES (530422, '澄江县', 530400, '澄江', 3, '0877', '652500', '102.90817', '24.67376', 'Chengjiang', '1', 0);
INSERT INTO `hh_region` VALUES (530423, '通海县', 530400, '通海', 3, '0877', '652700', '102.76641', '24.11362', 'Tonghai', '1', 0);
INSERT INTO `hh_region` VALUES (530424, '华宁县', 530400, '华宁', 3, '0877', '652800', '102.92831', '24.1926', 'Huaning', '1', 0);
INSERT INTO `hh_region` VALUES (530425, '易门县', 530400, '易门', 3, '0877', '651100', '102.16354', '24.67122', 'Yimen', '1', 0);
INSERT INTO `hh_region` VALUES (530426, '峨山彝族自治县', 530400, '峨山', 3, '0877', '653200', '102.40576', '24.16904', 'Eshan', '1', 0);
INSERT INTO `hh_region` VALUES (530427, '新平彝族傣族自治县', 530400, '新平', 3, '0877', '653400', '101.98895', '24.06886', 'Xinping', '1', 0);
INSERT INTO `hh_region` VALUES (530428, '元江哈尼族彝族傣族自治县', 530400, '元江', 3, '0877', '653300', '101.99812', '23.59655', 'Yuanjiang', '1', 0);
INSERT INTO `hh_region` VALUES (530500, '保山市', 530000, '保山', 2, '0875', '678000', '99.167133', '25.111802', 'Baoshan', '1', 0);
INSERT INTO `hh_region` VALUES (530502, '隆阳区', 530500, '隆阳', 3, '0875', '678000', '99.16334', '25.11163', 'Longyang', '1', 0);
INSERT INTO `hh_region` VALUES (530521, '施甸县', 530500, '施甸', 3, '0875', '678200', '99.18768', '24.72418', 'Shidian', '1', 0);
INSERT INTO `hh_region` VALUES (530522, '腾冲县', 530500, '腾冲', 3, '0875', '679100', '98.49414', '25.02539', 'Tengchong', '1', 0);
INSERT INTO `hh_region` VALUES (530523, '龙陵县', 530500, '龙陵', 3, '0875', '678300', '98.69024', '24.58746', 'Longling', '1', 0);
INSERT INTO `hh_region` VALUES (530524, '昌宁县', 530500, '昌宁', 3, '0875', '678100', '99.6036', '24.82763', 'Changning', '1', 0);
INSERT INTO `hh_region` VALUES (530600, '昭通市', 530000, '昭通', 2, '0870', '657000', '103.717216', '27.336999', 'Zhaotong', '1', 0);
INSERT INTO `hh_region` VALUES (530602, '昭阳区', 530600, '昭阳', 3, '0870', '657000', '103.70654', '27.31998', 'Zhaoyang', '1', 0);
INSERT INTO `hh_region` VALUES (530621, '鲁甸县', 530600, '鲁甸', 3, '0870', '657100', '103.54721', '27.19238', 'Ludian', '1', 0);
INSERT INTO `hh_region` VALUES (530622, '巧家县', 530600, '巧家', 3, '0870', '654600', '102.92416', '26.91237', 'Qiaojia', '1', 0);
INSERT INTO `hh_region` VALUES (530623, '盐津县', 530600, '盐津', 3, '0870', '657500', '104.23461', '28.10856', 'Yanjin', '1', 0);
INSERT INTO `hh_region` VALUES (530624, '大关县', 530600, '大关', 3, '0870', '657400', '103.89254', '27.7488', 'Daguan', '1', 0);
INSERT INTO `hh_region` VALUES (530625, '永善县', 530600, '永善', 3, '0870', '657300', '103.63504', '28.2279', 'Yongshan', '1', 0);
INSERT INTO `hh_region` VALUES (530626, '绥江县', 530600, '绥江', 3, '0870', '657700', '103.94937', '28.59661', 'Suijiang', '1', 0);
INSERT INTO `hh_region` VALUES (530627, '镇雄县', 530600, '镇雄', 3, '0870', '657200', '104.87258', '27.43981', 'Zhenxiong', '1', 0);
INSERT INTO `hh_region` VALUES (530628, '彝良县', 530600, '彝良', 3, '0870', '657600', '104.04983', '27.62809', 'Yiliang', '1', 0);
INSERT INTO `hh_region` VALUES (530629, '威信县', 530600, '威信', 3, '0870', '657900', '105.04754', '27.84065', 'Weixin', '1', 0);
INSERT INTO `hh_region` VALUES (530630, '水富县', 530600, '水富', 3, '0870', '657800', '104.4158', '28.62986', 'Shuifu', '1', 0);
INSERT INTO `hh_region` VALUES (530700, '丽江市', 530000, '丽江', 2, '0888', '674100', '100.233026', '26.872108', 'Lijiang', '1', 0);
INSERT INTO `hh_region` VALUES (530702, '古城区', 530700, '古城', 3, '0888', '674100', '100.2257', '26.87697', 'Gucheng', '1', 0);
INSERT INTO `hh_region` VALUES (530721, '玉龙纳西族自治县', 530700, '玉龙', 3, '0888', '674100', '100.2369', '26.82149', 'Yulong', '1', 0);
INSERT INTO `hh_region` VALUES (530722, '永胜县', 530700, '永胜', 3, '0888', '674200', '100.74667', '26.68591', 'Yongsheng', '1', 0);
INSERT INTO `hh_region` VALUES (530723, '华坪县', 530700, '华坪', 3, '0888', '674800', '101.26562', '26.62967', 'Huaping', '1', 0);
INSERT INTO `hh_region` VALUES (530724, '宁蒗彝族自治县', 530700, '宁蒗', 3, '0888', '674300', '100.8507', '27.28179', 'Ninglang', '1', 0);
INSERT INTO `hh_region` VALUES (530800, '普洱市', 530000, '普洱', 2, '0879', '665000', '100.972344', '22.777321', 'Pu\'er', '1', 0);
INSERT INTO `hh_region` VALUES (530802, '思茅区', 530800, '思茅', 3, '0879', '665000', '100.97716', '22.78691', 'Simao', '1', 0);
INSERT INTO `hh_region` VALUES (530821, '宁洱哈尼族彝族自治县', 530800, '宁洱', 3, '0879', '665100', '101.04653', '23.06341', 'Ninger', '1', 0);
INSERT INTO `hh_region` VALUES (530822, '墨江哈尼族自治县', 530800, '墨江', 3, '0879', '654800', '101.69171', '23.43214', 'Mojiang', '1', 0);
INSERT INTO `hh_region` VALUES (530823, '景东彝族自治县', 530800, '景东', 3, '0879', '676200', '100.83599', '24.44791', 'Jingdong', '1', 0);
INSERT INTO `hh_region` VALUES (530824, '景谷傣族彝族自治县', 530800, '景谷', 3, '0879', '666400', '100.70251', '23.49705', 'Jinggu', '1', 0);
INSERT INTO `hh_region` VALUES (530825, '镇沅彝族哈尼族拉祜族自治县', 530800, '镇沅', 3, '0879', '666500', '101.10675', '24.00557', 'Zhenyuan', '1', 0);
INSERT INTO `hh_region` VALUES (530826, '江城哈尼族彝族自治县', 530800, '江城', 3, '0879', '665900', '101.85788', '22.58424', 'Jiangcheng', '1', 0);
INSERT INTO `hh_region` VALUES (530827, '孟连傣族拉祜族佤族自治县', 530800, '孟连', 3, '0879', '665800', '99.58424', '22.32922', 'Menglian', '1', 0);
INSERT INTO `hh_region` VALUES (530828, '澜沧拉祜族自治县', 530800, '澜沧', 3, '0879', '665600', '99.93591', '22.55474', 'Lancang', '1', 0);
INSERT INTO `hh_region` VALUES (530829, '西盟佤族自治县', 530800, '西盟', 3, '0879', '665700', '99.59869', '22.64774', 'Ximeng', '1', 0);
INSERT INTO `hh_region` VALUES (530900, '临沧市', 530000, '临沧', 2, '0883', '677000', '100.08697', '23.886567', 'Lincang', '1', 0);
INSERT INTO `hh_region` VALUES (530902, '临翔区', 530900, '临翔', 3, '0883', '677000', '100.08242', '23.89497', 'Linxiang', '1', 0);
INSERT INTO `hh_region` VALUES (530921, '凤庆县', 530900, '凤庆', 3, '0883', '675900', '99.92837', '24.58034', 'Fengqing', '1', 0);
INSERT INTO `hh_region` VALUES (530922, '云县', 530900, '云县', 3, '0883', '675800', '100.12808', '24.44675', 'Yunxian', '1', 0);
INSERT INTO `hh_region` VALUES (530923, '永德县', 530900, '永德', 3, '0883', '677600', '99.25326', '24.0276', 'Yongde', '1', 0);
INSERT INTO `hh_region` VALUES (530924, '镇康县', 530900, '镇康', 3, '0883', '677704', '98.8255', '23.76241', 'Zhenkang', '1', 0);
INSERT INTO `hh_region` VALUES (530925, '双江拉祜族佤族布朗族傣族自治县', 530900, '双江', 3, '0883', '677300', '99.82769', '23.47349', 'Shuangjiang', '1', 0);
INSERT INTO `hh_region` VALUES (530926, '耿马傣族佤族自治县', 530900, '耿马', 3, '0883', '677500', '99.39785', '23.53776', 'Gengma', '1', 0);
INSERT INTO `hh_region` VALUES (530927, '沧源佤族自治县', 530900, '沧源', 3, '0883', '677400', '99.24545', '23.14821', 'Cangyuan', '1', 0);
INSERT INTO `hh_region` VALUES (532300, '楚雄彝族自治州', 530000, '楚雄', 2, '0878', '675000', '101.546046', '25.041988', 'Chuxiong', '1', 0);
INSERT INTO `hh_region` VALUES (532301, '楚雄市', 532300, '楚雄', 3, '0878', '675000', '101.54615', '25.0329', 'Chuxiong', '1', 0);
INSERT INTO `hh_region` VALUES (532322, '双柏县', 532300, '双柏', 3, '0878', '675100', '101.64205', '24.68882', 'Shuangbai', '1', 0);
INSERT INTO `hh_region` VALUES (532323, '牟定县', 532300, '牟定', 3, '0878', '675500', '101.54', '25.31551', 'Mouding', '1', 0);
INSERT INTO `hh_region` VALUES (532324, '南华县', 532300, '南华', 3, '0878', '675200', '101.27313', '25.19293', 'Nanhua', '1', 0);
INSERT INTO `hh_region` VALUES (532325, '姚安县', 532300, '姚安', 3, '0878', '675300', '101.24279', '25.50467', 'Yao\'an', '1', 0);
INSERT INTO `hh_region` VALUES (532326, '大姚县', 532300, '大姚', 3, '0878', '675400', '101.32397', '25.72218', 'Dayao', '1', 0);
INSERT INTO `hh_region` VALUES (532327, '永仁县', 532300, '永仁', 3, '0878', '651400', '101.6716', '26.05794', 'Yongren', '1', 0);
INSERT INTO `hh_region` VALUES (532328, '元谋县', 532300, '元谋', 3, '0878', '651300', '101.87728', '25.70438', 'Yuanmou', '1', 0);
INSERT INTO `hh_region` VALUES (532329, '武定县', 532300, '武定', 3, '0878', '651600', '102.4038', '25.5295', 'Wuding', '1', 0);
INSERT INTO `hh_region` VALUES (532331, '禄丰县', 532300, '禄丰', 3, '0878', '651200', '102.07797', '25.14815', 'Lufeng', '1', 0);
INSERT INTO `hh_region` VALUES (532500, '红河哈尼族彝族自治州', 530000, '红河', 2, '0873', '661400', '103.384182', '23.366775', 'Honghe', '1', 0);
INSERT INTO `hh_region` VALUES (532501, '个旧市', 532500, '个旧', 3, '0873', '661000', '103.15966', '23.35894', 'Gejiu', '1', 0);
INSERT INTO `hh_region` VALUES (532502, '开远市', 532500, '开远', 3, '0873', '661600', '103.26986', '23.71012', 'Kaiyuan', '1', 0);
INSERT INTO `hh_region` VALUES (532503, '蒙自市', 532500, '蒙自', 3, '0873', '661101', '103.385005', '23.366843', 'Mengzi', '1', 0);
INSERT INTO `hh_region` VALUES (532504, '弥勒市', 532500, '弥勒', 3, '0873', '652300', '103.436988', '24.40837', 'Mile ', '1', 0);
INSERT INTO `hh_region` VALUES (532523, '屏边苗族自治县', 532500, '屏边', 3, '0873', '661200', '103.68554', '22.98425', 'Pingbian', '1', 0);
INSERT INTO `hh_region` VALUES (532524, '建水县', 532500, '建水', 3, '0873', '654300', '102.82656', '23.63472', 'Jianshui', '1', 0);
INSERT INTO `hh_region` VALUES (532525, '石屏县', 532500, '石屏', 3, '0873', '662200', '102.49408', '23.71441', 'Shiping', '1', 0);
INSERT INTO `hh_region` VALUES (532527, '泸西县', 532500, '泸西', 3, '0873', '652400', '103.76373', '24.52854', 'Luxi', '1', 0);
INSERT INTO `hh_region` VALUES (532528, '元阳县', 532500, '元阳', 3, '0873', '662400', '102.83261', '23.22281', 'Yuanyang', '1', 0);
INSERT INTO `hh_region` VALUES (532529, '红河县', 532500, '红河县', 3, '0873', '654400', '102.42059', '23.36767', 'Honghexian', '1', 0);
INSERT INTO `hh_region` VALUES (532530, '金平苗族瑶族傣族自治县', 532500, '金平', 3, '0873', '661500', '103.22651', '22.77959', 'Jinping', '1', 0);
INSERT INTO `hh_region` VALUES (532531, '绿春县', 532500, '绿春', 3, '0873', '662500', '102.39672', '22.99371', 'Lvchun', '1', 0);
INSERT INTO `hh_region` VALUES (532532, '河口瑶族自治县', 532500, '河口', 3, '0873', '661300', '103.93936', '22.52929', 'Hekou', '1', 0);
INSERT INTO `hh_region` VALUES (532600, '文山壮族苗族自治州', 530000, '文山', 2, '0876', '663000', '104.24401', '23.36951', 'Wenshan', '1', 0);
INSERT INTO `hh_region` VALUES (532601, '文山市', 532600, '文山', 3, '0876', '663000', '104.244277', '23.369216', 'Wenshan', '1', 0);
INSERT INTO `hh_region` VALUES (532622, '砚山县', 532600, '砚山', 3, '0876', '663100', '104.33306', '23.60723', 'Yanshan', '1', 0);
INSERT INTO `hh_region` VALUES (532623, '西畴县', 532600, '西畴', 3, '0876', '663500', '104.67419', '23.43941', 'Xichou', '1', 0);
INSERT INTO `hh_region` VALUES (532624, '麻栗坡县', 532600, '麻栗坡', 3, '0876', '663600', '104.70132', '23.12028', 'Malipo', '1', 0);
INSERT INTO `hh_region` VALUES (532625, '马关县', 532600, '马关', 3, '0876', '663700', '104.39514', '23.01293', 'Maguan', '1', 0);
INSERT INTO `hh_region` VALUES (532626, '丘北县', 532600, '丘北', 3, '0876', '663200', '104.19256', '24.03957', 'Qiubei', '1', 0);
INSERT INTO `hh_region` VALUES (532627, '广南县', 532600, '广南', 3, '0876', '663300', '105.05511', '24.0464', 'Guangnan', '1', 0);
INSERT INTO `hh_region` VALUES (532628, '富宁县', 532600, '富宁', 3, '0876', '663400', '105.63085', '23.62536', 'Funing', '1', 0);
INSERT INTO `hh_region` VALUES (532800, '西双版纳傣族自治州', 530000, '西双版纳', 2, '0691', '666100', '100.797941', '22.001724', 'Xishuangbanna', '1', 0);
INSERT INTO `hh_region` VALUES (532801, '景洪市', 532800, '景洪', 3, '0691', '666100', '100.79977', '22.01071', 'Jinghong', '1', 0);
INSERT INTO `hh_region` VALUES (532822, '勐海县', 532800, '勐海', 3, '0691', '666200', '100.44931', '21.96175', 'Menghai', '1', 0);
INSERT INTO `hh_region` VALUES (532823, '勐腊县', 532800, '勐腊', 3, '0691', '666300', '101.56488', '21.48162', 'Mengla', '1', 0);
INSERT INTO `hh_region` VALUES (532900, '大理白族自治州', 530000, '大理', 2, '0872', '671000', '100.240037', '25.592765', 'Dali', '1', 0);
INSERT INTO `hh_region` VALUES (532901, '大理市', 532900, '大理', 3, '0872', '671000', '100.22998', '25.59157', 'Dali', '1', 0);
INSERT INTO `hh_region` VALUES (532922, '漾濞彝族自治县', 532900, '漾濞', 3, '0872', '672500', '99.95474', '25.6652', 'Yangbi', '1', 0);
INSERT INTO `hh_region` VALUES (532923, '祥云县', 532900, '祥云', 3, '0872', '672100', '100.55761', '25.47342', 'Xiangyun', '1', 0);
INSERT INTO `hh_region` VALUES (532924, '宾川县', 532900, '宾川', 3, '0872', '671600', '100.57666', '25.83144', 'Binchuan', '1', 0);
INSERT INTO `hh_region` VALUES (532925, '弥渡县', 532900, '弥渡', 3, '0872', '675600', '100.49075', '25.34179', 'Midu', '1', 0);
INSERT INTO `hh_region` VALUES (532926, '南涧彝族自治县', 532900, '南涧', 3, '0872', '675700', '100.50964', '25.04349', 'Nanjian', '1', 0);
INSERT INTO `hh_region` VALUES (532927, '巍山彝族回族自治县', 532900, '巍山', 3, '0872', '672400', '100.30612', '25.23197', 'Weishan', '1', 0);
INSERT INTO `hh_region` VALUES (532928, '永平县', 532900, '永平', 3, '0872', '672600', '99.54095', '25.46451', 'Yongping', '1', 0);
INSERT INTO `hh_region` VALUES (532929, '云龙县', 532900, '云龙', 3, '0872', '672700', '99.37255', '25.88505', 'Yunlong', '1', 0);
INSERT INTO `hh_region` VALUES (532930, '洱源县', 532900, '洱源', 3, '0872', '671200', '99.94903', '26.10829', 'Eryuan', '1', 0);
INSERT INTO `hh_region` VALUES (532931, '剑川县', 532900, '剑川', 3, '0872', '671300', '99.90545', '26.53688', 'Jianchuan', '1', 0);
INSERT INTO `hh_region` VALUES (532932, '鹤庆县', 532900, '鹤庆', 3, '0872', '671500', '100.17697', '26.55798', 'Heqing', '1', 0);
INSERT INTO `hh_region` VALUES (533100, '德宏傣族景颇族自治州', 530000, '德宏', 2, '0692', '678400', '98.578363', '24.436694', 'Dehong', '1', 0);
INSERT INTO `hh_region` VALUES (533102, '瑞丽市', 533100, '瑞丽', 3, '0692', '678600', '97.85183', '24.01277', 'Ruili', '1', 0);
INSERT INTO `hh_region` VALUES (533103, '芒市', 533100, '芒市', 3, '0692', '678400', '98.588641', '24.433735', 'Mangshi', '1', 0);
INSERT INTO `hh_region` VALUES (533122, '梁河县', 533100, '梁河', 3, '0692', '679200', '98.29705', '24.80658', 'Lianghe', '1', 0);
INSERT INTO `hh_region` VALUES (533123, '盈江县', 533100, '盈江', 3, '0692', '679300', '97.93179', '24.70579', 'Yingjiang', '1', 0);
INSERT INTO `hh_region` VALUES (533124, '陇川县', 533100, '陇川', 3, '0692', '678700', '97.79199', '24.18302', 'Longchuan', '1', 0);
INSERT INTO `hh_region` VALUES (533300, '怒江傈僳族自治州', 530000, '怒江', 2, '0886', '673100', '98.854304', '25.850949', 'Nujiang', '1', 0);
INSERT INTO `hh_region` VALUES (533321, '泸水县', 533300, '泸水', 3, '0886', '673100', '98.85534', '25.83772', 'Lushui', '1', 0);
INSERT INTO `hh_region` VALUES (533323, '福贡县', 533300, '福贡', 3, '0886', '673400', '98.86969', '26.90366', 'Fugong', '1', 0);
INSERT INTO `hh_region` VALUES (533324, '贡山独龙族怒族自治县', 533300, '贡山', 3, '0886', '673500', '98.66583', '27.74088', 'Gongshan', '1', 0);
INSERT INTO `hh_region` VALUES (533325, '兰坪白族普米族自治县', 533300, '兰坪', 3, '0886', '671400', '99.41891', '26.45251', 'Lanping', '1', 0);
INSERT INTO `hh_region` VALUES (533400, '迪庆藏族自治州', 530000, '迪庆', 2, '0887', '674400', '99.706463', '27.826853', 'Deqen', '1', 0);
INSERT INTO `hh_region` VALUES (533421, '香格里拉市', 533400, '香格里拉', 3, '0887', '674400', '99.70601', '27.82308', 'Xianggelila', '1', 0);
INSERT INTO `hh_region` VALUES (533422, '德钦县', 533400, '德钦', 3, '0887', '674500', '98.91082', '28.4863', 'Deqin', '1', 0);
INSERT INTO `hh_region` VALUES (533423, '维西傈僳族自治县', 533400, '维西', 3, '0887', '674600', '99.28402', '27.1793', 'Weixi', '1', 0);
INSERT INTO `hh_region` VALUES (540000, '西藏自治区', 100000, '西藏', 1, '', '', '91.132212', '29.660361', 'Tibet', '1', 0);
INSERT INTO `hh_region` VALUES (540100, '拉萨市', 540000, '拉萨', 2, '0891', '850000', '91.132212', '29.660361', 'Lhasa', '1', 0);
INSERT INTO `hh_region` VALUES (540102, '城关区', 540100, '城关', 3, '0891', '850000', '91.13859', '29.65312', 'Chengguan', '1', 0);
INSERT INTO `hh_region` VALUES (540121, '林周县', 540100, '林周', 3, '0891', '851600', '91.2586', '29.89445', 'Linzhou', '1', 0);
INSERT INTO `hh_region` VALUES (540122, '当雄县', 540100, '当雄', 3, '0891', '851500', '91.10076', '30.48309', 'Dangxiong', '1', 0);
INSERT INTO `hh_region` VALUES (540123, '尼木县', 540100, '尼木', 3, '0891', '851300', '90.16378', '29.43353', 'Nimu', '1', 0);
INSERT INTO `hh_region` VALUES (540124, '曲水县', 540100, '曲水', 3, '0891', '850600', '90.73187', '29.35636', 'Qushui', '1', 0);
INSERT INTO `hh_region` VALUES (540125, '堆龙德庆县', 540100, '堆龙德庆', 3, '0891', '851400', '91.00033', '29.65002', 'Duilongdeqing', '1', 0);
INSERT INTO `hh_region` VALUES (540126, '达孜县', 540100, '达孜', 3, '0891', '850100', '91.35757', '29.6722', 'Dazi', '1', 0);
INSERT INTO `hh_region` VALUES (540127, '墨竹工卡县', 540100, '墨竹工卡', 3, '0891', '850200', '91.72814', '29.83614', 'Mozhugongka', '1', 0);
INSERT INTO `hh_region` VALUES (540200, '日喀则市', 540000, '日喀则', 2, '0892', '857000', '88.884874', '29.263792', 'Rikaze', '1', 0);
INSERT INTO `hh_region` VALUES (540202, '桑珠孜区', 540200, '桑珠孜', 3, '0892', '857000', '88.880367', '29.269565', 'Sangzhuzi', '1', 0);
INSERT INTO `hh_region` VALUES (540221, '南木林县', 540200, '南木林', 3, '0892', '857100', '89.09686', '29.68206', 'Nanmulin', '1', 0);
INSERT INTO `hh_region` VALUES (540222, '江孜县', 540200, '江孜', 3, '0892', '857400', '89.60263', '28.91744', 'Jiangzi', '1', 0);
INSERT INTO `hh_region` VALUES (540223, '定日县', 540200, '定日', 3, '0892', '858200', '87.12176', '28.66129', 'Dingri', '1', 0);
INSERT INTO `hh_region` VALUES (540224, '萨迦县', 540200, '萨迦', 3, '0892', '857800', '88.02191', '28.90299', 'Sajia', '1', 0);
INSERT INTO `hh_region` VALUES (540225, '拉孜县', 540200, '拉孜', 3, '0892', '858100', '87.63412', '29.085', 'Lazi', '1', 0);
INSERT INTO `hh_region` VALUES (540226, '昂仁县', 540200, '昂仁', 3, '0892', '858500', '87.23858', '29.29496', 'Angren', '1', 0);
INSERT INTO `hh_region` VALUES (540227, '谢通门县', 540200, '谢通门', 3, '0892', '858900', '88.26242', '29.43337', 'Xietongmen', '1', 0);
INSERT INTO `hh_region` VALUES (540228, '白朗县', 540200, '白朗', 3, '0892', '857300', '89.26205', '29.10553', 'Bailang', '1', 0);
INSERT INTO `hh_region` VALUES (540229, '仁布县', 540200, '仁布', 3, '0892', '857200', '89.84228', '29.2301', 'Renbu', '1', 0);
INSERT INTO `hh_region` VALUES (540230, '康马县', 540200, '康马', 3, '0892', '857500', '89.68527', '28.5567', 'Kangma', '1', 0);
INSERT INTO `hh_region` VALUES (540231, '定结县', 540200, '定结', 3, '0892', '857900', '87.77255', '28.36403', 'Dingjie', '1', 0);
INSERT INTO `hh_region` VALUES (540232, '仲巴县', 540200, '仲巴', 3, '0892', '858800', '84.02951', '29.76595', 'Zhongba', '1', 0);
INSERT INTO `hh_region` VALUES (540233, '亚东县', 540200, '亚东', 3, '0892', '857600', '88.90802', '27.4839', 'Yadong', '1', 0);
INSERT INTO `hh_region` VALUES (540234, '吉隆县', 540200, '吉隆', 3, '0892', '858700', '85.29846', '28.85382', 'Jilong', '1', 0);
INSERT INTO `hh_region` VALUES (540235, '聂拉木县', 540200, '聂拉木', 3, '0892', '858300', '85.97998', '28.15645', 'Nielamu', '1', 0);
INSERT INTO `hh_region` VALUES (540236, '萨嘎县', 540200, '萨嘎', 3, '0892', '857800', '85.23413', '29.32936', 'Saga', '1', 0);
INSERT INTO `hh_region` VALUES (540237, '岗巴县', 540200, '岗巴', 3, '0892', '857700', '88.52069', '28.27504', 'Gangba', '1', 0);
INSERT INTO `hh_region` VALUES (540300, '昌都市', 540000, '昌都', 2, '0895', '854000', '97.178452', '31.136875', 'Qamdo', '1', 0);
INSERT INTO `hh_region` VALUES (540302, '卡若区', 540300, '昌都', 3, '0895', '854000', '97.18043', '31.1385', 'Karuo', '1', 0);
INSERT INTO `hh_region` VALUES (540321, '江达县', 540300, '江达', 3, '0895', '854100', '98.21865', '31.50343', 'Jiangda', '1', 0);
INSERT INTO `hh_region` VALUES (540322, '贡觉县', 540300, '贡觉', 3, '0895', '854200', '98.27163', '30.85941', 'Gongjue', '1', 0);
INSERT INTO `hh_region` VALUES (540323, '类乌齐县', 540300, '类乌齐', 3, '0895', '855600', '96.60015', '31.21207', 'Leiwuqi', '1', 0);
INSERT INTO `hh_region` VALUES (540324, '丁青县', 540300, '丁青', 3, '0895', '855700', '95.59362', '31.41621', 'Dingqing', '1', 0);
INSERT INTO `hh_region` VALUES (540325, '察雅县', 540300, '察雅', 3, '0895', '854300', '97.56521', '30.65336', 'Chaya', '1', 0);
INSERT INTO `hh_region` VALUES (540326, '八宿县', 540300, '八宿', 3, '0895', '854600', '96.9176', '30.05346', 'Basu', '1', 0);
INSERT INTO `hh_region` VALUES (540327, '左贡县', 540300, '左贡', 3, '0895', '854400', '97.84429', '29.67108', 'Zuogong', '1', 0);
INSERT INTO `hh_region` VALUES (540328, '芒康县', 540300, '芒康', 3, '0895', '854500', '98.59378', '29.67946', 'Mangkang', '1', 0);
INSERT INTO `hh_region` VALUES (540329, '洛隆县', 540300, '洛隆', 3, '0895', '855400', '95.82644', '30.74049', 'Luolong', '1', 0);
INSERT INTO `hh_region` VALUES (540330, '边坝县', 540300, '边坝', 3, '0895', '855500', '94.70687', '30.93434', 'Bianba', '1', 0);
INSERT INTO `hh_region` VALUES (542200, '山南地区', 540000, '山南', 2, '0893', '856000', '91.766529', '29.236023', 'Shannan', '1', 0);
INSERT INTO `hh_region` VALUES (542221, '乃东县', 542200, '乃东', 3, '0893', '856100', '91.76153', '29.2249', 'Naidong', '1', 0);
INSERT INTO `hh_region` VALUES (542222, '扎囊县', 542200, '扎囊', 3, '0893', '850800', '91.33288', '29.2399', 'Zhanang', '1', 0);
INSERT INTO `hh_region` VALUES (542223, '贡嘎县', 542200, '贡嘎', 3, '0893', '850700', '90.98867', '29.29408', 'Gongga', '1', 0);
INSERT INTO `hh_region` VALUES (542224, '桑日县', 542200, '桑日', 3, '0893', '856200', '92.02005', '29.26643', 'Sangri', '1', 0);
INSERT INTO `hh_region` VALUES (542225, '琼结县', 542200, '琼结', 3, '0893', '856800', '91.68093', '29.02632', 'Qiongjie', '1', 0);
INSERT INTO `hh_region` VALUES (542226, '曲松县', 542200, '曲松', 3, '0893', '856300', '92.20263', '29.06412', 'Qusong', '1', 0);
INSERT INTO `hh_region` VALUES (542227, '措美县', 542200, '措美', 3, '0893', '856900', '91.43237', '28.43794', 'Cuomei', '1', 0);
INSERT INTO `hh_region` VALUES (542228, '洛扎县', 542200, '洛扎', 3, '0893', '856600', '90.86035', '28.3872', 'Luozha', '1', 0);
INSERT INTO `hh_region` VALUES (542229, '加查县', 542200, '加查', 3, '0893', '856400', '92.57702', '29.13973', 'Jiacha', '1', 0);
INSERT INTO `hh_region` VALUES (542231, '隆子县', 542200, '隆子', 3, '0893', '856600', '92.46148', '28.40797', 'Longzi', '1', 0);
INSERT INTO `hh_region` VALUES (542232, '错那县', 542200, '错那', 3, '0893', '856700', '91.95752', '27.99224', 'Cuona', '1', 0);
INSERT INTO `hh_region` VALUES (542233, '浪卡子县', 542200, '浪卡子', 3, '0893', '851100', '90.40002', '28.96948', 'Langkazi', '1', 0);
INSERT INTO `hh_region` VALUES (542400, '那曲地区', 540000, '那曲', 2, '0896', '852000', '92.060214', '31.476004', 'Nagqu', '1', 0);
INSERT INTO `hh_region` VALUES (542421, '那曲县', 542400, '那曲', 3, '0896', '852000', '92.0535', '31.46964', 'Naqu', '1', 0);
INSERT INTO `hh_region` VALUES (542422, '嘉黎县', 542400, '嘉黎', 3, '0896', '852400', '93.24987', '30.64233', 'Jiali', '1', 0);
INSERT INTO `hh_region` VALUES (542423, '比如县', 542400, '比如', 3, '0896', '852300', '93.68685', '31.4779', 'Biru', '1', 0);
INSERT INTO `hh_region` VALUES (542424, '聂荣县', 542400, '聂荣', 3, '0896', '853500', '92.29574', '32.11193', 'Nierong', '1', 0);
INSERT INTO `hh_region` VALUES (542425, '安多县', 542400, '安多', 3, '0896', '853400', '91.6795', '32.26125', 'Anduo', '1', 0);
INSERT INTO `hh_region` VALUES (542426, '申扎县', 542400, '申扎', 3, '0896', '853100', '88.70776', '30.92995', 'Shenzha', '1', 0);
INSERT INTO `hh_region` VALUES (542427, '索县', 542400, '索县', 3, '0896', '852200', '93.78295', '31.88427', 'Suoxian', '1', 0);
INSERT INTO `hh_region` VALUES (542428, '班戈县', 542400, '班戈', 3, '0896', '852500', '90.01907', '31.36149', 'Bange', '1', 0);
INSERT INTO `hh_region` VALUES (542429, '巴青县', 542400, '巴青', 3, '0896', '852100', '94.05316', '31.91833', 'Baqing', '1', 0);
INSERT INTO `hh_region` VALUES (542430, '尼玛县', 542400, '尼玛', 3, '0896', '852600', '87.25256', '31.79654', 'Nima', '1', 0);
INSERT INTO `hh_region` VALUES (542431, '双湖县', 542400, '双湖', 3, '0896', '852600', '88.837776', '33.189032', 'Shuanghu', '1', 0);
INSERT INTO `hh_region` VALUES (542500, '阿里地区', 540000, '阿里', 2, '0897', '859000', '80.105498', '32.503187', 'Ngari', '1', 0);
INSERT INTO `hh_region` VALUES (542521, '普兰县', 542500, '普兰', 3, '0897', '859500', '81.177', '30.30002', 'Pulan', '1', 0);
INSERT INTO `hh_region` VALUES (542522, '札达县', 542500, '札达', 3, '0897', '859600', '79.80255', '31.48345', 'Zhada', '1', 0);
INSERT INTO `hh_region` VALUES (542523, '噶尔县', 542500, '噶尔', 3, '0897', '859400', '80.09579', '32.50024', 'Gaer', '1', 0);
INSERT INTO `hh_region` VALUES (542524, '日土县', 542500, '日土', 3, '0897', '859700', '79.7131', '33.38741', 'Ritu', '1', 0);
INSERT INTO `hh_region` VALUES (542525, '革吉县', 542500, '革吉', 3, '0897', '859100', '81.151', '32.3964', 'Geji', '1', 0);
INSERT INTO `hh_region` VALUES (542526, '改则县', 542500, '改则', 3, '0897', '859200', '84.06295', '32.30446', 'Gaize', '1', 0);
INSERT INTO `hh_region` VALUES (542527, '措勤县', 542500, '措勤', 3, '0897', '859300', '85.16616', '31.02095', 'Cuoqin', '1', 0);
INSERT INTO `hh_region` VALUES (542600, '林芝地区', 540000, '林芝', 2, '0894', '850400', '94.362348', '29.654693', 'Nyingchi', '1', 0);
INSERT INTO `hh_region` VALUES (542621, '林芝县', 542600, '林芝', 3, '0894', '850400', '94.48391', '29.57562', 'Linzhi', '1', 0);
INSERT INTO `hh_region` VALUES (542622, '工布江达县', 542600, '工布江达', 3, '0894', '850300', '93.2452', '29.88576', 'Gongbujiangda', '1', 0);
INSERT INTO `hh_region` VALUES (542623, '米林县', 542600, '米林', 3, '0894', '850500', '94.21316', '29.21535', 'Milin', '1', 0);
INSERT INTO `hh_region` VALUES (542624, '墨脱县', 542600, '墨脱', 3, '0894', '855300', '95.3316', '29.32698', 'Motuo', '1', 0);
INSERT INTO `hh_region` VALUES (542625, '波密县', 542600, '波密', 3, '0894', '855200', '95.77096', '29.85907', 'Bomi', '1', 0);
INSERT INTO `hh_region` VALUES (542626, '察隅县', 542600, '察隅', 3, '0894', '855100', '97.46679', '28.6618', 'Chayu', '1', 0);
INSERT INTO `hh_region` VALUES (542627, '朗县', 542600, '朗县', 3, '0894', '856500', '93.0754', '29.04549', 'Langxian', '1', 0);
INSERT INTO `hh_region` VALUES (610000, '陕西省', 100000, '陕西', 1, '', '', '108.948024', '34.263161', 'Shaanxi', '1', 0);
INSERT INTO `hh_region` VALUES (610100, '西安市', 610000, '西安', 2, '029', '710003', '108.948024', '34.263161', 'Xi\'an', '1', 0);
INSERT INTO `hh_region` VALUES (610102, '新城区', 610100, '新城', 3, '029', '710004', '108.9608', '34.26641', 'Xincheng', '1', 0);
INSERT INTO `hh_region` VALUES (610103, '碑林区', 610100, '碑林', 3, '029', '710001', '108.93426', '34.2304', 'Beilin', '1', 0);
INSERT INTO `hh_region` VALUES (610104, '莲湖区', 610100, '莲湖', 3, '029', '710003', '108.9401', '34.26709', 'Lianhu', '1', 0);
INSERT INTO `hh_region` VALUES (610111, '灞桥区', 610100, '灞桥', 3, '029', '710038', '109.06451', '34.27264', 'Baqiao', '1', 0);
INSERT INTO `hh_region` VALUES (610112, '未央区', 610100, '未央', 3, '029', '710014', '108.94683', '34.29296', 'Weiyang', '1', 0);
INSERT INTO `hh_region` VALUES (610113, '雁塔区', 610100, '雁塔', 3, '029', '710061', '108.94866', '34.22245', 'Yanta', '1', 0);
INSERT INTO `hh_region` VALUES (610114, '阎良区', 610100, '阎良', 3, '029', '710087', '109.22616', '34.66221', 'Yanliang', '1', 0);
INSERT INTO `hh_region` VALUES (610115, '临潼区', 610100, '临潼', 3, '029', '710600', '109.21417', '34.36665', 'Lintong', '1', 0);
INSERT INTO `hh_region` VALUES (610116, '长安区', 610100, '长安', 3, '029', '710100', '108.94586', '34.15559', 'Chang\'an', '1', 0);
INSERT INTO `hh_region` VALUES (610122, '蓝田县', 610100, '蓝田', 3, '029', '710500', '109.32339', '34.15128', 'Lantian', '1', 0);
INSERT INTO `hh_region` VALUES (610124, '周至县', 610100, '周至', 3, '029', '710400', '108.22207', '34.16337', 'Zhouzhi', '1', 0);
INSERT INTO `hh_region` VALUES (610125, '户县', 610100, '户县', 3, '029', '710300', '108.60513', '34.10856', 'Huxian', '1', 0);
INSERT INTO `hh_region` VALUES (610126, '高陵区', 610100, '高陵', 3, '029', '710200', '109.08816', '34.53483', 'Gaoling', '1', 0);
INSERT INTO `hh_region` VALUES (610200, '铜川市', 610000, '铜川', 2, '0919', '727100', '108.963122', '34.90892', 'Tongchuan', '1', 0);
INSERT INTO `hh_region` VALUES (610202, '王益区', 610200, '王益', 3, '0919', '727000', '109.07564', '35.06896', 'Wangyi', '1', 0);
INSERT INTO `hh_region` VALUES (610203, '印台区', 610200, '印台', 3, '0919', '727007', '109.10208', '35.1169', 'Yintai', '1', 0);
INSERT INTO `hh_region` VALUES (610204, '耀州区', 610200, '耀州', 3, '0919', '727100', '108.98556', '34.91308', 'Yaozhou', '1', 0);
INSERT INTO `hh_region` VALUES (610222, '宜君县', 610200, '宜君', 3, '0919', '727200', '109.11813', '35.40108', 'Yijun', '1', 0);
INSERT INTO `hh_region` VALUES (610300, '宝鸡市', 610000, '宝鸡', 2, '0917', '721000', '107.14487', '34.369315', 'Baoji', '1', 0);
INSERT INTO `hh_region` VALUES (610302, '渭滨区', 610300, '渭滨', 3, '0917', '721000', '107.14991', '34.37116', 'Weibin', '1', 0);
INSERT INTO `hh_region` VALUES (610303, '金台区', 610300, '金台', 3, '0917', '721000', '107.14691', '34.37612', 'Jintai', '1', 0);
INSERT INTO `hh_region` VALUES (610304, '陈仓区', 610300, '陈仓', 3, '0917', '721300', '107.38742', '34.35451', 'Chencang', '1', 0);
INSERT INTO `hh_region` VALUES (610322, '凤翔县', 610300, '凤翔', 3, '0917', '721400', '107.39645', '34.52321', 'Fengxiang', '1', 0);
INSERT INTO `hh_region` VALUES (610323, '岐山县', 610300, '岐山', 3, '0917', '722400', '107.62173', '34.44378', 'Qishan', '1', 0);
INSERT INTO `hh_region` VALUES (610324, '扶风县', 610300, '扶风', 3, '0917', '722200', '107.90017', '34.37524', 'Fufeng', '1', 0);
INSERT INTO `hh_region` VALUES (610326, '眉县', 610300, '眉县', 3, '0917', '722300', '107.75079', '34.27569', 'Meixian', '1', 0);
INSERT INTO `hh_region` VALUES (610327, '陇县', 610300, '陇县', 3, '0917', '721200', '106.85946', '34.89404', 'Longxian', '1', 0);
INSERT INTO `hh_region` VALUES (610328, '千阳县', 610300, '千阳', 3, '0917', '721100', '107.13043', '34.64219', 'Qianyang', '1', 0);
INSERT INTO `hh_region` VALUES (610329, '麟游县', 610300, '麟游', 3, '0917', '721500', '107.79623', '34.67844', 'Linyou', '1', 0);
INSERT INTO `hh_region` VALUES (610330, '凤县', 610300, '凤县', 3, '0917', '721700', '106.52356', '33.91172', 'Fengxian', '1', 0);
INSERT INTO `hh_region` VALUES (610331, '太白县', 610300, '太白', 3, '0917', '721600', '107.31646', '34.06207', 'Taibai', '1', 0);
INSERT INTO `hh_region` VALUES (610400, '咸阳市', 610000, '咸阳', 2, '029', '712000', '108.705117', '34.333439', 'Xianyang', '1', 0);
INSERT INTO `hh_region` VALUES (610402, '秦都区', 610400, '秦都', 3, '029', '712000', '108.71493', '34.33804', 'Qindu', '1', 0);
INSERT INTO `hh_region` VALUES (610403, '杨陵区', 610400, '杨陵', 3, '029', '712100', '108.083481', '34.270434', 'Yangling', '1', 0);
INSERT INTO `hh_region` VALUES (610404, '渭城区', 610400, '渭城', 3, '029', '712000', '108.72227', '34.33198', 'Weicheng', '1', 0);
INSERT INTO `hh_region` VALUES (610422, '三原县', 610400, '三原', 3, '029', '713800', '108.93194', '34.61556', 'Sanyuan', '1', 0);
INSERT INTO `hh_region` VALUES (610423, '泾阳县', 610400, '泾阳', 3, '029', '713700', '108.84259', '34.52705', 'Jingyang', '1', 0);
INSERT INTO `hh_region` VALUES (610424, '乾县', 610400, '乾县', 3, '029', '713300', '108.24231', '34.52946', 'Qianxian', '1', 0);
INSERT INTO `hh_region` VALUES (610425, '礼泉县', 610400, '礼泉', 3, '029', '713200', '108.4263', '34.48455', 'Liquan', '1', 0);
INSERT INTO `hh_region` VALUES (610426, '永寿县', 610400, '永寿', 3, '029', '713400', '108.14474', '34.69081', 'Yongshou', '1', 0);
INSERT INTO `hh_region` VALUES (610427, '彬县', 610400, '彬县', 3, '029', '713500', '108.08468', '35.0342', 'Binxian', '1', 0);
INSERT INTO `hh_region` VALUES (610428, '长武县', 610400, '长武', 3, '029', '713600', '107.7951', '35.2067', 'Changwu', '1', 0);
INSERT INTO `hh_region` VALUES (610429, '旬邑县', 610400, '旬邑', 3, '029', '711300', '108.3341', '35.11338', 'Xunyi', '1', 0);
INSERT INTO `hh_region` VALUES (610430, '淳化县', 610400, '淳化', 3, '029', '711200', '108.58026', '34.79886', 'Chunhua', '1', 0);
INSERT INTO `hh_region` VALUES (610431, '武功县', 610400, '武功', 3, '029', '712200', '108.20434', '34.26003', 'Wugong', '1', 0);
INSERT INTO `hh_region` VALUES (610481, '兴平市', 610400, '兴平', 3, '029', '713100', '108.49057', '34.29785', 'Xingping', '1', 0);
INSERT INTO `hh_region` VALUES (610500, '渭南市', 610000, '渭南', 2, '0913', '714000', '109.502882', '34.499381', 'Weinan', '1', 0);
INSERT INTO `hh_region` VALUES (610502, '临渭区', 610500, '临渭', 3, '0913', '714000', '109.49296', '34.49822', 'Linwei', '1', 0);
INSERT INTO `hh_region` VALUES (610521, '华县', 610500, '华县', 3, '0913', '714100', '109.77185', '34.51255', 'Huaxian', '1', 0);
INSERT INTO `hh_region` VALUES (610522, '潼关县', 610500, '潼关', 3, '0913', '714300', '110.24362', '34.54284', 'Tongguan', '1', 0);
INSERT INTO `hh_region` VALUES (610523, '大荔县', 610500, '大荔', 3, '0913', '715100', '109.94216', '34.79565', 'Dali', '1', 0);
INSERT INTO `hh_region` VALUES (610524, '合阳县', 610500, '合阳', 3, '0913', '715300', '110.14862', '35.23805', 'Heyang', '1', 0);
INSERT INTO `hh_region` VALUES (610525, '澄城县', 610500, '澄城', 3, '0913', '715200', '109.93444', '35.18396', 'Chengcheng', '1', 0);
INSERT INTO `hh_region` VALUES (610526, '蒲城县', 610500, '蒲城', 3, '0913', '715500', '109.5903', '34.9568', 'Pucheng', '1', 0);
INSERT INTO `hh_region` VALUES (610527, '白水县', 610500, '白水', 3, '0913', '715600', '109.59286', '35.17863', 'Baishui', '1', 0);
INSERT INTO `hh_region` VALUES (610528, '富平县', 610500, '富平', 3, '0913', '711700', '109.1802', '34.75109', 'Fuping', '1', 0);
INSERT INTO `hh_region` VALUES (610581, '韩城市', 610500, '韩城', 3, '0913', '715400', '110.44238', '35.47926', 'Hancheng', '1', 0);
INSERT INTO `hh_region` VALUES (610582, '华阴市', 610500, '华阴', 3, '0913', '714200', '110.08752', '34.56608', 'Huayin', '1', 0);
INSERT INTO `hh_region` VALUES (610600, '延安市', 610000, '延安', 2, '0911', '716000', '109.49081', '36.596537', 'Yan\'an', '1', 0);
INSERT INTO `hh_region` VALUES (610602, '宝塔区', 610600, '宝塔', 3, '0911', '716000', '109.49336', '36.59154', 'Baota', '1', 0);
INSERT INTO `hh_region` VALUES (610621, '延长县', 610600, '延长', 3, '0911', '717100', '110.01083', '36.57904', 'Yanchang', '1', 0);
INSERT INTO `hh_region` VALUES (610622, '延川县', 610600, '延川', 3, '0911', '717200', '110.19415', '36.87817', 'Yanchuan', '1', 0);
INSERT INTO `hh_region` VALUES (610623, '子长县', 610600, '子长', 3, '0911', '717300', '109.67532', '37.14253', 'Zichang', '1', 0);
INSERT INTO `hh_region` VALUES (610624, '安塞县', 610600, '安塞', 3, '0911', '717400', '109.32708', '36.86507', 'Ansai', '1', 0);
INSERT INTO `hh_region` VALUES (610625, '志丹县', 610600, '志丹', 3, '0911', '717500', '108.76815', '36.82177', 'Zhidan', '1', 0);
INSERT INTO `hh_region` VALUES (610626, '吴起县', 610600, '吴起', 3, '0911', '717600', '108.17611', '36.92785', 'Wuqi', '1', 0);
INSERT INTO `hh_region` VALUES (610627, '甘泉县', 610600, '甘泉', 3, '0911', '716100', '109.35012', '36.27754', 'Ganquan', '1', 0);
INSERT INTO `hh_region` VALUES (610628, '富县', 610600, '富县', 3, '0911', '727500', '109.37927', '35.98803', 'Fuxian', '1', 0);
INSERT INTO `hh_region` VALUES (610629, '洛川县', 610600, '洛川', 3, '0911', '727400', '109.43286', '35.76076', 'Luochuan', '1', 0);
INSERT INTO `hh_region` VALUES (610630, '宜川县', 610600, '宜川', 3, '0911', '716200', '110.17196', '36.04732', 'Yichuan', '1', 0);
INSERT INTO `hh_region` VALUES (610631, '黄龙县', 610600, '黄龙', 3, '0911', '715700', '109.84259', '35.58349', 'Huanglong', '1', 0);
INSERT INTO `hh_region` VALUES (610632, '黄陵县', 610600, '黄陵', 3, '0911', '727300', '109.26333', '35.58357', 'Huangling', '1', 0);
INSERT INTO `hh_region` VALUES (610700, '汉中市', 610000, '汉中', 2, '0916', '723000', '107.028621', '33.077668', 'Hanzhong', '1', 0);
INSERT INTO `hh_region` VALUES (610702, '汉台区', 610700, '汉台', 3, '0916', '723000', '107.03187', '33.06774', 'Hantai', '1', 0);
INSERT INTO `hh_region` VALUES (610721, '南郑县', 610700, '南郑', 3, '0916', '723100', '106.94024', '33.00299', 'Nanzheng', '1', 0);
INSERT INTO `hh_region` VALUES (610722, '城固县', 610700, '城固', 3, '0916', '723200', '107.33367', '33.15661', 'Chenggu', '1', 0);
INSERT INTO `hh_region` VALUES (610723, '洋县', 610700, '洋县', 3, '0916', '723300', '107.54672', '33.22102', 'Yangxian', '1', 0);
INSERT INTO `hh_region` VALUES (610724, '西乡县', 610700, '西乡', 3, '0916', '723500', '107.76867', '32.98411', 'Xixiang', '1', 0);
INSERT INTO `hh_region` VALUES (610725, '勉县', 610700, '勉县', 3, '0916', '724200', '106.67584', '33.15273', 'Mianxian', '1', 0);
INSERT INTO `hh_region` VALUES (610726, '宁强县', 610700, '宁强', 3, '0916', '724400', '106.25958', '32.82881', 'Ningqiang', '1', 0);
INSERT INTO `hh_region` VALUES (610727, '略阳县', 610700, '略阳', 3, '0916', '724300', '106.15399', '33.33009', 'Lueyang', '1', 0);
INSERT INTO `hh_region` VALUES (610728, '镇巴县', 610700, '镇巴', 3, '0916', '723600', '107.89648', '32.53487', 'Zhenba', '1', 0);
INSERT INTO `hh_region` VALUES (610729, '留坝县', 610700, '留坝', 3, '0916', '724100', '106.92233', '33.61606', 'Liuba', '1', 0);
INSERT INTO `hh_region` VALUES (610730, '佛坪县', 610700, '佛坪', 3, '0916', '723400', '107.98974', '33.52496', 'Foping', '1', 0);
INSERT INTO `hh_region` VALUES (610800, '榆林市', 610000, '榆林', 2, '0912', '719000', '109.741193', '38.290162', 'Yulin', '1', 0);
INSERT INTO `hh_region` VALUES (610802, '榆阳区', 610800, '榆阳', 3, '0912', '719000', '109.73473', '38.27843', 'Yuyang', '1', 0);
INSERT INTO `hh_region` VALUES (610821, '神木县', 610800, '神木', 3, '0912', '719300', '110.4989', '38.84234', 'Shenmu', '1', 0);
INSERT INTO `hh_region` VALUES (610822, '府谷县', 610800, '府谷', 3, '0912', '719400', '111.06723', '39.02805', 'Fugu', '1', 0);
INSERT INTO `hh_region` VALUES (610823, '横山县', 610800, '横山', 3, '0912', '719100', '109.29568', '37.958', 'Hengshan', '1', 0);
INSERT INTO `hh_region` VALUES (610824, '靖边县', 610800, '靖边', 3, '0912', '718500', '108.79412', '37.59938', 'Jingbian', '1', 0);
INSERT INTO `hh_region` VALUES (610825, '定边县', 610800, '定边', 3, '0912', '718600', '107.59793', '37.59037', 'Dingbian', '1', 0);
INSERT INTO `hh_region` VALUES (610826, '绥德县', 610800, '绥德', 3, '0912', '718000', '110.26126', '37.49778', 'Suide', '1', 0);
INSERT INTO `hh_region` VALUES (610827, '米脂县', 610800, '米脂', 3, '0912', '718100', '110.18417', '37.75529', 'Mizhi', '1', 0);
INSERT INTO `hh_region` VALUES (610828, '佳县', 610800, '佳县', 3, '0912', '719200', '110.49362', '38.02248', 'Jiaxian', '1', 0);
INSERT INTO `hh_region` VALUES (610829, '吴堡县', 610800, '吴堡', 3, '0912', '718200', '110.74533', '37.45709', 'Wubu', '1', 0);
INSERT INTO `hh_region` VALUES (610830, '清涧县', 610800, '清涧', 3, '0912', '718300', '110.12173', '37.08854', 'Qingjian', '1', 0);
INSERT INTO `hh_region` VALUES (610831, '子洲县', 610800, '子洲', 3, '0912', '718400', '110.03488', '37.61238', 'Zizhou', '1', 0);
INSERT INTO `hh_region` VALUES (610900, '安康市', 610000, '安康', 2, '0915', '725000', '109.029273', '32.6903', 'Ankang', '1', 0);
INSERT INTO `hh_region` VALUES (610902, '汉滨区', 610900, '汉滨', 3, '0915', '725000', '109.02683', '32.69517', 'Hanbin', '1', 0);
INSERT INTO `hh_region` VALUES (610921, '汉阴县', 610900, '汉阴', 3, '0915', '725100', '108.51098', '32.89129', 'Hanyin', '1', 0);
INSERT INTO `hh_region` VALUES (610922, '石泉县', 610900, '石泉', 3, '0915', '725200', '108.24755', '33.03971', 'Shiquan', '1', 0);
INSERT INTO `hh_region` VALUES (610923, '宁陕县', 610900, '宁陕', 3, '0915', '711600', '108.31515', '33.31726', 'Ningshan', '1', 0);
INSERT INTO `hh_region` VALUES (610924, '紫阳县', 610900, '紫阳', 3, '0915', '725300', '108.5368', '32.52115', 'Ziyang', '1', 0);
INSERT INTO `hh_region` VALUES (610925, '岚皋县', 610900, '岚皋', 3, '0915', '725400', '108.90289', '32.30794', 'Langao', '1', 0);
INSERT INTO `hh_region` VALUES (610926, '平利县', 610900, '平利', 3, '0915', '725500', '109.35775', '32.39111', 'Pingli', '1', 0);
INSERT INTO `hh_region` VALUES (610927, '镇坪县', 610900, '镇坪', 3, '0915', '725600', '109.52456', '31.8833', 'Zhenping', '1', 0);
INSERT INTO `hh_region` VALUES (610928, '旬阳县', 610900, '旬阳', 3, '0915', '725700', '109.3619', '32.83207', 'Xunyang', '1', 0);
INSERT INTO `hh_region` VALUES (610929, '白河县', 610900, '白河', 3, '0915', '725800', '110.11315', '32.80955', 'Baihe', '1', 0);
INSERT INTO `hh_region` VALUES (611000, '商洛市', 610000, '商洛', 2, '0914', '726000', '109.939776', '33.868319', 'Shangluo', '1', 0);
INSERT INTO `hh_region` VALUES (611002, '商州区', 611000, '商州', 3, '0914', '726000', '109.94126', '33.8627', 'Shangzhou', '1', 0);
INSERT INTO `hh_region` VALUES (611021, '洛南县', 611000, '洛南', 3, '0914', '726100', '110.14645', '34.08994', 'Luonan', '1', 0);
INSERT INTO `hh_region` VALUES (611022, '丹凤县', 611000, '丹凤', 3, '0914', '726200', '110.33486', '33.69468', 'Danfeng', '1', 0);
INSERT INTO `hh_region` VALUES (611023, '商南县', 611000, '商南', 3, '0914', '726300', '110.88375', '33.52581', 'Shangnan', '1', 0);
INSERT INTO `hh_region` VALUES (611024, '山阳县', 611000, '山阳', 3, '0914', '726400', '109.88784', '33.52931', 'Shanyang', '1', 0);
INSERT INTO `hh_region` VALUES (611025, '镇安县', 611000, '镇安', 3, '0914', '711500', '109.15374', '33.42366', 'Zhen\'an', '1', 0);
INSERT INTO `hh_region` VALUES (611026, '柞水县', 611000, '柞水', 3, '0914', '711400', '109.11105', '33.6831', 'Zhashui', '1', 0);
INSERT INTO `hh_region` VALUES (611100, '西咸新区', 610000, '西咸', 2, '029', '712000', '108.810654', '34.307144', 'Xixian', '1', 0);
INSERT INTO `hh_region` VALUES (611101, '空港新城', 611100, '空港', 3, '0374', '461000', '108.760529', '34.440894', 'Konggang', '1', 0);
INSERT INTO `hh_region` VALUES (611102, '沣东新城', 611100, '沣东', 3, '029', '710000', '108.82988', '34.267431', 'Fengdong', '1', 0);
INSERT INTO `hh_region` VALUES (611103, '秦汉新城', 611100, '秦汉', 3, '029', '712000', '108.83812', '34.386513', 'Qinhan', '1', 0);
INSERT INTO `hh_region` VALUES (611104, '沣西新城', 611100, '沣西', 3, '029', '710000', '108.71215', '34.190453', 'Fengxi', '1', 0);
INSERT INTO `hh_region` VALUES (611105, '泾河新城', 611100, '泾河', 3, '029', '713700', '109.049603', '34.460587', 'Jinghe', '1', 0);
INSERT INTO `hh_region` VALUES (620000, '甘肃省', 100000, '甘肃', 1, '', '', '103.823557', '36.058039', 'Gansu', '1', 0);
INSERT INTO `hh_region` VALUES (620100, '兰州市', 620000, '兰州', 2, '0931', '730030', '103.823557', '36.058039', 'Lanzhou', '1', 0);
INSERT INTO `hh_region` VALUES (620102, '城关区', 620100, '城关', 3, '0931', '730030', '103.8252', '36.05725', 'Chengguan', '1', 0);
INSERT INTO `hh_region` VALUES (620103, '七里河区', 620100, '七里河', 3, '0931', '730050', '103.78564', '36.06585', 'Qilihe', '1', 0);
INSERT INTO `hh_region` VALUES (620104, '西固区', 620100, '西固', 3, '0931', '730060', '103.62811', '36.08858', 'Xigu', '1', 0);
INSERT INTO `hh_region` VALUES (620105, '安宁区', 620100, '安宁', 3, '0931', '730070', '103.7189', '36.10384', 'Anning', '1', 0);
INSERT INTO `hh_region` VALUES (620111, '红古区', 620100, '红古', 3, '0931', '730084', '102.85955', '36.34537', 'Honggu', '1', 0);
INSERT INTO `hh_region` VALUES (620121, '永登县', 620100, '永登', 3, '0931', '730300', '103.26055', '36.73522', 'Yongdeng', '1', 0);
INSERT INTO `hh_region` VALUES (620122, '皋兰县', 620100, '皋兰', 3, '0931', '730200', '103.94506', '36.33215', 'Gaolan', '1', 0);
INSERT INTO `hh_region` VALUES (620123, '榆中县', 620100, '榆中', 3, '0931', '730100', '104.1145', '35.84415', 'Yuzhong', '1', 0);
INSERT INTO `hh_region` VALUES (620200, '嘉峪关市', 620000, '嘉峪关', 2, '0937', '735100', '98.277304', '39.786529', 'Jiayuguan', '1', 0);
INSERT INTO `hh_region` VALUES (620201, '雄关区', 620200, '雄关', 3, '0937', '735100', '98.277398', '39.77925', 'Xiongguan', '1', 0);
INSERT INTO `hh_region` VALUES (620202, '长城区', 620200, '长城', 3, '0937', '735106', '98.273523', '39.787431', 'Changcheng', '1', 0);
INSERT INTO `hh_region` VALUES (620203, '镜铁区', 620200, '镜铁', 3, '0937', '735100', '98.277304', '39.786529', 'Jingtie', '1', 0);
INSERT INTO `hh_region` VALUES (620300, '金昌市', 620000, '金昌', 2, '0935', '737100', '102.187888', '38.514238', 'Jinchang', '1', 0);
INSERT INTO `hh_region` VALUES (620302, '金川区', 620300, '金川', 3, '0935', '737100', '102.19376', '38.52101', 'Jinchuan', '1', 0);
INSERT INTO `hh_region` VALUES (620321, '永昌县', 620300, '永昌', 3, '0935', '737200', '101.97222', '38.24711', 'Yongchang', '1', 0);
INSERT INTO `hh_region` VALUES (620400, '白银市', 620000, '白银', 2, '0943', '730900', '104.173606', '36.54568', 'Baiyin', '1', 0);
INSERT INTO `hh_region` VALUES (620402, '白银区', 620400, '白银', 3, '0943', '730900', '104.17355', '36.54411', 'Baiyin', '1', 0);
INSERT INTO `hh_region` VALUES (620403, '平川区', 620400, '平川', 3, '0943', '730913', '104.82498', '36.7277', 'Pingchuan', '1', 0);
INSERT INTO `hh_region` VALUES (620421, '靖远县', 620400, '靖远', 3, '0943', '730600', '104.68325', '36.56602', 'Jingyuan', '1', 0);
INSERT INTO `hh_region` VALUES (620422, '会宁县', 620400, '会宁', 3, '0943', '730700', '105.05297', '35.69626', 'Huining', '1', 0);
INSERT INTO `hh_region` VALUES (620423, '景泰县', 620400, '景泰', 3, '0943', '730400', '104.06295', '37.18359', 'Jingtai', '1', 0);
INSERT INTO `hh_region` VALUES (620500, '天水市', 620000, '天水', 2, '0938', '741000', '105.724998', '34.578529', 'Tianshui', '1', 0);
INSERT INTO `hh_region` VALUES (620502, '秦州区', 620500, '秦州', 3, '0938', '741000', '105.72421', '34.58089', 'Qinzhou', '1', 0);
INSERT INTO `hh_region` VALUES (620503, '麦积区', 620500, '麦积', 3, '0938', '741020', '105.89013', '34.57069', 'Maiji', '1', 0);
INSERT INTO `hh_region` VALUES (620521, '清水县', 620500, '清水', 3, '0938', '741400', '106.13671', '34.75032', 'Qingshui', '1', 0);
INSERT INTO `hh_region` VALUES (620522, '秦安县', 620500, '秦安', 3, '0938', '741600', '105.66955', '34.85894', 'Qin\'an', '1', 0);
INSERT INTO `hh_region` VALUES (620523, '甘谷县', 620500, '甘谷', 3, '0938', '741200', '105.33291', '34.73665', 'Gangu', '1', 0);
INSERT INTO `hh_region` VALUES (620524, '武山县', 620500, '武山', 3, '0938', '741300', '104.88382', '34.72123', 'Wushan', '1', 0);
INSERT INTO `hh_region` VALUES (620525, '张家川回族自治县', 620500, '张家川', 3, '0938', '741500', '106.21582', '34.99582', 'Zhangjiachuan', '1', 0);
INSERT INTO `hh_region` VALUES (620600, '武威市', 620000, '武威', 2, '0935', '733000', '102.634697', '37.929996', 'Wuwei', '1', 0);
INSERT INTO `hh_region` VALUES (620602, '凉州区', 620600, '凉州', 3, '0935', '733000', '102.64203', '37.92832', 'Liangzhou', '1', 0);
INSERT INTO `hh_region` VALUES (620621, '民勤县', 620600, '民勤', 3, '0935', '733300', '103.09011', '38.62487', 'Minqin', '1', 0);
INSERT INTO `hh_region` VALUES (620622, '古浪县', 620600, '古浪', 3, '0935', '733100', '102.89154', '37.46508', 'Gulang', '1', 0);
INSERT INTO `hh_region` VALUES (620623, '天祝藏族自治县', 620600, '天祝', 3, '0935', '733200', '103.1361', '36.97715', 'Tianzhu', '1', 0);
INSERT INTO `hh_region` VALUES (620700, '张掖市', 620000, '张掖', 2, '0936', '734000', '100.455472', '38.932897', 'Zhangye', '1', 0);
INSERT INTO `hh_region` VALUES (620702, '甘州区', 620700, '甘州', 3, '0936', '734000', '100.4527', '38.92947', 'Ganzhou', '1', 0);
INSERT INTO `hh_region` VALUES (620721, '肃南裕固族自治县', 620700, '肃南', 3, '0936', '734400', '99.61407', '38.83776', 'Sunan', '1', 0);
INSERT INTO `hh_region` VALUES (620722, '民乐县', 620700, '民乐', 3, '0936', '734500', '100.81091', '38.43479', 'Minle', '1', 0);
INSERT INTO `hh_region` VALUES (620723, '临泽县', 620700, '临泽', 3, '0936', '734200', '100.16445', '39.15252', 'Linze', '1', 0);
INSERT INTO `hh_region` VALUES (620724, '高台县', 620700, '高台', 3, '0936', '734300', '99.81918', '39.37829', 'Gaotai', '1', 0);
INSERT INTO `hh_region` VALUES (620725, '山丹县', 620700, '山丹', 3, '0936', '734100', '101.09359', '38.78468', 'Shandan', '1', 0);
INSERT INTO `hh_region` VALUES (620800, '平凉市', 620000, '平凉', 2, '0933', '744000', '106.684691', '35.54279', 'Pingliang', '1', 0);
INSERT INTO `hh_region` VALUES (620802, '崆峒区', 620800, '崆峒', 3, '0933', '744000', '106.67483', '35.54262', 'Kongtong', '1', 0);
INSERT INTO `hh_region` VALUES (620821, '泾川县', 620800, '泾川', 3, '0933', '744300', '107.36581', '35.33223', 'Jingchuan', '1', 0);
INSERT INTO `hh_region` VALUES (620822, '灵台县', 620800, '灵台', 3, '0933', '744400', '107.6174', '35.06768', 'Lingtai', '1', 0);
INSERT INTO `hh_region` VALUES (620823, '崇信县', 620800, '崇信', 3, '0933', '744200', '107.03738', '35.30344', 'Chongxin', '1', 0);
INSERT INTO `hh_region` VALUES (620824, '华亭县', 620800, '华亭', 3, '0933', '744100', '106.65463', '35.2183', 'Huating', '1', 0);
INSERT INTO `hh_region` VALUES (620825, '庄浪县', 620800, '庄浪', 3, '0933', '744600', '106.03662', '35.20235', 'Zhuanglang', '1', 0);
INSERT INTO `hh_region` VALUES (620826, '静宁县', 620800, '静宁', 3, '0933', '743400', '105.72723', '35.51991', 'Jingning', '1', 0);
INSERT INTO `hh_region` VALUES (620900, '酒泉市', 620000, '酒泉', 2, '0937', '735000', '98.510795', '39.744023', 'Jiuquan', '1', 0);
INSERT INTO `hh_region` VALUES (620902, '肃州区', 620900, '肃州', 3, '0937', '735000', '98.50775', '39.74506', 'Suzhou', '1', 0);
INSERT INTO `hh_region` VALUES (620921, '金塔县', 620900, '金塔', 3, '0937', '735300', '98.90002', '39.97733', 'Jinta', '1', 0);
INSERT INTO `hh_region` VALUES (620922, '瓜州县', 620900, '瓜州', 3, '0937', '736100', '95.78271', '40.51548', 'Guazhou', '1', 0);
INSERT INTO `hh_region` VALUES (620923, '肃北蒙古族自治县', 620900, '肃北', 3, '0937', '736300', '94.87649', '39.51214', 'Subei', '1', 0);
INSERT INTO `hh_region` VALUES (620924, '阿克塞哈萨克族自治县', 620900, '阿克塞', 3, '0937', '736400', '94.34097', '39.63435', 'Akesai', '1', 0);
INSERT INTO `hh_region` VALUES (620981, '玉门市', 620900, '玉门', 3, '0937', '735200', '97.04538', '40.29172', 'Yumen', '1', 0);
INSERT INTO `hh_region` VALUES (620982, '敦煌市', 620900, '敦煌', 3, '0937', '736200', '94.66159', '40.14211', 'Dunhuang', '1', 0);
INSERT INTO `hh_region` VALUES (621000, '庆阳市', 620000, '庆阳', 2, '0934', '745000', '107.638372', '35.734218', 'Qingyang', '1', 0);
INSERT INTO `hh_region` VALUES (621002, '西峰区', 621000, '西峰', 3, '0934', '745000', '107.65107', '35.73065', 'Xifeng', '1', 0);
INSERT INTO `hh_region` VALUES (621021, '庆城县', 621000, '庆城', 3, '0934', '745100', '107.88272', '36.01507', 'Qingcheng', '1', 0);
INSERT INTO `hh_region` VALUES (621022, '环县', 621000, '环县', 3, '0934', '745700', '107.30835', '36.56846', 'Huanxian', '1', 0);
INSERT INTO `hh_region` VALUES (621023, '华池县', 621000, '华池', 3, '0934', '745600', '107.9891', '36.46108', 'Huachi', '1', 0);
INSERT INTO `hh_region` VALUES (621024, '合水县', 621000, '合水', 3, '0934', '745400', '108.02032', '35.81911', 'Heshui', '1', 0);
INSERT INTO `hh_region` VALUES (621025, '正宁县', 621000, '正宁', 3, '0934', '745300', '108.36007', '35.49174', 'Zhengning', '1', 0);
INSERT INTO `hh_region` VALUES (621026, '宁县', 621000, '宁县', 3, '0934', '745200', '107.92517', '35.50164', 'Ningxian', '1', 0);
INSERT INTO `hh_region` VALUES (621027, '镇原县', 621000, '镇原', 3, '0934', '744500', '107.199', '35.67712', 'Zhenyuan', '1', 0);
INSERT INTO `hh_region` VALUES (621100, '定西市', 620000, '定西', 2, '0932', '743000', '104.626294', '35.579578', 'Dingxi', '1', 0);
INSERT INTO `hh_region` VALUES (621102, '安定区', 621100, '安定', 3, '0932', '743000', '104.6106', '35.58066', 'Anding', '1', 0);
INSERT INTO `hh_region` VALUES (621121, '通渭县', 621100, '通渭', 3, '0932', '743300', '105.24224', '35.21101', 'Tongwei', '1', 0);
INSERT INTO `hh_region` VALUES (621122, '陇西县', 621100, '陇西', 3, '0932', '748100', '104.63446', '35.00238', 'Longxi', '1', 0);
INSERT INTO `hh_region` VALUES (621123, '渭源县', 621100, '渭源', 3, '0932', '748200', '104.21435', '35.13649', 'Weiyuan', '1', 0);
INSERT INTO `hh_region` VALUES (621124, '临洮县', 621100, '临洮', 3, '0932', '730500', '103.86196', '35.3751', 'Lintao', '1', 0);
INSERT INTO `hh_region` VALUES (621125, '漳县', 621100, '漳县', 3, '0932', '748300', '104.46704', '34.84977', 'Zhangxian', '1', 0);
INSERT INTO `hh_region` VALUES (621126, '岷县', 621100, '岷县', 3, '0932', '748400', '104.03772', '34.43444', 'Minxian', '1', 0);
INSERT INTO `hh_region` VALUES (621200, '陇南市', 620000, '陇南', 2, '0939', '746000', '104.929379', '33.388598', 'Longnan', '1', 0);
INSERT INTO `hh_region` VALUES (621202, '武都区', 621200, '武都', 3, '0939', '746000', '104.92652', '33.39239', 'Wudu', '1', 0);
INSERT INTO `hh_region` VALUES (621221, '成县', 621200, '成县', 3, '0939', '742500', '105.72586', '33.73925', 'Chengxian', '1', 0);
INSERT INTO `hh_region` VALUES (621222, '文县', 621200, '文县', 3, '0939', '746400', '104.68362', '32.94337', 'Wenxian', '1', 0);
INSERT INTO `hh_region` VALUES (621223, '宕昌县', 621200, '宕昌', 3, '0939', '748500', '104.39349', '34.04732', 'Dangchang', '1', 0);
INSERT INTO `hh_region` VALUES (621224, '康县', 621200, '康县', 3, '0939', '746500', '105.60711', '33.32912', 'Kangxian', '1', 0);
INSERT INTO `hh_region` VALUES (621225, '西和县', 621200, '西和', 3, '0939', '742100', '105.30099', '34.01432', 'Xihe', '1', 0);
INSERT INTO `hh_region` VALUES (621226, '礼县', 621200, '礼县', 3, '0939', '742200', '105.17785', '34.18935', 'Lixian', '1', 0);
INSERT INTO `hh_region` VALUES (621227, '徽县', 621200, '徽县', 3, '0939', '742300', '106.08529', '33.76898', 'Huixian', '1', 0);
INSERT INTO `hh_region` VALUES (621228, '两当县', 621200, '两当', 3, '0939', '742400', '106.30484', '33.9096', 'Liangdang', '1', 0);
INSERT INTO `hh_region` VALUES (622900, '临夏回族自治州', 620000, '临夏', 2, '0930', '731100', '103.212006', '35.599446', 'Linxia', '1', 0);
INSERT INTO `hh_region` VALUES (622901, '临夏市', 622900, '临夏', 3, '0930', '731100', '103.21', '35.59916', 'Linxia', '1', 0);
INSERT INTO `hh_region` VALUES (622921, '临夏县', 622900, '临夏', 3, '0930', '731800', '102.9938', '35.49519', 'Linxia', '1', 0);
INSERT INTO `hh_region` VALUES (622922, '康乐县', 622900, '康乐', 3, '0930', '731500', '103.71093', '35.37219', 'Kangle', '1', 0);
INSERT INTO `hh_region` VALUES (622923, '永靖县', 622900, '永靖', 3, '0930', '731600', '103.32043', '35.93835', 'Yongjing', '1', 0);
INSERT INTO `hh_region` VALUES (622924, '广河县', 622900, '广河', 3, '0930', '731300', '103.56933', '35.48097', 'Guanghe', '1', 0);
INSERT INTO `hh_region` VALUES (622925, '和政县', 622900, '和政', 3, '0930', '731200', '103.34936', '35.42592', 'Hezheng', '1', 0);
INSERT INTO `hh_region` VALUES (622926, '东乡族自治县', 622900, '东乡族', 3, '0930', '731400', '103.39477', '35.66471', 'Dongxiangzu', '1', 0);
INSERT INTO `hh_region` VALUES (622927, '积石山保安族东乡族撒拉族自治县', 622900, '积石山', 3, '0930', '731700', '102.87374', '35.7182', 'Jishishan', '1', 0);
INSERT INTO `hh_region` VALUES (623000, '甘南藏族自治州', 620000, '甘南', 2, '0941', '747000', '102.911008', '34.986354', 'Gannan', '1', 0);
INSERT INTO `hh_region` VALUES (623001, '合作市', 623000, '合作', 3, '0941', '747000', '102.91082', '35.00016', 'Hezuo', '1', 0);
INSERT INTO `hh_region` VALUES (623021, '临潭县', 623000, '临潭', 3, '0941', '747500', '103.35287', '34.69515', 'Lintan', '1', 0);
INSERT INTO `hh_region` VALUES (623022, '卓尼县', 623000, '卓尼', 3, '0941', '747600', '103.50811', '34.58919', 'Zhuoni', '1', 0);
INSERT INTO `hh_region` VALUES (623023, '舟曲县', 623000, '舟曲', 3, '0941', '746300', '104.37155', '33.78468', 'Zhouqu', '1', 0);
INSERT INTO `hh_region` VALUES (623024, '迭部县', 623000, '迭部', 3, '0941', '747400', '103.22274', '34.05623', 'Diebu', '1', 0);
INSERT INTO `hh_region` VALUES (623025, '玛曲县', 623000, '玛曲', 3, '0941', '747300', '102.0754', '33.997', 'Maqu', '1', 0);
INSERT INTO `hh_region` VALUES (623026, '碌曲县', 623000, '碌曲', 3, '0941', '747200', '102.49176', '34.58872', 'Luqu', '1', 0);
INSERT INTO `hh_region` VALUES (623027, '夏河县', 623000, '夏河', 3, '0941', '747100', '102.52215', '35.20487', 'Xiahe', '1', 0);
INSERT INTO `hh_region` VALUES (630000, '青海省', 100000, '青海', 1, '', '', '101.778916', '36.623178', 'Qinghai', '1', 0);
INSERT INTO `hh_region` VALUES (630100, '西宁市', 630000, '西宁', 2, '0971', '810000', '101.778916', '36.623178', 'Xining', '1', 0);
INSERT INTO `hh_region` VALUES (630102, '城东区', 630100, '城东', 3, '0971', '810007', '101.80373', '36.59969', 'Chengdong', '1', 0);
INSERT INTO `hh_region` VALUES (630103, '城中区', 630100, '城中', 3, '0971', '810000', '101.78394', '36.62279', 'Chengzhong', '1', 0);
INSERT INTO `hh_region` VALUES (630104, '城西区', 630100, '城西', 3, '0971', '810001', '101.76588', '36.62828', 'Chengxi', '1', 0);
INSERT INTO `hh_region` VALUES (630105, '城北区', 630100, '城北', 3, '0971', '810003', '101.7662', '36.65014', 'Chengbei', '1', 0);
INSERT INTO `hh_region` VALUES (630121, '大通回族土族自治县', 630100, '大通', 3, '0971', '810100', '101.70236', '36.93489', 'Datong', '1', 0);
INSERT INTO `hh_region` VALUES (630122, '湟中县', 630100, '湟中', 3, '0971', '811600', '101.57159', '36.50083', 'Huangzhong', '1', 0);
INSERT INTO `hh_region` VALUES (630123, '湟源县', 630100, '湟源', 3, '0971', '812100', '101.25643', '36.68243', 'Huangyuan', '1', 0);
INSERT INTO `hh_region` VALUES (630200, '海东市', 630000, '海东', 2, '0972', '810700', '102.10327', '36.502916', 'Haidong', '1', 0);
INSERT INTO `hh_region` VALUES (630202, '乐都区', 630200, '乐都', 3, '0972', '810700', '102.402431', '36.480291', 'Ledu', '1', 0);
INSERT INTO `hh_region` VALUES (630221, '平安县', 630200, '平安', 3, '0972', '810600', '102.104295', '36.502714', 'Ping\'an', '1', 0);
INSERT INTO `hh_region` VALUES (630222, '民和回族土族自治县', 630200, '民和', 3, '0972', '810800', '102.804209', '36.329451', 'Minhe', '1', 0);
INSERT INTO `hh_region` VALUES (630223, '互助土族自治县', 630200, '互助', 3, '0972', '810500', '101.956734', '36.83994', 'Huzhu', '1', 0);
INSERT INTO `hh_region` VALUES (630224, '化隆回族自治县', 630200, '化隆', 3, '0972', '810900', '102.262329', '36.098322', 'Hualong', '1', 0);
INSERT INTO `hh_region` VALUES (630225, '循化撒拉族自治县', 630200, '循化', 3, '0972', '811100', '102.486534', '35.847247', 'Xunhua', '1', 0);
INSERT INTO `hh_region` VALUES (632200, '海北藏族自治州', 630000, '海北', 2, '0970', '812200', '100.901059', '36.959435', 'Haibei', '1', 0);
INSERT INTO `hh_region` VALUES (632221, '门源回族自治县', 632200, '门源', 3, '0970', '810300', '101.62228', '37.37611', 'Menyuan', '1', 0);
INSERT INTO `hh_region` VALUES (632222, '祁连县', 632200, '祁连', 3, '0970', '810400', '100.24618', '38.17901', 'Qilian', '1', 0);
INSERT INTO `hh_region` VALUES (632223, '海晏县', 632200, '海晏', 3, '0970', '812200', '100.9927', '36.89902', 'Haiyan', '1', 0);
INSERT INTO `hh_region` VALUES (632224, '刚察县', 632200, '刚察', 3, '0970', '812300', '100.14675', '37.32161', 'Gangcha', '1', 0);
INSERT INTO `hh_region` VALUES (632300, '黄南藏族自治州', 630000, '黄南', 2, '0973', '811300', '102.019988', '35.517744', 'Huangnan', '1', 0);
INSERT INTO `hh_region` VALUES (632321, '同仁县', 632300, '同仁', 3, '0973', '811300', '102.0184', '35.51603', 'Tongren', '1', 0);
INSERT INTO `hh_region` VALUES (632322, '尖扎县', 632300, '尖扎', 3, '0973', '811200', '102.03411', '35.93947', 'Jianzha', '1', 0);
INSERT INTO `hh_region` VALUES (632323, '泽库县', 632300, '泽库', 3, '0973', '811400', '101.46444', '35.03519', 'Zeku', '1', 0);
INSERT INTO `hh_region` VALUES (632324, '河南蒙古族自治县', 632300, '河南', 3, '0973', '811500', '101.60864', '34.73476', 'Henan', '1', 0);
INSERT INTO `hh_region` VALUES (632500, '海南藏族自治州', 630000, '海南', 2, '0974', '813000', '100.619542', '36.280353', 'Hainan', '1', 0);
INSERT INTO `hh_region` VALUES (632521, '共和县', 632500, '共和', 3, '0974', '813000', '100.62003', '36.2841', 'Gonghe', '1', 0);
INSERT INTO `hh_region` VALUES (632522, '同德县', 632500, '同德', 3, '0974', '813200', '100.57159', '35.25488', 'Tongde', '1', 0);
INSERT INTO `hh_region` VALUES (632523, '贵德县', 632500, '贵德', 3, '0974', '811700', '101.432', '36.044', 'Guide', '1', 0);
INSERT INTO `hh_region` VALUES (632524, '兴海县', 632500, '兴海', 3, '0974', '813300', '99.98846', '35.59031', 'Xinghai', '1', 0);
INSERT INTO `hh_region` VALUES (632525, '贵南县', 632500, '贵南', 3, '0974', '813100', '100.74716', '35.58667', 'Guinan', '1', 0);
INSERT INTO `hh_region` VALUES (632600, '果洛藏族自治州', 630000, '果洛', 2, '0975', '814000', '100.242143', '34.4736', 'Golog', '1', 0);
INSERT INTO `hh_region` VALUES (632621, '玛沁县', 632600, '玛沁', 3, '0975', '814000', '100.23901', '34.47746', 'Maqin', '1', 0);
INSERT INTO `hh_region` VALUES (632622, '班玛县', 632600, '班玛', 3, '0975', '814300', '100.73745', '32.93253', 'Banma', '1', 0);
INSERT INTO `hh_region` VALUES (632623, '甘德县', 632600, '甘德', 3, '0975', '814100', '99.90246', '33.96838', 'Gande', '1', 0);
INSERT INTO `hh_region` VALUES (632624, '达日县', 632600, '达日', 3, '0975', '814200', '99.65179', '33.75193', 'Dari', '1', 0);
INSERT INTO `hh_region` VALUES (632625, '久治县', 632600, '久治', 3, '0975', '624700', '101.48342', '33.42989', 'Jiuzhi', '1', 0);
INSERT INTO `hh_region` VALUES (632626, '玛多县', 632600, '玛多', 3, '0975', '813500', '98.20996', '34.91567', 'Maduo', '1', 0);
INSERT INTO `hh_region` VALUES (632700, '玉树藏族自治州', 630000, '玉树', 2, '0976', '815000', '97.008522', '33.004049', 'Yushu', '1', 0);
INSERT INTO `hh_region` VALUES (632701, '玉树市', 632700, '玉树', 3, '0976', '815000', '97.008762', '33.00393', 'Yushu', '1', 0);
INSERT INTO `hh_region` VALUES (632722, '杂多县', 632700, '杂多', 3, '0976', '815300', '95.29864', '32.89318', 'Zaduo', '1', 0);
INSERT INTO `hh_region` VALUES (632723, '称多县', 632700, '称多', 3, '0976', '815100', '97.10788', '33.36899', 'Chenduo', '1', 0);
INSERT INTO `hh_region` VALUES (632724, '治多县', 632700, '治多', 3, '0976', '815400', '95.61572', '33.8528', 'Zhiduo', '1', 0);
INSERT INTO `hh_region` VALUES (632725, '囊谦县', 632700, '囊谦', 3, '0976', '815200', '96.47753', '32.20359', 'Nangqian', '1', 0);
INSERT INTO `hh_region` VALUES (632726, '曲麻莱县', 632700, '曲麻莱', 3, '0976', '815500', '95.79757', '34.12609', 'Qumalai', '1', 0);
INSERT INTO `hh_region` VALUES (632800, '海西蒙古族藏族自治州', 630000, '海西', 2, '0977', '817000', '97.370785', '37.374663', 'Haixi', '1', 0);
INSERT INTO `hh_region` VALUES (632801, '格尔木市', 632800, '格尔木', 3, '0977', '816000', '94.90329', '36.40236', 'Geermu', '1', 0);
INSERT INTO `hh_region` VALUES (632802, '德令哈市', 632800, '德令哈', 3, '0977', '817000', '97.36084', '37.36946', 'Delingha', '1', 0);
INSERT INTO `hh_region` VALUES (632821, '乌兰县', 632800, '乌兰', 3, '0977', '817100', '98.48196', '36.93471', 'Wulan', '1', 0);
INSERT INTO `hh_region` VALUES (632822, '都兰县', 632800, '都兰', 3, '0977', '816100', '98.09228', '36.30135', 'Dulan', '1', 0);
INSERT INTO `hh_region` VALUES (632823, '天峻县', 632800, '天峻', 3, '0977', '817200', '99.02453', '37.30326', 'Tianjun', '1', 0);
INSERT INTO `hh_region` VALUES (640000, '宁夏回族自治区', 100000, '宁夏', 1, '', '', '106.278179', '38.46637', 'Ningxia', '1', 0);
INSERT INTO `hh_region` VALUES (640100, '银川市', 640000, '银川', 2, '0951', '750004', '106.278179', '38.46637', 'Yinchuan', '1', 0);
INSERT INTO `hh_region` VALUES (640104, '兴庆区', 640100, '兴庆', 3, '0951', '750001', '106.28872', '38.47392', 'Xingqing', '1', 0);
INSERT INTO `hh_region` VALUES (640105, '西夏区', 640100, '西夏', 3, '0951', '750021', '106.15023', '38.49137', 'Xixia', '1', 0);
INSERT INTO `hh_region` VALUES (640106, '金凤区', 640100, '金凤', 3, '0951', '750011', '106.24261', '38.47294', 'Jinfeng', '1', 0);
INSERT INTO `hh_region` VALUES (640121, '永宁县', 640100, '永宁', 3, '0951', '750100', '106.2517', '38.27559', 'Yongning', '1', 0);
INSERT INTO `hh_region` VALUES (640122, '贺兰县', 640100, '贺兰', 3, '0951', '750200', '106.34982', '38.5544', 'Helan', '1', 0);
INSERT INTO `hh_region` VALUES (640181, '灵武市', 640100, '灵武', 3, '0951', '750004', '106.33999', '38.10266', 'Lingwu', '1', 0);
INSERT INTO `hh_region` VALUES (640200, '石嘴山市', 640000, '石嘴山', 2, '0952', '753000', '106.376173', '39.01333', 'Shizuishan', '1', 0);
INSERT INTO `hh_region` VALUES (640202, '大武口区', 640200, '大武口', 3, '0952', '753000', '106.37717', '39.01226', 'Dawukou', '1', 0);
INSERT INTO `hh_region` VALUES (640205, '惠农区', 640200, '惠农', 3, '0952', '753600', '106.71145', '39.13193', 'Huinong', '1', 0);
INSERT INTO `hh_region` VALUES (640221, '平罗县', 640200, '平罗', 3, '0952', '753400', '106.54538', '38.90429', 'Pingluo', '1', 0);
INSERT INTO `hh_region` VALUES (640300, '吴忠市', 640000, '吴忠', 2, '0953', '751100', '106.199409', '37.986165', 'Wuzhong', '1', 0);
INSERT INTO `hh_region` VALUES (640302, '利通区', 640300, '利通', 3, '0953', '751100', '106.20311', '37.98512', 'Litong', '1', 0);
INSERT INTO `hh_region` VALUES (640303, '红寺堡区', 640300, '红寺堡', 3, '0953', '751900', '106.19822', '37.99747', 'Hongsibao', '1', 0);
INSERT INTO `hh_region` VALUES (640323, '盐池县', 640300, '盐池', 3, '0953', '751500', '107.40707', '37.7833', 'Yanchi', '1', 0);
INSERT INTO `hh_region` VALUES (640324, '同心县', 640300, '同心', 3, '0953', '751300', '105.91418', '36.98116', 'Tongxin', '1', 0);
INSERT INTO `hh_region` VALUES (640381, '青铜峡市', 640300, '青铜峡', 3, '0953', '751600', '106.07489', '38.02004', 'Qingtongxia', '1', 0);
INSERT INTO `hh_region` VALUES (640400, '固原市', 640000, '固原', 2, '0954', '756000', '106.285241', '36.004561', 'Guyuan', '1', 0);
INSERT INTO `hh_region` VALUES (640402, '原州区', 640400, '原州', 3, '0954', '756000', '106.28778', '36.00374', 'Yuanzhou', '1', 0);
INSERT INTO `hh_region` VALUES (640422, '西吉县', 640400, '西吉', 3, '0954', '756200', '105.73107', '35.96616', 'Xiji', '1', 0);
INSERT INTO `hh_region` VALUES (640423, '隆德县', 640400, '隆德', 3, '0954', '756300', '106.12426', '35.61718', 'Longde', '1', 0);
INSERT INTO `hh_region` VALUES (640424, '泾源县', 640400, '泾源', 3, '0954', '756400', '106.33902', '35.49072', 'Jingyuan', '1', 0);
INSERT INTO `hh_region` VALUES (640425, '彭阳县', 640400, '彭阳', 3, '0954', '756500', '106.64462', '35.85076', 'Pengyang', '1', 0);
INSERT INTO `hh_region` VALUES (640500, '中卫市', 640000, '中卫', 2, '0955', '751700', '105.189568', '37.514951', 'Zhongwei', '1', 0);
INSERT INTO `hh_region` VALUES (640502, '沙坡头区', 640500, '沙坡头', 3, '0955', '755000', '105.18962', '37.51044', 'Shapotou', '1', 0);
INSERT INTO `hh_region` VALUES (640521, '中宁县', 640500, '中宁', 3, '0955', '751200', '105.68515', '37.49149', 'Zhongning', '1', 0);
INSERT INTO `hh_region` VALUES (640522, '海原县', 640500, '海原', 3, '0955', '751800', '105.64712', '36.56498', 'Haiyuan', '1', 0);
INSERT INTO `hh_region` VALUES (650000, '新疆维吾尔自治区', 100000, '新疆', 1, '', '', '87.617733', '43.792818', 'Xinjiang', '1', 0);
INSERT INTO `hh_region` VALUES (650100, '乌鲁木齐市', 650000, '乌鲁木齐', 2, '0991', '830002', '87.617733', '43.792818', 'Urumqi', '1', 0);
INSERT INTO `hh_region` VALUES (650102, '天山区', 650100, '天山', 3, '0991', '830002', '87.63167', '43.79439', 'Tianshan', '1', 0);
INSERT INTO `hh_region` VALUES (650103, '沙依巴克区', 650100, '沙依巴克', 3, '0991', '830000', '87.59788', '43.80118', 'Shayibake', '1', 0);
INSERT INTO `hh_region` VALUES (650104, '新市区', 650100, '新市', 3, '0991', '830011', '87.57406', '43.84348', 'Xinshi', '1', 0);
INSERT INTO `hh_region` VALUES (650105, '水磨沟区', 650100, '水磨沟', 3, '0991', '830017', '87.64249', '43.83247', 'Shuimogou', '1', 0);
INSERT INTO `hh_region` VALUES (650106, '头屯河区', 650100, '头屯河', 3, '0991', '830022', '87.29138', '43.85487', 'Toutunhe', '1', 0);
INSERT INTO `hh_region` VALUES (650107, '达坂城区', 650100, '达坂城', 3, '0991', '830039', '88.30697', '43.35797', 'Dabancheng', '1', 0);
INSERT INTO `hh_region` VALUES (650109, '米东区', 650100, '米东', 3, '0991', '830019', '87.68583', '43.94739', 'Midong', '1', 0);
INSERT INTO `hh_region` VALUES (650121, '乌鲁木齐县', 650100, '乌鲁木齐', 3, '0991', '830063', '87.40939', '43.47125', 'Wulumuqi', '1', 0);
INSERT INTO `hh_region` VALUES (650200, '克拉玛依市', 650000, '克拉玛依', 2, '0990', '834000', '84.873946', '45.595886', 'Karamay', '1', 0);
INSERT INTO `hh_region` VALUES (650202, '独山子区', 650200, '独山子', 3, '0992', '834021', '84.88671', '44.32867', 'Dushanzi', '1', 0);
INSERT INTO `hh_region` VALUES (650203, '克拉玛依区', 650200, '克拉玛依', 3, '0990', '834000', '84.86225', '45.59089', 'Kelamayi', '1', 0);
INSERT INTO `hh_region` VALUES (650204, '白碱滩区', 650200, '白碱滩', 3, '0990', '834008', '85.13244', '45.68768', 'Baijiantan', '1', 0);
INSERT INTO `hh_region` VALUES (650205, '乌尔禾区', 650200, '乌尔禾', 3, '0990', '834012', '85.69143', '46.09006', 'Wuerhe', '1', 0);
INSERT INTO `hh_region` VALUES (652100, '吐鲁番地区', 650000, '吐鲁番', 2, '0995', '838000', '89.184078', '42.947613', 'Turpan', '1', 0);
INSERT INTO `hh_region` VALUES (652101, '吐鲁番市', 652100, '吐鲁番', 3, '0995', '838000', '89.18579', '42.93505', 'Tulufan', '1', 0);
INSERT INTO `hh_region` VALUES (652122, '鄯善县', 652100, '鄯善', 3, '0995', '838200', '90.21402', '42.8635', 'Shanshan', '1', 0);
INSERT INTO `hh_region` VALUES (652123, '托克逊县', 652100, '托克逊', 3, '0995', '838100', '88.65823', '42.79231', 'Tuokexun', '1', 0);
INSERT INTO `hh_region` VALUES (652200, '哈密地区', 650000, '哈密', 2, '0902', '839000', '93.51316', '42.833248', 'Hami', '1', 0);
INSERT INTO `hh_region` VALUES (652201, '哈密市', 652200, '哈密', 3, '0902', '839000', '93.51452', '42.82699', 'Hami', '1', 0);
INSERT INTO `hh_region` VALUES (652222, '巴里坤哈萨克自治县', 652200, '巴里坤', 3, '0902', '839200', '93.01236', '43.59993', 'Balikun', '1', 0);
INSERT INTO `hh_region` VALUES (652223, '伊吾县', 652200, '伊吾', 3, '0902', '839300', '94.69403', '43.2537', 'Yiwu', '1', 0);
INSERT INTO `hh_region` VALUES (652300, '昌吉回族自治州', 650000, '昌吉', 2, '0994', '831100', '87.304012', '44.014577', 'Changji', '1', 0);
INSERT INTO `hh_region` VALUES (652301, '昌吉市', 652300, '昌吉', 3, '0994', '831100', '87.30249', '44.01267', 'Changji', '1', 0);
INSERT INTO `hh_region` VALUES (652302, '阜康市', 652300, '阜康', 3, '0994', '831500', '87.98529', '44.1584', 'Fukang', '1', 0);
INSERT INTO `hh_region` VALUES (652323, '呼图壁县', 652300, '呼图壁', 3, '0994', '831200', '86.89892', '44.18977', 'Hutubi', '1', 0);
INSERT INTO `hh_region` VALUES (652324, '玛纳斯县', 652300, '玛纳斯', 3, '0994', '832200', '86.2145', '44.30438', 'Manasi', '1', 0);
INSERT INTO `hh_region` VALUES (652325, '奇台县', 652300, '奇台', 3, '0994', '831800', '89.5932', '44.02221', 'Qitai', '1', 0);
INSERT INTO `hh_region` VALUES (652327, '吉木萨尔县', 652300, '吉木萨尔', 3, '0994', '831700', '89.18078', '44.00048', 'Jimusaer', '1', 0);
INSERT INTO `hh_region` VALUES (652328, '木垒哈萨克自治县', 652300, '木垒', 3, '0994', '831900', '90.28897', '43.83508', 'Mulei', '1', 0);
INSERT INTO `hh_region` VALUES (652700, '博尔塔拉蒙古自治州', 650000, '博尔塔拉', 2, '0909', '833400', '82.074778', '44.903258', 'Bortala', '1', 0);
INSERT INTO `hh_region` VALUES (652701, '博乐市', 652700, '博乐', 3, '0909', '833400', '82.0713', '44.90052', 'Bole', '1', 0);
INSERT INTO `hh_region` VALUES (652702, '阿拉山口市', 652700, '阿拉山口', 3, '0909', '833400', '82.567721', '45.170616', 'Alashankou', '1', 0);
INSERT INTO `hh_region` VALUES (652722, '精河县', 652700, '精河', 3, '0909', '833300', '82.89419', '44.60774', 'Jinghe', '1', 0);
INSERT INTO `hh_region` VALUES (652723, '温泉县', 652700, '温泉', 3, '0909', '833500', '81.03134', '44.97373', 'Wenquan', '1', 0);
INSERT INTO `hh_region` VALUES (652800, '巴音郭楞蒙古自治州', 650000, '巴音郭楞', 2, '0996', '841000', '86.150969', '41.768552', 'Bayingol', '1', 0);
INSERT INTO `hh_region` VALUES (652801, '库尔勒市', 652800, '库尔勒', 3, '0996', '841000', '86.15528', '41.76602', 'Kuerle', '1', 0);
INSERT INTO `hh_region` VALUES (652822, '轮台县', 652800, '轮台', 3, '0996', '841600', '84.26101', '41.77642', 'Luntai', '1', 0);
INSERT INTO `hh_region` VALUES (652823, '尉犁县', 652800, '尉犁', 3, '0996', '841500', '86.25903', '41.33632', 'Yuli', '1', 0);
INSERT INTO `hh_region` VALUES (652824, '若羌县', 652800, '若羌', 3, '0996', '841800', '88.16812', '39.0179', 'Ruoqiang', '1', 0);
INSERT INTO `hh_region` VALUES (652825, '且末县', 652800, '且末', 3, '0996', '841900', '85.52975', '38.14534', 'Qiemo', '1', 0);
INSERT INTO `hh_region` VALUES (652826, '焉耆回族自治县', 652800, '焉耆', 3, '0996', '841100', '86.5744', '42.059', 'Yanqi', '1', 0);
INSERT INTO `hh_region` VALUES (652827, '和静县', 652800, '和静', 3, '0996', '841300', '86.39611', '42.31838', 'Hejing', '1', 0);
INSERT INTO `hh_region` VALUES (652828, '和硕县', 652800, '和硕', 3, '0996', '841200', '86.86392', '42.26814', 'Heshuo', '1', 0);
INSERT INTO `hh_region` VALUES (652829, '博湖县', 652800, '博湖', 3, '0996', '841400', '86.63333', '41.98014', 'Bohu', '1', 0);
INSERT INTO `hh_region` VALUES (652900, '阿克苏地区', 650000, '阿克苏', 2, '0997', '843000', '80.265068', '41.170712', 'Aksu', '1', 0);
INSERT INTO `hh_region` VALUES (652901, '阿克苏市', 652900, '阿克苏', 3, '0997', '843000', '80.26338', '41.16754', 'Akesu', '1', 0);
INSERT INTO `hh_region` VALUES (652922, '温宿县', 652900, '温宿', 3, '0997', '843100', '80.24173', '41.27679', 'Wensu', '1', 0);
INSERT INTO `hh_region` VALUES (652923, '库车县', 652900, '库车', 3, '0997', '842000', '82.96209', '41.71793', 'Kuche', '1', 0);
INSERT INTO `hh_region` VALUES (652924, '沙雅县', 652900, '沙雅', 3, '0997', '842200', '82.78131', '41.22497', 'Shaya', '1', 0);
INSERT INTO `hh_region` VALUES (652925, '新和县', 652900, '新和', 3, '0997', '842100', '82.61053', '41.54964', 'Xinhe', '1', 0);
INSERT INTO `hh_region` VALUES (652926, '拜城县', 652900, '拜城', 3, '0997', '842300', '81.87564', '41.79801', 'Baicheng', '1', 0);
INSERT INTO `hh_region` VALUES (652927, '乌什县', 652900, '乌什', 3, '0997', '843400', '79.22937', '41.21569', 'Wushi', '1', 0);
INSERT INTO `hh_region` VALUES (652928, '阿瓦提县', 652900, '阿瓦提', 3, '0997', '843200', '80.38336', '40.63926', 'Awati', '1', 0);
INSERT INTO `hh_region` VALUES (652929, '柯坪县', 652900, '柯坪', 3, '0997', '843600', '79.04751', '40.50585', 'Keping', '1', 0);
INSERT INTO `hh_region` VALUES (653000, '克孜勒苏柯尔克孜自治州', 650000, '克孜勒苏', 2, '0908', '845350', '76.172825', '39.713431', 'Kizilsu', '1', 0);
INSERT INTO `hh_region` VALUES (653001, '阿图什市', 653000, '阿图什', 3, '0908', '845350', '76.16827', '39.71615', 'Atushi', '1', 0);
INSERT INTO `hh_region` VALUES (653022, '阿克陶县', 653000, '阿克陶', 3, '0908', '845550', '75.94692', '39.14892', 'Aketao', '1', 0);
INSERT INTO `hh_region` VALUES (653023, '阿合奇县', 653000, '阿合奇', 3, '0997', '843500', '78.44848', '40.93947', 'Aheqi', '1', 0);
INSERT INTO `hh_region` VALUES (653024, '乌恰县', 653000, '乌恰', 3, '0908', '845450', '75.25839', '39.71984', 'Wuqia', '1', 0);
INSERT INTO `hh_region` VALUES (653100, '喀什地区', 650000, '喀什', 2, '0998', '844000', '75.989138', '39.467664', 'Kashgar', '1', 0);
INSERT INTO `hh_region` VALUES (653101, '喀什市', 653100, '喀什', 3, '0998', '844000', '75.99379', '39.46768', 'Kashi', '1', 0);
INSERT INTO `hh_region` VALUES (653121, '疏附县', 653100, '疏附', 3, '0998', '844100', '75.86029', '39.37534', 'Shufu', '1', 0);
INSERT INTO `hh_region` VALUES (653122, '疏勒县', 653100, '疏勒', 3, '0998', '844200', '76.05398', '39.40625', 'Shule', '1', 0);
INSERT INTO `hh_region` VALUES (653123, '英吉沙县', 653100, '英吉沙', 3, '0998', '844500', '76.17565', '38.92968', 'Yingjisha', '1', 0);
INSERT INTO `hh_region` VALUES (653124, '泽普县', 653100, '泽普', 3, '0998', '844800', '77.27145', '38.18935', 'Zepu', '1', 0);
INSERT INTO `hh_region` VALUES (653125, '莎车县', 653100, '莎车', 3, '0998', '844700', '77.24316', '38.41601', 'Shache', '1', 0);
INSERT INTO `hh_region` VALUES (653126, '叶城县', 653100, '叶城', 3, '0998', '844900', '77.41659', '37.88324', 'Yecheng', '1', 0);
INSERT INTO `hh_region` VALUES (653127, '麦盖提县', 653100, '麦盖提', 3, '0998', '844600', '77.64224', '38.89662', 'Maigaiti', '1', 0);
INSERT INTO `hh_region` VALUES (653128, '岳普湖县', 653100, '岳普湖', 3, '0998', '844400', '76.77233', '39.23561', 'Yuepuhu', '1', 0);
INSERT INTO `hh_region` VALUES (653129, '伽师县', 653100, '伽师', 3, '0998', '844300', '76.72372', '39.48801', 'Jiashi', '1', 0);
INSERT INTO `hh_region` VALUES (653130, '巴楚县', 653100, '巴楚', 3, '0998', '843800', '78.54888', '39.7855', 'Bachu', '1', 0);
INSERT INTO `hh_region` VALUES (653131, '塔什库尔干塔吉克自治县', 653100, '塔什库尔干塔吉克', 3, '0998', '845250', '75.23196', '37.77893', 'Tashikuergantajike', '1', 0);
INSERT INTO `hh_region` VALUES (653200, '和田地区', 650000, '和田', 2, '0903', '848000', '79.92533', '37.110687', 'Hotan', '1', 0);
INSERT INTO `hh_region` VALUES (653201, '和田市', 653200, '和田市', 3, '0903', '848000', '79.91353', '37.11214', 'Hetianshi', '1', 0);
INSERT INTO `hh_region` VALUES (653221, '和田县', 653200, '和田县', 3, '0903', '848000', '79.82874', '37.08922', 'Hetianxian', '1', 0);
INSERT INTO `hh_region` VALUES (653222, '墨玉县', 653200, '墨玉', 3, '0903', '848100', '79.74035', '37.27248', 'Moyu', '1', 0);
INSERT INTO `hh_region` VALUES (653223, '皮山县', 653200, '皮山', 3, '0903', '845150', '78.28125', '37.62007', 'Pishan', '1', 0);
INSERT INTO `hh_region` VALUES (653224, '洛浦县', 653200, '洛浦', 3, '0903', '848200', '80.18536', '37.07364', 'Luopu', '1', 0);
INSERT INTO `hh_region` VALUES (653225, '策勒县', 653200, '策勒', 3, '0903', '848300', '80.80999', '36.99843', 'Cele', '1', 0);
INSERT INTO `hh_region` VALUES (653226, '于田县', 653200, '于田', 3, '0903', '848400', '81.66717', '36.854', 'Yutian', '1', 0);
INSERT INTO `hh_region` VALUES (653227, '民丰县', 653200, '民丰', 3, '0903', '848500', '82.68444', '37.06577', 'Minfeng', '1', 0);
INSERT INTO `hh_region` VALUES (654000, '伊犁哈萨克自治州', 650000, '伊犁', 2, '0999', '835100', '81.317946', '43.92186', 'Ili', '1', 0);
INSERT INTO `hh_region` VALUES (654002, '伊宁市', 654000, '伊宁', 3, '0999', '835000', '81.32932', '43.91294', 'Yining', '1', 0);
INSERT INTO `hh_region` VALUES (654003, '奎屯市', 654000, '奎屯', 3, '0992', '833200', '84.90228', '44.425', 'Kuitun', '1', 0);
INSERT INTO `hh_region` VALUES (654004, '霍尔果斯市', 654000, '霍尔果斯', 3, '0999', '835221', '80.418189', '44.205778', 'Huoerguosi', '1', 0);
INSERT INTO `hh_region` VALUES (654021, '伊宁县', 654000, '伊宁', 3, '0999', '835100', '81.52764', '43.97863', 'Yining', '1', 0);
INSERT INTO `hh_region` VALUES (654022, '察布查尔锡伯自治县', 654000, '察布查尔锡伯', 3, '0999', '835300', '81.14956', '43.84023', 'Chabuchaerxibo', '1', 0);
INSERT INTO `hh_region` VALUES (654023, '霍城县', 654000, '霍城', 3, '0999', '835200', '80.87826', '44.0533', 'Huocheng', '1', 0);
INSERT INTO `hh_region` VALUES (654024, '巩留县', 654000, '巩留', 3, '0999', '835400', '82.22851', '43.48429', 'Gongliu', '1', 0);
INSERT INTO `hh_region` VALUES (654025, '新源县', 654000, '新源', 3, '0999', '835800', '83.26095', '43.4284', 'Xinyuan', '1', 0);
INSERT INTO `hh_region` VALUES (654026, '昭苏县', 654000, '昭苏', 3, '0999', '835600', '81.1307', '43.15828', 'Zhaosu', '1', 0);
INSERT INTO `hh_region` VALUES (654027, '特克斯县', 654000, '特克斯', 3, '0999', '835500', '81.84005', '43.21938', 'Tekesi', '1', 0);
INSERT INTO `hh_region` VALUES (654028, '尼勒克县', 654000, '尼勒克', 3, '0999', '835700', '82.51184', '43.79901', 'Nileke', '1', 0);
INSERT INTO `hh_region` VALUES (654200, '塔城地区', 650000, '塔城', 2, '0901', '834700', '82.985732', '46.746301', 'Qoqek', '1', 0);
INSERT INTO `hh_region` VALUES (654201, '塔城市', 654200, '塔城', 3, '0901', '834700', '82.97892', '46.74852', 'Tacheng', '1', 0);
INSERT INTO `hh_region` VALUES (654202, '乌苏市', 654200, '乌苏', 3, '0992', '833000', '84.68258', '44.43729', 'Wusu', '1', 0);
INSERT INTO `hh_region` VALUES (654221, '额敏县', 654200, '额敏', 3, '0901', '834600', '83.62872', '46.5284', 'Emin', '1', 0);
INSERT INTO `hh_region` VALUES (654223, '沙湾县', 654200, '沙湾', 3, '0993', '832100', '85.61932', '44.33144', 'Shawan', '1', 0);
INSERT INTO `hh_region` VALUES (654224, '托里县', 654200, '托里', 3, '0901', '834500', '83.60592', '45.93623', 'Tuoli', '1', 0);
INSERT INTO `hh_region` VALUES (654225, '裕民县', 654200, '裕民', 3, '0901', '834800', '82.99002', '46.20377', 'Yumin', '1', 0);
INSERT INTO `hh_region` VALUES (654226, '和布克赛尔蒙古自治县', 654200, '和布克赛尔', 3, '0990', '834400', '85.72662', '46.79362', 'Hebukesaier', '1', 0);
INSERT INTO `hh_region` VALUES (654300, '阿勒泰地区', 650000, '阿勒泰', 2, '0906', '836500', '88.13963', '47.848393', 'Altay', '1', 0);
INSERT INTO `hh_region` VALUES (654301, '阿勒泰市', 654300, '阿勒泰', 3, '0906', '836500', '88.13913', '47.8317', 'Aletai', '1', 0);
INSERT INTO `hh_region` VALUES (654321, '布尔津县', 654300, '布尔津', 3, '0906', '836600', '86.85751', '47.70062', 'Buerjin', '1', 0);
INSERT INTO `hh_region` VALUES (654322, '富蕴县', 654300, '富蕴', 3, '0906', '836100', '89.52679', '46.99444', 'Fuyun', '1', 0);
INSERT INTO `hh_region` VALUES (654323, '福海县', 654300, '福海', 3, '0906', '836400', '87.49508', '47.11065', 'Fuhai', '1', 0);
INSERT INTO `hh_region` VALUES (654324, '哈巴河县', 654300, '哈巴河', 3, '0906', '836700', '86.42092', '48.06046', 'Habahe', '1', 0);
INSERT INTO `hh_region` VALUES (654325, '青河县', 654300, '青河', 3, '0906', '836200', '90.38305', '46.67382', 'Qinghe', '1', 0);
INSERT INTO `hh_region` VALUES (654326, '吉木乃县', 654300, '吉木乃', 3, '0906', '836800', '85.87814', '47.43359', 'Jimunai', '1', 0);
INSERT INTO `hh_region` VALUES (659000, '直辖县级', 650000, ' ', 2, '', '', '91.132212', '29.660361', '', '1', 0);
INSERT INTO `hh_region` VALUES (659001, '石河子市', 659000, '石河子', 3, '0993', '832000', '86.041075', '44.305886', 'Shihezi', '1', 0);
INSERT INTO `hh_region` VALUES (659002, '阿拉尔市', 659000, '阿拉尔', 3, '0997', '843300', '81.285884', '40.541914', 'Aral', '1', 0);
INSERT INTO `hh_region` VALUES (659003, '图木舒克市', 659000, '图木舒克', 3, '0998', '843806', '79.077978', '39.867316', 'Tumxuk', '1', 0);
INSERT INTO `hh_region` VALUES (659004, '五家渠市', 659000, '五家渠', 3, '0994', '831300', '87.526884', '44.167401', 'Wujiaqu', '1', 0);
INSERT INTO `hh_region` VALUES (659005, '北屯市', 659000, '北屯', 3, '0906', '836000', '87.808456', '47.362308', 'Beitun', '1', 0);
INSERT INTO `hh_region` VALUES (659006, '铁门关市', 659000, '铁门关', 3, '0906', '836000', '86.194687', '41.811007', 'Tiemenguan', '1', 0);
INSERT INTO `hh_region` VALUES (659007, '双河市', 659000, '双河', 3, '0909', '833408', '91.132212', '29.660361', 'Shuanghe', '1', 0);
INSERT INTO `hh_region` VALUES (710000, '台湾', 100000, '台湾', 1, '', '', '121.509062', '25.044332', 'Taiwan', '1', 0);
INSERT INTO `hh_region` VALUES (710100, '台北市', 710000, '台北', 2, '02', '1', '121.565170', '25.037798', 'Taipei', '1', 0);
INSERT INTO `hh_region` VALUES (710101, '松山区', 710100, '松山', 3, '02', '105', '121.577206', '25.049698', 'Songshan', '1', 0);
INSERT INTO `hh_region` VALUES (710102, '信义区', 710100, '信义', 3, '02', '110', '121.751381', '25.129407', 'Xinyi', '1', 0);
INSERT INTO `hh_region` VALUES (710103, '大安区', 710100, '大安', 3, '02', '106', '121.534648', '25.026406', 'Da\'an', '1', 0);
INSERT INTO `hh_region` VALUES (710104, '中山区', 710100, '中山', 3, '02', '104', '121.533468', '25.064361', 'Zhongshan', '1', 0);
INSERT INTO `hh_region` VALUES (710105, '中正区', 710100, '中正', 3, '02', '100', '121.518267', '25.032361', 'Zhongzheng', '1', 0);
INSERT INTO `hh_region` VALUES (710106, '大同区', 710100, '大同', 3, '02', '103', '121.515514', '25.065986', 'Datong', '1', 0);
INSERT INTO `hh_region` VALUES (710107, '万华区', 710100, '万华', 3, '02', '108', '121.499332', '25.031933', 'Wanhua', '1', 0);
INSERT INTO `hh_region` VALUES (710108, '文山区', 710100, '文山', 3, '02', '116', '121.570458', '24.989786', 'Wenshan', '1', 0);
INSERT INTO `hh_region` VALUES (710109, '南港区', 710100, '南港', 3, '02', '115', '121.606858', '25.054656', 'Nangang', '1', 0);
INSERT INTO `hh_region` VALUES (710110, '内湖区', 710100, '内湖', 3, '02', '114', '121.588998', '25.069664', 'Nahu', '1', 0);
INSERT INTO `hh_region` VALUES (710111, '士林区', 710100, '士林', 3, '02', '111', '121.519874', '25.092822', 'Shilin', '1', 0);
INSERT INTO `hh_region` VALUES (710112, '北投区', 710100, '北投', 3, '02', '112', '121.501379', '25.132419', 'Beitou', '1', 0);
INSERT INTO `hh_region` VALUES (710200, '高雄市', 710000, '高雄', 2, '07', '8', '120.311922', '22.620856', 'Kaohsiung', '1', 0);
INSERT INTO `hh_region` VALUES (710201, '盐埕区', 710200, '盐埕', 3, '07', '803', '120.286795', '22.624666', 'Yancheng', '1', 0);
INSERT INTO `hh_region` VALUES (710202, '鼓山区', 710200, '鼓山', 3, '07', '804', '120.281154', '22.636797', 'Gushan', '1', 0);
INSERT INTO `hh_region` VALUES (710203, '左营区', 710200, '左营', 3, '07', '813', '120.294958', '22.690124', 'Zuoying', '1', 0);
INSERT INTO `hh_region` VALUES (710204, '楠梓区', 710200, '楠梓', 3, '07', '811', '120.326314', '22.728401', 'Nanzi', '1', 0);
INSERT INTO `hh_region` VALUES (710205, '三民区', 710200, '三民', 3, '07', '807', '120.299622', '22.647695', 'Sanmin', '1', 0);
INSERT INTO `hh_region` VALUES (710206, '新兴区', 710200, '新兴', 3, '07', '800', '120.309535', '22.631147', 'Xinxing', '1', 0);
INSERT INTO `hh_region` VALUES (710207, '前金区', 710200, '前金', 3, '07', '801', '120.294159', '22.627421', 'Qianjin', '1', 0);
INSERT INTO `hh_region` VALUES (710208, '苓雅区', 710200, '苓雅', 3, '07', '802', '120.312347', '22.621770', 'Lingya', '1', 0);
INSERT INTO `hh_region` VALUES (710209, '前镇区', 710200, '前镇', 3, '07', '806', '120.318583', '22.586425', 'Qianzhen', '1', 0);
INSERT INTO `hh_region` VALUES (710210, '旗津区', 710200, '旗津', 3, '07', '805', '120.284429', '22.590565', 'Qijin', '1', 0);
INSERT INTO `hh_region` VALUES (710211, '小港区', 710200, '小港', 3, '07', '812', '120.337970', '22.565354', 'Xiaogang', '1', 0);
INSERT INTO `hh_region` VALUES (710212, '凤山区', 710200, '凤山', 3, '07', '830', '120.356892', '22.626945', 'Fengshan', '1', 0);
INSERT INTO `hh_region` VALUES (710213, '林园区', 710200, '林园', 3, '07', '832', '120.395977', '22.501490', 'Linyuan', '1', 0);
INSERT INTO `hh_region` VALUES (710214, '大寮区', 710200, '大寮', 3, '07', '831', '120.395422', '22.605386', 'Daliao', '1', 0);
INSERT INTO `hh_region` VALUES (710215, '大树区', 710200, '大树', 3, '07', '840', '120.433095', '22.693394', 'Dashu', '1', 0);
INSERT INTO `hh_region` VALUES (710216, '大社区', 710200, '大社', 3, '07', '815', '120.346635', '22.729966', 'Dashe', '1', 0);
INSERT INTO `hh_region` VALUES (710217, '仁武区', 710200, '仁武', 3, '07', '814', '120.347779', '22.701901', 'Renwu', '1', 0);
INSERT INTO `hh_region` VALUES (710218, '鸟松区', 710200, '鸟松', 3, '07', '833', '120.364402', '22.659340', 'Niaosong', '1', 0);
INSERT INTO `hh_region` VALUES (710219, '冈山区', 710200, '冈山', 3, '07', '820', '120.295820', '22.796762', 'Gangshan', '1', 0);
INSERT INTO `hh_region` VALUES (710220, '桥头区', 710200, '桥头', 3, '07', '825', '120.305741', '22.757501', 'Qiaotou', '1', 0);
INSERT INTO `hh_region` VALUES (710221, '燕巢区', 710200, '燕巢', 3, '07', '824', '120.361956', '22.793370', 'Yanchao', '1', 0);
INSERT INTO `hh_region` VALUES (710222, '田寮区', 710200, '田寮', 3, '07', '823', '120.359636', '22.869307', 'Tianliao', '1', 0);
INSERT INTO `hh_region` VALUES (710223, '阿莲区', 710200, '阿莲', 3, '07', '822', '120.327036', '22.883703', 'Alian', '1', 0);
INSERT INTO `hh_region` VALUES (710224, '路竹区', 710200, '路竹', 3, '07', '821', '120.261828', '22.856851', 'Luzhu', '1', 0);
INSERT INTO `hh_region` VALUES (710225, '湖内区', 710200, '湖内', 3, '07', '829', '120.211530', '22.908188', 'Huna', '1', 0);
INSERT INTO `hh_region` VALUES (710226, '茄萣区', 710200, '茄萣', 3, '07', '852', '120.182815', '22.906556', 'Qieding', '1', 0);
INSERT INTO `hh_region` VALUES (710227, '永安区', 710200, '永安', 3, '07', '828', '120.225308', '22.818580', 'Yong\'an', '1', 0);
INSERT INTO `hh_region` VALUES (710228, '弥陀区', 710200, '弥陀', 3, '07', '827', '120.247344', '22.782879', 'Mituo', '1', 0);
INSERT INTO `hh_region` VALUES (710229, '梓官区', 710200, '梓官', 3, '07', '826', '120.267322', '22.760475', 'Ziguan', '1', 0);
INSERT INTO `hh_region` VALUES (710230, '旗山区', 710200, '旗山', 3, '07', '842', '120.483550', '22.888491', 'Qishan', '1', 0);
INSERT INTO `hh_region` VALUES (710231, '美浓区', 710200, '美浓', 3, '07', '843', '120.541530', '22.897880', 'Meinong', '1', 0);
INSERT INTO `hh_region` VALUES (710232, '六龟区', 710200, '六龟', 3, '07', '844', '120.633418', '22.997914', 'Liugui', '1', 0);
INSERT INTO `hh_region` VALUES (710233, '甲仙区', 710200, '甲仙', 3, '07', '847', '120.591185', '23.084688', 'Jiaxian', '1', 0);
INSERT INTO `hh_region` VALUES (710234, '杉林区', 710200, '杉林', 3, '07', '846', '120.538980', '22.970712', 'Shanlin', '1', 0);
INSERT INTO `hh_region` VALUES (710235, '内门区', 710200, '内门', 3, '07', '845', '120.462351', '22.943437', 'Namen', '1', 0);
INSERT INTO `hh_region` VALUES (710236, '茂林区', 710200, '茂林', 3, '07', '851', '120.663217', '22.886248', 'Maolin', '1', 0);
INSERT INTO `hh_region` VALUES (710237, '桃源区', 710200, '桃源', 3, '07', '848', '120.760049', '23.159137', 'Taoyuan', '1', 0);
INSERT INTO `hh_region` VALUES (710238, '那玛夏区', 710200, '那玛夏', 3, '07', '849', '120.692799', '23.216964', 'Namaxia', '1', 0);
INSERT INTO `hh_region` VALUES (710300, '基隆市', 710000, '基隆', 2, '02', '2', '121.746248', '25.130741', 'Keelung', '1', 0);
INSERT INTO `hh_region` VALUES (710301, '中正区', 710300, '中正', 3, '02', '202', '121.518267', '25.032361', 'Zhongzheng', '1', 0);
INSERT INTO `hh_region` VALUES (710302, '七堵区', 710300, '七堵', 3, '02', '206', '121.713032', '25.095739', 'Qidu', '1', 0);
INSERT INTO `hh_region` VALUES (710303, '暖暖区', 710300, '暖暖', 3, '02', '205', '121.736102', '25.099777', 'Nuannuan', '1', 0);
INSERT INTO `hh_region` VALUES (710304, '仁爱区', 710300, '仁爱', 3, '02', '200', '121.740940', '25.127526', 'Renai', '1', 0);
INSERT INTO `hh_region` VALUES (710305, '中山区', 710300, '中山', 3, '02', '203', '121.739132', '25.133991', 'Zhongshan', '1', 0);
INSERT INTO `hh_region` VALUES (710306, '安乐区', 710300, '安乐', 3, '02', '204', '121.723203', '25.120910', 'Anle', '1', 0);
INSERT INTO `hh_region` VALUES (710307, '信义区', 710300, '信义', 3, '02', '201', '121.751381', '25.129407', 'Xinyi', '1', 0);
INSERT INTO `hh_region` VALUES (710400, '台中市', 710000, '台中', 2, '04', '4', '120.679040', '24.138620', 'Taichung', '1', 0);
INSERT INTO `hh_region` VALUES (710401, '中区', 710400, '中区', 3, '04', '400', '120.679510', '24.143830', 'Zhongqu', '1', 0);
INSERT INTO `hh_region` VALUES (710402, '东区', 710400, '东区', 3, '04', '401', '120.704', '24.13662', 'Dongqu', '1', 0);
INSERT INTO `hh_region` VALUES (710403, '南区', 710400, '南区', 3, '04', '402', '120.188648', '22.960944', 'Nanqu', '1', 0);
INSERT INTO `hh_region` VALUES (710404, '西区', 710400, '西区', 3, '04', '403', '120.67104', '24.14138', 'Xiqu', '1', 0);
INSERT INTO `hh_region` VALUES (710405, '北区', 710400, '北区', 3, '04', '404', '120.682410', '24.166040', 'Beiqu', '1', 0);
INSERT INTO `hh_region` VALUES (710406, '西屯区', 710400, '西屯', 3, '04', '407', '120.639820', '24.181340', 'Xitun', '1', 0);
INSERT INTO `hh_region` VALUES (710407, '南屯区', 710400, '南屯', 3, '04', '408', '120.643080', '24.138270', 'Nantun', '1', 0);
INSERT INTO `hh_region` VALUES (710408, '北屯区', 710400, '北屯', 3, '04', '406', '120.686250', '24.182220', 'Beitun', '1', 0);
INSERT INTO `hh_region` VALUES (710409, '丰原区', 710400, '丰原', 3, '04', '420', '120.718460', '24.242190', 'Fengyuan', '1', 0);
INSERT INTO `hh_region` VALUES (710410, '东势区', 710400, '东势', 3, '04', '423', '120.827770', '24.258610', 'Dongshi', '1', 0);
INSERT INTO `hh_region` VALUES (710411, '大甲区', 710400, '大甲', 3, '04', '437', '120.622390', '24.348920', 'Dajia', '1', 0);
INSERT INTO `hh_region` VALUES (710412, '清水区', 710400, '清水', 3, '04', '436', '120.559780', '24.268650', 'Qingshui', '1', 0);
INSERT INTO `hh_region` VALUES (710413, '沙鹿区', 710400, '沙鹿', 3, '04', '433', '120.565700', '24.233480', 'Shalu', '1', 0);
INSERT INTO `hh_region` VALUES (710414, '梧栖区', 710400, '梧栖', 3, '04', '435', '120.531520', '24.254960', 'Wuqi', '1', 0);
INSERT INTO `hh_region` VALUES (710415, '后里区', 710400, '后里', 3, '04', '421', '120.710710', '24.304910', 'Houli', '1', 0);
INSERT INTO `hh_region` VALUES (710416, '神冈区', 710400, '神冈', 3, '04', '429', '120.661550', '24.257770', 'Shengang', '1', 0);
INSERT INTO `hh_region` VALUES (710417, '潭子区', 710400, '潭子', 3, '04', '427', '120.705160', '24.209530', 'Tanzi', '1', 0);
INSERT INTO `hh_region` VALUES (710418, '大雅区', 710400, '大雅', 3, '04', '428', '120.647780', '24.229230', 'Daya', '1', 0);
INSERT INTO `hh_region` VALUES (710419, '新社区', 710400, '新社', 3, '04', '426', '120.809500', '24.234140', 'Xinshe', '1', 0);
INSERT INTO `hh_region` VALUES (710420, '石冈区', 710400, '石冈', 3, '04', '422', '120.780410', '24.274980', 'Shigang', '1', 0);
INSERT INTO `hh_region` VALUES (710421, '外埔区', 710400, '外埔', 3, '04', '438', '120.654370', '24.332010', 'Waipu', '1', 0);
INSERT INTO `hh_region` VALUES (710422, '大安区', 710400, '大安', 3, '04', '439', '120.58652', '24.34607', 'Da\'an', '1', 0);
INSERT INTO `hh_region` VALUES (710423, '乌日区', 710400, '乌日', 3, '04', '414', '120.623810', '24.104500', 'Wuri', '1', 0);
INSERT INTO `hh_region` VALUES (710424, '大肚区', 710400, '大肚', 3, '04', '432', '120.540960', '24.153660', 'Dadu', '1', 0);
INSERT INTO `hh_region` VALUES (710425, '龙井区', 710400, '龙井', 3, '04', '434', '120.545940', '24.192710', 'Longjing', '1', 0);
INSERT INTO `hh_region` VALUES (710426, '雾峰区', 710400, '雾峰', 3, '04', '413', '120.700200', '24.061520', 'Wufeng', '1', 0);
INSERT INTO `hh_region` VALUES (710427, '太平区', 710400, '太平', 3, '04', '411', '120.718523', '24.126472', 'Taiping', '1', 0);
INSERT INTO `hh_region` VALUES (710428, '大里区', 710400, '大里', 3, '04', '412', '120.677860', '24.099390', 'Dali', '1', 0);
INSERT INTO `hh_region` VALUES (710429, '和平区', 710400, '和平', 3, '04', '424', '120.88349', '24.17477', 'Heping', '1', 0);
INSERT INTO `hh_region` VALUES (710500, '台南市', 710000, '台南', 2, '06', '7', '120.279363', '23.172478', 'Tainan', '1', 0);
INSERT INTO `hh_region` VALUES (710501, '东区', 710500, '东区', 3, '06', '701', '120.224198', '22.980072', 'Dongqu', '1', 0);
INSERT INTO `hh_region` VALUES (710502, '南区', 710500, '南区', 3, '06', '702', '120.188648', '22.960944', 'Nanqu', '1', 0);
INSERT INTO `hh_region` VALUES (710504, '北区', 710500, '北区', 3, '06', '704', '120.682410', '24.166040', 'Beiqu', '1', 0);
INSERT INTO `hh_region` VALUES (710506, '安南区', 710500, '安南', 3, '06', '709', '120.184617', '23.047230', 'Annan', '1', 0);
INSERT INTO `hh_region` VALUES (710507, '安平区', 710500, '安平', 3, '06', '708', '120.166810', '23.000763', 'Anping', '1', 0);
INSERT INTO `hh_region` VALUES (710508, '中西区', 710500, '中西', 3, '06', '700', '120.205957', '22.992152', 'Zhongxi', '1', 0);
INSERT INTO `hh_region` VALUES (710509, '新营区', 710500, '新营', 3, '06', '730', '120.316698', '23.310274', 'Xinying', '1', 0);
INSERT INTO `hh_region` VALUES (710510, '盐水区', 710500, '盐水', 3, '06', '737', '120.266398', '23.319828', 'Yanshui', '1', 0);
INSERT INTO `hh_region` VALUES (710511, '白河区', 710500, '白河', 3, '06', '732', '120.415810', '23.351221', 'Baihe', '1', 0);
INSERT INTO `hh_region` VALUES (710512, '柳营区', 710500, '柳营', 3, '06', '736', '120.311286', '23.278133', 'Liuying', '1', 0);
INSERT INTO `hh_region` VALUES (710513, '后壁区', 710500, '后壁', 3, '06', '731', '120.362726', '23.366721', 'Houbi', '1', 0);
INSERT INTO `hh_region` VALUES (710514, '东山区', 710500, '东山', 3, '06', '733', '120.403984', '23.326092', 'Dongshan', '1', 0);
INSERT INTO `hh_region` VALUES (710515, '麻豆区', 710500, '麻豆', 3, '06', '721', '120.248179', '23.181680', 'Madou', '1', 0);
INSERT INTO `hh_region` VALUES (710516, '下营区', 710500, '下营', 3, '06', '735', '120.264484', '23.235413', 'Xiaying', '1', 0);
INSERT INTO `hh_region` VALUES (710517, '六甲区', 710500, '六甲', 3, '06', '734', '120.347600', '23.231931', 'Liujia', '1', 0);
INSERT INTO `hh_region` VALUES (710518, '官田区', 710500, '官田', 3, '06', '720', '120.314374', '23.194652', 'Guantian', '1', 0);
INSERT INTO `hh_region` VALUES (710519, '大内区', 710500, '大内', 3, '06', '742', '120.348853', '23.119460', 'Dana', '1', 0);
INSERT INTO `hh_region` VALUES (710520, '佳里区', 710500, '佳里', 3, '06', '722', '120.177211', '23.165121', 'Jiali', '1', 0);
INSERT INTO `hh_region` VALUES (710521, '学甲区', 710500, '学甲', 3, '06', '726', '120.180255', '23.232348', 'Xuejia', '1', 0);
INSERT INTO `hh_region` VALUES (710522, '西港区', 710500, '西港', 3, '06', '723', '120.203618', '23.123057', 'Xigang', '1', 0);
INSERT INTO `hh_region` VALUES (710523, '七股区', 710500, '七股', 3, '06', '724', '120.140003', '23.140545', 'Qigu', '1', 0);
INSERT INTO `hh_region` VALUES (710524, '将军区', 710500, '将军', 3, '06', '725', '120.156871', '23.199543', 'Jiangjun', '1', 0);
INSERT INTO `hh_region` VALUES (710525, '北门区', 710500, '北门', 3, '06', '727', '120.125821', '23.267148', 'Beimen', '1', 0);
INSERT INTO `hh_region` VALUES (710526, '新化区', 710500, '新化', 3, '06', '712', '120.310807', '23.038533', 'Xinhua', '1', 0);
INSERT INTO `hh_region` VALUES (710527, '善化区', 710500, '善化', 3, '06', '741', '120.296895', '23.132261', 'Shanhua', '1', 0);
INSERT INTO `hh_region` VALUES (710528, '新市区', 710500, '新市', 3, '06', '744', '120.295138', '23.07897', 'Xinshi', '1', 0);
INSERT INTO `hh_region` VALUES (710529, '安定区', 710500, '安定', 3, '06', '745', '120.237083', '23.121498', 'Anding', '1', 0);
INSERT INTO `hh_region` VALUES (710530, '山上区', 710500, '山上', 3, '06', '743', '120.352908', '23.103223', 'Shanshang', '1', 0);
INSERT INTO `hh_region` VALUES (710531, '玉井区', 710500, '玉井', 3, '06', '714', '120.460110', '23.123859', 'Yujing', '1', 0);
INSERT INTO `hh_region` VALUES (710532, '楠西区', 710500, '楠西', 3, '06', '715', '120.485396', '23.173454', 'Nanxi', '1', 0);
INSERT INTO `hh_region` VALUES (710533, '南化区', 710500, '南化', 3, '06', '716', '120.477116', '23.042614', 'Nanhua', '1', 0);
INSERT INTO `hh_region` VALUES (710534, '左镇区', 710500, '左镇', 3, '06', '713', '120.407309', '23.057955', 'Zuozhen', '1', 0);
INSERT INTO `hh_region` VALUES (710535, '仁德区', 710500, '仁德', 3, '06', '717', '120.251520', '22.972212', 'Rende', '1', 0);
INSERT INTO `hh_region` VALUES (710536, '归仁区', 710500, '归仁', 3, '06', '711', '120.293791', '22.967081', 'Guiren', '1', 0);
INSERT INTO `hh_region` VALUES (710537, '关庙区', 710500, '关庙', 3, '06', '718', '120.327689', '22.962949', 'Guanmiao', '1', 0);
INSERT INTO `hh_region` VALUES (710538, '龙崎区', 710500, '龙崎', 3, '06', '719', '120.360824', '22.965681', 'Longqi', '1', 0);
INSERT INTO `hh_region` VALUES (710539, '永康区', 710500, '永康', 3, '06', '710', '120.257069', '23.026061', 'Yongkang', '1', 0);
INSERT INTO `hh_region` VALUES (710600, '新竹市', 710000, '新竹', 2, '03', '3', '120.968798', '24.806738', 'Hsinchu', '1', 0);
INSERT INTO `hh_region` VALUES (710601, '东区', 710600, '东区', 3, '03', '300', '120.970239', '24.801337', 'Dongqu', '1', 0);
INSERT INTO `hh_region` VALUES (710602, '北区', 710600, '北区', 3, '03', '', '120.682410', '24.166040', 'Beiqu', '1', 0);
INSERT INTO `hh_region` VALUES (710603, '香山区', 710600, '香山', 3, '03', '', '120.956679', '24.768933', 'Xiangshan', '1', 0);
INSERT INTO `hh_region` VALUES (710700, '嘉义市', 710000, '嘉义', 2, '05', '6', '120.452538', '23.481568', 'Chiayi', '1', 0);
INSERT INTO `hh_region` VALUES (710701, '东区', 710700, '东区', 3, '05', '600', '120.458009', '23.486213', 'Dongqu', '1', 0);
INSERT INTO `hh_region` VALUES (710702, '西区', 710700, '西区', 3, '05', '600', '120.437493', '23.473029', 'Xiqu', '1', 0);
INSERT INTO `hh_region` VALUES (710800, '新北市', 710000, '新北', 2, '02', '2', '121.465746', '25.012366', 'New Taipei', '1', 0);
INSERT INTO `hh_region` VALUES (710801, '板桥区', 710800, '板桥', 3, '02', '220', '121.459084', '25.009578', 'Banqiao', '1', 0);
INSERT INTO `hh_region` VALUES (710802, '三重区', 710800, '三重', 3, '02', '241', '121.488102', '25.061486', 'Sanzhong', '1', 0);
INSERT INTO `hh_region` VALUES (710803, '中和区', 710800, '中和', 3, '02', '235', '121.498980', '24.999397', 'Zhonghe', '1', 0);
INSERT INTO `hh_region` VALUES (710804, '永和区', 710800, '永和', 3, '02', '234', '121.513660', '25.007802', 'Yonghe', '1', 0);
INSERT INTO `hh_region` VALUES (710805, '新庄区', 710800, '新庄', 3, '02', '242', '121.450413', '25.035947', 'Xinzhuang', '1', 0);
INSERT INTO `hh_region` VALUES (710806, '新店区', 710800, '新店', 3, '02', '231', '121.541750', '24.967558', 'Xindian', '1', 0);
INSERT INTO `hh_region` VALUES (710807, '树林区', 710800, '树林', 3, '02', '238', '121.420533', '24.990706', 'Shulin', '1', 0);
INSERT INTO `hh_region` VALUES (710808, '莺歌区', 710800, '莺歌', 3, '02', '239', '121.354573', '24.955413', 'Yingge', '1', 0);
INSERT INTO `hh_region` VALUES (710809, '三峡区', 710800, '三峡', 3, '02', '237', '121.368905', '24.934339', 'Sanxia', '1', 0);
INSERT INTO `hh_region` VALUES (710810, '淡水区', 710800, '淡水', 3, '02', '251', '121.440915', '25.169452', 'Danshui', '1', 0);
INSERT INTO `hh_region` VALUES (710811, '汐止区', 710800, '汐止', 3, '02', '221', '121.629470', '25.062999', 'Xizhi', '1', 0);
INSERT INTO `hh_region` VALUES (710812, '瑞芳区', 710800, '瑞芳', 3, '02', '224', '121.810061', '25.108895', 'Ruifang', '1', 0);
INSERT INTO `hh_region` VALUES (710813, '土城区', 710800, '土城', 3, '02', '236', '121.443348', '24.972201', 'Tucheng', '1', 0);
INSERT INTO `hh_region` VALUES (710814, '芦洲区', 710800, '芦洲', 3, '02', '247', '121.473700', '25.084923', 'Luzhou', '1', 0);
INSERT INTO `hh_region` VALUES (710815, '五股区', 710800, '五股', 3, '02', '248', '121.438156', '25.082743', 'Wugu', '1', 0);
INSERT INTO `hh_region` VALUES (710816, '泰山区', 710800, '泰山', 3, '02', '243', '121.430811', '25.058864', 'Taishan', '1', 0);
INSERT INTO `hh_region` VALUES (710817, '林口区', 710800, '林口', 3, '02', '244', '121.391602', '25.077531', 'Linkou', '1', 0);
INSERT INTO `hh_region` VALUES (710818, '深坑区', 710800, '深坑', 3, '02', '222', '121.615670', '25.002329', 'Shenkeng', '1', 0);
INSERT INTO `hh_region` VALUES (710819, '石碇区', 710800, '石碇', 3, '02', '223', '121.658567', '24.991679', 'Shiding', '1', 0);
INSERT INTO `hh_region` VALUES (710820, '坪林区', 710800, '坪林', 3, '02', '232', '121.711185', '24.937388', 'Pinglin', '1', 0);
INSERT INTO `hh_region` VALUES (710821, '三芝区', 710800, '三芝', 3, '02', '252', '121.500866', '25.258047', 'Sanzhi', '1', 0);
INSERT INTO `hh_region` VALUES (710822, '石门区', 710800, '石门', 3, '02', '253', '121.568491', '25.290412', 'Shimen', '1', 0);
INSERT INTO `hh_region` VALUES (710823, '八里区', 710800, '八里', 3, '02', '249', '121.398227', '25.146680', 'Bali', '1', 0);
INSERT INTO `hh_region` VALUES (710824, '平溪区', 710800, '平溪', 3, '02', '226', '121.738255', '25.025725', 'Pingxi', '1', 0);
INSERT INTO `hh_region` VALUES (710825, '双溪区', 710800, '双溪', 3, '02', '227', '121.865676', '25.033409', 'Shuangxi', '1', 0);
INSERT INTO `hh_region` VALUES (710826, '贡寮区', 710800, '贡寮', 3, '02', '228', '121.908185', '25.022388', 'Gongliao', '1', 0);
INSERT INTO `hh_region` VALUES (710827, '金山区', 710800, '金山', 3, '02', '208', '121.636427', '25.221883', 'Jinshan', '1', 0);
INSERT INTO `hh_region` VALUES (710828, '万里区', 710800, '万里', 3, '02', '207', '121.688687', '25.181234', 'Wanli', '1', 0);
INSERT INTO `hh_region` VALUES (710829, '乌来区', 710800, '乌来', 3, '02', '233', '121.550531', '24.865296', 'Wulai', '1', 0);
INSERT INTO `hh_region` VALUES (712200, '宜兰县', 710000, '宜兰', 2, '03', '2', '121.500000', '24.600000', 'Yilan', '1', 0);
INSERT INTO `hh_region` VALUES (712201, '宜兰市', 712200, '宜兰', 3, '03', '260', '121.753476', '24.751682', 'Yilan', '1', 0);
INSERT INTO `hh_region` VALUES (712221, '罗东镇', 712200, '罗东', 3, '03', '265', '121.766919', '24.677033', 'Luodong', '1', 0);
INSERT INTO `hh_region` VALUES (712222, '苏澳镇', 712200, '苏澳', 3, '03', '270', '121.842656', '24.594622', 'Suao', '1', 0);
INSERT INTO `hh_region` VALUES (712223, '头城镇', 712200, '头城', 3, '03', '261', '121.823307', '24.859217', 'Toucheng', '1', 0);
INSERT INTO `hh_region` VALUES (712224, '礁溪乡', 712200, '礁溪', 3, '03', '262', '121.766680', '24.822345', 'Jiaoxi', '1', 0);
INSERT INTO `hh_region` VALUES (712225, '壮围乡', 712200, '壮围', 3, '03', '263', '121.781619', '24.744949', 'Zhuangwei', '1', 0);
INSERT INTO `hh_region` VALUES (712226, '员山乡', 712200, '员山', 3, '03', '264', '121.721733', '24.741771', 'Yuanshan', '1', 0);
INSERT INTO `hh_region` VALUES (712227, '冬山乡', 712200, '冬山', 3, '03', '269', '121.792280', '24.634514', 'Dongshan', '1', 0);
INSERT INTO `hh_region` VALUES (712228, '五结乡', 712200, '五结', 3, '03', '268', '121.798297', '24.684640', 'Wujie', '1', 0);
INSERT INTO `hh_region` VALUES (712229, '三星乡', 712200, '三星', 3, '03', '266', '121.003418', '23.775291', 'Sanxing', '1', 0);
INSERT INTO `hh_region` VALUES (712230, '大同乡', 712200, '大同', 3, '03', '267', '121.605557', '24.675997', 'Datong', '1', 0);
INSERT INTO `hh_region` VALUES (712231, '南澳乡', 712200, '南澳', 3, '03', '272', '121.799810', '24.465393', 'Nanao', '1', 0);
INSERT INTO `hh_region` VALUES (712300, '桃园县', 710000, '桃园', 2, '03', '3', '121.083000', '25.000000', 'Taoyuan', '1', 0);
INSERT INTO `hh_region` VALUES (712301, '桃园市', 712300, '桃园', 3, '03', '330', '121.301337', '24.993777', 'Taoyuan', '1', 0);
INSERT INTO `hh_region` VALUES (712302, '中坜市', 712300, '中坜', 3, '03', '320', '121.224926', '24.965353', 'Zhongli', '1', 0);
INSERT INTO `hh_region` VALUES (712303, '平镇市', 712300, '平镇', 3, '03', '324', '121.218359', '24.945752', 'Pingzhen', '1', 0);
INSERT INTO `hh_region` VALUES (712304, '八德市', 712300, '八德', 3, '03', '334', '121.284655', '24.928651', 'Bade', '1', 0);
INSERT INTO `hh_region` VALUES (712305, '杨梅市', 712300, '杨梅', 3, '03', '326', '121.145873', '24.907575', 'Yangmei', '1', 0);
INSERT INTO `hh_region` VALUES (712306, '芦竹市', 712300, '芦竹', 3, '03', '338', '121.292064', '25.045392', 'Luzhu', '1', 0);
INSERT INTO `hh_region` VALUES (712321, '大溪镇', 712300, '大溪', 3, '03', '335', '121.286962', '24.880584', 'Daxi', '1', 0);
INSERT INTO `hh_region` VALUES (712324, '大园乡', 712300, '大园', 3, '03', '337', '121.196292', '25.064471', 'Dayuan', '1', 0);
INSERT INTO `hh_region` VALUES (712325, '龟山乡', 712300, '龟山', 3, '03', '333', '121.337767', '24.992517', 'Guishan', '1', 0);
INSERT INTO `hh_region` VALUES (712327, '龙潭乡', 712300, '龙潭', 3, '03', '325', '121.216392', '24.863851', 'Longtan', '1', 0);
INSERT INTO `hh_region` VALUES (712329, '新屋乡', 712300, '新屋', 3, '03', '327', '121.105801', '24.972203', 'Xinwu', '1', 0);
INSERT INTO `hh_region` VALUES (712330, '观音乡', 712300, '观音', 3, '03', '328', '121.077519', '25.033303', 'Guanyin', '1', 0);
INSERT INTO `hh_region` VALUES (712331, '复兴乡', 712300, '复兴', 3, '03', '336', '121.352613', '24.820908', 'Fuxing', '1', 0);
INSERT INTO `hh_region` VALUES (712400, '新竹县', 710000, '新竹', 2, '03', '3', '121.160000', '24.600000', 'Hsinchu', '1', 0);
INSERT INTO `hh_region` VALUES (712401, '竹北市', 712400, '竹北', 3, '03', '302', '121.004317', '24.839652', 'Zhubei', '1', 0);
INSERT INTO `hh_region` VALUES (712421, '竹东镇', 712400, '竹东', 3, '03', '310', '121.086418', '24.733601', 'Zhudong', '1', 0);
INSERT INTO `hh_region` VALUES (712422, '新埔镇', 712400, '新埔', 3, '03', '305', '121.072804', '24.824820', 'Xinpu', '1', 0);
INSERT INTO `hh_region` VALUES (712423, '关西镇', 712400, '关西', 3, '03', '306', '121.177301', '24.788842', 'Guanxi', '1', 0);
INSERT INTO `hh_region` VALUES (712424, '湖口乡', 712400, '湖口', 3, '03', '303', '121.043691', '24.903943', 'Hukou', '1', 0);
INSERT INTO `hh_region` VALUES (712425, '新丰乡', 712400, '新丰', 3, '03', '304', '120.983006', '24.899600', 'Xinfeng', '1', 0);
INSERT INTO `hh_region` VALUES (712426, '芎林乡', 712400, '芎林', 3, '03', '307', '121.076924', '24.774436', 'Xionglin', '1', 0);
INSERT INTO `hh_region` VALUES (712427, '横山乡', 712400, '横山', 3, '03', '312', '121.116244', '24.720807', 'Hengshan', '1', 0);
INSERT INTO `hh_region` VALUES (712428, '北埔乡', 712400, '北埔', 3, '03', '314', '121.053156', '24.697126', 'Beipu', '1', 0);
INSERT INTO `hh_region` VALUES (712429, '宝山乡', 712400, '宝山', 3, '03', '308', '120.985752', '24.760975', 'Baoshan', '1', 0);
INSERT INTO `hh_region` VALUES (712430, '峨眉乡', 712400, '峨眉', 3, '03', '315', '121.015291', '24.686127', 'Emei', '1', 0);
INSERT INTO `hh_region` VALUES (712431, '尖石乡', 712400, '尖石', 3, '03', '313', '121.197802', '24.704360', 'Jianshi', '1', 0);
INSERT INTO `hh_region` VALUES (712432, '五峰乡', 712400, '五峰', 3, '03', '311', '121.003418', '23.775291', 'Wufeng', '1', 0);
INSERT INTO `hh_region` VALUES (712500, '苗栗县', 710000, '苗栗', 2, '037', '3', '120.750000', '24.500000', 'Miaoli', '1', 0);
INSERT INTO `hh_region` VALUES (712501, '苗栗市', 712500, '苗栗', 3, '037', '360', '120.818869', '24.561472', 'Miaoli', '1', 0);
INSERT INTO `hh_region` VALUES (712521, '苑里镇', 712500, '苑里', 3, '037', '358', '120.648907', '24.441750', 'Yuanli', '1', 0);
INSERT INTO `hh_region` VALUES (712522, '通霄镇', 712500, '通霄', 3, '037', '357', '120.676700', '24.489087', 'Tongxiao', '1', 0);
INSERT INTO `hh_region` VALUES (712523, '竹南镇', 712500, '竹南', 3, '037', '350', '120.872641', '24.685513', 'Zhunan', '1', 0);
INSERT INTO `hh_region` VALUES (712524, '头份镇', 712500, '头份', 3, '037', '351', '120.895188', '24.687993', 'Toufen', '1', 0);
INSERT INTO `hh_region` VALUES (712525, '后龙镇', 712500, '后龙', 3, '037', '356', '120.786480', '24.612617', 'Houlong', '1', 0);
INSERT INTO `hh_region` VALUES (712526, '卓兰镇', 712500, '卓兰', 3, '037', '369', '120.823441', '24.309509', 'Zhuolan', '1', 0);
INSERT INTO `hh_region` VALUES (712527, '大湖乡', 712500, '大湖', 3, '037', '364', '120.863641', '24.422547', 'Dahu', '1', 0);
INSERT INTO `hh_region` VALUES (712528, '公馆乡', 712500, '公馆', 3, '037', '363', '120.822983', '24.499108', 'Gongguan', '1', 0);
INSERT INTO `hh_region` VALUES (712529, '铜锣乡', 712500, '铜锣', 3, '037', '366', '121.003418', '23.775291', 'Tongluo', '1', 0);
INSERT INTO `hh_region` VALUES (712530, '南庄乡', 712500, '南庄', 3, '037', '353', '120.994957', '24.596835', 'Nanzhuang', '1', 0);
INSERT INTO `hh_region` VALUES (712531, '头屋乡', 712500, '头屋', 3, '037', '362', '120.846616', '24.574249', 'Touwu', '1', 0);
INSERT INTO `hh_region` VALUES (712532, '三义乡', 712500, '三义', 3, '037', '367', '120.742340', '24.350270', 'Sanyi', '1', 0);
INSERT INTO `hh_region` VALUES (712533, '西湖乡', 712500, '西湖', 3, '037', '368', '121.003418', '23.775291', 'Xihu', '1', 0);
INSERT INTO `hh_region` VALUES (712534, '造桥乡', 712500, '造桥', 3, '037', '361', '120.862399', '24.637537', 'Zaoqiao', '1', 0);
INSERT INTO `hh_region` VALUES (712535, '三湾乡', 712500, '三湾', 3, '037', '352', '120.951484', '24.651051', 'Sanwan', '1', 0);
INSERT INTO `hh_region` VALUES (712536, '狮潭乡', 712500, '狮潭', 3, '037', '354', '120.918024', '24.540004', 'Shitan', '1', 0);
INSERT INTO `hh_region` VALUES (712537, '泰安乡', 712500, '泰安', 3, '037', '365', '120.904441', '24.442600', 'Tai\'an', '1', 0);
INSERT INTO `hh_region` VALUES (712700, '彰化县', 710000, '彰化', 2, '04', '5', '120.416000', '24.000000', 'Changhua', '1', 0);
INSERT INTO `hh_region` VALUES (712701, '彰化市', 712700, '彰化市', 3, '04', '500', '120.542294', '24.080911', 'Zhanghuashi', '1', 0);
INSERT INTO `hh_region` VALUES (712721, '鹿港镇', 712700, '鹿港', 3, '04', '505', '120.435392', '24.056937', 'Lugang', '1', 0);
INSERT INTO `hh_region` VALUES (712722, '和美镇', 712700, '和美', 3, '04', '508', '120.500265', '24.110904', 'Hemei', '1', 0);
INSERT INTO `hh_region` VALUES (712723, '线西乡', 712700, '线西', 3, '04', '507', '120.465921', '24.128653', 'Xianxi', '1', 0);
INSERT INTO `hh_region` VALUES (712724, '伸港乡', 712700, '伸港', 3, '04', '509', '120.484224', '24.146081', 'Shengang', '1', 0);
INSERT INTO `hh_region` VALUES (712725, '福兴乡', 712700, '福兴', 3, '04', '506', '120.443682', '24.047883', 'Fuxing', '1', 0);
INSERT INTO `hh_region` VALUES (712726, '秀水乡', 712700, '秀水', 3, '04', '504', '120.502658', '24.035267', 'Xiushui', '1', 0);
INSERT INTO `hh_region` VALUES (712727, '花坛乡', 712700, '花坛', 3, '04', '503', '120.538403', '24.029399', 'Huatan', '1', 0);
INSERT INTO `hh_region` VALUES (712728, '芬园乡', 712700, '芬园', 3, '04', '502', '120.629024', '24.013658', 'Fenyuan', '1', 0);
INSERT INTO `hh_region` VALUES (712729, '员林镇', 712700, '员林', 3, '04', '510', '120.574625', '23.958999', 'Yuanlin', '1', 0);
INSERT INTO `hh_region` VALUES (712730, '溪湖镇', 712700, '溪湖', 3, '04', '514', '120.479144', '23.962315', 'Xihu', '1', 0);
INSERT INTO `hh_region` VALUES (712731, '田中镇', 712700, '田中', 3, '04', '520', '120.580629', '23.861718', 'Tianzhong', '1', 0);
INSERT INTO `hh_region` VALUES (712732, '大村乡', 712700, '大村', 3, '04', '515', '120.540713', '23.993726', 'Dacun', '1', 0);
INSERT INTO `hh_region` VALUES (712733, '埔盐乡', 712700, '埔盐', 3, '04', '516', '120.464044', '24.000346', 'Puyan', '1', 0);
INSERT INTO `hh_region` VALUES (712734, '埔心乡', 712700, '埔心', 3, '04', '513', '120.543568', '23.953019', 'Puxin', '1', 0);
INSERT INTO `hh_region` VALUES (712735, '永靖乡', 712700, '永靖', 3, '04', '512', '120.547775', '23.924703', 'Yongjing', '1', 0);
INSERT INTO `hh_region` VALUES (712736, '社头乡', 712700, '社头', 3, '04', '511', '120.582681', '23.896686', 'Shetou', '1', 0);
INSERT INTO `hh_region` VALUES (712737, '二水乡', 712700, '二水', 3, '04', '530', '120.618788', '23.806995', 'Ershui', '1', 0);
INSERT INTO `hh_region` VALUES (712738, '北斗镇', 712700, '北斗', 3, '04', '521', '120.520449', '23.870911', 'Beidou', '1', 0);
INSERT INTO `hh_region` VALUES (712739, '二林镇', 712700, '二林', 3, '04', '526', '120.374468', '23.899751', 'Erlin', '1', 0);
INSERT INTO `hh_region` VALUES (712740, '田尾乡', 712700, '田尾', 3, '04', '522', '120.524717', '23.890735', 'Tianwei', '1', 0);
INSERT INTO `hh_region` VALUES (712741, '埤头乡', 712700, '埤头', 3, '04', '523', '120.462599', '23.891324', 'Pitou', '1', 0);
INSERT INTO `hh_region` VALUES (712742, '芳苑乡', 712700, '芳苑', 3, '04', '528', '120.320329', '23.924222', 'Fangyuan', '1', 0);
INSERT INTO `hh_region` VALUES (712743, '大城乡', 712700, '大城', 3, '04', '527', '120.320934', '23.852382', 'Dacheng', '1', 0);
INSERT INTO `hh_region` VALUES (712744, '竹塘乡', 712700, '竹塘', 3, '04', '525', '120.427499', '23.860112', 'Zhutang', '1', 0);
INSERT INTO `hh_region` VALUES (712745, '溪州乡', 712700, '溪州', 3, '04', '524', '120.498706', '23.851229', 'Xizhou', '1', 0);
INSERT INTO `hh_region` VALUES (712800, '南投县', 710000, '南投', 2, '049', '5', '120.830000', '23.830000', 'Nantou', '1', 0);
INSERT INTO `hh_region` VALUES (712801, '南投市', 712800, '南投市', 3, '049', '540', '120.683706', '23.909956', 'Nantoushi', '1', 0);
INSERT INTO `hh_region` VALUES (712821, '埔里镇', 712800, '埔里', 3, '049', '545', '120.964648', '23.964789', 'Puli', '1', 0);
INSERT INTO `hh_region` VALUES (712822, '草屯镇', 712800, '草屯', 3, '049', '542', '120.680343', '23.973947', 'Caotun', '1', 0);
INSERT INTO `hh_region` VALUES (712823, '竹山镇', 712800, '竹山', 3, '049', '557', '120.672007', '23.757655', 'Zhushan', '1', 0);
INSERT INTO `hh_region` VALUES (712824, '集集镇', 712800, '集集', 3, '049', '552', '120.783673', '23.829013', 'Jiji', '1', 0);
INSERT INTO `hh_region` VALUES (712825, '名间乡', 712800, '名间', 3, '049', '551', '120.702797', '23.838427', 'Mingjian', '1', 0);
INSERT INTO `hh_region` VALUES (712826, '鹿谷乡', 712800, '鹿谷', 3, '049', '558', '120.752796', '23.744471', 'Lugu', '1', 0);
INSERT INTO `hh_region` VALUES (712827, '中寮乡', 712800, '中寮', 3, '049', '541', '120.766654', '23.878935', 'Zhongliao', '1', 0);
INSERT INTO `hh_region` VALUES (712828, '鱼池乡', 712800, '鱼池', 3, '049', '555', '120.936060', '23.896356', 'Yuchi', '1', 0);
INSERT INTO `hh_region` VALUES (712829, '国姓乡', 712800, '国姓', 3, '049', '544', '120.858541', '24.042298', 'Guoxing', '1', 0);
INSERT INTO `hh_region` VALUES (712830, '水里乡', 712800, '水里', 3, '049', '553', '120.855912', '23.812086', 'Shuili', '1', 0);
INSERT INTO `hh_region` VALUES (712831, '信义乡', 712800, '信义', 3, '049', '556', '120.855257', '23.699922', 'Xinyi', '1', 0);
INSERT INTO `hh_region` VALUES (712832, '仁爱乡', 712800, '仁爱', 3, '049', '546', '121.133543', '24.024429', 'Renai', '1', 0);
INSERT INTO `hh_region` VALUES (712900, '云林县', 710000, '云林', 2, '05', '6', '120.250000', '23.750000', 'Yunlin', '1', 0);
INSERT INTO `hh_region` VALUES (712901, '斗六市', 712900, '斗六', 3, '05', '640', '120.527360', '23.697651', 'Douliu', '1', 0);
INSERT INTO `hh_region` VALUES (712921, '斗南镇', 712900, '斗南', 3, '05', '630', '120.479075', '23.679731', 'Dounan', '1', 0);
INSERT INTO `hh_region` VALUES (712922, '虎尾镇', 712900, '虎尾', 3, '05', '632', '120.445339', '23.708182', 'Huwei', '1', 0);
INSERT INTO `hh_region` VALUES (712923, '西螺镇', 712900, '西螺', 3, '05', '648', '120.466010', '23.797984', 'Xiluo', '1', 0);
INSERT INTO `hh_region` VALUES (712924, '土库镇', 712900, '土库', 3, '05', '633', '120.392572', '23.677822', 'Tuku', '1', 0);
INSERT INTO `hh_region` VALUES (712925, '北港镇', 712900, '北港', 3, '05', '651', '120.302393', '23.575525', 'Beigang', '1', 0);
INSERT INTO `hh_region` VALUES (712926, '古坑乡', 712900, '古坑', 3, '05', '646', '120.562043', '23.642568', 'Gukeng', '1', 0);
INSERT INTO `hh_region` VALUES (712927, '大埤乡', 712900, '大埤', 3, '05', '631', '120.430516', '23.645908', 'Dapi', '1', 0);
INSERT INTO `hh_region` VALUES (712928, '莿桐乡', 712900, '莿桐', 3, '05', '647', '120.502374', '23.760784', 'Citong', '1', 0);
INSERT INTO `hh_region` VALUES (712929, '林内乡', 712900, '林内', 3, '05', '643', '120.611365', '23.758712', 'Linna', '1', 0);
INSERT INTO `hh_region` VALUES (712930, '二仑乡', 712900, '二仑', 3, '05', '649', '120.415077', '23.771273', 'Erlun', '1', 0);
INSERT INTO `hh_region` VALUES (712931, '仑背乡', 712900, '仑背', 3, '05', '637', '120.353895', '23.758840', 'Lunbei', '1', 0);
INSERT INTO `hh_region` VALUES (712932, '麦寮乡', 712900, '麦寮', 3, '05', '638', '120.252043', '23.753841', 'Mailiao', '1', 0);
INSERT INTO `hh_region` VALUES (712933, '东势乡', 712900, '东势', 3, '05', '635', '120.252672', '23.674679', 'Dongshi', '1', 0);
INSERT INTO `hh_region` VALUES (712934, '褒忠乡', 712900, '褒忠', 3, '05', '634', '120.310488', '23.694245', 'Baozhong', '1', 0);
INSERT INTO `hh_region` VALUES (712935, '台西乡', 712900, '台西', 3, '05', '636', '120.196141', '23.702819', 'Taixi', '1', 0);
INSERT INTO `hh_region` VALUES (712936, '元长乡', 712900, '元长', 3, '05', '655', '120.315124', '23.649458', 'Yuanchang', '1', 0);
INSERT INTO `hh_region` VALUES (712937, '四湖乡', 712900, '四湖', 3, '05', '654', '120.225741', '23.637740', 'Sihu', '1', 0);
INSERT INTO `hh_region` VALUES (712938, '口湖乡', 712900, '口湖', 3, '05', '653', '120.185370', '23.582406', 'Kouhu', '1', 0);
INSERT INTO `hh_region` VALUES (712939, '水林乡', 712900, '水林', 3, '05', '652', '120.245948', '23.572634', 'Shuilin', '1', 0);
INSERT INTO `hh_region` VALUES (713000, '嘉义县', 710000, '嘉义', 2, '05', '6', '120.300000', '23.500000', 'Chiayi', '1', 0);
INSERT INTO `hh_region` VALUES (713001, '太保市', 713000, '太保', 3, '05', '612', '120.332876', '23.459647', 'Taibao', '1', 0);
INSERT INTO `hh_region` VALUES (713002, '朴子市', 713000, '朴子', 3, '05', '613', '120.247014', '23.464961', 'Puzi', '1', 0);
INSERT INTO `hh_region` VALUES (713023, '布袋镇', 713000, '布袋', 3, '05', '625', '120.166936', '23.377979', 'Budai', '1', 0);
INSERT INTO `hh_region` VALUES (713024, '大林镇', 713000, '大林', 3, '05', '622', '120.471336', '23.603815', 'Dalin', '1', 0);
INSERT INTO `hh_region` VALUES (713025, '民雄乡', 713000, '民雄', 3, '05', '621', '120.428577', '23.551456', 'Minxiong', '1', 0);
INSERT INTO `hh_region` VALUES (713026, '溪口乡', 713000, '溪口', 3, '05', '623', '120.393822', '23.602223', 'Xikou', '1', 0);
INSERT INTO `hh_region` VALUES (713027, '新港乡', 713000, '新港', 3, '05', '616', '120.347647', '23.551806', 'Xingang', '1', 0);
INSERT INTO `hh_region` VALUES (713028, '六脚乡', 713000, '六脚', 3, '05', '615', '120.291083', '23.493942', 'Liujiao', '1', 0);
INSERT INTO `hh_region` VALUES (713029, '东石乡', 713000, '东石', 3, '05', '614', '120.153822', '23.459235', 'Dongshi', '1', 0);
INSERT INTO `hh_region` VALUES (713030, '义竹乡', 713000, '义竹', 3, '05', '624', '120.243423', '23.336277', 'Yizhu', '1', 0);
INSERT INTO `hh_region` VALUES (713031, '鹿草乡', 713000, '鹿草', 3, '05', '611', '120.308370', '23.410784', 'Lucao', '1', 0);
INSERT INTO `hh_region` VALUES (713032, '水上乡', 713000, '水上', 3, '05', '608', '120.397936', '23.428104', 'Shuishang', '1', 0);
INSERT INTO `hh_region` VALUES (713033, '中埔乡', 713000, '中埔', 3, '05', '606', '120.522948', '23.425148', 'Zhongpu', '1', 0);
INSERT INTO `hh_region` VALUES (713034, '竹崎乡', 713000, '竹崎', 3, '05', '604', '120.551466', '23.523184', 'Zhuqi', '1', 0);
INSERT INTO `hh_region` VALUES (713035, '梅山乡', 713000, '梅山', 3, '05', '603', '120.557192', '23.584915', 'Meishan', '1', 0);
INSERT INTO `hh_region` VALUES (713036, '番路乡', 713000, '番路', 3, '05', '602', '120.555043', '23.465222', 'Fanlu', '1', 0);
INSERT INTO `hh_region` VALUES (713037, '大埔乡', 713000, '大埔', 3, '05', '607', '120.593795', '23.296715', 'Dapu', '1', 0);
INSERT INTO `hh_region` VALUES (713038, '阿里山乡', 713000, '阿里山', 3, '05', '605', '120.732520', '23.467950', 'Alishan', '1', 0);
INSERT INTO `hh_region` VALUES (713300, '屏东县', 710000, '屏东', 2, '08', '9', '120.487928', '22.682802', 'Pingtung', '1', 0);
INSERT INTO `hh_region` VALUES (713301, '屏东市', 713300, '屏东', 3, '08', '900', '120.488465', '22.669723', 'Pingdong', '1', 0);
INSERT INTO `hh_region` VALUES (713321, '潮州镇', 713300, '潮州', 3, '08', '920', '120.542854', '22.550536', 'Chaozhou', '1', 0);
INSERT INTO `hh_region` VALUES (713322, '东港镇', 713300, '东港', 3, '08', '928', '120.454489', '22.466626', 'Donggang', '1', 0);
INSERT INTO `hh_region` VALUES (713323, '恒春镇', 713300, '恒春', 3, '08', '946', '120.745451', '22.002373', 'Hengchun', '1', 0);
INSERT INTO `hh_region` VALUES (713324, '万丹乡', 713300, '万丹', 3, '08', '913', '120.484533', '22.589839', 'Wandan', '1', 0);
INSERT INTO `hh_region` VALUES (713325, '长治乡', 713300, '长治', 3, '08', '908', '120.527614', '22.677062', 'Changzhi', '1', 0);
INSERT INTO `hh_region` VALUES (713326, '麟洛乡', 713300, '麟洛', 3, '08', '909', '120.527283', '22.650604', 'Linluo', '1', 0);
INSERT INTO `hh_region` VALUES (713327, '九如乡', 713300, '九如', 3, '08', '904', '120.490142', '22.739778', 'Jiuru', '1', 0);
INSERT INTO `hh_region` VALUES (713328, '里港乡', 713300, '里港', 3, '08', '905', '120.494490', '22.779220', 'Ligang', '1', 0);
INSERT INTO `hh_region` VALUES (713329, '盐埔乡', 713300, '盐埔', 3, '08', '907', '120.572849', '22.754783', 'Yanpu', '1', 0);
INSERT INTO `hh_region` VALUES (713330, '高树乡', 713300, '高树', 3, '08', '906', '120.600214', '22.826789', 'Gaoshu', '1', 0);
INSERT INTO `hh_region` VALUES (713331, '万峦乡', 713300, '万峦', 3, '08', '923', '120.566477', '22.571965', 'Wanluan', '1', 0);
INSERT INTO `hh_region` VALUES (713332, '内埔乡', 713300, '内埔', 3, '08', '912', '120.566865', '22.611967', 'Napu', '1', 0);
INSERT INTO `hh_region` VALUES (713333, '竹田乡', 713300, '竹田', 3, '08', '911', '120.544038', '22.584678', 'Zhutian', '1', 0);
INSERT INTO `hh_region` VALUES (713334, '新埤乡', 713300, '新埤', 3, '08', '925', '120.549546', '22.469976', 'Xinpi', '1', 0);
INSERT INTO `hh_region` VALUES (713335, '枋寮乡', 713300, '枋寮', 3, '08', '940', '120.593438', '22.365560', 'Fangliao', '1', 0);
INSERT INTO `hh_region` VALUES (713336, '新园乡', 713300, '新园', 3, '08', '932', '120.461739', '22.543952', 'Xinyuan', '1', 0);
INSERT INTO `hh_region` VALUES (713337, '崁顶乡', 713300, '崁顶', 3, '08', '924', '120.514571', '22.514795', 'Kanding', '1', 0);
INSERT INTO `hh_region` VALUES (713338, '林边乡', 713300, '林边', 3, '08', '927', '120.515091', '22.434015', 'Linbian', '1', 0);
INSERT INTO `hh_region` VALUES (713339, '南州乡', 713300, '南州', 3, '08', '926', '120.509808', '22.490192', 'Nanzhou', '1', 0);
INSERT INTO `hh_region` VALUES (713340, '佳冬乡', 713300, '佳冬', 3, '08', '931', '120.551544', '22.417653', 'Jiadong', '1', 0);
INSERT INTO `hh_region` VALUES (713341, '琉球乡', 713300, '琉球', 3, '08', '929', '120.369020', '22.342366', 'Liuqiu', '1', 0);
INSERT INTO `hh_region` VALUES (713342, '车城乡', 713300, '车城', 3, '08', '944', '120.710979', '22.072077', 'Checheng', '1', 0);
INSERT INTO `hh_region` VALUES (713343, '满州乡', 713300, '满州', 3, '08', '947', '120.838843', '22.020853', 'Manzhou', '1', 0);
INSERT INTO `hh_region` VALUES (713344, '枋山乡', 713300, '枋山', 3, '08', '941', '120.656356', '22.260338', 'Fangshan', '1', 0);
INSERT INTO `hh_region` VALUES (713345, '三地门乡', 713300, '三地门', 3, '08', '901', '120.654486', '22.713877', 'Sandimen', '1', 0);
INSERT INTO `hh_region` VALUES (713346, '雾台乡', 713300, '雾台', 3, '08', '902', '120.732318', '22.744877', 'Wutai', '1', 0);
INSERT INTO `hh_region` VALUES (713347, '玛家乡', 713300, '玛家', 3, '08', '903', '120.644130', '22.706718', 'Majia', '1', 0);
INSERT INTO `hh_region` VALUES (713348, '泰武乡', 713300, '泰武', 3, '08', '921', '120.632856', '22.591819', 'Taiwu', '1', 0);
INSERT INTO `hh_region` VALUES (713349, '来义乡', 713300, '来义', 3, '08', '922', '120.633601', '22.525866', 'Laiyi', '1', 0);
INSERT INTO `hh_region` VALUES (713350, '春日乡', 713300, '春日', 3, '08', '942', '120.628793', '22.370672', 'Chunri', '1', 0);
INSERT INTO `hh_region` VALUES (713351, '狮子乡', 713300, '狮子', 3, '08', '943', '120.704617', '22.201917', 'Shizi', '1', 0);
INSERT INTO `hh_region` VALUES (713352, '牡丹乡', 713300, '牡丹', 3, '08', '945', '120.770108', '22.125687', 'Mudan', '1', 0);
INSERT INTO `hh_region` VALUES (713400, '台东县', 710000, '台东', 2, '089', '9', '120.916000', '23.000000', 'Taitung', '1', 0);
INSERT INTO `hh_region` VALUES (713401, '台东市', 713400, '台东', 3, '089', '950', '121.145654', '22.756045', 'Taidong', '1', 0);
INSERT INTO `hh_region` VALUES (713421, '成功镇', 713400, '成功', 3, '089', '961', '121.379571', '23.100223', 'Chenggong', '1', 0);
INSERT INTO `hh_region` VALUES (713422, '关山镇', 713400, '关山', 3, '089', '956', '121.163134', '23.047450', 'Guanshan', '1', 0);
INSERT INTO `hh_region` VALUES (713423, '卑南乡', 713400, '卑南', 3, '089', '954', '121.083503', '22.786039', 'Beinan', '1', 0);
INSERT INTO `hh_region` VALUES (713424, '鹿野乡', 713400, '鹿野', 3, '089', '955', '121.135982', '22.913951', 'Luye', '1', 0);
INSERT INTO `hh_region` VALUES (713425, '池上乡', 713400, '池上', 3, '089', '958', '121.215139', '23.122393', 'Chishang', '1', 0);
INSERT INTO `hh_region` VALUES (713426, '东河乡', 713400, '东河', 3, '089', '959', '121.300334', '22.969934', 'Donghe', '1', 0);
INSERT INTO `hh_region` VALUES (713427, '长滨乡', 713400, '长滨', 3, '089', '962', '121.451522', '23.315041', 'Changbin', '1', 0);
INSERT INTO `hh_region` VALUES (713428, '太麻里乡', 713400, '太麻里', 3, '089', '963', '121.007394', '22.615383', 'Taimali', '1', 0);
INSERT INTO `hh_region` VALUES (713429, '大武乡', 713400, '大武', 3, '089', '965', '120.889938', '22.339919', 'Dawu', '1', 0);
INSERT INTO `hh_region` VALUES (713430, '绿岛乡', 713400, '绿岛', 3, '089', '951', '121.492596', '22.661676', 'Lvdao', '1', 0);
INSERT INTO `hh_region` VALUES (713431, '海端乡', 713400, '海端', 3, '089', '957', '121.172008', '23.101074', 'Haiduan', '1', 0);
INSERT INTO `hh_region` VALUES (713432, '延平乡', 713400, '延平', 3, '089', '953', '121.084499', '22.902358', 'Yanping', '1', 0);
INSERT INTO `hh_region` VALUES (713433, '金峰乡', 713400, '金峰', 3, '089', '964', '120.971292', '22.595511', 'Jinfeng', '1', 0);
INSERT INTO `hh_region` VALUES (713434, '达仁乡', 713400, '达仁', 3, '089', '966', '120.884131', '22.294869', 'Daren', '1', 0);
INSERT INTO `hh_region` VALUES (713435, '兰屿乡', 713400, '兰屿', 3, '089', '952', '121.532473', '22.056736', 'Lanyu', '1', 0);
INSERT INTO `hh_region` VALUES (713500, '花莲县', 710000, '花莲', 2, '03', '9', '121.300000', '23.830000', 'Hualien', '1', 0);
INSERT INTO `hh_region` VALUES (713501, '花莲市', 713500, '花莲', 3, '03', '970', '121.606810', '23.982074', 'Hualian', '1', 0);
INSERT INTO `hh_region` VALUES (713521, '凤林镇', 713500, '凤林', 3, '03', '975', '121.451687', '23.744648', 'Fenglin', '1', 0);
INSERT INTO `hh_region` VALUES (713522, '玉里镇', 713500, '玉里', 3, '03', '981', '121.316445', '23.336509', 'Yuli', '1', 0);
INSERT INTO `hh_region` VALUES (713523, '新城乡', 713500, '新城', 3, '03', '971', '121.640512', '24.128133', 'Xincheng', '1', 0);
INSERT INTO `hh_region` VALUES (713524, '吉安乡', 713500, '吉安', 3, '03', '973', '121.568005', '23.961635', 'Ji\'an', '1', 0);
INSERT INTO `hh_region` VALUES (713525, '寿丰乡', 713500, '寿丰', 3, '03', '974', '121.508955', '23.870680', 'Shoufeng', '1', 0);
INSERT INTO `hh_region` VALUES (713526, '光复乡', 713500, '光复', 3, '03', '976', '121.423496', '23.669084', 'Guangfu', '1', 0);
INSERT INTO `hh_region` VALUES (713527, '丰滨乡', 713500, '丰滨', 3, '03', '977', '121.518639', '23.597080', 'Fengbin', '1', 0);
INSERT INTO `hh_region` VALUES (713528, '瑞穗乡', 713500, '瑞穗', 3, '03', '978', '121.375992', '23.496817', 'Ruisui', '1', 0);
INSERT INTO `hh_region` VALUES (713529, '富里乡', 713500, '富里', 3, '03', '983', '121.250124', '23.179984', 'Fuli', '1', 0);
INSERT INTO `hh_region` VALUES (713530, '秀林乡', 713500, '秀林', 3, '03', '972', '121.620381', '24.116642', 'Xiulin', '1', 0);
INSERT INTO `hh_region` VALUES (713531, '万荣乡', 713500, '万荣', 3, '03', '979', '121.407493', '23.715346', 'Wanrong', '1', 0);
INSERT INTO `hh_region` VALUES (713532, '卓溪乡', 713500, '卓溪', 3, '03', '982', '121.303422', '23.346369', 'Zhuoxi', '1', 0);
INSERT INTO `hh_region` VALUES (713600, '澎湖县', 710000, '澎湖', 2, '06', '8', '119.566417', '23.569733', 'Penghu', '1', 0);
INSERT INTO `hh_region` VALUES (713601, '马公市', 713600, '马公', 3, '06', '880', '119.566499', '23.565845', 'Magong', '1', 0);
INSERT INTO `hh_region` VALUES (713621, '湖西乡', 713600, '湖西', 3, '06', '885', '119.659666', '23.583358', 'Huxi', '1', 0);
INSERT INTO `hh_region` VALUES (713622, '白沙乡', 713600, '白沙', 3, '06', '884', '119.597919', '23.666060', 'Baisha', '1', 0);
INSERT INTO `hh_region` VALUES (713623, '西屿乡', 713600, '西屿', 3, '06', '881', '119.506974', '23.600836', 'Xiyu', '1', 0);
INSERT INTO `hh_region` VALUES (713624, '望安乡', 713600, '望安', 3, '06', '882', '119.500538', '23.357531', 'Wang\'an', '1', 0);
INSERT INTO `hh_region` VALUES (713625, '七美乡', 713600, '七美', 3, '06', '883', '119.423929', '23.206018', 'Qimei', '1', 0);
INSERT INTO `hh_region` VALUES (713700, '金门县', 710000, '金门', 2, '082', '8', '118.317089', '24.432706', 'Jinmen', '1', 0);
INSERT INTO `hh_region` VALUES (713701, '金城镇', 713700, '金城', 3, '082', '893', '118.316667', '24.416667', 'Jincheng', '1', 0);
INSERT INTO `hh_region` VALUES (713702, '金湖镇', 713700, '金湖', 3, '082', '891', '118.419743', '24.438633', 'Jinhu', '1', 0);
INSERT INTO `hh_region` VALUES (713703, '金沙镇', 713700, '金沙', 3, '082', '890', '118.427993', '24.481109', 'Jinsha', '1', 0);
INSERT INTO `hh_region` VALUES (713704, '金宁乡', 713700, '金宁', 3, '082', '892', '118.334506', '24.45672', 'Jinning', '1', 0);
INSERT INTO `hh_region` VALUES (713705, '烈屿乡', 713700, '烈屿', 3, '082', '894', '118.247255', '24.433102', 'Lieyu', '1', 0);
INSERT INTO `hh_region` VALUES (713706, '乌丘乡', 713700, '乌丘', 3, '082', '896', '118.319578', '24.435038', 'Wuqiu', '1', 0);
INSERT INTO `hh_region` VALUES (713800, '连江县', 710000, '连江', 2, '0836', '2', '119.539704', '26.197364', 'Lienchiang', '1', 0);
INSERT INTO `hh_region` VALUES (713801, '南竿乡', 713800, '南竿', 3, '0836', '209', '119.944267', '26.144035', 'Nangan', '1', 0);
INSERT INTO `hh_region` VALUES (713802, '北竿乡', 713800, '北竿', 3, '0836', '210', '120.000572', '26.221983', 'Beigan', '1', 0);
INSERT INTO `hh_region` VALUES (713803, '莒光乡', 713800, '莒光', 3, '0836', '211', '119.940405', '25.976256', 'Juguang', '1', 0);
INSERT INTO `hh_region` VALUES (713804, '东引乡', 713800, '东引', 3, '0836', '212', '120.493955', '26.366164', 'Dongyin', '1', 0);
INSERT INTO `hh_region` VALUES (810000, '香港特别行政区', 100000, '香港', 1, '', '', '114.173355', '22.320048', 'Hong Kong', '1', 0);
INSERT INTO `hh_region` VALUES (810100, '香港岛', 810000, '香港岛', 2, '00852', '999077', '114.177314', '22.266416', 'Hong Kong Island', '1', 0);
INSERT INTO `hh_region` VALUES (810101, '中西区', 810100, '中西区', 3, '00852', '999077', '114.154374', '22.281981', 'Central and Western District', '1', 0);
INSERT INTO `hh_region` VALUES (810102, '湾仔区', 810100, '湾仔区', 3, '00852', '999077', '114.182915', '22.276389', 'Wan Chai District', '1', 0);
INSERT INTO `hh_region` VALUES (810103, '东区', 810100, '东区', 3, '00852', '999077', '114.255993', '22.262755', 'Eastern District', '1', 0);
INSERT INTO `hh_region` VALUES (810104, '南区', 810100, '南区', 3, '00852', '999077', '114.174134', '22.24676', 'Southern District', '1', 0);
INSERT INTO `hh_region` VALUES (810200, '九龙', 810000, '九龙', 2, '00852', '999077', '114.17495', '22.327115', 'Kowloon', '1', 0);
INSERT INTO `hh_region` VALUES (810201, '油尖旺区', 810200, '油尖旺', 3, '00852', '999077', '114.173332', '22.311704', 'Yau Tsim Mong', '1', 0);
INSERT INTO `hh_region` VALUES (810202, '深水埗区', 810200, '深水埗', 3, '00852', '999077', '114.16721', '22.328171', 'Sham Shui Po', '1', 0);
INSERT INTO `hh_region` VALUES (810203, '九龙城区', 810200, '九龙城', 3, '00852', '999077', '114.195053', '22.32673', 'Jiulongcheng', '1', 0);
INSERT INTO `hh_region` VALUES (810204, '黄大仙区', 810200, '黄大仙', 3, '00852', '999077', '114.19924', '22.336313', 'Wong Tai Sin', '1', 0);
INSERT INTO `hh_region` VALUES (810205, '观塘区', 810200, '观塘', 3, '00852', '999077', '114.231268', '22.30943', 'Kwun Tong', '1', 0);
INSERT INTO `hh_region` VALUES (810300, '新界', 810000, '新界', 2, '00852', '999077', '114.202408', '22.341766', 'New Territories', '1', 0);
INSERT INTO `hh_region` VALUES (810301, '荃湾区', 810300, '荃湾', 3, '00852', '999077', '114.122952', '22.370973', 'Tsuen Wan', '1', 0);
INSERT INTO `hh_region` VALUES (810302, '屯门区', 810300, '屯门', 3, '00852', '999077', '113.977416', '22.391047', 'Tuen Mun', '1', 0);
INSERT INTO `hh_region` VALUES (810303, '元朗区', 810300, '元朗', 3, '00852', '999077', '114.039796', '22.443342', 'Yuen Long', '1', 0);
INSERT INTO `hh_region` VALUES (810304, '北区', 810300, '北区', 3, '00852', '999077', '114.148959', '22.494086', 'North District', '1', 0);
INSERT INTO `hh_region` VALUES (810305, '大埔区', 810300, '大埔', 3, '00852', '999077', '114.171743', '22.445653', 'Tai Po', '1', 0);
INSERT INTO `hh_region` VALUES (810306, '西贡区', 810300, '西贡', 3, '00852', '999077', '114.27854', '22.37944', 'Sai Kung', '1', 0);
INSERT INTO `hh_region` VALUES (810307, '沙田区', 810300, '沙田', 3, '00852', '999077', '114.191941', '22.379294', 'Sha Tin', '1', 0);
INSERT INTO `hh_region` VALUES (810308, '葵青区', 810300, '葵青', 3, '00852', '999077', '114.13932', '22.363877', 'Kwai Tsing', '1', 0);
INSERT INTO `hh_region` VALUES (810309, '离岛区', 810300, '离岛', 3, '00852', '999077', '113.945842', '22.281508', 'Outlying Islands', '1', 0);
INSERT INTO `hh_region` VALUES (820000, '澳门特别行政区', 100000, '澳门', 1, '', '', '113.54909', '22.198951', 'Macau', '1', 0);
INSERT INTO `hh_region` VALUES (820100, '澳门半岛', 820000, '澳门半岛', 2, '00853', '999078', '113.549134', '22.198751', 'MacauPeninsula', '1', 0);
INSERT INTO `hh_region` VALUES (820101, '花地玛堂区', 820100, '花地玛堂区', 3, '00853', '999078', '113.552284', '22.208067', 'Nossa Senhora de Fatima', '1', 0);
INSERT INTO `hh_region` VALUES (820102, '圣安多尼堂区', 820100, '圣安多尼堂区', 3, '00853', '999078', '113.564301', '22.12381', 'Santo Antonio', '1', 0);
INSERT INTO `hh_region` VALUES (820103, '大堂区', 820100, '大堂', 3, '00853', '999078', '113.552971', '22.188359', 'S�', '1', 0);
INSERT INTO `hh_region` VALUES (820104, '望德堂区', 820100, '望德堂区', 3, '00853', '999078', '113.550568', '22.194081', 'Sao Lazaro', '1', 0);
INSERT INTO `hh_region` VALUES (820105, '风顺堂区', 820100, '风顺堂区', 3, '00853', '999078', '113.541928', '22.187368', 'Sao Lourenco', '1', 0);
INSERT INTO `hh_region` VALUES (820200, '氹仔岛', 820000, '氹仔岛', 2, '00853', '999078', '113.577669', '22.156838', 'Taipa', '1', 0);
INSERT INTO `hh_region` VALUES (820201, '嘉模堂区', 820200, '嘉模堂区', 3, '00853', '999078', '113.565303', '22.149029', 'Our Lady Of Carmel\'s Parish', '1', 0);
INSERT INTO `hh_region` VALUES (820300, '路环岛', 820000, '路环岛', 2, '00853', '999078', '113.564857', '22.116226', 'Coloane', '1', 0);
INSERT INTO `hh_region` VALUES (820301, '圣方济各堂区', 820300, '圣方济各堂区', 3, '00853', '999078', '113.559954', '22.123486', 'St Francis Xavier\'s Parish', '1', 0);
INSERT INTO `hh_region` VALUES (900000, '钓鱼岛', 100000, '钓鱼岛', 1, '', '', '123.478088', '25.742385', 'DiaoyuDao', '1', 0);

-- ----------------------------
-- Table structure for hh_stepselect
-- ----------------------------
DROP TABLE IF EXISTS `hh_stepselect`;
CREATE TABLE `hh_stepselect`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '类别组ID',
  `pid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '上级id',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '组类别名',
  `issystem` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否系统内置',
  `tid` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '字段id',
  `fields` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '字段名称',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 8 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '联动类别表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_stepselect
-- ----------------------------
INSERT INTO `hh_stepselect` VALUES (1, 0, '你好2', 0, 43, 'diqu', 0);
INSERT INTO `hh_stepselect` VALUES (2, 0, 'dsfsd', 0, 43, 'diqu', 0);
INSERT INTO `hh_stepselect` VALUES (3, 0, 'sdfsdf', 0, 43, 'diqu', 0);
INSERT INTO `hh_stepselect` VALUES (4, 0, 'sdfsdfsdf', 0, 43, 'diqu', 0);
INSERT INTO `hh_stepselect` VALUES (6, 0, '666', 0, 43, 'diqu', 0);
INSERT INTO `hh_stepselect` VALUES (7, 1, 'dfdfd', 0, 43, 'diqu', 0);

-- ----------------------------
-- Table structure for hh_system_auth_node
-- ----------------------------
DROP TABLE IF EXISTS `hh_system_auth_node`;
CREATE TABLE `hh_system_auth_node`  (
  `auth_id` mediumint(8) UNSIGNED NOT NULL DEFAULT 0 COMMENT '角色ID',
  `node_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '节点ID',
  INDEX `index_auth_group`(`auth_id`) USING BTREE,
  INDEX `index_system_auth_node`(`node_id`) USING BTREE
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色与节点关系表' ROW_FORMAT = Fixed;

-- ----------------------------
-- Table structure for hh_system_node
-- ----------------------------
DROP TABLE IF EXISTS `hh_system_node`;
CREATE TABLE `hh_system_node`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `node` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '节点代码',
  `title` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '节点标题',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 3 COMMENT '节点类型（1：控制器，2：节点）',
  `is_auth` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '是否启动RBAC权限控制',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `node`(`node`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 250 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统节点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_system_node
-- ----------------------------
INSERT INTO `hh_system_node` VALUES (1, 'cms.adtype', '广告位管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (2, 'cms.adtype/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (3, 'cms.adtype/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (4, 'cms.adtype/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (5, 'cms.adtype/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (6, 'cms.adtype/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (7, 'cms.advert', '广告管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (8, 'cms.advert/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (9, 'cms.advert/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (10, 'cms.advert/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (11, 'cms.advert/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (12, 'cms.advert/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (13, 'cms.advert/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (14, 'cms.arctype', '栏目管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (15, 'cms.arctype/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (16, 'cms.arctype/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (17, 'cms.arctype/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (18, 'cms.arctype/edit_content', '编辑内容', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (19, 'cms.arctype/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (20, 'cms.arctype/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (21, 'cms.arctype/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (22, 'cms.arctype/get_pinyin', '中文转拼音', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (23, 'cms.arctype/arctype_show', '展示 / 折叠', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (24, 'cms.attribute', '模型属性(字段)管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (25, 'cms.attribute/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (26, 'cms.attribute/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (27, 'cms.attribute/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (28, 'cms.attribute/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (29, 'cms.attribute/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (30, 'cms.attribute/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (31, 'cms.debris', '碎片管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (32, 'cms.debris/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (33, 'cms.debris/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (34, 'cms.debris/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (35, 'cms.debris/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (36, 'cms.debris/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (37, 'cms.debris/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (38, 'cms.debris_pos', '碎片位管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (39, 'cms.debris_pos/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (40, 'cms.debris_pos/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (41, 'cms.debris_pos/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (42, 'cms.debris_pos/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (43, 'cms.debris_pos/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (44, 'cms.document', '文档管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (45, 'cms.document/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (46, 'cms.document/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (47, 'cms.document/copy', '复制', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (48, 'cms.document/move', '移动', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (49, 'cms.document/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (50, 'cms.document/set_status', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (51, 'cms.document/set_sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (52, 'cms.document/content', '管理内容', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (53, 'cms.document/arctype', '左侧栏目', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (54, 'cms.document/panl', '右侧面板', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (55, 'cms.document/document', '右侧文档', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (56, 'cms.form', '表单管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (57, 'cms.form/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (58, 'cms.form/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (59, 'cms.form/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (60, 'cms.form/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (61, 'cms.form/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (62, 'cms.form/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (63, 'cms.form/info', '信息列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (64, 'cms.link_type', '友链类型管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (65, 'cms.link_type/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (66, 'cms.link_type/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (67, 'cms.link_type/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (68, 'cms.link_type/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (69, 'cms.link_type/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (70, 'cms.links', '友链管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (71, 'cms.links/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (72, 'cms.links/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (73, 'cms.links/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (74, 'cms.links/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (75, 'cms.links/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (76, 'cms.links/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (77, 'cms.model', '模型管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (78, 'cms.model/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (79, 'cms.model/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (80, 'cms.model/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (81, 'cms.model/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (82, 'cms.model/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (83, 'cms.model/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (84, 'cms.select', '联动类别管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (85, 'cms.select/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (86, 'cms.select/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (87, 'cms.select/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (88, 'cms.select/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (89, 'cms.select/list_select', '查看子分类', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (90, 'cms.select/getStep', '根据pid获取下一级联动信息', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (91, 'cms.seoset', '优化设置管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (92, 'cms.seoset/site', '首页优化', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (93, 'cms.seoset/category', '栏目优化', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (94, 'cms.seoset/editCategory', '编辑栏目', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (95, 'cms.seoset/area', '地区优化', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (96, 'cms.seoset/longKey', '长尾词优化', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (97, 'cms.seoset/operate', '优化操作', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (98, 'cms.tag', 'TAG标签管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (99, 'cms.tag/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (100, 'cms.tag/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (101, 'cms.tag/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (102, 'cms.tag/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (103, 'cms.tag/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (104, 'cms.tag/rebuilt', '数据重建', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (105, 'cms.update', '更新管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (106, 'cms.update/index', '更新主页HTML', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (107, 'cms.update/category', '更新栏目HTML', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (108, 'cms.update/document', '更新文档HTML', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (109, 'addon', '插件管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (110, 'addon/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (111, 'addon/install', '安装插件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (112, 'addon/uninstall', '卸载插件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (113, 'addon/state', '禁启插件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (114, 'addon/config', '插件配置', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (115, 'addon/del', '删除插件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (116, 'addon/local', '上传插件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (117, 'admin', '管理员管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (118, 'admin/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (119, 'admin/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (120, 'admin/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (121, 'admin/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (122, 'admin/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (123, 'admin/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (124, 'admin/role', '所属角色', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (125, 'attachment', '附件管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (126, 'attachment/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (127, 'attachment/upload_file', '上传文件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (128, 'attachment/upload_max_file', '接收大文件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (129, 'attachment/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (130, 'attachment/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (131, 'attachment/move', '移动', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (132, 'attachment/kindeditor_upload', 'kindeditor上传', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (133, 'attachment/kindeditor_file_manager', 'kindeditor文件管理', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (134, 'attachment/kindeditor_image_del', 'kindeditor图片删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (135, 'attachment/native_upload', '上传本地文件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (136, 'attachment/crop', '本地图片裁剪', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (137, 'attachment/delimg', '删除文件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (138, 'attachment_group', '附件分组管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (139, 'attachment_group/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (140, 'attachment_group/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (141, 'attachment_group/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (142, 'attachment_group/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (143, 'attachment_group/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (144, 'auth_group', '角色(用户组)管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (145, 'auth_group/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (146, 'auth_group/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (147, 'auth_group/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (148, 'auth_group/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (149, 'auth_group/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (150, 'auth_group/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (151, 'auth_group/node', '节点授权', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (152, 'auth_group/access', '访问授权', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (153, 'auth_group/user', '成员授权', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (154, 'auth_group/remove_user', '解除成员授权(绑定)', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (155, 'auth_group/add_to_group_access', '新增成员', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (156, 'auth_group/shrink', 'ajax规则收缩', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (157, 'config', '配置管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (158, 'config/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (159, 'config/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (160, 'config/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (161, 'config/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (162, 'config/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (163, 'config/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (164, 'config/configuration', '网站配置', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (165, 'config/download', '下载文件或图片', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (166, 'config/delete_file', 'ajax异步删除文件或图片', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (167, 'config_type', '配置类型管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (168, 'config_type/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (169, 'config_type/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (170, 'config_type/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (171, 'config_type/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (172, 'config_type/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (173, 'config_type/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (174, 'data', '数据库管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (175, 'data/sql_index', '获取数据库中表的列表信息', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (176, 'data/sql_query', '执行sql语句', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (177, 'data/get_table_insert', '获取表结构和insert数据语句', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (178, 'data/sql_table', '获取表结构', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (179, 'data/sql_insert', '获取insert语句', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (180, 'data/repair', '表的修复', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (181, 'data/optimize', '表的优化', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (182, 'data/repairAll', '批量修复', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (183, 'data/optimizeAll', '优化所有表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (184, 'data/clear_table_data', '清空表数据', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (185, 'data/del_table', '删除表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (186, 'database', '数据库备份管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (187, 'database/index', '获取数据库中表的列表信息', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (188, 'database/repair', '表的修复', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (189, 'database/optimize', '表的优化', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (190, 'database/repairAll', '批量修复', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (191, 'database/optimizeAll', '批量优化', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (192, 'database/backuplst', '获取备份列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (193, 'database/dbbackup', '备份', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (194, 'database/restore', '数据还原', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (195, 'database/del', '删除备份', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (196, 'database/delall', '批量删除备份', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (197, 'database/download', '备份下载', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (198, 'database/upload', '上传备份', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (199, 'file', '文件管理器', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (200, 'file/index', '文件列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (201, 'file/edit', '文件内容编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (202, 'file/copy_folder', '复制文件夹', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (203, 'file/copy_file', '复制文件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (204, 'file/cut_folder', '剪切文件夹', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (205, 'file/cut_file', '剪切文件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (206, 'file/renames', '重命名', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (207, 'file/download', '文件下载', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (208, 'file/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (209, 'file/new_folder', '新建文件夹', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (210, 'file/new_file', '新建文件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (211, 'file/upload_file', '文件上传', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (212, 'file/upload_max_file', '大文件上传', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (213, 'file/compress', '压缩文件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (214, 'file/decompression_file', '解压文件', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (215, 'hooks', '钩子管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (216, 'hooks/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (217, 'hooks/detail', '详情', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (218, 'hooks/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (219, 'log', '日志管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (220, 'log/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (221, 'log/log_content', '查看详细', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (222, 'log/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (223, 'log/recover', '恢复日志', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (224, 'log/clear_log', '清空所有日志', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (225, 'logs', '管理员行为日志管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (226, 'logs/index', '行为日志列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (227, 'logs/del', '删除日志', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (228, 'logs/clear_log', '清空所有日志', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (229, 'menu', '菜单(规则)管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (230, 'menu/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (231, 'menu/add', '新增', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (232, 'menu/edit', '编辑', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (233, 'menu/del', '删除', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (234, 'menu/setShow', '显示/隐藏', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (235, 'menu/setStatus', '状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (236, 'menu/sort', '排序', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (237, 'menu/move', '移动菜单', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (238, 'menu/search', '菜单搜索', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (239, 'menu/ceshicaidan', '测试菜单', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (240, 'node', '系统节点管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (241, 'node/index', '列表', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (242, 'node/refreshNode', '系统节点更新', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (243, 'node/clearNode', '清除失效节点', 2, 0, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (244, 'node/setStatus', '设置节点状态', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (245, 'update', '在线更新管理', 1, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (246, 'update/index', '检查更新', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (247, 'update/isbackupfile', '在线更新', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (248, 'update/upload', '上传更新包', 2, 1, 1608807556, 1608807556);
INSERT INTO `hh_system_node` VALUES (249, 'update/receive_upload', '接收更新包', 2, 1, 1608807556, 1608807556);

-- ----------------------------
-- Table structure for hh_tag
-- ----------------------------
DROP TABLE IF EXISTS `hh_tag`;
CREATE TABLE `hh_tag`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标签名称',
  `color` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '标签颜色',
  `seotitle` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'seo标题',
  `keywords` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '关键字',
  `description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '描述',
  `view` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '浏览量',
  `target` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '_self' COMMENT 'HTML<a>标签的target属性(_blank:在新窗口中打开被链接文档,_self:默认。在相同的框架中打开被链接文档,_parent:在父框架集中打开被链接文档,_top:在整个窗口中打开被链接文档,framename:在指定的框架中打开被链接文档)',
  `rel` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT 'HTML<a>标签的rel属性，nofollow：Google使用\"nofollow\"，用于指定 Google 搜索引擎不要跟踪链接。external：此属性的意思是告诉搜索引擎，这个链接不是本站链接。noopener noreferrer：在新打开的页面（baidu）中可以通过window.opener获取到源页面的部分控制权，即使新打开的页面是跨域的也照样可以',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态(1:显示,0:隐藏)',
  `sort` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '排序',
  `create_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '创建时间',
  `update_time` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'tag标签表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hh_tag
-- ----------------------------
INSERT INTO `hh_tag` VALUES (1, 'jquery', '#a16767', 'sfsdf', 'sdfsd', 'sfsd', 11, '_blank', 'external', 1, 0, 1608126839, 1608127991);
INSERT INTO `hh_tag` VALUES (2, 'html', '', '', '', '', 4, '_self', '', 1, 0, 1608126839, 1608126839);

-- ----------------------------
-- Table structure for hh_tagmap
-- ----------------------------
DROP TABLE IF EXISTS `hh_tagmap`;
CREATE TABLE `hh_tagmap`  (
  `tag_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'tag标签ID',
  `model_id` int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT '模型ID',
  `category_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '栏目ID',
  `document_id` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '文档ID'
) ENGINE = MyISAM CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'tagmap表' ROW_FORMAT = Fixed;

-- ----------------------------
-- Records of hh_tagmap
-- ----------------------------
INSERT INTO `hh_tagmap` VALUES (2, 2, 33, 4);
INSERT INTO `hh_tagmap` VALUES (1, 2, 33, 4);

SET FOREIGN_KEY_CHECKS = 1;
