<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<link href="https://fonts.googleapis.com/css?family=Nanum+Gothic:400,700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Noto+Serif+KR:300,400,500&display=swap" rel="stylesheet">
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$('form').attr('onsubmit', 'return false');
		
		var searchObj = $.extend({}, _param);
		searchObj.classifications = '10,30';
		searchObj.statusPlate = true;
		searchObj.eventAliveFlag = true;
		searchObj.order = 'EXPOSURE, CLASSIFICATION ASC, APPELLATION ASC, ENTRANCE_ROOM_DT ASC';

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
		
		
		$('.previews-wrap').css('height',"calc("+$(window).height()+"px - 207px)");
		$( window ).resize(function() {
			$('.previews-wrap').css('height',"calc("+$(window).height()+"px - 207px)");
		});

		var _layer02 = $('.pb-right-popup-wrap[data-classification="30"]');
		_layer02.find('input[name=slideEffect], input[name=arrowFlag], input[name=screenMode], input[name=divisionMode]').siteRadio({ addText:['켜기', '끄기', '켜기', '끄기', '자동', '고정'], defaultValue:1 });
		_layer02.find('input[name=multiMode]').siteRadio({ addText:['켜기', '끄기'], defaultValue:2 });
		
		for(var i=5; i<=10; i++) {
			_layer02.find('select[name=slideSec]').append('<option value="'+i+'">'+i+'초</option>');
		}
		
		//멀티모드 radio
		_layer02.find('input[name=multiMode]').on('change', function() {
			//슬라이드효과 화면간격 화면분할 분할모드
			if($(this).val() == 1){
				$('.disable').show();
				$('select[name=multiName]').attr("disabled", false);
				_layer02.find('.previews').hide();
			}else{
				$('.disable').hide();
				$('select[name=multiName]').attr("disabled", true);
				_layer02.find('.previews').show();
				if(_layer02.find('input[name=divisionMode]:checked').val() == 1)
					_layer02.find('.previews').hide();
			}
		});
		
		// 분할모드 변경
		_layer02.find('input[name=divisionMode]').on('change', function() {
			if($(this).val() == 1){
				$('select[name=division]').attr("disabled", true);
				_layer02.find('.previews').hide();
			}else{
				$('select[name=division]').attr("disabled", false);
				_layer02.find('.previews').show();
			}
		});
		
		
		_layer02.find('input[name=binsoAllCheck]').pbCheckbox({ color:'blue' });
		
		$('select[name=fontType]').on('change', function() {
			if($(this).val()) $('.status-plate-previews .previews').css('font-family', $(this).val());
		});
		
		var _styleData = "";
		$.pb.ajaxCallHandler('/admin/selectStatusPlateStyle.do', { flag:2 }, function(styleData) {
			_styleData = styleData;
			$.each(styleData, function(idx) {
				var _styleItem = $('<div class="style-item" data-no="'+this.STATUS_PLATE_STYLE_NO+'"></div>');
				_styleItem.data(this).css('background-image', 'url("'+this.FILE+'")');
				_styleItem.append('<span class="select"></span>');

				if(this.FILE.indexOf('thumbnail') != -1){
					if(_layer02.find('.screen-allboard-wrap > .style-item').length%2 == 1) _styleItem.addClass('right');
					_layer02.find('.screen-allboard-wrap').append(_styleItem);	
				}
			});
			
			//종합현황판 -> 종합현황판 스타일 클릭
			_layer02.find('.screen-allboard-wrap > .style-item').on('click', function() {
				var _ = $(this);
				_.attr('disabled', true);
				var _divisionVal = _layer02.find('select[name=division] > option:selected').val();
				var _tempStr = $(this).data('FILE').replace('/thumbnail/', '/style/').replace('.svg', '');
				var _thumb = $(this).data('no');
// 				var _fileName = _tempStr+'_0'+_divisionVal;
				$.pb.ajaxCallHandler('/admin/selectStatusPlateStyle.do', { flag:2, division:_divisionVal, thumbnail:$(this).data('no') }, function(detailData) {
					var _allBoardObj = detailData[0];
					var _titleVal = _tempStr.slice(-1);
					if(_titleVal == 1) _layer02.find('.previews-box > .top-title').css('background', '');
					else if(_titleVal == 2) _layer02.find('.previews-box > .top-title').css('background', '#F6D25E');
					else if(_titleVal == 3) _layer02.find('.previews-box > .top-title').css('background', '#585858');
					else if(_titleVal == 4) _layer02.find('.previews-box > .top-title').css('background', '#FFEEBE');
					
					var _previews = _layer02.find('.status-plate-previews .previews .previews-box .binso-wrap');
					
					var _div = "";
					if(_divisionVal == 1) _div = "one";
					else if(_divisionVal == 2) _div = "two";
					else if(_divisionVal == 4) _div = "four";
					else if(_divisionVal == 6) _div = "six";
					else if(_divisionVal == 8) _div = "eight";

					_previews.removeClass('one two four six eight').addClass(_div);
					
					if($('input[name=bottomText]').val()) _previews.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_'+_div+'_bottom_black_'+_thumb+'.png")');
					else _previews.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_'+_div+'_top_black_'+_thumb+'.png")');
					
					_previews.find('.status').css('color', _allBoardObj.STATUS);
					_previews.find('.name').css('color', _allBoardObj.NAME) ;
					_previews.find('.chief-mourner').css('color', _allBoardObj.CHIEF_MOURNER);
					_previews.find('.er-start').css('color', _allBoardObj.ER_START);
					_previews.find('.er-start-time').css('color', _allBoardObj.ER_START_TIME);
					_previews.find('.carrying-start').css('color', _allBoardObj.CARRING_START);
					_previews.find('.carrying-start-time').css('color', _allBoardObj.CARRING_START_TIME);
					_previews.find('.burial-plot').css('color', _allBoardObj.BURIAL_PLOT);
					_previews.find('.burial-plot-name').css('color', _allBoardObj.BURIAL_PLOT_NAME);
					
					if($('input[name=arrowFlag]:checked').val() == 1) _previews.find('.table-cell .arrow').show();
					else _previews.find('.table-cell .arrow').hide();
					
					_layer02.find('.screen-allboard-wrap > .style-item > .select').removeClass('ac');
					_.find('.select').addClass('ac');
					_.attr('disabled', false);
				});
			});
			_layer02.find('.screen-allboard-wrap > .style-item:eq(0)').trigger('click');
		});
		
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectScreen30List.do', _searchObj, function(tableData) {
				_layer02.find('.pb-table.list > tbody').html('');
				$('.previews-wrap').html('');
				$.each(tableData.list, function(idx){
					
					//빈소명 리스트 추가
					if(this.CLASSIFICATION == 10){
						var _layerTr = $('<tr>');
						_layerTr.append('<td><input type="checkbox" name="binsoCheck" value="'+this.RASPBERRY_CONNECTION_NO+'"/></td>');
						_layerTr.append('<td>'+this.APPELLATION+'</td>');
						_layer02.find('.pb-table.list > tbody').append(_layerTr);
					}
					if(this.CLASSIFICATION == 30){
						var _this = this;
						var _div = $('<div class="screen-previews-30">').css('font-family', this.FONT_TYPE).data(this);
						var _style = "";
						$.each(_styleData, function(){
							if(this.THUMBNAIL == _this.STATUS_PLATE_STYLE_NO && this.DIVISION == _this.DIVISION) _style = this;
						});
						
						var _text = "slide_"+idx;
						_div.append('<div class="previews swiper-container '+_text+'"><div class="previews-box swiper-wrapper">');
						_div.append('<div class="title">'+this.APPELLATION);
						_div.append('<button type="button" class="btn-upd">수정하기</button>');
						
						var _wrap = $('<div class="info">');
						_wrap.append('<div>분할모드 : '+(this.DIVISION_MODE ? (this.DIVISION_MODE == 1 ? '자동' : '고정') : '미셋팅')+'</div>');
						_wrap.append('<div>화면분할 : '+(this.DIVISION ? this.DIVISION+"분할" : '미셋팅')+'</div>');
						_wrap.append('<div>멀티모드 : '+(this.MULTI_MODE ? (this.MULTI_MODE == 1 ? '켜기' : '끄기') : '미셋팅')+'</div>');
						_wrap.append('<div>멀티이름 : '+(this.MULTI_NAME ? this.MULTI_NAME : '미셋팅')+'</div>');
						_div.append(_wrap);
						
						_div.find('.btn-upd').off().on('click', function(){
							$('.pb-right-popup-wrap[data-classification=30]').openLayerPopup({}, function(_thisLayer) {
								_thisLayer.find('.top-button.register').data(_div.data()).val(_div.data('STATUS_PLATE_NO'));
								layerInit(_thisLayer, _div.data());
								var _data = _div.data();
								
								//빈소 수 배열 저장
								var _divBinsoArr = "";
								if(_div.data('BINSO_LIST')) _divBinsoArr = _div.data('BINSO_LIST').split(',');
								
								//행사 개수 세기
								var _cnt = 0;
								var _fnDivide = function(){
									_cnt = 0; //행사 개수 초기화
									_thisLayer.find('.status-plate-previews').html("");
									// 팝업 미리보기 화면 만들기
									var _popDiv = $('<div class="previews swiper-container popup'+_div.data('RASPBERRY_CONNECTION_NO')+'"><div class="previews-box swiper-wrapper">');
									
									//행사 개수 세기
									var _event = [];
									$.each(_divBinsoArr, function(idx){
										var _chk = false;
										$.each(tableData.event, function(){
											if(_divBinsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
												_cnt++;
												_event.push(this);
												_chk = true;
												if(_chk) return false; // break
											}
										});
									});
									// _event = 행사 마감하기 전까지 모든행사 조회 후 가장 오래된 행사 저장
									// 팝업 분할화면에 _event 리스트로 변경,
									
									
									if(_cnt == 0){ // 행사수 없을때 모두 대기화면 보여줌
										_popDiv.find('.title-box').hide();
										if(tableData.waitInfo[0]){
											if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
												_popDiv.find('.previews-box').html("").css('background', '#000');
											}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
												$.each(tableData.waitInfo, function(){
													var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
													_binso.css('background-image', 'url('+this.FILE+')');
													_div.find('.previews-box').append(_binso);
												});
											}else{ //대기화면 동영상
												_popDiv.find('.previews-box').html('<video controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
											}
										}else{
											_popDiv.find('.previews-box').html("").css('background', '#000');
										}
										
									}else{ //행사수 있을때
										//스타일 정하기
										var _imgDivide = "one";
										if(_thisLayer.find('select[name=division]').val() == 1) _imgDivide = "one";
										else if(_thisLayer.find('select[name=division]').val() == 2) _imgDivide = "two";
										else if(_thisLayer.find('select[name=division]').val() == 4) _imgDivide = "four";
										else if(_thisLayer.find('select[name=division]').val() == 6) _imgDivide = "six";
										else if(_thisLayer.find('select[name=division]').val() == 8) _imgDivide = "eight";
											
										//탑생성
										_popDiv.append('<div class="title-box">');
										_popDiv.find('.title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
										_popDiv.find('.title-box').append('<div class="text">빈소안내</div>');
										_popDiv.find('.title-box').append('<div class="time">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
										
										
										//슬라이드 효과 변경시, 화면분할 변경시 -> 스타일 변경
										$.each(_styleData, function(){
											if(this.THUMBNAIL == $('.select.ac').parent('.style-item').data('no') && this.DIVISION == _thisLayer.find('select[name=division]').val()){
												_style = this;
											}
										});
										
										var _popBinso = $('<div class="binso-wrap '+_imgDivide+' swiper-slide" style="padding:'+(_thisLayer.find('input[name=bottomText]').val() ? '26px 0px;' : '48px 0px 4px;')+'"></div>');
										_popBinso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_'+_imgDivide+'_'+(_thisLayer.find('input[name=bottomText]').val() ? 'bottom' : 'top')+'_black_'+(_style.THUMBNAIL ? _style.THUMBNAIL : $('.select.ac').parent('.style-item').data('no'))+'.png")');
										var _popBinsoBox = $('<div class="binso-box">');
										_popBinsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
										_popBinsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
										_popBinsoBox.append('<div class="arrow"></div>');
										_popBinsoBox.append('<div class="photo"></div>');
// 										_popBinsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
										_popBinsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
										_popBinsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
										_popBinsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
										_popBinsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
										_popBinsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
										_popBinsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
										_popBinsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
										_popBinso.append(_popBinsoBox);
										_popDiv.find('.previews-box').append(_popBinso);

										//바텀 생성
										if(_thisLayer.find('input[name=bottomText]').val())
											_popDiv.append('<div class="bottom" style="display: block;">'+_thisLayer.find('input[name=bottomText]').val()+'</div>');
										
										var _popBinsoClone = _popBinso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
										
										if(_thisLayer.find('select[name=division]').val() == 1){ // 팝업 1분할
											var i = 0; //행사수 증가
											$.each(_divBinsoArr, function(idx){
												$.each(_event, function(){
													if(_divBinsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
														if(i > 0){
															var _popClone = _popBinso.clone();
															_popDiv.find('.binso-wrap').last().after(_popClone);
															_popClone.find('.status').text(this.APPELLATION);
															_popClone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
															if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _popClone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_popClone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
															_popClone.find('.chief-mourner').data(this);

															_popClone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
															_popClone.find('.carrying-start-time').text(this.CARRYING_DT);
															_popClone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
														}else{
															_popBinso.find('.status').text(this.APPELLATION);
															_popBinso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
															if(this.ARROW_NO != 0 && this.ARROW_NO) _popBinso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _popBinso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_popBinso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
															_popBinso.find('.chief-mourner').data(this);
															
															_popBinso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
															_popBinso.find('.carrying-start-time').text(this.CARRYING_DT);
															_popBinso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
														}
														i++;
													}
												});
											});
										}else if(_thisLayer.find('select[name=division]').val() == 2){ //팝업 2분할

											//빈소 정보 입력 + 빈소생성
											var i = 0;
											$.each(_divBinsoArr, function(idx){
												$.each(_event, function(){
													if(_divBinsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
														if(i == 0){ // 처음 빈소 정보 입력
															_popBinso.find('.status').text(this.APPELLATION);
															_popBinso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
															if(this.ARROW_NO != 0 && this.ARROW_NO) _popBinso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _popBinso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_popBinso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
															_popBinso.find('.chief-mourner').data(this);
															
															_popBinso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
															_popBinso.find('.carrying-start-time').text(this.CARRYING_DT);
															_popBinso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
														}else if(i > 0 && i < 2){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
															var _popClone = _popBinsoBox.clone();
															_popDiv.find('.binso-wrap .binso-box').last().after(_popClone);
															_popClone.find('.status').text(this.APPELLATION);
															_popClone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
															if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _popClone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_popClone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
															_popClone.find('.chief-mourner').data(this);
															
															_popClone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
															_popClone.find('.carrying-start-time').text(this.CARRYING_DT);
															_popClone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
														}else if(i > 1){
															if(i%2 == 0){
																var _popClone = _popBinsoClone.clone();
																_popDiv.find('.binso-wrap').last().after(_popClone);
																_popClone.find('.binso-box').find('.status').text(this.APPELLATION);
																_popClone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _popClone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_popClone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_popClone.find('.chief-mourner').data(this);
																
																_popClone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_popClone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																_popClone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else{
																var _popClone = _popBinsoBox.clone();
																_popDiv.find('.binso-wrap .binso-box').last().after(_popClone);
																_popClone.find('.status').text(this.APPELLATION);
																_popClone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _popClone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_popClone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_popClone.find('.chief-mourner').data(this);
																
																_popClone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_popClone.find('.carrying-start-time').text(this.CARRYING_DT);
																_popClone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}
														}
														i++;
													}
 												});
											});
											
											if(i % 2 != 0){ //분할이미지 표현
												var _divideImg = $('<div class="divide-box divide02-box" style="bottom:29px;">');
												var _chk = false;
												$.each(tableData.divideImg, function(){ 
													if(this.DIVIDE == 'divide02'){
														_chk = true;
														_divideImg.data(this);
													}
												});
												
												if(_chk){
													_popDiv.find('.previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
												}else{
													_popDiv.find('.previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_two.png)");
												}
											}

										}else if(_thisLayer.find('select[name=division]').val() == 4){ //팝업 4분할

											var i = 0;
											$.each(_divBinsoArr, function(idx){
												$.each(_event, function(){
													if(_divBinsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
														if(i == 0){ // 처음 빈소 정보 입력
															_popBinso.find('.status').text(this.APPELLATION);
															_popBinso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
															if(this.ARROW_NO != 0 && this.ARROW_NO) _popBinso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _popBinso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_popBinso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
															_popBinso.find('.chief-mourner').data(this);
															
															_popBinso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
															_popBinso.find('.carrying-start-time').text(this.CARRYING_DT);
															_popBinso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
														}else if(i > 0 && i < 4){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
															var _popClone = _popBinsoBox.clone();
															_popDiv.find('.binso-wrap .binso-box').last().after(_popClone);
															_popClone.find('.status').text(this.APPELLATION);
															_popClone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
															if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _popClone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_popClone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
															_popClone.find('.chief-mourner').data(this);
															
															_popClone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
															_popClone.find('.carrying-start-time').text(this.CARRYING_DT);
															_popClone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
														}else if(i > 3){
															if(i%4 == 0){
																var _popClone = _popBinsoClone.clone();
																_popDiv.find('.binso-wrap').last().after(_popClone);
																_popClone.find('.binso-box').find('.status').text(this.APPELLATION);
																_popClone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _popClone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_popClone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_popClone.find('.binso-box').find('.chief-mourner').data(this);
																
																_popClone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_popClone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																_popClone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else{
																var _popClone = _popBinsoBox.clone();
																_popDiv.find('.binso-wrap').last().find('.binso-box').last().after(_popClone);
																_popClone.find('.status').text(this.APPELLATION);
																_popClone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _popClone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_popClone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_popClone.find('.chief-mourner').data(this);
																
																_popClone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_popClone.find('.carrying-start-time').text(this.CARRYING_DT);
																_popClone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}
														}
														i++;
													}
 												});
											});
											
											if(i % 4 != 0){ //분할이미지 표현
												var _chk = false;
												var _divideImg = $('<div class="divide-box divide04-box" style="bottom:29px;">');
												$.each(tableData.divideImg, function(){ 
													if(this.DIVIDE == 'divide04'){
														_chk = true;
														_divideImg.data(this);
													}
												});
												if(_chk){
													_popDiv.find('.previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
												}else{
													_popDiv.find('.previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_four.png)");
												}
											}
										}else if(_thisLayer.find('select[name=division]').val() == 6){ //팝업 6분할
											//빈소 정보 입력 + 빈소생성
											var i = 0;
											$.each(_divBinsoArr, function(idx){
												$.each(_event, function(){
													if(_divBinsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
														if(i == 0){ // 처음 빈소 정보 입력
															_popBinso.find('.status').text(this.APPELLATION);
															_popBinso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
															if(this.ARROW_NO != 0 && this.ARROW_NO) _popBinso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _popBinso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_popBinso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
															_popBinso.find('.chief-mourner').data(this);
															
															_popBinso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
															_popBinso.find('.carrying-start-time').text(this.CARRYING_DT);
															_popBinso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
														}else if(i > 0 && i < 6){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
															var _popClone = _popBinsoBox.clone();
															_popDiv.find('.binso-wrap .binso-box').last().after(_popClone);
															_popClone.find('.status').text(this.APPELLATION);
															_popClone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
															if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _popClone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_popClone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
															_popBinso.find('.chief-mourner').data(this);
															
															_popClone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
															_popClone.find('.carrying-start-time').text(this.CARRYING_DT);
															_popClone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
														}else if(i > 5){
															if(i%6 == 0){
																var _popClone = _popBinsoClone.clone();
																_popDiv.find('.binso-wrap').last().after(_popClone);
																_popClone.find('.binso-box').find('.status').text(this.APPELLATION);
																_popClone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _popClone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_popClone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_popClone.find('.binso-box').find('.chief-mourner').data(this);
																
																_popClone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_popClone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																_popClone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else{
																var _popClone = _popBinsoBox.clone();
																_popDiv.find('.binso-wrap').last().find('.binso-box').last().after(_popClone);
																_popClone.find('.status').text(this.APPELLATION);
																_popClone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _popClone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_popClone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_popClone.find('.chief-mourner').data(this);
																
																_popClone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_popClone.find('.carrying-start-time').text(this.CARRYING_DT);
																_popClone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}
														}
														i++;
													}
 												});
											});
											
											if(i % 6 != 0){ //분할이미지 표현
												var _chk = false;
												var _divideImg = $('<div class="divide-box divide06-box" style="bottom:29px;">');
												$.each(tableData.divideImg, function(){ 
													if(this.DIVIDE == 'divide06'){
														_chk = true;
														_divideImg.data(this);
													}
												});
												if(_chk){
													_popDiv.find('.previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
												}else{
													_popDiv.find('.previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_six.png)");
												}
											}
										}else{ //팝업 8분할
											//빈소 정보 입력 + 빈소생성
											var i = 0;
											$.each(_divBinsoArr, function(idx){
												$.each(_event, function(){
													if(_divBinsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
														if(i == 0){ // 처음 빈소 정보 입력
															_popBinso.find('.status').text(this.APPELLATION);
															_popBinso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
															if(this.ARROW_NO != 0 && this.ARROW_NO) _popBinso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _popBinso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_popBinso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
															_popBinso.find('.chief-mourner').data(this);
															
															_popBinso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
															_popBinso.find('.carrying-start-time').text(this.CARRYING_DT);
															_popBinso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
														}else if(i > 0 && i < 8){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
															var _popClone = _popBinsoBox.clone();
															_popDiv.find('.binso-wrap .binso-box').last().after(_popClone);
															_popClone.find('.status').text(this.APPELLATION);
															_popClone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
															if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _popClone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_popClone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
															_popClone.find('.chief-mourner').data(this);
															
															_popClone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
															_popClone.find('.carrying-start-time').text(this.CARRYING_DT);
															_popClone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
														}else if(i > 7){
															if(i%8 == 0){
																var _popClone = _popBinsoClone.clone();
																_popDiv.find('.binso-wrap').last().after(_popClone);
																_popClone.find('.binso-box').find('.status').text(this.APPELLATION);
																_popClone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _popClone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_popClone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_popClone.find('.binso-box').find('.chief-mourner').data(this);
																
																_popClone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_popClone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																_popClone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else{
																var _popClone = _popBinsoBox.clone();
																_popDiv.find('.binso-wrap').last().find('.binso-box').last().after(_popClone);
																_popClone.find('.status').text(this.APPELLATION);
																_popClone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _popClone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _popClone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_popClone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_popClone.find('.chief-mourner').data(this);
																
																_popClone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_popClone.find('.carrying-start-time').text(this.CARRYING_DT);
																_popClone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}
														}
														i++;
													}
 												});
											});
											
											if(i % 8 != 0){ //분할이미지 표현
												var _chk = false;
												var _divideImg = $('<div class="divide-box divide08-box" style="bottom:29px;">');
												$.each(tableData.divideImg, function(){ 
													if(this.DIVIDE == 'divide08'){
														_chk = true;
														_divideImg.data(this);
													}
												});
												if(_chk){
													_popDiv.find('.previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
												}else{
													_popDiv.find('.previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_eight.png)");
												}
											}
										} // 8팝업 8분할 끝
										
										
									} // 행사수 있을때 끝
									_thisLayer.find('.status-plate-previews').append(_popDiv);
									
									//분할모드, 멀티모드
									if(_thisLayer.find('input[name=divisionMode]:checked').val() == 1)
										_thisLayer.find('.previews').hide();
										
									if(_thisLayer.find('input[name=multiMode]:checked').val() == 1)
										_thisLayer.find('.previews').hide();
										
									//바텀 텍스트 변경
									if(_thisLayer.find('input[name=bottomText]').val()){
										_thisLayer.find('.previews .bottom').text(_div.data('BOTTOM_TEXT') ? _div.data('BOTTOM_TEXT') : '');
										_thisLayer.find('.previews .title-box').css('height', '27px').css('font-size', '18px');
										_thisLayer.find('.previews .divide-box').css('bottom', '25px');
									}else{
										_thisLayer.find('.previews .title-box').css('height', '50px').css('font-size', '24px');
										_thisLayer.find('.previews .divide-box').css('bottom', '3px');
									}
									
									// 화살표 노출 변경
									if(_thisLayer.find('input[name=arrowFlag]:checked').val() == 1) _thisLayer.find('.previews .previews-box').find('.arrow').show();
									else _thisLayer.find('.previews .previews-box').find('.arrow').hide();
									
									_thisLayer.find('.previews .previews-box').css('font-family', _thisLayer.find('select[name=fontType]').val());
									
									
								};_fnDivide(); //_fnDivide() 함수 끝
								
								
								//멀티모드, 분할모드 변경시 유가족 호실 수정
								_layer02.find('input[name=multiMode], input[name=divisionMode]').on('change', function() {
									if($(this).val() == 2){
										//fnbinsoFamily
										$.each(_thisLayer.find('.chief-mourner'), function(){
											$(this).fnBinsoFamily($(this).data('EVENT_NO'), tableData.family);
										});
										// 호실 font-size 
										$.each(_thisLayer.find('.statusRoot'), function(){
											setBinso($(this));
										});
									}
								});
								
								//스타일 선택 부분
								_thisLayer.find('.previews').css('font-family', _div.data('FONT_TYPE'));
								_thisLayer.find('select[name=division]').val(_div.data('DIVISION') ? _div.data('DIVISION') : '1');
								_thisLayer.find('.screen-allboard-wrap .style-item[data-no='+(_div.data('STATUS_PLATE_STYLE_NO') ? _div.data('STATUS_PLATE_STYLE_NO') : '42')+']').click();

								
								// 폰트 변경
								_thisLayer.find('select[name=fontType]').val(_div.data('FONT_TYPE'));
								_thisLayer.find('select[name=fontType]').on('change', function(){
									_thisLayer.find('.previews .previews-box').css('font-family', $(this).val());
								});
								
								// 화살표 노출 변경
								_thisLayer.find('input[name=arrowFlag]').on('change', function(){
									if($(this).val() == 0) _thisLayer.find('.previews .previews-box').find('.arrow').hide();
									else _thisLayer.find('.previews .previews-box').find('.arrow').show();
								});
								

								// 바텀 텍스트 변경
								_thisLayer.find('input[name=bottomText]').on('keyup', function(){
									if($(this).val().length > 0){
										_thisLayer.find('.previews .previews-box .binso-wrap').css('background-image', _thisLayer.find('.previews .previews-box .binso-wrap').css('background-image').replace('top', 'bottom')).css('padding', '26px 0px 26px');
										_thisLayer.find('.previews .title-box').css('height', '26px').css('font-size', '18px');
										if(_thisLayer.find('.previews .bottom').length > 0){
											_thisLayer.find('.previews .bottom').text($(this).val()).show();
										}else{
											_thisLayer.find('.previews').append('<div class="bottom"></div>');
											_thisLayer.find('.previews .bottom').text($(this).val()).show();
										}
										_thisLayer.find('.previews').find('.previews-box').find('.divide-box').css('bottom', '25px');
									}else{
										_thisLayer.find('.previews .previews-box .binso-wrap').css('background-image', _thisLayer.find('.previews .previews-box .binso-wrap').css('background-image').replace('bottom', 'top')).css('padding', '48px 0px 4px');
										_thisLayer.find('.previews .title-box').css('height', '50px').css('font-size', '25px');
										_thisLayer.find('.previews .bottom').text("").hide();
										_thisLayer.find('.previews').find('.previews-box').find('.divide-box').css('bottom', '3px');
									}
								});

								//분할모드, 멀티모드
								_layer02.find('input[name=divisionMode][value='+_div.data('DIVISION_MODE')+']').click();
								_layer02.find('input[name=multiMode][value='+_div.data('MULTI_MODE')+']').click();
								if(_div.data('MULTI_MODE') == 2) 
									$('select[name=multiName]').attr("disabled", true);
								
								// 슬라이드 효과 변경
								_thisLayer.find('input[name=slideEffect]').off().on('change', function(){
									_fnDivide();
									init($(this).val(), _thisLayer.find('select[name=slideSec]').val());
								});
								
								// 슬라이드 화면 간격
								_thisLayer.find('select[name=slideSec]').off().on('change', function(){
									_fnDivide();
									init(_thisLayer.find('input[name=slideEffect]:checked').val(), $(this).val());
								});
								
								// 화면분할 변경
								_layer02.find('select[name=division]').off().on('change', function() {
									var _selected = $('.screen-allboard-wrap > .style-item > .select.ac');
									if(_selected.length) _selected.parent('.style-item').trigger('click');
									_fnDivide();
									init(_thisLayer.find('input[name=slideEffect]:checked').val(), _thisLayer.find('select[name=slideSec]').val());
								});

								//빈소 리스트 체크
								if(_div.data('BINSO_LIST')) {
									$.each(_div.data('BINSO_LIST').split(','), function(idx, _value) {
										$('input[name=binsoCheck][value="'+_value+'"]').parent('.pb-checkbox-label').trigger('click');
									});
								}
								
								// 빈소명 체크 변경
								_layer02.find('input[name=binsoCheck]').off().on('change', function(){
									_divBinsoArr = [];
									$.each(_layer02.find('input[name=binsoCheck]'), function(idx, _value){
										if($(this).is(':checked'))
											_divBinsoArr.push($(this).val());
									});
									_fnDivide();
									init(_thisLayer.find('input[name=slideEffect]:checked').val(), _thisLayer.find('select[name=slideSec]').val());
								});
								
								//빈소명 올체크 변경
								_layer02.find('input[name=binsoAllCheck]').off().on('change', function(){
									_layer02.find('input[name=binsoCheck]').parent('label').click();
									_divBinsoArr = [];
									$.each(_layer02.find('input[name=binsoCheck]'), function(idx, _value){
										if($(this).is(':checked'))
											_divBinsoArr.push($(this).val());
									});
									_fnDivide();
									init(_thisLayer.find('input[name=slideEffect]:checked').val(), _thisLayer.find('select[name=slideSec]').val());
								});
								
								//바텀텍스트 적용
								_layer02.find('.bottom').text(_thisLayer.find('input[name=bottomText]').val());

								
								//fnbinsoFamily
								$.each(_thisLayer.find('.chief-mourner'), function(){
									$(this).fnBinsoFamily($(this).data('EVENT_NO'), tableData.family);
								});
								// 호실 font-size 
								$.each(_thisLayer.find('.statusRoot'), function(){
									setBinso($(this));
								});
								
								
							});
							
							function init(_slide, _delay){
								if(swiper != null) swiper.destroy(true, true);
								$.each($('.pb-right-popup-wrap .previews .chief-mourner'), function(){
									$(this).fnBinsoFamily($(this).data('EVENT_NO'), tableData.family);	
								});
								
								// 호실 font-size
								$.each($('.pb-right-popup-wrap .previews .statusRoot'), function(){
									setBinso($(this));
								});
								
								// 슬라이드 부분 - loop시 3개까지 복제 되서 length > 1 이상만 슬라이드 되게 함.
								if(_layer02.find('.status-plate-previews .previews .previews-box .binso-wrap').length > 1){
									if(_slide == 1){
										var swiper = new Swiper(".popup"+_div.data('RASPBERRY_CONNECTION_NO'),{
											effect : "slide",
											speed : 300,
											centeredSlides: true,
										      	autoplay: {
										      		disableOnInteraction : false, //마우스 클릭해도 슬라이드 재생
										        	delay: _delay*1000
										      	},
											loop: true
										});	
									}else{
										var swiper = new Swiper(".popup"+_div.data('RASPBERRY_CONNECTION_NO'),{
											effect : "fade",
											speed : 10,
											centeredSlides: true,
										      	autoplay: {
										      		disableOnInteraction : false, //마우스 클릭해도 슬라이드 재생
										        	delay: _delay*1000
										      	},
											loop: true
										});	 
									}
								}
							}
							init(_div.data('SLIDE_EFFECT'), _div.data('SLIDE_SEC'));
						});//팝업창 끝

						
						if(this.STATUS_PLATE_STYLE_NO){ //스타일이 있는 경우 - 화면관리에서 한번이라도 수정이 됨
							if(this.MULTI_MODE == 1){ //멀티모드 1(켜기)

								var _multi = []; // 먼저 같은 멀티모드 끼리 배열에 저장
								$.each(tableData.list, function(){
									if(_this.MULTI_NAME == this.MULTI_NAME){
										var _list = { 
											raspNo : this.RASPBERRY_CONNECTION_NO, 
											exposure : this.EXPOSURE
										};
										_multi.push(_list);
									}
								});
								
								// 노출순서 낮은거, 같으면 먼저 생성된 raspNo 가져오기
								var raspNo = _this.RASPBERRY_CONNECTION_NO;
								var exposure = _this.EXPOSURE;
								$.each(_multi, function(){
									if(raspNo != this.raspNo){
										if(exposure > this.exposure){
											raspNo = this.raspNo;
											exposure = this.exposure;
										}
										else if(exposure == this.exposure){
											if(raspNo > this.raspNo){
												raspNo = this.raspNo;
												exposure = this.exposure;
											}
										}
									}
								});
								
								var _30 = ""; // _30이 스타일정할 빈소
								$.each(tableData.list, function(){
									if(raspNo == this.RASPBERRY_CONNECTION_NO) _30 = this; 
								});
								
								if(_30.BINSO_LIST){
									var _binsoArr = _30.BINSO_LIST.split(',');

									//행사 개수 세기
									var _event = []; var _cnt = 0;
									$.each(_binsoArr, function(idx){
										var _chk = false;
										$.each(tableData.event, function(){
											if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
												_cnt++;
												_event.push(this);
												_chk = true;
												if(_chk) return false; // break
											}
										});
									});
									
									if(_cnt == 0){ // 행사수 없을때 모두 대기화면 보여줌
										_div.find('.title-box').hide();
										
										if(tableData.waitInfo[0]){
											if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
												_div.find('.previews-box').html("").css('background', '#000');
											}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
												$.each(tableData.waitInfo, function(){
													var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
													_binso.css('background-image', 'url('+this.FILE+')');
													_div.find('.previews-box').append(_binso);
												});
											}else{ //대기화면 동영상
												_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
											}
										}else{
											_div.find('.previews-box').html("").css('background', '#000');
										}
									}else{ //행사수 있을때
										
										
										//멀티개수 새서 배열생성 2차원배열로 생성
										var arr = new Array();
										$.each(_multi, function(idx){
											var arr_sub = new Array();
											arr.push(arr_sub);
										});

										//멀티에 들어가는 행사 갯수 새기, 배열에 종합넘버 넣기
										$.each(_event, function(idx){
											arr[idx%_multi.length].push(_multi[idx%_multi.length]);
										});
										
										//2차원배열 1차원으로 만들기 = 멀티모드 행사 순차적으로 넣기
										var _tmp = [];
										$.each(arr, function(idx, value){
											$.each(value, function(){
												_tmp.push(this);
											});
										});
										
										var _division = "";
										$.each(_tmp, function(idx){
											if(this.raspNo == _30.RASPBERRY_CONNECTION_NO){
												_division++;
											}
										});
										
										//스타일 정하기 , 멀티모드로 저장시 스타일 한번이라도 저장되어서 스타일 없을 수가 없음.
										$.each(_styleData, function(){
											if(this.THUMBNAIL == _30.STATUS_PLATE_STYLE_NO){
												if(_division == 1){
													if(this.DIVISION == 1){
														_style = this;
														_imgDivide = "one";
													}
												}else if(_division == 2){
													if(this.DIVISION == 2){
														_style = this;
														_imgDivide = "two";
													}
												}else if(_division == 3 || _division == 4){
													if(this.DIVISION == 4){
														_style = this;
														_imgDivide = "four";
													}
												}else if(_division == 5 || _division == 6){
													if(this.DIVISION == 6){
														_style = this;
														_imgDivide = "six";
													}
												}else if(_division > 6){
													if(this.DIVISION == 8){
														_style = this;
														_imgDivide = "eight";
													}
												}
											}
										});
										
										var _imgDivide = 'one';	// 초기값은 1분할 //
										_style.DIVISION = 1
										if(_tmp.length/arr.length <= 1) {
											_imgDivide = 'one';
											_style.DIVISION = 1;
										}else if(_tmp.length/arr.length <= 2) {
											_imgDivide = 'two';
											_style.DIVISION = 2;
										}else if(_tmp.length/arr.length <= 4) {
											_imgDivide = 'four';
											_style.DIVISION = 4;
										}else if(_tmp.length/arr.length <= 6) {
											_imgDivide = 'six';
											_style.DIVISION = 6;
										}else if(_tmp.length/arr.length <= 8) {
											_imgDivide = 'eight';
											_style.DIVISION = 8;
										}
										
										if(_30.BOTTOM_TEXT){
											//탑생성
											_div.find('.previews').append('<div class="title-box" style="height:30px">'); 
											_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
											_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
											_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
											
											var _binso = $('<div class="binso-wrap '+_imgDivide+' swiper-slide" style="padding:30px 0px;"></div>');
											_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_'+_imgDivide+'_bottom_black_'+_style.THUMBNAIL+'.png")');
											var _binsoBox = $('<div class="binso-box">');
// 											_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
											_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
											_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
											_binsoBox.append('<div class="arrow"></div>');
											_binsoBox.append('<div class="photo"></div>');
											_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
											
											_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
											_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
											_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
											_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
											_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
											_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
											_binso.append(_binsoBox);
											_div.find('.previews-box').append(_binso);

											//바텀 생성
											_div.find('.previews').append('<div class="bottom">'+(_30.BOTTOM_TEXT ? _30.BOTTOM_TEXT : "")+'</div>');
											
											var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
											
								

											//_style.DIVISION으로 분할한건 아무 의미 없음
											if(_style.DIVISION == 1){ // 1분할
// 												var i = 0; //행사수 증가
// 												var j = 0; // 종합에 행사 넣어주기 위한 cnt
// 												$.each(_binsoArr, function(idx){
// 													$.each(_event, function(){
// 														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
// 															// j%_multi.length = 멀티 개수로 나누기 했을때 순차적으로 종합에 넣기
// 															if(_multi[j%_multi.length].raspNo == _this.RASPBERRY_CONNECTION_NO){
// 																_binso.find('.status').text(this.APPELLATION);
// 																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																_binso.find('.chief-mourner').data(this);
// 																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
// 																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																i++;
// 															}
// 															j++;
// 														}
// 													});
// 												});
												
												var _this = this; //행사 데이터 저장
												$.each(_tmp, function(idx){
													if(this.raspNo == _this.RASPBERRY_CONNECTION_NO){
														_binso.find('.status').text(_event[idx].APPELLATION);
														_binso.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
														if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
														else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
														_binso.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
														_binso.find('.chief-mourner').data(_event[idx]);
														_binso.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
														_binso.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
														_binso.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
													}
												});
												
												
												//1분할일 경우는 빈소명 없을시 행사가 없다고 판단.
												if(_div.find('.previews-box .binso-wrap').last().find('.binso-box .status').text() == ""){
													_div.find('.title-box').hide();
													if(tableData.waitInfo[0]){
														if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
															_div.find('.previews-box').html("").css('background', '#000');
														}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
															$.each(tableData.waitInfo, function(){
																var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
																_binso.css('background-image', 'url('+this.FILE+')');
																_div.find('.previews-box').append(_binso);
															});
														}else{ //대기화면 동영상
															_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
														}
													}else{
														_div.find('.previews-box').html("").css('background', '#000');
													}
												}
											}else if(_style.DIVISION == 2){ // 2분할
												
// 												var i = 0; //행사수 증가
// 												var j = 0; // 종합에 행사 넣어주기 위한 cnt
// 												$.each(_binsoArr, function(idx){
// 													$.each(_event, function(){
// 														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
// 															// j%_multi.length = 멀티 개수로 나누기 했을때 순차적으로 종합에 넣기
// 															if(_multi[j%_multi.length].raspNo == _this.RASPBERRY_CONNECTION_NO){
// 																if(i == 0){ // 처음 빈소 정보 입력
// 																	_binso.find('.status').text(this.APPELLATION);
// 																	_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_binso.find('.chief-mourner').data(this);
// 																	_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_binso.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 0 && i < 2){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
// 																	var _clone = _binsoBox.clone();
// 																	_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
// 																	_clone.find('.status').text(this.APPELLATION);
// 																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_clone.find('.chief-mourner').data(this);
// 																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}
// 																i++;
// 															}
// 															j++;
// 														}
// 													});
// 												});
												
												var i = 0; //행사수 증가
												var _this = this; //행사 데이터 저장
												$.each(_tmp, function(idx){
													if(this.raspNo == _this.RASPBERRY_CONNECTION_NO){
														if(i == 0){ // 처음 빈소 정보 입력
															_binso.find('.status').text(_event[idx].APPELLATION);
															_binso.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_binso.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_binso.find('.chief-mourner').data(_event[idx]);
															_binso.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_binso.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_binso.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 0 && i < 2){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
															var _clone = _binsoBox.clone();
															_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
															_clone.find('.status').text(_event[idx].APPELLATION);
															_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_clone.find('.chief-mourner').data(_event[idx]);
															_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}
														i++;
													}
												});
												
												
												// 분할 이미지 표현
												if(_div.find('.previews-box .binso-wrap').last().find('.binso-box').length < _style.DIVISION){
													var _chk = false;
													var _divideImg = $('<div class="divide0'+_style.DIVISION+'-box" style="bottom:29px;">');
													$.each(tableData.divideImg, function(){ 
														if(this.DIVIDE == 'divide0'+_style.DIVISION){
															_chk = true;
															_divideImg.data(this);
														}
													});
													if(_chk){
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
													}else{
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_"+_imgDivide+".png)");
													}
												}
											}else if(_style.DIVISION == 4){ // 4분할
// 												var i = 0; //행사수 증가
// 												var j = 0; // 종합에 행사 넣어주기 위한 cnt
// 												$.each(_binsoArr, function(idx){
// 													$.each(_event, function(){
// 														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
// 															// j%_multi.length = 멀티 개수로 나누기 했을때 순차적으로 종합에 넣기
// 															if(_multi[j%_multi.length].raspNo == _this.RASPBERRY_CONNECTION_NO){
// 																if(i == 0){ // 처음 빈소 정보 입력
// 																	_binso.find('.status').text(this.APPELLATION);
// 																	_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_binso.find('.chief-mourner').data(this);
// 																	_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_binso.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 0 && i < 4){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
// 																	var _clone = _binsoBox.clone();
// 																	_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
// 																	_clone.find('.status').text(this.APPELLATION);
// 																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_clone.find('.chief-mourner').data(this);
// 																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 3){
// 																	if(i%4 == 0){
// 																		var _clone = _binsoClone.clone();
// 																		_div.find('.previews .binso-wrap').last().after(_clone);
// 																		_clone.find('.binso-box').find('.status').text(this.APPELLATION);
// 																		_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																		if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																		else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																		_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																		_clone.find('.chief-mourner').data(this);
// 																		_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																		_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
// 																		_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																	}else{
// 																		var _clone = _binsoBox.clone();
// 																		_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
// 																		_clone.find('.status').text(this.APPELLATION);
// 																		_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																		if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																		else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																		_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																		_clone.find('.chief-mourner').data(this);
// 																		_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																		_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																		_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																	}
// 																}
// 																i++;
// 															}
// 															j++;
// 														}
// 													});
// 												});
												

												var i = 0; //행사수 증가
												var _this = this; //행사 데이터 저장
												$.each(_tmp, function(idx){
													if(this.raspNo == _this.RASPBERRY_CONNECTION_NO){
														if(i == 0){ // 처음 빈소 정보 입력
															_binso.find('.status').text(_event[idx].APPELLATION);
															_binso.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_binso.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_binso.find('.chief-mourner').data(_event[idx]);
															_binso.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_binso.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_binso.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 0 && i < 4){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
															var _clone = _binsoBox.clone();
															_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
															_clone.find('.status').text(_event[idx].APPELLATION);
															_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_clone.find('.chief-mourner').data(_event[idx]);
															_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 3){
															if(i%4 == 0){
																var _clone = _binsoClone.clone();
																_div.find('.previews .binso-wrap').last().after(_clone);
																_clone.find('.binso-box').find('.status').text(_event[idx].APPELLATION);
																_clone.find('.binso-box').find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
																if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(_event[idx]);
																_clone.find('.binso-box').find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.binso-box').find('.carrying-start-time').text(_event[idx].CARRYING_DT);
																_clone.find('.binso-box').find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
															}else{
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																_clone.find('.status').text(_event[idx].APPELLATION);
																_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
																if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(_event[idx]);
																_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
																_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
															}
														}
														i++;

													}
												});
												
												// 분할 이미지 표현
												if(_div.find('.previews-box .binso-wrap').last().find('.binso-box').length < _style.DIVISION){
													var _chk = false;
													var _divideImg = $('<div class="divide0'+_style.DIVISION+'-box" style="bottom:29px;">');
													$.each(tableData.divideImg, function(){ 
														if(this.DIVIDE == 'divide0'+_style.DIVISION){
															_chk = true;
															_divideImg.data(this);
														}
													});
													if(_chk){
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
													}else{
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_"+_imgDivide+".png)");
													}
												}
											}else if(_style.DIVISION == 6){ // 6분할
// 												var i = 0; //행사수 증가
// 												var j = 0; // 종합에 행사 넣어주기 위한 cnt
// 												$.each(_binsoArr, function(idx){
// 													$.each(_event, function(){
// 														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
// 															// j%_multi.length = 멀티 개수로 나누기 했을때 순차적으로 종합에 넣기
// 															if(_multi[j%_multi.length].raspNo == _this.RASPBERRY_CONNECTION_NO){
// 																if(i == 0){ // 처음 빈소 정보 입력
// 																	_binso.find('.status').text(this.APPELLATION);
// 																	_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_binso.find('.chief-mourner').data(this);
// 																	_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_binso.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 0 && i < 6){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
// 																	var _clone = _binsoBox.clone();
// 																	_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
// 																	_clone.find('.status').text(this.APPELLATION);
// 																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_clone.find('.chief-mourner').data(this);
// 																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 5){
// 																	if(i%6 == 0){
// 																		var _clone = _binsoClone.clone();
// 																		_div.find('.previews .binso-wrap').last().after(_clone);
// 																		_clone.find('.binso-box').find('.status').text(this.APPELLATION);
// 																		_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																		if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																		else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																		_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																		_clone.find('.binso-box').find('.chief-mourner').data(this);
// 																		_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																		_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
// 																		_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																	}else{
// 																		var _clone = _binsoBox.clone();
// 																		_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
// 																		_clone.find('.status').text(this.APPELLATION);
// 																		_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																		if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																		else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																		_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																		_clone.find('.chief-mourner').data(this);
// 																		_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																		_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																		_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																	}
// 																}
// 																i++;
// 															}
// 															j++;
// 														}
// 													});
// 												});
												
												
												var i = 0; //행사수 증가
												var _this = this; //행사 데이터 저장
												$.each(_tmp, function(idx){
													if(this.raspNo == _this.RASPBERRY_CONNECTION_NO){
														if(i == 0){ // 처음 빈소 정보 입력
															_binso.find('.status').text(_event[idx].APPELLATION);
															_binso.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_binso.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_binso.find('.chief-mourner').data(_event[idx]);
															_binso.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_binso.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_binso.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 0 && i < 6){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
															var _clone = _binsoBox.clone();
															_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
															_clone.find('.status').text(_event[idx].APPELLATION);
															_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(this.ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_clone.find('.chief-mourner').data(_event[idx]);
															_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 5){
															if(i%6 == 0){
																var _clone = _binsoClone.clone();
																_div.find('.previews .binso-wrap').last().after(_clone);
																_clone.find('.binso-box').find('.status').text(_event[idx].APPELLATION);
																_clone.find('.binso-box').find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
																if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
																_clone.find('.binso-box').find('.chief-mourner').data(_event[idx]);
																_clone.find('.binso-box').find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.binso-box').find('.carrying-start-time').text(_event[idx].CARRYING_DT);
																_clone.find('.binso-box').find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
															}else{
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																_clone.find('.status').text(_event[idx].APPELLATION);
																_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
																if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(_event[idx]);
																_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
																_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
															}
														}
														i++;
													}
												});
												
												
												// 분할 이미지 표현
												if(_div.find('.previews-box .binso-wrap').last().find('.binso-box').length < _style.DIVISION){
													var _chk = false;
													var _divideImg = $('<div class="divide0'+_style.DIVISION+'-box" style="bottom:29px;">');
													$.each(tableData.divideImg, function(){ 
														if(this.DIVIDE == 'divide0'+_style.DIVISION){
															_chk = true;
															_divideImg.data(this);
														}
													});
													if(_chk){
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
													}else{
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_"+_imgDivide+".png)");
													}
												}
											}else if(_style.DIVISION == 8){ // 8분할
// 												var i = 0; //행사수 증가
// 												var j = 0; // 종합에 행사 넣어주기 위한 cnt
// 												$.each(_binsoArr, function(idx){
// 													$.each(_event, function(){
// 														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
// 															// j%_multi.length = 멀티 개수로 나누기 했을때 순차적으로 종합에 넣기
// 															if(_multi[j%_multi.length].raspNo == _this.RASPBERRY_CONNECTION_NO){
// 																if(i == 0){ // 처음 빈소 정보 입력
// 																	_binso.find('.status').text(this.APPELLATION);
// 																	_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_binso.find('.chief-mourner').data(this);
// 																	_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_binso.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 0 && i < 8){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
// 																	var _clone = _binsoBox.clone();
// 																	_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
// 																	_clone.find('.status').text(this.APPELLATION);
// 																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_clone.find('.chief-mourner').data(this);
// 																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 7){
// 																	if(i%8 == 0){
// 																		var _clone = _binsoClone.clone();
// 																		_div.find('.previews .binso-wrap').last().after(_clone);
// 																		_clone.find('.binso-box').find('.status').text(this.APPELLATION);
// 																		_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																		if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																		else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																		_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																		_clone.find('.binso-box').find('.chief-mourner').data(this);
// 																		_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																		_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
// 																		_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																	}else{
// 																		var _clone = _binsoBox.clone();
// 																		_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
// 																		_clone.find('.status').text(this.APPELLATION);
// 																		_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																		if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																		else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																		_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																		_clone.find('.chief-mourner').data(this);
// 																		_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																		_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																		_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																	}
// 																}
// 																i++;
// 															}
// 															j++;
// 														}
// 													});
// 												});

												
												var i = 0; //행사수 증가
												var _this = this; //행사 데이터 저장
												$.each(_tmp, function(idx){
													if(this.raspNo == _this.RASPBERRY_CONNECTION_NO){
														if(i == 0){ // 처음 빈소 정보 입력
															_binso.find('.status').text(_event[idx].APPELLATION);
															_binso.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_binso.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_binso.find('.chief-mourner').data(_event[idx]);
															_binso.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_binso.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_binso.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 0 && i < 8){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
															var _clone = _binsoBox.clone();
															_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
															_clone.find('.status').text(_event[idx].APPELLATION);
															_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_clone.find('.chief-mourner').data(_event[idx]);
															_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 7){
															if(i%8 == 0){
																var _clone = _binsoClone.clone();
																_div.find('.previews .binso-wrap').last().after(_clone);
																_clone.find('.binso-box').find('.status').text(_event[idx].APPELLATION);
																_clone.find('.binso-box').find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
																if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
																_clone.find('.binso-box').find('.chief-mourner').data(_event[idx]);
																_clone.find('.binso-box').find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.binso-box').find('.carrying-start-time').text(_event[idx].CARRYING_DT);
																_clone.find('.binso-box').find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
															}else{
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																_clone.find('.status').text(_event[idx].APPELLATION);
																_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
																if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(_event[idx]);
																_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
																_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
															}
														}
														i++;
													}
												});
												
													
												// 분할 이미지 표현
												if(_div.find('.previews-box .binso-wrap').last().find('.binso-box').length < _style.DIVISION){
													var _chk = false;
													var _divideImg = $('<div class="divide0'+_style.DIVISION+'-box" style="bottom:29px;">');
													$.each(tableData.divideImg, function(){ 
														if(this.DIVIDE == 'divide0'+_style.DIVISION){
															_chk = true;
															_divideImg.data(this);
														}
													});
													if(_chk){
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
													}else{
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_"+_imgDivide+".png)");
													}
												}
											}
										}else{ //멀티모드 바텀텍스트 없는경우 
											
											//탑생성
											_div.find('.previews').append('<div class="title-box" style="height:57px">'); 
											_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
											_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
											_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
											
											var _binso = $('<div class="binso-wrap '+_imgDivide+' swiper-slide" style="padding:56px 0px 4px;"></div>');
											_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_'+_imgDivide+'_top_black_'+_style.THUMBNAIL+'.png")');
											var _binsoBox = $('<div class="binso-box">');
// 											_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
											_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
											_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
											_binsoBox.append('<div class="arrow"></div>');
											_binsoBox.append('<div class="photo"></div>');
// 											_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
											_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
											
											_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
											_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
											_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
											_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
											_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
											_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
											_binso.append(_binsoBox);
											_div.find('.previews-box').append(_binso);
											
											//멀티개수 새서 배열생성 2차원배열로 생성
											var arr = new Array();
											$.each(_multi, function(idx){
												var arr_sub = new Array();
												arr.push(arr_sub);
											});

											//멀티에 들어가는 행사 갯수 새기, 배열에 종합넘버 넣기
											$.each(_event, function(idx){
												arr[idx%_multi.length].push(_multi[idx%_multi.length]);
											});
											
											//2차원배열 1차원으로 만들기 = 멀티모드 행사 순차적으로 넣기
											var _tmp = [];
											$.each(arr, function(idx, value){
												$.each(value, function(){
													_tmp.push(this);
												});
											});
											
											
											if(_style.DIVISION == 1){ // 1분할
// 												var i = 0; //행사수 증가
// 												var j = 0; // 종합에 행사 넣어주기 위한 cnt
// 												$.each(_binsoArr, function(idx){
// 													$.each(_event, function(){
// 														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
// 															// j%_multi.length = 멀티 개수로 나누기 했을때 순차적으로 종합에 넣기
// 															if(_multi[j%_multi.length].raspNo == _this.RASPBERRY_CONNECTION_NO){
// 																_binso.find('.status').text(this.APPELLATION);
// 																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																_binso.find('.chief-mourner').data(this);
// 																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
// 																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																i++;
// 															}
// 															j++;
// 														}
// 													});
// 												});
												
												var _this = this; //행사 데이터 저장
												$.each(_tmp, function(idx){
													if(this.raspNo == _this.RASPBERRY_CONNECTION_NO){
														_binso.find('.status').text(_event[idx].APPELLATION);
														_binso.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
														if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
														else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
														_binso.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
														_binso.find('.chief-mourner').data(_event[idx]);
														_binso.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
														_binso.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
														_binso.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
													}
												});
												
												
												//1분할일 경우는 빈소명 없을시 행사가 없다고 판단.
												if(_div.find('.previews-box .binso-wrap').last().find('.binso-box .status').text() == ""){
													_div.find('.title-box').hide();
													if(tableData.waitInfo[0]){
														if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
															_div.find('.previews-box').html("").css('background', '#000');
														}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
															$.each(tableData.waitInfo, function(){
																var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
																_binso.css('background-image', 'url('+this.FILE+')');
																_div.find('.previews-box').append(_binso);
															});
														}else{ //대기화면 동영상
															_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
														}
													}else{
														_div.find('.previews-box').html("").css('background', '#000');
													}
												}
											}else if(_style.DIVISION == 2){
// 												var i = 0; //행사수 증가
// 												var j = 0; // 종합에 행사 넣어주기 위한 cnt
// 												$.each(_binsoArr, function(idx){
// 													$.each(_event, function(){
// 														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
// 															// j%_multi.length = 멀티 개수로 나누기 했을때 순차적으로 종합에 넣기
// 															if(_multi[j%_multi.length].raspNo == _this.RASPBERRY_CONNECTION_NO){
// 																if(i == 0){ // 처음 빈소 정보 입력
// 																	_binso.find('.status').text(this.APPELLATION);
// 																	_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_binso.find('.chief-mourner').data(this);
// 																	_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_binso.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 0 && i < 2){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
// 																	var _clone = _binsoBox.clone();
// 																	_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
// 																	_clone.find('.status').text(this.APPELLATION);
// 																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_clone.find('.chief-mourner').data(this);
// 																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}
// 																i++;
// 															}
// 															j++;
// 														}
// 													});
// 												});
												
												var i = 0; //행사수 증가
												var _this = this; //행사 데이터 저장
												$.each(_tmp, function(idx){
													if(this.raspNo == _this.RASPBERRY_CONNECTION_NO){
														if(i == 0){ // 처음 빈소 정보 입력
															_binso.find('.status').text(_event[idx].APPELLATION);
															_binso.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_binso.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_binso.find('.chief-mourner').data(_event[idx]);
															_binso.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_binso.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_binso.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 0 && i < 2){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
															var _clone = _binsoBox.clone();
															_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
															_clone.find('.status').text(_event[idx].APPELLATION);
															_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_clone.find('.chief-mourner').data(_event[idx]);
															_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}
														i++;
													}
												});
												
												// 분할 이미지 표현
												if(_div.find('.previews-box .binso-wrap').last().find('.binso-box').length < _style.DIVISION){
													var _chk = false;
													var _divideImg = $('<div class="divide0'+_style.DIVISION+'-box" style="bottom:3px;">');
													$.each(tableData.divideImg, function(){ 
														if(this.DIVIDE == 'divide0'+_style.DIVISION){
															_chk = true;
															_divideImg.data(this);
														}
													});
													if(_chk){
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
													}else{
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_"+_imgDivide+".png)");
													}
												}
											}else if(_style.DIVISION == 4){
// 												var i = 0; //행사수 증가
// 												var j = 0; // 종합에 행사 넣어주기 위한 cnt
// 												$.each(_binsoArr, function(idx){
// 													$.each(_event, function(){
// 														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
// 															// j%_multi.length = 멀티 개수로 나누기 했을때 순차적으로 종합에 넣기
// 															if(_multi[j%_multi.length].raspNo == _this.RASPBERRY_CONNECTION_NO){
// 																if(i == 0){ // 처음 빈소 정보 입력
// 																	_binso.find('.status').text(this.APPELLATION);
// 																	_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_binso.find('.chief-mourner').data(this);
// 																	_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_binso.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 0 && i < 4){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
// 																	var _clone = _binsoBox.clone();
// 																	_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
// 																	_clone.find('.status').text(this.APPELLATION);
// 																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_clone.find('.chief-mourner').data(this);
// 																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 3){
// 																	if(i%4 == 0){
// 																		var _clone = _binsoClone.clone();
// 																		_div.find('.previews .binso-wrap').last().after(_clone);
// 																		_clone.find('.binso-box').find('.status').text(this.APPELLATION);
// 																		_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																		if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																		else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																		_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																		_clone.find('.binso-box').find('.chief-mourner').data(this);
// 																		_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																		_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
// 																		_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																	}else{
// 																		var _clone = _binsoBox.clone();
// 																		_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
// 																		_clone.find('.status').text(this.APPELLATION);
// 																		_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																		if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																		else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																		_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																		_clone.find('.chief-mourner').data(this);
// 																		_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																		_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																		_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																	}
// 																}
// 																i++;
// 															}
// 															j++;
// 														}
// 													});
// 												});
												
												var i = 0; //행사수 증가
												var _this = this; //행사 데이터 저장
												$.each(_tmp, function(idx){
													if(this.raspNo == _this.RASPBERRY_CONNECTION_NO){
														if(i == 0){ // 처음 빈소 정보 입력
															_binso.find('.status').text(_event[idx].APPELLATION);
															_binso.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_binso.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_binso.find('.chief-mourner').data(_event[idx]);
															_binso.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_binso.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_binso.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 0 && i < 4){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
															var _clone = _binsoBox.clone();
															_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
															_clone.find('.status').text(_event[idx].APPELLATION);
															_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_clone.find('.chief-mourner').data(_event[idx]);
															_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 3){
															if(i%4 == 0){
																var _clone = _binsoClone.clone();
																_div.find('.previews .binso-wrap').last().after(_clone);
																_clone.find('.binso-box').find('.status').text(_event[idx].APPELLATION);
																_clone.find('.binso-box').find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
																if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(_event[idx]);
																_clone.find('.binso-box').find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.binso-box').find('.carrying-start-time').text(_event[idx].CARRYING_DT);
																_clone.find('.binso-box').find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
															}else{
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																_clone.find('.status').text(_event[idx].APPELLATION);
																_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
																if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(_event[idx]);
																_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
																_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
															}
														}
														i++;
													}
												});
												
												// 분할 이미지 표현
												if(_div.find('.previews-box .binso-wrap').last().find('.binso-box').length < _style.DIVISION){
													var _chk = false;
													var _divideImg = $('<div class="divide0'+_style.DIVISION+'-box" style="bottom:3px;">');
													$.each(tableData.divideImg, function(){ 
														if(this.DIVIDE == 'divide0'+_style.DIVISION){
															_chk = true;
															_divideImg.data(this);
														}
													});
													if(_chk){
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
													}else{
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_"+_imgDivide+".png)");
													}
												}
											}else if(_style.DIVISION == 6){
// 												var i = 0; //행사수 증가
// 												var j = 0; // 종합에 행사 넣어주기 위한 cnt
// 												$.each(_binsoArr, function(idx){
// 													$.each(_event, function(){
// 														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
// 															// j%_multi.length = 멀티 개수로 나누기 했을때 순차적으로 종합에 넣기
// 															if(_multi[j%_multi.length].raspNo == _this.RASPBERRY_CONNECTION_NO){
// 																if(i == 0){ // 처음 빈소 정보 입력
// 																	_binso.find('.status').text(this.APPELLATION);
// 																	_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_binso.find('.chief-mourner').data(this);
// 																	_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_binso.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 0 && i < 6){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
// 																	var _clone = _binsoBox.clone();
// 																	_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
// 																	_clone.find('.status').text(this.APPELLATION);
// 																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_clone.find('.chief-mourner').data(this);
// 																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 5){
// 																	if(i%6 == 0){
// 																		var _clone = _binsoClone.clone();
// 																		_div.find('.previews .binso-wrap').last().after(_clone);
// 																		_clone.find('.binso-box').find('.status').text(this.APPELLATION);
// 																		_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																		if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																		else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																		_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																		_clone.find('.binso-box').find('.chief-mourner').data(this);
// 																		_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																		_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
// 																		_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																	}else{
// 																		var _clone = _binsoBox.clone();
// 																		_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
// 																		_clone.find('.status').text(this.APPELLATION);
// 																		_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																		if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																		else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																		_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																		_clone.find('.chief-mourner').data(this);
// 																		_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																		_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																		_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																	}
// 																}
// 																i++;
// 															}
// 															j++;
// 														}
// 													});
// 												});
												
												var i = 0; //행사수 증가
												var _this = this; //행사 데이터 저장
												$.each(_tmp, function(idx){
													if(this.raspNo == _this.RASPBERRY_CONNECTION_NO){
														if(i == 0){ // 처음 빈소 정보 입력
															_binso.find('.status').text(_event[idx].APPELLATION);
															_binso.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_binso.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_binso.find('.chief-mourner').data(_event[idx]);
															_binso.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_binso.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_binso.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 0 && i < 6){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
															var _clone = _binsoBox.clone();
															_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
															_clone.find('.status').text(_event[idx].APPELLATION);
															_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(this.ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_clone.find('.chief-mourner').data(_event[idx]);
															_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 5){
															if(i%6 == 0){
																var _clone = _binsoClone.clone();
																_div.find('.previews .binso-wrap').last().after(_clone);
																_clone.find('.binso-box').find('.status').text(_event[idx].APPELLATION);
																_clone.find('.binso-box').find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
																if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
																_clone.find('.binso-box').find('.chief-mourner').data(_event[idx]);
																_clone.find('.binso-box').find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.binso-box').find('.carrying-start-time').text(_event[idx].CARRYING_DT);
																_clone.find('.binso-box').find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
															}else{
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																_clone.find('.status').text(_event[idx].APPELLATION);
																_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
																if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(_event[idx]);
																_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
																_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
															}
														}
														i++;
													}
												});
												
												
												// 분할 이미지 표현
												if(_div.find('.previews-box .binso-wrap').last().find('.binso-box').length < _style.DIVISION){
													var _chk = false;
													var _divideImg = $('<div class="divide0'+_style.DIVISION+'-box" style="bottom:3px;">');
													$.each(tableData.divideImg, function(){ 
														if(this.DIVIDE == 'divide0'+_style.DIVISION){
															_chk = true;
															_divideImg.data(this);
														}
													});
													if(_chk){
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
													}else{
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_"+_imgDivide+".png)");
													}
												}
											}else if(_style.DIVISION == 8){ // 8분할
// 												var i = 0; //행사수 증가
// 												var j = 0; // 종합에 행사 넣어주기 위한 cnt
// 												$.each(_binsoArr, function(idx){
// 													$.each(_event, function(){
// 														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
// 															// j%_multi.length = 멀티 개수로 나누기 했을때 순차적으로 종합에 넣기
// 															if(_multi[j%_multi.length].raspNo == _this.RASPBERRY_CONNECTION_NO){
// 																if(i == 0){ // 처음 빈소 정보 입력
// 																	_binso.find('.status').text(this.APPELLATION);
// 																	_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_binso.find('.chief-mourner').data(this);
// 																	_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_binso.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 0 && i < 8){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
// 																	var _clone = _binsoBox.clone();
// 																	_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
// 																	_clone.find('.status').text(this.APPELLATION);
// 																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																	_clone.find('.chief-mourner').data(this);
// 																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																}else if(i > 7){
// 																	if(i%8 == 0){
// 																		var _clone = _binsoClone.clone();
// 																		_div.find('.previews .binso-wrap').last().after(_clone);
// 																		_clone.find('.binso-box').find('.status').text(this.APPELLATION);
// 																		_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																		if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																		else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																		_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																		_clone.find('.binso-box').find('.chief-mourner').data(this);
// 																		_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																		_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
// 																		_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																	}else{
// 																		var _clone = _binsoBox.clone();
// 																		_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
// 																		_clone.find('.status').text(this.APPELLATION);
// 																		_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
// 																		if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
// 																		else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
// 																		_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
// 																		_clone.find('.chief-mourner').data(this);
// 																		_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
// 																		_clone.find('.carrying-start-time').text(this.CARRYING_DT);
// 																		_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
// 																	}
// 																}
// 																i++;
// 															}
// 															j++;
// 														}
// 													});
// 												});
												
												var i = 0; //행사수 증가
												var _this = this; //행사 데이터 저장
												$.each(_tmp, function(idx){
													if(this.raspNo == _this.RASPBERRY_CONNECTION_NO){
														if(i == 0){ // 처음 빈소 정보 입력
															_binso.find('.status').text(_event[idx].APPELLATION);
															_binso.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_binso.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_binso.find('.chief-mourner').data(_event[idx]);
															_binso.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_binso.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_binso.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 0 && i < 8){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
															var _clone = _binsoBox.clone();
															_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
															_clone.find('.status').text(_event[idx].APPELLATION);
															_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
															if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
															else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
															_clone.find('.chief-mourner').data(_event[idx]);
															_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
															_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
															_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
														}else if(i > 7){
															if(i%8 == 0){
																var _clone = _binsoClone.clone();
																_div.find('.previews .binso-wrap').last().after(_clone);
																_clone.find('.binso-box').find('.status').text(_event[idx].APPELLATION);
																_clone.find('.binso-box').find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
																if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
																_clone.find('.binso-box').find('.chief-mourner').data(_event[idx]);
																_clone.find('.binso-box').find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.binso-box').find('.carrying-start-time').text(_event[idx].CARRYING_DT);
																_clone.find('.binso-box').find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
															}else{
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																_clone.find('.status').text(_event[idx].APPELLATION);
																_clone.find('.name').text("故 "+_event[idx].DM_NAME+" "+isNull(_event[idx].DM_POSITION, '')+"("+(_event[idx].DM_GENDER == 1 ? '남' : '여')+(_event[idx].DM_AGE ? ",  "+_event[idx].DM_AGE+"세" : "")+")");
																if(_event[idx].ARROW_NO != 0 && _event[idx].ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+_event[idx].ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+_event[idx].DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(_event[idx]);
																_clone.find('.er-start-time').text(_event[idx].ENTRANCE_ROOM_NO ? _event[idx].ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(_event[idx].CARRYING_DT);
																_clone.find('.burial-plot-name').text(_event[idx].BURIAL_PLOT_NAME ? _event[idx].BURIAL_PLOT_NAME : '미정');
															}
														}
														i++;
													}
												});
												
												// 분할 이미지 표현
												if(_div.find('.previews-box .binso-wrap').last().find('.binso-box').length < _style.DIVISION){
													var _chk = false;
													var _divideImg = $('<div class="divide0'+_style.DIVISION+'-box" style="bottom:3px;">');
													$.each(tableData.divideImg, function(){ 
														if(this.DIVIDE == 'divide0'+_style.DIVISION){
															_chk = true;
															_divideImg.data(this);
														}
													});
													if(_chk){
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
													}else{
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_"+_imgDivide+".png)");
													}
												}
											}
										}
									}
								}
							}else{ //멀티모드 끝, 멀티 모드 끄기(2), 자동모드
								if(this.DIVISION_MODE == 1){ //분할 모드 자동 - 자동일때는 분할 상관없이 빈소수에 따라 분할
									if(this.BINSO_LIST){
										var _binsoArr = this.BINSO_LIST.split(',');
										
										//행사 개수 세기
										var _event = []; var _cnt = 0;
										$.each(_binsoArr, function(idx){
											var _chk = false;
											$.each(tableData.event, function(){
												if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
													_cnt++;
													_event.push(this);
													_chk = true;
													if(_chk) return false; // break
												}
											});
										});
										
										if(_cnt == 0){
											_div.find('.title-box').hide();
											if(tableData.waitInfo[0]){
												if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
													_div.find('.previews-box').html("").css('background', '#000');
												}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
													$.each(tableData.waitInfo, function(){
														var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
														_binso.css('background-image', 'url('+this.FILE+')');
														_div.find('.previews-box').append(_binso);
													});
												}else{ //대기화면 동영상
													_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
												}
											}else{
												_div.find('.previews-box').html("").css('background', '#000');
											}
										}else if(_cnt == 1){
											//슬라이드 효과 변경시, 화면분할 변경시 -> 스타일 변경
											$.each(_styleData, function(){
												if(this.THUMBNAIL == _this.STATUS_PLATE_STYLE_NO && this.DIVISION == 1){
													_style = this;
												}
											});
											
											if(this.BOTTOM_TEXT){
												//탑생성
												_div.find('.previews').append('<div class="title-box" style="height:30px">'); 
												_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
												_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
												_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
												
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){

															//종합 스타일 저장
															var _binso = $('<div class="binso-wrap one swiper-slide" style="padding:30px 0px;"></div>');
															_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_one_bottom_black_'+_style.THUMBNAIL+'.png")');
															_binso.append('<div class="binso-box">');
// 															_binso.find('.binso-box').append('<div class="status" style="color:'+_style.STATUS+'">'+this.APPELLATION+'</div>');
															_binso.find('.binso-box').append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'">'+this.APPELLATION+'</div></div>');
															_binso.find('.binso-box').append('<div class="name" style="color:'+_style.NAME+'">'+"故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")"+'</div>');
															_binso.find('.binso-box').append('<div class="arrow"></div>');
															
															if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
			 												else _binso.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_binso.find('.binso-box').append('<div class="photo" style="background-image:url('+this.DM_PHOTO+')"></div>');
// 															_binso.find('.binso-box').append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
															_binso.find('.binso-box').append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
															_binso.find('.binso-box').find('.chief-mourner').data(this);
															_binso.find('.binso-box').append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
															_binso.find('.binso-box').append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'">'+(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-")+'</div>');
															_binso.find('.binso-box').append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
															_binso.find('.binso-box').append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'">'+this.CARRYING_DT+'</div>');
															_binso.find('.binso-box').append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
															_binso.find('.binso-box').append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'">'+(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정')+'</div>');
															_div.find('.previews-box').append(_binso);
														}
													});
												});
												//바텀 생성
												_div.find('.previews').append('<div class="bottom">'+(this.BOTTOM_TEXT ? this.BOTTOM_TEXT : "")+'</div>');
											
											}else{
												//탑생성
												_div.find('.previews').append('<div class="title-box" style="height:57px">'); 
												_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
												_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
												_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
												
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															//종합 스타일 저장
															var _binso = $('<div class="binso-wrap one swiper-slide" style="padding:56px 0px 4px 0px;"></div>');
															_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_one_top_black_'+_style.THUMBNAIL+'.png")');
															_binso.append('<div class="binso-box">');
// 															_binso.find('.binso-box').append('<div class="status" style="color:'+_style.STATUS+'">'+this.APPELLATION+'</div>');
															_binso.find('.binso-box').append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'">'+this.APPELLATION+'</div></div>');
															_binso.find('.binso-box').append('<div class="name" style="color:'+_style.NAME+'">'+"故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")"+'</div>');
															_binso.find('.binso-box').append('<div class="arrow"></div>');
															if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
			 												else _binso.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
															_binso.find('.binso-box').append('<div class="photo" style="background-image:url('+this.DM_PHOTO+')"></div>');
															_binso.find('.binso-box').append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
															_binso.find('.binso-box').find('.chief-mourner').data(this);
															_binso.find('.binso-box').append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
															_binso.find('.binso-box').append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'">'+(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-")+'</div>');
															_binso.find('.binso-box').append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
															_binso.find('.binso-box').append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'">'+this.CARRYING_DT+'</div>');
															_binso.find('.binso-box').append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
															_binso.find('.binso-box').append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'">'+(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정')+'</div>');
															_div.find('.previews-box').append(_binso);
														}
													});
												});
											}
										}else if(_cnt <= 2){ //자동 2분할
											//슬라이드 효과 변경시, 화면분할 변경시 -> 스타일 변경
											$.each(_styleData, function(){
												if(this.THUMBNAIL == _this.STATUS_PLATE_STYLE_NO && this.DIVISION == 2){
													_style = this;
												}
											});
											
											if(this.BOTTOM_TEXT){
												//탑생성
												_div.find('.previews').append('<div class="title-box" style="height:30px">'); 
												_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
												_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
												_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
												
												//종합 스타일 저장
												var _binso = $('<div class="binso-wrap two swiper-slide" style="padding:30px 0px;"></div>');
												_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_two_bottom_black_'+_style.THUMBNAIL+'.png")');
												var _binsoBox = $('<div class="binso-box">');
												_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
												_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
												_binsoBox.append('<div class="arrow"></div>');
												_binsoBox.append('<div class="photo"></div>');
												_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
												_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
												_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
												_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
												_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
												_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
												_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
												_binso.append(_binsoBox);
												_div.find('.previews-box').append(_binso);
												
												var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
													
												//바텀 생성
												_div.find('.previews').append('<div class="bottom">'+(this.BOTTOM_TEXT ? this.BOTTOM_TEXT : "")+'</div>');

												var i = 0; //행사수 증가
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 2){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}
															i++;
														}
	 												});
												});
											}else{ //자동 2분할 바텀 없음
												//탑생성
												_div.find('.previews').append('<div class="title-box" style="height:57px">'); 
												_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
												_div.find('.previews .title-box').append('<div class="text" style="font-size:25px;">빈소안내</div>');
												_div.find('.previews .title-box').append('<div class="time" style="font-size:20px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');

												//종합 스타일 저장
												var _binso = $('<div class="binso-wrap two swiper-slide" style="padding:56px 0px 4px 0px;"></div>');
												_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_two_top_black_'+_style.THUMBNAIL+'.png")');
												var _binsoBox = $('<div class="binso-box">');
												_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
												_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
												_binsoBox.append('<div class="arrow"></div>');
												_binsoBox.append('<div class="photo"></div>');
												_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
												_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
												_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
												_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
												_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
												_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
												_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
												_binso.append(_binsoBox);
												_div.find('.previews-box').append(_binso);
												
												var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
												
												var i = 0;
												//빈소 정보 입력 + 빈소생성
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 2){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}
															i++;
														}
	 												});
												});
											}
										}else if(_cnt <= 4){
											//슬라이드 효과 변경시, 화면분할 변경시 -> 스타일 변경
											$.each(_styleData, function(){
												if(this.THUMBNAIL == _this.STATUS_PLATE_STYLE_NO && this.DIVISION == 4){
													_style = this;
												}
											});
											if(this.BOTTOM_TEXT){//자동 4분할
												//탑생성
												_div.find('.previews').append('<div class="title-box" style="height:30px">'); 
												_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
												_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
												_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
												
												//종합 스타일 저장
												var _binso = $('<div class="binso-wrap four swiper-slide" style="padding:30px 0px;"></div>');
												_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_four_bottom_black_'+_style.THUMBNAIL+'.png")');
												var _binsoBox = $('<div class="binso-box">');
// 												_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
												_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
												_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
												_binsoBox.append('<div class="arrow"></div>');
												_binsoBox.append('<div class="photo"></div>');
// 												_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
												_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
												
												_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
												_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
												_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
												_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
												_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
												_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
												_binso.append(_binsoBox);
												_div.find('.previews-box').append(_binso);
												
												var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
													
												//바텀 생성
												_div.find('.previews').append('<div class="bottom">'+(this.BOTTOM_TEXT ? this.BOTTOM_TEXT : "")+'</div>');

												//빈소 정보 입력 + 빈소생성
												var i = 0;
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 4){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 3){
																if(i%4 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
												
												
												if(_cnt != 4){
													if(i % 4 != 0){ //분할이미지 표현
														var _chk = false;
														var _divideImg = $('<div class="divide-box divide04-box" style="bottom:29px;">');
														$.each(tableData.divideImg, function(){ 
															if(this.DIVIDE == 'divide04'){
																_chk = true;
																_divideImg.data(this);
															}
														});
														
														if(_chk){
															_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
															_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
														}else{
															_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
															_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_four.png)");
														}
													}
												}
											}else{ // 자동 4분할 바텀 없음
												//탑생성
												_div.find('.previews').append('<div class="title-box" style="height:57px">'); 
												_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
												_div.find('.previews .title-box').append('<div class="text" style="font-size:25px;">빈소안내</div>');
												_div.find('.previews .title-box').append('<div class="time" style="font-size:20px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
												
												//종합 스타일 저장
												var _binso = $('<div class="binso-wrap four swiper-slide" style="padding:56px 0px 4px 0px;"></div>');
												_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_four_top_black_'+_style.THUMBNAIL+'.png")');
												var _binsoBox = $('<div class="binso-box">');
// 												_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
												_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
												_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
												_binsoBox.append('<div class="arrow"></div>');
												_binsoBox.append('<div class="photo"></div>');
// 												_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
												_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
												
												_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
												_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
												_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
												_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
												_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
												_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
												_binso.append(_binsoBox);
												_div.find('.previews-box').append(_binso);
												
												var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
													
												var i = 0;
												//빈소 정보 입력 + 빈소생성
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 4){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 3){
																if(i%4 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text(this.DM_NAME);
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
													
												if(_cnt != 4){
													if(i % 4 != 0){ //분할이미지 표현
														var _chk = false;
														var _divideImg = $('<div class="divide-box divide04-box" style="bottom:3px;">');
														$.each(tableData.divideImg, function(){ 
															if(this.DIVIDE == 'divide04'){
																_chk = true;
																_divideImg.data(this);
															}
														});
														if(_chk){
															_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
															_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
														}else{
															_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
															_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_four.png)");
														}
													}
												}
											}
										}else if(_cnt <= 6){
											//슬라이드 효과 변경시, 화면분할 변경시 -> 스타일 변경
											$.each(_styleData, function(){
												if(this.THUMBNAIL == _this.STATUS_PLATE_STYLE_NO && this.DIVISION == 6){
													_style = this;
												}
											});
											
											if(this.BOTTOM_TEXT){//자동 6분할
												//탑생성
												_div.find('.previews').append('<div class="title-box" style="height:30px">'); 
												_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
												_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
												_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
												
												//종합 스타일 저장
												var _binso = $('<div class="binso-wrap six swiper-slide" style="padding:30px 0px;"></div>');
												_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_six_bottom_black_'+_style.THUMBNAIL+'.png")');
												var _binsoBox = $('<div class="binso-box">');
// 												_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
												_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
												_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
												_binsoBox.append('<div class="arrow"></div>');
												_binsoBox.append('<div class="photo"></div>');
// 												_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
												_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
												
												_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
												_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
												_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
												_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
												_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
												_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
												_binso.append(_binsoBox);
												_div.find('.previews-box').append(_binso);
												
												var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
													
												//바텀 생성
												_div.find('.previews').append('<div class="bottom">'+(this.BOTTOM_TEXT ? this.BOTTOM_TEXT : "")+'</div>');

												var i = 0;
												//빈소 정보 입력 + 빈소생성
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 6){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 5){
																if(i%6 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
												
												if(_cnt != 6){
													if(_event.length % 6 != 0){ //분할이미지 표현
														var _chk = false;
														var _divideImg = $('<div class="divide-box divide06-box" style="bottom:29px;">');
														$.each(tableData.divideImg, function(){ 
															if(this.DIVIDE == 'divide06'){
																_chk = true;
																_divideImg.data(this);
															}
														});
														if(_chk){
															_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
															_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
														}else{
															_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
															_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_six.png)");
														}
													}
												}
											}else{ //자동 6분할 바텀 없음
												//탑생성
												_div.find('.previews').append('<div class="title-box" style="height:57px">'); 
												_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
												_div.find('.previews .title-box').append('<div class="text" style="font-size:25px;">빈소안내</div>');
												_div.find('.previews .title-box').append('<div class="time" style="font-size:20px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
												
												//종합 스타일 저장
												var _binso = $('<div class="binso-wrap six swiper-slide" style="padding:56px 0px 4px 0px;"></div>');
												_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_six_top_black_'+_style.THUMBNAIL+'.png")');
												var _binsoBox = $('<div class="binso-box">');
// 												_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
												_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
												_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
												_binsoBox.append('<div class="arrow"></div>');
												_binsoBox.append('<div class="photo"></div>');
// 												_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
												_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
												
												_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
												_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
												_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
												_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
												_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
												_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
												_binso.append(_binsoBox);
												_div.find('.previews-box').append(_binso);
												
												var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
												
												var i = 0;
												//빈소 정보 입력 + 빈소생성
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 6){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 5){
																if(i%6 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
												
												if(_cnt != 6){
													if(_event.length % 6 != 0){ //분할이미지 표현
														var _chk = false;
														var _divideImg = $('<div class="divide-box divide06-box" style="bottom:3px;">');
														$.each(tableData.divideImg, function(){ 
															if(this.DIVIDE == 'divide06'){
																_chk = true;
																_divideImg.data(this);
															}
														});
														if(_chk){
															_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
															_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
														}else{
															_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
															_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_six.png)");
														}
													}
												}
											}
										}else if(_cnt > 6){
											//슬라이드 효과 변경시, 화면분할 변경시 -> 스타일 변경
											$.each(_styleData, function(){
												if(this.THUMBNAIL == _this.STATUS_PLATE_STYLE_NO && this.DIVISION == 8){
													_style = this;
												}
											});
											
											if(this.BOTTOM_TEXT){//자동 8분할
												//탑생성
												_div.find('.previews').append('<div class="title-box" style="height:30px">'); 
												_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
												_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
												_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
												
												//종합 스타일 저장
												var _binso = $('<div class="binso-wrap eight swiper-slide" style="padding:30px 0px;"></div>');
												_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_eight_bottom_black_'+_style.THUMBNAIL+'.png")');
												var _binsoBox = $('<div class="binso-box">');
// 												_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
												_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
												_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
												_binsoBox.append('<div class="arrow"></div>');
												_binsoBox.append('<div class="photo"></div>');
// 												_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
												_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
												
												_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
												_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
												_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
												_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
												_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
												_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
												_binso.append(_binsoBox);
												_div.find('.previews-box').append(_binso);
												
												var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
													
												//바텀 생성
												_div.find('.previews').append('<div class="bottom">'+(this.BOTTOM_TEXT ? this.BOTTOM_TEXT : "")+'</div>');

												var i = 0;
												//빈소 정보 입력 + 빈소생성
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 8){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 7){
																if(i%8 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
												if(_cnt % 8 != 0){ //분할이미지 표현
													var _chk = false;
													var _divideImg = $('<div class="divide-box divide08-box" style="bottom:29px;">');
													$.each(tableData.divideImg, function(){ 
														if(this.DIVIDE == 'divide08'){
															_chk = true;
															_divideImg.data(this);
														}
													});
													if(_chk){
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
													}else{
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_eight.png)");
													}
												}
											}else{  //자동 8분할 바텀 없음
												//탑생성
												_div.find('.previews').append('<div class="title-box" style="height:57px">'); 
												_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
												_div.find('.previews .title-box').append('<div class="text" style="font-size:25px;">빈소안내</div>');
												_div.find('.previews .title-box').append('<div class="time" style="font-size:20px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
												
												//종합 스타일 저장
												var _binso = $('<div class="binso-wrap eight swiper-slide" style="padding:56px 0px 4px;"></div>');
												_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_eight_top_black_'+_style.THUMBNAIL+'.png")');
												var _binsoBox = $('<div class="binso-box">');
// 												_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
												_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
												_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
												_binsoBox.append('<div class="arrow"></div>');
												_binsoBox.append('<div class="photo"></div>');
// 												_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
												_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
												
												_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
												_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
												_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
												_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
												_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
												_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
												_binso.append(_binsoBox);
												_div.find('.previews-box').append(_binso);
												
												var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.

												//빈소 정보 입력 + 빈소생성
												var i = 0;
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 8){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 7){
																if(i%8 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
												
												if(_cnt % 8 != 0){ //분할이미지 표현
													var _chk = false;
													var _divideImg = $('<div class="divide-box divide08-box" style="bottom:3px;">');
													$.each(tableData.divideImg, function(){ 
														if(this.DIVIDE == 'divide08'){
															_chk = true;
															_divideImg.data(this);
														}
													});
													if(_chk){
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
													}else{
														_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
														_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_eight.png)");
													}
												}
											}
										}
									}
								}else{ //자동모드 끝, 분할 모드 고정
									

									//분할모드 쪽 행사 수 새기
									var _binsoArr = this.BINSO_LIST.split(',');
									var _event = []; var _cnt = 0;
									$.each(_binsoArr, function(idx){
										var _chk = false;
										$.each(tableData.event, function(){
											if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
												_cnt++;
												_event.push(this);
												_chk = true;
												if(_chk) return false; // break
											}
										});
									});

	
									if(this.DIVISION == 1){
										if(this.BOTTOM_TEXT){
											//탑생성
											_div.find('.previews').append('<div class="title-box" style="height:30px">'); 
											_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
											_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
											_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
											
											//종합 스타일 저장
											var _binso = $('<div class="binso-wrap one swiper-slide" style="padding:30px 0px;"></div>');
											_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_one_bottom_black_'+_style.THUMBNAIL+'.png")');
											_binso.append('<div class="binso-box">');
											_binso.find('.binso-box').append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
											_binso.find('.binso-box').append('<div class="name" style="color:'+_style.NAME+'"></div>');
											_binso.find('.binso-box').append('<div class="arrow"></div>');
											_binso.find('.binso-box').append('<div class="photo"></div>');
											_binso.find('.binso-box').append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
											_binso.find('.binso-box').append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
											_binso.find('.binso-box').append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
											_binso.find('.binso-box').append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
											_binso.find('.binso-box').append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
											_binso.find('.binso-box').append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
											_binso.find('.binso-box').append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
											_div.find('.previews-box').append(_binso);
											
											//바텀 생성
											_div.find('.previews').append('<div class="bottom">'+(this.BOTTOM_TEXT ? this.BOTTOM_TEXT : "")+'</div>');
										
											
											//빈소 정보 입력 + 빈소생성
											if(this.BINSO_LIST){
												var _binsoArr = this.BINSO_LIST.split(','); var i = 0;
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i > 0){
																var _clone = _binso.clone();
																_div.find('.previews .binso-wrap').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else{
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}
															i++;
														}
	 												});
												});
												
												//고정 1분할 행사 없을시 대기화면
												if(i == 0){
													_div.find('.title-box').hide();
													if(tableData.waitInfo[0]){
														if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
															_div.find('.previews-box').html("").css('background', '#000');
														}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
															$.each(tableData.waitInfo, function(){
																var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
																_binso.css('background-image', 'url('+this.FILE+')');
																_div.find('.previews-box').append(_binso);
															});
														}else{ //대기화면 동영상
															_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
														}
													}else{
														_div.find('.previews-box').html("").css('background', '#000');
													}
												}
											}
										}else{
											//탑생성
											_div.find('.previews').append('<div class="title-box" style="height:57px">'); 
											_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
											_div.find('.previews .title-box').append('<div class="text" style="font-size:25px;">빈소안내</div>');
											_div.find('.previews .title-box').append('<div class="time" style="font-size:20px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
											
											//빈소 생성
											_div.find('.previews .binso-wrap.one').append('<div class="binso-box"></div>');

											//종합 스타일 저장
											var _binso = $('<div class="binso-wrap one swiper-slide" style="padding:56px 0px 4px 0px;"></div>');
											_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_one_top_black_'+_style.THUMBNAIL+'.png")');
											_binso.append('<div class="binso-box">');
// 											_binso.find('.binso-box').append('<div class="status" style="color:'+_style.STATUS+'"></div>');
											_binso.find('.binso-box').append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
											_binso.find('.binso-box').append('<div class="name" style="color:'+_style.NAME+'"></div>');
											_binso.find('.binso-box').append('<div class="arrow"></div>');
											_binso.find('.binso-box').append('<div class="photo"></div>');
											_binso.find('.binso-box').append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
											_binso.find('.binso-box').append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
											_binso.find('.binso-box').append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
											_binso.find('.binso-box').append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
											_binso.find('.binso-box').append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
											_binso.find('.binso-box').append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
											_binso.find('.binso-box').append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
											_div.find('.previews-box').append(_binso);

											
											//빈소 정보 입력 + 빈소생성
											if(this.BINSO_LIST){
												var _binsoArr = this.BINSO_LIST.split(','); var i = 0;
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i > 0){
																var _clone = _binso.clone();
																_div.find('.previews .binso-wrap').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else{
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}
															i++;
														}
	 												});
												});
											}
											//고정 1분할 행사 없을시 대기화면
											if(i == 0){
												_div.find('.title-box').hide();
												if(tableData.waitInfo[0]){
													if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
														_div.find('.previews-box').html("").css('background', '#000');
													}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
														$.each(tableData.waitInfo, function(){
															var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
															_binso.css('background-image', 'url('+this.FILE+')');
															_div.find('.previews-box').append(_binso);
														});
													}else{ //대기화면 동영상
														_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
													}
												}else{
													_div.find('.previews-box').html("").css('background', '#000');
												}
											}
										}
									}else if(this.DIVISION == 2){ //고정 2분할
										if(this.BOTTOM_TEXT){
											//탑생성
											_div.find('.previews').append('<div class="title-box" style="height:30px">'); 
											_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
											_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
											_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
											
											//종합 스타일 저장
											var _binso = $('<div class="binso-wrap two swiper-slide" style="padding:30px 0px;"></div>');
											_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_two_bottom_black_'+_style.THUMBNAIL+'.png")');
											var _binsoBox = $('<div class="binso-box">');
// 											_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
											_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
											_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
											_binsoBox.append('<div class="arrow"></div>');
											_binsoBox.append('<div class="photo"></div>');
// 											_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
											_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
											
											_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
											_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
											_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
											_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
											_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
											_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
											_binso.append(_binsoBox);
											_div.find('.previews-box').append(_binso);
											
											var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
												
											//바텀 생성
											_div.find('.previews').append('<div class="bottom">'+(this.BOTTOM_TEXT ? this.BOTTOM_TEXT : "")+'</div>');

											//빈소 정보 입력 + 빈소생성
											var i = 0;
											if(this.BINSO_LIST){
												var _binsoArr = this.BINSO_LIST.split(','); 
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 2){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 1){
																if(i%2 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
											}
											
											if(i % 2 != 0){ //분할이미지 표현
												var _divideImg = $('<div class="divide-box divide02-box" style="bottom:29px;">');
												var _chk = false;
												$.each(tableData.divideImg, function(){ 
													if(this.DIVIDE == 'divide02'){
														_chk = true;
														_divideImg.data(this);
													}
												});
												if(_chk){
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
												}else{
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_two.png)");
												}
											}
											
											//고정 2분할 행사 없을시 대기화면
											if(i == 0){
												_div.find('.title-box').hide();
												if(tableData.waitInfo[0]){
													if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
														_div.find('.previews-box').html("").css('background', '#000');
													}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
														$.each(tableData.waitInfo, function(){
															var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
															_binso.css('background-image', 'url('+this.FILE+')');
															_div.find('.previews-box').append(_binso);
														});
													}else{ //대기화면 동영상
														_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
													}
												}else{
													_div.find('.previews-box').html("").css('background', '#000');
												}
											}
										}else{
											//탑생성
											_div.find('.previews').append('<div class="title-box" style="height:57px">'); 
											_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
											_div.find('.previews .title-box').append('<div class="text" style="font-size:25px;">빈소안내</div>');
											_div.find('.previews .title-box').append('<div class="time" style="font-size:20px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');

											//종합 스타일 저장
											var _binso = $('<div class="binso-wrap two swiper-slide" style="padding:56px 0px 4px 0px;"></div>');
											_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_two_top_black_'+_style.THUMBNAIL+'.png")');
											var _binsoBox = $('<div class="binso-box">');
// 											_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
											_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
											_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
											_binsoBox.append('<div class="arrow"></div>');
											_binsoBox.append('<div class="photo"></div>');
// 											_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
											_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
											
											_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
											_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
											_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
											_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
											_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
											_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
											_binso.append(_binsoBox);
											_div.find('.previews-box').append(_binso);
											
											var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.

											//빈소 정보 입력 + 빈소생성
											var i = 0;
											if(this.BINSO_LIST){
												var _binsoArr = this.BINSO_LIST.split(','); 
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 2){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 1){
																if(i%2 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
											}
											
											if(i % 2 != 0){ //분할이미지 표현
												var _divideImg = $('<div class="divide-box divide02-box" style="bottom:3px;">');
												var _chk = false;
												$.each(tableData.divideImg, function(){ 
													if(this.DIVIDE == 'divide02'){
														_chk = true;
														_divideImg.data(this);
													}
												});
												if(_chk){
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
												}else{
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_two.png)");
												}
											}
											//고정 2분할 행사 없을시 대기화면
											if(i == 0){
												_div.find('.title-box').hide();
												if(tableData.waitInfo[0]){
													if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
														_div.find('.previews-box').html("").css('background', '#000');
													}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
														$.each(tableData.waitInfo, function(){
															var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
															_binso.css('background-image', 'url('+this.FILE+')');
															_div.find('.previews-box').append(_binso);
														});
													}else{ //대기화면 동영상
														_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
													}
												}else{
													_div.find('.previews-box').html("").css('background', '#000');
												}
											}
										}
									}else if(this.DIVISION == 4){ //고정 4분할
										if(this.BOTTOM_TEXT){
											//탑생성
											_div.find('.previews').append('<div class="title-box" style="height:30px">'); 
											_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
											_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
											_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
											
											//종합 스타일 저장
											var _binso = $('<div class="binso-wrap four swiper-slide" style="padding:30px 0px;"></div>');
											_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_four_bottom_black_'+_style.THUMBNAIL+'.png")');
											var _binsoBox = $('<div class="binso-box">');
// 											_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
											_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
											_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
											_binsoBox.append('<div class="arrow"></div>');
											_binsoBox.append('<div class="photo"></div>');
// 											_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
											_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
											
											_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
											_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
											_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
											_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
											_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
											_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
											_binso.append(_binsoBox);
											_div.find('.previews-box').append(_binso);
											
											var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
												
											//바텀 생성
											_div.find('.previews').append('<div class="bottom">'+(this.BOTTOM_TEXT ? this.BOTTOM_TEXT : "")+'</div>');

											//빈소 정보 입력 + 빈소생성
											var i = 0;
											if(this.BINSO_LIST){
												var _binsoArr = this.BINSO_LIST.split(','); 
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 4){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 3){
																if(i%4 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
											}	
											
											if(i % 4 != 0){ //분할이미지 표현
												var _chk = false;
												var _divideImg = $('<div class="divide-box divide04-box" style="bottom:29px;">');
												$.each(tableData.divideImg, function(){ 
													if(this.DIVIDE == 'divide04'){
														_chk = true;
														_divideImg.data(this);
													}
												});
												if(_chk){
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
												}else{
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_four.png)");
												}
											}
											
											//고정 4분할 행사 없을시 바텀 있을때 대기화면
											if(i == 0){
												_div.find('.title-box').hide();
												if(tableData.waitInfo[0]){
													if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
														_div.find('.previews-box').html("").css('background', '#000');
													}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
														$.each(tableData.waitInfo, function(){
															var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
															_binso.css('background-image', 'url('+this.FILE+')');
															_div.find('.previews-box').append(_binso);
														});
													}else{ //대기화면 동영상
														_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
													}
												}else{
													_div.find('.previews-box').html("").css('background', '#000');
												}
											}
										}else{
											//탑생성
											_div.find('.previews').append('<div class="title-box" style="height:57px">'); 
											_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
											_div.find('.previews .title-box').append('<div class="text" style="font-size:25px;">빈소안내</div>');
											_div.find('.previews .title-box').append('<div class="time" style="font-size:20px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
											
											//종합 스타일 저장
											var _binso = $('<div class="binso-wrap four swiper-slide" style="padding:56px 0px 4px 0px;"></div>');
											_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_four_top_black_'+_style.THUMBNAIL+'.png")');
											var _binsoBox = $('<div class="binso-box">');
// 											_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
											_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
											_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
											_binsoBox.append('<div class="arrow"></div>');
											_binsoBox.append('<div class="photo"></div>');
// 											_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
											_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
											
											_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
											_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
											_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
											_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
											_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
											_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
											_binso.append(_binsoBox);
											_div.find('.previews-box').append(_binso);
											
											var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
												
											//빈소 정보 입력 + 빈소생성
											var i = 0;
											if(this.BINSO_LIST){
												var _binsoArr = this.BINSO_LIST.split(','); 
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 4){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 3){
																if(i%4 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
											}
											
											if(i % 4 != 0){ //분할이미지 표현
												var _chk = false;
												var _divideImg = $('<div class="divide-box divide04-box" style="bottom:3px;">');
												$.each(tableData.divideImg, function(){ 
													if(this.DIVIDE == 'divide04'){
														_chk = true;
														_divideImg.data(this);
													}
												});
												if(_chk){
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
												}else{
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_four.png)");
												}
											}

											//고정 4분할 행사 없을시, 바텀 없을때 대기화면
											if(i == 0){
												_div.find('.title-box').hide();
												if(tableData.waitInfo[0]){
													if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
														_div.find('.previews-box').html("").css('background', '#000');
													}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
														$.each(tableData.waitInfo, function(){
															var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
															_binso.css('background-image', 'url('+this.FILE+')');
															_div.find('.previews-box').append(_binso);
														});
													}else{ //대기화면 동영상
														_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
													}
												}else{
													_div.find('.previews-box').html("").css('background', '#000');
												}
											}
										}
									}else if(this.DIVISION == 6){ //6분할
										if(this.BOTTOM_TEXT){
											//탑생성
											_div.find('.previews').append('<div class="title-box" style="height:30px">'); 
											_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
											_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
											_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
											
											//종합 스타일 저장
											var _binso = $('<div class="binso-wrap six swiper-slide" style="padding:30px 0px;"></div>');
											_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_six_bottom_black_'+_style.THUMBNAIL+'.png")');
											var _binsoBox = $('<div class="binso-box">');
// 											_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
											_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
											_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
											_binsoBox.append('<div class="arrow"></div>');
											_binsoBox.append('<div class="photo"></div>');
// 											_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
											_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
											
											_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
											_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
											_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
											_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
											_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
											_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
											_binso.append(_binsoBox);
											_div.find('.previews-box').append(_binso);
											
											var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
												
											//바텀 생성
											_div.find('.previews').append('<div class="bottom">'+(this.BOTTOM_TEXT ? this.BOTTOM_TEXT : "")+'</div>');

											//빈소 정보 입력 + 빈소생성
											var i = 0;
											if(this.BINSO_LIST){
												var _binsoArr = this.BINSO_LIST.split(','); 
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 6){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 5){
																if(i%6 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
											}
											
											if(i % 6 != 0){ //분할이미지 표현
												var _chk = false;
												var _divideImg = $('<div class="divide-box divide06-box" style="bottom:29px;">');
												$.each(tableData.divideImg, function(){ 
													if(this.DIVIDE == 'divide06'){
														_chk = true;
														_divideImg.data(this);
													}
												});
												if(_chk){
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
												}else{
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_six.png)");
												}
											}
											
											//고정 6분할 행사 없을시, 바텀 있을때 대기화면
											if(i == 0){
												_div.find('.title-box').hide();
												if(tableData.waitInfo[0]){
													if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
														_div.find('.previews-box').html("").css('background', '#000');
													}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
														$.each(tableData.waitInfo, function(){
															var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
															_binso.css('background-image', 'url('+this.FILE+')');
															_div.find('.previews-box').append(_binso);
														});
													}else{ //대기화면 동영상
														_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
													}
												}else{
													_div.find('.previews-box').html("").css('background', '#000');
												}
											}
										}else{
											//탑생성
											_div.find('.previews').append('<div class="title-box" style="height:57px">'); 
											_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
											_div.find('.previews .title-box').append('<div class="text" style="font-size:25px;">빈소안내</div>');
											_div.find('.previews .title-box').append('<div class="time" style="font-size:20px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
											
											//종합 스타일 저장
											var _binso = $('<div class="binso-wrap six swiper-slide" style="padding:56px 0px 4px 0px;"></div>');
											_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_six_top_black_'+_style.THUMBNAIL+'.png")');
											var _binsoBox = $('<div class="binso-box">');
// 											_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
											_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
											_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
											_binsoBox.append('<div class="arrow"></div>');
											_binsoBox.append('<div class="photo"></div>');
// 											_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
											_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
											
											_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
											_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
											_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
											_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
											_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
											_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
											_binso.append(_binsoBox);
											_div.find('.previews-box').append(_binso);
											
											var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
												
											//빈소 정보 입력 + 빈소생성
											var i = 0;
											if(this.BINSO_LIST){
												var _binsoArr = this.BINSO_LIST.split(','); 
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 6){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 5){
																if(i%6 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
											}
											if(i % 6 != 0){ //분할이미지 표현
												var _chk = false;
												var _divideImg = $('<div class="divide-box divide06-box" style="bottom:3px;">');
												$.each(tableData.divideImg, function(){ 
													if(this.DIVIDE == 'divide06'){
														_chk = true;
														_divideImg.data(this);
													}
												});
												if(_chk){
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
												}else{
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_six.png)");
												}
											}
											
											//고정 6분할 행사 없을시, 바텀 없을때 대기화면
											if(i == 0){
												_div.find('.title-box').hide();
												if(tableData.waitInfo[0]){
													if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
														_div.find('.previews-box').html("").css('background', '#000');
													}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
														$.each(tableData.waitInfo, function(){
															var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
															_binso.css('background-image', 'url('+this.FILE+')');
															_div.find('.previews-box').append(_binso);
														});
													}else{ //대기화면 동영상
														_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
													}
												}else{
													_div.find('.previews-box').html("").css('background', '#000');
												}
											}
										}
									}else{
										if(this.BOTTOM_TEXT){ //8분할 고정
											//탑생성
											_div.find('.previews').append('<div class="title-box" style="height:30px">'); 
											_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
											_div.find('.previews .title-box').append('<div class="text" style="font-size:18px;">빈소안내</div>');
											_div.find('.previews .title-box').append('<div class="time" style="font-size:18px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
											
											//종합 스타일 저장
											var _binso = $('<div class="binso-wrap eight swiper-slide" style="padding:30px 0px;"></div>');
											_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_eight_bottom_black_'+_style.THUMBNAIL+'.png")');
											var _binsoBox = $('<div class="binso-box">');
// 											_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
											_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
											_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
											_binsoBox.append('<div class="arrow"></div>');
											_binsoBox.append('<div class="photo"></div>');
// 											_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
											_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
											
											_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
											_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
											_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
											_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
											_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
											_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
											_binso.append(_binsoBox);
											_div.find('.previews-box').append(_binso);
											
											var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.
												
											//바텀 생성
											_div.find('.previews').append('<div class="bottom">'+(this.BOTTOM_TEXT ? this.BOTTOM_TEXT : "")+'</div>');

											//빈소 정보 입력 + 빈소생성
											var i = 0;
											if(this.BINSO_LIST){
												var _binsoArr = this.BINSO_LIST.split(',');
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 8){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 7){
																if(i%8 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
											}
											
											if(i % 8 != 0){ //분할이미지 표현
												var _chk = false;
												var _divideImg = $('<div class="divide-box divide08-box" style="bottom:29px;">');
												$.each(tableData.divideImg, function(){ 
													if(this.DIVIDE == 'divide08'){
														_chk = true;
														_divideImg.data(this);
													}
												});
												if(_chk){
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
												}else{
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_eight.png)");
												}
											}
											
											//고정 8분할 행사 없을시, 바텀 있을때 대기화면
											if(i == 0){
												_div.find('.title-box').hide();
												if(tableData.waitInfo[0]){
													if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
														_div.find('.previews-box').html("").css('background', '#000');
													}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
														$.each(tableData.waitInfo, function(){
															var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
															_binso.css('background-image', 'url('+this.FILE+')');
															_div.find('.previews-box').append(_binso);
														});
													}else{ //대기화면 동영상
														_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
													}
												}else{
													_div.find('.previews-box').html("").css('background', '#000');
												}
											}
										}else{  //고정 8분할
											//탑생성
											_div.find('.previews').append('<div class="title-box" style="height:57px">'); 
											_div.find('.previews .title-box').append('<div class="logo-img" style="background-image:url('+tableData.funeral.LOGO_IMG+')">');
											_div.find('.previews .title-box').append('<div class="text" style="font-size:25px;">빈소안내</div>');
											_div.find('.previews .title-box').append('<div class="time" style="font-size:20px;">'+new Date().format('MM월dd일 HH시mm분')+'</div>');
											
											//종합 스타일 저장
											var _binso = $('<div class="binso-wrap eight swiper-slide" style="padding:56px 0px 4px;"></div>');
											_binso.css('background-image', 'url("http://211.251.237.150:7080/dsfiles/division/img_division_eight_top_black_'+_style.THUMBNAIL+'.png")');
											var _binsoBox = $('<div class="binso-box">');
// 											_binsoBox.append('<div class="status" style="color:'+_style.STATUS+'"></div>');
											_binsoBox.append('<div class="statusRoot"><div class="status style="color:'+_style.STATUS+'"></div></div>');
											_binsoBox.append('<div class="name" style="color:'+_style.NAME+'"></div>');
											_binsoBox.append('<div class="arrow"></div>');
											_binsoBox.append('<div class="photo"></div>');
// 											_binsoBox.append('<div class="chief-mourner" style="color:'+_style.CHIEF_MOURNER+'"></div>');
											_binsoBox.append('<div class="chief-mourner sangjuRoot" style="color:'+_style.CHIEF_MOURNER+'"><div class="sangjuContainer"><p class="col3"></p></div></div>');
											
											_binsoBox.append('<div class="er-start" style="color:'+_style.ER_START+'">입관</div>');
											_binsoBox.append('<div class="er-start-time" style="color:'+_style.ER_START_TIME+'"></div>');
											_binsoBox.append('<div class="carrying-start" style="color:'+_style.CARRING_START+'">발인</div>');
											_binsoBox.append('<div class="carrying-start-time" style="color:'+_style.CARRING_START_TIME+'"></div>');
											_binsoBox.append('<div class="burial-plot" style="color:'+_style.BURIAL_PLOT+'">장지</div>');
											_binsoBox.append('<div class="burial-plot-name" style="color:'+_style.BURIAL_PLOT_NAME+'"></div>');
											_binso.append(_binsoBox);
											_div.find('.previews-box').append(_binso);
											
											var _binsoClone = _binso.clone(); //복사를 한번 더 하는 이유 : 아래쪽에 each문돌릴 때 미리 복사해놓지 않으면 빈소가 추가되어 복사가 됨.

											//빈소 정보 입력 + 빈소생성
											var i = 0;
											if(this.BINSO_LIST){
												var _binsoArr = this.BINSO_LIST.split(',');
												$.each(_binsoArr, function(idx){
													$.each(_event, function(){
														if(_binsoArr[idx] == this.RASPBERRY_CONNECTION_NO){
															if(i == 0){ // 처음 빈소 정보 입력
																_binso.find('.status').text(this.APPELLATION);
																_binso.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _binso.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _binso.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_binso.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_binso.find('.chief-mourner').data(this);
																
																_binso.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_binso.find('.carrying-start-time').text(this.CARRYING_DT);
																_binso.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 0 && i < 8){ //두번째 빈소 정보 입력 - 2분할(ex. 4분할일 경우 i < 4)
																var _clone = _binsoBox.clone();
																_div.find('.previews .binso-wrap .binso-box').last().after(_clone);
																_clone.find('.status').text(this.APPELLATION);
																_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																_clone.find('.chief-mourner').data(this);
																
																_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
															}else if(i > 7){
																if(i%8 == 0){
																	var _clone = _binsoClone.clone();
																	_div.find('.previews .binso-wrap').last().after(_clone);
																	_clone.find('.binso-box').find('.status').text(this.APPELLATION);
																	_clone.find('.binso-box').find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.binso-box').find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.binso-box').find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.binso-box').find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.binso-box').find('.chief-mourner').data(this);
																	
																	_clone.find('.binso-box').find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.binso-box').find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.binso-box').find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}else{
																	var _clone = _binsoBox.clone();
																	_div.find('.previews .binso-wrap').last().find('.binso-box').last().after(_clone);
																	_clone.find('.status').text(this.APPELLATION);
																	_clone.find('.name').text("故 "+this.DM_NAME+" "+isNull(this.DM_POSITION, '')+"("+(this.DM_GENDER == 1 ? '남' : '여')+(this.DM_AGE ? ",  "+this.DM_AGE+"세" : "")+")");
																	if(this.ARROW_NO != 0 && this.ARROW_NO) _clone.find('.arrow').css('background-image', 'url("/resources/icon_arrow/icon_arrow_'+this.ARROW_NO+'.svg")').css('background-color', '#FFF');
																	else _clone.find('.arrow').css('background-image', 'url("")').css('background-color', 'transparent');
																	_clone.find('.photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
																	_clone.find('.chief-mourner').data(this);
																	
																	_clone.find('.er-start-time').text(this.ENTRANCE_ROOM_NO ? this.ENTRANCE_ROOM_START_DT : "-");
																	_clone.find('.carrying-start-time').text(this.CARRYING_DT);
																	_clone.find('.burial-plot-name').text(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '미정');
																}
															}
															i++;
														}
	 												});
												});
											}
											if(i % 8 != 0){ //분할이미지 표현
												var _chk = false;
												var _divideImg = $('<div class="divide-box divide08-box" style="bottom:3px;">');
												$.each(tableData.divideImg, function(){ 
													if(this.DIVIDE == 'divide08'){
														_chk = true;
														_divideImg.data(this);
													}
												});
												if(_chk){
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url("+_divideImg.data('PATH')+")");
												}else{
													_div.find('.previews .previews-box .binso-wrap').last().append(_divideImg);
													_divideImg.css('background-image', "url(http://211.251.237.150:7080/dsfiles/division/img_basic_eight.png)");
												}
											}
											
											//고정 8분할 행사 없을시, 바텀 없을때 대기화면
											if(i == 0){
												_div.find('.title-box').hide();
												if(tableData.waitInfo[0]){
													if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
														_div.find('.previews-box').html("").css('background', '#000');
													}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
														$.each(tableData.waitInfo, function(){
															var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
															_binso.css('background-image', 'url('+this.FILE+')');
															_div.find('.previews-box').append(_binso);
														});
													}else{ //대기화면 동영상
														_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
													}
												}else{
													_div.find('.previews-box').html("").css('background', '#000');
												}
											}
										}
									}
								}
							}
						}else{  //스타일이 없는 경우 - 화면관리에서 한번이라도 수정이 안됨
							
							_div.find('.title-box').hide();
							// V1.1. 스타일 없을시 == 라즈베리 처음 생성 후 --> 빈소등록안되있어서 동영상 보여줌
							if(tableData.waitInfo[0]){
								if(tableData.waitInfo[0].SCREEN_TYPE == 0){ // 대기화면 미사용
									_div.find('.previews-box').html("").css('background', '#000');
								}else if(tableData.waitInfo[0].SCREEN_TYPE == 1){ // 대기화면 사진슬라이드
									$.each(tableData.waitInfo, function(){
										var _binso = $('<div class="binso-wrap one swiper-slide"></div>');
										_binso.css('background-image', 'url('+this.FILE+')');
										_div.find('.previews-box').append(_binso);
									});
								}else{ //대기화면 동영상
									_div.find('.previews-box').html('<video style="width:100%; height:100%;" controls><source src="'+tableData.waitInfo[0].FILE+'"/></video>');
								}
							}else{
								//등록된 대기화면 아무것도 없을시 검은화면
								_div.find('.previews-box').html("").css('background', '#000');
							}
						}
						
						// 화살표 노출 부분
						if(this.ARROW_FLAG == 0) _div.find('.arrow').hide();
						$('.previews-wrap').append(_div);

						//유가족 만들기
						$.each(_div.find('.chief-mourner'), function(){
							$(this).fnBinsoFamily($(this).data('EVENT_NO'), tableData.family);
						});
						
						$.each(_div.find('.statusRoot'), function(){
							setBinso($(this));
						});
					}
					
					// 슬라이드 부분 - loop시 3개까지 복제 되서 length > 1 이상만 슬라이드 되게 함.
					if(_div){
						if(_div.find('.previews .previews-box .binso-wrap').length > 1){
							if(this.SLIDE_EFFECT == 1){
								var swiper = new Swiper('.slide_'+idx,{
									effect : "slide",
									width : 1044,
									centeredSlides: true,
								      	autoplay: {
								      		disableOnInteraction : false, //마우스 클릭해도 슬라이드 재생
								        	delay: this.SLIDE_SEC*1000
								      	},
									loop: true
								});
							}else if(this.SLIDE_EFFECT == 0){
								var swiper = new Swiper('.slide_'+idx,{
									effect : "fade",
									speed : 10,
									width : 1044,
									centeredSlides: true,
								      	autoplay: {
								      		disableOnInteraction : false, //마우스 클릭해도 슬라이드 재생
								        	delay: this.SLIDE_SEC*1000
								      	},
									loop: true
								});
							}else{
								var swiper = new Swiper('.slide_'+idx,{
									effect : "fade",
									speed : 10,
									width : 1044,
									centeredSlides: true,
								      	autoplay: {
								      		disableOnInteraction : false, //마우스 클릭해도 슬라이드 재생
								        	delay: 5000
								      	},
									loop: true
								});
							}
						}
					}
				});
				_layer02.find('input[name=binsoCheck]').pbCheckbox({ color:'blue', allCheckedElement:$('input[name="binsoAllCheck"]') });

	 			var _topClock = setInterval(function() {
	 				$('.previews-wrap .previews .title-box .time').html(new Date().format('MM월dd일 HH시mm분'));
	 				$('.status-plate-previews .previews .title-box .time').html(new Date().format('MM월dd일 HH시mm분'));
	 			}, 1000);

			});
		};
// 		createTable(searchObj);
		
		//저장버튼
		$('.pb-right-popup-wrap .top-button.register').on('click', function() {
			var _btnValue = $(this).val();
			var _data = $(this).data();
			var _form = $('#dataForm30');
			if(!$('input[name=binsoCheck]:checked').length) return alert('적용할 빈소를 선택해주세요.');
			else if(!necessaryChecked(_form)) {
				var _uploadUrl = _btnValue ? '/admin/updateRaspberryStatusPlate.do':'/admin/insertRaspberryStatusPlate.do';
				var _formData = new FormData(_form[0]);
				_formData.append('actionUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('funeralNo', $('.select-box-wrap .table-search').data('funeralNo'));
				_formData.append('classification', _data.CLASSIFICATION);
				
				if(_data.RASPBERRY_CONNECTION_NO) _formData.append('raspberryConnectionNo', _data.RASPBERRY_CONNECTION_NO);
				_formData.append('statusPlateNo', _btnValue ? _btnValue:'');
				var _binsoList = [];
				$.each($('input[name=binsoCheck]:checked'), function() {
					_binsoList.push($(this).val());
				});

				_formData.append('division', _layer02.find('select[name=division]').val());
				_formData.append('fcmClassification', _data.CLASSIFICATION);
				_formData.append('binsoList', (_binsoList.length ? _binsoList:''));
				_formData.append('originMultiMode', _data.MULTI_MODE);
				_formData.append('statusPlateStyleNo', _form.find('.screen-allboard-wrap .select.ac').parent('.style-item').data('STATUS_PLATE_STYLE_NO'));
				
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
<style>
	.pb-table.list > tbody > tr:hover { background:none; cursor:default; }
	.status-plate-previews { height:725px; }
</style>
<form id="dataForm30">
	<div class="pb-right-popup-wrap full-size" data-classification="30">
		<div class="pb-popup-title">종합현황판 편집</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body half" style="width:960px; overflow:hidden;">
			<div class="popup-body-top">
				<div class="top-title">종합현황판 미리보기</div>
			</div>
			<div class="status-plate-previews">
				<div class="previews-box">
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
					<div class="row-box">
						<label class="title">화살표노출</label>
						<input type="radio" name="arrowFlag" value="1"/><input type="radio" name="arrowFlag" value="0"/>
					</div>
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">슬라이드효과</label>
						<input type="radio" name="slideEffect" value="1"/><input type="radio" name="slideEffect" value="0"/>
					</div>
					<div class="row-box">
						<label class="title">화면간격</label>
						<select class="form-select" name="slideSec"></select>
					</div>
				</div>
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title">하단안내</label>
						<input type="text" class="form-text" name="bottomText"/>
					</div>
				</div>
			</div>
			
			<div class="popup-body-top" style="padding:16px 0 15px 0;">
				<div class="top-title" style="padding:0;">화면분할 설정</div>
			</div>
			<div class="pb-popup-form">
				<div class="form-box-st-01 half">
					<div class="row-box">
						<div class="disable"></div>
						<label class="title">분할모드</label>
						<input type="radio" name="divisionMode" value="1"/><input type="radio" name="divisionMode" value="2"/>
					</div>
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<div class="disable"></div>
						<label class="title">화면분할</label>
						<select class="form-select" name="division">
							<option value="1">1분할</option>
							<option value="2">2분할</option>
							<option value="4">4분할</option>
							<option value="6">6분할</option>
							<option value="8">8분할</option>
						</select>
					</div>
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">멀티모드</label>
						<input type="radio" name="multiMode" value="1"/><input type="radio" name="multiMode" value="2"/>
					</div>
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">멀티이름</label>
						<select class="form-select" name="multiName">
							<option value="멀티그룹01">멀티그룹01</option>
							<option value="멀티그룹02">멀티그룹02</option>
							<option value="멀티그룹03">멀티그룹03</option>
							<option value="멀티그룹04">멀티그룹04</option>
							<option value="멀티그룹05">멀티그룹05</option>
						</select>
					</div>
				</div>
			</div>
			
			<div class="popup-body-top" style="padding:6px 0;">
				<div class="top-title">종합현황판 스타일</div>
				<div class="top-button-wrap half-text" style="top:-11px;">적용할 빈소</div>
			</div>
			<div class="pb-popup-form half" style="vertical-align:top;">
				<div class="screen-allboard-wrap"></div>
			</div>
			<div class="pb-popup-form half" style="height:277px; margin-left:20px; overflow-y:auto;">
				<table class="pb-table list" style="border:none;">
					<colgroup>
						<col width="10%"/>
						<col width="*"/>
					</colgroup>
					<thead>
						<tr>
							<th><input type="checkbox" name="binsoAllCheck"/></th>
							<th>빈소명</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
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
	<div class="title">종합현황판 관리</div>
	<div class="sub-title">화면을 관리할 수 있습니다.</div>
</div>
<div class="contents-body-wrap">
	<div class="previews-wrap"></div>
</div>