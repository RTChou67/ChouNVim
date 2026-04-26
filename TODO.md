# Neovim Configuration TODO

> 最后更新: 2026-04-26
> 当前原则: 先稳住基础路径，再做插件迁移；新插件只在能替代重复功能或解决明确痛点时引入。

## 状态标记

- `[ ]` 未开始
- `[-]` 正在做
- `[x]` 已完成或已验证
- `[?]` 需要先决策

## 当前结论

这次 review 后，旧 TODO 里一批 P0 已经过期：Trouble 命令、Noice 路由、LSP 快捷键、Mason 启动安装、Conform/LSP 旧 API、Markdown 右键菜单和 LivePreview 已经修过。

当前真正需要优先处理的是 Treesitter。现在本机是 Neovim 0.11.6，但 `lazy-lock.json` 里的 `nvim-treesitter` 锁在 `main` 分支；本地 README 明确说明这是不兼容重写，要求 Neovim 0.12.0+，而 `master` 才是给 Nvim 0.11 的兼容分支。因此目前的 `ensure_installed/highlight/indent` 旧式配置不再可靠，实际 headless 检查里 Lua buffer 没有启动 Treesitter highlighter。

## 已完成并验证

- [x] 修复 Markdown 右键菜单缺失 `menus.markdown` 导致的报错。
  - commit: `75476d0 Fix markdown menu and live preview`
  - 验证: `require("menu").open("markdown", { mouse = true })` 正常。
- [x] 修复 LivePreview 调用方式。
  - commit: `75476d0 Fix markdown menu and live preview`
  - 当前有效命令是 `:LivePreview start`。
- [x] 迁移 LSP 到 Neovim 0.11 API。
  - commit: `2896b77 Migrate LSP setup to Neovim 0.11`
  - 使用 `vim.lsp.config()` / `vim.lsp.enable()`。
- [x] 移除 Mason 启动期自动安装和 registry refresh。
  - commit: `8b1563f Avoid Mason auto installs during startup`
- [x] 修复 Neo-tree 右键菜单动作名。
  - commit: `96418e2 Override neo-tree context menu`
  - 本地覆盖 `lua/menus/neo-tree.lua`，避免 upstream menu 的 `Delete` 动作名问题。
- [x] 更新 Conform 和 LSP deprecated API。
  - commit: `3637c84 Update deprecated Neovim and Conform APIs`
  - 使用 `lsp_format = "fallback"` 和 `vim.lsp.get_clients()`。
- [x] 让 LSP 在第一个 Lua buffer 前注册。
  - commit: `9731af6 Register LSP before first buffer`
  - `nvim-lspconfig` 当前 `lazy = false`。

## P0: 必须先修

### 1. Treesitter 分支/API 决策

- [?] 二选一：
  - 保守方案: 在 Neovim 仍是 0.11.x 时，把 `nvim-treesitter` 固定到 `master` 分支，并保留旧式 `ensure_installed/highlight/indent` 配置。
  - 迁移方案: 升级到 Neovim 0.12+，继续使用 `main` 分支，并按新 API 改配置。
- [ ] 当前推荐先做保守方案，因为系统实际版本是 `NVIM v0.11.6`。
- [ ] 修复后验证：
  - `:checkhealth nvim-treesitter`
  - 打开 Lua / Python / Markdown 后确认 Treesitter highlight 启动
  - `:InspectTree` 或 `vim.treesitter.highlighter.active[bufnr]` 能看到 active highlighter
- [ ] 同步审查依赖 Treesitter 的插件：
  - `render-markdown.nvim`
  - `nvim-treesitter-context`
  - `dropbar.nvim`
  - `aerial.nvim`
  - `nvim-autopairs` 的 `check_ts = true`

### 2. 右键菜单配置收敛

- [ ] `lua/nvconfig.lua` 里仍有 `nvimtree` 菜单表，实际插件是 Neo-tree，且现在真正生效的是 `lua/menus/neo-tree.lua`。
- [ ] 决定菜单来源：
  - 保留 `nvconfig.menu.markdown` + `lua/menus/markdown.lua`
  - 删除或改名不再使用的 `nvconfig.menu.nvimtree`
  - 如需要自定义 default 菜单，再新增 `lua/menus/default.lua`
- [ ] 评估 `<RightMouse>` 是否也需要 visual mode 映射。
- [ ] 验证：
  - 普通 buffer 右键
  - Markdown buffer 右键
  - Neo-tree buffer 右键
  - visual selection 后右键

### 3. UI 重叠与默认启用策略

- [ ] `snacks.nvim` 当前全局启用 `notifier/dashboard/scroll/input/terminal/bigfile/words/indent`，需要逐项确认是否和现有插件重复。
- [ ] 重点检查：
  - `snacks.notifier` vs `noice.nvim`
  - `snacks.scroll` vs `nvim-scrollview`
  - `snacks.indent` vs 将来可能添加的缩进插件
  - `snacks.dashboard` 是否真的需要常驻
- [ ] `showkeys` 当前 `VeryLazy` 后自动 `toggle()`，建议改成默认关闭，只保留命令/快捷键。
- [ ] 验证启动消息、通知、滚动条、缩进线和按键显示没有重复或遮挡。

### 4. format/lint 策略落地

- [ ] `conform.nvim` 现在对所有普通文件保存时返回 format 配置，建议增加文件类型/formatter 可用性检查，减少无 formatter 文件的噪声。
- [ ] `nvim-lint` 当前在 `BufEnter`、`BufWritePost`、`InsertLeave` 触发，建议减少为保存后触发，或加 debounce。
- [ ] Python 维持当前策略：
  - LSP: `pyright`
  - format: `isort` + `black`
  - lint: 暂不启用 `pylint`
- [ ] 实际验证工具是否存在：
  - `stylua`
  - `black`
  - `isort`
  - `clang-format`
  - `shfmt`
  - `shellcheck`
  - `yamllint`

### 5. 工作树卫生

- [ ] 不要误提交现有用户改动，当前未提交项需要分别处理：
  - `init.lua`: 仅尾随空格
  - `lazy-lock.json`: 大量插件更新，包括新增 `menu`
  - `lua/plugins/editor/neo-tree.lua`: 用户已改为显示隐藏文件和 gitignored 文件
  - `.codex`、`.nvimlog`: 未跟踪文件，先不要纳入配置提交
- [ ] 每个真实修复单独 commit，避免把 lockfile 大升级和配置修复混在一起。

## P1: 稳定体验

### 6. Keymap 与 which-key 一致性

- [ ] 统一前缀含义：
  - `<leader>f`: find/search
  - `<leader>g`: git
  - `<leader>l`: LSP
  - `<leader>m`: markdown
  - `<leader>x`: diagnostics/trouble
- [ ] 检查 `which-key` group 是否都有真实映射，避免空组。
- [ ] 修正 Telescope 描述里的固定路径文字，例如 "Find Files in /home/rtchou"。

### 7. Neo-tree 启动行为

- [ ] 重新验证 `nvim .` 是否由 Neo-tree 接管。
- [ ] 当前 `vim.g.loaded_netrw` 和 `vim.g.loaded_netrwPlugin` 已在 options 早期设置，`neo-tree` 也已 `lazy = false`。
- [ ] 只在复现失败时再增加 `VimEnter` 目录启动逻辑。

### 8. Markdown 工作流

- [ ] 保持 `render-markdown` 默认 `enabled = false`，通过菜单或命令按需启用。
- [ ] LivePreview 使用浏览器预览，命令统一为 `LivePreview start`。
- [ ] 如 Treesitter 回退到 `master`，需要复测 `markdown` 和 `markdown_inline` parser。

### 9. 健康检查脚本化

- [ ] 建立最小验证命令清单：
  - Lua 语法检查
  - headless startup
  - LSP first-buffer attach
  - Markdown menu open
  - LivePreview command exists
  - Treesitter health/highlight
- [ ] 每次插件迁移前后都跑同一套检查。

## P2: 插件候选池

只在 P0/P1 稳定后再加。候选插件按“明确收益”和“与现有功能是否重复”排序。

### Treesitter 方向

- [?] 没有真正的一比一替代品。`nvim-treesitter` 仍是 parser/query 管理的事实标准，只是现在分成旧 `master` 兼容线和新 `main`/Neovim 0.12+ API。
- [?] 如果短期继续用 Neovim 0.11： pin `nvim-treesitter` 到 `master`。
- [?] 如果升级到 Neovim 0.12+：迁移到新 API，使用 `vim.treesitter.start()` 和 `require("nvim-treesitter").install(...)`，不再沿用旧 `ensure_installed/highlight/indent` 写法。
- [?] 如果想减少插件依赖：用 Neovim 内置 `vim.treesitter` 做 highlight/fold，自己管理 parser 安装；但这不是完整替代，维护成本更高。

### 可以认真评估

- [?] `saghen/blink.cmp`
  - 现代补全框架，可能替代 `nvim-cmp` 全家桶。
  - 迁移成本中等，不建议和 Treesitter 修复同一批做。
- [?] `folke/flash.nvim`
  - 增强跳转；和现有插件重叠少。
- [?] `stevearc/oil.nvim` 或 `echasnovski/mini.files`
  - 文件管理的“编辑 buffer”模型；可以作为 Neo-tree 的轻量补充，但不急。
- [?] `nvim-pack/nvim-spectre`
  - 项目级搜索替换；和 Telescope 互补。
- [?] `akinsho/git-conflict.nvim`
  - Git 冲突处理；和现有 diffview/gitsigns 互补。
- [?] `mbbill/undotree`
  - 撤销树可视化；功能独立、低风险。
- [?] `ibhagwan/fzf-lua`
  - 可作为 Telescope 的替代候选；如果以后想收敛 picker 生态，可以和 `snacks.picker` 一起比较。

### 暂不建议立即加

- [ ] DAP / neotest
  - 需要先明确常用语言和 adapter，不要先装一整套。
- [ ] 多光标、数据库、REST 客户端、代码截图、笔记系统
  - 当前不解决基础稳定性问题。
- [ ] 更多 UI 插件
  - 现有 UI 已经偏满，先减重再增强。

## 建议执行顺序

1. 修 Treesitter 分支/API 不匹配。
2. 收敛右键菜单配置。
3. 减少 UI 重叠：先处理 `showkeys` 和 `snacks`/`noice`/`scrollview`。
4. 收敛 format/lint 触发策略。
5. 再评估 `blink.cmp`、`flash.nvim`、`oil.nvim`、`spectre` 等插件。

## 每次改动前自检

- [ ] 这是在修真实问题，还是只是在加新插件？
- [ ] 是否和现有插件重复？
- [ ] 是否影响启动路径、第一 buffer、右键菜单或保存流程？
- [ ] 是否有 headless 验证步骤？
- [ ] 是否需要单独 commit，而不是混进 lockfile 更新？
