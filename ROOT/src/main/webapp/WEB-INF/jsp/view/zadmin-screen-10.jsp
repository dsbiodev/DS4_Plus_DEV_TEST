<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<link href="https://fonts.googleapis.com/css?family=Nanum+Gothic:400,700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Noto+Serif+KR:300,400,500&display=swap" rel="stylesheet">
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$('form').attr('onsubmit', 'return false');

		var searchObj = $.extend({}, _param);
		searchObj.classifications = '10';
		searchObj.statusPlate = true;
		searchObj.eventAliveFlag = true;
		searchObj.order = 'EXPOSURE, CLASSIFICATION ASC, APPELLATION ASC, ENTRANCE_ROOM_DT DESC';

		$.pb.ajaxCallHandler('/adminSec/selectFuneralList.do', { }, function(funeralData) {
			$('.select-box-wrap .allList tbody').append('<tr><td>선택해주세요</td>');
			$.each(funeralData.list, function(){
				var _tr = $('<tr>').data(this);
				_tr.append('<td value='+this.FUNERAL_NO+'>'+this.FUNERAL_NAME+'('+this.GUNGU_NAME+')</td>');
				$('.select-box-wrap .allList').find('tbody').append(_tr);
			});
			$('.select-box-wrap .allList tbody tr').on('click', function(){
				$('.select-box-wrap .allList tr').removeClass('ac');
				$(this).addClass('ac');
				
				if($(this).data('FUNERAL_NO')){
					$('.select-box-wrap .table-search').val($(this).find('td').text());
					$('.select-box-wrap .table-search').data('funeralNo', $(this).data('FUNERAL_NO'));
						searchObj.funeralNo = $(this).data('FUNERAL_NO');
						createTable(searchObj);
					}else{
					$('.select-box-wrap .table-search').val("");
					$('.select-box-wrap .table-search').data('funeralNo', null);
					$('.previews-wrap').html("");
				}
			});
			
			$('.select-box-wrap .table-search').on('keyup', function() {
				$('.select-box-wrap .allList > tbody > tr').removeClass('ac');
				$('.select-box-wrap .allList > tbody > tr').hide();
				if($(this).val()) $('.select-box-wrap .allList > tbody td:contains("'+$(this).val()+'")').parent('tr').show();
				else $('.select-box-wrap .allList > tbody > tr').show();
			});
		});
		
		
		
		$('.previews-wrap').css('height',"calc("+$(window).height()+"px - 127px)");
		$( window ).resize(function() {
			$('.previews-wrap').css('height',"calc("+$(window).height()+"px - 127px)");
		});
		
		var _layer01 = $('.pb-right-popup-wrap[data-classification="10"]');
		_layer01.find('input[name=screenMode]').siteRadio({ addText:['가로', '세로'], defaultValue:1 });
		$.each(_layer01.find('.btn-arrow-wrap > .btn-arrow').not('.cancel'), function(idx) { $(this).attr('data-arrow-no', (idx+1)).html('<img src="/resources/icon_arrow/icon_arrow_'+(idx+1)+'.svg"/>'); });
		_layer01.find('.btn-arrow-wrap > .btn-arrow').on('click', function() {
			$('.btn-arrow-wrap > .btn-arrow').removeClass('ac');
			$(this).addClass('ac');
		});
		_layer01.find('.btn-arrow-wrap > .btn-arrow.cancel').data('arrow-no', 0).trigger('click');
		
		$('select[name=fontType]').on('change', function() {
			if($(this).val()) $('.status-plate-previews .previews').css('font-family', $(this).val());
		});
		
		var _styleData = "";
		$.pb.ajaxCallHandler('/admin/selectStatusPlateStyle.do', { flag:1 }, function(styleData) {
			_styleData = styleData;
			$.each(styleData, function(idx) {
				var _styleItem = $('<div class="style-item" data-no="'+this.STATUS_PLATE_STYLE_NO+'"></div>');
				_styleItem.data(this).css('background-image', 'url("'+this.FILE+'")');
				_styleItem.append('<span class="select"></span>');
				
				if(this.FILE.indexOf('thumbnail') != -1){
					if(_layer01.find('.screen-style-wrap > .style-item').length%4 != 0) _styleItem.addClass('right');
					_layer01.find('.screen-style-wrap').append(_styleItem);
				}
			});
			
			_layer01.find('.screen-style-wrap > .style-item').on('click', function() {
				_layer01.find('.screen-style-wrap > .style-item > .select').removeClass('ac');
				$(this).find('.select').addClass('ac');
				 
				_layer01.find('.status-plate-previews .previews').hide();
				var _screenMode = _layer01.find('input[name=screenMode]:checked').val();
				var _fileName = $(this).data('FILE').replace('/thumbnail/', '/style/').replace('.svg', (_screenMode == 1 ? '_horizontal':'_vertical')+'.svg');
				
				$.pb.ajaxCallHandler('/admin/selectStatusPlateStyle.do', { fileName:_fileName }, function(selectedStyleData) {

					if(selectedStyleData.length) {
						var _selectedStyle = selectedStyleData[0];
						var _previews = _layer01.find('.status-plate-previews .previews'+(_screenMode == 1 ? '.horizontal':'.vertical')).show();
						_previews.addClass('previews').css('background-image', 'url("'+_selectedStyle.FILE+'")');
						
						_layer01.find('input[name="statusPlateStyleNo"]').val(_selectedStyle.STATUS_PLATE_STYLE_NO);
						_previews.find('.status').css('color', _selectedStyle.STATUS);
						_previews.find('.name').css('color', _selectedStyle.NAME);
						_previews.find('.chief-mourner').css('color', _selectedStyle.CHIEF_MOURNER);
						_previews.find('.er-start').css('color', _selectedStyle.ER_START);
						_previews.find('.er-start-time').css('color', _selectedStyle.ER_START_TIME);
						_previews.find('.carrying-start').css('color', _selectedStyle.CARRING_START);
						_previews.find('.carrying-start-time').css('color', _selectedStyle.CARRING_START_TIME);
						_previews.find('.burial-plot').css('color', _selectedStyle.BURIAL_PLOT);
						_previews.find('.burial-plot-name').css('color', _selectedStyle.BURIAL_PLOT_NAME);
					}
				});
			});
			_layer01.find('.screen-style-wrap > .style-item:eq(0)').trigger('click');
		});

		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectScreen10List.do', _searchObj, function(tableData, idx) {

				$('.previews-wrap').html('');
				$.each(tableData.list, function(idx){
					var _this = this;
					var _div = $('<div class="screen-previews-box">').css('font-family', this.FONT_TYPE);
					_div.data(this);
					var _style = "";
					$.each(_styleData, function(){
						if(this.STATUS_PLATE_STYLE_NO == _this.STATUS_PLATE_STYLE_NO) _style = this;
						else if(this.STATUS_PLATE_STYLE_NO == 29) _style = this; 
					});
					
					if(!_this.SCREEN_MODE){
						_div.append('<div class="previews horizontal">');
						_div.find('.previews.horizontal').css('background-image', 'url("'+_style.FILE+'")')
						_div.find('.previews.horizontal').append('<div class="statusRoot"><div class="status" style="color:'+_style.STATUS+'">'+_this.APPELLATION+'</div></div>');
						_div.find('.previews.horizontal').append('<div class="name" style="color:'+_style.NAME+'">');
						_div.find('.previews.horizontal').append('<div class="photo">');
						_div.find('.previews.horizontal').append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
						_div.find('.previews.horizontal').append('<div class="religion">');
						_div.find('.previews.horizontal').append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
						_div.find('.previews.horizontal').append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'">');
						_div.find('.previews.horizontal').append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
						_div.find('.previews.horizontal').append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'">');
						_div.find('.previews.horizontal').append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
						_div.find('.previews.horizontal').append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'">');
						_div.find('.previews.horizontal').append('<div class="condolence swiper-container"><div class="swiper-wrapper"></div></div>');
					}
					else if(_this.SCREEN_MODE == 1){	//가로
						_div.append('<div class="previews horizontal">');
						_div.find('.previews.horizontal').css('background-image', 'url("'+_style.FILE+'")')
						_div.find('.previews.horizontal').append('<div class="statusRoot"><div class="status" style="color:'+_style.STATUS+'">'+_this.APPELLATION+'</div></div>');
						_div.find('.previews.horizontal').append('<div class="name" style="color:'+_style.NAME+'">');
						_div.find('.previews.horizontal').append('<div class="photo">');
						_div.find('.previews.horizontal').append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
						_div.find('.previews.horizontal').append('<div class="religion">');
						_div.find('.previews.horizontal').append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
						_div.find('.previews.horizontal').append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'">');
						_div.find('.previews.horizontal').append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
						_div.find('.previews.horizontal').append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'">');
						_div.find('.previews.horizontal').append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
						_div.find('.previews.horizontal').append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'">');
						_div.find('.previews.horizontal').append('<div class="condolence swiper-container"><div class="swiper-wrapper"></div></div>');
					}else{	//세로
						_div.append('<div class="previews vertical">');
						_div.find('.previews.vertical').css('background-image', 'url("'+_style.FILE+'")');
						_div.find('.previews.vertical').append('<div class="statusRoot"><div class="status" style="color:'+_style.STATUS+'">'+_this.APPELLATION+'</div></div>');
						_div.find('.previews.vertical').append('<div class="name" style="color:'+_style.NAME+'">');
						_div.find('.previews.vertical').append('<div class="photo">');
						_div.find('.previews.vertical').append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
						_div.find('.previews.vertical').append('<div class="religion">');
						_div.find('.previews.vertical').append('<div class="er-start">입관</div>').css('color', _style.ER_START);
						_div.find('.previews.vertical').append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'">');
						_div.find('.previews.vertical').append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
						_div.find('.previews.vertical').append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'">');
						_div.find('.previews.vertical').append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
						_div.find('.previews.vertical').append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'">');
						_div.find('.previews.vertical').append('<div class="condolence swiper-container"><div class="swiper-wrapper"></div></div>');
					}
					
					var _info = "";
					$.each(tableData.event, function(){
						if(_this.RASPBERRY_CONNECTION_NO == this.RASPBERRY_CONNECTION_NO){
							_info = this;
							_div.find('.previews .chief-mourner').data(this);
							if(_this.SCREEN_MODE == 1)
								_div.find('.previews .name').html("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
							else _div.find('.previews .name').html("<div>故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"</div><div>("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")</div>");
							_div.find('.previews .photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
							_div.find('.previews .religion').css('background-image', 'url("'+this.STATUS_PLATE_BG+'")');
							_div.find('.previews .er-start-time').text(this.ENTRANCE_ROOM_NO ? new Date(this.ENTRANCE_ROOM_START_DT).format('MM월dd일 HH시mm분') : "-");
							_div.find('.previews .carrying-start-time').text(new Date(this.CARRYING_DT).format('MM월dd일 HH시mm분'));
							_div.find('.previews .burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : "미정");
							
							
							// 추모의 글 영역 세팅 //
							$.pb.ajaxCallHandler('https://choomo.app/api/v1/event/obituary-comment', { eventNo : _info.EVENT_NO }, function(data) {
								$.each(data, function(){
									_div.find('.condolence').addClass('slide_'+idx);
									var _comment = $('<div class="swiper-slide"><img src="/resources/img/icon_obi_0'+this.USER_FLAG+'.png"><div class="comment">'+"'"+this.COMMENT_NO+"' "+this.NAME+'</div></div>');
									_div.find('.condolence .swiper-wrapper').append(_comment);
									if(_this.SCREEN_MODE == 1){
										if(this.COMMENT_NO.length > 37) _comment.find('.comment').css('font-size', '16px');
									}else{
										if(this.COMMENT_NO.length > 19) _comment.find('.comment').css('font-size', '11px');
										else if(this.COMMENT_NO.length > 13) _comment.find('.comment').css('font-size', '15px');
										else _comment.find('.comment').css('font-size', '20px');
									}
								});
							});
						}
					});
					_div.on('click', function(){
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.top-button.register').data(_div.data()).val(_div.data('STATUS_PLATE_NO'));
							_thisLayer.find('.btn-arrow-wrap .btn-arrow').removeClass('ac');
							layerInit(_thisLayer, _div.data());
							if(_div.data('STATUS_PLATE_NO')) {
								if(_div.data('ARROW_NO') == 0) _thisLayer.find('.btn-arrow-wrap .btn-arrow.cancel').trigger('click');
								else _thisLayer.find('.btn-arrow-wrap .btn-arrow[data-arrow-no="'+_div.data('ARROW_NO')+'"]').trigger('click');
								if(_div.data('CLASSIFICATION') == 10) _thisLayer.find('.screen-style-wrap .style-item[data-no="'+_div.data('THUMBNAIL')+'"]').trigger('click');
							} else { //라즈베리 처음 등록한 후 상태값 없을때
								_layer01.find('.screen-style-wrap > .style-item:eq(0)').trigger('click');
								_thisLayer.find('input[name=multiMode]').val(2).click();
							}
							_thisLayer.find('.status').text(_this.APPELLATION);
							
							if(_info){
								_thisLayer.find('.photo').css('background-image', 'url("'+_info.DM_PHOTO+'")');
								_thisLayer.find('.religion').css('background-image', 'url("'+_info.STATUS_PLATE_BG+'")');
								_thisLayer.find('.name').text("故 "+_info.DM_NAME+" "+isNull(_info.DM_POSITION, '')+"("+(_info.DM_GENDER == 1 ? '남' : '여')+(_info.DM_AGE ? ",  "+_info.DM_AGE+"세" : "")+")");
								_thisLayer.find('.er-start-time').text(_info.ENTRANCE_ROOM_NO ? new Date(_info.ENTRANCE_ROOM_START_DT).format('MM월dd일 HH시mm분') : "-");
								_thisLayer.find('.carrying-start-time').text(new Date(_info.CARRYING_DT).format('MM월dd일 HH시mm분'));
								_thisLayer.find('.burial-plot-name').text(_info.BURIAL_PLOT_NAME ? _info.BURIAL_PLOT_NAME : "미정");
							}else{
								_thisLayer.find('.name').text("");
								_thisLayer.find('.chief-mourner .sangjuContainer .col3').html("");
								_thisLayer.find('.er-start-time').text("");
								_thisLayer.find('.carrying-start-time').text("");
								_thisLayer.find('.burial-plot-name').text("");
							}
							_layer01.find('input[name=screenMode]').on('change', function() { 
								_layer01.find('.screen-style-wrap .select.ac').parent('.style-item').trigger('click'); 
								init();
								setTimeout(function() {
									setBinso(_thisLayer.find('.statusRoot'));
									if(_layer01.find('input[name=screenMode]:checked').val() == 1){
										$('.pb-right-popup-wrap .previews.horizontal .chief-mourner').fnBinsoFamily(_info.EVENT_NO, tableData.family);	
									}else{
										$('.pb-right-popup-wrap .previews.vertical .chief-mourner').fnBinsoFamily(_info.EVENT_NO, tableData.family);	
									}
								}, 100);
								
							});
							_layer01.find('input[name=screenMode]').change();
							
							_thisLayer.find('.condolence').html("");
							_thisLayer.find('.horizontal .condolence').addClass('hPopSlide_'+idx);
							_thisLayer.find('.vertical .condolence').addClass('vPopSlide_'+idx);
							_thisLayer.find('.condolence').append('<div class="swiper-wrapper"></div>');
							// 추모의 글 영역 세팅 //
							
							if(_info) {
								$.pb.ajaxCallHandler('https://choomo.app/api/v1/event/obituary-comment', { eventNo : _info.EVENT_NO }, function(data) {
									$.each(data, function(){
										_div.find('.condolence').addClass('slide_'+idx);
										var _comment = $('<div class="swiper-slide"><img src="/resources/img/icon_obi_0'+this.USER_FLAG+'.png"><div class="comment">'+"'"+this.COMMENT_NO+"' "+this.NAME+'</div></div>');
										_div.find('.condolence .swiper-wrapper').append(_comment);
										if(_this.SCREEN_MODE == 1){
											if(this.COMMENT_NO.length > 37) _comment.find('.comment').css('font-size', '16px');
										}else{
											if(this.COMMENT_NO.length > 19) _comment.find('.comment').css('font-size', '11px');
											else if(this.COMMENT_NO.length > 13) _comment.find('.comment').css('font-size', '15px');
											else _comment.find('.comment').css('font-size', '20px');
										}
									});
								});
							}
							
							function init(){
								if(swiper != null) swiper.destroy(true, true);
	 							
	 							if(_thisLayer.find('input[name=screenMode]:checked').val() == 1){
	 								if(_thisLayer.find('.condolence .swiper-slide').length > 1){
										var swiper = new Swiper('.hPopSlide_'+idx, {
											direction: 'vertical',
											width : 918,
											height : 35,
											centeredSlides: true,
									      	autoplay: {
									      		disableOnInteraction : false, //마우스 클릭해도 슬라이드 재생
									        	delay: 3000
									      	},
											loop: true
										});
									}
	 							}
	 							else{
	 								if(_thisLayer.find('.condolence .swiper-slide').length > 1){
											var swiper = new Swiper('.vPopSlide_'+idx, {
											direction: 'vertical',
											width : 408,
											height : 28,
											centeredSlides: true,
									      	autoplay: {
									      		disableOnInteraction : false, //마우스 클릭해도 슬라이드 재생
									        	delay: 3000
									      	},
											loop: true
										});
									}
	 							}
							}
							init();
						});
					});
					setTimeout(function() {
	 					setBinso(_div.find('.previews .statusRoot'));
					}, 250);
					$('.previews-wrap').append(_div);
					//유가족 height값 위해서 append 이후로 뺌
					_div.find('.previews .chief-mourner').fnBinsoFamily(_div.find('.previews .chief-mourner').data('EVENT_NO'), tableData.family, _this.SCREEN_MODE);
					
					// 슬라이드 부분 - loop시 3개까지 복제 되서 length > 1 이상만 슬라이드 되게 함.
					if(_div.find('.previews .condolence .swiper-slide').length > 1){
						var swiper = new Swiper('.slide_'+idx, {
							direction: 'vertical',
							width : 361,
							centeredSlides: true,
					      	autoplay: {
					      		disableOnInteraction : false, //마우스 클릭해도 슬라이드 재생
					        	delay: 3000
					      	},
							loop: true
						});
					}
				});
			});
		};
// 		createTable(searchObj);
		
		
		//저장버튼
		$('.pb-right-popup-wrap .top-button.register').on('click', function() {
			var _btnValue = $(this).val();
			var _data = $(this).data();
			var _form = $('#dataForm'+(_data.CLASSIFICATION == 90 ? 50:_data.CLASSIFICATION));
			if(_data.CLASSIFICATION == 30 && !$('input[name=binsoCheck]:checked').length) return alert('적용할 빈소를 선택해주세요.');
			else if(!necessaryChecked(_form)) {
				var _uploadUrl = _btnValue ? '/admin/updateRaspberryStatusPlate.do':'/admin/insertRaspberryStatusPlate.do';
				var _formData = new FormData(_form[0]);
				_formData.append('actionUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('funeralNo', $('.select-box-wrap .table-search').data('funeralNo'));
				_formData.append('classification', _data.CLASSIFICATION);
				if(_data.RASPBERRY_CONNECTION_NO) _formData.append('raspberryConnectionNo', _data.RASPBERRY_CONNECTION_NO);
				_formData.append('statusPlateNo', _btnValue ? _btnValue:'');
				_formData.append('arrowNo', $('.btn-arrow-wrap > .btn-arrow.ac').data('arrow-no') ? $('.btn-arrow-wrap > .btn-arrow.ac').data('arrow-no') : 0);
				$.pb.ajaxUploadForm(_uploadUrl, _formData, function(result) {
					if(result != 0) {
						createTable(searchObj);
						closeLayerPopup();
					} else alert('저장 실패 관리자에게 문의하세요');
				}, '${sessionScope.loginProcess}');
			}
		});

		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<form id="dataForm10">
	<div class="pb-right-popup-wrap full-size" data-classification="10">
		<input type="hidden" name="statusPlateStyleNo" value=""/>
		<div class="pb-popup-title">빈소현황판 편집</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body half" style="width:960px; overflow:hidden;">
			<div class="popup-body-top">
				<div class="top-title">빈소현황판 미리보기</div>
			</div>
			<div class="status-plate-previews">
				<div class="previews-box">
					<div class="previews horizontal">
						<div class="statusRoot">
							<div class="status"></div>
						</div>
						<div class="name">故 김고인 권사 (남, 78세)</div>
						<div class="photo"></div>
						<div class="chief-mourner sangjuRoot">
				        	<div class='sangjuContainer'>
				            	<p class="col3"></p>
				        	</div>
						</div>
						<div class="religion"></div>
						<div class="er-start">입 관</div>
						<div class="er-start-time">12월 14일 06시 30분</div>
						<div class="carrying-start">발 인</div>
						<div class="carrying-start-time">12월 14일 06시 30분</div>
						<div class="burial-plot">장 지</div>
						<div class="burial-plot-name">성남공원</div>
						<div class="condolence swiper-container"></div>
					</div>
					<div class="previews vertical">
						<div class="statusRoot">
							<div class="status"></div>
						</div>
						<div class="name">故 김고인 권사 (남, 78세)</div>
						<div class="photo"></div>
						<div class="chief-mourner sangjuRoot">
				        	<div class='sangjuContainer'>
				            	<p class="col3"></p>
				        	</div>
						</div>
						<div class="religion"></div>
						<div class="er-start">입 관</div>
						<div class="er-start-time">12월 14일 06시 30분</div>
						<div class="carrying-start">발 인</div>
						<div class="carrying-start-time">12월 14일 06시 30분</div>
						<div class="burial-plot">장 지</div>
						<div class="burial-plot-name">성남공원</div>
						<div class="condolence swiper-container"></div>
					</div>
				</div>
			</div>
		</div>
		<div class="pb-popup-body half" style="width:calc(100% - 960px);">
			<div class="popup-body-top">
				<div class="top-title">현황판 정보</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
				</div>
			</div>
			<div class="pb-popup-form">
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">화면모드</label>
						<input type="radio" name="screenMode" value="1"/><input type="radio" name="screenMode" value="2"/>
					</div>
					<div class="row-box">
						<label class="title">폰트설정</label>
						<select class="form-select" name="fontType">
							<option value="NanumGothicExtraBold">고딕체 (나눔고딕)</option>
							<option value="NanumBarunGothicBold">고딕체 (나눔바른고딕)</option>
							<option value="NanumSquare_acB">스퀘어체 (나눔스퀘어)</option>
							<option value="Noto Sans KR">고딕체 (구글 노토 산스)</option>
							<option value="unBatang">바탕체 (은바탕체)</option>
							<option value="unDotum">돋움체 (은돋움체)</option>
							<option value="unGungseo">궁서체 (은궁서체)</option>
							<option value="unGraphic">그래픽체 (은그래픽)</option>
							<option value="nanumMyeongjoBold">명조체 (나눔명조)</option>
						</select>
					</div>
				</div>
				<div class="form-box-st-01 half" style="margin-left:14px; padding:20px 2.5px;">
					<div class="btn-arrow-wrap">
						<button type="button" class="btn-arrow"></button>
						<button type="button" class="btn-arrow"></button>
						<button type="button" class="btn-arrow"></button>
						<button type="button" class="btn-arrow"></button>
						<button type="button" class="btn-arrow"></button>
					</div>
					<div class="btn-arrow-wrap">
						<button type="button" class="btn-arrow bt-none"></button>
						<button type="button" class="btn-arrow bt-none cancel">없음</button>
						<button type="button" class="btn-arrow bt-none"></button>
					</div>
					<div class="btn-arrow-wrap">
						<button type="button" class="btn-arrow bt-none"></button>
						<button type="button" class="btn-arrow bt-none"></button>
						<button type="button" class="btn-arrow bt-none"></button>
						<button type="button" class="btn-arrow bt-none"></button>
						<button type="button" class="btn-arrow bt-none"></button>
					</div>
				</div>
			</div>
			<div class="popup-body-top" style="padding:16px 0 15px 0;">
				<div class="top-title">화면스타일</div>
			</div>
			<div class="pb-popup-form" style="vertical-align:top;">
				<div class="screen-style-wrap"></div>
			</div>
		</div>
	</div>
</form>

<div class="select-box-wrap">
	<input type="text" class="form-text table-search">
	<div class="funeral-box">
		<table class="allList">
			<colgroup><col width="100%"/></colgroup>
			<tbody></tbody>
		</table>
	</div>
</div>

<div class="contents-title-wrap">
	<div class="title">빈소 현황판 관리</div>
	<div class="sub-title">화면을 관리할 수 있습니다.</div>
</div>
<div class="contents-body-wrap">
	<div class="previews-wrap"></div>
</div>