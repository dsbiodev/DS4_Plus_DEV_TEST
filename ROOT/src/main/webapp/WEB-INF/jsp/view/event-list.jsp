<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = $.extend({}, _param);
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
		
		//행사목록보기 타 장례식장 목록 오류 테스트		
		//console.log("searchObj.funeralNo ==> : ", searchObj.funeralNo);
		if(searchObj.funeralNo=='' || searchObj.funeralNo==null){
			
			//페이지 한번만 새로 고침
			if (self.name != 'reload'){
			    self.name = 'reload';
			    self.location.reload(true);
			}else self.name = '';
		}
		// ./행사목록보기 타 장례식장 목록 오류 테스트
		
		
		searchObj.orderNo = 1;
		searchObj.order = 'EVENT_NO DESC';
		
		var _table = $('.contents-body-wrap .pb-table.list');
		var theadObj = { table: _table };
		theadObj.colGroup = new Array(8, 8, 8, 8, 10, 12, 12, '*', 8, 7, 7);
		theadObj.theadRow = new Array(['', '빈소'], ['', '상조회 정보'], ['', '고인명'], ['', '상주명'], ['', '연락처'], ['', '입실일시'], ['', '발인일시'], ['', '장지'], ['', '정산비용'], ['', '상태'], ['', '']);
		
		theadInit(theadObj, function(_orderText) { 
			searchObj.order = _orderText;
			createTable(searchObj);
		});
		
		/*//original
		var _sDate = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate() - 7); 
		var _sDateObj = $.pb.createDateObj(_sDate);
		var _eDateObj = $.pb.createDateObj();
		console.log("step 1");
		*/
		//date set
		var tmpStdDt = new Date(new Date().getFullYear(), new Date().getMonth(), 1); 
		var stdDt = $.pb.createDateObj(tmpStdDt);
		var edDt = $.pb.createDateObj();
		
		
		//date comboBox Set
		//var _searchBox = $('.main-contents-wrap > .contents-title-wrap > .search-box');		
		
		/*//original
		_searchBox.find('select[name=sYear]').sysDate('year', { begin:2019, unit:'년', selected:_sDateObj.year } );
		_searchBox.find('select[name=sMonth]').sysDate('month', { unit:'월', selected:_sDateObj._month } );
		_searchBox.find('select[name=sDay]').sysDate('day', { unit:'일', selected:_sDateObj._day } );
		
		_searchBox.find('select[name=eYear]').sysDate('year', { begin:2019, unit:'년', selected:_sDateObj.year } );
		_searchBox.find('select[name=eMonth]').sysDate('month', { unit:'월', selected:_eDateObj._month } );
		_searchBox.find('select[name=eDay]').sysDate('day', { unit:'일', selected:_eDateObj._day } );
		*/
		
		
		var searchBox = $('.main-contents-wrap > .contents-title-wrap > .search-box');
		searchBox.find('select[name=sYear]').sysDate('year', { begin:stdDt.year-3, unit:'년', selected:stdDt.year } );
		searchBox.find('select[name=sMonth]').sysDate('month', { unit:'월', selected:stdDt._month } );
		searchBox.find('select[name=sDay]').sysDate('day', { unit:'일', selected:stdDt._day } );
		
		searchBox.find('select[name=eYear]').sysDate('year', { begin:stdDt.year-3, unit:'년', selected:stdDt.year } );
		searchBox.find('select[name=eMonth]').sysDate('month', { unit:'월', selected:edDt._month } );
		searchBox.find('select[name=eDay]').sysDate('day', { unit:'일', selected:edDt._day } );
		
			
		
		var createTable = function(_searchObj) {			
			_searchObj.searchStartDt = $('select[name=sYear]').val()+'-'+$('select[name=sMonth]').val()+'-'+$('select[name=sDay]').val();
			_searchObj.searchEndDt = $('select[name=eYear]').val()+'-'+$('select[name=eMonth]').val()+'-'+$('select[name=eDay]').val();
			
			$.pb.ajaxCallHandler('/admin/selectEventList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td class="c">'+this.APPELLATION+'</td>');
					_tr.append('<td class="c">'+this.CARRYING_PLACE+'</td>');
					_tr.append('<td class="c">'+this.DM_NAME+'</td>');
					_tr.append('<td class="c">'+this.CM_NAME+'</td>');
					_tr.append('<td class="c">'+$.pb.phoneFomatter(this.CM_PHONE)+'</td>');
					_tr.append('<td class="c">'+new Date(this.ENTRANCE_ROOM_DT).format('yyyy-MM-dd HH:mm')+'</td>');
					_tr.append('<td class="c">'+(this.CARRYING_YN == 0 ? '미정' : new Date(this.CARRYING_DT).format('yyyy-MM-dd HH:mm'))+'</td>');
					_tr.append('<td class="c">'+this.BURIAL_PLOT_NAME+'</td>');
					_tr.append('<td class="c">'+(this.RST_PRICE ? $.pb.targetMoney(this.RST_PRICE) : '-')+'</td>');

					//console.log(this.FUNERAL_NO);
					
					var _timeDiff = $.pb.returnTimeDiff(new Date(), new Date(_tr.data('CARRYING_DT').replace(/\s/gi, 'T')));
					_tr.append('<td class="c">'+(this.EVENT_ALIVE_FLAG ? (_timeDiff.timeDiff < 0 ? '행사종료':'진행중'):'행사마감')+'</td>');
					_tr.append('<td class="c">'+(this.EVENT_ALIVE_FLAG ? '-':(_timeDiff.timeDiff < 0 ? '-':'<span class="cancellation">마감취소</span>'))+'</td>');
					_tr.on('click', function(e) {
						var _target = $(e.target);
						
						if(_target.hasClass('cancellation')) {
							var _binsoOlpObj = {
									overlapNo: _param.pk, 
									eventAliveFlag: true,
									binsoOverlap: true,
									funeralNo: '${sessionScope.loginProcess.FUNERAL_NO}',
									binsoList: _tr.data('RASPBERRY_CONNECTION_NO'),
									entranceRoomDt: _tr.data('ENTRANCE_ROOM_DT'),
									carryingDt: _tr.data('CARRYING_DT')
								};


								
								var _entranceRoomObj = { 
									overlapNo: _param.pk, 
									eventAliveFlag: true,
									entranceRoomOverlap: true,
									funeralNo: '${sessionScope.loginProcess.FUNERAL_NO}', 
									entranceRoomNo: _tr.data('ENTRANCE_ROOM_NO'), 
									entranceRoomStartDt: _tr.data('ENTRANCE_ROOM_START_DT'), 
									entranceRoomEndDt: _tr.data('ENTRANCE_ROOM_END_DT')
								};

								
								$.pb.ajaxCallHandler('/admin/selectEventList.do', _binsoOlpObj, function(binsoOverlap) {
									$.pb.ajaxCallHandler('/admin/selectEventList.do', _entranceRoomObj, function(entranceRoomOverlap) {
										if(binsoOverlap.list.length) return alert('사용중인 빈소가 있습니다.');
// 										else if(entranceRoomOverlap.list.length) return alert('사용중인 입관실이 있습니다.');
										else {
											alert('마감 취소되었습니다.');
											$.pb.ajaxCallHandler('/admin/updateEventAliveFlag.do', { eventNo:_tr.data('EVENT_NO'), funeralNo:_tr.data('FUNERAL_NO'), eventAliveFlag:1, rpiBinsoNo:_tr.data('RASPBERRY_CONNECTION_NO') }, function(eventAliveRst) {
												createTable(searchObj);
											});
										}
									});
								});
						} else{
							var stateObj = {
								
 								/* link:'/29010101/'+_tr.data('EVENT_NO'), 
 								page:'/manager/29010100' */
									link:'/29010201/'+ _tr.data('EVENT_NO'), //HYH - 목록보기 이동시 간편 분향실 관리로 이동 시킴.
									page:'/manager/29010200'
 								
 							};
							if('${sessionScope.loginProcess.FUNERAL_NO}' == 1207) {
								stateObj.page = '/manager/29010300'
							}else if('${sessionScope.loginProcess.FUNERAL_NO}' == 523) {
								stateObj.page = '/manager/29010300'
							}
 							history.pushState(stateObj, '', stateObj.link);
 							$('.main-contents-wrap').pageConnectionHandler(stateObj.page, { pk:_tr.data('EVENT_NO') });
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
		
		createTable(searchObj);
		
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
			searchObj.searchText = $(this).prev('.search-text').val();
			createTable(searchObj);
		});
	});
</script>
<style>
	.search-box { display:flex; align-items:center; }
	@media ( max-width: 700px ) {
/* 		.search-box { display:inline-block; } */
		.main-contents-wrap > .contents-title-wrap > .search-box > .search-select { width:120px; margin-left:0px;padding-left:0px;}
		.main-contents-wrap > .search-box-wrap { margin-top:180px; }
		.main-contents-wrap > .contents-title-wrap > .search-box > .search-text-wrap > .search-text { width:70%; }
		.main-contents-wrap > .contents-title-wrap > .search-box > .search-text-wrap > .search-text-btn { width:28%; }
	}
	
</style>
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