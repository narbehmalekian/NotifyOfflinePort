#---NotifyOfflinePort-----------------------------------------------

	# NotifyOfflinePort connects to specific ports at the address of your choice and shows a notification when the port is closed or offline.
	# It was originally written to notify me when my remote servers went offline. It could also be used to know when a website goes offline.
	# Run this script at your own risk. Only enter valid data in the settings.
	# If you have any questions, concerns, or suggestions, my email is narbeh.malekian@gmail.com

#---Settings--------------------------------------------------------
#---The three lists ($address, $ports, $names) will be matched with one another. The first items of the lists go together. The second items of the lists go together...and so on
#---So if you want to check Port 1 of Address1, and Port 2 of Address2. The lists should be input as follows
#---   $address = @( "Address1" , "Address2" )
#---   $ports = @( 1 , 2 )
#---   $names = @( "Name1" , "Name2" )
#---All lists should be in the format: $listName = @("item1", "item2", "item3"). No quotes for port numbers!

#---list of addresses to check

	$address = @("example.com", "google.com", "93.184.216.34")


#---list of ports to check

	$ports = @(80, 80, 81)


#---list of names for each port, for your reference

	$names = @("Example HTTP", "Google's Port 80", "Jeff's Server")


#---set duration between check, in integer seconds

	$t = 90


#-------------------------------------------------------------------
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
$n = $names.length

#---this function makes text appear letter-by-letter, just for fun c:
function Write-Sweep($text,$color="White",[switch]$nnl){
	$arr = $text.toCharArray()
	foreach($letter in $arr){
		Write-Host -nonewline "$letter" -ForegroundColor $color
		Start-Sleep -milliseconds 0.8
	}
	if(!$nnl){
		Write-Host ""
	}
}

#---checks every $t seconds if servers $names are online starting with port $base and counting up
while($true){
	for($i = 0; $i -lt $n; $i++){ #repeat check for each item in $names
			$name = $names[$i]
			$port = $ports[$i]
			$addr = $address[$i]
		if((tnc $addr -port $port).TcpTestSucceeded){ #---check if port was accessible
			Write-Sweep "$(Get-Date -Format G) - " -nnl
			Write-Sweep "$name is online" -color Green
		}
		else{
			Write-Sweep "$(Get-Date -Format G) - " -nnl
			Write-Sweep "$name is offline" -color Red
			#---windows notification, code from http://woshub.com/popup-notification-powershell/
			Add-Type -AssemblyName System.Windows.Forms
			$global:balmsg = New-Object System.Windows.Forms.NotifyIcon
			$path = (Get-Process -id $pid).Path
			$balmsg.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
			$balmsg.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
			$balmsg.BalloonTipText = "TCP connect to ($addr : $port) failed"
			$balmsg.BalloonTipTitle = "$name went offline"
			$balmsg.Visible = $true
			$balmsg.ShowBalloonTip(20000)
			#---windows notification sound
			[system.media.systemsounds]::Hand.play()
		}
	}
	Write-Host ""
	Write-Sweep "Waiting for next check..." -nnl
	Write-Host "`r" -nonewline
	$remain=$t
	if($remain -gt 3660){ #---show remaining hours and minutes until 1 hour
		for($i=$remain;$i -ge 3600;$i-=60){
			$percent = [math]::floor(100*(1-($i/$t)))
			$h = [math]::floor($i/3600)
			$m = [math]::floor(($i-($h*3600))/60)
			Write-Progress -Activity "Waiting for next check..." -Status "$h hours $m minutes remaining" -PercentComplete $percent
			Start-Sleep -s 60
			$remain-=60
		}
	}
	if($remain -gt 60){ #---show remaining minutes and seconds until 1 minute
		for($i=$remain;$i -gt 60;$i-=1){
			$percent = [math]::floor(100*(1-($i/$t)))
			$m = [math]::floor($i/60)
			$s = [math]::floor($i-($m*60))
			Write-Progress -Activity "Waiting for next check..." -Status "$m minutes $s seconds remaining" -PercentComplete $percent
			Start-Sleep -s 1
			$remain-=1
		}
	}
	for($i=$remain;$i -gt 0;$i-=0.1){ #---show remaining seconds and 10ths
		$percent = [math]::floor(100*(1-($i/$t)))
		$s = "{0:n1}" -f $i
		Write-Progress -Activity "Waiting for next check..." -Status "$s seconds remaining" -PercentComplete $percent
		Start-Sleep -milliseconds 100
	}
}