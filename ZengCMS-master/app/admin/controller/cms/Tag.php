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
// | TAG标签控制器
// +----------------------------------------------------------------------
namespace app\admin\controller\cms;

use think\facade\Db;
use think\facade\View;
use app\admin\controller\Base;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="TAG标签管理")
 * Class Tag
 * @package app\admin\controller\cms
 */
class Tag extends Base
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
        if ($status !== '' && ($status == 0 || $status == 1)) {
            $map[] = ['status', '=', $status];
            $query['status'] = $status;
        }
        if ($title) {
            $map[] = ['name', 'like', "%$title%"];
            $query['title'] = $title;
        }
        $order = ['sort' => 'desc', 'id' => 'asc'];
        $list = Db::name('tag')->where($map)->order($order)
        ->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query])
        ->each(function ($item, $key) {
            int_to_string($item, array('status' => array('0' => '隐藏', '1' => '显示')));
            return $item;
        });
        View::assign([
            'meta_title' => 'TAG标签列表',
            'status' => $status,
            'list' => $list,
        ]);
        // 记录当前列表页的cookie
        cookie('__forward__', $_SERVER['REQUEST_URI']);
        return view();
    }
    /**
     * @NodeAnotation(title="编辑")
     */
    public function edit($id = null)
    {
        if (empty($id)) {
            return json(['code'=>0,'msg'=>'参数错误！','url'=>'']);
        }
        $info = Db::name('tag')->find($id);
        if(request()->isPost()){
            $data = input('post.');
            $data['update_time'] = time();
            action_log($data['id'],'tag',2);
            $res = Db::name('tag')->strict(false)->update($data);
            if($res !== false){
                action_log($data['id'],'tag',2);
                $this->success('更新成功！');
            }
            $this->error('更新失败！');
        }
        $info = Db::name('tag')->find($id);
        View::assign([
            'meta_title'=>'编辑',
            'info'=>$info,
        ]);
        return view();
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
        foreach ($ids as $k => $v) {
            action_log($v,'tag', 3);
            Db::name('tag')->delete($v);
            Db::name('tagmap')->where('tag_id', $v)->delete();
        }
        return json(['code'=>1,'msg'=>'删除成功！','url'=>'']);
    }
    /**
     * @NodeAnotation(title="状态")
     */
    public function setStatus($model = 'tag', $data = array(), $type = 1)
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
    public function sort($model = 'tag', $data = array())
    {
        $data['sort'] = input('sort');
        return parent::sort($model, $data);
    }
    /**
     * @NodeAnotation(title="数据重建")
     */
    public function rebuilt()
    {
        if(request()->isPost()){
            $curr = input('curr');
            $limit = 3;
            $ids = Db::name('tag')->field('id')->page($curr,$limit)->select()->toArray();
            if(!$ids){
                return json(['code'=>2,'msg'=>'重建完成！']);
            }
            $i = 0;
            foreach($ids as $k=>$v){
                if(!Db::name('tagmap')->where('tag_id',$v['id'])->find()){
                    Db::name('tag')->delete($v['id']);
                    $i = 1;
                }
            }
            if(!$i){
                $curr = $curr + 1;
            }
            return json(['code'=>1,'curr'=>$curr,'msg'=>'重建成功！']);
        }
    }
}
