local ck = require("CK")
local Player = ck:get_table("Player")
local Target = ck:get_table("Target")
local API = ck:get_table("API")
local hud = ck:get_table("hud")

local gaugeContainer = Geyser.Container:new({
    name = "gaugeContainer",
    x = "45%",
    y = "90%",
    width = "15%",
    height = "3%"
}, hud.BottomBar)

local targetInfoContainer = Geyser.Container:new({
    name = "targetInfoContainer",
    x = "46%",
    y = "93%",
    width = "13%",
    height = "7%"
}, hud.BottomBar)

local targetBorderLabel = Geyser.Label:new({
    name = "targetBorderLabel",
    x = "45%",
    y = "90%",
    width = "15%",
    height = "10%"
}, hud.BottomBar)

targetBorderLabel:setStyleSheet([[
    border: 4px double green;
    background-color: rgba(0, 0, 0, 0);
]])

targetBorderLabel:raise()

local bars = {}

local function createBar()
    bars["tarPowerGauge"] = Geyser.Gauge:new({
        name = "tarPowerGauge",
        x = "0%",
        y = "0%",
        width = "100%",
        height = "100%"
    }, gaugeContainer)

    bars["tarPowerGauge"]:setText(f "Health: {Target.Health} / {Target.MaxHealth}")
    bars["tarPowerGauge"]:setValue(0, 100)
    bars["tarPowerGauge"]:setAlignment("c")
    bars["tarPowerGauge"]:setStyleSheet([[background-color: rgb(0, 128, 0);]])
    bars["tarPowerGauge"].back:setStyleSheet("background-color: black;")
end

createBar()

local tarStatsLabel = Geyser.Label:new({
    name = "tarStatsLabel",
    x = "0%",
    y = "0%",
    width = "100%",
    height = "100%"
}, targetInfoContainer)

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
    if CK.Target.level > 0 then
        -- Update the power gauge
        bars["tarPowerGauge"]:setValue(Target.Health, Target.MaxHealth)
        bars["tarPowerGauge"]:setText(f"Health: {Target.Health} / {Target.MaxHealth}")

        -- Update and show the stats label with the new information
        tarStatsLabel:echo(getTarInfoText())

        -- Ensure all elements are shown
        targetInfoContainer:show()
        gaugeContainer:show()
        targetBorderLabel:show()

    else
        -- Hide all elements if MaxHealth is <= 0
        targetInfoContainer:hide()
        gaugeContainer:hide()
    end
end

-- Update on the tick
registerNamedEventHandler("__PKGNAME__", "updateTargetInfo", "CK.tick", updateTargetInfo)