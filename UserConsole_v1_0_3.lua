local Showing_Credits = false

local Player = game.Players.LocalPlayer
local Camera = game.Workspace.Camera
local UserInputService = game:GetService("UserInputService")
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
local Console_Active = false


local BindTable = {}
table.insert(BindTable, ".")
table.insert(BindTable, "console")

local Chatcolor_RGB = false
local Chatcolor_Custom = nil

local Stalk_Target = ""

local Console_RGB = false
local Console_Color = Color3.new(255/255, 255/255, 210/255)

local Fly_Enabled = false
local Fly_Speed = 100
local Fly_GravComp = 5.5

local t = 5
local RunService = game:GetService("RunService")
local desiredInterval = 0.01
local counter = 0

local ConsoleGui
local ConsoleInputFiller
local ConsoleInputSign
local ConsoleInputBox

game:GetService("UserInputService").InputBegan:connect(function(input)

	if Console_Active then
		if (input.KeyCode == Enum.KeyCode.Return) then
			console_exec(ConsoleInputBox.Text)
		end
		if (input.KeyCode == Enum.KeyCode.Escape) then
			ConsoleInputBox.Text = ""
			ConsoleGui:Destroy()
			Console_Active = false
		end
	else
		for i, v in pairs(BindTable) do
			if v == string.char(input.KeyCode.Value) then
				if (Player.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar:IsFocused() == false) then
					console_exec(BindTable[i+1])
				end
			end
		end
	end
end)

function console_spawn()

    ConsoleGui = Instance.new("ScreenGui")
    ConsoleGui.Parent = Player.PlayerGui
    ConsoleGui.Name = "ConsoleGui"

    ConsoleInputFiller = Instance.new("Frame")
    ConsoleInputFiller.Name = "ConsoleInputFiller"
    ConsoleInputFiller.Parent = ConsoleGui
    ConsoleInputFiller.Size = UDim2.new(1, 0, 0.05, 0)
    ConsoleInputFiller.BorderSizePixel = 5
    ConsoleInputFiller.Position = UDim2.new(0, 0, 0.95, 0)
    ConsoleInputFiller.BackgroundColor3 = Color3.new(40 / 255, 40 / 255, 40 / 255)
	ConsoleInputFiller.BorderColor3 = Console_Color

    ConsoleInputSign = Instance.new("TextLabel")
    ConsoleInputSign.Name = "ConsoleInputSign"
    ConsoleInputSign.Parent = ConsoleGui
    ConsoleInputSign.Size = UDim2.new(1, 0, 0.05, 0)
    ConsoleInputSign.BorderSizePixel = 0
    ConsoleInputSign.Text = "> "
    ConsoleInputSign.Position = UDim2.new(0, 22, 0.95, 3)
    ConsoleInputSign.BackgroundColor3 = Color3.new(40 / 255, 40 / 255, 40 / 255)
    ConsoleInputSign.TextColor3 = Console_Color
    ConsoleInputSign.TextSize = 17
    ConsoleInputSign.TextXAlignment = "Left"

    ConsoleInputBox = Instance.new("TextBox")
    ConsoleInputBox.Name = "ConsoleInput"
    ConsoleInputBox.Parent = ConsoleGui
    ConsoleInputBox.Size = UDim2.new(1, 0, 0.05, 0)
    ConsoleInputBox.BorderSizePixel = 0
    ConsoleInputBox.Position = UDim2.new(0, 44, 0.95, 0)
    ConsoleInputBox.BackgroundColor3 = Color3.new(40 / 255, 40 / 255, 40 / 255)
    ConsoleInputBox.TextColor3 = Console_Color
    ConsoleInputBox.TextSize = 25
    ConsoleInputBox.TextXAlignment = "Left"
    ConsoleInputBox.Font = "Ubuntu"
    ConsoleInputBox.Text = ""
    ConsoleInputBox.PlaceholderText = "Insert command here..."
    ConsoleInputBox.PlaceholderColor3 = Color3.new(Console_Color.R * 0.44, Console_Color.G * 0.44, Console_Color.B * 0.44)
	Console_Active = true

	local wait
	wait = RunService.Heartbeat:Connect(function(step)
		counter = counter + step
		if counter >= desiredInterval then
			counter = counter - desiredInterval
			
			ConsoleInputBox:CaptureFocus()
			ConsoleInputBox.Text = ""
			wait:Disconnect()
			
		end
	end)
	

end





function console_exec(input)
	
    if Console_Active then
        ConsoleInputBox.Text = ""
        ConsoleGui:Destroy()
        Console_Active = false
    end


    local args = {}
    for arg in (input.." "):gmatch("(.-)".." ") do table.insert(args, arg) end
	
	for i, v in pairs(args) do
		if v == " " or v == "" then
			args[i] = nil
		end
	end


    if (args[1]:upper() == "FOV") then
	
		if (args[2]:upper() == "INCREASE") then
			game.Workspace.Camera.FieldOfView += tonumber(args[3])
			
		elseif (args[2]:upper() == "DECREASE") then
			game.Workspace.Camera.FieldOfView -= tonumber(args[3])
			
		else
			game.Workspace.Camera.FieldOfView = tonumber(args[2])
		end
    end


    if (args[1]:upper() == "TP") then
        Player.Character.HumanoidRootPart.CFrame = game.Players[args[2]].Character.HumanoidRootPart.CFrame
    end


    if (args[1]:upper() == "FLY") then
        
		
		if (args[2] == nil) then
			Fly_Enabled = not Fly_Enabled
			
		elseif (args[2]:upper() == "SPEED") then
		
			if (args[3]:upper() == "INCREASE") then
				Fly_Speed += tonumber(args[4])
				
			elseif (args[3]:upper() == "DECREASE") then
				Fly_Speed -= tonumber(args[4])
				
			else
				Fly_Speed = tonumber(args[3])
			end


        elseif (args[2]:upper() == "GRAVCOMP") then
            Fly_GravComp = tonumber(args[3])
		end
		
    end
	
	
	if (args[1]:upper() == "BIND") then
        local bindcmd = ""
        for i, v in pairs(args) do
            if i > 2 then
                bindcmd ..= v .. " "
            end
        end

        table.insert(BindTable, args[2])
        table.insert(BindTable, bindcmd)

	end


    if (args[1]:upper() == "UNBIND") then
        for i, v in pairs(BindTable) do
            if v == args[2] then
                BindTable[i+1] = nil
                BindTable[i] = nil
            end
        end
	end


    if (args[1]:upper() == "CHATCOLOR") then
        if (args[2]:upper() == "RGB") then
			Chatcolor_RGB = not Chatcolor_RGB
		else
			Chatcolor_Custom = Color3.new(args[2]/255, args[3]/255, args[4]/255)
		end
	end
	
	
	if (args[1]:upper() == "STALK") then
		Stalk_Target = args[2]
	end
	

    if (args[1]:upper() == "SUICIDE") then
        Player.Character.Humanoid.Health = 0
	end


	if (args[1]:upper() == "CONSOLE") then
		if (args[2] == nil) then
			console_spawn()
		elseif (args[2]:upper() == "COLOR") then
			if (args[3]:upper() == "RGB") then
				Console_RGB = not Console_RGB
			else
				Console_Color = Color3.new(args[3]/255, args[4]/255, args[5]/255)
			end
		end
	end
	
	if (args[1]:upper() == "CREDITS") then
		showcredits()
	end

end





RunService.Heartbeat:Connect(function(step)
    counter = counter + step
    if counter >= desiredInterval then
        counter = counter - desiredInterval
		
		local current_rgb_hue = tick() % t / t
		local current_rgb_color = Color3.fromHSV(current_rgb_hue,1,1) 
		
		if Fly_Enabled then
            
            local vel_x = 0
            local vel_y = Fly_GravComp
            local vel_z = 0
            
            if (Console_Active == false) and (Player.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar:IsFocused() == false) then

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    vel_x = vel_x + Camera.CFrame.LookVector.X*Fly_Speed
                    vel_z = vel_z + Camera.CFrame.LookVector.Z*Fly_Speed
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    vel_x = vel_x - Camera.CFrame.LookVector.X*Fly_Speed
                    vel_z = vel_z - Camera.CFrame.LookVector.Z*Fly_Speed
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    vel_x = vel_x + Camera.CFrame.LookVector.Z*Fly_Speed
                    vel_z = vel_z - Camera.CFrame.LookVector.X*Fly_Speed
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    vel_x = vel_x - Camera.CFrame.LookVector.Z*Fly_Speed
                    vel_z = vel_z + Camera.CFrame.LookVector.X*Fly_Speed
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    vel_y = vel_y + Fly_Speed
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    vel_y = vel_y - Fly_Speed
                end

            end

            Player.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(vel_x, vel_y, vel_z)

		end
		
		
		if not (Stalk_Target == "") then
			for i, v in pairs(game.Players:GetChildren()) do
				if v.Name == Stalk_Target then				
					Player.Character.HumanoidRootPart.CFrame = game.Players[Stalk_Target].Character.HumanoidRootPart.CFrame
				end
			end
		end
		
		
		if Console_Active then
		
			if Console_RGB then
				ConsoleInputSign.TextColor3 = current_rgb_color
				ConsoleInputBox.PlaceholderColor3 = Color3.new(current_rgb_color.R * 0.44, current_rgb_color.G * 0.44, current_rgb_color.B * 0.44)
				ConsoleInputBox.TextColor3 = current_rgb_color
				ConsoleInputFiller.BorderColor3 = current_rgb_color
			end
			
		end

	
        for i, v in pairs(Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Frame_MessageLogDisplay.Scroller:GetChildren()) do
			if v.Name == "Frame" then
				if not (v.TextLabel:GetChildren()[1] == nil) then
					if v.TextLabel.TextButton.Text == "[" .. Player.DisplayName .. "]:" then
						if Chatcolor_RGB then
                            v.TextLabel.TextButton.TextColor3  = current_rgb_color
						elseif not (Chatcolor_Custom == nil) then
							v.TextLabel.TextButton.TextColor3  = Chatcolor_Custom
						end
					end
				end
			end
		end

    end
end)









function showcredits()
	if Showing_Credits == false then
	
		Showing_Credits = true
	
		local NotifGui = Instance.new("ScreenGui")
		NotifGui.Parent = Player.PlayerGui
		NotifGui.Name = "NotifGui"
		NotifGui.Name = "NotifGui"

		local NotifFiller = Instance.new("Frame")
		NotifFiller.Name = "NotifFiller"
		NotifFiller.Parent = NotifGui
		NotifFiller.Size = UDim2.new(0, 275, 0, 100)
		NotifFiller.Position = UDim2.new(0, 2050, 0, 900)
		NotifFiller.BackgroundColor3 = Color3.new(40 / 255, 40 / 255, 40 / 255)
		NotifFiller.BorderSizePixel = 0

		local NotifColorBar = Instance.new("Frame")
		NotifColorBar.Name = "NotifColorBar"
		NotifColorBar.Parent = NotifGui
		NotifColorBar.Size = UDim2.new(0, 275, 0, 5)
		NotifColorBar.BorderSizePixel = 0
		NotifColorBar.Position = UDim2.new(0, 2050, 0, 900)
		NotifColorBar.BackgroundColor3 = Console_Color

		local NotifTitle = Instance.new("TextLabel")
		NotifTitle.Name = "NotifTitle"
		NotifTitle.Parent = NotifGui
		NotifTitle.Size = UDim2.new(0, 275, 0, 5)
		NotifTitle.BorderSizePixel = 0
		NotifTitle.Text = "UserConsole v1.0.3"
		NotifTitle.Position = UDim2.new(0, 2050, 0, 938)
		NotifTitle.BackgroundColor3 = Color3.new(40 / 255, 40 / 255, 40 / 255)
		NotifTitle.TextColor3 = Console_Color
		NotifTitle.TextSize = 25
		NotifTitle.Font = "Ubuntu"

		local NotifCredit = Instance.new("TextLabel")
		NotifCredit.Name = "NotifCredit"
		NotifCredit.Parent = NotifGui
		NotifCredit.Size = UDim2.new(0, 275, 0, 5)
		NotifCredit.BorderSizePixel = 0
		NotifCredit.Text = "Developed by wut#8866"
		NotifCredit.Position = UDim2.new(0, 2050, 0, 965)
		NotifCredit.BackgroundColor3 = Color3.new(40 / 255, 40 / 255, 40 / 255)
		NotifCredit.TextColor3 = Color3.new(Console_Color.R * 0.65, Console_Color.G * 0.65, Console_Color.B * 0.65)
		NotifCredit.TextSize = 12
		NotifCredit.Font = "Ubuntu"

        function repos(x)
            NotifFiller.Position = UDim2.new(0, x, 0, 935)
            NotifColorBar.Position = UDim2.new(0, x, 0, 935)
            NotifTitle.Position = UDim2.new(0, x, 0, 973)
            NotifCredit.Position = UDim2.new(0, x, 0, 1000)
        end

        local increment = 27
        local current_x = 2485
        local anim
        anim = RunService.Heartbeat:Connect(function(step)
            counter = counter + step
            if counter >= desiredInterval then
                counter = counter - desiredInterval
                
                if increment > 0 then
                    current_x -= increment
                    repos(current_x)
                    increment -= 0.5
                else
                    anim:Disconnect()
                    wait(3)
                    anim_mid()
                end

            end
        end)

        function anim_mid()

            local anim
            anim = RunService.Heartbeat:Connect(function(step)
                counter = counter + step
                if counter >= desiredInterval then
                    counter = counter - desiredInterval
                    
                    if increment > -18.5 then
                        current_x -= increment
                        repos(current_x)
                        increment -= 0.5
                    else
                        anim:Disconnect()
                        anim_end()
                    end

                end
            end)
        end

        function anim_end()

            NotifGui:Destroy()
            Showing_Credits = false

        end
    end
end
showcredits()