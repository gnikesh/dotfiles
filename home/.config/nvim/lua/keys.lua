-- save by pressing Escape
vim.keymap.set('n', '<Esc>', ':w<CR>', { desc = 'Save' })
-- select all
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select All' })
-- pasting over a selection no longer clobbers your clipboard
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])

-- Move between the file tree and the editor without reaching for the mouse.
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Focus left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Focus lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Focus upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Focus right window' })

-- The same navigation is available from the which-key leader menu.
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Focus left window' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Focus lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Focus upper window' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Focus right window' })
vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'Cycle windows' })

-- Use Neovim's built-in terminal in a bottom split.
local terminal_window

local function find_terminal_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == 'terminal' then
      return win
    end
  end
end

local function focus_editor_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype ~= 'NvimTree' and vim.bo[buf].buftype == '' then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

local function toggle_terminal()
  terminal_window = terminal_window and vim.api.nvim_win_is_valid(terminal_window)
    and terminal_window or find_terminal_window()

  if terminal_window then
    vim.api.nvim_win_close(terminal_window, true)
    terminal_window = nil
    return
  end

  focus_editor_window()
  vim.cmd('botright split')
  vim.cmd('resize 12')
  vim.cmd('terminal')
  terminal_window = vim.api.nvim_get_current_win()
  vim.cmd('startinsert')
end

vim.keymap.set('n', '<leader>t', toggle_terminal, { desc = 'Toggle terminal' })
vim.keymap.set('t', '<C-t>', toggle_terminal, { desc = 'Toggle terminal' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Focus file above' })
