# Initialize
$ScriptVersion = '19062023_en-us'
if ($env:SystemDrive -eq 'X:') { $WindowsPhase = 'WinPE' }
else {
    $ImageState = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State' -ErrorAction Ignore).ImageState
    if ($env:UserName -eq 'defaultuser0') { $WindowsPhase = 'OOBE' }
    elseif ($ImageState -eq 'IMAGE_STATE_SPECIALIZE_RESEAL_TO_OOBE') { $WindowsPhase = 'Specialize' }
    elseif ($ImageState -eq 'IMAGE_STATE_SPECIALIZE_RESEAL_TO_AUDIT') { $WindowsPhase = 'AuditMode' }
    else { $WindowsPhase = 'Windows' }
}
Write-Host -ForegroundColor DarkGray "based on start.osdcloud.com $ScriptVersion $WindowsPhase"
Invoke-Expression -Command (Invoke-RestMethod -Uri functions.osdcloud.com)


# WinPE
if ($WindowsPhase -eq 'WinPE') {
    

#   [PreOS] Update Module
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

#Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"
#Install-Module OSD -Force

#Write-Host  -ForegroundColor Green "Importing OSD PowerShell Module"
#Import-Module OSD -Force   


#   [OS] Params and Start-OSDCloud
$Params = @{
    #OSVersion = "Windows 11"
    OSVersion = "Windows 10"
    #OSBuild = "22H2"
    OSEdition = "Enterprise"
    OSLanguage = "en-us"
    OSLicense = "Volume"
    ZTI = $true
    Firmware = $true
}
Start-OSDCloud @Params



#  [PostOS] OOBEDeploy Configuration
Write-Host -ForegroundColor Green "Create C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json"
$OOBEDeployJson = @'
{
    "AddNetFX3":  {
                      "IsPresent":  false
                  },
    "Autopilot":  {
                      "IsPresent":  false
                  },
    "RemoveAppx":  [
                    "MicrosoftTeams",
                    "Microsoft.BingWeather",
                    "Microsoft.BingNews",
                    "Microsoft.GamingApp",
                    "Microsoft.GetHelp",
                    "Microsoft.Getstarted",
                    "Microsoft.Messaging",
                    "Microsoft.MicrosoftOfficeHub",
                    "Microsoft.MicrosoftSolitaireCollection",
                    "Microsoft.MicrosoftStickyNotes",
                    "Microsoft.MSPaint",
                    "Microsoft.People",
                    "Microsoft.PowerAutomateDesktop",
                    "Microsoft.StorePurchaseApp",
                    "Microsoft.Todos",
                    "microsoft.windowscommunicationsapps",
                    "Microsoft.WindowsFeedbackHub",
                    "Microsoft.WindowsMaps",
                    "Microsoft.WindowsSoundRecorder",
                    "Microsoft.Xbox.TCUI",
                    "Microsoft.XboxGameOverlay",
                    "Microsoft.XboxGamingOverlay",
                    "Microsoft.XboxIdentityProvider",
                    "Microsoft.XboxSpeechToTextOverlay",
                    "Microsoft.YourPhone",
                    "Microsoft.ZuneMusic",
                    "Microsoft.ZuneVideo"
                   ],
    "UpdateDrivers":  {
                          "IsPresent":  true
                      },
    "UpdateWindows":  {
                          "IsPresent":  true
                      }
}
'@
If (!(Test-Path "C:\ProgramData\OSDeploy")) {
    New-Item "C:\ProgramData\OSDeploy" -ItemType Directory -Force | Out-Null
}
$OOBEDeployJson | Out-File -FilePath "C:\ProgramData\OSDeploy\OSDeploy.OOBEDeploy.json" -Encoding ascii -Force


#  [PostOS] AutopilotOOBE CMD Command Line
Write-Host -ForegroundColor Green "Create C:\Windows\System32\OOBE.cmd"
$OOBECMD = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
Set Path = %PATH%;C:\Program Files\WindowsPowerShell\Scripts
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://gist.githubusercontent.com/Athlete-ITSolutions/3828c14c6b5c2816af11681f7c1da9ad/raw/SetDNSservers.ps1
Start /Wait PowerShell -NoL -C Install-Module AutopilotOOBE -Force -Verbose
Start /Wait PowerShell -NoL -C Install-Module OSD -Force -Verbose
Start /Wait PowerShell -NoL -C Start-AutopilotOOBE
Start /Wait PowerShell -NoL -C Start-OOBEDeploy
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://gist.githubusercontent.com/Athlete-ITSolutions/31a5beca0adbf36243368cdbb2d0b162/raw/Setkeyboardlanguage.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://gist.githubusercontent.com/Athlete-ITSolutions/655c77804a61981c552fc3df89dbe487/raw/WindowsActivation.ps1
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://gist.githubusercontent.com/Athlete-ITSolutions/4453b13ec59edc4d22104dc91f7ff7ce/raw/LogCleanup.ps1
Start /Wait PowerShell -NoL -C Restart-Computer -Force
'@
$OOBECMD | Out-File -FilePath 'C:\Windows\System32\OOBE.cmd' -Encoding ascii -Force


#  [PostOS] SetupComplete CMD Command Line
Write-Host -ForegroundColor Green "Create C:\Windows\Setup\Scripts\SetupComplete.cmd"
$SetupCompleteCMD = @'
powershell.exe -Command Set-ExecutionPolicy RemoteSigned -Force
powershell.exe -Command "& {IEX (IRM https://gist.githubusercontent.com/Athlete-ITSolutions/593b558dab9880f628cd86bf42b5f8fa/raw)}"
'@
$SetupCompleteCMD | Out-File -FilePath 'C:\Windows\Setup\Scripts\SetupComplete.cmd' -Encoding ascii -Force



#   Restart-Computer
Write-Host  -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
}


#region Specialize
if ($WindowsPhase -eq 'Specialize') {
    #Do something
    $null = Stop-Transcript
}


#region AuditMode
if ($WindowsPhase -eq 'AuditMode') {
    #Do something
    $null = Stop-Transcript
}


#region OOBE
if ($WindowsPhase -eq 'OOBE') {
    #Do something
    $null = Stop-Transcript
}


#region Windows
if ($WindowsPhase -eq 'Windows') {
    #Do something
    $null = Stop-Transcript
}
