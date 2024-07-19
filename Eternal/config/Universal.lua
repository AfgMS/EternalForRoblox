local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Eternal/library.lua"))()
local Main = Library:CreateCore()

local Tabs = {
	MainTab = Main:CreateTab("Main"),
}

local Toggle1 = Tabs.MainTab:CreateToggle({
	Name = "Toggle1",
	Callback = function(callback)
		if callback then
			print("Activated")
		else
			print("Deactivated")
		end
	end
})
local MiniToggle1 = Toggle1:CreateMiniToggle({
	Name = "MiniToggle1",
	Callback = function(callback)
		if callback then
			print("MiniE")
		else
			print("MiniD")
		end
	end
})

local Toggle2 = Tabs.MainTab:CreateToggle({
	Name = "Toggle2",
	Callback = function(callback)
		if callback then
			print("Enabled")
		else
			print("Disabled")
		end
	end
})
local Selected
local Dropdown1 = Toggle2:CreateDropdown({
	Name = "RandomThingy",
	List = {"Dungong", "Henlo", "Santu"},
	Callback = function(callback)
		if callback then
			Selected = callback
			if Selected == "Dungong" then
				print("hendroriujhajija")
			elseif Selected == "Henlo" then
				print("Santuywgah")
			elseif Selected == "Santu" then
				print("Dungongiajka")
			end
		end
	end
})
