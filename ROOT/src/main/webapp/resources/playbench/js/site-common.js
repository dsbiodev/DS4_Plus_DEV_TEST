/**
 * File : site-common.js
 * Explanation : 사이트 공통 javascript
 */

var _mainTopWrap = $('.main-top-wrap');

$.expr[':'].icontains = function(a, i, m) {
	return $(a).text().toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
};

$(document).on('change', '.necessary', function(){ 
//	if(!$(this).hasClass('excepted') && $(this).val()) $(this).siblings('.pb-warning').hide(); 
	if(!$(this).hasClass('excepted') && $(this).val()) $(this).removeClass('necessary-ac');
});
$(document).off().on('click', '.popup-mask, .pb-popup-close', function() { closeLayerPopup(); });

// 사이트 레이어 밖 클릭 시 레이어 닫기
//$(document).mouseup(function(e) {
//	var container = $('.pb-top-layer, .layer-sticky');
//	if(container.has(e.target).length == 0) container.hide();
//});


// 레이어 팝업 열기
//$.fn.openLayerPopup = function(_param, _done) {
//	var _opt = { 
//		slide:true
//	};
//	
//	$.extend(_opt, _param);
//	
//	var _ = $(this);
//	var _halfWidth = _.width()/2;
//	var _halfHeight = _.height()/2;
//	var _scrollY = $(window)[0].scrollY ? $(window)[0].scrollY:document.body.parentNode.scrollTop;
//	_.css('top', 'calc(50vh - '+_halfHeight+'px '+(_.height() < 400 ? '- 60px + ':'+ ')+_scrollY+'px)').css('left', 'calc(50vw - '+_halfWidth+'px)');
//	
//	if(_.find('.pb-warning').length) _.find('.pb-warning').hide();
//	if(!$('.popup-mask').length) $('body').append('<div class="popup-mask"></div>');
//	if($('.pb-top-layer:visible').length) $('.pb-top-layer:visible').hide();
//	
//	$('.popup-mask').show();
//	if(_opt.slide) _.hide().slideDown(300);
//	else _.show();
//	
////	console.log('Width(window, _this) : ', $(window).width(), _.width());
////	console.log('Height(window, _this) : ', $(window).height(), _.height());
//	
//	if(_done) _done(_);
//};


$.fn.openLayerPopup = function(_param, _done) {
	var _ = $(this);
	if(_done) _done(_);
	
	$('.popup-mask').show();
	_.css('display', 'block');
	if($(this).attr('class').indexOf('right') != -1){
		_.animate({right:0, opacity:1}, { duration:400, complete:function() { 
				if(_.hasClass('full-size')) _.css('left', 0);
			}
		});
	}else{
		_.animate({opacity:1}, { duration:400, complete:function() { }
		});
	}

};

//popup-mask 없음
$.fn.openLayerPopup2 = function(_param, _done) {
	var _ = $(this);
	if(_done) _done(_);

	_.css('display', 'block');


};

// 레이어 팝업창 닫기
function closeLayerPopup() {
	$('.popup-mask').hide();
	$('.popup-notice').hide();
	$('.pb-right-popup-wrap').css('opacity', '').css('right', '').css('left', '').css('display', '');
	$('.pb-open-popup-wrap').css('opacity', '').css('right', '').css('left', '').css('display', '');
}

$.fn.siteRadio = function(_option, _callBack) {
	var _ = this;
	
	var _default = {
			width:'',
			color:'',					// color : null, blue, red
			addText:'',					// type String, Array
			fontSize:'',				// default : 12px, typeof number or string
			matchParent:'',				// default : false
			defaultValue:''				// default : null
	};
	
	$.extend(_default, _option);
	$.each(_, function(idx) {
		var $_ = $(this);
		var _label = $('<label>');
		var _len = _.filter('input[name='+$_.attr('name')+']').length;
		
		_label.addClass('site-radio-label').addClass(_default.color)
		.addClass($_.index('input[name='+$_.attr('name')+']') == 0 ? 'first':($_.index('input[name='+$_.attr('name')+']') == (_len - 1) ? 'last':''));
		
		if(_default.width) _label.css('width', _default.width);
		if(_default.fontSize) _label.css('font-size', (typeof _default.fontSize == 'number' ? _default.fontSize+'px':_default.fontSize));
		if(_default.matchParent) {
			_label.css('width', 'calc('+(100/_len)+'% + 1px)').css('text-align', 'center');
		}
		
		if($_.val() == _default.defaultValue) {
			$_.prop('checked', true);
			_label.addClass('ac');
		}
		
		_label.append($_.clone().css('display', 'none')).append(_default.addText[idx]);
		_label.on('click', function() {
			$(this).addClass('ac').siblings('.site-radio-label').removeClass('ac');
		});
		
		$_.after(_label);
		$_.remove();
	});
};

$.fn.crtMenuTree = function(_menuData) {
	var _this = $(this);
	
	$.each(_menuData, function(idx, _value) {
		var _item = $('<div class="item">');
		_item.addClass(this.STEP == 1 ? 'parents step-01':'child step-02');
		_item.data(this).attr('data-menu-no', this.MENU_NO).attr('data-parents', (this.STEP == 1 ? '':_this.find('.item.parents').last().data('MENU_NO')));
		
		if(this.STEP == 1) _item.append('<span class="folder fold"></span>');
		_item.append('<span class="check-box"></span>');
		_item.append('<span class="text">'+this.KO+'</span>');

		_this.append(_item);
	});
	
	_this.find('.folder').on('click', function() {
		var _ = $(this);
		
		if(_.hasClass('fold')) {
			_.removeClass('fold').addClass('unfold');
			_.parent('.item').nextAll('.item.child[data-parents="'+_.parent('.item.parents').data('MENU_NO')+'"]').slideUp(300);
		} else if(_.hasClass('unfold')) {
			_.removeClass('unfold').addClass('fold');
			_.parent('.item').nextAll('.item.child[data-parents="'+_.parent('.item.parents').data('MENU_NO')+'"]').slideDown(300);
		}
	});
	
	_this.find('.check-box').on('click', function() {
		var _ = $(this);
		var _item = _.parent('.item');
		var _child = _item.hasClass('parents') ? _this.find('.item.child[data-parents="'+_item.data('MENU_NO')+'"]').not('.calculate'):_this.find('.item.child[data-parents="'+_item.data('parents')+'"]').not('.calculate');
		var _parents = _item.hasClass('child') ? _this.find('.item.parents[data-menu-no="'+_item.data('parents')+'"]'):null;
		
		if(_.hasClass('checked')) {
			_.removeClass('checked');
			if(_item.hasClass('parents')) _child.find('.check-box').removeClass('checked');
			else {
				if(_child.find('.check-box.checked').length) _parents.find('.check-box').removeClass('checked').addClass('half');
				else _parents.find('.check-box').removeClass('half checked');
			}
		} else {
			_.removeClass('half').addClass('checked');
			
			if(_item.hasClass('parents')) {
//					폴더 닫혔을때 체크 시 자식들 자동으로 펼쳐지게
//					_item.find('.folder').removeClass('unfold').addClass('fold');
//					_child.slideDown(300);
				_child.find('.check-box').addClass('checked');
			} else {
				if(_child.length == _child.find('.check-box.checked').length) _parents.find('.check-box').removeClass('half').addClass('checked');
				else _parents.find('.check-box').addClass('half');
			}
		}
	});
};


$.fn.crtPbWrapper = function(_option) {
	var _ = $(this);
	
	var _default = {
		textWidth:'',
		textHint:'입력하세요',
		textReg:'',
		textFormat:'',				// number, phone
	};
	
	$.extend(_default, _option);
	
	$.each(_, function() {
		var _thisWrap = $(this);
		_thisWrap.addClass('pb-auto-wrapper');
		_thisWrap.on('click', function(e) {
			if($(e.target).hasClass('pb-auto-wrapper')) _thisWrap.find('.wrapper-text').focus();
		});
		
		var _wrapperText = $('<input type=search>');
		_wrapperText.css('width', (_default.textWidth ? _default.textWidth+'px':'')).addClass('wrapper-text').attr('placeholder', _default.textHint).attr('maxlength', _default.textFormat == 'phone' ? 11:'50');
		_wrapperText.on('keydown', function(e) {
			var _this = $(this);
			var _textValue = $(this).val();
			
			if(_textValue && e.keyCode == 13) {
				var _label = $('<label>');
				_label.data('value', _textValue).addClass('wrapper-item');
				_textValue = _default.textFormat == 'phone' ? $.pb.phoneFomatter(_textValue):_textValue;
				_label.html('<span class="text">'+_textValue+'</span><img src="/resources/playbench/images/wrapper_item_close.svg" class="close"/>');
				_label.find('img.close').off().on('click', function() {
					var _tmpParents = $(this).parents('.pb-auto-wrapper');
					$(this).parent('label.wrapper-item').remove(); 
					
					if(!_thisWrap.find('label.wrapper-item').length) 
						_wrapperText.css('width', (_default.textWidth ? _default.textWidth+'px':'')).attr('placeholder', _default.textHint);
					
					//미리보기 변경
					createTxt(createMap($('.family-wrap')));
				});
				
				_this.attr('placeholder', '').css('width', (_default.textWidth ? _default.textWidth+'px':'')).addClass('wrapper-text').attr('placeholder', _default.textHint).attr('maxlength', _default.textFormat == 'phone' ? 11:'50');
				_this.val('');
				_this.before(_label);
				
				_thisWrap.scrollLeft(_[0].scrollWidth);
			}else if(!_textValue && e.keyCode == 37) {
				_this.prev().before(_this);
				_this.focus();
			}else if(!_textValue && e.keyCode == 39) {
				_this.next().after(_this);
				_this.focus();
			}else if(!_textValue && e.keyCode == 8) {
				_this.prev().remove();
			};
			
			if(_default.textFormat == 'number' || _default.textFormat == 'phone') $(this).val($(this).val().replace(/[^0-9]/g, ''));
		});
		
		_thisWrap.html(_wrapperText);
	});
	
};

$.pb.busNoFomatter = function(_value) {
	var formatNum = '';
	var num = _value.replace(/-/gi, '');
	if(num) {
		if(num.length==3) formatNum = num.replace(/(\d{3})(\d{0})/, '$1');
		else if(num.length==4) formatNum = num.replace(/(\d{3})(\d{1})/, '$1-$2');
		else if(num.length==5) formatNum = num.replace(/(\d{3})(\d{2})/, '$1-$2');
		else if(num.length==6) formatNum = num.replace(/(\d{3})(\d{2})(\d{1})/, '$1-$2-$3');
		else if(num.length==7) formatNum = num.replace(/(\d{3})(\d{2})(\d{2})/, '$1-$2-$3');
		else if(num.length==8) formatNum = num.replace(/(\d{3})(\d{2})(\d{3})/, '$1-$2-$3');
		else if(num.length==9) formatNum = num.replace(/(\d{3})(\d{2})(\d{4})/, '$1-$2-$3');
		else if(num.length==10) formatNum = num.replace(/(\d{3})(\d{2})(\d{5})/, '$1-$2-$3');
		else formatNum = num;
		
		return formatNum;
	} else return _value;
};

$.fn.busNoFomatter = function(_default){
//	$(this).attr('placeholder', '사업자 등록번호를 입력해주세요.');
	$(this).on('focus', function() { $(this).val(''); });
	$(this).on('keyup', function(e) {
		if($(this).val().length > 12) $(this).val($(this).val().slice(0, 12));
		else $(this).val($.pb.busNoFomatter($(this).val().replace(/[^0-9]/g, '')));
	});
	if(_default) $(this).val($.pb.busNoFomatter(_default));
};

// thead 초기화 및 차순검색
function theadInit(theadObj, callback) {
	var _targetTable = theadObj.table;
	var _theadTr = $('<tr>');
	var _theadTrSec = $('<tr>');
	
	$.each(theadObj.colGroup, function(idx, _value) {
		_targetTable.find('colgroup').append('<col width="'+(typeof(_value) === 'number' ? _value+'%':_value)+'"/>');
	});
	
	$.each(theadObj.theadRow, function(idx, _value) {
		var _th = $('<th>');
//		console.log('_value', _value, typeof(_value[0]), typeof _value[0]);
		
		if(typeof(_value[0]) == 'string') {
			_th.data('column', _value[0]).attr('colspan', (_value[2] ? _value[2]:''));
			_th.html(_value[1]);
			_theadTr.append(_th);
		} else {
			$.each(_value, function(jdx, _valueSec) {
				var _thSec = $('<th>');
				_thSec.data('column', _valueSec[0]).attr('colspan', (_valueSec[2] ? _valueSec[2]:''));
				_thSec.html(_valueSec[1]);
				_theadTr.append(_thSec);
			});
		}
		
		if(theadObj.theadRowSec && theadObj.theadRowSec[idx]) {
			var _thisSec = theadObj.theadRowSec[idx];
			if(_thisSec[0] || _thisSec[1]) {
				if(typeof(_thisSec[0]) == 'string') {
					var _thSec = $('<th>');
					_thSec.data('column', _thisSec[0]).attr('colspan', (_thisSec[2] ? _thisSec[2]:''));
					_thSec.html(_thisSec[1]);
					_theadTrSec.append(_thSec);
				} else {
					$.each(_thisSec, function(jdx, _valueSec) {
						var _thSec = $('<th>');
						_thSec.data('column', _valueSec[0]);
						
						_thSec.html(_valueSec[1]);
						_theadTrSec.append(_thSec);
					});
				}
			} else _th.attr('rowspan', 2);
		}
		
		
	});
	
	_targetTable.find('thead').html(_theadTr).append(_theadTrSec.length ? _theadTrSec:'');
	_targetTable.find('thead > tr > th').on('click', function() {
		var _column = $(this).data('column');
		if(_column) {
			var _order = $(this)[0].className && $(this).hasClass('ASC') ? 'DESC':'ASC';
			$(this).attr('class', _order).siblings('th').attr('class', '');
			if(callback) callback(_column+' '+_order);
		}
	});
};

// Form 초기화
var layerInit = function(_, _data) {
	var _setting = $.extend({}, _data);
	
	if(_.length) {
		$.each(Object.keys(_setting), function(idx, _value) {
			if(!/[a-z][^_]*/g.test(_value)) {
				var valueSplit = _value.toLowerCase().split('_');
				
				if(valueSplit.length > 1) {
					var newKey = '';
					$.each(valueSplit, function(idx, _splitVal) {
						if(idx > 0) {
							newKey += _splitVal.replace(_splitVal.slice(0,1), _splitVal.slice(0,1).toUpperCase());
						} else newKey += _splitVal;
					});
					
					_setting[newKey] = _setting[_value];
				} else _setting[_value.toLowerCase()] = _setting[_value];
				
				delete _setting[_value];
			}
		});
		
		$.each(_.find('[name]'), function(idx) {
//			console.log($(this)[0].localName, $(this)[0].type, $(this)[0].name);
			if($(this).hasClass('excepted')) {	// 예외
				
			} else if($(this)[0].localName == 'input') {
				if($(this)[0].type == 'text' || $(this)[0].type == 'password' || $(this)[0].type == 'hidden') {
					if($(this).hasClass('tel')) $(this).val($.pb.phoneFomatter(_setting[$(this)[0].name]));
					else {
//						console.log($(this)[0].name, _setting[$(this)[0].name]);
						$(this).val(_setting[$(this)[0].name]);
					}
				} else if($(this)[0].type == 'radio') {
					_.find('input[name="'+$(this)[0].name+'"]'+(typeof _setting[$(this)[0].name] == 'undefined' ? ':eq(0)':'[value="'+_setting[$(this)[0].name]+'"]')).trigger('click');
				} else if($(this)[0].type == 'checkbox') {
					if($(this).is(':checked')) {
						if(_setting[$(this)[0].name] != 1) $(this).parent('.pb-checkbox-label').click(); 
					} else {
						if(_setting[$(this)[0].name] == 1) $(this).parent('.pb-checkbox-label').click(); 
					}
				} else if($(this)[0].type == 'file') {
					$(this).val('');
				}
			} else if($(this)[0].localName == 'select') {
				$(this).find('option'+(_setting[$(this)[0].name] ? '[value="'+_setting[$(this)[0].name]+'"]':':eq(0)')).prop('selected', true).trigger('change');
			} else if($(this)[0].localName == 'textarea') {
				if($(this).hasClass('summernote')) $(this).summernote('code', _setting[$(this)[0].name]);
				else $(this).val(_setting[$(this)[0].name]);
			}
		});
		
		_.find('.pb-warning').hide();
		_.find('.necessary-ac').removeClass('necessary-ac');
	} else console.log('No Targets');
};

function necessaryChecked(_form) {
	var errCount = 0;
	$.each(_form.find('[name]'), function() {
		if($(this).hasClass('necessary') && !$(this).val()) {
			// 1.0v
//			if(!$(this).siblings('.pb-warning').length) $(this).parent().append('<div class="pb-warning">필수정보입니다.</div>');
//			$(this).siblings('.pb-warning').show();
			
			// 2.0v
			$(this).addClass('necessary-ac');
		}else{
			$(this).removeClass('necessary-ac');
		}
	});
	
//	errCount += _form.find('[name]').siblings('.pb-warning:visible').length;
	errCount += _form.find('[name].necessary-ac').length;
	return errCount;
}

function openFullScreenMode() {
	var docV = document.documentElement;
	if(docV.requestFullscreen) docV.requestFullscreen();
	else if(docV.webkitRequestFullscreen) docV.webkitRequestFullscreen();
	else if(docV.msRequestFullscreen) docV.msRequestFullscreen();
}

function closeFullScreenMode() {
	if(document.exitFullscreen) document.exitFullscreen();
	else if(document.webkitExitFullscreen) document.webkitExitFullscreen();
	else if(document.msExitFullscreen) document.msExitFullscreen();
}

$(window).on('keyup', function(e) {
	// 커뮤니티 뷰어 보일 시 화살표 오른쪽 왼쪽 컨트롤
	if($('.community-viewer-wrap').is(':visible') && (e.keyCode == 37 || e.keyCode == 39)) 
		$('.community-viewer-wrap').find('.overlay '+(e.keyCode == 37 ? '.prev':'.next')).trigger('click');
});

$(window).on('popstate', function(event) {
	var _state = event.originalEvent.state;

	console.log('[ Site-Common.js ] path', $(location)[0].pathname);
	console.log('[ Site-Common.js ] state', _state);
	console.log('[ Site-Common.js ] history', history);
	if(_state) {
		if(_state.link) {
			var _linkSplit = _state.link.split('/');
//			_state.page = 6 < _linkSplit[1].length ? '/manager/29010100' :_state.page;
			_state.page = 6 < _linkSplit[1].length ? '/manager/'+_linkSplit[1].substring(0,6)+'00' :_state.page;
			$('.popup-mask').hide();
			$('.main-contents-wrap').pageConnectionHandler(_state.page, { pk:_linkSplit[2] ? _linkSplit[2] : '' }, function() {});
		} else if(_state.paging) {
			$('.popup-mask').hide();
			$('.main-contents-wrap').pageConnectionHandler(_state.page, _state.paging, function() {
			});
		} else if(_state.pageDetail) {
//			$('.main-contents-wrap').pageConnectionHandler(_state.pageDetail, _state.pageDetail, function() {
//			});
		}
	}
//	else $(location).attr('href', '/');
});

$(window).on('resize', function() {
	
});