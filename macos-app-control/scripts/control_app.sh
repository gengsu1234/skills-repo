#!/bin/bash
# macOS 应用控制脚本
# 用法: ./control_app.sh "应用名" "操作说明" [输出目录]
# 例如: ./control_app.sh "Calculator" "计算 596-323"

APP_NAME="$1"
OPERATION="$2"
OUTPUT_DIR="${3:-/tmp}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "=== macOS 应用控制 ==="
echo "应用: $APP_NAME"
echo "操作: $OPERATION"
echo ""

# 1. 打开应用
echo "[1/5] 打开应用: $APP_NAME"
open -a "$APP_NAME" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "✗ 无法打开应用: $APP_NAME"
    exit 1
fi
sleep 1

# 2. 激活窗口
echo "[2/5] 激活应用窗口..."
osascript -e "tell application \"System Events\" to set frontmost of process \"$APP_NAME\" to true" 2>/dev/null
sleep 0.5

# 3. 获取窗口信息
echo "[3/5] 获取窗口信息..."
WINDOW_INFO=$(osascript -e "tell application \"System Events\" to tell process \"$APP_NAME\" to get {position, size} of window 1" 2>/dev/null)

if [ -z "$WINDOW_INFO" ]; then
    echo "✗ 无法获取窗口信息"
    echo "提示: 请检查辅助功能权限是否已授予"
    exit 1
fi

X=$(echo "$WINDOW_INFO" | awk -F', ' '{print $1}')
Y=$(echo "$WINDOW_INFO" | awk -F', ' '{print $2}')
W=$(echo "$WINDOW_INFO" | awk -F', ' '{print $3}')
H=$(echo "$WINDOW_INFO" | awk -F', ' '{print $4}')
echo "窗口位置: X=$X, Y=$Y, 宽=$W, 高=$H"

# 4. 执行操作（需要用户根据具体应用自定义）
echo "[4/5] 执行操作: $OPERATION"
echo "提示: 此脚本为通用模板，请根据具体应用自定义操作逻辑"
echo ""
echo "常用操作示例:"
echo "  - 键盘输入: osascript -e 'tell application \"System Events\" to tell process \"$APP_NAME\" to keystroke \"文本\"'"
echo "  - 快捷键:   osascript -e 'tell application \"System Events\" to tell process \"$APP_NAME\" to keystroke \"s\" using command down'"
echo "  - 点击按钮: osascript -e 'tell application \"System Events\" to tell process \"$APP_NAME\" to click button \"按钮名\" of window 1'"
echo ""

# 5. 截图
echo "[5/5] 截取应用窗口..."
SCREENSHOT_FILE="$OUTPUT_DIR/${APP_NAME}_${TIMESTAMP}.png"
screencapture -R"$X,$Y,$W,$H" "$SCREENSHOT_FILE" 2>/dev/null

if [ -f "$SCREENSHOT_FILE" ]; then
    FILE_SIZE=$(ls -lh "$SCREENSHOT_FILE" | awk '{print $5}')
    echo ""
    echo "✓ 截图完成"
    echo "  文件: $SCREENSHOT_FILE"
    echo "  大小: $FILE_SIZE"
    echo ""
    echo "视觉识别命令:"
    echo "python3 /Users/guanli/.codex/skills/kimi-vision/scripts/analyze_image.py $SCREENSHOT_FILE \"这个界面显示了什么？\""
else
    echo "✗ 截图失败"
fi
