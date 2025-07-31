-- this is the file for repl like functionality in code
-- quarto.nvim is kinda related, as it lets me edit jupyter notebook type files, but that has it's
-- own config file
--
if not string.find(vim.fn.hostname(), "node") then
  return {
    {
      "benlubas/molten-nvim",
      -- enabled = false,
      dependencies = { "image.nvim", "wezterm.nvim" },
      ft = { "python", "norg", "markdown", "quarto", "julia" }, -- this is just to avoid loading image.nvim, loading molten at the start has minimal startup time impact
      -- dev = true,
      init = function()
        -- if IsLinux() then -- xdg-open doesn't work on NixOS from within programs
        --   vim.g.molten_open_cmd = "firefox"
        -- end

        -- vim.g.molten_cover_empty_lines = true
        -- vim.g.molten_comment_string = "# %%"
        vim.keymap.set({ "v", "n" }, "<leader><leader>R", "<Cmd>MoltenEvaluateVisual<CR>")

        vim.g.molten_auto_open_output = false
        vim.g.molten_image_location = "both"
        vim.g.molten_image_provider = "wezterm"
        vim.g.molten_output_show_more = true
        vim.g.molten_output_win_border = { "", "━", "", "" }
        vim.g.molten_output_win_max_height = 100
        -- vim.g.molten_output_virt_lines = true
        vim.g.molten_virt_text_output = true
        vim.g.molten_use_border_highlights = true
        vim.g.molten_virt_lines_off_by_1 = true
        vim.g.molten_wrap_output = true
        vim.g.molten_tick_rate = 142
        local function ensure_kernel_for_venv()
          local venv_path = os.getenv "VIRTUAL_ENV" or os.getenv "CONDA_PREFIX"
          if not venv_path then
            vim.notify("No virtual environment found.", vim.log.levels.WARN)
            return
          end

          -- Canonicalize the venv_path to ensure consistency
          venv_path = vim.fn.fnamemodify(venv_path, ":p")

          -- Check if the kernel spec already exists
          local handle = io.popen "jupyter kernelspec list --json"
          local existing_kernels = {}
          if handle then
            local result = handle:read "*a"
            handle:close()
            local json = vim.fn.json_decode(result)
            -- Iterate over available kernel specs to find the one for this virtual environment
            for kernel_name, data in pairs(json.kernelspecs) do
              existing_kernels[kernel_name] = true -- Store existing kernel names for validation
              local kernel_path = vim.fn.fnamemodify(data.spec.argv[1], ":p") -- Canonicalize the kernel path
              if kernel_path:find(venv_path, 1, true) then
                vim.notify("Kernel spec for this virtual environment already exists.", vim.log.levels.INFO)
                return kernel_name
              end
            end
          end

          -- Prompt the user for a custom kernel name, ensuring it is unique
          local new_kernel_name
          repeat
            new_kernel_name = vim.fn.input "Enter a unique name for the new kernel spec: "
            if new_kernel_name == "" then
              vim.notify("Please provide a valid kernel name.", vim.log.levels.ERROR)
              return
            elseif existing_kernels[new_kernel_name] then
              vim.notify(
                "Kernel name '" .. new_kernel_name .. "' already exists. Please choose another name.",
                vim.log.levels.WARN
              )
              new_kernel_name = nil
            end
          until new_kernel_name

          -- Create the kernel spec with the unique name
          print "Creating a new kernel spec for this virtual environment..."
          local cmd = string.format(
            '%s -m ipykernel install --user --name="%s"',
            vim.fn.shellescape(venv_path .. "/bin/python"),
            new_kernel_name
          )

          os.execute(cmd)
          vim.notify("Kernel spec '" .. new_kernel_name .. "' created successfully.", vim.log.levels.INFO)
          return new_kernel_name
        end

        vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { desc = "Initialize Molten", silent = true })
        vim.keymap.set("n", "<localleader>ir", function()
          vim.cmd "MoltenInit rust"
        end, { desc = "Initialize Molten for Rust", silent = true })
        vim.keymap.set("n", "<localleader>ip", function()
          local venv = os.getenv "VIRTUAL_ENV"
          local kernel_name = ensure_kernel_for_venv()
          if kernel_name then
            vim.cmd(("MoltenInit %s"):format(kernel_name))
          else
            vim.notify("No kernel to initialize.", vim.log.levels.WARN)
          end
          -- if venv ~= nil then
          --   -- in the form of /home/benlubas/.virtualenvs/VENV_NAME
          --   venv = string.match(venv, "/.+/(.+)")
          --   vim.cmd(("MoltenInit %s"):format(venv))
          -- else
          --   vim.cmd "MoltenInit python3"
          -- end
        end, { desc = "Initialize Molten for python3", silent = true, noremap = true })

        vim.api.nvim_create_autocmd("User", {
          pattern = "MoltenInitPost",
          callback = function()
            -- quarto code runner mappings
            local r = require "quarto.runner"
            vim.keymap.set("n", "<localleader>rc", r.run_cell, { desc = "run cell", silent = true })
            vim.keymap.set("n", "<localleader>ra", r.run_above, { desc = "run cell and above", silent = true })
            vim.keymap.set("n", "<localleader>rb", r.run_below, { desc = "run cell and below", silent = true })
            vim.keymap.set("n", "<localleader>rl", r.run_line, { desc = "run line", silent = true })
            vim.keymap.set("n", "<localleader>rA", r.run_all, { desc = "run all cells", silent = true })
            vim.keymap.set("n", "<localleader>RA", function()
              r.run_all(true)
            end, { desc = "run all cells of all languages", silent = true })

            -- setup some molten specific keybindings
            vim.keymap.set(
              "n",
              "<localleader>e",
              ":MoltenEvaluateOperator<CR>",
              { desc = "evaluate operator", silent = true }
            )
            vim.keymap.set(
              "n",
              "<localleader>rr",
              ":MoltenReevaluateCell<CR>",
              { desc = "re-eval cell", silent = true }
            )
            vim.keymap.set(
              "v",
              "<localleader>r",
              ":<C-u>MoltenEvaluateVisual<CR>gv",
              { desc = "execute visual selection", silent = true }
            )
            vim.keymap.set(
              "n",
              "<localleader>os",
              ":noautocmd MoltenEnterOutput<CR>",
              { desc = "open output window", silent = true }
            )
            vim.keymap.set(
              "n",
              "<localleader>oh",
              ":MoltenHideOutput<CR>",
              { desc = "close output window", silent = true }
            )
            vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })
            local open = false
            vim.keymap.set("n", "<localleader>ot", function()
              open = not open
              vim.fn.MoltenUpdateOption("auto_open_output", open)
            end)

            -- if we're in a python file, change the configuration a little
            if vim.bo.filetype == "python" then
              vim.fn.MoltenUpdateOption("molten_virt_lines_off_by_1", false)
              vim.fn.MoltenUpdateOption("molten_virt_text_output", false)
            end
          end,
        })

        -- change the configuration when editing a python file
        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = "*.py",
          callback = function(e)
            if string.match(e.file, ".otter.") then
              return
            end
            if require("molten.status").initialized() == "Molten" then
              vim.fn.MoltenUpdateOption("molten_virt_lines_off_by_1", false)
              vim.fn.MoltenUpdateOption("molten_virt_text_output", false)
            end
          end,
        })

        -- Undo those config changes when we go back to a markdown or quarto file
        -- vim.api.nvim_create_autocmd("BufEnter", {
        --   pattern = { "*.qmd", "*.md", "*.ipynb" },
        --   callback = function()
        --     if require("molten.status").initialized() == "Molten" then
        --       vim.fn.MoltenUpdateOption("molten_virt_lines_off_by_1", true)
        --       vim.fn.MoltenUpdateOption("molten_virt_text_output", true)
        --     end
        --   end,
        -- })

        local imb = function(e)
          vim.schedule(function()
            local kernels = vim.fn.MoltenAvailableKernels()

            local try_kernel_name = function()
              local metadata = vim.json.decode(io.open(e.file, "r"):read "a")["metadata"]
              return metadata.kernelspec.name
            end
            local ok, kernel_name = pcall(try_kernel_name)

            if not ok or not vim.tbl_contains(kernels, kernel_name) then
              kernel_name = nil
              local venv = os.getenv "VIRTUAL_ENV"
              if venv ~= nil then
                kernel_name = string.match(venv, "/.+/(.+)")
              end
            end

            if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
              vim.cmd(("MoltenInit %s"):format(kernel_name))
            end
            vim.cmd "MoltenImportOutput"
          end)
        end

        -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
        --   vim.api.nvim_create_autocmd("BufEnter", {
        --     pattern = { "*.ipynb" },
        --     callback = function(e)
        --       if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
        --         imb(e)
        --       end
        --     end,
        --   })
        --
        --   -- automatically import output chunks from a jupyter notebook
        --   vim.api.nvim_create_autocmd("BufAdd", {
        --     pattern = { "*.ipynb" },
        --     callback = imb,
        --   })
        --
        --   -- automatically export output chunks to a jupyter notebook
        --   vim.api.nvim_create_autocmd("BufWritePost", {
        --     pattern = { "*.ipynb" },
        --     callback = function()
        --       if require("molten.status").initialized() == "Molten" then
        --         vim.cmd("MoltenExportOutput!")
        --       end
        --     end,
        --   })
      end,
    },
  }
else
  return {}
end
