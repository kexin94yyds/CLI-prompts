# CLI Prompts - Terminal Prompt Library

CLI Prompts is a powerful terminal prompt management system designed to enhance productivity for developers and content creators. With a simple `//` shortcut, you can quickly access and manage your own prompts.

> **Note**: This repository includes 3 example prompts. You can easily import your own prompts using the provided tools.

## ✨ Core Features

### 🎯 Quick Access
- **Double Slash Trigger**: Press `//` to quickly invoke the prompt selection interface
- **Purple Highlight Theme**: Clean Codex-style interface design
- **Smart Search**: Supports fuzzy search for quick prompt location

### 📚 Multi-Mode Management
- **Reading Mode**: Reading analysis related prompts
- **Learning Mode**: Knowledge learning and summary related prompts
- **Programming Mode**: Code development, debugging, optimization related prompts
- **Problem Mode**: Problem analysis and solution related prompts
- **Crawler Mode**: Data collection and processing related prompts

### 🔧 Powerful Features
- **Direct Search**: Cross-mode search across all prompts
- **Mode Selection**: Browse prompts by specific categories
- **Content Preview**: Real-time prompt content preview
- **Clipboard Integration**: Auto-copy to clipboard with further editing support
- **Command Line Insertion**: Direct insertion into terminal command line
- **Easy Import**: Import your own prompts from text files

## 🚀 Quick Start

### Installation Steps

1. **Clone Repository**
   ```bash
   git clone https://github.com/kexin94yyds/CLI-prompts.git
   cd CLI-prompts
   ```

2. **Configure Environment**
   ```bash
   # Add script to ~/.zshrc
   echo 'source ~/CLI-prompts/terminal-prompt.zsh' >> ~/.zshrc
   
   # Reload configuration
   source ~/.zshrc
   ```

3. **Start Using**
   - Press `//` in any terminal to invoke the prompt library
   - Use arrow keys to select, Enter to confirm
   - Supports direct search and mode selection

## 📖 Usage Guide

### Basic Operations
- **Invoke Interface**: Press `//` or `Ctrl + /`
- **Search Prompts**: Type keywords directly
- **Select Mode**: Choose specific mode to browse prompts
- **Insert Prompt**: Press Enter to insert into command line

### Advanced Features
- **Import Prompts**: Use `import-prompts.sh` script
- **Reorder Prompts**: Use `reorder-prompts.sh` script
- **Merge Modes**: Use `merge-modes.sh` script

## 🛠️ Technical Architecture

### Core Technologies
- **Shell**: Zsh script implementation
- **Interface**: fzf fuzzy finder
- **Data**: JSON format storage
- **Tools**: jq for JSON data processing

### File Structure
```
CLI-prompts/
├── terminal-prompt.zsh      # Core script
├── terminal-prompts.json    # Prompt data
├── *.sh                     # Utility scripts
├── *.md                     # Documentation
└── *-prompts.txt           # Mode-specific prompt files
```

## 📋 Prompt Categories

### 📖 Reading Mode (25 prompts)
- Summary, Elementary, Simple, Analogy, Science
- Uncommon, Common, Invincible, Recommended Books, Prompts
- Suggestions, Tips, Book Recommendations, Sources, Guidance
- Objective, Principles, Assumption Validation, Assumption Applications
- Framework, Repetition, Author, Insights, Follow-up

### 🎓 Learning Mode (25 prompts)
- Summary, Elementary, Simple, Analogy, Science
- Uncommon, Common, Invincible, Recommended Books, Prompts
- Suggestions, Tips, Book Recommendations, Sources, Guidance
- Objective, Principles, Assumption Validation, Assumption Applications
- Framework, Repetition, Author, Insights, Follow-up

### 💻 Programming Mode (25 prompts)
- Thinking, Test, Debug, Error, Persistence
- Problem Recording, Scanning, Improvement, UI Prompts
- Complexity, Prompts, Recording, Style, Public Account
- Movie Style, Twitter, Helping Others, Author, Insights
- Follow-up, Fact Checking, Detailed Explanation, Structuring

### ❓ Problem Mode (25 prompts)
- 5W1H, Nine Grid, First Principles, Text
- Thinking, YouTube, Topics, Complexity, Prompts
- Repetition, Recording, Style, Public Account, Movie Style
- Twitter, Helping Others, Author, Insights, Follow-up
- Fact Checking, Detailed Explanation, Structuring

### 🕷️ Crawler Mode (26 prompts)
- Thinking, YouTube, Topics, Complexity, Prompts
- Repetition, Recording, Style, Public Account, Movie Style
- Twitter, Helping Others, Author, Insights, Follow-up
- Fact Checking, Detailed Explanation, Structuring, 5W1H
- Nine Grid, First Principles, Text, Thinking

## 🔄 Import/Export

### Import Prompts
```bash
# Import using simple format
./convert.sh my-prompts.txt

# Import using complete format
./import-prompts.sh prompts-import.txt

# Merge multiple mode files
./merge-modes.sh
```

### Export Prompts
```bash
# Generate reorderable file
./reorder-prompts.sh
```

## 🎨 Interface Preview

- **Purple Highlight**: Selected items display in purple text
- **No Arrow Pointer**: Clean Codex-style design
- **Real-time Preview**: Right panel shows prompt content preview
- **Smart Search**: Supports fuzzy matching and keyword search

## 📚 Documentation

- [Quick Start Guide](QUICK_START.md)
- [Import Tool Guide](IMPORT_GUIDE.md)
- [Mode Management Guide](MODE_GUIDE.md)
- [Test Guide](TEST_GUIDE.md)
- [Final Usage Guide](FINAL_GUIDE.md)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

Thanks to all developers and users who have contributed to this project.

---

**Let CLI Prompts be your powerful assistant for productivity enhancement!** 🚀

---

# CLI Prompts - 终端提示词库

CLI Prompts 是一个强大的终端提示词管理系统，专为提升开发者和内容创作者的工作效率而设计。通过简单的 `//` 快捷键，您可以快速访问和管理您自己的提示词。

> **注意**: 本仓库包含3个示例提示词。您可以使用提供的工具轻松导入自己的提示词。

## ✨ 核心特性

### 🎯 快速访问
- **双斜杠触发**: 按 `//` 快速呼出提示词选择界面
- **紫色高亮主题**: 采用 Codex 风格的简洁界面设计
- **智能搜索**: 支持模糊搜索，快速定位所需提示词

### 📚 多模式管理
- **看书模式**: 阅读分析相关提示词
- **学习模式**: 知识学习和总结相关提示词  
- **编程模式**: 代码开发、调试、优化相关提示词
- **问题模式**: 问题分析和解决相关提示词
- **爬虫模式**: 数据采集和处理相关提示词

### 🔧 强大功能
- **直接搜索**: 跨模式搜索所有提示词
- **模式选择**: 按分类浏览特定模式的提示词
- **内容预览**: 实时预览提示词内容
- **剪贴板集成**: 自动复制到剪贴板，支持进一步编辑
- **命令行插入**: 直接插入到终端命令行
- **轻松导入**: 从文本文件导入您自己的提示词

## 🚀 快速开始

### 安装步骤

1. **克隆仓库**
   ```bash
   git clone https://github.com/kexin94yyds/CLI-prompts.git
   cd CLI-prompts
   ```

2. **配置环境**
   ```bash
   # 将脚本添加到 ~/.zshrc
   echo 'source ~/CLI-prompts/terminal-prompt.zsh' >> ~/.zshrc
   
   # 重新加载配置
   source ~/.zshrc
   ```

3. **开始使用**
   - 在任何终端中按 `//` 呼出提示词库
   - 使用方向键选择，Enter 确认
   - 支持直接搜索和模式选择

## 📖 使用指南

### 基本操作
- **呼出界面**: 按 `//` 或 `Ctrl + /`
- **搜索提示词**: 直接输入关键词
- **选择模式**: 选择特定模式浏览提示词
- **插入提示词**: 按 Enter 插入到命令行

### 高级功能
- **导入提示词**: 使用 `import-prompts.sh` 脚本
- **重排序提示词**: 使用 `reorder-prompts.sh` 脚本
- **合并模式**: 使用 `merge-modes.sh` 脚本

## 🛠️ 技术架构

### 核心技术
- **Shell**: Zsh 脚本实现
- **界面**: fzf 模糊搜索器
- **数据**: JSON 格式存储
- **工具**: jq 处理 JSON 数据

### 文件结构
```
CLI-prompts/
├── terminal-prompt.zsh      # 核心脚本
├── terminal-prompts.json    # 提示词数据
├── *.sh                     # 工具脚本
├── *.md                     # 文档
└── *-prompts.txt           # 各模式提示词文件
```

## 📋 提示词分类

### 📖 看书模式 (25个提示词)
- 总结、小学、简单、类比、科学
- 不常、常见、无敌、推荐书、提示词
- 建议、技巧、推书、来源、引导
- 客观、原则、假设成立、假设观点正确
- 框架、反复、作者、洞见、追问

### 🎓 学习模式 (25个提示词)  
- 总结、小学、简单、类比、科学
- 不常、常见、无敌、推荐书、提示词
- 建议、技巧、推书、来源、引导
- 客观、原则、假设成立、假设观点正确
- 框架、反复、作者、洞见、追问

### 💻 编程模式 (25个提示词)
- 思路、Test、Debug、出错、坚韧
- 记录问题、扫描、改良、UI提示词
- 复杂、prompts、记录、风格、公众号
- 电影风格、推特、帮人、作者、洞见
- 追问、事实核查、详解、结构化

### ❓ 问题模式 (25个提示词)
- 5W1H、九宫格、第一性原理、文字
- 思路、油管、主题、复杂、prompts
- 反复、记录、风格、公众号、电影风格
- 推特、帮人、作者、洞见、追问
- 事实核查、详解、结构化

### 🕷️ 爬虫模式 (26个提示词)
- 思路、油管、主题、复杂、prompts
- 反复、记录、风格、公众号、电影风格
- 推特、帮人、作者、洞见、追问
- 事实核查、详解、结构化、5W1H
- 九宫格、第一性原理、文字、思路

## 🔄 导入导出

### 导入提示词
```bash
# 使用简单格式导入
./convert.sh my-prompts.txt

# 使用完整格式导入
./import-prompts.sh prompts-import.txt

# 合并多个模式文件
./merge-modes.sh
```

### 导出提示词
```bash
# 生成可重排序的文件
./reorder-prompts.sh
```

## 🎨 界面预览

- **紫色高亮**: 选中项显示为紫色文字
- **无箭头指针**: 简洁的 Codex 风格设计
- **实时预览**: 右侧显示提示词内容预览
- **智能搜索**: 支持模糊匹配和关键词搜索

## 📚 文档

- [快速开始指南](QUICK_START.md)
- [导入工具说明](IMPORT_GUIDE.md)
- [模式管理指南](MODE_GUIDE.md)
- [测试指南](TEST_GUIDE.md)
- [最终使用指南](FINAL_GUIDE.md)

## 🤝 贡献

欢迎贡献代码和建议！请随时提交 Issue 和 Pull Request。

## 📄 许可证

本项目采用 MIT 许可证。

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者和用户。

---

**让终端提示词库成为您提升效率的得力助手！** 🚀