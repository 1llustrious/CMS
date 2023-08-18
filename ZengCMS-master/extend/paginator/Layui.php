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
// | Layui分页类
// +----------------------------------------------------------------------
namespace paginator;

use think\Paginator;

class Layui extends Paginator
{
    protected $uri;
    /**
     * [Description 上一页按钮]
     * @DateTime 2020-04-28 20:14:22
     * @param string $text
     * @return void
     */
    protected function getPreviousButton($text = "上一页")
    {
        if ($this->currentPage() <= 1) {
            return $this->getDisabledTextWrapper($text);
        }
        $url = $this->url(
            $this->currentPage() - 1
        );
        return $this->getPageLinkWrapper($url, $text);
    }
    /**
     * [Description 下一页按钮]
     * @DateTime 2020-04-28 20:14:05
     * @param string $text
     * @return void
     */
    protected function getNextButton($text = '下一页')
    {
        if (!$this->hasMore) {
            return $this->getDisabledTextWrapper($text);
        }
        $url = $this->url($this->currentPage() + 1);
        return $this->getPageLinkWrapper($url, $text);
    }
    /**
     * [Description 页码按钮]
     * @DateTime 2020-04-28 20:13:52
     * @return void
     */
    protected function getLinks()
    {
        if ($this->simple){
            return '';
        }  
        $block = [
            'first'  => null,
            'slider' => null,
            'last'   => null
        ];
        /* $side   = 3;
        $window = $side * 2;
        if ($this->lastPage < $window + 6) {
            $block['first'] = $this->getUrlRange(1, $this->lastPage);
        } elseif ($this->currentPage <= $window) {
            $block['first'] = $this->getUrlRange(1, $window + 2);
            $block['last']  = $this->getUrlRange($this->lastPage - 1, $this->lastPage);
        } elseif ($this->currentPage > ($this->lastPage - $window)) {
            $block['first'] = $this->getUrlRange(1, 2);
            $block['last']  = $this->getUrlRange($this->lastPage - ($window + 2), $this->lastPage);
        } else {
            $block['first']  = $this->getUrlRange(1, 2);
            $block['slider'] = $this->getUrlRange($this->currentPage - $side, $this->currentPage + $side);
            $block['last']   = $this->getUrlRange($this->lastPage - 1, $this->lastPage);
        } */
        /* $side   = 2;
        $window = $side * 2; */
        $side   = 1;
        $window = $side * 2;
        if ($this->lastPage < $window + 1) {
            $block['slider'] = $this->getUrlRange(1, $this->lastPage);
        } elseif ($this->currentPage <= $window - 1) {
            $block['slider'] = $this->getUrlRange(1, $window + 1);
        } elseif ($this->currentPage > ($this->lastPage - $window + 1)) {
            $block['slider']  = $this->getUrlRange($this->lastPage - ($window), $this->lastPage);
        } else {
            $block['slider'] = $this->getUrlRange($this->currentPage - $side, $this->currentPage + $side);
        }
        $html = '';
        if (is_array($block['first'])) {
            $html .= $this->getUrlLinks($block['first']);
        }
        if (is_array($block['slider'])) {
            $html .= $this->getDots();
            $html .= $this->getUrlLinks($block['slider']);
        }
        if (is_array($block['last'])) {
            $html .= $this->getDots();
            $html .= $this->getUrlLinks($block['last']);
        }
        return $html;
    }
    /**
     * [Description 渲染分页html]
     * @DateTime 2020-04-28 20:13:12
     * @return void
     */
    public function render()
    {
        if ($this->hasPages()) {
            if ($this->simple) {
                return sprintf(
                    '<ul class="pager">%s %s</ul>',
                    $this->getPreviousButton(),
                    $this->getNextButton()
                );
            } else {
                return sprintf(
                    '<div class="layui-laypage">%s %s %s %s %s</div>',
                    $this->getTotal($this->total),
                    $this->getPreviousButton(),
                    $this->getLinks(),
                    $this->getNextButton(),
                    $this->goPage()
                );
            }
        }
    }
    /**
     * [Description 生成一个可点击的按钮]
     * @DateTime 2020-04-28 20:13:03
     * @param [type] $url
     * @param [type] $page
     * @return void
     */
    protected function getAvailablePageWrapper($url, $page)
    {
        return '<a href="' . htmlentities($url) . '">' . $page . '</a>';
    }
    /**
     * [Description 生成一个禁用的按钮]
     * @DateTime 2020-04-28 20:12:50
     * @param [type] $text
     * @return void
     */
    protected function getDisabledTextWrapper($text)
    {
        return '<a class="layui-laypage-prev layui-disabled" >' . $text . '</a>';
    }
    /**
     * [Description 生成一个激活的按钮]
     * @DateTime 2020-04-28 20:12:39
     * @param [type] $text
     * @return void
     */
    protected function getActivePageWrapper($text)
    {
        return '<span class="layui-laypage-curr"><em class="layui-laypage-em"></em><em>' . $text . '</em></span>';
    }
    /**
     * [Description 生成省略号按钮]
     * @DateTime 2020-04-28 20:12:29
     * @return void
     */
    protected function getDots()
    {
        return $this->getDisabledTextWrapper('...');
    }
    /**
     * [Description 批量生成页码按钮]
     * @DateTime 2020-04-28 20:12:18
     * @param array $urls
     * @return void
     */
    protected function getUrlLinks(array $urls)
    {
        $html = '';
        foreach ($urls as $page => $url) {
            $html .= $this->getPageLinkWrapper($url, $page);
        }
        return $html;
    }
    /**
     * [Description 生成普通页码按钮]
     * @DateTime 2020-04-28 20:12:02
     * @param [type] $url
     * @param [type] $page
     * @return void
     */
    protected function getPageLinkWrapper($url, $page)
    {
        if ($page == $this->currentPage()) {
            return $this->getActivePageWrapper($page);
        }
        return $this->getAvailablePageWrapper($url, $page);
    }
    /**
     * [Description 生成总条数]
     * @DateTime 2020-04-28 20:11:48
     * @param [type] $num
     * @return void
     */
    protected function getTotal($num)
    {
        // return '<span class="layui-laypage-count">共'.$num.'条 '.$this->listRows.'条每页 第'.$this->currentPage."页/共".$this->lastPage."页". $this->total . '</b>条数据</p>'.'</span>';
        return '<span class="layui-laypage-count">' . $this->listRows . '条每页 第' . $this->currentPage . "页/共" . $this->lastPage . "页" . $this->total . '</b>条数据</p>' . '</span>';
    }
    /**
     * [Description 跳转]
     * @DateTime 2020-04-28 20:11:31
     * @return void
     */
    protected function goPage()
    {
        $this->getUri();
        return '<span class="layui-laypage-skip">到第<input type="text" min="1" value="' . $this->currentPage . '" onkeydown="javascript:if(event.keyCode==13){var page=(this.value>' . $this->lastPage . ')?' . $this->lastPage . ':this.value;location=\'' . $this->uri . 'page=\'+page+\'\'}" class="layui-input" ><button type="button" class="layui-laypage-btn" onclick="javascript:var page =(this.previousSibling.value > ' . $this->lastPage . ') ? ' . $this->lastPage . ': this.previousSibling.value;location=\'' . $this->uri . 'page=\'+page+\'\'">确定</button></span>';
    }
    /**
     * [Description 获取url]
     * @DateTime 2020-04-28 20:11:10
     * @return void
     */
    private function getUri()
    {
        $url = $_SERVER["REQUEST_URI"] . (strpos($_SERVER["REQUEST_URI"], '?') ? '' : "?");
        $parse = parse_url($url);
        if (isset($parse["query"])) {
            parse_str($parse['query'], $params);
            unset($params["page"]);
            $url = $parse['path'] . '?' . http_build_query($params) . '&';
        } else {
            $url = $parse['path'] . '?';
        }
        $this->uri = $url;
    }
}
