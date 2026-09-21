local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer

local AnimForce = {
    Enabled = true,
    SpeedMult = 2.0,
    Conn = nil
}

local function onStepped()
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
            track:AdjustSpeed(AnimForce.SpeedMult)
        end
    end
end

AnimForce.Conn = RunService.RenderStepped:Connect(onStepped)

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

return AnimForce
