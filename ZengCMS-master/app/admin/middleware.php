<?php
// 这是系统自动生成的middleware定义文件
return [
    \think\middleware\LoadLangPack::class, // 多语言加载
    app\admin\middleware\Logs::class,      // 记录行为日志
    app\admin\middleware\Crstat::class,    // 清理访问记录
];
