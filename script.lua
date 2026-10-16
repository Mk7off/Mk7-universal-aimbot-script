-- =====================================================================
-- 1. LIBRAIRIE MACLIB
-- =====================================================================
local MacLib = { 
	Options = {}, 
	Folder = "Maclib", 
	GetService = function(service)
		return cloneref and cloneref(game:GetService(service)) or game:GetService(service)
	end
}

local TweenService = MacLib.GetService("TweenService")
local RunService = MacLib.GetService("RunService")
local HttpService = MacLib.GetService("HttpService")
local ContentProvider = MacLib.GetService("ContentProvider")
local UserInputService = MacLib.GetService("UserInputService")
local Lighting = MacLib.GetService("Lighting")
local Players = MacLib.GetService("Players")

local isStudio = RunService:IsStudio()
local LocalPlayer = Players.LocalPlayer

local windowState
local acrylicBlur
local hasGlobalSetting

local tabs = {}
local currentTabInstance = nil
local tabIndex = 0
local unloaded = false

local assets = {
	interFont = "rbxassetid://12187365364",
	userInfoBlurred = "rbxassetid://18824089198",
	toggleBackground = "rbxassetid://18772190202",
	togglerHead = "rbxassetid://18772309008",
	buttonImage = "rbxassetid://10709791437",
	searchIcon = "rbxassetid://86737463322606",
	colorWheel = "rbxassetid://2849458409",
	colorTarget = "rbxassetid://73265255323268",
	grid = "rbxassetid://121484455191370",
	globe = "rbxassetid://108952102602834",
	transform = "rbxassetid://90336395745819",
	dropdown = "rbxassetid://18865373378",
	sliderbar = "rbxassetid://18772615246",
	sliderhead = "rbxassetid://18772834246",
}

local function GetGui()
	local newGui = Instance.new("ScreenGui")
	newGui.ScreenInsets = Enum.ScreenInsets.None
	newGui.ResetOnSpawn = false
	newGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	newGui.DisplayOrder = 2147483647

	local parent = RunService:IsStudio() 
		and LocalPlayer:FindFirstChild("PlayerGui")
		or (gethui and gethui())
		or (cloneref and cloneref(MacLib.GetService("CoreGui")) or MacLib.GetService("CoreGui"))

	newGui.Parent = parent
	return newGui
end

local function Tween(instance, tweeninfo, propertytable)
	return TweenService:Create(instance, tweeninfo, propertytable)
end

function MacLib:Window(Settings)
	local WindowFunctions = {Settings = Settings}
	if Settings.AcrylicBlur ~= nil then
		acrylicBlur = Settings.AcrylicBlur
	else
		acrylicBlur = true
	end

	local macLib = GetGui()

	local notifications = Instance.new("Frame")
	notifications.Name = "Notifications"
	notifications.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	notifications.BackgroundTransparency = 1
	notifications.BorderColor3 = Color3.fromRGB(0, 0, 0)
	notifications.BorderSizePixel = 0
	notifications.Size = UDim2.fromScale(1, 1)
	notifications.Parent = macLib
	notifications.ZIndex = 2

	local notificationsUIListLayout = Instance.new("UIListLayout")
	notificationsUIListLayout.Name = "NotificationsUIListLayout"
	notificationsUIListLayout.Padding = UDim.new(0, 10)
	notificationsUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	notificationsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	notificationsUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notificationsUIListLayout.Parent = notifications

	local notificationsUIPadding = Instance.new("UIPadding")
	notificationsUIPadding.Name = "NotificationsUIPadding"
	notificationsUIPadding.PaddingBottom = UDim.new(0, 10)
	notificationsUIPadding.PaddingLeft = UDim.new(0, 10)
	notificationsUIPadding.PaddingRight = UDim.new(0, 10)
	notificationsUIPadding.PaddingTop = UDim.new(0, 10)
	notificationsUIPadding.Parent = notifications

	local base = Instance.new("Frame")
	base.Name = "Base"
	base.AnchorPoint = Vector2.new(0.5, 0.5)
	base.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	base.BackgroundTransparency = Settings.AcrylicBlur and 0.05 or 0
	base.BorderColor3 = Color3.fromRGB(0, 0, 0)
	base.BorderSizePixel = 0
	base.Position = UDim2.fromScale(0.5, 0.5)
	base.Size = Settings.Size or UDim2.fromOffset(868, 650)
	base.Visible = false

	local baseUIScale = Instance.new("UIScale")
	baseUIScale.Name = "BaseUIScale"
	baseUIScale.Parent = base
	baseUIScale.Scale = 0.9

	local baseUICorner = Instance.new("UICorner")
	baseUICorner.Name = "BaseUICorner"
	baseUICorner.CornerRadius = UDim.new(0, 10)
	baseUICorner.Parent = base

	local baseUIStroke = Instance.new("UIStroke")
	baseUIStroke.Name = "BaseUIStroke"
	baseUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	baseUIStroke.Color = Color3.fromRGB(255, 255, 255)
	baseUIStroke.Transparency = 0.9
	baseUIStroke.Parent = base

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sidebar.BackgroundTransparency = 1
	sidebar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	sidebar.BorderSizePixel = 0
	sidebar.Position = UDim2.fromScale(-3.52e-08, 4.69e-08)
	sidebar.Size = UDim2.fromScale(0.325, 1)

	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.AnchorPoint = Vector2.new(1, 0)
	divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider.BackgroundTransparency = 0.9
	divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider.BorderSizePixel = 0
	divider.Position = UDim2.fromScale(1, 0)
	divider.Size = UDim2.new(0, 1, 1, 0)
	divider.Parent = sidebar

	local dividerInteract = Instance.new("TextButton")
	dividerInteract.Name = "DividerInteract"
	dividerInteract.AnchorPoint = Vector2.new(0.5, 0)
	dividerInteract.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dividerInteract.BackgroundTransparency = 1
	dividerInteract.BorderColor3 = Color3.fromRGB(0, 0, 0)
	dividerInteract.BorderSizePixel = 0
	dividerInteract.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	dividerInteract.Position = UDim2.fromScale(0.5, 0)
	dividerInteract.Size = UDim2.new(1, 6, 1, 0)
	dividerInteract.Text = ""
	dividerInteract.TextColor3 = Color3.fromRGB(0, 0, 0)
	dividerInteract.TextSize = 14
	dividerInteract.Parent = divider

	local information = Instance.new("Frame")
	information.Name = "Information"
	information.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	information.BackgroundTransparency = 1
	information.BorderColor3 = Color3.fromRGB(0, 0, 0)
	information.BorderSizePixel = 0
	information.Position = UDim2.fromOffset(0, 31)
	information.Size = UDim2.new(1, 0, 0, 60)

	local divider2 = Instance.new("Frame")
	divider2.Name = "Divider"
	divider2.AnchorPoint = Vector2.new(0, 1)
	divider2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider2.BackgroundTransparency = 0.9
	divider2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider2.BorderSizePixel = 0
	divider2.Position = UDim2.fromScale(0, 1)
	divider2.Size = UDim2.new(1, 0, 0, 1)
	divider2.Parent = information

	local informationHolder = Instance.new("Frame")
	informationHolder.Name = "InformationHolder"
	informationHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	informationHolder.BackgroundTransparency = 1
	informationHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	informationHolder.BorderSizePixel = 0
	informationHolder.Size = UDim2.fromScale(1, 1)

	local informationHolderUIPadding = Instance.new("UIPadding")
	informationHolderUIPadding.Name = "InformationHolderUIPadding"
	informationHolderUIPadding.PaddingBottom = UDim.new(0, 10)
	informationHolderUIPadding.PaddingLeft = UDim.new(0, 23)
	informationHolderUIPadding.PaddingRight = UDim.new(0, 22)
	informationHolderUIPadding.PaddingTop = UDim.new(0, 10)
	informationHolderUIPadding.Parent = informationHolder

	local globalSettingsButton = Instance.new("ImageButton")
	globalSettingsButton.Name = "GlobalSettingsButton"
	globalSettingsButton.Image = assets.globe
	globalSettingsButton.ImageTransparency = 0.5
	globalSettingsButton.AnchorPoint = Vector2.new(1, 0.5)
	globalSettingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	globalSettingsButton.BackgroundTransparency = 1
	globalSettingsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	globalSettingsButton.BorderSizePixel = 0
	globalSettingsButton.Position = UDim2.fromScale(1, 0.5)
	globalSettingsButton.Size = UDim2.fromOffset(16,16)
	globalSettingsButton.Parent = informationHolder

	local function ChangeGlobalSettingsButtonState(State)
		if State == "Default" then
			Tween(globalSettingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.5
			}):Play()
		elseif State == "Hover" then
			Tween(globalSettingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.3
			}):Play()
		end
	end

	globalSettingsButton.MouseEnter:Connect(function()
		ChangeGlobalSettingsButtonState("Hover")
	end)
	globalSettingsButton.MouseLeave:Connect(function()
		ChangeGlobalSettingsButtonState("Default")
	end)

	local titleFrame = Instance.new("Frame")
	titleFrame.Name = "TitleFrame"
	titleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleFrame.BackgroundTransparency = 1
	titleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	titleFrame.BorderSizePixel = 0
	titleFrame.Size = UDim2.fromScale(1, 1)

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	title.Text = Settings.Title
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.RichText = true
	title.TextSize = 18
	title.TextTransparency = 0.1
	title.TextTruncate = Enum.TextTruncate.SplitWord
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextYAlignment = Enum.TextYAlignment.Top
	title.AutomaticSize = Enum.AutomaticSize.Y
	title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	title.BorderSizePixel = 0
	title.Size = UDim2.new(1, -20, 0, 0)
	title.Parent = titleFrame

	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	subtitle.RichText = true
	subtitle.Text = Settings.Subtitle
	subtitle.RichText = true
	subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	subtitle.TextSize = 12
	subtitle.TextTransparency = 0.7
	subtitle.TextTruncate = Enum.TextTruncate.SplitWord
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.TextYAlignment = Enum.TextYAlignment.Top
	subtitle.AutomaticSize = Enum.AutomaticSize.Y
	subtitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	subtitle.BackgroundTransparency = 1
	subtitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	subtitle.BorderSizePixel = 0
	subtitle.LayoutOrder = 1
	subtitle.Size = UDim2.new(1, -20, 0, 0)
	subtitle.Parent = titleFrame

	local titleFrameUIListLayout = Instance.new("UIListLayout")
	titleFrameUIListLayout.Name = "TitleFrameUIListLayout"
	titleFrameUIListLayout.Padding = UDim.new(0, 3)
	titleFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	titleFrameUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	titleFrameUIListLayout.Parent = titleFrame

	titleFrame.Parent = informationHolder
	informationHolder.Parent = information
	information.Parent = sidebar

	local sidebarGroup = Instance.new("Frame")
	sidebarGroup.Name = "SidebarGroup"
	sidebarGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sidebarGroup.BackgroundTransparency = 1
	sidebarGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
	sidebarGroup.BorderSizePixel = 0
	sidebarGroup.Position = UDim2.fromOffset(0, 91)
	sidebarGroup.Size = UDim2.new(1, 0, 1, -91)

	local userInfo = Instance.new("Frame")
	userInfo.Name = "UserInfo"
	userInfo.AnchorPoint = Vector2.new(0, 1)
	userInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	userInfo.BackgroundTransparency = 1
	userInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	userInfo.BorderSizePixel = 0
	userInfo.Position = UDim2.fromScale(0, 1)
	userInfo.Size = UDim2.new(1, 0, 0, 107)

	local informationGroup = Instance.new("Frame")
	informationGroup.Name = "InformationGroup"
	informationGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	informationGroup.BackgroundTransparency = 1
	informationGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
	informationGroup.BorderSizePixel = 0
	informationGroup.Size = UDim2.fromScale(1, 1)

	local informationGroupUIPadding = Instance.new("UIPadding")
	informationGroupUIPadding.Name = "InformationGroupUIPadding"
	informationGroupUIPadding.PaddingBottom = UDim.new(0, 17)
	informationGroupUIPadding.PaddingLeft = UDim.new(0, 25)
	informationGroupUIPadding.Parent = informationGroup

	local informationGroupUIListLayout = Instance.new("UIListLayout")
	informationGroupUIListLayout.Name = "InformationGroupUIListLayout"
	informationGroupUIListLayout.FillDirection = Enum.FillDirection.Horizontal
	informationGroupUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	informationGroupUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	informationGroupUIListLayout.Parent = informationGroup

	local userId = LocalPlayer.UserId
	local thumbType = Enum.ThumbnailType.AvatarBust
	local thumbSize = Enum.ThumbnailSize.Size48x48
	local headshotImage, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

	local headshot = Instance.new("ImageLabel")
	headshot.Name = "Headshot"
	headshot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	headshot.BackgroundTransparency = 1
	headshot.BorderColor3 = Color3.fromRGB(0, 0, 0)
	headshot.BorderSizePixel = 0
	headshot.Size = UDim2.fromOffset(32, 32)
	headshot.Image = (isReady and headshotImage) or "rbxassetid://0"

	local uICorner3 = Instance.new("UICorner")
	uICorner3.Name = "UICorner"
	uICorner3.CornerRadius = UDim.new(1, 0)
	uICorner3.Parent = headshot

	local baseUIStroke2 = Instance.new("UIStroke")
	baseUIStroke2.Name = "BaseUIStroke"
	baseUIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	baseUIStroke2.Color = Color3.fromRGB(255, 255, 255)
	baseUIStroke2.Transparency = 0.9
	baseUIStroke2.Parent = headshot

	headshot.Parent = informationGroup

	local userAndDisplayFrame = Instance.new("Frame")
	userAndDisplayFrame.Name = "UserAndDisplayFrame"
	userAndDisplayFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	userAndDisplayFrame.BackgroundTransparency = 1
	userAndDisplayFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	userAndDisplayFrame.BorderSizePixel = 0
	userAndDisplayFrame.LayoutOrder = 1
	userAndDisplayFrame.Size = UDim2.new(1, -42, 0, 32)

	local displayName = Instance.new("TextLabel")
	displayName.Name = "DisplayName"
	displayName.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	displayName.Text = LocalPlayer.DisplayName
	displayName.TextColor3 = Color3.fromRGB(255, 255, 255)
	displayName.TextSize = 13
	displayName.TextTransparency = 0.1
	displayName.TextTruncate = Enum.TextTruncate.SplitWord
	displayName.TextXAlignment = Enum.TextXAlignment.Left
	displayName.TextYAlignment = Enum.TextYAlignment.Top
	displayName.AutomaticSize = Enum.AutomaticSize.XY
	displayName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	displayName.BackgroundTransparency = 1
	displayName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	displayName.BorderSizePixel = 0
	displayName.Parent = userAndDisplayFrame
	displayName.Size = UDim2.fromScale(1,0)

	local userAndDisplayFrameUIPadding = Instance.new("UIPadding")
	userAndDisplayFrameUIPadding.Name = "UserAndDisplayFrameUIPadding"
	userAndDisplayFrameUIPadding.PaddingLeft = UDim.new(0, 8)
	userAndDisplayFrameUIPadding.PaddingTop = UDim.new(0, 3)
	userAndDisplayFrameUIPadding.Parent = userAndDisplayFrame

	local userAndDisplayFrameUIListLayout = Instance.new("UIListLayout")
	userAndDisplayFrameUIListLayout.Name = "UserAndDisplayFrameUIListLayout"
	userAndDisplayFrameUIListLayout.Padding = UDim.new(0, 1)
	userAndDisplayFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	userAndDisplayFrameUIListLayout.Parent = userAndDisplayFrame

	local username = Instance.new("TextLabel")
	username.Name = "Username"
	username.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	username.Text = "@" .. LocalPlayer.Name
	username.TextColor3 = Color3.fromRGB(255, 255, 255)
	username.TextSize = 12
	username.TextTransparency = 0.7
	username.TextTruncate = Enum.TextTruncate.SplitWord
	username.TextXAlignment = Enum.TextXAlignment.Left
	username.TextYAlignment = Enum.TextYAlignment.Top
	username.AutomaticSize = Enum.AutomaticSize.XY
	username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	username.BackgroundTransparency = 1
	username.BorderColor3 = Color3.fromRGB(0, 0, 0)
	username.BorderSizePixel = 0
	username.LayoutOrder = 1
	username.Parent = userAndDisplayFrame
	username.Size = UDim2.fromScale(1,0)

	userAndDisplayFrame.Parent = informationGroup
	informationGroup.Parent = userInfo

	local userInfoUIPadding = Instance.new("UIPadding")
	userInfoUIPadding.Name = "UserInfoUIPadding"
	userInfoUIPadding.PaddingLeft = UDim.new(0, 10)
	userInfoUIPadding.PaddingRight = UDim.new(0, 10)
	userInfoUIPadding.Parent = userInfo

	userInfo.Parent = sidebarGroup

	local sidebarGroupUIPadding = Instance.new("UIPadding")
	sidebarGroupUIPadding.Name = "SidebarGroupUIPadding"
	sidebarGroupUIPadding.PaddingLeft = UDim.new(0, 10)
	sidebarGroupUIPadding.PaddingRight = UDim.new(0, 10)
	sidebarGroupUIPadding.PaddingTop = UDim.new(0, 31)
	sidebarGroupUIPadding.Parent = sidebarGroup

	local tabSwitchers = Instance.new("Frame")
	tabSwitchers.Name = "TabSwitchers"
	tabSwitchers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabSwitchers.BackgroundTransparency = 1
	tabSwitchers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabSwitchers.BorderSizePixel = 0
	tabSwitchers.Size = UDim2.new(1, 0, 1, -107)

	local tabSwitchersScrollingFrame = Instance.new("ScrollingFrame")
	tabSwitchersScrollingFrame.Name = "TabSwitchersScrollingFrame"
	tabSwitchersScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabSwitchersScrollingFrame.BottomImage = ""
	tabSwitchersScrollingFrame.CanvasSize = UDim2.new()
	tabSwitchersScrollingFrame.ScrollBarImageTransparency = 0.8
	tabSwitchersScrollingFrame.ScrollBarThickness = 1
	tabSwitchersScrollingFrame.TopImage = ""
	tabSwitchersScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabSwitchersScrollingFrame.BackgroundTransparency = 1
	tabSwitchersScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabSwitchersScrollingFrame.BorderSizePixel = 0
	tabSwitchersScrollingFrame.Size = UDim2.fromScale(1, 1)

	local tabSwitchersScrollingFrameUIListLayout = Instance.new("UIListLayout")
	tabSwitchersScrollingFrameUIListLayout.Name = "TabSwitchersScrollingFrameUIListLayout"
	tabSwitchersScrollingFrameUIListLayout.Padding = UDim.new(0, 17)
	tabSwitchersScrollingFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabSwitchersScrollingFrameUIListLayout.Parent = tabSwitchersScrollingFrame

	local tabSwitchersScrollingFrameUIPadding = Instance.new("UIPadding")
	tabSwitchersScrollingFrameUIPadding.Name = "TabSwitchersScrollingFrameUIPadding"
	tabSwitchersScrollingFrameUIPadding.PaddingTop = UDim.new(0, 2)
	tabSwitchersScrollingFrameUIPadding.Parent = tabSwitchersScrollingFrame

	tabSwitchersScrollingFrame.Parent = tabSwitchers
	tabSwitchers.Parent = sidebarGroup
	sidebarGroup.Parent = sidebar
	sidebar.Parent = base

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.AnchorPoint = Vector2.new(1, 0)
	content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	content.BackgroundTransparency = 1
	content.BorderColor3 = Color3.fromRGB(0, 0, 0)
	content.BorderSizePixel = 0
	content.Position = UDim2.fromScale(1, 4.69e-08)
	content.Size = UDim2.new(0, (base.AbsoluteSize.X - sidebar.AbsoluteSize.X), 1, 0)

	local resizingContent = false
	local defaultSidebarWidth = sidebar.AbsoluteSize.X
	local initialMouseX, initialSidebarWidth
	local snapRange = 20
	local minSidebarWidth = 107
	local maxSidebarWidth = base.AbsoluteSize.X - minSidebarWidth

	local TweenSettings = {
		DefaultTransparency = 0.9,
		HoverTransparency = 0.85,
		EasingStyle = Enum.EasingStyle.Sine
	}

	local function ChangeState(State)
		Tween(divider, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
			BackgroundTransparency = State == "Idle" and TweenSettings.DefaultTransparency or TweenSettings.HoverTransparency
		}):Play()  
	end

	dividerInteract.MouseEnter:Connect(function()
		ChangeState("Hover")
	end)
	dividerInteract.MouseLeave:Connect(function()
		ChangeState("Idle")
	end)

	dividerInteract.MouseButton1Down:Connect(function()
		resizingContent = true
		initialMouseX = UserInputService:GetMouseLocation().X
		initialSidebarWidth = sidebar.AbsoluteSize.X
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizingContent = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizingContent and input.UserInputType == Enum.UserInputType.MouseMovement then
			local deltaX = UserInputService:GetMouseLocation().X - initialMouseX
			local newSidebarWidth = initialSidebarWidth + deltaX

			if math.abs(newSidebarWidth - defaultSidebarWidth) < snapRange then
				newSidebarWidth = defaultSidebarWidth
			else
				newSidebarWidth = math.clamp(newSidebarWidth, minSidebarWidth, maxSidebarWidth)
			end

			sidebar.Size = UDim2.new(0, newSidebarWidth, 1, 0)
			content.Size = UDim2.new(0, base.AbsoluteSize.X - newSidebarWidth, 1, 0)
		end
	end)

	local topbar = Instance.new("Frame")
	topbar.Name = "Topbar"
	topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	topbar.BackgroundTransparency = 1
	topbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	topbar.BorderSizePixel = 0
	topbar.Size = UDim2.new(1, 0, 0, 63)

	local divider4 = Instance.new("Frame")
	divider4.Name = "Divider"
	divider4.AnchorPoint = Vector2.new(0, 1)
	divider4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider4.BackgroundTransparency = 0.9
	divider4.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider4.BorderSizePixel = 0
	divider4.Position = UDim2.fromScale(0, 1)
	divider4.Size = UDim2.new(1, 0, 0, 1)
	divider4.Parent = topbar

	local elements = Instance.new("Frame")
	elements.Name = "Elements"
	elements.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	elements.BackgroundTransparency = 1
	elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
	elements.BorderSizePixel = 0
	elements.Size = UDim2.fromScale(1, 1)

	local uIPadding2 = Instance.new("UIPadding")
	uIPadding2.Name = "UIPadding"
	uIPadding2.PaddingLeft = UDim.new(0, 20)
	uIPadding2.PaddingRight = UDim.new(0, 20)
	uIPadding2.Parent = elements

	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Name = "MinimizeBtn"
	minimizeBtn.AnchorPoint = Vector2.new(1, 0.5)
	minimizeBtn.Position = UDim2.new(1, -25, 0.5, 0)
	minimizeBtn.Size = UDim2.fromOffset(20, 20)
	minimizeBtn.BackgroundTransparency = 1
	minimizeBtn.Text = ""
	minimizeBtn.AutoButtonColor = false
	minimizeBtn.Parent = elements

	local minimizeBar = Instance.new("Frame")
	minimizeBar.Name = "MinimizeBar"
	minimizeBar.AnchorPoint = Vector2.new(0.5, 0.5)
	minimizeBar.Position = UDim2.fromScale(0.5, 0.5)
	minimizeBar.Size = UDim2.fromOffset(14, 2)
	minimizeBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	minimizeBar.BackgroundTransparency = 0.4
	minimizeBar.BorderSizePixel = 0
	minimizeBar.Parent = minimizeBtn

	local minimizeBarCorner = Instance.new("UICorner")
	minimizeBarCorner.CornerRadius = UDim.new(1, 0)
	minimizeBarCorner.Parent = minimizeBar

	minimizeBtn.MouseEnter:Connect(function()
		Tween(minimizeBar, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
			BackgroundTransparency = 0.1
		}):Play()
	end)
	minimizeBtn.MouseLeave:Connect(function()
		Tween(minimizeBar, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
			BackgroundTransparency = 0.4
		}):Play()
	end)

	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseBtn"
	closeBtn.AnchorPoint = Vector2.new(1, 0.5)
	closeBtn.Position = UDim2.fromScale(1, 0.5)
	closeBtn.Size = UDim2.fromOffset(20, 20)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "✕"
	closeBtn.FontFace = Font.new(assets.interFont, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	closeBtn.TextSize = 16
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.TextTransparency = 0.4
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = elements

	closeBtn.MouseEnter:Connect(function()
		Tween(closeBtn, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
			TextTransparency = 0.1,
			TextColor3 = Color3.fromRGB(239, 68, 68)
		}):Play()
	end)
	closeBtn.MouseLeave:Connect(function()
		Tween(closeBtn, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
			TextTransparency = 0.4,
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
	end)

	local topbarDragging = false
	local topbarDragStart = nil
	local topbarStartPos = nil
	local topbarDragInput = nil

	local function topbarUpdate(input)
		if topbarDragging and topbarStartPos and topbarDragStart then
			local delta = input.Position - topbarDragStart
			base.Position = UDim2.new(
				topbarStartPos.X.Scale,
				topbarStartPos.X.Offset + delta.X,
				topbarStartPos.Y.Scale,
				topbarStartPos.Y.Offset + delta.Y
			)
		end
	end

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			topbarDragging = true
			topbarDragStart = input.Position
			topbarStartPos = base.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					topbarDragging = false
				end
			end)
		end
	end)

	topbar.InputChanged:Connect(function(input)
		if topbarDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			topbarDragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == topbarDragInput then
			topbarUpdate(input)
		end
	end)

	topbar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			topbarDragging = false
		end
	end)

	local currentTab = Instance.new("TextLabel")
	currentTab.Name = "CurrentTab"
	currentTab.FontFace = Font.new(assets.interFont)
	currentTab.RichText = true
	currentTab.Text = ""
	currentTab.RichText = true
	currentTab.TextColor3 = Color3.fromRGB(255, 255, 255)
	currentTab.TextSize = 15
	currentTab.TextTransparency = 0.5
	currentTab.TextTruncate = Enum.TextTruncate.SplitWord	currentTab.TextXAlignment = Enum.TextXAlignment.Left
	currentTab.TextYAlignment = Enum.TextYAlignment.Top
	currentTab.AnchorPoint = Vector2.new(0, 0.5)
	currentTab.AutomaticSize = Enum.AutomaticSize.Y
	currentTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	currentTab.BackgroundTransparency = 1
	currentTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	currentTab.BorderSizePixel = 0
	currentTab.Position = UDim2.fromScale(0, 0.5)
	currentTab.Size = UDim2.fromScale(0.9, 0)
	currentTab.Parent = elements

	elements.Parent = topbar
	topbar.Parent = content
	content.Parent = base

	local globalSettings = Instance.new("Frame")
	globalSettings.Name = "GlobalSettings"
	globalSettings.AutomaticSize = Enum.AutomaticSize.XY
	globalSettings.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	globalSettings.BorderColor3 = Color3.fromRGB(0, 0, 0)
	globalSettings.BorderSizePixel = 0
	globalSettings.Position = UDim2.fromScale(0.298, 0.104)

	local globalSettingsUIStroke = Instance.new("UIStroke")
	globalSettingsUIStroke.Name = "GlobalSettingsUIStroke"
	globalSettingsUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	globalSettingsUIStroke.Color = Color3.fromRGB(255, 255, 255)
	globalSettingsUIStroke.Transparency = 0.9
	globalSettingsUIStroke.Parent = globalSettings

	local globalSettingsUICorner = Instance.new("UICorner")
	globalSettingsUICorner.Name = "GlobalSettingsUICorner"
	globalSettingsUICorner.CornerRadius = UDim.new(0, 10)
	globalSettingsUICorner.Parent = globalSettings

	local globalSettingsUIPadding = Instance.new("UIPadding")
	globalSettingsUIPadding.Name = "GlobalSettingsUIPadding"
	globalSettingsUIPadding.PaddingBottom = UDim.new(0, 10)
	globalSettingsUIPadding.PaddingTop = UDim.new(0, 10)
	globalSettingsUIPadding.Parent = globalSettings

	local globalSettingsUIListLayout = Instance.new("UIListLayout")
	globalSettingsUIListLayout.Name = "GlobalSettingsUIListLayout"
	globalSettingsUIListLayout.Padding = UDim.new(0, 5)
	globalSettingsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	globalSettingsUIListLayout.Parent = globalSettings

	local globalSettingsUIScale = Instance.new("UIScale")
	globalSettingsUIScale.Name = "GlobalSettingsUIScale"
	globalSettingsUIScale.Scale = 1e-07
	globalSettingsUIScale.Parent = globalSettings
	globalSettings.Parent = base
	base.Parent = macLib

	WindowFunctions.ScreenGui = macLib

	function WindowFunctions:UpdateTitle(NewTitle)
		title.Text = NewTitle
	end

	function WindowFunctions:UpdateSubtitle(NewSubtitle)
		subtitle.Text = NewSubtitle
	end

	local hovering
	local toggled = globalSettingsUIScale.Scale == 1 and true or false
	local function toggle()
		if not toggled then
			local intween = Tween(globalSettingsUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = 1
			})
			intween:Play()
			intween.Completed:Wait()
			toggled = true
		elseif toggled then
			local outtween = Tween(globalSettingsUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = 0
			})
			outtween:Play()
			outtween.Completed:Wait()
			toggled = false
		end
	end
	globalSettingsButton.MouseButton1Click:Connect(function()
		if not hasGlobalSetting then return end
		toggle()
	end)
	globalSettings.MouseEnter:Connect(function()
		hovering = true
	end)
	globalSettings.MouseLeave:Connect(function()
		hovering = false
	end)
	UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 and toggled and not hovering then
			toggle()
		end
	end)

	local BlurTarget = base
	local HS = HttpService
	local camera = workspace.CurrentCamera
	local MTREL = "Glass"
	local binds = {}
	local wedgeguid = HS:GenerateGUID(true)
	local DepthOfField

	for _,v in pairs(Lighting:GetChildren()) do
		if not v:IsA("DepthOfFieldEffect") and v:HasTag(".") then
			DepthOfField = Instance.new('DepthOfFieldEffect')
			DepthOfField.FarIntensity = 0
			DepthOfField.FocusDistance = 51.6
			DepthOfField.InFocusRadius = 50
			DepthOfField.NearIntensity = 1
			DepthOfField.Name = HS:GenerateGUID(true)
			DepthOfField:AddTag(".")
		elseif v:IsA("DepthOfFieldEffect") and v:HasTag(".") then
			DepthOfField = v
		end
	end

	if not DepthOfField then
		DepthOfField = Instance.new('DepthOfFieldEffect')
		DepthOfField.FarIntensity = 0
		DepthOfField.FocusDistance = 51.6
		DepthOfField.InFocusRadius = 50
		DepthOfField.NearIntensity = 1
		DepthOfField.Name = HS:GenerateGUID(true)
		DepthOfField:AddTag(".")
	end

	local frame = Instance.new('Frame')
	frame.Parent = BlurTarget
	frame.Size = UDim2.new(0.97, 0, 0.97, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundTransparency = 1
	frame.Name = HS:GenerateGUID(true)

	do
		local function IsNotNaN(x)
			return x == x
		end
		local continue = IsNotNaN(camera:ScreenPointToRay(0,0).Origin.x)
		while not continue do
			RunService.RenderStepped:Wait()
			continue = IsNotNaN(camera:ScreenPointToRay(0,0).Origin.x)
		end
	end

	local DrawQuad; do
		local acos, max, pi, sqrt = math.acos, math.max, math.pi, math.sqrt
		local sz = 0.2

		local function DrawTriangle(v1, v2, v3, p0, p1)
			local s1 = (v1 - v2).magnitude
			local s2 = (v2 - v3).magnitude
			local s3 = (v3 - v1).magnitude
			local smax = max(s1, s2, s3)
			local A, B, C
			if s1 == smax then
				A, B, C = v1, v2, v3
			elseif s2 == smax then
				A, B, C = v2, v3, v1
			elseif s3 == smax then
				A, B, C = v3, v1, v2
			end

			local para = ( (B-A).x*(C-A).x + (B-A).y*(C-A).y + (B-A).z*(C-A).z ) / (A-B).magnitude
			local perp = sqrt((C-A).magnitude^2 - para*para)
			local dif_para = (A - B).magnitude - para

			local st = CFrame.new(B, A)
			local za = CFrame.Angles(pi/2,0,0)
			local cf0 = st

			local Top_Look = (cf0 * za).lookVector
			local Mid_Point = A + CFrame.new(A, B).lookVector * para
			local Needed_Look = CFrame.new(Mid_Point, C).lookVector
			local dot = Top_Look.x*Needed_Look.x + Top_Look.y*Needed_Look.y + Top_Look.z*Needed_Look.z

			local ac = CFrame.Angles(0, 0, acos(dot))

			cf0 = cf0 * ac
			if ((cf0 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf0 = cf0 * CFrame.Angles(0, 0, -2*acos(dot))
			end
			cf0 = cf0 * CFrame.new(0, perp/2, -(dif_para + para/2))

			local cf1 = st * ac * CFrame.Angles(0, pi, 0)
			if ((cf1 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf1 = cf1 * CFrame.Angles(0, 0, 2*acos(dot))
			end
			cf1 = cf1 * CFrame.new(0, perp/2, dif_para/2)

			if not p0 then
				p0 = Instance.new('Part')
				p0.FormFactor = 'Custom'
				p0.TopSurface = 0
				p0.BottomSurface = 0
				p0.Anchored = true
				p0.CanCollide = false
				p0.CastShadow = false
				p0.Material = MTREL
				p0.Size = Vector3.new(sz, sz, sz)
				p0.Name = HS:GenerateGUID(true)
				local mesh = Instance.new('SpecialMesh', p0)
				mesh.MeshType = 2
				mesh.Name = wedgeguid
			end
			p0[wedgeguid].Scale = Vector3.new(0, perp/sz, para/sz)
			p0.CFrame = cf0

			if not p1 then
				p1 = p0:clone()
			end
			p1[wedgeguid].Scale = Vector3.new(0, perp/sz, dif_para/sz)
			p1.CFrame = cf1

			return p0, p1
		end

		function DrawQuad(v1, v2, v3, v4, parts)
			parts[1], parts[2] = DrawTriangle(v1, v2, v3, parts[1], parts[2])
			parts[3], parts[4] = DrawTriangle(v3, v2, v4, parts[3], parts[4])
		end
	end

	if binds[frame] then
		return binds[frame].parts
	end

	local parts = {}
	local parents = {}
	do
		local function add(child)
			if child:IsA'GuiObject' then
				parents[#parents + 1] = child
				add(child.Parent)
			end
		end
		add(frame)
	end

	local function IsVisible(instance)
		while instance do
			if instance:IsA("GuiObject") then
				if not instance.Visible then
					return false
				end
			elseif instance:IsA("ScreenGui") then
				if not instance.Enabled then
					return false
				end
				break
			end
			instance = instance.Parent
		end
		return true
	end

	local function UpdateOrientation(fetchProps)
		if not IsVisible(frame) or not acrylicBlur or unloaded then
			for _, pt in pairs(parts) do
				pt.Parent = nil
				DepthOfField.Enabled = false
				DepthOfField.Parent = nil
			end
			return
		end
		if not DepthOfField.Parent then
			DepthOfField.Parent = Lighting
		end
		DepthOfField.Enabled = true
		local properties = {
			Transparency = 0.98;
			BrickColor = BrickColor.new('Institutional white');
		}
		local zIndex = 1 - 0.05*frame.ZIndex

		local tl, br = frame.AbsolutePosition, frame.AbsolutePosition + frame.AbsoluteSize
		local tr, bl = Vector2.new(br.x, tl.y), Vector2.new(tl.x, br.y)
		do
			local rot = 0;
			for _, v in ipairs(parents) do
				rot = rot + v.Rotation
			end
			if rot ~= 0 and rot%180 ~= 0 then
				local mid = tl:lerp(br, 0.5)
				local s, c = math.sin(math.rad(rot)), math.cos(math.rad(rot))
				local vec = tl
				tl = Vector2.new(c*(tl.x - mid.x) - s*(tl.y - mid.y), s*(tl.x - mid.x) + c*(tl.y - mid.y)) + mid
				tr = Vector2.new(c*(tr.x - mid.x) - s*(tr.y - mid.y), s*(tr.x - mid.x) + c*(tr.y - mid.y)) + mid
				bl = Vector2.new(c*(bl.x - mid.x) - s*(bl.y - mid.y), s*(bl.x - mid.x) + c*(bl.y - mid.y)) + mid
				br = Vector2.new(c*(br.x - mid.x) - s*(br.y - mid.y), s*(br.x - mid.x) + c*(br.y - mid.y)) + mid
			end
		end
		DrawQuad(
			camera:ScreenPointToRay(tl.x, tl.y, zIndex).Origin, 
			camera:ScreenPointToRay(tr.x, tr.y, zIndex).Origin, 
			camera:ScreenPointToRay(bl.x, bl.y, zIndex).Origin, 
			camera:ScreenPointToRay(br.x, br.y, zIndex).Origin, 
			parts
		)
		if fetchProps then
			for _, pt in pairs(parts) do
				pt.Parent = camera
			end
			for propName, propValue in pairs(properties) do
				for _, pt in pairs(parts) do
					pt[propName] = propValue
				end
			end
		end
	end

	UpdateOrientation(true)
	RunService.RenderStepped:Connect(UpdateOrientation)

	function WindowFunctions:GlobalSetting(Settings)
		hasGlobalSetting = true
		local GlobalSettingFunctions = {}
		local globalSetting = Instance.new("TextButton")
		globalSetting.Name = "GlobalSetting"
		globalSetting.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
		globalSetting.Text = ""
		globalSetting.TextColor3 = Color3.fromRGB(0, 0, 0)
		globalSetting.TextSize = 14
		globalSetting.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		globalSetting.BackgroundTransparency = 1
		globalSetting.BorderColor3 = Color3.fromRGB(0, 0, 0)
		globalSetting.BorderSizePixel = 0
		globalSetting.Size = UDim2.fromOffset(200, 30)

		local globalSettingToggleUIPadding = Instance.new("UIPadding")
		globalSettingToggleUIPadding.Name = "GlobalSettingToggleUIPadding"
		globalSettingToggleUIPadding.PaddingLeft = UDim.new(0, 15)
		globalSettingToggleUIPadding.Parent = globalSetting

		local settingName = Instance.new("TextLabel")
		settingName.Name = "SettingName"
		settingName.FontFace = Font.new(assets.interFont)
		settingName.Text = Settings.Name
		settingName.RichText = true
		settingName.TextColor3 = Color3.fromRGB(255, 255, 255)
		settingName.TextSize = 13
		settingName.TextTransparency = 0.5
		settingName.TextTruncate = Enum.TextTruncate.SplitWord
		settingName.TextXAlignment = Enum.TextXAlignment.Left
		settingName.TextYAlignment = Enum.TextYAlignment.Top
		settingName.AnchorPoint = Vector2.new(0, 0.5)
		settingName.AutomaticSize = Enum.AutomaticSize.Y
		settingName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		settingName.BackgroundTransparency = 1
		settingName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		settingName.BorderSizePixel = 0
		settingName.Position = UDim2.fromScale(1.3e-07, 0.5)
		settingName.Size = UDim2.new(1,-40,0,0)
		settingName.Parent = globalSetting

		local globalSettingToggleUIListLayout = Instance.new("UIListLayout")
		globalSettingToggleUIListLayout.Name = "GlobalSettingToggleUIListLayout"
		globalSettingToggleUIListLayout.Padding = UDim.new(0, 10)
		globalSettingToggleUIListLayout.FillDirection = Enum.FillDirection.Horizontal
		globalSettingToggleUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		globalSettingToggleUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		globalSettingToggleUIListLayout.Parent = globalSetting

		local checkmark = Instance.new("TextLabel")
		checkmark.Name = "Checkmark"
		checkmark.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		)
		checkmark.Text = "✓"
		checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
		checkmark.TextSize = 13
		checkmark.TextTransparency = 1
		checkmark.TextXAlignment = Enum.TextXAlignment.Left
		checkmark.TextYAlignment = Enum.TextYAlignment.Top
		checkmark.AnchorPoint = Vector2.new(0, 0.5)
		checkmark.AutomaticSize = Enum.AutomaticSize.Y
		checkmark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		checkmark.BackgroundTransparency = 1
		checkmark.BorderColor3 = Color3.fromRGB(0, 0, 0)
		checkmark.BorderSizePixel = 0
		checkmark.LayoutOrder = -1
		checkmark.Position = UDim2.fromScale(1.3e-07, 0.5)
		checkmark.Size = UDim2.fromOffset(-10, 0)
		checkmark.Parent = globalSetting

		globalSetting.Parent = globalSettings

		local tweensettings = {
			duration = 0.2,
			easingStyle = Enum.EasingStyle.Quint,
			transparencyIn = 0.2,
			transparencyOut = 0.5,
			checkSizeIncrease = 12,
			checkSizeDecrease = -globalSettingToggleUIListLayout.Padding.Offset,
			waitTime = 1
		}

		local tweens = {
			checkIn = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
				Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeIncrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
			}),
			checkOut = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
				Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
			}),
			nameIn = Tween(settingName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
				TextTransparency = tweensettings.transparencyIn
			}),
			nameOut = Tween(settingName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
				TextTransparency = tweensettings.transparencyOut
			})
		}

		local function Toggle(State)
			if not State then
				tweens.checkOut:Play()
				tweens.nameOut:Play()
				checkmark:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					if checkmark.AbsoluteSize.X <= 0 then
						checkmark.TextTransparency = 1
					end
				end)
			else
				tweens.checkIn:Play()
				tweens.nameIn:Play()
				checkmark:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					if checkmark.AbsoluteSize.X > 0 then
						checkmark.TextTransparency = 0
					end
				end)
			end
		end

		local toggled = Settings.Default
		Toggle(toggled)

		globalSetting.MouseButton1Click:Connect(function()
			toggled = not toggled
			Toggle(toggled)

			task.spawn(function()
				if Settings.Callback then
					Settings.Callback(toggled)
				end
			end)
		end)

		function GlobalSettingFunctions:UpdateName(NewName)
			settingName.Text = NewName
		end

		function GlobalSettingFunctions:UpdateState(NewState)
			Toggle(NewState)
			toggled = NewState
		end

		return GlobalSettingFunctions
	end

	function WindowFunctions:TabGroup()
		local SectionFunctions = {}

		local tabGroup = Instance.new("Frame")
		tabGroup.Name = "Section"
		tabGroup.AutomaticSize = Enum.AutomaticSize.Y
		tabGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabGroup.BackgroundTransparency = 1
		tabGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
		tabGroup.BorderSizePixel = 0
		tabGroup.Size = UDim2.fromScale(1, 0)

		local divider3 = Instance.new("Frame")
		divider3.Name = "Divider"
		divider3.AnchorPoint = Vector2.new(0.5, 1)
		divider3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		divider3.BackgroundTransparency = 0.9
		divider3.BorderColor3 = Color3.fromRGB(0, 0, 0)
		divider3.BorderSizePixel = 0
		divider3.Position = UDim2.fromScale(0.5, 1)
		divider3.Size = UDim2.new(1, -21, 0, 1)
		divider3.Parent = tabGroup

		local sectionTabSwitchers = Instance.new("Frame")
		sectionTabSwitchers.Name = "SectionTabSwitchers"
		sectionTabSwitchers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		sectionTabSwitchers.BackgroundTransparency = 1
		sectionTabSwitchers.BorderColor3 = Color3.fromRGB(0, 0, 0)
		sectionTabSwitchers.BorderSizePixel = 0
		sectionTabSwitchers.Size = UDim2.fromScale(1, 1)

		local uIListLayout1 = Instance.new("UIListLayout")
		uIListLayout1.Name = "UIListLayout"
		uIListLayout1.Padding = UDim.new(0, 15)
		uIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout1.Parent = sectionTabSwitchers

		local uIPadding1 = Instance.new("UIPadding")
		uIPadding1.Name = "UIPadding"
		uIPadding1.PaddingBottom = UDim.new(0, 15)
		uIPadding1.Parent = sectionTabSwitchers

		sectionTabSwitchers.Parent = tabGroup
		tabGroup.Parent = tabSwitchersScrollingFrame

		function SectionFunctions:Tab(Settings)
			local TabFunctions = {Settings = Settings}
			local tabSwitcher = Instance.new("TextButton")
			tabSwitcher.Name = "TabSwitcher"
			tabSwitcher.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			tabSwitcher.Text = ""
			tabSwitcher.TextColor3 = Color3.fromRGB(0, 0, 0)
			tabSwitcher.TextSize = 14
			tabSwitcher.AutoButtonColor = false
			tabSwitcher.AnchorPoint = Vector2.new(0.5, 0)
			tabSwitcher.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcher.BackgroundTransparency = 1
			tabSwitcher.BorderColor3 = Color3.fromRGB(0, 0, 0)
			tabSwitcher.BorderSizePixel = 0
			tabSwitcher.Position = UDim2.fromScale(0.5, 0)
			tabSwitcher.Size = UDim2.new(1, -21, 0, 40)

			tabIndex += 1
			tabSwitcher.LayoutOrder = tabIndex

			local tabSwitcherUICorner = Instance.new("UICorner")
			tabSwitcherUICorner.Name = "TabSwitcherUICorner"
			tabSwitcherUICorner.Parent = tabSwitcher

			local tabSwitcherUIStroke = Instance.new("UIStroke")
			tabSwitcherUIStroke.Name = "TabSwitcherUIStroke"
			tabSwitcherUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			tabSwitcherUIStroke.Color = Color3.fromRGB(255, 255, 255)
			tabSwitcherUIStroke.Transparency = 1
			tabSwitcherUIStroke.Parent = tabSwitcher

			local tabSwitcherUIListLayout = Instance.new("UIListLayout")
			tabSwitcherUIListLayout.Name = "TabSwitcherUIListLayout"
			tabSwitcherUIListLayout.Padding = UDim.new(0, 9)
			tabSwitcherUIListLayout.FillDirection = Enum.FillDirection.Horizontal
			tabSwitcherUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			tabSwitcherUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			tabSwitcherUIListLayout.Parent = tabSwitcher

			local tabImage

			if Settings.Image then
				tabImage = Instance.new("ImageLabel")
				tabImage.Name = "TabImage"
				tabImage.Image = Settings.Image
				tabImage.ImageTransparency = 0.5
				tabImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				tabImage.BackgroundTransparency = 1
				tabImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
				tabImage.BorderSizePixel = 0
				tabImage.Size = UDim2.fromOffset(18, 18)
				tabImage.Parent = tabSwitcher
			end

			local tabSwitcherName = Instance.new("TextLabel")
			tabSwitcherName.Name = "TabSwitcherName"
			tabSwitcherName.FontFace = Font.new(
				assets.interFont,
				Enum.FontWeight.Medium,
				Enum.FontStyle.Normal
			)
			tabSwitcherName.Text = Settings.Name
			tabSwitcherName.RichText = true
			tabSwitcherName.TextColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcherName.TextSize = 16
			tabSwitcherName.TextTransparency = 0.5
			tabSwitcherName.TextTruncate = Enum.TextTruncate.SplitWord
			tabSwitcherName.TextXAlignment = Enum.TextXAlignment.Left
			tabSwitcherName.TextYAlignment = Enum.TextYAlignment.Top
			tabSwitcherName.AutomaticSize = Enum.AutomaticSize.Y
			tabSwitcherName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcherName.BackgroundTransparency = 1
			tabSwitcherName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			tabSwitcherName.BorderSizePixel = 0
			tabSwitcherName.Size = UDim2.fromScale(1, 0)
			tabSwitcherName.Parent = tabSwitcher
			tabSwitcherName.LayoutOrder = 1

			local tabSwitcherUIPadding = Instance.new("UIPadding")
			tabSwitcherUIPadding.Name = "TabSwitcherUIPadding"
			tabSwitcherUIPadding.PaddingLeft = UDim.new(0, 24)
			tabSwitcherUIPadding.PaddingRight = UDim.new(0, 35)
			tabSwitcherUIPadding.PaddingTop = UDim.new(0, 1)
			tabSwitcherUIPadding.Parent = tabSwitcher

			tabSwitcher.Parent = sectionTabSwitchers

			local elements1 = Instance.new("Frame")
			elements1.Name = "Elements"
			elements1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			elements1.BackgroundTransparency = 1
			elements1.BorderColor3 = Color3.fromRGB(0, 0, 0)
			elements1.BorderSizePixel = 0
			elements1.Position = UDim2.fromOffset(0, 63)
			elements1.Size = UDim2.new(1, 0, 1, -63)
			elements1.ClipsDescendants = true

			local elementsUIPadding = Instance.new("UIPadding")
			elementsUIPadding.Name = "ElementsUIPadding"
			elementsUIPadding.PaddingRight = UDim.new(0, 5)
			elementsUIPadding.PaddingTop = UDim.new(0, 10)
			elementsUIPadding.PaddingBottom = UDim.new(0, 10)
			elementsUIPadding.Parent = elements1

			local elementsScrolling = Instance.new("ScrollingFrame")
			elementsScrolling.Name = "ElementsScrolling"
			elementsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
			elementsScrolling.BottomImage = ""
			elementsScrolling.CanvasSize = UDim2.new()
			elementsScrolling.ScrollBarImageTransparency = 0.5
			elementsScrolling.ScrollBarThickness = 1
			elementsScrolling.TopImage = ""
			elementsScrolling.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			elementsScrolling.BackgroundTransparency = 1
			elementsScrolling.BorderColor3 = Color3.fromRGB(0, 0, 0)
			elementsScrolling.BorderSizePixel = 0
			elementsScrolling.Size = UDim2.fromScale(1, 1)
			elementsScrolling.ClipsDescendants = false

			local elementsScrollingUIPadding = Instance.new("UIPadding")
			elementsScrollingUIPadding.Name = "ElementsScrollingUIPadding"
			elementsScrollingUIPadding.PaddingBottom = UDim.new(0, 5)
			elementsScrollingUIPadding.PaddingLeft = UDim.new(0, 11)
			elementsScrollingUIPadding.PaddingRight = UDim.new(0, 3)
			elementsScrollingUIPadding.PaddingTop = UDim.new(0, 5)
			elementsScrollingUIPadding.Parent = elementsScrolling

			local elementsScrollingUIListLayout = Instance.new("UIListLayout")
			elementsScrollingUIListLayout.Name = "ElementsScrollingUIListLayout"
			elementsScrollingUIListLayout.Padding = UDim.new(0, 15)
			elementsScrollingUIListLayout.FillDirection = Enum.FillDirection.Horizontal
			elementsScrollingUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			elementsScrollingUIListLayout.Parent = elementsScrolling

			local left = Instance.new("Frame")
			left.Name = "Left"
			left.AutomaticSize = Enum.AutomaticSize.Y
			left.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			left.BackgroundTransparency = 1
			left.BorderColor3 = Color3.fromRGB(0, 0, 0)
			left.BorderSizePixel = 0
			left.Position = UDim2.fromScale(0.512, 0)
			left.Size = UDim2.new(0.5, -10, 0, 0)

			local leftUIListLayout = Instance.new("UIListLayout")
			leftUIListLayout.Name = "LeftUIListLayout"
			leftUIListLayout.Padding = UDim.new(0, 15)
			leftUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			leftUIListLayout.Parent = left

			left.Parent = elementsScrolling

			local right = Instance.new("Frame")
			right.Name = "Right"
			right.AutomaticSize = Enum.AutomaticSize.Y
			right.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			right.BackgroundTransparency = 1
			right.BorderColor3 = Color3.fromRGB(0, 0, 0)
			right.BorderSizePixel = 0
			right.LayoutOrder = 1
			right.Position = UDim2.fromScale(0.512, 0)
			right.Size = UDim2.new(0.5, -10, 0, 0)

			local rightUIListLayout = Instance.new("UIListLayout")
			rightUIListLayout.Name = "RightUIListLayout"
			rightUIListLayout.Padding = UDim.new(0, 15)
			rightUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			rightUIListLayout.Parent = right

			right.Parent = elementsScrolling
			elementsScrolling.Parent = elements1

			function TabFunctions:Section(Settings)
				local SectionFunctions = {}
				local section = Instance.new("Frame")
				section.Name = "Section"
				section.AutomaticSize = Enum.AutomaticSize.Y
				section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				section.BackgroundTransparency = 0.98
				section.BorderColor3 = Color3.fromRGB(0, 0, 0)
				section.BorderSizePixel = 0
				section.Position = UDim2.fromScale(0, 6.78e-08)
				section.Size = UDim2.fromScale(1, 0)
				section.ClipsDescendants = true
				section.Parent = Settings.Side == "Left" and left or right

				local sectionUICorner = Instance.new("UICorner")
				sectionUICorner.Name = "SectionUICorner"
				sectionUICorner.Parent = section

				local sectionUIStroke = Instance.new("UIStroke")
				sectionUIStroke.Name = "SectionUIStroke"
				sectionUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				sectionUIStroke.Color = Color3.fromRGB(255, 255, 255)
				sectionUIStroke.Transparency = 0.95
				sectionUIStroke.Parent = section

				local sectionUIListLayout = Instance.new("UIListLayout")
				sectionUIListLayout.Name = "SectionUIListLayout"
				sectionUIListLayout.Padding = UDim.new(0, 10)
				sectionUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				sectionUIListLayout.Parent = section

				local sectionUIPadding = Instance.new("UIPadding")
				sectionUIPadding.Name = "SectionUIPadding"
				sectionUIPadding.PaddingBottom = UDim.new(0, 20)
				sectionUIPadding.PaddingLeft = UDim.new(0, 20)
				sectionUIPadding.PaddingRight = UDim.new(0, 18)
				sectionUIPadding.PaddingTop = UDim.new(0, 22)
				sectionUIPadding.Parent = section

				function SectionFunctions:Button(Settings, Flag)
					local ButtonFunctions = {Settings = Settings}
					local button = Instance.new("Frame")
					button.Name = "Button"
					button.AutomaticSize = Enum.AutomaticSize.Y
					button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					button.BackgroundTransparency = 1
					button.BorderColor3 = Color3.fromRGB(0, 0, 0)
					button.BorderSizePixel = 0
					button.Size = UDim2.new(1, 0, 0, 38)
					button.Parent = section

					local buttonInteract = Instance.new("TextButton")
					buttonInteract.Name = "ButtonInteract"
					buttonInteract.FontFace = Font.new(assets.interFont)
					buttonInteract.RichText = true
					buttonInteract.TextColor3 = Color3.fromRGB(255, 255, 255)
					buttonInteract.TextSize = 13
					buttonInteract.TextTransparency = 0.5
					buttonInteract.TextTruncate = Enum.TextTruncate.AtEnd
					buttonInteract.TextXAlignment = Enum.TextXAlignment.Left
					buttonInteract.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					buttonInteract.BackgroundTransparency = 1
					buttonInteract.BorderColor3 = Color3.fromRGB(0, 0, 0)
					buttonInteract.BorderSizePixel = 0
					buttonInteract.Size = UDim2.fromScale(1, 1)
					buttonInteract.Parent = button
					buttonInteract.Text = ButtonFunctions.Settings.Name

					local buttonImage = Instance.new("ImageLabel")
					buttonImage.Name = "ButtonImage"
					buttonImage.Image = assets.buttonImage
					buttonImage.ImageTransparency = 0.5
					buttonImage.AnchorPoint = Vector2.new(1, 0.5)
					buttonImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					buttonImage.BackgroundTransparency = 1
					buttonImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
					buttonImage.BorderSizePixel = 0
					buttonImage.Position = UDim2.fromScale(1, 0.5)
					buttonImage.Size = UDim2.fromOffset(15, 15)
					buttonImage.Parent = button

					local TweenSettings = {
						DefaultTransparency = 0.5,
						HoverTransparency = 0.3,
						EasingStyle = Enum.EasingStyle.Sine
					}

					local function ChangeState(State)
						if State == "Idle" then
							Tween(buttonInteract, TweenInfo.new(0.2, TweenSettings.EasingStyle), { TextTransparency = TweenSettings.DefaultTransparency }):Play()
							Tween(buttonImage, TweenInfo.new(0.2, TweenSettings.EasingStyle), { ImageTransparency = TweenSettings.DefaultTransparency }):Play()
						elseif State == "Hover" then
							Tween(buttonInteract, TweenInfo.new(0.2, TweenSettings.EasingStyle), { TextTransparency = TweenSettings.HoverTransparency }):Play()
							Tween(buttonImage, TweenInfo.new(0.2, TweenSettings.EasingStyle), { ImageTransparency = TweenSettings.HoverTransparency }):Play()
						end
					end

					buttonInteract.MouseEnter:Connect(function() ChangeState("Hover") end)
					buttonInteract.MouseLeave:Connect(function() ChangeState("Idle") end)
					buttonInteract.MouseButton1Click:Connect(function()
						if ButtonFunctions.Settings.Callback then
							ButtonFunctions.Settings.Callback()
						end
					end)

					function ButtonFunctions:UpdateName(Name) buttonInteract.Text = Name end
					function ButtonFunctions:SetVisibility(State) button.Visible = State end

					if Flag then MacLib.Options[Flag] = ButtonFunctions end
					return ButtonFunctions
				end

				function SectionFunctions:Header(Settings, Flag)
					local HeaderFunctions = {Settings = Settings}
					local header = Instance.new("Frame")
					header.Name = "Header"
					header.AutomaticSize = Enum.AutomaticSize.Y
					header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					header.BackgroundTransparency = 1
					header.BorderColor3 = Color3.fromRGB(0, 0, 0)
					header.BorderSizePixel = 0
					header.LayoutOrder = 0
					header.Size = UDim2.fromScale(1, 0)
					header.Parent = section

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingBottom = UDim.new(0, 5)
					uIPadding.Parent = header

					local headerText = Instance.new("TextLabel")
					headerText.Name = "HeaderText"
					headerText.FontFace = Font.new(assets.interFont, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
					headerText.RichText = true
					headerText.Text = HeaderFunctions.Settings.Text or HeaderFunctions.Settings.Name
					headerText.TextColor3 = Color3.fromRGB(255, 255, 255)
					headerText.TextSize = 16
					headerText.TextTransparency = 0.3
					headerText.TextWrapped = true
					headerText.TextXAlignment = Enum.TextXAlignment.Left
					headerText.AutomaticSize = Enum.AutomaticSize.Y
					headerText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					headerText.BackgroundTransparency = 1
					headerText.BorderColor3 = Color3.fromRGB(0, 0, 0)
					headerText.BorderSizePixel = 0
					headerText.Size = UDim2.fromScale(1, 0)
					headerText.Parent = header

					function HeaderFunctions:UpdateName(New) headerText.Text = New end
					function HeaderFunctions:SetVisibility(State) header.Visible = State end

					if Flag then MacLib.Options[Flag] = HeaderFunctions end
					return HeaderFunctions
				end

				function SectionFunctions:Label(Settings, Flag)
					local LabelFunctions = {Settings = Settings}
					local label = Instance.new("Frame")
					label.Name = "Label"
					label.AutomaticSize = Enum.AutomaticSize.Y
					label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					label.BackgroundTransparency = 1
					label.BorderColor3 = Color3.fromRGB(0, 0, 0)
					label.BorderSizePixel = 0
					label.Size = UDim2.new(1, 0, 0, 38)
					label.Parent = section

					local labelText = Instance.new("TextLabel")
					labelText.Name = "LabelText"
					labelText.FontFace = Font.new(assets.interFont)
					labelText.RichText = true
					labelText.Text = LabelFunctions.Settings.Text or LabelFunctions.Settings.Name
					labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
					labelText.TextSize = 13
					labelText.TextTransparency = 0.5
					labelText.TextWrapped = true
					labelText.TextXAlignment = Enum.TextXAlignment.Left
					labelText.AutomaticSize = Enum.AutomaticSize.Y
					labelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					labelText.BackgroundTransparency = 1
					labelText.BorderColor3 = Color3.fromRGB(0, 0, 0)
					labelText.BorderSizePixel = 0
					labelText.Size = UDim2.fromScale(1, 1)
					labelText.Parent = label

					function LabelFunctions:UpdateName(New) labelText.Text = New end
					function LabelFunctions:SetVisibility(State) label.Visible = State end

					if Flag then MacLib.Options[Flag] = LabelFunctions end
					return LabelFunctions
				end

				function SectionFunctions:Paragraph(Settings, Flag)
					local ParagraphFunctions = {Settings = Settings}
					local paragraph = Instance.new("Frame")
					paragraph.Name = "Paragraph"
					paragraph.AutomaticSize = Enum.AutomaticSize.Y
					paragraph.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					paragraph.BackgroundTransparency = 1
					paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraph.BorderSizePixel = 0
					paragraph.Size = UDim2.new(1, 0, 0, 38)
					paragraph.Parent = section

					local paragraphHeader = Instance.new("TextLabel")
					paragraphHeader.Name = "ParagraphHeader"
					paragraphHeader.FontFace = Font.new(assets.interFont, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
					paragraphHeader.RichText = true
					paragraphHeader.Text = ParagraphFunctions.Settings.Header
					paragraphHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
					paragraphHeader.TextSize = 15
					paragraphHeader.TextTransparency = 0.4
					paragraphHeader.TextWrapped = true
					paragraphHeader.TextXAlignment = Enum.TextXAlignment.Left
					paragraphHeader.AutomaticSize = Enum.AutomaticSize.Y
					paragraphHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					paragraphHeader.BackgroundTransparency = 1
					paragraphHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraphHeader.BorderSizePixel = 0
					paragraphHeader.Size = UDim2.fromScale(1, 0)
					paragraphHeader.Parent = paragraph

					local uIListLayout = Instance.new("UIListLayout")
					uIListLayout.Name = "UIListLayout"
					uIListLayout.Padding = UDim.new(0, 5)
					uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout.Parent = paragraph

					local paragraphBody = Instance.new("TextLabel")
					paragraphBody.Name = "ParagraphBody"
					paragraphBody.FontFace = Font.new(assets.interFont)
					paragraphBody.RichText = true
					paragraphBody.Text = ParagraphFunctions.Settings.Body
					paragraphBody.TextColor3 = Color3.fromRGB(255, 255, 255)
					paragraphBody.TextSize = 13
					paragraphBody.TextTransparency = 0.5
					paragraphBody.TextWrapped = true
					paragraphBody.TextXAlignment = Enum.TextXAlignment.Left
					paragraphBody.AutomaticSize = Enum.AutomaticSize.Y
					paragraphBody.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					paragraphBody.BackgroundTransparency = 1
					paragraphBody.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraphBody.BorderSizePixel = 0
					paragraphBody.LayoutOrder = 1
					paragraphBody.Size = UDim2.fromScale(1, 0)
					paragraphBody.Parent = paragraph

					function ParagraphFunctions:UpdateHeader(New) paragraphHeader.Text = New end
					function ParagraphFunctions:UpdateBody(New) paragraphBody.Text = New end
					function ParagraphFunctions:SetVisibility(State) paragraph.Visible = State end

					if Flag then MacLib.Options[Flag] = ParagraphFunctions end
					return ParagraphFunctions
				end

				return SectionFunctions
			end

			local function SelectCurrentTab()
				local easetime = 0.15
				if currentTabInstance then currentTabInstance.Parent = nil end

				for i, tabInfo in pairs(tabs) do
					Tween(i, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
						BackgroundTransparency = (i == tabSwitcher and 0.98 or 1)
					}):Play()

					if tabInfo.tabStroke then
						Tween(tabInfo.tabStroke, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							Transparency = (i == tabSwitcher and 0.95 or 1)
						}):Play()
					end
					if tabInfo.switcherImage then
						Tween(tabInfo.switcherImage, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							ImageTransparency = (i == tabSwitcher and 0.1 or 0.5)
						}):Play()
					end
					if tabInfo.switcherName then
						Tween(tabInfo.switcherName, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							TextTransparency = (i == tabSwitcher and 0.1 or 0.5)
						}):Play()
					end
				end

				tabs[tabSwitcher].tabContent.Parent = content
				currentTabInstance = tabs[tabSwitcher].tabContent
				currentTab.Text = Settings.Name
			end

			tabSwitcher.MouseButton1Click:Connect(SelectCurrentTab)
			function TabFunctions:Select() SelectCurrentTab() end

			function TabFunctions:GetContent()
				elementsScrolling.Visible = false
				return elements1
			end

			tabs[tabSwitcher] = {
				tabContent = elements1,
				tabStroke = tabSwitcherUIStroke,
				switcherImage = tabImage,
				switcherName = tabSwitcherName,
			}

			return TabFunctions
		end

		return SectionFunctions
	end

	function WindowFunctions:Notify(Settings)
		local notification = Instance.new("Frame")
		notification.Name = "Notification"
		notification.AnchorPoint = Vector2.new(0.5, 0.5)
		notification.AutomaticSize = Enum.AutomaticSize.Y
		notification.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notification.BorderSizePixel = 0
		notification.Position = UDim2.fromScale(0.5, 0.5)
		notification.Size = UDim2.fromOffset(Settings.SizeX or 250, 0)
		notification.Parent = notifications

		local notificationUIStroke = Instance.new("UIStroke")
		notificationUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		notificationUIStroke.Color = Color3.fromRGB(255, 255, 255)
		notificationUIStroke.Transparency = 0.9
		notificationUIStroke.Parent = notification

		local notificationUICorner = Instance.new("UICorner")
		notificationUICorner.CornerRadius = UDim.new(0, 10)
		notificationUICorner.Parent = notification

		local notificationUIScale = Instance.new("UIScale")
		notificationUIScale.Parent = notification
		notificationUIScale.Scale = 0

		local notificationInformation = Instance.new("Frame")
		notificationInformation.AutomaticSize = Enum.AutomaticSize.Y
		notificationInformation.BackgroundTransparency = 1
		notificationInformation.Size = UDim2.fromScale(1, 1)

		local notificationTitle = Instance.new("TextLabel")
		notificationTitle.FontFace = Font.new(assets.interFont, Enum.FontWeight.SemiBold)
		notificationTitle.Text = Settings.Title
		notificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		notificationTitle.TextSize = 13
		notificationTitle.TextTransparency = 0.2
		notificationTitle.AutomaticSize = Enum.AutomaticSize.XY
		notificationTitle.BackgroundTransparency = 1
		notificationTitle.Size = UDim2.new(1, -12, 0, 0)
		notificationTitle.Parent = notificationInformation

		local notificationDescription = Instance.new("TextLabel")
		notificationDescription.FontFace = Font.new(assets.interFont, Enum.FontWeight.Medium)
		notificationDescription.Text = Settings.Description
		notificationDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
		notificationDescription.TextSize = 11
		notificationDescription.TextTransparency = 0.5
		notificationDescription.TextWrapped = true
		notificationDescription.AutomaticSize = Enum.AutomaticSize.XY
		notificationDescription.BackgroundTransparency = 1
		notificationDescription.Size = UDim2.new(1, -12, 0, 0)
		notificationDescription.Parent = notificationInformation
		notificationInformation.Parent = notification

		task.spawn(function()
			Tween(notificationUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { Scale = 1 }):Play()
			task.wait(Settings.Lifetime or 3)
			local out = Tween(notificationUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { Scale = 0 })
			out:Play()
			out.Completed:Wait()
			notification:Destroy()
		end)
	end

	function WindowFunctions:SetState(State)
		windowState = State
		base.Visible = State
	end
	function WindowFunctions:GetState()
		return windowState
	end

	function WindowFunctions:Reveal()
		base.Visible = true
		baseUIScale.Scale = 0.9
		Tween(baseUIScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	end

	local floatingGui = Instance.new("ScreenGui")
	floatingGui.Name = "Mk7_FloatingBubble"
	floatingGui.ResetOnSpawn = false
	floatingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	floatingGui.DisplayOrder = 2147483646
	floatingGui.IgnoreGuiInset = true

	local okFloatParent = pcall(function()
		floatingGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
	end)
	if not okFloatParent then
		floatingGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end

	local bubble = Instance.new("TextButton")
	bubble.Name = "Mk7Bubble"
	bubble.AnchorPoint = Vector2.new(0, 0)
	bubble.Position = UDim2.new(0, 20, 1, -80)
	bubble.Size = UDim2.fromOffset(60, 60)
	bubble.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bubble.BorderSizePixel = 0
	bubble.AutoButtonColor = false
	bubble.Text = "Mk7"
	bubble.FontFace = Font.new(assets.interFont, Enum.FontWeight.Bold, Enum.FontStyle.Italic)
	bubble.TextSize = 18
	bubble.TextColor3 = Color3.fromRGB(255, 255, 255)
	bubble.TextStrokeTransparency = 1
	bubble.Visible = false
	bubble.Parent = floatingGui

	local bubbleCorner = Instance.new("UICorner")
	bubbleCorner.CornerRadius = UDim.new(1, 0)
	bubbleCorner.Parent = bubble

	local bubbleStroke = Instance.new("UIStroke")
	bubbleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	bubbleStroke.Color = Color3.fromRGB(80, 80, 80)
	bubbleStroke.Transparency = 0.5
	bubbleStroke.Thickness = 1.5
	bubbleStroke.Parent = bubble

	local bubbleScale = Instance.new("UIScale")
	bubbleScale.Parent = bubble

	task.spawn(function()
		while bubble and bubble.Parent do
			Tween(bubbleScale, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Scale = 1.08 }):Play()
			task.wait(0.8)
			if not bubble or not bubble.Parent then break end
			Tween(bubbleScale, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Scale = 1 }):Play()
			task.wait(0.8)
		end
	end)

	bubble.MouseEnter:Connect(function()
		Tween(bubble, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
			BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		}):Play()
		Tween(bubbleStroke, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
			Transparency = 0.2
		}):Play()
	end)
	bubble.MouseLeave:Connect(function()
		Tween(bubble, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
			BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		}):Play()
		Tween(bubbleStroke, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
			Transparency = 0.5
		}):Play()
	end)

	local bubbleDragging = false
	local bubbleDragStart = nil
	local bubbleStartPos = nil
	local bubbleMoved = false
	local bubbleDragInput = nil

	local function bubbleDragUpdate(input)
		if bubbleDragging and bubbleStartPos and bubbleDragStart then
			local delta = input.Position - bubbleDragStart
			if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
				bubbleMoved = true
			end
			bubble.Position = UDim2.new(
				bubbleStartPos.X.Scale,
				bubbleStartPos.X.Offset + delta.X,
				bubbleStartPos.Y.Scale,
				bubbleStartPos.Y.Offset + delta.Y
			)
		end
	end

	bubble.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			bubbleDragging = true
			bubbleMoved = false
			bubbleDragStart = input.Position
			bubbleStartPos = bubble.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					bubbleDragging = false
				end
			end)
		end
	end)

	bubble.InputChanged:Connect(function(input)
		if bubbleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			bubbleDragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == bubbleDragInput then
			bubbleDragUpdate(input)
		end
	end)

	bubble.MouseButton1Click:Connect(function()
		if bubbleMoved then
			bubbleMoved = false
			return
		end
		bubble.Visible = false
		base.Visible = true
		WindowFunctions:SetState(true)
		baseUIScale.Scale = 0.95
		Tween(baseUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	end)

	minimizeBtn.MouseButton1Click:Connect(function()
		Tween(baseUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.9 }):Play()
		task.wait(0.15)
		base.Visible = false
		WindowFunctions:SetState(false)
		bubble.Visible = true
	end)

	closeBtn.MouseButton1Click:Connect(function()
		if macLib then
			pcall(function() macLib:Destroy() end)
		end
		if floatingGui then
			pcall(function() floatingGui:Destroy() end)
		end
		local espCheck = (gethui and gethui() or game:GetService("CoreGui")):FindFirstChild("Mk7_ESP_Gui")
		if espCheck then
			pcall(function() espCheck:Destroy() end)
		end
		local fovGuiCheck = (gethui and gethui() or game:GetService("CoreGui")):FindFirstChild("Mk7AimbotFOV")
		if fovGuiCheck then
			pcall(function() fovGuiCheck:Destroy() end)
		end
		for _, v in pairs(Lighting:GetChildren()) do
			if v:IsA("DepthOfFieldEffect") and v:HasTag(".") then
				pcall(function() v:Destroy() end)
			end
		end
		unloaded = true
	end)

	local MenuKeybind = Settings.Keybind or Enum.KeyCode.RightControl
	UserInputService.InputEnded:Connect(function(inp, gpe)
		if gpe then return end
		if unloaded then return end
		if inp.KeyCode == MenuKeybind then
			if bubble.Visible then
				bubble.Visible = false
				base.Visible = true
				WindowFunctions:SetState(true)
				baseUIScale.Scale = 0.95
				Tween(baseUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
			else
				WindowFunctions:SetState(not WindowFunctions:GetState())
			end
		end
	end)

	macLib.Enabled = true
	windowState = true
	return WindowFunctions
end

local MacLib = MacLib


-- =====================================================================
-- 2. INTRO ANIMATION
-- =====================================================================
local CUSTOM_INTRO_IMAGE = "rbxassetid://125695892332574"

local function PlayIntro(onComplete)
	local introGui = Instance.new("ScreenGui")
	introGui.Name = "Mk7_Intro"
	introGui.ResetOnSpawn = false
	introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	introGui.DisplayOrder = 2147483647
	introGui.IgnoreGuiInset = true

	local okParent = pcall(function()
		introGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
	end)
	if not okParent then
		introGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end

	local blurEffect = Instance.new("BlurEffect")
	blurEffect.Name = "Mk7IntroBlur"
	blurEffect.Size = 0
	blurEffect.Parent = Lighting

	local bg = Instance.new("Frame")
	bg.Name = "Background"
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 1
	bg.BorderSizePixel = 0
	bg.Size = UDim2.fromScale(1, 1)
	bg.Parent = introGui

	local container = Instance.new("Frame")
	container.Name = "Container"
	container.BackgroundTransparency = 1
	container.AnchorPoint = Vector2.new(0.5, 0.5)
	container.Position = UDim2.fromScale(0.5, 0.5)
	container.Size = UDim2.fromOffset(600, 400)
	container.Parent = bg

	local avatarCircle = Instance.new("ImageLabel")
	avatarCircle.Name = "AvatarCircle"
	avatarCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	avatarCircle.BorderSizePixel = 0
	avatarCircle.AnchorPoint = Vector2.new(0.5, 0.5)
	avatarCircle.Position = UDim2.new(0.5, 0, 0, 60)
	avatarCircle.Size = UDim2.fromOffset(110, 110)
	avatarCircle.Image = CUSTOM_INTRO_IMAGE
	avatarCircle.ImageTransparency = 1
	avatarCircle.BackgroundTransparency = 1
	avatarCircle.ScaleType = Enum.ScaleType.Crop
	avatarCircle.Parent = container

	local avatarCorner = Instance.new("UICorner")
	avatarCorner.CornerRadius = UDim.new(1, 0)
	avatarCorner.Parent = avatarCircle

	local titleText = "Mk7 Aimbot Hub"

	local titleShadow = Instance.new("TextLabel")
	titleShadow.BackgroundTransparency = 1
	titleShadow.FontFace = Font.new(assets.interFont, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	titleShadow.Text = titleText
	titleShadow.TextSize = 44
	titleShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
	titleShadow.TextTransparency = 1
	titleShadow.TextStrokeTransparency = 1
	titleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	titleShadow.Position = UDim2.new(0.5, 0, 0, 195)
	titleShadow.Size = UDim2.new(1, 0, 0, 60)
	titleShadow.Parent = container

	local title = Instance.new("TextLabel")
	title.BackgroundTransparency = 1
	title.FontFace = Font.new(assets.interFont, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	title.Text = titleText
	title.TextSize = 44
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextTransparency = 1
	title.TextStrokeTransparency = 1
	title.AnchorPoint = Vector2.new(0.5, 0.5)
	title.Position = UDim2.new(0.5, 0, 0, 191)
	title.Size = UDim2.new(1, 0, 0, 60)
	title.Parent = container

	local subtitle = Instance.new("TextLabel")
	subtitle.BackgroundTransparency = 1
	subtitle.FontFace = Font.new(assets.interFont, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
	subtitle.Text = "L O A D I N G"
	subtitle.TextSize = 13
	subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
	subtitle.TextTransparency = 1
	subtitle.TextStrokeTransparency = 1
	subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
	subtitle.Position = UDim2.new(0.5, 0, 0, 235)
	subtitle.Size = UDim2.new(1, 0, 0, 20)
	subtitle.Parent = container

	local barBg = Instance.new("Frame")
	barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	barBg.BorderSizePixel = 0
	barBg.AnchorPoint = Vector2.new(0.5, 0.5)
	barBg.Position = UDim2.new(0.5, 0, 0, 275)
	barBg.Size = UDim2.fromOffset(300, 4)
	barBg.BackgroundTransparency = 1
	barBg.Parent = container

	local barBgCorner = Instance.new("UICorner")
	barBgCorner.CornerRadius = UDim.new(1, 0)
	barBgCorner.Parent = barBg

	local barFill = Instance.new("Frame")
	barFill.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
	barFill.BorderSizePixel = 0
	barFill.Size = UDim2.fromScale(0, 1)
	barFill.Parent = barBg

	local barFillCorner = Instance.new("UICorner")
	barFillCorner.CornerRadius = UDim.new(1, 0)
	barFillCorner.Parent = barFill

	local barGlow = Instance.new("UIStroke")
	barGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	barGlow.Color = Color3.fromRGB(239, 68, 68)
	barGlow.Transparency = 1
	barGlow.Thickness = 2
	barGlow.Parent = barBg

	local percentText = Instance.new("TextLabel")
	percentText.BackgroundTransparency = 1
	percentText.FontFace = Font.new(assets.interFont, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	percentText.Text = "0%"
	percentText.TextSize = 11
	percentText.TextColor3 = Color3.fromRGB(180, 180, 180)
	percentText.TextTransparency = 1
	percentText.TextStrokeTransparency = 1
	percentText.AnchorPoint = Vector2.new(0.5, 0)
	percentText.Position = UDim2.new(0.5, 0, 0, 288)
	percentText.Size = UDim2.new(1, 0, 0, 14)
	percentText.Parent = container

	task.spawn(function()
		Tween(blurEffect, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { Size = 24 }):Play()
		Tween(bg, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.5 }):Play()
		task.wait(0.5)

		Tween(avatarCircle, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { ImageTransparency = 0 }):Play()
		task.wait(0.3)

		Tween(title, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { TextTransparency = 0 }):Play()
		Tween(titleShadow, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { TextTransparency = 0.4 }):Play()
		Tween(subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { TextTransparency = 0 }):Play()
		task.wait(0.3)

		Tween(barBg, TweenInfo.new(0.3, Enum.EasingStyle.Sine), { BackgroundTransparency = 0 }):Play()
		Tween(barGlow, TweenInfo.new(0.3, Enum.EasingStyle.Sine), { Transparency = 0.5 }):Play()
		Tween(percentText, TweenInfo.new(0.3, Enum.EasingStyle.Sine), { TextTransparency = 0 }):Play()

		local totalTime = 2.2
		local steps = 100
		local stepTime = totalTime / steps

		for i = 1, steps do
			barFill.Size = UDim2.fromScale(i / 100, 1)
			percentText.Text = i .. "%"
			task.wait(stepTime)
		end

		task.wait(0.3)

		Tween(blurEffect, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { Size = 0 }):Play()
		Tween(bg, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { BackgroundTransparency = 1 }):Play()
		Tween(avatarCircle, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { ImageTransparency = 1 }):Play()
		Tween(title, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { TextTransparency = 1 }):Play()
		Tween(titleShadow, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { TextTransparency = 1 }):Play()
		Tween(subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { TextTransparency = 1 }):Play()
		Tween(barBg, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { BackgroundTransparency = 1 }):Play()
		Tween(barFill, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { BackgroundTransparency = 1 }):Play()
		Tween(barGlow, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { Transparency = 1 }):Play()
		Tween(percentText, TweenInfo.new(0.5, Enum.EasingStyle.Sine), { TextTransparency = 1 }):Play()

		task.wait(0.6)

		if blurEffect and blurEffect.Parent then
			blurEffect:Destroy()
		end

		introGui:Destroy()

		if onComplete then
			onComplete()
		end
	end)
end


-- =====================================================================
-- 3. VOTRE SCRIPT (MK7 HUB)
-- =====================================================================

local Window = MacLib:Window({
	Title = "Mk7 Hub",
	Subtitle = "Thx for using my script !!",
	Size = UDim2.fromOffset(868, 650),
	DragStyle = 1,
	ShowUserInfo = true,
	Keybind = Enum.KeyCode.RightControl,
	AcrylicBlur = true,
})

local tabGroup = Window:TabGroup()

local tabs = {
	Home = tabGroup:Tab({ Name = "Home", Image = "rbxassetid://10723395457" }),
	Combat = tabGroup:Tab({ Name = "Combat", Image = "rbxassetid://10709818534" }),
	Visuals = tabGroup:Tab({ Name = "Visuals", Image = "rbxassetid://10723346959" })
}

--// Onglet Home
do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local HttpService = game:GetService("HttpService")
	local TeleportService = game:GetService("TeleportService")
	local TweenService = game:GetService("TweenService")
	local MarketplaceService = game:GetService("MarketplaceService")
	local Stats = game:GetService("Stats")
	local LocalPlayer = Players.LocalPlayer

	local MAX_FPS = 144
	local ACCENT = Color3.fromRGB(239, 68, 68)
	local FONT = "rbxasset://fonts/families/GothamSSm.json"

	local function Corner(parent, radius)
		local c = Instance.new("UICorner")
		c.CornerRadius = radius or UDim.new(0, 12)
		c.Parent = parent
		return c
	end

	local function Stroke(parent, color, transparency, thickness)
		local s = Instance.new("UIStroke")
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		s.Color = color or Color3.new(1, 1, 1)
		s.Transparency = transparency or 0.9
		s.Thickness = thickness or 1
		s.Parent = parent
		return s
	end

	local function Card(parent, pos, size)
		local f = Instance.new("Frame")
		f.BackgroundColor3 = Color3.new(1, 1, 1)
		f.BackgroundTransparency = 0.94
		f.BorderSizePixel = 0
		f.Position = pos
		f.Size = size
		f.Parent = parent
		Corner(f)
		Stroke(f)
		return f
	end

	local function Label(parent, text, size, weight, transparency, pos, sz, align)
		local l = Instance.new("TextLabel")
		l.BackgroundTransparency = 1
		l.FontFace = Font.new(FONT, weight or Enum.FontWeight.Medium)
		l.Text = text
		l.RichText = true
		l.TextSize = size
		l.TextColor3 = Color3.new(1, 1, 1)
		l.TextTransparency = transparency or 0
		l.TextXAlignment = align or Enum.TextXAlignment.Left
		l.TextYAlignment = Enum.TextYAlignment.Top
		l.TextTruncate = Enum.TextTruncate.AtEnd
		l.Position = pos
		l.Size = sz
		l.Parent = parent
		return l
	end

	local function Chip(parent, text)
		local chip = Instance.new("Frame")
		chip.AutomaticSize = Enum.AutomaticSize.XY
		chip.BackgroundColor3 = Color3.new(1, 1, 1)
		chip.BackgroundTransparency = 0.92
		chip.BorderSizePixel = 0
		chip.Parent = parent
		Corner(chip, UDim.new(1, 0))

		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0, 10)
		pad.PaddingRight = UDim.new(0, 10)
		pad.PaddingTop = UDim.new(0, 5)
		pad.PaddingBottom = UDim.new(0, 5)
		pad.Parent = chip

		local l = Instance.new("TextLabel")
		l.AutomaticSize = Enum.AutomaticSize.XY
		l.BackgroundTransparency = 1
		l.FontFace = Font.new(FONT, Enum.FontWeight.Medium)
		l.Text = text
		l.TextSize = 11
		l.TextColor3 = Color3.new(1, 1, 1)
		l.TextTransparency = 0.25
		l.Parent = chip
		return l
	end

	local function Notify(title, desc)
		Window:Notify({ Title = title, Description = desc, Lifetime = 3 })
	end

	local startTime = os.clock()
	local function Uptime()
		local s = math.floor(os.clock() - startTime)
		if s < 60 then return s .. "s" end
		local m = math.floor(s / 60)
		if m < 60 then return m .. "m" end
		return math.floor(m / 60) .. "h " .. (m % 60) .. "m"
	end

	local function GetPing()
		local ok, v = pcall(function()
			return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		end)
		return ok and math.floor(v) or 0
	end

	local okInfo, gameInfo = pcall(function()
		return MarketplaceService:GetProductInfo(game.PlaceId)
	end)
	local gameName = okInfo and gameInfo.Name or "Unknown Game"

	local okThumb, thumb = pcall(function()
		return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
	end)

	local jobShort = (game.JobId ~= "" and #game.JobId > 8)
		and (game.JobId:sub(1, 4) .. "..." .. game.JobId:sub(-4))
		or (game.JobId ~= "" and game.JobId or "Studio")

	local container = tabs.Home:GetContent()

	local root = Instance.new("ScrollingFrame")
	root.BackgroundTransparency = 1
	root.BorderSizePixel = 0
	root.Size = UDim2.fromScale(1, 1)
	root.CanvasSize = UDim2.fromOffset(0, 420)
	root.ScrollBarThickness = 1
	root.ScrollBarImageTransparency = 0.5
	root.TopImage = ""
	root.BottomImage = ""
	root.Parent = container

	local rootPad = Instance.new("UIPadding")
	rootPad.PaddingLeft = UDim.new(0, 12)
	rootPad.PaddingRight = UDim.new(0, 12)
	rootPad.PaddingTop = UDim.new(0, 6)
	rootPad.Parent = root

	local LEFT_W, RIGHT_W = 0.64, 0.36

	local profile = Card(root, UDim2.fromOffset(0, 0), UDim2.new(LEFT_W, -6, 0, 90))

	local avatar = Instance.new("ImageLabel")
	avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	avatar.BorderSizePixel = 0
	avatar.AnchorPoint = Vector2.new(0, 0.5)
	avatar.Position = UDim2.new(0, 16, 0.5, 0)
	avatar.Size = UDim2.fromOffset(56, 56)
	avatar.Image = okThumb and thumb or ""
	avatar.Parent = profile
	Corner(avatar, UDim.new(1, 0))
	Stroke(avatar, ACCENT, 0.4, 2)

	Label(profile, "Welcome back, " .. LocalPlayer.DisplayName, 16, Enum.FontWeight.SemiBold, 0,
		UDim2.fromOffset(88, 24), UDim2.new(1, -100, 0, 20))
	local profileSub = Label(profile, gameName .. " · 0s on this server", 11, Enum.FontWeight.Medium, 0.45,
		UDim2.fromOffset(88, 50), UDim2.new(1, -100, 0, 16))

	local perf = Card(root, UDim2.new(LEFT_W, 6, 0, 0), UDim2.new(RIGHT_W, -6, 0, 212))

	Label(perf, "PERFORMANCE", 9, Enum.FontWeight.SemiBold, 0.4,
		UDim2.fromOffset(0, 12), UDim2.new(1, 0, 0, 12), Enum.TextXAlignment.Center)

	local RING, T = 112, 9

	local ring = Instance.new("Frame")
	ring.BackgroundTransparency = 1
	ring.AnchorPoint = Vector2.new(0.5, 0)
	ring.Position = UDim2.new(0.5, 0, 0, 34)
	ring.Size = UDim2.fromOffset(RING, RING)
	ring.Parent = perf

	local track = Instance.new("Frame")
	track.BackgroundTransparency = 1
	track.Position = UDim2.fromOffset(T, T)
	track.Size = UDim2.new(1, -2 * T, 1, -2 * T)
	track.Parent = ring
	Corner(track, UDim.new(1, 0))
	Stroke(track, Color3.new(1, 1, 1), 0.88, T)

	local gradSeq = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(0.501, 1),
		NumberSequenceKeypoint.new(1, 1),
	})

	local function Half(posX, circleX)
		local clip = Instance.new("Frame")
		clip.BackgroundTransparency = 1
		clip.ClipsDescendants = true
		clip.Position = UDim2.fromScale(posX, 0)
		clip.Size = UDim2.fromScale(0.5, 1)
		clip.Parent = ring

		local circle = Instance.new("Frame")
		circle.BackgroundTransparency = 1
		circle.Position = UDim2.new(circleX, T, 0, T)
		circle.Size = UDim2.new(2, -2 * T, 1, -2 * T)
		circle.Parent = clip
		Corner(circle, UDim.new(1, 0))
		local s = Stroke(circle, ACCENT, 0, T)

		local g = Instance.new("UIGradient")
		g.Transparency = gradSeq
		g.Parent = s
		return g
	end

	local leftGradient = Half(0, 0)
	local rightGradient = Half(0.5, -1)

	local function SetProgress(p)
		local angle = math.clamp(p, 0, 1) * 360
		leftGradient.Rotation = math.clamp(angle, 180, 360)
		rightGradient.Rotation = math.clamp(angle, 0, 180)
	end
	SetProgress(0)

	local fpsText = Label(ring, "0", 24, Enum.FontWeight.Bold, 0,
		UDim2.new(0, 0, 0.5, -22), UDim2.new(1, 0, 0, 28), Enum.TextXAlignment.Center)
	Label(ring, "frames per second", 9, Enum.FontWeight.Medium, 0.45,
		UDim2.new(0, 0, 0.5, 8), UDim2.new(1, 0, 0, 12), Enum.TextXAlignment.Center)

	local pingLabel = Label(perf, "📶 0 ms", 11, Enum.FontWeight.Medium, 0.4,
		UDim2.fromOffset(0, 168), UDim2.new(1, 0, 0, 16), Enum.TextXAlignment.Center)

	local server = Card(root, UDim2.fromOffset(0, 102), UDim2.new(LEFT_W, -6, 0, 110))

	local icon = Instance.new("ImageLabel")
	icon.BackgroundColor3 = Color3.fromRGB(40, 60, 140)
	icon.BorderSizePixel = 0
	icon.Position = UDim2.fromOffset(16, 17)
	icon.Size = UDim2.fromOffset(76, 76)
	icon.Image = "rbxthumb://type=GameIcon&id=" .. game.GameId .. "&w=150&h=150"
	icon.Parent = server
	Corner(icon, UDim.new(0, 14))
	Stroke(icon, Color3.new(1, 1, 1), 0.8)

	Label(server, gameName, 15, Enum.FontWeight.SemiBold, 0,
		UDim2.fromOffset(108, 14), UDim2.new(1, -120, 0, 20))

	local chips = Instance.new("Frame")
	chips.BackgroundTransparency = 1
	chips.AutomaticSize = Enum.AutomaticSize.Y
	chips.Position = UDim2.fromOffset(108, 42)
	chips.Size = UDim2.new(1, -120, 0, 0)
	chips.Parent = server

	local chipsLayout = Instance.new("UIListLayout")
	chipsLayout.FillDirection = Enum.FillDirection.Horizontal
	chipsLayout.Wraps = true
	chipsLayout.Padding = UDim.new(0, 6)
	chipsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	chipsLayout.Parent = chips

	local playersChip = Chip(chips, "👥 0 / 0")
	local pingChip = Chip(chips, "📡 0 ms")
	local timeChip = Chip(chips, "⏱ 0s")
	Chip(chips, "🔗 Job " .. jobShort)

	local function ActionCard(index, glyph, title, sub, callback)
		local btn = Instance.new("TextButton")
		btn.AutoButtonColor = false
		btn.Text = ""
		btn.BackgroundColor3 = Color3.new(1, 1, 1)
		btn.BackgroundTransparency = 0.94
		btn.BorderSizePixel = 0
		btn.Position = UDim2.new((index - 1) / 3, (index - 1) * 4, 0, 224)
		btn.Size = UDim2.new(1 / 3, -8, 0, 90)
		btn.Parent = root
		Corner(btn)
		Stroke(btn)

		Label(btn, glyph, 18, Enum.FontWeight.Bold, 0, UDim2.fromOffset(16, 14), UDim2.fromOffset(30, 22)).TextColor3 = ACCENT
		Label(btn, title, 13, Enum.FontWeight.SemiBold, 0, UDim2.fromOffset(16, 48), UDim2.new(1, -24, 0, 16))
		Label(btn, sub, 10, Enum.FontWeight.Medium, 0.45, UDim2.fromOffset(16, 65), UDim2.new(1, -24, 0, 14))

		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.88 }):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0.94 }):Play()
		end)
		btn.MouseButton1Click:Connect(callback)
	end

	ActionCard(1, "↻", "Rejoin", "same server", function()
		Notify("Rejoin", "Rejoining the same server...")
		if #Players:GetPlayers() <= 1 then
			LocalPlayer:Kick("\nRejoining...")
			task.wait()
			TeleportService:Teleport(game.PlaceId, LocalPlayer)
		else
			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
		end
	end)

	ActionCard(2, "⇄", "Server Hop", "find a fresh one", function()
		Notify("Server Hop", "Searching for a new server...")
		local ok, data = pcall(function()
			local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)
			return HttpService:JSONDecode(game:HttpGet(url)).data
		end)
		if not ok or type(data) ~= "table" then
			Notify("Server Hop", "Could not fetch the server list.")
			return
		end
		local candidates = {}
		for _, s in ipairs(data) do
			if s.id ~= game.JobId and s.playing < s.maxPlayers then
				table.insert(candidates, s.id)
			end
		end
		if #candidates == 0 then
			Notify("Server Hop", "No other server available.")
			return
		end
		TeleportService:TeleportToPlaceInstance(game.PlaceId, candidates[math.random(#candidates)], LocalPlayer)
	end)

	ActionCard(3, "❐", "Copy Job ID", "share this server", function()
		if setclipboard then
			setclipboard(game.JobId)
			Notify("Job ID", "Job ID copied to clipboard!")
		else
			Notify("Job ID", "setclipboard not supported by your executor.")
		end
	end)

	local frameCount = 0
	local fpsAccumTime = 0
	local currentFPS = 0
	local targetProgress = 0
	local shownProgress = 0
	local lastPingUpdate = 0
	local cachedPing = 0

	RunService.RenderStepped:Connect(function(dt)
		frameCount += 1
		fpsAccumTime += dt

		if fpsAccumTime >= 0.2 then
			currentFPS = math.floor(frameCount / fpsAccumTime + 0.5)
			frameCount = 0
			fpsAccumTime = 0

			fpsText.Text = tostring(currentFPS)
			targetProgress = math.clamp(currentFPS / MAX_FPS, 0, 1)
		end

		shownProgress += (targetProgress - shownProgress) * math.min(dt * 8, 1)
		SetProgress(shownProgress)

		if os.clock() - lastPingUpdate >= 1 then
			lastPingUpdate = os.clock()
			cachedPing = GetPing()
			pingLabel.Text = "📶 " .. cachedPing .. " ms"
			pingChip.Text = "📡 " .. cachedPing .. " ms"
		end
	end)

	task.spawn(function()
		while root and root:IsDescendantOf(game) do
			task.wait(0.5)
			playersChip.Text = "👥 " .. #Players:GetPlayers() .. " / " .. Players.MaxPlayers
			timeChip.Text = "⏱ " .. Uptime()
			profileSub.Text = gameName .. " · " .. Uptime() .. " on this server"
		end
	end)
end

--// Onglet Combat (Aimbot + Triggerbot FULL AUTO + Wallbang + Auto Aim)
do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local VirtualInputManager = game:GetService("VirtualInputManager")
	local LocalPlayer = Players.LocalPlayer
	local Camera = workspace.CurrentCamera

	local TARGET_PART = "Head"
	local PREVIEW_SCALE = 0.18
	local ACCENT = Color3.fromRGB(239, 68, 68)
	local FONT = "rbxasset://fonts/families/GothamSSm.json"

	local state = {
		Enabled = false,
		KeyMode = "Hold",
		AimMode = "Auto",
		Speed = 60,
		FOV = 120,
		Key = { Mouse = Enum.UserInputType.MouseButton2 },
		TeamCheck = false,
		Triggerbot = false,
		TriggerDelay = 50,
		TriggerKey = "Auto",
		Wallbang = false,
		AutoAim = false,
	}
	local held, toggled, listening = false, false, false
	local lastTriggerTime = 0

	local function Corner(parent, radius)
		local c = Instance.new("UICorner")
		c.CornerRadius = radius or UDim.new(0, 12)
		c.Parent = parent
		return c
	end

	local function Stroke(parent, color, transparency, thickness)
		local s = Instance.new("UIStroke")
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		s.Color = color or Color3.new(1, 1, 1)
		s.Transparency = transparency or 0.9
		s.Thickness = thickness or 1
		s.Parent = parent
		return s
	end

	local function Card(parent, pos, size)
		local f = Instance.new("Frame")
		f.BackgroundColor3 = Color3.new(1, 1, 1)
		f.BackgroundTransparency = 0.94
		f.BorderSizePixel = 0
		f.Position = pos
		f.Size = size
		f.Parent = parent
		Corner(f)
		Stroke(f)
		return f
	end

	local function Label(parent, text, size, weight, transparency, pos, sz, align)
		local l = Instance.new("TextLabel")
		l.BackgroundTransparency = 1
		l.FontFace = Font.new(FONT, weight or Enum.FontWeight.Medium)
		l.Text = text
		l.RichText = true
		l.TextSize = size
		l.TextColor3 = Color3.new(1, 1, 1)
		l.TextTransparency = transparency or 0
		l.TextXAlignment = align or Enum.TextXAlignment.Left
		l.TextYAlignment = Enum.TextYAlignment.Top
		l.TextTruncate = Enum.TextTruncate.AtEnd
		l.Position = pos
		l.Size = sz
		l.Parent = parent
		return l
	end

	local function KeyName(key)
		if key.Mouse then
			return "MB" .. key.Mouse.Name:sub(-1)
		end
		return key.Keyboard.Name
	end

	local container = tabs.Combat:GetContent()

	local root = Instance.new("Frame")
	root.BackgroundTransparency = 1
	root.Size = UDim2.fromScale(1, 1)
	root.Parent = container

	local rootPad = Instance.new("UIPadding")
	rootPad.PaddingLeft = UDim.new(0, 12)
	rootPad.PaddingRight = UDim.new(0, 12)
	rootPad.PaddingTop = UDim.new(0, 6)
	rootPad.Parent = root

	local left = Instance.new("ScrollingFrame")
	left.BackgroundTransparency = 1
	left.BorderSizePixel = 0
	left.Size = UDim2.new(0.62, -6, 1, 0)
	left.AutomaticCanvasSize = Enum.AutomaticSize.Y
	left.CanvasSize = UDim2.new()
	left.ScrollBarThickness = 1
	left.ScrollBarImageTransparency = 0.5
	left.TopImage = ""
	left.BottomImage = ""
	left.Parent = root

	local leftLayout = Instance.new("UIListLayout")
	leftLayout.Padding = UDim.new(0, 8)
	leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
	leftLayout.Parent = left

	local leftPad = Instance.new("UIPadding")
	leftPad.PaddingRight = UDim.new(0, 4)
	leftPad.PaddingBottom = UDim.new(0, 8)
	leftPad.Parent = left

	local header = Label(left, '<font color="#ef4444">●</font>  AIMBOT', 11, Enum.FontWeight.SemiBold, 0.4,
		UDim2.new(), UDim2.new(1, 0, 0, 18))
	header.LayoutOrder = 0

	local statusCard = Card(left, UDim2.new(), UDim2.new(1, 0, 0, 46))
	statusCard.LayoutOrder = 1
	local statusLabel = Label(statusCard, "Aimbot is off", 13, Enum.FontWeight.SemiBold, 0,
		UDim2.fromOffset(14, 15), UDim2.new(1, -28, 0, 16))

	local function Row(order, title, desc, height, controlWidth)
		local card = Card(left, UDim2.new(), UDim2.new(1, 0, 0, height))
		card.LayoutOrder = order
		Label(card, title, 12, Enum.FontWeight.SemiBold, 0.05,
			UDim2.fromOffset(14, 12), UDim2.new(1, -(controlWidth + 30), 0, 16))
		Label(card, desc, 10, Enum.FontWeight.Medium, 0.5,
			UDim2.fromOffset(14, 31), UDim2.new(1, -(controlWidth + 30), 0, 14))
		return card
	end

	local function Toggle(card, default, callback)
		local on = default
		local btn = Instance.new("TextButton")
		btn.AutoButtonColor = false
		btn.Text = ""
		btn.AnchorPoint = Vector2.new(1, 0.5)
		btn.Position = UDim2.new(1, -14, 0.5, 0)
		btn.Size = UDim2.fromOffset(44, 22)
		btn.BackgroundColor3 = Color3.fromRGB(70, 70, 82)
		btn.BorderSizePixel = 0
		btn.Parent = card
		Corner(btn, UDim.new(1, 0))

		local knob = Instance.new("Frame")
		knob.BackgroundColor3 = Color3.new(1, 1, 1)
		knob.BorderSizePixel = 0
		knob.Position = UDim2.fromOffset(3, 3)
		knob.Size = UDim2.fromOffset(16, 16)
		knob.Parent = btn
		Corner(knob, UDim.new(1, 0))

		local function Render()
			local info = TweenInfo.new(0.15, Enum.EasingStyle.Sine)
			TweenService:Create(btn, info, { BackgroundColor3 = on and ACCENT or Color3.fromRGB(70, 70, 82) }):Play()
			TweenService:Create(knob, info, { Position = on and UDim2.fromOffset(25, 3) or UDim2.fromOffset(3, 3) }):Play()
		end

		btn.MouseButton1Click:Connect(function()
			on = not on
			Render()
			callback(on)
		end)
		Render()
	end

	local function Segmented(card, options, default, callback)
		local W = 64
		local holder = Instance.new("Frame")
		holder.BackgroundTransparency = 1
		holder.AnchorPoint = Vector2.new(1, 0.5)
		holder.Position = UDim2.new(1, -12, 0.5, 0)
		holder.Size = UDim2.fromOffset(#options * W, 32)
		holder.Parent = card

		local buttons = {}
		local function Select(name)
			for n, b in pairs(buttons) do
				local sel = (n == name)
				TweenService:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
					BackgroundTransparency = sel and 0 or 1,
					TextTransparency = sel and 0 or 0.4,
				}):Play()
			end
		end

		for i, name in ipairs(options) do
			local b = Instance.new("TextButton")
			b.AutoButtonColor = false
			b.BackgroundColor3 = ACCENT
			b.BackgroundTransparency = 1
			b.BorderSizePixel = 0
			b.Position = UDim2.fromOffset((i - 1) * W, 0)
			b.Size = UDim2.fromOffset(W - 4, 32)
			b.FontFace = Font.new(FONT, Enum.FontWeight.SemiBold)
			b.Text = name
			b.TextSize = 11
			b.TextColor3 = Color3.new(1, 1, 1)
			b.Parent = holder
			Corner(b, UDim.new(0, 8))
			buttons[name] = b

			b.MouseButton1Click:Connect(function()
				Select(name)
				callback(name)
			end)
		end
		Select(default)
	end

	local function Slider(order, title, desc, min, max, default, suffix, callback)
		local card = Card(left, UDim2.new(), UDim2.new(1, 0, 0, 78))
		card.LayoutOrder = order

		Label(card, title, 12, Enum.FontWeight.SemiBold, 0.05,
			UDim2.fromOffset(14, 12), UDim2.new(1, -100, 0, 16))
		local valueLabel = Label(card, "", 12, Enum.FontWeight.SemiBold, 0,
			UDim2.new(1, -94, 0, 12), UDim2.fromOffset(80, 16), Enum.TextXAlignment.Right)
		valueLabel.TextColor3 = ACCENT
		Label(card, desc, 10, Enum.FontWeight.Medium, 0.5,
			UDim2.fromOffset(14, 31), UDim2.new(1, -28, 0, 14))

		local track = Instance.new("Frame")
		track.BackgroundColor3 = Color3.new(1, 1, 1)
		track.BackgroundTransparency = 0.88
		track.BorderSizePixel = 0
		track.Position = UDim2.new(0, 14, 0, 58)
		track.Size = UDim2.new(1, -28, 0, 4)
		track.Parent = card
		Corner(track, UDim.new(1, 0))

		local fill = Instance.new("Frame")
		fill.BackgroundColor3 = ACCENT
		fill.BorderSizePixel = 0
		fill.Size = UDim2.fromScale(0, 1)
		fill.Parent = track
		Corner(fill, UDim.new(1, 0))

		local knob = Instance.new("Frame")
		knob.BackgroundColor3 = ACCENT
		knob.BorderSizePixel = 0
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Position = UDim2.fromScale(0, 0.5)
		knob.Size = UDim2.fromOffset(16, 16)
		knob.Parent = track
		Corner(knob, UDim.new(1, 0))
		Stroke(knob, Color3.new(1, 1, 1), 0.6, 2)

		local function Apply(v)
			v = math.clamp(v, min, max)
			local a = (v - min) / (max - min)
			fill.Size = UDim2.fromScale(a, 1)
			knob.Position = UDim2.fromScale(a, 0.5)
			valueLabel.Text = v .. (suffix ~= "" and (" " .. suffix) or "")
			callback(v)
		end

		local dragging = false
		local function FromX(x)
			local a = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
			Apply(math.floor(min + (max - min) * a + 0.5))
		end

		local hit = Instance.new("TextButton")
		hit.Text = ""
		hit.BackgroundTransparency = 1
		hit.Position = UDim2.new(0, 14, 0, 46)
		hit.Size = UDim2.new(1, -28, 0, 28)
		hit.Parent = card

		hit.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				FromX(input.Position.X)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				FromX(input.Position.X)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		Apply(default)
	end

	local preview = Card(root, UDim2.new(0.62, 6, 0, 0), UDim2.new(0.38, -6, 0, 262))

	Label(preview, "FOV PREVIEW", 9, Enum.FontWeight.SemiBold, 0.4,
		UDim2.fromOffset(14, 14), UDim2.new(0.5, 0, 0, 12))
	local fovValue = Label(preview, "120 px", 12, Enum.FontWeight.SemiBold, 0.1,
		UDim2.new(0.5, 0, 0, 12), UDim2.new(0.5, -14, 0, 14), Enum.TextXAlignment.Right)

	local box = Instance.new("Frame")
	box.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
	box.BackgroundTransparency = 0.2
	box.BorderSizePixel = 0
	box.ClipsDescendants = true
	box.Position = UDim2.fromOffset(12, 38)
	box.Size = UDim2.new(1, -24, 1, -52)
	box.Parent = preview
	Corner(box, UDim.new(0, 10))
	Stroke(box, Color3.new(1, 1, 1), 0.92)

	local previewCircle = Instance.new("Frame")
	previewCircle.BackgroundTransparency = 1
	previewCircle.AnchorPoint = Vector2.new(0.5, 0.5)
	previewCircle.Position = UDim2.fromScale(0.4, 0.5)
	previewCircle.Size = UDim2.fromOffset(44, 44)
	previewCircle.Parent = box
	Corner(previewCircle, UDim.new(1, 0))
	Stroke(previewCircle, Color3.new(1, 1, 1), 0.3, 1.5)

	local cross = Label(previewCircle, "+", 18, Enum.FontWeight.Medium, 0.1, UDim2.new(), UDim2.fromScale(1, 1), Enum.TextXAlignment.Center)
	cross.TextYAlignment = Enum.TextYAlignment.Center

	local okBust, bust = pcall(function()
		return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150)
	end)
	local avatarPrev = Instance.new("ImageLabel")
	avatarPrev.BackgroundTransparency = 1
	avatarPrev.AnchorPoint = Vector2.new(0.5, 0.5)
	avatarPrev.Position = UDim2.fromScale(0.74, 0.5)
	avatarPrev.Size = UDim2.fromOffset(56, 56)
	avatarPrev.Image = okBust and bust or ""
	avatarPrev.Parent = box

	local previewStatus = Label(box, "aimbot off", 10, Enum.FontWeight.Medium, 0.45,
		UDim2.new(0, 10, 1, -22), UDim2.new(1, -20, 0, 14))

	local function UpdatePreview()
		local d = state.FOV * 2 * PREVIEW_SCALE
		previewCircle.Size = UDim2.fromOffset(d, d)
		fovValue.Text = state.FOV .. " px"
	end

	local enabledRow = Row(2, "Enabled", "locks onto targets inside the FOV circle", 62, 44)
	Toggle(enabledRow, false, function(v)
		state.Enabled = v
		if not v then held, toggled = false, false end
	end)

	local keyRow = Row(3, "Aim Key", "hold it to aim. To lock on with no key, set Aim Key Mode to Always", 62, 90)
	local keyBtn = Instance.new("TextButton")
	keyBtn.AutoButtonColor = false
	keyBtn.AnchorPoint = Vector2.new(1, 0.5)
	keyBtn.Position = UDim2.new(1, -12, 0.5, 0)
	keyBtn.Size = UDim2.fromOffset(90, 30)
	keyBtn.BackgroundColor3 = Color3.new(1, 1, 1)
	keyBtn.BackgroundTransparency = 0.92
	keyBtn.BorderSizePixel = 0
	keyBtn.FontFace = Font.new(FONT, Enum.FontWeight.SemiBold)
	keyBtn.Text = KeyName(state.Key)
	keyBtn.TextSize = 12
	keyBtn.TextColor3 = Color3.new(1, 1, 1)
	keyBtn.Parent = keyRow
	Corner(keyBtn, UDim.new(0, 8))
	Stroke(keyBtn, Color3.new(1, 1, 1), 0.88)
	keyBtn.MouseButton1Click:Connect(function()
		listening = true
		keyBtn.Text = "..."
	end)

	local modeRow = Row(4, "Aim Key Mode", "Hold aims while the key is down, Toggle switches on/off, Always needs no key", 62, 192)
	Segmented(modeRow, { "Hold", "Toggle", "Always" }, state.KeyMode, function(v)
		state.KeyMode = v
		held, toggled = false, false
	end)

	local aimRow = Row(5, "Aim Mode", "Camera turns the view, FreeAim moves the cursor, Auto picks for you", 62, 192)
	Segmented(aimRow, { "Auto", "Camera", "FreeAim" }, state.AimMode, function(v)
		state.AimMode = v
		if v == "FreeAim" and not mousemoverel then
			Window:Notify({ Title = "Aimbot", Description = "mousemoverel not supported: Camera mode will be used.", Lifetime = 4 })
		end
	end)

	local teamRow = Row(6, "Team Check", "if enabled, only aims at enemies (ignores teammates)", 62, 44)
	Toggle(teamRow, false, function(v)
		state.TeamCheck = v
	end)

	-- ⭐ AUTO AIM : vise tout seul sans touche
	local autoAimRow = Row(7, "Auto Aim", "aims automatically when a VISIBLE enemy is in the FOV (no key needed)", 62, 44)
	Toggle(autoAimRow, false, function(v)
		state.AutoAim = v
	end)

	-- ⭐ WALLBANG
	local wallbangRow = Row(8, "Wallbang", "target enemies through walls (client-side; damage depends on the game)", 62, 44)
	Toggle(wallbangRow, false, function(v)
		state.Wallbang = v
	end)

	Slider(9, "Cursor Speed", "how far the cursor may travel in one frame", 1, 500, state.Speed, "px", function(v)
		state.Speed = v
	end)

	Slider(10, "FOV", "radius of the circle that picks targets", 10, 600, state.FOV, "", function(v)
		state.FOV = v
		UpdatePreview()
	end)

	Label(left, '<font color="#ef4444">●</font>  TRIGGERBOT', 11, Enum.FontWeight.SemiBold, 0.4,
		UDim2.new(), UDim2.new(1, 0, 0, 18)).LayoutOrder = 11

	local triggerHeld = false

	local function ReleaseTrigger()
		if triggerHeld then
			if mouse1release then
				pcall(function() mouse1release() end)
			elseif keyrelease then
				pcall(function() keyrelease(0x01) end)
			end
			triggerHeld = false
		end
	end

	local function PressTrigger()
		if not triggerHeld then
			if mouse1press then
				pcall(function() mouse1press() end)
				triggerHeld = true
			elseif keypress then
				pcall(function() keypress(0x01) end)
				triggerHeld = true
			end
		end
	end

	local triggerbotRow = Row(12, "Triggerbot", "fully automatic: aims AND shoots when an enemy is in the FOV", 62, 44)
	Toggle(triggerbotRow, false, function(v)
		state.Triggerbot = v
		if not v then ReleaseTrigger() end
	end)

	local triggerKeyRow = Row(13, "Trigger Mode", "Auto works without any key. Key requires aim key", 62, 192)
	Segmented(triggerKeyRow, { "Auto", "Key" }, state.TriggerKey, function(v)
		state.TriggerKey = v
	end)

	Slider(14, "Trigger Delay", "min wait time between shots (in milliseconds)", 0, 500, state.TriggerDelay, "ms", function(v)
		state.TriggerDelay = v
	end)

	UpdatePreview()

	local fovGui = Instance.new("ScreenGui")
	fovGui.Name = "Mk7AimbotFOV"
	fovGui.ResetOnSpawn = false
	fovGui.ScreenInsets = Enum.ScreenInsets.None
	fovGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	fovGui.DisplayOrder = 2147483000
	local okParent = pcall(function()
		fovGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
	end)
	if not okParent then
		fovGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end

	local fovRing = Instance.new("Frame")
	fovRing.BackgroundTransparency = 1
	fovRing.AnchorPoint = Vector2.new(0.5, 0.5)
	fovRing.Visible = false
	fovRing.Parent = fovGui
	Corner(fovRing, UDim.new(1, 0))
	Stroke(fovRing, ACCENT, 0.15, 1.5)

	local function Matches(input)
		local k = state.Key
		if k.Mouse then
			return input.UserInputType == k.Mouse
		end
		return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == k.Keyboard
	end

	UserInputService.InputBegan:Connect(function(input, gpe)
		if listening then
			local newKey
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Escape then
					newKey = false
				else
					newKey = { Keyboard = input.KeyCode }
				end
			elseif input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.MouseButton2
				or input.UserInputType == Enum.UserInputType.MouseButton3 then
				newKey = { Mouse = input.UserInputType }
			end
			if newKey ~= nil then
				listening = false
				if newKey then
					state.Key = newKey
					held, toggled = false, false
				end
				keyBtn.Text = KeyName(state.Key)
			end
			return
		end

		if Matches(input) then
			if state.Key.Keyboard and gpe then return end
			if state.KeyMode == "Hold" then
				held = true
			elseif state.KeyMode == "Toggle" then
				toggled = not toggled
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if state.KeyMode == "Hold" and Matches(input) then
			held = false
		end
	end)

	local function IsActive()
		if not state.Enabled then return false end
		if state.KeyMode == "Always" then return true end
		if state.KeyMode == "Toggle" then return toggled end
		return held
	end

	local function IsEnemy(player)
		if not state.TeamCheck then
			return true
		end
		if LocalPlayer.Team and player.Team then
			return player.Team ~= LocalPlayer.Team
		end
		if LocalPlayer.TeamColor and player.TeamColor then
			return player.TeamColor ~= LocalPlayer.TeamColor
		end
		return true
	end

	local function GetClosest(mouse)
		local best, bestDist
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character then
				local hum = plr.Character:FindFirstChildOfClass("Humanoid")
				local part = plr.Character:FindFirstChild(TARGET_PART)
				if hum and hum.Health > 0 and part then
					if IsEnemy(plr) then
						local p, onScreen = Camera:WorldToViewportPoint(part.Position)
						if onScreen then
							local sp = Vector2.new(p.X, p.Y)
							local d = (sp - mouse).Magnitude
							if d <= state.FOV and (not bestDist or d < bestDist) then
								best = { player = plr, part = part, screen = sp }
								bestDist = d
							end
						end
					end
				end
			end
		end
		return best
	end

	-- ============================================================
	-- VÉRIFICATION DE VISIBILITÉ
	-- ============================================================
	local function IsVisible(part)
		if state.Wallbang then
			return true
		end

		if not part then return false end

		local char = LocalPlayer.Character
		local startPart = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
		local origin = startPart and startPart.Position or Camera.CFrame.Position

		local direction = (part.Position - origin)
		local distance = direction.Magnitude
		if distance < 1 then return true end
		direction = direction.Unit

		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		local excludeList = { Camera }
		if char then table.insert(excludeList, char) end
		raycastParams.FilterDescendantsInstances = excludeList
		raycastParams.IgnoreWater = true

		local result = workspace:Raycast(origin, direction * distance, raycastParams)

		if not result then return true end
		if result.Instance == part then return true end

		local hitChar = result.Instance:FindFirstAncestorOfClass("Model")
		local targetChar = part:FindFirstAncestorOfClass("Model")
		if hitChar and targetChar and hitChar == targetChar then
			return true
		end
		return false
	end

	local function GetValidTarget(mouse)
		local target = GetClosest(mouse)
		if not target then return nil end
		if not IsVisible(target.part) then return nil end
		return target
	end

	local function TryTriggerbot()
		if not state.Triggerbot then
			ReleaseTrigger()
			return
		end

		if state.TriggerKey == "Key" and not IsActive() then
			ReleaseTrigger()
			return
		end

		local now = tick() * 1000
		local mouse = UserInputService:GetMouseLocation()
		local target = GetValidTarget(mouse)

		if not target then
			ReleaseTrigger()
			lastTriggerTime = now
			return
		end

		if now - lastTriggerTime < state.TriggerDelay then
			return
		end

		if not triggerHeld then
			lastTriggerTime = now
			PressTrigger()
		end
	end

	local function KeyHint()
		if state.KeyMode == "Always" then return "always active" end
		local verb = state.KeyMode == "Hold" and "hold " or "press "
		return verb .. KeyName(state.Key)
	end

	local lastStatus = ""
	local function SetStatus(big, small)
		if big .. small == lastStatus then return end
		lastStatus = big .. small
		statusLabel.Text = big
		previewStatus.Text = small
	end

	RunService:BindToRenderStep("Mk7Aimbot", Enum.RenderPriority.Camera.Value + 1, function()
		if not Window.ScreenGui or not Window.ScreenGui.Parent then
			RunService:UnbindFromRenderStep("Mk7Aimbot")
			ReleaseTrigger()
			fovGui:Destroy()
			return
		end

		Camera = workspace.CurrentCamera
		if not Camera then return end

		local mouse = UserInputService:GetMouseLocation()
		fovRing.Visible = state.Enabled or state.Triggerbot or state.AutoAim
		fovRing.Size = UDim2.fromOffset(state.FOV * 2, state.FOV * 2)
		fovRing.Position = UDim2.fromOffset(mouse.X, mouse.Y)

		-- Auto Aim manuel OU Triggerbot (vise + tire tout seul)
		local autoAim = state.Triggerbot or state.AutoAim
		local shouldAim = IsActive() or autoAim

		if (state.Enabled or state.Triggerbot or state.AutoAim) and shouldAim then
			local target = GetValidTarget(mouse)

			if target then
				local delta = target.screen - mouse
				local dist = delta.Magnitude

				local mode = state.AimMode
				if mode == "Auto" then
					mode = (UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default) and "Camera" or "FreeAim"
				end
				if mode == "FreeAim" and not mousemoverel then
					mode = "Camera"
				end

				if mode == "FreeAim" then
					if dist > state.Speed then
						delta = delta.Unit * state.Speed
					end
					mousemoverel(delta.X, delta.Y)
				else
					local alpha = dist > 0 and math.min(1, state.Speed / dist) or 0
					local goal = CFrame.lookAt(Camera.CFrame.Position, target.part.Position)
					Camera.CFrame = Camera.CFrame:Lerp(goal, alpha)
				end

				SetStatus("Locked on " .. target.player.DisplayName, "locked: " .. target.player.Name)
			else
				if state.AutoAim and state.Enabled then
					SetStatus("Auto Aim active · no visible target", "no target")
				elseif state.Enabled then
					SetStatus("Aimbot is on · no target", "no target")
				elseif state.Triggerbot then
					SetStatus("Triggerbot active · searching...", "searching")
				end
			end
		elseif not state.Enabled and not state.Triggerbot and not state.AutoAim then
			SetStatus("Aimbot is off", "aimbot off")
		elseif not IsActive() and not autoAim then
			SetStatus("Aimbot is on · " .. KeyHint(), "aimbot on")
		end

		TryTriggerbot()
	end)
end

--// Onglet Visuals (Player ESP)
do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local LocalPlayer = Players.LocalPlayer
	local Camera = workspace.CurrentCamera

	local ACCENT = Color3.fromRGB(239, 68, 68)
	local FONT = "rbxasset://fonts/families/GothamSSm.json"

	local ENEMY_COLOR = Color3.fromRGB(239, 68, 68)
	local ALLY_COLOR = Color3.fromRGB(255, 255, 255)

	local espState = {
		Enabled = false,
		BoxStyle = "Box",
		HealthBar = false,
		Names = false,
		Distance = false,
		Skeleton = false,
		HeadDot = false,
		MobileRenderer = false,
		Size = 1.3,
		Color = Color3.fromRGB(255, 255, 255),
		RenderDistance = 250,
		TeamColor = true,
	}

	local function Corner(parent, radius)
		local c = Instance.new("UICorner")
		c.CornerRadius = radius or UDim.new(0, 12)
		c.Parent = parent
		return c
	end

	local function Stroke(parent, color, transparency, thickness)
		local s = Instance.new("UIStroke")
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		s.Color = color or Color3.new(1, 1, 1)
		s.Transparency = transparency or 0.9
		s.Thickness = thickness or 1
		s.Parent = parent
		return s
	end

	local function Card(parent, pos, size)
		local f = Instance.new("Frame")
		f.BackgroundColor3 = Color3.new(1, 1, 1)
		f.BackgroundTransparency = 0.94
		f.BorderSizePixel = 0
		f.Position = pos
		f.Size = size
		f.Parent = parent
		Corner(f)
		Stroke(f)
		return f
	end

	local function Label(parent, text, size, weight, transparency, pos, sz, align)
		local l = Instance.new("TextLabel")
		l.BackgroundTransparency = 1
		l.FontFace = Font.new(FONT, weight or Enum.FontWeight.Medium)
		l.Text = text
		l.RichText = true
		l.TextSize = size
		l.TextColor3 = Color3.new(1, 1, 1)
		l.TextTransparency = transparency or 0
		l.TextXAlignment = align or Enum.TextXAlignment.Left
		l.TextYAlignment = Enum.TextYAlignment.Top
		l.TextTruncate = Enum.TextTruncate.AtEnd
		l.Position = pos
		l.Size = sz
		l.Parent = parent
		return l
	end

	local container = tabs.Visuals:GetContent()

	local root = Instance.new("Frame")
	root.BackgroundTransparency = 1
	root.Size = UDim2.fromScale(1, 1)
	root.Parent = container

	local rootPad = Instance.new("UIPadding")
	rootPad.PaddingLeft = UDim.new(0, 12)
	rootPad.PaddingRight = UDim.new(0, 12)
	rootPad.PaddingTop = UDim.new(0, 6)
	rootPad.Parent = root

	local left = Instance.new("ScrollingFrame")
	left.BackgroundTransparency = 1
	left.BorderSizePixel = 0
	left.Size = UDim2.new(0.62, -6, 1, 0)
	left.AutomaticCanvasSize = Enum.AutomaticSize.Y
	left.CanvasSize = UDim2.new()
	left.ScrollBarThickness = 1
	left.ScrollBarImageTransparency = 0.5
	left.TopImage = ""
	left.BottomImage = ""
	left.Parent = root

	local leftLayout = Instance.new("UIListLayout")
	leftLayout.Padding = UDim.new(0, 8)
	leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
	leftLayout.Parent = left

	local leftPad = Instance.new("UIPadding")
	leftPad.PaddingRight = UDim.new(0, 4)
	leftPad.PaddingBottom = UDim.new(0, 8)
	leftPad.Parent = left

	local function Row(order, title, desc, height, controlWidth)
		local card = Card(left, UDim2.new(), UDim2.new(1, 0, 0, height))
		card.LayoutOrder = order
		Label(card, title, 12, Enum.FontWeight.SemiBold, 0.05,
			UDim2.fromOffset(14, 12), UDim2.new(1, -(controlWidth + 30), 0, 16))
		Label(card, desc, 10, Enum.FontWeight.Medium, 0.5,
			UDim2.fromOffset(14, 31), UDim2.new(1, -(controlWidth + 30), 0, 14))
		return card
	end

	local function Toggle(card, default, callback)
		local on = default
		local btn = Instance.new("TextButton")
		btn.AutoButtonColor = false
		btn.Text = ""
		btn.AnchorPoint = Vector2.new(1, 0.5)
		btn.Position = UDim2.new(1, -14, 0.5, 0)
		btn.Size = UDim2.fromOffset(44, 22)
		btn.BackgroundColor3 = Color3.fromRGB(70, 70, 82)
		btn.BorderSizePixel = 0
		btn.Parent = card
		Corner(btn, UDim.new(1, 0))

		local knob = Instance.new("Frame")
		knob.BackgroundColor3 = Color3.new(1, 1, 1)
		knob.BorderSizePixel = 0
		knob.Position = UDim2.fromOffset(3, 3)
		knob.Size = UDim2.fromOffset(16, 16)
		knob.Parent = btn
		Corner(knob, UDim.new(1, 0))

		local function Render()
			local info = TweenInfo.new(0.15, Enum.EasingStyle.Sine)
			TweenService:Create(btn, info, { BackgroundColor3 = on and ACCENT or Color3.fromRGB(70, 70, 82) }):Play()
			TweenService:Create(knob, info, { Position = on and UDim2.fromOffset(25, 3) or UDim2.fromOffset(3, 3) }):Play()
		end

		btn.MouseButton1Click:Connect(function()
			on = not on
			Render()
			callback(on)
		end)
		Render()
	end

	local function Segmented(card, options, default, callback)
		local W = 64
		local holder = Instance.new("Frame")
		holder.BackgroundTransparency = 1
		holder.AnchorPoint = Vector2.new(1, 0.5)
		holder.Position = UDim2.new(1, -12, 0.5, 0)
		holder.Size = UDim2.fromOffset(#options * W, 32)
		holder.Parent = card

		local buttons = {}
		local function Select(name)
			for n, b in pairs(buttons) do
				local sel = (n == name)
				TweenService:Create(b, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
					BackgroundTransparency = sel and 0 or 1,
					TextTransparency = sel and 0 or 0.4,
				}):Play()
			end
		end

		for i, name in ipairs(options) do
			local b = Instance.new("TextButton")
			b.AutoButtonColor = false
			b.BackgroundColor3 = ACCENT
			b.BackgroundTransparency = 1
			b.BorderSizePixel = 0
			b.Position = UDim2.fromOffset((i - 1) * W, 0)
			b.Size = UDim2.fromOffset(W - 4, 32)
			b.FontFace = Font.new(FONT, Enum.FontWeight.SemiBold)
			b.Text = name
			b.TextSize = 11
			b.TextColor3 = Color3.new(1, 1, 1)
			b.Parent = holder
			Corner(b, UDim.new(0, 8))
			buttons[name] = b

			b.MouseButton1Click:Connect(function()
				Select(name)
				callback(name)
			end)
		end
		Select(default)
	end

	local function Slider(order, title, desc, min, max, default, suffix, callback)
		local card = Card(left, UDim2.new(), UDim2.new(1, 0, 0, 78))
		card.LayoutOrder = order

		Label(card, title, 12, Enum.FontWeight.SemiBold, 0.05,
			UDim2.fromOffset(14, 12), UDim2.new(1, -100, 0, 16))
		local valueLabel = Label(card, "", 12, Enum.FontWeight.SemiBold, 0,
			UDim2.new(1, -94, 0, 12), UDim2.fromOffset(80, 16), Enum.TextXAlignment.Right)
		valueLabel.TextColor3 = ACCENT
		Label(card, desc, 10, Enum.FontWeight.Medium, 0.5,
			UDim2.fromOffset(14, 31), UDim2.new(1, -28, 0, 14))

		local track = Instance.new("Frame")
		track.BackgroundColor3 = Color3.new(1, 1, 1)
		track.BackgroundTransparency = 0.88
		track.BorderSizePixel = 0
		track.Position = UDim2.new(0, 14, 0, 58)
		track.Size = UDim2.new(1, -28, 0, 4)
		track.Parent = card
		Corner(track, UDim.new(1, 0))

		local fill = Instance.new("Frame")
		fill.BackgroundColor3 = ACCENT
		fill.BorderSizePixel = 0
		fill.Size = UDim2.fromScale(0, 1)
		fill.Parent = track
		Corner(fill, UDim.new(1, 0))

		local knob = Instance.new("Frame")
		knob.BackgroundColor3 = ACCENT
		knob.BorderSizePixel = 0
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Position = UDim2.fromScale(0, 0.5)
		knob.Size = UDim2.fromOffset(16, 16)
		knob.Parent = track
		Corner(knob, UDim.new(1, 0))
		Stroke(knob, Color3.new(1, 1, 1), 0.6, 2)

		local function Apply(v)
			v = math.clamp(v, min, max)
			local a = (v - min) / (max - min)
			fill.Size = UDim2.fromScale(a, 1)
			knob.Position = UDim2.fromScale(a, 0.5)
			valueLabel.Text = tostring(v) .. (suffix ~= "" and (" " .. suffix) or "")
			callback(v)
		end

		local dragging = false
		local function FromX(x)
			local a = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
			local step = (max - min)
			local raw = min + step * a
			if step <= 10 then
				Apply(math.floor(raw * 10 + 0.5) / 10)
			else
				Apply(math.floor(raw + 0.5))
			end
		end

		local hit = Instance.new("TextButton")
		hit.Text = ""
		hit.BackgroundTransparency = 1
		hit.Position = UDim2.new(0, 14, 0, 46)
		hit.Size = UDim2.new(1, -28, 0, 28)
		hit.Parent = card

		hit.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				FromX(input.Position.X)
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				FromX(input.Position.X)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		Apply(default)
	end

	Label(left, '<font color="#ef4444">●</font>  PLAYER ESP', 11, Enum.FontWeight.SemiBold, 0.4,
		UDim2.new(), UDim2.new(1, 0, 0, 18)).LayoutOrder = 0

	local masterRow = Row(1, "Enabled", "master switch", 62, 44)
	Toggle(masterRow, false, function(v) espState.Enabled = v end)

	local styleRow = Row(2, "Box Style", "style of the box around players", 62, 210)
	Segmented(styleRow, { "Box", "Corners", "None" }, "Box", function(v) espState.BoxStyle = v end)

	local healthRow = Row(3, "Health Bar", "show a health bar on the side", 62, 44)
	Toggle(healthRow, false, function(v) espState.HealthBar = v end)

	local namesRow = Row(4, "Names", "show the player's name", 62, 44)
	Toggle(namesRow, false, function(v) espState.Names = v end)

	local distanceRow = Row(5, "Distance", "show distance from you", 62, 44)
	Toggle(distanceRow, false, function(v) espState.Distance = v end)

	local headDotRow = Row(6, "Head Dot", "draw a dot on the player's head", 62, 44)
	Toggle(headDotRow, false, function(v) espState.HeadDot = v end)

	local teamColorRow = Row(7, "Team Color", "red for enemies, white for allies", 62, 44)
	Toggle(teamColorRow, true, function(v)
		espState.TeamColor = v
	end)

	local mobileRow = Row(8, "Mobile Renderer", "experimental mobile rendering", 62, 44)
	Toggle(mobileRow, false, function(v) espState.MobileRenderer = v end)

	Label(left, '<font color="#ef4444">●</font>  APPEARANCE', 11, Enum.FontWeight.SemiBold, 0.4,
		UDim2.new(), UDim2.new(1, 0, 0, 18)).LayoutOrder = 9

	Slider(10, "ESP Size", "size multiplier for all ESP elements", 0.5, 3.0, 1.3, "x", function(v)
		espState.Size = v
	end)

	Label(left, '<font color="#ef4444">●</font>  PERFORMANCE', 11, Enum.FontWeight.SemiBold, 0.4,
		UDim2.new(), UDim2.new(1, 0, 0, 18)).LayoutOrder = 11

	Slider(12, "Render Distance", "max distance to render ESP (in studs)", 50, 1000, 250, "studs", function(v)
		espState.RenderDistance = v
	end)

	local espGui = Instance.new("ScreenGui")
	espGui.Name = "Mk7_ESP_Gui"
	espGui.ResetOnSpawn = false
	espGui.IgnoreGuiInset = true
	espGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	espGui.DisplayOrder = 1

	local okParent = pcall(function()
		espGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
	end)
	if not okParent then
		espGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end

	local espCache = {}

	local function CreateESP(player)
		if espCache[player] then return end

		local drawings = {}

		local box = Instance.new("Frame")
		box.BackgroundTransparency = 1
		box.BorderSizePixel = 0
		box.Visible = false
		box.Parent = espGui

		local boxStroke = Instance.new("UIStroke")
		boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		boxStroke.Color = Color3.new(1, 1, 1)
		boxStroke.Transparency = 0.1
		boxStroke.Thickness = 2
		boxStroke.Parent = box
		drawings.Box = box
		drawings.BoxStroke = boxStroke

		local nameTag = Instance.new("TextLabel")
		nameTag.BackgroundTransparency = 1
		nameTag.FontFace = Font.new(FONT, Enum.FontWeight.Bold)
		nameTag.TextSize = 14
		nameTag.TextColor3 = Color3.new(1, 1, 1)
		nameTag.TextStrokeTransparency = 0.1
		nameTag.TextStrokeColor3 = Color3.new(0, 0, 0)
		nameTag.Visible = false
		nameTag.Parent = espGui
		drawings.Name = nameTag

		local distTag = Instance.new("TextLabel")
		distTag.BackgroundTransparency = 1
		distTag.FontFace = Font.new(FONT, Enum.FontWeight.SemiBold)
		distTag.TextSize = 12
		distTag.TextColor3 = Color3.fromRGB(255, 255, 255)
		distTag.TextStrokeTransparency = 0.1
		distTag.TextStrokeColor3 = Color3.new(0, 0, 0)
		distTag.Visible = false
		distTag.Parent = espGui
		drawings.Distance = distTag

		local healthBg = Instance.new("Frame")
		healthBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		healthBg.BorderSizePixel = 0
		healthBg.Visible = false
		healthBg.Parent = espGui
		Corner(healthBg, UDim.new(1, 0))
		drawings.HealthBg = healthBg

		local healthFill = Instance.new("Frame")
		healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
		healthFill.BorderSizePixel = 0
		healthFill.Size = UDim2.fromScale(1, 1)
		healthFill.Parent = healthBg
		Corner(healthFill, UDim.new(1, 0))
		drawings.HealthFill = healthFill

		local headDot = Instance.new("Frame")
		headDot.BackgroundColor3 = Color3.new(1, 1, 1)
		headDot.BorderSizePixel = 0
		headDot.Size = UDim2.fromOffset(6, 6)
		headDot.Visible = false
		headDot.Parent = espGui
		Corner(headDot, UDim.new(1, 0))
		local dotStroke = Instance.new("UIStroke")
		dotStroke.Color = Color3.new(0, 0, 0)
		dotStroke.Transparency = 0.3
		dotStroke.Thickness = 1
		dotStroke.Parent = headDot
		drawings.HeadDot = headDot

		espCache[player] = drawings
	end

	local function RemoveESP(player)
		if espCache[player] then
			for _, obj in pairs(espCache[player]) do
				if typeof(obj) == "Instance" then
					obj:Destroy()
				end
			end
			espCache[player] = nil
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then CreateESP(player) end
	end
	Players.PlayerAdded:Connect(CreateESP)
	Players.PlayerRemoving:Connect(RemoveESP)

	local function HideAll(drawings)
		if drawings.Box then drawings.Box.Visible = false end
		if drawings.Name then drawings.Name.Visible = false end
		if drawings.Distance then drawings.Distance.Visible = false end
		if drawings.HealthBg then drawings.HealthBg.Visible = false end
		if drawings.HeadDot then drawings.HeadDot.Visible = false end
	end

	local function GetPlayerColor(player)
		if not espState.TeamColor then
			return espState.Color
		end
		local myTeam = LocalPlayer.Team
		local myTeamColor = LocalPlayer.TeamColor
		local theirTeam = player.Team
		local theirTeamColor = player.TeamColor

		if myTeam and theirTeam then
			if theirTeam == myTeam then
				return ALLY_COLOR
			else
				return ENEMY_COLOR
			end
		end
		if myTeamColor and theirTeamColor then
			if theirTeamColor == myTeamColor then
				return ALLY_COLOR
			else
				return ENEMY_COLOR
			end
		end
		return ENEMY_COLOR
	end

	RunService.RenderStepped:Connect(function()
		if not Window.ScreenGui or not Window.ScreenGui.Parent then
			for _, drawings in pairs(espCache) do HideAll(drawings) end
			return
		end

		if not espState.Enabled then
			for _, drawings in pairs(espCache) do HideAll(drawings) end
			return
		end

		Camera = workspace.CurrentCamera
		if not Camera then return end

		for player, drawings in pairs(espCache) do
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local head = char and char:FindFirstChild("Head")
			local hum = char and char:FindFirstChildOfClass("Humanoid")

			if hrp and head and hum and hum.Health > 0 then
				local distance = (Camera.CFrame.Position - hrp.Position).Magnitude

				if distance > espState.RenderDistance then
					HideAll(drawings)
				else
					local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

					if onScreen then
						local headScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
						local feetPos = hrp.Position - Vector3.new(0, 3, 0)
						local feetScreen = Camera:WorldToViewportPoint(feetPos)

						local topY = math.min(headScreen.Y, screenPos.Y)
						local bottomY = math.max(feetScreen.Y, screenPos.Y)
						local realHeight = math.abs(bottomY - topY)

						local leftPos = hrp.Position - Camera.CFrame.RightVector * 1.2
						local rightPos = hrp.Position + Camera.CFrame.RightVector * 1.2
						local leftScreen = Camera:WorldToViewportPoint(leftPos)
						local rightScreen = Camera:WorldToViewportPoint(rightPos)
						local realWidth = math.abs(rightScreen.X - leftScreen.X)

						local sizeMult = espState.Size
						local width = math.max(8, math.floor(realWidth * sizeMult))
						local height = math.max(12, math.floor(realHeight * sizeMult))

						local centerX = screenPos.X
						local centerY = (topY + bottomY) / 2

						local x = math.floor(centerX - width / 2)
						local y = math.floor(centerY - height / 2)

						local color = GetPlayerColor(player)

						if espState.BoxStyle == "Box" then
							drawings.Box.Visible = true
							drawings.Box.Position = UDim2.fromOffset(x, y)
							drawings.Box.Size = UDim2.fromOffset(width, height)
							drawings.BoxStroke.Color = color
							drawings.BoxStroke.Transparency = 0.1
							drawings.BoxStroke.Thickness = 2
						elseif espState.BoxStyle == "Corners" then
							drawings.Box.Visible = true
							drawings.Box.Position = UDim2.fromOffset(x, y)
							drawings.Box.Size = UDim2.fromOffset(width, height)
							drawings.BoxStroke.Color = color
							drawings.BoxStroke.Transparency = 0.4
							drawings.BoxStroke.Thickness = 3
						else
							drawings.Box.Visible = false
						end

						if espState.HealthBar then
							drawings.HealthBg.Visible = true
							drawings.HealthBg.Position = UDim2.fromOffset(x - 9, y)
							drawings.HealthBg.Size = UDim2.fromOffset(5, height)
							Corner(drawings.HealthBg, UDim.new(1, 0))

							local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
							drawings.HealthFill.Size = UDim2.fromScale(1, hpPct)
							drawings.HealthFill.Position = UDim2.fromScale(0, 1 - hpPct)
							drawings.HealthFill.BackgroundColor3 = Color3.fromRGB(
								math.floor(255 * (1 - hpPct)),
								math.floor(255 * hpPct),
								0
							)
							Corner(drawings.HealthFill, UDim.new(1, 0))
						else
							drawings.HealthBg.Visible = false
						end

						if espState.Names then
							drawings.Name.Visible = true
							drawings.Name.Text = player.Name
							drawings.Name.TextColor3 = color
							drawings.Name.Position = UDim2.fromOffset(x + width/2 - 100, y - 20)
							drawings.Name.Size = UDim2.fromOffset(200, 18)
							drawings.Name.TextXAlignment = Enum.TextXAlignment.Center
						else
							drawings.Name.Visible = false
						end

						if espState.Distance then
							drawings.Distance.Visible = true
							drawings.Distance.Text = "[" .. math.floor(distance) .. " studs]"
							drawings.Distance.TextColor3 = color
							drawings.Distance.Position = UDim2.fromOffset(x + width/2 - 100, y + height + 2)
							drawings.Distance.Size = UDim2.fromOffset(200, 16)
							drawings.Distance.TextXAlignment = Enum.TextXAlignment.Center
						else
							drawings.Distance.Visible = false
						end

						if espState.HeadDot then
							local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
							if headOnScreen then
								drawings.HeadDot.Visible = true
								drawings.HeadDot.BackgroundColor3 = color
								drawings.HeadDot.Position = UDim2.fromOffset(headPos.X - 3, headPos.Y - 3)
							else
								drawings.HeadDot.Visible = false
							end
						else
							drawings.HeadDot.Visible = false
						end

					else
						HideAll(drawings)
					end
				end
			else
				HideAll(drawings)
			end
		end
	end)
end

--// Lancement
tabs.Home:Select()

PlayIntro(function()
	Window:Reveal()
end)
