#!/usr/bin/env bash

# === 配置区域 ===
VM_IP="192.168.122.237"
# 你需要转发的端口列表
PORTS=(5666 4450 5005 5173 4533)
# socat 二进制文件路径（NixOS 通常在 /run/current-system/sw/bin/socat）
SOCAT_BIN=$(which socat)

# === 逻辑区域 ===

# 检查 socat 是否安装
if [ -z "$SOCAT_BIN" ]; then
    echo "错误: 未找到 socat，请先安装它。"
    exit 1
fi

echo "开始监控虚拟机 ${VM_IP} ..."

# 持续循环，直到能 ping 通虚拟机
while ! ping -c 1 -W 1 "$VM_IP" &>/dev/null; do
    echo "虚拟机尚未就绪，5秒后重试..."
    sleep 5
done

echo "虚拟机 ${VM_IP} 已上线！清理旧转发进程..."
# 清理之前可能残余的针对该 IP 的 socat 进程
pkill -f "socat.*${VM_IP}" || true

# 循环启动转发
for PORT in "${PORTS[@]}"; do
    echo "正在映射端口: 宿主机:${PORT} -> 虚拟机:${PORT}"
    # fork: 允许并发连接; reuseaddr: 允许快速重启端口监听
    "$SOCAT_BIN" TCP4-LISTEN:"${PORT}",fork,reuseaddr TCP4:"${VM_IP}":"${PORT}" &
done

echo "所有端口转发已在后台启动。"
echo "按 [CTRL+C] 停止所有转发并退出。"

# 捕获退出信号，清理后台进程
trap "echo '正在停止转发...'; pkill -P $$; exit" SIGINT SIGTERM

# 保持脚本运行
wait
