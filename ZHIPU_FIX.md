# 智谱 GLM API 配置修复说明

## 问题描述

之前使用智谱 GLM 模型时出现以下错误：
```
Error: model provider error: stream error: failed to deserialize api response: 
error:EOF while parsing a value at line 1 column 0 content:
```

**根本原因**：URL 拼接错误导致 API 请求发送到错误的端点。

- 智谱 API 的正确端点：`https://open.bigmodel.cn/api/paas/v4`
- 实际发送的端点：`https://open.bigmodel.cn/api/paas/v4/v1`（错误）

代码中的 `ensure_openai_v1()` 函数会自动在 URL 后追加 `/v1`，但智谱 API 的端点已经包含了版本号 `/v4`，不需要再追加。

## 修复内容

### 1. 改进 URL 拼接逻辑 (`crates/claw-cli/src/config.rs`)

修改了 `ensure_openai_v1()` 函数，使其能够智能判断是否需要追加 `/v1`：

```rust
fn ensure_openai_v1(url: &str) -> String {
    let trimmed = url.trim_end_matches('/');
    
    // Don't append /v1 if the URL already ends with a version pattern
    // Examples: /api/paas/v4, /v1, /api/v1, etc.
    if trimmed.ends_with("/v1") || trimmed.contains("/v4") || trimmed.contains("/api/paas") {
        trimmed.to_string()
    } else {
        format!("{}/v1", trimmed)
    }
}
```

### 2. 支持 ZHIPU_API_KEY 环境变量

添加了智谱 API Key 的环境变量检测：

```rust
let api_key = env_non_empty("ANTHROPIC_API_KEY")
    .or_else(|| env_non_empty("ANTHROPIC_AUTH_TOKEN"))
    .or_else(|| env_non_empty("ZHIPU_API_KEY"))
    .or_else(|| env_non_empty("OPENAI_API_KEY"));
```

当检测到 `ZHIPU_API_KEY` 时，自动使用 OpenAI 兼容模式，并默认连接到智谱 API 端点。

### 3. 自动配置智谱端点

当使用 `ZHIPU_API_KEY` 且未指定 `base_url` 时，自动使用智谱的 API 端点：

```rust
let default_url = if api_key.is_some() && base_url.is_none() {
    "https://open.bigmodel.cn/api/paas/v4"
} else {
    "https://api.openai.com"
};
```

## 使用方法

### 方式 1：使用环境变量（推荐）

```bash
export ZHIPU_API_KEY="your_api_key_here"
cargo run -- -m glm-4 -q '列出当前目录的文件'
```

### 方式 2：使用命令行参数

```bash
cargo run -- --provider openai -m glm-4 \
  --base-url https://open.bigmodel.cn/api/paas/v4 \
  -q '列出当前目录的文件'
```

### 方式 3：配置文件

创建 `~/.claw-code-rust/config.json`：

```json
{
  "provider": "openai",
  "model": "glm-4",
  "base_url": "https://open.bigmodel.cn/api/paas/v4",
  "api_key": "your_api_key_here"
}
```

然后运行：

```bash
cargo run -- -m glm-4 -q '列出当前目录的文件'
```

## 测试

运行单元测试验证 URL 拼接逻辑：

```bash
cargo test -p claw-cli test_ensure_openai_v1
```

测试覆盖的场景：
- ✅ 智谱 API (`/api/paas/v4`) - 不追加 `/v1`
- ✅ 已有 `/v1` 的 URL - 不追加 `/v1`
- ✅ Ollama (`localhost:11434`) - 追加 `/v1`
- ✅ 通用 OpenAI 兼容 API - 追加 `/v1`
- ✅ 带尾部斜杠的 URL - 正确处理

## 支持的提供商

现在支持以下提供商：

1. **Anthropic** - 使用 `ANTHROPIC_API_KEY` 或 `ANTHROPIC_AUTH_TOKEN`
2. **OpenAI / Zhipu GLM** - 使用 `OPENAI_API_KEY` 或 `ZHIPU_API_KEY`
3. **Ollama** - 本地运行的 Ollama 服务

## 注意事项

1. **API Key 安全**：不要将 API Key 提交到版本控制系统
2. **环境变量优先级**：CLI 参数 > 环境变量 > 配置文件
3. **模型名称**：确保使用正确的模型名称（如 `glm-4`、`glm-3-turbo` 等）

## 相关资源

- [智谱 AI 开放平台](https://open.bigmodel.cn/)
- [智谱 GLM API 文档](https://open.bigmodel.cn/dev/api)
- [OpenAI 兼容 API 格式](https://platform.openai.com/docs/api-reference)
