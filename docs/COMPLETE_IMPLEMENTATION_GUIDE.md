# 🚀 完整實現指南 - 一鍵設置

由於在 GitHub Web UI 上逐個手動創建 500+ 個文件效率極低，我為您準備了一個**完整的自動化設置方案**。

## ⚡ 快速開始（推薦）

### 使用自動化腳本（5 分鐘內完成完整設置）

```bash
# 1. 克隆倉庫
git clone https://github.com/glen200392/digital-transformation-pm.git
cd digital-transformation-pm

# 2. 運行自動化設置腳本
chmod +x setup.sh
./setup.sh

# 3. 啟動應用
npm run dev
```

---

## 📂 完整的項目結構和文件清單

### 步驟 1：創建項目結構（使用以下命令）

```bash
# 創建所有必要的目錄
mkdir -p app/{api/{auth,projects,tasks,warnings,ai,export,audit},\(dashboard\)/{settings/ai-governance,projects,tasks}}
mkdir -p components/{layout,dashboard,projects,tasks,ai,common,forms}
mkdir -p lib/{services,api}
mkdir -p types
mkdir -p prisma/migrations
mkdir -p database/{migrations,seeds}
mkdir -p .github/workflows
mkdir -p docs
mkdir -p __tests__/{unit,integration}
mkdir -p public/{images,icons}
```

### 步驟 2：創建配置文件

#### tsconfig.json
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "skip
LibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
```

#### next.config.js
```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  compression: true,
  poweredByHeader: false,
  headers: async () => {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff'
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY'
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block'
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin'
          }
        ]
      }
    ]
  }
};

module.exports = nextConfig;
```

#### tailwind.config.js
```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx}',
    './components/**/*.{js,ts,jsx,tsx}'
  ],
  theme: {
    extend: {
      colors: {
        primary: '#2563eb',
        secondary: '#64748b',
        success: '#10b981',
        warning: '#f59e0b',
        danger: '#ef4444'
      }
    }
  },
  plugins: []
};
```

#### jest.config.js
```javascript
const nextJest = require('next/jest')

const createJestConfig = nextJest({
  dir: './',
})

const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  testEnvironment: 'jest-environment-jsdom',
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/$1',
  },
  testMatch: [
    '**/__tests__/**/*.[jt]s?(x)',
    '**/?(*.)+(spec|test).[jt]s?(x)',
  ],
  collectCoverageFrom: [
    'app/**/*.{js,jsx,ts,tsx}',
    'components/**/*.{js,jsx,ts,tsx}',
    'lib/**/*.{js,jsx,ts,tsx}',
    '!**/*.d.ts',
    '!**/node_modules/**',
  ],
}

module.exports = createJestConfig(customJestConfig)
```

---

## 🗄️ 數據庫配置

### Prisma Schema (prisma/schema.prisma)

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// 用戶模型
model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String?
  password  String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  projects  Project[]
  tasks     Task[]
  auditLogs AuditLog[]
  aiConfigs AIConfig[]

  @@index([email])
}

// 項目模型
model Project {
  id          String   @id @default(cuid())
  name        String
  description String?
  status      String   @default("PLANNING") // PLANNING, ACTIVE, COMPLETED
  owner       User     @relation(fields: [ownerId], references: [id])
  ownerId     String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  phases    ProjectPhase[]
  tasks     Task[]
  warnings  Warning[]
  auditLogs AuditLog[]

  @@index([ownerId])
  @@index([status])
}

// 項目階段
model ProjectPhase {
  id          String   @id @default(cuid())
  projectId   String
  project     Project  @relation(fields: [projectId], references: [id], onDelete: Cascade)
  name        String
  description String?
  startDate   DateTime?
  endDate     DateTime?
  status      String   @default("NOT_STARTED")
  createdAt   DateTime @default(now())

  tasks Task[]

  @@index([projectId])
}

// 任務模型
model Task {
  id          String   @id @default(cuid())
  projectId   String
  project     Project  @relation(fields: [projectId], references: [id], onDelete: Cascade)
  phaseId     String?
  phase       ProjectPhase? @relation(fields: [phaseId], references: [id], onDelete: SetNull)
  title       String
  description String?
  status      String   @default("TODO") // TODO, IN_PROGRESS, COMPLETED
  priority    String   @default("MEDIUM") // LOW, MEDIUM, HIGH, CRITICAL
  assignedTo  User?    @relation(fields: [assignedToId], references: [id])
  assignedToId String?
  startDate   DateTime?
  dueDate     DateTime?
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  subtasks      Subtask[]
  dependencies  TaskDependency[] @relation("fromTask")
  dependents    TaskDependency[] @relation("toTask")
  collaborators TaskCollaborator[]
  auditLogs     AuditLog[]
  warnings      Warning[]
  aiLogs        AIUsageLog[]

  @@index([projectId])
  @@index([phaseId])
  @@index([assignedToId])
  @@index([dueDate])
  @@index([status])
}

// 子任務
model Subtask {
  id          String   @id @default(cuid())
  taskId      String
  task        Task     @relation(fields: [taskId], references: [id], onDelete: Cascade)
  title       String
  status      String   @default("TODO")
  completedAt DateTime?
  createdAt   DateTime @default(now())

  @@index([taskId])
}

// 任務依賴
model TaskDependency {
  id               String   @id @default(cuid())
  fromTaskId       String
  fromTask         Task     @relation("fromTask", fields: [fromTaskId], references: [id], onDelete: Cascade)
  toTaskId         String
  toTask           Task     @relation("toTask", fields: [toTaskId], references: [id], onDelete: Cascade)
  dependencyType   String   @default("DEPENDS_ON") // DEPENDS_ON, BLOCKS, RELATED_TO
  createdAt        DateTime @default(now())

  @@unique([fromTaskId, toTaskId])
  @@index([fromTaskId])
  @@index([toTaskId])
}

// 任務協作者
model TaskCollaborator {
  id              String   @id @default(cuid())
  taskId          String
  task            Task     @relation(fields: [taskId], references: [id], onDelete: Cascade)
  collaboratorId  String
  collaborator    User     @relation(fields: [collaboratorId], references: [id], onDelete: Cascade)
  department      String?
  role            String   @default("SUPPORT") // MAIN, SUPPORT, REVIEWER
  status          String   @default("PENDING") // PENDING, CONFIRMED
  createdAt       DateTime @default(now())

  @@unique([taskId, collaboratorId])
  @@index([taskId])
  @@index([collaboratorId])
}

// AI 配置
model AIConfig {
  id               String   @id @default(cuid())
  userId           String
  user             User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  provider         String   // OpenAI, Claude, etc
  apiKeyEncrypted  String   // AES-256 encrypted
  model            String?
  isActive         Boolean  @default(true)
  createdAt        DateTime @default(now())
  updatedAt        DateTime @updatedAt

  @@index([userId])
  @@index([provider])
}

// AI 使用日誌
model AIUsageLog {
  id              String   @id @default(cuid())
  taskId          String?
  task            Task?    @relation(fields: [taskId], references: [id], onDelete: SetNull)
  provider        String
  model           String?
  tokensUsed      Int
  estimatedCost   Decimal  @db.Decimal(10, 4)
  purpose         String?
  createdAt       DateTime @default(now())

  @@index([createdAt])
  @@index([provider])
  @@index([taskId])
}

// 預警
model Warning {
  id          String   @id @default(cuid())
  projectId   String
  project     Project  @relation(fields: [projectId], references: [id], onDelete: Cascade)
  taskId      String?
  task        Task?    @relation(fields: [taskId], references: [id], onDelete: SetNull)
  title       String
  description String?
  severity    String   @default("MEDIUM") // LOW, MEDIUM, HIGH, CRITICAL
  status      String   @default("OPEN") // OPEN, ACKNOWLEDGED, RESOLVED
  createdAt   DateTime @default(now())
  resolvedAt  DateTime?

  @@index([projectId])
  @@index([severity])
  @@index([status])
}

// 審計日誌
model AuditLog {
  id        String   @id @default(cuid())
  entityType String  // PROJECT, TASK, etc
  entityId  String
  action    String  // CREATE, UPDATE, DELETE
  oldValue  Json?
  newValue  Json?
  changedBy User    @relation(fields: [changedById], references: [id])
  changedById String
  changedAt DateTime @default(now())

  @@index([entityType, entityId])
  @@index([changedBy])
  @@index([changedAt])
}
```

---

## 📝 核心 API 實現代碼

### POST /api/auth/register

```typescript
// app/api/auth/register/route.ts
import { NextRequest, NextResponse } from 'next/server';
import bcrypt from 'bcryptjs';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function POST(request: NextRequest) {
  try {
    const { email, password, name } = await request.json();

    // 驗證輸入
    if (!email || !password) {
      return NextResponse.json(
        { error: '郵箱和密碼必填' },
        { status: 400 }
      );
    }

    // 檢查用戶是否存在
    const existingUser = await prisma.user.findUnique({
      where: { email }
    });

    if (existingUser) {
      return NextResponse.json(
        { error: '用戶已存在' },
        { status: 409 }
      );
    }

    // 加鹽密碼
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // 創建用戶
    const user = await prisma.user.create({
      data: {
        email,
        name: name || email.split('@')[0],
        password: hashedPassword
      },
      select: {
        id: true,
        email: true,
        name: true,
        createdAt: true
      }
    });

    return NextResponse.json(
      { message: '註冊成功', user },
      { status: 201 }
    );
  } catch (error) {
    console.error('Registration error:', error);
    return NextResponse.json(
      { error: '服務器錯誤' },
      { status: 500 }
    );
  }
}
```

### GET /api/projects

```typescript
// app/api/projects/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const page = parseInt(searchParams.get('page') || '1');
    const limit = parseInt(searchParams.get('limit') || '10');
    const skip = (page - 1) * limit;

    const projects = await prisma.project.findMany({
      skip,
      take: limit,
      include: {
        _count: {
          select: { tasks: true }
        }
      },
      orderBy: { createdAt: 'desc' }
    });

    const total = await prisma.project.count();

    return NextResponse.json({
      data: projects,
      pagination: {
        page,
        limit,
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    return NextResponse.json(
      { error: '獲取項目失敗' },
      { status: 500 }
    );
  }
}
```

---

## 🎨 前端頁面示例

### app/(dashboard)/page.tsx

```typescript
'use client';

import { useEffect, useState } from 'react';
import axios from 'axios';

export default function Dashboard() {
  const [projects, setProjects] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchProjects();
  }, []);

  const fetchProjects = async () => {
    try {
      const response = await axios.get('/api/projects?limit=10');
      setProjects(response.data.data);
    } catch (error) {
      console.error('Failed to fetch projects:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-6">儀表板</h1>

      {loading ? (
        <div>加載中...</div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {projects.map((project: any) => (
            <div key={project.id} className="border rounded-lg p-4 shadow">
              <h3 className="font-semibold text-lg">{project.name}</h3>
              <p className="text-gray-600">{project.description}</p>
              <p className="text-sm text-gray-500 mt-2">
                任務: {project._count.tasks}
              </p>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
```

---

## ✅ 完整的設置檢查清單

按照以下步驟完成設置：

```bash
# 1. 克隆並進入項目
git clone https://github.com/glen200392/digital-transformation-pm.git
cd digital-transformation-pm

# 2. 創建所有項目目錄和文件
# 運行上方提供的 mkdir 命令

# 3. 創建所有配置文件
# 複製上方提供的 tsconfig.json, next.config.js, tailwind.config.js, jest.config.js

# 4. 初始化 Prisma
npx prisma init

# 5. 創建 Prisma Schema（複製上方提供的 schema）
# 編輯 prisma/schema.prisma

# 6. 創建數據庫
npx prisma migrate dev --name init

# 7. 安裝依賴
npm install

# 8. 啟動開發服務器
npm run dev
```

---

## 📚 後續步驟

1. 完成所有 API 端點實現
2. 2. 完成所有前端頁面
   3. 3. 添加測試用例
      4. 4. 進行安全審計
         5. 5. 部署到 Vercel
           
            6. ---
           
            7. **需要幫助？** 查看 QUICK_START.md 或 docs/ 文件夾中的其他文檔。
