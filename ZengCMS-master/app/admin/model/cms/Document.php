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
// | 文档基础模型
// +----------------------------------------------------------------------
namespace app\admin\model\cms;

use think\Model;
use think\facade\Db;

class Document extends Model
{
    /**
     * [getUid 获取管理员UID]
     * @param  [array] $data [表单数据]
     * @return [array] 含uid的表单数据
     */
    public function getUid($data)
    {
        $data['uid'] = is_login();
        return $data;
    }
    /**
     * [getKeywords 获取关键词]
     * @param  [array] $data [表单数据]
     * @return [array] 含keywords的表单数据
     */
    public function getKeywords($data)
    {
        if (isset($data['keywords']) && isset($data['content'])) {
            $key = $data['keywords'];
            $content = preg_replace("/(\s|\&nbsp\;|　|\&quot\;|\xc2\xa0|)/", "", strip_tags($data['content']));
            if (empty($key) && !empty($content)) {
                $o= new \liliuwei\pscws4\PSCWS4API();
                // $o->PSCWS4($content);//获取所有分词
                $key = $o->PSCWS4_TOP($content,10);//返回分词结果的词语按权重统计的前N个词
                if ($key) {
                    $key = implode(',', $key);
                }
            }
            $data['keywords'] = $key;
        }
        return $data;
    }
    /**
     * [getDescription 获取描述]
     * @param  [array] $data [表单数据]
     * @return [array] 含description的表单数据
     */
    public function getDescription($data)
    {
        if (isset($data['description']) && isset($data['content'])) {
            $desc = $data['description'];
            $content = preg_replace("/(\s|\&nbsp\;|　|\&quot\;|\xc2\xa0|)/", "", strip_tags($data['content']));
            if (empty($desc) && !empty($content)) {
                preg_match("/^([\s\S]*?(\。|\？|\！|\：|\；|\.|\?|\!|\:|\;))/", $content, $match);
                if (!empty($match)) {
                    $desc = $match[0];
                } else {
                    $desc = mb_substr($content, 0, 100, 'utf-8');
                }
            }
            $data['description'] = $desc;
        }
        return $data;
    }
    /**
     * [getWriter 获取默认作者]
     * @param  [array] $data [表单数据]
     * @return [array] 含writer的表单数据
     */
    public function getWriter($data)
    {
        if (isset($data['writer'])) {
            $writer = $data['writer'];
            if (empty($writer)) {
                $writer = session("admin_auth.relname") ? session("admin_auth.relname") : session("admin_auth.username");
            }
            $data['writer'] = $writer;
        } else {
            $writer = session("admin_auth.relname") ? session("admin_auth.relname") : session("admin_auth.username");
            $data['writer'] = $writer;
        }
        return $data;
    }
    /**
     * [getCreateTime 获取创建时间]
     * @param  [array] $data [表单数据]
     * @param  [array] $type [类型；1：新增时，2：编辑时]
     * @return [array]       [含有时间戳create_time的表单数据]
     */
    public function getCreateTime($data, $type)
    {
        if ($type == 1) { //新增时
            if (isset($data['create_time'])) {
                $data['create_time'] = strtotime($data['create_time']);
            } else {
                $data['create_time'] = time();
            }
        } else { //编辑时
            if (isset($data['create_time'])) {
                $data['create_time'] = strtotime($data['create_time']);
            }
        }
        return $data;
    }
    /**
     * [getUpdateTime 获取更新时间]
     * @param  [array] $data [表单数据]
     * @return [array]       [含有时间戳update_time的表单数据]
     */
    public function getUpdateTime($data)
    {
        if (isset($data['update_time'])) {
            $data['update_time'] = strtotime($data['update_time']);
        } else {
            $data['update_time'] = time();
        }
        return $data;
    }
    /**
     * [getStatus 获取数据状态]
     * @param  [array] $data [表单数据]
     * @param  [array] $type [类型；1：新增时，2：编辑时]
     * @return [array]       [含status的表单数据]
     */
    public function getStatus($data, $type)
    {
        if ($type == 1) { // 新增时
            $category_id = $data['category_id'];
            $check = Db::name('arctype')->field('check')->find($category_id);
            $status = $check['check'] ? 2 : (isset($data['status'])?$data['status']:2);
        } else { // 编辑时
            $status = $data['status'];
        }
        $data['status'] = $status;
        return $data;
    }
    /**
     * [tag_handle 标签处理]
     * @param  [type] $tags        [多个标签，以逗号隔开]
     * @param  [type] $model_id    [模型ID]
     * @param  [type] $category_id [栏目ID]
     * @param  [type] $document_id [文档ID]
     * @return [type]              [description]
     */
    public function tag_handle($tags, $model_id, $category_id, $document_id)
    {
        Db::name('tagmap')->where([
            ['model_id', '=', $model_id],
            ['category_id', '=', $category_id],
            ['document_id', '=', $document_id]
        ])->delete();
        if($tags){
            $tags = str_replace('，', ',', $tags);
            $tag_arr = explode(',', $tags);
            foreach ($tag_arr as $k => $v) {
                $tag = Db::name('tag')->where('name', $v)->find();
                if (!$tag) {
                    $tag_id = Db::name('tag')
                    ->insertGetId(['name' => $v, 'create_time' => time(), 'update_time' => time()]);
                } else {
                    $tag_id = $tag['id'];
                }
                $map[] = ['tag_id' ,'=', $tag_id];
                $map[] = ['model_id' ,'=', $model_id];
                $map[] = ['category_id' ,'=', $category_id];
                $map[] = ['document_id' ,'=', $document_id];
                $data = ['tag_id' => $tag_id, 'model_id' => $model_id,'category_id'=>$category_id ,'document_id' => $document_id];
                if(!Db::name('tagmap')->where($map)->find()){
                    Db::name('tagmap')->insert($data);
                }
            }
        }
    }
    /**
     * [AddAutoComplete 新增或编辑数据时自动完成数据]
     * @param [type] $data [表单数据]
     * @param [type] $type [类型；1：新增，2：编辑]
     */
    public function AddAutoComplete($data, $type = 1)
    {
        $data = $this->getUid($data);//获取管理员ID
        $data = $this->getKeywords($data);//获取文章关键词
        $data = $this->getDescription($data);//获取描述
        $data = $this->getWriter($data);//获取默认作者
        $data = $this->getCreateTime($data, $type);//创建时间
        $data = $this->getUpdateTime($data);//修改时间
        $data = $this->getStatus($data, $type);//获取数据状态
        return $data;
    }
    /**
     * [add 新增文档]
     * @param array $data [表单数据]
     * @return void
     */
    public function add($data)
    {
        // 获取模型信息
        $modelInfo = Db::name('model')->find($data['model_id']);
        if (!$modelInfo) {
            // 编辑器图片处理
            editor1(isset($data['content']) ? $data['content'] : '');
            editor1(isset($data['content_en']) ? $data['content_en'] : '');
            return ['code'=>0,'msg'=>'栏目所属模型不存在！'];
        }
        if ($modelInfo['extend'] != 0) { //非独立模型的操作
            // 获取基础文档模型信息
            $extenDmodelInfo = Db::name('model')->find($modelInfo['extend']);
            if (!$extenDmodelInfo) {
                // 编辑器图片处理
                editor1(isset($data['content']) ? $data['content'] : '');
                editor1(isset($data['content_en']) ? $data['content_en'] : '');
                return ['code'=>0,'msg'=>'栏目所属模型的父模型不存在！'];
            }
            // 基础文档额外数据自动完成
            $data = $this->AddAutoComplete($data, 1);
            // 文档数据验证及自动完成
            $result = checkFieldAttr($data, $data['model_id']);
            $data = isset($result['data'])?$result['data']:$data;
            if ($result['code'] == 0) {
                // 编辑器图片处理
                editor1(isset($data['content']) ? $data['content'] : '');
                editor1(isset($data['content_en']) ? $data['content_en'] : '');
                return ['code'=>$result['code'],'msg'=>$result['msg']];
            }
            // 新增基础文档信息
            $id = Db::name($extenDmodelInfo['name'])->strict(false)->insertGetId($data);
            if (!$id) {
                // 编辑器图片处理
                editor1(isset($data['content']) ? $data['content'] : '');
                editor1(isset($data['content_en']) ? $data['content_en'] : '');
                return ['code'=>0,'msg'=>'新增基础文档失败!'];
            }
            $data['id'] = $id;
            /* 新增扩展文档信息内容 */
            $data['id'] = $id;
            $res = Db::name($extenDmodelInfo['name'].'_'.$modelInfo['name'])->strict(false)->insert($data);
            if(!$res){
                // 编辑器图片处理
                editor1(isset($data['content']) ? $data['content'] : '');
                editor1(isset($data['content_en']) ? $data['content_en'] : '');
                // 新增失败，删除基础数据
                Db::name($extenDmodelInfo['name'])->delete($data['id']);
                return ['code'=>0,'msg'=>'新增扩展信息失败!'];
            }
            // 处理tag标签
            if (isset($data['tags']) && !empty($data['tags'])) {
                $this->tag_handle($data['tags'], $data['model_id'], $data['category_id'] ,$data['id']);
            }
            // 行为记录
            action_log($data['id'], $extenDmodelInfo['name'], 1);
            action_log($data['id'], $extenDmodelInfo['name'] . '_' . $modelInfo['name'], 1);
            return ['code'=>1,'成功！'];
        } else { //独立模型的操作
            $data = $this->AddAutoComplete($data, 1);
            // 独立模型数据验证及自动完成
            $result = checkFieldAttr($data, $data['model_id']);
            $data = isset($result['data'])?$result['data']:$data;
            if ($result['code'] == 0) {
                // 编辑器图片处理
                editor1(isset($data['content']) ? $data['content'] : '');
                editor1(isset($data['content_en']) ? $data['content_en'] : '');
                return ['code'=>0,'msg'=>$result['msg']];
            }
            // 新增独立模型文档
            $id = Db::name($modelInfo['name'])->strict(false)->insertGetId($data);
            if (!$id) {
                // 编辑器图片处理
                editor1(isset($data['content']) ? $data['content'] : '');
                editor1(isset($data['content_en']) ? $data['content_en'] : '');
                // 新增失败
                return ['code'=>0,'msg'=>'新增独立文档失败'];
            }
            // 处理tag标签
            if (isset($data['tags']) && !empty($data['tags'])) {
                $this->tag_handle($data['tags'], $data['model_id'], $data['category_id'],$id);
            }
            // 记录新增后日志
            action_log($id, $modelInfo['name'],1);
            return ['code'=>1,'msg'=>'成功！'];
        }
    }
    /**
     * [edit 编辑文档]
     * @param array $data [表单数据]
     * @return void
     */
    public function edit($data)
    {
        // 获取模型信息
        $modelInfo = Db::name('model')->find($data['model_id']);
        if (!$modelInfo) {
            // 编辑器图片处理
            editor1(isset($data['content']) ? $data['content'] : '');
            editor1(isset($data['content_en']) ? $data['content_en'] : '');
            return ['code'=>0,'msg'=>'栏目所属模型不存在!'];
        }
        if ($modelInfo['extend'] != 0) { //非独立模型的操作
            // 获取基础文档模型信息
            $extenDmodelInfo = Db::name('model')->find($modelInfo['extend']);
            // 获取当前基本文档信息
            $info = Db::name($extenDmodelInfo['name'])->find($data['id']);
            if (!$extenDmodelInfo) {
                // 编辑器图片处理
                if (isset($data['content']) && isset($info['content'])) {
                    editor2($info['content'], $data['content']);
                }
                if (isset($data['content_en']) && isset($info['content_en'])) {
                    editor2($info['content_en'], $data['content_en']);
                }
                return ['code'=>0,'msg'=>'栏目所属模型的父模型不存在!'];
            }
            // 基础文档额外数据完成
            $data = $this->AddAutoComplete($data, 2);
            // 编辑文档数据验证及自动完成
            $result = checkFieldAttr($data, $data['model_id']);
            $data = isset($result['data'])?$result['data']:$data;
            if ($result['code'] == 0) {
                // 编辑器图片处理
                if (isset($data['content']) && isset($info['content'])) {
                    editor2($info['content'], $data['content']);
                }
                if (isset($data['content_en']) && isset($info['content_en'])) {
                    editor2($info['content_en'], $data['content_en']);
                }
                return ['code'=>0,'msg'=>$result['msg']];
            }
            // 编辑器图片处理
            if (isset($data['content']) && isset($info['content'])) {
                editor2($data['content'], $info['content']);
            }
            if (isset($data['content_en']) && isset($info['content_en'])) {
                editor2($data['content_en'], $info['content_en']);
            }
            // 编辑基础文档信息
            action_log($data['id'], $extenDmodelInfo['name'], 2);//记录修改前行为
            $res = Db::name($extenDmodelInfo['name'])->strict(false)->update($data);
            if ($res === false) {
                // 编辑器图片处理
                if (isset($data['content']) && isset($info['content'])) {
                    editor2($info['content'], $data['content']);
                }
                if (isset($data['content_en']) && isset($info['content_en'])) {
                    editor2($info['content_en'], $data['content_en']);
                }
                return ['code'=>0,'msg'=>'编辑基础文档失败!'];
            }
            action_log($data['id'], $extenDmodelInfo['name'], 2);//记录修改后行为
            /* 编辑扩展文档信息内容 */
            // 获取当前扩展文档信息
            $info2 = Db::name($extenDmodelInfo['name'] . '_' . $modelInfo['name'])->where('id', $data['id'])->find();
            // 编辑器图片处理
            if (isset($data['content']) && isset($info2['content'])) {
                editor2($data['content'], $info2['content']);
            }
            if (isset($data['content_en']) && isset($info2['content_en'])) {
                editor2($data['content_en'], $info2['content_en']);
            }
            action_log($data['id'], $extenDmodelInfo['name'] . '_' . $modelInfo['name'],2);//记录修改前行为
            $res = Db::name($extenDmodelInfo['name'] . '_' . $modelInfo['name'])->strict(false)->update($data);
            if ($res === false) {
                // 编辑器图片处理
                if (isset($data['content']) && isset($info2['content'])) {
                    editor2($info2['content'], $data['content']);
                }
                if (isset($data['content_en']) && isset($info2['content_en'])) {
                    editor2($info2['content_en'], $data['content_en']);
                }
                // 编辑失败
                return ['code'=>0,'msg'=>'编辑扩展信息失败'];
            }
            // 处理tag标签
            if (isset($data['tags'])) {
                $this->tag_handle($data['tags'], $data['model_id'], $data['category_id'] ,$data['id']);
            }
            action_log($data['id'], $extenDmodelInfo['name'] . '_' . $modelInfo['name'], 2);//记录修改后行为
            return ['code'=>1,'msg'=>'成功'];
        } else { //独立模型的操作
            // 数据完成
            $data = $this->AddAutoComplete($data, 2);
            // 独立模型数据验证及自动完成
            $result = checkFieldAttr($data, $data['model_id']); 
            $data = isset($result['data'])?$result['data']:$data;
            // 获取当前独立文档信息
            $info = Db::name($modelInfo['name'])->find($data['id']);
            if ($result['code'] == 0) {
                // 编辑器图片处理
                if (isset($data['content']) && isset($info['content'])) {
                    editor2($info['content'], $data['content']);
                }
                if (isset($data['content_en']) && isset($info['content_en'])) {
                    editor2($info['content_en'], $data['content_en']);
                }
                return ['code'=>0,'msg'=>$result['msg']];
            }
            // 编辑器图片处理
            if (isset($data['content']) && isset($info['content'])) {
                editor2($data['content'], $info['content']);
            }
            if (isset($data['content_en']) && isset($info['content_en'])) {
                editor2($data['content_en'], $info['content_en']);
            }
            // 编辑独立模型文档
            action_log($data['id'], $modelInfo['name'], 2);//记录修改前行为
            $res = Db::name($modelInfo['name'])->strict(false)->update($data);
            if ($res === false) {
                // 编辑器图片处理
                if (isset($data['content']) && isset($data['content'])) {
                    editor2($info['content'], $data['content']);
                }
                if (isset($data['content_en']) && isset($data['content_en'])) {
                    editor2($info['content_en'], $data['content_en']);
                }
                // 编辑失败
                return ['code'=>0,'msg'=>'编辑独立文档失败'];
            }
            // 处理tag标签
            if (isset($data['tags'])) {
                $this->tag_handle($data['tags'], $data['model_id'], $data['category_id'] ,$data['id']);
            }
            action_log($data['id'], $modelInfo['name'], 2);//记录修改后行为
            return ['code'=>1,'msg'=>'成功'];
        }
    }
}
