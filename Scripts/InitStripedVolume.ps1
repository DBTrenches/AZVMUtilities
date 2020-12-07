[cmdletbinding()]
Param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]$DriveLetter
)

$PhysicalDisks = Get-PhysicalDisk | Where-Object {$_.CanPool -eq "True" -and $_.OperationalStatus -eq "OK" -and $_.HealthStatus -eq "Healthy"}


New-StoragePool -FriendlyName "DataFiles" -StorageSubsystemFriendlyName "Windows Storage*" `
    -PhysicalDisks $PhysicalDisks | New-VirtualDisk -FriendlyName "DataFiles" `
    -Interleave 65536 -NumberOfColumns $PhysicalDisks.Count -ResiliencySettingName simple `
    -UseMaximumSize |Initialize-Disk -PartitionStyle GPT -PassThru |New-Partition -DriveLetter $DriveLetter `
    -UseMaximumSize |Format-Volume -FileSystem NTFS -NewFileSystemLabel "DataDisks" `
    -AllocationUnitSize 65536 -Confirm:$false

New-Item -ItemType Directory -Force -Path "$($DriveLetter):\Data"
New-Item -ItemType Directory -Force -Path "$($DriveLetter):\Logs"
