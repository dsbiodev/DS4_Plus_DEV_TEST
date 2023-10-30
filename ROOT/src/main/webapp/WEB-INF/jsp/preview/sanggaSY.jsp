<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<!-- 	<link rel="stylesheet" type="text/css" href="/resources/playbench/css/pb-common.css"> -->
<%-- 	<jsp:include page="/WEB-INF/jsp/common/meta.jsp"></jsp:include> --%>
<!-- 	<script type="text/javascript" src="/resources/js/jquery-3.2.1.min.js"></script> -->
<!-- 	<script type="text/javascript" src="/resources/playbench/playbench.js"></script> -->
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$.pb.ajaxCallHandler('/admin/selectSanggaList.do', { order:'EXPOSURE ASC, APPELLATION ASC', funeralNo:_param.funeralNo, statusPlate:true }, function(data) {
	        $.each(data.list, function(idx){
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.binso div').html(this.APPELLATION);
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.goin div').html(this.DM_NAME ? '<div class="goin-wrap"><div class="goin-box">故 '+this.DM_NAME + '</div></div>' + (this.DM_POSITION ? '<div class="po-wrap"><div class="po-box">(' + this.DM_POSITION +')</div></div>' : '') : '');
				autoFontSize($('.sangga-container table tbody tr:eq('+idx+')').find('.goin-box'), $('.sangga-container table tbody tr:eq('+idx+')').find('.goin-wrap'));
				autoFontSize($('.sangga-container table tbody tr:eq('+idx+')').find('.po-box'), $('.sangga-container table tbody tr:eq('+idx+')').find('.po-wrap'));
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.gender div').html((this.DM_GENDER ? (this.DM_GENDER == 1 ? '남' : '여') : '') + (this.DM_AGE ? '<br>'+this.DM_AGE : ''));
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.sangju div').html((this.CM_NAME ? this.CM_NAME : '') + (this.CM_BAP_NAME ? '<br>(' + this.CM_BAP_NAME +')' : ''));
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.jangso div').html(this.DM_NAME ? this.DEAD_PLACE : '');
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.jonggyo div').html(this.RELIGION_TXT ? this.RELIGION_TXT : '');
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.ipsil div').html(this.ENTRANCE_ROOM_DT ? new Date(this.ENTRANCE_ROOM_DT).format('MM월dd일<br>HH:mm') : '');
	        	
// 	        	var date = new Date();
// 	        	date.setTime(new Date().getTime() - (1 * 24 * 60 * 60 * 1000)); //1일전
	        	//입관일 1 2 구분해 
	        	
	        	var _ipGwan = this.ENTRANCE_ROOM_START_DT ? new Date(this.ENTRANCE_ROOM_START_DT).format('MM월dd일<br>HH:mm') : '';
	        	if(this.ENTRANCE_ROOM_NO == 1852) _ipGwan += "(2)"
	        	
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.ipgwan div').html(_ipGwan);
	        	if(new Date() > new Date(this.ENTRANCE_ROOM_END_DT)) $('.sangga-container table tbody tr:eq('+idx+')').find('.ipgwan div').html("완료");
	        		
// 	        	if(new Date() > new Date(this.ENTRANCE_ROOM_START_DT) && new Date() < new Date(this.ENTRANCE_ROOM_END_DT)) $('.sangga-container table tbody tr:eq('+idx+')').find('.ipgwan').addClass('ing')
// 	        	if(new Date() > new Date(this.ENTRANCE_ROOM_END_DT)) $('.sangga-container table tbody tr:eq('+idx+')').find('.ipgwan').addClass('end')
	        	if(new Date().format('yyyyMMdd') == new Date(this.ENTRANCE_ROOM_END_DT).format('yyyyMMdd') && new Date() < new Date(this.ENTRANCE_ROOM_END_DT)) $('.sangga-container table tbody tr:eq('+idx+')').find('.ipgwan div').html("*" + $('.sangga-container table tbody tr:eq('+idx+')').find('.ipgwan div').html())
	        	
// 	        	노란색은 하루전
// 	        	검은색은 지난거
// 	        	var date = new Date();
// 	        	date.setTime(new Date().getTime() - (1 * 24 * 60 * 60 * 1000)); //1일전
	        	
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.balin div').html(this.CARRYING_YN == 1 ? new Date(this.CARRYING_DT).format('MM월dd일<br>HH:mm') : '');
	        	if(this.CARRYING_YN == 1 && new Date().format('yyyyMMdd') == new Date(this.CARRYING_DT).format('yyyyMMdd') && new Date() < new Date(this.CARRYING_DT)) 
	        		$('.sangga-container table tbody tr:eq('+idx+')').find('.balin div').html("*" + $('.sangga-container table tbody tr:eq('+idx+')').find('.balin div').html())
// 	        	if(new Date(date.format('yyyy-MM-dd 00:00')) > new Date(this.ENTRANCE_ROOM_END_DT)) $('.sangga-container table tbody tr:eq('+idx+')').find('.ipgwan').addClass('ing')
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.jangji div').css('white-space', 'pre-wrap').html(this.BURIAL_PLOT_NAME ? this.BURIAL_PLOT_NAME : '');
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.sangjo div').css('white-space', 'pre-wrap').html(this.CARRYING_PLACE ? this.CARRYING_PLACE : '');
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.jindan div').html(this.DIAGNOSIS_YN == 1 ? 'O' : '');
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.insoo div').html(this.INSU_YN == 1 ? 'O' : '');
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.jungsan div').html(this.CAL_YN == 1 ? 'O' : '');
	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.bigo div').css('white-space', 'pre-wrap').html(this.BIGO ? this.BIGO : '');
// 	        	$('.sangga-container table tbody tr:eq('+idx+')').find('.yesig div').html(this.CEREMONY_YN == 1 ? new Date(this.CEREMONY_DT).format('MM월dd일<br>HH:mm') : '');
    		});
		})
	});
</script>
</head>
<style> 
	html { width:1920px;height:1080px;min-width:0px; }
 	.sangga-container { width:100%; height:100%; font-family: nanumMyeongjoBold; } 
	
	.sangga-container table {width:100%; height:100%; border-collapse: collapse; table-layout: fixed; }
	.sangga-container table thead { color: #FFF; font-size: 24px; text-align: center; font-weight: bold; line-height: 1.2;  letter-spacing: 9.6px; }
	.sangga-container table thead tr { height: 59px; background-image: url("/resources/img/syu/sangga_top.png"); background-size: 100% 100%; background-repeat: no-repeat; }
	.sangga-container table thead tr th { border: 1px solid #707070; box-sizing: border-box; }
	.sangga-container table tbody { }
 	.sangga-container table tbody tr { color: #000; background: #ffffe8; height: 58px; text-align: center; /* font-weight: bold; */ font-size: 20px;  line-height: 1.2; } 
	.sangga-container table tbody tr:nth-child(2n) { background: #ebf5ff; }
	.sangga-container table tbody tr td { border: 1px solid #707070; box-sizing: border-box; }
	.sangga-container table tbody tr td div { max-height: 55px; overflow:hidden; white-space:nowrap; text-overflow:ellipsis; }
	.sangga-container table tbody tr td.goin div { overflow:initial; white-space: pre-wrap; text-overflow: initial; }
	.sangga-container table tbody tr td.goin .goin-wrap { height:24px; }
	.sangga-container table tbody tr td.goin .goin-wrap .goin-box { font-size: 20px; }
	.sangga-container table tbody tr td.goin .po-wrap { height:24px; }
	.sangga-container table tbody tr td.goin .po-wrap .po-box { font-size: 20px; }
	.sangga-container table tbody tr td.ing { background: #fdce0c; }
	.sangga-container table tbody tr td.end { background: #c4c4c4; }
	.sangga-container table tfoot { color: #FFF; }
	.sangga-container table tfoot tr { height: 34px; background-image: url("/resources/img/syu/sangga_bottom.png"); background-size: 100% 100%; background-repeat: no-repeat; }
	.sangga-container table tfoot tr td { border: 1px solid #707070; box-sizing: border-box; }
</style>
<body>
	<div class="sangga-container">
		<table>
			<thead>
				<tr>
					<th style="width: 5.6%;">빈소</th>
					<th style="width: 9%;">고인명</th>
					<th style="width: 4.4%;">성별</th>
					<th style="width: 6.4%;">상주</th>
					<th style="width: 5.1%;">장소</th>
					<th style="width: 6%;">종교</th>
					<th style="width: 6.3%;">입실</th>
					<th style="width: 6.3%;">입관</th>
					<th style="width: 6.3%;">발인</th>
					<th style="width: 9.5%;">장지</th>
					<th style="width: 7.5%;">상조</th>
					<th style="width: 2.9%; letter-spacing:0px;">진단</th>
					<th style="width: 2.9%; letter-spacing:0px;">인수</th>
					<th style="width: 2.9%; letter-spacing:0px;">정산</th>
					<th style="width: 20%;">비고</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
				<tr>
					<td class="binso"><div></div></td>
					<td class="goin"><div></div></td>
					<td class="gender"><div></div></td>
					<td class="sangju"><div></div></td>
					<td class="jangso"><div></div></td>
					<td class="jonggyo"><div></div></td>
					<td class="ipsil"><div></div></td>
					<td class="ipgwan"><div></div></td>
					<td class="balin"><div></div></td>
					<td class="jangji"><div></div></td>
					<td class="sangjo"><div></div></td>
					<td class="jindan"><div></div></td>
					<td class="insoo"><div></div></td>
					<td class="jungsan"><div></div></td>
					<td class="bigo"><div></div></td>
				</tr>
			</tbody>
			<tfoot>
				 <tr>
					<td colspan="16"></td>
				</tr>
			</tfoot>
	
	</table>
</div>
</body>

</html>