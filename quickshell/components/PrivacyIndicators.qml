import QtQuick

import "../styles"
import "../services"

// Privacy indicators for the notch's left end: camera, mic and
// screen-share. Active devices get a colored icon with a dot
// stacked above; idle camera/mic show the greyed struck-through
// variant; screen-share hides entirely while idle.
Row {
    id: root
    spacing: 6

    Item {
        width: 16
        height: 24

        Rectangle {
            visible: PrivacyService.cameraActive
            width: 6
            height: 6
            radius: 3
            color: Theme.success
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        SvgIcon {
            source: PrivacyService.cameraActive
                ? Qt.resolvedUrl("../assets/icons/camera.svg")
                : Qt.resolvedUrl("../assets/icons/camera-off.svg")
            size: 16
            color: PrivacyService.cameraActive ? Theme.success : Theme.iconDisabled
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Item {
        width: 16
        height: 24

        Rectangle {
            visible: PrivacyService.micActive
            width: 6
            height: 6
            radius: 3
            color: Theme.success
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        SvgIcon {
            source: PrivacyService.micActive
                ? Qt.resolvedUrl("../assets/icons/microphone.svg")
                : Qt.resolvedUrl("../assets/icons/microphone-off.svg")
            size: 16
            color: PrivacyService.micActive ? Theme.success : Theme.iconDisabled
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Item {
        visible: PrivacyService.screenSharingActive
        width: 16
        height: 24

        Rectangle {
            width: 6
            height: 6
            radius: 3
            color: Theme.danger
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        SvgIcon {
            source: Qt.resolvedUrl("../assets/icons/screenshare.svg")
            size: 16
            color: Theme.danger
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
