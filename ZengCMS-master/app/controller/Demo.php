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
// | 项目在线演示控制器
// +----------------------------------------------------------------------
namespace app\controller;

use think\facade\View;

class Demo extends Base
{
    public function index()
    {
        $category_id = intval(input('cid_'));//栏目ID
        $document_id = input('id');//文档ID
        $doc = get_doc($category_id, $document_id, $field = null);
        if (!$doc) {
            abort(404, '页面异常');
        }
        View::assign([
            'doc' => $doc,
        ]);
        $tpl = LANG_URL_DIR . '/z-demo';
        return View::fetch(config('view.view_path') . $this->get_config['WEB_DEFAULT_THEME'] . $tpl . '.html');
    }
}