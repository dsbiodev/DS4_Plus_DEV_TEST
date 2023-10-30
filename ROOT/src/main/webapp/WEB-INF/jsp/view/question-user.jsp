<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script>
	$(function() {
		var _param = JSON.parse('${data}');
		
		$('input[type=radio][name=questionFlag]').pbRadiobox({ addText:['이용문의', '고장/장애', '제휴문의'], fontSize:'16px', matchParent:true });
		$('input[type=radio][name=questionFlag][value=1]').click();
		
		$('.question-user').text('문의 담당자 : '+'${sessionScope.loginProcess.NAME}'+('${sessionScope.loginProcess.PHONE}' ? '('+$.pb.phoneFomatter('${sessionScope.loginProcess.PHONE}')+')' : ''));
		$('.register').on('click', function(){
			if(!$('.question-textarea').val()) return alert("문의내용을 입력해 주세요.");
			var _formData = new FormData($('#dataForm')[0]);
			_formData.append('funeralNo', '${sessionScope.loginProcess.FUNERAL_NO}');
			_formData.append('createUserNo', '${sessionScope.loginProcess.USER_NO}');
			$.pb.ajaxUploadForm('/adminSec/insertQuestion.do', _formData, function(result) {
				if(result != 0) {
					$('input[type=radio][name=questionFlag][value=1]').click();
					$('textarea[name=contents]').val("");
					alert("문의되었습니다.");
				} else alert('저장 실패 관리자에게 문의하세요');
			}, '${sessionScope.loginProcess}');
		});
	});
</script>
<div class="contents-title-wrap">
	<div class="title">문의하기</div>
	<div>프로그램 사용방법 등 기타사항을 문의할 수 있습니다.</div>
	<div class="question-user"></div>
</div>
<div class="search-box-wrap">
	<div class="search-left-wrap">
		<div class="search-title">문의작성</div>
	</div>
	<div class="search-right-wrap">
		<button type="button" class="search-text-button register">작성완료</button>
	</div>
</div>
<div class="contents-body-wrap">
	<form id="dataForm">
		<div class="question-row">
			<label class="question-title" style="height:48px; line-height:48px;">문의항목</label>
			<div style="display:inline-block; margin-left:16px;">
				<input type="radio" name="questionFlag" value="1">
				<input type="radio" name="questionFlag" value="2">
				<input type="radio" name="questionFlag" value="3">
			</div>
		</div>
		<div class="question-row" style="margin-top:20px;">
			<div class="question-title" style="height:300px; line-height:300px;">문의내용</div>
			<textarea class="question-textarea" name="contents" style="height:300px;"></textarea>
		</div>
	</form>
</div>