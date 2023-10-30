<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	$(function() {
		var _session = '${sessionScope.loginProcess}' ? JSON.parse('${sessionScope.loginProcess}'):null;
// 		console.log('Top 세션', _session);
		
		if(_session) {
			if(_session.FUNERAL_NAME) $('.login-name').html('<img src="/resources/img/menu_default.png"><span>'+_session.FUNERAL_NAME+'</span><br>'+_session.NAME);
			else $('.login-name').html('<img src="/resources/img/menu_default.png"><br>'+_session.NAME);
			
			var _menuLv = _session.LV+''.slice(0, 1) == 2 ? 29:_session.LV;
			
			var mObj = {
				lv : _menuLv, 
				userNo : _session.USER_NO
			};
			
			if(_session.LV == 99 && _session.FUNERAL_NO) {
				mObj.lv = 29;
				mObj.funeralNo = _session.FUNERAL_NO;
			} else if(_session.LV == 20 && _session.FUNERAL_NO) mObj.lv = 29;
			else if(_session.LV == 91) mObj.lv = 90;
			
			
			var _arrLv = [];
			_arrLv.push(_session.LV)
			if(_session.FUNERAL_NO == 1207) { // 삼육의료원 추가기능
				_arrLv.push(28)
				mObj.lv = _arrLv.join();
				mObj.sy = true;
			}else if(_session.FUNERAL_NO == 523) { //대구의료원국화장례식장
				_arrLv.push(28)
				mObj.lv = _arrLv.join();
				mObj.dgd = true;
			}
			
			$.pb.ajaxCallHandler('/common/selectAllMenu.do', mObj, function(menuData) {
				if(_session.FUNERAL_NO == '1207') {
					var _tmp = {
						"MENU_NO" : 290103,
						"KO" : "삼육 분향실 관리",
						"LV" : "29",
						"STEP" : 2
					}
					menuData.push(_tmp)
				}else if(_session.FUNERAL_NO == '523') {
					var _tmp = {
						"MENU_NO" : 290103,
						"KO" : "대구 분향실 관리",
						"LV" : "29",
						"STEP" : 2
					}
					menuData.push(_tmp)
				}
				
				
				menuData.sort(function(a, b) { return a.MENU_NO - b.MENU_NO; });
				$.each(menuData, function() {
					if(this.STEP == 1) {
						var _menuDiv = $('<div>');
						_menuDiv.addClass('menu').data(this);
						var _icon = $('<span class="icon"></span>');
						var _text = $('<span class="text">'+this.KO+'</span>');
						
						var _iconNo = (_session.LV == 90 || _session.LV == 91 ? '99'+(String(this.MENU_NO).slice(2,6)):this.MENU_NO);
						_icon.attr('style', 'background-image:url("/resources/img/icon_'+_iconNo+'.svg");');
						_menuDiv.append(_icon).append(_text);
						
						if(this.MENU_NO == '991300'){
							
						}
						
						$('.main-left-wrap').append(_menuDiv);
						_menuDiv.on('click', function(){
							//모바일/PC 스크립트 인식 구분
							var filter = "win16|win32|win64|mac|macintel";
							if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
							//MOBILE                  
							}else {//PC   
								$(this).next('.menu-sub-wrap').find('.menu-sub').first().click();
							}
						});
					} else if(this.STEP == 2) {
						var lastMenuNo = $('.main-left-wrap > .menu').last().data('MENU_NO');
						var _subMenuWrap = $('.main-left-wrap > .menu-sub-wrap[data-parent="'+lastMenuNo+'"]');

						if(!_subMenuWrap.length) {
							_subMenuWrap = $('<div>');
							_subMenuWrap.addClass('menu-sub-wrap');
							_subMenuWrap.attr('data-parent', $('.main-left-wrap > .menu').last().data('MENU_NO'));

							$('.main-left-wrap > .menu').last().addClass('p');
							$('.main-left-wrap').append(_subMenuWrap);
						}
						
						var _subMenu = $('<div>');
						_subMenu.addClass('menu-sub').attr('data-link', this.LINK).data(this);
						_subMenu.html(this.KO);
						_subMenu.on('click', function() {
							if(_session) {

								
								//모바일/PC 스크립트 인식 구분
								var filter = "win16|win32|win64|mac|macintel";
								if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
								//MOBILE
									_subMenu.parent('.menu-sub-wrap').prev('.menu.p').addClass('ac').siblings('.menu.p').removeClass('ac');
									
									var _crtLink = '/'+(_session.LV == 90 || _session.LV == 91 ? '99'+(String(_subMenu.data('MENU_NO')).slice(2,6)):_subMenu.data('MENU_NO'));
									var _crtPage = (_session.LV.slice(0,1) == 9 ? (_session.FUNERAL_NO ? '/manager/':'/admin/' ):(_session.LV == 39 ? '/photo/':'/manager/'))+_crtLink;
									
									history.pushState({ link:_crtLink, page:_crtPage }, '', _crtLink);
									$('.main-contents-wrap').pageConnectionHandler(_crtPage, {}, function() {
//	 									console.log('Top 세션', _session);
										$('.menu-sub-wrap').hide();
									});
									
									$('.main-contents-wrap, .event-bar').addClass('simple');
									$('.main-left-wrap').addClass('simple').find('.menu > .text').hide();
									$('.login-name').hide();
									
									var filter = "win16|win32|win64|mac|macintel";
									if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
									//MOBILE
										$('.main-left-wrap').find('.p').hide();
										$('.main-left-wrap').find('.logout').hide();

									}
									
								}else {
								//PC       
									_subMenu.parent('.menu-sub-wrap').prev('.menu.p').addClass('ac').siblings('.menu.p').removeClass('ac');
									
									var _crtLink = '/'+(_session.LV == 90 || _session.LV == 91 ? '99'+(String(_subMenu.data('MENU_NO')).slice(2,6)):_subMenu.data('MENU_NO'));
									var _crtPage = (_session.LV.slice(0,1) == 9 ? (_session.FUNERAL_NO ? '/manager/':'/admin/' ):(_session.LV == 39 ? '/photo/':'/manager/'))+_crtLink;
									
									history.pushState({ link:_crtLink, page:_crtPage }, '', _crtLink);
									$('.main-contents-wrap').pageConnectionHandler(_crtPage, {}, function() {
//	 									console.log('Top 세션', _session);
										$('.menu-sub-wrap').hide();
									});
								}
								
								
							} else $(location).attr('href', '/');
						});
						
						_subMenuWrap.append(_subMenu);
					}
				});
				
				var _linkSplit = $(location)[0].pathname.split('/');
				var _targetMenu = $('.main-left-wrap [data-link="'+'/'+_linkSplit[1]+'/'+_linkSplit[2]+'"]');
				_targetMenu.hasClass('menu') ? _targetMenu.addClass('ac'):_targetMenu.parent('.menu-sub-wrap').prev('.menu.p').addClass('ac');
				
				$('.main-left-wrap .menu, .main-left-wrap .menu-sub').hover(function(e) {
					if($(e.currentTarget).hasClass('menu')) {
						$('.menu-sub-wrap').hide();
						var _scrollY = $(window)[0].scrollY ? $(window)[0].scrollY:document.body.parentNode.scrollTop;
						
						if($(this).data('MENU_NO') == '991300')
							$(this).next('.menu-sub-wrap').css('top', '684px').css('left', $('.main-left-wrap').width()+'px').show();
						else $(this).next('.menu-sub-wrap').css('top', ($(this).offset().top-_scrollY)+'px').css('left', $('.main-left-wrap').width()+'px').show();	
						
						if($(window).height() <= 940){
							if($(this).data('MENU_NO') == '991100')
								$(this).next('.menu-sub-wrap').css('top', '460px').css('left', $('.main-left-wrap').width()+'px').show();
							if($(this).data('MENU_NO') == '991200')
								$(this).next('.menu-sub-wrap').css('top', '572px').css('left', $('.main-left-wrap').width()+'px').show();
						}
					}
				}, function(e) {
					if(!$(e.relatedTarget).is('.menu, .menu-sub')) $('.menu-sub-wrap').hide();
					else if($(e.relatedTarget).hasClass('logout')) $('.menu-sub-wrap').hide();
				});
				
				$('.main-left-wrap').append('<div class="menu logout" style="display:flex;"><span class="icon" style="background-image:url(\'/resources/img/icon_logout.svg\');"></span><span class="text">로그아웃</span></div>');
				$('.main-left-wrap > .menu.logout').on('click', function() { 
					$.pb.delCookie('dsID'); $.pb.delCookie('dsPW');
					$(location).attr('href', '/logoutProcess.do'); 
				});
				
				$('.main-left-wrap > .menu.hamburger').on('click', function() {
					if($('.main-left-wrap').hasClass('simple')) {
						$('.main-contents-wrap, .event-bar').removeClass('simple');
						$('.main-left-wrap').removeClass('simple').find('.menu > .text').show();
					
						var filter = "win16|win32|win64|mac|macintel";
						if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
						//MOBILE
							$('.main-left-wrap').find('.p').show();
							$('.main-left-wrap').find('.logout').show();
							//$('.main-left-wrap').css('overflow-y','scroll');
							//$('.main-left-wrap').css('overflow-x','visible');
						}else{
							$('.login-name').show();
						}
					} else {
						$('.main-contents-wrap, .event-bar').addClass('simple');
						$('.main-left-wrap').addClass('simple').find('.menu > .text').hide();
						$('.login-name').hide();
						
						var filter = "win16|win32|win64|mac|macintel";
						if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
						//MOBILE
							$('.main-left-wrap').find('.p').hide();
							$('.main-left-wrap').find('.logout').hide();
							//$('.main-left-wrap').css('overflow-y','visible');
							//$('.main-left-wrap').css('overflow-x','visible');

						}
					}
				});
				var filter = "win16|win32|win64|mac|macintel";
				if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
				//MOBILE
					$('.main-contents-wrap, .event-bar').addClass('simple');
					$('.main-left-wrap').addClass('simple').find('.menu > .text').hide();
					$('.login-name').hide();
					$('.main-left-wrap').find('.p').hide();
					$('.main-left-wrap').find('.logout').hide();
					$('.main-left-wrap > .menu.p').css('width','100%');
					$('.main-left-wrap > .menu.p').css('display','flex');
					
					
					
					//$('.main-contents-wrap, .event-bar').addClass('simple');
					//$('.main-left-wrap').addClass('simple').find('.menu > .text').hide();
					//$('.login-name').hide();
				}
				// 기본 Simple형
// 				$('.main-contents-wrap').addClass('simple');
// 				$('.main-left-wrap').addClass('simple').find('.menu > .text').hide();
				$('.menu').not('.p, .hamburger, .logout').remove();
				
				if($(location)[0].pathname == '/main') $('.main-left-wrap > .menu-sub-wrap:eq(0)').find('.menu-sub:eq(0)').trigger('click');
			});
		} else $(location).attr('href', '/');
	});
</script>
<div class="main-left-wrap">
	<div class="menu hamburger" >
		<span class="icon" style="float:left;"></span>
		<span class="text">메뉴축소</span>
	</div>
	<div class="login-name"></div>
</div>