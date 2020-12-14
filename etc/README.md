# Etc
Additional configurations for various one-off/special deployment types + useful commands. The additional configurations may or may not be maintained, but the primary [aws/](../aws), [azure/](../azure), [gcp/](../gcp), [oci/](../oci), and [playbooks/](../playbooks) directories are, however!

# Commands
Replace the PIHOLE_PW, PIHOLE_IP, and other variable values as necessary.
`
#############
## Ad List ##
#############
# remove old cookies
rm -f cookies.pihole

# variables
PIHOLE_PW='changeme'
PIHOLE_IP='172.18.0.5'
ADLIST='https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts+https://mirror1.malwaredomains.com/files/justdomains&comment=malware-list'

# auth
curl 'https://'"$PIHOLE_IP"'/admin/index.php?login' --data-raw 'pw='"$PIHOLE_PW"'' --compressed --insecure -b cookies.pihole -c cookies.pihole

# token
PIHOLE_TOKEN=$(curl --silent 'https://'"$PIHOLE_IP"'/admin/index.php' --compressed --insecure -b cookies.pihole -c cookies.pihole | grep 'token" hidden' | awk -F '>' '{print $2}' | awk -F'<' '{print $1}')

# ad list addition
curl 'https://'"$PIHOLE_IP"'/admin/scripts/pi-hole/php/groups.php' --data-raw 'action=add_adlist&address='"$ADLIST"'&token='"$PIHOLE_TOKEN"'' --compressed --insecure -b cookies.pihole -c cookies.pihole

###########################
## Local Name Resolution ##
###########################
# remove old cookies
rm -f cookies.pihole

# variables
PIHOLE_PW='changeme'
PIHOLE_IP='172.18.0.5'
LOCAL_NAME='myprinter.home'
LOCAL_IP='192.168.0.9'

# auth
curl 'https://'"$PIHOLE_IP"'/admin/index.php?login' --data-raw 'pw='"$PIHOLE_PW"'' --compressed --insecure -b cookies.pihole -c cookies.pihole

# token
PIHOLE_TOKEN=$(curl --silent 'https://'"$PIHOLE_IP"'/admin/index.php' --compressed --insecure -b cookies.pihole -c cookies.pihole | grep 'token" hidden' | awk -F '>' '{print $2}' | awk -F'<' '{print $1}')

# local name resolution addition
curl 'https://'"$PIHOLE_IP"'/admin/scripts/pi-hole/php/customdns.php' --data-raw 'action=add&ip='"$LOCAL_IP"'&domain='"$LOCAL_NAME"'&token='"$PIHOLE_TOKEN"'' --compressed --insecure -b cookies.pihole -c cookies.pihole
`
