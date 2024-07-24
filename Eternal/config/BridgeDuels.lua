local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Eternal/library.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local CurrentCamera = game:GetService("Workspace").CurrentCamera

local Main = Library:CreateCore()
local Tabs = {
	Combat = Main:CreateTab({Name = "Combat"}),
	Movement = Main:CreateTab({Name = "Movement"}),
	Player = Main:CreateTab({Name = "Player"}),
	Render = Main:CreateTab({Name = "Render"}),
	Exploit = Main:CreateTab({Name = "Exploit"}),
	Misc = Main:CreateTab({Name = "Misc", ZSettings = true})
}

local function IsAlive(v)
	return v and v.Character and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0
end

local function GetNearestPlayer(MaxDist)
	local Nearest, MinDist

	for i,v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer then
			if not IsAlive(v) then
				repeat task.wait() until IsAlive(v)
			end
			local Distance = (v.Character:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
			if Distance <= MaxDist and (not MinDist or Distance < MinDist) then
				MinDist = Distance
				Nearest = v
			end
		end
	end
	return Nearest
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
			Library.Settings.MobileButtons = not Library.Settings.MobileButtons
		end
	end
})

local AutoSwordDelay
local AutoSword = Tabs.Combat:CreateToggle({
	Name = "AutoSword",
	Callback = function(callback)
		if callback then
			AutoSwordDelay = 0.1
			while true do
				wait(AutoSwordDelay)
				local NearestPlayer = GetNearestPlayer(28)
				local Sword = GetTool("Sword")
				if NearestPlayer then
					Humanoid:EquipTool(Sword)
				end
			end
		else
			AutoSwordDelay = 86400
		end
	end
})

local CriticalsMode = nil
local JumpCrit = false
local PacketCrit = false
local Criticals = Tabs.Combat:CreateToggle({
	Name = "Criticals",
	Callback = function(callback)
		if callback then
			if CriticalsMode == "Jump" then
				JumpCrit = true
				PacketCrit = false
			elseif CriticalsMode == "Packet" then
				JumpCrit = false
				PacketCrit = true
			end
			if JumpCrit then
				game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword").OnClientInvoke = function()
					Humanoid.Jump = true
				end 
			end
		else
			JumpCrit = false
			PacketCrit = false
		end
	end
})
local CritMode = Criticals:CreateDropdown({
	Name = "CritMode",
	List = {"Jump", "Packet"},
	Callback = function(callback)
		CriticalsMode = callback
	end
})

local KillAuraRange
local KillAura = Tabs.Combat:CreateToggle({
	Name = "KillAura",
	Callback = function(callback)
		if callback then
			KillAuraRange = 28
			while true do
				task.wait()
				if not IsAlive(LocalPlayer) then
					repeat
						task.wait()
					until IsAlive(LocalPlayer)
				end
				local NearestPlayer = GetNearestPlayer(KillAuraRange)
				local Sword = GetTool("Sword")
				if NearestPlayer then
					if Sword then
						local args = {
							[1] = NearestPlayer.Character,
							[2] = PacketCrit,
							[3] = Sword.Name
						}

						game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(unpack(args))
					end
				end
			end
		else
			KillAuraRange = 0
		end
	end
})

local TargetHUD = Tabs.Render:CreateToggle({
	Name = "TargetHUD",
	Callback = function(callback)
		if callback then
			while true do
				wait()
				if not IsAlive(LocalPlayer) then
					repeat
						task.wait()
					until IsAlive(LocalPlayer)
				end
			end
			local NearestPlayer = GetNearestPlayer(KillAuraRange)
			if NearestPlayer then
				Main:CreateTargetHud({
					TargetName = NearestPlayer.Name,
					TargetImage = Players:GetUserThumbnailAsync(NearestPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48),
					TargetHumanoid = NearestPlayer.Character:FindFirstChildOfClass("Humanoid"),
					PlayerHumanoid = Humanoid,
					HudVisible = true
				})
			end
		else
			Main:CreateTargetHud({
				HudVisible = false
			})
		end
	end
})
