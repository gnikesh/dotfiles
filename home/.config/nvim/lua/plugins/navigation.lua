return {
  {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    keys = {
      { '<leader>e', '<cmd>NvimTreeToggle<cr>', desc = 'File Tree' },
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    config = function()
      require('nvim-tree').setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        view = {
          side = 'left',
          width = 32,
        },
        renderer = {
          group_empty = true,
          indent_markers = { enable = false },
          icons = {
            show = {
              file = false,
              folder = false,
              folder_arrow = false,
              git = false,
              modified = false,
              hidden = false,
            },
          },
        },
        filters = {
          dotfiles = false,
        },
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = false,
          },
        },
      })

      vim.api.nvim_create_autocmd('QuitPre', {
        callback = function()
          if vim.bo.filetype == 'NvimTree' then
            return
          end

          local regular_windows = 0
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype ~= 'NvimTree' and vim.bo[buf].buftype == '' then
              regular_windows = regular_windows + 1
            end
          end

          if regular_windows == 1 then
            require('nvim-tree.api').tree.close()

            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == 'terminal' then
                vim.api.nvim_win_close(win, true)
              end
            end
          end
        end,
      })

      if vim.fn.argc() > 0 then
        vim.schedule(function()
          require('nvim-tree.api').tree.open({
            current_window = false,
            find_file = true,
            focus = false,
          })
          vim.cmd('wincmd l')
        end)
      end
    end,
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = true },
    },
    keys = {
      { '<leader>f', function() Snacks.picker.files() end, desc = 'Find Files' },
      { '<leader>s', function() Snacks.picker.grep() end,  desc = 'Search Text' },
      { '<leader>b', function() Snacks.picker.buffers() end, desc = 'Buffers' },
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition' },
    },
  },
}
