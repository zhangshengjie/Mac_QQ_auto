use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

do shell script "open /Applications/QQ.app"
tell application "QQ" to activate
tell application "System Events" to set frontmost of process "QQ" to true
tell application "System Events"
	tell application process "QQ"
	--delay 1
	key down command
	keystroke "w"
	key up command
	--delay 1
	key down command
	keystroke "w"
	key up command
	end tell
end tell

do shell script "open /Applications/QQ.app"