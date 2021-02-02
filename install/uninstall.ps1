#unistall nodejs
choco uninstall nodejs -y --remove-dependencies

# Unregister the scheduled task
Unregister-ScheduledTask -TaskName 'LAC' -Confirm:$false