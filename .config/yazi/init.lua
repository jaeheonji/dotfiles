-----------------
---- plugins ----
-----------------

require("full-border"):setup()
require("no-status"):setup()
require("starship"):setup()

------------------
---- linemode ----
------------------

local PERM_STYLE = {
	["r"] = ui.Style():fg("#f9e2af"), -- catppuccin perm_read
	["w"] = ui.Style():fg("#f38ba8"), -- catppuccin perm_write
	["x"] = ui.Style():fg("#a6e3a1"), -- catppuccin perm_exec
	["-"] = ui.Style():fg("#585b70"), -- catppuccin surface2
}

-- Returns true if `file` is the currently hovered entry in the active pane.
local function is_hovered(file)
	local h = cx.active.current.hovered
	-- URL objects require string coercion for equality comparison
	return h ~= nil and tostring(h.url) == tostring(file.url)
end

-- Converts a permission string (e.g. "-rwxr-xr-x") into a list of colored
-- ui.Span values. Colors are suppressed on the hovered row so the selection
-- highlight remains readable.
local function perm_spans(perm, hovered)
	if not perm then
		return { ui.Span("?????????"):fg("#585b70") }
	end
	local spans = {}
	for i = 2, #perm do -- skip index 1 (file type char: -, d, l, ...)
		local ch = perm:sub(i, i)
		-- hovered rows use the selection highlight, so drop per-char colors
		local style = hovered and ui.Style() or (PERM_STYLE[ch] or ui.Style())
		spans[#spans + 1] = ui.Span(ch):style(style)
	end
	return spans
end

-- Custom linemode: renders "size  permissions  mtime" for each file entry.
-- Activated by setting `linemode = "custom"` in yazi.toml.
function Linemode:custom()
	local hovered = is_hovered(self._file)
	local perm = self._file.cha:perm()

	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time) -- current year: show clock time
	else
		time = os.date("%b %d  %Y", time) -- older: show year instead (extra space aligns with HH:MM width)
	end

	local size = self._file:size()
	local size_str = size and ya.readable_size(size) or "-"

	local spans = { ui.Span(size_str .. " ") }
	for _, s in ipairs(perm_spans(perm, hovered)) do
		spans[#spans + 1] = s
	end
	spans[#spans + 1] = ui.Span(" " .. time)

	return ui.Line(spans)
end
