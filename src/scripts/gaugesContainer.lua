local ck = require("CK")
local Player = ck:get_table("Player")
local API = ck:get_table("API")
local Toggles = ck:get_table("Toggles")
local hud = ck:get_table("hud")

local gaugesContainer = Geyser.Container:new({
    name = "gaugesContainer",
    x = "0%",
    y = "90%",
    width = "15%",
    height = "10%"
}, hud.BottomBar)

local borderLabel = Geyser.Label:new({
    name = "gaugesBorderLabel",
    x = "0%",
    y = "90%",
    width = "15%",
    height = "10%"
}, hud.BottomBar)

borderLabel:setStyleSheet([[
    border: 4px double green;
    background-color: rgba(0, 0, 0, 0);
]])

local bars = {}

local function createAllBars()
    bars["powerGauge"] = Geyser.Gauge:new({
        name = "powerGauge",
        x = "0%",
        y = "0%",
        width = "100%",
        height = "20%"
    }, gaugesContainer)
    bars["powerGauge"]:setText(f "Powerlevel: {Player.PL} / {Player.MaxPL}")
    bars["powerGauge"]:setValue(999, 9999)
    bars["powerGauge"]:setAlignment("c")
    bars["powerGauge"]:setStyleSheet([[background-color: rgb(0, 128, 0);]])
    bars["powerGauge"].back:setStyleSheet("background-color: black;")

    bars["kiGauge"] = Geyser.Gauge:new({
        name = "kiGauge",
        x = "0%",
        y = "0%",
        width = "100%",
        height = "20%"
    }, gaugesContainer)
    bars["kiGauge"]:setText(f "Ki: {Player.Ki} / {Player.MaxKi}")
    bars["kiGauge"]:setAlignment("c")
    bars["kiGauge"]:setValue(999, 9999)
    bars["kiGauge"]:setStyleSheet([[background-color: rgb(0, 0, 139);]])
    bars["kiGauge"].back:setStyleSheet("background-color: black;")

    bars["fatigueGauge"] = Geyser.Gauge:new({
        name = "fatigueGauge",
        x = "0%",
        y = "0%",
        width = "100%",
        height = "20%"
    }, gaugesContainer)
    bars["fatigueGauge"]:setText(f "Fatigue: {Player.Fatigue} / {Player.MaxFatigue}")
    bars["fatigueGauge"]:setAlignment("c")
    bars["fatigueGauge"]:setValue(999, 9999)
    bars["fatigueGauge"]:setStyleSheet([[background-color: rgb(255, 140, 0);]])
    bars["fatigueGauge"].back:setStyleSheet("background-color: black;")

    bars["heatGauge"] = Geyser.Gauge:new({
        name = "heatGauge",
        x = "0%",
        y = "0%",
        width = "100%",
        height = "20%"
    }, gaugesContainer)
    bars["heatGauge"]:setText(f "Heat: {Player.Ki} / {Player.MaxKi}")
    bars["heatGauge"]:setAlignment("c")
    bars["heatGauge"]:setValue(999, 9999)
    bars["heatGauge"]:setStyleSheet([[background-color: rgb(178, 34, 34);]])
    bars["heatGauge"].back:setStyleSheet("background-color: black;")

    bars["biomassGauge"] = Geyser.Gauge:new({
        name = "biomassGauge",
        x = "0%",
        y = "0%",
        width = "100%",
        height = "20%"
    }, gaugesContainer)
    bars["biomassGauge"]:setText(f "Biomass: {Player.Ki} / {Player.MaxKi}")
    bars["biomassGauge"]:setAlignment("c")
    bars["biomassGauge"]:setValue(999, 9999)
    bars["biomassGauge"]:setStyleSheet([[background-color: rgb(0, 128, 0);]])
    bars["biomassGauge"].back:setStyleSheet("background-color: black;")

    bars["godKiGauge"] = Geyser.Gauge:new({
        name = "godKiGauge",
        x = "0%",
        y = "0%",
        width = "100%",
        height = "20%"
    }, gaugesContainer)
    bars["godKiGauge"]:setText(f "God Ki: {Player.GK} / {Player.MaxGK}")
    bars["godKiGauge"]:setAlignment("c")
    bars["godKiGauge"]:setValue(0, 1)
    bars["godKiGauge"]:setStyleSheet([[background-color: rgb(218, 165, 32);]])
    bars["godKiGauge"].back:setStyleSheet("background-color: black;")

    bars["darkEnergyGauge"] = Geyser.Gauge:new({
        name = "darkEnergyGauge",
        x = "0%",
        y = "0%",
        width = "100%",
        height = "20%"
    }, gaugesContainer)
    bars["darkEnergyGauge"]:setText(f "Dark Energy: {Player.DarkEnergy} / 3600")
    bars["darkEnergyGauge"]:setAlignment("c")
    bars["darkEnergyGauge"]:setValue(0, 100)
    bars["darkEnergyGauge"]:setStyleSheet([[background-color: rgb(75, 0, 130);]])
    bars["darkEnergyGauge"].back:setStyleSheet("background-color: black;")

    for _, bar in pairs(bars) do
        bar:hide()
    end
end

createAllBars()

local function configureBars(race)
    for _, bar in pairs(bars) do
        bar:hide()
    end

    -- Everyone gets at least two. 

    local count = 2
    if API:has_fatigue(race) then
        count = count + 1
    end

    if Player.MaxGK > 0 then
        count = count + 1
    end

    if race == "Demon" then
        count = count + 1
    end

    local size = math.floor(100 / count)
    local pos = 0

    local function get_pos()
        local prev = pos
        pos = pos + size
        return prev .. "%"
    end

    bars["powerGauge"]:show()
    bars["powerGauge"]:resize("100%", size .. "%")
    bars["powerGauge"]:move("0%", get_pos())

    if API:has_fatigue(race) then
        bars["kiGauge"]:show()
        bars["kiGauge"]:resize("100%", size .. "%")
        bars["kiGauge"]:move("0%", get_pos())

        bars["fatigueGauge"]:show()
        bars["fatigueGauge"]:resize("100%", size .. "%")
        bars["fatigueGauge"]:move("0%", get_pos())
    elseif API:isAndroid(race) then
        bars["heatGauge"]:show()
        bars["heatGauge"]:resize("100%", size .. "%")
        bars["heatGauge"]:move("0%", get_pos())
    elseif API:isBioDroid(race) then
        bars["biomassGauge"]:show()
        bars["biomassGauge"]:resize("100%", size .. "%")
        bars["biomassGauge"]:move("0%", get_pos())
    end

    if race == "Demon" then
        bars["darkEnergyGauge"]:show()
        bars["darkEnergyGauge"]:resize("100%", size .. "%")
        bars["darkEnergyGauge"]:move("0%", get_pos())
    end

    if Player.MaxGK > 0 then
        bars["godKiGauge"]:show()
        bars["godKiGauge"]:resize("100%", size .. "%")
        bars["godKiGauge"]:move("0%", get_pos())
    end
end

local function configureBarsByRace()
    local race = API:getRace()
    configureBars(race)
end

-- Only if msdp has ticked
if Toggles.ticked_once then
    configureBarsByRace()
end

local function getPowerlevelColor(percentage)
    local r, g, b

    if percentage >= 85 then
        r = 0
        g = 100
        b = 0
    elseif percentage >= 50 then
        local ratio = (percentage - 50) / 35
        r = math.floor(204 * (1 - ratio))
        g = 100 + math.floor((204 - 100) * ratio)
        b = 0
    elseif percentage >= 15 then
        local ratio = (percentage - 15) / 35
        r = 204 - math.floor((204 - 139) * ratio)
        g = 204 - math.floor((204 - 0) * ratio)
        b = 0
    else
        r = 139
        g = 0
        b = 0
    end

    return string.format("rgb(%d, %d, %d)", r, g, b)
end

local function updateGauges()
    local powerPercentage = math.floor(math.min(math.max((Player.Pl / Player.MaxPl) * 100, 0), 100))
    local color = getPowerlevelColor(powerPercentage)
    local race = API:getRace()

    bars["powerGauge"]:setStyleSheet([[background-color: ]] .. color .. [[;]])
    bars["powerGauge"].back:setStyleSheet([[background-color: black;]])
    bars["powerGauge"]:setValue(powerPercentage)
    bars["powerGauge"]:setText(
        "<b>PL: " .. math.format(Player.Pl) .. " / " .. math.format(Player.MaxPl) .. " ( " ..
            tostring(math.floor((Player.Pl / Player.MaxPl) * 100)) .. "% )</b>")

    if API:has_fatigue(race) then
        bars["kiGauge"]:setText("<b>Ki: " .. math.format(Player.Ki) .. " / " ..
                                    math.format(Player.MaxKi) .. " ( " ..
                                    tostring(math.floor((Player.Ki / Player.MaxKi) * 100)) .. "% )</b>")
        bars["kiGauge"]:setValue(math.min(math.max(Player.Ki, 0), Player.MaxKi), Player.MaxKi)
        bars["fatigueGauge"]:setText("<b>Fatigue: " .. math.format(Player.Fatigue) .. " / " ..
                                         math.format(Player.MaxFatigue) .. " ( " ..
                                         tostring(math.floor((Player.Fatigue / Player.MaxFatigue) * 100)) ..
                                         "% )</b>")
        bars["fatigueGauge"]:setValue(math.min(math.max(Player.Fatigue, 0), Player.MaxFatigue),
            Player.MaxFatigue)
    elseif API:isAndroid(race) then
        bars["heatGauge"]:setText("<b>Heat: " .. math.format(Player.Ki) .. " / " ..
                                      math.format(Player.MaxKi) .. " ( " ..
                                      tostring(math.floor((Player.Ki / Player.MaxKi) * 100)) .. "% )</b>")
        bars["heatGauge"]:setValue(math.max(math.min(Player.MaxKi - Player.Ki, Player.MaxKi), 0),
            Player.MaxKi)
    elseif API:isBioDroid(race) then
        bars["biomassGauge"]:setText("<b>Biomass: " .. math.format(Player.Ki) .. " / " ..
                                         math.format(Player.MaxKi) .. " ( " ..
                                         tostring(math.floor((Player.Ki / Player.MaxKi) * 100)) .. "% )</b>")
        bars["biomassGauge"]:setValue(math.min(math.max(Player.Ki, 0), Player.MaxKi), Player.MaxKi)
    end

    if Player.MaxGK > 0 then
        bars["godKiGauge"]:setValue(math.min(math.max(Player.GK, 0), Player.MaxGK), Player.MaxGK)
        bars["godKiGauge"]:setText("<b>God Ki: " .. math.format(Player.GK) .. " / " ..
                                       math.format(Player.MaxGK) .. " ( " ..
                                       tostring(math.floor((Player.GK / Player.MaxGK) * 100)) .. "% )</b>")
    end

    if race == "Demon" then
        bars["darkEnergyGauge"]:setText("<b>Dark Energy: " .. math.format(Player.DarkEnergy) .. " / 1000 ( " ..
                                            tostring(math.floor((Player.DarkEnergy / 1000) * 100)) .. "% )</b>")
        bars["darkEnergyGauge"]:setValue(math.max(math.min(Player.DarkEnergy, 1000), 0), 1000)
    end
end

-- Update on the tick
registerNamedEventHandler("__PKGNAME__", "updateGauges", "CK.tick", updateGauges)
