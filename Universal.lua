local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Library.lua"))()
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local CurrentCamera = game.Workspace.CurrentCamera
--[[
local Rayparams = RaycastParams.new()
Rayparams.FilterType = Enum.RaycastFilterType.Blacklist;
--]]

local Main = Library:CreateMain()
local Tabs = {
	Combat = Main:CreateTab("Combat", false),
	Movement = Main:CreateTab("Movement", false),
	Player = Main:CreateTab("Player", false),
	Render = Main:CreateTab("Render", false),
	Exploit = Main:CreateTab("Exploit", false),
	Misc = Main:CreateTab("Misc", true)
}

function IsAlive(entity)
	return entity and entity:FindFirstChildOfClass("Humanoid") and entity:FindFirstChildOfClass("Humanoid").Health > 0
end

function GetNearestEntity(MaxDist, EntityModes, EntityGetModes, EntitySort, EntityTeamCheck)
	local Entity, MinDist, Distance

	for _, entities in pairs(game.Workspace:GetChildren()) do
		if entities:IsA("Model") and entities.Name ~= LocalPlayer.Name then
			if IsAlive(entities) then
				if EntityModes == "Players" then
					for _, player in pairs(Players:GetPlayers()) do
						if player.Name == entities.Name then
							if not EntityTeamCheck or player.Team ~= LocalPlayer.Team then
								Distance = (entities:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
							end
						end
					end
				elseif EntityModes == "Models" then
					Distance = (entities:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
				end
				
				if Distance ~= nil then
					if EntityGetModes == "Distance" then
						local HumanoidE = entities:FindFirstChild("Humanoid")
						if EntitySort == "Nearest" then
							if Distance <= MaxDist and (not MinDist or Distance < MinDist) then
								MinDist = Distance
								Entity = entities
							end
						elseif EntitySort == "Furthest" then
							if Distance <= MaxDist and (not MinDist or Distance > MinDist) then
								MinDist = Distance
								Entity = entities
							end
						elseif EntitySort == "Health" then
							if HumanoidE and Distance <= MaxDist and (not MinDist or HumanoidE.Health < MinDist) then
								MinDist = HumanoidE.Health
								Entity = entities
							end
						elseif EntitySort == "Threat" then
							if HumanoidE and Distance <= MaxDist and (not MinDist or HumanoidE.Health > MinDist) then
								MinDist = HumanoidE.Health
								Entity = entities
							end
						end
					elseif EntityGetModes == "Mouse" then
						local ScreenPoint = workspace.CurrentCamera:WorldToScreenPoint(entities:FindFirstChild("HumanoidRootPart").Position)
						Distance = (Vector2.new(ScreenPoint.X, ScreenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
						if Distance <= MaxDist and (not MinDist or Distance < MinDist) then
							MinDist = Distance
							Entity = entities
						end
					end
				end
			end
		end
	end
	return Entity
end


spawn(function()
	local Distance, Mode1, Mode2, Mode3, Mode4, Hold, Check = nil, nil, nil, nil, nil, nil
	local Direction = Vector3.new(0, 0, 0)
	local Connections
	local AimAssist = Tabs.Combat:CreateToggle({
		Name = "AimAssist",
		Callback = function(callback)
			if callback then
				Connections = RunService.Heartbeat:Connect(function()
					local Entities = GetNearestEntity(Distance, Mode1, Mode2, Mode3, Check)
					if Entities then
						if Mode4 == "Head" then
							Direction = (Entities:FindFirstChild("Head").Position - CurrentCamera.CFrame.Position).unit
						elseif Mode4 == "Torso" then
							Direction = (Entities:FindFirstChild("HumanoidRootPart").Position - CurrentCamera.CFrame.Position).unit
						end
						if Hold then
							if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
								CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + Direction)
							end
						else
							CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + Direction)
						end
					end
				end)
			else
				if Connections then
					Connections:Disconnect()
				end
			end
		end
	})
	local CustomDistance = AimAssist:CreateSlider({
		Name = "Distance",
		Min = 0,
		Max = 200,
		Default = 85,
		Callback = function(callback)
			if callback then
				Distance = callback
			end
		end
	})
	local CustomMode1 = AimAssist:CreateDropdown({
		Name = "Mode1Options",
		List = {"Players", "Models"},
		Default = "Players",
		Callback = function(callback)
			if callback then
				Mode1 = callback
			end
		end
	})
	local CustomMode2 = AimAssist:CreateDropdown({
		Name = "Mode2Options",
		List = {"Distance", "Mouse"},
		Default = "Distance",
		Callback = function(callback)
			if callback then
				Mode2 = callback
			end
		end
	})
	local CustomMode3 = AimAssist:CreateDropdown({
		Name = "Mode3Options",
		List = {"Nearest", "Furthest", "Health", "Threat"},
		Default = "Nearest",
		Callback = function(callback)
			if callback then
				Mode3 = callback
			end
		end
	})
	local CustomMode4 = AimAssist:CreateDropdown({
		Name = "Mode3Options",
		List = {"Head", "Torso"},
		Default = "Torso",
		Callback = function(callback)
			if callback then
				Mode4 = callback
			end
		end
	})
	local HoldModes = AimAssist:CreateMiniToggle({
		Name = "Hold",
		Callback = function(callback)
			if callback then
				Hold = callback
			end
		end
	})
	local CheckModes = AimAssist:CreateMiniToggle({
		Name = "Teams",
		Callback = function(callback)
			if callback then
				Check = callback
			end
		end
	})
end)

spawn(function()
	local Enabled, CPS = false, nil
	local AutoClicker = Tabs.Combat:CreateToggle({
		Name = "AutoClicker",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait(1 / CPS)
					local Tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
					if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
						if Tool then
							Tool:Activate()
						end
					end
				until not Enabled
			end
		end
	})
	local CustomCPS = AutoClicker:CreateSlider({
		Name = "CPS",
		Min = 0,
		Max = 100,
		Default = 50,
		Callback = function(callback)
			if callback then
				CPS = callback
			end
		end
	})
end)

spawn(function()
	local Enabled, Speed, YPos = false, nil, 0
	local HumanoidRootPartY = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
	local OldGravity = game.Workspace.Gravity

	UserInputService.JumpRequest:Connect(function()
		YPos = YPos + 6
	end)
	UserInputService.InputBegan:Connect(function(Input, IsTyping)
		if IsTyping then return end
		if Input.KeyCode == Enum.KeyCode.LeftShift then
			YPos = YPos - 6
		end
	end)

	local Fly = Tabs.Movement:CreateToggle({
		Name = "Fly",
		Callback = function(callback)
			Enabled = callback
			if callback then
				YPos = 0
				HumanoidRootPartY = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				repeat
					task.wait()
					local Motion = LocalPlayer.Character.Humanoid.MoveDirection * Speed
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(Motion.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, Motion.Z)
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.X, HumanoidRootPartY + YPos, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Z) * LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Rotation
					game.Workspace.Gravity = 0
				until not Enabled
				YPos = 0
				game.Workspace.Gravity = OldGravity
				HumanoidRootPartY =  LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
			end
		end
	})
	local CustomSpeed = Fly:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 30,
		Default = 28,
		Callback = function(callback)
			if callback then
				Speed = callback
			end
		end
	})
end)

spawn(function()
	local Enabled, Boost = false, nil
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local HighJump = Tabs.Movement:CreateToggle({
		Name = "HighJump",
		AutoDisable = true,
		Callback = function(callback)
			Enabled = callback
			if callback then
				local OldBodyVelocity = LocalPlayer.Character:FindFirstChildWhichIsA("BodyVelocity")
				if OldBodyVelocity then
					OldBodyVelocity:Destroy()
				end
				local NewBodyVelocity = Instance.new("BodyVelocity")
				NewBodyVelocity.Velocity = Vector3.new(0, Boost, 0)
				NewBodyVelocity.P = Boost
				NewBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
				NewBodyVelocity.Parent = HumanoidRootPart
			else
				wait(0.3)
				local OldBodyVelocity = HumanoidRootPart:FindFirstChildWhichIsA("BodyVelocity")
				if OldBodyVelocity then
					OldBodyVelocity:Destroy()
				end
			end
		end
	})
	local CustomBoost = HighJump:CreateSlider({
		Name = "Boost",
		Min = 0,
		Max = 220,
		Default = 75,
		Callback = function(callback)
			if callback then
				Boost = callback
			end
		end
	})
end)

spawn(function()
	local Boost = nil
	local OldGravity = game.Workspace.Gravity
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local LongJump = Tabs.Movement:CreateToggle({
		Name = "LongJump",
		AutoDisable = true,
		Callback = function(callback)
			if callback then
				game.Workspace.Gravity = 20
				spawn(function()
					if callback then
						Humanoid.Jump = true
					end
				end)
				wait(0.28)
				if HumanoidRootPart then
					local Motion = HumanoidRootPart.CFrame.LookVector * Boost
					HumanoidRootPart.Velocity = Vector3.new(Motion.X, HumanoidRootPart.Velocity.Y, Motion.Z)
				end
			else
				wait(1.15)
				game.Workspace.Gravity = OldGravity
				HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, HumanoidRootPart.Velocity.Y, HumanoidRootPart.Velocity.Z)
			end
		end
	})
	local CustomBoost = LongJump:CreateSlider({
		Name = "Boost",
		Min = 0,
		Max = 115,
		Default = 185,
		Callback = function(callback)
			if callback then
				Boost = callback
			end
		end
	})
end)

spawn(function()
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local OldGravity = game.Workspace.Gravity
	local Enabled, AutoJump, Gravity, Speeds = false, true, false, nil
	local Speed = Tabs.Movement:CreateToggle({
		Name = "Speed",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait()
					if HumanoidRootPart then
						local Motion = LocalPlayer.Character.Humanoid.MoveDirection * Speeds
						HumanoidRootPart.Velocity = Vector3.new(Motion.X, HumanoidRootPart.Velocity.Y, Motion.Z)
						if AutoJump then
							Humanoid.Jump = true
						end
						if Gravity then
							game.Workspace.Gravity = 82
						else
							game.Workspace.Gravity = OldGravity
						end
					end
				until not Enabled
				game.Workspace.Gravity = OldGravity
				HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, HumanoidRootPart.Velocity.Y, HumanoidRootPart.Velocity.Z)
			end
		end
	})
	local CustomSpeed = Speed:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 30,
		Default = 30,
		Callback = function(callback)
			if callback then
				Speeds = callback
			end
		end
	})
	local AutoJumpMode = Speed:CreateMiniToggle({
		Name = "AutoJump",
		Enabled = true,
		Callback = function(callback)
			if callback then
				AutoJump = true
			else
				AutoJump = false
			end
		end
	})
	local GravityMode = Speed:CreateMiniToggle({
		Name = "Gravity",
		Callback = function(callback)
			if callback then
				Gravity = true
			else
				Gravity = false
			end
		end
	})
end)

spawn(function()
	local BlurEffect, Size, Enabled = nil, nil, false
	local Blur = Tabs.Render:CreateToggle({
		Name = "Blur",
		Callback = function(callback)
			Enabled = callback
			if callback then
				if not Lighting:FindFirstChildWhichIsA("BlurEffect") then
					BlurEffect = Instance.new("BlurEffect")
					BlurEffect.Parent = Lighting
				end
				repeat
					wait()
					BlurEffect.Size = Size
				until not Enabled
			else
				if BlurEffect then
					BlurEffect:Destroy()
				end
			end
		end
	})
	local CustomSize = Blur:CreateSlider({
		Name = "Size",
		Min = 0,
		Max = 100,
		Default = 28,
		Callback = function(callback)
			if callback then
				Size = callback
			end
		end
	})
end)

spawn(function()
	local function Hightlight(player)
		if player ~= LocalPlayer and IsAlive(player) then
			local highlight = player.Character:FindFirstChildOfClass("Highlight")
			if not highlight or highlight.Name ~= "Chams" then
				highlight = Instance.new("Highlight")
				highlight.Name = "Chams"
				highlight.Parent = player.Character
				highlight.FillTransparency = 1
				highlight.OutlineTransparency = 0.45
			end
		end
	end

	local function RemoveHighlight(player)
		if player ~= LocalPlayer and IsAlive(player) then
			local highlight = player.Character:FindFirstChildOfClass("Highlight")
			if highlight and highlight.Name == "Chams" then
				highlight:Destroy()
			end
		end
	end

	local Enabled = false
	local Chams = Tabs.Render:CreateToggle({
		Name = "Chams",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait()
					Players.PlayerAdded:Connect(Hightlight)
					Players.PlayerRemoving:Connect(RemoveHighlight)
					for i,v in pairs(Players:GetPlayers()) do
						Hightlight(v)
					end
				until not Enabled
				for i,v in pairs(Players:GetPlayers()) do
					RemoveHighlight(v)
				end
			end
		end
	})
end)
