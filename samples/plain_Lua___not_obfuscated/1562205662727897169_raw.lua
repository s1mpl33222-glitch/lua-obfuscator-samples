-- ==========================================================
-- AK-74 (MODELO ORIGINAL) + MIRA NO DEDO + SANGUE
-- ==========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local CONFIG = {
    DAMAGE = 20, HEADSHOT_DAMAGE = 100, FIRE_RATE = 0.09,
    RANGE = 800, BULLET_SPEED = 1500, SPREAD = 0.01,
    BLEED_DURATION = 5, BLEED_TICK = 0.15, BLEED_DAMAGE = 4,
    PUDDLE_MAX_SIZE = 8, PUDDLE_GROWTH_TIME = 5,
}

local bleedingTargets = {}
local currentAimPos = nil

local function updateAimFromInput(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        currentAimPos = input.Position
    elseif input.UserInputType == Enum.UserInputType.MouseMovement 
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        currentAimPos = UserInputService:GetMouseLocation()
    end
end

-- ========== FUNÇÃO AUXILIAR ==========
local function createMesh(part, meshType, scale, offset, meshId)
    local m
    if meshType == "Block" then m = Instance.new("BlockMesh")
    elseif meshType == "Cylinder" then m = Instance.new("CylinderMesh")
    elseif meshType == "Wedge" then
        m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.Wedge
    elseif meshType == "File" then
        m = Instance.new("SpecialMesh"); m.MeshType = Enum.MeshType.FileMesh; m.MeshId = meshId
    end
    if m then
        m.Scale = scale
        if offset then m.Offset = offset end
        m.Parent = part
    end
end

-- ========== CRIAÇÃO DO MODELO ==========
local function createAK74()
    local tool = Instance.new("Tool")
    tool.Name = "AK-74"
    tool.RequiresHandle = true
    tool.CanBeDropped = false
    tool.ToolTip = "AK-74"
    tool.GripForward = Vector3.new(0, 0, -1)
    tool.GripRight = Vector3.new(1, 0, 0)
    tool.GripUp = Vector3.new(0, 1, 0)
    tool.GripPos = Vector3.new(0, -0.2, 0.3)

    -- ========== FUNÇÃO PRA CRIAR PARTE ==========
    local function P(name, pos, rot, size, color, meshType, meshScale, meshOffset, meshId, transparency)
        local p = Instance.new("Part", tool)
        p.Name = name
        p.Size = size
        p.BrickColor = BrickColor.new(color)
        p.Anchored = true
        p.CanCollide = false
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.CFrame = CFrame.new(pos[1], pos[2], pos[3], rot[1], rot[2], rot[3], rot[4], rot[5], rot[6], rot[7], rot[8], rot[9])
        if transparency then p.Transparency = transparency end
        -- Material
        if color == "Brown" or color == "Reddish brown" or meshType == "Wedge" then
            p.Material = Enum.Material.Wood
        elseif color == "White" or color == "Institutional white" then
            p.Material = Enum.Material.Metal
        else
            p.Material = Enum.Material.Metal
        end
        if meshType then
            createMesh(p, meshType, meshScale, meshOffset, meshId)
        end
        return p
    end

    -- ==================== PARTES ====================
    
    -- SmokePart
    P("SmokePart", {69.2977066, 3.61904788, 201.51828},
        {-3.19382108e-014, 0, -1, -0.999999762, -2.4158453e-013, -3.19382108e-014, 2.4158453e-013, 0.999999762, 0},
        Vector3.new(0.2, 0.2, 0.2), "Black", "Cylinder", Vector3.new(0.6, 1, 0.6), nil, nil, 1)

    -- NoSight 1
    P("NoSight1", {69.2977066, 3.9342339, 201.089035},
        {0.999998569, -0.000377150165, -1.73346871e-005, 0.000377151184, 1, 5.64008951e-005, 1.73282315e-005, -5.66393137e-005, 0.999998569},
        Vector3.new(0.2, 0.2, 0.2), "White", "Block", Vector3.new(0.0476190485, 0.0476190485, 0.0476190485), nil, nil, 1)

    -- Block A
    P("BlockA", {69.2977066, 3.6842339, 200.654068},
        {0.000312114571, -0.999998689, -0.000282440305, -0.707122445, -0.000420430471, 0.707091093, -0.707089782, -2.10231665e-005, -0.707121611},
        Vector3.new(1, 1, 1), "Black", "Block", Vector3.new(0.0476190485, 0.0476190485, 0.142857149))

    -- Cylinder 1
    P("Cylinder1", {69.2977066, 3.62031507, 200.737213},
        {0.999998629, 7.62273485e-005, -0.000407658663, 0.000407666783, -0.000104725361, 0.999999881, 7.61873307e-005, -0.99999845, -0.000104993582},
        Vector3.new(1, 1, 1), "Black", "Cylinder", Vector3.new(0.142857149, 0.90476191, 0.095238097))

    -- NoSight 2 (FileMesh ring)
    P("NoSight2", {69.2977066, 3.93926787, 201.118301},
        {-0.000377148564, 0.99999851, -1.53943183e-005, 1.00000024, 0.000377149729, 7.84248114e-005, 7.82907009e-005, -1.53648507e-005, -0.999998689},
        Vector3.new(1, 1, 1), "Black", "File", Vector3.new(0.0571428612, 0.0571428612, 0.428571433), nil, "rbxassetid://3270017")

    -- NoSight 3
    P("NoSight3", {69.2977066, 3.76237607, 200.990097},
        {-0.00025420732, -0.999998689, -0.000293676887, 0.707103848, -0.000387427688, 0.707109749, -0.707108736, -2.78929874e-005, 0.707102537},
        Vector3.new(1, 1, 1), "Black", "Block", Vector3.new(0.0476190485, 0.0238095243, 0.380952388))

    -- NoSight 4
    P("NoSight4", {69.2977066, 3.76721001, 201.118103},
        {-0.000377149496, -0.999998689, -4.57084789e-005, 0.99999994, -0.000377148739, -1.74492598e-005, 1.71065331e-005, -4.57148781e-005, 0.999998629},
        Vector3.new(1, 1, 1), "Black", "Block", Vector3.new(0.285714298, 0.0238095243, 0.0476190485))

    -- Cylinder 2
    P("Cylinder2", {69.2977066, 3.62030005, 201.19812},
        {-0.000377150776, -2.77693744e-005, 0.999998629, 0.99999994, 6.66379929e-005, 0.000377152697, -6.6831708e-005, 0.99999851, 2.77441432e-005},
        Vector3.new(1, 0.4, 1), "Really black", "Cylinder", Vector3.new(0.0666666627, 0.0476190485, 0.099999994), Vector3.new(0, -0.0185714271, 0))

    -- Block B
    P("BlockB", {69.2977066, 3.7292459, 200.451019},
        {2.7749209e-005, -0.999998629, -0.000409813598, -1.32024288e-005, -0.000409814005, 0.999999881, -0.999998629, -2.7773538e-005, -1.34557486e-005},
        Vector3.new(1, 1, 1), "Black", "Block", Vector3.new(0.333333343, 0.0476190485, 0.0476190485))

    -- Wedge Brown 1
    P("WedgeBrown1", {69.2977066, 3.524261, 199.884064},
        {0.999998629, 0.000420307595, 1.73184108e-005, 0.000420307886, -0.999999881, -1.32024288e-005, 1.73127846e-005, 1.34557486e-005, -0.999998629},
        Vector3.new(1, 1, 1), "Brown", "Wedge", Vector3.new(0.238095239, 0.0476190485, 0.476190478))

    -- Cylinder Brown 1
    P("CylBrown1", {69.2977066, 3.73920989, 200.074005},
        {-0.000377150776, -2.77693744e-005, 0.999998629, 0.99999994, 6.66379929e-005, 0.000377152697, -6.6831708e-005, 0.99999851, 2.77441432e-005},
        Vector3.new(1, 1, 1), "Brown", "Cylinder", Vector3.new(0.285714298, 0.476190478, 0.238095239))

    -- Block Brown 1
    P("BlockBrown1", {69.2977066, 3.71525598, 199.979019},
        {-0.999998569, 0.000106894113, -0.000346631015, -0.000346632791, -1.7285347e-005, 0.99999994, 0.000106887252, 0.999998331, 1.71065331e-005},
        Vector3.new(1, 1, 1), "Brown", "Block", Vector3.new(0.238095239, 0.666666687, 0.0476190485))

    -- Block Brown 2
    P("BlockBrown2", {69.2977066, 3.6673429, 199.97905},
        {-0.999998391, 0.000106894106, -0.000712819048, -0.000712821377, -1.7285347e-005, 0.999999821, 0.000106862339, 0.999998331, 1.73002481e-005},
        Vector3.new(1, 1, 1), "Brown", "Block", Vector3.new(0.238095239, 0.095238097, 0.0476190485))

    -- Block Brown 3
    P("BlockBrown3", {69.2977066, 3.66725087, 200.21788},
        {-0.999998629, -1.50081187e-005, -0.000407661399, -0.000407697604, -0.000383511186, 1, -1.51522909e-005, 0.999998629, 0.000383272767},
        Vector3.new(1, 1, 1), "Brown", "Block", Vector3.new(0.238095239, 0.190476194, 0.0476190485))

    -- Block Brown 4
    P("BlockBrown4", {69.2977066, 3.5962379, 199.978958},
        {-0.999998569, 0.000106894113, -0.000346631015, -0.000346632791, -1.7285347e-005, 0.99999994, 0.000106887252, 0.999998331, 1.71065331e-005},
        Vector3.new(1, 1, 1), "Brown", "Block", Vector3.new(0.238095239, 0.666666687, 0.095238097))

    -- Cylinder 3
    P("Cylinder3", {69.2977066, 3.75830197, 198.932236},
        {-0.000377150776, -2.77693744e-005, 0.999998629, 0.99999994, 6.66379929e-005, 0.000377152697, -6.6831708e-005, 0.99999851, 2.77441432e-005},
        Vector3.new(1, 1, 1), "Black", "Cylinder", Vector3.new(0.285714298, 1.23809528, 0.238095239))

    -- NoSight 5
    P("NoSight5", {69.254982, 3.91026211, 199.527023},
        {2.7749209e-005, -0.999998629, -0.000409813598, -1.32024288e-005, -0.000409814005, 0.999999881, -0.999998629, -2.7773538e-005, -1.34557486e-005},
        Vector3.new(0.2, 0.2, 0.2), "Black", "Cylinder", Vector3.new(0.238095134, 0.190476194, 0.285714239))

    -- NoSight 6
    P("NoSight6", {69.3396988, 3.9203341, 199.403091},
        {-0.000377149467, 2.77368908e-005, -0.999998629, 0.99999994, 1.94311142e-005, -0.000377149001, 1.92373991e-005, -0.999998629, -2.77441795e-005},
        Vector3.new(0.2, 0.2, 0.2), "Black", "Block", Vector3.new(0.19047603, 0.142857149, 0.285714239))

    -- Block Brown 5
    P("BlockBrown5", {69.2977066, 3.66739011, 199.741104},
        {-0.999998391, 0.000106894106, -0.000712819048, -0.000712821377, -1.7285347e-005, 0.999999821, 0.000106862339, 0.999998331, 1.73002481e-005},
        Vector3.new(1, 1, 1), "Brown", "Block", Vector3.new(0.238095239, 0.190476194, 0.0476190485))

    -- Cylinder Brown 2
    P("CylBrown2", {69.2977066, 3.52424788, 199.718033},
        {-1.53435158e-005, 0.99999851, 0.000430618791, -5.63710928e-005, 0.000430618064, -1, -0.99999845, -1.53656074e-005, 5.66393137e-005},
        Vector3.new(1, 1, 1), "Brown", "Cylinder", Vector3.new(0.142857149, 0.238095239, 0.142857149))

    -- NoSight 7
    P("NoSight7", {69.2977066, 3.9103539, 199.532043},
        {-0.000377149467, 2.77368908e-005, -0.999998629, 0.99999994, 1.94311142e-005, -0.000377149001, 1.92373991e-005, -0.999998629, -2.77441795e-005},
        Vector3.new(0.2, 0.285714298, 0.2), "Black", "Block", Vector3.new(0.095238097, 1, 0.238095224))

    -- Block C
    P("BlockC", {69.2977066, 3.81024194, 199.693863},
        {-0.999998569, 0.000106894113, -0.000346631015, -0.000346632791, -1.7285347e-005, 0.99999994, 0.000106887252, 0.999998331, 1.71065331e-005},
        Vector3.new(1, 1, 1), "Black", "Block", Vector3.new(0.238095239, 0.285714298, 0.142857149))

    -- NoSight 8
    P("NoSight8", {69.2977066, 3.8913281, 199.656097},
        {-0.000377149467, 2.77368908e-005, -0.999998629, 0.99999994, 1.94311142e-005, -0.000377149001, 1.92373991e-005, -0.999998629, -2.77441795e-005},
        Vector3.new(0.2, 0.2, 0.2), "Black", "Block", Vector3.new(0.095237948, 0.285714298, 0.523809493))

    -- Mag 1a
    P("Mag1a", {69.298439, 2.97143507, 198.956085},
        {-0.99999851, -0.000241882386, -0.000339059538, -0.000414613256, 0.500024915, 0.866010785, -3.9932791e-005, 0.866009295, -0.500024438},
        Vector3.new(1, 1, 1), "Black", "Block", Vector3.new(0.142857149, 0.333333343, 0.238095239))

    -- Mag 1b
    P("Mag1b", {69.2974625, 2.80036998, 199.091232},
        {-0.999998569, -0.00034218331, -0.00024749877, -0.000416969444, 0.707117915, 0.707095742, -6.68740104e-005, 0.707094431, -0.70711714},
        Vector3.new(1, 1, 1), "Black", "Block", Vector3.new(0.142857149, 0.333333343, 0.285714298))

    -- NoSight 9
    P("NoSight9", {69.254982, 3.9203341, 199.403091},
        {-0.000377149467, 2.77368908e-005, -0.999998629, 0.99999994, 1.94311142e-005, -0.000377149001, 1.92373991e-005, -0.999998629, -2.77441795e-005},
        Vector3.new(0.2, 0.2, 0.2), "Black", "Block", Vector3.new(0.19047603, 0.142857149, 0.285714239))

    -- NoSight 10
    P("NoSight10", {69.301857, 3.92929196, 199.402985},
        {1.51692539e-005, -0.00040766751, 0.999998629, -4.36753035e-005, 1.00000012, 0.000407668209, -0.999998569, -4.3913722e-005, 1.51522545e-005},
        Vector3.new(0.2, 0.2, 0.2), "Black", "Wedge", Vector3.new(0.142857105, 0.0952381045, 0.0952381343))

    -- Block D
    P("BlockD", {69.2977066, 3.810256, 198.9561},
        {0.999998629, 7.62273485e-005, -0.000407658663, 0.000407666783, -0.000104725361, 0.999999881, 7.61873307e-005, -0.99999845, -0.000104993582},
        Vector3.new(1, 1, 1), "Black", "Block", Vector3.new(0.238095239, 1.38095236, 0.0476190485))

    -- NoSight 11
    P("NoSight11", {69.2930603, 3.92929196, 199.402985},
        {-1.51692557e-005, -0.000346632412, -0.999998629, 4.36753035e-005, 1.00000012, -0.000346633111, 0.999998569, -4.3913722e-005, -1.51530912e-005},
        Vector3.new(0.2, 0.2, 0.2), "Black", "Wedge", Vector3.new(0.142857119, 0.095238097, 0.0952381045))

    -- NoSight 12
    P("NoSight12", {69.3396988, 3.91026211, 199.527023},
        {2.7749209e-005, -0.999998629, -0.000409813598, -1.32024288e-005, -0.000409814005, 0.999999881, -0.999998629, -2.7773538e-005, -1.34557486e-005},
        Vector3.new(0.2, 0.2, 0.2), "Black", "Cylinder", Vector3.new(0.238095134, 0.190476194, 0.285714298))

    -- Block E
    P("BlockE", {69.2977066, 3.64428711, 198.884186},
        {0.999998629, 7.62273485e-005, -0.000407658663, 0.000407666783, -0.000104725361, 0.999999881, 7.61873307e-005, -0.99999845, -0.000104993582},
        Vector3.new(1, 2, 1), "Black", "Block", Vector3.new(0.238095239, 0.761904776, 0.285714298))

    -- Mag 1c
    P("Mag1c", {69.2977066, 3.39128089, 198.845901},
        {-0.999998569, 0.000106894113, -0.000346631015, -0.000346632791, -1.7285347e-005, 0.99999994, 0.000106887252, 0.999998331, 1.71065331e-005},
        Vector3.new(1, 1, 1), "Black", "Block", Vector3.new(0.142857149, 0.333333343, 0.285714298))

    -- Mag 1d
    P("Mag1d", {69.298439, 3.167238, 198.874069},
        {-0.999998689, -0.000160119409, -0.000383009872, -0.000411395158, 0.258848459, 0.965918124, -5.55789957e-005, 0.965916514, -0.25884822},
        Vector3.new(1, 1, 1), "Black", "Block", Vector3.new(0.142857149, 0.333333343, 0.285714298))

    -- Wedge Black 1
    P("WedgeBlack1", {69.2977066, 3.76335192, 198.07431},
        {0.999998569, -0.000377150165, -1.73346871e-005, 0.000377151184, 1, 5.64008951e-005, 1.73282315e-005, -5.66393137e-005, 0.999998569},
        Vector3.new(1, 1, 1), "Black", "Wedge", Vector3.new(0.238095239, 0.0476190485, 0.095238097))

    -- Block Brown 6
    P("BlockBrown6", {69.2977066, 3.24830794, 198.278915},
        {-0.999998629, 8.76361664e-005, -0.000339380262, -0.000349432928, -0.173593849, 0.984817386, 2.74343911e-005, 0.984815717, 0.173593327},
        Vector3.new(1, 1, 1), "Brown", "Block", Vector3.new(0.190476194, 0.238095239, 0.619047642))

    -- Block F
    P("BlockF", {69.2977066, 3.47234988, 198.498016},
        {-0.000150461565, 0.000528063392, -0.999998569, 0.866048634, -0.499959767, -0.00039429497, -0.499959201, -0.866047323, -0.000382182479},
        Vector3.new(1, 0.4, 1), "Black", "Block", Vector3.new(0.095238097, 0.0476190485, 0.0476190485))

    -- Wedge Brown 2
    P("WedgeBrown2", {69.2977066, 3.41328406, 198.16423},
        {0.999998569, -7.35549474e-005, -0.000398139557, 0.000404866703, 0.173634678, 0.984809995, -3.2952812e-006, -0.984808683, 0.173634306},
        Vector3.new(1, 1, 1), "Brown", "Wedge", Vector3.new(0.190476194, 0.0476190485, 0.142857149))

    -- Wedge Brown 3
    P("WedgeBrown3", {69.298439, 3.22434807, 197.384155},
        {0.999998629, 0.000420307595, 1.73184108e-005, 0.000420307886, -0.999999881, -1.32024288e-005, 1.73127846e-005, 1.34557486e-005, -0.999998629},
        Vector3.new(1, 1, 1), "Brown", "Wedge", Vector3.new(0.238095239, 0.428571433, 1.28571427))

    -- Wedge Black 2
    P("WedgeBlack2", {69.2977066, 3.81024194, 198.194107},
        {0.999998569, -0.000377150165, -1.73346871e-005, 0.000377151184, 1, 5.64008951e-005, 1.73282315e-005, -5.66393137e-005, 0.999998569},
        Vector3.new(1, 1, 1), "Black", "Wedge", Vector3.new(0.238095239, 0.0476190485, 0.142857149))

    -- Block Brown 7
    P("BlockBrown7", {69.2977066, 3.53424001, 197.12207},
        {0.999998569, -0.000377150165, -1.73346871e-005, 0.000377151184, 1, 5.64008951e-005, 1.73282315e-005, -5.66393137e-005, 0.999998569},
        Vector3.new(1, 1, 1), "Brown", "Block", Vector3.new(0.238095239, 0.190476194, 1.0476191))

    -- Wedge Black 3
    P("WedgeBlack3", {69.2977066, 3.47733998, 198.479065},
        {0.999998629, 0.000420307595, 1.73184108e-005, 0.000420307886, -0.999999881, -1.32024288e-005, 1.73127846e-005, 1.34557486e-005, -0.999998629},
        Vector3.new(1, 1, 1), "Black", "Wedge", Vector3.new(0.238095239, 0.0476190485, 0.714285731))

    -- Wedge Brown 4
    P("WedgeBrown4", {69.2977066, 3.60525489, 197.718201},
        {-0.999998689, -0.000420309458, 3.81800055e-005, -0.000420310069, 0.999999881, -1.32620335e-005, -3.81743303e-005, -1.34557486e-005, -0.999998629},
        Vector3.new(1, 1, 1), "Brown", "Wedge", Vector3.new(0.238095239, 0.0476190485, 0.142857149))

    -- Wedge Brown 5
    P("WedgeBrown5", {69.2977066, 3.6534121, 197.908035},
        {0.999998569, -0.000377150165, -1.73346871e-005, 0.000377151184, 1, 5.64008951e-005, 1.73282315e-005, -5.66393137e-005, 0.999998569},
        Vector3.new(1, 1, 1), "Brown", "Wedge", Vector3.new(0.238095239, 0.142857149, 0.238095239))

    -- Ring 1
    P("Ring1", {69.2977066, 3.47724891, 198.503067},
        {1.51462345e-005, 0.00040766751, -0.999998629, 1.73449516e-005, -0.99999994, -0.000407667307, -0.999998569, -1.71065331e-005, -1.5152269e-005},
        Vector3.new(1, 1, 1), "Black", "File", Vector3.new(0.190476194, 0.142857149, 0.142857149), nil, "rbxassetid://3270017")

    -- Block G
    P("BlockG", {69.2977066, 3.59620595, 198.074112},
        {0.999998629, 7.61677511e-005, -4.14705974e-005, 4.14781134e-005, -0.000104755163, 1, 7.61922347e-005, -0.999998391, -0.000105023384},
        Vector3.new(1, 1, 1), "Black", "Block", Vector3.new(0.238095239, 0.095238097, 0.285714298))

    -- Block Brown 8
    P("BlockBrown8", {69.2977066, 3.51039195, 197.836105},
        {0.999998569, -0.000377150165, -1.73346871e-005, 0.000377151184, 1, 5.64008951e-005, 1.73282315e-005, -5.66393137e-005, 0.999998569},
        Vector3.new(1, 1, 1), "Brown", "Block", Vector3.new(0.238095239, 0.142857149, 0.380952388))

    -- Block Brown 9
    P("BlockBrown9", {69.2977066, 3.22426009, 196.67012},
        {0.999998569, -0.000377150165, -1.73346871e-005, 0.000377151184, 1, 5.64008951e-005, 1.73282315e-005, -5.66393137e-005, 0.999998569},
        Vector3.new(1, 1, 1), "Brown", "Block", Vector3.new(0.238095239, 0.428571433, 0.142857149))

    -- AimPart
    P("AimPart", {69.2974625, 3.940202, 197.956024},
        {-1, 3.19382108e-014, 0, -3.19382108e-014, 0.999999762, 2.4158453e-013, -0, -2.4158453e-013, -0.999999762},
        Vector3.new(0.2, 0.2, 0.2), "Black", nil, nil, nil, nil, 1)

    -- ========== HANDLE (parte base do grip) ==========
    local handle = Instance.new("Part", tool)
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 0.4, 1)
    handle.Transparency = 1
    handle.Anchored = true
    handle.CanCollide = false
    handle.CFrame = CFrame.new(69.2974625, 3.28031993, 198.045059,
        -0.99999851, -0.000377149961, -1.53597921e-005,
        -0.000377149729, 0.999999881, -1.32918358e-005,
        1.53648507e-005, -1.34557486e-005, -0.99999845)

    -- ========== MOVE TUDO RELATIVO AO HANDLE E WELDA ==========
    local handleCF = handle.CFrame
    for _, v in pairs(tool:GetChildren()) do
        if v:IsA("BasePart") and v ~= handle then
            -- Converte posição absoluta para relativa ao handle
            local relativeCF = handleCF:ToObjectSpace(v.CFrame)
            v.CFrame = CFrame.new(0, 0, 0) * relativeCF
            -- Solta e solda
            v.Anchored = false
            v.Massless = true
            local w = Instance.new("WeldConstraint")
            w.Part0 = handle
            w.Part1 = v
            w.Parent = handle
        end
    end
    handle.CFrame = CFrame.new(0, 0, 0)
    handle.Anchored = false

    -- ========== MUZZLE POINT ==========
    local muzzle = Instance.new("Part", tool)
    muzzle.Name = "MuzzlePoint"
    muzzle.Size = Vector3.new(0.05, 0.05, 0.05)
    muzzle.Transparency = 1
    muzzle.CanCollide = false
    muzzle.Anchored = false
    muzzle.Massless = true
    muzzle.CFrame = handle.CFrame * CFrame.new(0, 0, -2.5)
    local wM = Instance.new("WeldConstraint")
    wM.Part0 = handle; wM.Part1 = muzzle; wM.Parent = handle

    local ejectPort = Instance.new("Part", tool)
    ejectPort.Name = "EjectPoint"
    ejectPort.Size = Vector3.new(0.03, 0.03, 0.03)
    ejectPort.Transparency = 1
    ejectPort.CanCollide = false
    ejectPort.Anchored = false
    ejectPort.Massless = true
    ejectPort.CFrame = handle.CFrame * CFrame.new(0.2, 0.3, -0.3)
    local wE = Instance.new("WeldConstraint")
    wE.Part0 = handle; wE.Part1 = ejectPort; wE.Parent = handle

    -- Fumaça
    local smoke = Instance.new("ParticleEmitter")
    smoke.Texture = "rbxassetid://243660364"
    smoke.Color = ColorSequence.new(Color3.fromRGB(200, 200, 200))
    smoke.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 2)})
    smoke.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1)})
    smoke.Lifetime = NumberRange.new(0.5, 1)
    smoke.Speed = NumberRange.new(2, 5)
    smoke.SpreadAngle = Vector2.new(20, 20)
    smoke.Rate = 0
    smoke.Parent = muzzle

    -- Som
    local fireSound = Instance.new("Sound")
    fireSound.Name = "FireSound"
    fireSound.SoundId = "rbxassetid://1112101072"
    fireSound.Volume = 0.6
    fireSound.Pitch = 1.0
    fireSound.Parent = handle

    return tool
end

-- ================= SANGUE =================
local function spawnBloodDropToward(startPos, targetPos)
    local drop = Instance.new("Part")
    drop.Shape = Enum.PartType.Ball
    drop.Size = Vector3.new(0.18, 0.18, 0.18)
    drop.BrickColor = BrickColor.new("Crimson")
    drop.Material = Enum.Material.Glass
    drop.Transparency = 0.1
    drop.CanCollide = false
    drop.CFrame = CFrame.new(startPos)
    local d = (targetPos - startPos)
    local h = Vector3.new(d.X, 0, d.Z).Unit
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = h * math.random(4, 8) + Vector3.new(math.random(-3,3), math.random(-2,2), math.random(-3,3))
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = drop
    drop.Parent = workspace
    Debris:AddItem(drop, 4)
end

local function spawnBloodSplat(position)
    for i = 1, 18 do
        local drop = Instance.new("Part")
        drop.Shape = Enum.PartType.Ball
        drop.Size = Vector3.new(0.15, 0.15, 0.15)
        drop.BrickColor = BrickColor.new("Crimson")
        drop.Material = Enum.Material.Glass
        drop.Transparency = 0.1
        drop.CanCollide = false
        drop.CFrame = CFrame.new(position)
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(math.random(-25,25), math.random(5,30), math.random(-25,25))
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = drop
        drop.Parent = workspace
        Debris:AddItem(drop, 3)
    end
end

local function createFixedBloodPuddle(position)
    local rp = RaycastParams.new(); rp.FilterDescendantsInstances = {workspace.CurrentCamera}; rp.FilterType = Enum.RaycastFilterType.Exclude
    local fr = workspace:Raycast(position, Vector3.new(0, -80, 0), rp)
    local fp = fr and fr.Position or (position - Vector3.new(0, 3, 0))
    local p = Instance.new("Part")
    p.Name = "BloodPuddle"
    p.Shape = Enum.PartType.Cylinder
    p.Size = Vector3.new(0.1, 1, 1)
    p.BrickColor = BrickColor.new("Crimson")
    p.Material = Enum.Material.Glass
    p.Transparency = 0.15
    p.Anchored = true
    p.CanCollide = false
    p.CFrame = CFrame.new(fp.X, fp.Y + 0.05, fp.Z) * CFrame.Angles(0, math.random() * math.pi * 2, math.rad(90))
    p.Parent = workspace
    Debris:AddItem(p, 15)
    TweenService:Create(p, TweenInfo.new(CONFIG.PUDDLE_GROWTH_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(0.1, CONFIG.PUDDLE_MAX_SIZE, CONFIG.PUDDLE_MAX_SIZE)}):Play()
    return p, fp
end

local function applyBleedEffect(humanoid, hitPart, isHeadshot, hitPosition)
    if bleedingTargets[humanoid] then return end
    bleedingTargets[humanoid] = true
    if isHeadshot then
        pcall(function() hitPart:BreakJoints() end)
        for i = 1, 60 do
            spawnBloodSplat(hitPart.Position + Vector3.new(math.random(-1,1), math.random(-1,1), math.random(-1,1)))
        end
    end
    local puddle, floorPos = createFixedBloodPuddle(hitPosition)
    task.spawn(function()
        local totalTicks = CONFIG.BLEED_DURATION / CONFIG.BLEED_TICK
        for i = 1, totalTicks do
            if not humanoid or humanoid.Health <= 0 then break end
            humanoid:TakeDamage(CONFIG.BLEED_DAMAGE)
            local root = humanoid.Parent:FindFirstChild("HumanoidRootPart")
            if root then
                local dp = root.Position + Vector3.new(math.random(-1,1), math.random(-0.5,1), math.random(-1,1))
                for j = 1, math.random(3,5) do
                    spawnBloodDropToward(dp, floorPos)
                end
            end
            task.wait(CONFIG.BLEED_TICK)
        end
        if humanoid and humanoid.Health > 0 then humanoid.Health = 0 end
        bleedingTargets[humanoid] = nil
    end)
end

-- ================= TIRO =================
local function shoot(tool)
    local character = LocalPlayer.Character
    if not character then return end
    local muzzle = tool:FindFirstChild("MuzzlePoint")
    local ejectPort = tool:FindFirstChild("EjectPoint")
    if not muzzle or not ejectPort then return end

    local flash = Instance.new("Part")
    flash.Shape = Enum.PartType.Ball
    flash.Size = Vector3.new(0.8, 0.8, 0.8)
    flash.Material = Enum.Material.Neon
    flash.Color = Color3.fromRGB(255, 180, 0)
    flash.CFrame = muzzle.CFrame
    flash.Anchored = true
    flash.CanCollide = false
    flash.Parent = workspace
    Debris:AddItem(flash, 0.04)
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 180, 0)
    light.Range = 10
    light.Brightness = 4
    light.Parent = flash

    local smoke = muzzle:FindFirstChildOfClass("ParticleEmitter")
    if smoke then smoke:Emit(3) end

    local casing = Instance.new("Part")
    casing.Shape = Enum.PartType.Cylinder
    casing.Size = Vector3.new(0.2, 0.08, 0.08)
    casing.Color = Color3.fromRGB(200, 180, 50)
    casing.Material = Enum.Material.Metal
    casing.CFrame = ejectPort.CFrame * CFrame.Angles(0, 0, math.rad(90))
    casing.CanCollide = false
    casing.Parent = workspace
    local cv = Instance.new("BodyVelocity")
    cv.Velocity = ejectPort.CFrame.RightVector * 15 + Vector3.new(0, 8, 0)
    cv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    cv.Parent = casing
    Debris:AddItem(casing, 4)

    local camPos = Camera.CFrame.Position
    local aimDirection
    if currentAimPos then
        local ray = Camera:ScreenPointToRay(currentAimPos.X, currentAimPos.Y)
        aimDirection = ray.Direction.Unit
    else
        aimDirection = Camera.CFrame.LookVector
    end

    local sX = math.random(-CONFIG.SPREAD*1000, CONFIG.SPREAD*1000)/1000
    local sY = math.random(-CONFIG.SPREAD*1000, CONFIG.SPREAD*1000)/1000
    local sZ = math.random(-CONFIG.SPREAD*1000, CONFIG.SPREAD*1000)/1000
    local direction = (aimDirection + Vector3.new(sX, sY, sZ)).Unit

    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {character, tool}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(camPos, direction * CONFIG.RANGE, rp)
    local targetPos = result and result.Position or (camPos + direction * CONFIG.RANGE)

    local bullet = Instance.new("Part")
    bullet.Shape = Enum.PartType.Ball
    bullet.Size = Vector3.new(0.22, 0.22, 0.22)
    bullet.Material = Enum.Material.Neon
    bullet.Color = Color3.fromRGB(255, 150, 30)
    bullet.CFrame = CFrame.new(muzzle.Position)
    bullet.CanCollide = false
    bullet.Parent = workspace
    local a0 = Instance.new("Attachment", bullet)
    local a1 = Instance.new("Attachment", bullet)
    a1.Position = Vector3.new(0, 0, 0.4)
    local trail = Instance.new("Trail")
    trail.Attachment0 = a0; trail.Attachment1 = a1
    trail.Lifetime = 0.12; trail.MinLength = 0
    trail.Color = ColorSequence.new(Color3.fromRGB(255,200,80), Color3.fromRGB(255,60,0))
    trail.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.1), NumberSequenceKeypoint.new(1,1)})
    trail.Parent = bullet

    local d = (muzzle.Position - targetPos).Magnitude
    local t = d / CONFIG.BULLET_SPEED
    TweenService:Create(bullet, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)}):Play()
    Debris:AddItem(bullet, t + 0.3)

    if result then
        task.spawn(function()
            local hp = result.Instance
            local hu = hp.Parent:FindFirstChild("Humanoid")
            if hu then
                local hs = hp.Name == "Head"
                local impact = Instance.new("Part")
                impact.Shape = Enum.PartType.Ball
                impact.Size = Vector3.new(0.35, 0.35, 0.35)
                impact.Material = Enum.Material.Neon
                impact.Color = Color3.fromRGB(255, 80, 80)
                impact.CFrame = CFrame.new(result.Position)
                impact.Anchored = true
                impact.CanCollide = false
                impact.Parent = workspace
                Debris:AddItem(impact, 0.15)
                spawnBloodSplat(result.Position)
                hu:TakeDamage(hs and CONFIG.HEADSHOT_DAMAGE or CONFIG.DAMAGE)
                applyBleedEffect(hu, hp, hs, result.Position)
            else
                local sp = Instance.new("Part")
                sp.Shape = Enum.PartType.Ball
                sp.Size = Vector3.new(0.15, 0.15, 0.15)
                sp.Material = Enum.Material.Neon
                sp.Color = Color3.fromRGB(255, 200, 0)
                sp.CFrame = CFrame.new(targetPos)
                sp.Anchored = true
                sp.CanCollide = false
                sp.Parent = workspace
                Debris:AddItem(sp, 0.15)
            end
        end)
    end

    local handle = tool:FindFirstChild("Handle")
    if handle and handle:FindFirstChild("FireSound") then handle.FireSound:Play() end
end

-- ================= INPUT =================
for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
    if v.Name == "AK-74" then v:Destroy() end
end
if LocalPlayer.Character then
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
        if v.Name == "AK-74" then v:Destroy() end
    end
end

local ok, ak = pcall(createAK74)
if not ok then
    warn("[AK-74] Erro ao criar arma: " .. tostring(ak))
    return
end
ak.Parent = LocalPlayer.Backpack

local isShooting = false
local lastShot = 0

RunService.RenderStepped:Connect(function()
    if isShooting and ak.Parent == LocalPlayer.Character then
        local now = tick()
        if now - lastShot >= CONFIG.FIRE_RATE then
            lastShot = now
            shoot(ak)
        end
    end
end)

UserInputService.TouchStarted:Connect(function(input) isShooting = true; updateAimFromInput(input) end)
UserInputService.TouchMoved:Connect(function(input) updateAimFromInput(input) end)
UserInputService.TouchEnded:Connect(function(input) isShooting = false; currentAimPos = nil end)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isShooting = true; updateAimFromInput(input) end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then updateAimFromInput(input) end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isShooting = false end
end)

task.spawn(function()
    task.wait(1)
    local char = LocalPlayer.Character
    if char then ak.Parent = char end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    isShooting = false
    task.wait(1)
    if char and char:FindFirstChild("Humanoid") then ak.Parent = char end
end)

print("[AK-74] Carregado! Arraste o dedo para atirar.")