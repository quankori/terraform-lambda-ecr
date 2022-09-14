resource "aws_ecr_repository" "repo" {
  name = local.ecr_repository_name
}

# The null_resource resource implements the standard resource lifecycle 
# but takes no further action.

# The triggers argument allows specifying an arbitrary set of values that, 
# when changed, will cause the resource to be replaced.

resource "null_resource" "ecr_image" {
  triggers = {
    python_file = md5(file("${path.module}/${local.app_dir}/app.py"))
    docker_file = md5(file("${path.module}/${local.app_dir}/Dockerfile"))
  }

  # The local-exec provisioner invokes a local executable after a resource is created. 
  # This invokes a process on the machine running Terraform, not on the resource. 
  # path.module: the filesystem path of the module where the expression is placed.

  provisioner "local-exec" {
    command = <<EOF
           aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com
           cd ${path.module}/${local.app_dir}
           docker build -t ${aws_ecr_repository.repo.repository_url}:${local.ecr_image_tag} .
           docker push ${aws_ecr_repository.repo.repository_url}:${local.ecr_image_tag}
       EOF
  }
}

data "aws_ecr_image" "lambda_image" {
  depends_on = [
    null_resource.ecr_image
  ]
  repository_name = local.ecr_repository_name
  image_tag       = local.ecr_image_tag
}
