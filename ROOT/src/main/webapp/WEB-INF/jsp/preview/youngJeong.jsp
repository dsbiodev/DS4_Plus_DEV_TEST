<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$.pb.ajaxCallHandler('/admin/selectYJPreview.do', { raspberryConnectionNo:_param.raspberryConnectionNo }, function(data) {
			// 영정 행사있을 때 노래 다운로드, 행사 없으면 노래없이 검은화면만
			if(data.list.length > 0) {
		 		$.pb.ajaxCallHandler('/admin/selectPreviewMusic.do', { raspberryConnectionNo:_param.raspberryConnectionNo, yjImg : data.list[0].DM_PHOTO }, function(data) { })
				$('.img-yj').prop('src', data.list[0].DM_PHOTO ? data.list[0].DM_PHOTO : "/resources/img/img_dm.png");
		 		if(data.list[0].DM_PHOTO_ROTATION) $('.img-yj').addClass('rotation');
			}
		})
	})
</script>
</head>
<style>
	html { transform: rotate(90deg); transform-origin: top right; position: absolute; top: 100%; left: calc(100% - 1080px); width: 1080px; height: 1920px; }
	body { background:#fff; width:100%; height:100%; margin: 0px; overflow: hidden; }
	.yj-warp { width: 100%; height: 100%; display: flex; justify-content: center; align-items: center; background: #000; }
	.yj-warp .img-yj { width : 100%; }
	.yj-warp .img-yj.rotation { transform:rotate(180deg); }
</style>
<body>
	<div class="yj-warp">
		<img class="img-yj">
	</div>
</body>
</html>