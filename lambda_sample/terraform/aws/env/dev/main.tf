module "taketani_lambda"{
    source                              = "../../module/lambda/"
    source_file                         = "../../../../src/lambda_function.py"
    output_path                         = "../../../../src/lambda_function.zip"
    func_name                           = "taketa3"
    lambda_trigger_source_execution_arn = module.taketani_apigw.apigw_execution_arn
    environment = {
        TEST_VAR = "test"
    }
}

module "taketani_apigw"{
    source                        = "../../module/api_gateway/"
    apigw_name                    = "taketani-API"
    route_key                     = "POST /taketani"
    target_lambda_arn             = module.taketani_lambda.lambda_func_arn
    target_lambda_integration_uri = module.taketani_lambda.lambda_integration_uri
    description                   = "taketani api"      
}