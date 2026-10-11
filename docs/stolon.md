# stolon inventory (multi-instance)

File: `environments/cluster1/group_vars/all/stolon.yml`

Introduced in commit `8791986` (Multi instance changes).

## `stolon_default_cgroups`

systemd resource control settings applied to every stolon instance (keeper) by default.
Keys are systemd resource control directives (see `man systemd.resource-control`).

```yaml
stolon_default_cgroups:
  CPUQuota: 100%
  MemoryHigh: 8G
```

Use this to prevent one instance from starving the other instances on the same host.

## `stolon_clusters`

Dictionary with one entry per stolon cluster (Postgres instance) running on the hosts in `stolon_host_group`.
The key is the cluster name. For every entry separate sentinel, keeper and proxy services are deployed.

### `sysconfig`

Settings written to the sysconfig (environment) files of the stolon services of that instance.

| Key                           | Description                                                                     |
|-------------------------------|---------------------------------------------------------------------------------|
| `stsentinel.cluster_name`     | Stolon cluster name used by the sentinel.                                       |
| `stkeeper.cluster_name`       | Stolon cluster name used by the keeper.                                         |
| `stkeeper.pg_port`            | Port Postgres listens on. Must be unique per host.                               |
| `stkeeper.data_dir`           | Keeper data directory for this instance.                                        |
| `stkeeper.pgdata_dir`         | PGDATA of the instance (usually `<data_dir>/postgres`).                          |
| `stkeeper.wal_dir`            | Keeper WAL directory for this instance.                                         |
| `stkeeper.pgwal_dir`          | Postgres WAL directory (pg_wal) for this instance.                              |
| `stproxy.cluster_name`        | Stolon cluster name used by the proxy.                                          |
| `stproxy.port`                | Port the stolon proxy listens on. Must be unique per host.                       |

### `custom_config`

Merged into the stolon cluster specification of this instance.

| Key                                  | Description                                                        |
|--------------------------------------|--------------------------------------------------------------------|
| `pgParameters.log_directory`         | Postgres log directory, typically `{{ stolon_pg_log_directory }}/<name>`. |
| `pgParameters.archive_command`       | Instance aware wal-g archive command, e.g. `/opt/wal-g/scripts/archive.sh <name> %p` (added in `1f64378`). |

Example:

```yaml
stolon_clusters:
  cluster1:
    sysconfig:
      stsentinel:
        cluster_name: cluster1
      stkeeper:
        cluster_name: cluster1
        pg_port: 5432
        data_dir: "{{ postgresql_data_mountpoint }}/cluster1"
        pgdata_dir: "{{ postgresql_data_mountpoint }}/cluster1/postgres"
        wal_dir: "{{ stolon_wal_dir }}/cluster1"
        pgwal_dir: "{{ stolon_wal_dir }}/cluster1"
      stproxy:
        cluster_name: cluster1
        port: 25432
    custom_config:
      pgParameters:
        log_directory: "{{ stolon_pg_log_directory }}/cluster1"
  cluster2:
    sysconfig:
      stsentinel:
        cluster_name: cluster2
      stkeeper:
        cluster_name: cluster2
        pg_port: 5433
        data_dir: "{{ postgresql_data_mountpoint }}/cluster2"
        pgdata_dir: "{{ postgresql_data_mountpoint }}/cluster2/postgres"
        wal_dir: "{{ stolon_wal_dir }}/cluster2"
        pgwal_dir: "{{ stolon_wal_dir }}/cluster2"
      stproxy:
        cluster_name: cluster2
        port: 25433
    custom_config:
      pgParameters:
        log_directory: "{{ stolon_pg_log_directory }}/cluster2"
```

## Consistency rules

- `pg_port` and `stproxy.port` must be unique per host and opened in [`firewall_ports`](firewall.md).
- `pgdata_dir` and `pg_port` must match the corresponding entry in [`walg_clusters`](walg.md).
- The cluster name should match a bucket in [`minio_buckets`](minio.md).
