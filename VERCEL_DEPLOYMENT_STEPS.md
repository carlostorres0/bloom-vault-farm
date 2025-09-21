# Bloom Vault Farm - Vercel 部署步骤指南

## 项目概述

Bloom Vault Farm 是一个基于FHE（完全同态加密）技术的去中心化农业金融平台。项目已完成重构，移除了所有lovable依赖，集成了真实的钱包连接功能。

## 部署前准备

### 1. 项目信息
- **GitHub仓库**: https://github.com/carlostorres0/bloom-vault-farm
- **技术栈**: Vite + React + TypeScript + RainbowKit + FHE
- **网络**: Sepolia测试网

### 2. 环境变量配置
```env
NEXT_PUBLIC_CHAIN_ID=11155111
NEXT_PUBLIC_RPC_URL=https://sepolia.infura.io/v3/b18fb7e6ca7045ac83c41157ab93f990
NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID=2ec9743d0d0cd7fb94dee1a7e6d33475
NEXT_PUBLIC_INFURA_API_KEY=b18fb7e6ca7045ac83c41157ab93f990
```

## 详细部署步骤

### 步骤 1: 访问 Vercel 并登录
1. 打开浏览器，访问 [vercel.com](https://vercel.com)
2. 点击 "Sign up" 或 "Log in"
3. 选择 "Continue with GitHub" 进行GitHub授权

### 步骤 2: 导入项目
1. 在Vercel仪表板中，点击 "New Project"
2. 选择 "Import Git Repository"
3. 在搜索框中输入 `carlostorres0/bloom-vault-farm`
4. 找到项目后点击 "Import"

### 步骤 3: 配置构建设置
1. **Framework Preset**: 选择 `Vite`
2. **Root Directory**: 留空（项目在根目录）
3. **Build Command**: `npm run build`
4. **Output Directory**: `dist`
5. **Install Command**: `npm install`

### 步骤 4: 配置环境变量
在项目设置页面，添加以下环境变量：

#### 必需的环境变量：
```
NEXT_PUBLIC_CHAIN_ID = 11155111
NEXT_PUBLIC_RPC_URL = https://sepolia.infura.io/v3/b18fb7e6ca7045ac83c41157ab93f990
NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID = 2ec9743d0d0cd7fb94dee1a7e6d33475
NEXT_PUBLIC_INFURA_API_KEY = b18fb7e6ca7045ac83c41157ab93f990
```

#### 配置步骤：
1. 在项目设置中，点击 "Environment Variables"
2. 为每个变量添加：
   - **Name**: 变量名（如 NEXT_PUBLIC_CHAIN_ID）
   - **Value**: 对应的值
   - **Environment**: 选择 Production, Preview, Development
3. 点击 "Save" 保存每个变量

### 步骤 5: 部署项目
1. 确认所有设置正确后，点击 "Deploy"
2. 等待构建完成（通常需要2-3分钟）
3. 构建成功后，Vercel会提供一个部署URL

### 步骤 6: 验证部署
1. 访问部署URL
2. 测试钱包连接功能
3. 确认所有页面正常加载
4. 验证环境变量是否正确配置

## 项目特性验证

### 钱包连接测试
1. 点击 "Connect Wallet" 按钮
2. 选择支持的钱包（MetaMask、Rainbow等）
3. 确认连接到Sepolia测试网
4. 测试钱包切换功能

### 页面功能测试
- **首页**: 检查品牌信息和导航
- **Dashboard**: 验证仪表板功能
- **Yield Predictions**: 测试预测功能
- **Finance**: 验证财务管理
- **Analytics**: 检查分析页面

### FHE合约功能
- 验证智能合约交互
- 测试加密数据功能
- 确认隐私保护特性

## 故障排除

### 常见问题及解决方案

#### 1. 构建失败
**问题**: 构建过程中出现错误
**解决方案**:
- 检查环境变量是否正确设置
- 确认所有依赖都已安装
- 查看构建日志中的具体错误信息

#### 2. 钱包连接失败
**问题**: 无法连接钱包
**解决方案**:
- 确认WalletConnect Project ID正确
- 检查RPC URL是否可访问
- 验证网络配置

#### 3. 环境变量未生效
**问题**: 环境变量在运行时未生效
**解决方案**:
- 确认变量名以 `NEXT_PUBLIC_` 开头
- 重新部署项目
- 清除浏览器缓存

### 调试步骤
1. 检查Vercel构建日志
2. 使用浏览器开发者工具查看控制台错误
3. 验证网络请求是否正常
4. 确认钱包网络设置

## 生产环境优化

### 性能优化
1. 启用Vercel Analytics（可选）
2. 配置CDN缓存
3. 优化图片和静态资源

### 安全配置
1. 配置安全头部（已在vercel.json中设置）
2. 启用HTTPS（Vercel自动提供）
3. 设置CSP策略（如需要）

### 监控设置
1. 配置错误监控
2. 设置性能监控
3. 配置用户分析

## 后续维护

### 更新部署
1. 推送代码到GitHub
2. Vercel自动触发重新部署
3. 验证新版本功能

### 域名配置
1. 在Vercel项目设置中添加自定义域名
2. 配置DNS记录
3. 启用SSL证书

### 备份策略
1. 定期备份代码仓库
2. 保存环境变量配置
3. 记录部署历史

## 技术支持

### 相关文档
- [Vercel部署文档](https://vercel.com/docs)
- [RainbowKit文档](https://www.rainbowkit.com/docs/introduction)
- [FHEVM文档](https://docs.fhevm.org/)

### 联系信息
- GitHub仓库: https://github.com/carlostorres0/bloom-vault-farm
- 项目文档: 查看项目README.md

## 部署检查清单

- [ ] Vercel账户已创建并连接GitHub
- [ ] 项目已成功导入到Vercel
- [ ] 构建设置已正确配置（Vite框架）
- [ ] 所有环境变量已添加
- [ ] 项目已成功部署
- [ ] 钱包连接功能正常
- [ ] 所有页面可正常访问
- [ ] 智能合约交互正常
- [ ] 性能优化已配置
- [ ] 监控和错误跟踪已设置

## 总结

Bloom Vault Farm项目已完成全面重构，具备以下特性：

✅ **完全移除lovable依赖**
✅ **集成真实钱包连接（RainbowKit + Wagmi + Viem）**
✅ **FHE智能合约完整实现**
✅ **现代化UI/UX设计**
✅ **生产环境部署就绪**
✅ **完整的文档和部署指南**

项目现在可以安全地部署到生产环境，为用户提供安全、私密的农业金融服务。
