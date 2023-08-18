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
// | 广告位控制器
// +----------------------------------------------------------------------
namespace app\admin\controller\cms;

use think\facade\Db;
use think\facade\View;
use app\admin\controller\Base;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
use app\admin\validate\cms\Adtype as AdtypeValidate;
/**
 * @ControllerAnnotation(title="广告位管理")
 * Class Adtype
 * @package app\admin\controller\cms
 */
class Adtype extends Base 
{
	/**
     * @NodeAnotation(title="列表")
     */
	public function index()
	{
		$map = array();
		$query = array();
		$title = trim(input('title'));
		if ($title) {
			$map[] = ['name', 'like', "%$title%"];
			$query['title'] = $title;
		}
		$order = ['sort' => 'desc', 'id' => 'desc'];
		$list = Db::name('adtype')
		->where($map)
		->order($order)
		->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query]);
		View::assign([
			'meta_title' => '广告位管理',//标题
			'list' => $list,//列表
		]);
		// 记录当前列表页的cookie
		cookie('__forward__', $_SERVER['REQUEST_URI']);
		return view();
	}
	/**
     * @NodeAnotation(title="新增")
     */
	public function add()
	{
		if (request()->isAjax()) {
			$data = input('post.');
			$validate = new AdtypeValidate();
			if (!$validate->scene('add')->check($data)) {
				return json(['code'=>0,'msg'=>'','url'=>$validate->getError()]);
			}
			$id = Db::name('adtype')->strict(false)->insertGetId($data);
			if ($id) {
				action_log($id,'adtype',1);
				return json(['code'=>1,'msg'=>'新增成功！','url'=>'index']);
			} else {
				return json(['code'=>0,'msg'=>'新增失败！','url'=>'']);
			}
		} else {
			View::assign([
				'meta_title' => '新增广告位',
				'info' => null,
			]);
			return view('edit');
		}
	}
	/**
     * @NodeAnotation(title="编辑")
     */
	public function edit($id = null)
	{
		if (empty($id)) {
			return json(['code'=>0,'msg'=>'参数错误！','url'=>'']);
		}
		// 当前配置类型信息
		$info = Db::name('adtype')->field(true)->find($id);
		if (request()->isAjax()) {
			$data = input('post.');
			$validate = new AdtypeValidate();
			if (!$validate->scene('edit')->check($data)) {
				return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
			}
			action_log($data['id'],'adtype',2);
			$res = Db::name('adtype')->strict(false)->update($data);
			if ($res !== false) {
				action_log($data['id'],'adtype',2);
				if ($info['sort'] == $data['sort']) {
					// 判断是否修改排序值如果修改就跳转到列表页，没有修改就跳转当前页
					return json(['code'=>1,'msg'=>'更新成功！','url'=>cookie('__forward__')]);
				} else {
					return json(['code'=>1,'msg'=>'更新成功！','url'=>'index']);
				}
			} else {
				return json(['code'=>0,'msg'=>'更新失败！','url'=>'']);
			}
		} else {
			if (!$info) {
				return json(['code'=>0,'msg'=>'信息错误！','url'=>'']);
			}
			View::assign([
				'meta_title' => '编辑广告位',
				'info' => $info,
			]);
			return view();
		}
	}
	/**
     * @NodeAnotation(title="删除")
     */
	public function del($ids = NULL) 
	{
		$ids = !empty($ids) ? $ids : input('ids', 0);
		if (empty($ids)) {
			return json(['code'=>0,'msg'=>'参数不能为空！','url'=>'']);
		}
		if (!is_array($ids)) {
			$ids = array(intval($ids));
		}
		$map[] = ['typeid', 'in', $ids];
		$adRes = Db::name('advert')->where($map)->find();
		if ($adRes) {
			return json(['code'=>0,'msg'=>'请先删除广告位下面的所有广告！','url'=>'']);
		}
		foreach($ids as $id){
			action_log($id,'adtype',3);
			Db::name('adtype')->delete($id);
		}
		return json(['code'=>1,'msg'=>'删除成功！','url'=>'']);
	}
	/**
	 * @NodeAnotation(title="排序")
	 * @param string $model
	 * @param array $data
	 * @return void
	 */
	public function sort($model = 'adtype', $data = array()) 
	{
		$data['sort'] = input('sort');
		return parent::sort($model, $data);
	}
}
