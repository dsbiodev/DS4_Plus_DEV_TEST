<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<script>
//add - 변수 추가
var getYear="";
var getMonth="";
var getMonthTmp="";
var getDate="";
var getFuneralNo="";
var getOS="";

	$(function() {		

			var param = JSON.parse('${data}');
			
			//console.log(param);
			
			var searchObj = $.extend({}, param);
			searchObj.currentPage = (param.pk ? param.pk:1);
			searchObj.queryPage = (param.pk ? (param.pk-1)*(param.display ? param.display:20):0);
			searchObj.display = (param.display ? param.display:20);			
			searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';	
			
			getFuneralNo=searchObj.funeralNo;
			
			//date set
			var tmpStdDt = new Date(new Date().getFullYear(), new Date().getMonth(), 1); 
			var stdDt = $.pb.createDateObj(tmpStdDt);
			var edDt = $.pb.createDateObj();
			
			//date comboBox Set
			var searchBox = $('.main-contents-wrap > .contents-title-wrap > .search-box');
			searchBox.find('select[name=sYear]').sysDate('year', { begin:stdDt.year-2, unit:'년', selected:stdDt.year } );
			searchBox.find('select[name=sMonth]').sysDate('month', { unit:'월', selected:stdDt._month } );
			searchBox.find('select[name=sDay]').sysDate('day', { unit:'일', selected:stdDt._day } );
			
			searchBox.find('select[name=eYear]').sysDate('year', { begin:stdDt.year-2, unit:'년', selected:stdDt.year } );
			searchBox.find('select[name=eMonth]').sysDate('month', { unit:'월', selected:edDt._month } );
			searchBox.find('select[name=eDay]').sysDate('day', { unit:'일', selected:edDt._day } );
			
			
			
			
			// 호출 및 함수 추가
			var fNo=getFuneralNo;
			getCreateDate(fNo);
			
			
			
			//display
			displayFlowerSales(searchObj);
	});
	
	
	
	//GET Create Date
	function getCreateDate(fNo){
						
		var funeralNoObj={
				funeralNo : fNo
		};				
						
		$.pb.ajaxCallHandler('/adminSec/selectFlowerFuneralCreateDt.do', funeralNoObj, function(data){
			
			
			var _dateParam = JSON.stringify(data);
			var _dateParamObj = JSON.parse(_dateParam);			
			console.log( _dateParam);
			
			var searchDate=(_dateParamObj.list[0].CREATE_DT);
			//console.log("searchDate" + searchDate);
			var dateAry= typeof searchDate==='string' ? searchDate.split('-') : '';
			//console.log(dateAry[0]);
			getYear=dateAry[0];
			if(typeof getYear=="undefined" || getYear == "" || getYear==null){
				getYear = _dateParamObj.list[0].CREATE_DT.year;
				getMonth= _dateParamObj.list[0].CREATE_DT.monthValue; 
			}else{
				getMonth=dateAry[1];
			}
			
		});				
	};
		
	//search button click Event
	$('#btnSearch').on('click', function() {
		
		//변수 추가
		var selDate="";				
		//추가				
		getDate = parseInt(getYear + "" + getMonth);
						
		//date validation
		var stDt = new Date($('select[name=sYear]').val()+'-'+$('select[name=sMonth]').val()+'-'+$('select[name=sDay]').val());
		console.log("stDt : " + stDt);
		var endDt = new Date($('select[name=eYear]').val()+'-'+$('select[name=eMonth]').val()+'-'+$('select[name=eDay]').val());
		console.log("endDt : " + endDt);			
		var tDiff = endDt.getTime() - stDt.getTime();
		console.log("var tDiff : " + tDiff);
		tDiff = Math.floor(tDiff/(1000 * 60 * 60 * 24));
		console.log("tDiff : " + tDiff);
		
		//추가
		selDate=parseInt($('select[name=sYear]').val()+''+$('select[name=sMonth]').val());
		
				
		if(tDiff < 0) {
			alert('조회일자 시작일이 종료일보다 클 수 없습니다.');
			return;
		}else if(getDate > selDate){	//추가
			alert("제휴일자("+getYear+"년 "+getMonth+"월) 이전 데이터는 조회할 수 없습니다.");
			
		
			var searchBox = $('.main-contents-wrap > .contents-title-wrap > .search-box');
			searchBox.find('select[name=sYear]').sysDate('year', { begin:getYear, unit:'년', selected:getYear } );
			searchBox.find('select[name=sMonth]').sysDate('month', { unit:'월', selected:getMonth } );			
			
			return;
			
		}
		else{
							
			//param
			var param = JSON.parse('${data}');
			
			var searchObj = $.extend({}, param);
			searchObj.currentPage = (param.pk ? param.pk:1);
			searchObj.queryPage = (param.pk ? (param.pk-1)*(param.display ? param.display:20):0);
			searchObj.display = (param.display ? param.display:20);			
			searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';			
			
			//display
			displayFlowerSales(searchObj);
		}			
	});	
	
	//display Method
	function displayFlowerSales(searchObj) {
		
		$('#detailFlowerSales').find('tbody').html('');
		
		$('#totCnt').text(" 0 개");		//주문 수량
		$('#totSales').text("0 원");		//매출액			
		$('#totSaving').text("0 원");	//지원금
		
						
		//param
		var param = new Object();
		param.strFuneralNo = searchObj.funeralNo;
		param.stDt = $('select[name=sYear]').val()+$('select[name=sMonth]').val()+$('select[name=sDay]').val();
		param.edDt = $('select[name=eYear]').val()+$('select[name=eMonth]').val()+$('select[name=eDay]').val();
		param.itemName = $('.productText').val();
				
		if(param.stDt < '20210901' || param.edDt < '20210901'){
			alert("화환매출은 2021년 09월부터 데이터를 제공하고 있습니다.");
			return;
		};
		
		//api
		$.ajax({
			url : 'https://choomo.app/api/ds/savings', //운영
			//url : 'http://211.251.238.235:9090/api/ds/savings', //개발
			
			type : 'get',
			//async: false,
			data : {funeralNo : param.strFuneralNo,
					startDate : param.stDt,
					endDate : param.edDt,
					produectNm : param.produectNm,
					itemName : param.itemName
			},
			dataType:'json',
			success: function(data) {						
				
				if(data.code == "0000"){	
					searchObj.total = data.value.LIST.length;	//data에 따른 paging 번호 set
					if(data.value.LIST.length ==0 ){
						alert("데이터가 존재하지 않습니다.");
						return;
					};
					
					//총 매출 현황 value display
					$('#totCnt').text(data.value.TOTAL_COUNT + " 개");		//주문 수량
					$('#totSales').text(addComma(data.value.TOTAL_PRICE) + " 원");		//매출액			
					$('#totSaving').text(addComma(data.value.TOTAL_SAVING) + " 원");	//지원금			
					 					
					//console.log(data.value.LIST);
					//console.log(data.value.LIST[0]);
					//console.log(data.value.LIST[0].ITEM_NAME);	
					//console.log(data.value.LIST.length); */
					
					var stCnt = searchObj.queryPage;
					var edCnt = searchObj.queryPage+20;
															
 					for(var i=stCnt; i<edCnt; i++){
 						
 						if(data.value.LIST[i] != null){ 							 					
 						
							var dRow = "";
																				
							dRow += '<tr>';
							dRow += '<td align="center">'+(i+1)+'</td>';		//순서
							dRow += '<td align="center">'+data.value.LIST[i].ORDER_DT+'</td>';		//주문일자
							dRow += '<td align="center">'+data.value.LIST[i].ITEM_NAME+'</td>';		//상품명						
							dRow += '<td align="center">'+data.value.LIST[i].SALE_PRICE.toLocaleString()+'</td>';		//결제금액
							dRow += '<td align="center">'+addComma(data.value.LIST[i].SAVING_PRICE)+'</td>';	//지원금 
							dRow += '</tr>';
								
							$('#detailFlowerSales').append(dRow);
 						}
					} 
					
					//paging
 					$('.contents-body-wrap > .paging').createPaging(searchObj, function(page) { 						

 						var pageObj =  searchObj;
 			        	pageObj.pk = page;
 			        	pageObj.currentPage = page;
 			        	pageObj.queryPage = (page-1)*(searchObj.display*1); 
 			        	
 						var _urlSplit = $(location)[0].pathname.split('/');
 						history.pushState({ paging:pageObj }, '', '/'+_urlSplit[1]+'/'+pageObj.currentPage);
 						displayFlowerSales(pageObj);
 			        });
					
				}else{
					alert("데이터가 존재하지 않습니다.");
				}						
			}
		});
	};	
	
	//숫자 value 콤마 정규식
	function addComma(num) {
		  var regexp = /\B(?=(\d{3})+(?!\d))/g;
		  return num.toString().replace(regexp, ',');
	}	
	
</script>
	
<style>
	.search-box { display:flex; align-items:center; }
	#btnSearch { margin-left:20px; margin-right:20px;}
	#shroudlist th{position:sticky; top:0px;}
	
	@media ( max-width: 700px ) {	
		.main-contents-wrap > .contents-title-wrap > .search-box > .search-select { width:120px; margin-left:0px;padding-left:0px;}
		.main-contents-wrap > .search-box-wrap { margin-top:180px; }
		.main-contents-wrap > .contents-title-wrap > .search-box > .search-text-wrap > .search-text { width:70%; }
		.main-contents-wrap > .contents-title-wrap > .search-box > .search-text-wrap > .search-text-btn { width:28%; }		
	}
		
</style>

<div class="contents-title-wrap">
	<div class="title">화환통계</div>
	<!-- 
	<div class="sub-title"><br>※조회일자에 해당하는 염습자 목록을 조회하고 엑셀파일로 다운로드 할 수 있습니다.</div>
	 -->
	<div class="search-box">조회 일자 : &nbsp;
		<select class="search-select year" name="sYear"></select>
		<select class="search-select month" name="sMonth"></select>
		<select class="search-select day" name="sDay"></select>
		<span class="text"> &nbsp;&nbsp;&nbsp;&nbsp;~ </span>
		<select class="search-select year" name="eYear"></select>
		<select class="search-select month" name="eMonth"></select>
		<select class="search-select day" name="eDay"></select>
		
		<div class="search-text-wrap">		
			<button type="button" class="search-text-btn" id="btnSearch">조 회</button>		
		</div>			
	</div>
	
	<div class="search-box" >상&nbsp;&nbsp;품&nbsp;&nbsp;명 : &nbsp;
		<input type="text" class="productText" style="height:48px; width:440px;" placeholder="상품명을 입력해주세요"/>
	</div>
		
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">총 매출 현황</div>
	</div>
</div>

<div class="contents-body-wrap">
	<table class="pb-table list" style="width:50%;" id=totalFlowerSales>
		<colgroup></colgroup>
		<thead>
			<tr>
				<th style="width:150px;">주 문 수 량</th>
				<th style="width:300px;">매 출 액 (원)</th>
				<th style="width:300px;">지 원 금 (원)</th>
			</tr>
		</thead>
		<tbody>			
			<tr id = "totRow" align="center">
				<td id=totCnt>0 개</td>
				<td id=totSales>0 원</td>
				<td id=totSaving>0 원</td> <!-- 지원금 -->
			</tr>					
		</tbody>
	</table>	
</div>

<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">세부 내역</div>
	</div>
</div>

<div class="contents-body-wrap">
	<table class="pb-table list" style="width:80%;" id=detailFlowerSales>
		<colgroup></colgroup>
		<thead>
			<tr>
				<th style="width:100px;">번 호</th>
				<th style="width:450px;">주 문 일 시</th>
				<th style="width:350px;">상 품 명</th>
				<th style="width:500px;">결 제 금 액 (원)</th>				
				<th style="width:500px;">지 원 금 (원) </th> 
			</tr>
		</thead>
		
		<tbody>					
		</tbody>
	</table>	
	<div class="paging"></div>
</div>








