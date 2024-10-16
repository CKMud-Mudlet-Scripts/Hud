local ck = require("CK")
ck:register("__PKGNAME__", "__VERSION__")


local hud = ck:get_table("hud", {rightPanelWidth=40, bottomPanelHeight = 10, adjusted_once=false})
local chat = ck:get_table("chat")
local map = ck:get_table("map")


hud.rightPanel = Geyser.Container:new({
    name = "RightPanel",
    x = (100 - hud.rightPanelWidth).."%",
    y = "0%",
    width = hud.rightPanelWidth.."%",  
    height = "100%", 
})

hud.rightPanelBackground = Geyser.Label:new({
    name = "RightPanelBackground",
    x = "0%",
    y = "0%",
    width = "100%",
    height = "100%",
}, hud.rightPanel)

hud.rightPanelBackground:setStyleSheet([[
  background-color: rgba(0, 0, 0, 0);   
  border: none;                         
  pointer-events: none;                 
]])

hud.bottomBar = Geyser.Container:new({
    name = "BottomBar",
    x = "0%", 
    y = (100 - hud.bottomPanelHeight).."%", 
    width = (100 - hud.rightPanelWidth).."%", 
    height = hud.bottomPanelHeight.."%", 
})

hud.bottomBarBackground = Geyser.Label:new({
    name = "BottomBarBackground",
    x = "0%",
    y = "0%",
    width = "100%",
    height = "100%",
}, hud.bottomBar) 

hud.bottomBarBackground:setStyleSheet([[
  background-color: rgba(0, 0, 0, 0%);
  border: 2px solid green;
  pointer-events: none;                 
]])

setBorderRight(hud.rightPanel:get_width())
setBorderBottom(hud.bottomBar:get_height())

function hud:adjustLayout()
    local newRightBorder = math.floor(hud.rightPanel:get_width())
    local newBottomBorder = math.floor(hud.bottomBar:get_height())
    setBorderRight(newRightBorder)  
    setBorderBottom(newBottomBorder)
    hud:movechat()
    hud:movemap()
    hud.adjusted_once = true
end

function hud:moveContainersToBackground()
    hud.rightPanel:lower()  
    hud.bottomBar:lower()   
end

function hud:hidePanels()
    hud.rightPanel:hide()
    hud.bottomBar:hide()
end

hud:moveContainersToBackground()
hud:hidePanels()
registerNamedEventHandler("__PKGNAME__", "Resize Hud on Mudlet Resize", "sysWindowResizeEvent",
    function() 
        hud:adjustLayout()
    end
)

function hud:movechat()
    if chat.container then
        chat.container:move((100 - hud.rightPanelWidth).."%", "50%")    -- Move to x = 60%, y = 50%
        chat.container:resize(hud.rightPanelWidth.."%", "50%")  -- Resize to width = 40%, height = 50%
    end
end

function hud:movemap()
    if map.container then
        map.container:move((100 - hud.rightPanelWidth).."%", "0%")     -- Move to x = 60%, y = 0%
        map.container:resize(hud.rightPanelWidth.."%", "50%") -- Resize to width = 40%, height = 100%
        map.container:raise()               -- Bring the container to the front
    end
end

local function adjust_once()
    if not hud.adjusted_once then
        hud:adjustLayout()
    end
end

registerNamedEventHandler("__PKGNAME__", "Move the chat/map windows", "CK.tick", adjust_once
)