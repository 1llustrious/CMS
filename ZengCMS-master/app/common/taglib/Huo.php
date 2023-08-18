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
// | 自定义标签
// +----------------------------------------------------------------------
namespace app\common\taglib;

use think\template\TagLib;

class Huo extends TagLib
{
    // 标签定义
    protected $tags = [
        // 标签定义： attr 属性列表 close 是否闭合（0 或者1 默认1） alias 标签别名 level 嵌套层次
        'nav'     =>  ['attr' => 'typeid,type,thisclass,level,field,limit,order', 'level' => 3, 'close' => 1], //导航(栏目)列表标签
        'doc'     =>  ['attr' => 'typeid,aid,limit,flags,field,order,titlelen,desclen', 'level' => 3], //文章(文档)列表标签
        'record'  =>  ['attr' => 'limit', 'level' => 3], //文章(文档)浏览记录列表标签
        'pos'     =>  ['attr' => 'typeid,field', 'level' => 3], //文章(文档)列表标签
        'fields'  =>  ['attr' => 'typeid,type,aid,get,function', 'close' => 0], //栏目字段获取标签
        'picurl'  =>  ['attr' => 'typeid,type,aid,id', 'close' => 1], //栏目或文档图片集字段获取标签
        'jump'    =>  ['attr' => 'lang,name', 'close' => 0], //根据语言lang和name获取跳转地址标签
        'config'  =>  ['attr' => 'get', 'close' => 0], //系统配置标签
        'seomenu' =>  ['attr' => '', 'close' => 0], //seo栏目标签
        'ad'      =>  ['attr' => 'apid'], //广告列表标签
        'links'   =>  ['attr' => 'typeid,limit,way'] //友链列表标签
    ];
    /**
     * nav 导航(栏目)标签，循环读取导航(栏目)列表*
     *
     * 用例：
     *
     * {huo:nav typeid="" type="" thisclass="" level="" field="" limit="" order=""}
     *
     * {$i}            //从1自增1的变量
     * {$id}           //栏目id
     * {$typename}     //栏目名称
     * {$typename_en}  //栏目英文名称
     * {$name}         //栏目标识
     * {$title}        //栏目标题，可使用{$vo.title|cut_str=###,10}或{:cut_str($vo['title'],10)}截取长度
     * {$seotitle}     //栏目seo标题
     * {$seotitle_en}  //栏目英文seo标题
     * {$create_time|date="Y-m-d"} //栏目创建时间
     * {$update_time|date="Y-m-d"} //栏目更新时间
     * {$thisclass} //栏目选择中样式默认为空【特殊拼凑的后台没此字段】
     * {$typeurl}   //栏目url【特殊拼凑的后台没此字段】
     * {$iconurl}   //栏目图片url【特殊拼凑的后台没此字段】
     * {$picurl}    //栏目图片集数组array【特殊拼凑的后台没此字段】，可使用{volist name="$picurl" id="vo"}{/volist}来调用
     * {$children}  //栏目的子栏目数组array【特殊拼凑的后台没此字段】，可使用{volist name="$children" id="vo"}{/volist}来调用
     * ......等等
     *
     * {/huo:nav}
     *
     * 参数说明：
     * typeid    栏目编号(id)或栏目标识(name)字符串，例typeid="1,3" 或 typeid="product,news"等，如果为空默认获取所有栏目
     * type      栏目类型：顶级栏目top或子栏目son，例：type="top"或type="son"
     * thisclass 样式代码，例：thisclass="on"
     * level     获取多少级栏目，例：level="3"，如果不填默认获取3级栏目导航
     * field     字段，读取指定字段，例： field="id,title,content"，如果不填写将默认获取所有字段
     * limit     读取多少条记录，例：limit="10"，限制多少个顶级栏目，如果不填默认获取所有一级栏目
     * order     排序，例： order="id desc" 或 order="sort desc,id desc"
     *
     * 可嵌套使用
     * 嵌套标签变量  typeid="$id"
     *
     * @param array $attr 标签属性
     * @param string $content  标签内容
     * @return string
     *
     */
    public function tagNav($attr, $content)
    {
        $typeid  =   !empty($attr['typeid']) ? $attr['typeid'] : '';
        $typeid  =   str_replace(array("{", "}"), "", $typeid);
        $type    =   !empty($attr['type']) ? $attr['type'] : '';
        $thisclass = !empty($attr['thisclass']) ? $attr['thisclass'] : '';
        $level   =   !empty($attr['level']) ? $attr['level'] : '';
        $field   =   !empty($attr['field']) ? $attr['field'] : '';
        $limit   =   !empty($attr['limit']) ? $attr['limit'] : '';
        $order   =   !empty($attr['order']) ? $attr['order'] : '';
        $where   =   '';
        $str = '<?php ';
        $str .= '$list=tag_nav("' . $typeid . '","' . $type . '","' . $thisclass . '","' . $where . '","' . $level . '","' . $field . '","' . $limit . '","' . $order . '");';
        $str .= ' $i = 1;';
        $str .= 'foreach ($list as $key=>$value):';
        $str .= 'extract($value);?>';
        $str .= $content;
        $str .= '<?php $i++; endforeach; ?>';
        return $str;
    }
    /**
     * doc 文章(文档)标签，循环读取文章(文档)列表*
     *
     * 用例：
     *
     * {huo:doc typeid="" aid="" limit="" flags="" field="" order="" titlelen="" desclen="" }
     *
     * {$i}                //从1自增1的变量
     * {$id}               //文章id
     * {$title}            //文章标题，可使用{$title|cut_str=###,10}或{:cut_str($title,10)}截取长度
     * {$keywords}         //文章关键词
     * {$description}      //文章描述
     * {$content}          //文章内容
     * {$create_time|date="Y-m-d"} //文章创建时间
     * {$update_time|date="Y-m-d"} //文章更新时间
     * {$category_id}        //文章所属栏目id
     * {$name}        //文章所属栏目标识
     * {$typename}    //文章所属栏目名称
     * {$typename_en} //文章所属栏目英文名称
     * {$typeurl}     //文章所属栏目url【特殊拼凑的后台没此字段】
     * {$iconurl}     //文章图片url【特殊拼凑的后台没此字段】
     * {$picurl}      //文章图片集数组array【特殊拼凑的后台没此字段】,用{volist name="$picurl" id="vo"}{/volist}使用
     * {$arturl}      //文章url【特殊拼凑的后台没此字段】
     * ......等等
     *
     * {/huo:doc}
     *
     * 说明：
     * typeid   栏目编号(id)或栏目标识，例：typeid="3"或typeid="product"，如果不填默认为当前栏目id
     * aid      文档id字符串，例：aid="1,2,3"
     * limit    读取多少条记录，例：limit="10"，如果不填默认10条
     * flags    自定义属性，例：flags="a"特推
     * field    字段，读取指定字段   例： field="id,title,content"，如果不填写将默认获取所有字段
     * order    排序，例： order="id desc"，浏览量排序（热点） order="view desc"
     * titlelen 标题指定长度，例：titlelen="10"
     * desclen  描述指定长度，例：desclen="10"
     *
     * 可嵌套使用
     * 嵌套标签变量  typeid="$id"
     *
     * @param array $attr 标签属性
     * @param string $content  标签内容
     * @return string
     */
    public function tagDoc($attr, $content)
    {
        $typeid     =   !empty($attr['typeid']) ? $attr['typeid'] : '';
        $typeid     =   str_replace(array("{", "}"), "", $typeid);
        $limit      =   !empty($attr['limit']) ? $attr['limit'] : '';
        $flags      =   !empty($attr['flags']) ? $attr['flags'] : '';
        $order      =   !empty($attr['order']) ? $attr['order'] : '';
        $field      =   !empty($attr['field']) ? $attr['field'] : '';
        $titlelen   =   !empty($attr['titlelen']) ? $attr['titlelen'] : '';
        $desclen    =   !empty($attr['desclen']) ? $attr['desclen'] : '';
        $where = '';
        if (!empty($attr['aid'])) {
            $where = 'id in (' . $attr['aid'] . ')';
        }
        $str  = '<?php ';
        $str .= '$list=tag_doc("' . $typeid . '","' . $limit . '","' . $where . '","' . $flags . '","' . $titlelen . '","' . $desclen . '");';
        $str .= ' $i = 1;'; //从1开始自增1的变量
        $str .= 'foreach ($list as $key=>$value):';
        $str .= 'extract($value);?>';
        $str .= $content;
        $str .= '<?php $i++; endforeach; ?>';
        return $str;
    }
    /**
     * record 文章(文档)浏览记录标签，循环读取文章(文档)浏览记录列表*
     *
     * 用例：
     *
     * {huo:record limit=""}
     *
     * {$i}                //从1自增1的变量
     * {$category_id}      //文章所属栏目id
     * {$id}               //文章id
     * {$title}            //文章标题，可使用{$title|cut_str=###,10}或{:cut_str($title,10)}截取长度
     * {$arturl}           //文章url【特殊拼凑的后台没此字段】
     * {$iconurl}          //文章图片url【特殊拼凑的后台没此字段】
     * {$record_time|date="Y-m-d"} //文章浏览记录时间
     * ......等等
     *
     * {/huo:record}
     *
     * 说明：
     * limit    读取多少条记录，例：limit="10"
     *
     * 可嵌套使用
     * 嵌套标签变量  typeid="$id"
     *
     * @param array $attr 标签属性
     * @param string $content  标签内容
     * @return string
     */
    public function tagRecord($attr, $content)
    {
        $limit      =   !empty($attr['limit']) ? $attr['limit'] : '';
        $str  = '<?php ';
        $str .= '$list=tag_record("' . $limit . '");';
        $str .= ' $i = 1;'; //从1开始自增1的变量
        $str .= 'foreach ($list as $key=>$value):';
        $str .= 'extract($value);?>';
        $str .= $content;
        $str .= '<?php $i++; endforeach; ?>';
        return $str;
    }
    /**
     * pos 当前位置函数标签，循环读取当前位置列表*
     *
     * 用例：
     *
     * {huo:pos typeid="" field=""}
     *
     * {$i}            //从1自增1的变量
     * {$id}           //栏目id
     * {$typename}     //栏目名称
     * {$typename_en}  //栏目英文名称
     * {$name}         //栏目标识
     * {$title|cut_str=###,10}   //栏目标题
     * {$seotitle}     //栏目seo标题
     * {$seotitle_en}  //栏目英文seo标题
     * {$keywords}     //栏目关键词
     * {$keywords_en}  //栏目英文关键词
     * {$description}  //栏目描述
     * {$description_en} //栏目英文描述
     * {$content}      //栏目内容
     * {$content_en}      //栏目英文内容
     * {$create_time|date="Y-m-d"} //栏目创建时间
     * {$update_time|date="Y-m-d"} //栏目更新时间
     * {$typeurl} //栏目url【特殊拼凑的后台没此字段】.
     * {$iconurl} //栏目图片url【特殊拼凑的后台没此字段】
     * ......等等
     *
     * {/huo:pos}
     *
     * 说明：
     * typeid   栏目编号(id)或栏目标识，例：typeid="3"或typeid="product"，如果不填默认为当前栏目id
     * field    字段，读取指定字段   例： field="id,title,content"，如果不填写将默认获取所有字段 true
     *
     * 可嵌套使用
     * 嵌套标签变量  typeid="$id"
     *
     * @param array $attr 标签属性
     * @param string $content  标签内容
     * @return string
     */
    public function tagPos($attr, $content)
    {
        $typeid     =   !empty($attr['typeid']) ? $attr['typeid'] : '';
        $typeid     =   str_replace(array("{", "}"), "", $typeid);
        $field      =   !empty($attr['field']) ? $attr['field'] : '';
        $str  = '<?php ';
        $str .= '$list=tag_pos("' . $typeid . '", "' . $field . '");';
        $str .= ' $i = 1;'; //从1开始自增1的变量
        $str .= 'foreach ($list as $key=>$value):';
        $str .= 'extract($value);?>';
        $str .= $content;
        $str .= '<?php $i++; endforeach; ?>';
        return $str;
    }
    /**
     * fields  单页栏目或文档字段获取 ，多用于单页，详情页栏目或文档读取
     *
     * 用例：
     *
     * 单栏目获取：
     * {huo:fields  get='title' function="cut_str(###,3)" /}
     * {huo:fields  get='content' /}
     * {huo:fields  get='create_time' function="date('Y-m-d',###)" /}
     * {huo:fields  get='typename' /}
     * {huo:fields  get='name' /}
     * {huo:fields  get='seotitle' /}
     * {huo:fields  get='typeurl' /}
     * {huo:fields  get='iconurl' /}
     *
     * 单文档获取：
     * {huo:fields typeid="2" aid="3" get='title' function="cut_str(###,3)" /}
     * {huo:fields typeid="2" aid="3" get='content' /}
     * {huo:fields typeid="2" aid="3" get='create_time' function="date('Y-m-d',###)" /}
     * {huo:fields typeid="2" aid="3" get='arturl' /}
     *
     * 参数说明：
     * typeid    栏目id或栏目标识，例：typeid="3"或typeid="product"，如果不填默认当前栏目id
     * type      类型，例：type="nav"获取单栏目信息；type="doc"获取单文档信息
     * aid       文档id，当type="doc"时设置才有效，如果不填则默认当前文档id
     * get       字段，例：get="typename"等等
     * function  方法，例：function="date('Y-m-d',###)"
     *
     * @param array $attr 标签属性
     * @param string $content  标签内容
     * @return string
     */
    public function tagFields($attr, $content)
    {
        $typeid = !empty($attr['typeid']) ? $attr['typeid'] : '';
        $type   = !empty($attr['type']) ? $attr['type'] : 'nav';
        $aid    = !empty($attr['aid']) ? $attr['aid'] : '';
        $name   = !empty($attr['get']) ? $attr['get'] : null;
        $fun    = !empty($attr['function']) ? $attr['function'] : '';
        if (is_null($name)) {
            return '';
        }
        switch ($type) {
            case 'nav':
                $value = get_nav($typeid, $name);
                break;
            case 'doc':
                $value = get_doc($typeid, $aid, $name);
                break;
            default:
                # code...
                break;
        }
        //有输出值则输出
        if ($value) {
            //如果使用函数
            if ($fun) {
                $return  = str_replace('###', $value, $fun);
            } else {
                $return = $value;
            }
            //如果值不为空
            if ($return) {
                $str  = '<?php ';
                $str .= 'echo ' . $return . ';';
                $str .= ' ?>';
            }
        }
        return $str;
    }
    /**
     * picurl  单页栏目或文档图片集字段获取 ，多用于单页，详情页栏目或文档图片集读取
     *
     * 用例：
     *
     * {huo:picurl typeid="" field=""}
     *
     * {$i}            //从1自增1的变量
     * {$id}           //栏目id
     * ......等等
     *
     * {/huo:picurl}
     *
     * * 参数说明：
     * typeid    栏目id或栏目标识，例：typeid="3"或typeid="product"，如果不填默认当前栏目id
     * type      类型，例：type="nav"获取单栏目图片集信息；type="doc"获取单文档图片集信息
     * aid       文档id，当type="doc"时设置才有效，如果不填则默认当前文档id
     * id        结果变量，例：id="vo"
     *
     * @param array $attr 标签属性
     * @param string $content  标签内容
     * @return string
     */
    public function tagPicurl($attr, $content)
    {
        $typeid = !empty($attr['typeid']) ? $attr['typeid'] : '';
        $type   = !empty($attr['type']) ? $attr['type'] : 'nav';
        $aid    = !empty($attr['aid']) ? $attr['aid'] : '';
        $id        = !empty($tag['id']) ? $tag['id'] : 'vo';
        $str = '';
        $str .= '<?php
                if("' . $type . '"=="nav"){
                    $list = get_nav("' . $typeid . '", "picurl");
                }else{
                    $list = get_doc("' . $typeid . '","' . $aid . '","picurl");
                }
                $i=1;';
        $str .= 'if($list):';
        $str .= 'foreach($list as $key=>$' . $id . '):?>';
        $str .= $content;
        $str .= '<?php $i++; endforeach;endif; ?>';
        return $str;
    }
    /**
     * jump  根据语言和name获取跳转地址标签
     *
     * 用例：
     *
     * {huo:jump lang="" name=""/}
     *
     * 参数说明：
     * lang  语言字符，例：lang="en"，如果不填默认跳转中文
     * name  跳转name，例：name="chenggonganli"，如果不填默认跳转到首页index
     *
     * @param array $attr 标签属性
     * @param string $content  标签内容
     * @return string
     */
    public function tagJump($attr, $content)
    {
        $lang = !empty($attr['lang']) ? $attr['lang'] : '';
        $name = !empty($attr['name']) ? $attr['name'] : '';
        return jump_by_lang($lang, $name);
    }
    /**
     * config  系统配置获取，在系统自定义设置的参数
     *
     * 用例：
     *
     * {huo:config get='WEB_SITE_POWERBY'/}   //读取版权信息
     * {huo:config get='WEB_SITE_ICP'/}       //读取备案号
     * ......等等
     *
     * @param array $attr 标签属性
     * @param string $content  标签内容
     * @return string
     */
    public function tagConfig($attr, $content)
    {
        $name = !empty($attr['get']) ? $attr['get'] : '';
        if (!empty($name)) {
            return get_one_cache_config($name);
        }
    }
    /**
     * seomenu 多城市优化栏目，开启地区优化必须在适当位置加入标签
     *
     * 用例：
     *
     * {huo:seomenu /}
     *
     * 会循环输出 地区栏目
     *
     * @param array $attr      标签属性
     * @param string $content  标签内容
     * @return string
     */
    public function tagSeomenu($attr, $content)
    {
        return tag_seomenu();
    }
    /**
     * ad 广告标签，循环读取广告列表*
     *
     * 用例：
     *
     * {huo:ad apid=""}
     * {$i}           //从1自增1的变量
     * {$title}       //广告标题，可使用{$title|cut_str=###,10}或{:cut_str($title,10)}截取长度
     * {$imgurl}      //广告图片url【特殊拼凑的后台没此字段】
     * {$linkurl}     //广告链接url【特殊拼凑的后台没此字段】
     * {/huo:ad}
     *
     * 参数说明：
     * apid    广告位id，例：apid="1"
     *
     * @param  array  $attr     标签属性
     * @param  string $content  标签内容
     * @return string
     */
    public function tagAd($attr, $content)
    {
        $apid = !empty($attr['apid']) ? $attr['apid'] : '';
        $str = '';
        if (!empty($apid) && is_numeric($apid)) {
            $str .= '<?php
					$list = tag_ad("' . $ap_id . '");
                    $i=1;
					foreach($list as $key=>$value):
					extract($value);
					?>';
            $str .= $content;
            $str .= '<?php $i++; endforeach; ?>';
            return $str;
        }
        return $str;
    }
    /**
     * links 友情链接标签，循环读取友链列表
     *
     * 用例：
     *
     * {huo:links typeid="" limit="" way=""}
     *
     * {$i}         //从1自增1的变量
     * {$title}     //友链标题【特殊拼凑的后台没此字段】
     * {$imgurl}    //友链图片url【特殊拼凑的后台没此字段】
     * {$linkurl}   //友链链接url【特殊拼凑的后台没此字段】
     *
     * {/huo:links}
     *
     * 参数说明
     * typeid  链接类型id，例：typeid="1"
     * limit   读取多少条记录，例：limit="10"
     * way     展示方式，例：way="1" 文章链接；way="2" 图片链接
     *
     * @param  array  $attr      标签属性
     * @param  string $content   标签内容
     * @return string
     */
    public function tagLinks($attr, $content)
    {
        $link_type = !empty($attr['typeid']) ? $attr['typeid'] : '';
        $limit   =  !empty($attr['limit']) ? $attr['limit'] : '';
        $show_way   =  !empty($attr['way']) ? $attr['way'] : '';
        $str = '';
        if (!empty($typeid) || $typeid == 0 && is_numeric($typeid)) {
            $str .= '<?php
            		$i=1;
					$list = tag_links("' . $limit . '","' . $link_type . '","' . $show_way . '");
					foreach($list as $key=>$value):
					extract($value);
					?>';
            $str .= $content;
            $str .= '<?php $i++; endforeach; ?>';
            return $str;
        }
        return $str;
    }
}
