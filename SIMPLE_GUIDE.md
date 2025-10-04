# 🚀 简单使用指南

## 📝 调整提示词顺序

### 方法1：直接修改txt文件
1. 编辑 `all-prompts.txt` 文件
2. 修改每行开头的序号来调整顺序
3. 运行：`./convert.sh all-prompts.txt`
4. 重新加载：`source ~/终端嵌入/Slash-Command-Prompter/terminal-prompt.zsh`

### 方法2：发给AI自动调整
1. 把 `all-prompts.txt` 的内容发给AI
2. 告诉AI你想要的顺序
3. AI会返回调整后的文件内容
4. 复制到 `all-prompts.txt` 并运行 `./convert.sh all-prompts.txt`

## 🎯 使用示例

### 调整顺序示例：
```
# 原来：
1|总结|Make an extensive summary...
2|小学|用小学学历的成年人能理解...

# 调整后：
1|思路|我不是让你直接执行...
2|Test|先测试再提交
3|总结|Make an extensive summary...
```

## ⚡ 快速命令

```bash
# 转换txt到JSON
./convert.sh all-prompts.txt

# 重新加载系统
source ~/终端嵌入/Slash-Command-Prompter/terminal-prompt.zsh

# 呼出提示词库
# 按 // 键
```

## 📁 文件说明

- `all-prompts.txt` - 完整的38个提示词，可直接编辑
- `convert.sh` - 简单转换工具
- `terminal-prompts.json` - 系统使用的JSON文件
- `terminal-prompt.zsh` - 核心系统文件
