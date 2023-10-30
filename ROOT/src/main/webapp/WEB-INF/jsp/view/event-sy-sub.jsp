<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		
		var _eventFlag = $(location)[0].pathname.split('/')[1].slice(-1);
		$('.event-info-top > .left-wrap > .item:eq('+(_eventFlag - 1)+')').addClass('ac');
		$('.contents-body-wrap').pageConnectionHandler('/view/event-'+$('.event-info-top > .left-wrap > .item.ac').val(), { pk:_param.pk, eventBinsoNo:_param.eventBinsoNo });
		
		$('.event-bar.top > .center-text').html(new Date().format('yyyy-MM-dd a/p hh:mm'));
		var _topClock = setInterval(function() {
			$('.event-bar.top > .center-text').html(new Date().format('yyyy-MM-dd a/p hh:mm'));
		}, 1000);
		
		var crtLeftMenu = function(_flag) {
			var _clickFlag = $(location)[0].pathname.split('/')[1].slice(-1);

			if(_clickFlag == 1) {
				var filter = "win16|win32|win64|mac|macintel";
				if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
				}else{
					$('.event-info-top > .right-wrap').append('<button class="btn cancel">취소</button>');
				}
				if($(location)[0].pathname.split('/')[2]) {
					var path = $(location)[0].pathname.split('/')[2];
					//모바일/PC 스크립트 인식 구분
					if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
					//MOBILE
						$('.event-info-top > .right-wrap').append('<button class="btn delete">행사삭제</button>');
						$('.event-info-top > .right-wrap').append('<button class="btn deadline">행사마감</button>');
						$('.event-info-top > .right-wrap').append('<button class="btn bugo-pop">모바일부고장</button>');
					}else { 
						$('.event-info-top > .right-wrap').append('<button class="btn delete">행사삭제</button>');
						$('.event-info-top > .right-wrap').append('<button class="btn deadline">행사마감</button>');
						$('.event-info-top > .right-wrap').append('<button class="btn print01">장례확인서</button>');
						$('.event-info-top > .right-wrap').append('<button class="btn print03">현황판 출력</button>');
						$('.event-info-top > .right-wrap').append('<button class="btn bugo-pop">모바일부고장</button>');
					}
				}

				$('.event-info-top > .right-wrap').append('<button class="btn save">저장하기</button>');
			} else if(_clickFlag == 2) {
				$('.event-info-top > .right-wrap').html('');
			} else if(_clickFlag == 3) {
				$('.event-info-top > .right-wrap').html('');
			} else if(_clickFlag == 4) {
				$('.event-info-top > .right-wrap').html('');
				$('.event-info-top > .right-wrap').append('<button type="button" class="btn order">주문상세 내역</button>');
				$('.event-info-top > .right-wrap').append('<button type="button" class="btn long cal">장례비용내역서 인쇄</button>');
			}
			
			$('.event-info-top > .right-wrap').find('.btn.cancel').off().on('click', function() { 
				if(confirm("취소하시겠습니까?")) $(location).attr('href', '/290103'); 
			});
			
			//행사 삭제
			$('.event-info-top > .right-wrap > .btn.delete').off().on('click', function(){
				if(confirm('삭제된 데이터는 복구할 수 없습니다. 그래도 삭제하시겠습니까? ')) {
					var _rpiBinsoList = '';
					$.each($('.box-body.binso > .body-select'), function(idx) { 
						if($(this).val()) {
							_rpiBinsoList += (idx ? ','+$(this).val():$(this).val());
						}
					});
					$.pb.ajaxCallHandler('/admin/deleteEvent.do', { eventNo:_param.pk, funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}', rpiBinsoNo:_rpiBinsoList, eventAliveFlag:$('input[name=eventAliveFlag]').val() }, function(eventAliveRst) {
						$(location).attr('href', '/290103');
					});
				}
			});

			//행사 마감
			$('.event-info-top > .right-wrap > .btn.deadline').off().on('click', function() {
				var _rpiBinsoList = '';
				$.each($('.body-select.binso'), function(idx) { 
					if($(this).val()) {
						_rpiBinsoList += (idx ? ','+$(this).val():$(this).val());
					}
				});
				$.pb.ajaxCallHandler('/admin/updateEventAliveFlag.do', { eventNo:_param.pk, funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}', eventAliveFlag:0, rpiBinsoNo:_rpiBinsoList }, function(eventAliveRst) {
					if(eventAliveRst) $(location).attr('href', '/290103');
				});
			});
			
			//장례확인서 출력
			$('.event-info-top > .right-wrap > .btn.print01').off().on('click', function(){
	 			window.open('/290901/'+_param.pk, "printName", "width=1000, height=800, scrolbars=yes");
			});
			
			//현황판 출력
			$('.event-info-top > .right-wrap > .btn.print03').off().on('click', function(){
//				window.open('/290903/'+_param.pk, "printName", "");
				window.open('/290903/'+_param.pk, "printName", "width=1000, height=800, scrolbars=yes");
			});

			// 장례비용내역서 출력
			$('.event-info-top > .right-wrap > .btn.long').off().on('click', function(){
				window.open('/290902/'+_param.pk, "printName", "width=1000, height=800, scrolbars=yes");
			});
		};
		
		
		$('.event-info-top > .left-wrap > .item').on('click', function() {
			var _thisIdx = $(this).index()+1;
			if($(location)[0].pathname.split('/')[2]) {
				$(this).addClass('ac').siblings('.item').removeClass('ac');
				
				var stateObj = { link:'/2901030'+_thisIdx+(_param.pk ? '/'+_param.pk:'') };
				stateObj.page = '/view/event-'+$(this).val();
				
				history.pushState(stateObj, '', stateObj.link);
				$('.contents-body-wrap').pageConnectionHandler(stateObj.page, { pk:_param.pk }, function() { crtLeftMenu(_thisIdx); });
			} else if(!$(this).hasClass('info')) alert('행사 등록 후 사용가능합니다.');
		});
		
		$('.event-bar.top > .right-text').on('click', function() { 
			if ((screen.availHeight || screen.height - 30) <= window.innerHeight) closeFullScreenMode();
	      	else openFullScreenMode();
		});
		
		
		$.pb.ajaxCallHandler('/admin/selectAllFuneralHallList.do', { funeralNo:'${sessionScope.loginProcess.FUNERAL_NO}', lv:29 }, function(funeralData) {
			var _funeralData = funeralData.list[0];
			$('.event-bar.bottom > .right-text').html('담당 : '+_funeralData.MANAGER_NAME+' ('+isNull($.pb.phoneFomatter(_funeralData.MANAGER_PHONE))+')');
		});
		
		$.pb.ajaxCallHandler('/admin/selectNoticeList.do', { order:'NOTICE_NO DESC', queryPage:0, display:1 }, function(noticeData) {
			if(noticeData.list.length) {
				var _noticeData = noticeData.list[0];
				$('.event-bar.bottom > .center-text').html(_noticeData.TITLE);
			}
		});
		
		crtLeftMenu(_eventFlag);
		
		if('${sessionScope.loginProcess.CALCULATE_FLAG}' != 1) $('.event-info-top button.item').not('.info').remove();
	});
</script>
<div class="event-bar top">
	<span class="center-text"></span>
	<span class="right-text" style="cursor:pointer;"><img src="/resources/img/icon_full_screen.svg" class="text-icon"/>전체화면</span>
</div>
<div class="space-box"></div>
<div class="event-info-top">
	<div class="left-wrap">
		<button type="button" class="item info" value="sy-info"><span class="title">행사정보</span></button>
		<button type="button" class="item order" value="order"><span class="title">주문</span></button>
		<button type="button" class="item take-back" value="take-back"><span class="title">반품</span></button>
		<button type="button" class="item calculate" value="calculate"><span class="title">정산</span></button>
	</div>
	<div class="right-wrap"></div>
</div>
<form id="eventSubForm"><div class="contents-body-wrap" style="font-size:0;"></div></form>
<div class="event-bar bottom">
	<span class="left-text"><img src="/resources/img/icon_dongsung_logo.svg" class="text-icon"/>동성바이오 v0.01</span>
	<span class="center-text"></span>
	<span class="right-text">담당 : -</span>
</div>
