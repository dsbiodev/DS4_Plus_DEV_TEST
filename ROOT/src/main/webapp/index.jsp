<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<jsp:include page="/WEB-INF/jsp/common/meta.jsp"></jsp:include>
	<jsp:include page="/WEB-INF/jsp/common/title.jsp"></jsp:include>
	<script>
		$(function() {
			$.getScript('/resources/playbench/js/site-common.js', function(data, textStatus, jqxhr) {
			
// 				if (document.location.protocol == 'http:')
// 			        document.location.href = document.location.href.replace('http:', 'https:');
			    
				
				$('.index-login-text').on('keyup', function(e) {
					if(e.keyCode == 13)	$('.index-login-wrap > .btn-login').trigger('click');
				});
				
				$('.pb-right-popup-wrap .top-button.login').on('click', function() { $(location).attr('href', '/main'); });
				$('.pb-right-popup-wrap .popup-body-top > .search-text').on('keyup', function() {
					$('.pb-table.list > tbody > tr').hide();
					if($(this).val()) $('.pb-table.list > tbody').find('td:contains("'+$(this).val()+'")').parent('tr').show();
					else $('.pb-table.list > tbody').find('tr').show();
				});
				
				$.pb.ajaxCallHandler('/admin/selectAllFuneralHallList.do', { userNo:true, order:'FUNERAL_NAME ASC', funeralFlag:true }, function(result) {
					
					$.each(result.list, function(idx) {
						var _tr = $('<tr>');
						_tr.data(this).addClass(idx%2 ? 'alt':'');

						_tr.append('<td>'+this.NAME+'</td>');
						_tr.append('<td>'+this.FUNERAL_NAME+'</td>');
						_tr.append('<td>'+this.ADDRESS+'</td>');
						_tr.on('click', function() {
							$.pb.ajaxCallHandler('/loginProcess.do', { userId:$('.index-login-text.id').val(), userPassword:$('.index-login-text.password').val(), targetUserNo:_tr.data('USER_NO'), session:true }, function(data) {
								if(data) $(location).attr('href', '/main');
								else location.reload();
							}, false);
						});

						$('.pb-right-popup-wrap .pb-table.list > tbody').append(_tr);
					});
				});
				
				$('.index-login-wrap > .btn-login').on('click', function() {
					if($('.index-login-text.id').val() && $('.index-login-text.password').val()) {
						$.pb.ajaxCallHandler('/loginProcess.do', { userId:$('.index-login-text.id').val(), userPassword:$('.index-login-text.password').val(), session:true }, function(data) {
							if($('input[name=autoLogin]').is(":checked")){
								$.pb.settingCookie("dsID", $('.index-login-text.id').val(), true);
								$.pb.settingCookie("dsPW", $('.index-login-text.password').val(), true);
							}
							if(data) {
								if(data.LV == 99) {
									$('.pb-right-popup-wrap').openLayerPopup();
								} else $(location).attr('href', '/main');
							} else alert('입력하신 정보에 해당되는 사용자가 존재하지 않습니다.');
						}, false);
					} else alert('아이디와 비밀번호를 모두 입력해주세요.');
				});
				
				if($.pb.getCookie().dsID && $.pb.getCookie().dsPW){
					$('input[name=autoLogin]').attr("checked", true);
					$('.id').val($.pb.getCookie().dsID);
					$('.password').val($.pb.getCookie().dsPW);
					$('.index-login-wrap > .btn-login').trigger('click');
				}
			});
			

			$('.pb-popup-close').on('click', function() { closeLayerPopup(); });
			
			//모바일/PC 스크립트 인식 구분
			var filter = "win16|win32|win64|mac|macintel";
			if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
			//MOBILE
				document.getElementById("top-button-wrap").style.position="inherit";
				document.getElementById("top-button-wrap").style.width="100%";
				document.getElementById("btn-popup-login").style.width="95%";
				document.getElementById("btn-popup-close").style.display="none";
				document.getElementById("search-text").style.width="100%";
				document.getElementById("search-text").style.marginTop="10px";
				document.getElementById("popup-wrap").style.width="100%";
				document.getElementById("popup-wrap").style.height=$(window).height()+"px";
				document.getElementById("popup-body-top").style.display="inherit";
				document.getElementById("c-table").style.width="100%";
				
				
			}else {
			//PC       
			}
		});
	</script>
</head>
<style>
html { min-width:0px; }
body { background:#fff; }
</style>
<body>
	<div class="pb-right-popup-wrap" id="popup-wrap">
		<div class="pb-popup-title" id="popup-title">관리자로그인</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body">
			<div class="popup-body-top" id="popup-body-top">
				<div class="top-button-wrap" id="top-button-wrap">
					<button type="button" class="top-button login" id="btn-popup-login">관리자 로그인</button>
					<button type="button" class="top-button pb-popup-close" id="btn-popup-close">닫기</button>
				</div>
				<input type="text" class="search-text" placeholder="키워드 검색" id="search-text"/>

			</div>
			<div class="pb-table-wrap">
				<table class="pb-table list" id="c-table">
					<colgroup>
						<col width="20%"/>
						<col width="30%"/>
						<col width="50%"/>
					</colgroup>
					<thead>
						<tr>
							<th>이름</th>
							<th>상호</th>
							<th>장례식장 주소</th>
						</tr>
					</thead>
					<tbody></tbody>
				</table>
			</div>
		</div>
	</div>
	<div class="popup-mask"></div>
	
	<div class="index-contents-wrap" style="background-color:#d0d0d0;">
		<div class="index-login-wrap">
			<div class="index-text-wrap">
				<div class="title">아이디</div>
				<input type="text" class="index-login-text id" placeholder="아이디를 입력 해주세요." value=""/>
			</div>
			<div class="index-text-wrap">
				<div class="title">패스워드</div>
				<input type="password" class="index-login-text password" placeholder="패스워드를 입력 해주세요." value=""/>
			</div>
			<div class="index-text-wrap">
				<div class="autologin">
					<div class="title" style="width:104px; display:inline-block;">자동로그인</div>
					<input type="checkbox" class="index-login-input" name="autoLogin" style="width:20px; height:20px; vertical-align:sub;" value=""/>
				</div>
			</div>
			<button type="button" class="btn-login">로그인</button>
		</div>
		<div class="index-logo-wrap"><img src="/resources/img/dongsung_main_logo.svg"/></div>
	</div>
</body>
</html>