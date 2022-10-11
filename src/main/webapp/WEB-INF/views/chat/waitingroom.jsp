<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<style>
input:valid {
  border-color: green;
}
input:invalid {
  border-color: red;
}
</style>
<section id=enroll-container>
	<h2>채팅</h2>
	<form name="chatroomFrm" action="<%= request.getContextPath() %>/chat/chatroom">
		<table>
			<tr>
				<th>채팅방<sup>*</sup></th>
				<td>
					<input type="radio" name="chatroomId" id="chatroom-all" value="helloMvc" />
					<label for="chatroom-all">HelloMvc 전체방</label>
					<input type="radio" name="chatroomId" id="chatroom-custom" value="" checked/>
					<label for="chatroom-custom">커스텀채팅방</label>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<input 
						type="text" 
						id="customChatroomId" 
						placeholder="채팅방아이디를 입력하세요."  
						pattern="[A-Za-z0-9]+"
						required/>										
					<input type="submit" value="채팅시작">
				</td>
			</tr>
		</table>
	</form>
</section>
<script>
const customChatroomId = document.querySelector("#customChatroomId");

/**
 * 커스텀채팅방일때만 input#customChatroomId 노출, required
 */
document.querySelectorAll("[name=chatroomId]").forEach((radio) => {
	radio.addEventListener('change', (e) => {
		const isCustomChatroom = e.target.id === 'chatroom-custom';
		customChatroomId.style.display = isCustomChatroom ? 'inline' : 'none';
		customChatroomId.required = isCustomChatroom; 
	});
});

/**
 * input#customChatroomId 입력값 -> radio 값입력
 */
customChatroomId.addEventListener('input', (e) => {
	document.querySelector("#chatroom-custom").value = e.target.value;
	
	e.target.setCustomValidity(''); // 오류메세지 초기화
	e.target.checkValidity(); // 작성내용이 pattern정규식에 일치하는지 검사. 일치하지 않으면 invalid 이벤트 발생! 
});

/**
 * pattern에 일치하지 않을때 발생하는 invalid 핸들러
 */
customChatroomId.addEventListener('invalid', (e) => {
	if(e.target.value === '')
		e.target.setCustomValidity('채팅방아이디는 필수입력항목입니다.');
	else
		e.target.setCustomValidity('채팅방아이디는 영문자/숫자로만 작성가능합니다.');
});

</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>






  
