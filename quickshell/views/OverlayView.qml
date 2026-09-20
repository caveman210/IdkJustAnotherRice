import QtQuick
import QtQuick.Layouts

import "../styles"
import "../core"

Item {
    id: root
    property bool expandedMode: false
    property int maximum: 100
    implicitWidth: {
        // Explicit caller width wins (all callers pass one).
        // Fall back to per-mode Theme constants otherwise.
        // "device" auto-sizes to the full text (capped) so
        // connect/disconnect prompts never clip mid-word.
        if (StatusManager.statusWidth > 0)
            return StatusManager.statusWidth

        switch (StatusManager.mode) {
        case "workspace":
            return Theme.statusWorkspaceWidth
        case "keyboard":
            return Theme.statusKeyboardWidth
        case "volume":
            return Theme.statusVolumeWidth
        case "brightness":
            return Theme.statusBrightnessWidth
        case "notification":
            return Theme.statusNotificationWidth
        case "device": {
            let textW = Math.ceil(deviceMetrics.advanceWidth)
            let iconW = Math.ceil(deviceIconMetrics.advanceWidth)
            let fitted = 14 + iconW + 10 + textW + 14 + 20
            return Math.min(fitted, Theme.statusDeviceMaxWidth)
        }
        default:
            return Theme.statusDefaultWidth
        }
    }

    implicitHeight: 33

    // Measures the device prompt title with the same font as the
    // display text so implicitWidth fits it exactly.
    TextMetrics {
        id: deviceMetrics
        font.pixelSize: 13
        font.weight: Font.Medium
        elide: Text.ElideNone
        text: StatusManager.title
    }

    TextMetrics {
        id: deviceIconMetrics
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 15
        elide: Text.ElideNone
        text: StatusManager.icon
    }

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        anchors.leftMargin:
            StatusManager.mode === "workspace" ||
            StatusManager.mode === "keyboard"
                ? 35
                : 14
        anchors.rightMargin: 14
        spacing: 10
        Text {
            text: StatusManager.icon
            color: Theme.textPrimary
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 15
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle {
            visible:
                StatusManager.mode === "volume" ||
                StatusManager.mode === "brightness"

            Layout.fillWidth: visible
            Layout.alignment: Qt.AlignVCenter
            height: 6
            radius: height / 2
            color: Theme.surface

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height
                radius: height / 2
                width: Math.max(
                    0,
                    Math.min(
                        parent.width,
                        parent.width * StatusManager.value / maximum
                    )
                )

                color: Theme.accent
                Behavior on width {
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }

        Text {
            visible: StatusManager.mode === "workspace"
            text: root.expandedMode
                ? StatusManager.title
                : "Workspace " + StatusManager.title
            color: Theme.textPrimary
            font.pixelSize: 13
            font.weight: Font.Medium
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            visible: StatusManager.mode === "keyboard"
            text: StatusManager.title
            color: Theme.textPrimary
            font.pixelSize: 16
            font.weight: Font.Medium
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            visible: StatusManager.mode === "notification"
            text: StatusManager.title
            color: Theme.textPrimary
            font.pixelSize: 13
            font.weight: Font.Medium
            elide: Text.ElideRight
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            visible: StatusManager.mode === "device"
            text: StatusManager.title
            color: Theme.textPrimary
            font.pixelSize: 13
            font.weight: Font.Medium
            elide: Text.ElideRight
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            visible:
                StatusManager.mode === "volume" ||
                StatusManager.mode === "brightness"

            text: StatusManager.value >= 0
                ? StatusManager.value + "%"
                : "Muted"
            color: Theme.textPrimary
            font.pixelSize: 12
            font.weight: Font.Medium
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
