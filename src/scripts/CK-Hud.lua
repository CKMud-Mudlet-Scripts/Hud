local ck = require("CK")
ck:register("__PKGNAME__", "__VERSION__")
local hud = ck:get_table("hud", {
    bottomPanelHeight = 10,
    rightPanelWidth = 40,
    adjusted_once = false
})
local chat = ck:get_table("chat")
local map = ck:get_table("map")
ck:define_feature("hud.vertical", false)
ck:define_feature("hud.free_form", false)

local function our_right_border()
    if ck:feature("hud.vertical") then
        return 0
    end
    return 40
end

hud.bottomBar = Geyser.Container:new({
    name = "BottomBar",
    x = "0%",
    y = (100 - hud.bottomPanelHeight) .. "%",
    width = "100%",
    height = hud.bottomPanelHeight .. "%"
})
hud.bottomBarBackground = Geyser.Label:new({
    name = "BottomBarBackground",
    x = "0%",
    y = "0%",
    width = "100%",
    height = "100%"
}, hud.bottomBar)
hud.bottomBarBackground:setStyleSheet([[
  background-color: rgba(0, 0, 0, 0%);
  border: 2px solid green;
  pointer-events: none;
]])

function hud:setborders()
    setBorderSizes(-1, -1, -1, -1)

    local bottom = hud.bottomBar:get_height()
    local top, right
    if ck:feature("hud.vertical") then
        top = math.floor(chat.container:get_height())
        right = 0
    else
        right = math.floor(chat.container:get_width())
        top = 0
    end
    setBorderSizes(top, right, bottom, 0)
end

function hud:adjustLayout()
    hud:movechat()
    hud:movemap()
    if ck:feature("hud.vertical") then
        hud.bottomBar:resize("100%", "10%")
        hud.bottomBarBackground:resize("100%", "100%")
    else
        local border = 100 - our_right_border()
        hud.bottomBar:resize(f("{border}%"), "10%")
        hud.bottomBarBackground:resize("100%", "100%")
    end
    hud.adjusted_once = true
end

hud:setborders()

function hud:moveContainersToBackground()
    hud.bottomBar:lower()
end

function hud:hidePanels()
    hud.bottomBar:hide()
end

hud:moveContainersToBackground()
hud:hidePanels()

registerNamedEventHandler("__PKGNAME__", "Resize Hud on Mudlet Resize", "sysWindowResizeEvent", function(event, x, y)
    raiseEvent("__PKGNAME__.resize")
    hud.adjusted_once = false
end)

function hud:movechat()
    if ck:feature("hud.free_form") then
        return
    end
    local x, y, w, h
    if not ck:feature("hud.vertical") then
        x = 100 - our_right_border()
        y = 30
        w = our_right_border()
        h = 70
    else
        x = 0
        y = 0
        w = 60
        h = 20
    end
    if chat.container then
        chat.container:move(f("{x}%"), f("{y}%"))
        chat.container:resize(f("{w}%"), f("{h}%"))
        chat.container:raise()
    end
end

function hud:movemap()
    if ck:feature("hud.free_form") then
        return
    end
    local x, y, w, h
    if not ck:feature("hud.vertical") then
        x = 100 - our_right_border()
        y = 0
        w = our_right_border()
        h = 70
    else
        x = 60
        y = 0
        w = 40
        h = 20
    end
    if map.container then
        map.container:move(f("{x}%"), f("{y}%"))
        map.container:resize(f("{w}%"), f("{h}%"))
        map.container:raise()
    end
end

local function adjust_once()
    if not hud.adjusted_once then
        hud:adjustLayout()
    end
    hud:setborders()
end

registerNamedEventHandler("__PKGNAME__", "Move the chat/map windows", "CK.tick", adjust_once)
registerNamedEventHandler("__PKGNAME__", "Adjust on feature swap", "CK.Feature",
    function(event, name, value)
        if name == "hud.vertical" then
            hud:adjustLayout()
            hud:setborders()
        end
    end
)
registerNamedEventHandler("__PKGNAME__", "Set Font for Wide Map", "CK.chat:wide-draw",
    function()
        if ck:feature("hud.vertical") then
            map.console:setFontSize(9)
        else
            map.console:setFontSize(14)
        end
    end
)
registerNamedEventHandler("__PKGNAME__", "Set Font for Narrow Map", "CK.chat:narrow-draw",
    function()
        if ck:feature("hud.vertical") then
            map.console:setFontSize(13)
        else
            map.console:setFontSize(18)
        end
    end
)
