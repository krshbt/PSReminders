$isModuleExists = Get-Module BurntToast
if($null -eq $isModuleExists){
    #Install-Module -Name BurntToast -Scope CurrentUser -Force
}

$configJson = $PSScriptRoot + "\reminders.json"
$logoPath = $PSScriptRoot + "\icons\"
$defautIcon = 'bell.png'
$notificationSound = 'Alarm'

function showNotification($title, $desc, $icon, $sound) {
    $header = New-BTHeader -Id '001' -Title $title
    if($null -eq $desc -or $desc -eq ''){
        $desc = $title
    }
    if($null -eq $icon -or $icon -eq ''){
        $icon = $defautIcon
    }
    $iconPath = $logoPath + $icon

    if($sound){
        New-BurntToastNotification -Text $desc -Header $header -AppLogo $iconPath -Sound $notificationSound -SnoozeAndDismiss
    }
    else {
        New-BurntToastNotification -Text $desc -Header $header -AppLogo $iconPath -SnoozeAndDismiss
    }
}

function ProcessReminders() {
    $inputReminders = Get-Content -Raw -Path $configJson | ConvertFrom-Json
    if($inputReminders.Active.Count -gt 0){
        foreach($reminder in $inputReminders.Active){
            $showNotification = $false
            $currentDate = Get-Date
            $reminderDate = Get-Date -Date $reminder.Date
            if($currentDate -ge  $reminderDate){
                $exactReminderDate = ""
                if($currentDate.Date -eq $reminderDate.Date){
                    $exactReminderDate = $reminder.Date
                }
                elseif($reminder.Repeat){
                    $dayOfWeek = [System.Int32]$currentDate.DayOfWeek
                    $todayDate = Get-Date -Format $inputReminders.Template.Date
                    if($reminder.Options.ToLowerInvariant() -eq "weekdays" -and $dayOfWeek -gt 0 -and $dayOfWeek -lt 6){
                        $exactReminderDate = $todayDate
                    }
                }

                if($exactReminderDate -ne ""){
                    $exactRemindertime = $exactReminderDate + ' ' + $reminder.Time
                    $reminderTime = Get-Date -Date $exactRemindertime
                    $currentTime = Get-Date
                    $diff = $currentTime - $reminderTime
                    $showNotification = $diff.TotalMinutes -gt 0 -and $diff.TotalMinutes -le $inputReminders.Configuration.MarginMinutes

                    if($showNotification){
                        showNotification $reminder.Title $reminder.Description $reminder.Icon $inputReminders.Configuration.EnableSound
                    }
                }
            }
        }
    }
}

ProcessReminders



