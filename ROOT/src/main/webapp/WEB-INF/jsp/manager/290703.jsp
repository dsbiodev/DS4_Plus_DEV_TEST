<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	//화환통계 link
	$(function() {
		var pwd = prompt("비밀번호를 입력하세요","");
		
		if(pwd =="8520"){			
			$('.main-contents-wrap').pageConnectionHandler('/view/flower-sales-statistics', { pk:'${pk}' }, function() {});
		}else if(pwd == null){
			$('.main-contents-wrap').pageConnectionHandler('/view/event-simple', { pk:'${pk}' }, function() {});
			
		}else{
			alert("비밀번호가 일치하지 않습니다.");
			history.go(-1);
		}
	});
</script>