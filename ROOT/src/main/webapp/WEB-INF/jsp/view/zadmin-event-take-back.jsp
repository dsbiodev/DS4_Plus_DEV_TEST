<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');

		var _binso = "";
		$.pb.ajaxCallHandler('/adminSec/selectCMName.do', {	eventNo : _param.pk }, function(data) {
			$('input[name=orderName]').val(data.cmName.CM_NAME);
			$('.binso').text(data.cmName.APPELLATION);
			_binso = data.cmName.APPELLATION;
		});
		
		var createPartner = function() {
			$('.company-box').html("");
			$.pb.ajaxCallHandler('/adminSec/selectFuneralItemPartner.do', {	funeralNo : _param.funeralNo }, function(data) {
				$.each(data.list, function(idx) {
					var _div = $('<div class="company">'+this.NAME+'</div>');
					_div.data(this);
					_div.on('click', function(){
						$(this).addClass('ac').siblings('div').removeClass('ac');
						createClassification(_div.data('PARTNER_NO'));
					});
					$('.company-box').append(_div);
				});
				var _div_set = $('<div class="company">세트상품</div>');
				$('.company-box').append(_div_set);
				_div_set.on('click', function(){
					$(this).addClass('ac').siblings('div').removeClass('ac');
					createClassification();
				});
				
				$('.company-box').find('.company:eq(0)').addClass('ac').click();
			});
		};createPartner();
		
		
		var createClassification = function(_partnerNo) {
			$('.classification-table').find('tbody').html("");
			$('.item-list').html("");
			$.pb.ajaxCallHandler('/adminSec/selectFuneralClassificationList.do', {partnerNo : _partnerNo}, function(data) {

				var _tTr = $('<tr>');
				_tTr.append('<td>전체분류</td>');
				$('.classification-table').find('tbody').append(_tTr);
				_tTr.on('click', function(){
					$(this).addClass('ac').siblings('tr').removeClass('ac');
					createItem("", _partnerNo);
				});
				
				$.each(data.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td>'+this.NAME+'</td>');
					$('.classification-table').find('tbody').append(_tr);
					_tr.on('click', function(){
						$(this).addClass('ac').siblings('tr').removeClass('ac');
						createItem(_tr.data('CLASSIFICATION_NO'), _partnerNo);
					});
				});
				$('.classification-table').find('tbody tr:eq(0)').addClass('ac').click();
			});
		};
		

		var createItem = function(_ClassificationNo, _partnerNo) {
			$('.item-list').html("");
			if(_partnerNo){
				$.pb.ajaxCallHandler('/adminSec/selectFuneralItemList.do', {classificationNo : _ClassificationNo, partnerNo : _partnerNo, order : 'IDX, ITEM_NO DESC' }, function(data) {
					$.each(data.list, function(idx) {
						
						var _div = $('<div class="item">');
						_div.data(this);
						_div.append('<div class="name">'+this.ITEM_NAME+'</div>');
						_div.append('<div>'+this.UNIT+'</div>');
						_div.append('<div>'+$.pb.targetMoney(this.PRICE)+'원</div>');
						$('.item-list').append(_div);
						_div.on('click', function(){
							addSetItem(_div.data());
						});
					});
				});
			}else{
				$.pb.ajaxCallHandler('/adminSec/selectSetList.do', {funeralNo : _param.funeralNo, order: 'SET_NO DESC'}, function(data) {
					$.each(data.list, function(idx) {
						var _div = $('<div class="item">');
						_div.data(this);
						_div.append('<div class="name">'+this.SET_NAME+'</div>');
						_div.append('<div>1세트</div>');
						_div.append('<div>'+$.pb.targetMoney(this.PRICE)+'원</div>');
						$('.item-list').append(_div);
						_div.on('click', function(){
							$.pb.ajaxCallHandler('/adminSec/selectSetItemList.do', {setNo : _div.data('SET_NO')}, function(data) {
								$.each(data.list, function(idx) {
									addSetItem(this);
								});
							});
						});
					});
				});
			}
		};
		
		$('input[type="checkbox"][name="all"]').pbCheckbox({addText:[],fontSize:'18px'},
				{checked: function(_this){
					$('.order-table input[name=chk]').each(function(){
						if(!$(this).is(':checked')) $(this).click();
					});
				},
				unChecked: function(_this){
					$('.order-table input[name=chk]:checked').click();
				}
		});
		
		var addSetItem = function(_data) {
			var _tr = $('<tr>');
			_tr.data(_data);
			_tr.append('<td><input type="checkbox" name="chk"></td>');
			_tr.find('input[name=chk]').pbCheckbox({ addText:[], matchParent:false });
			_tr.append('<td>'+(_data.ITEM_NAME ? _data.ITEM_NAME : _data.SET_NAME)+'</td>');
			_tr.append('<td>'+(_data.UNIT ? _data.UNIT : '1세트')+'</td>');
			_tr.append('<td><input type="text" name="cnt"></td>');
			_tr.find('input[name=cnt]').plusMinusBox(
				function(){_tr.find('.total-price').text($.pb.targetMoney(_data.PRICE*_tr.find('input[name=cnt]').val())+"원");
					calTotalPrice();
					if(_tr.find('input[name=cnt]').val() == 0) _tr.remove();
				},function(){ _tr.find('.total-price').text($.pb.targetMoney(_data.PRICE*_tr.find('input[name=cnt]').val())+"원")
					calTotalPrice();
				},function(){ _tr.find('.total-price').text($.pb.targetMoney(_data.PRICE*_tr.find('input[name=cnt]').val())+"원")
					calTotalPrice();
				}
			);
			_tr.find('input').val((_data.CNT ? _data.CNT : 1));
			_tr.append('<td class="r">'+$.pb.targetMoney(_data.PRICE)+'원</td>');
			_tr.append('<td class="r total-price">'+$.pb.targetMoney(_data.PRICE)+'원</td>');

			
			var _tmp = 0;
			if($('.order-table').find('tbody tr').length == 0){
				$('.order-table').find('tbody').append(_tr);
				calTotalPrice();
			}
			else{
				$('.order-table').find('tbody tr').each(function(){
					if($(this).data('ITEM_NO') == _data.ITEM_NO && $(this).data('SET_NO') == _data.SET_NO){
						_tmp = 0;
						$(this).find('input[name=cnt]').val(parseInt($(this).find('input[name=cnt]').val()) + (_data.CNT ? _data.CNT : 1));
						$(this).find('.total-price').text($.pb.targetMoney(_data.PRICE*$(this).find('input[name=cnt]').val())+"원")
						calTotalPrice();
						return false;
					}else _tmp = 1;
				});
				if(_tmp != 0){
					$('.order-table').find('tbody').append(_tr);
					calTotalPrice();
				}
			}
		};
		
		$('.del-item').on('click', function(){
			$('.order-table').find('tbody tr').each(function(){
				if($(this).find('input[name=chk]').is(':checked'))
					$(this).remove();
			});
			calTotalPrice();
		});
		
		$('.reset').on('click', function(){
			$('.order-table').find('tbody').html("");
			$('.total-wrap .total-price').text("0원");
		});
		
		var calTotalPrice = function(){
			var _price = 0;
			if($('.order-table').find('tbody tr').length > 0){
				$('.order-table').find('tbody tr').each(function(){
					_price += ($(this).find('input[name=cnt]').val()*$(this).data('PRICE'));
				});
				$('.total-wrap .total-price').text($.pb.targetMoney(_price) + "원");
			}else{
				$('.total-wrap .total-price').text("0원");
			}
		};
		
		
		$('.total-wrap .register').on('click', function(){
			if($('.order-table tbody tr').length < 1) return alert("상품을 주문해 주세요.");
			$.pb.ajaxCallHandler('/adminSec/selectEventFuneralInfoList.do', {	eventNo : _param.pk }, function(data) {
				var _data = data.funeralInfoList[0];
				var endCode = String.fromCharCode(29) + "V" +  String.fromCharCode(65) +  String.fromCharCode(0);
				var init = String.fromCharCode(27)+"@";
				var cutCode = String.fromCharCode(parseInt('1B', 16))  + String.fromCharCode(parseInt('69', 16))
				var input = '1B';
			    var decimalValue = parseInt(input, 16);
			    var _data = data.funeralInfoList[0];		

				var transdata	= init;
				transdata += "\n"+_data.FUNERAL_NAME+"\n\n";
	 			transdata += "주소 : "+_data.ADDRESS+" "+(_data.ADDRESS_DETAIL ? _data.ADDRESS_DETAIL : "")+" \n";
	 			transdata += "사업자번호 : "+_data.BUS_NO+" \n";
	 			transdata += "대표자 : "+_data.BOSS_NAME+" \n";
	 			transdata += "전화 : "+_data.CONTACT+" \n";
	 			transdata += "\n                  * 고 객 용 *\n\n";
	 			transdata += "빈소명: "+_binso+" \n";
	 			transdata += "현재날짜: "+new Date().format('yyyy년 MM월 dd일 E hh시 mm분')+" \n";
	 			transdata += "------------------------------------------------ \n";
	 			transdata += "상품명               단가     수량    금액(원)\n";
	 		    transdata += "------------------------------------------------ \n";
	 		    
	 		    
	 		   var _formData = new FormData($('#eventSubForm')[0]);
				_formData.append('stockDt', new Date().format('yyyyMMdd'));
				_formData.append('funeralNo', _param.funeralNo);
				_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');

				var _orderList = [], _stockList = [], _totalPrice = 0;
				$('.order-table tbody tr').each(function(){
					var $list = {
							eventNo : _param.pk,
							itemNo : $(this).data('ITEM_NO'),
							cnt : $(this).find('input[name=cnt]').val(),
							takeBackName : $('input[name=takeBackName]').val(),
							reflectFlag : $(this).data('REFLECT_FLAG'),
							createUserNo : '${sessionScope.loginProcess.USER_NO}'
					}
					_orderList.push($list);
					
					if($(this).data('REFLECT_FLAG') == 1){
						var $list2 = {
								eventNo : _param.pk,
								itemNo : $(this).data('ITEM_NO'),
								cnt : $(this).find('input[name=cnt]').val(),
								orderName : $('input[name=orderName]').val(),
								reflectFlag : $(this).data('REFLECT_FLAG'),
								createUserNo : '${sessionScope.loginProcess.USER_NO}'
						}
						_stockList.push($list2);
					}
					
					if($(this).data('ITEM_NAME').length >= 11){
						if($.pb.targetMoney($(this).data('PRICE')).length >= 9){
							transdata += $(this).data('ITEM_NAME').substring(0,11)+"  "+$.pb.targetMoney($(this).data('PRICE'))+"   "+"-"+$(this).find('input[name=cnt]').val()+"\t"+"-"+$.pb.targetMoney($(this).data('PRICE')*$(this).find('input[name=cnt]').val())+"\n";
						}else{
							transdata += $(this).data('ITEM_NAME').substring(0,11)+"  "+$.pb.targetMoney($(this).data('PRICE'))+"\t   "+"-"+$(this).find('input[name=cnt]').val()+"\t"+"-"+$.pb.targetMoney($(this).data('PRICE')*$(this).find('input[name=cnt]').val())+"\n";
						}
					}else if($(this).data('ITEM_NAME').length < 6){
						if($(this).data('ITEM_NAME').replace(/[0-9]/gi, '').length == 5){
							if($.pb.targetMoney($(this).data('PRICE')).length >= 9){
								transdata += $(this).data('ITEM_NAME').substring(0,11)+"\t  "+$.pb.targetMoney($(this).data('PRICE'))+"   "+"-"+$(this).find('input[name=cnt]').val()+"\t"+"-"+$.pb.targetMoney($(this).data('PRICE')*$(this).find('input[name=cnt]').val())+"\n";
							}else{
								transdata += $(this).data('ITEM_NAME').substring(0,11)+"\t  "+$.pb.targetMoney($(this).data('PRICE'))+"\t   "+"-"+$(this).find('input[name=cnt]').val()+"\t"+"-"+$.pb.targetMoney($(this).data('PRICE')*$(this).find('input[name=cnt]').val())+"\n";
							}
						}else{
							if($.pb.targetMoney($(this).data('PRICE')).length >= 9){
								transdata += $(this).data('ITEM_NAME').substring(0,11)+"\t\t  "+$.pb.targetMoney($(this).data('PRICE'))+"   "+"-"+$(this).find('input[name=cnt]').val()+"\t"+"-"+$.pb.targetMoney($(this).data('PRICE')*$(this).find('input[name=cnt]').val())+"\n";
							}else{
								transdata += $(this).data('ITEM_NAME').substring(0,11)+"\t\t  "+$.pb.targetMoney($(this).data('PRICE'))+"\t   "+"-"+$(this).find('input[name=cnt]').val()+"\t"+"-"+$.pb.targetMoney($(this).data('PRICE')*$(this).find('input[name=cnt]').val())+"\n";
							}
						}
					}else{
						if($.pb.targetMoney($(this).data('PRICE')).length >= 9){
							transdata += $(this).data('ITEM_NAME').substring(0,11)+"\t  "+$.pb.targetMoney($(this).data('PRICE'))+"  "+"-"+$(this).find('input[name=cnt]').val()+"\t"+"-"+$.pb.targetMoney($(this).data('PRICE')*$(this).find('input[name=cnt]').val())+"\n";
							
						}else{
							transdata += $(this).data('ITEM_NAME').substring(0,11)+"\t  "+$.pb.targetMoney($(this).data('PRICE'))+"\t   "+"-"+$(this).find('input[name=cnt]').val()+"\t"+"-"+$.pb.targetMoney($(this).data('PRICE')*$(this).find('input[name=cnt]').val())+"\n";
						}
					}
					_totalPrice += $(this).data('PRICE')*$(this).find('input[name=cnt]').val();
				});
	 			_formData.append('orderList', JSON.stringify(_orderList));
	 			_formData.append('stockList', JSON.stringify(_stockList));
				
	 			transdata += "------------------------------------------------ \n";
	 			transdata += "합계금액                             "+"-"+$.pb.targetMoney(_totalPrice)+"\n";
	 		    transdata += "------------------------------------------------ \n";
	 			transdata += "주문자 : "+$('input[name=takeBackName]').val()+ "\n"
	 			transdata += "------------------------------------------------ \n";
	 			transdata += "\n서명\n\n\n"
	 			transdata += "------------------------------------------------ \n";
	 			transdata += "거 래 일 : "+new Date().format('yyyy년 MM월 dd일')+" \n\n\n";
	 			transdata += endCode;
	 			transdata += cutCode;
	 			bilgeOut(transdata);

				$.pb.ajaxUploadForm('/adminSec/insertEventTakeBack.do', _formData, function(result) {
					if(result != 0) {
						$(location).attr('href', '/29010104/'+_param.pk);
					} else alert('저장 실패 관리자에게 문의하세요');
				}, '${sessionScope.loginProcess}');
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
		}
		
	});
</script>
<style>
	.contents-body-wrap .event-info-box { box-sizing:border-box; position:relative; }
	.total-wrap .register { background:linear-gradient(to bottom, #999999, #303030); }
	.form-text { width:200px; display:inline-block; border:1px solid #707070; border-radius:2px; background:#F6F6F6; color:#333333; font-size:33px; font-weight:500; letter-spacing:0.8px; height:88px; margin-left:10px; }
	.order-name { font-size:19px; color:#333; position:absolute; left:25%; top:-34px; }
</style>
<div class="event-info-box or" style="width:45%; padding-right:20px;">
	<div class="box-title"><span class="binso"></span>물품표</div> 
	<div class="company-box"></div>
	<div class="item-box">
		<div class="classification-box">
			<table class="classification-table">
				<tbody></tbody>
			</table>
		</div>
		<div class="item-box">
			<div class="item-list"></div>
		</div>
	</div>
</div>

<div class="event-info-box or" style="width:55%; padding-left:20px;">
	<div class="box-title">반품내역</div>
	<div class="item-button-wrap">
		<button type="button" class="top-button del-item">선택항목삭제</button>
		<button type="button" class="top-button reset">초기화버튼</button>
	</div>
	<div class="table-head">
		<div style="width:5%;"><input type="checkbox" name="all" value="1"></div>
		<div style="width:25%;">품목</div>
		<div style="width:10%;">단위</div>
		<div style="width:15%;">수량</div>
		<div style="width:20%;">단가</div>
		<div style="width:25%;">금액</div>
	</div>
	<div class="order-box" style="height:434px;">
		<table class="order-table">
			<colgroup>
				<col width="5%"/>
				<col width="25%"/>
				<col width="10%"/>
				<col width="15%"/>
				<col width="20%"/>
				<col width="25%"/>
			</colgroup>
			<tbody>
			</tbody>
		</table>
	</div>
	<div class="total-wrap">
		<button type="button" class="register">반품완료</button>
			<div class="order-name">주문하신 분(직접입력)</div>
			<input type="text" class="form-text" name="takeBackName"/>
		<div class="total-text">주문 금액</div>
		<div class="total-price">0원</div>
	</div>
</div>	
	
