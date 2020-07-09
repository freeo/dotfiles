global CloudFolder

#NoEnv

EnvGet, EnvCloudFolder, CLOUDFOLDER

computername := A_ComputerName

if (EnvCloudFolder != "") {
    ; MsgBox, %CloudFolder%
    CloudFolder := EnvCloudFolder
}
else if (computername="FREEOS-R560") {
    CloudFolder := "D:\GDrive"
}
else if (computername="700Z5A") {
    CloudFolder := "D:\GDrive"
}
else if (computername="Asa") {
    CloudFolder := "E:\GDrive"
}
else if (computername="VN7-591G") {
    CloudFolder := "D:\GDrive"
}
else {
    CloudFolder := ""
    MsgBox ERROR: Computer CloudFolder undefined, computername:"%computername%"
    ; TODO try find dropbox in [c:\,d:\,e:\,...]
}
if (CloudFolder="") {
    MsgBox ERROR: Computername: `"%computername%`" CloudFolder: `"%CloudFolder%`"
}

; MsgBox Computername: `"%computername%`" CloudFolder: `"%CloudFolder%`"
