<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _data = JSON.parse('${data}');
		$('.main-contents-wrap').pageConnectionHandler('/view/zadmin-event-sub', { pk:_data.pk, eventBinsoNo:_data.eventBinsoNo, funeralNo:_data.funeralNo }, function() {});
	});
</script>