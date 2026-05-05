package main

import (
	"syscall"
	"unsafe"
)

var buildVersion string

func main() {
	user32 := syscall.NewLazyDLL("user32.dll")
	messageBox := user32.NewProc("MessageBoxW")

	title, _ := syscall.UTF16PtrFromString("Hello")
	text, _ := syscall.UTF16PtrFromString("Hello from Go!")

	messageBox.Call(
		0, // hWnd (no parent)
		uintptr(unsafe.Pointer(text)),
		uintptr(unsafe.Pointer(title)),
		0, // MB_OK
	)
}
