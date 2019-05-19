# GetUserByEmailAndPassword package

  The script is to get the user's detail by given email and password from the database.
  
  In order to config the package properly, please download the file named "GetUserByEmailAndPassword.zip" from this folder.

  Moreover, you need to moditfy the content of the file according to the detail of your hosted database.
  
  There are several steps below which can help you to install the package properly to the AWS Lambda.
# Installation
  
### 1.Unzip the "getAllUser.zip" file
  
  After you unzip the file, you should have the following files from the zip file.
  
  1-1 config.json file
  
  1-2 main.js file
  
  1-3 node_modules folder
  
  1-4 package-lock.json file
  
  1-5 package.json file

### 2.In config.json file
  
  In config.json file, you need to modify the content according to the detail of AWS RDS instance and replace it with your own instance details.
  
  "dbhost" : YOUR ENDPOINT & PORT IN AWS RDS INSTANCE,
  
  "dbname" : YOUR INSTANCE NAME,
  
  "dbuser" : ROOT USER NAME,
  
  "dbpassword" : ROOT USER PASSWORD
  
### 3.Zip all the file from the previous zip file after making changes

### 4.Create a AWS Lambda function named "GetAllUser"

### 5.Upload the zip file into the AWS Lambda function 

### 6.Choose NodeJS as the compiling language.

### 7.Change the Handler from "index.handler" to "main.handler"

### 8.Deploy the AWS Lambda function to API Gateway

### 9.Add URL Query String parameters into th API with the following attributes

9.1 email

9.2 password

### 10. Modify the Body Mappin Template in Integration Request section

10-1 Set the content type to "Application/json"

10-2 Add the following code into the below block

{
    "email" : "$input.params('email')",
    "password" : "$input.params('password')"
}

### 11. Deploy the resource

# Tutorial resource

For more details on how to create AWS Lambda function and AWS API Gateway, please clink the links below

[Create AWS Lambda Function](https://docs.aws.amazon.com/en_us/lambda/latest/dg/getting-started.html)

[Deploy AWS API Gateway with AWS Lambda](https://docs.aws.amazon.com/en_us/apigateway/latest/developerguide/getting-started-with-lambda-integration.html)
