local A, L = unpack(select(2, ...))
local GetUnitName = GetUnitName
local Profile, profiles = {}, {}
local activeProfile = nil
local currentCharacter = nil

local function deepCopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function Profile:Init(db)
	local _db = db or A.db
	for name, profile in pairs(_db["Profiles"]) do
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
	return name.."(Copy)"
end

function Profile:Copy(name)
	local profile = profiles[name]
	local newName = copyOfName(name)
	
	A.db["Profiles"][newName] = deepCopy(profile)
	A.db["Characters"][currentCharacter] = newName

	self:Init(A.db)
	A.dbProvider:Save()
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
		error("You cannot rename the Default profile.")
		return
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

	self:Init(A.db)
	self:SetActive(newName)
	A.dbProvider:Save()
end

function Profile:Change(name)
	A.db["Characters"][currentCharacter] = name

	self:Init()
	self:SetActive(name)
	A.dbProvider:Save()
end

A.modules["Profile"] = Profile

