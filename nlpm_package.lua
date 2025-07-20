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
      version = "#0b5f769242a441bdb4d293957be240e6fb694428",
    },
    {
      name = "map-nelua",
      repo = "https://github.com/kmafeni04/map-nelua",
      version = "#4572efa8784fcce5763073007852573fb578fbdd",
    },
    {
      name = "inflect-nelua",
      repo = "https://github.com/kmafeni04/inflect-nelua",
      version = "#f57ebd68f4274bbf7f40ec409dea38c08bc733c1",
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
