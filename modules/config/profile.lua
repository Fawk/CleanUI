local A, L = unpack(select(2, ...))
local GetUnitName = GetUnitName
local Profile, profiles = {}, {}
local activeProfile = nil
local currentCharacter = nil

local function deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepCopy(orig_key)] = deepCopy(orig_value)
        end
        setmetatable(copy, deepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function Profile:Init()
	profiles = {}

	for name, profile in pairs(A.db["Profiles"]) do
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

function Profile:IsDefault()
	return activeProfile == "Default"
end

local function copyOfName(name)
	return name.."(Copy)"
end

function Profile:Copy(name)
	if not name then
		name = activeProfile
	end

	local profile = profiles[name]
	local newName = copyOfName(name)
	
	A.db["Profiles"][newName] = deepCopy(profile)
	A.db["Characters"][currentCharacter] = newName

	self:Change(newName)
end

local function removeEmptyProfiles(db)
	local newTbl = {}
	for k, v in next, db do
		if v ~= nil then
			newTbl[k] = v
		end
	end
	db = newTbl
end

function Profile:Rename(name, newName)
	if name == "Default" then
		return error("You cannot rename the Default profile.")
	end

	if activeProfile == name then
		A.db["Profiles"][newName] = deepCopy(A["Profile"])
	else
		A.db["Profiles"][newName] = deepCopy(profiles[name])
	end

	for char, profile in next, A.db["Characters"] do
		if name == profile then
			A.db["Characters"][char] = newName
		end
	end

	A.db["Profiles"][name] = nil
	removeEmptyProfiles(A.db["Profiles"])

	self:Change(newName)
end

function Profile:Change(name)
	A.db["Characters"][currentCharacter] = name

	self:Init()
	self:SetActive(name)

	A:Init()
	A:UpdateMoveableFrames()

	A.dbProvider:Save()
end

A.profiler = Profile