<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	//제천서울병원 제품 사용량 조회 페이지
	$(function() {
		$('.main-contents-wrap').pageConnectionHandler('/view/jecheon_productUsage', { pk:'${pk}' }, function() {});
	});
</script>