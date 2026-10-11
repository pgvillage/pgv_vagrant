# pgroute66 inventory (multi-instance)

File: `environments/cluster1/group_vars/all/pgroute66.yml`

Added in commit `1f64378` (latest state). pgroute66 runs on the `router` hosts and tells HAProxy which database host is
primary or standby for each cluster (used by `checkpgprimary.sh` / `checkpgstandby.sh`, see [haproxy.md](haproxy.md)).

## Settings

| Variable                  | Description                                                                     |
|---------------------------|---------------------------------------------------------------------------------|
| `pgroute66_pgport`        | Default Postgres port (`5433`).                                                  |
| `pgroute66_pgnodes_group` | Inventory group that holds the database hosts (`hacluster`).                     |
| `pgroute66_clusters`      | Dictionary with one entry per cluster; `pgport` is the Postgres port of that cluster. |
| `pgroute66_config`        | Configuration file contents of pgroute66, generated from the settings above.     |

## `pgroute66_clusters`

```yaml
pgroute66_clusters:
  cluster1:
    pgport: 5433
  cluster2:
    pgport: 5434
```

The keys must match the keys in [`stolon_clusters`](stolon.md) and the `<cluster>` prefix of the HAProxy frontend
names; `pgport` must match `stolon_clusters.<cluster>.sysconfig.stkeeper.pg_port`.

## `pgroute66_config`

| Key         | Description                                                                      |
|-------------|----------------------------------------------------------------------------------|
| `groups`    | Generated: for every cluster in `pgroute66_clusters`, every host in `pgroute66_pgnodes_group` with `host`, `port` (the cluster's `pgport`) and `dbname` (`pgroute66_dbname`). |
| `loglevel`  | `{{ pgroute66_loglevel }}`                                                       |
| `verbosity` | `{{ pgroute66_verbosity }}`                                                      |
| `bind`      | `{{ pgroute66_bind }}`                                                           |
| `port`      | `{{ pgroute66_port }}`                                                           |

For this inventory `groups` renders to:

```yaml
groups:
  cluster1:
    db-1.local: {host: db-1.local, port: 5433, dbname: <pgroute66_dbname>}
    db-2.local: {host: db-2.local, port: 5433, dbname: <pgroute66_dbname>}
    db-3.local: {host: db-3.local, port: 5433, dbname: <pgroute66_dbname>}
  cluster2:
    db-1.local: {host: db-1.local, port: 5434, dbname: <pgroute66_dbname>}
    # ...
```
