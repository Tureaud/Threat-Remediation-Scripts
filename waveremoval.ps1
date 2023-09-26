#WaveBrowser Production Script
start-transcript -path C:\waveBrowserRemovalAuditLog.txt
Get-Process -name "WaveBrowser","*Wavesor*","wavebrowser" | Stop-Process -Force;
#
$regNameList = @('REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Wavesor Software*',
    'REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\WavesorSWUpdaterTaskUser*'
    'REGISTRY::HKEY_USERS\*\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\wavebrowser*','REGISTRY::HKEY_USERS\*\SOFTWARE\Wavesor',
    'REGISTRY::HKEY_USERS\*\SOFTWARE\WaveBrowser', 'REGISTRY::HKEY_USERS\*\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WaveBrowser',
    'REGISTRY::HKEY_USERS\*\SOFTWARE\Clients\StartMenuInternet\WaveBrowser.*', 'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\CLSID\{9CD78CBC-FD21-4FFF-B452-9D792A58B7C4}', 
    'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\CLSID\{A3CA9AD3-179B-4E54-91F1-AC460EFB9C5F}', 'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\CLSID\{C5596523-009B-41A7-AB11-BCA2274BDCDB}',
    'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\CLSID\{F6994161-37C3-47C9-BE83-C84C33A1CF2A}', 'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\CLSID\{F87D77DF-DEF2-4294-9F4B-A92E5A6725DE}',
    'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\WOW6432Node\CLSID\{1BE9D40C-2307-4213-830E-7E3CE9EDF0C2}', 'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\WOW6432Node\CLSID\{30FB944E-9455-49DD-81C6-7542E47AA3E7}',
    'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\WOW6432Node\CLSID\{3C41B0C4-B5B6-4293-BED4-C927CCFDB909}', 'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\WOW6432Node\CLSID\{9E0CE9B5-C498-40A8-B7F2-B89AF1C56FFF}',
    'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\WOW6432Node\CLSID\{A3CA9AD3-179B-4E54-91F1-AC460EFB9C5F}', 'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\WOW6432Node\CLSID\{C5596523-009B-41A7-AB11-BCA2274BDCDB}',
    'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\WOW6432Node\CLSID\{D12748C8-5013-45E2-9A24-2FB7C2EEFB7C}', 'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\WOW6432Node\CLSID\{F6994161-37C3-47C9-BE83-C84C33A1CF2A}',
    'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\WOW6432Node\CLSID\{F87D77DF-DEF2-4294-9F4B-A92E5A6725DE}', 'REGISTRY::\HKEY_USERS\*\SOFTWARE\Classes\Wavesor*', 
    'REGISTRY::\HKEY_USERS\*\SOFTWARE\Classes\WaveBrws*', 'REGISTRY::HKEY_USERS\*\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\wavebrowser*',
    'REGISTRY::\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MediaPlayer\ShimInclusionList\wavebrowser*');
#
$regPropertyList = @('REGISTRY::HKEY_USERS\*\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', 'REGISTRY::HKEY_USERS\*\SOFTWARE\RegisteredApplications',
    'REGISTRY::HKEY_USERS\*\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppBadgeUpdated',
    'REGISTRY::HKEY_USERS\*\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache',
    'REGISTRY::HKEY_USERS\*\Software\RegisteredApplications', 'REGISTRY::HKEY_USERS\*\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store');
#
foreach($X in $regNameList){
    $removeRegName = Get-ChildItem -Path $X | Where-Object {$_.PSIsContainer} | Foreach-Object {$_.Name} ; 
    foreach($nItem in $removeRegName){
        reg delete $nItem /f
    }
};
#
foreach($Y in $regPropertyList){
   $removeRegPropName = Remove-ItemProperty -Path $Y -name "Wavesor*","*wavebrowser*", "*wave browser*"  -ErrorAction SilentlyContinue | Out-Null; 
   #-Confirm:$true -ErrorAction SilentlyContinue | Out-Null;
};
#
$valuePaths = @(
"REGISTRY::HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules",
"REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\UFH\ARP",
"REGISTRY::HKEY_USERS\*\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths")
#
foreach($vPath in $valuePaths){
    $pathList =  Get-Item -path $vPath
    $pathPropertyNames = $pathList.getvaluenames()

    foreach($propertyName in $pathPropertyNames){
        $pathCompare = Get-ItemPropertyValue -path $vPath -name $propertyName

    if ($pathCompare -like "*wavebrowser*"){
        echo "here: $propertyName"
        Remove-ItemProperty -Path $vPath -name $propertyName -Confirm:$false
    }}
};
#
$ieAudioPath = "REGISTRY::HKEY_USERS\*\SOFTWARE\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore\a7e25e2a_0"
$ieAudioPolicy = Get-ItemProperty -Path $ieAudioPath | Where-Object {$_."(default)"} | ForEach-Object {$_."(default)"}
if ($ieAudioPolicy -like "*wavebrowser*"){
    set-ItemProperty -Path $ieAudioPath -name "(default)" -value "" #-Confirm:$true
}
#
$Array = @( 
    @{ propertyName=("a"); propertyData=("chrome.exe")}
    @{ propertyName=("b"); propertyData=("msedge.exe")}
    @{ propertyName=("c"); propertyData=("iexplore.exe")}
    @{ propertyName=("d"); propertyData=("notepad.exe")}
    @{ propertyName=("MRUList"); propertyData=("abcd")}
)
#
$openWithHTML = "REGISTRY::HKEY_USERS\*\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.html\OpenWithList\"
Get-Item "REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe"
#
if(!$?){
    $propertyCounter = -1
    $dataCounter = 0
     while($propertyCounter -lt $array.propertyName.length -and $dataCounter -lt $array.propertyData.length){
        $propertyCounter += 1
        $dataCounter += 1
            if($propertyCounter -eq 3){
                continue
            }
            #$array.propertyName[$propertyCounter]
            #$array.propertyData[$dataCounter]
        if($propertyCounter -eq 4){
            New-ItemProperty -path "$openWithHTML" -Name $array.propertyName[$propertyCounter] -value "abc" -force -ErrorAction SilentlyContinue | Out-Null;
        }else{
            New-ItemProperty -path "$openWithHTML" -Name $array.propertyName[$propertyCounter] -value $array.propertyData[$dataCounter] -force -ErrorAction SilentlyContinue | Out-Null;
        }
     }
}elseif($?){
    for ($counter = 0 ; $counter -lt $array.propertyName.length -and $counter -lt $array.propertyData.length ; $counter++){
    #$array.propertyName[$counter] $array.propertyData[$counter]
    New-ItemProperty -path "$openWithHTML" -Name $array.propertyName[$counter] -value $array.propertyData[$counter] -force -ErrorAction SilentlyContinue | Out-Null;
    }   
};
#
$cachedTasks = Get-ItemProperty -Path "REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\*" | Where-Object { $_.URI -like "*Wavesor*" }  |  ForEach-Object {$_.pschildname};
foreach($cachedTask in $cachedTasks){reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\$cachedTask" /f}; #/f 
Remove-ItemProperty -path "REGISTRY::HKEY_USERS\*\Software\Classes\*\OpenWithProgids\" -name "*WaveBrwsHTM*";
#
#remove url associations and replace with installed browser? have to replace progld and hash value - replacing progID invalidates the previous hash and forces the user to select a new default 
Get-ChildItem "C:\Windows\SystemApps" -name "Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -ErrorAction SilentlyContinue | Out-Null;
if(!$?){
    Get-ItemProperty -Path "REGISTRY::HKEY_USERS\*\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\*\UserChoice" -name "ProgID", "Hash" | Where-Object { $_.ProgID -like "WaveBrwsHTM*" } | set-ItemProperty -name "ProgID" -value ""
}elseif($?){
    Get-ItemProperty -Path "REGISTRY::HKEY_USERS\*\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\*\UserChoice" -name "ProgID", "Hash" | Where-Object { $_.ProgID -like "WaveBrwsHTM*" } | set-ItemProperty -name "ProgID" -value "MSEdgeHTM"
};
#
$waveFiles = @('C:\Users\*\*','C:\Users\*\AppData\Local\*',
    'C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\*','C:\Users\*\AppData\Local\Temp\*',
    'C:\Windows\System32\config\systemprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\*',
    'C:\Windows\System32\config\systemprofile\AppData\Local\*', 'C:\Users\*\Desktop\*', 'C:\Users\*\Downloads\*', 
    'C:\Windows\Prefetch\*', 'C:\Windows\Temp\*', 'C:\Users\*\AppData\Local\Packages\*\*\*\*\*\',
    'C:\Users\*\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\*', 'C:\Windows\System32\config\systemprofile\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\*');
 foreach($Z in $waveFiles){
    $removeWaveFile = Get-ChildItem -Path $Z | Where-Object { $_.Name -match "WaveBrowser*|Wavesor*|WaveInstaller*|Wave Browser*" } -ErrorAction SilentlyContinue | del -recurse -force;
 };
#
Get-ScheduledTask | Where-Object { $_.TaskName -match 'Wavesor*|WaveBrowser*|Wave Browser*|Wavesor Software*|WavesorSWUpdaterTaskUser*' } | Unregister-ScheduledTask -Confirm:$false;
$taskRemove = Get-ChildItem "C:\Windows\System32\Tasks" -name "Wavesor Software*" ; remove-item "C:\Windows\System32\Tasks\$taskRemove" -recurse -force -confirm:$false
$taskRemove = Get-ChildItem "C:\Windows\System32\Tasks" -name "WavesorSWUpdaterTaskUser*" ; remove-item "C:\Windows\System32\Tasks\$taskRemove" -recurse -force -confirm:$false
$taskRemove = Get-ChildItem "C:\Windows\System32\Tasks" -name "Wavebrowser*" ; remove-item "C:\Windows\System32\Tasks\$taskRemove" -recurse -force -confirm:$false
#
write-host "All operations have completed - $(get-date)";
#
stop-transcript
