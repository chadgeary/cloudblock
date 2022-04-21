# Etc
Additional configurations for various one-off/special deployment types + useful commands. The additional configurations may or may not be maintained, but the primary [aws/](../aws), [azure/](../azure), [gcp/](../gcp), [oci/](../oci), and [playbooks/](../playbooks) directories are, however!

# Useful Commands and Troubleshooting

## Pihole - Add ad-list(s) via CLI
```
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
```

## Pihole - Add local name/ip resolution via CLI
```
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
```

## CloudflareD (DoH) - View counter of DNS requests and responses (plus the results)
```
CLOUDFLARED_METRICSPORT=$(sudo docker logs cloudflared_doh 2>&1 | awk -F':' '/metrics server on 127/ { print $4 }' | awk -F '/' '{ print $1 }')

sudo docker exec cloudflared_doh /bin/bash -c 'which curl; if [ $? -ne 0 ]; then apt-get update && apt-get -y install curl; fi && curl --silent 127.0.0.1:'"$CLOUDFLARED_METRICSPORT/metrics"'' | grep '^coredns_dns_requests_total\|^coredns_dns_responses_total'
```

## Automatically updating dynamic IPs via cron
```
#!/bin/bash
# Author: Aelfa
# Run every 5 minutes with cron
# check for ip changes every 5 minutes
# crontab -e, please don't use sudo crontab -e
# */5 * * * * /usr/bin/bash "/home/YOUR_USER/update_cloudblock_ip.sh" >> /home/YOUR_USER/cron.log

cloudprovider=oci #type the name to your cloudprovider example azure, aws, oci

if [[ $EUID == 0 ]]; then
  tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  You must execute as a user or as root, please don't use sudo
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  exit 0
fi

############################# SYSTEM INFORMATION #######################
readonly DETECTED_PUID=${SUDO_UID:-$UID}
readonly DETECTED_UNAME=$(id -un "${DETECTED_PUID}" 2>/dev/null || true)
readonly DETECTED_HOMEDIR=$(eval echo "~${DETECTED_UNAME}" 2>/dev/null || true)
LOG_FILE="$DETECTED_HOMEDIR/ips.txt"
BASEDIR="$DETECTED_HOMEDIR/cloudblock/$cloudprovider"
BASEFILE="$BASEDIR/$cloudprovider.tfvars"
########################################################################

CURRENT_IPV4="$(dig +short myip.opendns.com @resolver1.opendns.com)"
LAST_IPV4="$(tail -1 "$LOG_FILE" | awk -F, '{print $2}')"

if [ "$CURRENT_IPV4" = "$LAST_IPV4" ]; then
  echo "IP has not changed ($CURRENT_IPV4)"
else
  echo "IP has changed: $CURRENT_IPV4"
  echo "$(date),$CURRENT_IPV4" >>"$LOG_FILE"
  sed -i -e "s#^mgmt_cidr = .*#mgmt_cidr = \"$CURRENT_IPV4/32\"#" "$BASEFILE"
  cd "$BASEDIR" && terraform apply -auto-approve -var-file="$cloudprovider.tfvars"
fi
#EOF
```
