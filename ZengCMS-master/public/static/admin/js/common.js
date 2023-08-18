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
     * 例：全选<input type="checkbox" class="check-all"> 子选择<input type="checkbox" class="ids">
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
    // 我加的,页面加载时如果子选择全部选择那么全选就被选中,不用在全选那里加checked="checked"了(加载时)
    $(".ids").each(function (i) {
        if (!this.checked) {
            $(".check-all").prop("checked", false);
            return false;
        } else {
            $(".check-all").prop("checked", true);
        }
    });
    /**
     * @description: ajax的get请求
     * 例1：<... href="" class="ajax-get">xxx</...>
     * 例2：<... url=""  class="ajax-get">xxx</...>
     * 注意顺序必须是class="confirm ajax-get"
     * 例3：<... url=""  class="confirm ajax-get" data-confirm="确定要执行操作吗？">xxx</...>
     * @param : 
     * @return: 
     */
    // $('.ajax-get').click(function () {
    // 防止append()或html()后的点击事件无效
    $(document).on("click",".ajax-get",function() {
        var that = this;
        var confirm_text;
        // 判断class="confirm ajax-get"是否有confirm如果有顺序必须是class="confirm ajax-get"
        if ($(that).hasClass('confirm')) { // class="confirm ajax-get"有confirm
            // 判断是否设置了data-confirm=""
            if (!$(that).data('confirm')) { // 设置了
                confirm_text = '确定要执行该' + $(that).text().trim() + '操作吗？';
            } else { // 没有设置
                confirm_text = $(that).data('confirm');
            }
            // 询问框
            layer.confirm(confirm_text, {
                btn: ['确定', '取消'], //按钮
                icon: 3, //图标
                title: '提示', //提示
            }, function (index) { // 点确定时的操作
                ajax_get(that);
                layer.close(index);
                return false;
            }, function () { // 点取消时的操作
                // 无需任何操作
            });
        } else { // class="ajax-get"没有confirm
            ajax_get(that);
            return false;
        }
    });
    /**
     * @description: ajax-get公共的ajax_get
     * @param : 
     * @return: 
     */
    function ajax_get(that) {
        var target;
        if ((target = $(that).attr('href')) || (target = $(that).attr('url'))) {
            if (target == 'javascript:;' || target == '') {
                return false;
            }
            // 禁止再次点击 开始
            $(that).prop('disabled', true);
            if (typeof ($(that).attr('href')) != 'undefined') {
                $(that).prop('href', 'javascript:;');
            }
            if (typeof ($(that).attr('url')) != 'undefined') {
                $(that).attr('url', '');
            }
            // 禁止再次点击 结束
            $.get(target).success(function (data) {
                if (data.code == 1) {
                    layer.msg(data.msg, {
                        icon: 1,
                        time: 1500
                    }, function () {
                        // data-reload="false"不刷新(加载)，默认刷新(加载)，如果不刷新就设置为false
                        if ($(that).attr('data-reload') !== 'false') { //刷新
                            if($(that).hasClass('remove')){
                                $(that).parents('tr').remove();
                            } else if(data.url){
                                location.href = data.url;
                            } else {
                                location.reload();
                            }
                        } else {
                            // 解禁点击 开始
                            $(that).prop('disabled', false);
                            if (typeof ($(that).attr('href')) != 'undefined') {
                                $(that).prop('href', target);
                            }
                            if (typeof ($(that).attr('url')) != 'undefined') {
                                $(that).attr('url', target);
                            }
                            // 解禁点击 结束
                        }
                    });
                } else {
                    var time = 1500;
                    if(data.wait){
                        time = data.wait * 1000;
                    }
                    layer.msg(data.msg, {
                        icon: 2,
                        time: time
                    }, function () {
                        if (data.url) {
                            location.href = data.url;
                        }
                        // 解禁点击 开始
                        $(that).prop('disabled', false);
                        if (typeof ($(that).attr('href')) != 'undefined') {
                            $(that).prop('href', target);
                        }
                        if (typeof ($(that).attr('url')) != 'undefined') {
                            $(that).attr('url', target);
                        }
                        // 解禁点击 结束
                    });
                }
            });
        }
    }
    /**
     * @description: ajax的post的submit请求(不包含图片的ajax的post上传)
     * 例1：如下所示
     * <form class="form-horizontal" action="" method="post">
     * <button class="ajax-post" type="submit" target-form="form-horizontal" url="" href="">提交保存</button>
     * </form>
     * 例2：如下所示
     * <form class="form-horizontal" action="" method="post">
     * <button class="confirm ajax-post" type="submit" target-form="form-horizontal" url="" href="" data-confirm="确定要执行操作吗？">提交保存</button>
     * </form>
     * 例3：如下所示
     * <form class="form-horizontal" action="" method="post">
     * <button class="x_admin_close ajax-post" type="submit" target-form="form-horizontal" url="" href="" data-reload="false">提交保存</button>
     * </form>
     * @param : 
     * @return: 
     */
    $(".ajax-post").click(function () {
        var target, query, form;
        var target_form = $(this).attr('target-form');
        var that = this;
        var nead_confirm = false;
        var confirm_text;
        // 注意undefined是false，而字符串'undefined'是字符串的意思即true
        if ($(this).attr('href')) {
            target = $(this).attr('href');
        } else {
            target = $(this).attr('url');
        }
        if (($(this).attr('type') == 'submit') || ($(this).attr('type') == 'button') || target) {
            // 禁止再次点击 开始
            $(that).prop('disabled', true);
            if (typeof ($(that).attr('href')) != 'undefined') {
                $(that).prop('href', 'javascript:;');
            }
            if (typeof ($(that).attr('url')) != 'undefined') {
                $(that).attr('url', '');
            }
            // 禁止再次点击 结束
            form = $('.' + target_form); //form表单对象
            if ($(this).attr('hide-data') === 'true') { //无数据时，也可以使用的功能
                form = $('.hide-data');
                query = form.serialize();
                ajax_post(that, target, query);
            } else if (form.get(0) == undefined) { //没有对象时，return false
                // 解禁点击 开始
                $(that).prop('disabled', false);
                if (typeof ($(that).attr('href')) != 'undefined') {
                    $(that).prop('href', target);
                }
                if (typeof ($(that).attr('url')) != 'undefined') {
                    $(that).attr('url', target);
                }
                // 解禁点击 结束
                return false;
            } else if (form.get(0).nodeName == 'FORM') { //是form表单节点时
                // 顺序必须是class="confirm ajax-post"
                if ($(this).hasClass('confirm')) { //判断class里是否有confirm，有
                    // 判断是否设置了data-confirm=""
                    if (!$(that).data('confirm')) {
                        confirm_text = '确定要执行该' + $(that).text().trim() + '操作吗？';
                    } else {
                        confirm_text = $(that).data('confirm');
                    }
                    //询问框
                    layer.confirm(confirm_text, {
                        btn: ['确定', '取消'], //按钮
                        icon: 3, //图标
                        title: '提示', //提示
                    }, function (index) {
                        // 点确定时的操作
                        if (target == undefined) { //判断是否通过url或href指定提交，还是用form里的action
                            target = form.get(0).action;
                        }
                        query = form.serialize(); //数据input、select、textarea、checkbox
                        ajax_post(that, target, query);
                        layer.close(index);
                        return false;
                    }, function () { // 点取消时的操作
                        // 解禁点击 开始
                        $(that).prop('disabled', false);
                        if (typeof ($(that).attr('href')) != 'undefined') {
                            $(that).prop('href', target);
                        }
                        if (typeof ($(that).attr('url')) != 'undefined') {
                            $(that).attr('url', target);
                        }
                        // 解禁点击 结束
                    });
                } else { //判断class里是否有confirm，没有
                    if (target == undefined) { //判断是否通过url或href指定提交，还是用form里的action
                        target = form.get(0).action;
                    }
                    query = form.serialize(); //数据input、select、textarea、checkbox
                    ajax_post(that, target, query);
                }
            } else if (form.get(0).nodeName == 'INPUT' || form.get(0).nodeName == 'SELECT' || form.get(0).nodeName == 'TEXTAREA') {
                form.each(function (k, v) {
                    if (v.type == 'checkbox' && v.checked == true) {
                        nead_confirm = true;
                    }
                });
                if (nead_confirm && $(this).hasClass('confirm')) {
                    // 设置了data-confirm=""
                    if (!$(that).data('confirm')) {
                        confirm_text = '确定要执行该' + $(that).text().trim() + '操作吗？';
                    } else {
                        confirm_text = $(that).data('confirm');
                    }
                    //询问框
                    layer.confirm(confirm_text, {
                        btn: ['确定', '取消'], //按钮
                        icon: 3, //图标
                        title: '提示', //提示
                    }, function (index) {
                        query = form.serialize();
                        ajax_post(that, target, query);
                        layer.close(index);
                        return false;
                    }, function () {
                        // 解禁点击 开始
                        $(that).prop('disabled', false);
                        if (typeof ($(that).attr('href')) != 'undefined') {
                            $(that).prop('href', target);
                        }
                        if (typeof ($(that).attr('url')) != 'undefined') {
                            $(that).attr('url', target);
                        }
                        // 解禁点击 结束
                    });
                } else {
                    query = form.serialize();
                    ajax_post(that, target, query);
                }
            } else {
                // 顺序必须是class="confirm ajax-post"
                if ($(this).hasClass('confirm')) {
                    // 设置了data-confirm=""
                    if (!$(that).data('confirm')) {
                        confirm_text = '确定要执行该' + $(that).text().trim() + '操作吗？';
                    } else {
                        confirm_text = $(that).data('confirm');
                    }
                    //询问框
                    layer.confirm(confirm_text, {
                        btn: ['确定', '取消'], //按钮
                        icon: 3, //图标
                        title: '提示', //提示
                    }, function (index) {
                        query = form.find('input,select,textarea').serialize();
                        ajax_post(that, target, query);
                        layer.close(index);
                        return false;
                    }, function () {
                        // 解禁点击 开始
                        $(that).prop('disabled', false);
                        if (typeof ($(that).attr('href')) != 'undefined') {
                            $(that).prop('href', target);
                        }
                        if (typeof ($(that).attr('url')) != 'undefined') {
                            $(that).attr('url', target);
                        }
                        // 解禁点击 结束
                    });
                } else {
                    query = form.find('input,select,textarea').serialize();
                    ajax_post(that, target, query);
                }
            }
        }
        return false;
    });
    /**
     * @description: ajax-post公共的ajax_post
     * @param : 
     * @return: 
     */
    // function ajax_post(that,target,query){
    // 使用window.ajax_post那么layui.use内部也可调用
    window.ajax_post = function (that, target, query) {
        $.post(target, query).success(function (data) {
            if (data.code == 1) {
                // 如果是弹窗提交数据，如果要关闭弹窗顺序必须是class="x_admin_close ajax-post"
                layer.msg(data.msg, {
                    icon: 1,
                    time: 1500
                }, function () {
                    if ($(that).hasClass('x_admin_close')) {
                        // 解禁点击 开始
                        $(that).prop('disabled', false);
                        if (typeof ($(that).attr('href')) != 'undefined') {
                            $(that).prop('href', target);
                        }
                        if (typeof ($(that).attr('url')) != 'undefined') {
                            $(that).attr('url', target);
                        }
                        // 解禁点击 结束
                        // 关闭弹窗
                        var index = parent.layer.getFrameIndex(window.name);
                        parent.layer.close(index);
                    } else {
                        // data-reload="false"不刷新(加载)，默认刷新(加载)，如果不刷新就设置为false
                        if ($(that).attr('data-reload') !== 'false') { //刷新
                            if (data.url) {
                                location.href = data.url;
                            } else {
                                location.reload();
                            }
                        } else {
                            // 解禁点击 开始
                            $(that).prop('disabled', false);
                            if (typeof ($(that).attr('href')) != 'undefined') {
                                $(that).prop('href', target);
                            }
                            if (typeof ($(that).attr('url')) != 'undefined') {
                                $(that).attr('url', target);
                            }
                            // 解禁点击 结束
                        }
                    }
                });
            } else {
                var time = 1500;
                if(data.wait){
                    time = data.wait * 1000;
                }
                layer.msg(data.msg, {
                    icon: 2,
                    time: time
                }, function () {
                    if (data.url) {
                        location.href = data.url;
                    }
                    // 解禁点击 开始
                    $(that).prop('disabled', false);
                    if (typeof ($(that).attr('href')) != 'undefined') {
                        $(that).prop('href', target);
                    }
                    if (typeof ($(that).attr('url')) != 'undefined') {
                        $(that).attr('url', target);
                    }
                    // 解禁点击 结束
                });
            }
        }).error(function(xhr,status,info){
            // if(xhr.status == 500){
                layer.msg('未知错误！', {
                    icon: 2,
                    time: 1500
                }, function () {
                    // 解禁点击 开始
                    $(that).prop('disabled', false);
                    if (typeof ($(that).attr('href')) != 'undefined') {
                        $(that).prop('href', target);
                    }
                    if (typeof ($(that).attr('url')) != 'undefined') {
                        $(that).attr('url', target);
                    }
                    // 解禁点击 结束
                });
            // }
        });
    }
    /**
      * @description: ajax的post的submit请求(包含图片的ajax的post上传)
      * 例1：如下所示
      * <form class="form-horizontal" action="" method="post">
      * <input type="file"  name=""  class="upload-file">
      * <input type="radio" name="" value="" class="upload-radio">
      * <select name="" class="upload-select">
            <option value="" selected="">请选择</option>
      * </select>
      * <textarea name="" class="upload-text"></textarea>
      * <input type="text" name="" value="" class="upload-text">
      * <input type="checkbox" name="" value="" class="upload-checkbox">
      * <button class="ajax-post2" type="submit" target-form="form-horizontal" url="" href="">提交保存</button>
      * </form>
      * 例2：如下所示
      * <form class="form-horizontal" action="" method="post">
      * <input type="file"  name=""  class="upload-file">
      * <input type="radio" name="" value="" class="upload-radio">
      * <select name="" class="upload-select">
            <option value="" selected="">请选择</option>
      * </select>
      * <textarea name="" class="upload-text"></textarea>
      * <input type="text" name="" value="" class="upload-text">
      * <input type="checkbox" name="" value="" class="upload-checkbox">
      * <button class="confirm ajax-post2" type="submit" target-form="form-horizontal" url="" href="" data-confirm="确定要执行操作吗？">提交保存</button>
      * </form>
      * 例3：如下所示
      * <form class="form-horizontal" action="" method="post">
      * <input type="file"  name=""  class="upload-file">
      * <input type="radio" name="" value="" class="upload-radio">
      * <select name="" class="upload-select">
            <option value="" selected="">请选择</option>
      * </select>
      * <textarea name="" class="upload-text"></textarea>
      * <input type="text" name="" value="" class="upload-text">
      * <input type="checkbox" name="" value="" class="upload-checkbox">
      * <button class="x_admin_close ajax-post2" type="submit" target-form="form-horizontal" url="" href="" data-reload="false">提交保存</button>
      * </form>
      * @param : 
      * @return: 
      */
    $(".ajax-post2").click(function () {
        var target, form;
        var target_form = $(this).attr('target-form');
        var that = this;
        // 注意undefined是false，而字符串'undefined'是字符串的意思即true
        if ($(this).attr('href')) {
            target = $(this).attr('href');
        } else {
            target = $(this).attr('url');
        }
        if (($(this).attr('type') == 'submit') || ($(this).attr('type') == 'button') || target) {
            // 禁止再次点击 开始
            $(that).prop('disabled', true);
            if (typeof ($(that).attr('href')) != 'undefined') {
                $(that).prop('href', 'javascript:;');
            }
            if (typeof ($(that).attr('url')) != 'undefined') {
                $(that).attr('url', '');
            }
            // 禁止再次点击 结束
            form = $('.' + target_form);
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
            // 日期转为10位时间戳提交
            $($('.upload-date')).each(function (k, v) {
                formData.append($(v).attr('name'), Math.round(new Date($(v).val()).getTime()/1000).toString());
            });
            // 顺序必须是class="confirm ajax-post2"
            if ($(this).hasClass('confirm')) { //判断class里是否有confirm
                // 设置了data-confirm=""
                if (!$(that).data('confirm')) {
                    confirm_text = '确定要执行该' + $(that).text().trim() + '操作吗？';
                } else {
                    confirm_text = $(that).data('confirm');
                }
                //询问框
                layer.confirm(confirm_text, {
                    btn: ['确定', '取消'], //按钮
                    icon: 3, //图标
                    title: '提示', //提示
                }, function (index) {
                    // 判断是否通过url指定提交，还是用form里的action
                    if (target == undefined) {
                        target = form.get(0).action;
                    }
                    ajax_post2(that, target, formData);
                    layer.close(index);
                    return false;
                }, function () {
                    // 解禁点击 开始
                    $(that).prop('disabled', false);
                    if (typeof ($(that).attr('href')) != 'undefined') {
                        $(that).prop('href', target);
                    }
                    if (typeof ($(that).attr('url')) != 'undefined') {
                        $(that).attr('url', target);
                    }
                    // 解禁点击 结束
                });
            } else {
                // 判断是否通过url指定提交，还是用form里的action
                if (target == undefined) {
                    target = form.get(0).action;
                }
                ajax_post2(that, target, formData);
            }
        }
        return false;
    });
    /**
     * @description: ajax-post2公共的ajax_post2
     * @param : 
     * @return: 
     */
    function ajax_post2(that, target, formData) {
        $.ajax({
            url: target, // 提交url地址
            type: 'POST', // post方式提交
            data: formData, // 上传formdata封装的数据
            dataType: 'JSON', // 返回 JSON 数据
            cache: false, // 不缓存
            // async:false,				 // 同步请求
            async: true, // 异步请求(默认是true异步请求)
            processData: false, // jQuery不要去处理发送的数据
            contentType: false, // jQuery不要去设置Content-Type请求头
            success: function (data) { // 成功回调
                if (data.code == 1) {
                    // 顺序必须是class="x_admin_close ajax-post"
                    layer.msg(data.msg, {
                        icon: 1,
                        time: 1500
                    }, function () {
                        if ($(that).hasClass('x_admin_close')) {
                            // 解禁点击 开始
                            $(that).prop('disabled', false);
                            if (typeof ($(that).attr('href')) != 'undefined') {
                                $(that).prop('href', target);
                            }
                            if (typeof ($(that).attr('url')) != 'undefined') {
                                $(that).attr('url', target);
                            }
                            // 解禁点击 结束
                            // 关闭弹窗
                            var index = parent.layer.getFrameIndex(window.name);
                            parent.layer.close(index);
                        } else {
                            // data-reload="false"不刷新(加载),默认刷新(加载)，如果不刷新就设置为false
                            if ($(that).attr('data-reload') !== 'false') {
                                if (data.url) {
                                    location.href = data.url; //跳转
                                } else {
                                    location.reload(); //刷新本页面
                                }
                            } else {
                                // 解禁点击 开始
                                $(that).prop('disabled', false);
                                if (typeof ($(that).attr('href')) != 'undefined') {
                                    $(that).prop('href', target);
                                }
                                if (typeof ($(that).attr('url')) != 'undefined') {
                                    $(that).attr('url', target);
                                }
                                // 解禁点击 结束
                            }
                        }
                    });
                } else {
                    var time = 1500;
                    if(data.wait){
                        time = data.wait * 1000;
                    }
                    layer.msg(data.msg, {
                        icon: 2,
                        time: time
                    }, function () {
                        if (data.url) {
                            location.href = data.url;
                        }
                        // 解禁点击 开始
                        $(that).prop('disabled', false);
                        if (typeof ($(that).attr('href')) != 'undefined') {
                            $(that).prop('href', target);
                        }
                        if (typeof ($(that).attr('url')) != 'undefined') {
                            $(that).attr('url', target);
                        }
                        // 解禁点击 结束
                    });
                }
            },
            error: function () {
                layer.msg('未知错误！', {
                    icon: 2,
                    time: 1500
                }, function () {
                    // 解禁点击 开始
                    $(that).prop('disabled', false);
                    if (typeof ($(that).attr('href')) != 'undefined') {
                        $(that).prop('href', target);
                    }
                    if (typeof ($(that).attr('url')) != 'undefined') {
                        $(that).attr('url', target);
                    }
                    // 解禁点击 结束
                });
            }
        });
    }
});
/******************************************************** layui ************************************************/
layui.use(['form', 'jquery'], function () {
    var form = layui.form, // 表单
    $ = layui.jquery; // jquery
    /**
     * @description: 全选、全不选
     * 例：如下所示
     * <input type="checkbox" id="allChoose" lay-skin="primary" lay-filter="allChoose">
     * <tbody>
     * <input type="checkbox"  name="ids[]" value="" class="ids" lay-skin="primary" lay-filter="c_one">
     * </tbody>
     * @param : 
     * @return: 
     */
    form.on('checkbox(allChoose)', function (data) {
        var child = $(data.elem).parents('table').find('tbody input[type="checkbox"]').not(".switch");
        // console.log(child);
        child.each(function (index, item) {
            item.checked = data.elem.checked;
        });
        form.render('checkbox');
    });
    // 有一个未选中全选取消选中
    form.on('checkbox(c_one)', function (data) {
        var item = $(".ids");
        // console.log(item);
        for (var i = 0; i < item.length; i++) {
            if (item[i].checked == false) {
                $("#allChoose").prop("checked", false);
                form.render('checkbox');
                break;
            }
        }
        //如果都勾选了  勾上全选
        var all = item.length;
        for (var i = 0; i < item.length; i++) {
            if (item[i].checked == true) {
                all--;
            }
        }
        if (all == 0) {
            $("#allChoose").prop("checked", true);
            form.render('checkbox');
        }
    });
    /**
     * @description: 监听提交
     * 例：如下所示
     * <form class="layui-form">
     *      <div class="layui-form-item">
     *          <label class="layui-form-label">输入框</label>
     *          <div class="layui-input-block">
     *              <input type="text" name="" placeholder="请输入" autocomplete="off" class="layui-input">
     *          </div>
     *      </div>
     *      <button lay-submit lay-filter="formDemo">提交</button>
     * </form>
     * 注意主要是<form class="layui-form">和<button lay-submit lay-filter="formDemo">
     * @param : 
     * @return: 
     */
    form.on('submit(formDemo)', function (data) {
        // console.log(data.elem) //被执行事件的元素DOM对象，一般为button对象
        // console.log(data.form) //被执行提交的form对象，一般在存在form标签时才会返回
        // console.log(data.field) //当前容器的全部表单字段，名值对形式：{name: value}
        // layer.msg(JSON.stringify(data.field),{icon:0,time:3000});
        var that = data.elem;
        var query = data.field;
        if ($(that).attr('href')) {
            target = $(that).attr('href');
        } else {
            target = $(that).attr('url');
        }
        // 判断是否通过url指定提交，还是用form里的action
        if (target == undefined) {
            target = data.form.action;
        }
        // 禁止再次点击 开始
        $(that).prop('disabled', true);
        if (typeof ($(that).attr('href')) != 'undefined') {
            $(that).prop('href', 'javascript:;');
        }
        if (typeof ($(that).attr('url')) != 'undefined') {
            $(that).attr('url', '');
        }
        // 禁止再次点击 结束
        ajax_post(that, target, query);
        return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
    });
    // 监听switch
    // 例：<input type="checkbox" {if condition="$info['show'] eq 1"} checked="" {/if} name="{:url('setShow')}" value="{$info.show}" url="{:url('setShow')}" on="ids={$info.id}&show=1" off="ids={$info.id}&show=0" lay-skin="switch" lay-filter="switchTest" lay-text="显示|隐藏">
    form.on('switch(switchTest)', function(data){
        // console.log(data.elem); //得到checkbox原始DOM对象
        console.log(data.elem.checked); //开关是否开启，true或者false
        console.log(data.value); //开关value值，也可以通过data.elem.value得到
        // console.log(data.othis); //得到美化后的DOM对象

        console.log($(data.elem).attr('url'));
        var url = $(data.elem).attr('url');
        if(data.elem.checked){
            url = url + '?' + $(data.elem).attr('on');
        }else{
            url = url + '?' + $(data.elem).attr('off');
        }
        // 发送ajax
        $.ajax({
            url:url,
            method:'get',
            // data:data.field,
            dataType:'JSON',
            //请求成功
            success : function(res) {
                console.log(res);
                if(res.code == 1){
                    layui.notice.success(res.msg);
                }else{
                    layui.notice.error(res.msg);
                }
            },
            //请求失败，包含具体的错误信息
            error : function(e){
                console.log(e.status);
                console.log(e.responseText);
                layui.notice.success(e.responseText);
            }
        });
    });
});
/**
 * @description: layui表单更新渲染
 * 例1：xuanran();//更新所有
 * 例2：xuanran('select');//刷新select选择框渲染
 * @param : 
 * @return: 
 */
window.xuanran = function(type=""){
    layui.use(['form','jquery'], function(){
        var form = layui.form, //表单
            $ = layui.jquery; //jquery
        if(type == ""){
            form.render();//更新所有
        }else{
            // 这个非常重要，更新渲染的意思吧
            // form.render('select');//刷新select选择框渲染
            form.render(type);
        }
    });
}
/************************************************** layui.layer弹出层 **************************************************************/
/**
 * @description: 弹出层(方法一)
 * @param : title   标题
 * @param : url     请求的url
 * @param : w       弹出层宽度（缺省调默认值）
 * @param : h       弹出层高度（缺省调默认值）
 * @param : refresh 关闭弹出层后是否要刷新(父级)页面（默认值不刷新）
 * @return: 
 */
function x_admin_show(title, url, w, h, refresh = 0) {
    if (title == null || title == '') {
        title = false;
    }
    if (url == null || url == '') {
        url = "404.html";
    }
    if (w == null || w == '') {
        // w=($(window).width()*0.9);
        w = ($(window).width() * 0.9) + 'px';
    } else if (w.toString().indexOf("%") == -1 && w.toString().indexOf("px") == -1) {
        w = w + 'px';
    }
    if (h == null || h == '') {
        // h=($(window).height() - 50);
        h = ($(window).height() - 50) + 'px';
    } else if (h.toString().indexOf("%") == -1 && h.toString().indexOf("px") == -1) {
        h = h + 'px';
    }
    if (refresh) { //判断关闭弹窗时是否刷新页面
        layer.open({
            type: 2,
            // area: [w+'px', h +'px'],
            area: [w, h],
            fix: false, //不固定
            maxmin: true,
            shadeClose: true,
            shade: 0.4,
            title: title,
            content: url,
            end: function () { //无论是确认还是取消，只要层被销毁了，end都会执行，不携带任何参数。layer.open关闭事件
                location.reload(); //layer.open关闭刷新
            }
        });
    } else {
        layer.open({
            type: 2,
            // area: [w+'px', h +'px'],
            area: [w, h],
            fix: false, //不固定
            maxmin: true,
            shadeClose: true,
            shade: 0.4,
            title: title,
            content: url
        });
    }
    return false;
}
/**
 * @description: 弹出层(方法二)
 * 例1：onclick="javascript:x_admin_show2('设置头尾模板','{:url('wechat_edittemplate')}',{area:['50%','500px']});"
 * 例2：onclick="javascript:x_admin_show2('设置头尾模板','{:url('wechat_edittemplate')}',{area:['50%','500px']},1);"
 * 例3：onclick="javascript:x_admin_show2('设置头尾模板','{:url('wechat_edittemplate')}',{},1);"
 * @param : title：  标题
 * @param : content：内容 url
 * @param : options：自定义参数格式：{area:['50%','500px'],type:2,shadeClose: true}
 * @param : refresh: 关闭弹出层后是否要刷新(父级)页面（默认值不刷新）
 * @return: 
 */
function x_admin_show2(title, content, options, refresh = 0) {
    // type：弹出框类型
    // title：标题
    // content：内容 url
    // skin：皮肤(墨兰：layui-layer-lan)
    // shade：遮罩（默认：0.3）
    // shadeClose：点击遮罩关闭层
    // area：宽高（百分数或者具体数字）
    // offset：坐标
    // maxmin：最大最小化
    // shift：动画效果1-6
    // closeBtn:参数1，2，0关闭
    // 更多参数：http://layer.layui.com/api.html
    if (refresh) {
        var option = {
            type: 2,
            title: '',
            skin: '',
            shadeClose: true,
            shade: 0.2,
            area: ['70%', '80%'],
            maxmin: true,
            shift: 5,
            content: '',
            end: function () {
                location.reload(); //弹出层结束后，刷新主页面
            }
        }
    } else {
        var option = {
            type: 2,
            title: '',
            skin: '',
            shadeClose: true,
            shade: 0.2,
            area: ['70%', '80%'],
            maxmin: true,
            shift: 5,
            content: ''
        }
    }
    option.title = title;
    option.content = content;
    if (options != undefined) {
        option = $.extend({}, option, options);
    }
    layer.open(option);
    return false;
}
/**
 * @description: 关闭弹出层框口
 * @param : 
 * @return: 
 */
// function x_admin_close() {
window.x_admin_close = function() {
    var index = parent.layer.getFrameIndex(window.name);
    parent.layer.close(index);
}
/************************************************* other ********************************************************/
/**
 * @description: 搜索功能
 * 例：
 * <div class="search-form">
 * <form action="">
 * <select name="status">
        <option value="" selected="selected">全部</option>
        <option value="1">正常</option>
        <option value="0">禁用</option>
 * </select>
 * <input type="text" name="title" value=""  placeholder="搜索关键词" class="search-input">
 * </form>
 * <button class="layui-btn" id="search"><i class="layui-icon"></i></button>
 * </div>
 * @param : 
 * @return: 
 */
$("#search").click(function () {
    var url = '';
    var query = $('.search-form').find('input,select').serialize();
    query = query.replace(/(&|^)(\w*?\d*?\-*?_*?)*?=?((?=&)|(?=$))/g, '');
    query = query.replace(/^&/g, '');
    if (url.indexOf('?') > 0) {
        url += '&' + query;
    } else {
        url += '?' + query;
    }
    window.location.href = url;
});
/**
 * @description: 回车搜索
 * 例：<input type="text" name="title" value="" placeholder="搜索关键词" class="search-input">
 * @param : 
 * @return: 
 */
$(".search-input").keyup(function (e) {
    if (e.keyCode === 13) {
        $("#search").click();
        return false;
    }
});