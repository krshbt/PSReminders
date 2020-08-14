# Powershell Based Reminders
Powershell based reminders app for Windows 10. This is built on top of Burst Notification module.

# Pre-requisite
- BurntToast Module
- Command : Install-Module -Name BurntToast -Scope CurrentUser -Force

# Scheduling Options
Schedule this script using Task Scheduler.
- Choose Run whether user is logged on or not
- Trigger Setup 
    - Daily: 1 days
    - Repeat task every 1 minute for a duration of 1 day
    - Stop task if run longer than 2 minutes
    - Enabled
- Actions
    - Program: Powershell.exe
    - Add arguments: -ExecutionPolicy Bypass <Local Path>\RemiderSvc.ps1