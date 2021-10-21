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
		set winp to get position of mainWin
		set wins to get size of mainWin
		set oWinY to item 2 of winp
		set oWinH to item 2 of wins
		set oWinMaxY to oWinY + oWinH
		log "maxY:" & oWinMaxY
		
		set UIelm to UI elements of mainWin
		set UIelmCount to get count of UIelm
		if (UIelmCount > 11) then
			set repeatIndex to 0
			repeat with oneUIelm in UIelm
				set repeatIndex to repeatIndex + 1
				set oneUIelmCls to get class of oneUIelm as Unicode text
				if (oneUIelmCls = "splitter group") then
					--聊天列表,前一个元素即为添加好友按钮
					set addBtn to get item (repeatIndex - 1) of UIelm
					set positionxy to get the position of the addBtn
					set addX to item 1 of positionxy
					set addY to item 2 of positionxy
					log "add:" & addX & "," & addY
					
					--聊天列表
					
					set entirecontents to get entire contents of oneUIelm
					repeat with content in entirecontents
						set classname to get class of content as Unicode text
						if ("row" = classname or "static text" contains classname) then
							if ("row" = classname) then
								set positionxyRow to get the position of the content
								set Xcord to item 1 of positionxyRow
								set Ycord to item 2 of positionxyRow
								set sizec to get the size of the content
								set sizew to item 1 of sizec
								set sizeh to item 2 of sizec
								log "ps:" & Xcord & "," & Ycord & "," & sizew & "," & sizeh
							else
								log content
							end if
						end if
					end repeat
				end if
			end repeat
		end if
	end tell
end tell
