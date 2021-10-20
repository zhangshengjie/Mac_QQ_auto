use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

tell application "QQ" to activate
tell application "System Events" to set frontmost of process "QQ" to true
tell application "System Events"
	tell application process "QQ"
		set winList to every window
		repeat with wind in winList
			set num to count of UI elements of wind
			log num
			if (num = 8) then
				--?????
				set windentirecontents to get entire contents of wind
				repeat with winitem in windentirecontents
					set positionxy to get the position of the winitem
					set sizec to get the size of the winitem
					log winitem
					log positionxy
					log sizec
				end repeat
			end if
			
		end repeat
		-- repeat with wind in winList
		-- 	set num to count of UI elements of wind
		-- 	if (num = 8 or num = 9) then
		-- 		set windentirecontents to get entire contents of wind
		-- 		set windentirecontentsCount to get count of windentirecontents
		-- 		if (windentirecontentsCount > 10) then
		-- 			set inputBox to item 4 of windentirecontents
		-- 			set winp to get position of inputBox
		-- 			set oWinX to item 1 of winp
		-- 			set oWinY to item 2 of winp
		-- 			perform action "AXRaise" of wind
		-- 			log "ps," & oWinX & "," & oWinY
		-- 		end if
		-- 	end if
		-- end repeat
	end tell
end tell
