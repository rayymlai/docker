# RabbitMQ Server: User Guide 
Updated: Jul 28, 2016

This RabbitMQ dockerfile is from the official RabbitMQ distribution.
the startup script will generate admin password under the folder  /etc/rabbitmq/rabbitmq.config of the docker container.

# What's New
* Sample configuration guide

# Features
* Start single node RabbitMQ server in seconds
* Support all RabbitMQ integration models, e.g. hub-spoke, pub-sub

# Pre-requisites
* Create enough disk space (e.g. 100GB for demo use) under /mnt/data/mq, which can be a mounted block storage volume.
* Create the following subfolders
```
cd /mnt/data
sudo mkdir -p /mnt/data/mq/mq01/log01
```

# How to start RabbitMQ server
```
docker run --hostname mq.ourhome.com --name rmq01 -d -v /mnt/data/mq/mq01/log01:/data/log -v /mnt/data/mq/mq01:/data/mnesia -p 4201:15672 -p 4202:25672 -p 4203:4369 -p 4204:5672 rayymlai/rabbitmq
```

# How to launch RabbitMQ admin console

# Sample Configuration Guide
In order to use RabbitMQ server, you may want to perform the following server admin tasks:
* Change server password.
  - From docker host, issue the command "docker exec -ti rmq01 bash" to enter into the RabbitMQ command prompt.  You can view the admin password from the file /etc/rabbitmq/rabbitmq.config.
  - Open a Web browser to login to the RabbitMQ admin console, e.g. http://dockerhost.ourhome.com:4201 with the user id "admin" and the password you got from /etc/rabbitmq/rabbitmq.config.
  - Upon successful login, select Admin, click the user 'admin', and then "update user" to change the admin password.
* If you want to use the exchange model fir workflow or advanced message processing, you can select Exchanges | Add a new exchange, and create an exchange using the virtual host "/" (for production use).
  - Exchange model can route and process messages by topic names. For instance, whenever you publish social media feeds or contents regarding a specific stock, you would like to trigger market sentiment analysis (e.g. if we should buy or sell the stock if the market sentiment is very negative). Such a requirement would need workflow model to trigger custom message processes (e.g. sentiment analysis) depending on the message content type (e.g. stock symbol = xxx).
  - Sample scenario: you want to set up an exchange called "searchQueries", which can handle different data content types such as "socialMedia", "financialStatementFootnotes", "shareholderMeetingTranscripts" where you can analyze market sentiments. 
  - First, you create an exchange called "searchQueries" with type=topic, durability=Durable.
  - Second, you select Queues and create 3 queues for "socialMedia", "financialStatementFootnotes", "shareholderMeetingTranscripts". Each queue has virtual host="/" and durability=Durable. These queues will store messages for custom business processing (to be defined separately).
  - Third, you go back to edit the exchange "searchQueries" | Bindings, and create mapping topic names to the queues defined above. If you do not define queue binding, RabbitMQ will create anonymous queue names automatically, which will not be purged automatically (impact on storage). For example, you can create binding for "to queue" = "socialMedia" mapped to a routing key (aka topic name) "stock.socialMedia". You can customize your RabbitMQ client subscribe to this topic name "stock.socialMedia" to perform sentiment analysis. 

