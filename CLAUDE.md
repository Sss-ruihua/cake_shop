# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

环创店是一个基于Java Servlet的完整B2C蛋糕店Web应用，实现了用户管理、商品展示、购物车和订单管理等功能。项目采用MVC架构模式，使用经典三层结构（表现层、业务逻辑层、数据访问层）。

## 技术架构

- **后端框架**: Java Servlet 3.1.0, JSP, JSTL
- **数据库**: MySQL 8.0 (cake_shop数据库)
- **连接池**: C3P0 (v0.9.5.5) 优化配置
- **构建工具**: Maven 3.x
- **Java版本**: JDK 1.8
- **容器**: Apache Tomcat 8.5+
- **前端技术**: HTML5, CSS3, JavaScript, 模块化CSS架构
- **设计模式**: MVC, DAO, Service层

## 核心功能模块

### 1. 用户系统
- **用户注册**: 用户信息验证、用户名/邮箱唯一性检查、密码MD5加密存储
- **用户登录**: 会话管理、密码验证、登录状态保持
- **用户注销**: 会话清理
- **权限管理**: 普通用户/管理员权限区分
- **用户信息**: 支持个人信息更新和查看

### 2. 商品系统
- **商品展示**: 支持列表展示、分类浏览、搜索功能
- **商品分类**: 多级分类管理，支持父子分类
- **推荐系统**: 热销推荐、新品推荐、Banner推荐
- **商品详情**: 详细信息展示、图片显示
- **库存管理**: 实时库存更新和检查

### 3. 购物车系统
- **商品添加**: 商品加入购物车、数量管理，支持AJAX无刷新操作
- **购物车管理**: 商品数量修改、商品删除、清空购物车
- **价格计算**: 实时计算总价，包含商品金额和配送费
- **会话存储**: 基于Session的购物车数据管理
- **用户体验**: 响应式设计，支持移动端和桌面端
- **主要页面**:
  - `/cart` - 购物车主页面
  - `/checkout.jsp` - 订单结算页面
  - `/order-success.jsp` - 订单成功页面

### 4. 订单系统
- **订单创建**: 支持多种支付方式，配送费计算
- **订单管理**: 订单状态跟踪、取消订单功能
- **库存扣减**: 下单时自动减少库存
- **订单查询**: 用户订单列表和详情查询

### 5. 通用组件
- **统一返回**: Result封装类统一API响应格式
- **常量管理**: Constants类集中管理系统常量
- **编码过滤**: EncodeFilter解决中文乱码问题

## 项目结构详情

```
src/
├── main/
│   ├── java/com/sgu/cakeshopserive/
│   │   ├── servlet/                    # 控制器层 - 处理HTTP请求
│   │   │   ├── LoginServlet.java      # 用户登录处理
│   │   │   ├── RegisterServlet.java   # 用户注册处理
│   │   │   ├── LogoutServlet.java     # 用户注销处理
│   │   │   ├── GoodsServlet.java      # 商品管理和详情页
│   │   │   ├── CartServlet.java       # 购物车操作
│   │   │   ├── OrderServlet.java      # 订单管理
│   │   │   └── TypeServlet.java       # 商品分类处理
│   │   ├── service/                    # 业务逻辑层
│   │   │   ├── UserService.java       # 用户业务逻辑
│   │   │   ├── GoodsService.java      # 商品业务逻辑
│   │   │   ├── CartService.java       # 购物车业务逻辑
│   │   │   ├── OrderService.java      # 订单业务逻辑
│   │   │   └── TypeService.java       # 分类业务逻辑
│   │   ├── dao/                        # 数据访问层
│   │   │   ├── GoodsDao.java          # 商品数据访问对象
│   │   │   └── TypeDao.java           # 分类数据访问对象
│   │   ├── model/                      # 数据模型层
│   │   │   ├── User.java              # 用户实体类
│   │   │   ├── Goods.java             # 商品实体类
│   │   │   ├── Type.java              # 分类实体类
│   │   │   ├── Order.java             # 订单实体类
│   │   │   └── OrderItem.java         # 订单项实体类
│   │   ├── common/                     # 通用组件
│   │   │   ├── Constants.java         # 系统常量定义
│   │   │   └── Result.java            # 统一响应结果封装
│   │   ├── filter/                     # 过滤器
│   │   │   ├── EncodeFilter.java      # 编码过滤器(全局UTF-8)
│   │   │   └── IndexFilter.java       # 首页数据加载过滤器
│   │   └── utils/                      # 工具类
│   │       ├── DBUtils.java           # 数据库连接池管理
│   │       ├── PasswordUtil.java      # 密码MD5加密工具
│   │       └── PriceUtil.java         # 价格处理工具
│   └── webapp/                         # Web资源目录
│       ├── WEB-INF/
│       │   └── web.xml               # Web应用部署描述符
│       ├── css/                        # 样式文件目录(模块化)
│       │   ├── main.css               # 主样式入口文件
│       │   ├── base.css               # 基础样式
│       │   ├── layout.css             # 布局样式
│       │   ├── header.css             # 头部样式
│       │   ├── components.css         # 组件样式
│       │   ├── footer.css             # 底部样式
│       │   └── pages/                 # 页面专用样式
│       │       ├── index.css          # 首页样式
│       │       ├── auth.css           # 认证页面样式
│       │       ├── goods.css          # 商品页面样式
│       │       └── cart.css           # 购物车样式
│       ├── images/                     # 图片资源目录
│       ├── index.jsp                   # 首页
│       ├── login.jsp                   # 登录页面
│       ├── register.jsp                # 注册页面
│       ├── goods-detail.jsp            # 商品详情页
│       ├── cart.jsp                    # 购物车页面
│       ├── checkout.jsp                # 结算页面
│       ├── order-success.jsp           # 订单成功页面
│       └── error.jsp                   # 错误页面
├── test/                               # 测试代码目录
└── reference_document/                  # 参考文档目录
    ├── cake_shop.sql                  # 数据库结构和完整数据SQL
    ├── test_data.sql                  # 测试数据SQL
    └── test_categories.sql            # 商品分类测试数据
```

### 项目包结构特点
1. **清晰的分层架构**：严格遵循MVC设计模式，职责分明
2. **模块化设计**：按功能模块（用户、商品、订单、分类）组织代码
3. **完整的工具支持**：utils包提供数据库连接、密码加密、价格处理等工具类
4. **安全机制**：filter包实现编码处理和首页数据预加载
5. **统一响应格式**：common包的Result类提供统一的API响应格式
6. **测试支持**：完整的测试包结构，支持单元测试

## 核心依赖 (pom.xml)

- **Servlet API**: 3.1.0 (provided scope)
- **MySQL Connector**: 8.0.33
- **C3P0连接池**: 0.9.5.5
- **JUnit 5**: 5.10.2 (测试框架)

## 数据库设计

### 完整表结构
- **user**: 用户表 (user_id, username, password, real_name, email, phone, address, is_admin, is_active, create_time)
- **goods**: 商品表 (goods_id, goods_name, cover_image, detail_image, price, description, stock, type_id, create_time, update_time)
- **type**: 分类表 (type_id, type_name, parent_id, sort_order, create_time)
- **recommend**: 推荐表 (recommend_id, goods_id, recommend_type[ banner/hot/new ], sort_order, create_time)
- **order_table**: 订单表 (order_id, total_amount, total_quantity, payment_status, payment_method, shipping_info, order_time, user_id)
- **orderitem**: 订单项表 (orderitem_id, goods_price, quantity, goods_id, order_id)

### 数据库连接配置
- **URL**: `jdbc:mysql://localhost:3306/cake_shop?serverTimezone=UTC&useUnicode=true&characterEncoding=utf-8&autoReconnect=true&useSSL=false`
- **用户名**: `root`
- **密码**: `root`
- **优化连接池配置**:
  - 初始连接数: 3, 最小连接数: 3, 最大连接数: 10
  - 连接超时: 30秒, 最大空闲时间: 3分钟
  - 连接泄露检测: 5分钟超时
  - 支持连接池监控和调试

## 发现的问题与优化建议

### 1. 安全性问题
- **密码加密**: 当前使用MD5加密，建议升级到BCrypt或PBKDF2等更安全的哈希算法
- **会话管理**: 建议实现会话固定保护和CSRF防护
- **输入验证**: 需要更严格的XSS防护和SQL注入防护
- **敏感信息**: 数据库密码硬编码在代码中，建议使用配置文件或环境变量

### 2. 架构优化
- **依赖注入**: 缺少依赖注入框架，手动管理对象依赖关系
- **事务管理**: 缺少声明式事务管理，容易出现数据不一致
- **异常处理**: 异常处理机制不够完善，缺少统一的异常处理策略
- **日志系统**: 缺少完善的日志记录系统，只有简单的控制台输出

### 3. 性能优化
- **连接池配置**: C3P0连接池配置已优化，但可考虑使用HikariCP等性能更好的连接池
- **缓存机制**: 缺少缓存层，频繁查询数据库影响性能
- **分页查询**: 商品列表缺少分页功能，大数据量时性能较差
- **图片管理**: 缺少图片压缩和CDN支持

### 4. 代码质量
- **重复代码**: Service层和DAO层存在较多重复的异常处理代码
- **硬编码**: 存在魔法数字和硬编码字符串
- **注释规范**: 部分代码缺少必要的注释和文档
- **单元测试**: 缺少完整的单元测试覆盖

### 5. 配置管理
- **JSTL依赖**: pom.xml中JSTL依赖被注释掉，但JSP页面中可能在使用
- **Servlet版本**: pom.xml中Servlet版本为3.1.0，但web.xml配置为3.1
- **编码配置**: 虽然有编码过滤器，但建议在web.xml中统一配置字符编码

### 6. 前端优化
- **CSS架构**: 已采用模块化CSS架构，这是很好的实践
- **JavaScript**: 缺少JavaScript模块化，建议采用现代前端框架
- **响应式设计**: 需要完善移动端适配
- **AJAX交互**: 可以增加更多AJAX交互提升用户体验

## 已实现的优化特性

### 1. 架构改进
- **MVC分层**: 实现了清晰的MVC三层架构
- **Service层**: 引入业务逻辑层，分离业务和数据访问
- **统一返回**: Result封装类提供统一的API响应格式
- **常量管理**: Constants类集中管理系统常量和配置

### 2. 数据库优化
- **连接池优化**: C3P0连接池配置经过调优，支持连接泄露检测
- **SQL优化**: 使用PreparedStatement防止SQL注入
- **外键约束**: 完善的数据库外键约束保证数据完整性
- **索引设计**: 为关键字段建立索引提升查询性能

### 3. 代码质量提升
- **异常处理**: 在Service层实现统一的异常处理和错误返回
- **参数验证**: 完善的输入参数验证和格式检查
- **资源管理**: 使用try-with-resources确保数据库连接正确关闭
- **编码规范**: 统一的UTF-8编码处理

### 4. 前端优化
- **模块化CSS**: 采用CSS模块化架构，便于维护和扩展
- **响应式设计**: 基本的响应式布局支持
- **AJAX支持**: 购物车等功能采用AJAX提升用户体验
- **用户体验**: 添加加载状态提示和用户友好的错误提示

## 安全特性

### 当前实现
1. **密码安全**: 使用MD5哈希算法加密存储(建议升级)
2. **输入验证**: 前后端双重验证，防止XSS和SQL注入
3. **会话管理**: 30分钟自动超时，安全退出
4. **编码处理**: 统一UTF-8编码，防止中文乱码
5. **SQL注入防护**: 全程使用PreparedStatement
6. **权限控制**: 基于Session的用户认证和权限检查

### 建议改进
1. **密码加密**: 升级到BCrypt或PBKDF2
2. **CSRF防护**: 实现CSRF令牌验证
3. **会话安全**: 实现会话固定保护
4. **配置安全**: 使用配置文件管理敏感信息

## 开发规范

### 代码规范
1. **包命名**: `com.sgu.cakeshopserive.{module}`
2. **类命名**: 驼峰命名法，Servlet以Servlet结尾，Service以Service结尾
3. **数据库表**: 小写+下划线命名
4. **JSP文件**: 小写+中划线或驼峰命名
5. **常量定义**: 使用Constants类集中管理

### 编码规范
1. **字符编码**: 全项目UTF-8编码
2. **数据库字符集**: utf8mb4
3. **连接字符集**: useUnicode=true&characterEncoding=utf-8
4. **代码风格**: 遵循Java标准编码规范

### 安全开发规范
1. **SQL操作**: 使用PreparedStatement防止SQL注入
2. **用户输入**: 必须进行合法性验证和XSS防护
3. **密码处理**: 加密存储，不存储明文密码
4. **会话管理**: 合理设置超时时间，实现安全退出
5. **资源管理**: 使用try-with-resources确保资源正确关闭

## 调试和测试

### 调试配置
- **IDE**: 支持断点调试和热部署
- **日志**: 使用控制台输出，建议集成Log4j或SLF4J
- **浏览器**: Chrome开发者工具进行前端调试
- **数据库**: 使用MySQL Workbench或类似工具

### 测试
- **单元测试**: JUnit 5 (已配置)
- **集成测试**: Servlet容器内测试
- **浏览器测试**: 支持Chrome、Firefox、Edge等主流浏览器
- **压力测试**: 建议进行并发用户测试

## 常见问题解决

### 1. JSP页面访问问题
- **问题**: 除特定页面外其他JSP无法访问
- **解决**: 检查web.xml过滤器配置，确保过滤器只拦截必要的路径

### 2. 中文乱码问题
- **解决**: 检查EncodeFilter配置和数据库连接字符集设置，确保全链路UTF-8

### 3. 数据库连接问题
- **解决**: 确认MySQL服务状态、连接参数、防火墙设置和网络连接

### 4. 部署问题
- **解决**: 检查WAR包结构、Tomcat版本兼容性、内存配置和依赖冲突

### 5. 购物车数据丢失
- **解决**: 确保Session配置正确，检查Session超时设置

## 扩展开发指南

### 添加新功能模块
1. 创建对应的Model实体类
2. 实现DAO层数据访问
3. 编写Service业务逻辑
4. 创建Servlet控制器
5. 编写JSP视图页面
6. 配置路由映射(如需要)

### 数据库表扩展
1. 设计数据库表结构和索引
2. 编写创建表的SQL脚本
3. 更新对应的Model实体类
4. 实现DAO层CRUD操作
5. 编写Service业务逻辑
6. 添加单元测试

### 前端样式扩展
1. 在css/pages/目录下创建页面专用CSS
2. 遵循现有的模块化CSS架构
3. 使用响应式设计规范
4. 保持与现有设计风格一致

### 性能优化建议
1. **数据库优化**: 添加适当索引，优化查询语句
2. **缓存机制**: 考虑引入Redis等缓存层
3. **连接池优化**: 根据实际负载调整连接池参数
4. **前端优化**: 压缩CSS/JS，使用CDN加速

## 主要功能流程

### 购物车流程
1. **添加商品**: 用户在商品详情页点击"加入购物车" → AJAX请求到`/cart?action=add&goodsId=1`
2. **购物车管理**: 访问`/cart`查看购物车 → 支持数量修改、删除商品、清空购物车
3. **结算流程**: 点击"去结算" → 跳转到`/checkout.jsp` → 填写收货信息选择支付方式
4. **订单完成**: 提交订单 → 创建订单记录 → 跳转到`/order-success.jsp`显示订单信息

### 商品分类功能
1. **分类数据加载**: 页面加载时自动AJAX请求`/type?action=ajax`获取分类列表
2. **分类展示**: 导航栏"商品分类"下拉菜单动态显示所有分类
3. **分类浏览**: 点击分类跳转到`/goods?action=type&typeId=X`显示该分类商品

## 版本历史

- **v1.0**: 基础功能实现，包括用户管理、商品展示、购物车
- **v1.1**: 添加订单管理系统
- **v1.2**: 优化CSS架构，实现模块化样式
- **v1.3**: 完善异常处理和参数验证
- **v1.4**: 优化数据库连接池配置
- **v1.5**: 完善商品分类功能，修复导航栏分类显示问题

## 贡献指南

1. 遵循现有的代码规范和架构模式
2. 为新功能编写相应的单元测试
3. 更新相关文档和注释
4. 提交前进行代码审查和测试
5. 确保向后兼容性