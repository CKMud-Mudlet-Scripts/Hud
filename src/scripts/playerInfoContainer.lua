local ck = require("CK")
local Player = ck:get_table("Player")
local Room = ck:get_table("Room")
local API = ck:get_table("API")
local hud = ck:get_table("hud")

local playerInfoContainer = Geyser.Container:new({
    name = "playerInfoContainer",
    x = "25%",
    y = "0%",
    width = "25%",
    height = "100%"
}, hud.bottomBar)

local borderLabel = Geyser.Label:new({
    name = "playerBorderLabel",
    x = "25%",
    y = "0%",
    width = "25%",
    height = "100%"
}, hud.bottomBar)

borderLabel:setStyleSheet([[
    border: 4px double green;
    background-color: rgba(0, 0, 0, 0);
]])

local playerInfoLabel = Geyser.Label:new({
    name = "playerInfoLabel",
    x = "5%",
    y = "5%",
    width = "100%",
    height = "100%"
}, playerInfoContainer)

registerNamedEventHandler("__PKGNAME__", "Resize Playerinfo", "__PKGNAME__.resize", function()
    playerInfoContainer:resize("25%", "100%")
    borderLabel:resize("25%", "100%")
    playerInfoLabel:resize("100%", "100%")
end)

local function getPlayerInfoText()
    local API = API
    local Player = Player
    local Room = Room
    local playerInfoText = string.format([[
    <div style="display: flex; justify-content: center; align-items: center; height: 100%%;">
         <table style="width: 100%%; border-spacing: 10px; text-align: left;">
             <tr>
                 <td style="padding-right: 5px;"><b>Name:</b></td><td><b>%s</b></td>
                 <td style="padding-right: 5px;"><b>State:</b></td><td><b>%s</b></td>
             </tr>
             <tr>
                 <td style="padding-right: 5px;"><b>Race:</b></td><td><b>%s</b></td>
                 <td style="padding-right: 5px;"><b>Mode:</b></td><td><b>%s</b></td>
             </tr>
             <tr>
                 <td style="padding-right: 5px;"><b>Base PL:</b></td><td><b>%s</b></td>
                 <td style="padding-right: 5px;"><b>Gravity:</b></td><td><b>%s</b></td>
             </tr>
             <tr>
                 <td style="padding-right: 5px;"><b>Zenni:</b></td><td><b>%s</b></td>
                 <td style="padding-right: 5px;"><b>Token:</b></td><td><b>%s</b></td>
             </tr>
         </table>
     </div>
     ]], API:getName(), API.State:toString(), -- Fetch the player's state
        API:getRace(), API.Mode:toString(),   -- Fetch the player's mode
        CK.math.format(Player.BasePl), CK.math.format(Room.Gravity), CK.math.format(Player.Zenni), CK.math.format(Player.Tokens))
    return playerInfoText
end

playerInfoLabel:setStyleSheet([[
    background-color: black;
]])

playerInfoLabel:lower()

local function updatePlayerInfo()
    playerInfoLabel:clear()
    playerInfoLabel:echo(getPlayerInfoText())
end
-- Update on the tick
registerNamedEventHandler("__PKGNAME__", "updatePlayerInfo", "CK.tick", updatePlayerInfo)
