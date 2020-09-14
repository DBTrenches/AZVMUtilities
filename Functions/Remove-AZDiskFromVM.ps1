Function Remove-AZDiskFromVM {

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
    [string] $DiskName

    )

    $vm = Get-AzVM -Name $AzureVmName `
    -ResourceGroupName $ResourceGroupName

    Remove-AzVMDataDisk `
    -VM $vm `
    -Name $DiskName

    Update-AzVM `
    -ResourceGroupName $ResourceGroupName `
    -VM $vm

    Get-AzDisk `
    -ResourceGroupName $ResourceGroupName `
    -DiskName $DiskName | Remove-AzDisk -Force

}