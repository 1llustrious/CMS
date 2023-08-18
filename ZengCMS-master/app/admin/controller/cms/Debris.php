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
// | 碎片控制器
// +----------------------------------------------------------------------
namespace app\admin\controller\cms;

use think\facade\Db;
use think\facade\View;
use app\admin\controller\Base;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
use app\admin\validate\cms\Debris as DebrisValidate;
/**
 * @ControllerAnnotation(title="碎片管理")
 * Class Debris
 * @package app\admin\controller\cms
 */
class Debris extends Base
{
    /**
     * @NodeAnotation(title="列表")
     */
    public function index()
    {
        $map = array();
        $query = array();
        $status = trim(input('status'));
        $title = trim(input('title'));
        $posid = trim(input('posid'));
        if ($status !== '' && ($status == 0 || $status == 1)) {
            $map[] = ['status', '=', $status];
            $query['status'] = $status;
        }
        if ($posid !== '' && is_numeric($posid)) {
            $map[] = ['posid', '=', $posid];
            $query['posid'] = $posid;
        }
        if ($title) {
            $map[] = ['title', 'like', "%$title%"];
            $query['title'] = $title;
        }
        $order = ['sort' => 'desc', 'id' => 'desc'];
        $list = Db::name('debris')
        ->where($map)
        ->order($order)
        ->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query])
        ->each(function ($item, $key) {
            int_to_string($item, $map = array('status' => array('0' => '隐藏', '1' => '显示')));
            $item['debris_pos_name'] = Db::name('debris_pos')->where('id', $item['posid'])->value('name');
            return $item;
        });
        $debrisPosRes = Db::name('debris_pos')->select()->toArray();
        // 记录当前列表页的cookie
        cookie('__forward__', $_SERVER['REQUEST_URI']);
        return view('index',[
            'meta_title' => '碎片管理',//标题
            'status' => $status,//状态
            'posid' => $posid,//碎片位id
            'debrisPosRes' => $debrisPosRes,//碎片位列表
            'list' => $list,//碎片列表
        ]);
    }
    /**
     * @NodeAnotation(title="新增")
     */
    public function add()
    {
        if (request()->isAjax()) {
            $data = input('post.');
            $validate = new DebrisValidate();
            if (!$validate->scene('add')->check($data)) {
                $this->error($validate->getError());
            }
            $data['create_time'] = time();
            $data['update_time'] = time();
            $id = Db::name('debris')->strict(false)->insertGetId($data);
            if ($id) {
                action_log($id,'debris',1);
                $this->success('新增成功！', 'index');
            } else {
                return $this->error('新增失败！');
            }
        } else {
            $posid = input('posid');
            $DebrisPosRes = Db::name('debris_pos')->field('id,name')->select()->toArray();
            return view('edit',[
                'meta_title' => '新增碎片',//标题title
                'info' => null,
                'posid' => $posid,//碎片位id
                'DebrisPosRes' => $DebrisPosRes,//碎片位信息
            ]);
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
        $info = Db::name('debris')->field(true)->find($id);
        if (request()->isAjax()) {
            $data = input('post.');
            $validate = new DebrisValidate();
            if (!$validate->scene('edit')->check($data)) {
                $this->error($validate->getError());
            }
            $data['update_time'] = time();
            action_log($data['id'],'debris',2);
            $res = Db::name('debris')->strict(false)->update($data);
            if ($res !== false) {
                action_log($data['id'],'debris',2);
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
            $DebrisPosRes = Db::name('debris_pos')->field('id,name')->select()->toArray();
            return view('edit',[
                'meta_title' => '编辑碎片',
                'info' => $info,
                'DebrisPosRes' => $DebrisPosRes,//碎片位信息
            ]);
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
			action_log($id,'debris',3);
			Db::name('debris')->delete($id);
		}
		return json(['code'=>1,'msg'=>'删除成功！','url'=>'']);
    }
    /**
	 * @NodeAnotation(title="状态")
	 * [setStatus 设置一条或者多条数据的状态 或 删除一条或多条数据的基本信息]
	 * @param string  $model [表名]
	 * @param array   $data  [数据]
	 * @param integer $type  [类型]
	 */
    public function setStatus($model = 'debris', $data = array(), $type = 3)
    {
        $ids = input('ids');
        $status = input('status');
        $data['ids'] = $ids;
        $data['status'] = $status;
        return parent::setStatus($model, $data, $type);
    }
    /**
	 * @NodeAnotation(title="排序")
	 * @param  string $model [表名]
	 * @param  array  $data  [数据]
	 * @return [type]        [description]
	 */
    public function sort($model = 'debris', $data = array())
    {
        $data['sort'] = input('sort');
        return parent::sort($model, $data);
    }
}
