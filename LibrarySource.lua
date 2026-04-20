-- =========================================================
-- CUSTOM UI LIBRARY SOURCE (FIXED BLANK & MOBILE TOUCH)
-- =========================================================

local Library = {}

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

function Library:CreateWindow(titleText)
    local Window = {}
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomAuthUI"
    ScreenGui.ResetOnSpawn = false
    
    local success, err = pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not success then
        ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    MainFrame.Size = UDim2.new(0, 300, 200) -- Ukuran Frame Utama
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = MainFrame
    TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleLabel.Size = UDim2.new(1, 0, 0, 35)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = " " .. titleText
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Active = true
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleLabel

    local TitleBlock = Instance.new("Frame")
    TitleBlock.Parent = TitleLabel
    TitleBlock.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBlock.BorderSizePixel = 0
    TitleBlock.Position = UDim2.new(0, 0, 1, -5)
    TitleBlock.Size = UDim2.new(1, 0, 0, 5)

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 10, 0, 45)
    Container.Size = UDim2.new(1, -20, 1, -55)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)

    -- Logika Drag UI
    local dragging, dragInput, dragStart, startPos
    TitleLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TitleLabel.InputChanged:Connect(function(input)
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

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    function Window:CreateTextbox(placeholder, callback)
        local TextBoxFrame = Instance.new("Frame")
        TextBoxFrame.Name = "TextBoxFrame"
        TextBoxFrame.Parent = Container
        TextBoxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TextBoxFrame.Size = UDim2.new(1, 0, 0, 35)

        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 6)
        BoxCorner.Parent = TextBoxFrame

        local TextBox = Instance.new("TextBox")
        TextBox.Name = "InputBox"
        TextBox.Parent = TextBoxFrame
        TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.BackgroundTransparency = 1
        TextBox.Size = UDim2.new(1, -10, 1, 0)
        TextBox.Position = UDim2.new(0, 5, 0, 0)
        TextBox.Font = Enum.Font.Gotham
        TextBox.PlaceholderText = placeholder
        TextBox.Text = ""
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.TextSize = 13
        TextBox.ClearTextOnFocus = false
        
        TextBox:GetPropertyChangedSignal("Text"):Connect(function()
            callback(TextBox.Text)
        end)
    end

    function Window:CreateButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = "ActionButton"
        Button.Parent = Container
        Button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.Font = Enum.Font.GothamBold
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.AutoButtonColor = true -- Bawaan roblox agar tombol merespon klik/touch
        Button.Active = true
        Button.Selectable = true

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Button

        -- Menggunakan event .Activated untuk dukungan penuh di HP dan PC
        Button.Activated:Connect(function()
            callback()
        end)
    end

    -- KESALAHAN SEBELUMNYA ADA DI SINI (Sekarang sudah diperbaiki menjadi return Window)
    return Window
end

return Library
