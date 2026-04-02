#!/bin/bash

# 测试智谱 GLM API 配置修复

echo "=== 测试 URL 拼接逻辑 ==="
echo ""

# 测试用例
test_url() {
    local input="$1"
    local expected="$2"
    
    # 使用 Rust 测试（需要添加测试代码）
    echo "输入：$input"
    echo "期望：$expected"
    echo ""
}

echo "测试 1: 智谱 API (应保持不变)"
test_url "https://open.bigmodel.cn/api/paas/v4" "https://open.bigmodel.cn/api/paas/v4"

echo "测试 2: OpenAI (应添加 /v1)"
test_url "https://api.openai.com" "https://api.openai.com/v1"

echo "测试 3: Ollama (应添加 /v1)"
test_url "http://localhost:11434" "http://localhost:11434/v1"

echo "测试 4: 已包含 /v1 的 URL (应保持不变)"
test_url "https://api.example.com/v1" "https://api.example.com/v1"

echo ""
echo "=== 运行实际测试 ==="
echo ""

# 设置环境变量（请替换为您的实际 API Key）
export ZHIPU_API_KEY="xxxxx"

# 运行测试命令
cargo run -- -m glm-4 -q '列出当前目录的文件' 2>&1 | head -20

echo ""
echo "=== 测试完成 ==="
