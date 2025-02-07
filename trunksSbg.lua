-- Animation data: maps original animation IDs to the replacement animation IDs
local animations = {
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE",  -- M1
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE",  -- M2
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE",  -- M3
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE",  -- M4
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE",  -- Upslash
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE",  -- Downslam
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE",  -- Move 1
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE",  -- Move 2
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE",  -- Move 3
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE",  -- Move 4
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE",  -- Sub-Ult
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE",  -- Ultimate Start
    ["rbxassetid://IDHERE"] = "rbxassetid://REPLACEDIDHERE"   -- Ultimate Hit (Flame, Sound, and Mist)
}

-- Speed settings for each move, default is 1 if not defined
local animationSpeeds = {
    ["rbxassetid://IDHERE"] = 1,  -- M1 Speed
    ["rbxassetid://IDHERE"] = 1,  -- M2 Speed
    ["rbxassetid://IDHERE"] = 1,  -- M3 Speed
    ["rbxassetid://IDHERE"] = 1,  -- M4 Speed
    ["rbxassetid://IDHERE"] = 1,  -- Upslash Speed
    ["rbxassetid://IDHERE"] = 1,  -- Downslam Speed
    ["rbxassetid://IDHERE"] = 1,  -- Move 1 Speed
    ["rbxassetid://IDHERE"] = 1,  -- Move 2 Speed
    ["rbxassetid://IDHERE"] = 1,  -- Move 3 Speed
    ["rbxassetid://IDHERE"] = 1,  -- Move 4 Speed
    ["rbxassetid://IDHERE"] = 1,  -- Sub-Ult Speed
    ["rbxassetid://IDHERE"] = 1,  -- Ultimate Start Speed
    ["rbxassetid://IDHERE"] = 1   -- Ultimate Hit Speed
}

-- Start times for animations, default is 0 if not defined
local animationStartTimes = {
    ["rbxassetid://IDHERE"] = 0,   -- M1 Start Time
    ["rbxassetid://IDHERE"] = 0,   -- M2 Start Time
    ["rbxassetid://IDHERE"] = 0,   -- M3 Start Time
    ["rbxassetid://IDHERE"] = 0,   -- M4 Start Time
    ["rbxassetid://IDHERE"] = 0,   -- Upslash Start Time
    ["rbxassetid://IDHERE"] = 0,   -- Downslam Start Time
    ["rbxassetid://IDHERE"] = 0,   -- Move 1 Start Time
    ["rbxassetid://IDHERE"] = 0,   -- Move 2 Start Time
    ["rbxassetid://IDHERE"] = 0,   -- Move 3 Start Time
    ["rbxassetid://IDHERE"] = 0,   -- Move 4 Start Time
    ["rbxassetid://IDHERE"] = 0,   -- Sub-Ult Start Time
    ["rbxassetid://IDHERE"] = 0,   -- Ultimate Start Time
    ["rbxassetid://IDHERE"] = 0    -- Ultimate Hit Start Time
}

-- Retrieve the player and character information
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator")
local activeAnimations = {}  -- Tracks currently playing animations

-- Function to handle when an animation is played
local function onAnimationPlayed(animationTrack)
    -- Get the ID of the currently playing animation
    local animationId = animationTrack.Animation and animationTrack.Animation.AnimationId
    local newAnimationId = animations[animationId]  -- Find the replacement animation ID
    local animSpeed = animationSpeeds[animationId] or 1  -- Get the animation speed, default to 1 if not set
    local animStartTime = animationStartTimes[animationId] or 0  -- Get the start time for the animation, default to 0

    -- Only proceed if there is a valid replacement animation and it's not already playing
    if newAnimationId and not activeAnimations[newAnimationId] then
        activeAnimations[newAnimationId] = true  -- Mark this animation as currently playing

        -- Stop any currently playing animation that matches the original animation ID
        for _, animTrack in pairs(humanoid:GetPlayingAnimationTracks()) do
            if animTrack.Animation and animTrack.Animation.AnimationId == animationId then
                animTrack:Stop()  -- Stop the animation to avoid duplicates
                break
            end
        end

        -- Create and load the new animation
        local newAnim = Instance.new("Animation")
        newAnim.AnimationId = newAnimationId
        local animTrack = animator:LoadAnimation(newAnim)

        if animTrack then
            -- Play the new animation with custom speed and start time
            animTrack:Play()
            animTrack:AdjustSpeed(0)  -- Pause the animation at the start
            animTrack.TimePosition = animStartTime  -- Set the start position
            animTrack:AdjustSpeed(animSpeed)  -- Set the custom speed for this animation

            -- Once the animation finishes, mark it as available to play again
            animTrack.Stopped:Connect(function()
                activeAnimations[newAnimationId] = nil
            end)
        else
            -- If the animation fails to load, print a warning and allow retries
            warn("Failed to load animation: " .. newAnimationId)
            activeAnimations[newAnimationId] = nil  -- Allow retrying the animation
        end
    end
end

-- Connect the AnimationPlayed event to the handler function
humanoid.AnimationPlayed:Connect(onAnimationPlayed)

-- =======================================
-- GUI Setup (Simple UI with checkboxes)
-- =======================================

-- Create the ScreenGui to hold the UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SBGGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame for the GUI layout
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Set background color to black
frame.Parent = screenGui

-- Title of the GUI
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "SBG Gui"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Parent = frame

-- Layout for the checkboxes (vertical arrangement)
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.Parent = frame

-- Table to hold checkboxes for each animation
local checkboxes = {}

-- Create a checkbox for each animation
for animationId, _ in pairs(animations) do
    local checkboxFrame = Instance.new("Frame")
    checkboxFrame.Size = UDim2.new(1, 0, 0, 30)
    checkboxFrame.BackgroundTransparency = 1
    checkboxFrame.Parent = frame

    -- Checkbox button
    local checkbox = Instance.new("TextButton")
    checkbox.Size = UDim2.new(0, 20, 0, 20)
    checkbox.Position = UDim2.new(0, 10, 0, 5)
    checkbox.Text = "✔"  -- Initially checked
    checkbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    checkbox.Parent = checkboxFrame

    -- Label showing the animation name
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 0, 20)
    label.Position = UDim2.new(0, 30, 0, 5)
    label.Text = animationId  -- Show animation ID as text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.TextSize = 14
    label.Parent = checkboxFrame

    -- When checkbox is clicked, toggle the animation's state
    checkbox.MouseButton1Click:Connect(function()
        if checkbox.Text == "✔" then
            checkbox.Text = ""  -- Uncheck the box
            activeAnimations[animationId] = nil  -- Disable the animation
        else
            checkbox.Text = "✔"  -- Check the box
            activeAnimations[animationId] = true  -- Enable the animation
        end
    end)
end
