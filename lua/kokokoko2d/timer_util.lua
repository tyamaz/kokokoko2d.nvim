--- JSの setTimeout 系の処理をする何か
local M = {}


function M.setTimeout(callback, delay)
  local timer = vim.loop.new_timer()
  local closed = false
  timer:start(delay, 0, vim.schedule_wrap(function()
    if closed then
      return
    end
    timer:stop()
    timer:close()
    closed = true
    callback()
  end))

  -- やや複雑ではあるが個別生成されるローカル変数をクロージャでオブジェクトに纏わせる
  return {
    timer = timer,
    is_closed = function()
      return closed
    end,
    close = function()
      closed = true
    end
  }
end

function M.clearTimeout(t)
  local timer = t.timer
  if t.is_closed() then
    return
  end
  if timer then
    timer:stop()
    timer:close()
    t.close()
  end
end

return M

