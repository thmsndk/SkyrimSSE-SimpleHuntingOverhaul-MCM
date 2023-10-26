Scriptname SimpleHuntingOverhaulMCM extends SKI_ConfigBase

GlobalVariable Property _HuntingXP Auto ; FE004822

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
EndEvent

Event OnPageReset(string pageName)
    
    ; TODO: We could randomize gold in a min, max range if you have a carcass and we initialize a dialogue
    ; It could also be varied depending on weight of the carcass
    ; We could perhaps also modify the weight of the item.
    SetCursorFillMode(TOP_TO_BOTTOM)
    
    ; Left Column
    ; ; _FadeTimePass == 0 means that no time passes and there's no fadeout of the screen
    ; ; _FadeTimePass == 1 means both time and fadeout of the screen happen. This is the default.
    ; ; _FadeTimePass == 2 means only fadeout of the screen happens
    ; ; _FadeTimePass == 3 means only time passes
    ; - You can disable the skinned animal look by typing "Set _RemovePelts to 0"
    ; - You can disable the need for a permit by typing "Set _EnablePermits to 0"
    ; - You can disable the time passing + fadeout effect of looting by typing "Set _FadeTimePass to 0"
    ; - You can disable the time passing of looting by typing "Set _FadeTimePass to 2"
    ; - You can disable the fadeout effect of looting by typing "Set _FadeTimePass to 3"
    
    ; TODO: DropDown lookup for text representation
    menuFadeTimePass_OID    = AddMenuOption("FadeTimePass", menuFadeTimePassOptions[SHO_FadeTimePass.GetValueInt()])
    toggleRemovePelts_OID   = AddToggleOption("Enable skinned animal look", SHO_RemovePelts.GetValue())
    toggleEnablePermits_OID = AddToggleOption("Enable hunting permits", SHO_EnablePermits.GetValue())
    
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

; https://ck.uesp.net/wiki/Global
; GlobalVariable Property GameHour  auto
; _FadeTimePass [GLOB:FE001821]
; _HuntingXP [GLOB:FE001822]
; _EnablePermits [GLOB:FE00183D]
; GlobalVariable Property _HuntingXP Auto
; GlobalVariable Property GameHour Auto
; GlobalVariable Property _FadeTimePass Auto
; GlobalVariable Property _RemovePelts Auto
; SHO_S [GLOB:FE001841]
; SHO_M [GLOB:FE001842]
; SHO_L [GLOB:FE001843]
; SHO_XL [GLOB:FE001844]
; SHO_XXL [GLOB:FE001845]
; SHO_GuardDialogueTracker [GLOB:FE00187E]
