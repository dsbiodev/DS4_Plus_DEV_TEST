<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		var _table = $('.pb-table.list');
		
		var theadObj = {
			table: _table,
			colGroup: new Array(5, 20, '*', 10, 10, 10, 15, 5, 5),
			theadRow: new Array(['', '영정'], ['', '빈소명'], ['ADDRESS', '주소'], ['', '빈소수', 3], ['CONTACT', '대표전화번호'], ['', '테스트', 2]),
			theadRowSec:[ ['', ''], ['', ''], ['', ''], [['ALL', '총'], ['CONTINUE', '진행'], ['EMPTY', '공실']], ['', ''], [['TEST01', '테슷1'], ['TEST02', '테슷2']] ],
		};
		
		theadInit(theadObj, function(_orderText) { 
			searchObj.order = _orderText; 
// 			createTable(searchObj); 
		});
	});
</script>
<div class="contents-title-wrap">
	<div class="title">동성바이오 계정 관리</div>
</div>
<div class="contents-body-wrap">
	<table class="pb-table list" style="margin-top:20px;">
		<colgroup></colgroup>
		<thead></thead>
		<tbody></tbody>
	</table>
	<div class="paging"></div>
</div>