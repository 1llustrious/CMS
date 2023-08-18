<?php
namespace imgtool;

class ImgTool
{
    public static function ImageInfo($image)
    {
        //判断图片是否存在
        if (!file_exists($image)) {
            return false;
        }
        $info = getimagesize($image);
        if ($info == false) {
            return false;
        }
        $img = array();
        $img['width'] = $info[0];
        $img['height'] = $info[1];
        $img['ext'] = substr($info['mime'], strpos($info['mime'], '/') + 1);
        return $img;
    }
    //缩略图
    public static function Thumb($dst, $save = null, $width = 200, $height = 200)
    {
        $dinfo = self::ImageInfo($dst);
        if ($dinfo == false) {
            return false;
        }
        //计算缩放比例
        $calc = min($width / $dinfo['width'], $height / $dinfo['height']);
        //创建缩略画布
        $tim = imagecreatetruecolor($width, $height);
        // 创建白色填充缩略画布
        $color = imagecolorallocate($tim, 255, 255, 255);
        //填充缩略画布
        imagefill($tim, 0, 0, $color);
        $twidth = (int)$dinfo['width'] * $calc;
        $theight = (int)$dinfo['height'] * $calc;
        $posx = (int)($width - $twidth) / 2;
        $posy = (int)($height - $theight) / 2;
        $d_func = 'imagecreatefrom' . $dinfo['ext'];
        $dfunc = 'image' . $dinfo['ext'];
        if (!function_exists($d_func) || !function_exists($dfunc)) {
            return false;
        }
        //创建原始图画布
        $dim = $d_func($dst);
        //复制并缩略
        imagecopyresampled($tim, $dim, $posx, $posy, 0, 0, $twidth, $theight, $dinfo['width'], $dinfo['height']);
        if (!$save) {
            $save = $dst;
            unlink($dst);
        }
        //保存
        $dfunc($tim, $save);
        //销毁
        imagedestroy($tim);
        imagedestroy($dim);
        return true;
    }
    //缩略图2
    public static function Thumb2($dst, $save = null, $width = 200, $height = 200)
    {
        $dinfo = self::ImageInfo($dst);
        if ($dinfo == false) {
            return false;
        }
        //计算缩放比例
        $calc = min($width / $dinfo['width'], $height / $dinfo['height']);
        //创建缩略画布
        $tim = imagecreatetruecolor($width, $height);
        // 创建灰色填充缩略画布
        $color = imagecolorallocate($tim, 245, 245, 245);
        //填充缩略画布
        imagefill($tim, 0, 0, $color);
        $twidth = (int)$dinfo['width'] * $calc;
        $theight = (int)$dinfo['height'] * $calc;
        $posx = (int)($width - $twidth) / 2;
        $posy = (int)($height - $theight) / 2;
        $d_func = 'imagecreatefrom' . $dinfo['ext'];
        $dfunc = 'image' . $dinfo['ext'];
        if (!function_exists($d_func) || !function_exists($dfunc)) {
            return false;
        }
        //创建原始图画布
        $dim = $d_func($dst);
        //复制并缩略
        imagecopyresampled($tim, $dim, $posx, $posy, 0, 0, $twidth, $theight, $dinfo['width'], $dinfo['height']);
        if (!$save) {
            $save = $dst;
            unlink($dst);
        }
        //保存
        $dfunc($tim, $save);
        //销毁
        imagedestroy($tim);
        imagedestroy($dim);
        return true;
    }

    //水印图
    public static function Water($dst, $water, $save, $posx, $posy, $pct)
    {
        $dinfo = self::ImageInfo($dst);
        $winfo = self::ImageInfo($water);
        if ($dinfo == false || $winfo == false) {
            return false;
        }
        //首先保证水印不能比待操作图片还大
        if ($dinfo['width'] < $winfo['width'] || $dinfo['height'] < $winfo['height']) {
            return false;
        }
        $d_func = 'imagecreatefrom' . $dinfo['ext'];
        $dfunc = 'image' . $dinfo['ext'];
        $t_func = 'imagecreatefrom' . $winfo['ext'];
        if (!function_exists($d_func) || !function_exists($dfunc) || !function_exists($t_func)) {
            return false;
        }
        //创建画布
        $dim = $d_func($dst); //创建待操作的画布
        $tim = $t_func($water); //创建水印画布
        //复制并加水印
        imagecopymerge($dim, $tim, $posx, $posy, 0, 0, $winfo['width'], $winfo['height'], $pct);
        //保存
        if (!$save) {
            $save = $dst;
            //删除原始图
            unlink($dst);
        }
        $dfunc($dim, $save);
        imagedestroy($dim);
        imagedestroy($tim);
        return true;
    }
    //验证码
    public static function Code($style)
    {
        if ($style == 1) {
            //字符数字验证码
            $img = imagecreatetruecolor(80, 40);
            $bg = imagecolorallocate($img, 192, 192, 192);
            $color = imagecolorallocate($img, 0, 0, 0);
            imagefill($img, 0, 0, $bg);
            $number = substr(str_shuffle('abcdefghijklmnopqrstuvwzxyABCDEFGHIJKLMNOPQRSTUVWZXY123456789'), 0, 4);
            imagettftext($img, 20, 0, 8, 30, $color, __DIR__ . '/msyh.ttf', $number);
            imageline($img, 0, rand(0, 40), 80, rand(0, 40), $color);
            imageline($img, 0, rand(0, 40), 80, rand(0, 40), $color);
            imageline($img, 0, rand(0, 40), 80, rand(0, 40), $color);
            imageline($img, 0, rand(0, 40), 80, rand(0, 40), $color);
            imageline($img, 0, rand(0, 40), 80, rand(0, 40), $color);
            imageline($img, 0, rand(0, 40), 80, rand(0, 40), $color);
            //imagestring($img,5,5,2,$number,$color);
            header("content-type:image/jpeg");
            $_SESSION['Code'] = $number;
            imagejpeg($img);
            imagedestroy($img);
        } else if ($style == 2) {
            //中文验证码
            $img = imagecreatetruecolor(70, 20);
            $bg = imagecolorallocate($img, 192, 192, 192);
            $color = imagecolorallocate($img, 0, 0, 255);
            imagefill($img, 0, 0, $bg);
            $arr = array('们', '以', '我', '到', '他', '会', '作', '时', '要', '动', '国', '产', '的', '一', '是', '工', '就', '年', '阶', '义', '发', '成', '部', '民', '可', '出', '能', '方', '进', '在', '了', '不', '和', '有', '大', '这', '主', '中', '人', '上', '为', '来', '分', '生', '对', '于', '学', '下', '级', '地', '个', '用', '同', '行', '面', '说', '种', '过', '命', '度', '革', '而', '多', '子', '后', '自', '社', '加', '小', '机', '也', '经', '力', '线', '本', '电', '高', '量', '长', '党', '得', '实', '家', '定', '深', '法', '表', '着', '水', '理', '化', '争', '现', '所', '二', '起', '政', '三', '好', '十', '战', '无', '农', '使', '性', '前', '等', '反', '体', '合', '斗', '路', '图', '把', '结', '第', '里', '正', '新', '开', '论', '之', '物', '从', '当', '两', '些', '还', '天', '资', '事', '队', '批', '点', '育', '重', '其', '思', '与', '间', '内', '去', '因', '件', '日', '利', '相', '由', '压', '员', '气', '业', '代', '全', '组', '数', '果', '期', '导', '平', '各', '基', '或', '月', '毛', '然', '如', '应', '形', '想', '制', '心', '样', '干', '都', '向', '变', '关', '问', '比', '展', '那', '它', '最', '及', '外', '没', '看', '治', '提', '五', '解', '系', '林', '者', '米', '群', '头', '意', '只', '明', '四', '道', '马', '认', '次', '文', '通', '但', '条', '较', '克', '又', '公', '孔', '领', '军', '流', '入', '接', '席', '位', '情', '运', '器', '并', '飞', '原', '油', '放', '立', '题', '质', '指', '建', '区', '验', '活', '众', '很', '教', '决', '特', '此', '常', '石', '强', '极', '土', '少', '已', '根', '共', '直', '团', '统', '式', '转', '别', '造', '切', '九', '你', '取', '西', '持', '总', '料', '连', '任', '志', '观', '调', '七', '么', '山', '程', '百', '报', '更', '见', '必', '真', '保', '热', '委', '手', '改', '管', '处', '己', '将', '修', '支', '识', '病', '象', '几', '先', '老', '光', '专', '什', '六', '型', '具', '示', '复', '安', '带', '每', '东', '增', '则', '完', '风', '回', '南', '广', '劳', '轮', '科', '北', '打', '积', '车', '计', '给', '节', '做', '务', '被', '整', '联', '步', '类', '集', '号', '列', '温', '装', '即', '毫', '知', '轴', '研', '单', '色', '坚', '据', '速', '防', '史', '拉', '世', '设', '达', '尔', '场', '织', '历', '花', '受', '求', '传', '口', '断', '况', '采', '精', '金', '界', '品', '判', '参', '层', '止', '边', '清', '至', '万', '确', '究', '书', '术', '状', '厂', '须', '离', '再', '目', '海', '交', '权', '且', '儿', '青', '才', '证', '低', '越', '际', '八', '试', '规', '斯', '近', '注', '办', '布', '门', '铁', '需', '走', '议', '县', '兵', '固', '除', '般', '引', '齿', '千', '胜', '细', '影', '济', '白', '格', '效', '置', '推', '空', '配', '刀', '叶', '率', '述', '今', '选', '养', '德', '话', '查', '差', '半', '敌', '始', '片', '施', '响', '收', '华', '觉', '备', '名', '红', '续', '均', '药', '标', '记', '难', '存', '测', '士', '身', '紧', '液', '派', '准', '斤', '角', '降', '维', '板', '许', '破', '述', '技', '消', '底', '床', '田', '势', '端', '感', '往', '神', '便', '贺', '村', '构', '照', '容', '非', '搞', '亚', '磨', '族', '火', '段', '算', '适', '讲', '按', '值', '美', '态', '黄', '易', '彪', '服', '早', '班', '麦', '削', '信', '排', '台', '声', '该', '击', '素', '张', '密', '害', '侯', '草', '何', '树', '肥', '继', '右', '属', '市', '严', '径', '螺', '检', '左', '页', '抗', '苏', '显', '苦', '英', '快', '称', '坏', '移', '约', '巴', '材', '省', '黑', '武', '培', '著', '河', '帝', '仅', '针', '怎', '植', '京', '助', '升', '王', '眼', '她', '抓', '含', '苗', '副', '杂', '普', '谈', '围', '食', '射', '源', '例', '致', '酸', '旧', '却', '充', '足', '短', '划', '剂', '宣', '环', '落', '首', '尺', '波', '承', '粉', '践', '府', '鱼', '随', '考', '刻', '靠', '够', '满', '夫', '失', '包', '住', '促', '枝', '局', '菌', '杆', '周', '护', '岩', '师', '举', '曲', '春', '元', '超', '负', '砂', '封', '换', '太', '模', '贫', '减', '阳', '扬', '江', '析', '亩', '木', '言', '球', '朝', '医', '校', '古', '呢', '稻', '宋', '听', '唯', '输', '滑', '站', '另', '卫', '字', '鼓', '刚', '写', '刘', '微', '略', '范', '供', '阿', '块', '某', '功', '套', '友', '限', '项', '余', '倒', '卷', '创', '律', '雨', '让', '骨', '远', '帮', '初', '皮', '播', '优', '占', '死', '毒', '圈', '伟', '季', '训', '控', '激', '找', '叫', '云', '互', '跟', '裂', '粮', '粒', '母', '练', '塞', '钢', '顶', '策', '双', '留', '误', '础', '吸', '阻', '故', '寸', '盾', '晚', '丝', '女', '散', '焊', '功', '株', '亲', '院', '冷', '彻', '弹', '错', '散', '商', '视', '艺', '灭', '版', '烈', '零', '室', '轻', '血', '倍', '缺', '厘', '泵', '察', '绝', '富', '城', '冲', '喷', '壤', '简', '否', '柱', '李', '望', '盘', '磁', '雄', '似', '困', '巩', '益', '洲', '脱', '投', '送', '奴', '侧', '润', '盖', '挥', '距', '星', '松', '送', '获', '兴', '独', '官', '混', '纪', '依', '未', '突', '架', '宽', '冬', '章', '湿', '偏', '纹', '吃', '执', '阀', '矿', '寨', '责', '熟', '稳', '夺', '硬', '价', '努', '翻', '奇', '甲', '预', '职', '评', '读', '背', '协', '损', '棉', '侵', '灰', '虽', '矛', '厚', '罗', '泥', '辟', '告', '卵', '箱', '掌', '氧', '恩', '爱', '停', '曾', '溶', '营', '终', '纲', '孟', '钱', '待', '尽', '俄', '缩', '沙', '退', '陈', '讨', '奋', '械', '载', '胞', '幼', '哪', '剥', '迫', '旋', '征', '槽', '倒', '握', '担', '仍', '呀', '鲜', '吧', '卡', '粗', '介', '钻', '逐', '弱', '脚', '怕', '盐', '末', '阴', '丰', '雾', '冠', '丙', '街', '莱', '贝', '辐', '肠', '付', '吉', '渗', '瑞', '惊', '顿', '挤', '秒', '悬', '姆', '烂', '森', '糖', '圣', '凹', '陶', '词', '迟', '蚕', '亿', '矩', '康', '遵', '牧', '遭', '幅', '园', '腔', '订', '香', '肉', '弟', '屋', '敏', '恢', '忘', '编', '印', '蜂', '急', '拿', '扩', '伤', '飞', '露', '核', '缘', '游', '振', '操', '央', '伍', '域', '甚', '迅', '辉', '异', '序', '免', '纸', '夜', '乡', '久', '隶', '缸', '夹', '念', '兰', '映', '沟', '乙', '吗', '儒', '杀', '汽', '磷', '艰', '晶', '插', '埃', '燃', '欢', '铁', '补', '咱', '芽', '永', '瓦', '倾', '阵', '碳', '演', '威', '附', '牙', '芽', '永', '瓦', '斜', '灌', '欧', '献', '顺', '猪', '洋', '腐', '请', '透', '司', '危', '括', '脉', '宜', '笑', '若', '尾', '束', '壮', '暴', '企', '菜', '穗', '楚', '汉', '愈', '绿', '拖', '牛', '份', '染', '既', '秋', '遍', '锻', '玉', '夏', '疗', '尖', '殖', '井', '费', '州', '访', '吹', '荣', '铜', '沿', '替', '滚', '客', '召', '旱', '悟', '刺', '脑', '措', '贯', '藏', '敢', '令', '隙', '炉', '壳', '硫', '煤', '迎', '铸', '粘', '探', '临', '薄', '旬', '善', '福', '纵', '择', '礼', '愿', '伏', '残', '雷', '延', '烟', '句', '纯', '渐', '耕', '跑', '泽', '慢', '栽', '鲁', '赤', '繁', '境', '潮', '横', '掉', '锥', '希', '池', '败', '船', '假', '亮', '谓', '托', '伙', '哲', '怀', '割', '摆', '贡', '呈', '劲', '财', '仪', '沉', '炼', '麻', '罪', '祖', '息', '车', '穿', '货', '销', '齐', '鼠', '抽', '画', '饲', '龙', '库', '守', '筑', '房', '歌', '寒', '喜', '哥', '洗', '蚀', '废', '纳', '腹', '乎', '录', '镜', '妇', '恶', '脂', '庄', '擦', '险', '赞', '钟', '摇', '典', '柄', '辩', '竹', '谷', '卖', '乱', '虚', '桥', '奥', '伯', '赶', '垂', '途', '额', '壁', '网', '截', '野', '遗', '静', '谋', '弄', '挂', '课', '镇', '妄', '盛', '耐', '援', '扎', '虑', '键', '归', '符', '庆', '聚', '绕', '摩', '忙', '舞', '遇', '索', '顾', '胶', '羊', '湖', '钉', '仁', '音', '迹', '碎', '伸', '灯', '避', '泛', '亡', '答', '勇', '频', '皇', '柳', '哈', '揭', '甘', '诺', '概', '宪', '浓', '岛', '袭', '谁', '洪', '谢', '炮', '浇', '斑', '讯', '懂', '灵', '蛋', '闭', '孩', '释', '乳', '巨', '徒', '私', '银', '伊', '景', '坦', '累', '匀', '霉', '杜', '乐', '勒', '隔', '弯', '绩', '招', '绍', '胡', '呼', '痛', '峰', '零', '柴', '簧', '午', '跳', '居', '尚', '丁', '秦', '稍', '追', '梁', '折', '耗', '碱', '殊', '岗', '挖', '氏', '刃', '剧', '堆', '赫', '荷', '胸', '衡', '勤', '膜', '篇', '登', '驻', '案', '刊', '秧', '缓', '凸', '役', '剪', '川', '雪', '链', '渔', '啦', '脸', '户', '洛', '孢', '勃', '盟', '买', '杨', '宗', '焦', '赛', '旗', '滤', '硅', '炭', '股', '坐', '蒸', '凝', '竟', '陷', '枪', '黎', '救', '冒', '暗', '洞', '犯', '筒', '您', '宋', '弧', '爆', '谬', '涂', '味', '津', '臂', '障', '褐', '陆', '啊', '健', '尊', '豆', '拔', '莫', '抵', '桑', '坡', '缝', '警', '挑', '污', '冰', '柬', '嘴', '啥', '饭', '塑', '寄', '赵', '喊', '垫', '丹', '渡', '耳', '刨', '虎', '笔', '稀', '昆', '浪', '萨', '茶', '滴', '浅', '拥', '穴', '覆', '伦', '娘', '吨', '浸', '袖', '珠', '雌', '妈', '紫', '戏', '塔', '锤', '震', '岁', '貌', '洁', '剖', '牢', '锋', '疑', '霸', '闪', '埔', '猛', '诉', '刷', '狠', '忽', '灾', '闹', '乔', '唐', '漏', '闻', '沈', '熔', '氯', '荒', '茎', '男', '凡', '抢', '像', '浆', '旁', '玻', '亦', '忠', '唱', '蒙', '予', '纷', '捕', '锁', '尤', '乘', '乌', '智', '淡', '允', '叛', '畜', '俘', '摸', '锈', '扫', '毕', '璃', '宝', '芯', '爷', '鉴', '秘', '净', '蒋', '钙', '肩', '腾', '枯', '抛', '轨', '堂', '拌', '爸', '循', '诱', '祝', '励', '肯', '酒', '绳', '穷', '塘', '燥', '泡', '袋', '朗', '喂', '铝', '软', '渠', '颗', '惯', '贸', '粪', '综', '墙', '趋', '彼', '届', '墨', '碍', '启', '逆', '卸', '航', '衣', '孙', '龄', '岭', '骗', '休', '借');
            shuffle($arr);
            $chinese = implode('', array_slice($arr, 0, 4));
            imagettftext($img, 12, 0, 2, 15, $color, __DIR__ . '/msyh.ttf', $chinese);
            imageline($img, 0, rand(0, 30), 84, rand(0, 30), $color);
            imageline($img, 0, rand(0, 30), 84, rand(0, 30), $color);
            imageline($img, 0, rand(0, 30), 84, rand(0, 30), $color);
            header("content-type:image/jpeg");
            $_SESSION['Code'] = $chinese;
            imagejpeg($img);
            imagedestroy($img);
        }
    }
}
