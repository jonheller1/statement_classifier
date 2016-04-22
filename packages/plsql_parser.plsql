create or replace package plsql_parser is
--Copyright (C) 2016 Jon Heller.  This program is licensed under the LGPLv3.

--  _____   ____    _   _  ____ _______   _    _  _____ ______  __     ________ _______ 
-- |  __ \ / __ \  | \ | |/ __ \__   __| | |  | |/ ____|  ____| \ \   / /  ____|__   __|
-- | |  | | |  | | |  \| | |  | | | |    | |  | | (___ | |__     \ \_/ /| |__     | |   
-- | |  | | |  | | | . ` | |  | | | |    | |  | |\___ \|  __|     \   / |  __|    | |   
-- | |__| | |__| | | |\  | |__| | | |    | |__| |____) | |____     | |  | |____   | |   
-- |_____/ \____/  |_| \_|\____/  |_|     \____/|_____/|______|    |_|  |______|  |_|   
-- 
--This package is experimental and does not work yet.


function parse(
		p_source        in clob,
		p_user          in varchar2 default user
) return node_table;

/*

== Purpose ==

Parse Oracle SQL and PL/SQL statements.  Currently only SELECT statements are supported.

== Example ==

select lpad('   ', (level - 1) * 3, '   ') || type type, to_char(a.lexer_token.value) value, a.*
from table(plsql_parser.parse('select * from dual', user)) a
start with parent_id is null
connect by parent_id = prior id;

== Parameters ==

P_SOURCE - The SQL or PL/SQL statement to parse.
P_USER   - The user who runs the statement or owns the object.  Used for object resolution.

Raises: ORA-20123 for parse errors.  The SQLERRM contains the production rule and expected values.

Returns  - NODE_TABLE (todo)

--TODO: Put these in installer if this ever works.
create or replace type node is object
(
    id                  number,         --Unique identifier for the node.
    type                varchar2(4000), --String to represent the node type.  See the constants in PARSER.
    parent_id           number,         --Unique identifier of the node's parent.
	lexer_token         token           --Token information.
);
create or replace type node_table is table of node;


*/


--Constants for node types.

--Constants that are not auto-generated.

--Not listed:
C_QUERY_NAME                     constant varchar2(100) := 'query_name';
C_T_ALIAS                        constant varchar2(100) := 't_alias';

--"SELECT" collides with the "SELECT" terminal.
C_SELECT_STATEMENT               constant varchar2(100) := 'select_statement';


--These constants were generated from the Oracle SQL Language Reference image
--text descriptions.  Using a command like "C:\E50529_01\SQLRF\img_text>dir" and
--some string processing.
C_ABS                            constant varchar2(100) := 'abs';
C_ACOS                           constant varchar2(100) := 'acos';
C_ACTION_AUDIT_CLAUSE            constant varchar2(100) := 'action_audit_clause';
C_ACTIVATE_STANDBY_DB_CLAUSE     constant varchar2(100) := 'activate_standby_db_clause';
C_ADD_BINDING_CLAUSE             constant varchar2(100) := 'add_binding_clause';
C_ADD_COLUMN_CLAUSE              constant varchar2(100) := 'add_column_clause';
C_ADD_DISK_CLAUSE                constant varchar2(100) := 'add_disk_clause';
C_ADD_HASH_INDEX_PARTITION       constant varchar2(100) := 'add_hash_index_partition';
C_ADD_HASH_PARTITION_CLAUSE      constant varchar2(100) := 'add_hash_partition_clause';
C_ADD_HASH_SUBPARTITION          constant varchar2(100) := 'add_hash_subpartition';
C_ADD_LIST_PARTITION_CLAUSE      constant varchar2(100) := 'add_list_partition_clause';
C_ADD_LIST_SUBPARTITION          constant varchar2(100) := 'add_list_subpartition';
C_ADD_LOGFILE_CLAUSES            constant varchar2(100) := 'add_logfile_clauses';
C_ADD_MONTHS                     constant varchar2(100) := 'add_months';
C_ADD_MV_LOG_COLUMN_CLAUSE       constant varchar2(100) := 'add_mv_log_column_clause';
C_ADD_OVERFLOW_CLAUSE            constant varchar2(100) := 'add_overflow_clause';
C_ADD_PERIOD_CLAUSE              constant varchar2(100) := 'add_period_clause';
C_ADD_RANGE_PARTITION_CLAUSE     constant varchar2(100) := 'add_range_partition_clause';
C_ADD_RANGE_SUBPARTITION         constant varchar2(100) := 'add_range_subpartition';
C_ADD_SYSTEM_PARTITION_CLAUSE    constant varchar2(100) := 'add_system_partition_clause';
C_ADD_TABLE_PARTITION            constant varchar2(100) := 'add_table_partition';
C_ADD_UPDATE_SECRET              constant varchar2(100) := 'add_update_secret';
C_ADD_VOLUME_CLAUSE              constant varchar2(100) := 'add_volume_clause';
C_ADMINISTER_KEY_MANAGEMENT      constant varchar2(100) := 'administer_key_management';
C_ADVANCED_INDEX_COMPRESSION     constant varchar2(100) := 'advanced_index_compression';
C_ALIAS_FILE_NAME                constant varchar2(100) := 'alias_file_name';
C_ALLOCATE_EXTENT_CLAUSE         constant varchar2(100) := 'allocate_extent_clause';
C_ALLOW_DISALLOW_CLUSTERING      constant varchar2(100) := 'allow_disallow_clustering';
C_ALL_ROWS_HINT                  constant varchar2(100) := 'all_rows_hint';
C_ALTER_AUDIT_POLICY             constant varchar2(100) := 'alter_audit_policy';
C_ALTER_CLUSTER                  constant varchar2(100) := 'alter_cluster';
C_ALTER_DATABASE                 constant varchar2(100) := 'alter_database';
C_ALTER_DATABASE_LINK            constant varchar2(100) := 'alter_database_link';
C_ALTER_DATAFILE_CLAUSE          constant varchar2(100) := 'alter_datafile_clause';
C_ALTER_DIMENSION                constant varchar2(100) := 'alter_dimension';
C_ALTER_DISKGROUP                constant varchar2(100) := 'alter_diskgroup';
C_ALTER_EXTERNAL_TABLE           constant varchar2(100) := 'alter_external_table';
C_ALTER_FLASHBACK_ARCHIVE        constant varchar2(100) := 'alter_flashback_archive';
C_ALTER_FUNCTION                 constant varchar2(100) := 'alter_function';
C_ALTER_INDEX                    constant varchar2(100) := 'alter_index';
C_ALTER_INDEXTYPE                constant varchar2(100) := 'alter_indextype';
C_ALTER_INDEX_PARTITIONING       constant varchar2(100) := 'alter_index_partitioning';
C_ALTER_INTERVAL_PARTITIONING    constant varchar2(100) := 'alter_interval_partitioning';
C_ALTER_IOT_CLAUSES              constant varchar2(100) := 'alter_iot_clauses';
C_ALTER_JAVA                     constant varchar2(100) := 'alter_java';
C_ALTER_KEYSTORE_PASSWORD        constant varchar2(100) := 'alter_keystore_password';
C_ALTER_LIBRARY                  constant varchar2(100) := 'alter_library';
C_ALTER_MAPPING_TABLE_CLAUSES    constant varchar2(100) := 'alter_mapping_table_clauses';
C_ALTER_MATERIALIZED_VIEW        constant varchar2(100) := 'alter_materialized_view';
C_ALTER_MATERIALIZED_VIEW_LOG    constant varchar2(100) := 'alter_materialized_view_log';
C_ALTER_MATERIALIZED_ZONEMAP     constant varchar2(100) := 'alter_materialized_zonemap';
C_ALTER_MV_REFRESH               constant varchar2(100) := 'alter_mv_refresh';
C_ALTER_OPERATOR                 constant varchar2(100) := 'alter_operator';
C_ALTER_OUTLINE                  constant varchar2(100) := 'alter_outline';
C_ALTER_OVERFLOW_CLAUSE          constant varchar2(100) := 'alter_overflow_clause';
C_ALTER_PACKAGE                  constant varchar2(100) := 'alter_package';
C_ALTER_PLUGGABLE_DATABASE       constant varchar2(100) := 'alter_pluggable_database';
C_ALTER_PROCEDURE                constant varchar2(100) := 'alter_procedure';
C_ALTER_PROFILE                  constant varchar2(100) := 'alter_profile';
C_ALTER_QUERY_REWRITE_CLAUSE     constant varchar2(100) := 'alter_query_rewrite_clause';
C_ALTER_RESOURCE_COST            constant varchar2(100) := 'alter_resource_cost';
C_ALTER_ROLE                     constant varchar2(100) := 'alter_role';
C_ALTER_ROLLBACK_SEGMENT         constant varchar2(100) := 'alter_rollback_segment';
C_ALTER_SEQUENCE                 constant varchar2(100) := 'alter_sequence';
C_ALTER_SESSION                  constant varchar2(100) := 'alter_session';
C_ALTER_SESSION_SET_CLAUSE       constant varchar2(100) := 'alter_session_set_clause';
C_ALTER_SYNONYM                  constant varchar2(100) := 'alter_synonym';
C_ALTER_SYSTEM                   constant varchar2(100) := 'alter_system';
C_ALTER_SYSTEM_RESET_CLAUSE      constant varchar2(100) := 'alter_system_reset_clause';
C_ALTER_SYSTEM_SET_CLAUSE        constant varchar2(100) := 'alter_system_set_clause';
C_ALTER_TABLE                    constant varchar2(100) := 'alter_table';
C_ALTER_TABLESPACE               constant varchar2(100) := 'alter_tablespace';
C_ALTER_TABLE_PARTITIONING       constant varchar2(100) := 'alter_table_partitioning';
C_ALTER_TABLE_PROPERTIES         constant varchar2(100) := 'alter_table_properties';
C_ALTER_TEMPFILE_CLAUSE          constant varchar2(100) := 'alter_tempfile_clause';
C_ALTER_TRIGGER                  constant varchar2(100) := 'alter_trigger';
C_ALTER_TYPE                     constant varchar2(100) := 'alter_type';
C_ALTER_USER                     constant varchar2(100) := 'alter_user';
C_ALTER_VARRAY_COL_PROPERTIES    constant varchar2(100) := 'alter_varray_col_properties';
C_ALTER_VIEW                     constant varchar2(100) := 'alter_view';
C_ALTER_XMLSCHEMA_CLAUSE         constant varchar2(100) := 'alter_xmlschema_clause';
C_ALTER_ZONEMAP_ATTRIBUTES       constant varchar2(100) := 'alter_zonemap_attributes';
C_ANALYTIC_CLAUSE                constant varchar2(100) := 'analytic_clause';
C_ANALYTIC_FUNCTION              constant varchar2(100) := 'analytic_function';
C_ANALYZE                        constant varchar2(100) := 'analyze';
C_ANSI_SUPPORTED_DATATYPES       constant varchar2(100) := 'ansi_supported_datatypes';
C_ANY_TYPES                      constant varchar2(100) := 'any_types';
C_APPENDCHILDXML                 constant varchar2(100) := 'appendchildxml';
C_APPEND_HINT                    constant varchar2(100) := 'append_hint';
C_APPEND_VALUES_HINT             constant varchar2(100) := 'append_values_hint';
C_APPROX_COUNT_DISTINCT          constant varchar2(100) := 'approx_count_distinct';
C_ARCHIVE_LOG_CLAUSE             constant varchar2(100) := 'archive_log_clause';
C_ARRAY_DML_CLAUSE               constant varchar2(100) := 'array_dml_clause';
C_ARRAY_STEP                     constant varchar2(100) := 'array_step';
C_ASCII                          constant varchar2(100) := 'ascii';
C_ASCIISTR                       constant varchar2(100) := 'asciistr';
C_ASIN                           constant varchar2(100) := 'asin';
C_ASM_FILENAME                   constant varchar2(100) := 'asm_filename';
C_ASSOCIATE_STATISTICS           constant varchar2(100) := 'associate_statistics';
C_ATAN                           constant varchar2(100) := 'atan';
C_ATAN2                          constant varchar2(100) := 'atan2';
C_ATTRIBUTE_CLAUSE               constant varchar2(100) := 'attribute_clause';
C_ATTRIBUTE_CLUSTERING_CLAUSE    constant varchar2(100) := 'attribute_clustering_clause';
C_AUDIT                          constant varchar2(100) := 'audit';
C_AUDITING_BY_CLAUSE             constant varchar2(100) := 'auditing_by_clause';
C_AUDITING_ON_CLAUSE             constant varchar2(100) := 'auditing_on_clause';
C_AUDIT_OPERATION_CLAUSE         constant varchar2(100) := 'audit_operation_clause';
C_AUDIT_SCHEMA_OBJECT_CLAUSE     constant varchar2(100) := 'audit_schema_object_clause';
C_AUTOEXTEND_CLAUSE              constant varchar2(100) := 'autoextend_clause';
C_AVG                            constant varchar2(100) := 'avg';
C_BACKUP_KEYSTORE                constant varchar2(100) := 'backup_keystore';
C_BETWEEN_CONDITION              constant varchar2(100) := 'between_condition';
C_BFILENAME                      constant varchar2(100) := 'bfilename';
C_BINDING_CLAUSE                 constant varchar2(100) := 'binding_clause';
C_BIN_TO_NUM                     constant varchar2(100) := 'bin_to_num';
C_BITAND                         constant varchar2(100) := 'bitand';
C_BITMAP_JOIN_INDEX_CLAUSE       constant varchar2(100) := 'bitmap_join_index_clause';
C_BUILD_CLAUSE                   constant varchar2(100) := 'build_clause';
C_CACHE_HINT                     constant varchar2(100) := 'cache_hint';
C_CALL                           constant varchar2(100) := 'call';
C_CARDINALITY                    constant varchar2(100) := 'cardinality';
C_CASE_EXPRESSION                constant varchar2(100) := 'case_expression';
C_CAST                           constant varchar2(100) := 'cast';
C_CEIL                           constant varchar2(100) := 'ceil';
C_CELL_ASSIGNMENT                constant varchar2(100) := 'cell_assignment';
C_CELL_REFERENCE_OPTIONS         constant varchar2(100) := 'cell_reference_options';
C_CHANGE_DUPKEY_ERROR_INDEX      constant varchar2(100) := 'change_dupkey_error_index';
C_CHARACTER_DATATYPES            constant varchar2(100) := 'character_datatypes';
C_CHARACTER_SET_CLAUSE           constant varchar2(100) := 'character_set_clause';
C_CHARTOROWID                    constant varchar2(100) := 'chartorowid';
C_CHECKPOINT_CLAUSE              constant varchar2(100) := 'checkpoint_clause';
C_CHECK_DATAFILES_CLAUSE         constant varchar2(100) := 'check_datafiles_clause';
C_CHECK_DISKGROUP_CLAUSE         constant varchar2(100) := 'check_diskgroup_clause';
C_CHR                            constant varchar2(100) := 'chr';
C_CLOSE_KEYSTORE                 constant varchar2(100) := 'close_keystore';
C_CLUSTERING_COLUMNS             constant varchar2(100) := 'clustering_columns';
C_CLUSTERING_COLUMN_GROUP        constant varchar2(100) := 'clustering_column_group';
C_CLUSTERING_HINT                constant varchar2(100) := 'clustering_hint';
C_CLUSTERING_JOIN                constant varchar2(100) := 'clustering_join';
C_CLUSTERING_WHEN                constant varchar2(100) := 'clustering_when';
C_CLUSTER_CLAUSE                 constant varchar2(100) := 'cluster_clause';
C_CLUSTER_DETAILS                constant varchar2(100) := 'cluster_details';
C_CLUSTER_DETAILS_ANALYTIC       constant varchar2(100) := 'cluster_details_analytic';
C_CLUSTER_DISTANCE               constant varchar2(100) := 'cluster_distance';
C_CLUSTER_DISTANCE_ANALYTIC      constant varchar2(100) := 'cluster_distance_analytic';
C_CLUSTER_HINT                   constant varchar2(100) := 'cluster_hint';
C_CLUSTER_ID                     constant varchar2(100) := 'cluster_id';
C_CLUSTER_ID_ANALYTIC            constant varchar2(100) := 'cluster_id_analytic';
C_CLUSTER_INDEX_CLAUSE           constant varchar2(100) := 'cluster_index_clause';
C_CLUSTER_PROBABILITY            constant varchar2(100) := 'cluster_probability';
C_CLUSTER_PROB_ANALYTIC          constant varchar2(100) := 'cluster_prob_analytic';
C_CLUSTER_RANGE_PARTITIONS       constant varchar2(100) := 'cluster_range_partitions';
C_CLUSTER_SET                    constant varchar2(100) := 'cluster_set';
C_CLUSTER_SET_ANALYTIC           constant varchar2(100) := 'cluster_set_analytic';
C_COALESCE                       constant varchar2(100) := 'coalesce';
C_COALESCE_INDEX_PARTITION       constant varchar2(100) := 'coalesce_index_partition';
C_COALESCE_TABLE_PARTITION       constant varchar2(100) := 'coalesce_table_partition';
C_COALESCE_TABLE_SUBPARTITION    constant varchar2(100) := 'coalesce_table_subpartition';
C_COLLECT                        constant varchar2(100) := 'collect';
C_COLUMN_ASSOCIATION             constant varchar2(100) := 'column_association';
C_COLUMN_CLAUSES                 constant varchar2(100) := 'column_clauses';
C_COLUMN_DEFINITION              constant varchar2(100) := 'column_definition';
C_COLUMN_PROPERTIES              constant varchar2(100) := 'column_properties';
C_COMMENT                        constant varchar2(100) := 'comment';
C_COMMIT                         constant varchar2(100) := 'commit';
C_COMMIT_SWITCHOVER_CLAUSE       constant varchar2(100) := 'commit_switchover_clause';
C_COMPONENT_ACTIONS              constant varchar2(100) := 'component_actions';
C_COMPOSE                        constant varchar2(100) := 'compose';
C_COMPOSITE_HASH_PARTITIONS      constant varchar2(100) := 'composite_hash_partitions';
C_COMPOSITE_LIST_PARTITIONS      constant varchar2(100) := 'composite_list_partitions';
C_COMPOSITE_RANGE_PARTITIONS     constant varchar2(100) := 'composite_range_partitions';
C_COMPOUND_CONDITION             constant varchar2(100) := 'compound_condition';
C_COMPOUND_EXPRESSION            constant varchar2(100) := 'compound_expression';
C_CONCAT                         constant varchar2(100) := 'concat';
C_CONDITION                      constant varchar2(100) := 'condition';
C_CONDITIONAL_INSERT_CLAUSE      constant varchar2(100) := 'conditional_insert_clause';
C_CONSTRAINT                     constant varchar2(100) := 'constraint';
C_CONSTRAINT_CLAUSES             constant varchar2(100) := 'constraint_clauses';
C_CONSTRAINT_STATE               constant varchar2(100) := 'constraint_state';
C_CONTAINERS_CLAUSE              constant varchar2(100) := 'containers_clause';
C_CONTAINER_DATA_CLAUSE          constant varchar2(100) := 'container_data_clause';
C_CONTEXT_CLAUSE                 constant varchar2(100) := 'context_clause';
C_CONTROLFILE_CLAUSES            constant varchar2(100) := 'controlfile_clauses';
C_CONVERT                        constant varchar2(100) := 'convert';
C_CONVERT_DATABASE_CLAUSE        constant varchar2(100) := 'convert_database_clause';
C_CON_DBID_TO_ID                 constant varchar2(100) := 'con_dbid_to_id';
C_CON_GUID_TO_ID                 constant varchar2(100) := 'con_guid_to_id';
C_CON_NAME_TO_ID                 constant varchar2(100) := 'con_name_to_id';
C_CON_UID_TO_ID                  constant varchar2(100) := 'con_uid_to_id';
C_CORR                           constant varchar2(100) := 'corr';
C_CORRELATION                    constant varchar2(100) := 'correlation';
C_COS                            constant varchar2(100) := 'cos';
C_COSH                           constant varchar2(100) := 'cosh';
C_COST_MATRIX_CLAUSE             constant varchar2(100) := 'cost_matrix_clause';
C_COUNT                          constant varchar2(100) := 'count';
C_COVAR_POP                      constant varchar2(100) := 'covar_pop';
C_COVAR_SAMP                     constant varchar2(100) := 'covar_samp';
C_CREATE_AUDIT_POLICY            constant varchar2(100) := 'create_audit_policy';
C_CREATE_CLUSTER                 constant varchar2(100) := 'create_cluster';
C_CREATE_CONTEXT                 constant varchar2(100) := 'create_context';
C_CREATE_CONTROLFILE             constant varchar2(100) := 'create_controlfile';
C_CREATE_DATABASE                constant varchar2(100) := 'create_database';
C_CREATE_DATABASE_LINK           constant varchar2(100) := 'create_database_link';
C_CREATE_DATAFILE_CLAUSE         constant varchar2(100) := 'create_datafile_clause';
C_CREATE_DIMENSION               constant varchar2(100) := 'create_dimension';
C_CREATE_DIRECTORY               constant varchar2(100) := 'create_directory';
C_CREATE_DISKGROUP               constant varchar2(100) := 'create_diskgroup';
C_CREATE_EDITION                 constant varchar2(100) := 'create_edition';
C_CREATE_FILE_DEST_CLAUSE        constant varchar2(100) := 'create_file_dest_clause';
C_CREATE_FLASHBACK_ARCHIVE       constant varchar2(100) := 'create_flashback_archive';
C_CREATE_FUNCTION                constant varchar2(100) := 'create_function';
C_CREATE_INDEX                   constant varchar2(100) := 'create_index';
C_CREATE_INDEXTYPE               constant varchar2(100) := 'create_indextype';
C_CREATE_JAVA                    constant varchar2(100) := 'create_java';
C_CREATE_KEY                     constant varchar2(100) := 'create_key';
C_CREATE_KEYSTORE                constant varchar2(100) := 'create_keystore';
C_CREATE_LIBRARY                 constant varchar2(100) := 'create_library';
C_CREATE_MATERIALIZED_VIEW       constant varchar2(100) := 'create_materialized_view';
C_CREATE_MATERIALIZED_VW_LOG     constant varchar2(100) := 'create_materialized_vw_log';
C_CREATE_MATERIALIZED_ZONEMAP    constant varchar2(100) := 'create_materialized_zonemap';
C_CREATE_MV_REFRESH              constant varchar2(100) := 'create_mv_refresh';
C_CREATE_OPERATOR                constant varchar2(100) := 'create_operator';
C_CREATE_OUTLINE                 constant varchar2(100) := 'create_outline';
C_CREATE_PACKAGE                 constant varchar2(100) := 'create_package';
C_CREATE_PACKAGE_BODY            constant varchar2(100) := 'create_package_body';
C_CREATE_PDB_CLONE               constant varchar2(100) := 'create_pdb_clone';
C_CREATE_PDB_FROM_SEED           constant varchar2(100) := 'create_pdb_from_seed';
C_CREATE_PDB_FROM_XML            constant varchar2(100) := 'create_pdb_from_xml';
C_CREATE_PFILE                   constant varchar2(100) := 'create_pfile';
C_CREATE_PLUGGABLE_DATABASE      constant varchar2(100) := 'create_pluggable_database';
C_CREATE_PROCEDURE               constant varchar2(100) := 'create_procedure';
C_CREATE_PROFILE                 constant varchar2(100) := 'create_profile';
C_CREATE_RESTORE_POINT           constant varchar2(100) := 'create_restore_point';
C_CREATE_ROLE                    constant varchar2(100) := 'create_role';
C_CREATE_ROLLBACK_SEGMENT        constant varchar2(100) := 'create_rollback_segment';
C_CREATE_SCHEMA                  constant varchar2(100) := 'create_schema';
C_CREATE_SEQUENCE                constant varchar2(100) := 'create_sequence';
C_CREATE_SPFILE                  constant varchar2(100) := 'create_spfile';
C_CREATE_SYNONYM                 constant varchar2(100) := 'create_synonym';
C_CREATE_TABLE                   constant varchar2(100) := 'create_table';
C_CREATE_TABLESPACE              constant varchar2(100) := 'create_tablespace';
C_CREATE_TRIGGER                 constant varchar2(100) := 'create_trigger';
C_CREATE_TYPE                    constant varchar2(100) := 'create_type';
C_CREATE_TYPE_BODY               constant varchar2(100) := 'create_type_body';
C_CREATE_USER                    constant varchar2(100) := 'create_user';
C_CREATE_VIEW                    constant varchar2(100) := 'create_view';
C_CREATE_ZONEMAP_AS_SUBQUERY     constant varchar2(100) := 'create_zonemap_as_subquery';
C_CREATE_ZONEMAP_ON_TABLE        constant varchar2(100) := 'create_zonemap_on_table';
C_CROSS_OUTER_APPLY_CLAUSE       constant varchar2(100) := 'cross_outer_apply_clause';
C_CUBE_TABLE                     constant varchar2(100) := 'cube_table';
C_CUME_DIST_AGGREGATE            constant varchar2(100) := 'cume_dist_aggregate';
C_CUME_DIST_ANALYTIC             constant varchar2(100) := 'cume_dist_analytic';
C_CURRENT_DATE                   constant varchar2(100) := 'current_date';
C_CURRENT_TIMESTAMP              constant varchar2(100) := 'current_timestamp';
C_CURSOR_EXPRESSION              constant varchar2(100) := 'cursor_expression';
C_CURSOR_SHARING_EXACT_HINT      constant varchar2(100) := 'cursor_sharing_exact_hint';
C_CV                             constant varchar2(100) := 'cv';
C_CYCLE_CLAUSE                   constant varchar2(100) := 'cycle_clause';
C_DATABASE_FILE_CLAUSES          constant varchar2(100) := 'database_file_clauses';
C_DATABASE_LOGGING_CLAUSES       constant varchar2(100) := 'database_logging_clauses';
C_DATABASE_OBJECT_OR_PART        constant varchar2(100) := 'database_object_or_part';
C_DATAFILE_TEMPFILE_CLAUSES      constant varchar2(100) := 'datafile_tempfile_clauses';
C_DATAFILE_TEMPFILE_SPEC         constant varchar2(100) := 'datafile_tempfile_spec';
C_DATAOBJ_TO_PARTITION           constant varchar2(100) := 'dataobj_to_partition';
C_DATATYPES                      constant varchar2(100) := 'datatypes';
C_DATETIME_DATATYPES             constant varchar2(100) := 'datetime_datatypes';
C_DATETIME_EXPRESSION            constant varchar2(100) := 'datetime_expression';
C_DBLINK                         constant varchar2(100) := 'dblink';
C_DBLINK_AUTHENTICATION          constant varchar2(100) := 'dblink_authentication';
C_DBTIMEZONE                     constant varchar2(100) := 'dbtimezone';
C_DB_USER_PROXY_CLAUSES          constant varchar2(100) := 'db_user_proxy_clauses';
C_DEALLOCATE_UNUSED_CLAUSE       constant varchar2(100) := 'deallocate_unused_clause';
C_DECODE                         constant varchar2(100) := 'decode';
C_DECOMPOSE                      constant varchar2(100) := 'decompose';
C_DEFAULT_COST_CLAUSE            constant varchar2(100) := 'default_cost_clause';
C_DEFAULT_SELECTIVITY_CLAUSE     constant varchar2(100) := 'default_selectivity_clause';
C_DEFAULT_SETTINGS_CLAUSES       constant varchar2(100) := 'default_settings_clauses';
C_DEFAULT_TABLESPACE             constant varchar2(100) := 'default_tablespace';
C_DEFAULT_TEMP_TABLESPACE        constant varchar2(100) := 'default_temp_tablespace';
C_DEFERRED_SEGMENT_CREATION      constant varchar2(100) := 'deferred_segment_creation';
C_DELETE                         constant varchar2(100) := 'delete';
C_DELETEXML                      constant varchar2(100) := 'deletexml';
C_DELETE_SECRET                  constant varchar2(100) := 'delete_secret';
C_DENSE_RANK_AGGREGATE           constant varchar2(100) := 'dense_rank_aggregate';
C_DENSE_RANK_ANALYTIC            constant varchar2(100) := 'dense_rank_analytic';
C_DEPENDENT_TABLES_CLAUSE        constant varchar2(100) := 'dependent_tables_clause';
C_DEPTH                          constant varchar2(100) := 'depth';
C_DEREF                          constant varchar2(100) := 'deref';
C_DIMENSION_JOIN_CLAUSE          constant varchar2(100) := 'dimension_join_clause';
C_DISASSOCIATE_STATISTICS        constant varchar2(100) := 'disassociate_statistics';
C_DISKGROUP_ALIAS_CLAUSES        constant varchar2(100) := 'diskgroup_alias_clauses';
C_DISKGROUP_ATTRIBUTES           constant varchar2(100) := 'diskgroup_attributes';
C_DISKGROUP_AVAILABILITY         constant varchar2(100) := 'diskgroup_availability';
C_DISKGROUP_DIRECTORY_CLAUSES    constant varchar2(100) := 'diskgroup_directory_clauses';
C_DISKGROUP_TEMPLATE_CLAUSES     constant varchar2(100) := 'diskgroup_template_clauses';
C_DISKGROUP_VOLUME_CLAUSES       constant varchar2(100) := 'diskgroup_volume_clauses';
C_DISK_OFFLINE_CLAUSE            constant varchar2(100) := 'disk_offline_clause';
C_DISK_ONLINE_CLAUSE             constant varchar2(100) := 'disk_online_clause';
C_DISK_REGION_CLAUSE             constant varchar2(100) := 'disk_region_clause';
C_DISTRIBUTED_RECOV_CLAUSES      constant varchar2(100) := 'distributed_recov_clauses';
C_DML_TABLE_EXPRESSION_CLAUSE    constant varchar2(100) := 'dml_table_expression_clause';
C_DOMAIN_INDEX_CLAUSE            constant varchar2(100) := 'domain_index_clause';
C_DRIVING_SITE_HINT              constant varchar2(100) := 'driving_site_hint';
C_DROP_AUDIT_POLICY              constant varchar2(100) := 'drop_audit_policy';
C_DROP_BINDING_CLAUSE            constant varchar2(100) := 'drop_binding_clause';
C_DROP_CLUSTER                   constant varchar2(100) := 'drop_cluster';
C_DROP_COLUMN_CLAUSE             constant varchar2(100) := 'drop_column_clause';
C_DROP_CONSTRAINT_CLAUSE         constant varchar2(100) := 'drop_constraint_clause';
C_DROP_CONTEXT                   constant varchar2(100) := 'drop_context';
C_DROP_DATABASE                  constant varchar2(100) := 'drop_database';
C_DROP_DATABASE_LINK             constant varchar2(100) := 'drop_database_link';
C_DROP_DIMENSION                 constant varchar2(100) := 'drop_dimension';
C_DROP_DIRECTORY                 constant varchar2(100) := 'drop_directory';
C_DROP_DISKGROUP                 constant varchar2(100) := 'drop_diskgroup';
C_DROP_DISKGROUP_FILE_CLAUSE     constant varchar2(100) := 'drop_diskgroup_file_clause';
C_DROP_DISK_CLAUSE               constant varchar2(100) := 'drop_disk_clause';
C_DROP_EDITION                   constant varchar2(100) := 'drop_edition';
C_DROP_FLASHBACK_ARCHIVE         constant varchar2(100) := 'drop_flashback_archive';
C_DROP_FUNCTION                  constant varchar2(100) := 'drop_function';
C_DROP_INDEX                     constant varchar2(100) := 'drop_index';
C_DROP_INDEXTYPE                 constant varchar2(100) := 'drop_indextype';
C_DROP_INDEX_PARTITION           constant varchar2(100) := 'drop_index_partition';
C_DROP_JAVA                      constant varchar2(100) := 'drop_java';
C_DROP_LIBRARY                   constant varchar2(100) := 'drop_library';
C_DROP_LOGFILE_CLAUSES           constant varchar2(100) := 'drop_logfile_clauses';
C_DROP_MATERIALIZED_VIEW         constant varchar2(100) := 'drop_materialized_view';
C_DROP_MATERIALIZED_VIEW_LOG     constant varchar2(100) := 'drop_materialized_view_log';
C_DROP_MATERIALIZED_ZONEMAP      constant varchar2(100) := 'drop_materialized_zonemap';
C_DROP_OPERATOR                  constant varchar2(100) := 'drop_operator';
C_DROP_OUTLINE                   constant varchar2(100) := 'drop_outline';
C_DROP_PACKAGE                   constant varchar2(100) := 'drop_package';
C_DROP_PERIOD_CLAUSE             constant varchar2(100) := 'drop_period_clause';
C_DROP_PLUGGABLE_DATABASE        constant varchar2(100) := 'drop_pluggable_database';
C_DROP_PROCEDURE                 constant varchar2(100) := 'drop_procedure';
C_DROP_PROFILE                   constant varchar2(100) := 'drop_profile';
C_DROP_RESTORE_POINT             constant varchar2(100) := 'drop_restore_point';
C_DROP_ROLE                      constant varchar2(100) := 'drop_role';
C_DROP_ROLLBACK_SEGMENT          constant varchar2(100) := 'drop_rollback_segment';
C_DROP_SEQUENCE                  constant varchar2(100) := 'drop_sequence';
C_DROP_SYNONYM                   constant varchar2(100) := 'drop_synonym';
C_DROP_TABLE                     constant varchar2(100) := 'drop_table';
C_DROP_TABLESPACE                constant varchar2(100) := 'drop_tablespace';
C_DROP_TABLE_PARTITION           constant varchar2(100) := 'drop_table_partition';
C_DROP_TABLE_SUBPARTITION        constant varchar2(100) := 'drop_table_subpartition';
C_DROP_TRIGGER                   constant varchar2(100) := 'drop_trigger';
C_DROP_TYPE                      constant varchar2(100) := 'drop_type';
C_DROP_TYPE_BODY                 constant varchar2(100) := 'drop_type_body';
C_DROP_USER                      constant varchar2(100) := 'drop_user';
C_DROP_VIEW                      constant varchar2(100) := 'drop_view';
C_DS_ISO_FORMAT                  constant varchar2(100) := 'ds_iso_format';
C_DUMP                           constant varchar2(100) := 'dump';
C_DYNAMIC_SAMPLING_HINT          constant varchar2(100) := 'dynamic_sampling_hint';
C_ELSE_CLAUSE                    constant varchar2(100) := 'else_clause';
C_EMPTY_LOB                      constant varchar2(100) := 'empty_lob';
C_ENABLE_DISABLE_CLAUSE          constant varchar2(100) := 'enable_disable_clause';
C_ENABLE_DISABLE_VOLUME          constant varchar2(100) := 'enable_disable_volume';
C_ENABLE_PLUGGABLE_DATABASE      constant varchar2(100) := 'enable_pluggable_database';
C_ENCRYPTION_SPEC                constant varchar2(100) := 'encryption_spec';
C_END_SESSION_CLAUSES            constant varchar2(100) := 'end_session_clauses';
C_EQUALS_PATH_CONDITION          constant varchar2(100) := 'equals_path_condition';
C_ERROR_LOGGING_CLAUSE           constant varchar2(100) := 'error_logging_clause';
C_EVALUATION_EDITION_CLAUSE      constant varchar2(100) := 'evaluation_edition_clause';
C_EXCEPTIONS_CLAUSE              constant varchar2(100) := 'exceptions_clause';
C_EXCHANGE_PARTITION_SUBPART     constant varchar2(100) := 'exchange_partition_subpart';
C_EXISTSNODE                     constant varchar2(100) := 'existsnode';
C_EXISTS_CONDITION               constant varchar2(100) := 'exists_condition';
C_EXP                            constant varchar2(100) := 'exp';
C_EXPLAIN_PLAN                   constant varchar2(100) := 'explain_plan';
C_EXPORT_KEYS                    constant varchar2(100) := 'export_keys';
C_EXPR                           constant varchar2(100) := 'expr';
C_EXPRESSION_LIST                constant varchar2(100) := 'expression_list';
C_EXTENDED_ATTRIBUTE_CLAUSE      constant varchar2(100) := 'extended_attribute_clause';
C_EXTENT_MANAGEMENT_CLAUSE       constant varchar2(100) := 'extent_management_clause';
C_EXTERNAL_DATA_PROPERTIES       constant varchar2(100) := 'external_data_properties';
C_EXTERNAL_TABLE_CLAUSE          constant varchar2(100) := 'external_table_clause';
C_EXTRACTVALUE                   constant varchar2(100) := 'extractvalue';
C_EXTRACT_DATETIME               constant varchar2(100) := 'extract_datetime';
C_EXTRACT_XML                    constant varchar2(100) := 'extract_xml';
C_FACT_HINT                      constant varchar2(100) := 'fact_hint';
C_FAILOVER_CLAUSE                constant varchar2(100) := 'failover_clause';
C_FEATURE_DETAILS                constant varchar2(100) := 'feature_details';
C_FEATURE_DETAILS_ANALYTIC       constant varchar2(100) := 'feature_details_analytic';
C_FEATURE_ID                     constant varchar2(100) := 'feature_id';
C_FEATURE_ID_ANALYTIC            constant varchar2(100) := 'feature_id_analytic';
C_FEATURE_SET                    constant varchar2(100) := 'feature_set';
C_FEATURE_SET_ANALYTIC           constant varchar2(100) := 'feature_set_analytic';
C_FEATURE_VALUE                  constant varchar2(100) := 'feature_value';
C_FEATURE_VALUE_ANALYTIC         constant varchar2(100) := 'feature_value_analytic';
C_FILE_NAME_CONVERT              constant varchar2(100) := 'file_name_convert';
C_FILE_OWNER_CLAUSE              constant varchar2(100) := 'file_owner_clause';
C_FILE_PERMISSIONS_CLAUSE        constant varchar2(100) := 'file_permissions_clause';
C_FILE_SPECIFICATION             constant varchar2(100) := 'file_specification';
C_FIRST                          constant varchar2(100) := 'first';
C_FIRST_ROWS_HINT                constant varchar2(100) := 'first_rows_hint';
C_FIRST_VALUE                    constant varchar2(100) := 'first_value';
C_FLASHBACK_ARCHIVE_CLAUSE       constant varchar2(100) := 'flashback_archive_clause';
C_FLASHBACK_ARCHIVE_QUOTA        constant varchar2(100) := 'flashback_archive_quota';
C_FLASHBACK_ARCHIVE_RETENTION    constant varchar2(100) := 'flashback_archive_retention';
C_FLASHBACK_DATABASE             constant varchar2(100) := 'flashback_database';
C_FLASHBACK_MODE_CLAUSE          constant varchar2(100) := 'flashback_mode_clause';
C_FLASHBACK_QUERY_CLAUSE         constant varchar2(100) := 'flashback_query_clause';
C_FLASHBACK_TABLE                constant varchar2(100) := 'flashback_table';
C_FLOATING_POINT_CONDITION       constant varchar2(100) := 'floating_point_condition';
C_FLOOR                          constant varchar2(100) := 'floor';
C_FOR_REFRESH_CLAUSE             constant varchar2(100) := 'for_refresh_clause';
C_FOR_UPDATE_CLAUSE              constant varchar2(100) := 'for_update_clause';
C_FROM_TZ                        constant varchar2(100) := 'from_tz';
C_FULLY_QUALIFIED_FILE_NAME      constant varchar2(100) := 'fully_qualified_file_name';
C_FULL_DATABASE_RECOVERY         constant varchar2(100) := 'full_database_recovery';
C_FULL_HINT                      constant varchar2(100) := 'full_hint';
C_FUNCTION                       constant varchar2(100) := 'function';
C_FUNCTION_ASSOCIATION           constant varchar2(100) := 'function_association';
C_GATHER_OPT_STATS_HINT          constant varchar2(100) := 'gather_opt_stats_hint';
C_GENERAL_RECOVERY               constant varchar2(100) := 'general_recovery';
C_GLOBAL_PARTITIONED_INDEX       constant varchar2(100) := 'global_partitioned_index';
C_GRANT                          constant varchar2(100) := 'grant';
C_GRANTEE_CLAUSE                 constant varchar2(100) := 'grantee_clause';
C_GRANTEE_IDENTIFIED_BY          constant varchar2(100) := 'grantee_identified_by';
C_GRANT_OBJECT_PRIVILEGES        constant varchar2(100) := 'grant_object_privileges';
C_GRANT_ROLES_TO_PROGRAMS        constant varchar2(100) := 'grant_roles_to_programs';
C_GRANT_SYSTEM_PRIVILEGES        constant varchar2(100) := 'grant_system_privileges';
C_GREATEST                       constant varchar2(100) := 'greatest';
C_GROUPING                       constant varchar2(100) := 'grouping';
C_GROUPING_EXPRESSION_LIST       constant varchar2(100) := 'grouping_expression_list';
C_GROUPING_ID                    constant varchar2(100) := 'grouping_id';
C_GROUPING_SETS_CLAUSE           constant varchar2(100) := 'grouping_sets_clause';
C_GROUP_BY_CLAUSE                constant varchar2(100) := 'group_by_clause';
C_GROUP_COMPARISON_CONDITION     constant varchar2(100) := 'group_comparison_condition';
C_GROUP_ID                       constant varchar2(100) := 'group_id';
C_HASH_HINT                      constant varchar2(100) := 'hash_hint';
C_HASH_PARTITIONS                constant varchar2(100) := 'hash_partitions';
C_HASH_PARTITIONS_BY_QUANTITY    constant varchar2(100) := 'hash_partitions_by_quantity';
C_HASH_SUBPARTS_BY_QUANTITY      constant varchar2(100) := 'hash_subparts_by_quantity';
C_HEAP_ORG_TABLE_CLAUSE          constant varchar2(100) := 'heap_org_table_clause';
C_HEXTORAW                       constant varchar2(100) := 'hextoraw';
C_HIERARCHICAL_QUERY_CLAUSE      constant varchar2(100) := 'hierarchical_query_clause';
C_HIERARCHY_CLAUSE               constant varchar2(100) := 'hierarchy_clause';
C_HINT                           constant varchar2(100) := 'hint';
C_IDENTITY_CLAUSE                constant varchar2(100) := 'identity_clause';
C_IDENTITY_OPTIONS               constant varchar2(100) := 'identity_options';
C_IGNORE_ROW_ON_DUPKEY_INDEX     constant varchar2(100) := 'ignore_row_on_dupkey_index';
C_ILM_CLAUSE                     constant varchar2(100) := 'ilm_clause';
C_ILM_POLICY_CLAUSE              constant varchar2(100) := 'ilm_policy_clause';
C_IMPLEMENTATION_CLAUSE          constant varchar2(100) := 'implementation_clause';
C_IMPORT_KEYS                    constant varchar2(100) := 'import_keys';
C_INCOMPLETE_FILE_NAME           constant varchar2(100) := 'incomplete_file_name';
C_INDEXING_CLAUSE                constant varchar2(100) := 'indexing_clause';
C_INDEXSPEC                      constant varchar2(100) := 'indexspec';
C_INDEX_ASC_HINT                 constant varchar2(100) := 'index_asc_hint';
C_INDEX_ATTRIBUTES               constant varchar2(100) := 'index_attributes';
C_INDEX_COMBINE_HINT             constant varchar2(100) := 'index_combine_hint';
C_INDEX_COMPRESSION              constant varchar2(100) := 'index_compression';
C_INDEX_DESC_HINT                constant varchar2(100) := 'index_desc_hint';
C_INDEX_EXPR                     constant varchar2(100) := 'index_expr';
C_INDEX_FFS_HINT                 constant varchar2(100) := 'index_ffs_hint';
C_INDEX_HINT                     constant varchar2(100) := 'index_hint';
C_INDEX_JOIN_HINT                constant varchar2(100) := 'index_join_hint';
C_INDEX_ORG_OVERFLOW_CLAUSE      constant varchar2(100) := 'index_org_overflow_clause';
C_INDEX_ORG_TABLE_CLAUSE         constant varchar2(100) := 'index_org_table_clause';
C_INDEX_PARTITIONING_CLAUSE      constant varchar2(100) := 'index_partitioning_clause';
C_INDEX_PARTITION_DESCRIPTION    constant varchar2(100) := 'index_partition_description';
C_INDEX_PROPERTIES               constant varchar2(100) := 'index_properties';
C_INDEX_SS_ASC_HINT              constant varchar2(100) := 'index_ss_asc_hint';
C_INDEX_SS_DESC_HINT             constant varchar2(100) := 'index_ss_desc_hint';
C_INDEX_SS_HINT                  constant varchar2(100) := 'index_ss_hint';
C_INDEX_SUBPARTITION_CLAUSE      constant varchar2(100) := 'index_subpartition_clause';
C_INDIVIDUAL_HASH_PARTITIONS     constant varchar2(100) := 'individual_hash_partitions';
C_INDIVIDUAL_HASH_SUBPARTS       constant varchar2(100) := 'individual_hash_subparts';
C_INITCAP                        constant varchar2(100) := 'initcap';
C_INLINE_CONSTRAINT              constant varchar2(100) := 'inline_constraint';
C_INLINE_REF_CONSTRAINT          constant varchar2(100) := 'inline_ref_constraint';
C_INMEMORY_ALTER_TABLE_CLAUSE    constant varchar2(100) := 'inmemory_alter_table_clause';
C_INMEMORY_CLAUSE                constant varchar2(100) := 'inmemory_clause';
C_INMEMORY_COLUMN_CLAUSE         constant varchar2(100) := 'inmemory_column_clause';
C_INMEMORY_DISTRIBUTE            constant varchar2(100) := 'inmemory_distribute';
C_INMEMORY_DUPLICATE             constant varchar2(100) := 'inmemory_duplicate';
C_INMEMORY_HINT                  constant varchar2(100) := 'inmemory_hint';
C_INMEMORY_MEMCOMPRESS           constant varchar2(100) := 'inmemory_memcompress';
C_INMEMORY_PARAMETERS            constant varchar2(100) := 'inmemory_parameters';
C_INMEMORY_PRIORITY              constant varchar2(100) := 'inmemory_priority';
C_INMEMORY_PRUNING_HINT          constant varchar2(100) := 'inmemory_pruning_hint';
C_INMEMORY_TABLE_CLAUSE          constant varchar2(100) := 'inmemory_table_clause';
C_INNER_CROSS_JOIN_CLAUSE        constant varchar2(100) := 'inner_cross_join_clause';
C_INSERT                         constant varchar2(100) := 'insert';
C_INSERTCHILDXML                 constant varchar2(100) := 'insertchildxml';
C_INSERTCHILDXMLAFTER            constant varchar2(100) := 'insertchildxmlafter';
C_INSERTCHILDXMLBEFORE           constant varchar2(100) := 'insertchildxmlbefore';
C_INSERTXMLAFTER                 constant varchar2(100) := 'insertxmlafter';
C_INSERTXMLBEFORE                constant varchar2(100) := 'insertxmlbefore';
C_INSERT_INTO_CLAUSE             constant varchar2(100) := 'insert_into_clause';
C_INSTANCES_CLAUSE               constant varchar2(100) := 'instances_clause';
C_INSTANCE_CLAUSES               constant varchar2(100) := 'instance_clauses';
C_INSTR                          constant varchar2(100) := 'instr';
C_INTEGER                        constant varchar2(100) := 'integer';
C_INTERVAL_DAY_TO_SECOND         constant varchar2(100) := 'interval_day_to_second';
C_INTERVAL_EXPRESSION            constant varchar2(100) := 'interval_expression';
C_INTERVAL_YEAR_TO_MONTH         constant varchar2(100) := 'interval_year_to_month';
C_INTO_CLAUSE                    constant varchar2(100) := 'into_clause';
C_INVOKER_RIGHTS_CLAUSE          constant varchar2(100) := 'invoker_rights_clause';
C_IN_CONDITION                   constant varchar2(100) := 'in_condition';
C_IS_ANY_CONDITION               constant varchar2(100) := 'is_any_condition';
C_IS_A_SET_CONDITION             constant varchar2(100) := 'is_a_set_condition';
C_IS_EMPTY_CONDITION             constant varchar2(100) := 'is_empty_condition';
C_IS_JSON_CONDITION              constant varchar2(100) := 'is_json_condition';
C_IS_OF_TYPE_CONDITION           constant varchar2(100) := 'is_of_type_condition';
C_IS_PRESENT_CONDITION           constant varchar2(100) := 'is_present_condition';
C_ITERATION_NUMBER               constant varchar2(100) := 'iteration_number';
C_JOIN_CLAUSE                    constant varchar2(100) := 'join_clause';
C_JSON_COLUMNS_CLAUSE            constant varchar2(100) := 'json_columns_clause';
C_JSON_COLUMN_DEFINITION         constant varchar2(100) := 'json_column_definition';
C_JSON_CONDITION                 constant varchar2(100) := 'json_condition';
C_JSON_EXISTS_COLUMN             constant varchar2(100) := 'json_exists_column';
C_JSON_EXISTS_CONDITION          constant varchar2(100) := 'json_exists_condition';
C_JSON_EXISTS_ON_ERROR_CLAUSE    constant varchar2(100) := 'json_exists_on_error_clause';
C_JSON_NESTED_PATH               constant varchar2(100) := 'json_nested_path';
C_JSON_OBJECT_ACCESS_EXPR        constant varchar2(100) := 'json_object_access_expr';
C_JSON_PATH_EXPRESSION           constant varchar2(100) := 'json_path_expression';
C_JSON_QUERY                     constant varchar2(100) := 'json_query';
C_JSON_QUERY_COLUMN              constant varchar2(100) := 'json_query_column';
C_JSON_QUERY_ON_ERROR_CLAUSE     constant varchar2(100) := 'json_query_on_error_clause';
C_JSON_QUERY_RETURNING_CLAUSE    constant varchar2(100) := 'json_query_returning_clause';
C_JSON_QUERY_RETURN_TYPE         constant varchar2(100) := 'json_query_return_type';
C_JSON_QUERY_WRAPPER_CLAUSE      constant varchar2(100) := 'json_query_wrapper_clause';
C_JSON_TABLE                     constant varchar2(100) := 'json_table';
C_JSON_TABLE_ON_ERROR_CLAUSE     constant varchar2(100) := 'json_table_on_error_clause';
C_JSON_TEXTCONTAINS_CONDITION    constant varchar2(100) := 'json_textcontains_condition';
C_JSON_VALUE                     constant varchar2(100) := 'json_value';
C_JSON_VALUE_COLUMN              constant varchar2(100) := 'json_value_column';
C_JSON_VALUE_ON_ERROR_CLAUSE     constant varchar2(100) := 'json_value_on_error_clause';
C_JSON_VALUE_RETURNING_CLAUSE    constant varchar2(100) := 'json_value_returning_clause';
C_JSON_VALUE_RETURN_TYPE         constant varchar2(100) := 'json_value_return_type';
C_KEYSTORE_MANAGEMENT_CLAUSES    constant varchar2(100) := 'keystore_management_clauses';
C_KEY_MANAGEMENT_CLAUSES         constant varchar2(100) := 'key_management_clauses';
C_LAG                            constant varchar2(100) := 'lag';
C_LARGE_OBJECT_DATATYPES         constant varchar2(100) := 'large_object_datatypes';
C_LAST                           constant varchar2(100) := 'last';
C_LAST_DAY                       constant varchar2(100) := 'last_day';
C_LAST_VALUE                     constant varchar2(100) := 'last_value';
C_LEAD                           constant varchar2(100) := 'lead';
C_LEADING_HINT                   constant varchar2(100) := 'leading_hint';
C_LEAST                          constant varchar2(100) := 'least';
C_LENGTH                         constant varchar2(100) := 'length';
C_LEVEL_CLAUSE                   constant varchar2(100) := 'level_clause';
C_LIKE_CONDITION                 constant varchar2(100) := 'like_condition';
C_LINEAR_REGR                    constant varchar2(100) := 'linear_regr';
C_LISTAGG                        constant varchar2(100) := 'listagg';
C_LIST_PARTITIONS                constant varchar2(100) := 'list_partitions';
C_LIST_PARTITION_DESC            constant varchar2(100) := 'list_partition_desc';
C_LIST_SUBPARTITION_DESC         constant varchar2(100) := 'list_subpartition_desc';
C_LIST_VALUES_CLAUSE             constant varchar2(100) := 'list_values_clause';
C_LN                             constant varchar2(100) := 'ln';
C_LNNVL                          constant varchar2(100) := 'lnnvl';
C_LOB_COMPRESSION_CLAUSE         constant varchar2(100) := 'lob_compression_clause';
C_LOB_DEDUPLICATE_CLAUSE         constant varchar2(100) := 'lob_deduplicate_clause';
C_LOB_PARAMETERS                 constant varchar2(100) := 'lob_parameters';
C_LOB_PARTITIONING_STORAGE       constant varchar2(100) := 'lob_partitioning_storage';
C_LOB_PARTITION_STORAGE          constant varchar2(100) := 'lob_partition_storage';
C_LOB_RETENTION_CLAUSE           constant varchar2(100) := 'lob_retention_clause';
C_LOB_STORAGE_CLAUSE             constant varchar2(100) := 'lob_storage_clause';
C_LOB_STORAGE_PARAMETERS         constant varchar2(100) := 'lob_storage_parameters';
C_LOCALTIMESTAMP                 constant varchar2(100) := 'localtimestamp';
C_LOCAL_DOMAIN_INDEX_CLAUSE      constant varchar2(100) := 'local_domain_index_clause';
C_LOCAL_PARTITIONED_INDEX        constant varchar2(100) := 'local_partitioned_index';
C_LOCAL_XMLINDEX_CLAUSE          constant varchar2(100) := 'local_xmlindex_clause';
C_LOCK_TABLE                     constant varchar2(100) := 'lock_table';
C_LOG                            constant varchar2(100) := 'log';
C_LOGFILE_CLAUSE                 constant varchar2(100) := 'logfile_clause';
C_LOGFILE_CLAUSES                constant varchar2(100) := 'logfile_clauses';
C_LOGFILE_DESCRIPTOR             constant varchar2(100) := 'logfile_descriptor';
C_LOGGING_CLAUSE                 constant varchar2(100) := 'logging_clause';
C_LONG_AND_RAW_DATATYPES         constant varchar2(100) := 'long_and_raw_datatypes';
C_LOWER                          constant varchar2(100) := 'lower';
C_LPAD                           constant varchar2(100) := 'lpad';
C_LTRIM                          constant varchar2(100) := 'ltrim';
C_MAIN_MODEL                     constant varchar2(100) := 'main_model';
C_MAKE_REF                       constant varchar2(100) := 'make_ref';
C_MANAGED_STANDBY_RECOVERY       constant varchar2(100) := 'managed_standby_recovery';
C_MAPPING_TABLE_CLAUSES          constant varchar2(100) := 'mapping_table_clauses';
C_MATERIALIZED_VIEW_PROPS        constant varchar2(100) := 'materialized_view_props';
C_MAX                            constant varchar2(100) := 'max';
C_MAXIMIZE_STANDBY_DB_CLAUSE     constant varchar2(100) := 'maximize_standby_db_clause';
C_MAXSIZE_CLAUSE                 constant varchar2(100) := 'maxsize_clause';
C_MEDIAN                         constant varchar2(100) := 'median';
C_MEDIA_TYPES                    constant varchar2(100) := 'media_types';
C_MEMBER_CONDITION               constant varchar2(100) := 'member_condition';
C_MERGE                          constant varchar2(100) := 'merge';
C_MERGE_HINT                     constant varchar2(100) := 'merge_hint';
C_MERGE_INSERT_CLAUSE            constant varchar2(100) := 'merge_insert_clause';
C_MERGE_INTO_EXIST_KEYSTORE      constant varchar2(100) := 'merge_into_exist_keystore';
C_MERGE_INTO_NEW_KEYSTORE        constant varchar2(100) := 'merge_into_new_keystore';
C_MERGE_TABLE_PARTITIONS         constant varchar2(100) := 'merge_table_partitions';
C_MERGE_TABLE_SUBPARTITIONS      constant varchar2(100) := 'merge_table_subpartitions';
C_MERGE_UPDATE_CLAUSE            constant varchar2(100) := 'merge_update_clause';
C_MIGRATE_KEY                    constant varchar2(100) := 'migrate_key';
C_MIN                            constant varchar2(100) := 'min';
C_MINING_ANALYTIC_CLAUSE         constant varchar2(100) := 'mining_analytic_clause';
C_MINING_ATTRIBUTE_CLAUSE        constant varchar2(100) := 'mining_attribute_clause';
C_MOD                            constant varchar2(100) := 'mod';
C_MODEL_CLAUSE                   constant varchar2(100) := 'model_clause';
C_MODEL_COLUMN                   constant varchar2(100) := 'model_column';
C_MODEL_COLUMN_CLAUSES           constant varchar2(100) := 'model_column_clauses';
C_MODEL_EXPRESSION               constant varchar2(100) := 'model_expression';
C_MODEL_ITERATE_CLAUSE           constant varchar2(100) := 'model_iterate_clause';
C_MODEL_MIN_ANALYSIS_HINT        constant varchar2(100) := 'model_min_analysis_hint';
C_MODEL_RULES_CLAUSE             constant varchar2(100) := 'model_rules_clause';
C_MODIFY_COLLECTION_RETRIEVAL    constant varchar2(100) := 'modify_collection_retrieval';
C_MODIFY_COLUMN_CLAUSES          constant varchar2(100) := 'modify_column_clauses';
C_MODIFY_COL_PROPERTIES          constant varchar2(100) := 'modify_col_properties';
C_MODIFY_COL_SUBSTITUTABLE       constant varchar2(100) := 'modify_col_substitutable';
C_MODIFY_COL_VISIBILITY          constant varchar2(100) := 'modify_col_visibility';
C_MODIFY_DISKGROUP_FILE          constant varchar2(100) := 'modify_diskgroup_file';
C_MODIFY_HASH_PARTITION          constant varchar2(100) := 'modify_hash_partition';
C_MODIFY_INDEX_DEFAULT_ATTRS     constant varchar2(100) := 'modify_index_default_attrs';
C_MODIFY_INDEX_PARTITION         constant varchar2(100) := 'modify_index_partition';
C_MODIFY_INDEX_SUBPARTITION      constant varchar2(100) := 'modify_index_subpartition';
C_MODIFY_LIST_PARTITION          constant varchar2(100) := 'modify_list_partition';
C_MODIFY_LOB_PARAMETERS          constant varchar2(100) := 'modify_lob_parameters';
C_MODIFY_LOB_STORAGE_CLAUSE      constant varchar2(100) := 'modify_lob_storage_clause';
C_MODIFY_MV_COLUMN_CLAUSE        constant varchar2(100) := 'modify_mv_column_clause';
C_MODIFY_OPAQUE_TYPE             constant varchar2(100) := 'modify_opaque_type';
C_MODIFY_RANGE_PARTITION         constant varchar2(100) := 'modify_range_partition';
C_MODIFY_TABLE_DEFAULT_ATTRS     constant varchar2(100) := 'modify_table_default_attrs';
C_MODIFY_TABLE_PARTITION         constant varchar2(100) := 'modify_table_partition';
C_MODIFY_TABLE_SUBPARTITION      constant varchar2(100) := 'modify_table_subpartition';
C_MODIFY_VIRTCOL_PROPERTIES      constant varchar2(100) := 'modify_virtcol_properties';
C_MODIFY_VOLUME_CLAUSE           constant varchar2(100) := 'modify_volume_clause';
C_MONITOR_HINT                   constant varchar2(100) := 'monitor_hint';
C_MONTHS_BETWEEN                 constant varchar2(100) := 'months_between';
C_MOVE_DATAFILE_CLAUSE           constant varchar2(100) := 'move_datafile_clause';
C_MOVE_MV_LOG_CLAUSE             constant varchar2(100) := 'move_mv_log_clause';
C_MOVE_TABLE_CLAUSE              constant varchar2(100) := 'move_table_clause';
C_MOVE_TABLE_PARTITION           constant varchar2(100) := 'move_table_partition';
C_MOVE_TABLE_SUBPARTITION        constant varchar2(100) := 'move_table_subpartition';
C_MULTISET_EXCEPT                constant varchar2(100) := 'multiset_except';
C_MULTISET_INTERSECT             constant varchar2(100) := 'multiset_intersect';
C_MULTISET_UNION                 constant varchar2(100) := 'multiset_union';
C_MULTI_COLUMN_FOR_LOOP          constant varchar2(100) := 'multi_column_for_loop';
C_MULTI_TABLE_INSERT             constant varchar2(100) := 'multi_table_insert';
C_MV_LOG_AUGMENTATION            constant varchar2(100) := 'mv_log_augmentation';
C_MV_LOG_PURGE_CLAUSE            constant varchar2(100) := 'mv_log_purge_clause';
C_NANVL                          constant varchar2(100) := 'nanvl';
C_NATIVE_FOJ_HINT                constant varchar2(100) := 'native_foj_hint';
C_NCHR                           constant varchar2(100) := 'nchr';
C_NESTED_TABLE_COL_PROPERTIES    constant varchar2(100) := 'nested_table_col_properties';
C_NESTED_TABLE_PARTITION_SPEC    constant varchar2(100) := 'nested_table_partition_spec';
C_NEW_TIME                       constant varchar2(100) := 'new_time';
C_NEW_VALUES_CLAUSE              constant varchar2(100) := 'new_values_clause';
C_NEXT_DAY                       constant varchar2(100) := 'next_day';
C_NLSSORT                        constant varchar2(100) := 'nlssort';
C_NLS_CHARSET_DECL_LEN           constant varchar2(100) := 'nls_charset_decl_len';
C_NLS_CHARSET_ID                 constant varchar2(100) := 'nls_charset_id';
C_NLS_CHARSET_NAME               constant varchar2(100) := 'nls_charset_name';
C_NLS_INITCAP                    constant varchar2(100) := 'nls_initcap';
C_NLS_LOWER                      constant varchar2(100) := 'nls_lower';
C_NLS_UPPER                      constant varchar2(100) := 'nls_upper';
C_NOAPPEND_HINT                  constant varchar2(100) := 'noappend_hint';
C_NOAUDIT                        constant varchar2(100) := 'noaudit';
C_NOCACHE_HINT                   constant varchar2(100) := 'nocache_hint';
C_NO_CLUSTERING_HINT             constant varchar2(100) := 'no_clustering_hint';
C_NO_EXPAND_HINT                 constant varchar2(100) := 'no_expand_hint';
C_NO_FACT_HINT                   constant varchar2(100) := 'no_fact_hint';
C_NO_GATHER_OPT_STATS_HINT       constant varchar2(100) := 'no_gather_opt_stats_hint';
C_NO_INDEX_FFS_HINT              constant varchar2(100) := 'no_index_ffs_hint';
C_NO_INDEX_HINT                  constant varchar2(100) := 'no_index_hint';
C_NO_INDEX_SS_HINT               constant varchar2(100) := 'no_index_ss_hint';
C_NO_INMEMORY_HINT               constant varchar2(100) := 'no_inmemory_hint';
C_NO_INMEMORY_PRUNING_HINT       constant varchar2(100) := 'no_inmemory_pruning_hint';
C_NO_MERGE_HINT                  constant varchar2(100) := 'no_merge_hint';
C_NO_MONITOR_HINT                constant varchar2(100) := 'no_monitor_hint';
C_NO_NATIVE_FOJ_HINT             constant varchar2(100) := 'no_native_foj_hint';
C_NO_PARALLEL_HINT               constant varchar2(100) := 'no_parallel_hint';
C_NO_PARALLEL_INDEX_HINT         constant varchar2(100) := 'no_parallel_index_hint';
C_NO_PQ_CONCURRENT_UNION_HINT    constant varchar2(100) := 'no_pq_concurrent_union_hint';
C_NO_PQ_SKEW_HINT                constant varchar2(100) := 'no_pq_skew_hint';
C_NO_PUSH_PRED_HINT              constant varchar2(100) := 'no_push_pred_hint';
C_NO_PUSH_SUBQ_HINT              constant varchar2(100) := 'no_push_subq_hint';
C_NO_PX_JOIN_FILTER_HINT         constant varchar2(100) := 'no_px_join_filter_hint';
C_NO_QUERY_TRANSFORMATN_HINT     constant varchar2(100) := 'no_query_transformatn_hint';
C_NO_RESULT_CACHE_HINT           constant varchar2(100) := 'no_result_cache_hint';
C_NO_REWRITE_HINT                constant varchar2(100) := 'no_rewrite_hint';
C_NO_STAR_TRANSFORMATION_HINT    constant varchar2(100) := 'no_star_transformation_hint';
C_NO_STATEMENT_QUEUING_HINT      constant varchar2(100) := 'no_statement_queuing_hint';
C_NO_UNNEST_HINT                 constant varchar2(100) := 'no_unnest_hint';
C_NO_USE_CUBE_HINT               constant varchar2(100) := 'no_use_cube_hint';
C_NO_USE_HASH_HINT               constant varchar2(100) := 'no_use_hash_hint';
C_NO_USE_MERGE_HINT              constant varchar2(100) := 'no_use_merge_hint';
C_NO_USE_NL_HINT                 constant varchar2(100) := 'no_use_nl_hint';
C_NO_XMLINDEX_REWRITE_HINT       constant varchar2(100) := 'no_xmlindex_rewrite_hint';
C_NO_XML_QUERY_REWRITE_HINT      constant varchar2(100) := 'no_xml_query_rewrite_hint';
C_NO_ZONEMAP_HINT                constant varchar2(100) := 'no_zonemap_hint';
C_NTH_VALUE                      constant varchar2(100) := 'nth_value';
C_NTILE                          constant varchar2(100) := 'ntile';
C_NULLIF                         constant varchar2(100) := 'nullif';
C_NULL_CONDITION                 constant varchar2(100) := 'null_condition';
C_NUMBER                         constant varchar2(100) := 'number';
C_NUMBER_DATATYPES               constant varchar2(100) := 'number_datatypes';
C_NUMERIC_FILE_NAME              constant varchar2(100) := 'numeric_file_name';
C_NUMTODSINTERVAL                constant varchar2(100) := 'numtodsinterval';
C_NUMTOYMINTERVAL                constant varchar2(100) := 'numtoyminterval';
C_NVL                            constant varchar2(100) := 'nvl';
C_NVL2                           constant varchar2(100) := 'nvl2';
C_OBJECT_ACCESS_EXPRESSION       constant varchar2(100) := 'object_access_expression';
C_OBJECT_PROPERTIES              constant varchar2(100) := 'object_properties';
C_OBJECT_STEP                    constant varchar2(100) := 'object_step';
C_OBJECT_TABLE                   constant varchar2(100) := 'object_table';
C_OBJECT_TABLE_SUBSTITUTION      constant varchar2(100) := 'object_table_substitution';
C_OBJECT_TYPE_COL_PROPERTIES     constant varchar2(100) := 'object_type_col_properties';
C_OBJECT_VIEW_CLAUSE             constant varchar2(100) := 'object_view_clause';
C_OID_CLAUSE                     constant varchar2(100) := 'oid_clause';
C_OID_INDEX_CLAUSE               constant varchar2(100) := 'oid_index_clause';
C_ON_COMP_PARTITIONED_TABLE      constant varchar2(100) := 'on_comp_partitioned_table';
C_ON_HASH_PARTITIONED_TABLE      constant varchar2(100) := 'on_hash_partitioned_table';
C_ON_LIST_PARTITIONED_TABLE      constant varchar2(100) := 'on_list_partitioned_table';
C_ON_OBJECT_CLAUSE               constant varchar2(100) := 'on_object_clause';
C_ON_RANGE_PARTITIONED_TABLE     constant varchar2(100) := 'on_range_partitioned_table';
C_OPEN_KEYSTORE                  constant varchar2(100) := 'open_keystore';
C_OPT_PARAM_HINT                 constant varchar2(100) := 'opt_param_hint';
C_ORACLE_BUILT_IN_DATATYPES      constant varchar2(100) := 'oracle_built_in_datatypes';
C_ORACLE_SUPPLIED_TYPES          constant varchar2(100) := 'oracle_supplied_types';
C_ORA_DST_AFFECTED               constant varchar2(100) := 'ora_dst_affected';
C_ORA_DST_CONVERT                constant varchar2(100) := 'ora_dst_convert';
C_ORA_DST_ERROR                  constant varchar2(100) := 'ora_dst_error';
C_ORA_HASH                       constant varchar2(100) := 'ora_hash';
C_ORA_INVOKING_USER              constant varchar2(100) := 'ora_invoking_user';
C_ORA_INVOKING_USERID            constant varchar2(100) := 'ora_invoking_userid';
C_ORDERED_HINT                   constant varchar2(100) := 'ordered_hint';
C_ORDER_BY_CLAUSE                constant varchar2(100) := 'order_by_clause';
C_ORDINALITY_COLUMN              constant varchar2(100) := 'ordinality_column';
C_OUTER_JOIN_CLAUSE              constant varchar2(100) := 'outer_join_clause';
C_OUTER_JOIN_TYPE                constant varchar2(100) := 'outer_join_type';
C_OUT_OF_LINE_CONSTRAINT         constant varchar2(100) := 'out_of_line_constraint';
C_OUT_OF_LINE_PART_STORAGE       constant varchar2(100) := 'out_of_line_part_storage';
C_OUT_OF_LINE_REF_CONSTRAINT     constant varchar2(100) := 'out_of_line_ref_constraint';
C_PARALLEL_CLAUSE                constant varchar2(100) := 'parallel_clause';
C_PARALLEL_HINT_OBJECT           constant varchar2(100) := 'parallel_hint_object';
C_PARALLEL_HINT_STATEMENT        constant varchar2(100) := 'parallel_hint_statement';
C_PARALLEL_INDEX_HINT            constant varchar2(100) := 'parallel_index_hint';
C_PARTIAL_DATABASE_RECOVERY      constant varchar2(100) := 'partial_database_recovery';
C_PARTIAL_INDEX_CLAUSE           constant varchar2(100) := 'partial_index_clause';
C_PARTITIONING_STORAGE_CLAUSE    constant varchar2(100) := 'partitioning_storage_clause';
C_PARTITION_ATTRIBUTES           constant varchar2(100) := 'partition_attributes';
C_PARTITION_EXTENDED_NAME        constant varchar2(100) := 'partition_extended_name';
C_PARTITION_EXTENDED_NAMES       constant varchar2(100) := 'partition_extended_names';
C_PARTITION_EXTENSION_CLAUSE     constant varchar2(100) := 'partition_extension_clause';
C_PARTITION_OR_KEY_VALUE         constant varchar2(100) := 'partition_or_key_value';
C_PARTITION_SPEC                 constant varchar2(100) := 'partition_spec';
C_PASSWORD_PARAMETERS            constant varchar2(100) := 'password_parameters';
C_PATH                           constant varchar2(100) := 'path';
C_PATH_PREFIX_CLAUSE             constant varchar2(100) := 'path_prefix_clause';
C_PDB_CHANGE_STATE               constant varchar2(100) := 'pdb_change_state';
C_PDB_CHANGE_STATE_FROM_ROOT     constant varchar2(100) := 'pdb_change_state_from_root';
C_PDB_CLOSE                      constant varchar2(100) := 'pdb_close';
C_PDB_DATAFILE_CLAUSE            constant varchar2(100) := 'pdb_datafile_clause';
C_PDB_DBA_ROLES                  constant varchar2(100) := 'pdb_dba_roles';
C_PDB_FORCE_LOGGING_CLAUSE       constant varchar2(100) := 'pdb_force_logging_clause';
C_PDB_GENERAL_RECOVERY           constant varchar2(100) := 'pdb_general_recovery';
C_PDB_LOGGING_CLAUSES            constant varchar2(100) := 'pdb_logging_clauses';
C_PDB_OPEN                       constant varchar2(100) := 'pdb_open';
C_PDB_RECOVERY_CLAUSES           constant varchar2(100) := 'pdb_recovery_clauses';
C_PDB_SAVE_OR_DISCARD_STATE      constant varchar2(100) := 'pdb_save_or_discard_state';
C_PDB_SETTINGS_CLAUSES           constant varchar2(100) := 'pdb_settings_clauses';
C_PDB_STORAGE_CLAUSE             constant varchar2(100) := 'pdb_storage_clause';
C_PDB_UNPLUG_CLAUSE              constant varchar2(100) := 'pdb_unplug_clause';
C_PERCENTILE_CONT                constant varchar2(100) := 'percentile_cont';
C_PERCENTILE_DISC                constant varchar2(100) := 'percentile_disc';
C_PERCENT_RANK_AGGREGATE         constant varchar2(100) := 'percent_rank_aggregate';
C_PERCENT_RANK_ANALYTIC          constant varchar2(100) := 'percent_rank_analytic';
C_PERIOD_DEFINITION              constant varchar2(100) := 'period_definition';
C_PERMANENT_TABLESPACE_CLAUSE    constant varchar2(100) := 'permanent_tablespace_clause';
C_PHYSICAL_ATTRIBUTES_CLAUSE     constant varchar2(100) := 'physical_attributes_clause';
C_PHYSICAL_PROPERTIES            constant varchar2(100) := 'physical_properties';
C_PIVOT_CLAUSE                   constant varchar2(100) := 'pivot_clause';
C_PIVOT_FOR_CLAUSE               constant varchar2(100) := 'pivot_for_clause';
C_PIVOT_IN_CLAUSE                constant varchar2(100) := 'pivot_in_clause';
C_PLACEHOLDER_EXPRESSION         constant varchar2(100) := 'placeholder_expression';
C_PLSQL_DECLARATIONS             constant varchar2(100) := 'plsql_declarations';
C_POWER                          constant varchar2(100) := 'power';
C_POWERMULTISET                  constant varchar2(100) := 'powermultiset';
C_POWERMULTISET_BY_CARDNLTY      constant varchar2(100) := 'powermultiset_by_cardnlty';
C_PQ_CONCURRENT_UNION_HINT       constant varchar2(100) := 'pq_concurrent_union_hint';
C_PQ_DISTRIBUTE_HINT             constant varchar2(100) := 'pq_distribute_hint';
C_PQ_FILTER_HINT                 constant varchar2(100) := 'pq_filter_hint';
C_PQ_SKEW_HINT                   constant varchar2(100) := 'pq_skew_hint';
C_PREDICTION                     constant varchar2(100) := 'prediction';
C_PREDICTION_ANALYTIC            constant varchar2(100) := 'prediction_analytic';
C_PREDICTION_BOUNDS              constant varchar2(100) := 'prediction_bounds';
C_PREDICTION_COST                constant varchar2(100) := 'prediction_cost';
C_PREDICTION_COST_ANALYTIC       constant varchar2(100) := 'prediction_cost_analytic';
C_PREDICTION_DETAILS             constant varchar2(100) := 'prediction_details';
C_PREDICTION_DETAILS_ANALYTIC    constant varchar2(100) := 'prediction_details_analytic';
C_PREDICTION_PROBABILITY         constant varchar2(100) := 'prediction_probability';
C_PREDICTION_PROB_ANALYTIC       constant varchar2(100) := 'prediction_prob_analytic';
C_PREDICTION_SET                 constant varchar2(100) := 'prediction_set';
C_PREDICTION_SET_ANALYTIC        constant varchar2(100) := 'prediction_set_analytic';
C_PREFIX_COMPRESSION             constant varchar2(100) := 'prefix_compression';
C_PRESENTNNV                     constant varchar2(100) := 'presentnnv';
C_PRESENTV                       constant varchar2(100) := 'presentv';
C_PREVIOUS                       constant varchar2(100) := 'previous';
C_PRIVILEGE_AUDIT_CLAUSE         constant varchar2(100) := 'privilege_audit_clause';
C_PROGRAM_UNIT                   constant varchar2(100) := 'program_unit';
C_PROXY_CLAUSE                   constant varchar2(100) := 'proxy_clause';
C_PURGE                          constant varchar2(100) := 'purge';
C_PUSH_PRED_HINT                 constant varchar2(100) := 'push_pred_hint';
C_PUSH_SUBQ_HINT                 constant varchar2(100) := 'push_subq_hint';
C_PX_JOIN_FILTER_HINT            constant varchar2(100) := 'px_join_filter_hint';
C_QB_NAME_HINT                   constant varchar2(100) := 'qb_name_hint';
C_QUALIFIED_DISK_CLAUSE          constant varchar2(100) := 'qualified_disk_clause';
C_QUALIFIED_TEMPLATE_CLAUSE      constant varchar2(100) := 'qualified_template_clause';
C_QUERY_BLOCK                    constant varchar2(100) := 'query_block';
C_QUERY_PARTITION_CLAUSE         constant varchar2(100) := 'query_partition_clause';
C_QUERY_REWRITE_CLAUSE           constant varchar2(100) := 'query_rewrite_clause';
C_QUERY_TABLE_EXPRESSION         constant varchar2(100) := 'query_table_expression';
C_QUIESCE_CLAUSES                constant varchar2(100) := 'quiesce_clauses';
C_RANGE_PARTITIONS               constant varchar2(100) := 'range_partitions';
C_RANGE_PARTITION_DESC           constant varchar2(100) := 'range_partition_desc';
C_RANGE_SUBPARTITION_DESC        constant varchar2(100) := 'range_subpartition_desc';
C_RANGE_VALUES_CLAUSE            constant varchar2(100) := 'range_values_clause';
C_RANK_AGGREGATE                 constant varchar2(100) := 'rank_aggregate';
C_RANK_ANALYTIC                  constant varchar2(100) := 'rank_analytic';
C_RATIO_TO_REPORT                constant varchar2(100) := 'ratio_to_report';
C_RAWTOHEX                       constant varchar2(100) := 'rawtohex';
C_RAWTONHEX                      constant varchar2(100) := 'rawtonhex';
C_REBALANCE_DISKGROUP_CLAUSE     constant varchar2(100) := 'rebalance_diskgroup_clause';
C_REBUILD_CLAUSE                 constant varchar2(100) := 'rebuild_clause';
C_RECORDS_PER_BLOCK_CLAUSE       constant varchar2(100) := 'records_per_block_clause';
C_RECOVERY_CLAUSES               constant varchar2(100) := 'recovery_clauses';
C_REDO_LOG_FILE_SPEC             constant varchar2(100) := 'redo_log_file_spec';
C_REDUNDANCY_CLAUSE              constant varchar2(100) := 'redundancy_clause';
C_REF                            constant varchar2(100) := 'ref';
C_REFERENCES_CLAUSE              constant varchar2(100) := 'references_clause';
C_REFERENCE_MODEL                constant varchar2(100) := 'reference_model';
C_REFERENCE_PARTITIONING         constant varchar2(100) := 'reference_partitioning';
C_REFERENCE_PARTITION_DESC       constant varchar2(100) := 'reference_partition_desc';
C_REFTOHEX                       constant varchar2(100) := 'reftohex';
C_REGEXP_COUNT                   constant varchar2(100) := 'regexp_count';
C_REGEXP_INSTR                   constant varchar2(100) := 'regexp_instr';
C_REGEXP_LIKE_CONDITION          constant varchar2(100) := 'regexp_like_condition';
C_REGEXP_REPLACE                 constant varchar2(100) := 'regexp_replace';
C_REGEXP_SUBSTR                  constant varchar2(100) := 'regexp_substr';
C_REGISTER_LOGFILE_CLAUSE        constant varchar2(100) := 'register_logfile_clause';
C_RELATIONAL_PROPERTIES          constant varchar2(100) := 'relational_properties';
C_RELATIONAL_TABLE               constant varchar2(100) := 'relational_table';
C_RELOCATE_CLAUSE                constant varchar2(100) := 'relocate_clause';
C_REMAINDER                      constant varchar2(100) := 'remainder';
C_RENAME                         constant varchar2(100) := 'rename';
C_RENAME_COLUMN_CLAUSE           constant varchar2(100) := 'rename_column_clause';
C_RENAME_DISK_CLAUSE             constant varchar2(100) := 'rename_disk_clause';
C_RENAME_INDEX_PARTITION         constant varchar2(100) := 'rename_index_partition';
C_RENAME_PARTITION_SUBPART       constant varchar2(100) := 'rename_partition_subpart';
C_REPLACE                        constant varchar2(100) := 'replace';
C_REPLACE_DISK_CLAUSE            constant varchar2(100) := 'replace_disk_clause';
C_RESIZE_DISK_CLAUSE             constant varchar2(100) := 'resize_disk_clause';
C_RESOURCE_PARAMETERS            constant varchar2(100) := 'resource_parameters';
C_RESULT_CACHE_HINT              constant varchar2(100) := 'result_cache_hint';
C_RETRY_ON_ROW_CHANGE            constant varchar2(100) := 'retry_on_row_change';
C_RETURNING_CLAUSE               constant varchar2(100) := 'returning_clause';
C_RETURN_ROWS_CLAUSE             constant varchar2(100) := 'return_rows_clause';
C_REVERSE_MIGRATE_KEY            constant varchar2(100) := 'reverse_migrate_key';
C_REVOKE                         constant varchar2(100) := 'revoke';
C_REVOKEE_CLAUSE                 constant varchar2(100) := 'revokee_clause';
C_REVOKE_OBJECT_PRIVILEGES       constant varchar2(100) := 'revoke_object_privileges';
C_REVOKE_ROLES_FROM_PROGRAMS     constant varchar2(100) := 'revoke_roles_from_programs';
C_REVOKE_SYSTEM_PRIVILEGES       constant varchar2(100) := 'revoke_system_privileges';
C_REWRITE_HINT                   constant varchar2(100) := 'rewrite_hint';
C_ROLE_AUDIT_CLAUSE              constant varchar2(100) := 'role_audit_clause';
C_ROLLBACK                       constant varchar2(100) := 'rollback';
C_ROLLING_MIGRATION_CLAUSES      constant varchar2(100) := 'rolling_migration_clauses';
C_ROLLING_PATCH_CLAUSES          constant varchar2(100) := 'rolling_patch_clauses';
C_ROLLUP_CUBE_CLAUSE             constant varchar2(100) := 'rollup_cube_clause';
C_ROUND_DATE                     constant varchar2(100) := 'round_date';
C_ROUND_NUMBER                   constant varchar2(100) := 'round_number';
C_ROUTINE_CLAUSE                 constant varchar2(100) := 'routine_clause';
C_ROWIDTOCHAR                    constant varchar2(100) := 'rowidtochar';
C_ROWIDTONCHAR                   constant varchar2(100) := 'rowidtonchar';
C_ROWID_DATATYPES                constant varchar2(100) := 'rowid_datatypes';
C_ROW_LIMITING_CLAUSE            constant varchar2(100) := 'row_limiting_clause';
C_ROW_MOVEMENT_CLAUSE            constant varchar2(100) := 'row_movement_clause';
C_ROW_NUMBER                     constant varchar2(100) := 'row_number';
C_ROW_PATTERN                    constant varchar2(100) := 'row_pattern';
C_ROW_PATTERN_AGGREGATE_FUNC     constant varchar2(100) := 'row_pattern_aggregate_func';
C_ROW_PATTERN_CLASSIFIER_FUNC    constant varchar2(100) := 'row_pattern_classifier_func';
C_ROW_PATTERN_CLAUSE             constant varchar2(100) := 'row_pattern_clause';
C_ROW_PATTERN_DEFINITION         constant varchar2(100) := 'row_pattern_definition';
C_ROW_PATTERN_DEFINITION_LIST    constant varchar2(100) := 'row_pattern_definition_list';
C_ROW_PATTERN_FACTOR             constant varchar2(100) := 'row_pattern_factor';
C_ROW_PATTERN_MATCH_NUM_FUNC     constant varchar2(100) := 'row_pattern_match_num_func';
C_ROW_PATTERN_MEASURES           constant varchar2(100) := 'row_pattern_measures';
C_ROW_PATTERN_MEASURE_COLUMN     constant varchar2(100) := 'row_pattern_measure_column';
C_ROW_PATTERN_NAVIGATION_FUNC    constant varchar2(100) := 'row_pattern_navigation_func';
C_ROW_PATTERN_NAV_COMPOUND       constant varchar2(100) := 'row_pattern_nav_compound';
C_ROW_PATTERN_NAV_LOGICAL        constant varchar2(100) := 'row_pattern_nav_logical';
C_ROW_PATTERN_NAV_PHYSICAL       constant varchar2(100) := 'row_pattern_nav_physical';
C_ROW_PATTERN_ORDER_BY           constant varchar2(100) := 'row_pattern_order_by';
C_ROW_PATTERN_PARTITION_BY       constant varchar2(100) := 'row_pattern_partition_by';
C_ROW_PATTERN_PERMUTE            constant varchar2(100) := 'row_pattern_permute';
C_ROW_PATTERN_PRIMARY            constant varchar2(100) := 'row_pattern_primary';
C_ROW_PATTERN_QUANTIFIER         constant varchar2(100) := 'row_pattern_quantifier';
C_ROW_PATTERN_REC_FUNC           constant varchar2(100) := 'row_pattern_rec_func';
C_ROW_PATTERN_ROWS_PER_MATCH     constant varchar2(100) := 'row_pattern_rows_per_match';
C_ROW_PATTERN_SKIP_TO            constant varchar2(100) := 'row_pattern_skip_to';
C_ROW_PATTERN_SUBSET_CLAUSE      constant varchar2(100) := 'row_pattern_subset_clause';
C_ROW_PATTERN_SUBSET_ITEM        constant varchar2(100) := 'row_pattern_subset_item';
C_ROW_PATTERN_TERM               constant varchar2(100) := 'row_pattern_term';
C_RPAD                           constant varchar2(100) := 'rpad';
C_RTRIM                          constant varchar2(100) := 'rtrim';
C_SAMPLE_CLAUSE                  constant varchar2(100) := 'sample_clause';
C_SAVEPOINT                      constant varchar2(100) := 'savepoint';
C_SCN_TO_TIMESTAMP               constant varchar2(100) := 'scn_to_timestamp';
C_SCOPED_TABLE_REF_CONSTRAINT    constant varchar2(100) := 'scoped_table_ref_constraint';
C_SCRUB_CLAUSE                   constant varchar2(100) := 'scrub_clause';
C_SEARCHED_CASE_EXPRESSION       constant varchar2(100) := 'searched_case_expression';
C_SEARCH_CLAUSE                  constant varchar2(100) := 'search_clause';
C_SECRET_MANAGEMENT_CLAUSES      constant varchar2(100) := 'secret_management_clauses';
C_SECURITY_CLAUSE                constant varchar2(100) := 'security_clause';
C_SECURITY_CLAUSES               constant varchar2(100) := 'security_clauses';
C_SEGMENT_ATTRIBUTES_CLAUSE      constant varchar2(100) := 'segment_attributes_clause';
C_SEGMENT_MANAGEMENT_CLAUSE      constant varchar2(100) := 'segment_management_clause';
--C_SELECT                         constant varchar2(100) := 'select';
C_SELECT_LIST                    constant varchar2(100) := 'select_list';
C_SESSIONTIMEZONE                constant varchar2(100) := 'sessiontimezone';
C_SET                            constant varchar2(100) := 'set';
C_SET_CONSTRAINTS                constant varchar2(100) := 'set_constraints';
C_SET_ENCRYPTION_KEY             constant varchar2(100) := 'set_encryption_key';
C_SET_KEY                        constant varchar2(100) := 'set_key';
C_SET_KEY_TAG                    constant varchar2(100) := 'set_key_tag';
C_SET_PARAMETER_CLAUSE           constant varchar2(100) := 'set_parameter_clause';
C_SET_ROLE                       constant varchar2(100) := 'set_role';
C_SET_SUBPARTITION_TEMPLATE      constant varchar2(100) := 'set_subpartition_template';
C_SET_TIME_ZONE_CLAUSE           constant varchar2(100) := 'set_time_zone_clause';
C_SET_TRANSACTION                constant varchar2(100) := 'set_transaction';
C_SHRINK_CLAUSE                  constant varchar2(100) := 'shrink_clause';
C_SHUTDOWN_DISPATCHER_CLAUSE     constant varchar2(100) := 'shutdown_dispatcher_clause';
C_SIGN                           constant varchar2(100) := 'sign';
C_SIMPLE_CASE_EXPRESSION         constant varchar2(100) := 'simple_case_expression';
C_SIMPLE_COMPARISON_CONDITION    constant varchar2(100) := 'simple_comparison_condition';
C_SIMPLE_EXPRESSION              constant varchar2(100) := 'simple_expression';
C_SIN                            constant varchar2(100) := 'sin';
C_SINGLE_COLUMN_FOR_LOOP         constant varchar2(100) := 'single_column_for_loop';
C_SINGLE_ROW_FUNCTION            constant varchar2(100) := 'single_row_function';
C_SINGLE_TABLE_INSERT            constant varchar2(100) := 'single_table_insert';
C_SINH                           constant varchar2(100) := 'sinh';
C_SIZE_CLAUSE                    constant varchar2(100) := 'size_clause';
C_SOUNDEX                        constant varchar2(100) := 'soundex';
C_SOURCE_FILE_DIRECTORY          constant varchar2(100) := 'source_file_directory';
C_SOURCE_FILE_NAME_CONVERT       constant varchar2(100) := 'source_file_name_convert';
C_SPATIAL_TYPES                  constant varchar2(100) := 'spatial_types';
C_SPLIT_INDEX_PARTITION          constant varchar2(100) := 'split_index_partition';
C_SPLIT_NESTED_TABLE_PART        constant varchar2(100) := 'split_nested_table_part';
C_SPLIT_TABLE_PARTITION          constant varchar2(100) := 'split_table_partition';
C_SPLIT_TABLE_SUBPARTITION       constant varchar2(100) := 'split_table_subpartition';
C_SQLRF001                       constant varchar2(100) := 'sqlrf001';
C_SQLRF002                       constant varchar2(100) := 'sqlrf002';
C_SQL_FORMAT                     constant varchar2(100) := 'sql_format';
C_SQRT                           constant varchar2(100) := 'sqrt';
C_STANDARD_ACTIONS               constant varchar2(100) := 'standard_actions';
C_STANDARD_HASH                  constant varchar2(100) := 'standard_hash';
C_STANDBYS_CLAUSE                constant varchar2(100) := 'standbys_clause';
C_STANDBY_DATABASE_CLAUSES       constant varchar2(100) := 'standby_database_clauses';
C_STARTUP_CLAUSES                constant varchar2(100) := 'startup_clauses';
C_START_STANDBY_CLAUSE           constant varchar2(100) := 'start_standby_clause';
C_STAR_TRANSFORMATION_HINT       constant varchar2(100) := 'star_transformation_hint';
C_STATEMENT_QUEUING_HINT         constant varchar2(100) := 'statement_queuing_hint';
C_STATS_BINOMIAL_TEST            constant varchar2(100) := 'stats_binomial_test';
C_STATS_CROSSTAB                 constant varchar2(100) := 'stats_crosstab';
C_STATS_F_TEST                   constant varchar2(100) := 'stats_f_test';
C_STATS_KS_TEST                  constant varchar2(100) := 'stats_ks_test';
C_STATS_MODE                     constant varchar2(100) := 'stats_mode';
C_STATS_MW_TEST                  constant varchar2(100) := 'stats_mw_test';
C_STATS_ONE_WAY_ANOVA            constant varchar2(100) := 'stats_one_way_anova';
C_STATS_T_TEST                   constant varchar2(100) := 'stats_t_test';
C_STATS_WSR_TEST                 constant varchar2(100) := 'stats_wsr_test';
C_STDDEV                         constant varchar2(100) := 'stddev';
C_STDDEV_POP                     constant varchar2(100) := 'stddev_pop';
C_STDDEV_SAMP                    constant varchar2(100) := 'stddev_samp';
C_STILL_IMAGE_OBJECT_TYPES       constant varchar2(100) := 'still_image_object_types';
C_STOP_STANDBY_CLAUSE            constant varchar2(100) := 'stop_standby_clause';
C_STORAGE_CLAUSE                 constant varchar2(100) := 'storage_clause';
C_STORAGE_TABLE_CLAUSE           constant varchar2(100) := 'storage_table_clause';
C_STRING                         constant varchar2(100) := 'string';
C_STRIPING_CLAUSE                constant varchar2(100) := 'striping_clause';
C_SUBMULTISET_CONDITION          constant varchar2(100) := 'submultiset_condition';
C_SUBPARTITION_BY_HASH           constant varchar2(100) := 'subpartition_by_hash';
C_SUBPARTITION_BY_LIST           constant varchar2(100) := 'subpartition_by_list';
C_SUBPARTITION_BY_RANGE          constant varchar2(100) := 'subpartition_by_range';
C_SUBPARTITION_EXTENDED_NAME     constant varchar2(100) := 'subpartition_extended_name';
C_SUBPARTITION_EXTENDED_NAMES    constant varchar2(100) := 'subpartition_extended_names';
C_SUBPARTITION_OR_KEY_VALUE      constant varchar2(100) := 'subpartition_or_key_value';
C_SUBPARTITION_SPEC              constant varchar2(100) := 'subpartition_spec';
C_SUBPARTITION_TEMPLATE          constant varchar2(100) := 'subpartition_template';
C_SUBQUERY                       constant varchar2(100) := 'subquery';
C_SUBQUERY_FACTORING_CLAUSE      constant varchar2(100) := 'subquery_factoring_clause';
C_SUBQUERY_RESTRICTION_CLAUSE    constant varchar2(100) := 'subquery_restriction_clause';
C_SUBSTITUTABLE_COLUMN_CLAUSE    constant varchar2(100) := 'substitutable_column_clause';
C_SUBSTR                         constant varchar2(100) := 'substr';
C_SUM                            constant varchar2(100) := 'sum';
C_SUPPLEMENTAL_DB_LOGGING        constant varchar2(100) := 'supplemental_db_logging';
C_SUPPLEMENTAL_ID_KEY_CLAUSE     constant varchar2(100) := 'supplemental_id_key_clause';
C_SUPPLEMENTAL_LOGGING_PROPS     constant varchar2(100) := 'supplemental_logging_props';
C_SUPPLEMENTAL_LOG_GRP_CLAUSE    constant varchar2(100) := 'supplemental_log_grp_clause';
C_SUPPLEMENTAL_PLSQL_CLAUSE      constant varchar2(100) := 'supplemental_plsql_clause';
C_SUPPLEMENTAL_TABLE_LOGGING     constant varchar2(100) := 'supplemental_table_logging';
C_SWITCHOVER_CLAUSE              constant varchar2(100) := 'switchover_clause';
C_SWITCH_LOGFILE_CLAUSE          constant varchar2(100) := 'switch_logfile_clause';
C_SYSDATE                        constant varchar2(100) := 'sysdate';
C_SYSTEM_PARTITIONING            constant varchar2(100) := 'system_partitioning';
C_SYSTIMESTAMP                   constant varchar2(100) := 'systimestamp';
C_SYS_CONNECT_BY_PATH            constant varchar2(100) := 'sys_connect_by_path';
C_SYS_CONTEXT                    constant varchar2(100) := 'sys_context';
C_SYS_DBURIGEN                   constant varchar2(100) := 'sys_dburigen';
C_SYS_EXTRACT_UTC                constant varchar2(100) := 'sys_extract_utc';
C_SYS_GUID                       constant varchar2(100) := 'sys_guid';
C_SYS_OP_ZONE_ID                 constant varchar2(100) := 'sys_op_zone_id';
C_SYS_TYPEID                     constant varchar2(100) := 'sys_typeid';
C_SYS_XMLAGG                     constant varchar2(100) := 'sys_xmlagg';
C_SYS_XMLGEN                     constant varchar2(100) := 'sys_xmlgen';
C_TABLESPACE_CLAUSES             constant varchar2(100) := 'tablespace_clauses';
C_TABLESPACE_DATAFILE_CLAUSES    constant varchar2(100) := 'tablespace_datafile_clauses';
C_TABLESPACE_ENCRYPTION_SPEC     constant varchar2(100) := 'tablespace_encryption_spec';
C_TABLESPACE_GROUP_CLAUSE        constant varchar2(100) := 'tablespace_group_clause';
C_TABLESPACE_LOGGING_CLAUSES     constant varchar2(100) := 'tablespace_logging_clauses';
C_TABLESPACE_RETENTION_CLAUSE    constant varchar2(100) := 'tablespace_retention_clause';
C_TABLESPACE_STATE_CLAUSES       constant varchar2(100) := 'tablespace_state_clauses';
C_TABLESPEC                      constant varchar2(100) := 'tablespec';
C_TABLE_COLLECTION_EXPRESSION    constant varchar2(100) := 'table_collection_expression';
C_TABLE_COMPRESSION              constant varchar2(100) := 'table_compression';
C_TABLE_INDEX_CLAUSE             constant varchar2(100) := 'table_index_clause';
C_TABLE_PARTITIONING_CLAUSES     constant varchar2(100) := 'table_partitioning_clauses';
C_TABLE_PARTITION_DESCRIPTION    constant varchar2(100) := 'table_partition_description';
C_TABLE_PROPERTIES               constant varchar2(100) := 'table_properties';
C_TABLE_REFERENCE                constant varchar2(100) := 'table_reference';
C_TAN                            constant varchar2(100) := 'tan';
C_TANH                           constant varchar2(100) := 'tanh';
C_TEMPFILE_REUSE_CLAUSE          constant varchar2(100) := 'tempfile_reuse_clause';
C_TEMPORARY_TABLESPACE_CLAUSE    constant varchar2(100) := 'temporary_tablespace_clause';
C_TIERING_CLAUSE                 constant varchar2(100) := 'tiering_clause';
C_TIMEOUT_CLAUSE                 constant varchar2(100) := 'timeout_clause';
C_TIMESTAMP_TO_SCN               constant varchar2(100) := 'timestamp_to_scn';
C_TO_BINARY_DOUBLE               constant varchar2(100) := 'to_binary_double';
C_TO_BINARY_FLOAT                constant varchar2(100) := 'to_binary_float';
C_TO_BLOB                        constant varchar2(100) := 'to_blob';
C_TO_CHAR_CHAR                   constant varchar2(100) := 'to_char_char';
C_TO_CHAR_DATE                   constant varchar2(100) := 'to_char_date';
C_TO_CHAR_NUMBER                 constant varchar2(100) := 'to_char_number';
C_TO_CLOB                        constant varchar2(100) := 'to_clob';
C_TO_DATE                        constant varchar2(100) := 'to_date';
C_TO_DSINTERVAL                  constant varchar2(100) := 'to_dsinterval';
C_TO_LOB                         constant varchar2(100) := 'to_lob';
C_TO_MULTI_BYTE                  constant varchar2(100) := 'to_multi_byte';
C_TO_NCHAR_CHAR                  constant varchar2(100) := 'to_nchar_char';
C_TO_NCHAR_DATE                  constant varchar2(100) := 'to_nchar_date';
C_TO_NCHAR_NUMBER                constant varchar2(100) := 'to_nchar_number';
C_TO_NCLOB                       constant varchar2(100) := 'to_nclob';
C_TO_NUMBER                      constant varchar2(100) := 'to_number';
C_TO_SINGLE_BYTE                 constant varchar2(100) := 'to_single_byte';
C_TO_TIMESTAMP                   constant varchar2(100) := 'to_timestamp';
C_TO_TIMESTAMP_TZ                constant varchar2(100) := 'to_timestamp_tz';
C_TO_YMINTERVAL                  constant varchar2(100) := 'to_yminterval';
C_TRACE_FILE_CLAUSE              constant varchar2(100) := 'trace_file_clause';
C_TRANSLATE                      constant varchar2(100) := 'translate';
C_TRANSLATE_USING                constant varchar2(100) := 'translate_using';
C_TREAT                          constant varchar2(100) := 'treat';
C_TRIM                           constant varchar2(100) := 'trim';
C_TRUNCATE_CLUSTER               constant varchar2(100) := 'truncate_cluster';
C_TRUNCATE_PARTITION_SUBPART     constant varchar2(100) := 'truncate_partition_subpart';
C_TRUNCATE_TABLE                 constant varchar2(100) := 'truncate_table';
C_TRUNC_DATE                     constant varchar2(100) := 'trunc_date';
C_TRUNC_NUMBER                   constant varchar2(100) := 'trunc_number';
C_TYPE_CONSTRUCTOR_EXPRESSION    constant varchar2(100) := 'type_constructor_expression';
C_TZ_OFFSET                      constant varchar2(100) := 'tz_offset';
C_UID                            constant varchar2(100) := 'uid';
C_UNDER_PATH_CONDITION           constant varchar2(100) := 'under_path_condition';
C_UNDO_TABLESPACE                constant varchar2(100) := 'undo_tablespace';
C_UNDO_TABLESPACE_CLAUSE         constant varchar2(100) := 'undo_tablespace_clause';
C_UNDROP_DISK_CLAUSE             constant varchar2(100) := 'undrop_disk_clause';
C_UNIFIED_AUDIT                  constant varchar2(100) := 'unified_audit';
C_UNIFIED_NOAUDIT                constant varchar2(100) := 'unified_noaudit';
C_UNISTR                         constant varchar2(100) := 'unistr';
C_UNNEST_HINT                    constant varchar2(100) := 'unnest_hint';
C_UNPIVOT_CLAUSE                 constant varchar2(100) := 'unpivot_clause';
C_UNPIVOT_IN_CLAUSE              constant varchar2(100) := 'unpivot_in_clause';
C_UNUSABLE_EDITIONS_CLAUSE       constant varchar2(100) := 'unusable_editions_clause';
C_UPDATE                         constant varchar2(100) := 'update';
C_UPDATEXML                      constant varchar2(100) := 'updatexml';
C_UPDATE_ALL_INDEXES_CLAUSE      constant varchar2(100) := 'update_all_indexes_clause';
C_UPDATE_GLOBAL_INDEX_CLAUSE     constant varchar2(100) := 'update_global_index_clause';
C_UPDATE_INDEX_CLAUSES           constant varchar2(100) := 'update_index_clauses';
C_UPDATE_INDEX_PARTITION         constant varchar2(100) := 'update_index_partition';
C_UPDATE_INDEX_SUBPARTITION      constant varchar2(100) := 'update_index_subpartition';
C_UPDATE_SET_CLAUSE              constant varchar2(100) := 'update_set_clause';
C_UPGRADE_TABLE_CLAUSE           constant varchar2(100) := 'upgrade_table_clause';
C_UPPER                          constant varchar2(100) := 'upper';
C_USER                           constant varchar2(100) := 'user';
C_USERENV                        constant varchar2(100) := 'userenv';
C_USERGROUP_CLAUSES              constant varchar2(100) := 'usergroup_clauses';
C_USER_CLAUSES                   constant varchar2(100) := 'user_clauses';
C_USER_DEFINED_FUNCTION          constant varchar2(100) := 'user_defined_function';
C_USER_TABLESPACES_CLAUSE        constant varchar2(100) := 'user_tablespaces_clause';
C_USE_CONCAT_HINT                constant varchar2(100) := 'use_concat_hint';
C_USE_CUBE_HINT                  constant varchar2(100) := 'use_cube_hint';
C_USE_HASH_HINT                  constant varchar2(100) := 'use_hash_hint';
C_USE_KEY                        constant varchar2(100) := 'use_key';
C_USE_MERGE_HINT                 constant varchar2(100) := 'use_merge_hint';
C_USE_NL_HINT                    constant varchar2(100) := 'use_nl_hint';
C_USE_NL_WITH_INDEX_HINT         constant varchar2(100) := 'use_nl_with_index_hint';
C_USING_FUNCTION_CLAUSE          constant varchar2(100) := 'using_function_clause';
C_USING_INDEX_CLAUSE             constant varchar2(100) := 'using_index_clause';
C_USING_STATISTICS_TYPE          constant varchar2(100) := 'using_statistics_type';
C_USING_TYPE_CLAUSE              constant varchar2(100) := 'using_type_clause';
C_VALIDATION_CLAUSES             constant varchar2(100) := 'validation_clauses';
C_VALUE                          constant varchar2(100) := 'value';
C_VALUES_CLAUSE                  constant varchar2(100) := 'values_clause';
C_VARIANCE                       constant varchar2(100) := 'variance';
C_VARRAY_COL_PROPERTIES          constant varchar2(100) := 'varray_col_properties';
C_VARRAY_STORAGE_CLAUSE          constant varchar2(100) := 'varray_storage_clause';
C_VAR_POP                        constant varchar2(100) := 'var_pop';
C_VAR_SAMP                       constant varchar2(100) := 'var_samp';
C_VIRTUAL_COLUMN_DEFINITION      constant varchar2(100) := 'virtual_column_definition';
C_VSIZE                          constant varchar2(100) := 'vsize';
C_WHERE_CLAUSE                   constant varchar2(100) := 'where_clause';
C_WIDTH_BUCKET                   constant varchar2(100) := 'width_bucket';
C_WINDOWING_CLAUSE               constant varchar2(100) := 'windowing_clause';
C_WITH_CLAUSE                    constant varchar2(100) := 'with_clause';
C_XMLAGG                         constant varchar2(100) := 'xmlagg';
C_XMLCAST                        constant varchar2(100) := 'xmlcast';
C_XMLCDATA                       constant varchar2(100) := 'xmlcdata';
C_XMLCOLATTVAL                   constant varchar2(100) := 'xmlcolattval';
C_XMLCOMMENT                     constant varchar2(100) := 'xmlcomment';
C_XMLCONCAT                      constant varchar2(100) := 'xmlconcat';
C_XMLDIFF                        constant varchar2(100) := 'xmldiff';
C_XMLELEMENT                     constant varchar2(100) := 'xmlelement';
C_XMLEXISTS                      constant varchar2(100) := 'xmlexists';
C_XMLFOREST                      constant varchar2(100) := 'xmlforest';
C_XMLINDEX_CLAUSE                constant varchar2(100) := 'xmlindex_clause';
C_XMLISVALID                     constant varchar2(100) := 'xmlisvalid';
C_XMLPARSE                       constant varchar2(100) := 'xmlparse';
C_XMLPATCH                       constant varchar2(100) := 'xmlpatch';
C_XMLPI                          constant varchar2(100) := 'xmlpi';
C_XMLQUERY                       constant varchar2(100) := 'xmlquery';
C_XMLROOT                        constant varchar2(100) := 'xmlroot';
C_XMLSCHEMA_SPEC                 constant varchar2(100) := 'xmlschema_spec';
C_XMLSEQUENCE                    constant varchar2(100) := 'xmlsequence';
C_XMLSERIALIZE                   constant varchar2(100) := 'xmlserialize';
C_XMLTABLE                       constant varchar2(100) := 'xmltable';
C_XMLTABLE_OPTIONS               constant varchar2(100) := 'xmltable_options';
C_XMLTRANSFORM                   constant varchar2(100) := 'xmltransform';
C_XMLTYPE_COLUMN_PROPERTIES      constant varchar2(100) := 'xmltype_column_properties';
C_XMLTYPE_STORAGE                constant varchar2(100) := 'xmltype_storage';
C_XMLTYPE_TABLE                  constant varchar2(100) := 'xmltype_table';
C_XMLTYPE_VIEW_CLAUSE            constant varchar2(100) := 'xmltype_view_clause';
C_XMLTYPE_VIRTUAL_COLUMNS        constant varchar2(100) := 'xmltype_virtual_columns';
C_XML_ATTRIBUTES_CLAUSE          constant varchar2(100) := 'xml_attributes_clause';
C_XML_NAMESPACES_CLAUSE          constant varchar2(100) := 'xml_namespaces_clause';
C_XML_PASSING_CLAUSE             constant varchar2(100) := 'xml_passing_clause';
C_XML_TABLE_COLUMN               constant varchar2(100) := 'xml_table_column';
C_XML_TYPES                      constant varchar2(100) := 'xml_types';
C_YM_ISO_FORMAT                  constant varchar2(100) := 'ym_iso_format';
C_ZONEMAP_ATTRIBUTES             constant varchar2(100) := 'zonemap_attributes';
C_ZONEMAP_CLAUSE                 constant varchar2(100) := 'zonemap_clause';
C_ZONEMAP_REFRESH_CLAUSE         constant varchar2(100) := 'zonemap_refresh_clause';

end;
/
create or replace package body plsql_parser is
--  _____   ____    _   _  ____ _______   _    _  _____ ______  __     ________ _______ 
-- |  __ \ / __ \  | \ | |/ __ \__   __| | |  | |/ ____|  ____| \ \   / /  ____|__   __|
-- | |  | | |  | | |  \| | |  | | | |    | |  | | (___ | |__     \ \_/ /| |__     | |   
-- | |  | | |  | | | . ` | |  | | | |    | |  | |\___ \|  __|     \   / |  __|    | |   
-- | |__| | |__| | | |\  | |__| | | |    | |__| |____) | |____     | |  | |____   | |   
-- |_____/ \____/  |_| \_|\____/  |_|     \____/|_____/|______|    |_|  |______|  |_|   
-- 
--This package is experimental and does not work yet.



type number_table is table of number;
type string_table is table of varchar2(32767);

g_nodes                     node_table := node_table();
g_ast_tokens                token_table;  --AST = abstract syntax tree.
g_ast_token_index           number;
g_optional                  boolean; --Holds return value of optional functions.
g_parse_tree_tokens         token_table;
g_map_between_parse_and_ast number_table := number_table();
g_reserved_words            string_table;











-------------------------------------------------------------------------------
--Helper functions
-------------------------------------------------------------------------------
/*
procedure push(p_node node) is
begin
	g_nodes.extend;
	g_nodes(g_nodes.count) := p_node;
end;
*/

--Puprose: Create a new node and return the node ID.
function push(p_node_type varchar2, p_parent_id number) return number is
begin
	g_nodes.extend;
	g_nodes(g_nodes.count) := node(id => g_nodes.count, type => p_node_type, parent_id => p_parent_id, lexer_token => g_ast_tokens(g_ast_token_index));
	return g_nodes.count;
exception
	when subscript_beyond_count then
		return null;
end push;


procedure push(p_node_type varchar2, p_parent_id number) is
	v_ignore_result number;
begin
	v_ignore_result := push(p_node_type, p_parent_id);
end push;


procedure pop is
begin
	g_nodes.trim;
end pop;


function pop(p_node_index_before number default null, p_nodes_before node_table default null) return boolean is
begin
	if p_node_index_before is null then
		g_nodes.trim;
	else
		--TODO: Is this correct?
		--g_node_index := p_node_index_before;
		g_nodes := p_nodes_before;
	end if;
	return false;
end pop;


function current_value return clob is begin
	begin
		return upper(g_ast_tokens(g_ast_token_index).value);
	exception when subscript_beyond_count then
		return null;
	end;
end current_value;


function current_type return varchar2 is begin
	begin
		return g_ast_tokens(g_ast_token_index).type;
	exception when subscript_beyond_count then
		return null;
	end;
end current_type;


procedure increment(p_increment number default 1) is begin
	g_ast_token_index := g_ast_token_index + p_increment;
end increment;


function match_terminal(p_value varchar2, p_parent_id in number) return boolean is
begin
	push(p_value, p_parent_id);

	if current_value = p_value then
		increment;
		return true;
	else
		return pop;
	end if;
end match_terminal;


function next_value(p_increment number default 1) return clob is begin
	begin
		return upper(g_ast_tokens(g_ast_token_index+p_increment).value);
	exception when subscript_beyond_count then
		return null;
	end;
end next_value;


function previous_value(p_decrement number) return clob is begin
	begin
		if g_ast_token_index - p_decrement <= 0 then
			return null;
		else
			return upper(g_ast_tokens(g_ast_token_index - p_decrement).value);
		end if;
	exception when subscript_beyond_count then
		null;
	end;
end previous_value;


--Purpose: Determine which reserved words are truly reserved.
--V$RESERVED_WORD.RESERVED is not reliable so we must use dynamic SQL and catch
--errors to build a list of reserved words.
function get_reserved_words return string_table is
	v_dummy varchar2(1);
	v_reserved_words string_table := string_table();
begin
	for reserved_words in
	(
		select *
		from v$reserved_words
		order by keyword
	) loop
		begin
			execute immediate 'select dummy from dual '||reserved_words.keyword into v_dummy;
		exception when others then
			v_reserved_words.extend;
			v_reserved_words(v_reserved_words.count) := reserved_words.keyword;
			--For testing.
			--dbms_output.put_line('Failed: '||reserved_words.keyword||', Reserved: '||reserved_words.reserved);
		end;
	end loop;

	return v_reserved_words;
end get_reserved_words;


--Purpose: Remove the SUBQUERY node, re-number descendents to fill in gap, return parent id. 
--ASSUMPTIONS: 
function remove_extra_subquery(v_subquery_node_id number) return number is
	v_new_nodes node_table := node_table();
begin
	--Copy nodes up until the subquery node.
	for i in 1 .. v_subquery_node_id - 1 loop
		v_new_nodes.extend;
		v_new_nodes(v_new_nodes.count) := g_nodes(i);
	end loop;

	--Copy nodes after subquery until the end.
	for i in v_subquery_node_id + 1 .. g_nodes.count loop
		v_new_nodes.extend;
		--Shrink ID and PARENT_ID by 1 to fill in gap.
		v_new_nodes(v_new_nodes.count) := node(
			id => g_nodes(i).id - 1,
			type => g_nodes(i).type,
			parent_id => g_nodes(i).parent_id - 1,
			lexer_token => g_nodes(i).lexer_token
		);
	end loop;

	--Switcheroo
	g_nodes := v_new_nodes;

	return v_subquery_node_id - 1;
end remove_extra_subquery;


--------------------------------------------------------------------------------
--Purpose: Get the line up to a specific token.
function get_line_up_until_error(p_tokens token_table, p_token_error_index number) return varchar2 is
	v_newline_position number;
	v_line clob;

	--DBMS_INSTR does not allow negative positions so we must loop through to find the last.
	function find_last_newline_position(p_clob in clob) return number is
		v_nth number := 1;
		v_new_newline_position number;
		v_previous_newline_position number;
	begin
		v_previous_newline_position := dbms_lob.instr(lob_loc => p_clob, pattern => chr(10), nth => v_nth);

		loop
			v_nth := v_nth + 1;
			v_new_newline_position := dbms_lob.instr(lob_loc => p_clob, pattern => chr(10), nth => v_nth);

			if v_new_newline_position = 0 then
				return v_previous_newline_position;
			else
				v_previous_newline_position := v_new_newline_position;
			end if;
		end loop;
	end find_last_newline_position;
begin
	--Get text before index token and after previous newline.
	for i in reverse 1 .. p_token_error_index loop
		--Look for the last newline.
		v_newline_position := find_last_newline_position(p_tokens(i).value);

		--Get everything after newline if there is one, and exit.
		if v_newline_position > 0 then
			--(If the last character is a newline, the +1 will return null, which is what we want anyway.)
			v_line := dbms_lob.substr(lob_loc => p_tokens(i).value, offset => v_newline_position + 1) || v_line;
			exit;
		--Add entire string to the line if there was no newline.
		else
			v_line := p_tokens(i).value || v_line;
		end if;
	end loop;

	--Only return the first 4K bytes of data, to fit in SQL varchar2(4000). 
	return substrb(cast(substr(v_line, 1, 4000) as varchar2), 1, 4000);
end get_line_up_until_error;


--Purpose: Raise exception with information about the error.
--ASSUMES: All production rules are coded as functions on a line like: function%return boolean is%
procedure parse_error(p_error_expected_items varchar2, p_line_number number) is
	v_production_rule varchar2(4000);
	v_parse_tree_token_index number;
begin
	--Find the production rule the error line occurred on.
	select production_rule
	into v_production_rule
	from
	(
		--Find the production rule based on the function name.
		--ASSUMES a consistent coding style.
		--(Irony alert - this is exactly the kind of hack this program is built to avoid.)
		select
			row_number() over (order by line desc) last_when_1,
			replace(regexp_replace(text, 'function ([^\(]+).*', '\1'), chr(10)) production_rule
		from user_source
		where name = $$plsql_unit
			and type = 'PACKAGE BODY'
			and line <= p_line_number
			--Assumes coding style.
			and lower(text) like 'function%return boolean is%'
	) function_names
	where last_when_1 = 1;

	--Find the last token examined.
	begin
		v_parse_tree_token_index := g_map_between_parse_and_ast(g_ast_token_index);
	exception when subscript_beyond_count then
		v_parse_tree_token_index := g_map_between_parse_and_ast(g_ast_token_index-1);
	end;

	--Raise an error with some information about the rule.
	raise_application_error(-20123,
		'Error in line '||g_nodes(g_nodes.count).lexer_token.line_number||', '||
		'column '||to_char(g_nodes(g_nodes.count).lexer_token.last_char_position+1)||':'||chr(10)||
		get_line_up_until_error(g_parse_tree_tokens, v_parse_tree_token_index)||'<-- ERROR HERE'||chr(10)||
		'Error in '||v_production_rule||', expected one of: '||p_error_expected_items
	);
--Just in case a function cannot be found.
exception when no_data_found then
	raise_application_error(-20000, 'Could not find function for line number '||p_line_number||'.');
end parse_error;


function a_word_but_not_reserved(node_type varchar2, p_parent_id number) return boolean is
begin
	push(node_type, p_parent_id);

	if current_type = plsql_lexer.c_word and current_value not member of g_reserved_words then
		increment;
		return true;
	else
		return pop;
	end if;
end a_word_but_not_reserved;










-------------------------------------------------------------------------------
--Production Rules.
-------------------------------------------------------------------------------

--Forward declarations so functions can be placed in alphabetical order.
function containers_clause(p_parent_id number) return boolean;
function flashback_query_clause(p_parent_id number) return boolean;
function for_update_clause(p_parent_id number) return boolean;
function group_by_clause(p_parent_id number) return boolean;
function hierarchical_query_clause(p_parent_id number) return boolean;
function hint(p_parent_id number) return boolean;
function join_clause(p_parent_id number) return boolean;
function model_clause(p_parent_id number) return boolean;
function order_by_clause(p_parent_id number) return boolean;
function plsql_declarations(p_parent_id number) return boolean;
function query_block(p_parent_id number) return boolean;
function query_table_expression(p_parent_id number) return boolean;
function row_limiting_clause(p_parent_id number) return boolean;
function select_list(p_parent_id number) return boolean;
function select_statement(p_parent_id number) return boolean;
function subquery(p_parent_id number) return boolean;
function subquery_factoring_clause(p_parent_id number) return boolean;
function table_reference(p_parent_id number) return boolean;
function where_clause(p_parent_id number) return boolean;
function with_clause(p_parent_id number) return boolean;


function containers_clause(p_parent_id number) return boolean is
begin
	push(C_CONTAINERS_CLAUSE, p_parent_id);

	--TODO
	return pop;
end containers_clause;


function flashback_query_clause(p_parent_id number) return boolean is
begin
	push(C_FLASHBACK_QUERY_CLAUSE, p_parent_id);

	--TODO
	return pop;
end flashback_query_clause;


function for_update_clause(p_parent_id number) return boolean is
begin
	--TODO
	return true;
end for_update_clause;


function group_by_clause(p_parent_id number) return boolean is
begin
	--TODO
	return true;
end group_by_clause;


function hierarchical_query_clause(p_parent_id number) return boolean is
begin
	--TODO
	return true;
end hierarchical_query_clause;


--Hints are semi-abstract.
--Comments are excluded from the AST tokens because they generally never matter
--and it would really clutter things up to always examine them and ignore them.
--However, a comment in a specific format in the right place should count as a node.
--This means that occasionally we need to search through the parse tokens.
function hint(p_parent_id number) return boolean is
	v_parse_token_index number;
begin
	push(C_HINT, p_parent_id);

	--Use "-1" to start at previous node and then iterate forward.
	v_parse_token_index := g_map_between_parse_and_ast(g_ast_token_index-1);
	dbms_output.put_line('Parse token index: '||v_parse_token_index);

	--Start from parse tree token after the last node.
	for i in v_parse_token_index+1 .. g_parse_tree_tokens.count loop
		--False if an abstract token is found
		if g_parse_tree_tokens(i).type not in (plsql_lexer.c_whitespace, plsql_lexer.c_comment, plsql_lexer.c_eof) then
			return pop;
		--True if it's a hint.
		elsif g_parse_tree_tokens(i).type = plsql_lexer.c_comment and substr(g_parse_tree_tokens(i).value, 1, 3) in ('--+', '/*+') then
			--Replace node that points to abstract token with node that points to comment.
			g_nodes(g_nodes.count) := node(id => g_nodes.count, type => C_HINT, parent_id => p_parent_id, lexer_token => g_parse_tree_tokens(i));
			return true;
		end if;
	end loop;

	return pop;
exception when subscript_beyond_count then
	return pop;
end hint;


function join_clause(p_parent_id number) return boolean is
begin
	--TODO
	return true;
end join_clause;


function model_clause(p_parent_id number) return boolean is
begin
	--TODO
	return true;
end model_clause;


function order_by_clause(p_parent_id number) return boolean is
begin
	--TODO
	return true;
end order_by_clause;


function plsql_declarations(p_parent_id number) return boolean is
begin
	--TODO: PL/SQL is not yet supported.
	if current_value in ('PROCEDURE', 'FUNCTION') and next_value not in ('(', 'AS') then
		raise_application_error(-20000, 'PL/SQL is not yet supported.');
	else
		return false;
	end if;
end plsql_declarations;


function query_block(p_parent_id number) return boolean is
	v_new_node_id number;
begin
	v_new_node_id := push(C_QUERY_BLOCK, p_parent_id);
	g_optional := with_clause(v_new_node_id);
	if match_terminal('SELECT', v_new_node_id) then
		g_optional := hint(v_new_node_id);
		g_optional := match_terminal('DISTINCT', v_new_node_id) or match_terminal('UNIQUE', v_new_node_id) or match_terminal('ALL', v_new_node_id);
		if select_list(v_new_node_id) then
			if match_terminal('FROM', v_new_node_id) then
				if
				(
					table_reference(v_new_node_id) or
					join_clause(v_new_node_id) or
					(
						match_terminal('(', v_new_node_id) and
						join_clause(v_new_node_id) and
						match_terminal(')', v_new_node_id)
					)
				) then
					loop
						if match_terminal(',', v_new_node_id) then
							if
							(
								table_reference(v_new_node_id) or
								join_clause(v_new_node_id) or
								(
									match_terminal('(', v_new_node_id) and
									join_clause(v_new_node_id) and
									match_terminal(')', v_new_node_id)
								)
							) then
								null;
							else
								parse_error('table_reference, join_clause, or ( join_clause )', $$plsql_line);
							end if;
						else
							exit;
						end if;
					end loop;

					g_optional := where_clause(v_new_node_id);
					g_optional := hierarchical_query_clause(v_new_node_id);
					g_optional := group_by_clause(v_new_node_id);
					g_optional := model_clause(v_new_node_id);
					return true;
				else
					parse_error('table_reference, join_clause, or ( join_clause )', $$plsql_line);
				end if;
			else
				parse_error('FROM', $$plsql_line);
			end if;
		else
			parse_error('select_list', $$plsql_line);
		end if;
	else
		return pop;
	end if;
end query_block;


function query_table_expression(p_parent_id number) return boolean is
	v_new_node_id number;
begin
	v_new_node_id := push(C_QUERY_TABLE_EXPRESSION, p_parent_id);

	--TODO:
	--lateral, table_collection_expression, schema., etc.

	if a_word_but_not_reserved(C_QUERY_NAME, v_new_node_id) then
		return true;
	end if;

	return pop;
end query_table_expression;


function row_limiting_clause(p_parent_id number) return boolean is
begin
	--TODO
	return true;
end row_limiting_clause;


--select::=
--DIFFERENCE FROM MANUAL: "select_statement" instead of "select" to avoid collision with SELECT token.
function select_statement(p_parent_id number) return boolean is
	v_new_node_id number;
begin
	v_new_node_id := push(C_SELECT_STATEMENT, p_parent_id);

	if subquery(v_new_node_id) then
		g_optional := for_update_clause(v_new_node_id);
		--DIFFERENCE FROM MANUAL: The semicolon is optional, not required.
		g_optional := match_terminal(';', v_new_node_id);
		return true;
	else
		return pop;
	end if;
end select_statement;


function select_list(p_parent_id number) return boolean is
	v_new_node_id number;
begin
	v_new_node_id := push(C_SELECT_LIST, p_parent_id);

	--TODO
	if match_terminal('*', v_new_node_id) then
		return true;
	else
		return pop;
	end if;
end select_list;


function subquery(p_parent_id number) return boolean is
	v_first_subquery_id number;
	v_second_subquery_node_id number;
begin
	v_first_subquery_id := push(C_SUBQUERY, p_parent_id);

	--Third branch of diagram.
	if match_terminal('(', v_first_subquery_id) then 
		if subquery(v_first_subquery_id) then
			if match_terminal(')', v_first_subquery_id) then
				--Two optional rules at the end. 
				g_optional := order_by_clause(v_first_subquery_id);
				g_optional := row_limiting_clause(v_first_subquery_id);
				return true;
			else
				parse_error('")"', $$plsql_line);
			end if;
		else
			return pop;
		end if;

	--First or second branch of diagram.
	else
		--Assume it's a subquery (middle branch) - workaround to avoid left-recursion.
		v_second_subquery_node_id := push(C_SUBQUERY, v_first_subquery_id);

		if query_block(v_second_subquery_node_id) then
			--Second branch of diagram.
			if current_value in ('UNION', 'INTERSECT', 'MINUS') then
				loop
					if
					(
						(match_terminal('UNION', v_first_subquery_id) and match_terminal('ALL', v_first_subquery_id) is not null)
						or
						match_terminal('INTERSECT', v_first_subquery_id)
						or
						match_terminal('MINUS', v_first_subquery_id)
					) then
						if subquery(v_first_subquery_id) then
							null;
						else
							parse_error('subquery', $$plsql_line);
						end if;
					else
						exit when true;						
					end if;
				end loop;
				return true;
			--First branch of diagram.
			else
				--Remove extra SUBQUERY, it's a plain QUERY_BLOCK.
				v_first_subquery_id := remove_extra_subquery(v_second_subquery_node_id);

				--Two optional rules at the end. 
				g_optional := order_by_clause(v_first_subquery_id);
				g_optional := row_limiting_clause(v_first_subquery_id);
				return true;
			end if;
		else
			return pop;
		end if;
	end if;
end subquery;


function subquery_factoring_clause(p_parent_id number) return boolean is
	v_new_node_id number;
begin
	v_new_node_id := push(C_SUBQUERY_FACTORING_CLAUSE, p_parent_id);

	if a_word_but_not_reserved(C_QUERY_NAME, v_new_node_id) then
		--TODO
		return false;
	end if;

	return pop;
end subquery_factoring_clause;


function table_reference(p_parent_id number) return boolean is
	v_new_node_id number;
begin
	v_new_node_id := push(C_TABLE_REFERENCE, p_parent_id);

	if containers_clause(v_new_node_id) then
		g_optional := a_word_but_not_reserved(C_T_ALIAS, v_new_node_id);
	elsif next_value(1) = 'ONLY' and next_value(2) = '(' then
		increment;
		increment;
		if query_table_expression(v_new_node_id) then
			if match_terminal(')', v_new_node_id) then
--				g_optional := flashback_query_clause;
--				g_optional := pivot_clause or unpivot_clause or row_pattern_clause;
				g_optional := a_word_but_not_reserved(C_T_ALIAS, v_new_node_id);
				return true;				
			else
				parse_error('")"', $$plsql_line);
			end if;
		else
			parse_error('query_table_expression', $$plsql_line);
			return pop;
		end if;
	elsif query_table_expression(v_new_node_id) then
		g_optional := flashback_query_clause(v_new_node_id);
--		g_optional := pivot_clause or unpivot_clause or row_pattern_clause;
		g_optional := a_word_but_not_reserved(C_T_ALIAS, v_new_node_id);
		return true;				
	else
		parse_error('ONLY(query_table_expression), query_table_expression, or containers_clause', $$plsql_line);
		return pop;
	end if;
end table_reference;


function where_clause(p_parent_id number) return boolean is
begin
	--TODO
	return true;
end where_clause;


function with_clause(p_parent_id number) return boolean is
	v_new_node_id number;
begin
	v_new_node_id := push(C_WITH_CLAUSE, p_parent_id);

	if match_terminal('WITH', v_new_node_id) then
		--MANUAL DIFFERENCE  (sort of, it matches the "Note")
		--"Note:
		--You cannot specify only the WITH keyword. You must specify at least one of the clauses plsql_declarations or subquery_factoring_clause."
		if not (plsql_declarations(v_new_node_id) or subquery_factoring_clause(v_new_node_id)) then
			parse_error('plsql_declarations or subquery_factoring_clause', $$plsql_line);
		else
			return true;
		end if;
	else
		return pop;
	end if;
end with_clause;










-------------------------------------------------------------------------------
--Main Function
-------------------------------------------------------------------------------
/*
	Purpose: Recursive descent parser for PL/SQL.

	This link has a good introduction to recursive descent parsers: https://www.cis.upenn.edu/~matuszek/General/recursive-descent-parsing.html)
*/
function parse(
		p_source        in clob,
		p_user          in varchar2 default user
) return node_table is
begin
	--Check input.
	--TODO

	--Reset values, tokenize input.
	g_nodes := node_table();
	g_ast_tokens := token_table();
	g_ast_token_index := 1;
	g_parse_tree_tokens := plsql_lexer.lex(p_source);
	if g_reserved_words is null then
		g_reserved_words := get_reserved_words;
	end if;

	--Convert parse tree into abstract syntax tree by removing whitespace, comment, and EOF.
	--Also create a map between the two.
	for i in 1 .. g_parse_tree_tokens.count loop
		if g_parse_tree_tokens(i).type not in (plsql_lexer.c_whitespace, plsql_lexer.c_comment, plsql_lexer.c_eof) then
			g_ast_tokens.extend;
			g_ast_tokens(g_ast_tokens.count) := g_parse_tree_tokens(i);

			g_map_between_parse_and_ast.extend;
			g_map_between_parse_and_ast(g_map_between_parse_and_ast.count) := i;
		end if;
	end loop;

	--Classify, create statement based on classification.
	g_optional := select_statement(null);

	return g_nodes;
end parse;

end;
/
