--[[

    For anyone wondering, this just sends a discord message when someone executed the script.
    We only log basic data such as roblox username, executor used and the game you are in.
    Sensetive data such as IP adresses or HWIDs are NOT logged and never will be.
    If you want proof of this, feel free to dm me on discord: elmaethan823-art.

]]--

local function CloneReference(Object)
    if Seahook.Environment.cloneref then
        return Seahook.Environment.cloneref(Object)
    else
        return Object
    end
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

if Seahook.Environment.identifyexecutor and Seahook.Environment.request then
    local Player = Services.Players.LocalPlayer
    local Data = {
        Account = Player.Name,
        Executor = Seahook.Environment.identifyexecutor(),
        Executions = tonumber(Seahook.TotalExecutions),
        GameName = Services.MarketplaceService:GetProductInfo(game.PlaceId).Name,
        PlaceId = tostring(game.PlaceId)
    }

    task.spawn(function()
        pcall(function()
            Seahook.Environment.request({
                Url = "https://Abysall.wispbyte.org/api/send",
                Method = "POST",
                Headers = {
                    ["content-type"] = "application/json"
                },
                Body = Services.HttpService:JSONEncode(Data)
            })
        end)
    end)
end
