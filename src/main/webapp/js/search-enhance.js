/**
 * 搜索框交互增强脚本
 * 为环创店搜索框添加动态效果和更好的用户体验
 */

class SearchEnhancer {
    constructor() {
        this.searchWrapper = null;
        this.searchInput = null;
        this.searchDropdown = null;
        this.searchSuggestions = null;
        this.searchHistory = null;
        this.historyItems = null;
        this.clearHistoryBtn = null;
        this.isSearchVisible = false;
        this.searchTimeout = null;
        this.currentKeyword = '';
        this.isComposing = false; // 标记是否正在输入中文
        this.lastMouseLeaveTime = 0; // 记录最后离开搜索框的时间
        this.closeTimeout = null; // 延迟关闭的定时器

        this.init();
    }

    init() {
        // 等待DOM加载完成
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.setupElements());
        } else {
            this.setupElements();
        }
    }

    setupElements() {
        // 获取DOM元素
        this.searchWrapper = document.querySelector('.search-wrapper');
        this.searchInput = document.querySelector('.search-input');
        this.searchDropdown = document.querySelector('.search-dropdown');
        this.searchSuggestions = document.querySelector('#searchSuggestions');
        this.searchHistory = document.querySelector('#searchHistory');
        this.historyItems = document.querySelector('#historyItems');
        this.clearHistoryBtn = document.querySelector('.clear-history');

        if (!this.searchWrapper) {
            console.error('Search elements not found');
            return;
        }

        // 绑定事件
        this.bindEvents();

        // 加载搜索历史
        this.loadSearchHistory();
    }

    bindEvents() {
        // 搜索图标点击事件
        const searchIcon = this.searchWrapper.querySelector('.search-icon');
        if (searchIcon) {
            searchIcon.addEventListener('click', (e) => {
                e.preventDefault();
                this.toggleSearch();
            });
        }

        // 搜索输入框事件
        if (this.searchInput) {
            // 获得焦点时显示搜索框
            this.searchInput.addEventListener('focus', () => {
                this.showSearch();

                // 根据输入框内容决定显示什么
                const keyword = this.searchInput.value.trim();
                if (keyword.length > 0) {
                    // 如果有内容，直接获取搜索建议
                    this.fetchSuggestions(keyword);
                } else {
                    // 如果没有内容，显示热门搜索
                    this.loadPopularSearches();
                }
            });

            // 中文输入法开始事件
            this.searchInput.addEventListener('compositionstart', (e) => {
                this.isComposing = true;
                console.log('中文输入开始'); // 调试信息
                // 开始输入中文时，确保搜索框保持打开
                this.showSearch();
                // 清除任何延迟关闭的定时器
                if (this.closeTimeout) {
                    clearTimeout(this.closeTimeout);
                    this.closeTimeout = null;
                }
            });

            // 中文输入法更新事件
            this.searchInput.addEventListener('compositionupdate', (e) => {
                // 输入中文过程中，可以实时显示拼音
                const value = e.target.value;
                console.log('中文输入更新:', value); // 调试信息
                // 不触发搜索建议，避免干扰
            });

            // 中文输入法结束事件
            this.searchInput.addEventListener('compositionend', (e) => {
                this.isComposing = false;
                console.log('中文输入结束'); // 调试信息
                const keyword = e.target.value.trim();

                // 中文输入完成后，触发搜索建议
                clearTimeout(this.searchTimeout);
                if (keyword.length > 0) {
                    this.searchTimeout = setTimeout(() => {
                        this.fetchSuggestions(keyword);
                    }, 200); // 稍微减少延迟，提升响应速度
                } else {
                    this.hideSuggestions();
                }
            });

            // 输入事件（带防抖）
            this.searchInput.addEventListener('input', (e) => {
                // 如果正在输入中文，不处理input事件
                if (this.isComposing) {
                    return;
                }

                clearTimeout(this.searchTimeout);
                const keyword = e.target.value.trim();

                if (keyword.length > 0) {
                    this.searchTimeout = setTimeout(() => {
                        this.fetchSuggestions(keyword);
                    }, 300);
                } else {
                    // 清空输入框时，隐藏搜索建议并重新显示热门搜索
                    this.hideSuggestions();
                    setTimeout(() => {
                        this.loadPopularSearches();
                    }, 50);
                }
            });

            // 键盘导航
            this.searchInput.addEventListener('keydown', (e) => {
                this.handleKeyNavigation(e);
            });

            // 失去焦点时的处理
            this.searchInput.addEventListener('blur', (e) => {
                // 延迟检查，给点击事件时间处理
                setTimeout(() => {
                    // 如果正在输入中文，不关闭搜索框
                    if (this.isComposing) {
                        return;
                    }
                    // 如果新的焦点元素不在搜索框内，才关闭搜索框
                    if (!this.searchWrapper.contains(document.activeElement) &&
                        !this.searchWrapper.matches(':hover')) {
                        this.hideSearch();
                    }
                }, 200);
            });
        }

        // 清除历史按钮
        if (this.clearHistoryBtn) {
            this.clearHistoryBtn.addEventListener('click', () => {
                this.clearSearchHistory();
            });
        }

        // 点击外部关闭搜索框
        document.addEventListener('click', (e) => {
            if (!this.searchWrapper.contains(e.target)) {
                setTimeout(() => {
                    // 如果正在输入中文，不关闭搜索框
                    if (this.isComposing) {
                        return;
                    }
                    // 如果输入框还有焦点，不关闭搜索框
                    if (this.searchInput && this.searchInput.matches(':focus')) {
                        return;
                    }
                    // 其他情况才关闭搜索框
                    this.hideSearch();
                }, 150);
            }
        });

        // 鼠标进入搜索框时确保显示
        this.searchWrapper.addEventListener('mouseenter', () => {
            // 清除任何延迟关闭的定时器
            if (this.closeTimeout) {
                clearTimeout(this.closeTimeout);
                this.closeTimeout = null;
            }
            this.showSearch();
        });

        // 鼠标离开搜索框时的智能处理
        this.searchWrapper.addEventListener('mouseleave', () => {
            this.lastMouseLeaveTime = Date.now();

            // 延迟关闭，给用户时间移动到输入法候选框
            this.closeTimeout = setTimeout(() => {
                // 检查是否还在输入中文
                if (this.isComposing) {
                    console.log('正在输入中文，保持搜索框打开');
                    return;
                }

                // 检查输入框是否还有焦点
                if (this.searchInput && this.searchInput.matches(':focus')) {
                    console.log('输入框仍有焦点，保持搜索框打开');
                    return;
                }

                // 检查是否刚刚离开（可能是移动到输入法候选框）
                const timeSinceLeave = Date.now() - this.lastMouseLeaveTime;
                if (timeSinceLeave < 500) {
                    // 如果离开时间很短，可能是移动到输入法候选框，延长等待时间
                    this.closeTimeout = setTimeout(() => {
                        if (!this.isComposing &&
                            (!this.searchInput || !this.searchInput.matches(':focus'))) {
                            this.hideSearch();
                        }
                    }, 1000);
                    return;
                }

                // 其他情况关闭搜索框
                this.hideSearch();
            }, 300); // 初始延迟300ms
        });

        // 页面可见性变化时的处理
        document.addEventListener('visibilitychange', () => {
            if (document.hidden) {
                // 页面隐藏时重置输入法状态
                this.isComposing = false;
            }
        });

        // 窗口失去焦点时的处理
        window.addEventListener('blur', () => {
            // 防止输入法状态卡住
            setTimeout(() => {
                this.isComposing = false;
            }, 100);
        });

        // 添加输入法状态重置机制
        setInterval(() => {
            // 定期检查并重置可能卡住的输入法状态
            if (this.isComposing && this.searchInput && !this.searchInput.matches(':focus')) {
                this.isComposing = false;
            }
        }, 1000);

        // 搜索表单提交
        const searchForm = document.querySelector('.search-form');
        if (searchForm) {
            searchForm.addEventListener('submit', (e) => {
                const keyword = this.searchInput.value.trim();
                if (keyword) {
                    this.saveToHistory(keyword);
                }
                return true;
            });
        }
    }

    toggleSearch() {
        if (this.isSearchVisible) {
            this.hideSearch();
        } else {
            this.showSearch();
            this.searchInput.focus();
        }
    }

    showSearch() {
        if (!this.isSearchVisible) {
            this.searchWrapper.classList.add('active');
            this.isSearchVisible = true;

            // 添加显示动画
            if (this.searchDropdown) {
                this.searchDropdown.style.opacity = '1';
                this.searchDropdown.style.visibility = 'visible';
                this.searchDropdown.style.transform = 'translateY(0) scale(1)';
            }
        }
    }

    hideSearch() {
        // 清除任何延迟关闭的定时器
        if (this.closeTimeout) {
            clearTimeout(this.closeTimeout);
            this.closeTimeout = null;
        }

        // 如果输入框有焦点或正在输入中文，不隐藏搜索框
        if (this.searchInput &&
            (this.searchInput.matches(':focus') || this.isComposing)) {
            console.log('不关闭搜索框：输入框有焦点或正在输入中文');
            return;
        }

        if (this.isSearchVisible) {
            console.log('关闭搜索框');
            this.searchWrapper.classList.remove('active');
            this.isSearchVisible = false;

            // 延迟隐藏，允许点击动画
            setTimeout(() => {
                if (!this.isSearchVisible && this.searchDropdown) {
                    this.searchDropdown.style.opacity = '0';
                    this.searchDropdown.style.visibility = 'hidden';
                    this.searchDropdown.style.transform = 'translateY(-20px) scale(0.95)';
                }
            }, 150);
        }
    }

    fetchSuggestions(keyword) {
        // 模拟搜索建议API调用
        // 在实际应用中，这里应该是一个AJAX请求
        const mockSuggestions = [
            { name: '生日蛋糕', highlight: this.highlightKeyword('生日蛋糕', keyword) },
            { name: '巧克力蛋糕', highlight: this.highlightKeyword('巧克力蛋糕', keyword) },
            { name: '水果蛋糕', highlight: this.highlightKeyword('水果蛋糕', keyword) },
            { name: '草莓蛋糕', highlight: this.highlightKeyword('草莓蛋糕', keyword) },
            { name: '草莓慕斯', highlight: this.highlightKeyword('草莓慕斯', keyword) },
            { name: '草莓奶油蛋糕', highlight: this.highlightKeyword('草莓奶油蛋糕', keyword) },
            { name: '新鲜草莓', highlight: this.highlightKeyword('新鲜草莓', keyword) },
            { name: '芝士蛋糕', highlight: this.highlightKeyword('芝士蛋糕', keyword) },
            { name: '慕斯蛋糕', highlight: this.highlightKeyword('慕斯蛋糕', keyword) },
            { name: '奶油蛋糕', highlight: this.highlightKeyword('奶油蛋糕', keyword) },
            { name: '提拉米苏', highlight: this.highlightKeyword('提拉米苏', keyword) },
            { name: '黑森林蛋糕', highlight: this.highlightKeyword('黑森林蛋糕', keyword) },
            { name: '戚风蛋糕', highlight: this.highlightKeyword('戚风蛋糕', keyword) },
            { name: '水果拼盘', highlight: this.highlightKeyword('水果拼盘', keyword) },
            { name: '曲奇饼干', highlight: this.highlightKeyword('曲奇饼干', keyword) },
            { name: '马卡龙', highlight: this.highlightKeyword('马卡龙', keyword) }
        ].filter(item => item.name.includes(keyword));

        // 清理热门搜索，避免冲突
        this.clearPopularSearches();

        // 延迟显示，避免闪烁
        setTimeout(() => {
            this.displaySuggestions(mockSuggestions, keyword);
        }, 100);
    }

    highlightKeyword(text, keyword) {
        if (!keyword) return text;
        const regex = new RegExp(`(${keyword})`, 'gi');
        return text.replace(regex, '<span class="suggestion-highlight">$1</span>');
    }

    displaySuggestions(suggestions, keyword) {
        if (!this.searchSuggestions) return;

        // 确保搜索建议容器是可见的
        this.searchSuggestions.style.display = 'block';
        this.clearPopularSearches();

        if (suggestions.length > 0) {
            console.log('显示搜索建议:', suggestions);
            this.searchSuggestions.innerHTML = suggestions.map((item, index) => `
                <div class="suggestion-item" data-index="${index}" data-keyword="${item.name}">
                    ${item.highlight}
                </div>
            `).join('');

            // 绑定点击事件
            this.searchSuggestions.querySelectorAll('.suggestion-item').forEach(item => {
                item.addEventListener('click', () => {
                    const keyword = item.dataset.keyword;
                    this.searchInput.value = keyword;
                    this.saveToHistory(keyword);
                    // 提交搜索
                    this.performSearch(keyword);
                });
            });
        } else {
            console.log('没有找到搜索建议，显示空结果');
            this.showNoResults(keyword);
        }
    }

    showNoResults(keyword) {
        if (!this.searchSuggestions) return;

        this.searchSuggestions.style.display = 'block';
        this.searchSuggestions.innerHTML = `
            <div class="search-empty">
                没有找到与 "${keyword}" 相关的商品
            </div>
        `;
    }

    hideSuggestions() {
        if (this.searchSuggestions) {
            this.searchSuggestions.style.display = 'none';
            this.searchSuggestions.innerHTML = '';
        }
    }

    loadPopularSearches() {
        // 显示热门搜索词
        if (this.searchInput && this.searchInput.value.trim() === '') {
            // 先清理可能存在的旧热门搜索块
            this.clearPopularSearches();

            const popularSearches = ['生日蛋糕', '巧克力', '水果', '芝士', '慕斯', '草莓', '奶油', '巧克力', '提拉米苏'];
            const popularHTML = `
                <div id="popular-searches" style="padding: 15px 24px; border-bottom: 1px solid rgba(224,224,224,0.5);">
                    <div style="font-size: 13px; color: var(--text-muted); margin-bottom: 12px; font-weight: 600;">热门搜索</div>
                    <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                        ${popularSearches.map(term => `
                            <span class="popular-search" style="
                                background: linear-gradient(135deg, #fff5e6 0%, #ffe0b2 100%);
                                color: var(--secondary-color);
                                padding: 6px 14px;
                                border-radius: 16px;
                                font-size: 12px;
                                cursor: pointer;
                                transition: all 0.3s ease;
                                border: 1px solid rgba(255, 152, 0, 0.2);
                                font-weight: 500;
                            " data-keyword="${term}">${term}</span>
                        `).join('')}
                    </div>
                </div>
            `;

            // 插入到搜索建议容器之前
            if (this.searchSuggestions && this.searchSuggestions.style.display === 'none') {
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = popularHTML;
                this.searchSuggestions.parentNode.insertBefore(tempDiv.firstElementChild, this.searchSuggestions);

                // 绑定点击事件
                this.searchSuggestions.parentNode.querySelectorAll('.popular-search').forEach(item => {
                    item.addEventListener('click', () => {
                        const keyword = item.dataset.keyword;
                        this.searchInput.value = keyword;
                        this.saveToHistory(keyword);
                        this.performSearch(keyword);
                    });
                });
            }
        }
    }

    clearPopularSearches() {
        // 清理热门搜索块
        const existingPopular = document.getElementById('popular-searches');
        if (existingPopular) {
            existingPopular.remove();
        }
    }

    handleKeyNavigation(e) {
        const items = this.searchSuggestions?.querySelectorAll('.suggestion-item');
        if (!items || items.length === 0) return;

        let currentIndex = -1;
        const activeItem = this.searchSuggestions.querySelector('.suggestion-item.active');
        if (activeItem) {
            currentIndex = parseInt(activeItem.dataset.index);
        }

        switch (e.key) {
            case 'ArrowDown':
                e.preventDefault();
                items.forEach(item => item.classList.remove('active'));
                currentIndex = (currentIndex + 1) % items.length;
                items[currentIndex].classList.add('active');
                items[currentIndex].scrollIntoView({ block: 'nearest' });
                break;

            case 'ArrowUp':
                e.preventDefault();
                items.forEach(item => item.classList.remove('active'));
                currentIndex = currentIndex <= 0 ? items.length - 1 : currentIndex - 1;
                items[currentIndex].classList.add('active');
                items[currentIndex].scrollIntoView({ block: 'nearest' });
                break;

            case 'Enter':
                e.preventDefault();
                if (currentIndex >= 0) {
                    const keyword = items[currentIndex].dataset.keyword;
                    this.searchInput.value = keyword;
                    this.saveToHistory(keyword);
                    this.performSearch(keyword);
                }
                break;

            case 'Escape':
                this.hideSearch();
                this.searchInput.blur();
                break;
        }
    }

    loadSearchHistory() {
        if (!this.historyItems) return;

        const history = JSON.parse(localStorage.getItem('searchHistory') || '[]');

        if (history.length > 0) {
            this.historyItems.innerHTML = history.slice(0, 8).map(keyword => `
                <span class="history-item" data-keyword="${keyword}">${keyword}</span>
            `).join('');

            // 绑定点击事件
            this.historyItems.querySelectorAll('.history-item').forEach(item => {
                item.addEventListener('click', () => {
                    const keyword = item.dataset.keyword;
                    this.searchInput.value = keyword;
                    this.performSearch(keyword);
                });
            });

            // 显示搜索历史区域
            this.searchHistory.style.display = 'block';
        } else {
            this.searchHistory.style.display = 'none';
        }
    }

    saveToHistory(keyword) {
        if (!keyword || keyword.trim() === '') return;

        let history = JSON.parse(localStorage.getItem('searchHistory') || '[]');

        // 移除重复项并添加到最前面
        history = history.filter(item => item !== keyword);
        history.unshift(keyword);

        // 限制历史记录数量
        if (history.length > 20) {
            history = history.slice(0, 20);
        }

        localStorage.setItem('searchHistory', JSON.stringify(history));
        this.loadSearchHistory();
    }

    clearSearchHistory() {
        if (confirm('确定要清除所有搜索历史吗？')) {
            localStorage.removeItem('searchHistory');
            if (this.historyItems) {
                this.historyItems.innerHTML = '';
            }
            this.searchHistory.style.display = 'none';

            // 添加清除动画反馈
            this.clearHistoryBtn.textContent = '已清除';
            this.clearHistoryBtn.style.background = 'var(--success-color)';
            setTimeout(() => {
                this.clearHistoryBtn.textContent = '清除';
                this.clearHistoryBtn.style.background = '';
            }, 2000);
        }
    }

    performSearch(keyword) {
        // 执行搜索
        const form = document.querySelector('.search-form');
        if (form) {
            const keywordInput = form.querySelector('input[name="keyword"]');
            if (keywordInput) {
                keywordInput.value = keyword;
            }
            form.submit();
        }
    }
}

// 初始化搜索增强功能
const searchEnhancer = new SearchEnhancer();

// 导出到全局作用域（如果需要）
window.SearchEnhancer = SearchEnhancer;