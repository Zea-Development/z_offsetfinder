---@class MarkerDataStruct
---@field position vector3
---@field scale integer
---@field colour? vector4

---@class Resource
---@field name string
---@field incrementSpeed integer
---@field isFinderActive boolean
Resource = Resource or {}
Resource.name = GetCurrentResourceName()
Resource.incrementSpeed = 0.01
Resource.currentVehicle = 0
Resource.isFinderActive = false

------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # -------------
---@section Helper Functions

---@param marker_data MarkerDataStruct
local function draw_debug_marker(type, marker_data)
    local types = {
        sphere = 28,
        circle = 25,
        cylinder = 1,
        cone = 0
    }

    local position = marker_data.position
    local scale = marker_data.scale or 0.1
    local colour = marker_data.colour or vector4(0, 168, 255, 150)

    ---@diagnostic disable
    DrawMarker(
        types[type] or 28,
        position.x, position.y, position.z,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        scale, scale, scale,
        colour[1], colour[2], colour[3], colour[4],
        false, true, 2,
        nil, nil, false, false
    )
    ---@diagnostic enable
end

Resource.drawDebugMarker = draw_debug_marker

---@param type string
---@param offset vector3
---@return vector3
local function update_offset(type, offset)
    ---@param x number
    ---@param y number
    ---@param z number
    ---@return vector3
    local function move(x, y, z)
        return vector3(x * Resource.incrementSpeed, y * Resource.incrementSpeed, z * Resource.incrementSpeed)
    end

    local actions = {
        FORWARD  = move(0, 1, 0),
        BACKWARD = move(0, -1, 0),
        LEFT     = move(-1, 0, 0),
        RIGHT    = move(1, 0, 0),
        UP       = move(0, 0, 1),
        DOWN     = move(0, 0, -1)
    }

    return offset + actions[type]
end

Resource.updateOffset = update_offset

---@param entity integer
---@param opacity integer
local function set_opacity(entity, opacity)
    if entity <= 0 or not DoesEntityExist(entity) then
        return
    end

    SetEntityAlpha(entity, opacity, false)
end

Resource.setOpacity = set_opacity

local function finder_reset()
    Resource.setOpacity(Resource.currentVehicle, 255)
    FreezeEntityPosition(Resource.currentVehicle, false)
    Resource.currentVehicle = 0
end

Resource.finderReset = finder_reset

---@param player_ped integer
local function finder_thread(player_ped)
    local _offset = vector3(0.0, 0.0, 0.0)
    local enum = Enum.eUserInputs
    local direction_map = {
        [cfg.Keybinds.forward]  = "FORWARD",
        [cfg.Keybinds.backward] = "BACKWARD",
        [cfg.Keybinds.left]     = "LEFT",
        [cfg.Keybinds.right]    = "RIGHT",
        [cfg.Keybinds.up]       = "UP",
        [cfg.Keybinds.down]     = "DOWN"
    }
    local keys_to_disable = {
        Enum.eUserInputs[cfg.Keybinds.forward],
        Enum.eUserInputs[cfg.Keybinds.backward],
        Enum.eUserInputs[cfg.Keybinds.left],
        Enum.eUserInputs[cfg.Keybinds.right],
        Enum.eUserInputs[cfg.Keybinds.up],
        Enum.eUserInputs[cfg.Keybinds.down],
        Enum.eUserInputs[cfg.Keybinds.reset],
        Enum.eUserInputs[cfg.Keybinds.save],
        32,
        34,
        31,
        30,
        59,
        71,
        72,
        75,
        80
    }

    Nui.keybinds({
        [cfg.Keybinds.forward] = "Forward",
        [cfg.Keybinds.backward] = "Backward",
        [cfg.Keybinds.left] = "Left",
        [cfg.Keybinds.right] = "Right",
        [cfg.Keybinds.up] = "Up",
        [cfg.Keybinds.down] = "Down",
        [cfg.Keybinds.reset] = "Reset",
        [cfg.Keybinds.save] = "Copy"
    })

    while Resource.isFinderActive do
        local vehicle = GetVehiclePedIsIn(player_ped, false)
        if vehicle ~= Resource.currentVehicle then
            Resource.isFinderActive = false
            Resource.finderReset()

            Nui.notification(2500, {
                setTitle = "Info",
                setDescription = ("Finder Mode set to: %s"):format(tostring(Resource.isFinderActive)),
                setType = Enum.eNotificationTypes.info,
            })
        end

        for _, control_index in pairs(keys_to_disable) do
            DisableControlAction(0, control_index, true)
        end

        local _markerPos = GetOffsetFromEntityInWorldCoords(vehicle, _offset.x, _offset.y, _offset.z)
        Resource.drawDebugMarker("sphere", {
            position = _markerPos,
            scale = 0.05
        })

        for key, direction in pairs(direction_map) do
            if IsDisabledControlPressed(0, enum[key]) then
                _offset = Resource.updateOffset(direction, _offset)
            end
        end

        if IsDisabledControlJustPressed(0, enum[cfg.Keybinds.reset]) then
            _offset = vector3(0.0, 0.0, 0.0)

            Nui.notification(2500, {
                setTitle = "Info",
                setDescription = "Offset reset to vec3(0.0, 0.0, 0.0)",
                setType = Enum.eNotificationTypes.info,
            })
        elseif IsDisabledControlJustPressed(0, enum[cfg.Keybinds.save]) then
            SendNUIMessage({
                type = "copy",
                load = ("vector3(%f, %f, %f)"):format(_offset.x, _offset.y, _offset.z),
            })

            Nui.notification(2500, {
                setTitle = "Success",
                setDescription = "Copied to your clipboard! Pease use CTRL+V.",
                setType = Enum.eNotificationTypes.success,
            })
        end

        Wait(0)
    end

    Nui.keybinds(nil)
end

Resource.finderThread = finder_thread

------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------
