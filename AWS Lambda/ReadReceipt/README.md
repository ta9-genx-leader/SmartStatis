# Read receipts
Function:
1. Use baidu-aip ocr library to analysis the image url
2. Select the food items from the image 
3. Suggest the recommended food storage length, food category and key words of the food item

# Development platform
  Python 3.6/AWS Lambda
# Application System
  IOS
# Database system
  MySQL
# Installation 
  1. Download ocrwithremove.zip and save it to your destination.
  2. Create a Lambda function on AWS
  3. Select the language as Python 3.6
  4. Upload ocrwithremove.zip file
  5. Change the handler name to the python script name and the function name in the zip file, lambda_funtion.lambda_handler
  6. Configure a test event
       {"url1":""}
# Python script Setting
   
   Change MySQL account 
   #rds settings
   rds_host  = " "
   name = " "
   password =" "
   db_name = " "
   
   Change baidu aip ocr account
   baidu aip library setting
   APP_ID = ' '
   API_KEY = ' '
   SECRET_KEY = ' '
   client = AipOcr(APP_ID, API_KEY, SECRET_KEY)
   



