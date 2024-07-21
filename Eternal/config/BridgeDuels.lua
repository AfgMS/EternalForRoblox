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
					if Sword then
						Humanoid:EquipTool(Sword)
					end
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
				while true do
					wait()
					game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword").OnClientInvoke = function()
						Humanoid.Jump = true
					end 
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

local ScreenGui
local TargetHUD = Tabs.Render:CreateToggle({
	Name = "TargetHUD",
	Callback = function(callback)
		if callback then
			ScreenGui = Instance.new("ScreenGui")
			local Frame = Instance.new("Frame")
			local TargetHUD = Instance.new("Frame")
			local TargetName = Instance.new("TextLabel")
			local FightStatus = Instance.new("TextLabel")
			local HealthBack = Instance.new("Frame")
			local HealthFront = Instance.new("Frame")
			
			ScreenGui.Parent = LocalPlayer.PlayerGui
			ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

			Frame.Parent = ScreenGui
			Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame.BackgroundTransparency = 1.000
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Size = UDim2.new(1, 0, 1, 0)

			TargetHUD.Parent = Frame
			TargetHUD.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			TargetHUD.BackgroundTransparency = 0.350
			TargetHUD.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TargetHUD.BorderSizePixel = 0
			TargetHUD.Position = UDim2.new(0.577536166, 0, 0.670803726, 0)
			TargetHUD.Size = UDim2.new(0, 165, 0, 50)

			TargetName.Parent = TargetHUD
			TargetName.AnchorPoint = Vector2.new(0.5, 0.5)
			TargetName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TargetName.BackgroundTransparency = 1.000
			TargetName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TargetName.BorderSizePixel = 0
			TargetName.Position = UDim2.new(0.629999995, 0, 0.25, 0)
			TargetName.Size = UDim2.new(0, 120, 0, 14)
			TargetName.Font = Enum.Font.SourceSans
			TargetName.TextColor3 = Color3.fromRGB(255, 255, 255)
			TargetName.TextScaled = true
			TargetName.TextSize = 14.000
			TargetName.TextWrapped = true
			TargetName.TextXAlignment = Enum.TextXAlignment.Left

			FightStatus.Parent = TargetHUD
			FightStatus.AnchorPoint = Vector2.new(0.5, 0.5)
			FightStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			FightStatus.BackgroundTransparency = 1.000
			FightStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
			FightStatus.BorderSizePixel = 0
			FightStatus.Position = UDim2.new(0.629999995, 0, 0.5, 0)
			FightStatus.Size = UDim2.new(0, 120, 0, 14)
			FightStatus.Font = Enum.Font.SourceSans
			FightStatus.Text = "Winning"
			FightStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
			FightStatus.TextScaled = true
			FightStatus.TextSize = 14.000
			FightStatus.TextWrapped = true
			FightStatus.TextXAlignment = Enum.TextXAlignment.Left

			HealthBack.Parent = TargetHUD
			HealthBack.AnchorPoint = Vector2.new(0.5, 0.5)
			HealthBack.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
			HealthBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HealthBack.BorderSizePixel = 0
			HealthBack.Position = UDim2.new(0.5, 0, 0.850000024, 0)
			HealthBack.Size = UDim2.new(0, 155, 0, 5)

			HealthFront.Parent = HealthBack
			HealthFront.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			HealthFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
			HealthFront.BorderSizePixel = 0
			HealthFront.Size = UDim2.new(0, 155, 0, 5)
			
			while true do
				wait()
				local NearestPlayer  = GetNearestPlayer(KillAuraRange)
				TargetName.Text = NearestPlayer.Name
				HealthFront.Size = UDim2.new(NearestPlayer.Character:FindFirstChildOfClass("Humanoid").Health / NearestPlayer.Character:FindFirstChildOfClass("Humanoid").MaxHealth, 0, 1, 0)
				if Humanoid.Health > NearestPlayer.Character:FindFirstChildOfClass("Humanoid").Health then
					FightStatus.Text = "Winning"
				elseif Humanoid.Health < NearestPlayer.Character:FindFirstChildOfClass("Humanoid").Health then
					FightStatus.Text = "Losing"
				end
			end
		else
			ScreenGui:Destroy()
		end
	end
})
