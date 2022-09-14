# Serverless AWS

## Requirements

- AWS CLI

## Create lambda function

- Create new function in lambda function aws
- Run script build and zip
- Deploy code to lambda function

```bash
aws lambda update-function-code --function-name users_list --zip-file fileb://./main.zip
```

- Check again code on lambda function

```bash
aws lambda invoke --function-name users_list response.json --region us-east-2
```

## Query lambda function

```go
import (
	"github.com/aws/aws-lambda-go/lambda"
    "github.com/aws/aws-lambda-go/events"
)
```

- Response

```go
func list() (events.APIGatewayProxyResponse, error) {

    return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(res),
	}, nil
}
```

- Get detail

```go
func detail() (events.APIGatewayProxyResponse, error) {
	id, err := strconv.Atoi(req.PathParameters["id"])

	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       err.Error(),
		}, nil
	}

    // Log id
    fmt.Println(id)

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(res),
	}, nil
}
```

- Create

```go
func create(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	err := json.Unmarshal([]byte(req.Body), &book)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       err.Error(),
		}, nil
	}

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(res),
	}, nil
}

```

## Config API Gateway

- Create new API in API Gateway
- Create new resource
- Create API Get and deploy API
