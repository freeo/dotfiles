; # Bindings #################################################################
; ! Alt
; + Shift
; ^ Ctrl
; # Win
; $ NO RECURSE 
; ` escape char
; < only left modifier : <+ Left shift only
; > only right modifier

; # Settings #################################################################
; SetWorkingDir, %A_ScriptDir%

#Include %A_ScriptDir%/EnvCloudFolder.ahk
; provies %CloudFolder%

Menu, Tray, Icon, %CloudFolder%\system\christmas_star.ico

DetectHiddenWindows, On ; Tells AHK to search for windows that are minimized/hidden

#SingleInstance, Force
DetectHiddenText, On
; #NoEnv
; disables default access to environment variables
; Avoids checking empty variables to see if they are environment variables (recommended for all new scripts).
; https://www.autohotkey.com/docs/commands/_NoEnv.htm

; #If WinActive("ahk_class RiotWindowClass")
; $LButton::RButton
; $RButton::LButton


;XXX NoEnv makes %computername% unaccessible! Why do i need NoEnv? 
;


; on startup: deactivate caps lock ALWAYS
SetCapsLockState, Off

; init ########################################################################

global gameTimerActive
gameTimerActive := 0

; needs to be before initial RETURN
GroupAdd, FruityLoops, ahk_class TFruityLoopsMainForm
GroupAdd, FruityLoops, ahk_class TPlugListForm
GroupAdd, Browsers, ahk_class MozillaWindowClass
GroupAdd, Browsers, ahk_class Chrome_WidgetWin_1

; # Functions #################################################################

Explorer_GetSelection(hwnd="") {
    ; Get the full filepath + name of the currently selected file inside 
    ; the explorer window.
    hwnd := hwnd ? hwnd : WinExist("A")
    WinGetClass class, ahk_id %hwnd%
    if (class="CabinetWClass" or class="ExploreWClass" or class="Progman")
            for window in ComObjCreate("Shell.Application").Windows
                    if (window.hwnd==hwnd)
    sel := window.Document.SelectedItems
    for item in sel
        ToReturn .= item.path "`n"
        return Trim(ToReturn,"`n")
}

OpenVim(Admin="") {
    path_name := % Explorer_GetSelection()
    if (Admin) {
        Run *RunAs C:\Program Files\Vim\vim80\gvim.exe --servername "ADMIN MODE" --remote-silent "%path_name%",,,OutputVarPID
    }
    else {
        ; Run, C:\Program Files\Vim\vim80\gvim.exe --servername "GVIM" --remote-silent "%path_name%",,,OutputVarPID
        ; NVIM temp workaround
        Run, nvr --servername "%NVIM_LISTEN_ADRESS%" --remote-silent "%path_name%",,Hide,OutputVarPID
        WinWait ahk_pid %OutputVarPID%.
        WinActivate, Neovim


    }
    ; WinWait, ahk_pid %OutputVarPID%
    ; WinActivate, ahk_pid %OutputVarPID%
    return
}

; ShortNote (Vocabulary) ######################################################

; Global, invisble input of a short note (english vocabluray), which will
; be appended to an existing file. {PrintScreen} to begin, same to quit, or
; {Esc},{Enter} or "jk" to Smash-Escape Vim-style.
InputShortNote(){
    soundBegin = E:\3o projects\System\Sounds\notifications\One.mp3
    soundDone = E:\3o projects\System\Sounds\notifications\Ascend.mp3
    soundError = E:\3o projects\System\Sounds\notifications\piano.mp3
    SoundPlay, %soundBegin% 
    global shortNoteActive
    shortNoteActive := 1
    Input,shortNote,* C I,{PrintScreen}{Enter}{Esc},jk
    shortNoteActive := 0
    StringReplace, shortNote, shortNote,jk,,
    ; Tooltip ,%shortnote% , 10, 200 
    FormatTime,Now,,yyyy-MM-dd
    FileAppend,%Now%: %shortNote%`n,E:\Dropbox\vocabulary.txt
    if ErrorLevel
        SoundPlay, %soundError% 
    else
        SoundPlay, %soundDone% 
}

; GameTimer ############################################################

hhmmssToSeconds(timestring){
    result := (60*60*substr(timestring, 1, 2))+ (60*substr(timestring, 4, 2))+ (substr(timestring, 7, 2))
    if result
        return result
    else
        return "error"
}

; Convert the specified number of seconds to hh:mm:ss format.
SecondsTOhhmmss(NumberOfSeconds)
{
    time = 19990101  ; *Midnight* of an arbitrary date.
    time += %NumberOfSeconds%, seconds
    FormatTime, hhmmss, %time% T8, hh:mm:ss
    return hhmmss
    ; FormatTime, mmss, %time%, mm:ss
    ; return NumberOfSeconds//3600 ":" mmss  ; This method is used to support more than 24 hours worth of sections.
}

; Starts a timer on its first call, stops it after a second call.
; Records timestamps, time delta, active window during first call.
; 2-file structure: a log file containing the sets and another one, which
; contains only the summarized values of the log file (external python script)

; The init part at the top of the script! It is essential for this function to
; work.

GameTimer(){
    timerStart = E:\Dropbox\System\Sounds\ui\GameTimerStart.wav
    timerEnd = E:\Dropbox\System\Sounds\ui\GameTimerEnd.wav
    global gameTimerActive
    global gameTimerTitle
    global gameTimerStartTime

    if (gameTimerActive == 0){
        gameTimerActive := 1
        FormatTime,gameTimerStartTime,,HH:mm:ss
        WinGetTitle, gameTimerTitle, A
        FormatTime,dateNow,,yyyy-MM-dd
        LogStart =
(
Title: %gameTimerTitle%
Date: %dateNow%
start: %gameTimerStartTime%
)
        FileAppend, %LogStart%`n ,E:\Dropbox\GameTimer.log
        SoundPlay, %timerStart% 
    }
    else if (gameTimerActive == 1){
        FormatTime,gameTimerEndTime,,HH:mm:ss
        timedeltaSeconds := hhmmssToSeconds(gameTimerEndTime) - hhmmssToSeconds(gameTimerStartTime)
        timedelta := SecondsTOhhmmss(timedeltaSeconds)
        LogEnd =
(
end: %gameTimerEndTime%
Time:
%timedelta%
)
        FileAppend, %LogEnd%`n`n ,E:\Dropbox\GameTimer.log
        gameTimerActive := 0
        SoundPlay, %timerEnd% 
    }
}



; # VIM Keys #################################################################

PrintScreen::
InputShortNote()
return

#Enter::
OpenVim()
return

^#Enter::
OpenVim("Admin")
return

; # Winamp Filter Script #####################################################

^F8::
; Runs a python script to filter out the currently playing song in winamp.
; Run, py E:\Python\FilterOutWinamp\filter_current_song.py,, Hide
; Run, py E:\Dropbox\Python\FilterOutWinamp\filter_current_song.py,, Hide
; Run, py %CloudFolder%\Python\FilterOutWinamp\filter_current_song.py,, Hide
Run, py %CloudFolder%\Python\FilterOutWinamp\filter_current_song.py,, Hide

return

; # F-Media Keys #############################################################

; deactivate for baldur's gate
; #IfWinNotActive ahk_class SDL_app

; #IfWinNotActive ahk_class TFruityLoopsMainForm
#IfWinNotActive ahk_group FruityLoops
F5::
IfWinNotExist ahk_class ahk_class Winamp v1.x
    return
; Otherwise, the above has set the "last found" window for use below.
ControlSend, ahk_parent, c  ; Pause/Unpause
return

F8::
IfWinNotExist ahk_class ahk_class Winamp v1.x
    return
ControlSend, ahk_parent, b  ; Next Track
return

LWin & F5::
Suspend, On
Send, {F5}
Suspend, Off
return

LWin & F8::
Suspend, On
Send, {F8}
Suspend, Off
return


; Run, % "rundll32.exe user32.dll,LockWorkStation"
; result := DllCall("user32.dll\LockWorkStation")
; gehen beide nicht, da die Funktion vollständig per registry deaktiviert wurde.

; Switch User Account
^F12:: Run, % "C:\Windows\System32\tsdiscon.exe"

; Excel
; #If WinActive("ahk_class XLMAIN")
; #IfWinActive ahk_class XLMAIN
; #If WinActive("ahk_exe Excel.exe")
; q::msgbox test
; Excel not working this way, research needed

#IfWinActive ahk_group FruityLoops
; swap p and r for less mouse -> keyboard switches
$r::p
$p::r

#IfWinActive ahk_group Browsers
; Prev Tab Left
F1::
Send, {Ctrl down}{Shift down}{Tab}{Shift up}{Ctrl up}
return

; Next Tab Right
F2::
Send, {Ctrl down}{Tab}{Ctrl up}
return

; close current tab
F3::
Send, {Ctrl down}{w}{Ctrl up}
return

; undo close tab
^F3::
Send, {Ctrl down}{Shift down}{t}{Shift up}{Ctrl up}
return


#If

; disable noob keys
; ^!Left::MsgBox,,Hahahaha!, Nice try noob...
; ^!Right::MsgBox,,Hahahaha!, Nice try noob...
; ^!Up::MsgBox,,Hahahaha!, Nice try noob...
; ^!Down::MsgBox,,Hahahaha!, Nice try noob...

; # HJKL-Movement #############################################################
#h::
Send, {Left}
return

#j::
Send, {Down}
return

#k::
Send, {Up}
return

#+h::
Send, {Alt down}{Left}{Alt up}
return

#+l::
Send, {Alt down}{Right}{Alt up}
return

; unmap reserved windows mapping first:
;  http://www.howtogeek.com/howto/windows-vista/disableenable-lock-workstation-functionality-windows-l/
#l::
Send, {Right}
return

; # General Windows Key Remaps ###############################################
#MaxHotkeysPerInterval 500
; das * sorgt dafür, dass ich die Modifier CTRL/ALT/SHIFT ruhig drücken kann.
; *CAPSLOCK::Send, {ESC} 
; *CAPSLOCK::LCtrl
; XXX observe: with or without $ (no recurse)
$*CAPSLOCK::LCtrl
; *CAPSLOCK::AppsKey

; XXX TEMP
; ~*LCtrl::PlayTick2()

; longer left shift key
SC056::LShift ; alternative vim-esc everywhere
^Esc::return ; disable builtin win hotkey
; simply remapping to Esc doesn't work
<^[::
Send, {Escape}
return

; $^Esc::return

; I never use those...
; *RWin::RCtrl
; *RCtrl::RWin
*RWin::AppsKey

#m::WinMinimize, A

; NOT WORKING:
; SC163::Send {LWIN}
; $*SC05C::Send, {RCtrl}
; *$RWin::Send, {Ctrl}
; *$RCtrl::Send, {RWin}

; Mass Effect 3 special treatment



; Old style:
; LShift & q::PlayDaaah()
; RShift & h::PlayDaaah()
; cumbersome, because key combinations which contain these hotkeys don't work
; as well.

; #If (!WinActive("ahk_class SDL_app"))

PlayDaaah() {
    ; Daaah = E:\3o projects\System\Sounds\WrongKey.mp3
    Daaah = %CloudFolder%\System\Sounds\DaaahSoft.wav
    SoundPlay, %Daaah%, wait 
}

; Learning proper shift usage #################################################

; ~ let through original key function

; ~>+7::PlayDaaah()
; ~>+8::PlayDaaah()
; ~>+9::PlayDaaah()
; ~>+0::PlayDaaah()
; ~>+-::PlayDaaah()
; ~>+=::PlayDaaah()
;
; ~>+y::PlayDaaah()
; ~>+u::PlayDaaah()
; ~>+i::PlayDaaah()
; ~>+o::PlayDaaah()
; ~>+p::PlayDaaah()
; ~>+[::PlayDaaah()
; ~>+]::PlayDaaah()
;
; ~>+h::PlayDaaah()
; ~>+j::PlayDaaah()
; ~>+k::PlayDaaah()
; ~>+l::PlayDaaah()
; ~>+`;::PlayDaaah()
; ~>+'::PlayDaaah()
; ~>+\::PlayDaaah()
;
; ~>+n::PlayDaaah()
; ~>+m::PlayDaaah()
; ~>+,::PlayDaaah()
; ~>+.::PlayDaaah()
; ~>+/::PlayDaaah()
;
; ~<+1::PlayDaaah()
; ~<+2::PlayDaaah()
; ~<+3::PlayDaaah()
; ~<+4::PlayDaaah()
; ~<+5::PlayDaaah()
; ~<+6::PlayDaaah()
;
; ~<+q::PlayDaaah()
; ~<+w::PlayDaaah()
; ~<+e::PlayDaaah()
; ~<+r::PlayDaaah()
; ~<+t::PlayDaaah()
;
; ~<+a::PlayDaaah()
; ~<+s::PlayDaaah()
; ~<+d::PlayDaaah()
; ~<+f::PlayDaaah()
; ~<+g::PlayDaaah()
;
; ~<+z::PlayDaaah()
; ~<+x::PlayDaaah()
; ~<+c::PlayDaaah()
; ~<+v::PlayDaaah()
; ~<+b::PlayDaaah()


; autohotkey code - mapped to F12
; $LButton::
; MouseClick, Right,,,,, D
; KeyWait, LButton
; MouseClick, Right,,,,, U
; return
;
; $RButton::
; MouseClick, Left,,,,, D
; KeyWait, RButton
; MouseClick, Left,,,,, U
; return


; # Windows Explorer #########################################################
#If WinActive("ahk_class CabinetWClass")
; Switch Focus Address Bar
focus_adress = 0

; Adapt Chrome focus shortcut
^l::F4

; Focus file panel
^Space::
    SendInput, {ESC}
    ControlFocus, DirectUIHWND3, A
    SendInput, {Space}
    return

; Python in Windows Explorer

^Enter::
path_name := % Explorer_GetSelection()
; requires py launcher (python 3.3+), reads shebang (py 2 and 3 compatible)
run C:/ConEmu/ConEmu.exe /cmd cmd /c py "%path_name%" -new_console:c
; run py "%path_name%"
return

; global focus_adress
; if (focus_adress = 0){
;     SendInput, {F4}
;     focus_adress = 1
; }
; else {
;     SendInput, {ESC}
;     ControlFocus, DirectUIHWND3, A
;     SendInput, {Space}
;     focus_adress = 0
; }
; return

PlayTick() {
    Tick = %CloudFolder%\System\Sounds\buttons\button-50.wav
    SoundPlay, %Tick%
}

PlayDelete() {
    Tick = %CloudFolder%\System\Sounds\buttons\button-16.wav
    SoundPlay, %Tick%
}

PlayTick2() {
    ; Tick = %CloudFolder%\System\Sounds\ui\KeyboardSingle.wav
    Tick = %CloudFolder%\System\Sounds\ui\KeypressStandard.wav
    SoundPlay, %Tick%, wait
}

global shortNoteActive
#If (shortNoteActive == 1)

~Backspace::PlayDelete()

~Space::PlayTick()
~,::PlayTick()
~.::PlayTick()
~(::PlayTick()
~)::PlayTick()
~-::PlayTick()
~'::PlayTick()
~"::PlayTick()
~/::PlayTick()
~\::PlayTick()
~?::PlayTick()
~!::PlayTick()
~@::PlayTick()
~#::PlayTick()
~$::PlayTick()
~%::PlayTick()
~^::PlayTick()
~&::PlayTick()
~*::PlayTick()
~_::PlayTick()
~=::PlayTick()
~+::PlayTick()

~a::PlayTick()
~s::PlayTick()
~d::PlayTick()
~f::PlayTick()
~g::PlayTick()
~h::PlayTick()
~j::PlayTick()
~k::PlayTick()
~l::PlayTick()
~q::PlayTick()
~w::PlayTick()
~e::PlayTick()
~r::PlayTick()
~t::PlayTick()
~y::PlayTick()
~u::PlayTick()
~i::PlayTick()
~o::PlayTick()
~p::PlayTick()
~z::PlayTick()
~x::PlayTick()
~c::PlayTick()
~v::PlayTick()
~b::PlayTick()
~n::PlayTick()
~m::PlayTick()

~+a::PlayTick()
~+s::PlayTick()
~+d::PlayTick()
~+f::PlayTick()
~+g::PlayTick()
~+h::PlayTick()
~+j::PlayTick()
~+k::PlayTick()
~+l::PlayTick()
~+q::PlayTick()
~+w::PlayTick()
~+e::PlayTick()
~+r::PlayTick()
~+t::PlayTick()
~+y::PlayTick()
~+u::PlayTick()
~+i::PlayTick()
~+o::PlayTick()
~+p::PlayTick()
~+z::PlayTick()
~+x::PlayTick()
~+c::PlayTick()
~+v::PlayTick()
~+b::PlayTick()
~+n::PlayTick()
~+m::PlayTick()

~1::PlayTick()
~2::PlayTick()
~3::PlayTick()
~4::PlayTick()
~5::PlayTick()
~6::PlayTick()
~7::PlayTick()
~8::PlayTick()
~9::PlayTick()
~0::PlayTick()





#If 

Joy7::GameTimer()
Pause::GameTimer()

; Day of the Tentacle
; #Include %A_ScriptDir%\dott.ahk

; # NOT NEEDED ANYMORE #######################################################

; taskbar_on := 1
; F11::
; if !WinActive("ahk_exe gvim.exe")
;     Switch_Taskbar()
; else
; {
;     Suspend, On
;     Send, {F11}
;     Suspend, Off
;     return
; }
; return
; 
; Switch_Taskbar()
; {
;     global taskbar_on
;     if (taskbar_on == 1)
;     {
;         WinHide, ahk_class Shell_TrayWnd
;         WinHide, Start ahk_class Button
;         taskbar_on := 0
;     }
;     else
;     {
;         WinShow, ahk_class Shell_TrayWnd
;         WinShow, Start ahk_class Button
;         taskbar_on := 1
;     }
; return
; }
;
; F12 for NegativeScreen:
; F12::Send, !#{F12}
; 
; ^F12::Send, {F12}

; RunAsAdmin() {
;       ; Run this script as Administrator and exit the old user instance 
;       ; Problem is, I dont need the whole script to be run as admin at a dynamic
;       ; point. Probably useless.
; 	Global 0
; 	IfEqual, A_IsAdmin, 1, Return 0
; 	Loop, %0%
; 		params .= A_Space . %A_Index%
; 	DllCall("shell32\ShellExecute" (A_IsUnicode ? "":"A"),uint,0,str,"RunAs",str,(A_IsCompiled ? A_ScriptFullPath
; 	: A_AhkPath),str,(A_IsCompiled ? "": """" . A_ScriptFullPath . """" . A_Space) params,str,A_WorkingDir,int,1)
; 	ExitApp
; }

