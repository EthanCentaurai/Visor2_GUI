--[[ $Id$ ]]

local L = AceLibrary("AceLocale-2.2"):new("Visor2GUI")
local alpha = 1

-- wee! complex gui frame creation is fun!
local frame = CreateFrame("Frame", "Visor2GUIFrame", UIParent)
tinsert(UISpecialFrames, "Visor2GUIFrame")
frame:Hide()
frame:SetWidth(400)
frame:SetHeight(400)
frame:SetPoint("CENTER", UIParent, "CENTER")
frame:SetFrameLevel(9)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function(this) this:StartMoving() end)
frame:SetScript("OnDragStop", function(this) this:StopMovingOrSizing() end)
frame:SetScript("OnUpdate", function(this, elapsed)
	-- this function borrowed from RockConfig-1.0
	if MouseIsOver(this) then
		if alpha < 1 then alpha = alpha + elapsed/.15 end
		if alpha >= 1 then alpha = 1 end
	else
		if alpha > .25 then alpha = alpha - elapsed/.15 end
		if alpha <= .25 then alpha = .25 end
	end
	this:SetAlpha(alpha)
end)
frame:SetBackdrop({
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	insets = { left = 5, right = 5, top = 5, bottom = 5 },
	tile = true, tileSize = 16, edgeSize = 16,
})
frame:SetBackdropColor(0.09, 0.09, 0.19)
frame:SetBackdropBorderColor(0.5, 0.5, 0.5)

local texture = frame:CreateTexture(nil, "ARTWORK")
texture:SetWidth(300)
texture:SetHeight(48)
texture:SetPoint("TOP", 0, 15)
texture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")

local header = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
header:SetPoint("TOP", 0, 7)
header:SetText(L["Visor2 GUI"])

local editBox = CreateFrame("EditBox", "Visor2GUIEditBox", frame, "InputBoxTemplate")
editBox:SetWidth(325)
editBox:SetHeight(20)
editBox:SetPoint("TOP", frame, "TOP", 0, -47)
editBox:SetAutoFocus(false)
editBox:SetScript("OnEnterPressed", function() Visor2GUI:EditBoxUpdate() end)

local editBoxLabel = editBox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
editBoxLabel:SetPoint("TOP", 0, 20)
editBoxLabel:SetText(L["Enter frame name or select frame with Grab button"])

local target = frame:CreateFontString("Visor2GUITarget", "ARTWORK", "GameFontNormal")
target:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT")

local grabParent = CreateFrame("Button", "Visor2GUIGrabParent", frame, "GameMenuButtonTemplate")
grabParent:SetWidth(100)
grabParent:SetHeight(25)
grabParent:SetPoint("TOPRIGHT", editBox, "BOTTOMRIGHT")
grabParent:SetText(L["Grab Parent"])
grabParent:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Set the active frame's parent frame as the active frame"]) end)
grabParent:SetScript("OnLeave", function() GameTooltip:Hide() end)
grabParent:SetScript("OnClick", function() Visor2:SetupFrame("f="..Visor2GUI.parent) end)

-- sliders
local scaleSlider = CreateFrame("Slider", "Visor2GUIScale", frame, "OptionsSliderTemplate")
scaleSlider:SetWidth(120)
scaleSlider:SetHeight(16)
scaleSlider:SetPoint("TOP", 90, -110)
scaleSlider:SetMinMaxValues(0.05, 3)
scaleSlider:SetValueStep(0.05)
scaleSlider:SetValue(1)
scaleSlider:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Adjust frame size"]) end)
scaleSlider:SetScript("OnLeave", function() GameTooltip:Hide() end)
scaleSlider:SetScript("OnValueChanged", function() Visor2GUI:ScaleUpdate() end)

local alphaSlider = CreateFrame("Slider", "Visor2GUIAlpha", frame, "OptionsSliderTemplate")
alphaSlider:SetWidth(120)
alphaSlider:SetHeight(16)
alphaSlider:SetPoint("TOP", scaleSlider, "BOTTOM", 0, -30)
alphaSlider:SetMinMaxValues(0, 1)
alphaSlider:SetValueStep(0.05)
alphaSlider:SetValue(1)
alphaSlider:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Adjust frame transparency"]) end)
alphaSlider:SetScript("OnLeave", function() GameTooltip:Hide() end)
alphaSlider:SetScript("OnValueChanged", function() Visor2GUI:AlphaUpdate() end)

-- nudger stuff
local nudgeSlider = CreateFrame("Slider", "Visor2GUINudge", frame, "OptionsSliderTemplate")
nudgeSlider:SetWidth(120)
nudgeSlider:SetHeight(16)
nudgeSlider:SetPoint("BOTTOM", -85, 60)
nudgeSlider:SetMinMaxValues(1, 80)
nudgeSlider:SetValueStep(1)
nudgeSlider:SetScript("OnMouseUp", function() Visor2GUI:NudgeUpdate() end)

local nudgeLeft = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
nudgeLeft:SetWidth(20)
nudgeLeft:SetHeight(20)
nudgeLeft:SetPoint("BOTTOM", nudgeSlider, "TOP", -20, 40)
nudgeLeft:SetText("<")
nudgeLeft:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Nudge Left"]) end)
nudgeLeft:SetScript("OnLeave", function() GameTooltip:Hide() end)
nudgeLeft:SetScript("OnClick", function() Visor2GUI:NudgeLeft() end)

local nudgeRight = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
nudgeRight:SetWidth(20)
nudgeRight:SetHeight(20)
nudgeRight:SetPoint("BOTTOM", nudgeSlider, "TOP", 20, 40)
nudgeRight:SetText(">")
nudgeRight:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Nudge Right"]) end)
nudgeRight:SetScript("OnLeave", function() GameTooltip:Hide() end)
nudgeRight:SetScript("OnClick", function() Visor2GUI:NudgeRight() end)

local nudgeUp = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
nudgeUp:SetWidth(20)
nudgeUp:SetHeight(20)
nudgeUp:SetPoint("BOTTOM", nudgeSlider, "TOP", 0, 60)
nudgeUp:SetText("^")
nudgeUp:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Nudge Up"]) end)
nudgeUp:SetScript("OnLeave", function() GameTooltip:Hide() end)
nudgeUp:SetScript("OnClick", function() Visor2GUI:NudgeUp() end)

local nudgeDown = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
nudgeDown:SetWidth(20)
nudgeDown:SetHeight(20)
nudgeDown:SetPoint("BOTTOM", nudgeSlider, "TOP", 0, 20)
nudgeDown:SetText("v")
nudgeDown:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Nudge Down"]) end)
nudgeDown:SetScript("OnLeave", function() GameTooltip:Hide() end)
nudgeDown:SetScript("OnClick", function() Visor2GUI:NudgeDown() end)

-- edit width
local editW = CreateFrame("EditBox", "Visor2GUIEditW", frame, "InputBoxTemplate")
editW:SetWidth(40)
editW:SetHeight(20)
editW:SetPoint("TOP", -83, -110)
editW:SetAutoFocus(false)
editW:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Enter Width"]) end)
editW:SetScript("OnLeave", function() GameTooltip:Hide() end)
editW:SetScript("OnEnterPressed", function() Visor2GUI:EditWUpdate() end)

local editWLabel = editW:CreateFontString(nil, "ARTWORK", "GameFontNormal")
editWLabel:SetPoint("TOP", -20, 15)
editWLabel:SetText(L["Frame Width"])

local editWDown = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
editWDown:SetWidth(20)
editWDown:SetHeight(20)
editWDown:SetPoint("RIGHT", editW, "LEFT", -34, 0)
editWDown:SetText("<")
editWDown:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Width Down"]) end)
editWDown:SetScript("OnLeave", function() GameTooltip:Hide() end)
editWDown:SetScript("OnClick", function() Visor2GUI:ButtonWDown() end)

local editWUp = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
editWUp:SetWidth(20)
editWUp:SetHeight(20)
editWUp:SetPoint("RIGHT", editW, "LEFT", -10, 0)
editWUp:SetText(">")
editWUp:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Width Up"]) end)
editWUp:SetScript("OnLeave", function() GameTooltip:Hide() end)
editWUp:SetScript("OnClick", function() Visor2GUI:ButtonWUp() end)

-- edit height
local editH = CreateFrame("EditBox", "Visor2GUIEditH", frame, "InputBoxTemplate")
editH:SetWidth(40)
editH:SetHeight(20)
editH:SetPoint("TOP", editW, "BOTTOM", 0, -27)
editH:SetAutoFocus(false)
editH:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Enter Height"]) end)
editH:SetScript("OnLeave", function() GameTooltip:Hide() end)
editH:SetScript("OnEnterPressed", function() Visor2GUI:EditHUpdate() end)

local editHLabel = editH:CreateFontString(nil, "ARTWORK", "GameFontNormal")
editHLabel:SetPoint("TOP", -20, 15)
editHLabel:SetText(L["Frame Height"])

local editHDown = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
editHDown:SetWidth(20)
editHDown:SetHeight(20)
editHDown:SetPoint("RIGHT", editH, "LEFT", -10, 0)
editHDown:SetText("v")
editHDown:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Height Down"]) end)
editHDown:SetScript("OnLeave", function() GameTooltip:Hide() end)
editHDown:SetScript("OnClick", function() Visor2GUI:ButtonHDown() end)

local editHUp = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
editHUp:SetWidth(20)
editHUp:SetHeight(20)
editHUp:SetPoint("RIGHT", editH, "LEFT", -34, 0)
editHUp:SetText("^")
editHUp:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Height Up"]) end)
editHUp:SetScript("OnLeave", function() GameTooltip:Hide() end)
editHUp:SetScript("OnClick", function() Visor2GUI:ButtonHUp() end)

-- edit co-ordinates
local editX = CreateFrame("EditBox", "Visor2GUIEditX", frame, "InputBoxTemplate")
editX:SetWidth(40)
editX:SetHeight(20)
editX:SetPoint("BOTTOM", 120, 150)
editX:SetAutoFocus(false)
editX:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Enter X co-ordinate (center point of frame)"]) end)
editX:SetScript("OnLeave", function() GameTooltip:Hide() end)
editX:SetScript("OnEnterPressed", function() Visor2GUI:EditXUpdate() end)

local editXLabel = editX:CreateFontString(nil, "ARTWORK", "GameFontNormal")
editXLabel:SetPoint("RIGHT", editX, "LEFT", -10, 0)
editXLabel:SetText("X")

local editY = CreateFrame("EditBox", "Visor2GUIEditY", frame, "InputBoxTemplate")
editY:SetWidth(40)
editY:SetHeight(20)
editY:SetPoint("TOP", editX, "BOTTOM", 0, -14)
editY:SetAutoFocus(false)
editY:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Enter Y co-ordinate (center point of frame)"]) end)
editY:SetScript("OnLeave", function() GameTooltip:Hide() end)
editY:SetScript("OnEnterPressed", function() Visor2GUI:EditYUpdate() end)

local editYLabel = editY:CreateFontString(nil, "ARTWORK", "GameFontNormal")
editYLabel:SetPoint("RIGHT", editY, "LEFT", -10, 0)
editYLabel:SetText("Y")

-- other buttons
local grab = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
grab:SetWidth(50)
grab:SetHeight(25)
grab:SetPoint("BOTTOM", 0, 15)
grab:SetText(L["Grab"])
grab:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Left-Click and hold the mouse button, move the mouse over a frame and release the button to select that frame"]) end)
grab:SetScript("OnLeave", function() GameTooltip:Hide() end)
grab:SetScript("OnMouseDown", function() target:SetText(L["Drag mouse and release on target frame"]) end)
grab:SetScript("OnMouseUp", function() Visor2:SetupFrame("gf=TRUE") end)

local done = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
done:SetWidth(100)
done:SetHeight(25)
done:SetPoint("BOTTOM", 85, 15)
done:SetText(L["Done"])
done:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Exit Visor2 GUI"]) end)
done:SetScript("OnLeave", function() GameTooltip:Hide() end)
done:SetScript("OnClick", function() this:GetParent():Hide() end)

local del = CreateFrame("Button", "Visor2GUIDelete", frame, "GameMenuButtonTemplate")
del:SetWidth(100)
del:SetHeight(25)
del:SetPoint("BOTTOM", -85, 15)
del:SetText(L["Delete"])
del:Disable()
del:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Delete the selected frame's settings from Visor2"]) end)
del:SetScript("OnLeave", function() GameTooltip:Hide() end)

local hide = CreateFrame("Button", "Visor2GUIHide", frame, "GameMenuButtonTemplate")
hide:SetWidth(110)
hide:SetHeight(25)
hide:SetPoint("TOP", 0, -190)
hide:SetText(L["Hide Frame"])
hide:Disable()
hide:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Show/Hide the selected frame"]) end)
hide:SetScript("OnLeave", function() GameTooltip:Hide() end)
hide:SetScript("OnClick", function() Visor2GUI:HideUpdate() end)

local virtual = CreateFrame("Button", "Visor2GUIVirt", frame, "GameMenuButtonTemplate")
virtual:SetWidth(75)
virtual:SetHeight(25)
virtual:SetPoint("BOTTOM", 87, 50)
virtual:SetText(L["Virtual"])
virtual:Disable()
virtual:SetScript("OnEnter", function() Visor2GUI:ShowTooltip(L["Show a virtual copy of a hidden frame"]) end)
virtual:SetScript("OnLeave", function() GameTooltip:Hide() end)
virtual:SetScript("OnClick", function() Visor2GUI:ButtonVirt() end)

-- confirmation
local confirm = CreateFrame("Frame", "Visor2GUIConfirmFrame", UIParent)
tinsert(UISpecialFrames, "Visor2GUIConfirmFrame")
confirm:Hide()
confirm:SetWidth(450)
confirm:SetHeight(200)
confirm:SetPoint("CENTER", "UIParent", "CENTER")
confirm:SetToplevel(1)
confirm:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	insets = { left = 5, right = 6, top = 5, bottom = 6 },
	tile = true, tileSize = 32, edgeSize = 32,
})

del:SetScript("OnClick", function() confirm:Show() end)

local confirmText1 = confirm:CreateFontString(nil, "ARTWORK", "GameFontNormal")
confirmText1:SetPoint("TOP", 0, -50)
confirmText1:SetText(L["Are you sure you want to delete this frame's settings?"])

local confirmLabel = confirm:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
confirmLabel:SetPoint("TOP", confirmText1, "BOTTOM", 0, -25)

confirm:SetScript("OnShow", function() confirmLabel:SetText(Visor2GUI.f) end)

local confirmText2 = confirm:CreateFontString(nil, "ARTWORK", "GameFontNormal")
confirmText2:SetPoint("TOP", confirmLabel, "BOTTOM", 0, -30)
confirmText2:SetText(L["You will need to reload for any changes to take effect"])

local confirmDel = CreateFrame("Button", nil, confirm, "GameMenuButtonTemplate")
confirmDel:SetWidth(100)
confirmDel:SetHeight(22)
confirmDel:SetPoint("BOTTOMLEFT", 25, 15)
confirmDel:SetText(L["Delete"])
confirmDel:SetScript("OnClick", function() Visor2:DeleteFrame(Visor2GUI.f) confirm:Hide() end)

local confirmCancel = CreateFrame("Button", nil, confirm, "GameMenuButtonTemplate")
confirmCancel:SetWidth(100)
confirmCancel:SetHeight(22)
confirmCancel:SetPoint("BOTTOMRIGHT", -25, 15)
confirmCancel:SetText(L["Cancel"])
confirmCancel:SetScript("OnClick", function() confirm:Hide() end)
