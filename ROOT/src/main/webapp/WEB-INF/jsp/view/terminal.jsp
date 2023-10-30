<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = $.extend({}, _param);
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.order = 'A.CREATE_DT DESC';
		
		var _table = $('.contents-body-wrap .pb-table.list');
		var theadObj = { table: _table };

		var crtFuneralHallList = function(_lv) {
			var _obj = { userNo:true, order:'FUNERAL_NAME ASC' };
			
			$('.pb-right-popup-wrap .pb-table.list.funeral > tbody').html('');
			$.pb.ajaxCallHandler('/admin/selectAllFuneralHallList.do', _obj, function(result) {
				$.each(result.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this).addClass(idx%2 ? 'alt':'').attr('data-funeral-no', this.FUNERAL_NO).attr('data-manager-no', this.MANAGER_NO);
					_tr.append('<td>'+this.FUNERAL_NAME+'</td>');
					_tr.append('<td>'+this.ADDRESS+'</td>');
					_tr.on('click', function() {
						crtRbryConnection(_tr.data('FUNERAL_NO'));
						$(this).addClass('ac').siblings('tr').removeClass('ac');
						$('input[name=raspberryId]').val("");
						$('input[name=memo]').val("");
						$('.top-button.register').val('');
						$('.top-button.delete').val('');
					});

					$('.pb-right-popup-wrap .pb-table.list.funeral > tbody').append(_tr);
				});
			});
		};
		
		var crtRbryConnection = function(_funeralNo, _selected, _binsoSelected) {
			$.pb.ajaxCallHandler('/admin/selectRaspberryConnectionList.do', { funeralNo:_funeralNo, order:'RASPBERRY_CONNECTION_NO' }, function(result) {
				$('.pb-right-popup-wrap .pb-table.list.terminal > tbody').html("");
				$.each(result.rasp, function(){
					var _tr = $('<tr>');
					_tr.data(this).attr('data-id', this.RASPBERRY_CONNECTION_NO);
					_tr.append('<td>'+this.APPELLATION+'</td>');
					_tr.append('<td>'+this.RASPBERRY_ID+'</td>');
					_tr.append('<td>'+this.MEMO+'</td>');
					_tr.on('click', function() {
						if(_tr.data('CLASSIFICATION') == 20) $('.binso').css('display', 'block');
						else $('.binso').css('display', 'none');
						$('select[name=raspberryConnectionNo]').val(_tr.data('RASPBERRY_CONNECTION_NO'));
						$('select[name=binso]').val(_tr.data('BINSO_RASPBERRY_CONNECTION_NO'));
						$('input[name=raspberryId]').val(_tr.data('RASPBERRY_ID')).attr('readonly', true);
						$('input[name=memo]').val(_tr.data('MEMO'));
						$('.top-button.register').val(_tr.data('RASPBERRY_ID'));
						$('.top-button.delete').val(_tr.data('RASPBERRY_ID'));
						$(this).addClass('ac').siblings('tr').removeClass('ac');
					});
					$('.pb-right-popup-wrap .pb-table.list.terminal > tbody').append(_tr);
				});
				
				$('select[name=raspberryConnectionNo]').html('<option value="">시설을 선택해주세요</option>');
				$('select[name=binso]').html('<option value="">시설을 선택해주세요</option>');
				$.each(result.list, function() {
					$('select[name=raspberryConnectionNo]').append('<option value="'+this.RASPBERRY_CONNECTION_NO+'" data-classification="'+this.CLASSIFICATION+'">['+this.CLASSIFICATION_NAME+'] '+this.APPELLATION+'</option>');
					if(this.CLASSIFICATION == 10)
						$('select[name=binso]').append('<option value="'+this.RASPBERRY_CONNECTION_NO+'" data-classification="'+this.CLASSIFICATION+'">['+this.CLASSIFICATION_NAME+'] '+this.APPELLATION+'</option>');
				});
				
				$('select[name=raspberryConnectionNo]').on('change', function(){
					if($(this).find('option:selected').data('classification') == 20) $('.binso').css('display', 'block');
					else $('.binso').css('display', 'none');
				});
				if(_binsoSelected) $('.binso').css('display', 'block');
				$('.pb-table.list.terminal tr').removeClass('ac').siblings('[data-id="'+_selected+'"]').addClass('ac');
				$('select[name=raspberryConnectionNo] > option[value="'+_selected+'"]').prop('selected', true);
				$('select[name=binso] > option[value="'+_binsoSelected+'"]').prop('selected', true);
			});
		};
		
		theadObj.colGroup = new Array(5, '*', 15, 10, 12, 10, 20, 10);
		theadObj.theadRow = new Array(['', '번호'], ['FUNERAL_NAME', '장례식장'], ['', '시/도/군/구'], ['', '명칭'], ['RASPBERRY_ID', '라즈베리 아이디'], ['CLASSIFICATION_NAME', '모드'], ['MEMO', '메모'], ['CREATE_DT', '생성일']);
		
		theadInit(theadObj, function(_orderText) { 
			searchObj.order = _orderText;
			createTable(searchObj); 
		});
		
		$('.search-box-wrap .search-text-button').on('click', function() {
			searchObj.currentPage = 1;
			searchObj.queryPage = 0;
			searchObj.searchText = $(this).prev('.search-text').val();
			
			var _pageData = { paging:searchObj };
			var _urlSplit = $(location)[0].pathname.split('/');
			history.pushState(_pageData, '', '/'+_urlSplit[1]+'/1');
			createTable(searchObj);
		});
		
		$('.search-box-wrap .search-text').on('keyup', function(e) {
			if(e.keyCode == 13) $(this).next('.search-text-button').trigger('click');
		});
		
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectRaspberryList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx;
					_tr.append('<td class="c">'+_tableNo+'</td>');
					_tr.append('<td class="c">'+this.FUNERAL_NAME+'</td>');
					_tr.append('<td class="c">'+this.GUNGU_NAME+'</td>');
					_tr.append('<td class="c">'+this.APPELLATION+'</td>');
					_tr.append('<td class="c">'+this.RASPBERRY_ID+'</td>');
					_tr.append('<td>'+this.CLASSIFICATION_NAME+'</td>');
					_tr.append('<td>'+this.MEMO+'</td>');
					_tr.append('<td class="c">'+this.CREATE_DT+'</td>');
					_tr.on('click', function() {
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.top-button.register').val(_tr.data('RASPBERRY_ID'));
							_thisLayer.find('.top-button.delete').val(_tr.data('RASPBERRY_ID'));
							_thisLayer.find('.pb-table.list.funeral tr').removeClass('ac').siblings('[data-funeral-no="'+_tr.data('FUNERAL_NO')+'"]').addClass('ac');
// 							_thisLayer.find('input[name=raspberryId]').attr('readonly', true).css('width', '');
// 							_thisLayer.find('#btnOverlapChk').hide();
							$('input[name=raspberryId]').attr('readonly', true);
							crtRbryConnection(_tr.data('FUNERAL_NO'), _tr.data('RASPBERRY_CONNECTION_NO'), _tr.data('BINSO_RASPBERRY_CONNECTION_NO'));
							$('.table-search.icon-search').val("").keyup();
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
		
		crtFuneralHallList();
		createTable(searchObj);
		
		$('#btnRegister').on('click', function() {
			$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
				_thisLayer.find('.top-button.register').val('');
// 				_thisLayer.find('.top-button.delete').val('').hide();
				_thisLayer.find('.top-button.delete').val('');
				_thisLayer.find('.pb-table.list tr').removeClass('ac');
				
				$('.pb-table.list.terminal tbody').html("");
				$('select[name=raspberryConnectionNo]').html('<option value="">시설을 선택해주세요</option>');
				$('select[name=binso]').html('<option value="">시설을 선택해주세요</option>');
				$('input[name=raspberryId]').attr('readonly', false);
// 				_thisLayer.find('input[name=raspberryId]').attr('readonly', false).css('width', 'calc(100% - 256px)');
// 				_thisLayer.find('#btnOverlapChk').show();
				layerInit(_thisLayer);
			});
		});
		
		$('.pb-right-popup-wrap .table-search').on('keyup', function() {
			$('.pb-right-popup-wrap .pb-table.list.funeral > tbody > tr').hide();
			if($(this).val()) $('.pb-right-popup-wrap .pb-table.list.funeral > tbody td:contains("'+$(this).val()+'")').parent('tr').show();
			else $('.pb-right-popup-wrap .pb-table.list.funeral > tbody > tr').show();
		});
		
		$('input[name=raspberryId]').on('keyup', function(e) {
			if(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/gi.test($(this).val())) $(this).siblings('.pb-warning').show();
			else $(this).siblings('.pb-warning').hide();
			
// 			if(e.keyCode == 13) $(this).siblings('#btnOverlapChk').trigger('click');
		});
		
// 		$('#btnOverlapChk').on('click', function() {
// 			var _idInput = $(this).siblings('input[name=raspberryId]');
			
// 			if(_idInput.val() && !$(this).siblings('.pb-warning').is(':visible')) {
// 				$.pb.ajaxCallHandler('/admin/selectRaspberryList.do', { raspberryId:_idInput.val() }, function(result) {
// 					if(result.list.length) alert('이미 존재하는 아이디입니다.');
// 					else {
// 						if(confirm('사용가능한 아이디입니다. 사용하시겠습니까?')) _idInput.attr('readonly', true);
// 					}
// 				});
// 			}
// 		});
		
		
		$('select[name=raspberryConnectionNo]').on('change', function(){
			if($(this).val()){
				if($('.pb-right-popup-wrap .pb-table.list.terminal > tbody > tr[data-id='+$(this).val()+']').length == 0){
					$('.pb-right-popup-wrap .pb-table.list.terminal > tbody > tr').removeClass('ac');
					$('input[name=raspberryId]').val("").attr('readonly', false);
					$('input[name=memo]').val("");
					$('.top-button.register').val("");
					$('.top-button.delete').val("");
				}else{
					$('.pb-right-popup-wrap .pb-table.list.terminal > tbody > tr[data-id='+$(this).val()+']').addClass('ac').siblings('tr').removeClass('ac');
					$('input[name=raspberryId]').val($('.pb-right-popup-wrap .pb-table.list.terminal > tbody > tr[data-id='+$(this).val()+']').data('RASPBERRY_ID')).attr('readonly', true);
					$('input[name=memo]').val($('.pb-right-popup-wrap .pb-table.list.terminal > tbody > tr[data-id='+$(this).val()+']').data('MEMO'));
					$('.top-button.register').val($('.pb-right-popup-wrap .pb-table.list.terminal > tbody > tr[data-id='+$(this).val()+']').data('RASPBERRY_ID'));
					$('.top-button.delete').val($('.pb-right-popup-wrap .pb-table.list.terminal > tbody > tr[data-id='+$(this).val()+']').data('RASPBERRY_ID'));
				}
			}
		});
		
		
		
		$('.pb-right-popup-wrap .top-button.register').on('click', function() {
			var _btnValue = $(this).val();
			if(!_btnValue && !$('.pb-right-popup-wrap .pb-table.list.funeral tr.ac').length) return alert('장례식장을 선택해주세요.');
			
			//아이디 중복확인
			var overlap = false;
			if(!_btnValue && $('input[name=raspberryId]').val()){
				$.pb.ajaxCallHandler('/admin/selectRaspberryList.do', { raspberryId:$('input[name=raspberryId]').val() }, function(result) {
	 				if(result.list.length) overlap = true;
	 				
	 				if(overlap) return alert("이미 존재하는 아이디입니다.");
	 				else joinRaspberry();
				});
			}else{
				joinRaspberry(_btnValue);
			}
		});
		
		var joinRaspberry = function(_btnValue) {
			if(!necessaryChecked($('#dataForm'))) {
				var _formData = new FormData($('#dataForm')[0]);
				var _uploadUrl = _btnValue ? '/admin/updateRaspberry.do':'/admin/insertRaspberry.do';
				_formData.append('actionUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('raspberryId', _btnValue ? _btnValue:'');
				_formData.append('funeralNo', $('.pb-right-popup-wrap .pb-table.list.funeral tr.ac').data('funeral-no'));
				if($('select[name=raspberryConnectionNo]').find('option:selected').data('classification') == 20 && !$('select[name=binso]').find('option:selected').val()){
					return alert("빈소를 선택해 주세요.");
				}else{
					_formData.append('binsoRaspberryConnectionNo', $('select[name=binso]').find('option:selected').val());
				}
				
				$.pb.ajaxUploadForm(_uploadUrl, _formData, function(result) {
					if(result) {
						createTable(searchObj);
						crtRbryConnection($('.pb-right-popup-wrap .pb-table.list.funeral tr.ac').data('funeral-no'), $('select[name=raspberryConnectionNo]').val());
						$('input[name=raspberryId]').attr('readonly', true);
// 						if(_btnValue) closeLayerPopup();
// 						else {
// 							var targetLayer = $('.pb-right-popup-wrap');
// 							targetLayer.find('.top-button.register').val('');
// // 							targetLayer.find('.top-button.delete').val('').hide();
// 							targetLayer.find('.top-button.delete').val('').show();
// 							targetLayer.find('.pb-table.list tr').removeClass('ac');
// 							targetLayer.find('input[name=raspberryId]').attr('readonly', false);
// 							$('select[name=raspberryConnectionNo]').html('<option value="">시설을 선택해주세요</option>');
// 							$('select[name=binso]').html('<option value="">시설을 선택해주세요</option>');
// 							layerInit(targetLayer);
// 						}
					} else alert('저장 실패 관리자에게 문의하세요');
				}, true);
			}else{
				if(!$('select[name=raspberryConnectionNo]').val()) return alert("시설명을 선택해 주세요.");
			}
		};
		
		$('.pb-right-popup-wrap .top-button.delete').on('click', function() {
			var _rpiId = $(this).val();
			
			if(!_rpiId) return alert('라즈베리를 선택해 주세요.');
			else if(confirm('삭제하시겠습니까?')) {
				$.pb.ajaxCallHandler('/admin/deleteRaspberry.do', { raspberryId:_rpiId }, function(result) {
					if(result) {
						$(this).val("");
						$('input[name=raspberryId]').val("");
						crtRbryConnection($('.pb-right-popup-wrap .pb-table.list.funeral tr.ac').data('funeral-no'));
						createTable(searchObj);
					} else alert('저장 실패 관리자에게 문의하세요');
				});
			}
		});

		//모바일/PC 스크립트 인식 구분
		var filter = "win16|win32|win64|mac|macintel";
		if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
		//MOBILE
		//	document.getElementById("c-table").style.width="1700px";
		//	document.getElementById("btnRegister").style.display="none";

		}
		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<form id="dataForm">
	<div class="pb-right-popup-wrap full-size">
		<div class="pb-popup-title">라즈베리 등록 및 편집</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body half">
			<div class="popup-body-top">
				<div class="top-title">라즈베리 정보</div>
			</div>
			<input type="text" class="table-search icon-search" style="margin-top:0;" placeholder="장례식장검색"/>
			<div class="pb-table-wrap funeral-hall" style="height:calc(100% - 200px);">
				<table class="pb-table list funeral">
					<colgroup>
						<col width="40%"/>
						<col width="60%"/>
					</colgroup>
					<thead>
						<tr>
							<th>상호</th>
							<th>장례식장 주소</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
		
		<div class="pb-popup-body half">
			<div class="popup-body-top" style="height:70px;">
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button delete" style="display:inline-block;">삭제</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
				</div>
			</div>
			
			<div class="pb-table-wrap teminal" style="height:500px;">
				<span class="pb-popup-close"></span>
				<table class="pb-table list terminal">
					<colgroup>
						<col width="33%"/>
						<col width="33%"/>
						<col width="33%"/>
					</colgroup>
					<thead>
						<tr>
							<th>빈소목록</th>
							<th>아이디</th>
							<th>메모</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
			
			<div class="pb-popup-form" style="margin-top:20px;">
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">*시설명</label>
						<select class="form-select necessary" name="raspberryConnectionNo"><option value="">시설을 선택해주세요</option></select>
					</div>
					<div class="row-box">
						<label class="title">메모</label>
						<input type="text" class="form-text" name="memo" placeholder="예)별관 2층 종합현황판"/>
					</div>
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box binso" style="display:none;">
						<label class="title">빈소선택</label>
						<select class="form-select" name="binso"><option value="">시설을 선택해주세요</option></select>
					</div>
					<div class="row-box">
						<label class="title">*아이디</label>
						<input type="text" class="form-text necessary" name="raspberryId" placeholder="아이디"/>
<!-- 						<button type="button" class="text-button" id="btnOverlapChk">중복확인</button> -->
<!-- 						<div class="pb-warning">아이디는 영문만 가능합니다.</div> -->
					</div>
				</div>
			</div>
			
		</div>
	</div>
</form>
<div class="contents-title-wrap">
	<div class="title">라즈베리 단말 관리</div>
	<div class="title-right-wrap"><button type="button" class="title-button" id="btnRegister">라즈베리 신규등록</button></div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">라즈베리목록</div>
	</div>
	<div class="search-right-wrap">
		<input type="text" class="search-text rb" placeholder="키워드 검색"/>
		<button type="button" class="search-text-button">검색</button>
	</div>
</div>
<div class="contents-body-wrap">
	<table class="pb-table list" id="c-table">
		<colgroup></colgroup>
		<thead></thead>
		<tbody></tbody>
	</table>
	<div class="paging"></div>
</div>