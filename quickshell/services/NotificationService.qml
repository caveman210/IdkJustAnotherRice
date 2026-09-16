pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
    id: root
    property ListModel history: ListModel {}
    property int unreadCount: 0
    property url defaultIcon: "../assets/icons/bell.svg"

    function getAppIcon(notification) {
        let icon = notification.appIcon

        if (icon && icon !== "")
            return icon

        return root.defaultIcon
    }

    NotificationServer {
        id: server
        keepOnReload: true

        onNotification: function(notification) {
            notification.tracked = true

            let icon = root.getAppIcon(notification)

            let image = notification.image

            root.history.insert(0, {
                app: notification.appName,
                summary: notification.summary,
                body: notification.body,
                icon: icon,
                image: image,
                time: new Date().toLocaleTimeString()
            })

            root.unreadCount++

            console.log(
                "Notification:",
                notification.summary
            )

            console.log(
                "App:",
                notification.appName
            )

            console.log(
                "App icon:",
                icon
            )

            console.log(
                "Notification image:",
                image
            )

            console.log(
                "Desktop entry:",
                notification.desktopEntry
            )

            console.log(
                "Last generation:",
                notification.lastGeneration
            )
        }
    }

    Process {
        id: sendProcess

        onExited: function(exitCode, exitStatus) {
            if (exitCode !== 0) {
                console.log(
                    "Failed to send notification. Exit code:",
                    exitCode
                )
            }
        }
    }

    function send(app, summary, body) {
        sendProcess.running = false

        sendProcess.command = [
            "notify-send",
            "--app-name", app,
            summary,
            body
        ]

        console.log(
            "Sending notification:",
            app,
            summary,
            body
        )

        sendProcess.running = true
    }

    function clear() {
        history.clear()

        unreadCount = 0
    }

    function remove(index) {
        if (
            index >= 0 &&
            index < history.count
        ) {
            history.remove(index, 1)
        }
    }

    function markRead() {
        unreadCount = 0
    }

    Component.onCompleted: {
        console.log(
            "NotificationService loaded"
        )
    }
}
