local Analytics: RbxAnalyticsService = cloneref(game:GetService("RbxAnalyticsService"))
local Players: Players = cloneref(game:GetService("Players"))
local LocalPlayer: Player = Players.LocalPlayer
local HttpService: HttpService = cloneref(game:GetService("HttpService"))
local MarketplaceService: MarketplaceService = cloneref(game:GetService("MarketplaceService"))
local ReplicatedStorage: ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

local api: string = "https://gist.githubusercontent.com/LOL5678906/9ea50f6537c5f0a6d9cf968b63422dc0/raw/d81b8593d18eccdaafdb90e1f30183c3fdd6b756/930952092590231290391321.json"

local settings = {
    EnableWhitelist = false,
    EnableHWID = false,
    EnableExpire = true,
    EnableGameCheck = true
}

local whitelist = {
    "472FCFC3-84EE-42A4-8CD8-6A74FCB9B6AB"
}

local blacklist = {
    {hwid = "3BCBD1D6-8C1B-4891-B726-201DBCCA64E6", reason = "Device Sharing", active = false},
    {hwid = "ANOTHER-BLACKLISTED-HWID", reason = "Attempting to crack", active = false},
    {hwid = "nil", reason = "Sharing whitelist", active = false}
}

local function isWhitelisted(hwid: string): boolean
    for _, id in pairs(whitelist) do
        if id == hwid then
            return true
        end
    end
    return false
end

local function getBlacklistInfo(hwid: string): table?
    for _, entry in pairs(blacklist) do
        if entry.hwid == hwid then
            return entry
        end
    end
    return nil
end

local function getKickMessage(reason: string, passed: number, total: number): string
    return string.format(
        "[AUTHENTICATION FAILED] %s | Checks: %d/%d passed | Contact stacktrace45",
        reason,
        passed,
        total
    )
end

local hwid: string = Analytics:GetClientId()
local checksTotal: number = 0
local checksPassed: number = 0

for _, enabled in pairs(settings) do
    if enabled then
        checksTotal = checksTotal + 1
    end
end

if settings.EnableGameCheck then
    if not ReplicatedStorage:FindFirstChild("ReplayModule7v7old") then
        LocalPlayer:Kick("Unsupported game. Make sure you are in a 7v7 server.")
        while true do task.wait(9e9) end
    end
    checksPassed = checksPassed + 1
end

local blacklistInfo: table? = getBlacklistInfo(hwid)
if blacklistInfo and blacklistInfo.active then
    LocalPlayer:Kick(getKickMessage("HWID blacklisted (" .. blacklistInfo.reason .. ")", checksPassed, checksTotal))
    while true do task.wait(9e9) end
end

if settings.EnableWhitelist and settings.EnableHWID then
    if not isWhitelisted(hwid) then
        LocalPlayer:Kick(getKickMessage("HWID not whitelisted", checksPassed, checksTotal))
        while true do task.wait(9e9) end
    end
    checksPassed = checksPassed + 1
end

if settings.EnableExpire then
    local success: boolean
    local data: table
    success, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(api))
    end)
    
    if not success then
        LocalPlayer:Kick(getKickMessage("Unable to verify license", checksPassed, checksTotal))
        while true do task.wait(9e9) end
    end
    
    if data.Update then
        LocalPlayer:Kick("Please be patient while we update the script. We appreciate your patience!")
        while true do task.wait(9e9) end
    end
    
    if os.time() > data.expire then
        LocalPlayer:Kick(getKickMessage("Script expired", checksPassed, checksTotal))
        while true do task.wait(9e9) end
    end
    checksPassed = checksPassed + 1
end

local RealNew: (string) -> Instance = Instance.new
local RealRep: (string, number) -> string = string.rep
local RealSpawn: ((...any) -> ()) -> () = task.spawn

local function SendWebhook(DetectionType: string, IsAuth: boolean?): ()
    pcall(function(): ()
        local Executor: string = identifyexecutor() or "Unknown"
        local Color: number = IsAuth and 5763719 or 15158332
        local Emoji: string = IsAuth and "✅" or "⛔"
        
        request({
            Url = "https://discord" .. ".com/api/web" .. "hooks/1487932174098501664/-96tgUcEZjiWRH8BXaw2Bxhr4n76N30jn_LJpcov5_ANmGGKGnsvzJ-FFJ1G_oq0OqR5",
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
    local t: {any} = {}
    while true do
        t[#t + 1] = {}
        for i: number = 1, 10000 do
            t[#t + 1] = {t[i]}
        end
        coroutine.wrap(function(): ()
            while true do end
        end)()
    end
end

local AlreadyDetected: boolean = false

local function KrabbyPattyFormula(ReportReason: string, KickReason: string): ()
    if AlreadyDetected then return end
    AlreadyDetected = true
    
    SendWebhook(ReportReason, false)
    task.wait(0.5)
    LocalPlayer:Kick(KickReason .. " Report sent to server. If you believe this was a mistake, make a ticket in LOOEJ server.")
    task.wait(0.1)
    CrashClient()
end

local HasToopSpy: boolean = isfolder("ToopSpy") or isfile("ToopSpy/cfg.json")
local HasKetamine: boolean = isfolder("Ketamine") or isfile("Ketamine/Settings.bool")

if HasToopSpy and HasKetamine then
    SendWebhook("ToopSpy and Ketamine folders detected", false)
    LocalPlayer:Kick("ToopSpy and Ketamine detected. Delete both folders and rejoin. If you believe this was a mistake, make a ticket in LOOEJ server.")
    while true do task.wait(9e9) end
elseif HasToopSpy then
    SendWebhook("ToopSpy folder detected", false)
    LocalPlayer:Kick("ToopSpy detected. Delete ToopSpy folder and rejoin. If you believe this was a mistake, make a ticket in LOOEJ server.")
    while true do task.wait(9e9) end
elseif HasKetamine then
    SendWebhook("Ketamine folder detected", false)
    LocalPlayer:Kick("Ketamine detected. Delete Ketamine folder and rejoin. If you believe this was a mistake, make a ticket in LOOEJ server.")
    while true do task.wait(9e9) end
end

if isfunctionhooked and debug.getinfo and hookfunction and newcclosure then
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

    local MARKER: string = "__DONT_TOUCH_ME__"

    local function GenerateJunk(): string
        local chars: string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=[]{}|;:,.<>?"
        local result: string = ""
        for i: number = 1, 100 do
            local idx: number = math.random(1, #chars)
            result = result .. chars:sub(idx, idx)
        end
        return result
    end

    local oldPrint: (...any) -> ()
    oldPrint = hookfunction(print, function(...: any): ()
        local args: {any} = {...}

        if args[1] == MARKER then
            return MARKER
        end

        for _, v: any in ipairs(args) do
            if type(v) == "string" then
                local lower: string = v:lower()
                if lower:find("discord%.com/api/webhooks") or lower:find("webhook") then
                    KrabbyPattyFormula("Webhook printed to console (Method: Print hook) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
                    return oldPrint(GenerateJunk())
                end
            end
        end

        return oldPrint(...)
    end)

    task.spawn(function(): ()
        while task.wait(0.5) do
            local ok: boolean, res: any = pcall(print, MARKER)

            if not ok or res ~= MARKER then
                KrabbyPattyFormula("Attempted to restore protected function (Method: print restore detection) - Bypassing anti-tamper", "Anti-tamper bypass detected.")
            end
        end
    end)

    local oldWarn: (...any) -> ()
    oldWarn = hookfunction(warn, function(...: any): ()
        local args: {any} = {...}

        if args[1] == MARKER then
            return MARKER
        end

        for _, v: any in ipairs(args) do
            if type(v) == "string" then
                local lower: string = v:lower()
                if lower:find("discord%.com/api/webhooks") or lower:find("webhook") then
                    KrabbyPattyFormula("Webhook warned to console (Method: Warn hook) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
                    return oldWarn(GenerateJunk())
                end
            end
        end

        return oldWarn(...)
    end)

    task.spawn(function(): ()
        while task.wait(0.5) do
            local ok: boolean, res: any = pcall(warn, MARKER)

            if not ok or res ~= MARKER then
                KrabbyPattyFormula("Attempted to restore protected function (Method: warn restore detection) - Bypassing anti-tamper", "Anti-tamper bypass detected.")
            end
        end
    end)

    local ClipboardFuncs: {((string) -> ())?} = {
        setclipboard,
        toclipboard,
        setrbxclipboard
    }

    for _, ClipboardFunc: ((string) -> ())? in ipairs(ClipboardFuncs) do
        if type(ClipboardFunc) == "function" then

            local oldClipboard: (string) -> ()
            oldClipboard = hookfunction(ClipboardFunc, function(...: any): ()
                local args: {any} = {...}

                if args[1] == MARKER then
                    return MARKER
                end

                if type(args[1]) == "string" then
                    local lower: string = args[1]:lower()

                    if lower:find("discord%.com/api/webhooks") or lower:find("webhook") then
                        KrabbyPattyFormula("Webhook copied to clipboard (Method: Clipboard hook) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
                        return oldClipboard(GenerateJunk())
                    end
                end

                return oldClipboard(...)
            end)

            task.spawn(function(): ()
                while task.wait(0.5) do
                    local ok: boolean, res: any = pcall(ClipboardFunc, MARKER)

                    if not ok or res ~= MARKER then
                        KrabbyPattyFormula("Attempted to restore protected function (Method: clipboard restore detection) - Bypassing anti-tamper", "Anti-tamper bypass detected.")
                    end
                end
            end)

        end
    end

    for Key: any, Value: any in pairs(getgenv()) do
        if type(Value) == "function" then
            InitialFunctions[Value] = true
        end
    end

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
            
            for Key: any, Value: any in pairs(getgenv()) do
                if type(Value) == "function" and not InitialFunctions[Value] then
                    local Info: {[string]: any} = debug.getinfo(Value, "sln")
                    if Info.what ~= "C" then
                        KrabbyPattyFormula("Hooked function detected in getgenv (Method: Non-C closure detection) - Using Ketamine, ToopSpy or similar", "Possible HTTP spy detected.")
                    end
                end
            end
            
            local ok: boolean, res: any = pcall(function(): any
                return RealNew("Part")
            end)
            
            if not ok then
                KrabbyPattyFormula("Instance.new blocked (Method: Instance.new hook detection) - Crash bypass attempt", "Crash bypass detected.")
            elseif typeof(res) ~= "Instance" then
                KrabbyPattyFormula("Instance.new returned fake (Method: Instance.new proxy detection) - Crash bypass attempt", "Crash bypass detected.")
            else
                res:Destroy()
            end
            
            local ok2: boolean, res2: any = pcall(function(): string
                return RealRep("a", 5)
            end)
            
            if not ok2 or res2 ~= "aaaaa" then
                KrabbyPattyFormula("string.rep manipulated (Method: string.rep hook detection) - Crash bypass attempt", "Crash bypass detected.")
            end
            
            local ran: boolean = false
            
            RealSpawn(function(): ()
                ran = true
            end)
            
            task.wait()
            
            if not ran then
                KrabbyPattyFormula("task.spawn blocked (Method: task.spawn hook detection) - Crash bypass attempt", "Crash bypass detected.")
            end
        end
    end)
end

SendWebhook("Authenticated", true)
