local A, L = unpack(select(2, ...))
local GetUnitName = GetUnitName
local Profile, profiles = {}, {}
local activeProfile = nil

function Profile:Init(db)
	for name, profile in pairs(db["Profiles"]) do
		A:Debug("Profile:", name, "loaded!")
		profiles[name] = profile
	end
end

local function getName(n, r)
	return n.."-"..r
end

function Profile:Set(name)
	if not A.db["Characters"][name] then
		A.db["Characters"][name] = "Default"
		self:SetActive("Default")
	else
		self:SetActive(A.db["Characters"][name])
	end
	self:Update(name)
end

function Profile:Load()
	local name, realm = UnitFullName("player")
	if not realm then
		local f = CreateFrame("Frame")
		f.timer = 0
		f:SetScript("OnUpdate", function(self, elapsed)
			self.timer = self.timer + elapsed
			if self.timer > 0.001 then
				name, realm = UnitFullName("player")
				if realm then
					name = getName(name, realm)
					Profile:Set(name)
					self:SetScript("OnUpdate", nil)
				end
				self.timer = 0
			end
		end)
	else
		name = getName(name, realm)
		self:Set(name)
	end
end

function Profile:SetActive(profile)
	A:Debug("Setting active profile:", profile)
	A["Profile"] = A.db["Profiles"][profile] or A.db["Profiles"]["Default"]
	activeProfile = profile
end

function Profile:GetActive()
	return activeProfile
end

function Profile:Update(name)
	if name then
		A.db["Characters"][name] = profiles[name]
	else
		for name, profile in pairs(profiles) do
			A.db["Characters"][name] = profile
		end
	end
end

function Profile:Copy(name)
	local profile = profiles[name]
	A.db["Profiles"][name] = A.db["Profiles"][profile]
	A.db["Characters"][name] = name
end

A["Modules"]["Profile"] = Profile