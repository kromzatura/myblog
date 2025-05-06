#!/bin/bash

read -p "Enter post title: " title

slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed -e 's/ /-/g' -e 's/[^a-z0-9\-]//g')
date=$(date +%Y-%m-%d)
# For compatibility, we format time manually
datetime=$(date +"%Y-%m-%dT%H:%M:%S%z" | sed 's/\(..\)$/:\1/')  # Adds colon in timezone

filename="_posts/${date}-${slug}.md"
url="https://kromzatura.github.io/myblog/${date}-${slug}.html"

body=$(xclip -selection clipboard -o)

cat <<EOF > "$filename"
---
layout: post
title: "$title"
date: $datetime
---

$body
EOF

echo "✅ Post created: $filename"
code "$filename"

read -p "📦 Press Enter to commit and push..."

git add "$filename"
git commit -m "Add post: $title"
git push

# Safe log update
log_entry="{\"title\": \"$title\", \"filename\": \"$filename\", \"date\": \"$datetime\", \"url\": \"$url\"}"

if [ ! -f post_log.json ]; then
  echo "[]" > post_log.json
fi

tmp=$(mktemp)
jq --argjson entry "$log_entry" '. += [$entry]' post_log.json > "$tmp" && mv "$tmp" post_log.json

echo
