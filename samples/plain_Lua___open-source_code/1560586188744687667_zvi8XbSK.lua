-- UI
do
    local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua'))();
    local window = library:CreateWindow({
        Title = "Blockspin AutoFarm | Made By @dementia_enjoyr",
        Center = true,
        AutoShow = true,
        TabPadding = 8,
        MenuFadeTime = 0.2
    });

    local farm = window:AddTab("Farming"); do
        local steakhouse_enabled = farm:AddLeftGroupbox("Steak House"); do
            steakhouse_enabled:AddToggle("autofarm_enabled", {
                Text = "Enabled",
                Tooltip = "Make sure to be inside of the kitchen when you enable this.",
            });

            steakhouse_enabled:AddToggle("safe_mode", {
                Text = "Safe Mode",
                Default = true,
                Tooltip = "Kills your character so that others cannot kill you, you will still work.",
            });

            steakhouse_enabled:AddToggle("get_steak", {
                Text = "Automatically get steak",
                Default = true,
                Tooltip = "Picks up the steak for you",
            });
        end
    end
end

-- Services
local run_service = game:GetService("RunService");
local players = game:GetService("Players");
local replicated_storage = game:GetService("ReplicatedStorage");
local virtual_input_manager = game:GetService("VirtualInputManager");

-- Variables
local local_player = players.LocalPlayer;
local player_gui = local_player.PlayerGui;

local map = workspace.Map;
local tiles = map.Tiles;

local steak_house = tiles.ShoppingTile.SteakHouse;
local steak_interior = steak_house.Interior;

local old_position = nil;
local updated = tick();

-- Main
do
    local get_proximity_prompt = function(ancestor)
        for _, descendant in ancestor:GetDescendants() do
            if (descendant.ClassName == "ProximityPrompt") then
                return descendant;
            end
        end
    end

    local click_button = function(button)
        local absolute_position = button.AbsolutePosition;
        local absolute_size = button.AbsoluteSize;
        local click_position = Vector2.new(absolute_position.X + (absolute_size.X / 2), absolute_position.Y + absolute_size.Y);

        local x, y = click_position.X, click_position.Y;

        virtual_input_manager:SendMouseButtonEvent(x, y, 0, true, game, 1);
        task.wait();
        virtual_input_manager:SendMouseButtonEvent(x, y, 0, false, game, 1);
    end

    run_service.RenderStepped:Connect(function()
        if (Toggles.autofarm_enabled.Value and tick() - updated >= .3) then
            if (Toggles.safe_mode.Value) then
                pcall(function()
                    require(replicated_storage.Modules.Core.Net).send("request_respawn");
                end)
            end

            local character = local_player.Character;
            local root = (character and character:FindFirstChild("HumanoidRootPart"));
            
            if (root) then
                local proximity_prompt = get_proximity_prompt(steak_interior.Fridge);
                local job = local_player:GetAttribute("Job");
                
                if (job ~= "steakhouse_cook") then
                    local touch = steak_interior.SteakHouseBeacon.TouchPart;

                    if (touch) then
                        root.CFrame = root.CFrame:Lerp(touch.CFrame, .5);
                        task.spawn(click_button, player_gui.JobApplication.JobApplicationFrame.ApplyJob);
                    end
                else
                    local progress_bar_frame = player_gui.ProgressBar.ProgressBarFrame;
                    
                    local main_frame = progress_bar_frame.MainFrame;
                    local input_frame = progress_bar_frame.InputFrame;

                    if (proximity_prompt and not progress_bar_frame.Visible) then
                        if (Toggles.get_steak.Value) then
                            local end_cf = proximity_prompt.Parent.Parent.CFrame;
                            root.CFrame = CFrame.new(end_cf.Position + (end_cf.LookVector * 6), end_cf.Position);

                            run_service.Heartbeat:Wait();

                            fireproximityprompt(proximity_prompt, 1);
                        end
                    end
                    
                    local beacon = workspace:FindFirstChild("Beacon");
                    local base = (beacon and beacon.Base);
    
                    if (base) then
                        root.CFrame = base.CFrame;
                    end
    
                    local bar = main_frame.BarAmount;
                    local cooked_perfectly = main_frame.CookedPerfectly;
    
                    if (progress_bar_frame.Visible and bar and cooked_perfectly) then
                        if (bar.Size.X.Scale >= cooked_perfectly.Position.X.Scale) then
                            task.spawn(click_button, input_frame.FinishBar);
                        end
                    end
                end

                updated = tick();
            end
        end
    end)
end