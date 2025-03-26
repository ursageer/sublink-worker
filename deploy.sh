#!/bin/bash

# 创建 KV namespace（如果不存在）
KV_NAMESPACE_ID=$(npx wrangler kv:namespace list | grep SUBLINK_KV | awk '{print $2}')

if [ -z "$KV_NAMESPACE_ID" ]; then
  echo "Creating KV namespace SUBLINK_KV..."
  KV_NAMESPACE_ID=$(npx wrangler kv:namespace create SUBLINK_KV | grep -oP 'id: "\K[^"]+')
  echo "Created KV namespace with ID: $KV_NAMESPACE_ID"
else
  echo "Using existing KV namespace with ID: $KV_NAMESPACE_ID"
fi

# 更新 wrangler.toml 文件中的 KV_NAMESPACE_ID
sed -i "s/id = \"[^\"]*\"/id = \"$KV_NAMESPACE_ID\"/g" wrangler.toml

# 部署 worker
npx wrangler deploy
