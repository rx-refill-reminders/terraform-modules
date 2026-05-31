resource "terraform_data" "aws_tags" {
    input = {
        project   = var.project
        component = var.component
        stack     = var.stack
    }
}
