import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import System.IO
import Graphics.X11.ExtraTypes.XF86

main :: IO ()
main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/greg/.xmobarrc"
  xmonad $ defaultConfig
         { manageHook = manageDocks <+> manageHook defaultConfig
         , layoutHook = avoidStruts $ layoutHook defaultConfig
         , logHook = dynamicLogWithPP xmobarPP
                     { ppOutput = hPutStrLn xmproc
                     , ppTitle = xmobarColor "green" "" . shorten 50
                     }
         -- Use windows for mod to avoid conflict with emacs
         , modMask = mod4Mask
         } `additionalKeys`
         -- Mod-Shift-z locks the screen
         [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
         -- Ctrl-PrntScrn screenshots the current window
         , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
         -- PrntScrn screenshots the whole desktop
         , ((0, xK_Print), spawn "scrot")
         , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set 'Master' 2%+")
         , ((0, xF86XK_AudioLowerVolume), spawn "amixer set 'Master' 2%-")
         , ((0, xF86XK_AudioMute), spawn "amixer -D pulse set 'Master' toggle")
         ]
