local render = require("kokokoko2d.cursor_sign_render")
local M = {}
M.version = "0.0.2"



--- マルチバイト考慮した本当のカーソル位置のカラム位置
--- 1 文字目を 1 と換算する
local function get_visual_corrent_col()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local line = cursor_pos[1]
    local col = cursor_pos[2]
    -- 対象行全行をもってきて
    local line_str = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
    -- 行頭からカーソル列までの幅をマルチバイト込みで測る
    return vim.fn.strdisplaywidth(line_str:sub(1, col)) + 1
end




--- 初期化セット
--- called is enable
function M.setup()
  -- 残像に使うマーカー的文字の管理と初期化
  require("kokokoko2d.sign_define").setup()


  vim.api.nvim_create_augroup('kokokoko2d', { clear = true })

  -- バッファ を見る
  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'TermLeave' }, {
    group = 'kokokoko2d',
    callback = function()
      -- plugin 関係のバッファを無視する
      if vim.bo.filetype == 'lazy' then
        return
      end

      -- 戻った瞬間の位置を1個前の位置として記録する
      vim.api.nvim_buf_set_var(0, 'kokokoko2d_prev_lnum', vim.fn.line('.'))
      vim.api.nvim_buf_set_var(0, 'kokokoko2d_prev_cnum', vim.fn.col('.'))
    end,
  })

  -- カーソルの動きを見る
  vim.api.nvim_create_autocmd(
    -- { 'CursorMoved', 'CursorMovedI', 'CmdlineChanged' },
    { 'CursorMoved' },
    {
      group = 'kokokoko2d',
      callback = function()
          -- plugin 関係のバッファを無視する
         if vim.bo.filetype == 'lazy' then
            return
         end
        local cb = vim.api.nvim_get_current_buf()

        -- 行列共に1スタート換算
        local prev_lnum = vim.api.nvim_buf_get_var(0, 'kokokoko2d_prev_lnum')
        local prev_cnum = vim.api.nvim_buf_get_var(0, 'kokokoko2d_prev_cnum')

        local curt_lnum = vim.fn.line('.')
        local curt_cnum = get_visual_corrent_col() -- マルチバイト文字対応で、文字混在でも正しいカラム位置を出す

        local top_lnum = vim.fn.line('w0')
        local bottom_lnum = vim.fn.line('w$')
        local from_lnum = prev_lnum

        local speed = 200

        if prev_lnum < top_lnum then
          from_lnum = top_lnum
        end
        -- 画面外下から来ること想定
        if prev_lnum > bottom_lnum then
          from_lnum = bottom_lnum
        end
        -- 始点と終点の間に軌跡のサインを描画する
        render.render_range_based_dist(
          cb,
          {
            lnum = from_lnum,
            cnum = prev_cnum,
          },
          {lnum = curt_lnum, cnum = curt_cnum},
          speed)
-- ほげほげほげhごえほえgほえgほえgほえhごえhごえhごえhごえhごえhごえhごえhごえhごへごえhごえごえhごえhごほえgへおhhhhhhhhhhhh
        -- 1個前の位置を現在地点で更新
        vim.api.nvim_buf_set_var(0, 'kokokoko2d_prev_lnum', curt_lnum)
        vim.api.nvim_buf_set_var(0, 'kokokoko2d_prev_cnum', curt_cnum)
      end,
    }
  )
end

return M
