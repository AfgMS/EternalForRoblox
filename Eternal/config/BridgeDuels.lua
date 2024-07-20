---local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Eternal/library.lua"))()
local Library = require(game.ReplicatedStorage.Roblox.New.Eternal.Eternal)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local CurrentCamera = game:GetService("Workspace").CurrentCamera

local Main = Library:CreateCore()
local Tabs = {
	Combat = Main:CreateTab("Combat"),
	Movement = Main:CreateTab("Movement"),
	Player = Main:CreateTab("Player"),
	Render = Main:CreateTab("Render"),
	Exploit = Main:CreateTab("Exploit"),
	Misc = Main:CreateTab("Misc")
}

local function IsAlive(v)
	return v and v.Character and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0.11
end

local function GetNearestPlayers(distance)
	local PlayersTable = {}

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and IsAlive(player) then
			local ActualDistance = (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - player.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
			if ActualDistance <= distance then
				table.insert(PlayersTable, player)
			end
		end
	end
	return PlayersTable
end

local function GetTool(matchname)
	local Item = nil
	for i, v in pairs(LocalPlayer.Character:GetChildren()) do
		if v:IsA("Tool") and string.match(v.Name, matchname) then
			Item = v
		end
	end
	return Item
end

local MobileSupport = Tabs.Misc:CreateToggle({
	Name = "MobileSupport",
	Callback = function(callback)
		if callback then
			Library.MobileButtons = not Library.MobileButtons
		end
	end
})

local KillAuraDistance = 28
local KillAura = Tabs.Combat:CreateToggle({
	Name = "KillAura",
	Callback = function(enabled)
		if enabled then
			task.spawn(function()
				while enabled do
					task.wait(0.03)
					local targets = GetNearestPlayers(KillAuraDistance)
					local sword = GetTool("Sword")
					if #targets > 0 and sword then
						for _, target in pairs(targets) do
							repeat
								task.wait()
								print(target.Name .. ", Health: " .. target.Character:FindFirstChildOfClass("Humanoid").Health)
								local args = {
									[1] = target.Character,
									[2] = true,
									[3] = sword.Name
								}
								game:GetService("ReplicatedStorage").Packages.Knit.Services.ToolService.RF.AttackPlayerWithSword:InvokeServer(unpack(args))
							until not IsAlive(target)
						end
					else
						print("Nil")
					end
				end
			end)
		end
	end
})
