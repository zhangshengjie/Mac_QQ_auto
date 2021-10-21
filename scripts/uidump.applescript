use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

tell application "QQ" to activate
tell application "System Events" to set frontmost of process "QQ" to true
tell application "System Events"
	tell application process "QQ"
		--按键esc
		key code 53
		
		set winList to every window
		
		set winListLen to get count of winList
		log winListLen
		set mainWin to item winListLen of winList
		--set oWin to item 1 of winList
		--repeat with itWin in winList
		--	set num to count of UI elements of itWin
		--	log num
		--	if (num = 16) then
		--		perform action "AXRaise" of itWin
		--		set mainWin to itWin
		--		log mainWin
		--		exit repeat
		--	end if
		--end repeat
		
		set windentirecontents to get entire contents of mainWin
		set contentsLen to get count of windentirecontents
		log contentsLen
		set addBtn to get item 10 of windentirecontents
		set positionxy to get the position of the addBtn
		set addX to item 1 of positionxy
		set addY to item 2 of positionxy
		log "add:" & addX & "," & addY
		
		set winp to get position of mainWin
		set wins to get size of mainWin
		set oWinY to item 2 of winp
		set oWinH to item 2 of wins
		set oWinMaxY to oWinY + oWinH
		log "maxY:" & oWinMaxY
		set entirecontents to get entire contents of mainWin
		set repeatindex to -1
		repeat with content in entirecontents
			set repeatindex to repeatindex + 1
			set classname to get class of content
			if ("row" contains classname or "static text" contains classname) then
				if ("row" contains classname) then
					set positionxy to get the position of the content
					set Xcord to item 1 of positionxy
					set Ycord to item 2 of positionxy
					set sizec to get the size of the content
					set sizew to item 1 of sizec
					set sizeh to item 2 of sizec
					log "ps," & Xcord & "," & Ycord & "," & sizew & "," & sizeh
				else
					log content
				end if
			end if
		end repeat
		
		
	end tell
end tell
