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
        } else if (data instanceof java.util.List) {
            // 处理List类型的序列化
            json.append(",\"data\":");
            json.append(listToJson((java.util.List<?>) data));
        } else if (data != null) {
            json.append(",\"data\":");
            json.append(objectToJson(data));
        } else {
            json.append(",\"data\":null");
        }

        json.append(",\"code\":\"").append(escapeJson(code)).append("\"");
        json.append("}");
        return json.toString();
    }

    /**
     * List转JSON
     */
    private String listToJson(java.util.List<?> list) {
        StringBuilder json = new StringBuilder();
        json.append("[");

        for (int i = 0; i < list.size(); i++) {
            if (i > 0) json.append(",");
            json.append(objectToJson(list.get(i)));
        }

        json.append("]");
        return json.toString();
    }

    /**
     * 对象转JSON
     */
    private String objectToJson(Object obj) {
        try {
            // 检查是否是Type对象，进行特殊处理
            if (obj.getClass().getName().contains("Type")) {
                return typeToJson(obj);
            }

            // 尝试通过反射获取对象属性
            StringBuilder json = new StringBuilder();
            json.append("{");

            java.lang.reflect.Field[] fields = obj.getClass().getDeclaredFields();
            boolean first = true;

            for (java.lang.reflect.Field field : fields) {
                field.setAccessible(true);
                Object value = field.get(obj);

                if (!first) {
                    json.append(",");
                }
                first = false;

                json.append("\"").append(field.getName()).append("\":");

                if (value == null) {
                    json.append("null");
                } else if (value instanceof String) {
                    json.append("\"").append(escapeJson((String) value)).append("\"");
                } else if (value instanceof Number || value instanceof Boolean) {
                    json.append(value);
                } else if (value instanceof java.sql.Timestamp || value instanceof java.sql.Date || value instanceof java.util.Date) {
                    // 处理日期时间类型
                    json.append("\"").append(value.toString()).append("\"");
                } else {
                    // 对于其他对象类型，转换为字符串
                    json.append("\"").append(escapeJson(value.toString())).append("\"");
                }
            }

            json.append("}");
            return json.toString();
        } catch (Exception e) {
            // 如果反射失败，使用toString
            return "\"" + escapeJson(obj.toString()) + "\"";
        }
    }

    /**
     * Type对象转JSON（专门处理）
     */
    private String typeToJson(Object typeObj) {
        try {
            StringBuilder json = new StringBuilder();
            json.append("{");

            // 手动处理Type对象的已知字段
            try {
                java.lang.reflect.Field typeIdField = typeObj.getClass().getDeclaredField("typeId");
                java.lang.reflect.Field typeNameField = typeObj.getClass().getDeclaredField("typeName");

                typeIdField.setAccessible(true);
                typeNameField.setAccessible(true);

                int typeId = typeIdField.getInt(typeObj);
                String typeName = (String) typeNameField.get(typeObj);

                json.append("\"typeId\":").append(typeId);
                json.append(",\"typeName\":\"").append(escapeJson(typeName)).append("\"");

            } catch (NoSuchFieldException e) {
                // 如果字段不存在，使用反射通用方法
                java.lang.reflect.Field[] fields = typeObj.getClass().getDeclaredFields();
                boolean first = true;
                for (java.lang.reflect.Field field : fields) {
                    field.setAccessible(true);
                    Object value = field.get(typeObj);

                    if (!first) {
                        json.append(",");
                    }
                    first = false;

                    json.append("\"").append(field.getName()).append("\":");

                    if (value == null) {
                        json.append("null");
                    } else if (value instanceof String) {
                        json.append("\"").append(escapeJson((String) value)).append("\"");
                    } else {
                        json.append(value);
                    }
                }
            }

            json.append("}");
            return json.toString();
        } catch (Exception e) {
            // 如果所有方法都失败，返回简单的JSON
            return "{\"typeId\":0,\"typeName\":\"未知分类\"}";
        }
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