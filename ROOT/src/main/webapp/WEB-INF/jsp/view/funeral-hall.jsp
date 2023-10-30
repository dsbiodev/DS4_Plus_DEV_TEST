<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		$.getScript('//dapi.kakao.com/v2/maps/sdk.js?appkey=f7e1fd09c3c8eb31bab7abf293fe6bea&autoload=false&libraries=services', function(data, textStatus, jqxhr) {	//운영
		//$.getScript('//dapi.kakao.com/v2/maps/sdk.js?appkey=1c7c17859fd5b1a0e7c28e96e4192da5&autoload=false&libraries=services', function(data, textStatus, jqxhr) {	//개발	
			daum.maps.load(function() { 
				var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
			    mapOption = { 
			        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
			        level: 3 // 지도의 확대 레벨
			    };
				// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
				var map = new kakao.maps.Map(mapContainer, mapOption); 
				map.setDraggable(false);
				map.setZoomable(false);
			
				// 장례식장 담당자, 영정업체 담당자 가져오기
				$.pb.ajaxCallHandler('/adminSec/selectFuneralManagerList.do', {}, function(data) {
					$('select[name=managerNo]').append('<option value="">선택</option>')
					$.each(data.managerList, function(idx) {
						$('select[name=managerNo]').append('<option value='+this.USER_NO+'>'+this.NAME+'</option>')
					});
					
					$('select[name=photoManagerNo]').append('<option value=>선택</option>')
					$.each(data.photoManagerList, function(idx) {
						$('select[name=photoManagerNo]').append('<option value='+this.USER_NO+'>'+this.COMPANY_NAME+'</option>')
					});
				});
				
				$('.btn-addr').on('click', function(){
					new daum.Postcode({
						oncomplete:function(data) {
//		 					jQuery("#postcode1").val(data.postcode1);
//		 					jQuery("#postcode2").val(data.postcode2);
//		 					jQuery("#zonecode").val(data.zonecode);
							$('input[name=address]').val(data.address).removeClass('necessary-ac');
//		 					jQuery("#address_etc").focus();
								
							var geocoder = new daum.maps.services.Geocoder();
							geocoder.addressSearch(data.address, function(result, status) {
						        if(status === daum.maps.services.Status.OK) {
						        	$('input[name=lat]').val(result[0].y);
						        	$('input[name=lng]').val(result[0].x);
						            var coords = new daum.maps.LatLng(result[0].y, result[0].x);
						            
						            var moveLatLon = new kakao.maps.LatLng(result[0].y, result[0].x);
						 		    map.setCenter(moveLatLon);
						 		   	var marker = new kakao.maps.Marker({ 
						 			    // 지도 중심좌표에 마커를 생성합니다 
						 			    position: map.getCenter() 
					 				});marker.setMap(map);
						        } 
						    });
						}
					}).open();
				});
				
				
				var searchObj = _param;
				searchObj.currentPage = (_param.pk ? _param.pk:1);
				searchObj.queryPage = (_param.pk ? (_param.pk-1)*(_param.display ? _param.display:15):0);
				searchObj.display = (_param.display ? _param.display:15);
				searchObj.order = "USER_NAME != '' DESC, USER_NAME ASC";
				var _table = $('.pb-table.list');
				
				if(_param.funeral){
					$('.contents-title-wrap .title').text("장례식장 조회");
					$('#btnRegister').hide();
					var theadObj = {
						table: _table,
						colGroup:new Array(20, 20, 10, 10, 5, 5, 5, 20, 5),
						theadRow:[ ['', '장례식장'], ['', '주소'], ['', '대표자'], ['', '전화번호'], ['', '빈소수', 3], ['', 'API URL'], ['', '빈소정보'] ],
						theadRowSec:[ ['', ''], ['', ''], ['', ''], ['', ''], [ ['', '총'], ['', '진행'], ['', '공실'] ], ['', ''], ['', ''] ]
					};
					
					theadInit(theadObj, function(_orderText) {
						searchObj.order = _orderText; 
						createFuneralTable(searchObj); 
					});
					
					var createFuneralTable = function(_searchObj) {
						$.pb.ajaxCallHandler('/adminSec/selectFuneralHallList.do', _searchObj, function(tableData) {
							_table.find('tbody').html('');
							$.each(tableData.list, function(idx) {
								var _tr = $('<tr>');
								_tr.data(this);
								_tr.append('<td class="c">'+this.FUNERAL_NAME+'</td>');
								_tr.append('<td class="c">'+this.ADDRESS+'</td>');
								_tr.append('<td class="c">'+(this.BOSS_NAME ? this.BOSS_NAME : '-')+'</td>');
								_tr.append('<td class="c">'+this.CONTACT+'</td>');
								_tr.append('<td class="c">'+this.TOTAL_CNT+'</td>');
								_tr.append('<td class="c">'+this.GOING_CNT+'</td>');
								_tr.append('<td class="c">'+this.EMPTY_CNT+'</td>');
								_tr.append('<td class="c url">'+$(location)[0].origin+'/dsapi/'+btoa(String(this.FUNERAL_NO))+'</td>');
								_tr.append('<td class="c btn-move">이동</td>');
								_tr.find('.btn-move').on('click', function(){
									window.open(_tr.find('.url').text(), '_blank'); 
								});
								_table.find('tbody').append(_tr);
							});
							_searchObj.total = tableData.total;
							$('.contents-body-wrap > .paging').createPaging(_searchObj, function(_page) {
								var pageObj = _searchObj;
					        	pageObj.pk = _page;
					        	pageObj.currentPage = _page;
					        	pageObj.queryPage = (_page-1)*(_searchObj.display*1);
					        	
								var _urlSplit = $(location)[0].pathname.split('/');
								history.pushState({ paging:pageObj }, '', '/'+_urlSplit[1]+'/'+pageObj.currentPage);
								createFuneralTable(pageObj);
					        });
							_table.tableEmptyChecked('검색 결과가 없습니다.'); 
						});	
					}
					createFuneralTable(searchObj); 
					
					$('.search-right-wrap .search-text').on('keyup', function(e) {
						if(e.keyCode == 13) {
							$('.search-text-button').click();
						}
					});
					
					$('.search-text-button').on('click', function(){
						searchObj.currentPage = 1;
						searchObj.queryPage = 0;
						searchObj.searchText = $('.search-right-wrap .search-text').val();
						
						var _pageData = { paging:searchObj };
						var _urlSplit = $(location)[0].pathname.split('/');
						history.pushState(_pageData, '', '/'+_urlSplit[1]+'/1');
						createFuneralTable(searchObj);
					});
					
				}else{
					$('.contents-title-wrap .title').text("장례식장 DB관리");
					$('#btnRegister').show();
					if('${sessionScope.loginProcess.LV}' == 98) $('.chaum').show();
					else $('.chaum').hide();
					var theadObj = {
						table: _table,
						colGroup:new Array(15, 15, 8, 6, 4, 4, 4, 4, 4, 4, 4, '*', 5),
						theadRow:[ ['FUNERAL_NAME', '장례식장'], ['ADDRESS', '주소'], ['CONTACT', '전화번호'], ['USER_NAME', '담당자명'], ['', '빈소수', 3], ['', '정보', 4], ['', 'API URL'], ['', '빈소정보'] ],
						theadRowSec:[ ['', ''], ['', ''], ['', ''], ['', ''], [ ['FUNERAL', '총'], ['', '진행'], ['', '공실'] ], [ ['', '영정수'], ['', '종합현황'], ['', '입관실'], ['', '특수화면'] ], ['', ''], ['', '']]
					};
					
					theadInit(theadObj, function(_orderText) {
						searchObj.order = _orderText;
						createFuneralAllTable(searchObj);
					});
					
					$('.search-right-wrap .search-text').on('keyup', function(e) {
						if(e.keyCode == 13) {
							$('.search-text-button').click();
						}
					});
					
					$('.search-text-button').on('click', function(){
						searchObj.currentPage = 1;
						searchObj.queryPage = 0;
						searchObj.searchText = $('.search-right-wrap .search-text').val();
						
						var _pageData = { paging:searchObj };
						var _urlSplit = $(location)[0].pathname.split('/');
						history.pushState(_pageData, '', '/'+_urlSplit[1]+'/1');
						createFuneralAllTable(searchObj);
					});
					
					
					$('#btnRegister').on('click', function() {
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.top-button.register').val('');
							_thisLayer.find('.pb-popup-form.modify').hide();
							_thisLayer.find('.table-search.icon-search').val('').trigger('keyup').show();
							_thisLayer.find('.pb-table-wrap').show().find('.pb-table.list tr').removeClass('ac');
							_thisLayer.find('.row-button.upd,.row-button.del').hide();
							_thisLayer.find('.row-button.add').show();
							$('.popup-table').find('tbody').html('');
							$("input[type=file][name=funeralImg]").val("");
							$('.funeral-img').removeClass('add').html("");
							$("input[type=file][name=logoImg]").val("");
							$('.logo-img').removeClass('add').html("");
							
							/* HYH - seal image */
							$("input[type=file][name=sealImg]").val("");
							$('.seal-img').removeClass('add').html("");
							/* ./HYH - seal image */
							
							$(".div-divide input").val("");
							$('.divide-img').removeClass('add').html("");
							layerInit(_thisLayer);
							$('input[name=disabledPersonFacility][value=0]').click();
							$('input[name=waitingRoom][value=0]').click();
							$('input[name=operationKind][value=0]').click();
							$("input:radio[name='classification']").attr("disabled", false);
							
							setTimeout(function() {
								map.relayout();
								var moveLatLon = new kakao.maps.LatLng(37.3448139, 127.8802017);
					 		    map.setCenter(moveLatLon);
					 		   	var marker = new kakao.maps.Marker({ 
					 			    // 지도 중심좌표에 마커를 생성합니다 
					 			    position: map.getCenter() 
				 				});marker.setMap(map);
								$('.pb-popup-body').scrollTop(0);
							}, 100);
							
						});
					});
					
					$('input[type=radio][name=disabledPersonFacility]').siteRadio({ addText:['유', '무'], fontSize:'16px', defaultValue:'1'});
					$('input[type=radio][name=waitingRoom]').siteRadio({ addText:['유', '무'], fontSize:'16px', defaultValue:'1'});
					$('input[type=radio][name=operationKind]').siteRadio({ addText:['병원장례식장', '전문장례식장'], fontSize:'16px', defaultValue:'1'});
					$('input[type=radio][name=calculateFlag]').siteRadio({ addText:['미사용', '사용'], fontSize:'16px'});
					$('input[type=radio][name=funeralFlag]').siteRadio({ addText:['미사용', '사용'], fontSize:'16px'});
					$('input[type=radio][name=allianceFlag]').siteRadio({ addText:['미제휴', '제휴'], fontSize:'16px'});
					$('input[type=radio][name=classification]').pbRadiobox({ addText:['빈소', '영정', '종합현황', '입관실', '특수화면', '상가현황', '대기화면'], fontSize:'16px', matchParent:false });
					$.pb.createCityCodeSelectBox($('select[name=sido]'), $('select[name=gungu]'));
					$('input[name=contact]').phoneFomatter();
					$('input[name=calculateContact]').phoneFomatter();
					$('input[name=callmix]').phoneFomatter();
					$('input[name=busNo]').busNoFomatter();
					
					
					//이미지 업로드 
					$('.funeral-img').bind('click', function() {
						if($(this).hasClass('add')){
							if(confirm("삭제하시겠습니까?")){
								$(this).siblings('input[type=file][name=funeralImg]').val("");
								$(this).removeClass('add').html("");
							}
						}else $(this).siblings('input[type=file][name=funeralImg]').click();	
					});
					$("input[type=file][name=funeralImg]").bind("change", function() {
						var $this = $(this);
						var $files = $this[0].files;
						$.each($files, function() {
							var reader = new FileReader();
							var f = this;
							reader.onload = function(rst) {
								$this.siblings('.funeral-img').addClass('add').html('<img src='+rst.target.result+' class="images"/>');
							};
							reader.readAsDataURL(f);
						});
					});
					
					$('.logo-img').bind('click', function() {
						if($(this).hasClass('add')){
							if(confirm("삭제하시겠습니까?")){
								$(this).siblings('input[type=file][name=logoImg]').val("");
								$(this).removeClass('add').html("");
							}
						}else $(this).siblings('input[type=file][name=logoImg]').click();
					});
					$("input[type=file][name=logoImg]").bind("change", function() {
						var $this = $(this);
						var $files = $this[0].files;
						$.each($files, function() {
							var reader = new FileReader();
							var f = this;
							reader.onload = function(rst) {
								$this.siblings('.logo-img').addClass('add').html('<img src='+rst.target.result+' class="images"/>');
							};
							reader.readAsDataURL(f);
						});
					});
					
					
					
					// seal image
					$('.seal-img').bind('click', function() {
						if($(this).hasClass('add')){
							$(this).siblings('input[type=file][name=sealImg]').val("");
							$(this).removeClass('add').html("");
						}else $(this).siblings('input[type=file][name=sealImg]').click();	
					});
					$("input[type=file][name=sealImg]").bind("change", function() {
						var $this = $(this);
						var $files = $this[0].files;
						$.each($files, function() {
							var reader = new FileReader();
							var f = this;
							reader.onload = function(rst) {
								$this.siblings('.seal-img').addClass('add').html('<img src='+rst.target.result+' class="images"/>');
							};
							reader.readAsDataURL(f);
						});
					});
					
					
					
					/// 분할 이미지
					$('.divide-img').bind('click', function() {
						if($(this).hasClass('add')){
							$(this).prev('input[type=file]').val("");
							$(this).removeClass('add').html("");
						}else $(this).prev('input[type=file]').click();
					});
					$("input[type=file]").bind("change", function() {
						var $this = $(this);
						var $files = $this[0].files;
						$.each($files, function() {
							var reader = new FileReader();
							var f = this;
							reader.onload = function(rst) {
								$this.next('.divide-img').addClass('add').html('<img src='+rst.target.result+' class="images"/>');
							};
							reader.readAsDataURL(f);
						});
					});

					var createFuneralAllTable = function(_searchObj) {
						$.pb.ajaxCallHandler('/adminSec/selectAllFuneralHallList.do', _searchObj, function(tableData) {
							_table.find('tbody').html('');
							$.each(tableData.list, function(idx) {
								var _tr = $('<tr>');
								_tr.data(this);
								_tr.append('<td class="c">'+this.FUNERAL_NAME+'<br>['+this.GUNGU_NAME+']</td>');
								_tr.append('<td class="c">'+this.ADDRESS+'</td>');
								_tr.append('<td class="c">'+this.CONTACT+'</td>');
								_tr.append('<td class="c">'+(this.USER_NAME ? this.USER_NAME : '')+'</td>');
								_tr.append('<td class="c">'+(this.USER_NAME ? this.FUNERAL : '')+'</td>');
								_tr.append('<td class="c">'+(this.USER_NAME ? this.GOING_CNT : '')+'</td>');
								_tr.append('<td class="c">'+(this.USER_NAME ? this.EMPTY_CNT : '')+'</td>');
								_tr.append('<td class="c">'+(this.USER_NAME ? this.PHOTO : '')+'</td>');
								_tr.append('<td class="c">'+(this.USER_NAME ? this.ALL_STATUS : '')+'</td>');
								_tr.append('<td class="c">'+(this.USER_NAME ? this.ENTRY : '')+'</td>');
								_tr.append('<td class="c">'+(this.USER_NAME ? this.SPECIAL : '')+'</td>');
								if(this.USER_NAME){
									_tr.append('<td class="c url ">'+$(location)[0].origin+'/dsapi/'+btoa(String(this.FUNERAL_NO))+'</td>');
									_tr.append('<td class="c btn-move">이동</td>');
								}else{
									_tr.append('<td class="c"></td>');
									_tr.append('<td class="c"></td>');
								}
								
								_tr.find('.btn-move').on('click', function(e){
									window.open(_tr.find('.url').text(), '_blank'); 
								});
								
								//장례식장 목록 row click event
								_tr.find('td').not('.btn-move').on('click', function(e) {
									$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
										$.pb.ajaxCallHandler('/adminSec/selectFuneralDivideImg.do', {funeralNo : _tr.data('FUNERAL_NO') }, function(data) {
											$.each(data.divideImg, function(idx, value){
												$('.div-divide').find('input[name='+this.DIVIDE+']').next().addClass('add').html('<img src='+this.PATH+' class="images"/>');
											});
										});
										
										$('.imagebox').removeClass('add').html("");
										popup_list(_tr.data('FUNERAL_NO'));
										_thisLayer.find('.top-button.register').val(_tr.data('FUNERAL_NO'));
										_thisLayer.find('.pb-popup-form.modify').show().find('#funeralName').val(_tr.data('FUNERAL_NAME'));
										_thisLayer.find('.table-search.icon-search, .pb-table-wrap').hide();
										if(_tr.data('FUNERAL_IMG')) $('.funeral-img').addClass('add').html('<img src='+_tr.data('FUNERAL_IMG')+' class="images"/>');
										if(_tr.data('LOGO_IMG')) $('.logo-img').addClass('add').html('<img src='+_tr.data('LOGO_IMG')+' class="images"/>');
										
										/* HYH - seal image */
										if(_tr.data('SEAL_IMG')) $('.seal-img').addClass('add').html('<img src='+_tr.data('SEAL_IMG')+' class="images"/>');
										/* ./HYH - seal image */
										
										$("input:radio[name='classification']").attr("disabled", false);
										
										var geocoder = new daum.maps.services.Geocoder();
										geocoder.addressSearch(_tr.data('ADDRESS'), function(result, status) {
									        if(status === daum.maps.services.Status.OK) {
									            var coords = new daum.maps.LatLng(result[0].y, result[0].x);
									 			map.relayout();
												var moveLatLon = new kakao.maps.LatLng(result[0].y, result[0].x);
									 		    map.setCenter(moveLatLon);
									 		   	var marker = new kakao.maps.Marker({ 
									 			    // 지도 중심좌표에 마커를 생성합니다 
									 			    position: map.getCenter() 
								 				});marker.setMap(map);
									        } 
									    });
										layerInit(_thisLayer, _tr.data());
										setTimeout(function() { // 시/도 변경되면서 시간이 걸려서 추가
											$('select[name=gungu]').val(_tr.data('GUNGU'));
											$('.pb-popup-body').scrollTop(0);
										}, 100);
										
										//관리자 번호 display
										//값이 존재하면 배열에 담아서 순서대로 DIV에 출력
										var arrMgrNm = new Array();
										var arrMgrPhone = new Array();
										
										if(_tr.data('MGR_NM_2')){
											arrMgrNm.push(_tr.data('MGR_NM_2'));
											arrMgrPhone.push(_tr.data('MGR_PHONE_2'));	
										}
										
										if(_tr.data('MGR_NM_3')){
											arrMgrNm.push(_tr.data('MGR_NM_3'));
											arrMgrPhone.push(_tr.data('MGR_PHONE_3'));
										}
										
										if(_tr.data('MGR_NM_4')){
											arrMgrNm.push(_tr.data('MGR_NM_4'));
											arrMgrPhone.push(_tr.data('MGR_PHONE_4'));
										}
										
										if(_tr.data('MGR_NM_5')){
											arrMgrNm.push(_tr.data('MGR_NM_5'));
											arrMgrPhone.push(_tr.data('MGR_PHONE_5'));	
										}
																	
										for(var i=0; i<arrMgrNm.length; i++){											
											if(arrMgrNm[i]){
												
												addMgrDiv(i)												
												
												$('#mgrDivNm'+i).find('input[name=mgrNm]').val(arrMgrNm[i]);
												$('#mgrDivPhone'+i).find('input[name=mgrPhone]').val(arrMgrPhone[i]);		
											}																							
										}
										
										//삭제버튼 이미지 이벤트
							 			$('#mgrBtn0').unbind('click').bind('click',function(){
											$('#mgrDivNm0').remove();
											$('#mgrDivPhone0').remove();		
										}); 			
											
										$('#mgrBtn1').unbind('click').bind('click',function(){
											$('#mgrDivNm1').remove();
											$('#mgrDivPhone1').remove();		
											});
										
										$('#mgrBtn2').unbind('click').bind('click',function(){
											$('#mgrDivNm2').remove();
											$('#mgrDivPhone2').remove();		
											});
										
										$('#mgrBtn3').unbind('click').bind('click',function(){
											$('#mgrDivNm3').remove();
											$('#mgrDivPhone3').remove();		
										});											
										
										
									});
								});
								_table.find('tbody').append(_tr);
							});
							
							_searchObj.total = tableData.total;
							$('.contents-body-wrap > .paging').createPaging(_searchObj, function(_page) {
								var pageObj = _searchObj;
					        	pageObj.pk = _page;
					        	pageObj.currentPage = _page;
					        	pageObj.queryPage = (_page-1)*(_searchObj.display*1);
					        	
								var _urlSplit = $(location)[0].pathname.split('/');
								history.pushState({ paging:pageObj }, '', '/'+_urlSplit[1]+'/'+pageObj.currentPage);
								createFuneralAllTable(pageObj);
					        });
							
							_table.tableEmptyChecked('검색 결과가 없습니다.');
						});
					};
					createFuneralAllTable(searchObj);
					
					
					$('.top-button.register').on('click', function(){
						if(!necessaryChecked($('#dataForm'))) {
							var _url = $(this).val() ? '/adminSec/updateAllFuneralHall.do' : '/adminSec/insertAllFuneralHall.do';
							var _formData = new FormData($('#dataForm')[0]);
							_formData.append('funeralNo', $(this).val());
							_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
							_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
							
							var _menuNo = [];
							if($('input[name=calculateFlag]:checked').val() == 0){
								_menuNo.push(290201,290202,290203,290204,290301,290701);
								_formData.append('menuNoList', _menuNo);
							}
							
							var arr_list = [];
							$('.div-divide > input[type=file]').each(function(idx){
								if(!$(this).val()){
									if($(this).next().find('img').attr('src')){
										var $list = {
												divide : $(this).attr('name'),
												path : $(this).next().find('img').attr('src')
										};
										arr_list.push($list);
									}
								}
							});
							_formData.append('divideList', JSON.stringify(arr_list));

							if($(this).val()){
								if(!$('input[name=funeralImg]').val() && typeof $('.funeral-img').find('img').prop('src') != "undefined")
									_formData.append('funeralImg', $('.funeral-img').find('img').prop('src'));
								if(!$('input[name=logoImg]').val() && typeof $('.logo-img').find('img').prop('src') != "undefined")
									_formData.append('logoImg', $('.logo-img').find('img').prop('src'));
								
								/* HYH - seal image */
								if(!$('input[name=sealImg]').val() && typeof $('.seal-img').find('img').prop('src') != "undefined")
									_formData.append('sealImg', $('.seal-img').find('img').prop('src'));
							}
							
							//mgr valid & display
																														
							//mgrname
							var colNo = 2;
							
 							$('#rowMgrNm').find('input[name=mgrNm]').each(function(i, obj) {
																																																	
								_formData.append('MGR_NM_'+colNo,$(this).val());
																	
								colNo++															    							    							    
							}); 
 							
							var colPNo = 2;
 							//mgrPhone
 							$('#rowMgrPhone').find('input[name=mgrPhone]').each(function(i, obj) {
								
								_formData.append('MGR_PHONE_'+colPNo,$(this).val());
																	
								colPNo++															    							    							    
							});  							
																																				
							$.pb.ajaxUploadForm(_url, _formData, function(result) {
								$('.top-button-wrap').find('button').prop('disabled', true);
								if(result != 0) {
									createFuneralAllTable(searchObj);
									$('.top-button-wrap').find('button').prop('disabled', false);
									$('.pb-popup-close').click();
								} else alert('저장 실패 관리자에게 문의하세요');
							}, '${sessionScope.loginProcess}');
						}else{
							if(!$('input[name=funeralName]').val()) return alert("장례식장명을 입력해 주세요.");
							if(!$('input[name=bossName]').val()) return alert("대표자명을 입력해 주세요.");
							if(!$('input[name=calculateName]').val()) return alert("관리자명을 입력해 주세요.");
							if(!$('input[name=calculateContact]').val()) return alert("관리자연락처를 입력해 주세요.");
							if(!$('input[name=parkingCnt]').val()) return alert("주차가능대수를 입력해 주세요.");
							if(!$('input[name=funeralCnt]').val()) return alert("빈소수를 입력해 주세요.");
							if(!$('select[name=sido]').val()) return alert("장례식장 시/도를 선택해 주세요.");
							if(!$('select[name=gungu]').val()) return alert("장례식장 군/구를 선택해 주세요.");
							if(!$('input[name=address]').val()) return alert("장례식장주소를 입력해 주세요.");
							if(!$('select[name=managerNo]').val()) return alert("동성담당자를 선택해 주세요.");
						}
					});
					
					$("input:radio[name='classification']").on('change', function(){
						if($(this).val() == 10){
							$('input[name=buildingName]').prop('disabled', false).val("");
							$('input[name=areaSize]').prop('disabled', false).val("");
							$('input[name=floor]').prop('disabled', false).val("");
						}else{
							$('input[name=buildingName]').prop('disabled', true).val("");
							$('input[name=areaSize]').prop('disabled', true).val("");
							$('input[name=floor]').prop('disabled', true).val("");
						}
					});
					
					var popup_list = function(_funeralNo){
						$('.popup-table').find('tbody tr').removeClass('ac');
						$('.row-button.upd,.row-button.del').hide();$('.row-button.add').show();
						$.pb.ajaxCallHandler('/adminSec/selectRaspberryConnectionList.do', {funeralNo:_funeralNo}, function(tableData) {
							
							$('.popup-table').find('tbody').html('');
							$.each(tableData.list, function(idx) {
								var _tr = $('<tr>');
								_tr.data(this);
								_tr.append('<td class="c">'+this.CLASSIFICATION_NAME+'</td>');
								_tr.append('<td class="c">'+this.APPELLATION+'</td>');
								_tr.append('<td class="c">'+this.EXPOSURE+'</td>');
								_tr.append('<td class="c">'+(this.BUILDING_NAME ? this.BUILDING_NAME : '-')+'</td>');
								_tr.append('<td class="c">'+(this.FLOOR ? this.FLOOR : '-')+'</td>');
								_tr.append('<td class="c">'+(this.AREA_SIZE ? this.AREA_SIZE : '-')+'</td>');
								_tr.on('click', function(){
									if(_tr.hasClass('ac')){
										_tr.removeClass('ac');
										$("input:radio[name='classification']").attr("disabled", false);
										$('.row-button.upd,.row-button.del').hide();$('.row-button.add').show();
										$('input[name=appellation]').val("");
										$('input[name=buildingName]').val("");
										$('input[name=areaSize]').val("");
										$('input[name=floor]').val("");
										$('select[name=exposure]').val(1);
										$("input[name='classification']:radio[value='10']").click();
									}
									else{
										$('.row-button.upd').data($(this).data());$('.row-button.del').data($(this).data());
										$('.row-button.upd,.row-button.del').show();$('.row-button.add').hide();
					 					$('.popup-table').find('tbody tr').removeClass('ac');
										_tr.addClass('ac');
										$("input:radio[name='classification']:radio[value='"+_tr.data('CLASSIFICATION')+"']").click();
										$("input:radio[name='classification']").attr("disabled", true);
										$('input[name=appellation]').val(_tr.data('APPELLATION'));
										$('input[name=buildingName]').val(_tr.data('BUILDING_NAME'));
										$('input[name=areaSize]').val(_tr.data('AREA_SIZE'));
										$('input[name=floor]').val(_tr.data('FLOOR'));
										$('select[name=exposure]').val(_tr.data('EXPOSURE'));
										$('input[name=rasCnt]').val(_tr.data('RAS_CNT'));
									}
								});
								$('.popup-table').find('tbody').append(_tr);
							});
						});
						$('.row-button.upd,.row-button.del').hide();$('.row-button.add').show();
					}
					
					
					
					$('.row-button.add').on('click', function(){
						//먼저 장례식장을 등록해 주세요
						if(!$('.top-button.register').val()) return alert('장례식장을 먼저 등록해 주세요.');
						if(!$('input[name=appellation]').val()) return alert('명칭을 적어주세요.');
						var _formData = new FormData($('#dataForm')[0]);
						_formData.append('funeralNo', $('.top-button.register').val());
						_formData.append('appellation', $('input[name=appellation]').val());
						_formData.append('buildingName', $('input[name=buildingName]').val());
						_formData.append('floor', $('input[name=floor]').val());
						_formData.append('areaSize', $('input[name=areaSize]').val());
						_formData.append('exposure', $('select[name=exposure]').val());
						_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
						$.pb.ajaxUploadForm('/adminSec/insertRaspberryConnection.do', _formData, function(result) {
							$('.btn-box').find('button').prop('disabled', true);
							if(result != 0) {
								$("input:radio[name='classification']").attr("disabled", false);
								$("input:radio[name='classification']:radio[value='"+$("input:radio[name='classification']:checked").val()+"']").click();
								$('input[name=appellation]').val("");
								$('input[name=buildingName]').val("");
								$('input[name=floor]').val("");
								$('input[name=areaSize]').val("");
								$('select[name=exposure]').val(1);
								popup_list($('.top-button.register').val());
								$('.btn-box').find('button').prop('disabled', false);
								createFuneralAllTable(searchObj);
							} else alert('저장 실패 관리자에게 문의하세요');
						}, '${sessionScope.loginProcess}');
					});
					
					
					$('.row-button.upd').on('click', function(){
						if(!$('input[name=appellation]').val()) return alert('명칭을 적어주세요.');
						var _formData = new FormData($('#dataForm')[0]);
						_formData.append('respberryConnectionNo', $(this).data('RASPBERRY_CONNECTION_NO'));
						_formData.append('appellation', $('input[name=appellation]').val());
						_formData.append('buildingName', $('input[name=buildingName]').val());
						_formData.append('floor', $('input[name=floor]').val());
						_formData.append('areaSize', $('input[name=areaSize]').val());
						_formData.append('exposure', $('select[name=exposure]').val());
						_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
						$.pb.ajaxUploadForm('/adminSec/updateRaspberryConnection.do', _formData, function(result) {
							$('.btn-box').find('button').prop('disabled', true);
							if(result != 0) {
								$("input:radio[name='classification']").attr("disabled", false);
								$("input:radio[name='classification']:radio[value='"+$("input:radio[name='classification']:checked").val()+"']").click();
								$('input[name=appellation]').val("");
								$('input[name=buildingName]').val("");
								$('input[name=floor]').val("");
								$('input[name=areaSize]').val("");
								$('select[name=exposure]').val(1);
								popup_list($('.top-button.register').val());
								$('.btn-box').find('button').prop('disabled', false);
								createFuneralAllTable(searchObj);
							} else alert('저장 실패 관리자에게 문의하세요');
						}, '${sessionScope.loginProcess}');
					});
					
					$('.row-button.del').on('click', function(){
						if($('input[name=rasCnt]').val() > 0) return alert("등록된 라즈베리를 먼저 삭제해주세요.");
						var _formData = new FormData($('#dataForm')[0]);
						_formData.append('respberryConnectionNo', $(this).data('RASPBERRY_CONNECTION_NO'));
						_formData.append('updateUserNo', '${sessionScope.loginProcess.USER_NO}');
						$.pb.ajaxUploadForm('/adminSec/deleteRaspberryConnection.do', _formData, function(result) {
							$('.btn-box').find('button').prop('disabled', true);
							if(result != 0) {
								$("input:radio[name='classification']").attr("disabled", false);
								$("input:radio[name='classification']:radio[value='10']").click();
								$('input[name=appellation]').val("");
								$('input[name=buildingName]').val("");
								$('input[name=floor]').val("");
								$('input[name=areaSize]').val("");
								$('select[name=exposure]').val(1);
								popup_list($('.top-button.register').val());
								$('.btn-box').find('button').prop('disabled', false);
								createFuneralAllTable(searchObj);
							} else alert('저장 실패 관리자에게 문의하세요');
						}, '${sessionScope.loginProcess}');
					});
				}
			});
		});
		

		$('.pb-popup-close, .popup-mask').on('click', function() {
			
			//취소 시 관리자 등록 div 삭제
			for(var i=0; i<4;i++){
				$('#mgrDivNm'+i).remove();
				$('#mgrDivPhone'+i).remove();				
			}		
			
			
			closeLayerPopup(); 
			});
		
		function addMgrDiv(mgrCnt){
			
			//관리자 이름
			var divMgrNM = $('#rowMgrNm');
			
			var mgrNmWrap = $('<div class="row-box" id="mgrDivNm'+mgrCnt+'">');
			mgrNmWrap.append('<label class="title" ></label>');
			mgrNmWrap.append('<input type="text" class="form-text MgrName" name="mgrNm" placeholder="관리자명"/>');				
			mgrNmWrap.append('</div>');
								
			divMgrNM.append(mgrNmWrap);
			
			//관리자 연락처
			var divMgrPhone = $('#rowMgrPhone');
			
 			var mgrPhoneWrap = $('<div class="row-box" id="mgrDivPhone'+mgrCnt+'">');
			mgrPhoneWrap.append('<label class="title" ></label>');
			mgrPhoneWrap.append('<input type="text" class="form-text MgrPhone" name="mgrPhone" placeholder="관리자 연락처"/>');
			mgrPhoneWrap.append('<button type="button" class="mgrBtn" id="mgrBtn'+mgrCnt+'"><img class = "mgrImg" src = "/resources/img/Mgrdel.png"></button>');
			mgrPhoneWrap.find('input[name=mgrPhone]').phoneFomatter();
			
			mgrPhoneWrap.append('</div>');
						
			divMgrPhone.append(mgrPhoneWrap);
			
		}
		
		//관리자 추가 버튼 클릭 이벤트
		$('#btnMgrAdd').on('click',function(){
			
			//get div manager count
			var divMgr = document.getElementsByClassName('form-text MgrName');								
			var mgrCnt = (divMgr.length);
					
			if(mgrCnt > 3){
				alert("관리자 정보는 5개까지 등록가능합니다.")
				return;
			}
			
			addMgrDiv(mgrCnt);

 			$('#mgrBtn0').unbind('click').bind('click',function(){
				$('#mgrDivNm0').remove();
				$('#mgrDivPhone0').remove();		
			}); 			
				
			$('#mgrBtn1').unbind('click').bind('click',function(){
				$('#mgrDivNm1').remove();
				$('#mgrDivPhone1').remove();		
				});
			
			$('#mgrBtn2').unbind('click').bind('click',function(){
				$('#mgrDivNm2').remove();
				$('#mgrDivPhone2').remove();		
				});
			
			$('#mgrBtn3').unbind('click').bind('click',function(){
				$('#mgrDivNm3').remove();
				$('#mgrDivPhone3').remove();		
			});		 
		});
		
		
	
	});
</script>

<style>
 .row-box { margin-top:20px; font-size:0; position:relative; }
 .title { width:156px; display:inline-block; box-sizing:border-box; padding:0 16px; color:#333333; font-size:16px; font-weight:500; letter-spacing:0.8px; text-align:right; }
 .form-text { width:calc(100% - 156px); height:36px; display:inline-block; padding-left:12px; box-sizing:border-box; border:1px solid #707070; border-radius:2px; background:#F6F6F6; color:#333333; font-size:16px; font-weight:500; letter-spacing:0.8px;}
 .mgrBtn{ width:40px; height:36px; position:absolute; right:0; border-radius:4px; letter-spacing:0.9px;}
 .mgrImg{    border: 1px solid; width: 40px;  height: 36px;  position: relative; right: 0px;  bottom: 1px;}


  #nothingDiv1 {
 	visibility: hidden;
  }
  #nothingDiv2 {
 	visibility: hidden;
  } 
</style>

<form id="dataForm">
	<div id="pb-right-popup-wrap" class="pb-right-popup-wrap full-size">
		<input type="hidden" name="funeralNo" value=""/>
		<div class="pb-popup-title">장례식장 DB 관리</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body half">
			<div class="popup-body-top">
				<div class="top-title">장례식장 정보</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register">저장</button>
					<button type="button" class="top-button pb-popup-close">취소</button>
				</div>
			</div>
			<div class="pb-popup-form">
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">*장례식장명</label>
						<input type="text" class="form-text necessary" name="funeralName" placeholder="장례식장명"/>
					</div>
					<div class="row-box">
						<label class="title">대표전화번호</label>
						<input type="text" class="form-text" name="contact" placeholder="대표전화번호"/>
					</div>
					
					<div class="row-box">
						<div style="width:142px;height:36px" >							
							<button  type="button" class="row-button add"></button>							
						</div>
					</div>
										
					<div class="row-box" id="rowMgrNm">
						<label class="title">*관리자명</label>
						<input type="text" class="form-text necessary" name="calculateName" placeholder="관리자명"/>
					</div>
					
					<div class="row-box">
						<label class="title">관리자이메일</label>
						<input type="text" class="form-text" name="calculateEmail" placeholder="관리자이메일"/>
					</div>
					<div class="row-box">
						<label class="title">대표이미지</label>
						<input type="file" id="funeralImg" name="funeralImg" accept="image/*"/>
						<button type="button" class="imagebox funeral-img"></button>
					</div>
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">*대표자명</label>
						<input type="text" class="form-text necessary" name="bossName" placeholder="대표자명"/>
					</div>
					<div class="row-box">
						<label class="title">식장홈페이지</label>
						<input type="text" class="form-text" name="homepage" placeholder="홈페이지 주소"/>
					</div>
					
					<div class="row-box">
						<div class="btn-box">							
							<button type="button" class="row-button mgrAdd" id="btnMgrAdd">관리자 추가</button>							
						</div>
					</div>
										
					<div class="row-box" id="rowMgrPhone">
						<label class="title">*관리자연락처</label>
						<input type="text" class="form-text necessary" name="calculateContact" placeholder="관리자연락처"/>
					</div>
					
					<!-- HYH - admin 직인이미지 hidden 처리 -->
					<div class="row-box" id="nothingDiv1">
							<label class="title">-</label>							
					</div>
					
					<div class="row-box" id="nothingDiv2">							
						<label class="title">직인 이미지</label>
						<input type="file" id="sealImg" name="sealImg" accept="image/*"/>
						<button type="button" class="imagebox seal-img"></button>
					</div>				
					<!-- ./HYH - admin 직인이미지 hidden 처리 -->
					
				</div>
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title">로고 이미지</label>
						<input type="file" id="logoImg" name="logoImg" accept="image/*"/>
						<button type="button" class="imagebox logo-img"></button>
					</div>
					
					<div class="row-box">
						<label class="title">분할 이미지</label>
						<div class="div-divide">
							<input type="file" id="divide02" name="divide02" accept="image/*"/>
							<button type="button" class="imagebox divide-img"></button>
							
							<input type="file" id="divide04" name="divide04" accept="image/*"/>
							<button type="button" class="imagebox divide-img"></button>
							
							<input type="file" id="divide06" name="divide06" accept="image/*"/>
							<button type="button" class="imagebox divide-img"></button>
							
							<input type="file" id="divide08" name="divide08" accept="image/*"/>
							<button type="button" class="imagebox divide-img"></button>
						</div>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title" style="letter-spacing:0.5px;">*장애인편의시설</label>
						<input type="radio" class="form-text" name="disabledPersonFacility" value="1"/>
						<input type="radio" class="form-text" name="disabledPersonFacility" value="0"/>
					</div>
					<div class="row-box">
						<label class="title">*운영종류</label>
						<input type="radio" class="form-text" name="operationKind" value="1"/>
						<input type="radio" class="form-text" name="operationKind" value="0"/>
					</div>
					<div class="row-box">
						<label class="title">*빈소수</label>
						<input type="text" class="form-text necessary" name="funeralCnt" placeholder="빈소수"/>
					</div>
					<div class="row-box">
						<label class="title">*장례식장 시/도</label>
						<select class="form-select necessary" name="sido"></select>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">*유족대기실</label>
						<input type="radio" class="form-text" name="waitingRoom" value="1"/>
						<input type="radio" class="form-text" name="waitingRoom" value="0"/>
					</div>
					<div class="row-box">
						<label class="title" style="letter-spacing:0.5px;">*주차장가능대수</label>
						<input type="text" class="form-text necessary" name="parkingCnt" placeholder="주차장가능대수"/>
					</div>
					<div class="row-box">
						<label class="title">영정업체 담당자</label>
						<select class="form-select" name="photoManagerNo"></select>
					</div>
					<div class="row-box">
						<label class="title">*장례식장 군/구</label>
						<select class="form-select necessary" name="gungu"></select>
					</div>
				</div>
				
				<div class="form-box-st-01">
					<div class="row-box" style="position:relative;">
						<label class="title">*장례식장주소</label>
						<input type="text" class="form-text necessary" name="address" placeholder="주소" readonly/>
						<button type="button" class="btn-addr">주소찾기</button>
					</div>
					<div class="row-box">
						<label class="title">상세주소</label>
						<input type="hidden" class="form-text" name="lat">
						<input type="hidden" class="form-text" name="lng">
						<input type="text" class="form-text" name="addressDetail" placeholder="상세주소"/>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">사업자번호</label>
						<input type="text" class="form-text" name="busNo" placeholder="직접입력"/>
					</div>
					<div class="row-box">
						<label class="title">*동성담당자</label>
						<select class="form-select necessary" name="managerNo"></select>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">*정산이용 여부</label>
						<input type="radio" class="form-text" name="calculateFlag" value="0"/>
						<input type="radio" class="form-text" name="calculateFlag" value="1"/>
					</div>
					<div class="row-box">
						<label class="title">*활성화 여부</label>
						<input type="radio" class="form-text" name="funeralFlag" value="0"/>
						<input type="radio" class="form-text" name="funeralFlag" value="1"/>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box chaum">
						<label class="title">*제휴여부</label>
						<input type="radio" class="form-text " name="allianceFlag" value="0"/>
						<input type="radio" class="form-text" name="allianceFlag" value="1"/>
					</div>
					
				</div>
				
				<div class="form-box-st-01">
					<div class="row-box chaum">
						<label class="title">*제휴혜택</label>
						<input type="text" class="form-text" name="alliance" placeholder="직접입력"/>
					</div>
					<div class="row-box chaum">
						<label class="title">*콜믹스번호</label>
						<input type="text" class="form-text" name="callmix" placeholder="직접입력"/>
					</div>
				</div>
				
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title">지도상세</label>
						<div id="map"></div>
					</div>
				</div>
			</div>
		</div> 	
		
		<div class="pb-popup-body half">
			<div class="popup-body-top">
				<div class="top-title">세부사항</div>
			</div>
			<div class="pb-popup-form">
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title">세부추가</label>
						<input type="radio" class="form-text" name="classification" value="10"/>
						<input type="radio" class="form-text" name="classification" value="20"/>
						<input type="radio" class="form-text" name="classification" value="30"/>
						<input type="radio" class="form-text" name="classification" value="40"/>
						<input type="radio" class="form-text" name="classification" value="50"/>
						<input type="radio" class="form-text" name="classification" value="60"/>
						<input type="radio" class="form-text" name="classification" value="90"/>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">명칭</label>
						<input type="text" class="form-text" name="appellation" placeholder="직접입력"/>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">건물명</label>
						<input type="text" class="form-text" name="buildingName" placeholder="직접입력"/>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">평형</label>
						<input type="text" class="form-text" name="areaSize" placeholder="직접입력"/>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">층수</label>
						<input type="text" class="form-text" name="floor" placeholder="직접입력"/>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">현황판 노출순서</label>
						<select class="form-select" name="exposure">
							<option value="1">1</option><option value="2">2</option><option value="3">3</option>
							<option value="4">4</option><option value="5">5</option><option value="6">6</option>
							<option value="7">7</option><option value="8">8</option><option value="9">9</option>
							<option value="10">10</option>
							<option value="11">11</option><option value="12">12</option><option value="13">13</option>
							<option value="14">14</option><option value="15">15</option><option value="16">16</option>
							<option value="17">17</option><option value="18">18</option><option value="19">19</option>
							<option value="20">20</option>
						</select>
					</div>
				</div>
				
				<div class="form-box-st-01 half">
					<div class="row-box">
						<div class="btn-box">
							<input type="hidden" name="rasCnt"/> 
							<button type="button" class="row-button add">추가</button>
							<button type="button" class="row-button upd">수정완료</button>
							<button type="button" class="row-button del">삭제</button>
						</div>
					</div>
				</div>
			</div>
			
			<table class="popup-table list">
				<colgroup>
					<col width="15%"/>
					<col width="*"/>
					<col width="15%"/>
					<col width="15%"/>
					<col width="15%"/>
					<col width="15%"/>
				</colgroup>
				<thead>
					<tr>
						<th>분류</th>
						<th>명칭</th>
						<th>노출순서</th>
						<th>건물명</th>
						<th>층수</th>
						<th>평형</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</form>



<div class="contents-title-wrap">
	<div class="title"></div>
	<div class="title-right-wrap"><button type="button" class="title-button" id="btnRegister">신규등록</button></div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">장례식장 목록</div>
	</div>
	<div class="search-right-wrap">
		<input type="text" class="search-text rb" placeholder="키워드 검색"/>
		<button type="button" class="search-text-button">검색</button>
	</div>
</div>
<div class="contents-body-wrap">
	<table class="pb-table list">
		<colgroup>
		</colgroup>
		<thead></thead>
		<tbody></tbody>
	</table>
	<div class="paging"></div>
</div>
