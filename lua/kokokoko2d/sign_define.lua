--- サインを定義するモジュール
local M = {
}

local KOKOKOKO_SIGN = {
  default = {
    { shape = '󰝥', color = '#E60012',},
    { shape = '󰝥', color = '#F39800',},
    { shape = '●', color = '#FFF100',},
    { shape = '•', color = '#009944',},
    { shape = '•', color = '#0068B7',},
    { shape = '∙', color = '#1D2088',},
    { shape = '∙', color = '#920783',},
  },
};



function M.setup()
  -- vim.api.nvim_set_hl(0, 'KokokokoCurrent', { bg = nil, fg = '#E60012', default = true })

  local sign_name = "default"

  for i = 1, 7, 1 do
    local s = KOKOKOKO_SIGN[sign_name][i]
    vim.api.nvim_set_hl(0, 'Kokokoko2dOverlayColor' .. sign_name .. i, { bg = 'NONE', fg = s.color, default = true })
  end
end

function M.get_point_sign(_type, _n)
  local s = KOKOKOKO_SIGN[_type][_n]
  return {
    shape = s.shape,
    color = s.color,
    hlgroup = ("Kokokoko2dOverlayColor" .. _type .. _n),
  }
end

return M

