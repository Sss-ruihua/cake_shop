# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

环创店是一个基于Java Servlet的完整B2C蛋糕店Web应用，实现了用户管理、商品展示、购物车和订单管理等功能。

## 技术架构

- **后端框架**: Java Servlet 4.0.1, JSP, JSTL
- **数据库**: MySQL 8.0 (cake_shop数据库)
- **连接池**: C3P0 (v0.9.5.5)
- **构建工具**: Maven 3.x
- **Java版本**: JDK 1.8
- **容器**: Apache Tomcat 8.5+
- **前端技术**: HTML5, CSS3, JavaScript, Bootstrap响应式设计

## 核心功能模块

### 1. 用户系统
- **用户注册**: 用户信息验证、用户名/邮箱唯一性检查、密码加密存储
- **用户登录**: 会话管理、密码验证、登录状态保持
- **用户注销**: 会话清理
- **权限管理**: 普通用户/管理员权限区分

### 2. 商品系统
- **商品展示**: 支持列表展示、分类浏览、搜索功能
- **商品分类**: 多级分类管理
- **推荐系统**: 热销推荐、新品推荐、Banner推荐
- **商品详情**: 详细信息展示、图片显示

### 3. 购物车系统
- **商品添加**: 商品加入购物车、数量管理
- **购物车管理**: 商品数量修改、商品删除
- **价格计算**: 实时计算总价

## 项目结构详情

```
src/
├── main/
│   ├── java/com/sgu/cakeshopserive/
│   │   ├── servlet/                    # 控制器层
│   │   │   ├── LoginServlet.java      # 登录处理
│   │   │   ├── RegisterServlet.java   # 注册处理
│   │   │   ├── LogoutServlet.java     # 注销处理
│   │   │   ├── GoodsServlet.java      # 商品管理
│   │   │   └── CartServlet.java       # 购物车管理
│   │   ├── dao/                       # 数据访问层
│   │   │   ├── GoodsDao.java          # 商品数据访问
│   │   │   └── TypeDao.java           # 分类数据访问
│   │   ├── model/                     # 数据模型层
│   │   │   ├── Goods.java             # 商品实体
│   │   │   └── Type.java              # 分类实体
│   │   ├── filter/                    # 过滤器
│   │   │   ├── EncodeFilter.java      # 编码过滤器
│   │   │   └── IndexFilter.java       # 首页数据加载过滤器
│   │   └── utils/                     # 工具类
│   │       ├── DBUtils.java           # 数据库连接池
│   │       ├── PasswordUtil.java      # 密码加密工具
│   │       └── PriceUtil.java         # 价格处理工具
│   └── webapp/                        # Web资源目录
│       ├── WEB-INF/
│       │   └── web.xml               # Web应用部署描述符
│       ├── css/
│       │   └── style.css             # 全局样式表
│       ├── images/                    # 图片资源目录
│       ├── index.jsp                  # 首页
│       ├── login.jsp                  # 登录页面
│       ├── register.jsp               # 注册页面
│       ├── hello.jsp                  # 测试页面
│       └── error.jsp                  # 错误页面
└── test/                             # 测试代码目录
```

## 核心依赖 (pom.xml)

- **Servlet API**: 4.0.1 (provided scope)
- **MySQL Connector**: 8.0.33
- **C3P0连接池**: 0.9.5.5
- **JUnit 5**: 5.10.2 (测试框架)

## 数据库设计

### 核心表结构
- **user**: 用户表 (user_id, username, password, email, phone, address, is_admin, is_active, create_time)
- **goods**: 商品表 (goods_id, goods_name, cover_image, detail_image, price, description, stock, type_id, create_time, update_time)
- **type**: 分类表 (type_id, type_name, parent_id, sort_order, create_time)
- **recommend**: 推荐表 (recommend_id, goods_id, recommend_type, sort_order, create_time)

### 数据库连接配置
- **URL**: `jdbc:mysql://localhost:3306/cake_shop?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8`
- **用户名**: `root`
- **密码**: `root`
- **连接池配置**: 最小5个连接，最大20个连接，超时300秒

## 安全特性

1. **密码安全**: 使用MD5哈希算法加密存储
2. **输入验证**: 前后端双重验证，防止XSS和SQL注入
3. **会话管理**: 30分钟自动超时，安全退出
4. **编码处理**: 统一UTF-8编码，防止中文乱码

## 部署和运行

### 开发环境部署
```bash
# 1. 编译项目
mvn clean compile

# 2. 打包成WAR
mvn clean package

# 3. 部署到Tomcat
# 将target/CakeShopSerive-1.0-SNAPSHOT.war复制到Tomcat的webapps目录

# 4. 启动Tomcat
# 访问: http://localhost:8080/CakeShopSerive-1.0-SNAPSHOT/
```

### IDE配置
- **Tomcat配置**: 使用Tomcat 8.5+
- **部署配置**: 配置WAR包自动部署
- **数据库**: 确保MySQL服务运行，创建cake_shop数据库

## 开发规范

### 代码规范
1. **包命名**: `com.sgu.cakeshopserive.{module}`
2. **类命名**: 驼峰命名法，Servlet以Servlet结尾
3. **数据库表**: 小写+下划线命名
4. **JSP文件**: 小写+中划线或驼峰命名

### 编码规范
1. **字符编码**: 全项目UTF-8编码
2. **数据库字符集**: utf8mb4
3. **连接字符集**: useUnicode=true&characterEncoding=utf-8

### 安全开发规范
1. **SQL操作**: 使用PreparedStatement防止SQL注入
2. **用户输入**: 必须进行合法性验证
3. **密码处理**: 加密存储，不存储明文密码
4. **会话管理**: 合理设置超时时间

## 调试和测试

### 调试配置
- **IDE**: 支持断点调试
- **日志**: 使用控制台输出和文件日志
- **浏览器**: Chrome开发者工具

### 测试
- **单元测试**: JUnit 5
- **集成测试**: Servlet容器内测试
- **浏览器测试**: 支持Chrome、Firefox、Edge

## 常见问题解决

### 1. JSP页面访问问题
- **问题**: 除hello.jsp外其他JSP无法访问
- **解决**: 检查web.xml过滤器配置，确保IndexFilter只拦截必要的路径

### 2. 中文乱码问题
- **解决**: 检查EncodeFilter配置和数据库连接字符集设置

### 3. 数据库连接问题
- **解决**: 确认MySQL服务状态、连接参数和网络连接

### 4. 部署问题
- **解决**: 检查WAR包结构、Tomcat版本兼容性和内存配置

## 扩展开发指南

### 添加新功能
1. 创建对应的Servlet控制器
2. 实现DAO层数据访问
3. 创建Model实体类
4. 编写JSP视图页面
5. 配置web.xml路由映射

### 数据库表扩展
1. 创建数据库表和索引
2. 更新对应的Model类
3. 实现DAO层CRUD操作
4. 编写业务逻辑和控制器

### 前端样式扩展
1. 在css/style.css中添加新样式
2. 遵循现有的设计规范和响应式布局
3. 使用现有的CSS类和变量