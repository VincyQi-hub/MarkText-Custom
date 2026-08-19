!macro customInstall
  ; 注册 Markdown 文件预览处理器，使 Windows 资源管理器预览窗格（Preview Pane）
  ; 显示 md 文档的渲染效果（标题/加粗/列表排版，而非带 # 标记的原始文本）。
  ; 优先使用 PowerToys 的 Markdown Preview Handler（渲染效果）；
  ; 若目标机器未安装 PowerToys，则回退到 Windows 内置文本预览器（纯文本预览）。
  ; 键位置：HKCU\Software\Classes（用户级，无需管理员权限，优先于系统级）。
  ; 注：卸载时不删除这些键，避免卸载后资源管理器预览再次消失。
  IfFileExists "$LOCALAPPDATA\PowerToys\PowerToys.MarkdownPreviewHandlerCpp.dll" 0 NoPowerToys
    WriteRegStr HKCU "Software\Classes\.md\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}" "" "{60789D87-9C3C-44AF-B18C-3DE2C2820ED3}"
    WriteRegStr HKCU "Software\Classes\.markdown\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}" "" "{60789D87-9C3C-44AF-B18C-3DE2C2820ED3}"
    WriteRegStr HKCU "Software\Classes\.mmd\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}" "" "{60789D87-9C3C-44AF-B18C-3DE2C2820ED3}"
    WriteRegStr HKCU "Software\Classes\.mdown\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}" "" "{60789D87-9C3C-44AF-B18C-3DE2C2820ED3}"
    WriteRegStr HKCU "Software\Classes\.mdtxt\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}" "" "{60789D87-9C3C-44AF-B18C-3DE2C2820ED3}"
    WriteRegStr HKCU "Software\Classes\.mdtext\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}" "" "{60789D87-9C3C-44AF-B18C-3DE2C2820ED3}"
    Goto PreviewDone
  NoPowerToys:
    WriteRegStr HKCU "Software\Classes\.md\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}" "" "{1531d583-8375-4d3f-b5fb-d23bbd169f22}"
    WriteRegStr HKCU "Software\Classes\.markdown\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}" "" "{1531d583-8375-4d3f-b5fb-d23bbd169f22}"
    WriteRegStr HKCU "Software\Classes\.mmd\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}" "" "{1531d583-8375-4d3f-b5fb-d23bbd169f22}"
    WriteRegStr HKCU "Software\Classes\.mdown\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}" "" "{1531d583-8375-4d3f-b5fb-d23bbd169f22}"
    WriteRegStr HKCU "Software\Classes\.mdtxt\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}" "" "{1531d583-8375-4d3f-b5fb-d23bbd169f22}"
    WriteRegStr HKCU "Software\Classes\.mdtext\shellex\{8895b1c6-b41f-4c1c-a562-0d564250836f}" "" "{1531d583-8375-4d3f-b5fb-d23bbd169f22}"
  PreviewDone:
  ; 设置 md 文件图标为 MarkText 图标（扩展名层 + ProgID 层兜底，指向安装的 marktext.exe）
  WriteRegStr HKCU "Software\Classes\Markdown\DefaultIcon" "" "$INSTDIR\marktext.exe,0"
  WriteRegStr HKCU "Software\Classes\.md\DefaultIcon" "" "$INSTDIR\marktext.exe,0"
  WriteRegStr HKCU "Software\Classes\.markdown\DefaultIcon" "" "$INSTDIR\marktext.exe,0"
  WriteRegStr HKCU "Software\Classes\.mmd\DefaultIcon" "" "$INSTDIR\marktext.exe,0"
  WriteRegStr HKCU "Software\Classes\.mdown\DefaultIcon" "" "$INSTDIR\marktext.exe,0"
  WriteRegStr HKCU "Software\Classes\.mdtxt\DefaultIcon" "" "$INSTDIR\marktext.exe,0"
  WriteRegStr HKCU "Software\Classes\.mdtext\DefaultIcon" "" "$INSTDIR\marktext.exe,0"
!macroend

!macro customUnInstall
  MessageBox MB_YESNO "是否删除用户设置？" /SD IDNO IDNO SkipRemoval
    SetShellVarContext current
    RMDir /r "$APPDATA\marktext"
  SkipRemoval:
!macroend