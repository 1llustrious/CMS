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
    /**
     * @description: ajax get请求
     * @param : 
     * @return: 
     */
    $('.ajax-get').click(function () {
        var target;
        var that = this;
        if ($(this).hasClass('confirm')) {
            if (!confirm('确认要执行该操作吗?')) {
                return false;
            }
        }
        if ((target = $(this).attr('href')) || (target = $(this).attr('url'))) {
            $.get(target).success(function (data) {
                if (data.status == 1) {
                    if (data.url) {
                        updateAlert(data.info + '', 'alert-success');
                    } else {
                        updateAlert(data.info, 'alert-success');
                    }
                    setTimeout(function () {
                        if (data.url) {
                            location.href = data.url;
                        } else {
                            location.reload();
                        }
                    }, 1500);
                } else {
                    updateAlert(data.info);
                    setTimeout(function () {
                        if (data.url) {
                            location.href = data.url;
                        }
                    }, 1500);
                }
            });
        }
        return false;
    });
    /**
     * @description: ajax post submit请求
     * @param : 
     * @return: 
     */
    $(".ajax-post").click(function () {
        var target, query, form;
        var target_form = $(this).attr('target-form');
        var that = this;
        var nead_confirm = false;
        if (($(this).attr('type') == 'submit') || (target = $(this).attr('href')) || (target = $(this).attr('url'))) {
            form = $('.' + target_form);
            if ($(this).attr('hide-data') === 'true') { //无数据时也可以使用的功能
                form = $('.hide-data');
                query = form.serialize();
            } else if (form.get(0) == undefined) {
                return false;
            } else if (form.get(0).nodeName == 'FORM') {
                if ($(this).hasClass('confirm')) {
                    if (!confirm('确认要执行该操作吗?')) {
                        return false;
                    }
                }
                if ($(this).attr('url') !== undefined) {
                    target = $(this).attr('url');
                } else {
                    target = form.get(0).action;
                }
                query = form.serialize();
            } else if (form.get(0).nodeName == 'INPUT' || form.get(0).nodeName == 'SELECT' || form.get(0).nodeName == 'TEXTAREA') {
                form.each(function (k, v) {
                    if (v.type == 'checkbox' && v.checked == true) {
                        nead_confirm = true;
                    }
                })
                if (nead_confirm && $(this).hasClass('confirm')) {
                    if (!confirm('确认要执行该操作吗?')) {
                        return false;
                    }
                }
                query = form.serialize();
            } else {
                if ($(this).hasClass('confirm')) {
                    if (!confirm('确认要执行该操作吗?')) {
                        return false;
                    }
                }
                query = form.find('input,select,textarea').serialize();
            }
            $.post(target, query).success(function (data) {
                if (data.status == 1) {
                    if (data.url) {
                        updateAlert(data.info + '', 'alert-success');
                    } else {
                        updateAlert(data.info, 'alert-success');
                    }
                    setTimeout(function () {
                        if (data.url) {
                            location.href = data.url;
                        } else {
                            location.reload();
                        }
                    }, 1500);
                } else {
                    updateAlert(data.info);
                    setTimeout(function () {
                        if (data.url) {
                            location.href = data.url;
                        }
                    }, 1500);
                }
            });
        }
        return false;
    });
    /**
     * @description: 提示层
     * @param : text 提示内容
     * @param : c    提示内容样式
     * @return: 
     */
    window.updateAlert = function (text, c) {
        text = text || 'default';
        c = c || 'alert-danger';
        if (text != 'default') {
            $('.data-tips').text(text);
            $(".data-tips").addClass(c).show();
        }
        setTimeout(function () {
            $(".data-tips").hide();
        }, 1500);
    };
});