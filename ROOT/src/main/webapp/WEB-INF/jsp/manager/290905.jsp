<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<script>
	$(function() {
		var _param = JSON.parse('${data}');
		$('.main-contents-wrap').pageConnectionHandler('/view/print-event-05', { pk: _param.pk }, function() {});
	});
</script>