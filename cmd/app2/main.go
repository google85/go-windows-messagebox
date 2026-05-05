package main

//go:generate goversioninfo -icon=app.ico -manifest=app.manifest -o resource.syso

import (
	"golang.org/x/sys/windows"
)

var buildVersion string

func main() {
	windows.MessageBox(
		0,
		windows.StringToUTF16Ptr("Hello from Go!"),
		windows.StringToUTF16Ptr("Hello"),
		windows.MB_OK|windows.MB_ICONINFORMATION,
	)
}
