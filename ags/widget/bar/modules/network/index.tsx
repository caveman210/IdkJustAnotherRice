import AstalNetwork from "gi://AstalNetwork";
import { Gtk } from "ags/gtk4";
import { createBinding } from "ags";
import Variable from "gi://AstalIO"
// need something to check for the icons?

const networkCaller = AstalNetwork.Network.get_default()
const netService = createBinding(networkCaller,)
