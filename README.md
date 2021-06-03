# NotifyOfflinePort v1.0
This is a little script which checks and notifies if specific ports are offline. Like pinging an ip address, but more precise. Useful for being notified when servers or websites go down.

<h2>Settings</h2>

 - address list - PowerShell Array of Strings
	
		$address = @( "address1.com" , "www.address2.com" , "3.333.333.33" )

 - port list - PowerShell Array of Integers
		
		$ports = @( 1 , 2 , 3 )

 - name list - PowerShell Array of Strings
		
		$names = @( "Name 1" , "Name 2" , "Name 3" )

 - number of seconds between checks - Integer
		
		$t = 10

Items in the lists are matched based on their position in the list. Meaning the first item in the address list, the first item in the port list, and the first item in the name list will be grouped as the first check. Likewise, the second items of the three lists will be grouped and checked second, etc.

The three lists must be the same length (it probably crashes after reaching the end of the shortest list)

Use Port 80 to check if a website is online, that is the default port for http

<h2>To Do</h2>

 - error message for mismatched list lengths
 - notification settings (notify only once, persistent notification)

<h3>maybe later</h3>

 - email or text notification
 - pretty GUI
