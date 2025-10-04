#!/bin/bash

# 提示词导入工具
# 用法：./import-prompts.sh [txt文件路径]
# 支持格式：
# 1. 简单格式：名称|内容
# 2. 带顺序格式：序号|名称|内容

TERMINAL_PROMPT_DIR="$(dirname "$0")"
TERMINAL_PROMPT_FILE="$TERMINAL_PROMPT_DIR/terminal-prompts.json"
IMPORT_FILE="${1:-$TERMINAL_PROMPT_DIR/prompts-import.txt}"

# 颜色定义
COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_RED='\033[0;31m'
COLOR_CYAN='\033[0;36m'

echo -e "${COLOR_CYAN}📥 提示词导入工具${COLOR_RESET}"
echo ""

# 检查文件是否存在
if [ ! -f "$IMPORT_FILE" ]; then
    echo -e "${COLOR_RED}❌ 错误：找不到文件 $IMPORT_FILE${COLOR_RESET}"
    echo ""
    echo "用法："
    echo "  ./import-prompts.sh [txt文件路径]"
    echo ""
    echo "示例："
    echo "  ./import-prompts.sh                    # 使用默认文件 prompts-import.txt"
    echo "  ./import-prompts.sh my-prompts.txt     # 使用自定义文件"
    exit 1
fi

echo -e "${COLOR_YELLOW}📂 导入文件：$IMPORT_FILE${COLOR_RESET}"
echo ""

# 创建临时文件
TEMP_JSON=$(mktemp)

# 开始构建 JSON
cat > "$TEMP_JSON" << 'EOF'
{
  "modes": [
    {
      "id": "default",
      "name": "常用"
    }
  ],
  "prompts": [
EOF

# 计数器
count=0
total_lines=$(wc -l < "$IMPORT_FILE")

echo -e "${COLOR_CYAN}🔄 正在处理提示词...${COLOR_RESET}"

# 读取文件并处理每一行
while IFS= read -r line; do
    # 跳过空行和注释行
    if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
        continue
    fi
    
    # 检查是否包含分隔符 |
    if [[ "$line" == *"|"* ]]; then
        # 计算分隔符数量
        pipe_count=$(echo "$line" | tr -cd '|' | wc -c)
        
        if [ $pipe_count -eq 1 ]; then
            # 简单格式：名称|内容
            name=$(echo "$line" | cut -d'|' -f1 | xargs)
            content=$(echo "$line" | cut -d'|' -f2- | xargs)
            order=$count
        elif [ $pipe_count -eq 2 ]; then
            # 带顺序格式：序号|名称|内容
            order=$(echo "$line" | cut -d'|' -f1 | xargs)
            name=$(echo "$line" | cut -d'|' -f2 | xargs)
            content=$(echo "$line" | cut -d'|' -f3- | xargs)
            
            # 验证序号是否为数字
            if ! [[ "$order" =~ ^[0-9]+$ ]]; then
                echo -e "  ⚠️  ${COLOR_YELLOW}跳过无效序号：$line${COLOR_RESET}"
                continue
            fi
        else
            echo -e "  ⚠️  ${COLOR_YELLOW}跳过格式错误行：$line${COLOR_RESET}"
            continue
        fi
        
        # 跳过空的名称或内容
        if [[ -z "$name" || -z "$content" ]]; then
            continue
        fi
        
        # 增加计数器
        ((count++))
        
        # 添加逗号（除了第一个）
        if [ $count -gt 1 ]; then
            echo "," >> "$TEMP_JSON"
        fi
        
        # 转义 JSON 特殊字符
        name_escaped=$(echo "$name" | sed 's/\\/\\\\/g; s/"/\\"/g')
        content_escaped=$(echo "$content" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\n/\\n/g' | tr '\n' ' ')
        
        # 添加提示词到 JSON
        cat >> "$TEMP_JSON" << EOF
    {
      "id": "$order",
      "name": "$name_escaped",
      "content": "$content_escaped",
      "modeId": "default"
    }
EOF
        
        echo -e "  ✓ ${COLOR_GREEN}$name${COLOR_RESET}"
    else
        echo -e "  ⚠️  ${COLOR_YELLOW}跳过无效行：$line${COLOR_RESET}"
    fi
done < "$IMPORT_FILE"

# 结束 JSON
cat >> "$TEMP_JSON" << 'EOF'
  ]
}
EOF

# 验证 JSON 格式
if jq empty "$TEMP_JSON" 2>/dev/null; then
    # 备份原文件
    if [ -f "$TERMINAL_PROMPT_FILE" ]; then
        cp "$TERMINAL_PROMPT_FILE" "$TERMINAL_PROMPT_FILE.backup.$(date +%Y%m%d_%H%M%S)"
        echo -e "${COLOR_YELLOW}📋 已备份原文件${COLOR_RESET}"
    fi
    
    # 替换原文件
    mv "$TEMP_JSON" "$TERMINAL_PROMPT_FILE"
    
    echo ""
    echo -e "${COLOR_GREEN}✅ 导入完成！${COLOR_RESET}"
    echo -e "   📊 成功导入 ${COLOR_CYAN}$count${COLOR_RESET} 个提示词"
    echo -e "   📁 文件位置：${COLOR_CYAN}$TERMINAL_PROMPT_FILE${COLOR_RESET}"
    echo ""
    echo -e "${COLOR_YELLOW}💡 提示：${COLOR_RESET}"
    echo "   1. 重新加载提示词系统："
    echo "      source ~/终端嵌入/Slash-Command-Prompter/terminal-prompt.zsh"
    echo ""
    echo "   2. 或者重启终端自动加载"
    echo ""
    echo "   3. 按 // 呼出提示词库测试"
    
else
    echo -e "${COLOR_RED}❌ JSON 格式错误，导入失败${COLOR_RESET}"
    rm -f "$TEMP_JSON"
    exit 1
fi
