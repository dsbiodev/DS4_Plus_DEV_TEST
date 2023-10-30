<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	$(function() {
		
		// 현황판 출력
		var _param = JSON.parse('${data}');
		var _arr = location.pathname.split('/');
		$('.ajax-loading').remove();
		$.pb.ajaxCallHandler('/adminSec/selectEventBoardPrintList.do', { eventNo : _arr[_arr.length-1] }, function(data) {
			var _list = data.list[0];
			$('.status-text').text(_list.APPELLATION ? _list.APPELLATION : '');
			
			//$('.name-text').text("故 "+_list.DM_NAME+" "+_list.DM_POSITION+" ("+_list.DM_GENDER+ (_list.DM_AGE ? ", "+_list.DM_AGE+"세)" : ')'));
			// HYH - 성별 추가
			var appendText="";
			
			var _gender ="";
			if(_list.DM_GENDER ==""){
			 _gender = "";
			}else if(_list.DM_GENDER == "남"){
			 _gender = "남";
			}else if(_list.DM_GENDER == "여"){
			 _gender = "여";
			}else if(_list.DM_GENDER == "男"){
			 _gender = "男";
			}else if(_list.DM_GENDER == "女"){
			 _gender = "女";
			}
			
			if(_list.DM_AGE=='' && _list.DM_GENDER ==""){	//나이와 성별이 없을때
			appendText="";
			}else if(_list.DM_AGE !='' && _list.DM_GENDER ==""){	//나이는 있고 성별은 없을때
				appendText = " (" + _list.DM_AGE +"세)"
			}else if(_list.DM_AGE !='' && _list.DM_GENDER !=""){	//나이와 성별이 있을때
				appendText = " (" + _gender +  " / "+ _list.DM_AGE+"세)"
			}else if(_list.DM_AGE =='' && _list.DM_GENDER !=""){	//나이는 없고 성별만 있을때
				appendText = " ("+ _gender+")";
			}						 
			$('.name-text').text("故 "+_list.DM_NAME+" "+_list.DM_POSITION+" "+appendText);
			// ./HYH - 성별 추가
		
		
			if(_list.DM_PHOTO) $('.img-text').attr('src', _list.DM_PHOTO);
			else $('.img-text').attr('src', '/resources/img/print-03-img-default.png');

			var _familyList = data.familyList;
			if(_familyList.length > 0 && _familyList[0].RELATION){
				$.each(_familyList, function(){
					var _div = $('<div class=family-text>');
					_div.append(this.RELATION);
					var _name = $('<div class=div-name>');
					_name.append(this.NAME);
					_div.append(_name);
					$('.family').append(_div);
				});
				
				//관계  width값 조정
				var _tmp = $('.family-text .relation:eq(0)');
				$('.family-text .relation').each(function(idx, value){
					$(value).text($(value).text().replace(/ /gi, ''));
					if(_tmp.text().replace(/ /gi, '').length < $(value).text().replace(/ /gi, '').length)
						_tmp = $(value);
				});

				$('.family-text .relation').css('width', _tmp.css('width').replace('px','')-50);
				
				//이름 공백 없애기
				$('.family-text .div-name .name').each(function(idx, value){
					$(value).text($(value).text().replace(/ /gi, ''));
				});

				//이름중 마지막 이름 콤마 없애기
				$('.family-text .div-name').each(function(idx, value){
					$(value).find('.name').last().text($(value).find('.name').last().text().replace(/,/gi, ''));
				});
				$('.family-text').last().find('.div-name').css('padding-bottom', '0px');
				
				var _height = 0;
				$.each($('.family-text'), function(){
					_height += Number($(this).css('height').replace('px', ''));
				});
				

				var _break = 0;
				while(_height > 737){
					_break++;
					if(_break > 3000) break;
					
					$('.family-text').css('font-size', $('.family-text').css('font-size').replace('px', '')-1)
					_height = 0;
					$.each($('.family-text'), function(){
						_height += Number($(this).css('height').replace('px', ''));
					});
				}
			}
			
			/* 
			$('.er-start-text').text(_list.ENTRANCE_ROOM_NO ? _list.ENTRANCE_ROOM_START_DT : '');
			$('.carrying-start-text').text(_list.CARRYING_YN == 1 ? _list.CARRYING_DT : '');
			 */
			 if(_list.ENTRANCE_ROOM_NO){
				 if(_list.IPGWAN_YN==1){
					 $('.er-start-text').text(_list.ENTRANCE_ROOM_START_DT);
				 }else{
					 $('.er-start-text').text('-');
				 }
			 }else{
				 $('.er-start-text').text('-');
			 }
			 
			 if(_list.CARRYING_YN == 1){
				 $('.carrying-start-text').text(_list.CARRYING_DT);
			 }else{
				 $('.carrying-start-text').text('-');
			 }
			
			
			
			$('.burial-plot-text').html(_list.BURIAL_PLOT_NAME ? _list.BURIAL_PLOT_NAME : "미정");
			
			
 		  	IEPageSetupX.header = "";
 			IEPageSetupX.footer = "";
 			IEPageSetupX.ShrinkToFit = true;
 			IEPageSetupX.PrintBackground = true;
 			IEPageSetupX.Orientation = 0;
	 		IEPageSetupX.Preview();
	 	 	window.close();  			
 			
		});
		
	});
</script>

<style>
	@media print{
		.page .back .name-text { color:#ffffff!important; }
		.page .back .status-text { color:#ffffff!important; }
		.page .back .er-start-title { color:#ffffff!important; }
		.page .back .carrying-start-title { color:#ffffff!important; }
		.page .back .burial-plot-title { color:#ffffff!important; }
		
	}
 	@page { size:auto; margin:15px 15px 15px 15px; } 
	.main-left-wrap { display:none; }
	.main-contents-wrap { padding-left:0px !important; background:#FFF; padding-right:0px !important; }

	.page { position:relative;  top:-20px; } 
	.page .back { position:relative; color:#FFF; font-size:70px; }
 	.page .back .status { display:inline-block; position:absolute; width:608px; height:178px; }
  	.page .back .status img { width:100%; height:100%; position:absolute; }
  	
  	.page .back .dm-name { display:inline-block; position:absolute; left:608px; width:1215px; height:178px; } 
  	.page .back .dm-name img { width:100%; height:100%; position:absolute; }
  	.page .back .img { display:inline-block; position:absolute; top:178px; width:608px; height:762px; left:-1px;  }
  	.page .back .img .img-default { width:100%; height:100%; position:absolute; }
  	.page .back .img .img-text { width:535px; height:702px; position:absolute; }
  	.page .back .family { position:absolute; top:178px; left:607px; width:1216px; height:762px; display:flex; align-content:center; flex-direction:column; justify-content:center;}
  	.fm-img { position:absolute; top:178px; left:607px; width:1216px; height:762px; display:flex; align-content:center; }
  	
 	.page .back .er-start { display:inline-block; position:absolute; top:940px; width:911.5px; height:330px; }   
  	.page .back .er-start img { width:100%; height:100%; position:absolute; }  
    
    .page .back .carrying-start { display:inline-block; position:absolute; top:1190px; width:911.5px; height:80px; }    
  	.page .back .burial-plot img { width:100%; height:100%; position:absolute; }
  	.page .back .burial-plot { display:inline-block; position:absolute; top:940px; left:910.5px; width:912.5px; height:330px; }
  	.page .back .burial-plot img { width:100%; height:100%; position:absolute; }

  	.page .back .img-text { position:absolute; top:24px; left:38px; height:704px; width:534px; }   
  	.page .back .status-text { position:absolute; left:17px; width:579px; text-align:center; display:flex; height:179px; align-items:center; justify-content:center; text-overflow:ellipsis; overflow:hidden; white-space:nowrap; }  
  	.page .back .name-text { position:absolute; display:flex; align-items:center; width:1167px; height:167px; padding-left:30px; text-overflow:ellipsis; overflow:hidden; white-space:nowrap; }  
  	
  	.page .back .family-text { width:100%; color:#000; display:table;  justify-content:center;}  
  	.page .back .family-text .relation { display:table-cell; text-align:center; vertical-align:top; white-space:nowrap; position:relative; padding-right:20px; }
  	.page .back .family-text .relation:after { content:":"; position:absolute; right:0; }
  	.page .back .family-text .div-name { display:table-cell; padding:0px 25px 35px 15px; }
  	.page .back .family-text .div-name .name { display:inline-block; position:relative; }
  	
  	.page .back .er-start-text { position:absolute; left:279px; color:#000; font-size:65px; display:flex; width:620px; height:150px; align-items:center; justify-content:center; }  
  	.page .back .carrying-start-text { position:absolute; top:-88px; left:279px; color:#000; font-size:65px; display:flex; width:620px; height:150px; align-items:center; justify-content:center; }  
   	.page .back .burial-plot-text { position: absolute; color:#000; display:flex; align-items:center; justify-content:center; left:255px; width:639px; height:313px; text-overflow:ellipsis; overflow:hidden; word-break:break-all; white-space:pre-line; }  
	
  	.page .back .er-start-title { position:absolute; left:18px; font-size:65px; width:249px; height:150px; display:flex; justify-content:center; align-items:center; } 
  	.page .back .carrying-start-title { position:absolute; top:-88px; left:18px; font-size:65px; width:249px; height:150px; display:flex; justify-content:center; align-items:center;  } 
  	.page .back .burial-plot-title { position:absolute; display:flex; height:313px; width:244px; align-items:center; justify-content:center; }
  	 
</style>
<object id="IEPageSetupX" classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="/resources/js/IEPageSetupX.cab#version=1,4,0,3" width=0 height=0><param name="copyright" value="http://isulnara.com"></object> 
<div class="page" id="page">
	<div class="back">
		<div class="status">
			<img src="/resources/img/print-03-status.png;">
			<div class="status-text"></div>
		</div>
		<div class="dm-name">
			<img src="/resources/img/print-03-name.png;">
			<div class="name-text"></div>
		</div>
		<div class="img">
			<img class="img-default" src="/resources/img/print-03-img.png;">
			<img class="img-text">
		</div>
		<img class="fm-img" src="/resources/img/print-03-family.png;">
		<div class="family">
		</div>
		<div class="er-start">
			<img src="/resources/img/print-03-time.png;">
			<div class="er-start-title">입 관</div><div class="er-start-text"></div>
		</div>
		<div class="carrying-start">
			<div class="carrying-start-title">발 인</div><div class="carrying-start-text"></div>
		</div>
		<div class="burial-plot">
			<img src="/resources/img/print-03-plot.png;">
			<div class="burial-plot-title">장 지</div><div class="burial-plot-text"></div>
		</div>
	</div>
</div>
