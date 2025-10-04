#!/bin/bash

# 简单转换工具
# 用法：./convert.sh [txt文件路径]

TERMINAL_PROMPT_DIR="$(dirname "$0")"
TERMINAL_PROMPT_FILE="$TERMINAL_PROMPT_DIR/terminal-prompts.json"
INPUT_FILE="${1:-$TERMINAL_PROMPT_DIR/prompts-import.txt}"

# 颜色定义
COLOR_RESET='\033[0m'
COLOR_GREEN='\033[0;32m'
COLOR_CYAN='\033[0;36m'

echo -e "${COLOR_CYAN}🔄 转换中...${COLOR_RESET}"

# 检查文件是否存在
if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ 找不到文件：$INPUT_FILE"
    exit 1
fi

# 备份原文件
if [ -f "$TERMINAL_PROMPT_FILE" ]; then
    cp "$TERMINAL_PROMPT_FILE" "$TERMINAL_PROMPT_FILE.backup.$(date +%Y%m%d_%H%M%S)"
fi

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
            order=$((count + 1))
        elif [ $pipe_count -eq 2 ]; then
            # 带顺序格式：序号|名称|内容
            order=$(echo "$line" | cut -d'|' -f1 | xargs)
            name=$(echo "$line" | cut -d'|' -f2 | xargs)
            content=$(echo "$line" | cut -d'|' -f3- | xargs)
            
            # 验证序号是否为数字
            if ! [[ "$order" =~ ^[0-9]+$ ]]; then
                continue
            fi
        else
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
        content_escaped=$(echo "$content" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' ')
        
        # 添加提示词到 JSON
        cat >> "$TEMP_JSON" << EOF
    {
      "id": "$order",
      "name": "$name_escaped",
      "content": "$content_escaped",
      "modeId": "default"
    }
EOF
    fi
done < "$INPUT_FILE"

# 结束 JSON
cat >> "$TEMP_JSON" << 'EOF'
  ]
}
EOF

# 验证 JSON 格式并替换
if jq empty "$TEMP_JSON" 2>/dev/null; then
    mv "$TEMP_JSON" "$TERMINAL_PROMPT_FILE"
    echo -e "${COLOR_GREEN}✅ 转换完成！${COLOR_RESET}"
    echo -e "   📊 共 ${COLOR_CYAN}$count${COLOR_RESET} 个提示词"
    echo -e "   💡 重新加载：source ~/终端嵌入/Slash-Command-Prompter/terminal-prompt.zsh"
else
    echo "❌ JSON 格式错误"
    rm -f "$TEMP_JSON"
    exit 1
fi
