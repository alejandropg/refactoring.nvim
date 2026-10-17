-- Measures how long kotlin-lsp takes until it answers `textDocument/references`,
-- the same way `tests/test_inline_var.lua` waits for it.
-- Run: nvim --headless --clean -u scripts/minimal_init.lua -c "luafile scripts/measure_kotlin_lsp.lua"
local t0 = vim.uv.hrtime()
local last = t0

local function mark(label)
  local now = vim.uv.hrtime()
  io.stdout:write(("%-28s +%6.2fs  total %6.2fs\n"):format(label, (now - last) / 1e9, (now - t0) / 1e9))
  last = now
end

local function fail(msg)
  io.stdout:write("FAILED: " .. msg .. "\n")
  vim.cmd "cquit!"
end

local ok, err = pcall(function()
  require("tests.kotlin_lsp").start()
  mark "socket listening"

  vim.cmd "edit tests/files/kotlin_project/tmp.kt"
  local lines = vim.fn.readfile "tests/files/inline_var_comparison_operator_before.kt"
  vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
  vim.api.nvim_win_set_cursor(0, { 2, 8 })

  if not vim.wait(60000, function()
    return #vim.lsp.get_clients { bufnr = 0 } == 1
  end, 50) then
    return fail "client didn't attach"
  end
  mark "client attached"

  local client = vim.lsp.get_clients({ bufnr = 0 })[1]
  if not vim.wait(60000, function()
    return client.initialized
  end, 50) then
    return fail "client didn't initialize"
  end
  mark "initialize answered"

  local params = vim.lsp.util.make_position_params(0, "utf-16")
  params.context = { includeDeclaration = false }
  local attempts = 0
  local ready = false
  while not ready and (vim.uv.hrtime() - t0) / 1e9 < 300 do
    attempts = attempts + 1
    local results = vim.lsp.buf_request_sync(0, "textDocument/references", params, 5000) or {}
    for _, r in pairs(results) do
      if r.result and #r.result > 0 then ready = true end
    end
    if not ready then vim.wait(500) end
  end
  if not ready then return fail "references never answered" end
  mark(("references answered (%d tries)"):format(attempts))

  vim.lsp.buf_request_sync(0, "textDocument/references", params, 5000)
  mark "next references request"
end)

if not ok then fail(tostring(err)) end
vim.cmd "qall!"
