'Terminal "MOE" - moe10.bas
'(C) Mike Sunners, 8 January 2023
'    All Rights Reserved

Option Explicit
Option Autorun on
Option F8 "" ' switch ports
Option F9 "" ' send ctrl-C to port

Sub mm.prompt
  Print Chr$(27) + "[4mmoe" + Chr$(27) + "[m> ";
End Sub

End