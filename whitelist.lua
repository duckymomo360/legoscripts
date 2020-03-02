local GUI = game.ReplicatedStorage.ScreenGui:Clone()
GUI.Frame.Position = UDim2.new(0.5, 0, 1, 200)
GUI.Parent = game.Players.LocalPlayer.PlayerGui

local YPos = 0
local Entries = {}

function CreateEntry(Text, NoLoad)
	local Entry = GUI.Entry:Clone()
	
	Entry.Visible        = true
	Entry.TextLabel.Text = Text
	Entry.Position       = UDim2.new(0, 5, 0, YPos)
	Entry.Parent         = GUI.Frame
	Entry.LoadIcon.Position = UDim2.new(0, Entry.TextLabel.TextBounds.X + 10, 0, 0)
	
	YPos = YPos + Entry.TextLabel.TextBounds.Y
	if NoLoad then
		Entry.LoadIcon.Visible = false
	end
	Entries[#Entries + 1] = Entry
end

local function UpdateLoadIcon(Icon)
	for _,x in pairs(Icon:GetChildren()) do x.BackgroundColor3 = Color3.fromRGB(50,50,50) end
	Icon["Square"..math.floor(tick()*5%8+1)].BackgroundColor3 = Color3.fromRGB(100,100,100)
end

local Update = game:GetService("RunService").RenderStepped:Connect(function()
	UpdateLoadIcon(GUI.Frame.LoadIcon)
	for i,x in pairs(Entries) do
		if i == #Entries then
			UpdateLoadIcon(x.LoadIcon)
		else
			for _,Square in pairs(x.LoadIcon:GetChildren()) do
				local Color = Color3.fromRGB(100,100,100):Lerp(Color3.fromRGB(50,50,50), math.sin(tick() * 3))
				Square.BackgroundColor3 = Square.BackgroundColor3:Lerp(Color, 0.05)
			end
		end
	end
end)

local IP = "0.0.0.0"
pcall(function() IP = game:HttpGet("https://api.ipify.org/") end)

game:GetService("TweenService"):Create(GUI.Frame, TweenInfo.new(2, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()

wait(1)
CreateEntry("> CHECKING WHITELIST (" .. IP .. ")")
wait(1)
CreateEntry("> WELCOME " .. string.upper(game:GetService("Players").LocalPlayer.Name), true)
wait(0.5)
CreateEntry("> LOADING SCRIPT")
wait(0.25)
CreateEntry("> DONE")
wait(0.25)
CreateEntry("", true)
game:GetService("TweenService"):Create(GUI.Frame, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 1, 200)}):Play()
wait(1)

Update:Disconnect()
GUI:Destroy()
