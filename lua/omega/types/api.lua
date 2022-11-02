---@alias autocmd_event "BufAdd"|"BufDelete"|"BufEnter"|"BufFilePost"|"BufFilePre"|"BufHidden"|"BufLeave"|"BufModifiedSet"|"BufNew"|"BufNewFile"|"BufRead"|"BufReadCmd"|"BufUnload"|"BufWinEnter"|"BufWinLeave"|"BufWipeout"|"BufWrite"|"BufWritePre"|"BufWriteCmd"|"BufWritePost"|"ChanInfo"|"ChanOpen"|"CmdUndefined"|"CmdlineChanged"|"CmdlineEnter"|"CmdlineLeave"|"CmdwinEnter"|"CmdwinLeave"|"ColorScheme"|"ColorschemePre"|"CompleteChanged"|"CompleteDonePre"|"CompleteDone"|"CursorHold"|"CursorHoldI"|"CursorMoved"|"CursorMovedI"|"DiffUpdated"|"DirChanged"|"DirChangedPre"|"ExitPre"|"FileAppendCmd"|"FileAppendPost"|"FileAppendPre"|"FileChangedRO"|"FileChangedShell"|"FileChangedShellPost"|"FileReadCmd"|"FileReadPost"|"FileReadPre"|"FileType"|"FileWriteCmd"|"FileWritePost"|"FileWritePre"|"FilterReadPost"|"FilterReadPre"|"FilterWritePost"|"FilterWritePre"|"FocusGained"|"FocusLost"|"FuncUndefined"|"UIEnter"|"UILeave"|"InsertChange"|"InsertCharPre"|"InsertEnter"|"InsertLeavePre"|"InsertLeave"|"MenuPopup"|"ModeChanged"|"OptionSet"|"QuickFixCmdPre"|"QuickFixCmdPost"|"QuitPre"|"RemoteReply"|"SearchWrapped"|"RecordingEnter"|"RecordingLeave"|"SessionLoadPost"|"ShellCmdPost"|"Signal"|"ShellFilterPost"|"SourcePre"|"SourcePost"|"SourceCmd"|"SpellFileMissing"|"StdinReadPost"|"StdinReadPre"|"SwapExists"|"Syntax"|"TabEnter"|"TabLeave"|"TabNew"|"TabNewEntered"|"TabClosed"|"TermOpen"|"TermEnter"|"TermLeave"|"TermClose"|"TermResponse"|"TextChanged"|"TextChangedI"|"TextChangedP"|"TextYankPost"|"User"|"UserGettingBored"|"VimEnter"|"VimLeave"|"VimLeavePre"|"VimResized"|"VimResume"|"VimSuspend"|"WinClosed"|"WinEnter"|"WinLeave"|"WinNew"|"WinScrolled"

---@class autocmd_callback_parameter
---@field id number The autocommand id
---@field event string The event which triggered the autocommand
---@field group number|nil The id of the augroup if one exists
---@field match string The vale of the match |<amatch>|
---@field buf number The buffer from which the autocmd was executed
---@field file string The file in which the autocmd was executed
---@field data any Data that was passed to `nvim_exec_autocmds()`

---@class autocmd_opts
---@field pattern string|table #pattern or patterns to match against |autocmd-pattern|.
---@field desc string #description of the autocommand.
---@field once boolean
---@field group string|integer #the autocommand group name or id to match against
---@field buffer number #buffer number for buffer local autocommands |autocmd-buflocal|. Cannot be used with {pattern}.
---@field callback fun(arg:autocmd_callback_parameter)|string

---@param event autocmd_event[]|autocmd_event
---@param opts autocmd_opts
function vim.api.nvim_create_autocmd(event, opts) end
