use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

tell application "QQ" to activate
tell application "System Events" to set frontmost of process "QQ" to true
tell application "System Events"
	tell application process "QQ"
		set winList to every window
		repeat with wind in winList
			set num to count of UI elements of wind
			if (num = 8) then
				--?????
				--???????? static text ="???" ?????button
				--???????? static text ="???" ????? static text ="??"
				set contactIndex to -1
				set indexTmp to -1
				set btnTmpIndex to -1
				set windentirecontents to get entire contents of wind
				repeat with winitem in windentirecontents
					set classname to get class of winitem
					set indexTmp to indexTmp + 1
					if (classname = "static text") then
						set txt to get name of winitem
						if (txt = "???") then
							log "find ???"
							set contactIndex to indexTmp
						else if (txt = "??") then
							log "find ?? ??"
							set contactIndex to -1
							exit repeat
						end if
					else if (classname = "button") then
						if (contactIndex > 0) then
							set btnTmpIndex to btnTmpIndex+1
							if (btnTmpIndex=2) then
								set positionxy to get the position of the winitem
								set Xcord to item 1 of positionxy
								set Ycord to item 2 of positionxy
								set sizec to get the size of the winitem
								set sizew to item 1 of sizec
								set sizeh to item 2 of sizec
								log "ps," & Xcord & "," & Ycord & "," & sizew & "," & sizeh
								exit repeat
							end if
						end if
					else
						--your code
					end if
				end repeat
				 
			end if
			
		end repeat
	end tell
end tell
