use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

-- 一定要把 QQ 这个应用设置到 frontmost，也就是 focus 到当前的 app 窗口上
tell application "QQ" to activate
tell application "System Events" to set frontmost of process "QQ" to true

set output to ("开始执行")
do shell script "echo " & quoted form of output

set classNames to {}
tell application "System Events"
	tell application process "QQ"
		set winList to every window
		set oWin to item 2 of winList
		set entirecontents to get entire contents of oWin
		log "###each entirecontents"
		-- set theentirecontents to the length of entirecontents
		repeat with content in entirecontents
			log content
			set classname to get class of content
			log "classname:" & classname
			set contenttext to get name of conetnt
			log contenttext
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
	tell front window of (first application process whose frontmost is true)
		repeat with uiElem in entire contents as list
			set classNames to classNames & (class of uiElem as string)
		end repeat
	end tell
end tell


--  tell application "System Events"
--	 -- 如果设置了自动登录，则只需模拟点击回车键（return）即可
--	 keystroke "password"
--	 keystroke return
-- end tell
