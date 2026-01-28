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

 Date: 28/01/2026 15:44:45
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
) ENGINE = InnoDB AUTO_INCREMENT = 144 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '商品表' ROW_FORMAT = Dynamic;

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
INSERT INTO `goods` VALUES (24, '草莓慕斯蛋糕', 'images/strawberry_mousse_cake_1.jpg', 'images/strawberry_mousse_cake_2.jpg', 68.00, '精致诱人的草莓慕斯蛋糕，采用新鲜草莓制作，口感轻盈细腻，奶香浓郁，是甜点爱好者的最佳选择。', 50, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (25, '巧克力布朗尼', 'images/chocolate_brownie_1.jpg', 'images/chocolate_brownie_2.jpg', 45.00, '经典美式巧克力布朗尼，浓郁巧克力风味，配有核桃颗粒，质地湿润，是巧克力控的福音。', 60, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (26, '法式马卡龙', 'images/french_macaron_1.jpg', 'images/french_macaron_2.jpg', 88.00, '正宗法式马卡龙，五色彩虹组合，外壳酥脆，内馅柔软，杏仁香味浓郁，优雅精致的法式甜点。', 40, 6, '2025-12-04 09:32:32', '2025-12-04 15:23:57');
INSERT INTO `goods` VALUES (27, '纽约芝士蛋糕', 'images/new_york_cheesecake_1.jpg', 'images/new_york_cheesecake_2.jpg', 78.00, '经典纽约芝士蛋糕，质地丝滑细腻，口感浓郁，配上新鲜蓝莓，是美式甜点的代表之作。', 45, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (28, '日式抹茶千层蛋糕', 'images/matcha_mille_cake_1.jpg', 'images/matcha_mille_cake_2.jpg', 82.00, '正宗日式抹茶千层蛋糕，层层叠叠的抹茶饼皮与奶油交替，茶香浓郁，口感绵密，是日式甜点的精品。', 35, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (29, '意式提拉米苏', 'images/tiramisu_1.jpg', 'images/tiramisu_2.jpg', 75.00, '经典意式提拉米苏，咖啡浸泡的手指饼干配上马斯卡彭奶油，可可粉点缀，口感丰富层次分明。', 55, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (30, '法式闪电泡芙', 'images/chocolate_eclair_1.jpg', 'images/chocolate_eclair_2.jpg', 58.00, '法式闪电泡芙，巧克力淋面光泽诱人，内馅香草奶油，外酥内嫩，是经典的法式糕点。', 48, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (31, '蓝莓芝士塔', 'images/blueberry_cheese_tart_1.jpg', 'images/blueberry_cheese_tart_2.jpg', 62.00, '新鲜蓝莓芝士塔，酥脆塔皮配上浓郁芝士馅，酸甜的蓝莓完美平衡，口感丰富。', 42, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (32, '芒果班戟', 'images/belgian_truffle_1.jpg', 'images/mango_pancake_2.jpg', 52.00, '热带风情芒果班戟，新鲜芒果丁配上香滑奶油，薄饼外皮柔软，是夏日甜点的最佳选择。', 50, 6, '2025-12-04 09:32:32', '2025-12-04 15:23:54');
INSERT INTO `goods` VALUES (33, '比利时黑松露巧克力', 'images/belgian_truffle_1.jpg', 'images/belgian_truffle_2.jpg', 128.00, '精选比利时黑松露巧克力，手工制作，可可粉撒面，口感丝滑浓郁，巧克力味纯正，是巧克力爱好者的极致享受。', 30, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (34, '英式司康饼', 'images/belgian_truffle_1.jpg', 'images/english_scone_2.jpg', 38.00, '传统英式司康饼，金黄色外皮松软，配上草莓果酱和凝脂奶油，是英式下午茶的必备点心。', 65, 6, '2025-12-04 09:32:32', '2025-12-04 15:23:35');
INSERT INTO `goods` VALUES (35, '覆盆子蛋白糖', 'images/raspberry_meringue_1.jpg', 'images/raspberry_meringue_2.jpg', 48.00, '精致覆盆子蛋白糖，粉色渐变心形，口感轻盈蓬松，酸甜适中，是浪漫甜点的代表。', 38, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (36, '焦糖布丁', 'images/caramel_pudding_1.jpg', 'images/caramel_pudding_2.jpg', 35.00, '经典法式焦糖布丁，丝滑的布丁配上香脆焦糖，口感嫩滑，甜而不腻，是老少皆宜的甜点。', 70, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (37, '法式可丽饼', 'images/french_crepe_1.jpg', 'images/french_crepe_2.jpg', 42.00, '正宗法式可丽饼，薄如蝉翼的饼皮配上新鲜水果和奶油，口感丰富，是法式街头经典美食。', 58, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (38, '榴莲千层蛋糕', 'images/durian_mille_cake_1.jpg', 'images/durian_mille_cake_2.jpg', 98.00, '东南亚特色榴莲千层蛋糕，新鲜榴莲果肉配上香滑奶油，层层分明，榴莲香味浓郁，是榴莲爱好者的最爱。', 25, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (39, '美式苹果派', 'images/apple_pie_1.jpg', 'images/apple_pie_2.jpg', 55.00, '经典美式苹果派，肉桂苹果馅料配上酥脆派皮，lattice网格顶部，是美式家庭烘焙的代表，温热食用最佳。', 40, 6, '2025-12-04 09:32:32', '2025-12-04 15:23:33');
INSERT INTO `goods` VALUES (40, '柠檬蛋白霜挞', 'images/lemon_meringue_tart_1.jpg', 'images/lemon_meringue_tart_2.jpg', 65.00, '清新柠檬蛋白霜挞，酸甜柠檬凝脂配上轻盈蛋白霜，酥脆塔皮，口感层次丰富，清新解腻。', 36, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (41, '黑森林蛋糕', 'images/black_forest_cake_1.jpg', 'images/black_forest_cake_2.jpg', 88.00, '德式经典黑森林蛋糕，巧克力海绵蛋糕配上樱桃酒奶油和黑樱桃，口感浓郁丰富，是德国甜点的代表。', 32, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (42, '彩虹千层蛋糕', 'images/rainbow_mille_cake_1.jpg', 'images/rainbow_mille_cake_2.jpg', 118.00, '缤纷彩虹千层蛋糕，七彩层次鲜艳，配上香滑奶油夹心，视觉效果惊艳，是儿童生日派对的最佳选择。', 20, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (43, '韩式奶油蛋糕卷', 'images/korean_cream_roll_1.jpg', 'images/korean_cream_roll_2.jpg', 72.00, '精致韩式奶油蛋糕卷，柔美粉色装饰配上精致花卉图案，奶油质地柔滑，口感轻盈甜美，是韩式烘焙的精品。', 28, 1, '2025-12-04 09:32:32', '2025-12-04 09:32:32');
INSERT INTO `goods` VALUES (44, 'Tang Anqi', 'images/cupcake3.jpg', 'images/cupcake3-1', 20.00, 'With its well-designed Graphical User Interface(GUI), Navicat lets you quickly and                  ', 11, 5, '2024-11-27 21:21:21', '2025-01-10 13:29:24');
INSERT INTO `goods` VALUES (45, 'Sherry Stone', 'images/cupcake3.jpg', 'images/cupcake2-1', 94.00, 'The Main Window consists of several toolbars and panes for you to work on connections,              ', 63, 5, '2025-06-12 01:43:32', '2025-08-10 14:43:01');
INSERT INTO `goods` VALUES (46, 'Li Jiehong', 'images/tart3.jpg', 'images/cupcake3-1', 89.00, 'To get a secure connection, the first thing you need to do is to install OpenSSL                    ', 3, 4, '2024-10-31 05:55:14', '2025-07-26 23:38:04');
INSERT INTO `goods` VALUES (47, 'Choi Wing Sze', 'images/tart2.jpg', 'images/cupcake2-1', 83.00, 'Actually it is just in an idea when feel oneself can achieve and cannot achieve.', 26, 6, '2025-08-18 04:32:05', '2025-08-16 10:49:45');
INSERT INTO `goods` VALUES (48, 'Stanley Martinez', 'images/tart3.jpg', 'images/cupcake3-1', 96.00, 'The reason why a great man is great is that he resolves to be a great man.', 13, 5, '2024-08-24 02:03:26', '2025-07-16 13:12:59');
INSERT INTO `goods` VALUES (49, 'Bobby Meyer', 'images/cupcake3.jpg', 'images/cupcake3-1', 92.00, 'It can also manage cloud databases such as Amazon Redshift, Amazon RDS, Alibaba Cloud.              ', 52, 6, '2024-10-30 14:24:20', '2025-05-04 00:29:29');
INSERT INTO `goods` VALUES (50, 'Bonnie Hunter', 'images/tiramisu2.jpg', 'images/cupcake3-1', 41.00, 'There is no way to happiness. Happiness is the way.', 10, 5, '2024-12-12 01:27:13', '2025-01-18 07:30:14');
INSERT INTO `goods` VALUES (51, 'Yuen Tak Wah', 'images/tiramisu2.jpg', 'images/cupcake3-1', 62.00, 'A query is used to extract data from the database in a readable format according                    ', 84, 2, '2025-01-08 07:17:52', '2025-06-26 11:03:31');
INSERT INTO `goods` VALUES (52, 'Xia Lan', 'images/tiramisu1.jpg', 'images/cupcake2-1', 45.00, 'Import Wizard allows you to import data to tables/collections from CSV, TXT, XML, DBF and more.', 71, 3, '2025-09-08 09:22:45', '2025-01-13 07:52:59');
INSERT INTO `goods` VALUES (53, 'Ku Wing Sze', 'images/tiramisu1.jpg', 'images/cupcake2-1', 69.00, 'You will succeed because most people are lazy. If you wait, all that happens is you get older.', 21, 5, '2024-06-12 09:05:26', '2025-04-10 04:04:34');
INSERT INTO `goods` VALUES (54, 'Pak Ka Keung', 'images/tiramisu3.jpg', 'images/cupcake2-1', 40.00, 'If your Internet Service Provider (ISP) does not provide direct access to its server,               ', 6, 4, '2024-08-14 06:22:55', '2025-07-02 22:32:59');
INSERT INTO `goods` VALUES (55, 'Zhao Lu', 'images/tart1.jpg', 'images/cupcake2-1', 88.00, 'To clear or reload various internal caches, flush tables, or acquire locks, control-click           ', 53, 2, '2023-10-11 15:39:20', '2025-10-30 07:48:57');
INSERT INTO `goods` VALUES (56, 'David Martinez', 'images/tart1.jpg', 'images/cupcake3-1', 35.00, 'Success consists of going from failure to failure without loss of enthusiasm.                       ', 35, 1, '2025-03-17 15:19:16', '2025-10-18 22:08:44');
INSERT INTO `goods` VALUES (57, 'Chen Zhiyuan', 'images/tart3.jpg', 'images/cupcake2-1', 77.00, 'Secure SHell (SSH) is a program to log in into another computer over a network, execute             ', 55, 3, '2025-10-15 04:12:31', '2025-11-11 14:02:26');
INSERT INTO `goods` VALUES (58, 'Tracy Robertson', 'images/tiramisu1.jpg', 'images/cupcake2-1', 39.00, 'To start working with your server in Navicat, you should first establish a connection               ', 62, 3, '2024-04-03 06:21:43', '2025-05-16 15:36:21');
INSERT INTO `goods` VALUES (59, 'Hsuan Wing Sze', 'images/tiramisu2.jpg', 'images/cupcake3-1', 42.00, 'It is used while your ISPs do not allow direct connections, but allows establishing                 ', 32, 1, '2024-02-17 09:58:38', '2025-08-14 09:42:54');
INSERT INTO `goods` VALUES (60, 'Yau Fu Shing', 'images/tiramisu2.jpg', 'images/cupcake2-1', 67.00, 'You can select any connections, objects or projects, and then select the corresponding              ', 65, 4, '2025-11-06 19:56:36', '2025-10-25 10:38:30');
INSERT INTO `goods` VALUES (61, 'Curtis Mcdonald', 'images/tart2.jpg', 'images/cupcake2-1', 42.00, 'To successfully establish a new connection to local/remote server - no matter via                   ', 6, 6, '2024-08-18 22:12:53', '2025-08-22 18:31:08');
INSERT INTO `goods` VALUES (62, 'Joe Long', 'images/tart3.jpg', 'images/cupcake3-1', 79.00, 'Navicat authorizes you to make connection to remote servers running on different                    ', 47, 3, '2024-02-25 00:50:58', '2025-10-04 08:10:49');
INSERT INTO `goods` VALUES (63, 'Mo Siu Wai', 'images/tiramisu1.jpg', 'images/cupcake3-1', 26.00, 'The Main Window consists of several toolbars and panes for you to work on connections,              ', 19, 2, '2025-09-26 09:29:08', '2025-06-17 06:05:41');
INSERT INTO `goods` VALUES (64, 'Cheng Yuning', 'images/cupcake3.jpg', 'images/cupcake3-1', 49.00, 'Always keep your eyes open. Keep watching. Because whatever you see can inspire you.', 41, 3, '2024-02-29 06:04:12', '2025-10-13 10:01:53');
INSERT INTO `goods` VALUES (65, 'Gao Xiaoming', 'images/cupcake2.jpg', 'images/cupcake3-1', 34.00, 'I destroy my enemies when I make them my friends. Secure SHell (SSH) is a program                   ', 61, 5, '2024-11-15 15:44:40', '2025-01-24 11:01:09');
INSERT INTO `goods` VALUES (66, 'Jimmy Ruiz', 'images/tiramisu3.jpg', 'images/cupcake2-1', 92.00, 'HTTP Tunneling is a method for connecting to a server that uses the same protocol                   ', 54, 3, '2024-03-16 12:13:59', '2025-06-09 18:07:33');
INSERT INTO `goods` VALUES (67, 'Carlos Jordan', 'images/tart3.jpg', 'images/cupcake2-1', 50.00, 'You must be the change you wish to see in the world. The Main Window consists of                    ', 77, 1, '2024-02-16 09:04:52', '2025-02-07 22:58:35');
INSERT INTO `goods` VALUES (68, 'Lo Lik Sun', 'images/tart2.jpg', 'images/cupcake2-1', 69.00, 'Navicat Data Modeler is a powerful and cost-effective database design tool which                    ', 29, 4, '2025-09-11 07:25:57', '2025-03-27 15:15:55');
INSERT INTO `goods` VALUES (69, 'Jin Ziyi', 'images/cupcake3.jpg', 'images/cupcake3-1', 94.00, 'To start working with your server in Navicat, you should first establish a connection               ', 75, 3, '2025-07-20 10:08:18', '2025-02-23 13:28:23');
INSERT INTO `goods` VALUES (70, 'Zeng Jialun', 'images/tiramisu3.jpg', 'images/cupcake3-1', 91.00, 'If you wait, all that happens is you get older. The Information Pane shows the detailed             ', 46, 1, '2024-10-17 15:32:27', '2025-08-14 19:37:03');
INSERT INTO `goods` VALUES (71, 'Kam Chieh Lun', 'images/tiramisu1.jpg', 'images/cupcake3-1', 25.00, 'It can also manage cloud databases such as Amazon Redshift, Amazon RDS, Alibaba Cloud.              ', 51, 5, '2025-06-21 02:15:58', '2025-02-07 21:26:59');
INSERT INTO `goods` VALUES (72, 'Wayne Jordan', 'images/tart3.jpg', 'images/cupcake3-1', 49.00, 'The Information Pane shows the detailed object information, project activities, the                 ', 32, 3, '2025-02-20 16:51:15', '2025-11-14 06:56:10');
INSERT INTO `goods` VALUES (73, 'Michael Wagner', 'images/cupcake2.jpg', 'images/cupcake3-1', 42.00, 'A comfort zone is a beautiful place, but nothing ever grows there.', 4, 3, '2024-12-12 07:18:53', '2025-09-19 13:37:01');
INSERT INTO `goods` VALUES (74, 'Au Chi Yuen', 'images/cupcake3.jpg', 'images/cupcake3-1', 97.00, 'A comfort zone is a beautiful place, but nothing ever grows there. In the Objects                   ', 36, 1, '2025-06-18 00:11:02', '2025-02-03 15:35:10');
INSERT INTO `goods` VALUES (75, 'Xue Jialun', 'images/tiramisu3.jpg', 'images/cupcake2-1', 95.00, 'If the plan doesn’t work, change the plan, but never the goal. Such sessions are                  ', 65, 3, '2024-08-18 04:28:45', '2025-11-14 14:47:52');
INSERT INTO `goods` VALUES (76, 'Fung Cho Yee', 'images/tart1.jpg', 'images/cupcake3-1', 36.00, 'Secure Sockets Layer(SSL) is a protocol for transmitting private documents via the Internet.', 29, 4, '2024-06-28 02:37:35', '2025-05-22 00:45:50');
INSERT INTO `goods` VALUES (77, 'Ye Xiaoming', 'images/tiramisu2.jpg', 'images/cupcake2-1', 99.00, 'Navicat Data Modeler enables you to build high-quality conceptual, logical and physical             ', 11, 3, '2025-10-16 07:07:33', '2025-02-23 20:30:34');
INSERT INTO `goods` VALUES (78, 'Lok Sze Kwan', 'images/cupcake3.jpg', 'images/cupcake2-1', 77.00, 'Such sessions are also susceptible to session hijacking, where a malicious user takes               ', 28, 3, '2025-08-07 16:18:31', '2025-08-05 05:30:21');
INSERT INTO `goods` VALUES (79, 'Hu Rui', 'images/cupcake3.jpg', 'images/cupcake2-1', 41.00, 'To get a secure connection, the first thing you need to do is to install OpenSSL                    ', 4, 3, '2024-03-22 08:48:12', '2025-09-07 22:55:14');
INSERT INTO `goods` VALUES (80, 'Gao Jialun', 'images/cupcake3.jpg', 'images/cupcake3-1', 55.00, 'Anyone who has ever made anything of importance was disciplined. SQL Editor allows                  ', 25, 2, '2024-06-27 23:12:29', '2025-02-04 21:36:04');
INSERT INTO `goods` VALUES (81, 'Zhou Lan', 'images/tart1.jpg', 'images/cupcake2-1', 54.00, 'Actually it is just in an idea when feel oneself can achieve and cannot achieve.', 37, 6, '2024-05-30 09:23:31', '2025-03-09 14:25:49');
INSERT INTO `goods` VALUES (82, 'Yan Xiaoming', 'images/tart2.jpg', 'images/cupcake3-1', 39.00, 'In a Telnet session, all communications, including username and password, are transmitted           ', 63, 2, '2024-09-26 14:15:34', '2025-11-21 10:53:35');
INSERT INTO `goods` VALUES (83, 'Tsui Sai Wing', 'images/cupcake3.jpg', 'images/cupcake2-1', 75.00, 'Sometimes you win, sometimes you learn. Navicat Data Modeler enables you to build                   ', 47, 2, '2024-07-24 05:25:53', '2025-11-06 17:05:57');
INSERT INTO `goods` VALUES (84, 'Long Lu', 'images/tart1.jpg', 'images/cupcake3-1', 87.00, 'You cannot save people, you can just love them. Remember that failure is an event, not a person.', 3, 1, '2025-10-14 06:30:53', '2025-09-07 12:45:33');
INSERT INTO `goods` VALUES (85, 'Yam Sai Wing', 'images/tiramisu3.jpg', 'images/cupcake3-1', 75.00, 'Navicat allows you to transfer data from one database and/or schema to another with                 ', 43, 3, '2024-03-17 22:56:21', '2025-07-07 19:27:14');
INSERT INTO `goods` VALUES (86, 'Ti Lik Sun', 'images/tiramisu3.jpg', 'images/cupcake2-1', 87.00, 'It wasn’t raining when Noah built the ark.', 27, 5, '2024-10-17 07:25:15', '2025-01-09 07:06:05');
INSERT INTO `goods` VALUES (87, 'Qiu Ziyi', 'images/tiramisu1.jpg', 'images/cupcake2-1', 97.00, 'After logged in the Navicat Cloud feature, the Navigation pane will be divided into                 ', 20, 1, '2025-02-09 16:07:45', '2025-03-01 07:07:29');
INSERT INTO `goods` VALUES (88, 'Lai Lai Yan', 'images/tart2.jpg', 'images/cupcake2-1', 23.00, 'The Synchronize to Database function will give you a full picture of all database differences.', 66, 2, '2024-06-11 19:29:22', '2025-02-23 06:01:46');
INSERT INTO `goods` VALUES (89, 'Ying Wing Sze', 'images/tart2.jpg', 'images/cupcake3-1', 85.00, 'The repository database can be an existing MySQL, MariaDB, PostgreSQL, SQL Server,                  ', 90, 3, '2025-11-19 19:04:18', '2025-08-07 14:19:00');
INSERT INTO `goods` VALUES (90, 'Ma Fu Shing', 'images/cupcake2.jpg', 'images/cupcake3-1', 36.00, 'Navicat provides powerful tools for working with queries: Query Editor for editing                  ', 86, 2, '2025-01-31 20:44:17', '2025-04-03 14:15:22');
INSERT INTO `goods` VALUES (91, 'Man Kwok Wing', 'images/tart1.jpg', 'images/cupcake3-1', 93.00, 'With its well-designed Graphical User Interface(GUI), Navicat lets you quickly and                  ', 21, 5, '2024-11-29 02:08:18', '2025-06-01 07:35:48');
INSERT INTO `goods` VALUES (92, 'Cheryl Murphy', 'images/tart1.jpg', 'images/cupcake2-1', 56.00, 'Always keep your eyes open. Keep watching. Because whatever you see can inspire you.                ', 19, 3, '2024-12-12 09:11:39', '2025-11-19 17:45:11');
INSERT INTO `goods` VALUES (93, 'Miguel Castillo', 'images/cupcake3.jpg', 'images/cupcake3-1', 54.00, 'If the Show objects under schema in navigation pane option is checked at the Preferences            ', 9, 3, '2025-11-29 18:01:59', '2025-01-07 16:27:04');
INSERT INTO `goods` VALUES (94, 'Tang Hiu Tung', 'images/tart2.jpg', 'images/cupcake3-1', 33.00, 'To open a query using an external editor, control-click it and select Open with External            ', 52, 2, '2024-02-19 19:23:29', '2025-03-18 13:48:02');
INSERT INTO `goods` VALUES (95, 'Huang Zhiyuan', 'images/tart2.jpg', 'images/cupcake2-1', 26.00, 'HTTP Tunneling is a method for connecting to a server that uses the same protocol                   ', 64, 1, '2025-03-28 22:58:45', '2025-08-28 06:14:30');
INSERT INTO `goods` VALUES (96, 'Mildred Moreno', 'images/tart3.jpg', 'images/cupcake2-1', 47.00, 'HTTP Tunneling is a method for connecting to a server that uses the same protocol                   ', 76, 3, '2024-03-21 20:44:40', '2025-01-21 18:00:55');
INSERT INTO `goods` VALUES (97, 'Zhong Zitao', 'images/tart2.jpg', 'images/cupcake2-1', 91.00, 'Optimism is the one quality more associated with success and happiness than any other.', 52, 4, '2024-12-13 02:25:43', '2025-05-30 18:22:37');
INSERT INTO `goods` VALUES (98, 'Tin Wing Fat', 'images/tart3.jpg', 'images/cupcake2-1', 50.00, 'In the middle of winter I at last discovered that there was in me an invincible summer.', 53, 3, '2025-08-29 23:41:20', '2025-03-21 04:15:40');
INSERT INTO `goods` VALUES (99, 'Lau Wing Fat', 'images/tiramisu2.jpg', 'images/cupcake3-1', 48.00, 'Navicat provides a wide range advanced features, such as compelling code editing                    ', 1, 1, '2025-02-26 14:05:51', '2025-07-22 07:21:18');
INSERT INTO `goods` VALUES (100, 'Gerald Hill', 'images/tart3.jpg', 'images/cupcake3-1', 29.00, 'There is no way to happiness. Happiness is the way. The Navigation pane employs tree                ', 94, 2, '2024-06-29 00:20:22', '2025-03-03 00:20:31');
INSERT INTO `goods` VALUES (101, 'Yang Shihan', 'images/tart1.jpg', 'images/cupcake3-1', 72.00, 'Monitored servers include MySQL, MariaDB and SQL Server, and compatible with cloud                  ', 20, 2, '2023-12-30 11:00:38', '2025-05-16 14:28:36');
INSERT INTO `goods` VALUES (102, 'Carolyn Torres', 'images/tart1.jpg', 'images/cupcake3-1', 61.00, 'To connect to a database or schema, simply double-click it in the pane.', 74, 4, '2024-04-22 15:18:29', '2025-01-17 09:44:12');
INSERT INTO `goods` VALUES (103, 'Han Jialun', 'images/cupcake3.jpg', 'images/cupcake2-1', 23.00, 'Navicat authorizes you to make connection to remote servers running on different                    ', 45, 2, '2025-02-26 21:49:41', '2025-07-29 20:03:10');
INSERT INTO `goods` VALUES (104, 'Sit Ming', 'images/tart1.jpg', 'images/cupcake2-1', 78.00, 'It wasn’t raining when Noah built the ark.', 25, 4, '2025-03-17 23:38:22', '2025-11-25 19:15:46');
INSERT INTO `goods` VALUES (105, 'Marilyn Nelson', 'images/cupcake2.jpg', 'images/cupcake3-1', 28.00, 'Such sessions are also susceptible to session hijacking, where a malicious user takes               ', 18, 3, '2024-07-11 01:45:31', '2025-08-27 04:13:20');
INSERT INTO `goods` VALUES (106, 'Fu Sai Wing', 'images/tart3.jpg', 'images/cupcake2-1', 88.00, 'A comfort zone is a beautiful place, but nothing ever grows there.', 53, 3, '2024-03-14 11:15:19', '2025-08-03 05:53:12');
INSERT INTO `goods` VALUES (107, 'Mok Kwok Wing', 'images/cupcake2.jpg', 'images/cupcake3-1', 49.00, 'There is no way to happiness. Happiness is the way.', 46, 3, '2023-11-18 03:17:44', '2025-07-30 08:44:50');
INSERT INTO `goods` VALUES (108, 'Shawn Aguilar', 'images/tiramisu2.jpg', 'images/cupcake3-1', 89.00, 'If opportunity doesn’t knock, build a door. It provides strong authentication and                 ', 93, 3, '2025-02-12 10:08:02', '2025-06-11 18:24:10');
INSERT INTO `goods` VALUES (109, 'Yao Lan', 'images/tart1.jpg', 'images/cupcake3-1', 58.00, 'To successfully establish a new connection to local/remote server - no matter via                   ', 2, 6, '2023-11-24 22:04:54', '2025-05-17 04:50:18');
INSERT INTO `goods` VALUES (110, 'Anne Phillips', 'images/tart1.jpg', 'images/cupcake2-1', 43.00, 'Navicat Cloud could not connect and access your databases. By which it means, it                    ', 60, 2, '2025-07-10 10:16:42', '2025-01-03 10:07:56');
INSERT INTO `goods` VALUES (111, 'Chung Siu Wai', 'images/cupcake2.jpg', 'images/cupcake3-1', 59.00, 'It provides strong authentication and secure encrypted communications between two                   ', 20, 4, '2025-03-27 14:43:26', '2025-01-11 23:28:48');
INSERT INTO `goods` VALUES (112, 'Betty Watson', 'images/tart2.jpg', 'images/cupcake3-1', 46.00, 'Navicat authorizes you to make connection to remote servers running on different                    ', 55, 4, '2023-11-08 01:29:38', '2025-11-12 22:21:38');
INSERT INTO `goods` VALUES (113, 'Anne Allen', 'images/tart1.jpg', 'images/cupcake3-1', 80.00, 'To clear or reload various internal caches, flush tables, or acquire locks, control-click           ', 27, 5, '2024-05-23 01:12:26', '2025-09-06 15:30:54');
INSERT INTO `goods` VALUES (114, 'Tin Tak Wah', 'images/tiramisu3.jpg', 'images/cupcake3-1', 52.00, 'To successfully establish a new connection to local/remote server - no matter via                   ', 27, 6, '2025-04-03 18:38:06', '2025-07-17 15:32:28');
INSERT INTO `goods` VALUES (115, 'Joseph Cole', 'images/tart1.jpg', 'images/cupcake3-1', 40.00, 'In a Telnet session, all communications, including username and password, are transmitted           ', 17, 2, '2025-05-06 20:51:33', '2025-03-05 00:40:08');
INSERT INTO `goods` VALUES (116, 'Yuen Wai Lam', 'images/tart1.jpg', 'images/cupcake2-1', 37.00, 'In a Telnet session, all communications, including username and password, are transmitted           ', 40, 2, '2024-09-10 16:26:04', '2025-01-02 19:08:24');
INSERT INTO `goods` VALUES (117, 'Edna Hall', 'images/tiramisu1.jpg', 'images/cupcake2-1', 82.00, 'Creativity is intelligence having fun. If you wait, all that happens is you get older.', 54, 6, '2025-03-20 21:29:18', '2025-07-28 06:50:42');
INSERT INTO `goods` VALUES (118, 'Yuan Yuning', 'images/tiramisu2.jpg', 'images/cupcake3-1', 29.00, 'Flexible settings enable you to set up a custom key for comparison and synchronization.', 98, 4, '2025-05-24 01:29:19', '2025-03-14 21:18:25');
INSERT INTO `goods` VALUES (119, 'Charles Schmidt', 'images/tiramisu3.jpg', 'images/cupcake3-1', 46.00, 'Monitored servers include MySQL, MariaDB and SQL Server, and compatible with cloud                  ', 95, 5, '2023-10-24 16:20:28', '2025-10-05 04:57:23');
INSERT INTO `goods` VALUES (120, 'Lei Jialun', 'images/tiramisu2.jpg', 'images/cupcake3-1', 80.00, 'The On Startup feature allows you to control what tabs appear when you launch Navicat.', 14, 6, '2025-01-23 12:44:56', '2025-09-17 01:05:34');
INSERT INTO `goods` VALUES (121, 'Monica Mitchell', 'images/tart3.jpg', 'images/cupcake2-1', 24.00, 'Flexible settings enable you to set up a custom key for comparison and synchronization.', 29, 3, '2024-08-21 19:49:37', '2025-06-23 17:43:49');
INSERT INTO `goods` VALUES (122, 'Huang Jialun', 'images/tiramisu1.jpg', 'images/cupcake3-1', 57.00, 'A query is used to extract data from the database in a readable format according                    ', 89, 4, '2025-07-10 04:53:13', '2025-07-09 09:45:18');
INSERT INTO `goods` VALUES (123, 'Lu Lu', 'images/tiramisu1.jpg', 'images/cupcake3-1', 67.00, 'Navicat provides a wide range advanced features, such as compelling code editing                    ', 18, 2, '2024-04-10 22:34:02', '2025-12-03 11:28:52');
INSERT INTO `goods` VALUES (124, 'Louis Perry', 'images/cupcake2.jpg', 'images/cupcake3-1', 76.00, 'You will succeed because most people are lazy.', 62, 6, '2025-11-01 09:10:59', '2025-04-19 11:11:37');
INSERT INTO `goods` VALUES (125, 'Chiang Yu Ling', 'images/tart2.jpg', 'images/cupcake2-1', 90.00, 'Such sessions are also susceptible to session hijacking, where a malicious user takes               ', 64, 1, '2024-06-20 10:00:25', '2025-11-08 07:12:41');
INSERT INTO `goods` VALUES (126, 'Kwong Tsz Ching', 'images/tiramisu2.jpg', 'images/cupcake2-1', 82.00, 'To clear or reload various internal caches, flush tables, or acquire locks, control-click           ', 86, 6, '2024-10-05 02:19:00', '2025-08-23 14:04:38');
INSERT INTO `goods` VALUES (127, 'Chung Chiu Wai', 'images/cupcake3.jpg', 'images/cupcake2-1', 50.00, 'Navicat Monitor can be installed on any local computer or virtual machine and does                  ', 75, 2, '2024-09-07 20:46:45', '2025-04-14 18:36:01');
INSERT INTO `goods` VALUES (128, 'Fu Lu', 'images/tart2.jpg', 'images/cupcake3-1', 58.00, 'Creativity is intelligence having fun.', 27, 3, '2025-03-10 05:44:35', '2025-11-06 16:06:16');
INSERT INTO `goods` VALUES (129, 'Frederick Boyd', 'images/tart1.jpg', 'images/cupcake3-1', 71.00, 'A man is not old until regrets take the place of dreams. Champions keep playing until               ', 92, 3, '2023-12-13 21:49:04', '2025-07-14 01:41:46');
INSERT INTO `goods` VALUES (130, 'Li Shihan', 'images/cupcake2.jpg', 'images/cupcake3-1', 39.00, 'Navicat provides a wide range advanced features, such as compelling code editing                    ', 91, 6, '2024-01-27 05:06:41', '2025-12-05 18:57:41');
INSERT INTO `goods` VALUES (131, 'Lam Wing Fat', 'images/cupcake3.jpg', 'images/cupcake2-1', 30.00, 'The reason why a great man is great is that he resolves to be a great man.', 34, 3, '2024-09-20 17:13:48', '2025-05-03 22:45:50');
INSERT INTO `goods` VALUES (132, 'Leung Tak Wah', 'images/tart1.jpg', 'images/cupcake3-1', 37.00, 'Success consists of going from failure to failure without loss of enthusiasm.', 13, 1, '2025-01-14 21:19:48', '2025-05-02 15:14:41');
INSERT INTO `goods` VALUES (133, 'Tang Lu', 'images/tart1.jpg', 'images/cupcake3-1', 34.00, 'You will succeed because most people are lazy. Anyone who has ever made anything                    ', 15, 1, '2025-07-27 09:28:34', '2025-10-22 14:35:21');
INSERT INTO `goods` VALUES (134, 'Kong Lu', 'images/tart3.jpg', 'images/cupcake2-1', 42.00, 'Difficult circumstances serve as a textbook of life for people. In a Telnet session,                ', 12, 6, '2025-09-10 21:09:46', '2025-11-05 12:26:12');
INSERT INTO `goods` VALUES (135, 'Troy James', 'images/cupcake3.jpg', 'images/cupcake2-1', 62.00, 'All journeys have secret destinations of which the traveler is unaware.', 6, 5, '2024-07-02 11:02:06', '2025-10-14 22:16:03');
INSERT INTO `goods` VALUES (136, 'Han Zitao', 'images/tart1.jpg', 'images/cupcake3-1', 87.00, 'A man is not old until regrets take the place of dreams. A man is not old until regrets             ', 98, 4, '2025-06-13 04:22:44', '2025-09-11 15:29:11');
INSERT INTO `goods` VALUES (137, 'Yuen Ka Ming', 'images/tiramisu2.jpg', 'images/cupcake3-1', 56.00, 'Always keep your eyes open. Keep watching. Because whatever you see can inspire you.                ', 81, 3, '2025-03-30 11:50:38', '2025-06-14 06:09:58');
INSERT INTO `goods` VALUES (138, 'Joyce Evans', 'images/tiramisu3.jpg', 'images/cupcake3-1', 42.00, 'All the Navicat Cloud objects are located under different projects. You can share                   ', 33, 6, '2025-01-15 23:16:56', '2025-01-30 15:18:39');
INSERT INTO `goods` VALUES (139, 'Frances Weaver', 'images/tart3.jpg', 'images/cupcake2-1', 22.00, 'The Synchronize to Database function will give you a full picture of all database differences.', 89, 2, '2024-12-08 04:55:46', '2025-05-14 11:16:54');
INSERT INTO `goods` VALUES (140, 'Kwok Ka Keung', 'images/tiramisu2.jpg', 'images/cupcake3-1', 81.00, 'In the middle of winter I at last discovered that there was in me an invincible summer.', 58, 2, '2025-01-14 04:45:10', '2025-05-31 09:02:45');
INSERT INTO `goods` VALUES (141, 'To Chi Ming', 'images/cupcake2.jpg', 'images/cupcake3-1', 87.00, 'The Synchronize to Database function will give you a full picture of all database differences.', 43, 1, '2024-01-27 13:35:13', '2025-01-28 00:56:05');
INSERT INTO `goods` VALUES (142, 'Ricky Palmer', 'images/cupcake3.jpg', 'images/cupcake3-1', 71.00, 'Success consists of going from failure to failure without loss of enthusiasm.                       ', 96, 2, '2024-08-28 03:11:33', '2025-09-26 07:16:45');
INSERT INTO `goods` VALUES (143, 'Deng Zitao', 'images/cupcake3.jpg', 'images/cupcake2-1', 74.00, 'Optimism is the one quality more associated with success and happiness than any other.', 33, 5, '2025-01-30 20:07:58', '2025-10-02 08:39:41');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1043 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '推荐栏表' ROW_FORMAT = Dynamic;

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
INSERT INTO `recommend` VALUES (31, 'hot', 5, 1, '2025-12-04 09:33:14', '2025-12-04 09:33:14');
INSERT INTO `recommend` VALUES (32, 'hot', 27, 2, '2025-12-04 09:33:14', '2025-12-04 09:33:14');
INSERT INTO `recommend` VALUES (33, 'hot', 28, 3, '2025-12-04 09:33:14', '2025-12-04 09:33:14');
INSERT INTO `recommend` VALUES (34, 'hot', 25, 4, '2025-12-04 09:33:14', '2025-12-04 09:33:14');
INSERT INTO `recommend` VALUES (35, 'new', 42, 1, '2025-12-04 09:33:14', '2025-12-04 09:33:14');
INSERT INTO `recommend` VALUES (36, 'new', 43, 2, '2025-12-04 09:33:14', '2025-12-04 09:33:14');
INSERT INTO `recommend` VALUES (37, 'new', 38, 3, '2025-12-04 09:33:14', '2025-12-04 09:33:14');
INSERT INTO `recommend` VALUES (38, 'new', 33, 4, '2025-12-04 09:33:14', '2025-12-04 09:33:14');
INSERT INTO `recommend` VALUES (39, 'banner', 19, 1, '2025-12-04 09:33:14', '2025-12-04 09:33:14');
INSERT INTO `recommend` VALUES (40, 'banner', 22, 2, '2025-12-04 09:33:14', '2025-12-04 09:33:14');
INSERT INTO `recommend` VALUES (41, 'banner', 29, 3, '2025-12-04 09:33:14', '2025-12-04 09:33:14');
INSERT INTO `recommend` VALUES (42, 'banner', 39, 4, '2025-12-04 09:33:14', '2025-12-04 09:33:14');
INSERT INTO `recommend` VALUES (43, 'hot', 19, 598, '2021-07-27 05:00:56', '2005-01-16 19:44:33');
INSERT INTO `recommend` VALUES (44, 'new', 20, 773, '2014-08-31 00:46:01', '2005-09-26 03:56:27');
INSERT INTO `recommend` VALUES (45, 'banner', 27, 19, '2019-08-02 23:08:38', '2013-11-10 10:10:43');
INSERT INTO `recommend` VALUES (46, 'hot', 32, 768, '2000-02-12 04:14:58', '2004-12-09 17:58:36');
INSERT INTO `recommend` VALUES (47, 'hot', 12, 371, '2022-12-13 19:01:12', '2014-06-18 17:13:24');
INSERT INTO `recommend` VALUES (48, 'hot', 34, 44, '2023-01-14 11:51:23', '2016-03-02 21:39:04');
INSERT INTO `recommend` VALUES (49, 'hot', 32, 899, '2004-06-24 10:50:24', '2024-07-15 01:07:29');
INSERT INTO `recommend` VALUES (50, 'banner', 20, 518, '2001-08-23 06:17:53', '2023-09-23 14:37:35');
INSERT INTO `recommend` VALUES (51, 'hot', 35, 193, '2008-07-30 01:07:31', '2015-08-02 12:39:14');
INSERT INTO `recommend` VALUES (52, 'new', 42, 422, '2013-06-17 08:23:10', '2022-12-31 23:20:47');
INSERT INTO `recommend` VALUES (53, 'new', 39, 121, '2004-11-18 00:21:38', '2012-01-22 19:00:53');
INSERT INTO `recommend` VALUES (54, 'hot', 20, 111, '2002-08-02 14:05:59', '2015-03-22 17:16:35');
INSERT INTO `recommend` VALUES (55, 'new', 2, 634, '2013-12-15 18:02:55', '2022-07-01 17:05:40');
INSERT INTO `recommend` VALUES (56, 'new', 43, 685, '2024-10-22 14:34:41', '2006-09-13 15:06:23');
INSERT INTO `recommend` VALUES (57, 'hot', 19, 945, '2007-07-14 17:28:34', '2011-07-04 08:43:54');
INSERT INTO `recommend` VALUES (58, 'banner', 14, 614, '2013-04-02 20:47:33', '2011-02-23 23:53:28');
INSERT INTO `recommend` VALUES (59, 'new', 15, 264, '2015-08-09 22:35:14', '2006-07-12 10:34:00');
INSERT INTO `recommend` VALUES (60, 'banner', 10, 657, '2016-12-17 23:43:25', '2017-12-16 14:58:19');
INSERT INTO `recommend` VALUES (61, 'new', 2, 218, '2024-11-14 03:39:55', '2003-05-15 11:20:41');
INSERT INTO `recommend` VALUES (62, 'new', 30, 922, '2018-03-16 11:55:45', '2022-12-23 04:50:01');
INSERT INTO `recommend` VALUES (63, 'new', 15, 927, '2001-09-24 05:20:54', '2016-05-01 02:42:54');
INSERT INTO `recommend` VALUES (64, 'new', 8, 130, '2003-11-09 22:14:54', '2021-12-01 10:41:39');
INSERT INTO `recommend` VALUES (65, 'banner', 33, 783, '2007-03-23 17:05:55', '2004-08-12 21:41:58');
INSERT INTO `recommend` VALUES (66, 'new', 37, 629, '2004-06-21 14:50:45', '2025-05-25 12:56:13');
INSERT INTO `recommend` VALUES (67, 'banner', 34, 24, '2020-11-27 10:29:21', '2008-12-29 06:51:25');
INSERT INTO `recommend` VALUES (68, 'hot', 37, 262, '2015-06-02 17:51:40', '2002-11-07 12:45:11');
INSERT INTO `recommend` VALUES (69, 'new', 35, 253, '2005-12-02 23:43:44', '2001-01-07 04:54:24');
INSERT INTO `recommend` VALUES (70, 'new', 5, 598, '2003-04-09 08:43:40', '2001-11-09 07:11:02');
INSERT INTO `recommend` VALUES (71, 'banner', 35, 179, '2006-06-17 07:41:09', '2010-01-15 08:05:59');
INSERT INTO `recommend` VALUES (72, 'banner', 29, 990, '2000-03-02 07:54:52', '2004-04-28 03:12:50');
INSERT INTO `recommend` VALUES (73, 'hot', 10, 91, '2019-03-24 13:26:49', '2023-02-26 03:02:36');
INSERT INTO `recommend` VALUES (74, 'banner', 26, 480, '2020-01-11 02:04:47', '2010-11-21 23:57:10');
INSERT INTO `recommend` VALUES (75, 'new', 27, 210, '2023-01-09 17:08:38', '2011-01-16 06:22:56');
INSERT INTO `recommend` VALUES (76, 'banner', 8, 7, '2014-04-15 18:13:59', '2014-01-11 05:06:18');
INSERT INTO `recommend` VALUES (77, 'hot', 43, 716, '2020-03-31 01:55:06', '2023-11-06 12:26:25');
INSERT INTO `recommend` VALUES (78, 'hot', 19, 428, '2007-05-02 12:41:51', '2020-04-13 16:53:11');
INSERT INTO `recommend` VALUES (79, 'hot', 4, 811, '2016-04-02 08:16:13', '2007-11-29 00:05:09');
INSERT INTO `recommend` VALUES (80, 'hot', 29, 623, '2012-12-17 15:18:36', '2008-07-22 02:03:36');
INSERT INTO `recommend` VALUES (81, 'new', 30, 877, '2009-09-16 21:44:38', '2025-07-26 07:11:32');
INSERT INTO `recommend` VALUES (82, 'new', 1, 249, '2003-12-11 22:49:47', '2014-02-05 07:24:56');
INSERT INTO `recommend` VALUES (83, 'banner', 35, 910, '2017-07-14 09:18:13', '2005-05-28 20:20:38');
INSERT INTO `recommend` VALUES (84, 'banner', 5, 507, '2024-11-21 05:30:10', '2009-12-04 04:21:47');
INSERT INTO `recommend` VALUES (85, 'hot', 5, 407, '2019-09-26 12:25:51', '2016-03-09 01:20:45');
INSERT INTO `recommend` VALUES (86, 'banner', 11, 53, '2006-12-30 14:00:00', '2025-04-09 10:02:15');
INSERT INTO `recommend` VALUES (87, 'hot', 34, 21, '2009-10-11 11:31:02', '2016-01-07 21:12:35');
INSERT INTO `recommend` VALUES (88, 'banner', 21, 951, '2008-11-23 20:49:18', '2014-01-01 04:32:52');
INSERT INTO `recommend` VALUES (89, 'hot', 2, 18, '2006-05-22 03:07:29', '2010-03-24 17:53:47');
INSERT INTO `recommend` VALUES (90, 'hot', 42, 757, '2024-01-19 00:00:43', '2011-12-28 20:59:47');
INSERT INTO `recommend` VALUES (91, 'hot', 7, 741, '2021-10-19 05:28:41', '2012-06-07 11:34:37');
INSERT INTO `recommend` VALUES (92, 'banner', 23, 358, '2007-08-05 00:24:28', '2025-06-12 14:08:52');
INSERT INTO `recommend` VALUES (93, 'banner', 42, 376, '2019-05-29 11:18:41', '2021-07-20 14:49:39');
INSERT INTO `recommend` VALUES (94, 'new', 28, 142, '2010-01-31 16:07:41', '2013-07-30 20:22:15');
INSERT INTO `recommend` VALUES (95, 'banner', 1, 517, '2016-06-10 14:13:39', '2003-08-30 21:38:30');
INSERT INTO `recommend` VALUES (96, 'banner', 37, 925, '2015-03-16 13:43:07', '2022-06-27 03:27:16');
INSERT INTO `recommend` VALUES (97, 'new', 6, 510, '2016-01-23 13:31:52', '2014-09-15 04:35:06');
INSERT INTO `recommend` VALUES (98, 'hot', 13, 485, '2009-12-01 17:24:03', '2010-08-08 02:09:06');
INSERT INTO `recommend` VALUES (99, 'new', 18, 501, '2013-11-22 04:51:54', '2023-07-27 05:49:18');
INSERT INTO `recommend` VALUES (100, 'banner', 38, 992, '2016-11-24 14:44:29', '2007-11-02 03:34:00');
INSERT INTO `recommend` VALUES (101, 'hot', 19, 404, '2013-10-31 10:17:10', '2010-05-14 01:29:04');
INSERT INTO `recommend` VALUES (102, 'hot', 40, 857, '2001-08-13 11:04:40', '2008-11-11 09:32:11');
INSERT INTO `recommend` VALUES (103, 'hot', 15, 895, '2024-08-30 22:58:54', '2000-01-15 18:47:31');
INSERT INTO `recommend` VALUES (104, 'new', 1, 191, '2012-10-31 03:46:54', '2025-10-18 04:23:02');
INSERT INTO `recommend` VALUES (105, 'new', 32, 578, '2018-12-29 05:44:41', '2019-10-06 22:16:36');
INSERT INTO `recommend` VALUES (106, 'hot', 18, 588, '2019-08-17 00:54:26', '2002-04-02 00:46:27');
INSERT INTO `recommend` VALUES (107, 'hot', 32, 876, '2001-01-02 01:32:34', '2022-10-02 08:24:22');
INSERT INTO `recommend` VALUES (108, 'hot', 35, 293, '2018-03-03 17:38:17', '2004-10-19 00:37:44');
INSERT INTO `recommend` VALUES (109, 'hot', 1, 166, '2015-07-23 16:15:54', '2019-05-10 17:01:21');
INSERT INTO `recommend` VALUES (110, 'banner', 25, 296, '2002-04-23 06:20:52', '2019-02-17 21:42:55');
INSERT INTO `recommend` VALUES (111, 'new', 26, 67, '2024-06-24 05:29:59', '2009-09-02 03:32:56');
INSERT INTO `recommend` VALUES (112, 'hot', 5, 192, '2012-05-06 22:47:01', '2025-05-16 08:27:26');
INSERT INTO `recommend` VALUES (113, 'new', 7, 178, '2022-10-31 04:19:39', '2013-12-04 15:34:33');
INSERT INTO `recommend` VALUES (114, 'hot', 33, 990, '2001-06-27 04:11:23', '2003-12-26 13:13:51');
INSERT INTO `recommend` VALUES (115, 'new', 20, 617, '2000-02-20 15:10:54', '2022-05-18 21:05:46');
INSERT INTO `recommend` VALUES (116, 'hot', 18, 157, '2015-12-03 18:05:15', '2012-05-12 20:10:44');
INSERT INTO `recommend` VALUES (117, 'new', 15, 548, '2006-11-23 14:17:58', '2024-01-16 04:00:54');
INSERT INTO `recommend` VALUES (118, 'banner', 38, 360, '2008-04-28 12:03:05', '2014-05-31 13:54:07');
INSERT INTO `recommend` VALUES (119, 'banner', 40, 438, '2020-01-26 02:24:00', '2003-12-21 01:19:51');
INSERT INTO `recommend` VALUES (120, 'new', 42, 920, '2008-06-27 07:15:20', '2018-06-07 23:33:25');
INSERT INTO `recommend` VALUES (121, 'banner', 43, 365, '2006-03-17 18:05:07', '2003-07-09 08:47:58');
INSERT INTO `recommend` VALUES (122, 'new', 24, 283, '2013-04-16 02:44:31', '2011-12-29 01:06:17');
INSERT INTO `recommend` VALUES (123, 'hot', 23, 33, '2000-03-02 18:52:09', '2025-06-02 16:40:11');
INSERT INTO `recommend` VALUES (124, 'hot', 33, 688, '2024-04-07 12:35:22', '2020-01-06 11:33:09');
INSERT INTO `recommend` VALUES (125, 'hot', 38, 164, '2020-10-19 13:05:23', '2023-02-26 17:30:08');
INSERT INTO `recommend` VALUES (126, 'hot', 23, 11, '2002-08-26 01:13:00', '2016-10-10 16:37:37');
INSERT INTO `recommend` VALUES (127, 'new', 24, 350, '2019-08-09 13:48:14', '2020-10-07 04:05:22');
INSERT INTO `recommend` VALUES (128, 'banner', 13, 999, '2018-09-19 17:05:42', '2020-06-21 09:03:00');
INSERT INTO `recommend` VALUES (129, 'hot', 16, 728, '2006-08-16 13:22:15', '2020-04-04 16:44:43');
INSERT INTO `recommend` VALUES (130, 'banner', 9, 156, '2020-11-27 02:14:30', '2014-11-11 17:13:52');
INSERT INTO `recommend` VALUES (131, 'banner', 42, 732, '2014-12-25 21:36:16', '2002-12-22 15:30:31');
INSERT INTO `recommend` VALUES (132, 'hot', 10, 735, '2004-01-22 16:39:30', '2009-08-18 14:02:44');
INSERT INTO `recommend` VALUES (133, 'banner', 5, 524, '2020-12-20 14:44:45', '2002-12-26 22:24:06');
INSERT INTO `recommend` VALUES (134, 'banner', 7, 426, '2023-08-23 09:37:59', '2008-02-02 08:31:58');
INSERT INTO `recommend` VALUES (135, 'hot', 33, 540, '2019-11-29 01:51:17', '2018-11-28 20:35:36');
INSERT INTO `recommend` VALUES (136, 'hot', 37, 789, '2012-09-25 06:39:10', '2008-09-26 03:03:14');
INSERT INTO `recommend` VALUES (137, 'new', 39, 148, '2001-06-17 12:27:27', '2025-07-29 22:40:57');
INSERT INTO `recommend` VALUES (138, 'new', 39, 641, '2012-04-09 13:10:26', '2021-01-09 01:10:08');
INSERT INTO `recommend` VALUES (139, 'banner', 39, 685, '2012-10-11 09:06:13', '2004-08-10 05:34:16');
INSERT INTO `recommend` VALUES (140, 'new', 1, 981, '2012-07-11 11:15:37', '2025-05-26 08:12:35');
INSERT INTO `recommend` VALUES (141, 'new', 15, 697, '2019-02-22 11:32:33', '2004-09-21 15:45:04');
INSERT INTO `recommend` VALUES (142, 'banner', 34, 736, '2013-05-28 17:37:34', '2007-11-14 13:40:18');
INSERT INTO `recommend` VALUES (143, 'hot', 27, 630, '2022-12-27 14:12:23', '2002-04-20 11:14:33');
INSERT INTO `recommend` VALUES (144, 'hot', 35, 814, '2007-11-17 15:12:51', '2024-05-10 00:35:28');
INSERT INTO `recommend` VALUES (145, 'hot', 23, 388, '2011-05-12 02:12:33', '2007-10-22 03:14:31');
INSERT INTO `recommend` VALUES (146, 'hot', 7, 525, '2002-03-15 21:50:15', '2015-12-30 19:58:57');
INSERT INTO `recommend` VALUES (147, 'new', 22, 808, '2022-09-08 11:36:17', '2025-05-20 10:10:30');
INSERT INTO `recommend` VALUES (148, 'hot', 28, 685, '2015-11-04 22:17:51', '2013-12-27 00:22:39');
INSERT INTO `recommend` VALUES (149, 'banner', 23, 237, '2012-09-27 06:01:30', '2021-10-10 00:37:07');
INSERT INTO `recommend` VALUES (150, 'new', 32, 216, '2022-10-09 21:43:42', '2018-03-16 05:15:09');
INSERT INTO `recommend` VALUES (151, 'banner', 6, 572, '2016-11-06 01:00:17', '2014-03-24 05:24:35');
INSERT INTO `recommend` VALUES (152, 'banner', 3, 590, '2005-10-24 14:22:05', '2015-02-04 11:19:30');
INSERT INTO `recommend` VALUES (153, 'hot', 4, 827, '2020-10-16 18:36:27', '2004-11-06 08:34:47');
INSERT INTO `recommend` VALUES (154, 'hot', 24, 423, '2010-07-18 16:15:18', '2024-10-29 12:29:24');
INSERT INTO `recommend` VALUES (155, 'new', 9, 691, '2021-06-17 10:02:56', '2006-12-26 18:42:40');
INSERT INTO `recommend` VALUES (156, 'new', 24, 214, '2025-08-08 01:44:22', '2002-03-08 02:10:48');
INSERT INTO `recommend` VALUES (157, 'new', 33, 325, '2015-10-27 03:32:24', '2005-08-21 21:31:14');
INSERT INTO `recommend` VALUES (158, 'banner', 26, 295, '2000-12-01 15:07:55', '2017-06-04 19:19:02');
INSERT INTO `recommend` VALUES (159, 'hot', 28, 238, '2002-03-30 10:34:30', '2015-11-06 02:37:43');
INSERT INTO `recommend` VALUES (160, 'hot', 13, 593, '2005-12-02 19:46:55', '2004-07-30 22:54:54');
INSERT INTO `recommend` VALUES (161, 'hot', 28, 815, '2006-10-03 05:48:23', '2024-11-28 01:04:07');
INSERT INTO `recommend` VALUES (162, 'hot', 19, 55, '2013-04-30 21:29:12', '2001-06-23 12:49:32');
INSERT INTO `recommend` VALUES (163, 'new', 19, 768, '2020-03-24 00:30:21', '2009-05-02 11:29:31');
INSERT INTO `recommend` VALUES (164, 'new', 42, 842, '2007-02-08 21:19:37', '2004-02-23 21:42:53');
INSERT INTO `recommend` VALUES (165, 'new', 7, 483, '2023-09-08 00:17:56', '2020-03-02 05:00:00');
INSERT INTO `recommend` VALUES (166, 'banner', 10, 774, '2024-07-29 15:50:58', '2005-10-18 09:18:49');
INSERT INTO `recommend` VALUES (167, 'banner', 5, 483, '2012-02-22 04:43:34', '2025-08-02 01:33:41');
INSERT INTO `recommend` VALUES (168, 'new', 12, 777, '2014-05-08 16:37:51', '2023-01-11 08:49:16');
INSERT INTO `recommend` VALUES (169, 'banner', 39, 705, '2021-06-25 23:22:10', '2021-06-16 22:10:58');
INSERT INTO `recommend` VALUES (170, 'new', 8, 546, '2014-08-04 07:26:56', '2011-05-31 20:02:23');
INSERT INTO `recommend` VALUES (171, 'new', 22, 315, '2002-06-01 00:40:31', '2003-08-10 16:10:53');
INSERT INTO `recommend` VALUES (172, 'hot', 36, 614, '2003-10-09 21:32:44', '2018-06-05 10:24:03');
INSERT INTO `recommend` VALUES (173, 'banner', 2, 176, '2024-06-09 16:06:56', '2005-08-08 01:15:42');
INSERT INTO `recommend` VALUES (174, 'new', 33, 270, '2013-04-25 04:59:55', '2018-12-26 05:22:51');
INSERT INTO `recommend` VALUES (175, 'banner', 25, 925, '2019-09-05 08:33:51', '2021-01-04 05:23:03');
INSERT INTO `recommend` VALUES (176, 'hot', 26, 171, '2006-02-16 09:52:40', '2013-08-06 18:14:01');
INSERT INTO `recommend` VALUES (177, 'banner', 5, 157, '2004-10-09 22:24:24', '2002-10-13 15:53:40');
INSERT INTO `recommend` VALUES (178, 'hot', 29, 847, '2003-09-27 15:39:45', '2000-06-20 22:02:46');
INSERT INTO `recommend` VALUES (179, 'banner', 31, 306, '2018-11-30 15:55:43', '2024-09-02 12:54:42');
INSERT INTO `recommend` VALUES (180, 'banner', 20, 167, '2006-10-29 18:21:34', '2012-06-21 01:26:12');
INSERT INTO `recommend` VALUES (181, 'new', 27, 151, '2025-06-24 12:38:33', '2004-09-27 17:18:04');
INSERT INTO `recommend` VALUES (182, 'banner', 29, 63, '2023-05-30 05:31:11', '2013-08-07 13:42:11');
INSERT INTO `recommend` VALUES (183, 'banner', 18, 481, '2020-09-25 09:39:23', '2016-04-14 19:05:50');
INSERT INTO `recommend` VALUES (184, 'new', 42, 452, '2005-10-15 22:24:08', '2006-05-20 08:40:00');
INSERT INTO `recommend` VALUES (185, 'hot', 28, 84, '2022-04-04 23:32:27', '2023-11-06 15:09:29');
INSERT INTO `recommend` VALUES (186, 'new', 34, 344, '2023-02-08 01:07:46', '2011-09-26 19:32:55');
INSERT INTO `recommend` VALUES (187, 'banner', 8, 999, '2007-06-17 09:53:22', '2014-09-04 11:10:32');
INSERT INTO `recommend` VALUES (188, 'banner', 6, 606, '2003-01-29 06:43:33', '2023-06-19 15:56:09');
INSERT INTO `recommend` VALUES (189, 'new', 36, 734, '2023-05-17 22:43:30', '2013-10-22 19:59:29');
INSERT INTO `recommend` VALUES (190, 'banner', 8, 884, '2002-09-04 04:14:22', '2005-10-03 18:03:25');
INSERT INTO `recommend` VALUES (191, 'banner', 35, 219, '2006-07-14 05:03:36', '2001-09-30 12:03:06');
INSERT INTO `recommend` VALUES (192, 'hot', 29, 923, '2010-03-09 01:02:04', '2015-04-13 07:49:33');
INSERT INTO `recommend` VALUES (193, 'hot', 23, 135, '2002-12-13 17:42:07', '2006-12-28 11:02:44');
INSERT INTO `recommend` VALUES (194, 'banner', 21, 930, '2008-12-05 13:25:07', '2007-12-03 15:11:20');
INSERT INTO `recommend` VALUES (195, 'hot', 13, 235, '2002-01-27 20:01:44', '2002-04-27 20:40:38');
INSERT INTO `recommend` VALUES (196, 'banner', 8, 6, '2013-07-29 04:58:49', '2008-05-31 04:10:37');
INSERT INTO `recommend` VALUES (197, 'banner', 42, 903, '2024-02-12 03:49:09', '2024-02-26 14:35:20');
INSERT INTO `recommend` VALUES (198, 'banner', 19, 182, '2010-08-06 20:38:04', '2006-11-10 23:39:52');
INSERT INTO `recommend` VALUES (199, 'new', 4, 74, '2012-12-10 21:23:18', '2015-08-24 00:27:02');
INSERT INTO `recommend` VALUES (200, 'hot', 4, 305, '2016-08-20 20:47:38', '2014-07-28 05:57:31');
INSERT INTO `recommend` VALUES (201, 'banner', 12, 18, '2023-02-20 08:21:31', '2004-11-22 04:11:39');
INSERT INTO `recommend` VALUES (202, 'new', 39, 33, '2019-07-26 06:24:30', '2024-09-18 23:34:06');
INSERT INTO `recommend` VALUES (203, 'banner', 7, 737, '2011-02-11 06:14:26', '2022-08-15 20:13:21');
INSERT INTO `recommend` VALUES (204, 'banner', 8, 191, '2002-04-08 05:37:16', '2000-09-07 20:16:05');
INSERT INTO `recommend` VALUES (205, 'hot', 1, 952, '2024-09-15 08:30:25', '2021-09-16 02:02:30');
INSERT INTO `recommend` VALUES (206, 'banner', 33, 532, '2007-04-01 19:56:47', '2018-02-13 03:01:17');
INSERT INTO `recommend` VALUES (207, 'hot', 9, 652, '2015-07-28 13:05:41', '2007-05-28 19:18:26');
INSERT INTO `recommend` VALUES (208, 'banner', 3, 812, '2009-01-12 11:36:56', '2016-02-13 15:12:01');
INSERT INTO `recommend` VALUES (209, 'banner', 3, 96, '2017-09-06 20:54:59', '2020-11-14 21:48:00');
INSERT INTO `recommend` VALUES (210, 'hot', 42, 786, '2008-11-04 12:43:24', '2009-03-31 04:13:09');
INSERT INTO `recommend` VALUES (211, 'hot', 18, 792, '2007-11-17 12:39:08', '2024-10-25 18:26:52');
INSERT INTO `recommend` VALUES (212, 'new', 9, 953, '2025-05-21 06:11:26', '2001-08-03 18:45:51');
INSERT INTO `recommend` VALUES (213, 'new', 43, 900, '2004-06-20 14:20:37', '2008-01-04 12:47:29');
INSERT INTO `recommend` VALUES (214, 'hot', 24, 220, '2000-11-22 07:56:14', '2014-02-24 12:59:59');
INSERT INTO `recommend` VALUES (215, 'banner', 41, 323, '2004-03-21 09:01:47', '2012-01-07 16:59:40');
INSERT INTO `recommend` VALUES (216, 'banner', 17, 136, '2010-12-17 02:03:15', '2013-11-14 22:43:31');
INSERT INTO `recommend` VALUES (217, 'hot', 10, 761, '2023-05-02 01:24:39', '2017-01-21 21:16:22');
INSERT INTO `recommend` VALUES (218, 'hot', 1, 972, '2004-06-15 18:49:06', '2015-04-01 14:00:40');
INSERT INTO `recommend` VALUES (219, 'new', 40, 553, '2025-07-18 19:00:12', '2005-08-26 17:21:02');
INSERT INTO `recommend` VALUES (220, 'new', 33, 158, '2024-06-22 03:32:31', '2018-12-13 06:29:40');
INSERT INTO `recommend` VALUES (221, 'hot', 24, 628, '2001-03-09 19:42:33', '2014-02-20 03:02:59');
INSERT INTO `recommend` VALUES (222, 'hot', 35, 477, '2018-01-18 06:46:45', '2016-06-23 02:22:51');
INSERT INTO `recommend` VALUES (223, 'hot', 25, 932, '2016-02-10 04:05:24', '2004-01-26 09:22:49');
INSERT INTO `recommend` VALUES (224, 'banner', 15, 37, '2021-12-25 19:01:20', '2016-12-06 23:36:46');
INSERT INTO `recommend` VALUES (225, 'hot', 9, 326, '2003-09-03 23:16:21', '2019-05-28 04:21:58');
INSERT INTO `recommend` VALUES (226, 'hot', 27, 250, '2000-03-07 16:10:33', '2017-12-17 04:36:43');
INSERT INTO `recommend` VALUES (227, 'banner', 11, 822, '2018-10-25 09:18:20', '2020-10-17 17:27:36');
INSERT INTO `recommend` VALUES (228, 'hot', 21, 79, '2000-02-13 04:59:47', '2000-04-09 06:54:04');
INSERT INTO `recommend` VALUES (229, 'hot', 42, 376, '2021-08-24 11:04:38', '2016-10-09 16:09:27');
INSERT INTO `recommend` VALUES (230, 'new', 9, 941, '2010-06-14 22:17:17', '2021-04-14 14:30:54');
INSERT INTO `recommend` VALUES (231, 'hot', 6, 118, '2022-06-28 22:34:27', '2009-04-25 04:27:04');
INSERT INTO `recommend` VALUES (232, 'hot', 27, 193, '2011-07-30 03:33:17', '2009-07-16 20:25:21');
INSERT INTO `recommend` VALUES (233, 'new', 15, 488, '2008-03-20 15:33:21', '2023-11-03 02:10:21');
INSERT INTO `recommend` VALUES (234, 'new', 26, 16, '2016-11-13 08:11:21', '2022-12-21 21:52:32');
INSERT INTO `recommend` VALUES (235, 'new', 15, 565, '2015-06-26 03:09:32', '2022-08-30 07:36:44');
INSERT INTO `recommend` VALUES (236, 'banner', 41, 187, '2016-02-21 09:56:55', '2010-12-07 21:04:26');
INSERT INTO `recommend` VALUES (237, 'banner', 23, 750, '2024-09-15 22:39:02', '2000-05-27 12:19:30');
INSERT INTO `recommend` VALUES (238, 'banner', 12, 124, '2019-10-10 21:20:51', '2019-07-22 02:46:56');
INSERT INTO `recommend` VALUES (239, 'hot', 7, 444, '2011-09-02 16:23:12', '2000-05-08 22:27:51');
INSERT INTO `recommend` VALUES (240, 'banner', 38, 863, '2021-06-11 08:43:35', '2025-11-14 22:07:13');
INSERT INTO `recommend` VALUES (241, 'banner', 24, 760, '2017-05-13 12:41:53', '2014-04-21 22:31:04');
INSERT INTO `recommend` VALUES (242, 'hot', 1, 507, '2013-11-24 21:46:17', '2017-11-06 06:51:25');
INSERT INTO `recommend` VALUES (243, 'banner', 17, 778, '2001-12-03 16:05:36', '2021-05-01 19:31:17');
INSERT INTO `recommend` VALUES (244, 'new', 38, 357, '2018-04-08 15:43:39', '2004-12-09 13:13:35');
INSERT INTO `recommend` VALUES (245, 'hot', 34, 206, '2016-04-17 21:20:59', '2001-01-07 03:44:17');
INSERT INTO `recommend` VALUES (246, 'banner', 38, 179, '2016-10-05 09:48:31', '2009-01-28 21:22:35');
INSERT INTO `recommend` VALUES (247, 'hot', 32, 306, '2013-09-25 17:04:15', '2002-07-18 17:35:14');
INSERT INTO `recommend` VALUES (248, 'hot', 13, 565, '2011-02-11 05:49:11', '2000-03-25 23:21:45');
INSERT INTO `recommend` VALUES (249, 'hot', 32, 655, '2004-06-18 01:04:09', '2020-09-19 07:48:59');
INSERT INTO `recommend` VALUES (250, 'banner', 28, 82, '2006-10-12 04:10:37', '2002-11-06 09:14:36');
INSERT INTO `recommend` VALUES (251, 'hot', 17, 849, '2006-09-05 09:22:01', '2012-08-25 16:11:14');
INSERT INTO `recommend` VALUES (252, 'hot', 31, 201, '2011-12-30 04:12:28', '2011-06-04 01:05:12');
INSERT INTO `recommend` VALUES (253, 'new', 10, 953, '2006-09-16 09:05:37', '2015-01-11 10:20:56');
INSERT INTO `recommend` VALUES (254, 'hot', 35, 134, '2000-05-02 21:47:10', '2005-11-24 19:02:09');
INSERT INTO `recommend` VALUES (255, 'hot', 1, 650, '2021-09-26 08:11:59', '2012-11-16 22:24:40');
INSERT INTO `recommend` VALUES (256, 'new', 37, 954, '2020-11-17 09:48:47', '2014-01-22 08:26:50');
INSERT INTO `recommend` VALUES (257, 'banner', 4, 171, '2005-06-27 07:42:17', '2004-03-20 15:21:37');
INSERT INTO `recommend` VALUES (258, 'hot', 3, 141, '2024-01-25 03:47:54', '2000-07-20 06:25:38');
INSERT INTO `recommend` VALUES (259, 'hot', 28, 346, '2005-09-30 20:07:30', '2025-06-23 13:24:47');
INSERT INTO `recommend` VALUES (260, 'new', 6, 948, '2018-05-09 23:36:38', '2022-12-05 15:49:33');
INSERT INTO `recommend` VALUES (261, 'hot', 33, 326, '2023-05-22 16:19:48', '2013-05-04 23:01:28');
INSERT INTO `recommend` VALUES (262, 'banner', 30, 692, '2000-05-04 23:48:52', '2015-07-15 21:23:03');
INSERT INTO `recommend` VALUES (263, 'banner', 18, 267, '2008-09-03 09:39:28', '2018-08-27 17:17:39');
INSERT INTO `recommend` VALUES (264, 'hot', 18, 162, '2013-05-28 20:24:52', '2015-08-25 15:13:03');
INSERT INTO `recommend` VALUES (265, 'new', 4, 373, '2025-09-06 09:54:14', '2016-01-30 19:15:39');
INSERT INTO `recommend` VALUES (266, 'banner', 41, 298, '2009-10-17 22:14:32', '2014-08-19 22:53:30');
INSERT INTO `recommend` VALUES (267, 'hot', 3, 252, '2012-07-06 05:52:56', '2006-06-22 12:12:57');
INSERT INTO `recommend` VALUES (268, 'hot', 23, 580, '2025-04-12 09:45:52', '2008-12-07 09:09:55');
INSERT INTO `recommend` VALUES (269, 'new', 8, 532, '2016-03-08 06:04:55', '2002-11-07 13:38:46');
INSERT INTO `recommend` VALUES (270, 'banner', 11, 442, '2019-09-07 07:36:38', '2018-11-12 00:24:47');
INSERT INTO `recommend` VALUES (271, 'hot', 40, 119, '2001-05-27 19:50:24', '2022-03-28 22:13:06');
INSERT INTO `recommend` VALUES (272, 'new', 15, 577, '2010-08-14 21:37:12', '2019-05-13 00:00:14');
INSERT INTO `recommend` VALUES (273, 'hot', 22, 155, '2007-11-11 11:56:16', '2013-10-21 12:56:29');
INSERT INTO `recommend` VALUES (274, 'hot', 12, 276, '2014-02-24 20:46:02', '2012-11-14 15:41:38');
INSERT INTO `recommend` VALUES (275, 'banner', 38, 116, '2017-06-29 18:43:38', '2005-02-26 14:00:02');
INSERT INTO `recommend` VALUES (276, 'hot', 17, 701, '2005-05-04 00:39:24', '2019-05-11 01:58:21');
INSERT INTO `recommend` VALUES (277, 'hot', 6, 526, '2019-12-23 02:45:42', '2015-05-20 16:33:53');
INSERT INTO `recommend` VALUES (278, 'new', 15, 329, '2024-10-25 04:28:56', '2018-06-23 11:57:56');
INSERT INTO `recommend` VALUES (279, 'banner', 10, 767, '2021-06-28 02:43:10', '2002-07-06 02:47:54');
INSERT INTO `recommend` VALUES (280, 'new', 36, 463, '2021-05-18 11:02:38', '2018-10-13 01:26:33');
INSERT INTO `recommend` VALUES (281, 'banner', 13, 456, '2005-01-15 16:01:21', '2011-04-10 01:50:01');
INSERT INTO `recommend` VALUES (282, 'hot', 40, 637, '2025-01-16 05:16:53', '2022-11-27 15:46:08');
INSERT INTO `recommend` VALUES (283, 'hot', 26, 175, '2020-10-29 23:20:44', '2016-03-26 09:53:23');
INSERT INTO `recommend` VALUES (284, 'banner', 1, 611, '2004-05-28 08:21:54', '2009-02-17 08:24:04');
INSERT INTO `recommend` VALUES (285, 'hot', 7, 49, '2002-02-09 11:08:24', '2023-03-15 03:29:24');
INSERT INTO `recommend` VALUES (286, 'hot', 21, 191, '2002-08-30 09:23:44', '2016-11-23 15:57:50');
INSERT INTO `recommend` VALUES (287, 'banner', 8, 339, '2014-04-16 22:37:00', '2024-12-07 04:16:18');
INSERT INTO `recommend` VALUES (288, 'new', 3, 563, '2010-08-05 03:44:35', '2008-11-01 01:18:37');
INSERT INTO `recommend` VALUES (289, 'banner', 6, 683, '2021-09-02 03:35:59', '2000-09-10 03:52:53');
INSERT INTO `recommend` VALUES (290, 'new', 28, 875, '2013-12-07 05:36:25', '2013-06-15 04:16:29');
INSERT INTO `recommend` VALUES (291, 'hot', 34, 303, '2017-08-09 05:34:24', '2022-02-17 04:53:23');
INSERT INTO `recommend` VALUES (292, 'hot', 3, 897, '2008-12-05 23:08:20', '2015-11-29 04:23:59');
INSERT INTO `recommend` VALUES (293, 'new', 33, 689, '2004-06-09 13:19:14', '2017-03-03 13:39:19');
INSERT INTO `recommend` VALUES (294, 'banner', 16, 961, '2014-01-21 03:42:37', '2002-10-05 12:54:02');
INSERT INTO `recommend` VALUES (295, 'hot', 7, 823, '2020-09-25 15:58:40', '2004-01-23 13:10:05');
INSERT INTO `recommend` VALUES (296, 'banner', 40, 681, '2019-05-14 13:25:02', '2016-06-22 17:42:53');
INSERT INTO `recommend` VALUES (297, 'banner', 9, 986, '2002-10-26 23:45:58', '2012-10-13 08:05:40');
INSERT INTO `recommend` VALUES (298, 'banner', 17, 744, '2013-07-30 00:04:41', '2022-11-12 17:54:41');
INSERT INTO `recommend` VALUES (299, 'banner', 23, 611, '2005-10-14 12:25:43', '2025-01-20 06:57:35');
INSERT INTO `recommend` VALUES (300, 'new', 17, 501, '2017-03-29 10:30:47', '2015-11-11 18:44:35');
INSERT INTO `recommend` VALUES (301, 'banner', 34, 798, '2016-02-26 23:42:28', '2014-01-18 04:01:29');
INSERT INTO `recommend` VALUES (302, 'new', 18, 744, '2018-04-11 17:15:43', '2006-02-25 07:38:45');
INSERT INTO `recommend` VALUES (303, 'new', 27, 776, '2004-12-22 13:03:14', '2012-08-07 01:37:01');
INSERT INTO `recommend` VALUES (304, 'hot', 31, 667, '2020-12-06 22:40:04', '2021-12-06 03:03:52');
INSERT INTO `recommend` VALUES (305, 'banner', 14, 363, '2015-09-12 21:17:35', '2010-07-10 14:17:25');
INSERT INTO `recommend` VALUES (306, 'new', 32, 306, '2021-07-02 15:24:55', '2012-01-25 14:11:22');
INSERT INTO `recommend` VALUES (307, 'hot', 8, 719, '2018-04-02 21:00:32', '2021-06-25 23:49:45');
INSERT INTO `recommend` VALUES (308, 'new', 37, 279, '2024-10-22 21:21:29', '2010-09-07 04:29:21');
INSERT INTO `recommend` VALUES (309, 'hot', 3, 521, '2017-02-11 10:20:13', '2019-11-09 15:31:46');
INSERT INTO `recommend` VALUES (310, 'new', 7, 750, '2024-01-04 23:55:47', '2015-05-01 20:19:09');
INSERT INTO `recommend` VALUES (311, 'banner', 1, 358, '2008-01-27 01:57:34', '2023-06-21 17:54:43');
INSERT INTO `recommend` VALUES (312, 'new', 14, 215, '2011-10-28 21:38:56', '2018-04-05 22:15:02');
INSERT INTO `recommend` VALUES (313, 'new', 24, 593, '2015-04-18 18:03:01', '2025-04-28 08:15:17');
INSERT INTO `recommend` VALUES (314, 'hot', 22, 161, '2006-08-30 05:01:39', '2015-07-18 22:11:31');
INSERT INTO `recommend` VALUES (315, 'banner', 6, 5, '2007-07-25 15:32:30', '2000-10-03 08:22:28');
INSERT INTO `recommend` VALUES (316, 'new', 16, 265, '2019-10-28 08:00:27', '2008-07-14 13:30:11');
INSERT INTO `recommend` VALUES (317, 'new', 1, 317, '2006-05-24 04:28:31', '2025-11-08 23:36:02');
INSERT INTO `recommend` VALUES (318, 'banner', 35, 211, '2007-09-13 01:27:29', '2013-12-06 03:54:32');
INSERT INTO `recommend` VALUES (319, 'hot', 20, 641, '2007-03-20 05:41:54', '2022-01-08 22:37:23');
INSERT INTO `recommend` VALUES (320, 'banner', 35, 518, '2018-03-25 08:56:28', '2014-06-01 17:23:00');
INSERT INTO `recommend` VALUES (321, 'hot', 39, 86, '2021-11-16 20:53:43', '2006-11-23 00:10:28');
INSERT INTO `recommend` VALUES (322, 'hot', 1, 394, '2015-05-23 07:31:58', '2001-11-26 08:38:36');
INSERT INTO `recommend` VALUES (323, 'hot', 15, 361, '2004-03-03 16:28:56', '2022-11-28 06:12:07');
INSERT INTO `recommend` VALUES (324, 'hot', 13, 548, '2010-05-21 21:03:22', '2019-12-31 09:22:35');
INSERT INTO `recommend` VALUES (325, 'new', 36, 765, '2024-11-06 22:05:19', '2014-07-29 04:54:22');
INSERT INTO `recommend` VALUES (326, 'banner', 18, 991, '2002-06-07 12:25:11', '2002-02-02 17:37:07');
INSERT INTO `recommend` VALUES (327, 'new', 25, 335, '2016-08-26 08:39:01', '2006-05-22 22:41:57');
INSERT INTO `recommend` VALUES (328, 'banner', 43, 598, '2023-02-13 16:48:35', '2020-08-17 17:34:13');
INSERT INTO `recommend` VALUES (329, 'hot', 35, 935, '2021-03-26 01:07:21', '2023-09-02 15:27:08');
INSERT INTO `recommend` VALUES (330, 'new', 10, 533, '2009-06-01 15:18:20', '2010-02-03 00:18:45');
INSERT INTO `recommend` VALUES (331, 'new', 15, 351, '2005-01-11 02:35:52', '2022-12-25 20:02:19');
INSERT INTO `recommend` VALUES (332, 'hot', 43, 974, '2015-06-17 22:05:52', '2014-12-15 01:00:48');
INSERT INTO `recommend` VALUES (333, 'banner', 15, 516, '2009-06-17 18:30:35', '2018-07-27 11:25:34');
INSERT INTO `recommend` VALUES (334, 'banner', 29, 669, '2005-08-29 09:42:01', '2016-06-18 08:31:52');
INSERT INTO `recommend` VALUES (335, 'banner', 10, 631, '2003-04-09 21:38:58', '2013-03-28 14:40:42');
INSERT INTO `recommend` VALUES (336, 'new', 1, 548, '2011-01-22 22:14:35', '2010-05-11 21:56:52');
INSERT INTO `recommend` VALUES (337, 'hot', 32, 35, '2019-05-12 19:37:49', '2019-09-23 11:05:34');
INSERT INTO `recommend` VALUES (338, 'hot', 3, 103, '2005-05-23 12:17:35', '2021-03-29 14:47:59');
INSERT INTO `recommend` VALUES (339, 'banner', 36, 339, '2019-02-13 21:17:01', '2009-03-27 21:10:21');
INSERT INTO `recommend` VALUES (340, 'banner', 15, 51, '2019-03-22 02:20:56', '2022-07-12 02:30:53');
INSERT INTO `recommend` VALUES (341, 'new', 22, 553, '2013-05-26 16:41:43', '2015-11-14 03:06:49');
INSERT INTO `recommend` VALUES (342, 'hot', 41, 430, '2020-12-17 04:24:46', '2014-04-15 05:35:02');
INSERT INTO `recommend` VALUES (343, 'banner', 26, 789, '2009-09-18 05:56:00', '2005-02-28 03:51:42');
INSERT INTO `recommend` VALUES (344, 'banner', 5, 350, '2011-01-29 16:58:17', '2003-01-31 18:42:41');
INSERT INTO `recommend` VALUES (345, 'new', 39, 587, '2012-09-19 09:11:54', '2017-12-02 08:17:36');
INSERT INTO `recommend` VALUES (346, 'hot', 25, 726, '2005-10-15 13:07:38', '2009-08-01 08:15:42');
INSERT INTO `recommend` VALUES (347, 'hot', 23, 219, '2023-05-11 09:59:40', '2010-10-27 05:14:58');
INSERT INTO `recommend` VALUES (348, 'new', 30, 48, '2018-01-19 14:20:55', '2019-04-03 03:12:28');
INSERT INTO `recommend` VALUES (349, 'banner', 29, 167, '2010-04-25 15:51:19', '2018-01-28 05:22:53');
INSERT INTO `recommend` VALUES (350, 'new', 39, 897, '2023-02-02 18:10:33', '2002-12-21 13:03:09');
INSERT INTO `recommend` VALUES (351, 'new', 21, 520, '2000-06-09 02:51:21', '2019-09-30 11:59:44');
INSERT INTO `recommend` VALUES (352, 'banner', 41, 164, '2018-02-06 16:41:14', '2025-03-01 09:46:11');
INSERT INTO `recommend` VALUES (353, 'banner', 13, 650, '2014-09-22 02:42:42', '2016-06-07 16:21:30');
INSERT INTO `recommend` VALUES (354, 'new', 3, 474, '2001-04-04 08:39:53', '2015-11-20 17:11:45');
INSERT INTO `recommend` VALUES (355, 'hot', 33, 981, '2002-02-04 07:08:18', '2021-05-16 07:32:52');
INSERT INTO `recommend` VALUES (356, 'hot', 35, 128, '2024-05-27 14:51:10', '2024-07-21 05:01:33');
INSERT INTO `recommend` VALUES (357, 'hot', 41, 138, '2017-12-12 18:58:16', '2016-07-25 06:16:11');
INSERT INTO `recommend` VALUES (358, 'banner', 34, 440, '2004-01-07 01:44:24', '2007-05-20 10:20:00');
INSERT INTO `recommend` VALUES (359, 'banner', 30, 863, '2023-07-08 18:45:28', '2025-01-09 17:40:46');
INSERT INTO `recommend` VALUES (360, 'hot', 33, 953, '2022-05-22 10:33:59', '2003-12-18 23:07:40');
INSERT INTO `recommend` VALUES (361, 'banner', 3, 455, '2020-04-13 14:27:07', '2018-02-09 07:56:20');
INSERT INTO `recommend` VALUES (362, 'banner', 33, 167, '2004-03-11 20:22:55', '2025-05-27 05:04:44');
INSERT INTO `recommend` VALUES (363, 'hot', 38, 414, '2012-02-26 02:33:31', '2015-08-28 21:43:27');
INSERT INTO `recommend` VALUES (364, 'hot', 32, 632, '2018-07-11 19:08:25', '2009-12-06 11:16:28');
INSERT INTO `recommend` VALUES (365, 'banner', 25, 699, '2021-03-07 08:06:49', '2013-11-07 20:57:10');
INSERT INTO `recommend` VALUES (366, 'banner', 22, 841, '2000-11-05 18:16:48', '2006-08-27 22:23:16');
INSERT INTO `recommend` VALUES (367, 'hot', 23, 835, '2003-06-06 17:41:41', '2016-01-03 20:13:49');
INSERT INTO `recommend` VALUES (368, 'hot', 1, 46, '2009-07-09 19:21:26', '2022-06-27 09:20:50');
INSERT INTO `recommend` VALUES (369, 'banner', 20, 729, '2001-10-05 04:25:32', '2013-10-05 09:24:39');
INSERT INTO `recommend` VALUES (370, 'banner', 42, 951, '2014-12-18 10:39:34', '2019-05-11 06:52:46');
INSERT INTO `recommend` VALUES (371, 'banner', 39, 94, '2016-05-28 09:16:16', '2018-05-14 16:55:11');
INSERT INTO `recommend` VALUES (372, 'hot', 31, 75, '2004-09-23 05:16:00', '2019-07-05 05:21:52');
INSERT INTO `recommend` VALUES (373, 'hot', 32, 678, '2001-05-05 02:15:04', '2000-06-21 18:05:53');
INSERT INTO `recommend` VALUES (374, 'banner', 41, 434, '2004-12-06 07:37:12', '2005-04-19 15:48:37');
INSERT INTO `recommend` VALUES (375, 'banner', 18, 431, '2010-08-03 16:37:35', '2021-10-20 00:21:35');
INSERT INTO `recommend` VALUES (376, 'hot', 8, 549, '2015-01-31 13:47:28', '2022-11-26 19:09:49');
INSERT INTO `recommend` VALUES (377, 'new', 43, 864, '2022-01-14 01:16:30', '2019-03-27 03:07:56');
INSERT INTO `recommend` VALUES (378, 'hot', 8, 566, '2011-10-18 09:08:23', '2009-10-16 20:51:34');
INSERT INTO `recommend` VALUES (379, 'new', 7, 635, '2023-01-29 21:46:44', '2021-09-05 12:13:49');
INSERT INTO `recommend` VALUES (380, 'banner', 24, 545, '2022-08-12 10:41:15', '2022-12-25 09:43:03');
INSERT INTO `recommend` VALUES (381, 'hot', 4, 685, '2003-02-05 03:11:58', '2012-07-14 20:59:22');
INSERT INTO `recommend` VALUES (382, 'hot', 6, 402, '2022-01-17 16:33:52', '2016-06-07 09:48:43');
INSERT INTO `recommend` VALUES (383, 'banner', 9, 639, '2007-01-16 06:27:05', '2016-02-03 11:32:10');
INSERT INTO `recommend` VALUES (384, 'banner', 4, 176, '2005-08-24 05:33:26', '2013-11-11 21:43:40');
INSERT INTO `recommend` VALUES (385, 'banner', 17, 813, '2022-12-17 12:07:14', '2022-08-15 19:57:51');
INSERT INTO `recommend` VALUES (386, 'hot', 2, 423, '2022-01-08 20:22:22', '2020-10-29 18:59:40');
INSERT INTO `recommend` VALUES (387, 'banner', 42, 802, '2007-01-14 01:18:42', '2002-04-02 07:38:30');
INSERT INTO `recommend` VALUES (388, 'new', 2, 881, '2001-01-15 23:35:11', '2014-05-28 00:29:42');
INSERT INTO `recommend` VALUES (389, 'banner', 8, 315, '2018-10-25 17:26:18', '2002-08-29 19:11:49');
INSERT INTO `recommend` VALUES (390, 'banner', 28, 319, '2014-09-09 18:15:25', '2016-01-31 08:54:21');
INSERT INTO `recommend` VALUES (391, 'new', 20, 413, '2003-11-29 20:28:19', '2021-04-29 21:11:21');
INSERT INTO `recommend` VALUES (392, 'new', 42, 396, '2024-08-21 17:53:04', '2017-11-16 18:48:37');
INSERT INTO `recommend` VALUES (393, 'banner', 4, 947, '2001-12-27 07:34:24', '2012-04-03 09:44:03');
INSERT INTO `recommend` VALUES (394, 'hot', 10, 398, '2021-03-14 07:42:31', '2020-03-08 23:07:48');
INSERT INTO `recommend` VALUES (395, 'banner', 19, 999, '2024-11-30 10:54:28', '2004-07-10 19:06:05');
INSERT INTO `recommend` VALUES (396, 'banner', 17, 330, '2020-03-28 00:01:23', '2023-11-02 18:44:22');
INSERT INTO `recommend` VALUES (397, 'new', 2, 646, '2012-04-22 10:26:00', '2002-03-09 02:36:23');
INSERT INTO `recommend` VALUES (398, 'banner', 27, 1000, '2024-09-17 19:44:44', '2002-07-21 06:48:45');
INSERT INTO `recommend` VALUES (399, 'banner', 13, 954, '2012-05-21 23:31:56', '2004-01-12 17:20:04');
INSERT INTO `recommend` VALUES (400, 'banner', 17, 402, '2011-01-13 06:27:48', '2013-06-11 11:03:13');
INSERT INTO `recommend` VALUES (401, 'banner', 9, 157, '2024-01-28 07:42:09', '2009-12-05 18:51:55');
INSERT INTO `recommend` VALUES (402, 'hot', 37, 817, '2022-12-11 15:50:18', '2016-07-25 15:54:41');
INSERT INTO `recommend` VALUES (403, 'hot', 15, 43, '2010-06-02 22:12:38', '2020-06-14 07:21:23');
INSERT INTO `recommend` VALUES (404, 'banner', 27, 964, '2001-04-08 09:07:17', '2010-04-24 00:17:28');
INSERT INTO `recommend` VALUES (405, 'new', 2, 973, '2003-03-28 10:41:13', '2025-01-15 03:39:21');
INSERT INTO `recommend` VALUES (406, 'hot', 42, 711, '2021-01-22 04:52:12', '2003-04-08 11:57:33');
INSERT INTO `recommend` VALUES (407, 'banner', 27, 965, '2023-03-23 11:01:36', '2000-12-20 00:39:00');
INSERT INTO `recommend` VALUES (408, 'hot', 3, 554, '2011-03-27 14:06:36', '2014-03-21 08:37:01');
INSERT INTO `recommend` VALUES (409, 'new', 32, 387, '2005-02-26 17:10:57', '2024-04-29 08:48:57');
INSERT INTO `recommend` VALUES (410, 'banner', 14, 73, '2013-02-27 02:37:06', '2010-02-11 00:39:50');
INSERT INTO `recommend` VALUES (411, 'banner', 40, 993, '2023-09-12 19:27:58', '2008-04-17 00:05:57');
INSERT INTO `recommend` VALUES (412, 'new', 21, 296, '2002-06-16 10:00:26', '2022-01-05 17:55:57');
INSERT INTO `recommend` VALUES (413, 'new', 39, 559, '2010-03-16 03:06:14', '2000-09-29 17:19:06');
INSERT INTO `recommend` VALUES (414, 'hot', 33, 208, '2009-09-20 03:29:42', '2007-10-31 16:57:42');
INSERT INTO `recommend` VALUES (415, 'new', 40, 433, '2000-10-24 00:08:23', '2020-12-28 22:35:40');
INSERT INTO `recommend` VALUES (416, 'banner', 21, 323, '2018-05-07 01:06:28', '2004-04-14 23:04:33');
INSERT INTO `recommend` VALUES (417, 'new', 20, 718, '2020-11-07 15:12:15', '2013-07-10 02:01:20');
INSERT INTO `recommend` VALUES (418, 'hot', 20, 862, '2011-01-29 00:20:15', '2013-10-07 11:12:48');
INSERT INTO `recommend` VALUES (419, 'banner', 8, 434, '2004-09-07 06:25:17', '2022-08-04 19:08:18');
INSERT INTO `recommend` VALUES (420, 'hot', 10, 464, '2020-10-09 16:39:48', '2024-10-25 17:59:49');
INSERT INTO `recommend` VALUES (421, 'new', 28, 692, '2014-04-24 15:39:50', '2020-11-07 13:10:15');
INSERT INTO `recommend` VALUES (422, 'banner', 41, 160, '2023-08-13 01:20:19', '2025-09-05 11:42:05');
INSERT INTO `recommend` VALUES (423, 'hot', 27, 144, '2001-06-16 05:42:13', '2007-08-02 12:05:15');
INSERT INTO `recommend` VALUES (424, 'new', 35, 725, '2005-04-21 06:11:21', '2016-01-05 23:17:39');
INSERT INTO `recommend` VALUES (425, 'banner', 31, 263, '2023-06-12 17:30:38', '2025-10-24 05:49:33');
INSERT INTO `recommend` VALUES (426, 'banner', 42, 264, '2007-04-13 08:05:56', '2004-11-03 04:47:50');
INSERT INTO `recommend` VALUES (427, 'banner', 31, 718, '2011-10-11 14:19:12', '2004-07-30 21:39:12');
INSERT INTO `recommend` VALUES (428, 'hot', 31, 404, '2023-10-22 18:15:03', '2002-03-28 08:58:24');
INSERT INTO `recommend` VALUES (429, 'new', 21, 130, '2004-12-26 06:26:26', '2004-03-22 01:07:45');
INSERT INTO `recommend` VALUES (430, 'hot', 21, 470, '2019-12-18 04:14:56', '2006-10-30 06:06:37');
INSERT INTO `recommend` VALUES (431, 'banner', 24, 254, '2009-10-20 04:14:14', '2006-07-16 01:45:08');
INSERT INTO `recommend` VALUES (432, 'new', 24, 811, '2006-07-18 00:38:52', '2015-07-21 21:50:50');
INSERT INTO `recommend` VALUES (433, 'new', 23, 374, '2009-08-22 11:11:33', '2022-11-10 12:11:11');
INSERT INTO `recommend` VALUES (434, 'hot', 43, 930, '2006-06-24 14:00:22', '2015-11-10 22:24:15');
INSERT INTO `recommend` VALUES (435, 'banner', 32, 445, '2017-07-05 07:14:36', '2011-06-25 22:58:17');
INSERT INTO `recommend` VALUES (436, 'new', 5, 554, '2012-06-03 21:13:54', '2016-11-16 10:15:18');
INSERT INTO `recommend` VALUES (437, 'banner', 15, 993, '2017-08-29 12:57:18', '2001-01-12 12:19:34');
INSERT INTO `recommend` VALUES (438, 'banner', 31, 951, '2000-07-06 00:03:47', '2012-04-07 02:45:53');
INSERT INTO `recommend` VALUES (439, 'new', 17, 603, '2016-07-07 18:42:11', '2014-12-06 04:42:37');
INSERT INTO `recommend` VALUES (440, 'new', 3, 944, '2018-02-04 03:05:56', '2004-01-12 06:35:24');
INSERT INTO `recommend` VALUES (441, 'new', 9, 203, '2008-03-03 15:51:42', '2013-03-02 23:21:40');
INSERT INTO `recommend` VALUES (442, 'hot', 32, 141, '2018-03-07 07:00:14', '2006-08-17 10:18:16');
INSERT INTO `recommend` VALUES (443, 'banner', 24, 173, '2020-02-19 22:41:44', '2008-02-03 10:27:19');
INSERT INTO `recommend` VALUES (444, 'new', 22, 493, '2020-09-20 04:03:32', '2018-12-02 10:23:55');
INSERT INTO `recommend` VALUES (445, 'new', 36, 956, '2011-05-26 18:12:11', '2018-04-06 01:28:10');
INSERT INTO `recommend` VALUES (446, 'new', 41, 364, '2010-03-30 15:05:23', '2017-04-03 21:35:52');
INSERT INTO `recommend` VALUES (447, 'new', 24, 980, '2002-04-06 19:37:02', '2002-02-22 03:14:10');
INSERT INTO `recommend` VALUES (448, 'new', 1, 378, '2021-01-09 10:35:43', '2006-09-12 21:42:59');
INSERT INTO `recommend` VALUES (449, 'hot', 35, 341, '2011-10-14 00:01:24', '2019-05-08 09:35:24');
INSERT INTO `recommend` VALUES (450, 'new', 41, 438, '2015-03-24 16:28:06', '2016-03-10 06:34:38');
INSERT INTO `recommend` VALUES (451, 'hot', 10, 816, '2006-07-04 12:24:17', '2016-12-04 10:31:20');
INSERT INTO `recommend` VALUES (452, 'new', 2, 687, '2003-04-03 02:17:40', '2002-08-08 22:45:12');
INSERT INTO `recommend` VALUES (453, 'hot', 5, 30, '2022-06-17 11:34:15', '2013-03-30 23:00:43');
INSERT INTO `recommend` VALUES (454, 'new', 29, 132, '2000-02-14 21:07:09', '2025-01-13 12:49:25');
INSERT INTO `recommend` VALUES (455, 'banner', 38, 781, '2014-06-20 02:53:42', '2011-07-04 22:52:00');
INSERT INTO `recommend` VALUES (456, 'banner', 28, 31, '2008-03-31 23:08:59', '2005-07-23 08:21:15');
INSERT INTO `recommend` VALUES (457, 'hot', 41, 104, '2001-01-17 20:47:15', '2020-04-05 14:12:32');
INSERT INTO `recommend` VALUES (458, 'new', 33, 898, '2011-06-07 00:55:56', '2022-02-09 14:54:57');
INSERT INTO `recommend` VALUES (459, 'new', 40, 311, '2025-05-14 21:03:48', '2014-09-15 08:25:35');
INSERT INTO `recommend` VALUES (460, 'hot', 20, 265, '2009-08-11 15:17:53', '2023-03-16 17:37:53');
INSERT INTO `recommend` VALUES (461, 'new', 15, 111, '2007-07-12 15:55:54', '2014-08-07 19:57:09');
INSERT INTO `recommend` VALUES (462, 'banner', 11, 570, '2008-11-22 22:48:37', '2005-01-13 15:00:39');
INSERT INTO `recommend` VALUES (463, 'new', 3, 784, '2011-11-08 06:04:49', '2011-09-03 19:31:51');
INSERT INTO `recommend` VALUES (464, 'hot', 23, 864, '2016-01-18 14:01:28', '2008-03-14 12:18:38');
INSERT INTO `recommend` VALUES (465, 'banner', 20, 925, '2000-02-02 16:29:13', '2019-01-30 22:26:10');
INSERT INTO `recommend` VALUES (466, 'hot', 27, 160, '2017-10-26 01:21:52', '2020-06-19 13:09:26');
INSERT INTO `recommend` VALUES (467, 'hot', 17, 902, '2013-02-20 21:33:24', '2006-02-09 20:07:45');
INSERT INTO `recommend` VALUES (468, 'new', 16, 881, '2005-06-16 15:00:41', '2007-01-04 14:01:28');
INSERT INTO `recommend` VALUES (469, 'hot', 18, 414, '2017-05-18 22:44:04', '2009-06-06 18:57:21');
INSERT INTO `recommend` VALUES (470, 'banner', 14, 693, '2009-04-06 18:29:11', '2006-09-08 17:56:50');
INSERT INTO `recommend` VALUES (471, 'hot', 16, 512, '2005-06-13 18:20:19', '2023-07-11 03:04:21');
INSERT INTO `recommend` VALUES (472, 'new', 7, 701, '2011-04-10 22:02:52', '2006-07-09 10:14:31');
INSERT INTO `recommend` VALUES (473, 'hot', 21, 576, '2020-07-22 14:59:09', '2003-04-30 08:19:54');
INSERT INTO `recommend` VALUES (474, 'new', 42, 792, '2010-12-27 00:49:42', '2013-10-25 06:21:21');
INSERT INTO `recommend` VALUES (475, 'banner', 40, 979, '2022-05-28 22:25:36', '2018-03-05 23:49:02');
INSERT INTO `recommend` VALUES (476, 'banner', 26, 614, '2020-03-03 18:12:59', '2005-02-15 06:47:01');
INSERT INTO `recommend` VALUES (477, 'new', 32, 127, '2004-01-05 18:27:54', '2015-07-11 19:52:22');
INSERT INTO `recommend` VALUES (478, 'banner', 29, 340, '2020-10-31 09:59:57', '2001-06-20 02:12:09');
INSERT INTO `recommend` VALUES (479, 'banner', 28, 624, '2006-10-24 11:36:51', '2018-02-28 02:23:25');
INSERT INTO `recommend` VALUES (480, 'new', 37, 53, '2016-05-21 12:25:41', '2020-06-13 03:43:33');
INSERT INTO `recommend` VALUES (481, 'hot', 8, 304, '2018-12-12 09:42:18', '2004-02-02 23:06:40');
INSERT INTO `recommend` VALUES (482, 'banner', 27, 181, '2009-11-17 12:23:30', '2024-12-25 20:52:10');
INSERT INTO `recommend` VALUES (483, 'hot', 43, 762, '2018-12-15 08:45:35', '2013-10-27 02:50:41');
INSERT INTO `recommend` VALUES (484, 'new', 17, 912, '2012-12-30 13:05:26', '2024-09-24 02:46:05');
INSERT INTO `recommend` VALUES (485, 'new', 29, 432, '2014-02-09 08:44:50', '2010-01-10 23:34:58');
INSERT INTO `recommend` VALUES (486, 'hot', 25, 8, '2022-05-17 12:40:56', '2008-10-09 19:50:11');
INSERT INTO `recommend` VALUES (487, 'banner', 26, 77, '2002-05-25 17:48:12', '2012-12-21 12:02:51');
INSERT INTO `recommend` VALUES (488, 'banner', 4, 213, '2005-01-08 03:58:11', '2007-11-12 05:42:17');
INSERT INTO `recommend` VALUES (489, 'hot', 3, 557, '2022-02-03 15:08:23', '2016-12-28 12:26:48');
INSERT INTO `recommend` VALUES (490, 'hot', 32, 897, '2023-10-04 11:11:20', '2024-02-29 20:58:17');
INSERT INTO `recommend` VALUES (491, 'banner', 6, 698, '2015-04-04 05:17:25', '2011-06-14 11:08:43');
INSERT INTO `recommend` VALUES (492, 'banner', 15, 85, '2010-07-28 22:23:52', '2003-10-26 11:18:09');
INSERT INTO `recommend` VALUES (493, 'hot', 40, 957, '2013-08-20 14:07:52', '2015-05-20 13:45:02');
INSERT INTO `recommend` VALUES (494, 'banner', 38, 86, '2013-02-17 10:34:06', '2023-03-01 20:55:30');
INSERT INTO `recommend` VALUES (495, 'hot', 1, 764, '2013-09-15 16:56:43', '2002-06-30 15:37:59');
INSERT INTO `recommend` VALUES (496, 'banner', 4, 661, '2022-11-01 21:16:41', '2012-10-09 02:28:39');
INSERT INTO `recommend` VALUES (497, 'new', 5, 162, '2007-03-14 11:23:15', '2000-12-19 03:50:30');
INSERT INTO `recommend` VALUES (498, 'new', 35, 539, '2000-07-23 18:25:48', '2004-02-02 03:31:16');
INSERT INTO `recommend` VALUES (499, 'banner', 14, 285, '2000-11-20 09:20:41', '2012-01-31 09:22:24');
INSERT INTO `recommend` VALUES (500, 'new', 4, 210, '2024-03-21 13:53:53', '2019-08-30 23:29:20');
INSERT INTO `recommend` VALUES (501, 'hot', 39, 259, '2018-03-26 05:47:49', '2007-10-03 19:42:41');
INSERT INTO `recommend` VALUES (502, 'banner', 19, 947, '2004-11-11 13:24:00', '2001-03-05 02:45:47');
INSERT INTO `recommend` VALUES (503, 'new', 39, 406, '2024-02-16 10:49:49', '2023-08-26 19:29:46');
INSERT INTO `recommend` VALUES (504, 'new', 16, 186, '2015-08-29 16:00:14', '2025-10-05 18:19:01');
INSERT INTO `recommend` VALUES (505, 'hot', 21, 331, '2008-01-10 12:37:05', '2020-08-20 06:34:27');
INSERT INTO `recommend` VALUES (506, 'hot', 19, 753, '2019-05-17 20:04:51', '2006-07-23 15:19:33');
INSERT INTO `recommend` VALUES (507, 'hot', 23, 728, '2011-07-04 21:59:43', '2019-08-09 14:40:17');
INSERT INTO `recommend` VALUES (508, 'hot', 22, 6, '2020-11-12 22:41:39', '2005-11-05 11:15:45');
INSERT INTO `recommend` VALUES (509, 'banner', 37, 630, '2007-10-08 12:15:51', '2004-12-21 18:59:20');
INSERT INTO `recommend` VALUES (510, 'new', 4, 932, '2017-06-20 01:16:42', '2004-04-11 17:28:30');
INSERT INTO `recommend` VALUES (511, 'new', 35, 385, '2018-01-27 00:20:21', '2016-11-25 07:49:10');
INSERT INTO `recommend` VALUES (512, 'new', 19, 40, '2010-08-03 19:47:58', '2014-10-28 00:28:03');
INSERT INTO `recommend` VALUES (513, 'banner', 14, 899, '2005-08-13 14:19:22', '2006-06-29 19:09:04');
INSERT INTO `recommend` VALUES (514, 'banner', 41, 220, '2002-02-07 20:41:15', '2003-11-16 06:28:32');
INSERT INTO `recommend` VALUES (515, 'hot', 6, 210, '2012-02-07 12:57:24', '2009-08-24 00:15:04');
INSERT INTO `recommend` VALUES (516, 'hot', 1, 579, '2013-05-27 10:25:44', '2016-12-22 01:41:19');
INSERT INTO `recommend` VALUES (517, 'new', 18, 777, '2011-12-07 13:27:13', '2008-10-05 21:58:27');
INSERT INTO `recommend` VALUES (518, 'new', 14, 760, '2010-06-18 20:39:06', '2019-05-19 02:50:25');
INSERT INTO `recommend` VALUES (519, 'hot', 14, 557, '2011-04-27 07:43:40', '2024-05-04 10:02:22');
INSERT INTO `recommend` VALUES (520, 'hot', 8, 340, '2019-07-19 07:59:44', '2009-11-16 19:49:04');
INSERT INTO `recommend` VALUES (521, 'hot', 12, 642, '2009-03-02 18:08:52', '2018-08-14 01:38:53');
INSERT INTO `recommend` VALUES (522, 'new', 38, 247, '2014-10-16 05:49:03', '2005-11-26 10:05:17');
INSERT INTO `recommend` VALUES (523, 'banner', 9, 640, '2005-10-23 00:21:27', '2022-10-16 19:16:00');
INSERT INTO `recommend` VALUES (524, 'new', 19, 519, '2014-07-30 04:00:12', '2015-09-27 02:29:38');
INSERT INTO `recommend` VALUES (525, 'banner', 12, 897, '2022-02-22 11:44:59', '2020-04-11 22:38:37');
INSERT INTO `recommend` VALUES (526, 'banner', 37, 815, '2004-05-01 19:33:46', '2020-09-04 08:40:41');
INSERT INTO `recommend` VALUES (527, 'new', 43, 142, '2014-08-12 00:23:23', '2010-11-14 07:41:18');
INSERT INTO `recommend` VALUES (528, 'new', 7, 53, '2024-05-10 15:14:03', '2016-05-03 17:34:29');
INSERT INTO `recommend` VALUES (529, 'hot', 32, 624, '2002-08-29 09:50:45', '2002-06-17 11:24:19');
INSERT INTO `recommend` VALUES (530, 'hot', 21, 694, '2016-06-12 07:33:08', '2000-12-07 11:02:10');
INSERT INTO `recommend` VALUES (531, 'new', 1, 553, '2011-02-22 04:03:57', '2008-04-04 14:45:49');
INSERT INTO `recommend` VALUES (532, 'banner', 6, 525, '2004-12-28 14:35:39', '2012-12-11 11:32:38');
INSERT INTO `recommend` VALUES (533, 'hot', 29, 404, '2011-07-21 09:21:40', '2022-07-14 14:46:44');
INSERT INTO `recommend` VALUES (534, 'hot', 5, 998, '2013-05-06 10:27:28', '2002-01-12 02:46:11');
INSERT INTO `recommend` VALUES (535, 'hot', 4, 644, '2017-08-25 11:43:18', '2007-02-22 10:01:25');
INSERT INTO `recommend` VALUES (536, 'banner', 8, 416, '2003-02-15 15:25:52', '2003-09-22 00:04:03');
INSERT INTO `recommend` VALUES (537, 'hot', 35, 500, '2004-01-02 07:57:00', '2014-10-16 03:31:01');
INSERT INTO `recommend` VALUES (538, 'new', 1, 457, '2025-04-19 23:31:26', '2002-05-02 21:28:15');
INSERT INTO `recommend` VALUES (539, 'hot', 35, 499, '2025-10-26 10:14:27', '2005-11-24 03:09:38');
INSERT INTO `recommend` VALUES (540, 'banner', 25, 710, '2007-07-21 16:24:27', '2019-05-05 10:44:16');
INSERT INTO `recommend` VALUES (541, 'banner', 23, 942, '2002-07-22 00:23:12', '2024-12-10 23:51:58');
INSERT INTO `recommend` VALUES (542, 'banner', 28, 948, '2019-04-23 02:38:35', '2016-04-16 05:15:51');
INSERT INTO `recommend` VALUES (543, 'banner', 11, 698, '2003-06-16 04:03:35', '2014-10-13 19:57:51');
INSERT INTO `recommend` VALUES (544, 'new', 31, 65, '2010-11-18 01:11:32', '2007-05-31 02:07:53');
INSERT INTO `recommend` VALUES (545, 'banner', 24, 292, '2023-02-13 13:05:50', '2023-02-06 23:44:07');
INSERT INTO `recommend` VALUES (546, 'new', 20, 347, '2016-09-23 17:52:28', '2011-08-05 01:19:04');
INSERT INTO `recommend` VALUES (547, 'hot', 26, 429, '2024-07-29 07:21:46', '2009-12-18 08:04:47');
INSERT INTO `recommend` VALUES (548, 'new', 17, 297, '2012-10-19 01:34:36', '2020-12-05 05:30:01');
INSERT INTO `recommend` VALUES (549, 'new', 15, 3, '2001-04-16 12:00:02', '2001-05-10 02:57:47');
INSERT INTO `recommend` VALUES (550, 'new', 35, 342, '2024-06-19 05:32:02', '2009-03-08 05:02:33');
INSERT INTO `recommend` VALUES (551, 'banner', 42, 645, '2009-01-29 23:25:49', '2020-05-07 18:01:32');
INSERT INTO `recommend` VALUES (552, 'new', 1, 970, '2018-10-23 09:26:20', '2013-09-24 14:59:08');
INSERT INTO `recommend` VALUES (553, 'banner', 33, 350, '2009-08-22 23:05:01', '2011-05-02 08:33:20');
INSERT INTO `recommend` VALUES (554, 'new', 8, 846, '2010-03-14 09:47:54', '2004-01-12 22:32:01');
INSERT INTO `recommend` VALUES (555, 'banner', 6, 719, '2011-06-07 07:38:31', '2009-09-14 13:58:16');
INSERT INTO `recommend` VALUES (556, 'hot', 9, 154, '2017-09-06 14:33:07', '2010-06-18 12:56:31');
INSERT INTO `recommend` VALUES (557, 'hot', 30, 28, '2002-06-05 09:45:28', '2004-11-26 15:50:50');
INSERT INTO `recommend` VALUES (558, 'banner', 23, 10, '2020-08-03 03:47:46', '2008-05-28 12:50:58');
INSERT INTO `recommend` VALUES (559, 'new', 18, 318, '2010-03-30 14:20:52', '2006-02-09 18:26:35');
INSERT INTO `recommend` VALUES (560, 'new', 6, 660, '2002-12-28 11:07:36', '2008-04-25 22:49:22');
INSERT INTO `recommend` VALUES (561, 'hot', 5, 834, '2022-02-28 22:09:59', '2022-08-07 18:25:40');
INSERT INTO `recommend` VALUES (562, 'banner', 26, 701, '2002-04-15 04:21:27', '2022-08-17 14:35:22');
INSERT INTO `recommend` VALUES (563, 'new', 34, 962, '2001-01-29 05:24:52', '2005-10-11 16:10:36');
INSERT INTO `recommend` VALUES (564, 'banner', 29, 68, '2006-08-01 06:11:03', '2013-09-24 06:54:35');
INSERT INTO `recommend` VALUES (565, 'new', 23, 180, '2023-01-19 03:41:19', '2019-02-03 06:41:01');
INSERT INTO `recommend` VALUES (566, 'new', 34, 920, '2018-04-09 12:06:12', '2009-09-28 04:54:58');
INSERT INTO `recommend` VALUES (567, 'new', 6, 21, '2013-02-14 23:04:08', '2013-01-14 00:55:44');
INSERT INTO `recommend` VALUES (568, 'banner', 26, 578, '2023-05-18 17:08:50', '2011-11-11 19:45:40');
INSERT INTO `recommend` VALUES (569, 'new', 39, 795, '2004-09-28 21:23:38', '2007-11-11 07:53:06');
INSERT INTO `recommend` VALUES (570, 'new', 37, 873, '2002-02-02 15:57:50', '2011-02-06 19:36:49');
INSERT INTO `recommend` VALUES (571, 'hot', 36, 122, '2014-03-30 01:30:24', '2005-11-22 22:46:25');
INSERT INTO `recommend` VALUES (572, 'hot', 34, 128, '2012-07-08 18:49:51', '2009-08-11 22:28:24');
INSERT INTO `recommend` VALUES (573, 'new', 20, 880, '2001-09-08 12:02:12', '2017-11-15 15:41:19');
INSERT INTO `recommend` VALUES (574, 'banner', 24, 40, '2022-08-21 02:04:23', '2010-05-07 21:01:01');
INSERT INTO `recommend` VALUES (575, 'hot', 12, 750, '2004-04-08 17:59:56', '2004-08-26 05:15:34');
INSERT INTO `recommend` VALUES (576, 'hot', 5, 736, '2021-07-02 04:07:57', '2021-04-04 06:03:08');
INSERT INTO `recommend` VALUES (577, 'hot', 33, 227, '2006-11-06 20:07:56', '2011-07-28 19:00:03');
INSERT INTO `recommend` VALUES (578, 'hot', 21, 566, '2001-12-23 23:41:20', '2003-07-22 04:48:02');
INSERT INTO `recommend` VALUES (579, 'hot', 21, 131, '2011-07-21 22:59:03', '2018-06-04 01:29:19');
INSERT INTO `recommend` VALUES (580, 'new', 32, 577, '2000-06-26 20:26:09', '2024-04-25 09:48:00');
INSERT INTO `recommend` VALUES (581, 'hot', 23, 679, '2014-11-19 01:49:52', '2000-10-31 19:36:37');
INSERT INTO `recommend` VALUES (582, 'banner', 8, 673, '2003-03-18 17:42:58', '2001-06-16 08:56:29');
INSERT INTO `recommend` VALUES (583, 'banner', 21, 921, '2002-04-13 10:31:22', '2019-01-31 00:57:53');
INSERT INTO `recommend` VALUES (584, 'banner', 17, 344, '2004-12-03 10:27:19', '2015-07-29 13:33:43');
INSERT INTO `recommend` VALUES (585, 'hot', 33, 969, '2019-04-12 18:00:52', '2001-12-12 17:07:49');
INSERT INTO `recommend` VALUES (586, 'new', 43, 234, '2022-12-28 19:18:42', '2001-11-04 04:52:38');
INSERT INTO `recommend` VALUES (587, 'hot', 11, 932, '2010-06-22 03:45:00', '2013-07-22 23:42:49');
INSERT INTO `recommend` VALUES (588, 'hot', 24, 909, '2009-05-29 09:52:22', '2013-08-29 08:51:03');
INSERT INTO `recommend` VALUES (589, 'banner', 15, 151, '2003-11-23 15:46:38', '2021-04-28 23:33:21');
INSERT INTO `recommend` VALUES (590, 'hot', 32, 515, '2018-10-05 21:38:41', '2023-06-17 13:35:42');
INSERT INTO `recommend` VALUES (591, 'new', 18, 352, '2007-02-23 05:39:59', '2022-01-27 18:07:20');
INSERT INTO `recommend` VALUES (592, 'hot', 18, 750, '2009-12-20 22:36:46', '2007-05-13 11:37:07');
INSERT INTO `recommend` VALUES (593, 'new', 24, 778, '2013-11-18 11:16:15', '2010-03-06 22:59:44');
INSERT INTO `recommend` VALUES (594, 'hot', 5, 480, '2022-04-27 17:34:07', '2000-07-24 15:46:52');
INSERT INTO `recommend` VALUES (595, 'banner', 24, 881, '2023-12-01 10:52:23', '2020-08-28 02:18:49');
INSERT INTO `recommend` VALUES (596, 'new', 5, 843, '2011-01-04 08:12:56', '2000-06-03 00:39:35');
INSERT INTO `recommend` VALUES (597, 'banner', 40, 357, '2019-08-09 10:17:59', '2005-07-29 03:51:34');
INSERT INTO `recommend` VALUES (598, 'banner', 38, 56, '2024-11-06 19:02:55', '2012-04-18 12:36:24');
INSERT INTO `recommend` VALUES (599, 'new', 18, 117, '2024-07-07 12:05:43', '2009-07-03 23:22:23');
INSERT INTO `recommend` VALUES (600, 'hot', 16, 301, '2014-05-08 17:47:07', '2015-03-27 16:05:48');
INSERT INTO `recommend` VALUES (601, 'new', 13, 512, '2015-01-23 23:31:33', '2003-10-13 22:10:29');
INSERT INTO `recommend` VALUES (602, 'hot', 22, 293, '2002-09-14 11:18:13', '2005-11-17 00:33:11');
INSERT INTO `recommend` VALUES (603, 'hot', 27, 419, '2000-02-04 02:57:27', '2010-04-08 04:10:35');
INSERT INTO `recommend` VALUES (604, 'new', 35, 758, '2013-08-28 23:48:50', '2014-11-05 20:19:47');
INSERT INTO `recommend` VALUES (605, 'banner', 14, 595, '2021-03-08 11:44:51', '2024-10-27 08:36:37');
INSERT INTO `recommend` VALUES (606, 'new', 35, 272, '2004-04-28 07:06:17', '2014-07-17 08:27:08');
INSERT INTO `recommend` VALUES (607, 'banner', 8, 719, '2024-12-17 02:07:41', '2015-08-20 09:26:30');
INSERT INTO `recommend` VALUES (608, 'new', 30, 566, '2020-09-25 23:53:20', '2011-01-02 20:14:23');
INSERT INTO `recommend` VALUES (609, 'new', 10, 791, '2013-08-14 08:21:48', '2018-05-01 05:24:06');
INSERT INTO `recommend` VALUES (610, 'new', 39, 118, '2020-04-12 04:07:05', '2001-11-06 15:18:25');
INSERT INTO `recommend` VALUES (611, 'new', 12, 246, '2005-02-21 23:44:58', '2001-05-23 14:58:47');
INSERT INTO `recommend` VALUES (612, 'hot', 28, 489, '2023-08-19 08:30:52', '2005-04-20 18:00:09');
INSERT INTO `recommend` VALUES (613, 'new', 28, 276, '2007-02-28 17:00:32', '2019-03-24 21:08:13');
INSERT INTO `recommend` VALUES (614, 'new', 41, 126, '2009-10-18 03:25:43', '2011-05-04 11:40:45');
INSERT INTO `recommend` VALUES (615, 'new', 40, 147, '2015-12-23 11:33:23', '2008-12-10 17:32:40');
INSERT INTO `recommend` VALUES (616, 'new', 12, 872, '2009-02-09 14:24:05', '2009-06-08 02:37:22');
INSERT INTO `recommend` VALUES (617, 'new', 3, 446, '2021-11-15 00:31:10', '2004-08-09 14:37:05');
INSERT INTO `recommend` VALUES (618, 'banner', 30, 775, '2014-08-23 16:19:29', '2012-08-07 09:43:43');
INSERT INTO `recommend` VALUES (619, 'hot', 36, 248, '2021-08-31 17:07:02', '2016-10-14 18:31:59');
INSERT INTO `recommend` VALUES (620, 'new', 36, 124, '2007-02-16 08:28:56', '2012-09-03 02:32:03');
INSERT INTO `recommend` VALUES (621, 'new', 36, 647, '2024-11-25 02:07:26', '2013-06-09 11:24:15');
INSERT INTO `recommend` VALUES (622, 'banner', 13, 696, '2024-12-29 04:57:18', '2008-10-08 23:36:40');
INSERT INTO `recommend` VALUES (623, 'new', 40, 355, '2017-07-15 08:08:48', '2020-03-13 01:07:54');
INSERT INTO `recommend` VALUES (624, 'banner', 21, 673, '2005-01-16 13:42:02', '2003-09-21 11:23:26');
INSERT INTO `recommend` VALUES (625, 'banner', 3, 834, '2024-02-19 12:19:49', '2025-11-28 07:18:59');
INSERT INTO `recommend` VALUES (626, 'new', 10, 208, '2011-08-28 06:41:09', '2015-05-24 01:33:42');
INSERT INTO `recommend` VALUES (627, 'new', 25, 336, '2013-06-02 10:24:40', '2011-10-30 19:08:29');
INSERT INTO `recommend` VALUES (628, 'banner', 1, 603, '2016-01-08 18:18:42', '2022-01-20 13:58:56');
INSERT INTO `recommend` VALUES (629, 'new', 26, 575, '2002-02-16 12:26:22', '2024-09-16 04:58:51');
INSERT INTO `recommend` VALUES (630, 'banner', 1, 787, '2005-04-05 20:15:39', '2024-02-26 03:33:07');
INSERT INTO `recommend` VALUES (631, 'banner', 36, 835, '2002-04-15 12:55:38', '2003-03-30 14:13:05');
INSERT INTO `recommend` VALUES (632, 'banner', 35, 145, '2019-06-18 11:31:50', '2002-02-18 23:50:50');
INSERT INTO `recommend` VALUES (633, 'new', 38, 964, '2023-12-25 09:23:56', '2011-05-16 08:36:49');
INSERT INTO `recommend` VALUES (634, 'banner', 36, 161, '2019-04-25 00:33:04', '2006-10-11 22:12:55');
INSERT INTO `recommend` VALUES (635, 'banner', 10, 851, '2005-02-19 05:07:34', '2016-05-22 03:41:22');
INSERT INTO `recommend` VALUES (636, 'hot', 22, 355, '2025-10-25 10:10:44', '2008-10-07 19:22:16');
INSERT INTO `recommend` VALUES (637, 'hot', 2, 429, '2005-11-15 15:43:38', '2013-05-07 02:29:24');
INSERT INTO `recommend` VALUES (638, 'banner', 27, 21, '2025-10-03 18:47:06', '2000-12-21 03:10:35');
INSERT INTO `recommend` VALUES (639, 'new', 5, 857, '2011-12-28 13:14:51', '2011-05-17 16:54:13');
INSERT INTO `recommend` VALUES (640, 'hot', 23, 168, '2006-08-24 17:52:34', '2019-11-19 06:55:54');
INSERT INTO `recommend` VALUES (641, 'banner', 28, 343, '2018-03-07 13:09:11', '2013-06-28 00:58:32');
INSERT INTO `recommend` VALUES (642, 'hot', 14, 895, '2009-08-13 12:49:50', '2019-11-16 22:04:31');
INSERT INTO `recommend` VALUES (643, 'banner', 2, 709, '2011-01-24 06:18:12', '2014-09-04 19:37:36');
INSERT INTO `recommend` VALUES (644, 'banner', 29, 190, '2004-01-31 12:45:15', '2016-05-26 18:02:31');
INSERT INTO `recommend` VALUES (645, 'new', 8, 999, '2007-08-29 00:09:20', '2020-12-04 06:43:13');
INSERT INTO `recommend` VALUES (646, 'banner', 36, 555, '2010-12-16 15:28:49', '2021-09-07 22:35:56');
INSERT INTO `recommend` VALUES (647, 'hot', 25, 185, '2006-02-03 06:43:41', '2012-04-26 15:02:16');
INSERT INTO `recommend` VALUES (648, 'hot', 14, 384, '2008-10-31 22:22:31', '2011-04-02 16:08:01');
INSERT INTO `recommend` VALUES (649, 'new', 17, 2, '2021-05-03 22:42:54', '2022-11-29 09:40:09');
INSERT INTO `recommend` VALUES (650, 'new', 18, 366, '2019-11-07 14:55:23', '2013-07-02 02:29:39');
INSERT INTO `recommend` VALUES (651, 'banner', 30, 389, '2025-05-24 13:26:33', '2022-02-12 18:57:49');
INSERT INTO `recommend` VALUES (652, 'banner', 39, 853, '2016-09-11 12:24:40', '2015-09-02 07:21:28');
INSERT INTO `recommend` VALUES (653, 'new', 14, 96, '2012-05-04 22:40:55', '2015-11-08 05:02:58');
INSERT INTO `recommend` VALUES (654, 'banner', 5, 610, '2014-02-03 18:40:39', '2009-10-14 08:30:30');
INSERT INTO `recommend` VALUES (655, 'new', 18, 244, '2001-06-27 01:46:32', '2006-12-10 17:59:57');
INSERT INTO `recommend` VALUES (656, 'new', 34, 57, '2003-05-11 11:22:44', '2018-07-14 17:13:15');
INSERT INTO `recommend` VALUES (657, 'hot', 8, 287, '2005-11-19 08:28:39', '2013-06-01 06:50:04');
INSERT INTO `recommend` VALUES (658, 'hot', 36, 257, '2014-09-06 20:00:03', '2024-03-19 15:21:30');
INSERT INTO `recommend` VALUES (659, 'banner', 33, 310, '2004-05-31 22:03:43', '2025-12-02 19:53:25');
INSERT INTO `recommend` VALUES (660, 'new', 8, 35, '2006-02-22 13:37:21', '2019-08-28 01:14:42');
INSERT INTO `recommend` VALUES (661, 'banner', 6, 537, '2024-03-11 02:17:41', '2001-01-31 09:01:33');
INSERT INTO `recommend` VALUES (662, 'new', 31, 163, '2011-12-02 15:56:18', '2021-01-01 01:26:09');
INSERT INTO `recommend` VALUES (663, 'hot', 30, 121, '2001-05-12 08:19:48', '2017-01-25 23:23:25');
INSERT INTO `recommend` VALUES (664, 'new', 31, 993, '2011-08-10 16:56:03', '2006-01-23 17:32:37');
INSERT INTO `recommend` VALUES (665, 'hot', 9, 968, '2013-06-28 12:12:10', '2010-10-24 12:20:10');
INSERT INTO `recommend` VALUES (666, 'new', 42, 535, '2006-06-12 11:17:58', '2012-07-11 03:34:40');
INSERT INTO `recommend` VALUES (667, 'hot', 2, 557, '2009-07-26 02:43:28', '2007-11-04 08:02:03');
INSERT INTO `recommend` VALUES (668, 'banner', 12, 118, '2017-11-04 20:48:35', '2015-11-17 20:40:54');
INSERT INTO `recommend` VALUES (669, 'hot', 5, 740, '2000-11-06 15:09:06', '2002-04-04 04:20:24');
INSERT INTO `recommend` VALUES (670, 'hot', 9, 139, '2020-02-25 23:00:22', '2023-11-09 16:06:47');
INSERT INTO `recommend` VALUES (671, 'banner', 35, 875, '2011-07-25 03:46:30', '2012-11-06 08:26:01');
INSERT INTO `recommend` VALUES (672, 'hot', 7, 457, '2023-04-19 16:43:38', '2009-04-06 09:48:08');
INSERT INTO `recommend` VALUES (673, 'new', 41, 541, '2022-12-30 02:24:48', '2015-06-05 17:24:15');
INSERT INTO `recommend` VALUES (674, 'banner', 30, 472, '2003-05-28 21:14:25', '2001-10-09 02:53:48');
INSERT INTO `recommend` VALUES (675, 'banner', 18, 296, '2019-08-09 13:29:08', '2012-07-31 15:42:29');
INSERT INTO `recommend` VALUES (676, 'banner', 36, 58, '2024-02-27 11:25:25', '2011-11-09 23:09:08');
INSERT INTO `recommend` VALUES (677, 'new', 43, 666, '2022-10-18 09:51:51', '2012-11-20 06:06:17');
INSERT INTO `recommend` VALUES (678, 'banner', 31, 249, '2016-06-09 00:34:24', '2021-10-11 21:39:46');
INSERT INTO `recommend` VALUES (679, 'banner', 2, 548, '2020-04-27 13:59:17', '2000-04-05 21:39:47');
INSERT INTO `recommend` VALUES (680, 'new', 36, 991, '2011-07-25 16:04:01', '2001-11-24 09:59:22');
INSERT INTO `recommend` VALUES (681, 'banner', 7, 521, '2021-04-18 06:00:58', '2023-09-04 17:09:11');
INSERT INTO `recommend` VALUES (682, 'banner', 22, 762, '2006-02-08 13:38:39', '2024-10-28 15:16:26');
INSERT INTO `recommend` VALUES (683, 'hot', 19, 692, '2025-04-12 04:05:14', '2009-03-13 16:47:48');
INSERT INTO `recommend` VALUES (684, 'new', 30, 321, '2016-01-30 17:07:28', '2025-04-29 10:50:27');
INSERT INTO `recommend` VALUES (685, 'banner', 11, 461, '2009-04-19 10:39:02', '2013-11-22 19:06:14');
INSERT INTO `recommend` VALUES (686, 'banner', 24, 103, '2014-02-27 10:50:17', '2002-06-27 04:47:32');
INSERT INTO `recommend` VALUES (687, 'banner', 9, 730, '2017-07-28 02:41:26', '2009-01-13 05:50:22');
INSERT INTO `recommend` VALUES (688, 'hot', 25, 569, '2025-04-29 16:54:47', '2024-12-24 21:51:22');
INSERT INTO `recommend` VALUES (689, 'hot', 38, 632, '2002-01-07 13:22:29', '2019-10-17 22:34:37');
INSERT INTO `recommend` VALUES (690, 'hot', 15, 496, '2013-04-17 08:37:27', '2012-08-12 02:32:14');
INSERT INTO `recommend` VALUES (691, 'banner', 13, 649, '2001-12-19 15:47:48', '2016-10-12 18:03:46');
INSERT INTO `recommend` VALUES (692, 'hot', 23, 909, '2018-12-15 18:55:44', '2025-08-27 11:47:25');
INSERT INTO `recommend` VALUES (693, 'hot', 18, 556, '2019-02-13 20:18:48', '2012-12-28 07:44:53');
INSERT INTO `recommend` VALUES (694, 'banner', 8, 882, '2019-10-22 05:24:15', '2007-07-19 04:14:08');
INSERT INTO `recommend` VALUES (695, 'hot', 43, 17, '2018-11-29 12:39:37', '2009-09-06 22:21:54');
INSERT INTO `recommend` VALUES (696, 'hot', 43, 857, '2010-04-16 22:02:30', '2025-04-06 23:42:41');
INSERT INTO `recommend` VALUES (697, 'hot', 30, 40, '2017-06-02 03:37:26', '2020-04-29 03:17:29');
INSERT INTO `recommend` VALUES (698, 'new', 22, 931, '2012-03-16 05:48:32', '2004-05-27 18:28:17');
INSERT INTO `recommend` VALUES (699, 'hot', 19, 960, '2021-10-21 16:45:49', '2011-07-05 18:16:15');
INSERT INTO `recommend` VALUES (700, 'new', 4, 368, '2021-03-21 05:44:25', '2017-08-18 20:12:58');
INSERT INTO `recommend` VALUES (701, 'hot', 6, 494, '2002-08-28 22:27:55', '2000-07-13 19:02:25');
INSERT INTO `recommend` VALUES (702, 'hot', 42, 36, '2009-03-31 12:11:10', '2012-09-14 12:22:47');
INSERT INTO `recommend` VALUES (703, 'banner', 41, 848, '2002-07-24 16:23:42', '2008-12-05 04:14:06');
INSERT INTO `recommend` VALUES (704, 'banner', 19, 755, '2022-07-23 23:40:48', '2015-03-28 06:16:54');
INSERT INTO `recommend` VALUES (705, 'banner', 22, 416, '2024-08-07 14:45:56', '2000-07-27 09:58:13');
INSERT INTO `recommend` VALUES (706, 'banner', 43, 942, '2022-08-01 22:20:21', '2020-07-18 02:06:38');
INSERT INTO `recommend` VALUES (707, 'new', 16, 778, '2017-12-25 13:30:55', '2024-10-22 09:15:20');
INSERT INTO `recommend` VALUES (708, 'hot', 33, 846, '2020-12-13 00:46:04', '2023-09-13 15:49:47');
INSERT INTO `recommend` VALUES (709, 'new', 12, 862, '2022-05-28 13:30:13', '2002-10-26 17:33:49');
INSERT INTO `recommend` VALUES (710, 'banner', 10, 234, '2016-09-21 16:15:12', '2022-11-19 16:33:30');
INSERT INTO `recommend` VALUES (711, 'banner', 30, 415, '2015-03-10 13:33:12', '2009-02-02 20:17:41');
INSERT INTO `recommend` VALUES (712, 'hot', 20, 717, '2011-07-24 01:31:45', '2007-07-14 21:49:46');
INSERT INTO `recommend` VALUES (713, 'banner', 22, 368, '2017-04-20 02:38:23', '2025-03-07 05:01:05');
INSERT INTO `recommend` VALUES (714, 'new', 31, 96, '2024-12-25 17:22:38', '2022-05-31 22:10:13');
INSERT INTO `recommend` VALUES (715, 'new', 26, 92, '2006-02-02 18:16:28', '2012-01-10 04:59:19');
INSERT INTO `recommend` VALUES (716, 'banner', 19, 557, '2022-08-19 03:22:17', '2022-06-13 22:53:30');
INSERT INTO `recommend` VALUES (717, 'new', 28, 833, '2020-04-16 21:21:01', '2003-06-22 21:44:48');
INSERT INTO `recommend` VALUES (718, 'banner', 40, 628, '2000-12-15 18:17:56', '2024-05-29 13:13:34');
INSERT INTO `recommend` VALUES (719, 'hot', 14, 797, '2011-02-07 09:17:26', '2004-06-02 17:25:54');
INSERT INTO `recommend` VALUES (720, 'hot', 1, 791, '2020-06-25 06:09:08', '2019-05-16 12:15:35');
INSERT INTO `recommend` VALUES (721, 'new', 18, 794, '2013-08-27 08:44:44', '2015-05-25 02:07:49');
INSERT INTO `recommend` VALUES (722, 'hot', 9, 510, '2025-09-03 06:20:33', '2009-05-31 20:34:55');
INSERT INTO `recommend` VALUES (723, 'new', 16, 113, '2003-05-21 03:24:37', '2007-06-02 17:49:54');
INSERT INTO `recommend` VALUES (724, 'hot', 43, 512, '2002-02-09 22:56:34', '2024-01-16 06:24:56');
INSERT INTO `recommend` VALUES (725, 'hot', 2, 556, '2013-08-19 09:04:10', '2022-05-27 12:51:56');
INSERT INTO `recommend` VALUES (726, 'banner', 25, 1000, '2022-12-05 18:11:10', '2018-09-25 23:44:55');
INSERT INTO `recommend` VALUES (727, 'new', 1, 563, '2009-02-12 19:51:34', '2024-11-08 10:34:28');
INSERT INTO `recommend` VALUES (728, 'hot', 19, 449, '2015-04-07 09:46:31', '2006-04-22 00:34:18');
INSERT INTO `recommend` VALUES (729, 'hot', 21, 838, '2012-09-27 06:34:02', '2011-04-12 23:41:44');
INSERT INTO `recommend` VALUES (730, 'banner', 3, 386, '2010-06-07 14:47:31', '2011-12-27 15:00:18');
INSERT INTO `recommend` VALUES (731, 'hot', 34, 756, '2023-09-20 12:51:28', '2022-01-06 10:48:37');
INSERT INTO `recommend` VALUES (732, 'new', 10, 221, '2003-04-06 19:52:19', '2018-07-11 19:12:07');
INSERT INTO `recommend` VALUES (733, 'hot', 29, 661, '2006-08-24 18:55:58', '2002-11-17 13:05:51');
INSERT INTO `recommend` VALUES (734, 'hot', 26, 292, '2010-04-06 10:48:54', '2024-12-06 15:36:59');
INSERT INTO `recommend` VALUES (735, 'new', 27, 413, '2001-12-10 20:06:07', '2010-04-11 22:27:50');
INSERT INTO `recommend` VALUES (736, 'hot', 10, 223, '2002-09-21 09:09:19', '2013-12-28 03:51:44');
INSERT INTO `recommend` VALUES (737, 'banner', 19, 700, '2001-02-20 11:37:49', '2012-08-20 23:49:27');
INSERT INTO `recommend` VALUES (738, 'new', 28, 370, '2024-10-08 08:42:55', '2019-05-09 12:32:20');
INSERT INTO `recommend` VALUES (739, 'new', 6, 981, '2005-10-28 12:06:31', '2016-01-06 07:20:34');
INSERT INTO `recommend` VALUES (740, 'banner', 42, 803, '2017-03-25 00:30:09', '2022-02-16 13:16:29');
INSERT INTO `recommend` VALUES (741, 'new', 5, 770, '2002-02-15 15:46:45', '2019-03-10 01:46:14');
INSERT INTO `recommend` VALUES (742, 'new', 27, 78, '2002-08-15 10:47:42', '2021-01-06 15:04:50');
INSERT INTO `recommend` VALUES (743, 'banner', 12, 42, '2005-01-02 18:21:19', '2018-03-20 18:31:56');
INSERT INTO `recommend` VALUES (744, 'new', 19, 66, '2014-09-08 03:26:54', '2011-11-10 11:16:15');
INSERT INTO `recommend` VALUES (745, 'new', 6, 724, '2001-03-10 14:35:41', '2003-12-10 08:47:33');
INSERT INTO `recommend` VALUES (746, 'banner', 24, 502, '2003-10-27 21:36:22', '2025-03-03 00:05:28');
INSERT INTO `recommend` VALUES (747, 'banner', 35, 318, '2000-04-17 20:24:34', '2018-12-28 06:57:18');
INSERT INTO `recommend` VALUES (748, 'banner', 20, 970, '2014-03-02 23:25:51', '2016-11-14 08:27:35');
INSERT INTO `recommend` VALUES (749, 'banner', 29, 101, '2025-10-10 05:14:36', '2011-09-04 03:13:15');
INSERT INTO `recommend` VALUES (750, 'hot', 35, 284, '2020-07-28 18:32:56', '2012-08-15 02:52:15');
INSERT INTO `recommend` VALUES (751, 'new', 7, 735, '2025-05-03 13:03:41', '2010-01-02 18:38:23');
INSERT INTO `recommend` VALUES (752, 'banner', 28, 897, '2011-07-25 23:13:59', '2021-06-19 06:44:46');
INSERT INTO `recommend` VALUES (753, 'banner', 38, 600, '2002-11-04 13:07:04', '2012-06-05 00:00:41');
INSERT INTO `recommend` VALUES (754, 'new', 25, 296, '2020-05-09 09:59:49', '2000-04-02 20:53:58');
INSERT INTO `recommend` VALUES (755, 'hot', 3, 497, '2025-03-17 11:48:14', '2007-12-26 08:36:57');
INSERT INTO `recommend` VALUES (756, 'banner', 41, 807, '2020-03-20 01:39:18', '2002-07-07 11:00:38');
INSERT INTO `recommend` VALUES (757, 'banner', 1, 414, '2011-05-14 02:24:57', '2009-06-02 15:43:30');
INSERT INTO `recommend` VALUES (758, 'hot', 8, 159, '2018-10-22 09:29:53', '2019-09-16 11:22:00');
INSERT INTO `recommend` VALUES (759, 'hot', 5, 985, '2012-06-14 10:08:03', '2013-10-07 15:34:54');
INSERT INTO `recommend` VALUES (760, 'banner', 32, 520, '2018-12-10 07:37:29', '2002-04-18 07:17:13');
INSERT INTO `recommend` VALUES (761, 'new', 28, 358, '2003-02-16 23:58:57', '2006-11-14 03:32:21');
INSERT INTO `recommend` VALUES (762, 'new', 9, 951, '2011-09-20 04:25:53', '2004-08-25 15:13:56');
INSERT INTO `recommend` VALUES (763, 'banner', 13, 473, '2013-10-01 22:43:26', '2000-01-03 21:18:56');
INSERT INTO `recommend` VALUES (764, 'new', 21, 849, '2011-10-23 23:10:31', '2007-10-07 04:49:04');
INSERT INTO `recommend` VALUES (765, 'new', 38, 898, '2004-10-11 08:19:41', '2009-05-04 06:13:21');
INSERT INTO `recommend` VALUES (766, 'banner', 37, 822, '2021-02-24 06:00:10', '2016-02-24 01:05:40');
INSERT INTO `recommend` VALUES (767, 'hot', 24, 424, '2012-11-13 13:46:13', '2021-10-01 05:54:08');
INSERT INTO `recommend` VALUES (768, 'hot', 22, 399, '2023-09-03 16:18:11', '2010-09-14 16:22:21');
INSERT INTO `recommend` VALUES (769, 'banner', 34, 949, '2020-01-18 10:37:41', '2013-09-12 00:36:04');
INSERT INTO `recommend` VALUES (770, 'banner', 22, 146, '2014-04-24 03:01:48', '2020-01-01 03:51:13');
INSERT INTO `recommend` VALUES (771, 'banner', 22, 757, '2006-03-31 07:41:18', '2012-12-25 00:34:29');
INSERT INTO `recommend` VALUES (772, 'new', 17, 844, '2011-08-31 19:28:00', '2008-09-20 15:53:01');
INSERT INTO `recommend` VALUES (773, 'hot', 8, 335, '2001-03-03 14:10:10', '2014-08-13 06:39:57');
INSERT INTO `recommend` VALUES (774, 'new', 12, 137, '2020-08-14 18:32:47', '2025-07-02 09:08:48');
INSERT INTO `recommend` VALUES (775, 'hot', 22, 552, '2021-08-26 00:32:59', '2014-09-20 01:34:36');
INSERT INTO `recommend` VALUES (776, 'banner', 9, 968, '2021-06-04 23:18:45', '2019-06-06 18:11:40');
INSERT INTO `recommend` VALUES (777, 'new', 16, 906, '2009-01-13 01:53:48', '2015-11-10 06:04:25');
INSERT INTO `recommend` VALUES (778, 'new', 35, 954, '2012-06-19 13:53:28', '2003-07-05 22:55:39');
INSERT INTO `recommend` VALUES (779, 'new', 9, 732, '2007-02-20 22:08:18', '2004-01-31 14:01:29');
INSERT INTO `recommend` VALUES (780, 'new', 5, 107, '2009-12-21 06:28:21', '2011-02-07 15:14:25');
INSERT INTO `recommend` VALUES (781, 'new', 31, 258, '2014-09-25 23:05:03', '2024-08-24 09:25:10');
INSERT INTO `recommend` VALUES (782, 'hot', 8, 518, '2019-12-10 14:33:03', '2000-02-03 02:21:04');
INSERT INTO `recommend` VALUES (783, 'hot', 35, 935, '2003-08-02 23:11:37', '2018-11-22 21:43:57');
INSERT INTO `recommend` VALUES (784, 'new', 39, 131, '2021-10-01 17:51:56', '2010-11-27 17:03:51');
INSERT INTO `recommend` VALUES (785, 'new', 26, 737, '2009-08-10 16:00:50', '2013-07-13 05:10:32');
INSERT INTO `recommend` VALUES (786, 'new', 10, 611, '2024-10-26 03:35:42', '2009-06-14 13:31:36');
INSERT INTO `recommend` VALUES (787, 'hot', 24, 514, '2004-10-30 02:53:28', '2019-04-03 06:11:24');
INSERT INTO `recommend` VALUES (788, 'new', 38, 78, '2005-02-28 03:08:03', '2008-06-08 19:26:39');
INSERT INTO `recommend` VALUES (789, 'banner', 1, 533, '2003-01-04 06:43:07', '2025-04-07 15:09:58');
INSERT INTO `recommend` VALUES (790, 'banner', 10, 559, '2000-03-24 08:41:51', '2000-11-19 23:26:15');
INSERT INTO `recommend` VALUES (791, 'new', 27, 342, '2025-09-05 06:11:24', '2019-02-05 12:46:06');
INSERT INTO `recommend` VALUES (792, 'banner', 35, 47, '2025-05-29 05:16:41', '2019-12-28 06:27:22');
INSERT INTO `recommend` VALUES (793, 'banner', 23, 320, '2019-03-22 10:17:30', '2005-10-04 17:10:43');
INSERT INTO `recommend` VALUES (794, 'banner', 10, 900, '2003-04-21 13:41:11', '2013-03-12 05:47:08');
INSERT INTO `recommend` VALUES (795, 'hot', 43, 912, '2011-06-17 01:31:45', '2015-12-07 06:13:48');
INSERT INTO `recommend` VALUES (796, 'banner', 34, 72, '2019-07-14 07:03:22', '2005-03-12 05:20:56');
INSERT INTO `recommend` VALUES (797, 'new', 1, 965, '2024-04-08 07:51:59', '2002-10-31 00:06:15');
INSERT INTO `recommend` VALUES (798, 'new', 38, 936, '2019-08-08 12:02:12', '2010-11-02 08:53:35');
INSERT INTO `recommend` VALUES (799, 'new', 43, 101, '2004-07-22 17:09:52', '2017-11-13 18:20:11');
INSERT INTO `recommend` VALUES (800, 'new', 8, 641, '2013-06-03 08:36:25', '2006-07-09 09:40:47');
INSERT INTO `recommend` VALUES (801, 'new', 29, 941, '2001-05-12 21:25:18', '2007-12-03 08:40:05');
INSERT INTO `recommend` VALUES (802, 'hot', 14, 745, '2021-10-10 02:54:09', '2008-07-01 21:44:12');
INSERT INTO `recommend` VALUES (803, 'banner', 22, 922, '2017-08-25 10:26:26', '2017-10-31 22:21:25');
INSERT INTO `recommend` VALUES (804, 'new', 30, 980, '2014-08-28 16:43:54', '2003-01-06 17:42:29');
INSERT INTO `recommend` VALUES (805, 'new', 37, 115, '2024-02-28 15:59:04', '2021-12-11 07:11:49');
INSERT INTO `recommend` VALUES (806, 'banner', 31, 888, '2020-12-05 17:30:49', '2018-11-18 04:21:04');
INSERT INTO `recommend` VALUES (807, 'hot', 24, 620, '2003-11-16 11:51:55', '2025-11-14 08:51:11');
INSERT INTO `recommend` VALUES (808, 'banner', 1, 912, '2011-02-09 08:44:39', '2022-05-08 20:25:29');
INSERT INTO `recommend` VALUES (809, 'hot', 35, 653, '2000-08-31 07:55:28', '2014-05-31 04:06:58');
INSERT INTO `recommend` VALUES (810, 'banner', 6, 306, '2024-11-26 11:47:20', '2020-12-22 22:55:40');
INSERT INTO `recommend` VALUES (811, 'banner', 42, 679, '2019-04-29 23:01:54', '2019-01-11 21:26:35');
INSERT INTO `recommend` VALUES (812, 'banner', 11, 474, '2003-06-14 08:05:35', '2000-12-01 18:10:14');
INSERT INTO `recommend` VALUES (813, 'hot', 32, 544, '2010-01-19 20:28:22', '2005-08-01 18:43:19');
INSERT INTO `recommend` VALUES (814, 'hot', 41, 472, '2003-12-11 13:10:30', '2010-07-01 05:51:46');
INSERT INTO `recommend` VALUES (815, 'hot', 17, 621, '2009-11-04 17:12:40', '2024-02-05 21:05:00');
INSERT INTO `recommend` VALUES (816, 'hot', 31, 274, '2000-05-24 06:07:24', '2011-03-22 23:22:23');
INSERT INTO `recommend` VALUES (817, 'banner', 42, 842, '2003-02-17 12:52:16', '2020-08-26 13:08:42');
INSERT INTO `recommend` VALUES (818, 'hot', 34, 295, '2018-12-09 08:15:54', '2015-01-23 22:32:17');
INSERT INTO `recommend` VALUES (819, 'hot', 4, 17, '2018-03-11 14:40:19', '2006-07-13 15:27:38');
INSERT INTO `recommend` VALUES (820, 'new', 43, 405, '2007-10-29 08:27:08', '2016-03-21 09:51:43');
INSERT INTO `recommend` VALUES (821, 'banner', 15, 520, '2005-08-15 13:38:42', '2007-01-18 00:43:53');
INSERT INTO `recommend` VALUES (822, 'banner', 19, 686, '2001-02-18 22:06:32', '2025-05-03 22:45:03');
INSERT INTO `recommend` VALUES (823, 'hot', 39, 324, '2011-06-20 13:43:14', '2022-07-13 08:51:15');
INSERT INTO `recommend` VALUES (824, 'banner', 24, 986, '2012-07-10 09:17:20', '2021-12-31 21:53:32');
INSERT INTO `recommend` VALUES (825, 'new', 43, 894, '2005-07-09 11:08:37', '2003-10-31 19:45:17');
INSERT INTO `recommend` VALUES (826, 'hot', 21, 8, '2022-01-07 04:35:07', '2019-09-10 00:02:57');
INSERT INTO `recommend` VALUES (827, 'banner', 16, 664, '2003-02-19 15:11:45', '2011-04-13 09:56:42');
INSERT INTO `recommend` VALUES (828, 'hot', 27, 601, '2000-06-19 15:53:16', '2019-01-26 21:42:26');
INSERT INTO `recommend` VALUES (829, 'hot', 43, 570, '2006-12-09 10:34:06', '2012-09-29 20:26:15');
INSERT INTO `recommend` VALUES (830, 'hot', 29, 617, '2000-12-20 03:41:06', '2005-07-25 00:21:10');
INSERT INTO `recommend` VALUES (831, 'banner', 9, 815, '2005-11-25 05:15:53', '2005-12-31 03:17:39');
INSERT INTO `recommend` VALUES (832, 'new', 31, 15, '2008-09-03 04:31:47', '2001-05-06 02:08:25');
INSERT INTO `recommend` VALUES (833, 'banner', 39, 935, '2005-08-27 15:18:23', '2016-02-26 02:33:19');
INSERT INTO `recommend` VALUES (834, 'banner', 10, 961, '2018-06-07 13:08:46', '2025-03-25 09:25:15');
INSERT INTO `recommend` VALUES (835, 'new', 38, 715, '2009-07-30 14:52:23', '2007-02-02 10:23:20');
INSERT INTO `recommend` VALUES (836, 'hot', 34, 964, '2005-04-06 11:08:02', '2011-08-17 08:04:45');
INSERT INTO `recommend` VALUES (837, 'banner', 31, 23, '2022-11-04 00:44:23', '2011-04-12 05:33:37');
INSERT INTO `recommend` VALUES (838, 'banner', 26, 207, '2000-12-18 16:53:26', '2015-07-18 23:16:11');
INSERT INTO `recommend` VALUES (839, 'banner', 24, 276, '2016-01-15 07:20:36', '2006-12-13 07:16:59');
INSERT INTO `recommend` VALUES (840, 'hot', 10, 932, '2006-07-01 06:45:12', '2011-05-08 07:17:42');
INSERT INTO `recommend` VALUES (841, 'banner', 16, 537, '2014-09-17 04:10:28', '2021-04-02 16:10:36');
INSERT INTO `recommend` VALUES (842, 'new', 30, 677, '2017-05-15 14:17:45', '2001-12-11 09:11:54');
INSERT INTO `recommend` VALUES (843, 'banner', 12, 283, '2017-02-09 21:40:30', '2011-08-06 23:35:18');
INSERT INTO `recommend` VALUES (844, 'hot', 31, 593, '2019-06-08 06:25:32', '2012-10-25 05:04:55');
INSERT INTO `recommend` VALUES (845, 'new', 7, 560, '2019-09-07 04:29:00', '2000-04-10 21:13:37');
INSERT INTO `recommend` VALUES (846, 'hot', 42, 994, '2007-04-18 19:09:17', '2021-09-24 17:38:43');
INSERT INTO `recommend` VALUES (847, 'banner', 7, 675, '2012-02-28 20:49:34', '2004-12-28 06:50:15');
INSERT INTO `recommend` VALUES (848, 'new', 31, 34, '2014-01-20 22:10:05', '2004-08-15 07:25:01');
INSERT INTO `recommend` VALUES (849, 'hot', 43, 4, '2022-08-04 04:57:28', '2006-07-16 19:03:04');
INSERT INTO `recommend` VALUES (850, 'new', 40, 576, '2023-01-12 18:51:55', '2021-10-02 13:42:25');
INSERT INTO `recommend` VALUES (851, 'banner', 22, 178, '2013-07-17 06:38:38', '2014-02-17 07:50:34');
INSERT INTO `recommend` VALUES (852, 'hot', 41, 278, '2023-10-08 09:59:16', '2001-09-06 14:44:22');
INSERT INTO `recommend` VALUES (853, 'banner', 31, 907, '2012-09-20 19:14:05', '2015-10-16 20:54:39');
INSERT INTO `recommend` VALUES (854, 'banner', 24, 491, '2009-04-05 16:36:09', '2008-06-17 22:31:21');
INSERT INTO `recommend` VALUES (855, 'new', 20, 82, '2015-03-23 19:33:48', '2011-01-15 06:38:34');
INSERT INTO `recommend` VALUES (856, 'banner', 43, 465, '2025-01-22 19:04:37', '2001-06-09 13:08:32');
INSERT INTO `recommend` VALUES (857, 'new', 3, 5, '2007-01-28 15:39:12', '2016-08-03 05:01:49');
INSERT INTO `recommend` VALUES (858, 'banner', 35, 222, '2016-08-25 18:32:27', '2014-09-03 22:58:32');
INSERT INTO `recommend` VALUES (859, 'hot', 1, 366, '2009-04-30 14:14:26', '2018-11-13 19:35:08');
INSERT INTO `recommend` VALUES (860, 'hot', 29, 829, '2017-07-24 22:30:00', '2014-09-08 10:32:37');
INSERT INTO `recommend` VALUES (861, 'new', 34, 207, '2002-01-29 20:06:37', '2018-08-06 00:55:17');
INSERT INTO `recommend` VALUES (862, 'new', 9, 676, '2012-08-19 23:56:43', '2017-11-16 08:23:10');
INSERT INTO `recommend` VALUES (863, 'banner', 38, 632, '2012-07-05 18:28:39', '2012-04-26 14:43:15');
INSERT INTO `recommend` VALUES (864, 'hot', 7, 234, '2022-12-15 05:01:54', '2003-08-23 02:29:21');
INSERT INTO `recommend` VALUES (865, 'new', 7, 412, '2007-12-03 13:04:24', '2006-10-30 19:58:56');
INSERT INTO `recommend` VALUES (866, 'banner', 3, 159, '2024-08-18 03:26:05', '2012-01-15 03:14:00');
INSERT INTO `recommend` VALUES (867, 'hot', 15, 685, '2003-01-31 03:37:43', '2025-03-24 06:05:46');
INSERT INTO `recommend` VALUES (868, 'banner', 18, 130, '2016-09-11 07:02:08', '2014-04-16 02:17:24');
INSERT INTO `recommend` VALUES (869, 'new', 39, 660, '2014-05-06 04:58:49', '2015-08-11 02:47:57');
INSERT INTO `recommend` VALUES (870, 'new', 6, 700, '2000-10-17 21:46:11', '2000-10-24 12:46:05');
INSERT INTO `recommend` VALUES (871, 'new', 23, 416, '2006-04-08 08:41:36', '2008-04-18 22:56:29');
INSERT INTO `recommend` VALUES (872, 'banner', 33, 598, '2025-10-15 20:52:48', '2020-11-02 05:18:45');
INSERT INTO `recommend` VALUES (873, 'new', 33, 670, '2019-01-16 01:17:38', '2004-01-31 12:19:44');
INSERT INTO `recommend` VALUES (874, 'new', 18, 75, '2001-01-17 09:36:59', '2023-04-01 13:57:05');
INSERT INTO `recommend` VALUES (875, 'banner', 15, 362, '2002-08-27 01:25:37', '2009-04-29 13:00:31');
INSERT INTO `recommend` VALUES (876, 'hot', 10, 304, '2000-03-09 08:45:57', '2018-04-25 07:47:43');
INSERT INTO `recommend` VALUES (877, 'new', 17, 673, '2025-07-16 15:45:16', '2000-02-21 12:46:28');
INSERT INTO `recommend` VALUES (878, 'banner', 39, 318, '2002-05-02 07:56:26', '2001-01-09 12:40:40');
INSERT INTO `recommend` VALUES (879, 'hot', 42, 718, '2000-09-29 01:03:33', '2020-10-16 14:50:38');
INSERT INTO `recommend` VALUES (880, 'new', 15, 778, '2007-05-06 14:03:07', '2015-03-03 22:52:03');
INSERT INTO `recommend` VALUES (881, 'hot', 4, 73, '2018-12-25 02:50:02', '2000-01-12 08:56:57');
INSERT INTO `recommend` VALUES (882, 'banner', 34, 616, '2015-04-10 16:46:38', '2015-06-09 05:17:00');
INSERT INTO `recommend` VALUES (883, 'hot', 23, 865, '2003-09-23 03:20:51', '2011-01-20 02:29:29');
INSERT INTO `recommend` VALUES (884, 'banner', 13, 282, '2006-05-08 23:16:09', '2021-03-28 07:59:09');
INSERT INTO `recommend` VALUES (885, 'new', 8, 950, '2005-09-17 21:50:12', '2001-04-23 23:17:26');
INSERT INTO `recommend` VALUES (886, 'new', 12, 852, '2014-09-18 13:44:49', '2024-06-23 20:33:18');
INSERT INTO `recommend` VALUES (887, 'banner', 33, 236, '2013-02-07 02:22:08', '2018-03-28 19:08:58');
INSERT INTO `recommend` VALUES (888, 'banner', 23, 485, '2021-12-22 16:53:34', '2024-10-16 20:37:45');
INSERT INTO `recommend` VALUES (889, 'banner', 26, 326, '2011-09-18 00:59:23', '2020-11-05 05:21:35');
INSERT INTO `recommend` VALUES (890, 'hot', 22, 782, '2025-06-06 02:22:43', '2024-12-04 00:27:54');
INSERT INTO `recommend` VALUES (891, 'banner', 6, 591, '2021-08-21 12:35:42', '2020-09-14 09:34:51');
INSERT INTO `recommend` VALUES (892, 'banner', 36, 305, '2000-06-29 23:46:16', '2007-08-24 20:12:58');
INSERT INTO `recommend` VALUES (893, 'banner', 2, 743, '2008-06-21 07:24:38', '2008-02-13 16:16:51');
INSERT INTO `recommend` VALUES (894, 'banner', 25, 918, '2008-11-26 10:57:55', '2018-01-06 05:35:29');
INSERT INTO `recommend` VALUES (895, 'banner', 32, 590, '2001-11-11 14:01:59', '2022-12-09 10:06:15');
INSERT INTO `recommend` VALUES (896, 'new', 15, 686, '2000-05-13 01:18:20', '2015-11-01 14:36:20');
INSERT INTO `recommend` VALUES (897, 'banner', 14, 877, '2023-07-02 08:01:54', '2019-12-05 12:48:55');
INSERT INTO `recommend` VALUES (898, 'banner', 7, 519, '2010-07-24 03:47:33', '2021-06-11 11:29:21');
INSERT INTO `recommend` VALUES (899, 'new', 6, 487, '2016-12-26 19:11:22', '2000-05-23 02:19:31');
INSERT INTO `recommend` VALUES (900, 'new', 20, 928, '2007-02-11 18:35:14', '2021-03-21 05:52:10');
INSERT INTO `recommend` VALUES (901, 'new', 28, 655, '2024-08-13 01:51:13', '2003-06-01 15:46:33');
INSERT INTO `recommend` VALUES (902, 'banner', 3, 813, '2015-04-19 02:30:56', '2010-08-07 15:52:39');
INSERT INTO `recommend` VALUES (903, 'banner', 20, 610, '2022-12-16 20:17:26', '2017-12-29 06:55:37');
INSERT INTO `recommend` VALUES (904, 'banner', 35, 32, '2025-10-28 05:27:09', '2004-10-09 04:45:24');
INSERT INTO `recommend` VALUES (905, 'hot', 19, 683, '2004-05-05 22:43:47', '2002-09-25 20:01:36');
INSERT INTO `recommend` VALUES (906, 'hot', 14, 832, '2017-05-22 19:10:49', '2013-12-28 09:10:37');
INSERT INTO `recommend` VALUES (907, 'banner', 38, 815, '2011-08-02 06:52:38', '2004-07-20 19:50:38');
INSERT INTO `recommend` VALUES (908, 'banner', 38, 802, '2002-03-06 16:24:17', '2008-09-23 19:01:45');
INSERT INTO `recommend` VALUES (909, 'banner', 31, 264, '2023-04-01 05:55:03', '2006-05-08 12:14:24');
INSERT INTO `recommend` VALUES (910, 'hot', 27, 700, '2011-02-25 13:58:18', '2009-09-17 15:23:52');
INSERT INTO `recommend` VALUES (911, 'banner', 12, 105, '2020-01-04 21:18:14', '2022-07-14 23:59:22');
INSERT INTO `recommend` VALUES (912, 'new', 2, 650, '2018-10-26 18:38:49', '2020-10-05 13:55:20');
INSERT INTO `recommend` VALUES (913, 'hot', 26, 109, '2022-02-21 02:41:36', '2006-08-04 22:55:27');
INSERT INTO `recommend` VALUES (914, 'new', 12, 70, '2014-06-08 05:07:57', '2000-01-25 00:21:45');
INSERT INTO `recommend` VALUES (915, 'hot', 18, 227, '2020-02-04 07:27:15', '2006-06-04 11:21:30');
INSERT INTO `recommend` VALUES (916, 'banner', 26, 107, '2020-04-14 22:29:00', '2022-06-23 09:08:08');
INSERT INTO `recommend` VALUES (917, 'hot', 22, 175, '2020-01-19 05:04:18', '2010-11-29 12:30:16');
INSERT INTO `recommend` VALUES (918, 'banner', 32, 17, '2012-08-05 17:28:35', '2017-12-21 21:39:54');
INSERT INTO `recommend` VALUES (919, 'hot', 5, 481, '2009-02-13 03:25:17', '2010-04-11 07:05:37');
INSERT INTO `recommend` VALUES (920, 'hot', 28, 849, '2006-12-17 06:37:51', '2025-11-17 04:26:18');
INSERT INTO `recommend` VALUES (921, 'hot', 14, 397, '2019-01-31 23:08:25', '2018-01-24 21:37:35');
INSERT INTO `recommend` VALUES (922, 'banner', 42, 672, '2002-06-16 05:34:30', '2017-10-16 05:03:30');
INSERT INTO `recommend` VALUES (923, 'new', 29, 831, '2015-04-06 16:51:56', '2019-07-11 10:14:49');
INSERT INTO `recommend` VALUES (924, 'new', 1, 208, '2010-01-17 03:49:27', '2019-01-09 20:45:00');
INSERT INTO `recommend` VALUES (925, 'banner', 1, 604, '2024-12-16 15:44:51', '2006-10-16 02:45:36');
INSERT INTO `recommend` VALUES (926, 'banner', 5, 614, '2006-04-03 11:27:23', '2005-08-27 17:55:58');
INSERT INTO `recommend` VALUES (927, 'hot', 22, 861, '2000-09-25 08:03:02', '2001-01-15 09:30:20');
INSERT INTO `recommend` VALUES (928, 'new', 1, 507, '2000-06-22 03:24:37', '2006-11-21 03:01:57');
INSERT INTO `recommend` VALUES (929, 'new', 3, 566, '2005-07-20 01:13:07', '2024-02-03 16:19:17');
INSERT INTO `recommend` VALUES (930, 'banner', 26, 387, '2009-03-13 06:42:03', '2016-09-14 19:39:55');
INSERT INTO `recommend` VALUES (931, 'hot', 23, 11, '2000-01-31 10:57:06', '2007-01-03 10:35:23');
INSERT INTO `recommend` VALUES (932, 'new', 42, 704, '2011-02-17 02:08:06', '2021-10-28 14:01:06');
INSERT INTO `recommend` VALUES (933, 'new', 16, 414, '2003-08-16 07:03:26', '2012-10-21 17:30:07');
INSERT INTO `recommend` VALUES (934, 'new', 39, 465, '2009-04-23 12:47:05', '2005-10-21 06:25:33');
INSERT INTO `recommend` VALUES (935, 'banner', 9, 918, '2008-09-02 12:06:55', '2015-09-20 22:23:52');
INSERT INTO `recommend` VALUES (936, 'hot', 7, 100, '2025-05-18 23:56:08', '2005-12-18 14:39:46');
INSERT INTO `recommend` VALUES (937, 'banner', 15, 67, '2004-10-22 23:57:11', '2003-08-18 07:18:39');
INSERT INTO `recommend` VALUES (938, 'hot', 30, 78, '2023-07-05 05:13:17', '2018-09-26 05:56:46');
INSERT INTO `recommend` VALUES (939, 'hot', 5, 292, '2025-01-24 23:38:08', '2008-08-07 16:48:09');
INSERT INTO `recommend` VALUES (940, 'new', 43, 408, '2002-12-19 03:25:20', '2021-08-24 21:10:50');
INSERT INTO `recommend` VALUES (941, 'banner', 37, 229, '2004-08-26 05:45:27', '2007-08-12 14:29:36');
INSERT INTO `recommend` VALUES (942, 'new', 2, 905, '2016-07-27 18:49:22', '2016-08-13 12:40:02');
INSERT INTO `recommend` VALUES (943, 'hot', 29, 895, '2019-08-22 21:55:16', '2004-01-19 17:40:16');
INSERT INTO `recommend` VALUES (944, 'banner', 39, 690, '2022-10-06 09:56:11', '2015-10-26 10:47:55');
INSERT INTO `recommend` VALUES (945, 'hot', 27, 883, '2024-06-25 23:33:58', '2012-03-01 08:24:15');
INSERT INTO `recommend` VALUES (946, 'new', 19, 324, '2001-05-09 06:54:57', '2022-08-15 11:05:46');
INSERT INTO `recommend` VALUES (947, 'banner', 42, 925, '2010-04-21 20:08:28', '2007-04-18 23:00:54');
INSERT INTO `recommend` VALUES (948, 'new', 16, 210, '2013-08-24 12:36:15', '2010-05-09 23:48:34');
INSERT INTO `recommend` VALUES (949, 'banner', 27, 328, '2004-11-21 23:09:19', '2012-05-03 19:29:02');
INSERT INTO `recommend` VALUES (950, 'new', 12, 292, '2023-03-08 06:00:13', '2012-07-30 05:36:44');
INSERT INTO `recommend` VALUES (951, 'banner', 11, 595, '2020-02-13 03:51:05', '2017-01-31 10:50:19');
INSERT INTO `recommend` VALUES (952, 'hot', 6, 722, '2010-08-08 12:50:44', '2011-12-29 22:46:27');
INSERT INTO `recommend` VALUES (953, 'hot', 2, 669, '2013-12-21 05:16:24', '2004-06-16 17:54:55');
INSERT INTO `recommend` VALUES (954, 'new', 43, 763, '2008-09-29 14:42:18', '2015-10-14 01:15:11');
INSERT INTO `recommend` VALUES (955, 'banner', 19, 149, '2020-07-14 07:08:39', '2025-09-21 00:26:51');
INSERT INTO `recommend` VALUES (956, 'new', 41, 306, '2002-06-30 16:36:41', '2023-12-28 08:38:40');
INSERT INTO `recommend` VALUES (957, 'new', 43, 256, '2008-07-21 14:46:57', '2024-04-14 20:50:03');
INSERT INTO `recommend` VALUES (958, 'new', 38, 356, '2025-05-27 20:50:14', '2008-10-01 22:13:27');
INSERT INTO `recommend` VALUES (959, 'banner', 30, 161, '2016-03-11 13:10:39', '2004-06-23 11:54:02');
INSERT INTO `recommend` VALUES (960, 'banner', 37, 363, '2003-07-20 08:32:39', '2009-05-05 03:27:07');
INSERT INTO `recommend` VALUES (961, 'new', 11, 606, '2014-05-25 22:47:25', '2013-05-17 18:43:02');
INSERT INTO `recommend` VALUES (962, 'hot', 12, 706, '2001-12-06 02:11:36', '2020-07-16 02:47:15');
INSERT INTO `recommend` VALUES (963, 'new', 30, 522, '2022-07-20 21:28:06', '2013-02-24 20:14:12');
INSERT INTO `recommend` VALUES (964, 'new', 33, 203, '2014-10-14 16:55:13', '2006-04-26 07:02:25');
INSERT INTO `recommend` VALUES (965, 'hot', 3, 994, '2021-09-13 21:17:37', '2011-06-12 09:10:27');
INSERT INTO `recommend` VALUES (966, 'banner', 26, 388, '2000-09-05 18:41:30', '2003-03-24 19:16:55');
INSERT INTO `recommend` VALUES (967, 'new', 37, 784, '2012-09-01 11:21:28', '2025-02-03 01:29:13');
INSERT INTO `recommend` VALUES (968, 'hot', 3, 224, '2009-12-17 23:33:01', '2007-08-07 02:39:02');
INSERT INTO `recommend` VALUES (969, 'hot', 11, 735, '2018-08-19 12:35:36', '2013-10-21 12:14:44');
INSERT INTO `recommend` VALUES (970, 'new', 26, 84, '2012-12-22 02:32:25', '2006-10-17 01:06:49');
INSERT INTO `recommend` VALUES (971, 'new', 7, 94, '2013-11-22 10:03:20', '2015-04-20 22:52:14');
INSERT INTO `recommend` VALUES (972, 'banner', 14, 532, '2001-05-13 19:00:35', '2014-08-13 20:32:39');
INSERT INTO `recommend` VALUES (973, 'banner', 12, 644, '2012-07-14 08:33:42', '2025-11-28 16:14:07');
INSERT INTO `recommend` VALUES (974, 'hot', 38, 325, '2016-04-23 03:24:18', '2019-12-23 18:13:13');
INSERT INTO `recommend` VALUES (975, 'new', 24, 9, '2009-05-21 08:46:40', '2002-02-05 01:17:04');
INSERT INTO `recommend` VALUES (976, 'banner', 37, 931, '2025-09-07 11:24:41', '2000-04-22 02:41:10');
INSERT INTO `recommend` VALUES (977, 'hot', 8, 265, '2023-11-23 20:03:10', '2012-02-09 00:15:02');
INSERT INTO `recommend` VALUES (978, 'hot', 4, 899, '2021-05-07 16:37:09', '2009-10-06 04:24:45');
INSERT INTO `recommend` VALUES (979, 'banner', 38, 794, '2019-06-28 16:02:26', '2025-11-20 21:37:14');
INSERT INTO `recommend` VALUES (980, 'banner', 6, 389, '2012-09-04 18:16:10', '2020-12-20 20:51:14');
INSERT INTO `recommend` VALUES (981, 'new', 24, 0, '2016-01-15 22:37:48', '2007-05-25 04:09:44');
INSERT INTO `recommend` VALUES (982, 'hot', 10, 183, '2024-08-29 21:50:04', '2008-02-20 06:34:34');
INSERT INTO `recommend` VALUES (983, 'hot', 12, 613, '2015-10-26 19:35:47', '2018-11-19 13:21:36');
INSERT INTO `recommend` VALUES (984, 'hot', 25, 876, '2016-09-24 20:25:43', '2018-01-21 22:15:26');
INSERT INTO `recommend` VALUES (985, 'new', 40, 871, '2013-12-18 07:08:26', '2022-08-07 17:15:40');
INSERT INTO `recommend` VALUES (986, 'hot', 21, 210, '2006-11-22 20:50:48', '2017-04-18 11:37:29');
INSERT INTO `recommend` VALUES (987, 'banner', 5, 398, '2016-05-09 05:06:15', '2022-10-07 02:24:51');
INSERT INTO `recommend` VALUES (988, 'banner', 1, 690, '2017-03-02 14:39:28', '2022-01-31 02:26:38');
INSERT INTO `recommend` VALUES (989, 'hot', 10, 963, '2003-01-24 23:13:40', '2008-03-11 09:21:43');
INSERT INTO `recommend` VALUES (990, 'hot', 1, 78, '2018-08-16 00:53:40', '2014-01-18 15:13:05');
INSERT INTO `recommend` VALUES (991, 'hot', 11, 983, '2016-09-13 14:42:20', '2016-03-26 21:13:41');
INSERT INTO `recommend` VALUES (992, 'banner', 3, 994, '2003-07-08 17:38:09', '2006-11-11 02:12:07');
INSERT INTO `recommend` VALUES (993, 'banner', 5, 59, '2006-08-18 11:38:52', '2000-04-28 01:02:10');
INSERT INTO `recommend` VALUES (994, 'hot', 1, 969, '2022-04-08 00:39:36', '2005-05-29 14:13:08');
INSERT INTO `recommend` VALUES (995, 'hot', 7, 470, '2025-06-15 00:31:54', '2022-04-14 05:38:22');
INSERT INTO `recommend` VALUES (996, 'new', 28, 303, '2007-12-06 10:11:54', '2020-07-12 16:47:27');
INSERT INTO `recommend` VALUES (997, 'new', 31, 335, '2003-07-31 16:37:41', '2001-11-05 10:02:03');
INSERT INTO `recommend` VALUES (998, 'hot', 40, 838, '2022-07-30 18:54:21', '2021-02-12 00:15:44');
INSERT INTO `recommend` VALUES (999, 'banner', 32, 807, '2024-07-20 20:01:59', '2009-11-19 14:57:14');
INSERT INTO `recommend` VALUES (1000, 'banner', 1, 118, '2019-03-06 11:03:39', '2001-03-31 04:31:38');
INSERT INTO `recommend` VALUES (1001, 'new', 7, 309, '2002-07-06 02:12:41', '2024-09-06 23:18:03');
INSERT INTO `recommend` VALUES (1002, 'new', 11, 674, '2023-03-14 08:56:22', '2024-09-29 22:21:19');
INSERT INTO `recommend` VALUES (1003, 'hot', 7, 617, '2000-02-23 04:16:23', '2005-08-16 17:50:40');
INSERT INTO `recommend` VALUES (1004, 'banner', 10, 848, '2007-11-24 03:29:47', '2020-03-01 12:56:48');
INSERT INTO `recommend` VALUES (1005, 'banner', 38, 297, '2017-05-31 21:00:23', '2015-10-09 04:44:04');
INSERT INTO `recommend` VALUES (1006, 'new', 2, 87, '2005-01-27 17:30:18', '2003-04-30 17:25:04');
INSERT INTO `recommend` VALUES (1007, 'banner', 16, 672, '2024-05-03 13:07:18', '2016-05-11 07:27:14');
INSERT INTO `recommend` VALUES (1008, 'banner', 16, 317, '2024-01-03 11:39:59', '2003-06-08 13:26:27');
INSERT INTO `recommend` VALUES (1009, 'banner', 1, 838, '2011-04-09 06:19:43', '2011-02-11 20:29:40');
INSERT INTO `recommend` VALUES (1010, 'new', 29, 922, '2007-04-10 11:00:06', '2001-09-14 22:52:24');
INSERT INTO `recommend` VALUES (1011, 'new', 18, 912, '2005-06-24 08:45:30', '2015-09-18 06:03:55');
INSERT INTO `recommend` VALUES (1012, 'hot', 12, 246, '2018-11-23 19:26:21', '2022-08-16 19:37:16');
INSERT INTO `recommend` VALUES (1013, 'hot', 32, 377, '2008-10-06 18:18:22', '2024-05-01 06:55:43');
INSERT INTO `recommend` VALUES (1014, 'new', 36, 704, '2007-04-01 03:56:40', '2000-12-18 10:50:48');
INSERT INTO `recommend` VALUES (1015, 'hot', 43, 289, '2019-07-28 17:31:25', '2013-05-09 03:25:40');
INSERT INTO `recommend` VALUES (1016, 'hot', 5, 167, '2014-05-21 03:13:22', '2004-02-07 21:07:06');
INSERT INTO `recommend` VALUES (1017, 'hot', 35, 416, '2005-03-04 19:42:50', '2012-02-20 17:28:23');
INSERT INTO `recommend` VALUES (1018, 'hot', 8, 492, '2022-05-17 16:36:45', '2000-01-04 07:19:02');
INSERT INTO `recommend` VALUES (1019, 'new', 11, 349, '2014-04-19 12:39:10', '2005-09-28 23:35:37');
INSERT INTO `recommend` VALUES (1020, 'new', 1, 150, '2018-06-12 03:18:30', '2024-12-27 08:22:01');
INSERT INTO `recommend` VALUES (1021, 'new', 28, 622, '2021-10-19 07:24:28', '2015-01-23 19:46:19');
INSERT INTO `recommend` VALUES (1022, 'new', 12, 932, '2010-10-08 12:14:29', '2016-08-04 11:37:26');
INSERT INTO `recommend` VALUES (1023, 'hot', 1, 238, '2003-03-11 02:03:11', '2002-10-28 19:50:30');
INSERT INTO `recommend` VALUES (1024, 'hot', 2, 230, '2016-02-05 18:54:37', '2009-04-23 04:17:11');
INSERT INTO `recommend` VALUES (1025, 'hot', 15, 600, '2019-02-07 22:20:18', '2024-05-05 21:07:27');
INSERT INTO `recommend` VALUES (1026, 'hot', 10, 446, '2002-08-31 03:47:30', '2008-10-28 14:35:45');
INSERT INTO `recommend` VALUES (1027, 'banner', 31, 140, '2003-05-06 20:17:25', '2002-05-29 14:58:45');
INSERT INTO `recommend` VALUES (1028, 'new', 5, 992, '2018-04-04 12:13:40', '2009-12-23 06:22:02');
INSERT INTO `recommend` VALUES (1029, 'banner', 8, 510, '2008-11-26 19:30:01', '2003-12-25 05:51:41');
INSERT INTO `recommend` VALUES (1030, 'banner', 19, 692, '2019-09-29 12:14:31', '2017-09-23 13:50:42');
INSERT INTO `recommend` VALUES (1031, 'banner', 5, 189, '2014-07-29 11:08:15', '2006-01-08 02:25:38');
INSERT INTO `recommend` VALUES (1032, 'banner', 19, 358, '2008-05-08 13:41:42', '2015-07-19 22:56:55');
INSERT INTO `recommend` VALUES (1033, 'banner', 43, 307, '2014-01-27 19:29:57', '2003-10-10 19:11:04');
INSERT INTO `recommend` VALUES (1034, 'new', 1, 160, '2021-03-11 16:01:54', '2016-03-28 02:24:18');
INSERT INTO `recommend` VALUES (1035, 'new', 17, 334, '2002-08-09 22:08:37', '2022-05-19 05:39:08');
INSERT INTO `recommend` VALUES (1036, 'new', 38, 165, '2010-03-23 00:56:14', '2011-12-02 14:36:53');
INSERT INTO `recommend` VALUES (1037, 'hot', 27, 875, '2002-10-02 00:30:05', '2018-07-27 03:56:51');
INSERT INTO `recommend` VALUES (1038, 'banner', 40, 693, '2014-10-25 06:44:13', '2014-06-20 01:52:32');
INSERT INTO `recommend` VALUES (1039, 'hot', 38, 122, '2005-12-18 19:08:54', '2022-02-16 07:03:58');
INSERT INTO `recommend` VALUES (1040, 'new', 11, 279, '2025-02-17 20:35:58', '2019-06-28 20:04:30');
INSERT INTO `recommend` VALUES (1041, 'banner', 37, 29, '2022-07-01 07:09:59', '2015-04-29 01:32:51');
INSERT INTO `recommend` VALUES (1042, 'banner', 6, 404, '2014-11-03 01:06:30', '2022-10-09 21:08:09');

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '$2a$10$rQz8kH7k0K8k8k8k8k8k8.', '管理员', 'admin@cakeshop.com', NULL, NULL, 1, 1, '2025-12-01 09:17:49', '2025-12-01 09:17:49');
INSERT INTO `user` VALUES (2, 'testuser', '$2a$10$rQz8kH7k0K8k8k8k8k8k8.', '测试用户', 'test@example.com', '13800138000', '北京市朝阳区测试地址123号', 0, 1, '2025-12-01 09:17:49', '2025-12-01 09:17:49');
INSERT INTO `user` VALUES (3, 'zhangsan', '0985251f3d13076beec69aca778ea31f', '123', '2938051889@qq.com', '123', '123', 0, 1, '2025-12-02 20:45:04', '2025-12-02 20:45:04');
INSERT INTO `user` VALUES (4, 'lisi', '58cf703f664397ec4f0ac359b84b565c', 'aaa', '2938051888@qq.com', '123', '123', 0, 1, '2025-12-06 09:57:49', '2025-12-06 09:57:49');

SET FOREIGN_KEY_CHECKS = 1;
