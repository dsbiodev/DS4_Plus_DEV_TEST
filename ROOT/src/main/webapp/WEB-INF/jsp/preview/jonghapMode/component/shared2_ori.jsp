<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<style>
body { background:#fff; width:1920px; height:1080px; }
.two-background-wrap {background-color:#fafafa; width:100%; height:100%; }
.two-backgrond-image-wrap { width:100%; height:100%; }
.two-previews { width:100%; height:100%; display:flex; flex-flow:wrap; }

.two-title-wrap { height:48px; }
.two-preview-wrap { height:978px; padding: 6px 0px 0 4px; box-sizing: border-box; }
.two-bottom-wrap { height:48px; }


.binso { width:1920px; display:flex; flex-direction:column; height:488px; padding-right:4px; box-sizing: border-box; background-size: 100% 100%; }
.binso-top { display:flex; flex-direction:row; height:82px; overflow:hidden; position:relative; }
.binso-mid { display:flex; flex-direction:row; height:400px; overflow:hidden; }

.bin-top-left { width:322px; height:100%; display:flex; justify-content: center; align-items: center; padding: 2px 0px 0px 0px; box-sizing: border-box; }
.bin-top-center { width:1080px; height:100%; display:flex; justify-content: center; align-items: center; padding: 2px 0px 0px 0px; box-sizing: border-box; }

.bin-top-right { position: absolute; background-size: 100% 100%; border-radius: 0px 12px 12px 0px; top: 2px; right: 4px; width: 93px; height: 100%; box-sizing: border-box; }

.bin-mid-left { width:303px; height:100%; }
.bin-mid-center { width:1080px; height:100%; padding: 6px 6px 0px 12px;}
.bin-mid-right { width:506px; display:flex; flex-direction:column; padding: 6px 0 0 0; box-sizing: border-box; }
.bin-mid-right .section { height:132px; display:flex; }
.bin-mid-right .title { color:#FFF; font-size: 30px; width:170px; display:flex; justify-content: center; align-items: center; padding-right: 6px; box-sizing: border-box; }

.bin-hosil { color:#FFF; padding-left: 6px; font-size: 60px; text-align: center; }
.bin-goin { color:#FFF; padding-left: 6px; font-size: 60px; text-align: center; }

.bin-photo { width:100%; max-height:100%; height: 100%; box-sizing: border-box; padding:6px 0px 0px 3px; }
.family { width:100%;height:100%; display: flex; align-items: center; justify-content: center; padding: 9px 6px 13px 1px; box-sizing: border-box; }
.bin-enter-start-dt { color:#FFF;  font-size: 30px; width:335px; justify-content: center; align-items: center; display: flex; }
.bin-carrying-dt { color:#FFF; font-size: 30px; width:335px; justify-content: center; align-items: center; display: flex; }
.bin-jangji { color:#FFF; font-size: 30px; width:335px; padding-top: 3px; justify-content: center; align-items: center; display: flex; padding: 21px 0px 20px 0px; }
.bin-jangji-input { color:#FFF; font-size: 30px; justify-content: center; align-items: center; display: flex; white-space: pre-wrap; }

</style>
<head>
<script>
	function makeUI(data, index) {
		var style = data.style;
		var attr = data.attr;
		var evt = data.evt;
		var funeral = data.funeral;
		var divideImg = data.divideImg;		
	
		if(style[0].BOTTOM_TEXT != ''){
			// 하단문구가 있는 경우 //
			var basicLayer = $('<div class="two-basic-layer" style="width:100%; height:100%; display:flex; flex-direction: column; ">');
			basicLayer.append('<div class="two-title-wrap"></div>');
			basicLayer.append('<div class="two-preview-wrap tpw'+index+'"></div>');
			basicLayer.append('<div class="two-bottom-wrap"></div>');
			basicLayer.append('</div>');
			$('.swiper-slide.page.p'+index).html(basicLayer);
			$('.swiper-slide.page.p'+index).css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_two_bottom_black_'+style[0].STATUS_PLATE_STYLE_NO+'.png")');
		}else{
			// 하단 문구가 없는 경우 //
			var basicLayer = $('<div class="two-basic-layer" style="width:100%; height:100%; display:flex; flex-direction: column; ">');
			basicLayer.append('<div class="two-title-wrap" style="height:96px;" ></div>');
			basicLayer.append('<div class="two-preview-wrap tpw'+index+'" style="height:984px;"></div>');
			basicLayer.append('</div>');
			$('.swiper-slide.page.p'+index).html(basicLayer);
			$('.swiper-slide.page.p'+index).css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_two_top_black_'+style[0].STATUS_PLATE_STYLE_NO+'.png")');

		}
			
		// 빈소 UI 영역 세팅 //
		var binsoLayer =  $('<div class="binso-layer" style="width:100%; height:100%; display:flex; flex-direction: row; flex-wrap:wrap;">');
		var i;
		for(i=0;i<2;i++){
			binsoLayer.append('<div class="binso i'+index+' b'+i+'"></div>');
		}
		
		binsoLayer.append('</div>');
		$('.two-preview-wrap.tpw'+index).html(binsoLayer);
		// 빈소 데이터 세팅 //
		$.each(evt, function(i, evtItem){
			if(i<2){
				var nameAreaStr = '故 '+evtItem.DM_NAME;
				if(evtItem.DM_POSITION != null){
					// 종교 직위 설정 //
					nameAreaStr += ' ';
					nameAreaStr += evtItem.DM_POSITION;
				}
				if( evtItem.DM_GENDER!=0 || evtItem.DM_AGE!=''){
					nameAreaStr += ' (';
					
					if(evtItem.DM_GENDER!=0){
						if (evtItem.DM_GENDER==1){
							nameAreaStr+= '남';
						}
						if (evtItem.DM_GENDER==2){
							nameAreaStr+= '여';
						}
						if (evtItem.DM_GENDER==3){
							nameAreaStr+= '男';
						}
						if (evtItem.DM_GENDER==4){
							nameAreaStr+= '女';
						}
						if(evtItem.DM_AGE!=''){
							nameAreaStr+= ', ';
							nameAreaStr+= evtItem.DM_AGE;
							nameAreaStr+= '세';
						}
					}else{
						nameAreaStr+= evtItem.DM_AGE;
						nameAreaStr+= '세';
					}
					nameAreaStr += ')';
				}
				
				$('.binso.i'+index+'.b'+i).append('<div class="binso-top"><div class="bin-top-left"><div class="bin-hosil">'+evtItem.APPELLATION+'</div></div><div class="bin-top-center"><div class="bin-goin">'+nameAreaStr+'</div></div><div class="bin-top-right arrow"></div></div>');
				if(style[0].ARROW_FLAG == 1 && evtItem.ARROW_NO != 0 && evtItem.ARROW_NO) $('.binso.i'+index+'.b'+i).find('.arrow').css('background-image', 'url("http://211.251.237.150:7080/dsfiles/arrow/icon_arrow_'+evtItem.ARROW_NO+'.svg")').css('background-color', '#FFF');
				$('.binso.i'+index+'.b'+i).append('<div class="binso-mid"><div class="bin-mid-left"><img class="bin-photo"></img></div><div class="bin-mid-center"><div class="family chief-mourner sangjuRoot"><div class="sangjuContainer" ><p class="col3"></p></div></div></div><div class="bin-mid-right"><div class="section"><div class="title">입관</div><div class="bin-enter-start-dt"></div></div><div class="section"><div class="title">발인</div><div class="bin-carrying-dt"></div></div><div class="section"><div class="title">장지</div><div class="bin-jangji"><div class="bin-jangji-input"></div></div></div></div>');
				
				if(evtItem.DM_PHOTO != null){
					$('.binso.i'+index+'.b'+i).find('.bin-photo').attr("src", evtItem.DM_PHOTO);
				}else{
					$('.binso.i'+index+'.b'+i).find('.bin-photo').css('display','none');
				}
				$('.binso.i'+index+'.b'+i).find('.bin-enter-start-dt').html((new Date(evtItem.ENTRANCE_ROOM_START_DT)).format('MM월dd일 HH시mm분'));
				if(evtItem.CARRYING_YN == 1){
					$('.binso.i'+index+'.b'+i).find('.bin-carrying-dt').html((new Date(evtItem.CARRYING_DT)).format('MM월dd일 HH시mm분'));
				}else{
					$('.binso.i'+index+'.b'+i).find('.bin-carrying-dt').html('-');
				}
				if(evtItem.BURIAL_PLOT_NAME == ""){
					$('.binso.i'+index+'.b'+i).find('.bin-jangji-input').html('미정');
				}else{
					$('.binso.i'+index+'.b'+i).find('.bin-jangji-input').html(evtItem.BURIAL_PLOT_NAME);
				}
				
				// 빈소 스타일 적용 //
				$.each(style, function(i, styleItem){
					if(styleItem.SPS_DIVISION == 2){
						$('.bin-enter-start-dt').css('color', styleItem.ER_START_TIME );
						$('.bin-carrying-dt').css('color', styleItem.CARRING_START_TIME );
						$('.bin-jangji-input').css('color', styleItem.BURIAL_PLOT_NAME );
					}
				});
				
				//글자 크기 변경
				autoFontSize( $('.binso.i'+index+'.b'+i).find('.bin-hosil'), $('.binso.i'+index+'.b'+i).find('.bin-top-left'));
				autoFontSize( $('.binso.i'+index+'.b'+i).find('.bin-goin'), $('.binso.i'+index+'.b'+i).find('.bin-top-center'));
				autoFontSize( $('.binso.i'+index+'.b'+i).find('.bin-jangji-input'), $('.binso.i'+index+'.b'+i).find('.bin-jangji'));
				$('.binso.i'+index+'.b'+i).find('.chief-mourner').previewFnJonghapFamily(evtItem.FAMILY, '60px');
				
				// 글자크기 변경 - 폰트 받아오는 시간 오래걸려서 작성
		 		var timer = setInterval(function() {
					// 호실
		 			if($('.binso.i'+index+'.b'+i).find('.bin-hosil').height() > $('.binso.i'+index+'.b'+i).find('.bin-top-left').height())
						autoFontSize($('.binso.i'+index+'.b'+i).find('.bin-hosil'), $('.binso.i'+index+'.b'+i).find('.bin-top-left'));
					// 고인명
					if($('.binso.i'+index+'.b'+i).find('.bin-goin').height() > $('.binso.i'+index+'.b'+i).find('.bin-top-center').height())
						autoFontSize( $('.binso.i'+index+'.b'+i).find('.bin-goin'), $('.binso.i'+index+'.b'+i).find('.bin-top-center'));
					// 장지
					if($('.binso.i'+index+'.b'+i).find('.bin-jangji-input').height() > $('.binso.i'+index+'.b'+i).find('.bin-jangji').height())
						autoFontSize( $('.binso.i'+index+'.b'+i).find('.bin-jangji-input'), $('.binso.i'+index+'.b'+i).find('.bin-jangji'));
					// 상주
					if($('.binso.i'+index+'.b'+i).find('.family.chief-mourner.sangjuRoot').height() < $('.binso.i'+index+'.b'+i).find('.sangjuContainer').height())
						$('.binso.i'+index+'.b'+i).find('.chief-mourner').previewFnJonghapFamily(evtItem.FAMILY, '60px');
				}, 1000);
				
				// 60초후 setInterval 종료
				setTimeout(function() { clearInterval(timer) }, 60000);
				
			}
		});
		if( evt.length/2 < 1 ){
			$('.binso.i'+index+'.b1').css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_two.png)");
			if(style[0].BOTTOM_TEXT != ''){
				$('.binso.i'+index+'.b1').css('width', '1906px');
				$('.binso.i'+index+'.b1').css('height', '481px');
				$('.binso.i'+index+'.b1').css('background-repeat', 'round');
				$('.binso.i'+index+'.b1').css('position', 'absolute');
				$('.binso.i'+index+'.b1').css('left', '8px');
				$('.binso.i'+index+'.b1').css('top', '544px');
			}else {
				$('.binso.i'+index+'.b1').css('width', '1906px');
				$('.binso.i'+index+'.b1').css('height', '483px');
				$('.binso.i'+index+'.b1').css('background-repeat', 'round');
				$('.binso.i'+index+'.b1').css('position', 'absolute');
				$('.binso.i'+index+'.b1').css('left', '8px');
				$('.binso.i'+index+'.b1').css('top', '592px');
			}

			var _pathImg = $.grep(divideImg, function(o){ return o.DIVIDE=="divide02" })
			if(_pathImg.length > 0)	$('.binso.i'+index+'.b1').css('background-image', 'url('+_pathImg[0].PATH+')');
		}
	}
	function initUI(data){
		if(data.evt.length > 2){
			var slickContainer = $('<div class="swiper-container" style="width:100%; height:100%; ">');
			var slickLayer = $('<div class="swiper-wrapper slick-layer" style="width:100%; height:100%; ">');
			var pageCnt = Math.ceil(data.evt.length/2);		
			var style = data.style;
			var attr = data.attr;
			var evt = data.evt;
			var funeral = data.funeral;
			
			// initialize //
			$('.two-backgrond-image-wrap').html('');
			
	
			var _sE = '';
			if(style[0].SLIDE_EFFECT == 1) _sE = 'slide';
			else _sE = 'fade';
			
			var i=0;
			for(i=0;i<pageCnt;i++){
				slickLayer.append('<div class="swiper-slide page p'+i+'"></div>')
			}
			slickContainer.append(slickLayer);
			$('.two-backgrond-image-wrap').append(slickContainer);
			var swiper = new Swiper('.swiper-container',{
				effect : _sE,
				width : $('.two-backgrond-image-wrap').width(),
				centeredSlides: true,
			      	autoplay: {
			      		disableOnInteraction : false, //마우스 클릭해도 슬라이드 재생
			        	delay: style[0].SLIDE_SEC*1000
			      	},
				loop: true
			});
			
			for(var i=0;i<pageCnt;i++){
				var changedData = data;
				if(i > 0) {
					for(var j=0;j<2;j++){changedData.evt.shift();}
				}
				makeUI(changedData, i);
			}
		}else{
			$('.two-previews').append('<div class="swiper-slide page p0"></div>');
			makeUI(data, 0);
		}
	}
</script>
</head>

<body>
	<div class="two-background-wrap">
		<div class="two-backgrond-image-wrap">
			<div class="two-previews">

			</div>
		</div>
	</div>
</body>

</html>
