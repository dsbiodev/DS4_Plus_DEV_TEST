<%@ page language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');

		$('.pay-box .discount-price').targetMoney();
		$('.pay-box .pay-price').targetMoney();
		$('.receipt-box .receipt-price').targetMoney();
		
		var createTable = function() {
			$.pb.ajaxCallHandler('/adminSec/selectEventCalculateList.do', {	eventNo : _param.pk, funeralNo : _param.funeralNo}, function(data) {
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
					$.each(data.partnerCalculateList, function(idx) {
						var _tr = $('<tr>');
						_tr.data(this);
						_tr.append('<td>'+this.PARTNER_NAME+'</td>');
						_tr.append('<td class="r">'+$.pb.targetMoney(this.TOTAL_PRICE)+'</td>');
						if($('.discount option:selected').data('PARTNER_NO') == this.PARTNER_NO){
							_tr.append('<td>'+$('.discount option:selected').data('DISCOUNT_INFO')+'</td>');
							_tr.append('<td>'+$('.discount option:selected').data('DISCOUNT_RATE')+'%</td>');
		 					_tr.append('<td class="r">'+$.pb.targetMoney(this.TOTAL_PRICE*($('.discount option:selected').data('DISCOUNT_RATE'))/100)+'</td>');
		 					_tr.append('<td class="r">'+$.pb.targetMoney(this.TOTAL_PRICE*(100-$('.discount option:selected').data('DISCOUNT_RATE'))/100)+'</td>');
						}else{
							_tr.append('<td>-</td>');
							_tr.append('<td>-</td>');
							_tr.append('<td>-</td>');
							_tr.append('<td>-</td>');
						}
						_tr.append('<td class="r">'+$.pb.targetMoney(this.CASH_PRICE)+'</td>');
						_tr.append('<td class="r">'+$.pb.targetMoney(this.CARD_PRICE)+'</td>');
						_tr.append('<td class="r">'+$.pb.targetMoney(this.REAL_TOTAL_PRICE)+'</td>');
						_tr.append('<td><button type="button" class="btn-pay">결제하기</button></td>');
						_tr.find('.btn-pay').on('click', function(){
							$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
								$('.pb-right-popup-wrap .pb-popup-title').text("결제");
								$('.pb-right-popup-wrap .popup-body-top .top-title').text("결제수단");
								$('.pb-right-popup-wrap .pay-box').show();
								$('.pb-right-popup-wrap .receipt-box').hide();
								$('.pay-box .partner').val(_tr.data('PARTNER_NAME')+(_tr.data('BUS_NO') ? "("+$.pb.busNoFomatter(_tr.data('BUS_NO'))+")" : ''));
								$('.pay-box .total-price').val($.pb.targetMoney(_tr.data('TOTAL_PRICE')));
								$('.pay-box .remaining-price').val($.pb.targetMoney(_tr.data('REAL_TOTAL_PRICE')));
								$('.pay-box .discount-remaining-price').val($.pb.targetMoney(_tr.data('REAL_TOTAL_PRICE')));
								$('.pay-box .pay-flag').removeClass('ac');
								$('.pay-box .discount-price').val(0);
								$('.pay-box .pay-price').val(0);
								$('.pay-remarks').val("");
								$('.pay-box .btn-pay').data('PARTNER_NO', _tr.data('PARTNER_NO'));
								
								$('.pay-box .pay-flag').on('click', function(){
									$(this).addClass('ac').siblings('.pay-flag').removeClass('ac');
								});
								var _data = _tr.data();
								
								$('.pay-box .discount-price').on('focusin', function(){
			 						$('.pay-price').val(0);
			 						$('.discount-remaining-price').val($.pb.targetMoney(_data.REAL_TOTAL_PRICE));
			 					});
			 					$('.pay-box .discount-price').on('keyup', function(){
			 						if($(this).val().length == 0){
			 							$('.pay-price').val($.pb.targetMoney(_data.REAL_TOTAL_PRICE));
			 							$('.discount-remaining-price').val($.pb.targetMoney(_data.REAL_TOTAL_PRICE));
			 						}else{
			 							$('.discount-remaining-price').val($.pb.targetMoney(_data.REAL_TOTAL_PRICE - $(this).val().replace(/,/gi, '')));
			 							$('.pay-price').val($.pb.targetMoney(_data.REAL_TOTAL_PRICE - $(this).val().replace(/,/gi, '')));
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
						
						_tr.append('<td><button type="button" class="btn-receipt">발행하기</button></td>');
						_tr.find('.btn-receipt').on('click', function(){
							$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
								$('.pb-right-popup-wrap .pb-popup-title').text("현금영수증");
								$('.pb-right-popup-wrap .popup-body-top .top-title').text("발행분류");
								$('.receipt-remarks').val("");
								$('.pb-right-popup-wrap .pay-box').hide();
								$('.pb-right-popup-wrap .receipt-box').show();
								$('.receipt-box .partner').val(_tr.data('PARTNER_NAME')+(_tr.data('BUS_NO') ? "("+$.pb.busNoFomatter(_tr.data('BUS_NO'))+")" : ''));
								$('.receipt-box .receipt-flag').on('click', function(){
									$(this).addClass('ac').siblings('.receipt-flag').removeClass('ac');
									if($('.receipt-flag.ac').data('value') == "03") $('.receipt-box .issue-no').val("0100001234").attr('disabled', true);
									else $('.receipt-box .issue-no').val("").attr('disabled', false);
								});
								$('.receipt-box .btn-receipt').data('PARTNER_NO', _tr.data('PARTNER_NO'));
								$('.receipt-box .receipt-flag').removeClass('ac');
								$('.receipt-box .issue-no').val("").attr('disabled', false);
								$('.receipt-box .receipt-price').val(0);
								layerInit(_thisLayer);
							});
						});
						$('.company-price-table tbody').append(_tr);
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
					_tr.find('.btn-pay-cancel').on('click', function(){
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
							if(confirm("신용카드 결제 취소를 진행하겠습니다.")){
								var result = cancelCard(_tr.data('quota'), _tr.data('amount'), _tr.data('appNo'), _tr.data('appDate'), _tr.data('catId'));
								if(result){
									_formData.append('result', result);
									$.pb.ajaxUploadForm('/adminSec/updateCalCulate.do', _formData, function(result) {
					 					if(result == "1") {
					 						createTable();
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
					_tr.find('.btn-receipt-cancel').on('click', function(){
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
						if(confirm("현금영수증 발행 취소를 진행하겠습니다.")){
							var result = cancelReceipt(_tr.data('type'), _tr.data('ISSUE_NO'), _tr.data('amount'), _tr.data('appDate'), _tr.data('appNo'), _tr.data('catId'));
							if(result){
								_formData.append('result', result);
								$.pb.ajaxUploadForm('/adminSec/updateReceipt.do', _formData, function(result) {
				 					if(result == "1") {
				 						createTable();
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
		
		// 결제하기 출력
		$('.div-pay .btn-pay').on('click', function(){
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
				if(confirm("신용카드 결제를 진행하겠습니다.")){
					var result = reqcard(1, $('.pay-box .pay-price').val().replace(/,/gi, ''), 00);
					if(result){
						_formData.append('result', result);
						$.pb.ajaxUploadForm('/adminSec/insertCalCulate.do', _formData, function(result) {
		 					if(result == "1") {
		 						createTable();
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
		
		//카드결제시 함수
		var FS = "\x1C";
		var	STX = "\x02";
		var	ETX = "\x03";
		function reqcard(cat_port, goods_amt, quota_interest) { //신용승인 요청
			var _result = "";
// 			var s_buf = "D1" + FS + FS + FS + quota_interest + FS + FS + FS + goods_amt + FS + FS + FS + "DJ7098510001" + FS + FS;
			var s_buf = "D1" + FS + FS + FS + quota_interest + FS + FS + FS + goods_amt + FS + FS + FS + "DJ7098054001" + FS + FS;
			ret = self.document.payForm.m_PosToCat.ReqToCat(cat_port, 9600, s_buf); //포트, 통신속도, 데이터
			if(ret == 1) {
				_result = self.document.payForm.m_PosToCat.GetData();
// 				alert("응답데이터 : " + self.document.payForm.m_PosToCat.GetData());
			}else if(ret == -2) reqcard(cat_port, goods_amt, quota_interest);
			$('form[name=payForm] > object').remove();  
			return _result;
		}

		
		// 현금영수증 출력
		$('.div-receipt .btn-receipt').on('click', function(){
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
	 			var result = taxPoint($('.receipt-box .receipt-flag').data('value'), $('.receipt-box .issue-no').val(), $('.receipt-box .receipt-price').val().replace(/,/gi, ''));
				if(result){
					_formData.append('result', result);
					$.pb.ajaxUploadForm('/adminSec/insertReceipt.do', _formData, function(result) {
	 					if(result == "1") {
	 						createTable();
	 						$('.pb-popup-close').click();
	 					} else alert(decodeURIComponent(result));
	 				}, '${sessionScope.loginProcess}');
				}
			}else $('form[name=payForm] > object').remove();
		});
		
		function taxPoint(receipt_flag, issue_no, amt){
			var _result = "";
// 			var s_buf = "D3" + FS + receipt_flag + FS  + "@" + FS + issue_no + FS + FS + FS + amt + FS + FS + FS + FS + "DJ7098510001" + FS;
			var s_buf = "D3" + FS + receipt_flag + FS  + "@" + FS + issue_no + FS + FS + FS + amt + FS + FS + FS + FS + "DJ7098054001" + FS;
			ret = self.document.payForm.m_PosToCat.ReqToCat(1, 9600, s_buf); //포트, 통신속도, 데이터
			if(ret == 1)  {
				_result = self.document.payForm.m_PosToCat.GetData();
// 				alert("응답데이터 : " + self.document.payForm.m_PosToCat.GetData());
			} else  {
				// 현금영수증은 단말기에서 종료버튼 없이 바로 결제 되어서 요청실패시 재요청
				if(ret == -2) taxPoint(issue_no, amt);
			}
			$('form[name=payForm] > object').remove();
			return _result;
		}
		
		
		//신용카드 결제 취소
		function cancelCard(quota, amount, appNo, appDate, catId) {
			var _result = "";
			var s_buf = "D2" + FS + FS + FS + quota + FS + FS + FS + amount + FS + appNo + FS + appDate + FS + +"DJ"+catId + FS + FS;
			ret = self.document.payForm.m_PosToCat.ReqToCat(1, 9600, s_buf); //포트, 통신속도, 데이터
			if(ret == 1) _result = self.document.payForm.m_PosToCat.GetData();
			else if(ret == -2) ret = self.document.payForm.m_PosToCat.ReqToCat(1, 9600, s_buf); //포트, 통신속도, 데이터
			$('form[name=payForm] > object').remove();
			return _result;
		}
		
		function cancelReceipt(type, issueNo, amount, appDate, appNo, catId) {
			var _result = "";
			var s_buf = "D4" + FS + type + FS + "@" + FS + issueNo + FS + FS + FS + amount + FS + "1" + FS + appDate + FS + appNo + FS + "DJ" + catId + FS;
			ret = self.document.payForm.m_PosToCat.ReqToCat(1, 9600, s_buf); //포트, 통신속도, 데이터
			if(ret == 1) _result = self.document.payForm.m_PosToCat.GetData();
			else if(ret == -2) ret = self.document.payForm.m_PosToCat.ReqToCat(1, 9600, s_buf); //포트, 통신속도, 데이터
			$('form[name=payForm] > object').remove();
			return _result;
		}
		
		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<style>
	.contents-body-wrap .event-info-box { box-sizing:border-box; position:relative; }
	.popup-table tbody .blue { background:#a7e3fd; }
	.popup-table tbody .orange { background:#fdce0c; }
</style>
<div class="pb-right-popup-wrap">
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
				<input type="text" class="form-text price discount-price">
			</div>
			<div class="div-pay">
				<div class="text">할인 후 금액</div>
				<input type="text" class="form-text price discount-remaining-price" disabled>
			</div>
			<div class="div-pay">
				<div class="text">결제할 금액(직접입력)</div>
				<input type="text" class="form-text price pay-price">
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
		<div style="position:absolute; right:399px; background:linear-gradient(to bottom, #FFFFFF, #EBEDEE); top:29px; padding:6px 25px; border:1px solid #707070; font-size:16px; z-index:1">할인정보</div>
		<select class="form-select discount" style="width:400px; position:absolute; right:0; height:38px; font-size:16px; font-weight:500; padding:0px 5px;"></select>
	</div>
	
	<div class="company-price-box">
		<table class="company-price-table">
			<colgroup>
				<col width="12%"/>
				<col width="8%"/>
				<col width="*"/>
				<col width="4%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
				<col width="8%"/>
			</colgroup>
			<thead>
				<tr><td>사업자</td><td>총 금액</td><td>할인명</td><td>할인률</td><td>할인금액</td><td>할인 후 금액</td><td>현금결제</td><td>카드결제</td><td>남은금액</td><td>현금/카드</td><td>현금영수증</td></tr>
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
