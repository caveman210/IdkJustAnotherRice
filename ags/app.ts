import app from "ags/gtk4/app"
import Bar from "./widget/bar/Bar"

app.start({
	css: "./widget/bar/bar.scss",
	main() {
		app.get_monitors().map(Bar)
	},
})
