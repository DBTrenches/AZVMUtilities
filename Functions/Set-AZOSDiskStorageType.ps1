Function Set-AZOSDiskStorageType {

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
    [string] $StorageType
    )

    $vm = Get-AzVM -Name $AzureVmName `
    -ResourceGroupName $ResourceGroupName

    $OSDiskName=$vm.StorageProfile.OsDisk.Name
    $Osdisk = Get-AzDisk `
    -DiskName $OSDiskName `
    -ResourceGroupName $ResourceGroupName

    $Osdisk.Sku = [Microsoft.Azure.Management.Compute.Models.DiskSku]::new($StorageType)

    $Osdisk | Update-AzDisk
    
    Update-AzVM -VM $vm -ResourceGroupName $ResourceGroupName

}