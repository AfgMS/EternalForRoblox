local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Eternal/library.lua"))()
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
			Library.MobileButtons = not Library.MobileButtons
		end
	end
})

local KillAuraRange = 28
local AutoSword = Tabs.Combat:CreateToggle({
	Name = "AutoSword",
	Callback = function(callback)
		if callback then
			while true do
				wait()
				local NearestPlayer = GetNearestPlayer(KillAuraRange)
				if NearestPlayer then
					for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
						if v:IsA("Tool") and v.Name:match("Sword") then
							Humanoid:EquipTool(v)
						end
					end
				end
			end
		end
	end
})

local CriticalsMode = nil
local PacketMode, JumpMode = false, false
local Criticals = Tabs.Combat:CreateToggle({
	Name = "Criticals",
	Enabled = true,
	Callback = function(callback)
		if callback then
			if CriticalsMode == "Packet" then
				PacketMode, JumpMode = true, false
			elseif CriticalsMode == "Jump" then
				PacketMode, JumpMode = false, true
			end
		else
			PacketMode, JumpMode = false, false
		end
	end
})

local KillAuraEnabled = false
local BlockAnim, SwingAnim
local KillAura = Tabs.Combat:CreateToggle({
	Name = "KillAura",
	Callback = function(callback)
		if callback then
			KillAuraEnabled = true
			local NearestPlayer = GetNearestPlayer(KillAuraRange)
			repeat
				task.wait()
				if not IsAlive(LocalPlayer) then
					repeat
						task.wait()
					until IsAlive(LocalPlayer)
				end
				if NearestPlayer then
					local Sword = GetTool("Sword")
					if Sword then
						BlockAnim = Sword:WaitForChild("Animations").BlockHit
						SwingAnim = Sword:WaitForChild("Animations").Swing
						if BlockAnim and SwingAnim then
							local args = {
								[1] = NearestPlayer.Character,
								[2] = PacketMode,
								[3] = Sword.Name
							}
							game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(unpack(args))
							Humanoid:LoadAnimation(SwingAnim):Play()
						end
					end
				end
			until not KillAuraEnabled
		else
			Humanoid:LoadAnimation(SwingAnim):Stop()
			KillAuraEnabled = false
		end
	end
})
