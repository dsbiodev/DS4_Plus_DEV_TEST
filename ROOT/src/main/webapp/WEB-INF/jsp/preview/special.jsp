<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$.pb.ajaxCallHandler('/admin/selectSpecialPreview.do', { raspberryConnectionNo:_param.raspberryConnectionNo }, function(data) {
			var _list = data.list;
			
			if(data.list.length == 0) {
				$('.wait-warp').css('background', '#000');
			}else {
				if(_list[0].SCREEN_MODE == 2) {
					$('html').css("transform", "rotate(90deg)");
					$('html').css("transform-origin", "top right");
					$('html').css("position", "absolute");
					$('html').css("top", "100%");
					$('html').css("left", "calc(100% - 1080px)");
					$('html').css("width", "1080px");
					$('html').css("height", "1920px");
				}
				
				// 0:미사용, 1:사진 슬라이드, 2:동영상
				if(_list[0].SCREEN_TYPE == 0) {
					$('.special-warp').css('background', '#000');
				}else if(_list[0].SCREEN_TYPE == 1) {
					var _slideContainer = $('<div class="swiper-container" style="width:100%; height:100%;">');
					var _slideWrap = $('<div class="swiper-wrapper">');

					$.each(_list, function(idx) {
						var _div = $('<div class="swiper-slide">');
						_div.css('background-image', 'url("'+this.FILE+'")');
						_slideWrap.append(_div);
					})
					_slideContainer.append(_slideWrap);
					$('.special-warp').append(_slideContainer);
					
					if($('.swiper-slide').length > 1) {
						var swiper = new Swiper('.swiper-container',{
							effect : 'slide',
							width : $('.special-warp').width(),
							centeredSlides: true,
						      	autoplay: {
						      		disableOnInteraction : false, //마우스 클릭해도 슬라이드 재생
						        	delay: _list[0].SLIDE_SEC*1000
						      	},
							loop: true
						});
					}
				}else {
					// 동영상일 경우 파일다운로드 될수 있도록 구현
					$('.special-warp').css('background', '#000');
					$.pb.ajaxCallHandler('/admin/selectSpecialVideo.do', { raspberryConnectionNo:_param.raspberryConnectionNo, funeralNo:_param.funeralNo }, function(data) { })
				}
			}
		})
	})
</script>
</head>
<style>
	html { width:1920px;height:1080px; min-width:0px; }
	body { background:#fff; width:100%; height:100%; margin: 0px; overflow: hidden; }
	.swiper-slide { background-repeat: no-repeat; background-size: 100% 100%; }
</style>
<body>
	<div class="special-warp" style="width:100%;height:100%"></div>
</body>
</html>