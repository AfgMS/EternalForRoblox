local HttpService = game:GetService("HttpService")
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MainFolder = "Eternal"
local ConfigFolder = MainFolder .. "/config"
local LogsFolder = MainFolder .. "/logs"
local AutoSave = false
local Settings = {
	ToggleButton = {
		MiniToggle = {},
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

function Draggable(object)
	local gui = object

	local dragging
	local dragInput
	local dragStart
	local startPos

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

function Spoof(length)
	local Letter = {}
	for i = 1, length do
		local RandomLetter = string.char(math.random(97, 122))
		table.insert(Letter, RandomLetter)
	end
	return table.concat(Letter)
end

function TweenEffect(object, properties)
	local TweenProperties = TweenInfo.new(properties.time or 0.4, properties.easingStyle or Enum.EasingStyle.Quad, properties.easingDirection or Enum.EasingDirection.Out)
	local TweenAnim = TweenService:Create(object, TweenProperties, properties)
	TweenAnim:Play()
end

local Library = {
	LibraryVersion = 1.2,
	GuiColor = Color3.fromRGB(255, 255, 255), 
	MobileButtons = false
}

function Library:CreateCore()
	local Core = {}
	local Eternal = Instance.new("ScreenGui")
	Eternal.Name = Spoof(math.random(18, 20))
	Eternal.ResetOnSpawn = false
	if RunService:IsStudio() or game.PlaceId == 11630038968 then
		warn("CoreGui Denied")
		Eternal.Parent = PlayerGui
	else
		Eternal.Parent = CoreGui
	end
	
	local MainFrame = Instance.new("Frame")
	MainFrame.Parent = Eternal
	MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MainFrame.BackgroundTransparency = 1.000
	MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.BorderSizePixel = 0
	MainFrame.Size = UDim2.new(1, 0, 1, 0)
	MainFrame.Visible = false

	local MobileButtonsHolder = Instance.new("Frame")
	MobileButtonsHolder.Parent = Eternal
	MobileButtonsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MobileButtonsHolder.BackgroundTransparency = 1.000
	MobileButtonsHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MobileButtonsHolder.BorderSizePixel = 0
	MobileButtonsHolder.Size = UDim2.new(1, 0, 1, 0)
	MobileButtonsHolder.Visible = true

	local TrashCans = Instance.new("ImageLabel")
	TrashCans.Name = "TrashCans"
	TrashCans.Parent = MobileButtonsHolder
	TrashCans.AnchorPoint = Vector2.new(0.5, 0.5)
	TrashCans.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TrashCans.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TrashCans.Visible = false
	TrashCans.BorderSizePixel = 0
	TrashCans.Position = UDim2.new(0.948977232, 0, 0.901647091, 0)
	TrashCans.Size = UDim2.new(0, 80, 0, 80)
	TrashCans.Image = "rbxassetid://8463436236"
	TrashCans.Visible = false

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = MainFrame
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = MainFrame
	UIPadding.PaddingLeft = UDim.new(0, 20)
	UIPadding.PaddingTop = UDim.new(0, 35)

	local OpenButton = Instance.new("TextButton")
	OpenButton.Parent = Eternal
	OpenButton.AnchorPoint = Vector2.new(0.5, 0.5)
	OpenButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	OpenButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OpenButton.BorderSizePixel = 0
	OpenButton.Position = UDim2.new(0.5, 0, 0.0500000007, 0)
	OpenButton.Size = UDim2.new(0, 18, 0, 18)
	OpenButton.ZIndex = -2
	OpenButton.Font = Enum.Font.SourceSans
	OpenButton.Text = "+"
	OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	OpenButton.TextScaled = true
	OpenButton.TextSize = 14.000
	OpenButton.TextWrapped = true

	local Hud = Instance.new("Frame")
	Hud.Parent = Eternal
	Hud.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Hud.BackgroundTransparency = 1.000
	Hud.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Hud.BorderSizePixel = 0
	Hud.Size = UDim2.new(1, 0, 1, 0)
	Hud.ZIndex = -1

	local Logo = Instance.new("Frame")
	Logo.Parent = Hud
	Logo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Logo.BackgroundTransparency = 0.180
	Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Logo.BorderSizePixel = 0
	Logo.Position = UDim2.new(0.00932994019, 0, 0.0187969916, 0)

	local Top = Instance.new("Frame")
	Top.Parent = Logo
	Top.BackgroundColor3 = Library.GuiColor
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 2)

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Parent = Logo
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Title.BorderSizePixel = 0
	Title.Position = UDim2.new(0.0299999993, 0, 0.100000001, 0)
	Title.Size = UDim2.new(1, 0, 0, 18)
	Title.Font = Enum.Font.SourceSans
	Title.Text = "Eternal " .. Library.LibraryVersion .. " | " .. game.Players.LocalPlayer.Name .. " | " .. game.PlaceId
	Title.TextColor3 = Library.GuiColor
	Title.TextSize = 14.000
	Title.TextWrapped = true
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local NewSize = game:GetService("TextService"):GetTextSize(Title.Text, Title.TextSize, Title.Font, Vector2.new(math.huge, math.huge))
	Logo.Size = UDim2.new(0, NewSize.X + 12, 0, 21)


	local ArraylistHolder = Instance.new("Frame")
	ArraylistHolder.Name = "ArraylistHolder"
	ArraylistHolder.Parent = Hud
	ArraylistHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ArraylistHolder.BackgroundTransparency = 1.000
	ArraylistHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ArraylistHolder.BorderSizePixel = 0
	ArraylistHolder.Position = UDim2.new(0.799537122, 0, 0.0243661068, 0)
	ArraylistHolder.Size = UDim2.new(0.168943331, 0, 0.975633919, 0)

	local UIListLayout_4 = Instance.new("UIListLayout")
	UIListLayout_4.Parent = ArraylistHolder
	UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
	
	local TargetHUD = Instance.new("Frame")
	local TargetName = Instance.new("TextLabel")
	local FightStatus = Instance.new("TextLabel")
	local HealthBack = Instance.new("Frame")
	local HealthFront = Instance.new("Frame")
	
	function Library:ShowTargetHUD(target, targethudvisible)

		TargetHUD.Parent = MobileButtonsHolder
		TargetHUD.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TargetHUD.BackgroundTransparency = 0.350
		TargetHUD.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TargetHUD.BorderSizePixel = 0
		TargetHUD.Position = UDim2.new(0.56627214, 0, 0.661118448, 0)
		TargetHUD.Size = UDim2.new(0, 165, 0, 50)
		TargetHUD.Visible = targethudvisible

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
		HealthFront.Size = UDim2.new(1, 0, 1, 0)
		
		spawn(function()
			while true do
				if target then
					TargetName.Text = target.Name
					local LocalHumanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
					local TargetHumanoid = target.Character:FindFirstChildOfClass("Humanoid")
					if LocalHumanoid and TargetHumanoid then
						if LocalHumanoid.Health > TargetHumanoid.Health then
							FightStatus.Text = "Winning"
						elseif LocalHumanoid.Health < TargetHumanoid.Health then
							FightStatus.Text = "Losing"
						else
							FightStatus.Text = "nil"
						end
					end
					HealthFront.Size = UDim2.new(TargetHumanoid.Health / TargetHumanoid.MaxHealth, 0, 1, 0)
				end
			end
		end)
	end

	
	local function InsertArray(name)
		local ArrayList = Instance.new("TextLabel")
		ArrayList.Name = name
		ArrayList.Parent = ArraylistHolder
		ArrayList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ArrayList.BackgroundTransparency = 1.000
		ArrayList.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ArrayList.BorderSizePixel = 0
		ArrayList.Size = UDim2.new(1, 0, 0, 14)
		ArrayList.Font = Enum.Font.SourceSans
		ArrayList.Text = name
		ArrayList.TextColor3 = Library.GuiColor
		ArrayList.TextScaled = true
		ArrayList.TextSize = 18.000
		ArrayList.TextWrapped = true
		ArrayList.LayoutOrder = -#name
		ArrayList.TextXAlignment = Enum.TextXAlignment.Right
	end

	local function RemoveArray(name)
		for i,v in pairs(ArraylistHolder:GetChildren()) do
			if v:IsA("TextLabel") and v.Name == name then
				v:Destroy()
			end
		end
	end

	OpenButton.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
		TrashCans.Visible = not TrashCans.Visible
	end)

	UserInputService.InputBegan:Connect(function(Input, isTyping)
		if Input.KeyCode == Enum.KeyCode.RightShift and not isTyping then
			MainFrame.Visible = not MainFrame.Visible
			TrashCans.Visible = not TrashCans.Visible
		end
	end)

	function Core:CreateTab(TabName)
		local Tab = {SizeY = 0}
		local TabMain = Instance.new("Frame")
		TabMain.Parent = MainFrame
		TabMain.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
		TabMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabMain.BorderSizePixel = 0
		TabMain.Size = UDim2.new(0, 118, 0, 25)

		local TabTitle = Instance.new("TextLabel")
		TabTitle.Parent = TabMain
		TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabTitle.BackgroundTransparency = 1.000
		TabTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabTitle.BorderSizePixel = 0
		TabTitle.Text = TabName
		TabTitle.Size = UDim2.new(1, 0, 1, 0)
		TabTitle.Font = Enum.Font.SourceSans
		TabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabTitle.TextScaled = true
		TabTitle.TextSize = 14.000
		TabTitle.TextWrapped = true

		local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
		UITextSizeConstraint.Parent = TabTitle
		UITextSizeConstraint.MaxTextSize = 14

		local ToggleHolders = Instance.new("Frame")
		ToggleHolders.Name = "ToggleHolders"
		ToggleHolders.Parent = TabMain
		ToggleHolders.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ToggleHolders.BackgroundTransparency = 1.000
		ToggleHolders.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleHolders.BorderSizePixel = 0
		ToggleHolders.Position = UDim2.new(0, 0, 1, 0)
		ToggleHolders.Size = UDim2.new(1, 0, -6.24980021, 211)

		local UIListLayout_2 = Instance.new("UIListLayout")
		UIListLayout_2.Parent = ToggleHolders

		function Tab:CreateToggle(ToggleButton)
			ToggleButton = {
				Name = ToggleButton.Name,
				Keybind = ToggleButton.Keybind or "Insert",
				Enabled = ToggleButton.Enabled or false,
				Callback = ToggleButton.Callback or function() end
			}

			if not Settings.ToggleButton[ToggleButton.Name] then
				Settings.ToggleButton[ToggleButton.Name] = {
					Keybind = ToggleButton.Keybind,
					Enabled = ToggleButton.Enabled
				}
			else
				ToggleButton.Keybind = Settings.ToggleButton[ToggleButton.Name].Keybind
				ToggleButton.Enabled = Settings.ToggleButton[ToggleButton.Name].Enabled
			end

			local ToggleButtonHolder = Instance.new("TextButton")
			ToggleButtonHolder.Parent = ToggleHolders
			ToggleButtonHolder.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			ToggleButtonHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.BorderSizePixel = 0
			ToggleButtonHolder.LayoutOrder = 1
			ToggleButtonHolder.Size = UDim2.new(1, 0, -0.0134088602, 28)
			ToggleButtonHolder.Name = ToggleButton.Name
			ToggleButtonHolder.AutoButtonColor = false
			ToggleButtonHolder.Font = Enum.Font.SourceSans
			ToggleButtonHolder.Text = ""
			ToggleButtonHolder.TextColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonHolder.TextSize = 14.000

			local OpenMenu = Instance.new("TextButton")
			OpenMenu.Parent = ToggleButtonHolder
			OpenMenu.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			OpenMenu.BackgroundTransparency = 1.000
			OpenMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			OpenMenu.BorderSizePixel = 0
			OpenMenu.Position = UDim2.new(0.829999983, 0, 0.150999993, 0)
			OpenMenu.Size = UDim2.new(0, 18, 0, 18)
			OpenMenu.Font = Enum.Font.SourceSans
			OpenMenu.Text = "+"
			OpenMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
			OpenMenu.TextScaled = true
			OpenMenu.TextSize = 14.000
			OpenMenu.TextWrapped = true

			local ToggleCheckmark = Instance.new("Frame")
			ToggleCheckmark.Parent = ToggleButtonHolder
			ToggleCheckmark.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
			ToggleCheckmark.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleCheckmark.BorderSizePixel = 0
			ToggleCheckmark.Position = UDim2.new(0.0508474559, 0, 0.254365265, 0)
			ToggleCheckmark.Size = UDim2.new(0, 10, 0, 10)

			local UICorner_2 = Instance.new("UICorner")
			UICorner_2.CornerRadius = UDim.new(0, 3)
			UICorner_2.Parent = ToggleCheckmark

			local ToggleName = Instance.new("TextLabel")
			ToggleName.Parent = ToggleButtonHolder
			ToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.BackgroundTransparency = 1.000
			ToggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleName.BorderSizePixel = 0
			ToggleName.Position = UDim2.new(0.180000007, 0, 0.158999994, 0)
			ToggleName.Size = UDim2.new(0, 80, 0, 15)
			ToggleName.Font = Enum.Font.SourceSans
			ToggleName.Text = ToggleButton.Name
			ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleName.TextSize = 13.000
			ToggleName.TextXAlignment = Enum.TextXAlignment.Left

			local ToggleButtonMenu = Instance.new("Frame")
			ToggleButtonMenu.Name = "" .. ToggleButton.Name .. "Menu"
			ToggleButtonMenu.Parent = ToggleHolders
			ToggleButtonMenu.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
			ToggleButtonMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ToggleButtonMenu.BorderSizePixel = 0
			ToggleButtonMenu.LayoutOrder = 1
			ToggleButtonMenu.Position = UDim2.new(0, 0, 0.497959971, 0)
			ToggleButtonMenu.Size = UDim2.new(1, 0, 1.19949615, 0)
			ToggleButtonMenu.Visible = false

			local ScrollingFrame = Instance.new("ScrollingFrame")
			ScrollingFrame.Parent = ToggleButtonMenu
			ScrollingFrame.Active = true
			ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ScrollingFrame.BackgroundTransparency = 1.000
			ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.Size = UDim2.new(1, 0, 0.771614492, 0)
			ScrollingFrame.CanvasPosition = Vector2.new(0, 80.6783905)
			ScrollingFrame.ScrollBarThickness = 4
			ScrollingFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

			local UIListLayout_3 = Instance.new("UIListLayout")
			UIListLayout_3.Parent = ScrollingFrame
			UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

			local KeyBind = Instance.new("TextBox")
			KeyBind.Parent = ToggleButtonMenu
			KeyBind.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
			KeyBind.BorderColor3 = Color3.fromRGB(0, 0, 0)
			KeyBind.BorderSizePixel = 0
			KeyBind.Position = UDim2.new(0, 0, 0.786514044, 0)
			KeyBind.Size = UDim2.new(1, 0, -0.13670516, 23)
			KeyBind.Font = Enum.Font.SourceSans
			KeyBind.PlaceholderText = "None"
			KeyBind.Text = ""
			KeyBind.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeyBind.TextSize = 14.000
			UserInputService.InputBegan:Connect(function(Input, isTyping)
				if Input.UserInputType == Enum.UserInputType.Keyboard then
					if KeyBind:IsFocused() then
						ToggleButton.Keybind = Input.KeyCode.Name
						KeyBind.Text = Input.KeyCode.Name
						KeyBind.PlaceholderText = Input.KeyCode.Name
						KeyBind:ReleaseFocus() 
						Settings.ToggleButton[ToggleButton.Name].Keybind = ToggleButton.Keybind
					end       
				end
			end)

			local function OnClicked()
				if ToggleButton.Enabled then
					TweenEffect(ToggleCheckmark, {BackgroundColor3 = Color3.fromRGB(0, 175, 0)})
					InsertArray(ToggleButton.Name)
					Settings.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
				else
					TweenEffect(ToggleCheckmark, {BackgroundColor3 = Color3.fromRGB(175, 0, 0)})
					RemoveArray(ToggleButton.Name)
					Settings.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
				end
			end

			local function CreateButtons(name)	
				local MobileButtonz = Instance.new("TextButton")
				MobileButtonz.AnchorPoint = Vector2.new(0, 5)
				MobileButtonz.Parent = MobileButtonsHolder
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
				Draggable(MobileButtonz)

				local function OnClickedButtonz()
					if ToggleButton.Enabled then
						TweenEffect(MobileButtonz, {BackgroundColor3 = Color3.fromRGB(0, 175, 0)})
						Settings.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
					else
						TweenEffect(MobileButtonz, {BackgroundColor3 = Color3.fromRGB(175, 0, 0)})
						Settings.ToggleButton[ToggleButton.Name].Enabled = ToggleButton.Enabled
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
					OnClickedButtonz()
					OnClicked()

					if ToggleButton.Callback then
						ToggleButton.Callback(ToggleButton.Enabled)
					end
				end)

				while true do
					wait()
					if TrashCans.Visible and TrashcanCheck() then
						MobileButtonz:Destroy()
					end
				end
			end

			ToggleButtonHolder.MouseButton1Click:Connect(function()
				ToggleButton.Enabled = not ToggleButton.Enabled
				OnClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end)

			ToggleButtonHolder.MouseButton2Click:Connect(function()
				ToggleButtonMenu.Visible = not ToggleButtonMenu.Visible
			end)

			local HoldTime = 5
			local Holding = false
			ToggleButtonHolder.MouseButton1Down:Connect(function()
				if Library.MobileButtons then
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

			OpenMenu.MouseButton1Click:Connect(function()
				ToggleButtonMenu.Visible = not ToggleButtonMenu.Visible
			end)

			if ToggleButton.Keybind then
				UserInputService.InputBegan:Connect(function(Input, isTyping)
					if Input.KeyCode == Enum.KeyCode[ToggleButton.Keybind] and not isTyping then
						ToggleButton.Enabled = not ToggleButton.Enabled
						OnClicked()

						if ToggleButton.Callback then
							ToggleButton.Callback(ToggleButton.Enabled)
						end
					end
				end)
			end

			if ToggleButton.Enabled then
				ToggleButton.Enabled = true
				OnClicked()

				if ToggleButton.Callback then
					ToggleButton.Callback(ToggleButton.Enabled)
				end
			end
			
			function ToggleButton:CreateMiniToggle(MiniToggle)
				MiniToggle = {
					Name = MiniToggle.Name,
					Enabled = MiniToggle.Enabled,
					Callback = MiniToggle.Callback() or function()
					end
				}

				if not Settings.ToggleButton.MiniToggle[MiniToggle.Name] then
					Settings.ToggleButton.MiniToggle[MiniToggle.Name] = {
						Enabled = MiniToggle.Enabled
					}
				else
					MiniToggle.Enabled = Settings.ToggleButton.MiniToggle[MiniToggle.Name].Enabled
				end
				
				local MiniTogglez = Instance.new("TextButton")
				MiniTogglez.Name = MiniToggle.Name
				MiniTogglez.Parent = ScrollingFrame
				MiniTogglez.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				MiniTogglez.BackgroundTransparency = 1.000
				MiniTogglez.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniTogglez.BorderSizePixel = 0
				MiniTogglez.Size = UDim2.new(1, 0, 0, 23)
				MiniTogglez.AutoButtonColor = false
				MiniTogglez.Font = Enum.Font.SourceSans
				MiniTogglez.Text = ""
				MiniTogglez.TextColor3 = Color3.fromRGB(0, 0, 0)
				MiniTogglez.TextSize = 14.000

				local MiniToggleName = Instance.new("TextLabel")
				MiniToggleName.Parent = MiniTogglez
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

				local MiniToggleCheckmark = Instance.new("Frame")
				MiniToggleCheckmark.Parent = MiniTogglez
				MiniToggleCheckmark.BackgroundColor3 = Color3.fromRGB(175, 0, 0)
				MiniToggleCheckmark.BorderColor3 = Color3.fromRGB(0, 0, 0)
				MiniToggleCheckmark.BorderSizePixel = 0
				MiniToggleCheckmark.Position = UDim2.new(0.075000003, 0, 0.254000008, 0)
				MiniToggleCheckmark.Size = UDim2.new(0, 10, 0, 10)

				local UICorneraa = Instance.new("UICorner")
				UICorneraa.CornerRadius = UDim.new(0, 3)
				UICorneraa.Parent = MiniToggleCheckmark

				local function OnClickezd()
					if MiniToggle.Enabled then
						TweenEffect(MiniToggleCheckmark, {BackgroundColor3 = Color3.fromRGB(0, 175, 0)})
						Settings.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
					else
						TweenEffect(MiniToggleCheckmark, {BackgroundColor3 = Color3.fromRGB(175, 0, 0)})
						Settings.ToggleButton.MiniToggle[MiniToggle.Name].Enabled = MiniToggle.Enabled
					end
				end

				MiniTogglez.MouseButton1Click:Connect(function()
					MiniToggle.Enabled = not MiniToggle.Enabled
					OnClickezd()

					if MiniToggle.Callback then
						MiniToggle.Callback(MiniToggle.Enabled)
					end
				end)

				if MiniToggle.Enabled then
					MiniToggle.Enabled = true
					OnClickezd()

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
				Sliderz.Parent = ScrollingFrame
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
				Dropdown.Parent = ScrollingFrame
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
