output "master_ip" {
  value = aws_instance.master.public_ip
}

output "worker-node_ip" {
  value = [for i in aws_instance.worker-node : i.public_ip]
}
