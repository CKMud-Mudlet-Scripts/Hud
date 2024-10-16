local ck = require("CK")
local Player = ck:get_table("Player")
local Room = ck:get_table("Room")
local API = ck:get_table("API")
local hud = ck:get_table("hud")

local playerInfoContainer = Geyser.Container:new({
    name = "playerInfoContainer",
    x = "15%",
    y = "90%",
    width = "15%",
    height = "10%"
}, hud.BottomBar)

local borderLabel = Geyser.Label:new({
    name = "playerBorderLabel",
    x = "15%",
    y = "90%",
    width = "15%",
    height = "10%"
}, hud.BottomBar)

borderLabel:setStyleSheet([[
    border: 4px double green;
    background-color: rgba(0, 0, 0, 0);
]])

local playerInfoLabel = Geyser.Label:new({
    name = "playerInfoLabel",
    x = "15.5%",
    y = "90%",
    width = "14%",
    height = "10%"
}, playerInfoContainer)

local function getPlayerInfoText()
    local playerInfoText = string.format([[
    <div style="display: flex; justify-content: center; align-items: center; height: 100%%;">
        <table style="width: 100%%; border-spacing: 10px; text-align: left;">
            <tr>
                <td style="padding-right: 30px;"><b>Name:</b></td><td><b>%s</b></td>
                <td style="padding-right: 30px;"><b>State:</b></td><td><b>%s</b></td>
            </tr>
            <tr>
                <td style="padding-right: 30px;"><b>Race:</b></td><td><b>%s</b></td>
                <td style="padding-right: 30px;"><b>Mode:</b></td><td><b>%s</b></td>
            </tr>
            <tr>
                <td style="padding-right: 30px;"><b>Base PL:</b></td><td><b>%s</b></td>
                <td style="padding-right: 30px;"><b>Gravity:</b></td><td><b>%s</b></td>
            </tr>
            <tr>
                <td style="padding-right: 30px;"><b>Zenni:</b></td><td><b>%s</b></td>
            </tr>
        </table>
    </div>
]], API:getName(), API.State:toString(), -- Fetch the player's state
    API:getRace(), API.Mode:toString(), -- Fetch the player's mode
    math.format(Player.BasePl), math.format(Room.Gravity), math.format(Player.Zenni))
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
