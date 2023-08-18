<?php
  //pc端微信支付配置
  $data=array();

  // 商户号
  // $data['MCHID']=getAllConf('pc_wxpay_mchid');
  $data['MCHID']='1420367002';

  // 支付秘钥
  // $data['KEY']= getAllConf('pc_wxpay_key');
  $data['KEY']= 'T34s934IadLs0897jhge43Bsaigafddf';

  // APPID
  // $data['APPID']=getAllConf('pc_wxpay_appid');
  $data['APPID']='wx12dd820d8fbf8593';

  // 开发者密码
  // $data['SECRET']=getAllConf('pc_wxpay_secret');
  $data['SECRET']='b9840976e63916e233d1d380549514a3';

  // 统一下单API地址
  // $data['UOURL']=getAllConf('pc_wxpay_uourl');
  $data['UOURL']='https://api.mch.weixin.qq.com/pay/unifiedorder';
  
  // 支付通知地址
  // $data['NOTIFY']=getAllConf('pc_wxpay_notify');
  $data['NOTIFY']='http://ayanhaiai.ittun.com/shop/Flow/wxPaySuccess';
?>