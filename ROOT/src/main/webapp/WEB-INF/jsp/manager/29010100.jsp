<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _data = JSON.parse('${data}');
		if(!'${sessionScope.loginProcess}') $(location).attr('href', '/');
		if($.pb.getCookie().dsID && $.pb.getCookie().dsPW) {
			$.pb.ajaxCallHandler('/common/selectLoginUserInfo.do', { userId:$.pb.getCookie().dsID, userPassword:$.pb.getCookie().dsPW }, function(data) {
				if(!data) $(location).attr('href', '/');
			})
		}
		$('.main-contents-wrap').pageConnectionHandler('/view/event-sub', { pk:_data.pk, eventBinsoNo:_data.eventBinsoNo }, function() {});
	});
</script>





