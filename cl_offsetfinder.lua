local isOffsetCommandActive = false
local configVehicle = nil
local offset = vector3(0.0, 0.0, 0.0)
local defaultSpeed = 0.01
local speed = defaultSpeed
local scaleform = nil

function updateOffset(offset, direction, amount, vehicle)
    local currentPos = GetEntityCoords(vehicle)

    if direction == "FORWARD" then
        offset = offset + vector3(0.0, amount, 0.0)
    elseif direction == "BACKWARD" then
        offset = offset - vector3(0.0, amount, 0.0)
    elseif direction == "LEFT" then
        offset = offset - vector3(amount, 0.0, 0.0)
    elseif direction == "RIGHT" then
        offset = offset + vector3(amount, 0.0, 0.0)
    elseif direction == "UP" then
        offset = offset + vector3(0.0, 0.0, amount)
    elseif direction == "DOWN" then
        offset = offset - vector3(0.0, 0.0, amount)
    end

    return offset
end






function showHelpNotification(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function showNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

RegisterCommand(cfg.command, function(_, args)
    isOffsetCommandActive = not isOffsetCommandActive

    local playerPed = PlayerPedId()

    if not isOffsetCommandActive then
        if configVehicle then
            ResetEntityAlpha(configVehicle)
            configVehicle = nil
        end
        FreezeEntityPosition(playerPed, false)
        speed = defaultSpeed -- Reset speed to default when command is deactivated
        return
    end

    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle and vehicle ~= 0 then
        configVehicle = vehicle
        SetEntityAlpha(configVehicle, cfg.vehicleOpacity * 10, false)
        SetVehicleForwardSpeed(configVehicle, 0) -- Set vehicle speed to 0

        FreezeEntityPosition(playerPed, true)

        Citizen.CreateThread(function()
            while isOffsetCommandActive do
                local markerPos = GetOffsetFromEntityInWorldCoords(configVehicle, offset.x, offset.y, offset.z)

                DrawMarker(28, markerPos.x, markerPos.y, markerPos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.1, 255,
                    0, 0, 200, false, true, 2, nil, nil, false)
                DrawText3D(markerPos.x, markerPos.y, markerPos.z + 0.3, "Offset: " .. offset)

                showHelpNotification("Use ~INPUT_SCRIPTED_FLY_ZUP~ and ~INPUT_SCRIPTED_FLY_ZDOWN~.\nCurrent Speed: " ..
                                         speed)

                if IsControlPressed(0, keybinds[cfg.binds['forward_bind']]) then -- Arrow Up
                    offset = updateOffset(offset, "FORWARD", speed, configVehicle)
                elseif IsControlPressed(0, keybinds[cfg.binds['backward_bind']]) then -- Arrow Down
                    offset = updateOffset(offset, "BACKWARD", speed, configVehicle)
                elseif IsControlPressed(0, keybinds[cfg.binds['left_bind']]) then -- Arrow Left
                    offset = updateOffset(offset, "LEFT", speed, configVehicle)
                elseif IsControlPressed(0, keybinds[cfg.binds['right_bind']]) then -- Arrow Right
                    offset = updateOffset(offset, "RIGHT", speed, configVehicle)
                elseif IsControlPressed(0, keybinds[cfg.binds['up_bind']]) then -- Left Shift
                    offset = updateOffset(offset, "UP", speed, configVehicle)
                elseif IsControlPressed(0, keybinds[cfg.binds['down_bind']]) then -- Left Control
                    offset = updateOffset(offset, "DOWN", speed, configVehicle)
                elseif IsControlJustPressed(0, keybinds[cfg.binds['reset_bind']]) then -- R key
                    offset = vector3(0.0, 0.0, 0.0)
                elseif IsControlJustPressed(0, keybinds[cfg.binds['save_bind']]) then
                    showNotification("~g~Offset copied to clipboard")
                    print("Offset saved: ", offset.x, offset.y, offset.z)
                    local coords = string.format("vector3(%f, %f, %f)", offset.x, offset.y, offset.z)
                    SendNUIMessage({
                        type = "clipboard",
                        data = coords
                    })
                elseif IsControlJustPressed(0, 10) then -- Page Up
                    if IsControlPressed(0, 19) then
                        speed = speed + 0.002 -- Double the increment if Left Alt is held
                    else
                        speed = speed + 0.001 -- Regular increment
                    end
                elseif IsControlJustPressed(0, 11) then -- Page Down
                    if IsControlPressed(0, 19) then
                        speed = speed - 0.002 -- Double the decrement if Left Alt is held
                    else
                        speed = speed - 0.001 -- Regular decrement
                    end
                    if speed < 0.001 then
                        speed = 0.001
                    end
                end

                -- Disable all controls except the ones used for offset adjustment
                DisableControlAction(0, 32, true) -- MoveUpDown
                DisableControlAction(0, 34, true) -- MoveLeftRight
                DisableControlAction(0, 31, true) -- MoveUpDown
                DisableControlAction(0, 30, true) -- MoveLeftRight
                DisableControlAction(0, 59, true) -- Disable steering in vehicle
                DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
                DisableControlAction(0, 72, true) -- Disable reversing in vehicle
                DisableControlAction(0, 75, true) -- Disable exiting vehicle
                DisableControlAction(0, 80, true) -- Disable Cinematic Cam

                Citizen.Wait(0)
            end

            if configVehicle then
                ResetEntityAlpha(configVehicle)
                configVehicle = nil
            end
            FreezeEntityPosition(playerPed, false)
        end)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end
