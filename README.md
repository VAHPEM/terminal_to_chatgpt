terminal_to_chatgpt

Bridge your terminal and ChatGPT — send command output instantly with a hotkey.

--------------------------------------------------

WHAT THIS TOOL DOES

Run a terminal command → capture its output → send it directly to ChatGPT.

No manual copy-paste.

--------------------------------------------------

WORKFLOW

Terminal command
↓
runlog
↓
/tmp/chatgpt_terminal_last.json
↓
formatter.py
↓
Hammerspoon hotkey
↓
ChatGPT

--------------------------------------------------

ENVIRONMENT

Tested on:

macOS (Apple Silicon)
zsh (default macOS shell)
Python 3
Hammerspoon

Use the ChatGPT desktop app (not browser).

--------------------------------------------------

PROJECT STRUCTURE

terminal_to_chatgpt/
    mac/
        init.lua
    shell/
        runlog.sh
    shared/
        formatter.py

--------------------------------------------------

INSTALLATION

1. Install Hammerspoon

Download:

https://www.hammerspoon.org/

Move it to Applications and launch it.

Enable permissions:

System Settings
→ Privacy & Security
→ Accessibility → enable Hammerspoon
→ Screen Recording → enable Hammerspoon

--------------------------------------------------

2. Clone the repository

cd ~/Documents
git clone https://github.com/YOUR_USERNAME/terminal_to_chatgpt.git
cd terminal_to_chatgpt

--------------------------------------------------

3. Install Hammerspoon config

cp mac/init.lua ~/.hammerspoon/init.lua

Reload Hammerspoon:

hs.reload()

You should see:

Hammerspoon loaded: Ctrl+Cmd+G sends last terminal output to ChatGPT

--------------------------------------------------

4. Configure formatter path

Open the Hammerspoon config:

open ~/.hammerspoon/init.lua

Find this line:

local FORMATTER_CMD = "cd ~/Documents/custmization/chatgpt_terminal_bridge && ./.venv/bin/python formatter.py"

Change it to match your repository path.

Example:

local FORMATTER_CMD = 'cd "/Users/YOUR_USERNAME/Documents/terminal_to_chatgpt" && python3 shared/formatter.py'

Reload Hammerspoon again:

hs.reload()

--------------------------------------------------

5. Enable terminal logging

Add runlog to your shell:

echo 'source ~/Documents/terminal_to_chatgpt/shell/runlog.sh' >> ~/.zshrc
source ~/.zshrc

--------------------------------------------------

USAGE

Run commands using runlog:

runlog ls
runlog pwd
runlog npm run dev

Then press:

Ctrl + Cmd + G

The command output will automatically be sent to ChatGPT.

--------------------------------------------------

EXAMPLE

Command:

runlog ls

ChatGPT receives:

I ran this terminal command:

ls

Current directory:
/Users/user/project

Exit code: 0

Output:
...

--------------------------------------------------

TROUBLESHOOTING

If formatter.py fails:

cat /tmp/chatgpt_terminal_last.json

If the file does not exist:

runlog ls

--------------------------------------------------

If runlog is not found:

source ~/.zshrc

--------------------------------------------------

If ChatGPT window is not detected:

Make sure:

ChatGPT app is running
ChatGPT window is visible
Hammerspoon has Accessibility permission
