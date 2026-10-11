# MinIO inventory (multi-instance)

File: `environments/cluster1/group_vars/all/minio.yml`

Changed in commit `8791986` (Multi instance changes).

## `minio_buckets`

List of buckets created on the MinIO server. Previously a single bucket (`"{{ bucket_name }}"`) was created.
With multi-instance every Postgres instance gets its own bucket, named after the instance:

```yaml
minio_buckets:
  - cluster1
  - cluster2
```

Every bucket name must match the bucket in `s3_prefix` of the matching entry in [`walg_clusters`](walg.md)
(e.g. `s3_prefix: "s3://cluster1"`).
