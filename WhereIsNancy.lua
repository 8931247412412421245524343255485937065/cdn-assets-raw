local ExecutorName = identifyexecutor() or "Unknown"

local LocalPlayer = game:GetService("Players").LocalPlayer
local HttpService = cloneref(game:GetService("HttpService"))

local Method1 = game:GetService("RbxAnalyticsService"):GetClientId()
local Service = game:GetService("RbxAnalyticsService")
local Method2 = Service.GetClientId(Service)
local HWID = Method2

local safeRequest = clonefunction(syn and syn.request or http_request or request)

local AuthAPI = "https://gist.githubusercontent.com/8931247412412421245524343255485937065/313c8ba8bc6abeeed8e8f6a444065d5f/raw/d7b76b5ca8b512f4dd05423aa16abc67c561c770/HappyHawkTuah.json"
local BlacklistURL = "https://gist.githubusercontent.com/8931247412412421245524343255485937065/bd881f722b597ba470a6b6067571f7a3/raw/85832531f29484681c316db7eeea3038bcf50236/LockEmUp.json"
local WhitelistURL = "https://gist.githubusercontent.com/8931247412412421245524343255485937065/81d3d7e7af49081dcbde2c9eaea2f137/raw/ae43946ce0eedb33325d3e31754ede7f80d45579/Whitelist.json"

local Config = {
    EnableWhitelist = false,
    EnableHWID = false,
    EnableExpire = true,
    EnableErrorWebhook = true
}

local SavedQuestionnaireFile = ".questionnaire_completed"
local questionnaireAnswers = {}

if not isfile(SavedQuestionnaireFile) then
    local ScreenGui = Instance.new("ScreenGui")
    local Blur = Instance.new("BlurEffect")
    local Main = Instance.new("Frame")
    local Corner = Instance.new("UICorner")
    local OuterGlow = Instance.new("Frame")
    local GlowCorner = Instance.new("UICorner")
    local Content = Instance.new("Frame")
    local Brand = Instance.new("TextLabel")
    local Divider = Instance.new("Frame")
    local StatusDot = Instance.new("Frame")
    local DotCorner = Instance.new("UICorner")
    local StatusText = Instance.new("TextLabel")
    local QuestionText = Instance.new("TextLabel")
    local YesBtn = Instance.new("TextButton")
    local NoBtn = Instance.new("TextButton")
    local ExecutorChip = Instance.new("Frame")
    local ChipCorner = Instance.new("UICorner")
    local ChipText = Instance.new("TextLabel")
    local Border = Instance.new("UIStroke")

    ScreenGui.Parent = gethui()
    ScreenGui.ResetOnSpawn = false

    Blur.Parent = game.Lighting
    Blur.Size = 10

    OuterGlow.Parent = ScreenGui
    OuterGlow.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    OuterGlow.Position = UDim2.new(0.5, -153, 0.5, -93)
    OuterGlow.Size = UDim2.new(0, 306, 0, 186)
    OuterGlow.BorderSizePixel = 0
    OuterGlow.BackgroundTransparency = 0.4

    GlowCorner.CornerRadius = UDim.new(0, 14)
    GlowCorner.Parent = OuterGlow

    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    Main.Position = UDim2.new(0.5, -150, 0.5, -90)
    Main.Size = UDim2.new(0, 300, 0, 180)
    Main.BorderSizePixel = 0

    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Main

    Border.Parent = Main
    Border.Color = Color3.fromRGB(28, 28, 35)
    Border.Thickness = 0.8

    Content.Parent = Main
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 28, 0, 24)
    Content.Size = UDim2.new(1, -56, 1, -48)

    Brand.Parent = Content
    Brand.BackgroundTransparency = 1
    Brand.Size = UDim2.new(1, 0, 0, 24)
    Brand.Font = Enum.Font.Code
    Brand.Text = "QUESTIONNAIRE"
    Brand.TextColor3 = Color3.fromRGB(245, 245, 250)
    Brand.TextSize = 17
    Brand.TextXAlignment = Enum.TextXAlignment.Left

    Divider.Parent = Content
    Divider.BackgroundColor3 = Color3.fromRGB(65, 135, 255)
    Divider.Position = UDim2.new(0, 0, 0, 32)
    Divider.Size = UDim2.new(0, 38, 0, 1)
    Divider.BorderSizePixel = 0

    StatusDot.Parent = Content
    StatusDot.BackgroundColor3 = Color3.fromRGB(255, 185, 65)
    StatusDot.Position = UDim2.new(0, 0, 0, 52)
    StatusDot.Size = UDim2.new(0, 7, 0, 7)
    StatusDot.BorderSizePixel = 0

    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = StatusDot

    StatusText.Parent = Content
    StatusText.BackgroundTransparency = 1
    StatusText.Position = UDim2.new(0, 16, 0, 49)
    StatusText.Size = UDim2.new(1, -16, 0, 13)
    StatusText.Font = Enum.Font.Code
    StatusText.Text = "Question 1 of 3"
    StatusText.TextColor3 = Color3.fromRGB(175, 175, 180)
    StatusText.TextSize = 11
    StatusText.TextXAlignment = Enum.TextXAlignment.Left

    QuestionText.Parent = Content
    QuestionText.BackgroundTransparency = 1
    QuestionText.Position = UDim2.new(0, 0, 0, 76)
    QuestionText.Size = UDim2.new(1, 0, 0, 32)
    QuestionText.Font = Enum.Font.Code
    QuestionText.Text = "Have you been banned within the past month on your main or alt account?"
    QuestionText.TextColor3 = Color3.fromRGB(215, 215, 220)
    QuestionText.TextSize = 10
    QuestionText.TextWrapped = true
    QuestionText.TextXAlignment = Enum.TextXAlignment.Left
    QuestionText.TextYAlignment = Enum.TextYAlignment.Top

    ExecutorChip.Parent = Content
    ExecutorChip.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    ExecutorChip.Position = UDim2.new(1, -85, 1, -38)
    ExecutorChip.Size = UDim2.new(0, 85, 0, 16)
    ExecutorChip.BorderSizePixel = 0

    ChipCorner.CornerRadius = UDim.new(0, 8)
    ChipCorner.Parent = ExecutorChip

    ChipText.Parent = ExecutorChip
    ChipText.BackgroundTransparency = 1
    ChipText.Size = UDim2.new(1, 0, 1, 0)
    ChipText.Font = Enum.Font.Code
    ChipText.Text = (identifyexecutor() or "UNKNOWN"):upper()
    ChipText.TextColor3 = Color3.fromRGB(115, 115, 125)
    ChipText.TextSize = 8

    YesBtn.Parent = Content
    YesBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 75)
    YesBtn.Position = UDim2.new(0, 0, 1, -18)
    YesBtn.Size = UDim2.new(0.48, 0, 0, 18)
    YesBtn.Font = Enum.Font.Code
    YesBtn.Text = "YES"
    YesBtn.TextColor3 = Color3.fromRGB(245, 245, 250)
    YesBtn.TextSize = 9
    YesBtn.BorderSizePixel = 0

    local YesCorner = Instance.new("UICorner")
    YesCorner.CornerRadius = UDim.new(0, 4)
    YesCorner.Parent = YesBtn

    NoBtn.Parent = Content
    NoBtn.BackgroundColor3 = Color3.fromRGB(85, 205, 125)
    NoBtn.Position = UDim2.new(0.52, 0, 1, -18)
    NoBtn.Size = UDim2.new(0.48, 0, 0, 18)
    NoBtn.Font = Enum.Font.Code
    NoBtn.Text = "NO"
    NoBtn.TextColor3 = Color3.fromRGB(245, 245, 250)
    NoBtn.TextSize = 9
    NoBtn.BorderSizePixel = 0

    local NoCorner = Instance.new("UICorner")
    NoCorner.CornerRadius = UDim.new(0, 4)
    NoCorner.Parent = NoBtn

    local TweenService = game:GetService("TweenService")
    local currentQuestion = 1

    local questions = {
        "Have you been banned within the past month on your main or alt account?",
        "Do you crash when using Easier Moving Shots?",
        "Is Auto Steal bannable?"
    }

    local function closeUI()
        local fadeOut = TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
        TweenService:Create(OuterGlow, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Border, TweenInfo.new(0.4), {Transparency = 1}):Play()
        TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
        
        for _, obj in pairs(Content:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                TweenService:Create(obj, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
            elseif obj:IsA("Frame") then
                TweenService:Create(obj, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
            end
        end
        
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            Blur:Destroy()
            ScreenGui:Destroy()
        end)
    end

    local function sendQuestionnaireWebhook()
        local fields = {}
        for i, question in ipairs(questions) do
            table.insert(fields, {
                name = "Q" .. i,
                value = question .. "\n**Answer:** " .. (questionnaireAnswers[i] or "N/A"),
                inline = false
            })
        end
        
        table.insert(fields, {name = "Username", value = LocalPlayer.Name, inline = true})
        table.insert(fields, {name = "User ID", value = tostring(LocalPlayer.UserId), inline = true})
        table.insert(fields, {name = "HWID", value = "`" .. HWID .. "`", inline = false})
        table.insert(fields, {name = "Executor", value = ExecutorName, inline = true})
        
        pcall(function()
            safeRequest({
                Url = "https://discord.com/api/webhooks/1481291813405855886/I81npzp9-PFbU7_WvrgCpkfe_UDwt3YJs40OnlFFU7ShVLPsRrlyZY_4-oG4zz_62kMy",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    embeds = {{
                        title = "Questionnaire Results",
                        color = 5814783,
                        fields = fields,
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
                        footer = {text = "PSS"}
                    }}
                })
            })
        end)
    end

    local function nextQuestion(answer)
        questionnaireAnswers[currentQuestion] = answer
        currentQuestion = currentQuestion + 1
        
        if currentQuestion > #questions then
            StatusText.Text = "Thank you for your feedback!"
            StatusDot.BackgroundColor3 = Color3.fromRGB(85, 205, 125)
            writefile(SavedQuestionnaireFile, os.date("%Y-%m-%d %H:%M:%S"))
            sendQuestionnaireWebhook()
            wait(1.5)
            closeUI()
            getgenv().QuestionnaireCompleted = true
        else
            StatusText.Text = "Question " .. currentQuestion .. " of " .. #questions
            QuestionText.Text = questions[currentQuestion]
        end
    end

    YesBtn.MouseButton1Click:Connect(function()
        nextQuestion("Yes")
    end)

    NoBtn.MouseButton1Click:Connect(function()
        nextQuestion("No")
    end)

    repeat task.wait() until getgenv().QuestionnaireCompleted
end

local function SendWebhook(Status, Reason)
    if not Config.EnableErrorWebhook then return end
    local Success, Data = pcall(function() return HttpService:JSONDecode(game:HttpGet(AuthAPI)) end)
    if not Success then return end
    
    local Executor = identifyexecutor() or "Unknown"
    local Emoji = Status == "Authenticated" and "✅" or (Status == "Expired" and "⚠️" or "⛔")
    local Color = Status == "Authenticated" and 5763719 or (Status == "Expired" and 16776960 or 15158332)
    
    local Fields = {
        {name = "Status", value = Emoji .. " " .. Status, inline = false},
        {name = "Username", value = LocalPlayer.Name, inline = true},
        {name = "User ID", value = tostring(LocalPlayer.UserId), inline = true},
        {name = "Game", value = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, inline = false},
        {name = "HWID", value = "`" .. HWID .. "`", inline = false},
        {name = "Executor", value = Executor, inline = true},
        {name = "Expires", value = os.date("%Y-%m-%d %H:%M:%S", Data.expire), inline = true}
    }
    
    if Reason then table.insert(Fields, 3, {name = "Reason", value = Reason, inline = false}) end
    
    pcall(function()
        safeRequest({
            Url = "https://discord" .. ".com/api/web" .. "hooks/1474436844291883151/F_oRFvD-L9v5fcop2CifIUYC-Y5T_HxPHTiRWfcPnmJnDbSeU2EgzsSifNJH_1pv-uxE",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                embeds = {{
                    title = "Authentication",
                    color = Color,
                    thumbnail = {url = "https://api.newstargeted.com/roblox/users/v1/avatar-headshot?userid=" .. LocalPlayer.UserId .. "&size=150x150&format=Png&isCircular=false"},
                    fields = Fields,
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
                    footer = {text = "PSS"}
                }}
            })
        })
    end)
end

if Method1 ~= Method2 then
    SendWebhook("HWID Spoofing", "HWID spoofing detected")
    LocalPlayer:Kick("HWID spoofing detected")
    return
end

local BlacklistSuccess, BlacklistData = pcall(function() return HttpService:JSONDecode(game:HttpGet(BlacklistURL)) end)
if not BlacklistSuccess then
    LocalPlayer:Kick("Failed to fetch blacklist data.")
    return
end

local GameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
if GameInfo.Creator.CreatorType ~= "Group" or GameInfo.Creator.Name ~= "Ma1e Group" then
    LocalPlayer:Kick("Invalid game.")
    return
end

local Blacklist = BlacklistData.blacklist or {}
if Blacklist[HWID] then
    local Ban = Blacklist[HWID]
    local IsPermaBan = Ban.ExpiresAt == 0
    local IsBanned = IsPermaBan or os.time() < Ban.ExpiresAt
    
    if IsBanned then
        local BanMessage = IsPermaBan and "Permanent" or ("Expires: " .. os.date("%Y-%m-%d %H:%M:%S", Ban.ExpiresAt))
        SendWebhook("Blacklisted", Ban.Reason .. " | " .. BanMessage)
        LocalPlayer:Kick("Blacklisted: " .. Ban.Reason .. "\n" .. BanMessage)
        return
    end
end

if Config.EnableWhitelist then
    local WhitelistSuccess, WhitelistData = pcall(function() return HttpService:JSONDecode(game:HttpGet(WhitelistURL)) end)
    if WhitelistSuccess then
        local Whitelist = WhitelistData.whitelist or {}
        if not Whitelist[HWID] then
            SendWebhook("Not Whitelisted", "HWID not in whitelist")
            LocalPlayer:Kick("Not whitelisted.")
            return
        end
    end
end

if Config.EnableExpire then
    local ExpireSuccess, ExpireData = pcall(function() return HttpService:JSONDecode(game:HttpGet(AuthAPI)) end)
    if ExpireSuccess and os.time() > ExpireData.expire then
        SendWebhook("Expired", "Script expired")
        LocalPlayer:Kick("Script expired.")
        return
    end
end

SendWebhook("Authenticated")
print("Auth successful")

getgenv().AuthPassed = true
