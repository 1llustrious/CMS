<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006~2018 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------
use think\facade\Route;
/*
Route::get('think', function () {
    return 'hello,ThinkPHP6!';
});

Route::get('hello/:name', 'index/hello');
*/

// 首页路由，$意思是结束
Route::get('[:lang]/index$', 'Index/index')
->ext(get_one_cache_config('index_suffix','html'))
->pattern(['lang'=>get_one_cache_config('WEB_INDEX_LANG')]);

// 搜索列表路由
Route::get('[:lang]/[:city]/search', 'Search/index')
->ext(get_one_cache_config('other_suffix','html'))
->pattern(['lang'=>get_one_cache_config('WEB_INDEX_LANG'),'city' => '\w+']);

// tag某标签所有信息分页路由
Route::get('[:lang]/[:city]/tag/:tag/[:page]', 'Tag/detail')
->ext(get_one_cache_config('other_suffix','html'))
->pattern(['lang'=>get_one_cache_config('WEB_INDEX_LANG'),'city' => '\w+','page'=>'\d+']);

// seo诊断路由
Route::get('[:lang]/[:city]/seo', 'Seo/index')
->ext(get_one_cache_config('other_suffix','html'))
->pattern(['lang'=>get_one_cache_config('WEB_INDEX_LANG'),'city' => '\w+']);
Route::post('[:lang]/[:city]/seo', 'Seo/index')
->ext(get_one_cache_config('other_suffix','html'))
->pattern(['lang'=>get_one_cache_config('WEB_INDEX_LANG'),'city' => '\w+']);
Route::post('[:lang]/[:city]/seo/getkeyposition', 'Seo/getkeyposition')
->ext(get_one_cache_config('other_suffix','html'))
->pattern(['lang'=>get_one_cache_config('WEB_INDEX_LANG'),'city' => '\w+']);

// tag所有标签分页路由?page=x&keywords=x
Route::get('[:lang]/[:city]/tag', 'Tag/index')
->ext(get_one_cache_config('other_suffix','html'))
->pattern(['lang'=>get_one_cache_config('WEB_INDEX_LANG'),'city' => '\w+']);

// 下载路由
Route::get('[:lang]/[:city]/download', 'Download/index')
->ext(get_one_cache_config('other_suffix','html'))
->pattern(['lang'=>get_one_cache_config('WEB_INDEX_LANG'),'city' => '\w+']);

// 栏目分页访问路由-注意 id_
Route::get('[:lang]/[:city]/:id/list_:id_:page', 'Category/index')
->ext(get_one_cache_config('category_page_suffix','html'))
->pattern([
    'lang'=>get_one_cache_config('WEB_INDEX_LANG'),
    'city' => '\w+','id' => get_all_category_name(),
    'id_'=>'[0-9]+_','page'=>'\d+'
]);

// 内容详情路由
Route::get('[:lang]/[:city]/:catename/:id', 'Article/index')
->ext(get_one_cache_config('article_suffix','html'))
->pattern([
    'lang'=>get_one_cache_config('WEB_INDEX_LANG'),
    'city' => '\w+',
    'catename'=>get_all_category_name(),
    'id' => '\d+'
]);

// 栏目不分页访问路由
if(get_one_cache_config('category_suffix')){
    Route::get('[:lang]/[:city]/:id', 'Category/index')
    ->ext(get_one_cache_config('category_suffix'))
    ->pattern(['lang'=>get_one_cache_config('WEB_INDEX_LANG'),'city' => '\w+','id' => get_all_category_name()]);
}else{
    Route::get('[:lang]/[:city]/:id/', 'Category/index')
    ->pattern(['lang'=>get_one_cache_config('WEB_INDEX_LANG'),'city' => '\w+','id' => get_all_category_name()]);
}

// 模板演示路由
Route::get('[:lang]/[:city]/demo/:cid_:id', 'Demo/index')
->ext(get_one_cache_config('other_suffix','html'))
->pattern(['lang'=>get_one_cache_config('WEB_INDEX_LANG'),'city' => '\w+','cid_'=>'[0-9]+_','id' => '[0-9]+']);