# 🚀 Claw RS - 一句话总结

## 安装（一次性）
```bash
./install.sh
```

## 使用（每次只需一行）
```bash
claw
```

## 完成！✨

- ✅ **全局可用**：任何目录都能用 `claw` 命令
- ✅ **一次配置**：首次设置 API Key 后自动保存
- ✅ **智能聊天**：支持多轮对话、工具调用、文件编辑

---

## 详细用法

### 交互式聊天
```bash
claw
> 帮我写一个 Rust 函数
> 优化这段代码
> 解释这个错误
```

### 单次查询
```bash
claw -q "查看当前目录结构"
```

### 帮助
```bash
claw --help
```

---

## 配置文件
- **位置**：`~/.claw-code-rust/config.json`
- **内容**：自动保存的 API Key 和 provider 设置
- **重置**：`rm ~/.claw-code-rust/config.json`

---

**就这么简单！** 🎉
