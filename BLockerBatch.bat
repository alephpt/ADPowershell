:: uncomment the psexec command you wish to run on the b-locker list 

@for /F "tokens=1 delims=," %%A in (blocker.csv) do (

:: gather bitlocker status
manage-bde -cn %%A -status c: > \\someserver\somedrive$\some\report\dir\%%A.txt

:: Turns on bitlocker encryption
:: psexec \\%%A manage-bde -on C: -skiphardwaretest -recoverypassword

:: Initializes TPM without rebooting
:: psexec -h \\%%A powershell -Command "Initialize-TPM -AllowClear -AllowPhysicalPresence"

:: Reboots users computer after they click OK
:: psexec \\%%A shutdown /r /c "Windows will shutdown momentarily to preform necessary updates. Press [F1] upon Reboot to complete the required TPM system update. Please save any unsaved changes now."

:: Stores the recovery keys in a txt
:: manage-bde -cn %%A -protectors -get c: > \\someserver\somedrive$\some\bitlocker\dir\BitLocker^ Recovery^ Key^ %%A.txt

:: Runs the gpupdate (requires you to press n and then enter after a few moments to proceed with prompt)
:: psexec \\%%A gpupdate /force

:: Stores Recovery Keys in AD
:: psexec \\%%A powershell -Command "manage-bde.exe  -protectors $env:SystemDrive -adbackup -id ((Get-BitLockerVolume -MountPoint $env:SystemDrive).keyprotector | where { $_.Keyprotectortype -eq 'RecoveryPassword' } | Select-Object -ExpandProperty KeyProtectorID)"
)