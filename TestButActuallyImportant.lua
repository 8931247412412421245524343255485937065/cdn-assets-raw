------------------- W.I.P -------------------

local Analytics: RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players: Players = game:GetService("Players")
local LocalPlayer: Player = Players.LocalPlayer
local HttpService: HttpService = game:GetService("HttpService")
local MarketplaceService: MarketplaceService = game:GetService("MarketplaceService")

local function SendWebhook(DetectionType: string, IsAuth: boolean?): ()
    pcall(function(): ()
        local Executor: string = identifyexecutor() or "Unknown"
        local Color: number = IsAuth and 5763719 or 15158332
        local Emoji: string = IsAuth and "✅" or "⛔"
        
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
                        {name = "HWID", value = "`" .. gethwid() .. "`", inline = false},
                        {name = "Executor", value = Executor, inline = true}
                    },
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
                    footer = {text = "PSS"}
                }}
            })
        })
    end)
end

local function CrashClient(): ()
    while true do
        local Table: {[number]: string} = {}
        while true do
            for Index: number = 1, 1e9 do
                Table[Index] = string.rep("crash", 1e6)
                Instance.new("Part").Parent = workspace
            end
        end
    end
end

local AlreadyDetected: boolean = false

local function KrabbyPattyFormula(ReportReason: string, KickReason: string): ()
    if AlreadyDetected then return end
    AlreadyDetected = true
    
    task.spawn(function(): ()
        SendWebhook(ReportReason, false)
        task.wait(0.5)
        LocalPlayer:Kick(KickReason .. " Report sent to server. If you believe this was a mistake, make a ticket in LOOEJ server.")
        task.wait(0.1)
        CrashClient()
    end)
end

local HwidFunctionNames: {string} = {
    "gethwid",
    "getexecutorhwid",
    "get_hwid",
    "GetHWID"
}

for _, FuncName: string in ipairs(HwidFunctionNames) do
    local Func: any = getgenv()[FuncName] or getrenv()[FuncName]
    
    if Func and type(Func) == "function" then
        if isfunctionhooked(Func) then
            KrabbyPattyFormula("HWID function already hooked before script execution (Method: " .. FuncName .. " pre-hooked) - Pre-execution HWID spoofing detected", "Pre-execution HWID spoofing detected.")
        end
        
        local Info: {[string]: any} = debug.getinfo(Func)
        
        if Info and Info.source ~= "=[C]" then
            KrabbyPattyFormula("HWID function hooked (Method: " .. FuncName .. " not C closure) - HWID function spoofing detected", "HWID function spoofing detected.")
        end
    end
end

local OriginalGethwid: () -> string = gethwid
local BaseHWID: string = OriginalGethwid()
local GetClientIdRef: (RbxAnalyticsService) -> string = Analytics.GetClientId
local ExecutorName: string = identifyexecutor() or "Unknown"

local HasToopSpy: boolean = isfolder("ToopSpy") or isfile("ToopSpy/cfg.json")
local HasKetamine: boolean = isfolder("Ketamine") or isfile("Ketamine/Settings.bool")

if HasToopSpy and HasKetamine then
    SendWebhook("ToopSpy and Ketamine folders detected", false)
    LocalPlayer:Kick("ToopSpy and Ketamine detected. Delete both folders and rejoin. If you believe this was a mistake, make a ticket in LOOEJ server.")
    return
elseif HasToopSpy then
    SendWebhook("ToopSpy folder detected", false)
    LocalPlayer:Kick("ToopSpy detected. Delete ToopSpy folder and rejoin. If you believe this was a mistake, make a ticket in LOOEJ server.")
    return
elseif HasKetamine then
    SendWebhook("Ketamine folder detected", false)
    LocalPlayer:Kick("Ketamine detected. Delete Ketamine folder and rejoin. If you believe this was a mistake, make a ticket in LOOEJ server.")
    return
end

task.spawn(function(): ()
    task.wait(2)

    local Success1: boolean, Error1: string? = pcall(function(): ()
        LocalPlayer.Kick(workspace, "Test")
    end)

    local Success2: boolean, Error2: string? = pcall(function(): ()
        workspace:Kick("Test")
    end)

    if Success1 or Error1 ~= "Expected ':' not '.' calling member function Kick" then
        KrabbyPattyFormula("Anti-kick detected", "Anti-kick bypass detected.")
    end

    if Success2 or not string.match(Error2 or "", "^Kick is not a valid member of Workspace") then
        KrabbyPattyFormula("Anti-kick detected", "Anti-kick bypass detected.")
    end

    if #Players:GetPlayers() > 1 then
        for _, OtherPlayer: Player in ipairs(Players:GetPlayers()) do
            if OtherPlayer ~= LocalPlayer and OtherPlayer.Parent == Players then
                local Success3: boolean, Error3: string? = pcall(LocalPlayer.Kick, OtherPlayer, "Test")
                local Success4: boolean, Error4: string? = pcall(function(): ()
                    OtherPlayer:Kick("Test")
                end)

                if Success3 or Error3 ~= "Cannot kick a non-local Player from a LocalScript" then
                    KrabbyPattyFormula("Anti-kick detected", "Anti-kick bypass detected.")
                end

                if Success4 or Error4 ~= "Cannot kick a non-local Player from a LocalScript" then
                    KrabbyPattyFormula("Anti-kick detected", "Anti-kick bypass detected.")
                end
                break
            end
        end
    end

    local Success5: boolean, Error5: string? = pcall(function(): ()
        LocalPlayer:KicK("Test")
    end)

    if Success5 or not string.match(Error5 or "", "is not a valid member of Player") then
        KrabbyPattyFormula("Anti-kick detected", "Anti-kick bypass detected.")
    end
end)

local InitialFunctions: {[any]: boolean} = {}
local ProtectedFunctions: {[any]: boolean} = {}

local OriginalRestore: (any) -> any = restorefunction
restorefunction = function(Func: any): any
    if ProtectedFunctions[Func] then
        KrabbyPattyFormula("Attempted to restore protected function (Method: restorefunction detection) - Bypassing anti-tamper", "Anti-tamper bypass detected.")
    end
    return OriginalRestore(Func)
end

local OriginalPrint: (...any) -> ()
OriginalPrint = hookfunction(print, function(...: any): ()
    local Args: {any} = {...}
    for _, Arg: any in ipairs(Args) do
        if type(Arg) == "string" then
            local Lower: string = Arg:lower()
            if Lower:find("discord%.com/api/webhooks") or Lower:find("webhook") then
                SendWebhook("Webhook printed to console (Method: Print hook) - Using Ketamine, ToopSpy or similar", false)
                CrashClient()
            end
        end
    end
    return OriginalPrint(...)
end)
ProtectedFunctions[print] = true

local OriginalWarn: (...any) -> ()
OriginalWarn = hookfunction(warn, function(...: any): ()
    local Args: {any} = {...}
    for _, Arg: any in ipairs(Args) do
        if type(Arg) == "string" then
            local Lower: string = Arg:lower()
            if Lower:find("discord%.com/api/webhooks") or Lower:find("webhook") then
                SendWebhook("Webhook warned to console (Method: Warn hook) - Using Ketamine, ToopSpy or similar", false)
                CrashClient()
            end
        end
    end
    return OriginalWarn(...)
end)
ProtectedFunctions[warn] = true

local ClipboardFunc: ((string) -> ())? = setclipboard or toclipboard or setrbxclipboard
if ClipboardFunc then
    local OriginalClipboard: (string) -> ()
    OriginalClipboard = hookfunction(ClipboardFunc, function(...: any): ()
        local Args: {any} = {...}
        if #Args > 0 and type(Args[1]) == "string" then
            local Text: string = Args[1]
            local Lower: string = Text:lower()
            if Lower:find("discord%.com/api/webhooks") or Lower:find("webhook") then
                KrabbyPattyFormula("Webhook copied to clipboard (Method: Clipboard hook) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
                return OriginalClipboard("Nice try buddy")
            end
        end
        return OriginalClipboard(...)
    end)
    ProtectedFunctions[setclipboard] = true
    if toclipboard then ProtectedFunctions[toclipboard] = true end
    if setrbxclipboard then ProtectedFunctions[setrbxclipboard] = true end
end

for Key: any, Value: any in pairs(getgenv()) do
    if type(Value) == "function" then
        InitialFunctions[Value] = true
    end
end

SendWebhook("Authenticated", true)

local SuspiciousPatterns: {string} = {
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

local Metatable: {[any]: any} = getrawmetatable(game)
setreadonly(Metatable, false)

local OriginalIndex: (any, any) -> any = Metatable.__index
Metatable.__index = newcclosure(function(self: any, key: any): any
    local Result: any = OriginalIndex(self, key)
    
    if key == "Text" and type(Result) == "string" then
        for _, Pattern: string in pairs(SuspiciousPatterns) do
            if Result:match(Pattern) then
                KrabbyPattyFormula("Possible HTTP spy detected (Method: GUI text detection) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
            end
        end
    end
    
    return Result
end)

local OriginalNewindex: (any, any, any) -> () = Metatable.__newindex
Metatable.__newindex = newcclosure(function(self: any, key: any, value: any): ()
    if key == "Text" and type(value) == "string" then
        for _, Pattern: string in pairs(SuspiciousPatterns) do
            if value:match(Pattern) then
                KrabbyPattyFormula("Possible HTTP spy detected (Method: GUI text modification) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
            end
        end
    end
    
    return OriginalNewindex(self, key, value)
end)

setreadonly(Metatable, true)

task.spawn(function(): ()
    while task.wait(1) do
        if OriginalGethwid() ~= BaseHWID then
            KrabbyPattyFormula("HWID spoofing detected (Method: Original function reference comparison)", "HWID spoofing detected.")
        end
        
        if gethwid() ~= BaseHWID then
            KrabbyPattyFormula("HWID spoofing detected (Method: HWID comparison)", "HWID spoofing detected.")
        end
        
        local ClientIdA: string = Analytics:GetClientId()
        local ClientIdB: string = Analytics.GetClientId(Analytics)
        if ClientIdA ~= ClientIdB then
            KrabbyPattyFormula("ClientId spoofing detected (Method: Namecall vs direct call)", "ClientId spoofing detected.")
        end
        
        local ClientIdC: string = GetClientIdRef(Analytics)
        if ClientIdA ~= ClientIdC then
            KrabbyPattyFormula("ClientId spoofing detected (Method: Function reference vs namecall)", "ClientId spoofing detected.")
        end
        
        local RequestFunc: any = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
        if RequestFunc then
            if ExecutorName == "Potassium" then
                local Success: boolean, Error: string? = pcall(RequestFunc)
                if Success or (Error and not Error:lower():find("table")) then
                    KrabbyPattyFormula("HTTP request function hooked (Method: Request validation) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
                end
            else
                local Accesses: {[any]: boolean} = {}
                local ProxyTable: {[any]: any} = setmetatable({}, {
                    __index = function(_: any, k: any): nil
                        Accesses[k] = true
                        return nil
                    end
                })
                
                pcall(function(): ()
                    RequestFunc(ProxyTable)
                end)
                
                local Count: number = 0
                for _: any in pairs(Accesses) do
                    Count += 1
                end
                
                if Count > 1 then
                    KrabbyPattyFormula("HTTP request function hooked (Method: Multiple key access detection) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
                end
            end
        end
        
        for Key: any, Value: any in pairs(getgenv()) do
            if type(Value) == "function" and not InitialFunctions[Value] then
                local Info: {[string]: any} = debug.getinfo(Value, "sln")
                if Info.what ~= "C" then
                    KrabbyPattyFormula("Hooked function detected in getgenv (Method: Non-C closure detection) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
                end
            end
        end
    end
end)

