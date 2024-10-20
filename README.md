
# **Automating Kubeadm cluster on AWS EC2: Terraform, Ansible, and GitHub Actions**



![image](https://github.com/Chenwingu/kubeadm-ec2-automate/blob/main/kubeadm-k8s-cluster.png)

# **Introduction**

Integrating Terraform and Ansible provides a powerful solution for infrastructure provisioning and management, enabling us to automate everything from hardware deployment to software installation.


# **Prerequisites**

**Local machine setup: Install and configure Git, Terraform, Ansible, and vscode.**

**IAM Role: Create a role in AWS IAM, with necessary permissions and access the role via secrets.AWS_ROLE construct.**

**GitHub repository secrets: You need to configure valid credentials.**

**Project structure: Arrange your project directories and files.**


# **Walk through** 

Add **ansible_host resource** in your terraform configurations as outlined [here](https://github.com/Chenwingu/kubeadm-ec2-automate/blob/main/cluster.tf)! 

Terraform and Ansible have to work together to generate the **inventory file**. Use this [workflows](https://github.com/Chenwingu/kubeadm-ec2-automate/blob/main/.github/workflows/kubernetes.yml) as a guide.

This **inventory file** can be generate with some available **plugins** or alternatively with Terraform's **templatefile** function.


Check out the sample project tutorial in the [Link](https://medium.com/@chenwingu/automating-kubeadm-cluster-on-ec2-terraform-ansible-github-actions-be847ca8e4a2)

