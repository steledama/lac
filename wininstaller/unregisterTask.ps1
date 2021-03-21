# Unregister the scheduled task
Unregister-ScheduledTask -TaskName 'LACagent' -Confirm:$false
# Unregister-ScheduledTask -TaskName 'LACserver' -Confirm:$false