# Start Keymando at login
# -----------------------------------------------------------
start_at_login

# Disable Keymando when using these applications
# -----------------------------------------------------------
disable "Remote Desktop Connection"

# Basic mapping
# -----------------------------------------------------------
only /Chrome/ do
  map "<Ctrl-w>", "<Cmd-w>"
  map "<Ctrl-r>", "<Cmd-r>"
  map "<Ctrl-t>", "<Cmd-t>"
end

# Commands
# -----------------------------------------------------------

# Command launcher window via Cmd-Space
map "<Cmd- >" do
  trigger_item_with(Commands.items, RunRegisteredCommand.new)
end

# Register commands
# -----------------------------------------------------------
command "Volume Up" do
  `osascript -e 'set volume output volume (output volume of (get volume settings) + 7)'`
end

command "Volume Down" do
  `osascript -e 'set volume output volume (output volume of (get volume settings) - 7)'`
end

# Repeat last command via Cmd-.
map "<Cmd-.>", RunLastCommand.instance

# -----------------------------------------------------------
# Visit http://keymando.com to see what else Keymando can do!
# -----------------------------------------------------------
