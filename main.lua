-- VISUAL MENU + SPEED + FLY + NOCLIP + ESP (FIXED) + HP + GodMode + Loader + Watermark

-- ===== LOADER =====
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "LoaderGui"
gui.ResetOnSpawn = false
gui.Parent = LP:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 170)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Position = UDim2.new(0,0,0,10)
title.Text = "MultiMenu"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,0,0,20)
status.Position = UDim2.new(0,0,0,45)
status.Text = "Injecting..."
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(180,180,180)
status.BackgroundTransparency = 1

-- progress bar bg
local barBG = Instance.new("Frame", frame)
barBG.Size = UDim2.new(0.88,0,0,14)
barBG.Position = UDim2.new(0.06,0,0.72,0)
barBG.BackgroundColor3 = Color3.fromRGB(35,35,35)
barBG.BorderSizePixel = 0
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1,0)

-- progress bar fill
local bar = Instance.new("Frame", barBG)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
bar.BorderSizePixel = 0
Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

local percent = Instance.new("TextLabel", frame)
percent.Size = UDim2.new(1,0,0,20)
percent.Position = UDim2.new(0,0,0.85,0)
percent.Text = "Loading 0%"
percent.Font = Enum.Font.Gotham
percent.TextSize = 13
percent.TextColor3 = Color3.fromRGB(160,160,160)
percent.BackgroundTransparency = 1

-- progress animation
for i = 1, 100 do
	bar:TweenSize(
		UDim2.new(i/100,0,1,0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.03,
		true
	)
	percent.Text = "Loading "..i.."%"
	task.wait(0.03)
end

status.Text = "Done ✔"
task.wait(0.4)

-- fade out
for _,v in pairs(frame:GetDescendants()) do
	if v:IsA("TextLabel") then
		TweenService:Create(v, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
	elseif v:IsA("Frame") then
		TweenService:Create(v, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
	end
end

task.wait(0.5)
gui:Destroy()
-- ===== END LOADER =====


local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- ================= GODMODE =================
local GodModeEnabled = false
local GodConnection

local function applyGodMode()
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	-- отключаем Health, чтобы не конфликтовало
	HealthEnabled = false

	hum.MaxHealth = math.huge
	hum.Health = hum.MaxHealth

	if GodConnection then
		GodConnection:Disconnect()
	end

	GodConnection = hum.HealthChanged:Connect(function()
		if GodModeEnabled and hum.Health < hum.MaxHealth then
			hum.Health = hum.MaxHealth
		end
	end)
end

local function disableGodMode()
	GodModeEnabled = false

	if GodConnection then
		GodConnection:Disconnect()
		GodConnection = nil
	end

	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.MaxHealth = 100
		hum.Health = math.min(hum.Health, 100)
	end
end

-- при респавне
LP.CharacterAdded:Connect(function()
	task.wait(0.3)
	if GodModeEnabled then
		applyGodMode()
	end
end)

-- ================= HEALTH =================
local HealthEnabled = false
local HealthValue = 100
local HealthMax = 1000

local function applyHealth()
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.MaxHealth = HealthValue
		hum.Health = HealthValue
	end
end

LP.CharacterAdded:Connect(function()
	task.wait(0.2)
	if HealthEnabled then
		applyHealth()
	end
end)


-- ================= SPEED =================
local SpeedValue = 16
local SpeedMax = 300

local function applySpeed()
	local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = SpeedValue end
end

LP.CharacterAdded:Connect(function()
	task.wait(0.2)
	applySpeed()
end)

-- ================= FLY =================
local FlyEnabled = false
local FlySpeed = 80
local FlySpeedMax = 300
local BV, BG

local function setFly(state)
	FlyEnabled = state
	local char = LP.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart

	if state then
		BV = Instance.new("BodyVelocity", hrp)
		BV.MaxForce = Vector3.new(1e5,1e5,1e5)

		BG = Instance.new("BodyGyro", hrp)
		BG.MaxTorque = Vector3.new(1e5,1e5,1e5)
	else
		if BV then BV:Destroy() BV=nil end
		if BG then BG:Destroy() BG=nil end
	end
end

RunService.RenderStepped:Connect(function()
	if FlyEnabled and BV and BG then
		local cam = workspace.CurrentCamera
		local dir = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += cam.CFrame.UpVector end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= cam.CFrame.UpVector end

		BV.Velocity = dir * FlySpeed
		BG.CFrame = cam.CFrame
	end
end)

-- ================= NOCLIP =================
local NoclipEnabled = false

RunService.Stepped:Connect(function()
	if NoclipEnabled and LP.Character then
		for _,v in ipairs(LP.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- ================= ESP =================
local ESPEnabled = false
local ESPObjects = {}

local function clearESP()
	for _,h in pairs(ESPObjects) do
		h:Destroy()
	end
	ESPObjects = {}
end

local function applyESP()
	clearESP()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr.Character then
			local hl = Instance.new("Highlight")
			hl.FillColor = Color3.fromRGB(255,0,0)
			hl.OutlineColor = Color3.fromRGB(255,0,0)
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl.Parent = plr.Character
			table.insert(ESPObjects, hl)
		end
	end
end

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if ESPEnabled then
			task.wait(0.5)
			applyESP()
		end
	end)
end)

-- ================= GUI =================
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.ResetOnSpawn = false
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://6895079853"
clickSound.Volume = 1
clickSound.Parent = gui

local function playClick()
	clickSound:Play()
end


local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.6,0.6)
main.Position = UDim2.fromScale(0.2,0.2)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundColor3 = Color3.fromRGB(20,20,20)
top.BorderSizePixel = 0

local title = Instance.new("TextLabel", top)
title.Text = "Multi Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(220,220,220)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1,0,1,0)

-- ================= PAGES =================
local pages = {}

local function page()
	local f = Instance.new("Frame", main)
	f.Size = UDim2.new(1,0,1,-40)
	f.Position = UDim2.new(0,0,0,40)
	f.BackgroundTransparency = 1
	f.Visible = false
	return f
end

pages.SPEED = page()
pages.RAGE = page()
pages.SETTINGS = page()

pages.SPEED.Visible = true


local function tab(text,x,p)
	local b = Instance.new("TextButton", top)
	b.Size = UDim2.new(0,160,1,0)
	b.Position = UDim2.new(0,x,0,0)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 13
	b.TextColor3 = Color3.fromRGB(180,180,180)
	b.BackgroundTransparency = 1

	b.MouseButton1Click:Connect(function()
		playClick()
		for _,pg in pairs(pages) do pg.Visible=false end
		p.Visible=true
	end)
end


tab("SPEED",0,pages.SPEED)
tab("RAGE",160,pages.RAGE)
tab("SETTINGS",320,pages.SETTINGS)


-- ================= SLIDER =================
local function slider(parent,y,text,value,max,cb)
	local f = Instance.new("Frame", parent)
	f.Position = UDim2.new(0,30,0,y)
	f.Size = UDim2.new(0,300,0,60)
	f.BackgroundTransparency = 1

	local lbl = Instance.new("TextLabel", f)
	lbl.Text = text..": "..value
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 14
	lbl.TextColor3 = Color3.fromRGB(0,170,255)
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1,0,0,20)

	local bar = Instance.new("Frame", f)
	bar.Position = UDim2.new(0,0,0,30)
	bar.Size = UDim2.new(1,0,0,6)
	bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new(value/max,0,1,0)
	fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

	local drag=false
	bar.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
	end)
	UIS.InputChanged:Connect(function(i)
		if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
			local r = math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
			fill.Size = UDim2.new(r,0,1,0)
			local v = math.floor(r*max)
			lbl.Text = text..": "..v
			cb(v)
		end
	end)
end

-- SPEED
slider(pages.SPEED,40,"Speed",SpeedValue,SpeedMax,function(v)
	SpeedValue=v
	applySpeed()
end)

-- ================= SPEED =================

-- RESET SPEED BUTTON
local reset = Instance.new("TextButton", pages.SPEED)
reset.Size = UDim2.new(0,220,0,32)
reset.Position = UDim2.new(0,30,0,120)
reset.Text = "RESET SPEED"
reset.Font = Enum.Font.Gotham
reset.TextSize = 13
reset.TextColor3 = Color3.fromRGB(235,235,235) -- ВСЕГДА БЕЛЫЙ
reset.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", reset).CornerRadius = UDim.new(0,8)

reset.MouseButton1Click:Connect(function()
	SpeedValue = 16
	applySpeed()
end)

-- ================= RAGE =================

local TweenService = game:GetService("TweenService")

local function animateToggle(box, state)
	local goal = {}

	if state then
		goal.BackgroundColor3 = Color3.fromRGB(0,255,0)
		goal.Size = UDim2.fromOffset(34,34)
	else
		goal.BackgroundColor3 = Color3.fromRGB(40,40,40)
		goal.Size = UDim2.fromOffset(30,30)
	end

	local tween = TweenService:Create(
		box,
		TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		goal
	)

	tween:Play()
end


local function toggle(y,text,cb)
	local box = Instance.new("TextButton", pages.RAGE)
	box.Size = UDim2.fromOffset(30,30)
	box.Position = UDim2.new(0,30,0,y)
	box.BackgroundColor3 = Color3.fromRGB(40,40,40)
	box.Text = ""
	Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

	local lbl = Instance.new("TextLabel", pages.RAGE)
	lbl.Text = text
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 14
	lbl.TextColor3 = Color3.fromRGB(220,220,220)
	lbl.BackgroundTransparency = 1
	lbl.Position = UDim2.new(0,75,0,y)
	lbl.Size = UDim2.new(0,200,0,30)
	lbl.TextYAlignment = Enum.TextYAlignment.Center
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	box.MouseButton1Click:Connect(function()
		playClick()
		local state = cb()
		animateToggle(box, state)
	end)
end




toggle(40,"Fly",function()
	setFly(not FlyEnabled)
	return FlyEnabled
end)

toggle(90,"Noclip",function()
	NoclipEnabled = not NoclipEnabled
	return NoclipEnabled
end)

toggle(140,"ESP",function()
	ESPEnabled = not ESPEnabled
	if ESPEnabled then applyESP() else clearESP() end
	return ESPEnabled
end)

toggle(190,"Health",function()
	HealthEnabled = not HealthEnabled

	if HealthEnabled then
		applyHealth()
	else
		local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.MaxHealth = 100
			hum.Health = math.min(hum.Health, 100)
		end
	end

	return HealthEnabled
end)

toggle(240,"GodMode",function()
	GodModeEnabled = not GodModeEnabled

	if GodModeEnabled then
		applyGodMode()
	else
		disableGodMode()
	end

	return GodModeEnabled
end)


slider(pages.RAGE,290,"Health",HealthValue,HealthMax,function(v)
	HealthValue = v

	if HealthEnabled then
		if v == 0 then
			local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = 0 end
		else
			applyHealth()
		end
	end
end)

slider(pages.RAGE,360,"Fly Speed",FlySpeed,FlySpeedMax,function(v)
	FlySpeed = v
end)



-- ================= SETTINGS =================

-- ===== THEME BUTTON =====
local themeButton = Instance.new("TextButton", pages.SETTINGS)
themeButton.Size = UDim2.new(0,220,0,32)
themeButton.Position = UDim2.new(0,30,0,40)
themeButton.Text = "Theme: Black ▼"
themeButton.Font = Enum.Font.Gotham
themeButton.TextSize = 13
themeButton.TextColor3 = Color3.fromRGB(220,220,220)
themeButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", themeButton).CornerRadius = UDim.new(0,8)

local themeOpen = false

local dropdown = Instance.new("Frame", pages.SETTINGS)
dropdown.Position = UDim2.new(0,30,0,75)
dropdown.Size = UDim2.new(0,220,0,0)
dropdown.BackgroundColor3 = Color3.fromRGB(30,30,30)
dropdown.ClipsDescendants = true
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0,8)

-- ===== TEXT COLOR FUNCTION (FIXED) =====
local function setTextColor(root, color)
	for _,v in ipairs(root:GetDescendants()) do
		if (v:IsA("TextLabel") or v:IsA("TextButton"))
		and v ~= reset -- НЕ ТРОГАЕМ RESET SPEED
		and v.Parent ~= dropdown then
			v.TextColor3 = color
		end
	end
end


-- ===== APPLY THEME =====
local function applyTheme(mode)
	if mode == "Black" then
		main.BackgroundColor3 = Color3.fromRGB(15,15,15)
		top.BackgroundColor3 = Color3.fromRGB(20,20,20)
		themeButton.BackgroundColor3 = Color3.fromRGB(30,30,30)

		setTextColor(main, Color3.fromRGB(235,235,235)) -- белый текст

	elseif mode == "White" then
		main.BackgroundColor3 = Color3.fromRGB(235,235,235)
		top.BackgroundColor3 = Color3.fromRGB(220,220,220)
		themeButton.BackgroundColor3 = Color3.fromRGB(200,200,200)

		setTextColor(main, Color3.fromRGB(20,20,20)) -- чёрный текст

	elseif mode == "Mehanic" then
		-- 🔧 ОРАНЖЕВАЯ ТЕМА
		main.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- оранжевый
		top.BackgroundColor3 = Color3.fromRGB(230, 140, 0)
		themeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)

		setTextColor(main, Color3.fromRGB(255,255,255)) -- ВСЕГДА белый текст
	end

	-- reset speed всегда белым
	reset.TextColor3 = Color3.fromRGB(255,255,255)
end


-- ===== THEME OPTIONS =====
local function themeOption(text, y)
	local b = Instance.new("TextButton", dropdown)
	b.Size = UDim2.new(1,0,0,30)
	b.Position = UDim2.new(0,0,0,y)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 13
	b.TextColor3 = Color3.fromRGB(220,220,220)
	b.BackgroundTransparency = 1

	b.MouseButton1Click:Connect(function()
		themeButton.Text = "Theme: "..text.." ▼"
		applyTheme(text)

		themeOpen = false
		dropdown:TweenSize(UDim2.new(0,220,0,0),"Out","Quad",0.2,true)
	end)
end

themeOption("Black",0)
themeOption("White",30)
themeOption("Mehanic",60)


themeButton.MouseButton1Click:Connect(function()
	themeOpen = not themeOpen

	dropdown:TweenSize(
		themeOpen and UDim2.new(0,220,0,90) or UDim2.new(0,220,0,0),
		"Out",
		"Quad",
		0.2,
		true
	)
end)


-- DEFAULT THEME
applyTheme("Black")

-- ================= TRANSPARENCY =================

local transpValue = 1

local tFrame = Instance.new("Frame", pages.SETTINGS)
tFrame.Position = UDim2.new(0,30,0,180)
tFrame.Size = UDim2.new(0,300,0,60)
tFrame.BackgroundTransparency = 1

local tText = Instance.new("TextLabel", tFrame)
tText.Text = "Transparency: 1.00"
tText.Font = Enum.Font.Gotham
tText.TextSize = 14
tText.TextColor3 = Color3.fromRGB(0,170,255)
tText.BackgroundTransparency = 1
tText.Size = UDim2.new(1,0,0,20)

local tBar = Instance.new("Frame", tFrame)
tBar.Position = UDim2.new(0,0,0,30)
tBar.Size = UDim2.new(1,0,0,6)
tBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", tBar).CornerRadius = UDim.new(1,0)

local tFill = Instance.new("Frame", tBar)
tFill.Size = UDim2.new(1,0,1,0)
tFill.BackgroundColor3 = Color3.fromRGB(0,170,255)
Instance.new("UICorner", tFill).CornerRadius = UDim.new(1,0)

local dragging = false

tBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local r = math.clamp(
			(i.Position.X - tBar.AbsolutePosition.X) / tBar.AbsoluteSize.X,
			0,1
		)

		transpValue = 1 - (r * 0.5)
		tFill.Size = UDim2.new(r,0,1,0)
		tText.Text = string.format("Transparency: %.2f", transpValue)

		main.BackgroundTransparency = 1 - transpValue
		top.BackgroundTransparency = 1 - transpValue
	end
end)


-- ================= INSERT =================
UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode==Enum.KeyCode.Insert then
		main.Visible = not main.Visible
	end
end)
