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
		
		$('input[type=radio][name=dayFlag]').siteRadio({ addText:['월별통계', '일별통계'], fontSize:'20px', matchParent:false });
		$('input[type=radio][name=dayFlag][value=month]').click();
		$('input[type=radio][name=dayFlag]').on('change', function(){
			if($(this).val() == 'month'){
				$('.select-from-day').hide();
				$('.select-to-day').hide();
			}else{
				$('.select-from-day').show();
				$('.select-to-day').show();
			}
		});
		$('.select-from-day').hide();$('.select-to-day').hide();
		
		var searchObj = _param;
		searchObj.calFrom = $('.select-from-year').val() +"-"+ $('.select-from-month').val();
		searchObj.calTo = $('.select-to-year').val() +"-"+ $('.select-to-month').val();
		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
		searchObj.dayFlag = 'month';
		searchObj.order = 'CREATE_DT';
		var _table = $('.pb-table.list');
		
		$('.search-text-button.search').on('click', function(){
			searchObj.dayFlag = $('input[name=dayFlag]:checked').val();
			if(searchObj.dayFlag == 'month'){
				if(($('.select-from-year').val() + $('.select-from-month').val()) > ($('.select-to-year').val() + $('.select-to-month').val()))
					return alert("기간이 잘못됬습니다.");
				searchObj.calFrom = $('.select-from-year').val() +"-"+ $('.select-from-month').val();
				searchObj.calTo = $('.select-to-year').val() +"-"+ $('.select-to-month').val();
			}else{
				if(new Date($('.select-from-year').val() +"-"+ $('.select-from-month').val() +"-"+ $('.select-from-day').val()).format('yyyyMMdd') > new Date($('.select-to-year').val() +"-"+ $('.select-to-month').val() +"-"+ $('.select-to-day').val()).format('yyyyMMdd'))
					return alert("기간이 잘못됬습니다.");
				searchObj.calFrom = $('.select-from-year').val() +"-"+ $('.select-from-month').val() +"-"+ $('.select-from-day').val();
				searchObj.calTo = $('.select-to-year').val() +"-"+ $('.select-to-month').val() +"-"+ $('.select-to-day').val();
			}
			createTable(searchObj);
		});
		
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/adminSec/selectStatisticsCalList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				if(tableData.list.length > 0){
					var _sDate = new Date(_searchObj.calFrom);
					var _eDate = new Date(_searchObj.calTo);
					var tempDt = new Date(_sDate.getFullYear(), _sDate.getMonth(), _sDate.getDate());
					var _tmpObj = { dateCol:[] };
					var dtCount = 1;
					
					if(_searchObj.dayFlag == 'month'){
						while(tempDt.getTime() <= _eDate.getTime()) {							
							var _nowDate = new Date(tempDt.getFullYear(), tempDt.getMonth(), tempDt.getDate()).format('yyyy-MM')
							_tmpObj.dateCol.push(_nowDate);
							tempDt = new Date(_sDate.getFullYear(), _sDate.getMonth()+dtCount, _sDate.getDate());
							dtCount++;
						};
					}else{
						while(tempDt.getTime() <= _eDate.getTime()) {
							var _nowDate = new Date(tempDt.getFullYear(), tempDt.getMonth(), tempDt.getDate()).format('yyyy-MM-dd')
							_tmpObj.dateCol.push(_nowDate);
							tempDt = new Date(_sDate.getFullYear(), _sDate.getMonth(), _sDate.getDate()+dtCount);
							dtCount++;
						};
					}
					
					$.each(tableData.list, function() {
						var _ = this;
						var _overlapFlag = false;
						$.each(_table.find('#partner > th'), function(idx, _value) {
							if($(_value).text() == _.PARTNER_NAME) _overlapFlag = true;
						});
						if(!_overlapFlag) _table.find('#partner').append('<th colspan="3" data-partner-no="'+_.PARTNER_NO+'">'+_.PARTNER_NAME+'</th>');
						if(!_overlapFlag) _table.find('#partner_sale').append('<th>입고가</th><th>매출</th><th>마진(마진율)</th>');
					});
						
					$('#price').attr('colspan', $('#partner > th').length*3);
					$.each(_tmpObj.dateCol, function(idx, _value) {
						var _tr = $('<tr>');
						_tr.append('<td class="c">'+_value+'</td>');
						$.each(_table.find('#partner > th'), function(idx) {
							var _no = $(this).data('partner-no');
							_tr.append('<td class="c" style="text-align:right;">0</td>');
							_tr.append('<td class="c" style="text-align:right;">0</td>');
							_tr.append('<td class="c" style="text-align:right;">0</td>');
							$.each(tableData.list, function() {
								if(this.PARTNER_NO == _no && _value == this.CREATE_DT) _tr.find('td').last().prev().prev().html($.pb.targetMoney(this.W_PRICE)+"");
								if(this.PARTNER_NO == _no && _value == this.CREATE_DT) _tr.find('td').last().prev().html($.pb.targetMoney(this.PRICE)+"");
								if(this.PARTNER_NO == _no && _value == this.CREATE_DT) _tr.find('td').last().html($.pb.targetMoney(this.PRICE-this.W_PRICE)+""+"("+((this.PRICE-this.W_PRICE)/this.PRICE*100).toFixed(1)+"%)");
							});
						});
	
						_table.find('tbody').append(_tr);
					});
					
				}
			});
		
		};
		createTable(searchObj);
		
		$('.btn-excel').on('click', function(){
			fnExcelReport('statisticsCal', '매출 통계');
		});
	});
</script>
<style>
	.site-radio-label { padding:9px; vertical-align:sub; }
	.pb-table.list td { padding: 6px 6px; font-size: 12px;}
	
</style>
<div class="contents-title-wrap">
	<div class="title">매출통계</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">검색결과</div>
	</div>
	<div class="search-right-wrap">
		
		<div style="display:inline-block; width:425px; position:absolute; right:1100px;">
			<input type="radio" name="dayFlag" value="month"/>
			<input type="radio" name="dayFlag" value="day"/>
		</div>
		
		<select class="select-from-year" style="position:relative; z-index:1;"></select>
		<select class="select-from-month"></select>
		<select class="select-from-day"></select>
		<div class="text">부터</div>
		<select class="select-to-year"></select>
		<select class="select-to-month"></select>
		<select class="select-to-day"></select>
		<div class="text">까지</div>
		
		<button type="button" class="search-text-button search" style="border-radius:4px;">검색</button>
		<button type="button" class="btn-excel">엑셀 다운로드</button>
	</div>
</div>
<div class="contents-body-wrap">
	<table class="pb-table list" id="statisticsCal">
		<colgroup></colgroup>
		<thead>
			<tr>
				<th rowspan="3">날짜</th>
				<th id="price">업체별 매출 통계</th>
			</tr>
			<tr id="partner">
			<tr id="partner_sale">
			</tr>
		</thead>
		<tbody></tbody>
	</table>
</div>