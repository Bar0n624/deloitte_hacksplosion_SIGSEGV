# Automated Order Processing System
## Problem statement: 
Processing email orders manually is a tedious and time-consuming process, prone to human errors and delays, which results in poor customer experience. This leads to a reduction in number of orders that could potentially be fulfilled. In the current day and age, it is of pivotal importance to integrate AI to assist with the automation process of repeatable tasks to boost productivity. 

## Our solution:
We are using Java mail for receiving orders by email, and sending confirmations or error notifications to users using RPA alongside it. Orders are validated against a product inventory database. After validation, an invoice is sent to the customer through email using RPA. All microservices are connected through Kafka and performance metrics are evaluated through a Grafana dashboard. 

## Implemented features:
- SMTP using Java mail. Emails can be sent, received, and read.
- Parser in Java that converts required information into a json string.
- A typo and partial-match checker to better represent real world constraints.
