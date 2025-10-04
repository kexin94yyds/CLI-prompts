# 🔄 提示词顺序调整指南

## 🎯 功能说明

现在你可以轻松调整提示词的显示顺序！支持两种方式：

### 方式1：直接编辑带顺序的 txt 文件
### 方式2：使用顺序调整工具

## 📝 支持的格式

### 简单格式（自动排序）
```
名称|内容
```

### 带顺序格式（自定义排序）
```
序号|名称|内容
```

## 🚀 使用方法

### 方法1：使用顺序调整工具（推荐）

```bash
# 1. 生成顺序调整文件
./reorder-prompts.sh

# 2. 编辑生成的文件
vim reordered-prompts.txt

# 3. 修改序号调整顺序
# 例如：将 1|思路 改为 2|思路，将 2|Test 改为 1|Test

# 4. 导入调整后的顺序
./import-prompts.sh reordered-prompts.txt

# 5. 重新加载系统
source ~/终端嵌入/Slash-Command-Prompter/terminal-prompt.zsh
```

### 方法2：直接创建带顺序的文件

```bash
# 创建你的提示词文件
cat > my-ordered-prompts.txt << 'EOF'
# 我的提示词库（按使用频率排序）
1|思路|我不是让你直接执行这个需求。请你先按照以下步骤进行：分析当前的实现逻辑，包括功能流程、涉及的关键模块或文件。
2|Test|先测试再提交
3|Debug|Reflect on 5-7 different possible sources of the problem, distill those down to 1-2 most likely sources then add logs to validate your assumptions before we move onto implementing the actual code fix
4|记录问题|很好。问题解决了。请帮我生成一个问题排除的文档，记录这次问题的原因和解决的办法以供将来遇到类似问题的时候参考。
5|总结|Make an extensive summary of the article.
6|小学|用小学学历的成年人能理解的方式来表达, 最好系统且全面的讲解关于
EOF

# 导入
./import-prompts.sh my-ordered-prompts.txt

# 重新加载
source ~/终端嵌入/Slash-Command-Prompter/terminal-prompt.zsh
```

## 📊 示例演示

### 调整前：
```
1. 思路
2. Test  
3. Debug
4. 记录问题
5. 总结
```

### 调整后（把常用的放前面）：
```
1. Test
2. 思路
3. 总结
4. Debug
5. 记录问题
```

## 💡 调整策略建议

### 按使用频率排序
```
1|Test|先测试再提交
2|思路|我不是让你直接执行这个需求...
3|Debug|Reflect on 5-7 different possible sources...
4|记录问题|很好。问题解决了...
5|总结|Make an extensive summary of the article.
```

### 按功能分类排序
```
# 开发调试类
1|Test|先测试再提交
2|Debug|Reflect on 5-7 different possible sources...
3|思路|我不是让你直接执行这个需求...
4|记录问题|很好。问题解决了...

# 学习分析类  
5|总结|Make an extensive summary of the article.
6|小学|用小学学历的成年人能理解的方式来表达...
7|简单|Please list comprehensive and structured about
```

### 按重要性排序
```
1|思路|我不是让你直接执行这个需求...
2|Test|先测试再提交
3|Debug|Reflect on 5-7 different possible sources...
4|记录问题|很好。问题解决了...
5|坚韧|在这个问题上我们已经修改多次...
```

## 🔧 高级技巧

### 1. 批量调整
```bash
# 生成当前顺序文件
./reorder-prompts.sh

# 用编辑器批量修改序号
vim reordered-prompts.txt

# 导入新顺序
./import-prompts.sh reordered-prompts.txt
```

### 2. 分组管理
```
# 开发类
1|Test|先测试再提交
2|Debug|Reflect on 5-7 different possible sources...
3|思路|我不是让你直接执行这个需求...

# 学习类
10|总结|Make an extensive summary of the article.
11|小学|用小学学历的成年人能理解的方式来表达...

# 问题解决类
20|记录问题|很好。问题解决了...
21|出错|问题仍然没有解决...
22|坚韧|在这个问题上我们已经修改多次...
```

### 3. 快速测试
```bash
# 创建测试文件
echo "1|Test|先测试再提交" > test-order.txt
echo "2|思路|我不是让你直接执行这个需求..." >> test-order.txt

# 导入测试
./import-prompts.sh test-order.txt

# 按 // 测试顺序
```

## 🎉 总结

现在你可以：

1. ✅ **自定义顺序** - 把最常用的提示词放前面
2. ✅ **分类管理** - 按功能或重要性分组
3. ✅ **快速调整** - 用工具生成，编辑后导入
4. ✅ **灵活排序** - 支持任意数字序号

让你的提示词库更符合使用习惯！🎯
