$Global:Transcript = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Set-KeyboardLanguage.log"
Start-Transcript -Path (Join-Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD\" $Global:Transcript) -ErrorAction Ignore

Write-Host -ForegroundColor Green "Install language packs"
Install-Language -Language de-ch
Install-Language -Language fr-ch
Install-Language -Language en-US

Write-Host -ForegroundColor Green "Set keyboard language to de-ch"
Start-Sleep -Seconds 5

$LanguageList = Get-WinUserLanguageList

$LanguageList.Add("de-ch")
Set-WinUserLanguageList $LanguageList -Force

Start-Sleep -Seconds 5

Stop-Transcript
