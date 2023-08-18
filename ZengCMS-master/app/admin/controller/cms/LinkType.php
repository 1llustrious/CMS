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
// | 友链类型控制器
// +----------------------------------------------------------------------
namespace app\admin\controller\cms;

use think\facade\Db;
use think\facade\View;
use app\admin\controller\Base;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
use app\admin\validate\cms\LinkType as LinkTypeValidate;
/**
 * @ControllerAnnotation(title="友链类型管理")
 * Class LinkType
 * @package app\admin\controller\cms
 */
class LinkType extends Base
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
        $list = Db::name('link_type')->where($map)->order($order)
        ->paginate(get_one_config('WEB_ONE_PAGE_NUMBER'), false, [
            'query' => $query,
        ]);
        View::assign([
            'meta_title' => '友链类型',
            'list' => $list,
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
            $validate = new LinkTypeValidate();
            if (!$validate->scene('add')->check($data)) {
                $this->error($validate->getError());
            }
            $id = Db::name('link_type')->strict(false)->insertGetId($data);
            if ($id) {
                // 记录新增后行为
                action_log($id, 'link_type', 1);
                $this->success('新增成功！', 'index');
            } else {
                $this->error('新增失败！');
            }
        } else {
            View::assign([
                'meta_title' => '新增友链类型',
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
        // 当前配置类型信息
        $info = Db::name('link_type')->field(true)->find($id);
        if (request()->isAjax()) {
            $data = input('post.');
            $validate = new LinkTypeValidate();
            if (!$validate->scene('edit')->check($data)) {
                $this->error($validate->getError());
            }
            action_log($data['id'], 'link_type' ,2);//记录修改前行为
            $res = Db::name('link_type')->strict(false)->update($data);
            if ($res !== false) {
                action_log($data['id'], 'link_type' ,2);//记录修改后行为
                // 判断是否修改排序值如果修改就跳转到列表页，没有修改就跳转当前页
                if ($info['sort'] == $data['sort']) {
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
                'meta_title' => '编辑友链类型',
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
        $map[] = ['link_type_id', 'in', $ids];
        $linkRes = Db::name('links')->where($map)->find();
        if ($linkRes) {
            $this->error('请先删除友链类型下的所有友链！');
        }
        foreach($ids as $id){
            action_log($id, 'link_type', 3);
            Db::name('link_type')->delete($id);
        }
        $this->success('删除成功！');
    }
    /**
     * @NodeAnotation(title="排序")
     */
    public function sort($model = 'link_type', $data = array())
    {
        $data['sort'] = input('sort');
        return parent::sort($model, $data);
    }
}
