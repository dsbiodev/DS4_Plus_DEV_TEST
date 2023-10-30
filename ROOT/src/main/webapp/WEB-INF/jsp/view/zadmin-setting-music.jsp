<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		var searchObj = $.extend({}, _param);
		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
		searchObj.classifications = '10';
		searchObj.statusPlate = true;
		searchObj.eventAliveFlag = true;
		// ENTRANCE_ROOM_DT DESC는 이전행사들 가져와서 덮어주기 때문에 DESC로 가져옴
		searchObj.order = 'EXPOSURE, CLASSIFICATION ASC, APPELLATION ASC, ENTRANCE_ROOM_DT DESC';

		
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
					$('.contents-body-wrap').html("");
				}
			});
			
			$('.select-box-wrap .table-search').on('keyup', function() {
				$('.select-box-wrap .allList > tbody > tr').removeClass('ac');
				$('.select-box-wrap .allList > tbody > tr').hide();
				if($(this).val()) $('.select-box-wrap .allList > tbody td:contains("'+$(this).val()+'")').parent('tr').show();
				else $('.select-box-wrap .allList > tbody > tr').show();
			});
		});
		
		$('#btnFileUpload').on('click', function() { $(this).siblings('input[type=file]').trigger('click'); }).html('파일첨부');
		$('input[type=file]').on('change', function() {
			var _ = $(this);
			if(_.val()) {
				var _fileName = _[0].files[0].name;
				if(/(\.mp3)$/i.test(_fileName) == false) { 
					alert("mp3 형식의 파일을 선택하십시오");
					$(this).val('');
				} else {
					$.each(_[0].files, function(idx) {
						var _thisFile = this;
						var reader = new FileReader();
						reader.onload = function(rst) {
							_.siblings('.form-text').val(_fileName);
						};
						reader.readAsDataURL(_thisFile);
						console.log('readAsDataURL = '+_fileName);

					});
				}
			}
		});
		
		var _table1 = $('.c-1');
		var _table2 = $('.c-2');
		var _table3 = $('.c-3');
		var _table4 = $('.c-4');
		var _tableFuneralMusicList = $('.t-f-list');

		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectFuneralMusic.do', {funeralNo:searchObj.funeralNo}, function(tableData) {
				_tableFuneralMusicList.find('tbody').html('');

				var optTitleList = [];
				var optNoList = [];
				var optionString='';
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					var mNo = this.MUSIC_NO;
					_tr.append('<td>'+this.MUSIC_TITLE+'</td><td><button type="button" id="btnMusicDelete'+idx+'" value='+mNo+' style="width:95%">삭제</div></td>');
					_tableFuneralMusicList.find('tbody').append(_tr);
					optNoList.push(mNo);
					optTitleList.push(this.MUSIC_TITLE);
					
					$('#btnMusicDelete'+idx+'').on('click', function() {						
						if(confirm('삭제하시겠습니까?')) {
							$.pb.ajaxCallHandler('/admin/deleteFuneralMusic.do', { musicNo:mNo }, function(result) {
								if(result) {
									closeLayerPopup();
									createTable(searchObj);
								} else alert('저장 실패 관리자에게 문의하세요');
							});
						}
					});
					
				});

				$.pb.ajaxCallHandler('/admin/selectRaspForMusic.do', {funeralNo:searchObj.funeralNo}, function(raspData) {

					_table1.find('tbody').html('');
					_table2.find('tbody').html('');
					_table3.find('tbody').html('');
					_table4.find('tbody').html('');

					$.each(raspData.list, function(idx) {

						var _tr = $('<tr>');
						var musicNo = this.MUSIC_NO;
						var raspId = this.RASPBERRY_ID;
						optionString = '<option value=0>선택해주세요.</option>';

						if(this.MUSIC_NO!=null){//지정된 음악이 있다면
							$.each(optNoList, function(idx) {
								if(parseInt(optNoList[idx])==parseInt(musicNo)){
									optionString += '<option value='+optNoList[idx]+' selected>'+optTitleList[idx]+'</option>';
								}else{
									optionString += '<option value='+optNoList[idx]+'>'+optTitleList[idx]+'</option>';
								}
							});
						}else{
							$.each(optNoList, function(idx) {
								optionString += '<option value='+optNoList[idx]+'>'+optTitleList[idx]+'</option>';
							});
						}

						var selectHtml = '<select class="form-select" id="select'+idx+'">'+optionString+'</select>';

						_tr.append('<td><div style="width:100%;display:inline-block;">'+this.APPELLATION+'<br/>'+selectHtml+'</div></td>');


						
						if(this.CLASSIFICATION==10){//빈소현황판
							_table1.find('tbody').append(_tr);
						}else if(this.CLASSIFICATION==20){//영정화면
							_table2.find('tbody').append(_tr);
						}else if(this.CLASSIFICATION==40){//입관실
							_table3.find('tbody').append(_tr);
						}else if(this.CLASSIFICATION==50){//특수화면
							_table4.find('tbody').append(_tr);
						}
						$('#select'+idx+'').on('change', function() {						
							if(confirm('음악을 설정/변경하시겠습니까?')) {
								$.pb.ajaxCallHandler('/admin/updateRaspForMusic.do', { musicNo: $(this).val(),raspberryId: raspId}, function(result) {
									if(result) {
										closeLayerPopup();
										createTable(searchObj);
										alert('음악이 설정되었습니다.');
									} else alert('저장 실패 관리자에게 문의하세요');
								});
							}
						});
					});
				});

			});
		};

		createTable(searchObj);


		
		//값 초기화
		$('#btnRegister').on('click', function() {
			$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
				_thisLayer.find('.top-button.register').val('');
				_thisLayer.find('.top-button.delete').val('').hide();
				layerInit(_thisLayer);
			});
		});
		//음원파일 정보 입력
		$('.pb-right-popup-wrap .top-button.register').on('click', function() {
			var _btnValue = $(this).val();
			if(!$('.select-box-wrap .table-search').data('funeralNo')) return alert("장례식장을 먼저 선택해 주세요.");	
			if(!$('input[name=oriFileName]').val()) return alert("파일을 등록해 주세요.");
			if(_btnValue || !necessaryChecked($('#dataForm'))) {
				var _uploadUrl = _btnValue ? '/admin/updateFuneralMusic.do':'/admin/insertFuneralMusic.do';
				var _formData = new FormData($('#dataForm')[0]);
				_formData.append('actionUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('funeralNo', '${sessionScope.loginProcess.FUNERAL_NO}');
				_formData.append('title', $('input[name=title]').val());
				
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
		


		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
		
		
		
		//모바일/PC 스크립트 인식 구분
		var filter = "win16|win32|win64|mac|macintel";
		if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
		//MOBILE
			document.getElementById("title").style.height="100px";
			document.getElementById("t-1").style.width="95%";
			document.getElementById("t-2").style.width="95%";
			document.getElementById("t-3").style.width="95%";
			document.getElementById("t-4").style.width="95%";
			document.getElementById("btnRegister").style.marginTop="14px";
			
			document.getElementById("btnSave").style.width="90px";
			document.getElementById("btnCancel").style.width="90px";
			document.getElementById("pop-sub-title-a").style.width="80px";
			document.getElementById("pop-sub-title-a").style.padding="0px";
			document.getElementById("pop-sub-title-b").style.width="80px";
			document.getElementById("pop-sub-title-b").style.padding="0px";
			document.getElementById("pop-sub-text-a").style.width="50%";
			document.getElementById("pop-sub-text-b").style.width="50%";
			document.getElementById("btnFileUpload").style.width="80px";
			document.getElementById("th").style.width="70%";

		}
		
		

		
	});
</script>
<style>
	.c-1 { min-width:300px; width:23%; display:inline-block; vertical-align:top; margin: 10px; }
	.c-2 { min-width:300px; width:23%; display:inline-block; vertical-align:top; margin: 10px; }
	.c-3 { min-width:300px; width:23%; display:inline-block; vertical-align:top; margin: 10px; }
	.c-4 { min-width:300px; width:23%; display:inline-block; vertical-align:top; margin: 10px; }
	
	table.music-table { width:100%; text-align:center; background-color:#ffffff; }
	table.music-table > tbody > tr.empty { height:41px; }
	table.music-table > tbody > tr.alt { background:#FAFAFA; }
	table.music-table > tbody > tr.ac { background:#98C7FF; }
	table.music-table > tbody > tr.already { background:#A8A8A8; }
	table.music-table > tbody > tr:hover { background:#98C7FF; cursor:pointer; }
	table.music-table > tbody > tr.already:hover { background:#A8A8A8; cursor:default; }
	table.music-table th { height:30px; border:1px solid #707070; background:linear-gradient(to bottom, #FFFFFF, #EBEDEE); color:#333333; font-size:16px; font-weight:500; letter-spacing:0.8px; text-align:center; cursor:pointer; }
	table.music-table td { text-align:left; padding:12px 20px; border:1px solid #707070; color:#333333; font-size:16px; font-weight:500; letter-spacing:0.8px; }
	table.music-table td.c { text-align:center; }
	table.music-table td.r { text-align:right; }
	table.music-table td.l { text-align:left; }
	table.music-table .cancellation { text-decoration:underline; }
	table.music-table .cancellation:hover { color:#E10000; }
	table.music-table > tbody .table-text { width:100%; height:56px; border:1px solid #707070; border-radius:2px; background-color:#F6F6F6; color:#333333; font-size:18px; }

/* 	.arrow { border: solid black;border-width: 0 3px 3px 0;display: inline-block;padding: 3px; }
	.right { transform: rotate(-45deg);-webkit-transform: rotate(-45deg); } */
	
	.form-select { width:calc(100%); height:36px; padding-left:12px; box-sizing:border-box; border:1px solid #707070; border-radius:2px; background-color:#F6F6F6; color:#333333; font-size:16px; font-weight:500; letter-spacing:0.8px; }
	
</style>
<form id="dataForm">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-title">음원 등록 및 편집</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title">신규음원 등록</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register" id="btnSave">저장</button>
					<button type="button" class="top-button delete">삭제</button>
					<button type="button" class="top-button pb-popup-close" id="btnCancel">취소</button>
				</div>
			</div>
			<div class="pb-popup-form">
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title" id="pop-sub-title-a">*음원 제목</label>
						<input type="text" class="form-text necessary" name="title" placeholder="제목을 입력해주세요." id="pop-sub-text-a"/>
					</div>
					<div class="row-box">
						<label class="title" id="pop-sub-title-b">*음원 파일</label>
						<input type="file" name="filePath" id="musicInput"/>
						<input type="text" class="form-text" name="oriFileName" style="width:calc(100% - 256px);" placeholder="파일을 등록해주세요." id="pop-sub-text-b" readonly/>
						<button type="button" class="text-button" id="btnFileUpload"></button>
					</div>
				</div>
			</div>
			<div class="popup-body-top">
				<div class="top-title">음원 관리</div>
			</div>
			<div class="pb-music-table">
				<table class="t-f-list music-table" style="width:100%;">
					<thead>
						<tr>
							<th style="width:80%" id="th">음원제목</th><th style="width:*;" > </th>
						</tr>
					</thead>
					<tbody>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</form>

<div class="select-box-wrap">
	<input type="text" class="form-text table-search">
	<div class="funeral-box">
		<table class="allList">
			<colgroup><col width="100%"/></colgroup>
			<tbody></tbody>
		</table>
	</div>
</div>


<div class="contents-title-wrap" id="title">
	<div class="title">현황판 음원 설정</div>
	<div class="title-right-wrap">
		<button type="button" class="title-button" id="btnRegister">음원 관리</button>
	</div>
</div>
<div class="contents-body-wrap" style=" text-align: left; ">
	<div class="c-1" id="t-1">
		<table class="music-table">
			<thead>
				<tr>
					<th>빈소현황판 음원 설정</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>
	</div>
	<div class="c-2" id="t-2">
		<table class="music-table">
			<thead>
				<tr>
					<th>영정화면 음원 설정</th>
				</tr>
			</thead>			
			<tbody>
			</tbody>
		</table>
	</div>
	<div class="c-3" id="t-3">
		<table class="music-table">
			<thead>
				<tr>
					<th>입관실 음원 설정</th>
				</tr>
			</thead>			
			<tbody>
			</tbody>
		</table>
	</div>
	<div class="c-4" id="t-4">
		<table class="music-table">
			<thead>
				<tr>
					<th>특수화면 음원 설정</th>
				</tr>
			</thead>			
			<tbody>
			</tbody>
		</table>
	</div>
</div>