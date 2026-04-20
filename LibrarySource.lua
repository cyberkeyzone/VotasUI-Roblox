-- =====================================================================
-- VOTAS UI LIBRARY v2 - PREMIUM & ELEGANT (MOBILE & PC SUPPORT)
-- =====================================================================

local VotasUI = {}

-- Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Tema Warna (Customizable)
local Theme = {
    MainBackground = Color3.fromRGB(20, 20, 20),
    SidebarBackground = Color3.fromRGB(25, 25, 25),
    SectionBackground = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(85, 110, 255), -- Biru Elegan
    TextLight = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 150),
    Hover = Color3.fromRGB(40, 40, 40)
}

-- Fungsi untuk membuat Animasi dengan mudah
local function Tween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function VotasUI:CreateWindow(titleText)
    local Window = {}
    local CurrentTab = nil

    -- 1. Setup ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VotasUI_Premium"
    ScreenGui.ResetOnSpawn = false
    
    local success, err = pcall(function() ScreenGui.Parent = CoreGui end)
    if not success then ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. Main Frame (Window Utama)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.MainBackground
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Active = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    -- Efek Bayangan (Drop Shadow)
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "Shadow"
    DropShadow.Parent = MainFrame
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0, -15, 0, -15)
    DropShadow.Size = UDim2.new(1, 30, 1, 30)
    DropShadow.ZIndex = 0
    DropShadow.Image = "rbxassetid://4743306712"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)

    -- 3. Sidebar (Panel Kiri untuk Tab)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.SidebarBackground
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 2

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    -- Menutupi sudut kanan Sidebar agar menyatu dengan konten
    local SidebarCover = Instance.new("Frame")
    SidebarCover.Parent = Sidebar
    SidebarCover.BackgroundColor3 = Theme.SidebarBackground
    SidebarCover.Position = UDim2.new(1, -5, 0, 0)
    SidebarCover.Size = UDim2.new(0, 5, 1, 0)
    SidebarCover.BorderSizePixel = 0
    SidebarCover.ZIndex = 2

    -- Judul UI di Sidebar
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = Sidebar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 0, 0, 15)
    TitleLabel.Size = UDim2.new(1, 0, 0, 25)
    TitleLabel.Font = Enum.Font.GothamBlack
    TitleLabel.Text = titleText
    TitleLabel.TextColor3 = Theme.Accent
    TitleLabel.TextSize = 16
    TitleLabel.ZIndex = 3

    -- Container untuk Tombol Tab
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.Parent = Sidebar
    TabList.BackgroundTransparency = 1
    TabList.Position = UDim2.new(0, 0, 0, 60)
    TabList.Size = UDim2.new(1, 0, 1, -70)
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.ScrollBarThickness = 0
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.ZIndex = 3

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabList
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)

    -- 4. Container Konten Utama (Kanan)
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 150, 0, 15)
    ContentContainer.Size = UDim2.new(1, -160, 1, -30)
    ContentContainer.ZIndex = 2

    -- 5. Dragging Logic (Bisa digeser lewat area atas MainFrame)
    local dragging, dragInput, dragStart, startPos
    local DragArea = Instance.new("Frame")
    DragArea.Parent = MainFrame
    DragArea.BackgroundTransparency = 1
    DragArea.Size = UDim2.new(1, 0, 0, 40)
    DragArea.ZIndex = 10
    
    DragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    DragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Fungsi Tutup UI
    function Window:Destroy()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end

    -- ==========================================
    -- FUNGSI MEMBUAT TAB BARU
    -- ==========================================
    function Window:CreateTab(tabName)
        local Tab = {}
        
        -- Tombol Tab di Sidebar
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName.."_Btn"
        TabButton.Parent = TabList
        TabButton.BackgroundColor3 = Theme.MainBackground
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(0.85, 0, 0, 32)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = tabName
        TabButton.TextColor3 = Theme.TextDark
        TabButton.TextSize = 13
        TabButton.AutoButtonColor = false
        TabButton.ZIndex = 4

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabButton

        -- Halaman Konten untuk Tab ini
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName.."_Page"
        TabPage.Parent = ContentContainer
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.Visible = false
        TabPage.ZIndex = 2

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = TabPage
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 10)

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = TabPage
        PagePadding.PaddingRight = UDim.new(0, 5)
        PagePadding.PaddingTop = UDim.new(0, 5)

        -- Logika klik Tab
        TabButton.Activated:Connect(function()
            if CurrentTab then
                CurrentTab.Btn.BackgroundTransparency = 1
                CurrentTab.Btn.TextColor3 = Theme.TextDark
                CurrentTab.Page.Visible = false
            end
            CurrentTab = {Btn = TabButton, Page = TabPage}
            
            Tween(TabButton, {BackgroundTransparency = 0}, 0.2)
            TabButton.TextColor3 = Theme.TextLight
            TabPage.Visible = true
        end)

        -- Set tab pertama sebagai tab aktif default
        if CurrentTab == nil then
            CurrentTab = {Btn = TabButton, Page = TabPage}
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Theme.TextLight
            TabPage.Visible = true
        end

        -- ==========================================
        -- FUNGSI ELEMEN DI DALAM TAB (TEXTBOX, BUTTON, DLL)
        -- ==========================================
        
        -- 1. Teks Label / Info
        function Tab:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Parent = TabPage
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Theme.TextLight
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
        end

        -- 2. Textbox (Input)
        function Tab:CreateTextbox(title, placeholder, callback)
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Parent = TabPage
            BoxFrame.BackgroundColor3 = Theme.SectionBackground
            BoxFrame.Size = UDim2.new(1, 0, 0, 45)

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 6)
            BoxCorner.Parent = BoxFrame

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Parent = BoxFrame
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0, 10, 0, 5)
            TitleLabel.Size = UDim2.new(1, -20, 0, 15)
            TitleLabel.Font = Enum.Font.GothamSemibold
            TitleLabel.Text = title
            TitleLabel.TextColor3 = Theme.TextLight
            TitleLabel.TextSize = 12
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local TextBoxBg = Instance.new("Frame")
            TextBoxBg.Parent = BoxFrame
            TextBoxBg.BackgroundColor3 = Theme.MainBackground
            TextBoxBg.Position = UDim2.new(0, 10, 0, 22)
            TextBoxBg.Size = UDim2.new(1, -20, 0, 20)
            
            local TBCorner = Instance.new("UICorner")
            TBCorner.CornerRadius = UDim.new(0, 4)
            TBCorner.Parent = TextBoxBg

            local TextBox = Instance.new("TextBox")
            TextBox.Parent = TextBoxBg
            TextBox.BackgroundTransparency = 1
            TextBox.Size = UDim2.new(1, -10, 1, 0)
            TextBox.Position = UDim2.new(0, 5, 0, 0)
            TextBox.Font = Enum.Font.Gotham
            TextBox.PlaceholderText = placeholder
            TextBox.Text = ""
            TextBox.TextColor3 = Theme.TextLight
            TextBox.PlaceholderColor3 = Theme.TextDark
            TextBox.TextSize = 12
            TextBox.ClearTextOnFocus = false
            TextBox.TextXAlignment = Enum.TextXAlignment.Left

            TextBox.FocusLost:Connect(function()
                callback(TextBox.Text)
            end)
        end

        -- 3. Button
        function Tab:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = TabPage
            Button.BackgroundColor3 = Theme.Accent
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.Font = Enum.Font.GothamBold
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 13
            Button.AutoButtonColor = false

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = Button

            Button.MouseEnter:Connect(function() Tween(Button, {BackgroundColor3 = Color3.fromRGB(105, 130, 255)}, 0.2) end)
            Button.MouseLeave:Connect(function() Tween(Button, {BackgroundColor3 = Theme.Accent}, 0.2) end)

            Button.Activated:Connect(function()
                Tween(Button, {Size = UDim2.new(0.98, 0, 0, 33)}, 0.1)
                task.wait(0.1)
                Tween(Button, {Size = UDim2.new(1, 0, 0, 35)}, 0.1)
                callback()
            end)
        end

        -- 4. Toggle Switch
        function Tab:CreateToggle(text, default, callback)
            local toggled = default or false
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = TabPage
            ToggleFrame.BackgroundColor3 = Theme.SectionBackground
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)

            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 6)
            FrameCorner.Parent = ToggleFrame

            local Title = Instance.new("TextLabel")
            Title.Parent = ToggleFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(0.7, 0, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = Theme.TextLight
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local SwitchBtn = Instance.new("TextButton")
            SwitchBtn.Parent = ToggleFrame
            SwitchBtn.BackgroundColor3 = toggled and Theme.Accent or Theme.MainBackground
            SwitchBtn.Position = UDim2.new(1, -45, 0.5, -10)
            SwitchBtn.Size = UDim2.new(0, 35, 0, 20)
            SwitchBtn.Text = ""
            SwitchBtn.AutoButtonColor = false

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = SwitchBtn

            local Circle = Instance.new("Frame")
            Circle.Parent = SwitchBtn
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.Size = UDim2.new(0, 16, 0, 16)

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = Circle

            SwitchBtn.Activated:Connect(function()
                toggled = not toggled
                callback(toggled)
                if toggled then
                    Tween(SwitchBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
                    Tween(Circle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
                else
                    Tween(SwitchBtn, {BackgroundColor3 = Theme.MainBackground}, 0.2)
                    Tween(Circle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                end
            end)
        end

        return Tab
    end

    return Window
end

return VotasUI
