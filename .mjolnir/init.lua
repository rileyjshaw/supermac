local griderr, grid  = pcall(function() return require "mjolnir.bg.grid" end)
local windowerr, window = pcall(function() return require "mjolnir.window" end)
local hotkeyerr, hotkey = pcall(function() return require "mjolnir.hotkey" end)
local alerterr, alert = pcall(function() return require "mjolnir.alert" end)
local fnutilserr, fnutils = pcall(function() return require "mjolnir.fnutils" end)

function print_if_not_table(var)
  if not(type(var) == "table") then print(var) end
end

if not griderr or not windowerr or not hotkeyerr or not alerterr then
  mjolnir.showerror("Some packages appear to be missing.")
  print("At least one package was missing. Have you installed the packages? See README.md.")
  print_if_not_table(grid)
  print_if_not_table(window)
  print_if_not_table(hotkey)
  print_if_not_table(alert)
  print_if_not_table(fnutils)
end

mash = {"cmd", "alt", "ctrl"}
MARGIN = 2
GRIDWIDTH = 12
GRIDHEIGHT = 9

grid.MARGINX = MARGIN
grid.MARGINY = MARGIN

-- ternary if
function tif(cond, a, b)
  if cond then return a else return b end
end

function reset_granularity()
  grid.GRIDWIDTH = GRIDWIDTH
  grid.GRIDHEIGHT = GRIDHEIGHT
end

reset_granularity()

function change_granularity(iswidth, del)
  if iswidth then
    grid.GRIDWIDTH = grid.GRIDWIDTH + del
  else
    grid.GRIDHEIGHT = grid.GRIDHEIGHT + del
  end

  alert.show(tif(iswidth, grid.GRIDWIDTH, grid.GRIDHEIGHT))
end

function centerpoint()
  w = grid.GRIDWIDTH - 2
  h = grid.GRIDHEIGHT - 2
  return { x = 1, y = 1, w = w, h = h }
end

function fullheightatcolumn(column)
  return { x = column - 1, y = 0, w = 1, h = grid.GRIDHEIGHT }
end

function ifwin(fn)
  return function()
    local win = window.focusedwindow()
    if win then fn(win) end
  end
end

local grid_shortcuts = {
  R = mjolnir.reload,
  [";"] = ifwin(grid.snap),
  up = ifwin(grid.pushwindow_up),
  left = ifwin(grid.pushwindow_left),
  right = ifwin(grid.pushwindow_right),
  down = ifwin(grid.pushwindow_down),
  A = ifwin(grid.resizewindow_thinner),
  D = ifwin(grid.resizewindow_wider),
  W = ifwin(grid.resizewindow_shorter),
  S = ifwin(grid.resizewindow_taller),
  space = ifwin(grid.maximize_window),
  F = ifwin(grid.pushwindow_nextscreen),
  C = ifwin(function(win) grid.set(win, centerpoint(), win:screen()) end),
  H = function() change_granularity(true, 1) end,
  J = function() change_granularity(false, 1) end,
  K = function() change_granularity(false, -1) end,
  L = function() change_granularity(true, -1) end,
  ["1"] = ifwin(function(win) grid.set(win, fullheightatcolumn(1), win:screen()) end),
  ["2"] = ifwin(function(win) grid.set(win, fullheightatcolumn(2), win:screen()) end),
  ["3"] = ifwin(function(win) grid.set(win, fullheightatcolumn(3), win:screen()) end),
  ["4"] = ifwin(function(win) grid.set(win, fullheightatcolumn(4), win:screen()) end),
  ["0"] = function() reset_granularity() alert.show(GRIDWIDTH..", "..GRIDHEIGHT) end
}

for key, func in pairs(grid_shortcuts) do
  hotkey.bind(mash, key, func)
end

alert.show(" 🎩\n 💀")
