<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<script>
	$(function() {
		//모바일인 경우 무조건 간편화면
		var filter = "win16|win32|win64|mac|macintel";
		if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
		//MOBILE
			$.pb.settingCookie("dsELD", 2, true);
		}
		
		var _param = JSON.parse('${data}');
		var searchObj = $.extend({}, _param);
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:10):0);
		searchObj.display = (_param.display ? _param.display:10);
		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
		searchObj.eventAliveFlag = true;
// 		searchObj.orderNo = 1;
		searchObj.order = 'EXPOSURE ASC, APPELLATION ASC, ENTRANCE_ROOM_DT ASC';
		
		$('.search-box-wrap .search-text-button').on('click', function() {
			searchObj.searchText = $(this).prev('.search-text').val();
			if($('.event-body-wrap').hasClass('list')){
				createTable_list(searchObj, 'now');
				createTable_list(searchObj, 'rsvd');
			}else{
				createTable_div(searchObj, 'now');
				createTable_div(searchObj, 'rsvd');
			}
		});
		
		
		$('.search-box-wrap .search-text').on('keyup', function(e) {
			if(e.keyCode == 13) $(this).next('.search-text-button').trigger('click');
		});
		
		$('.event-bar.top > .center-text').html(new Date().format('yyyy-MM-dd a/p hh:mm'));
		var _topClock = setInterval(function() {
			$('.event-bar.top > .center-text').html(new Date().format('yyyy-MM-dd a/p hh:mm'));
		}, 1000);
		
		$.pb.ajaxCallHandler('/admin/selectAllFuneralHallList.do', { funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}', lv:29 }, function(funeralData) {
			var _funeralData = funeralData.list[0];
			$('.event-bar.bottom > .right-text').html('담당 : '+isNull(_funeralData.MANAGER_NAME, '담당자 없음')+' ('+isNull($.pb.phoneFomatter(_funeralData.MANAGER_PHONE))+')');
		});
		
		$.pb.ajaxCallHandler('/admin/selectNoticeList.do', { order:'NOTICE_NO DESC', queryPage:0, display:1, endDt:true }, function(noticeData) {
			var _noticeData = noticeData.list[0];
			if(_noticeData) {
				$('.event-bar.bottom > .center-text').html(_noticeData.TITLE);
				if(!$.pb.getCookie().noPop){ // 쿠키에 하루동안 열지않기 저장
					$('.popup-mask').show();
					var _scrollY = $(window)[0].scrollY ? $(window)[0].scrollY:document.body.parentNode.scrollTop;
					
					var _popupNotice = $('<div class="popup-notice">');
					_popupNotice.data(this).css('top', 'calc(50vh - 300px - '+_scrollY+'px)');
					
					_popupNotice.append('<div class="title">'+_noticeData.TITLE+'</div>');
					_popupNotice.append('<textarea class="contents" readonly>'+_noticeData.CONTENTS+'</textarea>');
					_popupNotice.append('<div class="bottom-wrap"><button type="button" class="btn-day-close">오늘 하루동안 닫기</button><button type="button" class="btn-close">닫기</button></div>');
					_popupNotice.find('.btn-day-close').on('click', function() { 
				 		$.pb.settingCookiePop("noPop", "1", 1);
						$('.popup-mask').hide();
						$(this).parents('.popup-notice').hide();
					});
					_popupNotice.find('.btn-close').on('click', function() { 
						$('.popup-mask').hide();
						$(this).parents('.popup-notice').hide();
					});
					$('.main-contents-wrap').append(_popupNotice);
				}
			}
		});
		
		var createTable_list = function(_searchObj, _flag) {
			$.pb.ajaxCallHandler('/admin/selectEventFamily.do', { funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}' }, function(data) { 
				$('.contents-body-wrap .pb-table.list').show();
				$('.event-body-wrap').removeClass('div').addClass('list');
				searchObj.statusPlate = (_flag == 'now' ? true:false);
				var _url = (_flag == 'now' ? 'selectAllEventList':'selectEventList');
				$.pb.ajaxCallHandler('/admin/'+_url+'.do', _searchObj, function(tableData) {
					var _listWrap = $('.contents-body-wrap.'+_flag+' > .event-body-wrap');
					_listWrap.html('');
					
					if(_flag == 'rsvd' && tableData.list.length) $('.search-box-wrap.rsvd, .contents-body-wrap.rsvd').show();
					$.each((_flag == 'now' ? tableData:tableData.list), function(idx) {
						var _tr = $('<div class="event-item-box">');
						_tr.data(this);
						_tr.append('<div class="dead-man-photo" style="width:6%;"></div>');
						if(this.DM_PHOTO) _tr.find('.dead-man-photo').css('background-image', 'url("'+this.DM_PHOTO+'")');
						if(this.BINSO_RASPBERRY_CONNECTION_NO) _tr.find('.dead-man-photo').append('<div class="yj"></div>');
						
						var _wrap01 = $('<div style="width:13%;"></div>');
						_wrap01.append('<div style="width:100%;">'+this.APPELLATION+(this.FLOOR ? "("+this.FLOOR+"층)" : '')+'</div>');
						
						/* var _gender = this.DM_GENDER == 1 ? "남" : "여";
						_wrap01.append('<div>'+(this.DM_NAME ? (this.DM_AGE ? this.DM_NAME+"("+ _gender + "/" + this.DM_AGE + "세)" : this.DM_NAME+"("+_gender+")") : "")+'</div>');
						_tr.append(_wrap01); */ //HYH - 주석처리
						
						// _tr.append(_wrap01) HYH 추가 - 모바일용
						var appendText="";
						var selGender="";
						if(this.DM_GENDER==0){
							selGender="";
						}else if(this.DM_GENDER==1){
							selGender="남";
						}else if(this.DM_GENDER==2){
							selGender="여";
						}else if(this.DM_GENDER==3){
							selGender="男";
						}else if(this.DM_GENDER==4){
							selGender="女";
						}																														

						if(this.DM_GENDER == 0 && this.DM_AGE == ""){			//성별 없음, 나이 없음
							appendText="";
						}else if(this.DM_GENDER == 0 && this.DM_AGE != ""){		//성별 없음, 나이 있음
							appendText=" ("+ this.DM_AGE+ "세)";
						}else if(this.DM_GENDER != 0 && this.DM_AGE == ""){		//성별 있음, 나이 없음
							appendText=" ("+ selGender + ")";
						}else if(this.DM_GENDER != 0 && this.DM_AGE != ""){		//성별 있음, 나이 있음.
							appendText=" ("+ selGender +" ,"+this.DM_AGE+"세)";
						}

						 _wrap01.append('<div>'+(this.DM_NAME ? this.DM_NAME+""+appendText : "")+'</div>');
						 _tr.append(_wrap01);
						 // ./ _tr.append(_wrap01) HYH - 추가 - 모바일용 
						
						
						var _wrap02 = $('<div style="width:20%;"></div>');
						_wrap02.append('<div>'+(this.CM_NAME ? "상주 : "+ this.CM_NAME : "")+"<br>"+(this.CM_PHONE ? "("+$.pb.phoneFomatter(this.CM_PHONE)+")" : "")+'</div>');
						_wrap02.append('<div class="burial" style="width:100%;">'+(this.BURIAL_PLOT_NAME ? "장지 : "+this.BURIAL_PLOT_NAME.replace('\n', '<br/>') : "")+'</div>');
						_tr.append(_wrap02);
						
						
						var erd = new Date(this.ENTRANCE_ROOM_DT);
						var ersd = new Date(this.ENTRANCE_ROOM_START_DT);
						var cd = new Date(this.CARRYING_DT);
						
						var varUA = navigator.userAgent.toLowerCase(); //userAgent 값 얻기
					    if ( varUA.indexOf('android') > -1) {
					        //안드로이드
					    } else if ( varUA.indexOf("iphone") > -1||varUA.indexOf("ipad") > -1||varUA.indexOf("ipod") > -1 ) {
					        //IOS
							erd.setHours(erd.getHours() - 9);
							ersd.setHours(ersd.getHours() - 9);
							cd.setHours(cd.getHours() - 9);
					    } else {
					        //아이폰, 안드로이드 외
					    }
						
						var _entDt = this.ENTRANCE_ROOM_DT ? "입실 : "+erd.format('MM월 dd일 HH:mm') : "";
						var _entSDt = this.ENTRANCE_ROOM_DT ? "입관 : "+ersd.format('MM월 dd일 HH:mm') : "";
						var _carDt = this.ENTRANCE_ROOM_DT ? "발인 : "+cd.format('MM월 dd일 HH:mm') : "";
						_tr.append('<div class="dt" style="width:13%;line-height:34px;">'+_entDt+"<br>"+_entSDt+"<br>"+_carDt+'</div>');
						
						
						var _this = this;
						_tr.append('<div class="family" style="width:32%;"></div>');
						if(data.length){
							$.each(data, function(){
								if(this.EVENT_NO == _this.EVENT_NO){
									var _div = $('<div class="fa" style="font-weight:500; font-family: Noto Sans KR;">');
									_div.append('<div class="re" style="display:inherit;width:100%"><div style="width:17%;text-align:center;">'+this.RELATION+'</div><div style="width:2%;">:</div>'+'<div style="width:80%;">'+this.NAMES_BASIC+'</div></div>');
									_tr.find('.family').append(_div);
								}
							});
						}
						
						var _wrap03 = $('<div style="width:8%;"></div>');
						_wrap03.append('<div class="">'+(this.BUILDING_NAME ? this.BUILDING_NAME + "/" + this.FLOOR +"층" : "")+'</div>');
						
						_wrap03.append('<div class="total" style="width:100%; word-break:break-all;">'+(this.RST_PRICE ? $.pb.targetMoney(this.RST_PRICE) : '-')+'</div>');
						_tr.append(_wrap03);
						_tr.append('<div class="bigo" style="white-space:pre-wrap; width:8%; height:100%; overflow:auto; white-space: pre-wrap;">'+isNull(this.BIGO)+'</div>');
						_tr.on('click', function() {
	 						$.pb.settingCookie("dsELD", 1, true);
// 	 						var _eventNo = (_tr.data('PARENT_EVENT_NO') ? _tr.data('PARENT_EVENT_NO'):_tr.data('EVENT_NO'));
	 						if(_tr.data('EVENT_NO')) {
	 							var stateObj = {
	 								link:'/29010101/'+_tr.data('EVENT_NO'), 
	 								page:'/manager/29010100'
	 							};
								
	 							history.pushState(stateObj, '', stateObj.link);
	 							$('.main-contents-wrap').pageConnectionHandler(stateObj.page, { pk:_tr.data('EVENT_NO') });
	 						} else {
	 							var stateObj = { 
									link:'/29010101/', 
									page:'/manager/29010100'
								};
								history.pushState(stateObj, '', stateObj.link);
								$('.main-contents-wrap').pageConnectionHandler(stateObj.page, { pk:_tr.data('EVENT_NO'), eventBinsoNo:_tr.data('RASPBERRY_CONNECTION_NO') });
	 						}
						});
						_listWrap.append(_tr);
					});
				});
			});
		};
		
		var createTable_div = function(_searchObj, _flag) {
			$.pb.ajaxCallHandler('/admin/selectEventFamily.do', { funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}' }, function(data) { 
				$('.contents-body-wrap .pb-table.list').hide();
				$('.event-body-wrap').removeClass('list').addClass('div');
				searchObj.statusPlate = (_flag == 'now' ? true:false);
				var _url = (_flag == 'now' ? 'selectAllEventList':'selectEventList');
				$.pb.ajaxCallHandler('/admin/'+_url+'.do', _searchObj, function(tableData) {
					var _listWrap = $('.contents-body-wrap.'+_flag+' > .event-body-wrap');
					_listWrap.html('');
					if(_flag == 'rsvd' && tableData.list.length) $('.search-box-wrap.rsvd, .contents-body-wrap.rsvd').show();
					$.each((_flag == 'now' ? tableData:tableData.list), function(idx) {
						var _tr = $('<div class="event-item-box">');
						_tr.data(this);
						if(this.EVENT_NO) _tr.addClass('e');
						_tr.append('<div class="idx">'+this.APPELLATION+'</div>');
						var _wrap = $('<div class="info"></div>');
						_wrap.append('<div class="dead-man-photo"></div>');
						if(this.DM_PHOTO) _wrap.find('.dead-man-photo').css('background-image', 'url("'+this.DM_PHOTO+'")').css('background-size', '100% 100%');
						if(this.BINSO_RASPBERRY_CONNECTION_NO) _wrap.find('.dead-man-photo').append('<div class="yj"></div>');
						
						// HYH - 모바일용 주석 처리
						/* var _gender = this.DM_GENDER == 1 ? "남" : "여";
						_wrap.append('<div class="name">'+(this.DM_NAME ? (this.DM_AGE ? this.DM_NAME+"("+ _gender + "/" + this.DM_AGE + "세)" : this.DM_NAME+"("+_gender+")") : "")+'</div>'); */
						// HYH - ./모바일용 주석 처리
						
						// HYH -성별 추가 모바일용
						var appendText="";
						var selGender="";
						if(this.DM_GENDER==0){
							selGender="";
						}else if(this.DM_GENDER==1){
							selGender="남";
						}else if(this.DM_GENDER==2){
							selGender="여";
						}else if(this.DM_GENDER==3){
							selGender="男";
						}else if(this.DM_GENDER==4){
							selGender="女";
						}																														

						if(this.DM_GENDER == 0 && this.DM_AGE == ""){			//성별 없음, 나이 없음
							appendText="";
						}else if(this.DM_GENDER == 0 && this.DM_AGE != ""){		//성별 없음, 나이 있음
							appendText=" ("+ this.DM_AGE+ "세)";
						}else if(this.DM_GENDER != 0 && this.DM_AGE == ""){		//성별 있음, 나이 없음
							appendText=" ("+ selGender + ")";
						}else if(this.DM_GENDER != 0 && this.DM_AGE != ""){		//성별 있음, 나이 있음.
							appendText=" ("+ selGender +" ,"+this.DM_AGE+"세)";
						}

						_wrap.append('<div>'+(this.DM_NAME ? this.DM_NAME+""+appendText : "")+'</div>')
						// ./HYH -성별 추가 모바일용
						
						
						var ersdate = new Date(this.ENTRANCE_ROOM_START_DT);
						var cdate = new Date(this.CARRYING_DT);
						
						var varUA = navigator.userAgent.toLowerCase(); //userAgent 값 얻기
					    if ( varUA.indexOf('android') > -1) {
					        //안드로이드
					    } else if ( varUA.indexOf("iphone") > -1||varUA.indexOf("ipad") > -1||varUA.indexOf("ipod") > -1 ) {
					        //IOS
							ersdate.setHours(ersdate.getHours() - 9);
							cdate.setHours(cdate.getHours() - 9);
					    } else {
					        //아이폰, 안드로이드 외
					    }
						_wrap.append('<div class="dt">'+(this.EVENT_NO ? "입관 : " + isNull(ersdate.format('MM월 dd일 HH:mm')) : "")+'</div>');
						_wrap.append('<div class="dt">'+(this.EVENT_NO ? "발인 : " + isNull(cdate.format('MM월 dd일 HH:mm')) : "")+'</div>');
						_wrap.append('<div class="plot">'+(this.EVENT_NO ? "<div>장지</div> : " + "<div>"+isNull(this.BURIAL_PLOT_NAME, " 미정")+"</div>" : "")+'</div>');
						_tr.append(_wrap);
						
						var _this = this;
						_tr.append('<div class="family"></div>');
						if(data.length){
							$.each(data, function(){
								if(this.EVENT_NO == _this.EVENT_NO){
									var _div = $('<div class="fa" style="display:inherit;width: 100%; font-family: Noto Sans KR;">');
									_div.append('<div class="re" style="display:inherit;width:100%"><div style="width:17%;text-align:center;">'+this.RELATION+'</div><div style="width:2%;">:</div>'+'<div style="width:80%;">'+this.NAMES_BASIC+'</div></div>');
									//_div.append('<div class="re"><span>'+this.RELATION+' :</span>'+this.NAMES_BASIC+'</div>');
									_tr.find('.family').append(_div);
								}
							});
						}
						
						_tr.on('click', function() {
	 						$.pb.settingCookie("dsELD", 2, true);
// 	 						var _eventNo = (_tr.data('PARENT_EVENT_NO') ? _tr.data('PARENT_EVENT_NO'):_tr.data('EVENT_NO'));
	 						if(_tr.data('EVENT_NO')) {
	 							var stateObj = { 
	 								link:'/29010101/'+_tr.data('EVENT_NO'), 
	 								page:'/manager/29010100'
	 							};
								
	 							history.pushState(stateObj, '', stateObj.link);
	 							$('.main-contents-wrap').pageConnectionHandler(stateObj.page, { pk:_tr.data('EVENT_NO') });
	 						} else {
	 							var stateObj = { 
										link:'/29010101/', 
										page:'/manager/29010100'
									};
									history.pushState(stateObj, '', stateObj.link);
									$('.main-contents-wrap').pageConnectionHandler(stateObj.page, { pk:_tr.data('EVENT_NO'), eventBinsoNo:_tr.data('RASPBERRY_CONNECTION_NO') });
	 						}
						});
						_listWrap.append(_tr);
					});
				});
			});
			
		}

		var _table = $('.contents-body-wrap.now .pb-table.list');
		var _tableRsvd = $('.contents-body-wrap.rsvd .pb-table.list');

		var listForm = function(){
			var theadObj = { table: _table };
			var theadObjRsvd = { table: _tableRsvd };
			theadObj.colGroup = new Array(6, 13, 20, 13, '*', 8, 8);
			theadObj.theadRow = [ ['', '영정'], ['', '빈소명'], ['', '대표상주'], ['', '상례절차'], ['', '상주'], ['', '건물/층수'], ['', '비고'] ];
			theadObj.theadRowSec = [ ['', ''], ['', '고인명'], ['', '장지'], ['', ''], ['', ''], ['', '합계'], ['', ''] ];
			theadObjRsvd.colGroup = new Array(6, 13, 20, 13, '*', 8, 8);
			theadObjRsvd.theadRow = [ ['', '영정'], ['', '빈소명'], ['', '대표상주'], ['', '상례절차'], ['', '상주'], ['', '건물/층수'], ['', '비고'] ];
			theadObjRsvd.theadRowSec = [ ['', ''], ['', '고인명'], ['', '장지'], ['', ''], ['', ''], ['', '합계'], ['', ''] ];
			
			theadInit(theadObj, function(_orderText) { });
			theadInit(theadObjRsvd, function(_orderText) { });

			createTable_list(searchObj, 'now');
			createTable_list(searchObj, 'rsvd');
		}
		
		var divForm = function(){
			_table.find('thead').html("");
			_tableRsvd.find('thead').html("");
			
			createTable_div(searchObj, 'now');
			createTable_div(searchObj, 'rsvd');
		}

		// 리스트 형식 클릭
		$('.btn-list').on('click', function(){
			$('.btn-div').removeClass('ac');
			$('.btn-list').addClass('ac');
			$.pb.settingCookie("dsELD", 1, true);
			listForm();
		});

		// 분할 형식 클릭
		$('.btn-div').on('click', function(){
			$('.btn-div').addClass('ac');
			$('.btn-list').removeClass('ac');
			$.pb.settingCookie("dsELD", 2, true);
			divForm();
		});
		
		if($.pb.getCookie().dsELD == 2){
			$.pb.settingCookie("dsELD", 2, true);
			$('.btn-div').click();
		}else{
			$.pb.settingCookie("dsELD", 1, true);
			$('.btn-list').click();
		}
		
		$('.search-right-wrap > .btn-register').on('click', function() {
			var stateObj = { link:'/29010101', page:'/manager/29010100' };
			
			history.pushState(stateObj, '', stateObj.link);
			$('.main-contents-wrap').pageConnectionHandler(stateObj.page, {  });
		});
		
		$('.event-bar.top > .right-text').on('click', function() { 
			if ((screen.availHeight || screen.height - 30) <= window.innerHeight) closeFullScreenMode();
	      	else openFullScreenMode();
		});
		//모바일/PC 스크립트 인식 구분
		var filter = "win16|win32|win64|mac|macintel";
		if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
		//MOBILE
			document.getElementById("center-txt").style.display="none";

		}
	});
</script>
<div class="event-bar top">
	<span class="center-text" id="center-txt"></span>
	<span class="right-text" style="cursor:pointer;"><img src="/resources/img/icon_full_screen.svg" class="text-icon"/>전체화면</span>
</div>

<div class="space-box"></div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">행사현황</div>
	</div>
	<div class="search-right-wrap">
		<span>상주검색</span>
		<input type="text" class="search-text rb" style="vertical-align:top;" placeholder="예 : 홍길동"/>
		<button type="button" class="search-text-button" style="margin-right:15px; width:80px; background:#093687;">검색</button>
		<button type="button" class="btn-list" value="1">리스트</button>
		<button type="button" class="btn-div" value="2">분할</button>
		<button type="button" class="btn-register">행사예약</button>
	</div>
</div>
<div class="contents-body-wrap now" style="padding-bottom:50px;">
	<table class="pb-table list event">
		<colgroup></colgroup>
		<thead></thead>
	</table>
	<div class="event-body-wrap"></div>
</div>
<div class="search-box-wrap rsvd" style="display:none;">
	<div class="search-left-wrap">
		<div class="search-title">예약현황</div>
	</div>
</div>
<div class="contents-body-wrap rsvd" style="display:none; padding-bottom:50px;">
	<table class="pb-table list event">
		<colgroup></colgroup>
		<thead></thead>
	</table>
	<div class="event-body-wrap"></div>
</div>

<div class="event-bar bottom">
	<span class="left-text"><img src="/resources/img/icon_dongsung_logo.svg" class="text-icon"/>동성바이오 v0.01</span>
	<span class="center-text"></span>
	<span class="right-text"></span>
</div>