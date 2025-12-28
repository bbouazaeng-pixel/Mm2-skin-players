local Players = game:GetService("Players")
local InsertService = game:GetService("InsertService")
local player = Players.LocalPlayer

if game.PlaceId ~= 142823291 then
    player:Kick("🚫NOT SUPPORT THE MAP UED THIS ON MM2 ONLY")
    return
end

local MAX_FAIL = 25
local FAIL_FILE = "VisualMM2_Fail.txt"
local fails = 0

pcall(function()
    if isfile and isfile(FAIL_FILE) then
        fails = tonumber(readfile(FAIL_FILE)) or 0
    end
end)

if fails >= MAX_FAIL then
    player:Kick("Too many invalid key attempts")
    return
end

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "Visual Mm2 Players Skin By Zurfex",
    KeySystem = true,
    KeySettings = {
        Title = "Key System",
        Subtitle = "Enter Key",
        Note = "Invalid key, join discord to get key",
        SaveKey = true,
        FileName = "VisualMM2_Key",
        GrabKeyFromSite = true,
        GetKey = function()
            if setclipboard then
                setclipboard("https://discord.gg/s2eRwNn4X")
            end
        end,
        Key = {"skin-hub-key"}
    }
})

local function addFail()
    fails = fails + 1
    pcall(function()
        if writefile then
            writefile(FAIL_FILE, tostring(fails))
        end
    end)
    if fails >= MAX_FAIL then
        player:Kick("Too many invalid key attempts")
    end
end

task.delay(1.5, function()
    if not Window then
        addFail()
    end
end)

local function setupChar()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")
    return char, hum, hrp
end

local character, humanoid, hrp = setupChar()

player.CharacterAdded:Connect(function()
    task.wait(1)
    character, humanoid, hrp = setupChar()
end)

local function applyMorph(assetId)
    for _,v in pairs(character:GetChildren()) do
        if v:IsA("Accessory") or v:IsA("Model") then
            v:Destroy()
        end
    end
    local model = InsertService:LoadAsset(assetId)
    local acc = model:GetChildren()[1]
    if not acc then return end
    acc.Parent = character
    local handle = acc:FindFirstChild("Handle") or acc:FindFirstChildWhichIsA("BasePart", true)
    if handle then
        handle.CFrame = hrp.CFrame
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = hrp
        weld.Part1 = handle
        weld.Parent = handle
    end
end

local function applyAnimations(animIds)
    local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
    for _,track in pairs(animator:GetPlayingAnimationTracks()) do
        track:Stop()
        track:Destroy()
    end
    local tracks = {}
    for name,id in pairs(animIds) do
        local anim = Instance.new("Animation")
        anim.AnimationId = id
        tracks[name] = animator:LoadAnimation(anim)
        tracks[name].Priority = Enum.AnimationPriority.Movement
    end
    tracks.Idle:Play()
    humanoid.Running:Connect(function(speed)
        if speed > 10 then
            tracks.Run:Play()
            tracks.Walk:Stop()
            tracks.Idle:Stop()
        elseif speed > 1 then
            tracks.Walk:Play()
            tracks.Run:Stop()
            tracks.Idle:Stop()
        else
            tracks.Idle:Play()
            tracks.Walk:Stop()
            tracks.Run:Stop()
        end
    end)
end

local Tab = Window:CreateTab("Skins", "user")

local AnimSet = {
    Idle = "rbxassetid://6672457045",
    Walk = "rbxassetid://6672457128",
    Run = "rbxassetid://6672457267"
}

Tab:CreateButton({
    Name = "HEATZZE SKIN",
    Callback = function()
        applyMorph(1234567890)
        applyAnimations(AnimSet)
    end
})

Tab:CreateButton({
    Name = "WS10 SKIN",
    Callback = function()
        applyMorph(9876543210)
        applyAnimations(AnimSet)
    end
})