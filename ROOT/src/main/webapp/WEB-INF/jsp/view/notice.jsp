<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$('.body-select.time.year').sysDate('year', { begin:'2020', maxValue:2025, unit:'년'} );
		$('.body-select.time.month').sysDate('month', { unit:'월' } );
		$('.body-select.time.day').sysDate('day', { unit:'일' } );
		
		// 날짜 형식 생성
		var crtDt = function(_wrap) {
			var _rstDt = '';
			_rstDt += _wrap.find('.year').val()+'-';
			_rstDt += _wrap.find('.month').val()+'-';
			_rstDt += _wrap.find('.day').val();
// 			_rstDt += _wrap.find('.day').val()+'T';
// 			_rstDt += _wrap.find('.hour').val()+':';
// 			_rstDt += _wrap.find('.min').val()+':00';
			return _rstDt;
		};
		
		var searchObj = _param;
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.order = 'NOTICE_NO DESC';
		
		var _table = $('.pb-table.list');
		$('input[type=radio][name=noticeFlag]').pbRadiobox({ addText:['시스템점검', '업데이트', '긴급공지', '이벤트공지', '일반공지', '특수'], fontSize:'16px', matchParent:true });
		if('${sessionScope.loginProcess.LV}' != 99){
			$('.pb-right-popup-wrap').find('.top-button-wrap').remove();
			$('.title-right-wrap').remove();
		}
		
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
			colGroup:new Array(10, 15, '*', 20),
			theadRow:[['', '번호'], ['NOTICE_FLAG_NAME', '구분'], ['TITLE', '제목'], ['CREATE_DT', '등록일']]
		};
		
		theadInit(theadObj, function(_orderText) {
			searchObj.order = _orderText; 
			createTable(searchObj); 
		});
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectNoticeList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx; 
					_tr.append('<td class="c">'+_tableNo+'</td>');
					_tr.append('<td class="c">'+this.NOTICE_FLAG_NAME+'</td>');
					_tr.append('<td>'+this.TITLE+'</td>');
					_tr.append('<td class="c">'+this.CREATE_DT+'</td>');
					_tr.find('td').on('click', function() {
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.top-button.register').val(_tr.data('NOTICE_NO'));
							_thisLayer.find('.top-button.delete').val(_tr.data('NOTICE_NO'));
	 						$('.pb-right-popup-wrap .delete').show();
							layerInit(_thisLayer, _tr.data());
							var _date = _tr.data('END_DT').split('-');
							_thisLayer.find('.body-select.time.year').val(_date[0]);
							_thisLayer.find('.body-select.time.month').val(_date[1]);
							_thisLayer.find('.body-select.time.day').val(_date[2]);
							
							if('${sessionScope.loginProcess.LV}' != 99) $('input[name=noticeFlag]').prop('disabled', true);
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
		

		$('#btnRegister').on('click', function() {
			$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
				_thisLayer.find('.top-button.register, .top-button.delete').val('');
				_thisLayer.find('.top-button.delete').hide();
				_thisLayer.find('.pb-popup-form.modify').hide();
				_thisLayer.find('.table-search.icon-search').val('').trigger('keyup').show();
				_thisLayer.find('.pb-table-wrap').show().find('.pb-table.list tr').removeClass('ac');
				_thisLayer.find('.row-button.upd,.row-button.del').hide();
				_thisLayer.find('.row-button.add').show();
				layerInit(_thisLayer);
				$('.popup-table').find('tbody').html('');
			});
		});
		
		
		$('.register').on('click', function(){
			if(!necessaryChecked($('#dataForm'))) {
				var _url = $(this).val() ? '/admin/updateNotice.do' : '/admin/insertNotice.do';
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('noticeNo', $(this).val());
				_formData.append('userNo', '1');
				_formData.append('endDt', crtDt($('#endDtWrap')));
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
				if(!$('input[name=title]').val()) return alert("제목을 입력해 주세요.");
				if(!$('textarea[name=contents]').val()) return alert("내용을 입력해 주세요.");
			}
		});

		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
		
		$('.delete').on('click', function(){
			var _formData = new FormData($('#dataForm')[0]);
			_formData.append('noticeNo', $(this).val());
			$.pb.ajaxUploadForm('/admin/deleteNotice.do', _formData, function(result) {
				$('.top-button-wrap').find('button').prop('disabled', true);
				if(result != 0) {
					createTable(searchObj);
					$('.top-button-wrap').find('button').prop('disabled', false);
					$('.pb-popup-close').click();
				} else alert('저장 실패 관리자에게 문의하세요');
			}, '${sessionScope.loginProcess}');
		});

		
	});
</script>
<form id="dataForm">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-title">공지사항 보기</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title">공지사항 정보</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
					<button type="button" class="top-button delete">삭제</button>
				</div>
			</div>
			
			<div class="pb-popup-form">
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title">공지분류</label>
						<input type="radio" name="noticeFlag" value="1">
						<input type="radio" name="noticeFlag" value="2">
						<input type="radio" name="noticeFlag" value="3">
						<input type="radio" name="noticeFlag" value="4">
						<input type="radio" name="noticeFlag" value="5">
						<input type="radio" name="noticeFlag" value="6">
					</div>
					<div class="row-box">
						<label class="title">작성자</label>
						<input type="text" class="form-text" name="userName" placeholder="작성자" disabled/>
					</div>
					<div class="row-box">
						<label class="title">공지 마감일</label>
						<div class="right-item-wrap" id="endDtWrap">
							<select class="body-select time year"></select>
							<select class="body-select time month"></select>
							<select class="body-select time day"></select>
						</div>
					</div>
					<div class="row-box">
						<label class="title">작성일시</label>
						<input type="text" class="form-text" name="createDt" placeholder="작성일시" disabled/>
					</div>
					<div class="row-box">
						<label class="title">제목</label>
						<input type="text" class="form-text necessary" name="title" placeholder="제목"/>
					</div>
					<div class="row-box">
						<label class="title">내용</label>
						<textarea class="form-textarea necessary" name="contents" style="height:400px;"></textarea>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>


<div class="contents-title-wrap">
	<div class="title">공지사항</div>
	<div class="title-right-wrap"><button type="button" class="title-button" id="btnRegister">신규등록</button></div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">공지목록</div>
	</div>
	<div class="search-right-wrap">
		<input type="text" class="search-text rb" placeholder="제목으로 검색"/>
		<button type="button" class="search-text-button">검색</button>
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