<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		// 세션없을시 추가
		if(!'${sessionScope.loginProcess}') $(location).attr('href', '/');
		var _param = JSON.parse('${data}');

		$('input[type=radio][name=vatFlag]').siteRadio({ addText:['여', '부'], fontSize:'16px', defaultValue:1 });
		$('input[type=text][name=price]').targetMoney();
		
		var _binso = "";
		$.pb.ajaxCallHandler('/adminSec/selectCMName.do', {	eventNo : _param.pk }, function(data) {
			$('input[name=orderName]').val(data.cmName.CM_NAME);
			$('.binso').text('[' + data.cmName.APPELLATION + '] 주문내역');
			_binso = data.cmName.APPELLATION;
		});
		
		
		//주문 내역 보기
		var _orderTotalPrice = 0;
		var fnOrderList = function() {
			$('.order-box tbody').html("");
			$.pb.ajaxCallHandler('/adminSec/selectOrderTotalList.do', {	eventNo : _param.pk }, function(data) {
				_orderTotalPrice = 0; 
				$.each(data.list, function(idx) {
					var _tr = $('<tr class="order">');
					var _this  = this
					_tr.data(this);
					_tr.append('<td>'+(this.ITEM_NAME ? this.ITEM_NAME : this.SET_NAME)+'</td>');
					_tr.append('<td>'+(this.UNIT ? this.UNIT : '1세트')+'</div>');
					_tr.append('<td class="pm-box"><input type="text" name="cnt" value="0" maxlength="3"></td>');
					_tr.find('input[name=cnt]').plusMinusBox(
		 				function(){
		 					_tr.find('.total-price').text($.pb.targetMoney(_this.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1 + (_this.ORDER_CNT ? _this.ORDER_CNT : 0)*1))+"원");
		 					calTotalPrice();
		 					if(_tr.find('input[name=cnt]').val() == 0) _tr.removeClass('ac');
		 				},function() {
		 					_tr.find('.total-price').text($.pb.targetMoney(_this.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1 + (_this.ORDER_CNT ? _this.ORDER_CNT : 0)*1))+"원")
		 					calTotalPrice();
		 					if(_tr.find('input[name=cnt]').val() > 0) _tr.addClass('ac');
		 				},function() {
		 					_tr.find('.total-price').text($.pb.targetMoney(_this.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1 + (_this.ORDER_CNT ? _this.ORDER_CNT : 0)*1))+"원")
		 					calTotalPrice();
		 					if(_tr.find('input[name=cnt]').val() == 0) _tr.removeClass('ac');
		 					if(_tr.find('input[name=cnt]').val() > 0) _tr.addClass('ac');
		 				}, 'gray'
		 			);
					
					_tr.append('<td class="order-cnt">'+(this.ORDER_CNT ? this.ORDER_CNT : 0)+'</td>');
					_tr.append('<td>'+this.CLASSIFICATION_NAME+'</td>');
					_tr.append('<td class="r">'+$.pb.targetMoney(this.VAT_PRICE)+'원</td>');
					_tr.append('<td class="r total-price">'+$.pb.targetMoney(this.ORDER_PRICE)+'원</td>');
					_orderTotalPrice += (this.ORDER_PRICE ? this.ORDER_PRICE : 0);
					$('.order-box tbody').append(_tr);
				});
				$('.order-info .total-price').text($.pb.targetMoney(_orderTotalPrice) + '원');
			});
		};fnOrderList();
		
		var createPartner = function() {
			$('.company-box').html("");
			$.pb.ajaxCallHandler('/adminSec/selectFuneralItemPartner.do', {	funeralNo : '${sessionScope.loginProcess.FUNERAL_NO}' }, function(data) {
				var _partner = [];
				$.each(data.list, function(idx) {
					var _div = $('<div class="company">'+this.NAME+'</div>');
					_div.data(this);
					_div.on('click', function(){
						$(this).addClass('ac').siblings('div').removeClass('ac');
						createClassification(_div.data('PARTNER_NO'));
					});
					$('.company-box').append(_div);
					
					//임의상품등록 사업자 추가
					_partner.push(this.NAME);
					$('.popup-partner-box').append('<input type="radio" name="partnerNo" value="'+this.PARTNER_NO+'">');
					
					
					$('.partner-chk-box').append('<input type="checkbox" name="partnerNo" value="'+this.PARTNER_NO+'">');
					
				});
				var _div_set = $('<div class="company">세트상품</div>');
				$('.company-box').append(_div_set);
				_div_set.on('click', function(){
					$(this).addClass('ac').siblings('div').removeClass('ac');
					createClassification();
				});
				$('.company-box').find('.company:eq(0)').addClass('ac').click();
				
				$('input[type=radio][name=partnerNo]').pbRadiobox({ addText:_partner });
				$('input[type=radio][name=partnerNo]').on('click', function() {
					createClassification($(this).val(), 'randomItem');
				});
				$('input[type=radio][name=partnerNo]:eq(0)').click();
				
				
				$('input[type=checkbox]').pbCheckbox({ addText:_partner })
				;
				
			});
		};createPartner();
		
		var createClassification = function(_partnerNo, flag) {
			$.pb.ajaxCallHandler('/adminSec/selectFuneralClassificationList.do', {partnerNo : _partnerNo}, function(data) {
				if(!flag) {
					$('.classification-box').html("");
					$('.classification-box').append('<div>전체분류</div>');
					$.each(data.list, function(idx) {
						var _div = $('<div>'+this.NAME+'</div>');
						_div.data(this);
						$('.classification-box').append(_div);
					});
					$('.classification-box div').on('click', function() {
						$(this).addClass('ac').siblings('div').removeClass('ac');
						createItem($(this).data('CLASSIFICATION_NO'), _partnerNo);
					});
					$('.classification-box div:eq(0)').addClass('ac').click();
				}
				else {
					//임의상품등록 분류부분 추가
					$('select[name=classification]').html("");
					$.each(data.list, function(idx) {
						$('select[name=classification]').append('<option value="'+this.CLASSIFICATION_NO+'">'+this.NAME+'</option>')
					});
				}
			});
		};
		
		var createItem = function(_classificationNo, _partnerNo) {
			$('.item-box').html("");
			if(_partnerNo){
				$.pb.ajaxCallHandler('/adminSec/selectFuneralItemList.do', {classificationNo : _classificationNo, partnerNo : _partnerNo, order : 'IDX*1, ITEM_NO DESC' }, function(data) {
					$.each(data.list, function(idx) {
						var _div = $('<div class="item">');
						_div.data(this);
						_div.append('<div class="name">'+this.ITEM_NAME+'</div>');
						_div.append('<div>'+this.UNIT+'</div>');
						_div.append('<div>'+$.pb.targetMoney(this.VAT_PRICE)+'원</div>');
						$('.item-box').append(_div);
						_div.on('click', function(){
							addSetItem(_div.data());
						});
					});
				});
			}else{
				$.pb.ajaxCallHandler('/adminSec/selectSetList.do', {funeralNo : '${sessionScope.loginProcess.FUNERAL_NO}', order: 'SET_NO DESC'}, function(data) {
					$.each(data.list, function(idx) {
						var _div = $('<div class="item">');
						_div.data(this);
						_div.append('<div class="name">'+this.SET_NAME+'</div>');
						_div.append('<div>1세트</div>');
						_div.append('<div>'+$.pb.targetMoney(this.VAT_PRICE)+'원</div>');
						$('.item-box').append(_div);
						_div.on('click', function(){
							$.pb.ajaxCallHandler('/adminSec/selectSetItemList.do', {setNo : _div.data('SET_NO')}, function(data) {
								$.each(data.list, function(idx) {
									addSetItem(this);
								});
							});
						});
					});
				});
			};
		};
		
		var addSetItem = function(_data) {
			var _tr = $('<tr class="order">');
			_tr.data(_data);
			_tr.append('<td>'+(_data.ITEM_NAME ? _data.ITEM_NAME : _data.SET_NAME)+'</td>');
			_tr.append('<td>'+(_data.UNIT ? _data.UNIT : '1세트')+'</td>');
			_tr.append('<td class="pm-box"><input type="text" name="cnt" value="10" maxlength="3"></td>');
			_tr.find('input[name=cnt]').plusMinusBox(
				function(){
 					_tr.find('.total-price').text($.pb.targetMoney(_data.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1 + _tr.find('.order-cnt').text()*1))+"원");
 					calTotalPrice();
 					if(_tr.find('input[name=cnt]').val() == 0) _tr.removeClass('ac');
 				},function(){ 
 					_tr.find('.total-price').text($.pb.targetMoney(_data.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1 + _tr.find('.order-cnt').text()*1))+"원")
 					calTotalPrice();
 					if(_tr.find('input[name=cnt]').val() > 0) _tr.addClass('ac');
 				},function(){
 					_tr.find('.total-price').text($.pb.targetMoney(_data.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1 + _tr.find('.order-cnt').text()*1))+"원")
 					calTotalPrice();
 					if(_tr.find('input[name=cnt]').val() == 0) _tr.removeClass('ac');
 					if(_tr.find('input[name=cnt]').val() > 0) _tr.addClass('ac');
 				}, 'gray'
 			);
			_tr.append('<td class="order-cnt">0</td>');
			_tr.append('<td>'+_data.CLASSIFICATION_NAME+'</td>');
			_tr.append('<td class="r">'+$.pb.targetMoney(_data.VAT_PRICE)+'원</td>');
			_tr.append('<td class="r total-price">'+$.pb.targetMoney(_data.VAT_PRICE)+'원</td>');
			
			var _tmp = 0;
			if($('.order-box tbody tr').length == 0) {
				_tr.addClass('ac').find('input[name=cnt]').val(_data.CNT ? _data.CNT : 1);
				$('.order-box tbody').append(_tr);
				calTotalPrice();
			}
			else {
				$('.order-box tbody tr').each(function() {
					if($(this).data('ITEM_NO') == _data.ITEM_NO) {
						_tmp = 0;
						$(this).find('input[name=cnt]').val(parseInt($(this).find('input[name=cnt]').val()) + (_data.CNT ? _data.CNT : 1));
						$(this).find('.total-price').text($.pb.targetMoney(_data.VAT_PRICE * ($(this).find('input[name=cnt]').val()*1 + $(this).find('.order-cnt').text()*1))+"원")
						if($(this).find('input[name=cnt]').val() > 0) $(this).addClass('ac');
						$('.order-box tbody tr:eq(0)').before($(this));
						calTotalPrice();
						return false;
					} else _tmp = 1;
				});
				if(_tmp != 0) {
					_tr.addClass('ac').find('input[name=cnt]').val(_data.CNT ? _data.CNT : 1);
					_tr.find('.total-price').text($.pb.targetMoney(_data.VAT_PRICE * (_data.CNT ? _data.CNT : 1)) + "원")
					$('.order-box tbody tr:eq(0)').before(_tr);
					calTotalPrice();
				}
			}
		};
		
		var calTotalPrice = function(){
			var _price = 0;
			if($('.order-box tbody tr').length > 0) {
				$('.order-box tbody tr').each(function() {
					_price += ($(this).find('input[name=cnt]').val()*$(this).data('VAT_PRICE'));
				});
				$('.order-price').text($.pb.targetMoney(_price) + "원");
				if(_price > 0) $('.event-info-btn-wrap .register').addClass("ac");
				else $('.event-info-btn-wrap .register').removeClass("ac");
			}else{
				$('.order-price').text("0원");
			}
		};
		
		// 임의상품등록
		$('.btn-info .item-register').on('click', function() {
			$('.pb-right-popup-wrap.item').openLayerPopup({}, function(_thisLayer) {
				layerInit(_thisLayer);
			});
		});
		$('.pb-right-popup-wrap .top-button.register').on('click', function() {
			if(!necessaryChecked($('#popupDataForm'))) {
				var _formData = new FormData($('#popupDataForm')[0]);
				_formData.append('eventNo', _param.pk);
				$.pb.ajaxUploadForm('/adminSec/insertEventRandomItem.do', _formData, function(result) {
	 				if(result != 0) {
	 					var _tr = $('<tr class="order">');
						var _this  = result.list
						_tr.data(_this);
						_tr.append('<td>'+(_this.ITEM_NAME ? _this.ITEM_NAME : _this.SET_NAME)+'</td>');
						_tr.append('<td>'+(_this.UNIT ? _this.UNIT : '1세트')+'</div>');
						_tr.append('<td class="pm-box"><input type="text" name="cnt" value="0" maxlength="3"></td>');
						_tr.find('input[name=cnt]').plusMinusBox(
			 				function(){
			 					_tr.find('.total-price').text($.pb.targetMoney(_this.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1))+"원")
			 					calTotalPrice();
			 					if(_tr.find('input[name=cnt]').val() == 0) _tr.removeClass('ac');
			 				},function() {
			 					_tr.find('.total-price').text($.pb.targetMoney(_this.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1))+"원")
			 					calTotalPrice();
			 					if(_tr.find('input[name=cnt]').val() > 0) _tr.addClass('ac');
			 				},function() {
			 					_tr.find('.total-price').text($.pb.targetMoney(_this.VAT_PRICE*(_tr.find('input[name=cnt]').val()*1))+"원")
			 					calTotalPrice();
			 					if(_tr.find('input[name=cnt]').val() == 0) _tr.removeClass('ac');
			 					if(_tr.find('input[name=cnt]').val() > 0) _tr.addClass('ac');
			 				}, 'gray'
			 			);
						
						_tr.find('input[name=cnt]').val(1);
					 	_tr.addClass('ac');
						 
						_tr.append('<td class="order-cnt">0</td>');
						_tr.append('<td>'+_this.CLASSIFICATION_NAME+'</td>');
						_tr.append('<td class="r">'+$.pb.targetMoney(_this.VAT_PRICE)+'원</td>');
						_tr.append('<td class="r total-price">'+$.pb.targetMoney(_this.VAT_PRICE)+'원</td>');
						$('.order-box tbody').prepend(_tr);
						
						calTotalPrice();
						$('.pb-popup-close').click();
	 				} else alert('저장 실패 관리자에게 문의하세요');
	 			}, '${sessionScope.loginProcess}');
			}
		});
		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
		
		// 전체 주문내역 출력
		$('.btn-info .total-order-list').on('click', function() {
			var agent = navigator.userAgent.toLowerCase();
			if((navigator.appName == 'Netscape' && agent.indexOf('trident') == -1) && (agent.indexOf("msie") == -1)) return alert("인터넷익스플로러 브라우저로 실행해 주세요.");
			$('.btn-info .total-order-list').prop('disabled', true);
			$.pb.ajaxCallHandler('/adminSec/selectEventFuneralInfoList.do', { eventNo : _param.pk, funeralNo : '${sessionScope.loginProcess.FUNERAL_NO}' }, function(data) {
				var _data = data.funeralInfoList[0];
				var _str = "", _totalPrice = 0;
				var transdata	= "";
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
				$('.order-box tbody tr').each(function() {
					$(this).data("CNT", $(this).find('.order-cnt').text())
					_str += FnOrderTrans($(this).data());
					_totalPrice += $(this).data('VAT_PRICE')*$(this).find('.order-cnt').text()*1;
				});
	 		    transdata += _str;
	 		    transdata += "------------------------------------------------ \n";
	 		    var _totalLen = 0, _totalStr = "";
	 		   	var _totalPrice = $.pb.targetMoney(_totalPrice);
	 		   	for (var i = 0; i < _totalPrice.length; i++) { _totalLen += 1; }
		    	for(var i = 0; i < (40 - _totalLen); i++) { _totalStr += " "; }
		    	_totalStr += $.pb.targetMoney(_totalPrice);
	 			transdata += "합계금액"+_totalStr+"\n";
	 			transdata += "------------------------------------------------\n";
	 			transdata += "거 래 일 : "+new Date().format('yyyy년 MM월 dd일');

				$('object').remove();
				var _payObj = $('<object>');
				_payObj.attr('classid', 'CLSID:505A0E24-D6BB-4B0B-A46D-92F3D558AF21');
				_payObj.attr('codebase', '/resources/js/NicePrintV100.cab#version=1,0,0,1');
				_payObj.attr('id', 'm_print');
				$('#body').append(_payObj);
				//ret가 1이면 정상
				if(_str.length > 0) ret = self.document.m_print.NicePrint(1, 9600, transdata, chkStrLength(transdata)); //포트, 통신속도, 데이터, 데이터 길이
				$('object').remove();
				
			});
			$('.btn-info .total-order-list').prop('disabled', false);
		});
		
		// 현재 주문 취소
		$('.btn-info .reset').on('click', function() {
			$('.order-box tbody tr').each(function() {
				$(this).find('input[name=cnt]').val(0);
				$(this).find('.total-price').text($.pb.targetMoney($(this).data('VAT_PRICE')*$(this).data('ORDER_CNT'))+"원");
				$(this).removeClass('ac');
			});
			$('.order-price').text("0원");
			$('.event-info-btn-wrap .register').removeClass("ac");
		});
		
		// 전표 재출력
		$('.btn-info .re-print').on('click', function() {
			var agent = navigator.userAgent.toLowerCase();
			if((navigator.appName == 'Netscape' && agent.indexOf('trident') == -1) && (agent.indexOf("msie") == -1)) return alert("인터넷익스플로러 브라우저로 실행해 주세요.");
			
			$.pb.ajaxCallHandler('/adminSec/selectEventOrderRePrintList.do', { eventNo : _param.pk, flag:'order', funeralNo : '${sessionScope.loginProcess.FUNERAL_NO}' }, function(data) {
				$('object').remove();
				var _payObj = $('<object>');
				_payObj.attr('classid', 'CLSID:505A0E24-D6BB-4B0B-A46D-92F3D558AF21');
				_payObj.attr('codebase', '/resources/js/NicePrintV100.cab#version=1,0,0,1');
				_payObj.attr('id', 'm_print');
				$('#body').append(_payObj);
				
				var _data = data.funeralInfoList[0];
				var _str = "", _totalPrice = 0;
				$.each(data.list, function(idx) {
					_str += FnOrderTrans(this);
					_totalPrice += this.VAT_PRICE * this.CNT;
				});
	 		   	var _totalPrice = $.pb.targetMoney(_totalPrice);
				
				// transdata는 단말기
				// prntdata는 주방용 프린트
				var transdata = "";
		    	transdata += "\n"+_data.FUNERAL_NAME+"\n\n";
	 			transdata += "주소 : "+_data.ADDRESS+" "+(_data.ADDRESS_DETAIL ? _data.ADDRESS_DETAIL : "")+" \n";
	 			transdata += "사업자번호 : "+_data.BUS_NO+" \n";
	 			transdata += "대표자 : "+_data.BOSS_NAME+" \n";
	 			transdata += "전화 : "+_data.CONTACT+" \n";
				transdata += '\x1B' + '\x21' + '\x30' + "\n\          재출력\n" + '\x1B' + '\x21' + '\x00'; //가로세로 2배
	 			transdata += "\n                    * 고 객 용 *\n\n";
	 			transdata += "현재날짜: "+new Date().format('yyyy년 MM월 dd일 E hh시 mm분')+" \n";
	 			transdata += "------------------------------------------------ \n"; //48개
	 			transdata += "상품명                    단가   수량   금액(원)\n";
	 		    transdata += "------------------------------------------------ \n";
	 		    transdata += _str;
	 		    transdata += "------------------------------------------------\n";
	 		    var _totalLen = 0, _totalStr = "";
	 		   	for (var i = 0; i < _totalPrice.toString().length; i++) { _totalLen += 1; }
		    	for(var i = 0; i < (40 - _totalLen); i++) { _totalStr += " "; }
		    	_totalStr += $.pb.targetMoney(_totalPrice);
	 			transdata += "합계금액"+_totalStr+"\n";
	 		    transdata += "------------------------------------------------\n";
	 			transdata += "거 래 일 : "+new Date().format('yyyy년 MM월 dd일');
	 			
				//ret가 1이면 정상
				if(_str.length > 0) ret = self.document.m_print.NicePrint(1, 9600, transdata, chkStrLength(transdata)); //포트, 통신속도, 데이터, 데이터 길이
				
				$.each(data.partner, function(idx) {
		 			var _strP = "", _totalPrice = 0;
					var _this = this;
					
					$.each(data.list, function(idx) {
		 		    	_strP += FnOrderPrint(this, _this.PARTNER_FLAG);
		 		    	if(_this.PARTNER_FLAG == this.PARTNER_FLAG) _totalPrice += this.VAT_PRICE * this.CNT;
					});
					
					var printdata = "";
					printdata += "\n"+_data.FUNERAL_NAME+"\n\n";
					printdata += "주소 : "+_data.ADDRESS+" "+(_data.ADDRESS_DETAIL ? _data.ADDRESS_DETAIL : "")+" \n";
					printdata += "사업자번호 : "+_data.BUS_NO+" \n";
			 		printdata += "대표자 : "+_data.BOSS_NAME+" \n";
			 		printdata += "전화 : "+_data.CONTACT+" \n";

			 		printdata += '\x1B' + '\x21' + '\x30' + "\n\        재출력\n" + '\x1B' + '\x21' + '\x00'; //가로세로 2배
			 		
			 		printdata += "\n                * 고 객 용 *\n\n";
			 		printdata += "현재날짜: "+new Date().format('yyyy년 MM월 dd일 E hh시mm분');
			 		printdata += "------------------------------------------ \n"; //40개
			 		printdata += "상품명              단가   수량   금액(원)\n";
			 		printdata += "------------------------------------------ \n";
		 		    printdata += _strP;
		 			printdata += "------------------------------------------\n";
		 		    var _totalLenP = 0, _totalStrP = "";
		 		   	for (var i = 0; i < _totalPrice.toString().length; i++) { _totalLenP += 1; }
			    	for(var i = 0; i < (33 - _totalLenP); i++) { _totalStrP += " "; }
			    	_totalStrP += $.pb.targetMoney(_totalPrice);
			    	printdata += "합계금액"+_totalStrP+"\n";
			    	printdata += "------------------------------------------\n";
		 		    printdata += "거 래 일 : "+new Date().format('yyyy년 MM월 dd일');
		 		    if(_strP.length > 0) retP = self.document.m_print.NicePrint(_this.PARTNER_FLAG, 9600, printdata, chkStrLength(printdata)); //포트, 통신속도, 데이터, 데이터 길이
				});
	 		    
				$('object').remove();
			});
		});
		
		
		// 주문완료
		$('.event-info-btn-box .register').on('click', function() {
			var agent = navigator.userAgent.toLowerCase();
			if((navigator.appName == 'Netscape' && agent.indexOf('trident') == -1) && (agent.indexOf("msie") == -1)) return alert("인터넷익스플로러 브라우저로 실행해 주세요.");
			
			if($('.order-box tbody tr').length < 1) return alert("상품을 주문해 주세요.");
			else {
				var _chk = true;
				$('.order-box tbody tr').each(function() {
					if($(this).find('input[name=cnt]').val() > 0) return _chk = false;
				});
				if(_chk) return alert("상품을 주문해 주세요.");
			}

			$('.ajax-loading').show();
			$.pb.ajaxCallHandler('/adminSec/selectEventFuneralInfoList.do', { eventNo : _param.pk, funeralNo : '${sessionScope.loginProcess.FUNERAL_NO}' }, function(data) {
				$('object').remove();
				var _payObj = $('<object>');
				_payObj.attr('classid', 'CLSID:505A0E24-D6BB-4B0B-A46D-92F3D558AF21');
				_payObj.attr('codebase', '/resources/js/NicePrintV100.cab#version=1,0,0,1');
				_payObj.attr('id', 'm_print');
				$('#body').append(_payObj);
				
				
				var _data = data.funeralInfoList[0];
				var _orderList = [], _stockList = [], _totalPrice = 0;
 		    	var _str = "";
				$('.order-box tbody tr').each(function() {
					if($(this).find('input[name=cnt]').val() > 0) {
						var $list = {
								eventNo : _param.pk,
								itemNo : $(this).data('ITEM_NO') ? $(this).data('ITEM_NO') : 0,
								randomItemNo : $(this).data('RANDOM_ITEM_NO') ? $(this).data('RANDOM_ITEM_NO') : 0,
								cnt : $(this).find('input[name=cnt]').val(),
								orderName : $('input[name=orderName]').val(),
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
						$(this).data("CNT", $(this).find('input[name=cnt]').val())
						_str += FnOrderTrans($(this).data());
						_totalPrice += $(this).data('VAT_PRICE')*$(this).find('input[name=cnt]').val();
					}
				});
				
				var printTxt = function(txt01) {
					var transdata = "";
					transdata += "\n"+_data.FUNERAL_NAME+"\n\n";
		 			transdata += "주소 : "+_data.ADDRESS+" "+(_data.ADDRESS_DETAIL ? _data.ADDRESS_DETAIL : "")+" \n";
		 			transdata += "사업자번호 : "+_data.BUS_NO+" \n";
		 			transdata += "대표자 : "+_data.BOSS_NAME+" \n";
		 			transdata += "전화 : "+_data.CONTACT+" \n";
		 			transdata += "\n                  * "+txt01+" *\n\n";
		 			transdata += "빈소명: "+_binso+" \n";
		 			transdata += "현재날짜: "+new Date().format('yyyy년 MM월 dd일 E hh시 mm분')+" \n";
		 			transdata += "------------------------------------------------ \n";
		 			transdata += "상품명                    단가   수량   금액(원)\n";
		 		    transdata += "------------------------------------------------ \n";
		 		    transdata += _str;
		 			transdata += "------------------------------------------------ \n";
		 		    var _totalLen = 0, _totalStr = "";
		 		   	var _tPrice = $.pb.targetMoney(_totalPrice);
		 		   	for (var i = 0; i < _tPrice.length; i++) { _totalLen += 1; }
			    	for(var i = 0; i < (40 - _totalLen); i++) { _totalStr += " "; }
			    	_totalStr += $.pb.targetMoney(_tPrice);
		 			transdata += "합계금액"+_totalStr+"\n";
		 		    transdata += "------------------------------------------------ \n";
		 			transdata += "주문자 : "+$('input[name=orderName]').val()+ "\n"
		 			transdata += "------------------------------------------------ \n";
		 			transdata += "\n서명\n\n\n"
		 			transdata += "------------------------------------------------ \n";
		 			transdata += "거 래 일 : "+new Date().format('yyyy년 MM월 dd일');
					ret = self.document.m_print.NicePrint(1, 9600, transdata, chkStrLength(transdata)); //포트, 통신속도, 데이터, 데이터 길이
				};
				printTxt("고 객 용", 1);
				printTxt("가 맹 용", 1);

				
				$.each(data.partner, function(idx) {
		 			var _strP = "", _totalPrice = 0;
					var _this = this;
					$('.order-box tbody tr').each(function() {
						if($(this).find('input[name=cnt]').val() > 0 && _this.PARTNER_FLAG == $(this).data('PARTNER_FLAG')) {
							$(this).data("CNT", $(this).find('input[name=cnt]').val())
							_strP += FnOrderPrint($(this).data(), _this.PARTNER_FLAG);
			 		    	if(_this.PARTNER_FLAG == $(this).data('PARTNER_FLAG')) _totalPrice += $(this).data('VAT_PRICE') * $(this).find('input[name=cnt]').val();
						};
					});
					
					var printTxtP = function(txt01) {
						var printdata = "";
						printdata += "\n"+_data.FUNERAL_NAME+"\n\n";
						printdata += "주소 : "+_data.ADDRESS+" "+(_data.ADDRESS_DETAIL ? _data.ADDRESS_DETAIL : "")+" \n";
						printdata += "사업자번호 : "+_data.BUS_NO+" \n";
						printdata += "대표자 : "+_data.BOSS_NAME+" \n";
			 			printdata += "전화 : "+_data.CONTACT+" \n";
			 			printdata += "\n                  * "+txt01+" *\n\n";
			 			printdata += "빈소명: "+_binso+" \n";
				 		printdata += "현재날짜: "+new Date().format('yyyy년 MM월 dd일 E hh시mm분');
				 		printdata += "------------------------------------------\n\n"; //40개
				 		printdata += "상품명              단가   수량   금액(원)\n";
				 		printdata += "------------------------------------------\n\n";
			 		    printdata += _strP;
			 			printdata += "------------------------------------------\n\n";
			 		    var _totalLenP = 0, _totalStrP = "";
			 		   	var _tPrice = $.pb.targetMoney(_totalPrice);
			 		   	for (var i = 0; i < _totalPrice.toString().length; i++) { _totalLenP += 1; }
				    	for(var i = 0; i < (33 - _totalLenP); i++) { _totalStrP += " "; }
				    	_totalStrP += $.pb.targetMoney(_totalPrice);
				    	printdata += "합계금액"+_totalStrP+"\n";
				    	printdata += "------------------------------------------\n";
				    	printdata += "주문자 : "+$('input[name=orderName]').val()+ "\n"
				    	printdata += "------------------------------------------\n";
				    	printdata += "\n서명\n\n\n"
				    	printdata += "------------------------------------------\n";
			 		    printdata += "거 래 일 : "+new Date().format('yyyy년 MM월 dd일');
			 		   if(_strP.length > 0) ret = self.document.m_print.NicePrint(_this.PARTNER_FLAG, 9600, printdata, chkStrLength(printdata)); //포트, 통신속도, 데이터, 데이터 길이
					}
					printTxtP("가 맹 용", _this.PARTNER_FLAG);
				});
				$('object').remove();
				
				var _formData = new FormData($('#eventSubForm')[0]);
				_formData.append('eventNo', _param.pk);
				_formData.append('stockDt', new Date().format('yyyyMMdd'));
				_formData.append('funeralNo', '${sessionScope.loginProcess.FUNERAL_NO}');
				_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
	 			_formData.append('orderList', JSON.stringify(_orderList));
	 			_formData.append('stockList', JSON.stringify(_stockList));
	 			$.pb.ajaxUploadForm('/adminSec/insertEventOrder.do', _formData, function(result) {
	 				if(result != 0) {
						$(location).attr('href', '/' + $(location)[0].pathname.split('/')[1].slice(0,6));
	 				} else alert('저장 실패 관리자에게 문의하세요');
	 			}, '${sessionScope.loginProcess}');
			});
		});
	});
</script>
<div class="event-info-box or acc" style="width:390px; padding:20px 16px 0px 0px;">
	<div class="top-box">사업자 분류</div>
	<div class="mid-wrap" style="height: calc(100% - 36px);"> 
		<div class="mid-box company-box"></div>
		<div class="list-wrap">
			<div class="list-box classification-box">
			</div>
		</div>
	</div>
</div>

<div class="event-info-box or acc" style="width:390px; padding:20px 16px 0px 0px;">
	<div class="top-box">주문 물품표</div>
	<div class="mid-box item-mid">
		<div style="width:54.4%">상품</div>
		<div style="width:15.1%">단위</div>
		<div style="width:35.8%">단가</div>
	</div>
	<div class="list-wrap item-wrap" style="height: calc(100% - 68px);">
		<div class="list-box item-box">
		</div>
	</div>
</div>

<div class="event-info-box or acc" style="width:calc(100% - 780px); padding-top: 20px;">
	<div class="top-box binso"></div>
	<div class="mid-box">
		<div style="width:23.5%">상품</div>
		<div style="width:8.2%">단위</div>
		<div style="width:13%">주문</div>
		<div style="width:8.2%">총 수량</div>
		<div style="width:21.3%">분류</div>
		<div style="width:11.1%">단가</div>
		<div style="width:14.7%">금액</div>
	</div>
	<div class="list-wrap order-wrap" style="height: calc(100% - 68px);">
		<table class="order-box">
			<colgroup>
				<col width="23.9%"/>
				<col width="8.3%"/>
				<col width="13.3%"/>
				<col width="8.3%"/>
				<col width="21.8%"/>
				<col width="11.4%"/>
				<col width="13%"/>
			</colgroup>
			<tbody></tbody>
		</table>
	</div>
</div>


<!-- <div class="event-info-box or partner-chk-box" style="width: 780px; padding-top: 20px;"> -->
<!-- </div> -->

<div class="event-info-box or" style="width: 780px; padding-top: 20px;">
</div>

<div class="event-info-box or" style="width:calc(100% - 780px); padding-top: 20px;">
	<div class="event-info-btn-box">
		<div class="event-info-btn-wrap">
			<table class="order-info">
				<tbody>
					<tr>
						<td class="title">주문자</td>
						<td><input type="text" class="form-text" name="orderName" placeholder="직접입력"/></td>
					</tr>
					<tr>
						<td class="title">주문금액</td>
						<td class="txt order-price">0원</td>
					</tr>
					<tr>
						<td class="title-price">총금액</td>
						<td class="txt total-price"></td>
					</tr>
				</tbody>
			</table>
			<button type="button" class="register">주문완료</button>
			<div class="btn-info">
				<div>
					<button type="button" class="item-register">임의상품등록</button>
					<button type="button" class="total-order-list">전체 주문내역 출력</button>
				</div>
				<div>
					<button type="button" class="reset">현재 주문 취소</button>
					<button type="button" class="re-print">전표 재출력</button>
				</div>
			</div>
		</div>
	</div>
</div>


<form id="popupDataForm">
<div class="pb-right-popup-wrap item">
	<div class="pb-popup-title">임의상품 등록</div>
	<div style="font-size: 14px; position: absolute; top: 67px; left: 22px; color: #093687;">상품목록에 없는 상품을 개별로 등록할 수 있습니다.</div>
	<span class="pb-popup-close"></span>
	<div class="pb-popup-body">
		<div class="popup-body-top">
			<div class="top-title">신규등록</div>
			<div class="top-button-wrap">
				<button type="button" class="top-button register">저장</button>
				<button type="button" class="top-button pb-popup-close">취소</button>
				<button type="button" class="top-button delete">삭제</button>
			</div>
		</div>
		<div class="pb-popup-form">
			<div class="form-box-st-01">
				<div class="row-box popup-partner-box">
					<label class="title">구분</label>
				</div>
			</div>
			<div class="form-box-st-01 half">
				<div class="row-box">
					<label class="title">* 분류</label>
					<select class="form-select" name="classification"></select>
				</div>
			</div>
			<div class="form-box-st-01 half">
				<div class="row-box">
					<label class="title">* 상품명</label>
					<input type="text" class="form-text necessary" name="name" placeholder="상품명을 입력하세요." maxlength="20"/>
				</div>
			</div>
			<div class="form-box-st-01 half">
				<div class="row-box">
					<label class="title">* 단위</label>
					<input type="text" class="form-text necessary" name="unit" placeholder="품목의 단위를 입력하세요." maxlength="20"/>
				</div>
			</div>
			<div class="form-box-st-01 half">
				<div class="row-box">
					<label class="title">* 단가</label>
					<input type="text" class="form-text necessary" name="price" placeholder="품목의 단가를 입력하세요." maxlength="12"/>
				</div>
			</div>
			<div class="form-box-st-01 half">
				<div class="row-box">
					<label class="title">부가세 여부</label>
					<input type="radio" class="form-text" name="vatFlag" value="1">
					<input type="radio" class="form-text" name="vatFlag" value="2">
				</div>
			</div>
			<div class="form-box-st-01 half">
				<div class="row-box">
					<label class="title">업체명</label>
					<input type="text" class="form-text" name="company" placeholder="업체명을 입력하세요." maxlength="20"/>
				</div>
			</div>
		</div>
	</div>
</div>
</form>
