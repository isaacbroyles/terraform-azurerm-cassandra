output "num_servers" {
  value = "${module.cassandra_servers.cluster_size}"
}

output "cassandra_admin_user_name" {
  value = "${module.cassandra_servers.admin_user_name}"
}

output "scale_set_name_servers" {
  value = "${module.cassandra_servers.scale_set_name}"
}

output "load_balancer_ip_address" {
  value = "${module.cassandra_servers.load_balancer_ip_address}"
}
