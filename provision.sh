#!/bin/bash

# Digest options
OPTS=${1}


# Display usage info

usage(){
cat << EOF
Usage: ${0} {[-h|--help]|[-r|--remove]|[-v|--version]}

OPTIONS:
	-h | --help      Displays usage data
	-r | --remove    Shuts down and uninstalls nginx web server
	-v | --version   Displays version number

	Default/No opts  Updates system, installs nginx, copies index.html in place, 
			 and starts and configures the service

EOF
}


# Update system, install webserver, copy files from s3, and configure to start on boot

updateinstallconfig() {
	sudo yum update -y
	sudo amazon-linux-extras install nginx1.12 -y
	sudo chkconfig nginx on
	sudo aws s3 cp s3://gregoryjohnson-assignment-webserver/index.html /usr/share/nginx/html/index.html
	sudo service nginx start
}


# Remove webserver

removews(){
	sudo service nginx stop
	rm /usr/share/nginx/html/*
	sudo yum remove nginx -y
}


# Display version info

version(){
	echo "1.0.0"
}

# Handle options:
# Available options are -h|--help, -r|--remove, -v|--version or no option(default)
case "$OPTS" in
	-h|--help)
		usage
		;;
	-r|--remove)
		removews
		;;
	-v|--version)
		version
		;;
	*)
		updateinstallconfig
		;;
esac
