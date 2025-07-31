-- Open file with xdg
function OpenFileInxdg()
  -- Get the filename under the cursor
  local file = vim.fn.expand("<cfile>")

  -- Define the command to open the file in Okular
  local cmd = "xdg-open " .. file .. " &"
  print("Executing:" .. cmd)

  -- Execute the command asynchronously
  vim.fn.jobstart(cmd, {
    -- Optionally, you can set up a callback to handle when the job is done
    on_exit = function(id, code, event)
      if code == 0 then
        print("Opened " .. file .. " in xdg successfully.")
      else
        print("Failed to open " .. file .. ". Exit code: " .. code)
      end
    end,
  })
end

-- ~/ressources/paper/rl/Deep-RMSA_A_Deep-Reinforcement-Learning_Routing_Modulation_and_Spectrum_Assignment_Agent_for_Elastic_Optical_Networks.pdf
