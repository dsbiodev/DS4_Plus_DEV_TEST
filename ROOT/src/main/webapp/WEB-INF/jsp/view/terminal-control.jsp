<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = $.extend({}, _param);
		searchObj.currentPage = (_param.pk ? _param.pk:1);
		searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:30):0);
		searchObj.display = (_param.display ? _param.display:30);
		searchObj.fcmFlag = true;
		searchObj.order = 'A.CREATE_DT DESC';
		
		var _table = $('.contents-body-wrap .pb-table.list');
		var theadObj = { table: _table };
		
		theadObj.colGroup = new Array(5, 5, '*', 8, 10, 7, 8, 8, 8, 10, 10);
		theadObj.theadRow = new Array(['', '번호'], ['', '<input type="checkbox" name="allCheck">'], ['FUNERAL_NAME', '장례식장'], ['', '명칭'], ['RASPBERRY_ID', '라즈베리 아이디'], ['CLASSIFICATION_NAME', '모드'], ['SYSTEM_FLAG', '연결여부'], ['AUTORIZED_IP', '공인IP'], ['PRIVATE_IP', '사설IP'], ['MEMO', '메모'], ['CREATE_DT', '생성일']);

		theadInit(theadObj, function(_orderText) { 
			searchObj.order = _orderText;
			createTable(searchObj); 
		});
		
		$('.search-box-wrap .search-text-button').on('click', function() {
			searchObj.currentPage = 1;
			searchObj.queryPage = 0;
			//searchObj.dsiplay = 30;
			searchObj.searchText = $(this).prev('.search-text').val();
			searchObj.classification = $('select[name=cla]').val();
			var _pageData = { paging:searchObj };
			var _urlSplit = $(location)[0].pathname.split('/');
			history.pushState(_pageData, '', '/'+_urlSplit[1]+'/1');
			createTable(searchObj);
		});
		
		$('.search-box-wrap .search-text').on('keyup', function(e) {
			if(e.keyCode == 13) $(this).next('.search-text-button').trigger('click');
		});
		
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectRaspberryControlList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					var _tableNo = (tableData.total*1) - ((tableData.currentPage*1 - 1) * (tableData.display*1)) - idx;
					_tr.append('<td class="c">'+_tableNo+'</td>');
					_tr.append('<td class="c"><input type="checkbox" name="chk"></td>');
					_tr.find('input[type="checkbox"][name="chk"]').pbCheckbox({addText:[],fontSize:'18px'});
					_tr.append('<td class="c">'+this.FUNERAL_NAME+'['+this.GUNGU_NAME+']</td>');
					_tr.append('<td class="c">'+this.APPELLATION+'</td>');
					_tr.append('<td class="raspberry-id c">'+this.RASPBERRY_ID+'</td>');
					_tr.append('<td class="c">'+this.CLASSIFICATION_NAME+'</td>');
// 					_tr.append('<td class="system-flag c">'+(this.SYSTEM_FLAG ? '연결' : '미연결')+'</td>');
					_tr.append('<td class="system-flag c">미연결</td>');
					_tr.append('<td class="autorized-ip c">'+(this.AUTORIZED_IP ? this.AUTORIZED_IP : '-')+'</td>');
					_tr.append('<td class="private-ip c">'+(this.PRIVATE_IP ? this.PRIVATE_IP : '-')+'</td>');
					_tr.append('<td>'+this.MEMO+'</td>');
					_tr.append('<td class="c">'+this.CREATE_DT+'</td>');
					_tr.on('click', function() {
						$('.pb-right-popup-wrap').openLayerPopup2({}, function(_thisLayer) {
							_thisLayer.find('.rpi-controll-wrap').data('id', _tr.data('RASPBERRY_ID'));
							_tr.find('input[name=chk]').click();
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
				// 데이터가져온후 소켓통신 연결 
	 			$.pb.ajaxCallHandler('/admin/raspListConnChk.do', tableData, function(data) {})
				console.log("raspListConnChk error chk end", tableData)
			});
			
			
			
		};

		$('input[type="checkbox"][name="allCheck"]').pbCheckbox({addText:[],fontSize:'18px'},
			{checked: function(_this){
				$('input[name=chk]').click();
			},
			unChecked: function(_this){
				$('input[name=chk]:checked').click();
			}
		});
		
		
		$('.rpi-controll-wrap > .controll-item').on('click', function() {
			var _rpiCode = $(this).val();
			var _socketFlag = $(this).data('socketFlag');
			if(!$('input[name=chk]:checked').length) return alert("라즈베리를 체크해 주세요.");
			$.each($('.pb-table.list tbody tr'), function(){
				if($(this).find('input[name=chk]').is(':checked')){
		 			$.pb.ajaxCallHandler('/admin/insertRpiControll.do', { raspberryId:$(this).data('RASPBERRY_ID'), raspberryConnectionNo : $(this).data('RASPBERRY_CONNECTION_NO'), codeValue:_rpiCode, socketFlag : _socketFlag }, function(rpiResult) {
		 			});
				}
			});
			return alert('요청하였습니다.');
		});
		createTable(searchObj);
		
		
		$.getScript('/resources/js/sockjs.js', function(data, textStatus) {
			$.getScript('/resources/js/stomp.js', function(data, textStatus) {
 				var sock = null,
 			    stompClient = null;
		       	sock = new SockJS('/stomp');
		       	stompClient = Stomp.over(sock);    //stomp client 구성
		       	stompClient.connect({}, function(frame){
		          	// subscribe message
		          	stompClient.subscribe('/subscribe/connChk', function(data) {
		    			var jsonObj = JSON.parse(data.body);
		    			$('.pb-table tbody tr').each(function(){
		    				if(jsonObj.raspberryConnectionNo == $(this).data("RASPBERRY_CONNECTION_NO"))
		    					$(this).find('td.system-flag').text('연결');
		    			});
		          	});
	       		});
			});
		});
		
		
		$.getScript('/resources/js/sockjs.js', function(data, textStatus) {
			$.getScript('/resources/js/stomp.js', function(data, textStatus) {
 				var sock = null,
 			    stompClient = null;
		       	sock = new SockJS('/stomp');
		       	stompClient = Stomp.over(sock);    //stomp client 구성
		       	stompClient.connect({}, function(frame){
		          	// subscribe message
		          	stompClient.subscribe('/subscribe/teminal-control', function(data) {
		    			var jsonObj = JSON.parse(data.body);
		    			$('.pb-table tbody tr').each(function(){
		    				if(jsonObj.raspberryId == $(this).find('td.raspberry-id').text()){
		    					$(this).find('td.system-flag').text(jsonObj.systemFlag ? '연결' : '미연결');
		    					$(this).find('td.autorized-ip').text(jsonObj.autorizedIp);
		    					$(this).find('td.private-ip').text(jsonObj.privateIp);
		    				}
		    			});
		          	});
	       		});
			});
		});

		
		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<style>
	.rpi-controll-wrap > .controll-item { height:130px; border:1px solid #707070; background-color:#FFFFFF; background-repeat:no-repeat; background-position:center 16px; color:#333333; font-size:18px; font-weight:500; }
	.rpi-controll-wrap > .controll-item:first-child { margin-left:0; }
	.rpi-controll-wrap > .controll-item:last-child { margin-right:0; }
	.rpi-controll-wrap > .controll-item:hover { background-color:#E9ECEF; }
	.pb-right-popup-wrap { height:100px; top:initial; position:fixed; opacity:1; right:0px;top:0px;}
	.pb-right-popup-wrap > .pb-popup-body { height:100px; padding:0px; }
	.rpi-controll-wrap { margin:0px; }
	.rpi-controll-wrap > .controll-item { width:100px;height:100px;font-size:11px;background-position: center 0px; padding-top: 75px;}
	.pb-right-popup-wrap { width:auto; border:none; background:none; display:block; }
	.main-contents-wrap > .search-box-wrap { margin-top: 30px; }
	.search-mode { width:100px;height:30px; }
	
	@media ( max-width: 700px ) {

		.pb-right-popup-wrap { height:120px; top:0px; position:fixed; opacity:1; right:0px;text-align:right;}
		.rpi-controll-wrap > .controll-item { max-width:100px; width:70px; height:100px;font-size:12px;background-position: center 0px; padding-top: 65px;top:0;}
	}
	
	
</style>

<div class="contents-title-wrap">
	<div class="title"></div>
<form id="dataForm">
	<div class="pb-right-popup-wrap">
		<div class="pb-popup-body">
<!-- 			<div class="popup-body-top"> -->
<!-- 				<div class="top-title"></div> -->
<!-- 				<div class="top-button-wrap"> -->
<!-- 					<button type="button" class="top-button pb-popup-close">취소</button> -->
<!-- 				</div> -->
<!-- 			</div> -->
			<div class="rpi-controll-wrap">
				<button type="button" class="controll-item" style="background-image:url('/resources/img/icon_rpi_controll_01.svg');" value="1" data-socket-flag="3">화면갱신</button>
				<button type="button" class="controll-item" style="background-image:url('/resources/img/icon_rpi_controll_02.svg');" value="2" data-socket-flag="5">연결체크</button>
				<button type="button" class="controll-item" style="background-image:url('/resources/img/icon_rpi_controll_03.svg');" value="3" data-socket-flag="6">재실행</button>
				<button type="button" class="controll-item" style="background-image:url('/resources/img/icon_rpi_controll_04.svg');" value="4" data-socket-flag="7">리부팅</button>
				<button type="button" class="controll-item" style="background-image:url('/resources/img/icon_rpi_controll_05.svg');" value="5" data-socket-flag="3">업데이트</button>
			</div>
		</div>
	</div>
</form>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">라즈베리목록</div>
	</div>
	<div class="search-right-wrap">
		<select class="pb-select" name="cla">
			<option value="">전체</option>
			<option value="10">빈소</option>
			<option value="20">영정</option>
			<option value="30">종합</option>
			<option value="40">입관</option>
			<option value="50">특수</option>
		</select>
		<input type="text" class="search-text rb" placeholder="키워드 검색"/>
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