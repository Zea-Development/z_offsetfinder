local isOffsetCommandActive = false
local configVehicle = nil
local offset = vector3(0.0, 0.0, 0.0)
local defaultSpeed = 0.01
local speed = defaultSpeed

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
        speed = defaultSpeed
        
        return
    end

    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle and vehicle ~= 0 then
        configVehicle = vehicle
        SetEntityAlpha(configVehicle, 80, false)
        SetVehicleForwardSpeed(configVehicle, 0)

        FreezeEntityPosition(playerPed, true)

        Citizen.CreateThread(function()
            while isOffsetCommandActive do
                local vehiclePos = GetEntityCoords(configVehicle, false)
                local markerPos = GetOffsetFromEntityInWorldCoords(configVehicle, offset.x, offset.y, offset.z)

                for _, Cindex in pairs({32, 34, 31, 30, 59, 71, 72, 75}) do 
                    DisableControlAction(0, Cindex, true)
                end

                DrawMarker(28, markerPos.x, markerPos.y, markerPos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.08, 0.08, 0.08, 255, 255, 0, 85, false, true, 2, nil, nil, false)
                DrawText3D(markerPos.x, markerPos.y, markerPos.z + 0.3, "Offset: " .. offset)

                showHelpNotification("Use ~INPUT_SCRIPTED_FLY_ZUP~ and ~INPUT_SCRIPTED_FLY_ZDOWN~.\nCurrent Speed: " .. speed)

                if IsControlPressed(0, keybinds[cfg.keybinds['forward_bind']]) then -- Arrow Up
                    offset = updateOffset(offset, "FORWARD", speed, configVehicle)
                elseif IsControlPressed(0, keybinds[cfg.keybinds['backward_bind']]) then -- Arrow Down
                    offset = updateOffset(offset, "BACKWARD", speed, configVehicle)
                elseif IsControlPressed(0, keybinds[cfg.keybinds['left_bind']]) then -- Arrow Left
                    offset = updateOffset(offset, "LEFT", speed, configVehicle)
                elseif IsControlPressed(0, keybinds[cfg.keybinds['right_bind']]) then -- Arrow Right
                    offset = updateOffset(offset, "RIGHT", speed, configVehicle)
                elseif IsControlPressed(0, keybinds[cfg.keybinds['up_bind']]) then -- Left Shift
                    offset = updateOffset(offset, "UP", speed, configVehicle)
                elseif IsControlPressed(0, keybinds[cfg.keybinds['down_bind']]) then -- Left Control
                    offset = updateOffset(offset, "DOWN", speed, configVehicle)
                elseif IsControlJustPressed(0, keybinds[cfg.keybinds['reset_bind']]) then -- R key
                    offset = vector3(0.0, 0.0, 0.0)
                elseif IsControlJustPressed(0, keybinds[cfg.keybinds['save_bind']]) then
                    showNotification("~g~Offset copied to clipboard")
                    SendNUIMessage({
                        type = "clipboard",
                        data = string.format("vector3(%f, %f, %f)", offset.x, offset.y, offset.z)
                    })
                end

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
