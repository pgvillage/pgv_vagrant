---
title: HAProxy - multiinstance
summary: A description of configuring HAProxy to proxy ports for multiple PostgreSQL HA clusters
authors:
  - Sebas Mannem
date: 2026-10-11
---

# HAProxy inventory (multi-instance)

When deploying multiple HA clusters (e.a. stolon or Patroni), HAProxy needs to forward traffix for all options for all instances.
You can configre them by editing the haproxy config (e.a. `environments/cluster1/group_vars/hacluster/haproxy.yml`) and define all front-ends and back-ends.
Best is to define a global config first and define front-ends and backends from that.

## Generic settings

| Variable                 | Description                                                        |
|--------------------------|--------------------------------------------------------------------|
| `haproxy_timeout_client` | Client timeout of the frontends and server timeout of the backends (`10800s`). |
| `haproxy_checkport`      | Port used for health checks of the backend servers (`9201`).        |

## `haproxy_config`

Helper dictionary that maps each route type to a backend port (on the database hosts) and a frontend port (on the router):

!!! example
    ```yaml
    haproxy_config:
      cluster1:
        rw:
          backend_port: "{{ stolon_clusters.cluster1.sysconfig.stkeeper.pg_port }}"
          frontend_port: 35433
        proxy:
          backend_port: "{{ stolon_clusters.cluster1.sysconfig.stproxy.port }}"
          frontend_port: 35434
        ro:
          backend_port: "{{ stolon_clusters.cluster1.sysconfig.stkeeper.pg_port }}"
          frontend_port: 35435
    ```

| Route       | Backend                      | Health check                           |
|-------------|------------------------------|----------------------------------------|
| `ReadWrite` | Postgres port of the keeper  | `/opt/pgroute66/checkpgprimary.sh`      |
| `ReadOnly`  | Postgres port of the keeper  | `/opt/pgroute66/checkpgstandby.sh`      |
| `Proxy`     | stolon proxy port            | `/opt/pgroute66/checkpgprimary.sh`      |

!!! note
    You can define other config and/or use other naming instead of ReadWrite, Proxy and ReadOnly.

## `haproxy_frontends`

List of frontends. Each entry has `name`, `address`, `port`, `mode`, `backend` and `timeout_client`.

The `name` is used to determine the cluster: the check script strips everything after the first dash. Frontend names
must therefore follow the pattern `<cluster>-<Route>-frontend` (e.g. `cluster1-ReadWrite-frontend`), and `<cluster>`
must match a key in [`pgroute66_clusters`](pgroute66.md).

!!! example
    ```yaml
    haproxy_frontends:
      - name: "cluster1-ReadWrite-frontend"
        address: "*"
        port: "{{ haproxy_config.cluster1.rw.frontend_port }}"
        mode: "{{ haproxy_default_mode }}"
        backend: "cluster1-ReadWrite-backend"
        timeout_client: "{{ haproxy_timeout_client }}"
    ```

!!! note
    Define a seperate frontend for every chapter defined for every cluster in `haproxy_config`

## `haproxy_backends`

List of backends, named `<cluster>-<Route>-backend`.

| Key              | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| `name`           | Backend name, referenced by `backend` in the frontend.                      |
| `mode`           | HAProxy mode (`haproxy_default_mode`).                                      |
| `balance_method` | Balance algorithm (`leastconn`).                                            |
| `options`        | HAProxy options (`external-check`).                                         |
| `params`         | Extra parameters, e.g. `external-check command /opt/pgroute66/checkpgprimary.sh`. |
| `timeout_server` | Server timeout.                                                             |
| `servers`        | List of servers with `name`, `address`, `port` and `checkport`.             |

!!! example
    ```yaml
    haproxy_backends:
      - name: "cluster1-ReadWrite-backend"
        mode: "{{ haproxy_default_mode }}"
        balance_method: "leastconn"
        options:
          - "external-check"
        params:
          - "external-check command  /opt/pgroute66/checkpgprimary.sh"
        timeout_server: "{{ haproxy_timeout_client }}"
        servers:
          - name: "db-1.local"
            address: "172.30.1.31"
            port: "{{ haproxy_config.rw.backend_port }}"
            checkport: "{{ haproxy_checkport }}"
          # db-2.local, db-3.local ...
    ```

## Adding an instance

The current inventory only routes `cluster1`. For another instance, add frontends and backends named after
that cluster (e.g. `cluster2-ReadWrite-frontend` / `cluster2-ReadWrite-backend`) with unused frontend ports and the
backend ports of that instance from [`stolon_clusters`](stolon.md).
