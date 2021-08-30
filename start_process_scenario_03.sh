#!/bin/bash

echo "Scenario 3: User Task 1 --> Message --> User Task 2 --> End + User Task 2A --> End"

echo Message Event Process: Start Process
curl --location --request POST 'http://localhost:8080/rest/message' --header 'Content-Type: application/json' --data-raw '{
     "messageName": "message-start-event",
     "businessKey": "process-key-123"
}'

sleep 5

echo Message Event Process: Complete User Task 1
IP=$(curl --location --fail --silent --request POST 'http://localhost:8080/rest/task' --header 'Content-Type: application/json' --data-raw '{ "processInstanceBusinessKey": "process-key-123", "taskDefinitionKey": "user-task-1"}' | jq -r '.[0].id')

curl --location --fail --silent --request POST "http://localhost:8080/rest/task/$IP/complete" --header 'Content-Type: application/json'

sleep 5

echo Message Event Process: Recieve Message
curl --location --request POST 'http://localhost:8080/rest/message' --header 'Content-Type: application/json' --data-raw '{
     "messageName": "message-intermediate-catch-event",
     "businessKey": "process-key-123"
}'

sleep 5

echo Message Event Process: Interrupting User Task 2
curl --location --request POST 'http://localhost:8080/rest/message' --header 'Content-Type: application/json' --data-raw '{
     "messageName": "message-boundary-event-non-interrupting",
     "businessKey": "process-key-123"
}'

sleep 5

echo Message Event Process: Complete User Task 2
IP=$(curl --location --fail --silent --request POST 'http://localhost:8080/rest/task' --header 'Content-Type: application/json' --data-raw '{ "processInstanceBusinessKey": "process-key-123", "taskDefinitionKey": "user-task-2"}' | jq -r '.[0].id')

curl --location --fail --silent --request POST "http://localhost:8080/rest/task/$IP/complete" --header 'Content-Type: application/json'

sleep 5

echo Message Event Process: Complete User Task 2A
IP=$(curl --location --fail --silent --request POST 'http://localhost:8080/rest/task' --header 'Content-Type: application/json' --data-raw '{ "processInstanceBusinessKey": "process-key-123", "taskDefinitionKey": "user-task-2a"}' | jq -r '.[0].id')

curl --location --fail --silent --request POST "http://localhost:8080/rest/task/$IP/complete" --header 'Content-Type: application/json'