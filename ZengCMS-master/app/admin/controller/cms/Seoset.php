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
// | 优化设置控制器
// +----------------------------------------------------------------------
namespace app\admin\controller\cms;

use think\facade\Db;
use think\facade\View;
use app\admin\controller\Base;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="优化设置管理")
 * Class Seoset
 * @package app\admin\controller\cms
 */
class Seoset extends Base
{
    /**
     * @NodeAnotation(title="首页优化")
     */
    public function site()
    {
        $map[] = ['ename', 'in', 'WEB_SITE_TITLE,WEB_SITE_TITLE_EN,WEB_SITE_KEYWORDS,WEB_SITE_KEYWORDS_EN,WEB_SITE_DESCRIPTION,WEB_SITE_DESCRIPTION_EN'];
        $map[] = ['status','=',1];
        $list = Db::name('config')->where($map)->order('sort desc')->field('id,cname,ename,value,values,form_type,remark')->select()->toArray();
        // dump($list);die;
        // 记录当前列表页的cookie
        cookie('__forward__', $_SERVER['REQUEST_URI']);
        View::assign([
            'meta_title' => '首页优化',
            'list' => $list,
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="栏目优化")
     */
    public function category()
    {
        $tree = Db::name('arctype')->field('id,pid,typename,name')->order('sort asc,id asc')->select()->toArray();
        $tree = cate_level($tree);//栏目层级归类
        cookie('__forward__', $_SERVER['REQUEST_URI']);
        View::assign([
            'meta_title' => '栏目优化',
            'list' => $tree,
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="编辑栏目")
     */
    public function editCategory($id = null)
    {
        $Category = Db::name('arctype');
        if (request()->isPost()) { //提交表单
            $data = input('post.');
            if (false !== $Category->where('id', $data['id'])->strict(false)->update($data)) {
                $this->success('编辑成功！', cookie('__forward__'));
            } else {
                $this->error('编辑失败！');
            }
        } else {
            if (empty($id)) {
                $this->error('参数错误！', cookie('__forward__'));
            }
            // 获取分类信息
            $info = $id ? $Category->find($id) : '';
            View::assign([
                'meta_title' => '编辑【' . $info['typename'] . '】栏目',
                'info' => $info,
            ]);
            return view();
        }
    }
    /**
     * @NodeAnotation(title="地区优化")
     */
    public function area()
    {
        if (request()->isPost()) {
            //更新优化城市
            $map[] = ['ename', '=', 'WEB_SEO_CITY'];
            $data['value'] = json_encode(input('area'));
            $flag = Db::name('config')->where($map)->update($data);
            //更新优化栏目
            $map2[] = ['ename', '=', 'WEB_SEO_MENU'];
            $data2['value'] = json_encode(input('seomenu'));
            $flag2 = Db::name('config')->where($map2)->update($data2);
            if ($flag || $flag2) {
                $this->success('更新成功！', url('area'));
            } else {
                $this->error('更新失败！', url('area'));
            }
        } else {
            $map[] = ['leveltype', '<', 3];
            //获取城市信息
            $area = Db::name('region')->where($map)->field('id,name,shortname')->select()->toArray();
            unset($area[0]);
            $tmap[] = ['status', '=', 1];
            $tmap[] = ['pid', '=', 0];
            //获取顶级栏目信息
            $arctype = Db::name("arctype")->field("id,typename")->where($tmap)->order("sort asc,id asc")->select()->toArray();
            //获取已优化城市
            $map2[] = ['ename', '=', 'WEB_SEO_CITY'];
            $info = Db::name('config')->where($map2)->field('value')->find();
            //获取已地区优化栏目
            $map3[] = ['ename', '=', 'WEB_SEO_MENU'];
            $tpinfo = Db::name('config')->where($map3)->field('value')->find();
            $tpinfo = json_decode($tpinfo['value']);
            if ($tpinfo) {
                $tpinfo = implode(',', $tpinfo);
            }
            View::assign([
                'meta_title' => '地区优化',
                'area' => $area,//所有城市信息
                'arctype' => $arctype,//所有顶级栏目信息
                'info' => $info,//获取城市信息
                'tpinfo' => $tpinfo,//获取已地区优化的栏目
            ]);
            return view();
        }
    }
    /**
     * @NodeAnotation(title="长尾词优化")
     */
    public function longKey()
    {
        $map[] = ['ename', 'in', 'WEB_LONGKEY_PREFIX,WEB_LONGKEY_SUFFIX'];
        $list = Db::name('config')->where($map)->field('id,cname,ename,value,values,form_type,remark')->select()->toArray();
        View::assign([
            'meta_title' => "长尾词优化",
            'list' => $list,
        ]);
        // 记录当前列表页的cookie
        cookie('__forward__', $_SERVER['REQUEST_URI']);
        return view();
    }
    /**
     * @NodeAnotation(title="优化操作")
     */
    public function operate()
    {
        if (request()->isPost()) {
            $num = null;
            for ($i = 0; $i < count($_POST["id"]); $i++) {
                $data["id"] = intval($_POST["id"][$i]);
                $data["cname"] = $_POST["cname"][$i];
                $data["ename"] = $_POST["ename"][$i];
                $data["value"] = $_POST["content"][$i];
                $arr = Db::name('config')->where('id', $data['id'])->update($data);
                if (is_numeric($arr)) {
                    $num += $arr;
                }
            }
            if ($num) {
                $this->success('更新成功！', cookie('__forward__'));
            } else {
                $this->error('内容无更新！', cookie('__forward__'));
            }
        } else {
            $this->error('更新失败！', cookie('__forward__'));
        }
    }
}