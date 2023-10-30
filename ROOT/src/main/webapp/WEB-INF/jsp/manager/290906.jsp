<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<script>
$(function() {	
	$('.main-contents-wrap').pageConnectionHandler('/view/print-event-06', { pk:'${searchObj.funeralNo}' }, function() {
		//console.log("\n\n t : ", pk);
	});
});
	
</script>