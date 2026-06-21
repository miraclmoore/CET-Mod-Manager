---@class CETMM
CETMM = {}

local m_gui     ---@type gui
local m_event   ---@type event
local m_hotkeys ---@type hotkeys
local m_options ---@type options
local m_locale  ---@type locale
local m_dofiles ---@type dofiles
local m_version ---@type string
local m_backend ---@type backend
local m_uninstalled = false

function CETMM.GetUISystem()
  return m_gui
end

function CETMM.GetOptions()
  return m_options
end

function CETMM.GetLocale()
  return m_locale
end

function CETMM.GetDofiles()
  return m_dofiles
end

function CETMM.GetVersion()
  return m_version
end

function CETMM.GetBackEnd()
  return m_backend
end

function CETMM.IsUninstalled()
  return m_uninstalled
end

function CETMM.Initialize()
  m_options = require ("modules/options")
  m_locale = require ("modules/locale")
  m_dofiles = require ("modules/dofiles")
  m_event = require ("modules/event")
  m_hotkeys = require("modules/hotkeys")
  m_version = require ("modules/version")

  -- Load config
  m_options.Load()
  m_locale.Initialize()

  registerForEvent("onInit", function()
    local ok, err = pcall(function()
      -- init
      if CETMMEXT == nil then
        error("CETMMEXT global is nil — RED4ext plugin may not have loaded correctly")
      end
      m_backend = require ("modules/backend")
      m_uninstalled = m_backend.GetUninstall().IsAsiRemoved()
      if not m_uninstalled then
        m_backend.GetMods().Scan()
        m_dofiles.Scan()
      end
      m_gui = require ("modules/gui")
    end)
    if not ok then
      spdlog.error("[CETMM] onInit failed: " .. tostring(err))
    end
  end)
end

function CETMM.Update()
  registerForEvent("onUpdate", function()

  end)
end

function CETMM.Event() -- Hotkey, Console event..
  if not m_uninstalled then
    m_event.Register()
    m_hotkeys.Register()
  end
end

function CETMM.Render()
  registerForEvent("onDraw", function()
    if m_gui then
      m_gui.Initialize()
      m_gui.Render()
    end
  end)
end

function CETMM.Shutdown()
  registerForEvent("onShutdown", function()
    m_options.Save()
  end)
end