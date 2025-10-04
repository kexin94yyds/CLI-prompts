#!/bin/bash

# 测试模式选择功能

TERMINAL_PROMPT_DIR="/Users/apple/终端嵌入/Slash-Command-Prompter"
TERMINAL_PROMPT_FILE="$TERMINAL_PROMPT_DIR/terminal-prompts.json"

echo "🎯 测试模式选择功能"
echo ""

# 检查文件是否存在
if [ ! -f "$TERMINAL_PROMPT_FILE" ]; then
    echo "❌ 找不到提示词文件：$TERMINAL_PROMPT_FILE"
    exit 1
fi

echo "✅ 提示词文件存在"
echo ""

# 显示所有模式
echo "📋 可用模式："
jq -r '.modes[] | "  - \(.name) (ID: \(.id))"' "$TERMINAL_PROMPT_FILE"
echo ""

# 显示编程模式提示词
echo "🚀 编程模式提示词："
jq -r '.prompts[] | select(.modeId == "programming") | "  - \(.name)"' "$TERMINAL_PROMPT_FILE"
echo ""

# 显示学习模式提示词
echo "📚 学习模式提示词："
jq -r '.prompts[] | select(.modeId == "learning") | "  - \(.name)"' "$TERMINAL_PROMPT_FILE"
echo ""

echo "✅ 模式系统测试完成！"
