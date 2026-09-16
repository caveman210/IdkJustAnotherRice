import QtQuick

import "../styles"

Rectangle {
    id: root
    clip: true
    radius: Theme.capsuleRadius
    color: Theme.background
    width: implicitWidth
    height: implicitHeight
    implicitWidth: viewHost.implicitWidth
    implicitHeight: viewHost.implicitHeight

    Behavior on implicitWidth {
        NumberAnimation {
            duration: Theme.animationNormal
            easing.type: Theme.animationHorizontal
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Theme.animationNormal
            easing.type: Theme.animationVertical
        }
    }

    HoverHandler {
        id: islandHover

        onHoveredChanged: {
            islandInteraction.handleHoverChanged(hovered)
        }
    }

    IslandInteraction {
        id: islandInteraction
        anchors.fill: parent
    }

    ViewHost {
        id: viewHost
        anchors.centerIn: parent
    }
}
