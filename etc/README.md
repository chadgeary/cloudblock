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
