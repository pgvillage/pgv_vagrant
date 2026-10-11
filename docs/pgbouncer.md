# pgbouncer inventory (multi-instance)

Files:
- `environments/cluster1/group_vars/all/pgbouncer.yml` (added in commit `1f64378`, latest state)
- `environments/cluster1/group_vars/hacluster/pgbouncer.yml` (`pgbouncer_pgdata`, `pgbouncer_install_dir`)

## `pgbouncer_instances`

Dictionary with one entry per pgbouncer instance. The key is the instance name. Each instance sits in front of one
Postgres instance.

| Key             | Description                                                                              |
|-----------------|------------------------------------------------------------------------------------------|
| `pgport`        | Port of the Postgres instance. Must match `stolon_clusters.<cluster>.sysconfig.stkeeper.pg_port`. |
| `port`          | Port pgbouncer listens on. Must be unique per host.                                      |
| `pgdata`        | PGDATA of the Postgres instance. Must match `stkeeper.pgdata_dir`.                        |
| `pgenv`         | Environment settings for the connection to Postgres, e.g. `service: cluster1-master`.     |

```yaml
pgbouncer_instances:
  instance1:
    pgport: 5433
    port: 6433
    pgdata: "/mnt/data/cluster1/postgres"
    pgenv:
      service: cluster1-master
  instance2:
    pgport: 5434
    port: 6434
    pgdata: "/mnt/data/cluster2/postgres"
    pgenv:
      service: cluster2-master
```

## Notes

- `pgbouncer_pgdata` in `group_vars/hacluster/pgbouncer.yml` still points to the single-instance `{{ stolon_data_dir }}/postgres/`.
- The pgbouncer ports (6433, 6434) are not in [`firewall_ports`](firewall.md). Add them if clients outside the host
  need to connect to pgbouncer.
