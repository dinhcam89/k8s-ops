# Create keypair
resource "aws_key_pair" "k8s_key" {
  key_name = var.key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDn1s0XP3CjT/qMt7Hld5bnBZKbxhoEA7hvjy/Z91QVSZ1BTfo9oFPqxsIUrUNWvJCZ8N7A7uIHCT5oo5/8ATbnRETronkyqxj4FGYRXoMM4UvfjvBpa4H5HQ/ud0/c8cmvzAq9zygaayynP2/ogR2e5Ci+smuHMpJ8Ccd5DLZLvRECADKZ77oCzJ+MghfowYZyrxM4c0C0/vMZsBazxYijT/+tl9AxCrwjilsBZZNzamYTBYfI7JSqddOXKUCPS4r1HUFRHajWjJs7js4pap/F/yPTL72s/tCum8pb2a9kHm5YpTQNfLYUUlkeF/eog+ieBOlkHrcD+NqKDKtlmv/Bv8NLfVVRXO36vR+XpAdnZJhKq45DeP0AAs/9RDhmdRbH40hehDoy+o06hHcLUhPY8+RvKqfRscB6WZtYhUqh9r5digmQ39kVTSFcl4CF8pSnPXIKk4gQ+MgOA1Rc7DNi2ramXDSsjUdim0Jau0wBD+3cwj7zHosYuT+56+DfKMNu2lZIJ9HGTh9h4RLfmnQ8eQ+aG4h7z9IkG/extW+yTk97nPGEBqft+XbfI0cuEWd6KE7GuEfsWZzutmM/H634iEv5/EC4Tm4wJmstX9/OFyyO6Xwc6lMGszaCf8FMxgHyxuza9D0hZNj9sASKqXqz6nm+U0Qbm65Iu9SJgxAu6w== cam@MSI"
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


