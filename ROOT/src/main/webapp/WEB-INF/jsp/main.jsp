<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<jsp:include page="/WEB-INF/jsp/common/meta.jsp"></jsp:include>
	<jsp:include page="/WEB-INF/jsp/common/title.jsp"></jsp:include>
	<script>
		$(function() {
			var _session = '${sessionScope.loginProcess}' ? JSON.parse('${sessionScope.loginProcess}'):null;
			$.getScript('/resources/playbench/js/site-common.js', function(data, textStatus, jqxhr) {
				
				var _lvUrl = (_session.LV.slice(0,1) == 9 ? (_session.FUNERAL_NO ? '/manager/':'/admin/' ):(_session.LV == 39 ? '/photo/':'/manager/'));
				
				if(!_session) $(location).attr('href', '/');
				else if($(location)[0].pathname == '/main') {
					
				} else {
					var _urlSplit = $(location)[0].pathname.split('/');
					var _mainObj = { pk:'${subPath}' };

					if(_session.LV == 99){
						_lvUrl += _urlSplit[1];
						if(6 < _urlSplit[1].length) _lvUrl = '/admin/9910'+_urlSplit[1].substring(4,6)+'00';
						else _lvUrl = _lvUrl;
						
					}else{
						_lvUrl += _urlSplit[1];
						if(6 < _urlSplit[1].length) _lvUrl = '/manager/2901'+_urlSplit[1].substring(4,6)+'00';
						else _lvUrl = _lvUrl;
					}
					
					history.pushState({ link:$(location)[0].pathname, page:_lvUrl }, '', $(location)[0].pathname);
					$('.main-contents-wrap').pageConnectionHandler(_lvUrl, _mainObj, function() {});
				}
				
				if(!$('.ajax-loading').length) $('body').append('<div class="ajax-loading"><img src="/resources/playbench/images/ajax_loader.gif"/></div>');
			});
		});
	</script>
</head>
<body id="body">
	<jsp:include page="/WEB-INF/jsp/common/main-left.jsp"></jsp:include>
	<div class="main-contents-wrap"></div>
	<div class="popup-mask"></div>
</body>
</html>