# MongoDB backup

## k8s
Every declaration file is contained in k8s/ folder. This service uses a MongoDB client to manage backups and a CronJob as a backup agent.

## Backup Script

The backup-script.sh file must be placed at the `/var/backups` folder of the MongoDB client. This client shares this mount point with the CronJob container.
