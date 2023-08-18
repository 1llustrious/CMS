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
// | 公共js
// +----------------------------------------------------------------------
$(function () {
    /**
     * @description: 全选、全不选
     * @param : 
     * @return: 
     */
    $(".check-all").click(function () {
        $(".ids").prop("checked", this.checked);
    });
    // 如果子选择全选，全选按钮选中，如果有一个以上子选项不选，全选按钮不选中(点击时)
    $(".ids").click(function () {
        var option = $(".ids");
        option.each(function (i) {
            if (!this.checked) {
                $(".check-all").prop("checked", false);
                return false;
            } else {
                $(".check-all").prop("checked", true);
            }
        });
    });
    // 我加的页面加载时如果子选择全部选择那么全选就被选中不用在全选那里加checked="checked"了(加载时)
    $(".ids").each(function (i) {
        if (!this.checked) {
            $(".check-all").prop("checked", false);
            return false;
        } else {
            $(".check-all").prop("checked", true);
        }
    });
    /**
     * @description: ajax get请求
     * @param : 
     * @return: 
     */
    $('.ajax-get').click(function () {
        var target;
        var that = this;
        //顺序必须是confirm ajax-get
        if ($(that).hasClass('confirm')) {
            if (!confirm('确认要执行该操作吗?')) {
                return false;
            }
        }
        if ((target = $(that).attr('href')) || (target = $(that).attr('url'))) {
            $.get(target).success(function (data) {
                if (data.code == 1) {
                    // updateAlert(data.msg,'1');
                    // setTimeout(function(){
                    //     if (data.url) {
                    //         location.href=data.url;
                    //     }else{
                    //         location.reload();
                    //     }
                    // },1500);
                    layer.msg(data.msg, {
                        icon: 1,
                        time: 1500
                    }, function () {
                        if (data.url) {
                            location.href = data.url;
                        } else {
                            location.reload();
                        }
                    });
                } else {
                    // updateAlert(data.msg,'2');
                    // setTimeout(function(){
                    //     if (data.url) {
                    //         location.href=data.url;
                    //     }
                    // },1500);
                    layer.msg(data.msg, {
                        icon: 2,
                        time: 1500
                    }, function () {
                        if (data.url) {
                            location.href = data.url;
                        }
                    });
                }
            });
        }
        return false;
    });
    /**
     * @description: ajax post submit请求(不包含图片的ajax的post上传)
     * @param : 
     * @return: 
     */
    $(".ajax-post").click(function () {
        var target, query, form;
        var target_form = $(this).attr('target-form');
        var that = this;
        var nead_confirm = false;
        $(that).prop('disabled', true); //禁止再次点击
        if (($(this).attr('type') == 'submit') || (target = $(this).attr('href')) || (target = $(this).attr('url'))) {
            form = $('.' + target_form); //form表单对象
            if ($(this).attr('hide-data') === 'true') { //无数据时也可以使用的功能
                form = $('.hide-data');
                query = form.serialize();
            } else if (form.get(0) == undefined) { //判断数据是否存在
                return false;
            } else if (form.get(0).nodeName == 'FORM') { //判断是否是form表单，是
                //顺序必须是confirm ajax-post
                if ($(this).hasClass('confirm')) { //判断class里是否有confirm
                    if (!confirm('确认要执行该操作吗?')) { //判断是否继续操作
                        return false;
                    }
                }
                if ($(this).attr('url') !== undefined) { //判断是否通过url指定提交，还是用form里的action
                    target = $(this).attr('url');
                } else {
                    target = form.get(0).action;
                }
                query = form.serialize(); //数据input、select、textarea、checkbox
            } else if (form.get(0).nodeName == 'INPUT' || form.get(0).nodeName == 'SELECT' || form.get(0).nodeName == 'TEXTAREA') {
                form.each(function (k, v) {
                    if (v.type == 'checkbox' && v.checked == true) {
                        nead_confirm = true;
                    }
                })
                if (nead_confirm && $(this).hasClass('confirm')) {
                    //顺序必须是confirm ajax-post
                    if (!confirm('确认要执行该操作吗?')) {
                        return false;
                    }
                }
                query = form.serialize();
            } else {
                //顺序必须是confirm ajax-post
                if ($(this).hasClass('confirm')) {
                    if (!confirm('确认要执行该操作吗?')) {
                        return false;
                    }
                }
                query = form.find('input,select,textarea').serialize();
            }
            $.post(target, query).success(function (data) {
                if (data.code == 1) {
                    // updateAlert(data.msg,'1');
                    // //顺序必须是x_admin_close ajax-post
                    // if($(that).hasClass('x_admin_close')){//判断是否要关闭弹窗
                    //     setTimeout(function(){
                    //         x_admin_close();
                    //     },1500);
                    // }
                    // setTimeout(function(){
                    //     if (data.url) {
                    //         location.href=data.url;
                    //     }else{
                    //         location.reload();
                    //     }
                    // },1500);
                    //顺序必须是x_admin_close ajax-post
                    layer.msg(data.msg, {
                        icon: 1,
                        time: 1500
                    }, function () {
                        if ($(that).hasClass('x_admin_close')) {
                            // x_admin_close();//关闭弹窗
                            //关闭弹窗
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        } else {
                            if (data.url) {
                                location.href = data.url;
                            } else {
                                location.reload();
                            }
                        }
                    });
                } else {
                    // updateAlert(data.msg,'2');
                    // setTimeout(function(){
                    //     if (data.url) {
                    //          location.href=data.url;
                    //     }
                    // },1500);
                    // $(that).prop('disabled',false);//解禁点击
                    layer.msg(data.msg, {
                        icon: 2,
                        time: 1500
                    }, function () {
                        if (data.url) {
                            location.href = data.url;
                        }
                        $(that).prop('disabled', false); //解禁点击
                    });
                }
            });
        }
        return false;
    });
    /**
     * @description: ajax post submit请求(包含图片的ajax的post上传)
     * @param : 
     * @return: 
     */
    $(".ajax-post2").click(function () {
        var target, form;
        var target_form = $(this).attr('target-form');
        var that = this;
        $(that).prop('disabled', true); //禁止再次点击
        if ($(this).attr('type') == 'submit') {
            form = $('.' + target_form);
            target = form.get(0).action;
            // 上传文件
            var formData = new FormData();
            $($('.upload-file')).each(function (k, v) {
                if ($(v)[0].files[0]) {
                    formData.append($(v).attr('name'), $(v)[0].files[0]);
                }
            });
            // 单选
            $($('.upload-radio')).each(function (k, v) {
                if ($(v).prop('checked')) {
                    formData.append($(v).attr('name'), $(v).val());
                }
            });
            // 下拉菜单
            $($('.upload-select')).each(function (k, v) {
                formData.append($(v).attr('name'), $(v).val());
            });
            // 文本域、单行文本
            $($('.upload-text')).each(function (k, v) {
                formData.append($(v).attr('name'), $(v).val());
            });
            // 复选框选中
            $($('.upload-checkbox')).each(function (k, v) {
                if ($(v).prop('checked')) {
                    formData.append($(v).attr('name'), $(v).val());
                }
            });
            $.ajax({
                url: target,
                type: 'POST',
                data: formData, // 上传formdata封装的数据
                dataType: 'JSON',
                cache: false, // 不缓存
                // async: false,
                processData: false, // jQuery不要去处理发送的数据
                contentType: false, // jQuery不要去设置Content-Type请求头
                success: function (data) { //成功回调
                    if (data.code == 1) {
                        // updateAlert(data.msg,'1');
                        // setTimeout(function(){
                        //     if (data.url) {
                        //         location.href=data.url;
                        //     }else{
                        //         location.reload();
                        //     }
                        // },1500);

                        // layer.msg(data.msg, {icon: 1,time:1500},function(){
                        //     if (data.url) {
                        //         location.href=data.url;
                        //     }else{
                        //         location.reload();
                        //     }
                        // });
                        //顺序必须是x_admin_close ajax-post
                        layer.msg(data.msg, {
                            icon: 1,
                            time: 1500
                        }, function () {
                            if ($(that).hasClass('x_admin_close')) {
                                // x_admin_close();//关闭弹窗
                                // 关闭弹窗
                                var index = parent.layer.getFrameIndex(window.name);
                                parent.layer.close(index);
                            } else {
                                if (data.url) {
                                    location.href = data.url;
                                } else {
                                    location.reload();
                                }
                            }
                        });
                    } else {
                        // updateAlert(data.msg,'2');
                        // setTimeout(function(){
                        //     if (data.url) {
                        //         location.href=data.url;
                        //     }
                        // },1500);
                        // $(that).prop('disabled',false);//解禁点击
                        layer.msg(data.msg, {
                            icon: 2,
                            time: 1500
                        }, function () {
                            if (data.url) {
                                location.href = data.url;
                            }
                            $(that).prop('disabled', false); //解禁点击
                        });
                    }
                },
                error: function () {
                    // updateAlert('未知错误！','2');

                    // setTimeout(function(){
                    //     location.reload();
                    // },1500);

                    // $(that).prop('disabled',false);//解禁点击
                    layer.msg('未知错误！', {
                        icon: 2,
                        time: 1500
                    }, function () {
                        $(that).prop('disabled', false); //解禁点击
                    });
                }
            });
        }
        return false;
    });
    /**
     * @description: 提示层
     * @param : text 提示内容
     * @param : c    图标 1：打钩，2：打岔
     * @return: 
     */
    window.updateAlert = function (text, c) {
        layer.msg(text, {
            icon: c,
            time: 1500
        });
    };
    /**
     * @description: 关闭layer弹出框口
     * @param : 
     * @return: 
     */
    // function x_admin_close() {
    window.x_admin_close = function () {
        var index = parent.layer.getFrameIndex(window.name);
        parent.layer.close(index);
    }
});