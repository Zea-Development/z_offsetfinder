---@script core/client/classes/enumerators.lua

---@class Enum
---@field eUserInputs table<string, integer>

Enum = Enum or {}

------------- # ------------- # ------------- # ------------- # ------------- # ------------- # ------------- # -------------

---@enum eNotificationTypes
Enum.eNotificationTypes = {
    success = "success",
    error = "error",
    info = "info",
    warning = "warning"
}

---@enum eUserInputs
Enum.eUserInputs = {
    ---|> Function Keys
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,

    ---|> Special Keys
    ["ESC"] = 322,
    ["~"] = 243,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["ENTER"] = 18,
    ["CAPSLOCK"] = 137,
    ["LEFT_SHIFT"] = 21,
    ["LEFT_CTRL"] = 36,
    ["LEFT_ALT"] = 19,
    ["SPACEBAR"] = 22,
    ["RIGHT_SHIFT"] = 229,
    ["RIGHT_CTRL"] = 70,
    ["RIGHT_ALT"] = 230,
    ["HOME"] = 213,
    ["PAGE_UP"] = 10,
    ["PAGE_DOWN"] = 11,
    ["INSERT"] = 121,
    ["DELETE"] = 178,
    ["END"] = 168,
    ["PAUSE"] = 197,

    ---|> Number Keys
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["0"] = 48,

    ---|> Letters
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["J"] = 311,
    ["K"] = 311,
    ["L"] = 182,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,

    ---|> Punctuation
    [","] = 82,
    ["."] = 81,
    ["/"] = 43,
    [";"] = 58,

    ---|> Arrow Keys
    ["ARROW_UP"] = 172,
    ["ARROW_DOWN"] = 173,
    ["ARROW_LEFT"] = 174,
    ["ARROW_RIGHT"] = 175,

    ---|> Mouse Buttons
    ["RIGHT_MOUSE_BUTTON"] = 25,
    ["LEFT_MOUSE_BUTTON"] = 24,
    ["MIDDLE_MOUSE_BUTTON"] = 14,
    ["SCROLLWHEEL_UP"] = 17,
    ["SCROLLWHEEL_DOWN"] = 16,
    ["MOUSE_X"] = 1,
    ["MOUSE_Y"] = 2,

    ---|> Numpad Keys
    ["NUMPAD_0"] = 48,
    ["NUMPAD_1"] = 49,
    ["NUMPAD_2"] = 50,
    ["NUMPAD_3"] = 51,
    ["NUMPAD_4"] = 52,
    ["NUMPAD_5"] = 53,
    ["NUMPAD_6"] = 54,
    ["NUMPAD_7"] = 55,
    ["NUMPAD_8"] = 56,
    ["NUMPAD_9"] = 57,
    ["NUMPAD_PLUS"] = 96,
    ["NUMPAD_MINUS"] = 97,
    ["NUMPAD_ENTER"] = 98,
    ["NUMPAD_DOT"] = 99,

    ---|> Controller Keys
    ["CONTROLLER_A"] = 18,
    ["CONTROLLER_B"] = 45,
    ["CONTROLLER_X"] = 22,
    ["CONTROLLER_Y"] = 23,
    ["CONTROLLER_DPAD_UP"] = 27,
    ["CONTROLLER_DPAD_DOWN"] = 19,
    ["CONTROLLER_DPAD_LEFT"] = 20,
    ["CONTROLLER_DPAD_RIGHT"] = 21,
    ["CONTROLLER_LEFT_BUMPER"] = 37,
    ["CONTROLLER_RIGHT_BUMPER"] = 44,
    ["CONTROLLER_LEFT_TRIGGER"] = 10,
    ["CONTROLLER_RIGHT_TRIGGER"] = 11,
    ["CONTROLLER_LEFT_STICK"] = 13,
    ["CONTROLLER_RIGHT_STICK"] = 14,
    ["CONTROLLER_LEFT_AXIS_X"] = 1,
    ["CONTROLLER_LEFT_AXIS_Y"] = 2,
    ["CONTROLLER_RIGHT_AXIS_X"] = 3,
    ["CONTROLLER_RIGHT_AXIS_Y"] = 4,
    ["CONTROLLER_SELECT"] = 0,
    ["CONTROLLER_START"] = 1,
}
