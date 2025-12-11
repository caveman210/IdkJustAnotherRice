import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { execAsync } from "ags/process"
import { createPoll } from "ags/time"
import { BatteryService } from "./modules/battery/index"

export default function Bar(gdkmonitor: Gdk.Monitor) {
	const time = createPoll("", 1000, "date")
	const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

	return (
		<window
			visible
			name="bar"
			class="Bar"
			gdkmonitor={gdkmonitor}
			exclusivity={Astal.Exclusivity.EXCLUSIVE}
			anchor={TOP | LEFT | RIGHT}
			application={app}
		>
			<centerbox cssName="centerbox">
				<box $type="start">
					<button
						$type="start"
						onClicked={() => execAsync("sherlock")}
						hexpand
						halign={Gtk.Align.CENTER}
					>
						<label label="Launcher" />
					</button>
				</box>
				<box $type="center" />
				<menubutton $type="center" hexpand halign={Gtk.Align.CENTER}>
					<label label={time} />
					<popover>
						<Gtk.Calendar />
					</popover>
				</menubutton>
				<box $type="end" >
					<BatteryService />
				</box>
				{ /*
				<box $type="end" >
					<BrightnessService />
				</box>
				*/}
			</centerbox>
		</window>
	)
}
