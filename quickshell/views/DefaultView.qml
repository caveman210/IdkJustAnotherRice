import QtQuick
import "../views"
import "../services"
import "../components"

Item {
    // Base 160 fits Clock (+ Cava when playing). Expand only while the
    // low-battery warning is shown so the island grows like it does
    // for other states instead of reserving space permanently.
    implicitWidth: LowBatteryService.active ? Math.max(160, row.implicitWidth + 32) : 160
    implicitHeight: 33

    Row {
        id: row
        spacing: 8
        anchors.centerIn: parent

        Cava {
            visible: MediaService.hasPlayer
            anchors.verticalCenter: parent.verticalCenter
        }

        ClockView {
            anchors.verticalCenter: parent.verticalCenter
        }

        LowBatteryIndicator {
            visible: LowBatteryService.active
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
