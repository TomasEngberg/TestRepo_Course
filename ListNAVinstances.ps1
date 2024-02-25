function Get-NAVServerInstances {
    param (
        $version,
        $powershellsession
    
    )
    
        
    Invoke-Command -Session $powershellsession -ScriptBlock {
    $version2 = $Using:version;
    $nstPath = "HKLM:\SOFTWARE\Microsoft\Microsoft Dynamics NAV\" + $version2 + "\Service";
    Import-Module (Join-Path -Path (Get-ItemProperty $nstPath -Name Path).Path -ChildPath "navadmintool.ps1") -verbose:$false|Out-Null; 
    $instances = Get-NavServerInstance;
    $sep = " ";
    #$MyArray = @();
    $counter = 0;

    foreach($navinstance in $instances)
      {
      $counter = $counter + 1;
      $navinstance2 = [regex]::Matches($navinstance.DisplayName, '(?<=\[)[^]]+(?=\])').Value
#      $found = $navinstance.DisplayName -match '(?<=\[)[^]]+(?=\])'  
#    Write-Host $matches
#	 Write-Host $navinstance.DisplayName 
#     Write-Host $navinstance2
     Write-Host $navinstance2
     $CurrentConfig = $navinstance2 | Get-NAVServerConfiguration -AsXml
        foreach ($Setting in $CurrentConfig.configuration.appSettings.add)
        {
            if ( $Setting.Key -eq "ClientServicesPort" ) 
            {
                $MyClientPort = $Setting.Value;
            }
            if ( $Setting.Key -eq "SOAPServicesPort" ) 
            {
                $MySoapPort = $Setting.Value;
            }
            if ( $Setting.Key -eq "ODATAServicesPort" ) 
            {
                $MyOdataPort = $Setting.Value;
            }
			if ( $Setting.Key -eq "ManagementServicesPort" )
			{
				$MyMgmtPort = $Setting.Value;
			}
            if ( $Setting.Key -eq "DatabaseServer" ) 
            {
                $MyDatabaseServer = $Setting.Value;
            }
            if ( $Setting.Key -eq "DatabaseName" ) 
            {
                $MyDatabaseName = $Setting.Value;
            }
#     $navinstance3 = Get-NAVServerConfiguration $navinstance2
#     Write-Host $navinstance3.ClientServicesPort
        }
        #Write-Host $navinstance2
        $output = $affiliate2 + $sep + $server2 + $sep + $navinstance2 + $sep + $MyClientPort + $sep + $MySoapPort + $sep + $MyOdataPort + $sep + $MyMgmtPort + $sep + $MyDatabaseServer + $sep + $MyDatabaseName
        if ( $counter -le 1 ) 
        {
            $output
        }
        else 
        {
            $output = "," + $output;
            $output
        }
        #Add-Content -Path $filename2 -Value $output
        #Write-Host $MyArray
      }
	
    #if not defined connect to default instance
#    $Instance = $instances.Item(0).ServerInstance.Replace("MicrosoftDynamicsNavServer$","");
#    Write-Host "Default instance = " $Instance;
#    if ($instancename2 -eq ""){
#       $instancename2 = $Instance;
#    }
#    Write-Host "Connecting to instance = " $instancename2;

#    try{
#        #Check if the User 
#        Set-NAVServerUser -ServerInstance $instancename2 -WindowsAccount $username2 -ea stop;
#        Write-Host "User $username2 already exists "  -ForegroundColor Red;
#        } 
#    catch {
#        New-NAVServerUser -ServerInstance $instancename2 -WindowsAccount $username2 -ea stop;
#        Write-Host "User $username2 created "  -ForegroundColor Green;
#          }

#    try{
#        #Write-Host "Try before";
#        #Write-Host $NAVPermissionSet2
#        foreach($perm in $NAVPermissionSet2)
#        {
#            $Perms = Get-NAVServerUserPermissionSet -ServerInstance $instancename2 -WindowsAccount $username2 -PermissionSet $perm -ea stop;
#            if ($perm -eq $Perms.PermissionSetID)
#            {
#                Write-Host "Permission $perm already exists for user $username2" -ForegroundColor Red;
#            }
#            else  
#            {
#        #        Write-Host 'Before adding permission set ' $NAVPermissionSet2 ' for user ' $username2  ' on serverinstance '  $instancename2;
#                New-NAVServerUserPermissionSet -PermissionSetId $perm -ServerInstance $instancename2 -WindowsAccount $username2 -ea stop;
#                Write-Host "Permission $perm added to user $username2" -ForegroundColor Green;
#            }
#        }
#       }
#    catch {
#       # Write-Host "Catch before";
#        Write-Host "Couldn't add permission $NAVPermissionSet2 to user $username2" -ForegroundColor Red;
#       # write-Host $Perms.PermissionSetId;
#        }
    }
    #$MyArray
}
