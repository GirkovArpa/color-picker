global clicking := false
;WinSet, Region, 50-0 W200 H250 E, color.ahk

Gui, Add, Button, x30 y130 w100 h20 , Click && Hold
Gui, Add, GroupBox, x30 y24 w100 h107 , 
Gui, Add, Edit, x32 y4 w96 h20 right, Edit
for i in [1, 2, 3] {
  for j in [1, 2, 3] {
    X := i * 32
    Y := j * 32
    Gui, Add, Progress, x%X% y%Y% w32 h32 cGreen vMyProgress%i%_%j%, 100
  }
}
Gui, Show, x381 y170 h379 w483, 

SetTimer, myLoop, 10

myLoop(){
  if (not clicking) 
    return
  for i in [1, 2, 3] {
    for j in [1, 2, 3] {
      MouseGetPos, MouseX, MouseY
      MouseX += i
      MouseY += j
      PixelGetColor, color, %MouseX%, %MouseY%, RGB
      GuiControl +C%color%, MyProgress%i%_%j%
      if (i = 2 and j = 2) {
        color := StrReplace(color, "0x", "#")
        GuiControl, Text, Edit1, %color%
        clipboard := "" color
      }
    }
  }
}

LButton Up::
  clicking := false
  return

~LButton::
  MouseGetPos, , , , OutputVarControl
  if (OutputVarControl = "Button1")
    clicking := true
  return

