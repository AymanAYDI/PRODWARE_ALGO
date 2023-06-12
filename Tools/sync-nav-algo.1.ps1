Import-Module "${env:ProgramFiles}\Microsoft Dynamics 365 Business Central\130\Service\NavAdminTool.ps1" -WarningAction SilentlyContinue | out-null

$Readhost = Read-Host "Instance du serveur ?" 
$server=$Readhost
$oldversion = Read-Host "Version en cours ?" 

##Get the old version from powershell.
#ToDo parse Get-NavAppInfo

##Get the new Version from the file
$files = Get-ChildItem -Path "${env:userprofile}\Documents\AL\ALGO\" -Filter "*.app"
for ($i=0; $i -lt $files.Count; $i++) {
    $newversion = $files[$i].Name.Substring("ALGO_ALGO_".Length, $files[$i].Name.Length-"ALGO_ALGO_".Length-4)
}

Write-host "Voulez-vous mettre à jour l'extension ALGO en versiob $oldversion vers la version $newversion sur le serveur $server? (défaut est non)" -ForegroundColor Yellow 
    $Readhost = Read-Host " ( o / n ) " 
    Switch ($ReadHost) 
    { 
        O {
            Publish-NAVApp -ServerInstance $server -Path "${env:userprofile}\Documents\AL\ALGO\ALGO_ALGO_$newversion.app" -SkipVerification -PassThru
            Sync-NAVApp -ServerInstance $server -Name "ALGO" -Version $newversion
            Start-NAVAppDataUpgrade -ServerInstance $server -Name "ALGO" -Version $newversion
            Unpublish-NAVApp -Name ALGO -ServerInstance $server -Version $oldversion
            
            Uninstall-NAVApp -Name ALGO -ServerInstance $server -Version $newversion
            Unpublish-NAVApp -ServerInstance $server -Name "ALGO" -Version $newversion
            Sync-NAVTenant -ServerInstance $server
        } 
        N {Write-Host "Non, pas de mise à jour"
        } 
        Default {Write-Host "Défaut, pas de mise à jour"
        } 
      } 




