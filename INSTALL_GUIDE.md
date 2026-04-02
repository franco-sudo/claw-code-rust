# 🚀 Claw RS 一键安装指南

## ✨ 新功能：一键安装，开箱即用！

现在你只需要运行一次安装脚本，就可以直接使用 `claw` 命令，无需任何额外配置！

---

## 📥 安装步骤

### 方式一：使用批处理脚本（推荐）

1. **双击运行** `install.bat`
2. 按照提示完成以下操作：
   - ✅ 自动编译项目
   - ✅ 创建启动器
   - ✅ 添加到 PATH（可选）
   - ✅ 配置 AI 提供商（关键！）

### 方式二：使用 PowerShell 脚本（更现代的界面）

1. **右键点击** `install.ps1`
2. 选择 **"使用 PowerShell 运行"**

或者在 PowerShell 中运行：
```powershell
.\install.ps1
```

---

## 🎯 安装过程中的选择

### 步骤 1-3：基础安装
- 编译 release 版本
- 创建启动器
- 添加到 PATH（建议选择 Y）

### 步骤 4：AI 提供商配置（重要！）

安装程序会提供三个选项：

#### 选项 [1]：智谱 GLM API（推荐中国用户）
- ✅ 优秀的中文支持
- ✅ 价格实惠
- ✅ 可用模型：glm-4、glm-3-turbo

**如何获取 API Key：**
1. 访问 https://open.bigmodel.cn/
2. 注册/登录账号
3. 进入 API 控制台
4. 创建新的 API Key
5. 复制并粘贴到安装程序

#### 选项 [2]：Anthropic Claude API
- ✅ 强大的代码理解能力
- ✅ 高质量的回答
- ✅ 可用模型：claude-sonnet-4、claude-opus

**如何获取 API Key：**
1. 访问 https://console.anthropic.com/
2. 注册/登录账号
3. 获取 API Key

#### 选项 [3]：跳过配置
如果暂时没有 API Key，可以选择跳过，稍后通过以下方式配置：
- 运行 `claw` 进入交互式设置
- 设置环境变量
- 编辑配置文件

---

## ✅ 安装完成后

### 立即开始使用

安装完成后，你可以直接在任何目录运行：

```cmd
claw
```

### 常用命令

```cmd
# 交互式对话
claw

# 单次查询
claw -q "你好，请帮我解释一下这段代码"

# 指定模型
claw -m glm-4 -q "Hello"

# 查看帮助
claw --help

# 查看版本
claw --version
```

---

## 🔧 高级选项

### 快速安装（跳过配置）

如果你想先安装，稍后再配置：

**批处理：**
```cmd
install.bat
# 然后在第 4 步选择 3
```

**PowerShell：**
```powershell
.\install.ps1 -SkipConfig
```

### 仅添加到 PATH，不配置

**PowerShell：**
```powershell
.\install.ps1 -SkipPath
```

---

## 📁 配置文件位置

配置文件保存在：
```
%USERPROFILE%\.claw-code-rust\config.json
```

即：
```
C:\Users\54708\.claw-code-rust\config.json
```

### 手动编辑配置示例

**智谱 GLM：**
```json
{
  "provider": "openai",
  "model": "glm-4",
  "base_url": "https://open.bigmodel.cn/api/paas/v4",
  "api_key": "your_api_key_here"
}
```

**Anthropic Claude：**
```json
{
  "provider": "anthropic",
  "model": "claude-sonnet-4-20250514",
  "api_key": "your_api_key_here"
}
```

---

## 🆘 故障排除

### 问题 1：提示找不到 claw 命令

**解决方案：**
1. 确认安装时选择了添加到 PATH
2. 重启终端窗口（CMD/PowerShell）
3. 或者使用完整路径运行：
   ```cmd
   C:\Users\54708\Desktop\claw\claw-code-rust\claw.bat
   ```

### 问题 2：提示模型不存在

**原因：** 使用了错误的模型名称

**解决方案：**
- 智谱用户使用 `-m glm-4` 参数
- 或者修改配置文件中的 model 字段

### 问题 3：API Key 无效

**解决方案：**
1. 检查 API Key 是否正确复制（无多余空格）
2. 确认 API Key 未过期
3. 重新运行安装程序或手动编辑配置文件

---

## 🎉 开始使用

安装完成后，直接运行：

```cmd
claw
```

享受你的 AI 编程助手！🚀

---

## 📝 更新日志

**v0.3.9 更新：**
- ✅ 新增一键安装功能
- ✅ 自动配置 AI 提供商
- ✅ 支持智谱 GLM 和 Anthropic Claude
- ✅ 优化的中文用户体验
- ✅ 修复启动器脚本问题
