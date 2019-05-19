# ReadReceipts

ocrwithremove.zip contains a python script, baidu aip library, pymysql library which could run on AWS Lambda to read receipt image.

Function:
1. Use baidu-aip ocr library to analysis the image url
2. Select the food items from the image 
3. Suggest the recommended food storage length, food category and key words of the food item

# Development platform
  Python 3.6/AWS Lambda
# Database system
  MySQL
# Library required
  baidu-aip
  
  pymysql
  
  requests
  
  time
  
# Installation 
  1. Download ocrwithremove.zip and save it to your destination.
  2. Create a Lambda function on AWS
  3. Select the language as Python 3.6
  4. Upload ocrwithremove.zip file
  5. Change the handler name to the python script name and the function name, lambda_funtion.lambda_handler
  7. Change the Basic setting, set Timeout as 3 mins
  8. Configure a test event
   
       {"url1": "https://upload.wikimedia.org/wikipedia/commons/1/13/Receipt-woolworth.jpg",
       
        "uid": 123}
       
# Python script Setting
   
   Change MySQL account 
   rds_host  = YOUR ENDPOINT & PORT IN AWS RDS INSTANCE,
   
   name = ROOT USER NAME
   
   password =ROOT USER PASSWORD
   
   db_name = YOUR INSTANCE NAME
   
   
   Change baidu aip ocr account
   
   baidu aip library setting
   
   APP_ID = YOUR BAIDU-AIP ID
   
   API_KEY = YOUR BAIDU-AIP KEY
   
   SECRET_KEY = YOUR BAIDU-AIP SECRET KEY
   
   client = AipOcr(APP_ID, API_KEY, SECRET_KEY)
   
   
   

# Example of output 
  use url link "https://upload.wikimedia.org/wikipedia/commons/1/13/Receipt-woolworth.jpg"
  
  [
  {
    "Item": " wWW SANDWICH CLASSIC EGG LETTUCE",
    "price": 6,
    "expiry days": 6,
    "keyword": "sandwich egg lettuce",
    "category": "vegetable"
  },
  {
    "Item": " APPLE PINK LADY",
    "price": 0.85,
    "keyword": "apple",
    "expiry days": 5,
    "category": "fruit"
  },
  {
    "Item": " MACRO ORGANC FRESH MILK LOW FAT 1L",
    "price": 2.2,
    "expiry days": 8,
    "keyword": "milk fat",
    "category": "dairy"
  },
  {
    "Item": " BANANA CAVENDISH",
    "price": 1.43,
    "keyword": "banana",
    "expiry days": 5,
    "category": "fruit"
  }
]

