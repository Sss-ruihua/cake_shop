-- 测试数据插入脚本
-- 用于测试环创店网站的商品展示功能

-- 插入商品分类
INSERT INTO `type` (`type_name`, `create_time`, `update_time`) VALUES
('蛋糕', NOW(), NOW()),
('面包', NOW(), NOW()),
('饼干', NOW(), NOW()),
('甜点', NOW(), NOW()),
('饮品', NOW(), NOW()),
('礼品', NOW());

-- 插入测试商品
INSERT INTO `goods` (`goods_name`, `cover_image`, `detail_image`, `price`, `description`, `stock`, `type_id`, `create_time`, `update_time`) VALUES
('经典巧克力蛋糕', 'images/cake1.jpg', '["images/cake1_1.jpg", "images/cake1_2.jpg"]', 158.00, '浓郁巧克力口感，丝滑细腻，适合生日和庆典', 50, 1, NOW(), NOW()),
('草莓奶油蛋糕', 'images/cake2.jpg', '["images/cake2_1.jpg", "images/cake2_2.jpg"]', 128.00, '新鲜草莓搭配轻盈奶油，口感清新甜美', 45, 1, NOW(), NOW()),
('提拉米苏', 'images/cake3.jpg', '["images/cake3_1.jpg", "images/cake3_2.jpg"]', 98.00, '意大利经典甜点，咖啡与马斯卡彭的完美融合', 30, 4, NOW(), NOW()),
('法式马卡龙', 'images/macaron1.jpg', '["images/macaron1_1.jpg"]', 68.00, '六色装马卡龙，外酥内软，色彩缤纷', 100, 3, NOW(), NOW()),
('手工曲奇礼盒', 'images/cookie1.jpg', '["images/cookie1_1.jpg"]', 88.00, '精选原料手工制作，黄油香浓口感酥脆', 60, 3, NOW(), NOW()),
('抹茶千层蛋糕', 'images/cake4.jpg', '["images/cake4_1.jpg", "images/cake4_2.jpg"]', 138.00, '日式抹茶粉制作，层次分明，茶香浓郁', 35, 1, NOW(), NOW()),
('黑森林蛋糕', 'images/cake5.jpg', '["images/cake5_1.jpg", "images/cake5_2.jpg"]', 168.00, '德国经典黑樱桃与巧克力组合', 25, 1, NOW(), NOW()),
('芝士蛋糕', 'images/cheese1.jpg', '["images/cheese1_1.jpg"]', 108.00, '纽约式重芝士，口感醇厚浓郁', 40, 4, NOW(), NOW());

-- 插入推荐商品数据
INSERT INTO `recommend` (`recommend_type`, `goods_id`, `sort_order`, `create_time`, `update_time`) VALUES
-- Banner推荐 (首页轮播)
('banner', 1, 1, NOW(), NOW()),
('banner', 2, 2, NOW(), NOW()),
('banner', 3, 3, NOW(), NOW()),
-- 热销推荐
('hot', 1, 1, NOW(), NOW()),
('hot', 2, 2, NOW(), NOW()),
('hot', 5, 3, NOW(), NOW()),
('hot', 6, 4, NOW(), NOW()),
('hot', 7, 5, NOW(), NOW()),
('hot', 8, 6, NOW(), NOW()),
-- 新品推荐
('new', 6, 1, NOW(), NOW()),
('new', 7, 2, NOW(), NOW()),
('new', 8, 3, NOW(), NOW()),
('new', 4, 4, NOW(), NOW()),
('new', 5, 5, NOW(), NOW()),
('new', 3, 6, NOW(), NOW());