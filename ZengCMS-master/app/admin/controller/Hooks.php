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
// | 钩子控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\facade\Db;
use think\facade\View;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="钩子管理")
 * Class Hooks
 * @package app\admin\controller
 */
class Hooks extends Base
{
    /**
     * @NodeAnotation(title="列表")
     */
    public function index()
    {
        $map = array();
        $where = 1;
        $query = array();
        $addon = trim(input('addon'));
        $title = trim(input('title'));
        if ($addon) {
            $where = "find_in_set('{$addon}',addons)";
            $query['addon'] = $addon;
        }
        if ($title) {
            $map[] = ['name|description|addons', 'like', "%$title%"];
            $query['title'] = $title;
        }
        $list = Db::name('hooks')->where($where)->where($map)->order(['sort'=>'desc','id' => 'asc'])
        ->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query])
        ->each(function ($item, $key) {
            int_to_string($item, array(
                'type' => [1 => '视图', 2 => '控制器'],
            ));
            return $item;
        });
        $addons =  Db::name('addon')->order('id desc')->column('*', 'name');
        View::assign([
            'meta_title'=>'插件钩子列表',
            'list' => $list, //分页后列表
            'addons'=>$addons,//已安装的插件
            'addon'=>$addon,//插件名
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="详情")
     */
    public function detail($id = null)
    {
        if (empty($id)) {
            return json(['code'=>0,'msg'=>'参数错误！','url'=>'']);
        }
        $info = Db::name('hooks')->find($id); // 当前信息
        int_to_string($info, array(
            'type' => [1 => '视图', 2 => '控制器'],
        ));
        View::assign([
            'meta_title'=>'钩子详情',
            'info'=>$info,
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="排序")
	 * [sort 排序]
	 * @param  string $model [表名]
	 * @param  array  $data  [数据]
	 * @return [type]        [description]
	 */
	public function sort($model = 'hooks', $data = array())
	{
		$data['sort'] = input('sort');
		return parent::sort($model, $data);
    }
}