/**
 * File : plabench.js
 * Explanation : 공통 javascript
 */
// IE9 이상, 크롬, 안드로이드 4.0 이상
(function(factory) {
	if ( typeof define === 'function' && define.amd ) {
		define([ 'jquery' ], factory );
	} else {
		// Browser global
		factory( jQuery );
	}
}(function($) {
	// if(window.location.protocol != 'https:') window.location.href = 'https:' + window.location.href.substring(window.location.protocol.length);
	// var host = location.host.toLowerCase();
	// var currentAddress = location.href;
	// if(host.indexOf('www')== -1) { currentAddress = currentAddress.replace('//','//www.'); location.href = currentAddress; };

	$.pb = $.pb || {};
	var version = $.pb.version = '1.0.0';
	var pbImagePath = '/resources/playbench/images';

	$(document).ajaxSend(function(event, xhr, ajaxOption) {
		$('.ajax-loading').show();
	});

	$(document).ajaxStart(function(data) {
		
	});

	$(document).ajaxStop(function(data) {
		$('.ajax-loading').hide();
	});
	
	$.fn.pbCheckbox = function(_option, _callBack) {
		var _ = this;
		var _default = {
				color:'default',					// color : default, blue, red
				addText:new Array(),				// type String, Array
				margin:'',							// default : 0 6px 0 4px
				fontSize:'',						// default : 14px
				fontColor:'',						// default : #333333
				textAlign:'',						// default : -5px
				cursor:'',							// default : default
				allCheckedElement:'',
		};

		_callBack = _callBack ? _callBack:{ checked:function(){}, unChecked:function(){}, done:function(){} };

		var _callBackObj;
		if(typeof _callBack === 'function') {		// _callBack is done.
			_callBackObj = { checked:function(){}, unChecked:function(){}, done:_callBack };
		} else {
			_callBackObj = {
					checked:typeof _callBack.checked === 'function' ? _callBack.checked:function(){},
					unChecked:typeof _callBack.unChecked === 'function' ? _callBack.unChecked:function(){},
					done:typeof _callBack.done === 'function' ? _callBack.done:function(){},
			};
		}

		if(_option) {
			if(typeof _option.addText == 'string') _option.addText = new Array(_option.addText);
			$.extend(_default, _option);
		}
		
		var newCheckbox = [];
		$.each(_, function(idx) {
			var $_ = $(this);
			var _label = $('<label>');
			_label.addClass('pb-checkbox-label');
			if($_.attr('id')) _label.attr('for', $_.attr('id'));
			if(_default.cursor) _label.css('cursor', _default.cursor);

			var imgOnOff = '/check_off.png';
			
			if($_.attr('disabled')) imgOnOff = '/check_disabled.png';
			else if($_.attr('checked')) imgOnOff = '/check_on_'+_default.color+'.png';
			_label.append($_.clone())
			.append('<img src="'+pbImagePath+imgOnOff+'">').find('img').addClass('pb-checkbox-box');
			if(_default.addText[idx]) {
				_label.find('img').after('<span>').siblings('span').addClass('pb-checkbox-text')
				.css('margin', _default.margin)
				.css('color', _default.fontColor)
				.css('font-size', _default.fontSize)
				.html(_default.addText[idx]);
			} else {
				_label.attr('style', 'margin-right:0').find('img.pb-checkbox-box').attr('style', 'margin-right:0');
			}

			_label.on('change', function(event) {
				var _thisBox = $(this).find('input[type=checkbox]');
				
				if(_thisBox.is(':checked')) {
					_thisBox.siblings('img').attr('src', pbImagePath+'/check_on_'+_default.color+'.png');
					_callBackObj.checked(_thisBox, event);
				} else {
					_thisBox.siblings('img').attr('src', pbImagePath+'/check_off.png');
					_callBackObj.unChecked(_thisBox, event);
				}

				_callBackObj.done(_thisBox, event);
			});

			newCheckbox.push(_label[0]);
			$_.after(_label);
			$_.remove();
		});

		if(_default.allCheckedElement) {
			var _element = _default.allCheckedElement;
			var _thisBox = _element.find('input[type=checkbox]');
			_element.off().on('click', function() {
				if($(this).is(':checked')) {
					$(newCheckbox).find('input[type=checkbox]').prop('checked', true).next('img').attr('src', pbImagePath+'/check_on_'+_default.color+'.png');
				} else {
					$(newCheckbox).find('input[type=checkbox]').prop('checked', false).next('img').attr('src', pbImagePath+'/check_off.png');
				}
			});
		}
	};

	$.fn.pbRadiobox = function(_option, _callBack) {
		var _ = this;
		var _default = {
				color:'default',					// color : default, blue, red
				addText:'',							// type String, Array
				fontSize:'',						// default : 14px
				labelSize:'',
				textAlign:'',						// default : -5px
				imageSize:''
		};

		_callBack = _callBack ? _callBack:{ checked:function(){}, unChecked:function(){}, done:function(){} };

		var _callBackObj;
		if(typeof _callBack === 'function') {		// _callBack is done.
			_callBackObj = { checked:function(){}, unChecked:function(){}, done:_callBack };
		} else {
			_callBackObj = {
					checked:typeof _callBack.checked === 'function' ? _callBack.checked:function(){},
					unChecked:typeof _callBack.unChecked === 'function' ? _callBack.unChecked:function(){},
					done:typeof _callBack.done === 'function' ? _callBack.done:function(){},
			};
		}

		if(_option) {
			if(typeof _option.addText == 'string') option.addText = new Array(_option.addText);
			$.extend(_default, _option);
		}

		$.each(_, function(idx) {
			var $_ = $(this);
			var _label = $('<label>');
			_label.addClass('pb-radio-label');
			if(_default.labelSize) _label.addClass(_default.labelSize);
			if($_.attr('id')) _label.attr('for', $_.attr('id'));

			var imgOnOff = '/radio_off.svg';
			if($_.attr('checked')) imgOnOff = '/radio_on_'+_default.color+'.svg';
			_label.append($_.clone())
			.append('<img src="'+pbImagePath+imgOnOff+'">').find('img').addClass('pb-radio-box').attr('style', (_default.imageSize ? 'width:'+_default.imageSize+'; height:'+_default.imageSize+';':''));
			if(_default.addText[idx]) {
				_label.find('img').after('<span>').siblings('span').addClass('pb-radio-text').css('font-size', _default.fontSize)
				.html(_default.addText[idx]);
			} else {
				_label.attr('style', 'margin-right:0').find('img.pb-radio-box').attr('style', 'margin-right:0');
			}

			_label.on('change', function(event) {
				var _thisBox = $(this).find('input[type=radio]');

				if(_thisBox.is(':checked')) {
					$('input[type=radio][name='+_thisBox.attr('name')+']').next('img').attr('src', pbImagePath+'/radio_off.svg');
					_thisBox.siblings('img').attr('src', pbImagePath+'/radio_on_'+_default.color+'.svg');
					_callBackObj.checked(_thisBox, event);
				} else {
					_thisBox.siblings('img').attr('src', pbImagePath+'/radio_off.svg');
					_callBackObj.unChecked(_thisBox, event);
				}
				
				_callBackObj.done(_thisBox, event);
			});

			$_.after(_label);
			$_.remove();
		});
	};
	
	// new Radio
	$.fn.crtRadiobox = function(_option, _callBack) {
		var _ = this;
		
		var _default = {
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
			
			_label.addClass('nw-radio-label').addClass(_default.color);
			if(idx == 0) _label.addClass('first');
			else if(idx == (_.length - 1)) _label.addClass('last');
			
			if(_default.fontSize) _label.css('font-size', (typeof _default.fontSize == 'number' ? _default.fontSize+'px':_default.fontSize));
			if(_default.matchParent) _label.css('width', 'calc('+(100/_.length)+'% + 2px)').css('text-align', 'center');
			
			if($_.val() == _default.defaultValue) {
				$_.prop('checked', true);
				_label.addClass('ac');
			}
			
			_label.append($_.clone().css('display', 'none')).append(_default.addText[idx]);
			_label.on('click', function() {
				$(this).addClass('ac').siblings('.nw-radio-label').removeClass('ac');
			});
			
			$_.after(_label);
			$_.remove();
		});
	};

	// Select Tag : Year
	$.fn.createYear = function(_opt) {
		var _this = $(this);
		var _option = {
			begin: 1950,
			end: new Date().getFullYear(),
			selected: new Date().getFullYear(),
			unit: '',
		};
		
		if(_opt) { $.extend(_option, _opt); }
		
		for(var by = _option.begin; by <= _option.end; by++) {
			var rBy = by < 10 ? '0'+by:by;
//			var _selected = (_option.selected == _by ? 'selected':'');
			_this.append('<option value="'+rBy+'" >'+by+_option.unit+'년</option>');
		}
		
		_this.find('option[value="'+_option.selected+'"]').prop('selected', true);
	};

	// Select Tag : Month
	$.fn.createMonth = function(selectedVal, _unit) {
		var $this = $(this);
		$this.find('option').not('option[value=""]').remove();
		
		for(var bm = 1; bm <= 12; bm++) {
			var rBm = bm < 10 ? "0"+bm : bm;
			var $selected = $selected = rBm == selectedVal ? 'selected':'';
			$this.append('<option value="'+rBm+'"'+$selected+'>'+bm+(_unit ? _unit:'')+'월</option>');
		};
	};

	// Select Tag : Day
	$.fn.createDay = function(selectedVal, _unit) {
		var $this = $(this);
		$this.find('option').not('option[value=""]').remove();
		
		for(var bd = 1; bd <= 31; bd++) {
			var rBd = bd < 10 ? "0"+bd : bd;
			var $selected = $selected = rBd == selectedVal ? 'selected':'';
			$this.append('<option value="'+rBd+'"'+$selected+'>'+bd+(_unit ? _unit:'')+'일</option>');
		}
	};
	
	// Select Tag : Day
	$.fn.createTimeHour = function(selectedVal) {
		var $this = $(this);
		$this.find('option').not('option[value=""]').remove();
		
		for(var bd = 0; bd <= 23; bd++) {
			var rBd = bd < 10 ? "0"+bd : bd;
			var $selected = $selected = rBd == selectedVal ? 'selected':'';
			$this.append('<option value="'+rBd+'"'+$selected+'>'+rBd+'시</option>');
		}
	};
	
	$.fn.sysDate = function(_type, _opt) {
		var _ = $(this);
		if(_type) {
			var _default = {
				initFlag: true,
				begin: (_type == 'month' || _type == 'day' ? 1:0),
				maxValue: 0,
				unit: '',
				selected: '',
			};
			
			if(_type == 'year') {
				_default.begin = 1950;
				_default.maxValue = new Date().getFullYear();
			} else if(_type == 'month') _default.maxValue = 12;
			else if(_type == 'day') _default.maxValue = 31;
			else if(_type == 'hour') _default.maxValue = 23;
			else if(_type == 'min') _default.maxValue = 59;
			else console.log('_type is strange');
			
			if(_opt) { $.extend(_default, _opt); }
			
			if(_default.initFlag) _.html('');
			for(var i=_default.begin; i<=_default.maxValue; i++) {
				var ni = i < 10 ? '0'+i:i;
				_.append('<option value="'+ni+'">'+ni+_default.unit+'</option>');
			}
			_.find('option[value="'+_default.selected+'"]').prop('selected', true);
		} else console.log('_type is not null');
	};

	$.pb.phoneFomatter = function(_value, _hide) {
		var formatNum = '';
		var num = _value ? _value.replace(/-/gi, ''):'';

		if(num) {
			if(num.length==6) {
				formatNum = num.replace(/(\d{3})(\d{3})/, '$1-$2');
			} else if(num.length==8) {
				formatNum = num.replace(/(\d{4})(\d{4})/, '$1-$2');
			} else if(num.length==10) {
				if(_hide) formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-****-$3');
				else{
					if(num.indexOf('02')==0) formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3'); // 02국번에 10자일경우 추가함
					else formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
				}
			} else if(num.length==11) {
				if(_hide) formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-****-$3');
				else formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
			}
//			else if(num.length==12) {
//				if(_hide) formatNum = num.replace(/(\d{4})(\d{4})(\d{4})/, '$1-****-$3');
//				else formatNum = num.replace(/(\d{4})(\d{4})(\d{4})/, '$1-$2-$3');
//			}
			else if(num.indexOf('02')==0) {
				if(_hide) formatNum = num.replace(/(\d{2})(\d{3})(\d{4})/, '$1-****-$3');
				else formatNum = num.replace(/(\d{2})(\d{3})(\d{4})/, '$1-$2-$3');
			} else {
				formatNum = num;
			}

			return formatNum;
		} else return _value;
	};

	$.fn.phoneFomatter = function(_default, _hide){
//		$(this).attr('placeholder', '전화번호를 입력해주세요.');
		$(this).on('focus', function() { $(this).val(''); });
		$(this).on('keyup', function() {
			if($(this).val().length > 13) $(this).val($(this).val().slice(0, 13));
			else $(this).val($.pb.phoneFomatter($(this).val().replace(/[^0-9]/g, '')));
		});

		if(_default) $(this).val($.pb.phoneFomatter(_default, _hide));
	};
	
	$.pb.targetMoney = function(_value) {
		if(_value) return _value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","); 
		else return 0;
	};
	
	$.fn.targetMoney = function(_default, keyupDone) {
		$(this).on('focus', function() {
			$(this).val('');
			$(this).data('value', 0);
		});
		
		$(this).on('keyup', function() {
			
			//첫번째 0올경우 삭제
			if($(this).val().length > 1 && $(this).val().substr(0, 1) == 0) {
				$(this).val($(this).val().substring(1));
			}
			
			$(this).val($(this).val().replace(/[^0-9]/g, ''));
			$(this).val($.pb.targetMoney($(this).val()));
			$(this).data('value', $(this).val().replace(/,/gi, ''));
			if(keyupDone) keyupDone($(this));
			
			
		});
		
		if(_default) $(this).val(_default.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ','));
		$(this).data('value', $(this).val().replace(/,/gi, ''));
	};
	
	$.fn.getWeekDay = function(dateDay, language) {
		var week = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');;
		if(language == 'en') week = new Array('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');

		var todayLabel = week[dateDay];
		return todayLabel;
	};

	$.fn.tableEmptyChecked = function(_value) {
		var _ = $(this);
		var _text = _value ? _value:'입력된 데이터가 없습니다.';
		var colSpan = 0;
		$.each(_.find('thead > tr'), function() {
			colSpan = (colSpan < $(this).find('th').length ? $(this).find('th').length:colSpan);
		});
		
		$.each(_.find('thead > tr > th'), function() {
			if($(this).attr('colspan')) colSpan += $(this).attr('colspan') - 1;
		});
		
		if(_.find('tbody > tr').length < 15) {
			var crtLeng = 15 - _.find('tbody > tr').length;
			
			for(var j=0; j<crtLeng; j++) {
				var _tr = $('<tr>');
				_tr.addClass('empty alt');
				
				for(var i=0; i<colSpan; i++) {
					_tr.append('<td></td>');
				};
				
//			$(this).find('tbody').html('<tr class="empty alt"><td colspan='+colSpan+' style="padding:20px 0px; font-size:1.6em; text-align:center;">'+_text+'</td></tr>');
				_.find('tbody').append(_tr);
			}
		}
	};
	
	$.pb.passwordCheck = function(_pwElements01, _pwElements02, _option) {
		var _default = {
			text:'비밀번호를 정확히 입력해주세요.', 
			margin:'',										// _default : 0 0 0 6px
			color:'',										// _default : #FF4E4E
			fontSize:'',									// _default : 12px
			verticalAlign:'',								// _default : -4px
			regex:'',										// _default : ''
		};
		
		if(_option) { $.extend(_default, _option); }
		
		var _textWarning = $('<div class="pb-warning">'+_default.text+'</div>');
		_textWarning.css('margin', _default.margin);
		_textWarning.css('color', _default.color);
		_textWarning.css('font-size', _default.fontSize);
		_textWarning.css('vertical-align', _default.verticalAlign);
		
		_pwElements01.after(_textWarning.clone());
		_pwElements01.on('focusout', function(e) {
			var _value = $(this).val();
			
			if(_value == _pwElements02.val() && (_default.regex ? _default.regex.test(_value):true)) {
				$(this).siblings('.pb-warning').hide();
				_pwElements02.siblings('.pb-warning').hide();
			} else $(this).siblings('.pb-warning').show();
		});
		
		_pwElements02.after(_textWarning.clone());
		_pwElements02.on('focusout', function(e) {
			var _value = $(this).val();
			
			if(_value == _pwElements01.val() && (_default.regex ? _default.regex.test(_value):true)) {
				$(this).siblings('.pb-warning').hide();
				_pwElements01.siblings('.pb-warning').hide();
			} else $(this).siblings('.pb-warning').show();
		});
	};
	
	$.fn.plusMinusBox = function(_minusDone, _plusDone, _inputDone, color, raedonly) {
		var _thisWarp = $('<div class="pb-pm-wrap">');
		var _this = $(this).clone();
		
		_this.val(0);
//		_this.attr('class', 'pm-value-box').attr('readonly', (readonly ? readonly:true));
		_this.attr('class', 'pm-value-box');
		_this.on("keyup", function() { 
			$(this).val($(this).val().replace(/[^0-9]/g,"")); 
			if(_inputDone) _inputDone();
		});
			
		var _minus = $('<button type="button" tabindex="-1">');
		_minus.addClass(color ? 'btn-minus-' + color : 'btn-minus');
		
		var _plus = $('<button type="button" tabindex="-1">');
		_plus.addClass(color ? 'btn-plus-' + color : 'btn-minus');
		
		_minus.on('click', function() { 
			if(_this.val() > 0) _this.val((_this.val()*1) - 1);
			if(_minusDone) _minusDone();
		});
		
		_plus.on('click', function() { 
			_this.val((_this.val()*1) + 1); 
			if(_plusDone) _plusDone();
		});
		
		_thisWarp.append(_minus).append(_this).append(_plus);
		$(this).after(_thisWarp);
		$(this).remove();
	};
	
	$.fn.crtCommonCode = function(_opt) {
		
		var _ = $(this);
		var _default = {
			target: '',
			basicText: '선택해주세요',
			selected: '',
			order: 'VALUE ASC'
		};
		
		$.extend(_default, _opt);
		
		
		if(_default.basicText) _.html('<option value="">'+_default.basicText+'</option>');
		$.pb.ajaxCallHandler('/common/selectCommonCode.do', _default, function(codeResult) {
			$.each(codeResult, function() {
				var _item = $('<option>');
				_item.data(this).attr('value', this.VALUE).html(this.KO);
				_.append(_item);
			});
			
			if(_default.selected) _.find('option[value="'+_default.selected+'"]').prop('selected', true);
		});
	};
	
	$.pb.createCityCodeSelectBox = function(_lv1Element, _lv2Element, _default) {
		$.pb.ajaxCallHandler('/common/selectCityCode.do', { lv:1, order:'NAME ASC' }, function(data) {
			_lv1Element.html('<option value="">시/도</option>');
			if(_lv2Element) _lv2Element.html('<option value="">군/구</option>');
			
			$.each(data, function() { _lv1Element.append('<option value="'+this.CODE+'">'+this.NAME+'</option>'); });
			
			if(_lv2Element) {
				_lv1Element.off().on('change', function() {
					if($(this).val()) {
						$.pb.ajaxCallHandler('/common/selectCityCode.do', { lv:2, code:$(this).val(), order:'NAME ASC' }, function(data) {
							_lv2Element.html('<option value="">군/구</option>');
							
							$.each(data, function() {
								_lv2Element.append('<option value="'+this.CODE+'">'+this.LV2+'</option>');
							});
							
							if(_default) {
								_lv2Element.find('option[value='+_default+']').attr('selected', true);
								_default = '';
							}
						});
					} else _lv2Element.html('<option value="">군/구</option>');
				});
			}
			
			if(_default) _lv1Element.find('option[value*='+((_default+'').slice(0,2))+']').attr('selected', true).trigger('change');
		});
	};

	var inspection = function(_this) {
		if(!_this.length) return console.log('pb-calendar', '- No target.');
		else if(_this.attr('type') != 'text') return console.log('pb-calendar', '- Target type error. Target type must be text.');
		else return 'clear';
	};

	$.fn.createDatepicker = function($option) {
		var $this = $(this);
		if(inspection($this) != 'clear') return;

		var _option = {
				format: 'yyyy-MM-dd',
				calDate: '',
				lang: 'ko',
				monthTitleArr:new Array(),
				weekTitleArr:new Array(),
				fadeSpeed:400,
				selectWeek:false
		};

		if($option) {
			_option = {
				format:$option.format ? $option.format:_option.format,
				calDate:$option.calDate ? $option.calDate:_option.calDate,
				lang:$option.lang ? $option.lang:_option.lang,
				fadeSpeed:$option.fadeSpeed ? $option.fadeSpeed:_option.fadeSpeed,
				selectWeek:$option.selectWeek ? $option.selectWeek:_option.selectWeek,
				onClickCallBack:$option.onClickCallBack ? $option.onClickCallBack:null,
				parents:$option.parents ? $option.parents:null,
				previousDateProhibit:$option.previousDateProhibit ? $option.previousDateProhibit:false,
				previousDateProhibitAlert:$option.previousDateProhibitAlert ? $option.previousDateProhibitAlert:false
			};
		};

		var _bodyBackground = $('body').find('.calendar-ui-bg');
		if(_bodyBackground.length == 0) {
			$('body').append('<div class="calendar-ui-bg"></div>');
			_bodyBackground = $('body').find('.calendar-ui-bg');
		};

		_bodyBackground.on('click', function() {
			if($('.pb-calendar-ui').is(':visible')) $('.pb-calendar-ui').hide();
			$(this).hide();
		});

		var createCalendarUi = function(_this, _option) {
			_this.addClass('pb-datepicker');

			var _calendarWrap = _calendarWrap = _this.next('div.pb-calendar-ui');

			if(_option.lang == 'ko') {
				_option.monthTitleArr = new Array('1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월');
				_option.weekTitleArr = new Array('일', '월', '화', '수', '목', '금', '토');
				if(!_option.previousDateProhibitAlert) _option.previousDateProhibitAlert = '당일 이전 날짜는 선택하실 수 없습니다.';
			} else if(_option.lang == 'en') {
				_option.monthTitleArr = new Array('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
				_option.weekTitleArr = new Array('Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa');
				if(!_option.previousDateProhibitAlert) _option.previousDateProhibitAlert = 'You can not select a date before the date.';
			};

			if(!_this.next('div.pb-calendar-ui').length) {
				_calendarWrap = $('<div class="pb-calendar-ui"></div>');
				_calendarWrap.append('<div class="calendar-title"></div>');
				_calendarWrap.find('.calendar-title').append('<span class="year-title"></span>');
				_calendarWrap.find('.calendar-title').append('<img src="'+pbImagePath+'/cal_next_btn.png" class="next"/>');
				_calendarWrap.find('.calendar-title').append('<img src="'+pbImagePath+'/cal_prev_btn.png" class="prev"/>');

				_calendarWrap.append('<div class="week-box"></div>');
				for(var weekIdx = 0; weekIdx < _option.weekTitleArr.length; weekIdx++) {
					_calendarWrap.find('.week-box').append('<div class="item">'+_option.weekTitleArr[weekIdx]+'</div>');

					if(weekIdx == 0) _calendarWrap.find('.week-box > .item').last().addClass('su');
					else if(weekIdx == 6) _calendarWrap.find('.week-box > .item').last().addClass('sa');
				};

				_calendarWrap.append('<div class="day-box"></div>');
			};

			var toDate = _option.calDate ? new Date(_option.calDate):new Date();
			var toDateStart = new Date(toDate.getFullYear(), toDate.getMonth(), 1);
			var toDateEnd = new Date(toDate.getFullYear(), toDate.getMonth()+1, 0);
			var prevStartDate = new Date(toDate.getFullYear(), toDate.getMonth(), (1-toDateStart.getDay()));
			var nextEndDate = new Date(toDateEnd.getFullYear(), toDateEnd.getMonth(), (toDateEnd.getDate()+(6-toDateEnd.getDay())));

			_calendarWrap.find('.calendar-title > .year-title').html(_option.monthTitleArr[toDate.getMonth()]+' '+toDate.getFullYear());
			_calendarWrap.find('.calendar-title > .prev').unbind().bind('click', function() {
				_option.calDate = new Date(toDate.getFullYear(), toDate.getMonth()-1, 1);
				createCalendarUi(_this, _option);
			});
			_calendarWrap.find('.calendar-title > .next').unbind().bind('click', function() {
				_option.calDate = new Date(toDate.getFullYear(), toDate.getMonth()+1, 1);
				createCalendarUi(_this, _option);
			});

			_calendarWrap.find('.day-box').html('');

			var _dayCount = 1;
			var _tempDate = new Date(prevStartDate.getFullYear(), prevStartDate.getMonth(), prevStartDate.getDate());
			while(_tempDate.getTime() <= nextEndDate.getTime()) {
				var _item = $('<div class="item">'+_tempDate.getDate()+'</div>');
				_item.data('date-value', _tempDate);
				if(_tempDate.getMonth() == toDate.getMonth()) _item.addClass('thisMonth');
				if(_tempDate.format(_option.format) == new Date().format(_option.format)) _item.addClass('toDay');
				if(_this.val()) if(_tempDate.format(_option.format) == _this.val()) _item.addClass('selectDay');

				if(_tempDate.getDay() == 0) _item.addClass('su');
				else if(_tempDate.getDay() == 6) _item.addClass('sa');

				_item.on('click', function(e) {
					$(this).addClass('selectDay').siblings('.item').removeClass('selectDay');

					if(_option.selectWeek) {
						$('.day-box > .item.thisWeek').removeClass('thisWeek');

						var wSu = $(this).index()-($(this).data('dateValue').getDay())+1;
						$('.day-box > .item').slice(wSu, wSu+7).addClass('thisWeek');
					};

					if(_option.previousDateProhibit)
						if($(this).data('date-value').format('yyyyMMdd') < new Date().format('yyyyMMdd')) return alert(_option.previousDateProhibitAlert);

					_this.val($(this).data('date-value').format(_option.format));
					_calendarWrap.hide();
					if(_bodyBackground.length) _bodyBackground.hide();
					_this.trigger('change');
				});

				_calendarWrap.find('.day-box').append(_item);
				_tempDate = new Date(prevStartDate.getFullYear(), prevStartDate.getMonth(), prevStartDate.getDate()+_dayCount);
				_dayCount++;
			};


			if(_option.selectWeek && $('.day-box > .item.selectDay').length) {
				$('.day-box > .item.thisWeek').removeClass('thisWeek');
				var wSu = $('.day-box > .item.selectDay').index()-($('.day-box > .item.selectDay').data('dateValue').getDay())+1;
				$('.day-box > .item').slice(wSu, wSu+7).addClass('thisWeek');
			} else if(_option.selectWeek && _calendarWrap.find('.item.toDay').length) {
				$('.day-box > .item.thisWeek').removeClass('thisWeek');
				var itemBase = _calendarWrap.find('.item.toDay');
				var itemBaseIdx = itemBase.index();
				var wSu = itemBaseIdx-(itemBase.data('dateValue').getDay())+1;
				$('.day-box > .item').slice(wSu, wSu+7).addClass('thisWeek');
			};

			_this.on('focus', function() {
				var _offset = _this.offset();
				if(!_this.is(':visible')) {
					_this.show();
					_offset = _this.offset();
					_this.hide();
				};

				var _top, _left;
				if(_option.parents) {
					_top = (_offset.top + $(this).height() - _option.parents.offset().top) + 'px';
					_left = (_offset.left - _option.parents.offset().left) + 'px';
				} else {
					_top = _offset.top + $(this).height() + 'px';
					_left = _offset.left + 'px';
				}

				_this.next('div.pb-calendar-ui').css('top', _top).css('left', _left).fadeIn(_option.fadeSpeed);

				if(_option.selectWeek && _calendarWrap.find('.item.toDay').length && !_calendarWrap.find('.item.selectDay').length) {
					$('.day-box > .item.thisWeek').removeClass('thisWeek');
					var itemBase = _calendarWrap.find('.item.toDay');
					var itemBaseIdx = itemBase.index();
					var wSu = itemBaseIdx-(itemBase.data('dateValue').getDay())+1;
					$('.day-box > .item').slice(wSu, wSu+7).addClass('thisWeek');
				}

				_bodyBackground.show();
			});

			_this.attr('readonly', true);
			_this.addClass('crt-calendar-icon');

			_this.after(_calendarWrap);
		};

		if($this.length == 1) createCalendarUi($this, _option);
		else if($this.length > 1) $.each($this, function() { createCalendarUi($(this), _option); });
	};
	
	// Use in Spring
	$.fn.pageConnectionHandler = function(page, _param, done) {
		var _this = $(this);

		var param = { page : page };
		$.extend(param, _param);

		$.ajax({
			url : '/common/pageConnectionHandler.do',
			type : 'post',
			data : param,
			async: true,
			success : function(data) {
				_this.html(data);
				if(done) done();
			},
			error : function(err) {
				console.info('Error', err);
//				$(location).attr('href', '/');
			}
		});
	};

	// Use in NodeJS
	$.fn.pageConnection = function(_page, _data) {
		var _this = $(this);
		if(_page) {
			$.ajax({
				url : '/pageConnection',
				type : 'post',
				data : { page:_page, data:_data },
				async : true,
				success : function(data) {
					_this.html(data);
				},
				error : function(err) {
					console.log(err);
				}
			});
		}
	};
	
	$.pb.getCookie = function(_cookieName) {
		_cookieName = _cookieName + '=';
		var cookieData = document.cookie;
		var start = cookieData.indexOf(_cookieName);
		var cookieValue = '';
		
		if(start != -1) {
			start += _cookieName.length;
			var end = cookieData.indexOf(';', start);
			
			if(end == -1) end = cookieData.length;
			cookieValue = cookieData.substring(start, end);
		}
		
		return unescape(cookieValue);
	}
	
	$.pb.delCookie = function(_keyValue){
		var expireDate = new Date();
	    expireDate.setDate(expireDate.getDate() - 1);
	    document.cookie = _keyValue + "= " + "; expires=" + expireDate.toGMTString();
	}
	

	$.pb.ajaxCallHandler = function($url, $data, $done, $xhrHeader) {
		$.ajax({
			url: $url,
			type: 'post',
			data: $data,
			beforeSend: function(xhr) {
				if($xhrHeader == false) xhr.setRequestHeader('requestJsonData', false);
				else xhr.setRequestHeader('requestJsonData', true);
			},
			success: function(rs) {
				if($done != null) $done(rs);
			},
			error: function(err) {
				console.info('Error', err);
			}
		});
	};

	$.pb.ajaxUploadForm = function(_url, _formData, _done, _session) {
//		var agent = navigator.userAgent.toLowerCase();
		if(_session) {
			$.ajax({
				url: _url,
				type: 'post',
				data: _formData,
				processData: false,
				contentType: false,
				success: function(rs) {
					if(_done != null) _done(rs);
				},
				error: function(err) {
					console.info('Error', err);
				}
			});
		} else {
			alert('[UploadForm] 세션이 만료되었습니다. 로그인화면으로 돌아갑니다.');
			$(location).attr('href', '/');
		}
	};

	$.fn.createPaging = function($data, btnFunction) {
		this.html('');

		var total = $data.total*1;
		var display = $data.display ? $data.display*1:10;
		var currentPage = $data.currentPage*1;
		var totalPage = Math.ceil(total/display);
		var pageCount = 10;

		var startPage = currentPage/10;
		if(startPage > 1) {
			if(startPage%1 == 0) startPage = startPage * pageCount - 9
			else startPage = Math.floor(startPage) * pageCount + 1
		} else {
			startPage = 1;
		}

		var endPage = startPage + 9;
		endPage = endPage <= pageCount ? pageCount : endPage;
		endPage = endPage > totalPage ? totalPage : endPage;
		endPage = endPage == 0 ? 1 : endPage;

		var $sBtn01 = $('<span class="prev"><i class="fas fa-chevron-left"></i></span>');
		var $sBtn02 = $('<span class="next"><i class="fas fa-chevron-right"></i></span>');
		var prev = startPage == 1 ? 1:startPage-1;
		$sBtn01.unbind().bind('click', function() { btnFunction(prev); });
		
		for(var i=startPage; i<=endPage; i++) {
			var $page = $('<span class="num">'+i+'</span>');
			if(i == currentPage) $page.addClass('ac');
			this.append($page);
		};

		$.each(this.find('span.num'), function() {
			$(this).unbind().bind('click', function() { btnFunction($(this).text());  });
		});

		var next = endPage == totalPage ? endPage:endPage+1;
		$sBtn02.unbind().bind('click', function() { btnFunction(next); });
		if(totalPage > pageCount) {
			this.prepend($sBtn01);
			this.append($sBtn02);
		}
	};

	$.pb.addStyleSheet = function(_file) {
		if(_file) {
			if(typeof _file == 'string') _file = new Array(_file);
			for(var i=0; i<_file.length; i++) {
				var link = document.createElement('link');
				link.type = 'text/css';
				link.rel = 'stylesheet';
				link.href = '/resources/playbench/css/'+ _file[i] + '.css';

				document.getElementsByTagName('head')[0].appendChild(link);
			}
		} else console.log('File does not exist.');
	};
	
	$.pb.createDateObj = function(_toDay, _format, _time) {
		_toDay = _toDay ? _toDay:new Date();
		_format = _format ? _format:'yyyy-MM-dd';
		_time = _time ? _time:'HH:mm';
		
		var _firstDate = new Date(_toDay.getFullYear(), _toDay.getMonth(), 1);
		var _lastDate = new Date(_toDay.getFullYear(), _toDay.getMonth()+1, 0);
		var _dateObj = { 
				toDay:_toDay,
				firstDate:_firstDate,
				lastDate:_lastDate,
				toDayFormat:_toDay.format(_format),
				firstDateFormat:_firstDate.format(_format),
				lastDateFormat:_lastDate.format(_format),
				timeFormat:_toDay.format(_time),
				year:_toDay.getFullYear(),
				month:_toDay.getMonth()+1,
				day:_toDay.getDate(),
				hour:_toDay.getHours(),
				min:_toDay.getMinutes(),
				_month:(_toDay.getMonth()+1 < 10 ? '0'+(_toDay.getMonth()+1):_toDay.getMonth()+1),
				_day:(_toDay.getDate() < 10 ? '0'+_toDay.getDate():_toDay.getDate())
		};
		
		return _dateObj;
	};

	Date.prototype.format = function(f) {
		if(!this) return;
		
		var d = this;
		var weekName = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];
		
		return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
	        switch($1) {
	            case "yyyy": return d.getFullYear();
	            case "yy": return (d.getFullYear() % 1000).zf(2);
	            case "MM": return (d.getMonth() + 1).zf(2);
	            case "dd": return d.getDate().zf(2);
	            case "E": return weekName[d.getDay()];
	            case "HH": return d.getHours().zf(2);
	            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
	            case "mm": return d.getMinutes().zf(2);
	            case "ss": return d.getSeconds().zf(2);
	            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
	            default: return $1;
	        }
	    });
	};

	String.prototype.string = function(len){ var s = '', i = 0; while (i++ < len) { s += this; } return s; };
	String.prototype.zf = function(len){ return "0".string(len - this.length) + this; };
	Number.prototype.zf = function(len){ return this.toString().zf(len); };
	
	$.pb.addStyleSheet(['pb-common', 'pb-calendar', 'pb-community', 'pb-nomal-sec']);

	var filter = "win16|win32|win64|mac|macintel";
	if(navigator.platform) {
		if(0 > filter.indexOf(navigator.platform.toLowerCase())) navigator.pPlatformCheck = 'mobile';
		//else navigator.pPlatformCheck = 'mobile';
		else navigator.pPlatformCheck = 'nomal';
		
//		console.log('this platform', navigator.platform, navigator.pPlatformCheck);
		
		$.pb.addStyleSheet(['pb-'+navigator.pPlatformCheck]);
		
		
	}

	//엑셀 다운로드
	$.fn.excelDown = function(_tableId, _fileName) {
		this.on('click', function(e){
			var a = document.createElement('a');
	        var data_type = 'data:application/vnd.ms-excel;charset=utf-8';
	        var table_html = encodeURIComponent(document.getElementById(_tableId).outerHTML);
	        a.href = data_type + ',%EF%BB%BF' + table_html;
	        a.download = _fileName + '.xls';
	        a.click();
	        e.preventDefault();
		});
	};
	
	$.pb.returnEmailForm = function(_value) {
		var _regex = /^[a-zA-Z]?[\w0-9-]*\@([\w0-9-\.]+)+\.[\w]{2,}$/;
		return _regex.test(_value);
	}
	
	$.pb.settingCookie = function(_cookieKey, _keyValue, _saveFlag) {
		var _d = new Date();
		_d.setDate(_d.getDate() + 7);
		document.cookie = _cookieKey+'=;path=/;expires="Thu, 01 Jan 1970 00:00:01 GMT";';
		if(_saveFlag) document.cookie = _cookieKey+'='+escape(_keyValue)+(_d ? ';path=/;expires="'+_d.toGMTString()+'";':'');
	};
	
	$.pb.settingCookiePop = function(_cookieKey, _keyValue, _exp) {
		var date = new Date();
		date.setTime(date.getTime() + _exp*24*60*60*1000);
		document.cookie = _cookieKey + '=' + _keyValue + ';expires=' + date.toUTCString() + ';path=/';
	};
	
	$.pb.getCookie = function() {
		var getCookie = document.cookie;
		var cookieSplit = getCookie.split('; ');
		
		var cookieObj = {};
		$.each(cookieSplit, function(idx, _value) {
			var valueSplit = _value.split('=');
			if(valueSplit.length == 2) cookieObj[valueSplit[0]] = unescape(valueSplit[1]);
		});
		
		return cookieObj; 
	}
	
	$.pb.returnTimeDiff = function(_date, _date2) {
//		var _tmpDate = _date.replace(/-|:| /gi, ',');
//		_tmpDate = eval('new Date('+_tmpDate+')');
//		_tmpDate.setMonth(_tmpDate.getMonth()-1);
		
		var _tmpDate = (typeof _date == 'string' ? new Date(_date):_date);
		var _tmpDate2 = (_date2 ? (typeof _date2 == 'string' ? new Date(_date2):_date2):null);

		var returnStr = '';
		if(_date) {
			var timeDiff = (_tmpDate2 ? _tmpDate2.getTime():new Date().getTime()) - _tmpDate.getTime();
			var newTime = new Date(0, 0, 0, 0, 0, 0, timeDiff);
			
			var _nD = Math.floor(timeDiff/(1000 * 60 * 60 * 24));
			var _nH = newTime.getHours();
			var _nM = newTime.getMinutes();
			var _nS = newTime.getSeconds();
			
			returnStr = {
				timeDiff: timeDiff/1000,
				message: (_nD ? _nD+'일 ':(_nH ? _nH+'시간 ':(_nM ? _nM+'분 ':(_nS ? _nS+'초 ':''))))+'전',
				_nD:_nD
			};
		} else returnStr = 'Date is null..';
		
		return returnStr;
	};
	
}));

function isNull(str, chgStr) {
    if (str == null || str == '' || str == 'undefined') {
          return chgStr ? chgStr:'';
    } else {
          return str;
    }
}

function showFormData(_form) {
	$.each(_form.find('[name]'), function(idx) { 
		console.log(idx, '[ '+$(this)[0].localName+' ]', $(this)[0].name, ($(this).val() ? $(this).val():null));
		if($(this)[0].type == 'text'){
			console.log('[ '+$(this)[0].type+' ]', $(this)[0].name, ($(this).val() ? $(this).val():null));
		}
		else if($(this)[0].type == 'radio') {
			if($(this).is(':checked')){
				console.log('[ '+$(this)[0].type+' ]', $(this)[0].name, ($(this).val() ? $(this).val():null));
			}
		} else if($(this)[0].localName == 'select'){
			console.log('[ '+$(this)[0].type+' ]', $(this)[0].name, ($(this).val() ? $(this).val():null));
		}
		else {
			console.log('[ '+$(this)[0].type+' ]', $(this)[0].name, ($(this).val() ? $(this).val():null));
		}
	});
}


function fnExcelReport(id, title) {
	var tab_text = '<html xmlns:x="urn:schemas-microsoft-com:office:excel">';
	tab_text = tab_text + '<head><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8">';
	tab_text = tab_text + '<xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>'
	tab_text = tab_text + '<x:Name>Test Sheet</x:Name>';
	tab_text = tab_text + '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';
	tab_text = tab_text + '</x:ExcelWorksheets></x:ExcelWorkbook></xml></head><body>';
	tab_text = tab_text + "<table border='1px'>";
	var exportTable = $('#' + id).clone();
	exportTable.find('input').each(function (index, elem) { $(elem).remove(); });
	tab_text = tab_text + exportTable.html();
	tab_text = tab_text + '</table></body></html>';
	var data_type = 'data:application/vnd.ms-excel';
	var ua = window.navigator.userAgent;
	var msie = ua.indexOf("MSIE ");
	var fileName = title + '.xls';
	//Explorer 환경에서 다운로드
	if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
		if (window.navigator.msSaveBlob) {
		var blob = new Blob([tab_text], {
		type: "application/csv;charset=utf-8;"
		});
		navigator.msSaveBlob(blob, fileName);
		}
	} else {
		var blob2 = new Blob([tab_text], {
		type: "application/csv;charset=utf-8;"
		});
		var filename = fileName;
		var elem = window.document.createElement('a');
		elem.href = window.URL.createObjectURL(blob2);
		elem.download = filename;
		document.body.appendChild(elem);
		elem.click();
		document.body.removeChild(elem);
	}
}


function onlyNumber(event){
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		return false;
}

function removeChar(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		event.target.value = event.target.value.replace(/[^0-9]/g, "");
}

function emailcheck(str){
	var regExp = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,2}$/;
	//입력을 안했으면
	if(str.lenght == 0) return false;
	//이메일 형식에 맞지않으면
	if (!str.match(regExp)) {return false;}
	return true;
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}



var FnOrderTrans = function(data, orderFlag) {
	var _str = "";
	
	// 총 48칸
	// 상품명 20칸
	var _len = 0;
	for (var i = 0; i < data.ITEM_NAME.length; i++) {
   		if (escape(data.ITEM_NAME.charAt(i)).length == 6) _len += 2;
       	else _len += 1;
   	}
	
	if(_len < 19) {
    	_str += data.ITEM_NAME;
		for(var i = 0; i < (20 - _len); i++) {
    		_str += " ";
    	}
	}else {
		//_len 길이 체크 20이상일 경우 뒤에 문자 잘라서 띄어쓰기 붙이기
		_str += data.ITEM_NAME.substr(0, 9);
    	var _len2 = 0
		for (var i = 0; i < data.ITEM_NAME.substr(0, 9).length; i++) {
       		if (escape(data.ITEM_NAME.substr(0, 9).charAt(i)).length == 6) _len2 += 2;
           	else _len2 += 1;
       	}
    	for(var i = 0; i < (20 - _len2); i++) {
    		_str += " ";
    	}
	}
	
	//단가 10칸
	var _pLen = 0
	var _price = $.pb.targetMoney(data.VAT_PRICE);
	for (var i = 0; i < _price.length; i++) {
		_pLen += 1;
   	}
	for(var i = 0; i < (10 - _pLen); i++) {
		_str += " ";
	}
	_str += _price;
	
	
	if(!orderFlag) {
		//수량 7칸
		for(var i = 0; i < (7 - data.CNT.toString().length); i++) {
			_str += " ";
		}
		_str += data.CNT;
		
		//금액 11칸
		var _tLen = 0
		var _tPrice = $.pb.targetMoney(data.VAT_PRICE*data.CNT);
		for (var i = 0; i < _tPrice.length; i++) {
			_tLen += 1;
	   	}
		for(var i = 0; i < (11 - _tLen); i++) {
			_str += " ";
		}
		_str += _tPrice;
	}else {
		//수량 7칸
		for(var i = 0; i < (6 - data.CNT.toString().length); i++) {
			_str += " ";
		}
		_str += "-"+data.CNT;
		
		//금액 11칸
		var _tLen = 0
		var _tPrice = $.pb.targetMoney(data.VAT_PRICE*data.CNT);
		for (var i = 0; i < _tPrice.length; i++) {
			_tLen += 1;
	   	}
		for(var i = 0; i < (10 - _tLen); i++) {
			_str += " ";
		}
		_str += "-"+_tPrice;
	}
	
	
	
	return _str;
}

var FnOrderPrint = function(data, partnerFlag, orderFlag) {
	var _str = "";
	if(data.PARTNER_FLAG == partnerFlag) {
		// 프린트 총 40칸
		// 상품명 14칸
    	var _len = 0
    	for (var i = 0; i < data.ITEM_NAME.length; i++) {
       		if (escape(data.ITEM_NAME.charAt(i)).length == 6) _len += 2;
           	else _len += 1;
       	}
    	
    	if(_len < 13) {
    		_str += data.ITEM_NAME;
    		for(var i = 0; i < (14 - _len); i++) {
    			_str += " ";
	    	}
    	}else {
    		//_len 길이 체크 14이상일 경우 뒤에 문자 잘라서 띄어쓰기 붙이기
    		_str += data.ITEM_NAME.substr(0, 6);
	    	var _len2 = 0
    		for (var i = 0; i < data.ITEM_NAME.substr(0, 6).length; i++) {
           		if (escape(data.ITEM_NAME.substr(0, 6).charAt(i)).length == 6) _len2 += 2;
	           	else _len2 += 1;
	       	}
	    	for(var i = 0; i < (14 - _len2); i++) {
	    		_str += " ";
	    	}
    	}
    	
    	
    	//단가 10칸
    	var _pLen = 0
    	var _price = $.pb.targetMoney(data.VAT_PRICE);
    	for (var i = 0; i < _price.length; i++) {
    		_pLen += 1;
       	}
    	for(var i = 0; i < (10 - _pLen); i++) {
    		_str += " ";
    	}
    	_str += _price;
    	
    	
    	if(!orderFlag) {
    		//수량 7칸
        	for(var i = 0; i < (7 - data.CNT.toString().length); i++) {
        		_str += " ";
        	}
        	_str += data.CNT;
        	
        	//금액 11칸
        	var _tLen = 0
        	var _tPrice = $.pb.targetMoney(data.VAT_PRICE*data.CNT);
        	for (var i = 0; i < _tPrice.length; i++) {
        		_tLen += 1;
           	}
        	for(var i = 0; i < (11 - _tLen); i++) {
        		_str += " ";
        	}
        	_str += _tPrice;
    	}else {
    		//수량 7칸
        	for(var i = 0; i < (6 - data.CNT.toString().length); i++) {
        		_str += " ";
        	}
        	_str += "-"+data.CNT;
        	
        	//금액 11칸
        	var _tLen = 0
        	var _tPrice = $.pb.targetMoney(data.VAT_PRICE*data.CNT);
        	for (var i = 0; i < _tPrice.length; i++) {
        		_tLen += 1;
           	}
        	for(var i = 0; i < (10 - _tLen); i++) {
        		_str += " ";
        	}
        	_str += "-"+_tPrice;
    	}
    	
	}
	return _str;
}

// 프린트 뽑는데 사용하는 함수
function chkStrLength(str) {    
	var str;    
	var han_count = 0;     
	han_count = (escape(str)+"%u").match(/%u/g).length-1; 
	return (str.length + han_count);
}
