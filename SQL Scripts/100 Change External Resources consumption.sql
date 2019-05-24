/* What's goin on */
SELECT * FROM sys.resource_governor_resource_pools WHERE name = 'default'
SELECT * FROM sys.resource_governor_external_resource_pools WHERE name = 'default'

/* Change possible memory consumption */
ALTER EXTERNAL RESOURCE POOL "default" WITH (max_memory_percent = 40);
ALTER RESOURCE GOVERNOR RECONFIGURE;
SELECT * FROM sys.resource_governor_external_resource_pools WHERE name = 'default'

/* Reconfigure :-) */
ALTER EXTERNAL RESOURCE POOL "default" WITH (max_memory_percent = 20);
ALTER RESOURCE GOVERNOR RECONFIGURE;