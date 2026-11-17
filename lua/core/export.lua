-- Document export: pick style options, then convert to styled .docx.
-- <leader>e saves the file, asks font/size/spacing (last picks first),
-- and runs scripts/export_docs.py asynchronously (Decisions D10-D12).

local M = {}

local FONTS = { "Times New Roman", "Calibri", "Georgia" }
local SIZES = { "11", "12", "14" }
local SPACINGS = { "single", "1.5", "double" }
local DEFAULTS = { font = FONTS[1], size = SIZES[2], spacing = SPACINGS[1] }

local function history_path()
  return vim.fn.stdpath("data") .. "/export-last.json"
end

-- Last picks, persisted across sessions; missing/corrupt file → defaults.
local function load_last()
  local last = vim.deepcopy(DEFAULTS)
  local ok, lines = pcall(vim.fn.readfile, history_path())
  if ok and lines and #lines > 0 then
    local ok_json, saved = pcall(vim.json.decode, table.concat(lines, "\n"))
    if ok_json and type(saved) == "table" then
      for k, v in pairs(saved) do
        if last[k] ~= nil and type(v) == "string" then
          last[k] = v
        end
      end
    end
  end
  return last
end

local function save_last(sel)
  vim.fn.writefile({ vim.json.encode(sel) }, history_path())
end

-- Stable order, but the last pick first (vim.ui.select can't preselect).
local function with_last_first(items, last)
  local out = {}
  for _, item in ipairs(items) do
    if item == last then
      table.insert(out, 1, item)
    else
      table.insert(out, item)
    end
  end
  return out
end

-- Run the converter with the chosen style; quote its stdout on success
-- (the output path) and its stderr on failure (the reason).
function M.export(sel)
  local script = vim.fn.stdpath("config") .. "/scripts/export_docs.py"
  local file = vim.fn.expand("%:p")
  local stdout, stderr = {}, {}
  vim.fn.jobstart({
    "python3",
    script,
    "--font",
    sel.font,
    "--size",
    sel.size,
    "--spacing",
    sel.spacing,
    file,
  }, {
    detach = true, -- fire and forget: the export outlives even a quit
    stdout_buffered = true, -- deliver stdout as one list when the job ends
    stderr_buffered = true, -- same for stderr
    on_stdout = function(_, data)
      stdout = data
    end,
    on_stderr = function(_, data)
      stderr = data
    end,
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          local out = table.concat(stdout, "\n"):gsub("%s+$", "")
          if out == "" then
            out = "finished with no output"
          end
          vim.notify("Export (" .. file .. "): " .. out, vim.log.levels.INFO)
        else
          local err = table.concat(stderr, "\n"):gsub("%s+$", "")
          if err == "" then
            err = "no details"
          end
          vim.notify("Export failed (exit " .. code .. ") (" .. file .. "): " .. err, vim.log.levels.ERROR)
        end
      end)
    end,
  })
end

-- Save, pick style, export. Cancelling any picker aborts silently.
function M.run()
  vim.cmd("write") -- fails loudly (E32) on unnamed buffers; export never runs then
  local last = load_last()
  vim.ui.select(with_last_first(FONTS, last.font), { prompt = "Export font:" }, function(font)
    if font == nil then
      return
    end
    vim.ui.select(with_last_first(SIZES, last.size), { prompt = "Export size:" }, function(size)
      if size == nil then
        return
      end
      vim.ui.select(with_last_first(SPACINGS, last.spacing), { prompt = "Line spacing:" }, function(spacing)
        if spacing == nil then
          return
        end
        local sel = { font = font, size = size, spacing = spacing }
        save_last(sel)
        M.export(sel)
      end)
    end)
  end)
end

return M
