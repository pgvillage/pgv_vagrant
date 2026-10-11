# Linux inventory (multi-instance)

File: `environments/cluster1/group_vars/all/packages.yml`

Changed in commit `1f64378` (latest state). These settings are not specific to an instance, but are needed for the
components that the multi-instance setup uses (haproxy, keepalived, pgroute66 on the router hosts).

## `linux_pg_version`

Postgres version used for package names and repositories (`{{ postgresql_version }}`).

## `linux_users`

Dictionary with an inventory group name as key and the list of users to create on the hosts in that group as value.
Each user has `name` and optionally `shell` and `system`.

```yaml
linux_users:
  hacluster:
    - name: postgres
      shell: /bin/bash
      system: true
    - name: pgbouncer
      shell: /bin/bash
      system: true
    - name: avchecker
      system: true
    - name: pgquartz
      system: true
    - name: pgfga
      system: true
    - name: pgroute66
      system: true
  backup:
    - name: minio
      system: true
  router:
    - name: haproxy
      system: true
    - name: keepalived
      system: true
    - name: pgroute66
      system: true
```

## `linux_groups`

Same structure as `linux_users`, for groups (`name`, `system`).

```yaml
linux_groups:
  hacluster:
    - name: postgres
      system: true
  backup:
    - name: minio
      system: true
  router:
    - name: pgroute66
      system: true
```

## `linux_packages`

Dictionary with an inventory group name as key and the list of packages to install on that group as value.

```yaml
linux_packages:
  hacluster:
    - "acl"
    - "postgresql-{{ linux_pg_version | replace('.', '') }}"
    - "stolon"
    - "wal-g-pg"
    - "etcd"
  backup:
    - "acl"
    - "minio"
  router:
    - keepalived
    - haproxy
    - pgroute66
  localhosts:
    - "chainsmith"
```

## `linux_public_repos`

List of package repositories to configure.

| Key           | Description                                     |
|---------------|-------------------------------------------------|
| `name`        | Repository name.                                |
| `description` | Human readable description.                     |
| `repo`        | Repository definition (APT source line).        |
| `enabled`     | Whether the repository is enabled.              |
| `priority`    | Repository priority.                            |

The inventory configures the PgVillage APT repository and the PGDG repository for Ubuntu:

```yaml
linux_public_repos:
  - name: PgVillage
    description: "PgVillage DEB Library - Ubuntu {{ ansible_facts.distribution_version }} - {{ ansible_facts.architecture }}"
    repo: >-
      [signed-by=/etc/apt/keyrings/pgvillage.asc arch={{ linux_architecture }}]
      https://repo.mannemsolutions.nl/apt/v0.3.2
      {{ ansible_facts.distribution_release }}
      main
    priority: 10
  - name: "pgdg{{ linux_pg_version }}"
    description: "PostgreSQL {{ linux_pg_version }} for Ubuntu {{ ansible_facts.distribution_version }} - {{ ansible_facts.architecture }}"
    repo: |
      [signed-by=/etc/apt/keyrings/postgresql.asc] https://apt.postgresql.org/pub/repos/apt {{ ansible_facts.distribution_release }}-pgdg main
    enabled: true
    priority: 20
```
