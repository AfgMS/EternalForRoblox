local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Eternal/library.lua"))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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

local function IsAlive(plr)
	return plr and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0.11
end

local function FindNearestPlayer(distance)
	local NearestPlayer = nil
	local MinDistance = math.huge

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if IsAlive(player) then
				local Distances = (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - player.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
				if Distances < MinDistance and Distances <= distance then
					MinDistance = Distances
					NearestPlayer = player
				end
			end
		end
	end
	return NearestPlayer
end

local function GetTool(matchname)
	for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		if tool:IsA("Tool") and string.match(tool.Name, matchname) then
			return tool
		end
	end
	return nil
end

local function DamagePlayer(plr, crit, tool)
	local args = {
		[1] = plr,
		[2] = crit,
		[3] = tool
	}

	ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(unpack(args))
end

--AutoSword
local AutoSwordDistance
local AutoSword = Tabs.Combat:CreateToggle({
	Name = "AutoSword",
	Callback = function(callback)
		if callback then
			AutoSwordDistance = 28
			local Nearest = FindNearestPlayer(AutoSwordDistance)
			local Sword = GetTool("Sword")
			if Nearest then
				if Sword then
					Humanoid:EquipTool(Sword)
				end
			end
		else
			AutoSwordDistance = 0
		end
	end
})
local AutoSwordCustomDistance = AutoSword:CreateSlider({
	Name = "Distance",
	Min = 0,
	Max = 100,
	Callback = function(callback)
		if AutoSword.Enabled then
			AutoSwordDistance = callback
		end
	end
})
--Criticals
local CriticalMode = nil
local KillAuraCriticals = false
local Criticals = Tabs.Combat:CreateToggle({
	Name = "Criticals",
	Callback = function(callback)
		if callback then
			if CriticalMode == "Packet" then
				KillAuraCriticals = true
			elseif CriticalMode == "Jump" then
				KillAuraCriticals = false
			end
		end
	end
})
local CriticalsMode = Criticals:CreateDropdown({
	Name = "Mode",
	List = {"Packet", "Jump"},
	Callback = function(callback)
		CriticalMode = callback
	end
})

--KillAura
local KillAuraDistance
local KillAuraESP
local KillAuraSwing = true
local KillAuraAutoBlock = nil
local KillAuraDelay
local KillAura19 = false
local KillAura = Tabs.Combat:CreateToggle({
	Name = "KillAura",
	Callback = function(callback)
		if callback then
			KillAuraDelay = 0.1
			KillAuraDistance = 28
			local Nearest = FindNearestPlayer(KillAuraDistance)
			local Sword = GetTool("Sword")
			if Nearest then
				if KillAura19 then
					KillAuraDelay = 0.55
				else
					KillAuraDelay = 0.1
				end
				if Sword then
					local SwingAnimation = Sword:WaitForChild("Animations"):FindFirstChild("Swing")
					local BlockAnimation = Sword:WaitForChild("Animations"):FindFirstChild("Block")
					if KillAuraAutoBlock == "Packet" then
						game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(true, Sword)
					elseif KillAuraAutoBlock == "Fake" then
						game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(false, Sword)
						Humanoid:LoadAnimation(BlockAnimation):Play()
					end
					while true do
						wait(KillAuraDelay)
						DamagePlayer(Nearest.Character, KillAuraCriticals, Sword)
						if KillAuraSwing then
							Humanoid:LoadAnimation(SwingAnimation):Play()
						end
					end
				end
			else
				KillAuraESP:Destroy()
				game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(false, Sword)
				KillAuraDelay = 86400
			end
		end
	end
})
local KillAuraCustomDistance = KillAura:CreateSlider({
	Name = "Range",
	Min = 0,
	Max = 28,
	Callback = function(callback)
		KillAuraDistance = callback
	end
})
local KillAuraAutoBlockMode = KillAura:CreateDropdown({
	Name = "AutoBlock",
	List = {"Packet", "Fake"},
	Callback = function(callback)
		KillAuraAutoBlock = callback
	end
})
local KillAuraSwingMode = KillAura:CreateMiniToggle({
	Name = "Swing",
	Callback = function(callback)
		KillAuraSwing = not KillAuraSwing
	end
})
local KillAuraSwingMode = KillAura:CreateMiniToggle({
	Name = "1.9 Attack",
	Callback = function(callback)
		KillAura19 = not KillAura19
	end
})
