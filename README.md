# chrome-python-aws-lambda

This project is to create a Docker image for run Chrome in a AWS Lambda function.

## Run Docker

### Build

    docker build -t chromepythonawslambda:latest .

### Run

    docker run -p 9000:8080 --user apps --privileged chromepythonawslambda:latest

### Test it

    curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
