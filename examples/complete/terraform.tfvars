# fixtures
region                 = "eu-west-2"
cluster_name           = "foo-cluster"
db_name                = "foo"
environment            = "notprod"
node_type              = "dc2.large"
cluster_nodes          = 1
wlm_json_configuration = "[{\"query_concurrency\": 5}]"

tags = {
  Owner   = "Foo"
  Project = "sample"
}
