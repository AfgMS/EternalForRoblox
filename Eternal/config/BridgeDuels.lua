local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AfgMS/EternalForRoblox/main/Eternal/library.lua"))()
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

local function IsAlive(plr)
	return plr and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0.11
end

local function FindNearestPlayer(distance)
	local NearestPlayer = nil
	local MinDistance = math.huge

	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
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

--AutoSword
local KillAuraDistance = 28
local AutoSwordDelay
local AutoSword = Tabs.Combat:CreateToggle({
	Name = "AutoSword",
	Callback = function(callback)
		if callback then
			AutoSwordDelay = 0.1
			local Target = FindNearestPlayer(KillAuraDistance)
			local Sword = GetTool("Sword")
			if Target then
				while true do
					wait(AutoSwordDelay)
					Humanoid:EquipTool(Sword)
				end
			end
		else
			AutoSwordDelay = 86400
		end
	end
})
--Criticals
local SelectedCrit = nil
local PacketCrit = false
local JumpCrit = false
local Criticals = Tabs.Combat:CreateToggle({
	Name = "Criticals",
	Callback = function(callback)
		if callback then
			if SelectedCrit == "Packet" then
				print(LocalPlayer.Name .. " C0-11")
				PacketCrit = true
				JumpCrit = false
			elseif SelectedCrit == "Jump" then
				print(LocalPlayer.Name .. "Jumped")
				JumpCrit = true
				PacketCrit = false
			end
		end
	end
})
--KillAura
local KillAuraAutoBlock = nil
local KillAuraSwordSwing = true
local KillAura = Tabs.Combat:CreateToggle({
	Name = "KillAura",
	Callback = function(callback)
		if callback then
			local Target = FindNearestPlayer(KillAuraDistance)
			local Sword = GetTool("Sword")
			if Sword then
				local KillAuraSwingAnim = Sword:WaitForChild("Animations"):FindFirstChild("Swing")
				local KillAuraBlockAnim = Sword:WaitForChild("Animations"):FindFirstChild("Block")
					repeat
						task.wait()
						local args = {
							[1] = Target.Character,
							[2] = PacketCrit,
							[3] = Sword.Name
						}

						game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("AttackPlayerWithSword"):InvokeServer(unpack(args))
					if KillAuraSwingAnim then
						Humanoid:LoadAnimation(KillAuraSwingAnim):Play()
					end
					until not Sword
				if KillAuraAutoBlock == "Fake" then
					local args = {
						[1] = false,
						[2] = Sword.Name
					}

					game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
					Humanoid:LoadAnimation(KillAuraBlockAnim):Play()
				elseif KillAuraAutoBlock == "Packet" then
					local args = {
						[1] = true,
						[2] = Sword.Name
					}

					game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
				end
			end
		end
	end
})
