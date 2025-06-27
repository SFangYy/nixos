-- lua/custom/file_templates.lua

local M = {}
local telescope = require('telescope.builtin')
local actions = require('telescope.actions')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local pickers = require('telescope.pickers')

-- 获取项目根目录的辅助函数
-- 尝试找到最近的 .git 目录作为项目根目录
local function get_project_root()
  local cwd = vim.fn.getcwd()
  local root_dir = vim.fn.finddir('.git', cwd .. ';') -- 查找 .git 目录
  if root_dir ~= '' then
    return root_dir:gsub('/%.git$', '') -- 移除 /.git
  else
    -- 如果没有 .git，可以设置为当前工作目录或默认目录
    return cwd
  end
end

-- 定义您的模板
-- 您可以根据需要添加更多模板
local templates = {
  daily_note = {
    content = function()
      local date = os.date("%Y-%m-%d")
      return "---\n" ..
             "title: " .. date .. " 日报\n" ..
             "date: " .. date .. "\n" ..
             "---\n\n" ..
             "# " .. date .. " 日报\n\n" ..
             "- [ ] 今日待办\n\n" ..
             "## 总结\n\n"
    end,
    -- 注意：这里不再有 default_path_suffix，因为它将由用户动态选择
  },
  new_doc = {
    content = function()
      return "---\n" ..
             "title: 新文档\n" ..
             "date: " .. os.date("%Y-%m-%d") .. "\n" ..
             "---\n\n" ..
             "# 新文档标题\n\n" ..
             "这是新文档的内容。\n"
    end,
  },
  -- 您可以添加更多模板
}

--- 创建一个带有模板的新文件，允许用户选择子目录
-- @param template_name string: 模板的名称 (例如 'daily_note')
-- @param base_dir_suffix string: 基础目录后缀，例如 'notes/daily/' 或 'docs/'
M.create_file_in_subdir_with_template = function(template_name, base_dir_suffix)
  local template = templates[template_name]
  if not template then
    vim.notify("未找到模板: " .. template_name, vim.log.levels.ERROR)
    return
  end

  local project_root = get_project_root()
  local base_dir = project_root .. "/" .. base_dir_suffix

  -- 确保基础目录存在
  vim.fn.mkdir(base_dir, "p")

  -- 获取 base_dir 下的所有子文件夹
  local subdirs = {}
  for _, entry in ipairs(vim.fn.readdir(base_dir, false, { "dir" })) do
    -- 过滤掉 "." 和 ".."
    if entry ~= "." and entry ~= ".." then
      table.insert(subdirs, entry)
    end
  end

  -- 如果没有子文件夹，直接在 base_dir 中创建文件
  if #subdirs == 0 then
    vim.notify("在 " .. base_dir .. " 下未找到子文件夹，直接在该目录创建。", vim.log.levels.INFO)
    M._prompt_filename_and_create(base_dir, template)
    return
  end

  -- 使用 Telescope 让用户选择一个子文件夹
  pickers.new({}, {
    prompt_title = "选择目标子文件夹 (模板: " .. template_name .. ")",
    finder = finders.new_table({ results = subdirs }),
    sorter = sorters.get_fuzzy_sorter(),
    actions = {
      select_default = actions.create_close_actions(function(prompt_bufnr)
        local selection = require('telescope.actions.state').get_current_picker(prompt_bufnr):get_selection()
        local selected_subdir = selection[1] -- 选择项就是子文件夹名

        local target_dir = base_dir .. selected_subdir .. "/"
        vim.fn.mkdir(target_dir, "p") -- 确保选定的子目录存在

        -- 提示用户输入文件名并在选定的目录中创建
        M._prompt_filename_and_create(target_dir, template)
      end),
      ['<C-c>'] = actions.close, -- 允许取消选择
      ['<esc>'] = actions.close,
    },
  }):find()
end

--- 内部函数：提示用户输入文件名并创建文件
-- @param target_dir string: 最终目标目录
-- @param template table: 要使用的模板
function M._prompt_filename_and_create(target_dir, template)
  -- 使用 Telescope 提示用户输入文件名
  telescope.find_files({
    prompt_title = "输入文件名并创建 (目录: " .. target_dir .. ")",
    cwd = target_dir, -- 默认在选定的子目录下创建
    -- 自定义操作：当用户输入一个不存在的文件名时，创建并写入模板
    actions = {
      select_default = actions.create_close_actions(function(prompt_bufnr)
        local selection = require('telescope.actions.state').get_current_picker(prompt_bufnr):get_selection()
        local file_path_input = selection.path or selection[1] -- selection.path 是文件路径，selection[1] 是输入框内容

        -- 确保文件路径以选定目录开头
        local final_file_path
        if file_path_input:sub(1, #target_dir) == target_dir then
          final_file_path = file_path_input
        else
          final_file_path = target_dir .. file_path_input
        end

        -- 如果是新文件（即路径不存在），则创建并写入模板
        if not vim.fn.filereadable(final_file_path) then
          -- 确保文件名的目录部分也存在
          local dir_only = vim.fn.fnamemodify(final_file_path, ":h")
          vim.fn.mkdir(dir_only, "p")

          local file = io.open(final_file_path, "w")
          if file then
            file:write(template.content())
            io.close(file)
            vim.notify("文件创建成功: " .. final_file_path, vim.log.levels.INFO)
            vim.cmd("edit " .. final_file_path) -- 打开新创建的文件
          else
            vim.notify("无法创建文件: " .. final_file_path, vim.log.levels.ERROR)
          end
        else
          -- 如果文件已存在，则正常打开
          vim.cmd("edit " .. final_file_path)
        end
      end),
      ['<C-c>'] = actions.close, -- 允许取消选择
      ['<esc>'] = actions.close,
    },
    -- 允许用户输入不存在的文件名来创建
    allow_new = true,
  })
end

return M