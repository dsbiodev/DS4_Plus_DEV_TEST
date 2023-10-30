<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		$.getScript('//dapi.kakao.com/v2/maps/sdk.js?appkey=f7e1fd09c3c8eb31bab7abf293fe6bea&autoload=false&libraries=services', function(data, textStatus, jqxhr) {
			daum.maps.load(function() {
				var searchObj = _param;
				searchObj.currentPage = (_param.pk ? _param.pk:1);
				searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:10):0);
				searchObj.display = (_param.display ? _param.display:10);
				searchObj.order = 'PARTNER_NO DESC';

				$.pb.ajaxCallHandler('/adminSec/selectFuneralList.do', { }, function(funeralData) {
					$('.select-box-wrap .allList tbody').append('<tr><td>선택해주세요</td>');
					$.each(funeralData.list, function(){
						var _tr = $('<tr>').data(this);
						_tr.append('<td value='+this.FUNERAL_NO+'>'+this.FUNERAL_NAME+'('+this.GUNGU_NAME+')</td>');
						$('.select-box-wrap .allList').find('tbody').append(_tr);
					});
					$('.select-box-wrap .allList tbody tr').on('click', function(){
						$('.select-box-wrap .allList tr').removeClass('ac');
						$(this).addClass('ac');
						
						if($(this).data('FUNERAL_NO')){
							$('.select-box-wrap .table-search').val($(this).find('td').text());
							$('.select-box-wrap .table-search').data('funeralNo', $(this).data('FUNERAL_NO'));
	 						searchObj.funeralNo = $(this).data('FUNERAL_NO');
	 						createTable(searchObj);
	 					}else{
							$('.select-box-wrap .table-search').val("");
							$('.select-box-wrap .table-search').data('funeralNo', null);
	 						$('.pb-table.list tbody').html("");
	 						$('.paging').html("");
	 					}
					});
					
					$('.select-box-wrap .table-search').on('keyup', function() {
						$('.select-box-wrap .allList > tbody > tr').removeClass('ac');
						$('.select-box-wrap .allList > tbody > tr').hide();
						if($(this).val()) $('.select-box-wrap .allList > tbody td:contains("'+$(this).val()+'")').parent('tr').show();
						else $('.select-box-wrap .allList > tbody > tr').show();
					});
				});
				
				
				var _table = $('.pb-table.list'), _total = 0;
				$('input[type=radio][name=partnerFlag]').pbRadiobox({ addText:['장례식장', '식당', '매점', '기타'], fontSize:'16px', matchParent:true });
				$('input[name=busNo]').busNoFomatter();
				$('input[name=tel]').phoneFomatter();
				
				$('.btn-addr').on('click', function(){
					new daum.Postcode({
						oncomplete:function(data) {
//		 					jQuery("#postcode1").val(data.postcode1);
//		 					jQuery("#postcode2").val(data.postcode2);
//		 					jQuery("#zonecode").val(data.zonecode);
							$('input[name=address]').removeClass('necessary-ac').val(data.address);
//		 					jQuery("#address_etc").focus();
								
							var geocoder = new daum.maps.services.Geocoder();
							geocoder.addressSearch(data.address, function(result, status) {
						        if(status === daum.maps.services.Status.OK) {
						            var coords = new daum.maps.LatLng(result[0].y, result[0].x);
						            
						            var moveLatLon = new kakao.maps.LatLng(result[0].y, result[0].x);
						 		    map.setCenter(moveLatLon);
						 		   	var marker = new kakao.maps.Marker({ 
						 			    // 지도 중심좌표에 마커를 생성합니다 
						 			    position: map.getCenter() 
					 				});marker.setMap(map);
						        } 
						    });
						}
					}).open();
				});
				
				$('.search-right-wrap .search-text').on('keyup', function(e) {
					if(e.keyCode == 13) {
						$('.search-text-button').click();
					}
				});
				
				$('.search-text-button').on('click', function(){
					searchObj.currentPage = 1;
					searchObj.queryPage = 0;
					searchObj.searchText = $('.search-right-wrap .search-text').val();
					
					var _pageData = { paging:searchObj };
					var _urlSplit = $(location)[0].pathname.split('/');
					history.pushState(_pageData, '', '/'+_urlSplit[1]+'/1');
					createTable(searchObj);
				});
				
				var theadObj = {
					table: _table,
					colGroup:new Array(25, 25, 25, 25),
					theadRow:[['NAME', '사업자'], ['PARTNER_FLAG_NAME', '구분'], ['BUS_NO', '사업자등록번호'], ['CREATE_DT', '등록일']]
				};
				
				theadInit(theadObj, function(_orderText) {
					searchObj.order = _orderText; 
					createTable(searchObj); 
				});
				
				var createTable = function(_searchObj) {
					$.pb.ajaxCallHandler('/adminSec/selectPartnerManagementList.do', _searchObj, function(tableData) {
						_table.find('tbody').html('');
						_total = tableData.total;
						$.each(tableData.list, function(idx) {
							var _tr = $('<tr>');
							_tr.data(this);
							_tr.append('<td class="c">'+this.NAME+'</td>');
							_tr.append('<td class="c">'+this.PARTNER_FLAG_NAME+'</td>');
							_tr.append('<td class="c">'+$.pb.busNoFomatter(this.BUS_NO)+'</td>');
							_tr.append('<td class="c">'+this.CREATE_DT+'</td>');
							_tr.find('td').on('click', function() {
								$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
									_thisLayer.find('.top-button.register').val(_tr.data('PARTNER_NO'));
									_thisLayer.find('.top-button.delete').val(_tr.data('PARTNER_NO'));
									_thisLayer.find('.top-button.delete').data('partnerCnt', _tr.data('PARTNER_CNT'))
			 						$('.pb-right-popup-wrap .delete').show();
									layerInit(_thisLayer, _tr.data());
								});
							});
							_table.find('tbody').append(_tr);
						});
						
						_searchObj.total = tableData.total;
						$('.contents-body-wrap > .paging').createPaging(_searchObj, function(_page) {
							var pageObj = _searchObj;
				        	pageObj.pk = _page;
				        	pageObj.currentPage = _page;
				        	pageObj.queryPage = (_page-1)*(_searchObj.display*1);
							var _urlSplit = $(location)[0].pathname.split('/');
							history.pushState({ paging:pageObj }, '', '/'+_urlSplit[1]+'/'+pageObj.currentPage);
							createTable(pageObj);
				        });
						_table.tableEmptyChecked('검색 결과가 없습니다.');
					});
				};
				

				$('#btnRegister').on('click', function() {
					if(!$('.select-box-wrap .table-search').data('funeralNo')) return alert("장례식장을 먼저 선택해 주세요.");	
					$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
						_thisLayer.find('.top-button.register, .top-button.delete').val('');
						_thisLayer.find('.top-button.delete').hide();
						layerInit(_thisLayer);
					});	
				});
				
				
				$('.register').on('click', function(){
					if(!$(this).val() && _total >= 4) return alert("더이상 업체를 등록할 수 없습니다.");
					if(!necessaryChecked($('#dataForm'))) {
						var _url = $(this).val() ? '/adminSec/updatePartnerManagement.do' : '/adminSec/insertPartnerManagement.do';
						var _formData = new FormData($('#dataForm')[0]);
						_formData.append('partnerNo', $(this).val());
						_formData.append('funeralNo', $('.select-box-wrap .table-search').data('funeralNo'));
						_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
						_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
						$.pb.ajaxUploadForm(_url, _formData, function(result) {
							$('.top-button-wrap').find('button').prop('disabled', true);
							if(result != 0) {
								createTable(searchObj);
								$('.top-button-wrap').find('button').prop('disabled', false);
								$('.pb-popup-close').click();
							} else alert('저장 실패 관리자에게 문의하세요');
						}, '${sessionScope.loginProcess}');
					}else{
						if(!$('input[name=name]').val()) return alert("상호를 입력해 주세요.");
						if(!$('input[name=busNo]').val()) return alert("사업자번호를 입력해 주세요.");
						if(!$('input[name=address]').val()) return alert("주소를 입력해 주세요.");
					}
				});
				
				$('.delete').on('click', function(){
					if($(this).data('partnerCnt') > 0) return alert("해당업체의 상품을 먼저 삭제해 주세요.");
					var _formData = new FormData($('#dataForm')[0]);
					_formData.append('partnerNo', $(this).val());
					_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
					$.pb.ajaxUploadForm('/adminSec/deletePartnerManagement.do', _formData, function(result) {
						$('.top-button-wrap').find('button').prop('disabled', true);
						if(result != 0) {
							createTable(searchObj);
							$('.top-button-wrap').find('button').prop('disabled', false);
							$('.pb-popup-close').click();
						} else alert('저장 실패 관리자에게 문의하세요');
					}, '${sessionScope.loginProcess}');
				});
			});
		});

		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<form id="dataForm">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-title">업체정보관리</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title">업체정보</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
					<button type="button" class="top-button delete">삭제</button>
				</div>
			</div>
			
			<div class="pb-popup-form">
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">* 상호</label>
						<input type="text" class="form-text necessary" name="name" placeholder="상호"/>
					</div>
				
				</div>	
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">* 사업자번호</label>
						<input type="text" class="form-text necessary" name="busNo" placeholder="사업자번호(숫자만입력)"/>
					</div>
				</div>
				
				<div class="form-box-st-01">
					<div class="row-box" style="position:relative;">
						<label class="title">*장례식장주소</label>
						<input type="text" class="form-text necessary" name="address" placeholder="주소" readonly/>
						<button type="button" class="btn-addr">주소찾기</button>
					</div>
				</div>
				
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title">구분</label>
						<input type="radio" name="partnerFlag" value="1">
						<input type="radio" name="partnerFlag" value="2">
						<input type="radio" name="partnerFlag" value="3">
						<input type="radio" name="partnerFlag" value="0">	
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">담당자 이름</label>
						<input type="text" class="form-text" name="manager" placeholder="담당자이름"/>
					</div>
				</div>	
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">전화번호</label>
						<input type="text" class="form-text" name="tel" placeholder="전화번호"/>
					</div>
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">이메일</label>
						<input type="text" class="form-text" name="email" placeholder="이메일 주소"/>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>

<div class="select-box-wrap">
<!-- 	<select class="form-select" name="funeralNo"> -->
<!-- 		<option value="">장례식장명 선택</option> -->
<!-- 	</select> -->
	<input type="text" class="form-text table-search">
	<div class="funeral-box">
		<table class="allList">
			<colgroup><col width="100%"/></colgroup>
			<tbody></tbody>
		</table>
	</div>
</div>

<div class="contents-title-wrap">
	<div class="title">업체관리</div>
	<div>업체를  관리할 수 있습니다.</div>
	<div class="title-right-wrap"><button type="button" class="title-button" id="btnRegister">신규등록</button></div>
</div>

<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">업체목록</div>
	</div>
</div>
<div class="contents-body-wrap">
	<table class="pb-table list">
		<colgroup></colgroup>
		<thead></thead>
		<tbody></tbody>
	</table>
	<div class="paging"></div>
</div>