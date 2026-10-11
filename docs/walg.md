# wal-g inventory (multi-instance)

File: `environments/cluster1/group_vars/all/wal-g.yml`

Introduced in commit `d5fa688` (wal-g multi-instance).

## `walg_clusters`

Dictionary with one entry per Postgres instance on the host. The key is the instance (cluster) name and must match
the key used in [`stolon_clusters`](stolon.md) and the bucket name in [`minio_buckets`](minio.md).
For every entry the role deploys a separate wal-g configuration, log folder and backup cron job.

| Key                | Description                                                                                  |
|--------------------|----------------------------------------------------------------------------------------------|
| `pg_datadir`       | PGDATA of the instance. Must match `stolon_clusters.<name>.sysconfig.stkeeper.pgdata_dir`.   |
| `pg_port`          | Port the instance listens on. Must match `stolon_clusters.<name>.sysconfig.stkeeper.pg_port`. |
| `s3_prefix`        | S3 location backups and WAL are written to (e.g. `s3://cluster1`).                           |
| `logfolder`        | Log folder for wal-g of this instance, typically `{{ walg_logfolder }}/<name>/`.             |
| `cron.enabled`     | Enable the scheduled backup for this instance (defaults to `walg_cron_enabled`).             |
| `cron.minute`      | Minute of the backup cron job (defaults to `walg_cron_minute`).                              |
| `cron.hour`        | Hour of the backup cron job (defaults to `walg_cron_hour`).                                  |

Example:

```yaml
walg_clusters:
  cluster1:
    pg_datadir: "{{ postgresql_data_mountpoint }}/cluster1/postgres"
    pg_port: 5432
    s3_prefix: "s3://cluster1"
    logfolder: "{{ walg_logfolder }}/cluster1/"
    cron:
      enabled: "{{ walg_cron_enabled }}"
      minute: "{{ walg_cron_minute }}"
      hour: "{{ walg_cron_hour }}"
  cluster2:
    pg_datadir: "{{ postgresql_data_mountpoint }}/cluster2/postgres"
    pg_port: 5433
    s3_prefix: "s3://cluster2"
    logfolder: "{{ walg_logfolder }}/cluster2/"
    cron:
      enabled: "{{ walg_cron_enabled }}"
      minute: "{{ walg_cron_minute }}"
      hour: "{{ walg_cron_hour }}"
```

Tip: stagger `cron.minute` / `cron.hour` per instance so backups of all instances on a host do not run at the same time.

## `walg_bucket_defaults.S3_CA_CERT_FILE`

Changed from the hardcoded `/var/lib/pgsql/.postgresql/root.crt` to a path relative to the home directory of the wal-g user:

```yaml
S3_CA_CERT_FILE: "{{ getent_passwd[walg_user][4] }}/.postgresql/root.crt"
```

This makes the setting work on distributions where the postgres home directory differs (e.g. Ubuntu `/var/lib/postgresql`).
It requires `getent_passwd` facts to be gathered for `walg_user`.

## Related

- Each stolon instance must archive through the instance aware archive script, see `archive_command` in [stolon.md](stolon.md).
