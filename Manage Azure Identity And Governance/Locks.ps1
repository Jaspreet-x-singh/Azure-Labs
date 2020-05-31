# How to apply locks on resources
New-AzResourceLock -LockName DonotDelete -LockLevel CanNotDelete -ResourceGroupName AZ101

# See all the applied locks
Get-AzResourceLock -ResourceGroupName AZ101

# Remove the lock
$lockid = (Get-AzResourceLock -ResourceGroupName AZ101).lockid
Remove-AzResourceLock -LockId $lockid