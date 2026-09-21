local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer

local AnimForce = {
    Enabled = true,
    SpeedMult = 2.0,
    PoseFreeze = false,
    Conn = nil
}

local function onRender()
    if not AnimForce.Enabled then return end
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    local tracks = animator:GetPlayingAnimationTracks()
    for i = 1, #tracks do
        local track = tracks[i]
        if track and track.IsPlaying then
            if AnimForce.PoseFreeze then
                track:AdjustSpeed(0)
            else
                track:AdjustSpeed(AnimForce.SpeedMult)
            end
        end
    end
end

AnimForce.Conn = RunService.RenderStepped:Connect(onRender)

function AnimForce:Unload()
    if AnimForce.Conn then
        AnimForce.Conn:Disconnect()
        AnimForce.Conn = nil
    end
    AnimForce.Enabled = false
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local animator = hum and hum:FindFirstChildOfClass("Animator")
    if animator then
        local tracks = animator:GetPlayingAnimationTracks()
        for i = 1, #tracks do
            tracks[i]:AdjustSpeed(1.0)
        end
    end
end

function AnimForce.Settings(sub)
    sub:CreateToggle({
        Name = "Enabled",
        Default = AnimForce.Enabled,
        Callback = function(enabled)
            AnimForce.Enabled = enabled
        end
    })

    sub:CreateSlider({
        Name = "Speed Multiplier",
        Min = 0.1,
        Max = 10,
        Default = AnimForce.SpeedMult,
        Step = 0.1,
        Decimals = 1,
        Callback = function(val)
            AnimForce.SpeedMult = val
        end
    })

    sub:CreateToggle({
        Name = "Freeze Pose",
        Default = AnimForce.PoseFreeze,
        Callback = function(enabled)
            AnimForce.PoseFreeze = enabled
        end
    })
end

return AnimForce
