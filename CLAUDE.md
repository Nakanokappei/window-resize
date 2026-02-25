# Window Resize - macOS Menu Bar App

## Overview
macOSで動作中のアプリウィンドウを既定サイズにリサイズするメニューバー常駐アプリ。

## Tech Stack
- **Language:** Swift (SwiftUI + AppKit)
- **Build:** `swiftc` + シェルスクリプト（Xcodeプロジェクト不要）
- **Signing:** Developer ID Application (Team: G466Q9TVYB) + Apple Notarization
- **Minimum OS:** macOS 13.0 (Ventura)
- **Architecture:** Apple Silicon (arm64) / Intel (x86_64) 自動検出

## Build & Run
```bash
bash build.sh
open "build/Window Resize.app"
```
- ビルドは /tmp にステージング（iCloud Drive の xattr 問題回避）
- Developer ID署名 + Hardened Runtime（`--options runtime`）
- Apple Notarization + Staple を build.sh 内で自動実行
- キーチェーンプロファイル `notarytool-profile` に認証情報を保存済み
- 言語テスト: `open "build/Window Resize.app" --args -AppleLanguages "(ja)"`

## Project Structure
```
Window Resize/
├── CLAUDE.md                # このファイル
├── Info.plist               # アプリメタデータ (LSUIElement, BundleID, Localizations)
├── build.sh                 # ビルドスクリプト (swiftc → /tmpステージング → 署名 → 公証 → .app バンドル)
├── README.md                # GitHub用ドキュメント
├── LICENSE                  # MIT License
├── appicon.af               # アプリアイコン ソース（バンドルには含まない）
├── Window Size App Icon.icon/ # アプリアイコン ソース（バンドルには含まない）
├── docs/                    # ユーザーマニュアル（16言語、マークダウン）
├── Sources/
│   ├── main.swift           # エントリポイント (.accessory ポリシー, 二重起動防止) [18行]
│   ├── AppDelegate.swift    # NSStatusItem, メニュー構築, リサイズ実行 [234行]
│   ├── WindowManager.swift  # CGWindowListCopyWindowInfo + AXUIElement API [88行]
│   ├── PresetSize.swift     # サイズモデル (Codable, Identifiable, label付き) [28行]
│   ├── SettingsStore.swift  # UserDefaults永続化, SMAppService自動起動, スクリーンショット設定 [113行]
│   ├── SettingsView.swift   # SwiftUI設定画面 [151行]
│   ├── SettingsWindowController.swift  # NSHostingController ラッパー [18行]
│   ├── ScreenshotHelper.swift          # SCScreenshotManager (macOS14+) / CGWindowList fallback + Retina対応 [107行]
│   ├── AccessibilityHelper.swift       # 権限チェック・stale検出・ガイド表示 [69行]
│   └── Localization.swift   # L() ヘルパー関数 [5行]
└── Resources/
    ├── AppIcon.icns          # アプリアイコン
    ├── MenuBarIcon.png       # メニューバーアイコン (18×18)
    ├── MenuBarIcon@2x.png    # メニューバーアイコン Retina (36×36)
    ├── en.lproj/             # 英語 (ベース)
    ├── ja.lproj/             # 日本語
    ├── zh-Hans.lproj/        # 簡体中文
    ├── zh-Hant.lproj/        # 繁体中文
    ├── es.lproj/             # スペイン語
    ├── fr.lproj/             # フランス語
    ├── de.lproj/             # ドイツ語
    ├── it.lproj/             # イタリア語
    ├── pt.lproj/             # ポルトガル語
    ├── ru.lproj/             # ロシア語
    ├── ar.lproj/             # アラビア語
    ├── hi.lproj/             # ヒンディー語
    ├── id.lproj/             # インドネシア語
    ├── ko.lproj/             # 韓国語
    ├── vi.lproj/             # ベトナム語
    └── th.lproj/             # タイ語
```

## Key Types & Classes

### AppDelegate.swift
- **ResizeAction** (NSObject) — NSMenuItem の representedObject として windowInfo + PresetSize を運ぶ
- **AppDelegate** — NSStatusItem 管理、メニュー構築、`resizeSelectedWindow()` でリサイズ実行
- **WindowListMenu** (NSMenu, NSMenuDelegate) — `menuNeedsUpdate()` でウィンドウ一覧を遅延取得
- **SizeListMenu** (NSMenu) — ウィンドウごとのプリセットサイズ一覧、画面サイズ超過時は disable

### WindowManager.swift
- **WindowInfo** (struct) — windowID, ownerName, windowName, ownerPID, bounds
- **WindowManager** — `listWindows()` / `resizeWindow(_:to:)` の static メソッド

### SettingsStore.swift
- **ScreenshotSaveLocation** (enum) — `.desktop` / `.pictures`
- **SettingsStore** (ObservableObject, singleton) — `builtInSizes` (12個) + `customSizes`、`launchAtLogin`、スクリーンショット設定
- UserDefaults キー: `"customPresetSizes"`, `"launchAtLogin"`, `"screenshotEnabled"`, `"screenshotSaveToFile"`, `"screenshotSaveLocation"`, `"screenshotCopyToClipboard"`
- 変更時に `.settingsChanged` 通知を post → AppDelegate がメニュー再構築

### ScreenshotHelper.swift
- **ScreenshotHelper** — `captureWindow(_:completion:)` / `saveToFile(_:location:)` / `copyToClipboard(_:)` の static メソッド
- macOS 14+: `SCScreenshotManager` (ScreenCaptureKit) でキャプチャ
- macOS 13: `CGWindowListCreateImage` にフォールバック
- Retina対応: NSImage の size を論理サイズ (point) に設定、ピクセルデータはフル解像度を保持

## Key Architecture Decisions

### ウィンドウ列挙・リサイズ
- `CGWindowListCopyWindowInfo` でウィンドウ一覧取得
- `AXUIElement` API でリサイズ実行（Accessibility権限必須）
- PID + ウィンドウタイトルでマッチング（CGWindowIDとAXUIElementの直接マッピングはない）
- タイトル不一致時は最初のウィンドウにフォールバック

### 座標系の違い
- **CGWindowList**: 原点が画面左上 (top-left origin)
- **NSScreen**: 原点が画面左下 (bottom-left origin, Quartz座標系)
- `SizeListMenu.screenSizeForWindow()` で座標変換してマルチディスプレイ対応

### コード署名・公証
- Developer ID Application 証明書で署名（Team ID: G466Q9TVYB）
- Hardened Runtime 有効（`--options runtime`）— 公証の必須要件
- `xcrun notarytool` で Apple に提出、`xcrun stapler` でチケット貼付
- キーチェーンプロファイル `notarytool-profile` に Apple ID + App-specific password を保存
- build.sh がビルド→署名→公証→ステープルを一括実行

### Accessibility権限
- `AXIsProcessTrusted()` はstaleでも `true` を返す場合がある
- 対策: `isAccessibilityActuallyWorking()` で実際にAXUIElement操作を試行して検証

### スクリーンショット機能
- リサイズ完了後 0.5秒待機してからウィンドウをキャプチャ
- macOS 14+: `SCScreenshotManager` (ScreenCaptureKit) — コード署名済みアプリ向けの安全なAPI
- macOS 13: `CGWindowListCreateImage` フォールバック（非推奨API）
- Retina対応: フル解像度ピクセルを保持しつつ NSImage.size を論理サイズに設定（144 DPI PNG出力）
- 保存先: デスクトップ or ピクチャ（設定で選択）
- クリップボードへのコピーも同時実行可能（設定で ON/OFF）
- 権限不足時はサイレントに失敗（OS が権限ダイアログを表示する）

### 多言語対応 (i18n)
- `NSLocalizedString` + `.lproj/Localizable.strings` 方式（全16言語）
- 一部言語には `InfoPlist.strings` も存在（アクセシビリティ説明文の翻訳）
- `L("key")` ヘルパー関数で呼び出し
- プリセットサイズ名（"MacBook Pro 16\"", "XGA" 等）は翻訳しない（製品名・規格名）

### メニュー構造
- NSStatusItem + NSMenu（AppKit）
- サイズ名にタブストップ(230pt)で右揃えラベル表示（NSAttributedString + NSTextTab）
- WindowListMenu: NSMenuDelegate で遅延ウィンドウ一覧取得
- 画面解像度を超えるサイズは自動的に disabled

### 設定永続化
- UserDefaults でカスタムサイズ保存 (JSONEncoder/Decoder)
- SMAppService でログイン時自動起動
- 設定画面: SwiftUI → NSHostingController → NSWindow（400×500 固定サイズ）

## Bundle ID
`com.windowresize.app`

## Conventions
- ローカライズキーはドット区切り: `menu.resize`, `settings.width`, `alert.resize-failed.title`
- NSMenu の既存プロパティとの名前衝突注意（例: `size` → `presetSize` にリネーム済み）
- `resizeSelectedWindow` は WindowListMenu から呼ばれるため `private` 不可
- ソースコード合計: 約730行（9ファイル）
