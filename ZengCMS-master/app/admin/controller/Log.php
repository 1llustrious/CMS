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
// | 日志控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use think\facade\Db;
use think\facade\View;
use think\facade\Config;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="日志管理")
 * Class Log
 * @package app\admin\controller
 */
class Log extends Base
{
    /**
     * @NodeAnotation(title="列表")
     */
    public function index()
    {
        $map = array();
        $query = array();
        $title = trim(input('title'));
        $status = trim(input('status'));
        $table_name = trim(input('table_name'));
        $type = trim(input('type'));
        if ($status !== '' && ($status == 0 || $status == 1)) {
            $map[] = ['status', '=', $status];
            $query['status'] = $status;
        }
        if ($table_name) {
            $map[] = ['table_name', '=', $table_name];
            $query['table_name'] = $table_name;
        }
        if ($type !== '' && ($type == 1 || $type == 2 || $type == 3)) {
            $map[] = ['type', '=', $type];
            $query['type'] = $type;
        }
        if ($title) {
            $where[] = ['name', 'like', "%$title%"];
            $adminIds = Db::name('admin')->field('id')->where($where)->select()->toArray();
            $adminIdsArr = array_column($adminIds, 'id');
            $map[] = ['admin_id', 'in', $adminIdsArr];
            $query['title'] = $title;
        }
        $data = input('get.');
        $data['start_date'] = isset($data['start_date']) ? $data['start_date'] : '';
        $data['end_date'] = isset($data['end_date']) ? $data['end_date'] : '';
        // 备份时间条件
        if ($data['start_date'] !== '' && $data['end_date'] == '') {
            $start_date = strtotime($data['start_date']);
            $time = time();
            $where2 = "dtime>={$start_date} AND dtime<={$time}";
        } elseif ($data['start_date'] !== '' && $data['end_date'] !== '') {
            $start_date = strtotime($data['start_date']);
            $end_date = strtotime($data['end_date']);
            $where2 = "dtime>={$start_date} AND dtime<={$end_date}";
        } elseif ($data['start_date'] == '' && $data['end_date'] !== '') {
            $end_date = strtotime($data['end_date']);
            $where2 = "dtime<={$end_date}";
        } else {
            $where2 = 1;
        }
        $query['start_date'] = $data['start_date'];
        $query['end_date'] = $data['end_date'];

        $order = ['id' => 'desc']; //排序
        $list = Db::name('log')->where($map)->where($where2)->order($order)->paginate(['list_rows'=> 8,'var_page' => 'page','query' => $query])->each(function ($item, $key) {
            int_to_string($item, $map = array('status' => array('0' => '未恢复', '1' => '已恢复')));
            int_to_string($item, $map = array('type' => array('1' => '新增', '2' => '修改', '3' => '删除')));
            $admin_name = Db::name('admin')->where(['id' => $item['admin_id']])->value('name');
            $item['admin_name'] = $admin_name;
            return $item;
        });
        $tableRes = Db::query('SHOW TABLE STATUS');
        $prefix = Config::get('database.connections.mysql.prefix'); //表前缀
        // array_change_key_case() 函数将数组的所有的键都转换为大写字母或小写字母。
        // 数组的数字索引不发生变化。如果未提供可选参数（即第二个参数），则默认转换为小写字母。
        $tableRes = array_map('array_change_key_case', $tableRes);
        foreach ($tableRes as $k => $v) {
            $tableList[] = str_replace($prefix, '', $v['name']);
        }
        View::assign([
            'status' => $status, //恢复状态
            'type' => $type, //操作类型
            'table_name' => $table_name, //表名
            'meta_title' => '操作日志', //标题
            'list' => $list, // 列表
            'tableList' => $tableList,
        ]);
        // 记录当前列表页的cookie
        cookie('__forward__', $_SERVER['REQUEST_URI']);
        return view();
    }
    /**
     * @NodeAnotation(title="查看详细")
     */
    public function log_content($id = null)
    {
        if (empty($id)) {
            return json(['code'=>0,'msg'=>'参数错误！','url'=>'']);
        }
        $info = Db::name('log')->alias('l')->field('l.*,a.name admin_name')->leftJoin('admin a', 'l.admin_id=a.id')->find($id);//日志主表信息
        int_to_string($info, array('type' => array('1' => '新增', '2' => '修改', '3' => '删除')));
        if (!$info) {
            return json(['code'=>0,'msg'=>'信息错误！','url'=>'']);
        }
        $list = Db::name('log_content')->where(['log_id' => $id])->select()->toArray();
        // print_r($list);die;
        View::assign([
            'meta_title' => '日志详细',
            'list' => $list,
            'info' => $info,
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
        $map[] = ['log_id', 'in', $ids];
        $del_log_content = Db::name('log_content')->where($map)->delete();
        $del_log = Db::name('log')->delete($ids);
        if ($del_log_content || $del_log) {
            return json(['code'=>1,'msg'=>'删除成功！','url'=>'']);
        } else {
            return json(['code'=>0,'msg'=>'删除失败！','url'=>'']);
        }
    }
    /**
     * @NodeAnotation(title="恢复日志")
     */
    public function recover($ids = NULL)
    {
        $ids = !empty($ids) ? $ids : input('ids', 0);
        if (empty($ids)) {
            return json(['code'=>0,'msg'=>'参数不能为空！','url'=>'']);
        }
        $logRes = Db::name('log')->find($ids);
        // 模型信息和模型字段信息需要根据日志内容手动恢复
        if($logRes['table_name'] == 'attribute'){
            return json(['code'=>0,'msg'=>'模型字段信息，请根据日志内容手动恢复','url'=>'']);
        }
        if($logRes['table_name'] == 'model'){
            return json(['code'=>0,'msg'=>'模型信息，请根据日志内容手动恢复','url'=>'']);
        }
        // print_r($logRes);die;
        if ($logRes['status'] == 0 && $logRes['type'] == 2) { //恢复修改内容
            $map[] = ['log_id', '=', $ids];
            $logContentRes = Db::name('log_content')->where($map)->select()->toArray();
            // print_r($logContentRes);die;
            if ($logContentRes) {
                foreach ($logContentRes as $k => $v) {
                    $data[$v['field_name']] = $v['field_value'];
                }
                $res = Db::name($logRes['table_name'])->where('id', $logRes['table_pk_id'])->update($data);
                if ($res) {
                    Db::name('log')->where('id', $ids)->update(['status' => 1]);
                    return json(['code'=>1,'msg'=>'恢复成功！','url'=>'']);
                } else {
                    return json(['code'=>0,'msg'=>'恢复失败！','url'=>'']);
                }
            } else {
                return json(['code'=>0,'msg'=>'没有内容可恢复！','url'=>'']);
            }
        } elseif ($logRes['status'] == 0 && $logRes['type'] == 3) { //恢复删除内容
            $map[] = ['log_id', '=', $ids];
            $logContentRes = Db::name('log_content')->where($map)->select()->toArray();
            // print_r($logContentRes);die;
            if ($logContentRes) {
                foreach ($logContentRes as $k => $v) {
                    $data[$v['field_name']] = $v['field_value'];
                }
                // print_r($data);die;
                $res = Db::name($logRes['table_name'])->insert($data);
                // print_r($res);die;
                if ($res) {
                    Db::name('log')->where('id', $ids)->update(['status' => 1]);
                    return json(['code'=>1,'msg'=>'恢复成功！','url'=>'']);
                } else {
                    return json(['code'=>0,'msg'=>'恢复失败！','url'=>'']);
                }
            } else {
                return json(['code'=>0,'msg'=>'没有内容可恢复！','url'=>'']);
            }
        }
    }
    /**
     * @NodeAnotation(title="清空所有日志")
     */
    public function clear_log()
    {
        $prefix = Config::get('database.connections.mysql.prefix');
        $log_table_name = $prefix . 'log';
        // echo $log_table_name;die;
        $log_content_table_name = $prefix . 'log_content';
        Db::query("truncate table" . ' ' . $log_table_name);
        Db::query("truncate table" . ' ' . $log_content_table_name);
        return json(['code'=>1,'msg'=>'清空日志成功！','url'=>'']);
    }
}
