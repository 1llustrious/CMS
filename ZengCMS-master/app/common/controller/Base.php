<?php
namespace app\common\controller;

use app\BaseController;
use think\facade\Cookie;

class Base extends BaseController
{
    public function initialize()
    {
        parent::initialize();
    }
    public function enlang()
    {
        $lang = input('lang');
        switch ($lang) {
            case 'zh-cn':
                Cookie::set('think_lang', 'zh-cn');
                break;
            case 'en-us':
                Cookie::set('think_lang', 'en-us');
                break;
            default:
                Cookie::set('think_lang', 'zh-cn');
                break;
        }
        $this->success(lang('change language success'));
    }
}
