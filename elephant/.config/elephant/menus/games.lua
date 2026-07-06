Name = "games"
NamePretty = "Games"
HideFromProviderlist = false

local HOME = os.getenv("HOME")
local GAMES_DIR = HOME .. "/Games"

local EXCLUDE_PATTERNS = {
	"^[Uu]nins%d*%.exe$",
	"[Cc]rash[Hh]andler",
	"[Cc]rash[Rr]eporter",
	"^[Ss]etup%.exe$",
	"^[Ii]nstall%.exe$",
	"^[Rr]edist",
	"^[Uu]nity[Cc]rash",
	"^[Dd]x[Ss]etup",
	"^[Vv]cRedist",
}

local function excluded(filename)
	for _, pat in ipairs(EXCLUDE_PATTERNS) do
		if filename:match(pat) then
			return true
		end
	end
	return false
end

local function pretty_name(dir_name)
	local name = dir_name:gsub("%.?v%d+[%.%d]+$", "")
	name = name:gsub("[%._]+", " ")
	name = name:match("^%s*(.-)%s*$")
	return name
end

local function find_icons(game_dir)
	local found = {}
	local handle = io.popen(
		"find '"
			.. game_dir
			.. "' -maxdepth 1 -type f -iname '*icon*' 2>/dev/null | grep -iE '\\.(png|jpg|jpeg)$' | sort"
	)
	if handle then
		for path in handle:lines() do
			table.insert(found, path)
		end
		handle:close()
	end
	if #found == 0 then
		return { "applications-games" }
	end
	return found
end

local function find_game_exe(game_dir)
	local handle = io.popen("find '" .. game_dir .. "' -maxdepth 3 -iname '*.exe' 2>/dev/null | sort")
	if not handle then
		return nil, nil
	end

	local candidates = {}
	for path in handle:lines() do
		local filename = path:match("[^/]+$")
		if filename and not excluded(filename) then
			table.insert(candidates, path)
		end
	end
	handle:close()

	if #candidates == 0 then
		return nil, nil
	end

	table.sort(candidates, function(a, b)
		local da = select(2, a:gsub("/", ""))
		local db = select(2, b:gsub("/", ""))
		return da < db
	end)

	local exe = candidates[1]
	local dir = exe:match("^(.*)/[^/]+$")
	return exe, dir
end

function GetEntries()
	math.randomseed(os.time())
	local entries = {}

	local handle = io.popen("find '" .. GAMES_DIR .. "' -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort")
	if not handle then
		return entries
	end

	for game_dir in handle:lines() do
		local dir_name = game_dir:match("[^/]+$")
		local exe, exe_dir = find_game_exe(game_dir)

		if exe and exe_dir then
			local name = pretty_name(dir_name)
			table.insert(entries, {
				Text = name,
				Subtext = exe:match("[^/]+$"),
				Icon = (function()
					local icons = find_icons(game_dir)
					return icons[math.random(#icons)]
				end)(),
				Actions = {
					activate = "sh -c 'cd \"" .. exe_dir .. '" && wine "' .. exe .. "\" &'",
				},
			})
		end
	end

	handle:close()
	return entries
end
