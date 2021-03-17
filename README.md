# README

## Description

Notifications is a Microservice for send Push notifications and SMSs using AWS SNS 🚀

## Installation ⚙️
Clone the service Repo  
Enter the Repo Dir `cd /notifications`.  
Copy the enviroment variables to .env `cp .env.example .env`  

Feel free to edit the following variables in .env
```
SIDEKIQ_THREADS=10 Number of threads for sidekiq process  
SMS_LIMIT_PER_MINUTE=100 number of SMS messages processed per minute   
PUSH_LIMIT_PER_MINUTE=100  number of push notification messages processed per minute  
```

Run the service `docker-compose up`   
Create and migrate the database `docker-compose exec app rails db:create db:migrate`.  
Seed the database with mock user data `docker-compose exec app rails db:seed`

## Run Rspec Tests 🧪
`docker-compose exec -e RAILS_ENV=test app rspec`

## API Docs 📕
http://localhost:3000/api-docs/  
Basic Auth creds  
Username: username  
Password: password

## Service API Auth 🔓
Basic Auth creds  
Username: username  
Password: password

## Assumptions 🤔
* The database gets the user data from another service `mocked with seeds for testing`   
* We use AWS SNS to send SMSs and Push Notifications `mocked with localstack`

## Users filters 🚶‍♂️
filters are sent over notifications creation as json object, the filter is the key and the value is the query you want to filter the users with (example included in the swagger api docs)

feel free to use any of the following filters 
``` 
with_locale  
search_name_query  
search_email_query  
search_phone_query  
with_birthdate_before  
with_birthdate_after  
```

## Rate limiting 🏁
I use Sidekiq as the job background processor  
You can monitor the queue consuming through here  http://localhost:3000/sidekiq/queues   

Mainly we have three queues default, sms_notifications, push_notifications.
on Firing a noticiation we send a message over the default queue which handled by the NotificationWorker, then the NotificationWorker use the filter to get the targeted users, after that the NotificationWorker will dicide which channel the message should be published to, according to the notification channel type, if the message is sms message it will go to the SmsWorker, the NotificationWorker will iterate over the targeted users and push messages to the SmsWorker

Each one the channel queues has a limit over the queue.

## TODO
* Create a relation between notifications and users and save the delivery status
* Add More Tests


Kindly, feel free to contact me if you have any questions.
