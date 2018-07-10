local AddonName = ...
local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")

local GetAddOnCPUUsage = GetAddOnCPUUsage
local GetAddOnMemoryUsage = GetAddOnMemoryUsage
local UpdateAddOnCPUUsage = UpdateAddOnCPUUsage
local UpdateAddOnMemoryUsage = UpdateAddOnMemoryUsage

local Stats = {}

function Stats:Init()

	local frame = CreateFrame("Frame", nil, A.frameParent)
	frame:SetSize(200, 100)
	frame:SetPoint("TOPLEFT", A.frameParent, "TOPLEFT", 100, 0)
	frame:SetBackdrop(A.enum.backdrops.editboxborder)
	frame:SetBackdropColor(0.1, 0.1, 0.1, 0.5)

	frame.cpu = frame:CreateFontString(nil, "OVERLAY")
	frame.cpu:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")
	frame.cpu:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -5)

	frame.mem = frame:CreateFontString(nil, "OVERLAY")
	frame.mem:SetFont(media:Fetch("font", "Default"), 10, "OUTLINE")
	frame.mem:SetPoint("TOPLEFT", frame.cpu, "BOTTOMLEFT", 0, -5)

	-- frame:SetScript("OnUpdate", function(self, elapsed)
	-- 	UpdateAddOnCPUUsage()
	-- 	UpdateAddOnMemoryUsage()

	-- 	self.cpu:SetText(GetAddOnCPUUsage(AddonName))
	-- 	self.mem:SetText(GetAddOnMemoryUsage(AddonName))
	-- end)

end

A.modules.stats = Stats