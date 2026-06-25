#!/bin/bash
# ============================================
# 一键发布 wangchangyi.com
# 用法：
#   发布          ./publish.sh
#   发布+备注     ./publish.sh "新文章：xxx"
#   本地预览      ./publish.sh serve
# ============================================

set -e

cd "$(dirname "$0")"

SITE="wangchangyi.com"

case "${1:-}" in
  serve)
    echo "🔍 本地预览中... http://localhost:1313"
    hugo server --buildDrafts
    exit 0
    ;;
  status)
    echo "=== 当前状态 ==="
    git status --short
    echo "=== 上次构建 ==="
    ls -la public/ 2>/dev/null | head -3
    exit 0
    ;;
esac

# 1. 检查是否有变更
if git diff --quiet && git diff --cached --quiet; then
  echo "ℹ️  没有新的变更，无需发布"
  exit 0
fi

# 2. 提交信息
MSG="${1:-更新网站内容}"

# 3. 构建测试（确保能成功构建）
echo "🔨 构建测试..."
hugo --minify 2>&1 | tail -3

# 4. 提交并推送
echo "📤 推送到 GitHub..."
git add -A
git commit -m "$MSG"
git push origin master

echo ""
echo "✅ 发布完成！"
echo "   Cloudflare Pages 将自动部署"
echo "   预计 30-60 秒后 https://wangchangyi.com 更新"
