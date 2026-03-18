local CHATGPT_APP_NAME = "ChatGPT"
local FORMATTER_CMD = "cd ... && ./.venv/bin/python formatter.py"
local HOTKEY_MODS = {"ctrl", "cmd"}
local HOTKEY_KEY = "G"

local function trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function readFormattedPrompt()
    local output, status, _, rc = hs.execute(FORMATTER_CMD, true)

    if not status or rc ~= 0 then
        return nil, "formatter.py failed:\n" .. tostring(output)
    end

    output = trim(output or "")
    if output == "" then
        return nil, "formatter.py returned empty output"
    end

    return output, nil
end

local function findChatGPTWindow()
    local app = hs.appfinder.appFromName(CHATGPT_APP_NAME)
    if not app then
        return nil, "ChatGPT app is not running"
    end

    local win = app:mainWindow()
    if not win then
        local wins = app:allWindows()
        if wins and #wins > 0 then
            win = wins[1]
        end
    end

    if not win then
        return nil, "No ChatGPT window found"
    end

    return win, nil
end

local function sendLastTerminalOutputToChatGPT()
    local formatted, err = readFormattedPrompt()
    if not formatted then
        hs.alert.show(err)
        return
    end

    local win, winErr = findChatGPTWindow()
    if not win then
        hs.alert.show(winErr)
        return
    end

    hs.pasteboard.setContents(formatted)

    local app = win:application()
    app:activate()
    win:focus()

    hs.timer.doAfter(0.35, function()
        hs.eventtap.keyStroke({"cmd"}, "v")

        hs.timer.doAfter(0.15, function()
            hs.eventtap.keyStroke({}, "return")
        end)
    end)
end

hs.hotkey.bind(HOTKEY_MODS, HOTKEY_KEY, sendLastTerminalOutputToChatGPT)

hs.alert.show("Hammerspoon loaded: Ctrl+Cmd+G sends last terminal output to ChatGPT")