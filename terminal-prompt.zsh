#!/usr/bin/env zsh

# 终端提示词系统 - 简化版（类似 Codex 斜杠命令）
# 按快捷键直接呼出提示词列表

# 配置文件路径
TERMINAL_PROMPT_DIR="${TERMINAL_PROMPT_DIR:-/Users/apple/终端嵌入/Slash-Command-Prompter}"
TERMINAL_PROMPT_FILE="${TERMINAL_PROMPT_FILE:-$TERMINAL_PROMPT_DIR/terminal-prompts.json}"

# 颜色定义
COLOR_RESET='\033[0m'
COLOR_BLUE='\033[0;34m'
COLOR_GREEN='\033[0;32m'
COLOR_YELLOW='\033[0;33m'
COLOR_CYAN='\033[0;36m'

# 检查必需的工具
check_dependencies() {
    local missing_deps=()
    
    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi
    
    if ! command -v fzf &> /dev/null; then
        missing_deps+=("fzf")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${COLOR_YELLOW}缺少工具：${missing_deps[*]}${COLOR_RESET}"
        echo "请安装：brew install jq fzf"
        return 1
    fi
    
    return 0
}

# 获取所有提示词（格式化显示）
get_all_prompts() {
    if [ ! -f "$TERMINAL_PROMPT_FILE" ]; then
        return
    fi
    
    jq -r '.prompts[] | "\(.name)"' "$TERMINAL_PROMPT_FILE" 2>/dev/null
}

# 获取提示词内容
get_prompt_content() {
    local prompt_name="$1"
    if [ ! -f "$TERMINAL_PROMPT_FILE" ]; then
        return
    fi
    
    jq -r --arg name "$prompt_name" \
        '.prompts[] | select(.name == $name) | .content' \
        "$TERMINAL_PROMPT_FILE" 2>/dev/null
}

# 显示模式选择器（支持直接搜索）
show_modes() {
    if ! check_dependencies; then
        return 1
    fi
    
    # 获取所有模式和提示词
    local modes=$(jq -r '.modes[] | "\(.id)|\(.name)"' "$TERMINAL_PROMPT_FILE" 2>/dev/null)
    # 修改：同时包含名称和内容，用于搜索
    local all_prompts=$(jq -r '.prompts[] | "\(.name)|\(.modeId)|\(.content)"' "$TERMINAL_PROMPT_FILE" 2>/dev/null)
    
    if [ -z "$modes" ]; then
        echo -e "${COLOR_YELLOW}没有找到模式${COLOR_RESET}"
        return 1
    fi
    
    # 创建混合列表：模式 + 所有提示词（包含内容用于搜索）
    local mixed_list=""
      mixed_list+="$(echo "$modes" | sed 's/^/  /')\n"
      mixed_list+="\n提示词库:\n"
      mixed_list+="$(echo "$all_prompts" | sed 's/^/  /')"
    
    # 使用 fzf 显示混合列表
    local selected=$(echo -e "$mixed_list" | \
        fzf --height 60% +m --select-1 \
            --reverse \
            --border rounded \
            --prompt="搜索: " \
            --header="选择模式 或 直接搜索提示词 | 输入搜索 ↑↓选择 Enter进入 Esc退出" \
            --preview="echo ''; echo -e '\033[1;36m内容预览：\033[0m'; echo ''; if [[ {} == *'|'* ]]; then name=\$(echo {} | sed 's/^  //' | cut -d'|' -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'); mode_id=\$(echo {} | sed 's/^  //' | cut -d'|' -f2 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'); if [[ \$mode_id == reading || \$mode_id == learning || \$mode_id == programming || \$mode_id == problem || \$mode_id == crawler ]]; then cat /Users/apple/终端嵌入/Slash-Command-Prompter/terminal-prompts.json | jq -r --arg name \"\$name\" --arg mode_id \"\$mode_id\" '.prompts[] | select(.name == \$name and .modeId == \$mode_id) | .content' | fold -w 70 -s; else echo \"模式: \$name\"; fi; else echo \"选择模式\"; fi" \
            --preview-window=right:50%:wrap \
            --color='fg:#d0d0d0,bg:#1e1e1e,hl:#a855f7' \
            --color='fg+:#a855f7,bg+:#3a3a3a,hl+:#a855f7' \
            --color='info:#afaf87,prompt:#a855f7,pointer:#a855f7' \
            --color='marker:#ff5f87,spinner:#ff5f87,header:#87afaf' \
            --marker='*')
    
    if [ -n "$selected" ]; then
        # 去掉前导空格
        selected=$(echo "$selected" | sed 's/^  //')
        
        # 检查是否是模式选择
        if [[ "$selected" == "模式选择:" ]]; then
            # 重新显示模式选择
            show_modes
        elif [[ "$selected" == "提示词搜索:" ]]; then
            # 显示所有提示词搜索
            show_all_prompts
        elif [[ "$selected" == *"|"* ]]; then
            # 检查是模式还是提示词
            local first_part=$(echo "$selected" | cut -d'|' -f1)
            local second_part=$(echo "$selected" | cut -d'|' -f2)
            
            if [[ "$second_part" == "reading" || "$second_part" == "learning" || "$second_part" == "programming" || "$second_part" == "problem" || "$second_part" == "crawler" ]]; then
                # 这是提示词，直接插入
                local name="$first_part"
                local mode_id="$second_part"
                local content=$(jq -r --arg name "$name" --arg mode_id "$mode_id" '.prompts[] | select(.name == $name and .modeId == $mode_id) | .content' "$TERMINAL_PROMPT_FILE" 2>/dev/null)
                if [ -n "$content" ]; then
                    echo -n "$content" | pbcopy
                    LBUFFER="${LBUFFER}${content}"
                    # 设置标记，表示刚刚使用了提示词
                    export TERMINAL_PROMPT_JUST_USED=1
                fi
            else
                # 这是模式，进入模式选择
                local mode_id="$first_part"
                local mode_name="$second_part"
                show_prompts_for_mode "$mode_id" "$mode_name"
            fi
        fi
    fi
}

# 显示指定模式的提示词选择器
show_prompts_for_mode() {
    local mode_id="$1"
    local mode_name="$2"
    
    if ! check_dependencies; then
        return 1
    fi
    
    # 获取指定模式的提示词名称
    local prompts=$(jq -r --arg mode_id "$mode_id" '.prompts[] | select(.modeId == $mode_id) | .name' "$TERMINAL_PROMPT_FILE" 2>/dev/null)
    
    if [ -z "$prompts" ]; then
        echo -e "${COLOR_YELLOW}模式 $mode_name 没有找到提示词${COLOR_RESET}"
        return 1
    fi
    
    # 使用 fzf 显示提示词列表
    local selected=$(echo "$prompts" | \
        fzf --height 60% \
            --reverse \
            --border rounded \
            --prompt="/ " \
            --header="$mode_name | ↑↓选择 Enter插入 Esc退出" \
            --preview="echo ''; echo -e '\033[1;36m内容预览：\033[0m'; echo ''; cat $TERMINAL_PROMPT_FILE | jq -r --arg name {} --arg mode_id '$mode_id' '.prompts[] | select(.name == \$name and .modeId == \$mode_id) | .content' | fold -w 70 -s" \
            --preview-window=right:50%:wrap \
            --color='fg:#d0d0d0,bg:#1e1e1e,hl:#a855f7' \
            --color='fg+:#a855f7,bg+:#3a3a3a,hl+:#a855f7' \
            --color='info:#afaf87,prompt:#a855f7,pointer:#a855f7' \
            --color='marker:#ff5f87,spinner:#ff5f87,header:#87afaf' \
            --marker='✓' \
            --bind='ctrl-y:execute-silent(cat $TERMINAL_PROMPT_FILE | jq -r --arg name {} --arg mode_id '$mode_id' '"'"'.prompts[] | select(.name == $name and .modeId == $mode_id) | .content'"'"' | pbcopy)+abort')
    
    if [ -n "$selected" ]; then
        # 获取选中提示词的内容
        local content=$(jq -r --arg name "$selected" --arg mode_id "$mode_id" '.prompts[] | select(.name == $name and .modeId == $mode_id) | .content' "$TERMINAL_PROMPT_FILE" 2>/dev/null)
        if [ -n "$content" ]; then
            # 复制到剪贴板（静默）
            echo -n "$content" | pbcopy
            
            # 插入到命令行
            LBUFFER="${LBUFFER}${content}"
            # 设置标记，表示刚刚使用了提示词
            export TERMINAL_PROMPT_JUST_USED=1
        fi
    fi
}

# 显示选择方式菜单
show_prompt_menu() {
    if ! check_dependencies; then
        return 1
    fi
    
    # 显示选择方式
    local choice=$(echo -e "选择模式\n搜索所有提示词" | \
        fzf --height 40% \
            --reverse \
            --border rounded \
            --prompt="选择方式: " \
            --header="选择使用方式 | ↑↓选择 Enter进入 Esc退出" \
            --color='fg:#d0d0d0,bg:#1e1e1e,hl:#a855f7' \
            --color='fg+:#a855f7,bg+:#3a3a3a,hl+:#a855f7' \
            --color='info:#afaf87,prompt:#a855f7,pointer:#a855f7' \
            --color='marker:#ff5f87,spinner:#ff5f87,header:#87afaf' \
            --marker='*')
    
    if [ -n "$choice" ]; then
        if [ "$choice" = "选择模式" ]; then
            show_modes
        elif [ "$choice" = "搜索所有提示词" ]; then
            show_all_prompts
        fi
    fi
}

# 搜索所有提示词
show_all_prompts() {
    if ! check_dependencies; then
        return 1
    fi
    
    # 获取所有提示词名称和模式
    local prompts=$(jq -r '.prompts[] | "\(.name)|\(.modeId)"' "$TERMINAL_PROMPT_FILE" 2>/dev/null)
    
    if [ -z "$prompts" ]; then
        echo -e "${COLOR_YELLOW}没有找到提示词${COLOR_RESET}"
        return 1
    fi
    
    # 使用 fzf 显示提示词列表，支持搜索
    local selected=$(echo "$prompts" | \
        fzf --height 60% \
            --reverse \
            --border rounded \
            --prompt="/ " \
            --header="提示词库 | 输入搜索 ↑↓选择 Enter插入 Esc退出" \
            --preview="echo ''; echo -e '\033[1;36m内容预览：\033[0m'; echo ''; local name=\$(echo {} | cut -d'|' -f1); local mode_id=\$(echo {} | cut -d'|' -f2); cat \$TERMINAL_PROMPT_FILE | jq -r --arg name \"\$name\" --arg mode_id \"\$mode_id\" '.prompts[] | select(.name == \$name and .modeId == \$mode_id) | .content' | fold -w 70 -s" \
            --preview-window=right:50%:wrap \
            --color='fg:#d0d0d0,bg:#1e1e1e,hl:#a855f7' \
            --color='fg+:#a855f7,bg+:#3a3a3a,hl+:#a855f7' \
            --color='info:#afaf87,prompt:#a855f7,pointer:#a855f7' \
            --color='marker:#ff5f87,spinner:#ff5f87,header:#87afaf' \
            --marker='✓' \
            --bind='ctrl-y:execute-silent(cat $TERMINAL_PROMPT_FILE | jq -r --arg name $(echo {} | cut -d"|" -f1) --arg mode_id $(echo {} | cut -d"|" -f2) '"'"'.prompts[] | select(.name == $name and .modeId == $mode_id) | .content'"'"' | pbcopy)+abort')
    
    if [ -n "$selected" ]; then
        # 提取提示词名称和模式ID
        local name=$(echo "$selected" | cut -d'|' -f1)
        local mode_id=$(echo "$selected" | cut -d'|' -f2)
        
        # 获取选中提示词的内容
        local content=$(jq -r --arg name "$name" --arg mode_id "$mode_id" '.prompts[] | select(.name == $name and .modeId == $mode_id) | .content' "$TERMINAL_PROMPT_FILE" 2>/dev/null)
        if [ -n "$content" ]; then
            # 复制到剪贴板（静默）
            echo -n "$content" | pbcopy
            
            # 插入到命令行
            LBUFFER="${LBUFFER}${content}"
            # 设置标记，表示刚刚使用了提示词
            export TERMINAL_PROMPT_JUST_USED=1
        fi
    fi
}

# 主函数：显示提示词选择器（直接显示模式选择，支持搜索）
show_prompts() {
    show_modes
}

# 快速编辑提示词文件
edit_prompts() {
    if [ -f "$TERMINAL_PROMPT_FILE" ]; then
        ${EDITOR:-vim} "$TERMINAL_PROMPT_FILE"
        echo -e "${COLOR_GREEN}提示词已更新${COLOR_RESET}"
    else
        echo -e "${COLOR_YELLOW}找不到提示词文件${COLOR_RESET}"
    fi
}

# 显示帮助
show_help() {
    cat << EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  终端提示词系统 - 使用帮助
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

快捷键：
  //             按两次 / 呼出提示词搜索（推荐）
  Ctrl + /       随时呼出提示词搜索（备用）
  Ctrl + Space   同上

使用方法：
  1. 快速按两次 / 呼出提示词选择界面
  2. 可以直接：
     - 选择模式：先选模式，再选提示词
     - 直接搜索：输入关键词搜索所有提示词
  3. 用 ↑↓ 方向键选择
  4. 按 Enter 插入到命令行（同时复制到剪贴板）
  5. 可以继续编辑或添加内容
  6. 按 Esc 退出

循环使用功能：
  - 按 // 呼出提示词库，选择提示词，按 Enter 插入到命令行
  - 编辑修改内容后，按 Enter 执行命令
  - 命令执行完成后，再次按 Enter 键会自动重新打开提示词库
  - 可以继续选择新的提示词，形成连续循环使用
  - 无需重复输入 prompt 命令，实现真正的循环工作流程

使用方式：
  选择模式 - 先选择模式（编程/学习/问题/看书/爬虫），再选择具体提示词
  直接搜索 - 输入关键词（如：思路、debug、总结）直接搜索所有126个提示词

模式说明：
  编程模式：思路、Test、Debug、出错、坚韧、记录问题、扫描、改良、UI提示词
  学习模式：总结、小学、简单、类比、科学、不常、常见、无敌、推荐书、提示词等
  问题模式：各种问题解决、分析、优化相关提示词
  看书模式：阅读分析相关提示词
  爬虫模式：数据采集相关提示词

命令行工具：
  prompts        直接呼出提示词搜索
  prompts-edit   编辑提示词文件  
  prompts-help   显示帮助

提示词文件：$TERMINAL_PROMPT_FILE

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
}

# 导出命令别名
alias prompts='show_prompts'
alias prompts-edit='edit_prompts'
alias prompts-help='show_help'

# ZLE widget：呼出提示词库
_show_prompts_widget() {
    # 提示加载信息，不改变编辑状态
    zle -M "加载提示词库..."
    
    # 调用提示词选择器
    show_prompts
    
    # 仅重绘当前提示，避免 reset 导致的状态切换
    zle -R
}

# ZLE widget：智能斜杠 - 按两次 / 呼出提示词库
_smart_slash() {
    # 如果命令行是单个斜杠，呼出提示词库并清空
    if [ "$BUFFER" = "/" ]; then
        BUFFER=""
        _show_prompts_widget
    else
        # 否则正常输入斜杠
        LBUFFER="${LBUFFER}/"
    fi
}

# ZLE widget：按 Enter 时自动复制整行到剪贴板，并支持循环打开提示词库
_accept_line_with_copy() {
    # 获取当前命令行的完整内容
    local line="$BUFFER"
    
    # 如果有内容，就复制到剪贴板
    if [ -n "$line" ]; then
        echo -n "$line" | pbcopy
    fi
    
    # 执行正常的 Enter 操作（接受当前行）
    zle accept-line
    
    # 如果刚刚使用了提示词，则标记在下一次进入编辑时自动弹出提示词库
    if [ "$TERMINAL_PROMPT_JUST_USED" = "1" ]; then
        unset TERMINAL_PROMPT_JUST_USED
        export TERMINAL_PROMPT_OPEN_ON_READY=1
    fi
}

# 在每次进入新行编辑时触发（避免 fzf 的回车被 ZLE 误吞导致立刻执行）
_terminal_prompt_line_init() {
    if [ "$TERMINAL_PROMPT_OPEN_ON_READY" = "1" ]; then
        unset TERMINAL_PROMPT_OPEN_ON_READY
        _show_prompts_widget
    fi
}

# 注册 ZLE widgets
zle -N _show_prompts_widget
zle -N _smart_slash
zle -N _accept_line_with_copy
zle -N zle-line-init _terminal_prompt_line_init

# 绑定快捷键
# / 键 - 空行时呼出提示词库，否则正常输入斜杠（主要快捷键）
bindkey '/' _smart_slash

# Ctrl + / (在终端中是 Ctrl+_ ) - 备用
bindkey '^_' _show_prompts_widget

# Ctrl + Space (备用)
bindkey '^ ' _show_prompts_widget

# Enter 键 - 执行命令并复制到剪贴板
bindkey '^M' _accept_line_with_copy

# 初始化检查
if [ ! -f "$TERMINAL_PROMPT_FILE" ]; then
    echo -e "${COLOR_YELLOW}⚠ 找不到提示词文件：$TERMINAL_PROMPT_FILE${COLOR_RESET}"
else
    # 静默加载，不显示欢迎信息
    if [[ -o interactive ]] && [ -z "$TERMINAL_PROMPT_LOADED" ]; then
        export TERMINAL_PROMPT_LOADED=1
        echo -e "${COLOR_GREEN}提示词系统已加载${COLOR_RESET} ${COLOR_CYAN}按 // 呼出${COLOR_RESET}"
    fi
fi
