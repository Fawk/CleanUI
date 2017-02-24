local A, L = unpack(select(2, ...))
local GetUnitName = GetUnitName
local Profile, profiles = {}, {}

function Profile:Init(db)
	for name, profile in pairs(db["Profiles"]) do
		A:Debug("Profile:", name, "loaded!")
		profiles[name] = profile
	end
end

function Profile:Load()
	local name = GetUnitName("player", true)
	if not A.db["Characters"][name] then
		A.db["Characters"][name] = "Default"
		self:SetActive("Default")
	else
		self:SetActive(A.db["Characters"][name])
	end
	self:Update(name)
end

function Profile:SetActive(profile)
	A:Debug("Setting active profile:", profile)
	A["Profile"] = A.db["Profiles"][profile] or A.db["Profiles"]["Default"]
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

A["Modules"]["Profile"] = Profile