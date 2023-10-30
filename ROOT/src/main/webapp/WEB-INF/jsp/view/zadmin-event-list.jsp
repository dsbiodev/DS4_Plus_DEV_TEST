<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = $.extend({}, _param);
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
// 		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
		searchObj.orderNo = 1;
		searchObj.order = 'EVENT_NO DESC';
		
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
					$('.pb-table.list tbody').html("");
					$('.paging').html("");
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
		
		var _table = $('.contents-body-wrap .pb-table.list');
		var theadObj = { table: _table };
		theadObj.colGroup = new Array(8, 8, 8, 10, 12, 12, '*', 8, 7, 7);
		theadObj.theadRow = new Array(['', '빈소'], ['', '고인명'], ['', '상주명'], ['', '연락처'], ['', '입실일시'], ['', '발인일시'], ['', '장지'], ['', '정산비용'], ['', '상태'], ['', '']);
		
		theadInit(theadObj, function(_orderText) { 
			searchObj.order = _orderText;
			createTable(searchObj);
		});
		
		var _sDate = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate() - 7); 
		var _sDateObj = $.pb.createDateObj(_sDate);
		var _eDateObj = $.pb.createDateObj();
		
		var _searchBox = $('.main-contents-wrap > .contents-title-wrap > .search-box');
		_searchBox.find('select[name=sYear]').sysDate('year', { begin:2019, unit:'년', selected:_sDateObj.year } );
		_searchBox.find('select[name=sMonth]').sysDate('month', { unit:'월', selected:_sDateObj._month } );
		_searchBox.find('select[name=sDay]').sysDate('day', { unit:'일', selected:_sDateObj._day } );
		
		_searchBox.find('select[name=eYear]').sysDate('year', { begin:2019, unit:'년', selected:_sDateObj.year } );
		_searchBox.find('select[name=eMonth]').sysDate('month', { unit:'월', selected:_eDateObj._month } );
		_searchBox.find('select[name=eDay]').sysDate('day', { unit:'일', selected:_eDateObj._day } );
		
		
		var createTable = function(_searchObj) {
			_searchObj.searchStartDt = $('select[name=sYear]').val()+'-'+$('select[name=sMonth]').val()+'-'+$('select[name=sDay]').val();
			_searchObj.searchEndDt = $('select[name=eYear]').val()+'-'+$('select[name=eMonth]').val()+'-'+$('select[name=eDay]').val();
			$.pb.ajaxCallHandler('/admin/selectEventList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td class="c">'+this.APPELLATION+'</td>');
					_tr.append('<td class="c">'+this.DM_NAME+'</td>');
					_tr.append('<td class="c">'+this.CM_NAME+'</td>');
					_tr.append('<td class="c">'+$.pb.phoneFomatter(this.CM_PHONE)+'</td>');
					_tr.append('<td class="c">'+new Date(this.ENTRANCE_ROOM_DT).format('yyyy-MM-dd HH:mm')+'</td>');
					_tr.append('<td class="c">'+(this.CARRYING_YN == 0 ? '미정' : new Date(this.CARRYING_DT).format('yyyy-MM-dd HH:mm'))+'</td>');
					_tr.append('<td class="c">'+this.BURIAL_PLOT_NAME+'</td>');
					_tr.append('<td class="c">'+(this.RST_PRICE ? $.pb.targetMoney(this.RST_PRICE) : '-')+'</td>');

					var _timeDiff = $.pb.returnTimeDiff(new Date(), new Date(_tr.data('CARRYING_DT').replace(/\s/gi, 'T')));
					_tr.append('<td class="c">'+(this.EVENT_ALIVE_FLAG ? (_timeDiff.timeDiff < 0 ? '행사종료':'진행중'):'행사마감')+'</td>');
					_tr.append('<td class="c">'+(this.EVENT_ALIVE_FLAG ? '-':(_timeDiff.timeDiff < 0 ? '-':'<span class="cancellation">마감취소</span>'))+'</td>');
					_tr.on('click', function(e) {
 						$.pb.settingCookie("dsZadSearch", $('.form-text.table-search').val()+"!@#"+$('.select-box-wrap .table-search').data('funeralNo'), true);
						
						var _target = $(e.target);
						
						if(_target.hasClass('cancellation')) {
							var _binsoOlpObj = {
									overlapNo: _param.pk, 
									eventAliveFlag: true,
									binsoOverlap: true,
									funeralNo: $('.select-box-wrap .table-search').data('funeralNo'),
									binsoList: _tr.data('RASPBERRY_CONNECTION_NO'),
									entranceRoomDt: _tr.data('ENTRANCE_ROOM_DT'),
									carryingDt: _tr.data('CARRYING_DT')
								};
								
								var _entranceRoomObj = { 
									overlapNo: _param.pk, 
									eventAliveFlag: true,
									entranceRoomOverlap: true,
									funeralNo: $('.select-box-wrap .table-search').data('funeralNo'), 
									entranceRoomNo: _tr.data('ENTRANCE_ROOM_NO'), 
									entranceRoomStartDt: _tr.data('ENTRANCE_ROOM_START_DT'), 
									entranceRoomEndDt: _tr.data('ENTRANCE_ROOM_END_DT')
								};
								
								$.pb.ajaxCallHandler('/admin/selectEventList.do', _binsoOlpObj, function(binsoOverlap) {
									$.pb.ajaxCallHandler('/admin/selectEventList.do', _entranceRoomObj, function(entranceRoomOverlap) {
										if(binsoOverlap.list.length) return alert('사용중인 빈소가 있습니다.');
// 										else if(entranceRoomOverlap.list.length) return alert('사용중인 입관실이 있습니다.');
										else {
											$.pb.ajaxCallHandler('/admin/updateEventAliveFlag.do', { eventNo:_tr.data('EVENT_NO'), funeralNo:_tr.data('FUNERAL_NO'), eventAliveFlag:1 }, function(eventAliveRst) {
												createTable(searchObj);
											});
										}
									});
								});
						} else{
 							var stateObj = { 
 								link:'/99100101/'+$('.select-box-wrap .table-search').data('funeralNo')+"&"+_tr.data('EVENT_NO'), 
 								page:'/admin/99100100'
 							};
							
 							history.pushState(stateObj, '', stateObj.link);
 							$('.main-contents-wrap').pageConnectionHandler(stateObj.page, { pk:$('.select-box-wrap .table-search').data('funeralNo')+'&'+_tr.data('EVENT_NO') });
						}
					});
					
					_table.find('tbody').append(_tr);
				});
				
				_searchObj.total = tableData.total;
				$('.contents-body-wrap > .paging').createPaging(_searchObj, function(_page) {
					var pageObj = _searchObj;
		        	pageObj.pk = _page;
		        	pageObj.currentPage = _page;
		        	pageObj.queryPage = (_page-1)*(_searchObj.display*1);
		        	
					var _urlSplit = $(location)[0].pathname.split('/');
					history.pushState({ paging:pageObj }, '', '/'+_urlSplit[1]+'/'+pageObj.currentPage);
					createTable(pageObj);
		        });
				
				_table.tableEmptyChecked('검색 결과가 없습니다.');
			});
		};
// 		createTable(searchObj);
		
		$('.contents-title-wrap > .search-box > .search-text-wrap > .search-text').on('keyup', function(e) {
			if(e.keyCode == 13) {
				$(this).next(".search-text-btn").trigger('click');
			}
		});
		
		$('.search-box .search-select').on('change', function() {
			var _start = new Date($('select[name=sYear]').val()+'-'+$('select[name=sMonth]').val()+'-'+$('select[name=sDay]').val());
			var _end = new Date($('select[name=eYear]').val()+'-'+$('select[name=eMonth]').val()+'-'+$('select[name=eDay]').val());
			var _tDiff = _end.getTime() - _start.getTime();
			_tDiff = Math.floor(_tDiff/(1000 * 60 * 60 * 24));
			
			if(_tDiff < 0) {
				alert('시작일이 종료일보다 클 수 없습니다.');
				
				var _startObj = $.pb.createDateObj(new Date($('select[name=sYear]').val(), ($('select[name=sMonth]').val()-1), ($('select[name=sDay]').val()*1+7)));
				$('select[name=eYear]').sysDate('year', { begin:_startObj.year, unit:'년'} );
				$('select[name=eMonth]').sysDate('month', { unit:'월', selected:_startObj._month } );
				$('select[name=eDay]').sysDate('day', { unit:'일', selected:_startObj._day } );
			}
		});
		
		
		$('#btnSearch').on('click', function() {
			if(!$('.select-box-wrap .table-search').data('funeralNo')) return alert("장례식장을 먼저 선택해 주세요.");	
			searchObj.searchText = $(this).prev('.search-text').val();
			createTable(searchObj);
		});
	});
</script>
<style>
.search-box { display:inline; }
</style>
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
	<div class="title">행사목록</div>
	<div class="sub-title">설정된 기간과 고인 또는 상주명을 통해 행사를 검색할 수 있습니다.</div>
	<div class="search-box">
		<select class="search-select year" name="sYear"></select>
		<select class="search-select month" name="sMonth"></select>
		<select class="search-select day" name="sDay"></select>
		<span class="text">부터</span>
		<select class="search-select year" name="eYear"></select>
		<select class="search-select month" name="eMonth"></select>
		<select class="search-select day" name="eDay"></select>
		<span class="text">까지</span>
		<div class="search-text-wrap">
			<input type="text" class="search-text" placeholder="고인 또는 상주명을 입력 해주세요"/>
			<button type="button" class="search-text-btn" id="btnSearch">행사 검색</button>
		</div>
	</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">검색 결과</div>
	</div>
</div>
<div class="contents-body-wrap">
	<table class="pb-table list">
		<colgroup></colgroup>
		<thead></thead>
		<tbody></tbody>
	</table>
	<div class="paging"></div>
</div>