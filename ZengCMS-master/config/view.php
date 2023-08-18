<?php
// +----------------------------------------------------------------------
// | 模板设置
// +----------------------------------------------------------------------

return [
    // 模板引擎类型使用Think
    'type'          => 'Think',
    // 默认模板渲染规则 1 解析为小写+下划线 2 全部转换小写 3 保持操作方法
    'auto_rule'     => 1,
    // 模板目录名
    'view_dir_name' => 'view',
    // 模板后缀
    'view_suffix'   => 'html',
    // 模板文件名分隔符
    'view_depr'     => DIRECTORY_SEPARATOR,
    // 模板引擎普通标签开始标记
    'tpl_begin'     => '{',
    // 模板引擎普通标签结束标记
    'tpl_end'       => '}',
    // 标签库标签开始标记
    'taglib_begin'  => '{',
    // 标签库标签结束标记
    'taglib_end'    => '}',

    // 模板路径
    'view_path'    => PROJECT_PATH.'/public/static/template/',
    // 模板输出替换
    'tpl_replace_string' => [
        // '__STATIC__'=>'/static',
        // 静态资源路径
        '__STATIC__'=>EXTRA_DIR.PUBLIC_DIR.'/static',
        '__TEMPLATE__'=>EXTRA_DIR.PUBLIC_DIR.'/static/template/'.get_one_cache_config('WEB_DEFAULT_THEME'),
    ],
    // 预先加载的标签库
    'taglib_pre_load' => 'app\common\taglib\Huo',
    // 内置标签库名称(标签使用不必指定标签库名称),以逗号分隔 注意解析顺序
    // 调用时不用带Hh:
    // 'taglib_build_in'    => 'cx,app\common\taglib\Huo',
    // 'default_filter'     => 'htmlspecialchars_decode', // 默认过滤方法 用于普通标签输出
    'default_filter'     => '', // 默认过滤方法 用于普通标签输出
];
