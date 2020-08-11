# Local Docker Development Stack

This repo will launch several containers:

- [Traefik](https://traefik.io/) - a reverse proxy/load balancer
- [Portainer](https://www.portainer.io/) - a container management system
- [Prometheus](https://prometheus.io) - monitoring system & time series database
- [Grafana](http://grafana.com) - open platform for analytics and monitoring
- [cadvisor](https://github.com/google/cadvisor) - container resource usage and performance monitoring
- [node-exporter](https://github.com/prometheus/node_exporter) - exporter for docker host machine metrics
- [mailhog](https://github.com/mailhog/MailHog) - Web and API based SMTP testing

In order to make use of features such as the `mailhog` container, any relevant container must be connected to the
`docker-stack` network - this can be performed via the [Portainer interface](https://portainer.dev.localhost), or by
running the following command:

`docker network connect docker-stack <container name>`

You must then configure your application appropriately, such as sending emails to `mailhog:1025` or configuring
instrumentation in your application for collection via Prometheus.

Speaking of which...

## Prometheus Instrumentation

First, add appropriate instrumentation and Prometheus exporters to your application. This could take any number of
forms depending on the project and is out of scope for this document, however once this has been configured you can
then merely add configuration to `data/prometheus/prometheus.yaml` to periodically hit your monitoring endpoint
to scrape metrics:

```
[...]
scrape_configs:
    [...]
  - job_name: 'phoenix_app'
    scrape_interval: 5s
    static_configs:
      - targets: ['docker-phoenix_app_1:4000']
```

Once Prometheus is successfully pulling the desired data points (you should start to see those defined by your
instrumentation appearing in [the Prometheus dashboard](https://prometheus.dev.localhost)), you can begin
[using Grafana](https://grafana.dev.localhost) to create Dashboards for visualisation of your metrics.

## Supporting Stack URLs

|Tool|URL|Localhost|
|---|---|---|
| **Portainer** | [https://portainer.dev.localhost](https://portainer.dev.localhost) | [https://localhost:9000](https://localhost:9000) |
| **Prometheus** | [https://prometheus.dev.localhost](https://prometheus.dev.localhost) | [https://localhost:9090](https://localhost:9090) |
| **Grafana** | [https://grafana.dev.localhost](https://grafana.dev.localhost) | [https://localhost:3000](https://localhost:3000) |
| **Mailhog** | [https://mailhog.dev.localhost](https://mailhog.dev.localhost) | [https://localhost:8025](https://localhost:8025) |
