'Terminal Switch - tsw14.bas
'(C) Mike Sunners, 14 January 2023
'    All Rights Reserved
'
' 11Jan23 - move interrupt rearming until keystroke processed
'         - tighten code around select
Option Explicit
Option Autorun on
Option F8 "" ' switch ports
Option F9 "" ' send ctrl-C to port

Sub mm.prompt
  Print "home> ";
End Sub

Print "Terminal Switch Ver 1.4"
Print "Copyright 2023 Mike Sunners"

SetPin GP21, GP20, COM2        ' default port
Open "COM2:115200, 1024" As #8 ' 1k receive buffer

Sub switch()
  Static id% = 0
  Close #8
  SetPin GP5, DIN
  SetPin GP4, DOUT
  SetPin GP9, DIN
  SetPin GP8, DOUT
  SetPin GP21, DIN
  SetPin GP20, DOUT

  Select Case id% Mod 3
  Case 0 : SetPin  GP5,  GP4, COM2 ':Print "<LARRY>"; ' test code 
  Case 1 : SetPin  GP9,  GP8, COM2 ':Print "<MOE>";
  Case 2 : SetPin GP21, GP20, COM2 ':Print "<CURLY>";
  End Select

  Inc id%
  Open "COM2:115200, 1024" As #8
End Sub

Dim inch%          ' single keyboard character
Dim keyflag% = 1   ' key interrupt initially armed

Sub check_key()    ' key ISR
  On key 0
  keyflag% = 1
End Sub

Do ' main loop
  If Loc(#8) <> 0 Then Print Input$(255, #8); ' receive
  If keyflag% = 1 Then  ' send
    keyflag% = 0
    inch% = Asc(Inkey$) ' get ASCII key value
    Select Case inch%
    Case 152 ' AVT F8
      switch()
    Case 153 ' AVT F9
      Print #8, Chr$(3);
    Case Else
      Print #8, Chr$(inch%);
    End Select
    On key check_key()  ' rearm
  EndIf ' send
Loop ' end of tsw14.bas