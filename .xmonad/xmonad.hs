import XMonad
import Data.Monoid
import System.Exit

import XMonad.ManageHook

import XMonad.Actions.CopyWindow
import XMonad.Actions.WithAll
import XMonad.Actions.CycleWS
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves

import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Util.Run

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers

import XMonad.Layout.Renamed
import XMonad.Layout.Simplest
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Layout.WindowNavigation
import XMonad.Layout.SubLayouts
import XMonad.Layout.LimitWindows
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Gaps
import XMonad.Layout.IndependentScreens
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.NoBorders

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myTerminal = "alacritty"
myBrowser = "firefox"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth = 2

myModMask = mod4Mask

myWorkspaces = [" \xf269 ", " \xf120 ", " \xf121 ", " \xfb6e ", " \xf1bc ", " \xf11b ", " \xf108  "]

myNormalBorderColor  = "#3b4252"
myFocusedBorderColor = "#eceff4"

myKeys =
    [ ("M-<Return>", spawn myTerminal)
    , ("M-S-<Return>", spawn "dmenu_run -i -p \"Launch: \"")

    , ("M-b", spawn myBrowser)
    , ("M-r", spawn (myTerminal ++ " -e ranger"))
    , ("M-S-l", spawn "slock")
    , ("M-s", spawn (myTerminal ++ " -e spt"))
    , ("M-i", spawn "intellij-idea-ultimate-edition")
    , ("M-M1-h", spawn (myTerminal ++ " -e htop"))
    , ("M-S-s", spawn "$HOME/.xmonad/screenshot.sh")

    , ("M-C-r", spawn "xmonad --recompile")
    , ("M-S-r", spawn "xmonad --restart")
    , ("M-S-q", io exitSuccess)

    , ("M-S-c", kill1)
    , ("M-S-a", killAll)

    , ("M-S-t", sendMessage ToggleLayout)

    , ("M-.", nextScreen)

    , ("M-f", sendMessage (XMonad.Layout.ToggleLayouts.Toggle "floats"))
    , ("M-t", withFocused $ windows . W.sink)
    , ("M-S-t", sinkAll)

    , ("M-m", windows W.focusMaster)
    , ("M-j", windows W.focusDown)
    , ("M-k", windows W.focusUp)
    , ("M-S-m", windows W.swapMaster)
    , ("M-S-j", windows W.swapDown)
    , ("M-S-k", windows W.swapUp)
    , ("M-<Backspace>", promote)
    , ("M-S-<Tab>", rotSlavesDown)
    , ("M-C-<Tab>", rotAllDown)

    , ("M-<Tab>", sendMessage NextLayout)
    , ("M-<Space>", sendMessage (XMonad.Layout.MultiToggle.Toggle NBFULL) >> sendMessage ToggleStruts)

    , ("M-h", sendMessage Shrink)
    , ("M-l", sendMessage Expand)
    , ("M-M1-j", sendMessage MirrorShrink)
    , ("M-M1-k", sendMessage MirrorExpand)

    , ("<XF86AudioPlay>", spawn "spt playback --toggle")
    , ("<XF86AudioPrev>", spawn "spt playback --previous")
    , ("<XF86AudioNext>", spawn "spt playback --next")
    , ("<XF86AudioStop>", spawn "systemctl stop --user spotifyd.service; sleep 1; systemctl start --user spotifyd.service")
    , ("<XF86AudioMute>", spawn "amixer set Master toggle")
    , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
    , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
    ]

myKeys2 conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm .|. shiftMask, xK_Return), spawn myTerminal)
    , ((modm .|. controlMask, xK_r), spawn "xmonad --recompile")
    , ((modm .|. shiftMask, xK_r), spawn "xmonad --restart")
    , ((modm .|. shiftMask, xK_q), io exitSuccess)

    , ((modm, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm .|. shiftMask, xK_Return), spawn "dmenu_run -i -p \"Launch: \"")

    , ((modm, xK_b), spawn myBrowser)
    , ((modm, xK_s), spawn (myTerminal ++ " -e spt"))
    , ((modm, xK_i), spawn "intellij-idea-ultimate-edition")
    , ((modm .|. mod1Mask, xK_h), spawn (myTerminal ++ " -e htop"))

    , ((modm .|. shiftMask, xK_c), kill1)
    , ((modm .|. shiftMask, xK_a), killAll)

    , ((modm .|. shiftMask, xK_t), sendMessage ToggleLayout)

    , ((modm, xK_period), nextScreen)

    , ((modm, xK_m), windows W.focusMaster)
    , ((modm, xK_j), windows W.focusDown)
    , ((modm, xK_k), windows W.focusUp)
    , ((modm .|. shiftMask, xK_m), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_j), windows W.swapDown)
    , ((modm .|. shiftMask, xK_k), windows W.swapUp)
    , ((modm, xK_BackSpace), promote)
    , ((modm .|. shiftMask, xK_Tab), rotSlavesDown)
    , ((modm .|. controlMask, xK_Tab), rotAllDown)

    ]
    ++

    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))
    ]

mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

tall = renamed [Replace "tall"]
       $ smartBorders
       $ windowNavigation
       $ subLayout [] (smartBorders Simplest)
       $ limitWindows 12
       $ mySpacing 5
       $ ResizableTall 1 (3/100) (1/2) []

floats = renamed [Replace "floats"]
         $ smartBorders
         $ limitWindows 20 simplestFloat

myLayoutHook = avoidStruts $ toggleLayouts floats $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
    where
    myDefaultLayout = withBorder myBorderWidth tall
                      ||| floats

myManageHook = composeAll
    [ className =? "confirm" --> doFloat
    , className =? "download" --> doFloat
    , className =? "error" --> doFloat
    , className =? "notification" --> doFloat
    , title =? "Discord" --> doShift ( myWorkspaces !! 3 )
    , title =? "Mozilla Firefox" --> doShift ( myWorkspaces !! 0 )
    , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat
    , isFullscreen -->  doFullFloat
    ]

myLogHook = return ()

myStartupHook = do
    spawnOnce "picom &"
    spawnOnce "~/.fehbg &"
    spawnOnce "discord-ptb &"

main = do

    xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc0"
    xmproc1 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc1"

    xmonad $ docks def {
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

        layoutHook         = myLayoutHook,
        manageHook         = myManageHook,
        handleEventHook    = handleEventHook def <+> docksEventHook,
        logHook            = myLogHook <+> dynamicLogWithPP xmobarPP
                               { ppCurrent = xmobarColor "#88c0d0" ""
                               , ppVisible = xmobarColor "#4c566a" ""
                               , ppHidden = xmobarColor "#434c5e" ""
                               , ppHiddenNoWindows = xmobarColor "#3b4252" ""
                               , ppUrgent = xmobarColor "#bf616a" ""
                               , ppSep = "   "
                               , ppWsSep = "  "
                               , ppTitle = xmobarColor "#88c0d0" "" . shorten 60
                               , ppOrder = \(ws:_:t:_) -> [ws,t]
                               , ppOutput = \x -> hPutStrLn xmproc0 x  >> hPutStrLn xmproc1 x
                               },
        startupHook        = myStartupHook
    } `additionalKeysP` myKeys
