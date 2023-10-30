<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		var searchObj = $.extend({}, _param);
		searchObj.order = 'A.CREATE_DT DESC';

		var _table = $('.t1 .pb-table.rasp01');
		var theadObj = { table: _table };
		theadObj.colGroup = new Array(40, 30, 30);
		theadObj.theadRow = new Array(['', '장례식장명'], ['', '빈소명'], ['', '아이디']);
		theadInit(theadObj, function(_orderText) { 
			searchObj.order = _orderText;
		});
		
		var _table2 = $('.t2 .pb-table.rasp02');
		var theadObj2 = { table: _table2 };
		theadObj2.colGroup = new Array(40, 30, 30);
		theadObj2.theadRow = new Array(['', '장례식장명'],['', '빈소명'], ['', '아이디']);
		theadInit(theadObj2, function(_orderText) { 
			searchObj.order = _orderText;
			createTable(searchObj); 
		});
		
		$('.main-contents-wrap').find('.search-text-button1').on('click', function() {
			searchObj.searchText = $(this).prev('.search-text1').val();
			createTable1(searchObj);
		});
		$('.main-contents-wrap').find('.search-text-button2').on('click', function() {
			searchObj.searchText = $(this).prev('.search-text2').val();
			createTable2(searchObj);
		});
		
		$('.search-right-wrap1 .search-text1').on('keyup', function(e) {
			if(e.keyCode == 13) $(this).next('.search-text-button1').trigger('click');
		});
		$('.search-right-wrap2 .search-text2').on('keyup', function(e) {
			if(e.keyCode == 13) $(this).next('.search-text-button2').trigger('click');
		});
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectRaspberryList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');
				_table2.find('tbody').html('');
				
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td class="c">'+this.FUNERAL_NAME+'</td>');
					_tr.append('<td class="c">'+this.APPELLATION+'</td>');
					_tr.append('<td class="c">'+this.RASPBERRY_ID+'</td>');
					_tr.on('click', function() {
	 					$('.pb-table.rasp01').find('tbody tr').removeClass('ac');
						_tr.addClass('ac');
					});
					_table.find('tbody').append(_tr);
				});
				
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td class="c">'+this.FUNERAL_NAME+'</td>');
					_tr.append('<td class="c">'+this.APPELLATION+'</td>');
					_tr.append('<td class="c">'+this.RASPBERRY_ID+'</td>');
					_tr.on('click', function() {
	 					$('.pb-table.rasp02').find('tbody tr').removeClass('ac');
						_tr.addClass('ac');
					});
					_table2.find('tbody').append(_tr);
				});
			});
		}
		createTable(searchObj);
		
		var createTable1 = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectRaspberryList.do', _searchObj, function(tableData) {
				_table.find('tbody').html('');				
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td class="c">'+this.FUNERAL_NAME+'</td>');
					_tr.append('<td class="c">'+this.APPELLATION+'</td>');
					_tr.append('<td class="c">'+this.RASPBERRY_ID+'</td>');
					_tr.on('click', function() {
	 					$('.pb-table.rasp01').find('tbody tr').removeClass('ac');
						_tr.addClass('ac');
					});
					_table.find('tbody').append(_tr);
				});
			});
		}
		var createTable2 = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectRaspberryList.do', _searchObj, function(tableData) {
				_table2.find('tbody').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<tr>');
					_tr.data(this);
					_tr.append('<td class="c">'+this.FUNERAL_NAME+'</td>');
					_tr.append('<td class="c">'+this.APPELLATION+'</td>');
					_tr.append('<td class="c">'+this.RASPBERRY_ID+'</td>');
					_tr.on('click', function() {
	 					$('.pb-table.rasp02').find('tbody tr').removeClass('ac');
						_tr.addClass('ac');
					});
					_table2.find('tbody').append(_tr);
				});
			});
		}
		
		
		$('.btn-change').on('click', function() {
			if($('.pb-table.rasp01 > tbody > tr.ac').length == 0) return alert("고장난 라즈베리를 선택해 주세요.");
			if($('.pb-table.rasp01 > tbody > tr.ac').length > 1) return alert("고장난 라즈베리를  하나만 선택해 주세요.");
			if($('.pb-table.rasp02 > tbody > tr.ac').length == 0) return alert("교체할 라즈베리를 선택해 주세요.");
			if($('.pb-table.rasp02 > tbody > tr.ac').length > 1) return alert("교체할 라즈베리를  하나만 선택해 주세요.");
			
			$.pb.ajaxCallHandler('/admin/raspberryChange.do', { 
				wrongRaspNo : $('.pb-table.rasp01 > tbody > tr.ac').data('RASPBERRY_CONNECTION_NO'),
				wrongRaspberryId:$('.pb-table.rasp01 > tbody > tr.ac').data('RASPBERRY_ID'), 
				raspNo : $('.pb-table.rasp02 > tbody > tr.ac').data('RASPBERRY_CONNECTION_NO'),
				raspberryId:$('.pb-table.rasp02 > tbody > tr.ac').data('RASPBERRY_ID'), 
					}, function(data) {
				alert('라즈베리가 교체되었습니다.');
			});
			
// 			$.pb.ajaxCallHandler('/admin/raspberryChange.do', { wrongRaspberryId:$('.pb-table.rasp01 > tbody > tr.ac').data('RASPBERRY_ID'), raspberryId:$('.pb-table.rasp02 > tbody > tr.ac').data('RASPBERRY_ID') }, function(data) {
// 				alert('라즈베리가 교체되었습니다.');
// 			});
		});
		

		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<style>

	tbody {display:block;height:600px;overflow-y:scroll;}
	thead, tbody tr { display:table;width:100%;table-layout:fixed;/* even columns width , fix width of table too*/}
	thead {width: 100%;/* scrollbar is average 1em/16px width, remove it from thead width */}
	table { width:400px;}
	tbody {-ms-overflow-style: none; /* IE and Edge */scrollbar-width: none; /* Firefox */}
	tbody::-webkit-scrollbar {display: none; /* Chrome, Safari, Opera*/}
	.search-text-button1 {width: 200px;height: 48px; border-radius: 4px;background: #157FFB;color: #FFFFFF;font-size: 18px;font-weight: 500; letter-spacing: 0.9px;vertical-align: top;}
	.search-text-button2 {width: 200px;height: 48px; border-radius: 4px;background: #157FFB;color: #FFFFFF;font-size: 18px;font-weight: 500; letter-spacing: 0.9px;vertical-align: top;}
    
	.main-contents-wrap > .search-box-wrap { padding:0px 0 13px 0; }
	.main-contents-wrap > .contents-body-wrap { display:inline-flex; height:calc(100vh - 200px); }
	.main-contents-wrap > .search-box-wrap > .search-left-wrap { display:flex;}
	.search-title { width:49%; }
	.pb-table.list > tbody > tr.ac { background: #fdce0c; }
	.search-btn-wrap { text-align:right; margin-top:17px; }
	.search-btn-wrap .btn-change { margin-bottom: 13px; width:200px; height:48px; border-radius:4px; background:#157FFB; color:#FFFFFF; font-size:18px; font-weight:500; letter-spacing:0.9px; vertical-align:top; float:left;}
</style>
<div class="contents-title-wrap">
	<div class="title">라즈베리 단말 교체</div>
</div>
<div class="search-box-wrap">
	<div class="search-btn-wrap">
		<button type="button" class="btn-change">교체하기</button>
	</div>
</div>
<div class="contents-body-wrap">
	<div class="t1" style="width:40%; height:600px;padding:2px;">
		<div class="search-right-wrap1" style="width:100%;height:40px;">
			<input type="text" class="search-text1" placeholder="고장난 라즈베리를 입력하세요." style="width:80%;height:40px;"/>
			<button type="button" class="search-text-button1" style="width:19%;height:40px;">검색</button>
		</div>
		<table class="pb-table list rasp01" style="width:100%;height:100%;">
			<colgroup></colgroup>
			<thead></thead>
			<tbody></tbody>
		</table>
	</div>
	<div class="t2" style="width:40%; height:600px;padding:2px;">
		<div class="search-right-wrap2">
			<input type="text" class="search-text2" placeholder="교체할 라즈베리를 입력하세요." style="width:80%;height:40px;"/>
			<button type="button" class="search-text-button2" style="width:19%;height:40px;">검색</button>
		</div>
		<table class="pb-table list rasp02" style="width:100%;height:100%;">
			<colgroup></colgroup>
			<thead></thead>
			<tbody></tbody>
		</table>	
	</div>
	

</div>