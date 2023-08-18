{__NOLAYOUT__}<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>跳转提示</title>
	<style type="text/css">
	body {margin: 0px; padding:0px; font-family:"微软雅黑", Arial, "Trebuchet MS", Verdana, Georgia,Baskerville,Palatino,Times; font-size:16px;}
	div{margin-left:auto; margin-right:auto;}
	a {text-decoration: none; color: #1064A0;}
	a:hover {color: #0078D2;}
	img { border:none; }
	h1,h2,h3,h4 {
		/*	display:block;*/
		margin:0;
		font-weight:normal;
		font-family: "微软雅黑", Arial, "Trebuchet MS", Helvetica, Verdana ;
		line-height:38px;
	}
	h1{font-size:38px; color:#0188DE; padding:20px 0px 10px 0px;}
	h2{color:#0188DE; font-size:16px; padding:10px 0px 40px 0px;}
	#page{width:910px; padding:20px 20px 40px 20px; margin-top:80px;text-align: center;}
</style>
</head>
<body>
	<div id="page" style="border-style:dashed;border-color:#e4e4e4;line-height:30px;background:url(sorry.png) no-repeat right;">
		<?php switch ($code) {?>
			<?php case 1:?>
			<h1><!--( ^_^ ) --><?php echo(strip_tags($msg));?>~</h1>
			<?php break;?>
			<?php case 0:?>
			<h1><!--(+﹏+) --><?php echo(strip_tags($msg));?>~</h1>
			<?php break;?>
		<?php } ?>
	<!--
	<br />
	<h2>Sorry, the site now can not be accessed. </h2> -->
	<br />
	<font color="#666666">
		页面自动 <a id="href" href="<?php echo($url);?>">跳转</a> 等待时间： <b id="wait"><?php echo($wait);?></b>
	</font>
	<br /><br />
</div>
<script type="text/javascript">
	(function(){
		var wait = document.getElementById('wait'),href = document.getElementById('href').href;
		var interval = setInterval(function(){
			var time = --wait.innerHTML;
			if(time <= 0) {
				location.href = href;
				clearInterval(interval);
			};
		}, 1000);
	})();
</script>
</body>
</html>