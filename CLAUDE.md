# Window Resize - macOS Menu Bar App

## Overview
macOSで動作中のアプリウィンドウを既定サイズにリサイズするメニューバー常駐アプリ。

## Tech Stack
- **Language:** Swift (SwiftUI + AppKit)
- **Build:** `swiftc` + シェルスクリプト（Xcodeプロジェクト不要）
- **Minimum OS:** macOS 13.0 (Ventura)
- **Architecture:** Apple Silicon (arm64) / Intel (x86_64) 自動検出

## Build & Run
```bash
bash build.sh
open "build/Window Resize.app"
```
- ビルド時に `tccutil reset` でアクセシビリティ権限を自動リセット（未署名アプリのため）
- Gatekeeperに止められた場合: `xattr -cr "build/Window Resize.app"`

## Project Structure
```
Window Resize/
├── CLAUDE.md                # このファイル
├── Info.plist               # アプリメタデータ (LSUIElement, BundleID, Localizations)
├── build.sh                 # ビルドスクリプト (swiftc → .app バンドル組み立て)
├── Sources/
│   ├── main.swift           # エントリポイント (.accessory ポリシー)
│   ├── AppDelegate.swift    # NSStatusItem, メニュー構築, リサイズ実行
│   ├── WindowManager.swift  # CGWindowListCopyWindowInfo + AXUIElement API
│   ├── PresetSize.swift     # サイズモデル (Codable, label付き)
│   ├── SettingsStore.swift  # UserDefaults永続化, SMAppService自動起動
│   ├── SettingsView.swift   # SwiftUI設定画面
│   ├── SettingsWindowController.swift  # NSHostingController ラッパー
│   ├── AccessibilityHelper.swift       # 権限チェック・stale検出・ガイド表示
│   └── Localization.swift   # L() ヘルパー関数
└── Resources/
    ├── en.lproj/            # 英語 (ベース)
    ├── zh-Hans.lproj/       # 簡体中文
    ├── es.lproj/            # スペイン語
    ├── hi.lproj/            # ヒンディー語
    ├── ar.lproj/            # アラビア語
    ├── id.lproj/            # インドネシア語
    ├── pt.lproj/            # ポルトガル語
    ├── fr.lproj/            # フランス語
    ├── ja.lproj/            # 日本語
    ├── ru.lproj/            # ロシア語
    ├── de.lproj/            # ドイツ語
    ├── vi.lproj/            # ベトナム語
    ├── th.lproj/            # タイ語
    ├── ko.lproj/            # 韓国語
    ├── it.lproj/            # イタリア語
    └── zh-Hant.lproj/       # 繁体中文
```

## Key Architecture Decisions

### ウィンドウ列挙・リサイズ
- `CGWindowListCopyWindowInfo` でウィンドウ一覧取得
- `AXUIElement` API でリサイズ実行（Accessibility権限必須）
- PID + ウィンドウタイトルでマッチング（CGWindowIDとAXUIElementの直接マッピングはない）

### Accessibility権限のstale問題
- 未署名アプリはリビルドのたびにバイナリハッシュが変わり、TCC権限が無効化される
- `AXIsProcessTrusted()` はstaleでも `true` を返す場合がある
- 対策: `isAccessibilityActuallyWorking()` で実際にAXUIElement操作を試行して検証
- build.sh で `tccutil reset Accessibility` を自動実行

### 多言語対応 (i18n)
- `NSLocalizedString` + `.lproj/Localizable.strings` 方式
- `L("key")` ヘルパー関数で呼び出し
- プリセットサイズ名（"MacBook Pro 16\"", "XGA" 等）は翻訳しない（製品名・規格名）
- 言語テスト: `open "build/Window Resize.app" --args -AppleLanguages "(ja)"`

### メニュー構造
- NSStatusItem + NSMenu（AppKit）
- サイズ名にタブストップで右揃えラベル表示（NSAttributedString）
- WindowListMenu: NSMenuDelegate で遅延ウィンドウ一覧取得

### 設定永続化
- UserDefaults でカスタムサイズ保存 (JSONEncoder/Decoder)
- SMAppService でログイン時自動起動

## Bundle ID
`com.windowresize.app`

## Conventions
- ローカライズキーはドット区切り: `menu.resize`, `settings.width`, `alert.resize-failed.title`
- NSMenu の既存プロパティとの名前衝突注意（例: `size` → `presetSize` にリネーム済み）
- `resizeSelectedWindow` は WindowListMenu から呼ばれるため `private` 不可
