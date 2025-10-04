#!/bin/bash

# 提示词顺序调整工具
# 用法：./reorder-prompts.sh

TERMINAL_PROMPT_DIR="$(dirname "$0")"
TERMINAL_PROMPT_FILE="$TERMINAL_PROMPT_DIR/terminal-prompts.json"
OUTPUT_FILE="$TERMINAL_PROMPT_DIR/reordered-prompts.txt"

# 颜色定义
COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_CYAN='\033[0;36m'

echo -e "${COLOR_CYAN}🔄 提示词顺序调整工具${COLOR_RESET}"
echo ""

# 检查文件是否存在
if [ ! -f "$TERMINAL_PROMPT_FILE" ]; then
    echo -e "${COLOR_RED}❌ 错误：找不到提示词文件 $TERMINAL_PROMPT_FILE${COLOR_RESET}"
    exit 1
fi

echo -e "${COLOR_YELLOW}📂 当前提示词文件：$TERMINAL_PROMPT_FILE${COLOR_RESET}"
echo ""

# 生成带顺序的 txt 文件
echo "# 提示词顺序调整文件" > "$OUTPUT_FILE"
echo "# 格式：序号|名称|内容" >> "$OUTPUT_FILE"
echo "# 修改序号来调整显示顺序，数字越小越靠前" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# 提取提示词并生成文件
jq -r '.prompts[] | "\(.id)|\(.name)|\(.content)"' "$TERMINAL_PROMPT_FILE" >> "$OUTPUT_FILE"

echo -e "${COLOR_GREEN}✅ 已生成顺序调整文件：${COLOR_RESET}"
echo -e "   📁 ${COLOR_CYAN}$OUTPUT_FILE${COLOR_RESET}"
echo ""

echo -e "${COLOR_YELLOW}📋 当前提示词顺序：${COLOR_RESET}"
jq -r '.prompts[] | "\(.id). \(.name)"' "$TERMINAL_PROMPT_FILE" | head -10

echo ""
echo -e "${COLOR_CYAN}💡 使用方法：${COLOR_RESET}"
echo "1. 编辑 $OUTPUT_FILE 文件"
echo "2. 修改每行开头的序号来调整顺序"
echo "3. 运行：./import-prompts.sh $OUTPUT_FILE"
echo "4. 重新加载：source ~/终端嵌入/Slash-Command-Prompter/terminal-prompt.zsh"
echo ""

echo -e "${COLOR_YELLOW}📝 示例：${COLOR_RESET}"
echo "将："
echo "  1|思路|我不是让你直接执行..."
echo "  2|Test|先测试再提交"
echo ""
echo "改为："
echo "  1|Test|先测试再提交"
echo "  2|思路|我不是让你直接执行..."
echo ""
echo "这样 Test 就会显示在思路前面了！"
