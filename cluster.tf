# Create keypair
resource "aws_key_pair" "k8s_key" {
  key_name = var.key_name
  public_key = "id_rsa.pub"
}

# Create Controlplane (Master)
resource "aws_instance" "master" {
  ami           = var.ami["master"] 
  instance_type = var.instance_type["master"]
  key_name      = aws_key_pair.k8s_key.key_name
  associate_public_ip_address = true
  subnet_id = aws_subnet.cluster_subnet.id
  vpc_security_group_ids = [aws_security_group.master.id]
   
   root_block_device {
    volume_type = "gp2"
    volume_size = 14

  }
  timeouts {
    create = "10m"
  }
  tags = {
    Name = "master-${var.k8s_name}"
  }
  
}


# Create Worker nodes for cluster
resource "aws_instance" "worker-node" {
  count = var.node_count
  ami           = var.ami["worker-node"] 
  instance_type = var.instance_type["worker-node"]
  key_name      = aws_key_pair.k8s_key.key_name
  associate_public_ip_address = true
  subnet_id = aws_subnet.cluster_subnet.id
  vpc_security_group_ids = [aws_security_group.worker_node.id]
  
  root_block_device {
    volume_type = "gp2"
    volume_size = 8

  }

  tags = {
    Name = "worker-node-${count.index}"
  }
  
}

# Define the host as an Ansible resource
resource "ansible_host" "master" {         ### ansible host details for master ###
  depends_on = [ aws_instance.master ]
  name = "controlplane"
  groups = ["master"]
  variables = {
    ansible_user = "ubuntu"
    ansible_host = aws_instance.master.public_ip
    ansible_ssh_private_key_file = "id_rsa"
    node_hostname = "master"
  }
}


# Define the host as an Ansible resource
resource "ansible_host" "worker" {                     ### ansible host details for workers ###
  depends_on = [ aws_instance.worker-node ]
  count = 2
  name = "worker-node-${count.index}"
  groups = ["workers"]
  variables = {
    ansible_user = "ubuntu"
    ansible_host = aws_instance.worker-node[count.index].public_ip
    ansible_ssh_private_key_file = "id_rsa"
    node_hostname = "worker-node-${count.index}"
  }
}


