-- A single kotlin-lsp server shared by all the Kotlin test cases. Starting
-- kotlin-lsp takes seconds (JVM start and Gradle import), while a child Nvim
-- connects to a running one instantly. `scripts/minimal_init.lua` gets its
-- `cmd` from here.
local M = {}

local root = vim.fn.getcwd()
-- Where Mason installs kotlin-lsp (`make deps`)
local install_dir = root .. "/deps/bin/packages/kotlin-lsp"

---@return string
local function launcher()
  local path = vim.fn.glob(install_dir .. "/kotlin-server-*/bin/intellij-server")
  assert(path ~= "", "kotlin-lsp isn't installed in " .. install_dir .. ", run `make deps`")
  return path
end

---@param port integer
---@return boolean
local function is_listening(port)
  local connected ---@type boolean|nil
  local tcp = assert(vim.uv.new_tcp())
  tcp:connect("127.0.0.1", port, function(err)
    connected = err == nil
    tcp:close()
  end)
  vim.wait(1000, function()
    return connected ~= nil
  end)
  return connected == true
end

--- The `cmd` for `vim.lsp.config`: connect to the shared server when it's
--- running, otherwise start a server for this Nvim only.
---@param dispatchers vim.lsp.rpc.Dispatchers
---@return vim.lsp.rpc.PublicClient
function M.cmd(dispatchers)
  local port = tonumber(vim.env.KOTLIN_LSP_PORT)
  if port then return vim.lsp.rpc.connect("127.0.0.1", port)(dispatchers) end
  return vim.lsp.rpc.start({ launcher(), "--stdio" }, dispatchers)
end

--- Starts the shared server, if it isn't running yet. Use it in `pre_once`:
--- child Nvims started afterwards inherit `$KOTLIN_LSP_PORT`.
function M.start()
  if vim.env.KOTLIN_LSP_PORT then return end

  local tcp = assert(vim.uv.new_tcp())
  tcp:bind("127.0.0.1", 0)
  local port = tcp:getsockname().port
  tcp:close()

  local server = vim.system({
    launcher(),
    "--socket=127.0.0.1:" .. port,
    "--multi-client",
    "--workspace-root=" .. root .. "/tests/files/kotlin_project",
  }, { stdout = false, stderr = false })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      server:kill "sigterm"
      -- NOTE: the launcher starts the JVM in its own process group, and the
      -- JVM keeps running after the launcher stops
      vim.system({ "pkill", "-f", install_dir .. "/" }):wait()
    end,
  })

  local listening = vim.wait(60000, function()
    return is_listening(port)
  end, 500)
  assert(listening, "kotlin-lsp didn't start listening on port " .. port)
  vim.env.KOTLIN_LSP_PORT = tostring(port)
end

return M
