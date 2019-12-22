# Local Docker Development Stack

This repo will launch several containers:

- [Traefik](https://traefik.io/) - a reverse proxy/load balancer
- [Portainer](https://www.portainer.io/) - a container management system
- [Prometheus](https://prometheus.io) - monitoring system & time series database
- [Grafana](http://grafana.com) - open platform for analytics and monitoring
- [cadvisor](https://github.com/google/cadvisor) - container resource usage and performance monitoring
- [node-exporter](https://github.com/prometheus/node_exporter) - exporter for docker host machine metrics
- [mailhog](https://github.com/mailhog/MailHog) - Web and API based SMTP testing

In order to monitor the entire stack, each project must be connected to a single Docker network which enables effective
communication between each of the services therein. This repo creates a network named 'traefik', to which all other
project repos should be connected.

To connect another project to the Traefik network, simply configure the *network* section in the relevant
`docker-compose.yml` file as follows:

```
networks:
  default:
    external:
      name: traefik
```

## Supporting Stack URLs

|Tool|URL|
|---|---|
| **Portainer** | [http://portainer.dev.localhost](http://portainer.dev.localhost) |
| **Prometheus** | [http://prometheus.dev.localhost](http://prometheus.dev.localhost) |
| **Grafana** | [http://grafana.dev.localhost](http://grafana.dev.localhost) |
| **Mailhog** | [http://mailhog.dev.localhost](http://mailhog.dev.localhost) |
