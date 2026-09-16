import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "../core"
import "."

Item {
    id: root

    // =========================================================
    // Hyprland
    // =========================================================

    Connections {
        enabled: CompositorService.isHyprland
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "workspace") {
                var workspace = event.data

                StatusManager.show({
                    mode: "workspace",
                    icon: "󰍹",
                    title: workspace,
                    value: Number(workspace),
                    statusWidth: 200,
                    statusHeight: 33
                })
            }
        }
    }

    // =========================================================
    // Niri (niri msg --json event-stream)
    // =========================================================

    // Niri workspace ids are stable but opaque; idx is the
    // per-output position shown to the user. The event stream
    // sends the full list up-front (and on every change), so we
    // keep a map to resolve WorkspaceActivated ids to idx/name.
    property var workspaceById: ({})

    function showNiriWorkspace(id) {
        var info = workspaceById[id]

        if (!info)
            return

        var label = info.name || String(info.idx)

        StatusManager.show({
            mode: "workspace",
            icon: "󰍹",
            title: label,
            value: info.idx,
            statusWidth: 200,
            statusHeight: 33
        })
    }

    function handleNiriEvent(line) {
        var text = line.trim()

        if (text.length === 0)
            return

        var event = null

        try {
            event = JSON.parse(text)
        } catch (err) {
            return
        }

        if (event.WorkspacesChanged) {
            var workspaces = event.WorkspacesChanged.workspaces || []
            var map = {}

            for (var i = 0; i < workspaces.length; ++i) {
                var ws = workspaces[i]
                map[ws.id] = {
                    idx: ws.idx,
                    name: ws.name
                }
            }

            workspaceById = map
        } else if (event.WorkspaceActivated) {
            // Only announce the newly focused workspace, not the
            // one that just lost focus.
            if (event.WorkspaceActivated.focused)
                showNiriWorkspace(event.WorkspaceActivated.id)
        }
    }

    Process {
        id: niriEventStream
        running: CompositorService.isNiri
        command: ["niri", "msg", "--json", "event-stream"]

        stdout: SplitParser {
            splitMarker: "\n"

            onRead: function(line) {
                root.handleNiriEvent(line)
            }
        }

        onExited: {
            // Socket dropped (e.g. compositor restarted) — reconnect.
            if (CompositorService.isNiri)
                reconnectTimer.restart()
        }
    }

    Timer {
        id: reconnectTimer
        interval: 2000
        repeat: false

        onTriggered: {
            niriEventStream.running = false
            niriEventStream.running = true
        }
    }
}
