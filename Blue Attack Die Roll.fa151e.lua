colorSide = "blue"
btn = {label = "ROLL",
    color = {0.7573, 0.7573, 0.7573, 0.01},
    font_color = {0,0,0,100},
    tooltip = "Roll Die",
    scale = {1,1,0.5},
    width = 1400,
    height = 2800,
    font_size = 500}
dieRollerFunction = "rollDie"
----#include TTS_armada/src/dieRoller/diceButton
--Runs on load, creates button and makes sure the lockout is off
function onload()
    if colorSide == nil then
        print("MUST SET colorSide VARIABLE ON BUTTON BEFORE #include")
    end
    if btn==nil then
        btn = {}
    end
    self.interactable = false
    data = {click_function = "buttonPress", function_owner = self, label = btn.label or "",
    position = {0, 0.65, 0}, scale = btn.scale or {1,1,1},  width = btn.width or 1400, height = btn.height or 1400, font_size = btn.font_size or 1100, color = btn.color or {1,1,1,0.01},
    font_color = btn.font_color or {1,1,1,100}, tooltip = btn.tooltip or "", alignment = 3}

    self.createButton(data)
    dieRollerInfo = Global.getTable("dieRollerInfo")
    dieRoller = getObjectFromGUID(dieRollerInfo[colorSide.."DieRollerGUID"])
end


function buttonPress()
    if dieRollerFunction == nil then
        print("MUST SET dieRollerFunction VARIABLE ON BUTTON BEFORE #include")
        return
    end
    self.AssetBundle.playTriggerEffect(0) --triggers animation/sound
    dieRoller.call(dieRollerFunction)
end
 

----#include TTS_armada/src/dieRoller/diceButton