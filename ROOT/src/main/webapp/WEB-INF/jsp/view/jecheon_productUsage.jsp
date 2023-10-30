<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>

	$(function() {
		
		//setting
		setDate();
	
		var searchObj = makeParam();
		
		var _dtExcel="";
								
		displayList(searchObj);
	});
	
	function makeParam(){
		
		var _param = JSON.parse('${data}');
		
		var searchObj = $.extend({}, _param);
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:30):0);
		searchObj.display = (_param.display ? _param.display:30);			
		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';	
		searchObj.stDt = $('.select-from-year').val()+$('.select-from-month').val()+$('.select-from-day').val()+'000000';
		searchObj.endDt = $('.select-to-year').val()+$('.select-to-month').val()+$('.select-to-day').val()+'235959';
		
		return searchObj;
	};
	
	
	function setDate(){
		
		//from date
		$('.select-from-year').createYear({begin:2021});		
		$('.select-from-month').createMonth();		
		$('.select-from-day').createDay();
				
		//to date
		$('.select-to-year').createYear({begin:2021});
		$('.select-to-month').createMonth();
		$('.select-to-day').createDay();
			
		//data set
		var curDate = new Date();
		$('.select-from-year').val(curDate.getFullYear());
		$('.select-from-month').val(curDate.getMonth()+1 < 10 ? "0"+(curDate.getMonth()+1) : curDate.getMonth()+1);				 
		$('.select-from-day').val("0"+new Date(curDate.getFullYear(),curDate.getMonth(),1).getDate());
		
		$('.select-to-year').val(curDate.getFullYear());
		$('.select-to-month').val(curDate.getMonth()+1 < 10 ? "0"+(curDate.getMonth()+1) : curDate.getMonth()+1);		
		$('.select-to-day').val(new Date(curDate.getFullYear(),curDate.getMonth(),0).getDate());			
	};
	
	$('.search-text-button.search').on('click', function(){
		
		//date validation
		var stDt = new Date($('.select-from-year').val()+'-'+$('.select-from-month').val()+'-'+$('.select-from-day').val());
		var endDt = new Date($('.select-to-year').val()+'-'+$('.select-to-month').val()+'-'+$('.select-to-day').val());		
							
		var tDiff = endDt.getTime() - stDt.getTime();
		tDiff = Math.floor(tDiff/(1000 * 60 * 60 * 24));
				
		if(tDiff < 0) {
			alert('조회일자 시작일이 종료일보다 클 수 없습니다.');
			return;
		}
			
		var searchObj = makeParam();
		displayList(searchObj);
			
	});
	
	
	function displayList(searchObj){
		
		var _table = $('.pb-table.list');	
		
		var excelTbl = $('.pb-table.excel');	
		excelTbl.find('tbody').html('');	
		
		_dtExcel="";
		
		$.pb.ajaxCallHandler('/admin/selectProductUsage.do', searchObj, function(dtResult) {
									
			_table.find('tbody').html('');
			
			if(dtResult.list.length > 0){
				
				_dtExcel = dtResult;
				
				//paging count set
				searchObj.total = dtResult.list.length;
				searchObj.lastPage = Math.ceil(searchObj.total / 30);
											
				var stCnt = searchObj.queryPage;
				var edCnt = searchObj.queryPage+30;
							
				for(var i=stCnt; i<edCnt; i++){
 						
 						if(dtResult.list[i] != null){ 							 					
 						
							var dRow = "";
																				
							dRow += '<tr>';							
							dRow += '<td align="center">'+dtResult.list[i].NAME+'</td>';					//제품명
							dRow += '<td align="center">'+dtResult.list[i].CNT+'</td>';						//개수						
							dRow += '<td align="right">'+addComma(dtResult.list[i].PRICE)+'</td>';			//단가
							dRow += '<td align="right">'+addComma(dtResult.list[i].ORDER_PRICE)+'</td>';	//금액							
							
							dRow += '</tr>';
								
							$('#usageList').append(dRow);
 						}
					}
								
				//합계 row add
				if(searchObj.currentPage == searchObj.lastPage){
														
					addTotal(dtResult);										
				}
							
				//paging				
				$('.contents-body-wrap > .paging').createPaging(searchObj, function(page) {														

					var pageObj =  searchObj;
			    	pageObj.pk = page;
			    	pageObj.currentPage = page;
			    	pageObj.queryPage = (page-1)*(searchObj.display*1);
			    				    				    	
					var _urlSplit = $(location)[0].pathname.split('/');
					history.pushState({ paging:pageObj }, '', '/'+_urlSplit[1]+'/'+pageObj.currentPage);
					displayList(pageObj);												
			    });																					
			}else{
				alert("해당 일자에 데이터가 존재하지 않습니다.")
			}	 	
		});																																																										
	};
	
	function addTotal(dtResult){
		
		var totSum = 0;
		
		for(var i=0; i<dtResult.list.length; i++){
			
			totSum += parseInt(dtResult.list[i].ORDER_PRICE);														
		}		
		
		var dRow = "";
		
		dRow += '<tr>';							
		dRow += '<td align="center" style="background:lightgray; font-weight:bold; font-style:italic;">'+"총  계"+'</td>';		//총계
		dRow += '<td align="center" style="background:lightgray; font-weight:bold; font-style:italic;">'+""+'</td>';								
		dRow += '<td align="right" style="background:lightgray; font-weight:bold; font-style:italic;">'+""+'</td>';			
		dRow += '<td align="right" style="background:lightgray; font-weight:bold; font-style:italic;">'+addComma(totSum)+'</td>';		
		dRow += '</tr>';
			
		$('#usageList').append(dRow);		
	};


	//숫자 value 콤마 정규식
	function addComma(num) {
		  var regexp = /\B(?=(\d{3})+(?!\d))/g;
		  return num.toString().replace(regexp, ',');
	};	
	
	$('.btn-excel').on('click', function(){
						
		makeExcelDt(_dtExcel);
		
		fnExcelReport('excelTbl', '제품 사용량 조회');
	});	
	
	function makeExcelDt(dtResult){				

		var totSum = 0;
		
		for(var i=0; i<dtResult.list.length; i++){

			var dRow = "";
																
			dRow += '<tr>';							
			dRow += '<td align="center">'+dtResult.list[i].NAME+'</td>';					//제품명
			dRow += '<td align="center">'+dtResult.list[i].CNT+'</td>';						//개수						
			dRow += '<td align="right">'+addComma(dtResult.list[i].PRICE)+'</td>';			//단가
			dRow += '<td align="right">'+addComma(dtResult.list[i].ORDER_PRICE)+'</td>';	//금액		
			totSum += parseInt(dtResult.list[i].ORDER_PRICE);		
			
			dRow += '</tr>';
				
			$('#excelTbl').append(dRow);			
		}
		
		
		var tRow = "";
		
		tRow += '<tr>';							
		tRow += '<td align="center"; font-weight="bold";>'+"총  계"+'</td>';		//총계
		tRow += '<td align="center">'+""+'</td>';								
		tRow += '<td align="right">'+""+'</td>';			
		tRow += '<td align="right">'+addComma(totSum)+'</td>';		
		tRow += '</tr>';
			
		$('#excelTbl').append(tRow);
		
	};	

				
</script>
<style>	
	.pb-table.list td { padding: 6px 6px; font-size: 12px;}
	
</style>
<div class="contents-title-wrap">
	<div class="title">제품 사용량 조회</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">검색결과</div>
	</div>
	
	<div class="search-right-wrap">			
		<select class="select-from-year" style="position:relative; z-index:1;"></select>
		<select class="select-from-month"></select>
		<select class="select-from-day"></select>
		<div class="text">~</div>
		<select class="select-to-year"></select>
		<select class="select-to-month"></select>
		<select class="select-to-day"></select>		
		<div class="text"></div>
		
		<button type="button" class="search-text-button search" style="border-radius:4px;">검색</button>
		<button type="button" class="btn-excel">엑셀 다운로드</button>
	</div>
</div>
<div class="contents-body-wrap">
	<table class="pb-table list" style="width:90%; margin:auto;" id=usageList>
		<colgroup></colgroup>
		<thead>
			<tr>
				<th style="width:300px;">제품명</th>
				<th style="width:100px;">사용개수</th>
				<th style="width:400px; ">단가</th>
				<th style="width:400px; ">총 금 액(원)</th>								
			</tr>
		</thead>
		
		<tbody>					
		</tbody>
	</table>	
	<div class="paging"></div>
</div>
<div class="contents-body-wrap">
	<table class="pb-table excel" style="width:80%;visibility: hidden; " id=excelTbl>
		<colgroup></colgroup>
		<thead>
			<tr>
				<th style="width:300px;">제품명</th>
				<th style="width:100px;">사용개수</th>
				<th style="width:400px; ">단가</th>
				<th style="width:400px; ">총 금 액(원)</th>								
			</tr>
		</thead>
		
		<tbody>					
		</tbody>
	</table>	
	
</div>