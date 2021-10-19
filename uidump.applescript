use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

tell application "QQ" to activate
tell application "System Events" to set frontmost of process "QQ" to true
tell application "System Events"
	tell application process "QQ"
		set winList to every window
		set oWin to item 2 of winList
		set entirecontents to get entire contents of oWin
		log "###each entirecontents"
		-- set theentirecontents to the length of entirecontents
		set repeatindex to -1
		repeat with content in entirecontents
			set repeatindex to repeatindex + 1
			--log repeatindex
			if (repeatindex = 80) then
				exit repeat
			end if
			log "#####################"
			set classname to get class of content
			log "classname:" & classname
			log content
			set positionxy to get the position of the content
			set Xcord to item 1 of positionxy
			set Ycord to item 2 of positionxy
			log "position:" & Xcord & "," & Ycord
			set sizec to get the size of the content
			set sizew to item 1 of sizec
			set sizeh to item 2 of sizec
			log "size:" & sizew & "," & sizeh
		end repeat
	end tell
end tell



on click_an_element (an_element)
    tell application "QQ" to activate
    tell application "System Events"
        tell application process "QQ"
            try
                click an_element
            end try
        end tell
    end tell
end click_an_element




--  tell application "System Events"
--	 -- 如果设置了自动登录，则只需模拟点击回车键（return）即可
--	 keystroke "password"
--	 keystroke return
-- end tell
