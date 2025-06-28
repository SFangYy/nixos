-- 将函数挂载到全局，以便快捷键可以调用
_G.CreateTemplatedFileInSubdir = function(base_dir)
  -- 获取当前工作目录并拼接成基础路径
  local cwd = vim.fn.getcwd()
  local base_path = cwd .. '/' .. base_dir

  -- 确保基础目录存在 (如果不存在则递归创建，类似 mkdir -p)
  vim.fn.mkdir(base_path, 'p')

  -- 查找 base_path 下的所有子目录
  local subdirs = {}
  -- vim.fs.dir 是一个迭代器，用于遍历目录条目
  for name, type in vim.fs.dir(base_path) do
    if type == 'directory' then
      table.insert(subdirs, name)
    end
  end

  -- 定义一个函数，用于获取文件名并创建文件
  -- 参数 anwser_dir 是用户最终选择的目录
  local function get_filename_and_create(answer_dir)
    vim.ui.input({ prompt = '请输入文件名: ' }, function(filename)
      -- 如果用户取消输入 (按 Esc)，则直接返回
      if not filename or filename == '' then
        print('操作已取消')
        return
      end

      local final_path = answer_dir .. '/' .. filename
      local relative_path = vim.fn.fnamemodify(final_path, ':.')

      -- 创建模板内容
      local template = {
        '---',
        'path: ' .. relative_path,
        '---',
        '',
      }

      -- 写入文件并打开
      vim.fn.writefile(template, final_path)
      vim.cmd('edit ' .. final_path)
      print('文件已创建: ' .. final_path)
    end)
  end

  -- 核心逻辑：根据是否存在子目录来决定下一步操作
  if #subdirs == 0 then
    -- 如果 A/B/ 下没有子目录，直接在 A/B/ 下创建
    get_filename_and_create(base_path)
  else
    -- 如果有子目录，使用 Telescope 让用户选择
    
    -- 添加一个特殊选项，允许在根目录 (A/B/) 创建
    table.insert(subdirs, 1, '. (在此文件夹创建)')

    require('telescope.pickers').new({}, {
      prompt_title = '选择一个子文件夹',
      finder = require('telescope.finders').new_table {
        results = subdirs,
      },
      sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
      attach_mappings = function(prompt_bufnr, map)
        map('i', '<CR>', function()
          local selection = require('telescope.actions.state').get_selected_entry()
          require('telescope.actions').close(prompt_bufnr)
          
          local chosen_dir_name = selection.value
          local final_dir
          
          if chosen_dir_name == '. (在此文件夹创建)' then
            final_dir = base_path
          else
            final_dir = base_path .. '/' .. chosen_dir_name
          end
          
          get_filename_and_create(final_dir)
        end)
        return true
      end,
    }):find()
  end
end