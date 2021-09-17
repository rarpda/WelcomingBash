#Description 
Welcoming script to run when computer startups. Pulls weather data from the BBC.

#Dependencies
Requires the installation of:
-curl
-jq 

#Running
To run shell command:
1. Set Welcome.sh to executable - chmod 700 Welcome.sh
2. Run "gnome-terminal -- /Welcome.sh" with optional input argument of current location. Defaults to London.

1. Set allStart.sh to executable using chmod 700 allStart.sh
Add to .bashrc to run script when terminal is opened

