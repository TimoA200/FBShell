#!/bin/sh

####### CONFIG ######
BoxIP="192.168.178.1"
#BoxUSER=""
#BoxPW=""
#####################

location="/upnp/control/wanpppconn1"
uri="urn:dslforum-org:service:WANPPPConnection:1"

AddPortMapping() {
	action='AddPortMapping'
	SoapParamString="<NewRemoteHost>$1</NewRemoteHost><NewExternalPort>$2</NewExternalPort><NewProtocol>$3</NewProtocol><NewInternalPort>$4</NewInternalPort><NewInternalClient>$5</NewInternalClient><NewEnabled>$6</NewEnabled><NewPortMappingDescription>$7</NewPortMappingDescription><NewLeaseDuration>$8</NewLeaseDuration>"
	output=$(curl -s -k -m 5 --anyauth -u "$BoxUSER:BoxPW" http://$BoxIP:49000$location -H 'Content-Type: text/xml; charset="utf-8"' -H "SoapAction:$uri#$action" -d "<?xml version='1.0' encoding='utf-8'?><s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'><s:Body><u:$action xmlns:u='$uri'>$SoapParamString</u:$action></s:Body></s:Envelope>")
	echo $output
}

DeletePortMapping() {
	action='DeletePortMapping'
	SoapParamString="<NewRemoteHost>$1</NewRemoteHost><NewExternalPort>$2</NewExternalPort><NewProtocol>$3</NewProtocol>"

	output=$(curl -s -k -m 5 --anyauth -u "$BoxUSER:BoxPW" http://$BoxIP:49000$location -H 'Content-Type: text/xml; charset="utf-8"' -H "SoapAction:$uri#$action" -d "<?xml version='1.0' encoding='utf-8'?><s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'><s:Body><u:$action xmlns:u='$uri'>$SoapParamString</u:$action></s:Body></s:Envelope>")
	echo $output
}

DisplayInfo() {
	echo "For Info about the arguments look at:"
	echo "https://avm.de/fileadmin/user_upload/Global/Service/Schnittstellen/wanipconnSCPD.pdf"
}

if [ $# -eq 0 ]; then DisplayInfo
else
	if [ $1 = "DisplayInfo" ]; then DisplayInfo;
	elif [ $1 = "AddPortMapping" ]; then AddPortMapping $2 $3 $4 $5 $6 $7 $8 $9;
	elif [ $1 = "DeletePortMapping" ]; then DeletePortMapping $2 $3 $4;
	fi
fi
