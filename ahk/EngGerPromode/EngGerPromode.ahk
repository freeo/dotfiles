; AHK special chars
;------------------
; ! Alt
; + Shift
; ^ Ctrl
; # Win
; $ NO RECURSE 
; ` escape char
; 
; Debug
; Tooltip, message, x, y
; Tooltip, <++>, 15, 15

; English/German Promode
;-----------------------
; Description:
; This script enables changing integration of German keys. They should be
; available it both setups, but style of calling them shall be more comfortable
; by setting the primary language. This makes chatting in german less annoying as
; well as writing longer texts. Designed for US keyboard settings.
;
; Author: Arthur Jaron
; Version: 0.4
; Last Change: 19.12.2013 
;
; Explantion:
;                 default       ...+ALT       
; GER MODE        ;'[:"{        öäüÖÄÜ
; US  MODE        öäüÖÄÜ        ;'[:"{
; both modes      
;                 AltGR + e   ¿
;                 Alt + -     ß    (ß is so rare, - is way more frequent)

;end auto execution from here on
; return 

; # Function definitions #####################################################

#SingleInstance, Force

SetEnglish(){
    Menu, Tray, NoIcon
    Menu, Tray, Icon, %A_ScriptDir%\united_kingdom.ico
    Menu, Tray, Tip, Primary Lanuage:`n`nEnglish`n`n(use Alt+... for German characters)
    global language
    language := "English"
    return
}

SetGerman(){
    Menu, Tray, Icon, %A_ScriptDir%\german.ico
    Menu, Tray, Icon ; UNHIDE! The call above doesn't unhide!
    Menu, Tray, Tip, Primary Lanuage:`n`nGerman`n`n(use Alt+... for English characters)
    global language
    language := "German"
    return
}

toggleLanguage(){
    ; SetGerman()
    global language
    if (language == "English")
    {
        SetGerman()
    }
    else if (language == "German")
    {
        SetEnglish()
    }
    ; no return, will be returned within the Set<Language> functions!
}


; # Default Startup Options ##################################################

; primary language 
SetEnglish()

; # System Bindings ##########################################################

#Space::
toggleLanguage()
return


; # Bindings #################################################################

; Always active Exceptions
!-:: Send, ß ; ! Alt + - = ß
!e:: Send, € ; Euro-Char
!`:: Send, ° ; Degree-char from German layout


global language
#If language == "German"

$`;:: Send, ö
$':: Send, ä
$[:: Send, ü
$+':: Send, Ä
$+;:: Send, Ö
$+[:: Send, Ü

$!;:: Send,;
$!+;:: Send,:
$!':: Send, {'}
$!+':: Send, {"}
$![:: Send, {[}
$!+[:: Send, {{}

#If (language == "English" and !(WinActive("ahk_class gdkWindowToplevel"))a)
$!`;:: Send, ö
$!':: Send, ä
$![:: Send, ü
$!+':: Send, Ä
$!+;:: Send, Ö
$!+[:: Send, Ü

; Pidgin
#If (language == "English" and WinActive("ahk_class gdkWindowToplevel"))
$!`;:: SendInput, ^+{u}00f6{Space}
$!':: SendInput, ^+{u}00e4{Space}
$![:: SendInput, ^+{u}00fc{Space}
$!+':: SendInput, ^+{u}00c4{Space}
$!+;:: SendInput, ^+{u}00d6{Space}
$!+[:: SendInput, ^+{u}00dc{Space}
$!-:: SendInput, ^+{u}00df{Space}
