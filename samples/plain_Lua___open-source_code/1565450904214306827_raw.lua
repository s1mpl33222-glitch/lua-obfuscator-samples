-- Deobfuscated By Dex Notifier [.gg/dexfinder]

getgenv().SCRIPT_ID = "8c721ba2ce507addc5014015bcaab1e5"
_call1; getgenv() -- Ran
_call2; getgenv().SCRIPT_ID = "8c721ba2ce507addc5014015bcaab1e5" -- Ran
_call3; local response2 = game:HttpGet("https://raw.githubusercontent.com/31yyyyy/main/refs/heads/main/mm2.lua") -- Remote Call -- Ran
_call4; loadstring(response2) -- Dynamic Load -- Ran
_call5; loadstring(response2)() -- Dynamic Load -- Ran
_call6; local response4 = game:HttpGet("https://raw.githubusercontent.com/meeqscripts/mm2/refs/heads/main/autofarm") -- Remote Call -- Ran
_call7; loadstring(response4) -- Dynamic Load -- Ran
_call8; loadstring(response4)() -- Dynamic Load -- Ran
_call9; getfenv() -- Ran
_call10; rawset({}, 0, { 10, 6, 3, 4, 9, 7, 1, 5, 12 }) -- Ran
_call11; local Frame = Instance.new("Frame") -- Ran
_call12; UDim2.fromOffset(512, 512) -- Ran
_call13; Frame.Size = UDim2.fromOffset(512, 512) -- Ran
_call14; local Path2D = Instance.new("Path2D") -- Ran
_call15; Path2D.Parent = Frame -- Ran
_call16; UDim2.fromOffset(0, 0) -- Ran
_call17; UDim2.fromOffset(23, 27) -- Ran
_call18; Path2DControlPoint.new(UDim2.fromOffset(0, 0), UDim2.fromOffset(0, 0), UDim2.fromOffset(23, 27)) -- Ran
_call19; UDim2.fromOffset(77, 0) -- Ran
_call20; UDim2.fromOffset(-18, 32) -- Ran
_call21; Path2DControlPoint.new(UDim2.fromOffset(77, 0), UDim2.fromOffset(-18, 32), UDim2.fromOffset(0, 0)) -- Ran
_call22; Path2D:SetControlPoints({ Path2DControlPoint.new(UDim2.fromOffset(0, 0), UDim2.fromOffset(0, 0), UDim2.fromOffset(23, 27)), Path2DControlPoint.new(UDim2.fromOffset(77, 0), UDim2.fromOffset(-18, 32), UDim2.fromOffset(0, 0)) }) -- Ran
_call23; Path2D:GetPositionOnCurve(0.25) -- Ran
_call24; Path2D:GetTangentOnCurve(0.25) -- Ran
_call25; UDim2.fromOffset(77, 12) -- Ran
_call26; Path2DControlPoint.new(UDim2.fromOffset(77, 12), UDim2.fromOffset(-18, 32), UDim2.fromOffset(0, 0)) -- Ran
_call27; Path2D:UpdateControlPoint(2, Path2DControlPoint.new(UDim2.fromOffset(77, 12), UDim2.fromOffset(-18, 32), UDim2.fromOffset(0, 0))) -- Ran
_call28; Path2D:GetPositionOnCurve(0.75) -- Ran
_call29; Path2D:GetTangentOnCurve(0.75) -- Ran
_call30; Frame:Destroy() -- Cleanup -- Ran
_call31; Rect.new(-6, -15, 7, -5) -- Ran
_call32; NumberRange.new(-79, -59) -- Ran
_call33; Vector3.new(9, 14, 9) -- Ran
_call34; Vector3.new(-2, 1, 19) -- Ran
_call35; Vector3.new(11, -6, -1) -- Ran
_call36; Vector3.new(-9, -9, 4) -- Ran
_call37; CFrame.new(-5, -15, 10) -- Ran
_call38; Vector3.new(17, -3, 14) -- Ran
_call39; local RotationCurve = Instance.new("RotationCurve") -- Ran
_call40; CFrame.new() -- Ran
_call41; RotationCurveKey.new(0, CFrame.new(), Enum.KeyInterpolationMode.Linear) -- Ran
_call42; RotationCurve:InsertKey(RotationCurveKey.new(0, CFrame.new(), Enum.KeyInterpolationMode.Linear)) -- Ran
_call43; CFrame.Angles(0, 0, 1.5882496193148399) -- Ran
_call44; RotationCurveKey.new(1, CFrame.Angles(0, 0, 1.5882496193148399), Enum.KeyInterpolationMode.Linear) -- Ran
_call45; RotationCurve:InsertKey(RotationCurveKey.new(1, CFrame.Angles(0, 0, 1.5882496193148399), Enum.KeyInterpolationMode.Linear)) -- Ran
_call46; RotationCurve:GetValueAtTime(0.25) -- Ran
_call47; RotationCurve:RemoveKeyAtIndex(2, 1) -- Ran
_call48; CFrame.Angles(0, 0, 1.902408884673819) -- Ran
_call49; RotationCurveKey.new(1, CFrame.Angles(0, 0, 1.902408884673819), Enum.KeyInterpolationMode.Linear) -- Ran
_call50; RotationCurve:InsertKey(RotationCurveKey.new(1, CFrame.Angles(0, 0, 1.902408884673819), Enum.KeyInterpolationMode.Linear)) -- Ran
_call51; RotationCurve:GetValueAtTime(0.75) -- Ran
_call52; RotationCurve:Destroy() -- Cleanup -- Ran
_call53; local Path2D2 = Instance.new("Path2D") -- Ran
_call54; Path2D2.Closed = false -- Ran
_call55; Path2D2.Thickness = 5 -- Ran
_call56; Path2D2.Visible = true -- Ran
_call57; Path2D2.ZIndex = 1 -- Ran
_call58; UDim2.new(-6, -13, 4, 0) -- Ran
_call59; Path2DControlPoint.new(UDim2.new(-6, -13, 4, 0)) -- Ran
_call60; UDim2.new(-16, -20, 16, 0) -- Ran
_call61; Path2DControlPoint.new(UDim2.new(-16, -20, 16, 0)) -- Ran
_call62; Path2D2:SetControlPoints({ Path2DControlPoint.new(UDim2.new(-6, -13, 4, 0)), Path2DControlPoint.new(UDim2.new(-16, -20, 16, 0)) }) -- Ran
_call63; Path2D2:GetControlPoints() -- Ran
_call64; Path2D2:GetMaxControlPoints() -- Ran
_call65; Path2D2:Destroy() -- Cleanup -- Ran
_call66; Vector3.new(-14, 16, -4) -- Ran
_call67; Vector3.new(-19, -1, 3) -- Ran
_call68; Ray.new(Vector3.new(-14, 16, -4), Vector3.new(-19, -1, 3)) -- Ran
_call69; Instance.new("FloatCurve") -- Ran
_call70; FloatCurveKey.new(0, -3, Enum.KeyInterpolationMode.Cubic) -- Ran
_call71; FloatCurveKey.new(1, 15, Enum.KeyInterpolationMode.Cubic) -- Ran
_call72; (run it once with --studio if needed; writes C:\Users\lyubo\AppData\Local\Temp\dex_l_j55mciv5\result_remote0_0_envboot.path2d)
[*] run status: script error: Unable to assign property RightTangent. Property is read only
[*] done: 1 succeeded, 0 failed out of 1 -- Ran
_call73; pcall(loadstring, 48819, nil, nil) -- Protected Call -- Ran
_call74; loadstring(48819, nil, nil) -- Dynamic Load -- Ran
_call75; pcall(nil) -- Protected Call -- Ran
_call76; pcall(loadstring, "\27LuaP", nil, nil) -- Protected Call -- Ran
_call77; loadstring("\27LuaP", nil, nil) -- Dynamic Load -- Ran
_call78; pcall(loadstring, "function: 0x159240950bc0050f", nil, nil) -- Protected Call -- Ran
    _call79; loadstring("function: 0x159240950bc0050f", nil, nil) -- Dynamic Load -- Ran
        _call80; pcall(loadstring, {}, nil, nil) -- Protected Call -- Ran
        Fatal Error: "Script:3: attempt to get length of a nil value"
        -- Dex Environment Log End
