local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local MainFolder = "Eternal"
local ConfigFolder = MainFolder .. "/config"
local LogsFolder = MainFolder .. "/logs"
local Settings = {
	Tabs = {
		ToggleButton = {
			MiniToggle = {}
		}
	}
}

function LoadSettings(path)
	if isfile(path) then
		return HttpService:JSONDecode(readfile(path))
	else
		return nil
	end
end

function SaveSettings(path, settings)
	writefile(path, HttpService:JSONEncode(settings))
end

if isfolder(MainFolder) and isfolder(ConfigFolder) and isfolder(LogsFolder) then
	local FileMain = ConfigFolder .. "/" .. game.PlaceId .. ".json"
	local LoadedSettings = LoadSettings(FileMain)
	if LoadedSettings then
		Settings = LoadedSettings
	end
	AutoSave = true

	spawn(function()
		while AutoSave do
			wait(3)
			SaveSettings(FileMain, Settings)
		end
	end)
end

function Spoof(length)
	local Letter = {}
	for i = 1, length do
		local RandomLetter = string.char(math.random(97, 122))
		table.insert(Letter, RandomLetter)
	end
	return table.concat(Letter)
end

function FadeEffect(object, properties)
	local TweenProperties = TweenInfo.new(properties.time or 0.4, properties.easingStyle or Enum.EasingStyle.Quad, properties.easingDirection or Enum.EasingDirection.Out)
	local TweenAnim = TweenService:Create(object, TweenProperties, properties)
	TweenAnim:Play()
end

function MakeDraggable(gui)
	local dragging, dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

local Library = {
	Settings = {
		CurrentVersions = 1.2,
		ClientColor = Color3.fromRGB(255, 255, 255),
		MobileButtons = false,
	},
}

function Library:CreateCore()
	local Core = {}
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.ResetOnSpawn = false
	if RunService:IsStudio() or game.PlaceId == 11630038968 then
		ScreenGui.Name = "Eternal_" .. Library.Settings.CurrentVersions
		ScreenGui.Parent = PlayerGui
	else
		ScreenGui.Name = Spoof(math.random(18, 20))
		ScreenGui.Parent = CoreGui
	end
	
	local HudsFrame = Instance.new("Frame")
	HudsFrame.Parent = ScreenGui
	HudsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HudsFrame.BackgroundTransparency = 1.000
	HudsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HudsFrame.BorderSizePixel = 0
	HudsFrame.Size = UDim2.new(1, 0, 1, 0)
	HudsFrame.Visible = true
	HudsFrame.ZIndex = -1
	
	local TabsFrame = Instance.new("Frame")
	TabsFrame.Parent = ScreenGui
	TabsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabsFrame.BackgroundTransparency = 1.000
	TabsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabsFrame.BorderSizePixel = 0
	TabsFrame.Size = UDim2.new(1, 0, 1, 0)
	TabsFrame.Visible = false
	
	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = TabsFrame
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)
	
	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = TabsFrame
	UIPadding.PaddingLeft = UDim.new(0, 20)
	UIPadding.PaddingTop = UDim.new(0, 55)
	
	local ButtonsFrame = Instance.new("Frame")
	ButtonsFrame.Parent = ScreenGui
	ButtonsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ButtonsFrame.BackgroundTransparency = 1.000
	ButtonsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ButtonsFrame.BorderSizePixel = 0
	ButtonsFrame.Size = UDim2.new(1, 0, 1, 0)
	ButtonsFrame.Visible = true
	ButtonsFrame.ZIndex = -1
	
	local TrashCans = Instance.new("ImageLabel")
	TrashCans.Parent = ButtonsFrame
	TrashCans.AnchorPoint = Vector2.new(0.5, 0.5)
	TrashCans.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TrashCans.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TrashCans.BorderSizePixel = 0
	TrashCans.Position = UDim2.new(0.948977232, 0, 0.901647091, 0)
	TrashCans.Size = UDim2.new(0, 80, 0, 80)
	TrashCans.Visible = false
	TrashCans.Image = "rbxassetid://8463436236"
	
	local UICorner_10 = Instance.new("UICorner")
	UICorner_10.CornerRadius = UDim.new(0, 4)
	UICorner_10.Parent = TrashCans
	
	local OpenGui = Instance.new("TextButton")
	OpenGui.Parent = ScreenGui
	OpenGui.AnchorPoint = Vector2.new(0.5, 0.5)
	OpenGui.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	OpenGui.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OpenGui.BorderSizePixel = 0
	OpenGui.Position = UDim2.new(0.5, 0, 0.0450000018, 0)
	OpenGui.Size = UDim2.new(0, 18, 0, 18)
	OpenGui.ZIndex = -2
	OpenGui.Font = Enum.Font.SourceSans
	OpenGui.Text = "+"
	OpenGui.TextScaled = true
	OpenGui.TextSize = 14.000
	OpenGui.TextColor3 =  Library.Settings.ClientColor
	OpenGui.TextWrapped = true
	
	local UICorner_8 = Instance.new("UICorner")
	UICorner_8.CornerRadius = UDim.new(0, 4)
	UICorner_8.Parent = OpenGui
	
	local LogoFrame = Instance.new("Frame")
	LogoFrame.Parent = HudsFrame
	LogoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	LogoFrame.BackgroundTransparency = 0.180
	LogoFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoFrame.BorderSizePixel = 0
	LogoFrame.Position = UDim2.new(0.00932994019, 0, 0.0187969916, 0)
	LogoFrame.Size = UDim2.new(0, 155, 0, 22)

	local TopFrame = Instance.new("Frame")
	TopFrame.Parent = LogoFrame
	TopFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TopFrame.BorderSizePixel = 0
	TopFrame.Size = UDim2.new(1, 0, 0, 2)
	TopFrame.BackgroundColor3 =  Library.Settings.ClientColor

	local LogoText = Instance.new("TextLabel")
	LogoText.Parent = LogoFrame
	LogoText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoText.BackgroundTransparency = 1.000
	LogoText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoText.BorderSizePixel = 0
	LogoText.Position = UDim2.new(0.0299999993, 0, 0.100000001, 0)
	LogoText.Size = UDim2.new(1, 0, 0, 18)
	LogoText.Font = Enum.Font.SourceSans
	LogoText.Text = "Eternal " .. Library.Settings.CurrentVersions .. " | " .. game.Players.LocalPlayer.Name .. " | " .. game.PlaceId
	LogoText.TextSize = 14.000
	LogoText.TextWrapped = true
	LogoText.TextColor3 = Library.Settings.ClientColor
	LogoText.TextXAlignment = Enum.TextXAlignment.Left
	
	local NewLogoTextSize = game:GetService("TextService"):GetTextSize(LogoText.Text, LogoText.TextSize, LogoText.Font, Vector2.new(math.huge, math.huge))
	LogoFrame.Size = UDim2.new(0, NewLogoTextSize.X + 12, 0, 22)
	
	local ArraylistFrame = Instance.new("Frame")
	ArraylistFrame.Parent = HudsFrame
	ArraylistFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ArraylistFrame.BackgroundTransparency = 1.000
	ArraylistFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ArraylistFrame.BorderSizePixel = 0
	ArraylistFrame.Position = UDim2.new(0.799537122, 0, 0.0243661068, 0)
	ArraylistFrame.Size = UDim2.new(0.168943331, 0, 0.975633919, 0)
	
	local UIListLayout_7 = Instance.new("UIListLayout")
	UIListLayout_7.Parent = ArraylistFrame
	UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_7.HorizontalAlignment = Enum.HorizontalAlignment.Center
	
	local function AddArraylist(togglename)
		local Array = Instance.	new("TextLabel")
		Array.Name = togglename
		Array.Parent = ArraylistFrame
		Array.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Array.BackgroundTransparency = 1.000
		Array.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Array.BorderSizePixel = 0
		Array.Size = UDim2.new(1, 0, 0, 18)
		Array.Font = Enum.Font.SourceSans
		Array.Text = togglename
		Array.TextScaled = true
		Array.TextSize = 18.000
		Array.TextWrapped = true
		Array.TextXAlignment = Enum.TextXAlignment.Right
		Array.LayoutOrder = -#togglename
		Array.TextColor3 =  Library.Settings.ClientColor
	end
	
	local function RemoveArraylist(togglename)
		for i,v in pairs(ArraylistFrame:GetChildren()) do
			if v:IsA("TextLabel") and v.Name == togglename then
				v:Destroy()
			end
		end
	end
	
	OpenGui.MouseButton1Click:Connect(function()
		TabsFrame.Visible = not TabsFrame.Visible
		TrashCans.Visible = not TrashCans.Visible
	end)

	UserInputService.InputBegan:Connect(function(Input, isTyping)
		if Input.KeyCode == Enum.KeyCode.RightShift and not isTyping then
			TabsFrame.Visible = not TabsFrame.Visible
			TrashCans.Visible = not TrashCans.Visible
		end
	end)
	
	local TargetHudFrame = Instance.new("Frame")
	local TargetName = Instance.new("TextLabel")
	local FightResult = Instance.new("TextLabel")
	local HealthBack = Instance.new("Frame")
	local HealthFront = Instance.new("Frame")
	local TargetPicture = Instance.new("ImageLabel")
	
	function Core:CreateTargetHud(TargetHud)
		TargetHud = {
			TargetName = TargetHud.TargetName,
			TargetImage = TargetHud.TargetImage,
			TargetHumanoid = TargetHud.TargetHumanoid,
			PlayerHumanoid = TargetHud.PlayerHumanoid,
			HudVisible = TargetHud.HudVisible
		}
		TargetHudFrame.Parent = HudsFrame
		TargetHudFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		TargetHudFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TargetHudFrame.BackgroundTransparency = 0.350
		TargetHudFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TargetHudFrame.BorderSizePixel = 0
		TargetHudFrame.Position = UDim2.new(0.6, 0, 0.63, 0)
		TargetHudFrame.Size = UDim2.new(0, 165, 0, 50)
		
		TargetName.Parent = TargetHudFrame
		TargetName.AnchorPoint = Vector2.new(0.5, 0.5)
		TargetName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TargetName.BackgroundTransparency = 1.000
		TargetName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TargetName.BorderSizePixel = 0
		TargetName.Position = UDim2.new(0.626893938, 0, 0.25, 0)
		TargetName.Size = UDim2.new(0, 112, 0, 14)
		TargetName.Font = Enum.Font.SourceSans
		TargetName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TargetName.TextScaled = true
		TargetName.TextSize = 14.000
		TargetName.TextWrapped = true
		TargetName.TextXAlignment = Enum.TextXAlignment.Left
		
		FightResult.Parent = TargetHudFrame
		FightResult.AnchorPoint = Vector2.new(0.5, 0.5)
		FightResult.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		FightResult.BackgroundTransparency = 1.000
		FightResult.BorderColor3 = Color3.fromRGB(0, 0, 0)
		FightResult.BorderSizePixel = 0
		FightResult.Position = UDim2.new(0.6280303, 0, 0.5, 0)
		FightResult.Size = UDim2.new(0, 112, 0, 14)
		FightResult.Font = Enum.Font.SourceSans
		FightResult.TextColor3 = Color3.fromRGB(255, 255, 255)
		FightResult.TextScaled = true
		FightResult.TextSize = 14.000
		FightResult.TextWrapped = true
		FightResult.TextXAlignment = Enum.TextXAlignment.Left
		
		HealthBack.Parent = TargetHudFrame
		HealthBack.AnchorPoint = Vector2.new(0.5, 0.5)
		HealthBack.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
		HealthBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
		HealthBack.BorderSizePixel = 0
		HealthBack.Position = UDim2.new(0.5, 0, 0.850000024, 0)
		HealthBack.Size = UDim2.new(0, 155, 0, 5)
		
		HealthFront.Parent = HealthBack
		HealthFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
		HealthFront.BorderSizePixel = 0
		HealthFront.Size = UDim2.new(0, 155, 0, 5)
		HealthFront.BackgroundColor3 =  Library.Settings.ClientColor
		
		TargetPicture.Parent = TargetHudFrame
		TargetPicture.AnchorPoint = Vector2.new(0.5, 0.5)
		TargetPicture.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TargetPicture.BackgroundTransparency = 1.000
		TargetPicture.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TargetPicture.BorderSizePixel = 0
		TargetPicture.Position = UDim2.new(0.150000006, 0, 0.400000006, 0)
		TargetPicture.Size = UDim2.new(0, 28, 0, 28)
		
		TargetHudFrame.Visible = TargetHud.HudVisible
		TargetName.Text = TargetHud.TargetName
		if TargetHud.PlayerHumanoid and TargetHud.TargetHumanoid then
			if TargetHud.PlayerHumanoid.Health > TargetHud.TargetHumanoid.Health then
				FightResult.Text = "Winning"
			elseif TargetHud.PlayerHumanoid.Health < TargetHud.TargetHumanoid.Health then
				FightResult.Text = "Losing"
			else
				FightResult.Text = "Tie"
			end
		end
		TargetPicture.Image = TargetHud.TargetImage
		HealthFront.Size = UDim2.new(TargetHud.TargetHumanoid.Health / TargetHud.TargetHumanoid.MaxHealth, 0, 1, 0)
		return TargetHud
	end
	
	function Core:CreateTab(Tab)
		Tab = {
			Name = Tab.Name,
			ZSettings = Tab.ZSettings
		}
		if not Settings[Tab.Name] then
			Settings[Tab.Name] = {
				Name = Tab.Name,
				ZSettings = Tab.ZSettings
			}
		else
			Tab.Name = Settings[Tab.Name].Name
			Tab.ZSettings = Settings[Tab.Name].ZSettings
		end
		
		local TabHolder = Instance.new("Frame")
		TabHolder.Name = Tab.Name
		TabHolder.Parent = TabsFrame
		TabHolder.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
		TabHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabHolder.BorderSizePixel = 0
		TabHolder.Size = UDim2.new(0, 118, 0, 25)
		
		local TabName = Instance.new("TextLabel")
		TabName.Parent = TabHolder
		TabName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabName.BackgroundTransparency = 1.000
		TabName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabName.BorderSizePixel = 0
		TabName.Size = UDim2.new(1, 0, 1, 0)
		TabName.Font = Enum.Font.SourceSans
		TabName.Text = Tab.Name
		TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabName.TextScaled = true
		TabName.TextSize = 14.000
		TabName.TextWrapped = true
		
		local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
		UITextSizeConstraint.Parent = TabName
		UITextSizeConstraint.MaxTextSize = 14
		
		local TogglesList = Instance.new("Frame")
		TogglesList.Parent = TabHolder
		TogglesList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TogglesList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TogglesList.BorderSizePixel = 0
		TogglesList.BackgroundTransparency = 1
		TogglesList.Position = UDim2.new(0, 0, 1, 0)
		TogglesList.Size = UDim2.new(1, 0, -6.24980021, 211)
		
		local UIListLayout_2 = Instance	.new("UIListLayout")
		UIListLayout_2.Parent = TogglesList
		
		local ZASettings = Instance.new("Frame")
		ZASettings.Name = "ZASettingsssssssssssssssssssssssssssssssss"
		ZASettings.Parent = TogglesList
		ZASettings.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		ZASettings.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ZASettings.BorderSizePixel = 0
		ZASettings.Size = UDim2.new(1, 0, 0, 22)
		ZASettings.Visible = false
		
		local OpenSettings = Instance.new("TextButton")
		OpenSettings.Parent = ZASettings
		OpenSettings.AnchorPoint = Vector2.new(0.5, 0.5)
		OpenSettings.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		OpenSettings.BackgroundTransparency = 1.000
		OpenSettings.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OpenSettings.BorderSizePixel = 0
		OpenSettings.Position = UDim2.new(0.899999976, 0, 0.5, 0)
		OpenSettings.Size = UDim2.new(0, 18, 0, 18)
		OpenSettings.Font = Enum.Font.SourceSans
		OpenSettings.Text = "+"
		OpenSettings.TextColor3 = Color3.fromRGB(255, 255, 255)
		OpenSettings.TextScaled = true
		OpenSettings.TextSize = 14.000
		OpenSettings.TextWrapped = true
		
		local SettingsName = Instance.new("TextLabel")
		SettingsName.Parent = ZASettings
		SettingsName.AnchorPoint = Vector2.new(0.5, 0.5)
		SettingsName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SettingsName.BackgroundTransparency = 1.000
		SettingsName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SettingsName.BorderSizePixel = 0
		SettingsName.Position = UDim2.new(0.5, 0, 0.5, 0)
		SettingsName.Size = UDim2.new(0, 80, 0, 15)
		SettingsName.Font = Enum.Font.SourceSans
		SettingsName.Text = "Client Settings"
		SettingsName.TextColor3 = Color3.fromRGB(255, 255, 255)
		SettingsName.TextSize = 13.000
		SettingsName.TextXAlignment = Enum.TextXAlignment.Left
		
		local ZMenuOpened = false
		local ZMenu = Instance.new("Frame")
		ZMenu.Name = "ZMenuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"
		ZMenu.Parent = TogglesList
		ZMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		ZMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ZMenu.BorderSizePixel = 0
		ZMenu.LayoutOrder = 1
		ZMenu.Position = UDim2.new(0, 0, 0.497959971, 0)
		ZMenu.Size = UDim2.new(1, 0, 0, 65)
		ZMenu.Visible = false
		
		local SettingsList = Instance.new("ScrollingFrame")
		SettingsList.Parent = ZMenu
		SettingsList.Active = true
		SettingsList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SettingsList.BackgroundTransparency = 1.000
		SettingsList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SettingsList.BorderSizePixel = 0
		SettingsList.Size = UDim2.new(1, 0, 1, 0)
		SettingsList.ScrollBarThickness = 4
		SettingsList.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
		SettingsList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
		
		local UIListLayout_6 = Instance.new("UIListLayout")
		UIListLayout_6.Parent = SettingsList
		UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
		
		local MobileSupport = Instance.new("TextButton")
		MobileSupport.Parent = SettingsList
		MobileSupport.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MobileSupport.BackgroundTransparency = 1.000
		MobileSupport.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MobileSupport.BorderSizePixel = 0
		MobileSupport.Size = UDim2.new(1, 0, 0, 23)
		MobileSupport.AutoButtonColor = false
		MobileSupport.Font = Enum.Font.SourceSans
		MobileSupport.Text = ""
		MobileSupport.TextColor3 = Color3.fromRGB(0, 0, 0)
		MobileSupport.TextSize = 14.000
		
		local MobileSupportName = Instance.new("TextLabel")
		MobileSupportName.Parent = MobileSupport
		MobileSupportName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		MobileSupportName.BackgroundTransparency = 1.000
		MobileSupportName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MobileSupportName.BorderSizePixel = 0
		MobileSupportName.Position = UDim2.new(0.200000003, 0, 0.158999994, 0)
		MobileSupportName.Size = UDim2.new(0, 80, 0, 15)
		MobileSupportName.Font = Enum.Font.SourceSans
		MobileSupportName.Text = "Mobile Buttons"
		MobileSupportName.TextColor3 = Color3.fromRGB(255, 255, 255)
		MobileSupportName.TextSize = 13.000
		MobileSupportName.TextXAlignment = Enum.TextXAlignment.Left
		
		local MobileSupportEnabled = false
		local MobileSupportStatus = Instance.new("Frame")
		MobileSupportStatus.Parent = MobileSupport
		MobileSupportStatus.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
		MobileSupportStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MobileSupportStatus.BorderSizePixel = 0
		MobileSupportStatus.Position = UDim2.new(0.075000003, 0, 0.254000008, 0)
		MobileSupportStatus.Size = UDim2.new(0, 10, 0, 10)
		
		local UICorner_99 = Instance.new("UICorner")
		UICorner_99.CornerRadius = UDim.new(0, 3)
		UICorner_99.Parent = MobileSupportStatus
		
		MobileSupport.MouseButton1Click:Connect(function()
			MobileSupportEnabled = not MobileSupportEnabled
			if MobileSupportEnabled then
				Library.Settings.MobileButtons = true
				FadeEffect(MobileSupportStatus, {BackgroundColor3 = Color3.fromRGB(0, 175, 0)})
			else
				Library.Settings.MobileButtons = false
				FadeEffect(MobileSupportStatus, {BackgroundColor3 = Color3.fromRGB(175, 0, 0)})
			end
		end)
		
		if Tab.ZSettings then
			ZASettings.Visible = true
		end
		
		OpenSettings.MouseButton1Click:Connect(function()
			ZMenuOpened = not ZMenuOpened
			if ZMenuOpened then
				ZMenu.Visible = true
				OpenSettings.Text = "-"
			else
				ZMenu.Visible = false
				OpenSettings.Text = "+"
			end
		end)
		
		function Tab:CreateToggle(ToggleButton)
			ToggleButton = {
				Name = ToggleButton.Name,
				Enabled = ToggleButton.Enabled,
				Keybind = ToggleButton.Keybind or "Insert",
				Callback = ToggleButton.Callback or function() end
			}
			if not Settings.Tabs.ToggleButton[ToggleButton.Name] then
				Settings.Tabs.ToggleButton[ToggleButton.Name] = {
					Enabled = ToggleButton.Enabled,
					Keybind = ToggleButton.Keybind
				}
			else
				ToggleButton.Enabled = Settings.Tabs.ToggleButton[ToggleButton.Name].Enabled
				ToggleButton.Keybind = Settings.Tabs.ToggleButton[ToggleButton.Name].Keybind
			end
			
			local ToggleButtonHolder = Instance.new("TextButton")
			ToggleButtonHolder.Name = ToggleButton.Name
			ToggleButtonHolder.Parent = TogglesList
			ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			ToggleButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.BorderSizePixel = 0
			ToggleButtonHolder.LayoutOrder = 1
			ToggleButtonHolder.Position = UDim2.new(0.0169491526, 0, 0.615238428, 0)
			ToggleButtonHolder.Size = UDim2.new(1, 0, 0, 27)
			ToggleButtonHolder.AutoButtonColor = false
			ToggleButtonHolder.Font = Enum.Font.SourceSans
			ToggleButtonHolder.Text = ""
			ToggleButtonHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.TextSize = 14.000
			
			local ToggleButtonName = Instance.new("TextLabel")
			ToggleButtonName.Parent = ToggleButtonHolder
			ToggleButtonName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleButtonName.BackgroundTransparency = 1.000
			ToggleButtonName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonName.BorderSizePixel = 0
			ToggleButtonName.Position = UDim2.new(0.180000007, 0, 0.158999994, 0)
			ToggleButtonName.Size = UDim2.new(0, 80, 0, 15)
			ToggleButtonName.Font = Enum.Font.SourceSans
			ToggleButtonName.Text = ToggleButton.Name
			ToggleButtonName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleButtonName.TextSize = 13.000
			ToggleButtonName.TextXAlignment = Enum.TextXAlignment.Left
			
			local ToggleButtonStatus = Instance.new("Frame")
			ToggleButtonStatus.Parent = ToggleButtonHolder
			ToggleButtonStatus.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
			ToggleButtonStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonStatus.BorderSizePixel = 0
			ToggleButtonStatus.Position = UDim2.new(0.0508474559, 0, 0.254365265, 0)
			ToggleButtonStatus.Size = UDim2.new(0, 10, 0, 10)
			
			local UICorner_3 = Instance.new("UICorner")
			UICorner_3.CornerRadius = UDim.new(0, 3)
			UICorner_3.Parent = ToggleButtonStatus
			
			local OpenToggleMenu = Instance.new("TextButton")
			OpenToggleMenu.Parent = ToggleButtonHolder
			OpenToggleMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OpenToggleMenu.BackgroundTransparency = 1.000
			OpenToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OpenToggleMenu.BorderSizePixel = 0
			OpenToggleMenu.Position = UDim2.new(0.829999983, 0, 0.150999993, 0)
			OpenToggleMenu.Size = UDim2.new(0, 18, 0, 18)
			OpenToggleMenu.Font = Enum.Font.SourceSans
			OpenToggleMenu.Text = "+"
			OpenToggleMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
			OpenToggleMenu.TextScaled = true
			OpenToggleMenu.TextSize = 14.000
			OpenToggleMenu.TextWrapped = true
			
			local ToggleMenu = Instance.new("Frame")
			ToggleMenu.Name = ToggleButton.Name .. "ZMenu"
			ToggleMenu.Parent = TogglesList
			ToggleMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			ToggleMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleMenu.BorderSizePixel = 0
			ToggleMenu.LayoutOrder = 1
			ToggleMenu.Position = UDim2.new(0, 0, 0.497959971, 0)
			ToggleMenu.Size = UDim2.new(1, 0, 0, 65)
			ToggleMenu.Visible = false
			
			local MenuList = Instance.new("ScrollingFrame")
			MenuList.Parent = ToggleMenu
			MenuList.Active = true
			MenuList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			MenuList.BackgroundTransparency = 1.000
			MenuList.BorderColor3 = Color3.fromRGB(0, 0, 0)
			MenuList.BorderSizePixel = 0
			MenuList.Size = UDim2.new(1, 0, 0, 50)
			MenuList.ScrollBarThickness = 4
			MenuList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
			MenuList.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
			
			local UIListLayout_5 = Instance.new("UIListLayout")
			UIListLayout_5.Parent = MenuList
			UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
			
			local ToggleKeybinds = Instance.new("TextBox")
			ToggleKeybinds.Parent = ToggleMenu
			ToggleKeybinds.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			ToggleKeybinds.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleKeybinds.BorderSizePixel = 0
			ToggleKeybinds.Position = UDim2.new(0, 0, 0.786514044, 0)
			ToggleKeybinds.Size = UDim2.new(1, 0, -0.13670516, 23)
			ToggleKeybinds.Font = Enum.Font.SourceSans
			ToggleKeybinds.PlaceholderText = "None"
			ToggleKeybinds.Text = ""
			ToggleKeybinds.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleKeybinds.TextSize = 14.000
			UserInputService.InputBegan:Connect(function(Input, isTyping)
				if Input.UserInputType == Enum.UserInputType.Keyboard then
					if ToggleKeybinds:IsFocused() then
						ToggleButton.Keybind = Input.KeyCode.Name
						ToggleKeybinds.Text = Input.KeyCode.Name
						ToggleKeybinds.PlaceholderText = Input.KeyCode.Name
						ToggleKeybinds:ReleaseFocus()
						Settings.Tabs.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
					end       
				end
			end)
			
			local function OnToggle()
				if ToggleButton.Enabled then
					FadeEffect(ToggleButtonStatus, {BackgroundColor3 = Color3.fromRGB(0, 175, 0)})
					AddArraylist(ToggleButton.Name)
					Settings.Tabs.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
				else
					FadeEffect(ToggleButtonStatus, {BackgroundColor3 = Color3.fromRGB(175, 0, 0)})
					RemoveArraylist(ToggleButton.Name)
					Settings.Tabs.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
				end
			end
			
			local function CreateButtons(name)	
				local MobileButtonz = Instance.new("TextButton")
				MobileButtonz.AnchorPoint = Vector2.new(0, 5)
				MobileButtonz.Parent = ButtonsFrame
				MobileButtonz.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
				MobileButtonz.BackgroundTransparency = 0.45
				MobileButtonz.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MobileButtonz.BorderSizePixel = 0
				MobileButtonz.Size = UDim2.new(0, 42, 0, 42)
				MobileButtonz.Font = Enum.Font.SourceSans
				MobileButtonz.Text = name
				MobileButtonz.Position = UDim2.new(0.5, 0, 0.5, 0)
				MobileButtonz.TextColor3 = Color3.fromRGB(0, 0, 0)
				MobileButtonz.TextScaled = true
				MobileButtonz.TextSize = 14.000
				MobileButtonz.TextWrapped = true
				MakeDraggable(MobileButtonz)

				local function OnButtons()
					if ToggleButton.Enabled then
						FadeEffect(MobileButtonz, {BackgroundColor3 = Color3.fromRGB(0, 175, 0)})
						Settings.Tabs.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					else
						FadeEffect(MobileButtonz, {BackgroundColor3 = Color3.fromRGB(175, 0, 0)})
						Settings.Tabs.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					end
				end

				local function TrashcanCheck()
					local CheckX = MobileButtonz.AbsolutePosition.X >= TrashCans.AbsolutePosition.X and MobileButtonz.AbsolutePosition.X + MobileButtonz.AbsoluteSize.X <= TrashCans.AbsolutePosition.X + TrashCans.AbsoluteSize.X
					local CheckY = MobileButtonz.AbsolutePosition.Y >= TrashCans.AbsolutePosition.Y and MobileButtonz.AbsolutePosition.Y + MobileButtonz.AbsoluteSize.Y <= TrashCans.AbsolutePosition.Y + TrashCans.AbsoluteSize.Y
					return CheckX and CheckY
				end

				local UICorner = Instance.new("UICorner")
				UICorner.CornerRadius = UDim.new(1, 0)
				UICorner.Parent = MobileButtonz

				MobileButtonz.MouseButton1Click:Connect(function()
					ToggleButton.Enabled = not ToggleButton.Enabled
					OnButtons()
					OnToggle()

					if ToggleButton.Callback then
						ToggleButton.Callback(ToggleButton.Enabled)
					end
				end)
				
				spawn(function()
					while true do
						wait()
						if TrashCans.Visible and TrashcanCheck() then
							MobileButtonz:Destroy()
						end
					end
				end)
			end

			ToggleButtonHolder.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				OnToggle()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end)

			ToggleButtonHolder.MouseButton2Click:Connect(function()
				ToggleMenu.Visible = not ToggleMenu.Visible
			end)

			local HoldTime = 3
			local Holding = false
			ToggleButtonHolder.MouseButton1Down:Connect(function()
				if Library.Settings.MobileButtons then
					Holding = true
					wait(HoldTime)
					if Holding then
						CreateButtons(ToggleButton.Name)
					end
				end
			end)

			ToggleButtonHolder.MouseButton1Up:Connect(function()
				Holding = false
			end)
			
			local MenuOpened = false
			OpenToggleMenu.MouseButton1Click:Connect(function()
				MenuOpened = not MenuOpened
				if MenuOpened then
					ToggleMenu.Visible = true
					OpenToggleMenu.Text = "-"
				else
					ToggleMenu.Visible = false
					OpenToggleMenu.Text = "+"
				end
			end)

			if ToggleButton.Keybind then
				UserInputService.InputBegan:Connect(function(Input, isTyping)
					if Input.KeyCode == Enum.KeyCode[ToggleButton.Keybind] and not isTyping then
						ToggleButton.Enabled = not ToggleButton.Enabled
						OnToggle()

						if ToggleButton.Callback then
							ToggleButton.Callback(ToggleButton.Enabled)
						end
					end
				end)
			end

			if ToggleButton.Enabled then
				ToggleButton.Enabled = true
				OnToggle()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end
			
			function ToggleButton:CreateMiniToggle(MiniToggle)
				MiniToggle = {
					Name = MiniToggle.Name,
					Enabled = MiniToggle.Enabled,
					Callback = MiniToggle.Callback or function() end
				}
				if not Settings.Tabs.ToggleButton.MiniToggle[MiniToggle.Name] then
					Settings.Tabs.ToggleButton.MiniToggle[MiniToggle.Name] = {
						Enabled = MiniToggle.Enabled
					}
				else
					MiniToggle.Enabled = Settings.Tabs.ToggleButton.MiniToggle[MiniToggle.Name].Enabled
				end
				
				local MiniToggleHolder = Instance.new("TextButton")
				MiniToggleHolder.Parent = MenuList
				MiniToggleHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleHolder.BackgroundTransparency = 1.000
				MiniToggleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolder.BorderSizePixel = 0
				MiniToggleHolder.Size = UDim2.new(1, 0, 0, 23)
				MiniToggleHolder.AutoButtonColor = false
				MiniToggleHolder.Font = Enum.Font.SourceSans
				MiniToggleHolder.Name = MiniToggle.Name
				MiniToggleHolder.Text = ""
				MiniToggleHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleHolder.TextSize = 14.000
				
				local MiniToggleName = Instance.new("TextLabel")
				MiniToggleName.Parent = MiniToggleHolder
				MiniToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleName.BackgroundTransparency = 1.000
				MiniToggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleName.BorderSizePixel = 0
				MiniToggleName.Position = UDim2.new(0.200000003, 0, 0.158999994, 0)
				MiniToggleName.Size = UDim2.new(0, 80, 0, 15)
				MiniToggleName.Font = Enum.Font.SourceSans
				MiniToggleName.Text = MiniToggle.Name
				MiniToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
				MiniToggleName.TextSize = 13.000
				MiniToggleName.TextXAlignment = Enum.TextXAlignment.Left
				
				local MiniToggleStatus = Instance.new("Frame")
				MiniToggleStatus.Parent = MiniToggleHolder
				MiniToggleStatus.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
				MiniToggleStatus.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleStatus.BorderSizePixel = 0
				MiniToggleStatus.Position = UDim2.new(0.075000003, 0, 0.254000008, 0)
				MiniToggleStatus.Size = UDim2.new(0, 10, 0, 10)
				
				local UICorner_92 = Instance.new("UICorner")
				UICorner_92.CornerRadius = UDim.new(0, 3)
				UICorner_92.Parent = MiniToggleStatus

				local function OnMiniToggle()
					if MiniToggle.Enabled then
						FadeEffect(MiniToggleStatus, {BackgroundColor3 = Color3.fromRGB(0, 175, 0)})
						Settings.Tabs.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
					else
						FadeEffect(MiniToggleStatus, {BackgroundColor3 = Color3.fromRGB(175, 0, 0)})
						Settings.Tabs.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
					end
				end

				MiniToggleHolder.MouseButton1Click:Connect(function()
					MiniToggle.Enabled = not MiniToggle.Enabled
					OnMiniToggle()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end)

				if MiniToggle.Enabled then
					MiniToggle.Enabled = true
					OnMiniToggle()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end
				return MiniToggle
			end
			
			function ToggleButton:CreateSlider(Slider)
				Slider = {
					Name = Slider.Name,
					Min = Slider.Min,
					Max = Slider.Max,
					Callback = Slider.Callback or function() 
					end
				}

				local Value
				local Dragged = false

				local Sliderz = Instance.new("Frame")
				Sliderz.Name = Slider.Name
				Sliderz.Parent = MenuList
				Sliderz.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Sliderz.BackgroundTransparency = 1.000
				Sliderz.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Sliderz.BorderSizePixel = 0
				Sliderz.Size = UDim2.new(1, 0, 0, 25)

				local SliderName = Instance.new("TextLabel")
				SliderName.Parent = Sliderz
				SliderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderName.BackgroundTransparency = 1.000
				SliderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderName.BorderSizePixel = 0
				SliderName.Position = UDim2.new(0.100000001, 0, 0.180000007, 0)
				SliderName.Size = UDim2.new(0, 80, 0, 8)
				SliderName.Font = Enum.Font.SourceSans
				SliderName.Text = Slider.Name
				SliderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderName.TextSize = 13.000
				SliderName.TextXAlignment = Enum.TextXAlignment.Left

				local SliderBack = Instance.new("Frame")
				SliderBack.Parent = Sliderz
				SliderBack.BackgroundColor3 = Color3.fromRGB(105, 85, 85)
				SliderBack.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderBack.BorderSizePixel = 0
				SliderBack.Position = UDim2.new(0.0850000009, 0, 0.800000012, 0)
				SliderBack.Size = UDim2.new(0, 100, 0, 2)

				local SliderFront = Instance.new("Frame")
				SliderFront.Parent = SliderBack
				SliderFront.BackgroundColor3 = Color3.fromRGB(89, 143, 77)
				SliderFront.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderFront.BorderSizePixel = 0
				SliderFront.Size = UDim2.new(0, 50, 0, 2)

				local SliderTriggerer = Instance.new("TextButton")
				SliderTriggerer.Parent = SliderFront
				SliderTriggerer.BackgroundColor3 = Color3.fromRGB(88, 117, 153)
				SliderTriggerer.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SliderTriggerer.BorderSizePixel = 0
				SliderTriggerer.Position = UDim2.new(1, 0, -0.899999976, 0)
				SliderTriggerer.Size = UDim2.new(0, 5, 0, 5)
				SliderTriggerer.Font = Enum.Font.SourceSans
				SliderTriggerer.Text = ""
				SliderTriggerer.TextColor3 = Color3.fromRGB(0, 0, 0)
				SliderTriggerer.TextSize = 14.000

				local function OnDragged(input)
					local InputPos = input.Position
					Value = math.clamp((InputPos.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
					local SliderValue = math.round(Value * Slider.Max)
					SliderFront.Size = UDim2.fromScale(Value, 1)

					Slider.Callback(SliderValue)
				end

				SliderTriggerer.MouseButton1Down:Connect(function()
					Dragged = true
				end)

				UserInputService.InputChanged:Connect(function(input)
					if Dragged and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						OnDragged(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						Dragged = false
					end
				end)
				return Slider
			end

			function ToggleButton:CreateDropdown(Dropdowns)
				Dropdowns = {
					Name = Dropdowns.Name,
					List = Dropdowns.List,
					Callback = Dropdowns.Callback or function() 
					end
				}

				local Dropdown = Instance.new("TextButton")
				Dropdown.Name = Dropdowns.Name
				Dropdown.Parent = MenuList
				Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Dropdown.BackgroundTransparency = 1.000
				Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Dropdown.BorderSizePixel = 0
				Dropdown.Size = UDim2.new(1, 0, 0, 23)
				Dropdown.Font = Enum.Font.SourceSans
				Dropdown.Text = ""
				Dropdown.TextColor3 = Color3.fromRGB(0, 0, 0)
				Dropdown.TextSize = 14.000

				local ModeText = Instance.new("TextLabel")
				ModeText.Parent = Dropdown
				ModeText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ModeText.BackgroundTransparency = 1.000
				ModeText.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ModeText.BorderSizePixel = 0
				ModeText.Position = UDim2.new(0.1, 0, 0.159, 0)
				ModeText.Size = UDim2.new(0, 30, 0, 15)
				ModeText.Font = Enum.Font.SourceSans
				ModeText.Text = "Mode:"
				ModeText.TextColor3 = Color3.fromRGB(255, 255, 255)
				ModeText.TextSize = 13.000
				ModeText.TextXAlignment = Enum.TextXAlignment.Left

				local SelectedText = Instance.new("TextLabel")
				SelectedText.Parent = Dropdown
				SelectedText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SelectedText.BackgroundTransparency = 1.000
				SelectedText.BorderColor3 = Color3.fromRGB(0, 0, 0)
				SelectedText.BorderSizePixel = 0
				SelectedText.Position = UDim2.new(0.35, 0, 0.159, 0)
				SelectedText.Size = UDim2.new(0, 68, 0, 15)
				SelectedText.Font = Enum.Font.SourceSans
				SelectedText.Text = "None"
				SelectedText.TextColor3 = Color3.fromRGB(255, 255, 255)
				SelectedText.TextSize = 13.000
				SelectedText.TextXAlignment = Enum.TextXAlignment.Left

				local CurrentDropdown = 1
				Dropdown.MouseButton1Click:Connect(function()
					SelectedText.Text = Dropdowns.List[CurrentDropdown]
					Dropdowns.Callback(Dropdowns.List[CurrentDropdown])
					CurrentDropdown = CurrentDropdown % #Dropdowns.List + 1
				end)

				return Dropdowns
			end
			return ToggleButton
		end		
		return Tab
	end
	return Core
end
return Library
