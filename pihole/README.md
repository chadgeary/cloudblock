# Deployed via SSM automatically, if running the playbook on it's own, see info below.

# Reference
Ansible playbook for [Pihole (docker)](https://hub.docker.com/r/pihole/pihole/). Tested EL7 (CentOS / RHEL), Amazon Linux 2, and Ubuntu 18.04 & 20.04. Supports optionally using Cloudflare's DoH client (cloudflared) - see Deploy (with DoH).

# Requires
Ports TCP/UDP 53 (DNS) and TCP 8001 (HTTP/Management) must be available.

# Deploy (without DoH)

```
# locally (assumes ansible is installed)
ansible-playbook pihole.yml --extra-vars \
"target=localhost \
install_dir=/opt/pihole \
dns_server_1=9.9.9.9 \
dns_server_2=1.0.0.1 \
show_password=True \
use_doh=False"
```

# Deploy (with DoH)
```
# locally (assumes ansible is installed)
ansible-playbook pihole.yml --extra-vars \
"target=localhost \
install_dir=/opt/pihole \
dns_server_1=172.17.0.1 \
dns_server_2=172.17.0.1 \
show_password=True \
use_doh=True"

# afer installation, via web console -> Settings
# Change Custom 1 and Custom 2 from 127.0.0.1 to 172.17.0.1#5053
```

# Notes
```
# if show_password=False
sudo cat /opt/pihole/password

# admin console
127.0.0.1:8001/admin
```

# Raspberry / Raspbian
I suspect this would work if docker were installed, though I don't have an environment to test currently.

# See Also
- [Pihole on Dockerhub](https://hub.docker.com/r/pihole/pihole)
- [Cloudflare's DoH Client](https://github.com/cloudflare/cloudflared)
