return {
	setup = function()
		-- Define the default opener for each OS
		local commands = {
			linux = "xdg-open %s1",
			macos = "open %s1",
		}

		local command = commands[ya.target_os()]
		if not command then
			return
		end

		-- Register the system default opener
		rt.opener.system_default = {
			{
				run = command,
				desc = "System default",
				orphan = true,
			},
		}

		-- Append the opener to all existing open rules
		for _, rule in pairs(rt.open.rules:match()) do
			rule.use[#rule.use + 1] = "system_default"

			rt.open.rules:update({ id = rule.id }, { use = rule.use })
		end
	end,
}
