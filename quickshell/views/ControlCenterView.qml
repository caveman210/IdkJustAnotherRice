import QtQuick
import QtQuick.Layouts

import "../styles"
import "../components"
import "../core"
import "../views"
import "../services"

Item {
    id: root
    clip: true
    property Item wifiSvc
    implicitWidth: 520
    implicitHeight: 530

    // The user is looking at their notifications — clear the badge.
    Component.onCompleted: NotificationService.markRead()

    BatteryService {
        id: batteryService
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 18

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: "Control Center"
                color: Theme.textPrimary
                font.pixelSize: 20
                font.bold: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }

            Row {
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                spacing: 6

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: batteryService ? batteryService.icon : "󰁺"
                    color: Theme.icon
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: batteryService ? batteryService.percentage + "%" : "--%"
                    color: Theme.textPrimary
                    font.pixelSize: 14
                }
            }
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 3
            columnSpacing: 12
            rowSpacing: 12

            ControlCard {
                iconSource: WifiService.svgIcon
                title: "Wi-Fi"
                subtitle: WifiService.subtitle
                active: WifiService.connected
                onClicked: WifiService.toggle()
            }

            ControlCard {
                iconSource: BluetoothService.icon
                title: "Bluetooth"
                subtitle: BluetoothService.subtitle
                active: BluetoothService.enabled
                onClicked: BluetoothService.toggle()
            }

            ControlCard {
                iconSource: MicrophoneService.icon
                title: "Microphone"
                subtitle: MicrophoneService.subtitle
                active: !MicrophoneService.muted
                onClicked: MicrophoneService.toggle()
            }

            ControlCard {
                visible: NightLightService.available
                iconSource: NightLightService.icon
                title: "Night Light"
                subtitle: NightLightService.subtitle
                active: NightLightService.enabled
                onClicked: NightLightService.toggle()
            }

            ControlCard {
                iconSource: FocusService.icon
                title: "Focus"
                subtitle: FocusService.subtitle
                active: FocusService.enabled
                onClicked: FocusService.toggle()
            }

            ControlCard {
                iconSource: MediaService.icon
                title: "Media"
                subtitle: MediaService.subtitle
                active: MediaService.hasPlayer

                onClicked: {
                    IslandController.openMediaControls()
                }
            }
        }

        ControlSlider {
            iconSource: AudioService.volumeIcon
            value: AudioService.volume / 100

            onIconClicked: AudioService.toggleMute()

            onValueChangedByUser: function(value) {
                AudioService.setVolume(
                    value * 100
                )
            }
        }

        ControlSlider {
            iconSource: BrightnessService.brightnessIcon
            value: BrightnessService.brightness / 100

            onValueChangedByUser: function(value) {
                BrightnessService.setBrightness(
                    value * 100
                )
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 14
            color: Theme.surface
            clip: true

            NotificationView {
                anchors.fill: parent
                anchors.margins: 14
            }
        }
    }
}
