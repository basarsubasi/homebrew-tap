cask "optiontab" do
  version "1.0.0"
  
  # Replace this with the output of `shasum -a 256 OptionTab-1.0.0.dmg`
  sha256 "33631de454faec35ece8c5b8c11c89c8b73dcf1b2fcd9649c99a5ce8c40bae5b"

  # Replace this with the actual URL to your GitHub release DMG
  url "https://github.com/basarsubasi/option-tab-macos/releases/download/v#{version}/OptionTab-#{version}.dmg"
  
  name "OptionTab"
  desc "Fast and minimal alt-tab behavior for macOS"
  homepage "https://github.com/basarsubasi/option-tab-macos"

  depends_on macos: :ventura

  app "OptionTab.app"

  # Run after the app is copied to Applications
  postflight do
    # 1. Automatically remove the quarantine flag so the user never sees the "damaged app" error
    system_command "xattr",
                   args: ["-cr", "/Applications/OptionTab.app"],
                   must_succeed: true,
                   sudo: false
    # 2. Launch the app immediately!
    system_command "open",
                   args: ["-a", "OptionTab"],
                   must_succeed: false,
                   sudo: false
  end

  # ==========================================
  # UNINSTALLATION & CLEANUP LOGIC
  # ==========================================

  # 1. Reset Accessibility Permissions via terminal
  uninstall_preflight do
    system_command "tccutil",
                   args: ["reset", "Accessibility", "com.optiontab.app"],
                   sudo: false,
                   must_succeed: false
  end


  # 2. Quit the app and remove it from macOS Login Items
  uninstall quit:       "com.optiontab.app",
            login_item: "OptionTab"



  # 3. Trash UserDefaults and settings
  zap trash: [
    "~/Library/Preferences/com.optiontab.app.plist",
    "~/Library/Application Scripts/com.optiontab.app"
  ]
end