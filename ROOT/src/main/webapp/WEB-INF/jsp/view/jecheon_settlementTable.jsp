<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<script>

	$(function() {
		_finalList = [];
		
		//setting
		setDate();
	
		var searchObj = makeParam();						
									
		displayList(searchObj);
	});
	
	//조회 parameter set
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
	
	//date set
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
	
	//검색버튼 클릭 이벤트
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
	
	
	//display
	function displayList(searchObj){
		
		_finalList.length = 0;
		
		var excelTbl = $('.pb-table.excel');	
		excelTbl.find('tbody').html('');		
		
		var _table = $('.pb-table.list');
		_table.find('tbody').html('');
				
		$.pb.ajaxCallHandler('/admin/selectSettlementTable.do', searchObj, function(dtResult) {			
			
			if(dtResult.list.length > 0){
										
				
				$.pb.ajaxCallHandler('/admin/selectSumSettlementTable.do', searchObj, function(dtTot) {
					
					//make data
					var pkEventNo = [];								
					var stPk = dtResult.list[0].event_no;				
					pkEventNo.push(stPk);
					
					//event no 추출				
					for(var i=0; i<dtResult.list.length; i++){								
									
						if(dtResult.list[i] != null){ 							
							if( stPk != dtResult.list[i].event_no){
								pkEventNo.push(dtResult.list[i].event_no);
								stPk = dtResult.list[i].event_no;
							}
						}
					};				
																	
					var strNo = 1;
									
					//make cal
					for(var i=0; i<pkEventNo.length; i++){
						
						var strEventNo = pkEventNo[i];
																								
						jungsanList = new Array(['eventNo', strEventNo],
								['번호', 0],
								['고인명', strNo],
								['수의', 0], 
								['관', 0],
								['염습품목', 0],
								['기타', 0],
								['예식실', 0],
								['빈소', 0],
								['염습실', 0],
								['식대', 0],
								['할인금액', 0],								
								['수입계', 0]);																				
											
						for(var j=0; j<dtResult.list.length; j++){						
																			
							if(strEventNo == dtResult.list[j].event_no){
								
								jungsanList[1][1] = strNo;				
								jungsanList[2][1] = dtResult.list[j].dm_name;
															
								var strTyp = dtResult.list[j].typ;						
								 switch (strTyp){
								    case '수의' :    
								    	jungsanList[3][1] = dtResult.list[j].usageFee;
								      break;  
								    case '관' :
								    	jungsanList[4][1] = dtResult.list[j].usageFee;
								      break;  
								    case '염습품목' :
								    	jungsanList[5][1] = dtResult.list[j].usageFee;
								      break;  
								    case '기타' :
								    	jungsanList[6][1] = dtResult.list[j].usageFee;
								      break;  
								    case '예식실' :
								    	jungsanList[7][1] = dtResult.list[j].usageFee;
								      break;  
								    case '빈소' :
								    	jungsanList[8][1] = dtResult.list[j].usageFee;
								      break;  
								    case '염습실' :
								    	jungsanList[9][1] = dtResult.list[j].usageFee;
								      break;  
								    case '식대' :
								    	jungsanList[10][1] = dtResult.list[j].usageFee;
								      break;  					    
								  }											 
								 jungsanList[11][1] = dtResult.list[j].discount_price;
							}						
						}
						//console.log(jungsanList);
						strNo = strNo+1;
						
						//append row
						
						var dRow = "";
						
						//tot make 					
						var totSum = (jungsanList[3][1] + 
									 jungsanList[4][1] +
									 jungsanList[5][1] +
									 jungsanList[6][1] +
									 jungsanList[7][1] +
									 jungsanList[8][1] +
									 jungsanList[9][1] +
									 jungsanList[10][1]) -								 
									 jungsanList[11][1]
						
						//console.log(totSum);
						
						var dRow = "";					
						
						dRow += '<tr>';																														
						dRow += '<td align="center">'+jungsanList[1][1]+'</td>';			//No
						dRow += '<td align="center">'+jungsanList[0][1]+'</td>';			//eventNo	
						dRow += '<td align="center">'+jungsanList[2][1]+'</td>';			//고인명							
						dRow += '<td align="right">'+addComma(jungsanList[3][1])+'</td>';	//수의
						dRow += '<td align="right">'+addComma(jungsanList[4][1])+'</td>';	//관,봉안함 횡대
						dRow += '<td align="right">'+addComma(jungsanList[5][1])+'</td>';	//염습품목
						dRow += '<td align="right">'+addComma(jungsanList[6][1])+'</td>';	//기타
						dRow += '<td align="right">'+addComma(jungsanList[7][1])+'</td>';	//예식실사용료
						dRow += '<td align="right">'+addComma(jungsanList[8][1])+'</td>';	//빈소사용료
						dRow += '<td align="right">'+addComma(jungsanList[9][1])+'</td>';	//염습실사용료
						dRow += '<td align="right">'+addComma(jungsanList[10][1])+'</td>';	//식대
						dRow += '<td align="right">'+addComma(jungsanList[11][1])+'</td>';	//할인금액
						dRow += '<td align="right">'+addComma(totSum)+'</td>';	//수입계																						
						dRow += '</tr>';
							
						//$('#usageList').append(dRow);
						_finalList.push(dRow);
					};					
										
					//합계 row add
					//if(searchObj.currentPage == searchObj.lastPage){
															
						var totRow = addTotalRow(dtTot);		
						_finalList.push(totRow);						
					//}						
					
					//paging count set
					searchObj.total = _finalList.length;
					searchObj.lastPage = Math.ceil(searchObj.total / 30);
												
					var stCnt = searchObj.queryPage;				
					var edCnt = searchObj.queryPage+30;													
							
									
					//display row
					for(var i=stCnt; i<edCnt; i++){					
						
						if(_finalList[i] != null){					
							$('#usageList').append(_finalList[i]);
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
						displayList(pageObj);												
				    });																																										
				});
			
			}else{
				alert("해당 일자에 데이터가 존재하지 않습니다.")
			}	
				
		});		
		
	};
	
	//총금액 make tr row
	function addTotalRow(dt){
										
		var fee1 =0;
		var fee2 =0;
		var fee3 =0;
		var fee4 =0;
		var fee5 =0;
		var fee6 =0;
		var fee7 =0;
		var fee8 =0;
		var disFee =0;						
		var totSum = 0;
		
		for(var i=0; i<dt.list.length; i++){
						
			var strTyp = dt.list[i].typ;						
			 switch (strTyp){
			    case '수의' :    
			    	fee1 = dt.list[i].usageFee;
			      break;  
			    case '관' :
			    	fee2 = dt.list[i].usageFee;
			      break;  
			    case '염습품목' :
			    	fee3 = dt.list[i].usageFee;
			      break;  
			    case '기타' :
			    	fee4 = dt.list[i].usageFee;
			      break;  
			    case '예식실' :
			    	fee5 = dt.list[i].usageFee;
			      break;  
			    case '빈소' :
			    	fee6 = dt.list[i].usageFee;
			      break;  
			    case '염습실' :
			    	fee7 = dt.list[i].usageFee;
			      break;  
			    case '식대' :
			    	fee8 = dt.list[i].usageFee;
			      break;  			
			    case '총할인액' :
			    	disFee = dt.list[i].usageFee;
			      break;  				      
			  }											 			
		}
		
		totSum += (fee1+fee2+fee3+fee4+fee5+fee6+fee7+fee8)-disFee;
		
		//add row
		var dRow = "";					
				
		dRow += '<tr>';																														
		dRow += '<td align="center" style="background:lightgray; font:bold;">'+""+'</td>';				//No
		dRow += '<td align="center">'+""+'</td>';				//eventNo column	
		dRow += '<td align="center" style="background:lightgray; font-weight:bold; font-style:italic;">'+"소 계"+'</td>';			//고인명							
		dRow += '<td align="right" style="background:lightgray; font-weight:bold; font-style:italic;">'+addComma(fee1)+'</td>';	//수의
		dRow += '<td align="right" style="background:lightgray; font-weight:bold; font-style:italic;">'+addComma(fee2)+'</td>';	//관,봉안함 횡대
		dRow += '<td align="right" style="background:lightgray; font-weight:bold; font-style:italic;">'+addComma(fee3)+'</td>';	//염습품목
		dRow += '<td align="right" style="background:lightgray; font-weight:bold; font-style:italic;">'+addComma(fee4)+'</td>';	//기타
		dRow += '<td align="right" style="background:lightgray; font-weight:bold; font-style:italic;">'+addComma(fee5)+'</td>';	//예식실사용료
		dRow += '<td align="right" style="background:lightgray; font-weight:bold; font-style:italic;">'+addComma(fee6)+'</td>';	//빈소사용료
		dRow += '<td align="right" style="background:lightgray; font-weight:bold; font-style:italic;">'+addComma(fee7)+'</td>';	//염습실사용료
		dRow += '<td align="right" style="background:lightgray; font-weight:bold; font-style:italic;">'+addComma(fee8)+'</td>';	//식대
		dRow += '<td align="right" style="background:lightgray; font-weight:bold; font-style:italic;">'+addComma(disFee)+'</td>';	//할인금액
		dRow += '<td align="right" style="background:lightgray; font-weight:bold; font-style:italic;">'+addComma(totSum)+'</td>';	//수입계																						
		dRow += '</tr>';
		
		return dRow;
	};


	//숫자 value 콤마 정규식
	function addComma(num) {
		  var regexp = /\B(?=(\d{3})+(?!\d))/g;
		  return num.toString().replace(regexp, ',');
	};	
	
	
	//excel download
	$('.btn-excel').on('click', function(){
						
		//display row
		for(var i=0; i<_finalList.length; i++){
										
			$('#excelTbl').append(_finalList[i]);				
		}			
		
		fnExcelReport('excelTbl', '정산표');
	});	
		
	//row click 
	$('#usageList').on('click', function(e){
		
		//var rIndex = e.target.closest("tr").rowIndex;
		var rIndex = e.target.parentNode.rowIndex;
		
		
		// 현재 클릭된 Row(<tr>)
		var tbl = $(this);
		var tr = tbl.children().children();
		var td = tr.eq(rIndex).find('td');
		var strPk = td.eq(1).text();
		console.log("피케이:"+strPk);
		
		if(strPk == null || strPk == ""){
			return;
		}
		
		window.open('/290907/'+strPk, "printName", "width=1400px, height=800, scrolbars=yes");
	});	
	
	
</script>
<style>	
	.pb-table.list td { padding: 6px 6px; font-size: 12px;}
	
	#usageList th:nth-of-type(2){display:none;}
	#usageList td:nth-of-type(2){display:none;}
	
	#excelTbl th:nth-of-type(2){display:none;}
	#excelTbl td:nth-of-type(2){display:none;}
	
</style>
<div class="contents-title-wrap">
	<div class="title">정 산 표</div>
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
	<table class="pb-table list" style="width:90%; margin:auto;" id="usageList">
		<colgroup></colgroup>
		<thead>
			<tr>
				<th style="width:80px;">No.</th>
				<th style="width:80px;">고유번호</th>
				<th style="width:150px;">고인명</th>
				<th style="width:200px;">수의</th>
				<th style="width:200px;">관,봉안함,횡대</th>
				<th style="width:200px;">염습품목</th>
				<th style="width:200px;">기타</th>
				<th style="width:200px;">예식실사용료</th>
				<th style="width:200px;">빈소사용료</th>
				<th style="width:200px;">염습실사용료</th>
				<th style="width:200px;">식대</th>
				<th style="width:200px;">할인금액</th>
				<th style="width:200px;">수입계</th>								
			</tr>
		</thead>
		
		<tbody>					
		</tbody>
	</table>	
	<div class="paging"></div>
</div>
<div class="contents-body-wrap">
	<table class="pb-table excel" style="width:80%;visibility: hidden; " id="excelTbl">
		<colgroup></colgroup>
		<thead>
			<tr>
				<th style="width:80px;">No.</th>
				<th style="width:80px;">고유번호</th>
				<th style="width:150px;">고인명</th>
				<th style="width:200px;">수의</th>
				<th style="width:200px;">관,봉안함,횡대</th>
				<th style="width:200px;">염습품목</th>
				<th style="width:200px;">기타</th>
				<th style="width:200px;">예식실사용료</th>
				<th style="width:200px;">빈소사용료</th>
				<th style="width:200px;">염습실사용료</th>
				<th style="width:200px;">식대</th>
				<th style="width:200px;">할인금액</th>
				<th style="width:200px;">수입계</th>										
			</tr>
		</thead>
		
		<tbody>					
		</tbody>
	</table>	
	
</div>