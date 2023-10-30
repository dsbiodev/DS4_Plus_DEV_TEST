<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<script>
	$(function() {
		//$('.main-contents-wrap').pageConnectionHandler('/view/print-event-03', { pk:'${pk}' }, function() {});
		
		// LSH - modify 2023.02.14
		var ua = window.navigator.userAgent;
		var msie = ua.indexOf("MSIE");
		
		if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) { 	//Explorer 환경
			$('.main-contents-wrap').pageConnectionHandler('/view/print-event-03', { pk:'${pk}' }, function() {});			
		} else {	//Explorer 이외의 환경
			$('.main-contents-wrap').pageConnectionHandler('/view/print-event-03-NIE', { pk:'${pk}' }, function() {});
		}
	});
</script>