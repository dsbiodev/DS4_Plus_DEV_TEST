<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<script>
	$(function() {
		var _param = JSON.parse('${data}');
				
		$('.event-simple-info-scroll').css('height' , $(window).height() - 159);

		//조회 조건
		var searchObj = $.extend({}, _param);
		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
		
		//date set
		var tmpStdDt = new Date(new Date().getFullYear(), new Date().getMonth(), 1); 
		var stdDt = $.pb.createDateObj(tmpStdDt);
		var edDt = $.pb.createDateObj();
		
		//date comboBox Set
		var searchBox = $('.main-contents-wrap > .contents-title-wrap > .search-box');
		searchBox.find('select[name=sYear]').sysDate('year', { begin:stdDt.year-2, unit:'년', selected:stdDt.year } );
		searchBox.find('select[name=sMonth]').sysDate('month', { unit:'월', selected:stdDt._month } );
		searchBox.find('select[name=sDay]').sysDate('day', { unit:'일', selected:stdDt._day } );
		
		searchBox.find('select[name=eYear]').sysDate('year', { begin:stdDt.year-2, unit:'년', selected:stdDt.year } );
		searchBox.find('select[name=eMonth]').sysDate('month', { unit:'월', selected:edDt._month } );
		searchBox.find('select[name=eDay]').sysDate('day', { unit:'일', selected:edDt._day } );
				
		//table set
		var _table = $('.contents-body-wrap .pb-table.shroudlist');
		
		var theadObj = { table: _table };
		//theadObj.colGroup = new Array(10, 6, 5, 5, 9, 9, 6, 6, 10, 4,9,8,10,10,12);
		theadObj.theadRow = new Array(['', '구분 '],['', '발인일시'], ['', '성명'], ['', '나이'], ['', '성별'], ['', '주민등록번호'], ['', '사망일'], ['', '사인'], ['', '사망장소'], ['', '안치일자'], ['', '약품처리여부'], 
									  ['', '매/화장여부'], ['', '염습일자'],['', '염습처리자'], ['', '상주명'], ['', '상주전화번호']);
		
		//thead init
		theadInit(theadObj, function() { 
			//searchObj.order = _orderText;
			//createTable(searchObj);
		});
		
		//grid display				
		var createTable = function(_searchObj) {
			
			//dto			
			_searchObj.searchStartDt = $('select[name=sYear]').val()+'-'+$('select[name=sMonth]').val()+'-'+$('select[name=sDay]').val();
			_searchObj.searchEndDt = $('select[name=eYear]').val()+'-'+$('select[name=eMonth]').val()+'-'+$('select[name=eDay]').val();
			_searchObj.searchYear = $('select[name=sYear]').val();
			
			$.pb.ajaxCallHandler('/admin/selectShroudNote.do', _searchObj, function(dtResult) {
												
			_table.find('tbody').html('');
			
			if(dtResult.list.length > 0){
									
				var monthVal = '';
				var seq = 1;
							
 				$.each(dtResult.list, function(idx) { 					
 					var _tr = $('<tr>');
 					
 					//월 별 구분 row 					
 					if(monthVal != this.dtMonth){ 						
 						insertRow(this.dtMonth); 		
 						monthVal = this.dtMonth;
 						
 						seq = 1;
 					}
 					 				 				 					 					
 						_tr.data(this);
 											 						
 						var regNum = '-';
 						if(this.dm_reg_number != null){
 							regNum = this.dm_reg_number.substring(0,6) + '-' + this.dm_reg_number.substring(6,13); 							
 						}
 						 						
 						var dmGender = '';
 						if(this.dm_gender == 1){
 							dmGender = '남자';
 						}else if(this.dm_gender ==2){
 							dmGender = '여자';	
 						}else if(this.dm_gender ==3){
 							dmGender = '男子';	
 						}else if(this.dm_gender ==4){
 							dmGender = '女子';	
 						}
 						
 						var drugYn = (this.drug_yn == 1) ? '유' : '무';
 						//var enshrineDt = (this.enshrine_dt == null) ? '' : new Date(this.enshrine_dt).format('yyyy-MM-dd HH:mm'); 						
 						var enshrineDt = (this.enshrine_dt == null) ? '' : new Date(this.enshrine_dt).format('yyyy-MM-dd'); 						
 						var shroudDt = (this.shroud_dt == null) ? '' : new Date(this.shroud_dt).format('yyyy-MM-dd');
 						var shroudMgr = (this.shroud_mgr == null) ? '' :this.shroud_mgr;
 						 						
 						_tr.append('<td class="c">'+seq+'</td>'); 						 						
 						_tr.append('<td class="c">'+new Date(this.carrying_dt).format('yyyy-MM-dd')+'</td>');		
 						_tr.append('<td class="c">'+this.dm_name+'</td>');
 						_tr.append('<td class="c">'+this.dm_age+'</td>');
 						_tr.append('<td class="c">'+dmGender+'</td>');
 						_tr.append('<td class="c">'+regNum+'</td>'); 						
 						_tr.append('<td class="c">'+new Date(this.dead_dt).format('yyyy-MM-dd')+'</td>');
 						_tr.append('<td class="c">'+this.dead_cause+'</td>');
 						_tr.append('<td class="c">'+this.dead_place+'</td>');
 						_tr.append('<td class="c">'+enshrineDt+'</td>');
 						_tr.append('<td class="c">'+drugYn+'</td>');
 						_tr.append('<td class="c">'+this.funeral_system+'</td>');
 						_tr.append('<td class="c">'+shroudDt+'</td>');
 						_tr.append('<td class="c">'+shroudMgr+'</td>');
 						_tr.append('<td class="c">'+this.cm_name+ '</td>');
 						_tr.append('<td class="c">'+$.pb.phoneFomatter(this.cm_phone)+'</td>');
 						
 						_table.find('tbody').append(_tr);
 						
 						//구분 번호
 						seq++
 									
 					}); 																						
			}else{
				alert("해당 일자에 데이터가 존재하지 않습니다.")
			}	 																	
																																																										
			});
		};
		
		try{
			createTable(searchObj);			
		}catch(e){
			throw e;
			
		}
		 
		
		//insert Row		
		function insertRow(MonthVal){
			
			var strYear = MonthVal.substring(0,4);
			var strMonth = MonthVal.substring(5,7);
						
			var table = $('.contents-body-wrap .pb-table.shroudlist');		
			var tr = $('<tr>');
			
			tr.css('background-color','#FFFFB3');			
											
			tr.append('<td class="c">'+strYear + '년 '+ strMonth+ '월'+'</td>');
			tr.append('<td class="c" colspan = "15">'+''+'</td>');			
			
			table.find('tbody').append(tr);					
		}
	

		//조회버튼 클릭 이벤트
		$('#btnSearch').on('click', function() {
						
			//날짜 valid
			var _start = new Date($('select[name=sYear]').val()+'-'+$('select[name=sMonth]').val()+'-'+$('select[name=sDay]').val());
			var _end = new Date($('select[name=eYear]').val()+'-'+$('select[name=eMonth]').val()+'-'+$('select[name=eDay]').val());
			
			var _tDiff = _end.getTime() - _start.getTime();
			_tDiff = Math.floor(_tDiff/(1000 * 60 * 60 * 24));
			
			if(_tDiff < 0) {
				alert('조회일자 시작일이 종료일보다 클 수 없습니다.');
			}else{
				
				createTable(searchObj);				
			}						
		}); 
 
		//엑셀버튼 클릭 이벤트
		$('#btnExcel').on('click', function() {
			FnExcelDown('shroudNoteTbl', '염습대장 리스트');
										
		});  
	});	
	
	
	function FnExcelDown(id, title) {
		
		var tab_text = '<html xmlns:x="urn:schemas-microsoft-com:office:excel">';
		
		tab_text = tab_text + '<head><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8">';
		tab_text = tab_text + '<xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>'
		tab_text = tab_text + '<x:Name>Test Sheet</x:Name>';
		tab_text = tab_text + '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';
		tab_text = tab_text + '</x:ExcelWorksheets></x:ExcelWorkbook></xml>';
		
		tab_text = tab_text + '<style type="text/css">';		
		tab_text = tab_text + '.headerTr {background-color:#c0c0c0; height:35; font-size:12pt; text-align:center;}';
		tab_text = tab_text + '</style>';
		
		tab_text = tab_text + '</head><body>';
		
		tab_text = tab_text + '<table border="1px" style ="text-align:center;">';
		tab_text = tab_text + '<h2 style="text-align:center;">염습 및 위생처리 관리대장</h2>';
		tab_text = tab_text + '<h4>&nbsp;</h4>';
		
		tab_text = tab_text + '<colgroup></colgroup>';		
		tab_text = tab_text + '<thead><tr class="headerTr"><th colspan="">구분 </th><th colspan="">발인일시</th><th colspan="">성명</th><th colspan="">나이</th><th colspan="">성별</th><th colspan="">주민등록번호</th><th colspan="">사망일</th><th colspan="">사인</th><th colspan="">사망장소</th><th colspan="">안치일자</th><th colspan="">약품처리여부</th><th colspan="">매/화장여부</th><th colspan="">염습일자</th><th colspan="">염습처리자</th><th colspan="">상주명</th><th colspan="">상주전화번호</th></tr></thead>';
				
		var exportTable = $('#' + id).find('tbody').clone();
		
						
		tab_text = tab_text + exportTable.html();
		
		tab_text = tab_text + '</table></body></html>';
		console.log(tab_text);
		var data_type = 'data:application/vnd.ms-excel';
		var ua = window.navigator.userAgent;
		var msie = ua.indexOf("MSIE ");
		var fileName = title + '.xls';
		
		//Explorer 환경에서 다운로드
		if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
			if (window.navigator.msSaveBlob) {
			var blob = new Blob([tab_text], {
			type: "application/csv;charset=utf-8;"
			});
			navigator.msSaveBlob(blob, fileName);
			}
		} else {
			var blob2 = new Blob([tab_text], {
			type: "application/csv;charset=utf-8;"
			});
			var filename = fileName;
			var elem = window.document.createElement('a');
			elem.href = window.URL.createObjectURL(blob2);
			elem.download = filename;
			document.body.appendChild(elem);
			elem.click();
			document.body.removeChild(elem);
		}
	}	
</script>
<style>
	.search-box { display:flex; align-items:center; }
	#btnSearch { margin-left:20px; margin-right:20px;}
	#shroudlist th{position:sticky; top:0px;}
	
	@media ( max-width: 700px ) {	
		.main-contents-wrap > .contents-title-wrap > .search-box > .search-select { width:120px; margin-left:0px;padding-left:0px;}
		.main-contents-wrap > .search-box-wrap { margin-top:180px; }
		.main-contents-wrap > .contents-title-wrap > .search-box > .search-text-wrap > .search-text { width:70%; }
		.main-contents-wrap > .contents-title-wrap > .search-box > .search-text-wrap > .search-text-btn { width:28%; }		
	}
		
</style>

<div class="contents-title-wrap">
	<div class="title">염습대장</div>
	<div class="sub-title"><br>※조회일자에 해당하는 염습자 목록을 조회하고 엑셀파일로 다운로드 할 수 있습니다.</div>
	<div class="search-box">조회 일자 : &nbsp;
		<select class="search-select year" name="sYear"></select>
		<select class="search-select month" name="sMonth"></select>
		<select class="search-select day" name="sDay"></select>
		<span class="text"> &nbsp;&nbsp;&nbsp;&nbsp;~ </span>
		<select class="search-select year" name="eYear"></select>
		<select class="search-select month" name="eMonth"></select>
		<select class="search-select day" name="eDay"></select>
		
		<div class="search-text-wrap">		
			<button type="button" class="search-text-btn" id="btnSearch">조 회</button>		
		</div>
		
		<div class="excel-text-wrap">		
		<button type="button" class="excel-text-btn" id="btnExcel">Excel 다운</button>
		</div>		
		
	</div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">검색 결과</div>
	</div>
</div>

- 
<div class="contents-body-wrap">
	<div class="event-simple-info-scroll"  id="event-simple-info-box-scroll">
	<table class="pb-table shroudlist" id="shroudNoteTbl">
		<colgroup></colgroup>
		<thead style = "position:sticky; top:0px;"></thead>
		<tbody></tbody>
	</table>
	</div>
</div> 