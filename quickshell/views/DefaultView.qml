import QtQuick
import "../views"
import "../services"
import "../components"

Item {
    // Base 160 fits the centered clock. Expand only while the
    // low-battery warning is shown so the island grows like it does
    // for other states instead of reserving space permanently.
    // (The wider notch is its own view — see NotchView.)
    implicitWidth: LowBatteryService.active ? Math.max(160, row.implicitWidth + 32) : 160
    implicitHeight: 33

    Row {
        id: row
        spacing: 8
        anchors.centerIn: parent

        ClockView {
            anchors.verticalCenter: parent.verticalCenter
        }

        LowBatteryIndicator {
            visible: LowBatteryService.active
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
