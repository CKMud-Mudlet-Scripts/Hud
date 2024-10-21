local ck = require("CK")
local Player = ck:get_table("Player")
local API = ck:get_table("API")
local hud = ck:get_table("hud")

local statsContainer = Geyser.Container:new({
    name = "statsContainer",
    x = "50%",
    y = "0%",
    width = "25%",
    height = "100%"
}, hud.bottomBar)

local borderLabel = Geyser.Label:new({
    name = "statsBorderLabel",
    x = "50%",
    y = "0%",
    width = "25%",
    height = "100%"
}, hud.bottomBar)

borderLabel:setStyleSheet([[
    border: 4px double green;
    background-color: rgba(0, 0, 0, 0);
]])

local statsLabel = Geyser.Label:new({
    name = "statsLabel",
    x = "5%",
    y = "5%",
    width = "100%",
    height = "100%"
}, statsContainer)


registerNamedEventHandler("__PKGNAME__", "Resize StatsContainer", "__PKGNAME__.resize", function()
    statsContainer:resize("25%", "100%")
    borderLabel:resize("25%", "100%")
    statsLabel:resize("100%", "100%")
end)


local function getStatsText()
    local Player = Player
    local statsText = string.format([[
<div style="display: flex; justify-content: center; align-items: center; height: 100%%;">
    <table style="width: 100%%; text-align: left;">
        <tr>
            <td style="padding-right: 5px;"><b>STR:</b></td><td><b>%s</b></td>
            <td style="padding-left: 18px; padding-right: 5px;"><b>UBS:</b></td><td><b>%s</b></td>  <!-- Added padding-left for spacing -->
            <td style="padding-left: 18px; padding-right: 5px;"><b>ARM:</b></td><td><b>%s</b></td>  <!-- Added padding-left -->
        </tr>
        <tr>
            <td style="padding-right: 5px;"><b>SPD:</b></td><td><b>%s</b></td>
            <td style="padding-left: 18px; padding-right: 5px;"><b>LBS:</b></td><td><b>%s</b></td>
            <td style="padding-left: 18px; padding-right: 5px;"><b>HIT:</b></td><td><b>%s</b></td>
        </tr>
        <tr>
            <td style="padding-right: 5px;"><b>INT:</b></td><td><b>%s</b></td>
            <td style="padding-left: 18px; padding-right: 5px;"><b>HUNG:</b></td><td><b>%s</b></td>
            <td style="padding-left: 18px; padding-right: 5px;"><b>DAM:</b></td><td><b>%s</b></td>
        </tr>
        <tr>
            <td style="padding-right: 5px;"><b>WIS:</b></td><td><b>%s</b></td>
            <td style="padding-left: 18px; padding-right: 5px;"><b>THISRT:</b></td><td><b>%s</b></td>
            <td style="padding-left: 18px; padding-right: 5px;"><b>GRAV:</b></td><td><b>%s</b></td>
        </tr>
    </table>
</div>
]], Player.Stats.STR, Player.UBS, Player.Armor/80, Player.Stats.SPD, Player.LBS, Player.Hitroll, Player.Stats.INT,
        Player.Hunger, Player.Damroll, Player.Stats.WIS, Player.Thirst, Player.MaxGravity)
    return statsText
end

statsLabel:setStyleSheet([[
    background-color: black;
]])

statsLabel:lower()

local function updateStats()
    statsLabel:clear()
    statsLabel:echo(getStatsText())
end

-- Update on the tick
registerNamedEventHandler("__PKGNAME__", "updateStats", "CK.tick", updateStats)