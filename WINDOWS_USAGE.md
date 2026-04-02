# Claw RS - Windows 使用指南

## ✅ 问题已解决！

之前的错误是因为启动器脚本中的二进制文件名不正确。现在已经修复完成。

## 📁 文件说明

- **claw-rs.exe** - 实际的可执行文件（位于 `target/release/claw-rs.exe`）
- **claw.bat** - Windows 启动器脚本（已修复）
- **install.bat** - 安装脚本（批处理版本）
- **install.ps1** - 安装脚本（PowerShell 版本）

## 🚀 使用方法

### 方法一：直接使用启动器（当前可用）

```cmd
c:\Users\54708\Desktop\claw\claw-code-rust\claw.bat
```

或者简写为：
```cmd
claw
```

### 方法二：运行可执行文件

```cmd
c:\Users\54708\Desktop\claw\claw-code-rust\target\release\claw-rs.exe
```

### 方法三：使用 cargo 运行（开发模式）

```cmd
cd c:\Users\54708\Desktop\claw\claw-code-rust
cargo run
```

## ⚙️ 配置 API Key

首次使用前需要设置 API Key：

### 临时设置（仅当前终端窗口有效）
```cmd
set ZHIPU_API_KEY=your_api_key_here
claw
```

### 永久设置
```cmd
setx ZHIPU_API_KEY "your_api_key_here"
```

然后重启终端窗口，再运行 `claw` 即可。

## 💡 常用命令

```cmd
# 交互式对话
claw

# 单次查询
claw -q "你好，请帮我解释一下这段代码"

# 指定模型
claw -m qwen3.5:9b -q "Hello"

# 查看帮助
claw --help

# 查看版本
claw --version
```

## 📋 完整参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `-m, --model` | 使用的模型 | - |
| `-s, --system` | 系统提示词 | "You are a helpful coding assistant..." |
| `-p, --permission` | 权限模式：auto, interactive, deny | auto |
| `-q, --query` | 单次查询模式 | - |
| `--provider` | AI 提供商：anthropic, ollama, openai | 自动检测 |
| `--ollama-url` | Ollama 服务器地址 | http://localhost:11434 |
| `--max-turns` | 最大对话轮数 | 100 |

## 🔧 故障排除

### 问题：提示找不到 claw-rs.exe

**解决方案：**
1. 确认已经编译项目：`cargo build --release`
2. 检查文件是否存在：`dir target\release\claw-rs.exe`
3. 如果不存在，重新编译：`cargo build --release`

### 问题：想要全局使用 claw 命令

**解决方案：**
1. 运行安装脚本：`install.bat`
2. 选择添加到 PATH
3. 重启终端窗口

或者手动添加环境变量：
1. 右键"此电脑" → 属性 → 高级系统设置
2. 环境变量 → 用户变量 → Path → 编辑
3. 添加路径：`C:\Users\54708\Desktop\claw\claw-code-rust`

## 📝 配置文件位置

配置文件保存在：
```
%USERPROFILE%\.claw-code-rust\config.json
```

即：
```
C:\Users\54708\.claw-code-rust\config.json
```

## 🎯 下一步

现在你可以直接运行 `claw` 命令开始使用了！

```cmd
claw
```

祝你使用愉快！🎉
