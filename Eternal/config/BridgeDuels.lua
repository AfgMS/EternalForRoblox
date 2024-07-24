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

local KillAuraCrit = false
local Criticals = Tabs.Combat:CreateToggle({
	Name = "Criticals",
	Enabled = true,
	Callback = function(callback)
		if callback then
			KillAuraCrit = not KillAuraCrit
		end
	end
})

local KillAuraEnabled = false
local KillAuraSwing = false
local KillAuraESP = Instance.new("Part", game.Workspace)
local ChooseBlockMode = "Fake"
local BlockAnim, SwingAnim
local KillAura = Tabs.Combat:CreateToggle({
	Name = "KillAura",
	Callback = function(callback)
		KillAuraEnabled = callback
		if callback then
			KillAuraEnabled = true
			repeat
				task.wait()
				if not IsAlive(LocalPlayer) then
					repeat
						task.wait()
					until IsAlive(LocalPlayer)
				end
				local NearestPlayer = GetNearestPlayer(KillAuraRange)
				if NearestPlayer then
					KillAuraESP.Shape = "Ball"
					KillAuraESP.Transparency = 0.45
					KillAuraESP.Size = Vector3.new(15, 15, 15)
					KillAuraESP.Position = NearestPlayer.Character:WaitForChild("Head").Position + Vector3.new(0, 2, 0)
					local Sword = GetTool("Sword")
					if Sword then
						BlockAnim = Sword:WaitForChild("Animations").BlockHit
						SwingAnim = Sword:WaitForChild("Animations").Swing
						if KillAuraSwing then
							Humanoid:LoadAnimation(SwingAnim):Play()
						end
						if ChooseBlockMode == "Fake" then
							Humanoid:LoadAnimation(BlockAnim):Play()
							local args = {
								[1] = false,
								[2] = Sword.Name
							}

							game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
						elseif ChooseBlockMode == "Packet" then
							Humanoid:LoadAnimation(BlockAnim):Stop()
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
			until not KillAuraEnabled
		end
	end
})
local KillAuraSwingMode = KillAura:CreateMiniToggle({
	Name = "NoSwing",
	Enabled = true,
	Callback = function(callback)
		KillAuraSwing = not KillAuraSwing
	end
})
local AutoBlockMode = KillAura:CreateDropdown({
	Name = "AutoBlockMode",
	List = {"Fake", "Packet"},
	Callback = function(callback)
		if callback then
			ChooseBlockMode = callback
		end
	end
})
