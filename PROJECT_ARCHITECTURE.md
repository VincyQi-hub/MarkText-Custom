# 项目架构与构建说明（marktext_specialedition）

本文档记录本项目的**架构构建方式**与**已做的修改内容**，供后续开发与打包参考。

## 1. 项目概述

- 名称：`marktext_specialedition`（MarkText 特别版）
- 基准：官方 **MarkText 0.17.1**（2022-03 停止更新）的中文 fork
- 定位：面向 **Ebook / 文档工程**的所见即所得 Markdown 编辑器
- 技术栈：Electron 17 + Vue 2.6 + Vuex 3 + Webpack 5 + 自研 muya 编辑器引擎（marked + snabbdom）

## 2. 架构如何构建

### 2.1 三层源码结构

```
src/
├── main/        Electron 主进程（Node 环境）
│   ├── app/           窗口管理、启动流程（windowManager）
│   ├── preferences/   全局偏好设置（electron-store + schema.json）
│   ├── menu/          菜单与动作（actions/file.js 含退出确认弹窗）
│   ├── filesystem/    文件读写、编码、监听
│   └── windows/       各窗口实现（editor.js / setting.js）
├── renderer/    Vue 渲染进程
│   ├── pages/         app.vue（主界面）、preference.vue（设置页）
│   ├── components/    editorWithTabs/、sideBar/、exportSettings/ 等
│   ├── store/         Vuex：editor.js、preferences.js、project.js 等
│   ├── services/      printService.js（导出 PDF 用）等
│   └── mixins/        文件点击等公共逻辑
└── muya/        核心 Markdown 引擎（独立库）
    └── lib/
        ├── parser/        marked 定制解析器（blockRules / inlineRules / lexer / renderer）
        ├── contentState/  文档状态与编辑操作（enterCtrl、backspaceCtrl、pasteCtrl 等 + history）
        ├── eventHandler/  键盘 / 鼠标 / 剪贴板 / 拖放事件
        ├── renderers/     AST → snabbdom vnode → DOM
        ├── marktext/      marktext 扩展语法
        └── ui/            浮动 UI（图片选择、格式选择、表格工具等）
```

### 2.2 数据流

```
用户输入 → eventHandler（键盘/鼠标/剪贴板）
        → contentState 修改文档 AST（各 *Ctrl 模块）
        → renderers 重新渲染 snabbdom vnode → 更新 DOM（所见即所得）
        → stateChange 事件 → 渲染进程 Vuex → 主进程 ipc 保存文件
```

主进程与渲染进程通过 `ipcMain` / `ipcRenderer`（`src/main/dataCenter`）通信；全局配置存于 `src/main/preferences`（electron-store）。

### 2.3 导出 PDF 机制

Markdown → HTML → 隐藏 `.print-container`（`src/renderer/services/printService.js`）→ Chromium 打印引擎 → PDF。可设页面尺寸（A3/A4/A5/Letter 等）、页眉页脚、导出主题（Academic / GitHub / Liber）。

## 3. 构建环境与打包

### 3.1 前置条件

- Node.js（本项目用 v24 实测通过）、npm
- VS Build Tools（含 VC++ v143 工具集）与 **Windows SDK**（用于原生模块编译）
- 网络（国内建议配 npmmirror 镜像）

### 3.2 依赖安装（npm 替代 yarn）

```bash
npm install --ignore-scripts --legacy-peer-deps --registry=https://registry.npmmirror.com
# 补充下载 Electron 二进制：
ELECTRON_MIRROR="https://npmmirror.com/mirrors/electron/" node node_modules/electron/install.js
```

> `--ignore-scripts`：跳过 postinstall 中依赖 yarn 的脚本（`yarn run rebuild` / `yarn run lint:fix`）。
> `--legacy-peer-deps`：绕过旧依赖树与 npm 7+ 严格 peer 校验的冲突（如 eslint-config-standard 与 eslint 8）。

### 3.3 node-gyp 环境适配（关键，否则原生模块编译失败）

本项目原生模块（`ced`、`fontmanager-redux`、`keytar`、`native-keymap`）在 Windows 编译需要 node-gyp 能找到 VS + SDK。本机实测需要：

1. **node-gyp 降到 8.4.1**（7.1.2 无法识别本机 VS 安装；8.4.1 的 VS 检测正常）：
   ```bash
   npm install --no-save node-gyp@8.4.1 --legacy-peer-deps
   ```
2. **打独立 SDK 检测补丁**：本机 Windows SDK 为独立安装（VS 组件清单只有 `Windows11SDK` 前缀），node-gyp 默认报 "missing any Windows SDK"。在 `node_modules/node-gyp/lib/find-visualstudio.js` 的 `getSDK` 末尾追加文件系统检测（检查 `%ProgramFiles(x86)%\Windows Kits\10\Include` 下的 SDK 版本号并返回）。
3. **`openssl_fips` 兼容**：Electron 17 头文件（`.electron-gyp/17.1.2/include/node/common.gypi`）与 node-gyp 8 的条件评估不兼容，编译前设置：
   ```bash
   export npm_config_openssl_fips=
   ```

> 这些适配均位于 `node_modules` 内，重新 `npm install` 后需重新应用。

### 3.4 构建与打包命令

```bash
# webpack 构建（main + renderer + muya）
node .electron-vue/build.js

# 打包 Windows 安装包（x64 + ia32 NSIS）
export npm_config_openssl_fips=
ELECTRON_MIRROR="https://npmmirror.com/mirrors/electron/" \
ELECTRON_BUILDER_BINARIES_MIRROR="https://npmmirror.com/mirrors/electron-builder-binaries/" \
npx electron-builder --win --x64
```

产物（`build/`）：
- `marktext-setup.exe` —— NSIS 安装包（**推荐**，安装时自动注册 md 预览处理器与文件图标）
- `marktext-x64-win.zip` / `marktext-ia32-win.zip` —— 免安装版（不执行安装脚本）

## 4. 修改内容记录

### 4.1 应用图标替换

| 文件 | 说明 |
|---|---|
| `static/logo-96px.png` | 窗口 / 任务栏图标（96×96） |
| `src/renderer/assets/images/logo.png` | "关于"对话框图标（150×150） |
| `resources/icons/icon.png` | 图标源图（1025×1025） |
| `resources/icons/{16,24,32,48,64,128,256,512}x*/marktext.png` | Linux 打包图标源 |
| `resources/icons/icon.ico` | Windows 打包图标（多尺寸 ICO） |

- 源图 `MarkText图标.png`（270×278）居中放入透明正方形画布（不变形）后缩放到各尺寸，尺寸与原图标逐一一致。
- 原图标备份于 `/tmp/icon_backup/`（若需恢复）。
- 限制：mac 打包图标 `icon.icns` 未替换（本机无 icns 生成工具）。

### 4.2 退出确认弹窗中文化

`src/main/menu/actions/file.js` 的 `showUnsavedFilesMessage`：

- 标题：`MarkText`
- 按钮（左→右）：**保存 / 不保存 / 取消**（中文）
- 内容：`是否保存对 N 个文件的更改？`，细节：`如果不保存，更改将丢失。`
- `defaultId: 0`（默认保存）、`cancelId: 2`（Esc → 取消）
- 该弹窗同时服务于：关闭未保存标签、关闭全部标签、关闭窗口、退出应用。

### 4.3 Windows 资源管理器 md 预览注册

`resources/windows/installer.nsh` 的 `customInstall` 宏（NSIS 安装时执行，`electron-builder.yml` 已通过 `nsis.include` 引用）：

- 为 `.md/.markdown/.mmd/.mdown/.mdtxt/.mdtext` 注册预览处理器：
  - 已装 PowerToys：`Markdown Preview Handler`（`{60789D87-9C3C-44AF-B18C-3DE2C2820ED3}`，Markdig 渲染 → 预览窗格显示渲染效果）
  - 未装 PowerToys：回退 Windows 内置文本预览器（`{1531d583-8375-4d3f-b5fb-d23bbd169f22}`）
- 键位置：`HKCU\Software\Classes\.<ext>\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}`（用户级，无需管理员）
- 卸载时不删除这些键（避免卸载后预览消失）。

### 4.4 md 文件图标注册

- `electron-builder.yml`：`fileAssociations[0].icon = "resources/icons/icon.ico"`（win 文件关联图标；mac 自动转 `.icns`）
- `installer.nsh`：注册 `Markdown` ProgID 及 6 个扩展名层的 `DefaultIcon` 指向 `$INSTDIR\marktext.exe,0`（应用图标，跟随安装位置）
- 效果：将 `.md` 默认打开方式设为 MarkText 后，资源管理器中的 md 文件图标显示为 MarkText 图标。

### 4.5 文档更新

- `README.md`：完善为项目自身说明（特色 + 本次增强 + 构建快速开始）
- 本文档（`PROJECT_ARCHITECTURE.md`）：架构与修改记录

## 5. 注意事项与后续

- **安装版 vs 免安装版**：预览处理器注册、文件图标注册只在 NSIS 安装包（`marktext-setup.exe`）安装时执行；免安装版（zip / win-unpacked）不会自动注册。
- **PowerToys 依赖**：md 渲染预览依赖 PowerToys；卸载 PowerToys 后渲染预览失效（回退键已在安装时写入，无需重装）。
- **node-gyp 适配需重装依赖后重新应用**（见 3.3）。
- 目录无 `.git`，建议 `git init` 后纳入版本管理。
