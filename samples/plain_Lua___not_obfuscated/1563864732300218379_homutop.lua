if game.GameId == 10253235584 then
	local function yu(name)
		if name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
			return true
		end
		if name:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x$") then
			return true
		end
		return false
	end
	local function ri()
		for _, service in ipairs(game:GetChildren()) do
			local ok, children = pcall(function() return service:GetChildren() end)
			if ok then
				for _, child in ipairs(children) do
					if yu(child.Name) then
						child:Destroy()
					end
				end
			end
		end
	end
	ri()
end
if game.GameId == 10759415852 or game.GameId == 1831550657 then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()
	task.wait(3)
end
local Yuri = {}
function Yuri.new(Opts)
	local Svc = {
		Ts = Opts.TweenService,
		Txs = Opts.TextService,
		Uis = Opts.UserInputService,
		Cg = Opts.CoreGui,
		Rs = Opts.RunService,
	}
	local Ext = {
		Cfg = Opts.config,
		OnChkKey = Opts.onCheckKey,
		OnCls = Opts.onClose,
		SKey = Opts.scriptKey,
	}
	local Ast = {
		Dir = Opts.AssetDir or "yuri/Assets",
		Base = Opts.AssetBase or "https://raw.githubusercontent.com/iLove-yuri/debug/main/NewUI/",
	}
	local function MkFldr(P)
		if not isfolder(P) then makefolder(P) end
	end
	local function GetAsset(N)
		local P = Ast.Dir .. "/" .. N
		if not isfile(P) then
			local Ok, Rs = pcall(request, { Url = Ast.Base .. N, Method = "GET" })
			if Ok and Rs and Rs.Body and #Rs.Body > 0 then
				writefile(P, Rs.Body)
			end
		end
		if not isfile(P) then
			return ""
		end
		local Ok, Res = pcall(getcustomasset, P)
		if Ok and Res then
			return Res
		end
		return ""
	end
	MkFldr("yuri")
	MkFldr(Ast.Dir)
	local Img = {
		Pnl = GetAsset("UI.png"),
		Cnc = GetAsset("Cancel.png"),
		Hmu = GetAsset("Homu.png"),
		Mdo = GetAsset("Mado.png"),
	}
	local Mob = Svc.Uis.TouchEnabled and not Svc.Uis.KeyboardEnabled
	local Fnt = {
		Face = Enum.Font.Code,
		Size = Mob and 14 or 16,
	}
	local Lay = {
		Pad = 8,
		Gap = 6,
		BotPad = 8,
		WGrid = Mob and 333 or 453,
		HKey = Mob and 20 or 26,
		WCheck = Mob and 115 or 135,
		HCheck = Mob and 15 or 18,
		GapCheck = Mob and 60 or 80,
		HTab = Mob and 23 or 29,
	}
	Lay.WPill = Lay.WGrid - Lay.Pad * 2
	Lay.HGrid = Lay.Pad + Lay.HKey + Lay.Gap
				+ Lay.HCheck + Lay.GapCheck
				+ Lay.HTab + Lay.BotPad
	local Thm = {
		Text = Color3.fromRGB(0, 0, 0),
		TextHover = Color3.fromRGB(255, 255, 255),
		Dim = Color3.fromRGB(120, 95, 60),
		Accent = Color3.fromRGB(235, 205, 150),
		Pink = Color3.fromRGB(255, 105, 180),
		PillBg = Color3.fromRGB(210, 210, 210),
		PillBorder = Color3.fromRGB(170, 170, 170),
		PillBorderFocus = Color3.fromRGB(100, 100, 100),
		TipBg = Color3.fromRGB(20, 20, 20),
		TipBorder = Color3.fromRGB(50, 50, 50),
		TabBar = Color3.fromRGB(180, 180, 180),
		TabIdle = Color3.fromRGB(195, 195, 195),
		TabHover = Color3.fromRGB(210, 210, 210),
		TabActive = Color3.fromRGB(225, 225, 225),
		TabText = Color3.fromRGB(40, 40, 40),
		TabBorder = Color3.fromRGB(155, 155, 155),
		ToastBg = Color3.fromRGB(20, 20, 20),
		ToastBorder = Color3.fromRGB(50, 50, 50),
		ToastHueSat = 0.85,
		ToastHueVal = 0.25,
	}
	if Svc.Cg:FindFirstChild("iLoveyuri") then
		Svc.Cg.iLoveyuri:Destroy()
	end
	local Sg = Instance.new("ScreenGui")
	Sg.Name             = "iLoveyuri"
	Sg.ResetOnSpawn     = false
	Sg.ZIndexBehavior   = Enum.ZIndexBehavior.Global
	Sg.DisplayOrder     = 1
	Sg.IgnoreGuiInset   = true
	Sg.Parent           = Svc.Cg
	local Wr = Instance.new("Frame")
	Wr.BackgroundTransparency = 1
	Wr.AnchorPoint            = Vector2.new(0.5, 0.5)
	Wr.Size                   = UDim2.fromOffset(Lay.WGrid, Lay.HGrid)
	Wr.Position               = UDim2.fromScale(0.5, 0.5)
	Wr.Parent                 = Sg
	local Rt = Instance.new("Frame")
	Rt.Name               = "Root"
	Rt.BackgroundTransparency = 1
	Rt.BorderSizePixel    = 0
	Rt.Size               = UDim2.fromOffset(Lay.WGrid, Lay.HGrid)
	Rt.Position           = UDim2.fromOffset(0, 0)
	Rt.ClipsDescendants   = true
	Rt.ZIndex             = 1
	Rt.Parent             = Wr
	local Rbg = Instance.new("ImageLabel")
	Rbg.Name               = "Background"
	Rbg.Image              = Img.Pnl
	Rbg.ImageRectOffset    = Vector2.new(23, 22)
	Rbg.ImageRectSize      = Vector2.new(1530, 1241)
	Rbg.ScaleType          = Enum.ScaleType.Stretch
	Rbg.BackgroundTransparency = 1
	Rbg.BorderSizePixel    = 0
	Rbg.Size               = UDim2.fromScale(1, 1)
	Rbg.ZIndex             = 1
	Rbg.Parent             = Rt
	local Cb = Instance.new("ImageButton")
	Cb.Image                = Img.Cnc
	Cb.ScaleType            = Enum.ScaleType.Fit
	Cb.ImageColor3          = Thm.Dim
	Cb.BackgroundTransparency = 1
	Cb.AutoButtonColor      = false
	Cb.AnchorPoint          = Vector2.new(1, 0)
	Cb.Size                 = UDim2.fromOffset(20, 20)
	Cb.Position             = UDim2.new(1, 0, 0, 0)
	Cb.ZIndex               = 5
	Cb.Parent               = Rt
	local function MakePill(Prnt, YOff, W, H, XOff)
		local Pl = Instance.new("Frame")
		Pl.BackgroundColor3   = Thm.PillBg
		Pl.BorderColor3       = Thm.PillBorder
		Pl.BorderSizePixel    = 1
		Pl.Size               = UDim2.fromOffset(W, H)
		Pl.Position           = UDim2.fromOffset(XOff or Lay.Pad, YOff)
		Pl.ClipsDescendants   = true
		Pl.ZIndex             = 6
		Pl.Parent             = Prnt
		return Pl
	end
	local function WrapText(TObj, MaxTSz, MinTSz)
		TObj.TextWrapped = false
		TObj.TextScaled  = true
		local Cn = Instance.new("UITextSizeConstraint")
		Cn.MaxTextSize = MaxTSz
		Cn.MinTextSize = MinTSz or 8
		Cn.Parent      = TObj
		return Cn
	end
	Lay.YKey = Lay.Pad
	local Kc = MakePill(Rt, Lay.YKey, Lay.WPill, Lay.HKey)
	local Ktb = Instance.new("TextBox")
	Lay.YTop = Lay.YKey + Lay.HKey + Lay.Gap
	Lay.YTabs = Lay.YTop + Lay.HCheck + Lay.GapCheck
	Ktb.PlaceholderText  = "Paste your key here..."
	Ktb.Text             = ""
	Ktb.Font             = Fnt.Face
	Ktb.TextSize         = Fnt.Size - 1
	Ktb.TextColor3       = Thm.Text
	Ktb.PlaceholderColor3 = Thm.Text
	Ktb.BackgroundTransparency = 1
	Ktb.Size             = UDim2.fromScale(1, 1)
	Ktb.Position         = UDim2.fromOffset(0, 0)
	Ktb.ClearTextOnFocus = false
	Ktb.TextXAlignment   = Enum.TextXAlignment.Center
	Ktb.ZIndex           = 7
	Ktb.Parent           = Kc
	WrapText(Ktb, Fnt.Size - 1)
	Ktb.Focused:Connect(function()
		Svc.Ts:Create(Kc, TweenInfo.new(0.15), { BorderColor3 = Thm.PillBorderFocus }):Play()
	end)
	Ktb.FocusLost:Connect(function()
		Svc.Ts:Create(Kc, TweenInfo.new(0.15), { BorderColor3 = Thm.PillBorder }):Play()
	end)
	local function MakeButton(Bopts)
		local Txt      = Bopts.text
		local XOff     = Bopts.xOff or Lay.Pad
		local YOff     = Bopts.yOff
		local W        = Bopts.w
		local H        = Bopts.h
		local TClr     = Bopts.textColor or Thm.Text
		local MaxTSz   = Bopts.maxTextSize or Fnt.Size
		local TSz      = Bopts.textSize or Fnt.Size
		local Pl = MakePill(Rt, YOff, W, H, XOff)
		local B = Instance.new("TextButton")
		B.Text             = Txt
		B.Font             = Fnt.Face
		B.TextSize         = TSz
		B.TextColor3       = TClr
		B.BackgroundTransparency = 1
		B.AutoButtonColor  = false
		B.Size             = UDim2.fromScale(1, 1)
		B.TextXAlignment   = Enum.TextXAlignment.Center
		B.TextYAlignment   = Enum.TextYAlignment.Center
		B.ZIndex           = 7
		B.Parent           = Pl
		WrapText(B, MaxTSz)
		local Bp = Instance.new("UIPadding")
		Bp.PaddingLeft   = UDim.new(0, 6)
		Bp.PaddingRight  = UDim.new(0, 6)
		Bp.PaddingTop    = UDim.new(0, 3)
		Bp.PaddingBottom = UDim.new(0, 3)
		Bp.Parent        = B
		B.MouseEnter:Connect(function()
			Svc.Ts:Create(B, TweenInfo.new(0.15), { TextColor3 = Thm.TextHover }):Play()
		end)
		B.MouseLeave:Connect(function()
			Svc.Ts:Create(B, TweenInfo.new(0.15), { TextColor3 = TClr }):Play()
		end)
		return B, Pl
	end
	local function AddTT(HoverInst, InfoStr)
		local Tt = Instance.new("Frame")
		Tt.BackgroundColor3 = Thm.TipBg
		Tt.BorderColor3     = Thm.TipBorder
		Tt.BorderSizePixel  = 1
		Tt.ZIndex           = 100
		Tt.Visible          = false
		Tt.Parent           = Sg
		local Lb = Instance.new("TextLabel")
		Lb.BackgroundTransparency = 1
		Lb.Font           = Fnt.Face
		Lb.TextSize        = 13
		Lb.TextColor3      = Thm.Pink
		Lb.TextXAlignment  = Enum.TextXAlignment.Left
		Lb.Position        = UDim2.fromOffset(3, 1)
		Lb.Text            = InfoStr
		Lb.ZIndex          = Tt.ZIndex + 1
		Lb.Parent          = Tt
		local Ok, Res = pcall(function()
			return Svc.Txs:GetTextSize(InfoStr, 13, Fnt.Face, Vector2.new(1000, 100))
		end)
		local TxW = (Ok and Res and Res.X) or (#InfoStr * 7)
		local TxH = (Ok and Res and Res.Y) or 13
		Tt.Size = UDim2.fromOffset(TxW + 5, TxH + 4)
		Lb.Size = UDim2.fromOffset(TxW, TxH)
		local Hover = false
		HoverInst.MouseEnter:Connect(function()
			Hover = true
			local Mp = Svc.Uis:GetMouseLocation()
			Tt.Position = UDim2.fromOffset(Mp.X + 15, Mp.Y + 12)
			Tt.Visible  = true
			while Hover do
				Svc.Rs.Heartbeat:Wait()
				local P = Svc.Uis:GetMouseLocation()
				Tt.Position = UDim2.fromOffset(P.X + 15, P.Y + 12)
			end
			Tt.Visible = false
		end)
		HoverInst.MouseLeave:Connect(function()
			Hover = false
			Tt.Visible = false
		end)
		return Tt
	end
	local Kb = MakeButton({
		text      = "Check Key",
		xOff      = Lay.Pad + math.floor((Lay.WPill - Lay.WCheck) / 2),
		textSize  = 99,
		yOff      = Lay.YTop,
		w         = Lay.WCheck,
		h         = Lay.HCheck,
	})
	local Tr = Instance.new("Frame")
	Tr.BackgroundColor3  = Thm.TabBar
	Tr.BorderColor3      = Thm.TabBorder
	Tr.BorderSizePixel   = 1
	Tr.Size              = UDim2.fromOffset(Lay.WPill, Lay.HTab)
	Tr.Position          = UDim2.fromOffset(Lay.Pad, Lay.YTabs)
	Tr.ClipsDescendants  = false
	Tr.ZIndex            = 6
	Tr.Parent            = Rt
	Lay.CharH = Lay.GapCheck - 4
	Lay.CharW = Lay.CharH
	Lay.CharY = Lay.YTabs - Lay.CharH - 2
	local Hi = Instance.new("ImageLabel")
	Hi.Image                = Img.Hmu
	Hi.ScaleType            = Enum.ScaleType.Fit
	Hi.BackgroundTransparency = 1
	Hi.Size                 = UDim2.fromOffset(Lay.CharW, Lay.CharH)
	Hi.Position             = UDim2.fromOffset(Lay.Pad, Lay.CharY)
	Hi.ZIndex               = 6
	Hi.Parent               = Rt
	local Hsp = Hi.Position
	local function Jump(Chr, Sp)
		return function()
			local JH = 20
			local JD = 0.6
			Svc.Ts:Create(
				Chr,
				TweenInfo.new(JD / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Position = UDim2.new(Sp.X.Scale, Sp.X.Offset, Sp.Y.Scale, Sp.Y.Offset - JH) }
			):Play()
			task.wait(JD / 2)
			Svc.Ts:Create(
				Chr,
				TweenInfo.new(JD / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{ Position = Sp }
			):Play()
		end
	end
	Hi.InputBegan:Connect(function(Inp)
		if Inp.UserInputType == Enum.UserInputType.MouseButton1
		or Inp.UserInputType == Enum.UserInputType.Touch then
			Jump(Hi, Hsp)()
		end
	end)
	local Mi = Instance.new("ImageLabel")
	Mi.Image                = Img.Mdo
	Mi.ScaleType            = Enum.ScaleType.Fit
	Mi.BackgroundTransparency = 1
	Mi.Size                 = UDim2.fromOffset(Lay.CharW, Lay.CharH)
	Mi.Position             = UDim2.fromOffset(Lay.Pad + Lay.CharW - 15, Lay.CharY + 3)
	Mi.ZIndex               = 6
	Mi.Parent               = Rt
	local Msp = Mi.Position
	Mi.InputBegan:Connect(function(Inp)
		if Inp.UserInputType == Enum.UserInputType.MouseButton1
		or Inp.UserInputType == Enum.UserInputType.Touch then
			Jump(Mi, Msp)()
		end
	end)
	local Tl = Instance.new("UIListLayout")
	Tl.FillDirection     = Enum.FillDirection.Horizontal
	Tl.HorizontalAlignment = Enum.HorizontalAlignment.Left
	Tl.VerticalAlignment = Enum.VerticalAlignment.Center
	Tl.Padding           = UDim.new(0, 0)
	Tl.SortOrder         = Enum.SortOrder.LayoutOrder
	Tl.Parent            = Tr
	local Tp = Instance.new("UIPadding")
	Tp.PaddingLeft   = UDim.new(0, 0)
	Tp.PaddingRight  = UDim.new(0, 0)
	Tp.PaddingTop    = UDim.new(0, 2)
	Tp.PaddingBottom = UDim.new(0, 2)
	Tp.Parent        = Tr
	local TAB_W = math.floor((Lay.WPill - 6 - 3) / 4)
	local function MakeTab(N, Clr, LOrd, TT)
		local Tb = Instance.new("TextButton")
		Tb.Text             = N
		Tb.Font             = Fnt.Face
		Tb.TextSize         = Fnt.Size
		Tb.TextScaled       = false
		Tb.TextColor3       = Clr or Thm.TabText
		Tb.BackgroundColor3 = Thm.TabIdle
		Tb.AutoButtonColor  = false
		Tb.BorderSizePixel  = 0
		Tb.Size             = UDim2.new(0.25, -1, 1, 0)
		Tb.LayoutOrder      = LOrd
		Tb.ZIndex           = 7
		Tb.ClipsDescendants = true
		Tb.Parent           = Tr
		Tb.MouseEnter:Connect(function()
			if Tb.BackgroundColor3 ~= Thm.TabActive then
				Svc.Ts:Create(Tb, TweenInfo.new(0.1), { BackgroundColor3 = Thm.TabHover }):Play()
			end
		end)
		Tb.MouseLeave:Connect(function()
			if Tb.BackgroundColor3 ~= Thm.TabActive then
				Svc.Ts:Create(Tb, TweenInfo.new(0.1), { BackgroundColor3 = Thm.TabIdle }):Play()
			end
		end)
		if TT then
			AddTT(Tb, TT)
		end
		return Tb
	end
	local Tbs = {
		Db = MakeTab("Discord", Thm.TabText, 1),
		Ab = MakeTab("AAC", Thm.Pink, 2, "An Average Campaign"),
		Lb = MakeTab("Linkvertise", Thm.TabText, 3, "Yuri"),
		Wb = MakeTab("Lootlabs", Thm.TabText, 4, "Yuri"),
	}
	local Ta = Instance.new("Frame")
	Ta.Name                  = "ToastArea"
	Ta.BackgroundTransparency = 1
	Ta.AnchorPoint           = Vector2.new(1, 1)
	Ta.Position              = UDim2.new(1, -16, 1, -16)
	Ta.Size                  = UDim2.fromOffset(260, 200)
	Ta.Parent                = Sg
	local Tla = Instance.new("UIListLayout")
	Tla.FillDirection       = Enum.FillDirection.Vertical
	Tla.VerticalAlignment   = Enum.VerticalAlignment.Bottom
	Tla.HorizontalAlignment = Enum.HorizontalAlignment.Right
	Tla.Padding             = UDim.new(0, 6)
	Tla.SortOrder           = Enum.SortOrder.LayoutOrder
	Tla.Parent              = Ta
	local function Toast(Txt, Clr)
		Clr = Clr or Thm.Text
		local H = 26
		local O = Instance.new("Frame")
		O.BackgroundColor3  = Thm.ToastBg
		O.BorderColor3      = Thm.ToastBorder
		O.BorderSizePixel   = 1
		O.Size              = UDim2.fromOffset(0, H)
		O.ClipsDescendants  = true
		O.Parent            = Ta
		local Sd = Instance.new("Frame")
		Sd.BackgroundColor3 = Thm.Pink
		Sd.BorderSizePixel  = 0
		Sd.Size             = UDim2.new(0, 3, 1, 0)
		Sd.Parent           = O
		local RHue   = 0
		local RAlive = true
		task.spawn(function()
			while RAlive and O and O.Parent do
				RHue = (RHue + 0.01) % 1
				O.BackgroundColor3 = Color3.fromHSV(RHue, Thm.ToastHueSat, Thm.ToastHueVal)
				task.wait(0.03)
			end
		end)
		task.delay(3.25, function() RAlive = false end)
		local Lbl = Instance.new("TextLabel")
		Lbl.BackgroundTransparency = 1
		Lbl.Font             = Fnt.Face
		Lbl.TextSize         = 13
		Lbl.TextColor3       = Thm.Pink
		Lbl.TextXAlignment   = Enum.TextXAlignment.Left
		Lbl.Position         = UDim2.fromOffset(10, 0)
		Lbl.Size             = UDim2.new(1, -14, 1, 0)
		Lbl.Text             = Txt
		Lbl.Parent           = O
		local TsOk, TsRes = pcall(function()
			return Svc.Txs:GetTextSize(Txt, 13, Fnt.Face, Vector2.new(1000, H))
		end)
		local TxtW = (TsOk and TsRes and TsRes.X) or (#Txt * 8)
		local TgtW    = math.min(260, TxtW + 24)
		Svc.Ts:Create(O, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Size = UDim2.fromOffset(TgtW, H)
		}):Play()
		task.delay(3, function()
			if O and O.Parent then
				Svc.Ts:Create(O, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
					Size = UDim2.fromOffset(0, H)
				}):Play()
				task.delay(0.25, function()
					if O then O:Destroy() end
				end)
			end
		end)
	end
	local Chk = false
	local function SetCheck(IsChk)
		Chk              = IsChk
		Kb.Text      = IsChk and "Checking..." or "Check Key"
		Kb.Active    = not IsChk
		local Tgt = IsChk and Thm.Dim or Thm.Text
		Svc.Ts:Create(Kb, TweenInfo.new(0.15), { TextColor3 = Tgt }):Play()
	end
	local function RunCheck(Key)
		if Chk then return end
		Key = Key and Key:gsub("^%s+", ""):gsub("%s+$", "") or ""
		if Key == "" then
			Toast("Enter your key", Thm.Pink)
			return
		end
		SetCheck(true)
		local Ok, Err = pcall(Ext.OnChkKey, Key, function(Txt, Clr)
			SetCheck(false)
			Toast(Txt, Clr)
		end, Sg)
		if not Ok then
			SetCheck(false)
			Toast("Key check failed: " .. tostring(Err), Thm.Pink)
		end
	end
	local Drg = { On = false }
	Rt.InputBegan:Connect(function(Inp)
		if Inp.UserInputType == Enum.UserInputType.MouseButton1
		or Inp.UserInputType == Enum.UserInputType.Touch then
			Drg.On = true
			Drg.Start = Inp.Position
			Drg.Pos = Wr.Position
			Inp.Changed:Connect(function()
				if Inp.UserInputState == Enum.UserInputState.End then
					Drg.On = false
				end
			end)
		end
	end)
	Rt.InputChanged:Connect(function(Inp)
		if (Inp.UserInputType == Enum.UserInputType.MouseMovement
		or  Inp.UserInputType == Enum.UserInputType.Touch) and Drg.On then
			local Dlt = Inp.Position - Drg.Start
			Svc.Ts:Create(Wr, TweenInfo.new(0.08), {
				Position = UDim2.new(
					Drg.Pos.X.Scale, Drg.Pos.X.Offset + Dlt.X,
					Drg.Pos.Y.Scale, Drg.Pos.Y.Offset + Dlt.Y
				)
			}):Play()
		end
	end)
	Tbs.Lb.MouseButton1Click:Connect(function()
		setclipboard(Ext.Cfg.LinkvertiseURL)
		Toast("Linkvertise link copied", Thm.Pink)
	end)
	Tbs.Wb.MouseButton1Click:Connect(function()
		setclipboard(Ext.Cfg.LootlabsURL)
		Toast("Lootlabs link copied", Thm.Pink)
	end)
	Tbs.Ab.MouseButton1Click:Connect(function()
		setclipboard(Ext.Cfg.AAC)
		Toast("AAC link copied", Thm.Pink)
	end)
	Tbs.Db.MouseButton1Click:Connect(function()
		setclipboard(Ext.Cfg.DiscordURL)
		Toast("Discord link copied", Thm.Pink)
	end)
	Kb.MouseButton1Click:Connect(function()
		RunCheck(Ktb.Text)
	end)
	Ktb.FocusLost:Connect(function(EnterPressed)
		if EnterPressed and Ktb.Text ~= "" then
			RunCheck(Ktb.Text)
		end
	end)
	Cb.MouseButton1Click:Connect(function()
		Sg:Destroy()
		if Ext.OnCls then Ext.OnCls() end
	end)
	Cb.MouseEnter:Connect(function()
		Svc.Ts:Create(Cb, TweenInfo.new(0.15), { ImageColor3 = Thm.Pink }):Play()
	end)
	Cb.MouseLeave:Connect(function()
		Svc.Ts:Create(Cb, TweenInfo.new(0.15), { ImageColor3 = Thm.Dim }):Play()
	end)
	task.spawn(function()
		if Ext.SKey and Ext.SKey ~= "" then
			Ktb.Text = Ext.SKey
			Toast("Filling key...", Thm.Accent)
			RunCheck(Ext.SKey)
		end
	end)
	return {
		ScreenGui  = Sg,
		Toast      = Toast,
		Ktb        = Ktb,
	}
end
return Yuri
