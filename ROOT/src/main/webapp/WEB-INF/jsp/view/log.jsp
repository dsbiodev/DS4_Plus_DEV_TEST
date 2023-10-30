<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		$('.select-from-year').createYear({begin:2018});
		$('.select-to-year').createYear({begin:2018});
		$('.select-from-month').createMonth();
		$('.select-to-month').createMonth();
		$('.select-from-day').createDay();
		$('.select-to-day').createDay();
		
		$('.select-from-year').val(new Date((Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24)).getFullYear());
		$('.select-from-month').val(new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1 < 10 ? "0"+(new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1) : new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1);
		$('.select-from-day').val(new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getDate() < 10 ? "0"+new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getDate() : new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getDate());
		
		$('.select-to-month').val(new Date().getMonth()+1 < 10 ? "0"+(new Date().getMonth()+1) : new Date().getMonth()+1);
		$('.select-to-day').val(new Date().getDate() < 10 ? "0"+new Date().getDate() : new Date().getDate());
		
		
		var searchObj = $.extend({}, _param);
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.calFrom = $('.select-from-year').val()+$('.select-from-month').val()+$('.select-from-day').val();
		searchObj.calTo = $('.select-to-year').val()+$('.select-to-month').val()+$('.select-to-day').val();
		searchObj.order = 'LOG_NO DESC';
		
		var _table = $('.contents-body-wrap .pb-table.list');
		var theadObj = { table: _table };
		
		theadObj.colGroup = new Array(8, 10, 8, 15, '*', 10);
		theadObj.theadRow = new Array(['', '구분'], ['', '아이디'], ['', '사용자명'], ['', '행위'], ['', 'Data'], ['CREATE_DT', '일시']);
		
		theadInit(theadObj, function(_orderText) { 
			searchObj.order = _orderText;
			createTable(searchObj); 
		});
		
		$('.search-box-wrap .search-text-button').on('click', function() {
			if(($('.select-from-year').val() + $('.select-from-month').val() + $('.select-from-day').val()) > ($('.select-to-year').val() + $('.select-to-month').val() + $('.select-to-day').val()))
				return alert("기간이 잘못됬습니다.");
			searchObj.currentPage = 1;
			searchObj.queryPage = 0;
			searchObj.calFrom = $('.select-from-year').val()+$('.select-from-month').val()+$('.select-from-day').val();
			searchObj.calTo = $('.select-to-year').val()+$('.select-to-month').val()+$('.select-to-day').val();
			searchObj.searchText = $(this).prev('.search-text').val();
			
			var _pageData = { paging:searchObj };
			var _urlSplit = $(location)[0].pathname.split('/');
			history.pushState(_pageData, '', '/'+_urlSplit[1]+'/1');
			createTable(searchObj);
		});
		
		$('.search-box-wrap .search-text').on('keyup', function(e) {
			if(e.keyCode == 13) $(this).next('.search-text-button').trigger('click');
		});
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectLogList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx;
					_tr.append('<td class="c">'+this.DIVISION_TEXT+'</td>');
					_tr.append('<td class="c">'+this.ID+'</td>');
					_tr.append('<td class="c">'+this.NAME+'</td>');
					_tr.append('<td class="c">'+this.ACTION_TEXT+'</td>');
					_tr.append('<td class="c" style="word-break:break-all;">'+this.DATA_STRING+'</td>');
					_tr.append('<td class="c">'+this.CREATE_DT+'</td>');
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
	});
</script>

<div class="contents-title-wrap">
	<div class="title">로그 관리</div>
</div>

<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">로그 목록</div>
	</div>
	<div class="search-right-wrap">
		<select class="select-from-year" style="width:120px;"></select>
		<select class="select-from-month" style="width:100px;"></select>
		<select class="select-from-day" style="width:100px;"></select>
		<div class="text">부터</div>
		<select class="select-to-year" style="width:120px;"></select>
		<select class="select-to-month" style="width:100px;"></select>
		<select class="select-to-day" style="width:100px;"></select>
		<div class="text">까지</div>
		
		<input type="text" class="search-text rb" placeholder="ID 또는 이름"/>
		<button type="button" class="search-text-button">검색</button>
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