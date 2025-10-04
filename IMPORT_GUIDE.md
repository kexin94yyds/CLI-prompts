# 提示词导入工具使用指南

## 🎯 功能说明

这个工具可以让你用简单的 txt 格式管理提示词，然后自动转换为 JSON 格式导入到终端提示词库中。

## 📝 TXT 格式说明

### 基本格式
```
名称|内容
```

### 示例
```
总结|Make an extensive summary of the article.
小学|用小学学历的成年人能理解的方式来表达, 最好系统且全面的讲解关于
简单|Please list comprehensive and structured about
```

### 特殊规则
- 以 `#` 开头的行为注释，会被忽略
- 空行会被忽略
- 名称和内容用 `|` 分隔
- 内容可以包含换行符（会自动转义）

## 🚀 使用方法

### 方法1：使用默认文件
```bash
cd ~/终端嵌入/Slash-Command-Prompter
./import-prompts.sh
```
这会导入 `prompts-import.txt` 文件

### 方法2：使用自定义文件
```bash
cd ~/终端嵌入/Slash-Command-Prompter
./import-prompts.sh my-prompts.txt
```

### 方法3：直接指定路径
```bash
./import-prompts.sh /path/to/your/prompts.txt
```

## 📋 完整工作流程

### 1. 准备 TXT 文件
创建或编辑你的提示词文件，格式如下：
```
# 这是我的提示词库
总结|Make an extensive summary of the article.
小学|用小学学历的成年人能理解的方式来表达, 最好系统且全面的讲解关于
思路|我不是让你直接执行这个需求。请你先按照以下步骤进行：
1. 分析当前的实现逻辑，包括功能流程、涉及的关键模块或文件。
2. 基于我的[新需求]，说明如果要实现，需要对哪些部分做出修改。
3. 暂时不要改代码！只需要你说明改动思路。
```

### 2. 运行导入脚本
```bash
./import-prompts.sh your-prompts.txt
```

### 3. 重新加载系统
```bash
source ~/终端嵌入/Slash-Command-Prompter/terminal-prompt.zsh
```

### 4. 测试使用
按 `//` 呼出提示词库，查看是否导入成功

## 🔧 高级功能

### 自动备份
- 每次导入前会自动备份原文件
- 备份文件名格式：`terminal-prompts.json.backup.YYYYMMDD_HHMMSS`

### 错误处理
- 自动验证 JSON 格式
- 跳过无效行并显示警告
- 统计成功导入的提示词数量

### 安全特性
- 导入前验证文件存在性
- JSON 格式验证
- 自动转义特殊字符

## 📊 示例输出

```
📥 提示词导入工具

📂 导入文件：prompts-import.txt

🔄 正在处理提示词...
  ✓ 总结
  ✓ 小学
  ✓ 简单
  ✓ 思路
  ⚠️  跳过无效行：这是注释行

📋 已备份原文件

✅ 导入完成！
   📊 成功导入 4 个提示词
   📁 文件位置：/Users/apple/终端嵌入/Slash-Command-Prompter/terminal-prompts.json

💡 提示：
   1. 重新加载提示词系统：
      source ~/终端嵌入/Slash-Command-Prompter/terminal-prompt.zsh

   2. 或者重启终端自动加载

   3. 按 // 呼出提示词库测试
```

## 🛠️ 故障排除

### 问题1：权限错误
```bash
chmod +x import-prompts.sh
```

### 问题2：找不到 jq
```bash
brew install jq
```

### 问题3：文件格式错误
检查你的 txt 文件格式：
- 确保每行都是 `名称|内容` 格式
- 检查是否有特殊字符需要转义
- 确保文件编码为 UTF-8

### 问题4：JSON 格式错误
脚本会自动验证 JSON 格式，如果出错会显示具体错误信息

## 💡 使用技巧

### 1. 批量管理
- 可以用任何文本编辑器编辑 txt 文件
- 支持复制粘贴大量提示词
- 可以添加注释说明

### 2. 版本控制
- txt 文件可以用 Git 管理
- 比 JSON 文件更容易阅读和编辑
- 支持 diff 比较

### 3. 分享提示词
- 可以轻松分享 txt 文件
- 其他人可以直接导入使用
- 支持团队协作

## 🎉 总结

现在你可以：
1. ✅ 用简单的 txt 格式管理提示词
2. ✅ 一键导入到终端提示词库
3. ✅ 自动备份和错误处理
4. ✅ 支持注释和批量编辑

让你的提示词管理更加简单高效！
