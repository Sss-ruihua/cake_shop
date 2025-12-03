package com.sgu.cakeshopserive.common;

/**
 * 统一响应结果类
 */
public class Result<T> {
    private boolean success;
    private String message;
    private T data;
    private String code;

    public Result() {}

    public Result(boolean success, String message, T data, String code) {
        this.success = success;
        this.message = message;
        this.data = data;
        this.code = code;
    }

    public static <T> Result<T> success(T data) {
        return new Result<>(true, "操作成功", data, "SUCCESS");
    }

    public static <T> Result<T> success(String message, T data) {
        return new Result<>(true, message, data, "SUCCESS");
    }

    public static <T> Result<T> success(String message, T data, String code) {
        return new Result<>(true, message, data, code);
    }

    public static <T> Result<T> error(String message) {
        return new Result<>(false, message, null, "ERROR");
    }

    public static <T> Result<T> error(String message, String code) {
        return new Result<>(false, message, null, code);
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Override
    public String toString() {
        return "Result{" +
                "success=" + success +
                ", message='" + message + '\'' +
                ", data=" + data +
                ", code='" + code + '\'' +
                '}';
    }

    /**
     * 转换为JSON字符串
     */
    public String toJson() {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\":").append(success);
        json.append(",\"message\":\"").append(escapeJson(message)).append("\"");

        if (data instanceof String) {
            json.append(",\"data\":\"").append(escapeJson((String) data)).append("\"");
        } else if (data != null) {
            json.append(",\"data\":").append(escapeJson(data.toString()));
        } else {
            json.append(",\"data\":null");
        }

        json.append(",\"code\":\"").append(escapeJson(code)).append("\"");
        json.append("}");
        return json.toString();
    }

    /**
     * JSON字符串转义
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}