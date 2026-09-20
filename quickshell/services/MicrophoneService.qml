pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property bool muted: false
    property url icon:
        muted
            ? "../assets/icons/microphone-off.svg"
            : "../assets/icons/microphone.svg"
    property string subtitle:
        muted
            ? "Muted"
            : "Enabled"

    Process {
        id: micReader
        command: [
            "wpctl",
            "get-volume",
            "@DEFAULT_AUDIO_SOURCE@"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                let output = text.trim()

                root.muted = output.indexOf("[MUTED]") !== -1
            }
        }
    }

    Process {
        id: micToggle
        command: [
            "wpctl",
            "set-mute",
            "@DEFAULT_AUDIO_SOURCE@",
            "toggle"
        ]

        onExited: {
            refreshTimer.restart()
        }
    }

    // Relaxed 10s safety poll (was 1s). Mute state is refreshed
    // immediately after every local toggle via refreshTimer.
    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: update()
    }

    Timer {
        id: refreshTimer
        interval: 250
        repeat: false
        onTriggered: update()
    }

    function update() {
        micReader.running = false
        micReader.running = true
    }

    function toggle() {
        micToggle.running = false
        micToggle.running = true
    }

    Component.onCompleted: update()
}
