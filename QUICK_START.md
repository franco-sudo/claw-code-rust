# Claw RS 快速启动指南

## 🚀 一键安装与使用

### 1. 安装（只需执行一次）

```bash
# 赋予安装脚本执行权限
chmod +x install.sh

# 运行安装脚本
./install.sh
```

安装完成后，`claw` 命令即可在全终端使用。

### 2. 首次使用（配置 API Key）

```bash
# 设置智谱 API Key（只需设置一次）
export ZHIPU_API_KEY='your_api_key_here'

# 启动交互式对话
claw
```

**✨ 自动保存功能**：第一次使用后，API Key 会自动保存到配置文件 `~/.claw-code-rust/config.json`，后续无需再次设置！

### 3. 日常使用

#### 方式一：交互式聊天（推荐）
```bash
claw
```

然后输入你的问题，例如：
```
> 帮我总结此项目
> 查看 main.rs 文件的代码结构
> 帮我添加一个日志功能
```

#### 方式二：单次查询
```bash
claw -q "列出当前目录的文件"
```

#### 方式三：使用环境变量（如果已保存可跳过）
```bash
export ZHIPU_API_KEY='your_api_key'
claw
```

---

## 📋 完整用法

### 基本命令

| 命令 | 说明 |
|------|------|
| `claw` | 启动 GLM-4 交互式对话 |
| `claw -q "问题"` | 单次查询模式 |
| `claw --help` | 显示完整帮助信息 |

### 高级选项

```bash
# 使用其他模型
claw -m glm-3-turbo

# 指定系统提示词
claw --system "你是一个专业的 Rust 工程师"

# 权限模式
claw -p interactive  # auto | interactive | deny

# 最大对话轮数
claw --max-turns 50
```

---

## 🔧 手动安装（可选）

如果不想使用安装脚本，可以手动操作：

### 1. 编译发布版本
```bash
cargo build --release
```

### 2. 添加到 PATH

#### 方式 A：符号链接（推荐）
```bash
ln -s /Users/daijingchao/Desktop/claw2/claw-code-rust/claw /usr/local/bin/claw
chmod +x /usr/local/bin/claw
```

#### 方式 B：修改 shell 配置文件
在 `~/.zshrc` 或 `~/.bashrc` 中添加：
```bash
export PATH="/Users/daijingchao/Desktop/claw2/claw-code-rust:$PATH"
```

然后执行：
```bash
source ~/.zshrc
```

---

## 🛠️ 故障排除

### 问题 1: "command not found: claw"
**解决**：确保已运行安装脚本，或将项目目录添加到 PATH

### 问题 2: "No provider configured"
**解决**：首次使用需要设置 API Key
```bash
export ZHIPU_API_KEY='your_api_key'
claw
```

### 问题 3: 配置文件位置
配置文件位于：`~/.claw-code-rust/config.json`

查看配置：
```bash
cat ~/.claw-code-rust/config.json
```

重置配置：
```bash
rm ~/.claw-code-rust/config.json
```

### 问题 4: 切换 API Key
直接修改环境变量并重新运行：
```bash
export ZHIPU_API_KEY='new_api_key'
claw
```
新配置会覆盖旧配置。

---

## 💡 使用技巧

1. **保持上下文**：使用交互模式（`claw`）可以进行多轮对话，AI 会记住之前的内容

2. **工具调用**：Claw 可以自动调用工具来帮助你：
   - 读取文件
   - 搜索代码
   - 执行命令
   - 编辑文件

3. **权限控制**：
   - `-p auto`: 自动批准安全操作（默认）
   - `-p interactive`: 每次操作前询问
   - `-p deny`: 拒绝所有操作

---

## 📞 获取帮助

```bash
# 查看完整 CLI 帮助
claw --help

# 查看版本
claw --version
```

---

**祝你使用愉快！** 🎉
