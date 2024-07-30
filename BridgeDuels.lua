local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Library.lua"))()
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local CurrentCamera = game:GetService("Workspace").CurrentCamera

local Main = Library:CreateMain()
local Tabs = {
	Combat = Main:CreateTab("Combat", false),
	Movement = Main:CreateTab("Movement", false),
	Player = Main:CreateTab("Player", false),
	Render = Main:CreateTab("Render", false),
	Exploit = Main:CreateTab("Exploit", false),
	Misc = Main:CreateTab("Misc", true)
}

local function IsAlive(v)
	return v and v.Character and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0
end

local function GetNearestPlayer(MaxDist)
	local Nearest, MinDist

	for i,v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and IsAlive(v) then
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

spawn(function()
	local Enabled, Range, Delays, Object, Direction, Hold = false, nil, 0, nil, nil, false
	local AimAssist = Tabs.Combat:CreateToggle({
		Name = "AimAssist",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait(Delays)
					local NearestPlayer = GetNearestPlayer(Range)
					if NearestPlayer then
						if Object == "Head" then
							Direction = (NearestPlayer.Character:WaitForChild("Head").Position - CurrentCamera.CFrame.Position).unit
						elseif Object == "HumRootPart" then
							Direction = (NearestPlayer.Character:WaitForChild("HumanoidRootPart").Position - CurrentCamera.CFrame.Position).unit
						elseif Object == "LowerTorso" then
							Direction = (NearestPlayer.Character:WaitForChild("LowerTorso").Position - CurrentCamera.CFrame.Position).unit
						end
						local SetLookAt = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + Direction)
						if Hold then
							if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
								CurrentCamera.CFrame = SetLookAt
							end
						else
							CurrentCamera.CFrame = SetLookAt
						end
					end
				until not Enabled
			end
		end
	})
	local HoldToAim = AimAssist:CreateMiniToggle({
		Name = "Hold",
		Enabled = true,
		Callback = function(callback)
			if callback then
				Hold = true
			else
				Hold = false
			end
		end
	})
	local CustomRange = AimAssist:CreateSlider({
		Name = "Range",
		Min = 0,
		Max = 100,
		Default = 28,
		Callback = function(callback)
			if callback then
				Range = callback
			end
		end
	})
	local CustomObject = AimAssist:CreateDropdown({
		Name = "AimPart",
		List = {"Head", "HumRootPart", "LowerTorso"},
		Default = "HumRootPart",
		Callback = function(callback)
			if callback then
				Object = callback
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
					task.wait(1 / CPS)
					local Tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
					if Tool and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
						Tool:Activate()
					end
				until not Enabled
			end
		end
	})
	local CustomCPS = AutoClicker:CreateSlider({
		Name = "CPS",
		Min = 0,
		Max = 100,
		Default = 10,
		Callback = function(callback)
			if callback then
				CPS = callback
			end
		end
	})
end)

spawn(function()
	local Enabled = false
	local AutoSword = Tabs.Combat:CreateToggle({
		Name = "AutoSword",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					if IsAlive(LocalPlayer) then
						local NearestPlayer = GetNearestPlayer(30)
						if NearestPlayer then
							for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
								if v:IsA("Tool") and v.Name:match("Sword") then
									Humanoid:EquipTool(v)
								end
							end
						end
					end
				until not Enabled
			end
		end
	})
end)

local KillAuraCrit = false
spawn(function()
	local Criticals = Tabs.Combat:CreateToggle({
		Name = "Criticals",
		Enabled = true,
		Callback = function(callback)
			if callback then
				KillAuraCrit = true
			else
				KillAuraCrit = false
			end
		end
	})
end)

spawn(function()
	local Enabled, Range, Swing, Mode, BlockAnim, SwingAnim = false, nil, false, nil, nil, nil
	local KillAura = Tabs.Combat:CreateToggle({
		Name = "KillAura",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					if IsAlive(LocalPlayer) then
						local NearestPlayer = GetNearestPlayer(Range)
						if NearestPlayer then
							local Sword = GetTool("Sword")
							if Sword then
								BlockAnim = Sword:WaitForChild("Animations").BlockHit
								SwingAnim = Sword:WaitForChild("Animations").Swing
								if Swing then
									Humanoid:LoadAnimation(SwingAnim):Play()
								end
								if Mode == "Fake" then
									Humanoid:LoadAnimation(BlockAnim):Play()
									local args = {
										[1] = false,
										[2] = Sword.Name
									}

									game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								elseif Mode == "Remote" then
									Humanoid:LoadAnimation(BlockAnim):Stop()
									local args = {
										[1] = true,
										[2] = Sword.Name
									}

									game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								elseif Mode == "Legit" then
									Humanoid:LoadAnimation(BlockAnim):Play()
									local args = {
										[1] = true,
										[2] = Sword.Name
									}

									game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								end
								local args = {
									[1] = NearestPlayer.Character,
									[2] = KillAuraCrit,
									[3] = Sword.Name
								}
								game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(unpack(args))
							end
						end
					end
				until not Enabled
			end
		end
	})
	local CustomRange = KillAura:CreateSlider({
		Name = "Range",
		Min = 0,
		Max = 30,
		Default = 30,
		Callback = function(callback)
			if callback then
				Range = callback
			end
		end
	})
	local CustomSwing = KillAura:CreateMiniToggle({
		Name = "Swing",
		Enabled = true,
		Callback = function(callback)
			if callback then
				Swing = true
			else
				Swing = false
			end
		end
	})
	local CustomMode = KillAura:CreateDropdown({
		Name = "AutoBlock",
		List = {"Fake", "Remote", "Legit"},
		Default = "Fake",
		Callback = function(callback)
			if callback then
				Mode = callback
			end
		end
	})
end)

spawn(function()
	local Enabled, YPos = false, 0
	local YRoot =  LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
	local OldGravity = game.Workspace.Gravity
	local Speed = nil
	local OldSpeed = Humanoid.WalkSpeed
	UserInputService.JumpRequest:Connect(function()
		YPos = YPos + 3
	end)
	UserInputService.InputBegan:Connect(function(Input, IsTyping)
		if IsTyping then return end
		if Input.KeyCode == Enum.KeyCode.LeftShift then
			YPos = YPos - 3
		end
	end)
	local Fly = Tabs.Movement:CreateToggle({
		Name = "Fly",
		Callback = function(callback)
			Enabled = callback
			if callback then
				YRoot =  LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				YPos = 0
				repeat
					task.wait()
					local velo = LocalPlayer.Character.Humanoid.MoveDirection * Speed
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(velo.X, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity.Y, velo.Z)
					LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.X, YRoot + YPos, LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Z) * LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.Rotation
					game.Workspace.Gravity = 0
				until not Enabled
				YRoot =  LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position.Y
				YPos = 0
				Humanoid.WalkSpeed = OldSpeed
				game.Workspace.Gravity = OldGravity
				LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
			end
		end
	})
	local CustomSpeed = Fly:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 100,
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
				local OldBodyVelo = LocalPlayer.Character:FindFirstChildWhichIsA("BodyVelocity")
				if OldBodyVelo then
					OldBodyVelo:Destroy()
				end
				local BodyVelo = Instance.new("BodyVelocity")
				BodyVelo.Velocity = Vector3.new(0, Boost, 0)
				BodyVelo.P = Boost
				BodyVelo.MaxForce = Vector3.new(0, math.huge, 0)
				BodyVelo.Parent = HumanoidRootPart
			else
				local BodyVelo = HumanoidRootPart:FindFirstChildOfClass("BodyVelocity")
				if BodyVelo then
					BodyVelo:Destroy()
				end
			end
		end
	})
	local CustomBoost = HighJump:CreateSlider({
		Name = "Boost",
		Min = 0,
		Max = 1000,
		Default = 140,
		Callback = function(callback)
			if callback then
				Boost = callback
			end
		end
	})
end)

spawn(function()
	local Boost = nil
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local LongJump = Tabs.Movement:CreateToggle({
		Name = "LongJump",
		AutoDisable = true,
		Enabled = false,
		Callback = function(enabled)
			if enabled then
				if HumanoidRootPart then
					Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					local velo = HumanoidRootPart.CFrame.LookVector * Boost
					HumanoidRootPart.Velocity = Vector3.new(velo.X, HumanoidRootPart.Velocity.Y, velo.Z)
				end
			end
		end
	})

	LongJump:CreateSlider({
		Name = "Boost",
		Min = 50,
		Max = 120,
		Default = 85,
		Callback = function(value)
			Boost = value
		end
	})
end)

spawn(function()
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local Enabled, Diagonal, Expand = false, false, true
	local DefaultPos = Vector3.zero
	local function GetPlacePos(pos, diagonalmode)
		local NewPos = Vector3.new(math.floor((pos.X / 3) + 0.5) * 3, math.floor((pos.Y / 3) + 0.5) * 3, math.floor((pos.Z / 3) + 0.5) * 3)
		local Offset = (DefaultPos - NewPos)
		if IsAlive(LocalPlayer) then
			local HumanoidAngle = math.deg(math.atan2(-Humanoid.MoveDirection.X, -Humanoid.MoveDirection.Z))
			local DiagonalCheck = (HumanoidAngle >= 130 and HumanoidAngle <= 150) or (HumanoidAngle <= -35 and HumanoidAngle >= -50) or (HumanoidAngle >= 35 and HumanoidAngle <= 50) or (HumanoidAngle <= -130 and HumanoidAngle >= -150)
			if DiagonalCheck and ((NewPos.X == 0 and NewPos.Z ~= 0) or (NewPos.X ~= 0 and NewPos.Z == 0)) and diagonalmode then
				return DefaultPos
			end
		end
		return NewPos
	end
	
	local Scaffold = Tabs.Movement:CreateToggle({
		Name = "Scaffold",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					if IsAlive(LocalPlayer) then
						local Towers = UserInputService:IsKeyDown(Enum.KeyCode.Space) and UserInputService:GetFocusedTextBox() == nil
						if Towers then
							HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, 28, HumanoidRootPart.Velocity.Z)
						end
						for i = 1, Expand do
							local PlacePos = GetPlacePos((HumanoidRootPart.Position + (Humanoid.MoveDirection * (i * 3.5))) + Vector3.new(0, -((HumanoidRootPart.Size.Y / 2) + Humanoid.HipHeight + 1.5)), 0)
							PlacePos = Vector3.new(PlacePos.X, PlacePos.Y - (Towers and 4 or 0), PlacePos.Z)
							local args = {
								[1] = PlacePos
							}

							game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("PlaceBlock"):InvokeServer(unpack(args))
							if Expand > 1 then
								task.wait()
							end
							DefaultPos = PlacePos
						end
					end
				until not Enabled
				DefaultPos = Vector3.zero
			end
		end
	})
end)

spawn(function()
	local Enabled, NewSpeed, Mode = true, nil, nil
	local OldGravity = game.Workspace.Gravity
	local OldJumpHeight = Humanoid.JumpHeight
	local OldWalkspeed = Humanoid.WalkSpeed
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local Speed = Tabs.Movement:CreateToggle({
		Name = "Speed",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					if IsAlive(LocalPlayer) then
						if Mode == "WalkSpeed" then
							Humanoid.JumpHeight = OldJumpHeight
							Humanoid.WalkSpeed = NewSpeed
						elseif Mode == "Hop" then
							game.Workspace.Gravity = 82
							Humanoid.WalkSpeed = OldWalkspeed
							local velo = LocalPlayer.Character.Humanoid.MoveDirection * NewSpeed
							HumanoidRootPart.Velocity = Vector3.new(velo.X, HumanoidRootPart.Velocity.Y, velo.Z)
							Humanoid.Jump = true
						elseif Mode == "LowHop" then
							Humanoid.WalkSpeed = OldWalkspeed
							game.Workspace.Gravity = OldGravity
							Humanoid.JumpHeight = 0.20
							local velo = LocalPlayer.Character.Humanoid.MoveDirection * (NewSpeed + 15)
							HumanoidRootPart.Velocity = Vector3.new(velo.X, HumanoidRootPart.Velocity.Y, velo.Z)
							Humanoid.Jump = true
						end
					end
				until not Enabled
				Humanoid.WalkSpeed = OldWalkspeed
				game.Workspace.Gravity = OldGravity
				Humanoid.JumpHeight = OldJumpHeight
			end
		end
	})
	local CustomSpeedMode = Speed:CreateDropdown({
		Name = "SpeedMode",
		List = {"WalkSpeed", "Hop", "LowHop"},
		Default = "Hop",
		Callback = function(callback)
			if callback then
				Mode = callback
			end
		end
	})
	local CustomSpeed = Speed:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 50,
		Default = 28,
		Callback = function(callback)
			if callback then
				NewSpeed = callback
			end
		end
	})
end)

spawn(function()
	local OldHipHeight = Humanoid.HipHeight
	local Steps = Tabs.Movement:CreateToggle({
		Name = "Steps",
		Callback = function(callback)
			if callback then
				Humanoid.HipHeight = 3
			else
				Humanoid.HipHeight = OldHipHeight
			end
		end
	})
end)

spawn(function()
	local Enabled, Radius, Speed, Angle = false, nil, nil, 0
	local TargetStrafe = Tabs.Movement:CreateToggle({
		Name = "TargetStrafe",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait()
					local NearestPlayer = GetNearestPlayer(28)
					if NearestPlayer then
						local DeltaTime = wait()
						Angle = Angle + Speed * DeltaTime
						local XPos = math.cos(Angle) * Radius
						local ZPos = math.sin(Angle) * Radius
						local NewPos = NearestPlayer.Character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(XPos, 0, ZPos)
						Humanoid:MoveTo(NewPos)
					end
				until not Enabled
			end
		end
	})
	local CustomRadius = TargetStrafe:CreateSlider({
		Name = "Radius",
		Min = 0,
		Max = 28,
		Default = 12,
		Callback = function(callback)
			if callback then
				Radius = callback
			end
		end
	})
	local CustomSpeed = TargetStrafe:CreateSlider({
		Name = "Speed",
		Min = 0,
		Max = 28,
		Default = 25,
		Callback = function(callback)
			if callback then
				Speed = callback
			end
		end
	})
end)

spawn(function()
	local ChatWindowConfiguration = game:GetService("TextChatService"):FindFirstChild("ChatWindowConfiguration")
	local Streamer = Tabs.Render:CreateToggle({
		Name = "Streamer",
		Callback = function(callback)
			if callback then
				ChatWindowConfiguration.Enabled = false
				for _,bodypart in pairs(LocalPlayer.Character:GetChildren()) do
					if bodypart:IsA("MeshPart") then
						bodypart.BrickColor = BrickColor.Random()
					end
				end
			else
				ChatWindowConfiguration.Enabled = true
			end
		end
	})
end)
