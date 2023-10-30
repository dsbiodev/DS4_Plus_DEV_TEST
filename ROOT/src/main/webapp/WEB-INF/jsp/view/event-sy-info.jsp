<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$('input[name=dmGender]').siteRadio({ addText:['남', '여'], width:'calc(((88% - 58px) / 3) / 4)', defaultValue:1 });
		$('input[name=dmRegNumber]').on('keyup', function() { if($(this).val()) $(this).val($(this).val().replace(/[^0-9]*/gi, '')); });
		$('input[name=cmPhone]').phoneFomatter();
		$('.obituary-phone').phoneFomatter();
		
		var _dateOption = {
	             changeMonth: true, 
	             changeYear: true,
	             nextText: '다음 달',
	             prevText: '이전 달',
	             dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
	             dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'], 
	             monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	             monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	             dateFormat: "yy-mm-dd"      
	        };
		
		$('.body-text.cal').datepicker(_dateOption);
     	$('.body-text.clock').clockpicker(); 
      
      
     	var crtTimeZone = function(_target, _dateObj, _dFlag) {
			var _defaultFlag = { year:true, month:true, day:true, hour:true, min:true };

			$.extend(_defaultFlag, _dFlag);
			_target.first().val(_dateObj.toDayFormat);
			_target.last().val(_defaultFlag.hour ? _dateObj.timeFormat : '00:00');
			
			_target.on('change', function() {
				var _rst = new Date(_target.first().val() + "T" + _target.last().val());
				var _tDiff = new Date().getTime() - _rst.getTime();
				
				var _id = _target.attr('class');
				if(_id.indexOf('entranceRoomDtWrap') != -1) {
					
				} else if(_id.indexOf('entranceRoomStartDtWrap') != -1) {
					var _Date = new Date(_target.first().val()+'T'+_target.last().val());
					_Date = _Date.setHours(_Date.getHours()+1);
					$('.er-start-time').text($('input[name=entranceRoomNo]:checked').val() ? new Date(crtDt($('.entranceRoomStartDtWrap'))).format('MM월dd일 HH시mm분') : "-");
					var _chgDate = $.pb.createDateObj(new Date(_Date));
					crtTimeZone($('.entranceRoomEndDtWrap'), _chgDate);
					
				} else if(_id.indexOf('carryingDtWrap') != -1) {
					$('.carrying-start').text(new Date(crtDt($('.carryingDtWrap'))).format('MM월dd일 HH시mm분'));
				}
			});
		}
		
     	// 입관 value값 변경해야 돼
		$('input[name=entranceRoomNo]').siteRadio({ addText:['1호', '2호'], matchParent:true, defaultValue:1 });
		$('input[name=diagnosisYn], input[name=insuYn], input[name=calYn], input[name=ceremonyYn]').siteRadio({ addText:['O', 'X', 'O', 'X', 'O', 'X', 'O', 'X'], matchParent:true, defaultValue:0 });
		$('input[name=dischargeYn], input[name=drugYn], input[name=publicProsecutorYn]').siteRadio({ addText:['유', '무', '유', '무', '유', '무'], matchParent:true, defaultValue:1 });
		$('select[name=deadClassify], select[name=deadCause], select[name=funeralSystem]').on('change', function() {
			if($(this).val() == 'direct') $(this).next('.body-text').attr('disabled', false);
			else $(this).next('.body-text').attr('disabled', true).val('');
		});
		
		$('input[name=sBinso]').on('click', function(e){
			e.stopPropagation();
			if($('.binso-box').css('display') == 'none') $('.binso-box').css('display', 'flex');
			else $('.binso-box').css('display', 'none');
		});
		
		$('.binso-box').on('click', function(e){
			e.stopPropagation();$('.binso-box').css('display', 'flex');
		});

		$('.main-contents-wrap').not('.binso-box').on('click', function(e){
			e.stopPropagation();$('.binso-box').css('display', 'none');
		});
		
		var gBinsoList = []; //기본 빈소리스트
		// 빈소, 입관실 리스트 생성
		var crtBinsoList = function(_binsoList, _entranceRoomNo) {
			$.pb.ajaxCallHandler('/admin/selectRaspberryConnectionList.do', { funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}', order:'APPELLATION ASC' }, function(result) {
				$('select.body-select.binso').html('<option value="">선택해주세요</option>');
				$.each(result.list, function() {
					if(this.CLASSIFICATION == 10) {
						$('select.body-select.binso').append('<option value="'+this.RASPBERRY_CONNECTION_NO+'">['+this.CLASSIFICATION_NAME+'] '+this.APPELLATION+'</option>');
						$('select.body-select.binso').find('option').data(this);
					}
				});
				$.each(_binsoList, function(idx, _value) {
					$('select.body-select.binso > option[value="'+this.RASPBERRY_CONNECTION_NO+'"]:eq('+idx+')').prop('selected', true).trigger('change');
					gBinsoList.push(this.RASPBERRY_CONNECTION_NO);
				});
				if(_param.eventBinsoNo) $('select[name=nBinso] > option[value="'+_param.eventBinsoNo+'"]').prop('selected', true).trigger('change');
				
				// 삼육은 입관 2개 고정임
				var obj = $.grep(result.list, function(o){return o.CLASSIFICATION == 40});
				$('input[name=entranceRoomNo]:eq(0)').val(obj[0].RASPBERRY_CONNECTION_NO);
				$('input[name=entranceRoomNo]:eq(1)').val(obj[1].RASPBERRY_CONNECTION_NO);
				$('input[name=entranceRoomNo][value='+_entranceRoomNo+']').click();
			});
		};
		
		var _orginRaspList = new Array(); //배열선언 - 기존 빈소리스트 담기
		var _originEnRoom = null;
		if(_param.pk) {
			$.pb.ajaxCallHandler('/admin/selectEventDetail.do', { eventNo:_param.pk, order:'ORDER_NO ASC' }, function(data) {
				// 수정전 빈소 배열
				$.each(data.eventInfo, function(idx, _value) {
					_orginRaspList.push(_value.RASPBERRY_CONNECTION_NO)
				})
				_originEnRoom = data.eventInfo[0].ENTRANCE_ROOM_NO
				
				var _eventInfo = data.eventInfo[0];
				$('input[nmame=eventAliveFlag]').val(_eventInfo.EVENT_ALIVE_FLAG);
				$('input[nmame=funeralName]').val(_eventInfo.FUNERAL_NAME);
				layerInit($('.contents-body-wrap'), _eventInfo);
				
				crtBinsoList(data.eventInfo, _eventInfo.ENTRANCE_ROOM_NO);
				if(_eventInfo.DM_PHOTO) $('.profile-info-wrap .photo').css('background-image', 'url("'+_eventInfo.DM_PHOTO+'")').addClass('ac');
				
				if(_eventInfo.DEAD_CLASSIFY && !$('select[name=deadClassify] > option[value="'+_eventInfo.DEAD_CLASSIFY+'"]').length) {
					$('select[name=deadClassify] > option[value="direct"]').prop('selected', true).trigger('change');
					$('#deadClassify').val(_eventInfo.DEAD_CLASSIFY);
				}
				
				$('input[name=deadPlaceName]').val(_eventInfo.DEAD_PLACE);
				
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
				
				crtTimeZone($('.entranceRoomDtWrap'), $.pb.createDateObj(new Date(_eventInfo.ENTRANCE_ROOM_DT.replace(/\s/gi, 'T'))));
				crtTimeZone($('.entranceRoomStartDtWrap'), $.pb.createDateObj(new Date(_eventInfo.ENTRANCE_ROOM_START_DT.replace(/\s/gi, 'T'))));
				crtTimeZone($('.entranceRoomEndDtWrap'), $.pb.createDateObj(new Date(_eventInfo.ENTRANCE_ROOM_END_DT.replace(/\s/gi, 'T'))));
				crtTimeZone($('.carryingDtWrap'), $.pb.createDateObj(new Date(_eventInfo.CARRYING_DT.replace(/\s/gi, 'T'))));
				crtTimeZone($('.deadDtWrap'), $.pb.createDateObj(new Date(_eventInfo.DEAD_DT.replace(/\s/gi, 'T'))));
				crtTimeZone($('.ceremonyDtWrap'), _eventInfo.CEREMONY_DT ? $.pb.createDateObj(new Date(_eventInfo.CEREMONY_DT.replace(/\s/gi, 'T'))) : '');
			});
		} else {
			crtBinsoList();
			
			var _d = $.pb.createDateObj();
			var _d1 = $.pb.createDateObj(new Date(_d.year, _d.month-1, _d.day+1));
			var _d2 = $.pb.createDateObj(new Date(_d1.year, _d1.month-1, _d1.day, _d1.hour+1));
			var _d3 = $.pb.createDateObj(new Date(_d.year, _d.month-1, _d.day+2));

			crtTimeZone($('.entranceRoomDtWrap'), _d, { hour:false, min:false });
			crtTimeZone($('.entranceRoomStartDtWrap'), _d1);
			crtTimeZone($('.entranceRoomEndDtWrap'), _d2);
			crtTimeZone($('.carryingDtWrap'), _d3);
			crtTimeZone($('.deadDtWrap'), _d, { hour:false, min:false });
			crtTimeZone($('.ceremonyDtWrap'), _d3);
		}
		
		// 고인사진 등록		
		$('#btnDmPhoto').on('click', function() { $('input[type=file][name=dmPhoto]').trigger('click'); });
		$('input[type=file]').on('change', function(e) {
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
								var varUA = navigator.userAgent.toLowerCase(); //userAgent 값 얻기
								$('.photo').addClass('ac');
							    if ( varUA.indexOf('android') > -1) {
							        //안드로이드
							    	$('.photo').css('background-image', rotateImage(e));
							    } else if ( varUA.indexOf("iphone") > -1||varUA.indexOf("ipad") > -1||varUA.indexOf("ipod") > -1 ) {
							        //IOS
							    	$('.photo').css('background-image', 'url(\''+rst.target.result+'\')');
							    } else {
							        //아이폰, 안드로이드 외
							    	$('.photo').css('background-image', 'url(\''+rst.target.result+'\')');
							    }
						};
						reader.readAsDataURL(_thisFile);
					}); 
				}
			}
		});
		
		// 고인사진 삭제
		$('#btnDmPhotoDelete').on('click', function() { 
			if(confirm('사진 삭제는 저장하기를 누르지 않아도 데이터가 삭제됩니다. 삭제 하시겠습니까?')) {
				var _file = $('input[type=file][name=dmPhoto]');
				_file.siblings('.photo').css('background-image', '').removeClass('ac');
				$('.photo').css('background-image', '').removeClass('ac');
				_file.val('');
				if(_param.pk) {
					$.pb.ajaxCallHandler('/admin/deleteDmPhoto.do', { eventNo:_param.pk }, function(deleteResult) { console.log('삭제완료'); });
				}
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
		};
		
		
		// 상주 행 추가
		$('#btnFmilyRow').on('click', function() {
			var _piWrap = $('<div class="family-wrap">');
			_piWrap.append('<select class="body-select chief-mourner"></select>');
			_piWrap.append('<input type="text" class="body-text family" maxlegnth="20" disabled>');
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
			_rstDt += _wrap.first().val();
			_rstDt += 'T';
			_rstDt += _wrap.last().val()+':00';
			return _rstDt;
		};
		
		$('textarea[name=burialPlotName], textarea[name=carryingPlace], textarea[name=bigo]').on('keyup', function() {
			var _value = $(this).val();
			if(_value.split('\n').length > 2) {
				if($(this).attr('name') == 'carryingPlace') alert('상조회는 최대 2줄까지 입력 가능합니다');
				else if($(this).attr('name') == 'burialPlotName') alert('장지명은 최대 2줄까지 입력 가능합니다');
				else alert('비고는 최대 2줄까지 입력 가능합니다');
				var _txt = _value.split("\n").slice(0, 2);
		        $(this).val(_txt.join("\n"));
			}
		});
		
		//상주명, 관계 직접입력 변경
		$(document).on("keyup", ".body-text.family",function(e){ createTxt(createMap($('.family-wrap'))); });
		$(document).on("keyup", ".wrapper-text",function(e){ 
			if(e.keyCode == 13 || e.keyCode == 8){ 
				//상주 관계 입력해야 생성
				if($(this).parents('.chief-mourner-wrap').siblings('.body-text.family').val().length) createTxt(createMap($('.family-wrap')));
			}
			if($(".wrapper-text").is(":focus") && event.key == "Next"){
			}
		});
		
		$(document).on('change', '.body-select.chief-mourner', function() { createTxt(createMap($('.family-wrap'))); });
		$(document).on('click', '.wrapper-item .close', function() { createTxt(createMap($('.family-wrap'))); });
		$(document).on('click', '.family-wrap .btn-up, .family-wrap .btn-down', function() { createTxt(createMap($('.family-wrap'))); });
		
		
		//행사 삭제
// 		$('.event-info-top > .right-wrap > .btn.delete').off().on('click', function(){
// 			if(confirm('삭제된 데이터는 복구할 수 없습니다. 그래도 삭제하시겠습니까? ')) {
// 				var _rpiBinsoList = '';
// 				$.each($('.box-body.binso > .body-select'), function(idx) { 
// 					if($(this).val()) {
// 						_rpiBinsoList += (idx ? ','+$(this).val():$(this).val());
// 					}
// 				});
// 				$.pb.ajaxCallHandler('/admin/deleteEvent.do', { eventNo:_param.pk, funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}', rpiBinsoNo:_rpiBinsoList, eventAliveFlag:$('input[name=eventAliveFlag]').val() }, function(eventAliveRst) {
// 					$(location).attr('href', '/290103');
// 				});
// 			}
// 		});

// 		//행사 마감
// 		$('.event-info-top > .right-wrap > .btn.deadline').off().on('click', function(){
// 			var _rpiBinsoList = '';
// 			$.each($('.body-select.binso'), function(idx) { 
// 				if($(this).val()) {
// 					_rpiBinsoList += (idx ? ','+$(this).val():$(this).val());
// 				}
// 			});
// 			$.pb.ajaxCallHandler('/admin/updateEventAliveFlag.do', { eventNo:_param.pk, funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}', eventAliveFlag:0, rpiBinsoNo:_rpiBinsoList }, function(eventAliveRst) {
// 				if(eventAliveRst) $(location).attr('href', '/290103');
// 			});
// 		});
		
		// 저장
		$('.event-info-top > .right-wrap').find('.btn.save').on('click', function() {
			var _tDiff1 = $.pb.returnTimeDiff(crtDt($('.entranceRoomDtWrap')), crtDt($('.entranceRoomStartDtWrap')));
			var _tDiff2 = $.pb.returnTimeDiff(crtDt($('.entranceRoomDtWrap')), crtDt($('.entranceRoomEndDtWrap')));
			var _tDiff3 = $.pb.returnTimeDiff(crtDt($('.entranceRoomDtWrap')), crtDt($('.carryingDtWrap')));
			var _tDiff4 = $.pb.returnTimeDiff(crtDt($('.entranceRoomStartDtWrap')), crtDt($('.entranceRoomEndDtWrap')));
			var _tDiff5 = $.pb.returnTimeDiff(crtDt($('.entranceRoomStartDtWrap')), crtDt($('.carryingDtWrap')));
			var _tDiff6 = $.pb.returnTimeDiff(crtDt($('.entranceRoomEndDtWrap')), crtDt($('.carryingDtWrap')));
 			
			
			//edited by euibo
			if($('select[name=cmNameFlag]').val()==1){
				if(!$('input[name=cmName]').val()) return alert("대표상주 성함을 입력해 주세요.");
				if(!$('input[name=cmPhone]').val()) return alert("대표상주 연락처를 입력해 주세요.");
				if($('input[name=cmPhone]').val().replace(/[^0-9]*/gi, '').length > 11) return alert("대표상주 연락처가 올바르지 않습니다.");
			}

			if(_tDiff1.timeDiff <= 0) return alert('입관시작일이 입실일보다 이전일 수 없습니다.');
			else if(_tDiff2.timeDiff <= 0) return alert('입관마감일이 입실일보다 이전일 수 없습니다.');
			else if(_tDiff4.timeDiff <= 0) return alert('입관마감일이 입관시작일보다 이전일 수 없습니다.');
			
			if(_tDiff3.timeDiff <= 0) return alert('발인일이 입실일보다 이전일 수 없습니다.');
			
			if(_tDiff5.timeDiff <= 0) return alert('발인일이 입관시작일보다 이전일 수 없습니다.');
			else if(_tDiff6.timeDiff <= 0) return alert('발인일이 입관마감일보다 이전일 수 없습니다.');	
			
			
			if(!necessaryChecked($('#eventSubForm'))) {
				var _url = _param.pk ? '/admin/updateEvent.do' : '/admin/insertEvent.do';
				var _binsoList = [], _overlapBinso = '', _obituaryPhoneList = [], _chiefMournerList = [], _carInfoList = [], _rpiBinsoList = '';
				
				$.each($('.body-select.binso'), function(idx) { 
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
					funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}', 
					binsoList:_overlapBinso, 
					entranceRoomDt:new Date().format('yyyy-MM-ddThh:mm:ss') < crtDt($('.entranceRoomDtWrap')) ? crtDt($('.entranceRoomDtWrap')) : new Date().format('yyyy-MM-ddThh:mm:ss'),
					carryingDt:crtDt($('.carryingDtWrap'))	
				};
				
				var _entranceRoomObj = { 
					overlapNo:_param.pk, 
					eventAliveFlag:true,
					entranceRoomOverlap:true,
					funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}', 
					entranceRoomNo:$('input[name=entranceRoomNo]:checked').val(), 
					entranceRoomStartDt:crtDt($('.entranceRoomStartDtWrap')), 
				};
				
				$.pb.ajaxCallHandler('/admin/selectEventList.do', _binsoOlpObj, function(binsoOverlap) {
					if(binsoOverlap.list.length) return alert('선택하신 시간에 사용중인 빈소가 있습니다.');
					else {
						var _formData = new FormData($('#eventSubForm')[0]);
						_formData.append('eventNo', (_param.pk ? _param.pk:''));
						_formData.append('funeralNo', '${sessionScope.loginProcess.FUNERAL_NO}');
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
						_formData.append('deadPlace', "direct");
						_formData.append('deadCauseName', $('#deadCause').val());
						_formData.append('funeralSystemName', $('#funeralSystem').val());
						_formData.append('rpiBinsoNo', _rpiBinsoList); // 현재빈소
						gBinsoList.push(_rpiBinsoList);
						_formData.append('orginBinsoNo', gBinsoList.join(',')); //기본빈소
						_formData.append('binsoList', (_binsoList.length ? JSON.stringify(_binsoList):null));
						_formData.append('obituaryPhoneList', _obituaryPhoneList);
						_formData.append('chiefMournerList', (_chiefMournerList.length ? JSON.stringify(_chiefMournerList):''));
						_formData.append('carInfoList', (_carInfoList.length ? JSON.stringify(_carInfoList):''));
						_formData.append('entranceRoomDt', crtDt($('.entranceRoomDtWrap')));
						_formData.append('entranceRoomStartDt', crtDt($('.entranceRoomStartDtWrap')));
						_formData.append('entranceRoomEndDt', crtDt($('.entranceRoomEndDtWrap')));
						_formData.append('carryingYn', '1');
						_formData.append('carryingDt', crtDt($('.carryingDtWrap')));
						_formData.append('ceremonyDt', crtDt($('.ceremonyDtWrap')));
						_formData.append('deadDt', crtDt($('.deadDtWrap')));
						_formData.append('orginRaspList', _orginRaspList.join());
						_formData.append('originEnRoom', ($('input[name=entranceRoomNo]:checked').val() == _originEnRoom ? null : _originEnRoom));
						_formData.append('changeBinso', (_rpiBinsoList == _orginRaspList.join()));
						
						$.pb.ajaxUploadForm(_url, _formData, function(result) {
							$('.ajax-loading').hide();
							if(result != 0) {
								$.ajax({
									url : 'https://choomo.app/api/v1/event',
									type : 'post',
									async: false,
									data : {'eventNo' : result.eventNo },
									success: function(data) {}
								});
								$(location).attr('href', '/290103');
							} else alert('저장 실패 관리자에게 문의하세요');
						}, '${sessionScope.loginProcess}');
					}
				});
			}else{
				if(!$('select[name=nBinso]').val()) return alert("빈소를 선택해 주세요.");
				if(!$('input[name=dmName]').val()) return alert("고인성함을 입력해 주세요.");
			}
		});
		
		$('.event-info-top > .right-wrap').find('.btn.bugo-pop').on('click', function() {
			$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
				document.choomoService.location = 'https://choomo.app/choomo-service?eventNo=' + _param.pk;
			});
		});
		
		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
	
	function rotateImage(e){ 
		var files = e.target.files; 
		var fileType = files[0].type; 
		loadImage(files[0], function(img, data){
		img.toBlob(function(blob){
			var rotateFile = new File([blob], files[0].name, {type:fileType}); 
			sel_file = rotateFile;
			var reader = new FileReader();
			reader.onload = function(e){
				$('.photo').css('background-image', 'url(\''+e.target.result+'\')');
				//$("#img").attr("src",e.target.result); 
			}
			reader.readAsDataURL(rotateFile); 
		},fileType)}, { orientation:true})
	}
</script>
<style>
	.event-info-box.ev > .box-body { padding: 20px; }
	.event-info-box > .box-body .info-label { color: #000; }
	.event-info-box > .box-body .body-text { width: calc((88% - 25px) / 3); margin-right: 12px; background: #FFF; }
	.event-info-box > .box-body .body-text.half { width: calc(((88% - 58px) / 3) / 2); }
	.event-info-box > .box-body .body-text-area { background: #FFF; }
	.event-info-box > .box-body .body-select { width: calc((88% - 25px) / 3); margin-right: 12px; background-color: #FFF; }
	.event-info-box > .box-body > .profile-info-wrap { margin-top: 12px; }
	.event-info-box > .box-body > .profile-info-wrap > .radio-wrap { width: calc((88% - 25px) / 3); margin-right: 12px; background-color: #FFF; }
	.event-info-box > .box-body > .profile-info-wrap input:last-child {	margin-right: 0px; }
	.site-radio-label { border: 1px solid #b1b1b1; background: #dfdfdf; color: #000; }
	.site-radio-label.ac { border: 1px solid #157FFb; }
	.event-info-box > .box-body > .profile-info-wrap .photo-box { width: calc(79% - 28px); display: inline-block; vertical-align: top; height: 129px; text-align: center; background: #000; }
	.event-info-box > .box-body > .profile-info-wrap .photo-box .photo { width: 100px; height: 100%; box-sizing: border-box; display: inline-block; border: 1px solid #707070; background-image: url(/resources/img/icon-photo.png); background-color: #FFF; background-repeat: no-repeat; background-position: 50%; vertical-align: top; }
	.event-info-box > .box-body > .profile-info-wrap .photo-box .photo.ac { background-size: 100% 100%; }
	.event-info-box > .box-body > .profile-info-wrap .btn-photo { font-weight: 500; font-stretch: normal; letter-spacing: 0.8px; text-align: center; color: #000000; font-size: 16px; width: calc(79% - 28px); height: 36px; border-radius: 2px; border: solid 1px #b1b1b1; background-image: linear-gradient(to bottom, var(--white), #ebedee); }
	#btnFmilyRow { font-size: 16px; font-weight: 500; color:#157ffb; line-height: 1.88; width: 81px; height: calc(100% - 40px); margin: 0 16px 0 0px; border-radius: 2px; border: solid 1px #157ffb; background-color: #FFF; position:absolute; letter-spacing: 2px; min-height: 60px; }
	.event-info-box > .box-body .body-select.chief-mourner { margin-left: 0px; }
	.event-info-box > .box-body .family-wrap { width: calc(100% - 97px); display: inline-block; vertical-align: top; position: relative; left:97px; margin-bottom:10px; }
    .event-info-box > .box-body .family-wrap:last-child { margin-bottom: 0px; }
    .event-info-box.ev > .box-title { padding: 20px 0 0px 20px; }
	.event-info-box .profile-info-wrap .binso-box { position:absolute; top:35px; left:79px; width:260px; height:165px; background:#FFF; z-index:1; border:1px solid #707070; padding:10px; display:none; flex-direction:column; justify-content:space-around; border-radius:2px; }
	.event-info-box > .box-body .body-select.mt { margin:0px; width:100%; }
	#btnCarRow { font-size: 16px; font-weight: 500; color:#157ffb; line-height: 1.88; width: 81px; height: 100%; margin: 0 16px 0 0px; border-radius: 2px; border: solid 1px #157ffb; background-color: #FFF; position:absolute; letter-spacing: 2px; }
	.car-body .profile-info-wrap { width: calc(100% - 97px); display: inline-block; vertical-align: top; position: relative; left:97px; margin-bottom: 10px; }
	.car-body .profile-info-wrap:last-child { margin-bottom: 0px; }
	.event-info-box > .box-body .body-text.car { width:calc(25% - 12px); margin-right: 0px; }
	.event-info-box > .box-body .chief-mourner-wrap { width:calc(100% - 240px - 66px); display:inline-block; padding:5px 10px; border-radius:4px; vertical-align:top; }
	.event-info-box > .box-body .family { margin-left: 8px; margin-right: 8px; }
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
	<div class="pb-right-popup-wrap" id="bugo-pop" style="width:1400px;">
		<div class="pb-popup-title">모바일 부고장 보내기</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body" id="bugo-pop-body">
			<iframe name="choomoService" width="100%" height="100%" scrolling="no" frameborder="0">해당 브라우저는 IFRAME을 지원하지 않습니다.<br/>다른 브라우저를 이용해주세요.</iframe>
		</div>
	</div>
</form>


<input type="hidden" name="eventAliveFlag"/>
<input type="hidden" name="funeralName"/>
<div class="event-info-box ev" style="width:702px; margin-top:20px;">
	<div class="box-body">
		<div class="profile-info-wrap">
			<label class="info-label">고인정보</label>
			<input type="text" class="body-text necessary" name="dmName" placeholder="성함" maxlength="20"/>
			<input type="text" class="body-text" name="dmPosition" placeholder="세례명" maxlength="20"/>
			<input type="text" class="body-text half" name="dmAge" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" placeholder="나이" maxlength="3"/>
			<input type="radio" name="dmGender" value="1"/><input type="radio" name="dmGender" value="2"/>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label"></label>
			<input type="text" class="body-text" name="deadPlaceName" maxlength="4" placeholder="사망장소"/>
			<input type="text" class="body-text" name="religionTxt" placeholder="종교" maxlength="20"/>
			<textarea class="body-text-area" name="carryingPlace" style="width:calc((88% - 25px) / 3); vertical-align:top;" placeholder="상조회"></textarea>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">상주정보</label>
			<input type="text" class="body-text" name="cmName" placeholder="대표상주" maxlength="20"/>
			<input type="text" class="body-text" name="cmBapName" placeholder="세례명" maxlength="20"/>
			<input type="text" class="body-text" name="cmPhone" placeholder="연락처"/>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">입실정보</label>
			<select class="body-select necessary binso" name="nBinso"></select>
			<input type="text" class="body-text cal entranceRoomDtWrap dt" readonly>
			<input type="text" class="body-text clock entranceRoomDtWrap tm" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">입관정보</label>
			<div class="radio-wrap"><input type="radio" name=entranceRoomNo value="1"/><input type="radio" name="entranceRoomNo" value="0"/></div>
			<input type="text" class="body-text cal entranceRoomStartDtWrap dt" readonly>
			<input type="text" class="body-text clock entranceRoomStartDtWrap tm" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">입관마감</label>
			<label style="width:197px;"></label>
			<input type="text" class="body-text cal entranceRoomEndDtWrap dt" readonly>
			<input type="text" class="body-text clock entranceRoomEndDtWrap tm" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">발인정보</label>
			<textarea class="body-text-area" name="burialPlotName" style="width:185px; margin-right:12px; vertical-align:top;" placeholder="장지명"></textarea>
			<input type="text" class="body-text cal carryingDtWrap dt" readonly>
			<input type="text" class="body-text clock carryingDtWrap tm" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
		</div>
		
		<div class="profile-info-wrap">
			<label class="info-label">예식정보</label>
			<div class="radio-wrap"><input type="radio" name=ceremonyYn value="1"/><input type="radio" name="ceremonyYn" value="0"/></div>
			<input type="text" class="body-text cal ceremonyDtWrap dt" readonly>
			<input type="text" class="body-text clock ceremonyDtWrap tm" style="margin-right:0px;" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label" style="line-height: 36px;">비고</label>
			<textarea class="body-text-area" name="bigo" style="width:calc(100% - 80px); vertical-align:top; height: 60px;" placeholder="예시)동문할인 70%"></textarea>
		</div>
	</div>
</div>

<div class="event-info-box ev" style="width:303px; margin:20px 0px 0px 20px;">
	<div class="box-body">
		<div class="profile-info-wrap">
			<label class="info-label" style="width:31%;">진단서</label>
			<div class="radio-wrap" style="width:calc(79% - 28px); margin-right:0px;"><input type="radio" name=diagnosisYn value="1"/><input type="radio" name="diagnosisYn" value="0"/></div>
		</div>
		
		<div class="profile-info-wrap">
			<label class="info-label" style="width:31%;">인수여부</label>
			<div class="radio-wrap" style="width:calc(79% - 28px); margin-right:0px;"><input type="radio" name=insuYn value="1"/><input type="radio" name="insuYn" value="0"/></div>
		</div>
		
		<div class="profile-info-wrap">
			<label class="info-label" style="width:31%;">정산여부</label>
			<div class="radio-wrap" style="width:calc(79% - 28px); margin-right:0px;"><input type="radio" name=calYn value="1"/><input type="radio" name="calYn" value="0"/></div>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label" style="width:31%;">영정사진</label>
			<input type="file" name="dmPhoto"/>
			<div class="photo-box"><div class="photo"></div></div>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label" style="width:31%;"></label>
			<button type="button" class="btn-photo register" id="btnDmPhoto">사진등록</button>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label" style="width:31%;"></label>
			<button type="button" class="btn-photo delete" id="btnDmPhotoDelete">사진삭제</button>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label" style="width:31%; height:60px;"></label>
		</div>
	</div>
</div>
<div class="event-info-box ev" style="width: calc(100% - 1045px); margin:20px 0px 0px 20px; height: 488px;">
	<div class="box-body" style="height:100%; background: #f0f0f0;">
		<textarea class="body-text-area" name="takeOver" style="width:100%; height:100%;" placeholder="인수인계 사항"></textarea>
	</div>
</div>
<div class="event-info-box ev">
	<div class="box-body" style="position: relative; min-height:100px;">
		<button type="button" class="title-button" id="btnFmilyRow">상주 행 추가</button>
		<div class="box-body family-body"></div>
	</div>
</div>

<div class="event-info-box ev" style="width:702px;">
	<div class="box-title">선택정보</div>
	<div class="box-body">
		<div class="profile-info-wrap">
			<label class="info-label">사망정보</label>
			<input type="text" class="body-text cal deadDtWrap dt" readonly>
			<input type="text" class="body-text clock deadDtWrap tm" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
			<input type="text" class="body-text" name="medicalCertificate" placeholder="진단서발행처"/>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">사망구분</label>
			<select class="body-select" name="deadClassify">
				<option value="별세">별세</option>
				<option value="영면">영면</option>
				<option value="소천">소천</option>
				<option value="별세">별세</option>
				<option value="direct">직접입력</option>
			</select>
			<input type="text" class="body-text" id="deadClassify" maxlength="20" placeholder="직접입력" disabled/>
			<input type="text" class="body-text" name="dmRegNumber" maxlength="13" placeholder="주민번호(숫자만)"/>
		</div>
		
		<div class="profile-info-wrap">
			<label class="info-label">사망원인</label>
			<select class="body-select" name="deadCause">
				<option value="자연사">자연사</option>
				<option value="병사">병사</option>
				<option value="변사">변사</option>
				<option value="direct">직접입력</option>
			</select>
			<input type="text" class="body-text" id="deadCause" placeholder="직접입력" disabled/>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">고인주소</label>
			<input type="text" class="body-text" name="dmAddr" placeholder="주소" style="width:calc((88% - 15px) / 2); margin-right:0px;" readonly/>
			<button type="button" class="body-text-button btn-addr" style="margin:0px 12px 0 0px;">주소찾기</button>
			<input type="text" class="body-text" name="dmAddrDetail" placeholder="상세주소"/>
		</div>
		
		
		<div class="profile-info-wrap">
			<label class="info-label">장례방식</label>
			<select class="body-select" name="funeralSystem">
				<option value="화장">화장</option>
				<option value="매장">매장</option>
				<option value="direct">직접입력</option>
			</select>
			<input type="text" class="body-text" id="funeralSystem" placeholder="직접입력" disabled/>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">상주여부</label>
			<select class="body-select" name="cmNameFlag">
				<option value="1">있음</option>
				<option value="2">없음</option>
			</select>
		</div>
		
		
		<div class="profile-info-wrap" style="position:relative;">
			<label class="info-label">추가빈소</label>
			<input type="text" class="body-text sBinso" name="sBinso" placeholder="빈소" readonly/>
			<div class="binso-box">
				<select class="body-select binso mt"></select>
				<select class="body-select binso mt"></select>
				<select class="body-select binso mt"></select>
			</div>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">퇴원확인</label>
			<div class="radio-wrap"><input type="radio" name="dischargeYn" value="1"/><input type="radio" name="dischargeYn" value="0"/></div>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">약물처리</label>
			<div class="radio-wrap"><input type="radio" name="drugYn" value="1"/><input type="radio" name="drugYn" value="0"/></div>
		</div>
		<div class="profile-info-wrap">
			<label class="info-label">검사지휘</label>
			<div class="radio-wrap"><input type="radio" name="publicProsecutorYn" value="1"/><input type="radio" name="publicProsecutorYn" value="0"/></div>
		</div>
	</div>
</div>
<div class="event-info-box ev" style="width: calc(100% - 722px); margin:0px 0px 0px 20px; min-height: 565px;">
	<div class="box-title">알림글(모바일 부고장에 표시되는 항목입니다.)</div>
	<div class="box-body">
		<div class="profile-info-wrap">
			<textarea class="body-text-area" name="storeInfo" style="height:176px;" placeholder="예시) 저희 상가는 부의금을 정중히 사양합니다. /국민은행 0000-000-0000"></textarea>
		</div>
	</div>
	<div class="box-title">배차정보</div>
	<div class="box-body">
		<div class="profile-info-wrap" style="position:relative;">
			<button type="button" class="title-button" id="btnCarRow">배차 행 추가</button>
			<div class="box-body car-body"></div>
		</div>
	</div>
</div>