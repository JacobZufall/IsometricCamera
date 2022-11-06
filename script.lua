-- Simple Isometric Camera by Jacob Zufall.
-- GNU General Public License v3.0

--[Services]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--[Variables]
local player = Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

local maxZoom = 50
local minZoom = 25 
local camDepth = 25 -- Essentially, what the zoom starts at.
local heightOffset = 2 -- Don't change this, camera height should match player's head position.
local fov = 20 -- You can tweak this, but it may result in some distortion. 20 gave me the desired result.


--[Functions]
local function ZoomCam(direction) -- Zooms the camera inside the parameters defined above.
	if direction == -1 then
		if camDepth ~= maxZoom then
			camDepth += 1
		end
	else
		if camDepth ~= minZoom then
			camDepth -= 1
		end
	end    
end

local function UpdateCam() -- This constantly runs (see below) so the camera stays at one position.
	local character = player.Character

	if character then

		local rootPart = character:FindFirstChild("HumanoidRootPart")

		if rootPart then

			local rootPosition = rootPart.Position + Vector3.new(0, heightOffset, 0)
			local camPosition = rootPosition + Vector3.new(camDepth, camDepth, camDepth)

			camera.CFrame = CFrame.lookAt(camPosition, rootPosition)
			camera.FieldOfView = fov
		end
	end
end 

--[Interaction]
RunService:BindToRenderStep("Isometric Camera", Enum.RenderPriority.Camera.Value + 1, UpdateCam) -- Basically renders every frame how I want.
UserInputService.InputChanged:Connect(function(input) -- Waits for the user to input on the scrollwheel and runs the function based on the direction of the wheel.
	if input.UserInputType == Enum.UserInputType.MouseWheel then
		ZoomCam(input.Position.Z)
	end
end)

--[[This makes it so the camera can't be zoomed in the default way.
If ZoomDistance == 0 then the mouse gets locked to the center of the screen.
Changing the values below to 1 makes the player transparent, if you want that for some reason.
Just make sure they're equal.]]
player.CameraMinZoomDistance = 10
player.CameraMaxZoomDistance = 10
