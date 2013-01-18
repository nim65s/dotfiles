--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.AppLauncher as AL
import XMonad.Prompt.Shell (getBrowser)
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout
import XMonad.Layout.NoBorders
import System.IO
import Data.Monoid
import Data.String
import Data.List
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Core
import XMonad.Util.Run

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "terminator"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ffff00"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm , xK_Return             ), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_t     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_s     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_t     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_s     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_c     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_r     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_f     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_v ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_l), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Toggle borders on the focused window
    , ((modm .|. shiftMask, xK_b     ), withFocused toggleBorder)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- prev/next WS
    , ((modm,               xK_Left  ),  moveTo Prev HiddenWS )
    , ((modm,               xK_Right ),  moveTo Next HiddenWS )
    , ((modm,               xK_Down  ),  moveTo Prev EmptyWS  )
    , ((modm,               xK_Up    ),  moveTo Next EmptyWS  )
    , ((modm .|. shiftMask, xK_Left  ),  shiftTo Prev HiddenWS)
    , ((modm .|. shiftMask, xK_Right ),  shiftTo Next HiddenWS)
    , ((modm .|. shiftMask, xK_Down  ),  shiftTo Prev EmptyWS )
    , ((modm .|. shiftMask, xK_Up    ),  shiftTo Next EmptyWS )

    -- toggle WS
    , ((modm,               xK_Escape),  toggleWS )

    -- AppLauncher
    , ((modm .|. shiftMask, xK_j     ), AL.launchApp nimXPConfig "chromium" )
    , ((modm              , xK_w     ), wikiPrompt nimXPConfig )
    , ((modm              , xK_a     ), archPrompt nimXPConfig )
    , ((modm              , xK_g     ), googlePrompt nimXPConfig )
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{é,p,o}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{é,p,o}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_eacute, xK_p, xK_o] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = smartBorders tiled ||| Mirror tiled ||| noBorders Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/3

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"            --> doFloat
    , className =? "Gimp"               --> doFloat
    , className =? "feh"                --> doFloat
    , className =? "x11-ssh-askpass"    --> doFloat
    , className =? "spotify"            --> doShift "2"
    , className =? "chromium"           --> doShift "3"
    , resource  =? "desktop_window"     --> doIgnore
    , resource  =? "kdesktop"           --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ ewmh defaults
        { manageHook = manageDocks <+> manageHook defaultConfig
        , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
        , layoutHook = lessBorders OnlyFloat $ avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppSep = " − "
            , ppWsSep = ""
            , ppTitle = xmobarColor "green" ""
            , ppCurrent = xmobarColor "green" ""
            , ppVisible = xmobarColor "yellow" ""
            , ppHidden = xmobarColor "white" ""
            , ppHiddenNoWindows = xmobarColor "black" ""
            }
        }

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- Prompts
nimXPConfig = defaultXPConfig
    { font = "xft:SourceCodePro-Regular:pixelsize=13"
    , bgColor = "black"
    , fgColor = "green"
    , fgHLight = "yellow"
    , bgHLight = "blue"
    , borderColor = "black"
    , promptBorderWidth = 0
    , position = Top
    , height = 15
    , historySize = 10
    }

wikiPrompt :: XPConfig -> X ()
wikiPrompt c = nimPrompt c "Wikipedia" "http://fr.wikipedia.org/w/index.php?title=Sp%C3%A9cial:Recherche&search="

archPrompt :: XPConfig -> X ()
archPrompt c = nimPrompt c "Archlinux" "https://wiki.archlinux.org/index.php?search="

googlePrompt :: XPConfig -> X ()
googlePrompt c = nimPrompt c "Google" "http://www.google.com/search?q="

nimPrompt :: XPConfig -> String -> String -> X ()
nimPrompt c text url =
    inputPrompt c text ?+ \query ->
    safeSpawn "chromium" [url ++ replace " " "+" query] -- TODO: getBrowser
        >> return ()

-- Next comes from http://hackage.haskell.org/packages/archive/MissingH/1.0.0/doc/html/Data-String-Utils.html to get replace function…
--
--  −− I’m dirty and I know it \o/ −−
--

replace :: Eq a => [a] -> [a] -> [a] -> [a]
replace old new l = join new . split old $ l

split :: Eq a => [a] -> [a] -> [[a]]
split _ [] = []
split delim str =
    let (firstline, remainder) = breakList (isPrefixOf delim) str
        in
        firstline : case remainder of
                                   [] -> []
                                   x -> if x == delim
                                        then [] : []
                                        else split delim
                                                 (drop (length delim) x)

join :: [a] -> [[a]] -> [a]
join delim l = concat (intersperse delim l)

breakList :: ([a] -> Bool) -> [a] -> ([a], [a])
breakList func = spanList (not . func)

spanList :: ([a] -> Bool) -> [a] -> ([a], [a])

spanList _ [] = ([],[])
spanList func list@(x:xs) =
    if func list
       then (x:ys,zs)
       else ([],list)
    where (ys,zs) = spanList func xs
