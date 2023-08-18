/* 刷新验证码 开始 */
var verifyimg = $(".verifyimg").attr("src");
$(".verifyimg").attr("src", verifyimg.replace(/\?.*$/,'')+'?'+Math.random());
$(".reloadverify").click(function(){
    if(verifyimg.indexOf('?')>0){
        $(".verifyimg").attr("src", verifyimg+'&random='+Math.random());
    }else{
        $(".verifyimg").attr("src", verifyimg.replace(/\?.*$/,'')+'?'+Math.random());
    }
});
/* 刷新验证码 结束 */
/* 登录 开始 */
function login(){
	var form = $("#form");
	var url = form.attr('action');
	if(!$("input[name='verify']").val()){
		layer.msg('请输入验证码', {icon: 2,time:1500});
		return false;
	}
	if(!$("input[name='name']").val()){
		layer.msg('请输入用户名', {icon: 2,time:1500});
		return false;
	}
	if(!$("input[name='password']").val()){
		layer.msg('请输入密码', {icon: 2,time:1500});
		return false;
	}
	var query = form.serialize();
	$.post(url,query,function(data){
		if(data.code==0){
			layer.msg(data.msg, {icon: 2,time:1500});
			setTimeout(function(){
				if(data.url){
					location.href=data.url;
				}
			},1500);
		}else{
			layer.msg(data.msg, {icon: 1,time:1500});
			setTimeout(function(){
				if(data.url){
					location.href=data.url;
				}
			},1500);
		}
	},"JSON");
}
// 回车登录
$(document).keyup(function(e) {
    if (e.keyCode === 13) {
        login();
        return false;
    }
});
/* 登录 结束 */