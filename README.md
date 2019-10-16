# SmartStatis
  Smartstais aims to provide a sustainable way of life for Australian by increasing their awareness of food waste and avioding unecessary expense on shopping. It enables users to have a better management on their food storage and shopping list.
  
[![Watch the video](https://i.imgur.com/cYQJDpQ.jpg)](https://www.youtube.com/watch?v=Dt17HNwzNXQ)

Function:

* Manage food in the current storage (Fridge/Freezer/Pantry).
* Record food purchased from supermarkets by scanning the receipts.
* Add Food with user input.
* Suggest the recommended food storage length based on open data.
* Notify user the condition of stored food and the length of expiry date.
* Help users to manage shopping list.
* Help users to calculate the amount of money wasted on the expired food.
* Search corresponding recipes for the stored food.
# Iteration function
### Iteration 1: 

  * Manage food in the current storage (Fridge/Freezer/Pantry).
  
  * Record food purchased from supermarkets by scanning the receipts.
  
  * Add Food with the user inputs.
  
  * Suggest the recommended food storage length based on open data. 
   
  * Notify the user the condition of stored food and the length of expiry date.
   
  
### Iteration 2:

  * Help the users to manage shopping list.
  
  * Search corresponding recipes for the stored food.
   
  
### Iteration 3:

  * Help the users to calculate the amount of money wasted on the expired food.
   
  * Help the users to find the videos of recipes with their given ingredients.
   
  * Help the users to track the history for what they consume and what they waste from food.
   
  * Help the users to acquire information for the average food waste generated by the australian households.
   
  * Notify the users about the progress of food waste with the comparison of the information from previous months.
   
  * Create a function that the user can choose what time they prefer to receive push notifications.
  
# Development platform
  Xcode/Swift
# Application System
  IOS
# Server platform
  Amazon AWS Lambda function/Amazon AWS API Gateway
# Database system
  MySQL
# Installation 
  1. Download Xcode from APP store
  2. Download the SmartStatis project and save it to your destination.
  3. Open the downloaded project file named SmartStatis.xcodeproj in Xcode.
  4. Select a simulator/plug your iphon as your simulator destination.
  5. Click the Launch button to build the project on your destination.
# Version Control
  v2.0 Update informatio button in GuestView
  
  v2.1 Replace WKWebView with Youtube library
  
  v2.2 Create Recipe search Section
  
  v2.3 Default report section
  
  v3.0 Report section completed
  
  v3.1 UI design changed.
  
  v3.2 Algoriths for receipts changed

  v3.3 Add Timeout functions for Https response
  
  v3.4 UI design improved
# Future feature

  ### 1. Login view and Registration view
  
  As we attempt to not require the user's information at the first stage when we introduce Smartstatis, the Login view and Registration view are not added yet. However, in order to provide the better services to the users, creating a login view and a registration view can be beneficial. In order to integrate the login view and the registration view into the Smartstatis project, the developer must consider how to integrate the new features with the existing function. It is better that the developers integrate the login function and the registration function with the GuestViewController which is the first view representing to the users. Please refer to the following link for more information about GusetViewController.

[GuestViewController](https://github.com/ta9-genx-leader/SmartStatis/blob/master/Final/SmartStatis/SmartStatis/Main/GuestViewController.swift)

### 2. Multiple selection of ingredients to search for recipes video from the food storage
As the current project simple allows the user to search for recipes by single selection of the particular ingredient, this can be improvded by introducing the functions that the users can select multiple ingredients from their food storage to search for the ideal recipe video so that the users can then gain more ideas on how to consume those ingredients which are about to be expired.

In order to realize this idea, it is better that the developers can integrate the current function located in HomePageController as this is the class which manages the logic for ingredient selection. Please refer to the following link for more information about HomePageController.

In order to realize this idea, it is better that the developers can integrate the current function located in HomePageController as this is the class which manages the logic for ingredient selection. Please refer to the following link for more information about HomePageController.

[HomePageController](https://github.com/ta9-genx-leader/SmartStatis/blob/master/Final/SmartStatis/SmartStatis/Main/HomePageController.swift)

