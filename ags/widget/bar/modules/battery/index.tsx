import AstalBattery from "gi://AstalBattery"
import { Gtk } from "ags/gtk4"
import { createBinding } from "ags"
import { getBatteryIcon } from "./types"
import AstalIO from "gi://AstalIO?version=0.1"

export function BatteryService() {
	const batt = AstalBattery.get_default();
	//const timer = AstalIO.Time.interval(
	const per_val = createBinding(batt, "percentage").as((p: number) => Math.floor(p * 100));
	const isCharging = createBinding(batt, "state").as((s: number) => s === AstalBattery.State.CHARGING);
	const isFull = createBinding(batt, "state").as((s: number) => s === AstalBattery.State.FULLY_CHARGED);

	const icon = per_val.as(p =>
		isCharging.as(charging =>
			isFull.as(full =>
				getBatteryIcon(p, charging, full)
			)()
		)()
	);

	return (
		<menubutton visible={createBinding(batt, "deviceType").as((t: number) => t === AstalBattery.Type.BATTERY)} $type="center" hexpand halign={Gtk.Align.CENTER}>
			<box>
				<label label={icon} />
				<label label={per_val.as(v => `${v}%`)} />
			</box>
		</menubutton>
	);
}
