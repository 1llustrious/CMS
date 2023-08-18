DROP TABLE IF EXISTS `__PREFIX__ems`;
CREATE TABLE IF NOT EXISTS `__PREFIX__ems`(
`id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
`event` varchar(30) NOT NULL DEFAULT '' COMMENT '事件',
`email` varchar(100) NOT NULL DEFAULT '' COMMENT '邮箱',
`code` varchar(10) NOT NULL DEFAULT '' COMMENT '验证码',
`times` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '验证次数',
`ip` char(15) NOT NULL DEFAULT '' COMMENT '操作IP',
`create_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '创建时间',
PRIMARY KEY (`id`)
)ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='邮箱验证码表';