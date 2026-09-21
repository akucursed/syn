local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local AnimForce = {}

local connection = nil
local isEnabled = false

local Config = {
    Speed = 1.0,
    FreezeOnDisable = true,
}

local function applyAnimForce()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        track:AdjustSpeed(Config.Speed)
    end
end

local function stopAnimForce()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end
    if Config.FreezeOnDisable then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:AdjustSpeed(0)
        end
    else
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:AdjustSpeed(1)
        end
    end
end

function AnimForce.Enable()
    if isEnabled then return end
    isEnabled = true
    connection = RunService.Heartbeat:Connect(function()
        if isEnabled then
            applyAnimForce()
        end
    end)
end

function AnimForce.Disable()
    if not isEnabled then return end
    isEnabled = false
    if connection then
        connection:Disconnect()
        connection = nil
    end
    stopAnimForce()
end

function AnimForce.Settings(sub)
    sub:CreateSlider({
        Name = "Animation Speed",
        Flag = "AnimForce_Speed",
        Min = 0,
        Max = 5,
        Default = 1.0,
        Decimals = 1,
        Callback = function(val)
            Config.Speed = val
        end
    })

    sub:CreateToggle({
        Name = "Freeze On Disable",
        Flag = "AnimForce_Freeze",
        Default = true,
        Callback = function(state)
            Config.FreezeOnDisable = state
        end
    })
end

return AnimForce
