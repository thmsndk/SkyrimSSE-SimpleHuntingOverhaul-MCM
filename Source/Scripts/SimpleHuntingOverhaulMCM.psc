Scriptname SimpleHuntingOverhaulMCM extends SKI_ConfigBase  

GlobalVariable Property _HuntingXP Auto
GlobalVariable Property GameHour Auto
GlobalVariable Property _FadeTimePass Auto
GlobalVariable Property _RemovePelts Auto
GlobalVariable Property SHO_S Auto ; 0x07000841
GlobalVariable Property SHO_M Auto ; 0x07000842
GlobalVariable Property SHO_L Auto ; 0x07000843
GlobalVariable Property SHO_XL Auto ; 0x07000844
GlobalVariable Property SHO_XXL Auto ; 0x07000845
; GlobalVariable Property SHO_GuardDialogueTracker Auto

; MCM Helper perhaps? https://github.com/Exit-9B/MCM-Helper/wiki

Event OnConfigInit()
    ModName = "Simple Hunting Overhaul"
    Pages = new string[1]
    Pages[0] = "Settings"

    ; Load references to SHO globals
    SHO_S = Game.GetFormFromFile(0x07000841, "Simple Hunting Overhaul.esp") AS GlobalVariable
    SHO_M  = Game.GetFormFromFile(0x07000842, "Simple Hunting Overhaul.esp") AS GlobalVariable
    SHO_L  = Game.GetFormFromFile(0x07000843, "Simple Hunting Overhaul.esp") AS GlobalVariable
    SHO_XL  = Game.GetFormFromFile(0x07000844, "Simple Hunting Overhaul.esp") AS GlobalVariable
    SHO_XXL  = Game.GetFormFromFile(0x07000845, "Simple Hunting Overhaul.esp") AS GlobalVariable
EndEvent

Event OnPageReset(string pageName)
    ; TODO: We could randomize gold in a min, max range if you have a carcass and we initialize a dialogue
    ; It could also be varied depending on weight of the carcass
    ; We could perhaps also modify the weight of the item.

    ; Script properties on the fragments are responsible for setting the reward property depending on the dialogue
    ; Skeever, Dog
    AddTextOption("Small Carcass Reward", SHO_S.GetValue());
    
    ; Wolf, Ice Wolf, Fox, Snow Fox, Chicken, Hare, Slaughterfish, Mudcrab
    AddTextOption("Medium Carcass Reward", SHO_M.GetValue());
    
    ; Goat, Large Mudcrab, Giant Mudcrab
    AddTextOption("Large Carcass Reward", SHO_L.GetValue());
    
    ; Deer, Elk Male, Elk Female
    AddTextOption("XL Carcass Reward", SHO_XL.GetValue());
    
    ; Vale Deer
    AddTextOption("XXL Carcass Rewardi", SHO_XXL.GetValue());
EndEvent

; https://ck.uesp.net/wiki/Global
; GlobalVariable Property GameHour  auto

; _FadeTimePass [GLOB:FE001821]
; _HuntingXP [GLOB:FE001822]
; _EnablePermits [GLOB:FE00183D]

; GlobalVariable Property _HuntingXP Auto
; GlobalVariable Property GameHour Auto
; GlobalVariable Property _FadeTimePass Auto
; GlobalVariable Property _RemovePelts Auto

; ;Hello MaskedRPGFan, fancy meeting you here!
; ; _FadeTimePass == 0 means that no time passes and there's no fadeout of the screen
; ; _FadeTimePass == 1 means both time and fadeout of the screen happen. This is the default.
; ; _FadeTimePass == 2 means only fadeout of the screen happens
; ; _FadeTimePass == 3 means only time passes

; SHO_S [GLOB:FE001841]
; SHO_M [GLOB:FE001842]
; SHO_L [GLOB:FE001843]
; SHO_XL [GLOB:FE001844]
; SHO_XXL [GLOB:FE001845]
; SHO_GuardDialogueTracker [GLOB:FE00187E]

; - You can disable the skinned animal look by typing "Set _RemovePelts to 0"
; - You can disable the need for a permit by typing "Set _EnablePermits to 0"
; - You can disable the time passing + fadeout effect of looting by typing "Set _FadeTimePass to 0"
; - You can disable the time passing of looting by typing "Set _FadeTimePass to 2"
; - You can disable the fadeout effect of looting by typing "Set _FadeTimePass to 3"