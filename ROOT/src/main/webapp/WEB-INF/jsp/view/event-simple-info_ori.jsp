<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$('input[name=dmGender]').siteRadio({ addText:['남자', '여자'], width:'calc(64% / 3 / 2)', defaultValue:1 });
		$('input[name=dmRegNumber]').on('keyup', function() { if($(this).val()) $(this).val($(this).val().replace(/[^0-9]*/gi, '')); });
		
		//염습처리자 input event
		$('input[name=shroudMgr]').on('keyup', function() {
			if($(this).val()) $(this).val($(this).val());
		});
		
		//프리드 div숨김
		var strFuneralNo = ${sessionScope.loginProcess.FUNERAL_NO};			
		var arrHideFuneral = [83,1126];
		var bugoHideFlag = "N";
		
		//프리드 주석처리
		for(var i=0; i<arrHideFuneral.length;i++){
			if(strFuneralNo.toString() == arrHideFuneral[i].toString()){	
				
				bugoHideFlag = "Y";
			}
		}
				
		if(bugoHideFlag == "Y"){			
			$('#cmDiv').hide();
			//$('#cmInfo').hide();
			//$('#cmAdd').hide();
			$('#cmNote').hide();
		}else{
			$('#cmDiv').show();
			//$('#cmInfo').show();
			//$('#cmAdd').show();
			$('#cmNote').show();
		}
		
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
//        	$('#startDate').datepicker('setDate', 'today');
//       	$('#endDate').datepicker('setDate', '-1D'); //(-1D:하루전, -1M:한달전, -1Y:일년전), (+1D:하루후, -1M:한달후, -1Y:일년후)
      	$('.body-text.clock').clockpicker(); 
       
       
		$('.obituary-phone-wrap').crtPbWrapper({ textHint:'숫자만 입력', textFormat:'phone' });
		$('.event-simple-info-scroll').css('height' , $(window).height() - 159);

		//기타정보 클릭
		$('.etc-info').on('click', function(){ $('.profile-info-wrap.etc').toggle(); });
		
		var crtTimeZone = function(_target, _dateObj, _dFlag) {
			var _defaultFlag = { year:true, month:true, day:true, hour:true, min:true };

			$.extend(_defaultFlag, _dFlag);
			_target.first().val(_dateObj.toDayFormat);
			_target.last().val(_defaultFlag.hour ? _dateObj.timeFormat : '00:00');
			
			_target.on('change', function() {
				var _rst = new Date(_target.first().val() + "T" + _target.last().val());
				var _tDiff = new Date().getTime() - _rst.getTime();
// 				_tDiff = Math.floor(_tDiff/(1000 * 60 * 60 * 24));
				
// 				if(_target.attr('class').indexOf('deadDtWrap') == -1 && 0 < _tDiff) {
// 					alert('현재일 보다 이전일은 선택 불가능합니다.');
// 					_target.first().val(_dateObj.toDayFormat);
// 					_target.last().val(_dateObj.timeFormat);
// 				} else {
					var _id = _target.attr('class');
					if(_id.indexOf('entranceRoomDtWrap') != -1) {
						
					} else if(_id.indexOf('entranceRoomStartDtWrap') != -1) {
						var _Date = new Date(_target.first().val()+'T'+_target.last().val());
						_Date = _Date.setHours(_Date.getHours()+1);
						$('.er-start-time').text($('select[name=entranceRoomNo]').val() ? new Date(crtDt($('.entranceRoomStartDtWrap'))).format('MM월dd일 HH시mm분') : "-");
						var _chgDate = $.pb.createDateObj(new Date(_Date));
						crtTimeZone($('.entranceRoomEndDtWrap'), _chgDate);
					} else if(_id.indexOf('entranceRoomEndDtWrap') != -1) {
						
					} else if(_id.indexOf('carryingDtWrap') != -1) {
						$('.carrying-start').text(new Date(crtDt($('.carryingDtWrap'))).format('MM월dd일 HH시mm분'));
					}
// 				}
			});
		}
		
		$('input[name=diagnosisYn], input[name=dischargeYn], input[name=drugYn], input[name=publicProsecutorYn]').siteRadio({ width:'calc(50% - 3px)', addText:['유', '무', '유', '무', '유', '무', '유', '무'], defaultValue:0 });
		$('input[name=carryingYn]').siteRadio({ width:'calc(50% - 3px)', addText:['확정', '미정'], defaultValue:1 });
		
		$('input[name=carryingYn]').on('change', function() {
			if($(this).val() == 0) $('.carryingDtWrap').attr('disabled', true);
			else $('.carryingDtWrap').attr('disabled', false);
		});
		

		$('select[name=deadClassify]').on('change', function() {
			if($(this).val() == 'direct') $('#deadClassify').attr('disabled', false);
			else $('#deadClassify').attr('disabled', true).val('');
		});
		
		$('select[name=deadPlace]').on('change', function() {
			if($(this).val() == 'direct') $('#deadPlace').attr('disabled', false);
			else $('#deadPlace').attr('disabled', true).val('');
		});
		
		$('select[name=deadCause]').on('change', function() {
			if($(this).val() == 'direct') $('#deadCause').attr('disabled', false);
			else $('#deadCause').attr('disabled', true).val('');
		});
		
		$('select[name=funeralSystem]').on('change', function() {
			if($(this).val() == 'direct') $('#funeralSystem').attr('disabled', false);
			else $('#funeralSystem').attr('disabled', true).val('');
		});
		
		//상주여부 프리드
		$('select[name=cmNameFlag]').on('change', function() {
			if ($(this).val() == 2) {
				$('input[name=cmName]').val("");
				$('input[name=cmPhone]').val("");
				//	$('.box-body.family-body').html("");
			} else {
			}
		});

		var gBinsoList = []; //기본 빈소리스트
		// 빈소, 입관실 리스트 생성
		var crtBinsoList = function(_binsoList, _entranceRoomNo) {
			$.pb.ajaxCallHandler('/admin/selectRaspberryConnectionList.do', { funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}', order:'APPELLATION ASC' }, function(result) {
				$('select.body-select.binso').html('<option value="">선택해주세요</option>');
				$.each(result.list, function() {
					if(this.CLASSIFICATION == 10) {
						$('.box-body select.body-select.binso').append('<option value="'+this.RASPBERRY_CONNECTION_NO+'">['+this.CLASSIFICATION_NAME+'] '+this.APPELLATION+'</option>');
					} else if(this.CLASSIFICATION == 40) {
						$('select[name=entranceRoomNo]').append('<option value="'+this.RASPBERRY_CONNECTION_NO+'" '+(this.RASPBERRY_CONNECTION_NO == _entranceRoomNo ? 'selected':'')+'>'+this.APPELLATION+'</option>');
					}
				});
				
				$.each(_binsoList, function(idx, _value) {
					$('.box-body select.body-select.binso > option[value="'+this.RASPBERRY_CONNECTION_NO+'"]:eq('+idx+')').prop('selected', true).trigger('change');
					gBinsoList.push(this.RASPBERRY_CONNECTION_NO);
				});
				
				if(_param.eventBinsoNo) $('select[name=nBinso] > option[value="'+_param.eventBinsoNo+'"]').prop('selected', true).trigger('change');
			});
		};
		
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
// 				console.log(_param.pk, data);
// 				$('input[nmame=eventAliveFlag]').val(_eventInfo.EVENT_ALIVE_FLAG);
				$('input[nmame=funeralName]').val(_eventInfo.FUNERAL_NAME);
				layerInit($('.contents-body-wrap'), _eventInfo);
				$('.status').text(_eventInfo.APPELLATION);setBinso($('.statusRoot'));
				$('.name').html("故 "+_eventInfo.DM_NAME+" "+isNull(_eventInfo.DM_POSITION, '')+"("+(_eventInfo.DM_GENDER == 1 ? '남' : '여')+(_eventInfo.DM_AGE ? ",  "+_eventInfo.DM_AGE+"세" : "")+")");
				$('.photo').css('background-image', 'url("'+_eventInfo.DM_PHOTO+'")');
				$('.family').text();
				$('.er-start-time').text(_eventInfo.ENTRANCE_ROOM_NO ? new Date(_eventInfo.ENTRANCE_ROOM_START_DT).format('MM월 dd일 HH시mm분') : "-");
				$('.carrying-start').text(new Date(_eventInfo.CARRYING_DT).format('MM월 dd일 HH시mm분'));
				$('.burial-plot-name').text(_eventInfo.BURIAL_PLOT_NAME ? _eventInfo.BURIAL_PLOT_NAME : "미정");
				
				crtBinsoList(data.eventInfo, _eventInfo.ENTRANCE_ROOM_NO);
				if(_eventInfo.DM_PHOTO) $('.event-preview-wrap .photo').css('background-image', 'url("'+_eventInfo.DM_PHOTO+'")');
				$('select[name=dmReligion]').crtCommonCode({ target:'RELIGION', selected:String(_eventInfo.DM_RELIGION) });
				
				if(_eventInfo.DEAD_CLASSIFY && !$('select[name=deadClassify] > option[value="'+_eventInfo.DEAD_CLASSIFY+'"]').length) {
					$('select[name=deadClassify] > option[value="direct"]').prop('selected', true).trigger('change');
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
					var _targetWrap = $('.box-body.car-body .car-wrap:eq('+idx+')');
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
				
				//염습일자 조회해야함								
				if(_eventInfo.enshrine_dt == null){
					crtTimeZone($('.enshrine'), $.pb.createDateObj(), { hour:false, min:false });									
				}else{
					crtTimeZone($('.enshrine'), $.pb.createDateObj(new Date(_eventInfo.enshrine_dt.replace(/\s/gi, 'T'))));
				}
				
				if(_eventInfo.shroud_dt == null){
					var _d = $.pb.createDateObj();
					crtTimeZone($('.shroud'), $.pb.createDateObj(new Date(_d.year, _d.month-1, _d.day+1)), { hour:false, min:false });									
				}else{
					crtTimeZone($('.shroud'), $.pb.createDateObj(new Date(_eventInfo.shroud_dt.replace(/\s/gi, 'T'))));		
				}															
				
				$('input[name=shroudMgr]').val(_eventInfo.shroud_mgr);
				
				//프리드							
				if(_eventInfo.cm_flag ==1){
					$('select[name=cmNameFlag]').val(_eventInfo.cm_flag);					
				}else{				
					$('select[name=cmNameFlag]').val("2");			
				}
				
			});
		} else {
			crtBinsoList();
			$('select[name=dmReligion]').crtCommonCode({ target:'RELIGION' });
			
			var _d = $.pb.createDateObj();
			var _d1 = $.pb.createDateObj(new Date(_d.year, _d.month-1, _d.day+1));
			var _d2 = $.pb.createDateObj(new Date(_d1.year, _d1.month-1, _d1.day, _d1.hour+1));
			var _d3 = $.pb.createDateObj(new Date(_d.year, _d.month-1, _d.day+2));

			crtTimeZone($('.entranceRoomDtWrap'), _d, { hour:false, min:false });
			crtTimeZone($('.entranceRoomStartDtWrap'), _d1);
			crtTimeZone($('.entranceRoomEndDtWrap'), _d2);
			crtTimeZone($('.carryingDtWrap'), _d3);
			crtTimeZone($('.deadDtWrap'), _d, { hour:false, min:false });
			
			//염습일자
			crtTimeZone($('.shroud'), _d1, { hour:false, min:false });
			crtTimeZone($('.enshrine'), _d, { hour:false, min:false });
			
			//프리드				
			if(bugoHideFlag == "Y"){
				$('select[name=cmNameFlag]').val("2");
				//$('input[name=cmName]').val("2");
				//$('input[name=cmPhone]').val("2");				
			}
		}
		

		// 고인사진 등록		
		$('#btnDmPhoto').on('click', function() { $('input[type=file][name=dmPhoto]').trigger('click'); });
		$('input[type=file]').on('change', function() {
			var _ = $(this);
			
			if(_.val()) {
				var _fileName = _[0].files[0].name; 
				var _fileSize = _[0].files[0].size;	//			
				var maxSize = 5*1024*1024;			//
				
				if(/(\.png|\.jpg|\.jpeg|\.gif)$/i.test(_fileName) == false) { 
					alert("png, jpg, gif 형식의 파일을 선택하십시오");
					$(this).val('');
				}
				else if(_fileSize > maxSize){					
					return alert("파일 용량이 5MB 이상입니다.\n5MB 이하의 파일만 가능합니다.");
				}else {
					$.each(_[0].files, function(idx) {
						var _thisFile = this;
						$('input[name=photoName]').val(this.name);
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
			if(confirm('사진 삭제는 저장하기를 누르지 않아도 데이터가 삭제됩니다. 삭제 하시겠습니까?')) {
				var _file = $('input[type=file][name=dmPhoto]');
				$('.photo').css('background-image', '');
				$('input[name=photoName]').val('');
				_file.val('');
				if(_param.pk) {
					$.pb.ajaxCallHandler('/admin/deleteDmPhoto.do', { eventNo:_param.pk }, function(deleteResult) { console.log('삭제완료'); });
				}
			}
		});
		
		
		// 주소찾기
		/*
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
		*/
		
		//주소찾기  - HYH
		// daum API 변경으로 인한 소스 수정 - HYH
		$('.btn-addr').on('click', function(){
			new daum.Postcode({
				oncomplete:function(data){
					$('input[name=dmAddr]').val(data.address);
				}
			}).open();
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
			_piWrap.append('<select class="body-select chief-mourner" style="margin-left:0px;"><option value="">선택</option></select>');
			_piWrap.append('<input type="text" class="body-text family" style="margin-left:8px;" disabled>');
			_piWrap.append('<div class="chief-mourner-wrap"></div>');
			_piWrap.append('<div class="btn-wrap"><button type="button" class="btn-up"></button><button type="button" class="btn-down"></button></div>');
			_piWrap.find('.btn-wrap .btn-up').on('click', function(){ _piWrap.prev().before(_piWrap); createTxt(createMap($('.family-wrap'))) });
			_piWrap.find('.btn-wrap .btn-down').on('click', function(){ _piWrap.next().after(_piWrap); createTxt(createMap($('.family-wrap'))) });
			fmilyRowBindAction(_piWrap);
		}).trigger('click').trigger('click').trigger('click');
		
		
		// 배차 행 추가
		$('.box-body.car-body').find('#phone').phoneFomatter();
		$('#btnCarRow').on('click', function() {
			var _piWrap = $('<div class="car-wrap">');
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
		
		//미리보기 화면
		/* $('select[name=nBinso], select[name=dmGender]').on('change', function(){
			if($('select[name=nBinso]').find('option:selected').text() != '선택해주세요'){
				$('.status').text($('select[name=nBinso]').find('option:selected').text().replace('[빈소]', ''));
				setBinso($('.statusRoot'));
			}
			else{
				$('.status').text('');
			}
			$('.name').html("故 "+$('input[name=dmName]').val()+" "+isNull($('input[name=dmPosition]').val(), '')+"("+($('select[name=dmGender]').find('option:selected').val() == 1 ? '남' : '여')+($('input[name=dmAge]').val() ? ",  "+$('input[name=dmAge]').val()+"세" : "")+")");
		});
		
		$('input[name=dmPosition], input[name=dmName], input[name=dmAge]').on('keyup', function(){
			$('.name').html("故 "+$('input[name=dmName]').val()+" "+isNull($('input[name=dmPosition]').val(), '')+"("+($('select[name=dmGender]').find('option:selected').val() == 1 ? '남' : '여')+($('input[name=dmAge]').val() ? ",  "+$('input[name=dmAge]').val()+"세" : "")+")");
		}); */
		
		// 성별, 나이, 직급 수정 - HYH
		$('select[name=nBinso], select[name=dmGender]').on('change', function(){
			if($('select[name=nBinso]').find('option:selected').text() != '선택해주세요'){
				$('.status').text($('select[name=nBinso]').find('option:selected').text().replace('[빈소]', ''));
				setBinso($('.statusRoot'));
			}
			else{
				$('.status').text('');
			}
			
			var selGender="";
			if($('select[name=dmGender]').find('option:selected').val() == 0){
				selGender="";
			}else if($('select[name=dmGender]').find('option:selected').val()==1){
				selGender=" (남";
			}else if($('select[name=dmGender]').find('option:selected').val()==2){
				selGender=" (여";
			}else if($('select[name=dmGender]').find('option:selected').val()==3){
				selGender=" (男";
			}else if($('select[name=dmGender]').find('option:selected').val()==4){
				selGender=" (女";
			}
			
			var inputAge = "";
			if($('select[name=dmGender]').find('option:selected').val() == 0 && $('input[name=dmAge]').val() == ''){
				inputAge = "";	//성별도 없고 나이도 없는 경우
			}else if($('select[name=dmGender]').find('option:selected').val() == 0 && $('input[name=dmAge]').val() != ''){
				inputAge = " ("+ $('input[name=dmAge]').val() +"세)";	//성별은 없으나 나이는 있는 경우
			}else if($('select[name=dmGender]').find('option:selected').val() != 0 && $('input[name=dmAge]').val() == ''){
				inputAge = ")";	//성별은 있으나 나이는 없는 경우
			}else if($('select[name=dmGender]').find('option:selected').val() != 0 && $('input[name=dmAge]').val() != ''){
				inputAge = " ,"+ $('input[name=dmAge]').val() + "세)";	//성별도 있고 나이도 있는 경우
			}
			
			
			
			$('.name').html("故 "+$('input[name=dmName]').val()+" "
					+isNull($('input[name=dmPosition]').val(), '')
					/* +"(" */
					/* +($('select[name=dmGender]').find('option:selected').val() == 1 ? '남' : '여') */					
					+selGender
					/* +($('input[name=dmAge]').val() ? ",  "
					+$('input[name=dmAge]').val()+"세" : "")+")" */
					+inputAge
			);
		});
		
		$('input[name=dmPosition], input[name=dmName], input[name=dmAge]').on('keyup', function(){	
			var selGender="";
			if($('select[name=dmGender]').find('option:selected').val() == 0){
				selGender="";
			}else if($('select[name=dmGender]').find('option:selected').val()==1){
				selGender=" (남";
			}else if($('select[name=dmGender]').find('option:selected').val()==2){
				selGender=" (여";
			}else if($('select[name=dmGender]').find('option:selected').val()==3){
				selGender=" (男";
			}else if($('select[name=dmGender]').find('option:selected').val()==4){
				selGender=" (女";
			}
			
			var inputAge="";
			if($('select[name=dmGender]').find('option:selected').val() == 0 && $('input[name=dmAge]').val() == ''){
				inputAge = "";	//성별도 없고 나이도 없는 경우
			}else if($('select[name=dmGender]').find('option:selected').val() == 0 && $('input[name=dmAge]').val() != ''){
				inputAge = " ("+ $('input[name=dmAge]').val() +"세)";	//성별은 없으나 나이는 있는 경우
			}else if($('select[name=dmGender]').find('option:selected').val() != 0 && $('input[name=dmAge]').val() == ''){
				inputAge = ")";	//성별은 있으나 나이는 없는 경우
			}else if($('select[name=dmGender]').find('option:selected').val() != 0 && $('input[name=dmAge]').val() != ''){
				inputAge = " ,"+ $('input[name=dmAge]').val() + "세)";	//성별도 있고 나이도 있는 경우
			}
			
			$('.name').html("故 "+$('input[name=dmName]').val()
					+" "+isNull($('input[name=dmPosition]').val(), '')					
					
					/* +($('select[name=dmGender]').find('option:selected').val() == 1 ? '남' : '여') */					
					+ selGender
					/* 
					+($('input[name=dmAge]').val() ? ",  "
					+$('input[name=dmAge]').val()+"세" : "")+")" */
					+ inputAge
			); // ./$('.name').html
					
					
		});	// ./on('keyup', function)
		// ./성별, 나이, 직급 수정 - HYH
		

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
		$(document).on("keyup",".body-text.family",function(e){ createTxt(createMap($('.family-wrap'))); });
		$(document).on("keyup",".wrapper-text",function(e){ 
			if(e.keyCode == 13 || e.keyCode == 8){ 
				//상주 관계 입력해야 생성
				if($(this).parents('.chief-mourner-wrap').siblings('.body-text.family').val().length) createTxt(createMap($('.family-wrap')));
			}
		});
		$(document).on("change", ".body-select.chief-mourner", function(e) { createTxt(createMap($('.family-wrap'))); });
		$(document).on("click", ".wrapper-item img.close", function(e) { createTxt(createMap($('.family-wrap'))); });
		$(document).on("click", ".family-wrap .btn-up, .family-wrap .btn-down", function(e) { createTxt(createMap($('.family-wrap'))); });
		
		
		//행사 삭제
// 		$('.event-info-top > .right-wrap > .btn.delete').off().on('click', function(){
// 			if(confirm('삭제된 데이터는 복구할 수 없습니다. 그래도 삭제하시겠습니까? ')) {
// 				var _rpiBinsoList = '';
// 				$.each($('.body-select.binso'), function(idx) { 
// 					if($(this).val()) {
// 						_rpiBinsoList += (idx ? ','+$(this).val():$(this).val());
// 					}
// 				});
// 				$.pb.ajaxCallHandler('/admin/deleteEvent.do', { eventNo:_param.pk, funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}', rpiBinsoNo:_rpiBinsoList, eventAliveFlag:$('input[name=eventAliveFlag]').val() }, function(eventAliveRst) {
// 					$(location).attr('href', '/290102');
// 				});
// 			}
// 		});

		//행사 마감
// 		$('.event-info-top > .right-wrap > .btn.deadline').off().on('click', function(){
// 			var _rpiBinsoList = '';
// 			$.each($('.body-select.binso'), function(idx) { 
// 				if($(this).val()) {
// 					_rpiBinsoList += (idx ? ','+$(this).val():$(this).val());
// 				}
// 			});
// 			$.pb.ajaxCallHandler('/admin/updateEventAliveFlag.do', { eventNo:_param.pk, funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}', eventAliveFlag:0, rpiBinsoNo:_rpiBinsoList }, function(eventAliveRst) {
// 				if(eventAliveRst) $(location).attr('href', '/290102');
// 			});
// 		});

		// 저장이벤트
		$(".event-simple-info-wrap .btn-save").on('click', function(event) {
			var _tDiff1 = $.pb.returnTimeDiff(crtDt($('.entranceRoomDtWrap')), crtDt($('.entranceRoomStartDtWrap')));
			var _tDiff2 = $.pb.returnTimeDiff(crtDt($('.entranceRoomDtWrap')), crtDt($('.entranceRoomEndDtWrap')));
			var _tDiff3 = $.pb.returnTimeDiff(crtDt($('.entranceRoomDtWrap')), crtDt($('.carryingDtWrap')));
			var _tDiff4 = $.pb.returnTimeDiff(crtDt($('.entranceRoomStartDtWrap')), crtDt($('.entranceRoomEndDtWrap')));
			var _tDiff5 = $.pb.returnTimeDiff(crtDt($('.entranceRoomStartDtWrap')), crtDt($('.carryingDtWrap')));
			var _tDiff6 = $.pb.returnTimeDiff(crtDt($('.entranceRoomEndDtWrap')), crtDt($('.carryingDtWrap')));
			
			//edited by euibo 프리드
			if($('select[name=cmNameFlag]').val()==1){
				if(!$('input[name=cmName]').val()) return alert("대표상주 성함을 입력해 주세요.");
				if(!$('input[name=cmPhone]').val()) return alert("대표상주 연락처를 입력해 주세요.");
				if($('input[name=cmPhone]').val().replace(/[^0-9]*/gi, '').length > 11) return alert("대표상주 연락처가 올바르지 않습니다.");
			}

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
					entranceRoomNo:$('select[name=entranceRoomNo]').val(), 
					entranceRoomStartDt:crtDt($('.entranceRoomStartDtWrap')), 
					entranceRoomEndDt:crtDt($('.entranceRoomEndDtWrap'))
				};
				
				$.pb.ajaxCallHandler('/admin/selectEventList.do', _binsoOlpObj, function(binsoOverlap) {
// 					$.pb.ajaxCallHandler('/admin/selectEventList.do', _entranceRoomObj, function(entranceRoomOverlap) {
						if(binsoOverlap.list.length) return alert('선택하신 시간에 사용중인 빈소가 있습니다.');
// 						else if(entranceRoomOverlap.list.length) return alert('선택하신 시간에 사용중인 입관실이 있습니다.');
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
							_formData.append('entranceRoomDt', crtDt($('.entranceRoomDtWrap')));
							_formData.append('entranceRoomStartDt', crtDt($('.entranceRoomStartDtWrap')));
							_formData.append('entranceRoomEndDt', crtDt($('.entranceRoomEndDtWrap')));
							_formData.append('carryingDt', crtDt($('.carryingDtWrap')));
							_formData.append('deadDt', crtDt($('.deadDtWrap')));
							_formData.append('orginRaspList', _orginRaspList.join());
							_formData.append('originEnRoom', ($('select[name=entranceRoomNo]').val() == _originEnRoom ? null : _originEnRoom));
							_formData.append('changeBinso', (_rpiBinsoList == _orginRaspList.join()));
							
							//염습,안치일
							_formData.append('enshrine_dt',  crtDt($('.enshrine')));
							_formData.append('shroud_dt', crtDt($('.shroud')));
							_formData.append('shroud_mgr', $('input[name=shroudMgr]').val());
							
							//프리드
							_formData.append('cm_flag', $('select[name=cmNameFlag]').val());
							
							$('.ajax-loading').show();
							
							$.pb.ajaxUploadForm(_url, _formData, function(result) {
								$('.ajax-loading').hide();
								if(result != 0) {
									$.ajax({
										//url : 'http://211.251.238.235:9090/api/v1/event',
										url : 'https://choomo.app/api/v1/event',
										type : 'post',
										async: false,
										data : {'eventNo' : result.eventNo },
										success: function(data) {}
									});
									$(location).attr('href', '/290102');
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
		
		$('.btn-cancel').on('click', function(){ 
			if(confirm("취소하시겠습니까?")) $(location).attr('href', '/290102'); 
		});
		
		
		$('.event-info-top > .right-wrap .btn.bugo-pop').on('click', function() {
			$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
				//document.choomoService.location = 'http://211.251.238.235:9090/choomo-service?eventNo=' + _param.pk;
				document.choomoService.location = 'https://choomo.app/choomo-service?eventNo=' + _param.pk;
			});
		});

		//모바일/PC 스크립트 인식 구분
		var filter = "win16|win32|win64|mac|macintel";
		if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
		//MOBILE
		$('.right-wrap').find('.cancel').hide();
			$('.right-wrap').find('.print01').hide();
			$('.right-wrap').find('.print03').hide();
			$('.event-info-top > .right-wrap > .btn.deadline').style.display="none"
			document.getElementById("event-simple-info-box-wrap").style.width="700px";
			document.getElementById("event-simple-info-bigo").style.width="700px";
			document.getElementById("btn-save").style.top="56px";
			document.getElementById("btncancel").style.top="56px";
			document.getElementById("event-preview-wrap").style.width="100%";
			document.getElementById("event-preview-wrap").style.height="auto";
			document.getElementById("event-preview-box").style.width="700px";
			document.getElementById("event-preview-box").style.height="358px";
			document.getElementById("family-text").style.backgroungColor="#ff0000";
		}
		$('.pb-popup-close, .popup-mask').on('click', function(){ closeLayerPopup(); });
	});
</script>
<style>
	.event-info-box > .box-body .obituary-phone-wrap { width:88%; display:inline-block; vertical-align:top; }
	.event-info-box > .box-body .chief-mourner-wrap { width:calc(100% - 240px - 32px); display:inline-block; padding:5px 10px; border-radius:4px; vertical-align:top; }
	.event-info-box > .box-body .family { margin-left: 8px; margin-right: 8px; }
	
	button.obituary-send { width:100%; height:56px; background-image:linear-gradient(to bottom, #FF9897, #F650A0); color:#FFFFFF; font-size:18px; }
	.pb-table.list.bugo tr:hover { background:none; }
	.pb-table.list.bugo tr td { cursor:initial; padding:0px; height: 56px; }
	.pb-table.list > tbody .table-text { border:none; }
	.pb-table.list.bugo .re-send { color:#f6509f; text-decoration:underline; font-size:16px; background:#FFF; cursor:pointer; }
</style>

			
<form id="dataForm">
	<div class="pb-right-popup-wrap" style="width:1600px;">
		<div class="pb-popup-title">모바일 부고장 보내기</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<iframe name="choomoService" width="100%" height="100%" scrolling="no" frameborder="0">해당 브라우저는 IFRAME을 지원하지 않습니다.<br/>다른 브라우저를 이용해주세요.</iframe>
		</div>
	</div>
</form>


<div class="event-preview-wrap" id="event-preview-wrap">
	<div class="event-preview-box" id="event-preview-box">
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
		<div class="burial-plot-name jangjiRoot">
		</div>
	</div>
	
	<div class="profile-info-wrap" id="event-simple-info-bigo">
		<div class="row-box">
			<label class="info-label">비고입력란(행사현황판에 출력 됩니다.)</label>
			<textarea class="body-text-area" name="bigo" style="height:139px;" placeholder="예시)의료비 70%"></textarea>
		</div>
	</div>
</div>

<div class="event-simple-info-wrap" id="event-simple-info-box-wrap">
	<div class="event-simple-info-scroll"  id="event-simple-info-box-scroll">
		<input type="hidden" name="eventAliveFlag"/>
		<input type="hidden" name="funeralName"/>
		<div class="event-simple-info-box">
			<div class="box-title">필수정보</div>
			<div class="box-body">
				<div class="profile-info-wrap">
					<div class="row-box">
						<label class="info-label nece">주 빈소선택</label>
						<select class="body-select necessary binso" name="nBinso"></select>
					</div>
					<div class="row-box">
						<label class="info-label">추가 빈소선택</label>
						<input type="text" class="body-text sBinso" name="sBinso" placeholder="더보기" readonly/>
						<div class="binso-box">
							<select class="body-select binso mt"></select>
							<select class="body-select binso mt"></select>
							<select class="body-select binso mt"></select>
						</div>
						
					</div>
					<div class="row-box">
						<label class="info-label">영정사진</label>
						<span class="hint" style="left:63px; width:432px;">* 규격 : 11R/가로 : 11인치(28cm)/세로 : 14인치(36cm)/파일 : jpg, png 등</span>
						<input type="text" class="body-text" name="photoName" placeholder="영정사진" readonly/>
					</div>
					<div class="row-box">
						<label class="info-label"></label>
						<input type="file" name="dmPhoto"/>
						<button type="button" class="btn-photo register" id="btnDmPhoto">사진등록</button>
					</div>
					<div class="row-box">
						<label class="info-label"></label>
						<button type="button" class="btn-photo delete" id="btnDmPhotoDelete">사진삭제</button>
					</div>
				</div>

				
				<div class="profile-info-wrap">
					<div class="row-box">
						<label class="info-label nece">고인성함</label>
						<input type="text" class="body-text necessary" name="dmName" placeholder="성함" maxlength="30"/>
					</div>
					<div class="row-box">
						<label class="info-label">나이</label>
						<input type="text" class="body-text" name="dmAge" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" placeholder="나이"/>
					</div>

					<div class="row-box">
						<label class="info-label">종교</label>
						<select class="body-select info" name="dmReligion"></select>
					</div>
				
					<div class="row-box">
						<label class="info-label">종교 직위</label>
						<input type="text" class="body-text" name="dmPosition" placeholder="직위"/>
					</div>
					<div class="row-box">
						<label class="info-label info">성별</label>
						<select class="body-select" name="dmGender">
							<!-- <option value="1">남자</option>
							<option value="2">여자</option> -->
							<!-- #성별 수정 -->
							<option value="0">선택</option>
							<option value="1">남</option>
							<option value="2">여</option>
							<option value="3">男</option>
							<option value="4">女</option>
						<!-- ./#성별 수정 -->
						</select>
					</div>
				</div>
				
				<div class="profile-info-wrap">
					<div class="row-box">
						<label class="info-label">입실일</label>
						<input type="text" class="body-text cal entranceRoomDtWrap dt" readonly>
					</div>
					<div class="row-box">
						<label class="info-label">입실시간</label>
						<input type="text" class="body-text clock entranceRoomDtWrap tm" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
					</div>
				</div>
				
				<div class="profile-info-wrap">
					<div class="row-box">
						<label class="info-label">입관실</label>
						<select class="body-select" name="entranceRoomNo"></select>
					</div>
					<div class="row-box">
						<label class="info-label">입관시작일</label>
						<input type="text" class="body-text cal entranceRoomStartDtWrap dt" readonly>
					</div>
					<div class="row-box">
						<label class="info-label">입관시작시간</label>
						<input type="text" class="body-text clock entranceRoomStartDtWrap tm" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
					</div>
					<div class="row-box">
						<label class="info-label">입관마감일</label>
						<input type="text" class="body-text cal entranceRoomEndDtWrap dt" readonly>
					</div>
					<div class="row-box">
						<label class="info-label">입관마감시간</label>
						<input type="text" class="body-text clock entranceRoomEndDtWrap tm" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
					</div>
					
				</div>
			
				<div class="profile-info-wrap">
					<div class="row-box">
						<label class="info-label">발인</label>
						<div class="radio-wrap"><input type="radio" name="carryingYn" value="1"/><input type="radio" name="carryingYn" value="0"/></div>
					</div>
					<div class="row-box">
						<label class="info-label">발인일</label>
						<input type="text" class="body-text cal carryingDtWrap dt" readonly>
					</div>
					<div class="row-box">
						<label class="info-label">발인시간</label>
						<input type="text" class="body-text clock carryingDtWrap tm" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
					</div>
				</div>
			
				<div class="profile-info-wrap">
					<div class="row-box">
						<label class="info-label">사망일</label>
						<input type="text" class="body-text cal deadDtWrap dt" readonly>
					</div>
					<div class="row-box">
						<label class="info-label">사망시간</label>
						<input type="text" class="body-text clock deadDtWrap tm" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
					</div>
					
					<div class="row-box">
						<label class="info-label">사망구분</label>
						<select class="body-select" name="deadClassify">
							<option value="별세">별세</option>
							<option value="영면">영면</option>
							<option value="소천">소천</option>
							<option value="선종">선종</option>
							<option value="direct">직접입력</option>
						</select>
					</div>
					<div class="row-box">
						<label class="info-label">직접입력</label>
						<input type="text" class="body-text" id="deadClassify" placeholder="직접입력" disabled/>
					</div>
					<div class="row-box">
						<label class="info-label">장지</label>
						<textarea class="body-text-area" name="burialPlotName" placeholder="미 입력시 미정"></textarea>
					</div>
				</div>
				
				
			<div class="profile-info-wrap" id="cmDiv">
					<div class="row-box">
						<label class="info-label nece">상주여부</label>
						<select class="body-select" name="cmNameFlag">
							<option value="1">있음</option>
							<option value="2">없음</option>
						</select>
					</div>
					<div class="row-box">
						<label class="info-label nece">대표상주</label>
						<input type="text" class="body-text" name="cmName" placeholder="대표상주"/>
					</div>
					<div class="row-box">
						<label class="info-label nece">상주연락처</label>
						<input type="text" class="body-text tel" name="cmPhone" placeholder="연락처"/>
					</div>
				</div>

				<div class="profile-info-wrap" id="cmInfo">
					<div class="row-box" style="width:calc(100% - 9px);">
						<label class="info-label nece">상주정보</label>
						<span class="hint" style="left:62px;">*현황판과 부고장에 등록될 상주 정보를 입력 해 주세요. 이름을 입력 한 후 엔터(Enter)키를 누르세요.</span>
						<div class="box-body family-body"></div>
					</div>
				</div>
				
				
				<div class="profile-info-wrap" id ="cmAdd">
					<div class="row-box">
						<button type="button" class="title-button" id="btnFmilyRow">상주 행 추가</button>
					</div>
				</div>
					
				
				<div class="profile-info-wrap" id = cmNote>
					<div class="row-box" style="width:calc(100% - 9px);">
						<label class="info-label">알림글</label>
						<span class="hint" style="left:44px;">*모바일 부고장에 표시되는 항목입니다.</span>
						<textarea class="body-text-area" name="storeInfo" style="height:176px;" placeholder="예시글) 해당 장례식장은 코로나 확산방지를 위해 방역 수칙을 준수하고 있으며, 안전하게 방문하여 조문이 가능합니다."></textarea>
					</div>
				</div>
				
				<div class="profile-info-wrap">
					<div class="etc-info">기타정보<span style="margin-left:10px; color:#f00;">클릭시 열립니다.</span></div>
				</div>
			
			
				<div class="profile-info-wrap etc">
					<div class="row-box">
						<label class="info-label">주민번호</label>
						<input type="text" class="body-text" name="dmRegNumber" maxlength="13" placeholder="숫자만"/>
					</div>
					<div class="row-box" style="width:40%;">
						<label class="info-label">고인주소</label>
						<input type="text" class="body-text" name="dmAddr" placeholder="주소" readonly/>
						<button type="button" class="body-text-button btn-addr">주소찾기</button>
					</div>
					<div class="row-box" style="width:40%;">
						<label class="info-label">상세주소</label>
					<input type="text" class="body-text" name="dmAddrDetail" placeholder="상세주소"/>
					</div>
				</div>
				
				<div class="profile-info-wrap etc">
					<div class="row-box">
						<label class="info-label">사망장소</label>
						<select class="body-select" name="deadPlace">
							<option value="집">집</option>
							<option value="병원">병원</option>
							<option value="direct">직접입력</option>
						</select>
					</div>
					
					<div class="row-box">
						<label class="info-label">직접입력</label>
						<input type="text" class="body-text" id="deadPlace" placeholder="직접입력" disabled/>
					</div>
					
					<div class="row-box">
						<label class="info-label">사망원인</label>
						<select class="body-select" name="deadCause">
							<option value="자연사">자연사</option>
							<option value="병사">병사</option>
							<option value="변사">변사</option>
							<option value="direct">직접입력</option>
						</select>
					</div>
					
					<div class="row-box">
						<label class="info-label">직접입력</label>
						<input type="text" class="body-text" id="deadCause" placeholder="직접입력" disabled/>
					</div>
				</div>

				<div class="profile-info-wrap etc">
					<div class="row-box">
						<label class="info-label">장례방식</label>
						<select class="body-select" name="funeralSystem">
							<option value="화장">화장</option>
							<option value="매장">매장</option>
							<option value="direct">직접입력</option>
						</select> 
					</div>
					
					<div class="row-box">
						<label class="info-label">직접입력</label>
						<input type="text" class="body-text" id="funeralSystem" placeholder="직접입력" disabled/>
					</div>
					
					<div class="row-box">
						<label class="info-label">상조회정보</label>
						<input type="text" class="body-text" name="carryingPlace" placeholder=""/>
					</div>
					
					<div class="row-box">
						<label class="info-label">진단서발행처</label>
						<input type="text" class="body-text" name="medicalCertificate" placeholder="진단서발행처"/>
					</div>
				</div>
				<div class="profile-info-wrap etc">
					<div class="row-box">
						<label class="info-label" style="font-size:12px;">진단서발행</label>
						<div>
							<input type="radio" name="diagnosisYn" value="1"/><input type="radio" name="diagnosisYn" value="0"/>
						</div>
					</div>
					<div class="row-box">
						<label class="info-label">퇴원확인서</label>
						<div>
							<input type="radio" name="dischargeYn" value="1"/><input type="radio" name="dischargeYn" value="0"/>
						</div>
					</div>
					<div class="row-box">
						<label class="info-label">약물처리</label>
						<div>
							<input type="radio" name="drugYn" value="1"/><input type="radio" name="drugYn" value="0"/>
						</div>
					</div>
					<div class="row-box">
						<label class="info-label">검사지휘서</label>
						<div>
							<input type="radio" name="publicProsecutorYn" value="1"/><input type="radio" name="publicProsecutorYn" value="0"/>
						</div>
					</div>
				</div>
				
				
				<!-- 염습대장 추가 -->
				<div class="profile-info-wrap">				
					<div class="row-box">
						<label class="info-label">안치일자</label>
						<input type="text" class="body-text cal enshrine dt" readonly>
					</div>
					<div class="row-box">
						<label class="info-label">안치시간</label>
						<input type="text" class="body-text clock enshrine tm" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
					</div>
					<div class="row-box">
						<label class="info-label">염습일자</label>
						<input type="text" class="body-text cal shroud dt" readonly>
					</div>
					<div class="row-box">
						<label class="info-label">염습시간</label>
						<input type="text" class="body-text clock shroud tm" data-autoclose="true" value="00:00" aria-invalid="false" readonly>
					</div>
					<div class="row-box">
						<label class="info-label">염습처리자</label>
						<input type="text" class="body-text" name="shroudMgr" placeholder="처리자" maxlength="30"/>
					</div>					
				</div>
				
				<div class="profile-info-wrap etc">
					<div class="row-box">
						<label class="info-label">배차정보</label>
					</div>
				</div>
				
				<div class="profile-info-wrap etc">
					<div class="row-box" style="width:calc(100% - 9px);">
						<div class="box-body car-body"></div>
					</div>
				</div>
				
				<div class="profile-info-wrap etc">
					<div class="row-box" style="width:calc(100% - 9px);">
						<button type="button" class="title-button" id="btnCarRow" style="margin-bottom:30px;">배차 행 추가</button>
					</div>
				</div>
			</div>
		</div>
		<button type="button" class="btn-save" id="btn-save">저장</button>
		<button type="button" class="btn-cancel" id="btn-cancel">취소</button>
	</div>
</div>

