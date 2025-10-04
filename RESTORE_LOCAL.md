# 本地提示词库恢复说明

## 📦 备份文件位置

您的完整提示词库（126个提示词）已备份到：
- `terminal-prompts.json.local.backup` - 完整备份

## 🔄 恢复步骤

### 方法1：快速恢复
```bash
cp terminal-prompts.json.local.backup terminal-prompts.json
```

### 方法2：重命名恢复
```bash
mv terminal-prompts.json.local.backup terminal-prompts.json
```

## ⚠️ 重要提示

1. **不要删除** `terminal-prompts.json.local.backup` 文件
2. **不要提交** 这个备份文件到 GitHub（已在 .gitignore 中排除）
3. **定期备份** 您的提示词到其他位置

## 📝 GitHub vs 本地

- **GitHub**: 只包含3个示例提示词（供其他用户参考）
- **本地**: 完整的126个提示词（您的个人库）

## 🔐 额外备份建议

建议将备份文件复制到：
```bash
# 复制到云盘
cp terminal-prompts.json.local.backup ~/Dropbox/backups/

# 或复制到移动硬盘
cp terminal-prompts.json.local.backup /Volumes/MyDrive/backups/

# 或创建加密备份
zip -e my-prompts-backup.zip terminal-prompts.json.local.backup
```

## ✅ 验证备份

检查备份文件是否完整：
```bash
# 查看备份文件大小
ls -lh terminal-prompts.json.local.backup

# 查看提示词数量
cat terminal-prompts.json.local.backup | jq '.prompts | length'
```

应该显示 126 个提示词。

