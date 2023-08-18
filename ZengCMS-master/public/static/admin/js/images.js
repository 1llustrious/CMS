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
// | 图片处理js
// +----------------------------------------------------------------------
/**
 * @description: 模拟文件上传按钮点击操作
 * @param : filename 文件表单名
 */
function SelectImage(filename)
{
    $('.' + filename).click();
}
/**
 * @description: ajax上传文件
 */
$(".upload-file").change(function (event)
{
    var isajax = $(this).attr('isajax');
    // 判断是否ajax上传图片
    if(!isajax){
        return false;
    }
    var filename = $(this).attr('filename');  //文件表单名
    var uploadurl = $(this).attr('uploadurl');//上传地址
    uploadurl = uploadurl?uploadurl:GV.upload_url;
    var uploadparam = $(this).attr('uploadparam');//上传参数
    if(uploadparam){
        uploadurl = uploadurl + '?' + uploadparam;
    }
    var iscrop = $(this).attr('iscrop');      //上传图片后是否立即裁剪
    iscrop = iscrop?iscrop:'0';               //默认不裁剪
    var cropurl = GV.crop_url;                //裁剪地址
    var filevalue = '';
    var res = 1;
    var formData = new FormData();//上传文件
    formData.append(filename, $(this)[0].files[0]);
    $.ajax({
        url: uploadurl,
        type: 'POST',
        data: formData,//上传formdata封装的数据
        dataType: 'JSON',
        cache: false,//不缓存
        async: false,
        processData: false,//jQuery不要去处理发送的数据
        contentType: false,//jQuery不要去设置Content-Type请求头
        success: function (data) { //成功回调
            // console.log(data);
            if (data.code == 1) {
                filevalue = data.path;
                res = 1;
            } else {
                res = 0;
                // alert(data.msg);
                layer.msg(data.msg);
                setTimeout(function () {
                    if (data.url) {
                        location.href = data.url;
                    }
                }, 1500);
            }
        },
    });
    if(res){
        if (iscrop && iscrop == '1') {
            // window.open(cropurl+"?filename="+filename+"&filevalue="+filevalue);
            x_admin_show('裁剪', cropurl + "?filename=" + filename + "&filevalue=" + filevalue + "&type", '', '');
        } else {
            return_img(filevalue, filename);
        }
    }
});
/**
 * @description: 裁剪图片
 * @param : filename 文件表单名
 * @param : type     类型默认空，空返回图片，不为空刷新父(用于文件选择器里的裁剪，刷新type="file")
 */
function caijian(filename,type="")
{
    var filevalue = $("input[name=" + filename + "]").val();
    var cropurl = GV.crop_url;
    if (!filevalue) {
        alert('请先上传图片');
        return;
    } else {
        if(filevalue.indexOf('uploads/') == -1){
            alert('不能裁剪');
            return;
        }
        // window.open(cropurl+"?filename="+filename+"&filevalue="+filevalue);
        x_admin_show('裁剪', cropurl+"?filename=" + filename + "&filevalue=" + filevalue + "&type="+type, '', '');
    }
}
/**
 * @description: 裁剪后返回图像或点击直接返回图像
 * @param : filevalue 文件值
 * @param : filename  文件表单名
 */
function return_img(filevalue, filename)
{
    // 是单文件还是多文件，one：单文件，list：多文件
    var filetype  = $("input[filename=" + filename + "]").attr('filetype');
    if(filevalue.indexOf('http')!=-1){
        var filepath = filevalue;
        var arr = filevalue.split('/');
        filevalue = arr[arr.length-1];
　　}else{
        var filepath = GV.static_url + "/" + filevalue;
    }
    if (filetype == 'one') { // 单图的操作
        $("#" + filename).find('img').attr("src", filepath);
        $("input[name=" + filename + "]").val(filevalue);
        var str;
        str = '<span>';
        str = str + '<img src="' + filepath + '" alt="" height="100px;" width="100px;" class="showimg">';
        str = str + '<button type=\"button\"'+ '" filename="' + filename +  '" filevalue="' + filevalue + '"onclick=\"delimg(this);\" class="layui-btn layui-btn-danger layui-btn-mini delimg">';
        str = str + '<i class="layui-icon">&#xe640;</i>';
        str = str + '</button>';
        str = str + '</span>';
        $("#" + filename).html(str);
    } else if(filetype == 'list') { // 多图的操作
        // 第一种 还有一种js获取字符串然后转为数组形式把图片路径放到数组里再转为字符串 (字段可以用json数据存，现在用逗号分隔的字符串)
        var pic = $("input[name=" + filename + "]").val();
        if (pic == "") {
            $("input[name=" + filename + "]").val(filevalue);
        } else {
            $("input[name=" + filename + "]").val(pic + "," + filevalue);
        }
        var str;
        str = '<div class=\"img-div\">';
        str = str + '<img src=\"' + filepath + '" alt="" height="100px;" width="100px;\" class="showimg">';
        str = str + '<button type=\"button\"'+ '" filename="' + filename +  '" filevalue="' + filevalue + '"onclick=\"delimg(this);\" class="layui-btn layui-btn-danger layui-btn-mini delimg">';
        str = str + '<i class=\"layui-icon\">&#xe640;</i>';
        str = str + '</button>';
        str = str + '</div>';
        $("#" + filename).append(str);
    }else if(filetype == 'onefile'){ //单文件的操作
        $("input[name="+filename+"]").val(filevalue);
        var arr = filevalue.split('/');
        var name = arr[arr.length-1];
        /* var str;
        str='<span>';
        str=str+name;
        str=str+'<button type="button" class="layui-btn layui-btn-danger layui-btn-mini delimg" onclick="delimg(this);" filevalue="'+filevalue+'" filename="'+filename+'" filetype="'+filetype+'">';
        str=str+'<i class="layui-icon">&#xe640;</i>';
        str=str+'</button>';
        str=str+'</span>';
        $("#"+filename).html(str); */
        $("#"+filename).html("<div class=\"upload-pre-file\"><i class=\"fa fa-paperclip\"></i> " + name + "<a href='javascript:;' onclick='delimg(this);' filename="+filename+" filevalue="+filevalue+"> <i class=\"fa fa-trash-o\"></i></a></div>");
    }else if(filetype == 'filelist'){ // 多文件
        // 第一种 还有一种js获取字符串然后转为数组形式把图片路径放到数组里再转为字符串 (字段可以用json数据存，现在用逗号分隔的字符串)
        var pic = $("input[name=" + filename + "]").val();
        if (pic == "") {
            $("input[name=" + filename + "]").val(filevalue);
        } else {
            $("input[name=" + filename + "]").val(pic + "," + filevalue);
        }
        var arr = filevalue.split('/');
        var name = arr[arr.length-1];
        var str;
        str = '<div class=\"img-div\">';
        str = str + "<div class=\"upload-pre-file\">";
        str = str + "<i class=\"fa fa-paperclip\"></i> " + name + " ";
        str = str + "<button href='javascript:;' onclick='delimg(this);' filename="+filename+" filevalue="+filevalue+" style='background-color: transparent;border: 0;'>";
        str = str + "<i class=\"fa fa-trash-o\"></i>";
        str = str + "</button>";
        str = str + "</div>";
        str = str + '</div>';
        $("#" + filename).append(str);
    }else if(filetype == 'onevideo'){ // 单视频
        $("#" + filename).find('source').attr("src", filepath);
        $("input[name=" + filename + "]").val(filevalue);
        var str;
        str = '<span>';
        str = str + '<video width="100px" height="100px" controls="controls" autoplay="autoplay">';
        str = str + '<source src="' + filepath + '" type="video/mp4">';
        str = str + '</video>';
        str = str + '<button type=\"button\"'+ '" filename="' + filename +  '" filevalue="' + filevalue + '"onclick=\"delimg(this);\" class="layui-btn layui-btn-danger layui-btn-mini delimg">';
        str = str + '<i class="layui-icon">&#xe640;</i>';
        str = str + '</button>';
        str = str + '</span>';
        $("#" + filename).html(str);
    }else if(filetype == 'videolist') { // 多视频的操作
        // 第一种 还有一种js获取字符串然后转为数组形式把图片路径放到数组里再转为字符串 (字段可以用json数据存，现在用逗号分隔的字符串)
        var pic = $("input[name=" + filename + "]").val();
        if (pic == "") {
            $("input[name=" + filename + "]").val(filevalue);
        } else {
            $("input[name=" + filename + "]").val(pic + "," + filevalue);
        }
        var str;
        str = '<div class=\"img-div\">';
        str = str + '<video width="100px" height="100px" controls="controls" autoplay="autoplay">';
        str = str + '<source src="' + filepath + '" type="video/mp4">';
        str = str + '</video>';
        str = str + '<button type=\"button\"'+ '" filename="' + filename +  '" filevalue="' + filevalue + '"onclick=\"delimg(this);\" class="layui-btn layui-btn-danger layui-btn-mini delimg">';
        str = str + '<i class=\"layui-icon\">&#xe640;</i>';
        str = str + '</button>';
        str = str + '</div>';
        $("#" + filename).append(str);
    }
}
/**
 * @description: 右上角删除
 * @param : obj this
 */
function delimg(obj) {
    // 文件名称
    var filename = $(obj).attr('filename');
    // 单个文件存储路径
    var filevalue = $(obj).attr('filevalue');
    // 文件类型，one单图或list多图或onefile单文件或filelist多文件或onevideo单视频或videolist多视频
    var filetype = $("input[filename=" + filename + "]").attr('filetype');
    $.ajax({
        type: "post",
        url: GV.delete_url,
        data: {
            'url': filevalue
        },
        success: function (res) {
            if (filetype == 'one' || filetype == 'onefile' || filetype == 'onevideo') { //删除单上传的
                if (res.code == 1 || res.code == 2) {
                    $("input[name=" + filename + "]").val(''); //只有该单路径
                    // 删除/移除
                    $(obj).parent().remove();
                    layer.msg(res.msg);
                }
                if (res.code == 0) {
                    layer.msg(res.msg);
                }
            } else { //删除多上传的
                var picvalue = $("input[name=" + filename + "]").val();
                var str = "";
                if (res.code == 1 || res.code == 2) {
                    // 文本框中地址处理
                    if (picvalue == filevalue) {
                        // 只有该路径
                        $("input[name=" + filename + "]").val('');
                    } else {
                        // 该路径在字符串中间
                        str = picvalue.replace(filevalue + ",", "");
                        // 该路径在结尾
                        str = str.replace("," + filevalue, ""); 
                        $("input[name=" + filename + "]").val(str);
                    }
                    // 删除/移除
                    $(obj).parent().remove();
                    layer.msg(res.msg);
                }
                if (res.code == 0) {
                    layer.msg(res.msg);
                }
            }
        }
    });
}
// 图片拖动
$(".thumb_list").sortable({
    // 当排序动作开始时触发此事件
    start: function(event, ui) {
        // console.log(event);
        // console.log(ui);
    },
    // 当排序动作结束时触发此事件
    stop: function(event, ui) {
        // console.log(event);
        // console.log(ui);
        console.log(this);
        var filename = $(this).attr('id');
        var arr = new Array();
        $(this).find('button').each(function (index, el) {
            console.log($(el).attr('filevalue'));
            arr.push($(this).attr('filevalue'));
        });
        var str = arr.join(',');
        // console.log(str);
        $("input[name=" + filename + "]").val(str);
    },
});
// 点击图片弹窗
$(document).on("click",".showimg",function()
{
    var url = $(this).attr('src');
    getImageWidth(url,function(w,h){
        console.log({width:w,height:h});
        var width = w + 'px';
        var height = h+1 + 'px';
        var index = layer.open({
            type: 2,
            title: false,
            // area: ['630px', '360px'],
            area: [width, height],
            shade: 0.8,
            closeBtn: 0,
            shadeClose: true,
            maxmin: true,
            moveOut: true,
            maxmin: false,
            skin: 'layui-layer-nobg', //没有背景色
            content: url,
            success: function(layero, index) {
                var body = layer.getChildFrame('body', index);
                if (body.length > 0) {
                    $.each(body, function(i, v) {
                        // todo 优化弹出层背景色修改
                        $(v).before('<style>\n' +
                        'html, body {\n' +
                        '    background: #333;\n' +
                        '}\n' +
                        '</style>');
                    });
                }
            }
        });
    });
});
// 获取图片真实高度
function getImageWidth(url, callback)
{
    var img = new Image();
    img.src = url;
    // 如果图片被缓存，则直接返回缓存数据
    if(img.complete){
        callback(img.width, img.height);
    }else{
        img.onload = function(){
            callback(img.width, img.height);
        }
    }
}