# Local Docker Development Stack

This repo will launch several containers:

- [Traefik](https://traefik.io/) - a reverse proxy/load balancer
- [Portainer](https://www.portainer.io/) - a container management system
- [Prometheus](https://prometheus.io) - monitoring system & time series database
- [Grafana](http://grafana.com) - open platform for analytics and monitoring
- [cadvisor](https://github.com/google/cadvisor) - container resource usage and performance monitoring
- [node-exporter](https://github.com/prometheus/node_exporter) - exporter for docker host machine metrics
- [Blackfire](https://blackfire.io/) - Agent container for PHP Performance Testing
- [localstack](https://github.com/localstack/localstack) - fully functional local AWS cloud stack
- [mailhog](https://github.com/mailhog/MailHog) - Web and API based SMTP testing
- [dockerhost](https://github.com/qoomon/docker-host) - container to forward all traffic to the docker host (used for XDebug)

In order to simulate the entire stack, each project must be connected to a single Docker network which enables effective communication between each of the services therein. This repo creates a network named 'traefik', to which all other project repos should be connected.

To connect another project to the Traefik network, simply configure the *network* section in the relevant `docker-compose.yml` file as follows:

```
networks:
  default:
    external:
      name: traefik
```

## Supporting Stack URLs

|Tool|localhost URL|dnsmasq URL|
|---|---|---|
| **Portainer** | [http://localhost:9001](http://localhost:9001) | [http://portainer.localhost](http://portainer.localhost) |
| **Prometheus** | [http://localhost:9090](http://localhost:9090) | [http://prometheus.localhost](http://prometheus.localhost) |
| **Grafana** | [http://localhost:3000](http://localhost:3000) | [http://grafana.localhost](http://grafana.localhost) |
| **Mailhog** | [http://localhost:8025](http://localhost:8025) | [http://mailhog.localhost](http://mailhog.localhost) |
| **SonarQube** | [http://localhost:9990](http://localhost:9990) | [http://sonarqube.localhost](http://sonarqube.localhost) |

## SonarQube

If the SonarQube container doesn't start correctly, you may need to configure your host system as per the [documentation](https://docs.sonarqube.org/latest/requirements/requirements/) - the relevant section duplicated below for ease.

---
#### Platform Notes

###### Linux

If you're running on Linux, you must ensure that:

- vm.max_map_count is greater or equals to 262144
- fs.file-max is greater or equals to 65536
- the user running SonarQube can open at least 65536 file descriptors
- the user running SonarQube can open at least 4096 threads

You can see the values with the following commands:

```
sysctl vm.max_map_count
sysctl fs.file-max
ulimit -n
ulimit -u
```
You can set them dynamically for the current session by running the following commands as root:
```
sysctl -w vm.max_map_count=262144
sysctl -w fs.file-max=65536
ulimit -n 65536
ulimit -u 4096
```
To set these values more permanently, you must update either `/etc/sysctl.d/99-sonarqube.conf` (or `/etc/sysctl.conf` as you wish) to reflect these values.

If the user running SonarQube (sonarqube in this example) does not have the permission to have at least 65536 open descriptors, you must insert this line in `/etc/security/limits.d/99-sonarqube.conf` (or `/etc/security/limits.conf` as you wish):
```
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
```
You can get more detail in the Elasticsearch documentation.

If you are using systemd to start SonarQube, you must specify those limits inside your unit file in the section [service] :
```
[Service]
...
LimitNOFILE=65536
LimitNPROC=4096
...
```
---

Once the above has been configured: 

- Log into SonarQube at the relevant URL, using the credentials `admin` / `admin`
- Create a project in SonarQube
- Create a Token for the project
- Download and install the scanner from the link provided (remember to add the $install_directory/bin folder to your PATH)
- (optional) Install the PHPStorm plugin
- Set up a connection from the plugin to your containerised SonarQube server
- run `sonar-scanner` from the root of the project

## dnsmasq

Setup of dnsmasq went as follows:

#### install dnsmasq
'sudo apt install dnsmasq'
#### edit dnsmasq configuration
'vi /etc/dnsmasq.conf'
```
address=/localhost/127.0.0.1
listen-address=127.0.0.1
server=8.8.8.8
server=8.8.4.4
```
#### edit dnsmasq cache config
`vi /etc/NetworkManager/dnsmasq.d/cache.conf`
```
cache-size=1000
net-ttl=900
```
#### edit systemd-resolved configuration
`vi /etc/systemd/resolved.conf`
```
DNSStubListener=no
```
`sudo systemctl restart systemd-resolved`
`sudo systemctl restart dnsmasq`
`sudo systemctl enable dnsmasq`
`sudo systemctl restart network-manager`

### NOTE
the changes to systemd-resolved configuration will prevent your local machine from accessing the internet - however, the changes to dnsmasq configuration will restore access.

I noticed that after these changes browsing websites for the first time took a few seconds - this was due to a hangover from Docksal in my `/etc/resolv.conf` file. Making the following change fixed it:
```
#nameserver 192.168.64.100 # commented out this line
nameserver 127.0.0.1
nameserver 8.8.8.8 # added this (Google Public DNS IP)
search mscp.local
```
Unfortunately I then found that resolvconf would automatically replace this line on bootup (or when running `sudo resolvconf -u`). In order to address this, I had to do the following:
`sudo vim /run/resolvconf/interfaces/lo.inet`
```
#nameserver 192.168.64.100
nameserver 8.8.8.8
```
