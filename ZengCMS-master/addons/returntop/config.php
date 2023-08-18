<?php
return [
    'random' => [
        'title'=> '是否开启随机:',
        'type' => 'radio',
        'rule' => 'required',
        'content' => [
            '1' => '开启',
            '0' => '关闭'
        ],
        'msg'     => '',
        'tips'    => '',
        'ok'      => '',
        'value'   => 0,
    ],
    'current' => [
        'title' => '指定样式:',
        'type' => 'radio',
        'value' => '1',
    ],
];
