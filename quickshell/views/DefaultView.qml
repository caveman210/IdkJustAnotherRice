import QtQuick
import "../views"
import "../services"
import "../components"

Item {
    implicitWidth: 160
    implicitHeight: 33

    Row {
        id: row
        spacing: 8
        anchors.centerIn: parent

        Cava {
            visible: MediaService.hasPlayer
            anchors.verticalCenter: parent.verticalCenter
        }

        ClockView { }
    }
}
