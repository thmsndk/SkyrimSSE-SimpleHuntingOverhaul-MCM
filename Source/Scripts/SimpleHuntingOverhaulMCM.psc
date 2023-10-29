Scriptname SimpleHuntingOverhaulMCM extends SKI_ConfigBase

GlobalVariable Property SHO_HuntingXP Auto ; FE004822

; GlobalVariable Property GameHour Auto
GlobalVariable Property SHO_FadeTimePass   Auto ; FE004821
GlobalVariable Property SHO_RemovePelts    Auto ; FE0048E4
GlobalVariable Property SHO_EnablePermits  Auto ; FE00483D
GlobalVariable Property SHO_S           Auto ; 0x07000841
GlobalVariable Property SHO_M           Auto ; 0x07000842
GlobalVariable Property SHO_L           Auto ; 0x07000843
GlobalVariable Property SHO_XL          Auto ; 0x07000844
GlobalVariable Property SHO_XXL         Auto ; 0x07000845

; GlobalVariable Property SHO_GuardDialogueTracker Auto ; FE00487E

int menuFadeTimePass_OID
string[] menuFadeTimePassOptions
string[] menuFadeTimePassOptionsDescription

int toggleRemovePelts_OID
int toggleEnablePermits_OID

string sliderGoldFormat = "{0} Gold"
int sliderSHO_S_OID
int sliderSHO_M_OID
int sliderSHO_L_OID
int sliderSHO_XL_OID
int sliderSHO_XXL_OID

; MCM Helper perhaps? https://github.com/Exit-9B/MCM-Helper/wiki
Event OnConfigInit()
    ModName = "Simple Hunting Overhaul"
    
    ; Load references to SHO globals
    SHO_FadeTimePass  = Game.GetFormFromFile(0x07004821, "Simple Hunting Overhaul.esp") AS GlobalVariable
    SHO_RemovePelts   = Game.GetFormFromFile(0x070048E4, "Simple Hunting Overhaul.esp") AS GlobalVariable
    SHO_EnablePermits = Game.GetFormFromFile(0x0700483D, "Simple Hunting Overhaul.esp") AS GlobalVariable
    
    SHO_S    = Game.GetFormFromFile(0x07000841, "Simple Hunting Overhaul.esp") AS GlobalVariable
    SHO_M    = Game.GetFormFromFile(0x07000842, "Simple Hunting Overhaul.esp") AS GlobalVariable
    SHO_L    = Game.GetFormFromFile(0x07000843, "Simple Hunting Overhaul.esp") AS GlobalVariable
    SHO_XL   = Game.GetFormFromFile(0x07000844, "Simple Hunting Overhaul.esp") AS GlobalVariable
    SHO_XXL  = Game.GetFormFromFile(0x07000845, "Simple Hunting Overhaul.esp") AS GlobalVariable
    
    menuFadeTimePassOptions = new string[4]
    menuFadeTimePassOptions[0] = "No time pass, No Fadeout"
    menuFadeTimePassOptions[1] = "Time pass, Fadeout"
    menuFadeTimePassOptions[2] = "Only fadeout"
    menuFadeTimePassOptions[3] = "Only time pass"
    
    menuFadeTimePassOptionsDescription = new string[4]
    menuFadeTimePassOptionsDescription[0] = "No time passes and there's no fadeout of the screen"
    menuFadeTimePassOptionsDescription[1] = "Both time and fadeout of the screen happen. This is the default."
    menuFadeTimePassOptionsDescription[2] = "only fadeout of the screen happens"
    menuFadeTimePassOptionsDescription[3] = "only time passes"
    
    SHO_HuntingXP  = Game.GetFormFromFile(0x07004822, "Simple Hunting Overhaul.esp") AS GlobalVariable
    
EndEvent

Event OnPageReset(string pageName)
    
    ; TODO: We could randomize gold in a min, max range if you have a carcass and we initialize a dialogue
    ; It could also be varied depending on weight of the carcass
    ; We could perhaps also modify the weight of the item.
    SetCursorFillMode(TOP_TO_BOTTOM)
    
    ; Left Column
    AddHeaderOption("Settings")
    
    menuFadeTimePass_OID    = AddMenuOption("When looting kill", menuFadeTimePassOptions[SHO_FadeTimePass.GetValueInt()])
    toggleRemovePelts_OID   = AddToggleOption("Enable skinned animal look", SHO_RemovePelts.GetValue())
    toggleEnablePermits_OID = AddToggleOption("Enable hunting permits", SHO_EnablePermits.GetValue())
    
    ; SimpleHuntingOverhaul_Alias.psc is responsible for passing time,
    ; the time it takes depends on your current hunting xp
    ; each item added increases your hunting xp
    AddHeaderOption("Experience")
    int currentXP = SHO_HuntingXP.GetValueInt();
    AddTextOption("Experience", currentXP+" / 100")
    
    If  currentXP < 10
        ; howlong = 2.0
    AddTextOption("    Two hours pass while you retrieve the pelt...", "")
    elseif currentXP < 20
        ; howlong = 1.5
    AddTextOption("    An hour and half pass while you retrieve the pelt...", "")
    elseif currentXP < 30
        ; howlong = 1.3
    AddTextOption("    Around one hour passes...", "")
    elseif currentXP < 40
        ; howlong = 1.0
    AddTextOption("    One hour passes...", "")
    elseif currentXP < 50
        ; howlong = 0.7
    AddTextOption("    Less than one hour passes...", "")
    elseif currentXP < 60
        ; howlong = 0.5
    AddTextOption("    Half an hour passes...", "")
    elseif currentXP < 70
        ; howlong = 0.4
    AddTextOption("    Less than half an hour passes...", "")
    elseif currentXP < 80
        ; howlong = 0.3
    AddTextOption("    A quarter of an hour passes...", "")
    elseif currentXP < 90
        ; howlong = 0.2
    AddTextOption("    Ten minutes pass...", "")
    else
        ; howlong = 0.1
    AddTextOption("    A few minutes pass...", "")
    endif
    
    ; Right Column
    SetCursorPosition(1)
    AddHeaderOption("Gold Rewards")
    
    ; Script properties on the fragments are responsible for setting the reward property depending on the dialogue
    ; Skeever, Dog
    sliderSHO_S_OID = AddSliderOption("Small Carcass Reward", SHO_S.GetValue(), sliderGoldFormat);
    
    ; Wolf, Ice Wolf, Fox, Snow Fox, Chicken, Hare, Slaughterfish, Mudcrab
    sliderSHO_M_OID = AddSliderOption("Medium Carcass Reward", SHO_M.GetValue(), sliderGoldFormat);
    
    ; Goat, Large Mudcrab, Giant Mudcrab
    sliderSHO_L_OID = AddSliderOption("Large Carcass Reward", SHO_L.GetValue(), sliderGoldFormat);
    
    ; Deer, Elk Male, Elk Female
    sliderSHO_XL_OID = AddSliderOption("XL Carcass Reward", SHO_XL.GetValue(), sliderGoldFormat);
    
    ; Vale Deer
    sliderSHO_XXL_OID = AddSliderOption("XXL Carcass Reward", SHO_XXL.GetValue(), sliderGoldFormat);
    
EndEvent

; @implements SKI_ConfigBase
event OnOptionSelect(int a_option)
	{Called when the user selects a non-dialog option}
	
	if (a_option == toggleRemovePelts_OID)
        int value = SHO_RemovePelts.GetValueInt()

        if(value == 1)
            SHO_RemovePelts.SetValueInt(0)
            SetToggleOptionValue(a_option, 0)
        else
            SHO_RemovePelts.SetValueInt(1)
            SetToggleOptionValue(a_option, 1)
        endIf

	elseIf (a_option == toggleEnablePermits_OID)
		int value = SHO_EnablePermits.GetValueInt()
        
        if(value == 1)
            SHO_EnablePermits.SetValueInt(0)
            SetToggleOptionValue(a_option, 0)
        else
            SHO_EnablePermits.SetValueInt(1)
            SetToggleOptionValue(a_option, 1)
        endIf

	endIf
endEvent

; @implements SKI_ConfigBase
event OnOptionSliderOpen(int a_option)
    {Called when the user selects a slider option}
    OnRewardSliderOpen(a_option)
endEvent

Function OnRewardSliderOpen(int a_option)
    float value = 0
    if (a_option == sliderSHO_S_OID)
        value = SHO_S.GetValue()
    endIf
    
    if (a_option == sliderSHO_M_OID)
        value = SHO_M.GetValue()
    endIf
    
    if (a_option == sliderSHO_L_OID)
        value = SHO_L.GetValue()
    endIf
    
    if (a_option == sliderSHO_XL_OID)
        value = SHO_XL.GetValue()
    endIf
    
    if (a_option == sliderSHO_XXL_OID)
        value = SHO_XXL.GetValue()
    endIf
    
    SetSliderDialogStartValue(value)
    
    ; SetSliderDialogDefaultValue(50)
    SetSliderDialogRange(0, value*10)
    SetSliderDialogInterval(5)
EndFunction

Function OnRewardSliderAccept(int a_option, float a_value)
    if (a_option == sliderSHO_S_OID)
        SHO_S.SetValue(a_value)
    endIf
    
    if (a_option == sliderSHO_M_OID)
        SHO_M.SetValue(a_value)
    endIf
    
    if (a_option == sliderSHO_L_OID)
        SHO_L.SetValue(a_value)
    endIf
    
    if (a_option == sliderSHO_XL_OID)
        SHO_XL.SetValue(a_value)
    endIf
    
    if (a_option == sliderSHO_XXL_OID)
        SHO_XXL.SetValue(a_value)
    endIf
    
    SetSliderOptionValue(a_option, a_value, sliderGoldFormat)
EndFunction

; @implements SKI_ConfigBase
event OnOptionSliderAccept(int a_option, float a_value)
    {Called when the user accepts a new slider value}
    OnRewardSliderAccept(a_option, a_value)
endEvent

; @implements SKI_ConfigBase
event OnOptionHighlight(int a_option)
    {Called when the user highlights an option}
    if (a_option == sliderSHO_S_OID)
        SetInfoText("Small Carcass: Skeever, Dog")
    endIf
    
    if (a_option == sliderSHO_M_OID)
        SetInfoText("Medium Carcass: Wolf, Ice Wolf, Fox, Snow Fox, Chicken, Hare, Slaughterfish, Mudcrab")
    endIf
    
    if (a_option == sliderSHO_L_OID)
        SetInfoText("Large Carcass: Goat, Large Mudcrab, Giant Mudcrab")
    endIf
    
    if (a_option == sliderSHO_XL_OID)
        SetInfoText("XL Carcass: Deer, Elk Male, Elk Female")
    endIf
    
    if (a_option == sliderSHO_XXL_OID)
        SetInfoText("XXL Carcass: Vale Deer")
    endIf
    
    If (a_option == menuFadeTimePass_OID)
        string description = menuFadeTimePassOptionsDescription[SHO_FadeTimePass.GetValueInt()]
        SetInfoText(description)
    EndIf
    
endEvent

; @implements SKI_ConfigBase
event OnOptionMenuOpen(int a_option)
    {Called when the user selects a menu option}
    
    if (a_option == menuFadeTimePass_OID)
        SetMenuDialogStartIndex(SHO_FadeTimePass.GetValueInt())
        SetMenuDialogDefaultIndex(0)
        SetMenuDialogOptions(menuFadeTimePassOptions)
    endIf
    
endEvent

; @implements SKI_ConfigBase
event OnOptionMenuAccept(int a_option, int a_index)
    {Called when the user accepts a new menu entry}
    
    if (a_option == menuFadeTimePass_OID)
        SHO_FadeTimePass.SetValueInt(a_index)
        SetMenuOptionValue(a_option, menuFadeTimePassOptions[a_index])
    endIf
    
endEvent

