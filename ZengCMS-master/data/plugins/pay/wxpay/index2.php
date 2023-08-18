<?php
include $payPlus . 'Base.php';
include $payPlus . 'phpqrcode/phpqrcode.php';
class WeiXinPay2 extends Base
{
    //1.调用统一下单API 后去二维码支付链接
    public function getQrUrl($outTradeNo, $orderTotalPrice)
    {
        //调用统一下单API
        $params = [
            'appid' => $this->data['APPID'],
            'mch_id' => $this->data['MCHID'],
            'nonce_str' => md5(time()),
            'body' => '扫码支付模式二',
            // 'out_trade_no'=> $pid,
            'out_trade_no' => $outTradeNo,
            // 'total_fee'=> 2,
            'total_fee' => $orderTotalPrice,
            'spbill_create_ip' => $_SERVER['SERVER_ADDR'],
            'notify_url' => $this->data['NOTIFY'],
            'trade_type' => 'NATIVE',
            // 'product_id'=>$pid
            'product_id' => $outTradeNo
        ];
        $arr = $this->unifiedorder($params);
        return $arr['code_url'];
    }
}
/*
$obj = new WeiXinPay2();
$qrurl = $obj->getQrUrl('1118');
//2.生成二维码
 QRcode::png($qrurl);
*/