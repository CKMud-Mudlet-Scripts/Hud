local ck = require("CK")
local Player = ck:get_table("Player")
local Target = ck:get_table("Target")
local API = ck:get_table("API")
local hud = ck:get_table("hud")

local gaugeContainer = Geyser.Container:new({
    name = "gaugeContainer",
    x = "75%",
    y = "0%",
    width = "25%",
    height = "50%"
}, hud.bottomBar)

--gaugeContainer:flash()

local targetInfoContainer = Geyser.Container:new({
    name = "targetInfoContainer",
    x = "75%",
    y = "50%",
    width = "25%",
    height = "50%"
}, hud.bottomBar)
--targetInfoContainer:flash()

local targetBorderLabel = Geyser.Label:new({
    name = "targetBorderLabel",
    x = "0%",
    y = "0%",
    width = "100%",
    height = "100%"
}, hud.bottomBar)

targetBorderLabel:setStyleSheet([[
    border: 4px double green;
    background-color: rgba(0, 0, 0, 0);
]])

targetBorderLabel:raise()

local tarPowerGauge = Geyser.Gauge:new({
        name = "tarPowerGauge",
        x = "0%",
        y = "0%",
        width = "100%",
        height = "100%"
}, gaugeContainer)

tarPowerGauge:setText(f "Health: 100 / 100")
tarPowerGauge:setValue(100, 100)
tarPowerGauge:setAlignment("c")
tarPowerGauge:setStyleSheet([[background-color: rgb(0, 128, 0);]])
tarPowerGauge.back:setStyleSheet("background-color: black;")
tarPowerGauge:hide()

local tarStatsLabel = Geyser.Label:new({
    name = "tarStatsLabel",
    x = "0%",
    y = "0%",
    width = "100%",
    height = "100%"
}, targetInfoContainer)

registerNamedEventHandler("__PKGNAME__", "Resize TargetContainer", "__PKGNAME__.resize", function()
    gaugeContainer:resize("25%", "50%")
    targetInfoContainer:resize("25%", "50%")
    targetBorderLabel:resize("100%", "100%")
    tarPowerGauge:resize("100%", "100%")
    tarStatsLabel:resize("100%", "100%")
end)


local function getTarInfoText()
    local tarInfoText = string.format([[
    <div style="display: flex; justify-content: center; align-items: center; height: 100%%;">
        <table style="width: 80%%; border-spacing: 10px; text-align: left;">
            <tr><td style="padding-right: 50px;"><b>Name:</b></td><td><b>%s</b></td></tr>
            <tr><td style="padding-right: 50px;"><b>Level:</b></td><td><b>%s</b></td></tr>
        </table>
    </div>
]], Target.name, Target.level)
    return tarInfoText
end

tarStatsLabel:setStyleSheet([[
    background-color: rgba(0, 0, 0, 0);
    color: white;
]])

tarStatsLabel:raise()

local function updateTargetInfo()
    local Target = Target
    if CK.Target.level > 0 then
        -- Update the power gauge
        tarPowerGauge:setValue(Target.Health, Target.MaxHealth)
        tarPowerGauge:setText(f"Health: {Target.Health} / {Target.MaxHealth}")

        -- Update and show the stats label with the new information
        tarStatsLabel:echo(getTarInfoText())

        -- Ensure all elements are shown
        tarPowerGauge:show()
    else
        -- Hide all elements if MaxHealth is <= 0
        tarStatsLabel:clear()
        tarPowerGauge:hide()
    end
end

-- Update on the tick
registerNamedEventHandler("__PKGNAME__", "updateTargetInfo", "CK.tick", updateTargetInfo)