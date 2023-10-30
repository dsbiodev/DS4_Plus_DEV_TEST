<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<script>
	$(function() {
		var _param = JSON.parse('${data}');
		var searchObj = $.extend({}, _param);
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:10):0);
		searchObj.display = (_param.display ? _param.display:10);
		searchObj.eventAliveFlag = true;
// 		searchObj.orderNo = 1;
		searchObj.order = 'EXPOSURE ASC, APPELLATION ASC, ENTRANCE_ROOM_DT ASC';
		$('.contents-body-wrap .pb-table.list').hide();
		

		
		
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
						$('.event-body-wrap').show();
						searchObj.funeralNo = $(this).data('FUNERAL_NO');
						$('.btn-list').click();
						
					}else{
					$('.select-box-wrap .table-search').val("");
					$('.select-box-wrap .table-search').data('funeralNo', null);
					$('.event-body-wrap').hide();
				}
			});
			
			$('.select-box-wrap .table-search').on('keyup', function() {
				$('.select-box-wrap .allList > tbody > tr').removeClass('ac');
				$('.select-box-wrap .allList > tbody > tr').hide();
				if($(this).val()) $('.select-box-wrap .allList > tbody td:contains("'+$(this).val()+'")').parent('tr').show();
				else $('.select-box-wrap .allList > tbody > tr').show();
			});
			
			if($.pb.getCookie().dsZadSearch){
				var _data = $.pb.getCookie().dsZadSearch.split('!@#');
				$('.form-text.table-search').val(_data[0]).keyup();
				$('.select-box-wrap .allList > tbody > tr td[value="'+_data[1]+'"]').parents('tr').addClass('ac').click();
				$.pb.delCookie('dsZadSearch');
			}
		});
		
		
		$('.search-box-wrap .search-text-button').on('click', function() {
			if(!$('.select-box-wrap .table-search').data('funeralNo')) return alert("장례식장을 먼저 선택해 주세요.");	
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
		
		var createTable_list = function(_searchObj, _flag) {
			$.pb.ajaxCallHandler('/admin/selectEventFamily.do', { funeralNo:$('.select-box-wrap .table-search').data('funeralNo') }, function(data) { 
				$('.contents-body-wrap .pb-table.list').show();
				$('.event-body-wrap').removeClass('div').addClass('list');
				searchObj.statusPlate = (_flag == 'now' ? '':false);
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
						var _gender = this.DM_GENDER == 1 ? "남" : "여";
						_wrap01.append('<div>'+(this.DM_NAME ? (this.DM_AGE ? this.DM_NAME+"("+ _gender + "/" + this.DM_AGE + "세)" : this.DM_NAME+"("+_gender+")") : "")+'</div>');
						_tr.append(_wrap01);
						
						var _wrap02 = $('<div style="width:20%;"></div>');
						_wrap02.append('<div>'+(this.CM_NAME ? "상주 : "+ this.CM_NAME : "")+"<br>"+(this.CM_PHONE ? "("+$.pb.phoneFomatter(this.CM_PHONE)+")" : "")+'</div>');
						_wrap02.append('<div class="burial" style="width:100%;">'+(this.BURIAL_PLOT_NAME ? "장지 : "+this.BURIAL_PLOT_NAME.replace('\n', '<br/>') : "")+'</div>');
						_tr.append(_wrap02);
						
						var _entDt = this.ENTRANCE_ROOM_DT ? "입실 : "+new Date(this.ENTRANCE_ROOM_DT).format('MM월 dd일 HH:mm') : "";
						var _entSDt = this.ENTRANCE_ROOM_DT ? "입관 : "+new Date(this.ENTRANCE_ROOM_START_DT).format('MM월 dd일 HH:mm') : "";
						var _carDt = this.ENTRANCE_ROOM_DT ? "발인 : "+new Date(this.CARRYING_DT).format('MM월 dd일 HH:mm') : "";
						_tr.append('<div class="dt" style="width:13%;line-height:34px;">'+_entDt+"<br>"+_entSDt+"<br>"+_carDt+'</div>');
						
						var _this = this;
						_tr.append('<div class="family" style="width:32%;"></div>');
						if(data.length){
							$.each(data, function(){
								if(this.EVENT_NO == _this.EVENT_NO){
									var _div = $('<div class="fa" style="font-weight:500; font-family: Noto Sans KR;">');
									_div.append('<div class="re" style="display:inherit;width:100%"><div style="width:25%;text-align:center;">'+this.RELATION+'</div><div style="width:2%;">:</div>'+'<div style="width:73%;">'+this.NAMES_BASIC+'</div></div>');
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
	 						$.pb.settingCookie("dsZadSearch", $('.form-text.table-search').val()+"!@#"+$('.select-box-wrap .table-search').data('funeralNo'), true);
							
	 						var _eventNo = (_tr.data('PARENT_EVENT_NO') ? _tr.data('PARENT_EVENT_NO'):_tr.data('EVENT_NO'));
	 						if(_eventNo) {
	 							var stateObj = { 
	 								link:'/99100101/'+$('.select-box-wrap .table-search').data('funeralNo')+"&"+_eventNo, 
	 								page:'/admin/99100100'
	 							};
								
	 							history.pushState(stateObj, '', stateObj.link);
	 							$('.main-contents-wrap').pageConnectionHandler(stateObj.page, { pk:$('.select-box-wrap .table-search').data('funeralNo')+'&'+_eventNo });
	 						} else {
	 							var stateObj = { 
	 								link:'/99100101/'+$('.select-box-wrap .table-search').data('funeralNo')+'&', 
	 								page:'/admin/99100100'
								};
								history.pushState(stateObj, '', stateObj.link);
								$('.main-contents-wrap').pageConnectionHandler(stateObj.page, { pk:$('.select-box-wrap .table-search').data('funeralNo')+'&', eventBinsoNo:_tr.data('RASPBERRY_CONNECTION_NO') });
	 						}
						});
						_listWrap.append(_tr);
					});
				});
			});
		};
		
		var createTable_div = function(_searchObj, _flag) {
			$.pb.ajaxCallHandler('/admin/selectEventFamily.do', { funeralNo:$('.select-box-wrap .table-search').data('funeralNo') }, function(data) { 
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
						var _gender = this.DM_GENDER == 1 ? "남" : "여";
						_wrap.append('<div class="name">'+(this.DM_NAME ? (this.DM_AGE ? this.DM_NAME+"("+ _gender + "/" + this.DM_AGE + "세)" : this.DM_NAME+"("+_gender+")") : "")+'</div>');
						_wrap.append('<div class="dt">'+(this.EVENT_NO ? "입관 : " + isNull(new Date(this.ENTRANCE_ROOM_START_DT).format('MM월 dd일 HH:mm')) : "")+'</div>');
						_wrap.append('<div class="dt">'+(this.EVENT_NO ? "발인 : " + isNull(new Date(this.CARRYING_DT).format('MM월 dd일 HH:mm')) : "")+'</div>');
						_wrap.append('<div class="plot">'+(this.EVENT_NO ? "<div>장지</div> : " + "<div>"+isNull(this.BURIAL_PLOT_NAME, " 미정")+"</div>" : "")+'</div>');
						_tr.append(_wrap);
						var _this = this;
						_tr.append('<div class="family"></div>');
						if(data.length){
							$.each(data, function(){
								if(this.EVENT_NO == _this.EVENT_NO){
									var _div = $('<div class="fa" style="display:inherit;width: 100%; font-family: Noto Sans KR;">');
									_div.append('<div class="re" style="display:inherit;width:100%"><div style="width:25%;text-align:center;">'+this.RELATION+'</div><div style="width:2%;">:</div>'+'<div style="width:73%;">'+this.NAMES_BASIC+'</div></div>');
									_tr.find('.family').append(_div);
								}
							});
						}
						_tr.on('click', function() {
	 						$.pb.settingCookie("dsZadSearch", $('.form-text.table-search').val()+"!@#"+$('.select-box-wrap .table-search').data('funeralNo'), true);
	 						
	 						var _eventNo = (_tr.data('PARENT_EVENT_NO') ? _tr.data('PARENT_EVENT_NO'):_tr.data('EVENT_NO'));
	 						if(_eventNo) {
	 							var stateObj = { 
	 								link:'/99100101/'+$('.select-box-wrap .table-search').data('funeralNo')+"&"+_eventNo, 
	 								page:'/admin/99100100'
	 							};
								
	 							history.pushState(stateObj, '', stateObj.link);
	 							$('.main-contents-wrap').pageConnectionHandler(stateObj.page, { pk:$('.select-box-wrap .table-search').data('funeralNo')+'&'+_eventNo });
	 						} else {
	 							var stateObj = { 
	 								link:'/99100101/'+$('.select-box-wrap .table-search').data('funeralNo')+'&', 
	 								page:'/admin/99100100'
								};
								history.pushState(stateObj, '', stateObj.link);
								$('.main-contents-wrap').pageConnectionHandler(stateObj.page, { pk:$('.select-box-wrap .table-search').data('funeralNo')+'&', eventBinsoNo:_tr.data('RASPBERRY_CONNECTION_NO') });
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
			if(!$('.select-box-wrap .table-search').data('funeralNo')) return alert("장례식장을 먼저 선택해 주세요.");	
			$('.btn-div').removeClass('ac');
			$('.btn-list').addClass('ac');
			listForm();
		});

		// 분할 형식 클릭
		$('.btn-div').on('click', function(){
			if(!$('.select-box-wrap .table-search').data('funeralNo')) return alert("장례식장을 먼저 선택해 주세요.");	
			$('.btn-div').addClass('ac');
			$('.btn-list').removeClass('ac');
			divForm();
		});
		
		$('.search-right-wrap > .btn-register').on('click', function() {
			if(!$('.select-box-wrap .table-search').data('funeralNo')) return alert("장례식장을 먼저 선택해 주세요.");	
			var stateObj = { link:'/99100101/'+$('.select-box-wrap .table-search').data('funeralNo')+'&', page:'/admin/99100100' };
				
			history.pushState(stateObj, '', stateObj.link);
			$('.main-contents-wrap').pageConnectionHandler(stateObj.page, { pk:$('.select-box-wrap .table-search').data('funeralNo')+'&' });
		});
		
		$('.event-bar.top > .right-text').on('click', function() { 
			if ((screen.availHeight || screen.height - 30) <= window.innerHeight) closeFullScreenMode();
	      	else openFullScreenMode();
		});
	});
</script>
<div class="select-box-wrap">
	<input type="text" class="form-text table-search">
	<div class="funeral-box">
		<table class="allList">
			<colgroup><col width="100%"/></colgroup>
			<tbody></tbody>
		</table>
	</div>
</div>

<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">행사현황</div>
	</div>
	<div class="search-right-wrap">
		<input type="text" class="search-text rb" style="vertical-align:top;" placeholder="예 : 홍길동"/>
		<button type="button" class="search-text-button" style="margin-right:15px; width:80px; background:#093687;">검색</button>
		<button type="button" class="btn-list">리스트</button>
		<button type="button" class="btn-div">분할</button>
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

