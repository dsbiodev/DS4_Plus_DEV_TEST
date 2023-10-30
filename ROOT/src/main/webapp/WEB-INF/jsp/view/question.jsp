<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = _param;
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.order = 'QUESTION_NO DESC';
		

		$('.select-from-year').createYear({begin:2018});
		$('.select-to-year').createYear({begin:2018});
		
		$('.select-from-month').createMonth();
		$('.select-to-month').createMonth();
		
		
		var _table = $('.pb-table.list');
		$('input[type=radio][name=questionFlag]').pbRadiobox({ addText:['이용문의', '고장/장애', '제휴문의'], fontSize:'16px', matchParent:true });
		
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
			colGroup:new Array(25, 8, 8, 8, '*', 10, 9),
			theadRow:[['FUNERAL_NAME', '장례식장'], ['ADDRESS', '대표자'], ['ADDRESS', '담당자'], ['ADDRESS', '문의항목'], ['CONTACT', '내용'], ['REMARKS', '비고'], ['ADDRESS', '작성일']]
		};
		
		theadInit(theadObj, function(_orderText) {
			searchObj.order = _orderText; 
			createFuneralAllTable(searchObj); 
		});
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/adminSec/selectQuestionList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx; 
					_tr.append('<td class="c">'+this.FUNERAL_NAME+'</td>');
					_tr.append('<td class="c">'+(this.BOSS_NAME ? this.BOSS_NAME : '-')+'</td>');
					_tr.append('<td class="c">'+this.CREATE_USER_NAME+'</td>');
					_tr.append('<td class="c">'+this.QUESTION_FLAG_NAME+'</td>');
					_tr.append('<td class="l" style="word-break: break-all;">'+this.CONTENTS+'</td>');
					_tr.append('<td class="c">'+(this.REMARKS ? this.REMARKS : '-')+'</td>');
					_tr.append('<td class="c">'+this.CREATE_DT+'</td>');
					_tr.find('td').on('click', function() {
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.top-button.upd').val(_tr.data('QUESTION_NO'));
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
		createTable(searchObj);

		
		$('.upd').on('click', function(){
			var _formData = new FormData($('#dataForm')[0]);
			_formData.append('questionNo', $(this).val());
			$.pb.ajaxUploadForm('/adminSec/updateQuestion.do', _formData, function(result) {
				$('.top-button-wrap').find('button').prop('disabled', true);
				if(result != 0) {
					createTable(searchObj);
					$('.top-button-wrap').find('button').prop('disabled', false);
					$('.pb-popup-close').click();
				} else alert('저장 실패 관리자에게 문의하세요');
			}, '${sessionScope.loginProcess}');
		});

		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<form id="dataForm" onsubmit="return false">
	<div id="pb-right-popup-wrap" class="pb-right-popup-wrap">
		<input type="hidden" name="funeralNo" value=""/>
		<div class="pb-popup-title">문의항목</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title">문의내용</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button upd">수정</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
				</div>
			</div>
			<div class="pb-popup-form">
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title">내용</label>
						<textarea class="form-textarea necessary" name="contents" style="height:400px;" readonly></textarea>
					</div>
					<div class="row-box">
						<label class="title">비고</label>
						<input type="text" class="form-text necessary" name="remarks"/>
					</div>
				</div>
			</div>
		</div> 	
	</div>
</form>


<div class="contents-title-wrap">
	<div class="title">문의항목</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">문의내용</div>
	</div>
<!-- 	<div class="search-right-wrap"> -->
<!-- 		<select class="select-from-year"></select> -->
<!-- 		<select class="select-from-month"></select> -->
<!-- 		<div class="text">부터</div> -->
<!-- 		<select class="select-to-year"></select> -->
<!-- 		<select class="select-to-month"></select> -->
<!-- 		<div class="text">까지</div> -->
<!-- 		<button type="button" class="search-text-button">검색</button> -->
<!-- 	</div> -->
</div>
<div class="contents-body-wrap">
	<table class="pb-table list">
		<colgroup>
		</colgroup>
		<thead></thead>
		<tbody></tbody>
	</table>
	<div class="paging"></div>
</div>