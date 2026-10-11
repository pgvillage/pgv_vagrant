# Nagios inventory

File: `environments/cluster1/group_vars/all/nagios.yml`

Changed in commit `8791986` (Multi instance changes).

## `nagios_enabled`

Boolean to enable or disable the nagios role. It is set to `false` in this inventory
(the README also requires this for Ubuntu deployments).

```yaml
nagios_enabled: false
```
