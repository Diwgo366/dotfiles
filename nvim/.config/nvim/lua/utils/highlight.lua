local colors = require('utils.colors')

local function hl(group, opts)
  opts = opts or {}
  local cmd = 'highlight ' .. group
  if opts.fg then cmd = cmd .. ' guifg=' .. opts.fg end
  if opts.bg then cmd = cmd .. ' guibg=' .. opts.bg end
  if opts.attr then cmd = cmd .. ' gui=' .. opts.attr end
  if opts.sp then cmd = cmd .. ' guisp=' .. opts.sp end
  vim.cmd(cmd)
end

-- =============================================================
-- BASE
-- =============================================================
hl('Normal', { fg = colors.fg })
hl('NormalNC', { fg = colors.fg })
hl('NormalFloat', { fg = colors.fg, bg = colors.current_line })
hl('FloatBorder', { fg = colors.purple, bg = colors.current_line })
hl('EndOfBuffer', { fg = colors.comment })

-- =============================================================
-- LINE NUMBERS
-- =============================================================
hl('LineNr', { fg = colors.line_nr })
hl('CursorLineNr', { fg = colors.cursor_line_nr, attr = 'bold' })
hl('CursorLine', { bg = colors.current_line })
hl('CursorColumn', { bg = colors.current_line })
hl('SignColumn', { })
hl('ColorColumn', { bg = colors.current_line })

-- =============================================================
-- SELECTION & SEARCH
-- =============================================================
hl('Visual', { fg = colors.bg, bg = colors.purple })
hl('VisualNOS', { fg = colors.bg, bg = colors.purple })
hl('Search', { fg = colors.bg, bg = colors.yellow, attr = 'bold' })
hl('IncSearch', { fg = colors.bg, bg = colors.orange, attr = 'bold' })
hl('Substitute', { fg = colors.bg, bg = colors.pink, attr = 'bold' })

-- =============================================================
-- UI ELEMENTS
-- =============================================================
hl('VertSplit', { fg = colors.border })
hl('WinSeparator', { fg = colors.border })
hl('StatusLine', { fg = colors.fg, bg = colors.current_line })
hl('StatusLineNC', { fg = colors.comment })
hl('TabLine', { fg = colors.comment })
hl('TabLineSel', { fg = colors.fg, bg = colors.current_line, attr = 'bold' })
hl('TabLineFill', { })

-- =============================================================
-- SYNTAX BASE
-- =============================================================
hl('Comment', { fg = colors.comment, attr = 'italic' })
hl('String', { fg = colors.yellow })
hl('StringDelimiter', { fg = colors.yellow })
hl('Character', { fg = colors.green })
hl('Number', { fg = colors.orange })
hl('Boolean', { fg = colors.purple })
hl('Float', { fg = colors.orange })

-- =============================================================
-- OPERATORS & KEYWORDS
-- =============================================================
hl('Operator', { fg = colors.pink })
hl('Keyword', { fg = colors.pink })
hl('Statement', { fg = colors.pink })
hl('Conditional', { fg = colors.pink })
hl('Repeat', { fg = colors.pink })
hl('Label', { fg = colors.pink })
hl('Exception', { fg = colors.pink })

-- =============================================================
-- TYPES & STRUCTURES
-- =============================================================
hl('Type', { fg = colors.cyan })
hl('StorageClass', { fg = colors.pink })
hl('Structure', { fg = colors.cyan })
hl('Typedef', { fg = colors.cyan })
hl('PreProc', { fg = colors.pink })
hl('Include', { fg = colors.pink })
hl('Define', { fg = colors.pink })
hl('Macro', { fg = colors.pink })
hl('PreCondit', { fg = colors.pink })

-- =============================================================
-- FUNCTIONS & IDENTIFIERS
-- =============================================================
hl('Function', { fg = colors.cyan })
hl('FunctionBuiltin', { fg = colors.cyan })
hl('Identifier', { fg = colors.fg })
hl('Variable', { fg = colors.fg })
hl('Constant', { fg = colors.orange })
hl('SpecialChar', { fg = colors.pink })
hl('Tag', { fg = colors.pink })
hl('Special', { fg = colors.purple })
hl('SpecialComment', { fg = colors.comment, attr = 'italic' })

-- =============================================================
-- ERRORS, WARNINGS, INFO
-- =============================================================
hl('Error', { fg = colors.error, attr = 'bold,underline' })
hl('ErrorMsg', { fg = colors.error, attr = 'bold' })
hl('WarningMsg', { fg = colors.warning, attr = 'bold' })
hl('Question', { fg = colors.green })
hl('MoreMsg', { fg = colors.green })
hl('ModeMsg', { fg = colors.cyan })

-- =============================================================
-- SPELLING
-- =============================================================
hl('SpellBad', { sp = colors.error, attr = 'undercurl' })
hl('SpellCap', { sp = colors.warning, attr = 'undercurl' })
hl('SpellRare', { sp = colors.hint, attr = 'undercurl' })
hl('SpellLocal', { sp = colors.info, attr = 'undercurl' })

-- =============================================================
-- FOLDING
-- =============================================================
hl('Folded', { fg = colors.comment, bg = colors.current_line })
hl('FoldColumn', { fg = colors.comment })

-- =============================================================
-- DIFF
-- =============================================================
hl('DiffAdd', { fg = colors.green })
hl('DiffChange', { fg = colors.yellow })
hl('DiffDelete', { fg = colors.red })
hl('DiffText', { fg = colors.cyan, attr = 'underline' })

-- =============================================================
-- COMPLETION MENU
-- =============================================================
hl('Pmenu', { fg = colors.fg, bg = colors.current_line })
hl('PmenuSel', { fg = colors.bg, bg = colors.purple })
hl('PmenuSbar', { bg = colors.current_line })
hl('PmenuThumb', { bg = colors.purple })

-- =============================================================
-- BRACKETS & DELIMITERS
-- =============================================================
hl('MatchParen', { fg = colors.bg, bg = colors.orange })
hl('Delimiter', { fg = colors.fg })
hl('Bracket', { fg = colors.fg })

-- =============================================================
-- TITLE & MESSAGES
-- =============================================================
hl('Title', { fg = colors.cyan })
hl('MsgArea', { fg = colors.fg })
hl('MsgSeparator', { fg = colors.border })

-- =============================================================
-- SPECIAL ELEMENTS
-- =============================================================
hl('Todo', { fg = colors.bg, bg = colors.orange })
hl('Attention', { fg = colors.bg, bg = colors.red })
hl('Underlined', { attr = 'underline' })
hl('Conceal', { fg = colors.comment })
hl('Ignore', { fg = colors.comment })
hl('Whitespace', { fg = colors.comment })
hl('NonText', { fg = colors.comment })
hl('SpecialKey', { fg = colors.purple })

-- =============================================================
-- TREESITTER
-- =============================================================
hl('TSPunctDelimiter', { fg = colors.fg })
hl('TSPunctBracket', { fg = colors.fg })
hl('TSPunctSpecial', { fg = colors.fg })
hl('TSConstant', { fg = colors.orange })
hl('TSConstBuiltin', { fg = colors.orange })
hl('TSConstMacro', { fg = colors.orange })
hl('TSString', { fg = colors.yellow })
hl('TSStringEscape', { fg = colors.pink })
hl('TSStringRegex', { fg = colors.red })
hl('TSCharacter', { fg = colors.green })
hl('TSNumber', { fg = colors.orange })
hl('TSBoolean', { fg = colors.purple })
hl('TSFloat', { fg = colors.orange })
hl('TSFunction', { fg = colors.cyan })
hl('TSFuncBuiltin', { fg = colors.cyan })
hl('TSFuncMacro', { fg = colors.cyan })
hl('TSParameter', { fg = colors.orange })
hl('TSParameterReference', { fg = colors.orange })
hl('TSMethod', { fg = colors.cyan })
hl('TSField', { fg = colors.fg })
hl('TSProperty', { fg = colors.fg })
hl('TSConstructor', { fg = colors.cyan })
hl('TSConditional', { fg = colors.pink })
hl('TSRepeat', { fg = colors.pink })
hl('TSLabel', { fg = colors.pink })
hl('TSKeyword', { fg = colors.pink })
hl('TSKeywordFunction', { fg = colors.pink })
hl('TSKeywordOperator', { fg = colors.pink })
hl('TSOperator', { fg = colors.pink })
hl('TSException', { fg = colors.pink })
hl('TSType', { fg = colors.cyan })
hl('TSTypeBuiltin', { fg = colors.cyan })
hl('TSStructure', { fg = colors.cyan })
hl('TSInclude', { fg = colors.pink })
hl('TSVariable', { fg = colors.fg })
hl('TSVariableBuiltin', { fg = colors.pink })
hl('TSText', { fg = colors.fg })
hl('TSStrong', { attr = 'bold' })
hl('TSEmphasis', { attr = 'italic' })
hl('TSUnderline', { attr = 'underline' })
hl('TSStrike', { attr = 'strikethrough' })
hl('TSTitle', { fg = colors.cyan })
hl('TSLiteral', { fg = colors.yellow })
hl('TSURI', { fg = colors.cyan, attr = 'underline' })
hl('TSComment', { fg = colors.comment, attr = 'italic' })
hl('TSAnnotation', { fg = colors.purple })
hl('TSAttribute', { fg = colors.purple })
hl('TSNamespace', { fg = colors.cyan })
hl('TSTag', { fg = colors.pink })
hl('TSTagDelimiter', { fg = colors.comment })
hl('TSNote', { fg = colors.bg, bg = colors.info })
hl('TSWarning', { fg = colors.bg, bg = colors.warning })
hl('TSDanger', { fg = colors.bg, bg = colors.error })
hl('TSMath', { fg = colors.orange })

-- =============================================================
-- BARBAR.NVIM (TABS)
-- =============================================================
hl('BufferLineBackground', { fg = colors.comment })
hl('BufferLineBuffer', { fg = colors.comment })
hl('BufferLineBufferVisible', { fg = colors.fg })
hl('BufferLineBufferSelected', { fg = colors.fg, bg = colors.current_line })
hl('BufferLineModified', { fg = colors.warning })
hl('BufferLineModifiedSelected', { fg = colors.warning })
hl('BufferLineModifiedVisible', { fg = colors.warning })
hl('BufferLineIndicator', { fg = colors.purple, bg = colors.current_line })
hl('BufferLineIndicatorSelected', { fg = colors.purple, bg = colors.current_line })
hl('BufferLineTab', { fg = colors.comment })
hl('BufferLineTabSelected', { fg = colors.cyan })
hl('BufferLineTabpage', { fg = colors.comment })
hl('BufferLineTabpageSelected', { fg = colors.fg, bg = colors.current_line })
hl('BufferLineFill', { })
hl('BufferLineSeparator', { })
hl('BufferLineSeparatorSelected', { })
hl('BufferLineSeparatorVisible', { })
hl('BufferLineOffsetSeparator', { fg = colors.border })
hl('BufferLineGroupSeparator', { fg = colors.border })
hl('BufferLineDuplicate', { fg = colors.comment })
hl('BufferLineDuplicateSelected', { fg = colors.fg })
hl('BufferLineDuplicateVisible', { fg = colors.fg })
hl('BufferLineNumbers', { fg = colors.comment })
hl('BufferLineNumbersSelected', { fg = colors.fg })
hl('BufferLineNumbersVisible', { fg = colors.fg })
hl('BufferLineDiagnostics', { fg = colors.fg })
hl('BufferLineError', { fg = colors.error })
hl('BufferLineErrorDiagnostic', { fg = colors.error })
hl('BufferLineWarning', { fg = colors.warning })
hl('BufferLineWarningDiagnostic', { fg = colors.warning })
hl('BufferLineInfo', { fg = colors.info })
hl('BufferLineInfoDiagnostic', { fg = colors.info })
hl('BufferLineHint', { fg = colors.hint })
hl('BufferLineHintDiagnostic', { fg = colors.hint })

-- =============================================================
-- NVIM-TREE (FILE EXPLORER)
-- =============================================================
hl('NvimTreeNormal', { fg = colors.fg })
hl('NvimTreeNormalNC', { fg = colors.fg })
hl('NvimTreeEndOfBuffer', { fg = colors.comment })
hl('NvimTreeRootFolder', { fg = colors.cyan })
hl('NvimTreeFolderName', { fg = colors.cyan })
hl('NvimTreeFolderIcon', { fg = colors.purple })
hl('NvimTreeOpenedFolderName', { fg = colors.cyan })
hl('NvimTreeEmptyFolderName', { fg = colors.comment })
hl('NvimTreeFileName', { fg = colors.fg })
hl('NvimTreeFileNameOpened', { fg = colors.cyan })
hl('NvimTreeSpecialFile', { fg = colors.yellow })
hl('NvimTreeExecFile', { fg = colors.green })
hl('NvimTreeImageFile', { fg = colors.purple })
hl('NvimTreeSymlink', { fg = colors.cyan, attr = 'italic' })
hl('NvimTreeFolderArrowOpen', { fg = colors.purple })
hl('NvimTreeFolderArrowClosed', { fg = colors.purple })
hl('NvimTreeGitDirty', { fg = colors.yellow })
hl('NvimTreeGitNew', { fg = colors.green })
hl('NvimTreeGitRenamed', { fg = colors.pink })
hl('NvimTreeGitDeleted', { fg = colors.red })
hl('NvimTreeGitStaged', { fg = colors.green })
hl('NvimTreeGitIgnored', { fg = colors.comment })
hl('NvimTreeCursorLine', { bg = colors.current_line })
hl('NvimTreeIndentMarker', { fg = colors.border })
hl('NvimTreeWinSeparator', { fg = colors.border })
hl('NvimTreeStatusLine', { })
hl('NvimTreeStatusLineNC', { })
hl('NvimTreeVertSplit', { fg = colors.border })

-- =============================================================
-- TELESCOPE
-- =============================================================
hl('TelescopeBorder', { fg = colors.purple })
hl('TelescopePromptBorder', { fg = colors.purple })
hl('TelescopePromptNormal', { fg = colors.fg })
hl('TelescopeNormal', { fg = colors.fg })
hl('TelescopeSelection', { fg = colors.bg, bg = colors.purple })
hl('TelescopeSelectionCaret', { fg = colors.orange })

-- =============================================================
-- LUALINE CUSTOM STATUSLINE GROUPS
-- =============================================================
hl('StatuslineGit', { fg = colors.cyan, bg = colors.current_line })
hl('StatuslineGitAdd', { fg = colors.green, bg = colors.current_line })
hl('StatuslineGitChange', { fg = colors.yellow, bg = colors.current_line })
hl('StatuslineGitDelete', { fg = colors.red, bg = colors.current_line })
hl('StatuslineMode', { fg = colors.bg, bg = colors.cyan })
hl('StatuslineModeSeparator', { fg = colors.cyan, bg = colors.current_line })

-- =============================================================
-- LAZY.NVIM
-- =============================================================
hl('LazyNormal', { fg = colors.fg })
hl('LazyButton', { fg = colors.bg, bg = colors.purple })
hl('LazyButtonActive', { fg = colors.bg, bg = colors.cyan })
hl('LazyH1', { fg = colors.cyan })
hl('LazyReasonEvent', { fg = colors.yellow })
hl('LazyReasonStart', { fg = colors.green })
hl('LazyReasonRuntime', { fg = colors.orange })
hl('LazyReasonRequire', { fg = colors.pink })
hl('LazyReasonPlugin', { fg = colors.purple })

-- =============================================================
-- NOTIFICATIONS
-- =============================================================
hl('NotifyERRORBorder', { fg = colors.error })
hl('NotifyWARNBorder', { fg = colors.warning })
hl('NotifyINFOBorder', { fg = colors.info })
hl('NotifyDEBUGBorder', { fg = colors.hint })
hl('NotifyTRACEBorder', { fg = colors.purple })
hl('NotifyERRORIcon', { fg = colors.error })
hl('NotifyWARNIcon', { fg = colors.warning })
hl('NotifyINFOIcon', { fg = colors.info })
hl('NotifyDEBUGIcon', { fg = colors.hint })
hl('NotifyTRACEIcon', { fg = colors.purple })
hl('NotifyERRORTitle', { fg = colors.error })
hl('NotifyWARNTitle', { fg = colors.warning })
hl('NotifyINFOTitle', { fg = colors.info })
hl('NotifyDEBUGTitle', { fg = colors.hint })
hl('NotifyTRACETitle', { fg = colors.purple })

return {}
