package com.sgu.cakeshopserive.servlet;

import com.sgu.cakeshopserive.common.Result;
import com.sgu.cakeshopserive.model.Type;
import com.sgu.cakeshopserive.service.TypeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * 分类控制器
 * 职责：处理分类相关的HTTP请求
 */
@WebServlet(name = "TypeServlet", urlPatterns = {"/type"})
public class TypeServlet extends HttpServlet {
    private TypeService typeService = new TypeService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listTypes(request, response);
                    break;
                case "ajax":
                    getTypesAjax(request, response);
                    break;
                default:
                    listTypes(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendErrorResponse(response, "获取分类信息失败：" + e.getMessage());
        }
    }

    /**
     * 获取所有分类列表（AJAX接口）
     */
    private void getTypesAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Result<List<Type>> result = typeService.getAllTypes();

        PrintWriter out = response.getWriter();
        out.print(result.toJson());
        out.flush();
    }

    /**
     * 获取所有分类列表
     */
    private void listTypes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Result<List<Type>> result = typeService.getAllTypes();

        PrintWriter out = response.getWriter();
        out.print(result.toJson());
        out.flush();
    }

    /**
     * 发送错误响应
     */
    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        PrintWriter out = response.getWriter();
        out.print("{\"success\": false, \"message\": \"" + message + "\"}");
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}