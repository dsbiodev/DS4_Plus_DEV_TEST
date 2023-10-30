<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		$('.select-from-year').createYear({begin:2018});
		$('.select-to-year').createYear({begin:2018});
		$('.select-from-month').createMonth();
		$('.select-to-month').createMonth();
		
		$('.calendar.year').createYear({begin:2018});
		$('.calendar.month').createMonth();

		$('.select-from-year').val(new Date((Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24)).getFullYear());
		$('.select-from-month').val(new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1 < 10 ? "0"+(new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1) : new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1);
		$('.select-to-month').val(new Date().getMonth()+1 < 10 ? "0"+(new Date().getMonth()+1) : new Date().getMonth()+1);

		var searchObj = _param;
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.calFrom = $('.select-from-year').val() + $('.select-from-month').val();
		searchObj.calTo = $('.select-to-year').val() + $('.select-to-month').val();
		searchObj.order = 'SIDO DESC';
		
		var _table = $('.pb-table.list');
		
		var theadObj = {
			table: _table,
			colGroup:new Array(50, 50),
			theadRow:[['SIDO_NAME', '지역'], ['CNT', '진행']]
		};
		
		theadInit(theadObj, function(_orderText) {
			searchObj.order = _orderText; 
			createTable(searchObj); 
		});
		
		$('.search-text-button.search').on('click', function(){
			if(($('.select-from-year').val() + $('.select-from-month').val()) > ($('.select-to-year').val() + $('.select-to-month').val()))
				return alert("기간이 잘못됬습니다.");
			searchObj.calFrom = $('.select-from-year').val() + $('.select-from-month').val();
			searchObj.calTo = $('.select-to-year').val() + $('.select-to-month').val();
			createTable(searchObj);
		});
		
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/adminSec/selectStatisticsAreaList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td class="c">'+this.SIDO_NAME+'</td>');
					_tr.append('<td class="c">'+this.CNT+'</td>');
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
		
		$('.btn-excel').on('click', function(){
			fnExcelReport('statisticsArea', '지역별 통계');
		});
	});
</script>
<div class="contents-title-wrap">
	<div class="title">지역별 통계</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">지역별 행사 건수</div>
	</div>
	<div class="search-right-wrap">
		<select class="select-from-year"></select>
		<select class="select-from-month"></select>
		<div class="text">부터</div>
		<select class="select-to-year"></select>
		<select class="select-to-month"></select>
		<div class="text">까지</div>
		
		<button type="button" class="search-text-button search" style="border-radius:4px;">검색</button>
		<button type="button" class="btn-excel">엑셀 다운로드</button>
	</div>
</div>
<div class="contents-body-wrap">
	<table class="pb-table list" id="statisticsArea">
		<colgroup></colgroup>
		<thead></thead>
		<tbody></tbody>
	</table>
	<div class="paging"></div>
</div>