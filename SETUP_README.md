# Claw RS - GLM 快速启动配置说明

## ✅ 已完成的改进

### 1. **自动保存 API Key** ✨
- **功能**：首次使用智谱 API Key 后，自动保存到配置文件
- **位置**：`~/.claw-code-rust/config.json`
- **优势**：只需配置一次，后续无需重复设置（除非手动切换）

**修改文件**：
- `crates/claw-cli/src/config.rs` - 添加了自动保存逻辑

### 2. **全局终端命令** 🚀
- **命令**：`claw`
- **安装方式**：运行 `./install.sh`
- **效果**：在任何目录下都可以直接使用 `claw` 命令

**新增文件**：
- `claw` - GLM 快速启动脚本
- `install.sh` - 一键安装脚本
- `demo.sh` - 完整演示脚本

---

## 🎯 快速开始（3 步完成）

### Step 1: 编译与安装
```bash
cd /Users/daijingchao/Desktop/claw2/claw-code-rust
./install.sh
```

### Step 2: 设置 API Key（仅首次）
```bash
export ZHIPU_API_KEY='XXX'
```

### Step 3: 启动聊天
```bash
claw
```

**完成！** 🎉 以后只需输入 `claw` 即可，API Key 已自动保存。

---

## 📝 使用示例

### 交互式聊天（多轮对话，保持上下文）
```bash
claw
```

然后输入：
```
> 帮我总结此项目
> 查看 main.rs 文件的结构
> 帮我优化这个函数
```

### 单次查询
```bash
claw -q "列出当前目录的文件"
```

### 查看帮助
```bash
claw --help
```

---

## 🔧 技术细节

### 自动保存逻辑
当检测到环境变量中的 API Key 时，会在成功构建 provider 后自动保存到配置文件：

```rust
// Auto-save config on first successful use
if file.api_key.is_none() && api_key.is_some() {
    file.provider = Some(name.clone());
    file.api_key = api_key.clone();
    file.base_url = base_url.clone();
    let _ = save_config(&file); // 忽略错误，尽力而为
}
```

### 配置文件格式
```json
{
  "provider": "openai",
  "model": "glm-4",
  "base_url": "https://open.bigmodel.cn/api/paas/v4",
  "api_key": "your_saved_api_key"
}
```

### 优先级顺序
1. **环境变量**（最高优先级，可随时覆盖）
2. **配置文件**（自动保存的配置）
3. **CLI 参数**（命令行指定）

---

## 🛠️ 高级用法

### 切换 API Key
```bash
export ZHIPU_API_KEY='new_api_key'
claw
# 新配置会自动覆盖旧配置
```

### 使用其他模型
```bash
claw -m glm-3-turbo
```

### 自定义系统提示词
```bash
claw --system "你是一个专业的代码审查专家"
```

### 权限控制
```bash
claw -p interactive  # 每次操作前询问
claw -p deny        # 拒绝所有工具调用
claw -p auto        # 自动批准（默认）
```

---

## 📂 文件清单

### 新增文件
- ✅ `claw` - GLM 快速启动脚本
- ✅ `install.sh` - 安装脚本
- ✅ `demo.sh` - 演示脚本
- ✅ `QUICK_START.md` - 详细使用指南
- ✅ `SETUP_README.md` - 本文件

### 修改文件
- ✅ `crates/claw-cli/src/config.rs` - 添加自动保存功能
- ✅ `crates/core/src/query.rs` - 修复 UTF-8 截断 bug

---

## ❓ 常见问题

### Q: 如何查看保存的配置？
```bash
cat ~/.claw-code-rust/config.json
```

### Q: 如何重置配置？
```bash
rm ~/.claw-code-rust/config.json
```

### Q: 如何在多个 API Key 之间切换？
直接设置环境变量并重新运行即可：
```bash
export ZHIPU_API_KEY='another_key'
claw
```

### Q: 不记得是否设置过 API Key 怎么办？
直接运行 `claw`，如果已保存会使用配置，未保存会提示设置。

---

## 🎉 总结

现在你可以：

1. ✅ **全局使用** `claw` 命令（任何终端目录）
2. ✅ **一次配置**，永久使用（自动保存 API Key）
3. ✅ **一键启动** GLM-4 模型聊天
4. ✅ **灵活切换**（随时可用环境变量覆盖）

**开始享受流畅的 AI 编程体验吧！** 🚀
