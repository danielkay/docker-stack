# Local Docker Development Stack

This repo will launch several containers:

- [Traefik](https://traefik.io/) - a reverse proxy/load balancer
- [Portainer](https://www.portainer.io/) - a container management system
- [Prometheus](https://prometheus.io) - monitoring system & time series database
- [Grafana](http://grafana.com) - open platform for analytics and monitoring
- [cadvisor](https://github.com/google/cadvisor) - container resource usage and performance monitoring
- [node-exporter](https://github.com/prometheus/node_exporter) - exporter for docker host machine metrics
- [mailhog](https://github.com/mailhog/MailHog) - Web and API based SMTP testing

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
