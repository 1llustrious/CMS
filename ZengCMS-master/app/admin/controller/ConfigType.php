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
// | 配置类型控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\facade\Db;
use think\facade\View;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="配置类型管理")
 * Class ConfigType
 * @package app\admin\controller
 */
class ConfigType extends Base
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
            $map[] = ['config_type_name', 'like', "%$title%"];
            $query['title'] = $title;
        }
        $list = Db::name('config_type')->where($map)->order(['sort' => 'desc', 'id' => 'asc'])
        ->paginate(['list_rows'=> get_one_config('WEB_ONE_PAGE_NUMBER'),'var_page' => 'page','query' => $query])
        ->each(function ($item, $key) {
            int_to_string($item,array('status' => array('0' => '隐藏', '1' => '显示')));
            return $item;
        });
        View::assign([
            'meta_title' => '配置类型列表', //标题
            'status' => $status, //状态
            'list' => $list, // 列表
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
            // 数据验证
            $validate = validate('ConfigType');
            if (!$validate->scene('add')->check($data)) {
                return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
            }
            $data['create_time'] = time(); //创建时间
            $id = Db::name('config_type')->strict(true)->insertGetId($data); //新增基础内容
			if (!$id) {
                return json(['code'=>0,'msg'=>'新增出错！','url'=>'']);
			}
			// 记录新增后行为
			action_log($id,'config_type',1);
            return json(['code'=>1,'msg'=>'新增成功！','url'=>'index']);
        } else {
            View::assign([
                'meta_title' => '新增配置类型',//标题title
                'info' => null,//空信息
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
        $info = Db::name('config_type')->find($id); // 当前信息
        if (request()->isAjax()) {
            $data = input('post.');
            // 数据验证
            $validate = validate('ConfigType');
            if (!$validate->scene('edit')->check($data)) {
                return json(['code'=>0,'msg'=>$validate->getError(),'url'=>'']);
            }
            $data['id'] = intval($data['id']);
			if ($data['id'] == 0) {
                return json(['code'=>0,'msg'=>'非法操作！','url'=>'']);
            }
            $data['update_time'] = time(); // 最后一次修改时间
			action_log($data['id'],'config_type', 2); // 记录修改前行为
			$res = Db::name('config_type')->strict(false)->where('id',$data['id'])->update($data); //更新基础内容
			if(!$res){
                return json(['code'=>0,'msg'=>'更新失败！','url'=>'']);
            }
            action_log($data['id'],'config_type',2); // 记录修改后行为
            // 判断是否修改排序值如果修改就跳转到列表页，没有修改就跳转当前页
            if ($info['sort'] == $data['sort']) { 
                return json(['code'=>1,'msg'=>'更新成功！','url'=>cookie('__forward__')]);
            } else {
                return json(['code'=>1,'msg'=>'更新成功！','url'=>'index']);
            }
        } else {
            if (!$info) {
                return json(['code'=>0,'msg'=>'信息错误！','url'=>'']);
            }
            View::assign([
                'meta_title' => '编辑配置类型',//标题 title
                'info' => $info, // 当前信息
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
        // 判断该配置类型下有没有配置，如有提示 请先删除该配置类型下的所有配置！
        $map[] = ['config_type_id', 'in', $ids];
        $configRes = Db::name('config')->field('id')->where($map)->select()->toArray();
        if ($configRes) {
            return json(['code'=>0,'msg'=>'请先删除该配置类型下的所有配置！','url'=>'']);
        } else {
            // 删除该配置类型信息
            foreach ($ids as $k => $v) {
                // 记录删除行为
                action_log($v,'config_type',3);
                Db::name('config_type')->delete($v);
            }
            return json(['code'=>1,'msg'=>'删除配置类型成功！','url'=>'']);
        }
    }
    /**
     * @NodeAnotation(title="状态")
     */
    public function setStatus($model = 'config_type', $data = array(), $type = 1)
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
    public function sort($model = 'config_type', $data = array())
    {
        $data['sort'] = input('sort');
        return parent::sort($model, $data);
    }
}
