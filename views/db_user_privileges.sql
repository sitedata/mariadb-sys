#
# Name: db_user_privilegs
# Author: YJ
# Last Update: 2017.12.01
# Desc: list of privileges of user & role
#
# MariaDB [sys]> select * from db_user_privileges;
# +-------------+---------+---------+------------+------------+---------------+-----------------+--------+-------+---------------------------------------------------------+
# | host        | user    | is_role | priv_level | priv_scope | default_role  | privileges      | target | grant | all_roles                                               |
# +-------------+---------+---------+------------+------------+---------------+-----------------+--------+-------+---------------------------------------------------------+
# | localhost   | root    | N       |          1 | Global     |               | all privileges  | *.*    | Y     | rl_ail,rl_aivdl,rl_backup,rl_dba,rl_galera_stt,rl_midas |
# | localhost   | dba     | N       |          1 | Global     | rl_dba        |                 | *.*    | NULL  | rl_dba                                                  |
# | 127.0.0.1   | dba     | N       |          1 | Global     | rl_dba        |                 | *.*    | NULL  | rl_dba                                                  |
# ...
# |             | rl_dba  | Y       |          1 | Global     |               | all privileges  | *.*    | NULL  | NULL                                                    |
# | localhost   | bkuser  | N       |          1 | Global     | rl_backup     |                 | *.*    | NULL  | rl_backup                                               |
# +-------------+---------+---------+------------+------------+---------------+-----------------+--------+-------+---------------------------------------------------------+
CREATE OR REPLACE
ALGORITHM=UNDEFINED
DEFINER = 'root'@'localhost'
SQL SECURITY DEFINER
VIEW `db_user_privileges`
AS
--
-- Global Privileges
--
SELECT mu.host `host`,
       mu.user `user`,
       mu.is_role,
       1 AS priv_level,
       'Global' AS priv_scope,
       mu.default_role,
       CASE WHEN 'N' NOT IN (mu.select_priv, mu.insert_priv, mu.update_priv, mu.delete_priv, mu.create_priv,
                             mu.drop_priv, mu.reload_priv, mu.shutdown_priv, mu.process_priv, mu.file_priv,
                             mu.references_priv, mu.index_priv, mu.alter_priv, mu.show_db_priv,
                             mu.super_priv, mu.create_tmp_table_priv, mu.lock_tables_priv, mu.execute_priv,
                             mu.repl_slave_priv, mu.repl_client_priv, mu.create_view_priv, mu.show_view_priv,
                             mu.create_routine_priv, mu.alter_routine_priv, mu.create_user_priv, mu.event_priv,
                             mu.trigger_priv, mu.create_tablespace_priv)
            THEN 'all privileges '
       ELSE
           CONCAT_WS(', ',
           IF(mu.select_priv = 'Y', 'select', NULL),
           IF(mu.insert_priv = 'Y', 'insert', NULL),
           IF(mu.update_priv = 'Y', 'update', NULL),
           IF(mu.delete_priv = 'Y', 'delete', NULL),
           IF(mu.create_priv = 'Y', 'create', NULL),
           IF(mu.drop_priv = 'Y', 'drop', NULL),
           IF(mu.reload_priv = 'Y', 'reload', NULL),
           IF(mu.shutdown_priv = 'Y', 'shutdown', NULL),
           IF(mu.process_priv = 'Y', 'process', NULL),
           IF(mu.file_priv = 'Y', 'file', NULL),
           IF(mu.references_priv = 'Y', 'references', NULL),
           IF(mu.index_priv = 'Y', 'index', NULL),
           IF(mu.alter_priv = 'Y', 'alter', NULL),
           IF(mu.show_db_priv = 'Y', 'show databases', NULL),
           IF(mu.super_priv = 'Y', 'super', NULL),
           IF(mu.create_tmp_table_priv = 'Y', 'create temporary tables', NULL),
           IF(mu.lock_tables_priv = 'Y', 'lock tables', NULL),
           IF(mu.execute_priv = 'Y', 'execute', NULL),
           IF(mu.repl_slave_priv = 'Y', 'replication slave', NULL),
           IF(mu.repl_client_priv = 'Y', 'replication client', NULL),
           IF(mu.create_view_priv = 'Y', 'create view', NULL),
           IF(mu.show_view_priv = 'Y', 'show view', NULL),
           IF(mu.create_routine_priv = 'Y', 'create routine', NULL),
           IF(mu.alter_routine_priv = 'Y', 'alter routine', NULL),
           IF(mu.create_user_priv = 'Y', 'create user', NULL),
           IF(mu.event_priv = 'Y', 'event', NULL),
           IF(mu.trigger_priv = 'Y', 'trigger', NULL)
           )
       END AS `privileges`,
       '*.*' AS `target`,
       IF(mu.grant_priv='Y', 'Y', NULL) AS `grant`,
       (SELECT GROUP_CONCAT(r.role)
          FROM mysql.roles_mapping r
         WHERE mu.host = r.host
           AND mu.user = r.user
       ) AS all_roles
  FROM mysql.user mu
--
-- Database Privileges
--
UNION ALL
SELECT md.host `host`,
       md.user `user`,
       u.is_role,
       2 AS priv_level,
       'Database' AS priv_scope,
       u.default_role,
       CASE WHEN 'N' NOT IN (md.select_priv, md.insert_priv, md.update_priv, md.delete_priv, 
                             md.create_priv, md.drop_priv, 
                             md.references_priv, md.index_priv, md.alter_priv, 
                             md.create_tmp_table_priv, md.lock_tables_priv, md.create_view_priv, md.show_view_priv, 
                             md.create_routine_priv, md.alter_routine_priv, md.execute_priv, 
                             md.event_priv, md.trigger_priv)
            THEN 'all privileges '
       ELSE
           CONCAT_WS(', ',
           IF(md.select_priv = 'Y', 'select', NULL),
           IF(md.insert_priv = 'Y', 'insert', NULL),
           IF(md.update_priv = 'Y', 'update', NULL),
           IF(md.delete_priv = 'Y', 'delete', NULL),
           IF(md.create_priv = 'Y', 'create', NULL),
           IF(md.drop_priv = 'Y', 'drop', NULL),
           IF(md.references_priv = 'Y', 'references', NULL),
           IF(md.index_priv = 'Y', 'index', NULL),
           IF(md.alter_priv = 'Y', 'alter', NULL),
           IF(md.create_tmp_table_priv = 'Y', 'create temporary tables', NULL),
           IF(md.lock_tables_priv = 'Y', 'lock tables', NULL),
           IF(md.create_view_priv = 'Y', 'create view', NULL),
           IF(md.show_view_priv = 'Y', 'show view', NULL),
           IF(md.create_routine_priv = 'Y', 'create routine', NULL),
           IF(md.alter_routine_priv = 'Y', 'alter routine', NULL),
           IF(md.execute_priv = 'Y', 'execute', NULL),
           IF(md.event_priv = 'Y', 'event', NULL),
           IF(md.trigger_priv = 'Y', 'trigger', NULL)
           )
       END AS `privileges`,
       CONCAT_WS('.', md.db, '*') AS `databases`,
       IF(md.grant_priv='Y', 'Y', NULL) AS `grant`,
       (SELECT GROUP_CONCAT(r.role)
          FROM mysql.roles_mapping r
         WHERE md.host = r.host
           AND md.user = r.user
       ) AS all_roles
  FROM mysql.db md
  LEFT OUTER JOIN mysql.user u
    ON md.host = u.host
   AND md.user = u.user
--
-- Table Privileges
--
UNION ALL
SELECT mt.host `host`,
       mt.user `user`,
       u.is_role,
       3 AS priv_level,
       'Table' AS priv_scope,
       u.default_role,
       REPLACE(mt.table_priv, ',', ', ') AS `privileges`,
       CONCAT(mt.db, '.', mt.table_name) `tables`,
       NULL AS `grant`,
       (SELECT GROUP_CONCAT(r.role)
          FROM mysql.roles_mapping r
         WHERE u.host = r.host
           AND u.user = r.user
       ) AS all_roles
  FROM mysql.tables_priv mt
  LEFT OUTER JOIN mysql.user u
    ON mt.host = u.host
   AND mt.user = u.user
 WHERE mt.table_name IN
       (SELECT t.table_name
          FROM information_schema.tables AS t
         WHERE t.table_type IN
               ('base table', 'system view', 'temporary', '')
            OR t.table_type <> 'view'
           AND t.create_options IS NOT NULL)
-- View Privileges
UNION ALL
SELECT mv.host `host`,
       mv.user `user`,
       u.is_role,
       4 AS priv_level,
       'View' AS priv_scope,
       u.default_role,
       REPLACE(mv.table_priv, ',', ', ') AS `privileges`,
       CONCAT(mv.db, '.', mv.table_name) `views`,
       NULL AS `grant`,
       (SELECT GROUP_CONCAT(r.role)
          FROM mysql.roles_mapping r
         WHERE u.host = r.host
           AND u.user = r.user
       ) AS all_roles
  from mysql.tables_priv mv
  LEFT OUTER JOIN mysql.user u
    ON mv.host = u.host
   AND mv.user = u.user
 WHERE mv.table_name IN
       (SELECT table_name from information_schema.views)
-- Table Column Privileges
UNION ALL
SELECT mtc.host `host`,
       mtc.user `user`,
       u.is_role,
       5 AS priv_level,
       'Table Column' AS priv_scope,
       u.default_role,
       REPLACE(mtc.column_priv, ',', ', ') AS `privileges`,
       CONCAT(mtc.db, '.', mtc.table_name, '.', mtc.column_name) `tables_columns`,
       NULL AS `grant`,
       (SELECT GROUP_CONCAT(r.role)
          FROM mysql.roles_mapping r
         WHERE u.host = r.host
           AND u.user = r.user
       ) AS all_roles
  from mysql.columns_priv mtc
  LEFT OUTER JOIN mysql.user u
    ON mtc.host = u.host
   AND mtc.user = u.user
 WHERE mtc.table_name IN
       (SELECT t.table_name
          from information_schema.tables AS t
         WHERE t.table_type IN
               ('base table', 'system view', 'temporary', '')
            OR t.table_type <> 'view'
           AND t.create_options IS NOT NULL)
-- View Column Privileges
UNION ALL
SELECT mvc.host `host`,
       mvc.user `user`,
       u.is_role,
       6 AS priv_level,
       'View Column' AS priv_scope,
       u.default_role,
       REPLACE(mvc.column_priv, ',', ', ') AS `privileges`,
       CONCAT(mvc.db, '.', mvc.table_name, '.', mvc.column_name) `views_columns`,
       NULL AS `grant`,
       (SELECT GROUP_CONCAT(r.role)
          FROM mysql.roles_mapping r
         WHERE u.host = r.host
           AND u.user = r.user
       ) AS all_roles
  from mysql.columns_priv mvc
  LEFT OUTER JOIN mysql.user u
    ON mvc.host = u.host
   AND mvc.user = u.user
 WHERE mvc.table_name IN
       (SELECT table_name from information_schema.views)
-- Procedure Privileges
UNION ALL
SELECT mp.host `host`,
       mp.user `user`,
       u.is_role,
       7 AS priv_level,
       'Procedure' AS priv_scope,
       u.default_role,
       REPLACE(mp.proc_priv, ',', ', ') AS `privileges`,
       CONCAT(mp.db, '.', mp.routine_name) `procedures`,
       NULL AS `grant`,
       (SELECT GROUP_CONCAT(r.role)
          FROM mysql.roles_mapping r
         WHERE u.host = r.host
           AND u.user = r.user
       ) AS all_roles
  from mysql.procs_priv mp
  LEFT OUTER JOIN mysql.user u
    ON mp.host = u.host
   AND mp.user = u.user
 WHERE mp.routine_type = 'procedure'
-- Function Privileges
UNION ALL
SELECT mf.host `host`,
       mf.user `user`,
       u.is_role,
       8 AS priv_level,
       'Function' AS priv_scope,
       u.default_role,
       REPLACE(mf.proc_priv, ',', ', ') AS `privileges`,
       CONCAT(mf.db, '.', mf.routine_name) `functions`,
       NULL AS `grant`,
       (SELECT GROUP_CONCAT(r.role)
          FROM mysql.roles_mapping r
         WHERE u.host = r.host
           AND u.user = r.user
       ) AS all_roles
  from mysql.procs_priv mf
  LEFT OUTER JOIN mysql.user u
    ON mf.host = u.host
   AND mf.user = u.user
 WHERE mf.routine_type = 'function'
;
