# 终端提示词系统 - 快速开始

## 安装步骤

### 1. 安装依赖工具

```bash
# 安装 jq 和 fzf
brew install jq fzf
```

### 2. 加载到 zsh

编辑你的 `~/.zshrc` 文件，添加以下内容：

```bash
# 加载终端提示词系统
source ~/终端嵌入/Slash-Command-Prompter/terminal-prompt.zsh
```

### 3. 重新加载配置

```bash
source ~/.zshrc
```

## 使用方法

### 快捷键

- **Ctrl + /** - 打开提示词菜单
- **Ctrl + Space** - 快速搜索所有提示词

### 命令行工具

```bash
tp-menu      # 打开提示词菜单
tp-search    # 搜索所有提示词
tp-edit      # 编辑提示词文件
tp-add       # 添加新提示词
tp-help      # 显示帮助
```

## 快速测试

1. 在终端按 `Ctrl + Space` 或运行 `tp-search`
2. 输入关键词搜索提示词
3. 使用方向键选择
4. 按 `Enter` 插入到命令行
5. 按 `Ctrl-Y` 复制到剪贴板

## 示例

当前已内置的提示词：
- 我靠 - 快速表达惊叹
- Git提交 - 常用Git命令
- 代码解释 - AI提示词模板
- 等等...

## 自定义提示词

编辑 `terminal-prompts.json` 文件添加你自己的提示词：

```bash
tp-edit
```

