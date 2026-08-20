package main

//go:generate goversioninfo -icon=app.ico -manifest=app.manifest -o resource.syso

import (
	"golang.org/x/sys/windows"
)

var buildVersion string

func main() {
	title := "Hello" + " v" + buildVersion
	text := "Hello from Go!"

	windows.MessageBox(
		0,
		windows.StringToUTF16Ptr(text),
		windows.StringToUTF16Ptr(title),
		windows.MB_OK|windows.MB_ICONINFORMATION,
	)
}
