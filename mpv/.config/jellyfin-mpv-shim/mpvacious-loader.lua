local mpv_scripts_dir_path = os.getenv("HOME") ..  "/.config/mpv/scripts/"
package.path = package.path .. ';' .. os.getenv("HOME") .. '/.config/mpv/scripts/mpvacious/?.lua'
function load(relative_path) dofile(mpv_scripts_dir_path .. relative_path) end
load("mpvacious/subs2srs.lua")
