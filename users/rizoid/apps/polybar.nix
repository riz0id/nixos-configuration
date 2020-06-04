{ pkgs }:

''
[settings]
format-background = #161616
format-foreground = #f4f4f4
format-padding = 0
format-offset = 0
; throttle-output = 5
; throttle-output-for = 10
; throttle-input-for = 30
screenchange-reload = true
compositing-background = source
compositing-foreground = source
compositing-overline = source
compositing-underline = source
compositing-border = source
[global/wm]
margin-bottom = 1
margin-top = 1
[colors]
background = #00000000
foreground = #B5B5B5
foreground-alt = #B5B5B5
[section/base]
fixed-center = true
width = 1888
height = 30
offset-x = 16
offset-y = 4
border-size = 0
border-color = #00000000
background = #161616
foreground = #F4F4F4
font-0 = Source Code Pro:size=13:style=Regular;4
font-1 = Font Awesome 5 Free:size=13:style=Regular;4
font-2 = Font Awesome 5 Brands:size=13:style=Regular;4
font-3 = Material Icons:size=16:style=Regularc;6
padding = 1
module-margin = 1
; --------------------------------------------------------------------
[bar/top]
inherit = section/base
bottom = false
modules-left = cpu ram battery
modules-center = date
modules-right =
[bar/bottom]
inherit = section/base
bottom = true
modules-left =
modules-center = xworkspaces
modules-right = temperature
; --------------------------------------------------------------------
[module/date]
type = internal/date
interval = 1.0
date = %b, %d
time = %H:%M
label = %date% %time%
[module/xwindow]
type = internal/xwindow
[module/cpu]
type = internal/cpu
format =  <label>
label = %percentage:3%%
[module/ram]
type = internal/memory
format =  <label>
label = %percentage_used:3%%
[module/battery]
type = internal/battery
label-charging =  %percentage:3%%
label-discharging =  %percentage:3%%
[module/xworkspaces]
type = internal/xworkspaces
pin-workspaces = false
enable-click = false
enable-scroll = false
[module/temperature]
type = internal/temperature
interval = 0.5
; To list all the zone types, run
; $ for i in /sys/class/thermal/thermal_zone*; do echo "$i: $(<$i/type)"; done
thermal-zone = 0
base-temperature = 20
warn-temperature = 80

''
