import QtQuick
import Quickshell
import Quickshell.Hyprland

import "../island"
import "../core"
import "../services"

PanelWindow {
    id: root
    visible: ThemeService.ready

    // Hyprland-only: Niri does not implement hyprland_focus_grab_v1,
    // so click-outside-to-dismiss is unavailable there (Esc / IPC reset still work).
    HyprlandFocusGrab {
        id: focusGrab
        active: CompositorService.isHyprland && ThemeService.ready && IslandState.modal
        windows: [ root ]

        onCleared: {
            IslandController.reset()
        }
    }

    // Focusable whenever a modal view is open so keyboard navigation
    // (hjkl / arrows / Enter / Esc) works on all compositors.
    focusable: ThemeService.ready && IslandState.modal

    anchors {
        top: true
        left: true
        right: true
    }

    exclusiveZone: ThemeService.ready ? 33 : 0
    implicitHeight: capsule.implicitHeight + 20
    color: "transparent"

    Island {
        id: capsule
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
    }

    Region {
        id: capsuleMask
        item: capsule
    }

    mask: capsuleMask
}
