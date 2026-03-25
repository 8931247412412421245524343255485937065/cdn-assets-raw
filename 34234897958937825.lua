local api = "https://gist.githubusercontent.com/LOL5678906/9ea50f6537c5f0a6d9cf968b63422dc0/raw/d81b8593d18eccdaafdb90e1f30183c3fdd6b756/930952092590231290391321.json"
local http: HttpService = cloneref(game:GetService("HttpService"))
local players: Players = cloneref(game:GetService("Players"))
local analytics: RbxAnalyticsService = cloneref(game:GetService("RbxAnalyticsService"))
local replicated: ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local plr: Player = cloneref(players.LocalPlayer)

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

local hwid: string = analytics:GetClientId()
local checksTotal: number = 0
local checksPassed: number = 0

for _, enabled in pairs(settings) do
    if enabled then
        checksTotal = checksTotal + 1
    end
end

if settings.EnableGameCheck then
    if not replicated:FindFirstChild("ReplayModule7v7old") then
        plr:Kick("Unsupported game. Make sure you are in a 7v7 server.")
        return
    end
    checksPassed = checksPassed + 1
end

local blacklistInfo: table? = getBlacklistInfo(hwid)
if blacklistInfo and blacklistInfo.active then
    plr:Kick(getKickMessage("HWID blacklisted (" .. blacklistInfo.reason .. ")", checksPassed, checksTotal))
    return
end

if settings.EnableWhitelist and settings.EnableHWID then
    if not isWhitelisted(hwid) then
        plr:Kick(getKickMessage("HWID not whitelisted", checksPassed, checksTotal))
        return
    end
    checksPassed = checksPassed + 1
end

if settings.EnableExpire then
    local success: boolean
    local data: table
    success, data = pcall(function()
        return http:JSONDecode(game:HttpGet(api))
    end)
    
    if not success then
        warn("Unable to verify license")
        plr:Kick(getKickMessage("Unable to verify license", checksPassed, checksTotal))
        return
    end
    
    if data.Update then
        plr:Kick("Please be patient while we update the script. We appreciate your patience!")
        return
    end
    
    if os.time() > data.expire then
        warn("Script expired")
        plr:Kick(getKickMessage("Script expired", checksPassed, checksTotal))
        return
    end
    checksPassed = checksPassed + 1
end
