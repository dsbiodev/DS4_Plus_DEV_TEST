<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = $.extend({}, _param);
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
		searchObj.display = (_param.display ? _param.display:15);
		searchObj.lv = (_param.lv == 90 ? '90, 91':_param.lv);
		searchObj.order = 'MATERIAL_NO DESC';
		
		var _table = $('.contents-body-wrap .pb-table.list');
		var theadObj = { table: _table };
		theadObj.colGroup = new Array(5, '*', 10, 10);
		theadObj.theadRow = new Array(['', '번호'], ['', '제목'], ['', '파일다운로드'], ['', '등록일']);
		
		theadInit(theadObj, function(_orderText) { 
			searchObj.order = _orderText;
			createTable(searchObj);
		});
		
		if('${sessionScope.loginProcess.FUNERAL_NO}') {
			$('#btnRegister, .top-button.register, .top-button.delete, .top-button.pb-popup-close').remove();
			$('input[name=title], textarea[name=contents]').attr('readonly', true);
			$('#btnFileUpload').on('click', function() { 
				var _data = $(this).data();
				$(location).attr('href', '/common/fileDownload?filePath='+_data.FILE_PATH+'&fileName='+encodeURI(_data.ORI_FILE_NAME)); 
			}).html('다운로드');
		} else {
			$('#btnFileUpload').on('click', function() { $(this).siblings('input[type=file]').trigger('click'); }).html('파일첨부');
			$('input[type=file]').on('change', function() {
				var _ = $(this);
				if(_.val()) {
					var _fileName = _[0].files[0].name;
					if(/(\.png|\.jpg|\.jpeg|\.gif|\.pdf|\.exe)$/i.test(_fileName) == false) { 
						alert("png, jpg, gif, pdf, exe 형식의 파일을 선택하십시오");
						$(this).val('');
					} else {
						$.each(_[0].files, function(idx) {
							var _thisFile = this;
							var reader = new FileReader();
							reader.onload = function(rst) {
								_.siblings('.form-text').val(_fileName);
							};
							
							reader.readAsDataURL(_thisFile);
						});
					}
				}
			});
		}
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectMaterialList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx;
					_tr.append('<td class="c">'+_tableNo+'</td>');
					_tr.append('<td class="c">'+this.TITLE+'</td>');
					_tr.append('<td class="c download"><img src="/resources/img/icon_download.svg" class="down"/>다운로드</a></td>');
					_tr.append('<td class="c">'+this.CREATE_DT+'</td>');
					_tr.on('click', function(e) {
						if($(e.target).hasClass('download') || $(e.target).hasClass('down')) {
							$(location).attr('href', '/common/fileDownload?filePath='+_tr.data('FILE_PATH')+'&fileName='+encodeURI(_tr.data('ORI_FILE_NAME')));
						} else {
							$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
								_thisLayer.find('.top-button.register').val(_tr.data('MATERIAL_NO'));
								_thisLayer.find('.top-button.delete').val(_tr.data('MATERIAL_NO')).show();
								_thisLayer.find('#btnFileUpload').data(_tr.data());
								layerInit(_thisLayer, _tr.data());
							});
						}
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
				_thisLayer.find('.top-button.register').val('');
				_thisLayer.find('.top-button.delete').val('').hide();
				layerInit(_thisLayer);
			});
		});
		
		$('.pb-right-popup-wrap .top-button.register').on('click', function() {
			var _btnValue = $(this).val();
			if(!$('input[name=oriFileName]').val()) return alert("파일을 등록해 주세요.");
			if(_btnValue || !necessaryChecked($('#dataForm'))) {
				var _uploadUrl = _btnValue ? '/admin/updateMaterial.do':'/admin/insertMaterial.do';
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('actionUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('materialNo', _btnValue ? _btnValue:'');
				
				$.pb.ajaxUploadForm(_uploadUrl, _formData, function(result) {
					if(result) {
						closeLayerPopup();
						createTable(searchObj);
					} else alert('저장 실패 관리자에게 문의하세요');
				}, true);
			}else{
				if(!$('input[name=title]').val()) return alert("제목을 입력해 주세요.");
			}
		});
		
		$('.pb-right-popup-wrap .top-button.delete').on('click', function() {
			var _materialNo = $(this).val();
			
			if(confirm('삭제하시겠습니까?')) {
				$.pb.ajaxCallHandler('/admin/deleteMaterial.do', { materialNo:_materialNo }, function(result) {
					if(result) {
						closeLayerPopup();
						createTable(searchObj);
					} else alert('저장 실패 관리자에게 문의하세요');
				});
			}
		});

		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<style>
	td.download { color:#157FFB !important; }
	td img.down { margin-right:8px; vertical-align:top; }
</style>
<form id="dataForm">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-title">자료등록 및 편집</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title">자료정보</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button delete">삭제</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
				</div>
			</div>
			<div class="pb-popup-form">
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title">제목</label>
						<input type="text" class="form-text necessary" name="title" placeholder="제목을 입력해주세요."/>
					</div>
					<div class="row-box">
						<label class="title">파일</label>
						<input type="file" name="filePath"/>
						<input type="text" class="form-text" name="oriFileName" style="width:calc(100% - 256px);" placeholder="파일을 등록해주세요." readonly/>
						<button type="button" class="text-button" id="btnFileUpload"></button>
					</div>
					<div class="row-box">
						<label class="title" style="vertical-align:top;">내용</label>
						<textarea class="form-textarea" name="contents" style="height:480px;"></textarea>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
<div class="contents-title-wrap">
	<div class="title">자료실</div>
	<div class="title-right-wrap">
		<button type="button" class="title-button" id="btnRegister">신규등록</button>
	</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">자료목록</div>
	</div>
<!-- 	<div class="search-right-wrap"> -->
<!-- 		<input type="text" class="search-text rb" placeholder="업체명, 담당자, 아이디로 검색"/> -->
<!-- 		<button type="button" class="search-text-button">검색</button> -->
<!-- 	</div> -->
</div>
<div class="contents-body-wrap">
	<table class="pb-table list">
		<colgroup></colgroup>
		<thead></thead>
		<tbody></tbody>
	</table>
	<div class="paging"></div>
</div>