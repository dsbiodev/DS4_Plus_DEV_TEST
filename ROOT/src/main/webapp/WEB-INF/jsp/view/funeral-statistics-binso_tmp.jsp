<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		//total value로 전체 현황 및 총합에 사용
		//var _arrTotVal;
		
		var _param = JSON.parse('${data}');
		
		$('input[type=radio][name=btnRdoFlag]').siteRadio({ addText:['합계', '사용률'], fontSize:'16px', matchParent:false });
		$('input[type=radio][name=btnRdoFlag][value=sum]').click();
		
		$('.select-from-year').createYear({begin:2018});
		$('.select-to-year').createYear({begin:2018});
		$('.select-from-month').createMonth();
		$('.select-to-month').createMonth();
		
		$('.select-from-year').val(new Date((Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24)).getFullYear());
		$('.select-from-month').val(new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1 < 10 ? "0"+(new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1) : new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1);
		$('.select-to-month').val(new Date().getMonth()+1 < 10 ? "0"+(new Date().getMonth()+1) : new Date().getMonth()+1);
						
		//$('.select-from-month').val(new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1 < 10 ? "0"+(new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+2) : new Date(Date.parse(new Date()) -30 * 1000 * 60 * 60 * 24).getMonth()+1);	
		//$('.select-to-month').val(new Date().getMonth()+1 < 10 ? "0"+(new Date().getMonth()+1) : new Date().getMonth()+1);

		var searchObj = _param;
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
		searchObj.calFrom = $('.select-from-year').val() +"-"+ $('.select-from-month').val();
		searchObj.calTo = $('.select-to-year').val() +"-"+ $('.select-to-month').val();
		searchObj.order = 'APPELLATION ASC';
		searchObj.searchTyp = $('input:radio[name="btnRdoFlag"]:checked').val();
		
		var _table = $('.pb-table.list');
		

		//테이블 grid method
		var displaySum = function(_searchObj) {			
			
			$.pb.ajaxCallHandler('/adminSec/selectStatisticsBinsoList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				
				if(tableData.list.length > 0){
					var _sDate = new Date(_searchObj.calFrom);
					var _eDate = new Date(_searchObj.calTo);
					var tempDt = new Date(_sDate.getFullYear(), _sDate.getMonth(), _sDate.getDate());
					var _tmpObj = { dateCol:[] };
					var dtCount = 1;
					
					//기준 월 날짜값 구하기
					while(tempDt.getTime() <= _eDate.getTime()) {							
						var _nowDate = new Date(tempDt.getFullYear(), tempDt.getMonth(), tempDt.getDate()).format('yyyy-MM')
						_tmpObj.dateCol.push(_nowDate);
						tempDt = new Date(_sDate.getFullYear(), _sDate.getMonth()+dtCount, _sDate.getDate());
						dtCount++;
					};
															
					//기준 월 총계 리스트 get			
					var dicTot = {};
					var dicSangjo = {};
															
					for(var i=0; i<_tmpObj.dateCol.length;i++){
						
						var standardDt = _tmpObj.dateCol[i];
																	
						for(var j=0; j<tableData.list.length;j++){
							
							var rowDtVal = tableData.list[j]["DATE"]
							
							if(standardDt == rowDtVal){
								
								//console.log("total_val 1 : " + tableData.list[j]["TOTAL_VAL"]);
								dicTot[_tmpObj.dateCol[i]] = tableData.list[j]["TOTAL_VAL"];									
								dicSangjo[_tmpObj.dateCol[i]] = tableData.list[j]["SANGJO_CNT"];
								
								
							}							
						}
					};
					
															
					//컬럼 헤더 만들기
					//빈소명이 일치하면 라즈베리con No와 빈소명을 추가.														
					$.each(tableData.list, function() {
						var _ = this;
						var _overlapFlag = false;
															
						$.each(_table.find('#binsoNames > th'), function(idx, _value) {
	
							if($(_value).text() == _.APPELLATION){
								_overlapFlag = true;
							}
						});
						
						if(!_overlapFlag){
							_table.find('#binsoNames').append('<th data-connection-no="'+_.RASPBERRY_CONNECTION_NO+'">'+_.APPELLATION+'</th>');							
						}
					});						
					
					//총계 컬럼 추가
					addTotCol(_searchObj.searchTyp,_table);
					 
					//이용횟수 컬럼 병합
					$('#useCnt').attr('colspan', $('#binsoNames > th').length);
					
					var myData=$('#binsoNames > th').length;	
					
					var trCnt=0;
						
					$.each(_tmpObj.dateCol, function(idx, _value) {
						var _tr = $('<tr>');

						_tr.append('<td class="c">'+_value+'</td>');
						$.each(_table.find('#binsoNames > th'), function(idx) {
							var _rcNo = $(this).data('connection-no');
							
							_tr.append('<td class="c">0</td>');
														
							$.each(tableData.list, function() {
								
								//console
								//console.log("RCN : " + this.RASPBERRY_CONNECTION_NO);
								
								if(this.RASPBERRY_CONNECTION_NO == _rcNo && _value == this.DATE){
									
									//console
									//console.log("this.CNT : " + this.CNT);
									
									_tr.find('td').last().html(this.CNT);						
								}																
							});
							
						});
						_table.find('tbody').append(_tr);
					});		
										
					//총계, 상조회 수 display		
					//월을 비교하여 해당 row에 값 입력
					var myData=$('#binsoNames > th').length;
									
					for(var i=0; i < _tmpObj.dateCol.length; i++){
						for(var j=0; j < Object.keys(dicTot).length; j++){
							
							if(_tmpObj.dateCol[i] == Object.keys(dicTot)[j]){
								$('tr:eq('+(2+i)+')>td:eq('+ (myData-1)+')').html(dicTot[Object.keys(dicTot)[j]]);	
							}											
						}
						for(var j=0; j < Object.keys(dicSangjo).length; j++){
							if(_tmpObj.dateCol[i] == Object.keys(dicSangjo)[j]){
								$('tr:eq('+(2+i)+')>td:eq('+ (myData)+')').html(dicSangjo[Object.keys(dicSangjo)[j]]);	
							}						
						}					
					}
					
					//컬럼 합 구하기					
					//하단에 테이블에 Tfoot Row 추가					
					var strFoot;
					
					for(var i=0; i< myData; i++){
						strFoot += '<td class = "c">0</td>';
					}														
					$('#statisticsBinso').find('tfoot').append($('<td class = "c" >합 계</td>'+strFoot));
																	
					var curTbl = $('#statisticsBinso tr')
					var arrSum = new Array();					
							
					//합계 구하기
					//columns
					for(var i=1; i <= myData;i++){
						
						var tmpVal = 0;
						//column별 row값					
						for(var j=2; j < curTbl.length;j++){
							
							tmpVal += parseInt($('tr:eq('+j+')>td:eq('+i+')').html());						
						}
						arrSum[i] = tmpVal;
					};

					//합계 display
					for(var i=1; i < arrSum.length; i++){						
						$('#statisticsBinso').find('tfoot').find('td:eq('+i+')').html(arrSum[i]);						
					};
					
					//색상변경					
					$('#statisticsBinso').find('tfoot').css("background-color","#FAF4C0");
					
					//event 현황 display
					var evTotCnt = arrSum[myData-1];
					var evSangjoCnt = arrSum[myData];
										
					displayTotEvent(evTotCnt,evSangjoCnt);
	
										
				}else{
					alert("조건에 해당하는 데이터가 존재하지 않습니다.")
				}											
			});
		};
							
		//합계 display method
		displaySum(searchObj);
		
		//사용률 display method
		var displayPer = function(_searchObj) {			
			
			$.pb.ajaxCallHandler('/adminSec/selectStatisticsBinsoList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				
				if(tableData.list.length > 0){
					var _sDate = new Date(_searchObj.calFrom);
					var _eDate = new Date(_searchObj.calTo);
					var tempDt = new Date(_sDate.getFullYear(), _sDate.getMonth(), _sDate.getDate());
					var _tmpObj = { dateCol:[] };
					var dtCount = 1;
					
					//기준 월 날짜값 구하기
					while(tempDt.getTime() <= _eDate.getTime()) {							
						var _nowDate = new Date(tempDt.getFullYear(), tempDt.getMonth(), tempDt.getDate()).format('yyyy-MM')
						_tmpObj.dateCol.push(_nowDate);
						tempDt = new Date(_sDate.getFullYear(), _sDate.getMonth()+dtCount, _sDate.getDate());
						dtCount++;
					};
																			
					//기준 월 총계 리스트 get			
					var dicTot = {};
					var dicSangjo = {};
															
					for(var i=0; i<_tmpObj.dateCol.length;i++){
						
						var standardDt = _tmpObj.dateCol[i];
																	
						for(var j=0; j<tableData.list.length;j++){
							
							var rowDtVal = tableData.list[j]["DATE"]
							
							if(standardDt == rowDtVal){
								//console.log("total_val 2 : " + tableData.list[j]["TOTAL_VAL"]);
								dicTot[_tmpObj.dateCol[i]] = tableData.list[j]["TOTAL_VAL"];									
								dicSangjo[_tmpObj.dateCol[i]] = tableData.list[j]["SANGJO_CNT"];
							}							
						}
					};
					
					//make column header
					//빈소명이 일치하면 라즈베리con No와 빈소명을 추가.														
					$.each(tableData.list, function() {
						var _ = this;
						var _overlapFlag = false;
															
						$.each(_table.find('#binsoNames > th'), function(idx, _value) {
	
							if($(_value).text() == _.APPELLATION){
								_overlapFlag = true;
							}
						});
						
						if(!_overlapFlag){
							_table.find('#binsoNames').append('<th data-connection-no="'+_.RASPBERRY_CONNECTION_NO+'">'+_.APPELLATION+'</th>');							
						}
					});						
					
					//총계 컬럼 추가
					addTotCol(_searchObj.searchTyp,_table);
					 
					//이용횟수 컬럼 병합
					$('#useCnt').attr('colspan', $('#binsoNames > th').length);
					
					var myData=$('#binsoNames > th').length;
							
					var trCnt=0;
						
					$.each(_tmpObj.dateCol, function(idx, _value) {
						var _tr = $('<tr>');
						
						_tr.append('<td class="c">'+_value+'</td>');
						$.each(_table.find('#binsoNames > th'), function(idx) {
							var _rcNo = $(this).data('connection-no');
							
							_tr.append('<td class="c">0</td>');
														
							$.each(tableData.list, function() {
								if(this.RASPBERRY_CONNECTION_NO == _rcNo && _value == this.DATE){
									_tr.find('td').last().html(this.CNT);						
								}																
							});
							
						});
						_table.find('tbody').append(_tr);
					});		
										
					//사용률 display		
					//월을 비교하여 해당 row에 값 입력
					var myData=$('#binsoNames > th').length;
									
					for(var i=0; i<_tmpObj.dateCol.length; i++){
						for(var j=0; j<Object.keys(dicTot).length; j++){
							
							if(_tmpObj.dateCol[i] == Object.keys(dicTot)[j]){
								$('tr:eq('+(2+i)+')>td:eq('+ (myData)+')').html(dicTot[Object.keys(dicTot)[j]]);	
							}											
						}
					}
					
					//컬럼 합 구하기					
					//하단에 테이블에 Tfoot Row 추가					
					var strFoot;
					
					for(var i=0; i<myData;i++){
						strFoot += '<td class = "c">0</td>';
					}														
					$('#statisticsBinso').find('tfoot').append($('<td class = "c" >합 계</td>'+strFoot));
																	
					var curTbl = $('#statisticsBinso tr')
					var arrSum = new Array();					
							
					//합계 구하기
					//columns
					for(var i=1; i<=myData;i++){
						
						var tmpVal = 0;
						//column별 row값					
						for(var j=2; j<curTbl.length;j++){
							
							tmpVal += parseInt($('tr:eq('+j+')>td:eq('+i+')').html());						
						}
						arrSum[i] = tmpVal;
					};
					
					//합계률 display
					for(var i=1; i<arrSum.length; i++){						
						$('#statisticsBinso').find('tfoot').find('td:eq('+i+')').html(arrSum[i]);						
					};
					
					//색상변경					
					$('#statisticsBinso').find('tfoot').css("background-color","#FAF4C0");
					
					//percent value change tbody
					for(var i=2; i< curTbl.length;i++){
						
						var rTot = parseInt($('tr:eq('+i+')>td:eq('+myData+')').html());
						
						for(var j=1;j<myData;j++){
							var cellVal = parseInt($('tr:eq('+i+')>td:eq('+j+')').html());
							
							if(cellVal == 0){
								$('tr:eq('+i+')>td:eq('+j+')').html('0%');
								
							}else{
								var tmpPer = Math.round((cellVal/rTot * 100),0) + '%';
								$('tr:eq('+i+')>td:eq('+j+')').html(tmpPer);
							}														
						}
						
						//총 사용률
						if(rTot == 0){							
							$('tr:eq('+i+')>td:eq('+myData+')').html('0%');	
						}else{							
							$('tr:eq('+i+')>td:eq('+myData+')').html('100%');
							}
						
					};
					
					//합계률 cell percent change								
					var ftot = 	$('#statisticsBinso').find('tfoot').find('td:eq('+(arrSum.length-1)+')').html();		
					
					for(var i=1; i<arrSum.length; i++){
						
						var cellVal = parseInt($('#statisticsBinso').find('tfoot').find('td:eq('+i+')').html());
						
						if(cellVal == 0){
							$('#statisticsBinso').find('tfoot').find('td:eq('+i+')').html('0%');							
							
						}else{
							var tmpPer = Math.round((cellVal/ftot * 100),0) + '%';
							$('#statisticsBinso').find('tfoot').find('td:eq('+i+')').html(tmpPer);	
						}																	
					};
					
					//event 현황 display									
					var evTotCnt = 0;		//전체 총 합
					var evSangjoCnt = 0;	//상조 총 합
										
					for(key in dicSangjo){
						evSangjoCnt += dicSangjo[key];						
					};
					
					for(key in dicTot){
						evTotCnt += dicTot[key];					
					};
										
						
					displayTotEvent(evTotCnt,evSangjoCnt);					
						
				}else{
					alert("조건에 해당하는 데이터가 존재하지 않습니다.")
				}											
			});
		};		
	
		//날짜로 검색이벤트
		$('.search-text-button.search').on('click', function(){
			
			//초기화 부분
			$('tfoot').empty();
			$('tbody').empty();
			$('#binsoNames').empty();
	
			//올바른 기간 조건이 아닐때
			if(($('.select-from-year').val() + $('.select-from-month').val()) > ($('.select-to-year').val() + $('.select-to-month').val())){
				alert("기간이 잘못됬습니다.");
				return;
			}			
							
			searchObj.calFrom = $('.select-from-year').val() +"-"+ $('.select-from-month').val();
			searchObj.calTo = $('.select-to-year').val() +"-"+ $('.select-to-month').val();
			searchObj.searchTyp = $('input:radio[name="btnRdoFlag"]:checked').val();
			
			 if(searchObj.searchTyp == 'sum'){
					displaySum(searchObj);
			}else{			 				
					displayPer(searchObj);
			}		
		});		
		
		
		//엑셀 다운로드 기능
		$('.btn-excel').on('click', function(){
			fnExcelReport('statisticsBinso', '빈소 통계');
		});
		
		//radio btn change event
		 $("input:radio[name=btnRdoFlag]").click(function(){
			 
			//초기화
			$('tfoot').empty();
			$('tbody').empty();
			$('#binsoNames').empty();			 
			 
			var param = JSON.parse('${data}');
			param.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
			param.calFrom = $('.select-from-year').val() +"-"+ $('.select-from-month').val();
			param.calTo = $('.select-to-year').val() +"-"+ $('.select-to-month').val();
			param.order = 'APPELLATION ASC';
			param.searchTyp = $('input:radio[name="btnRdoFlag"]:checked').val();
							 
			 if(param.searchTyp == 'sum'){
				displaySum(param);
			 }else{			 	
				displayPer(param);
			 }				     
		 });		
	});
	//.function
		
	function addTotCol(searchTyp,curTbl){				
		if(searchTyp == 'sum'){
			curTbl.find('#binsoNames').append('<th>' +"총 계"+'</th>');
			curTbl.find('#binsoNames').append('<th>' +"상조회 건수"+'</th>');
			 
		}else{
			curTbl.find('#binsoNames').append('<th>' +"총 사용률"+'</th>');
		}		
	};	
	
	function calPercent(tot,val){
		
		var tmpVal;
		var perVal;
				
		if(tot==0){
			perVal = "0%";
		}else{
			tmpVal = parseInt(val/tot * 100);
			
			//Add
			if(tmpVal == 100){
				perVal=tmpVal.toFixed() + "%";
			}else{
				perVal=tmpVal.toFixed(2) + "%";
			}
			
			//perVal =  Math.floor(tmpVal) + "%";
		}			
				
		var str = val + "건 / " + perVal; 
		
		return str;
	};
	
	function displayTotEvent(totCnt,sangjoCnt){
			
		var sumCnt = totCnt-sangjoCnt;				
					
		var strTotal = calPercent(totCnt,totCnt);
		var strEv = calPercent(totCnt,sumCnt);
		var strSangjo = calPercent(totCnt,sangjoCnt);
		
		$('#binsoEventDisplay').find('#displayTot').find('h2').text(strTotal);
		$('#binsoEventDisplay').find('#displaySum').find('h2').text(strEv);
		$('#binsoEventDisplay').find('#displaySangjo').find('h2').text(strSangjo);
					
	};
	
		
</script>

	<div class="contents-title-wrap">
		<div class="title">빈소 통계</div>
	</div>
	
	<div class="search-box-wrap">
	
		<div class="search-left-wrap">
		<div class="search-title">빈소 월별 통계
		</div>
	</div>
	
	<div class="search-right-wrap">
	
		<!-- 합계/사용율 라디오버튼 -->
		<div style="display:inline-block; width:350px; position:absolute; right:950px; top:7px">
			<input type="radio" name="btnRdoFlag" value="sum" checked="checked"/>
			<input type="radio" name="btnRdoFlag" value="per"/>
		</div>	
		
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

<div class="binso_totTal" id = "binsoEventDisplay">

		<div >
			<div class="binso_totCnt" id = "displayTot">			
			<p class = "binso_text"><b>전체 행사</b></p>
			<h2>
			 <b >0</b>
			</h2>		
			</div>
		</div>

		<div >
			<div class="binso_defaultCnt"  id = "displaySum">						
			<p class = "binso_text"><b>일반 행사</b></p>
			<h2>
			 <b >0</b>
			</h2>		
			</div>
		</div>
		
		<div>
			<div class = "binso_sangjoCnt" id = "displaySangjo">						
			<p class = "binso_text"><b>상조 행사</b></p>
			<h2>
			 <b >0</b>
			</h2>		
			</div>		
		</div>		
</div>

<center><h4>※빈소 통계는 <font color="red">발인 일자</font> <b>기준</b> 입니다. </h4></center>

<div class="contents-body-wrap">
	<table class="pb-table list" id="statisticsBinso">
		<colgroup></colgroup>
		<thead>
			<tr>
				<th rowspan="2">월</th>
				<th id="useCnt">이용횟수</th>
			</tr>
			<tr id="binsoNames">
			
			</tr>
		</thead>
		<tbody>
		
		</tbody>
		<tfoot>
	
		</tfoot>			
	</table>
	
	<div class="paging"></div>
</div>