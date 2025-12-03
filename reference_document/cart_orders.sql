-- 环创店蛋糕店购物车功能数据库补充脚本
-- 用于支持订单相关功能

-- 如果表已存在，删除它们
DROP TABLE IF EXISTS `order_item`;
DROP TABLE IF EXISTS `order_table`;

-- 创建订单表
CREATE TABLE `order_table` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT '用户ID',
  `order_no` varchar(50) NOT NULL COMMENT '订单号',
  `total_amount` decimal(10,2) NOT NULL COMMENT '商品总金额',
  `total_quantity` int(11) NOT NULL COMMENT '商品总数量',
  `delivery_fee` decimal(10,2) DEFAULT 8.00 COMMENT '配送费',
  `discount_amount` decimal(10,2) DEFAULT 0.00 COMMENT '优惠金额',
  `final_amount` decimal(10,2) NOT NULL COMMENT '最终支付金额',
  `status` varchar(20) DEFAULT 'pending' COMMENT '订单状态(pending,confirmed,preparing,delivering,completed,cancelled)',
  `receiver_name` varchar(100) DEFAULT NULL COMMENT '收货人姓名',
  `receiver_phone` varchar(20) DEFAULT NULL COMMENT '收货人电话',
  `receiver_address` varchar(500) DEFAULT NULL COMMENT '收货地址',
  `delivery_time` varchar(50) DEFAULT NULL COMMENT '期望送达时间',
  `order_notes` varchar(1000) DEFAULT NULL COMMENT '订单备注',
  `payment_method` varchar(50) DEFAULT NULL COMMENT '支付方式(wechat,alipay,cod)',
  `payment_status` varchar(20) DEFAULT 'unpaid' COMMENT '支付状态(unpaid,paid,refunded)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 创建订单项表
CREATE TABLE `order_item` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL COMMENT '订单ID',
  `goods_id` int(11) NOT NULL COMMENT '商品ID',
  `goods_name` varchar(200) NOT NULL COMMENT '商品名称',
  `goods_price` decimal(10,2) NOT NULL COMMENT '商品价格',
  `goods_image` varchar(500) DEFAULT NULL COMMENT '商品图片',
  `quantity` int(11) NOT NULL COMMENT '购买数量',
  `subtotal` decimal(10,2) NOT NULL COMMENT '小计金额',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`item_id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_goods_id` (`goods_id`),
  CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `order_table` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_order_item_goods` FOREIGN KEY (`goods_id`) REFERENCES `goods` (`goods_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单项表';

-- 插入一些测试商品数据（如果goods表为空）
INSERT IGNORE INTO `goods` (`goods_id`, `goods_name`, `cover_image`, `price`, `description`, `stock`, `type_id`, `create_time`, `update_time`) VALUES
(1, '经典巧克力蛋糕', 'images/chocolate-cake.jpg', 168.00, '浓郁巧克力口味的经典蛋糕，采用进口巧克力制作，口感丝滑，巧克力爱好者的首选', 50, 1, NOW(), NOW()),
(2, '新鲜草莓蛋糕', 'images/strawberry-cake.jpg', 188.00, '当季新鲜草莓搭配奶油，酸甜可口，颜值爆表的水果蛋糕', 30, 1, NOW(), NOW()),
(3, '抹茶慕斯蛋糕', 'images/matcha-cake.jpg', 158.00, '日式抹茶制作，清香不腻，口感细腻，适合喜欢清淡口味的顾客', 25, 1, NOW(), NOW()),
(4, '提拉米苏', 'images/tiramisu.jpg', 128.00, '意大利经典甜品，咖啡与马斯卡彭奶酪的完美结合', 40, 2, NOW(), NOW()),
(5, '芒果千层蛋糕', 'images/mango-cake.jpg', 198.00, '层层芒果酱与奶油交织，果香浓郁，口感丰富', 35, 1, NOW(), NOW()),
(6, '黑森林蛋糕', 'images/blackforest.jpg', 178.00, '德国经典巧克力蛋糕，樱桃与巧克力的完美融合', 20, 1, NOW(), NOW());

-- 插入商品分类数据（如果type表为空）
INSERT IGNORE INTO `type` (`type_id`, `type_name`, `parent_id`, `sort_order`, `create_time`) VALUES
(1, '生日蛋糕', 0, 1, NOW()),
(2, '西点甜品', 0, 2, NOW()),
(3, '慕斯类', 2, 1, NOW()),
(4, '巧克力类', 1, 1, NOW()),
(5, '水果类', 1, 2, NOW());

-- 创建索引以提高查询性能
CREATE INDEX idx_goods_price ON goods(price);
CREATE INDEX idx_goods_stock ON goods(stock);
CREATE INDEX idx_goods_create_time ON goods(create_time);
CREATE INDEX idx_order_final_amount ON order_table(final_amount);
CREATE INDEX idx_order_payment_status ON order_table(payment_status);