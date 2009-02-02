
Visor2GUI = Visor2:NewModule("GUI", "AceConsole-2.0")

local L = AceLibrary("AceLocale-2.2"):new("Visor2_GUI")
local function round(num, digits)
	-- banker's rounding
	local mantissa = 10^digits
	local norm = num*mantissa
	norm = norm + 0.5
	local norm_f = math.floor(norm)
	if norm == norm_f and (norm_f % 2) ~= 0 then
		return (norm_f-1)/mantissa
	end
	return norm_f/mantissa
end


function Visor2GUI:OnEnable()
	self:RegisterEvent("VISOR_UPDATE")
	self:RegisterChatCommand({ "/vzg", "/Visor2GUI" }, {
		type = 'group', args = {
			toggle = {
				type = 'execute', name = L["Toggle GUI Frame"], desc = L["Toggle GUI Frame"],
				func = function()
					if Visor2GUIFrame:IsShown() then Visor2GUIFrame:Hide()
					else Visor2GUIFrame:Show() end
				end,
			},
		},
	})
end


function Visor2GUI:VISOR_UPDATE(p)
	if not Visor2GUIFrame:IsShown() then return end

	if p.f then
		self.f = p.f
		self.parent = _G[self.f]:GetParent():GetName() or nil

		if self.parent then Visor2GUIGrabParent:Enable()
		else Visor2GUIGrabParent:Disable() end

		Visor2GUITarget:SetText(L["Parent Frame"]..": |cffffffff"..(self.parent or NONE))
		Visor2GUIEditBox:SetText(self.f)

		local s = p.s or _G[self.f]:GetScale()
		Visor2GUIScale:SetValue(s or 1)

		local a = p.a or _G[self.f]:GetAlpha()
		Visor2GUIAlpha:SetValue(a or 1)

		local wh = p.wh or _G[self.f]:GetWidth()
		wh = round(wh, 0)
		Visor2GUIEditW:SetText(wh)

		local ht = p.ht or _G[self.f]:GetHeight()
		ht = round(ht, 0)
		Visor2GUIEditH:SetText(ht)

		local x, y = _G[self.f]:GetCenter()
		x = p.x or round(x, 0)
		y = p.y or round(y, 0)

		Visor2GUIEditX:SetText(x)
		Visor2GUIEditY:SetText(y)

		if _G[p.f]:IsShown() then
			Visor2GUIHide:SetText(L["Hide Frame"])
		else
			Visor2GUIHide:SetText(L["Show Frame"])
		end

		Visor2GUIHide:Enable()
		Visor2GUIDelete:Enable()
	else
		Visor2GUIHide:Disable()
		Visor2GUIDelete:Disable()
	end
end


function Visor2GUI:ShowTooltip(txt)
	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
	GameTooltip:SetText(txt)
	GameTooltip:Show()
end

function Visor2GUI:Toggle()
	if Visor2GUIFrame:IsShown() then
		Visor2GUIFrame:Hide()
	else
		Visor2GUIFrame:Show()
	end
end


function Visor2GUI:EditBoxUpdate()
	Visor2:SetupFrame("f="..this:GetText())
end

function Visor2GUI:EditWUpdate()
	local n = Visor2GUIEditW:GetText()

	Visor2:Do("wh="..n)
end

function Visor2GUI:ButtonWUp()
	local n = Visor2GUIEditW:GetText() + 1

	Visor2:Do("wh="..n)
end

function Visor2GUI:ButtonWDown()
	local n = Visor2GUIEditW:GetText() - 1

	Visor2:Do("wh="..n)
end


function Visor2GUI:EditHUpdate()
	local n = Visor2GUIEditH:GetText()

	Visor2:Do("ht="..n)
end

function Visor2GUI:ButtonHUp()
	local n = Visor2GUIEditH:GetText() + 1

	Visor2:Do("ht="..n)
end

function Visor2GUI:ButtonHDown()
	local n = Visor2GUIEditH:GetText() - 1

	Visor2:Do("ht="..n)
end


function Visor2GUI:ScaleUpdate()
	local s = round(this:GetValue(), 2)

	Visor2GUIScaleText:SetText(L["Frame Scale"]..": "..s)
	Visor2:Do("s="..s)
end

function Visor2GUI:AlphaUpdate()
	local a = round(this:GetValue(), 2)

	Visor2GUIAlphaText:SetText(L["Frame Alpha"]..": "..a)
	Visor2:Do("a="..a)
end

function Visor2GUI:HideUpdate()
	if Visor2GUIHide:GetText() == L["Hide Frame"] then
		Visor2:Do("h=TRUE")
		Visor2GUIHide:SetText(L["Show Frame"])
	else
		Visor2:Do("h=FALSE")
		Visor2GUIHide:SetText(L["Hide Frame"])
	end
end


function Visor2GUI:EditXUpdate()
	local x = Visor2GUIEditX:GetText()

	Visor2:Do("x="..x)
	Visor2GUIEditX:SetText(x)
end

function Visor2GUI:EditYUpdate()
	local y = Visor2GUIEditY:GetText()

	Visor2:Do("y="..y)
	Visor2GUIEditY:SetText(y)
end


function Visor2GUI:NudgeUpdate()
	local n = this:GetValue()

	Visor2GUINudgeText:SetText(L["Nudge Amount"]..": "..n)
	Visor2:Do("n="..n)
end

