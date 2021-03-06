<%--
   APDPlat - Application Product Development Platform
   Copyright (c) 2013, 杨尚川, yang-shangchuan@qq.com
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>    
<%@page import="org.apdplat.qa.datasource.BaiduDataSource"%>
<%@page import="org.apdplat.qa.model.Question"%>
<%@page import="org.apdplat.qa.model.Evidence"%>
<%@page import="org.apdplat.qa.model.CandidateAnswer"%>
<%@page import="org.apdplat.qa.model.QuestionType"%>
<%@page import="org.apdplat.qa.system.CommonQuestionAnsweringSystem"%>
<%@page import="org.apdplat.qa.system.QuestionAnsweringSystem"%>
<%@page import="java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    QuestionAnsweringSystem questionAnsweringSystem = (QuestionAnsweringSystem) session.getAttribute("questionAnsweringSystem");
    if (questionAnsweringSystem == null) {
        questionAnsweringSystem = new CommonQuestionAnsweringSystem();
        session.setAttribute("questionAnsweringSystem", questionAnsweringSystem);
    }
    String questionStr = request.getParameter("questionStr");
    Question question = null;
    List<CandidateAnswer> candidateAnswers = null;
    if (questionStr != null && questionStr.trim().length() > 3) {
        questionStr = new String(questionStr.getBytes("ISO8859-1"), "UTF-8");
        question = new BaiduDataSource().getQuestion(questionStr);
        question = questionAnsweringSystem.answerQuestion(question);
        if (question != null) {
            candidateAnswers = question.getAllCandidateAnswer();
        }
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>人机问答系统演示</title>
    </head>
    <body>
        <h1><font color="blue">人机问答系统演示</font></h1>
                <%
                    if (questionStr == null || questionStr.trim().length() <= 3) {
                %>      
        <font color="red">请输入问题且长度大于3</font>
            <%
            } else if (candidateAnswers == null || candidateAnswers.size() == 0) {
            %>
        <font color="red">回答问题失败：<%=questionStr%></font><br/>
            <%
                }
                if (question != null) {
            %>
        <font color="red">Question : <%=question.getQuestion()%></font><br/><br/>
            <%
                int j = 1;
                for (Evidence evidence : question.getEvidences()) {
            %>
        <font color="red"> Title <%=j%> : </font> <%=evidence.getTitle()%><br/>
        <font color="red"> Snippet <%=j%> : </font> <%=evidence.getSnippet()%><br/>
            <%
                    j++;
                }
                if (candidateAnswers != null && candidateAnswers.size() > 0) {
            %>      
        <p><font color="red">答案：</font></p>
        <table>
            <tr><th>序号</th><th>候选答案</th><th>答案评分</th></tr>
                    <%
                        int i = 0;
                        for (CandidateAnswer candidateAnswer : candidateAnswers) {
                            if ((++i) == 1) {
                    %>			
            <tr><td><font color="red"><%=i%></font></td><td><font color="red"><%=candidateAnswer.getAnswer()%></font></td><td><font color="red"><%=candidateAnswer.getScore()%></font></td></tr>
                        <%
                        } else {
                        %>
            <tr><td><%=i%></td><td><%=candidateAnswer.getAnswer()%></td><td><%=candidateAnswer.getScore()%></td></tr>
            <%
                    }
                }
            %>        
        </table>
        <%
            }
        %>
        <h1><a href="<%=request.getContextPath()%>/view.jsp">返回</a></h1>
        <%
        } else {
        %>
        <p>
            <b>可以像如下提问：</b><br/>
            1、APDPlat的作者是谁？<br/>
            2、APDPlat的发起人是谁？<br/>
            3、谁死后布了七十二疑冢？<br/>
            4、习近平最爱的女人是谁？<br/>
            5、BMW是哪个汽车公司制造的？<br/>
            6、长城信用卡是哪家银行发行的？<br/>
            7、美国历史上第一所高等学府是哪个学校？<br/>
            8、前身是红色中华通讯社的是什么？<br/>
            9、“海的女儿”是哪个城市的城徽？<br/>
            10、世界上流经国家最多的河流是哪一条？<br/>
            11、世界上最长的河流是什么？<br/>
            12、汉城是哪个国家的首都？<br/>
            13、全球表面积有多少平方公里？
        </p>
        <form action="view.jsp" method="post">
            <font color="red">输入问题：</font><input name="questionStr" size="150" maxlength="150">
            <p></p>
            <input type="submit" value="查看证据及答案"/>
        </form>
        <%
            }
        %>
        <br/>
        <h1><a href="index.jsp">简要信息</a></h1>
    </body>
</html>