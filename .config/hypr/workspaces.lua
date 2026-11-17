
-- ╔══════════════════════╗
-- ║     WORKSPACES       ║
-- ╚══════════════════════╝

-- Smart gaps for special workspace transitions
hl.workspace_rule({
    workspace = "w[tv1]",
    gaps_in = 0,
    gaps_out = 0,
    no_border = true
})

hl.workspace_rule({
    workspace = "f[1]",
    gaps_in = 0,
    gaps_out = 0,
    no_border = true
})

-- Automatically launch Kitty when the scratchpad
-- workspace is created and is empty.
hl.on("workspace.created", function(ws)

    -- Only handle the scratchpad workspace
    if ws.name ~= "special:scratchpad" then
        return
    end

    -- Do not launch Kitty if the workspace isn't empty
    if not ws.is_empty then
        return
    end

    -- Launch Kitty silently on the scratchpad workspace
    hl.exec_cmd("kitty", {
        workspace = ws.name .. " silent"
    })

end)

