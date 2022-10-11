<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/header.jsp" %>  
<%
	String memberId = loginMember.getMemberId();
	String chatroomId = request.getParameter("chatroomId");
%>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/chat.css" />
<section id="chat-container">	
	<h2>채팅</h2>
	<div id="msg-container">
		<ul></ul>
	</div>
	
	<div id="msg-editor" class="editor">
		<form name="chatMsgFrm">
			<textarea name="msg" id="msg" cols="30" rows="2" pattern="(.|\n)+"
				required></textarea>
			<button type="submit" id="send">Send</button>
		</form>
	</div>
</section>
<script>
document.chatMsgFrm.addEventListener("submit", (e) => {
	e.preventDefault();
	
	const payload = {
		messageType : 'CHAT_MSG',
		data : {
			chatroomId : '<%= chatroomId %>',
			sender : '<%= memberId %>',
			msg : e.target.msg.value
		},
		time : Date.now()
	};
	
	ws.send(JSON.stringify(payload));
	
	e.target.msg.value = "";
	e.target.msg.focus();
});

ws.addEventListener("message", (e) => {
	const {messageType, data : {sender, chatroomId, msg}, time}=  JSON.parse(e.data);
	console.log(messageType, sender, chatroomId, msg, time);
	
	const ul = document.querySelector("#chat-container ul");
	let html;
	switch(messageType){
	case "CHAT_ENTER": 
		html = `<li class="line">\${sender} 님이 입장했습니다.</li>`;
		break;
	case "CHAT_MSG": 		
		html = `
		<li class="left">
			<span class="badge">\${sender}</span>
			\${msg}
		</li>`;
		break;
	case "CHAT_LEAVE": 
		html = `<li class="line">\${sender} 님이 퇴장했습니다.</li>`;
		break;
	}
	ul.insertAdjacentHTML('beforeend', html);
	
	
});
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>  
