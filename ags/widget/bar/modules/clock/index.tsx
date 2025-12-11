import { Gtk } from "ags/gtk4"
import { createPoll } from "ags/time"

export function ClockService() {
    const time = createPoll("", 1000, "date '+%H:%M (%A, %b %d, %Y)'")

    return (
        <Gtk.MenuButton hexpand halign={Gtk.Align.CENTER}>
            <Gtk.Label label={time} />
            <Gtk.Popover>
                <Gtk.Calendar />
            </Gtk.Popover>
        </Gtk.MenuButton>
    )
}
