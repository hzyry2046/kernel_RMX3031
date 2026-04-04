#!/bin/bash
set -euo pipefail

# 配置基础 URL（请根据实际情况修改）
BASE_URL="https://github.com/frstprjkt/kernel-lts/commit"

usage() {
    echo "用法: $0 (name)"
    exit 1
}

# 检查参数
if [ $# -ne 1 ]; then
    usage
fi

NAME="$1"
PATCH_DIR="patches"
PATCH_FILE="${PATCH_DIR}/${NAME}.patch"

# 确保在 Git 仓库中执行
if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "错误：当前目录不是 Git 仓库"
    exit 1
fi

# 创建补丁目录
mkdir -p "$PATCH_DIR"

# 下载补丁文件
echo "正在下载 ${BASE_URL}/${NAME}.patch ..."
if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$PATCH_FILE" "${BASE_URL}/${NAME}.patch" || {
        echo "下载失败 (curl)"
        exit 1
    }
elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$PATCH_FILE" "${BASE_URL}/${NAME}.patch" || {
        echo "下载失败 (wget)"
        exit 1
    }
else
    echo "错误：未找到 curl 或 wget"
    exit 1
fi

echo "下载完成，保存为 ${PATCH_FILE}"

# 应用补丁
echo "正在应用补丁..."
git apply "$PATCH_FILE"

echo "补丁应用成功！"
