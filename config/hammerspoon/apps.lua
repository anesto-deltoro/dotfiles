local function toggleApplication(name)
  local app = hs.application.find(name)
  if not app or app:isHidden() then
    hs.application.launchOrFocus(name)
  elseif hs.application.frontmostApplication() ~= app then
    app:activate()
  else
    app:hide()
  end
end

hs.hotkey.bind(mash, "c", function() toggleApplication("Visual Studio Code") end)
hs.hotkey.bind(mash, "t", function() toggleApplication("Terminal") end)
hs.hotkey.bind(mash, "f", function() toggleApplication("Finder") end)
hs.hotkey.bind(mash, "m", function() toggleApplication("Mail") end)
hs.hotkey.bind(mash, "p", function() toggleApplication("System Preferences") end)
hs.hotkey.bind(mash, "w", function() toggleApplication("WhatsApp") end)
hs.hotkey.bind(mash, "n", function() toggleApplication("Notion") end)
hs.hotkey.bind(mash, "s", function() toggleApplication("Slack") end)
hs.hotkey.bind(mash, "z", function() toggleApplication("IntelliJ IDEA CE") end)
hs.hotkey.bind(mash, "d", function() toggleApplication("Docker") end)
hs.hotkey.bind(mash, "v", function() toggleApplication("Google Drive") end)

hs.hotkey.bind(mash, "e", function() toggleApplication("Google Chrome") end)
hs.hotkey.bind(mash, "g", function() toggleApplication("SourceTree") end)
