Function Add-AZEmptyDiskToVM {

    [cmdletbinding()]
    Param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $AzureVmName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $ResourceGroupName,
    
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $DiskName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [int] $Lun,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [int] $DiskSizeInGB,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $StorageType
    )

    $vm = Get-AzVM -Name $AzureVmName `
    -ResourceGroupName $ResourceGroupName

    $vm = Add-AzVMDataDisk -VM $vm `
    -Name $DiskName -Lun $Lun `
    -DiskSizeinGB $DiskSizeInGB `
    -CreateOption Empty `
    -StorageAccountType $StorageType

    Update-AzVM -VM $vm `
    -ResourceGroupName $ResourceGroupName

    return $vm

}