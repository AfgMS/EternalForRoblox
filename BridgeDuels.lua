local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Library.lua"))()
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
local CurrentCamera = game.Workspace.CurrentCamera
local Viewmodel = CurrentCamera:FindFirstChildWhichIsA("Model")
if not shared.OriginalC0 then
	shared.OriginalC0 = Viewmodel:FindFirstChildWhichIsA("Model"):WaitForChild("Handle"):WaitForChild("MainPart").C0
end
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
	return entity and entity.Character and entity.Character:FindFirstChildOfClass("Humanoid") and entity.Character:FindFirstChildOfClass("Humanoid").Health > 0
end

function GetPlayer(MaxDist, Mode)
	local Nearest, MinDist

	for i, v in pairs(Players:GetChildren()) do
		if v ~= LocalPlayer and IsAlive(v) then
			local Distance = (v.Character:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
			if Mode == "Distance" then
				if Distance <= MaxDist and (not MinDist or Distance < MinDist) then
					MinDist = Distance
					Nearest = v
				end
			elseif Mode == "Health" then
				local Humanoid = v.Character:FindFirstChild("Humanoid")
				if Humanoid then
					local Health = Humanoid.Health
					if Distance <= MaxDist and (not MinDist or Health < MinDist) then
						MinDist = Health
						Nearest = v
					end
				end
			end
		end
	end
	return Nearest
end

function GetTools(name)
	local TooResults
	for _,tool in pairs(LocalPlayer.Backpack:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:match(name) then
			TooResults = tool
		end
	end
	return TooResults
end

function CheckTools(name)
	local TooResults
	for _,tool in pairs(LocalPlayer.Character:GetChildren()) do
		if tool:IsA("Tool") and tool.Name:match(name) then
			TooResults = tool
		end
	end
	return TooResults
end

local function GetToolsViewmodel()
	local ToolsMain = nil
	if Viewmodel and Viewmodel.Name:match("View") then
		for _,tools in pairs(Viewmodel:GetChildren()) do
			if tools:IsA("Model") then
				for _,handle in pairs(tools:GetChildren()) do
					if handle.Name:match("Handle") then
						for _,mainpart in pairs(handle:GetChildren()) do
							if mainpart.Name:match("Main") then
								ToolsMain = mainpart
							end
						end
					end
				end
			end
		end
	end
	return ToolsMain
end

function PlayItemView(anim)
	local Item = GetToolsViewmodel()
	if Item then
		local Tween = TweenService:Create(Item, TweenInfo.new(anim.Time), {C0 = shared.OriginalC0 * anim.CFrame})
		if Tween then
			Tween:Play()
			Tween.Completed:Wait()
		end
	end
end

spawn(function()
	local Enabled, Hold, HoldType, Distance, Aim = false, false, nil, nil, nil
	local Direction = Vector3.zero
	local AimAssist = Tabs.Combat:CreateToggle({
		Name = "AimAssist",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					local Player = GetPlayer(Distance, "Distance")
					if Aim == "Head" then
						Direction = (Player.Character:FindFirstChild("Head").Position - CurrentCamera.CFrame.Position).unit
					elseif Aim == "Torso" then
						Direction = (Player.Character:FindFirstChild("HumanoidRootPart").Position - CurrentCamera.CFrame.Position).unit
					elseif Aim == "Leg" then
						Direction = (Player.Character:FindFirstChild("LowerTorso").Position - CurrentCamera.CFrame.Position).unit
					end
					if Player then
						local NewCFrame = CFrame.new(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.Position + Direction)
						if Hold then
							if UserInputService:IsMouseButtonPressed(Enum.UserInputType[HoldType]) then
								CurrentCamera.CFrame = NewCFrame
							else
								CurrentCamera.CFrame = NewCFrame
							end
						end
					end
				until not Enabled
			end
		end
	})
	local CustomDirection = AimAssist:CreateDropdown({
		Name = "Directions",
		List = {"Head", "Torso", "Leg"},
		Default = "Torso",
		Callback = function(callback)
			if callback then
				Aim = callback
			end
		end
	})
	local CustomHoldType = AimAssist:CreateDropdown({
		Name = "Type",
		List = {"MouseButton1", "MouseButton2"},
		Default = "MouseButton1",
		Callback = function(callback)
			if callback then
				HoldType = callback
			end
		end
	})
	local HoldMode = AimAssist:CreateMiniToggle({
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
	local CustomDistance = AimAssist:CreateSlider({
		Name = "Distances",
		Min = 0,
		Max = 100,
		Default = 20,
		Callback = function(callback)
			if callback then
				Distance = callback
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
	local Enabled, Distance, Sword = false, nil, nil
	local AutoSword = Tabs.Combat:CreateToggle({
		Name = "AutoSword",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					local Player = GetPlayer(Distance, "Distance")
					Sword = GetTools("Sword")
					if Players then
						if Sword ~= nil then
							if LocalPlayer.Character:WaitForChild(Sword.Name) then
								Humanoid:EquipTool(Sword)
							end
						end
					end
				until not Enabled
				Humanoid:UnequipTools(Sword)
			end
		end
	})
	local CustomDistance = AutoSword:CreateSlider({
		Name = "Distance",
		Min = 0,
		Max = 100,
		Default = 20,
		Callback = function(callback)
			if callback then
				Distance = callback
			end
		end
	})
end)

local HitCrit = false
spawn(function()
	local Criticals = Tabs.Combat:CreateToggle({
		Name = "Criticals",
		Enabled = true,
		Callback = function(callback)
			if callback then
				HitCrit = true
			else
				HitCrit = false
			end
		end
	})
end)

spawn(function()
	local function KillRandom(plr)
		local Messages = {
			"Soo bad, just use Eternal " .. plr.Name .. "!",
			"Get Eternal Now! " .. plr.Name,
			"LOL " .. plr.Name
		}
		return Messages[math.random(1, #Messages)]
	end

	local function DiedRandom(plr)
		local Messages = {
			"Lag! Real! ",
			"Oops, " .. plr.Name .. ", Reported!"
		}
		return Messages[math.random(1, #Messages)]
	end

	local function SendMessages(msg)
		local args = {
			[1] = msg,
			[2] = "All"
		}
		game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(unpack(args))
	end

	local Enabled = false
	local KillSults = Tabs.Combat:CreateToggle({
		Name = "KillSults",
		Callback = function(callback)
			Enabled = callback
			if callback then
				game:GetService("ReplicatedStorage").Modules.Knit.Services.CombatService.RE.OnKill.OnClientEvent:Connect(function(killer, killed, ...)
					if Enabled then
						if  killer.Name == LocalPlayer.Name and killed.Name ~= LocalPlayer.Name then
							local message = KillRandom(killed)
							SendMessages(message)
						elseif killer.Name ~= LocalPlayer.Name and killed.Name == LocalPlayer.Name then
							local message = DiedRandom(killer)
							SendMessages(message)
						end
					end
				end)
			end
		end
	})
end)

local KillAuraDistance = nil
local KillAuraPlayerModes = nil
local KillAuraAnimation = nil
spawn(function()
	local BillboardGui = Instance.new("BillboardGui")
	local ImageLabel = Instance.new("ImageLabel")
	local Viewmodel = GetToolsViewmodel()
	local Enabled, BlockingMode = false, nil
	local BlockAnim, SwingAnim, AnimSword
	local Sword
	local KillAura = Tabs.Combat:CreateToggle({
		Name = "KillAura",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					if IsAlive(LocalPlayer) then
						local Player = GetPlayer(KillAuraDistance, KillAuraPlayerModes)
						if Player then
							Sword = CheckTools("Sword")
							if Sword then
								if BlockingMode == "Fake" then
									local args = {
										[1] = false,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								elseif	BlockingMode == "Remote" then
									local args = {
										[1] = true,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								end
								spawn(function()
									if Enabled then
										if KillAuraAnimation ~= nil then
											for i,v in pairs(KillAuraAnimation) do
												PlayItemView(v)
											end
										else
											Sword:Activate()
										end
									end
								end)
								spawn(function()
									if Enabled and BillboardGui and ImageLabel then
										BillboardGui.Active = true
										BillboardGui.AlwaysOnTop = true
										BillboardGui.MaxDistance = math.huge
										BillboardGui.Size = UDim2.new(18, 0, 18, 0)
										BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 5, 0)
										BillboardGui.Parent = Player.Character:FindFirstChild("HumanoidRootPart")

										ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
										ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
										ImageLabel.BackgroundTransparency = 1.000
										ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
										ImageLabel.BorderSizePixel = 0
										ImageLabel.Parent = BillboardGui
										ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
										ImageLabel.Size = UDim2.new(0.215, 0, 0.245, 0)
										ImageLabel.Image = "http://www.roblox.com/asset/?id=17329562110" 
									else
										BillboardGui.Active = false
									end
								end)
								local args = {
									[1] = Player.Character,
									[2] = HitCrit,
									[3] = Sword.Name
								}
								game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(unpack(args))
							end
						else
							if KillAuraAnimation ~= nil then
								Viewmodel.C0 = shared.OriginalC0
							end
							BillboardGui.Active = false
							local args = {
								[1] = false,
								[2] = Sword.Name
							}
							game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
						end
					end
				until not Enabled
				BillboardGui.Active = false
				if KillAuraAnimation ~= nil then
					Viewmodel.C0 = shared.OriginalC0
				end
				local args = {
					[1] = false,
					[2] = Sword.Name
				}
				game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
			end
		end
	})
	local CustomKillAuraPlayerModes = KillAura:CreateDropdown({
		Name = "PlayerMode",
		List = {"Distance", "Health"},
		Default = "Distance",
		Callback = function(callback)
			if callback then
				KillAuraPlayerModes = callback
			end
		end
	})
	local CustomBlockingMode = KillAura:CreateDropdown({
		Name = "BlockingMode",
		List = {"Fake", "Remote", "SemiLegit"},
		Default = "Fake",
		Callback = function(callback)
			if callback then
				BlockingMode = callback
			end
		end
	})
	local CustomDistance = KillAura:CreateSlider({
		Name = "Distance",
		Min = 0,
		Max = 20,
		Default = 20,
		Callback = function(callback)
			if callback then
				KillAuraDistance = callback
			end
		end
	})
end)

--[[ OldKillAura
local KillAuraDistance = nil
local KillAuraPlayerModes = nil
local KillAuraAnimation = nil
spawn(function()
	local BillboardGui = Instance.new("BillboardGui")
	local ImageLabel = Instance.new("ImageLabel")
	local Viewmodel = GetToolsViewmodel()
	local Enabled, BlockingMode = false, nil
	local BlockAnim, SwingAnim, AnimSword
	local Sword
	local KillAura = Tabs.Combat:CreateToggle({
		Name = "KillAura",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait()
					if IsAlive(LocalPlayer) then
						local Player = GetPlayer(KillAuraDistance, KillAuraPlayerModes)
						if Player then
							Sword = CheckTools("Sword")
							if Sword then
								--BlockAnim = Sword:WaitForChild("Animations").BlockHit
								--SwingAnim = Sword:WaitForChild("Animations").Swing
								if BlockingMode == "Fake" then
									--Humanoid:LoadAnimation(BlockAnim):Play()
									local args = {
										[1] = false,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								elseif	BlockingMode == "Remote" then
									--Humanoid:LoadAnimation(BlockAnim):Stop()
									local args = {
										[1] = true,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
									--[[
								elseif BlockingMode == "SemiLegit" then
									Humanoid:LoadAnimation(BlockAnim):Play()
									local args = {
										[1] = true,
										[2] = Sword.Name
									}
									game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
								end
								spawn(function()
									if Enabled then
										if KillAuraAnimation ~= nil then
											--Humanoid:LoadAnimation(SwingAnim):Play()
											for i,v in pairs(KillAuraAnimation) do
												PlayItemView(v)
											end
										else
											Sword:Activate()
											--Humanoid:LoadAnimation(SwingAnim):Play()
										end
									end
								end)
								spawn(function()
									if Enabled and BillboardGui and ImageLabel then
										BillboardGui.Active = true
										BillboardGui.AlwaysOnTop = true
										BillboardGui.MaxDistance = math.huge
										BillboardGui.Size = UDim2.new(18, 0, 18, 0)
										BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 5, 0)
										BillboardGui.Parent = Player.Character:FindFirstChild("HumanoidRootPart")

										ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
										ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
										ImageLabel.BackgroundTransparency = 1.000
										ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
										ImageLabel.BorderSizePixel = 0
										ImageLabel.Parent = BillboardGui
										ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
										ImageLabel.Size = UDim2.new(0.215, 0, 0.245, 0)
										ImageLabel.Image = "http://www.roblox.com/asset/?id=17329562110" 
									else
										BillboardGui.Active = false
									end
								end)
								local args = {
									[1] = Player.Character,
									[2] = HitCrit,
									[3] = Sword.Name
								}
								game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(unpack(args))
							end
						else
							if KillAuraAnimation ~= nil then
								Viewmodel.C0 = shared.OriginalC0
							end
							BillboardGui.Active = false
							--Humanoid:LoadAnimation(SwingAnim):Stop()
							--Humanoid:LoadAnimation(BlockAnim):Stop()
							local args = {
								[1] = false,
								[2] = Sword.Name
							}
							game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
						end
					end
				until not Enabled
				BillboardGui.Active = false
				--Humanoid:LoadAnimation(SwingAnim):Stop()
				--Humanoid:LoadAnimation(BlockAnim):Stop()
				if KillAuraAnimation ~= nil then
					Viewmodel.C0 = shared.OriginalC0
				end
				local args = {
					[1] = false,
					[2] = Sword.Name
				}
				game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
			end
		end
	})
	local CustomKillAuraPlayerModes = KillAura:CreateDropdown({
		Name = "PlayerMode",
		List = {"Distance", "Health"},
		Default = "Distance",
		Callback = function(callback)
			if callback then
				KillAuraPlayerModes = callback
			end
		end
	})
	local CustomBlockingMode = KillAura:CreateDropdown({
		Name = "BlockingMode",
		List = {"Fake", "Remote", "SemiLegit"},
		Default = "Fake",
		Callback = function(callback)
			if callback then
				BlockingMode = callback
			end
		end
	})
	local CustomDistance = KillAura:CreateSlider({
		Name = "Distance",
		Min = 0,
		Max = 20,
		Default = 20,
		Callback = function(callback)
			if callback then
				KillAuraDistance = callback
			end
		end
	})
end)
--]]

--[[
spawn(function()
	local Enabled = false
	local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local Velocity = Tabs.Combat:CreateToggle({
		Name = "JumpReset",
		Callback = function(callback)
			Enabled = callback
			if callback then
				ReplicatedStorage.Modules.Knit.Services.CombatService.RE.KnockBackApplied.OnClientEvent:Connect(function()
					if Enabled then
						Humanoid.Jump = true			
					end
				end)
			end
		end
	})
end)
--]]

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
		Max = 105,
		Default = 145,
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
					task.wait()
					if IsAlive(LocalPlayer) then
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
					end
				until not Enabled
				game.Workspace.Gravity = OldGravity
				HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, HumanoidRootPart.Velocity.Y, HumanoidRootPart.Velocity.Z)
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
end)

spawn(function()
	local Enabled, Diagonal, ToolCheck, Expand = false, false, false, nil
	local DefaultPos = Vector3.zero
	local function GetPlace(pos, diagonal)
		local NewPos = Vector3.new(math.floor((pos.X / 3) + 0.5) * 3, math.floor((pos.Y / 3) + 0.5) * 3, math.floor((pos.Z / 3) + 0.5) * 3)
		if IsAlive(LocalPlayer) then
			local HumanoidDirections = math.deg(math.atan2(-Humanoid.MoveDirection.X, -Humanoid.MoveDirection.Z))
			local DiagonalAngle = (HumanoidDirections >= 130 and HumanoidDirections <= 150) or (HumanoidDirections <= -35 and HumanoidDirections >= -50) or (HumanoidDirections >= 35 and HumanoidDirections <= 50) or (HumanoidDirections <= -130 and HumanoidDirections >= -150)
			if DiagonalAngle and ((NewPos.X == 0 and NewPos.Z ~= 0) or (NewPos.X ~= 0 and NewPos.Z == 0)) and diagonal then
				return DefaultPos
			end
		end
		return NewPos
	end

	local Scaffold = Tabs.Player:CreateToggle({
		Name = "Scaffold",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					if IsAlive(LocalPlayer) then
						local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
						local Block = CheckTools("Blocks")
						for i = 1, Expand do
							local PlacePos = GetPlace(HumanoidRootPart.Position + Humanoid.MoveDirection * (i * 3.5) - Vector3.yAxis * ((HumanoidRootPart.Size.Y / 2) + Humanoid.HipHeight + 1.5), Diagonal)
							DefaultPos = PlacePos
							if ToolCheck then
								if Block then
									local args = {
										[1] = PlacePos
									}

									game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("PlaceBlock"):InvokeServer(unpack(args))
								end
							else
								local args = {
									[1] = PlacePos
								}

								game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("PlaceBlock"):InvokeServer(unpack(args))
							end
							if Expand > 1 then
								wait()
							end
						end
					end
				until not Enabled
				DefaultPos = Vector3.zero
			end
		end
	})
	local CustomExpand = Scaffold:CreateSlider({
		Name = "Expand",
		Min = 0,
		Max = 3,
		Default = 1,
		Callback = function(callback)
			if callback then
				Expand = callback
			end
		end
	})
	local DiagonalMode = Scaffold:CreateMiniToggle({
		Name = "Diagonal",
		Enabled = true,
		Callback = function(callback)
			if callback then
				Diagonal = true
			else
				Diagonal = false
			end
		end
	})
	local ToolCheckMode = Scaffold:CreateMiniToggle({
		Name = "ToolCheck",
		Callback = function(callback)
			if callback then
				ToolCheck = true
			else
				ToolCheck = false
			end
		end
	})
end)

spawn(function()
	local Enabled = false
	local AutoHeal = Tabs.Player:CreateToggle({
		Name = "AutoGapple",
		Callback = function(callback)
			if callback then
				repeat
					task.wait()
					local Apple = CheckTools("Apple")
					if Apple then
						local args = {
							[1] = true
						}

						game:GetService("Players").LocalPlayer.Character.GoldApple.__comm__.RF.Eat:InvokeServer(unpack(args))
					end
				until not Enabled
				local args = {
					[1] = false
				}

				game:GetService("Players").LocalPlayer.Character.GoldApple.__comm__.RF.Eat:InvokeServer(unpack(args))
			end
		end
	})
end)

spawn(function()
	local Enabled, Selected = false, nil
	local Animation = Tabs.Render:CreateToggle({
		Name = "Animation",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					if Selected == "Eternal1" then
						KillAuraAnimation = {
							{CFrame = CFrame.new(0, 0, 1.5) * CFrame.Angles(math.rad(-35), math.rad(50), math.rad(110)), Time = 0.15},
							{CFrame = CFrame.new(0, 0.8, 1.0) * CFrame.Angles(math.rad(-65), math.rad(50), math.rad(110)), Time = 0.15}
						}
					elseif Selected == "Eternal2" then
						KillAuraAnimation = {
							{CFrame = CFrame.new(-2.5, 0, 3.5) * CFrame.Angles(math.rad(0), math.rad(25), math.rad(60)), Time = 0.1},
							{CFrame = CFrame.new(-0.5, 0, 1.3) * CFrame.Angles(math.rad(0), math.rad(25), math.rad(60)), Time = 0.1}
						}
					end
				until not Enabled
				KillAuraAnimation = nil
			end
		end
	})
	local CustomAnimations = Animation:CreateDropdown({
		Name = "Animations",
		List = {"Eternal1", "Eternal2"},
		Default = "Eternal1",
		Callback = function(callback)
			if callback then
				Selected = callback
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
					task.wait()
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
					task.wait()
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

spawn(function()
	local Enabled = false
	local function CreateESP(player)
		if player ~= LocalPlayer and IsAlive(player) then
			local BillboardGui = player.Character:FindFirstChild("2DESP")
			if not BillboardGui then
				local BillboardGui = Instance.new("BillboardGui")
				local Frame = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local UIStroke = Instance.new("UIStroke")

				BillboardGui.Parent = player.Character
				BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				BillboardGui.Active = true
				BillboardGui.AlwaysOnTop = true
				BillboardGui.Name = "2DESP"
				BillboardGui.LightInfluence = 1.000
				BillboardGui.Size = UDim2.new(4.5, 0, 5.5, 0)

				Frame.Parent = BillboardGui
				Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				Frame.BackgroundTransparency = 1
				Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Frame.BorderSizePixel = 0
				Frame.Size = UDim2.new(1, 0, 1, 0)

				UICorner.CornerRadius = UDim.new(0.219999999, 0)
				UICorner.Parent = Frame

				UIStroke.Parent = Frame
				UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
				UIStroke.LineJoinMode = Enum.LineJoinMode.Bevel
				UIStroke.Transparency = 0.25
				UIStroke.Thickness = 0.025
				UIStroke.Color = Color3.fromRGB(255, 255, 255)
			end
		end
	end

	local function RemoveESP(player)
		if player ~= LocalPlayer and IsAlive(player) then
			local BillboardGui = player.Character:FindFirstChild("2DESP")
			if BillboardGui then
				BillboardGui:Destroy()
			end
		end
	end

	local ESP = Tabs.Render:CreateToggle({
		Name = "ESP",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					Players.PlayerAdded:Connect(CreateESP)
					Players.PlayerRemoving:Connect(RemoveESP)
					for _, v in pairs(Players:GetPlayers()) do
						CreateESP(v)
					end
				until not Enabled
				for _, v in pairs(Players:GetPlayers()) do
					RemoveESP(v)
				end
			end
		end
	})
end)


spawn(function()
	local Enabled, Player, PlayerName, PlayerHumanoid, PlayerImage  = false, nil, nil, nil, nil
	local TargetHUD = Tabs.Render:CreateToggle({
		Name = "TargetHUD",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					Player = GetPlayer(KillAuraDistance, KillAuraPlayerModes)
					if Player and IsAlive(Player) then
						PlayerName = Player.Name
						PlayerHumanoid = Player.Character:FindFirstChildOfClass("Humanoid")
						PlayerImage = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size48x48)
						Main:TargetHud(PlayerName, PlayerImage, PlayerHumanoid, Humanoid, Enabled)
					end
				until not Enabled
				Player, PlayerName, PlayerHumanoid, PlayerImage  = nil, nil, nil, nil
				Main:TargetHud(PlayerName, PlayerImage, PlayerHumanoid, Humanoid, Enabled)
			end
		end
	})
end)

--[[
spawn(function()
	local ToolsView = GetToolsViewmodel()
	local Enabled = false
	local ToolsPosition = {
		Original = {
			OriginalX = ToolsView.Position.X,
			OriginalY = ToolsView.Position.Y,
			OriginalZ = ToolsView.Position.Z 
		},
		Modified = {
			NewX = ToolsView.Position.X or 0,
			NewY = ToolsView.Position.Y or 0,
			NewZ = ToolsView.Position.Z or 0
		}
	}
	local Viewmodel = Tabs.Render:CreateToggle({
		Name = "Viewmodel",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					wait()
					local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
					if Tool and ToolsView then
						if shared.OriginalC0 then
							ToolsView.C0 = shared.OriginalC0 * CFrame.new(ToolsPosition.Modified.NewX, ToolsPosition.Modified.NewY, ToolsPosition.Modified.NewZ)
						end
					end
				until not Enabled
				ToolsView.C0 = shared.OriginalC0
			end
		end
	})
	local CustomX = Viewmodel:CreateSlider({
		Name = "X",
		Min = 0,
		Max = 100,
		Default = ToolsPosition.Original.OriginalX,
		Callback = function(callback)
			ToolsPosition.Modified.NewX = callback
		end
	})
	local CustomY = Viewmodel:CreateSlider({
		Name = "Y",
		Min = 0,
		Max = 100,
		Default = ToolsPosition.Original.OriginalY,
		Callback = function(callback)
			ToolsPosition.Modified.NewY = callback
		end
	})
	local CustomZ = Viewmodel:CreateSlider({
		Name = "Z",
		Min = 0,
		Max = 100,
		Default = ToolsPosition.Original.OriginalZ,
		Callback = function(callback)
			ToolsPosition.Modified.NewZ = callback
		end
	})
end)
--]]

spawn(function()
	local Enabled, Distance, PlayerModes = false, nil, nil
	local BowAura = Tabs.Exploit:CreateToggle({
		Name = "BowAura",
		Callback = function(callback)
			Enabled = callback
			if callback then
				repeat
					task.wait()
					local Player = GetPlayer(Distance, PlayerModes)
					if Player then
						local Bow = CheckTools("Bow")
						if Bow then
							local args = {
								[1] = Player.Character:FindFirstChild("HumanoidRootPart").Position,
								[2] = 5.9958127420395613
							}
							Bow:WaitForChild("__comm__"):WaitForChild("RF"):FindFirstChild("Fire"):InvokeServer(unpack(args))
						end
					end
				until not Enabled
			end
		end
	})
	local CustomDistance = BowAura:CreateSlider({
		Name = "Distance",
		Min = 0,
		Max = 100,
		Default = 50,
		Callback = function(callback)
			if callback then
				Distance = callback
			end
		end
	})
	local CustomPlayerModes = BowAura:CreateDropdown({
		Name = "PlayerMode",
		List = {"Distance", "Health"},
		Default = "Distance",
		Callback = function(callback)
			if callback then
				PlayerModes = callback
			end
		end
	})
end)
