<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<style>
	.sangga-container { width:100%; height:100%; display:flex; flex-direction:column; }
	.sangga-div-top { width:100%; height:80px; display:flex; flex-direction:row; background-image: url('/resources/img/bg_top_sangga.png'); background-size: 100% 100%; }
	.sangga-div-top-left { height:100%; display:flex; justify-content: left; align-items: center; flex:25; color:#fff; font-size:24px; font-family: NanumGothic; padding-left: 120px;}
	.sangga-div-top-center { height:100%; display:flex; justify-content: center; align-items: center; flex:50; color:#fff; font-size:46px; font-family: NanumGothic; word-spacing: 5vw; }
	.sangga-div-top-right { height:100%; display:flex; justify-content: flex-end; align-items: center; flex:25; color:#fff; font-size:24px; font-family: NanumGothic;padding-right: 120px;}
	
	.sangga-div-center { width:100%; height:1000px; }
	.sangga-table { width:100%;height:99.8%; border-collapse: collapse;letter-spacing:1px;}
	.sangga-table-head { background-image: linear-gradient(to bottom, #868686, #000000 46%, #838383); color:#fff; }
	.sangga-table-head td { height: 40px; text-align: center; font-size:24px; font-family: NanumGothic; border: 1px solid #707070; letter-spacing: 20px; text-indent: 20px; }
	.sangga-table-body td { text-align: center; font-size:20px; font-family: NanumGothic; border: 1px solid #777777; font-weight: bold; box-sizing: border-box; }
	.sangga-table-body tr { min-height:192px; }
	
    .sangga-table-body tr:nth-child(3n+1) { border-top: 2px solid #000; }
    .sangga-table-body tr:first-child { border-top:none; }
    
	.sangga-table-body tr:nth-child(6n+1) { background:#f2f3fa; }
	.sangga-table-body tr:nth-child(6n+2) { background:#f2f3fa; }
	.sangga-table-body tr:nth-child(6n+3) { background:#f2f3fa; }
	.evt-info { width:100%; height:100%; display:flex; flex-direction:column; }
	.evt-info-row { display:flex; flex-direction:row; flex:1; justify-content: center; align-items: center; }
	.evt-info-row-name { display:flex; flex:15; justify-content: center; align-items: center; }
	.evt-info-row-date { display:flex; flex:85; justify-content: center; align-items: center; }
	.bigo-wrap { display: flex; justify-content: center; align-items: center; height: 100%; white-space: pre-wrap; }
 	.bigo { width: 100%; text-align: left; display: flex; justify-content: flex-start; align-items: center; }
 	
 	.appllation { font-size: 26px; width: 100%; text-align: center; display: flex; justify-content: center; align-items: center; }
 	.goin { font-size: 24px; width: 100%; text-align: center; display: flex; justify-content: center; align-items: center; }
 	.sangjuNm-wrap { display: flex; justify-content: center; align-items: center; height: 100%; white-space: pre-wrap; }
 	.sangjuNm { font-size: 23px; width: 100%; text-align: left; display: flex; justify-content: flex-start; align-items: center; }
 	
 	.jangji-wrap { display: flex; justify-content: center; align-items: center; height: 100%; white-space: pre-wrap; }
 	.jangji { font-size: 22px; width: 100%; text-align: left; display: flex; justify-content: center; align-items: center; }
 	
 	.sangjo-wrap { display: flex; justify-content: center; align-items: center; height: 100%; white-space: pre-wrap; }
 	.sangjo { font-size: 22px; width: 100%; text-align: left; display: flex; justify-content: center; align-items: center; }
 	
 	.place-wrap { display: flex; justify-content: center; align-items: center; height: 100%; white-space: pre-wrap; }
 	.place { font-size: 22px; width: 100%; text-align: left; display: flex; justify-content: center; align-items: center; }
 	
</style>
<head>
<script>
	function sanggaInit(_funeralNo){
	     $.pb.ajaxCallHandler('/admin/selectSanggaList.do', { order:'EXPOSURE ASC, APPELLATION ASC', funeralNo:_funeralNo, statusPlate:true }, function(data) {
	        var table = $('.sangga-table');
	        var thead = $('.sangga-table-head');
	        var tbody = $('.sangga-table-body');
	        //thead.append('<tr><td>빈소</td><td>고인</td><td>상주</td><td colspan="2" style="letter-spacing:1.2px;">상례정보</td><td>장지</td><td style="letter-spacing:1.2px;">상조회사</td><td colspan="2">정보</td><td>비고</td></tr>');
	        //thead.append('<tr><td>빈소</td><td>고인</td><td>상주정보</td><td colspan="2" style="letter-spacing:1.2px;">상례정보</td><td>장지</td><td style="letter-spacing:1.2px;">상조회사</td><td>장소</td><td>비고</td></tr>');
	        //thead.append('<tr><td>빈소</td><td>고인</td><td>상주정보</td><td colspan="2" style="letter-spacing:1.2px;">상례정보</td><td>장지</td><td colspan="2">정보</td><td>비고</td></tr>');
	        thead.append('<tr><td>빈소</td><td>고인</td><td>상주정보</td><td colspan="2" style="letter-spacing:1.2px;">장례정보</td><td>장지</td><td>비고</td></tr>');
	        
	        var _list = data.list
	        $.each(_list, function(i, oneData){
				var nameAreaStr = '';
				var sjName = '';
				var sangjuNm = '';
				var jangji = '';
				//var sangjo = '';
				var bigo = '';
				
				//var pcy = '';
				//var dy = '';
				//var cause = ''
				
				//var place='';
				var enterDt = '<td style="width:3%;">입실</td><td style="width:10%;"></td>';
				var enterSDt = '<td>입관</td><td></td>';
				var carryDt = '<td>발인</td><td></td>';
				
				
				//빈소명 처리
				var f_parlor="";
				var f_parlor_floor="";
				if(oneData.APPELLATION !=null && oneData.APPELLATION !=""){
										
					var rName=oneData.APPELLATION;
					var tmp=rName.split('(');
										
					if(tmp[1]){
						f_parlor=tmp[0];
						f_parlor_floor="<br>("+tmp[1];
						
					}else{
						f_parlor=tmp[0];
						f_parlor_floor="";						
					}
				}	
				
				
				//고인명 처리
	           	if(oneData.DM_NAME != null && oneData.DM_NAME != ""){
           	  		nameAreaStr = '故'+oneData.DM_NAME; 
	              	if(oneData.DM_POSITION != null){
	                 	nameAreaStr += ' ';
	                 	nameAreaStr += oneData.DM_POSITION;
	              	}
	              	if( oneData.DM_GENDER!=0 || oneData.DM_AGE!=''){
	                 	nameAreaStr += '</br>(';
	                 
	                 	if(oneData.DM_GENDER!=0){
	                    	if (oneData.DM_GENDER==1){
		                       nameAreaStr+= '남';
		                    }
		                    if (oneData.DM_GENDER==2){
		                       nameAreaStr+= '여';
		                    }
		                    if (oneData.DM_GENDER==3){
		                       nameAreaStr+= '男';
		                    }
		                    if (oneData.DM_GENDER==4){
		                       nameAreaStr+= '女';
		                    }
		                    if(oneData.DM_AGE!=''){
		                       nameAreaStr+= ', ';
		                       nameAreaStr+= oneData.DM_AGE;
		                       nameAreaStr+= '세';
		                    }
	                 	}else{
	                    	nameAreaStr+= oneData.DM_AGE;
		                    nameAreaStr+= '세';
	                 	}
	               		nameAreaStr += ')';
					}
	              	if(oneData.DM_RELIGION_NAME != null && oneData.DM_RELIGION_NAME != ""){
	            		nameAreaStr += "<br>"+oneData.DM_RELIGION_NAME;   
	              	}
	              		              	
	              	
	              //상주명 추가
	              	if(oneData.strSangju != null && oneData.strSangju != ""){	              		
	              		var tmpStr = "("+oneData.strSangju.toString().trim()+")  ";	              		
	              		//var tmpStr = oneData.strSangju.toString().trim();
	              		console.log(tmpStr);
	              		sangjuNm += tmpStr.replace(/\\/gi, ') (');	              		
	              		//sangjuNm += tmpStr.replace(/\\/gi, '<br>');
	              	}
	              	
	              	//장지
	              	if(oneData.BURIAL_PLOT_NAME != null && oneData.BURIAL_PLOT_NAME != ""){
	                 	jangji +=oneData.BURIAL_PLOT_NAME;   
	              	}else
	              		jangji +='장지 미정';
	              	if(oneData.CARRYING_PLACE != null && oneData.CARRYING_PLACE != ""){
	                 	sangjo +=oneData.CARRYING_PLACE;   
	              	}
	              	
	              	//비고
	              	if(oneData.BIGO != null && oneData.BIGO != ""){
	                 	bigo +=oneData.BIGO;   
	              	}
	              	
	              	
	              	//발인
	              	carryDt = '발인 미정';
	              	if(oneData.CARRYING_YN == 1){
	                 	carryDt =new Date(oneData.CARRYING_DT).format('MM월 dd일 HH:mm');   
	              	}
	              	
	              	//입실
	              	var curTime = new Date();
	              	if(curTime > new Date(oneData.ENTRANCE_ROOM_DT)){
	                 	enterDt = '<td style="width:3%;background:#fdce0c;">입실</td><td class="er-tm" data-time="'+oneData.ENTRANCE_ROOM_DT+'" style="width:10%;">'+new Date(oneData.ENTRANCE_ROOM_DT).format('MM월 dd일 HH:mm')+'</td>';
	              	}else{
	                 	enterDt = '<td style="width:3%;">입실</td><td class="er-tm" data-time="'+oneData.ENTRANCE_ROOM_DT+'" style="width:10%;">'+new Date(oneData.ENTRANCE_ROOM_DT).format('MM월 dd일 HH:mm')+'</td>';
	              	}
	              	
	              	 
	              	//입관
	              	ipgwanDt = '입관 미정';
	              	if(oneData.IPGWAN_YN == 1){
	                 	ipgwanDt =new Date(oneData.ENTRANCE_ROOM_START_DT).format('MM월 dd일 HH:mm');   
	              	}
	              	
	              	if(oneData.IPGWAN_YN==1){
	              		if(curTime > new Date(oneData.ENTRANCE_ROOM_START_DT)){	              			
	              			
	              			enterSDt = '<td style="background:#fdce0c;">입관</td><td class="c-tm" data-cYn="'+oneData.IPGWAN_YN+'" data-time="'+oneData.ENTRANCE_ROOM_START_DT+'">'+ipgwanDt+'</td>';		                 	
		              	}else{		              		
		                 	enterSDt = '<td>입관</td><td class="c-tm" data-cYn="'+oneData.IPGWAN_YN+'" data-time=">'+oneData.ENTRANCE_ROOM_START_DT+'">'+ipgwanDt+'</td>';
		              	}
	              	}else{
	              		enterSDt = '<td>입관</td><td class="c-tm" data-cYn="'+oneData.IPGWAN_YN+'" data-time=">'+oneData.ENTRANCE_ROOM_START_DT+'">'+ipgwanDt+'</td>';
	              	}
	              	 
	              	 
	              	 
	              	//발인	              	
	              	if(oneData.CARRYING_YN == 1 && curTime > new Date(oneData.CARRYING_DT)){
	                 	carryDt = '<td style="background:#fdce0c;">발인</td><td class="c-tm" data-cYn="'+oneData.CARRYING_YN+'" data-time="'+oneData.CARRYING_DT+'">'+carryDt+'</td>';
	              	}else{
	                 	carryDt = '<td>발인</td><td class="c-tm" data-cYn="'+oneData.CARRYING_YN+'" data-time="'+oneData.CARRYING_DT+'">'+carryDt+'</td>';
	              	}
	              	
	              	
	              	/*
	              	if(oneData.DEAD_PLACE != null && oneData.DEAD_PLACE != ""){
	              		place=oneData.DEAD_PLACE;
	              	}	              	
	              	
	              	if(oneData.PUBLIC_PROSECUTOR_YN==1){
	                 	pcy = 'O';
	              	}else{
	                 	pcy = 'X';
	              	}
	              	if(oneData.DIAGNOSIS_YN==1){
	                 	dy='O';
	              	}else{
	                 	dy='X';
	              	}
	              	if(oneData.DEAD_CAUSE != null && oneData.DEAD_CAUSE != "" ){
	                 	cause=oneData.DEAD_CAUSE;
	              	}
	              	*/
	              
	           	}
	           	tbody.append('<tr>'+
	           		'<td rowspan="3" style="width:7%;"><div class="appllation-wrap"><div class="appllation">'+f_parlor+''+f_parlor_floor+'</div></div></td>'+			//빈소명
	           		'<td rowspan="3" style="width:12%;"><div class="goin-wrap"><div class="goin">'+nameAreaStr+'</div></div></td>'+			//고인명
	           		'<td rowspan="3" style="width:44%;"><div class="sangjuNm-wrap"><div class="sangjuNm">'+sangjuNm+'</div></div></td>'+	//상주관계
	           		enterDt+
	           		
	           		'<td rowspan="3" style="width:9%;"><div class="jangji-wrap"><div class="jangji">'+jangji+'</div></div></td>'+
		           	//'<td rowspan="3" style="width:9%;"><div class="sangjo-wrap"><div class="sangjo">'+sangjo+'</div></div></td>'+																			//상조		           	
		           	//'<td rowspan="3" style="width:6%;"><div class="place-wrap"><div class="place">'+place+'</div></div></td>'+
		           	
		           	//'<td style="width:3%;"><font color="lightgray">사인</font></td><td style="width:3%;"><div class="ellipsis" style="width: 3%; padding: 0px;">'+""+'</div></td>'+
		           	
		           	'<td rowspan="3" style="width:15%;"><div class="bigo-wrap"><div class="bigo">'+bigo+'</div></div></td>'+		           	
		           	
		           	//'<tr>'+enterSDt+'<td>진단</td><td>'+dy+'</td></tr>'+
		           	//'<tr>'+carryDt+'<td>검사</td><td>'+pcy+'</td>'+
		           	
		           	'<tr>'+enterSDt+'</tr>'+
		           	'<tr>'+carryDt+'</td>'+
		           	
		           	
	           		+'</tr>');	           	
        	});
					
	        table.append(thead);
	        table.append(tbody);
	        
	        var timer = setInterval(function() {
				$('.er-tm').each(function(i, o){
					if(new Date() > new Date($(this).data('time'))) {
						$(this).prev().css('background', '#fdce0c');
					}
					if(new Date() > new Date($('.ers-tm:eq('+i+')').data('time'))) {
						$('.ers-tm:eq('+i+')').prev().css('background', '#fdce0c');
					}
					if($('.c-tm:eq('+i+')').data('cYn') == 1 && new Date() > new Date($('.c-tm:eq('+i+')').data('time'))) {
						$('.c-tm:eq('+i+')').prev().css('background', '#fdce0c');
					}
				})
			}, 1000);
	        
	        
	        // table row height setting //
	        // 최소 5개의 데이터를 볼 수 있다. //
	        // 5개 이상인 경우 960px을 균등하게 나누어 높이값으로 설정 //
	        var dataLen = data.list.length;
	        if(dataLen <= 5){//64px
	           var rHeight = '64px';
	           $('.sangga-table-body .td').height(rHeight+'px');
	           $('.sangga-table-body .bigo-wrap').height(150 + 'px');		//비고(bigo-wrap)
	           $('.sangga-table-body .sangjuNm-wrap').height(220 + 'px');	//상주관계:상주명(sangjuNm-wrap)
	           
	           $('.sangga-table-body .goin-wrap').height(100 + 'px');		//고인(goin-wrap)
	           
	           $('.sangga-table-body .jangji-wrap').height(55 + 'px');		//장지(jangji-wrap)
	           //$('.sangga-table-body .sangjo-wrap').height(52 + 'px');		//상조(sangjo-wrap)
	           //$('.sangga-table-body .place-wrap').height(32 + 'px');		//사망장소(place-wrap)
	           
	        }else{
	           if(dataLen > 10){
	              $('.sangga-table-body').find('td').css('font-size','15px');
	           }
	           if(dataLen > 15){
	              $('.sangga-table-body').find('td').css('font-size','12px');
	           }
	           var rHeight = ((950 / (dataLen * 4)) - 3 ) ;
	           $('.sangga-table-body').find('td').height(rHeight+'px');
	           $('.sangga-table-body .bigo-wrap').height((rHeight*3+20)+'px');
	           
	        }
	        $('.sangga-div-top-left').text(data.funeralInfo.FUNERAL_NAME);
	        
	        // 글자 크기 줄여줌
	        $('.sangga-table-body .goin').each(function() {
				autoFontSize( $(this), $(this).parent('.goin-wrap'));
	        });
	        $('.sangga-table-body .bigo').each(function() {
				autoFontSize( $(this), $(this).parent('.bigo-wrap'));
	        });
	        $('.sangga-table-body .sangjuNm').each(function() {
				autoFontSize( $(this), $(this).parent('.sangjuNm-wrap'));
	        });
	        $('.sangga-table-body .jangji').each(function() {
				autoFontSize( $(this), $(this).parent('.jangji-wrap'));
	        });
	        /*
	        $('.sangga-table-body .sangjo').each(function() {
				autoFontSize( $(this), $(this).parent('.sangjo-wrap'));
	        });
	        $('.sangga-table-body .place').each(function() {
				autoFontSize( $(this), $(this).parent('.place-wrap'));
	        });
	        */
	        // 글자크기 이후 줄여줌
	        $('.sangga-table-body .bigo').css('height', '100%').css('overflow', 'hidden');
			
	        
	     });
		
		var sanggaClock = setInterval(function() {
		   $('.sangga-div-top-right').html(new Date().format('MM월 dd일 HH시 mm분'));
		}, 1000);
   }
</script>
</head>

<body>
   <div class="sangga-container">
      <div class="sangga-div-top">
         <div class="sangga-div-top-left"></div>
         <div class="sangga-div-top-center">상 가 현 황</div>
         <div class="sangga-div-top-right"></div>
      </div>
      <div class="sangga-div-center">
         <table class="sangga-table"> 
         <thead class="sangga-table-head"></thead>
         <tbody class="sangga-table-body"></tbody>
         </table>
      </div>
   </div>
</body>

</html>