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
