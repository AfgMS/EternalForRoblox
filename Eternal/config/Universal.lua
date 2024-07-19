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

local Toggle3 = Tabs.MainTab:CreateToggle({
	Name = "Toggle3",
	Callback = function(callback)
		if callback then
			print("Pencing")
		else
			print("Fembror")
		end
	end
})
