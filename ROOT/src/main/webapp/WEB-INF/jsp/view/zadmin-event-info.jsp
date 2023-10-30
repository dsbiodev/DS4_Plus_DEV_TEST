<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$('input[name=dmGender]').siteRadio({ addText:['남자', '여자'], width:'calc(64% / 3 / 2)', defaultValue:1 });
		$('input[name=dmRegNumber]').on('keyup', function() { if($(this).val()) $(this).val($(this).val().replace(/[^0-9]*/gi, '')); });
		$('input[name=cmPhone]').phoneFomatter();
		$('.obituary-phone').phoneFomatter();
		
		$('.obituary-phone-wrap').crtPbWrapper({ textHint:'숫자만 입력', textFormat:'phone' });
		$('.event-info-box.bugojang').remove();
		
		var crtTimeZone = function(_target, _dateObj, _dFlag) {
			var _defaultFlag = { year:true, month:true, day:true, hour:true, min:true };
			
			$.extend(_defaultFlag, _dFlag);
			_target.find('.body-select.time.year').sysDate('year', { begin:_dateObj.year, maxValue:_dateObj.year+1, unit:'년'} );
			_target.find('.body-select.time.month').sysDate('month', { unit:'월', selected:(_defaultFlag.month ? (_dateObj.month < 10 ? '0'+_dateObj.month:_dateObj.month):'00') } );
			_target.find('.body-select.time.day').sysDate('day', { unit:'일', selected:(_defaultFlag.day ? (_dateObj.day < 10 ? '0'+_dateObj.day:_dateObj.day):'00') } );
			_target.find('.body-select.time.hour').sysDate('hour', { unit:'시', selected:(_defaultFlag.hour ? (_dateObj.hour < 10 ? '0'+_dateObj.hour:_dateObj.hour):'00') });
			_target.find('.body-select.time.min').sysDate('min', { unit:'분', selected:(_defaultFlag.min ? (_dateObj.min < 10 ? '0'+_dateObj.min:_dateObj.min):'00') });
			
			_target.find('.body-select.time').off().on('change', function() {
				var _year = _target.find('.body-select.time.year').val();
				var _month = _target.find('.body-select.time.month').val();
				var _day = _target.find('.body-select.time.day').val();
				var _hour = _target.find('.body-select.time.hour').val();
				var _min = _target.find('.body-select.time.min').val();
				
				var _rst = new Date(_year+'-'+_month+'-'+_day+"T"+_hour+":"+_min);
				var _tDiff = new Date().getTime() - _rst.getTime();
// 				_tDiff = Math.floor(_tDiff/(1000 * 60 * 60 * 24));
				
				// 달력 없는 일 수정시 다음날 넘어감 ex) 월 31일 없는경우 다음날로 변경
				_target.find('.body-select.time.year').val(_rst.getFullYear());
				_target.find('.body-select.time.month').val((_rst.getMonth()+1) < 10 ? '0'+(_rst.getMonth()+1) : _rst.getMonth()+1);
				_target.find('.body-select.time.day').val(_rst.getDate() < 10 ? '0'+_rst.getDate() : _rst.getDate());
				_target.find('.body-select.time.hour').val(_hour);
				_target.find('.body-select.time.min').val(_min);
				
// 				if(_target.attr('id') != 'deadDtWrap' && 0 < _tDiff) {
// 					alert('현재일 보다 이전일은 선택 불가능합니다.');
// 					_target.find('.body-select.time.year').sysDate('year', { begin:_dateObj.year, maxValue:_dateObj.year+1, unit:'년'} );
// 					_target.find('.body-select.time.month').sysDate('month', { unit:'월', selected:(_defaultFlag.month ? (_dateObj.month < 10 ? '0'+_dateObj.month:_dateObj.month):'00') } );
// 					_target.find('.body-select.time.day').sysDate('day', { unit:'일', selected:(_defaultFlag.day ? (_dateObj.day < 10 ? '0'+_dateObj.day:_dateObj.day):'00') } );
// 				} else {
					var _id = _target.attr('id');
					if(_id == 'entranceRoomDtWrap') {
					} else if(_id == 'entranceRoomStartDtWrap') {
						var _chgDate = $.pb.createDateObj(new Date(_year+'-'+_month+'-'+_day+'T'+((_hour*1+1) < 10 ? '0'+(_hour*1+1):(_hour*1+1))+':'+_min));
						crtTimeZone($('#entranceRoomEndDtWrap'), _chgDate);
						$('.er-start-time').text($('select[name=entranceRoomNo]').val() ? new Date(crtDt($('#entranceRoomStartDtWrap'))).format('MM월dd일 HH시mm분') : "-");
					} else if(_id == 'entranceRoomEndDtWrap') {
					} else if(_id == 'carryingDtWrap') {
						$('.carrying-start').text(new Date(crtDt($('#carryingDtWrap'))).format('MM월dd일 HH시mm분'));
					}
// 				}
			});
			

			// 달력 없는 일 수정시 다음날 넘어감 ex) 월 31일 없는경우 다음날로 변경
			_target.find('.body-select.month, .body-select.day').off().on('change', function() {
				var _year = _target.find('.body-select.time.year').val();
				var _month = _target.find('.body-select.time.month').val();
				var _day = _target.find('.body-select.time.day').val();
				var _hour = _target.find('.body-select.time.hour').val();
				var _min = _target.find('.body-select.time.min').val();
				var _rst = new Date(_year+'-'+_month+'-'+_day);
				
				_target.find('.body-select.time.year').val(_rst.getFullYear());
				_target.find('.body-select.time.month').val(_rst.getMonth()+1);
				_target.find('.body-select.time.day').val(_rst.getDate() < 10 ? '0'+_rst.getDate() : _rst.getDate());
			});
		}
		
		$('input[name=carryingYn]').siteRadio({ addText:['확정', '미정'], matchParent:true, defaultValue:1 });
		$('input[name=carryingYn]').on('change', function() {
			if($(this).val() == 0) $(this).parents('.profile-info-wrap').find('.body-select').attr('disabled', true);
			else $(this).parents('.profile-info-wrap').find('.body-select').attr('disabled', false);
		});
		
		$('input[name=deadClassify]').pbRadiobox({ addText:['별세', '영면', '소천', '선종', '직접입력'], fontSize:'16px', imageSize:'24px' }, function(_this) {
			if(_this.val() == 'direct') _this.parents('.profile-info-wrap').find('.body-text').attr('disabled', false);
			else _this.parents('.profile-info-wrap').find('.body-text').attr('disabled', true).val('');
		});
		
		$('select[name=deadPlace], select[name=deadCause], select[name=funeralSystem]').on('change', function() {
			if($(this).val() == 'direct') $(this).next('.body-text').attr('disabled', false);
			else $(this).next('.body-text').attr('disabled', true).val('');
		});
		
		$('input[name=diagnosisYn], input[name=dischargeYn], input[name=drugYn], input[name=publicProsecutorYn]').siteRadio({ addText:['유', '무', '유', '무', '유', '무', '유', '무'], matchParent:true, defaultValue:0 });

		var gBinsoList = []; //기본 빈소리스트
		// 빈소, 입관실 리스트 생성
		var crtBinsoList = function(_binsoList, _entranceRoomNo) {
			$.pb.ajaxCallHandler('/admin/selectRaspberryConnectionList.do', { funeralNo:_param.funeralNo, order:'APPELLATION ASC' }, function(result) {
				$('.box-body.binso > select.body-select').html('<option value="">선택해주세요</option>');
				$.each(result.list, function() {
					if(this.CLASSIFICATION == 10) {
						$('.box-body.binso > select.body-select').append('<option value="'+this.RASPBERRY_CONNECTION_NO+'">['+this.CLASSIFICATION_NAME+'] '+this.APPELLATION+'</option>');
						$('.box-body.binso > select.body-select').find('option').data(this);
					} else if(this.CLASSIFICATION == 40) {
						$('select[name=entranceRoomNo]').append('<option value="'+this.RASPBERRY_CONNECTION_NO+'" '+(this.RASPBERRY_CONNECTION_NO == _entranceRoomNo ? 'selected':'')+'>'+this.APPELLATION+'</option>');
					}
				});
				
				$.each(_binsoList, function(idx, _value) {
					$('.box-body.binso > select.body-select > option[value="'+this.RASPBERRY_CONNECTION_NO+'"]:eq('+idx+')').prop('selected', true).trigger('change');
					gBinsoList.push(this.RASPBERRY_CONNECTION_NO);
				});
				
				if(_param.eventBinsoNo) $('select[name=nBinso] > option[value="'+_param.eventBinsoNo+'"]').prop('selected', true).trigger('change');
			});
		};

		var _orginRaspList = new Array(); //배열선언 - 기존 빈소리스트 담기
		var _originEnRoom = null;
		if(_param.pk) {
			$.pb.ajaxCallHandler('/admin/selectEventDetail.do', { eventNo:_param.pk, order:'ORDER_NO ASC' }, function(data) {
				var _eventInfo = data.eventInfo[0];
// 				$('input[nmame=eventAliveFlag]').val(_eventInfo.EVENT_ALIVE_FLAG);
				$('input[nmame=funeralName]').val(_eventInfo.FUNERAL_NAME);
				layerInit($('.contents-body-wrap'), _eventInfo);
				$('.status').text(_eventInfo.APPELLATION);setBinso($('.statusRoot'));
				$('.name').html("故 "+_eventInfo.DM_NAME+" "+isNull(_eventInfo.DM_POSITION, '')+"("+(_eventInfo.DM_GENDER == 1 ? '남' : '여')+(_eventInfo.DM_AGE ? ",  "+_eventInfo.DM_AGE+"세" : "")+")");
				
				if(_eventInfo.DM_PHOTO)
					$('.photo').css('background-image', 'url("'+_eventInfo.DM_PHOTO+'")');
				$('.family').text();
				$('.er-start-time').text(_eventInfo.ENTRANCE_ROOM_NO ? new Date(_eventInfo.ENTRANCE_ROOM_START_DT).format('MM월 dd일 HH시mm분') : "-");
				$('.carrying-start').text(new Date(_eventInfo.CARRYING_DT).format('MM월 dd일 HH시mm분'));
				$('.burial-plot-name').text(_eventInfo.BURIAL_PLOT_NAME ? _eventInfo.BURIAL_PLOT_NAME : "미정");
				
				crtBinsoList(data.eventInfo, _eventInfo.ENTRANCE_ROOM_NO);
				if(_eventInfo.DM_PHOTO) $('.profile-photo-wrap > .photo').css('background-image', 'url("'+_eventInfo.DM_PHOTO+'")');
				$('select[name=dmReligion]').crtCommonCode({ target:'RELIGION', selected:String(_eventInfo.DM_RELIGION) });
				
				if(_eventInfo.DEAD_CLASSIFY && !$('input[name=deadClassify][value="'+_eventInfo.DEAD_CLASSIFY+'"]').length) {
					$('input[name=deadClassify][value="direct"]').parents('.pb-radio-label').trigger('click');
					$('#deadClassify').val(_eventInfo.DEAD_CLASSIFY);
				}
				
				if(_eventInfo.DEAD_PLACE && !$('select[name=deadPlace] > option[value="'+_eventInfo.DEAD_PLACE+'"]').length) {
					$('select[name=deadPlace] > option[value="direct"]').prop('selected', true).trigger('change');
					$('#deadPlace').val(_eventInfo.DEAD_PLACE);
				}
				
				if(_eventInfo.FUNERAL_SYSTEM && !$('select[name=funeralSystem] > option[value="'+_eventInfo.FUNERAL_SYSTEM+'"]').length) {
					$('select[name=funeralSystem] > option[value="direct"]').prop('selected', true).trigger('change');
					$('#funeralSystem').val(_eventInfo.FUNERAL_SYSTEM);
				}
				
				if(_eventInfo.DEAD_CAUSE && !$('select[name=deadCause] > option[value="'+_eventInfo.DEAD_CAUSE+'"]').length) {
					$('select[name=deadCause] > option[value="direct"]').prop('selected', true).trigger('change');
					$('#deadCause').val(_eventInfo.DEAD_CAUSE);
				}
				
				$.each(data.eventFamilyInfo, function(idx) {
					if(2 < idx) $('#btnFmilyRow').trigger('click');
					var _targetWrap = $('.box-body.family-body .family-wrap:eq('+idx+')');
					var _target = _targetWrap.find('option[value="'+this.RELATION+'"]');
					
					if(_target.length) _target.prop('selected', true).trigger('change');
					else {
						_targetWrap.find('option[value="direct"]').prop('selected', true).trigger('change');
						_targetWrap.find('.body-text.family').val(this.RELATION);
					}
					
					var _eKeyup = jQuery.Event('keydown', { keyCode: 13 } );
					$.each(this.NAMES.split('^#$%&PB$@!'), function(idx, _value) {
						_targetWrap.find('.chief-mourner-wrap > .wrapper-text').val(_value);
						_targetWrap.find('.chief-mourner-wrap > .wrapper-text').trigger(_eKeyup);
					});
				});
				createTxt(data.eventFamilyInfo);
				
				$.each(data.eventCarInfo, function(idx) {
					if(2 < idx) $('#btnCarRow').trigger('click');
					var _targetWrap = $('.box-body.car-body .profile-info-wrap:eq('+idx+')');
					
					_targetWrap.find('#category').val(this.CATEGORY);
					_targetWrap.find('#number').val(this.NUMBER);
					_targetWrap.find('#name').val(this.NAME);
					_targetWrap.find('#phone').val($.pb.phoneFomatter(this.PHONE));
				});
				
// 				new Date('2019-08-18T14:30').format('yyyy-MM-dd HH:mm')
				crtTimeZone($('#entranceRoomDtWrap'), $.pb.createDateObj(new Date(_eventInfo.ENTRANCE_ROOM_DT.replace(/\s/gi, 'T'))));
				crtTimeZone($('#entranceRoomStartDtWrap'), $.pb.createDateObj(new Date(_eventInfo.ENTRANCE_ROOM_START_DT.replace(/\s/gi, 'T'))));
				crtTimeZone($('#entranceRoomEndDtWrap'), $.pb.createDateObj(new Date(_eventInfo.ENTRANCE_ROOM_END_DT.replace(/\s/gi, 'T'))));
				crtTimeZone($('#carryingDtWrap'), $.pb.createDateObj(new Date(_eventInfo.CARRYING_DT.replace(/\s/gi, 'T'))));
				crtTimeZone($('#deadDtWrap'), $.pb.createDateObj(new Date(_eventInfo.DEAD_DT.replace(/\s/gi, 'T'))));
			});
		} else {
			crtBinsoList();
			$('select[name=dmReligion]').crtCommonCode({ target:'RELIGION' });
			
			var _d = $.pb.createDateObj();
			var _d1 = $.pb.createDateObj(new Date(_d.year, _d.month-1, _d.day+1));
			var _d2 = $.pb.createDateObj(new Date(_d1.year, _d1.month-1, _d1.day, _d1.hour+1));
			var _d3 = $.pb.createDateObj(new Date(_d.year, _d.month-1, _d.day+2));

			crtTimeZone($('#entranceRoomDtWrap'), _d, { hour:false, min:false });
			crtTimeZone($('#entranceRoomStartDtWrap'), _d1);
			crtTimeZone($('#entranceRoomEndDtWrap'), _d2);
			crtTimeZone($('#carryingDtWrap'), _d3);
			crtTimeZone($('#deadDtWrap'), _d, { hour:false, min:false });
		}
		

		// 고인사진 등록		
		$('#btnDmPhoto').on('click', function() { $('input[type=file][name=dmPhoto]').trigger('click'); });
		$('input[type=file]').on('change', function() {
			var _ = $(this);
			
			if(_.val()) {
				var _fileName = _[0].files[0].name;
				if(/(\.png|\.jpg|\.jpeg|\.gif)$/i.test(_fileName) == false) { 
					alert("png, jpg, gif 형식의 파일을 선택하십시오");
					$(this).val('');
				} else {
					$.each(_[0].files, function(idx) {
						var _thisFile = this;
						var reader = new FileReader();
						reader.onload = function(rst) {
							$('.photo').css('background-image', 'url(\''+rst.target.result+'\')');
						};
						reader.readAsDataURL(_thisFile);
					});
				}
			}
		});
		
		// 고인사진 삭제
		$('#btnDmPhotoDelete').on('click', function() { 
			var _file = $('input[type=file][name=dmPhoto]');
			_file.siblings('.photo').css('background-image', '');
			_file.val('');
			if(_param.pk) {
				$.pb.ajaxCallHandler('/admin/deleteDmPhoto.do', { eventNo:_param.pk }, function(deleteResult) { console.log('삭제완료'); });
			}
		});
		
		
		// 주소찾기
		$.getScript('https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js', function(data, textStatus, jqxhr) {
			if(textStatus == 'success') {
				$('input[name=dmAddr]').siblings('.body-text-button').on('click', function() {
					new daum.Postcode({
						oncomplete:function(addrResult) {
							var _addr = '';
							if(addrResult.userSelectedType == 'R') _addr = addrResult.roadAddress;
							else _addr = addrResult.jibunAddress;
							
							$('input[name=dmAddr]').val(_addr);
						}
					}).open();
				});
			}
		});
		
		
		// 상주정보 -> 유가족 관계 리스트
		
		var _familyArr = new Array('상 주', '배우자', '부 군', '미망인', '아 들', '딸', '며느리', '사 위', '자', '녀', '자 부', '손', '외 손', '손 자', '손 녀', '외손자', '외손녀', '夫 ', '妻', '子', '子婦 ', '女', '壻', '孫');
		var fmilyRowBindAction = function(_) {
			_.find('.chief-mourner-wrap').crtPbWrapper({ textWidth:100, textHint:'상주명' });
			
			$.each(_familyArr, function(idx, _value) { _.find('.body-select').append('<option value="'+_value+'">'+_value+'</option>'); });
			_.find('.body-select').append('<option value="direct">직접입력</option>');
			_.find('.body-select').on('change', function() {
				if($(this).val() == 'direct') $(this).siblings('.body-text.family').attr('disabled', false).val('');
				else if($(this).val()) $(this).siblings('.body-text.family').attr('disabled', true).val($(this).val());
				else $(this).siblings('.body-text.family').attr('disabled', true).val('');
			});
			_.find('.body-select').val('direct').change();
			$('.box-body.family-body').append(_);
// 			$(document).scrollTop($('.contents-body-wrap')[0].scrollHeight);
		};
		
		
		// 상주 행 추가
		$('#btnFmilyRow').on('click', function() {
			var _piWrap = $('<div class="family-wrap">');
			_piWrap.append('<input type="text" class="body-text family" disabled>');
			_piWrap.append('<select class="body-select chief-mourner"><option value="">선택</option></select>');
			_piWrap.append('<div class="chief-mourner-wrap"></div>');
			_piWrap.append('<div class="btn-wrap"><button type="button" class="btn-up"></button><button type="button" class="btn-down"></button></div>');
			_piWrap.find('.btn-wrap .btn-up').on('click', function(){ _piWrap.prev().before(_piWrap); createTxt(createMap($('.family-wrap'))) });
			_piWrap.find('.btn-wrap .btn-down').on('click', function(){ _piWrap.next().after(_piWrap); createTxt(createMap($('.family-wrap'))) });
			fmilyRowBindAction(_piWrap);
		}).trigger('click').trigger('click').trigger('click');
		
		
		// 배차 행 추가
		$('.box-body.car-body').find('#phone').phoneFomatter();
		$('#btnCarRow').on('click', function() {
			var _piWrap = $('<div class="profile-info-wrap">');
			_piWrap.append('<input type="text" class="body-text car" id="category" placeholder="차량종류"/>');
			_piWrap.append('<input type="text" class="body-text car" id="number" placeholder="차량번호"/>');
			_piWrap.append('<input type="text" class="body-text car" id="name" placeholder="기사명"/>');
			_piWrap.append('<input type="text" class="body-text car" id="phone" placeholder="연락처"/>');
			_piWrap.find('#phone').phoneFomatter();
			
			$('.box-body.car-body').append(_piWrap);
		}).trigger('click').trigger('click').trigger('click');
		
		
		// 날짜 형식 생성
		var crtDt = function(_wrap) {
			var _rstDt = '';
			_rstDt += _wrap.find('.year').val()+'-';
			_rstDt += _wrap.find('.month').val()+'-';
			_rstDt += _wrap.find('.day').val()+'T';
			
			_rstDt += _wrap.find('.hour').val()+':';
			
			_rstDt += _wrap.find('.min').val()+':00';
			
			return _rstDt;
		};
		
		//미리보기 화면
		$('select[name=nBinso], input[name=dmGender]').on('change', function(){
			if($('select[name=nBinso]').find('option:selected').text() != '선택해주세요'){
				$('.status').text($('select[name=nBinso]').find('option:selected').text().replace('[빈소]', ''));
				setBinso($('.statusRoot'));
			}
			else{
				$('.status').text('');
			}
			$('.name').html("故 "+$('input[name=dmName]').val()+" "+isNull($('input[name=dmPosition]').val(), '')+"("+($('input[name=dmGender]:checked').val() == 1 ? '남' : '여')+($('input[name=dmAge]').val() ? ",  "+$('input[name=dmAge]').val()+"세" : "")+")");
		});
		
		$('input[name=dmPosition], input[name=dmName], input[name=dmAge]').on('keyup', function(){
			$('.name').html("故 "+$('input[name=dmName]').val()+" "+isNull($('input[name=dmPosition]').val(), '')+"("+($('input[name=dmGender]:checked').val() == 1 ? '남' : '여')+($('input[name=dmAge]').val() ? ",  "+$('input[name=dmAge]').val()+"세" : "")+")");
		});
		
		
		$('textarea[name=burialPlotName]').on('keyup', function() {
			var _value = $(this).val();
			if(_value.split('\n').length > 2) {
				alert('장지명은 최대 2줄까지 입력 가능합니다');
				var _txt = _value.split("\n").slice(0, 2);
		        $(this).val(_txt.join("\n"));
			}
			$('.burial-plot-name').text($(this).val() ? $(this).val() : "미정");
		});
		
		//상주명, 관계 직접입력 변경
		$(document).on("keyup", ".body-text.family",function(e){ createTxt(createMap($('.family-wrap'))); });
		$(document).on("keyup", ".wrapper-text",function(e){ 
			if(e.keyCode == 13 || e.keyCode == 8){ 
				//상주 관계 입력해야 생성
				if($(this).parents('.chief-mourner-wrap').siblings('.body-text.family').val().length) createTxt(createMap($('.family-wrap')));
			}
		});
		$(document).on('change', '.body-select.chief-mourner', function() { createTxt(createMap($('.family-wrap'))); });
		$(document).on('click', '.wrapper-item .close', function() { createTxt(createMap($('.family-wrap'))); });
		$(document).on('click', '.family-wrap .btn-up, .family-wrap .btn-down', function() { createTxt(createMap($('.family-wrap'))); });
		
		
			

		//행사 삭제
		$('.event-info-top > .right-wrap > .btn.delete').off().on('click', function(){
			var _rpiBinsoList = '';
			$.each($('.box-body.binso > .body-select'), function(idx) { 
				if($(this).val()) {
					_rpiBinsoList += (idx ? ','+$(this).val():$(this).val());
				}
			});
			$.pb.ajaxCallHandler('/admin/deleteEvent.do', { eventNo:_param.pk, funeralNo:_param.funeralNo, rpiBinsoNo:_rpiBinsoList, eventAliveFlag:$('input[name=eventAliveFlag]').val() }, function(eventAliveRst) {
				$(location).attr('href', '/991001');
			});
		});

		//행사 마감
		$('.event-info-top > .right-wrap > .btn.deadline').off().on('click', function(){
			var _rpiBinsoList = '';
			$.each($('.box-body.binso > .body-select'), function(idx) { 
				if($(this).val()) {
					_rpiBinsoList += (idx ? ','+$(this).val():$(this).val());
				}
			});
			$.pb.ajaxCallHandler('/admin/updateEventAliveFlag.do', { eventNo:_param.pk, funeralNo:_param.funeralNo, eventAliveFlag:0, rpiBinsoNo:_rpiBinsoList }, function(eventAliveRst) {
				if(eventAliveRst) $(location).attr('href', '/991001');
			});
		});

		// 저장
		$('.event-info-top > .right-wrap').find('.btn.save').on('click', function() {
			var _tDiff1 = $.pb.returnTimeDiff(crtDt($('#entranceRoomDtWrap')), crtDt($('#entranceRoomStartDtWrap')));
			var _tDiff2 = $.pb.returnTimeDiff(crtDt($('#entranceRoomDtWrap')), crtDt($('#entranceRoomEndDtWrap')));
			var _tDiff3 = $.pb.returnTimeDiff(crtDt($('#entranceRoomDtWrap')), crtDt($('#carryingDtWrap')));
			var _tDiff4 = $.pb.returnTimeDiff(crtDt($('#entranceRoomStartDtWrap')), crtDt($('#entranceRoomEndDtWrap')));
			var _tDiff5 = $.pb.returnTimeDiff(crtDt($('#entranceRoomStartDtWrap')), crtDt($('#carryingDtWrap')));
			var _tDiff6 = $.pb.returnTimeDiff(crtDt($('#entranceRoomEndDtWrap')), crtDt($('#carryingDtWrap')));
			
			
			//edited by euibo
			if(!$('input[name=cmName]').val()) return alert("대표상주 성함을 입력해 주세요.");
			if(!$('input[name=cmPhone]').val()) return alert("대표상주 연락처를 입력해 주세요.");
			if($('input[name=cmPhone]').val().replace(/[^0-9]*/gi, '').length > 11) return alert("대표상주 연락처가 올바르지 않습니다.");

			if(!$('select[name=entranceRoomNo]').val()) return alert("입관실을 선택해 주세요.");
			if($('select[name=entranceRoomNo]').val()){
				if(_tDiff1.timeDiff <= 0) return alert('입관시작일이 입실일보다 이전일 수 없습니다.');
				else if(_tDiff2.timeDiff <= 0) return alert('입관마감일이 입실일보다 이전일 수 없습니다.');
				else if(_tDiff4.timeDiff <= 0) return alert('입관마감일이 입관시작일보다 이전일 수 없습니다.');
			}
			if($('input[name=carryingYn]:checked').val() != 0){
				if(_tDiff3.timeDiff <= 0) return alert('발인일이 입실일보다 이전일 수 없습니다.');
				if($('select[name=entranceRoomNo]').val()){
					if(_tDiff5.timeDiff <= 0) return alert('발인일이 입관시작일보다 이전일 수 없습니다.');
					else if(_tDiff6.timeDiff <= 0) return alert('발인일이 입관마감일보다 이전일 수 없습니다.');	
				}
			}
			
			if(!necessaryChecked($('#eventSubForm'))) {
				var _url = _param.pk ? '/admin/updateEvent.do' : '/admin/insertEvent.do';
				var _binsoList = [], _overlapBinso = '', _obituaryPhoneList = [], _chiefMournerList = [], _carInfoList = [], _rpiBinsoList = '';
				$.each($('.box-body.binso > .body-select'), function(idx) { 
					if($(this).val()) {
						var _chiefMournerObj = { binsoNo:$(this).val(), orderNo:(idx+1) };
						_overlapBinso += (idx ? ','+$(this).val():$(this).val());
						_binsoList.push(_chiefMournerObj);
						_rpiBinsoList += (idx ? ','+$(this).val():$(this).val());
					}
				});
				
				//빈소 중복체크 하기
				var _binsolap = false;
				for(var i=0; i<_binsoList.length;i++) {
					for(var j=0;j<_binsoList.length;j++){
						if(i != j && _binsoList[i].binsoNo == _binsoList[j].binsoNo) _binsolap = true;
					}
				}if(_binsolap) return alert("중복된 빈소가 있습니다.");

				var _binsoOlpObj = {
					overlapNo:_param.pk, 
					eventAliveFlag:true,
					binsoOverlap:true,
					funeralNo:_param.funeralNo, 
					binsoList:_overlapBinso, 
					entranceRoomDt:new Date().format('yyyy-MM-ddThh:mm:ss') < crtDt($('#entranceRoomDtWrap')) ? crtDt($('#entranceRoomDtWrap')) : new Date().format('yyyy-MM-ddThh:mm:ss'),
// 					entranceRoomDt:crtDt($('#entranceRoomDtWrap')), 
					carryingDt:crtDt($('#carryingDtWrap'))	
				};
				
				var _entranceRoomObj = { 
					overlapNo:_param.pk, 
					eventAliveFlag:true,
					entranceRoomOverlap:true,
					funeralNo:_param.funeralNo, 
					entranceRoomNo:$('select[name=entranceRoomNo]').val(), 
					entranceRoomStartDt:crtDt($('#entranceRoomStartDtWrap')), 
					entranceRoomEndDt:crtDt($('#entranceRoomEndDtWrap'))
				};
				
				$.pb.ajaxCallHandler('/admin/selectEventList.do', _binsoOlpObj, function(binsoOverlap) {
// 					$.pb.ajaxCallHandler('/admin/selectEventList.do', _entranceRoomObj, function(entranceRoomOverlap) {
						if(binsoOverlap.list.length) return alert('선택하신 시간에 사용중인 빈소가 있습니다.');
// 						else if(entranceRoomOverlap.list.length) return alert('선택하신 시간에 사용중인 입관실이 있습니다.');
						else {
							var _formData = new FormData($('#eventSubForm')[0]);
							_formData.append('eventNo', (_param.pk ? _param.pk:''));
							_formData.append('funeralNo', _param.funeralNo);
							_formData.append('funeralName', $('input[name=funeralName]').val());
							_formData.append('actionUserNo', '${sessionScope.loginProcess.USER_NO}');
							
							$.each($('.obituary-phone-wrap > .wrapper-item'), function() { _obituaryPhoneList.push($(this).data('value')); });
							$.each($('.chief-mourner-wrap'), function() { 
								var _ = $(this);
								$.each(_.find('.wrapper-item'), function() {
									var _chiefMournerObj = { relation:_.siblings('.body-select.chief-mourner').val(), name:$(this).data('value') };
									_chiefMournerObj.relation = (_chiefMournerObj.relation == 'direct' ? _.siblings('.body-text.family').val():_chiefMournerObj.relation);
									_chiefMournerList.push(_chiefMournerObj);
								});
							});
							
							var _chkRelation = false;
							$.each(_chiefMournerList, function() { 
								if(!this.relation) _chkRelation = true;
							});
							if(_chkRelation) return alert("상주정보에 관계를 선택해 주세요.");
							
							
							$.each($('.box-body.car-body > .profile-info-wrap'), function() {
								var _ = $(this);
								if(_.find('#category').val() && _.find('#number').val() && _.find('#name').val() && _.find('#phone').val())
									_carInfoList.push({ category: _.find('#category').val(), number: _.find('#number').val(), name: _.find('#name').val(), phone: _.find('#phone').val() });
							});
							
							_formData.append('deadClassifyName', $('#deadClassify').val());
							_formData.append('deadPlaceName', $('#deadPlace').val());
							_formData.append('deadCauseName', $('#deadCause').val());
							_formData.append('funeralSystemName', $('#funeralSystem').val());
							_formData.append('rpiBinsoNo', _rpiBinsoList); // 현재빈소
							gBinsoList.push(_rpiBinsoList);
							_formData.append('orginBinsoNo', gBinsoList.join(',')); //기본빈소
							_formData.append('binsoList', (_binsoList.length ? JSON.stringify(_binsoList):null));
							_formData.append('obituaryPhoneList', _obituaryPhoneList);
							_formData.append('chiefMournerList', (_chiefMournerList.length ? JSON.stringify(_chiefMournerList):''));
							_formData.append('carInfoList', (_carInfoList.length ? JSON.stringify(_carInfoList):''));
							_formData.append('entranceRoomDt', crtDt($('#entranceRoomDtWrap')));
							_formData.append('entranceRoomStartDt', crtDt($('#entranceRoomStartDtWrap')));
							_formData.append('entranceRoomEndDt', crtDt($('#entranceRoomEndDtWrap')));
							_formData.append('carryingDt', crtDt($('#carryingDtWrap')));
							_formData.append('deadDt', crtDt($('#deadDtWrap')));
							_formData.append('orginRaspList', _orginRaspList.join());
							_formData.append('originEnRoom', ($('select[name=entranceRoomNo]').val() == _originEnRoom ? null : _originEnRoom));
							_formData.append('changeBinso', (_rpiBinsoList == _orginRaspList.join()));
							
							$('.ajax-loading').show();
							$.pb.ajaxUploadForm(_url, _formData, function(result) {
								$('.ajax-loading').hide();
								if(result != 0) {
									$.ajax({
										url : 'https://choomo.app/api/v1/event',
										type : 'post',
										async: false,
										data : {'eventNo' : result.EVENT_NO },
										success: function(data) {}
									});
									$(location).attr('href', '/991001');
								} else alert('저장 실패 관리자에게 문의하세요');
							}, '${sessionScope.loginProcess}');
						}
// 					});
				});
			}else{
				if(!$('select[name=nBinso]').val()) return alert("빈소를 선택해 주세요.");
				if(!$('input[name=dmName]').val()) return alert("고인성함을 입력해 주세요.");

			}
		});
		
		$('.event-info-top > .right-wrap').find('.btn.bugo-pop').on('click', function() {
			$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
				document.choomoService.location = 'https://choomo.app/choomo-service?eventNo=' + _param.pk;
// 				_thisLayer.find('.top-button.register').val('');
// 				obituary();
			});
		});
		
// 		$('.obituary-send').on('click', function(){
// 			var _formData = new FormData();
// 			_formData.append('id', new Date().format('yyMMddHHmmss'));
// 			_formData.append('name', $('.obituary-name').val());
// 			_formData.append('phone', $('.obituary-phone').val());
// 			_formData.append('cmName', $('input[name=cmName]').val());
// 			_formData.append('funeralNo', _param.funeralNo);
// 			_formData.append('eventNo', _param.pk);
// 			$.pb.ajaxUploadForm('/admin/insertEventObituary.do', _formData, function(result) {
// 				if(result != 0) {
// 					$('.obituary-phone').val(""); $('.obituary-name').val("");
// 					obituary();
// 				} else alert('저장 실패 관리자에게 문의하세요');
// 			}, '${sessionScope.loginProcess}');
// 		});
		
// 		var obituary = function(){
// 			$('.pb-table.list.bugo.user').find('tbody').html("");
// 			var settingDate = new Date();
// 			settingDate.setMonth(settingDate.getMonth()-1); //한달 전
// 			$.pb.ajaxCallHandler('/admin/selectEventObituaryList.do', { eventNo:_param.pk, date:new Date().format('yyyyMM'), date_1 : settingDate.format('yyyyMM') }, function(tableData) {
// 				$.each(tableData.list, function(idx) {
// 					var _tr = $('<tr>');
// 					_tr.data(this);
// 					_tr.append('<td class="c">'+this.DEST_NAME+'</td>');
// 					_tr.append('<td class="c">'+$.pb.phoneFomatter(this.DEST_PHONE)+'</td>');
// 					if(this.CALL_STATUS == '전송중') _tr.append('<td class="c">전송중</td>');
// 					else _tr.append('<td class="c"><button type="button" class="re-send">재전송</button></td>');	
// 					_tr.find('.re-send').on('click', function(){
// 						var _formData = new FormData();
// 						_formData.append('id', new Date().format('yyMMddHHmmss'));
// 						_formData.append('name', _tr.data('DEST_NAME'));
// 						_formData.append('phone', _tr.data('DEST_PHONE'));
// 						_formData.append('cmName', $('input[name=cmName]').val());
// 						_formData.append('funeralNo', _param.funeralNo);
// 						_formData.append('eventNo', _param.pk);							
// 						$.pb.ajaxUploadForm('/admin/insertEventObituary.do', _formData, function(result) {
// 							if(result != 0) {
// 								$('.obituary-phone').val(""); $('.obituary-name').val("");
// 								obituary();
// 							} else alert('저장 실패 관리자에게 문의하세요');
// 						}, '${sessionScope.loginProcess}');
// 					});
					
					
					
// 					$('.pb-table.list.bugo.user').find('tbody').append(_tr);
// 				});
// 			});
// 		}
		$('.pb-popup-close, .popup-mask').on('click', function(){ closeLayerPopup(); });
	});
</script>
<style>
	.event-info-box > .box-body .obituary-phone-wrap { width:88%; display:inline-block; vertical-align:top; }
	
	.event-info-box > .box-body .chief-mourner-wrap { width:calc(100% - 240px - 66px); display:inline-block; margin-left:16px; padding:5px 10px; border-radius:4px; vertical-align:top; }
	.event-info-box > .box-body .family-wrap { margin-bottom:10px; }
	.event-info-box > .box-body .family-wrap .btn-wrap { margin:0px 0px 0px 10px; height:48px; display:inline-flex; flex-direction:column; vertical-align:top;}
	.event-info-box > .box-body .family-wrap .btn-wrap .btn-up { width:24px; height:24px; background-image:url(/resources/img/icon_family_up.png); background-size:100% 100%; background-color:#DFDFDF; border:1px solid #707070; } 
	.event-info-box > .box-body .family-wrap .btn-wrap .btn-down { width:24px; height:24px; background-image:url(/resources/img/icon_family_down.png); background-size:100% 100%; background-color:#DFDFDF; border:1px solid #707070; }

	button.obituary-send { width:100%; height:56px; background-image:linear-gradient(to bottom, #FF9897, #F650A0); color:#FFFFFF; font-size:18px; }
	.pb-table.list.bugo tr:hover { background:none; }
	.pb-table.list.bugo tr td { cursor:initial; padding:0px; height: 56px; }
	.pb-table.list > tbody .table-text { border:none; }
	.pb-table.list.bugo .re-send { color:#f6509f; text-decoration:underline; font-size:16px; background:#FFF; cursor:pointer; }
	
</style>
<form id="dataForm">
	<div class="pb-right-popup-wrap" style="width:1400px;">
		<div class="pb-popup-title">모바일 부고장 보내기</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<iframe name="choomoService" width="100%" height="100%" scrolling="no" frameborder="0">해당 브라우저는 IFRAME을 지원하지 않습니다.<br/>다른 브라우저를 이용해주세요.</iframe>
<!-- 			<div class="popup-body-top"> -->
<!-- 				<div class="top-title">부고장 받으시는 분</div> -->
<!-- 			</div> -->
			
<!-- 			<table class="pb-table list bugo"> -->
<!-- 				<colgroup> -->
<!-- 					<col width="35%"/> -->
<!-- 					<col width="35%"/> -->
<!-- 					<col width="30%"/> -->
<!-- 				</colgroup> -->
<!-- 				<thead> -->
<!-- 					<tr> -->
<!-- 						<th>이름</th> -->
<!-- 						<th>연락처</th> -->
<!-- 						<th>전송</th> -->
<!-- 					</tr> -->
<!-- 				</thead> -->
<!-- 				<tbody> -->
<!-- 					<tr> -->
<!-- 						<td><input type="text" class="table-text obituary-name" style="text-align:center;" placeholder="이름"/></td> -->
<!-- 						<td><input type="text" class="table-text obituary-phone" style="text-align:center;" placeholder="숫자만"/></td> -->
<!-- 						<td><button type="button" class="obituary-send">전 송</button></td> -->
<!-- 					</tr> -->
<!-- 				</tbody> -->
<!-- 			</table> -->
			
<!-- 			<div class="popup-body-top" style="padding:30px 0;"> -->
<!-- 				<div class="top-title">부고장 발송목록</div> -->
<!-- 			</div> -->
			
<!-- 			<table class="pb-table list bugo user"> -->
<!-- 				<colgroup> -->
<!-- 					<col width="35%"/> -->
<!-- 					<col width="35%"/> -->
<!-- 					<col width="30%"/> -->
<!-- 				</colgroup> -->
<!-- 				<thead> -->
<!-- 					<tr> -->
<!-- 						<th>이름</th> -->
<!-- 						<th>연락처</th> -->
<!-- 						<th>재전송</th> -->
<!-- 					</tr> -->
<!-- 				</thead> -->
<!-- 				<tbody></tbody> -->
<!-- 			</table> -->
		</div>
	</div>
</form>

<div class="event-preview-wrap" style="margin-top:20px;">
	<div class="event-preview-box">
		<div class="statusRoot">
			<div class="status"></div>
		</div>
		<div class="name"></div>
		<div class="photo"></div>
		<div class="family sangjuRoot">
        	<div class='sangjuContainer'>
            	<p class="col3"></p>
        	</div>
		</div>
		<div class="er-start-time"></div>
		<div class="carrying-start"></div>
		<div class="burial-plot-name"></div>
	</div>
</div>

<div class="event-info-box ev" style="margin:20px 0px 10px 0px; width:calc(100% - 700px); height:358px;">
	<div class="box-title">
		비고입력란
		<span class="hint">*행사현황판에 출력 됩니다.</span>
	</div>
	<div class="box-body" style="padding:0px 20px;">
		<textarea class="body-text-area" name="bigo" style="height:100px;" placeholder="예시) 의료비 70%"></textarea>
	</div>
	
	<div class="box-title">
		알림글
		<span class="hint">*모바일 부고장에 표시되는 항목입니다.</span>
	</div>
	<div class="box-body" style="padding:0px 20px;">
		<textarea class="body-text-area" name="storeInfo" style="height:100px;" placeholder="예시글) 해당 장례식장은 코로나 확산방지를 위해 방역 수칙을 준수하고 있으며, 안전하게 방문하여 조문이 가능합니다."></textarea>
	</div>
	
</div>

<input type="hidden" name="eventAliveFlag"/>
<input type="hidden" name="funeralName"/>
<div class="event-info-box ev" style="width:26%">
	<div class="box-title">빈소선택</div>
	<div class="box-body binso" style="margin-right:0px;">
		<label class="title">* 빈소를 한개이상 선택 해 주세요</label>
		<select class="body-select necessary" name="nBinso"></select>
		<select class="body-select mt"></select>
		<select class="body-select mt"></select>
		<select class="body-select mt"></select>
	</div>
</div>
<div class="event-info-box ev" style="width:calc(20% - 20px); margin-left:20px;">
	<div class="box-title">고인사진</div>
	<div class="box-body" style="height:266px;">
		<div class="profile-photo-wrap">
			<input type="file" name="dmPhoto"/>
			<div class="photo"></div>
			<div class="info">
				<div class="info-row">[영정사진양식안내]</div>
				<div class="info-row">규격 : 11R</div>
				<div class="info-row">가로 : 11인치(28cm)</div>
				<div class="info-row">세로 : 14인치(36cm)</div>
				<div class="info-row">파일 : jpg, png 등</div>
			</div>
			<div class="photo-button-wrap">
				<button type="button" class="btn-photo register" id="btnDmPhoto">등록</button>
				<button type="button" class="btn-photo delete" style="margin-left:16px;" id="btnDmPhotoDelete">삭제</button>
			</div>
		</div>
	</div>
</div>
<div class="event-info-box ev" style="width:calc(54% - 20px); margin-left:20px;">
	<div class="box-title">고인 및 상주</div>
	<div class="box-body">
		<div class="profile-info-wrap">
			<label class="info-label">종교</label>
			<select class="body-select info" name="dmReligion"></select>
			<label class="info-label">종교 직위</label>
			<input type="text" class="body-text" name="dmPosition" placeholder="직위"/>
			<label class="info-label info">성별</label>
			<input type="radio" name="dmGender" value="1"/><input type="radio" name="dmGender" value="2"/>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">고인주소</label>
			<input type="text" class="body-text" name="dmAddr" style="width:calc(100% - 24% - 100px - 21.3%);" placeholder="주소" readonly/>
			<button type="button" class="body-text-button">주소찾기</button>
			<label class="info-label">상세주소</label>
			<input type="text" class="body-text" name="dmAddrDetail" placeholder="상세주소"/>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">* 고인성함</label>
			<input type="text" class="body-text necessary" name="dmName" placeholder="성함" maxlength="30"/>
			<label class="info-label">나이</label>
			<input type="text" class="body-text" name="dmAge" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" placeholder="나이"/>
			<label class="info-label">주민번호</label>
			<input type="text" class="body-text" name="dmRegNumber" maxlength="13" placeholder="숫자만"/>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">대표상주</label>
			<input type="text" class="body-text" name="cmName" placeholder="대표상주"/>
			<label class="info-label">상주연락처</label>
			<input type="text" class="body-text tel" name="cmPhone" placeholder="연락처"/>
		</div>
		<div class="profile-info-wrap" style="margin-top:14px;">
			<label class="info-label">상주회사</label>
			<input type="text" class="body-text" name="cmCompany" placeholder="상주회사"/>
			<label class="info-label">상주직위</label>
			<input type="text" class="body-text" name="cmPosition" placeholder="상주직위"/>
		</div>
	</div>
</div>
<div class="event-info-box ev bugojang">
	<div class="box-title">부고장 추가 전송<span class="hint">*연락처 입력 후 키보드 엔터키</span></div>
	<div class="box-body">
		<label class="info-label">전화번호</label>
		<div class="obituary-phone-wrap"></div>
	</div>
</div>
<div class="event-info-box ev half">
	<div class="box-title">행사시간</div>
	<div class="box-body" style="height:342px;">
		<div class="profile-info-wrap">
			<label class="info-label lh">입실일시</label>
			<div class="right-item-wrap" id="entranceRoomDtWrap">
				<select class="body-select time year"></select>
				<select class="body-select time month"></select>
				<select class="body-select time day"></select>
				<select class="body-select time hour"></select>
				<select class="body-select time min"></select>
			</div>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">입관시작</label>
			<select class="body-select" name="entranceRoomNo" style="width:160px;"></select>
			<div class="right-item-wrap" id="entranceRoomStartDtWrap">
				<select class="body-select time year"></select>
				<select class="body-select time month"></select>
				<select class="body-select time day"></select>
				<select class="body-select time hour"></select>
				<select class="body-select time min"></select>
			</div>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label lh">입관마감</label>
			<div class="right-item-wrap" id="entranceRoomEndDtWrap">
				<select class="body-select time year"></select>
				<select class="body-select time month"></select>
				<select class="body-select time day"></select>
				<select class="body-select time hour"></select>
				<select class="body-select time min"></select>
			</div>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">발인일시</label>
			<div class="radio-wrap" style="width:160px;"><input type="radio" name="carryingYn" value="1"/><input type="radio" name="carryingYn" value="0"/></div>
			<div class="right-item-wrap" id="carryingDtWrap">
				<select class="body-select time year"></select>
				<select class="body-select time month"></select>
				<select class="body-select time day"></select>
				<select class="body-select time hour"></select>
				<select class="body-select time min"></select>
			</div>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label lh">사망일시</label>
			<div class="right-item-wrap" id="deadDtWrap">
				<select class="body-select time year"></select>
				<select class="body-select time month"></select>
				<select class="body-select time day"></select>
				<select class="body-select time hour"></select>
				<select class="body-select time min"></select>
			</div>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label" style="padding-top:6px;">사망구분</label>
			<input type="radio" name="deadClassify" value="별세" checked/>
			<input type="radio" name="deadClassify" value="영면"/>
			<input type="radio" name="deadClassify" value="소천"/>
			<input type="radio" name="deadClassify" value="선종"/>
			<input type="radio" name="deadClassify" value="direct"/>
			<div class="right-item-wrap" style="width:calc(100% - 12% - 430px);">
				<input type="text" class="body-text" id="deadClassify" style="width:100%;" placeholder="직접입력" disabled/>
			</div>
		</div>
	</div>
</div>
<div class="event-info-box ev half" style="margin-left:20px;">
	<div class="box-title">상례정보</div>
	<div class="box-body" style="height:auto;">
		<div class="profile-info-wrap">
			<label class="info-label">사망장소</label>
			<select class="body-select" name="deadPlace" style="width:calc(19% - 4px);">
				<option value="집">집</option>
				<option value="병원">병원</option>
				<option value="direct">직접입력</option>
			</select>
			<input type="text" class="body-text" id="deadPlace" style="width:calc(19% - 4px); margin-left:8px;" placeholder="직접입력" disabled/>
			<label class="info-label">사망원인</label>
			<select class="body-select" name="deadCause" style="width:calc(19% - 4px);">
				<option value="자연사">자연사</option>
				<option value="병사">병사</option>
				<option value="변사">변사</option>
				<option value="direct">직접입력</option>
			</select>
			<input type="text" class="body-text" id="deadCause" style="width:calc(19% - 4px); margin-left:8px;" placeholder="직접입력" disabled/>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">장례방식</label>
			<select class="body-select" name="funeralSystem" style="width:calc(19% - 4px);">
				<option value="화장">화장</option>
				<option value="매장">매장</option>
				<option value="direct">직접입력</option>
			</select> 
			<input type="text" class="body-text" id="funeralSystem" style="width:calc(19% - 4px); margin-left:8px;" placeholder="직접입력" disabled/>
			<label class="info-label">장지명</label>
			<textarea class="body-text-area" name="burialPlotName" style="width:38%; vertical-align:top;" placeholder="미 입력시 미정"></textarea>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label" style="font-size:14px;">상조회정보</label>
			<input type="text" class="body-text" name="carryingPlace" style="width:38%;" placeholder=""/>
		</div> 
		<div class="profile-info-wrap"> 
			<label class="info-label">진단서</label>
			<input type="text" class="body-text" name="medicalCertificate" style="width:38%;" placeholder="진단서발행처"/>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label" style="font-size:14px;">진단서발행</label>
			<div class="radio-wrap">
				<input type="radio" name="diagnosisYn" value="1"/><input type="radio" name="diagnosisYn" value="0"/>
			</div>
			<label class="info-label" style="font-size:14px;">퇴원확인서</label>
			<div class="radio-wrap">
				<input type="radio" name="dischargeYn" value="1"/><input type="radio" name="dischargeYn" value="0"/>
			</div>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">약물처리</label>
			<div class="radio-wrap">
				<input type="radio" name="drugYn" value="1"/><input type="radio" name="drugYn" value="0"/>
			</div>
			<label class="info-label" style="font-size:14px;">검사지휘서</label>
			<div class="radio-wrap">
				<input type="radio" name="publicProsecutorYn" value="1"/><input type="radio" name="publicProsecutorYn" value="0"/>
			</div>
		</div>
	</div>
</div>
<div class="event-info-box ev half">
	<div class="box-title">
		상주정보
		<span class="hint">*현황판과 부고장에 등록될 상주 정보를 입력 해 주세요.</span>
		<button type="button" class="title-button" id="btnFmilyRow">상주 행 추가</button>
	</div>
	<div class="box-body family-body"></div>
</div>
<div class="event-info-box ev half" style="margin-left:20px;">
	<div class="box-title">
		배차정보
		<button type="button" class="title-button" id="btnCarRow">배차 행 추가</button>
	</div>
	<div class="box-body car-body"></div>
</div>
