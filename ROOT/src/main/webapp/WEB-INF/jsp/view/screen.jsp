<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<link href="https://fonts.googleapis.com/css?family=Nanum+Gothic:400,700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Noto+Serif+KR:300,400,500&display=swap" rel="stylesheet">
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$('form').attr('onsubmit', 'return false');
		
		var searchObj = $.extend({}, _param);
		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
		searchObj.classifications = '10, 30, 50, 90';
		searchObj.order = 'CLASSIFICATION ASC, APPELLATION ASC';
		
		var _layer01 = $('.pb-right-popup-wrap[data-classification="10"]');
		var _layer02 = $('.pb-right-popup-wrap[data-classification="30"]');
		var _layer03 = $('.pb-right-popup-wrap[data-classification="50"]');
		
		_layer01.find('input[name=screenMode]').siteRadio({ addText:['가로', '세로'], defaultValue:1 });
		_layer01.find('input[name=screenMode]').on('change', function() { _layer01.find('.screen-style-wrap .select.ac').parent('.style-item').trigger('click'); });
		
		
		_layer02.find('input[name=slideEffect], input[name=arrowFlag], input[name=screenMode], input[name=divisionMode]').siteRadio({ addText:['켜기', '끄기', '켜기', '끄기', '자동', '고정'], defaultValue:1 });
		_layer02.find('input[name=multiMode]').siteRadio({ addText:['켜기', '끄기'], defaultValue:2 });
		
		$.each(_layer01.find('.btn-arrow-wrap > .btn-arrow').not('.cancel'), function(idx) { $(this).attr('data-arrow-no', (idx+1)).html('<img src="/resources/icon_arrow/icon_arrow_'+(idx+1)+'.svg"/>'); });
		
		_layer01.find('.btn-arrow-wrap > .btn-arrow').on('click', function() {
			$('.btn-arrow-wrap > .btn-arrow').removeClass('ac');
			$(this).addClass('ac');
		});
		
		_layer01.find('.btn-arrow-wrap > .btn-arrow.cancel').data('arrow-no', 0).trigger('click');
		
		$('select[name=fontType]').on('change', function() {
			if($(this).val()) $('.status-plate-previews .previews').css('font-family', $(this).val());
		});
		
		for(var i=5; i<=10; i++) {
			_layer02.find('select[name=slideSec]').append('<option value="'+i+'">'+i+'초</option>');
			_layer03.find('select[name=slideSec]').append('<option value="'+i+'">'+i+'초</option>');
		}
		
		_layer02.find('select[name=division]').on('change', function() {
			var _selected = $('.screen-allboard-wrap > .style-item > .select.ac');
			if(_selected.length) _selected.parent('.style-item').trigger('click');
		});
		
		_layer02.find('input[name=arrowFlag]').on('change', function() {
			if($(this).val() == 1) $('.previews-box > .previews .table-cell > .arrow').show();
			else $('.previews-box > .previews .table-cell > .arrow').hide();
		});
		
		//멀티모드 radio
		_layer02.find('input[name=multiMode]').on('change', function() {
			//슬라이드효과 화면간격 화면분할 분할모드
			if($(this).val() == 1){
				$('.disable').show();
				$('select[name=multiName]').attr("disabled", false);
			}else{
				$('.disable').hide();
				$('select[name=multiName]').attr("disabled", true);
			}
		});
		
		_layer02.find('input[name=binsoAllCheck]').pbCheckbox({ color:'blue' });
		
		_layer03.find('input[name=screenType]').pbRadiobox({ addText:['미사용', '사진 슬라이드', '동영상'] });
		_layer03.find('input[name=screenMode]').siteRadio({ addText:['가로', '세로'], defaultValue:1 });
		_layer03.find('.pb-radio-label').css('margin-top', '10px');
		
		_layer03.find('input[name=screenType]').on('change', function() {
			var _ = $(this);
			if(_.val() == 1) {
				_layer03.find('.pb-popup-form').not(':first').hide().siblings('.slide').show();
			} else if(_.val() == 2) {
				_layer03.find('.pb-popup-form').not(':first').hide().siblings('.video').show();
			} else _layer03.find('.pb-popup-form').not(':first').hide();
		});
		
		var fileList = [], notDeletePriority = [];
		$.each(_layer03.find('.form-images-wrap > .image-item'), function(idx) {
			var _thisWrap = $(this);
			_thisWrap.attr('data-priority', idx);
			_thisWrap.append('<div class="image-text">'+(idx+1)+'번 사진파일</div>');
			_thisWrap.append('<div class="delete-hover"><div class="delete-hover-text">삭제하기</div></div>');
			_thisWrap.hover(function() {
				if($(this).hasClass('ac')) $(this).find('.delete-hover').show();
			}, function() {
				if($(this).hasClass('ac')) $(this).find('.delete-hover').hide();
			});
			
			_thisWrap.on('click', function() {
				
				_layer03.find('.form-images-wrap > .image-item').removeClass('run');
				if($(this).hasClass('ac')) {
					$(this).find('.image-text').show();
					$(this).find('.delete-hover').hide();
					fileList[_thisWrap.data('priority')] = null;
					$(this).css('background-image', '').removeClass('ac');
					$.each(notDeletePriority, function(idx, _value) {
						if(_thisWrap.data('priority') == _value) notDeletePriority.splice(idx, 1);
					});
				} else $(this).addClass('run').siblings('#slideFileSelector').trigger('click');
			});
			
			fileList.push(null);
		});
		
		$('#btnVideoFile').on('click', function() { $(this).siblings('#videoFile').trigger('click'); });
		_layer03.find('input[type=file]').on('change', function() {
			var _ = $(this);
			var _regex = (_.attr('id') == 'slideFileSelector' ? /(\.png|\.jpg|\.jpeg|\.gif)$/i:/(\.mp4|\.avi|\.mkv|\.wmv)$/i)
			if(_.val()) {
				var _fileName = _[0].files[0].name;
				if(_regex.test(_fileName) == false) { 
					alert("파일 형식이 올바르지 않습니다");
					$(this).val('');
				} else {
					$.each(_[0].files, function(idx) {
						var _thisFile = this;
						var reader = new FileReader();
						reader.onload = function(rst) {
							if(_.attr('id') == 'slideFileSelector') {
								var _target = _.siblings('.image-item.run');
								_target.css('background-image', 'url(\''+rst.target.result+'\')').addClass('ac');
								_target.find('.image-text').hide();
								
								fileList[_target.data('priority')] = _[0].files[0];
							} else if(_.attr('id') == 'videoFile') {
								_.siblings('.form-text').val(_fileName);
							}
						};
						reader.readAsDataURL(_thisFile);
					});
				}
			}
		});
		
		$.pb.ajaxCallHandler('/admin/selectStatusPlateStyle.do', { thumbnail:true }, function(styleData) {
			$.each(styleData, function(idx) {
				var _styleItem = $('<div class="style-item" data-no="'+this.STATUS_PLATE_STYLE_NO+'"></div>');
				_styleItem.data(this).css('background-image', 'url("'+this.FILE+'")');
				_styleItem.append('<span class="select"></span>');
				
				if(this.FLAG == 1) {
					if(_layer01.find('.screen-style-wrap > .style-item').length%4 != 0) _styleItem.addClass('right');
					_layer01.find('.screen-style-wrap').append(_styleItem);
				} else if(this.FLAG == 2) {
					if(_layer02.find('.screen-allboard-wrap > .style-item').length%2 == 1) _styleItem.addClass('right');
					_layer02.find('.screen-allboard-wrap').append(_styleItem);
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
						if(_screenMode == 2) {
							_previews.html('');
							var _pTable1 = $('<div class="previews-table">').css('font-size', '20px').css('font-weight', '500');
							_pTable1.append('<div class="table-rows r1"></div>');

							_pTable1.find('.table-rows.r1').append('<div class="table-cell" style="width:213px;"></div>');
							_pTable1.find('.table-rows.r1').append('<div class="table-cell center" style="width:calc(100% - 213px);"></div>');
							
							var _insideTable = $('<div class="inside-table">').css('height', '276px');
							_insideTable.append('<div class="inside-rows"><div class="inside-cell status" style="height:78px; line-height:78px;">특1호실(지하2층)</div></div>');
							_insideTable.append('<div class="inside-rows"><div class="inside-cell name" style="padding-top:28px; font-size:28px; line-height:40px;">故<br/>김고인(83세)<br/>집사</div></div>');
							_insideTable.find('.inside-rows > .inside-cell').css('width', '100%').css('text-align', 'center').css('vertical-align', 'top');
							
							_pTable1.find('.table-cell').last().html(_insideTable);
							
							var _pTable2 = $('<div class="previews-table">').css('font-size', '20px').css('font-weight', '500');
							_pTable2.append('<div class="table-rows r1"></div>');
							_pTable2.find('.table-rows.r1').append('<div class="table-cell left chief-mourner" style="width:100%; height:299px; vertical-align:top;"><div class="h">배우자</div><div class="names">: 최영희</div>');
							_pTable2.find('.table-rows.r1 > .chief-mourner')
							.append('<div class="h">배우자</div><div class="names">: 최영희</div>')
							.append('<div class="h">아들</div><div class="names">: 김철수, 김철소</div>')
							.append('<div class="h">딸</div><div class="names">: 김영희</div>')
							.append('<div class="h">손자</div><div class="names">: 김손자, 최손자</div>');
							
							var _pTable3 = $('<div class="previews-table">').css('font-size', '20px').css('font-weight', '500');
							_pTable3.append('<div class="table-rows r1"></div><div class="table-rows r2"></div><div class="table-rows r3"></div>');
							_pTable3.find('.table-rows.r1').append('<div class="table-cell center er-start">입 관</div><div class="table-cell center er-start-time">12월 14일 06시 30분</div>');
							_pTable3.find('.table-rows.r2').append('<div class="table-cell center carrying-start">발 인</div><div class="table-cell center carrying-start-time">12월 14일 06시 30분</div>');
							_pTable3.find('.table-rows.r3').append('<div class="table-cell center burial-plot">장 지</div><div class="table-cell center burial-plot-name">성남공원</div>');
							_pTable3.find('.table-rows > .table-cell:first-child').css('width', '94px').css('height', '40px').css('line-height', '40px');
							
							_previews.append(_pTable1);
							_previews.append(_pTable2);
							_previews.append(_pTable3);
						}
						
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
			
			//종합현황판 -> 종합현황판 스타일 클릭
			_layer02.find('.screen-allboard-wrap > .style-item').on('click', function() {
				var _ = $(this);
				_.attr('disabled', true);
				var _divisionVal = _layer02.find('select[name=division] > option:selected').val();
				var _tempStr = $(this).data('FILE').replace('/thumbnail/', '/style/').replace('.svg', '');
				var _fileName = _tempStr+'_0'+_divisionVal;
				
				$.pb.ajaxCallHandler('/admin/selectStatusPlateStyle.do', { flag:2, fileName:_fileName }, function(detailData) {
					var _allBoardObj = detailData[0];
					var _titleVal = _tempStr.slice(-1);
					_layer02.find('.previews-box').html('<div class="top-title">빈 소 안 내</div>');
					
					if(_titleVal == 1) _layer02.find('.previews-box > .top-title').css('background', '');
					else if(_titleVal == 2) _layer02.find('.previews-box > .top-title').css('background', '#F6D25E');
					else if(_titleVal == 3) _layer02.find('.previews-box > .top-title').css('background', '#585858');
					else if(_titleVal == 4) _layer02.find('.previews-box > .top-title').css('background', '#FFEEBE');
					
					if(_divisionVal == 1 || _divisionVal == 4) {
						for(var i=0; i<_divisionVal; i++) {
							var _previews = $('<div class="previews">').css('height', (_divisionVal == 1 ? '465px':'233px')).addClass(_divisionVal == 1 ? '':'half');
							var _pTable1 = $('<div class="previews-table">').css('font-size', (_divisionVal == 1 ? '24px':'12px')).css('font-weight', '500');
							var _pTable2 = $('<div class="previews-table">').css('font-size', (_divisionVal == 1 ? '20px':'12px')).css('font-weight', '500');
							var _pTable3 = $('<div class="previews-table">').css('font-size', (_divisionVal == 1 ? '24px':'12px')).css('font-weight', '500');
							
							_pTable1.append('<div class="table-rows r1"></div>');
							_pTable1.find('.table-rows.r1').append('<div class="table-cell left name" style="width:38%; padding-left:10px;">故 김고인 권사 (남, 78세)</div>');
							_pTable1.find('.table-rows.r1').append('<div class="table-cell left status" style="width:56%; letter-spacing:3px;">특1호실(지하2층)</div>');
							_pTable1.find('.table-rows.r1').append('<div class="table-cell right"><button type="button" class="arrow"></button></div>');
							_pTable1.find('.table-rows.r1 > .table-cell').css('height', (_divisionVal == 1 ? '56px':'28px'));
							_pTable1.find('.table-rows.r1 > .table-cell > .arrow').css('height', (_divisionVal == 1 ? '56px':'28px')).css('border-radius', (_divisionVal == 1 ? '0 10px 10px 0':'0 5px 5px 0'));
							
							_pTable2.append('<div class="table-rows r2"></div>');
							_pTable2.find('.table-rows.r2').append('<div class="table-cell" style="width:'+(_divisionVal == 1 ? '230px':'115px')+';"></div>');
							_pTable2.find('.table-rows.r2').append('<div class="table-cell left chief-mourner" style="vertical-align:top;">배우자 : 최영희<br/>아들 : 김철수, 김철소<br/>딸 : 김영희</div>');
							_pTable2.find('.table-rows.r2 > .chief-mourner').css('height', (_divisionVal == 1 ? '306px':'154px')).css('padding', (_divisionVal == 1 ? '14px 12px':'8px 6px'));
							
							_pTable3.append('<div class="table-rows r3"></div>');
							_pTable3.find('.table-rows.r3').append('<div class="table-cell" style="width:'+(_divisionVal == 1 ? '457px':'226.5px')+';"></div>');
							_pTable3.find('.table-rows.r3').append('<div class="table-cell burial-plot" style="width:'+(_divisionVal == 1 ? '145px':'75px')+'; padding-left:'+(_divisionVal == 1 ? '6px':'3px')+';">장 지</div>');
							_pTable3.find('.table-rows.r3').append('<div class="table-cell burial-plot-name" style="padding-left:'+(_divisionVal == 1 ? '6px':'3px')+';">성남공원</div>');
							
							var _insideTable = $('<div class="inside-table">');
							_insideTable.append('<div class="inside-rows"><div class="inside-cell er-start">입 관</div><div class="inside-cell er-start-time">12월 14일 06시 30분</div></div>');
							_insideTable.append('<div class="inside-rows"><div class="inside-cell carrying-start">발 인</div><div class="inside-cell carrying-start-time">12월 14일 06시 30분</div></div>');
							_insideTable.find('.inside-rows > .inside-cell').css('height', (_divisionVal == 1 ? '49px':'24.5px'));
							_insideTable.find('.inside-rows > .inside-cell:first-child').css('width', (_divisionVal == 1 ? '140px':'70px'));
							_insideTable.find('.inside-rows > .inside-cell:last-child').css('padding-left', (_divisionVal == 1 ? '5px':'2.5px'));
							_insideTable.find('.er-start, .er-start-time').css('padding-bottom', (_divisionVal == 1 ? '5px':'2.5px'));
							
							_pTable3.find('.table-rows.r3 > .table-cell').first().append(_insideTable);
							
							_previews.append(_pTable1).append(_pTable2).append(_pTable3);
							_layer02.find('.previews-box').append(_previews);
						}
					} else {
						if(_divisionVal == 2) {
							for(var i=0; i<_divisionVal; i++) {
								var _previews = $('<div class="previews">').css('height', '231px');
								var _pTable1 = $('<div class="previews-table">').css('font-size', '20px').css('font-weight', '500');
								var _pTable2 = $('<div class="previews-table">');
								
								_pTable1.append('<div class="table-rows r1"></div>');
								_pTable1.find('.table-rows.r1').append('<div class="table-cell left name" style="width:40%; padding-left:10px;">故 김고인 권사 (남, 78세)</div>');
								_pTable1.find('.table-rows.r1').append('<div class="table-cell left status" style="width:54%; letter-spacing:3px;">특1호실(지하2층)</div>');
								_pTable1.find('.table-rows.r1').append('<div class="table-cell right"><button type="button" class="arrow"></button></div>');
								_pTable1.find('.table-rows.r1 > .table-cell').css('height', '39px');
								_pTable1.find('.table-rows.r1 > .table-cell > .arrow').css('height', '39px').css('border-radius', (_divisionVal == 1 ? '0 10px 10px 0':'0 6px 6px 0'));
								
								_pTable2.append('<div class="table-rows r2"></div>');
								_pTable2.find('.table-rows.r2').append('<div class="table-cell" style="width:16%;"></div>');
								_pTable2.find('.table-rows.r2').append('<div class="table-cell left chief-mourner" style="vertical-align:top;">배우자 : 최영희<br/>아들 : 김철수, 김철소<br/>딸 : 김영희</div>');
								_pTable2.find('.table-rows.r2 > .chief-mourner').css('width', '529px').css('padding', '8px').css('font-size', '16px');
								_pTable2.find('.table-rows.r2').append('<div class="table-cell" style="vertical-align:top;"></div>');
								
								var _insideTable = $('<div class="inside-table">').css('font-size', '16px');
								_insideTable.append('<div class="inside-rows"><div class="inside-cell er-start">입 관</div><div class="inside-cell er-start-time">12월 14일 06시 30분</div></div>');
								_insideTable.append('<div class="inside-rows"><div class="inside-cell carrying-start">발 인</div><div class="inside-cell carrying-start-time">12월 14일 06시 30분</div></div>');
								_insideTable.append('<div class="inside-rows"><div class="inside-cell burial-plot">장 지</div><div class="inside-cell burial-plot-name">성남공원</div></div>');
								_insideTable.find('.inside-rows > .inside-cell').css('height', '60px').css('padding-top', '4px');
								_insideTable.find('.inside-rows > .inside-cell:first-child').css('width', '78px');
								_pTable2.find('.table-rows.r2 > .table-cell').last().append(_insideTable);
								
								
								_previews.append(_pTable1).append(_pTable2);
								_layer02.find('.previews-box').append(_previews);
							}
						} else if(_divisionVal == 6 || _divisionVal == 8) {
							for(var i=0; i<_divisionVal; i++) {
								var _previews = $('<div class="previews half">').css('height', (_divisionVal == 6 ? '154px':'115.5px')).css('font-weight', 'normal');
								var _pTable1 = $('<div class="previews-table">').css('font-size', '10px');
								var _pTable2 = $('<div class="previews-table">');
								
								_pTable1.append('<div class="table-rows r1"></div>');
								_pTable1.find('.table-rows.r1').append('<div class="table-cell left name" style="width:40%; padding-left:4px;">故 김고인 권사 (남, 78세)</div>');
								_pTable1.find('.table-rows.r1').append('<div class="table-cell left status" style="width:54%; letter-spacing:3px;">특1호실(지하2층)</div>');
								_pTable1.find('.table-rows.r1').append('<div class="table-cell right"><button type="button" class="arrow"></button></div>');
								_pTable1.find('.table-rows.r1 > .table-cell').css('height', (_divisionVal == 6 ? '27px':'23px'));
								_pTable1.find('.table-rows.r1 > .table-cell > .arrow').css('height', (_divisionVal == 6 ? '27px':'23px')).css('border-radius', (_divisionVal == 1 ? '0 10px 10px 0':'0 4px 4px 0'));
								
								_pTable2.append('<div class="table-rows r2"></div>');
								_pTable2.find('.table-rows.r2').append('<div class="table-cell" style="width:'+(_divisionVal == 6 ? '21':'16')+'%;"></div>');
								_pTable2.find('.table-rows.r2').append('<div class="table-cell left chief-mourner" style="vertical-align:top;">배우자 : 최영희<br/>아들 : 김철수, 김철소<br/>딸 : 김영희</div>');
								_pTable2.find('.table-rows.r2 > .chief-mourner').css('width', (_divisionVal == 6 ? '232px':'262px')).css('padding', '5px 4px').css('font-size', '10px');
								_pTable2.find('.table-rows.r2').append('<div class="table-cell" style="vertical-align:top;"></div>');
								
								var _insideTable = $('<div class="inside-table">').css('font-size', '10px');
								_insideTable.append('<div class="inside-rows"><div class="inside-cell er-start">입 관</div><div class="inside-cell er-start-time">12월14일06시30분</div></div>');
								_insideTable.append('<div class="inside-rows"><div class="inside-cell carrying-start">발 인</div><div class="inside-cell carrying-start-time">12월14일06시30분</div></div>');
								_insideTable.append('<div class="inside-rows"><div class="inside-cell burial-plot">장 지</div><div class="inside-cell burial-plot-name">성남공원</div></div>');
								_insideTable.find('.inside-rows > .inside-cell').css('height', (_divisionVal == 6 ? '42px':'30px')).css('padding-bottom', '1px');
								_insideTable.find('.inside-rows > .inside-cell:first-child').css('width', '32px');
								_pTable2.find('.table-rows.r2 > .table-cell').last().append(_insideTable);
								
								
								_previews.append(_pTable1).append(_pTable2);
								_layer02.find('.previews-box').append(_previews);
							}
						}
					}
					
					var _previews = _layer02.find('.status-plate-previews .previews');
					_previews.css('background-image', 'url("'+_allBoardObj.FILE+'")');
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
			
			_layer01.find('.screen-style-wrap > .style-item:eq(0)').trigger('click');
			_layer02.find('.screen-allboard-wrap > .style-item:eq(0)').trigger('click');
		});
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectRaspberryConnectionList.do', _searchObj, function(tableData) {
				_layer02.find('.pb-table.list > tbody').html('');
				$('.contents-body-wrap').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<div class="screen-item">');
					var _screenWrap = $('.contents-body-wrap > .screen-wrap[data-classification="'+this.CLASSIFICATION+'"]');
					_tr.data(this).html(this.APPELLATION);
					_tr.on('click', function() {
						
						$('.pb-right-popup-wrap[data-classification="'+(_tr.data("CLASSIFICATION") == 90 ? 50:_tr.data("CLASSIFICATION"))+'"]').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.top-button.register').data(_tr.data()).val(_tr.data('STATUS_PLATE_NO'));
							_layer03.find('.form-images-wrap > .image-item').removeClass('ac').css('background-image', '').find('.image-text').show();
							_layer03.find('.form-video-wrap').html('');
							_thisLayer.find('.btn-arrow-wrap .btn-arrow').removeClass('ac');

							fileList = [], notDeletePriority = [];
							layerInit(_thisLayer, _tr.data());
							if(_tr.data('STATUS_PLATE_NO')) {
								if(_tr.data('ARROW_NO') == 0) _thisLayer.find('.btn-arrow-wrap .btn-arrow.cancel').trigger('click');
								else _thisLayer.find('.btn-arrow-wrap .btn-arrow[data-arrow-no="'+_tr.data('ARROW_NO')+'"]').trigger('click');
								
								if(_tr.data('CLASSIFICATION') == 10) _thisLayer.find('.screen-style-wrap .style-item[data-no="'+_tr.data('THUMBNAIL')+'"]').trigger('click');
								else if(_tr.data('CLASSIFICATION') == 30){
									_thisLayer.find('.screen-allboard-wrap > .style-item[data-no="'+_tr.data('STATUS_PLATE_STYLE_NO')+'"]').trigger('click');
									if(!_tr.data('MULTI_MODE'))
										_thisLayer.find('input[name=multiMode][value="2"]').click();
								}
								
								if(_tr.data('CLASSIFICATION') == 50 || _tr.data('CLASSIFICATION') == 90) {
									$.pb.ajaxCallHandler('/admin/selectStatusPlateFiles.do', { statusPlateNo:_tr.data('STATUS_PLATE_NO') }, function(fileData) {
										$.each(fileData, function() {
											if(_tr.data('SCREEN_TYPE') == 1) {
												var _target = $('.form-images-wrap > .image-item[data-priority="'+this.PRIORITY+'"]');
												_target.css('background-image', 'url("'+this.FILE+'")').addClass('ac');
												_target.find('.image-text').hide();
												
												notDeletePriority.push(this.PRIORITY);
											} else if(_tr.data('SCREEN_TYPE') == 2) {
												$('#videoFile').val('').siblings('.form-text').val('');
												$('.form-video-wrap').html('<video style="width:90%; height:auto; max-height:520px;" controls><source src="'+this.FILE+'"/></video>');
											}
										});
									});
								}
							} else { //라즈베리 처음 등록한 후 상태값 없을때
								_layer01.find('.screen-style-wrap > .style-item:eq(0)').trigger('click');
								_layer02.find('.screen-allboard-wrap > .style-item:eq(0)').trigger('click');
								_thisLayer.find('input[name=multiMode][value="2"]').click();
							}
							
							
							if(_tr.data('CLASSIFICATION') == 50) {
								_layer03.find('.pb-popup-title').html('특수화면 편집');
								_layer03.find('.popup-body-top > .top-title').html('특수화면 미리보기');
								_layer03.find('#tmpTitle').css('width', '30px').html('');
								_layer03.find('.form-box-st-01:eq(0)').addClass('half');
								_layer03.find('input[name=screenMode]').attr('disabled', false).parents('.row-box').show();
							} else if(_tr.data('CLASSIFICATION') == 90) {
								_layer03.find('.pb-popup-title').html('대기화면 편집');
								_layer03.find('.popup-body-top > .top-title').html('대기화면 미리보기');
								_layer03.find('.form-box-st-01:eq(0)').removeClass('half');
								_layer03.find('#tmpTitle').css('width', '').html('대기화면');
								_layer03.find('input[name=screenMode]').attr('disabled', true).parents('.row-box').hide();
							}
							
							if(_tr.data('BINSO_LIST')) {
								$.each(_tr.data('BINSO_LIST').split(','), function(idx, _value) {
									$('input[name=binsoCheck][value="'+_value+'"]').parent('.pb-checkbox-label').trigger('click');
								});
							}
						});
					});
					
					if(this.CLASSIFICATION == 10) {
						var _layerTr = $('<tr>');
						_layerTr.append('<td><input type="checkbox" name="binsoCheck" value="'+this.RASPBERRY_CONNECTION_NO+'"/></td>');
						_layerTr.append('<td>'+this.APPELLATION+'</td>');
						
						_layer02.find('.pb-table.list > tbody').append(_layerTr);
						
					}
					
					if(!_screenWrap.length) {
						_screenWrap = $('<div class="screen-wrap" data-classification="'+this.CLASSIFICATION+'">');
						_screenWrap.append('<div class="screen-title">'+this.CLASSIFICATION_NAME+' 현황판 관리</div>');
						_screenWrap.append('<div class="screen-item-wrap"></div>');
						$('.contents-body-wrap').append(_screenWrap);
					}
					
					if(_screenWrap.find('.screen-item').length%5 == 0) _tr.css('margin-left', 0);
					_screenWrap.find('.screen-item-wrap').append(_tr);
				});
				_layer02.find('input[name=binsoCheck]').pbCheckbox({ color:'blue', allCheckedElement:$('input[name="binsoAllCheck"]') });
			});
		};
		createTable(searchObj);
		
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
				_formData.append('funeralNo', '${sessionScope.loginProcess.FUNERAL_NO}');
				_formData.append('classification', _data.CLASSIFICATION);
				
				if(_data.RASPBERRY_CONNECTION_NO) _formData.append('raspberryConnectionNo', _data.RASPBERRY_CONNECTION_NO);
				_formData.append('statusPlateNo', _btnValue ? _btnValue:'');

				if(_data.CLASSIFICATION == 10) {
					_formData.append('arrowNo', $('.btn-arrow-wrap > .btn-arrow.ac').data('arrow-no') ? $('.btn-arrow-wrap > .btn-arrow.ac').data('arrow-no') : 0);
// 					_formData.append('statusPlateStyleNo', _form.find('.screen-style-wrap .select.ac').parent('.style-item').data('STATUS_PLATE_STYLE_NO'));
				} else if(_data.CLASSIFICATION == 30) {
					var _binsoList = [];
					$.each($('input[name=binsoCheck]:checked'), function() {
						_binsoList.push($(this).val());
					});
					
					_formData.append('fcmClassification', _data.CLASSIFICATION);
					_formData.append('binsoList', (_binsoList.length ? _binsoList:''));
					_formData.append('statusPlateStyleNo', _form.find('.screen-allboard-wrap .select.ac').parent('.style-item').data('STATUS_PLATE_STYLE_NO'));
				} else if(_data.CLASSIFICATION == 50 || _data.CLASSIFICATION == 90) {
					var _screenType = $('input[name=screenType]:checked').val();
					if(_screenType == 1) {
						$.each(fileList, function(idx, _value) { if(_value) _formData.append(idx, _value); });
						if(notDeletePriority.length) _formData.append('notDeletePriority', notDeletePriority);
					} else if(_screenType == 2) {
						if($('#videoFile')[0].files.length) _formData.append(0, $('#videoFile')[0].files[0]);
					}
					_formData.append('fcmClassification', (_data.CLASSIFICATION == 50 ? _data.CLASSIFICATION:''));
// 					_formData.append('statusPlateBgNo', '${sessionScope.loginProcess.FUNERAL_NO}');
				}
				$.pb.ajaxUploadForm(_uploadUrl, _formData, function(result) {
					if(result != 0) {
						createTable(searchObj);
						closeLayerPopup();
					} else alert('저장 실패 관리자에게 문의하세요');
				}, '${sessionScope.loginProcess}');
			}
		});
	});
</script>
<style>
	.top-button-wrap.half-text { width:50%; height:100%; box-sizing:border-box; padding:24px 0; color:#707070; font-size:20px; font-weight:500; letter-spacing:1px; }
	.pb-table.list > tbody > tr:hover { background:none; cursor:default; }
	
	.previews.horizontal > .chief-mourner > .h { width:100px; display:inline-block; margin-top:20px; text-align:center; }
	.previews.horizontal > .chief-mourner > .names { width:calc(100% - 100px); margin-top:20px; display:inline-block; }
	
	.previews .chief-mourner > .h { width:100px; display:inline-block; margin-top:20px; text-align:center; }
	.previews .chief-mourner > .names { width:calc(100% - 100px); margin-top:20px; display:inline-block; }
</style>
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
						<div class="status">특1호실(지하2층)</div>
						<div class="name">故 김고인 권사 (남, 78세)</div>
<!-- 						<div class="chief-mourner-bg"></div> -->
						<div class="chief-mourner" style="padding-top:24px;">
							<div class="h">배우자</div><div class="names">: 최영희</div>
							<div class="h">아들</div><div class="names">: 김철수, 김철소</div>
							<div class="h">딸</div><div class="names">: 김영희</div>
							<div class="h">손자</div><div class="names">: 김손자, 최손자</div>
						</div>
						<div class="er-start">입 관</div>
						<div class="er-start-time">12월 14일 06시 30분</div>
						<div class="carrying-start">발 인</div>
						<div class="carrying-start-time">12월 14일 06시 30분</div>
						<div class="burial-plot">장 지</div>
						<div class="burial-plot-name">성남공원</div>
						
						<div class="condolence-call">추모의글</div>
						<div class="condolence-call-text">한승현님께서 조화를 보내셨습니다. "삼가고인의 명복을 빕니다."</div>
					</div>
					<div class="previews vertical"></div>
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
					<div class="top-title">빈 소 안 내</div>
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
							<option value="unBatang">바탕체 (은바탕체)</option>
							<option value="unDotum">돋움체 (은돋움체)</option>
							<option value="unGungseo">궁서체 (은궁서체)</option>
							<option value="unGraphic">그래픽체 (은그래픽)</option>
							<option value="Noto Sans KR">고딕체 (구글 노토 산스)</option>
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
						<div class="disable"></div>
						<label class="title">슬라이드효과</label>
						<input type="radio" name="slideEffect" value="1"/><input type="radio" name="slideEffect" value="0"/>
					</div>
					<div class="row-box">
						<div class="disable"></div>
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
<form id="dataForm50">
	<div class="pb-right-popup-wrap" data-classification="50">
		<div class="pb-popup-title"></div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body" style="width:960px; overflow:hidden;">
			<div class="popup-body-top">
				<div class="top-title"></div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
				</div>
			</div>
			<div class="pb-popup-form">
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title" id="tmpTitle"></label>
						<input type="radio" name="screenType" value="0"/>
						<input type="radio" name="screenType" value="1"/>
						<input type="radio" name="screenType" value="2"/>
					</div>
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">화면모드</label>
						<input type="radio" name="screenMode" value="1"/>
						<input type="radio" name="screenMode" value="2"/>
					</div>
				</div>
			</div>
			<div class="pb-popup-form slide" style="display:none; border-top:none;">
				<div class="form-box-st-01 half">
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">화면간격</label>
						<select class="form-select" name="slideSec"></select>
					</div>
				</div>
				<div class="form-images-wrap">
					<input type="file" id="slideFileSelector"/>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
				</div>
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title full" style="text-align:center;">- 사진은 최대 12장까지 등록가능합니다 -</label>
					</div>
				</div> 
			</div>
			<div class="pb-popup-form video" style="display:none; border-top:none;">
				<div class="form-box-st-01">
					<div class="row-box" style="padding-top:20px; margin-top:0;">
						<label class="title">동영상파일</label>
						<input type="file" id="videoFile"/>
						<input type="text" class="form-text" style="width:calc(100% - 256px);"/>
						<button type="button" class="text-button" id="btnVideoFile">파일찾기</button>
					</div>
				</div>
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title full" style="text-align:center;">- 동영상 파일 크기는 100MB(메가)를 초과할 수 없습니다 -</label>
					</div>
				</div>
				<div class="form-video-wrap"></div>
			</div>
		</div>
	</div>
</form>


<div class="contents-title-wrap">
	<div class="title">화면관리</div>
	<div class="sub-title">화면을 관리할 수 있습니다.</div>
</div>
<div class="contents-body-wrap"></div>