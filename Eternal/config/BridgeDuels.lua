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

local function DamagePlayer(plr, crit, tool)end

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
local PacketCrit = false
local JumpCri = false
local Criticals = Tabs.Combat:CreateToggle({
	Name = "Criticals",
	Callback = function(callback)
		if callback then
			if CriticalMode == "Packet" then
				PacketCrit = true
				JumpCri = false
			elseif CriticalMode == "Jump" then
				JumpCri = true
				PacketCrit = false
			end
		else
			PacketCrit = false
			JumpCri = false
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
local Sword = GetTool("Sword")
local ChoosedAutoBlock = nil
local KillAuraDistance
local TargetESP
local KillAura = Tabs.Combat:CreateToggle({
	Name = "KillAura",
	Callback = function(callback)
		if callback then
			KillAuraDistance = 28
			local Nearest = FindNearestPlayer(KillAuraDistance)
			if Nearest then
				if Sword then
					local KillAuraSwingAnim = Sword:WaitForChild("Animations"):FindFirstChild("Swing")
					local KillAuraBlockAnim = Sword:WaitForChild("Animations"):FindFirstChild("Block")
					
					if ChoosedAutoBlock == "Fake" then
						if KillAuraBlockAnim then
							print("Founded" .. KillAuraBlockAnim.Name)
							Humanoid:LoadAnimation(KillAuraBlockAnim):Play()
						end
						local args = {
							[1] = false,
							[2] = Sword
						}

						game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
					elseif ChoosedAutoBlock == "Packet" then
						local args = {
							[1] = true,
							[2] = Sword
						}

						game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
					elseif ChoosedAutoBlock == "Vanilla" then
						if KillAuraBlockAnim then
							print("Founded" .. KillAuraBlockAnim.Name)
							local args = {
								[1] = true,
								[2] = Sword
							}

							game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RF"):WaitForChild("ToggleBlockSword"):InvokeServer(unpack(args))
							Humanoid:LoadAnimation(KillAuraBlockAnim):Play()
						end
					end

					while true do
						wait(2)
						print("Target: " .. Nearest.Name .. " | Health:" .. Nearest.Character:FindFirstChildOfClass("Humanoid").Health)
					end
				end
			end
		else
				KillAuraDistance = 0
		end
	end
})
