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
// | 钩子模型
// +----------------------------------------------------------------------
namespace app\admin\model;

use think\Model;
use app\common\annotation\HooksAnotation;
use Doctrine\Common\Annotations\FileCacheReader;
use Doctrine\Common\Annotations\AnnotationReader;
use Doctrine\Common\Annotations\AnnotationRegistry;

class Hooks extends Model
{
    /**
     * 更新插件里的所有钩子对应的插件
     * @param  [$addons_name] 插件名称        
     * @return [type]
     */
    public function updateHooks($addons_name)
    {
        $addons_class = get_addon_class($addons_name);
        if (!class_exists($addons_class)) {
            $this->error = "未实现{$addons_name}插件的入口文件";
            return false;
        }
        $actionList = $this->getHooksAnotation($addons_class,$addons_name);
        if($actionList){
            foreach($actionList as $k=>$v){
                // 判断钩子是否存在 不存在就新增
                if (empty($this->where('name',$v['name'])->find())) {
                    $v['addons'] = $addons_name;
                    $v['create_time'] = time();
                    $v['update_time'] = time();
                    self::create($v);
                }else{
                    self::where('name',$v['name'])->update([
                        'type'=>$v['type'],
                        'system'=>$v['system'],
                        'status'=>$v['status'],
                        'update_time'=>time()
                    ]);
                    $flag = $this->updateAddons($v['name'], array($addons_name),array($v['description']));
                    if (false === $flag) {
                        $this->removeHooks($addons_name);
                        return false;
                    }
                }
            }
        }else{
            $this->removeHooks($addons_name); 
        }
        // 获取这个插件总的方法列表，数组
        /* $methods = get_class_methods($addons_class);
        $methods = array_map(function ($item) {return parseName($item, 0, false);}, $methods);
        $notHook = ['install','uninstall','enabled','disabled','construct','get_info','get_config'];
        foreach($methods as $k=>$v){
            if(in_array($v,$notHook)){
                unset($methods[$k]);
            }
        }
        $hooks  = $this->column('name');
        $common = array_intersect($hooks, $methods);
        if (!empty($common)) {
            foreach ($common as $hook) {
                $flag = $this->updateAddons($hook, array($addons_name));
                if (false === $flag) {
                    $this->removeHooks($addons_name);
                    return false;
                }
            }
        } */
        return true;
    }
    /**
     * 去除插件所有钩子里对应的插件数据
     * @param  [$addons_name] 插件名称        
     * @return [type]
     */
    public function removeHooks($addons_name)
    {
        $addons_class = get_addon_class($addons_name);
        if (!class_exists($addons_class)) {
            return false;
        }
        // 获取这个插件总的方法列表，数组
        /* $methods = get_class_methods($addons_class);
        $methods = array_map(function ($item) {return parseName($item, 0, false);}, $methods);
        $notHook = ['install','uninstall','enabled','disabled','construct','get_info','get_config'];
        foreach($methods as $k=>$v){
            if(in_array($v,$notHook)){
                unset($methods[$k]);
            }
        }
        $hooks  = $this->column('name');
        $common = array_intersect($hooks, $methods);
        if ($common) {
            foreach ($common as $hook) {
                $flag = $this->removeAddons($hook, array($addons_name));
                if (false === $flag) {
                    return false;
                }
            }
        } */
        $actionList = $this->getHooksAnotation($addons_class,$addons_name);
        if($actionList){
            foreach($actionList as $k=>$v){
                $flag = $this->removeAddons($v['name'], array($addons_name),array($v['description']));
                // if (false === $flag) {
                //     return false;
                // }
            }
        }
        return true;
    }
    /**
     * 更新单个钩子处的插件
     * @param  [$hook_name]   钩子名称   
     * @param  [$name]        插件名称
     * @param  [$des]         钩子描述
     * @return [type]
     */
    public function updateAddons($hook_name, $name ,$des)
    {
        $o_addons = $this->where('name',$hook_name)->value('addons');
        if ($o_addons) {
            $o_addons = str2arr($o_addons);
        }
        if ($o_addons) {
            $addons = array_merge($o_addons, $name);
            $addons = array_unique($addons);
        } else {
            $addons = $name;
        }
        $flag = $this->where('name',$hook_name)->update(['addons'=>arr2str($addons)]);
        if (false === $flag) {
            $this->where('name',$hook_name)->update(['addons'=>arr2str($o_addons)]);
        }

        $o_description = $this->where('name',$hook_name)->value('description');
        if ($o_description) {
            $o_description = str2arr($o_description,'|');
        }
        if ($o_description) {
            $description = array_merge($o_description, $des);
            $description = array_unique($description);
        } else {
            $description = $des;
        }
        $flag2 = $this->where('name',$hook_name)->update(['description'=>arr2str($description,'|')]);
        if (false === $flag2) {
            $this->where('name',$hook_name)->update(['description'=>arr2str($o_description,'|')]);
        }

        return $flag || $flag2;
    }
    /**
     * 去除单个钩子里对应的插件数据
     * @param  [$hook_name] 钩子名称   
     * @param  [$name]      插件名称  
     * @param  [$des]       钩子描述
     * @return [type]
     */
    public function removeAddons($hook_name, $name, $des)
    {
        $this->where([['addons','in',$name]])->delete();
        $o_addons = $this->where('name',$hook_name)->value('addons');
        $o_addons = str2arr($o_addons);
        if ($o_addons) {
            $addons = array_diff($o_addons,$name);
        } else {
            return true;
        }
        $flag = $this->where('name',$hook_name)->update(['addons'=>arr2str($addons)]);
        if (false === $flag) {
            $this->where('name',$hook_name)->update(['addons'=>arr2str($o_addons)]);
        }

        $o_description = $this->where('name',$hook_name)->value('description');
        $o_description = str2arr($o_description,'|');
        if ($o_description) {
            $description = array_diff($o_description,$des);
        } else {
            return true;
        }
        $flag2 = $this->where('name',$hook_name)->update(['description'=>arr2str($description,'|')]);
        if (false === $flag2) {
            $this->where('name',$hook_name)->update(['description'=>arr2str($o_description,'|')]);
        }

        return $flag || $flag2;
    }
    /**
     * 获取单个插件所有钩子注释等等信息
     * @param  [$addons_class] 插件类       
     * @return [type]
     */
    public function getHooksAnotation($addons_class,$addons_name)
    {
        AnnotationRegistry::registerLoader('class_exists');
        $reader = new FileCacheReader(new AnnotationReader(), runtime_path() . 'annotation' . DIRECTORY_SEPARATOR . 'hooks', true);
        $reflectionClass = new \ReflectionClass($addons_class);
        $methods         = $reflectionClass->getMethods();
        $actionList      = [];
        // 遍历读取所有方法的注释的参数信息
        foreach ($methods as $method) {
            // 读取HooksAnotation的注解
            $hooksAnnotation = $reader->getMethodAnnotation($method, HooksAnotation::class);
            if (!empty($hooksAnnotation) && !empty($hooksAnnotation->description)) {
                $actionName  = !empty($hooksAnnotation) && !empty($hooksAnnotation->name) ? $hooksAnnotation->name : $method->name;
                $actionDescription  = !empty($hooksAnnotation) && !empty($hooksAnnotation->description) ? $hooksAnnotation->description : null;
                $actionType   = !empty($hooksAnnotation) && !empty($hooksAnnotation->type) ? $hooksAnnotation->type : 1;
                $actionSystem   = !empty($hooksAnnotation) && !empty($hooksAnnotation->system) ? $hooksAnnotation->system : 0;
                $actionStatus   = !empty($hooksAnnotation) && !empty($hooksAnnotation->status) ? $hooksAnnotation->status : 1;
                $actionList[] = [
                    'name'          => $actionName,
                    'description'   => '插件'.$addons_name.':'.$actionDescription,
                    'type'          => $actionType,
                    'system'        => $actionSystem,
                    'status'        => $actionStatus,
                ];
            }
        }
        return $actionList;
    }
}
