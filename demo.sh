#!/bin/bash

# Demo script showing the complete workflow

echo "=========================================="
echo "Claw RS - Complete Setup & Usage Demo"
echo "=========================================="
echo ""

echo "📦 Step 1: Build release binary"
echo "----------------------------------------"
cargo build --release
echo ""

echo "🔧 Step 2: Install claw command"
echo "----------------------------------------"
./install.sh
echo ""

echo "💡 Step 3: Usage examples"
echo "----------------------------------------"
echo ""
echo "✅ Now you can use:"
echo ""
echo "  # Interactive chat (recommended)"
echo "  claw"
echo ""
echo "  # Single query"
echo "  claw -q 'Hello, help me review this code'"
echo ""
echo "  # With custom model"
echo "  claw -m glm-3-turbo"
echo ""
echo "  # View all options"
echo "  claw --help"
echo ""

echo "🎯 Key features:"
echo "----------------------------------------"
echo "✨ API key auto-saved after first use"
echo "✨ Config stored in ~/.claw-code-rust/config.json"
echo "✨ One command to start GLM-4 chat"
echo "✨ Full terminal availability"
echo ""

echo "🚀 Quick start:"
echo "----------------------------------------"
echo "export ZHIPU_API_KEY='your_api_key_here'"
echo "claw"
echo ""
