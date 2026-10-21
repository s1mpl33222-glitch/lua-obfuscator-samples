if _G.StickyFrontTP == nil then _G.StickyFrontTP = false end
if _G.StickySideTP == nil then _G.StickySideTP = true end
if _G.StickySideTPRange == nil then _G.StickySideTPRange = 100 end
_G.StickyStealPrioKey = _G.StickyStealPrioKey or "P"
_G.StickyStealNearKey = _G.StickyStealNearKey or "F"
if _G.StickyCFrameGoTo == nil then _G.StickyCFrameGoTo = false end
_G.StickyNoCollide = true
if _G.StickyNoCollideConstraints == nil then _G.StickyNoCollideConstraints = true end

_G.StickyCFrameGoSpeed = tonumber(_G.StickyCFrameGoSpeed) or 35
if _G.StickyTPTrail == nil then _G.StickyTPTrail = false end
if _G.StickyHybridTP == nil then _G.StickyHybridTP = false end
_G.StickyDropKeyName = _G.StickyDropKeyName or "B"
_G.StickyResetKeyName = _G.StickyResetKeyName or "X"
_G.StickyInvisKeyName = _G.StickyInvisKeyName or "U"
_G.StickyCloneKeyName = _G.StickyCloneKeyName or "V"
_G.StickyCarpetSpeedKeyName = _G.StickyCarpetSpeedKeyName or "Q"
_G.StickyNearestKey = _G.StickyNearestKey or "F"
_G.StickyStealQuickKey = _G.StickyStealQuickKey or "C"
_G.StickyStopTPKeyName = _G.StickyStopTPKeyName or "N"
_G.StickyKickKeyName = _G.StickyKickKeyName or "K"
_G._stp_tpKeyName = _G._stp_tpKeyName or "T"
do
    local POS_FILE = "StickyPanelPositions.json"
    local HttpService = game:GetService("HttpService")

    local saved = {}
    pcall(function()
        if type(readfile) ~= "function" then return end
        if type(isfile) == "function" and not isfile(POS_FILE) then return end
        local raw = readfile(POS_FILE)
        if type(raw) == "string" and #raw > 0 then
            local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
            if ok and type(data) == "table" then saved = data end
        end
    end)

    local lastChange, writePending = 0, false
    local function queueWrite()
        lastChange = os.clock()
        if writePending then return end
        writePending = true
        task.spawn(function()
            while os.clock() - lastChange < 0.5 do task.wait(0.1) end
            writePending = false
            if type(writefile) ~= "function" then return end
            pcall(function() writefile(POS_FILE, HttpService:JSONEncode(saved)) end)
        end)
    end

    local function clampOnScreen(frame)
        if not frame or not frame.Parent then return end
        local sg = frame:FindFirstAncestorOfClass("ScreenGui")
        local screen = sg and sg.AbsoluteSize
        if not screen or screen.X < 50 or screen.Y < 50 then return end
        local pos, size = frame.AbsolutePosition, frame.AbsoluteSize
        if size.X <= 0 or size.Y <= 0 then return end
        local margin = 4
        local maxX = math.max(screen.X - size.X - margin, margin)
        local maxY = math.max(screen.Y - size.Y - margin, margin)
        local dx = (pos.X < margin and margin - pos.X) or (pos.X > maxX and maxX - pos.X) or 0
        local dy = (pos.Y < margin and margin - pos.Y) or (pos.Y > maxY and maxY - pos.Y) or 0
        if math.abs(dx) >= 1 or math.abs(dy) >= 1 then
            local p = frame.Position
            frame.Position = UDim2.new(p.X.Scale, p.X.Offset + math.floor(dx + 0.5), p.Y.Scale, p.Y.Offset + math.floor(dy + 0.5))
        end
    end
    _G.StickyClampPanel = clampOnScreen

    local registered = setmetatable({}, { __mode = "k" })
    _G.StickyRememberPanel = function(frame, key)
        if typeof(frame) ~= "Instance" or not frame:IsA("GuiObject") or type(key) ~= "string" then return end
        if registered[frame] then return end
        registered[frame] = key
        local entry = saved[key]
        if type(entry) == "table" and tonumber(entry.xo) and tonumber(entry.yo) then
            pcall(function()
                frame.Position = UDim2.new(tonumber(entry.xs) or 0, tonumber(entry.xo), tonumber(entry.ys) or 0, tonumber(entry.yo))
            end)
        end
        frame:GetPropertyChangedSignal("Position"):Connect(function()
            if not frame.Parent then return end
            local p = frame.Position
            saved[key] = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
            queueWrite()
        end)
        local function clampSoon() task.defer(function() pcall(clampOnScreen, frame) end) end
        task.delay(0.25, function() pcall(clampOnScreen, frame) end)
        frame:GetPropertyChangedSignal("Visible"):Connect(function() if frame.Visible then clampSoon() end end)
        local sg = frame:FindFirstAncestorOfClass("ScreenGui")
        if sg then
            sg:GetPropertyChangedSignal("AbsoluteSize"):Connect(clampSoon)
            sg:GetPropertyChangedSignal("Enabled"):Connect(function() if sg.Enabled then clampSoon() end end)
        end
    end

end
	do
		if _G.StickyXrayAlpha == nil then _G.StickyXrayAlpha = 0.5 end
		local xrayOriginal = setmetatable({}, { __mode = "k" })
		local xrayConns = {}
		local xrayLoopId = 0
		local function xrayAlpha()
			return math.clamp(tonumber(_G.StickyXrayAlpha) or 0.5, 0.05, 0.95)
		end
		local XRAY_FOLDERS = { "Base", "PlotSign", "FriendPanel", "Cash", "Laser", "Decorations", "Skin", "Unlock", "Purchases" }
		local function setTransparency(instance, alpha, loopId)
			if not instance or loopId ~= xrayLoopId then return end
			local function apply(obj)
				if not obj:IsA("BasePart") then return end
				if xrayOriginal[obj] == nil then
					xrayOriginal[obj] = (obj.Transparency == alpha) and 0 or obj.Transparency
				end
				local orig = xrayOriginal[obj]
				if orig < 1 then
					local target = orig + (1 - orig) * alpha
					if math.abs(obj.Transparency - target) > 0.01 then obj.Transparency = target end
				end
			end
			apply(instance)
			for i, child in ipairs(instance:GetDescendants()) do
				apply(child)
				if i % 400 == 0 then
					if loopId ~= xrayLoopId then return end
				end
			end
		end
		local function trackSubtree(root, alpha, loopId)
			if not root or loopId ~= xrayLoopId then return end
			setTransparency(root, alpha, loopId)
			xrayConns[#xrayConns + 1] = root.DescendantAdded:Connect(function(obj)
				if loopId == xrayLoopId then setTransparency(obj, alpha, loopId) end
			end)
		end
		local function processPlot(plot, alpha, loopId)
			if not plot or loopId ~= xrayLoopId then return end
			for _, fname in ipairs(XRAY_FOLDERS) do
				trackSubtree(plot:FindFirstChild(fname), alpha, loopId)
			end
			xrayConns[#xrayConns + 1] = plot.ChildAdded:Connect(function(child)
				if loopId ~= xrayLoopId then return end
				for _, fname in ipairs(XRAY_FOLDERS) do
					if child.Name == fname then trackSubtree(child, alpha, loopId); break end
				end
			end)
			local podiums = plot:FindFirstChild("AnimalPodiums")
			if not podiums then return end
			local function processPodium(podium)
				for _, child in ipairs(podium:GetChildren()) do
					if child.Name == "Claim" then
						trackSubtree(child, alpha, loopId)
					elseif child.Name == "Base" then
						trackSubtree(child:FindFirstChild("Decorations"), alpha, loopId)
					elseif child:IsA("Model") and child.Name ~= "Decorations" then
						trackSubtree(child, alpha, loopId)
					end
				end
			end
			for _, podium in ipairs(podiums:GetChildren()) do processPodium(podium) end
			xrayConns[#xrayConns + 1] = podiums.ChildAdded:Connect(function(podium)
				if loopId == xrayLoopId then processPodium(podium) end
			end)
		end
		local function enableXray()
			for _, c in ipairs(xrayConns) do
				if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end) end
			end
			xrayConns = {}
			xrayLoopId = xrayLoopId + 1
			local id = xrayLoopId
			local plotsFolder = workspace:FindFirstChild("Plots")
			if not plotsFolder then return end
			for _, plot in ipairs(plotsFolder:GetChildren()) do
				if id ~= xrayLoopId then return end
				processPlot(plot, xrayAlpha(), id)
			end
			xrayConns[#xrayConns + 1] = plotsFolder.ChildAdded:Connect(function(plot)
				if id == xrayLoopId then processPlot(plot, xrayAlpha(), id) end
			end)
		end
		local function disableXray()
			for _, c in ipairs(xrayConns) do
				if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end) end
			end
			xrayConns = {}
			xrayLoopId = xrayLoopId + 1
			local snapshot = xrayOriginal
			xrayOriginal = setmetatable({}, { __mode = "k" })
			for obj, orig in pairs(snapshot) do
				pcall(function() if obj:IsA("BasePart") then obj.Transparency = orig end end)
			end
		end
		_G.StickyEnableXray = enableXray
		_G.StickyDisableXray = disableXray
		local function plotsWorldReady()
			local plotsFolder = workspace:FindFirstChild("Plots")
			if not plotsFolder then return false end
			local n = 0
			pcall(function() n = #plotsFolder:GetChildren() end)
			return n > 0
		end
		local function applyXrayIfEnabled()
			if _G.StickyXray ~= true then return false end
			if not plotsWorldReady() then return false end
			enableXray()
			return true
		end
		local xrayRetrying = false
		local function startXrayRetry()
			if _G.StickyXray ~= true then return end
			if xrayRetrying then return end
			xrayRetrying = true
			task.spawn(function()
				local waitMax = tonumber(_G.StickyXrayWaitMax) or 90
				local t0 = os.clock()
				local childConn
				childConn = workspace.ChildAdded:Connect(function(ch)
					if ch.Name == "Plots" and _G.StickyXray == true then
						task.defer(function()
							if plotsWorldReady() then applyXrayIfEnabled() end
						end)
					end
				end)
				while _G.StickyXray == true and (os.clock() - t0) < waitMax do
					if applyXrayIfEnabled() then break end
					task.wait(0.15)
				end
				if childConn then pcall(function() childConn:Disconnect() end) end
				xrayRetrying = false
			end)
		end
		_G.StickyApplyXrayIfEnabled = applyXrayIfEnabled
		_G.StickyStartXrayRetry = startXrayRetry
	end

local fflags = {
    ["DFIntTaskSchedulerTargetFps"] = "9999",
    ["FFlagTaskSchedulerLimitTargetFpsToDevice"] = "False",
    ["FFlagTaskSchedulerLimitTargetFpsTo2402"] = "False",
    ["FFlagGameBasicSettingsFramerateCap5"] = "False",
    ["FIntTaskSchedulerAutoThreadLimit"] = "8",
    ["DFIntTaskSchedulerJobInitThreads"] = "8",
    ["DFIntTaskSchedulerJobInGameThreads"] = "8",
    ["FIntRuntimeMaxNumOfThreads"] = "1000000",
    ["DFIntRuntimeConcurrency"] = "16",
    ["FIntRuntimeMaxNumOfMutexes"] = "1000000",
    ["FIntRuntimeMaxNumOfSemaphores"] = "1000000",
    ["FIntRuntimeMaxNumOfLatches"] = "1000000",
    ["FIntSimWorldTaskQueueParallelTasks"] = "20",

    ["FFlagEnableTextureStreaming"] = "True",
    ["FFlagPreloadAllFonts"] = "True",
    ["DFFlagEnableSoundPreloading"] = "True",
    ["DFFlagEnableMeshPreloading"] = "True",
    ["DFFlagEnableMeshPreloading2"] = "True",
    ["DFFlagEnableTexturePreloading"] = "True",
    ["DFIntAssetPreloading"] = "2147483647",
    ["DFIntNumAssetsMaxToPreload"] = "2147483647",
    ["FFlagAssetPreloadingIXP"] = "True",
    ["DFFlagEnablePreloadAvatarAssets"] = "True",
    ["DFIntPreloadAvatarAssets"] = "2147483647",
    ["DFFlagTeleportClientAssetPreloadingEnabledIXP"] = "True",
    ["DFFlagTeleportClientAssetPreloadingEnabledIXP2"] = "True",
    ["DFFlagTeleportClientAssetPreloadingEnabled9"] = "True",
    ["DFIntTeleportClientAssetPreloadingHundredthsPercentage"] = "100000",
    ["DFIntTeleportClientAssetPreloadingHundredthsPercentage2"] = "100000",
    ["DFFlagTeleportClientAssetPreloadingDoingExperiment"] = "True",
    ["DFFlagTeleportClientAssetPreloadingDoingExperiment2"] = "True",
    ["DFFlagTeleportPreloadingMetrics5"] = "True",
    ["DFFlagPreloadAsyncSupportTexturePack"] = "True",
    ["FFlagPreloadTextureItemsOption4"] = "True",
    ["FFlagUseNewLuaPreloadAssets"] = "True",
    ["DFFlagEnableScriptPreloadOnJoin"] = "True",
    ["FFlagLuaAppsScriptPreload"] = "True",
    ["DFFlagRemoveUnusedKtxMetadata"] = "True",
    ["FFlagKtx2Support3"] = "True",
    ["FFlagSlimContentProvider"] = "True",

    ["DFFlagLuaAppFastGameStartup"] = "True",
    ["FFlagFastLuaAppStartup"] = "True",
    ["FFlagAppShellAlwaysSkipExperienceLoadingScreen"] = "True",
    ["FFlagEnableQuickGameLaunch"] = "True",
    ["DFFlagEnableJoinDataDownloadOptimization"] = "True",
    ["FIntJoinDataAdditionalDataCacheTimeoutSeconds"] = "0",
    ["DFIntJoinDataCompressionLevel"] = "0",
    ["DFIntJoinDataItemEstimatedCompressionRatioHundreths"] = "0",
    ["DFIntServerFramesBetweenJoins"] = "1",
    ["DFIntClusterSenderMaxJoinBandwidthBps"] = "2100000000",
    ["DFIntClusterSenderMaxUpdateBandwidthBps"] = "2100000000",
    ["DFIntClusterCompressionLevel"] = "0",
    ["DFFlagAllowPropertyDefaultSkip"] = "True",
    ["FFlagSlimPropertySet3"] = "True",
    ["FFlagSlimService9"] = "True",

    ["DFIntMaxConcurrentDownloads"] = "64",
    ["FIntContentProviderConcurrentDownloadCount"] = "64",
    ["DFIntContentProviderTaskMaxCount"] = "64",
    ["DFIntHttpsTimeoutScaleNumerator"] = "1",
    ["DFFlagEnableRequestAsyncCompression"] = "false",
    ["DFFlagNetworkUseZstdWrapper"] = "False",

    ["FFlagEnableTextureStreamingForCSG"] = "True",
    ["DFFlagTextureStreamingPrefetchEnabled"] = "True",
    ["DFIntTextureStreamingPrefetchMaxRadius"] = "0",
    ["FFlagAdjustableTextureStreamingTargetMemory"] = "True",
    ["DFIntTextureStreamingTargetMemoryBudgetMb"] = "512",
    ["FFlagTM2SkipMipsForUnstreamable2"] = "True",
    ["DFFlagDoNotSkipMipsBasedOnSystemMemoryPS"] = "True",
    ["FIntDebugTextureManagerSkipMips"] = "8",
    ["DFIntDebugLimitMinTextureResolutionWhenSkipMips"] = "8",
    ["DFFlagTextureQualityOverrideEnabled"] = "True",
    ["DFIntTextureQualityOverride"] = "0",
    ["FFlagRenderUseTextureManager224"] = "False",

    ["DFFlagEnableAvatarOutfitCaching"] = "True",
    ["FFlagUserAvatarFetchOptimization"] = "True",
    ["DFIntAvatarOutfitCacheSize"] = "100",
    ["FFlagAvatarPipelineUseCache"] = "True",
    ["DFFlagLoadCharacterLayeredClothingProperty2"] = "False",
    ["DFFlagEnableDynamicHeadByDefault"] = "False",
    ["FFlagKeepZeroInfluenceBones"] = "False",

    ["FFlagDeferredUILoading"] = "True",
    ["DFFlagLazyLoadInGameMenu"] = "True",
    ["FFlagLuaMenuPerfImprovements"] = "True",
    ["FFlagFixIGMTabTransitions"] = "True",
    ["FFlagEnableInGameMenuChrome"] = "False",
    ["FFlagEnableInGameMenuChromeABTest2"] = "False",
    ["FFlagEnableInGameMenuDurationLogger"] = "False",

    ["DFIntReplicatorSeparateVarThresholds"] = "True",
    ["DFIntNetworkClusterPacketCacheNumParallelTasks"] = "8",
    ["DFIntReplicationDataCacheNumParallelTasks"] = "8",
    ["DFIntMegaReplicatorNumParallelTasks"] = "19",
    ["DFIntMegaReplicatorNetworkQualityProcessorUnit"] = "10",
    ["FFlagNextGenReplicatorEnabledRead"] = "true",
    ["FFlagNextGenReplicatorEnabledRead2"] = "True",
    ["FFlagNextGenReplicatorEnabledWrite"] = "true",
    ["FFlagNextGenReplicatorEnabledWrite2"] = "True",
    ["FFlagDebugNextGenReplicatorEnabledWriteCFrameColor"] = "true",
    ["DFFlagNextGenRepRollbackOverbudgetPackets"] = "True",
    ["DFFlagCorrectServerReplicatorStatsIP"] = "True",
    ["DFFlagDebugLargeReplicatorDisableCompression"] = "True",
    ["DFFlagDebugLargeReplicatorForceFullSend"] = "True",
    ["FFlagDebugLargeReplicatorEnabled"] = "True",
    ["FFlagDebugLargeReplicatorWrite"] = "True",
    ["FFlagDebugLargeReplicatorRead"] = "True",
    ["DFFlagReplicatorCheckReadTableCollisions"] = "True",
    ["FFlagOnlyDecrementCompletenessIfReplicating"] = "True",
    ["DFFlagCanClientReplicateProp"] = "False",
    ["DFIntNetworkCluster"] = "1",
    ["DFIntNetworkQualityResponderUnit"] = "10",
    ["DFIntPlayerNetworkUpdateQueueSize"] = "20",
    ["DFIntMaxProcessPacketsStepsPerCyclic"] = "5000",
    ["DFIntMaxProcessPacketsStepsAccumulated"] = "0",
    ["DFIntMaxFrameBufferSize"] = "4",
    ["DFIntOverrideISRReplicatorStepBandwidthBytes"] = "131072",
    ["DFIntServerBandwidthPlayerSampleRateFacsOverride"] = "2147483647",
    ["DFIntGameNetCompressionLodByteBudgetThresholdPct"] = "0",
    ["DFIntBufferCompressionThreshold"] = "100",

    ["DFFlagRakNetDecoupleRecvAndUpdateLoopShutdown"] = "True",
    ["DFFlagRakNetDetectNetUnreachable"] = "True",
    ["DFFlagRakNetDetectRecvThreadOverload"] = "True",
    ["DFFlagRakNetUnblockSelectOnShutdownByWritingToSocket"] = "True",
    ["DFFlagRakNetDisconnectNotification"] = "True",
    ["DFFlagRakNetCalculateApplicationFeedback2"] = "True",
    ["DFFlagSampleAndRefreshRakPing"] = "True",
    ["DFIntRakNetLoopMs"] = "1",
    ["DFIntRakNetSelectTimeoutMs"] = "1",
    ["DFIntRakNetApplicationFeedbackScaleUpThresholdPercent"] = "0",
    ["DFIntRakNetApplicationFeedbackScaleUpFactorHundredthPercent"] = "0",
    ["DFIntRakNetApplicationFeedbackMaxSpeedBPS"] = "0",
    ["DFIntRakNetNakResendDelayMsMax"] = "1",
    ["DFIntRakNetClockDriftAdjustmentPerPingMillisecond"] = "100",
    ["DFIntRaknetBandwidthInfluxHundredthsPercentageV2"] = "10000",
    ["DFIntSendRakNetStatsInterval"] = "2147483647",
    ["DFIntClientPacketExcessMicroseconds"] = "1000",
    ["DFIntClientPacketMaxDelayMs"] = "1",
    ["DFIntClientPacketMaxFrameMicroseconds"] = "200",
    ["DFIntTargetTimeDelayFacctorTenths"] = "25",
    ["DFIntWaitOnUpdateNetworkLoopEndedMS"] = "100",
    ["DFIntWaitOnRecvFromLoopEndedMS"] = "10",

    ["DFIntSignalRCoreError"] = "1",
    ["DFIntSignalRCore"] = "1",
    ["DFIntSignalRCoreTimerMs"] = "50",
    ["DFIntSignalRCoreRpcQueueSize"] = "4096",
    ["DFIntSignalRCoreNetworkHandler"] = "1",
    ["DFIntSignalRCoreHubConnectionDisconnectInfoHundredthsPercent"] = "10",
    ["DFIntSignalRCoreHandshakeTimeoutMs"] = "1000",
    ["DFIntSignalRCoreServerTimeoutMs"] = "5000",
    ["DFIntSignalRCoreKeepAlivePingPeriodMs"] = "1000",
    ["DFIntSignalRCoreHubMaxBackoffMs"] = "500",
    ["DFIntSignalRCoreHubBaseRetryMs"] = "50",
    ["DFIntSignalRHeartbeatIntervalSeconds"] = "1",
    ["DFIntSignalRHubConnectionConnectTimeoutMs"] = "7000",
    ["DFIntSignalRHubConnectionBaseRetryTimeMs"] = "50",
    ["DFIntSignalRHubConnectionMaxRetryTimeMs"] = "1000",
    ["DFIntSignalRHubConnectionHeartbeatTimerRateMs"] = "1000",

    ["FFlagLuauCodegen"] = "True",
    ["FFlagLuauCodegenFull"] = "True",
    ["FFlagLuauCodegenEnableAll"] = "True",
    ["FFlagLuauInstructionReordering"] = "True",
    ["FFlagLuauVector3FastPath"] = "True",
    ["FFlagDebugCodegenOptSize"] = "True",
    ["FFlagFasterPreciseTime4"] = "True",
    ["FFlagSortKeyOptimization"] = "True",
    ["FFlagMessageBusCallOptimization"] = "True",
    ["FFlagPushFrameTimeToHarmony"] = "True",
    ["FFlagRenderCBRefactor2"] = "True",

    ["FIntDebugForceMSAASamples"] = "0",
    ["FIntDebugFRMOptionalMSAALevelOverride"] = "0",
    ["DFIntDebugFRMQualityLevelOverride"] = "0",
    ["FFlagDisablePostProcess"] = "True",
    ["FFlagDisablePostFx"] = "True",
    ["DFFlagRenderBloomMakeResolutionIndependent"] = "False",
    ["DFFlagRenderSunRaysMakeResolutionIndependent"] = "False",
    ["FFlagDisableHQShadersLowEndDx112"] = "True",
    ["FFlagGraphicsCheckComputeSupport"] = "False",
    ["FFlagGraphicsEnableD3D10Compute"] = "True",
    ["FFlagDebugGraphicsPreferD3D11"] = "True",
    ["FFlagDebugGraphicsPreferD3D11FL10"] = "True",
    ["FFlagDebugGraphicsDisableDirect3D11"] = "False",
    ["FFlagHandleAltEnterFullscreenManually"] = "False",
    ["FIntFullscreenTitleBarTriggerDelayMillis"] = "3600000",
    ["FFlagFastGPULightCulling3"] = "True",
    ["FFlagDebugForceFSMCPULightCulling"] = "True",
    ["FFlagMSRendererLightGridOptimization"] = "True",
    ["DFFlagLightGridSimdNew3"] = "True",
    ["DFFlagProbesStaggerUpdateCalls"] = "True",
    ["FFlagNewLightAttenuation"] = "True",
    ["FFlagDebugForceFutureIsBrightPhase3"] = "True",
    ["FFlagDebugForceFutureIsBrightPhase2"] = "True",
    ["FFlagRenderDynamicResolutionScale11"] = "True",
    ["FFlagFRMRefactor"] = "False",
    ["FFlagDebugDisplayFPS"] = "True",
    ["FIntSSAOMipLevels"] = "0",
    ["FIntRenderShadowIntensity"] = "0",
    ["FIntRenderShadowmapBias"] = "0",
    ["FIntRenderLocalLightUpdatesMax"] = "1",
    ["FIntRenderLocalLightFadeInMs"] = "0",
    ["FFlagDebugRenderCollectGpuCounters"] = "True",
    ["FFlagFixGraphicsQuality"] = "True",
    ["FFlagCommitToGraphicsQualityFix"] = "True",
    ["FFlagRenderEnableHalfsPVR"] = "False",
    ["FFlagEnableAudioPannerFiltering"] = "True",
    ["FFlagRenderFixFog"] = "true",

    ["DFIntCSGLevelOfDetailSwitchingDistanceL23"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL34"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL12"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistance"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceStatic"] = "0",
    ["DFIntHACDPointSampleDistApartTenths"] = "2147483647",
    ["DFFlagDebugSkipMeshVoxelizer"] = "True",
    ["FFlagSimCSGV3IncrementalTriangulationStreamingCompression"] = "False",
    ["FFlagSortPhysicsCollisionGroups"] = "True",
    ["FFlagOptimizePhysCollide"] = "True",
    ["FFlagNewOptimizeNoCollisionPrimitiveInMidphase660"] = "True",
    ["DFFlagOptimizeNoCollisionPrimitiveInMidphaseCrash"] = "True",
    ["DFFlagJointIrregularityOptimization"] = "true",

    ["FFlagEnableTerrainMaterialsS2"] = "False",
    ["FIntTerrainArraySliceSize"] = "0",
    ["FIntRenderGrassHeightScalar"] = "0",
    ["FIntFRMMinGrassDistance"] = "0",
    ["FIntGrassMovementReducedMotionFactor"] = "0",
    ["FFlagGlobalWindRendering"] = "False",
    ["FFlagGlobalWindActivated"] = "False",
    ["FStringTerrainMaterialTable2022"] = "",
    ["FStringTerrainMaterialTablePre2022"] = "",
    ["FStringPartTexturePackTablePre2022"] = "",
    ["DFFlagDebugRenderForceTechnologyVoxel"] = "True",

    ["FFlagEnablePerformanceControlService"] = "True",
    ["DFFlagPerformanceControlEnableMemoryProbing3"] = "True",
    ["DFIntPerformanceControlFrameTimeMaxUtility"] = "-1",
    ["DFIntPerformanceControlFrameTimeMax"] = "1",
    ["DFIntPerformanceControlTextureQualityBestUtility"] = "-1",
    ["DFIntPerformanceControlReportingPeriodInMs"] = "700",
    ["DFIntNumFramesAllowedToBeAboveError"] = "1",
    ["DFIntMaxAverageFrameDelayExceedFactor"] = "1",
    ["DFIntGraphicsOptimizationModeMaxFrameTimeTargetMs"] = "25",
    ["DFIntFrameRateMSToReduceTouchEvents"] = "30",
    ["DFFlagDebugPerfMode"] = "True",
    ["DFIntMemoryUtilityCurveTotalMemoryReserve"] = "0",
    ["DFIntMemoryUtilityCurveNumSegments"] = "100",
    ["DFIntMemoryUtilityCurveBaseHundrethsPercent"] = "10000",
    ["DFIntMaxSpeedDeltaMillis"] = "1",
    ["FIntMaxSpeedDeltaMillis"] = "1",

    ["FFlagDisableTelemetryOnJoin"] = "True",
    ["DFFlagDeferTelemetryUntilAfterLoad"] = "True",
    ["FFlagDebugDisableTelemetryV2Event"] = "True",
    ["FFlagDebugDisableTelemetryV2Stat"] = "True",
    ["FFlagDebugDisableTelemetryPoint"] = "True",
    ["FFlagEnableTelemetryProtocol"] = "False",
    ["FFlagEnableTelemetryService1"] = "False",
    ["FFlagOpenTelemetryEnabled2"] = "False",
    ["FFlagEnableTelemetryServicePlaySessionInfo"] = "False",
    ["FFlagEnableTelemetryServiceMemoryCPUInfo"] = "False",
    ["DFFlagGraphicsQualityUsageTelemetry"] = "False",
    ["DFFlagReportAssetRequestV1Telemetry"] = "False",
    ["DFFlagAddMachineIDInstallerTelemetry"] = "False",
    ["DFFlagRccLoadSoundLengthTelemetryEnabled"] = "False",
    ["DFFlagBrowserTrackerIdTelemetryEnabled"] = "False",
    ["DFFlagAudioDeviceTelemetry"] = "False",
    ["DFFlagAddPlaySessionIdTelemetry"] = "False",
    ["DFFlagAddPlaySessionIdToSimConstraintTelemetryEvent"] = "False",
    ["DFFlagAddUserIdToSessionTracking"] = "False",
    ["DFIntLightstepHTTPTransportHundredthsPercent2"] = "0",
    ["DFFlagEnableLightstepReporting2"] = "False",
    ["DFIntPhysicsAnalyticsHighFrequencyIntervalSec"] = "20",
    ["DFIntClientLightingTechnologyChangedTelemetryHundredthsPercent"] = "0",
    ["DFIntContentProviderPreloadHangTelemetryHundredthsPercentage"] = "0",
    ["DFIntTrackCountryRegionAPIHundredthsPercent"] = "10000",
    ["DFIntVisibilityCheckRayCastLimitPerFrame"] = "10",
    ["DFStringTelegrafHTTPTransportUrl"] = "null",
    ["DFStringAltTelegrafHTTPTransportUrl"] = "null",
    ["DFStringLightstepToken"] = "null",
    ["DFStringLightstepHTTPTransportUrlPath"] = "null",
    ["DFStringLightstepHTTPTransportUrlHost"] = "null",
    ["DFStringRobloxAnalyticsURL"] = "null",
    ["DFStringTelemetryV2Url"] = "null",
    ["DFStringCrashUploadToBacktraceBaseUrl"] = "null",
    ["DFStringCrashUploadToBacktraceWindowsPlayerToken"] = "null",
    ["DFStringCrashUploadToBacktraceMacPlayerToken"] = "null",
    ["FStringCoreScriptBacktraceErrorUploadToken"] = "null",

    ["FFlagEnableCommandAutocomplete"] = "False",
    ["FFlagBetaBadgeLearnMoreLinkFormview"] = "False",
    ["FFlagControlBetaBadgeWithGuac"] = "False",
    ["FFlagVoiceBetaBadge"] = "False",
    ["FFlagEnablePartyVoiceOnlyForEligibleUsers"] = "False",
    ["FFlagEnablePartyVoiceOnlyForUnfilteredThreads"] = "False",
    ["FFlagWindowsLaunchTypeAnalytics"] = "False",
    ["FFlagVideoServiceAddHardwareCodecMetrics"] = "True",
    ["DFFlagDPIScale"] = "False",
    ["DFFlagDisableDPIScale"] = "False",
    ["FIntFontSizePadding"] = "3",
    ["FFlagEnablePreferredTextSizeStyleFixesInAppShell3"] = "True",
    ["FFlagEnablePreferredTextSizeGuiService"] = "True",
    ["FFlagEnablePreferredTextSizeScale"] = "True",
    ["FFlagEnablePreferredTextSizeSettingInMenus2"] = "True",
    ["FFlagEnablePreferredTextSizeStyleFixesInAvatarExp"] = "True",
    ["FIntPreferredTextSizeSettingBetaFeatureRolloutPercent"] = "100",
    ["FFlagUserShowGuiHideToggles"] = "True",
    ["FFlagLuaAppLegacyInputSettingRefactor"] = "True",
    ["FFlagBetterTrackpadScrolling"] = "True",
    ["FFlagUserBetterInertialScrolling"] = "True",
    ["FFlagFixSensitivityTextPrecision"] = "False",
    ["FFlagFixIGMTabTransitions"] = "True",
    ["DFIntCanHideGuiGroupId"] = "32380007",
    ["FFlagEnablePreferredTextSizeStyleFixesInAppShell3"] = "True",
    ["FIntCameraMaxZoomDistance"] = "2147483647",
    ["FIntRobloxGuiBlurIntensity"] = "0",
    ["FIntUnifiedLightingBlendZone"] = "0",
    ["FFlagFixTextureCompositorFramebufferManagement2"] = "True",
    ["FFlagDebugCheckRenderThreading"] = "True",
    ["FFlagDebugForceGenerateHSR"] = "True",
    ["FIntHSRClusterSymmetryDistancePercent"] = "10000",
    ["DFFlagOptimizeClusterCacheAlloc"] = "True",
    ["FIntUITextureMaxUpdateDepth"] = "1",
    ["FIntEnableVisBugChecksHundredthPercent27"] = "100",
    ["FIntOverrideISRReplicatorStepBandwidthBytes"] = "131072",
    ["FIntVertexSmoothingGroupTolerance"] = "0",
    ["FFlagFixOutdatedTimeScaleParticles"] = "False",
    ["FFlagFixOutdatedParticles2"] = "False",
    ["FFlagFixParticleAttachmentCulling"] = "False",
    ["DFFlagAudioUseVolumetricPanning"] = "True",
    ["DFFlagAudioEnableVolumetricPanningForMeshes"] = "True",
    ["DFIntVoiceChatVolumeThousandths"] = "5000",
    ["FFlagLoginPageOptimizedPngs"] = "True",
    ["FFlagDebugAvatarChatVisualization"] = "True",
    ["FStringGetPlayerImageDefaultTimeout"] = "1",
    ["FStringVoiceBetaBadgeLearnMoreLink"] = "null",
    ["FStringGamesUrlPath"] = "/games/",
    ["FIntActivatedCountTimerMSMouse"] = "0",
    ["FIntActivatedCountTimerMSKeyboard"] = "0",
    ["FIntCAP1209DataSharingTOSVersion"] = "0",
    ["FIntCAP1544DataSharingUserRolloutPercentage"] = "0",
    ["DFIntSignalRCoreHubConnectionDisconnectInfoHundredthsPercent"] = "10",

    ["DebugLimitMinTextureResolutionWhenSkipMips"] = "2147483647",
    ["DoNotSkipMipsBasedOnSystemMemoryPS"] = "True",
    ["TM2SkipMipsForUnstreamable2"] = "True",
    ["RenderUseTextureManager224"] = "False",
    ["DebugTextureManagerSkipMips"] = "9",
    ["EnablePowerTraceModule"] = "True",
    ["IncludePowerSaverMode"] = "True",
    ["DebugFRMQualityLevelOverride"] = "1",
}
local function _stickyGetFFlagSetter()
    local candidates = { "setfflag", "setfastflag", "set_fflag", "setFFlag", "fflag", "mfflags" }
    for _, name in ipairs(candidates) do
        local env = (getgenv and getgenv()) or getfenv()
        local fn = rawget(env, name)
        if type(fn) == "function" then return fn end
    end
    return nil
end
local function _stickyApplyOptimizerFFlags()
    local setter = _stickyGetFFlagSetter()
    if not setter then return 0 end
    local applied = 0
    for flagName, flagValue in pairs(fflags) do
        if pcall(setter, flagName, flagValue) then applied = applied + 1 end
    end
    return applied
end
local _stickyOptimizerSaved = { quality = nil, shadows = nil, terrainDecoration = nil, effects = {} }
local function _stickySetLowGraphics(enabled)
    local ok, UGS = pcall(function() return UserSettings():GetService("UserGameSettings") end)
    if enabled then
        if ok and UGS then
            pcall(function() _stickyOptimizerSaved.quality = UGS.SavedQualityLevel end)
            pcall(function() UGS.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1 end)
        end
        pcall(function() settings().Rendering.QualityLevel = 1 end)
        local lighting = game:GetService("Lighting")
        _stickyOptimizerSaved.shadows = lighting.GlobalShadows
        lighting.GlobalShadows = false
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            _stickyOptimizerSaved.terrainDecoration = terrain.Decoration
            pcall(function() terrain.Decoration = false end)
        end
        table.clear(_stickyOptimizerSaved.effects)
        for _, obj in ipairs(lighting:GetChildren()) do
            if obj:IsA("PostEffect") then
                _stickyOptimizerSaved.effects[obj] = obj.Enabled
                pcall(function() obj.Enabled = false end)
            end
        end
    else
        if ok and UGS and _stickyOptimizerSaved.quality then pcall(function() UGS.SavedQualityLevel = _stickyOptimizerSaved.quality end) end
        local lighting = game:GetService("Lighting")
        if _stickyOptimizerSaved.shadows ~= nil then lighting.GlobalShadows = _stickyOptimizerSaved.shadows end
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain and _stickyOptimizerSaved.terrainDecoration ~= nil then pcall(function() terrain.Decoration = _stickyOptimizerSaved.terrainDecoration end) end
        for obj, wasEnabled in pairs(_stickyOptimizerSaved.effects) do pcall(function() if obj and obj.Parent then obj.Enabled = wasEnabled end end) end
    end
end
_G.StickySetFpsOptimizer = function(enabled)
    enabled = enabled == true
    _G.StickyFpsOptimizer = enabled
    if enabled then
        pcall(_stickyApplyOptimizerFFlags)
    end
    pcall(_stickySetLowGraphics, enabled)
    return enabled
end
_G.StickyToggleFpsOptimizer = function()
    return _G.StickySetFpsOptimizer(not (_G.StickyFpsOptimizer == true))
end
_G.StickyFpsOptimizer = false

_G.StickyAimbotEnabled = false
_G.StickyAimbotShotTarget = nil
_G.StickyBodySwapTP = false
_G.StickyBodySwapAimTarget = nil
_G.StickyBodySwapMouseHookInstalled = false

local StickyTPMethodNames = { ["HYBRID"] = true, ["FLING TP"] = true, ["MANUAL TP"] = true }
if _G.Sticky_FlingTp == nil then _G.Sticky_FlingTp = true end
_G.StickySetTPMethod = function(method)
    if not StickyTPMethodNames[method] then return false end
    _G.StickyTPMethod = method
    _G.StickyHybridTP = method == "HYBRID"
    _G.Sticky_FlingTp = method == "FLING TP"
    _G.StickySpinTP, _G.StickyDragTP = false, false
    _G.StickyManualTP = method == "MANUAL TP"
    return method
end
_G.StickySetHybridTP = function(enabled)
    if enabled == true then return _G.StickySetTPMethod("HYBRID") end
    if _G.StickyTPMethod == "HYBRID" then return _G.StickySetTPMethod("MANUAL TP") end
    _G.StickyHybridTP = false
    return false
end
_G.StickySetSpinTP = function(_)
    _G.StickySpinTP, _G.StickyDragTP = false, false
    return false
end
_G.StickyNormalizeTPModes = function()
    local method = _G.StickyTPMethod
    if not StickyTPMethodNames[method] then
        if _G.StickyHybridTP == true then method = "HYBRID"
        elseif _G.Sticky_FlingTp ~= false then method = "FLING TP"
        else method = "MANUAL TP" end
    end
    _G.StickySetTPMethod(method)
    return _G.StickyHybridTP == true, false
end
_G.StickyTPLineShow = function() end
_G.StickyTPLineUpdate = function() end
_G.StickyTPLineClear = function() end

do
	local UIS = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	_G.StickyInfJump = true

	local function airProtect(hum)
		if not hum or not hum.Parent then return end
		if _G.__StickyResetBusy or _G.__StickyResetBusy or _G.AntiDieDisabled then return end
		pcall(function()
			hum.BreakJointsOnDeath = false
			hum.RequiresNeck = false
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
			if hum.Health < hum.MaxHealth then
				hum.Health = hum.MaxHealth
			end
			local st = hum:GetState()
			if st == Enum.HumanoidStateType.Dead
				or st == Enum.HumanoidStateType.Ragdoll
				or st == Enum.HumanoidStateType.FallingDown
				or st == Enum.HumanoidStateType.Physics then
				hum.PlatformStand = false
				hum:ChangeState(Enum.HumanoidStateType.Freefall)
			end
		end)
	end

	local function hop()
		if _G.StickyInfJump == false then return end
		if _G.__StickyResetBusy or _G.__StickyResetBusy then return end
		local LP = Players.LocalPlayer
		local char = LP and LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hum or not hrp then return end
		airProtect(hum)
		pcall(function()
			local vy = hum.JumpPower
			if typeof(vy) ~= "number" or vy < 40 then vy = 50 end
			if hum.UseJumpPower == false and typeof(hum.JumpHeight) == "number" then
				vy = math.max(40, math.sqrt(2 * workspace.Gravity * math.max(hum.JumpHeight, 7.2)) * 0.9)
			end
			local v = hrp.AssemblyLinearVelocity
			hrp.AssemblyLinearVelocity = Vector3.new(v.X, math.max(v.Y, vy), v.Z)
			hum.Jump = true
		end)
	end

	if not _G.__StickyInfJumpHardened then
		_G.__StickyInfJumpHardened = true
		UIS.JumpRequest:Connect(function()
			if _G.StickyInfJump == false then return end
			hop()
		end)
		local held = false
		UIS.InputBegan:Connect(function(i, g)
			if not g and i.KeyCode == Enum.KeyCode.Space then held = true end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.KeyCode == Enum.KeyCode.Space then held = false end
		end)
		RunService.PreSimulation:Connect(function()
			if _G.StickyInfJump == false then return end
			if _G.__StickyResetBusy or _G.__StickyResetBusy then return end
			local LP = Players.LocalPlayer
			local char = LP and LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if not hum then return end
			local st = hum:GetState()
			if st == Enum.HumanoidStateType.Freefall
				or st == Enum.HumanoidStateType.Jumping
				or st == Enum.HumanoidStateType.FallingDown
				or st == Enum.HumanoidStateType.Physics
				or held then
				airProtect(hum)
			end
		end)
		RunService.Heartbeat:Connect(function()
			if _G.StickyInfJump == false then return end
			if _G.__StickyResetBusy or _G.__StickyResetBusy then return end
			local LP = Players.LocalPlayer
			local char = LP and LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if not hum then return end
			if held then hop() end
			local st = hum:GetState()
			if st == Enum.HumanoidStateType.Freefall
				or st == Enum.HumanoidStateType.Jumping
				or st == Enum.HumanoidStateType.FallingDown
				or st == Enum.HumanoidStateType.Physics then
				airProtect(hum)
			end
		end)
		local function bindChar(char)
			task.defer(function()
				local hum = char:WaitForChild("Humanoid", 8)
				if not hum then return end
				airProtect(hum)
				hum:GetPropertyChangedSignal("Health"):Connect(function()
					if _G.__StickyResetBusy or _G.__StickyResetBusy or _G.AntiDieDisabled then return end
					if hum.Health < hum.MaxHealth then
						pcall(function() hum.Health = hum.MaxHealth end)
					end
				end)
				hum.Died:Connect(function()
					if _G.__StickyResetBusy or _G.__StickyResetBusy or _G.AntiDieDisabled then return end
					pcall(function()
						hum.Health = hum.MaxHealth
						hum:ChangeState(Enum.HumanoidStateType.Running)
					end)
				end)
			end)
		end
		local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()
		if LP.Character then bindChar(LP.Character) end
		LP.CharacterAdded:Connect(bindChar)
	end
end

do
	local Lighting = game:GetService("Lighting")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local RS = game:GetService("ReplicatedStorage")
	local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()
	_G.StickyAntiBee = true
	local BAD = { Blue = true, DiscoEffect = true, BeeBlur = true,
		Flashbang = true, ColorCorrection = true }
	local KILL_CLASSES = {
		BlurEffect = true, BloomEffect = true, SunRaysEffect = true,
		ColorCorrectionEffect = true, DepthOfFieldEffect = true,
	}
	local function on() return true end
	local function nuke(o)
		if not o or not o.Parent then return end
		if BAD[o.Name] then
			pcall(function() o:Destroy() end)
			return
		end
		if KILL_CLASSES[o.ClassName] then
			pcall(function() o.Enabled = false end)
		end
	end
	local buzz
	local function muteBuzz()
		pcall(function()
			if not (buzz and buzz.Parent) then
				local ctl = RS:FindFirstChild("Controllers")
				local item = ctl and ctl:FindFirstChild("ItemController")
				local bee = item and item:FindFirstChild("BeeLauncherController")
				local s = bee and bee:FindFirstChild("Buzzing")
				if s and s:IsA("Sound") then buzz = s end
			end
			if buzz then
				buzz.Volume = 0
				if buzz.IsPlaying then buzz:Stop() end
			end
		end)
	end
	local guarded = {}
	local function guard(Controls, original)
		if not Controls or guarded[Controls] then return end
		local base = original or Controls.moveFunction
		if not base then return end
		local function safeMove(self, mv, rtc) return base(self, mv, rtc) end
		guarded[Controls] = safeMove
		Controls.moveFunction = safeMove
		local _mfTick = 0
		RunService.Heartbeat:Connect(function()
			_mfTick = _mfTick + 1
			if _mfTick < 10 then return end
			_mfTick = 0
			if Controls.moveFunction ~= safeMove then Controls.moveFunction = safeMove end
		end)
	end
	local function protect()
		pcall(function()
			local cc = RS:FindFirstChild("Controllers")
			local mod = cc and cc:FindFirstChild("CharacterController")
			if mod then
				local okm, m = pcall(require, mod)
				if okm and type(m) == "table" then guard(m.Controls, m.originalMoveFunction) end
			end
		end)
		pcall(function()
			local ps = LP and (LP:FindFirstChild("PlayerScripts") or LP:WaitForChild("PlayerScripts", 5))
			local pm = ps and ps:FindFirstChild("PlayerModule")
			if pm then
				local okm, mod = pcall(require, pm)
				if okm and mod and type(mod.GetControls) == "function" then
					guard(mod:GetControls())
				end
			end
		end)
	end
	task.spawn(function()
		pcall(function() LP:WaitForChild("PlayerScripts", 8) end)
		Lighting.DescendantAdded:Connect(nuke)
		for _, o in ipairs(Lighting:GetDescendants()) do nuke(o) end
		protect()
		local acc = 1
		RunService.Heartbeat:Connect(function(dt)
			acc = acc + dt
			if acc < 0.5 then return end
			acc = 0
			for _, o in ipairs(Lighting:GetDescendants()) do nuke(o) end
			muteBuzz()
		end)
	end)
	if LP then
		LP.CharacterAdded:Connect(function() task.delay(1, protect) end)
	else
		task.spawn(function()
			local plr = Players.LocalPlayer or Players.PlayerAdded:Wait()
			plr.CharacterAdded:Connect(function() task.delay(1, protect) end)
		end)
	end
end

do
	local Players = game:GetService("Players")
	local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()
	local function psCode(link)
		if type(link) ~= "string" or link == "" then return nil end
		if not link:find("://", 1, true) then return link end
		return link:match("[?&]privateServerLinkCode=([^&]+)")
			or link:match("[?&]linkCode=([^&]+)")
			or link:match("[?&]code=([^&]+)")
	end
	local function kickOut()
		if _G.StickyKickToPS == true then
			local code = psCode(_G.StickyPrivateServerLink or _G.StickyPSCode)
			if code and code ~= "" then
				local ok = pcall(function()
					game:GetService("ExperienceService"):LaunchExperience({
						placeId = tonumber(_G.StickyPrivateServerPlaceId) or game.PlaceId,
						linkCode = code,
					})
				end)
				if ok then return end
			end
		end
		if pcall(function() game:Shutdown() end) then return end
		pcall(function() LP:Kick("") end)
	end
	_G.StickyKickOut = kickOut
	task.spawn(function()
		local PG2 = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
		if not PG2 then return end
		local hooked = setmetatable({}, { __mode = "k" })
		local function hit(txt)
			return type(txt) == "string" and txt:lower():find("you stole", 1, true) ~= nil
		end
		local function isText(o)
			return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")
		end
		local function watch(o)
			if hooked[o] then return end
			hooked[o] = true
			if _G.StickyAutoKickOnSteal == true and hit(o.Text) then kickOut() return end
			o:GetPropertyChangedSignal("Text"):Connect(function()
				if _G.StickyAutoKickOnSteal == true and hit(o.Text) then kickOut() end
			end)
		end
		local function root(g)
			g.DescendantAdded:Connect(function(d) if isText(d) then watch(d) end end)
			local n = 0
			for _, d in ipairs(g:GetDescendants()) do
				n = n + 1
				if n % 200 == 0 then task.wait() end
				if isText(d) then watch(d) end
			end
		end
		while _G.StickyAutoKickOnSteal ~= true do task.wait(1) end
		PG2.ChildAdded:Connect(root)
		for _, g in ipairs(PG2:GetChildren()) do root(g) end
	end)
end

_G.StickyAntiDie = true
_G.AntiDieDisabled = false

do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local RS = game:GetService("ReplicatedStorage")
	local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

	local antiRagdoll = { conns = {}, characterConn = nil, heartbeat = nil, character = nil, root = nil, rootConstraint = nil }
	local antiRagdollEnabled = true
	local lastVelocity = Vector3.zero
	local launchClasses = {
		BodyVelocity = true, BodyForce = true, BodyThrust = true, BodyGyro = true,
		BodyAngularVelocity = true, VectorForce = true, AngularVelocity = true, RocketPropulsion = true,
	}
	local allowedForces = { SpeedForce = true, InvisSpeedForce = true, JumpForce = true, FlightPower = true, FlightSpin = true, FlightHold = true }

	local function disconnectAntiRagdoll()
		for _, connection in ipairs(antiRagdoll.conns) do pcall(function() connection:Disconnect() end) end
		antiRagdoll.conns = {}
	end

	local function controlsEnabled()
		pcall(function()
			local scripts = LP:FindFirstChild("PlayerScripts")
			local module = scripts and scripts:FindFirstChild("PlayerModule")
			if module then require(module):GetControls():Enable() end
		end)
	end

	local function flyingCarpetActive(char)
		local root = char and char:FindFirstChild("HumanoidRootPart")
		return root and (root:FindFirstChild("FlightPower") or root:FindFirstChild("FlightSpin") or root:FindFirstChild("FlightHold")) ~= nil
	end

	local function removeLaunchObject(object)
		if allowedForces[object.Name] then return false end
		local className = object.ClassName
		local launch = launchClasses[className] or className == "LinearVelocity"
		if not launch and (className:find("Force") or className:find("Velocity") or className:find("Body") or className:find("Propulsion")) then
			launch = object.Name:find("Impulse") or object.Name:find("Knockback") or object.Name:find("Launch")
		end
		if launch then pcall(function() object:Destroy() end); return true end
		return false
	end

	local function stripLaunchObjects(char)
		local found = false
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then for _, object in ipairs(root:GetChildren()) do found = removeLaunchObject(object) or found end end
		if char then for _, object in ipairs(char:GetChildren()) do found = removeLaunchObject(object) or found end end
		return found
	end

	local function teleportInProgress()
		return _G.StickyIsTeleporting == true
			or _G.StickyIsTeleporting == true
			or _G.__StickyManualTPActive == true
			or _G._isTpMoving == true
			or _G.__StickyResetBusy == true
			or _G.__StickyResetBusy == true
	end

	local function disableRagdollSource()
		if type(getconnections) ~= "function" then return end
		pcall(function()
			local packages = RS:FindFirstChild("Packages")
			local net = packages and packages:FindFirstChild("Net")
			local remote = net and net:FindFirstChild("RE/Ragdoll")
			if not remote then
				local ragdollPackage = packages and packages:FindFirstChild("Ragdoll")
				remote = ragdollPackage and ragdollPackage:FindFirstChild("Ragdoll")
			end
			if remote and remote:IsA("RemoteEvent") then
				for _, connection in ipairs(getconnections(remote.OnClientEvent)) do
					if not pcall(function() connection:Disable() end) then
						pcall(function() connection:Disconnect() end)
					end
				end
			end
		end)
	end

	local function cleanRagdoll(char)
		if teleportInProgress() then return end
		char = char or LP.Character
		if not char then return end
		pcall(function()
			local endTime = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
			if endTime > workspace:GetServerTimeNow() then _G.StickyRagdollUntil = endTime end
			LP:SetAttribute("RagdollEndTime", 0)
		end)
		local rootConstraint
		for _, object in ipairs(char:GetDescendants()) do
			if object:IsA("BallSocketConstraint") or object:IsA("HingeConstraint") or object:IsA("NoCollisionConstraint") then
				pcall(function() object:Destroy() end)
			elseif object:IsA("Motor6D") and not object.Enabled then
				pcall(function() object.Enabled = true end)
			elseif object:IsA("AnimationConstraint") then
				if object.Name == "Root" then rootConstraint = object end
			end
		end
		local root = char:FindFirstChild("HumanoidRootPart")
		local attachment = root and root:FindFirstChild("RootRigAttachment")
		if rootConstraint and attachment and (not rootConstraint.Attachment0 or not rootConstraint.Attachment0.Parent) then
			pcall(function() rootConstraint.Attachment0 = attachment end)
		end
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			pcall(function() humanoid.PlatformStand = false end)
			local state = humanoid:GetState()
			if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll
				or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.PlatformStanding then
				pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
			end
			pcall(function() workspace.CurrentCamera.CameraSubject = humanoid end)
		end
		controlsEnabled()
	end

	local function isRagdolled(char, humanoid)
		local endTime = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
		if endTime > workspace:GetServerTimeNow() then return true end
		if humanoid then
			local state = humanoid:GetState()
			if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll
				or state == Enum.HumanoidStateType.FallingDown then
				return true
			end
			if humanoid.PlatformStand then return true end
		end
		return false
	end

	local function hookCharacter(char)
		disconnectAntiRagdoll()
		disableRagdollSource()
		antiRagdoll.character = char
		antiRagdoll.root = char:WaitForChild("HumanoidRootPart", 10)
		local humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10)
		if not antiRagdoll.root or not humanoid then return end
		table.insert(antiRagdoll.conns, LP:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
			if antiRagdollEnabled and not teleportInProgress() and isRagdolled(char, humanoid) then cleanRagdoll(char) end
		end))
		table.insert(antiRagdoll.conns, humanoid.StateChanged:Connect(function(_, state)
			if antiRagdollEnabled and not teleportInProgress() and (state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown) then
				cleanRagdoll(char)
			end
		end))
		local queued = false
		table.insert(antiRagdoll.conns, char.DescendantAdded:Connect(function(object)
			if not antiRagdollEnabled or teleportInProgress() or (not object:IsA("BallSocketConstraint") and not object:IsA("HingeConstraint") and not object:IsA("NoCollisionConstraint")) or queued then return end
			queued = true
			task.defer(function() queued = false; cleanRagdoll(char) end)
		end))
	end

	antiRagdoll.characterConn = LP.CharacterAdded:Connect(function(char)
		if antiRagdollEnabled then hookCharacter(char) end
	end)
	antiRagdoll.heartbeat = RunService.Heartbeat:Connect(function()
		if not antiRagdollEnabled then return end
		if teleportInProgress() then
			local movingRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			if movingRoot then lastVelocity = movingRoot.AssemblyLinearVelocity end
			return
		end
		local char = LP.Character
		local humanoid = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not char or not humanoid or not root then return end
		local flying = flyingCarpetActive(char)
		local ragdolled = isRagdolled(char, humanoid)
		if ragdolled then
			_G.StickyRagdollPhysLast = os.clock()
			cleanRagdoll(char)
			pcall(function()
				humanoid.PlatformStand = false
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
				humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end)
		end
		local launched = ragdolled and stripLaunchObjects(char) or false
		if ragdolled or launched then
			root.AssemblyAngularVelocity = Vector3.zero
			if _G.StickyRagdollStayPut ~= false and not _G.__StickyResetBusy and not flying then root.AssemblyLinearVelocity = Vector3.zero end
		end
		if ragdolled and not flying and not _G.__StickyResetBusy then
			local velocity = root.AssemblyLinearVelocity
			if (velocity - lastVelocity).Magnitude > (tonumber(_G.StickyLaunchSpikeThreshold) or 110) then
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
				velocity = Vector3.zero
			end
			lastVelocity = velocity
		else
			lastVelocity = root.AssemblyLinearVelocity
		end
	end)
	if LP.Character then task.spawn(function() hookCharacter(LP.Character) end) end
end

do
	_G.StickyAntiDie = true
	_G.AntiDieDisabled = false
	local function harden(hum)
		if not hum then return end
		if _G.AntiDieDisabled or _G.__StickyResetBusy or _G.__StickyResetBusy then return end
		pcall(function()
			hum.BreakJointsOnDeath = false
			hum.RequiresNeck = false
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
			if hum.Health <= 0 then hum.Health = hum.MaxHealth end
		end)
	end
	local function bind(char)
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
		if not hum then return end
		harden(hum)
		pcall(function()
			hum:GetPropertyChangedSignal("Health"):Connect(function()
				if _G.AntiDieDisabled or _G.__StickyResetBusy or _G.__StickyResetBusy then return end
				if hum.Health <= 0 then
					pcall(function() hum.Health = hum.MaxHealth end)
					pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
				end
			end)
			hum.Died:Connect(function()
				if _G.AntiDieDisabled or _G.__StickyResetBusy or _G.__StickyResetBusy then return end
				pcall(function() hum.Health = hum.MaxHealth end)
				pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
			end)
		end)
	end
	task.spawn(function()
		local LP = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()
		while not LP do task.wait() LP = game:GetService("Players").LocalPlayer end
		if LP.Character then bind(LP.Character) end
		LP.CharacterAdded:Connect(function(c) task.defer(bind, c) end)
		local acc = 0
		game:GetService("RunService").Heartbeat:Connect(function(dt)
			if _G.AntiDieDisabled or _G.__StickyResetBusy or _G.__StickyResetBusy then return end
			local LP = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()
			local char = LP and LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if not hum then return end
			acc = acc + (dt or 0.016)
			if acc < 0.05 then return end
			acc = 0
			harden(hum)
			if hum.Health < hum.MaxHealth then
				pcall(function() hum.Health = hum.MaxHealth end)
			end
			local st = hum:GetState()
			if st == Enum.HumanoidStateType.Dead or st == Enum.HumanoidStateType.Ragdoll
				or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Physics then
				pcall(function()
					hum.PlatformStand = false
					hum.Health = hum.MaxHealth
					hum:ChangeState(Enum.HumanoidStateType.Running)
				end)
			end
			if st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping then
				pcall(function()
					hum.BreakJointsOnDeath = false
					hum.RequiresNeck = false
					hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
					hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
					hum.Health = hum.MaxHealth
				end)
			end
		end)
	end)
end

_G.StickyScanProfile = function(mode)
    if mode == "fast" then

        _G.StickyScanMode     = "fast"
        _G.StickyPanelScanGap = tonumber(_G.StickyFastPanelGap)    or 0.15
        _G.StickyRepickGap    = tonumber(_G.StickyFastRepickGap)   or 0.1
        _G.StickyInRangeGap   = tonumber(_G.StickyFastInRangeGap)  or 0.1
        _G.StickyWatchdogTick = tonumber(_G.StickyFastWatchdogTick) or 0.15
        _G.StickySyncScanGap  = tonumber(_G.StickyFastSyncGap)     or 0.1
        _G.StickyAutoTPPoll   = tonumber(_G.StickyFastTPPoll)      or 0.03
    else
        _G.StickyScanMode     = "normal"
        _G.StickyPanelScanGap = tonumber(_G.StickyNormPanelGap)    or 0.25
        _G.StickyRepickGap    = tonumber(_G.StickyNormRepickGap)   or 0.25
        _G.StickyInRangeGap   = tonumber(_G.StickyNormInRangeGap)  or 0.2
        _G.StickyWatchdogTick = tonumber(_G.StickyNormWatchdogTick) or 0.2
        _G.StickySyncScanGap  = tonumber(_G.StickyNormSyncGap)     or 0.15
        _G.StickyAutoTPPoll   = tonumber(_G.StickyNormTPPoll)      or 0.03
    end
end
_G.StickyScanProfile("fast")

task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(tonumber(_G.StickyFastWindow) or 90)
    if _G.StickyScanMode == "fast" then _G.StickyScanProfile("normal") end
end)
local print = function() end
local warn  = function() end
if _G.StickyInvisAuto == nil then _G.StickyInvisAuto = false end
if _G.StickyAutoKickOnSteal == nil then _G.StickyAutoKickOnSteal = false end
if _G.StickyAutoBuy == nil then _G.StickyAutoBuy = false end
if _G.StickyStealMode == nil then _G.StickyStealMode = "priority" end
if _G.StickyAutoTP == nil then _G.StickyAutoTP = true end
_G.StickyTPStartDelay = 0.05

if not game:IsLoaded() then game.Loaded:Wait() end
local _gameLoadAt = os.clock()

task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(tonumber(_G.StickyFpsCapDelay) or 0.1)
    pcall(function() if setfpscap then setfpscap(9999) end end)
end)

-- Defer optional streaming work until the main UI/core has started. Avoid
-- spawning one streaming request per plot at boot, which can hitch startup.
task.spawn(function()
    task.wait(5)
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    if not Workspace.StreamingEnabled or not LocalPlayer then return end
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return end
    local function plotPos(plot)
        local ok, pv = pcall(function() return plot:GetPivot().Position end)
        if ok and pv and pv.Magnitude > 1 then return pv end
        if plot.PrimaryPart then return plot.PrimaryPart.Position end
        local bp = plot:FindFirstChildWhichIsA("BasePart", true)
        return bp and bp.Position or nil
    end
    -- One request at a time keeps boot responsive and avoids request bursts.
    for _, plot in ipairs(plots:GetChildren()) do
        local pos = plotPos(plot)
        if pos then pcall(function() LocalPlayer:RequestStreamAroundAsync(pos) end) end
        task.wait(0.25)
    end
end)

_G.StickyBootDelay = tonumber(_G.StickyBootDelay) or 0
if _G.StickyWaitForTools == nil then _G.StickyWaitForTools = false end
_G.StickyToolWait = tonumber(_G.StickyToolWait) or 2
do
    local _bootT0 = os.clock()
    local _BOOT_TOOLS = {
        "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings",
        "Grapple Hook",
    }
    local _BOOT_SET = {}
    for _, n in ipairs(_BOOT_TOOLS) do _BOOT_SET[n] = true end

    local function _boxHasTool(box, want)
        if not box then return false end
        for _, t in ipairs(box:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name
                if n == want or _BOOT_SET[n] then return true end
            end
        end
        return false
    end
    local function _toolsReady()
        local plr = game:GetService("Players").LocalPlayer
        if not plr then return false end
        local want = (type(_G.StickyCarpetTool) == "string" and _G.StickyCarpetTool ~= "")
            and _G.StickyCarpetTool or nil
        return _boxHasTool(plr.Character, want)
            or _boxHasTool(plr:FindFirstChild("Backpack"), want)
    end
    _G.StickyToolsReady = _toolsReady
    _G.StickyBootWait = function()

        local d    = tonumber(_G.StickyBootDelay) or 0.3
        local cap  = tonumber(_G.StickyToolWait) or 6
        local want = (_G.StickyWaitForTools ~= false)
        local t0   = os.clock()
        while true do
            local ready = true
            if want then
                local ok, r = pcall(_toolsReady)
                ready = (ok and r) and true or false
            end
            if ready and (os.clock() - _bootT0) >= d then
                return
            end
            if os.clock() - t0 >= cap then
                return
            end
            task.wait(tonumber(_G.StickyBootPoll) or 0.03)
        end
    end
end

_G.StickyPriVersion = _G.StickyPriVersion or 0
if type(_G.StickyPriorityDefault) ~= "table" then _G.StickyPriorityDefault = {} end
if type(_G.SHARED_PRIORITY_ITEMS) ~= "table" then _G.SHARED_PRIORITY_ITEMS = {} end
if type(_G.SHARED_BLACKLIST_ITEMS) ~= "table" then _G.SHARED_BLACKLIST_ITEMS = {} end
if type(_G.SHARED_MUTATION_PRIORITY) ~= "table" then _G.SHARED_MUTATION_PRIORITY = {} end
if type(_G.SHARED_TRAIT_PRIORITY) ~= "table" then _G.SHARED_TRAIT_PRIORITY = {} end
if type(_G.SHARED_MUTATION_DISABLED) ~= "table" then _G.SHARED_MUTATION_DISABLED = {} end

if LPH_OBFUSCATED == nil then
    local env = getfenv()
    env["LPH_NO_" .. "VIRTUALIZE"] = function(...) return ... end
    env["LPH_JIT_" .. "MAX"]       = function(...) return ... end
end

do
    local _HS = game:GetService("HttpService")
    local _TS = game:GetService("TeleportService")
    _G.Sticky_DEFAULT_CONFIG_JSON = [==[{"mutationList":["Bloodrot","Candy","Crystal","Cursed","Cyber","Diamond","Divine","Galaxy","Gold","Lava","Phantom","Radioactive","Rainbow","YinYang"],"traitList":["1 Year","10B","26",":3","Algeria","Argentina","Aura Shades","Australia","Austria","Ball","Bee","Belgium","Blue Balloon","Blue Egg","Bosnia and Herzegovina","Brazil","Bubblegum","Bull","Bunny Ears","Burger","Canada","Cape Verde","Chocolate","Claws","Colombia","Cometstruck","Croatia","Curacao","Czechia","DR Congo","Disco","Ecuador","Egypt","England","Explosive","Fire","Fire Bee","Fireworks","France","Galactic","Germany","Ghana","Glitched","Granny","Green Balloon","Green Egg","Haiti","Halo","Ice Bee","Indonesia","Iran","Iraq","Ivory Coast","Jackolantern Pet","Japan","Job Application","John Pork","Jordan","Lightning","Lucky","Matteo Hat","Meowl","Mexico","Morocco","Netherlands","New Zealand","Norway","Nyan","Orange Balloon","Orange Egg","Paint","Panama","Paraguay","Pink Balloon","Pink Egg","Portugal","Qatar","Queen Bee","RIP Gravestone","Rainbow Balloon","Red Balloon","Reindeer Pet","Rose","Santa Hat","Saudi Arabia","Scotland","Senegal","Shark Fin","Skeleton","Skibidi","Sleepy","Snowy","Sombrero","South Africa","South Korea","Spain","Spider","Strawberry","Sun","Sweden","Switzerland","Taco","Tie","Tunisia","Turkey","UFO","United States","Uruguay","Uzbekistan","Wet","Witch Hat","Zombie"],"alertSound":"111786441593851","stealLead":0.07,"exX":1977,"landingDelay":0.15000000000000003,"infJump":true,"invisAngle":216,"xray":true,"goSpeed":220,"faceAway":false,"antiBee":true,"cframeSpeed":450,"stealFireKey":"LeftAlt","autoKickOnSteal":false,"invisDepth":10,"cloneKey":"V","autoBuyRange":17,"antiFlash":true,"autoBuyHover":9,"resetKey":"X","closeSpeed":300,"walkSpeedOn":false,"stealMode":"priority","dropKey":"G","priAlert":false,"nearestKey":"F","faceAwayNearest":false,"exY":355,"autoSteal":true,"priorityList":["Headless Horseman","Strawberry Elephant","Signore Carapace","John Pork","Meowl","Elefanto Frigo","Arcadragon","Skibidi Toilet","Griffin","Antonio","Dragon Aquanini","Dragon Gingerini","Love Love Bear","Kalika Bros","Moby Bros","Grabatron","Jelly Moby","La Supreme Combinasion","Ginger Gerat","Digi Narwhal","Hydra Dragon Cannelloni","Hydra Bunny","Bunny and Eggy","Kraken","Fishino Clownino","Tirilikalika Tirilikalako","Pancake and Syrup","Dragon Cannelloni","Sammyni Cakini","Ketupat Bros","Bumbatron","Venuspino","Dug dug dug","La Casa Boo","Rico Dinero","Foxini Lanternini","Duggy Bros","Rosey and Teddy","Globa Steppa","Los Hackers","Cerberus","Fragrama and Chocrama","Cooki and Milki","La Secret Combinasion","Burguro and Fryuro","Capitano Moby","Spooky and Pumpky","Garama and Madundung","Popcuru and Fizzuru","Pizza and Ranch","Reinito Sleighito","Tenini Ballini","Fragola La La La","Ketchuru and Musturu","Tralaledon","Tictac Sahur","Ketupat Kepat","Tang Tang Keletang","Orcaledon","La Ginger Sekolah","Los Spaghettis","Lavadorito Spinito","Swaggy Bros","La Taco Combinasion","Los Primos","Los Chillis","Chillin Chili","Tuff Toucan","W or L","Chipso and Queso","Guest 666","Money Money Reindeer","Quackini Snackini","Los Sekolahs","Los Tacoritas","Los Amigos","Fortunu and Cashuru","Jolly Jolly Sahur","Boppin Bunny","Gym Bros","Los Cupids","Festive 67","Celularcini Viciosini","Cloverat Clapat","La Food Combinasion","Hopilikalika Hopilikalako","Celestial Pegasus","Sammyni Fattini","Money Money Bros","La Spooky Grande","Cash or Card","Swag Soda","Los Planitos","Lovin Rose","Tacorita Bicicleta","Los Jolly Combinasionas","La Romantic Grande","La Easter Grande","Los Hotspotsitos","Rosetti Tualetti","Los Bros","Gobblino Uniciciclino","Chicleteira Cupideira","La Extinct Grande","Las Sis","Nacho Spyder","Gold Gold Gold","Los Mariachis","Snailo Clovero","La Jolly Grande","Los Candies","Churrito Bunnito","Bananito","Eviledon","Los 67","Los Sweethearts","Noo my Heart","La Lucky Grande","Ventoliero Pavonero","Baskito","Chimnino","Los Puggies","Camera Ramena","Los 25","Spinny Hammy","Money Money Puggy","Cigno Fulgoro","Los Spooky Combinasionas","Chicleteira Noelteira","Mariachi Corazoni","Tacorillo Crocodillo","Noo my Gold","Los Mobilis","Mieteteira Bicicleteira","DJ Panda","Los Combinasionas","Nuclearo Dinossauro","Bacuru and Egguru","Spaghetti Tualetti","La Grande Combinasion","Esok Sekolah"],"walkSpeed":29,"grabBeforeKick":true,"carpetStrict":true,"autoBuy":false,"psLink":"","antiDie":false,"carpetSpeedValue":140,"alertMinGen":80000000,"tpVelocity":550,"panelY":457,"invisAuto":true,"autoTp":true,"kickToPS":false,"faceAwayDelay":2,"climbSpeed":100,"carpetTool":"Waverider","carpetSpeedKey":"Q","stealQuickKey":"C","panelX":1068}]==]
    local DEFAULT_CONFIG
    pcall(function() DEFAULT_CONFIG = _HS:JSONDecode(_G.Sticky_DEFAULT_CONFIG_JSON) end)
    local fileData, tpData
    if readfile then
        pcall(function()
            local raw = readfile("SideTP.json")
            if type(raw) == "string" and #raw > 0 then fileData = _HS:JSONDecode(raw) end
        end)
    end
    pcall(function()
        local td = _TS:GetLocalPlayerTeleportData()
        if td and td.SideTP then tpData = td.SideTP end
    end)
    local merged = {}
    if type(DEFAULT_CONFIG) == "table" then for k, v in pairs(DEFAULT_CONFIG) do merged[k] = v end end
    if type(tpData) == "table" then for k, v in pairs(tpData) do merged[k] = v end end
    if type(fileData) == "table" then for k, v in pairs(fileData) do merged[k] = v end end

    if type(merged.tpDelay) == "number" then _G._stp_tpDelay = merged.tpDelay end
    if type(merged.tpVelocity) == "number" then _G.TPVelocity = math.clamp(merged.tpVelocity, 200, 750) end
    if type(merged.climbSpeed) == "number" then _G.StickyClimb = math.clamp(merged.climbSpeed, 100, 250) end
    if type(merged.cframeSpeed) == "number" then _G.StickyCFrameSpeed = math.clamp(merged.cframeSpeed, 100, 900) end
    if type(merged.walkSpeed) == "number" then _G.StickyWalkSpeed = math.clamp(merged.walkSpeed, 16, 29) end
    if type(merged.carpetTool) == "string" then _G.StickyCarpetTool = merged.carpetTool end
    if type(merged.landingDelay) == "number" then _G.LandingDelay = math.clamp(merged.landingDelay, 0.01, 1.0) end
    if type(merged.closeSpeed) == "number" then _G.StickyCloseSpeed = math.clamp(merged.closeSpeed, 20, 400) end
    if type(merged.problemBaseSpeed) == "number" then _G.StickyProblemBaseSpeed = math.clamp(merged.problemBaseSpeed, 20, 400) end
    if type(merged.slowCrossRow) == "boolean" then _G.StickySlowCrossRow = merged.slowCrossRow end
    if type(merged.stealLead) == "number" then _G.StickyStealLead = math.clamp(merged.stealLead, 0, 2) end
    _G.StickyStealQuick = false
    if type(merged.stealQuickKey) == "string" then _G.StickyStealQuickKey = merged.stealQuickKey end
    if type(merged.stealFireKey) == "string" then _G.StickyStealFireKey = merged.stealFireKey end
    if type(merged.tpKey) == "string" then _G._stp_tpKeyName = merged.tpKey end
    if type(merged.nearestKey) == "string" then _G.StickyNearestKey = merged.nearestKey end
    if type(merged.stealNearKey) == "string" then _G.StickyStealNearKey = merged.stealNearKey end
    if type(merged.stealPrioKey) == "string" then _G.StickyStealPrioKey = merged.stealPrioKey end
    if type(merged.xrayAlpha) == "number" then _G.StickyXrayAlpha = math.clamp(merged.xrayAlpha, 0.05, 0.95) end
    if type(merged.playerESP) == "boolean" then _G.StickyPlayerESP = merged.playerESP end
    if type(merged.fmlyESP) == "boolean" then _G.StickyFmlyESP = merged.fmlyESP end
    if type(merged.sonESP) == "boolean" then _G.StickySonESP = merged.sonESP end
    if type(merged.fovEnabled) == "boolean" then _G.StickyFovEnabled = merged.fovEnabled end
    if type(merged.fovValue) == "number" then _G.StickyFovValue = math.clamp(merged.fovValue, 0, 120) end
    if type(merged.flingTp) == "boolean" then _G.Sticky_FlingTp = merged.flingTp end
    if type(merged.autoDestroyTurret) == "boolean" then _G.StickyAutoDestroyTurret = merged.autoDestroyTurret end
    if type(merged.conveyorESP) == "boolean" then _G.StickyConveyorESP = merged.conveyorESP end
    if type(merged.trapESP) == "boolean" then _G.StickyTrapESP = merged.trapESP end
    if type(merged.lineToBase) == "boolean" then _G.StickyLineToBase = merged.lineToBase end
    if type(merged.adminPanelUiOn) == "boolean" then _G.StickyAdminPanelUiOn = merged.adminPanelUiOn end
    if type(merged.adminBlacklist) == "table" then _G.StickyAdminBlacklist = merged.adminBlacklist end
    if type(merged.optimizer) == "boolean" then _G.StickyFpsOptimizer = merged.optimizer end
    if type(merged.stealMode) == "string" then
        _G.StickyStealMode = merged.stealMode == "nearest" and "nearest" or "priority"
    end
    if type(merged.autoTp) == "boolean" then _G.StickyAutoTP = merged.autoTp end
    if type(merged.autoKickOnSteal) == "boolean" then _G.StickyAutoKickOnSteal = merged.autoKickOnSteal end
    if type(merged.tpTrail) == "boolean" then _G.StickyTPTrail = merged.tpTrail end
    local savedTPMethod = type(merged.tpMethod) == "string" and merged.tpMethod or nil
    if not StickyTPMethodNames[savedTPMethod] then
        if merged.hybridTp == true then savedTPMethod = "HYBRID"
        elseif merged.flingTp == true or (merged.flingTp == nil and _G.Sticky_FlingTp ~= false) then savedTPMethod = "FLING TP"
        else savedTPMethod = "MANUAL TP" end
    end
    _G.StickySetTPMethod(savedTPMethod)
    _G.StickyInstaTpBrainrot = true
    _G.StickyCFrameGoTo = true
    if type(merged.invisAuto) == "boolean" then _G.StickyInvisAuto = merged.invisAuto end
    if type(merged.invisAutoRecover) == "boolean" then _G.StickyInvisAutoRecover = merged.invisAutoRecover end
    if type(merged.prioritySoundID) == "string" then _G.StickyPrioritySoundID = merged.prioritySoundID end
    if _G.StickyStealMode ~= "nearest" then _G.StickyStealMode = "priority" end
    _G._stealUserOff = false
    if type(merged.priorityList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.priorityList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_PRIORITY_ITEMS
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
            _G.StickyPriVersion = _G.StickyPriVersion + 1
        end
    end
    if type(merged.priorityDefault) == "table" then
        local d = {}
        for _, v in ipairs(merged.priorityDefault) do
            if type(v) == "string" and v ~= "" then d[#d + 1] = v end
        end
        if #d > 0 then _G.StickyPriorityDefault = d end
    end
    if type(merged.mutationList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.mutationList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_MUTATION_PRIORITY
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
        end
    end
    if type(merged.mutationDisabled) == "table" then
        local D = _G.SHARED_MUTATION_DISABLED
        table.clear(D)
        for _, v in ipairs(merged.mutationDisabled) do
            if type(v) == "string" and v ~= "" then D[v] = true end
        end
    end
    if type(merged.traitList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.traitList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_TRAIT_PRIORITY
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
        end
    end
    if type(merged.blacklistList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.blacklistList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        local L = _G.SHARED_BLACKLIST_ITEMS
        if type(L) ~= "table" then L = {}; _G.SHARED_BLACKLIST_ITEMS = L end
        table.clear(L)
        for i = 1, #clean do L[i] = clean[i] end
    end

    if type(merged.invisAuto) == "boolean" then _G.StickyInvisAuto = merged.invisAuto end
    if type(merged.invisDepth) == "number" then _G.StickyInvisDepth = math.clamp(merged.invisDepth, 0, 10) end
    if type(merged.invisAngle) == "number" then _G.StickyInvisAngle = math.clamp(merged.invisAngle, 0, 360) end
    if type(merged.autoTp) == "boolean" then _G.StickyAutoTP = merged.autoTp end
    if type(merged.autoBuy) == "boolean" then _G.StickyAutoBuy = merged.autoBuy end
    if type(merged.autoBuyRange) == "number" then _G.StickyAutoBuyRange = math.clamp(merged.autoBuyRange, 5, 40) end
    if type(merged.autoBuyHover) == "number" then _G.StickyAutoBuyHover = math.clamp(merged.autoBuyHover, 0, 20) end
    if type(merged.panelX) == "number" then _G._stp_panelX = merged.panelX end
    if type(merged.panelY) == "number" then _G._stp_panelY = merged.panelY end
    if type(merged.panelPos) == "table" then _G._stp_pos = merged.panelPos end
    if type(merged.autoKickOnSteal) == "boolean" then _G.StickyAutoKickOnSteal     = merged.autoKickOnSteal end
    if type(merged.resetKey)        == "string"  then _G.StickyResetKeyName        = merged.resetKey end
    if type(merged.invisKey)        == "string"  then _G.StickyInvisKeyName        = merged.invisKey end
    if type(merged.cloneKey)        == "string"  then _G.StickyCloneKeyName        = merged.cloneKey end
    if type(merged.carpetSpeedKey)  == "string"  then _G.StickyCarpetSpeedKeyName  = merged.carpetSpeedKey end
    if type(merged.kickKey)         == "string"  then _G.StickyKickKeyName         = merged.kickKey end
    if type(merged.stopTpKey)       == "string"  then _G.StickyStopTPKeyName       = merged.stopTpKey end
    if type(merged.dropKey)         == "string"  then _G.StickyDropKeyName         = merged.dropKey end
    if type(merged.goSpeed)      == "number"  then _G.StickyGoSpeed            = math.clamp(merged.goSpeed, 80, 600) end
    if type(merged.kickToPS)     == "boolean" then _G.StickyKickToPS           = merged.kickToPS end
    if type(merged.psLink)       == "string"  then _G.StickyPrivateServerLink  = merged.psLink end
    if type(merged.priAlert)     == "boolean" then _G.StickyPriAlert           = merged.priAlert end
    if type(merged.alertSound)   == "string"  then _G.StickyAlertSound         = merged.alertSound end
    if type(merged.alertMinGen)  == "number"  then _G.StickyAlertMinGen        = merged.alertMinGen end
    if type(merged.walkSpeedOn)  == "boolean" then _G.StickyWalkSpeedOn        = merged.walkSpeedOn end
    if type(merged.xray)         == "boolean" then _G.StickyXray               = merged.xray end
    if type(merged) == "table" and merged.cframeGoTo ~= nil then _G.StickyCFrameGoTo = merged.cframeGoTo == true; _G.StickyCFrameGoTo = _G.StickyCFrameGoTo end
    if type(merged.uiOpenKey) == "string" then _G.StickyUiOpenKey = merged.uiOpenKey end
    if type(merged.frontTp) == "boolean" then _G.StickyFrontTP = merged.frontTp end
    if type(merged.sideTp) == "boolean" then _G.StickySideTP = merged.sideTp end
    if type(merged.sideTpRange) == "number" then _G.StickySideTPRange = math.clamp(merged.sideTpRange, 20, 200) end

    if type(merged.antiFlash)    == "boolean" then _G.StickyAntiFlash          = merged.antiFlash end
    if type(merged.faceAway)        == "boolean" then _G.StickyFaceAway        = merged.faceAway end
    if type(merged.faceAwayNearest) == "boolean" then _G.StickyFaceAwayNearest = merged.faceAwayNearest end
    if type(merged.faceAwayDelay)   == "number"  then _G.StickyFaceAwayDelay   = merged.faceAwayDelay end
    if type(merged.antiBee)      == "boolean" then _G.StickyAntiBee            = merged.antiBee end
    if type(merged.infJump)      == "boolean" then _G.StickyInfJump            = merged.infJump end
    if type(merged.antiDie)      == "boolean" then _G.AntiDieDisabled = false end
    _G.AntiDieDisabled = false
    _G.StickyAntiDie = true
    if type(merged.carpetSpeedValue) == "number" then _G.StickyCarpetSpeedValue = merged.carpetSpeedValue end
    if type(merged.exX) == "number" then _G._Sticky_exX = merged.exX end
    if type(merged.exY) == "number" then _G._Sticky_exY = merged.exY end
    if type(merged.fX)  == "number" then _G._Sticky_fX  = merged.fX  end
    if type(merged.fY)  == "number" then _G._Sticky_fY  = merged.fY  end
    if type(merged.kX)  == "number" then _G._Sticky_kX  = merged.kX  end
    if type(merged.kY)  == "number" then _G._Sticky_kY  = merged.kY  end

    if writefile then
        pcall(function()
            local t = type(fileData) == "table" and fileData or {}
            if t.autoTp == nil then t.autoTp = type(merged.autoTp) == "boolean" and merged.autoTp or true end
            writefile("SideTP.json", _HS:JSONEncode(t))
        end)
    end
end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local RS         = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

if _G.StickyNoZeroVel == nil then _G.StickyNoZeroVel = false end
function _vzOK()
    if _G.StickyNoZeroVel == true then return false end
    if _G.StickyZeroWhileStealing ~= true and LP:GetAttribute("Stealing") == true then return false end
    return true
end
function _vzL(p)
    if p and _vzOK() then
        p.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end
function _vzA(p)
    if p and _vzOK() then
        p.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end

_BLOCKING_MACHINE_TYPES = {
    Fuse     = true,
    Duel     = true,
    Trade    = true,
    Crafting = true,
}
function _StickyIsFusing(animalData)
    if type(animalData) ~= "table" then return false end
    local m = animalData.Machine
    if type(m) ~= "table" then return false end
    return _BLOCKING_MACHINE_TYPES[m.Type] == true
end

do

local RS  = game:GetService("ReplicatedStorage")
local RUN = game:GetService("RunService")

local _netFolder
local function _netDir()
    if _netFolder then return _netFolder end
    local pk = RS:FindFirstChild("Packages") or RS:WaitForChild("Packages", 10)
    if not pk then return nil end
    _netFolder = pk:FindFirstChild("Net") or pk:WaitForChild("Net", 10)
    return _netFolder
end
local _net
local function _getNet()
    if _net then return _net end
    local dir = _netDir()
    if not dir then return nil end
    local ok, m = pcall(require, dir)
    if ok and type(m) == "table" then _net = m end
    return _net
end
local _queue, _hooked, _original = {}, false, nil
local function _host()
    for _, sig in ipairs({ RUN.Heartbeat, RUN.RenderStepped, RUN.PostSimulation }) do
        local ok, conns = pcall(getconnections, sig)
        if ok then
            for _, c in ipairs(conns) do
                local f = c.Function
                if f and f ~= _G.__mkSyncHost and islclosure(f) and not isexecutorclosure(f) then
                    local s = select(2, pcall(debug.info, f, "s"))
                    if type(s) == "string" and s:find("^ReplicatedStorage%.") and not s:find("ReplicatedFirst") then
                        return f
                    end
                end
            end
        end
    end
end
local function _install()
    if _hooked then return true end
    if not _getNet() then return false end
    local h = _host()
    if not h then return false end
    _G.__mkNetHost = h
    local w = function(...)
        local job = table.remove(_queue, 1)
        if job then
            local ok, r = pcall(_net[job.kind], _net, job.name)
            job.result = (ok and typeof(r) == "Instance") and r or nil
            job.done = true
        end
        return _original(...)
    end
    local ok, env = pcall(getfenv, h)
    if ok and type(env) == "table" then pcall(setfenv, w, env) end
    _original = hookfunction(h, w)
    _hooked = true
    return true
end
local _cache = {}
local function _get(name, kind)
    kind = (kind == "RemoteFunction" and "RemoteFunction")
        or (kind == "UnreliableRemoteEvent" and "UnreliableRemoteEvent")
        or "RemoteEvent"
    if type(name) ~= "string" or name == "" then return nil end
    local logical = name:match("^R[EF]/(.+)$") or name:match("^URE/(.+)$") or name
    local ck = kind .. "|" .. logical
    local hit = _cache[ck]
    if hit and hit.Parent then return hit end
    _cache[ck] = nil
    if not _getNet() then return nil end
    if not _install() then return nil end
    local job = { kind = kind, name = logical }
    table.insert(_queue, job)
    local t = os.clock() + (tonumber(_G.StickyNetTimeout) or 5)
    while not job.done and os.clock() < t do RUN.Heartbeat:Wait() end
    if job.result and job.result.Parent then
        _cache[ck] = job.result
        return job.result
    end
    return nil
end
_G.StickyNet = {
    RemoteEvent = function(_, name) return _get(name, "RemoteEvent") end,
    RemoteFunction = function(_, name) return _get(name, "RemoteFunction") end,
    UnreliableRemoteEvent = function(_, name) return _get(name, "UnreliableRemoteEvent") end,
}
_G.StickyGetRemote = _get
_G.Resolve = _get
_G.__secureGetRemote = function(method, name) return _get(name, method) end
_G.StickyNetHooked = function() return _hooked end
do
    local _dummy = Instance.new("RemoteEvent")
    local _rawFire = (clonefunction and clonefunction(_dummy.FireServer)) or _dummy.FireServer
    _G.RawFire = function(name, ...)
        local r = _get(name)
        if not r then return false end
        _rawFire(r, ...)
        return true
    end
end
end

do
local _xchan
local _lastTry, _attempts = 0, 0
local _deepScans, _lastDeep = 0, 0
local _mod

local MAX_ATTEMPTS, RETRY_GAP = 40, 0.5
local BOOT_T0, BOOT_BURST, BOOT_GAP = os.clock(), 3.0, 0.10
local MAX_DEEP, DEEP_GAP = 3, 1.5
local _bootDone = false
local _bootGrace = 4.0

local RS_SYNC = game:GetService("ReplicatedStorage")
local _mask_sc
local function _getMask()
    if _mask_sc and _mask_sc.Parent then return _mask_sc end
    local c = RS_SYNC:FindFirstChild("Controllers")
    _mask_sc = c and c:FindFirstChild("PlotController")
    return _mask_sc
end
local secure_call = _G.secure_call
if type(secure_call) ~= "function" then

    local RUN = game:GetService("RunService")
    local state = { ready = false, inside = false }
    local conn, original
    local function host()
        for _, sig in ipairs({ RUN.Heartbeat, RUN.RenderStepped, RUN.PostSimulation }) do
            local ok, conns = pcall(getconnections, sig)
            if ok then
                for _, c in ipairs(conns) do
                    local f = c.Function
                    if f and f ~= _G.__mkNetHost and islclosure(f) and not isexecutorclosure(f) then
                        local s = select(2, pcall(debug.info, f, "s"))
                        if type(s) == "string" and s:find("^ReplicatedStorage%.") and not s:find("ReplicatedFirst") then
                            return f, c, s
                        end
                    end
                end
            end
        end
    end
    local function install()
        if state.ready then return true end
        local h, c, src = host()
        if not h then return false end
        local chunk = loadstring([[
            local state, pack, unpack = ...
            return function(...)
                local job = state.job
                if job and not job.done then
                    job.done = true
                    state.inside = true
                    job.result = pack(pcall(job.fn, unpack(job.args, 1, job.args.n)))
                    state.inside = false
                end
                return state.original(...)
            end
        ]], "=" .. src)
        if not chunk then return false end
        local ok, env = pcall(getfenv, h)
        if ok and type(env) == "table" then pcall(setfenv, chunk, env) end
        local wrapper = chunk(state, table.pack, table.unpack)
        _G.__mkSyncHost = h
        original = hookfunction(h, wrapper)
        state.original = original
        conn = c
        state.ready = true
        return true
    end
    secure_call = function(fn, ...)
        if type(fn) ~= "function" then return nil end
        if state.inside then return fn(...) end
        if not install() then return nil end
        state.job = { fn = fn, args = table.pack(...), done = false }
        pcall(function() conn:Fire(0) end)
        local job = state.job
        state.job = nil
        if not job or not job.done or not job.result then return nil end
        if not job.result[1] then error(job.result[2], 2) end
        return table.unpack(job.result, 2, job.result.n)
    end
    _G.secure_call = secure_call
    _G.StickySyncHooked = function() return state.ready end
end
task.spawn(function()
    pcall(function()
        local sync = _getSyncMod()
        if sync and type(sync.GetAllChannels) == "function" then
            local mask = _getMask()
            if mask then pcall(secure_call, sync.GetAllChannels, mask) end
        end
    end)
end)
local _syncMod_sc, _nextTry_sc = nil, 0
local function _getSyncMod()
    if _syncMod_sc then return _syncMod_sc end
    local p = RS_SYNC:FindFirstChild("Packages")
    local m = p and p:FindFirstChild("Synchronizer")
    if not m then return nil end
    local ok, mod = pcall(require, m)
    if ok and type(mod) == "table" then _syncMod_sc = mod end
    return _syncMod_sc
end
_G.__secureChans = function()
    if os.clock() < _nextTry_sc then return _xchan end
    local sync = _getSyncMod()
    if not sync then _nextTry_sc = os.clock() + 0.1; return _xchan end
    if type(sync.GetAllChannels) ~= "function" then _nextTry_sc = os.clock() + 0.1; return _xchan end
    local mask = _getMask()
    if not mask then _nextTry_sc = os.clock() + 0.1; return _xchan end
    local ok, reg = pcall(secure_call, sync.GetAllChannels, mask)
    if ok and type(reg) == "table" then
        _xchan = reg; _nextTry_sc = os.clock() + 1.5
        _G.StickySyncDiag = "GetAllChannels (secure_call) - undetect/instant"
    else
        _nextTry_sc = os.clock() + 0.1
    end
    return _xchan
end

local function _retryGap()
    if (os.clock() - BOOT_T0) < BOOT_BURST then return BOOT_GAP end
    return RETRY_GAP
end

local function _channelCount(t)
    if type(t) ~= "table" then return 0 end
    local ok, hits = pcall(function()
        local h, n = 0, 0
        for _, v in next, t do
            n = n + 1
            if type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                h = h + 1
            end
            
            if n >= 50 then break end
        end
        return h
    end)
    return (ok and hits) or 0
end

local function _module()
    if _mod then return _mod end
    local ok, m = pcall(function()
        return require(game:GetService("ReplicatedStorage").Packages.Synchronizer)
    end)
    if ok and type(m) == "table" then _mod = m; return _mod end
    local ok2, m2 = pcall(function()
        local pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
        local sync = pkgs and pkgs:FindFirstChild("Synchronizer")
        if not sync then return nil end
        return require(sync)
    end)
    if ok2 and type(m2) == "table" then _mod = m2 end
    return _mod
end

local function _probe(mod)
    local gu = (debug and debug.getupvalue) or getupvalue
    if type(gu) ~= "function" then return nil, 0, nil end
    local best, bestN, where = nil, 0, nil
    local function consider(t, tag)
        local n = _channelCount(t)
        if n > bestN then best, bestN, where = t, n, tag end
    end
    local cands = {
        { mod.Get, 10, 4, "Get/10/4" },
        { mod.GetAllChannels, 10, 1, "GetAll/10/1" },
        { mod.Wait, 10, 1, "Wait/10/1" },
    }
    for _, c in ipairs(cands) do
        if type(c[1]) == "function" then
            local o, u = pcall(gu, c[1], c[2])
            if o and type(u) == "table" then
                consider(rawget(u, c[3]), c[4])
                if bestN > 0 then return best, bestN, where end
            end
        end
    end
    for _, fn in ipairs({ mod.Get, mod.GetAllChannels, mod.Wait, mod.WaitAndCall, mod.GetTableFromChannel }) do
        if type(fn) == "function" then
            for i = 8, 12 do
                local o, u = pcall(gu, fn, i)
                if o and type(u) == "table" then
                    consider(u, "up" .. i)
                    for j = 1, 4 do consider(rawget(u, j), "up" .. i .. "/" .. j) end
                    if bestN > 0 then return best, bestN, where end
                end
            end
        end
    end
    local ok, up = pcall(gu, mod.Get, 9)
    if ok and type(up) == "table" then
        consider(rawget(up, 3), "Get/9/3")
        if bestN > 0 then return best, bestN, where end
        consider(up, "Get/9")
        if bestN > 0 then return best, bestN, where end
    end
    return best, bestN, where
end

local function _deepScan(mod)
    local gu = (debug and debug.getupvalue) or getupvalue
    if type(gu) ~= "function" then return nil, 0, nil end
    local best, bestN, where = nil, 0, nil
    local function consider(t, tag)
        local n = _channelCount(t)
        if n > bestN then best, bestN, where = t, n, tag end
    end
    local _fnCount = 0
    for fname, fn in next, mod do
        if type(fn) == "function" then
            _fnCount = _fnCount + 1
            if _fnCount > 30 then break end
            for i = 1, 16 do
                local o, u = pcall(gu, fn, i)
                if not o then break end
                if type(u) == "table" then
                    consider(u, tostring(fname) .. "/" .. i)
                    for j = 1, 4 do
                        consider(rawget(u, j), tostring(fname) .. "/" .. i .. "/" .. j)
                    end
                end
            end
        end
    end
    return best, bestN, where
end

local _gcFound, _gcFoundN, _gcState = nil, 0, "idle"

local function _gcScanOnce()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    local live, names, nLive = {}, {}, 0
    for _, p in ipairs(plots:GetChildren()) do live[p.Name] = true; nLive = nLive + 1; names[nLive] = p.Name end
    if nLive == 0 then return end

    local function score(t)
        local hits, seen = 0, 0
        for k, v in next, t do
            seen = seen + 1
            if type(k) == "string" and live[k]
                and type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                hits = hits + 1
            end
            if seen >= 64 then break end
        end
        return hits
    end

    local best, bestN = nil, 0
    local hasFilter = type(filtergc) == "function"

    if hasFilter then
        local tries = {}
        if nLive >= 2 then tries[1] = { names[1], names[2], "CacheTable" } end
        tries[#tries + 1] = { names[1], "CacheTable" }
        if nLive >= 3 then tries[#tries + 1] = { names[2], names[3], "CacheTable" } end
        for _, keys in ipairs(tries) do
            local ok, res = pcall(filtergc, "table", { Keys = keys }, false)
            if ok and type(res) == "table" then
                for _, t in ipairs(res) do
                    if type(t) == "table" then
                        local n = score(t)
                        if n > bestN and n >= 2 then best, bestN = t, n end
                    end
                end
            end
            if bestN >= nLive then break end
        end
    end

    if bestN == 0 and type(getgc) == "function"
        and (not hasFilter or _G.StickyAllowFullGc == true)
        and not (_G.StickyIsTeleporting and _G.StickyIsTeleporting())
        and (os.clock() - (_G.__gcFullAt or 0)) >= (tonumber(_G.StickyFullGcGap) or 3.0)
        and (workspace.StreamingEnabled == false or os.clock() - _gameLoadAt >= 4.0) then
        _G.__gcFullAt = os.clock()
        pcall(function()
            local gc = getgc(true)
            local _gcLimit = math.min(#gc, 4000)
            for i = 1, _gcLimit do
                local t = gc[i]
                if type(t) == "table" then
                    local pk = 0
                    for k in next, t do
                        if type(k) == "string" and live[k] then pk = pk + 1; if pk >= 2 then break end end
                    end
                    if pk >= 2 then
                        local n = score(t)
                        if n > bestN and n >= 2 then best, bestN = t, n end
                    end
                    if bestN >= nLive then break end
                end
            end
        end)
    end
    if best and bestN > _gcFoundN then _gcFound, _gcFoundN = best, bestN end
end

local _gcLastScan = 0
local _gcRescans = 0
local _gcMiss, _gcLastPlots = 0, -1
local function _gcChans()
    if _gcFound then
        local _pl = workspace:FindFirstChild("Plots")
        local _nLive = _pl and #_pl:GetChildren() or 0
        if _G.StickySyncRescan == true and _gcFoundN < _nLive
            and _gcRescans < (tonumber(_G.StickySyncMaxRescan) or 20)
            and (os.clock() - _gcLastScan) >= (tonumber(_G.StickySyncRescanGap) or 3) then
            _gcLastScan = os.clock()
            _gcRescans = _gcRescans + 1
            _gcScanOnce()
        end
        return _gcFound, _gcFoundN, "gc/plot-key+CacheTable"
    end

    local _pl = workspace:FindFirstChild("Plots")
    local _n = _pl and #_pl:GetChildren() or 0
    if _n ~= _gcLastPlots then
        _gcLastPlots = _n

        _gcMiss = (_gcMiss > 2) and 2 or _gcMiss
        _gcLastScan = _gcLastScan - 0.05
    end

    local gap = tonumber(_G.StickySyncScanGap) or 0.2
    local back = math.min(_gcMiss * (tonumber(_G.StickySyncMissStep) or 0.15),
                          tonumber(_G.StickySyncMissMax) or 1)
    if os.clock() - _gcLastScan < (gap + back) then return nil, 0, nil end
    _gcLastScan = os.clock()
    _gcScanOnce()
    if _gcFound then
        _gcMiss = 0
        return _gcFound, _gcFoundN, "gc/plot-key+CacheTable"
    end

    if _n > 0 then _gcMiss = _gcMiss + 1 end
    return nil, 0, nil
end

local function _apiChans(mod)
    if type(mod) ~= "table" then return nil, 0, nil end
    local fn = rawget(mod, "GetAllChannels")
    if type(fn) ~= "function" then return nil, 0, nil end
    local function _accept(reg, tag)
        if type(reg) ~= "table" then return nil, 0, nil end
        local n = _channelCount(reg)
        if n > 0 then return reg, n, tag end
        return nil, 0, nil
    end

    if _G.StickyAllowSecureSyncCall ~= false and type(secure_call) == "function" then
        for _, form in ipairs({ "self", "plain" }) do
            local ok, reg = pcall(function()
                if form == "self" then return secure_call(fn, mod) end
                return secure_call(fn)
            end)
            if ok then
                local r, n, t = _accept(reg, "GetAllChannels/secure_call(" .. form .. ")")
                if r then return r, n, t end
            end
        end
    end
    if _G.StickyAllowRawSyncCall then
        for _, form in ipairs({ "self", "plain" }) do
            local ok, reg = pcall(function()
                if form == "self" then return fn(mod) end
                return fn()
            end)
            if ok then
                local r, n, t = _accept(reg, "GetAllChannels/RAW(" .. form .. ")")
                if r then return r, n, t end
            end
        end
    end
    return nil, 0, nil
end

local _xchan2, _nextTry2, _attempts2 = nil, 0, 0
local _xchan2Until = 0
local _nextApi = 0
local _chansLastScan = 0
local function _chans()
    if _xchan2 then
        local now = os.clock()
        if now < _xchan2Until then return _xchan2 end
        if _channelCount(_xchan2) > 0 then _xchan2Until = now + 2 return _xchan2 end
    end
    local now = os.clock()
    if now - _chansLastScan < 0.02 then return _xchan2 end
    if now < _nextTry2 then return _xchan2 end
    _chansLastScan = now
    _attempts2 = _attempts2 + 1

    local best, n, where
    if _G.StickyAllowSecureSyncCall ~= false and os.clock() >= _nextApi then
        local mod = _getSyncMod()
        if mod then best, n, where = _apiChans(mod) end
        if not best or n == 0 then _nextApi = os.clock() + (tonumber(_G.StickySyncApiGap) or 0.5) end
    end

    if not best or n == 0 then best, n, where = _gcChans() end

    if (not best or n == 0) and _attempts2 <= 400 and _G.StickyAllowUpvalueProbe then
        local mod = _getSyncMod()
        if mod then
            best, n, where = _probe(mod)
            local inBoot = _gameLoadAt and (os.clock() - _gameLoadAt) < 4
            if (not best or n == 0) and (not inBoot) and os.clock() - _lastDeep > 2 then
                _lastDeep = os.clock()
                _deepScans = _deepScans + 1
                best, n, where = _deepScan(mod)
            end
        end
    end
    if best and n > 0 then
        _xchan2 = best
        _G.StickySyncDiag = string.format("%s - %d channels", tostring(where), n)
        return _xchan2
    end

    local inBoot2 = _gameLoadAt and (os.clock() - _gameLoadAt) < 4
    _nextTry2 = os.clock() + (inBoot2 and 0.1 or ((_G.StickyScanMode == "fast") and 0.03 or 0.1))
    return _xchan2
end
_G.__secureChans = _chans

_G.StickySyncAll=function()return _chans()end
_G.StickySyncGet=function(idx)
local t=_chans()
if not t or idx==nil then return nil end
local ok,cd=pcall(rawget,t,idx)
if ok and type(cd)=="table" then return cd end
local ok2,cd2=pcall(function() return t[idx] end)
if ok2 and type(cd2)=="table" then return cd2 end
return nil
end
_G.sProp=function(ch,key)
if type(ch)~="table" or key==nil then return nil end
local ct=rawget(ch,"CacheTable")
if type(ct)~="table" then
local okC,c2=pcall(function() return ch.CacheTable end)
if okC and type(c2)=="table" then ct=c2 end
end
if type(ct)~="table" then return nil end
local v=rawget(ct,key)
if v~=nil then return v end
local okV,v2=pcall(function() return ct[key] end)
if okV then return v2 end
return nil
end
_G._StickyRawCT=function(plotName)
local c=_G.StickySyncGet(plotName)
if not c then return nil end
return rawget(c,"CacheTable")
end
local _AD,_MD,_TD
local function _data()
if _AD then return true end
local ok=pcall(function()

local R=game:GetService("ReplicatedStorage")
local d=R:FindFirstChild("Datas") or R:WaitForChild("Datas",2)
if not d then return end
local a=d:FindFirstChild("Animals") or d:WaitForChild("Animals",2)
if a then _AD=require(a) end
local m=d:FindFirstChild("Mutations") or d:WaitForChild("Mutations",2)
if m then _MD=require(m) end
local t=d:FindFirstChild("Traits") or d:WaitForChild("Traits",2)
if t then _TD=require(t) end
end)
return ok and _AD~=nil
end
_G._StickyGen=function(index,mutation,traits)
if not _data() then return 0 end
local info=_AD[index]
if not info or not info.Generation then return 0 end
local mult=1
if mutation and mutation~="None" and mutation~="" then
local m=_MD[mutation]
if m and m.Modifier then mult=mult+m.Modifier end
end
if type(traits)=="table" then
for _,tr in ipairs(traits)do
local t=_TD[tr]
if t and t.MultiplierModifier then mult=mult+t.MultiplierModifier end
end
end
return info.Generation*mult
end
local _sharedAnimals
_G._StickyAnimShim=setmetatable({GetGeneration=function(_,index,mutation,traits)return _G._StickyGen(index,mutation,traits)end},{
__index=function(_,k)

if not _sharedAnimals then
local ok,real=pcall(function()
local R=game:GetService("ReplicatedStorage")
local sh=R:FindFirstChild("Shared") or R:WaitForChild("Shared",3)
local an=sh and (sh:FindFirstChild("Animals") or sh:WaitForChild("Animals",3))
return an and require(an) or nil
end)
if ok and type(real)=="table" then _sharedAnimals=real end
end
if not _sharedAnimals then return nil end
return rawget(_sharedAnimals,k)
end})
_G.Sticky_GetPlotChannel=function(plotName)return _G.StickySyncGet(plotName)end
_G.Sticky_GetAllPlots=function()return _G.StickySyncAll() or {} end
_G.Sticky_GetPlotAnimalList=function(plotName)
local ct=_G._StickyRawCT(plotName)
local al=ct and ct.AnimalList
return type(al)=="table" and al or nil
end
end

_G.StickySyncAll  = _G.StickySyncAll
_G.StickySyncGet  = _G.StickySyncGet
_G.StickyRawCT    = _G._StickyRawCT
_G.StickyGen      = _G._StickyGen
_G.StickyAnimShim = _G._StickyAnimShim
_G.stealthGet    = function(n) return _G.StickySyncGet(n) end
_G.SyncInt       = {_cache={},_data=nil}

task.spawn(function()
    for i = 1, 260 do
        local t = _G.StickySyncAll()
        local pl = workspace:FindFirstChild("Plots")
        local kids = pl and pl:GetChildren()
        local want = kids and #kids or 0
        if want > 0 and type(t) == "table" then
            local have = 0
            for k = 1, want do
                if rawget(t, kids[k].Name) ~= nil then have = have + 1 end
            end
            if have >= want then _G.StickyChannelsReady = true return end
        end
        task.wait(i <= 100 and 0.04 or 0.1)
    end
end)

_G.StickyGetSyncData = _G.StickyGetSyncData or function(plot)
    local plotName = type(plot) == "string" and plot or (plot and plot.Name)
    if not plotName then return nil end
    local Pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
    local Sync = Pkgs and Pkgs:FindFirstChild("Synchronizer")
    if not Sync then return nil end
    local okMod, mod = pcall(require, Sync)
    if not okMod or type(mod) ~= "table" then return nil end

    local okT, data = pcall(function() return _G.StickyRawCT(plotName) end)
    if okT and type(data) == "table" then return data end

    local okC, ch = pcall(function() return _G.StickySyncGet(plotName) end)
    if okC and ch then
        local synth = { __channel = ch }
        pcall(function() local ct = rawget(ch, "CacheTable"); if type(ct)=="table" then synth.AnimalList = ct.AnimalList; synth.Owner = ct.Owner end end)
        return synth
    end
    return nil
end

_mkNextModTry = 0

function _StickyBuildDefaultBrainrotPriority()
    if not AnimalsData then return end
    table.clear(_brainrotDefaultPri)
    table.clear(_brainrotDefaultRarity)
    local rarities = { OG = 1, Secret = 2, ["Brainrot God"] = 3, ["Brainrot Titan"] = 4, ["Brainrot Legendary"] = 5, Legendary = 6, Mythic = 7, Epic = 8, Rare = 9, Uncommon = 10, Common = 11 }
    local list = {}
    for name, info in pairs(AnimalsData) do
        if type(info) == "table" then
            local r = tostring(info.Rarity or "Common")
            local rIdx = rarities[r] or 12
            table.insert(list, { name = info.DisplayName or name, index = name, r = r, rIdx = rIdx })
        end
    end
    table.sort(list, function(a, b)
        if a.rIdx ~= b.rIdx then return a.rIdx < b.rIdx end
        return (a.name or a.index) < (b.name or b.index)
    end)
    for i, v in ipairs(list) do
        local nn = _normName(v.name)
        local ni = _normName(v.index)
        _brainrotDefaultPri[nn] = i
        _brainrotDefaultRarity[nn] = v.r
        if _brainrotDefaultPri[ni] == nil then
            _brainrotDefaultPri[ni] = i
            _brainrotDefaultRarity[ni] = v.r
        end
    end
    if #_G.SHARED_PRIORITY_ITEMS == 0 then
        local cap = tonumber(_G.StickyDefaultPrioCap) or 60
        for i, v in ipairs(list) do
            if i > cap then break end
            _G.SHARED_PRIORITY_ITEMS[i] = v.name
        end
    end
    _G.StickyPriVersion = (_G.StickyPriVersion or 0) + 1
end

function loadModules()
    if AnimalsData then
        if not AnimalsShared and _G.StickyAnimShim then AnimalsShared = _G.StickyAnimShim end
        return true
    end
    if os.clock() < _mkNextModTry then return false end
    _mkNextModTry = os.clock() + (tonumber(_G.StickyModRetry) or 0.5)
    pcall(function()
        local Datas = RS:FindFirstChild("Datas") or RS:WaitForChild("Datas", 1.5)
        if Datas then
            local a = Datas:FindFirstChild("Animals") or Datas:WaitForChild("Animals", 1.5)
            if a then AnimalsData = require(a) end
        end
    end)
    pcall(_StickyBuildDefaultBrainrotPriority)
    AnimalsShared = _G.StickyAnimShim
    if not NumberUtils then
        pcall(function()
            local Utils = RS:FindFirstChild("Utils")
            local n = Utils and Utils:FindFirstChild("NumberUtils")
            if n then NumberUtils = require(n) end
        end)
    end
    return AnimalsData ~= nil
end

function loadNet() return false end

function getRemote(method, name)
    return _G.__secureGetRemote(method, name)
end
_G.StickyGetRemote = getRemote

do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local RS = game:GetService("ReplicatedStorage")
	local LP = Players.LocalPlayer

	local getRemote
	do
		local _netFolder
		local function _netDir()
			if _netFolder then return _netFolder end
			local pk = RS:FindFirstChild("Packages") or RS:WaitForChild("Packages", 10)
			if not pk then return nil end
			_netFolder = pk:FindFirstChild("Net") or pk:WaitForChild("Net", 10)
			return _netFolder
		end
		local _net
		local function _getNet()
			if _net then return _net end
			local dir = _netDir()
			if not dir then return nil end
			local ok, m = pcall(require, dir)
			if ok and type(m) == "table" then _net = m end
			return _net
		end
		local _queue, _hooked, _original = {}, false, nil
		local function _host()
			if type(getconnections) ~= "function" then return nil end
			for _, sig in ipairs({ RunService.Heartbeat, RunService.RenderStepped, RunService.PostSimulation }) do
				local ok, conns = pcall(getconnections, sig)
				if ok and type(conns) == "table" then
					for _, c in ipairs(conns) do
						local f = c.Function
						if f and f ~= _G.__lefaSyncHost and type(islclosure) == "function" and islclosure(f)
							and (type(isexecutorclosure) ~= "function" or not isexecutorclosure(f)) then
							local s = select(2, pcall(debug.info, f, "s"))
							if type(s) == "string" and s:find("^ReplicatedStorage%.") and not s:find("ReplicatedFirst") then
								return f
							end
						end
					end
				end
			end
			return nil
		end
		local function _install()
			if _hooked then return true end
			if type(hookfunction) ~= "function" then return false end
			if not _getNet() then return false end
			local h = _host()
			if not h then return false end
			_G.__lefaNetHost = h
			local w = function(...)
				local job = table.remove(_queue, 1)
				if job then
					local ok, r = pcall(_net[job.kind], _net, job.name)
					job.result = (ok and typeof(r) == "Instance") and r or nil
					job.done = true
				end
				return _original(...)
			end
			local ok, env = pcall(getfenv, h)
			if ok and type(env) == "table" then pcall(setfenv, w, env) end
			_original = hookfunction(h, w)
			_hooked = true
			return true
		end
		local _cache = {}
		local function _get(name, kind)
			kind = (kind == "RemoteFunction" and "RemoteFunction")
				or (kind == "UnreliableRemoteEvent" and "UnreliableRemoteEvent")
				or "RemoteEvent"
			if type(name) ~= "string" or name == "" then return nil end
			local logical = name:match("^R[EF]/(.+)$") or name:match("^URE/(.+)$") or name
			local ck = kind .. "|" .. logical
			local hit = _cache[ck]
			if hit and hit.Parent then return hit end
			_cache[ck] = nil
			if not _getNet() then return nil end
			if not _install() then
				if type(_G.__secureGetRemote) == "function" then
					local r = _G.__secureGetRemote(kind, logical)
					if r and r.Parent then _cache[ck] = r; return r end
				end
				if type(_G.StickyGetRemote) == "function" then
					local r = _G.StickyGetRemote(kind, logical)
					if r and r.Parent then _cache[ck] = r; return r end
				end
				return nil
			end
			local job = { kind = kind, name = logical }
			table.insert(_queue, job)
			local t = os.clock() + (tonumber(_G.LefaNetTimeout) or 5)
			while not job.done and os.clock() < t do RunService.Heartbeat:Wait() end
			if job.result and job.result.Parent then
				_cache[ck] = job.result
				return job.result
			end
			return nil
		end
		_G.__lefaGetRemote = _G.__lefaGetRemote or function(method, name) return _get(name, method) end
		getRemote = function(method, name) return _get(name, method) end
	end

	local GRAPPLE_ARG = 0.8
	local _grappleUseItem, _grappleItemUse

	task.spawn(function() _grappleUseItem = getRemote("RemoteEvent", "UseItem") end)
	task.spawn(function() _grappleItemUse = getRemote("RemoteEvent", "75c9466d-e4c0-4b02-b26a-c3615fcc1e42") end)

	local function _fireGrapple()
		local fired = false
		if not (_grappleUseItem and _grappleUseItem.Parent) then
			_grappleUseItem = getRemote("RemoteEvent", "UseItem")
		end
		if not (_grappleItemUse and _grappleItemUse.Parent) then
			_grappleItemUse = getRemote("RemoteEvent", "75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
		end
		if _grappleUseItem and _grappleUseItem.Parent then
			pcall(function() _grappleUseItem:FireServer(GRAPPLE_ARG) end)
			fired = true
		end
		if _grappleItemUse and _grappleItemUse.Parent then
			pcall(function() _grappleItemUse:FireServer(GRAPPLE_ARG) end)
			fired = true
		end
		if not fired then
			local r = getRemote("RemoteEvent", "UseItem")
			if r then
				pcall(function() r:FireServer(GRAPPLE_ARG) end)
				fired = true
			end
		end
		if fired then _G.LastGrappleAt = os.clock() end
		return fired
	end

	local function fireGrapple(destino)
		local char = LP.Character
		if not char then return false end
		if not char:FindFirstChild("Grapple Hook") then
			local bp = LP:FindFirstChild("Backpack")
			local tool = bp and bp:FindFirstChild("Grapple Hook")
			local hum = char:FindFirstChildOfClass("Humanoid")
			if tool and hum then pcall(function() hum:EquipTool(tool) end) end
			task.wait(0.05)
			char = LP.Character or char
		end
		if not char:FindFirstChild("Grapple Hook") then return false end
		return _fireGrapple()
	end

	_G.StickyFireGrapple2 = function(value, exato)
		return fireGrapple(value)
	end
	_G.Sticky_FireGrapple = _G.StickyFireGrapple2
	_G.StickyFireGrapple = fireGrapple
	_G.StickyFireGrappleBoth = function(...)
		return fireGrapple(...)
	end
	_G.LefaFireGrapple = fireGrapple
	_G.StickyGrappleReady = function()
		return true
	end

	function fireGrappleBeforeTP(destino)
		local char = LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not char or not hum then return false end
		local justEquipped = false
		if not char:FindFirstChild("Grapple Hook") then
			local bp = LP:FindFirstChild("Backpack")
			local g = bp and bp:FindFirstChild("Grapple Hook")
			if g then
				pcall(function() hum:EquipTool(g) end)
				justEquipped = true
			end
		end
		if justEquipped or not char:FindFirstChild("Grapple Hook") then
			local waitS = math.max(0.05, (tonumber(_G.StickyGrappleWaitMs) or tonumber(_G.StickyGrappleWaitMs) or 200) / 1000)
			pcall(function() char:WaitForChild("Grapple Hook", waitS) end)
		end
		if justEquipped then
			task.wait((tonumber(_G.StickyGrappleSettleMs) or tonumber(_G.StickyGrappleSettleMs) or 60) / 1000)
		end
		char = LP.Character
		if not (char and char:FindFirstChild("Grapple Hook")) then return false end
		local res = _fireGrapple()
		_G.__StickyGrapplePrimed = true
		RunService.Heartbeat:Wait()
		RunService.Heartbeat:Wait()
		return res and true or false
	end
	_G.StickyFireGrappleBeforeTP = fireGrappleBeforeTP

	_G.__StickyLefaFireGrapple = fireGrapple
	rawset(getfenv and getfenv(0) or _G, "fireGrapple", fireGrapple)
	getgenv = getgenv or function() return _G end
	pcall(function()
		if type(getgenv) == "function" then
			getgenv().fireGrapple = fireGrapple
			getgenv().fireGrappleBeforeTP = fireGrappleBeforeTP
		end
	end)
end

function fireGrapple(destino)
	if type(_G.StickyFireGrapple2) == "function" then
		return _G.StickyFireGrapple2(destino)
	end
	return false
end
function fireGrappleBeforeTP(destino)
	if type(_G.StickyFireGrappleBeforeTP) == "function" then
		return _G.StickyFireGrappleBeforeTP(destino)
	end
	return fireGrapple(destino)
end
_G.StickyFireGrapple = fireGrapple

CARPET_SPEED = 280
INBASE_SPEED = 450
SKY_CLONE_WAIT = 0.35
CARPET_NAMES = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }

FLY_TOOLS = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }
function findTool(name)
    local char = LP.Character
    local bp = LP:FindFirstChild("Backpack")
    return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
end
GRAPPLE_NAMES = { "Grapple Hook" }
function findGrapple()
    for _, n in ipairs(GRAPPLE_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then return t, n end
    end
    return nil
end
function listTools()
    local out, char, bp = {}, LP.Character, LP:FindFirstChild("Backpack")
    if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then out[#out + 1] = t.Name end end end
    if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then out[#out + 1] = t.Name end end end
    return table.concat(out, ", ")
end
_lastCarpetName = nil
function equipCarpet()
    local char = LP.Character
    if not char then return nil end
    if _lastCarpetName then
        local t = char:FindFirstChild(_lastCarpetName)
        if t and t.Parent == char then return _lastCarpetName end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    for _, n in ipairs(CARPET_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then
            if t.Parent ~= char then pcall(function() hum:EquipTool(t) end) end
            _lastCarpetName = n
            return n
        end
    end
    return nil
end
function setCarpetTool(name)
    if type(name) ~= "string" or name == "" then return end
    _G.StickyCarpetTool = name

    _lastCarpetName = nil
    for i = #CARPET_NAMES, 1, -1 do
        if CARPET_NAMES[i] == name then table.remove(CARPET_NAMES, i) end
    end
    table.insert(CARPET_NAMES, 1, name)
end
_G.StickySetCarpetTool = setCarpetTool
if type(_G.StickyCarpetTool) == "string" and _G.StickyCarpetTool ~= "" then
    setCarpetTool(_G.StickyCarpetTool)
end
_carpetEngaging = false
function carpetEngage(force)
    if not force then
        local c = LP.Character
        if c then
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then
                    _G.TPEngage = "carpet=" .. tostring(n)
                    return n
                end
            end
        end
    end
    if _carpetEngaging then
        local _tw = os.clock()
        repeat RunService.Heartbeat:Wait() until (not _carpetEngaging) or os.clock() - _tw > 6
        local c = LP.Character
        if c then
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then return n end
            end
        end
    end
    _carpetEngaging = true
    local _t0 = os.clock()
    while not findTool("Grapple Hook") and os.clock() - _t0 < (tonumber(_G.StickyGrappleToolWait) or 5) do
        RunService.Heartbeat:Wait()
    end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then _carpetEngaging = false; return nil end

    if not char:FindFirstChild("Grapple Hook") then
        local g = findTool("Grapple Hook")
        if g then pcall(function() hum:EquipTool(g) end) end
    end
    local _te = os.clock()
    while not (LP.Character and LP.Character:FindFirstChild("Grapple Hook")) and os.clock() - _te < 1.5 do
        local c = LP.Character
        local h2 = c and c:FindFirstChildOfClass("Humanoid")
        local g = findTool("Grapple Hook")
        if g and h2 then pcall(function() h2:EquipTool(g) end) end
        RunService.Heartbeat:Wait()
    end
    if LP.Character and LP.Character:FindFirstChild("Grapple Hook") then
        (function()
            if type(_G.StickyFireGrapple2) == "function" then
                return _G.StickyFireGrapple2()
            elseif type(fireGrapple) == "function" then
                return fireGrapple()
            end
            return false
        end)()
    end
    task.wait(0.06)
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h:UnequipTools() end) end
    task.wait(0.04)
    local cn
    local _tc = os.clock()
    repeat
        cn = equipCarpet()
        local c = LP.Character
        if cn and c and c:FindFirstChild(cn) then break end
        RunService.Heartbeat:Wait()
    until os.clock() - _tc > 0.5
    _G.TPEngage = "carpet=" .. tostring(cn)
    _carpetEngaging = false
    return cn
end

_G.StickyEquipCarpet = equipCarpet
_G.StickyCarpetEngaging = function() return _carpetEngaging end

if _G.StickyKeepCarpet == nil then _G.StickyKeepCarpet = true end
LP.CharacterAdded:Connect(function(c)
    if _G.StickyKeepCarpet == false then return end
    task.spawn(function()
        c:WaitForChild("Humanoid", 10)
        task.wait(tonumber(_G.StickyCarpetRespawnDelay) or 0.6)
        if _G.StickyKeepCarpet == false then return end
        if _carpetEngaging or LP.Character ~= c then return end
        if LP:GetAttribute("Stealing") == true then return end
        for _, n in ipairs(CARPET_NAMES) do
            if c:FindFirstChild(n) then return end
        end
        pcall(equipCarpet)
    end)
end)

PET_PRIORITY_TIERS = {
    [1] = { pets = {"Headless Horseman"}, threshold = 0 },
    [2] = { pets = {"Signore Carapace"}, threshold = 0 },
    [3] = { pets = {"John Pork"}, threshold = 0 },
    [4] = { pets = {"Strawberry Elephant"}, threshold = 0 },
    [5] = { pets = {"Arcadragon"}, threshold = 5e9 },
    [6] = { pets = {"Elefanto Frigo"}, threshold = 10e9 },
    [7] = { pets = {"Meowl"}, threshold = 5e9 },
    [8] = { pets = {"Skibidi Toilet"}, threshold = 5e9 },
    [9] = { pets = {"Love Love Bear"}, threshold = 0 },
    [10] = { pets = {"Antonio"}, threshold = 0 },
    [11] = { pets = {"Pancake and Syrup"}, threshold = 0 },
    [12] = { pets = {"Griffin"}, threshold = 0 },
    [13] = { pets = {"Globa Steppa","La Supreme Combinasion","Fishino Clownino","Dragon Gingerini","Tirilikalika Tirilikalako"}, threshold = 5e9 },
    [14] = { pets = {"Ginger Gerat","Pet"}, threshold = 10e9 },
    [15] = { pets = {"Hydra Bunny","Digi Narwhal","Kalika Bros"}, threshold = 3e9 },
    [16] = { pets = {"Hydra Dragon Cannelloni","Dragon Cannelloni","Bunny and Eggy"}, threshold = 3e9 },
    [17] = { pets = {"Ketupat Bros","Rosey and Teddy","La Casa Boo","Fragola la la"}, threshold = 3e9 },
    [18] = { pets = {"Fragola La La La","Cerberus","Guest 666","Los Hackers"}, threshold = 1e9 },
    [19] = { pets = {"Garama and Madunung","Spooky and Pumpky","Reinito Sleighito","Burguro And Fryuro","Cooki and Milki","Fragrama and Chocrama","La Food Combinasion","Los Amigos","Foxini Lanternini","Capitano Moby","Fortunu and Cashuru","Los Sekolahs","Celestial Pegasus"}, threshold = 750e6 },
    [20] = { pets = {"La Secret Combinasion","Sammyni Fattini","Cloverat Clapat","Popcuru and Fizzuru"}, threshold = 1e9 },
}

TIER_LOOKUP = {}
for tier, data in pairs(PET_PRIORITY_TIERS) do
    for _, name in ipairs(data.pets) do TIER_LOOKUP[name] = tier end
end

LOCKED_TIERS = { [1]=true, [2]=true, [3]=true, [4]=true }

DIRECT_THRESHOLDS = {
    [3] = { [4] = 10e9 },
    [4] = {},
    [5] = { [6] = math.huge },
    [6] = { [9] = math.huge, [10] = math.huge, [12] = 15e9 },
    [10] = { [12] = 20e9 },
    [11] = { [12] = 10e9 },
}

MUTATION_PRIORITY = {
    ["Galaxy"]=1,["Candy"]=1,["Yin Yang"]=1,["YinYang"]=1,["Divine"]=1,
    ["Cursed"]=1,["Lava"]=1,["Radioactive"]=1,["Cyber"]=1,["Rainbow"]=1,["Bloodrot"]=2,
}

TRAIT_PRIORITY = {}

MUTATION_ICONS, TRAIT_ICONS = {}, {}

function _StickyLoadGameData()
    local ok1, mData = pcall(function() return require(game.ReplicatedStorage.Datas.Mutations) end)
    if ok1 and type(mData) == "table" then
        local mList = {}
        for name, data in pairs(mData) do
            if type(data) == "table" then
                MUTATION_ICONS[name] = data.Icon
                mList[#mList + 1] = name
            end
        end
        table.sort(mList)
        if #_G.SHARED_MUTATION_PRIORITY == 0 then
            for i = 1, #mList do _G.SHARED_MUTATION_PRIORITY[i] = mList[i] end
        end
    end
    local ok2, tData = pcall(function() return require(game.ReplicatedStorage.Datas.Traits) end)
    if ok2 and type(tData) == "table" then
        local tList = {}
        for name, data in pairs(tData) do
            if type(data) == "table" then
                TRAIT_ICONS[name] = data.Icon
                tList[#tList + 1] = name
            end
        end
        table.sort(tList)
        if #_G.SHARED_TRAIT_PRIORITY == 0 then
            for i = 1, #tList do _G.SHARED_TRAIT_PRIORITY[i] = tList[i] end
        end
    end
end

task.spawn(function()
    pcall(function()
        local Datas = game:GetService("ReplicatedStorage"):FindFirstChild("Datas")
        local a = Datas and Datas:FindFirstChild("Animals")
        if a and not AnimalsData then AnimalsData = require(a) end
        if AnimalsData then _StickyBuildDefaultBrainrotPriority() end
    end)
    pcall(_StickyLoadGameData)
end)

function getMutPrio(m)
    if not m or m == "" or m == "None" then return 0 end
    local n = tostring(m)
    local dis = _G.SHARED_MUTATION_DISABLED
    if type(dis) == "table" and (dis[n] or dis[_normName(n)]) then return 0 end
    local idx = _priIndexOfMut(n)
    if not idx then
        n = n:lower():gsub("[%s%-_]","")
        idx = _priIndexOfMut(n)
    end
    if idx then return 999 - idx end
    if MUTATION_PRIORITY[m] then return MUTATION_PRIORITY[m] end
    if MUTATION_PRIORITY[n] then return MUTATION_PRIORITY[n] end
    return 0
end

function getTraitPrio(t)
    if not t or t == "" then return 0 end
    local name = type(t) == "table" and t.name or tostring(t)
    local n = name
    local idx = _priIndexOfTrait(n)
    if not idx then
        n = n:lower():gsub("[%s%-_]","")
        idx = _priIndexOfTrait(n)
    end
    if idx then return 999 - idx end
    if TRAIT_PRIORITY[name] then return TRAIT_PRIORITY[name] end
    if TRAIT_PRIORITY[n] then return TRAIT_PRIORITY[n] end
    return 0
end

function getCumThreshold(hi, lo)
    if DIRECT_THRESHOLDS[hi] and DIRECT_THRESHOLDS[hi][lo] then return DIRECT_THRESHOLDS[hi][lo] end
    if LOCKED_TIERS[hi] then return math.huge end
    local total = 0
    for t = hi + 1, lo do
        local td = PET_PRIORITY_TIERS[t]
        if td and td.threshold > 0 then total = total + td.threshold end
    end
    return total
end

function _normName(s)
    return tostring(s):lower():gsub("[%s%-_'%.]", "")
end
_priCacheVer, _priCache = -1, {}
_brainrotDefaultPri = {}
_brainrotDefaultRarity = {}
_mutPriCacheVer, _mutPriCache = -1, {}
_traitPriCacheVer, _traitPriCache = -1, {}

function _priLookup(listName)
    local ver = _G.StickyPriVersion or 0
    if listName == "mutation" then
        if _mutPriCacheVer ~= ver then
            table.clear(_mutPriCache)
            local plist = _G.SHARED_MUTATION_PRIORITY
            if type(plist) == "table" then
                for i = #plist, 1, -1 do _mutPriCache[_normName(plist[i])] = i end
            end
            _mutPriCacheVer = ver
        end
        return _mutPriCache
    elseif listName == "trait" then
        if _traitPriCacheVer ~= ver then
            table.clear(_traitPriCache)
            local plist = _G.SHARED_TRAIT_PRIORITY
            if type(plist) == "table" then
                for i = #plist, 1, -1 do _traitPriCache[_normName(plist[i])] = i end
            end
            _traitPriCacheVer = ver
        end
        return _traitPriCache
    else
        if _priCacheVer ~= ver then
            table.clear(_priCache)
            local plist = _G.SHARED_PRIORITY_ITEMS
            if type(plist) == "table" then
                for i = #plist, 1, -1 do _priCache[_normName(plist[i])] = i end
            end
            _priCacheVer = ver
        end
        return _priCache
    end
end
_G.StickyPriLookup = function() return _priLookup() end
function _priIndexOf(name)
    if not name then return nil end
    local n = _normName(name)
    local idx = _priLookup()[n]
    if idx then return idx end
    local def = _brainrotDefaultPri[n]
    if def and _brainrotDefaultRarity[n] == "OG" then
        return def * 0.001
    end
    return nil
end
function _priIndexOfMut(name)
    if not name then return nil end
    return _priLookup("mutation")[_normName(name)]
end
function _priIndexOfTrait(name)
    if not name then return nil end
    return _priLookup("trait")[_normName(name)]
end

function petOutranks(aName, bName, aMut, bMut, aMPS, bMPS, aTraits, bTraits)
    local iA = _priIndexOf(aName)
    local iB = _priIndexOf(bName)
    if iA ~= nil and iB ~= nil then
        if iA ~= iB then return iA < iB end
    end
    if (iA ~= nil) ~= (iB ~= nil) then return iA ~= nil end
    if iA == nil and iB == nil then
        if (aMPS or 0) ~= (bMPS or 0) then return (aMPS or 0) > (bMPS or 0) end
    end
    local ma, mb = getMutPrio(aMut), getMutPrio(bMut)
    if ma ~= mb then return ma > mb end
    if type(aTraits) == "table" and type(bTraits) == "table" then
        local pa, pb = 0, 0
        for _, t in ipairs(aTraits) do pa = math.max(pa, getTraitPrio(t)) end
        for _, t in ipairs(bTraits) do pb = math.max(pb, getTraitPrio(t)) end
        if pa ~= pb then return pa > pb end
    end
    return (aMPS or 0) > (bMPS or 0)
end

function getPlotChannel(plotName)
    local channel
    pcall(function() channel = _G.StickySyncGet(plotName) end)
    return channel
end

function channelGet(channel, key)
    if not channel then return nil end
    local ok, v = pcall(function()
        local ct = rawget(channel, "CacheTable")
        if type(ct) == "table" then
            local r = rawget(ct, key)
            if r ~= nil then return r end
        end
        local d = rawget(channel, "Data")
        if type(d) == "table" then
            local r = rawget(d, key)
            if r ~= nil then return r end
        end
        return rawget(channel, key)
    end)
    if ok then return v end
    return nil
end

function _ownerIsMe(owner)
    if not owner then return false end
    local result = false
    pcall(function()
        if typeof(owner) == "Instance" and owner:IsA("Player") then
            result = owner.UserId == LP.UserId
        elseif type(owner) == "table" and owner.UserId then
            result = owner.UserId == LP.UserId
        elseif typeof(owner) == "Instance" then
            result = owner == LP
        elseif type(owner) == "string" then
            result = owner:lower() == LP.Name:lower()
                or owner:lower() == (LP.DisplayName or LP.Name):lower()
        end
    end)
    return result
end

function isMyPlot(channel)
    if not channel then return false end
    return _ownerIsMe(channelGet(channel, "Owner"))
end

_ownerInGameCache, _ownerInGameAt = {}, {}
function _ownerInGame(owner)
    if not owner then return false end
    local cacheKey
    if typeof(owner) == "Instance" then cacheKey = "i:" .. tostring(owner)
    elseif type(owner) == "number" then cacheKey = "n:" .. owner
    elseif type(owner) == "string" then cacheKey = "s:" .. owner:lower()
    else cacheKey = "o:" .. tostring(owner) end
    local now = os.clock()
    local cached = _ownerInGameAt[cacheKey]
    if cached and (now - cached.t) < 2 then return cached.v end
    local inGame = false
    pcall(function()
        if typeof(owner) == "Instance" and owner:IsA("Player") then
            inGame = owner.Parent == Players
        elseif type(owner) == "number" then
            inGame = Players:GetPlayerByUserId(owner) ~= nil
        elseif type(owner) == "table" and owner.Name then
            inGame = Players:FindFirstChild(tostring(owner.Name)) ~= nil
        elseif typeof(owner) == "Instance" and owner.Name then
            inGame = Players:FindFirstChild(owner.Name) ~= nil
        elseif type(owner) == "string" then
            if Players:FindFirstChild(owner) then
                inGame = true
            else
                local lo = owner:lower()
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl.Name:lower() == lo or (pl.DisplayName or ""):lower() == lo then inGame = true break end
                end
            end
        end
    end)
    _ownerInGameCache[cacheKey] = { v = inGame, t = now }
    _ownerInGameAt[cacheKey] = { v = inGame, t = now }
    return inGame
end

function ownerInGame(channel)
    if not channel then return false end
    return _ownerInGame(channelGet(channel, "Owner"))
end

_petModelCache = setmetatable({}, { __mode = "v" })
_genCache = {}

local _MPS_SUFFIX = { K = 1e3, M = 1e6, B = 1e9, T = 1e12, Q = 1e15 }
_wmpsCache, _wmpsAt = {}, {}
function _worldMPS(plot, slot)
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    local podium = podiums and podiums:FindFirstChild(tostring(slot))
    if not podium then return nil end

    local _ck = plot.Name .. "\0" .. tostring(slot)
    local _now = os.clock()
    if _wmpsAt[_ck] and (_now - _wmpsAt[_ck]) < (tonumber(_G.StickyWorldMPSTTL) or 1) then
        return _wmpsCache[_ck]
    end
    local best = nil
    local function _scanLabels(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                local txt = child.Text
                if type(txt) == "string" and txt ~= "" then
                    local num, suf = txt:match("%$%s*([%d%.]+)%s*([KMBTQ]?)%s*/s")
                    if num then
                        local v = tonumber(num)
                        if v then
                            v = v * (_MPS_SUFFIX[suf] or 1)
                            if not best or v > best then best = v end
                        end
                    end
                end
            end
            _scanLabels(child)
        end
    end
    _scanLabels(podium)
    _wmpsCache[_ck], _wmpsAt[_ck] = best, _now
    return best
end
function getPetPosition(plot, slot, strict)
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(tostring(slot))
    if not podium then return nil end

    local key = plot.Name .. "\0" .. tostring(slot)
    local cached = _petModelCache[key]
    if cached and cached.Parent and cached:IsDescendantOf(podium) then
        local ok, cf = pcall(function() return cached:GetBoundingBox() end)
        if ok then return cf.Position end
    end
    _petModelCache[key] = nil

    local _skipNames = { Claim = true, Base = true, Decorations = true }
    local function _findModel(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Model") and not _skipNames[child.Name] then
                if child:FindFirstChildWhichIsA("MeshPart", true) then
                    return child
                end
            end
            local found = _findModel(child)
            if found then return found end
        end
        return nil
    end

    local model = _findModel(podium)
    if model then
        local ok, cf = pcall(function() return model:GetBoundingBox() end)
        if ok then
            _petModelCache[key] = model
            return cf.Position
        end
    end

    if strict then return nil end
    local ok, cf = pcall(function() return podium:GetPivot() end)
    if ok then return cf.Position end
    return podium.Position
end

function scanAllPets()
    local pets = {}
    if not loadModules() then
        _G.StickyScanTotal, _G.StickyScanUsed, _G.StickyScanNoChan = 0, 0, 8
        return pets
    end

    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then
        _G.StickyScanTotal, _G.StickyScanUsed, _G.StickyScanNoChan = 0, 0, 8
        return pets
    end

    local _mkSeen, _mkUse, _mkTotal = 0, 0, 0
    local _mkNoChan = 0
    local _mkTags = {}
    for _, plot in ipairs(Plots:GetChildren()) do
        _mkTotal = _mkTotal + 1
        local channel = getPlotChannel(plot.Name)
        if not channel then _mkTags[#_mkTags + 1] = "nochan" _mkNoChan = _mkNoChan + 1 continue end
        _mkSeen = _mkSeen + 1
        local owner = channelGet(channel, "Owner")
        if _ownerIsMe(owner) then _G.StickyMyPlot = plot.Name _mkTags[#_mkTags + 1] = "MINE" continue end
        if _G.StickyMyPlot == plot.Name then _mkTags[#_mkTags + 1] = "MINE" continue end
        if not _G.StickyMyPlot and owner == nil then _mkTags[#_mkTags + 1] = "noowner?" continue end
        if _G.StickyRequireOwner ~= false and not _ownerInGame(owner) then _mkTags[#_mkTags + 1] = "left" continue end
        _mkUse = _mkUse + 1

        local animalList = channelGet(channel, "AnimalList")
        if not animalList then _mkTags[#_mkTags + 1] = "nolist" continue end
        local _mkPlotN = 0

        for slot, animalData in pairs(animalList) do
            if type(animalData) ~= "table" then continue end
            local animalName = animalData.Index
            if not animalName then continue end
            local animalInfo = AnimalsData and AnimalsData[animalName]
            if not animalInfo and _G.StickyRequireKnown == true then continue end
            if _StickyIsFusing(animalData) then continue end

            local mutation = animalData.Mutation or "None"
            local traits = animalData.Traits
            if type(traits) ~= "table" then traits = {} end

            local genValue
            local _gk = plot.Name .. "\0" .. tostring(slot)
            local _gc = _genCache[_gk]
            if _gc and _gc.n == animalName and _gc.m == animalData.Mutation and _gc.t == animalData.Traits then
                genValue = _gc.g
            else
                genValue = 0
                pcall(function()
                    local shim = AnimalsShared or _G.StickyAnimShim
                    if shim then genValue = shim:GetGeneration(animalName, animalData.Mutation, animalData.Traits, nil) end
                end)
                if genValue and genValue > 0 then
                    _genCache[_gk] = { n = animalName, m = animalData.Mutation, t = animalData.Traits, g = genValue }
                end
            end
            if (not genValue or genValue <= 0) and _G.StickyWorldMPS ~= false then
                local wm = _worldMPS(plot, slot)
                if wm and wm > 0 then genValue = wm end
            end

            local displayName = (animalInfo and animalInfo.DisplayName) or animalName

            local pos = getPetPosition(plot, slot, (_G.StickyRequireOwner == false) or (_G.StickyRequireModel == true))

            if pos then
                if genValue >= (tonumber(_G.StickyMinMPS) or 0) then
                    table.insert(pets, {
                        name = displayName,
                        index = animalName,
                        mps = genValue,
                        mutation = mutation,
                        traits = traits,
                        position = pos,
                        plot = plot.Name,
                        slot = tostring(slot),
                    })
                    _mkPlotN = _mkPlotN + 1
                end
            end
        end
        _mkTags[#_mkTags + 1] = tostring(_mkPlotN)
    end

    _G.StickyScanTotal, _G.StickyScanUsed, _G.StickyScanNoChan = _mkTotal, _mkUse, _mkNoChan
    _G.StickyScanInfo = string.format("plots %d scanned of %d  pets %d  [%s]  %s", _mkUse, _mkTotal, #pets, table.concat(_mkTags, " "), tostring(_G.StickyScanMode))
    local function _bestTraitPrio(traits)
        if type(traits) ~= "table" then return 0 end
        local best = 0
        for _, t in ipairs(traits) do
            local p = getTraitPrio(t)
            if p > best then best = p end
        end
        return best
    end

    for _, p in ipairs(pets) do
        p._pri = _priIndexOf(p.name) or (p.index and _priIndexOf(p.index)) or nil
        p._mp = tonumber(p.mps) or 0
        p._mut = getMutPrio(p.mutation)
        p._trait = _bestTraitPrio(p.traits)
    end

    local function _petOrder(a, b)
        local ia, ib = a._pri, b._pri
        if (ia ~= nil) ~= (ib ~= nil) then return ia ~= nil end
        if ia and ib and ia ~= ib then return ia < ib end
        if ia == nil then
            if a._mp ~= b._mp then return a._mp > b._mp end
        end
        if a._mut ~= b._mut then return a._mut > b._mut end
        if a._trait ~= b._trait then return a._trait > b._trait end
        if a._mp ~= b._mp then return a._mp > b._mp end
        local pa, pb = tostring(a.plot), tostring(b.plot)
        if pa ~= pb then return pa < pb end
        return (tonumber(a.slot) or 0) < (tonumber(b.slot) or 0)
    end

    local mode = _G.StickyStealMode
    if mode == "highest" then
        table.sort(pets, function(a, b)
            local ma, mb = tonumber(a.mps) or 0, tonumber(b.mps) or 0
            if ma ~= mb then return ma > mb end
            local pa, pb = tostring(a.plot), tostring(b.plot)
            if pa ~= pb then return pa < pb end
            return (tonumber(a.slot) or 0) < (tonumber(b.slot) or 0)
        end)
        return pets
    end

    table.sort(pets, _petOrder)

    return pets
end
_G.StickyScanAllPets = scanAllPets

_scanShared, _scanSharedAt = nil, 0
function scanAllPetsCached(maxAge)
    local now = os.clock()
    if _scanShared and (now - _scanSharedAt) <= (tonumber(maxAge) or 0.15) then
        return _scanShared
    end
    local ok, p = pcall(scanAllPets)
    if ok and type(p) == "table" then
        _scanShared, _scanSharedAt = p, now
        return p
    end
    return nil
end
_G.StickyScanCached = scanAllPetsCached

function scanForTP()

    local inBoot = _gameLoadAt and (os.clock() - _gameLoadAt) < 4
    local full = scanAllPetsCached(tonumber(_G.StickyScanCacheAge) or (inBoot and 0.1 or 0.2))
    if type(full) ~= "table" then full = {} end
    if _G.StickyScanTiered and _G.StickyUseTiered ~= false then
        local ok, tiered = pcall(_G.StickyScanTiered)
        if ok and type(tiered) == "table" and #tiered > 0 then
            local seen = {}
            for _, p in ipairs(full) do
                if p and p.plot and p.slot ~= nil then
                    seen[tostring(p.plot) .. "_" .. tostring(p.slot)] = true
                end
            end
            for _, p in ipairs(tiered) do
                if p and p.plot and p.slot ~= nil then
                    local uid = tostring(p.plot) .. "_" .. tostring(p.slot)
                    if not seen[uid] then
                        seen[uid] = true
                        full[#full + 1] = p
                    end
                end
            end
        end
    end
    return full
end

function _petUid(p)
    if not p then return nil end
    return tostring(p.plot) .. "_" .. tostring(p.slot)
end
function _pickPetOnFoot(pets, myPos)
    if not pets or #pets == 0 then return nil end
    local best
    if _G.StickyStealMode == "nearest" and myPos then
        local bestD = math.huge
        for _, p in ipairs(pets) do
            if not p.conveyor and p.position then
                local d = (p.position - myPos).Magnitude
                if d < bestD then bestD = d; best = p end
            end
        end
    else
        for _, p in ipairs(pets) do
            if not p.conveyor then best = p; break end
        end
    end
    return best or pets[1]
end
function _findTPSyncedPet(pets)
    local uid = _G.StickyStealTargetUID
    if type(uid) ~= "string" or uid == "" then return nil end
    for _, p in ipairs(pets) do
        if _petUid(p) == uid then return p end
    end
    return nil
end
function _clearTPSync()
    _G.StickyTPSyncActive = false
    _G.StickyStealTargetUID = nil
    _G.StickyStealTarget = nil
end
function _armTPSync(pet)
    if not pet then return end
    _G.StickyStealTargetUID = _petUid(pet)
    _G.StickyStealTarget = pet
    _G.StickyTPSyncActive = true
    local gen = (_G._StickyTPSyncGen or 0) + 1
    _G._StickyTPSyncGen = gen
    task.delay(12, function()
        if _G._StickyTPSyncGen == gen then _clearTPSync() end
    end)
end
_G.StickyClearTPSync = _clearTPSync
function _findStealTarget(pets)
    if not _G.StickyTPSyncActive then return nil end
    return _findTPSyncedPet(pets)
end
function _publishStealTarget(pet)
    if not pet then return end
    _G.StickyStealTargetUID = _petUid(pet)
    _G.StickyStealTarget = pet
end

MK_UPPER = {
    B = {{coord=Vector3.new(-487.921448,16.850713,-75.768013),facing="NORTH"},{coord=Vector3.new(-332.379730,16.850722,-75.762100),facing="NORTH"},{coord=Vector3.new(-487.134918,16.850713,-18.094154),facing="SOUTH"},{coord=Vector3.new(-316.300171,16.850713,-17.845898),facing="SOUTH"}},
    C = {{coord=Vector3.new(-330.765381,16.850713,31.424425),facing="NORTH"},{coord=Vector3.new(-502.989349,16.850713,31.172430),facing="NORTH"},{coord=Vector3.new(-489.077087,16.850713,89.010147),facing="SOUTH"},{coord=Vector3.new(-330.908936,16.850713,88.930145),facing="SOUTH"}},
    D = {{coord=Vector3.new(-331.264893,16.850713,138.209167),facing="NORTH"},{coord=Vector3.new(-487.935181,16.850713,138.026321),facing="NORTH"},{coord=Vector3.new(-487.774933,16.850713,195.882538),facing="SOUTH"},{coord=Vector3.new(-330.799133,16.850575,196.022354),facing="SOUTH"}},
}
MK_LOWER = {
    B = {{coord=Vector3.new(-335.725586,-3.048217,-74.984589),facing="NORTH"},{coord=Vector3.new(-503.214233,-3.048217,-75.043137),facing="NORTH"},{coord=Vector3.new(-483.619385,-3.718430,-18.844337),facing="SOUTH"},{coord=Vector3.new(-316.147095,-3.048218,-18.818844),facing="SOUTH"}},
    C = {{coord=Vector3.new(-335.985413,-3.048218,32.051426),facing="NORTH"},{coord=Vector3.new(-503.277008,-3.048217,31.956175),facing="NORTH"},{coord=Vector3.new(-483.749390,-3.048218,88.147003),facing="SOUTH"},{coord=Vector3.new(-315.793823,-3.048217,88.163979),facing="SOUTH"}},
    D = {{coord=Vector3.new(-335.476654,-3.048218,139.001083),facing="NORTH"},{coord=Vector3.new(-503.710083,-3.048218,138.989883),facing="NORTH"},{coord=Vector3.new(-315.654938,-3.048218,195.302444),facing="SOUTH"},{coord=Vector3.new(-483.859253,-3.048218,195.269043),facing="SOUTH"}},
}
UPPER_Y_THRESHOLD = 7
TALL_PETS = { ["La Secret Combinasion"]=true, ["La Jolly Grande"]=true }
TALL_OFFSET = 3

BASES_LOW = {
    [1] = Vector3.new(-476.52, -2, 220.94090270996094),
    [2] = Vector3.new(-476.52, -2, 113.77315521240234),
    [3] = Vector3.new(-476.52, -2, 6.178487777709961),
    [4] = Vector3.new(-476.52, -2, -101.07275390625),
    [5] = Vector3.new(-342.66, -2, 221.44737243652344),
    [6] = Vector3.new(-342.66, -2, 113.41409301757812),
    [7] = Vector3.new(-342.66, -2, 6.249461650848389),
    [8] = Vector3.new(-342.66, -2, -99.73458862304688),
}
BASES_HIGH = {
    [1] = Vector3.new(-479.51, 18, 220.94090270996094),
    [2] = Vector3.new(-479.51, 18, 113.77315521240234),
    [3] = Vector3.new(-479.51, 18, 6.178487777709961),
    [4] = Vector3.new(-479.51, 18, -101.07275390625),
    [5] = Vector3.new(-339.48, 18, 221.44737243652344),
    [6] = Vector3.new(-339.48, 18, 113.41409301757812),
    [7] = Vector3.new(-339.48, 18, 6.249461650848389),
    [8] = Vector3.new(-339.48, 18, -99.73458862304688),
}
FRONT_Y_LOW   = -3.048217
FRONT_Y_HIGH  = 16.850713
COLUMN_SPLIT_X = -410
FRONT_Z_CLAMP  = 18
SIDE_NEAR_Z    = 45

function getClosestBaseIdx(pos)
    local closest, dist = 1, math.huge
    for i = 1, 8 do
        local b = BASES_LOW[i]
        local d = (pos.X - b.X)^2 + (pos.Z - b.Z)^2
        if d < dist then dist = d; closest = i end
    end
    return closest
end

function buildFrontCandidate(idx, isUpper, playerZ)
    local base = isUpper and BASES_HIGH[idx] or BASES_LOW[idx]
    local frontY = isUpper and FRONT_Y_HIGH or FRONT_Y_LOW
    local frontZ = math.clamp(playerZ - base.Z, -FRONT_Z_CLAMP, FRONT_Z_CLAMP) + base.Z
    local coord = Vector3.new(base.X, frontY, frontZ)
    local faceDir = (idx <= 4) and Vector3.new(-1, 0, 0) or Vector3.new(1, 0, 0)
    return coord, faceDir
end

function plotSides(coordTable, idx)
    local base = BASES_LOW[idx]
    local isWest = idx <= 4
    local out = {}
    for _, coords in pairs(coordTable) do
        for _, data in ipairs(coords) do
            if ((data.coord.X < COLUMN_SPLIT_X) == isWest)
               and math.abs(data.coord.Z - base.Z) < SIDE_NEAR_Z then
                out[#out + 1] = data
            end
        end
    end
    return out
end

function _floor1LaserSolid(plotName)
    local solid = false
    pcall(function()
        local Plots = workspace:FindFirstChild("Plots")
        local plot = Plots and Plots:FindFirstChild(plotName)
        if not plot then return end
        for _, d in ipairs(plot:GetDescendants()) do
            if d:IsA("BasePart") and (d.Name == "LaserHitbox" or d.Name == "Laser")
                and d.CanCollide and d.Position.Y <= 9 then
                solid = true
                break
            end
        end
    end)
    return solid
end


-- True when a world position overlaps the horizontal footprint of an active laser part.
-- plotName may be nil to test all plots, or a plot name to check only that plot.
local function _stickyPositionNearLaser(position, plotName, padding)
    if typeof(position) ~= "Vector3" then return false end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local pad = math.max(0, tonumber(padding) or 1.5)
    local near = false
    pcall(function()
        for _, plot in ipairs(plots:GetChildren()) do
            if plotName == nil or tostring(plot.Name) == tostring(plotName) then
                for _, part in ipairs(plot:GetDescendants()) do
                    if part:IsA("BasePart")
                        and (part.Name == "LaserHitbox" or part.Name == "Laser")
                        and part.CanCollide then
                        local localPos = part.CFrame:PointToObjectSpace(position)
                        if math.abs(localPos.X) <= part.Size.X * 0.5 + pad
                            and math.abs(localPos.Z) <= part.Size.Z * 0.5 + pad
                            and math.abs(localPos.Y) <= part.Size.Y * 0.5 + math.max(5, pad) then
                            near = true
                            return
                        end
                    end
                end
            end
        end
    end)
    return near
end
_G.StickyPositionNearLaser = _stickyPositionNearLaser

local function _stickyPlotHasActiveLaser(plotName)
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(tostring(plotName or ""))
    if not plot then return false end
    local active = false
    pcall(function()
        for _, part in ipairs(plot:GetDescendants()) do
            if part:IsA("BasePart")
                and (part.Name == "LaserHitbox" or part.Name == "Laser")
                and part.CanCollide then
                active = true
                break
            end
        end
    end)
    return active
end

function isPlotUnlocked(plotName)
    local ok, res = pcall(function()
        local channel = getPlotChannel(plotName)
        if not channel then return false end
        if channelGet(channel, "BlockEndTimeFirstFloor") ~= nil then return false end
        return not _floor1LaserSolid(plotName)
    end)
    return ok and (res == true)
end

function findClosest(petPos, coordTable)
    local best, bestKey, bestDist = nil, nil, math.huge
    for skyKey, coords in pairs(coordTable) do
        for _, data in ipairs(coords) do
            local c = data.coord
            local d = math.sqrt((petPos.X - c.X)^2 + (petPos.Z - c.Z)^2)
            if d < bestDist then bestDist = d; best = data; bestKey = skyKey end
        end
    end
    return best, bestKey
end

do
_vizParts = {}
_vizGen = 0

function _vizEnsure()
    if _vizFolder and _vizFolder.Parent then return end
    _vizFolder = Instance.new("Folder")
    _vizFolder.Name = "StickyPathViz"
    _vizFolder.Parent = workspace
    _vizAnchor = Instance.new("Part")
    _vizAnchor.Name = "Anchor"
    _vizAnchor.Anchored = true; _vizAnchor.CanCollide = false; _vizAnchor.CanQuery = false
    _vizAnchor.CanTouch = false; _vizAnchor.Transparency = 1; _vizAnchor.Size = Vector3.one
    _vizAnchor.CFrame = CFrame.new()
    _vizAnchor.Parent = _vizFolder
end
clearViz = function()
    for i = #_vizParts, 1, -1 do
        local part = _vizParts[i]
        if part and part.Parent then pcall(function() part:Destroy() end) end
        _vizParts[i] = nil
    end
    if _vizAnchor and _vizAnchor.Parent then
        for _, child in ipairs(_vizAnchor:GetChildren()) do pcall(function() child:Destroy() end) end
    end
end
local function _ghost(cf, size, color, op)
    _vizEnsure()
    local a = Instance.new("BoxHandleAdornment")
    a.Adornee = _vizAnchor
    a.AlwaysOnTop = true
    a.ZIndex = 0
    pcall(function() a.Shading = Enum.AdornShading.XRayShaded end)
    a.Color3 = color
    a.Transparency = 1 - op
    a.Size = size
    a.CFrame = cf
    a.Parent = _vizAnchor
end
local function _neon(cf, size, color, ball, transp)
    _vizEnsure()
    local p = Instance.new("Part")
    p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
    p.Material = Enum.Material.Neon; p.Color = color
    p.Transparency = transp or 0
    if ball then p.Shape = Enum.PartType.Ball end
    p.Size = size; p.CFrame = cf; p.Parent = _vizFolder
    _vizParts[#_vizParts + 1] = p
end
function vizLine(a, b, color)
    local d = b - a
    if d.Magnitude < 0.05 then return end
    _neon(CFrame.lookAt((a + b) * 0.5, b), Vector3.new(0.18, 0.18, d.Magnitude), color, false, 0)
    _neon(CFrame.lookAt((a + b) * 0.5, b), Vector3.new(0.40, 0.40, d.Magnitude), color, false, 0.7)
end
function vizDot(pos, color, sz)
    _neon(CFrame.new(pos), Vector3.new(sz, sz, sz), color, true, 0)
end
vizPath = function(fromPos, waypoints)
    if _G.StickyTPTrail ~= true then return end
    if not fromPos or type(waypoints) ~= "table" or #waypoints == 0 then return end
    local LINE = Color3.fromRGB(255, 255, 255)
    local ORB  = Color3.fromRGB(255, 255, 255)
    if type(vizDot) == "function" then
        pcall(vizDot, fromPos, ORB, 1.4)
    end
    local prev = fromPos
    for _, wp in ipairs(waypoints) do
        if typeof(wp) == "Vector3" then
            if type(vizLine) == "function" then
                pcall(vizLine, prev, wp, LINE)
            end
            prev = wp
        end
    end
    if type(vizDot) == "function" and typeof(prev) == "Vector3" then
        pcall(vizDot, prev, ORB, 1.4)
    end
end

end

MK_SPEED = 125
MK_ARRIVE = 3
_STRIP_OK = (type(getconnections) == "function")
function _climbCap()
    local v = math.clamp(tonumber(_G.StickyClimb) or 200, 100, 250)
    if not _STRIP_OK then v = 55 end
    return v
end

function vZero(hrp)
    if hrp then _vzL(hrp); _vzA(hrp) end
end

function _setFlightVel(hrp, vel)
    if hrp and typeof(vel) == "Vector3" and _G.StickyTPBusy == true
        and _G.Sticky_FlingTp == true and vel.Magnitude > 5 then
        local flat = Vector3.new(vel.X, 0, vel.Z)
        if flat.Magnitude > 0.1 then
            local unit = flat.Unit
            local perp = Vector3.new(-unit.Z, 0, unit.X)
            local now = os.clock()
            local amp = math.clamp(tonumber(_G.Sticky_FlingAmp) or 1, 0, 3) * 0.62
            local speed = vel.Magnitude * 0.94
            local slide = ((math.sin(now * 13) * 0.55) + (math.cos(now * 6.5) * 0.35)) * math.min(80, speed * 0.19) * amp
            local wave = ((math.sin(now * 15) * 0.5) + (math.cos(now * 7.5) * 0.32)) * math.min(42, speed * 0.105) * amp
            local pulse = 1 + math.sin(now * 18) * 0.09 * amp
            vel = Vector3.new(unit.X * speed * pulse + perp.X * slide, vel.Y * 0.94 + wave, unit.Z * speed * pulse + perp.Z * slide)
            pcall(function()
                local spinTime = os.clock()
                local spinAmp = math.clamp(tonumber(_G.Sticky_FlingAmp) or 1, 0, 3) * 0.62
                hrp.CFrame = CFrame.new(hrp.Position)
                    * CFrame.Angles(0, (spinTime * 12) % (math.pi * 2), 0)
                    * CFrame.Angles(math.sin(spinTime * 13) * math.rad(30) * spinAmp, 0, (spinTime * 10) % (math.pi * 2))
            end)
        end
    end
    local char = hrp and hrp.Parent
    local part = (char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))) or hrp
    if part then part.AssemblyLinearVelocity = vel end
end

local _cfGen, _cfRunning = 0, false
local function _stickyHybridFaceBack(hrp, target)
    if _G.StickyHybridTP ~= true or not hrp or not hrp.Parent or typeof(target) ~= "Vector3" then return end
    local d = target - hrp.Position
    local flat = Vector3.new(d.X, 0, d.Z)
    if flat.Magnitude < 0.05 then return end
    pcall(function() hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position - flat.Unit) end)
end
_G.StickyHybridFaceBack = _stickyHybridFaceBack

function cframeMoveThrough(hrp, waypoints, hopsOverride)
    if not hrp or not hrp.Parent or not waypoints or #waypoints == 0 then return false end
    _cfGen = _cfGen + 1
    local myGen = _cfGen
    local stepSize = math.clamp(tonumber(_G.StickyCFrameGoSpeed) or tonumber(_G.StickyCFrameStep) or 40, 0.5, 500)
    local stepDelay = math.clamp(tonumber(_G.StickyCFrameDelay) or 0.03, 0.01, 0.2)
    local lagThresh = math.clamp(tonumber(_G.StickyCFrameLagThresh) or 8, 2, 30)
    local MAX_RETRIES = 4
    if type(vizPath) == "function" then pcall(vizPath, hrp.Position, waypoints) end
    local char = hrp.Parent
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
    _cfRunning = true
    local stopConn
    if humanoid and animator then
        pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do track:Stop() end
        end)
        stopConn = humanoid.AnimationPlayed:Connect(function(track)
            pcall(function() track:Stop() end)
        end)
    end
    local target = waypoints[#waypoints]
    local points = {}
    local function fillSteps(from, to)
        local d = to - from
        local segLen = d.Magnitude
        if segLen < 0.1 then return end
        local u = d / segLen
        local walked = 0
        while walked < segLen do
            local s = math.min(stepSize, segLen - walked)
            walked = walked + s
            points[#points + 1] = from + u * walked
        end
    end
    local fullPath = { hrp.Position }
    for i = 1, #waypoints do fullPath[#fullPath + 1] = waypoints[i] end
    if (fullPath[#fullPath] - target).Magnitude > 0.1 then fullPath[#fullPath + 1] = target end
    for i = 1, #fullPath - 1 do fillSteps(fullPath[i], fullPath[i + 1]) end
    if hopsOverride then
        local maxPts = math.clamp(math.floor(tonumber(hopsOverride) or 4), 1, 50)
        if #points > maxPts then
            local trimmed = {}
            for i = 1, maxPts - 1 do
                local idx = math.floor(i * #points / maxPts)
                trimmed[#trimmed + 1] = points[math.max(1, idx)]
            end
            trimmed[#trimmed + 1] = points[#points]
            points = trimmed
        end
    end
    local function yawOf(h)
        local dir = _G.StickyLastFacingDir
        if typeof(dir) == "Vector3" and dir.Magnitude > 0.01 then
            return math.atan2(-dir.X, -dir.Z)
        end
        local _, y = h.CFrame:ToEulerAnglesYXZ()
        return y
    end
    local retries, idx = 0, 1
    local aborted = false
    while idx <= #points and retries < MAX_RETRIES do
        if not _cfRunning or _cfGen ~= myGen or not hrp.Parent then aborted = true; break end
        if _G.StickyTPStop or _G.StickyTPStop then aborted = true; break end
        local tp = points[idx]
        local faceYaw = yawOf(hrp)
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(tp) * CFrame.Angles(0, faceYaw, 0)
            _stickyHybridFaceBack(hrp, target)
        end)
        task.wait(stepDelay)
        if not hrp.Parent then aborted = true; break end
        if (hrp.Position - tp).Magnitude > lagThresh then
            retries = retries + 1
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(tp) * CFrame.Angles(0, faceYaw, 0)
            end)
            task.wait(0.05)
        else
            idx = idx + 1
            retries = 0
        end
    end
    if not aborted and hrp.Parent then
        local faceYaw = yawOf(hrp)
        local function settle()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(target) * CFrame.Angles(0, faceYaw, 0)
        end
        pcall(settle)
        for _ = 1, 3 do
            task.wait()
            if not hrp.Parent or _cfGen ~= myGen then break end
            pcall(settle)
        end
    end
    if stopConn then pcall(function() stopConn:Disconnect() end) end
    if _cfGen == myGen then _cfRunning = false end
    pcall(function()
        if hrp and hrp.Parent then
            hrp.Anchored = false
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end)
    return not aborted
end
_G.StickyCFrameMoveThrough = cframeMoveThrough
_G.StickyCFrameStop = function() _cfRunning = false end

function velMoveThrough(hrp, waypoints, speedOverride, allowJump, quickStart)
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    local _runSpeed = speedOverride or (_G.TPVelocity and math.clamp(_G.TPVelocity, 200, 750)) or CARPET_SPEED
    vizPath(hrp.Position, waypoints)
    local wpIdx = 1
    local done = false
    local conn
    local function finish(snapToEnd)
        if done then return end
        done = true
        _G.__StickyVizFollow = false
        if hrp and hrp.Parent then
            _vzL(hrp)
            _vzA(hrp)
            if snapToEnd then
                local _, y = hrp.CFrame:ToEulerAnglesYXZ()
                hrp.CFrame = CFrame.new(waypoints[#waypoints]) * CFrame.Angles(0, y, 0)
            end
        end
        if conn then conn:Disconnect() end
    end
    local lastDist, stall = math.huge, 0

    local _stStart = os.clock()
    local _lastJump = 0

    local _routeLen = 0
    do
        local _p = hrp.Position
        for _, wp in ipairs(waypoints) do
            _routeLen = _routeLen + (_p - wp).Magnitude
            _p = wp
        end
    end
    local _mayJump = _routeLen >= (tonumber(_G.StickyJumpMinDist) or 100)

    local _ = quickStart

    conn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if not hrp or not hrp.Parent or done then
            if conn then conn:Disconnect() end
            return
        end
        if _G.StickyTPStop then finish(false) return end
        equipCarpet()
        if _mayJump and _G.StickyJumpEachStep ~= false then
            local _now = os.clock()
            if _now - _lastJump >= (tonumber(_G.StickyJumpGap) or 0.2) then
                _lastJump = _now
                local _jh = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if _jh then
                    pcall(function() _jh:ChangeState(Enum.HumanoidStateType.Jumping) end)
                    pcall(function() _jh.Jump = true end)
                end
            end
        end
        local target = waypoints[wpIdx]
        local diff = target - hrp.Position
        local mag = diff.Magnitude
        local _spd = _runSpeed
        if _G.StickyHybridTP == true then
            local ramp = math.clamp(mag / 42, 0.35, 1)
            _spd = _runSpeed * (0.55 + ramp * 0.45)
        end
        if wpIdx < #waypoints and mag < 26 then
            local nxt = waypoints[wpIdx + 1]
            local b = nxt - target
            if mag > 0.1 and b.Magnitude > 0.1 and diff.Unit:Dot(b.Unit) < 0.9 then
                _spd = math.min(_spd, 240)
            end
        end
        local _arr = math.max(MK_ARRIVE, _spd / 60 * 1.25)
        if mag < _arr then
            wpIdx = wpIdx + 1
            if wpIdx > #waypoints then finish(true) return end
            lastDist, stall = math.huge, 0
            if _G.StickyZeroEachStep ~= false and _vzOK() then
                pcall(function()
                    local _v = hrp.AssemblyLinearVelocity
                    local _keepY = (_G.StickyZeroStepKeepY == false) and 0 or math.max(_v.Y, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, _keepY, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end
            if _mayJump and _G.StickyJumpEachStep ~= false then
                local _wh = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if _wh then
                    _lastJump = os.clock()
                    pcall(function() _wh:ChangeState(Enum.HumanoidStateType.Jumping) end)
                    pcall(function() _wh.Jump = true end)
                end
            end
            target = waypoints[wpIdx]
            diff = target - hrp.Position
            mag = diff.Magnitude
        end

        if mag > lastDist - 0.05 then stall = stall + 1 else stall = 0 end
        lastDist = mag
        if stall >= (tonumber(_G.StickyStallFrames) or 18) then finish(false) return end

        if mag >= 0.1 then
            local dir = diff.Unit
            if (allowJump or diff.Y > 10) and diff.Y > 5 and wpIdx < #waypoints then
                local hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if hum then
                    local st = hum:GetState()
                    if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() hum.Jump = true end)
                    end
                end
            end
            local _sp = _spd
            local _mc = _climbCap()
            if dir.Y > 0 and dir.Y * _sp > _mc then
                _sp = _mc / dir.Y
            end
            _setFlightVel(hrp, Vector3.new(dir.X * _sp, dir.Y * _sp, dir.Z * _sp))
            if _G.StickySpinTP == true then
                local spinPosition = hrp.Position
                local spinYaw = (os.clock() * (tonumber(_G.StickySpinRate) or 22)) % (math.pi * 2)
                pcall(function() hrp.CFrame = CFrame.new(spinPosition) * CFrame.Angles(0, spinYaw, 0) end)
            end
            _stickyHybridFaceBack(hrp, target)
        end
    end))

    local totalDist = 0
    do
        local prev = hrp.Position
        for _, wp in ipairs(waypoints) do
            totalDist = totalDist + (prev - wp).Magnitude
            prev = wp
        end
    end
    local timeout = totalDist / math.min(MK_SPEED, _runSpeed) + (tonumber(_G.StickyFlightGrace) or 2)
    local elapsed = 0
    while not done and elapsed < timeout do
        task.wait(0.05)
        elapsed = elapsed + 0.05
        if not (hrp and hrp.Parent) then break end
    end
    finish(false)
    vZero(hrp)
end

_OTHER_CLONES = {}
do
    local _MY_CLONE = tostring(LP.UserId) .. "_Clone"
    local _seen = {}
    local function _isOtherClone(inst)
        if not inst then return false end
        local n = inst.Name
        if n == _MY_CLONE then return false end
        if n:match("^%d+_Clone$") then return true end
        if not n:find("lone", 1, true) then return false end
        if not inst:IsA("Model") then return false end
        if inst == LP.Character then return false end
        if not inst:FindFirstChild("HumanoidRootPart") then return false end
        if not inst:FindFirstChildOfClass("Humanoid") then return false end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Character == inst then return false end
        end
        return true
    end
    local function _neutralize(inst)
        if not inst or _seen[inst] then return end
        _seen[inst] = true
        _OTHER_CLONES[#_OTHER_CLONES + 1] = inst
        local function declaw(d)
            if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
        end
        for _, d in ipairs(inst:GetDescendants()) do declaw(d) end
        inst.DescendantAdded:Connect(declaw)
        inst.Destroying:Connect(function()
            _seen[inst] = nil
            for i = #_OTHER_CLONES, 1, -1 do
                if _OTHER_CLONES[i] == inst then table.remove(_OTHER_CLONES, i); break end
            end
        end)
    end
    local function _scan(inst)
        if _isOtherClone(inst) then _neutralize(inst) end
    end
    for _, c in ipairs(workspace:GetChildren()) do _scan(c) end
    workspace.ChildAdded:Connect(function(c)
        _scan(c)
        task.defer(function() if c and c.Parent == workspace then _scan(c) end end)
    end)
end

do

    local _pSeen = setmetatable({}, { __mode = "k" })
    local _ncBag = setmetatable({}, { __mode = "k" })
    local function _declaw(d)
        if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
    end
    local function _declawChar(char)
        if not char then return end
        for _, d in ipairs(char:GetDescendants()) do _declaw(d) end
        if not _pSeen[char] then
            _pSeen[char] = true
            char.DescendantAdded:Connect(_declaw)
        end
    end

    local _THEIRS = { "HumanoidRootPart", "UpperTorso", "LowerTorso", "Torso", "Head" }
    local function _noCollide(char)
        if not char then return end
        local c = LP.Character
        local mine = c and c:FindFirstChild("HumanoidRootPart")
        if not mine then return end
        local bag = _ncBag[char]
        if not bag or bag.root ~= mine then bag = { root = mine }; _ncBag[char] = bag end
        for _, n in ipairs(_THEIRS) do
            local part = char:FindFirstChild(n)
            if part and part:IsA("BasePart") then
                local nc = bag[n]
                if not (nc and nc.Parent) then
                    pcall(function()
                        local k = Instance.new("NoCollisionConstraint")
                        k.Part0, k.Part1 = mine, part
                        k.Parent = mine
                        bag[n] = k
                    end)
                end
            end
        end
    end
    local _watched = setmetatable({}, { __mode = "k" })
    local _pinHooked = setmetatable({}, { __mode = "k" })
    local function _pin(p)
        if not p:IsA("BasePart") then return end
        if p.CanCollide then p.CanCollide = false end
        if _watched[p] then return end
        _watched[p] = true
        pcall(function()
            p:GetPropertyChangedSignal("CanCollide"):Connect(function()
                if p.CanCollide then p.CanCollide = false end
            end)
        end)
    end
    local function _pinChar(ch)
        if not ch then return end
        for _, d in ipairs(ch:GetDescendants()) do _pin(d) end
        if not _pinHooked[ch] then
            _pinHooked[ch] = true
            ch.DescendantAdded:Connect(function(d) task.defer(_pin, d) end)
        end
    end
    local function _hookPlayer(pl)
        if pl == LP then return end
        if pl.Character then _declawChar(pl.Character); _noCollide(pl.Character); _pinChar(pl.Character) end
        pl.CharacterAdded:Connect(function(c)
            task.wait(0.05)
            _declawChar(c)
            _noCollide(c)
            _pinChar(c)
        end)
    end
    for _, pl in ipairs(Players:GetPlayers()) do _hookPlayer(pl) end
    Players.PlayerAdded:Connect(_hookPlayer)

    LP.CharacterAdded:Connect(function()
        task.wait(0.3)
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP and pl.Character then _noCollide(pl.Character) end
        end
    end)

    local function _pinPlayer(pl)
        if pl == LP then return end
        if pl.Character then _pinChar(pl.Character) end
        pl.CharacterAdded:Connect(function(c) task.wait(0.15) _pinChar(c) end)
    end
    for _, pl in ipairs(Players:GetPlayers()) do _pinPlayer(pl) end
    Players.PlayerAdded:Connect(_pinPlayer)

    local _MY_CLONE_N = tostring(LP.UserId) .. "_Clone"
    local function _clones()
        local t = _OTHER_CLONES
        return (type(t) == "table") and t or {}
    end

    local _ncAcc = 0
    RunService.Stepped:Connect(function(_, dt)
        if _G.StickyNoCollide == false or _G.isCloning == true then return end
        _ncAcc = _ncAcc + (dt or 0.016)
        if _ncAcc < 0.1 then return end
        _ncAcc = 0
        local c = LP.Character
        local myHrp = c and c:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        local mp = myHrp.Position
        local rng = tonumber(_G.StickyNoCollideRange) or 28
        for _, pl in ipairs(Players:GetPlayers()) do
            local ch = (pl ~= LP) and pl.Character
            local h = ch and ch:FindFirstChild("HumanoidRootPart")
            if h and (h.Position - mp).Magnitude <= rng then
                for _, d in ipairs(ch:GetDescendants()) do
                    if d:IsA("BasePart") and d.CanCollide then d.CanCollide = false end
                end
            end
        end
        for _, cl in ipairs(_clones()) do
            if cl and cl.Parent and cl.Name ~= _MY_CLONE_N then
                local h = cl:FindFirstChild("HumanoidRootPart")
                if h and (h.Position - mp).Magnitude <= rng then
                    for _, d in ipairs(cl:GetDescendants()) do
                        if d:IsA("BasePart") and d.CanCollide then d.CanCollide = false end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(1)
            if _G.isCloning ~= true then
                for _, pl in ipairs(Players:GetPlayers()) do
                    local ch = (pl ~= LP) and pl.Character
                    if ch then _pinChar(ch) end
                end
                for _, cl in ipairs(_clones()) do
                    if cl and cl.Parent and cl.Name ~= _MY_CLONE_N then _pinChar(cl) end
                end
            end
        end
    end)
end
local _len
do
local _DIRS = { Vector3.new(1,0,0), Vector3.new(-1,0,0), Vector3.new(0,0,1), Vector3.new(0,0,-1) }
local _STRUCT = { ["structure base home"] = true, ["Wall"] = true, ["Floor"] = true, ["Roof"] = true }
local _SKIP_NAME = { ["DeliveryHitbox"]=true, ["StealHitbox"]=true, ["LaserHitbox"]=true,
    ["AnimalTarget"]=true, ["Multiplier"]=true, ["Laser"]=true, ["Hitbox"]=true,
    ["Spawn"]=true, ["MainRoot"]=true, ["SecondFloor"]=true, ["ThirdFloor"]=true, ["Slope"]=true }
local function _blocks(inst)
    if not inst then return false end
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    local _par = inst.Parent
    if _par and (_par.Name == "ObstacleVolumes" or _par.Name == "ObstacleVolume") then return false end
    if _STRUCT[inst.Name] then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 150 then return true end
    return false
end
local function _blocksWide(inst)
    if not inst then return false end
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    local _par = inst.Parent
    if _par and (_par.Name == "ObstacleVolumes" or _par.Name == "ObstacleVolume") then return false end
    if _STRUCT[inst.Name] then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 30 then return true end
    return false
end
local function _block(origin, target, blockFn)
    blockFn = blockFn or _blocks
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    local o = origin
    for _ = 1, 16 do
        rp.FilterDescendantsInstances = skip
        local d = target - o
        if d.Magnitude < 0.05 then return nil end
        local res = workspace:Raycast(o, d, rp)
        if not res then return nil end
        if blockFn(res.Instance) then return res end
        skip[#skip + 1] = res.Instance
        o = res.Position + d.Unit * 0.3
    end
    return nil
end
local function _clear(a, b) return _block(a, b) == nil end
local function _clearDist(origin, dir, maxD)
    local res = _block(origin, origin + dir.Unit * maxD)
    if not res then return maxD end
    return (res.Position - origin).Magnitude
end
function _len(pts)
    local s, prev = 0, pts[1]
    for k = 2, #pts do s = s + (pts[k] - prev).Magnitude; prev = pts[k] end
    return s
end
local function _pull(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    while i < #pts do
        local j = #pts
        while j > i + 1 and not _clear(out[#out], pts[j]) do j = j - 1 end
        out[#out + 1] = pts[j]
        i = j
    end
    return out
end
local function _stages(toPos)
    local st = {}
    for _, dr in ipairs(_DIRS) do
        local cd = _clearDist(toPos, dr, 46)
        if cd >= 12 then st[#st + 1] = toPos + dr * math.min(cd - 5, 38) end
    end
    return st
end
local function _routeClear(pts)
    for i = 1, #pts - 1 do
        if not _clear(pts[i], pts[i + 1]) then return false end
    end
    return true
end
local function _peakY(pts)
    local m = -math.huge
    for _, p in ipairs(pts) do if p.Y > m then m = p.Y end end
    return m
end
local function _starts(fromPos)
    local pts = { fromPos }
    if _block(fromPos, fromPos + Vector3.new(0, 40, 0)) then
        for _, dr in ipairs(_DIRS) do
            local cd = _clearDist(fromPos, dr, 40)
            if cd >= 12 then pts[#pts + 1] = fromPos + dr * math.min(cd - 5, 34) end
        end
    end
    return pts
end

local function _candidates(sp, stage, toPos)
    local list = {}
    local function add(mid)
        if mid then list[#list + 1] = { sp, mid, stage, toPos }
        else list[#list + 1] = { sp, stage, toPos } end
    end
    add(nil)
    add(Vector3.new(stage.X, sp.Y, stage.Z))
    add(Vector3.new(sp.X, stage.Y, sp.Z))
    local dir = Vector3.new(stage.X - sp.X, 0, stage.Z - sp.Z)
    if dir.Magnitude > 0.1 then
        dir = dir.Unit
        local perp = Vector3.new(-dir.Z, 0, dir.X)
        for _, off in ipairs({ 20, -20, 40, -40 }) do
            add(sp + perp * off)
        end
    end
    return list
end

local PathfindingService = game:GetService("PathfindingService")
local _CLEARANCE = 16
local function _clearWideRay(a, b)
    return _block(a, b, _blocksWide) == nil
end

local _SWEEP_R = 4
local _ENDPOINT_SLACK = 6
local _canSphere = nil
local function _sweepBlockFn(inst)
    if _G.StickyStrictSweep == false then return _blocks(inst) end
    return _blocksWide(inst)
end
local function _sweepDir(a, b)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    local o = a
    for _ = 1, 24 do
        rp.FilterDescendantsInstances = skip
        local d = b - o
        if d.Magnitude < 0.05 then return false end
        local res
        local ok = pcall(function() res = workspace:Spherecast(o, _SWEEP_R, d, rp) end)
        if not ok then _canSphere = false; return nil end
        if not res then return false end
        if _sweepBlockFn(res.Instance) then return true end
        skip[#skip + 1] = res.Instance
        local adv = (res.Distance or 0) - 0.05
        if adv > 0 then o = o + d.Unit * math.min(adv, d.Magnitude) end
    end
    return true
end
local function _sweepBlocked(a, b, slackA, slackB)
    if _canSphere == nil then
        _canSphere = pcall(function()
            workspace:Spherecast(Vector3.new(0, 10000, 0), 1, Vector3.new(0, -1, 0), RaycastParams.new())
        end)
    end
    if not _canSphere then return nil end
    local d = b - a
    local len = d.Magnitude
    if len < 0.1 then return false end
    local u = d / len
    local a2 = a + u * math.min(slackA or _ENDPOINT_SLACK, len * 0.4)
    local b2 = b - u * math.min(slackB or _ENDPOINT_SLACK, len * 0.4)
    local fwd = _sweepDir(a2, b2)
    if fwd == nil then return nil end
    if fwd then return true end
    local rev = _sweepDir(b2, a2)
    if rev == nil then return nil end
    return rev
end

local function _clearWide(a, b, slackA, slackB)
    if not _clear(a, b) then return false end
    local sw = _sweepBlocked(a, b, slackA, slackB)
    if sw ~= nil then return not sw end
    local d = Vector3.new(b.X - a.X, 0, b.Z - a.Z)
    if d.Magnitude < 0.1 then
        local ox = Vector3.new(_CLEARANCE, 0, 0)
        local oz = Vector3.new(0, 0, _CLEARANCE)
        return _clearWideRay(a + ox, b + ox) and _clearWideRay(a - ox, b - ox)
            and _clearWideRay(a + oz, b + oz) and _clearWideRay(a - oz, b - oz)
    end
    local perp = Vector3.new(-d.Z, 0, d.X).Unit * _CLEARANCE
    local up = Vector3.new(0, _CLEARANCE, 0)
    return _clearWideRay(a + perp, b + perp)
        and _clearWideRay(a - perp, b - perp)
        and _clearWideRay(a + up, b + up)
        and _clearWideRay(a - up, b - up)
end

local function _crestClear(a, b)
    if not _clear(a, b) then return false end
    local cl = tonumber(_G.StickyCrestClearance) or 6
    local d = Vector3.new(b.X - a.X, 0, b.Z - a.Z)
    if d.Magnitude < 0.1 then
        return true
    end
    local perp = Vector3.new(-d.Z, 0, d.X).Unit * cl
    return _clearWideRay(a + perp, b + perp)
        and _clearWideRay(a - perp, b - perp)
        and _clearWideRay(a + Vector3.new(0, cl, 0), b + Vector3.new(0, cl, 0))
end

local function _pullWide(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    local n = #pts
    while i < n do
        local j = n
        while j > i + 1 do
            local a, b = out[#out], pts[j]
            local sA = (i == 1) and _ENDPOINT_SLACK or 0
            local sB = (j == n) and _ENDPOINT_SLACK or 0
            if _clearWide(a, b, sA, sB) then break end
            j = j - 1
        end
        out[#out + 1] = pts[j]
        i = j
    end
    return out
end

local function _pushOffWalls(pts)
    if #pts <= 2 then return pts end
    local MARGIN = 8
    local MAX_PUSH = 12
    local out = { pts[1] }
    for i = 2, #pts - 1 do
        local p = pts[i]
        local shift = Vector3.zero
        for _, dr in ipairs(_DIRS) do
            local res = _block(p, p + dr * MARGIN, _blocks)
            if res then
                local dist = (res.Position - p).Magnitude
                if dist < MARGIN then
                    shift = shift - dr * (MARGIN - dist)
                end
            end
        end
        do
            local resUp = _block(p, p + Vector3.new(0, MARGIN, 0), _blocks)
            if resUp then
                local dist = (resUp.Position - p).Magnitude
                if dist < 4 then shift = shift + Vector3.new(0, -(4 - dist), 0) end
            end
        end
        if shift.Magnitude > 0.1 then
            if shift.Magnitude > MAX_PUSH then shift = shift.Unit * MAX_PUSH end
            local moved = p + shift
            if _clear(out[#out], moved) then
                out[#out + 1] = moved
            else
                out[#out + 1] = p
            end
        else
            out[#out + 1] = p
        end
    end
    out[#out + 1] = pts[#pts]
    return out
end

do
local _vxFloor, _vxSqrt = math.floor, math.sqrt
local _vxMin, _vxMax = math.min, math.max
local function _vxAbs(n) return n < 0 and -n or n end

local _vxOverlap = OverlapParams.new()
_vxOverlap.FilterType = Enum.RaycastFilterType.Exclude
_vxOverlap.RespectCanCollide = true

local _vxCast = RaycastParams.new()
_vxCast.FilterType = Enum.RaycastFilterType.Exclude
_vxCast.RespectCanCollide = true
_vxCast.IgnoreWater = true

local _vxOrigin
local _vxDimX, _vxDimY, _vxDimZ = 0, 0, 0
local _vxSz, _vxInflate = 4, 2.5
local _vxSolid = {}
local _vxSolidGen, _vxSolidAt = "", 0
local _vxOX, _vxOY, _vxOZ = 0, 0, 0
local _vxHeight = 5

local function _vxWorld(sz, x, y, z)
    local h = sz * 0.5
    return Vector3.new(_vxOrigin.X + x * sz + h, _vxOrigin.Y + y * sz + h, _vxOrigin.Z + z * sz + h)
end
local function _vxKey(x, y, z) return x + y * 1024 + z * 1048576 end
local function _vxGKey(x, y, z)
    return (x + _vxOX + 8192) + (y + _vxOY + 8192) * 16384 + (z + _vxOZ + 8192) * 268435456
end

local function _vxIsSolid(x, y, z)
    if x < 0 or y < 0 or z < 0 or x >= _vxDimX or y >= _vxDimY or z >= _vxDimZ then return true end
    local k = _vxGKey(x, y, z)
    local c = _vxSolid[k]
    if c ~= nil then return c end
    local h = _vxSz * 0.5
    local cx = _vxOrigin.X + x * _vxSz + h
    local cy = _vxOrigin.Y + y * _vxSz + h
    local cz = _vxOrigin.Z + z * _vxSz + h
    local sxz = _vxSz + _vxInflate
    local vy = _vxHeight > _vxSz and _vxHeight or _vxSz
    local vcy = cy - h + vy * 0.5
    local parts = workspace:GetPartBoundsInBox(CFrame.new(cx, vcy, cz), Vector3.new(sxz, vy, sxz), _vxOverlap)
    local solid = #parts > 0
    _vxSolid[k] = solid
    return solid
end

local function _vxSegClear(from, to, radius, height, sample)
    local dir = to - from
    local mag = dir.Magnitude
    if mag < 0.05 then return true end
    if workspace:Raycast(from, dir, _vxCast) then return false end
    local r = radius > 1 and radius or 1
    if workspace:Blockcast(CFrame.new(from), Vector3.new(r * 2, height, r * 2), dir, _vxCast) ~= nil then return false end
    local n = _vxFloor(mag)
    if sample ~= false and n >= 2 then
        local step = dir / n
        local torso = Vector3.new(r * 2, 3, r * 2)
        for i = 1, n - 1 do
            local pt = from + step * i
            if #workspace:GetPartBoundsInBox(CFrame.new(pt), torso, _vxOverlap) > 0 then return false end
        end
    end
    return true
end

local _vxNeigh = {}
do
    for dx = -1, 1 do
        for dy = -1, 1 do
            for dz = -1, 1 do
                if dx ~= 0 or dy ~= 0 or dz ~= 0 then
                    local nz = (dx ~= 0 and 1 or 0) + (dy ~= 0 and 1 or 0) + (dz ~= 0 and 1 or 0)
                    local kd = dx + dy * 1024 + dz * 1048576
                    _vxNeigh[#_vxNeigh + 1] = { dx, dy, dz, _vxSqrt(dx * dx + dy * dy + dz * dz), nz, kd }
                end
            end
        end
    end
end

local function _vxNoCorner(cx, cy, cz, off)
    if off[5] < 2 then return true end
    if off[1] ~= 0 and _vxIsSolid(cx + off[1], cy, cz) then return false end
    if off[2] ~= 0 and _vxIsSolid(cx, cy + off[2], cz) then return false end
    if off[3] ~= 0 and _vxIsSolid(cx, cy, cz + off[3]) then return false end
    return true
end

local function _vxSnapGoal(goalPos, x, y, z)
    if not _vxIsSolid(x, y, z) then return x, y, z end
    for r = 1, 16 do
        for dx = -r, r do
            for dy = -r, r do
                for dz = -r, r do
                    if _vxMax(_vxAbs(dx), _vxAbs(dy), _vxAbs(dz)) == r then
                        local nx, ny, nz = x + dx, y + dy, z + dz
                        if not _vxIsSolid(nx, ny, nz) and (_vxWorld(_vxSz, nx, ny, nz) - goalPos).Magnitude <= 8 then
                            return nx, ny, nz
                        end
                    end
                end
            end
        end
    end
    return x, y, z
end
local function _vxSnapStart(pos, x, y, z)
    if not _vxIsSolid(x, y, z) then return x, y, z end
    for r = 1, 16 do
        for dx = -r, r do
            for dy = -r, r do
                for dz = -r, r do
                    if _vxMax(_vxAbs(dx), _vxAbs(dy), _vxAbs(dz)) == r then
                        local nx, ny, nz = x + dx, y + dy, z + dz
                        if not _vxIsSolid(nx, ny, nz) and not workspace:Raycast(pos, _vxWorld(_vxSz, nx, ny, nz) - pos, _vxCast) then
                            return nx, ny, nz
                        end
                    end
                end
            end
        end
    end
    return x, y, z
end

local function _vxPush(h, f, key)
    local i = #h + 1
    h[i] = { f, key }
    while i > 1 do
        local p = _vxFloor(i * 0.5)
        if h[p][1] <= h[i][1] then break end
        h[p], h[i] = h[i], h[p]
        i = p
    end
end
local function _vxPop(h)
    local n = #h
    if n == 0 then return nil end
    local top = h[1]
    h[1] = h[n]
    h[n] = nil
    n -= 1
    local i = 1
    while true do
        local l, r, s = i + i, i + i + 1, i
        if l <= n and h[l][1] < h[s][1] then s = l end
        if r <= n and h[r][1] < h[s][1] then s = r end
        if s == i then break end
        h[i], h[s] = h[s], h[i]
        i = s
    end
    return top[2]
end

local _vxHeurW = tonumber(_G.StickyPathWeight) or 2.5
local function _vxAStar(sz, startCell, goalCell, startPos, goalPos)
    local sx, sy, sz2 = _vxSnapStart(startPos, startCell.x, startCell.y, startCell.z)
    local gx, gy, gz = _vxSnapGoal(goalPos, goalCell.x, goalCell.y, goalCell.z)
    local goalKey = _vxKey(gx, gy, gz)
    local startKey = _vxKey(sx, sy, sz2)

    local nodes = { [startKey] = { x = sx, y = sy, z = sz2, g = 0, parent = nil } }
    local closed = {}
    local heap = {}
    _vxPush(heap, 0, startKey)

    local function Heur(x, y, z)
        local ax, ay, az = x - gx, y - gy, z - gz
        return _vxSqrt(ax * ax + ay * ay + az * az)
    end

    local pops = 0
    while #heap > 0 do
        local curKey = _vxPop(heap)
        if closed[curKey] then continue end
        closed[curKey] = true
        pops += 1
        if pops > 300000 then break end

        local cur = nodes[curKey]
        if curKey == goalKey then
            local path = {}
            local n = cur
            while n do
                path[#path + 1] = _vxWorld(sz, n.x, n.y, n.z)
                n = n.parent and nodes[n.parent]
            end
            local rev = {}
            for i = #path, 1, -1 do rev[#rev + 1] = path[i] end
            return rev
        end

        local cx, cy, cz = cur.x, cur.y, cur.z
        local cg = cur.g
        for _, off in _vxNeigh do
            local nk = curKey + off[6]
            if closed[nk] then continue end
            local nx, ny, nz = cx + off[1], cy + off[2], cz + off[3]
            if _vxIsSolid(nx, ny, nz) then continue end
            if not _vxNoCorner(cx, cy, cz, off) then continue end
            local tg = cg + off[4]
            local ex = nodes[nk]
            if not ex or tg < ex.g then
                if ex then
                    ex.g, ex.parent, ex.x, ex.y, ex.z = tg, curKey, nx, ny, nz
                else
                    nodes[nk] = { x = nx, y = ny, z = nz, g = tg, parent = curKey }
                end
                _vxPush(heap, tg + _vxHeurW * Heur(nx, ny, nz), nk)
            end
        end
    end
    return nil
end

local function _vxSimplify(path, radius, height)
    if not path or #path < 3 then return path end
    local out = { path[1] }
    local anchor = 1
    local i = 2
    while i <= #path do
        if not _vxSegClear(path[anchor], path[i + 1] or path[i], radius, height, false) then
            out[#out + 1] = path[i]
            anchor = i
        end
        i += 1
    end
    out[#out + 1] = path[#path]
    return out
end

voxelRoute = function(fromPos, toPos)
    local char = LP.Character
    local _flt = char and { char } or {}
    for _, cl in ipairs(_OTHER_CLONES) do _flt[#_flt + 1] = cl end
    _vxOverlap.FilterDescendantsInstances = _flt
    _vxCast.FilterDescendantsInstances = _flt

    local sz      = tonumber(_G.StickyPathCell)   or 4
    local inflate = tonumber(_G.StickyPathRadius) or 2.5
    local height  = tonumber(_G.StickyPathHeight) or 5
    local pad     = tonumber(_G.StickyPathPad)    or 40

    _vxHeurW = tonumber(_G.StickyPathWeight) or 2.5
    local _gen = sz .. "|" .. inflate .. "|" .. height
    local _now = os.clock()
    if _gen ~= _vxSolidGen or (_now - _vxSolidAt) > (tonumber(_G.StickyPathCacheTTL) or 3) then
        table.clear(_vxSolid)
        _vxSolidGen = _gen
    end
    _vxSolidAt = _now
    _vxSz, _vxInflate, _vxHeight = sz, inflate, height

    local mn = Vector3.new(_vxMin(fromPos.X, toPos.X), _vxMin(fromPos.Y, toPos.Y), _vxMin(fromPos.Z, toPos.Z)) - Vector3.new(pad, pad, pad)
    local mx = Vector3.new(_vxMax(fromPos.X, toPos.X), _vxMax(fromPos.Y, toPos.Y), _vxMax(fromPos.Z, toPos.Z)) + Vector3.new(pad, pad, pad)
    mn = Vector3.new(_vxFloor(mn.X / sz) * sz, _vxFloor(mn.Y / sz) * sz, _vxFloor(mn.Z / sz) * sz)
    _vxOrigin = mn
    _vxOX, _vxOY, _vxOZ = _vxFloor(mn.X / sz), _vxFloor(mn.Y / sz), _vxFloor(mn.Z / sz)
    local size = mx - mn
    _vxDimX = _vxFloor(size.X / sz) + 1
    _vxDimY = _vxFloor(size.Y / sz) + 1
    _vxDimZ = _vxFloor(size.Z / sz) + 1
    if _vxDimX * _vxDimY * _vxDimZ > 200000 then return nil end

    local startCell = {
        x = _vxFloor((fromPos.X - _vxOrigin.X) / sz),
        y = _vxFloor((fromPos.Y - _vxOrigin.Y) / sz),
        z = _vxFloor((fromPos.Z - _vxOrigin.Z) / sz),
    }
    local goalCell = {
        x = _vxFloor((toPos.X - _vxOrigin.X) / sz),
        y = _vxFloor((toPos.Y - _vxOrigin.Y) / sz),
        z = _vxFloor((toPos.Z - _vxOrigin.Z) / sz),
    }

    local path = _vxAStar(sz, startCell, goalCell, fromPos, toPos)
    if not path then return nil end
    path = _vxSimplify(path, inflate, height)
    if not path or #path == 0 then return nil end

    local route = {}
    for idx = 2, #path do route[#route + 1] = path[idx] end
    if #route == 0 or (route[#route] - toPos).Magnitude > 0.5 then
        route[#route + 1] = toPos
    end
    return route
end

end

_G.StickyVoxelRoute = voxelRoute

local _MAP_CENTER = { minX = -458, maxX = -362, minZ = -40, maxZ = 185 }
local _BYPASS_Z_NORTH, _BYPASS_Z_SOUTH = 205, -95
local _BYPASS_X_WEST,  _BYPASS_X_EAST  = -525, -295

local function _inCenterZone(x, z)
    return x >= _MAP_CENTER.minX and x <= _MAP_CENTER.maxX
       and z >= _MAP_CENTER.minZ and z <= _MAP_CENTER.maxZ
end

local function _segmentCrossesCenter(a, b)
    if _inCenterZone(a.X, a.Z) or _inCenterZone(b.X, b.Z) then return true end
    for i = 1, 10 do
        local t = i / 11
        if _inCenterZone(a.X + (b.X - a.X) * t, a.Z + (b.Z - a.Z) * t) then return true end
    end
    return false
end

local function _findBestCenterDetour(fromPos, toPos, y)
    local candidates = {
        { Vector3.new(fromPos.X, y, _BYPASS_Z_NORTH), Vector3.new(toPos.X, y, _BYPASS_Z_NORTH) },
        { Vector3.new(fromPos.X, y, _BYPASS_Z_SOUTH), Vector3.new(toPos.X, y, _BYPASS_Z_SOUTH) },
        { Vector3.new(_BYPASS_X_WEST, y, fromPos.Z), Vector3.new(_BYPASS_X_WEST, y, toPos.Z) },
        { Vector3.new(_BYPASS_X_EAST, y, fromPos.Z), Vector3.new(_BYPASS_X_EAST, y, toPos.Z) },
    }
    local best, bestLen = nil, math.huge
    for _, pair in ipairs(candidates) do
        local w1, w2 = pair[1], pair[2]
        if _clearWide(fromPos, w1) and _clearWide(w1, w2) and _clearWide(w2, toPos) then
            local len = (fromPos - w1).Magnitude + (w1 - w2).Magnitude + (w2 - toPos).Magnitude
            if len < bestLen then bestLen = len; best = { w1, w2 } end
        end
    end
    return best
end
_G.StickySegmentCrossesCenter = _segmentCrossesCenter
_G.StickyFindCenterDetour     = _findBestCenterDetour

local function _rowBoxX() return tonumber(_G.StickyRowBoxX) or 26 end
local function _rowBoxZ() return tonumber(_G.StickyRowBoxZ) or 30 end
local function _rowLane() return tonumber(_G.StickyRowLane) or 30 end

local function _nearestBase(p)
    local bi, bd = nil, math.huge
    for i = 1, 8 do
        local b = BASES_LOW[i]
        local d = (p.X - b.X) ^ 2 + (p.Z - b.Z) ^ 2
        if d < bd then bd = d; bi = i end
    end
    if bd > 70 * 70 then return nil end
    return bi
end

local function _segmentHitsOtherBase(a, b, ignA, ignB)
    local hx, hz = _rowBoxX(), _rowBoxZ()
    for i = 0, 24 do
        local t = i / 24
        local px = a.X + (b.X - a.X) * t
        local pz = a.Z + (b.Z - a.Z) * t
        for k = 1, 8 do
            if k ~= ignA and k ~= ignB then
                local bs = BASES_LOW[k]
                if math.abs(px - bs.X) <= hx and math.abs(pz - bs.Z) <= hz then
                    return true
                end
            end
        end
    end
    return false
end

local function _findRowDetour(fromPos, toPos, y)
    local iFrom, iTo = _nearestBase(fromPos), _nearestBase(toPos)
    if not _segmentHitsOtherBase(fromPos, toPos, iFrom, iTo) then return nil end

    local colX = BASES_LOW[iTo or 1].X
    local off  = _rowLane()
    local lanes = {}
    local outer = (colX < COLUMN_SPLIT_X) and (colX - off) or (colX + off)
    lanes[#lanes + 1] = outer
    local inner = (colX < COLUMN_SPLIT_X) and (colX + off) or (colX - off)
    if not _inCenterZone(inner, (fromPos.Z + toPos.Z) * 0.5) then
        lanes[#lanes + 1] = inner
    end

    local best, bestLen = nil, math.huge
    for _, laneX in ipairs(lanes) do
        local w1 = Vector3.new(laneX, y, fromPos.Z)
        local w2 = Vector3.new(laneX, y, toPos.Z)
        if _clearWide(fromPos, w1) and _clearWide(w1, w2) and _clearWide(w2, toPos)
           and not _segmentHitsOtherBase(w1, w2, iFrom, iTo) then
            local len = (fromPos - w1).Magnitude + (w1 - w2).Magnitude + (w2 - toPos).Magnitude
            if len < bestLen then bestLen = len; best = { w1, w2 } end
        end
    end
    return best
end
_G.StickyFindRowDetour = _findRowDetour

local _hopRP = RaycastParams.new()
_hopRP.FilterType = Enum.RaycastFilterType.Exclude

local function _partTopY(inst)
    local ok, t = pcall(function()
        local cf, sz = inst.CFrame, inst.Size
        local half = (math.abs(cf.RightVector.Y) * sz.X
            + math.abs(cf.UpVector.Y) * sz.Y
            + math.abs(cf.LookVector.Y) * sz.Z) / 2
        return cf.Position.Y + half
    end)
    if ok and t then return t end
    return inst.Position.Y + (inst.Size.Y / 2)
end

local function _hopBlockerTop(a, b)
    local ignore = { LP.Character }
    for _, cl in ipairs(_OTHER_CLONES) do ignore[#ignore + 1] = cl end
    local top = nil
    for _ = 1, 10 do
        _hopRP.FilterDescendantsInstances = ignore
        local r = workspace:Raycast(a, b - a, _hopRP)
        if not r then break end
        if _blocks(r.Instance) then
            local t = _partTopY(r.Instance)
            if not top or t > top then top = t end
        end
        ignore[#ignore + 1] = r.Instance
    end
    return top
end

local function _hopRoute(fromPos, toPos)
    local flat = Vector3.new(toPos.X - fromPos.X, 0, toPos.Z - fromPos.Z)
    local dist = flat.Magnitude
    if dist < 8 then return nil end
    local dir = flat.Unit
    local step = tonumber(_G.StickyHopStep) or 8
    local clear = tonumber(_G.StickyHopClear) or 4
    local maxUp = tonumber(_G.StickyHopMaxUp) or 22
    local groundY = fromPos.Y
    local route = {}
    local inHop, hopY, hopStart = false, nil, nil
    local i = step
    while i <= dist do
        local a = fromPos + dir * (i - step)
        local b = fromPos + dir * math.min(i, dist)
        local ga = Vector3.new(a.X, groundY, a.Z)
        local gb = Vector3.new(b.X, groundY, b.Z)
        if not _clear(ga, gb) then
            local top = _hopBlockerTop(ga, gb) or (groundY + 6)
            local want = top + clear
            if want - groundY > maxUp then return nil end
            if not inHop then
                inHop, hopY, hopStart = true, want, ga
                route[#route + 1] = Vector3.new(a.X, want, a.Z)
            elseif want > hopY then
                hopY = want
                route[#route + 1] = Vector3.new(a.X, want, a.Z)
            end
        elseif inHop then
            inHop = false
            route[#route + 1] = Vector3.new(b.X, hopY, b.Z)
            route[#route + 1] = gb
        end
        i = i + step
    end
    if inHop then
        route[#route + 1] = Vector3.new(toPos.X, hopY, toPos.Z)
    end
    route[#route + 1] = toPos
    return route
end
_G.StickyHopRoute = _hopRoute

function _softenLine(fromPos, toPos)
    if _G.StickySoftenLine == false then return nil end
    local span = toPos - fromPos
    local d = span.Magnitude
    if d < (tonumber(_G.StickySoftenMin) or 220) then return nil end
    local flat = Vector3.new(span.X, 0, span.Z)
    if flat.Magnitude < 1 then return nil end
    flat = flat.Unit
    local perp = Vector3.new(-flat.Z, 0, flat.X)

    local segs = math.clamp(math.floor(d / (tonumber(_G.StickySoftenSeg) or 160)) + 1, 2, 4)
    local amp  = tonumber(_G.StickySoftenAmp)  or 9
    local ampY = tonumber(_G.StickySoftenAmpY) or 5

    local sgn = ((math.floor(math.abs(fromPos.X) + math.abs(toPos.Z)) % 2) == 0) and 1 or -1

    local pts = {}
    for i = 1, segs - 1 do
        local t = i / segs
        local w = math.sin(t * math.pi)
        pts[#pts + 1] = fromPos + span * t
            + perp * (amp * w * sgn)
            + Vector3.new(0, ampY * w, 0)
    end
    pts[#pts + 1] = toPos

    local prev = fromPos
    for _, p in ipairs(pts) do
        if not _clearWide(prev, p) then return nil end
        prev = p
    end
    return pts
end

local function _centerSpanT(a, b)
    local t0, t1 = nil, nil
    for i = 0, 40 do
        local t = i / 40
        local x = a.X + (b.X - a.X) * t
        local z = a.Z + (b.Z - a.Z) * t
        if _inCenterZone(x, z) then
            if not t0 then t0 = t end
            t1 = t
        end
    end
    return t0, t1
end

local function _hitSpanT(a, b)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    rp.FilterDescendantsInstances = skip
    local t0, t1 = nil, nil
    local n, edge = 28, 0.1
    for i = 0, n - 1 do
        local tA, tB = i / n, (i + 1) / n
        if tB > edge and tA < (1 - edge) then
            local pA, pB = a:Lerp(b, tA), a:Lerp(b, tB)
            local d = pB - pA
            if d.Magnitude > 0.05 then
                local hit = workspace:Raycast(pA, d, rp)
                if hit and _blocksWide(hit.Instance) then
                    if not t0 then t0 = math.max(tA, edge) end
                    t1 = math.min(tB, 1 - edge)
                end
            end
        end
    end
    return t0, t1
end

local function _localHopOver(fromPos, toPos, tBlock0, tBlock1)
    local lift = tonumber(_G.StickyCenterFly) or 10
    local pad = tonumber(_G.StickyHopPad) or 0.12
    local t0 = math.clamp(tBlock0 or 0.35, 0.08, 0.85)
    local t1 = math.clamp(tBlock1 or 0.65, t0 + 0.04, 0.92)
    local tRise0 = math.max(0.04, t0 - pad)
    local tRise1, tFall0, tFall1 = t0, t1, math.min(0.94, t1 + pad)
    local function at(t, yAdd)
        local p = fromPos:Lerp(toPos, t)
        local gy = fromPos.Y + (toPos.Y - fromPos.Y) * t
        return Vector3.new(p.X, gy + (yAdd or 0), p.Z)
    end
    local route = { fromPos }
    local function push(p)
        if (route[#route] - p).Magnitude > 0.6 then route[#route + 1] = p end
    end
    push(at(tRise0, 0))
    push(at((tRise0 + tRise1) * 0.5, lift * 0.5))
    push(at(tRise1, lift))
    push(at((tRise1 + tFall0) * 0.5, lift))
    push(at(tFall0, lift))
    push(at((tFall0 + tFall1) * 0.5, lift * 0.5))
    push(at(tFall1, 0))
    push(toPos)
    return route
end

function computeRoute(fromPos, toPos, facingDir, maxLift, preferCrest)
    local _ = maxLift

    if _clearWide(fromPos, toPos) then return { toPos } end

    if _segmentCrossesCenter(fromPos, toPos) then
        local c0, c1 = _centerSpanT(fromPos, toPos)
        local h0, h1 = _hitSpanT(fromPos, toPos)
        if c0 and h0 and h1 and h1 >= c0 and h0 <= (c1 or 1) then
            local t0 = math.max(h0, c0)
            local t1 = math.min(h1, c1 or h1)
            if (t1 - t0) > 0.02 then
                return _localHopOver(fromPos, toPos, t0, t1)
            end
        end
    end

    local centerPatch = nil
    local rowPatch = _findRowDetour(fromPos, toPos, fromPos.Y)
    if rowPatch and #rowPatch > 0 then
        fromPos = rowPatch[#rowPatch]
    end

    local function _withPatch(route)
        if (not centerPatch or #centerPatch == 0)
           and (not rowPatch or #rowPatch == 0) then return route end
        local merged = {}
        if centerPatch then for _, p in ipairs(centerPatch) do merged[#merged + 1] = p end end
        if rowPatch    then for _, p in ipairs(rowPatch)    do merged[#merged + 1] = p end end
        for _, p in ipairs(route) do merged[#merged + 1] = p end
        return merged
    end

    if _clearWide(fromPos, toPos) then return _withPatch({ toPos }) end

    if preferCrest then
        local cruiseY = math.max(fromPos.Y, toPos.Y, 26) + 12
        local up   = Vector3.new(fromPos.X, cruiseY, fromPos.Z)
        local over = Vector3.new(toPos.X,   cruiseY, toPos.Z)
        local crest = { fromPos, up, over, toPos }
        local ok = true
        for i = 1, #crest - 1 do
            local a, b = crest[i], crest[i + 1]
            if (a - b).Magnitude > 0.5 then
                local sA = (i == 1) and _ENDPOINT_SLACK or 0
                local sB = (i == #crest - 1) and _ENDPOINT_SLACK or 0
                if not _clearWide(a, b, sA, sB) then ok = false; break end
            end
        end
        if ok then return _withPatch(crest) end
    end

    do
        local vr = voxelRoute(fromPos, toPos)
        if vr and #vr > 0 then return _withPatch(vr) end
    end

    local entry = facingDir and (toPos - facingDir * 14) or toPos

    local best, bestLen = nil, math.huge
    local function consider(pts)
        if not pts or #pts < 2 then return end
        local n = #pts
        for i = 1, n - 1 do
            local a, b = pts[i], pts[i + 1]
            if (a - b).Magnitude > 0.5 then
                local sA = (i == 1) and _ENDPOINT_SLACK or 0
                local sB = (i == n - 1) and _ENDPOINT_SLACK or 0
                if not _clearWide(a, b, sA, sB) then return end
            end
        end
        local pulled = _pullWide(pts)
        local L = _len(pulled)
        if L < bestLen then best, bestLen = pulled, L end
    end

    do
        local dirF = Vector3.new(entry.X - fromPos.X, 0, entry.Z - fromPos.Z)
        if dirF.Magnitude > 0.1 then
            dirF = dirF.Unit
            local perp = Vector3.new(-dirF.Z, 0, dirF.X)
            local midBase = (fromPos + entry) * 0.5
            for _, off in ipairs({ 14, -14, 24, -24, 38, -38, 56, -56, 76, -76 }) do
                consider({ fromPos, midBase + perp * off, entry })
                consider({ fromPos, fromPos + perp * off, entry + perp * off, entry })
            end
        end
    end

    local navRaw
    if not best then
        local groundTo = Vector3.new(entry.X, fromPos.Y, entry.Z)
        local path = PathfindingService:CreatePath({
            AgentRadius = 16, AgentHeight = 5, AgentCanJump = true, AgentJumpHeight = 10, AgentMaxSlope = 89,
        })
        local FLOAT = 5
        local nav = { fromPos }
        local ok = pcall(function()
            path:ComputeAsync(Vector3.new(fromPos.X, fromPos.Y, fromPos.Z), groundTo)
        end)
        if ok and path.Status == Enum.PathStatus.Success then
            local last = fromPos
            for _, wp in ipairs(path:GetWaypoints()) do
                if (wp.Position - last).Magnitude >= 8 then
                    nav[#nav + 1] = wp.Position + Vector3.new(0, FLOAT, 0)
                    last = wp.Position
                end
            end
        end
        nav[#nav + 1] = entry + Vector3.new(0, FLOAT, 0)
        nav = _pushOffWalls(nav)
        navRaw = nav
        consider(nav)
    end

    local route = best
    if not route and _clear(fromPos, toPos) then route = { toPos } end
    if not route and navRaw then route = _pullWide(navRaw) end
    if not route then route = { toPos } end
    if (route[#route] - toPos).Magnitude > 0.5 then
        route[#route + 1] = toPos
    end
    return _withPatch(route)
end
end

local _stickyRouteRP = RaycastParams.new()
_stickyRouteRP.FilterType = Enum.RaycastFilterType.Exclude
_stickyRouteRP.IgnoreWater = true
local function _stickyRouteIgnore()
    local out = {}
    if LP and LP.Character then out[#out + 1] = LP.Character end
    return out
end
local function _stickyAllPartsClear(a, b)
    local d = b - a
    if d.Magnitude < 0.1 then return true end
    _stickyRouteRP.FilterDescendantsInstances = _stickyRouteIgnore()
    local ok, hit = pcall(function()
        return workspace:Blockcast(CFrame.lookAt(a, b), Vector3.new(5.5, 7.5, 5.5), d, _stickyRouteRP)
    end)
    return ok and hit == nil
end
local function _stickyRouteAllClear(pts)
    if type(pts) ~= "table" or #pts == 0 then return false end
    local prev = pts[1]
    for i = 2, #pts do
        if not _stickyAllPartsClear(prev, pts[i]) then return false end
        prev = pts[i]
    end
    return true
end
local function _stickySafeRoute(fromPos, toPos, facingDir, preferCrest)
    local direct = computeRoute(fromPos, toPos, facingDir, nil, preferCrest == true)
    local pts = { fromPos }
    for _, point in ipairs(direct or {toPos}) do pts[#pts + 1] = point end
    if _stickyRouteAllClear(pts) then return direct end
    local lift = math.max(fromPos.Y, toPos.Y, 28) + 18
    local high = { fromPos, Vector3.new(fromPos.X, lift, fromPos.Z), Vector3.new(toPos.X, lift, toPos.Z), toPos }
    if _stickyRouteAllClear(high) then return { high[2], high[3], toPos } end
    local retry = computeRoute(fromPos, toPos, facingDir, nil, true)
    local retryPts = { fromPos }
    for _, point in ipairs(retry or {toPos}) do retryPts[#retryPts + 1] = point end
    if _stickyRouteAllClear(retryPts) then return retry end
    return retry or {toPos}
end
_G.StickySafeTPRoute = _stickySafeRoute

function equipTool(name)
    local char = LP.Character
    if not char or char:FindFirstChild(name) then return char ~= nil end
    local bp = LP:FindFirstChild("Backpack")
    if not bp then return false end
    local tool = bp:FindFirstChild(name)
    if tool and tool:IsA("Tool") then tool.Parent = char; return true end
    return false
end

function unequipAll()
    local char, bp = LP.Character, LP.Backpack
    if not char or not bp then return end
    for _, t in pairs(char:GetChildren()) do
        if t:IsA("Tool") then t.Parent = bp end
    end
end

function doClone()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum then return false end

    -- Never initiate a Quantum Cloner action while standing inside an active laser lane.
    -- Automated steal routing chooses a side position before it calls this function.
    if rootPart and type(_G.StickyPositionNearLaser) == "function" then
        local nearLaser = false
        local ok = pcall(function()
            nearLaser = _G.StickyPositionNearLaser(rootPart.Position, nil, 1.5)
        end)
        if ok and nearLaser then
            warn("[Sticky] Clone skipped: current position overlaps an active laser lane; use a side position.")
            return false
        end
    end

    local cloner = (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild("Quantum Cloner"))
                or char:FindFirstChild("Quantum Cloner")
    if not cloner then return false end

    if cloner.Parent ~= char then
        pcall(function() hum:EquipTool(cloner) end)
        task.wait(0.06)
    end

    local useItem = getRemote("RemoteEvent", "UseItem")
    local onTel   = getRemote("RemoteEvent", "QuantumCloner/OnTeleport")
    if not useItem or not onTel then return false end

    _G.isCloning = true
    local useOk = pcall(function() useItem:FireServer() end)
    task.wait(0.12)
    local telOk = pcall(function() onTel:FireServer() end)
    task.wait(0.35)
    pcall(function()
        local currentChar = LP.Character
        local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
        if currentHum then currentHum:UnequipTools() end
    end)

    -- Defensive cleanup after the clone/teleport request. Never leave the character anchored.
    pcall(function()
        local currentChar = LP.Character
        local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        if currentRoot and currentRoot:IsA("BasePart") then currentRoot.Anchored = false end
    end)
    task.delay(0.6, function() _G.isCloning = false end)
    return useOk and telOk
end

_TweenTS = game:GetService("TweenService")
function StickyTween(rootPart, hum, targetPos, lookDir)
    if not rootPart or not rootPart.Parent then return end
    local STEP = 20
    local speed = (_G.TPTravelSpeed or 100)
    local hasLook = lookDir ~= nil and lookDir.Magnitude > 0.001
    local prevAnchored = rootPart.Anchored
    _vzL(rootPart)
    _vzA(rootPart)
    pcall(function() rootPart.Anchored = true end)
    local deadline = os.clock() + 12
    while rootPart and rootPart.Parent and os.clock() < deadline do
        local pos = rootPart.Position
        local toTarget = targetPos - pos
        local d = toTarget.Magnitude
        if d < 0.5 then break end
        local stepDist = math.min(STEP, d)
        local stepGoal = pos + toTarget.Unit * stepDist
        local stepCF
        if hasLook then
            stepCF = CFrame.lookAt(stepGoal, stepGoal + lookDir)
        else
            stepCF = (rootPart.CFrame - rootPart.CFrame.Position) + stepGoal
        end
        local dur = math.clamp(stepDist / speed, 0.02, 1)
        local tw = _TweenTS:Create(rootPart, TweenInfo.new(dur, Enum.EasingStyle.Linear), { CFrame = stepCF })
        tw:Play()
        tw.Completed:Wait()
    end
    pcall(function() rootPart.Anchored = prevAnchored end)
    if rootPart and rootPart.Parent then _vzL(rootPart) end
end

function _makeOneWay(plat)
    if not plat then return end
    local rsConn
    local lastY = nil
    rsConn = RunService.Stepped:Connect(function()
        if not plat or not plat.Parent then
            if rsConn then rsConn:Disconnect() end
            return
        end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local currentY = hrp.Position.Y
            if not lastY then lastY = currentY end
            local deltaY = currentY - lastY
            local isMovingUp = (hrp.AssemblyLinearVelocity.Y > 1) or (deltaY > 0.01 and deltaY < 5)
            if isMovingUp then
                plat.CanCollide = false
            else
                plat.CanCollide = (currentY > plat.Position.Y + 0.1)
            end
            lastY = currentY
        end
    end)
end

function carpetEngageFast()
    local char = LP.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return nil end

    if not char:FindFirstChild("Grapple Hook") then
        local g = findTool("Grapple Hook")
        if g then pcall(function() hum:EquipTool(g) end) end
    end
    local _t = os.clock()
    while not (LP.Character and LP.Character:FindFirstChild("Grapple Hook"))
        and os.clock() - _t < (tonumber(_G.StickyGoGrappleWait) or 0.35) do
        local c = LP.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        local g = findTool("Grapple Hook")
        if g and h then pcall(function() h:EquipTool(g) end) end
        RunService.Heartbeat:Wait()
    end
    if LP.Character and LP.Character:FindFirstChild("Grapple Hook") then
        (function()
            if type(_G.StickyFireGrapple2) == "function" then
                return _G.StickyFireGrapple2()
            elseif type(fireGrapple) == "function" then
                return fireGrapple()
            end
            return false
        end)()
    end

    local h2 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h2 then pcall(function() h2:UnequipTools() end) end
    RunService.Heartbeat:Wait()

    local cn
    local _t2 = os.clock()
    repeat
        cn = equipCarpet()
        local c = LP.Character
        if cn and c and c:FindFirstChild(cn) then break end
        RunService.Heartbeat:Wait()
    until os.clock() - _t2 > (tonumber(_G.StickyGoCarpetWait) or 2)
    return cn
end
_G.StickyCarpetEngageFast = carpetEngageFast

function goToBrainrot(petPos, slot)
    if not petPos then return end
    if type(_G.StickyNormalizeTPModes) == "function" then _G.StickyNormalizeTPModes() end
    _G.StickyInstaTpBrainrot = true
    _G.StickyCFrameGoTo = true
    if _G.StickyInstaTpBrainrot == true or _G.StickyCFrameGoTo == true or _G.StickyCFrameGoTo == true then
        local LP = game:GetService("Players").LocalPlayer
        local RS = game:GetService("RunService")
        local char, hrp, hum
        local tReady = os.clock()
        repeat
            char = LP and LP.Character
            hrp = char and char:FindFirstChild("HumanoidRootPart")
            hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum then break end
            RS.Heartbeat:Wait()
        until os.clock() - tReady > 2
        if not hrp then return end
        pcall(function() hrp.Anchored = false end)
        pcall(function() if type(equipCarpet) == "function" then equipCarpet() end end)

        local h = petPos.Y
        local _slot = tonumber(slot)
        local targetY = hrp.Position.Y
        local _isFloor1 = false
        if _slot and _slot >= 1 and _slot < 11 then
            targetY = -2.5
            _isFloor1 = true
        elseif _slot and _slot >= 19 then
            targetY = 23
        elseif _slot and _slot >= 11 then
            targetY = 16
        elseif h > 23.15 then
            targetY = 23
        elseif h >= 11 and h <= 23.15 then
            targetY = 16
        elseif h >= -6.9 and h <= 8.9 then
            targetY = -2.5
            _isFloor1 = true
        end
        if _G.StickyApproachF2From1 == nil then _G.StickyApproachF2From1 = true end
        local _f2FromF1 = (not _isFloor1) and _G.StickyApproachF2From1
            and ((_slot and _slot >= 11 and _slot < 19) or (h > 10 and h <= 23.15))
        if _f2FromF1 then targetY = h - 5.5 end
        if (not _isFloor1) and ((_slot and _slot >= 19) or h > 23.15) then
            targetY = h - 5.5
        end
        local _to = Vector3.new(petPos.X, targetY, petPos.Z)

        if (not _isFloor1) and ((_slot and _slot >= 19) or (not _slot and h > 23.15)) then
            local plat = Instance.new("Part")
            plat.Name = "StickyTempPlatform"
            plat.Size = Vector3.new(3, 1, 3)
            plat.Position = _to - Vector3.new(0, 5, 0)
            plat.Anchored = true
            plat.CanCollide = true
            plat.Transparency = 1
            plat.Parent = workspace
            task.spawn(function()
                local s = tick()
                while tick() - s < 20 do
                    if LP:GetAttribute("Stealing") or _G.StickyTPStop or _G.StickyTPStop then break end
                    task.wait(0.1)
                end
                if plat and plat.Parent then plat:Destroy() end
            end)
        elseif _f2FromF1 then
            local plat = Instance.new("Part")
            plat.Name = "StickyF2ApproachPlat"
            plat.Size = Vector3.new(6, 1, 6)
            plat.Position = _to - Vector3.new(0, 3, 0)
            plat.Anchored = true
            plat.CanCollide = true
            plat.Transparency = 1
            plat.Parent = workspace
            task.spawn(function()
                local s = tick()
                while tick() - s < 20 do
                    if LP:GetAttribute("Stealing") or _G.StickyTPStop or _G.StickyTPStop then break end
                    task.wait(0.1)
                end
                if plat and plat.Parent then plat:Destroy() end
            end)
        end

        if type(vizPath) == "function" then pcall(vizPath, hrp.Position, { _to }) end

        do
            local tries = math.clamp(math.floor(tonumber(_G.StickyBrainrotSnapTries) or 3), 1, 4)
            local verify = tonumber(_G.StickyBrainrotSnapVerify) or 0.12
            local tol = tonumber(_G.StickyBrainrotSnapTol) or 2.5
            local snapBaseSteps = math.clamp(math.floor(tonumber(_G.StickyBrainrotSnapSteps) or 8), 6, 14)
            local snapStepDistance = math.clamp(tonumber(_G.StickyBrainrotSnapStepDistance) or 24, 12, 48)
            local function snapWrite()
                if not hrp or not hrp.Parent then return false end
                local startPos = hrp.Position
                local distance = (startPos - _to).Magnitude
                local snapSteps = math.clamp(math.max(snapBaseSteps, math.ceil(distance / snapStepDistance)), 6, 24)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                for step = 1, snapSteps do
                    if not hrp or not hrp.Parent or _G.StickyTPStop then return false end
                    local a = step / snapSteps
                    a = a * a * (3 - 2 * a)
                    local pos = startPos:Lerp(_to, a)
                    hrp.CFrame = CFrame.new(pos)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    RS.Heartbeat:Wait()
                end
                hrp.CFrame = CFrame.new(_to)
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                return true
            end
            for _try = 1, tries do
                if LP:GetAttribute("Stealing") or _G.StickyTPStop or _G.StickyTPStop then break end
                char = LP.Character
                hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then break end
                pcall(snapWrite)
                if verify <= 0 then break end
                local v0 = os.clock()
                local ok = false
                while os.clock() - v0 < verify do
                    RS.Heartbeat:Wait()
                    char = LP.Character
                    hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then break end
                    if (hrp.Position - _to).Magnitude <= tol then ok = true; break end
                end
                if ok then break end
            end
            char = LP.Character
            hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then pcall(snapWrite) end
        end

        if hrp and hrp.Parent then
            pcall(function()
                hrp.Anchored = false
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end)
            _G.StickyGtbArrivedAt = os.clock()
            _G.StickyGtbArrivePos = hrp.Position
        end
        return
    end

    if false then
        local LP = game:GetService("Players").LocalPlayer or game:GetService("Players").PlayerAdded:Wait()
        local RS = game:GetService("RunService")
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and typeof(petPos) == "Vector3" then
            pcall(function() hrp.Anchored = false end)
            pcall(function()
                if type(equipCarpet) == "function" then equipCarpet()
                elseif type(_G.StickyEquipCarpet) == "function" then _G.StickyEquipCarpet() end
            end)
            local h = petPos.Y
            local _slot = tonumber(slot)
            local targetY = hrp.Position.Y
            local _isFloor1 = false
            if _slot and _slot >= 1 and _slot < 11 then
                targetY = -4
                _isFloor1 = true
            elseif _slot and _slot >= 19 then
                targetY = 21
            elseif _slot and _slot >= 11 then
                targetY = 14.5
            elseif h > 23.15 then
                targetY = 21
            elseif h >= 11 and h <= 23.15 then
                targetY = 14.5
            elseif h >= -6.9 and h <= 8.9 then
                targetY = -4
                _isFloor1 = true
            end
            if _G.StickyApproachF2From1 == nil then _G.StickyApproachF2From1 = true end
            local _f2FromF1 = (not _isFloor1) and _G.StickyApproachF2From1
                and ((_slot and _slot >= 11 and _slot < 19) or (h > 10 and h <= 23.15))
            if _f2FromF1 then targetY = h - 8 end
            local target = Vector3.new(petPos.X, targetY, petPos.Z)
            if type(_G.StickyTPLineShow) == "function" then
                pcall(_G.StickyTPLineShow, hrp.Position, target)
            end
            local speed = math.clamp(tonumber(_G.StickyCFrameGoSpeed) or 35, 5, 500)
            local start = hrp.Position
            local dist = (target - start).Magnitude
            local steps = math.max(1, math.ceil(dist / math.max(speed * 0.35, 8)))
            for i = 1, steps do
                if not hrp.Parent then break end
                local a = i / steps
                hrp.CFrame = CFrame.new(start:Lerp(target, a))
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                RS.Heartbeat:Wait()
            end
            local tHold = os.clock()
            local maxHold = tonumber(_G.StickyCFrameGoHoldMax) or 8
            local LP = game:GetService("Players").LocalPlayer
            local holdY = target.Y
            while hrp.Parent and (os.clock() - tHold) < maxHold do
                if LP and LP:GetAttribute("Stealing") == true then break end
                if _G.StickyTPStop or _G.StickyTPStop then break end
                local char = LP and LP.Character
                if char and (char:GetAttribute("Carrying") == true or char:FindFirstChild("Stealing")) then break end
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local md = hum and hum.MoveDirection or Vector3.zero
                local pos = hrp.Position
                if md.Magnitude > 0.05 then
                    if math.abs(pos.Y - holdY) > 1.5 then
                        hrp.CFrame = CFrame.new(pos.X, holdY, pos.Z) * (hrp.CFrame - hrp.CFrame.Position)
                    end
                else
                    local flat = Vector3.new(target.X - pos.X, 0, target.Z - pos.Z)
                    if flat.Magnitude > 12 then
                        break
                    elseif flat.Magnitude > 0.5 then
                        local nx = pos.X + flat.Unit.X * math.min(flat.Magnitude, 2)
                        local nz = pos.Z + flat.Unit.Z * math.min(flat.Magnitude, 2)
                        hrp.CFrame = CFrame.new(nx, holdY, nz) * (hrp.CFrame - hrp.CFrame.Position)
                    else
                        hrp.CFrame = CFrame.new(pos.X, holdY, pos.Z) * (hrp.CFrame - hrp.CFrame.Position)
                    end
                end
                hrp.AssemblyAngularVelocity = Vector3.zero
                RS.Heartbeat:Wait()
            end
            return
        end
    end
    if not petPos then return end
    local char, hrp, hum
    local _t0 = os.clock()
    repeat
        char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum then break end
        RunService.Heartbeat:Wait()
    until os.clock() - _t0 > 3
    if not hrp or not hum then return end
    pcall(function() hrp.Anchored = false end)
    pcall(function()
        if typeof(petPos) == "Vector3" and type(vizPath) == "function" then
            vizPath(hrp.Position, { petPos })
        end
    end)
    local _equipped = false
    do

        for _, _cn in ipairs(CARPET_NAMES) do
            if char and char:FindFirstChild(_cn) then _equipped = true break end
        end
        local _gd = (petPos and hrp and hrp.Parent) and (petPos - hrp.Position).Magnitude or math.huge
        local _gmin = tonumber(_G.StickyGoGrappleMin) or 100
        if not _equipped and _G.StickyGoGrapple ~= false and _gd > _gmin then
            pcall(carpetEngageFast)
            char = LP.Character
            for _, _cn in ipairs(CARPET_NAMES) do
                if char and char:FindFirstChild(_cn) then _equipped = true break end
            end
        end
        local _e0 = os.clock()
        while not _equipped and os.clock() - _e0 <= (tonumber(_G.StickyGoCarpetWait) or 3) do
            char = LP.Character
            for _, _cn in ipairs(CARPET_NAMES) do
                if char and char:FindFirstChild(_cn) then _equipped = true break end
            end
            if _equipped then break end
            equipCarpet()
            RunService.Heartbeat:Wait()
        end
        if _equipped then task.wait(tonumber(_G.StickyGoCarpetSettle) or 0.02) end
    end
    char = LP.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp then return end
    pcall(function() hrp.Anchored = false end)
    local _plotRad = (petPos.Y <= 8.9) and 26 or 25
    do
        local _t0b = os.clock()
        repeat
            local p = hrp.Position
            local inRad = false
            local plotsFolder = workspace:FindFirstChild("Plots")
            if plotsFolder then
                for _, plot in ipairs(plotsFolder:GetChildren()) do
                    pcall(function()
                        local pp = plot:GetPivot().Position
                        if math.abs(p.X - pp.X) < _plotRad and math.abs(p.Z - pp.Z) < _plotRad then inRad = true end
                    end)
                    if inRad then break end
                end
            end
            if inRad then break end
            RunService.Heartbeat:Wait()
        until os.clock() - _t0b > (tonumber(_G.StickyGoPlotWait) or 1)
    end
    local h = petPos.Y
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)
    local _wentUnder = false
    local _slot = tonumber(slot)
    local _under = tonumber(_G.StickyUnderOffset) or 6
    local targetY = hrp.Position.Y
    if (_slot and _slot >= 19) or (not _slot and h > 23.15) then
        targetY = h - (tonumber(_G.StickyUnderOffset3) or 4)
        _wentUnder = true
    elseif (_slot and _slot >= 11) or (not _slot and h >= 11 and h <= 23.15) then

        targetY = h - (tonumber(_G.StickyUnderOffset2) or 3.5)
        _wentUnder = true
    elseif (_slot and _slot >= 1) or (not _slot and h >= -6.9 and h <= 8.9) then
        targetY = tonumber(_G.StickyFloor1Y) or -4
        if _G.StickyFloor1Platform ~= false then _wentUnder = true end
    else
        targetY = h - _under
        _wentUnder = true
    end
    local _to = Vector3.new(petPos.X, targetY, petPos.Z)
    if hrp and hrp.Parent then

        do
            local _goSpeed = tonumber(_G.StickyGoSpeed) or 400
            local _s1 = tonumber(_G.StickyGoGlideSpeed1) or (_goSpeed * 0.375)
            local _t1 = tonumber(_G.StickyGoGlideTime1) or 0.03
            local _s2 = tonumber(_G.StickyGoGlideSpeed2) or _goSpeed
            local _cap = tonumber(_G.StickyGoGlideMax) or 2.5
            local _g0 = os.clock()
            local _lastJump = 0
            while os.clock() - _g0 < _cap do
                if not (hrp and hrp.Parent) then break end
                if LP:GetAttribute("Stealing") or _G.StickyTPStop then break end
                local d = _to - hrp.Position
                if d.Magnitude <= 3 then break end
                equipCarpet()
                if _G.StickyGoJump == true and d.Magnitude > 15 and (os.clock() - _lastJump) > 0.5 then
                    local _gh = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                    if _gh then
                        pcall(function() _gh:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() _gh.Jump = true end)
                        _lastJump = os.clock()
                    end
                end
                if _G.StickyGoZeroEachFrame ~= false then
                    pcall(function()
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end)
                end
                local _v = d.Unit * (((os.clock() - _g0) < _t1) and _s1 or _s2)
                if _G.StickyGoNoRise ~= false and hrp.Position.Y >= _to.Y - 0.5 and _v.Y > 0 then
                    _v = Vector3.new(_v.X, 0, _v.Z)
                end
                _setFlightVel(hrp, _v)
                RunService.Heartbeat:Wait()
            end
        end
        local _snapCF = CFrame.new(_to) * (hrp.CFrame - hrp.CFrame.Position)
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            hrp.CFrame = _snapCF
        end)

        for _ = 1, (tonumber(_G.StickySnapHoldFrames) or 8) do
            RunService.Heartbeat:Wait()
            if not (hrp and hrp.Parent) then break end
            if (hrp.Position - _to).Magnitude > 4 then
                pcall(function()
                    hrp.CFrame = _snapCF
                end)
            end
        end
    end
    if _wentUnder and _G.StickyPlatform ~= false then
        local _platPos = (hrp and hrp.Parent and hrp.Position) or _to
        local _feetY = _platPos.Y - 3
        local _sz = tonumber(_G.StickyPlatSize) or 10
        local _old = workspace:FindFirstChild("ANGVELSTempPlatform")
        if _old then pcall(function() _old:Destroy() end) end
        local _plat = Instance.new("Part")
        _plat.Name = "ANGVELSTempPlatform"; _plat.Size = Vector3.new(_sz, 1, _sz)
        _plat.Position = Vector3.new(petPos.X, _feetY - (tonumber(_G.StickyPlatDrop) or 1.5), petPos.Z)
        _plat.Anchored = true; _plat.CanCollide = false; pcall(_makeOneWay, _plat); _plat.Transparency = 1
        _plat.Material = Enum.Material.SmoothPlastic; _plat.Parent = workspace
        task.spawn(function()
            local _s = tick()
            while tick() - _s < (tonumber(_G.StickyPlatLife) or 20) do
                if LP:GetAttribute("Stealing") then break end
                task.wait(0.1)
            end
            if _plat and _plat.Parent then _plat:Destroy() end
        end)
    end
end

_Stats = game:GetService("Stats")
function _pingMs()
    local ok, p = pcall(function() return LP:GetNetworkPing() * 1000 end)
    if ok and type(p) == "number" and p > 0 then return p end
    local ok2, p2 = pcall(function()
        return _Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok2 and type(p2) == "number" and p2 > 0 then return p2 end
    return 0
end
_G.StickyPingMs = _pingMs
function _pingAdjustSpeed(spd)
    local thresh = tonumber(_G.StickyPingThresh) or 170
    local capped = tonumber(_G.StickyHighPingSpeed) or 400
    if _pingMs() >= thresh and spd > capped then return capped end
    return spd
end

function _inVoid(hrp)
    if not hrp or not hrp.Parent then return true end
    local voidY = tonumber(_G.StickyVoidY) or -50
    return hrp.Position.Y < voidY
end
function _waitOutOfVoid(timeout)
    local t0 = os.clock()
    local good = 0
    while os.clock() - t0 < (timeout or 12) do
        if _G.StickyTPStop then return false end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Parent and not _inVoid(hrp) and math.abs(hrp.AssemblyLinearVelocity.Y) < 12 then
            good += 1
            if good >= 4 then return true end
        else
            good = 0
        end
        RunService.Heartbeat:Wait()
    end
    return false
end

do
    local lastSafe = nil
    local recovering = false
    local _voidTick = 0
    RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        _voidTick = _voidTick + 1
        if _voidTick < 2 then return end
        _voidTick = 0
        if _G.StickyVoidRecover == false then return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return end
        local voidY = tonumber(_G.StickyVoidY) or -50
        if hrp.Position.Y >= voidY then
            if math.abs(hrp.AssemblyLinearVelocity.Y) < 40 then
                lastSafe = hrp.Position
            end
            return
        end
        if recovering or not lastSafe then return end
        recovering = true

        pcall(function()
            _vzL(hrp)
            _vzA(hrp)
            hrp.CFrame = CFrame.new(lastSafe + Vector3.new(0, 5, 0))
        end)
        task.spawn(function()
            local delay = tonumber(_G.StickyVoidRecoverDelay) or 0
            if delay > 0 then task.wait(delay) end
            local vy = tonumber(_G.StickyVoidY) or -50
            local tries = 0
            while tries < 80 do
                local c = LP.Character
                local h = c and c:FindFirstChild("HumanoidRootPart")
                if not h or not h.Parent then break end
                if h.Position.Y >= vy and math.abs(h.AssemblyLinearVelocity.Y) < 18 then
                    break
                end
                if lastSafe then
                    pcall(function()
                        _vzL(h)
                        _vzA(h)
                        h.CFrame = CFrame.new(lastSafe + Vector3.new(0, 5, 0))
                    end)
                end
                tries = tries + 1
                RunService.Heartbeat:Wait()
            end
            recovering = false
        end)
    end))
end

isTeleporting = false

task.spawn(function()
    local _since = nil
    while true do
        task.wait(1)
        if isTeleporting then
            _since = _since or os.clock()
            if os.clock() - _since > (tonumber(_G.StickyTPWatchdog) or 25) then
                isTeleporting = false
                _G.StickyStealHold = false
                _since = nil
                if _G.StickyTPDebug == true then
                    
                end
            end
        else
            _since = nil
        end
    end
end)

_G.StickyDoClone = doClone
_G.StickyIsTeleporting = function() return isTeleporting end

function cframeStepThrough(hrp, waypoints, stepSize)
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    stepSize = stepSize or 24
    local lockY = hrp.Position.Y
    vizPath(hrp.Position, waypoints)
    local wpIdx = 1
    local deadline = os.clock() + 10
    local _lastFire = 0
    while hrp and hrp.Parent and os.clock() < deadline do
        if _G.StickyTPStop then break end
        do
            local char = hrp.Parent
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and char and not char:FindFirstChild("Grapple Hook") then
                local g = findGrapple()
                if g then pcall(function() hum:EquipTool(g) end) end
            end
            if os.clock() - _lastFire > 0.3 then
                _lastFire = os.clock()
                if char and char:FindFirstChild("Grapple Hook") then
                    (function()
            if type(_G.StickyFireGrapple2) == "function" then
                return _G.StickyFireGrapple2()
            elseif type(fireGrapple) == "function" then
                return fireGrapple()
            end
            return false
        end)()
                end
            end
        end
        local target = waypoints[wpIdx]
        local flat = Vector3.new(target.X - hrp.Position.X, 0, target.Z - hrp.Position.Z)
        local mag = flat.Magnitude
        if mag < 2 then
            wpIdx = wpIdx + 1
            if wpIdx > #waypoints then break end
            RunService.Heartbeat:Wait()
        else
            local hop = math.min(stepSize, mag)
            local nextPos = hrp.Position + flat.Unit * hop
            local _, y = hrp.CFrame:ToEulerAnglesYXZ()
            hrp.CFrame = CFrame.new(Vector3.new(nextPos.X, lockY, nextPos.Z)) * CFrame.Angles(0, y, 0)
            _vzL(hrp)
            _vzA(hrp)
            task.wait(hop / math.clamp(tonumber(_G.StickyCFrameSpeed) or 450, 60, 900))
        end
    end
    do
        local hum = hrp and hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:UnequipTools() end) end
        task.wait(0.05)
        equipCarpet()
    end
    if hrp and hrp.Parent then
        _vzL(hrp)
        _vzA(hrp)
    end
end

function _isStraightRoute(fromPos, route)
    if not route or #route <= 1 then return true end
    local turns, lastDir, prev = 0, nil, fromPos
    for _, wp in ipairs(route) do
        local seg = wp - prev
        if seg.Magnitude > 1 then
            local dir = seg.Unit
            if lastDir and dir:Dot(lastDir) < 0.94 then turns = turns + 1 end
            lastDir = dir
        end
        prev = wp
    end
    return turns <= (tonumber(_G.StickyStraightMaxTurns) or 1)
end

local _StickyAnimRestoreAt = 0
local function restoreAnimations()
    _StickyAnimRestoreAt = os.clock() + 3
    task.spawn(function()
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local animate = char:FindFirstChild("Animate")
        if animate then pcall(function() animate.Disabled = false end) end
        if hum then
            pcall(function() hum.AutoRotate = true end)
            local animator = hum:FindFirstChildOfClass("Animator")
            if animator then
                pcall(function()
                    local tracks = animator:GetPlayingAnimationTracks()
                    if tracks then
                        for _, t in ipairs(tracks) do
                            if t.Priority == Enum.AnimationPriority.Core
                               or t.Priority == Enum.AnimationPriority.Idle then
                                pcall(function() t:Play(0.1) end)
                            end
                        end
                    end
                end)
            end
        end
    end)
end

local _tpSavedCollide = {}
local function _tpPhaseOn(char)
    if not char then return end
    _tpSavedCollide = {}
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") and d.CanCollide then
            _tpSavedCollide[d] = true
            pcall(function() d.CanCollide = false end)
        end
    end
    if not char:GetAttribute("_StickyTpPhaseHook") then
        char:SetAttribute("_StickyTpPhaseHook", true)
        char.DescendantAdded:Connect(function(d)
            if isTeleporting and d:IsA("BasePart") and d.CanCollide then
                _tpSavedCollide[d] = true
                pcall(function() d.CanCollide = false end)
            end
        end)
    end
end
local function _tpPhaseOff()
    for p, _ in pairs(_tpSavedCollide) do
        if p and p.Parent then pcall(function() p.CanCollide = true end) end
    end
    _tpSavedCollide = {}
end
_G.StickyTPPhaseOn = _tpPhaseOn
_G.StickyTPPhaseOff = _tpPhaseOff

task.spawn(function()
    local was = false
    while true do
        local now = isTeleporting == true
        if was and not now then
            pcall(_tpPhaseOff)
        end
        was = now
        task.wait(0.05)
    end
end)

function doVelocityTP(forceGrapple)
    if isTeleporting then return end
    if LP:GetAttribute("Stealing") == true then return end
    isTeleporting = true
    _G.StickyTPStop = false
    if LP:GetAttribute("Stealing") == true or _G.StickyTPStop == true then
        isTeleporting = false
        return
    end
    if _G.StickyDisarmSteal then _G.StickyDisarmSteal() end
    pcall(function()
        local c = LP.Character
        if c then _tpPhaseOn(c) end
    end)
    if not NetModule then pcall(loadNet) end

    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then isTeleporting = false; return end

    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)

    if forceGrapple or _G.StickyAlwaysGrapple ~= false then
        if type(fireGrappleBeforeTP) == "function" then
            pcall(fireGrappleBeforeTP)
        elseif type(_G.StickyFireGrapple2) == "function" then
            pcall(_G.StickyFireGrapple2)
        elseif type(fireGrapple) == "function" then
            pcall(fireGrapple)
        end
    end

    if _inVoid(hrp) then
        if _G.StickyTPStop then isTeleporting = false; return end
        char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then isTeleporting = false; return end
    end

    local allPets = scanForTP()
    if #allPets == 0 then
        local _t0 = os.clock()
        while #allPets == 0 and os.clock() - _t0 < (tonumber(_G.StickyTPScanWait) or 3) do
            task.wait(0.03)
            allPets = scanForTP()
        end
    end
    if #allPets == 0 then isTeleporting = false; return end

    if _G.StickyFullScanFirst ~= false then
        local _fs0 = os.clock()
        local _fcap = tonumber(_G.StickyFullScanWait) or 0.8
        local _stale = tonumber(_G.StickyScanStaleGap) or 0.2
        local _prev = tonumber(_G.StickyScanNoChan) or 0
        local _lastProg = os.clock()
        while (tonumber(_G.StickyScanNoChan) or 0) > 0
            and os.clock() - _fs0 < _fcap do
            if _G.StickyTPStop then break end
            task.wait(0.03)
            allPets = scanForTP()
            local _now = tonumber(_G.StickyScanNoChan) or 0
            if _now < _prev then
                _prev, _lastProg = _now, os.clock()
            elseif os.clock() - _lastProg >= _stale then
                break
            end
        end
        if (tonumber(_G.StickyScanNoChan) or 0) > 0 then

        end
    end

    if not (type(_G.StickyStealTargetUID) == "string" and _G.StickyStealTargetUID ~= "") then
        local pool, seen = {}, {}
        local function _absorb(list)
            if type(list) ~= "table" then return end
            for _, p in ipairs(list) do
                if not p.conveyor and p.plot and p.slot ~= nil then
                    local uid = tostring(p.plot) .. "_" .. tostring(p.slot)
                    local ex = seen[uid]
                    if not ex then
                        seen[uid] = p
                        pool[#pool + 1] = p
                    elseif (p.mps or 0) > (ex.mps or 0) then
                        for i = 1, #pool do
                            if pool[i] == ex then pool[i] = p break end
                        end
                        seen[uid] = p
                    end
                end
            end
        end
        _absorb(allPets)
        for _ = 1, (tonumber(_G.StickyTPScans) or 1) do
            task.wait(tonumber(_G.StickyTPScanGap) or 0.03)
            local _ok, _more = pcall(scanForTP)
            if _ok then _absorb(_more) end
        end
        if #pool > 0 then allPets = pool end
    end

    local pet
    if type(_G.StickyStealTargetUID) == "string" and _G.StickyStealTargetUID ~= "" then
        pet = _findStealTarget(allPets)
        if not pet then isTeleporting = false; return end
    else
        local prio, best
        for _, p in ipairs(allPets) do
            if not p.conveyor then
                if p._pri and (not prio or p._pri < prio._pri) then prio = p end
                if not best or (p.mps or 0) > (best.mps or 0) then best = p end
            end
        end
        pet = prio or best or allPets[1]
    end
    local petPos = pet.position
    local petName = pet.name
    if _G.StickyArmSteal then pcall(_G.StickyArmSteal, pet) end

    _G.StickyStealHold = true

    local _hasCarpet = false
    do
        local _c = LP.Character
        if _c then
            for _, _n in ipairs(CARPET_NAMES) do
                if _c:FindFirstChild(_n) then _hasCarpet = true break end
            end
        end
    end
    if not _hasCarpet then
        pcall(fireGrapple)
    end

    local adjY = petPos.Y
    if TALL_PETS[petName] then adjY = petPos.Y - TALL_OFFSET end
    local coordTable = adjY > 23.15 and MK_UPPER or MK_LOWER

    if petPos.Y <= 8.9 and isPlotUnlocked(pet.plot) then
        if not _hasCarpet then carpetEngage(forceGrapple) end
        vZero(hrp)
        local _to = Vector3.new(petPos.X, -4, petPos.Z)
        local route = _stickySafeRoute(hrp.Position, _to, nil, _G.StickyHybridTP == true)
        if not route or #route == 0 then route = { _to } end
        local _straight = _isStraightRoute(hrp.Position, route)
        local _obSpeed = math.clamp(tonumber(_G.TPVelocity) or 400, 200, 750)
        if _straight then
            _obSpeed = math.clamp(tonumber(_G.StickyStraightSpeed) or 300, 100, 500)
        end
        do
            local _len, _prev = 0, hrp.Position
            for _, wp in ipairs(route) do _len = _len + (wp - _prev).Magnitude; _prev = wp end
            if _len < 100 then
                _obSpeed = math.clamp(tonumber(_G.StickyCloseSpeed) or 80, 20, 400)
            end
        end
        _obSpeed = _pingAdjustSpeed(_obSpeed)
        velMoveThrough(hrp, route, _obSpeed, true, true)
        if hrp and hrp.Parent then
            _vzL(hrp)
            _vzA(hrp)
        end
        _G.StickyStealHold = false
        isTeleporting = false
        if _G.StickyTPStop then return end
        return
    end

    local closestData, skyKey = findClosest(petPos, coordTable)
    if not closestData or not skyKey then _G.StickyStealHold = false; isTeleporting = false; return end

    local destPos = closestData.coord

    local _carpet = _hasCarpet and (function()
        local _c = LP.Character
        if _c then
            for _, _n in ipairs(CARPET_NAMES) do
                if _c:FindFirstChild(_n) then return _n end
            end
        end
        return nil
    end)() or carpetEngage(forceGrapple)
    vZero(hrp)

    local facingDir = closestData.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)

    local _frontApproach = false
    do
        local isUpper = (coordTable == MK_UPPER)
        local idx = getClosestBaseIdx(petPos)
        local frontCoord, frontFace = buildFrontCandidate(idx, isUpper, hrp.Position.Z)
        local bestCoord, bestFace = frontCoord, frontFace
        local bestDist = (hrp.Position - frontCoord).Magnitude
        local pickedFront = true
        local targetLaserActive = _stickyPlotHasActiveLaser(pet.plot)

        local _tb = BASES_LOW[idx]
        local _isWest = idx <= 4
        local _rowBlocked = false
        local _dx, _dz = hrp.Position.X - _tb.X, hrp.Position.Z - _tb.Z
        local _distToBase = math.sqrt(_dx * _dx + _dz * _dz)
        local _sideRange = tonumber(_G.StickySideTPRange) or 100
        if _G.StickyPreferFrontOnRow ~= false and _distToBase > _sideRange then
            for i = 1, 8 do
                if i ~= idx and (i <= 4) == _isWest then
                    local bz = BASES_LOW[i].Z
                    if (bz - hrp.Position.Z) * (bz - _tb.Z) < 0 then _rowBlocked = true; break end
                end
            end
        end

        local sideCandidates = {}
        for _, d in ipairs(plotSides(coordTable, idx)) do
            local overlapsLaser = targetLaserActive and _stickyPositionNearLaser(d.coord, pet.plot, 1.5)
            if not overlapsLaser then
                sideCandidates[#sideCandidates + 1] = d
            end
        end

        -- When side TP is enabled, aim for one of the side approach coordinates instead of
        -- defaulting to the front of a base. Active laser gates always require a safe side.
        local forceSide = (_G.StickySideTP == true) or targetLaserActive
        if forceSide then
            local nearestSide, nearestSideDist
            for _, d in ipairs(sideCandidates) do
                local dd = (hrp.Position - d.coord).Magnitude
                if nearestSideDist == nil or dd < nearestSideDist then
                    nearestSide, nearestSideDist = d, dd
                end
            end
            if nearestSide then
                bestCoord = nearestSide.coord
                bestFace = nearestSide.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)
                pickedFront = false
            elseif targetLaserActive then
                -- Do not fall back to cloning directly at an active laser gate.
                _G.StickyStealHold = false
                isTeleporting = false
                warn("[Sticky] No safe side coordinate found; skipping clone at active laser gate.")
                return
            end
        elseif not _rowBlocked then
            for _, d in ipairs(sideCandidates) do
                local dd = (hrp.Position - d.coord).Magnitude
                if dd < bestDist then
                    bestDist = dd
                    bestCoord = d.coord
                    bestFace = d.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)
                    pickedFront = false
                end
            end
        end
        destPos = bestCoord
        facingDir = bestFace
        _frontApproach = pickedFront
        if _G.StickyTPDebug == true then
            
        end
    end

    if facingDir and facingDir.Magnitude > 0.1 then
        local axis = facingDir.Unit
        local toPlayer = hrp.Position - destPos
        local sign = (axis:Dot(toPlayer) >= 0) and 1 or -1
        destPos = destPos + axis * sign * (tonumber(_G.StickyCloneBackoff) or 0.5)
    end
    local _route = _stickySafeRoute(hrp.Position, destPos, facingDir, _G.StickyCrestRoute == true or _G.StickyHybridTP == true)

    local ASCEND_STEP = 10
    local _stepped = {}
    do
        local prev = hrp.Position
        for _, wp in ipairs(_route) do
            local dy = wp.Y - prev.Y
            if dy > ASCEND_STEP * 1.5 then
                local n = math.ceil(dy / ASCEND_STEP)
                for s = 1, n - 1 do
                    local t = s / n
                    _stepped[#_stepped + 1] = Vector3.new(
                        prev.X + (wp.X - prev.X) * t,
                        prev.Y + dy * t,
                        prev.Z + (wp.Z - prev.Z) * t
                    )
                end
            end
            _stepped[#_stepped + 1] = wp
            prev = wp
        end
    end
    local _mainSpeed = math.clamp(tonumber(_G.TPVelocity) or 400, 200, 750)
    local _targetIdx = getClosestBaseIdx(petPos)
    local _targetIsWest = _targetIdx <= 4
    local _playerIsWest = hrp.Position.X < COLUMN_SPLIT_X
    local _crossRow = _targetIsWest ~= _playerIsWest
    local _isLower = coordTable == MK_LOWER
    local _toTarget = (petPos - hrp.Position).Unit
    local _lookDir = hrp.CFrame.LookVector
    local _dot = _toTarget:Dot(_lookDir)
    local _isBehind = _dot < -0.3
    local _isProblemTP = _crossRow and _frontApproach and _isLower and _isBehind
    do
        local _len, _prev = 0, hrp.Position
        for _, wp in ipairs(_route) do _len = _len + (wp - _prev).Magnitude; _prev = wp end
        if _len < 100 then
            _mainSpeed = math.clamp(tonumber(_G.StickyCloseSpeed) or 80, 20, 400)
        end
        if _isProblemTP and _G.StickySlowCrossRow == true then
            _mainSpeed = math.clamp(tonumber(_G.StickyProblemBaseSpeed) or 60, 20, 400)
        end
    end
    _mainSpeed = _pingAdjustSpeed(_mainSpeed)
    velMoveThrough(hrp, _stepped, _mainSpeed, true, true)
    if _G.StickyTPStop then
        if hrp and hrp.Parent then vZero(hrp) end
        _G.StickyStealHold = false
        isTeleporting = false
        return
    end

    do
        local above = destPos + Vector3.new(0, 16, 0)
        local _t0 = os.clock()
        local _lastJump = 0
        while os.clock() - _t0 < 1.5 do
            if not hrp or not hrp.Parent then break end
            if LP:GetAttribute("Stealing") or _G.StickyTPStop then break end
            equipCarpet()
            local d = above - hrp.Position
            local flat = Vector3.new(d.X, 0, d.Z).Magnitude
            if flat <= 3 and hrp.Position.Y >= destPos.Y then break end
            if d.Y > 3 and (os.clock() - _lastJump) > 0.5 then
                local _hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if _hum then
                    local st = _hum:GetState()
                    if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() _hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() _hum.Jump = true end)
                        _lastJump = os.clock()
                    end
                end
            end
            _setFlightVel(hrp, d.Unit * math.min(math.max(d.Magnitude * 8, 55), 320))
            _vzA(hrp)
            RunService.Heartbeat:Wait()
        end
    end

    do
        local _runCap = _frontApproach and (tonumber(_G.StickyFrontRunIn) or 130) or 400
        local _t0 = os.clock()
        local _bestMag, _bestT = math.huge, os.clock()
        local _lastJump = 0
        while os.clock() - _t0 < 4 do
            if not hrp or not hrp.Parent then break end
            if LP:GetAttribute("Stealing") or _G.StickyTPStop then break end
            equipCarpet()
            local diff = destPos - hrp.Position
            local mag = diff.Magnitude
            if mag <= 3 then break end
            if mag < _bestMag - 0.5 then _bestMag = mag; _bestT = os.clock()
            elseif os.clock() - _bestT > 0.6 then break end
            if diff.Y > 3 and mag > 15 and (os.clock() - _lastJump) > 0.5 then
                local _hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if _hum then
                    local st = _hum:GetState()
                    if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() _hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() _hum.Jump = true end)
                        _lastJump = os.clock()
                    end
                end
            end
            _setFlightVel(hrp, diff.Unit * math.min(math.max(mag * 8, 55), _runCap))
            _vzA(hrp)
            RunService.Heartbeat:Wait()
        end
    end

    if hrp and hrp.Parent and not _G.StickyTPStop then
        local _flatOff = Vector3.new(destPos.X - hrp.Position.X, 0, destPos.Z - hrp.Position.Z).Magnitude
        if _flatOff > 10 then
            if _G.StickyTPDebug == true then
                
            end
            local _rr = (_stepped and #_stepped > 0) and _stepped or { destPos }
            velMoveThrough(hrp, _rr, _mainSpeed, true, true)
            if hrp and hrp.Parent then
                _vzL(hrp)
                _vzA(hrp)
            end
        end
    end

    local _anchoredForAirEndpoint = false
    local _wasAnchoredAtEndpoint = false
    local _endpointFloor = tonumber(pet.slot) and ((tonumber(pet.slot) >= 19 and 3)
        or (tonumber(pet.slot) >= 11 and 2) or 1) or nil
    if not _endpointFloor then
        if petPos.Y > 23.15 then _endpointFloor = 3
        elseif petPos.Y >= 11 then _endpointFloor = 2
        else _endpointFloor = 1 end
    end
    local _upperFloorEndpoint = _endpointFloor == 2 or _endpointFloor == 3
    if hrp and hrp.Parent and hum and (_upperFloorEndpoint or hum.FloorMaterial == Enum.Material.Air) then
        _wasAnchoredAtEndpoint = hrp.Anchored
        _anchoredForAirEndpoint = true
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.Anchored = true
        end)
    end
    if hrp and hrp.Parent then
        if _anchoredForAirEndpoint then
            hrp.CFrame = CFrame.new(destPos, destPos + facingDir)
        else
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + facingDir)
        end
        _stickyHybridFaceBack(hrp, destPos)
    end
    vZero(hrp)

    local syncFrames = 3
    local syncConn
    syncConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if not hrp or not hrp.Parent then syncConn:Disconnect(); return end
        syncFrames = syncFrames - 1
        hrp.CFrame = CFrame.new(destPos, destPos + facingDir)
        _stickyHybridFaceBack(hrp, destPos)
        _vzL(hrp)
        _vzA(hrp)
        if syncFrames <= 0 then syncConn:Disconnect() end
    end))
    if _anchoredForAirEndpoint then
        repeat RunService.Heartbeat:Wait() until syncFrames <= 0 or not hrp or not hrp.Parent
        if hrp and hrp.Parent then
            pcall(function() hrp.Anchored = _wasAnchoredAtEndpoint end)
        end
    end

    local _landTries = tonumber(_G.StickyMaxLandTries) or 3
    local _landGap   = tonumber(_G.StickyLandCheckGap) or 0.03
    for _ = 1, _landTries do
        task.wait(_landGap)
        if hum.FloorMaterial ~= Enum.Material.Air then break end
    end

    do
        local stable, _st0 = 0, os.clock()
        local _cap = tonumber(_G.StickyStableWait) or 0.3
        while os.clock() - _st0 < _cap do
            if _G.StickyTPStop then break end
            local _hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not _hrp or not _hrp.Parent then break end
            local flat = (Vector3.new(_hrp.Position.X, 0, _hrp.Position.Z) - Vector3.new(destPos.X, 0, destPos.Z)).Magnitude
            if flat <= 3.5 and math.abs(_hrp.Position.Y - destPos.Y) <= 4 then
                stable = stable + 1
                if stable >= 2 then break end
            else
                stable = 0
                pcall(function()
                    _hrp.CFrame = CFrame.new(destPos, destPos + facingDir)
                    _stickyHybridFaceBack(_hrp, destPos)
                end)
                _vzL(_hrp)
                _vzA(_hrp)
            end
            RunService.Heartbeat:Wait()
        end
    end
    local _ahrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local _clonePos = (_ahrp and _ahrp.Parent and _ahrp.Position) or destPos

    local _clonePlat = Instance.new("Part")
    _clonePlat.Name = "StickyHubClonePlatform"
    _clonePlat.Size = Vector3.new(12, 1, 12)
    _clonePlat.Position = Vector3.new(_clonePos.X, _clonePos.Y - 3, _clonePos.Z)
    _clonePlat.Anchored = true
    _clonePlat.CanCollide = true
    _clonePlat.Transparency = 1
    _clonePlat.Material = Enum.Material.SmoothPlastic
    _clonePlat.Parent = workspace

    if _ahrp and _ahrp.Parent then
        _vzL(_ahrp)
        _vzA(_ahrp)
    end

    local _preClonePos, _preCloneChar
    do
        _preCloneChar = LP.Character
        local _h = _preCloneChar and _preCloneChar:FindFirstChild("HumanoidRootPart")
        _preClonePos = _h and _h.Position or destPos
    end
    local _charAdded = false
    local _caConn = LP.CharacterAdded:Connect(function() _charAdded = true end)

    _G.StickyStealHold = false
    if facingDir and facingDir.Magnitude > 0.1 then
        local _pinHum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if _pinHum then pcall(function() _pinHum.AutoRotate = false end) end
        for _ = 1, 2 do
            local _h = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not _h or not _h.Parent then break end
            pcall(function()
                _h.CFrame = CFrame.new(_h.Position, _h.Position + facingDir)
                _stickyHybridFaceBack(_h, destPos)
                _vzL(_h)
                _vzA(_h)
            end)
            RunService.Heartbeat:Wait()
        end
    end

    local _cloneOk = doClone()
    if _clonePlat then pcall(function() _clonePlat:Destroy() end); _clonePlat = nil end
    do
        local _t0 = os.clock()
        repeat
            if _charAdded then break end
            if LP.Character ~= _preCloneChar then break end
            local _h = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if _h then
                local _dx = _h.Position.X - _preClonePos.X
                local _dz = _h.Position.Z - _preClonePos.Z
                local _dy = _h.Position.Y - _preClonePos.Y
                if (_dx * _dx + _dz * _dz) > 4 then break end
                if _dy * _dy > 1 then break end
            end
            RunService.Heartbeat:Wait()
        until os.clock() - _t0 > (tonumber(_G.StickyCloneSettle) or 0.6)
    end
    if _caConn then _caConn:Disconnect() end

    pcall(function()
        local _rh = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if _rh then _rh.AutoRotate = true end
    end)

    task.wait(0.1)
    goToBrainrot(petPos, pet and pet.slot)
    isTeleporting = false
    if _G.StickyTPStop then return end
    if _G.StickyArmSteal then pcall(_G.StickyArmSteal, pet) end
    restoreAnimations()
end

local _stickyDoVelocityTPCore = doVelocityTP
function doVelocityTP(forceGrapple)
    -- Recover stale locks left behind by an interrupted/erroring teleport.
    local now = os.clock()
    if isTeleporting == true and tonumber(_G.StickyTPStartedAt)
        and now - _G.StickyTPStartedAt > 25 then
        isTeleporting = false
        _G.StickyTPBusy = false
        _G.Sticky_TpActive = false
        _G.StickyStealHold = false
        pcall(function() if type(_G.StickyTPPhaseOff) == "function" then _G.StickyTPPhaseOff() end end)
    end
    if isTeleporting == true then return false end
    local wasBusy = _G.StickyTPBusy
    _G.StickyTPBusy = true
    _G.StickyTPStartedAt = now
    local ok, result = pcall(function()
        return _stickyDoVelocityTPCore(forceGrapple)
    end)
    -- Always release the wrapper lock, including when the core throws.
    _G.StickyTPBusy = false
    _G.StickyTPStartedAt = nil
    if not ok then
        isTeleporting = false
        _G.Sticky_TpActive = false
        _G.StickyStealHold = false
        pcall(function() if type(_G.StickyTPPhaseOff) == "function" then _G.StickyTPPhaseOff() end end)
        warn("[Sticky TP] Teleport failed; lock cleared: " .. tostring(result))
        return false
    end
    if isTeleporting == true then
        -- Core normally clears this itself. Avoid permanent lock if it returned early.
        isTeleporting = false
    end
    _G.StickyTPStartedAt = nil
    return result
end

_manualTPBusy = false
function manualFullTP()
    local now = os.clock()

    -- Only clear a lock when its owner has exceeded the watchdog window.
    -- A fresh in-progress teleport must never be interrupted by a second click.
    local startedAt = tonumber(_G.StickyTPStartedAt)
    if (isTeleporting == true or _G.StickyTPBusy == true or _G.Sticky_TpActive == true)
        and startedAt and now - startedAt > (tonumber(_G.StickyTPWatchdog) or 25) then
        isTeleporting = false
        _G.StickyTPBusy = false
        _G.Sticky_TpActive = false
        _G.StickyStealHold = false
        _G.StickyTPStartedAt = nil
        pcall(function()
            if type(_G.StickyTPPhaseOff) == "function" then _G.StickyTPPhaseOff() end
        end)
    end

    if _manualTPBusy or isTeleporting == true or _G.StickyTPBusy == true then
        return false
    end
    _manualTPBusy = true
    local okAll, result = pcall(function()
        if _G.StickyScanProfile and _G.StickyScanMode == "fast" then
            pcall(_G.StickyScanProfile, "normal")
        end

        -- Sometimes the game is still clearing Stealing for a few frames after
        -- a clone/reset. Wait briefly instead of silently consuming the click.
        local waitStart = os.clock()
        while LP:GetAttribute("Stealing") == true and os.clock() - waitStart < 2.5 do
            task.wait(0.1)
        end
        if LP:GetAttribute("Stealing") == true then
            warn("[Sticky TP] Still marked as Stealing; try again after the state clears.")
            return false
        end

        local lastError
        for attempt = 1, 3 do
            if isTeleporting == true or _G.StickyTPBusy == true then
                -- Another TP started between attempts; don't start a competing one.
                return false
            end

            local scanOk, pets = pcall(scanForTP)
            if not scanOk then
                lastError = pets
                warn("[Sticky TP] Target scan failed (attempt " .. attempt .. "): " .. tostring(pets))
            elseif pets and #pets > 0 then
                -- Give the target list one short settle pass, but don't require it
                -- to be identical forever; moving/updated slots can reorder it.
                task.wait(0.08)
                local tpOk, tpResult = pcall(doVelocityTP, true)
                if tpOk and tpResult ~= false then
                    return true
                end
                lastError = tpOk and "teleport routine returned false" or tpResult
                warn("[Sticky TP] Attempt " .. attempt .. " failed: " .. tostring(lastError))
            else
                lastError = "no valid targets found"
                warn("[Sticky TP] No targets found (attempt " .. attempt .. ")")
            end
            task.wait(0.18 * attempt)
        end
        if lastError then warn("[Sticky TP] Gave up after retries: " .. tostring(lastError)) end
        return false
    end)

    -- Always release the manual-click guard, even if scanning or TP throws.
    _manualTPBusy = false
    if not okAll then
        warn("[Sticky TP] Manual teleport handler error: " .. tostring(result))
        if tonumber(_G.StickyTPStartedAt) and os.clock() - _G.StickyTPStartedAt > 25 then
            isTeleporting = false
            _G.StickyTPBusy = false
            _G.Sticky_TpActive = false
            _G.StickyStealHold = false
            _G.StickyTPStartedAt = nil
        end
        return false
    end
    return result == true
end
_G.StickyStartSideTP = manualFullTP

if type(_G.SHARED_PRIORITY_ITEMS) ~= "table" or #_G.SHARED_PRIORITY_ITEMS == 0 then
_G.SHARED_PRIORITY_ITEMS = {
    "Headless Horseman","Strawberry Elephant","Signore Carapace","John Pork","Meowl",
    "Elefanto Frigo","Arcadragon","Skibidi Toilet","Griffin","Antonio",
    "Dragon Aquanini","Dragon Gingerini","Love Love Bear","Kalika Bros","Moby Bros",
    "Grabatron","Jelly Moby","La Supreme Combinasion","Ginger Gerat","Digi Narwhal",
    "Hydra Dragon Cannelloni","Hydra Bunny","Bunny and Eggy","Kraken","Fishino Clownino",
    "Tirilikalika Tirilikalako","Pancake and Syrup","Dragon Cannelloni","Sammyni Cakini","Ketupat Bros",
    "Bumbatron","Venuspino","Dug dug dug","La Casa Boo","Rico Dinero",
    "Foxini Lanternini","Duggy Bros","Rosey and Teddy","Globa Steppa","Los Hackers",
    "Cerberus","Fragrama and Chocrama","Cooki and Milki","La Secret Combinasion","Burguro and Fryuro",
    "Capitano Moby","Spooky and Pumpky","Garama and Madundung","Popcuru and Fizzuru","Pizza and Ranch",
    "Reinito Sleighito","Tenini Ballini","Fragola La La La","Ketchuru and Musturu","Tralaledon",
    "Tictac Sahur","Ketupat Kepat","Tang Tang Keletang","Orcaledon","La Ginger Sekolah",
    "Los Spaghettis","Lavadorito Spinito","Swaggy Bros","La Taco Combinasion","Los Primos",
    "Los Chillis","Chillin Chili","Tuff Toucan","W or L","Chipso and Queso",
    "Guest 666","Money Money Reindeer","Quackini Snackini","Los Sekolahs","Los Tacoritas",
    "Los Amigos","Fortunu and Cashuru","Jolly Jolly Sahur","Boppin Bunny","Gym Bros",
    "Los Cupids","Festive 67","Celularcini Viciosini","Cloverat Clapat","La Food Combinasion",
    "Hopilikalika Hopilikalako","Celestial Pegasus","Sammyni Fattini","Money Money Bros","La Spooky Grande",
    "Cash or Card","Swag Soda","Los Planitos","Lovin Rose","Tacorita Bicicleta",
    "Los Jolly Combinasionas","La Romantic Grande","La Easter Grande","Los Hotspotsitos","Rosetti Tualetti",
    "Los Bros","Gobblino Uniciclino","Chicleteira Cupideira","La Extinct Grande","Las Sis",
    "Nacho Spyder","Gold Gold Gold","Los Mariachis","Snailo Clovero","La Jolly Grande",
    "Los Candies","Churrito Bunnito","Bananito","Eviledon","Los 67",
    "Los Sweethearts","Noo my Heart","La Lucky Grande","Ventoliero Pavonero","Baskito",
    "Chimnino","Los Puggies","Camera Ramena","Los 25","Spinny Hammy",
    "Money Money Puggy","Cigno Fulgoro","Los Spooky Combinasionas","Chicleteira Noelteira","Mariachi Corazoni",
    "Tacorillo Crocodillo","Noo my Gold","Los Mobilis","Mieteteira Bicicleteira","DJ Panda",
    "Los Combinasionas","Nuclearo Dinossauro","Bacuru and Egguru","Spaghetti Tualetti","La Grande Combinasion",
    "Esok Sekolah",
}
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if input.KeyCode == Enum.KeyCode.V then
        task.spawn(function() pcall(doClone) end)
    end
    local want = _G._stp_tpKeyName
    if type(want) ~= "string" or want == "" then want = "T" end
    if input.KeyCode.Name == want then
        task.spawn(function() pcall(manualFullTP) end)
    end
end)

task.spawn(function() pcall(loadModules) pcall(loadNet) end)
task.spawn(function()
    pcall(function()
        local R = game:GetService("ReplicatedStorage")
        local d = R:FindFirstChild("Datas") or R:WaitForChild("Datas", 3)
        if d then
            local a = d:FindFirstChild("Animals") or d:WaitForChild("Animals", 3)
            if a then _AD = require(a) end
            local m = d:FindFirstChild("Mutations") or d:WaitForChild("Mutations", 3)
            if m then _MD = require(m) end
            local t = d:FindFirstChild("Traits") or d:WaitForChild("Traits", 3)
            if t then _TD = require(t) end
        end
    end)
end)
task.spawn(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
    task.wait(0.2)
    for _ = 1, 8 do
        pcall(scanAllPetsCached, 0)
        task.wait(0.08)
    end
    while true do
        pcall(scanAllPetsCached, 0.3)
        task.wait(0.2)
    end
end)

_G.StickyChannelsReady = false

task.spawn(function()
    local char = LP.Character or LP.CharacterAdded:Wait()
    char:WaitForChild("HumanoidRootPart", 10)
    char:WaitForChild("Humanoid", 10)
    pcall(loadModules)
    if _G.StickyAutoTP == false then return end
    task.defer(function()
        if _G.StickyAutoTP ~= false and not isTeleporting then
            pcall(doVelocityTP, true)
        end
    end)

    local _carpetDone = false
    task.spawn(function()
        local _tw = os.clock()
        while os.clock() - _tw < 12 do
            for _, n in ipairs(CARPET_NAMES) do
                if findTool(n) then pcall(carpetEngage, _G.StickyJoinGrapple ~= false) _carpetDone = true return end
            end
            task.wait(0.05)
        end
        _carpetDone = true
    end)

    local _toolsReady = false
    task.spawn(function()
        if _G.StickyWaitForTools ~= false and type(_G.StickyToolsReady) == "function" then
            local _tt0 = os.clock()
            local _tcap = tonumber(_G.StickyToolWait) or 6
            while os.clock() - _tt0 < _tcap do
                local ok, ready = pcall(_G.StickyToolsReady)
                if ok and ready then break end
                if _G.StickyAutoTP == false then return end
                task.wait(tonumber(_G.StickyToolPoll) or 0.02)
            end
        end
        _toolsReady = true
    end)

    local function _channelsProgress()
        local Plots = workspace:FindFirstChild("Plots")
        if not Plots then return 0, 0 end
        local kids = Plots:GetChildren()
        if #kids == 0 then return 0, 0 end
        local ready = 0
        for _, plot in ipairs(kids) do
            if getPlotChannel(plot.Name) then ready = ready + 1 end
        end
        return ready, #kids
    end

    local _bootT0 = os.clock()
    local _wMax = tonumber(_G.StickyAutoTPWait) or 4
    local _chanGrace = tonumber(_G.StickyChanGrace) or 0
    local _petsFound = nil
    local _lastTop = nil

    while os.clock() - _bootT0 < _wMax do
        if _G.StickyAutoTP == false then return end
        if LP:GetAttribute("Stealing") == true then return end

        local ready, total = _channelsProgress()
        local chanOk = (total == 0) or ready >= total
            or (total > 0 and ready >= math.max(0, total - _chanGrace))

        local ok, pets = pcall(scanForTP)
        if ok and pets and #pets > 0 then
            _petsFound = pets
            local top = tostring(pets[1].plot) .. "_" .. tostring(pets[1].slot)
            if chanOk and top == _lastTop then break end
            _lastTop = top
        end

        RunService.Heartbeat:Wait()
    end

    if _G.StickyAutoTP == false then return end

    local _wt0 = os.clock()
    while (not _carpetDone or not _toolsReady) and os.clock() - _wt0 < 3 do
        if _G.StickyAutoTP == false then return end
        task.wait(0.03)
    end

    pcall(doVelocityTP, true)
    if _G.StickyScanProfile then _G.StickyScanProfile("normal") end
end)

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

    local PG = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 20)

    local GUIHOST = (gethui and gethui()) or game:GetService("CoreGui")

    local function diag()
        pcall(loadModules)
        local Plots = workspace:FindFirstChild("Plots")
        local nPlots = Plots and #Plots:GetChildren() or 0
        local nCh, nOwn, nAl = 0,0,0
        if Plots then
            for _, plot in ipairs(Plots:GetChildren()) do
                local ch = getPlotChannel(plot.Name)
                if ch then
                    nCh = nCh + 1
                    if ownerInGame(ch) then nOwn = nOwn + 1 end
                    if channelGet(ch, "AnimalList") then nAl = nAl + 1 end
                end
            end
        end
        local pets = scanAllPetsCached(0.12)
        local ok = pets ~= nil
        local nPets = (ok and pets and #pets) or 0
        local msg = string.format("plots=%d ch=%d owner=%d animals=%d PETS=%d", nPlots, nCh, nOwn, nAl, nPets)
        
        if nPets > 0 and pets[1] then
            
        end
        return nPets
    end

    local _fspOverlap = OverlapParams.new()
    _fspOverlap.FilterType = Enum.RaycastFilterType.Exclude
    local function _promptWorldPos(p)
        local pp = p and p.Parent
        if not pp then return nil end
        if pp:IsA("Attachment") then return pp.WorldPosition end
        if pp:IsA("BasePart") then return pp.Position end
        return nil
    end
    local function findStealPrompt(pet)
        if not pet then return nil end
        local podPrompt
        if pet.plot and pet.slot then
            local plots = workspace:FindFirstChild("Plots")
            local plot = plots and plots:FindFirstChild(pet.plot)
            local podiums = plot and plot:FindFirstChild("AnimalPodiums")
            local podium = podiums and podiums:FindFirstChild(tostring(pet.slot))
            if podium then
                local base = podium:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                local attach = spawn and spawn:FindFirstChild("PromptAttachment")
                if attach then
                    for _, p in ipairs(attach:GetChildren()) do
                        if p:IsA("ProximityPrompt") then podPrompt = p break end
                    end
                end
                if not podPrompt then
                    podPrompt = podium:FindFirstChildWhichIsA("ProximityPrompt", true)
                end
            end
        end
        if pet.position then
            local pp = podPrompt and _promptWorldPos(podPrompt)
            if (not podPrompt) or (pp and (pp - pet.position).Magnitude > 15) then
                _fspOverlap.FilterDescendantsInstances = LP.Character and { LP.Character } or {}
                local okB, parts = pcall(workspace.GetPartBoundsInRadius, workspace, pet.position, 14, _fspOverlap)
                if okB and parts then
                    local best, bestD
                    for _, part in ipairs(parts) do
                        local pr = part:FindFirstChildOfClass("ProximityPrompt")
                        if not pr then
                            for _, ch in ipairs(part:GetChildren()) do
                                if ch:IsA("Attachment") then
                                    pr = ch:FindFirstChildOfClass("ProximityPrompt")
                                    if pr then break end
                                end
                            end
                        end
                        if pr then
                            local pos = _promptWorldPos(pr)
                            local d = pos and (pos - pet.position).Magnitude or math.huge
                            if not best or d < bestD then best, bestD = pr, d end
                        end
                    end
                    if best then return best end
                end
            end
        end
        return podPrompt
    end

    local InternalStealCache = {}
    local STEAL_HOLD_DURATION = 1.3
    local STEAL_PROXIMITY = tonumber(_G.StickyStealProximity) or 31
    local _stealHoldStart, _stealHoldActive = 0, false

    local _stealTarget, _stealArmedAt = nil, 0
    local _lastTargetPick, _lastPickUid, _currentTargetName = 0, nil, nil
    local _stealLastScan, _autoLastScan = 0, 0
    local _inRangeLast = 0
    local _armCheckAt = 0
    local _petsCache, _petsCacheAt = nil, 0

    local function _scanCached(now, maxAge)
        if _petsCache and (now - _petsCacheAt) <= (maxAge or 0.1) then return _petsCache end
        local pets = scanAllPetsCached(0.08)
        local ok = pets ~= nil
        if ok and type(pets) == "table" then
            _petsCache, _petsCacheAt = pets, now
            return pets
        end
        return nil
    end

    local function _petListed(plot, slot)
        local ch = getPlotChannel(plot)
        local al = ch and channelGet(ch, "AnimalList")
        if type(al) ~= "table" then return true, false end
        local e = al[slot]
        if e == nil then e = al[tonumber(slot) or -1] end
        if e == nil then e = al[tostring(slot)] end
        return e ~= nil, true
    end

    local function _prox()
        return tonumber(_G.StickyStealProximity) or STEAL_PROXIMITY
    end
    local STEAL_HOLD_MAX = 2.6
    local function _holdDur()
        if _G.StickyStealHoldFull == true then return STEAL_HOLD_MAX end
        local h = tonumber(_G.StickyStealHoldDuration) or STEAL_HOLD_DURATION
        if h < STEAL_HOLD_DURATION then h = STEAL_HOLD_DURATION elseif h > STEAL_HOLD_MAX then h = STEAL_HOLD_MAX end
        return h
    end

    local _cooldownUntil = 0
    local function _verifyFire(pet, path, judge)
        task.delay(tonumber(_G.StickyVerifyDelay) or 0.35, function()
            if not (pet and pet.plot and pet.slot ~= nil) then return end
            local listed, known = true, false
            pcall(function() listed, known = _petListed(pet.plot, pet.slot) end)
            if not known then return end
            if not listed then
                _G.StickyStealFails = 0
                _cooldownUntil = 0
                
                return
            end
            if not judge then _cooldownUntil = 0 return end

        end)
    end
    local function _holdBusy()
        return _stealHoldActive
    end

    local _armedPet, _armLostSince = nil, 0
    local function _armLivePos(p)
        if not (p and p.plot and p.slot ~= nil) then return nil end
        local plots = workspace:FindFirstChild("Plots")
        local plot = plots and plots:FindFirstChild(p.plot)
        if not plot then return nil end
        local ok, pos = pcall(getPetPosition, plot, p.slot)
        if ok then return pos end
        return nil
    end
    _G.StickyArmSteal = function(pet)
        if type(pet) ~= "table" or type(pet.plot) ~= "string" or pet.slot == nil then return end
        _armedPet = {
            name = pet.name, index = pet.index, mps = pet.mps, _pri = pet._pri,
            plot = pet.plot, slot = tostring(pet.slot), position = pet.position,
        }
        _armLostSince = 0
        _stealTarget = _armedPet
        _G.StickyActiveStealPet = _armedPet
        _stealArmedAt = os.clock()
        if type(pet.name) == "string" and pet.name ~= "" then _currentTargetName = pet.name end
    end
    _G.StickyDisarmSteal = function()
        _armedPet, _armLostSince = nil, 0
    end
    _G.StickyArmedName = function() return _armedPet and _armedPet.name or nil end

    local UIC = {
        bg   = Color3.fromRGB(5, 5, 5),
        bg2  = Color3.fromRGB(10, 10, 10),
        card = Color3.fromRGB(22, 22, 22),
        track = Color3.fromRGB(42, 42, 42),
        line = Color3.fromRGB(92, 92, 92),
        acc  = Color3.fromRGB(245, 245, 245),
        acc2 = Color3.fromRGB(200, 200, 200),
        txt  = Color3.fromRGB(255, 255, 255),
        dim  = Color3.fromRGB(150, 150, 150),
        off  = Color3.fromRGB(48, 48, 48),
    }
    local UIF, UIFB = Enum.Font.Gotham, Enum.Font.GothamBold

    local function mk(class, parent, props)
        local o = Instance.new(class)
        for k, v in pairs(props or {}) do o[k] = v end
        o.Parent = parent
        return o
    end
    local function corner(o, r) mk("UICorner", o, { CornerRadius = UDim.new(0, r or 8) }) return o end
local function stroke(o, col) return o end

    pcall(function()
        local _oldDbg = LP:FindFirstChild("PlayerGui")
        _oldDbg = _oldDbg and _oldDbg:FindFirstChild("StickyStealDbg")
        if _oldDbg then _oldDbg:Destroy() end
    end)

    local stealBarSg, stealBarFill, stealBarBox, stealBarLabel, stealScanIcon
    local _lastFillX = -1
    local _scanAnimRunning = false
    local function ensureStealBar()
        if stealBarBox and stealBarBox.Parent then
            return
        end
        for _, par in ipairs({ GUIHOST, PG }) do
            pcall(function()
                local old = par and par:FindFirstChild("StickyStealBar")
                if old then old:Destroy() end
            end)
        end
        pcall(function()
            local host = (gethui and gethui()) or game:GetService("CoreGui")
            local sg = host and host:FindFirstChild("StickyTargets")
            local tr = sg and sg:FindFirstChild("Root")
            if tr then
                local oldBox = tr:FindFirstChild("GrabProgressBox")
                if oldBox then oldBox:Destroy() end
            end
        end)

        stealBarSg = mk("ScreenGui", GUIHOST, {
            Name = "StickyStealBar", ResetOnSpawn = false,
            IgnoreGuiInset = true, DisplayOrder = 120,
            Enabled = true,
        })
        local parent = stealBarSg

        stealBarBox = corner(mk("Frame", parent, {
            Name = "GrabProgressBox",
            Active = true,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, tonumber(_G._Sticky_barX) or 0, 1, tonumber(_G._Sticky_barY) or -120),
            Size = UDim2.fromOffset(260, 68),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            ZIndex = 5,
        }), 8)
        local barStroke = Instance.new("UIStroke")
        barStroke.Thickness = 1
        barStroke.Color = Color3.fromRGB(255, 255, 255)
        barStroke.Transparency = 0.15
        barStroke.Parent = stealBarBox
        local stealBarSig = mk("TextLabel", stealBarBox, {
            Name = "StickySignature", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -2),
            Size = UDim2.new(1, -16, 0, 16), BackgroundTransparency = 1, Text = "leaked at discord.gg/Z7vPrxecnJ",
            Font = Enum.Font.GothamBold, TextScaled = true, TextColor3 = Color3.fromRGB(165, 165, 165), ZIndex = 15,
        })
        mk("UITextSizeConstraint", stealBarSig, { MaxTextSize = 12, MinTextSize = 7 })
        pcall(_G.StickyRememberPanel, stealBarBox, "StealBar")
        do
            local on, from, base, tracked
            stealBarBox.InputBegan:Connect(function(i)
                if _G.StickyAllUiDragLocked == true then return end
                if i.UserInputType ~= Enum.UserInputType.MouseButton1
                    and i.UserInputType ~= Enum.UserInputType.Touch then return end
                on, from, base = true, i.Position, stealBarBox.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then
                        on = false
                        _G._Sticky_barX = stealBarBox.Position.X.Offset
                        _G._Sticky_barY = stealBarBox.Position.Y.Offset
                    end
                end)
            end)
            stealBarBox.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement
                    or i.UserInputType == Enum.UserInputType.Touch then tracked = i end
            end)
            UIS.InputChanged:Connect(function(i)
                if _G.StickyAllUiDragLocked == true or not on or i ~= tracked then return end
                local d = i.Position - from
                stealBarBox.Position = UDim2.new(base.X.Scale, base.X.Offset + d.X, base.Y.Scale, base.Y.Offset + d.Y)
            end)
        end
        stealBarLabel = mk("TextLabel", stealBarBox, {
            Position = UDim2.fromOffset(12, 6), Size = UDim2.new(1, -24, 0, 14),
            BackgroundTransparency = 1,
            Text = "Scanning For Targets",
            Font = UIFB or Enum.Font.GothamBold, TextSize = 10,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6,
        })
        stealScanIcon = mk("TextLabel", stealBarBox, {
            AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 2),
            Size = UDim2.fromOffset(26, 22), BackgroundTransparency = 1,
            Text = "🔎", Font = UIFB or Enum.Font.GothamBold, TextSize = 17,
            TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 7, Visible = true,
        })
        local track = corner(mk("Frame", stealBarBox, {
            Position = UDim2.fromOffset(10, 26), Size = UDim2.new(1, -20, 0, 10),
            BackgroundColor3 = Color3.fromRGB(24, 24, 24),
            BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 6,
        }), 4)
        stealBarFill = corner(mk("Frame", track, {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0, ZIndex = 7,
        }), 4)
        _G.StickyRepaintStealMode = function() end
        _G.StickyRepaintStealBarKeys = function() end
        if stealBarSg then stealBarSg.Enabled = true end
    end

    local function showScanningStatus()
        if not stealBarLabel then return end
        stealBarLabel.Text = "Scanning For Targets"
        stealBarLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        if stealScanIcon then
            stealScanIcon.Visible = true
            if not _scanAnimRunning then
                _scanAnimRunning = true
                task.spawn(function()
                    local base = UDim2.new(1, -10, 0, 2)
                    while stealScanIcon and stealScanIcon.Parent and stealScanIcon.Visible do
                        tw(stealScanIcon, { Position = UDim2.new(1, -13, 0, 1), Rotation = -8 })
                        task.wait(0.28)
                        if not (stealScanIcon and stealScanIcon.Parent and stealScanIcon.Visible) then break end
                        tw(stealScanIcon, { Position = UDim2.new(1, -7, 0, 3), Rotation = 8 })
                        task.wait(0.28)
                    end
                    if stealScanIcon and stealScanIcon.Parent then
                        stealScanIcon.Position, stealScanIcon.Rotation = base, 0
                    end
                    _scanAnimRunning = false
                end)
            end
        end
    end
    local function showStealBar(name, pct)
        pcall(function()
            ensureStealBar()
            if stealBarSg then stealBarSg.Enabled = true end
            if stealBarBox then stealBarBox.Visible = true end
            if stealBarLabel then
                local nm = tostring(name or "")
                if nm ~= "" then
                    stealBarLabel.Text = "STEALING = " .. nm
                else
                    stealBarLabel.Text = "STEALING"
                end
                stealBarLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
            if stealScanIcon then stealScanIcon.Visible = false end
            if stealBarFill then
                local p = math.clamp(tonumber(pct) or 0, 0, 1)
                stealBarFill.Size = UDim2.new(p, 0, 1, 0)
            end
        end)
    end
    local function setStealBarPct(pct)
        pcall(function()
            ensureStealBar()
            if stealBarFill then
                local p = math.clamp(tonumber(pct) or 0, 0, 1)
                if math.abs(p - (_lastFillX or -1)) > 0.01 then
                    _lastFillX = p
                    stealBarFill.Size = UDim2.new(p, 0, 1, 0)
                end
            end
            if stealBarLabel and (tonumber(pct) or 0) > 0.02 then
                if not tostring(stealBarLabel.Text):find("STEALING", 1, true) then
                    stealBarLabel.Text = "STEALING"
                    stealBarLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
                if stealScanIcon then stealScanIcon.Visible = false end
            end
        end)
    end
    local function setStealBarSeconds(secLeft, frac)
        setStealBarPct(frac or 0)
    end
    local function hideStealBar()
        pcall(function()
            ensureStealBar()
            if stealBarFill then
                stealBarFill.Size = UDim2.new(0, 0, 1, 0)
                _lastFillX = 0
            end
            if stealBarLabel then showScanningStatus() end
        end)
    end
    task.defer(hideStealBar)

    local function buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then return end
        if not prompt or not prompt.Parent then return end
        local data = { holdCallbacks = {}, triggerCallbacks = {}, holdEndCallbacks = {}, ready = true }
        local function grab(sig, into)
            local ok, conns = pcall(getconnections, sig)
            if ok and type(conns) == "table" then
                for _, c in ipairs(conns) do
                    if type(c.Function) == "function" then table.insert(into, c.Function) end
                end
            end
        end
        grab(prompt.PromptButtonHoldBegan, data.holdCallbacks)
        grab(prompt.Triggered, data.triggerCallbacks)
        grab(prompt.PromptButtonHoldEnded, data.holdEndCallbacks)
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 or #data.holdEndCallbacks > 0 then
            InternalStealCache[prompt] = data
        end
    end

    local _rawFireServer = Instance.new("RemoteEvent").FireServer
    local _reBegin, _reCommit = nil, nil
    local _reState, _reRetryAt = {}, {}
    local function _re(cache, hash)
        if cache and cache.Parent then return cache end
        local st = _reState[hash]
        if typeof(st) == "Instance" then
            if st.Parent then return st end
            _reState[hash] = nil
            st = nil
        end
        if st == "pending" then return nil end
        if st == "failed" and os.clock() < (_reRetryAt[hash] or 0) then return nil end
        _reState[hash] = "pending"
        task.spawn(function()
            local got
            pcall(function()
                if _G.StickyGetRemote then got = _G.StickyGetRemote("RemoteEvent", hash) end
            end)
            if typeof(got) == "Instance" then
                _reState[hash] = got
                
            else
                _reState[hash] = "failed"
                _reRetryAt[hash] = os.clock() + (tonumber(_G.StickyRemoteRetry) or 5)
                
            end
        end)
        task.delay(tonumber(_G.StickyRemoteResolveWait) or 3, function()
            if _reState[hash] == "pending" then
                _reState[hash] = "failed"
                _reRetryAt[hash] = os.clock() + (tonumber(_G.StickyRemoteRetry) or 5)
                
            end
        end)
        return nil
    end

    local function _stealBegin()
        _reBegin = _re(_reBegin, "f40f7d9e-2f0d-4167-b250-899273f46874")
        if not _reBegin then return false end
        local t = workspace:GetServerTimeNow() + 124
        pcall(_rawFireServer, _reBegin, t, "68c86eb7-eb7e-4b4d-96ae-cf7cd847c5b0")
        pcall(function() _rawFireServer(_reBegin, t, "07b9cc25-2a1f-4a26-a0ec-f2fab578d8bd") end)
        return true
    end

    local function _stealCommit(plot, slot)
        _reCommit = _re(_reCommit, "3ba148c9-7ed6-4675-93f8-9f7c356a2c54")
        if not _reCommit then return false end
        if type(plot) ~= "string" or slot == nil then return false end
        local sl = tonumber(slot) or slot
        local t = workspace:GetServerTimeNow() + 31
        pcall(_rawFireServer, _reCommit, t, "cda5c764-d4e3-45c4-94e4-53a538347590", plot, sl)
        pcall(function()
            _rawFireServer(_reCommit, t, "8c852fbf-d542-4ef4-aa28-612e24db8d4a", plot, sl)
        end)
        return true
    end
    _G.StickyStealBegin, _G.StickyStealCommit = _stealBegin, _stealCommit

    local function executeStealAsync(prompt, petName, restoreMax, pet)
        if _holdBusy() then return false end
        if not (prompt and prompt.Parent and prompt.Enabled) then return false end

        local data = InternalStealCache[prompt]
        if not data then
            data = { holdCallbacks = {}, triggerCallbacks = {}, holdEndCallbacks = {}, ready = true }
            InternalStealCache[prompt] = data
        end
        if not data.ready then return false end
        data.ready = false

        _stealHoldStart = tick()
        _stealHoldActive = true
        _G.StickyAutoGrabActive = true
        _G.StickyStealProgress = 0
        pcall(function() prompt.MaxActivationDistance = math.huge end)
        showStealBar(petName, 0)

        task.spawn(function()
            local oldHold, oldMax = nil, restoreMax
            pcall(function() oldHold = prompt.HoldDuration end)
            local minHold = math.max(0.05, (type(_holdDur) == "function" and _holdDur()) or STEAL_HOLD_DURATION)
            pcall(function()
                if type(oldHold) == "number" and oldHold > minHold then prompt.HoldDuration = minHold end
            end)
            local maxHold = minHold + 1.3
            _G.StickyStealCycleDur = minHold

            local native = (#data.holdCallbacks == 0 and #data.triggerCallbacks == 0 and not fireproximityprompt)
            local begun = false
            if native then
                begun = pcall(function() prompt:InputHoldBegin() end)
            else
                for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
                begun = true
            end

            local t0, readyAt, outSince = tick(), nil, nil
            local grabDistance = tonumber(_G.StickyStealGrabDist) or 16
            local dwell = tonumber(_G.StickyStealDwell) or 0.22
            local abortAfter = tonumber(_G.StickyStealAbortAfter) or 0.35
            local function promptPosition()
                local parent = prompt and prompt.Parent
                if not parent then return nil end
                if parent:IsA("Attachment") then return parent.WorldPosition end
                if parent:IsA("BasePart") then return parent.Position end
                local part = parent:FindFirstAncestorWhichIsA("BasePart")
                return part and part.Position or nil
            end
            local function planarDistance()
                local character = LP.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local pos = promptPosition()
                if not root or not pos then return nil end
                local dx, dz = root.Position.X - pos.X, root.Position.Z - pos.Z
                return math.sqrt(dx * dx + dz * dz)
            end

            local barConn
            pcall(function()
                pcall(function()
                    barConn = RunService.RenderStepped:Connect(function()
                        if not (prompt and prompt.Parent and prompt:IsDescendantOf(workspace)) then return end
                        local elapsed = tick() - t0
                        local progress = math.clamp(elapsed / minHold, 0, 1)
                        _G.StickyStealProgress = progress
                        setStealBarPct(progress)
                    end)
                end)

                while prompt and prompt.Parent and prompt:IsDescendantOf(workspace) do
                    RunService.Heartbeat:Wait()
                    if LP:GetAttribute("Stealing") == true then break end

                    local character = LP.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    local distance = planarDistance()
                    local down = not humanoid or humanoid.Health <= 0 or humanoid.PlatformStand == true
                        or humanoid:GetState() == Enum.HumanoidStateType.FallingDown
                        or humanoid:GetState() == Enum.HumanoidStateType.Ragdoll
                    local far = distance and distance > (grabDistance * 2.5)
                    if down or far then
                        outSince = outSince or tick()
                        if tick() - outSince > abortAfter then break end
                    else
                        outSince = nil
                    end

                    local elapsed = tick() - t0
                    _G.StickyStealProgress = math.clamp(elapsed / minHold, 0, 1)
                    _G.StickyStealCycleLeft = math.max(minHold - elapsed, 0)
                    if elapsed >= minHold then
                        local inRange = distance and distance <= grabDistance
                        if inRange then readyAt = readyAt or tick() else readyAt = nil end
                        if readyAt and tick() - readyAt >= dwell then
                            if native then
                                pcall(function() prompt:InputHoldEnd() end)
                            elseif #data.triggerCallbacks > 0 then
                                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                            elseif fireproximityprompt then
                                pcall(fireproximityprompt, prompt)
                            end
                            break
                        end
                    end
                    if elapsed >= maxHold + 2 then break end
                end
            end)
            if barConn then pcall(function() barConn:Disconnect() end) end

            if native and begun then pcall(function() prompt:InputHoldEnd() end) end
            for _, fn in ipairs(data.holdEndCallbacks) do task.spawn(fn) end
            pcall(function() if oldHold ~= nil and prompt and prompt.Parent then prompt.HoldDuration = oldHold end end)
            pcall(function() if oldMax ~= nil and prompt and prompt.Parent then prompt.MaxActivationDistance = oldMax end end)
            task.wait(0.05)
            _G.StickyStealProgress = nil
            _G.StickyStealCycleLeft = 0
            _stealHoldActive = false
            _G.StickyAutoGrabActive = false
            data.ready = true
            hideStealBar()
        end)
        return true
    end

    local function timeUntilCanSteal()
        if LP:GetAttribute("Stealing") or LP:GetAttribute("IsTrading")
            or LP:GetAttribute("IsDuelSelecting") or LP:GetAttribute("Web") then
            return -1
        end
        local ragdoll = LP:GetAttribute("RagdollEndTime")
        if ragdoll then
            local r = ragdoll - workspace:GetServerTimeNow()
            if r > 0 then return r end
        end
        return 0
    end

    local stealOn = (_G.StickyStealMode ~= nil)
    local _emptyScans = 0
    local function _fireSteal(pet)
        if not pet then return false end
        if _holdBusy() then  return false end
        local _fhrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local _fd = (_fhrp and pet.position) and (pet.position - _fhrp.Position).Magnitude or nil
        local _judge = (_fd ~= nil) and (_fd <= _prox() + 2) or false
        local _cd = _holdDur() + (tonumber(_G.StickyStealCycleGap) or 0)

        local prompt = findStealPrompt(pet)
        if not prompt or not prompt.Parent then
            
            return false
        end
        local oldMax
        pcall(function() oldMax = prompt.MaxActivationDistance end)
        pcall(function() prompt.MaxActivationDistance = math.huge end)
        buildStealCallbacks(prompt)
        if executeStealAsync(prompt, pet.name, oldMax, pet) then
            _G.StickyLastFire = os.clock()
            _verifyFire(pet, "prompt", _judge)
            return true
        end
        if oldMax ~= nil then pcall(function() prompt.MaxActivationDistance = oldMax end) end
        return false
    end
    _G.StickyFireSteal = _fireSteal
    local function _stealTick()
        _G.StickyTickN = (_G.StickyTickN or 0) + 1
        stealOn = (_G.StickyStealMode ~= nil)
        if not stealOn then  return end
        local now = os.clock()
        local _lockUid = _G.StickyStealTargetUID
        local _lockChanged = (type(_lockUid) == "string" and _lockUid ~= "" and _lockUid ~= _lastPickUid)
        local _needPick = (not _stealTarget) or _lockChanged or (now - _lastTargetPick) >= (tonumber(_G.StickyRepickGap) or 0.2)
        if _armedPet then
            local _lp = _armLivePos(_armedPet)
            if _lp then
                _armedPet.position = _lp
                _armLostSince = 0
            elseif _armLostSince == 0 then
                _armLostSince = now
            elseif now - _armLostSince > (tonumber(_G.StickyArmLostGrace) or 1.0) then
                _armedPet, _armLostSince = nil, 0
            end
            if _armedPet and (now - _armCheckAt) >= (tonumber(_G.StickyArmCheckGap) or 0.3) then
                _armCheckAt = now
                local okL, listed = pcall(_petListed, _armedPet.plot, _armedPet.slot)
                if okL and not listed then
                    
                    _armedPet, _armLostSince = nil, 0
                end
            end
            if _armedPet and _G.StickyStealMode ~= "nearest" then
                _stealTarget = _armedPet
                if type(_armedPet.name) == "string" then _currentTargetName = _armedPet.name end
                _needPick = false
            end
        end
        local _scanGap = (_emptyScans >= 3) and (tonumber(_G.StickyStealIdleGap) or 0.2) or 0.01
        if not LP:GetAttribute("Stealing") and _needPick and (now - _autoLastScan) >= _scanGap then
            _autoLastScan = now
            _lastTargetPick = now
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pets = _scanCached(now, 0.05)
                local ok = pets ~= nil
                if ok and pets and #pets > 0 then _emptyScans = 0 else _emptyScans = _emptyScans + 1 end
                if ok and pets and #pets > 0 then
                    local best
                    if type(_lockUid) == "string" and _lockUid ~= "" then
                        for _, p in ipairs(pets) do
                            if not p.conveyor and _petUid(p) == _lockUid then best = p break end
                        end
                    end
                    if not best and _G.StickyStealMode == "nearest" then
                        local myPos = hrp.Position
                        local bestD = math.huge
                        for _, p in ipairs(pets) do
                            if not p.conveyor and p.position then
                                local d = (p.position - myPos).Magnitude
                                if d < bestD then bestD = d; best = p end
                            end
                        end
                    elseif not best then
                        for _, p in ipairs(pets) do if not p.conveyor then best = p; break end end
                    end
                    best = best or pets[1]
                    if best then
                        _stealTarget = best
                        _stealArmedAt = now
                        _lastPickUid = _lockUid
                        if type(best.name) == "string" and best.name ~= "" then
                            _currentTargetName = best.name
                        end
                    end
                end
            end
        end
        if _G.StickyStealMode == "nearest"
            and not (type(_lockUid) == "string" and _lockUid ~= "") then
            local _c2 = LP.Character
            local _h2 = _c2 and _c2:FindFirstChild("HumanoidRootPart")
            if _h2 and (now - _inRangeLast) >= (tonumber(_G.StickyInRangeGap) or 0.15) then
                _inRangeLast = now
                local _pets2 = _scanCached(now, 0.15)
                if _pets2 ~= nil and type(_pets2) == "table" then
                    local _near, _nd = nil, math.huge
                    local _mp = _h2.Position
                    for _, p in ipairs(_pets2) do
                        if not p.conveyor and p.position then
                            local d = (p.position - _mp).Magnitude
                            if d < _nd then _nd, _near = d, p end
                        end
                    end
                    if _near then
                        local _nu = _petUid(_near)
                        if _nu ~= _G.StickyLastNearUid then
                            _G.StickyLastNearUid = _nu
                            
                        end
                        _stealTarget = _near
                        _armedPet, _armLostSince = nil, 0
                        _lastTargetPick = now
                        if type(_near.name) == "string" then _currentTargetName = _near.name end
                    end
                end
            end
        end
        local pet = _stealTarget
        if not pet then  return end

        if now - _stealLastScan < 0.02 then _G.StickyThrN = (_G.StickyThrN or 0) + 1 return end
        _stealLastScan = now
        local t = timeUntilCanSteal()
        if t == -1 then
            if LP:GetAttribute("Stealing") then _stealTarget = nil; _armedPet, _armLostSince = nil, 0 end
            
            return
        end
        if t > 0 and t > _holdDur() then  return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then  return end

        if pet.position then
            local toPet = pet.position - hrp.Position
            local dist = toPet.Magnitude
            if (now - (_G.__StickyTgtAt or 0)) >= 0.15 then
                _G.__StickyTgtAt = now
                _G.StickyStealTgt = tostring(pet.name) .. " [" .. tostring(pet.plot) .. "/" .. tostring(pet.slot) .. "] d=" .. math.floor(dist)
            end
            local hold = _holdDur()

            local lead = tonumber(_G.StickyStealLead) or 0.6

            local closing = dist > 0.001 and (hrp.AssemblyLinearVelocity:Dot(toPet) / dist) or 0

            local _nearBase = false
            do
                local _bi = getClosestBaseIdx(pet.position)
                local _b = _bi and BASES_LOW[_bi]
                if _b then
                    local _bx, _bz = hrp.Position.X - _b.X, hrp.Position.Z - _b.Z
                    if math.sqrt(_bx * _bx + _bz * _bz) <= (tonumber(_G.StickyCloseBaseRange) or 100) then
                        _nearBase = true
                    end
                end
            end

            local _armed = _G.StickyStealQuick ~= true
            local _mul = _armed and 1.5 or 1
            if _nearBase then
                if dist > (tonumber(_G.StickyNearBaseStealStart) or 80) * _mul then  return end
            elseif closing > (tonumber(_G.StickyFastApproach) or 150) then

                if dist > (tonumber(_G.StickyStealLeadMax) or 420) * _mul then  return end
                if (dist / closing) > hold * lead + (tonumber(_G.StickyStealEarly) or 0.35) * _mul then  return end
            elseif closing > 5 then

                if dist > (tonumber(_G.StickyCloseProximity) or 40) * _mul then  return end
            else

                if dist > _prox() * _mul then  return end
            end
        end
        _fireSteal(pet)
    end
    local _stealThrottle = 0
    RunService.Heartbeat:Connect(function()
        _stealThrottle = _stealThrottle + 1
        if _stealThrottle < 2 then return end
        _stealThrottle = 0
        pcall(_stealTick)
    end)

    task.spawn(function()
        while true do
            task.wait(tonumber(_G.StickyWatchdogTick) or 0.15)
            if _G.StickyStealMode ~= nil and _G.StickyStealWatchdog ~= false
                and not LP:GetAttribute("Stealing")
                and not _holdBusy()
                and (os.clock() - (_G.StickyLastFire or 0)) > (tonumber(_G.StickyWatchdogGap) or 1.0) then
                local c = LP.Character
                local h = c and c:FindFirstChild("HumanoidRootPart")
                if h then
                    local pets = _scanCached(os.clock(), 0.15)
                    local ok = pets ~= nil
                    if ok and type(pets) == "table" then
                        local near, nd = nil, math.huge
                        local mp = h.Position
                        if _G.StickyStealMode == "nearest" then
                            for _, p in ipairs(pets) do
                                if not p.conveyor and p.position then
                                    local d = (p.position - mp).Magnitude
                                    if d < nd then nd, near = d, p end
                                end
                            end
                        else
                            local want = _armedPet or _stealTarget
                            local wuid = want and _petUid(want)
                            if wuid then
                                for _, p in ipairs(pets) do
                                    if not p.conveyor and p.position and _petUid(p) == wuid then
                                        near, nd = p, (p.position - mp).Magnitude
                                        break
                                    end
                                end
                            end
                        end
                        if near and nd <= _prox() then
                            
                            pcall(_fireSteal, near)
                        end
                    end
                end
            end
        end
    end)

    do
        local function applyUnwalkAlways(char)
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local animator = hum and hum:FindFirstChildOfClass("Animator")
            local animate = char:FindFirstChild("Animate")
            if animate then animate.Disabled = true end
            if animator then
                local ok, tracks = pcall(function() return animator:GetPlayingAnimationTracks() end)
                if ok and tracks then for _, t in ipairs(tracks) do pcall(function() t:Stop(0) end) end end
            end
        end
        local function hook(char)
            task.spawn(function()
                char:WaitForChild("Humanoid", 10); task.wait(0.05)
                for i = 1, 8 do
                    if LP.Character ~= char then break end
                    applyUnwalkAlways(char); task.wait(0.25)
                end
            end)
        end
        if LP.Character then hook(LP.Character) end
        LP.CharacterAdded:Connect(hook)
        local _unwalkLast = 0
        RunService.Heartbeat:Connect(function()
            local now = os.clock()
            if now - _unwalkLast < 1.5 then return end
            if _StickyAnimRestoreAt and now < _StickyAnimRestoreAt then return end
            _unwalkLast = now
            if LP.Character then applyUnwalkAlways(LP.Character) end
        end)
    end

    local HS = game:GetService("HttpService")
    local UIS = game:GetService("UserInputService")
    local CFG_FILE = "SideTP.json"

    local function loadCfgTable()
        local t = {}
        if readfile then
            pcall(function()
                local raw = readfile(CFG_FILE)
                if type(raw) == "string" and #raw > 0 then
                    local ok, d = pcall(HS.JSONDecode, HS, raw)
                    if ok and type(d) == "table" then t = d end
                end
            end)
        end
        return t
    end
    do
        local t = loadCfgTable()
        if tonumber(t.stealTargetX) then _G._Sticky_tgtX = tonumber(t.stealTargetX) end
        if tonumber(t.stealTargetY) then _G._Sticky_tgtY = tonumber(t.stealTargetY) end
        if t.tpTrail ~= nil then _G.StickyTPTrail = t.tpTrail == true end
        if t.autoTp ~= nil then _G.StickyAutoTP = t.autoTp == true end
        if type(t.flingTp) == "boolean" then _G.Sticky_FlingTp = t.flingTp end
        local savedTPMethod = type(t.tpMethod) == "string" and t.tpMethod or nil
        local hasLegacyTPMode = type(t.hybridTp) == "boolean"
            or type(t.flingTp) == "boolean" or type(t.spinTp) == "boolean" or type(t.dragTp) == "boolean"
        if not StickyTPMethodNames[savedTPMethod] and hasLegacyTPMode then
            if t.hybridTp == true then savedTPMethod = "HYBRID"
            elseif t.flingTp == true then savedTPMethod = "FLING TP"
            else savedTPMethod = "MANUAL TP" end
        end
        if StickyTPMethodNames[savedTPMethod] then _G.StickySetTPMethod(savedTPMethod) end
        if t.autoKickOnSteal ~= nil then _G.StickyAutoKickOnSteal = t.autoKickOnSteal == true end
        if t.invisAuto ~= nil then _G.StickyInvisAuto = t.invisAuto == true end
        if t.invisAutoRecover ~= nil then _G.StickyInvisAutoRecover = t.invisAutoRecover == true end
        if t.autoRecoverHit ~= nil then _G.StickyAutoRecoverHit = t.autoRecoverHit == true end
        if t.prioritySound ~= nil then _G.StickyPriAlert = t.prioritySound == true end
        if type(t.prioritySoundID) == "string" then _G.StickyPrioritySoundID = t.prioritySoundID end
        if t.clickToAP ~= nil then _G.StickyClickToAP = t.clickToAP == true end
        if t.proximityAP ~= nil then _G.StickyProximityAP = t.proximityAP == true end
        if tonumber(t.proximityRange) then _G.StickyProximityRange = math.clamp(tonumber(t.proximityRange), 5, 60) end
        if type(t.stealMode) == "string" then _G.StickyStealMode = t.stealMode == "nearest" and "nearest" or "priority" end
        _G.StickyInstaTpBrainrot = true
        _G.StickyCFrameGoTo = true
        if tonumber(t.invisUiX) then _G._Sticky_invX = tonumber(t.invisUiX) end
        if tonumber(t.invisUiY) then _G._Sticky_invY = tonumber(t.invisUiY) end
        if tonumber(t.stealBarX) then _G._Sticky_barX = tonumber(t.stealBarX) end
        if tonumber(t.stealBarY) then _G._Sticky_barY = tonumber(t.stealBarY) end
    end

    local function saveTpSettings()
        if not writefile then return end
        local t = loadCfgTable()
        t.stealTargetX = tonumber(_G._Sticky_tgtX) or t.stealTargetX
        t.stealTargetY = tonumber(_G._Sticky_tgtY) or t.stealTargetY
        t.tpVelocity = tonumber(_G.TPVelocity) or 400
        t.climbSpeed = tonumber(_G.StickyClimb) or 160
        t.goSpeed = tonumber(_G.StickyGoSpeed) or 200
        t.cframeSpeed = tonumber(_G.StickyCFrameSpeed) or 450
        t.walkSpeed = tonumber(_G.StickyWalkSpeed) or 27
        t.landingDelay = tonumber(_G.LandingDelay) or 0.35
        t.closeSpeed = tonumber(_G.StickyCloseSpeed) or 80
        t.problemBaseSpeed = tonumber(_G.StickyProblemBaseSpeed) or 60
        t.slowCrossRow = _G.StickySlowCrossRow == true
        t.autoTp = _G.StickyAutoTP ~= false
        t.flashTp = nil
        t.tpMethod = StickyTPMethodNames[_G.StickyTPMethod] and _G.StickyTPMethod or "MANUAL TP"
        t.bodySwapTp = nil
        t.spinTp = false
        t.autoKickOnSteal = _G.StickyAutoKickOnSteal == true
        t.kickToPS = _G.StickyKickToPS == true
        t.psLink = tostring(_G.StickyPrivateServerLink or "")
        t.priAlert = _G.StickyPriAlert == true
        t.alertSound = tostring(_G.StickyAlertSound or "111786441593851")
        t.alertMinGen = tonumber(_G.StickyAlertMinGen) or 80e6
        t.walkSpeedOn = _G.StickyWalkSpeedOn ~= false
        t.xray = _G.StickyXray == true
        t.cframeGoTo = true
        t.instaTpBrainrot = true
        t.dragTp = false
        t.tpTrail = _G.StickyTPTrail == true
        t.hybridTp = _G.StickyHybridTP == true
        t.invisUiX = tonumber(_G._Sticky_invX) or t.invisUiX
        t.invisUiY = tonumber(_G._Sticky_invY) or t.invisUiY
        t.stealBarX = tonumber(_G._Sticky_barX) or t.stealBarX
        t.stealBarY = tonumber(_G._Sticky_barY) or t.stealBarY
        t.panelX = tonumber(_G._stp_panelX) or t.panelX
        t.panelY = tonumber(_G._stp_panelY) or t.panelY
        if type(_G.StickyUiOpenKey) == "string" then t.uiOpenKey = _G.StickyUiOpenKey end
        t.frontTp = _G.StickyFrontTP == true
        t.sideTp = _G.StickySideTP == true
        t.sideTpRange = tonumber(_G.StickySideTPRange) or 100
        t.invisAuto = _G.StickyInvisAuto == true
        t.invisAutoRecover = _G.StickyInvisAutoRecover == true
        t.autoRecoverHit = _G.StickyAutoRecoverHit == true
        t.prioritySound = _G.StickyPriAlert == true
        t.prioritySoundID = tostring(_G.StickyPrioritySoundID or "")
        t.clickToAP = _G.StickyClickToAP == true
        t.proximityAP = _G.StickyProximityAP == true
        t.proximityRange = math.clamp(tonumber(_G.StickyProximityRange) or 15, 5, 60)
        t.invisDepth = tonumber(_G.StickyInvisDepth) or 4.2
        t.invisAngle = tonumber(_G.StickyInvisAngle) or 180
        t.autoSteal = stealOn
        t.stealMode = _G.StickyStealMode
        t.stealLead = tonumber(_G.StickyStealLead) or 0.6
        t.stealFireKey = type(_G.StickyStealFireKey) == "string" and _G.StickyStealFireKey or nil
        t.priorityList = _G.SHARED_PRIORITY_ITEMS
        t.blacklistList = _G.SHARED_BLACKLIST_ITEMS
        t.mutationList = _G.SHARED_MUTATION_PRIORITY
        do
            local d = {}
            for name, on in pairs(_G.SHARED_MUTATION_DISABLED) do
                if on then d[#d + 1] = name end
            end
            t.mutationDisabled = d
        end
        t.traitList = _G.SHARED_TRAIT_PRIORITY
        t.panelX = tonumber(_G._stp_panelX)
        t.panelY = tonumber(_G._stp_panelY)
        t.panelPos = _G._stp_pos
        
        if type(_G.StickyCloneKeyName)  == "string" then t.cloneKey  = _G.StickyCloneKeyName  else t.cloneKey  = nil end
        if type(_G.StickyKickKeyName)   == "string" then t.kickKey   = _G.StickyKickKeyName   else t.kickKey   = nil end
        if type(_G.StickyStopTPKeyName) == "string" then t.stopTpKey = _G.StickyStopTPKeyName else t.stopTpKey = nil end
        if type(_G.StickyNearestKey)    == "string" then t.nearestKey= _G.StickyNearestKey    else t.nearestKey= nil end
        if type(_G.StickyDropKeyName)   == "string" then t.dropKey   = _G.StickyDropKeyName   else t.dropKey   = nil end
        if type(_G.StickyResetKeyName)  == "string" then t.resetKey  = _G.StickyResetKeyName  else t.resetKey  = nil end
        if type(_G.StickyInvisKeyName)  == "string" then t.invisKey  = _G.StickyInvisKeyName  else t.invisKey  = nil end
        if type(_G.StickyCarpetSpeedKeyName) == "string" then t.carpetSpeedKey = _G.StickyCarpetSpeedKeyName else t.carpetSpeedKey = nil end
        if type(_G.StickyStealQuickKey) == "string" then t.stealQuickKey = _G.StickyStealQuickKey else t.stealQuickKey = nil end
        if type(_G.StickyStealNearKey) == "string" then t.stealNearKey = _G.StickyStealNearKey end
        if type(_G.StickyStealPrioKey) == "string" then t.stealPrioKey = _G.StickyStealPrioKey end
        t.xrayAlpha = math.clamp(tonumber(_G.StickyXrayAlpha) or 0.5, 0.05, 0.95)
        t.playerESP = _G.StickyPlayerESP == true
        t.fmlyESP = _G.StickyFmlyESP == true
        t.sonESP = _G.StickySonESP == true
        t.fovEnabled = _G.StickyFovEnabled == true
        t.fovValue = math.clamp(tonumber(_G.StickyFovValue) or 70, 0, 120)
        t.flingTp = _G.Sticky_FlingTp == true
        t.aimbotEnabled = nil
        t.autoDestroyTurret = _G.StickyAutoDestroyTurret == true
        t.conveyorESP = _G.StickyConveyorESP == true
        t.trapESP = _G.StickyTrapESP == true
        t.lineToBase = _G.StickyLineToBase == true
        t.adminPanelUiOn = _G.StickyAdminPanelUiOn == true
        t.adminBlacklist = type(_G.StickyAdminBlacklist) == "table" and _G.StickyAdminBlacklist or {}
        t.optimizer = _G.StickyFpsOptimizer == true
        t.antiFlash = _G.StickyAntiFlash ~= false
        t.faceAway = _G.StickyFaceAway == true
        t.faceAwayNearest = _G.StickyFaceAwayNearest == true
        t.faceAwayDelay = tonumber(_G.StickyFaceAwayDelay) or 2
        t.antiBee   = _G.StickyAntiBee ~= false
        t.infJump   = _G.StickyInfJump ~= false
        t.antiDie   = _G.AntiDieDisabled ~= true
        t.carpetSpeedValue = tonumber(_G.StickyCarpetSpeedValue) or 140

        if type(_G.StickyCarpetTool) == "string" then t.carpetTool = _G.StickyCarpetTool else t.carpetTool = nil end
        t.autoBuy = _G.StickyAutoBuy == true
        t.autoBuyRange = tonumber(_G.StickyAutoBuyRange) or 17
        t.autoBuyHover = tonumber(_G.StickyAutoBuyHover) or 9
        t.exX = tonumber(_G._Sticky_exX); t.exY = tonumber(_G._Sticky_exY)
        t.fX  = tonumber(_G._Sticky_fX);  t.fY  = tonumber(_G._Sticky_fY)
        t.kX  = tonumber(_G._Sticky_kX);  t.kY  = tonumber(_G._Sticky_kY)
        pcall(function() writefile(CFG_FILE, HS:JSONEncode(t)) end)
    end
    _G.StickySaveSettings = saveTpSettings  

    if _G.TPVelocity == nil then _G.TPVelocity = 400 end
    if _G.StickyClimb == nil then _G.StickyClimb = 160 end
    if _G.StickyGoSpeed == nil then _G.StickyGoSpeed = 200 end
    if _G.StickyCFrameSpeed == nil then _G.StickyCFrameSpeed = 450 end
    if _G.StickyWalkSpeed == nil then _G.StickyWalkSpeed = 24 end
    if _G.LandingDelay == nil then _G.LandingDelay = 0.35 end
    if _G.StickyCloseSpeed == nil then _G.StickyCloseSpeed = 80 end
    if _G.StickyProblemBaseSpeed == nil then _G.StickyProblemBaseSpeed = 60 end
    if _G.StickySlowCrossRow == nil then _G.StickySlowCrossRow = false end
    if _G.StickyInvisDepth == nil then _G.StickyInvisDepth = 4.2 end
    if _G.StickyInvisAngle == nil then _G.StickyInvisAngle = 180 end
    if _G.StickyPlayerESP == nil then _G.StickyPlayerESP = false end
    if _G.StickyFmlyESP == nil then _G.StickyFmlyESP = false end
    if _G.StickySonESP == nil then _G.StickySonESP = false end
    if _G.StickyFovEnabled == nil then _G.StickyFovEnabled = false end
    if _G.StickyFovValue == nil then _G.StickyFovValue = 70 end
    if _G.StickyFpsOptimizer == nil then _G.StickyFpsOptimizer = false end
    if _G.StickyFpsOptimizer == true then pcall(_G.StickySetFpsOptimizer, true) end

    local TS = game:GetService("TweenService")
    local EASE = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local function tween(o, props) TS:Create(o, EASE, props):Play() end

    local guiParent = (gethui and gethui()) or game:GetService("CoreGui")
    for _, par in ipairs({ guiParent, PG }) do
        pcall(function()
            local old = par:FindFirstChild("StickyTP")
            if old then old:Destroy() end
            local oldBar = par:FindFirstChild("StickyTopBar")
            if oldBar then oldBar:Destroy() end
        end)
    end

    local sg = mk("ScreenGui", nil, {
        Name = "StickyTP", ResetOnSpawn = false, IgnoreGuiInset = true,
        DisplayOrder = 999999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then pcall(function() sg.Parent = (gethui and gethui()) or game:GetService("CoreGui") end) end

    sg.Enabled = false
    _G.StickyUiOpenKey = _G.StickyUiOpenKey or "LeftControl"
    _G.StickyToggleMainUI = function()
        if type(_G.StickyToggleTargets) == "function" then _G.StickyToggleTargets() end
    end

    local W, H, RAIL, PAD = 520, 360, 70, 16

    local root = mk("Frame", sg, {
        Name = "Root", Active = true, BackgroundTransparency = 1,
        Size = UDim2.fromOffset(W, H + 20),
        Position = UDim2.fromOffset(tonumber(_G._stp_panelX) or 80, tonumber(_G._stp_panelY) or 120),
    })
    local card = corner(mk("Frame", root, {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = UIC.bg, BorderSizePixel = 0, ZIndex = 1,
    }), 10)
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Thickness = 1
    mainStroke.Color = Color3.fromRGB(255, 255, 255)
    mainStroke.Transparency = 0.86
    mainStroke.Parent = card
    local hubSig = mk("TextLabel", card, {
        Name = "StickySignature", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -2),
        Size = UDim2.new(1, -16, 0, 16), BackgroundTransparency = 1, Text = "leaked at discord.gg/Z7vPrxecnJ",
        Font = Enum.Font.GothamBold, TextScaled = true, TextColor3 = Color3.fromRGB(165, 165, 165), ZIndex = 11,
    })
    mk("UITextSizeConstraint", hubSig, { MaxTextSize = 12, MinTextSize = 7 })
    pcall(_G.StickyRememberPanel, root, "HubPanel")

    local rail = mk("Frame", card, {
        Size = UDim2.new(1, 0, 0, RAIL), BackgroundColor3 = Color3.fromRGB(9, 9, 9), BorderSizePixel = 0, ZIndex = 2,
    })
    corner(rail, 10)
    local hubNameLbl = mk("TextLabel", rail, {
        Size = UDim2.fromOffset(172, 18), Position = UDim2.fromOffset(12, 6),
        BackgroundTransparency = 1, Text = "STICKY PRIVATE HUB", Font = UIFB, TextSize = 12,
        TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
    })
    mk("Frame", rail, {
        Size = UDim2.fromOffset(52, 2), Position = UDim2.fromOffset(12, 26),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ZIndex = 2,
    })
    local privLbl = mk("TextLabel", rail, {
        Size = UDim2.fromOffset(64, 16), Position = UDim2.fromOffset(192, 6),
        BackgroundTransparency = 1, Text = "ONLINE", Font = UIFB, TextSize = 10,
        TextColor3 = Color3.fromRGB(190, 190, 190), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
    })
    pcall(function()
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(145, 145, 145)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 160, 160)),
        })
        g.Parent = hubNameLbl
    end)
    task.spawn(function()
        while hubNameLbl and hubNameLbl.Parent do
            task.wait(2)
            if not hubNameLbl.Parent then break end
            pcall(function()
                local flash = Instance.new("TextLabel")
                flash.Size, flash.Position = hubNameLbl.Size, hubNameLbl.Position
                flash.BackgroundTransparency = 1
                flash.Text, flash.Font, flash.TextSize = hubNameLbl.Text, hubNameLbl.Font, hubNameLbl.TextSize
                flash.TextColor3, flash.TextTransparency = Color3.fromRGB(255, 255, 255), 0.05
                flash.TextXAlignment, flash.ZIndex = hubNameLbl.TextXAlignment, hubNameLbl.ZIndex + 1
                flash.Parent = hubNameLbl.Parent
                local ts = game:GetService("TweenService")
                ts:Create(flash, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 1 }):Play()
                task.delay(0.45, function() if flash then pcall(function() flash:Destroy() end) end end)
            end)
        end
    end)
    local body = mk("Frame", card, {
        Position = UDim2.fromOffset(0, RAIL), Size = UDim2.new(1, 0, 1, -RAIL - 20),
        BackgroundTransparency = 1, ZIndex = 2,
    })
    mk("Frame", card, {
        Name = "HeaderDivider", Position = UDim2.fromOffset(0, RAIL - 1),
        Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = UIC.line,
        BorderSizePixel = 0, ZIndex = 4,
    })

    local pages, tabs = {}, {}
    local tabOpenHook = {}
    local function selectTab(name)
        local _h = tabOpenHook[name]
        if _h then tabOpenHook[name] = nil; pcall(_h) end
        for n, p in pairs(pages) do p.Visible = (n == name) end
        for n, t in pairs(tabs) do
            local on = (n == name)
            tween(t.bg, { BackgroundTransparency = on and 0 or 1 })
            tween(t.lbl, { TextColor3 = on and UIC.txt or UIC.dim })
            tween(t.btn, { BackgroundTransparency = on and 0.2 or 0.5 })
        end
    end
    _G.StickySelectTab = selectTab
    _G.StickyShowMainUi = function()
        if type(_G.StickyToggleTargets) == "function" then _G.StickyToggleTargets() end
    end
    _G.StickyOpenPriorityUi = function()
        if type(_G.StickyShowPrioritySettings) == "function" then _G.StickyShowPrioritySettings(true)
        else _G.__StickyOpenPriorityOnTargets = true end
    end
    do
        local function hookFlash(btn)
            if not btn:IsA("TextButton") or btn:GetAttribute("StickyFlashHooked") then return end
            btn:SetAttribute("StickyFlashHooked", true)
            btn.MouseButton1Click:Connect(function()
                local stroke = Instance.new("UIStroke")
                stroke.Name = "ClickFlash"
                stroke.Thickness = 2
                stroke.Color = Color3.fromRGB(255, 255, 255)
                stroke.Transparency = 0
                stroke.Parent = btn
                local ts = game:GetService("TweenService")
                ts:Create(stroke, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 1 }):Play()
                task.delay(0.14, function() if stroke then pcall(function() stroke:Destroy() end) end end)
            end)
        end
        for _, d in ipairs(root:GetDescendants()) do hookFlash(d) end
        root.DescendantAdded:Connect(hookFlash)
    end

    do
        local dragging, startPos, startInput
        root.InputBegan:Connect(function(input)
            if _G.StickyAllUiDragLocked == true then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startPos = root.Position
                startInput = input.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        _G._stp_panelX = root.Position.X.Offset
                        _G._stp_panelY = root.Position.Y.Offset
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if _G.StickyAllUiDragLocked == true or not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - startInput
                root.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
            end
        end)
    end

    local function tab(name, order)
        local b = corner(mk("TextButton", rail, {
            Size = UDim2.new(1 / 5, -6, 0, 30), Position = UDim2.new((order - 1) / 5, 3, 0, 32),
            BackgroundColor3 = UIC.card, BackgroundTransparency = 0.5, Text = "",
            AutoButtonColor = false, Active = true, ZIndex = 2,
        }), 6)
        local bg = mk("Frame", b, {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = UIC.acc,
            BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        corner(bg, 6)
        local lbl = mk("TextLabel", b, {
            Size = UDim2.new(1, 0, 1, 0), Position = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1, Text = name, Font = UIFB, TextSize = 11,
            TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        mk("UIPadding", lbl, { PaddingLeft = UDim.new(0, 12) })
        local page = mk("ScrollingFrame", body, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
            Visible = false, ScrollBarThickness = 0, ScrollBarImageColor3 = UIC.line,
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 2,
        })
        mk("UIPadding", page, {
            PaddingLeft = UDim.new(0, PAD), PaddingRight = UDim.new(0, PAD + 4),
            PaddingTop = UDim.new(0, PAD + 4), PaddingBottom = UDim.new(0, PAD),
        })
        mk("UIListLayout", page, { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })
        tabs[name], pages[name] = { btn = b, bg = bg, lbl = lbl }, page
        b.MouseButton1Click:Connect(function() selectTab(name) end)
        b.MouseEnter:Connect(function()
            if not pages[name].Visible then
                tween(b, { BackgroundTransparency = 0.3 })
            end
        end)
        b.MouseLeave:Connect(function()
            if not pages[name].Visible then
                tween(b, { BackgroundTransparency = 0.5 })
            end
        end)
        return page
    end

    local function label(parent, txt, first)
        local l = mk("TextLabel", parent, {
            Size = UDim2.new(1, 0, 0, first and 14 or 26), BackgroundTransparency = 1,
            Text = string.upper(txt), Font = UIFB, TextSize = 10, TextColor3 = UIC.dim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Bottom, ZIndex = 2,
        })
        return l
    end

    local function shell(parent, h)
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = UIC.card,
            BorderSizePixel = 0, Active = true, ZIndex = 2,
        }), 6)
        local bg = mk("Frame", card, {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = UIC.acc,
            BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        corner(bg, 6)
        return card
    end

    local function action(parent, txt, fn)
        local card2 = shell(parent, 36)
        local b = mk("TextButton", card2, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = txt,
            Font = UIFB, TextSize = 12, TextColor3 = UIC.txt,
            Active = true, AutoButtonColor = false, ZIndex = 3,
        })
        b.MouseEnter:Connect(function() 
            tween(card2:FindFirstChildOfClass("Frame"), { BackgroundTransparency = 0.3 })
        end)
        b.MouseLeave:Connect(function() 
            tween(card2:FindFirstChildOfClass("Frame"), { BackgroundTransparency = 1 })
        end)
        b.MouseButton1Click:Connect(fn)
    end

    local function toggle(parent, txt, get, fn, suffix)
        local card2 = shell(parent, 36)
        local hit = mk("TextButton", card2, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "",
            Active = true, AutoButtonColor = false, ZIndex = 4,
        })
        local circ = corner(mk("Frame", card2, {
            Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(12, 13),
            BackgroundColor3 = UIC.dim, BorderSizePixel = 0, ZIndex = 4,
        }), 5)
        local titleLabel = mk("TextLabel", card2, {
            Size = suffix and UDim2.new(0, 96, 1, 0) or UDim2.new(1, -70, 1, 0),
            Position = UDim2.fromOffset(28, 0),
            BackgroundTransparency = 1, Text = txt, Font = UIFB, TextSize = 12,
            TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        if suffix then
            mk("TextLabel", card2, {
                Size = UDim2.new(1, -180, 1, 0), Position = UDim2.fromOffset(126, 0),
                BackgroundTransparency = 1, Text = suffix, Font = UIF,
                TextSize = 9, TextColor3 = UIC.dim,
                TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 3,
            })
        end
        local pill = corner(mk("Frame", card2, {
            Size = UDim2.fromOffset(40, 20), Position = UDim2.new(1, -52, 0.5, -10),
            BackgroundColor3 = UIC.track, BorderSizePixel = 0, ZIndex = 3,
        }), 10)
        local knob = corner(mk("Frame", pill, {
            Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(2, 2),
            BackgroundColor3 = UIC.dim, BorderSizePixel = 0, ZIndex = 4,
        }), 8)
        local function paint(instant)
            local v = get()
            local pc = v and Color3.fromRGB(235, 235, 235) or Color3.fromRGB(48, 48, 48)
            local kc = v and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(170, 170, 170)
            local kp = UDim2.fromOffset(v and 22 or 2, 2)
            local cc = v and Color3.fromRGB(235, 235, 235) or Color3.fromRGB(48, 48, 48)
            if instant then
                pill.BackgroundColor3, knob.BackgroundColor3, knob.Position = pc, kc, kp
                circ.BackgroundColor3 = cc
            else
                tween(pill, { BackgroundColor3 = pc })
                tween(knob, { BackgroundColor3 = kc, Position = kp })
                tween(circ, { BackgroundColor3 = cc })
            end
        end
        hit.MouseButton1Click:Connect(function() fn(); paint() end)
        paint(true)
        return paint
    end

    local function keybind(parent, txt, getName, setName)
        local card2 = shell(parent, 36)
        mk("TextLabel", card2, {
            Size = UDim2.new(1, -90, 1, 0), Position = UDim2.fromOffset(14, 0),
            BackgroundTransparency = 1, Text = txt, Font = UIFB, TextSize = 12,
            TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local btn = corner(mk("TextButton", card2, {
            Size = UDim2.fromOffset(64, 22), Position = UDim2.new(1, -76, 0.5, -11),
            BackgroundColor3 = UIC.track, Text = "", Font = UIFB, TextSize = 11,
            TextColor3 = UIC.txt, AutoButtonColor = false, Active = true, ZIndex = 4,
        }), 6)
        local listening, conn = false, nil
        local function repaint()
            if listening then btn.Text = "..."; return end
            local k = getName()
            btn.Text = (type(k) == "string" and k ~= "") and k or "NONE"
        end
        local function stop()
            listening = false
            _G.StickyBindListening = false
            _G.StickyCapturingKey = false
            if conn then conn:Disconnect(); conn = nil end
            tween(btn, { BackgroundColor3 = UIC.track })
            repaint()
        end
        btn.MouseButton1Click:Connect(function()
            if listening then stop(); return end
            listening = true
            _G.StickyBindListening = true
            _G.StickyCapturingKey = true
            tween(btn, { BackgroundColor3 = UIC.acc })
            btn.TextColor3 = UIC.bg
            repaint()
            conn = game:GetService("UserInputService").InputBegan:Connect(function(inp)
                if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
                local kn = inp.KeyCode.Name
                if kn == "Escape" or kn == "Backspace" or kn == "Delete" then
                    setName(nil)
                else
                    setName(kn)
                end
                btn.TextColor3 = UIC.txt
                stop()
                pcall(saveTpSettings)
            end)
        end)
        btn.MouseButton2Click:Connect(function()
            if listening then stop(); return end
            setName(nil)
            repaint()
            pcall(saveTpSettings)
        end)
        repaint()
        return repaint
    end

    local function input(parent, txt, hint, get, set)
        local card2 = shell(parent, 52)
        mk("TextLabel", card2, {
            Size = UDim2.new(1, -24, 0, 12), Position = UDim2.fromOffset(14, 8),
            BackgroundTransparency = 1, Text = txt, Font = UIF, TextSize = 11,
            TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local box = mk("TextBox", card2, {
            Size = UDim2.new(1, -24, 0, 20), Position = UDim2.fromOffset(14, 24),
            BackgroundTransparency = 1, Font = UIFB, TextSize = 12,
            TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left,
            PlaceholderText = hint, PlaceholderColor3 = UIC.line,
            ClearTextOnFocus = false, Text = tostring(get() or ""),
            TextTruncate = Enum.TextTruncate.AtEnd, Active = true, ZIndex = 4,
        })
        box.FocusLost:Connect(function() set(box.Text) end)
        return box
    end

    local function dropdown(parent, txt, options, get, set)
        local HEAD, ROW = 40, 26
        local card2 = shell(parent, HEAD)
        card2.ClipsDescendants = true
        mk("TextLabel", card2, {
            Size = UDim2.new(1, -24, 0, 12), Position = UDim2.fromOffset(14, 6),
            BackgroundTransparency = 1, Text = txt, Font = UIF, TextSize = 11,
            TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local cur = mk("TextLabel", card2, {
            Size = UDim2.new(1, -44, 0, 14), Position = UDim2.fromOffset(14, 20),
            BackgroundTransparency = 1, Font = UIFB, TextSize = 12,
            TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Text = "", ZIndex = 3,
        })
        local arrow = mk("TextLabel", card2, {
            Size = UDim2.fromOffset(20, 14), Position = UDim2.new(1, -32, 0, 20),
            BackgroundTransparency = 1, Font = UIFB, TextSize = 11,
            TextColor3 = UIC.acc, TextXAlignment = Enum.TextXAlignment.Right,
            Text = "v", ZIndex = 3,
        })
        local hit = mk("TextButton", card2, {
            Size = UDim2.new(1, 0, 0, HEAD), BackgroundTransparency = 1, Text = "",
            Active = true, AutoButtonColor = false, ZIndex = 4,
        })
        local list = mk("Frame", card2, {
            Position = UDim2.fromOffset(0, HEAD), Size = UDim2.new(1, 0, 0, #options * ROW),
            BackgroundTransparency = 1, Visible = false, ZIndex = 3,
        })
        mk("UIListLayout", list, { SortOrder = Enum.SortOrder.LayoutOrder })
        local open, rows = false, {}
        local function paint()
            local v = get()
            cur.Text = (type(v) == "string" and v ~= "") and v or tostring(options[1])
            for _, r in ipairs(rows) do
                local on = (r.name == cur.Text)
                r.lbl.TextColor3 = on and UIC.acc or UIC.dim
                r.bg.BackgroundTransparency = on and 0.85 or 1
            end
        end
        local function setOpen(v)
            open = v
            list.Visible = v
            arrow.Text = v and "^" or "v"
            tween(card2, {
                Size = UDim2.new(1, 0, 0, v and (HEAD + #options * ROW + 6) or HEAD),
            })
        end
        for i, name in ipairs(options) do
            local rb = mk("TextButton", list, {
                Size = UDim2.new(1, 0, 0, ROW), BackgroundColor3 = UIC.acc,
                BackgroundTransparency = 1, BorderSizePixel = 0, Text = "",
                AutoButtonColor = false, Active = true, LayoutOrder = i, ZIndex = 4,
            })
            local rl = mk("TextLabel", rb, {
                Size = UDim2.new(1, -30, 1, 0), Position = UDim2.fromOffset(22, 0),
                BackgroundTransparency = 1, Text = name, Font = UIFB, TextSize = 11,
                TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
            })
            rows[#rows + 1] = { name = name, lbl = rl, bg = rb }
            rb.MouseButton1Click:Connect(function()
                set(name)
                paint()
                setOpen(false)
            end)
        end
        hit.MouseButton1Click:Connect(function() setOpen(not open) end)
        paint()
        return paint
    end

    local function slider(parent, txt, min, max, get, set, step)
        step = step or 1
        local card2 = shell(parent, 50)
        mk("TextLabel", card2, {
            Size = UDim2.new(1, -76, 0, 14), Position = UDim2.fromOffset(14, 8),
            BackgroundTransparency = 1, Text = txt, Font = UIF, TextSize = 11,
            TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local val = mk("TextLabel", card2, {
            Size = UDim2.fromOffset(52, 14), Position = UDim2.new(1, -64, 0, 8),
            BackgroundTransparency = 1, Font = UIFB, TextSize = 12, TextColor3 = UIC.txt,
            TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 3,
        })
        local track = corner(mk("TextButton", card2, {
            Size = UDim2.new(1, -24, 0, 6), Position = UDim2.fromOffset(14, 32),
            BackgroundColor3 = UIC.track, Text = "", AutoButtonColor = false,
            Active = true, BorderSizePixel = 0, ZIndex = 3,
        }), 3)
        local fill = corner(mk("Frame", track, {
            Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = UIC.acc,
            BorderSizePixel = 0, ZIndex = 4,
        }), 3)
        local knob = mk("TextLabel", track, {
            Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0), BackgroundTransparency = 1,
            Text = "➜", Font = UIFB, TextSize = 14, TextColor3 = UIC.txt,
            TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 5,
        })

        local function refresh()
            local v = math.clamp(tonumber(get()) or min, min, max)
            local rel = (v - min) / math.max(max - min, 1e-6)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            val.Text = step < 1 and string.format("%.2f", v) or tostring(math.floor(v + 0.5))
        end
        local function applyAt(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            set(math.clamp(math.floor((min + (max - min) * rel) / step + 0.5) * step, min, max))
            refresh()
        end

        local sliding = false
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                sliding = true; tween(knob, { Size = UDim2.fromOffset(18, 18) }); applyAt(i.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch) then applyAt(i.Position.X) end
        end)
        UIS.InputEnded:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch) then
                sliding = false; tween(knob, { Size = UDim2.fromOffset(16, 16) }); saveTpSettings()
            end
        end)
        refresh()
    end

    do
        local dragging, dragStart, startPos, dragInput
        card.Active = true
        rail.Active, body.Active = true, true

        local function begin(i)
            if _G.StickyAllUiDragLocked == true then return end
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging, dragStart, startPos = true, i.Position, root.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End and dragging then
                    dragging = false
                    _G._stp_panelX = root.Position.X.Offset
                    _G._stp_panelY = root.Position.Y.Offset
                    saveTpSettings()
                end
            end)
        end
        local function track(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch then dragInput = i end
        end
        for _, o in ipairs({ card, rail, body }) do
            o.InputBegan:Connect(begin)
            o.InputChanged:Connect(track)
        end
        UIS.InputChanged:Connect(function(i)
            if _G.StickyAllUiDragLocked == true or not dragging or i ~= dragInput then return end
            local d = i.Position - dragStart
            root.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
        end)
    end

	do
		local miniSg = mk("ScreenGui", nil, { Name = "StickyMiniUI", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999997, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Enabled = true })
		pcall(function() miniSg.Parent = guiParent end)
		local miniRoot = corner(mk("Frame", miniSg, { Name = "MiniRoot", Active = true, Size = UDim2.fromOffset(280, 210), Position = UDim2.fromOffset(24, 100), BackgroundColor3 = Color3.fromRGB(5,5,5), BorderSizePixel = 0, ZIndex = 20 }), 8)
		local stroke = Instance.new("UIStroke"); stroke.Thickness = 1; stroke.Color = Color3.fromRGB(255,255,255); stroke.Transparency = 0.2; stroke.Parent = miniRoot
		local miniSig = mk("TextLabel", miniRoot, {
		    Name = "StickySignature", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -2),
		    Size = UDim2.new(1, -16, 0, 16), BackgroundTransparency = 1, Text = "leaked at discord.gg/Z7vPrxecnJ",
		    Font = Enum.Font.GothamBold, TextScaled = true, TextColor3 = Color3.fromRGB(165, 165, 165), ZIndex = 30,
		})
		mk("UITextSizeConstraint", miniSig, { MaxTextSize = 12, MinTextSize = 7 })
		pcall(_G.StickyRememberPanel, miniRoot, "MiniUI")
		local head = mk("Frame", miniRoot, { Size = UDim2.new(1,0,0,38), BackgroundColor3 = Color3.fromRGB(16,16,16), BorderSizePixel = 0, ZIndex = 21 }); corner(head,8)
		mk("TextLabel", head, { Size = UDim2.new(1,-20,1,0), Position = UDim2.fromOffset(14,0), BackgroundTransparency = 1, Text = "MINI UI", Font = UIFB, TextSize = 14, TextColor3 = Color3.fromRGB(255,255,255), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22 })
		mk("Frame", miniRoot, { Position = UDim2.fromOffset(12,42), Size = UDim2.new(1,-24,0,1), BackgroundColor3 = Color3.fromRGB(70,70,70), BorderSizePixel = 0, ZIndex = 22 })
		local manualTp = corner(mk("TextButton", miniRoot, { Position = UDim2.fromOffset(12,48), Size = UDim2.new(1,-24,0,30), BackgroundColor3 = Color3.fromRGB(235,235,235), BorderSizePixel = 0, Text = "TELEPORT MANUAL", Font = UIFB, TextSize = 12, TextColor3 = Color3.fromRGB(0,0,0), AutoButtonColor = false, Active = true, ZIndex = 21 }),6)
		manualTp.MouseButton1Click:Connect(function() task.spawn(function() if diag() == 0 then return end; if _G.StickyStartSideTP then pcall(_G.StickyStartSideTP) else pcall(doVelocityTP,true) end end) end)
		local function miniToggle(text, y, getter, setter)
			local b = corner(mk("TextButton", miniRoot, { Position=UDim2.fromOffset(12,y), Size=UDim2.new(1,-24,0,28), BackgroundColor3=Color3.fromRGB(42,42,42), BorderSizePixel=0, Text=text, Font=UIFB, TextSize=11, TextColor3=Color3.fromRGB(255,255,255), AutoButtonColor=false, Active=true, ZIndex=21 }),6)
			local function paint() local on=getter(); b.Text=text .. (on and "  ON" or "  OFF"); b.BackgroundColor3=on and Color3.fromRGB(235,235,235) or Color3.fromRGB(42,42,42); b.TextColor3=on and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255) end
			b.MouseButton1Click:Connect(function() setter(); paint() end); paint(); return b
		end
		miniToggle("CARPET SPEED",84,function() return _G.StickyCarpetSpeed==true end,function() if type(_G.StickySetCarpetSpeed)=="function" then pcall(_G.StickySetCarpetSpeed,not (_G.StickyCarpetSpeed==true)) end end)
		local floatOn, floatConn = false, nil
		miniToggle("FLOAT (UPWARD)",116,function() return floatOn end,function()
			floatOn=not floatOn
			if floatConn then pcall(function() floatConn:Disconnect() end); floatConn=nil end
			if floatOn then floatConn=game:GetService("RunService").Heartbeat:Connect(function() local plr=game:GetService("Players").LocalPlayer; local ch=plr and plr.Character; local hrp=ch and ch:FindFirstChild("HumanoidRootPart"); if hrp then local v=hrp.AssemblyLinearVelocity; hrp.AssemblyLinearVelocity=Vector3.new(v.X,math.max(v.Y,18),v.Z) end end) end
		end)
		local cloneBtn = corner(mk("TextButton", miniRoot, { Position=UDim2.fromOffset(12,148), Size=UDim2.new(1,-24,0,28), BackgroundColor3=Color3.fromRGB(42,42,42), BorderSizePixel=0, Text="CLONE", Font=UIFB, TextSize=11, TextColor3=Color3.fromRGB(255,255,255), AutoButtonColor=false, Active=true, ZIndex=21 }),6)
		cloneBtn.MouseButton1Click:Connect(function() task.spawn(function() local action=_G.StickyDoClone or doClone; if type(action)=="function" then pcall(action) end end) end)
		_G.StickyInstaTpBrainrot = true
		_G.StickyCFrameGoTo = true
		local dragging, dragStart, startPos, dragInput
		miniRoot.InputBegan:Connect(function(i) if _G.StickyAllUiDragLocked==true then return end; if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end; dragging,dragStart,startPos=true,i.Position,miniRoot.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end) end)
		miniRoot.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then dragInput=i end end)
		UIS.InputChanged:Connect(function(i) if _G.StickyAllUiDragLocked==true or not dragging or i~=dragInput then return end; local d=i.Position-dragStart; miniRoot.Position=UDim2.fromOffset(startPos.X.Offset+d.X,startPos.Y.Offset+d.Y) end)
		_G.StickyMiniUIOn = miniSg.Enabled == true
		_G.StickySetMiniUI=function(value) miniSg.Enabled=value==true; _G.StickyMiniUIOn=miniSg.Enabled end
		_G.StickyToggleMiniUI=function() _G.StickySetMiniUI(not miniSg.Enabled) end
		_G.StickyOpenTeleportSettings=function() if type(_G.StickyShowTeleportSettings)=="function" then _G.StickyShowTeleportSettings() end end
	end

	do
		local invSg=mk("ScreenGui",nil,{Name="StickyInvisibleStealUI",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=999996,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Enabled=true}); pcall(function() invSg.Parent=guiParent end)
			local root=corner(mk("Frame",invSg,{Name="InvisibleStealRoot",Active=true,Size=UDim2.fromOffset(280,212),Position=UDim2.fromOffset(320,100),BackgroundColor3=Color3.fromRGB(5,5,5),BorderSizePixel=0,ZIndex=20}),8)
		local st=Instance.new("UIStroke"); st.Thickness=1; st.Color=Color3.fromRGB(255,255,255); st.Transparency=0.2; st.Parent=root
		local invSig = mk("TextLabel", root, {
		    Name = "StickySignature", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -2),
		    Size = UDim2.new(1, -16, 0, 16), BackgroundTransparency = 1, Text = "leaked at discord.gg/Z7vPrxecnJ",
		    Font = Enum.Font.GothamBold, TextScaled = true, TextColor3 = Color3.fromRGB(165, 165, 165), ZIndex = 30,
		})
		mk("UITextSizeConstraint", invSig, { MaxTextSize = 12, MinTextSize = 7 })
		pcall(_G.StickyRememberPanel, root, "InvisibleStealUI")
		local h=mk("Frame",root,{Size=UDim2.new(1,0,0,38),BackgroundColor3=Color3.fromRGB(16,16,16),BorderSizePixel=0,ZIndex=21}); corner(h,8)
		mk("TextLabel",h,{Size=UDim2.new(1,-20,1,0),Position=UDim2.fromOffset(14,0),BackgroundTransparency=1,Text="INVISIBLE STEAL",Font=UIFB,TextSize=14,TextColor3=Color3.fromRGB(255,255,255),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=22})
		local invDragging, invDragStart, invStartPos, invDragInput
		h.Active=true
		h.InputBegan:Connect(function(i) if _G.StickyAllUiDragLocked==true then return end; if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end; invDragging,invDragStart,invStartPos=true,i.Position,root.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then invDragging=false end end) end)
		h.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then invDragInput=i end end)
		UIS.InputChanged:Connect(function(i) if _G.StickyAllUiDragLocked==true or not invDragging or i~=invDragInput then return end; local d=i.Position-invDragStart; root.Position=UDim2.fromOffset(invStartPos.X.Offset+d.X,invStartPos.Y.Offset+d.Y) end)
		_G.StickyInvisibleStealUIOn = invSg.Enabled == true
_G.StickySetInvisibleStealUI = function(value)
    invSg.Enabled = value == true
    _G.StickyInvisibleStealUIOn = invSg.Enabled
end
local function row(text,y,getter,setter) local b=corner(mk("TextButton",root,{Position=UDim2.fromOffset(12,y),Size=UDim2.new(1,-24,0,28),BackgroundColor3=Color3.fromRGB(42,42,42),BorderSizePixel=0,Text="",Font=UIFB,TextSize=11,TextColor3=Color3.fromRGB(255,255,255),AutoButtonColor=false,Active=true,ZIndex=21}),6); local function paint() local on=getter(); b.Text=text..(on and "  ON" or "  OFF"); b.BackgroundColor3=on and Color3.fromRGB(235,235,235) or Color3.fromRGB(42,42,42); b.TextColor3=on and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255) end; b.MouseButton1Click:Connect(function() setter(); paint() end); paint(); return b end
		row("INVISIBLE STEAL",48,function() return _G.StickyInvisActive==true end,function() if type(_G.StickyInvisToggle)=="function" then pcall(_G.StickyInvisToggle) elseif type(_G.StickyInvisStart)=="function" then if _G.StickyInvisActive then pcall(_G.StickyInvisStop) else pcall(_G.StickyInvisStart) end end end)
		row("AUTO RECOVER",80,function() return _G.StickyInvisAutoRecover==true end,function() _G.StickyInvisAutoRecover=not (_G.StickyInvisAutoRecover==true); if type(saveTpSettings)=="function" then pcall(saveTpSettings) end end)
		row("AUTO INVISIBLE ON STEAL",112,function() return _G.StickyInvisAuto==true end,function() _G.StickyInvisAuto=not (_G.StickyInvisAuto==true); if type(_G.StickyInvisSync)=="function" then pcall(_G.StickyInvisSync) end; if type(saveTpSettings)=="function" then pcall(saveTpSettings) end end)
		local function valueLine(title,y,key,minv,maxv,step,suffix) local l=mk("TextLabel",root,{Position=UDim2.fromOffset(12,y),Size=UDim2.new(1,-100,0,22),BackgroundTransparency=1,Text="",Font=UIFB,TextSize=11,TextColor3=Color3.fromRGB(255,255,255),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=22}); local function paint() l.Text=title..": "..tostring(_G[key] or minv)..suffix end; local function adj(d) _G[key]=math.clamp((tonumber(_G[key]) or minv)+d,minv,maxv); if key=="StickyInvisAngle" then _G.InvisStealAngle=_G[key] else _G.SinkSliderValue=_G[key] end; saveTpSettings(); paint() end; for _,spec in ipairs({{"−",200,-step},{"+",234,step}}) do local b=corner(mk("TextButton",root,{Position=UDim2.fromOffset(spec[2],y),Size=UDim2.fromOffset(30,22),BackgroundColor3=Color3.fromRGB(42,42,42),BorderSizePixel=0,Text=spec[1],Font=UIFB,TextSize=14,TextColor3=Color3.fromRGB(255,255,255),AutoButtonColor=false,Active=true,ZIndex=22}),5); b.MouseButton1Click:Connect(function() adj(spec[3]) end) end; paint() end
			valueLine("ROTATION",146,"StickyInvisAngle",0,360,5,"°"); valueLine("DEPTH",172,"StickyInvisDepth",0,10,0.5,"")

		task.spawn(function() while root.Parent do if _G.StickyInvisAutoRecover==true then local plr=game:GetService("Players").LocalPlayer; local ch=plr and plr.Character; local hum=ch and ch:FindFirstChildOfClass("Humanoid"); if hum then local state=hum:GetState(); if state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown or state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Dead then pcall(function() hum.PlatformStand=false; hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) end end end; task.wait(0.5) end end)
		_G.StickyToggleExtrasUI=function() _G.StickySetInvisibleStealUI(not invSg.Enabled) end
	end

    local home = tab("Home", 1)
    label(home, "dashboard", true)
    label(home, "DEVELOPER: STICKY")
    local infoCard = shell(home, 74)
    mk("TextLabel", infoCard, {
        Size = UDim2.new(1, -24, 1, -12), Position = UDim2.fromOffset(12, 6),
        BackgroundTransparency = 1,
        Text = "we are currently looking for helpers & mods. Open a ticket in the server if you want to be a MODERATOR for our server!",
        Font = UIF, TextSize = 11, TextColor3 = UIC.txt, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 3,
    })
    local discordCard = shell(home, 36)
    local discordBtn = mk("TextButton", discordCard, {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = "DISCORD  •  https://discord.gg/hcjvNKvEUq",
        Font = UIFB, TextSize = 11, TextColor3 = UIC.txt,
        TextXAlignment = Enum.TextXAlignment.Center, AutoButtonColor = false, Active = true, ZIndex = 3,
    })
    discordBtn.MouseButton1Click:Connect(function()
        pcall(function() if type(setclipboard) == "function" then setclipboard("https://discord.gg/hcjvNKvEUq") end end)
        discordBtn.Text = "DISCORD LINK COPIED"
        task.delay(1.2, function()
            if discordBtn and discordBtn.Parent then discordBtn.Text = "DISCORD  •  https://discord.gg/hcjvNKvEUq" end
        end)
    end)
    local pri = tab("Priority", 2)

    local function mkSubTabs(parent)
        local tabsFrame = mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1,
        })
        local names = {"Brainrots", "Mutations", "Blacklist"}
        local w = 1 / #names
        for i, n in ipairs(names) do
            local b = corner(mk("TextButton", tabsFrame, {
                Size = UDim2.new(w, -4, 1, 0), Position = UDim2.new(w * (i - 1), 2, 0, 0),
                BackgroundColor3 = UIC.acc, Text = n, Font = UIFB, TextSize = 11,
                TextColor3 = UIC.bg, AutoButtonColor = false, Active = true, ZIndex = 3,
            }), 6)
            b.MouseButton1Click:Connect(function()
                currentPriTab = n:lower():gsub("s$", "")
                for _, c in ipairs(tabsFrame:GetChildren()) do
                    if c:IsA("TextButton") then
                        c.BackgroundColor3 = (c == b) and UIC.acc or UIC.track
                        c.TextColor3 = (c == b) and UIC.bg or UIC.txt
                    end
                end
                if refreshPri then refreshPri() end
            end)
            if i == 1 then
                b.BackgroundColor3, b.TextColor3 = UIC.acc, UIC.bg
            else
                b.BackgroundColor3, b.TextColor3 = UIC.track, UIC.txt
            end
        end
    end
    mkSubTabs(pri)

    local addBox
    do
        local card2 = shell(pri, 36)
        stroke(card2)
        addBox = mk("TextBox", card2, {
            Size = UDim2.new(1, -74, 0, 24), Position = UDim2.fromOffset(10, 6),
            BackgroundColor3 = UIC.track, BorderSizePixel = 0,
            Font = UIF, TextSize = 12, TextColor3 = UIC.txt,
            TextXAlignment = Enum.TextXAlignment.Left,
            PlaceholderText = "type a name, then Enter", PlaceholderColor3 = UIC.dim,
            ClearTextOnFocus = false, Text = "", Active = true, ZIndex = 4,
        })
        corner(addBox, 6)
        mk("UIPadding", addBox, { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
        local addBtn = corner(mk("TextButton", card2, {
            Size = UDim2.fromOffset(52, 24), Position = UDim2.new(1, -60, 0, 6),
            BackgroundColor3 = UIC.acc, Text = "ADD", Font = UIFB, TextSize = 11,
            TextColor3 = UIC.bg, AutoButtonColor = false, Active = true, ZIndex = 4,
        }), 6)
        local function doAdd()
            local name = (addBox.Text or ""):match("^%s*(.-)%s*$")
            if name and name ~= "" then
                if currentPriTab == "brainrot" then
                    table.insert(_G.SHARED_PRIORITY_ITEMS, name)
                elseif currentPriTab == "mutation" then
                    table.insert(_G.SHARED_MUTATION_PRIORITY, name)
                elseif currentPriTab == "blacklist" then
                    if type(_G.SHARED_BLACKLIST_ITEMS) ~= "table" then _G.SHARED_BLACKLIST_ITEMS = {} end
                    table.insert(_G.SHARED_BLACKLIST_ITEMS, name)
                else
                    table.insert(_G.SHARED_TRAIT_PRIORITY, name)
                end
                _G.StickyPriVersion = (_G.StickyPriVersion or 0) + 1
                pcall(saveTpSettings)
                addBox.Text = ""
                if refreshPri then refreshPri() end
            end
        end
        addBtn.MouseButton1Click:Connect(doAdd)
        addBtn.MouseEnter:Connect(function() tween(addBtn, { BackgroundColor3 = UIC.txt }) end)
        addBtn.MouseLeave:Connect(function() tween(addBtn, { BackgroundColor3 = UIC.acc }) end)
        addBox.FocusLost:Connect(function(enter) if enter then doAdd() end end)
    end

    label(pri, "priority  -  top = highest")
    local rowsHost = mk("Frame", pri, {
        Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 2,
    })
    mk("UIListLayout", rowsHost, { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })

    local function getListAndIcon()
        if currentPriTab == "brainrot" then
            return _G.SHARED_PRIORITY_ITEMS, nil
        elseif currentPriTab == "mutation" then
            return _G.SHARED_MUTATION_PRIORITY, MUTATION_ICONS
        elseif currentPriTab == "blacklist" then
            if type(_G.SHARED_BLACKLIST_ITEMS) ~= "table" then _G.SHARED_BLACKLIST_ITEMS = {} end
            return _G.SHARED_BLACKLIST_ITEMS, nil
        else
            return _G.SHARED_TRAIT_PRIORITY, TRAIT_ICONS
        end
    end

    refreshPri = function()
        for _, c in ipairs(rowsHost:GetChildren()) do
            if c:IsA("GuiObject") then c:Destroy() end
        end
        local L, icons = getListAndIcon()
        for i = 1, #L do
            local nm = tostring(L[i])
            local row = corner(mk("Frame", rowsHost, {
                Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = UIC.card,
                BorderSizePixel = 0, LayoutOrder = i, ZIndex = 2,
            }), 6)
            stroke(row)
            local iconId = icons and icons[nm]
            local textOff = 12
            if iconId and type(iconId) == "string" then
                local icon = mk("ImageLabel", row, {
                    Size = UDim2.fromOffset(22, 22), Position = UDim2.fromOffset(10, 4),
                    BackgroundTransparency = 1, Image = tostring(iconId),
                    ZIndex = 3,
                })
                textOff = 40
            end
            mk("TextLabel", row, {
                Size = UDim2.new(1, (currentPriTab == "mutation") and -148 or -104, 1, 0),
                Position = UDim2.fromOffset(textOff, 0),
                BackgroundTransparency = 1, Text = i .. ".  " .. nm,
                Font = UIF, TextSize = 12, TextColor3 = UIC.txt,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3,
            })
            local function commit()
                _G.StickyPriVersion = (_G.StickyPriVersion or 0) + 1
                pcall(saveTpSettings)
                refreshPri()
            end
            local function mini(xoff, sym, act)
                local b = corner(mk("TextButton", row, {
                    Size = UDim2.fromOffset(26, 22), Position = UDim2.new(1, xoff, 0.5, -11),
                    BackgroundColor3 = UIC.track, Text = sym, Font = UIFB, TextSize = 12,
                    TextColor3 = UIC.txt, AutoButtonColor = false, Active = true, ZIndex = 3,
                }), 6)
                b.MouseEnter:Connect(function() tween(b, { BackgroundColor3 = UIC.line }) end)
                b.MouseLeave:Connect(function() tween(b, { BackgroundColor3 = UIC.track }) end)
                b.MouseButton1Click:Connect(act)
                return b
            end
            mini(-98, "\u{25B2}", function() if i > 1 then L[i], L[i - 1] = L[i - 1], L[i]; commit() end end)
            mini(-68, "\u{25BC}", function() if i < #L then L[i], L[i + 1] = L[i + 1], L[i]; commit() end end)
            mini(-36, "X", function()
                local nm = L[i]
                table.remove(L, i)
                if type(nm) == "string" and nm ~= "" then
                    if currentPriTab == "brainrot" then
                        local BL = _G.SHARED_BLACKLIST_ITEMS
                        if type(BL) ~= "table" then BL = {}; _G.SHARED_BLACKLIST_ITEMS = BL end
                        local has = false
                        for _, v in ipairs(BL) do if v == nm then has = true; break end end
                        if not has then BL[#BL+1] = nm end
                    elseif currentPriTab == "blacklist" then
                        local PL = _G.SHARED_PRIORITY_ITEMS
                        if type(PL) ~= "table" then PL = {}; _G.SHARED_PRIORITY_ITEMS = PL end
                        local has = false
                        for _, v in ipairs(PL) do if v == nm then has = true; break end end
                        if not has then PL[#PL+1] = nm end
                    end
                end
                commit()
            end)
            if currentPriTab == "mutation" then
                local D = _G.SHARED_MUTATION_DISABLED
                local off = D[nm] == true
                local tg = corner(mk("TextButton", row, {
                    Size = UDim2.fromOffset(34, 22), Position = UDim2.new(1, -136, 0.5, -11),
                    BackgroundColor3 = off and UIC.track or UIC.acc,
                    Text = off and "OFF" or "ON", Font = UIFB, TextSize = 10,
                    TextColor3 = off and UIC.dim or UIC.bg,
                    AutoButtonColor = false, Active = true, ZIndex = 3,
                }), 6)
                tg.MouseButton1Click:Connect(function()
                    if D[nm] then D[nm] = nil else D[nm] = true end
                    commit()
                end)
                if off then
                    for _, c in ipairs(row:GetChildren()) do
                        if c:IsA("TextLabel") then c.TextColor3 = UIC.dim end
                        if c:IsA("ImageLabel") then c.ImageTransparency = 0.6 end
                    end
                end
            end
        end
    end
    tabOpenHook["Priority"] = function() if refreshPri then refreshPri() end end

    local esp = tab("ESP", 3)
    label(esp, "world", true)
    toggle(esp, "XRAY BASES",
        function() return _G.StickyXray == true end,
        function()
            _G.StickyXray = not (_G.StickyXray == true)
            if _G.StickyXray then
                if type(_G.StickyStartXrayRetry) == "function" then pcall(_G.StickyStartXrayRetry)
                elseif type(_G.StickyEnableXray) == "function" then pcall(_G.StickyEnableXray) end
            else
                if type(_G.StickyDisableXray) == "function" then pcall(_G.StickyDisableXray) end
            end
            saveTpSettings()
        end)
    slider(esp, "Xray Alpha", 0.05, 0.95,
        function() return tonumber(_G.StickyXrayAlpha) or 0.5 end,
        function(v)
            _G.StickyXrayAlpha = v
            if _G.StickyXray == true and type(_G.StickyEnableXray) == "function" then pcall(_G.StickyEnableXray) end
            saveTpSettings()
        end, 0.05)
    label(esp, "players")
    toggle(esp, "PLAYER ESP",
        function() return _G.StickyPlayerESP == true end,
        function()
            _G.StickyPlayerESP = not (_G.StickyPlayerESP == true)
            if type(_G.StickyRefreshPlayerESP) == "function" then pcall(_G.StickyRefreshPlayerESP) end
            saveTpSettings()
        end)
    label(esp, "performance")
    toggle(esp, "OPTIMIZER", function() return _G.StickyFpsOptimizer == true end, function()
        local enabled = not (_G.StickyFpsOptimizer == true)
        pcall(_G.StickySetFpsOptimizer, enabled)
        pcall(saveTpSettings)
    end, "REJOIN TO DISABLE THIS!")
    local keys = tab("Keybinds", 4)
    label(keys, "keybinds", true)
    do
        local _kbRepaints = {}
        local function track(fn)
            if type(fn) == "function" then _kbRepaints[#_kbRepaints+1] = fn end
            return fn
        end
        track(keybind(keys, "INVIS",
            function() return _G.StickyInvisKeyName end,
            function(k) _G.StickyInvisKeyName = k end))
        track(keybind(keys, "CARPET SPEED",
            function() return _G.StickyCarpetSpeedKeyName end,
            function(k) _G.StickyCarpetSpeedKeyName = k end))
        track(keybind(keys, "CLONE",
            function() return _G.StickyCloneKeyName or "V" end,
            function(k) _G.StickyCloneKeyName = k or "V" end))
        track(keybind(keys, "INSTA RESET",
            function() return _G.StickyResetKeyName end,
            function(k) _G.StickyResetKeyName = k end))
        track(keybind(keys, "DROP BRAINROT",
            function() return _G.StickyDropKeyName end,
            function(k) _G.StickyDropKeyName = k end))
        track(keybind(keys, "STEAL PRIORITY",
            function() return _G.StickyStealPrioKey or "P" end,
            function(k)
                _G.StickyStealPrioKey = k
                if type(_G.StickyRepaintStealMode) == "function" then pcall(_G.StickyRepaintStealMode) end
                if type(_G.StickyRepaintStealBarKeys) == "function" then pcall(_G.StickyRepaintStealBarKeys) end
            end))
        track(keybind(keys, "STEAL NEAREST",
            function() return _G.StickyStealNearKey or "F" end,
            function(k)
                _G.StickyStealNearKey = k
                if type(_G.StickyRepaintStealMode) == "function" then pcall(_G.StickyRepaintStealMode) end
                if type(_G.StickyRepaintStealBarKeys) == "function" then pcall(_G.StickyRepaintStealBarKeys) end
            end))
        track(keybind(keys, "UI OPEN",
            function() return _G.StickyUiOpenKey or "LeftControl" end,
            function(k) _G.StickyUiOpenKey = k or "LeftControl" end))
        _G.StickyRepaintKeybinds = function()
            for _, r in ipairs(_kbRepaints) do pcall(r) end
        end
    end

    local cfg = tab("Config", 5)
    label(cfg, "config", true)
    do
        local exportBtn = corner(mk("TextButton", cfg, {
            Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = UIC.acc,
            Text = "EXPORT TO CLIPBOARD", Font = UIFB, TextSize = 12,
            TextColor3 = UIC.bg, AutoButtonColor = false, Active = true, ZIndex = 3,
        }), 8)
        exportBtn.MouseButton1Click:Connect(function()
            pcall(function()
                local raw = readfile and readfile("SideTP.json")
                if type(raw) == "string" and #raw > 0 then
                    if type(setclipboard) == "function" then setclipboard(raw) end
                    
                else
                    
                end
            end)
        end)
        exportBtn.MouseEnter:Connect(function() tween(exportBtn, { BackgroundColor3 = UIC.txt }) end)
        exportBtn.MouseLeave:Connect(function() tween(exportBtn, { BackgroundColor3 = UIC.acc }) end)
    end
    do
        local card = shell(cfg, 104)
        stroke(card)
        local importBox = mk("TextBox", card, {
            Size = UDim2.new(1, -10, 0, 56), Position = UDim2.fromOffset(5, 5),
            BackgroundColor3 = UIC.track, BorderSizePixel = 0,
            Font = UIF, TextSize = 10, TextColor3 = UIC.txt,
            TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
            PlaceholderText = "paste exported JSON here", PlaceholderColor3 = UIC.dim,
            ClearTextOnFocus = false, Text = "", MultiLine = true, Active = true, ZIndex = 4,
        })
        corner(importBox, 6)
        mk("UIPadding", importBox, { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6) })
        local importBtn = corner(mk("TextButton", card, {
            Size = UDim2.new(1, -10, 0, 30), Position = UDim2.fromOffset(5, 68),
            BackgroundColor3 = UIC.acc, Text = "IMPORT AND SAVE", Font = UIFB, TextSize = 12,
            TextColor3 = UIC.bg, AutoButtonColor = false, Active = true, ZIndex = 4,
        }), 6)
        importBtn.MouseButton1Click:Connect(function()
            pcall(function()
                local HS = game:GetService("HttpService")
                local raw = importBox.Text or ""
                local ok, t = pcall(HS.JSONDecode, HS, raw)
                if not (ok and type(t) == "table" and type(t.priorityList) == "table") then
                    
                    return
                end
                if writefile then writefile("SideTP.json", raw) end
                
                importBox.Text = ""
            end)
        end)
        importBtn.MouseEnter:Connect(function() tween(importBtn, { BackgroundColor3 = UIC.txt }) end)
        importBtn.MouseLeave:Connect(function() tween(importBtn, { BackgroundColor3 = UIC.acc }) end)
    end
    do
        local resetBtn = corner(mk("TextButton", cfg, {
            Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = UIC.line,
            Text = "RESET TO DEFAULT", Font = UIFB, TextSize = 12,
            TextColor3 = UIC.txt, AutoButtonColor = false, Active = true, ZIndex = 3,
        }), 8)
        resetBtn.MouseButton1Click:Connect(function()
            pcall(function()
                if writefile then writefile("SideTP.json", _G.Sticky_DEFAULT_CONFIG_JSON) end
                
            end)
        end)
        resetBtn.MouseEnter:Connect(function() tween(resetBtn, { BackgroundColor3 = UIC.acc }) end)
        resetBtn.MouseLeave:Connect(function() tween(resetBtn, { BackgroundColor3 = UIC.line }) end)
    end

    if refreshPri then refreshPri() end
    selectTab("Home")
    _G.StickyPrioritySettingsPage = pri
    _G.StickyCompactUIHelpers = {
        label = label, toggle = toggle, slider = slider, dropdown = dropdown,
        saveTpSettings = type(saveTpSettings) == "function" and saveTpSettings or _G.StickySaveSettings,
    }
    _G.StickyMainScreenGui = sg
    sg.Enabled = false
    task.delay(1.5, diag)
end

do
    local RunService = game:GetService("RunService")
    local Lighting   = game:GetService("Lighting")
    local RS         = game:GetService("ReplicatedStorage")
    local LP         = game:GetService("Players").LocalPlayer

    local RAG_STATES = {
        [Enum.HumanoidStateType.Physics]     = true,
        [Enum.HumanoidStateType.Ragdoll]     = true,
        [Enum.HumanoidStateType.FallingDown] = true,
        [Enum.HumanoidStateType.GettingUp]   = true,
    }

    local conns, char, hum, hrp, anim = {}, nil, nil, nil, nil

    local function ragdolled()
        return hum ~= nil and RAG_STATES[hum:GetState()] == true
    end

    local function cleanup()
        if not char then return end
        pcall(function()
            for _, o in ipairs(char:GetDescendants()) do
                if o:IsA("AnimationConstraint") and not o.Enabled then
                    o.Enabled = true
                end
            end
        end)
        if anim then
            for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                local n = t.Animation and t.Animation.Name:lower() or ""
                if n:find("rag") or n:find("fall") or n:find("hurt") or n:find("down") then t:Stop(0) end
            end
        end
    end

    local function recover()
        if hum:GetState() == Enum.HumanoidStateType.Physics then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
        if hrp and hrp.Parent and not _G.StickyInvisActive then
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end)
        end
        cleanup()
        if not _G.StickyInvisActive then
            pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
        end
        pcall(function()
            local _ps = LP:FindFirstChild("PlayerScripts") or LP:WaitForChild("PlayerScripts", 10)
            require(_ps:WaitForChild("PlayerModule", 10)):GetControls():Enable()
        end)
    end

    local function bind(c)
        for _, v in pairs(conns) do pcall(function() v:Disconnect() end) end
        conns = {}
        char = c
        hum  = c:WaitForChild("Humanoid", 10)
        hrp  = c:WaitForChild("HumanoidRootPart", 10)
        anim = hum and hum:WaitForChild("Animator", 10)
        if not hum then return end

        conns[#conns + 1] = hum.StateChanged:Connect(function()
            if ragdolled() and not _G.StickyInvisActive then recover() end
        end)
        conns[#conns + 1] = c.DescendantAdded:Connect(function()
            if ragdolled() and not _G.StickyInvisActive then cleanup() end
        end)
        local f = 0
        conns[#conns + 1] = RunService.Heartbeat:Connect(function()
            f = f + 1
            if f < 2 then return end
            f = 0
            if not ragdolled() then return end
            if _G.StickyInvisActive then return end
            recover()
        end)
    end

    LP.CharacterAdded:Connect(function(c) pcall(bind, c) end)
    if LP.Character then pcall(bind, LP.Character) end

    local BAD = { Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true }
    local function nuke(o) if o and o.Parent and BAD[o.Name] then pcall(function() o:Destroy() end) end end

    local buzz
    local function muteBuzz()
        pcall(function()
            if not (buzz and buzz.Parent) then
                local ctl = RS:FindFirstChild("Controllers")
                local item = ctl and ctl:FindFirstChild("ItemController")
                local bee = item and item:FindFirstChild("BeeLauncherController")
                local s = bee and bee:FindFirstChild("Buzzing")
                if s and s:IsA("Sound") then buzz = s end
            end
            if buzz then
                buzz.Volume = 0
                if buzz.IsPlaying then buzz:Stop() end
            end
        end)
    end

    task.spawn(function()
        LP:WaitForChild("PlayerScripts", 8)
        _G.StickyBootWait()
        Lighting.DescendantAdded:Connect(nuke)
        do local n = 0
            for _, o in ipairs(Lighting:GetDescendants()) do
                n = n + 1; if n % 150 == 0 then task.wait() end
                nuke(o)
            end
        end
        muteBuzz()
        local acc = 0
        RunService.Heartbeat:Connect(function(dt)
            acc = acc + dt
            if acc >= 1.0 then acc = 0; muteBuzz() end
        end)
    end)
end

;(function()
    local C = {
        bg   = Color3.fromRGB(8, 8, 8),
        bg2  = Color3.fromRGB(16, 16, 16),
        row  = Color3.fromRGB(24, 24, 24),
        rowH = Color3.fromRGB(58, 58, 58),
        line = Color3.fromRGB(96, 96, 96),
        acc  = Color3.fromRGB(42, 42, 42),
        acc2 = Color3.fromRGB(210, 210, 210),
        txt  = Color3.fromRGB(255, 255, 255),
        dim  = Color3.fromRGB(160, 160, 160),
    }
    local MUT_COLORS = {
        Divine = Color3.fromRGB(180, 100, 255),
        Phantom = Color3.fromRGB(140, 160, 220),
        Gold = Color3.fromRGB(255, 190, 50),
        Diamond = Color3.fromRGB(80, 200, 220),
        Rainbow = Color3.fromRGB(255, 120, 180),
        Candy = Color3.fromRGB(255, 140, 200),
        Bloodrot = Color3.fromRGB(200, 40, 40),
        Cursed = Color3.fromRGB(120, 60, 180),
        Crystal = Color3.fromRGB(140, 220, 255),
        Cyber = Color3.fromRGB(60, 220, 180),
        None = Color3.fromRGB(140, 140, 145),
    }
    local FB, FR = Enum.Font.GothamBold, Enum.Font.Gotham
    local TS = game:GetService("TweenService")
    local EASE = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local function tw(o, p) TS:Create(o, EASE, p):Play() end

    local function mk(cls, parent, props)
        local o = Instance.new(cls)
        for k, v in pairs(props or {}) do o[k] = v end
        o.Parent = parent
        return o
    end
    local function round(o, r) mk("UICorner", o, { CornerRadius = UDim.new(0, r or 8) }) return o end

    local host = (gethui and gethui()) or game:GetService("CoreGui")
    pcall(function()
        local old = host:FindFirstChild("StickyTargets")
        if old then old:Destroy() end
    end)

    local sg = mk("ScreenGui", nil, {
        Name = "StickyTargets", ResetOnSpawn = false,
        IgnoreGuiInset = true, DisplayOrder = 999998,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Enabled = false,
    })
    pcall(function() sg.Parent = host end)
    if not sg.Parent then pcall(function() sg.Parent = (gethui and gethui()) or game:GetService("CoreGui") end) end
    task.defer(function()
        pcall(function()
            if not game:IsLoaded() then game.Loaded:Wait() end
        end)
        local LP = game:GetService("Players").LocalPlayer
        local t0 = os.clock()
        while not LP and (os.clock() - t0) < 30 do task.wait(0.1); LP = game:GetService("Players").LocalPlayer end
        if LP and not LP.Character then
            pcall(function() LP.CharacterAdded:Wait() end)
        end
        pcall(function()
            local c = LP and LP.Character
            if c then c:WaitForChild("HumanoidRootPart", 15) end
        end)
        task.wait(2)
        if sg and sg.Parent then sg.Enabled = true end
        _G.__StickyUiReady = true
        pcall(function()
            local host = (gethui and gethui()) or game:GetService("CoreGui")
            local bar = host and host:FindFirstChild("StickyStealBar")
            if not bar and LP then
                local pg = LP:FindFirstChild("PlayerGui")
                bar = pg and pg:FindFirstChild("StickyStealBar")
            end
            if bar then bar.Enabled = true end
        end)
        task.wait(3)
        if _G.StickyXray ~= false then
            _G.StickyXray = true
            if type(_G.StickyStartXrayRetry) == "function" then pcall(_G.StickyStartXrayRetry)
            elseif type(_G.StickyEnableXray) == "function" then pcall(_G.StickyEnableXray) end
        end
    end)
    task.delay(8, function()
        if sg and sg.Parent and not sg.Enabled then
            sg.Enabled = true
            _G.__StickyUiReady = true
        end
    end)

    local root = round(mk("Frame", sg, {
        Name = "Root", Active = true, BackgroundColor3 = Color3.fromRGB(4, 4, 4), BorderSizePixel = 0,
        Size = UDim2.fromOffset(260, 300),
        Position = UDim2.fromOffset(tonumber(_G._Sticky_tgtX) or 24,
            tonumber(_G._Sticky_tgtY) or 250),
    }), 10)
    local targetStroke = Instance.new("UIStroke")
    targetStroke.Thickness = 1
    targetStroke.Color = Color3.fromRGB(255, 255, 255)
    targetStroke.Transparency = 0.84
    targetStroke.Parent = root
    local targetsSig = mk("TextLabel", root, {
        Name = "StickySignature", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -2),
        Size = UDim2.new(1, -16, 0, 16), BackgroundTransparency = 1, Text = "leaked at discord.gg/Z7vPrxecnJ",
        Font = Enum.Font.GothamBold, TextScaled = true, TextColor3 = Color3.fromRGB(165, 165, 165), ZIndex = 11,
    })
    mk("UITextSizeConstraint", targetsSig, { MaxTextSize = 12, MinTextSize = 7 })
    pcall(_G.StickyRememberPanel, root, "StealTargets")
    local head = mk("TextLabel", root, {
        Position = UDim2.fromOffset(16, 8), Size = UDim2.new(1, -84, 0, 22),
        BackgroundTransparency = 1, Text = "STEAL TARGETS", Font = FB, TextSize = 15,
        TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = Enum.TextXAlignment.Left,
    })
    mk("TextLabel", root, {
        Position = UDim2.fromOffset(17, 31), Size = UDim2.new(1, -96, 0, 12),
        BackgroundTransparency = 1, Text = "LIVE SCANNER  /  READY", Font = FR, TextSize = 8,
        TextColor3 = Color3.fromRGB(145, 145, 145), TextXAlignment = Enum.TextXAlignment.Left,
    })
    mk("Frame", root, {
        Position = UDim2.fromOffset(16, 50), Size = UDim2.new(1, -32, 0, 1),
        BackgroundColor3 = Color3.fromRGB(72, 72, 72), BorderSizePixel = 0,
    })
    local targetPrioBtn, targetNearBtn
    local function paintStealModeBtns()
        local priority = _G.StickyStealMode ~= "nearest"
        if targetPrioBtn then
            targetPrioBtn.BackgroundColor3 = priority and Color3.fromRGB(238, 238, 238) or Color3.fromRGB(24, 24, 24)
            targetPrioBtn.TextColor3 = priority and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        end
        if targetNearBtn then
            targetNearBtn.BackgroundColor3 = priority and Color3.fromRGB(24, 24, 24) or Color3.fromRGB(238, 238, 238)
            targetNearBtn.TextColor3 = priority and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        end
    end
    _G.StickySetStealMode = function(mode)
        if mode ~= "nearest" then mode = "priority" end
        _G.StickyStealMode = mode
        paintStealModeBtns()
        if type(saveTpSettings) == "function" then pcall(saveTpSettings)
        elseif type(_G.StickySaveSettings) == "function" then pcall(_G.StickySaveSettings) end
    end
    _G.StickyRepaintStealMode = paintStealModeBtns
    local countBadge = round(mk("Frame", root, {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 14),
        Size = UDim2.fromOffset(42, 24), BackgroundColor3 = Color3.fromRGB(24, 24, 24),
        BorderSizePixel = 0,
    }), 6)
    local count = mk("TextLabel", countBadge, {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Text = "0", Font = FB, TextSize = 12, TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    targetPrioBtn = round(mk("TextButton", root, {
        Position = UDim2.fromOffset(16, 58), Size = UDim2.new(0.5, -20, 0, 24),
        BackgroundColor3 = Color3.fromRGB(238, 238, 238), BorderSizePixel = 0,
        Text = "STEAL PRIORITY", Font = FB, TextSize = 10,
        TextColor3 = Color3.fromRGB(0, 0, 0), AutoButtonColor = false, Active = true, ZIndex = 3,
    }), 5)
    targetNearBtn = round(mk("TextButton", root, {
        Position = UDim2.new(0.5, 4, 0, 58), Size = UDim2.new(0.5, -20, 0, 24),
        BackgroundColor3 = Color3.fromRGB(24, 24, 24), BorderSizePixel = 0,
        Text = "STEAL NEAREST", Font = FB, TextSize = 10,
        TextColor3 = Color3.fromRGB(255, 255, 255), AutoButtonColor = false, Active = true, ZIndex = 3,
    }), 5)
    targetPrioBtn.MouseButton1Click:Connect(function()
        _G.StickySetStealMode("priority")
        paintStealModeBtns()
    end)
    targetNearBtn.MouseButton1Click:Connect(function()
        _G.StickySetStealMode("nearest")
        paintStealModeBtns()
    end)
    paintStealModeBtns()
    local priorityPageBtn = round(mk("TextButton", root, {
        Position = UDim2.fromOffset(16, 86), Size = UDim2.new(1, -32, 0, 22),
        BackgroundColor3 = Color3.fromRGB(28, 28, 28), BorderSizePixel = 0,
        Text = "PRIORITY SETTINGS", Font = FB, TextSize = 9,
        TextColor3 = Color3.fromRGB(255, 255, 255), AutoButtonColor = false, Active = true, ZIndex = 4,
    }), 5)
    local emptyState = mk("TextLabel", root, {
        Position = UDim2.fromOffset(16, 144), Size = UDim2.new(1, -32, 0, 24),
        BackgroundTransparency = 1, Text = "SCANNING 🔎", Font = FB, TextSize = 11,
        TextColor3 = Color3.fromRGB(220, 220, 220), TextXAlignment = Enum.TextXAlignment.Center,
        Visible = true, ZIndex = 4,
    })
    local list = mk("ScrollingFrame", root, {
        Position = UDim2.fromOffset(12, 114), Size = UDim2.new(1, -24, 1, -142),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.line,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })
    mk("UIListLayout", list, { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })
    mk("UIPadding", list, {
        PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 0), PaddingRight = UDim.new(0, 0),
    })

    local priorityPage = _G.StickyPrioritySettingsPage
    local priorityOpen = false
    if priorityPage then
        priorityPage.Name = "PrioritySettingsPage"
        priorityPage.Parent = root
        priorityPage.Position = UDim2.fromOffset(12, 114)
        priorityPage.Size = UDim2.new(1, -24, 1, -142)
        priorityPage.BackgroundTransparency = 1
        priorityPage.ScrollBarThickness = 3
        priorityPage.ScrollBarImageColor3 = C.line
        priorityPage.ZIndex = 5
        priorityPage.Visible = false
    end
    local function showPrioritySettings(show)
        if not priorityPage then return end
        priorityOpen = (show == nil) and not priorityOpen or (show == true)
        priorityPage.Visible = priorityOpen
        list.Visible = not priorityOpen
        emptyState.Visible = (not priorityOpen) and emptyState.Visible
        priorityPageBtn.Text = priorityOpen and "BACK TO TARGETS" or "PRIORITY SETTINGS"
    end
    priorityPageBtn.MouseButton1Click:Connect(function() showPrioritySettings() end)
    _G.StickyShowPrioritySettings = showPrioritySettings
    if _G.__StickyOpenPriorityOnTargets then
        _G.__StickyOpenPriorityOnTargets = nil
        showPrioritySettings(true)
    end
    local oldMain = _G.StickyMainScreenGui
    if oldMain and oldMain ~= sg then pcall(function() oldMain:Destroy() end) end
    _G.StickyMainScreenGui = nil

    do
        local on, from, base, tracked
        head.InputBegan:Connect(function(i)
            if _G.StickyAllUiDragLocked == true then return end
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            on, from, base = true, i.Position, root.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    on = false
                    _G._Sticky_tgtX = root.Position.X.Offset
                    _G._Sticky_tgtY = root.Position.Y.Offset
                    if type(saveTpSettings) == "function" then pcall(saveTpSettings) end
                    if type(_G.StickySaveConfigNow) == "function" then pcall(_G.StickySaveConfigNow) end
                end
            end)
        end)
        head.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch then tracked = i end
        end)
        UIS.InputChanged:Connect(function(i)
            if _G.StickyAllUiDragLocked == true or not on or i ~= tracked then return end
            local d = i.Position - from
            root.Position = UDim2.fromOffset(base.X.Offset + d.X, base.Y.Offset + d.Y)
        end)
    end

    local function short(n)
        n = tonumber(n) or 0
        if n >= 1e9 then return string.format("%.1fB", n / 1e9) end
        if n >= 1e6 then return string.format("%.1fM", n / 1e6) end
        if n >= 1e3 then return string.format("%.1fK", n / 1e3) end
        return string.format("%d", n)
    end

    local _CTP_TOL_X, _CTP_TOL_Z = 62, 58
    local function _ctpFloorFromY(y)
        if y >= -6.9 and y <= 8.9 then return 1 end
        if y >= 11 and y <= 23.15 then return 2 end
        if y > 23.15 then return 3 end
        return nil
    end
    local function _ctpFloorFromSlot(slot, py)
        local s = tonumber(slot)
        if s then
            if s >= 19 then return 3 end
            if s >= 11 then return 2 end
            if s >= 1 then return 1 end
        end
        if py then return _ctpFloorFromY(py) end
        return nil
    end
    local function _ctpSameBase(petPos, myPos)
        local pIdx = getClosestBaseIdx(petPos)
        local mIdx = getClosestBaseIdx(myPos)
        if pIdx ~= mIdx then return false end
        local b = BASES_LOW[mIdx]
        if not b then return false end
        return math.abs(myPos.X - b.X) <= _CTP_TOL_X
           and math.abs(myPos.Z - b.Z) <= _CTP_TOL_Z
    end
    local function _ctpAllowed(pet)
        if not pet or not pet.position then return false end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        local myPos = hrp.Position
        if not _ctpSameBase(pet.position, myPos) then return false end
        local myFloor = _ctpFloorFromY(myPos.Y)
        if not myFloor then return false end
        local tgtFloor = _ctpFloorFromSlot(pet.slot, pet.position.Y)
        if not tgtFloor then return false end
        local diff = tgtFloor - myFloor
        local up = tonumber(_G.StickyClickTPMaxUp) or 3
        local down = tonumber(_G.StickyClickTPMaxDown) or 3
        return diff <= up and diff >= -down
    end

    local rows = {}
    local function rowFor(uid)
        local r = rows[uid]
        if r and r.card.Parent then return r end
        local card = round(mk("Frame", list, {
            Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = Color3.fromRGB(14, 14, 14),
            BorderSizePixel = 0, Active = true,
        }), 6)
        local accent = mk("Frame", card, {
            Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(3, 46),
            BackgroundColor3 = Color3.fromRGB(62, 62, 62), BorderSizePixel = 0, ZIndex = 2,
        })
        round(accent, 2)
        local bg = mk("Frame", card, {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.acc,
            BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        round(bg, 6)
        local rank = mk("TextLabel", card, {
            Position = UDim2.fromOffset(8, 0), Size = UDim2.fromOffset(26, 46),
            BackgroundTransparency = 1, Font = FB, TextSize = 12, TextColor3 = Color3.fromRGB(200, 200, 205),
            TextXAlignment = Enum.TextXAlignment.Center, Text = "", ZIndex = 2,
        })
        local nm = mk("TextLabel", card, {
            Position = UDim2.fromOffset(40, 6), Size = UDim2.new(1, -50, 0, 16),
            BackgroundTransparency = 1, Font = FB, TextSize = 13, TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Text = "", ZIndex = 2,
        })
        local icons = {}
        for k = 1, 4 do
            icons[k] = mk("ImageLabel", card, {
                Position = UDim2.fromOffset(36 + (k - 1) * 16, 22), Size = UDim2.fromOffset(12, 12),
                BackgroundTransparency = 1, Image = "", Visible = false, ZIndex = 2,
            })
        end
        local sub = mk("TextLabel", card, {
            RichText = true,
            Position = UDim2.fromOffset(40, 23), Size = UDim2.new(1, -50, 0, 12),
            BackgroundTransparency = 1, Font = FR, TextSize = 9, TextColor3 = C.dim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Text = "", ZIndex = 2,
        })
        local mps = mk("TextLabel", card, {
            AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 0),
            Size = UDim2.fromOffset(66, 40), BackgroundTransparency = 1,
            Font = FB, TextSize = 11, TextColor3 = C.acc,
            TextXAlignment = Enum.TextXAlignment.Right, Text = "", ZIndex = 2,
        })
        local hit = mk("TextButton", card, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "",
            AutoButtonColor = false, Active = true, ZIndex = 3,
        })
        r = { card = card, bg = bg, accent = accent, rank = rank, name = nm, sub = sub, mps = mps, icons = icons, hit = hit, lastLocked = false }
        rows[uid] = r
        return r
    end

    task.spawn(function()
        local _pd = tonumber(_G.StickyPanelStartDelay) or 0

        if not game:IsLoaded() then game.Loaded:Wait() end
        if _pd > 0 then task.wait(_pd) end
        local _filled = false
        local _panelT0 = os.clock()
        while sg.Parent do
            local _pw = os.clock()
            while _filled
                and (_G.StickyStealHold or (_G.StickyIsTeleporting and _G.StickyIsTeleporting()))
                and os.clock() - _pw < (tonumber(_G.StickyPanelPauseMax) or 3) do
                task.wait(0.2)
            end
            local bootActive = _gameLoadAt and (os.clock() - _gameLoadAt) < 4
            local pets = scanAllPetsCached(bootActive and 0.2 or 0.15)
        local ok = pets ~= nil
            if ok and type(pets) == "table" then
                local seen = {}
                for i, p in ipairs(pets) do
                    if not p.conveyor then
                        local uid = _petUid(p)
                        seen[uid] = true
                        local r = rowFor(uid)
                        r.pet = p
                        if r.lastOrder ~= i then
                            r.lastOrder = i
                            r.card.LayoutOrder = i
                            r.rank.Text = "#" .. tostring(i)
                        end
                        local nmTxt = tostring(p.name or "?")
                        if r.lastName ~= nmTxt then
                            r.lastName = nmTxt
                            r.name.Text = nmTxt
                            r.name.TextColor3 = C.txt
                        end
                        if r.mps then r.mps.Visible = false end
                        local mutName = "None"
                        if type(p.mutation) == "string" and p.mutation ~= "" and p.mutation ~= "None" then
                            mutName = p.mutation
                        end
                        local genStr = short(p.mps or p.gen or 0) .. "/s"
                        local mutKey = genStr .. "\0" .. mutName
                        if r.lastMut ~= mutKey then
                            r.lastMut = mutKey
                            for k = 1, #r.icons do r.icons[k].Visible = false end
                            r.sub.Position = UDim2.fromOffset(40, 23)
                            r.sub.Size = UDim2.new(1, -50, 0, 14)
                            r.sub.RichText = true
                            local mutCol = Color3.fromRGB(190, 190, 190)
                            local rc = math.floor(mutCol.R * 255)
                            local gc = math.floor(mutCol.G * 255)
                            local bc = math.floor(mutCol.B * 255)
                            r.sub.Text = string.format(
                                '<font color="rgb(180,180,185)">%s</font>  <font color="rgb(%d,%d,%d)">%s</font>',
                                genStr, rc, gc, bc, mutName
                            )
                        end
                        local locked = (_G.StickyStealTargetUID == uid)
                        if locked ~= r.lastLocked then
                            r.lastLocked = locked
                            tw(r.bg, { BackgroundTransparency = 1 })
                            tw(r.card, { BackgroundColor3 = locked and Color3.fromRGB(36, 36, 36) or Color3.fromRGB(14, 14, 14) })
                            if r.accent then tw(r.accent, { BackgroundColor3 = locked and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(62, 62, 62) }) end
                        end
                        if not r.wired then
                            r.wired = true
                            local myUid = uid
                            local _crow = r
                            r.hit.MouseButton1Click:Connect(function()
                                if _G.StickyStealTargetUID == myUid then
                                    _G.StickyStealTargetUID = nil
                                    _G.StickyStealTarget = nil
                                else
                                    _G.StickyStealTargetUID = myUid
                                    local pet = _crow.pet
                                    do
                                        local okS, fresh = pcall(scanAllPets)
                                        if okS and type(fresh) == "table" then
                                            for _, fp in ipairs(fresh) do
                                                if _petUid(fp) == myUid then pet = fp break end
                                            end
                                        end
                                    end
                                    if pet and pet.position and not isTeleporting
                                        and not _G.StickyClickTPBusy
                                        and _ctpAllowed(pet) then
                                        _G.StickyClickTPBusy = true
                                        isTeleporting = true
                                        if _G.StickyArmSteal then pcall(_G.StickyArmSteal, pet) end
                                        task.spawn(function()
                                            pcall(function()
                                                goToBrainrot(pet.position, pet.slot)
                                            end)
                                            isTeleporting = false
                                            _G.StickyClickTPBusy = false
                                        end)
                                    end
                                end
                            end)
                            r.hit.MouseEnter:Connect(function()
                                if _G.StickyStealTargetUID ~= myUid then
                                    tw(r.card, { BackgroundColor3 = Color3.fromRGB(28, 28, 28) })
                                end
                            end)
                            r.hit.MouseLeave:Connect(function()
                                if _G.StickyStealTargetUID ~= myUid then
                                    tw(r.card, { BackgroundColor3 = Color3.fromRGB(14, 14, 14) })
                                end
                            end)
                        end
                    end
                end
                local n = 0
                for uid, r in pairs(rows) do
                    if seen[uid] then n = n + 1
                    else r.card:Destroy() rows[uid] = nil end
                end
                count.Text = tostring(n)
                emptyState.Visible = n == 0
                root.Size = UDim2.fromOffset(260, 260)
                if n > 0 then _filled = true end
            else
                emptyState.Visible = true
            end
            if not _filled and (os.clock() - _panelT0) < (tonumber(_G.StickyPanelRush) or 10) then
                task.wait(bootActive and 0.15 or (tonumber(_G.StickyPanelRushGap) or 0.15))
            else
                task.wait(tonumber(_G.StickyPanelScanGap) or 0.6)
            end
        end
    end)

    _G.StickyTargetsUIOn = sg.Enabled == true
    _G.StickySetTargetsUI = function(value)
        sg.Enabled = value == true
        _G.StickyTargetsUIOn = sg.Enabled
    end
    _G.StickyToggleTargets = function() _G.StickySetTargetsUI(not sg.Enabled) end
    _G.StickyShowMainUi = function() _G.StickySetTargetsUI(true) end
    _G.StickyToggleMainUI = function() sg.Enabled = not sg.Enabled end
    _G.StickyOpenPriorityUi = function() showPrioritySettings(true); sg.Enabled = true end

task.spawn(function()
    local folder
    local function ensureFolder()
        if folder and folder.Parent then return folder end
        folder = workspace:FindFirstChild("_StickyWhiteBox")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "_StickyWhiteBox"
            folder.Parent = workspace
        end
        return folder
    end
    local boxes = {}
    while true do
        task.wait(0.35)
        if _G.StickyWhiteBox == false then
            for _, b in pairs(boxes) do pcall(function() b:Destroy() end) end
            boxes = {}
        else
            local f = ensureFolder()
            local pets = nil
            if type(scanAllPets) == "function" then
                local ok, res = pcall(scanAllPets)
                if ok then pets = res end
            elseif type(_G.StickyScanAllPets) == "function" then
                local ok, res = pcall(_G.StickyScanAllPets)
                if ok then pets = res end
            end
            local seen = {}
            if type(pets) == "table" then
                local n = 0
                for _, pet in ipairs(pets) do
                    local pos = pet.position or pet.pos
                    local uid = tostring(pet.uid or pet.name or n)
                    if pos then
                        n = n + 1
                        seen[uid] = true
                        local p = boxes[uid]
                        if not p or not p.Parent then
                            p = Instance.new("Part")
                            p.Name = "WB_" .. uid
                            p.Anchored = true
                            p.CanCollide = false
                            p.CanQuery = false
                            p.CanTouch = false
                            p.CastShadow = false
                            p.Material = Enum.Material.SmoothPlastic
                            p.Color = Color3.fromRGB(255, 255, 255)
                            local bx = tonumber(_G.StickyWhiteBoxSize) or 3.8
                            local by = tonumber(_G.StickyWhiteBoxHeight) or 3.6
                            p.Size = Vector3.new(bx, by, bx)
                            p.Transparency = tonumber(_G.StickyWhiteBoxTransp) or 0.35
                            p.Parent = f
                            boxes[uid] = p
                        end
                        do
                            local by = p.Size.Y
                            local front = 1.2
                            p.CFrame = CFrame.new(pos.X, pos.Y + (by * 0.35) + 0.8, pos.Z + front)
                        end
                    end
                end
            end
            for uid, p in pairs(boxes) do
                if not seen[uid] then
                    pcall(function() p:Destroy() end)
                    boxes[uid] = nil
                end
            end
        end
    end
end)

end)()

do
    local Players = game:GetService("Players")
    local espFolder, espItems = nil, {}
    local function clearPlayerESP()
        for _, item in pairs(espItems) do pcall(function() item:Destroy() end) end
        espItems = {}
        if espFolder then pcall(function() espFolder:Destroy() end); espFolder = nil end
    end
    local function refreshPlayerESP()
        if _G.StickyPlayerESP ~= true then clearPlayerESP(); return end
        if not espFolder or not espFolder.Parent then
            espFolder = Instance.new("Folder")
            espFolder.Name = "_StickyPlayerESP"
            espFolder.Parent = workspace
        end
        local seen = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                local character = player.Character
                seen[player] = true
                local h = espItems[player]
                if not h or not h.Parent then
                    h = Instance.new("Highlight")
                    h.Name = "PlayerESP_" .. player.UserId
                    h.Adornee = character
                    h.FillColor = Color3.fromRGB(255, 255, 255)
                    h.FillTransparency = 1
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.OutlineTransparency = 0
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent = espFolder
                    espItems[player] = h
                    local tag = Instance.new("BillboardGui")
                    tag.Name = "Name"
                    tag.AlwaysOnTop = true
                    tag.Size = UDim2.fromOffset(160, 24)
                    tag.StudsOffset = Vector3.new(0, 3.2, 0)
                    tag.Adornee = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                    tag.Parent = h
                    local text = Instance.new("TextLabel")
                    text.Size = UDim2.fromScale(1, 1)
                    text.BackgroundTransparency = 1
                    text.Text = player.DisplayName ~= "" and player.DisplayName or player.Name
                    text.Font = Enum.Font.GothamBold
                    text.TextSize = 12
                    text.TextColor3 = Color3.fromRGB(255, 255, 255)
                    text.TextStrokeTransparency = 0
                    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    text.Parent = tag
                else
                    h.Adornee = character
                    local tag = h:FindFirstChild("Name")
                    if tag then tag.Adornee = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart") end
                end
            end
        end
        for player, item in pairs(espItems) do
            if not seen[player] then pcall(function() item:Destroy() end); espItems[player] = nil end
        end
    end
    _G.StickyRefreshPlayerESP = refreshPlayerESP
    Players.PlayerRemoving:Connect(function(player)
        local item = espItems[player]
        if item then pcall(function() item:Destroy() end); espItems[player] = nil end
    end)
    task.spawn(function()
        while true do refreshPlayerESP(); task.wait(0.5) end
    end)
end
;(function()
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local LP = Players.LocalPlayer
    local uiHelpers = _G.StickyCompactUIHelpers or {}
    local label, toggle, slider, dropdown = uiHelpers.label, uiHelpers.toggle, uiHelpers.slider, uiHelpers.dropdown
    local saveTpSettings = uiHelpers.saveTpSettings or function()
        if type(_G.StickySaveSettings) == "function" then pcall(_G.StickySaveSettings) end
    end
    local host = (gethui and gethui()) or game:GetService("CoreGui")

    local function mk(className, parent, props)
        local object = Instance.new(className)
        for key, value in pairs(props or {}) do object[key] = value end
        object.Parent = parent
        return object
    end
    local function round(object, radius)
        mk("UICorner", object, { CornerRadius = UDim.new(0, radius or 7) })
        return object
    end
    local C = {
        bg = Color3.fromRGB(5, 5, 5), card = Color3.fromRGB(20, 20, 20),
        line = Color3.fromRGB(58, 58, 58), white = Color3.fromRGB(245, 245, 245),
        text = Color3.fromRGB(245, 245, 245), dim = Color3.fromRGB(155, 155, 155),
        off = Color3.fromRGB(48, 48, 48),
    }
    local FONT, BOLD = Enum.Font.Gotham, Enum.Font.GothamBold
    local oldGui = host and host:FindFirstChild("StickyMainUICompact")
    if oldGui then pcall(function() oldGui:Destroy() end) end
    local oldRoleGui = host and host:FindFirstChild("StickyRosterESPLabels")
    if oldRoleGui then pcall(function() oldRoleGui:Destroy() end) end
    local oldRoleFolder = Workspace:FindFirstChild("_StickyRosterESP")
    if oldRoleFolder then pcall(function() oldRoleFolder:Destroy() end) end
    local gui = mk("ScreenGui", host, {
        Name = "StickyMainUICompact", ResetOnSpawn = false, IgnoreGuiInset = true,
        DisplayOrder = 1000002, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })

    local banner = round(mk("Frame", gui, {
        Name = "FPSBanner", AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 10), Size = UDim2.fromOffset(236, 48),
        BackgroundColor3 = C.bg, BorderSizePixel = 0, ZIndex = 30,
    }), 7)
    local bannerStroke = Instance.new("UIStroke")
    bannerStroke.Color, bannerStroke.Transparency, bannerStroke.Thickness = C.line, 0.15, 1
    bannerStroke.Parent = banner
    local fpsLabel = mk("TextLabel", banner, {
        Position = UDim2.fromOffset(10, 0), Size = UDim2.fromOffset(65, 30),
        BackgroundTransparency = 1, Text = "FPS ...", Font = BOLD, TextSize = 11,
        TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 31,
    })
    local openButton = round(mk("TextButton", banner, {
        Position = UDim2.new(1, -96, 0, 4), Size = UDim2.fromOffset(88, 22),
        BackgroundColor3 = C.white, BorderSizePixel = 0, Text = "MAIN UI",
        Font = BOLD, TextSize = 10, TextColor3 = C.bg,
        AutoButtonColor = false, Active = true, ZIndex = 32,
    }), 5)
    mk("Frame", banner, {
        Name = "SignatureDivider", Position = UDim2.fromOffset(10, 30), Size = UDim2.new(1, -20, 0, 1),
        BackgroundColor3 = C.line, BackgroundTransparency = 0.4, BorderSizePixel = 0, ZIndex = 31,
    })
    local signatureLabel = mk("TextLabel", banner, {
        Name = "Signature", Position = UDim2.fromOffset(8, 31), Size = UDim2.new(1, -16, 0, 16),
        BackgroundTransparency = 1, Text = "leaked at discord.gg/Z7vPrxecnJ", Font = BOLD,
        TextScaled = true, TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 31,
    })
    mk("UITextSizeConstraint", signatureLabel, { MaxTextSize = 12, MinTextSize = 7 })

    local root = round(mk("Frame", gui, {
        Name = "MainRoot", Visible = false, Active = true,
        Position = UDim2.new(0.5, -180, 0, 66), Size = UDim2.fromOffset(360, 286),
        BackgroundColor3 = C.bg, BorderSizePixel = 0, ZIndex = 20,
    }), 8)
    local rootStroke = Instance.new("UIStroke")
    rootStroke.Color, rootStroke.Transparency, rootStroke.Thickness = C.line, 0.15, 1
    rootStroke.Parent = root
    local mainSig = mk("TextLabel", root, {
        Name = "StickySignature", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -2),
        Size = UDim2.new(1, -16, 0, 16), BackgroundTransparency = 1, Text = "leaked at discord.gg/Z7vPrxecnJ",
        Font = Enum.Font.GothamBold, TextScaled = true, TextColor3 = Color3.fromRGB(165, 165, 165), ZIndex = 30,
    })
    mk("UITextSizeConstraint", mainSig, { MaxTextSize = 12, MinTextSize = 7 })
    pcall(_G.StickyRememberPanel, root, "MainUI")
    local header = mk("Frame", root, {
        Name = "Header", Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Color3.fromRGB(11, 11, 11), BorderSizePixel = 0, ZIndex = 21,
    })
    round(header, 8)
    mk("TextLabel", header, {
        Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -48, 1, 0),
        BackgroundTransparency = 1, Text = "MAIN UI", Font = BOLD, TextSize = 13,
        TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22,
    })
    local close = round(mk("TextButton", header, {
        Position = UDim2.new(1, -30, 0, 6), Size = UDim2.fromOffset(22, 22),
        BackgroundColor3 = C.off, BorderSizePixel = 0, Text = "×", Font = BOLD,
        TextSize = 15, TextColor3 = C.text, AutoButtonColor = false, Active = true, ZIndex = 23,
    }), 5)
    if _G.StickyAllUiDragLocked == nil then _G.StickyAllUiDragLocked = false end
    local uiDragLockButton = round(mk("TextButton", header, {
        Position = UDim2.new(1, -58, 0, 6), Size = UDim2.fromOffset(22, 22),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
        Text = _G.StickyAllUiDragLocked and "🔒" or "🔓", Font = BOLD, TextSize = 13,
        TextColor3 = C.text, AutoButtonColor = false, Active = true, ZIndex = 23,
    }), 5)
    uiDragLockButton.MouseButton1Click:Connect(function()
        _G.StickyAllUiDragLocked = not (_G.StickyAllUiDragLocked == true)
        uiDragLockButton.Text = _G.StickyAllUiDragLocked and "🔒" or "🔓"
    end)
    close.MouseButton1Click:Connect(function() root.Visible = false end)

    local nav = mk("Frame", root, {
        Position = UDim2.fromOffset(8, 40), Size = UDim2.new(1, -16, 0, 28),
        BackgroundTransparency = 1, ZIndex = 21,
    })
    local content = mk("Frame", root, {
        Position = UDim2.fromOffset(8, 74), Size = UDim2.new(1, -16, 1, -102),
        BackgroundTransparency = 1, ZIndex = 21,
    })
    local pages, categoryButtons = {}, {}
    local activeCategory = "ESP"
    local function selectCategory(name)
        activeCategory = name
        for key, page in pairs(pages) do page.Visible = key == name end
        for key, button in pairs(categoryButtons) do
            local active = key == name
            button.BackgroundColor3 = active and C.white or C.card
            button.TextColor3 = active and C.bg or C.text
        end
    end
    local sectionNames = {"ESP", "MISC", "MAIN", "ADMIN PANEL", "TELEPORT"}
    for index, name in ipairs(sectionNames) do
        local button = round(mk("TextButton", nav, {
            Position = UDim2.new((index - 1) / #sectionNames, 0, 0, 0),
            Size = UDim2.new(1 / #sectionNames, -4, 1, 0), BackgroundColor3 = C.card,
            BorderSizePixel = 0, Text = name, Font = BOLD, TextSize = name == "ADMIN PANEL" and 8 or 9,
            TextColor3 = C.text, AutoButtonColor = false, Active = true, ZIndex = 22,
        }), 5)
        categoryButtons[name] = button
        button.MouseButton1Click:Connect(function() selectCategory(name) end)
        local page = mk("Frame", content, {
            Name = name .. "Page", Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1, Visible = false, ZIndex = 21,
        })
        pages[name] = page
    end
    selectCategory("ESP")

    local saveSettings = function()
        if type(_G.StickySaveSettings) == "function" then pcall(_G.StickySaveSettings) end
    end
    local function makeToggle(parent, y, title, getValue, setValue, x, width)
        local row = round(mk("Frame", parent, {
            Position = UDim2.fromOffset(x or 0, y),
            Size = width and UDim2.fromOffset(width, 30) or UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = C.card, BorderSizePixel = 0, ZIndex = 22,
        }), 5)
        mk("TextLabel", row, {
            Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -62, 1, 0),
            BackgroundTransparency = 1, Text = title, Font = BOLD, TextSize = 10,
            TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 23,
        })
        local button = round(mk("TextButton", row, {
            Position = UDim2.new(1, -48, 0.5, -9), Size = UDim2.fromOffset(38, 18),
            BackgroundColor3 = C.off, BorderSizePixel = 0, Text = "OFF",
            Font = BOLD, TextSize = 8, TextColor3 = C.dim,
            AutoButtonColor = false, Active = true, ZIndex = 24,
        }), 5)
        local function paint()
            local on = getValue() == true
            button.Text = on and "ON" or "OFF"
            button.BackgroundColor3 = on and C.white or C.off
            button.TextColor3 = on and C.bg or C.dim
        end
        button.MouseButton1Click:Connect(function()
            setValue(not (getValue() == true))
            paint()
            saveSettings()
        end)
        paint()
        return paint
    end

    local tpSettingsScroll = mk("ScrollingFrame", pages.TELEPORT, {
        Name = "TeleportSettings", Position = UDim2.fromOffset(3, 0), Size = UDim2.new(1, -9, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.line, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Active = true, ZIndex = 22,
    })
    mk("UIPadding", tpSettingsScroll, { PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 5), PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 8) })
    mk("UIListLayout", tpSettingsScroll, { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })
    local function mainTpSlider(name, min, max, key, step)
        slider(tpSettingsScroll, name, min, max, function() return _G[key] end, function(v)
            _G[key] = v
            if key == "StickyInvisAngle" then _G.InvisStealAngle = v end
            if key == "StickyInvisDepth" then _G.SinkSliderValue = v end
            saveTpSettings()
        end, step)
    end
    label(tpSettingsScroll, "TP METHODS", true)
    local methodOrder = {"HYBRID", "FLING TP", "MANUAL TP"}
    local methodPaints = {}
    local initialTPMethod = _G.StickyTPMethod
    if not StickyTPMethodNames[initialTPMethod] then
        if _G.StickyHybridTP == true then initialTPMethod = "HYBRID"
        elseif _G.Sticky_FlingTp ~= false then initialTPMethod = "FLING TP"
        else initialTPMethod = "MANUAL TP" end
    end
    _G.StickySetTPMethod(initialTPMethod)
    local function repaintTPMethods()
        for _, paint in pairs(methodPaints) do pcall(paint, true) end
    end
    for _, methodName in ipairs(methodOrder) do
        local method = methodName
        local display = method == "HYBRID" and "HYBRID TP" or method
        methodPaints[method] = toggle(tpSettingsScroll, display, function()
            return _G.StickyTPMethod == method
        end, function()
            if _G.StickyTPMethod ~= method then
                _G.StickySetTPMethod(method)
                repaintTPMethods()
                saveTpSettings()
            end
        end)
    end
    _G.StickyRepaintTPModeButtons = repaintTPMethods
    label(tpSettingsScroll, "teleport settings")
    _G.StickyRepaintAutoTP = toggle(tpSettingsScroll, "AUTO TP", function() return _G.StickyAutoTP ~= false end, function() _G.StickyAutoTP = not (_G.StickyAutoTP ~= false); saveTpSettings() end)
    if _G.Sticky_FlingTp == nil then _G.Sticky_FlingTp = true end
    if _G.Sticky_FlingAmp == nil then _G.Sticky_FlingAmp = 1 end
    dropdown(tpSettingsScroll, "TOOL USED FOR FLYING", FLY_TOOLS, function() return _G.StickyCarpetTool end, function(n) setCarpetTool(n); saveTpSettings() end)
    label(tpSettingsScroll, "movement")
    toggle(tpSettingsScroll, "TP TRAIL", function() return _G.StickyTPTrail == true end, function()
        _G.StickyTPTrail = not (_G.StickyTPTrail == true)
        if not _G.StickyTPTrail and type(clearViz) == "function" then pcall(clearViz) end
        saveTpSettings()
    end)
    local repaintHybrid = repaintTPMethods
    mainTpSlider("TP Velocity", 200, 750, "TPVelocity", 5)
    mainTpSlider("Rise Speed", 100, 250, "StickyClimb", 5)
    mainTpSlider("Go To Brainrot Speed", 80, 600, "StickyGoSpeed", 5)
    mainTpSlider("Landing Delay", 0.01, 1.0, "LandingDelay", 0.01)
    mainTpSlider("Close Speed", 20, 400, "StickyCloseSpeed", 5)
    mainTpSlider("Front Speed", 20, 400, "StickyProblemBaseSpeed", 5)
    label(tpSettingsScroll, "front approach")
    toggle(tpSettingsScroll, "FRONT SPEED", function() return _G.StickySlowCrossRow == true end, function() _G.StickySlowCrossRow = not (_G.StickySlowCrossRow == true); saveTpSettings() end)
    if _G.StickyAutoRecoverHit == nil then _G.StickyAutoRecoverHit = true end
    toggle(tpSettingsScroll, "AUTO RECOVER HIT (NOT INVIS)", function() return _G.StickyAutoRecoverHit == true end, function()
        _G.StickyAutoRecoverHit = not (_G.StickyAutoRecoverHit == true)
        saveTpSettings()
    end)
    _G.StickyRepaintTPModeButtons = repaintHybrid

    local function getCamera()
        return Workspace.CurrentCamera
    end
    local cameraOriginal = setmetatable({}, {__mode = "k"})
    local function applyFov()
        local cam = getCamera()
        if _G.StickyFovEnabled == true then
            if cam then
                if cameraOriginal[cam] == nil then cameraOriginal[cam] = cam.FieldOfView end
                pcall(function() cam.FieldOfView = math.clamp(tonumber(_G.StickyFovValue) or 70, 1, 120) end)
            end
        else
            for savedCamera, original in pairs(cameraOriginal) do
                pcall(function() if savedCamera and savedCamera.Parent then savedCamera.FieldOfView = original end end)
                cameraOriginal[savedCamera] = nil
            end
        end
    end
    makeToggle(pages.ESP, 0, "FOV", function() return _G.StickyFovEnabled end, function(value)
        _G.StickyFovEnabled = value
        applyFov()
    end)
    local fovRow = round(mk("Frame", pages.ESP, {
        Position = UDim2.fromOffset(0, 35), Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = C.card, BorderSizePixel = 0, ZIndex = 22,
    }), 5)
    local fovText = mk("TextLabel", fovRow, {
        Position = UDim2.fromOffset(10, 2), Size = UDim2.new(1, -20, 0, 15),
        BackgroundTransparency = 1, Text = "FOV VALUE: 70", Font = BOLD,
        TextSize = 9, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 23,
    })
    local fovTrack = round(mk("TextButton", fovRow, {
        Position = UDim2.fromOffset(10, 25), Size = UDim2.new(1, -20, 0, 7),
        BackgroundColor3 = C.off, BorderSizePixel = 0, Text = "",
        AutoButtonColor = false, Active = true, ZIndex = 23,
    }), 4)
    local fovFill = round(mk("Frame", fovTrack, {
        Size = UDim2.new(70 / 120, 0, 1, 0), BackgroundColor3 = C.white,
        BorderSizePixel = 0, ZIndex = 24,
    }), 4)
    local fovKnob = round(mk("Frame", fovTrack, {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(70 / 120, 0, 0.5, 0),
        Size = UDim2.fromOffset(12, 12), BackgroundColor3 = C.white,
        BorderSizePixel = 0, ZIndex = 25,
    }), 6)
    local slidingFov = false
    local function paintFov()
        local value = math.clamp(math.floor((tonumber(_G.StickyFovValue) or 70) + 0.5), 0, 120)
        local fraction = value / 120
        fovText.Text = "FOV VALUE: " .. tostring(value)
        fovFill.Size = UDim2.new(fraction, 0, 1, 0)
        fovKnob.Position = UDim2.new(fraction, 0, 0.5, 0)
        if _G.StickyFovEnabled == true then applyFov() end
    end
    local function setFovFromX(x)
        local width = math.max(fovTrack.AbsoluteSize.X, 1)
        local fraction = math.clamp((x - fovTrack.AbsolutePosition.X) / width, 0, 1)
        _G.StickyFovValue = math.clamp(math.floor(fraction * 120 + 0.5), 0, 120)
        paintFov()
        saveSettings()
    end
    fovTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            slidingFov = true
            setFovFromX(input.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if slidingFov and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFovFromX(input.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            slidingFov = false
        end
    end)
    paintFov()
    Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        if _G.StickyFovEnabled == true then task.defer(applyFov) end
    end)

    if _G.Sticky_FlingTp == nil then _G.Sticky_FlingTp = true end
    if _G.Sticky_FlingAmp == nil then _G.Sticky_FlingAmp = 1 end
    if _G.StickyAutoDestroyTurret == nil then _G.StickyAutoDestroyTurret = false end
    if _G.StickyConveyorESP == nil then _G.StickyConveyorESP = false end
    if _G.StickyTrapESP == nil then _G.StickyTrapESP = false end
    if _G.StickyLineToBase == nil then _G.StickyLineToBase = false end
    if type(_G.StickyAdminBlacklist) ~= "table" then _G.StickyAdminBlacklist = {} end
    if _G.StickyAdminPanelUiOn == nil then _G.StickyAdminPanelUiOn = false end

    local plotBeam, playerAttach, plotAttach
    local function resetPlotBeam()
        pcall(function() if plotBeam then plotBeam:Destroy() end end)
        pcall(function() if playerAttach then playerAttach:Destroy() end end)
        pcall(function() if plotAttach then plotAttach:Destroy() end end)
        plotBeam, playerAttach, plotAttach = nil, nil, nil
    end
    local function findMyPlot()
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                for _, label in ipairs(sign:GetDescendants()) do
                    if label:IsA("TextLabel") then
                        local text = tostring(label.Text or ""):lower()
                        if text:find(tostring(LP.DisplayName or LP.Name):lower(), 1, true)
                            or text:find(tostring(LP.Name):lower(), 1, true) then return plot end
                    end
                end
            end
        end
        return nil
    end
    local function updatePlotBeam()
        if _G.StickyLineToBase ~= true then resetPlotBeam(); return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local plot = findMyPlot()
        local plotPart = plot and (plot:FindFirstChild("MainRootPart") or plot:FindFirstChildWhichIsA("BasePart", true))
        if plotPart and not plotPart:IsA("BasePart") then plotPart = plot:FindFirstChildWhichIsA("BasePart", true) end
        if not hrp or not plotPart then return end
        if plotBeam and (not plotBeam.Parent or playerAttach.Parent ~= hrp or plotAttach.Parent ~= plotPart) then resetPlotBeam() end
        if not playerAttach then
            playerAttach = Instance.new("Attachment")
            playerAttach.Name = "StickyLineToBase_Player"
            playerAttach.Parent = hrp
        end
        if not plotAttach then
            plotAttach = Instance.new("Attachment")
            plotAttach.Name = "StickyLineToBase_Base"
            plotAttach.Position = Vector3.new(0, 5, 0)
            plotAttach.Parent = plotPart
        end
        if not plotBeam then
            plotBeam = Instance.new("Beam")
            plotBeam.Name = "StickyLineToBase"
            plotBeam.Attachment0, plotBeam.Attachment1 = playerAttach, plotAttach
            plotBeam.FaceCamera = true
            plotBeam.LightEmission = 1
            plotBeam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
            plotBeam.Transparency = NumberSequence.new(0)
            plotBeam.Width0, plotBeam.Width1 = 0.55, 0.55
            plotBeam.Parent = hrp
        end
    end
    _G.createPlotBeam = updatePlotBeam
    _G.resetPlotBeam = resetPlotBeam
    LP.CharacterAdded:Connect(function() task.wait(0.4); pcall(updatePlotBeam) end)

    local extraEspFolder = Workspace:FindFirstChild("_StickyExtraWorldESP")
    if extraEspFolder then pcall(function() extraEspFolder:Destroy() end) end
    extraEspFolder = Instance.new("Folder")
    extraEspFolder.Name = "_StickyExtraWorldESP"
    extraEspFolder.Parent = Workspace
    local worldMarkers = {}
    local function partFor(inst)
        if not inst or not inst.Parent then return nil end
        if inst:IsA("BasePart") then return inst end
        if inst:IsA("Model") then return inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart", true) end
        return nil
    end
    local function isPlayerObject(inst)
        local par = inst
        while par and par ~= Workspace do
            if Players:GetPlayerFromCharacter(par) then return true end
            if par:IsA("Model") and par:FindFirstChildOfClass("Humanoid") then return true end
            par = par.Parent
        end
        return false
    end
    local function hazardKind(inst)
        local n = tostring(inst.Name or ""):lower()
        if n:find("sentrybullet", 1, true) then return nil end
        if n:find("tripmine", 1, true) or n:find("subspacemine", 1, true) or n:find("mine", 1, true) then return "MINE" end
        if n:find("trap", 1, true) or n:find("hive", 1, true) then return "TRAP" end
        return nil
    end
    local function inConveyorContainer(inst)
        if inst:GetAttribute("Conveyor") == true or inst:GetAttribute("IsConveyor") == true then return true end
        local par = inst.Parent
        while par and par ~= Workspace do
            local n = tostring(par.Name or ""):lower()
            if n:find("conveyor", 1, true) or n:find("walkinganimals", 1, true) or n == "walking" then return true end
            par = par.Parent
        end
        return tostring(inst.Name or ""):lower():find("conveyor", 1, true) ~= nil
    end
    local function makeWorldMarker(inst, labelText, color)
        local part = partFor(inst)
        if not part then return nil end
        local h = Instance.new("Highlight")
        h.Name = "StickyExtraWorldHighlight"
        h.Adornee = inst:IsA("Model") and inst or part
        h.FillTransparency = 1
        h.OutlineTransparency = 0
        h.OutlineColor = color
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = extraEspFolder
        local bb = Instance.new("BillboardGui")
        bb.Name = "StickyExtraWorldTag"
        bb.Adornee = part
        bb.Size = UDim2.fromOffset(170, 26)
        bb.StudsOffset = Vector3.new(0, 3.3, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 5000
        bb.Parent = gui
        local text = Instance.new("TextLabel")
        text.Size = UDim2.fromScale(1, 1)
        text.BackgroundTransparency = 1
        text.Text = labelText
        text.Font = BOLD
        text.TextSize = 11
        text.TextColor3 = color
        text.TextStrokeColor3 = Color3.new(0, 0, 0)
        text.TextStrokeTransparency = 0
        text.Parent = bb
        return { highlight = h, tag = bb, text = labelText }
    end
    local function destroyWorldMarker(inst)
        local item = worldMarkers[inst]
        if item then
            pcall(function() item.highlight:Destroy() end)
            pcall(function() item.tag:Destroy() end)
            worldMarkers[inst] = nil
        end
    end
    local function refreshExtraWorldESP()
        local wanted = {}
        local descendants = Workspace:GetDescendants()
        if _G.StickyTrapESP == true then
            for i, inst in ipairs(descendants) do
                if i % 600 == 0 then task.wait() end
                if (inst:IsA("Model") or inst:IsA("BasePart")) and not isPlayerObject(inst) then
                    local kind = hazardKind(inst)
                    local par, nested = inst.Parent, false
                    while par and par ~= Workspace do
                        if hazardKind(par) then nested = true; break end
                        par = par.Parent
                    end
                    if kind and not nested then
                        wanted[inst] = { text = "⚠ " .. kind .. " ESP", color = kind == "MINE" and Color3.fromRGB(200, 190, 255) or Color3.fromRGB(255, 255, 255) }
                    end
                end
            end
        end
        if _G.StickyConveyorESP == true then
            local shared = _G.SharedState
            local walking = type(shared) == "table" and shared.WalkingCache or nil
            local best, bestScore
            if type(walking) == "table" then
                for _, entry in ipairs(walking) do
                    local model = type(entry) == "table" and entry.model or nil
                    local score = type(entry) == "table" and (tonumber(entry.genValue) or 0) or 0
                    if model and model.Parent and (not bestScore or score > bestScore) then best, bestScore = model, score end
                end
            end
            if best then
                wanted[best] = { text = "CONVEYOR  " .. tostring(best.Name), color = Color3.fromRGB(255, 255, 255) }
            else
                local count = 0
                for i, inst in ipairs(descendants) do
                    if i % 700 == 0 then task.wait() end
                    if (inst:IsA("Model") or inst:IsA("BasePart")) and not isPlayerObject(inst) and inConveyorContainer(inst) then
                        local name = tostring(inst.Name or "")
                        if not name:lower():find("conveyor", 1, true) or inst:GetAttribute("Conveyor") == true or inst:GetAttribute("IsConveyor") == true then
                            wanted[inst] = { text = "CONVEYOR  " .. name, color = Color3.fromRGB(255, 255, 255) }
                            count = count + 1
                            if count >= 16 then break end
                        end
                    end
                end
            end
        end
        for inst in pairs(worldMarkers) do if not wanted[inst] or not inst.Parent then destroyWorldMarker(inst) end end
        for inst, spec in pairs(wanted) do
            local current = worldMarkers[inst]
            if not current or not current.tag.Parent or current.text ~= spec.text then
                destroyWorldMarker(inst)
                worldMarkers[inst] = makeWorldMarker(inst, spec.text, spec.color)
            end
        end
    end
    task.spawn(function()
        while gui and gui.Parent do
            if _G.StickyLineToBase == true then pcall(updatePlotBeam) else resetPlotBeam() end
            if _G.StickyConveyorESP == true or _G.StickyTrapESP == true then
                pcall(refreshExtraWorldESP)
            else
                for inst in pairs(worldMarkers) do destroyWorldMarker(inst) end
            end
            task.wait(1.5)
        end
    end)

    local autoTurretOn = _G.StickyAutoDestroyTurret == true
    local turretSeen = setmetatable({}, { __mode = "k" })
    local turretCooldown = setmetatable({}, { __mode = "k" })
    local function turretIsPlayer(inst)
        local par = inst
        while par and par ~= Workspace do
            if (par:IsA("Model") and Players:GetPlayerFromCharacter(par))
                or (par:IsA("Model") and par:FindFirstChildOfClass("Humanoid")) then return true end
            par = par.Parent
        end
        return false
    end
    local turretPins = setmetatable({}, { __mode = "k" })
    local turretArmed = setmetatable({}, { __mode = "k" })
    local function turretTargetable(inst, now)
        if _G.Sticky_TurretWaitReady == false then return true end
        if turretArmed[inst] then return true end
        if not turretSeen[inst] then turretSeen[inst] = now end
        if now - turretSeen[inst] >= (tonumber(_G.Sticky_TurretDeploySpan) or 12) then
            turretArmed[inst] = true
            return true
        end
        local pinned, labels = false, {}
        local strict = _G.Sticky_TurretDeployStrict ~= false
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("TextLabel") and d.Text ~= "" then
                local text = tostring(d.Text)
                local lower = text:lower()
                local event = false
                if lower:find("ready", 1, true) then
                    event, pinned = true, true
                elseif not strict and (text:find("!", 1, true) or text:match("^%s*%d+%.?%d*%s*[sS]?%s*$")) then
                    event, pinned = true, true
                else
                    local number = text:match("^%s*(%d+%.?%d*)%s*[sS]?%s*!*%s*$")
                    if number and (tonumber(number) or 99) <= 10 then event, pinned = true, true end
                end
                if event then labels[#labels + 1] = text end
            end
        end
        if not pinned then turretPins[inst] = nil; turretArmed[inst] = true; return true end
        table.sort(labels)
        local key = table.concat(labels, "\1")
        local pin = turretPins[inst]
        if not pin or pin.key ~= key then
            turretPins[inst] = { key = key, at = now }
            return false
        end
        if _G.Sticky_TurretStaticRelease ~= false
            and now - pin.at >= (tonumber(_G.Sticky_TurretStaticPin) or 1.2) then
            turretArmed[inst] = true
            return true
        end
        return false
    end
    local turretLastDeep = 0
    local function nearestSentry(includeCooldown)
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local now, best, bestDist = os.clock(), nil, math.huge
        local function scan(list)
            for _, inst in ipairs(list) do
                if inst.Name:find("Sentry", 1, true) and inst.Name ~= "SentryBullet"
                    and (inst:IsA("Model") or inst:IsA("BasePart")) and not turretIsPlayer(inst)
                    and (includeCooldown or not (turretCooldown[inst] and now < turretCooldown[inst]))
                    and turretTargetable(inst, now) then
                    local part = partFor(inst)
                    if part then
                        if not turretSeen[inst] then turretSeen[inst] = now end
                        local dist = (hrp.Position - part.Position).Magnitude
                        if dist < bestDist and dist <= (tonumber(_G.StickyTurretHitRange) or 45) then best, bestDist = inst, dist end
                    end
                end
            end
        end
        scan(Workspace:GetChildren())
        if not best and now - turretLastDeep >= (tonumber(_G.Sticky_TurretDeepEvery) or 3) then
            turretLastDeep = now
            scan(Workspace:GetDescendants())
        end
        return best
    end
    local function turretWeapon()
        local char = LP.Character
        local backpack = LP:FindFirstChildOfClass("Backpack")
        return (backpack and backpack:FindFirstChild("Bat")) or (char and char:FindFirstChild("Bat"))
            or (backpack and backpack:FindFirstChild("Gummy Bear")) or (char and char:FindFirstChild("Gummy Bear"))
    end
    local turretCycleActive = false
    local function destroyTurretCycle(target)
        if turretCycleActive or not target or not target.Parent then return false end
        turretCycleActive = true
        local invisibleSurface = _G.invisibleStealEnabled == true
        if invisibleSurface then _G.Sticky_InvisSurface = true end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local tool = turretWeapon()
        if not (hrp and hum and tool) then
            if invisibleSurface then _G.Sticky_InvisSurface = false end
            turretCycleActive = false
            return false
        end
        local start = os.clock()
        while autoTurretOn and target.Parent and os.clock() - start < (tonumber(_G.Sticky_TurretCycleCap) or tonumber(_G.StickyTurretCycleCap) or 6) do
            if _G.StickyTPBusy == true or _G.Sticky_TpActive == true or LP:GetAttribute("Stealing") == true then break end
            if _G.Sticky_TurretYieldToSpeed ~= false and _G.Sticky_CarpetSpeedActive == true then break end
            if _G.Sticky_TurretYieldToBuyKick ~= false and type(_G.Sticky_AutoBuyActive) == "function" then
                local okBuy, buying = pcall(_G.Sticky_AutoBuyActive)
                if okBuy and buying then break end
            end
            local currentChar = LP.Character
            local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
            local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
            if not currentRoot or not currentHum then break end
            tool = turretWeapon()
            if not tool then break end
            pcall(function()
                for _, d in ipairs(target:GetDescendants()) do
                    if d:IsA("BasePart") then d.Transparency = math.max(d.Transparency, 0.5); d.CanCollide = false; d.CanTouch = false; d.CanQuery = false end
                end
                if target:IsA("Model") then target:PivotTo(CFrame.new(currentRoot.Position + currentRoot.CFrame.LookVector * 4, currentRoot.Position))
                elseif target:IsA("BasePart") then target.CFrame = CFrame.new(currentRoot.Position + currentRoot.CFrame.LookVector * 4, currentRoot.Position) end
                if tool.Parent ~= currentChar then currentHum:EquipTool(tool) end
                tool:Activate()
            end)
            task.wait(0.1)
        end
        if target.Parent then turretCooldown[target] = os.clock() + (tonumber(_G.Sticky_TurretCooldown) or 2.5) end
        if invisibleSurface then _G.Sticky_InvisSurface = false end
        turretCycleActive = false
        return not target.Parent
    end
    local function setAutoTurret(value)
        if value == nil then value = not autoTurretOn end
        autoTurretOn = value == true
        _G.StickyAutoDestroyTurret = autoTurretOn
        return autoTurretOn
    end
    _G.Sticky_AutoTurretActive = function() return autoTurretOn == true end
    _G.Sticky_ToggleAutoTurret = function(value) return setAutoTurret(value) end
    _G.Sticky_DestroyTurretIfThreat = function()
        if not autoTurretOn or _G.StickyTPBusy == true or LP:GetAttribute("Stealing") == true then return false end
        if _G.Sticky_TurretYieldToBuyKick ~= false and type(_G.Sticky_AutoBuyActive) == "function" then
            local okBuy, buying = pcall(_G.Sticky_AutoBuyActive)
            if okBuy and buying then return false end
        end
        local target = nearestSentry(true)
        if not target or not turretWeapon() then return false end
        return destroyTurretCycle(target)
    end
    task.spawn(function()
        local bootAt = os.clock()
        while gui and gui.Parent do
            if autoTurretOn and os.clock() - bootAt >= (tonumber(_G.Sticky_TurretJoinGrace) or 8)
                and _G.StickyTPBusy ~= true and _G.Sticky_TpActive ~= true
                and not (_G.Sticky_TurretYieldToSpeed ~= false and _G.Sticky_CarpetSpeedActive == true)
                and LP:GetAttribute("Stealing") ~= true then
                local target = nearestSentry(false)
                if target and turretWeapon() then pcall(destroyTurretCycle, target) end
            end
            task.wait(0.2)
        end
    end)

    local function cleanUsername(value)
        local name = tostring(value or ""):match("^%s*(.-)%s*$") or ""
        if #name < 3 or #name > 20 or not name:match("^[%w_]+$") then return nil end
        return name
    end
    local function isAdminBlacklisted(username)
        local key = tostring(username or ""):lower()
        for _, value in ipairs(_G.StickyAdminBlacklist) do
            if tostring(value):lower() == key then return true end
        end
        return false
    end
    local function fireUiButton(button)
        if not button then return false end
        if type(firesignal) == "function" then
            local ok = pcall(function() firesignal(button.MouseButton1Click) end)
            if ok then return true end
        end
        local ok = pcall(function()
            local vim = game:GetService("VirtualInputManager")
            local x = button.AbsolutePosition.X + button.AbsoluteSize.X / 2
            local y = button.AbsolutePosition.Y + button.AbsoluteSize.Y / 2
            vim:SendMouseButtonEvent(x, y, 0, true, game, 0)
            vim:SendMouseButtonEvent(x, y, 0, false, game, 0)
        end)
        return ok
    end
    local function runAdminCommand(targetPlayer, commandName)
        if not targetPlayer or not targetPlayer.Parent or targetPlayer == LP or isAdminBlacklisted(targetPlayer.Name) then return false end
        local playerGui = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
        local realAdminGui = playerGui and playerGui:FindFirstChild("AdminPanel")
        local panel = realAdminGui and realAdminGui:FindFirstChild("AdminPanel")
        local profiles = panel and panel:FindFirstChild("Profiles")
        local profilesScroll = profiles and profiles:FindFirstChild("ScrollingFrame")
        local playerButton = profilesScroll and profilesScroll:FindFirstChild(targetPlayer.Name, true)
        if not playerButton then return false end
        if not fireUiButton(playerButton) then return false end
        task.wait(0.05)
        local content = panel and panel:FindFirstChild("Content")
        local contentScroll = content and content:FindFirstChild("ScrollingFrame")
        local commandButton = contentScroll and contentScroll:FindFirstChild(commandName, true)
        if not commandButton then return false end
        return fireUiButton(commandButton)
    end
    _G.StickyRunAdminPanelCommand = runAdminCommand
    local adminRoot = round(mk("Frame", gui, {
        Name = "AdminPanelUI", Visible = false, Active = true,
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(360, 380), BackgroundColor3 = C.bg, BorderSizePixel = 0, ZIndex = 40,
    }), 8)
    local adminStroke = Instance.new("UIStroke")
    adminStroke.Color, adminStroke.Transparency, adminStroke.Thickness = C.line, 0.1, 1
    adminStroke.Parent = adminRoot
    local adminSig = mk("TextLabel", adminRoot, {
        Name = "StickySignature", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -2),
        Size = UDim2.new(1, -16, 0, 16), BackgroundTransparency = 1, Text = "leaked at discord.gg/Z7vPrxecnJ",
        Font = Enum.Font.GothamBold, TextScaled = true, TextColor3 = Color3.fromRGB(165, 165, 165), ZIndex = 50,
    })
    mk("UITextSizeConstraint", adminSig, { MaxTextSize = 12, MinTextSize = 7 })
    pcall(_G.StickyRememberPanel, adminRoot, "AdminPanelUI")
    local adminHeader = round(mk("Frame", adminRoot, {
        Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(11, 11, 11),
        BorderSizePixel = 0, ZIndex = 41,
    }), 8)
    mk("TextLabel", adminHeader, {
        Position = UDim2.fromOffset(9, 0), Size = UDim2.new(1, -185, 1, 0),
        BackgroundTransparency = 1, Text = "ADMIN PANEL UI", Font = BOLD, TextSize = 10,
        TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 42,
    })
    local apSettingsButton = round(mk("TextButton", adminHeader, {
        Position = UDim2.new(1, -170, 0, 4), Size = UDim2.fromOffset(76, 22),
        BackgroundColor3 = C.white, BorderSizePixel = 0, Text = "AP SETTINGS",
        Font = BOLD, TextSize = 8, TextColor3 = C.bg, AutoButtonColor = false, Active = true, ZIndex = 43,
    }), 5)
    local refreshAdminButton = round(mk("TextButton", adminHeader, {
        Position = UDim2.new(1, -88, 0, 4), Size = UDim2.fromOffset(56, 22),
        BackgroundColor3 = C.card, BorderSizePixel = 0, Text = "REFRESH",
        Font = BOLD, TextSize = 7, TextColor3 = C.text, AutoButtonColor = false, Active = true, ZIndex = 43,
    }), 5)
    local closeAdminButton = round(mk("TextButton", adminHeader, {
        Position = UDim2.new(1, -28, 0, 4), Size = UDim2.fromOffset(20, 22),
        BackgroundColor3 = C.card, BorderSizePixel = 0, Text = "×", Font = BOLD,
        TextSize = 15, TextColor3 = C.text, AutoButtonColor = false, Active = true, ZIndex = 43,
    }), 5)
    local adminStatus = mk("TextLabel", adminRoot, {
        Position = UDim2.fromOffset(9, 32), Size = UDim2.new(1, -18, 0, 16),
        BackgroundTransparency = 1, Text = "Click a command button to use the in-game Admin Panel.",
        Font = FONT, TextSize = 8, TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 42,
    })
    local adminList = mk("ScrollingFrame", adminRoot, {
        Position = UDim2.fromOffset(8, 51), Size = UDim2.new(1, -16, 1, -79),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.dim, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Active = true, ZIndex = 41,
    })
    mk("UIListLayout", adminList, { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder })
    local adminCommands = {"balloon", "inverse", "jail", "jumpscare", "morph", "nightvision", "ragdoll", "rocket", "tiny"}
    local function renderAdminList()
        if not adminList or not adminList.Parent then return end
        for _, child in ipairs(adminList:GetChildren()) do if child:IsA("GuiObject") then child:Destroy() end end
        local count = 0
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and not isAdminBlacklisted(player.Name) then
                count = count + 1
                local row = round(mk("Frame", adminList, {
                    Name = "Player_" .. tostring(player.UserId), Size = UDim2.new(1, -4, 0, 76),
                    BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = count, ZIndex = 42,
                }), 5)
                mk("TextLabel", row, {
                    Position = UDim2.fromOffset(6, 0), Size = UDim2.new(1, -12, 0, 18),
                    BackgroundTransparency = 1, Text = player.Name, Font = BOLD, TextSize = 8,
                    TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 43,
                })
                for i, commandName in ipairs(adminCommands) do
                    local label = commandName:upper():sub(1, 5)
                    local gridRow = math.floor((i - 1) / 3)
                    local gridColumn = (i - 1) % 3
                    local button = round(mk("TextButton", row, {
                        Position = UDim2.fromOffset(6 + gridColumn * 110, 20 + gridRow * 18), Size = UDim2.fromOffset(102, 16),
                        BackgroundColor3 = Color3.fromRGB(37, 37, 37), BorderSizePixel = 0,
                        Text = label, Font = BOLD, TextSize = 7, TextColor3 = C.text,
                        AutoButtonColor = false, Active = true, ZIndex = 44,
                    }), 4)
                    button.MouseButton1Click:Connect(function()
                        if not isAdminBlacklisted(player.Name) then pcall(runAdminCommand, player, commandName) end
                    end)
                end
            end
        end
        if count == 0 then
            local empty = mk("TextLabel", adminList, {
                Size = UDim2.new(1, -4, 0, 26), BackgroundTransparency = 1,
                Text = "No eligible players in the server.", Font = FONT, TextSize = 10,
                TextColor3 = C.dim, ZIndex = 42,
            })
        end
        local pg = LP:FindFirstChildOfClass("PlayerGui")
        local native = pg and pg:FindFirstChild("AdminPanel")
        adminStatus.Text = native and "Commands use the in-game Admin Panel; blacklisted usernames are hidden." or "The in-game Admin Panel item must be available for commands to work."
    end
    local adminSettings = round(mk("Frame", gui, {
        Name = "AdminPanelSettings", Visible = false, Active = true,
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(360, 260), BackgroundColor3 = C.bg, BorderSizePixel = 0, ZIndex = 70,
    }), 8)
    local settingsStroke = Instance.new("UIStroke")
    settingsStroke.Color, settingsStroke.Transparency, settingsStroke.Thickness = C.line, 0.1, 1
    settingsStroke.Parent = adminSettings
    local apSettingsSig = mk("TextLabel", adminSettings, {
        Name = "StickySignature", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -2),
        Size = UDim2.new(1, -16, 0, 16), BackgroundTransparency = 1, Text = "leaked at discord.gg/Z7vPrxecnJ",
        Font = Enum.Font.GothamBold, TextScaled = true, TextColor3 = Color3.fromRGB(165, 165, 165), ZIndex = 80,
    })
    mk("UITextSizeConstraint", apSettingsSig, { MaxTextSize = 12, MinTextSize = 7 })
    pcall(_G.StickyRememberPanel, adminSettings, "AdminPanelSettings")
    local settingsHeader = round(mk("Frame", adminSettings, {
        Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(11, 11, 11),
        BorderSizePixel = 0, ZIndex = 71,
    }), 8)
    mk("TextLabel", settingsHeader, {
        Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -42, 1, 0),
        BackgroundTransparency = 1, Text = "AP SETTINGS  ·  USERNAME BLACKLIST",
        Font = BOLD, TextSize = 9, TextColor3 = C.text,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 72,
    })
    local closeSettingsButton = round(mk("TextButton", settingsHeader, {
        Position = UDim2.new(1, -26, 0, 4), Size = UDim2.fromOffset(18, 20),
        BackgroundColor3 = C.card, BorderSizePixel = 0, Text = "×", Font = BOLD,
        TextSize = 14, TextColor3 = C.text, AutoButtonColor = false, Active = true, ZIndex = 73,
    }), 4)
    local nameInput = round(mk("TextBox", adminSettings, {
        Position = UDim2.fromOffset(8, 38), Size = UDim2.new(1, -70, 0, 26),
        BackgroundColor3 = C.card, BorderSizePixel = 0, Text = "",
        PlaceholderText = "Roblox username", PlaceholderColor3 = C.dim,
        Font = FONT, TextSize = 10, TextColor3 = C.text, ClearTextOnFocus = false,
        ZIndex = 72,
    }), 5)
    local addBlacklistButton = round(mk("TextButton", adminSettings, {
        Position = UDim2.new(1, -56, 0, 38), Size = UDim2.fromOffset(48, 26),
        BackgroundColor3 = C.white, BorderSizePixel = 0, Text = "ADD",
        Font = BOLD, TextSize = 9, TextColor3 = C.bg, AutoButtonColor = false, Active = true, ZIndex = 72,
    }), 5)
    local blacklistList = mk("ScrollingFrame", adminSettings, {
        Position = UDim2.fromOffset(8, 72), Size = UDim2.new(1, -16, 1, -100),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.dim, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Active = true, ZIndex = 71,
    })
    local blacklistLayout = mk("UIListLayout", blacklistList, { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })
    local function saveBlacklist()
        saveSettings()
        renderAdminList()
    end
    local function renderBlacklist()
        for _, child in ipairs(blacklistList:GetChildren()) do if child:IsA("GuiObject") then child:Destroy() end end
        local names = _G.StickyAdminBlacklist
        table.sort(names, function(a, b) return tostring(a):lower() < tostring(b):lower() end)
        for i, name in ipairs(names) do
            local row = round(mk("Frame", blacklistList, {
                Size = UDim2.new(1, -4, 0, 26), BackgroundColor3 = C.card,
                BorderSizePixel = 0, LayoutOrder = i, ZIndex = 72,
            }), 4)
            mk("TextLabel", row, {
                Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -42, 1, 0),
                BackgroundTransparency = 1, Text = tostring(name), Font = FONT, TextSize = 10,
                TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 73,
            })
            local removeButton = round(mk("TextButton", row, {
                Position = UDim2.new(1, -30, 0.5, -9), Size = UDim2.fromOffset(22, 18),
                BackgroundColor3 = C.off, BorderSizePixel = 0, Text = "X", Font = BOLD,
                TextSize = 8, TextColor3 = C.text, AutoButtonColor = false, Active = true, ZIndex = 74,
            }), 4)
            local captured = tostring(name)
            removeButton.MouseButton1Click:Connect(function()
                for index = #_G.StickyAdminBlacklist, 1, -1 do
                    if tostring(_G.StickyAdminBlacklist[index]):lower() == captured:lower() then table.remove(_G.StickyAdminBlacklist, index) end
                end
                renderBlacklist()
                saveBlacklist()
            end)
        end
    end
    local function addBlacklistName()
        local name = cleanUsername(nameInput.Text)
        if not name or isAdminBlacklisted(name) then return end
        _G.StickyAdminBlacklist[#_G.StickyAdminBlacklist + 1] = name
        nameInput.Text = ""
        renderBlacklist()
        saveBlacklist()
    end
    addBlacklistButton.MouseButton1Click:Connect(addBlacklistName)
    nameInput.FocusLost:Connect(function(enterPressed) if enterPressed then addBlacklistName() end end)
    closeSettingsButton.MouseButton1Click:Connect(function() adminSettings.Visible = false end)
    do
        local dragging, dragStart, startPos, trackedInput
        settingsHeader.Active = true
        settingsHeader.InputBegan:Connect(function(input)
            if _G.StickyAllUiDragLocked == true then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging, dragStart, startPos = true, input.Position, adminSettings.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end)
        settingsHeader.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then trackedInput = input end
        end)
        UIS.InputChanged:Connect(function(input)
            if _G.StickyAllUiDragLocked == true or not dragging or input ~= trackedInput then return end
            local delta = input.Position - dragStart
            adminSettings.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end)
    end
    local adminTogglePaint
    local function openAdminSettings()
        adminRoot.Visible = true
        _G.StickyAdminPanelUiOn = true
        adminSettings.Visible = true
        if adminTogglePaint then adminTogglePaint() end
        renderBlacklist()
        renderAdminList()
        saveSettings()
    end
    apSettingsButton.MouseButton1Click:Connect(openAdminSettings)
    refreshAdminButton.MouseButton1Click:Connect(renderAdminList)
    local function setAdminPanelUI(value)
        _G.StickyAdminPanelUiOn = value == true
        adminRoot.Visible = _G.StickyAdminPanelUiOn
        if not adminRoot.Visible then adminSettings.Visible = false end
        if adminTogglePaint then adminTogglePaint() end
        if adminRoot.Visible then renderAdminList() end
        saveSettings()
    end
    closeAdminButton.MouseButton1Click:Connect(function() setAdminPanelUI(false) end)
    do
        local dragging, dragStart, rootStart, trackedInput
        adminHeader.InputBegan:Connect(function(input)
            if _G.StickyAllUiDragLocked == true then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging, dragStart, rootStart = true, input.Position, adminRoot.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end)
        adminHeader.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then trackedInput = input end
        end)
        UIS.InputChanged:Connect(function(input)
            if _G.StickyAllUiDragLocked == true or not dragging or input ~= trackedInput then return end
            local delta = input.Position - dragStart
            adminRoot.Position = UDim2.new(rootStart.X.Scale, rootStart.X.Offset + delta.X, rootStart.Y.Scale, rootStart.Y.Offset + delta.Y)
        end)
    end
    Players.PlayerAdded:Connect(function() task.delay(0.2, renderAdminList) end)
    Players.PlayerRemoving:Connect(function() task.defer(renderAdminList) end)
    renderAdminList()
    renderBlacklist()
    if _G.StickyAdminPanelUiOn == true then adminRoot.Visible = true end

    makeToggle(pages.ESP, 82, "PLAYER ESP", function() return _G.StickyPlayerESP end, function(value)
        _G.StickyPlayerESP = value
        if type(_G.StickyRefreshPlayerESP) == "function" then pcall(_G.StickyRefreshPlayerESP) end
    end, 0, 168)
    makeToggle(pages.ESP, 82, "FMLY ESP", function() return _G.StickyFmlyESP end, function(value)
        _G.StickyFmlyESP = value
    end, 176, 168)
    makeToggle(pages.ESP, 117, "SON ESP", function() return _G.StickySonESP end, function(value)
        _G.StickySonESP = value
    end, 0, 168)
    makeToggle(pages.ESP, 117, "CONVEYOR ESP", function() return _G.StickyConveyorESP end, function(value)
        _G.StickyConveyorESP = value
        if not value then for inst in pairs(worldMarkers) do destroyWorldMarker(inst) end end
    end, 176, 168)
    makeToggle(pages.ESP, 152, "TRAP ESP", function() return _G.StickyTrapESP end, function(value)
        _G.StickyTrapESP = value
        if not value then task.defer(refreshExtraWorldESP) end
    end, 0, 168)
    makeToggle(pages.ESP, 152, "LINE TO BASE", function() return _G.StickyLineToBase end, function(value)
        _G.StickyLineToBase = value
        if value then task.defer(updatePlotBeam) else resetPlotBeam() end
    end, 176, 168)

    local function placeholder(page, text)
        mk("TextLabel", page, {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Text = text, Font = FONT, TextSize = 10, TextColor3 = C.dim,
            TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 22,
        })
    end
    if _G.StickyPriAlert == nil then _G.StickyPriAlert = true end
    if type(_G.StickyPrioritySoundID) ~= "string" then _G.StickyPrioritySoundID = "" end
    if _G.StickyClickToAP == nil then _G.StickyClickToAP = false end
    if _G.StickyProximityAP == nil then _G.StickyProximityAP = false end
    if _G.StickyProximityRange == nil then _G.StickyProximityRange = 15 end

    local miscContent = mk("ScrollingFrame", pages.MISC, {
        Name = "MiscFeatures", Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, -3, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.line, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Active = true, ZIndex = 22,
    })
    makeToggle(miscContent, 0, "AUTO DESTROY TURRET", function()
        return _G.StickyAutoDestroyTurret == true
    end, function(value) setAutoTurret(value) end)
    makeToggle(miscContent, 38, "AUTO KICK ON STEAL", function()
        return _G.StickyAutoKickOnSteal == true
    end, function(value) _G.StickyAutoKickOnSteal = value end)
    makeToggle(miscContent, 76, "PRIORITY SOUND", function()
        return _G.StickyPriAlert == true
    end, function(value) _G.StickyPriAlert = value end)

    local rangeRow = round(mk("Frame", miscContent, {
        Position = UDim2.fromOffset(0, 190), Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = C.card, BorderSizePixel = 0, ZIndex = 22,
    }), 5)
    mk("TextLabel", rangeRow, {
        Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -112, 1, 0),
        BackgroundTransparency = 1, Text = "PROXIMITY AP RANGE", Font = BOLD,
        TextSize = 9, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 23,
    })
    local rangeValue = mk("TextLabel", rangeRow, {
        Position = UDim2.new(1, -101, 0, 0), Size = UDim2.fromOffset(38, 30),
        BackgroundTransparency = 1, Text = "", Font = BOLD, TextSize = 9,
        TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 23,
    })
    local function paintProximityRange()
        _G.StickyProximityRange = math.clamp(tonumber(_G.StickyProximityRange) or 15, 5, 60)
        rangeValue.Text = tostring(_G.StickyProximityRange)
    end
    local function rangeButton(text, x, delta)
        local button = round(mk("TextButton", rangeRow, {
            Position = UDim2.new(1, x, 0, 5), Size = UDim2.fromOffset(22, 20),
            BackgroundColor3 = C.off, BorderSizePixel = 0, Text = text, Font = BOLD,
            TextSize = 10, TextColor3 = C.text, AutoButtonColor = false, Active = true, ZIndex = 24,
        }), 4)
        button.MouseButton1Click:Connect(function()
            _G.StickyProximityRange = math.clamp((tonumber(_G.StickyProximityRange) or 15) + delta, 5, 60)
            paintProximityRange()
            saveTpSettings()
        end)
    end
    rangeButton("−", -56, -5)
    rangeButton("+", -30, 5)
    paintProximityRange()

    local soundRow = round(mk("Frame", miscContent, {
        Position = UDim2.fromOffset(0, 114), Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = C.card, BorderSizePixel = 0, ZIndex = 22,
    }), 5)
    local soundIdBox = round(mk("TextBox", soundRow, {
        Position = UDim2.fromOffset(6, 4), Size = UDim2.new(1, -82, 0, 22),
        BackgroundColor3 = C.off, BorderSizePixel = 0,
        Text = tostring(_G.StickyPrioritySoundID or ""), PlaceholderText = "Priority sound ID (blank = ping)",
        PlaceholderColor3 = C.dim, Font = FONT, TextSize = 8, TextColor3 = C.text,
        ClearTextOnFocus = false, ZIndex = 23,
    }), 4)
    local function playPrioritySound()
        local digits = tostring(_G.StickyPrioritySoundID or ""):match("%d+")
        local snd = Instance.new("Sound")
        snd.SoundId = digits and ("rbxassetid://" .. digits) or "rbxasset://sounds/electronicpingshort.wav"
        snd.Volume = 3
        snd.Parent = game:GetService("SoundService")
        pcall(function() snd:Play() end)
        task.delay(12, function() pcall(function() snd:Destroy() end) end)
    end
    local testSound = round(mk("TextButton", soundRow, {
        Position = UDim2.new(1, -70, 0, 4), Size = UDim2.fromOffset(64, 22),
        BackgroundColor3 = C.white, BorderSizePixel = 0, Text = "TEST",
        Font = BOLD, TextSize = 8, TextColor3 = C.bg, AutoButtonColor = false, Active = true, ZIndex = 23,
    }), 4)
    soundIdBox.FocusLost:Connect(function()
        local digits = tostring(soundIdBox.Text or ""):match("%d+")
        _G.StickyPrioritySoundID = digits or ""
        soundIdBox.Text = _G.StickyPrioritySoundID
        saveTpSettings()
    end)
    testSound.MouseButton1Click:Connect(playPrioritySound)

    local clickAPBusy, apCommandIndex = false, 0
    local apPlayerCooldown, apCommandCooldown = {}, {}
    local function issueAPCommand(player, isProximity)
        if clickAPBusy or not player or player == LP or not player.Parent or isAdminBlacklisted(player.Name) then return end
        local now = os.clock()
        local userId = player.UserId
        if isProximity and now - (apPlayerCooldown[userId] or 0) < 3 then return end
        local command
        for _ = 1, #adminCommands do
            apCommandIndex = (apCommandIndex % #adminCommands) + 1
            local candidate = adminCommands[apCommandIndex]
            if now - (apCommandCooldown[candidate] or 0) >= 2 then command = candidate; break end
        end
        if not command then return end
        clickAPBusy = true
        apPlayerCooldown[userId] = now
        task.spawn(function()
            local ok, fired = pcall(runAdminCommand, player, command)
            if ok and fired then apCommandCooldown[command] = os.clock() end
            clickAPBusy = false
        end)
    end
    local clickAPInput = game:GetService("UserInputService")
    if _G.StickyAPClickConnection then pcall(function() _G.StickyAPClickConnection:Disconnect() end) end
    _G.StickyAPClickConnection = clickAPInput.InputBegan:Connect(function(input, processed)
        if processed or _G.StickyClickToAP ~= true then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local camera = workspace.CurrentCamera
        if not camera then return end
        local screenPos = input.UserInputType == Enum.UserInputType.Touch
            and Vector2.new(input.Position.X, input.Position.Y)
            or clickAPInput:GetMouseLocation()
        local inset = game:GetService("GuiService"):GetGuiInset()
        local mousePos = Vector2.new(screenPos.X - inset.X, screenPos.Y - inset.Y)
        local ray = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
        local direction = ray.Direction.Unit
        local bestPlayer, bestAlong = nil, math.huge
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            local character = player ~= LP and player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local offset = hrp.Position - ray.Origin
                local along = offset:Dot(direction)
                if along > 0 and along < bestAlong then
                    local distanceFromRay = (offset - direction * along).Magnitude
                    if distanceFromRay <= 8 then bestPlayer, bestAlong = player, along end
                end
            end
        end
        if bestPlayer then issueAPCommand(bestPlayer, false) end
    end)
    task.spawn(function()
        while gui.Parent do
            if _G.StickyProximityAP == true and not clickAPBusy then
                local character = LP.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local nearest, nearestDistance = nil, tonumber(_G.StickyProximityRange) or 15
                    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                        local targetCharacter = player ~= LP and player.Character
                        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
                        if targetRoot and not isAdminBlacklisted(player.Name) then
                            local distance = (targetRoot.Position - rootPart.Position).Magnitude
                            if distance <= nearestDistance and os.clock() - (apPlayerCooldown[player.UserId] or 0) >= 3 then
                                nearest, nearestDistance = player, distance
                            end
                        end
                    end
                    if nearest then issueAPCommand(nearest, true) end
                end
            end
            task.wait(0.25)
        end
    end)
    local proximityViz, proximityVizRange
    task.spawn(function()
        while gui.Parent do
            if _G.StickyProximityAP == true then
                local character = LP.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local range = math.clamp(tonumber(_G.StickyProximityRange) or 15, 5, 60)
                    if not proximityViz or not proximityViz.Parent then
                        proximityViz = Instance.new("Part")
                        proximityViz.Name = "StickyProximityRangeVisual"
                        proximityViz.Shape = Enum.PartType.Cylinder
                        proximityViz.Anchored = true
                        proximityViz.CanCollide = false
                        proximityViz.CanTouch = false
                        proximityViz.CanQuery = false
                        proximityViz.CastShadow = false
                        proximityViz.Material = Enum.Material.Neon
                        proximityViz.Color = C.white
                        proximityViz.Transparency = 0.82
                        proximityViz.Parent = Workspace
                        proximityVizRange = nil
                    end
                    if range ~= proximityVizRange then
                        proximityViz.Size = Vector3.new(0.15, range * 2, range * 2)
                        proximityVizRange = range
                    end
                    proximityViz.CFrame = CFrame.new(rootPart.Position + Vector3.new(0, -2.5, 0))
                        * CFrame.Angles(0, 0, math.rad(90))
                end
            elseif proximityViz then
                pcall(function() proximityViz:Destroy() end)
                proximityViz, proximityVizRange = nil, nil
            end
            task.wait(0.1)
        end
        if proximityViz then pcall(function() proximityViz:Destroy() end) end
    end)

    local prioritySeen, priorityStartedAt = {}, os.clock()
    task.spawn(function()
        while gui.Parent do
            if _G.StickyPriAlert == true then
                local priority = {}
                for _, name in ipairs(type(_G.SHARED_PRIORITY_ITEMS) == "table" and _G.SHARED_PRIORITY_ITEMS or {}) do
                    priority[tostring(name):lower()] = true
                end
                local ok, pets = pcall(scanForTP)
                local foundNew = false
                if ok and type(pets) == "table" and os.clock() - priorityStartedAt >= 6 then
                    for _, pet in ipairs(pets) do
                        if type(pet) == "table" and pet.name and not pet.conveyor
                            and pet.owner ~= LP.Name and priority[tostring(pet.name):lower()] then
                            local key = tostring(pet.uid or (tostring(pet.plot) .. ":" .. tostring(pet.slot) .. ":" .. tostring(pet.name)))
                            if not prioritySeen[key] then prioritySeen[key] = true; foundNew = true end
                        end
                    end
                    if foundNew then playPrioritySound() end
                end
            end
            task.wait(1.5)
        end
    end)
    local function setMainUI(value)
        root.Visible = value == true
        _G.StickyMainUIOn = root.Visible
    end
    _G.StickySetMainUI = setMainUI
    mk("TextLabel", pages.MAIN, {
        Position = UDim2.fromOffset(4, 0), Size = UDim2.new(1, -8, 0, 18),
        BackgroundTransparency = 1, Text = "UI VISIBILITY", Font = BOLD, TextSize = 10,
        TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22,
    })
    makeToggle(pages.MAIN, 22, "MAIN UI", function() return root.Visible == true end, setMainUI)
    makeToggle(pages.MAIN, 53, "MINI UI", function() return _G.StickyMiniUIOn == true end, function(value)
        if type(_G.StickySetMiniUI) == "function" then _G.StickySetMiniUI(value) end
    end)
    makeToggle(pages.MAIN, 84, "INVISIBLE STEAL UI", function() return _G.StickyInvisibleStealUIOn == true end, function(value)
        if type(_G.StickySetInvisibleStealUI) == "function" then _G.StickySetInvisibleStealUI(value) end
    end)
    makeToggle(pages.MAIN, 115, "ADMIN PANEL UI", function() return _G.StickyAdminPanelUiOn == true end, function(value)
        setAdminPanelUI(value)
    end)
    makeToggle(pages.MAIN, 146, "STEAL TARGET UI", function() return _G.StickyTargetsUIOn == true end, function(value)
        if type(_G.StickySetTargetsUI) == "function" then _G.StickySetTargetsUI(value) end
    end)
    local adminContent = mk("ScrollingFrame", pages["ADMIN PANEL"], {
        Name = "AdminPanelCategoryContent", Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, -3, 1, 0), BackgroundTransparency = 1,
        BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.line,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Active = true, ZIndex = 22,
    })
    local adminCategoryPadding = mk("UIPadding", adminContent, {
        PaddingRight = UDim.new(0, 5), PaddingBottom = UDim.new(0, 6),
    })
    mk("TextLabel", adminContent, {
        Position = UDim2.fromOffset(4, 0), Size = UDim2.new(1, -8, 0, 18),
        BackgroundTransparency = 1, Text = "ADMIN PANEL CONTROLS", Font = BOLD, TextSize = 10,
        TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 22,
    })
    adminTogglePaint = makeToggle(adminContent, 22, "ADMIN PANEL UI", function()
        return _G.StickyAdminPanelUiOn == true
    end, function(value)
        setAdminPanelUI(value)
    end)
    local apSettingsMainButton = round(mk("TextButton", adminContent, {
        Position = UDim2.fromOffset(0, 58), Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = C.card, BorderSizePixel = 0, Text = "AP SETTINGS",
        Font = BOLD, TextSize = 9, TextColor3 = C.text, AutoButtonColor = false, Active = true, ZIndex = 22,
    }), 5)
    apSettingsMainButton.MouseButton1Click:Connect(openAdminSettings)
    makeToggle(adminContent, 96, "CLICK TO AP", function()
        return _G.StickyClickToAP == true
    end, function(value) _G.StickyClickToAP = value end)
    makeToggle(adminContent, 134, "PROXIMITY AP", function()
        return _G.StickyProximityAP == true
    end, function(value) _G.StickyProximityAP = value end)
    rangeRow.Parent = adminContent
    rangeRow.Position = UDim2.fromOffset(0, 172)

    do
        local dragging, dragStart, rootStart, trackedInput
        header.InputBegan:Connect(function(input)
            if _G.StickyAllUiDragLocked == true then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging, dragStart, rootStart = true, input.Position, root.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end)
        header.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then trackedInput = input end
        end)
        UIS.InputChanged:Connect(function(input)
            if _G.StickyAllUiDragLocked == true or not dragging or input ~= trackedInput then return end
            local delta = input.Position - dragStart
            root.Position = UDim2.new(rootStart.X.Scale, rootStart.X.Offset + delta.X, rootStart.Y.Scale, rootStart.Y.Offset + delta.Y)
        end)
    end

    openButton.MouseButton1Click:Connect(function() _G.StickySetMainUI(not root.Visible) end)
    _G.StickyToggleMainUI = function() _G.StickySetMainUI(not root.Visible) end
    _G.StickyShowMainUi = function() _G.StickySetMainUI(true); selectCategory("ESP") end
    _G.StickyShowTeleportSettings = function() root.Visible = true; selectCategory("TELEPORT") end
    _G.StickyOpenTeleportSettings = _G.StickyShowTeleportSettings
    _G.StickyMainScreenGui = gui

    task.spawn(function()
        local count, last = 0, os.clock()
        while gui and gui.Parent do
            RunService.RenderStepped:Wait()
            count = count + 1
            local now = os.clock()
            if now - last >= 0.5 then
                fpsLabel.Text = string.format("FPS %d", math.floor(count / math.max(now - last, 0.01) + 0.5))
                count, last = 0, now
            end
        end
    end)

    local function makeRoster(options)
        local roster = { names = {}, ids = {}, source = "none" }
        local function addValue(raw)
            local value = tostring(raw or ""):gsub("\\", ""):gsub("%*", "")
                :gsub("^%s+", ""):gsub("%s+$", "")
                :gsub("^[^%w_#]+", ""):gsub("[^%w_]+$", "")
            local id = value:match("^#?(%d+)$") or value:match("^roblox_user_(%d+)$")
            if id then
                local n = tonumber(id)
                if n and n > 0 and n < 1e11 then roster.ids[n] = true end
                return
            end
            local name = value:lower():gsub("%s+", "")
            if #name >= 3 and #name <= 20 and name:match("^[%w_]+$") and not name:match("^%d+$") then
                roster.names[name] = true
            end
            local longest = ""
            for token in value:gmatch("[%w_]+") do if #token > #longest then longest = token end end
            if #longest >= 3 and #longest <= 20 and longest:match("^[%w_]+$") and not longest:match("^%d+$") then
                roster.names[longest:lower()] = true
            end
        end
        if isfile and readfile then
            pcall(function()
                if not isfile(options.cache) then return end
                for line in tostring(readfile(options.cache)):gmatch("[^\r\n]+") do addValue(line) end
                if next(roster.names) or next(roster.ids) then roster.source = "cache" end
            end)
        end
        function roster:has(player)
            if not player then return false end
            if self.names[tostring(player.Name):lower()] then return true end
            if self.names[tostring(player.DisplayName):lower()] then return true end
            return self.ids[tonumber(player.UserId)] == true
        end
        function roster:refresh()
            local body
            if not options.headers and game.HttpGet then
                local ok, result = pcall(function() return game:HttpGet(options.url, true) end)
                if ok then body = result end
            end
            if not body or body == "" then
                local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
                if not req then return false end
                local ok, response = pcall(req, { Url = options.url, Method = "GET", Headers = options.headers })
                if ok and response then body = response.Body or response.body end
            end
            if type(body) ~= "string" or body == "" then return false end
            local ok, decoded = pcall(HttpService.JSONDecode, HttpService, body)
            if not ok or type(decoded) ~= "table" or type(decoded[options.field]) ~= "table" then return false end
            local entries = decoded[options.field]
            if #entries == 0 then return false end
            self.names, self.ids = {}, {}
            for _, entry in ipairs(entries) do addValue(entry) end
            self.source = "live"
            if writefile then
                pcall(function()
                    local out = {}
                    for name in pairs(self.names) do out[#out + 1] = name end
                    for id in pairs(self.ids) do out[#out + 1] = "#" .. tostring(id) end
                    writefile(options.cache, table.concat(out, "\n"))
                end)
            end
            return true
        end
        return roster
    end

    local familyGood = makeRoster({
        field = "good", cache = "Sticky_FmlyGood.txt",
        url = "",
    })
    local familyBad = makeRoster({
        field = "bad", cache = "Sticky_FmlyBad.txt",
        url = "",
    })
    local sonSafe = makeRoster({
        field = "safe", cache = "Sticky_SonSafe.txt", url = "",
        headers = { ["x-api-key"] = "son-esp-key-2026", ["Content-Type"] = "application/json" },
    })
    local sonGrief = makeRoster({
        field = "grief", cache = "Sticky_SonGrief.txt", url = "",
        headers = { ["x-api-key"] = "son-esp-key-2026", ["Content-Type"] = "application/json" },
    })
    _G.StickyFmlyStatus = function(player)
        if familyGood:has(player) then return "good" end
        if familyBad:has(player) then return "bad" end
        return nil
    end
    _G.StickySonStatus = function(player)
        if sonSafe:has(player) then return "good" end
        if sonGrief:has(player) then return "bad" end
        return nil
    end
    task.spawn(function() task.wait(2); familyGood:refresh() end)
    task.spawn(function() task.wait(2.5); sonSafe:refresh() end)
    task.spawn(function() task.wait(3); familyBad:refresh() end)
    task.spawn(function() task.wait(3.5); sonGrief:refresh() end)

    local roleFolder = Instance.new("Folder")
    roleFolder.Name = "_StickyRosterESP"
    roleFolder.Parent = Workspace
    local roleGui = Instance.new("ScreenGui")
    roleGui.Name = "StickyRosterESPLabels"
    roleGui.ResetOnSpawn = false
    roleGui.IgnoreGuiInset = true
    roleGui.DisplayOrder = 1000001
    roleGui.Parent = host
    local roleItems = {}
    local ROLE_COLORS = {
        FMLY = Color3.fromRGB(90, 220, 160),
        ["FMLY-BAD"] = Color3.fromRGB(255, 105, 105),
        SON = Color3.fromRGB(90, 200, 220),
        ["SON-GRIEF"] = Color3.fromRGB(255, 145, 90),
    }
    local function clearRoleItem(player)
        local item = roleItems[player]
        if item then
            pcall(function() item.highlight:Destroy() end)
            pcall(function() item.label:Destroy() end)
            roleItems[player] = nil
        end
    end
    local function rosterRoles(player)
        local roles = {}
        if _G.StickyFmlyESP == true then
            local status = _G.StickyFmlyStatus(player)
            if status == "good" then roles[#roles + 1] = "FMLY"
            elseif status == "bad" then roles[#roles + 1] = "FMLY-BAD" end
        end
        if _G.StickySonESP == true then
            local status = _G.StickySonStatus(player)
            if status == "good" then roles[#roles + 1] = "SON"
            elseif status == "bad" then roles[#roles + 1] = "SON-GRIEF" end
        end
        return roles
    end
    local function refreshRosterESP()
        local seen = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local roles = rosterRoles(player)
                if #roles > 0 then
                    local character = player.Character
                    local roleText = table.concat(roles, "  /  ")
                    local existing = roleItems[player]
                    if not existing or existing.character ~= character or existing.text ~= roleText then
                        clearRoleItem(player)
                        local color = ROLE_COLORS[roles[1]] or C.white
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "StickyRosterHighlight_" .. tostring(player.UserId)
                        highlight.Adornee = character
                        highlight.FillTransparency = 1
                        highlight.OutlineColor = color
                        highlight.OutlineTransparency = 0
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = roleFolder
                        local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                        local label = Instance.new("BillboardGui")
                        label.Name = "StickyRosterTag_" .. tostring(player.UserId)
                        label.Adornee = head
                        label.AlwaysOnTop = true
                        label.LightInfluence = 0
                        label.MaxDistance = 3000
                        label.Size = UDim2.fromOffset(180, 24)
                        label.StudsOffset = Vector3.new(0, 3.8, 0)
                        label.Parent = roleGui
                        local text = Instance.new("TextLabel")
                        text.Size = UDim2.fromScale(1, 1)
                        text.BackgroundTransparency = 1
                        text.Text = roleText
                        text.Font = BOLD
                        text.TextSize = 12
                        text.TextColor3 = color
                        text.TextStrokeTransparency = 0
                        text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        text.Parent = label
                        roleItems[player] = { character = character, text = roleText, highlight = highlight, label = label }
                    else
                        local head = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
                        if head then existing.label.Adornee = head end
                    end
                    seen[player] = true
                end
            end
        end
        for player in pairs(roleItems) do if not seen[player] then clearRoleItem(player) end end
    end
    Players.PlayerRemoving:Connect(clearRoleItem)
    task.spawn(function()
        while gui and gui.Parent do
            pcall(refreshRosterESP)
            task.wait(0.5)
        end
    end)

    if _G.StickyFovEnabled == true then task.defer(applyFov) end
end)()

;(function()
    local active, conns = false, {}
    local realHRP, cloneHRP, track, hip, origT
    local stuck, restarting = false, false
    local start, stop

    local function depth()
        return 0.01 + (math.clamp(tonumber(_G.StickyInvisDepth) or 4.2, 0, 10) / 10) * 0.19
    end
    local function angle()
        return math.clamp(tonumber(_G.StickyInvisAngle) or 180, 0, 360)
    end
    local function add(c) conns[#conns + 1] = c end
    local function rewire(char, from, to)
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == from then v.Part0 = to end
                if v.Part1 == from then v.Part1 = to end
            end
        end
    end

    stop = function()
        active, stuck = false, false
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
        if origT then
            for p, v in pairs(origT) do
                if p and p.Parent then pcall(function() p.LocalTransparencyModifier = v end) end
            end
            origT = nil
        end
        if track then
            pcall(function() track:AdjustSpeed(1) track:Stop(0) track:Destroy() end)
            track = nil
        end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if realHRP and realHRP:IsDescendantOf(game) and hum then
            local tmp = Instance.new("Model")
            tmp.Parent = game
            char.Parent = tmp
            realHRP.Parent = char
            char.PrimaryPart = realHRP
            char.Parent = workspace
            realHRP.CanCollide = true
            rewire(char, cloneHRP, realHRP)
            if cloneHRP then
                local at = cloneHRP.CFrame
                cloneHRP:Destroy()
                cloneHRP = nil
                realHRP.CFrame = at
            end
            hum.HipHeight = hip or 0
            tmp:Destroy()
        end
        realHRP, cloneHRP = nil, nil
        _G.StickyInvisActive = false
    end

    local function animTrick(char, hum)
        if not (char and hum and hum.Health > 0) then return end
        local a = Instance.new("Animation")
        a.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
        local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
        track = animator:LoadAnimation(a)
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = true
        track:Play(0, 1, 0)
        a:Destroy()
        add(track.Stopped:Connect(function()
            if active then animTrick(char, hum) end
        end))
        task.defer(function()
            if not track then return end
            track.TimePosition = 0.7
            task.delay(0.1, function() if track then track:AdjustSpeed(math.huge) end end)
        end)
    end

    start = function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum or active then return false end

        local folder = workspace:FindFirstChild(LP.Name)
        if folder then
            for _, n in ipairs({ "DoubleRig", "Constraints" }) do
                local x = folder:FindFirstChild(n)
                if x then x:Destroy() end
            end
            add(folder.ChildAdded:Connect(function(c)
                if c.Name == "DoubleRig" or c.Name == "Constraints" then c:Destroy() end
            end))
        end
        for _, s in ipairs({ "Dead", "FallingDown", "Ragdoll" }) do
            hum:SetStateEnabled(Enum.HumanoidStateType[s], false)
        end

        hip = hum.HipHeight
        realHRP = char:FindFirstChild("HumanoidRootPart")
        if not (realHRP and realHRP.Parent) then return false end

        local tmp = Instance.new("Model")
        tmp.Parent = game
        char.Parent = tmp
        cloneHRP = realHRP:Clone()
        cloneHRP.Parent = char
        realHRP.Parent = workspace.CurrentCamera
        cloneHRP.CFrame = realHRP.CFrame
        char.PrimaryPart = cloneHRP
        char.Parent = workspace
        rewire(char, realHRP, cloneHRP)
        tmp:Destroy()

        active = true
        animTrick(char, hum)

        origT = {}
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                origT[p] = p.LocalTransparencyModifier
                p.LocalTransparencyModifier = 1
            end
        end
        add(char.DescendantAdded:Connect(function(d)
            if not (active and d:IsA("BasePart")) then return end
            if origT and origT[d] == nil then origT[d] = d.LocalTransparencyModifier end
            pcall(function() d.LocalTransparencyModifier = 1 end)
        end))

        add(RunService.Heartbeat:Connect(function()
            if not active or not hum.Parent then return end
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Dead or st == Enum.HumanoidStateType.FallingDown
                or st == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end))

        local lastTarget, grace = nil, 60
        add(RunService.PreSimulation:Connect(function()
            if not (active and realHRP and hum.Health > 0) then return end
            local base = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
            if not base then return end
            if grace > 0 then
                grace = grace - 1
            elseif not stuck and lastTarget then
                local _drift = (realHRP.Position - lastTarget).Magnitude
                local _cloneDrift = cloneHRP and (cloneHRP.Position - lastTarget).Magnitude or 0
                if _drift > 2.25 or _cloneDrift > 8 then
                    stuck = true
                    if not restarting then
                        task.spawn(function()
                            restarting = true
                            pcall(stop)
                            task.wait(0.5)
                            restarting = false
                            local ok = pcall(start)
                            if not ok then
                                task.wait(1)
                                pcall(start)
                            end
                        end)
                    end
                end
            end
            local cf = base.CFrame
                - Vector3.new(0, hum.HipHeight + (base.Size.Y / 2) - 1 + depth(), 0)
            realHRP.CFrame = cf * CFrame.Angles(math.rad(angle()), 0, 0)
            realHRP.AssemblyLinearVelocity = base.AssemblyLinearVelocity
            realHRP.CanCollide = false
            if realHRP.Parent ~= workspace.CurrentCamera then
                realHRP.Parent = workspace.CurrentCamera
            end
            lastTarget = cf.Position
        end))

        add(LP.CharacterAdded:Connect(function() if active then stop() end end))
        _G.StickyInvisActive = true
        return true
    end

    _G.StickyInvisStart, _G.StickyInvisStop = start, stop
    _G.StickyInvisToggle = function()
        if active then stop() else start() end
    end

    local armed, autoOn = false, false
    local function syncAuto()
        local want = (_G.StickyInvisAuto == true) and (LP:GetAttribute("Stealing") == true)
        if not want then
            armed = false
            if active and autoOn then autoOn = false pcall(stop) end
            return
        end
        if active or armed then return end
        armed = true
        task.delay(tonumber(_G.StickyInvisAutoDelay) or 1.5, function()
            armed = false
            if _G.StickyInvisAuto == true and not active
                and LP:GetAttribute("Stealing") == true then
                autoOn = true
                pcall(start)
            end
        end)
    end
    _G.StickyInvisSync = syncAuto
    LP:GetAttributeChangedSignal("Stealing"):Connect(syncAuto)
end)()

do
    local LP = game:GetService("Players").LocalPlayer
    local Workspace = game:GetService("Workspace")
    local old = _G.StickyAutoRecoverConnections
    if type(old) == "table" then
        for _, connection in ipairs(old) do pcall(function() connection:Disconnect() end) end
    end
    local connections = {}
    _G.StickyAutoRecoverConnections = connections
    local wasStealing = LP:GetAttribute("Stealing") == true
    local hitDuringSteal, recovering = false, false
    local recentStealUntil = 0
    local recoveryTarget = _G.StickyActiveStealPet or _G.StickyStealTarget
    local function snapshotTarget()
        local target = _G.StickyActiveStealPet or _G.StickyStealTarget
        if type(target) ~= "table" or not target.plot or target.slot == nil then return nil end
        return { plot = tostring(target.plot), slot = tostring(target.slot), position = target.position, name = target.name }
    end
    local function ragdollActive()
        local untilTime = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
        local now = 0
        pcall(function() now = Workspace:GetServerTimeNow() end)
        if untilTime > now + 0.05 then return true end
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return false end
        local state = humanoid:GetState()
        return state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Physics
    end
    local function beginRecovery()
        if recovering or _G.StickyAutoRecoverHit ~= true or not hitDuringSteal then return end
        if os.clock() < (tonumber(_G.StickySuppressAutoRecoverUntil) or 0) then
            hitDuringSteal = false
            return
        end
        local target = recoveryTarget or snapshotTarget()
        hitDuringSteal = false
        if not target or not target.plot or target.slot == nil then return end
        recovering = true
        task.spawn(function()
            local started = os.clock()
            while os.clock() - started < 10 do
                if _G.StickyAutoRecoverHit ~= true then recovering = false; return end
                if os.clock() < (tonumber(_G.StickySuppressAutoRecoverUntil) or 0) then
                    hitDuringSteal = false; recovering = false; return
                end
                local busy = _G.StickyTPBusy == true or LP:GetAttribute("Stealing") == true
                if not ragdollActive() and not busy then break end
                task.wait(0.1)
            end
            -- Hit recovery should return to the selected brainrot, not restart
            -- the side-steal/reclone routine (which can route out of the base).
            -- Use the saved target position and slot directly.
            if _G.StickyAutoRecoverHit == true
                and os.clock() >= (tonumber(_G.StickySuppressAutoRecoverUntil) or 0)
                and not ragdollActive()
                and _G.StickyTPBusy ~= true and LP:GetAttribute("Stealing") ~= true
                and type(goToBrainrot) == "function"
                and typeof(target.position) == "Vector3" then
                pcall(goToBrainrot, target.position, tonumber(target.slot))
            end
            recovering = false
        end)
    end
    local function markHit()
        if wasStealing or os.clock() <= recentStealUntil then
            hitDuringSteal = true
            recoveryTarget = recoveryTarget or snapshotTarget()
            if not wasStealing then task.delay(0.15, beginRecovery) end
        end
    end
    connections[#connections + 1] = LP:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
        if ragdollActive() then markHit() end
    end)
    -- A sudden movement burst is also a drop/hit signal. Do not rely on
    -- ragdoll alone: some hits launch the character without entering that state.
    local RunService = game:GetService("RunService")
    local speedOverThreshold = false
    connections[#connections + 1] = RunService.Heartbeat:Connect(function()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local eligible = wasStealing or os.clock() <= recentStealUntil
        local velocity = root and root.AssemblyLinearVelocity or Vector3.zero
        local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
        local fast = eligible and root ~= nil and horizontalSpeed > 23.05
            and os.clock() >= (tonumber(_G.StickySuppressAutoRecoverUntil) or 0)
        if fast and not speedOverThreshold then
            markHit()
            task.delay(0.15, beginRecovery)
        end
        speedOverThreshold = fast == true
    end)
    connections[#connections + 1] = LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        local active = LP:GetAttribute("Stealing") == true
        if active then
            wasStealing = true
            recentStealUntil = os.clock() + 0.6
            recoveryTarget = snapshotTarget() or recoveryTarget
            hitDuringSteal = ragdollActive()
        elseif wasStealing then
            wasStealing = false
            recentStealUntil = os.clock() + 0.6
            task.delay(0.25, beginRecovery)
            task.delay(0.7, beginRecovery)
        end
    end)
    local stateConnection, healthConnection
    local function bindCharacter(character)
        if stateConnection then pcall(function() stateConnection:Disconnect() end) end
        if healthConnection then pcall(function() healthConnection:Disconnect() end) end
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local lastHealth = humanoid.Health
            healthConnection = humanoid.HealthChanged:Connect(function(health)
                if health < lastHealth then markHit() end
                lastHealth = health
            end)
            connections[#connections + 1] = healthConnection
            stateConnection = humanoid.StateChanged:Connect(function(_, state)
                if state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
                    or state == Enum.HumanoidStateType.Physics then markHit() end
            end)
            connections[#connections + 1] = stateConnection
        end
    end
    if LP.Character then bindCharacter(LP.Character) end
    connections[#connections + 1] = LP.CharacterAdded:Connect(bindCharacter)
    if wasStealing then recoveryTarget = snapshotTarget() or recoveryTarget end
end

do
    local RunService = game:GetService("RunService")
    local Players    = game:GetService("Players")
    local Workspace  = game:GetService("Workspace")
    local _wfConns, _wfActive = {}, false
    local function stopWalkFling()
        _wfActive = false
        for _, c in ipairs(_wfConns) do
            if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end) end
        end
        _wfConns = {}
    end
    local function startWalkFling()
        _wfActive = true
        local ch = LP.Character
        if not ch then return end
        local rr
        for _, o in pairs(Workspace.CurrentCamera:GetChildren()) do
            if o.Name == "UpperTorso" or o.Name == "Torso" then rr = o break end
        end
        if not rr then rr = ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso") end
        if not rr then
            for _, o in pairs(Workspace.CurrentCamera:GetChildren()) do
                if o.Name == "HumanoidRootPart" then rr = o break end
            end
            rr = rr or ch:FindFirstChild("HumanoidRootPart")
        end
        if not rr then return end
        table.insert(_wfConns, RunService.Stepped:Connect(function()
            if not _wfActive then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    for _, pt in ipairs(p.Character:GetChildren()) do
                        if pt:IsA("BasePart") and pt.CanCollide then pt.CanCollide = false end
                    end
                end
            end
        end))
        local co = coroutine.create(function()
            if _G.invisibleStealEnabled then rr.CFrame = rr.CFrame * CFrame.new(0, 3, 0) end
            while _wfActive do
                RunService.Heartbeat:Wait()
                if not rr or not rr.Parent then break end
                local v = rr.Velocity
                rr.Velocity = v * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if rr then rr.Velocity = v end
                RunService.Stepped:Wait()
                if rr then rr.Velocity = v + Vector3.new(0, 0.1, 0) end
            end
        end)
        coroutine.resume(co)
        table.insert(_wfConns, co)
    end
    _G.DropBrainrot = function()
        if _wfActive then return end
        startWalkFling()
        task.delay(0.4, stopWalkFling)
    end
    _G.stopWalkFling = stopWalkFling
end
_G.StickyDropBrainrot = _G.DropBrainrot

do
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()
	local carpetOn, carpetConn = false, nil
	if _G.StickyCarpetSpeedValue == nil then _G.StickyCarpetSpeedValue = 140 end
	local function setCarpetSpeed(on)
		carpetOn = on and true or false
		_G.StickyCarpetSpeed = carpetOn
		if carpetConn then pcall(function() carpetConn:Disconnect() end); carpetConn = nil end
		if type(_G.StickyPaintCarpetSpeed) == "function" then pcall(_G.StickyPaintCarpetSpeed) end
		if not carpetOn then return end
		pcall(function()
			if type(equipCarpet) == "function" then equipCarpet()
			elseif type(_G.StickyEquipCarpet) == "function" then _G.StickyEquipCarpet() end
		end)
		carpetConn = RunService.Heartbeat:Connect(function()
			local c = LP.Character
			if not c then return end
			local hum = c:FindFirstChildOfClass("Humanoid")
			local hrp = c:FindFirstChild("HumanoidRootPart")
			if not hum or not hrp then return end
			if LP:GetAttribute("Stealing") then
				setCarpetSpeed(false)
				return
			end
			local toolName = nil
			if type(equipCarpet) == "function" then
				local ok, n = pcall(equipCarpet)
				if ok then toolName = n end
			end
			local hasCarpet = false
			if toolName and c:FindFirstChild(toolName) then hasCarpet = true end
			if not hasCarpet then
				for _, n in ipairs({"Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings"}) do
					if c:FindFirstChild(n) then hasCarpet = true; break end
				end
			end
			if not hasCarpet then
				pcall(function()
					if type(_G.StickyEquipCarpet) == "function" then _G.StickyEquipCarpet()
					elseif type(equipCarpet) == "function" then equipCarpet() end
				end)
			end
			local md = hum.MoveDirection
			local spd = math.clamp(tonumber(_G.StickyCarpetSpeedValue) or 140, 20, 400)
			if md.Magnitude > 0 then
				hrp.AssemblyLinearVelocity = Vector3.new(md.X * spd, hrp.AssemblyLinearVelocity.Y, md.Z * spd)
			else
				hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
			end
		end)
	end
	_G.StickySetCarpetSpeed = setCarpetSpeed
	_G.toggleCarpetSpeed = function() setCarpetSpeed(not carpetOn) end
end

_G.__StickyResetBusy = false
_G.StickyInstaReset = function()
    local _now = os.clock()
    if _G.__StickyResetBusy
        and (_now - (tonumber(_G.__StickyResetAt) or 0)) < (tonumber(_G.StickyResetCooldown) or 1.0) then
        return
    end
    _G.__StickyResetBusy = true
    _G.__StickyResetBusy = true
    _G.__StickyResetAt = _now
    _G.StickyTPStop = true
    _G.StickyTPStop = true
    task.spawn(function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

        local _prevAntiDie = _G.AntiDieDisabled
        _G.AntiDieDisabled = true
        _G.StickyAntiDie = false
        _G.StickyStealHold = false
        _G.MeerkoStealHold = false

        pcall(function() if type(_G.StickyInvisStop) == "function" then _G.StickyInvisStop() end end)
        pcall(function() if type(_G.MeerkoInvisStop) == "function" then _G.MeerkoInvisStop() end end)
        _G.StickyInvisActive = false

        local _restored = false
        local function _restore()
            if _restored then return end
            _restored = true
            _G.AntiDieDisabled = _prevAntiDie
            _G.StickyAntiDie = true
            _G.__StickyResetBusy = false
            _G.__StickyResetBusy = false
            _G.StickyTPStop = false
            _G.StickyTPStop = false
        end
        local _conn
        _conn = LP.CharacterAdded:Connect(function(newChar)
            if _conn then _conn:Disconnect(); _conn = nil end
            task.defer(function()
                pcall(function() newChar:WaitForChild("Humanoid", 12) end)
                RunService.Heartbeat:Wait()
                _restore()
            end)
        end)
        task.delay(10, function()
            if _conn then _conn:Disconnect(); _conn = nil end
            _restore()
        end)

        local _origChar = LP.Character
        local _hum = _origChar and _origChar:FindFirstChildOfClass("Humanoid")
        if not _hum then
            _restore()
            return
        end

        for _ = 1, 6 do
            pcall(function()
                _hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                _hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                _hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                _hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
                _hum.BreakJointsOnDeath = true
                _hum.RequiresNeck = true
                _hum.Health = 0
            end)
            RunService.Heartbeat:Wait()
            if not _origChar.Parent or LP.Character ~= _origChar then break end
            if _hum.Health <= 0 then break end
        end
        pcall(function()
            if _origChar and _origChar.Parent and LP.Character == _origChar then
                _origChar:BreakJoints()
            end
        end)
        task.delay(tonumber(_G.StickyResetFallbackGap) or 0.45, function()
            if not _origChar or LP.Character ~= _origChar then return end
            local h = _origChar:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then
                pcall(function()
                    h.Health = 0
                    _origChar:BreakJoints()
                end)
            end
        end)
    end)
end
_G.StickyInstantReset = _G.StickyInstaReset
_G.instantReset = _G.StickyInstaReset
_G.MeerkoInstaReset = _G.StickyInstaReset

do
	local UIS = game:GetService("UserInputService")
	if not _G.__StickyBindsWired then
		_G.__StickyBindsWired = true
		UIS.InputBegan:Connect(function(input, gp)
			if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
			if _G.StickyCapturingKey or _G.StickyBindListening then return end
			if gp then
				local box
				pcall(function() box = UIS:GetFocusedTextBox() end)
				if box then return end
			end
			local name = input.KeyCode.Name
			local function keyOf(g, d)
				local v = _G[g]
				if type(v) ~= "string" or v == "" then return d end
				return v
			end
			if name == keyOf("StickyResetKeyName", "X") then
				task.spawn(function()
					local fn = _G.StickyInstantReset or _G.StickyInstaReset
					if type(fn) == "function" then pcall(fn) end
				end)
				return
			end
			if name == keyOf("StickyDropKeyName", "B") then
				task.spawn(function()
					local fn = _G.StickyDropBrainrot or _G.DropBrainrot
					if type(fn) == "function" then pcall(fn) end
				end)
				return
			end
			if name == keyOf("StickyInvisKeyName", "U") then
				task.spawn(function()
					if type(_G.StickyInvisToggle) == "function" then pcall(_G.StickyInvisToggle)
					elseif type(_G.StickyInvisStart) == "function" then
						if _G.StickyInvisActive then pcall(_G.StickyInvisStop) else pcall(_G.StickyInvisStart) end
					end
				end)
				return
			end
			if name == keyOf("StickyCarpetSpeedKeyName", "Q") then
				task.spawn(function()
					if type(_G.toggleCarpetSpeed) == "function" then pcall(_G.toggleCarpetSpeed)
					elseif type(_G.StickySetCarpetSpeed) == "function" then
						pcall(_G.StickySetCarpetSpeed, not (_G.StickyCarpetSpeed == true))
					end
				end)
				return
			end
			if name == keyOf("StickyCloneKeyName", "V") then
				task.spawn(function()
					if type(_G.StickyDoClone) == "function" then pcall(_G.StickyDoClone)
					elseif type(_G.StickyInstantClone) == "function" then pcall(_G.StickyInstantClone)
					elseif type(doClone) == "function" then pcall(doClone) end
				end)
				return
			end
			if name == keyOf("StickyStealPrioKey", "P") then
				_G.StickyStealMode = "priority"
				if type(_G.StickyRepaintStealMode) == "function" then pcall(_G.StickyRepaintStealMode) end
				return
			end
			if name == keyOf("StickyStealNearKey", "F") then
				_G.StickyStealMode = "nearest"
				if type(_G.StickyRepaintStealMode) == "function" then pcall(_G.StickyRepaintStealMode) end
				return
			end
		end)
	end
end

_G.StickyAntiDie = true
_G.AntiDieDisabled = false

do
    local Workspace = game:GetService("Workspace")
    local _shopParts = setmetatable({}, { __mode = "k" })
    local _shopModels = {}
    local function _isShop(m)
        if not m or not m.Parent then return false end
        local n = tostring(m.Name or ""):lower()
        return n:find("shop", 1, true) ~= nil
    end
    local function _declawShop(m)
        pcall(function()
            for _, d in ipairs(m:GetDescendants()) do
                if d:IsA("BasePart") and d.CanCollide then
                    _shopParts[d] = true
                    d.CanCollide = false
                end
            end
        end)
    end
    local function _track(m)
        if not m:IsA("Model") and not m:IsA("Folder") then return end
        if not _isShop(m) then return end
        _shopModels[#_shopModels + 1] = m
        _declawShop(m)
        m.DescendantAdded:Connect(function(d)
            if d:IsA("BasePart") then
                task.defer(function()
                    pcall(function()
                        if d.CanCollide then
                            _shopParts[d] = true
                            d.CanCollide = false
                        end
                    end)
                end)
            end
        end)
    end
    task.spawn(function()
        pcall(function()
            Workspace.DescendantAdded:Connect(function(c) pcall(_track, c) end)
        end)
        pcall(function()
            for _, d in ipairs(Workspace:GetDescendants()) do
                if (d:IsA("Model") or d:IsA("Folder")) and _isShop(d) then
                    _track(d)
                end
            end
        end)
        while true do
            for i = #_shopModels, 1, -1 do
                local m = _shopModels[i]
                if m and m.Parent then
                    _declawShop(m)
                else
                    table.remove(_shopModels, i)
                end
            end
            task.wait(0.35)
        end
    end)
end

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

    task.spawn(function()
        local function ownCloneName()
            return tostring(LP.UserId) .. "_Clone"
        end
        local function isOtherClone(inst)
            if not inst:IsA("Model") then return false end
            local n = inst.Name
            if type(n) ~= "string" or not string.find(n, "_Clone", 1, true) then return false end
            return n ~= ownCloneName()
        end
        local function disableCollide(root)
            if not root or not root.Parent then return end
            for _, d in ipairs(root:GetDescendants()) do
                if d:IsA("BasePart") and d.CanCollide then
                    pcall(function() d.CanCollide = false end)
                end
            end
        end
        while true do
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    disableCollide(p.Character)
                    RunService.Heartbeat:Wait()
                end
            end
            for _, child in ipairs(Workspace:GetChildren()) do
                if isOtherClone(child) then
                    disableCollide(child)
                    RunService.Heartbeat:Wait()
                end
            end
            task.wait(tonumber(_G.StickyNoclipInterval) or 0.4)
        end
    end)

    if _G.StickyNoclipMachines == nil then _G.StickyNoclipMachines = true end
    task.spawn(function()
        local NOCLIP_KW = _G.StickyNoclipKW or { "truck", "fuse", "craft", "incubator", "cupid", "soccerball", "shop", "machine", "conveyor" }
        local AVOID_KW  = _G.StickyNoclipAvoidKW or { "trade","portal","wheel","cyber","spin","roulette","summer","admin","plot","board","sentry","laser","base" }
        local FORCE_KW  = _G.StickyNoclipForceKW or { "summer base", "summerfuse" }
        local _clsMemo, _clsMemoN = {}, 0
        local function classify(name)
            local raw = name or ""
            local hit = _clsMemo[raw]
            if hit ~= nil then
                if hit == false then return nil end
                return hit
            end
            local n = raw:lower()
            local res = nil
            for _, k in ipairs(FORCE_KW) do
                if n:find(k, 1, true) then res = "noclip"; break end
            end
            if res == nil then
                for _, k in ipairs(AVOID_KW) do
                    if n:find(k, 1, true) then res = "avoid"; break end
                end
            end
            if res == nil then
                for _, k in ipairs(NOCLIP_KW) do
                    if n:find(k, 1, true) then res = "noclip"; break end
                end
            end
            if _clsMemoN >= (tonumber(_G.StickyClsMemoMax) or 8000) then
                _clsMemo, _clsMemoN = {}, 0
            end
            _clsMemo[raw] = (res == nil) and false or res
            _clsMemoN = _clsMemoN + 1
            return res
        end
        local function chainClassify(p)
            local chain, a = {}, p
            while a and a ~= Workspace do
                table.insert(chain, 1, a)
                a = a.Parent
            end
            if not a then return nil end
            for _, node in ipairs(chain) do
                if node:FindFirstChildOfClass("Humanoid") then return nil end
                local cls = classify(node.Name)
                if cls then return cls end
            end
            return nil
        end
        local _targets, _lastDiscover = {}, 0
        local _ncPending, _ncScheduled = {}, false
        local function ncDrain()
            _ncScheduled = false
            local batch = _ncPending
            _ncPending = {}
            local n = 0
            for p in pairs(batch) do
                if _G.StickyNoclipMachines ~= false and p.Parent and p.Anchored and chainClassify(p) == "noclip" then
                    pcall(function()
                        p.CanCollide = false
                        p.CanQuery = false
                    end)
                end
                n = n + 1
                if n % (tonumber(_G.StickyNoclipDrainBatch) or 150) == 0 then
                    RunService.Heartbeat:Wait()
                end
            end
        end
        pcall(function()
            Workspace.DescendantAdded:Connect(function(p)
                if not p:IsA("BasePart") then return end
                _ncPending[p] = true
                if not _ncScheduled then
                    _ncScheduled = true
                    task.delay(0.15, ncDrain)
                end
            end)
        end)
        local function discover()
            local out = {}
            local wn = 0
            local function walk(container, depth)
                for _, c in ipairs(container:GetChildren()) do
                    if c:IsA("Model") or c:IsA("Folder") or c:IsA("BasePart") then
                        if not c:FindFirstChildOfClass("Humanoid") then
                            local cls = classify(c.Name)
                            if cls == "avoid" then
                            elseif cls == "noclip" then
                                out[#out + 1] = c
                            elseif depth < (tonumber(_G.StickyNoclipDepth) or 5) then
                                walk(c, depth + 1)
                            end
                        end
                    end
                    wn = wn + 1
                    if wn % (tonumber(_G.StickyNoclipWalkBatch) or 200) == 0 then
                        RunService.Heartbeat:Wait()
                    end
                end
            end
            pcall(walk, Workspace, 0)
            _targets = out
        end
        local boot = tick()
        while true do
            if _G.StickyNoclipMachines ~= false then
                local every = (tick() - boot < 12) and 1 or (tonumber(_G.StickyNoclipDiscoverEvery) or 3)
                if tick() - _lastDiscover > every then
                    _lastDiscover = tick()
                    discover()
                end
                for _, m in ipairs(_targets) do
                    if m.Parent then
                        if m:IsA("BasePart") then
                            if m.CanCollide then pcall(function() m.CanCollide = false end) end
                            if m.CanQuery then pcall(function() m.CanQuery = false end) end
                        else
                            for _, p in ipairs(m:GetDescendants()) do
                                if p:IsA("BasePart") then
                                    if p.CanCollide then pcall(function() p.CanCollide = false end) end
                                    if p.CanQuery then pcall(function() p.CanQuery = false end) end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(tonumber(_G.StickyNoclipApplyEvery) or 0.3)
        end
    end)
end


-- [[ LOWBALL QUALITY-OF-LIFE PATCH: FOV INIT, FPS, RESET, STEAL SPEED, INPUT HUD ]]
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local LP = Players.LocalPlayer
    if not LP then return end

    -- FOV: re-apply on startup, camera replacement, and respawn so it doesn't
    -- require toggling the setting off/on after the script loads.
    task.spawn(function()
        local lastCamera
        local function applySavedFov()
            local cam = Workspace.CurrentCamera
            if not cam then return end
            lastCamera = cam
            if _G.StickyFovEnabled == true then
                local value = math.clamp(tonumber(_G.StickyFovValue) or 70, 1, 120)
                pcall(function() cam.FieldOfView = value end)
            end
        end
        Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            task.defer(applySavedFov)
        end)
        LP.CharacterAdded:Connect(function()
            task.delay(0.35, applySavedFov)
        end)
        task.wait(1)
        applySavedFov()
        while task.wait(0.5) do
            if _G.StickyFovEnabled == true and Workspace.CurrentCamera ~= lastCamera then
                applySavedFov()
            elseif _G.StickyFovEnabled == true then
                applySavedFov()
            end
        end
    end)

    -- Separate compact controls; use executor UI parent when available.
    local parent
    pcall(function() if type(gethui) == "function" then parent = gethui() end end)
    parent = parent or game:GetService("CoreGui")
    pcall(function()
        local old = parent:FindFirstChild("StickyQoLPatch")
        if old then old:Destroy() end
    end)
    local gui = Instance.new("ScreenGui")
    gui.Name = "StickyQoLPatch"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 1000000
    pcall(function() gui.Parent = parent end)
    if not gui.Parent then
        pcall(function() gui.Parent = LP:WaitForChild("PlayerGui") end)
    end

    local function corner(obj, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 7)
        c.Parent = obj
        return c
    end
    local function stroke(obj, color)
        local st = Instance.new("UIStroke")
        st.Color = color or Color3.fromRGB(65, 65, 65)
        st.Thickness = 1
        st.Parent = obj
        return st
    end
    local function makeButton(name, text, pos, size)
        local b = Instance.new("TextButton")
        b.Name = name
        b.Text = text
        b.Position = pos
        b.Size = size
        b.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        b.TextColor3 = Color3.fromRGB(245, 245, 245)
        b.Font = Enum.Font.GothamSemibold
        b.TextSize = 12
        b.BorderSizePixel = 0
        b.AutoButtonColor = true
        b.Active = true
        b.Parent = gui
        corner(b, 7)
        stroke(b)
        return b
    end

    -- Minimal movable reset button for touch and mouse.
    local reset = makeButton("QuickReset", "RESET", UDim2.new(1, -94, 0.68, 0), UDim2.fromOffset(78, 32))
    reset.TextSize = 11
    local resetKey = Enum.KeyCode.X
    local function instaReset()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        -- Give manual reset priority over auto-recovery so it cannot immediately TP back.
        _G.StickySuppressAutoRecoverUntil = os.clock() + 2.5
        _G.StickyAutoRecoverHitPending = false
        pcall(function()
            hrp.AssemblyAngularVelocity = Vector3.zero
            local v = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = Vector3.new(v.X, 10000000, v.Z)
        end)
    end
    reset.MouseButton1Click:Connect(instaReset)
    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == resetKey then
            task.spawn(instaReset)
        end
    end)

    -- Make RESET independently draggable on touch/mouse.
    do
        local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
        reset.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging, dragStart, startPos = true, input.Position, reset.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        reset.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not dragging or input ~= dragInput or not dragStart or not startPos then return end
            local delta = input.Position - dragStart
            reset.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end)
    end

    -- Toggle controls; speed is applied only during the same Stealing attribute
    -- state used by the auto-invisible-on-steal feature.
    local fpsEnabled = _G.StickyFpsOptimizer == true
    local speedEnabled = _G.StickyStealVelocityEnabled == true
    local fpsButton = makeButton("FPSBoostToggle", "FPS BOOST: " .. (fpsEnabled and "ON" or "OFF"),
        UDim2.new(1, -142, 0, 92), UDim2.fromOffset(126, 30))
    local speedButton = makeButton("StealSpeedToggle", "STEAL SPEED: " .. (speedEnabled and "ON" or "OFF"),
        UDim2.new(1, -142, 0, 128), UDim2.fromOffset(126, 30))
    local function paintToggle(button, label, enabled)
        button.Text = label .. (enabled and ": ON" or ": OFF")
        button.BackgroundColor3 = enabled and Color3.fromRGB(35, 80, 55) or Color3.fromRGB(24, 24, 24)
    end
    paintToggle(fpsButton, "FPS BOOST", fpsEnabled)
    paintToggle(speedButton, "STEAL SPEED", speedEnabled)

    -- Extra reversible graphics reductions for objects added after the toggle.
    local savedObjects = setmetatable({}, {__mode = "k"})
    local optimizerConnection
    local function applyObjectOptimization(obj)
        if not obj or not obj.Parent then return end
        if obj:IsA("BasePart") then
            if savedObjects[obj] == nil then savedObjects[obj] = {kind="part", material=obj.Material, cast=obj.CastShadow} end
            pcall(function() obj.CastShadow = false end)
            pcall(function() obj.Material = Enum.Material.Plastic end)
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            if savedObjects[obj] == nil then savedObjects[obj] = {kind="enabled", enabled=obj.Enabled} end
            pcall(function() obj.Enabled = false end)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            if savedObjects[obj] == nil then savedObjects[obj] = {kind="transparency", transparency=obj.Transparency} end
            pcall(function() obj.Transparency = math.max(obj.Transparency, 0.5) end)
        end
    end
    local function setFps(enabled)
        fpsEnabled = enabled == true
        if type(_G.StickySetFpsOptimizer) == "function" then
            pcall(_G.StickySetFpsOptimizer, fpsEnabled)
        else
            _G.StickyFpsOptimizer = fpsEnabled
        end
        if fpsEnabled then
            pcall(function() Lighting.GlobalShadows = false end)
            for _, obj in ipairs(Workspace:GetDescendants()) do applyObjectOptimization(obj) end
            if optimizerConnection then optimizerConnection:Disconnect() end
            optimizerConnection = Workspace.DescendantAdded:Connect(function(obj)
                if fpsEnabled then task.defer(applyObjectOptimization, obj) end
            end)
        else
            if optimizerConnection then optimizerConnection:Disconnect(); optimizerConnection = nil end
            for obj, saved in pairs(savedObjects) do
                if obj and obj.Parent then
                    pcall(function()
                        if saved.kind == "part" then obj.Material = saved.material; obj.CastShadow = saved.cast
                        elseif saved.kind == "enabled" then obj.Enabled = saved.enabled
                        elseif saved.kind == "transparency" then obj.Transparency = saved.transparency end
                    end)
                end
                savedObjects[obj] = nil
            end
            -- Existing optimizer restores the original quality/shadow/effects it captured.
            if type(_G.StickySetFpsOptimizer) == "function" then pcall(_G.StickySetFpsOptimizer, false) end
        end
        paintToggle(fpsButton, "FPS BOOST", fpsEnabled)
    end
    fpsButton.MouseButton1Click:Connect(function() setFps(not fpsEnabled) end)

    local speedConn
    local function setStealSpeed(enabled)
        speedEnabled = enabled == true
        _G.StickyStealVelocityEnabled = speedEnabled
        paintToggle(speedButton, "STEAL SPEED", speedEnabled)
        if speedConn then speedConn:Disconnect(); speedConn = nil end
        if not speedEnabled then return end
        local accumulator = 0
        speedConn = RunService.Heartbeat:Connect(function(dt)
            accumulator = accumulator + dt
            if accumulator < 0.08 then return end
            accumulator = 0
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp or LP:GetAttribute("Stealing") ~= true then return end
            local dir = hum.MoveDirection
            -- Do not invent a forward direction when the player is idle; that caused auto-movement.
            if dir.Magnitude < 0.05 then return end
            dir = Vector3.new(dir.X, 0, dir.Z)
            if dir.Magnitude < 0.05 then return end
            dir = dir.Unit
            local current = hrp.AssemblyLinearVelocity
            -- Set horizontal magnitude to exactly 23 studs/s; preserve vertical velocity.
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.new(dir.X * 23, current.Y, dir.Z * 23)
            end)
        end)
    end
    speedButton.MouseButton1Click:Connect(function() setStealSpeed(not speedEnabled) end)

    -- PC-only keyboard/mouse overlay. Mobile touch devices do not get this HUD.
    if not UIS.TouchEnabled then
        local overlay = Instance.new("Frame")
        overlay.Name = "KeyboardMouseOverlay"
        overlay.Position = UDim2.new(0, 12, 1, -88)
        overlay.Size = UDim2.fromOffset(220, 72)
        overlay.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
        overlay.BackgroundTransparency = 0.15
        overlay.BorderSizePixel = 0
        overlay.Parent = gui
        corner(overlay, 8)
        stroke(overlay, Color3.fromRGB(60, 60, 60))
        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Position = UDim2.fromOffset(8, 4)
        title.Size = UDim2.new(1, -16, 0, 16)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 10
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextColor3 = Color3.fromRGB(220, 220, 220)
        title.Text = "INPUT"
        title.Parent = overlay
        local keyLabel = Instance.new("TextLabel")
        keyLabel.BackgroundTransparency = 1
        keyLabel.Position = UDim2.fromOffset(8, 22)
        keyLabel.Size = UDim2.new(1, -16, 0, 20)
        keyLabel.Font = Enum.Font.GothamBold
        keyLabel.TextSize = 13
        keyLabel.TextXAlignment = Enum.TextXAlignment.Left
        keyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyLabel.Text = "W  A  S  D"
        keyLabel.Parent = overlay
        local mouseLabel = Instance.new("TextLabel")
        mouseLabel.BackgroundTransparency = 1
        mouseLabel.Position = UDim2.fromOffset(8, 44)
        mouseLabel.Size = UDim2.new(1, -16, 0, 18)
        mouseLabel.Font = Enum.Font.Gotham
        mouseLabel.TextSize = 10
        mouseLabel.TextXAlignment = Enum.TextXAlignment.Left
        mouseLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        mouseLabel.Text = "Mouse: —"
        mouseLabel.Parent = overlay
        local held = {}
        local function paintKeys()
            local parts = {}
            for _, k in ipairs({"W","A","S","D","SPACE","SHIFT","CTRL"}) do
                if held[k] then parts[#parts+1] = k end
            end
            keyLabel.Text = #parts > 0 and table.concat(parts, "   ") or "—"
        end
        UIS.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local name = input.KeyCode.Name
                if name == "W" or name == "A" or name == "S" or name == "D" or name == "Space" or name == "LeftShift" or name == "RightShift" or name == "LeftControl" or name == "RightControl" then
                    local mapped = ({Space="SPACE", LeftShift="SHIFT", RightShift="SHIFT", LeftControl="CTRL", RightControl="CTRL"})[name] or name
                    held[mapped] = true
                    paintKeys()
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                mouseLabel.Text = "Mouse: LEFT"
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                mouseLabel.Text = "Mouse: RIGHT"
            elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                mouseLabel.Text = "Mouse: MIDDLE"
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local name = input.KeyCode.Name
                local mapped = ({Space="SPACE", LeftShift="SHIFT", RightShift="SHIFT", LeftControl="CTRL", RightControl="CTRL"})[name] or name
                held[mapped] = nil
                paintKeys()
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
                mouseLabel.Text = "Mouse: —"
            end
        end)
    end

    -- Respect a previously enabled setting when the UI is rebuilt.
    if fpsEnabled then task.defer(setFps, true) end
    if speedEnabled then task.defer(setStealSpeed, true) end
end
