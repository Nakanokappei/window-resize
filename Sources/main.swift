import AppKit

// 二重起動防止: 同じバンドルIDのプロセスが既に動いていたら終了する
// Prevent duplicate launch: quit if another instance with the same bundle ID is already running
if let bundleID = Bundle.main.bundleIdentifier {
    let running = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
    if running.count > 1 {
        // 既存インスタンスがあれば終了（パスが異なっても検出される）
        // Exit if another instance exists (detected regardless of file path)
        exit(0)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
