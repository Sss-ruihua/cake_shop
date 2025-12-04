/**
 * 商品懒加载核心模块
 * 支持首页、分类页面、搜索页面的无限滚动加载
 */

class GoodsLazyLoader {
    constructor(options = {}) {
        this.config = {
            // 配置选项
            pageSize: options.pageSize || 12,           // 每页加载数量
            threshold: options.threshold || 100,        // 距离底部多少像素开始加载
            loadingText: options.loadingText || '正在加载更多商品...',
            noMoreText: options.noMoreText || '没有更多商品了',
            errorText: options.errorText || '加载失败，点击重试',
            retryText: options.retryText || '点击重试',
            loaderId: options.loaderId || 'lazy-loader',

            // API端点
            endpoints: {
                list: 'goods?action=ajaxList',
                type: 'goods?action=ajaxType',
                search: 'goods?action=ajaxSearch'
            }
        };

        // 状态变量
        this.currentPage = 1;
        this.isLoading = false;
        this.hasMore = true;
        this.lastError = null;
        this.container = null;
        this.loader = null;
        this.type = 'list';  // list, type, search
        this.params = {};    // 额外参数

        this.init();
    }

    /**
     * 初始化懒加载器
     */
    init() {
        this.createLoader();
        this.bindEvents();
    }

    /**
     * 创建加载器元素
     */
    createLoader() {
        this.loader = document.createElement('div');
        this.loader.id = this.config.loaderId;
        this.loader.className = 'lazy-loader';
        this.updateLoaderState('loading');
        document.body.appendChild(this.loader);
    }

    /**
     * 绑定事件监听器
     */
    bindEvents() {
        // 使用Intersection Observer监听滚动
        if ('IntersectionObserver' in window) {
            this.observer = new IntersectionObserver(
                (entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting && !this.isLoading && this.hasMore) {
                            this.loadMore();
                        }
                    });
                },
                {
                    rootMargin: `${this.config.threshold}px`
                }
            );
            this.observer.observe(this.loader);
        } else {
            // 兼容旧浏览器，使用scroll事件
            window.addEventListener('scroll', this.handleScroll.bind(this));
        }

        // 点击重试
        this.loader.addEventListener('click', () => {
            if (this.lastError) {
                this.loadMore();
            }
        });
    }

    /**
     * 处理滚动事件（兼容旧浏览器）
     */
    handleScroll() {
        if (this.isLoading || !this.hasMore) return;

        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
        const windowHeight = window.innerHeight;
        const loaderTop = this.loader.offsetTop;

        if (scrollTop + windowHeight >= loaderTop - this.config.threshold) {
            this.loadMore();
        }
    }

    /**
     * 设置容器和参数
     */
    setup(container, type, params = {}) {
        this.container = container;
        this.type = type;
        this.params = params;
        this.currentPage = 1;
        this.isLoading = false;
        this.hasMore = true;
        this.lastError = null;
        this.updateLoaderState('loading');
    }

    /**
     * 加载更多商品
     */
    async loadMore() {
        if (this.isLoading || !this.hasMore) return;

        this.isLoading = true;
        this.updateLoaderState('loading');

        try {
            const url = this.buildApiUrl();
            const response = await this.fetchWithTimeout(url, {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });

            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }

            const result = await response.json();

            if (result.success) {
                this.handleSuccess(result.data);
            } else {
                throw new Error(result.message || '加载失败');
            }

        } catch (error) {
            this.handleError(error);
        } finally {
            this.isLoading = false;
        }
    }

    /**
     * 构建API URL
     */
    buildApiUrl() {
        const baseUrl = this.config.endpoints[this.type];
        const params = new URLSearchParams({
            page: this.currentPage,
            pageSize: this.config.pageSize,
            ...this.params
        });
        return `${baseUrl}&${params.toString()}`;
    }

    /**
     * 处理成功加载
     */
    handleSuccess(data) {
        // 移除骨架屏
        const skeletonContainer = this.container.querySelector('.skeleton-container');
        if (skeletonContainer) {
            skeletonContainer.remove();
        }

        if (data.goods && data.goods.length > 0) {
            this.renderGoods(data.goods);
            this.currentPage++;
        }

        this.hasMore = data.hasMore;

        if (this.hasMore) {
            this.updateLoaderState('loading');
        } else {
            this.updateLoaderState('no-more');
        }

        // 触发自定义事件
        this.dispatchEvent('loaded', {
            goods: data.goods,
            page: data.currentPage,
            hasMore: data.hasMore
        });
    }

    /**
     * 处理加载错误
     */
    handleError(error) {
        console.error('懒加载错误:', error);
        this.lastError = error;
        this.updateLoaderState('error');

        // 触发自定义事件
        this.dispatchEvent('error', { error });
    }

    /**
     * 渲染商品列表
     */
    renderGoods(goods) {
        if (!this.container) return;

        const fragment = document.createDocumentFragment();

        goods.forEach(item => {
            const goodsElement = this.createGoodsElement(item);
            fragment.appendChild(goodsElement);
        });

        this.container.appendChild(fragment);
    }

    /**
     * 创建商品元素
     */
    createGoodsElement(goods) {
        const div = document.createElement('div');
        div.className = 'product-card goods-item'; // 同时支持两个类名
        div.setAttribute('data-goods-id', goods.goodsId);
        div.style.cursor = 'pointer';

        const stockClass = goods.stock <= 0 ? 'out-of-stock' : '';
        const stockText = goods.stock <= 0 ? '暂时缺货' : `库存: ${goods.stock}`;

        div.innerHTML = `
            <div class="goods-image" onclick="goToDetail(event, ${goods.goodsId})">
                <img src="${goods.coverImage}" alt="${goods.goodsName}" class="product-image" loading="lazy"
                     onerror="this.src='images/default.jpg'">
                ${goods.stock <= 0 ? '<div class="out-of-stock-overlay">暂时缺货</div>' : ''}
            </div>
            <div class="product-info goods-info">
                <div class="product-category">${goods.typeName || '未分类'}</div>
                <h3 class="product-name goods-name" onclick="goToDetail(event, ${goods.goodsId})">${goods.goodsName}</h3>
                <p class="product-description goods-desc">${goods.description}</p>
                <div class="product-price goods-price">¥${goods.price}</div>
                <div class="product-actions goods-actions">
                    <button class="btn-add-cart btn-cart" onclick="event.stopPropagation(); addToCart(${goods.goodsId}, '${goods.goodsName.replace(/'/g, "\\'")}', ${goods.price}, ${goods.stock})"
                            ${goods.stock <= 0 ? 'disabled' : ''}>
                        ${goods.stock <= 0 ? '暂时缺货' : '加入购物车'}
                    </button>
                    <a href="goods?action=detail&goodsId=${goods.goodsId}" class="btn-view-detail btn-detail" onclick="event.stopPropagation()">查看详情</a>
                </div>
            </div>
        `;

        return div;
    }

    /**
     * 更新加载器状态
     */
    updateLoaderState(state) {
        if (!this.loader) return;

        this.loader.className = `lazy-loader ${state}`;

        switch (state) {
            case 'loading':
                this.loader.innerHTML = `
                    <div class="loading-spinner"></div>
                    <span>${this.config.loadingText}</span>
                `;
                break;
            case 'no-more':
                this.loader.innerHTML = `<span>${this.config.noMoreText}</span>`;
                break;
            case 'error':
                this.loader.innerHTML = `
                    <span>${this.config.errorText}</span>
                    <button class="retry-btn">${this.config.retryText}</button>
                `;
                break;
        }
    }

    /**
     * 带超时的fetch
     */
    async fetchWithTimeout(url, options, timeout = 10000) {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), timeout);

        try {
            const response = await fetch(url, {
                ...options,
                signal: controller.signal
            });
            clearTimeout(timeoutId);
            return response;
        } catch (error) {
            clearTimeout(timeoutId);
            if (error.name === 'AbortError') {
                throw new Error('请求超时');
            }
            throw error;
        }
    }

    /**
     * 触发自定义事件
     */
    dispatchEvent(eventName, detail) {
        const event = new CustomEvent(`lazyload:${eventName}`, { detail });
        document.dispatchEvent(event);
    }

    /**
     * 重置懒加载器
     */
    reset() {
        this.currentPage = 1;
        this.isLoading = false;
        this.hasMore = true;
        this.lastError = null;
        this.updateLoaderState('loading');
    }

    /**
     * 销毁懒加载器
     */
    destroy() {
        if (this.observer) {
            this.observer.disconnect();
        }
        if (this.loader && this.loader.parentNode) {
            this.loader.parentNode.removeChild(this.loader);
        }
        window.removeEventListener('scroll', this.handleScroll);
    }
}

/**
 * 懒加载工厂函数
 */
window.createLazyLoader = function(options) {
    return new GoodsLazyLoader(options);
};

/**
 * 预定义的懒加载实例
 */
window.goodsLazyLoader = null;

/**
 * 初始化商品懒加载
 */
window.initGoodsLazyLoader = function(container, type, params) {
    if (window.goodsLazyLoader) {
        window.goodsLazyLoader.destroy();
    }

    window.goodsLazyLoader = new GoodsLazyLoader();
    window.goodsLazyLoader.setup(container, type, params);

    return window.goodsLazyLoader;
};