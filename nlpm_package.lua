---@class PackageDependency
---@field name string package name as it will be used in file gen
---@field repo string git repo
---@field version? string git hash(#) or tag(v), defaults to "#HEAD"

---@class Package
---@field dependencies? PackageDependency[] List of package dependencies
---@field scripts? table<string, string> scripts that can be called with `nlpm run`

---@type Package
return {
  dependencies = {
    {
      name = "ssdg",
      repo = "https://github.com/kmafeni04/ssdg",
      version = "#9e1fb58f183ae7efea98d25a40d6d1bf38f483af",
    },
    {
      name = "ansicolor-nelua",
      repo = "https://github.com/kmafeni04/ansicolor-nelua",
      version = "#82d3d7e1154316ca75c7a52c4f17eb2d67add499",
    },
    {
      name = "map-nelua",
      repo = "https://github.com/kmafeni04/map-nelua",
      version = "#74f7d0ebbf5057ba202f2659d25c75b225b17d7d",
    },
    {
      name = "inflect-nelua",
      repo = "https://github.com/kmafeni04/inflect-nelua",
      version = "#9e65ff4ff711c7466eda95d62568400f092f631b",
    },
    {
      name = "mariadb-bindings-nelua",
      repo = "https://github.com/kmafeni04/mariadb-bindings-nelua",
      version = "#7b7226f3f0a0524931f40ce67948893dc9a23f7d",
    },
    {
      name = "libpq-fe-bindings-nelua",
      repo = "https://github.com/kmafeni04/libpq-fe-bindings-nelua",
      version = "#db9a6de9b4a6010b70c3f13454365f49bae4fa4a",
    },
  },
  scripts = {
    test_sqlite = "nelua test.nelua -DSQLITE_TEST",
    test_pg = "nelua test.nelua -DPG_TEST",
    test_mysql = "nelua test.nelua -DMYSQL_TEST",
    docs = "nelua norm-doc.nelua",
  },
}
