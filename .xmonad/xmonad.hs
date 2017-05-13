{-# LANGUAGE NoMonomorphismRestriction #-}

import XMonad
import XMonad.Actions.UpdatePointer
import XMonad.Actions.GridSelect
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Cursor
import XMonad.Util.SpawnOnce
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import Control.Monad
import Graphics.X11.ExtraTypes.XF86
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import System.IO

--variables
term = "termite"
myWorkspaces = ["1","2","3","4","5"]

--gridSelect config
--gsconfig2 colorizer = (buildDefaultGSConfig colorizer) { gs_cellheight = 50, gs_cellwidth = 120 }
--myColorizer = colorRangeFromClassName
--					  (0x2b,0xb4,0xda)	-- lowest inactive bg
--					  (0x69,0x44,0xda)	-- highest inactive bg
--					  black				-- active bg
--					  white				-- inactive fg
--					  white				-- active fg
--	 where black = minBound
--		 white = maxBound

myLogHook = fadeInactiveLogHook fadeAmount
	where fadeAmount = 0.8

myManageHook = composeAll [
	className =? "Firefox"								--> doShift "2",
	className =? "Java"									--> doShift "3",
	className =? "Eclipse"								--> doShift "3",
	className =? "krita"								--> doShift "3",
	className =? "inkscape"							--> doShift "3",
	className =? "Spotify"								--> doShift "4",
	className =? "Franz"								--> doShift "5",
	(className =? "Firefox" <&&> resource =? "Dialog")	--> doFloat,
	className =? "feh"									--> doFloat,
	isFullscreen										--> doFullFloat,
	manageDocks
	]

--config
conf = defaultConfig {
	manageHook	= myManageHook,
	layoutHook	= smartBorders . avoidStruts $ layoutHook defaultConfig,
	terminal = term,
	borderWidth = 1,
	focusFollowsMouse = False,
	workspaces = myWorkspaces,
	normalBorderColor = "#000000",
	focusedBorderColor = "#2bb4da"
	}

main = do
	xmonad $ conf {
		startupHook = startupHook conf 
			>> setWMName "LG3D"
			>> setDefaultCursor xC_left_ptr,
		modMask = mod4Mask,
		handleEventHook = fullscreenEventHook,
		logHook = dynamicLog
			>> updatePointer (0.5,0.5) (1,1)
			>> takeTopFocus
			>> spawnOnce "setxkbmap gb"
			>> myLogHook,
		manageHook = myManageHook <+> manageHook defaultConfig
		}`additionalKeys`[
			((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -e 'mv /home/chrootzius/.shots/'; notify-send \"Scrot\" \"Screenshot was taken\""),
			((0, xK_Print), spawn "scrot -e 'mv $f /home/chrootzius/.shots/'; notify-send \"Scrot\" \"Screenshot was taken\""),
			((mod4Mask, xK_p), spawn "shutter -f -o /home/chrootzius/.shots/%d%m%Y%T.png -C -n -e"),
			((mod4Mask,xK_P), spawn "shutter -s -o /home/chrootzius/.shots/%d%m%Y%T.png -C -n -e"),
			((mod4Mask, xK_d), spawn "rofi -config /home/chrootzius/.config/rofi/config -show run"),
--			((mod4Mask, xK_g), goToSelected $ gsconfig2 myColorizer),
			--media keys
			((0, xF86XK_AudioLowerVolume   ), spawn "amixer -q set Master 5%- unmute"),
			((0, xF86XK_AudioRaiseVolume   ), spawn "amixer -q set Master 5%+ unmute"),
			((0, xF86XK_AudioMute		   ), spawn "amixer -q set Master toggle"),
			((0, 0x1008ffb2    ), spawn "amixer -q set Capture toggle"),
			((0, xF86XK_AudioPrev	), spawn "playerctl previous"),
			((0, xF86XK_AudioNext	), spawn "playerctl next"),
			((0, xF86XK_AudioPlay	), spawn "playerctl play-pause"),
			((0, xF86XK_MonBrightnessUp ), spawn "xbacklight -inc 20"),
			((0, xF86XK_MonBrightnessDown ), spawn "xbacklight -dec 20"),
			((0, xF86XK_ScreenSaver  ), spawn "scrot 'lock.png' -q 1 -e 'mv $f /tmp/lock.png'; i3lock -I 1 -i /tmp/lock.png")
			]
