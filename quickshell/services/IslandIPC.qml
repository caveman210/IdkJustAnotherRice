import Quickshell
import Quickshell.Io

import "../core"

IpcHandler {
    target: "luci"

    function openPowerMenu() {
        IslandController.openPowerMenu()
    }

    function openExpandedHome() {
        IslandController.openExpanded()
    }

    function reset() {
        IslandController.reset()
    }

    function openWallpaperSelector() {
        IslandController.openWallpaperSelector()
    }

    function openThemeSelector() {
        IslandController.openThemeSelector()
    }
}
