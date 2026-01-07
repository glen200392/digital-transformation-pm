# 🚀 數位轉型專案管理工具 - 快速開始指南

## 📦 項目概述

Enterprise Digital Transformation Project Management Tool 是一個企業級的項目管理平台，專為數位轉型辦公室設計。

**核心功能：**
- 📊 多層級項目管理（項目 → 階段 → 任務 → 子任務）
- - 🔗 任務依賴關係追蹤與關鍵路徑分析
  - - 🤝 跨職能協作管理（HR、IT 等部門）
    - - 🤖 AI 工具集成與成本追蹤
      - - ⚠️ 實時預警與風險管理
        - - 📈 可視化儀表板與進度報表
          - - 📤 多格式導出（Excel、PDF、CSV、Markdown）
            - - 🔐 企業級安全與審計日誌
             
              - ---

              ## 🛠️ 技術棧

              | 層級 | 技術 | 說明 |
              |------|------|------|
              | **前端** | Next.js 15 + React 18 | App Router、API Routes |
              | **語言** | TypeScript | 完整的類型安全 |
              | **樣式** | TailwindCSS | 現代 UI 設計 |
              | **ORM** | Prisma | 類型安全的數據庫訪問 |
              | **數據庫** | PostgreSQL | Neon 云託管 |
              | **認證** | NextAuth.js + JWT | 企業級認證 |
              | **測試** | Jest + Playwright | 多層次測試覆蓋 |
              | **部署** | Vercel | 自動 CI/CD，無需運維 |

              ---

              ## 🚀 快速開始

              ### 方式 1：本地開發（推薦）

              #### 前置條件
              - Node.js 18+
              - - npm 或 yarn
                - - Git
                  - - PostgreSQL (本地) 或 Neon (云)
                   
                    - #### 步驟
                   
                    - ```bash
                      # 1. 克隆倉庫
                      git clone https://github.com/glen200392/digital-transformation-pm.git
                      cd digital-transformation-pm

                      # 2. 安裝依賴
                      npm install

                      # 3. 複製環境配置
                      cp .env.example .env.local

                      # 4. 配置數據庫連接
                      # 編輯 .env.local 並設置 DATABASE_URL

                      # 5. 運行數據庫遷移
                      npx prisma migrate dev

                      # 6. （可選）填充示例數據
                      npx prisma db seed

                      # 7. 啟動開發服務器
                      npm run dev

                      # 8. 訪問應用
                      # 打開瀏覽器並訪問 http://localhost:3000
                      ```

                      ### 方式 2：使用 Docker Compose（推薦用於本地 PostgreSQL）

                      ```bash
                      # 1. 克隆倉庫
                      git clone https://github.com/glen200392/digital-transformation-pm.git
                      cd digital-transformation-pm

                      # 2. 啟動 Docker 容器
                      docker-compose up

                      # 3. 在另一個終端運行遷移
                      docker-compose exec app npx prisma migrate dev

                      # 4. 訪問應用
                      # http://localhost:3000
                      ```

                      ---

                      ## 🔧 環境變量配置

                      創建 `.env.local` 文件（永不提交到 Git）：

                      ```env
                      # 數據庫連接
                      DATABASE_URL=postgresql://user:password@localhost:5432/pm_tool

                      # Neon 云数据库示例
                      # DATABASE_URL=postgresql://user:password@xxxxx.neon.tech:5432/pm_tool?sslmode=require

                      # Redis (可選，用於快取)
                      REDIS_URL=redis://localhost:6379

                      # JWT 密鑰（最少 32 字節）
                      JWT_SECRET=your-super-secret-key-here-at-least-32-chars

                      # NextAuth 密鑰
                      NEXTAUTH_SECRET=your-nextauth-secret

                      # Encryption Key for API Keys (64 chars hex)
                      ENCRYPTION_KEY=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef

                      # AI 提供商配置（用戶配置，不在此硬編碼）
                      # OPENAI_API_KEY=sk-...
                      # CLAUDE_API_KEY=sk-ant-...

                      # Email 配置（用於通知）
                      SMTP_HOST=smtp.gmail.com
                      SMTP_PORT=587
                      SMTP_USER=your-email@gmail.com
                      SMTP_PASSWORD=your-app-password

                      # 應用配置
                      NODE_ENV=development
                      NEXTAUTH_URL=http://localhost:3000
                      ```

                      ---

                      ## 📂 項目結構

                      ```
                      digital-transformation-pm/
                      ├── app/                          # Next.js App Router
                      │  ├── api/                       # API 路由 (Serverless Functions)
                      │  │  ├── auth/                   # 認證相關
                      │  │  ├── projects/               # 項目管理 API
                      │  │  ├── tasks/                  # 任務管理 API
                      │  │  ├── warnings/               # 預警系統 API
                      │  │  ├── ai/                     # AI 集成 API
                      │  │  ├── export/                 # 導出功能 API
                      │  │  └── audit/                  # 審計日誌 API
                      │  │
                      │  ├── (dashboard)/               # 受保護路由（需要認證）
                      │  │  ├── page.tsx               # 主儀表板
                      │  │  ├── projects/
                      │  │  │  ├── page.tsx            # 項目列表
                      │  │  │  ├── [id]/page.tsx       # 項目詳情
                      │  │  │  └── new/page.tsx        # 新建項目
                      │  │  ├── tasks/
                      │  │  │  ├── page.tsx            # 任務管理
                      │  │  │  ├── [id]/page.tsx       # 任務詳情
                      │  │  │  └── new/page.tsx
                      │  │  ├── warnings/page.tsx       # 預警中心
                      │  │  ├── export/page.tsx         # 數據導出
                      │  │  └── settings/
                      │  │     ├── ai-governance/page.tsx  # AI 治理
                      │  │     ├── profile/page.tsx
                      │  │     └── notifications/page.tsx
                      │  │
                      │  ├── auth/                      # 認證頁面
                      │  │  ├── login/page.tsx
                      │  │  └── register/page.tsx
                      │  │
                      │  └── layout.tsx                 # 根佈局
                      │
                      ├── components/                   # React 組件
                      │  ├── layout/                    # 佈局組件
                      │  ├── dashboard/                 # 儀表板組件
                      │  ├── projects/                  # 項目管理組件
                      │  ├── tasks/                     # 任務管理組件
                      │  ├── ai/                        # AI 相關組件
                      │  ├── common/                    # 通用組件
                      │  └── forms/                     # 表單組件
                      │
                      ├── lib/                          # 工具函數和配置
                      │  ├── db.ts                      # 數據庫連接
                      │  ├── auth.ts                    # 認證邏輯
                      │  ├── api-client.ts              # API 調用
                      │  ├── validators.ts              # 數據驗證
                      │  ├── encryption.ts              # 加密函數
                      │  └── utils.ts                   # 通用工具
                      │
                      ├── types/                        # TypeScript 類型定義
                      │  ├── index.ts
                      │  ├── project.ts
                      │  ├── task.ts
                      │  └── ai.ts
                      │
                      ├── middleware.ts                 # Next.js 中間件（認證）
                      ├── prisma/                       # Prisma ORM
                      │  ├── schema.prisma             # 數據庫 schema
                      │  └── migrations/               # 數據庫遷移
                      ├── database/                     # SQL 文件
                      │  ├── schema.sql                # 完整 schema
                      │  ├── migrations/               # 遷移文件
                      │  └── seed.sql                  # 示例數據
                      ├── .github/workflows/            # CI/CD 工作流
                      ├── docs/                         # 文檔
                      │  ├── ARCHITECTURE.md           # 架構文檔
                      │  ├── API.md                    # API 文檔
                      │  ├── DATABASE.md               # 數據庫設計
                      │  ├── DEPLOYMENT.md             # 部署指南
                      │  └── DEVELOPMENT.md            # 開發指南
                      ├── .env.example                  # 環境變量範本
                      ├── tsconfig.json                 # TypeScript 配置
                      ├── next.config.js                # Next.js 配置
                      ├── tailwind.config.js            # TailwindCSS 配置
                      ├── jest.config.js                # Jest 配置
                      ├── docker-compose.yml            # Docker Compose
                      ├── Dockerfile                    # Docker 鏡像
                      └── package.json                  # 項目依賴
                      ```

                      ---

                      ## 📝 開發工作流

                      ### 創建新功能

                      ```bash
                      # 1. 從 develop 分支創建新分支
                      git checkout develop
                      git pull origin develop
                      git checkout -b feature/your-feature-name

                      # 2. 開發並測試
                      npm run dev

                      # 3. 運行測試
                      npm run test:unit
                      npm run test:integration

                      # 4. 運行 linting
                      npm run lint

                      # 5. 提交代碼
                      git add .
                      git commit -m "feat: describe your feature"

                      # 6. 推送並創建 Pull Request
                      git push origin feature/your-feature-name
                      ```

                      ### 數據庫遷移

                      ```bash
                      # 創建新遷移
                      npx prisma migrate dev --name add_new_feature

                      # 部署遷移（生產環境）
                      npx prisma migrate deploy
                      ```

                      ---

                      ## 🧪 測試

                      ```bash
                      # 運行所有測試
                      npm test

                      # 運行特定測試
                      npm run test:unit

                      # 生成覆蓋率報告
                      npm run test:coverage

                      # E2E 測試
                      npm run test:e2e
                      ```

                      ---

                      ## 🌐 部署到 Vercel

                      ### 方式 1：通過 GitHub（推薦）

                      1. 訪問 [vercel.com](https://vercel.com)
                      2. 2. 使用 GitHub 登入
                         3. 3. 導入此倉庫
                            4. 4. 設置環境變量：
                               5.    - `DATABASE_URL` - Neon PostgreSQL 連接字符串
                                     -    - `JWT_SECRET` - 隨機生成的密鑰
                                          -    - `ENCRYPTION_KEY` - 64 字符十六進制密鑰
                                               -    - `NEXTAUTH_SECRET` - NextAuth 密鑰
                                                    - 5. 點擊「Deploy」
                                                     
                                                      6. ### 方式 2：使用 Vercel CLI
                                                     
                                                      7. ```bash
                                                         # 安裝 Vercel CLI
                                                         npm i -g vercel

                                                         # 部署
                                                         vercel

                                                         # 設置環境變量
                                                         vercel env add DATABASE_URL
                                                         vercel env add JWT_SECRET
                                                         # ...

                                                         # 查看部署
                                                         vercel --prod
                                                         ```

                                                         ---

                                                         ## 🔗 數據庫設置

                                                         ### 選項 1：Neon (推薦，免費 5GB)

                                                         1. 訪問 [neon.tech](https://neon.tech)
                                                         2. 2. 使用 GitHub 登入（免費）
                                                            3. 3. 創建新 project
                                                               4. 4. 複製連接字符串到 `DATABASE_URL`
                                                                 
                                                                  5. ### 選項 2：本地 PostgreSQL
                                                                 
                                                                  6. ```bash
                                                                     # macOS (使用 Homebrew)
                                                                     brew install postgresql@15
                                                                     brew services start postgresql@15

                                                                     # 創建數據庫
                                                                     createdb pm_tool

                                                                     # 設置環境變量
                                                                     DATABASE_URL=postgresql://localhost:5432/pm_tool
                                                                     ```

                                                                     ---

                                                                     ## 🤖 AI 工具集成

                                                                     ### 配置 OpenAI

                                                                     1. 在應用中進入 Settings → AI Governance
                                                                     2. 2. 點擊「Add API Configuration」
                                                                        3. 3. 選擇「OpenAI」
                                                                           4. 4. 粘貼您的 OpenAI API Key
                                                                              5. 5. 點擊「Test Connection」
                                                                                 6. 6. 保存配置
                                                                                   
                                                                                    7. 成本追蹤將自動記錄每次 AI 調用。
                                                                                   
                                                                                    8. ---
                                                                                   
                                                                                    9. ## 📚 文檔
                                                                                   
                                                                                    10. - [完整架構文檔](./docs/ARCHITECTURE.md)
                                                                                        - - [API 文檔](./docs/API.md)
                                                                                          - - [數據庫設計](./docs/DATABASE.md)
                                                                                            - - [部署指南](./docs/DEPLOYMENT.md)
                                                                                              - - [開發指南](./docs/DEVELOPMENT.md)
                                                                                               
                                                                                                - ---

                                                                                                ## 🆘 故障排查

                                                                                                ### 端口 3000 已佔用

                                                                                                ```bash
                                                                                                # 使用其他端口
                                                                                                npm run dev -- -p 3001
                                                                                                ```

                                                                                                ### 數據庫連接失敗

                                                                                                ```bash
                                                                                                # 檢查連接字符串
                                                                                                echo $DATABASE_URL

                                                                                                # 測試連接
                                                                                                psql $DATABASE_URL
                                                                                                ```

                                                                                                ### 遷移失敗

                                                                                                ```bash
                                                                                                # 重置數據庫（謹慎使用！）
                                                                                                npx prisma migrate reset
                                                                                                ```

                                                                                                ---

                                                                                                ## 🤝 貢獻指南

                                                                                                詳見 [CONTRIBUTING.md](./CONTRIBUTING.md)

                                                                                                ---

                                                                                                ## 📋 可用命令

                                                                                                ```bash
                                                                                                npm run dev              # 啟動開發服務器
                                                                                                npm run build            # 構建生產版本
                                                                                                npm start                # 啟動生產服務器
                                                                                                npm run lint             # 運行代碼檢查
                                                                                                npm test                 # 運行所有測試
                                                                                                npm run test:unit        # 運行單元測試
                                                                                                npm run test:integration # 運行集成測試
                                                                                                npm run test:coverage    # 生成覆蓋率報告
                                                                                                npm run test:e2e         # 運行 E2E 測試
                                                                                                ```

                                                                                                ---

                                                                                                ## 📞 支持

                                                                                                - 提交 Issues：[GitHub Issues](https://github.com/glen200392/digital-transformation-pm/issues)
                                                                                                - - 討論功能：[GitHub Discussions](https://github.com/glen200392/digital-transformation-pm/discussions)
                                                                                                  - - 查看項目進度：[GitHub Projects](https://github.com/glen200392/digital-transformation-pm/projects)
                                                                                                   
                                                                                                    - ---
                                                                                                    
                                                                                                    ## 📄 許可證
                                                                                                    
                                                                                                    本項目採用 MIT 許可證。詳見 [LICENSE](./LICENSE)
                                                                                                    
                                                                                                    ---
                                                                                                    
                                                                                                    **準備好開始開發了嗎？** 👉 [查看完整架構文檔](./docs/ARCHITECTURE.md)
