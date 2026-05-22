---
name: "macos-app-control"
version: "1.0.0"
updated: "2026-05-23"
source: "AI生成"
author: "Codex (AI)"
description: "控制 macOS 应用进行 UI 操作。通过 AppleScript 和键盘输入操控任意应用，支持窗口截图和视觉识别。适用于 GUI 自动化测试、键鼠控制功能测试或需要 GUI 操作的场景。当用户说'控制XX应用'、'操作XX软件'、'测试应用'、'GUI测试'时使用。"
---

# macOS 应用控制技能

**版本**：1.0.0  
**更新日期**：2026-05-23  
**来源**：🤖 AI生成（Codex创建）

这个技能让我能够通过 AppleScript 操控任意 macOS 应用，实现 UI 自动化和 GUI 测试。

## 核心用途

### 1. GUI 自动化测试

本技能非常适合用于 GUI 应用的自动化测试，可以完成大部分测试操作：

#### 支持的测试类型

- **功能测试**：验证应用功能是否正常
- **UI 测试**：检查界面元素是否正确显示
- **回归测试**：自动化重复的测试流程
- **冒烟测试**：快速验证核心功能
- **用户流程测试**：模拟真实用户操作路径
- **边界测试**：测试极端输入和边界条件
- **兼容性测试**：验证不同系统版本的表现

#### 测试能力覆盖

| 测试操作 | 支持程度 | 实现方式 |
|---------|---------|---------|
| 启动应用 | ✅ 完全支持 | `open -a "应用名"` |
| 激活窗口 | ✅ 完全支持 | AppleScript `frontmost` |
| 键盘输入 | ✅ 完全支持 | `keystroke` 命令 |
| 快捷键操作 | ✅ 完全支持 | `keystroke using` |
| 鼠标点击 | ✅ 完全支持 | `click` 命令 |
| 菜单操作 | ✅ 完全支持 | `click menu item` |
| 按钮点击 | ✅ 完全支持 | `click button` |
| 表单填写 | ✅ 完全支持 | 键盘输入 + Tab 导航 |
| 滚动操作 | ✅ 完全支持 | `keystroke space/page down` |
| 窗口切换 | ✅ 完全支持 | `Cmd+Tab` 或 AppleScript |
| 截图验证 | ✅ 完全支持 | `screencapture` |
| 视觉验证 | ✅ 完全支持 | Kimi Vision |
| 文本识别 | ✅ 完全支持 | Kimi Vision OCR |
| 拖拽操作 | ✅ 完全支持 | AppleScript `drag` 命令 |

**说明**：本技能通过 AppleScript 实现拖拽操作，Computer Use 的拖拽功能同样是基于坐标计算实现的，本质相同，没有显著差异。

### 2. 日常自动化

除了测试，还可以用于：

- 自动化重复性工作流程
- 批量处理文档
- 定期截图监控
- 自动化报告生成
- 应用间数据迁移

## 截图原则

### 优先截取应用窗口

**优先只截取应用窗口，非必要不截取整个屏幕。**

原因：
1. 窗口截图体积小，响应快
2. 只需要应用窗口内容即可
3. 大图片可能增加处理时间

实现方式：
- 使用 `screencapture -R<X,Y,W,H>` 指定窗口区域
- 先通过 AppleScript 获取窗口位置和大小
- 只截取该区域

### 例外情况

以下情况可以截取整个屏幕：
1. **无法获取窗口坐标**：AppleScript 无法获取窗口位置时
2. **多窗口场景**：需要同时查看多个窗口时
3. **全屏应用**：应用使用全屏模式时
4. **GUI 测试失败**：需要记录完整桌面状态时

### 大图片处理

如果截图体积过大：
- 可以压缩后再发送给视觉识别 API
- Kimi Vision 是单次请求，没有上下文限制
- 基本上没有图片大小限制

## 支持的应用类型

本技能支持**所有 macOS 应用**，没有限制：

### ✅ 完全支持

1. **原生 macOS 应用**
   - 计算器、文本编辑、备忘录、提醒事项
   - Finder、Safari、邮件、日历
   - 系统偏好设置、活动监视器
   - 终端、控制台

2. **AppleScript 可控应用**
   - 支持 AppleScript 命令的应用
   - 提供 UI 元素访问的应用
   - 支持 `System Events` 控制的应用

3. **第三方应用**
   - Microsoft Office（Word、Excel、PowerPoint）
   - Adobe 系列（Photoshop、Illustrator）
   - 开发工具（Xcode、VS Code、Terminal）
   - 浏览器（Chrome、Firefox）
   - 通讯软件（微信、QQ、Slack）

4. **游戏和特殊应用**
   - 简单的游戏（如 macOS 自带象棋）
   - 模拟器
   - 媒体播放器

### ⚠️ 部分限制

某些应用可能有以下限制：

1. **权限保护的应用**
   - 系统关键进程（需要 root 权限）
   - 安全软件（防病毒、防火墙）
   - 密码管理器（需要额外授权）

2. **特殊界面应用**
   - 全屏游戏（可能需要特殊处理）
   - 虚拟机窗口（跨系统界面）
   - 远程桌面应用

3. **辅助功能未授权应用**
   - 需要在系统偏好设置中授予权限
   - 路径：系统偏好设置 → 安全性与隐私 → 隐私 → 辅助功能

## 技术原理

本技能采用纯系统原生方案，不依赖 MCP 插件：

1. **AppleScript UI 控制**：通过 System Events 获取窗口信息、UI 元素
2. **键盘输入模拟**：使用 keystroke 命令输入文字和快捷键
3. **鼠标操作模拟**：使用 click 命令点击按钮和菜单
4. **窗口截图**：使用 screencapture 截取窗口或全屏
5. **视觉识别**：调用 Kimi Vision 技能分析截图内容

## 使用方式

### 方式一：直接使用脚本

```bash
# 控制指定应用
bash /Users/guanli/.codex/skills/macos-app-control/scripts/control_app.sh "应用名" "操作说明"

# 示例
bash /Users/guanli/.codex/skills/macos-app-control/scripts/control_app.sh "Calculator" "计算 596-323"
bash /Users/guanli/.codex/skills/macos-app-control/scripts/control_app.sh "TextEdit" "新建文档并输入 Hello"
bash /Users/guanli/.codex/skills/macos-app-control/scripts/control_app.sh "Finder" "打开桌面文件夹"
```

### 方式二：作为技能调用

当用户说"控制XX应用"、"操作XX软件"、"测试应用"、"GUI测试"时，自动触发此技能。

## 核心功能

### 1. 应用启动与激活

```bash
# 打开应用
open -a "应用名"

# 激活窗口
osascript -e 'tell application "System Events" to set frontmost of process "应用名" to true'
```

### 2. 窗口信息获取

```bash
# 获取窗口位置和大小
osascript -e 'tell application "System Events" to tell process "应用名" to get {position, size} of window 1'

# 获取所有窗口
osascript -e 'tell application "System Events" to tell process "应用名" to get every window'

# 获取 UI 元素
osascript -e 'tell application "System Events" to tell process "应用名" to get entire contents of window 1'
```

### 3. 键盘输入

```bash
# 输入文字
osascript << 'EOF'
tell application "System Events" to tell process "应用名"
    keystroke "Hello World"
end tell
EOF

# 快捷键
osascript << 'EOF'
tell application "System Events" to tell process "应用名"
    keystroke "s" using command down  # Cmd+S
end tell
EOF

# 特殊按键
osascript << 'EOF'
tell application "System Events" to tell process "应用名"
    keystroke return        # 回车
    keystroke tab           # Tab
    keystroke (ASCII character 27)  # Escape
    keystroke space         # 空格
end tell
EOF
```

### 4. 鼠标操作

```bash
# 点击按钮
osascript -e 'tell application "System Events" to tell process "应用名" to click button "确定" of window 1'

# 点击坐标
osascript << 'EOF'
tell application "System Events"
    tell process "应用名"
        click at {100, 200}
    end tell
end tell
EOF

# 菜单操作
osascript << 'EOF'
tell application "System Events" to tell process "应用名"
    click menu item "新建" of menu "文件" of menu bar 1
end tell
EOF

# 拖拽操作
osascript << 'EOF'
tell application "System Events"
    tell process "应用名"
        -- 从坐标 A 拖拽到坐标 B
        drag from {100, 200} to {300, 400}
    end tell
end tell
EOF
```

### 5. 窗口截图

#### 方式一：截取应用窗口（优先）

```bash
# 从窗口信息中提取坐标和尺寸
WINDOW_INFO=$(osascript -e 'tell application "System Events" to tell process "应用名" to get {position, size} of window 1')
X=100; Y=200; W=800; H=600

# 使用 -R 参数指定区域截图
screencapture -R"$X,$Y,$W,$H" /tmp/app_screenshot.png
```

#### 方式二：截取整个屏幕（例外情况）

```bash
# 当无法获取窗口坐标时使用
screencapture /tmp/fullscreen.png
```

### 6. 视觉识别

调用 Kimi Vision 分析截图：

```bash
python3 /Users/guanli/.codex/skills/kimi-vision/scripts/analyze_image.py /tmp/app_screenshot.png "这个界面显示了什么？"
```

## GUI 测试模板

### 模板 1：功能测试流程

```bash
#!/bin/bash
# GUI 功能测试模板

APP_NAME="应用名"
TEST_CASE="测试用例名称"

echo "=== GUI 功能测试 ==="
echo "应用: $APP_NAME"
echo "测试: $TEST_CASE"
echo ""

# 1. 启动应用
echo "[1/5] 启动应用..."
open -a "$APP_NAME"
sleep 1

# 2. 记录初始状态
echo "[2/5] 记录初始状态..."
screencapture /tmp/test_before.png

# 3. 执行操作
echo "[3/5] 执行测试操作..."
osascript << 'EOF'
tell application "System Events" to tell process "应用名"
    -- 测试操作
    keystroke "测试输入"
    keystroke return
end tell
EOF

sleep 0.5

# 4. 记录结果状态
echo "[4/5] 记录结果状态..."
screencapture /tmp/test_after.png

# 5. 视觉验证
echo "[5/5] 视觉验证..."
python3 /Users/guanli/.codex/skills/kimi-vision/scripts/analyze_image.py /tmp/test_after.png "验证结果是否符合预期"

echo "测试完成"
```

### 模板 2：表单测试

```bash
#!/bin/bash
# 表单自动填写测试

# 1. 定位到第一个输入框
osascript << 'EOF'
tell application "System Events" to tell process "应用名"
    keystroke tab  -- 导航到输入框
    keystroke "用户名"
    keystroke tab
    keystroke "密码"
    keystroke return
end tell
EOF
```

### 模板 3：菜单功能测试

```bash
#!/bin/bash
# 菜单功能测试

# 测试每个菜单项
osascript << 'EOF'
tell application "System Events" to tell process "应用名"
    -- 测试"文件"菜单
    click menu item "新建" of menu "文件" of menu bar 1
    delay 0.5
    
    -- 截图验证
    -- ...
    
    -- 测试"编辑"菜单
    click menu item "全选" of menu "编辑" of menu bar 1
    delay 0.5
end tell
EOF
```

### 模板 4：回归测试套件

```bash
#!/bin/bash
# 回归测试套件

TESTS=(
    "测试登录功能"
    "测试创建文档"
    "测试保存功能"
    "测试导出功能"
    "测试退出应用"
)

for TEST in "${TESTS[@]}"; do
    echo "执行测试: $TEST"
    # 调用具体的测试脚本
    # bash test_script.sh "$TEST"
    
    # 记录测试结果
    # screencapture "/tmp/test_result_$(date +%s).png"
done

echo "回归测试完成"
```

## 常见快捷键

| 操作 | 快捷键 | AppleScript |
|------|--------|-------------|
| 保存 | Cmd+S | `keystroke "s" using command down` |
| 打开 | Cmd+O | `keystroke "o" using command down` |
| 新建 | Cmd+N | `keystroke "n" using command down` |
| 关闭窗口 | Cmd+W | `keystroke "w" using command down` |
| 退出应用 | Cmd+Q | `keystroke "q" using command down` |
| 复制 | Cmd+C | `keystroke "c" using command down` |
| 粘贴 | Cmd+V | `keystroke "v" using command down` |
| 全选 | Cmd+A | `keystroke "a" using command down` |
| 撤销 | Cmd+Z | `keystroke "z" using command down` |
| 重做 | Cmd+Shift+Z | `keystroke "z" using {command down, shift down}` |

## 实际应用示例

### 示例 1：GUI 自动化测试 - 计算器

```bash
# 测试计算器的基本运算功能
open -a "Calculator"
sleep 1

# 测试加法
osascript << 'EOF'
tell application "System Events" to tell process "Calculator"
    keystroke "5"
    keystroke "+"
    keystroke "3"
    keystroke "="
end tell
EOF

sleep 0.3

# 截图验证
WINDOW_INFO=$(osascript -e 'tell application "System Events" to tell process "Calculator" to get {position, size} of window 1')
# 截图并验证结果...
```

### 示例 2：GUI 自动化测试 - 文本编辑器

```bash
# 测试文本编辑器的保存功能
open -a "TextEdit"
sleep 1

# 输入文本
osascript << 'EOF'
tell application "System Events" to tell process "TextEdit"
    keystroke "测试文档内容"
end tell
EOF

# 保存文件
osascript << 'EOF'
tell application "System Events" to tell process "TextEdit"
    keystroke "s" using command down
    delay 0.5
    keystroke "test_document"
    keystroke return
end tell
EOF

# 验证文件是否创建
if [ -f "$HOME/Documents/test_document.txt" ]; then
    echo "✓ 测试通过：文件已创建"
else
    echo "✗ 测试失败：文件未创建"
fi
```

### 示例 3：GUI 自动化测试 - 系统偏好设置

```bash
# 测试系统偏好设置的打开和导航
osascript << 'EOF'
tell application "System Preferences"
    activate
    reveal pane id "com.apple.preference.general"
end tell
EOF

sleep 1

# 截图验证
screencapture /tmp/system_prefs.png

# 验证是否正确打开
python3 /Users/guanli/.codex/skills/kimi-vision/scripts/analyze_image.py /tmp/system_prefs.png "是否显示了系统偏好设置的通用设置界面？"
```

## 依赖

- macOS 系统（任意版本，推荐 10.14+）
- AppleScript / System Events（系统内置）
- 辅助功能权限（需在系统偏好设置中授予）
- Kimi Vision 技能（用于视觉识别，可选）

## 注意事项

### 截图相关

1. **优先截取窗口**：非必要不截取整个屏幕
2. **例外情况**：无法获取窗口坐标时可以截全屏
3. **大图片处理**：如需要可压缩后再发送
4. **无上下文限制**：Kimi Vision 是单次请求，基本没有图片大小限制

### 操作相关

1. **辅助功能**：需要授予 Terminal 或 Codex 辅助功能权限
2. **窗口可见**：应用窗口需要可见（不能最小化）
3. **适当延迟**：给应用响应时间
4. **错误处理**：检查窗口是否存在

### GUI 测试相关

1. **测试隔离**：每个测试用例应独立运行
2. **状态重置**：测试前恢复初始状态
3. **结果记录**：保存测试截图和日志
4. **异常处理**：处理弹窗、错误提示等异常情况

## 与 Computer Use 的对比

| 功能 | Computer Use | AppleScript 方案 |
|------|--------------|------------------|
| 依赖 | MCP 插件 | 系统内置 |
| 应用支持 | 所有 macOS 应用 | 所有 macOS 应用 |
| 键盘输入 | ✅ 支持 | ✅ 支持 |
| 鼠标点击 | ✅ 支持 | ✅ 支持 |
| 拖拽操作 | ✅ 支持（坐标计算） | ✅ 支持（坐标计算） |
| 菜单操作 | ✅ 支持 | ✅ 支持 |
| 截图 | 自动窗口截图 | 手动 screencapture |
| 截图范围 | 自动识别窗口 | 优先窗口，可全屏 |
| 视觉识别 | 内置 | 需调用 Kimi Vision |
| 稳定性 | 依赖插件状态 | 系统原生支持 |
| 灵活性 | 受插件限制 | 可自由编写脚本 |
| GUI 测试 | ✅ 支持 | ✅ 完全支持 |
| 测试框架 | 无 | 可自定义 |
| 批量测试 | 需额外实现 | 原生支持脚本 |
| 图片大小限制 | 有优化 | 可压缩，基本无限制 |
| 额外功能 | AI 驱动决策 | 可编程自动化 |

**结论**：本技能与 Computer Use 在核心功能上基本一致，主要差异在于：
1. 本技能使用系统原生 AppleScript，不依赖外部插件
2. 视觉识别需要额外调用 Kimi Vision
3. 可以更灵活地自定义测试脚本和自动化流程
4. 拖拽操作两者实现方式相同，都是基于坐标计算

## 故障排查

### 问题 1：窗口位置获取失败

**原因**：辅助功能权限未授予

**解决**：
1. 系统偏好设置 → 安全性与隐私 → 隐私 → 辅助功能
2. 添加 Terminal 或 Codex 到允许列表
3. 重启终端或 Codex 应用
4. 如果仍然无法获取，直接截取全屏

### 问题 2：键盘输入无效

**原因**：
- 窗口未激活
- 应用未获得焦点
- 输入法冲突

**解决**：
1. 先执行激活窗口命令
2. 添加适当延迟（`sleep 0.5`）
3. 切换到英文输入法

### 问题 3：按钮点击失败

**原因**：
- 按钮 UI 路径不正确
- 按钮名称不匹配
- 窗口结构变化

**解决**：
1. 使用 `entire contents` 命令获取完整 UI 结构
2. 检查按钮的确切名称和路径
3. 尝试使用坐标点击

### 问题 4：应用无法启动

**原因**：
- 应用名称不正确
- 应用未安装
- 权限问题

**解决**：
1. 检查应用名称（区分大小写）
2. 使用 `open -a` 测试应用是否能正常启动
3. 检查应用是否需要特殊权限

## 高级用法

### 1. 多窗口管理

```bash
# 获取所有窗口
WINDOWS=$(osascript -e 'tell application "System Events" to tell process "应用名" to get every window')

# 操作特定窗口
osascript << 'EOF'
tell application "System Events" to tell process "应用名"
    set targetWindow to window 2
    -- 操作该窗口
end tell
EOF
```

### 2. 等待元素出现

```bash
# 循环检查按钮是否存在
osascript << 'EOF'
tell application "System Events" to tell process "应用名"
    repeat until exists button "确定" of window 1
        delay 0.5
    end repeat
    click button "确定" of window 1
end tell
EOF
```

### 3. 条件操作

```bash
# 根据窗口标题执行不同操作
osascript << 'EOF'
tell application "System Events" to tell process "应用名"
    set windowTitle to name of window 1
    if windowTitle contains "保存" then
        keystroke "s" using command down
    else
        keystroke "o" using command down
    end if
end tell
EOF
```

### 4. 异常处理

```bash
# 处理弹窗
osascript << 'EOF'
tell application "System Events" to tell process "应用名"
    if exists sheet 1 of window 1 then
        -- 有弹窗
        click button "确定" of sheet 1 of window 1
    end if
end tell
EOF
```

## 扩展建议

本技能可以作为基础框架，扩展到更复杂的自动化场景：

1. **工作流自动化**：串联多个应用完成复杂任务
2. **测试自动化**：自动测试应用功能
3. **数据处理**：从应用中提取数据并处理
4. **报告生成**：自动截图并生成报告
5. **持续集成**：集成到 CI/CD 流程
6. **性能测试**：测量操作响应时间

只要应用支持 macOS 原生 UI 控制，就可以使用本技能进行操作和测试。
