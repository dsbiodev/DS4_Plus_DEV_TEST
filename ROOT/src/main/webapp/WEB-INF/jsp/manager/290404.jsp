<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		$('.main-contents-wrap').pageConnectionHandler('/view/screen-90', { pk:'${pk}' }, function() {});
	});
</script>