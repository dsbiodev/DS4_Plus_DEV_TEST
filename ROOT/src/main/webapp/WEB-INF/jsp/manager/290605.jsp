<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	//염습대장 link
	$(function() {
		$('.main-contents-wrap').pageConnectionHandler('/view/dressing-list', { pk:'${pk}' }, function() {});
	});
</script>