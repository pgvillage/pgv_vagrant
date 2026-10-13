---
title: PgBouncer - multiinstance
summary: A description of configuring pgbouncer to support pooling for multiple instances
authors:
  - Sebas Mannem
date: 2026-10-11
---

# PgPool - multiple instances

When deploting multiple HA clusters (e.a. stolon or Patroni), the pgvillage/pgbouncer role supports deploying multiple instances of PgBouncer too.

!!! note
    PgBouncer supports many features and with that many options for managing PostgreSQL instances.
    Some examples include: Installing PgBouncer locally vs on seperate servers, running multiple instances of PgBouncer on the same port,
    forwarding per database to another PostgreSQL instance, using multiple cnames to target a writable Postgres instance, etc.
    PgVillage aims at KISS, whicj to PgVillage means that we run a local instance next to the database server and only use PgBouncer for pooling.
    As such, the multiinstance feature for PgBouncer installs multiple instances of PgBouncer, which all should use their own port, 
    and forward to another local PostgreSQL instance.

To configure PgBouncer for multiinstance, edit the pgbouncer config (e.a. `environments/cluster1/group_vars/all/pgbouncer.yml`) 
and configure a seperate PgBouncer instance per Postgres cluster.

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

!!! Note
    Make sure you open [`firewall_ports`](firewall.md) for PgBouncer (unless PgBouncer should only be available through HAProxy).
