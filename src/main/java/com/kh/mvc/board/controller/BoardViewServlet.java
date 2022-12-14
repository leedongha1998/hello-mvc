package com.kh.mvc.board.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kh.mvc.board.model.dto.Board;
import com.kh.mvc.board.model.dto.BoardComment;
import com.kh.mvc.board.model.service.BoardService;
import com.kh.mvc.common.HelloMvcUtils;

/**
 * Servlet implementation class BoardViewServlet
 */
@WebServlet("/board/boardView")
public class BoardViewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private BoardService boardService = new BoardService();
	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {		
		try {
			// 1. 사용자입력값 처리
			int no = Integer.parseInt(request.getParameter("no"));

			// 읽음여부판단
			Cookie[] cookies = request.getCookies();
			String boardCookieVal = "";
			boolean hasRead = false;
			
			if(cookies != null) {
				for(Cookie c : cookies) {
					String name = c.getName();
					String value = c.getValue();
					if("boardCookie".equals(name)) {
						boardCookieVal = value;
						if(value.contains("[" + no + "]")) {
							hasRead = true;
						}
						break;
					}
				}
			}
			
			// 쿠키처리
			if(!hasRead) {
				Cookie cookie = new Cookie("boardCookie", boardCookieVal + "[" + no + "]");
				cookie.setPath(request.getContextPath() + "/board/boardView");
				cookie.setMaxAge(365 * 24 * 60 * 60);
				response.addCookie(cookie);
				System.out.println("[boardCookie 새로 발급되었음 : " + cookie.getValue() + "]");
			}
			
			
			
			// 2. 업무로직
			// 게시글조회 및 조회수 증가처리
			Board board = hasRead ?
							boardService.findByNo(no) : 
								boardService.findByNo(no, hasRead);
			List<BoardComment> commentList = boardService.findBoardCommentByBoardNo(no);
								
			System.out.println("board = " + board);
			System.out.println("commentList = " + commentList);
			
			// XSS공격대비 (Cross-site Scripting)
			board.setTitle(HelloMvcUtils.escapeXml(board.getTitle()));
			board.setContent(HelloMvcUtils.escapeXml(board.getContent()));
			
			// 개행문자 변환처리
			board.setContent(HelloMvcUtils.convertLineFeedToBr(board.getContent()));
			
			
			// 3. view단 처리
			request.setAttribute("board", board);
			request.setAttribute("commentList", commentList);
			request.getRequestDispatcher("/WEB-INF/views/board/boardView.jsp")
				.forward(request, response);
		}
		catch(Exception e) {
			e.printStackTrace();
			throw e;
		}
	
	}

}





