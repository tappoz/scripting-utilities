.terraform:
	terraform init

# -auto-approve
# terraform plan -var-file variables.tfvars
tf-apply: .terraform
	terraform apply -var-file variables.tfvars

# -auto-approve
tf-destroy:
	terraform destroy -var-file variables.tfvars .

tf-refresh:
	terraform refresh -var-file variables.tfvars .
