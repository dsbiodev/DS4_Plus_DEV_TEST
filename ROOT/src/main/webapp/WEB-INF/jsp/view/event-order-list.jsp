<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<script type="text/javascript" src="/resources/js/html2canvas.min.js"></script>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		var _totalList = "";
		var _totalPrice = 0;
		var createTable= function() {
			$.pb.ajaxCallHandler('/adminSec/selectEventOrderList.do', {	eventNo : _param.pk, order : 'CREATE_DT DESC' }, function(data) {
				_totalList = data.totalList;
				$.each(data.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td>'+this.FLAG+'</td>');
					_tr.append('<td>'+this.ITEM_NAME+'</td>');
					_tr.append('<td>'+(this.FLAG == '주문' ? '' : '-')+this.CNT+'</td>');
					_tr.append('<td>'+this.UNIT+'</td>');
					_tr.append('<td class="r">'+$.pb.targetMoney(this.PRICE)+'</td>');
					_tr.append('<td class="r">'+$.pb.targetMoney(this.ORDER_PRICE)+'</td>');
					_tr.append('<td>'+this.CREATE_DT+'</td>');
					_tr.append('<td>'+this.ORDER_NAME+'</td>');
					$('.order-list-table').find('tbody').append(_tr);
				});

				$.each(data.totalList, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td>'+this.ITEM_NAME+'</td>');
					_tr.append('<td>'+this.CNT+'</td>');
					_tr.append('<td>'+this.UNIT+'</td>');
					_tr.append('<td class="r">'+$.pb.targetMoney(this.PRICE)+'</td>');
					_tr.append('<td class="r">'+$.pb.targetMoney(this.ORDER_PRICE)+'</td>');
					$('.order-total-table').find('tbody').append(_tr);	
				});
				
				if(data.priceList[0]){
					$('.order-price').text($.pb.targetMoney(data.priceList[0].ORDER_PRICE)+"원");
					$('.take-back-price').text($.pb.targetMoney(data.priceList[0].TAKE_BACK_PRICE)+"원");
					$('.total-price').text($.pb.targetMoney(data.priceList[0].TOTAL_PRICE)+"원");
					_totalPrice = data.priceList[0].TOTAL_PRICE;
				}
			});
		};createTable();
		

		$(document).off().on('click', '.event-info-top > .right-wrap > .btn.long.list', function() { 
			$('.btn.long.list').prop('disabled', true)
			var endCode = String.fromCharCode(29) + "V" +  String.fromCharCode(65) +  String.fromCharCode(0);
			var init = String.fromCharCode(27)+"@";
			var cutCode = String.fromCharCode(parseInt('1B', 16))  + String.fromCharCode(parseInt('69', 16))
			var input = '1B';
		    
			
			var transdata	= init;
			$.pb.ajaxCallHandler('/adminSec/selectEventFuneralInfoList.do', {	eventNo : _param.pk }, function(data) {
				var _data = data.funeralInfoList[0];		
			
				transdata += "\n"+_data.FUNERAL_NAME+"\n\n";
	 			transdata += "주소 : "+_data.ADDRESS+" "+(_data.ADDRESS_DETAIL ? _data.ADDRESS_DETAIL : "")+" \n";
	 			transdata += "사업자번호 : "+_data.BUS_NO+" \n";
	 			transdata += "대표자 : "+_data.BOSS_NAME+" \n";
	 			transdata += "전화 : "+_data.CONTACT+" \n";
	 			transdata += "\n                  * 고 객 용 *\n\n";
	 			transdata += "현재날짜: "+new Date().format('yyyy년 MM월 dd일 E hh시 mm분')+" \n";
	 			transdata += "------------------------------------------------ \n"; //48개
	 			transdata += "상품명                    단가   수량   금액(원)\n";
	 		    transdata += "------------------------------------------------ \n";

 		    	var _str = "";
	 		    $.each(_totalList, function(idx) {
	 		    	// 상품명 20칸
	 		    	var _len = 0
	 		    	for (var i = 0; i < this.ITEM_NAME.length; i++) {
 		           		if (escape(this.ITEM_NAME.charAt(i)).length == 6) _len += 2;
	 		           	else _len += 1;
	 		       	}
	 		    	
	 		    	if(_len < 19) {
		 		    	_str += this.ITEM_NAME;
	 		    		for(var i = 0; i < (20 - _len); i++) {
		 		    		_str += " ";
		 		    	}
	 		    	}else {
	 		    		//_len 길이 체크 20이상일 경우 뒤에 문자 잘라서 띄어쓰기 붙이기
	 		    		_str += this.ITEM_NAME.substr(0, 9);
		 		    	var _len2 = 0
	 		    		for (var i = 0; i < this.ITEM_NAME.substr(0, 9).length; i++) {
	 		           		if (escape(this.ITEM_NAME.substr(0, 9).charAt(i)).length == 6) _len2 += 2;
		 		           	else _len2 += 1;
		 		       	}
		 		    	for(var i = 0; i < (20 - _len2); i++) {
		 		    		_str += " ";
		 		    	}
	 		    	}
	 		    	
	 		    	//단가 10칸
	 		    	var _pLen = 0
	 		    	var _price = $.pb.targetMoney(this.PRICE);
	 		    	for (var i = 0; i < _price.length; i++) {
	 		    		_pLen += 1;
	 		       	}
	 		    	for(var i = 0; i < (10 - _pLen); i++) {
	 		    		_str += " ";
	 		    	}
	 		    	_str += _price;
	 		    	

	 		    	//수량 7칸
	 		    	for(var i = 0; i < (7 - this.CNT.toString().length); i++) {
	 		    		_str += " ";
	 		    	}
	 		    	_str += this.CNT;
	 		    	
	 		    	
	 		    	//금액 11칸
	 		    	var _tLen = 0
	 		    	var _tPrice = $.pb.targetMoney(this.ORDER_PRICE);
	 		    	for (var i = 0; i < _tPrice.length; i++) {
	 		    		_tLen += 1;
	 		       	}
	 		    	for(var i = 0; i < (11 - _tLen); i++) {
	 		    		_str += " ";
	 		    	}
	 		    	_str += _tPrice;

				});
	 		    
	 		    transdata += _str;
	 		    
	 		    transdata += "------------------------------------------------ \n";
	 			transdata += "합계금액                             "+$.pb.targetMoney(_totalPrice)+"\n";
	 		    transdata += "------------------------------------------------\n";
	 			transdata += "거 래 일 : "+new Date().format('yyyy년 MM월 dd일')+" \n\n\n";
	 			transdata += endCode;
	 			transdata += cutCode;
	 			bilgeOut(transdata);
				$('.btn.long.list').prop('disabled', false)
// 	 			$(location).attr('href', '/290101');
			});
		});
		
		function bilgeOut(transdata){
			var _payObj = $('<object>');
			_payObj.attr('classid', 'CLSID:3726C529-0F34-4971-B3F2-447C092ED5B3');
			_payObj.attr('codebase', '/resources/js/NCRSPort.CAB#version=1,0,0,0');
			_payObj.attr('id', 'UserControl1');
			_payObj.attr('onError', 'alert("ActiveX 설치가 필요합니다. ActiveX 설치 창이 뜨면 확인을 눌러주시기 바랍니다.");');
			$('#body').append(_payObj);
			document.UserControl1.DataOutPut(transdata);
			$('object').remove()
		}
		
	});
</script>
<style>
	.contents-body-wrap .event-info-box { box-sizing:border-box; position:relative; }
</style>
<!-- <object id="UserControl1" classid="CLSID:3726C529-0F34-4971-B3F2-447C092ED5B3" codebase="/resources/js/NCRSPort.CAB#version=1,0,0,0" width="0" height="0" onError="alert('ActiveX 설치가 필요합니다. ActiveX 설치 창이 뜨면 확인을 눌러주시기 바랍니다.');"></object> -->
<div class="event-info-box or" style="width:55%; padding-right:20px;">
	<div class="box-title">주문/반품 내역</div>
	<div class="table-head">
		<div style="width:5.2%;">구분</div>
		<div style="width:25%;">주문/반품 품목</div>
		<div style="width:10%;">수량</div>
		<div style="width:10%;">단위</div>
		<div style="width:10%;">단가</div>
		<div style="width:10%;">주문</div>
		<div style="width:15%;">주문일시</div>
		<div style="width:15%;">주문자</div>
	</div>
	<div class="order-list-box or" style="height:455px;">
		<table class="order-list-table">
			<colgroup>
				<col width="5%"/>
				<col width="25%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="15%"/>
				<col width="15%"/>
			</colgroup>
			<tbody></tbody>
		</table>
	</div>
	<div class="total-wrap">
		<table class="price-table">
			<tbody>
				<tr>
					<td class="b">주문금액</td>
					<td class="r order-price">0원</td>
				</tr>
				<tr>
					<td class="b">반품금액</td>
					<td class="r take-back-price">0원</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>

<div class="event-info-box or" style="width:45%; padding-left:20px;">
	<div class="box-title">총 주문내역</div>
	<div class="table-head">
		<div style="width:30%;">품목</div>
		<div style="width:15%;">수량</div>
		<div style="width:15%;">단위</div>
		<div style="width:20%;">단가</div>
		<div style="width:20%;">금액</div>
	</div>
	<div class="order-total-box" style="height:455px;">
		<table class="order-total-table">
			<colgroup>
				<col width="30%"/>
				<col width="15%"/>
				<col width="15%"/>
				<col width="20%"/>
				<col width="20%"/>
			</colgroup>
			<tbody>
			</tbody>
		</table>
	</div>
	<div class="total-wrap">
		<div class="total-text">주문 금액</div>
		<div class="total-price">0원</div>
	</div>
</div>	
