import QtQuick
import QtQuick.Effects

import "../styles"

Item {
    id: root
    property url source: ""
    property color color: Theme.icon
    property int size: 20
    property int iconWidth: size
    property int iconHeight: size
    width: iconWidth
    height: iconHeight

    Image {
        id: image
        anchors.fill: parent
        source: root.source
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
        visible: false
    }

    MultiEffect {
        anchors.fill: image
        source: image
        colorization: 1.0
        colorizationColor: root.color
    }
}
