---@script core/client/classes/nui.lua

---@class NotificationStruct
---@field setTitle string
---@field setDescription string
---@field setType string

---@class Nui
---@field focus fun(focus: boolean, cursor: boolean)
---@field notification fun(setTimeout: integer, notificationData: NotificationStruct)

Nui = Nui or {}

------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # -------------

---@param focus boolean
---@param cursor boolean
local function set_focus(focus, cursor)
    SetNuiFocus(focus, cursor)
end

Nui.focus = set_focus

---@param timeout integer
---@param notification_data NotificationStruct
local function create_notification(timeout, notification_data)
    SendNUIMessage({
        type = 'notification',
        load = {
            setTimeout = timeout,
            setTitle = notification_data.setTitle,
            setDescription = notification_data.setDescription,
            setType = notification_data.setType
        }
    })
end

Nui.notification = create_notification

---@param keybinds table | nil
local function display_keybinds(keybinds)
    if keybinds == nil then
        SendNUIMessage({
            type = 'keybinds-hide',
        })
        return
    end

    SendNUIMessage({
        type = 'keybinds-show',
        load = {
            setContext = keybinds,
        }
    })
end

Nui.keybinds = display_keybinds

------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # -------------
