-- @param: Please refer to our resource documentation for assistance with configuring this resource: docs.zeadevelopment.com.
------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # -------------
---@class cfg : Configuration
cfg = {}

---@field keybinds table
---@description: Allow for the customization of keybinds utilized by the resource.

cfg.binds = {
    ['forward_bind'] = 'ARROW_UP',
    ['backward_bind'] = 'ARROW_DOWN',
    ['left_bind'] = 'ARROW_LEFT',
    ['right_bind'] = 'ARROW_RIGHT',
    ['up_bind'] = 'LEFT_SHIFT',
    ['down_bind'] = 'LEFT_CTRL',
    ['reset_bind'] = 'R',
    ['save_bind'] = 'ENTER'
}

------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # -------------

cfg.command = 'zhoseConfig' -- Command to toggle the offset finder

cfg.vehicleOpacity = 8 -- Opacity of the vehicle when the offset finder is active

------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # -------------

return cfg