/**
 * 环创店 - 搜索功能模块
 * 提供悬浮搜索框、搜索建议、搜索历史等功能
 */

class SearchComponent {
    constructor() {
        this.init();
    }

    /**
     * 初始化搜索功能
     */
    init() {
        const searchInput = document.getElementById('searchInput');
        if (!searchInput) return;

        // 加载搜索历史
        this.loadSearchHistory();

        // 绑定事件
        this.bindEvents();

        console.log('搜索功能初始化完成');
    }

    /**
     * 绑定事件监听器
     */
    bindEvents() {
        const searchInput = document.getElementById('searchInput');
        const suggestionsContainer = document.getElementById('searchSuggestions');

        // 输入事件监听
        searchInput.addEventListener('input', (e) => {
            const keyword = e.target.value.trim();
            if (keyword.length > 0) {
                this.getSearchSuggestions(keyword);
            } else {
                suggestionsContainer.classList.remove('active');
                this.loadSearchHistory();
            }
        });

        // 键盘事件监听
        searchInput.addEventListener('keydown', (e) => {
            this.handleSearchKeydown(e);
        });

        // 获得焦点时显示历史
        searchInput.addEventListener('focus', () => {
            if (searchInput.value.trim() === '') {
                this.loadSearchHistory();
            }
        });

        // 失去焦点时延迟隐藏建议
        searchInput.addEventListener('blur', () => {
            setTimeout(() => {
                suggestionsContainer.classList.remove('active');
            }, 200);
        });

        // 搜索图标交互
        const searchIcon = document.querySelector('.search-icon');
        if (searchIcon) {
            // 悬浮时聚焦输入框
            searchIcon.addEventListener('mouseenter', () => {
                setTimeout(() => {
                    searchInput.focus();
                }, 300); // 延迟一点，让动画完成后再聚焦
            });

            // 点击搜索图标时聚焦输入框
            searchIcon.addEventListener('click', (e) => {
                e.preventDefault();
                searchInput.focus();
            });
        }

        // 点击外部区域关闭搜索建议
        document.addEventListener('click', (e) => {
            const searchDropdown = document.querySelector('.search-dropdown');
            if (!searchDropdown.contains(e.target) && e.target !== searchIcon) {
                suggestionsContainer.classList.remove('active');
            }
        });
    }

    /**
     * 执行搜索
     */
    performSearch(form) {
        const keyword = form.keyword.value.trim();
        if (keyword === '') {
            this.showNotification('请输入搜索关键词', 'error');
            return false;
        }

        // 保存搜索历史
        this.saveSearchHistory(keyword);

        // 跳转到搜索结果页面
        window.location.href = `goods?action=search&keyword=${encodeURIComponent(keyword)}`;
        return false;
    }

    /**
     * 获取搜索建议
     */
    async getSearchSuggestions(keyword) {
        try {
            // 首先尝试从缓存获取
            const cachedSuggestions = this.getCachedSuggestions(keyword);
            if (cachedSuggestions) {
                this.renderSuggestions(cachedSuggestions, keyword);
                return;
            }

            // 从服务器获取搜索建议
            const response = await fetch(`goods?action=ajaxSuggest&keyword=${encodeURIComponent(keyword)}`, {
                method: 'GET',
                headers: {
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });

            if (response.ok) {
                const result = await response.json();
                if (result.success && result.data && result.data.length > 0) {
                    this.renderSuggestions(result.data, keyword);
                    this.cacheSuggestions(keyword, result.data);
                } else {
                    // 使用模拟建议
                    this.getMockSuggestions(keyword);
                }
            } else {
                // 使用模拟建议
                this.getMockSuggestions(keyword);
            }
        } catch (error) {
            console.error('获取搜索建议失败:', error);
            // 使用模拟建议
            this.getMockSuggestions(keyword);
        }
    }

    /**
     * 模拟搜索建议
     */
    getMockSuggestions(keyword) {
        const mockSuggestions = [
            '生日蛋糕', '巧克力蛋糕', '水果蛋糕', '芝士蛋糕',
            '奶油蛋糕', '慕斯蛋糕', '婚礼蛋糕', '儿童蛋糕'
        ].filter(item => item.includes(keyword));

        if (mockSuggestions.length > 0) {
            this.renderSuggestions(mockSuggestions, keyword);
        } else {
            document.getElementById('searchSuggestions').classList.remove('active');
        }
    }

    /**
     * 渲染搜索建议
     */
    renderSuggestions(suggestions, keyword) {
        const suggestionsContainer = document.getElementById('searchSuggestions');

        let html = '';
        suggestions.forEach((suggestion, index) => {
            const highlighted = suggestion.replace(
                new RegExp(keyword, 'gi'),
                `<span class="suggestion-highlight">${keyword}</span>`
            );
            html += `
                <div class="suggestion-item ${index === 0 ? 'active' : ''}"
                     data-keyword="${suggestion}"
                     onmouseover="searchComponent.highlightSuggestion(this)"
                     onclick="searchComponent.selectSuggestion('${suggestion}')">
                    ${highlighted}
                </div>
            `;
        });

        suggestionsContainer.innerHTML = html;
        suggestionsContainer.classList.add('active');
    }

    /**
     * 处理键盘导航
     */
    handleSearchKeydown(e) {
        const suggestions = document.querySelectorAll('.suggestion-item');
        const searchInput = document.getElementById('searchInput');
        let activeIndex = Array.from(suggestions).findIndex(item => item.classList.contains('active'));

        switch (e.key) {
            case 'ArrowDown':
                e.preventDefault();
                if (activeIndex < suggestions.length - 1) {
                    if (activeIndex >= 0) suggestions[activeIndex].classList.remove('active');
                    activeIndex++;
                    suggestions[activeIndex].classList.add('active');
                    this.scrollToSuggestion(suggestions[activeIndex]);
                }
                break;

            case 'ArrowUp':
                e.preventDefault();
                if (activeIndex > 0) {
                    suggestions[activeIndex].classList.remove('active');
                    activeIndex--;
                    suggestions[activeIndex].classList.add('active');
                    this.scrollToSuggestion(suggestions[activeIndex]);
                }
                break;

            case 'Enter':
                e.preventDefault();
                if (activeIndex >= 0) {
                    this.selectSuggestion(suggestions[activeIndex].dataset.keyword);
                } else {
                    // 执行搜索
                    this.performSearch(searchInput.form);
                }
                break;

            case 'Escape':
                document.getElementById('searchSuggestions').classList.remove('active');
                break;
        }
    }

    /**
     * 高亮建议项
     */
    highlightSuggestion(element) {
        document.querySelectorAll('.suggestion-item').forEach(item => {
            item.classList.remove('active');
        });
        element.classList.add('active');
    }

    /**
     * 选择建议
     */
    selectSuggestion(keyword) {
        const searchInput = document.getElementById('searchInput');
        searchInput.value = keyword;
        this.saveSearchHistory(keyword);
        document.getElementById('searchSuggestions').classList.remove('active');

        // 执行搜索
        window.location.href = `goods?action=search&keyword=${encodeURIComponent(keyword)}`;
    }

    /**
     * 滚动到建议项
     */
    scrollToSuggestion(element) {
        const suggestionsContainer = document.getElementById('searchSuggestions');
        const containerRect = suggestionsContainer.getBoundingClientRect();
        const elementRect = element.getBoundingClientRect();

        if (elementRect.bottom > containerRect.bottom) {
            suggestionsContainer.scrollTop += elementRect.bottom - containerRect.bottom;
        } else if (elementRect.top < containerRect.top) {
            suggestionsContainer.scrollTop -= containerRect.top - elementRect.top;
        }
    }

    /**
     * 保存搜索历史
     */
    saveSearchHistory(keyword) {
        let history = JSON.parse(localStorage.getItem('searchHistory') || '[]');

        // 移除重复项
        history = history.filter(item => item !== keyword);

        // 添加到开头
        history.unshift(keyword);

        // 限制历史记录数量
        history = history.slice(0, 8);

        localStorage.setItem('searchHistory', JSON.stringify(history));
        this.loadSearchHistory();
    }

    /**
     * 加载搜索历史
     */
    loadSearchHistory() {
        const history = JSON.parse(localStorage.getItem('searchHistory') || '[]');
        const historyContainer = document.getElementById('historyItems');

        if (!historyContainer) return;

        if (history.length === 0) {
            historyContainer.innerHTML = '<div style="color: #999; font-size: 12px;">暂无搜索历史</div>';
            return;
        }

        let html = '';
        history.forEach(keyword => {
            html += `
                <div class="history-item"
                     title="${keyword}"
                     onclick="searchComponent.selectSuggestion('${keyword}')">
                    ${keyword}
                </div>
            `;
        });

        historyContainer.innerHTML = html;
    }

    /**
     * 清除搜索历史
     */
    clearSearchHistory() {
        if (confirm('确定要清除所有搜索历史吗？')) {
            localStorage.removeItem('searchHistory');
            this.loadSearchHistory();
            this.showNotification('搜索历史已清除', 'success');
        }
    }

    /**
     * 显示通知消息
     */
    showNotification(message, type = 'info') {
        // 移除现有通知
        const existingNotifications = document.querySelectorAll('.notification');
        existingNotifications.forEach(notif => {
            if (notif.parentNode) {
                notif.parentNode.removeChild(notif);
            }
        });

        // 创建新通知
        const notification = document.createElement('div');
        notification.className = 'notification notification-' + type;
        notification.textContent = message;

        // 设置样式
        notification.style.cssText = `
            position: fixed;
            top: 80px;
            right: 20px;
            padding: 14px 24px;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            z-index: 10000;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
            opacity: 0;
            transform: translateX(100%) translateY(-10px);
            transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            max-width: 320px;
            font-size: 14px;
            line-height: 1.4;
            display: flex;
            align-items: center;
            gap: 10px;
        `;

        // 根据类型设置背景色
        let bgColor = '';
        switch (type) {
            case 'success':
                bgColor = '#4CAF50';
                break;
            case 'error':
                bgColor = '#F44336';
                break;
            case 'info':
                bgColor = '#FF9800';
                break;
            default:
                bgColor = '#5D4037';
        }
        notification.style.backgroundColor = bgColor;

        // 添加到页面
        document.body.appendChild(notification);

        // 显示动画
        setTimeout(() => {
            notification.style.opacity = '1';
            notification.style.transform = 'translateX(0) translateY(0)';
        }, 50);

        // 自动隐藏
        setTimeout(() => {
            notification.style.opacity = '0';
            notification.style.transform = 'translateX(100%) translateY(-10px)';
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 300);
        }, 3000);
    }

    /**
     * 缓存搜索建议
     */
    cacheSuggestions(keyword, suggestions) {
        const cache = JSON.parse(localStorage.getItem('searchSuggestionsCache') || '{}');
        cache[keyword] = {
            data: suggestions,
            timestamp: Date.now()
        };
        localStorage.setItem('searchSuggestionsCache', JSON.stringify(cache));
    }

    /**
     * 获取缓存的搜索建议
     */
    getCachedSuggestions(keyword) {
        const cache = JSON.parse(localStorage.getItem('searchSuggestionsCache') || '{}');
        const cached = cache[keyword];

        if (cached && Date.now() - cached.timestamp < 5 * 60 * 1000) { // 5分钟有效期
            return cached.data;
        }
        return null;
    }
}

// 全局函数，供HTML调用
function performSearch(form) {
    return searchComponent.performSearch(form);
}

function clearSearchHistory() {
    searchComponent.clearSearchHistory();
}

// 初始化搜索组件
let searchComponent;
document.addEventListener('DOMContentLoaded', function() {
    searchComponent = new SearchComponent();
});

// 导出到全局作用域
window.searchComponent = searchComponent;