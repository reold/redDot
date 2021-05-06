local redDot = {}

--vars
local UI = require(game.ReplicatedStorage:WaitForChild("MaterialR"))

local backdrop = script.Parent

--globalvars
redDot.common = {}
redDot.registeredBindings = {}

redDot.whitelist = {
    "!",
}

--utils
function redDot.common.checkIfInArray(array, item)
    for i,v in pairs(array) do
        if v == item then
            return true
        end
    end
    return false
end

--main
function redDot.regBindings(binds)
    redDot.registeredBindings = binds
end

function bindActions(oldObj, newObj)
    if oldObj:IsA("TextButton") then
        newObj.MouseButton1Click:Connect(function()
            redDot.registeredBindings[oldObj:GetAttribute("Onlick")]()
        end)
    end
end

function redDot.dropCommonInss(globalParent)
    local UiCorner = Instance.new("UICorner")
    UiCorner.Name = "ui-corner"
    UiCorner.CornerRadius = UDim.new(0.05, 0)
    UiCorner.Parent = globalParent
end

function transferGuiProps(toIns, fromIns)
    toIns.Parent = fromIns.Parent
    toIns.AnchorPoint = fromIns.AnchorPoint
    toIns.Position = fromIns.Position
    toIns.Size = fromIns.Size
    toIns.Theme = fromIns:GetAttribute("Theme")
end

function redDot.convertToR(obj)

    if obj:IsA("GuiObject") then

        if not redDot.common.checkIfInArray(redDot.whitelist, obj.Name) then

            if obj:IsA("TextButton") then

                local newObj = UI:Get("TextButton")
                pcall(function()
                    transferGuiProps(newObj, obj)
                end)
                newObj.Text = obj.Text
                bindActions(obj, newObj)
                obj:Destroy()

            elseif obj:IsA("TextBox") then

                local newObj = UI:Get("TextBox")
                pcall(function()
                    transferGuiProps(newObj, obj)
                end)
                newObj.PlaceholderText = obj.PlaceholderText
                newObj.Text = obj.Text
                newObj.TextColor3 = obj.TextColor3
                obj:Destroy()

            elseif obj:IsA("Frame") and obj.Name == "switch" then

                local newObj = UI:Get("Switch")
                pcall(function()
                    transferGuiProps(newObj, obj)
                end)
                obj:Destroy()

            elseif obj:IsA("Frame") and obj.Name ~= "switch" then
                redDot.dropCommonInss(obj)
            end
        end
    end
end

function redDot.convertAll(items) 

    for i,v in pairs(items) do

        redDot.convertToR(v)

        if #v:GetChildren() > 0 then
            redDot.convertAll(v:GetChildren())
        end

    end
end

return redDot
