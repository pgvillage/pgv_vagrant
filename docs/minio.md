---
title: minio - multiinstance
summary: A description of configuring minio to support backups for multiple instances
authors:
  - Sebas Mannem
date: 2026-10-11
---

# mini - multiple buckets

When deploting multiple HA clusters (e.a. stolon or Patroni), you should seperate the backups for each cluster to another bucket.
To configure Minio with multiple buckets, edit the avchecker config (e.a. `environments/cluster1/group_vars/all/minio.yml`) and define a bucket per cluster.
Then configure `s3_prefix` for each [walg_clusters](./walg.md) for each cluster to use the bucket meant for it.

## `minio_buckets`

With multi-instance every Postgres instance gets its own bucket, named after the instance:

```yaml
minio_buckets:
  - cluster1
  - cluster2
```
