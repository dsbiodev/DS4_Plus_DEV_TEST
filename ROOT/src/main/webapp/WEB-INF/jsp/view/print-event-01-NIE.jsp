<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
	@media print{
		* {
		    -webkit-print-color-adjust: exact !important;   /* Chrome, Safari 6 – 15.3, Edge */
		    color-adjust: exact !important; /*Firefox*/
		} 	
		
		header, .main-left-wrap, .popup-mask { display:none; }
		.main-contents-wrap { display:block; }
	}
 	@page { size: A4 portrait; margin:25px 0px 0px 15px; } 
	.main-left-wrap { display:none; }
	.main-contents-wrap { padding-left:0px !important; background:#FFF; }
	
 	.page { display:inline-block; width:100%; padding:0px 55px; background:#fff; }
 	.print-title { width:1075px; text-align:center; font-size:40px; letter-spacing:15px; margin-bottom:50px; margin-top:50px;  } 
 	.print-title2 { width:1075px; text-align:left; font-size:20px; word-spacing:10px; margin-bottom:10px; } 
 	.print-title3 { width:1075px; text-align:center; font-size:33px; padding:50px 0px; }
 	.sealClassWrap { width : 1075px; text-align:center;} 
 	/* .print-title4 { width:1075px; text-align:center; font-size:40px; letter-spacing:10px; } */
	.print-title4 {font-size:40px; letter-spacing:10px; float:center; display:inline-block}
	


 	.print-table { width:1035px; border:2px solid #000; text-align:center; font-size:20px; position:relative; z-index:1000; border-collapse:collapse; } 
 	.print-table tr td { border:2px solid #000; height:60px; } 
 	.print-table .family-name { text-align:left; padding-left:10px; }
 	
 	.print-table2 { width:1035px; border:2px solid #000; text-align:center; font-size:20px; position:relative; z-index:1000; border-collapse:collapse; }
 	.print-table2 tr td { border:2px solid #000; height:50px; }
   	.bg { position:relative; }
   	.div-bg-title { position:relative; width:100%; height:100%; display:flex; align-items:center; justify-content:center; z-index:100; }
	.img-box { width:1035px; text-align:center; }
	.img-box .logo-img { width:100px; height:auto; }
	
	.sealImg { display:inline-block;}
	
</style>
<script>
	$(function() {
		
		// 장례확인서
		var _param = JSON.parse('${data}');
		var _arr = location.pathname.split('/');
		$('.ajax-loading').remove();
		$.pb.ajaxCallHandler('/adminSec/selectEventConfirmPrintList.do', { eventNo : _arr[_arr.length-1] }, function(data) {
			var totInfo=data.info;
			var _info = data.info[0];
			
			
			$('.dm-name').text(_info.DM_NAME);
			//$('.gender').text(_info.DM_GENDER == 1 ? "남자" : "여자");
			//HYH 성별 추가
			var selGender="";
			/* $('.gender').text(_info.DM_GENDER == 1 ? "남자" : "여자"); */
			if(_info.DM_GENDER == 0){
				$('.gender').text('');
			}else if(_info.DM_GENDER == 1){
				$('.gender').text('남');
			}else if(_info.DM_GENDER == 2){
				$('.gender').text('여');
			}else if(_info.DM_GENDER == 3){
				$('.gender').text('男');
			}else if(_info.DM_GENDER == 4){
				$('.gender').text('女');
			}
			// ./HYH 성별 추가
			
			$('.age').text(_info.DM_AGE);
			$('.addr').text(_info.DM_ADDR+" "+_info.DM_ADDR_DETAIL);
			$('.religion').text(_info.DM_RELIGION);
			$('.funeral-system').text(_info.FUNERAL_SYSTEM);
			$('.burial').text(_info.BURIAL_PLOT_NAME ? _info.BURIAL_PLOT_NAME : "미정");
			
			$('.dead-dt').text(_info.DEAD_DT);
			$('.entrance-dt').text(_info.ENTRANCE_ROOM_DT);
			
			
			
			/* $('.entrance-start-dt').text(_info.ENTRANCE_ROOM_NO ? _info.ENTRANCE_ROOM_START_DT : ''); */
			if(_info.ENTRANCE_ROOM_NO){
				if(_info.IPGWAN_YN==1){
					$('.entrance-start-dt').text(_info.ENTRANCE_ROOM_START_DT);
				}else{
					$('.entrance-start-dt').text('-');
				}
			}else{
				$('.entrance-start-dt').text('-');
			}
			
			
			
			$('.carrying-dt').text(_info.CARRYING_YN == 1 ? _info.CARRYING_DT : '');
			
			if(_info.LOGO_IMG) $('.logo-img').attr('src', _info.LOGO_IMG);
			else $('.img-box').remove();
			
			/* 직인이미지 */
			if(_info.SEAL_IMG) $('.seal-img').attr('src', _info.SEAL_IMG);
			else $('.img-box').remove();
			
			
			$('.print-title2').text("["+_info.FUNERAL_NAME+"] "+new Date().format('yyyy년 MM월 dd일 E'));
			$('.print-title4').text(_info.FUNERAL_NAME);
			
			$.each(data.family, function(idx, value){
				$('.family:eq('+idx+')').text(value.RELATION);
				$('.family-name:eq('+idx+')').text(value.NAME);
				if(idx == 13) return false; // HYH - modify
			});
			$('.binso').text(data.binso[0].APPELLATION);


			/* 프린트 하기 LSH modify 2023.02.14 */
			//$('.page').css('margin-left', '15px');			
			setTimeout(function() {
				window.print();
				window.close();
			}, 500);				
			
		});
		
	});
	
</script>



<div class="page" id="page">
	<div class="print-title">[ 장 례 확 인 서 ]</div>
	<div class="print-title2"></div>
	<table class="print-table">
		<tr>
			<td rowspan="4" class="bg" style="width:140px; "><div style="width:100%; height:100%; ">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:138px; height:238px; right:0; left:0; top:0;"></div>
				<div class="div-bg-title">고인</div>
			</div></td>
			<td class="bg" style="width:140px;"><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:138px; height:58px; right:0; left:0; top:0; "></div>
				<div class="div-bg-title">성명</div>
			</div></td>
<!-- 			<td class="bg"> -->
<!-- 				<img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:100%; height:100%; right:0; left:0; top:0; "> -->
<!-- 				<div style="position:relative; z-index:100">본관</div> -->
<!-- 			</td> -->
			<td class="bg" style="width:190px;"><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:188px; height:58px; right:0; left:0; top:0; "></div>
				<div class="div-bg-title">성별</div>
			</div></td>
			<td class="bg" style="width:190px;"><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:188px; height:58px; right:0; left:0; top:0;"></div>
				<div class="div-bg-title">나이</div>
			</div></td>
			<td class="bg" ><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:100%; height:58px; right:0; left:0; top:0;  "></div>
				<div class="div-bg-title">주소</div>
			</div></td>
		</tr>
		<tr>
			<td class="dm-name"></td>
<!-- 			<td class=""></td> -->
			<td class="gender"></td>
			<td class="age"></td>
			<td class="addr"></td>
		</tr>
		<tr>
			<td class="bg"><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:100%; height:100%; right:0; left:0; top:0; padding:1 1 1 1; "></div>
				<div class="div-bg-title">종교</div>
			</div></td>
			<td colspan="2" class="bg"><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:100%; height:100%; right:0; left:0; top:0; padding:1 1 1 1; "></div>
				<div class="div-bg-title">매장/화장</div>
			</div></td>
			<td class="bg"><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:100%; height:100%; right:0; left:0; top:0; padding:1 1 1 1; "></div>
				<div class="div-bg-title">장지</div>
			</div></td>
		</tr>
		<tr>
			<td class="religion"></td>
			<td colspan="2" class="funeral-system"></td>
			<td class="burial"></td>
		</tr>
		<tr>
			<td rowspan="13" class="bg" style="width:140px; "><div style="width:100%; height:100%;"> <!-- HYH - modify -->
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:138px; height:100%; right:0; left:0; top:0;"></div>
				<div class="div-bg-title">상주</div>
			</div></td>
			<td class="bg" style="width:140px; "><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:138px; height:100%; right:0; left:0; top:0;"></div>
				<div class="div-bg-title">관계</div>
			</div></td>
			<td colspan="4" class="bg"><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:100%; height:100%; right:0; left:0; top:0;"></div>
				<div class="div-bg-title">성명</div>
			</div></td>
		</tr>
		<!-- HYH 수정 - 4line Add -->
		<tr><td class="family"></td><td colspan="4" class="family-name"></td></tr>
		<tr><td class="family"></td><td colspan="4" class="family-name"></td></tr>
		<tr><td class="family"></td><td colspan="4" class="family-name"></td></tr>
		<tr><td class="family"></td><td colspan="4" class="family-name"></td></tr>
		<tr><td class="family"></td><td colspan="4" class="family-name"></td></tr>
		<tr><td class="family"></td><td colspan="4" class="family-name"></td></tr>
		<tr><td class="family"></td><td colspan="4" class="family-name"></td></tr> 
		<tr><td class="family"></td><td colspan="4" class="family-name"></td></tr>
		<tr><td class="family"></td><td colspan="4" class="family-name"></td></tr>
		<tr><td class="family"></td><td colspan="4" class="family-name"></td></tr>
		<tr><td class="family"></td><td colspan="4" class="family-name"></td></tr>
		<tr><td class="family"></td><td colspan="4" class="family-name"></td></tr>



	</table>
	<table class="print-table2" style="margin-top:-2px;">
		<tr>
			<td rowspan="2" class="bg" style="width:140px; "><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:138px; height:100%; right:0; left:0; top:0;"></div>
				<div class="div-bg-title">안치현황</div>
			</div></td>
			<td class="bg" style="width:140px; "><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:138px; height:100%; right:0; left:0; top:0;"></div>
				<div class="div-bg-title">빈소</div>
			</div></td>
			<td class="bg" style="width:190px; "><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:188px; height:100%; right:0; left:0; top:0;"></div>
				<div class="div-bg-title">사망일시</div>
			</div></td>
			<td class="bg" style="width:190px; "><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:188px; height:100%; right:0; left:0; top:0;"></div>
				<div class="div-bg-title">입실일시</div>
			</div></td>
			<td class="bg"  style="width:190px; "><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:188px; height:100%; right:0; left:0; top:0;"></div>
				<div class="div-bg-title">입관일시</div>
			</div></td>
			<td class="bg"><div style="width:100%; height:100%;">
				<div><img src="/resources/img/th_gray.png" style="position:absolute; z-index:9; width:100%; height:100%; right:0; left:0; top:0;"></div>
				<div class="div-bg-title">발인일시</div>
			</div></td>
		</tr>
		<tr>
			<td class="binso"></td>
			<td class="dead-dt"></td>
			<td class="entrance-dt"></td>
			<td class="entrance-start-dt"></td>
			<td class="carrying-dt"></td>
		</tr>
	</table>
	
	
	<div class="print-title3">위와 같이 故<div class="dm-name" style="display:inline-block;">홍길동</div>님의 장례식장에 참석하였음을 확인하여 드립니다.</div>
	<!-- <div class="img-box">
		<img class="logo-img" src="">
	</div> -->
	
	<div class="sealClassWrap">
		<div class="print-title4">*인천사랑병원장례식장</div>
		<div class="sealImg" style="dsiplay:inline-block; "><img class="seal-img" src=""></div>
	</div>
	<style>
		
	</style>
	
	
</div>
