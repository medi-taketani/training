import boto3
    
ssm = boto3.client('ssm')

def lambda_handler(event, context):
    print("Hello Worldooonn")
    print(event)

    response = ssm.get_parameter(
        Name='taketani-ssm-params',
        WithDecryption=True
    )
    return response['Parameter']['Value']    
