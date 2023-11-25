local M = {}

M.find_buffer_by_name = function(target_name)
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    for _, window in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
      local buffer = vim.api.nvim_win_get_buf(window)
      local buffer_name = vim.api.nvim_buf_get_name(buffer)
      if buffer_name:find(target_name) then
        return buffer
      end
    end
  end

  return nil
end

M.switch_to_window_with_buffer = function(buffer_handle)
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    for _, window in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
      local current_buffer = vim.api.nvim_win_get_buf(window)

      if current_buffer == buffer_handle then
        vim.api.nvim_set_current_tabpage(tabpage)
        vim.api.nvim_set_current_win(window)
        return
      end
    end
  end
end

return M
