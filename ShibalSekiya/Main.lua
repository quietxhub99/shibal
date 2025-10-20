local Version = "1.6.53"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()

-------------------------------------------
----- =======[ GLOBAL FUNCTION ]
-------------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local net = ReplicatedStorage:WaitForChild("Packages")
	:WaitForChild("_Index")
	:WaitForChild("sleitnick_net@0.2.0")
	:WaitForChild("net")

local rodRemote = net:WaitForChild("RF/ChargeFishingRod")
local miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted")
local finishRemote = net:WaitForChild("RE/FishingCompleted")

local Player = Players.LocalPlayer
local XPBar = Player:WaitForChild("PlayerGui"):WaitForChild("XP")

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

for i,v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
                    v:Disable()
end

task.spawn(function()
    if XPBar then
        XPBar.Enabled = true
    end
end)

local TeleportService = game:GetService("TeleportService")
local PlaceId = game.PlaceId

local function AutoReconnect()
    while task.wait(5) do
        if not Players.LocalPlayer or not Players.LocalPlayer:IsDescendantOf(game) then
            TeleportService:Teleport(PlaceId)
        end
    end
end

Players.LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        TeleportService:Teleport(PlaceId)
    end
end)

task.spawn(AutoReconnect)

local ijump = false

local RodIdle = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("ReelingIdle")

local RodShake = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("RodThrow")

local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")


local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

local RodShake = animator:LoadAnimation(RodShake)
local RodIdle = animator:LoadAnimation(RodIdle)

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")


-------------------------------------------
----- =======[ NOTIFY FUNCTION ]
-------------------------------------------

local function NotifySuccess(title, message, duration)
    WindUI:Notify({
        Title = title,
        Content = message,
        Duration = duration,
        Icon = "circle-check"
    })
end

local function NotifyError(title, message, duration)
    WindUI:Notify({
        Title = title,
        Content = message,
        Duration = duration,
        Icon = "ban"
    })
end

local function NotifyInfo(title, message, duration)
    WindUI:Notify({
        Title = title,
        Content = message,
        Duration = duration,
        Icon = "info"
    })
end

local function NotifyWarning(title, message, duration)
    WindUI:Notify({
        Title = title,
        Content = message,
        Duration = duration,
        Icon = "triangle-alert"
    })
end


------------------------------------------
----- =======[ CHECK DATA ]
-----------------------------------------

local CheckData = {
	pasteURL = "https://raw.githubusercontent.com/quietxhub99/raul/refs/heads/main/upd.txt",
	interval = 30,
	kicked = false,
	notified = false
}

local function checkStatus()
	local success, result = pcall(function()
		return game:HttpGet(CheckData.pasteURL)
	end)

	if not success or typeof(result) ~= "string" then
		return
	end

	local response = result:upper():gsub("%s+", "")

	if response == "UPDATE" then
		if not CheckData.kicked then
			CheckData.kicked = true
			LocalPlayer:Kick("QuietXHub Premium Update Available!.")
		end
	elseif response == "LATEST" then
		if not CheckData.notified then
			CheckData.notified = true
			warn("[QuietXHub] Status: Latest version")
		end
	else
		warn("[QuietXHub] Status unknown:", response)
	end
end

checkStatus()

task.spawn(function()
	while not CheckData.kicked do
		task.wait(CheckData.interval)
		checkStatus()
	end
end)


local confirmed = false
WindUI:Popup({
    Title = "Important!",
    Icon = "rbxassetid://129260712070622",
    Content = [[
Thank you for using Premium script!.
Dont be a Stealer!
]],
    Buttons = {
        { Title = "Close", Variant = "Secondary", Callback = function() end },
        { Title = "Next", Variant = "Primary", Callback = function() confirmed = true end },
    }
})

repeat task.wait() until confirmed


-------------------------------------------
----- =======[ LOAD WINDOW ]
-------------------------------------------

WindUI:AddTheme({
    Name = "Blue Ocean",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#5CC6FF"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#004E92"), Transparency = 0 },
    }, {
        Rotation = 90,
    }),
    Dialog = Color3.fromHex("#0B1E3F"),
    Outline = Color3.fromHex("#D0E7FF"),
    Text = Color3.fromHex("#E6F4FF"),
    Placeholder = Color3.fromHex("#94AFCB"),
    Background = Color3.fromHex("#0A192F"),
    Button = Color3.fromHex("#1E81CE"),
    Icon = Color3.fromHex("#B5DCFF")
})

WindUI.TransparencyValue = 0.3

local Window = WindUI:CreateWindow({
    Title = "Fish It",
    Icon = "crown",
    Author = "by Prince",
    Folder = "QuietXHub",
    Size = UDim2.fromOffset(600, 400),
    Transparent = true,
    Theme = "Blue Ocean",
    KeySystem = false,
    ScrollBarEnabled = true,
    HideSearchBar = true,
    NewElements = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
        end,
    }
})

Window:EditOpenButton({
    Title = "QuietXHub",
    Icon = "crown",
    CornerRadius = UDim.new(0,19),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("21FFE0"), 
        Color3.fromHex("3C84FF")
    ),
    Draggable = true,
})

Window:Tag({
    Title = "PREMIUM VERSION",
    Color = Color3.fromHex("#30ff6a")
})



local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("QuietXConfig")

WindUI:SetNotificationLower(true)

-- Semua kode Window / UI kamu tetap di sini (seperti yang kamu kirim)
-- ↓ Tambahkan ini setelah semua Tab dideklarasikan

-- Fungsi untuk load tab dari GitHub
local function loadTab(tab, fileName)
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/<USERNAME>/QuietXHub/main/Tabs/" .. fileName .. ".lua"))()(tab)
    end)
    if not success then
        warn("[QuietXHub] Gagal load tab " .. fileName .. ": " .. tostring(err))
        WindUI:Notify({
            Title = "QuietXHub",
            Content = "Gagal load tab: " .. fileName,
            Duration = 5,
            Image = "x"
        })
    end
end

loadTab(Home, "Home")

WindUI:Notify({
    Title = "QuietXHub",
    Content = "All Tabs Loaded Successfully!",
    Duration = 5,
    Image = "square-check-big"
})