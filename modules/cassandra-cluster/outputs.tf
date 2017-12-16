output "scale_set_name" {
  value = "${element(concat(azurerm_virtual_machine_scale_set.cassandra_with_load_balancer.*.name, azurerm_virtual_machine_scale_set.cassandra.*.name), 0)}"
}

output "admin_user_name" {
  value = "${var.admin_user_name}"
}

output "cluster_size" {
  value = "${var.cluster_size}"
}

output "load_balancer_ip_address" {
  value = "${azurerm_public_ip.cassandra_access.*.ip_address}"
}

output "load_balancer_id" {
  value = "${azurerm_lb.cassandra_access.*.id}"
}

output "backend_pool_id" {
  value = "${azurerm_lb_backend_address_pool.cassandra_bepool.*.id}"
}
