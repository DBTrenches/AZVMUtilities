# AZVMUtilities

AZVMUtilities provides a set of tools to configure Azure VMs. You can use these utilities to start a VM, create a disk and attach it to the VM. You can also detach and remove disks after stopping the VM in order to save money. While the VM is stopped you can downgrade the OS Disk.

## Example Usage

Import the module.

```powershell
Import-Module .\AZVMUtilities -Force
```

Variables.

```powershell
$Subscription = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx"
$ResourceGroupName = "VMResourceGroup"
$vmName = "vmName"
$location = 'East US'
$storageType = 'Standard_LRS'
$OsStorageTypeWorking = 'StandardSSD_LRS'
$OsStorageTypeAtRest = 'Standard_LRS'
$dataDiskName = $vmName + '_DataDisk'
$DiskSizeinGB = 100
```

Stop the VM, detach and remove data disk. No Cost on storage

```powershell
Select-AZSubscription -Subscription $Subscription
$StopStatus=Stop-AZVM -ResourceGroupName $ResourceGroupName -Name $vmName -Force
If ($StopStatus.Status -eq "Succeeded" ){
   #detach SQL and remove data Disk

   Remove-AZDiskFromVM `
   -AzureVmName $vmName `
   -ResourceGroupName $ResourceGroupName `
   -DiskName $dataDiskName
}
```

Stop the VM, downgrade OS Disk Storage type. Savings on OS Disk

```powershell
Select-AZSubscription -Subscription $Subscription
$StopStatus=Stop-AZVM -ResourceGroupName $ResourceGroupName -Name $vmName -Force
If ($StopStatus.Status -eq "Succeeded" ){
   #Downgrade OS Disk

   Set-AZOSDiskStorageType `
   -AzureVmName $vmName `
   -ResourceGroupName $ResourceGroupName `
   -StorageType $OsStorageTypeAtRest
}
```

Stop the VM and attach Data disk

```powershell
Select-AZSubscription -Subscription $Subscription
$StopStatus=Stop-AZVM -ResourceGroupName $ResourceGroupName -Name $vmName -Force
If ($StopStatus.Status -eq "Succeeded" ){
# add empty data disk
    Add-AZEmptyDiskToVM `
    -AzureVmName $vmName `
    -ResourceGroupName $ResourceGroupName `
    -DiskName $dataDiskName `
    -Lun 10 `
    -DiskSizeInGB $DiskSizeinGB `
    -StorageType $storageType
}
```

Stop the VM and upgrade OS Disk Storage type. Savings on OS Disk

```powershell
Select-AZSubscription -Subscription $Subscription
$StopStatus=Stop-AZVM -ResourceGroupName $ResourceGroupName -Name $vmName -Force

If ($StopStatus.Status -eq "Succeeded" ){
   #Downgrade OS Disk

   Set-AZOSDiskStorageType `
   -AzureVmName $vmName `
   -ResourceGroupName $ResourceGroupName `
   -StorageType $OsStorageTypeWorking
}
```

Start the VM and initialize Data Disk.

```powershell
Select-AZSubscription -Subscription $Subscription
$StartStatus=Start-AZVM -ResourceGroupName $ResourceGroupName -Name $vmName

If ($StartStatus.Status -eq "Succeeded"){
     Invoke-AzVMRunCommand `
    -VMName $vmName `
    -ResourceGroupName $ResourceGroupName `
    -CommandId 'RunPowerShellScript' `
    -ScriptPath .\scripts\InitDisk.ps1
}
```
