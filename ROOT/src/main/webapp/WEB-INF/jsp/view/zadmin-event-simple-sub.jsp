<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		var _pk = _param.pk.split('&');
		
		var _eventFlag = $(location)[0].pathname.split('/')[1].slice(-1);
		$('.event-info-top > .left-wrap > .item:eq('+(_eventFlag - 1)+')').addClass('ac');
		$('.contents-body-wrap').pageConnectionHandler('/view/zadmin-event-'+$('.event-info-top > .left-wrap > .item.ac').val(), { pk:_pk[1], funeralNo:_pk[0], eventBinsoNo:_param.eventBinsoNo });
		
		$('.event-bar.top > .center-text').html(new Date().format('yyyy-MM-dd a/p hh:mm'));
		var _topClock = setInterval(function() {
			$('.event-bar.top > .center-text').html(new Date().format('yyyy-MM-dd a/p hh:mm'));
		}, 1000);
		
		var crtLeftMenu = function(_flag) {
			var _clickFlag = $(location)[0].pathname.split('/')[1].slice(-1);
			$('.event-info-top > .right-wrap').html("");

			if(_clickFlag == 1) {
				if($(location)[0].pathname.split('/')[2]) {
					$('.event-info-top > .right-wrap').append('<button class="btn delete">행사삭제</button>');
					$('.event-info-top > .right-wrap').append('<button class="btn deadline">행사마감</button>');
					$('.event-info-top > .right-wrap').append('<button class="btn print01">장례확인서</button>');
					$('.event-info-top > .right-wrap').append('<button class="btn print03">현황판 출력</button>');
					$('.event-info-top > .right-wrap').append('<button class="btn bugo-pop">모바일부고장</button>');
				}
			} else if(_clickFlag == 2) {
				$('.event-info-top > .right-wrap').html('');
			} else if(_clickFlag == 3) {
				$('.event-info-top > .right-wrap').html('');
			} else if(_clickFlag == 4) {
				$('.event-info-top > .right-wrap').html('');
				$('.event-info-top > .right-wrap').append('<button type="button" class="btn long cal">장례비용내역서 인쇄</button>');
			}
			
			$('.event-info-top > .right-wrap').find('.btn.cancel').off().on('click', function() { 
				if(confirm("취소하시겠습니까?")) $(location).attr('href', '/991002'); 
			});
			

// 			//행사 삭제
// 			$('.event-info-top > .right-wrap > .btn.delete').off().on('click', function(){
// 				$.pb.ajaxCallHandler('/admin/deleteEvent.do', { eventNo:_pk[1], funeralNo:_pk[0] }, function(eventAliveRst) {
// 					$(location).attr('href', '/991002');
// 				});
// 			});

// 			//행사 마감
// 			$('.event-info-top > .right-wrap > .btn.deadline').off().on('click', function(){
// 				$.pb.ajaxCallHandler('/admin/updateEventAliveFlag.do', { eventNo:_pk[1], funeralNo:_pk[0], eventAliveFlag:0 }, function(eventAliveRst) {
// 					if(eventAliveRst) $(location).attr('href', '/991002');
// 				});
// 			});
			
			//장례확인서 출력
			$('.event-info-top > .right-wrap > .btn.print01').off().on('click', function(){
	 			window.open('/290901/'+_pk[1], "printName", "width=1000, height=800, scrolbars=yes");
			});
			
			//현황판 출력
			$('.event-info-top > .right-wrap > .btn.print03').on('click', function(){
// 				window.open('/290903/'+_param.pk, "printName", "");
				window.open('/290903/'+_pk[1], "printName", "width=1000, height=800, scrolbars=yes");
			});

			// 장례비용내역서 출력
			$('.event-info-top > .right-wrap > .btn.long').off().on('click', function(){
				window.open('/290902/'+_pk[1], "printName", "width=1000, height=800, scrolbars=yes");
			});
		};
		
		
		$('.event-info-top > .left-wrap > .item').on('click', function() {
			var _thisIdx = $(this).index()+1;
			if(_pk[1]) {
				$(this).addClass('ac').siblings('.item').removeClass('ac');

				var stateObj = { link:'/9910020'+_thisIdx+(_param.pk ? '/'+_param.pk:'') };
				stateObj.page = '/view/zadmin-event-'+$(this).val();
				
				history.pushState(stateObj, '', stateObj.link);
				$('.contents-body-wrap').pageConnectionHandler(stateObj.page, { pk:_pk[1], funeralNo:_pk[0] }, function() { crtLeftMenu(_thisIdx); });
			} else if(!$(this).hasClass('info')) alert('행사 등록 후 사용가능합니다.');
		});
		
		$('.event-bar.top > .right-text').on('click', function() { 
			if ((screen.availHeight || screen.height - 30) <= window.innerHeight) closeFullScreenMode();
	      	else openFullScreenMode();
		});
		
		crtLeftMenu(_eventFlag);
	});
</script>
<div class="event-bar top">
	<span class="center-text"></span>
	<span class="right-text" style="cursor:pointer;"><img src="/resources/img/icon_full_screen.svg" class="text-icon"/>전체화면</span>
</div>
<div class="space-box"></div>
<div class="event-info-top">
	<div class="left-wrap">
		<button type="button" class="item info" value="simple-info"><span class="title">행사정보</span></button>
		<button type="button" class="item order" value="order"><span class="title">주문</span></button>
		<button type="button" class="item take-back" value="take-back"><span class="title">반품</span></button>
		<button type="button" class="item calculate" value="calculate"><span class="title">정산</span></button>
	</div>
	<div class="right-wrap"></div>
</div>
<form id="eventSubForm"><div class="contents-body-wrap" style="padding-bottom:50px; font-size:0;"></div></form>
<div class="event-bar bottom">
	<span class="left-text"><img src="/resources/img/icon_dongsung_logo.svg" class="text-icon"/>동성바이오 v0.01</span>
	<span class="center-text">-</span>
	<span class="right-text">담당 : -</span>
</div>
