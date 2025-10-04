#!/bin/bash

# 合并所有模式到JSON文件
# 用法：./merge-modes.sh

TERMINAL_PROMPT_DIR="$(dirname "$0")"
TERMINAL_PROMPT_FILE="$TERMINAL_PROMPT_DIR/terminal-prompts.json"

# 颜色定义
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_CYAN="\033[0;36m"
COLOR_RESET="\033[0m"

echo -e "${COLOR_CYAN}🔄 合并所有模式到JSON文件${COLOR_RESET}\n"

# 备份原文件
if [ -f "$TERMINAL_PROMPT_FILE" ]; then
    cp "$TERMINAL_PROMPT_FILE" "$TERMINAL_PROMPT_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${COLOR_YELLOW}📋 已备份原文件${COLOR_RESET}"
fi

# 创建临时文件
TEMP_JSON=$(mktemp)

# 开始构建 JSON
cat > "$TEMP_JSON" << 'EOF'
{
  "modes": [
    {
      "id": "reading",
      "name": "看书"
    },
    {
      "id": "learning",
      "name": "学习"
    },
    {
      "id": "programming",
      "name": "编程"
    },
    {
      "id": "problem",
      "name": "问题"
    },
    {
      "id": "crawler",
      "name": "爬虫"
    }
  ],
  "prompts": [
EOF

# 处理每个模式文件
mode_files=("看书-prompts.txt" "学习-prompts.txt" "编程-prompts.txt" "问题-prompts.txt" "爬虫-prompts.txt")
mode_ids=("reading" "learning" "programming" "problem" "crawler")
mode_names=("看书" "学习" "编程" "问题" "爬虫")

total_prompts=0

for i in "${!mode_files[@]}"; do
    file="${mode_files[$i]}"
    mode_id="${mode_ids[$i]}"
    mode_name="${mode_names[$i]}"
    
    if [ -f "$TERMINAL_PROMPT_DIR/$file" ]; then
        echo -e "${COLOR_CYAN}📂 处理模式：$mode_name${COLOR_RESET}"
        
        # 读取文件并处理每一行
        local name=""
        local content=""
        local reading_content=false
        
        while IFS= read -r line; do
            # 跳过注释行
            if [[ "$line" =~ ^[[:space:]]*# ]]; then
                continue
            fi
            
            # 如果是空行，表示一个提示词结束
            if [[ -z "$line" ]]; then
                if [[ -n "$name" && -n "$content" ]]; then
                    # 增加计数器
                    ((total_prompts++))
                    
                    # 添加逗号（除了第一个）
                    if [ $total_prompts -gt 1 ]; then
                        echo "," >> "$TEMP_JSON"
                    fi
                    
                    # 转义 JSON 特殊字符
                    name_escaped=$(echo "$name" | sed 's/\\/\\\\/g; s/"/\\"/g')
                    content_escaped=$(echo "$content" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' ')
                    
                    # 添加提示词到 JSON
                    cat >> "$TEMP_JSON" << EOF
    {
      "id": "$total_prompts",
      "name": "$name_escaped",
      "content": "$content_escaped",
      "modeId": "$mode_id"
    }
EOF
                    
                    echo -e "  ✓ ${COLOR_GREEN}$name${COLOR_RESET}"
                fi
                # 重置变量
                name=""
                content=""
                reading_content=false
                continue
            fi
            
            # 如果还没有名称，这行就是名称
            if [[ -z "$name" ]]; then
                name=$(echo "$line" | xargs)
                reading_content=true
            # 如果已经有名称，这行就是内容
            elif [[ "$reading_content" == true ]]; then
                if [[ -n "$content" ]]; then
                    content="${content} ${line}"
                else
                    content="$line"
                fi
            fi
        done < "$TERMINAL_PROMPT_DIR/$file"
        
        # 处理最后一个提示词（如果文件末尾没有空行）
        if [[ -n "$name" && -n "$content" ]]; then
            # 增加计数器
            ((total_prompts++))
            
            # 添加逗号（除了第一个）
            if [ $total_prompts -gt 1 ]; then
                echo "," >> "$TEMP_JSON"
            fi
            
            # 转义 JSON 特殊字符
            name_escaped=$(echo "$name" | sed 's/\\/\\\\/g; s/"/\\"/g')
            content_escaped=$(echo "$content" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' ')
            
            # 添加提示词到 JSON
            cat >> "$TEMP_JSON" << EOF
    {
      "id": "$total_prompts",
      "name": "$name_escaped",
      "content": "$content_escaped",
      "modeId": "$mode_id"
    }
EOF
            
            echo -e "  ✓ ${COLOR_GREEN}$name${COLOR_RESET}"
        fi
    else
        echo -e "${COLOR_YELLOW}⚠ 找不到文件：$file${COLOR_RESET}"
    fi
done

# 结束 JSON
cat >> "$TEMP_JSON" << 'EOF'
  ]
}
EOF

# 验证 JSON 格式并替换
if jq empty "$TEMP_JSON" 2>/dev/null; then
    mv "$TEMP_JSON" "$TERMINAL_PROMPT_FILE"
    echo -e "\n${COLOR_GREEN}✅ 合并完成！${COLOR_RESET}"
    echo -e "   📊 共 ${COLOR_CYAN}$total_prompts${COLOR_RESET} 个提示词"
    echo -e "   📁 文件位置：${COLOR_CYAN}$TERMINAL_PROMPT_FILE${COLOR_RESET}"
    echo -e "\n${COLOR_YELLOW}💡 提示：${COLOR_RESET}"
    echo "   1. 重新加载提示词系统："
    echo "      source ~/终端嵌入/Slash-Command-Prompter/terminal-prompt.zsh"
    echo ""
    echo "   2. 或者重启终端自动加载"
    echo ""
    echo "   3. 按 // 呼出模式选择测试"
else
    echo -e "\n${COLOR_YELLOW}❌ JSON 格式错误${COLOR_RESET}"
    rm -f "$TEMP_JSON"
    exit 1
fi
