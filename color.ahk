#SingleInstance Force

Menu, Tray,  Icon, icon.ico

global clicking := false
global color := ""
global index := 0

IDC_ARROW := 32512
IDC_IBEAM := 32513
IDC_WAIT := 32514
IDC_CROSS := 32515
IDC_UPARROW := 32516
IDC_SIZE := 32640
IDC_ICON := 32641
IDC_SIZENWSE := 32642
IDC_SIZENESW := 32643
IDC_SIZEWE := 32644
IDC_SIZENS := 32645
IDC_SIZEALL := 32646
IDC_NO := 32648
IDC_HAND := 32649
IDC_APPSTARTING := 32650
IDC_HELP := 32651
;WinSet, Region, 50-0 W200 H250 E, color.ahk

;Colors := "red,green,blue"
;Loop, parse, Colors, `, 
;    MsgBox, Color number %A_Index% is %A_LoopField%.


Gui, Add, Button, x2 y130 w100 h20 , Click && Drag
Gui, Add, GroupBox, x2 y24 w100 h107 , 
Gui, Add, Edit, x2 y4 w96 h20 right vEdit1
for i in [0, 1, 2] {
  for j in [0, 1, 2] {
    X := (i * 32)
    Y := (j * 32)
    X -= 28
    Gui, Add, Progress, x%X% y%Y% w32 h32 cGreen vMyProgress%i%_%j%, 100
  }
}
Gui, Show, x381 y170 h154 w104, ColPik

Gui -MinimizeBox -Resize -MaximizeBox  ; Change the settings of the default GUI window.

SetTimer, myLoop, 10

myLoop() {
  if (not clicking) 
    return
  for i in [0, 1, 2] {
    for j in [0, 1, 2] {
      MouseGetPos, MouseX, MouseY
      MouseX += i
      MouseY += j
      PixelGetColor, color, %MouseX%, %MouseY%, RGB
      GuiControl +C%color%, MyProgress%i%_%j%
      if (i = 1 and j = 1) {
        color := StrReplace(color, "0x", "#")
        Tooltip, %color%
        GuiControl, Text, Edit1, %color%
        clipboard := "" color
      }
    }
  }
}

LButton Up::
  if (clicking) {
    Y := (index * 22) + 155
    GuiControlGet, Edit1
    Gui, Add, Edit, x3 y%Y% w76 h20 right, %Edit1%
    Edit1 := StrReplace(Edit1, "#", "0x")
    Gui, Add, Progress, x81 y%Y% w20 h20 c%Edit1% vTempMyProgress%index%, 100
    index += 1
    newHeight := 154 + (index * 23)
    Gui, Show, w104 h%newHeight%
  }
  clicking := false
  ToolTip
  SPI_SETCURSORS := 0x57
  DllCall("SystemParametersInfo", UInt, SPI_SETCURSORS, UInt, 0, UInt, 0, UInt, 0)
  return

~LButton::
  MouseGetPos, , , , OutputVarControl
  if (OutputVarControl = "Button1") {
    clicking := true
    CursorHandle := DllCall("LoadCursor", Uint, 0, Int, IDC_CROSS)
    Cursors = 32512,32513,32514,32515,32516,32640,32641,32642,32643,32644,32645,32646,32648,32649,32650,32651
    Loop, Parse, Cursors, `,
	    DllCall("SetSystemCursor", Uint, CursorHandle, Int, A_Loopfield)
  }
  return

