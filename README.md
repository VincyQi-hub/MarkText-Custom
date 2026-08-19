# MarkText Custom（特别版）

基于 [MarkText](https://github.com/marktext/marktext) 0.17.1 的中文特别版，面向 **Ebook / 文档工程** 场景深度定制的所见即所得 Markdown 编辑器。

</div>

## ✨ 特性

- **中文汉化**：界面全面中文化
- **Mermaid mindmap**：升级 Mermaid 并支持思维导图
- **工作区级配置（folder settings）**：类似 VS Code，每个项目一个 `marktext.json`
- **图片路径预置变量**：`${filename}`、`${fileWorkspaceFolder}`、`${relativeFileDirname}` 等，按项目灵活组织图片存储
- **图片文字环绕**：图片可左浮动，文字（引用块、代码块、列表、标题等块级元素）环绕在图片右侧
- **表格整体对齐**：左对齐 / 居中 / 右对齐 / 整行居中，自定义语法 `{: align=center }` 持久化
- **退出确认弹窗中文化**：保存 / 不保存 / 取消
- **Windows 集成**：安装后自动注册 md 文件渲染预览与 MarkText 文件图标

## 📸 截图

- ### 图标修改：图标修改为更符合MD文档编辑的风格
  
  <img src="file:///C:/Users/Dvincy/Desktop/markText-custom-master/assets/README/2026-08-19-01.png" title="" alt="2026-08-19-01.png" width="111">

- ### 表格整体的对齐方式：左中右/整行居中
  
  <img src="file:///C:/Users/Dvincy/Desktop/markText-custom-master/assets/README/2026-08-19-02.png" title="" alt="2026-08-19-02.png" width="660">

- ### 图片的文字环绕效果：
  
  ![2026-08-19-03.png](C:\Users\Dvincy\Desktop\markText-custom-master\assets\README\2026-08-19-03.png)

- ### 退出时保存：位置更符合主流软件
  
  ![2026-08-19-04.png](C:\Users\Dvincy\Desktop\markText-custom-master\assets\README\2026-08-19-04.png)

- ### windows 资源管理器：预览MD文件（需要安装Powertoy）

<img src="file:///C:/Users/Dvincy/Desktop/markText-custom-master/assets/README/2026-08-19-06.png" title="" alt="2026-08-19-06.png" width="632">

- ### 卸载弹窗：是否删除用户配置文字汉化补充

![2026-08-19-05.png](C:\Users\Dvincy\Desktop\markText-custom-master\assets\README\2026-08-19-05.png)

## 📦 安装

从 [Releases](../../releases) 下载对应平台的安装包：

| 平台                 | 安装包                  |
| ------------------ | -------------------- |
| Windows x64 / ia32 | `marktext-setup.exe` |
| macOS / Linux      | 待发布                  |

> Windows 安装包安装时**自动注册** md 文件渲染预览（已装 [PowerToys](https://learn.microsoft.com/powertoys) 时显示 Markdown 渲染效果，否则回退系统文本预览）与 MarkText 文件图标。

## 🚀 使用

### 图片文字环绕与分栏

1. 插入图片并选中
2. 工具栏点击 **文字环绕** → 编辑器内图片左浮动、文字环绕
3. **导出 HTML/PDF 时自动分栏**：图片固定在左侧，图片之后的内容（引用块、代码块、表格、文字——直到下一个标题或另一张浮动图片）自动排列在图片右侧，不再受浮动高度限制

> 也支持手动分栏语法：用 `{: .columns }` ... `{: /columns }` 包裹图片和右侧内容（Ebook 网站需配合解析）。

### 表格整体对齐

光标进入表格 → 表格上方菜单（创建副本/转为...）选择：

| 功能         | md 语法               |
| ---------- | ------------------- |
| 左对齐        | `{: align=left }`   |
| 居中         | `{: align=center }` |
| 右对齐        | `{: align=right }`  |
| 整行居中（占满整行） | `{: align=full }`   |

对齐标记写在表格最后一行之后（中间无空行），由 Ebook 网站解析该自定义语法。

### 工作区配置（`marktext.json`）

在项目根目录放置 `marktext.json`，打开该目录时自动应用：

```json
{
  "imageRelativeDirectoryName": "${fileWorkspaceFolder}/markdown/_images/${relativeFileDirname}/${fileBasenameNoExtension}",
  "imagePreferRelativeDirectory": true,
  "imageInsertAction": "folder",
  "theme": "one-dark"
}
```

## 🔧 从源码构建

完整构建说明见 [PROJECT_ARCHITECTURE.md](./PROJECT_ARCHITECTURE.md)。

```bash
# 1. 安装依赖（跳过 postinstall 中依赖 yarn 的脚本）
npm install --ignore-scripts --legacy-peer-deps

# 2. 构建（webpack 编译 main / renderer / muya）
node .electron-vue/build.js

# 3. 打包 Windows 安装包（需先完成架构文档中的 node-gyp 环境适配）
export npm_config_openssl_fips=
npx electron-builder --win --x64
```

## 📚 文档

- [项目架构与修改记录](./PROJECT_ARCHITECTURE.md)

## 🤝 致谢

- [MarkText](https://github.com/marktext/marktext) 原作者 [Jocs](https://github.com/Jocs) 及贡献者
- [chinayangxiaowei](https://github.com/chinayangxiaowei/marktext-chinese-language-pack) 中文汉化思路
- [PowerToys](https://github.com/microsoft/PowerToys) Markdown 预览处理器

## 📄 许可证

[MIT](./LICENSE)MarkText Custom（MarkText 0.17.1 增强定制版）
