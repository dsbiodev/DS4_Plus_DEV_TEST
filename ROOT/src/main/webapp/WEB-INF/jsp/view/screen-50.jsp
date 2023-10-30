<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<link href="https://fonts.googleapis.com/css?family=Nanum+Gothic:400,700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Noto+Serif+KR:300,400,500&display=swap" rel="stylesheet">

<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$('form').attr('onsubmit', 'return false');
		
		var searchObj = $.extend({}, _param);
		searchObj.funeralNo = '${sessionScope.loginProcess.FUNERAL_NO}';
		searchObj.classifications = '50';
		searchObj.order = 'CLASSIFICATION ASC, APPELLATION ASC';
		
		var _layer03 = $('.pb-right-popup-wrap[data-classification="50"]');
		
		for(var i=5; i<=10; i++) {
			_layer03.find('select[name=slideSec]').append('<option value="'+i+'">'+i+'초</option>');
		}
		
		_layer03.find('input[name=screenType]').pbRadiobox({ addText:['미사용', '사진 슬라이드', '동영상'] });
		_layer03.find('input[name=screenMode]').siteRadio({ addText:['가로', '세로'], defaultValue:1 });
		_layer03.find('.pb-radio-label').css('margin-top', '10px');
		
		_layer03.find('input[name=screenType]').on('change', function() {
			var _ = $(this);
			if(_.val() == 1) {
				_layer03.find('.pb-popup-form').not(':first').hide().siblings('.slide').show();
			} else if(_.val() == 2) {
				_layer03.find('.pb-popup-form').not(':first').hide().siblings('.video').show();
			} else _layer03.find('.pb-popup-form').not(':first').hide();
		});
		
		var fileList = [], notDeletePriority = [];
		$.each(_layer03.find('.form-images-wrap > .image-item'), function(idx) {
			var _thisWrap = $(this);
			_thisWrap.attr('data-priority', idx);
			_thisWrap.append('<div class="image-text">'+(idx+1)+'번 사진파일</div>');
			_thisWrap.append('<div class="delete-hover"><div class="delete-hover-text">삭제하기</div></div>');
			_thisWrap.hover(function() {
				if($(this).hasClass('ac')) $(this).find('.delete-hover').show();
			}, function() {
				if($(this).hasClass('ac')) $(this).find('.delete-hover').hide();
			});
			
			_thisWrap.on('click', function() {
				
				_layer03.find('.form-images-wrap > .image-item').removeClass('run');
				if($(this).hasClass('ac')) {
					$(this).find('.image-text').show();
					$(this).find('.delete-hover').hide();
					fileList[_thisWrap.data('priority')] = null;
					$(this).css('background-image', '').removeClass('ac');
					$.each(notDeletePriority, function(idx, _value) {
						if(_thisWrap.data('priority') == _value) notDeletePriority.splice(idx, 1);
					});
				} else $(this).addClass('run').siblings('#slideFileSelector').trigger('click');
			});
			
			fileList.push(null);
		});
		
		$('#btnVideoFile').on('click', function() { $(this).siblings('#videoFile').trigger('click'); });
		_layer03.find('input[type=file]').on('change', function() {
			var _ = $(this);
			var _regex = (_.attr('id') == 'slideFileSelector' ? /(\.png|\.jpg|\.jpeg|\.gif)$/i:/(\.mp4|\.avi|\.mkv|\.wmv)$/i)
			if(_.val()) {
				var _fileName = _[0].files[0].name;
				if(_regex.test(_fileName) == false) { 
					alert("파일 형식이 올바르지 않습니다");
					$(this).val('');
				} else {
					$.each(_[0].files, function(idx) {
						var _thisFile = this;
						var reader = new FileReader();
						reader.onload = function(rst) {
							if(_.attr('id') == 'slideFileSelector') {
								var _target = _.siblings('.image-item.run');
								_target.css('background-image', 'url(\''+rst.target.result+'\')').addClass('ac');
								_target.find('.image-text').hide();
								
								fileList[_target.data('priority')] = _[0].files[0];
							} else if(_.attr('id') == 'videoFile') {
								_.siblings('.form-text').val(_fileName);
							}
						};
						reader.readAsDataURL(_thisFile);
					});
				}
			}
		});
		
		$('#btnVideoFile2').on('click', function() { $(this).siblings('#videoFile2').trigger('click'); });
		_layer03.find('input[type=file]').on('change', function() {
			var _ = $(this);
			var _regex = (_.attr('id') == 'slideFileSelector' ? /(\.png|\.jpg|\.jpeg|\.gif)$/i:/(\.mp4|\.avi|\.mkv|\.wmv)$/i)
			if(_.val()) {
				var _fileName = _[0].files[0].name;
				if(_regex.test(_fileName) == false) { 
					alert("파일 형식이 올바르지 않습니다");
					$(this).val('');
				} else {
					$.each(_[0].files, function(idx) {
						var _thisFile = this;
						var reader = new FileReader();
						reader.onload = function(rst) {
							if(_.attr('id') == 'slideFileSelector') {
								var _target = _.siblings('.image-item.run');
								_target.css('background-image', 'url(\''+rst.target.result+'\')').addClass('ac');
								_target.find('.image-text').hide();
								
								fileList[_target.data('priority')] = _[0].files[0];
							} else if(_.attr('id') == 'videoFile2') {
								_.siblings('.form-text').val(_fileName);
							}
						};
						reader.readAsDataURL(_thisFile);
					});
				}
			}
		});
		
		var createTable = function(_searchObj) {
			$.pb.ajaxCallHandler('/admin/selectRaspberryConnectionList.do', _searchObj, function(tableData) {
				$('.contents-body-wrap').html('');
				$.each(tableData.list, function(idx) {
					var _tr = $('<div class="screen-item">');
					var _screenWrap = $('.contents-body-wrap > .screen-wrap[data-classification=50]');
					_tr.data(this).html(this.APPELLATION);
					_tr.on('click', function() {
						
						$('.pb-right-popup-wrap').openLayerPopup({}, function(_thisLayer) {
							_thisLayer.find('.top-button.register').data(_tr.data()).val(_tr.data('STATUS_PLATE_NO'));
							_layer03.find('.form-images-wrap > .image-item').removeClass('ac').css('background-image', '').find('.image-text').show();
							_layer03.find('.form-video-wrap .video-box').html('');

							fileList = [], notDeletePriority = [];
							layerInit(_thisLayer, _tr.data());
							if(_tr.data('STATUS_PLATE_NO')) {
								$.pb.ajaxCallHandler('/admin/selectStatusPlateFiles.do', { statusPlateNo:_tr.data('STATUS_PLATE_NO') }, function(fileData) {
									$.each(fileData, function(idx) {
										if(_tr.data('SCREEN_TYPE') == 1) {
											var _target = $('.form-images-wrap > .image-item[data-priority="'+this.PRIORITY+'"]');
											_target.css('background-image', 'url("'+this.FILE+'")').addClass('ac');
											_target.find('.image-text').hide();
											
											notDeletePriority.push(this.PRIORITY);
										} else if(_tr.data('SCREEN_TYPE') == 2) {
											$('#videoFile, #videoFile2').val('').siblings('.form-text').val('');
											$('.form-video-wrap > .video-box:eq('+idx+')').html('<video style="width:100%; height:300px;" controls><source src="'+this.FILE+'"/></video><div>'+(idx == 0 ? "HD" : "Full HD")+'번 영상</div>');
										}
									});
								});
							}
							
							_layer03.find('input[name=screenMode]').attr('disabled', false).parents('.row-box').show();
						});
					});
					
					if(!_screenWrap.length) {
						_screenWrap = $('<div class="screen-wrap" data-classification="'+this.CLASSIFICATION+'">');
						_screenWrap.append('<div class="screen-item-wrap"></div>');
						$('.contents-body-wrap').append(_screenWrap);
					}
					
					if(_screenWrap.find('.screen-item').length%5 == 0) _tr.css('margin-left', 0);
					_screenWrap.find('.screen-item-wrap').append(_tr);
				});
			});
		};
		createTable(searchObj);
		
		//저장버튼
		$('.pb-right-popup-wrap .top-button.register').on('click', function() {
			var _btnValue = $(this).val();
			var _data = $(this).data();

			if(!necessaryChecked($('#dataForm50'))) {
				var _uploadUrl = _btnValue ? '/admin/updateRaspberryStatusPlate.do':'/admin/insertRaspberryStatusPlate.do';
				var _formData = new FormData($('#dataForm50')[0]);
				_formData.append('actionUserNo', '${sessionScope.loginProcess.USER_NO}');
				_formData.append('funeralNo', '${sessionScope.loginProcess.FUNERAL_NO}');
				_formData.append('classification', _data.CLASSIFICATION);
				
				if(_data.RASPBERRY_CONNECTION_NO) _formData.append('raspberryConnectionNo', _data.RASPBERRY_CONNECTION_NO);
				_formData.append('statusPlateNo', _btnValue ? _btnValue:'');

				var _screenType = $('input[name=screenType]:checked').val();
				if(_screenType == 1) {
					$.each(fileList, function(idx, _value) { if(_value) _formData.append(idx, _value); });
					if(notDeletePriority.length) _formData.append('notDeletePriority', notDeletePriority);
				} else if(_screenType == 2) {
					if($('#videoFile')[0].files.length) _formData.append(0, $('#videoFile')[0].files[0]);
					if($('#videoFile2')[0].files.length) _formData.append(1, $('#videoFile2')[0].files[0]);
				}
				_formData.append('fcmClassification', _data.CLASSIFICATION);
				$.pb.ajaxUploadForm(_uploadUrl, _formData, function(result) {
					if(result != 0) {
						createTable(searchObj);
						closeLayerPopup();
					} else alert('저장 실패 관리자에게 문의하세요');
				}, '${sessionScope.loginProcess}');
			}
		});
		//모바일/PC 스크립트 인식 구분
		var filter = "win16|win32|win64|mac|macintel";
		if (filter.indexOf(navigator.platform.toLowerCase()) < 0) {
		//MOBILE
				
			document.getElementById("pb-popup-body").style.width="100%";
			document.getElementById("pb-popup-body").style.overflow="scroll";
			document.getElementById("btnSave").style.width="90px";
			document.getElementById("btnCancel").style.width="90px";

			$('.site-radio-label').css( 'width' , '70px');
			$('.pb-radio-label').css( 'text-align' , 'center');
			$('.pb-radio-label').css( 'text-align' , 'center');
			
			$('.image-text').css( 'display' , 'none');

			
		}

		$('.pb-popup-close, .popup-mask').on('click', function() { closeLayerPopup(); });
	});
</script>
<style>
	.top-button-wrap.half-text { width:50%; height:100%; box-sizing:border-box; padding:24px 0; color:#707070; font-size:20px; font-weight:500; letter-spacing:1px; }
	.pb-table.list > tbody > tr:hover { background:none; cursor:default; }
	.screen-wrap > .screen-item-wrap > .screen-item { min-width:300px; }
	@media ( max-width: 500px ) {
		.screen-wrap > .screen-item-wrap { text-align:center; }
		.pb-right-popup-wrap { width:100%; overflow:scroll;}
		.pb-popup-form > .form-box-st-01 > .row-box > .form-select { width:140px; }
		.pb-popup-form .form-images-wrap > .image-item { height:100px; width:calc(100%/2 - 25px); }
		.pb-popup-form > .form-box-st-01 > .row-box > label.title { width:110px; }
		.pb-radio-label { width:120px;float:left; }
		.pb-popup-form .form-images-wrap > .image-item > .image-text {display:none;}
		
	}
</style>
<form id="dataForm50">
	<div class="pb-right-popup-wrap" data-classification="50">
		<div class="pb-popup-title">특수화면 편집</div>
		<span class="pb-popup-close"></span>
		<div class="pb-popup-body" style="width:960px; overflow:hidden;" id="pb-popup-body">
			<div class="popup-body-top">
				<div class="top-title">특수화면 미리보기</div>
				<div class="top-button-wrap">
					<button type="button" class="top-button register" id="btnSave">저장</button>
					<button type="button" class="top-button pb-popup-close" id="btnCancel">취소</button>
				</div>
			</div>
			<div class="pb-popup-form">
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title" id="tmpTitle" style="width:30px;"></label>
						<input type="radio" name="screenType" value="0"/>
						<input type="radio" name="screenType" value="1"/>
						<input type="radio" name="screenType" value="2"/>
					</div>
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">화면모드</label>
						<input type="radio" name="screenMode" value="1"/>
						<input type="radio" name="screenMode" value="2"/>
					</div>
				</div>
			</div>
			<div class="pb-popup-form slide" style="display:none; border-top:none;">
				<div class="form-box-st-01 half">
				</div>
				<div class="form-box-st-01 half">
					<div class="row-box">
						<label class="title">화면간격</label>
						<select class="form-select" name="slideSec"></select>
					</div>
				</div>
				<div class="form-images-wrap">
					<input type="file" id="slideFileSelector"/>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
					<div class="image-item"></div>
				</div>
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title full" style="text-align:center;">- 사진은 최대 12장까지 등록가능합니다 -</label>
					</div>
				</div> 
			</div>
			<div class="pb-popup-form video" style="display:none; border-top:none;">
				<div class="form-box-st-01">
					<div class="row-box" style="padding-top:20px; margin-top:0;">
						<label class="title">동영상파일 HD</label>
						<input type="file" id="videoFile"/>
						<input type="text" class="form-text" style="width:calc(100% - 256px);" readonly="readonly"/>
						<button type="button" class="text-button" id="btnVideoFile">파일찾기</button>
					</div>
					<div class="row-box" style="padding-top:20px; margin-top:0;">
						<label class="title" style="font-size:13px;">동영상파일 Full HD</label>
						<input type="file" id="videoFile2"/>
						<input type="text" class="form-text" style="width:calc(100% - 256px);" readonly="readonly"/>
						<button type="button" class="text-button" id="btnVideoFile2">파일찾기</button>
					</div>
				</div>
				<div class="form-box-st-01">
					<div class="row-box">
						<label class="title full" style="text-align:center;">- 동영상 파일 크기는 100MB(메가)를 초과할 수 없습니다 -</label>
					</div>
				</div>
				<div class="form-video-wrap">
					<div class="video-box"></div>
					<div class="video-box"></div>
				</div>
			</div>
		</div>
	</div>
</form>

<div class="contents-title-wrap">
	<div class="title">특수화면 관리</div>
	<div class="sub-title">화면을 관리할 수 있습니다.</div>
</div>
<div class="contents-body-wrap"></div>