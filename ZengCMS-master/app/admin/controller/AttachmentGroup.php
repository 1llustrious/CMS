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
// | 附件分组控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\facade\Db;
use think\facade\View;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="附件分组管理")
 * Class AttachmentGroup
 * @package app\admin\controller
 */
class AttachmentGroup extends Base 
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
		$list = Db::name('attachment_group')->where($map)->order($order)
		->paginate(get_one_config('WEB_ONE_PAGE_NUMBER'), false, [
			'query' => $query,
		]);
		View::assign([
			'meta_title' => '分组管理', //标题
			'list' => $list, //列表
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
			//提交表单
			$data = input('post.');
			$data['create_time'] = time();
			$data['update_time'] = time();
			// 验证
			$validate = validate('attachment_group');
			if (!$validate->scene('add')->check($data)) {
				$this->error($validate->getError());
			}
			$id = Db::name('attachment_group')->strict(false)->insertGetId($data);
			if ($id) {
				action_log($id, 'attachment_group', 1);
				$this->success('新增成功！', 'index');
			} else {
				$this->error('新增失败！');
			}
		} else {
			View::assign([
				'meta_title' => '新增分组', //标题title
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
			$this->error('参数错误！');
		}
		$info = Db::name('attachment_group')->field(true)->find($id);
		if (request()->isAjax()) {
			$data = input('post.');
			$validate = validate('attachment_group');
			if (!$validate->scene('edit')->check($data)) {
				$this->error($validate->getError());
			}
			$data['update_time'] = time();
			action_log($data['id'],'attachment_group',2);//记录修改前行为
			$res = Db::name('attachment_group')->strict(false)->update($data);
			if ($res !== false) {
				action_log($data['id'],'attachment_group',2);//记录修改后行为
				if ($info['sort'] == $data['sort']) {
					// 判断是否修改排序值如果修改就跳转到列表页，没有修改就跳转当前页
					$this->success('更新成功！', cookie('__forward__'));
				} else {
					$this->success('更新成功！', 'index');
				}
			} else {
				$this->error('更新失败！');
			}
		} else {
			if (!$info) {
				$this->error('信息错误！');
			}
			View::assign([
				'meta_title' => '编辑分组', //标题 title
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
			$this->error('参数不能为空！');
		}
		if (!is_array($ids)) {
			$ids = array(intval($ids));
		}
		foreach($ids as $id){
            action_log($id, 'attachment_group', 3);
            Db::name('attachment_group')->delete($id);
        }
        $this->success('删除成功！');
	}
	/**
     * @NodeAnotation(title="排序")
     */
	public function sort($model = 'attachment_group', $data = array()) 
	{
		$data['sort'] = input('sort');
		return parent::sort($model, $data);
	}
}
