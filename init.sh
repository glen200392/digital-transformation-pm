#!/bin/bash

# Digital Transformation PM Tool - Complete Initialization Script
# This script sets up the entire Next.js application with all dependencies

set -e

echo "🚀 Starting Digital Transformation PM Tool Setup..."

# Step 1: Create directory structure
echo "📁 Creating directory structure..."
mkdir -p app/{api/{auth,projects,tasks,warnings,ai,export,audit},\(dashboard\)/{settings/ai-governance,projects,tasks}}
mkdir -p components/{layout,dashboard,projects,tasks,ai,common,forms}
mkdir -p lib/{services,api}
mkdir -p types
mkdir -p prisma/migrations
mkdir -p database/{migrations,seeds}
mkdir -p .github/workflows
mkdir -p __tests__/{unit,integration}
mkdir -p public/{images,icons}

echo "✅ Directories created!"

# Step 2: Install dependencies
echo "📦 Installing npm dependencies..."
npm install

# Step 3: Create all configuration files
echo "⚙️ Creating configuration files..."

# tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
      "target": "ES2020",
          "useDefineForClassFields": true,
              "lib": ["ES2020", "DOM", "DOM.Iterable"],
                  "skipLibCheck": true,
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
                                                              "paths": { "@/*": ["./*"] }
                                                                },
                                                                  "include": ["**/*.ts", "**/*.tsx"],
                                                                    "exclude": ["node_modules"]
                                                                    }
                                                                    EOF

                                                                    # next.config.js
                                                                    cat > next.config.js << 'EOF'
                                                                    const nextConfig = {
                                                                      reactStrictMode: true,
                                                                        swcMinify: true,
                                                                          headers: async () => [{
                                                                              source: '/:path*',
                                                                                  headers: [
                                                                                        { key: 'X-Content-Type-Options', value: 'nosniff' },
                                                                                              { key: 'X-Frame-Options', value: 'DENY' },
                                                                                                    { key: 'X-XSS-Protection', value: '1; mode=block' }
                                                                                                        ]
                                                                                                          }]
                                                                                                          };
                                                                                                          module.exports = nextConfig;
                                                                                                          EOF
                                                                                                          
                                                                                                          # tailwind.config.js
                                                                                                          cat > tailwind.config.js << 'EOF'
                                                                                                          module.exports = {
                                                                                                            content: ['./app/**/*.{js,ts,jsx,tsx}', './components/**/*.{js,ts,jsx,tsx}'],
                                                                                                              theme: { extend: {} },
                                                                                                                plugins: []
                                                                                                                };
                                                                                                                EOF
                                                                                                                
                                                                                                                # jest.config.js
                                                                                                                cat > jest.config.js << 'EOF'
                                                                                                                const nextJest = require('next/jest')
                                                                                                                const createJestConfig = nextJest({ dir: './' })
                                                                                                                module.exports = createJestConfig({
                                                                                                                  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
                                                                                                                    testEnvironment: 'jest-environment-jsdom',
                                                                                                                      moduleNameMapper: { '^@/(.*)$': '<rootDir>/$1' }
                                                                                                                      });
                                                                                                                      EOF
                                                                                                                      
                                                                                                                      # postcss.config.js
                                                                                                                      cat > postcss.config.js << 'EOF'
                                                                                                                      module.exports = {
                                                                                                                        plugins: {
                                                                                                                            tailwindcss: {},
                                                                                                                                autoprefixer: {}
                                                                                                                                  }
                                                                                                                                  };
                                                                                                                                  EOF
                                                                                                                                  
                                                                                                                                  echo "✅ Configuration files created!"
                                                                                                                                  
                                                                                                                                  # Step 4: Initialize Prisma
                                                                                                                                  echo "🗄️ Initializing Prisma..."
                                                                                                                                  npx prisma init
                                                                                                                                  
                                                                                                                                  # Create Prisma schema file (must be created manually - see docs)
                                                                                                                                  echo "⚠️ Please copy the Prisma schema from docs/COMPLETE_IMPLEMENTATION_GUIDE.md to prisma/schema.prisma"
                                                                                                                                  
                                                                                                                                  # Step 5: Create core application files
                                                                                                                                  echo "📝 Creating core application files..."
                                                                                                                                  
                                                                                                                                  # Create middleware.ts
                                                                                                                                  cat > middleware.ts << 'EOF'
                                                                                                                                  import { NextRequest, NextResponse } from 'next/server';
                                                                                                                                  
                                                                                                                                  export function middleware(request: NextRequest) {
                                                                                                                                    const token = request.cookies.get('token')?.value;
                                                                                                                                      
                                                                                                                                        if (!token && request.nextUrl.pathname.startsWith('/dashboard')) {
                                                                                                                                            return NextResponse.redirect(new URL('/auth/login', request.url));
                                                                                                                                              }
                                                                                                                                                
                                                                                                                                                  return NextResponse.next();
                                                                                                                                                  }
                                                                                                                                                  
                                                                                                                                                  export const config = {
                                                                                                                                                    matcher: ['/dashboard/:path*', '/api/protected/:path*']
                                                                                                                                                    };
                                                                                                                                                    EOF
                                                                                                                                                    
                                                                                                                                                    # Step 6: Create basic API routes
                                                                                                                                                    echo "🔧 Creating basic API route..."
                                                                                                                                                    
                                                                                                                                                    mkdir -p app/api/health
                                                                                                                                                    cat > app/api/health/route.ts << 'EOF'
                                                                                                                                                    import { NextRequest, NextResponse } from 'next/server';
                                                                                                                                                    
                                                                                                                                                    export async function GET(request: NextRequest) {
                                                                                                                                                      return NextResponse.json({ status: 'ok', timestamp: new Date() });
                                                                                                                                                      }
                                                                                                                                                      EOF
                                                                                                                                                      
                                                                                                                                                      echo "✅ API routes created!"
                                                                                                                                                      
                                                                                                                                                      # Step 7: Create root layout
                                                                                                                                                      mkdir -p app
                                                                                                                                                      cat > app/layout.tsx << 'EOF'
                                                                                                                                                      import type { Metadata } from 'next';
                                                                                                                                                      import './globals.css';
                                                                                                                                                      
                                                                                                                                                      export const metadata: Metadata = {
                                                                                                                                                        title: 'Digital Transformation PM',
                                                                                                                                                          description: 'Enterprise project management tool'
                                                                                                                                                          };
                                                                                                                                                          
                                                                                                                                                          export default function RootLayout({
                                                                                                                                                            children,
                                                                                                                                                            }: {
                                                                                                                                                              children: React.ReactNode;
                                                                                                                                                              }) {
                                                                                                                                                                return (
                                                                                                                                                                    <html lang="zh-TW">
                                                                                                                                                                          <body>{children}</body>
                                                                                                                                                                              </html>
                                                                                                                                                                                );
                                                                                                                                                                                }
                                                                                                                                                                                EOF
                                                                                                                                                                                
                                                                                                                                                                                # Create root page
                                                                                                                                                                                cat > app/page.tsx << 'EOF'
                                                                                                                                                                                export default function Home() {
                                                                                                                                                                                  return (
                                                                                                                                                                                      <main className="min-h-screen bg-gradient-to-br from-blue-600 to-blue-800">
                                                                                                                                                                                            <div className="flex items-center justify-center h-screen">
                                                                                                                                                                                                    <div className="text-center text-white">
                                                                                                                                                                                                              <h1 className="text-4xl font-bold mb-4">數位轉型PM工具</h1>
                                                                                                                                                                                                                        <p className="text-xl mb-8">企業級專案管理平台</p>
                                                                                                                                                                                                                                  <a href="/auth/login" className="bg-white text-blue-600 px-6 py-2 rounded font-bold">
                                                                                                                                                                                                                                              登入
                                                                                                                                                                                                                                                        </a>
                                                                                                                                                                                                                                                                </div>
                                                                                                                                                                                                                                                                      </div>
                                                                                                                                                                                                                                                                          </main>
                                                                                                                                                                                                                                                                            );
                                                                                                                                                                                                                                                                            }
                                                                                                                                                                                                                                                                            EOF
                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                            # Create globals.css
                                                                                                                                                                                                                                                                            cat > app/globals.css << 'EOF'
                                                                                                                                                                                                                                                                            @tailwind base;
                                                                                                                                                                                                                                                                            @tailwind components;
                                                                                                                                                                                                                                                                            @tailwind utilities;
                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                            * {
                                                                                                                                                                                                                                                                              margin: 0;
                                                                                                                                                                                                                                                                                padding: 0;
                                                                                                                                                                                                                                                                                  box-sizing: border-box;
                                                                                                                                                                                                                                                                                  }
                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                  body {
                                                                                                                                                                                                                                                                                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                                                                                                                                                                                                                                                                                    }
                                                                                                                                                                                                                                                                                    EOF
                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                    echo "✅ Core files created!"
                                                                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                                                                    # Step 8: Create environment file
                                                                                                                                                                                                                                                                                    echo "🔐 Creating .env.local..."
                                                                                                                                                                                                                                                                                    if [ ! -f .env.local ]; then
                                                                                                                                                                                                                                                                                      cp .env.example .env.local
                                                                                                                                                                                                                                                                                        echo "✅ .env.local created! Please update with your configuration."
                                                                                                                                                                                                                                                                                        else
                                                                                                                                                                                                                                                                                          echo "ℹ️ .env.local already exists"
                                                                                                                                                                                                                                                                                          fi
                                                                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                                                                          echo ""
                                                                                                                                                                                                                                                                                          echo "🎉 Initialization complete!"
                                                                                                                                                                                                                                                                                          echo ""
                                                                                                                                                                                                                                                                                          echo "Next steps:"
                                                                                                                                                                                                                                                                                          echo "1. Update .env.local with your database URL"
                                                                                                                                                                                                                                                                                          echo "2. Copy Prisma schema from docs/COMPLETE_IMPLEMENTATION_GUIDE.md to prisma/schema.prisma"
                                                                                                                                                                                                                                                                                          echo "3. Run: npx prisma migrate dev --name init"
                                                                                                                                                                                                                                                                                          echo "4. Run: npm run dev"
                                                                                                                                                                                                                                                                                          echo ""
