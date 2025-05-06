#!/bin/bash

# Set how many days old a post must be to be deleted (e.g., 30 days)
DAYS_OLD=30

echo "🧹 Searching for posts older than $DAYS_OLD days..."

# Find old Markdown posts
find _posts -type f -name "*.md" -mtime +$DAYS_OLD -print -exec git rm {} \;

echo "✅ Staged old posts for deletion."

# Commit and push
git commit -m "Auto cleanup: remove posts older than $DAYS_OLD days"
git push

echo "🚀 Cleanup pushed to remote."
