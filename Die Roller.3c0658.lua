colorSide = "blue"
----#include TTS_armada/src/dieRoller/dieRoller
SCRIPT = "function onDestroy() dieRollerInfo = Global.getTable('dieRollerInfo') dieRoller = getObjectFromGUID(dieRollerInfo."..colorSide.."DieRollerGUID) dieRoller.call('waitToUpdate') end function onDrop()  dieRollerInfo = Global.getTable('dieRollerInfo') dieRoller = getObjectFromGUID(dieRollerInfo."..colorSide.."DieRollerGUID) dieRoller.call('waitToUpdate') end"
function onLoad(save_state)
    self.interactable = false
    -- colorSide = "red"
    dieRollerInfo = Global.getTable("dieRollerInfo")
    dieRollerZone = getObjectFromGUID(dieRollerInfo.dieRollerZone[colorSide])
    dieCount = 0

    -- dieValues
    dieIndex = {}
    dieIndex.hit = 0
    dieIndex.crit = 1
    dieIndex.acc = 2

    dieNames = {"hit","crit","acc"}

    self.createButton({
        click_function = "dud", function_owner = self, label = "", position = {-3.12, 0.52, 1.39}, rotation = {0, -90, 0}, scale = {0.5, 0.5, 0.5}, width = 400, height = 400, font_size = 450, color = {1, 1, 1, 0.01}, font_color = {1, 0, 0, 100}, tooltip = "1", alignment = 3})

    self.createButton({
        click_function = "dud", function_owner = self, label = "", position = {-3.12, 0.52, -0.12}, rotation = {0, -90, 0}, scale = {0.5, 0.5, 0.5}, width = 400, height = 400, font_size = 450, color = {1, 1, 1, 0.01}, font_color = {1, 0, 0, 100}, tooltip = "2", alignment = 3})

    self.createButton({
        click_function = "dud", function_owner = self, label = "", position = {-3.12, 0.52, -1.63}, rotation = {0, -90, 0}, scale = {0.5, 0.5, 0.5}, width = 400, height = 400, font_size = 450, color = {1, 1, 1, 0.01}, font_color = {1, 0, 0, 100}, tooltip = "3", alignment = 3})

    createDieTimer(0.5)
end

function dud()
end

function rollDie()
    -- if dieObjs != nil then
    for i, obj in pairs(dieRollerZone.getObjects()) do --dieObjs
        if obj != nil then
            obj.roll()
        end
    end
    -- end
end

function createDieTimer(timerDelay)
    local timerCounter = Global.getVar("timerCounter")
    timerCounter = timerCounter + 1
    Global.setVar("timerCounter", timerCounter)
    Timer.create({
        identifier     = "rollDie".. timerCounter,
        function_name  = "printDieValues",
        function_owner = self,
        delay          = timerDelay,
        repetitions    = 0
    })

end
function getDieColor(obj)
    local dieColor = obj.getVar("dieColor")
    if dieColor==nil then
        custom = obj.getCustomObject()
        isDie = (custom~=nil and custom.image ~=nil)
        if isDie then
            obj.setVar("dieColor",DIE_COLORS[custom.image])
        end
        dieColor = obj.getVar("dieColor")
    end
    return dieColor
end
function printDieValues()
    local dieRecord = {}
    dieRecord.hit = 0
    dieRecord.crit = 0
    dieRecord.acc = 0
    local zoneObjs = dieRollerZone.getObjects()
    if zoneObjs != nil then
        for i, obj in pairs(zoneObjs) do
            if obj != nil then
                local sDieValue = obj.getValue()
                if sDieValue~=nil then
                    local sDieColor = getDieColor(obj) --obj.getVar("dieColor")
                    if sDieColor ~=nil then
                        local sDieResult = dieRollerInfo.dieValues[sDieColor][sDieValue]
                        if sDieResult == nil then
                            print(tostring(sDieColor)..tostring(sDieValue))
                        end
                        for _,icon in pairs(sDieResult) do
                            dieRecord[icon] = dieRecord[icon] + 1
                        end
                    end
                end
            end
        end
    end

    for i, v in pairs(dieNames) do
        if dieRecord[v] == 0 then
            d = ""
        else
            d = dieRecord[v]
        end


        self.editButton({
            index          = dieIndex[v],
            label          = d
        })

    end

end

function spawnBlackAttackDice()
    spawnDie("black")
end

function spawnBlueAttackDice()
    spawnDie("blue")
end

function spawnRedAttackDice()
    spawnDie("red")
end


dieObjs = {}
dieGuidCache = {}
function spawnDie(dieColor)

    if dieObjs == nil then
        dieObjs = {}
        dieGuidCache = {}
    else
        for i, obj in pairs(dieObjs) do
            dieCount = i
            if obj == nil then
                dieCount = i - 1
                break
            end
        end
    end

    if dieCount < 25 then
        dieCount = dieCount + 1

        local rot = self.getRotation()
        local pos = self.getPosition()

        local c = dieRollerInfo.diePos[dieCount].c
        local q = dieRollerInfo.diePos[dieCount].q

        local a = c * math.cos(math.rad(q + rot.y))
        local b = c * math.sin(math.rad(q + rot.y))

        pos.x = pos.x + a
        pos.z = pos.z - b
        pos.y = 3

        local dieBag = getObjectFromGUID(dieRollerInfo[dieColor .. "BagGUID"])

        diceRot = {326.26, 1.20, 89.99}

        dieObjs[dieCount] = dieBag.takeObject({
            position = pos,
            rotation = diceRot
        })
        dieGuidCache[dieObjs[dieCount].getGUID()] = dieObjs[dieCount]

        dieObjs[dieCount].setPosition(pos)
        dieObjs[dieCount].setLuaScript(SCRIPT)

        dieObjs[dieCount].setVar("dieColor", dieColor)

        updateDieCountDisplay()
    end
end

function clearDie()
    dieCount = 0
    dieObjs = {}
    -- if dieObjs != nil then
    --     for i, obj in pairs(dieObjs) do
    --         if obj != nil then
    --             destroyObject(obj)
    --         end
    --     end
    --     dieObjs = nil
    --     dieCount = 0
    -- end

    local zoneObjs = dieRollerZone.getObjects()

    for _,obj in pairs(zoneObjs) do
        if obj != self then
            destroyObject(obj)
        end
    end
end
RED_DIFFUSE = "http://i.imgur.com/MmwVdPY.jpg"
BLUE_DIFFUSE = "http://i.imgur.com/iMYTEPL.jpg"
BLACK_DIFFUSE = "http://i.imgur.com/1VkLvkX.jpg"
DIE_COLORS = {}
DIE_COLORS["http://i.imgur.com/MmwVdPY.jpg"] = "red"
DIE_COLORS["http://i.imgur.com/iMYTEPL.jpg"] = "blue"
DIE_COLORS["http://i.imgur.com/1VkLvkX.jpg"] = "black"

function updateDieCountDisplay()
    dieColorCount = {}
    dieColorCount.black = 0
    dieColorCount.blue = 0
    dieColorCount.red = 0

    if dieRollerZone==nil then
        return
    end
    local zoneObjs = dieRollerZone.getObjects()
    for _,newObj in pairs(zoneObjs) do
        if newObj != self and newObj~=nil then
            if dieGuidCache[newObj.getGUID()]==nil then
                -- print("Found something new?")
                custom = newObj.getCustomObject()
                isDie = (custom~=nil and custom.image ~=nil)
                if isDie then
                    newObj.setVar("dieColor",DIE_COLORS[custom.image])
                    newObj.setLuaScript(SCRIPT)
                    -- print("setting color to: "..DIE_COLORS[custom.image])
                    for i, dieObj in pairs(dieObjs) do
                        dieCount = i
                        if dieObj == nil then
                            dieCount = dieCount - 1
                            break
                        end
                    end
                    dieCount = dieCount + 1
                    -- print("putting at index: "..tostring(dieCount))
                    dieObjs[dieCount] = newObj
                    dieGuidCache[newObj.getGUID()] = newObj
                end
            end
        end
    end

    if zoneObjs != nil then
        for i, obj in pairs(zoneObjs) do
            if obj != nil then
                local selectedColor = getDieColor(obj) --obj.getVar("dieColor")
                if dieColorCount[selectedColor]~=nil then
                    dieColorCount[selectedColor] = dieColorCount[selectedColor] + 1
                end
            end
        end
    end



    updateButtonDisplay(dieRollerInfo.buttonInfo[colorSide.."Player"].blackAttackButtonGUID,"black")
    updateButtonDisplay(dieRollerInfo.buttonInfo[colorSide.."Player"].blueAttackButtonGUID,"blue")
    updateButtonDisplay(dieRollerInfo.buttonInfo[colorSide.."Player"].redAttackButtonGUID,"red")

end
--on collision is a bad idea
function onCollisionEnter(collision_info)
    updateDieCountDisplay()
end

function waitToUpdate()
    local timerCounter = Global.getVar("timerCounter")
    timerCounter = timerCounter + 1
    Global.setVar("timerCounter", timerCounter)

    Timer.create({
        identifier     = "DieRoller"..timerCounter,
        function_name  = "updateDieCountDisplay",
        function_owner = self,
        delay          = 0.1
    })
end

function updateButtonDisplay(buttonGUID,diceColor)
    buttonObj = getObjectFromGUID(buttonGUID)

    local data = buttonObj.getTable("data")
    if dieColorCount[diceColor] != 0 then
        data.label = dieColorCount[diceColor]
    else
        data.label = ""
    end

    buttonObj.clearButtons()
    buttonObj.createButton(data)
end

function clearButtonDisplay(buttonGUID,diceColor)
    buttonObj = getObjectFromGUID(buttonGUID)

    local data = buttonObj.getTable("data")
    data.label = ""

    buttonObj.clearButtons()
    buttonObj.createButton(data)
end

----#include TTS_armada/src/dieRoller/dieRoller