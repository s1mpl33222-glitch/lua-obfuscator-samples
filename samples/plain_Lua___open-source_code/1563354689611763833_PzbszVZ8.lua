local flags = {
    DFIntTaskSchedulerTargetFps = "120",
    FFlagAuroraLimit60HzRenderSim = "False",
    FFlagDebugDisableVsync = "True",
    FFlagGameBasicSettingsFramerateCap = "False",
    DFFlagDisableTaskSchedulerTargetFpsLowerLimit = "True",
    FFlagTaskSchedulerTargetFpsIgnoreMin = "True",
    FFlagDebugGraphicsDisableDirect3D11Limit = "True"
}

if type(setfflag) == "function" then
    for flag, value in pairs(flags) do
        local success, err = pcall(function()
            setfflag(flag, value)
        end)

        print(flag, success and "Applied" or ("Failed: " .. tostring(err)))
    end
else
    warn("Your executor does not support setfflag.")
end