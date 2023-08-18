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
// | 管理员行为日志控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\facade\Db;
use think\facade\View;
use think\facade\Config;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="管理员行为日志管理")
 * Class Logs
 * @package app\admin\controller
 */
class Logs extends Base
{
    /**
     * @NodeAnotation(title="行为日志列表")
     */
    public function index()
    {
        $map = array();
        $query = array();
        $admin_id = input('admin_id');
        if (is_numeric($admin_id)) {
            $map[] = ['operator', '=', $admin_id];
            $query['admin_id'] = $admin_id;
        }
        $title = trim(input('title'));
        if ($title) {
            $map[] = ['url|description|operate_ip|operate_area', 'like', "%$title%"];
            $query['title'] = $title;
        }
        // 时间条件 开始
        $data = input('get.');
        $data['start_date'] = isset($data['start_date']) ? $data['start_date'] : '';
        $data['end_date'] = isset($data['end_date']) ? $data['end_date'] : '';
        if ($data['start_date'] !== '' && $data['end_date'] == '') {
            $start_date = strtotime($data['start_date']);
            $time = time();
            $where2 = "operate_time>={$start_date} AND operate_time<={$time}";
        } elseif ($data['start_date'] !== '' && $data['end_date'] !== '') {
            $start_date = strtotime($data['start_date']);
            $end_date = strtotime($data['end_date']);
            $where2 = "operate_time>={$start_date} AND operate_time<={$end_date}";
        } elseif ($data['start_date'] == '' && $data['end_date'] !== '') {
            $end_date = strtotime($data['end_date']);
            $where2 = "operate_time<={$end_date}";
        } else {
            $where2 = 1;
        }
        $query['start_date'] = $data['start_date'];
        $query['end_date'] = $data['end_date'];
        // 时间条件 结束
        $order = ['id' => 'desc'];//排序
        // 日志列表
        $list = Db::name('logs')->where($map)->where($where2)->order($order)
        ->paginate(['list_rows'=> 8,'var_page' => 'page','query' => $query])
        ->each(function ($item, $key) {
            $admin_name = Db::name('admin')->where(['id' => $item['operator']])->value('name');
            $item['name'] = $admin_name;
            return $item;
        });
        $adminRes = Db::name('admin')->select()->toArray();
        View::assign([
            'list' => $list,//行为日志列表
            'meta_title' => '行为日志',//标题
            'adminRes' => $adminRes,//所有管理员
            'admin_id' => $admin_id,//管理员ID
        ]);
        return view();
    }
    /**
     * @NodeAnotation(title="删除日志")
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
        Db::name('logs')->delete($ids);
        return json(['code'=>1,'msg'=>'删除成功！','url'=>'index']);
    }
    /**
     * @NodeAnotation(title="清空所有日志")
     */
    public function clear_log()
    {
        $prefix = Config::get('database.connections.mysql.prefix');
        $logs_table_name = $prefix . 'logs';
        Db::query("truncate table" . ' ' . $logs_table_name);
        return json(['code'=>1,'msg'=>'清空成功！','url'=>'']);
    }
}
