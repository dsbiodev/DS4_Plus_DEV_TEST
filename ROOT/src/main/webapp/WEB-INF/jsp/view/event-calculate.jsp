<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<!DOCTYPE html>
<script>
	$(function() {
		if(!'${sessionScope.loginProcess}') $(location).attr('href', '/');
		var _param = JSON.parse('${data}');

		$('.pay-box .discount-price').targetMoney();
		$('.pay-box .pay-price').targetMoney();
		$('.receipt-box .receipt-price').targetMoney();
		
		if (self.name != 'reload'){
		    self.name = 'reload';
		    self.location.reload(true);
		}else self.name = '';		
		
		//$(document).off().on('click', '.event-info-top > .right-wrap > .btn.order', function() {
		$(document).off().on('click', '.event-info-top > .right-wrap > .order', function() {			
			
			//20220321 초기화 추가
			$('.order-list-table').find('tbody').empty();
			
			$('.pb-right-popup-wrap.order').openLayerPopup({}, function(_thisLayer) {
				$('body').css('overflow', 'hidden');
				$.pb.ajaxCallHandler('/adminSec/selectEventOrderList.do', {	eventNo : _param.pk, order : 'CREATE_DT DESC' }, function(data) {
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
						$('.order-list-table').find('tbody').append(_tr);
					});
				});
			});
		});
		
		
		var createTable = function() {
			$.pb.ajaxCallHandler('/adminSec/selectEventCalculateList.do', {	eventNo : _param.pk, funeralNo : '${sessionScope.loginProcess.FUNERAL_NO}'}, function(data) {
				
				console.log(data)
				
				$('.company-price-table tbody').html("");
				$('.calculate-history-table tbody').html("");
				$('.receipt-history-table tbody').html("");

				$('.discount').html("");
				$('.discount').append('<option>없음</option>');
				$.each(data.calculateDiscountList, function(idx) {
					var _option = $('<option value='+this.DISCOUNT_NO+'>'+this.NAME+" - "+this.DISCOUNT_INFO+'['+this.DISCOUNT_RATE+'%]'+'</option>');
					_option.data(this);
					$('.discount').append(_option);
				});
				$('.discount').on('change', function(){ changeDiscount(); });
				
				var changeDiscount = function(){
					$('.company-price-table tbody').html("");
					
					var _totalPrice = 0, _cashPrice = 0, _cardPrice = 0, _realTotalPrice = 0;
					$.each(data.partnerCalculateList, function(idx) {
						var _tr = $('<tr>');
						_tr.data(this);
						_tr.append('<td>'+this.PARTNER_NAME+'</td>');
						_tr.append('<td class="r"><button type="button" class="btn-print-cost">인쇄</button></td>');
						_tr.find('.btn-print-cost').on('click', function() {
							if(_tr.data('ORDER_PRICE') == 0) return alert("주문된 내역이 없습니다.")
							else {
// 								window.open('/290904/'+_param.pk+"&"+_tr.data('PARTNER_NO'), "printName", "");
					 			window.open('/290904/'+_param.pk+"&"+_tr.data('PARTNER_NO'), "printName", "width=1000, height=800, scrolbars=yes");
							}
						});
						
						_tr.append('<td class="r"><button type="button" class="btn-print-tb">인쇄</button></td>');
						_tr.find('.btn-print-tb').on('click', function() {
							if(_tr.data('ORDER_PRICE') == 0) return alert("반품된 내역이 없습니다.")
							else {
// 								window.open('/290905/'+_param.pk+"&"+_tr.data('PARTNER_NO'), "printName", "");
					 			window.open('/290905/'+_param.pk+"&"+_tr.data('PARTNER_NO'), "printName", "width=1000, height=800, scrolbars=yes");
							}

						});
						
						_tr.append('<td class="r">'+$.pb.targetMoney(this.ORDER_PRICE)+'</td>');
						_tr.append('<td class="r">'+$.pb.targetMoney(this.TAKE_BACK_PRICE)+'</td>');
						_tr.append('<td class="r">'+$.pb.targetMoney(this.TOTAL_PRICE)+'</td>');

						_totalPrice += this.TOTAL_PRICE
						_cashPrice += this.CASH_PRICE;
						_cardPrice += this.CARD_PRICE;
						_realTotalPrice += this.REAL_TOTAL_PRICE;
						
// 						_tr.append('<td class="r">'+$.pb.targetMoney(this.CASH_PRICE)+'</td>');
// 						_tr.append('<td class="r">'+$.pb.targetMoney(this.CARD_PRICE)+'</td>');
// 						_tr.append('<td class="r">'+$.pb.targetMoney(this.REAL_TOTAL_PRICE)+'</td>');
// 						_tr.append('<td><button type="button" class="btn-pay">결제하기</button></td>');
// 						_tr.find('.btn-pay').on('click', function(){
// 							$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
// 								$('.pb-right-popup-wrap .pb-popup-title').text("결제");
// 								$('.pb-right-popup-wrap .popup-body-top .top-title').text("결제수단");
// 								$('.pb-right-popup-wrap .pay-box').show();
// 								$('.pb-right-popup-wrap .receipt-box').hide();
// 								$('.pay-box .partner').val(_tr.data('PARTNER_NAME')+(_tr.data('BUS_NO') ? "("+$.pb.busNoFomatter(_tr.data('BUS_NO'))+")" : ''));
// 								$('.pay-box .total-price').val($.pb.targetMoney(_tr.data('TOTAL_PRICE')));
// 								$('.pay-box .remaining-price').val($.pb.targetMoney(_tr.data('REAL_TOTAL_PRICE')));
// 								$('.pay-box .discount-remaining-price').val($.pb.targetMoney(_tr.data('REAL_TOTAL_PRICE')));
// 								$('.pay-box .pay-flag').removeClass('ac');
// 								$('.pay-box .discount-price').val(0);
// 								$('.pay-box .pay-price').val(0);
// 								$('.pay-remarks').val("");
// 								$('.pay-box .btn-pay').data(_tr.data());
								
// 								$('.pay-box .pay-flag').on('click', function(){
// 									$(this).addClass('ac').siblings('.pay-flag').removeClass('ac');
// 								});
// 								var _data = _tr.data();
								
// 								$('.pay-box .discount-price').on('focusin', function(){
// 			 						$('.pay-price').val(0);
// 			 						$('.discount-remaining-price').val($.pb.targetMoney(_data.REAL_TOTAL_PRICE));
// 			 					});
// 			 					$('.pay-box .discount-price').on('keyup', function(){
// 			 						if($(this).val().length == 0){
// 			 							$('.pay-price').val($.pb.targetMoney(_data.REAL_TOTAL_PRICE));
// 			 							$('.discount-remaining-price').val($.pb.targetMoney(_data.REAL_TOTAL_PRICE));
// 			 						}else{
// 			 							$('.discount-remaining-price').val($.pb.targetMoney(_data.REAL_TOTAL_PRICE - $(this).val().replace(/,/gi, '')));
// 			 							$('.pay-price').val($.pb.targetMoney(_data.REAL_TOTAL_PRICE - $(this).val().replace(/,/gi, '')));
// 			 	 						$('.pay-price').keyup();	
// 			 						}
// 			 					});
// 								$('.pay-box .discount-price').on('focusout', function(){
// 									if($(this).val().length < 1) $(this).val(0);
// 								});
// 								$('.pay-box .pay-price').on('focusout', function(){
// 									if($(this).val().length < 1) $(this).val(0);
// 								});
// 								layerInit(_thisLayer);
// 							});
// 						});
// 						_tr.append('<td><button type="button" class="btn-receipt">발행하기</button></td>');
// 						_tr.find('.btn-receipt').on('click', function(){
// 							$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
// 								$('.pb-right-popup-wrap .pb-popup-title').text("현금영수증");
// 								$('.pb-right-popup-wrap .popup-body-top .top-title').text("발행분류");
// 								$('.receipt-remarks').val("");
// 								$('.pb-right-popup-wrap .pay-box').hide();
// 								$('.pb-right-popup-wrap .receipt-box').show();
// 								$('.receipt-box .partner').val(_tr.data('PARTNER_NAME')+(_tr.data('BUS_NO') ? "("+$.pb.busNoFomatter(_tr.data('BUS_NO'))+")" : ''));
// 								$('.receipt-box .receipt-flag').on('click', function(){
// 									$(this).addClass('ac').siblings('.receipt-flag').removeClass('ac');
// 									if($('.receipt-flag.ac').data('value') == "03") $('.receipt-box .issue-no').val("0100001234").attr('disabled', true);
// 									else $('.receipt-box .issue-no').val("").attr('disabled', false);
// 								});
// 								$('.receipt-box .btn-receipt').data(_tr.data());
// 								$('.receipt-box .receipt-flag').removeClass('ac');
// 								$('.receipt-box .issue-no').val("").attr('disabled', false);
// 								$('.receipt-box .receipt-price').val(0);
// 								layerInit(_thisLayer);
// 							});
// 						});
						
						$('.company-price-table tbody').append(_tr);
					});
					
					$('.company-price-table tbody tr:eq(0)').append('<td rowspan='+data.partnerCalculateList.length+' class="r">'+$.pb.targetMoney(_cashPrice)+'</td>');
					$('.company-price-table tbody tr:eq(0)').append('<td rowspan='+data.partnerCalculateList.length+' class="r">'+$.pb.targetMoney(_cardPrice)+'</td>');
					$('.company-price-table tbody tr:eq(0)').append('<td rowspan='+data.partnerCalculateList.length+' class="r">'+$.pb.targetMoney(_realTotalPrice)+'</td>');
					$('.company-price-table tbody tr:eq(0)').append('<td rowspan='+data.partnerCalculateList.length+'><button type="button" class="btn-pay">결제하기</button></td>');
					$('.company-price-table tbody tr:eq(0)').find('.btn-pay').on('click', function() { 
						var _data = $('.company-price-table tbody tr:eq(0)').data();
						$('.pb-right-popup-wrap.cal').openLayerPopup({}, function(_thisLayer) {
							$('body').css('overflow', 'hidden');
							$('.pb-right-popup-wrap.cal .pb-popup-title').text("결제");
							$('.pb-right-popup-wrap.cal .popup-body-top .top-title').text("결제수단");
							$('.pb-right-popup-wrap.cal .pay-box').show();
							$('.pb-right-popup-wrap.cal .receipt-box').hide();
// 							$('.pay-box .partner').val(_tr.data('PARTNER_NAME')+(_tr.data('BUS_NO') ? "("+$.pb.busNoFomatter(_tr.data('BUS_NO'))+")" : ''));
							$('.pay-box .total-price').val($.pb.targetMoney(_totalPrice));
							$('.pay-box .remaining-price').val($.pb.targetMoney(_realTotalPrice));
							$('.pay-box .discount-remaining-price').val($.pb.targetMoney(_realTotalPrice));
							$('.pay-box .pay-flag').removeClass('ac');
							$('.pay-box .discount-price').val(0);
							
							//20220318 주석
							//$('.pay-box .pay-price').val(0);
							$('.pay-box .pay-price').val($.pb.targetMoney(_realTotalPrice));
							$('.pay-remarks').val("");
							$('.pay-box .btn-pay').data(_data);
						
							$('.pay-box .pay-flag').on('click', function(){
								$(this).addClass('ac').siblings('.pay-flag').removeClass('ac');
							});
							
							$('.pay-box .discount-price').on('focusin', function(){
		 						//20220318 주석처리
								//$('.pay-price').val(0);
		 						$('.discount-remaining-price').val($.pb.targetMoney(_realTotalPrice));
		 					});
		 					$('.pay-box .discount-price').on('keyup', function(){
		 						if($(this).val().length == 0){
		 							$('.pay-price').val($.pb.targetMoney(_realTotalPrice));
		 							$('.discount-remaining-price').val($.pb.targetMoney(_realTotalPrice));
		 						}else{
		 							$('.discount-remaining-price').val($.pb.targetMoney(_realTotalPrice - $(this).val().replace(/,/gi, '')));
		 							$('.pay-price').val($.pb.targetMoney(_realTotalPrice - $(this).val().replace(/,/gi, '')));
		 	 						$('.pay-price').keyup();	
		 						}
		 					});
							$('.pay-box .discount-price').on('focusout', function(){
								if($(this).val().length < 1) $(this).val(0);
							});
							$('.pay-box .pay-price').on('focusout', function(){
								if($(this).val().length < 1) $(this).val(0);
							});
							layerInit(_thisLayer);
						});
					});
	
					$('.company-price-table tbody tr:eq(0)').append('<td rowspan='+data.partnerCalculateList.length+'><button type="button" class="btn-receipt">발행하기</button></td>');
					$('.company-price-table tbody tr:eq(0)').find('.btn-receipt').on('click', function() { 
						var _data = $('.company-price-table tbody tr:eq(0)').data();
						$('.pb-right-popup-wrap.cal').openLayerPopup({}, function(_thisLayer) {
							$('body').css('overflow', 'hidden');
							$('.pb-right-popup-wrap.cal .pb-popup-title').text("현금영수증");
							$('.pb-right-popup-wrap.cal .popup-body-top .top-title').text("발행분류");
							$('.receipt-remarks').val("");
							$('.pb-right-popup-wrap.cal .pay-box').hide();
							$('.pb-right-popup-wrap.cal .receipt-box').show();
							$('.receipt-box .partner').val(_data.PARTNER_NAME+(_data.BUS_NO ? "("+$.pb.busNoFomatter(_data.BUS_NO)+")" : ''));
							$('.receipt-box .receipt-flag').on('click', function(){
								$(this).addClass('ac').siblings('.receipt-flag').removeClass('ac');
								if($('.receipt-flag.ac').data('value') == "03") $('.receipt-box .issue-no').val("0100001234").attr('disabled', true);
								else $('.receipt-box .issue-no').val("").attr('disabled', false);
							});
							$('.receipt-box .btn-receipt').data(_data);
							$('.receipt-box .receipt-flag').removeClass('ac');
							$('.receipt-box .issue-no').val("").attr('disabled', false);
							$('.receipt-box .receipt-price').val(0);
							layerInit(_thisLayer);
						});
					});
	
	
				};changeDiscount();
				
				$.each(data.calculateHistoryList, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td>'+(this.UPDATE_DT ? this.UPDATE_DT : this.CREATE_DT)+'</td>');
					_tr.append('<td>'+this.PARTNER_NAME+'</td>');
					_tr.append('<td>'+this.PAY_FLAG_NAME+'</td>');
					_tr.append('<td class="r">'+$.pb.targetMoney(this.PAY_PRICE)+'</td>');
					_tr.append('<td class="r">'+$.pb.targetMoney(this.DISCOUNT_PRICE)+'</td>');
					_tr.append('<td class="r">'+$.pb.targetMoney(this.REAL_PAY_PRICE)+'</td>');
					_tr.append('<td>'+(this.REMARKS ? this.REMARKS : '-')+'</td>');
					_tr.append('<td>'+(this.PAY_FLAG != 3 ? '<button type="button" class="btn-pay-cancel">결제취소</button>' : '-')+'</td>');
					_tr.find('.btn-pay-cancel').on('click', function() {
						var _formData = new FormData();
 						_formData.append('calculateNo', _tr.data('CALCULATE_NO'));
 						_formData.append('payFlag', _tr.data('PAY_FLAG'));
 						_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
 						
						//카드
						if(_tr.data('PAY_FLAG') == 1){
							$('form[name=payForm] > object').remove();
							var _payObj = $('<object>');
							_payObj.attr('classid', 'CLSID:C74CC3D6-6C88-4F02-8636-3A54928EDDD8');
							_payObj.attr('codebase', '/resources/js/PosToCatReq.ocx#version=2,0,0,3');
							_payObj.attr('id', 'm_PosToCat');
							_payObj.attr('width', '0');
							_payObj.attr('height', '0');
							_payObj.attr('idborder', '0');
							$('form[name=payForm]').append(_payObj);
							if(confirm("신용카드 결제 취소를 진행하겠습니다.")) {
								console.log("11111111")
								$('.ajax-loading').show();
								var result = cancelCard(_tr.data('quota'), _tr.data('amount'), _tr.data('appNo'), _tr.data('appDate'), _tr.data('catId'));
								if(result){
									_formData.append('result', result);
									$.pb.ajaxUploadForm('/adminSec/updateCalCulate.do', _formData, function(result) {
					 					if(result == "1") {
					 						createTable();
					 						$('.ajax-loading').hide();
					 						$('.pb-popup-close').click();
					 					} else alert(decodeURIComponent(result));
					 				}, '${sessionScope.loginProcess}');
								}
							}else $('form[name=payForm] > object').remove();
						}else{ //현금
							if(confirm("현금 결제 취소를 진행하겠습니다.")){
								$.pb.ajaxUploadForm('/adminSec/updateCalCulate.do', _formData, function(result) {
		 							createTable();
		 						}, '${sessionScope.loginProcess}');	
							}
						}
					});
					$('.calculate-history-table tbody').append(_tr);
				});
				
				$.each(data.receiptHistoryList, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td>'+(this.UPDATE_DT ? this.UPDATE_DT : this.CREATE_DT)+'</td>');
					_tr.append('<td>'+this.PARTNER_NAME+'</td>');
					_tr.append('<td>'+this.ISSUE_NO+'</td>');
					_tr.append('<td class="r">'+$.pb.targetMoney(this.RECEIPT_PRICE)+'</td>');
					_tr.append('<td>'+(this.REMARKS ? this.REMARKS : '-')+'</td>');
					_tr.append('<td>'+(this.FLAG != 2 ? '<button type="button" class="btn-receipt-cancel">발행취소</button>' : '-')+'</td>');
					_tr.find('.btn-receipt-cancel').on('click', function() {
						var _formData = new FormData();
 						_formData.append('receiptNo', _tr.data('RECEIPT_NO'));
 						_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
 						
						$('form[name=payForm] > object').remove();
						var _payObj = $('<object>');
						_payObj.attr('classid', 'CLSID:C74CC3D6-6C88-4F02-8636-3A54928EDDD8');
						_payObj.attr('codebase', '/resources/js/PosToCatReq.ocx#version=2,0,0,3');
						_payObj.attr('id', 'm_PosToCat');
						_payObj.attr('width', '0');
						_payObj.attr('height', '0');
						_payObj.attr('idborder', '0');
						$('form[name=payForm]').append(_payObj);
						if(confirm("현금영수증 발행 취소를 진행하겠습니다.")) {
							$('.ajax-loading').show();
							var result = cancelReceipt(_tr.data('type'), _tr.data('ISSUE_NO'), _tr.data('amount'), _tr.data('appDate'), _tr.data('appNo'), _tr.data('catId'));
							if(result){
								_formData.append('result', result);
								$.pb.ajaxUploadForm('/adminSec/updateReceipt.do', _formData, function(result) {
				 					if(result == "1") {
				 						createTable();
										$('.ajax-loading').hide();
				 						$('.pb-popup-close').click();
				 					} else alert(decodeURIComponent(result));
				 				}, '${sessionScope.loginProcess}');
							}
						}else $('form[name=payForm] > object').remove();
					});
					$('.receipt-history-table tbody').append(_tr);
				});
			});
		};createTable();
		
		$('.pb-popup-close, .popup-mask').on('click', function() {
			$('body').css('overflow', 'auto');
			closeLayerPopup();
		});
		
		// 결제하기 출력
		$('.div-pay .btn-pay').on('click', function(){
								
			var agent = navigator.userAgent.toLowerCase();
			if((navigator.appName == 'Netscape' && agent.indexOf('trident') == -1) && (agent.indexOf("msie") == -1)) return alert("인터넷익스플로러 브라우저로 실행해 주세요.");
			
			if(!$('.pay-box .pay-flag.ac').data('value')) return alert("결제수단을 선택해 주세요.");
			if(!$('.pay-box .pay-price').val()) return alert("결제금액을 입력해 주세요.");
			if($('.discount-remaining-price').val().replace(/,/gi, '')*1 < $('.pay-price').val().replace(/,/gi, '')*1) return alert("결제금액이 할인 후 금액보다 클 수 없습니다.");
				
			var _formData = new FormData();
			_formData.append('eventNo', _param.pk);
			_formData.append('partnerNo', $(this).data('PARTNER_NO'));
			_formData.append('discountPrice', $('.pay-box .discount-price').val().replace(/,/gi, ''));
			_formData.append('payPrice', $('.pay-box .pay-price').val().replace(/,/gi, ''));
			_formData.append('payFlag', $('.pay-box .pay-flag.ac').data('value'));
			_formData.append('remarks', $('.pay-box .pay-remarks').val());
			_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
			if($('.pay-box .pay-flag.ac').data('value') == 1){ // 카드결제
				$('form[name=payForm] > object').remove();
				var _payObj = $('<object>');
				_payObj.attr('classid', 'CLSID:C74CC3D6-6C88-4F02-8636-3A54928EDDD8');
				_payObj.attr('codebase', '/resources/js/PosToCatReq.ocx#version=2,0,0,3');
				_payObj.attr('id', 'm_PosToCat');
				_payObj.attr('width', '0');
				_payObj.attr('height', '0');
				_payObj.attr('idborder', '0');
				$('form[name=payForm]').append(_payObj);
				if(confirm("신용카드 결제를 진행하겠습니다.")) {
					$('.ajax-loading').show();
					var result = reqcard(1, $('.pay-box .pay-price').val().replace(/,/gi, ''), 00, $(this).data('NICE_CAT_ID'));
					if(result){
						_formData.append('result', result);
						$.pb.ajaxUploadForm('/adminSec/insertCalCulate.do', _formData, function(result) {
		 					if(result == "1") {
		 						createTable();
								$('.ajax-loading').hide();
		 						$('.pb-popup-close').click();
		 					} else alert(decodeURIComponent(result));
		 				}, '${sessionScope.loginProcess}');
					}
				}else $('form[name=payForm] > object').remove();
			}else{ //현금결제
				if(confirm("현금 결제를 진행하겠습니다.")){
					$.pb.ajaxUploadForm('/adminSec/insertCalCulate.do', _formData, function(result) {
						if(result != 0) {
							createTable();
							$('.pb-popup-close').click();
						} else alert('저장 실패 관리자에게 문의하세요');
					}, '${sessionScope.loginProcess}');
				}
			}
		});
		
		// 현금영수증 출력
		$('.div-receipt .btn-receipt').on('click', function(){
			var agent = navigator.userAgent.toLowerCase();
			if((navigator.appName == 'Netscape' && agent.indexOf('trident') == -1) && (agent.indexOf("msie") == -1)) return alert("인터넷익스플로러 브라우저로 실행해 주세요.");
			
			if(!$('.receipt-box .receipt-flag.ac').data('value')) return alert("발행분류를 선택해 주세요.");
			if(!$('.receipt-box .issue-no').val()) return alert("발행번호를 입력해 주세요.");
			if(!$('.receipt-box .receipt-price').val()) return alert("발행금액을 입력해 주세요.");
			var _formData = new FormData();
			_formData.append('eventNo', _param.pk);
			_formData.append('partnerNo', $(this).data('PARTNER_NO'));
			_formData.append('issueNo', $('.receipt-box .issue-no').val().replace(/,/gi, ''));
			_formData.append('receiptPrice', $('.receipt-box .receipt-price').val().replace(/,/gi, ''));
			_formData.append('remarks', $('.receipt-box .receipt-remarks').val());
			_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
			
			$('form[name=payForm] > object').remove();
			var _payObj = $('<object>');
			_payObj.attr('classid', 'CLSID:C74CC3D6-6C88-4F02-8636-3A54928EDDD8');
			_payObj.attr('codebase', '/resources/js/PosToCatReq.ocx#version=2,0,0,3');
			_payObj.attr('id', 'm_PosToCat');
			_payObj.attr('width', '0');
			_payObj.attr('height', '0');
			_payObj.attr('idborder', '0');
			$('form[name=payForm]').append(_payObj);
			if(confirm("현금영수증 발행을 진행하겠습니다.")){
				$('.ajax-loading').show();
	 			var result = taxPoint($('.receipt-box .receipt-flag').data('value'), $('.receipt-box .issue-no').val(), $('.receipt-box .receipt-price').val().replace(/,/gi, ''), $(this).data('NICE_CAT_ID'));
				if(result){
					_formData.append('result', result);
					$.pb.ajaxUploadForm('/adminSec/insertReceipt.do', _formData, function(result) {
	 					if(result == "1") {
	 						createTable();
							$('.ajax-loading').hide();
	 						$('.pb-popup-close').click();
	 					} else alert(decodeURIComponent(result));
	 				}, '${sessionScope.loginProcess}');
				}
			}else $('form[name=payForm] > object').remove();

		});
		
		//카드결제시 함수
		var FS = "\x1C";
		var	STX = "\x02";
		var	ETX = "\x03";
		function reqcard(cat_port, goods_amt, quota_interest, catId) { //신용승인 요청
			// catid 다중사업자시에 필요
			var _result = "";
// 			var s_buf = "D1" + FS + FS + FS + quota_interest + FS + FS + FS + goods_amt + FS + FS + FS + "DJ"+ catId + FS + FS;
			var s_buf = "D1" + FS + FS + FS + quota_interest + FS + FS + FS + goods_amt + FS + FS + FS + FS + FS;
			ret = self.document.payForm.m_PosToCat.ReqToCat(cat_port, 9600, s_buf); //포트, 통신속도, 데이터
			if(ret == 1) {
				_result = self.document.payForm.m_PosToCat.GetData();
// 				alert("응답데이터 : " + self.document.payForm.m_PosToCat.GetData());
			}else if(ret == -2) reqcard(cat_port, goods_amt, quota_interest);
			$('form[name=payForm] > object').remove();
			$('.ajax-loading').hide();
			return _result;
		}

		//현금영수증
		function taxPoint(flag, issueNo, amt, catId) {
			var _result = "";
			var s_buf = "D3" + FS + flag + FS  + "@" + FS + issueNo + FS + FS + FS + amt + FS + FS + FS + FS + "DJ" + catId + FS;
// 			var s_buf = "D3" + FS + flag + FS  + "@" + FS + issueNo + FS + FS + FS + amt + FS + FS + FS + FS + FS;
			ret = self.document.payForm.m_PosToCat.ReqToCat(1, 9600, s_buf); //포트, 통신속도, 데이터
			if(ret == 1)  {
				_result = self.document.payForm.m_PosToCat.GetData();
// 				alert("응답데이터 : " + self.document.payForm.m_PosToCat.GetData());
			} else  {
				// 현금영수증은 단말기에서 종료버튼 없이 바로 결제 되어서 요청실패시 재요청
				if(ret == -2) taxPoint(issue_no, amt);
			}
			$('form[name=payForm] > object').remove();
			$('.ajax-loading').hide();
			return _result;
		}
		
		
		//신용카드 결제 취소
		function cancelCard(quota, amount, appNo, appDate, catId) {
			var _result = "";
// 			var s_buf = "D2" + FS + FS + FS + quota + FS + FS + FS + amount + FS + appNo + FS + appDate + FS +"DJ"+ catId + FS + FS;
			var s_buf = "D2" + FS + FS + FS + quota + FS + FS + FS + amount + FS + appNo + FS + appDate + FS + catId + FS + FS;
			ret = self.document.payForm.m_PosToCat.ReqToCat(1, 9600, s_buf); //포트, 통신속도, 데이터
			
			console.log(ret)
			if(ret == 1) _result = self.document.payForm.m_PosToCat.GetData();
			else if(ret == -2) ret = self.document.payForm.m_PosToCat.ReqToCat(1, 9600, s_buf); //포트, 통신속도, 데이터
			$('form[name=payForm] > object').remove();
			$('.ajax-loading').hide();
			return _result;
		}

		//현금영수증 취소
		function cancelReceipt(type, issueNo, amount, appDate, appNo, catId) {
			var _result = "";
// 			var s_buf = "D4" + FS + type + FS + "@" + FS + issueNo + FS + FS + FS + amount + FS + "1" + FS + appDate + FS + appNo + FS + "DJ" + catId + FS;
			var s_buf = "D4" + FS + type + FS + "@" + FS + issueNo + FS + FS + FS + amount + FS + "1" + FS + appDate + FS + appNo + FS + FS;
			ret = self.document.payForm.m_PosToCat.ReqToCat(1, 9600, s_buf); //포트, 통신속도, 데이터
			if(ret == 1) _result = self.document.payForm.m_PosToCat.GetData();
			else if(ret == -2) ret = self.document.payForm.m_PosToCat.ReqToCat(1, 9600, s_buf); //포트, 통신속도, 데이터
			$('form[name=payForm] > object').remove();
			$('.ajax-loading').hide();
			return _result;
		}
	});
</script>
<style>
	.pb-right-popup-wrap > .pb-popup-body { height: calc(100vh - 96px); }
    
	.contents-body-wrap .event-info-box { box-sizing:border-box; position:relative; }
	.popup-table tbody .blue { background:#a7e3fd; }
	.popup-table tbody .orange { background:#fdce0c; }
	.pb-table.order-list-table > tbody > tr:nth-child(2n) { background: #f0f0f0; }
	.pb-table.order-list-table > tbody > tr:hover { background: #ffeda0; }
	.pb-table.order-list-table td { padding: 8px 5px; color: #333333; font-size: 16px; font-weight: 500; letter-spacing: 0.8px; text-align: center; }
</style>
<div class="pb-right-popup-wrap order">
	<div class="pb-popup-title">주문상세 내역 POP</div>
	<span class="pb-popup-close"></span>
	<div class="pb-popup-body">
		<table class="pb-table list order-list-table">
			<colgroup>
				<col width="8%"/>
				<col width="29%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="15%"/>
				<col width="15%"/>
				<col width="25%"/>
			</colgroup>
			<thead>
				<tr>
					<th>구분</th>
					<th>주문/반품 품목</th>
					<th>수량</th>
					<th>단위</th>
					<th>단가</th>
					<th>주문</th>
					<th>주문일시</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
</div>
	
<div class="pb-right-popup-wrap cal">
	<div class="pb-popup-title">결제</div>
	<span class="pb-popup-close"></span>
	<div class="pb-popup-body" style="height:auto;">
		<div class="popup-body-top">
			<div class="top-title">결제수단</div>
			<div class="top-button-wrap">
				<button type="button" class="top-button pb-popup-close">닫기</button>
			</div>
		</div>
		
		<div class="pay-box">
			<div class="div-pay">
				<div class="pay-flag" data-value="1">카드</div>
				<div class="pay-flag" data-value="2">현금</div>
			</div>
			<div class="top-title">결제금액</div>
			<div class="div-pay">
				<div class="text">발행 사업자</div>
				<input type="text" class="form-text price partner" style="text-align:center;" disabled>
			</div>
			<div class="div-pay">
				<div class="text">총금액</div>
				<input type="text" class="form-text price total-price" disabled>
			</div>
			<div class="div-pay">
				<div class="text">남은결제 금액</div>
				<input type="text" class="form-text price remaining-price" disabled>
			</div>
			<div class="div-pay">
				<div class="text">할인 금액(직접입력)</div>
				<input type="text" class="form-text price discount-price" maxlength="12">
			</div>
			<div class="div-pay">
				<div class="text">할인 후 금액</div>
				<input type="text" class="form-text price discount-remaining-price" disabled>
			</div>
			<div class="div-pay">
				<div class="text">결제할 금액(직접입력)</div>
				<input type="text" class="form-text price pay-price" maxlength="12">
			</div>
			<div class="div-pay">
				<div class="text">비고</div>
				<input type="text" class="form-text price pay-remarks" style="text-align:left;">
			</div>
			<div class="top-title">결제하기</div>
			<div class="div-pay">
				<button type="button" class="btn-pay">결제하기</button>
			</div>
		</div>
		
		<div class="receipt-box" style="display:none;">
			<div class="div-receipt">
				<div class="text" style="width:39.5%;">발행 분류</div>
				<div style="display:flex; justify-content:space-between; width:59.5%;">
					<div class="receipt-flag" data-value="01">개인소득공제</div>
					<div class="receipt-flag" data-value="02">사업자 지출증빙</div>
					<div class="receipt-flag" data-value="03">자진발급</div>
				</div>
			</div>
			
			<div class="div-receipt">
				<div class="text" style="width:39.5%;">발행 사업자</div>
				<input type="text" class="form-text price partner" style="text-align:center; width:59.5%;" disabled>
			</div>
			<div class="top-title">발행 받으시는 분</div>
			<div class="div-receipt">
				<div class="text">발행 번호</div>
				<input type="text" class="form-text price issue-no" onkeydown="return onlyNumber(event)" onkeyup="removeChar(event)" placeholder="주민(사업자, 핸드폰)번호 입력">
			</div>
			<div class="div-receipt">
				<div class="text">발행 금액</div>
				<input type="text" class="form-text price receipt-price">
			</div>
			<div class="div-receipt">
				<div class="text">비고</div>
				<input type="text" class="form-text price receipt-remarks" style="text-align:left;">
				
				
			</div>
			<div class="top-title">결제하기</div>
			<div class="div-receipt">
				<button type="button" class="btn-receipt">현금영수증 발행</button>
			</div>
		</div>
	</div>	
</div>

<div class="event-info-box or">
	<div class="box-title">주문정보
<!-- 		<div style="position:absolute; right:399px; background:linear-gradient(to bottom, #FFFFFF, #EBEDEE); top:29px; padding:6px 25px; border:1px solid #707070; font-size:16px; z-index:1">할인정보</div> -->
<!-- 		<select class="form-select discount" style="width:400px; position:absolute; right:0; height:38px; font-size:16px; font-weight:500; padding:0px 5px;"></select> -->
	</div>
	
	<div class="company-price-box">
		<table class="company-price-table">
			<colgroup>
				<col width="*"/>
				<col width="6%"/>
				<col width="6%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="8%"/>
				<col width="8%"/>
			</colgroup>
			<thead>
				<tr>
					<td>사업자</td>
					
					<td>비용내역서</td>
					<td>반품내역서</td>
					
					<td>총 주문금액</td>
					<td>총 반품금액</td>
					<td>총금액</td>
					<td>현금결제</td>
					<td>카드결제</td>
					<td>남은결제 금액</td>
					<td>현금/카드</td>
					<td>현금영수증</td>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
</div>

<div class="event-info-box or">
	<div class="box-title">결제이력</div>
	<div class="calculate-history-box">
		<table class="calculate-history-table">
			<colgroup>
				<col width="10%"/>
				<col width="15%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="20%"/>
				<col width="15%"/>
			</colgroup>
			<thead>
				<tr><td>결제일시</td><td>사업자</td><td>결제구분</td><td>결제금액</td><td>할인금액</td><td>실제결제금액</td><td>비고</td><td>결제취소</td></tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
</div>

<div class="event-info-box or">
	<div class="box-title">현금영수증 이력</div>
	<div class="receipt-history-box">
		<table class="receipt-history-table">
			<colgroup>
				<col width="10%"/>
				<col width="15%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="15%"/>
				<col width="10%"/>
			</colgroup>
			<thead>
				<tr><td>결제일시</td><td>사업자</td><td>발행번호</td><td>발행금액</td><td>비고</td><td>결제취소</td></tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
</div>

<form name="payForm" method="POST" action="/view/CATPayResult">
	<input type="hidden" name="resultData" value="">
	<input type="hidden" name="catComPort" value="1"/>
	<input type="hidden" name="reserved1" value="">
	<input type="hidden" name="reserved2" value="">
</form>
