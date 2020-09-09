variable "source_file" {
    default = ""
}

variable "output_path" {
    default = ""
}

variable "func_name" {
    default = ""
}

variable "lambda_trigger_source_execution_arn" {
    default = ""
}

variable "environment" {
    type    = map
    default = {}
}