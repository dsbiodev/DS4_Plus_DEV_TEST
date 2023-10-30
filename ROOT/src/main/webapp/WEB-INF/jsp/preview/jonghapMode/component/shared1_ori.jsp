<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<style>
body { background:#fff; width:1920px; height:1080px; }
.one-background-wrap {background-color:#fafafa; width:100%; height:100%; }
.one-backgrond-image-wrap { width:100%; height:100%; }
.one-previews { width:100%; height:100%; display:flex; flex-flow:wrap; }

.one-title-wrap { height:48px; }
.one-preview-wrap { height:978px; padding: 8px 0px 0 4px;}
.one-bottom-wrap { height:48px; }

.binso { width:1920px; display:flex; flex-direction:column; height:975px; padding-right:4px; background-size: 100% 100%; }
.binso-top { display:flex; flex-direction:row; height:96px; overflow:hidden; position:relative; }
.binso-mid { display:flex; flex-direction:row; height:722px; overflow:hidden; }
.binso-bottom { display:flex; flex-direction:row; height:154px; overflow:hidden; }

.bin-top-left { width:554px; height:100%; display:flex; justify-content: center; align-items: center; padding: 2px 12px 5px 13px; box-sizing: border-box; }
.bin-top-center { width:1354px; height:100%; display:flex; justify-content: center; align-items: center; padding: 2px 12px 5px 13px; box-sizing: border-box; }
.bin-top-right { position: absolute; background-size: 100% 100%; border-radius: 0px 24px 24px 0px; top: 0px; right: 0.5%; width: 93px; height: calc(100% - 6px); }

.bin-mid-left { width:558px; height:100%; }
.bin-mid-center { width:1348px; height:100%; padding: 6px 0 6px 0; }
.bin-bottom-right { width:50%; display:flex; flex-direction:column; }
.bin-bottom-right .section { height:100%; display:flex; padding-left: 6px;}
.bin-bottom-right .title { color:#FFF; font-size: 50px; width:232px; display:flex; padding-bottom: 6px; justify-content: center; align-items: center; }

.bin-bottom-left .section { height:79px; display:flex; padding-left: 6px;}
.bin-bottom-left { width:50%; height:100%; }
.bin-bottom-left .title { color:#FFF; font-size: 50px; width:232px; display:flex; padding-bottom: 6px; justify-content: center; align-items: center; }

.bin-hosil { color:#FFF; padding-left: 6px; font-size: 67px; text-align: center; }
.bin-goin { color:#FFF; padding-left: 6px; font-size: 67px; text-align: center; }

.bin-photo { width:100%; max-height:100%; height: 100%; box-sizing: border-box; padding: 1px 8px 5px 3px; }
.family { width:100%;height:100%; display: flex; align-items: center; justify-content: center; padding: 3px 9px 24px 11px; box-sizing: border-box; }
.bin-enter-start-dt { color:#FFF;  font-size: 50px; width: 714px;padding-left: 11px; padding-bottom: 6px; justify-content: center; align-items: center; display: flex; }
.bin-carrying-dt { color:#FFF; font-size: 50px; width:714px; padding-bottom: 6px; padding-left: 11px; justify-content: center; align-items: center; display: flex; }
.bin-jangji { color:#FFF; font-size: 50px; width:714px; padding-bottom: 6px; padding-left: 11px; justify-content: center; align-items: center; display: flex; padding: 0px 4px 6px 16px; }
.bin-jangji-input { color:#FFF; font-size: 50px; justify-content: center; align-items: center; display: flex; white-space: pre-wrap; }

</style>
<head>
<script>
	function makeUI(data, index) {
		var style = data.style;
		var attr = data.attr;
		var evt = data.evt;
		var funeral = data.funeral;

		if(style[0].BOTTOM_TEXT != ''){
			// 하단문구가 있는 경우 //
			var basicLayer = $('<div class="one-basic-layer" style="width:100%; height:100%; display:flex; flex-direction: column; ">');
			basicLayer.append('<div class="one-title-wrap"></div>');
			basicLayer.append('<div class="one-preview-wrap opw'+index+'"></div>');
			basicLayer.append('<div class="one-bottom-wrap"></div>');
			basicLayer.append('</div>');
			$('.swiper-slide.page.p'+index).html(basicLayer);
			$('.swiper-slide.page.p'+index).css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_one_bottom_black_'+style[0].STATUS_PLATE_STYLE_NO+'.png")');
		}else{
			// 하단 문구가 없는 경우 //
			var basicLayer = $('<div class="one-basic-layer" style="width:100%; height:100%; display:flex; flex-direction: column; ">');
			basicLayer.append('<div class="one-title-wrap" style="height:96px;" ></div>');
			basicLayer.append('<div class="one-preview-wrap opw'+index+'" style="height:976px;"></div>');
			basicLayer.append('</div>');
			$('.swiper-slide.page.p'+index).html(basicLayer);
			$('.swiper-slide.page.p'+index).css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_one_top_black_'+style[0].STATUS_PLATE_STYLE_NO+'.png")');
		}
		
		// 빈소 UI 영역 세팅 //
		var binsoLayer =  $('<div class="binso-layer" style="width:100%; height:100%; display:flex; flex-direction: row; flex-wrap:wrap;">');
		var i;
		for(i=0;i<1;i++){
			binsoLayer.append('<div class="binso i'+index+' b'+i+'"></div>');
		}
		
		binsoLayer.append('</div>');
		$('.one-preview-wrap.opw'+index).html(binsoLayer);
		// 빈소 데이터 세팅 //
		
		
		$.each(evt, function(i, evtItem){
			var nameAreaStr = '故 '+evt[index].DM_NAME;
			if(evt[index].DM_POSITION != null){
				// 종교 직위 설정 //
				nameAreaStr += ' ';
				nameAreaStr += evt[index].DM_POSITION;
			}
			if( evt[index].DM_GENDER!=0 || evt[index].DM_AGE!=''){
				nameAreaStr += ' (';
				
				if(evt[index].DM_GENDER!=0){
					if(evt[index].DM_GENDER == 1) nameAreaStr+= '남';
					if(evt[index].DM_GENDER == 2) nameAreaStr+= '여';
					if(evt[index].DM_GENDER == 3) nameAreaStr+= '男';
					if(evt[index].DM_GENDER == 4) nameAreaStr+= '女';
					if(evt[index].DM_AGE != '') {
						nameAreaStr+= ', ';
						nameAreaStr+= evt[index].DM_AGE;
						nameAreaStr+= '세';
					}
				}else {
					nameAreaStr+= evt[index].DM_AGE;
					nameAreaStr+= '세';
				}
				nameAreaStr += ')';
			}
			
			$('.binso.i'+index+'.b'+i).append('<div class="binso-top"><div class="bin-top-left"><div class="bin-hosil">'+evt[index].APPELLATION+'</div></div><div class="bin-top-center"><div class="bin-goin">'+nameAreaStr+'</div></div><div class="bin-top-right arrow"></div></div>');
			if(style[0].ARROW_FLAG == 1 && evt[index].ARROW_NO != 0 && evt[index].ARROW_NO) $('.binso.i'+index+'.b'+i).find('.arrow').css('background-image', 'url("http://211.251.237.150:7080/dsfiles/arrow/icon_arrow_'+evt[index].ARROW_NO+'.svg")').css('background-color', '#FFF');
			$('.binso.i'+index+'.b'+i).append('<div class="binso-mid"><div class="bin-mid-left"><img class="bin-photo"></img></div><div class="bin-mid-center"><div class="family chief-mourner sangjuRoot"><div class="sangjuContainer" ><p class="col3"></p></div></div></div></div>');
			$('.binso.i'+index+'.b'+i).append('<div class="binso-bottom"><div class="bin-bottom-left"><div class="section"><div class="title">입관</div><div class="bin-enter-start-dt"></div></div><div class="section"><div class="title">발인</div><div class="bin-carrying-dt"></div></div></div><div class="bin-bottom-right"><div class="section"><div class="title">장지</div><div class="bin-jangji"><div class="bin-jangji-input"></div></div></div></div></div>');
			// 분할의 경우만 폰크가 더 크게 나올수 있도록 세팅
			if(evt[index].DM_PHOTO != null){
				$('.binso.i'+index+'.b'+i).find('.bin-photo').attr("src", evt[index].DM_PHOTO);
			}else{
				$('.binso.i'+index+'.b'+i).find('.bin-photo').css('display','none');
			}
			
			$('.binso.i'+index+'.b'+i).find('.bin-enter-start-dt').html((new Date(evt[index].ENTRANCE_ROOM_START_DT)).format('MM월dd일 HH시mm분'));
			if(evt[index].CARRYING_YN == 1){
				$('.binso.i'+index+'.b'+i).find('.bin-carrying-dt').html((new Date(evt[index].CARRYING_DT)).format('MM월dd일 HH시mm분'));
			}else{
				$('.binso.i'+index+'.b'+i).find('.bin-carrying-dt').html('-');
			}
			if(evt[index].BURIAL_PLOT_NAME == ""){
				$('.binso.i'+index+'.b'+i).find('.bin-jangji-input').html('미정');
			}else{
				$('.binso.i'+index+'.b'+i).find('.bin-jangji-input').html(evt[index].BURIAL_PLOT_NAME);
			}
			
			// 빈소 스타일 적용 //
			$.each(style, function(i, styleItem){
				if(styleItem.SPS_DIVISION == 1){
					$('.bin-enter-start-dt').css('color', styleItem.ER_START_TIME );
					$('.bin-carrying-dt').css('color', styleItem.CARRING_START_TIME );
					$('.bin-jangji-input').css('color', styleItem.BURIAL_PLOT_NAME );
				}
			});
			
			//글자 크기 변경
			autoFontSize($('.binso.i'+index+'.b'+i).find('.bin-hosil'), $('.binso.i'+index+'.b'+i).find('.bin-top-left'));
			
			autoFontSize($('.binso.i'+index+'.b'+i).find('.bin-goin'), $('.binso.i'+index+'.b'+i).find('.bin-top-center'));
			
			autoFontSize($('.binso.i'+index+'.b'+i).find('.bin-jangji-input'), $('.binso.i'+index+'.b'+i).find('.bin-jangji'));
			$('.binso.i'+index+'.b'+i).find('.chief-mourner').previewFnJonghapFamily(evt[index].FAMILY, '67px');
			
			// 글자크기 변경 - 폰트 받아오는 시간 오래걸려서 작성
	 		var timer = setInterval(function() {
				// 호실
	 			if($('.binso.i'+index+'.b'+i).find('.bin-hosil').height() > $('.binso.i'+index+'.b'+i).find('.bin-top-left').height())
					autoFontSize($('.binso.i'+index+'.b'+i).find('.bin-hosil'), $('.binso.i'+index+'.b'+i).find('.bin-top-left'));
				// 고인명
				if($('.binso.i'+index+'.b'+i).find('.bin-goin').height() > $('.binso.i'+index+'.b'+i).find('.bin-top-center').height())
					autoFontSize( $('.binso.i'+index+'.b'+i).find('.bin-goin'), $('.binso.i'+index+'.b'+i).find('.bin-top-center'));
				// 상주
				if($('.binso.i'+index+'.b'+i).find('.family.chief-mourner.sangjuRoot').height() < $('.binso.i'+index+'.b'+i).find('.sangjuContainer').height())
					$('.binso.i'+index+'.b'+i).find('.chief-mourner').previewFnJonghapFamily(evt[index].FAMILY, '67px');
			}, 1000);
			
			// 60초후 setInterval 종료
			setTimeout(function() { clearInterval(timer) }, 60000);
		});
	}
	
	function initUI(data){
		if(data.evt.length>1){
			var slickContainer = $('<div class="swiper-container" style="width:100%; height:100%; ">');
			var slickLayer = $('<div class="swiper-wrapper slick-layer" style="width:100%; height:100%; ">');
			var pageCnt = Math.ceil(data.evt.length);		
			var style = data.style;
			var attr = data.attr;
			var evt = data.evt;
			var funeral = data.funeral;
			
			// initialize //
			$('.one-backgrond-image-wrap').html('');
			
			var _sE = '';
			if(style[0].SLIDE_EFFECT == 1) _sE = 'slide';
			else _sE = 'fade';
			
			var i=0;
			for(i=0;i<pageCnt;i++){
				slickLayer.append('<div class="swiper-slide page p'+i+'"></div>')
			}
			slickContainer.append(slickLayer);
			$('.one-backgrond-image-wrap').append(slickContainer);
			var swiper = new Swiper('.swiper-container',{
				effect : _sE,
				width : $('.one-backgrond-image-wrap').width(),
				centeredSlides: true,
			      	autoplay: {
			      		disableOnInteraction : false, //마우스 클릭해도 슬라이드 재생
			        	delay: style[0].SLIDE_SEC*1000
			      	},
				loop: true
			});

			for(var i=0;i<pageCnt;i++){
				var changedData = data;
// 				for(var j=0;j<2*i;j++) {changedData.evt.shift();}
				makeUI(changedData, i);
			}
		}else{
			$('.one-previews').append('<div class="swiper-slide page p0"></div>');
			makeUI(data, 0);
		}
	}
</script>
</head>

<body>
	<div class="one-background-wrap">
		<div class="one-backgrond-image-wrap">
			<div class="one-previews">

			</div>
		</div>
	</div>
</body>

</html>
