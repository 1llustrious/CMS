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
// | 友链控制器
// +----------------------------------------------------------------------
namespace app\admin\controller\cms;

use think\facade\Db;
use think\facade\View;
use app\admin\controller\Base;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
use app\admin\validate\cms\Links as LinksValidate;
/**
 * @ControllerAnnotation(title="友链管理")
 * Class Links
 * @package app\admin\controller\cms
 */
class Links extends Base
{
    /**
     * @NodeAnotation(title="列表")
     */
    public function index()
    {
        $map = array();
        $query = array();
        $status = trim(input('status'));
        $typeid = trim(input('typeid'));
        $title = trim(input('title'));
        if ($status !== '' && ($status == 0 || $status == 1)) {
            $map[] = ['status', '=', $status];
            $query['status'] = $status;
        }
        if ($typeid !== '' && is_numeric($typeid)) {
            $map[] = ['typeid', '=', $typeid];
            $query['typeid'] = $typeid;
        }
        if ($title) {
            $map[] = ['link|website_name', 'like', "%$title%"];
            $query['title'] = $title;
        }
        $order = ['sort' => 'desc', 'id' => 'desc'];
        $list = Db::name('links')
        ->where($map)
        ->order($order)
        ->paginate(get_one_config('WEB_ONE_PAGE_NUMBER'), false, ['query' => $query,])
        ->each(function ($item, $key) {
            int_to_string($item, $map = array('status' => array('0' => '未审核', '1' => '已审核')));
            return $item;
        });
        $linkTypeRes = Db::name('link_type')->select()->toArray();
        View::assign([
            'meta_title' => '友链列表',//标题
            'status' => $status,//状态
            'typeid' => $typeid,//友链类型id
            'list' => $list,//列表
            'linkTypeRes' => $linkTypeRes,
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
            $validate = new LinksValidate();
            if (!$validate->scene('add')->check($data)) {
                $this->error($validate->getError());
            }
            $data['create_time'] = time();
            if (strpos($data['url'], 'http://') !== false || strpos($data['url'], 'https://') !== false) {
                $data['url'] = $data['url'];
            } else {
                $data['url'] = 'http://' . $data['url'];
            }
            $id = Db::name('links')->strict(false)->insertGetId($data);
            if ($id) {
                // 记录新增后行为
                action_log($id, 'links', 1);
                $this->success('新增成功！', 'index');
            } else {
                $this->error('新增失败！');
            }
        } else {
            $linkTypeRes = Db::name('link_type')->field('id,name')->select()->toArray();
            View::assign([
                'meta_title' => '新增友链',//标题title
                'info' => null,
                'linkTypeRes' => $linkTypeRes,//友链类型
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
            exit();
        }
        $info = Db::name('links')->field(true)->find($id);//当前信息
        if (request()->isAjax()) { //提交表单
            $data = input('post.');
            $validate = new LinksValidate();
            if (!$validate->scene('edit')->check($data)) {
                $this->error($validate->getError());
            }
            action_log($data['id'], 'links' ,2);//记录修改前行为
            $res = Db::name('links')->strict(false)->update($data);
            if ($res !== false) {
                action_log($data['id'], 'links' ,2);//记录修改后行为
                // 判断是否修改排序值如果修改就跳转到列表页，没有修改就跳转当前页
                if ($info['sort'] == $data['sort']) {
                    $this->success('更新成功！', cookie('__forward__'));
                } else {
                    $this->success('更新成功！', 'Links/index');
                }
            } else {
                $this->error('更新失败！');
            }
        } else {
            if (!$info) {
                $this->error('信息错误！');
                exit();
            }
            $linkTypeRes = Db::name('link_type')->field('id,name')->select()->toArray();
            View::assign([
                'meta_title' => '编辑友链',//标题 title
                'info' => $info,
                'linkTypeRes' => $linkTypeRes,//友链类型
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
            action_log($id, 'links', 3);
            Db::name('link_type')->delete($id);
        }
        $this->success('删除成功！');
    }
    /**
     * @NodeAnotation(title="状态")
     */
    public function setStatus($model = 'links', $data = array(), $type = 3)
    {
        $ids = input('ids');
        $status = input('status');
        $data['ids'] = $ids;
        $data['status'] = $status;
        return parent::setStatus($model, $data, $type);
    }
    /**
     * @NodeAnotation(title="排序")
     */
    public function sort($model = 'links', $data = array())
    {
        $data['sort'] = input('sort');
        return parent::sort($model, $data);
    }
}
