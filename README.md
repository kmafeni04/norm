# norm

A database ORM for the [nelua](https://www.nelua.io) programming language

## norm.nelua

### norm

The norm module

```lua
local norm = @record{}
```

### norm.destroy_rows

See [base.nelua](#basenelua)

```lua
local norm.destroy_rows = base.destroy_rows
```

### norm.escape_identifier

See [base.nelua](#basenelua)

```lua
local norm.escape_identifier = base.escape_identifier
```

### norm.escape_literal

See [base.nelua](#basenelua)

```lua
local norm.escape_literal = base.escape_literal
```

### norm.DbKind

Enum used to specify what database is connected in the [norm.Db](#normdb) module

```lua
local norm.DbKind = @enum{
  not_set = 0,
  sqlite,
  pg,
  mysql
}
```

### norm.Config

This record is used to configure the ORM on what database should be connected

```lua
local norm.Config = @record{
  kind: norm.DbKind,
  conn: union{
    sqlite: record{
      name: string
    },
    pg: record{
      name: string,
      user: string,
      password: string,
      host: string,
      port: uinteger
    },
    mysql: record{
      name: string,
      user: string,
      password: string,
      host: string,
      port: uinteger
    }
  },
  log: logger.NotSetOrBool
}
```

### norm.Db

This module is a collection of functions to make queries to the database

```lua
local norm.Db = @record{
  kind: norm.DbKind,
  conn: union{
    sqlite_db: *sqlite.type,
    pg_db: *pg.type,
    mysql_db: *mysql.type
  },
  log: logger.NotSetOrBool
}
```

### norm.Db.new

This function returns a new [norm.Db](#normdb) object and an error string
If no error occurs, an empty string is returned

```lua
function norm.Db.new(conf: norm.Config): (norm.Db, string)
```

### norm.Db:destroy

This function cleans up the memory used by the Db object

```lua
function norm.Db:destroy()
```

### norm.Db:query

Sends a query to the database returning a sequence(rows) of hashmap(columns) and a string
In the case of an error, a non empty string is returned describing the error
All further Db functions are constructed around this function

```lua
function norm.Db:query(sql: string): (sequence(hashmap(string, string)), string)
```

### norm.Db:table_exists

This function checks if a table exists in the database returning a `true` if it does, `false` otherwise

```lua
function norm.Db:table_exists(name: string): boolean
```

### norm.Db:select

This function at it's simplest just append "SELECT" to a query
Optionally, you can pass `where` to the query which will append a "WHERE" clause at the end of the sql with your conditions

```lua
function norm.Db:select(sql: string, where: hashmap(string, string)): (sequence(hashmap(string, string)), string)
```

### norm.Db:insert

This function inserts `values` into the table `tbl_name` returning the specified row of columns
If `returning` is not set, and empty sequence is returned

```lua
function norm.Db:insert(
    tbl_name: string,
    values: hashmap(string, string),
    returning: facultative(string)
  ): (sequence(hashmap(string, string)), string)
```

### norm.Db:update

This function updates a table `tbl_name` with `values` where `conditions` returning the specified row of columns
If `returning` is not set, and empty sequence is returned

```lua
function norm.Db:update(
    tbl_name: string,
    values: hashmap(string, string),
    conditions: hashmap(string, string),
    returning: facultative(string)
  ): (sequence(hashmap(string, string)), string)
```

### norm.Db:update

This function updates a table `tbl_name` with `values` where `conditions` returning the specified row of columns
If `returning` is not set, and empty sequence is returned

```lua
function norm.Db:delete(tbl_name: string, conditions: hashmap(string, string)): string
```

### norm.Schema

This is a collection of types and function for creating and managing your database schema

```lua
local norm.Schema = @record{}
```

### norm.Schema.Migration

This record is used in [norm.migrate](#normmigrate) to define a migration and what action is taken when that migration is called

```lua
local norm.Schema.Migration = @record{
  name: string,
  fn: function(db: norm.Db): string
}
```

### norm.Schema.ColumnOptions

These are options used to modify how a column is generated in [norm.Schema.Column](#normschemacolumn)

```lua
local norm.Schema.ColumnOptions = @record{
  default_val: string,
  is_null: boolean,
  unique: boolean,
  primary_key: boolean
}
```

### norm.Schema.ColumnType

This defines the type of a column in [norm.Schema.Column](#normschemacolumn)

```lua
local norm.Schema.ColumnType: type = @enum{
  not_set = 0,
  -- generic types
  integer,
  blob,
  text,
  numeric,
  real,
  varchar,
  any,
  ----------
  -- pg/mysql specific types
  timestamp,
  date,
  ----------
  -- pg specific types
  serial,
  ----------
  -- mysql specific types
  id,
  ---------
}
```

### norm.Schema.ColumnType

This defines the type of a column in [norm.Schema.Column](#normschemacolumn)

```lua
local norm.Schema.Column = @record{
  name: string,
  type: norm.Schema.ColumnType,
  opts: norm.Schema.ColumnOptions
}
```

### norm.Schema.create_table

This function creates a table, `name`, with the specified `columns` returning an error string
`extra_sql` is appended before the final ) of the create query
If no error occurs, the string is empty

```lua
function norm.Schema.create_table(db: norm.Db, name: string, columns: sequence(norm.Schema.Column), extra_sql: string): string
```

### norm.Schema.drop_table

This function drops a table, `name`, returning an error string
If no error occurs, the string is empty

```lua
function norm.Schema.drop_table(db: norm.Db, name: string): string
```

### norm.Schema.IndexOpts

These are options used to customise the create of an index in a table, see (norm.Schema.create_index)[normschemacreate_index]

```lua
local norm.Schema.IndexOpts = @record{
  where: string,
  unique: boolean,
  if_not_exists: boolean
}
```

### norm.Schema.create_index

This function adds new indexes to a table, `name`, returning an error string
It takes a list of `cols` and optional `opts` to create a new index
If no error occurs, the string is empty

```lua
function norm.Schema.create_index(db: norm.Db, name: string, cols: sequence(string), opts: norm.Schema.IndexOpts): string
```

### norm.Schema.drop_index

This function drops an index from a table, `name`, returning an error string
It takes a list of `cols` to determine the index to drop
If no error occurs, the string is empty

```lua
function norm.Schema.drop_index(db: norm.Db, name: string, cols: sequence(string)): string
```

### norm.Schema.add_column

This function adds a new `col` to a table, `tbl_name`, returning an error string
If no error occurs, the string is empty

```lua
function norm.Schema.add_column(db: norm.Db, tbl_name: string, col: norm.Schema.Column): string
```

### norm.Schema.drop_column

This function drops a `col` from a table, `tbl_name`, returning an error string
If no error occurs, the string is empty

```lua
function norm.Schema.drop_column(db: norm.Db, tbl_name: string, col_name: string): string
```

### norm.Schema.rename_column

This function renames a `col` from a table, `tbl_name`, replacing the `old_col_name` with the `new_col_name`, returning an error string
If no error occurs, the string is empty

```lua
function norm.Schema.rename_column(db: norm.Db, tbl_name: string, old_col_name: string, new_col_name: string): string
```

### norm.Schema.rename_table

This function renames a table replacing the `old_tbl_name` with the `new_tbl_name`, returning an error string
If no error occurs, the string is empty

```lua
function norm.Schema.rename_table(db: norm.Db, old_tbl_name: string, new_tbl_name: string): string
```

### norm.migrate

This function runs all `migrations`, returning an error string
If no error occurs, the string is empty

```lua
function norm.migrate(db: norm.Db, migrations: sequence(norm.Schema.Migration)): string
```

### norm.Model

This is used to interact with a particular table directly with more specific functions

```lua
local norm.Model = @record{
  db: norm.Db,
  name: string,
}
```

### norm.Model.Inst

Model Instance
This is meant to represent a single row in a model's table

```lua
local norm.Model.Inst = @record{
  db: norm.Db,
  tbl_name: string,
  row: hashmap(string, string)
}
```

### norm.Model.new

This function runs all `migrations`, returning a new [norm.Model](#normmodel) object and an error string
If no error occurs, the string is empty

```lua
function norm.Model.new(db: norm.Db, name: string): (norm.Model, string)
```

### norm.Model:find

This function attempts to find a row based on the `conditions`, returning a [norm.model.Inst](#normmodelinst) object and an error string
If no error occurs, the string is empty

```lua
function norm.Model:find(conditions: hashmap(string, string)): (norm.Model.Inst, string)
```

### norm.Model:select

This function attempts to find rows based on the `conditions`, returning a sequence of [norm.model.Inst](#normmodelinst) objects and an error string
If no error occurs, the string is empty

```lua
function norm.Model:select(conditions: hashmap(string, string)): (sequence(norm.Model.Inst), string)
```

### norm.Model:create

This function inserts `values` into the model's table, returning a [norm.model.Inst](#normmodelinst) object and an error string
If `returning` is not set, and empty object is returned
If no error occurs, the string is empty

```lua
function norm.Model:create(values: hashmap(string, string), returning: facultative(string)): (norm.Model.Inst, string)
```

### norm.Model.Inst:update

This function updates the row instance with `values` into the model's table, returning a [norm.model.Inst](#normmodelinst) object and an error string
If `returning` is not set, and empty object is returned
If no error occurs, the string is empty

```lua
function norm.Model.Inst:update(values: hashmap(string, string), returning: facultative(string)): (norm.Model.Inst, string)
```

### norm.Model.Inst:delete

This function deletes the row instance from the model's table, returning an error string
If no error occurs, the string is empty

```lua
function norm.Model.Inst:delete(): string
```

### norm.Model.Inst:get_col

This function get's the value of the col by `name` if it exists, returning the value and an error string
If no error occurs, the string is empty

```lua
function norm.Model.Inst:get_col(name: string): (string, string)
```

## base.nelua

This file provides some utility functions used by the library

### base.escape_identifier

Escapes a string `s` so it can be used as an identifier in sql queries

```lua
function base.escape_identifier(s: string)
```

### base.escape_literal

Escapes a string `s` so it can be used as a literal in sql queries

```lua
function base.escape_literal(s: string)
```

### base.format_date

Returns a date string formatted properly for insertion in the database.
The `time` argument is optional, will default to the current UTC time.

```lua
function base.format_date(time: facultative(integer))
```

### base.destroy_rows

Cleans up memory for rows returned from running sql queries

```lua
function base.destroy_rows(rows: sequence(hashmap(string, string)))
```

## logger.nelua

### logger record

The logger module

```lua
local logger = @record{}
```

### logger.NotSetOrBool

Used to determine if the logger should print to console or not

```lua
local logger.NotSetOrBool = @enum{
  NOT_SET = 0,
  TRUE,
  FALSE
}
```

### logger.log

If the `log` is not set or set to true, will print `s`

```lua
function logger.log(log: logger.NotSetOrBool, s: string)
```

---

## Acknowledgements
