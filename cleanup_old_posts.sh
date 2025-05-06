#!/bin/bash

# Set how many days old a post must be to be deleted (e.g., 30 days)
DAYS_OLD=30

echo "🧹 Searching for posts older than $DAYS_OLD days..."

# Ensure we are in the correct project directory
if [ ! -d "_posts" ]; then
  echo "❌ Error: _posts directory not found. Please run from your blog root."
  exit 1
fi

# Find and stage old posts
OLD_FILES=$(find _posts -type f -name "*.md" -mtime +$DAYS_OLD)

if [ -z "$OLD_FILES" ]; then
  echo "ℹ️ No posts older than $DAYS_OLD days found. Nothing to delete."
  exit 0
fi

# Show files before deleting
echo "⚠️ The following files will be deleted:"
echo "$OLD_FILES"
echo

read -p "❓ Are you sure you want to delete these files? (y/N): " CONFIRM
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "❌ Cleanup cancelled."
  exit 1
fi

# Remove files and push
echo "$OLD_FILES" | xargs git rm
git commit -m "Auto cleanup: remove posts older than $DAYS_OLD days"
git push

echo "🚀 Cleanup pushed to remote."
