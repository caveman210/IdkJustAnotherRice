import QtQuick

import "../views"
import "../styles"
import "../services"
import "../components"

Item {
    id: root
    // Wider than the 160 pill so the centered clock clears the
    // privacy cluster on the left and the battery icon on the
    // right. Expand only while the low-battery warning is shown,
    // like the pill does. No Cava here by design.
    implicitWidth: LowBatteryService.active ? Math.max(210, row.implicitWidth + 32) : 210
    implicitHeight: 33

    BatteryService {
        id: batteryService
    }

    PrivacyIndicators {
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
    }

    Row {
        id: row
        spacing: 8
        anchors.centerIn: parent

        ClockView {
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Text {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        text: batteryService ? batteryService.icon : "󰁺"
        color: Theme.icon
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 16
    }
}
