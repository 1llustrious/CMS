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
// | 节点控制器
// +----------------------------------------------------------------------
namespace app\admin\controller;

use app\admin\model\SystemNode;
use app\common\auth\Node as NodeService;
use app\common\annotation\NodeAnotation;
use app\common\annotation\ControllerAnnotation;
/**
 * @ControllerAnnotation(title="系统节点管理")
 * Class Node
 * @package app\admin\controller
 */
class Node extends Base
{
    /**
     * @NodeAnotation(title="列表")
     */
    public function index()
    {
        $list = (new SystemNode())->getNodeTreeList();
        return view('',[
            'meta_title'=>'节点管理',
            'list'=>$list,
        ]);
    }
    /**
     * @NodeAnotation(title="系统节点更新")
     */
    public function refreshNode($force = 0)
    {
        $nodeList = (new NodeService())->getNodelist();
        empty($nodeList) && $this->error('暂无需要更新的系统节点');
        $model = new SystemNode();
        try {
            if ($force == 1) {
                $updateNodeList = $model->whereIn('node', array_column($nodeList, 'node'))->select();
                $formatNodeList = array_format_key($nodeList, 'node');
                foreach ($updateNodeList as $vo) {
                    isset($formatNodeList[$vo['node']]) && $model->where('id', $vo['id'])->update([
                        'title'   => $formatNodeList[$vo['node']]['title'],
                        'is_auth' => $formatNodeList[$vo['node']]['is_auth'],
                    ]);
                }
            }
            $existNodeList = $model->field('node,title,type,is_auth')->select();
            foreach ($nodeList as $key => $vo) {
                foreach ($existNodeList as $v) {
                    if ($vo['node'] == $v->node) {
                        unset($nodeList[$key]);
                        break;
                    }
                }
            }
            $model->saveAll($nodeList);
        } catch (\Exception $e) {
            return json(['code'=>0,'msg'=>'节点更新失败']);
        }
        return json(['code'=>1,'msg'=>'节点更新成功']);
    }
    /**
     * @NodeAnotation(title="清除失效节点",auth=false)
     */
    public function clearNode()
    {
        $nodeList = (new NodeService())->getNodelist();
        $model = new SystemNode();
        try {
            $existNodeList = $model->field('id,node,title,type,is_auth')->select()->toArray();
            $formatNodeList = array_format_key($nodeList, 'node');
            foreach ($existNodeList as $vo) {
                !isset($formatNodeList[$vo['node']]) && $model->where('id', $vo['id'])->delete();
            }
        } catch (\Exception $e) {
            return json(['code'=>0,'msg'=>'节点更新失败']);
        }
        return json(['code'=>1,'msg'=>'清除失效节点成功']);
    }
    /**
     * @NodeAnotation(title="设置节点状态")
     */
    public function setStatus($model = 'system_node', $data = array(), $type = 3) 
    {
		$ids = input('ids');
		$status = input('status');
		$data['ids'] = $ids;
		$data['is_auth'] = $status;
		return parent::setStatus($model, $data, $type);
	}
}