<?php
namespace lemo\helper;

class ExpressHelper
{
    /**
     * 查询快递
     * @param $postcom  快递公司编码
     * @param $getNu    快递单号
     * @return array    物流跟踪信息数组
     */
    public function queryExpress($postcom , $getNu) 
    {
        $url = "https://m.kuaidi100.com/query?type=".$postcom."&postid=".$getNu."&id=1&valicode=&temp=0.49738534969422676";
        $resp = httpRequest($url,"GET");
        return json_decode($resp,true);
    }
}