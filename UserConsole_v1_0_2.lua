getgenv().Player = game.Players.LocalPlayer
getgenv().Camera = game.Workspace.Camera
getgenv().UserInputService = game:GetService("UserInputService")
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
getgenv().Console_Active = false


getgenv().BindTable = {}
table.insert(BindTable, ".")
table.insert(BindTable, "console")

getgenv().Chatcolor_RGB = false

getgenv().Stalk_Target = ""

getgenv().Console_RGB = false
getgenv().Console_Color = Color3.new(1, 1, 1)

getgenv().Fly_Enabled = false
getgenv().Fly_Speed = 100
getgenv().Fly_GravComp = 5.5

game:GetService("UserInputService").InputBegan:connect(function(input)

	if Console_Active then
		if (input.KeyCode == Enum.KeyCode.Return) then
			game.Workspace.Camera.CameraType = "Custom"
			console_exec(ConsoleInputBox.Text)
		end
	else
		for i, v in pairs(BindTable) do
			if v == string.char(input.KeyCode.Value) then
				console_exec(BindTable[i+1])
			end
		end
	end
end)





function console_spawn()

    getgenv().ConsoleGui = Instance.new("ScreenGui")
    ConsoleGui.Parent = Player.PlayerGui
    ConsoleGui.Name = "ConsoleGui"

    getgenv().ConsoleInputFiller = Instance.new("Frame")
    ConsoleInputFiller.Name = "ConsoleInputFiller"
    ConsoleInputFiller.Parent = ConsoleGui
    ConsoleInputFiller.Size = UDim2.new(1, 0, 0.05, 0)
    ConsoleInputFiller.BorderSizePixel = 0
    ConsoleInputFiller.Position = UDim2.new(0, 0, 0.95, 0)
    ConsoleInputFiller.BackgroundColor3 = Color3.new(40 / 255, 40 / 255, 40 / 255)

    getgenv().ConsoleInputSign = Instance.new("TextLabel")
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

    getgenv().ConsoleInputBox = Instance.new("TextBox")
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
    ConsoleInputBox.PlaceholderColor3 = Color3.new(0.44, 0.44, 0.44)
	Console_Active = true

	wait(0.03)
	ConsoleInputBox:CaptureFocus()
    ConsoleInputBox.Text = ""
	

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
			getgenv().Chatcolor_Custom = Color3.new(args[2]/255, args[3]/255, args[4]/255)
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
			Console_Active = true
		elseif (args[2]:upper() == "COLOR") then
			if (args[3]:upper() == "RGB") then
				Console_RGB = not Console_RGB
			else
				getgenv().Console_Color = Color3.new(args[3]/255, args[4]/255, args[5]/255)
			end
		end
	end

end






local t = 5
local RunService = game:GetService("RunService")
local desiredInterval = 0.05
local counter = 0
RunService.Heartbeat:Connect(function(step)
    counter = counter + step
    if counter >= desiredInterval then
        counter = counter - desiredInterval
		
		
		for i, v in pairs(Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Frame_MessageLogDisplay.Scroller:GetChildren()) do
			if v.Name == "Frame" then
				if not (v.TextLabel:GetChildren()[1] == nil) then
					if v.TextLabel.TextButton.Text == "[" .. Player.DisplayName .. "]:" then
						if Chatcolor_RGB then
							local hue = tick() % t / t
                            local color = Color3.fromHSV(hue,1,1) 
                            v.TextLabel.TextButton.TextColor3  = color
						elseif not (Chatcolor_Custom == nil) then
							v.TextLabel.TextButton.TextColor3  = Chatcolor_Custom
						end
					end
				end
			end
		end
		

		if Fly_Enabled then
            
            local vel_x = 0
            local vel_y = Fly_GravComp
            local vel_z = 0
            
            if (Console_Active == false) then

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
			Player.Character.HumanoidRootPart.CFrame = game.Players[Stalk_Target].Character.HumanoidRootPart.CFrame
		end
		
		
		if Console_Active then
		
			if Console_RGB then
				local hue = tick() % t / t
				local color = Color3.fromHSV(hue,1,1) 
				ConsoleInputSign.TextColor3 = color
				ConsoleInputBox.PlaceholderColor3 = Color3.new(color.R * 0.44, color.G * 0.44, color.B * 0.44)
				ConsoleInputBox.TextColor3 = color
			end
			
		end

    end
end)