local A, L = unpack(select(2, ...))
local media = LibStub("LibSharedMedia-3.0")
local Units = A.Units

function LFDRole(frame, db)
	local role = frame.LFDRole or (function()
		local role = frame:CreateTexture(frame:GetName().."_LFDRole", "OVERLAY")
        role:SetSize(14, 14)
        role.PostUpdate = function(self, role)
            self:SetTexture(media:Fetch("icon", role))
            self:SetTexCoord(0, 1, 0, 1)
        end
		return role
	end)()

	Units:Position(role, db["Position"])

	frame.LFDRole = role
end

A["Elements"]["LFDRole"] = LFDRole