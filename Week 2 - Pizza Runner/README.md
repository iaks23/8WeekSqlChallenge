# 8-Week SQL Challenge

# CASE STUDY #2 - PIZZA RUNNER 🍕

![picturelogo](https://github.com/iaks23/8WeekSqlChallenge/blob/main/img/W2.png)

## TABLE OF CONTENTS 📖
* [Who's Running? 🏃🏻‍♀️](#who's-running)
* [Problem Statement 🔨](#problem-statement)
* [Datasets 💻](#datasets)
* [Data Cleaning 🧹](#cleaning)
* [Case Study Solutions 🔑](#case-study-solutions)
* [Bonus Questions 💃🏻](#bonus-questions)




## Who's Running? 🏃🏻‍♀️ <a name="who's-running"></a>

Danny's back at it with yet another million dollar idea but this time it's with a worldwide favorite dish, the pizza.

Danny was scrolling through his Instagram feed when something really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.


## Problem Statement 🔨 <a name="problem-statement"></a>

Danny's aware of how essential data collection will be to his business, which is why he has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

Danny has shared with you 6 interconnected datasets for this case study:

---------------

* <code> customer_orders </code>
* <code> runner_orders </code>
* <code> runners </code>
* <code> pizza_names </code>
* <code> pizza_toppings </code>
* <code> pizza_recipes </code>

---------------

## Datasets 💻 <a name="datasets"></a>

Below is the entity relationship diagram of the datasets available with Danny.

![ER](https://github.com/iaks23/8WeekSqlChallenge/blob/main/img/ER.png)

For more information regarding the tables, their descriptions, and schema make sure to take a look [here](https://8weeksqlchallenge.com/case-study-2/)

## Data Cleaning 🧹 <a name="cleaning"></a>

Upon first glance, it is evident that we cannot dive headfirst into solving the queries without doing a little bit of grunt work. This calls for a little bit of data cleaning on the <code>customer_orders</code> table and the <code>runner_orders</code> table to transform the null values, unwanted suffixes, and even alter column types for easier data manipulation. 

I have tried tackling this in two ways...
