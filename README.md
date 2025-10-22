# 運動行政系統 (SPO Wireframe)

一個完整的運動機構管理系統，包含前台用戶介面和後台管理介面，專為運動學校、體育中心、訓練營等機構設計。

## 📋 項目概述

本系統是一個 HTML/CSS 靜態原型系統，展示了運動行政管理的完整工作流程，包括：
- **前台用戶介面**：學校展示、課程瀏覽、報名流程、會員專區
- **後台管理介面**：學校管理、課程管理、用戶管理、報名管理等

## 🏗️ 系統架構

```
SPO_wireframe/
├── 前台頁面 (Frontend)
│   ├── index.html              # 主頁 - 合作學校列表
│   ├── school_detail.html      # 學校詳情 - 課程列表
│   ├── course_detail.html      # 課程詳情 - 課程介紹
│   ├── signup_flow.html        # 報名流程 - 表單填寫
│   ├── member_dashboard.html   # 會員專區 - 個人資訊
│   └── styles.css              # 前台統一樣式文件
├── 後台管理 (Backend)
│   ├── admin_dashboard.html    # 後台首頁 - 儀表板
│   ├── admin_schools.html      # 學校管理 - 列表頁
│   ├── admin_school_edit.html  # 學校編輯 - 新增/修改
│   ├── admin_courses.html      # 課程管理 - 列表頁
│   ├── admin_course_edit.html  # 課程編輯 - 新增/修改
│   ├── admin_users.html        # 用戶管理 - 列表頁
│   ├── admin_user_detail.html  # 用戶詳情 - 檢視/編輯
│   ├── admin_coaches.html      # 教練管理 - 列表頁
│   ├── admin_coach_edit.html   # 教練編輯 - 新增/修改
│   ├── admin_registrations.html        # 報名管理 - 列表頁
│   ├── admin_registration_detail.html  # 報名詳情 - 檢視/處理
│   ├── admin_permissions.html  # 權限管理 - 列表頁
│   ├── admin_permission_edit.html # 權限編輯 - 設定權限
│   └── styles.css              # 後台統一樣式文件
└── README.md                   # 項目說明文件
```

## 🎨 設計系統

### 色彩配置
- **主要藍色**: `#3b82f6` - 按鈕、連結、強調元素
- **主要文字色**: `#333` - 標題、內容文字
- **次要背景色**: `#f4f4f4` - 卡片背景、區塊背景
- **邊框色**: `#ccc` - 分隔線、表格邊框
- **警告色**: `#e74c3c` - 錯誤訊息、必填提示

### 字體系統
- **主要字體**: Inter (從 Google Fonts 載入)
- **備用字體**: Arial, sans-serif
- **字體權重**: 400 (regular), 600 (semi-bold), 700 (bold)

### 間距系統
- **標準間距**: 20px (`--spacing`)
- **小間距**: 10px (`--spacing-sm`)
- **大間距**: 30px (`--spacing-lg`)

## 💻 功能模組

### 前台功能
1. **首頁 (index.html)**
   - 合作學校展示 (3列網格布局)
   - 學校篩選和搜尋
   - 響應式設計

2. **學校詳情 (school_detail.html)**
   - 學校基本資訊展示
   - 課程列表 (2列網格布局)
   - 課程分類篩選 (運動類別、年齡層)

3. **課程詳情 (course_detail.html)**
   - 課程詳細介紹
   - 教練資訊
   - 報名連結和側邊欄CTA

4. **報名流程 (signup_flow.html)**
   - 多步驟表單 (學員資料、監護人資料、緊急聯絡人)
   - 表單驗證和錯誤提示
   - 條款同意和提交確認

5. **會員專區 (member_dashboard.html)**
   - 標籤頁式介面 (個人資料、報名課程、付款紀錄等)
   - 響應式側邊欄導航
   - 即時資料更新

### 後台功能
1. **儀表板 (admin_dashboard.html)**
   - 系統概覽和關鍵指標
   - 快速操作入口
   - 最新活動記錄

2. **學校管理**
   - 學校列表檢視和搜尋 (`admin_schools.html`)
   - 新增/編輯學校資訊 (`admin_school_edit.html`)
   - 學校狀態管理

3. **課程管理**
   - 課程列表和篩選 (`admin_courses.html`)
   - 課程資訊編輯 (`admin_course_edit.html`)
   - 課程排期管理

4. **用戶管理**
   - 用戶列表和搜尋 (`admin_users.html`)
   - 用戶詳情檢視 (`admin_user_detail.html`)
   - 用戶權限設定

5. **教練管理**
   - 教練資料管理 (`admin_coaches.html`)
   - 教練資格認證 (`admin_coach_edit.html`)

6. **報名管理**
   - 報名申請處理 (`admin_registrations.html`)
   - 報名詳情審核 (`admin_registration_detail.html`)
   - 報名狀態追蹤

7. **權限管理**
   - 角色權限設定 (`admin_permissions.html`)
   - 細粒度權限控制 (`admin_permission_edit.html`)

## 🎯 核心特色

### 響應式設計
- **移動優先**: 所有頁面都經過移動設備優化
- **斷點設計**: 主要斷點為 768px (平板) 和手機設備
- **彈性布局**: 使用 CSS Grid 和 Flexbox 實現適應性佈局

### 統一樣式系統
- **CSS 變數**: 使用 CSS Custom Properties 管理色彩和間距
- **組件化設計**: 可重複使用的按鈕、卡片、表單組件
- **一致性**: 前後台保持統一的視覺語言

### 使用者體驗
- **直觀導航**: 清晰的資訊架構和導航設計
- **視覺回饋**: Hover 效果、過渡動畫、狀態指示
- **無障礙設計**: 語義化 HTML、鍵盤導航支援

## 🛠️ 技術規格

### 前端技術
- **HTML5**: 語義化標籤、表單驗證
- **CSS3**: Grid Layout、Flexbox、CSS Variables、Transitions
- **字體**: Google Fonts (Inter)
- **圖示**: Lucide Icons (用於會員專區)

### 瀏覽器支援
- Chrome 60+
- Firefox 55+
- Safari 12+
- Edge 79+

### 檔案結構
- **模組化CSS**: 前後台分離的樣式文件
- **語義化HTML**: 清晰的頁面結構和命名
- **注釋文檔**: 詳細的程式碼注釋和文檔

## 🚀 快速開始

### 線上預覽
- **GitHub Pages**: [https://your-username.github.io/SPO_wireframe](https://your-username.github.io/SPO_wireframe)
- **前台首頁**: 直接開啟 `index.html`
- **後台管理**: 開啟 `backend/admin_dashboard.html`

### 本地開發
1. **克隆項目**
   ```bash
   git clone https://github.com/your-username/SPO_wireframe.git
   cd SPO_wireframe
   ```

2. **開啟頁面**
   - 前台首頁: 開啟 `index.html`
   - 後台管理: 開啟 `backend/admin_dashboard.html`

3. **本地服務器** (推薦)
   ```bash
   # 使用 Python 本地服務器
   python -m http.server 8000
   
   # 或使用 Node.js serve
   npx serve .
   
   # 或使用 Live Server (VS Code 擴展)
   ```

### GitHub Pages 部署
1. 推送代碼到 GitHub
2. 進入 Repository Settings
3. 在 Pages 設定中選擇 source 為 "Deploy from a branch"
4. 選擇 "main" 分支和 "/ (root)" 資料夾
5. 儲存後即可透過 GitHub Pages URL 訪問

### 自定義修改
1. **色彩主題**: 修改 `styles.css` 中的 CSS 變數
2. **佈局調整**: 修改網格系統類別 (`.grid`, `.grid-2`, `.grid-3`)
3. **新增頁面**: 複製現有頁面結構，引用統一樣式文件

## 📱 頁面展示

### 前台頁面
- **首頁**: 學校展示網格，每行3個學校卡片
- **學校詳情**: 學校資訊 + 課程篩選 + 2列課程網格
- **課程詳情**: 課程介紹 + 側邊欄報名 CTA
- **報名表單**: 多步驟表單，清晰的資訊收集流程
- **會員專區**: 標籤頁介面，整合個人資訊管理

### 後台頁面
- **管理介面**: 統一的後台設計語言
- **資料表格**: 可排序、篩選的資料展示
- **表單介面**: 一致的表單設計和驗證
- **狀態管理**: 清楚的狀態指示和操作回饋

## 🔧 維護與更新

### 樣式維護
- **統一更新**: 所有樣式集中在兩個 `styles.css` 文件中
- **版本控制**: 建議使用 Git 追蹤樣式變更
- **備份機制**: 定期備份樣式文件和頁面結構

### 內容更新
- **學校資訊**: 更新 `index.html` 和 `school_detail.html`
- **課程資料**: 修改課程卡片內容和連結
- **系統配置**: 調整後台管理頁面的資料展示

## 📋 最佳實踐

### 程式碼規範
- **命名約定**: 使用語義化的 CSS 類名
- **檔案組織**: 保持清晰的文件結構
- **注釋標準**: 為重要功能添加說明注釋

### 性能優化
- **圖片優化**: 使用適當的圖片格式和大小
- **CSS精簡**: 避免不必要的樣式重複
- **快取策略**: 設定適當的快取標頭

## 🤝 貢獻指南

### 開發流程
1. Fork 項目
2. 創建功能分支
3. 提交變更
4. 發起 Pull Request

### 問題回報
- 使用 Issues 回報錯誤或建議
- 提供詳細的重現步驟
- 附上瀏覽器和設備資訊

## 📄 授權資訊

本項目為開源項目，採用 MIT 授權。

---

**開發團隊**: SPO Wireframe Team  
**最後更新**: 2025年10月22日  
**版本**: 1.0.0

如有任何問題或建議，歡迎聯繫開發團隊或提出 Issue。