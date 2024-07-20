local HttpService = game:GetService("HttpService")
local MainFolder = "Eternal"
local ConfigFolder = MainFolder .. "/config"
local LogsFolder = MainFolder .. "/logs"
local LibraryURL = "https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Eternal/library.lua"
local BridgeDuelsURL = "https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Eternal/config/BridgeDuels.lua"
local UniversalURL = "https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Eternal/config/Universal.lua"

local function GetGithub(url, path)
	local content = game:HttpGet(url)
	if content then
		writefile(path, content)
	else
		writefile(LogsFolder .. "/update_error.txt", "Unable to update Eternal. Dm nothm_ on discord for support")
	end
end

if not isfolder(MainFolder) then makefolder(MainFolder) end
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
if not isfolder(LogsFolder) then makefolder(LogsFolder) end
if not isfile(MainFolder .. "/library.txt") then GetGithub(LibraryURL, MainFolder .. "/library.txt") end
if isfolder(MainFolder) and isfolder(ConfigFolder) and isfolder(LogsFolder) then
	if game.PlaceId == 6872274481 or game.PlaceId == 8560631822 or game.PlaceId == 8444591321 then
		writefile(LogsFolder .. "/error_" .. game.PlaceId .. ".txt", "This game is not supported by Eternal")
	elseif game.PlaceId == 11630038968 then
		loadstring(game:HttpGet(BridgeDuelsURL))()
	else
		loadstring(game:HttpGet(UniversalURL))()
	end
end
