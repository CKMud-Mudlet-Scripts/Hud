local ck = require("CK")
ck:register("__PKGNAME__", "__VERSION__")

local hud = ck:get_table("hud", {
    rightPanelWidth = 40,
    topPanelHeight = 20,
    bottomPanelHeight = 10,
    adjusted_once = false
})
local chat = ck:get_table("chat")
local map = ck:get_table("map")

ck:define_feature("hud.vertical", false)

if not ck:feature("hud.vertical") then

    hud.rightPanel = Geyser.Container:new({
        name = "RightPanel",
        x = (100 - hud.rightPanelWidth) .. "%",
        y = "0%",
        width = hud.rightPanelWidth .. "%",
        height = "100%"
    })

    hud.rightPanelBackground = Geyser.Label:new({
        name = "RightPanelBackground",
        x = "0%",
        y = "0%",
        width = "100%",
        height = "100%"
    }, hud.rightPanel)

    hud.rightPanelBackground:setStyleSheet([[
      background-color: rgba(0, 0, 0, 0);   
      border: none;                         
      pointer-events: none;                 
    ]])
    setBorderRight(hud.rightPanel:get_width())
else
    hub.rightPanelWidth = 0
    hud.topPanel = Geyser.Container:new({
        name = "TopPanel",
        x = "0%",
        y = "0%",
        width = "100%",
        height = (100 - hud.topPanelHeight) .. "%"
    })

    hud.topPanelBackground = Geyser.Label:new({
        name = "TopPanelBackground",
        x = "0%",
        y = "0%",
        width = "100%",
        height = "100%"
    }, hud.topPanel)

    hud.topPanelBackground:setStyleSheet([[
      background-color: rgba(0, 0, 0, 0);   
      border: none;                         
      pointer-events: none;                 
    ]])
    setBorderTop(hud.topPanel:get_width())
end

hud.bottomBar = Geyser.Container:new({
    name = "BottomBar",
    x = "0%",
    y = (100 - hud.bottomPanelHeight) .. "%",
    width = (100 - hud.rightPanelWidth) .. "%",
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

setBorderBottom(hud.bottomBar:get_height())

function hud:adjustLayout()
    if not ck:feature("hud.vertical") then
        local newRightBorder = math.floor(hud.rightPanel:get_width())
        setBorderRight(newRightBorder)
    else
        local newTopBorder = math.floor(hud.topPanel:get_height())
        setBorderTop(newTopBorder)
    end
    local newBottomBorder = math.floor(hud.bottomBar:get_height())
    setBorderBottom(newBottomBorder)
    hud:movechat()
    hud:movemap()
    hud.adjusted_once = true
end

function hud:moveContainersToBackground()
    if not ck:feature("hud.vertical") then
        hud.rightPanel:lower()
    else
        hud.topPanel:lower()
    end
    hud.bottomBar:lower()
end

function hud:hidePanels()
    if not ck:feature("hud.vertical") then
        hud.rightPanel:hide()
    else
        hud.topPanel:hide()
    end
    hud.bottomBar:hide()
end

hud:moveContainersToBackground()
hud:hidePanels()
registerNamedEventHandler("__PKGNAME__", "Resize Hud on Mudlet Resize", "sysWindowResizeEvent", function()
    hud:adjustLayout()
end)

function hud:movechat()
    local x, y, w, h
    if not ck:feature("hud.vertical") then
        x = 100 - hud.rightPanelWidth
        y = 50
        w = hud.rightPanelWidth
        h = 50
    else
        x = 0
        y = 0
        w = 60
        h = 100
    end
    if chat.container then
        chat.container:move(f "{x}%", f "{y}%")
        chat.container:resize(f "{w}%", f "{h}%")
        chat.container:raise()
    end
end

function hud:movemap()
    local x, y, w, h
    if not ck:feature("hud.vertical") then
        x = 100 - hud.rightPanelWidth
        y = 0
        w = hud.rightPanelWidth
        h = 50
    else
        x = 60
        y = 0
        w = 40
        h = 100
    end
    if map.container then
        map.container:move(f "{x}%", f "{y}%")
        map.container:resize(f "{w}%", f "{h}%")
        map.container:raise()
    end
end

local function adjust_once()
    if not hud.adjusted_once then
        hud:adjustLayout()
    end
end

registerNamedEventHandler("__PKGNAME__", "Move the chat/map windows", "CK.tick", adjust_once)
