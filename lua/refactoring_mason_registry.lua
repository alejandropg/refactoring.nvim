-- NOTE: overrides mason-registry's kotlin-lsp package: its download URLs
-- return 404 (mason-org/mason-registry#17323), and its linux_arm64 `bin` has an
-- extra `{` (mason-org/mason-registry#16914). A `lua:` registry `require`s a
-- list of module names and then `require`s each of them to get its spec
-- TODO: once both are fixed upstream, remove this, refactoring_mason_index.lua, and `registries` in minimal_init.lua

local version = "263.6379.0"
local base_file = "kotlin-server-" .. version
local url_without_extension = "https://download.jetbrains.com/language-server/kotlin-server/"
  .. version .. "/" .. base_file

return {
  name = "kotlin-lsp",
  -- NOTE: Mason validates that these fields exist, but doesn't use them
  description = "",
  homepage = "",
  licenses = {},
  languages = {},
  categories = {},
  source = {
    id = "pkg:generic/kotlin-lsp@" .. version,
    download = {
      {
        target = "darwin_x64",
        files = { ["kotlin-lsp.zip"] = url_without_extension .. ".sit" },
      },
      {
        target = "darwin_arm64",
        files = { ["kotlin-lsp.zip"] = url_without_extension .. "-aarch64.sit" },
      },
      {
        target = "linux_x64",
        files = { ["kotlin-lsp.tar.gz"] = url_without_extension .. ".tar.gz" },
      },
      {
        target = "linux_arm64",
        files = { ["kotlin-lsp.tar.gz"] = url_without_extension .. "-aarch64.tar.gz" },
      },
    },
  },
  bin = { ["intellij-server"] = base_file .. "/bin/intellij-server" },
}
