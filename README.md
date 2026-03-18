# terminal_to_chatgpt
Bridge your terminal and ChatGPT - send command output instantly with a hotkey
⸻
Overview
This tool captures your terminal command + output, formats it, and pastes it into the ChatGPT macOS app automatically.
Workflow:
Terminal → runlog → JSON → formatter → Hammerspoon → ChatGPT
⸻
Environment
This project has been tested on:
	•	macOS (Sonoma / Apple Silicon)
	•	zsh (default macOS shell)
	•	Python 3
	•	Hammerspoon
Make sure you are using the ChatGPT desktop app (not browser).
⸻
Project structure
chatgpt-terminal-bridge/
├─ mac/
│  └─ init.lua
├─ shell/
│  └─ runlog.sh
├─ shared/
│  └─ formatter.py
⸻
Install dependencies
1. Install Hammerspoon
Download:
https://www.hammerspoon.org/
Move it to Applications and launch it.
Enable permissions:
System Settings
→ Privacy & Security
→ Accessibility → enable Hammerspoon
→ Screen Recording → enable Hammerspoon
⸻
2. Clone the repository
'''
cd ~/Documents
git clone https://github.com/YOUR_USERNAME/chatgpt-terminal-bridge.git
cd chatgpt-terminal-bridge
'''
⸻
3. Install Hammerspoon config
Copy the config: 'cp mac/init.lua ~/.hammerspoon/init.lua'
Reload Hammerspoon: 'hs.reload()'
You should see: 'Hammerspoon loaded: Ctrl+Cmd+G sends last terminal output to ChatGPT'
⸻
5. Configure the formatter path
Open your Hammerspoon configuration: 'open ~/.hammerspoon/init.lua'
Locate the following line: 'local FORMATTER_CMD = "cd ... && ./.venv/bin/python formatter.py"'
Update it to match the location where you cloned the repository.
After editing the file, reload Hammerspoon: 'hs.reload()'
If everything is configured correctly, you should see: "Hammerspoon loaded: Ctrl+Cmd+G sends last terminal output to ChatGPT"
⸻
4. Enable terminal logging
Add runlog to your shell:
'''
echo 'source ~/Documents/customization/chatgpt_terminal_bridge/shell/runlog.sh' >> ~/.zshrc
source ~/.zshrc
'''
⸻
Usage
Run commands using runlog:
'''
runlog ls
runlog pwd
runlog npm run dev
'''
Then press: 'Ctrl + Cmd + G'
The output will be sent to ChatGPT automatically.
⸻
Example
Command: runlog ls
ChatGPT receives:
'''
I ran this terminal command:

ls

Current directory:
/Users/user/project

Exit code: 0

Output:
...
'''
