/*
 Navicat Premium Data Transfer

 Source Server         : MyComputer
 Source Server Type    : MySQL
 Source Server Version : 50736 (5.7.36)
 Source Host           : localhost:3306
 Source Schema         : cake_shop

 Target Server Type    : MySQL
 Target Server Version : 50736 (5.7.36)
 File Encoding         : 65001

 Date: 04/12/2025 08:36:37
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `goods_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `goods_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商品名称',
  `cover_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '封面图片路径',
  `detail_image` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '详情图片路径(JSON格式存储多张图片)',
  `price` decimal(10, 2) NOT NULL COMMENT '商品价格',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '商品描述',
  `stock` int(11) NULL DEFAULT 0 COMMENT '库存数量',
  `type_id` int(11) NULL DEFAULT NULL COMMENT '分类ID',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`goods_id`) USING BTREE,
  INDEX `idx_type_id`(`type_id`) USING BTREE,
  INDEX `idx_goods_name`(`goods_name`) USING BTREE,
  CONSTRAINT `goods_ibfk_1` FOREIGN KEY (`type_id`) REFERENCES `type` (`type_id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, '彩色马卡龙', 'images/macaron1.jpg', '[\"images/macaron1-1.jpg\", \"images/macaron1-2.jpg\"]', 38.00, '经典的法式马卡龙，多种口味，色彩缤纷，口感层次丰富', 50, 1, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (2, '彩虹马卡龙塔', 'images/macaron2.jpg', '[\"images/macaron2-1.jpg\", \"images/macaron2-2.jpg\"]', 128.00, '多层次马卡龙塔，适合生日聚会和庆典，视觉震撼', 20, 1, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (3, '精选马卡龙礼盒', 'images/macaron3.jpg', '[\"images/macaron3-1.jpg\", \"images/macaron3-2.jpg\"]', 88.00, '包含巧克力、草莓、香草等经典口味，包装精美', 30, 1, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (4, '巧克力慕斯蛋糕', 'images/mousse1.jpg', '[\"images/mousse1-1.jpg\", \"images/mousse1-2.jpg\"]', 68.00, '浓郁巧克力慕斯，搭配新鲜浆果，口感丝滑，巧克力爱好者的首选', 25, 2, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (5, '草莓慕斯蛋糕', 'images/mousse2.jpg', '[\"images/mousse2-1.jpg\", \"images/mousse2-2.jpg\"]', 58.00, '粉色甜美造型，新鲜草莓装饰，口感轻盈，适合闺蜜聚会', 30, 2, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (6, '抹茶慕斯蛋糕', 'images/mousse3.jpg', '[\"images/mousse3-1.jpg\", \"images/mousse3-2.jpg\"]', 62.00, '日式风格，绿色层次分明，抹茶与红豆的完美搭配', 25, 2, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (7, '彩虹纸杯蛋糕', 'images/cupcake1.jpg', '[\"images/cupcake1-1.jpg\", \"images/cupcake1-2.jpg\"]', 35.00, '多种颜色的纸杯蛋糕，装饰精美，适合儿童生日派对', 40, 3, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (8, '巧克力纸杯蛋糕', 'images/cupcake2.jpg', '[\"images/cupcake2-1.jpg\", \"images/cupcake2-2.jpg\"]', 32.00, '浓郁巧克力奶油，装饰巧克力碎片，圣诞主题风格', 35, 3, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (9, '香草纸杯蛋糕', 'images/cupcake3.jpg', '[\"images/cupcake3-1.jpg\", \"images/cupcake3-2.jpg\"]', 30.00, '优雅奶油花装饰，点缀新鲜蓝莓，下午茶完美搭配', 35, 3, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (10, '经典提拉米苏', 'images/tiramisu1.jpg', '[\"images/tiramisu1-1.jpg\", \"images/tiramisu1-2.jpg\"]', 45.00, '正宗意大利风味，马斯卡彭奶酪配手指饼干，撒有可可粉', 20, 4, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (11, '精致提拉米苏', 'images/tiramisu2.jpg', '[\"images/tiramisu2-1.jpg\", \"images/tiramisu2-2.jpg\"]', 42.00, '层次分明的提拉米苏切块，装饰咖啡豆，高级餐厅摆盘', 18, 4, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (12, '现代杯装提拉米苏', 'images/tiramisu3.jpg', '[\"images/tiramisu3-1.jpg\", \"images/tiramisu3-2.jpg\"]', 38.00, '玻璃杯装盛，层次分明，装饰薄荷叶，咖啡馆风格', 22, 4, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (13, '热带水果挞', 'images/tart1.jpg', '[\"images/tart1-1.jpg\", \"images/tart1-2.jpg\"]', 52.00, '新鲜草莓、蓝莓、奇异果等热带水果，色彩缤纷，口感丰富', 15, 5, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (14, '法式浆果挞', 'images/tart2.jpg', '[\"images/tart2-1.jpg\", \"images/tart2-2.jpg\"]', 48.00, '精致法式工艺，新鲜浆果艺术排列，透明果胶光泽', 18, 5, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (15, '混合水果挞拼盘', 'images/tart3.jpg', '[\"images/tart3-1.jpg\", \"images/tart3-2.jpg\"]', 75.00, '草莓、柠檬、蓝莓多种口味，法式传统工艺，色彩缤纷', 12, 5, '2025-12-03 11:14:26', '2025-12-03 11:14:26');
INSERT INTO `goods` VALUES (16, '经典巧克力蛋糕', 'images/mousse1.jpg', '[\"images/cake1_1.jpg\", \"images/cake1_2.jpg\"]', 158.00, '浓郁巧克力口感，丝滑细腻，适合生日和庆典', 50, 1, '2025-12-03 12:06:02', '2025-12-03 15:30:04');
INSERT INTO `goods` VALUES (17, '草莓奶油蛋糕', 'images/mousse1.jpg', '[\"images/cake2_1.jpg\", \"images/cake2_2.jpg\"]', 128.00, '新鲜草莓搭配轻盈奶油，口感清新甜美', 45, 1, '2025-12-03 12:06:02', '2025-12-03 15:30:06');
INSERT INTO `goods` VALUES (18, '提拉米苏', 'images/mousse1.jpg', '[\"images/cake3_1.jpg\", \"images/cake3_2.jpg\"]', 98.00, '意大利经典甜点，咖啡与马斯卡彭的完美融合', 30, 4, '2025-12-03 12:06:02', '2025-12-03 15:30:08');
INSERT INTO `goods` VALUES (19, '法式马卡龙', 'images/macaron1.jpg', '[\"images/macaron1_1.jpg\"]', 68.00, '六色装马卡龙，外酥内软，色彩缤纷', 100, 3, '2025-12-03 12:06:02', '2025-12-03 12:06:02');
INSERT INTO `goods` VALUES (20, '手工曲奇礼盒', 'images/cupcake1.jpg', '[\"images/cookie1_1.jpg\"]', 88.00, '精选原料手工制作，黄油香浓口感酥脆', 60, 3, '2025-12-03 12:06:02', '2025-12-03 15:30:26');
INSERT INTO `goods` VALUES (21, '抹茶千层蛋糕', 'images/cupcake1.jpg', '[\"images/cake4_1.jpg\", \"images/cake4_2.jpg\"]', 138.00, '日式抹茶粉制作，层次分明，茶香浓郁', 35, 1, '2025-12-03 12:06:02', '2025-12-03 15:30:21');
INSERT INTO `goods` VALUES (22, '黑森林蛋糕', 'images/cupcake1.jpg', '[\"images/cake5_1.jpg\", \"images/cake5_2.jpg\"]', 168.00, '德国经典黑樱桃与巧克力组合', 25, 1, '2025-12-03 12:06:02', '2025-12-03 15:30:23');
INSERT INTO `goods` VALUES (23, '芝士蛋糕', 'images/cupcake1.jpg', '[\"images/cheese1_1.jpg\"]', 108.00, '纽约式重芝士，口感醇厚浓郁', 40, 4, '2025-12-03 12:06:02', '2025-12-03 15:31:18');

-- ----------------------------
-- Table structure for order_table
-- ----------------------------
DROP TABLE IF EXISTS `order_table`;
CREATE TABLE `order_table`  (
  `order_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `total_amount` decimal(10, 2) NOT NULL COMMENT '订单总额',
  `total_quantity` int(11) NOT NULL COMMENT '商品总数量',
  `payment_status` enum('unpaid','paid','cancelled','refunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'unpaid' COMMENT '支付状态(未付款/已付款/已取消/已退款)',
  `payment_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '支付方式',
  `shipping_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '收货信息(JSON格式存储姓名、电话、地址等)',
  `order_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  PRIMARY KEY (`order_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_order_time`(`order_time`) USING BTREE,
  INDEX `idx_payment_status`(`payment_status`) USING BTREE,
  CONSTRAINT `order_table_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_table
-- ----------------------------

-- ----------------------------
-- Table structure for orderitem
-- ----------------------------
DROP TABLE IF EXISTS `orderitem`;
CREATE TABLE `orderitem`  (
  `orderitem_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '订单项ID',
  `goods_price` decimal(10, 2) NOT NULL COMMENT '下单时商品价格',
  `quantity` int(11) NOT NULL COMMENT '购买数量',
  `goods_id` int(11) NOT NULL COMMENT '商品ID',
  `order_id` int(11) NOT NULL COMMENT '订单ID',
  PRIMARY KEY (`orderitem_id`) USING BTREE,
  INDEX `idx_order_id`(`order_id`) USING BTREE,
  INDEX `idx_goods_id`(`goods_id`) USING BTREE,
  CONSTRAINT `orderitem_ibfk_1` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `orderitem_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `order_table` (`order_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '订单项表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orderitem
-- ----------------------------

-- ----------------------------
-- Table structure for recommend
-- ----------------------------
DROP TABLE IF EXISTS `recommend`;
CREATE TABLE `recommend`  (
  `recommend_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '推荐栏ID',
  `recommend_type` enum('banner','hot','new') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '推荐类型(banner:条幅推荐,hot:热销推荐,new:新品推荐)',
  `goods_id` int(11) NOT NULL COMMENT '商品ID',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序顺序',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`recommend_id`) USING BTREE,
  INDEX `goods_id`(`goods_id`) USING BTREE,
  INDEX `idx_recommend_type`(`recommend_type`) USING BTREE,
  INDEX `idx_sort_order`(`sort_order`) USING BTREE,
  CONSTRAINT `recommend_ibfk_1` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '推荐栏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recommend
-- ----------------------------
INSERT INTO `recommend` VALUES (16, 'banner', 1, 1, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (17, 'banner', 2, 2, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (18, 'banner', 3, 3, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (19, 'hot', 1, 1, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (20, 'hot', 2, 2, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (21, 'hot', 5, 3, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (22, 'hot', 6, 4, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (23, 'hot', 7, 5, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (24, 'hot', 8, 6, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (25, 'new', 6, 1, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (26, 'new', 7, 2, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (27, 'new', 8, 3, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (28, 'new', 4, 4, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (29, 'new', 5, 5, '2025-12-03 12:06:23', '2025-12-03 12:06:23');
INSERT INTO `recommend` VALUES (30, 'new', 3, 6, '2025-12-03 12:06:23', '2025-12-03 12:06:23');

-- ----------------------------
-- Table structure for type
-- ----------------------------
DROP TABLE IF EXISTS `type`;
CREATE TABLE `type`  (
  `type_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `type_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`type_id`) USING BTREE,
  UNIQUE INDEX `type_name`(`type_name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of type
-- ----------------------------
INSERT INTO `type` VALUES (1, '生日蛋糕', '2025-12-01 09:17:38', '2025-12-01 09:17:38');
INSERT INTO `type` VALUES (2, '水果蛋糕', '2025-12-01 09:17:38', '2025-12-01 09:17:38');
INSERT INTO `type` VALUES (3, '巧克力蛋糕', '2025-12-01 09:17:38', '2025-12-01 09:17:38');
INSERT INTO `type` VALUES (4, '慕斯蛋糕', '2025-12-01 09:17:38', '2025-12-01 09:17:38');
INSERT INTO `type` VALUES (5, '芝士蛋糕', '2025-12-01 09:17:38', '2025-12-01 09:17:38');
INSERT INTO `type` VALUES (6, '定制蛋糕', '2025-12-01 09:17:38', '2025-12-01 09:17:38');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电话',
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '地址',
  `is_admin` tinyint(1) NULL DEFAULT 0 COMMENT '是否管理员(0:否,1:是)',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '账户是否有效(0:无效,1:有效)',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '$2a$10$rQz8kH7k0K8k8k8k8k8k8.', '管理员', 'admin@cakeshop.com', NULL, NULL, 1, 1, '2025-12-01 09:17:49', '2025-12-01 09:17:49');
INSERT INTO `user` VALUES (2, 'testuser', '$2a$10$rQz8kH7k0K8k8k8k8k8k8.', '测试用户', 'test@example.com', '13800138000', '北京市朝阳区测试地址123号', 0, 1, '2025-12-01 09:17:49', '2025-12-01 09:17:49');
INSERT INTO `user` VALUES (3, 'zhangsan', '0985251f3d13076beec69aca778ea31f', '123', '2938051889@qq.com', '123', '123', 0, 1, '2025-12-02 20:45:04', '2025-12-02 20:45:04');

SET FOREIGN_KEY_CHECKS = 1;
