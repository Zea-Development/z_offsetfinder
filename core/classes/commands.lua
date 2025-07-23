---@script core/client/classes/commands.lua

---@class CommandStruct
---@field input string
---@field description string
---@field parameters? table

---@class command
---@field commands table<string, CommandStruct>
---@field suggestion fun(command: string, description: string, parameters: table)

Command = Command or {}
Command.commands = {
    toggle_finder = {
        input = 'offset:finder',
        description = 'Toggle the offset finder mode.'
    },
}

------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # -------------

---@param command string
---@param description string
---@param parameters table?
local function create_suggestion(command, description, parameters)
    TriggerEvent('chat:addSuggestion', ('/%s'):format(command),
        ('[%s] %s'):format(Resource.name, description), parameters)
end

Command.suggestion = create_suggestion

------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # -------------

for k, v in pairs(Command.commands) do
    Command.suggestion(v.input, v.description, v.parameters or {})
end

------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # -------------

--[[
    ## Toggle Finder
]]
RegisterCommand(Command.commands.toggle_finder.input, function()
    local player_ped = PlayerPedId()

    local vehicle = GetVehiclePedIsIn(player_ped, false)
    if not vehicle or vehicle <= 0 then
        return Nui.notification(2500, {
            setTitle = "Info",
            setDescription = "You must be seated within a vehicle when using this command.",
            setType = Enum.eNotificationTypes.info,
        })
    end

    if Resource.isFinderActive == false then
        Resource.currentVehicle = vehicle
        Resource.setOpacity(vehicle, 80)

        FreezeEntityPosition(Resource.currentVehicle, true)
    else
        Resource.finderReset()
    end

    Resource.isFinderActive = not Resource.isFinderActive
    Nui.notification(2500, {
        setTitle = "Info",
        setDescription = ("Finder Mode set to: %s"):format(tostring(Resource.isFinderActive)),
        setType = Enum.eNotificationTypes.info,
    })

    CreateThread(function()
        Resource.finderThread(player_ped)
    end)
end, false)
