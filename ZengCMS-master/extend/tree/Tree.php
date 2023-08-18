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
// | 找子孙树、家谱插件
// +----------------------------------------------------------------------
namespace tree;

class Tree
{
    /**
     * [Description 找某分类的子孙树$id=0代表顶级分类(使用递归+静态static)]
     * @DateTime 2020-02-25 08:48:50
     * @param [type] $data
     * @param integer $id
     * @param integer $level
     * @return void
     */
    public function ChildrenTree($data, $id = 0, $level = 0)
    {
        return $this->sort($data, $id, $level);
    }
    private function sort($data, $id, $level)
    {
        static $tree = array();
        foreach ($data as $k => $v) {
            if ($v['pid'] == $id) {
                $v['level'] = $level;
                $tree[] = $v;
                $this->sort($data, $v['id'], $level + 1);
            }
        }
        return $tree;
    }
    /**
     * [Description 找某分类的所有子分类id，注意不包含自身id(使用递归+静态static)]
     * @DateTime 2020-02-25 08:38:27
     * @param [type] $object
     * @param integer $id
     * @return void
     */
    public function ChildrenIdsArr($object, $id = 0)
    {
        $data = $object->field('pid,id')->select()->toArray();
        return $this->_ChildrenIdsArr($data, $id, TRUE);
    }
    private function _ChildrenIdsArr($data, $id, $clear = FALSE)
    {
        static $tree = array();
        if ($clear) {
            $tree = array();
        }
        foreach ($data as $k => $v) {
            if ($v['pid'] == $id) {
                $tree[] = $v['id'];
                $this->_ChildrenIdsArr($data, $v['id']);
            }
        }
        return $tree;
    }
    /**
     * [Description 找某栏目的所有子栏目id(使用递归+array_merge()函数)]
     * @DateTime 2020-02-25 08:39:08
     * @param [type] $object
     * @param integer $id
     * @return void
     */
    /* public function ChildrenIdsArr($object, $id = 0)
    {
        $data = $object->field('pid,id')->select()->toArray();
        return $this->_ChildrenIdsArr($data, $id);
    }
    private function _ChildrenIdsArr($data, $id)
    {
        $tree = array();
        foreach ($data as $k => $v) {
            if ($v['pid'] == $id) {
                $tree[] = $v['id'];
                $tree = array_merge($tree, $this->_ChildrenIdsArr($data, $v['id']));
            }
        }
        return $tree;
    } */
    /**
     * [Description 找某分类的家谱树(使用递归-先归后递+array_merge()函数)]
     * @DateTime 2020-02-25 08:39:21
     * @param [type] $data
     * @param [type] $id
     * @return void
     */
    public function ParentTree($data, $id)
    {
        return $this->_ParentTree($data, $id);
    }
    /**
     * [Description 利用递归找家谱,再利用先归后递]
     * @DateTime 2020-02-25 08:39:35
     * @param [type] $data
     * @param [type] $id
     * @return void
     */
    private function _ParentTree($data, $id)
    {
        $tree = array();
        foreach ($data as $k => $v) {
            if ($v['id'] == $id) {
                if ($v['pid'] > 0) {
                    $tree = array_merge($tree, $this->_ParentTree($data, $v['pid']));
                }
                $tree[] = $v;
            }
        }
        return $tree;
    }
    /**
     * [Description 找某分类的家谱树(使用迭代+反转数组array_reverse()函数)]
     * @DateTime 2020-02-25 08:40:01
     * @param [type] $data
     * @param [type] $id
     * @return void
     */
    /* public function ParentTree($data, $id)
    {
        return $this->_ParentTree($data, $id);
    }
    private function _ParentTree($data, $id)
    {
        $tree = array();
        while ($id > 0) {
            foreach ($data as $k => $v) {
                if ($v['id'] == $id) {
                    $tree[] = $v;
                    $id = $v['pid'];
                    break;
                }
            }
        }
        return array_reverse($tree);
    } */
}
