local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local Units = A.Units

function GroupRoleIndicator(frame, db)
	local role = frame.GroupRoleIndicator or (function()
		local role = CreateFrame("Frame", frame:GetName().."_GroupRoleIndicator", frame)
		role:SetSize(14, 14)
		role:SetFrameLevel(4)
		local texture = role:CreateTexture(nil, "OVERLAY")
        role.texture = texture
        role.PostUpdate = function(self, role)
            self.texture:SetTexture(media:Fetch("icon", role))
            self.texture:SetTexCoord(0, 1, 0, 1)
        end
        role.SetTexCoord = function(self) end
		return role
	end)()

	Units:Position(role, db["Position"])
	role.texture:SetAllPoints()

	frame.GroupRoleIndicator = role
end

A["Elements"]["GroupRoleIndicator"] = GroupRoleIndicator