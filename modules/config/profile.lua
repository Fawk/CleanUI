local A, L = unpack(select(2, ...))
local GetUnitName = GetUnitName
local Profile, profiles = {}, {}
local activeProfile = nil
local currentCharacter = nil

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
	currentCharacter = name
	A.dbProvider:Save()
end

function Profile:Load()
	local name, realm = UnitFullName("player")
	name = getName(name, realm)
	self:Set(name)
end

function Profile:SetActive(profile)
	A:Debug("Setting active profile:", profile)
	A["Profile"] = A.db["Profiles"][profile] or A.db["Profiles"]["Default"]
	activeProfile = profile
end

function Profile:GetActive()
	return activeProfile
end

local function copyOfName(name)
	return name.." (Copy)"
end

function Profile:Copy(name)
	local profile = profiles[name]
	local newName = copyOfName(name)
	A.db["Profiles"][newName] = A.db["Profiles"][profile]
	A.db["Characters"][currentCharacter] = newName
end

function Profile:Rename(name)
	if activeProfile == name then
		
	else

	end
end

A["Modules"]["Profile"] = Profile