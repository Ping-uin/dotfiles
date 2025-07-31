return {
  "David-Kunz/gen.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    model = "deepseek-coder-v2:16b", -- The default model to use.
    -- The host running the Ollama service.
    host = "https://ksc02drio4j8kzbt.myfritz.net/ollama_ext",
    port = "ollama_ext", -- The port on which the Ollama service is listening.
    quit_map = "q", -- set keymap for close the response window
    retry_map = "<c-r>", -- set keymap to re-send the current prompt
    -- init = function(options)
    --   pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
    -- end,
    -- Function to initialize Ollama
    command = function(options)
      local secret = vim.fn.getenv "ollamakey"
      local body = { model = options.model, stream = true }
      local api_call = "curl --silent --no-buffer -X POST "
        .. options.host
        .. "/api/chat "
        .. "-H 'Authorization: Bearer "
        .. secret
        .. "' -d $body"

      return api_call
    end,
    -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
    -- This can also be a command string.
    -- The executed command must return a JSON object with { response, context }
    -- (context property is optional).
    -- list_models = '<omitted lua function>', -- Retrieves a list of model names
    display_mode = "float", -- The display mode. Can be "float" or "split" or "horizontal-split".
    show_prompt = false, -- Shows the prompt submitted to Ollama.
    show_model = false, -- Displays which model you are using at the beginning of your chat session.
    no_auto_close = true, -- Never closes the window automatically.
    debug = false, -- Prints errors and the command which is run.
  },
}
