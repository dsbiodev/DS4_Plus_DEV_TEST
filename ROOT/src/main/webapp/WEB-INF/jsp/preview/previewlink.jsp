<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html style="min-width:auto !important; width:100%">
<style>

.p-container {  width:100%; margin-right: auto; margin-left: auto; padding-left: 13px; padding-right: 13px; max-width: 1200px; }
.preview-link-title { width:100%; height:100px; background-image:url('/resources/img/preview_link_top.png'); background-repeat : no-repeat; background-size : 100% 100%; }
.preview-link-title-wrap { font-family: 'NanumMyeongjoBold'; color:#ffd562; font-size:24px; text-align: center; top: 36px; position: relative; }
.preview-link-mid { width:100%; height:auto; }
.preview-link-table { width: 100%; max-width: 100%; margin-bottom: 18px; }
.preview-link-thead { display: table-header-group; vertical-align: middle; border-color: inherit; }
.preview-tbody { font-family: "Open Sans",Arial,Helvetica,Sans-Serif; font-size: 15px; line-height: 1.42857143; color: #333; }
.preview-tbody tr { height:140px; border: solid 1px; border-color: #707070; }
.preview-tbody thead tr { height: 40px; border: solid 1px; border-color: #707070; background:linear-gradient(to bottom, #ffffff, #ebedee); }
.preview-tbody tbody tr:hover { background-color: #f5f5f5; }
td { border: solid 1px; border-color: #707070; padding:8px !important;} 
table { text-align:center; border: solid 1px; border-color: #707070; background: url('/resources/img/preview_link_back.png') 100% 100% no-repeat; }
</style>
<head>
	<jsp:include page="/WEB-INF/jsp/common/meta.jsp"></jsp:include>
	<jsp:include page="/WEB-INF/jsp/common/title.jsp"></jsp:include>
	<title>빈소 정보</title>
<script>
function viewInit() {
// 	console.log("aaaaaaaaaaa");
// 	console.log(btoa(451))

	_paramNo = window.location.pathname.split('/')[2];		
 	$.pb.ajaxCallHandler('/admin/selectEventForFuneralPreview.do', { funeralNo:_paramNo }, function(data) {
	//$.pb.ajaxCallHandler('/admin/selectEventForFuneralPreview.do', { funeralNo:atob(window.location.pathname.split('/')[2]) }, function(data) {
		//console.log(data);
		if( $('.preview-link-table').width() > 700 ){
			$('.preview-tbody').html('');
			var previewTableBody = $('.preview-tbody');
			$.each(data.evt, function(i, oneData){
				var famHtml = '';
				if(oneData.FAMILY != "" && oneData.FAMILY != null ){
					var famArr = oneData.FAMILY.split('!/,');
					$.each(famArr, function(i, oneLine){
						if( i +1 < famArr.length ){
							var oneLineArr = oneLine.split('!:');
							famHtml += oneLineArr[0] + ' : ' + oneLineArr[1] +'</br>';	
						}else{
							oneLine = oneLine.split('!/');
							var oneLineArr = oneLine[0].split('!:');
							famHtml += oneLineArr[0] + ' : ' + oneLineArr[1] +'</br>';	
						}
					});
				}
				
				
				
				//oneData.ENTRANCE_ROOM_START_DT
				var ersd = "";
				var iYn = oneData.IPGWAN_YN;
				
				if(iYn == 1){
					ersd = oneData.ENTRANCE_ROOM_START_DT;					
				}else{
					ersd = "입관 미정";
				}
				
				
				//oneData.CARRYING_DT
				var cYn = oneData.CARRYING_YN;
				var cdt = "";
				if(cYn == 1){
					cdt = oneData.CARRYING_DT;					
				}else{
					cdt = "발인 미정";
				}				
				
				var bpn = oneData.BURIAL_PLOT_NAME;
				if( bpn == null || bpn == ""){
					bpn = '장지 미정';	
				}
				
				
				var dmPhoto = oneData.DM_PHOTO;
				
								
				/**
				*
				var _tr = '<tr><td>'+oneData.APPELLATION+'</td><td>'+oneData.DM_NAME+'</td><td></td><td style="text-align:left;">'+famHtml+'</td><td>'+bpn+'</td><td>'+oneData.ENTRANCE_ROOM_START_DT+'</td><td>'+oneData.CARRYING_DT+'</td></tr>';
				if( dmPhoto != null || dmPhoto != ""){
					_tr = '<tr><td>'+oneData.APPELLATION+'</td><td>'+oneData.DM_NAME+'</td><td style="background-repeat: no-repeat; background-size: contain; background-image:url('+dmPhoto+')"></td><td style="text-align:left;">'+famHtml+'</td><td>'+bpn+'</td><td>'+oneData.ENTRANCE_ROOM_START_DT+'</td><td>'+oneData.CARRYING_DT+'</td></tr>';	
				}
				previewTableBody.append(_tr); 
				*/
				
				if(oneData.APPELLATION.indexOf('안치') != -1){
					//console.log(oneData.APPELLATION);	
				}else{
					var _tr = '<tr><td>'+oneData.APPELLATION+'</td><td>'+oneData.DM_NAME+'</td><td></td><td style="text-align:left;">'+famHtml+'</td><td>'+bpn+'</td><td>'+ersd+'</td><td>'+cdt+'</td></tr>';
					if( dmPhoto != null || dmPhoto != ""){
						_tr = '<tr><td>'+oneData.APPELLATION+'</td><td>'+oneData.DM_NAME+'</td><td style="background-repeat: no-repeat; background-size: contain; background-image:url('+dmPhoto+')"></td><td style="text-align:left;">'+famHtml+'</td><td>'+bpn+'</td><td>'+ersd+'</td><td>'+cdt+'</td></tr>';	
					}
					previewTableBody.append(_tr);	
				}
				
				
				
			});
		}else{
			$('.preview-link-title').height('60px');
			$('.preview-link-title-wrap').css('top', '18px');
			$('.preview-link-table').html('');
			var _previewTableBody = '<tbody class="preview-tbody"></tbody>';
			$('.preview-link-table').append(_previewTableBody);
			var previewTableBody = $('.preview-tbody');
			
			
			$.each(data.evt, function(i, oneData){
				var famHtml = '';
				if(oneData.FAMILY != "" && oneData.FAMILY != null ){
					var famArr = oneData.FAMILY.split('!/,');
					$.each(famArr, function(i, oneLine){
						if( i +1 < famArr.length ){
							var oneLineArr = oneLine.split('!:');
							famHtml += oneLineArr[0] + ' : ' + oneLineArr[1] +'</br>';	
						}else{
							oneLine = oneLine.split('!/');
							var oneLineArr = oneLine[0].split('!:');
							famHtml += oneLineArr[0] + ' : ' + oneLineArr[1] +'</br>';	
						}
					});
				}
				
				
				//oneData.ENTRANCE_ROOM_START_DT
				var ersd = "";
				var iYn = oneData.IPGWAN_YN;
				
				if(iYn == 1){
					ersd = oneData.ENTRANCE_ROOM_START_DT;					
				}else{
					ersd = "입관 미정";
				}
				
				
				//oneData.CARRYING_DT
				var cYn = oneData.CARRYING_YN;
				var cdt = "";
				if(cYn == 1){
					cdt = oneData.CARRYING_DT;					
				}else{
					cdt = "발인 미정";
				}
				
				
				var bpn = oneData.BURIAL_PLOT_NAME;
				if( bpn == null || bpn == ""){
					bpn = '장지 미정';	
				}
				
				var dmPhoto = oneData.DM_PHOTO;
				
				if(oneData.APPELLATION.indexOf('안치') != -1){
					//console.log(oneData.APPELLATION);	
				}else{				
					var _tr = '<tr><td style="width:25%;">'+oneData.APPELLATION+'</td><td style="width:25%;">故 '+oneData.DM_NAME+'</td><td rowspan="4" style="text-align:left;">'+famHtml+'</td></tr><tr><td rowspan="3"></td><td>입관일시</br>'+ersd+'</td></tr><tr><td>발인일시</br>'+cdt+'</td></tr><tr><td>'+bpn+'</td></tr>';
					if( dmPhoto != null || dmPhoto != ""){
						var _tr = '<tr><td style="width:25%;">'+oneData.APPELLATION+'</td><td style="width:25%;">故 '+oneData.DM_NAME+'</td><td rowspan="4" style="text-align:left;">'+famHtml+'</td></tr><tr style=" min-height:100px;"><td rowspan="3"style=" background-repeat: no-repeat; background-size: contain; background-image:url('+dmPhoto+')"></td><td>입관일시</br>'+ersd+'</td></tr><tr><td>발인일시</br>'+cdt+'</td></tr><tr><td>'+bpn+'</td></tr>';
					}
				}
				

				previewTableBody.append(_tr);	
			});
			$('.preview-tbody').find('tr').height('auto');

		}
	});
}
viewInit();
</script>
</head>

<body>
	<div class="p-container">
		<div class="preview-link-title">
			<div class="preview-link-title-wrap">삼가 고인의 명복을 빕니다.</div>
		</div>
		<div class="preview-link-mid">
			<table class="preview-link-table">
				<thead class=".preview-link-thead">
                    <tr>
                        <th class="text-center" style="font-size: 15px; width: 10%">빈 소 명</th>
                        <th class="text-center" style="font-size: 15px; width: 10%">고 인</th>
                        <th class="text-center" style="font-size: 15px; width: 9.1%">고인 사진</th>
                        <th class="text-center" style="font-size: 15px; width: 30.9%">상 주</th>
                        <th class="text-center" style="font-size: 15px; width: 20%">장 지</th>
                        <th class="text-center" style="font-size: 15px; width: 10%">입관 일시</th>
                        <th class="text-center" style="font-size: 15px; width: 10%">발인 일시</th>
                    </tr>
                </thead>
                <tbody class="preview-tbody">
                
                </tbody>
			</table>
		</div>
	</div>
</body>

</html>
