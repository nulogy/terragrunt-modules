# Data Platform Database User

This module is currently designed for OpsCore.

In particular, it relies on the existence of a database role `readonly` that has read permissions to all the database's tables.

## Future plans

To support ECO or Production Scheduling, we have options:
* Create a new module for those apps
* Add a configuration variable to this module and switch over different SQL templates for `GRANT` and `REVOKE` statements.
