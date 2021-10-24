getgenv().Controller = require(game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
getgenv().Player = game.Players.LocalPlayer
getgenv().UserInputService = game:GetService("UserInputService")
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
getgenv().Console_Active = false
getgenv().ConsoleInput = ""

getgenv().Fly_Enabled = false
getgenv().Fly_Speed = 100
getgenv().Fly_GravComp = 5.5


game:GetService("UserInputService").InputBegan:connect(function(input)

	if Console_Active then
        if input.UserInputType == Enum.UserInputType.Keyboard then

            
            if not (input.KeyCode == Enum.KeyCode.Backspace) then
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    ConsoleInput = ConsoleInput .. string.char(input.KeyCode.Value):upper()
                else
                    ConsoleInput = ConsoleInput .. string.char(input.KeyCode.Value)
                end
            else
                ConsoleInput = ConsoleInput:sub(1, -2)
            end


            ConsoleInputBox.Text = "> " .. ConsoleInput


            if (input.KeyCode == Enum.KeyCode.Return) then
                Controller:Enable()
                game.Workspace.Camera.CameraType = "Custom"
                
                console_exec(ConsoleInput)
                ConsoleInput = ""

                ConsoleGui:Destroy()
                Console_Active = false
            end

        end
       
    end

    if (input.KeyCode == Enum.KeyCode.Period and Console_Active == false) then
        console_spawn()
        Console_Active = true
        ConsoleInputBox.Text = "> "
    end

end)






function console_spawn()

    Controller:Disable()
    game.Workspace.Camera.CameraType = "Scriptable"

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


    getgenv().ConsoleInputBox = Instance.new("TextLabel")
    ConsoleInputBox.Name = "ConsoleInput"
    ConsoleInputBox.Parent = ConsoleGui
    ConsoleInputBox.Size = UDim2.new(1, 0, 0.05, 0)
    ConsoleInputBox.BorderSizePixel = 0
    ConsoleInputBox.Position = UDim2.new(0, 22, 0.95, 0)
    ConsoleInputBox.BackgroundColor3 = Color3.new(40 / 255, 40 / 255, 40 / 255)
    ConsoleInputBox.TextColor3 = Color3.new(200 / 255, 200 / 255, 200 / 255)
    ConsoleInputBox.TextSize = 25
    ConsoleInputBox.TextXAlignment = "Left"
    ConsoleInputBox.Font = "Ubuntu"

end





function console_exec(input)

    local args = {}
    for arg in input:gmatch("%w+") do table.insert(args, arg) end



    if (args[1]:upper() == "FOV") then
        game.Workspace.Camera.FieldOfView = tonumber(args[2])
    end


    if (args[1]:upper() == "TP") then
        Player.Character.HumanoidRootPart.CFrame = game.Players[args[2]].Character.HumanoidRootPart.CFrame
    end


    if (args[1]:upper() == "FLY") then
        
        if (args[2] == nil) then
            if Fly_Enabled then
				Fly_Enabled = false
			else
				Fly_Enabled = true
			end
        
		
		elseif (args[2]:upper() == "SPEED") then
            Fly_Speed = tonumber(args[3])


        elseif (args[2]:upper() == "GRAVCOMP") then
            Fly_GravComp = tonumber(args[3])
        end

    end

end







local RunService = game:GetService("RunService")
local desiredInterval = 0.05
local counter = 0
RunService.Heartbeat:Connect(function(step)
    counter = counter + step
    if counter >= desiredInterval then
        counter = counter - desiredInterval
		
		

		if Fly_Enabled then
            
            local vel_x = 0
            local vel_y = Fly_GravComp
            local vel_z = 0
            
            if (Console_Active == false) then

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    vel_x = vel_x + Player.Character.HumanoidRootPart.CFrame.LookVector.X*Fly_Speed
                    vel_z = vel_z + Player.Character.HumanoidRootPart.CFrame.LookVector.Z*Fly_Speed
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    vel_x = vel_x - Player.Character.HumanoidRootPart.CFrame.LookVector.X*Fly_Speed
                    vel_z = vel_z - Player.Character.HumanoidRootPart.CFrame.LookVector.Z*Fly_Speed
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    vel_x = vel_x + Player.Character.HumanoidRootPart.CFrame.LookVector.Z*Fly_Speed
                    vel_z = vel_z - Player.Character.HumanoidRootPart.CFrame.LookVector.X*Fly_Speed
                end

                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    vel_x = vel_x - Player.Character.HumanoidRootPart.CFrame.LookVector.Z*Fly_Speed
                    vel_z = vel_z + Player.Character.HumanoidRootPart.CFrame.LookVector.X*Fly_Speed
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
    end
end)