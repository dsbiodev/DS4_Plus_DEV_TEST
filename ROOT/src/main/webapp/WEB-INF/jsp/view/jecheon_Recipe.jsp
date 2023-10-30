<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	$(function() {
		if(!'${sessionScope.loginProcess}') $(location).attr('href', '/');
		
		var _param = JSON.parse('${data}');
		
		var searchObj = $.extend({}, _param);
		
		var _arr = location.pathname.split('/');
		
		searchObj.eventNo = _arr[_arr.length-1];	
		
		//console.log("이벤트번호:" +searchObj);
		//searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';	
						
 		$('.ajax-loading').remove();
 		 	
 		displayRcp(searchObj);	
 		
	});
	
	function displayRcp(searchObj){
			
		$('#topTbl').find('#rcpTopTbody').empty();
		$('#bottomTbl').find('#rcpBtmTbody').empty();				
		
		_totVal = "";
		_disVal = "";
		
		$.pb.ajaxCallHandler('/admin/selectEventDetail.do', searchObj, function(dtInfo) {	
		
			$.pb.ajaxCallHandler('/admin/selectSumSettlementTable.do', searchObj, function(dtCal) {
				
				if(dtCal.list.length >0){
					
					//console.log(dtInfo);
					//console.log(dtInfo.eventInfo[0].CARRYING_DT);
					
					var carryingDt =  new Date(dtInfo.eventInfo[0].CARRYING_DT).format('yyyy년 MM월 dd일');
					
					$('#topTdDate').text(carryingDt);
					$('#topTdName').text( "故 " + dtInfo.eventInfo[0].DM_NAME);
					$('#btmTdDate').text(carryingDt);
					$('#btmTdName').text( "故 " + dtInfo.eventInfo[0].DM_NAME);
					
					rcpRow = [];			
					rcpRow = makeList(dtInfo,dtCal);
					
					//공급대가총액
					$('#topSumPrice').text(addComma(_totVal-_disVal) + " 원");
					$('#btmSumPrice').text(addComma(_totVal) + " 원");
										
					for(var i=0; i< rcpRow.length; i++){											    												
						$('#topTbl').find('#rcpTopTbody').append(rcpRow[i]);
						$('#bottomTbl').find('#rcpBtmTbody').append(rcpRow[i]);												
					}						
										
				}						
			});
			
			//print
			IEPageSetupX.header = "";
			IEPageSetupX.footer = "";		
			IEPageSetupX.ShrinkToFit = true;
			IEPageSetupX.PrintBackground = false;
			IEPageSetupX.leftMargin = "";
			IEPageSetupX.rightMargin = "";
			IEPageSetupX.Preview();
			window.close();	
		});	

	};
	
	function makeList(dtInfo,dtCal){
		
		//make row
		rcpList = new Array(['수의', 0], 
							['관', 0],
							['염습품목', 0],
							['기타', 0],
							['예식실', 0],
							['빈소', 0],
							['염습실', 0],
							['식대', 0],
							['할인금액', 0],								
							['합계', 0]);
		
		for(var i=0; i< dtCal.list.length; i++){
			
			var strTyp = dtCal.list[i].typ;						
			 switch (strTyp){
			    case '수의' :    
			    	rcpList[0][1] = dtCal.list[i].usageFee;
			      break;  
			    case '관' :
			    	rcpList[1][1] = dtCal.list[i].usageFee;
			      break;  
			    case '염습품목' :
			    	rcpList[2][1] = dtCal.list[i].usageFee;
			      break;  
			    case '기타' :
			    	rcpList[3][1] = dtCal.list[i].usageFee;
			      break;  
			    case '예식실' :
			    	rcpList[4][1] = dtCal.list[i].usageFee;
			      break;  
			    case '빈소' :
			    	rcpList[5][1] = dtCal.list[i].usageFee;
			      break;  
			    case '염습실' :
			    	rcpList[6][1] = dtCal.list[i].usageFee;
			      break;  
			    case '식대' :
			    	rcpList[7][1] = dtCal.list[i].usageFee;
			      break;
			    case '총할인액' :
			    	rcpList[8][1] = dtCal.list[i].usageFee;
			      break;  					    
			  }				 				
		}
		
		//sum val
		var totSum = (rcpList[0][1] +						
					rcpList[1][1] +
					rcpList[2][1] +
					rcpList[3][1] +
					rcpList[4][1] +
				 	rcpList[5][1] +
				 	rcpList[6][1] +
				 	rcpList[7][1]) 
				 	//- rcpList[8][1]		
		rcpList[9][1] = totSum;
		
		//전역합계
		_disVal = rcpList[8][1];
		_totVal = totSum;
		
		RowList = [];
		var carryingDt =  new Date(dtInfo.eventInfo[0].CARRYING_DT).format('MM월dd일');
		
		for(var i=0; i<rcpList.length-2; i++){					
			
			var dRow = "";					
			
			dRow += '<tr>';																														
			dRow += '<td align="center">'+carryingDt+'</td>';						//발인일		
			dRow += '<td colspan = "3"; align="center">'+rcpList[i][0]+'</td>';			//품목							
			dRow += '<td colspan = "2"; align="right" style="padding-right:10px">'+addComma(rcpList[i][1])+'</td>';	//공급가액
			dRow += '<td align="center">'+" "+'</td>';	//비고			
			dRow += '</tr>';
			
			RowList.push(dRow);							
		}
		
		//disprice
		var dRow = "";
		
		dRow += '<tr>';
		dRow += '<td colspan = "4"; align="center">'+"합 계"+'</td>';				
		dRow += '<td colspan = "2"; align="right" style="padding-right:10px">'+addComma(rcpList[9][1])+" 원"+'</td>';	//합계
		dRow += '<td align="center">'+""+'</td>';	//비고				
		dRow += '</tr>';
		
		RowList.push(dRow);		

		//totsum
		dRow = "";
		
		dRow += '<tr>';																														
		dRow += '<td colspan = "4"; align="center">'+"할인금액"+'</td>';			
		dRow += '<td colspan = "2"; align="right" style="padding-right:10px">'+addComma(rcpList[8][1])+" 원"+'</td>';	//할인금액
		dRow += '<td align="center">'+""+'</td>';	//비고		
		dRow += '</tr>';
		
		RowList.push(dRow);					
		
		return RowList;
	};			
	
	//숫자 value 콤마 정규식
	function addComma(num) {
		  var regexp = /\B(?=(\d{3})+(?!\d))/g;
		  return num.toString().replace(regexp, ',');
	};	
		

</script>
<style>
 	@page { size:auto; margin:50px 0px 20px 0%; } 
	.main-left-wrap { display:none; }
	.main-contents-wrap { padding-left:0px !important; background:#FFF; }
	
 	.page { display: inline-block; width:60%; padding: 0px 35px; background: #fff; font-size: 22px; } 
 	.print-title { width:1250px; text-align:center; font-size:30px; letter-spacing:15px; margin-bottom:20px; font-weight:bold; } 

	.info-box { width:1250px; position:relative; }
	.info-box .mourner-box { position:absolute; top:0; right:0px; }
	.info-box .mourner-box .mourner{ margin-left:150px; }
	.info-box .total-box { position:absolute; top:0; right:0px; }
	
	.funeralhall-box { margin-bottom:18px; }
	
 	.main-index { width:1250px; text-align:right; font-size:25px; position:absolute; }
 	.index { margin:120px 0px 10px 0px; width:1250px; font-size:25px; text-align:right; }
 	
 	.print-table { width:1250px; border: 1px solid #000; text-align:center; font-size:20px; position:relative; z-index:1000; text-align:center; border-collapse:collapse; } 
	.print-table tbody tr th { border: 1px solid #000; height:53px; position:relative; } 
	.print-table tbody tr td { border: 1px solid #000; height:38px; position:relative; font-size:25px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }  
 	.print-table tbody tr .l { text-align: left; } 
 	.print-table tbody tr .r { text-align: right; padding-right: 10px; } 
  	.page-wrap { height: 100vh; box-sizing: border-box; }
  	
  	    
</style>
<object id="IEPageSetupX" classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/resources/js/IEPageSetupX.cab#version=1,4,0,3" width=0 height=0></object> 
<div class="page" id="page">
	<div class="page-wrap">
		<table class="print-table print-table0" id = "topTbl">
		    <tr align ="center">
				<!-- <p><td height="300" colspan = "7">영 수 증 (공급받는자용)</td></p> -->
				<td colspan="7">
					<div style="height:70px; display: table-cell; vertical-align: middle; font-weight:bold; ">영 수 증 (공급받는자용)</div>
				</td>
		    </tr>
		    
		    <tr align = "center" >
				<td colspan = "2" id = "topTdDate">날짜</td>
				<td rowspan = "4">공급자</td>
				<td>사업자등록번호</td>
				<td colspan = "3">304-85-05715</td>			
		    </tr>
		    
		    <tr align = "center" >
				<td id = "topTdName" >故 고인명</td>
				<td>귀하</td>	
				<td>상  호</td>
				<td>(주)제서 제천점</td>
				<td>성명</td>
				<td>김 인 식 (인)</td>		
		    </tr>
		    
		    <tr align = "center">
				<td colspan ="2" rowspan = "2">아래와 같이 영수합니다.</td>	
				<td>소 재 지</td>
				<td colspan = "3">충북 제천시 서부동 176번지</td>	
		    </tr>
		    
		    <tr align = "center">	    
				<td>업   태</td>
				<td>서비스 소매·도매</td>
				<td>종목</td>
				<td>장례식장 운영업</td>	
		    </tr>
		    
		    <tr align = "center">
				<td colspan = "2" >공급대가총액</td>
				<td colspan = "5" id = "topSumPrice">금액</td>	
		    </tr>
		    
		    <tr align = "center">
				<td>일자</td>
				<td colspan= "3">품 목</td>
				<td colspan = "2">공급가액</td>
				<td>비고</td>			
		    </tr>
		    
			<tbody id = "rcpTopTbody"></tbody>
		    
		</table>
		
	<br />	
	<hr style="width:1250px; margin: auto; border-top:1px dashed black;" />
	<!-- <hr align="center;" style=" border-top:1px dashed black; height:0.5px;" > -->
	<br />
	
	<table class="print-table print-table0" id = "bottomTbl">
		    <tr align ="center">
				<!-- <p><td colspan = "7">영 수 증 (공급자용)</td></p> -->
				<td colspan="7">
					<div style="height:70px; display: table-cell; vertical-align: middle; font-weight:bold; ">영 수 증 (공급자용)</div>
				</td>
		    </tr>
		    
		    <tr align = "center">
				<td colspan = "2" id = "btmTdDate">날짜</td>
				<td rowspan = "4">공급자</td>
				<td>사업자등록번호</td>
				<td colspan = "3">304-85-05715</td>			
		    </tr>
		    
		    <tr align = "center">
				<td  id = "btmTdName">故 고인명</td>
				<td>귀하</td>	
				<td>상  호</td>
				<td>(주)제서 제천점</td>
				<td>성명</td>
				<td>김 인 식 (인)</td>		
		    </tr>
		    
		    <tr align = "center">
				<td colspan ="2" rowspan = "2">아래와 같이 영수합니다.</td>	
				<td>소 재 지</td>
				<td colspan = "3">충북 제천시 서부동 176번지</td>	
		    </tr>
		    
		    <tr align = "center">	    
				<td>업   태</td>
				<td>서비스 소매·도매</td>
				<td>종목</td>
				<td>장례식장 운영업</td>	
		    </tr>
		    
		    <tr align = "center">
				<td colspan = "2">공급대가총액</td>
				<td colspan = "5" id = "btmSumPrice">금액</td>	
		    </tr>
		    
		    <tr align = "center">
				<td>일자</td>
				<td colspan= "3">품 목</td>
				<td colspan = "2">공급가액</td>
				<td>비고</td>			
		    </tr>
		    
			<tbody id = "rcpBtmTbody"></tbody>		    
		</table>				

	</div>	
	
	
</div>

