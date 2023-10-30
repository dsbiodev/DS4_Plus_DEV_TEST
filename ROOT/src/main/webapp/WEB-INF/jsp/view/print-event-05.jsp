<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	$(function() {
		if(!'${sessionScope.loginProcess}') $(location).attr('href', '/');
		
		//장례비용 내역서
		var _param = JSON.parse('${data}');
		// S = split
		var _paramS = _param.pk.split('&');
		$('.ajax-loading').remove();
		$.pb.ajaxCallHandler('/adminSec/selectEventOrderPrintList.do', { eventNo : _paramS[0], partnerNo : _paramS[1], funeralNo : '${sessionScope.loginProcess.FUNERAL_NO}' }, function(data) {
			var _info = data.infoList[0];
			$('.deceased').text(_info.DM_NAME +" | "+_info.APPELLATION);
			$('.enshrine').text(_info.ENTRANCE_ROOM_NO ? _info.ENTRANCE_ROOM_START_DT+" ~ "+_info.ENTRANCE_ROOM_END_DT : '');
			$('.checkin').text(_info.ENTRANCE_ROOM_DT+" ~ "+(_info.CARRYING_YN == 1 ? _info.CARRYING_DT : '미정'));
			$('.funeralhall').text(_info.FUNERAL_NAME+ " | " + _info.ADDRESS+" "+ (_info.ADDRESS_DETAIL ? _info.ADDRESS_DETAIL : "")+(_info.BUS_NO ? " | "+_info.BUS_NO : "")+(_info.BOSS_NAME ? " | "+_info.BOSS_NAME : ""));

			
			$.each(data.partnerCnt, function(idx){
				var _this = this;
				
				// 반품내역 테이블 생성
				var _table = $('<table class="print-table print-tb-table">');
				_table.data(this);
				_table.append('<colgroup><col width="20%"/><col width="20%"/><col width="15%"/><col width="15%"/><col width="15%"/><col width="15%"/></colgroup>');
				_table.append('<thead><tr><th colspan=6><img src="/resources/img/th_gray.png"><div>'+this.NAME+' 반품 내역</div></th></tr>');
				_table.find('thead').append('<tr>');
				_table.find('thead tr:last-child').append('<th><img src="/resources/img/th_gray.png""><div>분류</div></th>');
				_table.find('thead tr:last-child').append('<th><img src="/resources/img/th_gray.png"><div>품목</div></th>');
				_table.find('thead tr:last-child').append('<th><img src="/resources/img/th_gray.png"><div>단위</div></th>');
				_table.find('thead tr:last-child').append('<th><img src="/resources/img/th_gray.png"><div>수량</div></th>');
				_table.find('thead tr:last-child').append('<th><img src="/resources/img/th_gray.png"><div>단가</div></th>');
				_table.find('thead tr:last-child').append('<th><img src="/resources/img/th_gray.png"><div>금액</div></th>');
				_table.append('<tbody>');
				$('.page-take-back-wrap').append(_table);
				
				var _table2 = $('<table class="print-table print-tb-total-table">');
				_table2.append('<colgroup><col width="20%"/><col width="65%"/><col width="15%"/></colgroup>');
				_table2.append('<tbody><tr class="tfoot"><td class="c-name"><img src="/resources/img/th_gray.png"><div>'+this.NAME+' 합계</div></td><td><img src="/resources/img/th_gray.png"></td><td><img src="/resources/img/th_gray.png"><div class="price"></div></td></tr></tbody>');
				_table.after(_table2);
			});
			
			
			var _total = 0;
			var _tbPrice = 0;
			$.each(data.list, function(idx){
				var _this = this;
				if(this.FLAG == 2) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td>'+this.NAME+'</td>');
					_tr.append('<td class="r">'+$.pb.targetMoney(this.PRICE)+'</td>');
					$('.page-total-wrap .print-table > .tbody').append(_tr);
					_total += this.PRICE
				}

				if(this.TAKE_BACK_CNT < 0) {
					_tbPrice += this.VAT_PRICE*this.TAKE_BACK_CNT;
				}
				
				// 반품내역 리스트
				$('.page-take-back-wrap .print-table').each(function() {
					if($(this).data('PARTNER_NO') == _this.PARTNER_NO && _this.TAKE_BACK_CNT < 0) {
						var _tr = $('<tr>');
						_tr.data(this);
						_tr.append('<td class="c-name">'+_this.CLASSIFICATION_NAME+'</td>');
						_tr.append('<td>'+_this.NAME+'</td>');
						_tr.append('<td>'+_this.UNIT+'</td>');
						_tr.append('<td>'+_this.TAKE_BACK_CNT+'</td>');
						_tr.append('<td class="r">'+$.pb.targetMoney(_this.VAT_PRICE)+'</td>');
						_tr.append('<td class="r">'+$.pb.targetMoney(_this.VAT_PRICE*_this.TAKE_BACK_CNT)+'</td>');
						$(this).find('tbody').append(_tr);
						$(this).next().find('.tfoot .price').text($.pb.targetMoney(_this.VAT_PRICE * _this.TAKE_BACK_CNT + $(this).next().find('.tfoot .price').text().replace(/,/gi, '')*1))
					}
				});
			});
			
			// 반품 테이블 품목 같은거끼리 묶기
			$('.page-take-back-wrap .print-tb-table').each(function() {
				var _this = $(this);
				_this.find(".c-name").each(function() {
					var rows = _this.find(".c-name" + ":contains('" + $(this).text() + "')");
					if (rows.length > 1) {
						rows.eq(0).attr("rowspan", rows.length);
						rows.not(":eq(0)").remove();
					}
				});

	 			// 반품내역 없을시 테이블 삭제
				if($(this).next().find('tbody tr .price').text() == "") $(this).next().remove()
				if($(this).find('tbody tr').length < 1) $(this).remove()
			});
			
			
			
			// 반품내역 합계
			if(_tbPrice == 0) $('.page-take-back-wrap').remove();
			$('.page-take-back-wrap .total').text($.pb.targetMoney(_tbPrice)+"원");
			
			
			// 주문테이블 품목 같은거끼리 묶기
			$('.page-wrap').each(function(){
				var _this = $(this);
				_this.find(".c-name").each(function() {
					var rows = _this.find(".c-name" + ":contains('" + $(this).text() + "')");
					if (rows.length > 1) {
						rows.eq(0).attr("rowspan", rows.length);
						rows.not(":eq(0)").remove();
					}
				});
			});
			
			
			IEPageSetupX.header = "";
			IEPageSetupX.footer = "";
			IEPageSetupX.ShrinkToFit = true;
			IEPageSetupX.PrintBackground = false;
			IEPageSetupX.leftMargin = "";
			IEPageSetupX.rightMargin = "";
			IEPageSetupX.Preview();
			window.close();
		});
		

		var createTable = function(_data) {
			var tmp = 0;
			
			$.each(_data, function(idx) {
				if(0 < idx && idx < 38) {
					if(idx%37 == 0){
						tmp += 1;
					}
				}else {
					if((idx-37)%45 == 0) {
						tmp += 1;
					}
				}

				if(this.FLAG == 2) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.css('font-weight', '500');
					_tr.append('<td>'
							+'<img src="/resources/img/td_blue.png" style="position:absolute; z-index:9; width:100%; height:36px; left:0px; top:0px;">'
							+'<div style="position:relative; z-index:100">'+this.NAME+'</div></td>');
					_tr.append('<td><img src="/resources/img/td_blue.png" style="position:absolute; z-index:9; width:calc(100% - 1px); height:36px; left:0; top:0px;"></td>');
					_tr.append('<td><img src="/resources/img/td_blue.png" style="position:absolute; z-index:9; width:100%; height:36px; left:0; top:0px;"></td>');
					_tr.append('<td><img src="/resources/img/td_blue.png" style="position:absolute; z-index:9; width:100%; height:36px; left:0; top:0px;"></td>');
					_tr.append('<td><img src="/resources/img/td_blue.png" style="position:absolute; z-index:9; width:100%; height:36px; left:0; top:0px;"></td>');
					_tr.append('<td><img src="/resources/img/td_blue.png" style="position:absolute; z-index:9; width:100%; height:36px; left:0; top:0px;"></td>');
					_tr.append('<td>'
							+'<img src="/resources/img/td_blue.png" style="position:absolute; z-index:9; width:calc(100% - 1px); height:36px; left:0; top:0px;">'
							+'<div style="position:relative; z-index:100"></div></td>');
					_tr.append('<td class="r">'
							+'<img src="/resources/img/td_blue.png" style="position:absolute; z-index:9; width:calc(100% + 1px); height:36px; right:0px; top:0px;">'
							+'<div style="position:relative; z-index:100">'+$.pb.targetMoney(this.PRICE)+'</div></td>');
					$('.partner'+this.PARTNER_NO+':eq('+tmp+') .print-table > .tbody').append(_tr);
					
					_tPrice += (this.PRICE);
				}else{
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td class="c-name">'+this.CLASSIFICATION_NAME+'</td>');
					_tr.append('<td><div class="ellipsis" style="width:255px;">'+this.NAME+'</div></td>');
					_tr.append('<td>'+this.UNIT+'</td>');
					_tr.append('<td>'+this.ORDER_CNT+'</td>');
					_tr.append('<td>'+(this.TAKE_BACK_CNT == 0 ? '' : this.TAKE_BACK_CNT)+'</td>');
					_tr.append('<td>'+this.CNT+'</td>');
					_tr.append('<td class="r">'+$.pb.targetMoney(this.VAT_PRICE)+'</td>');
					_tr.append('<td class="r">'+$.pb.targetMoney(this.PRICE)+'</td>');
					$('.partner'+this.PARTNER_NO+':eq('+tmp+') .print-table > .tbody').append(_tr);
				}
			});
			
		}
		
		
	});
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
  	
  	.page-total-wrap { height: 100vh; box-sizing: border-box; }
  	.page-total-wrap .total-box { height: 50vh; }
  	.page-total-wrap .print-table tbody tr { height: 80px; }
  	
  	.page-take-back-wrap .print-table { font-size: 25px; }
	.page-take-back-wrap .print-table th { border: 1px solid #000; position: relative; }
  	.page-take-back-wrap .print-table thead tr th img { position:absolute; z-index:9; width:100%; height:50px; }
  	.page-take-back-wrap .print-table thead tr th div { position: relative; z-index: 100; height: 50px; display: flex; justify-content: center; align-items: center; }

    .print-tb-total-table { margin-bottom: 100px; font-size: 25px; border-top: none; }
  	.print-tb-total-table tbody tr { height: 55px; }
  	.print-tb-total-table tbody tr td { border-top: none; }
   	.print-tb-total-table tbody tr td img { position: absolute; left: 0px; z-index:9; width:100%; height:55px; top: 0px; }
	.print-tb-total-table tbody tr td div { position: relative; z-index: 100; height: 50px; display: flex; justify-content: center; align-items: center; }
	.print-tb-total-table tbody tr td .price { justify-content: flex-end; padding-right: 10px; }
  	    
</style>
<object id="IEPageSetupX" classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/resources/js/IEPageSetupX.cab#version=1,4,0,3" width=0 height=0></object> 
<div class="page" id="page">
	<div class="page-take-back-wrap" style="min-width: 100vh;">
		<div class="print-title">반품내역서</div>
		
		<div class="info-box">
			<div class="deceased-box">고인정보 : <span class="deceased"></span></div>
			<div class="mourner-box">상주확인 : <span class="mourner">(인)</span></div>
		</div>
		<div class="info-box">
			<div class="total-box">합 계 : <span class="total"></span></div>
		</div>
		<div class="funeralhall-box">업체정보 : <span class="funeralhall"></span></div>
		
	</div>
	
</div>

