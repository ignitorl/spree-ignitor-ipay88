# Spree Ignitor Ipay88

# UNDER DEVELOPMENT
This is a plugin which seamlessly integrates any Spree Commerce based application with Ipay88 payment gateway, a service widely used in South-East Asia. 

#### The following steps are involved
  - Including in the Gemfile of your Spree-based Rails application and running bundle installer
  -  Installing and running migrations
  -  Configuring merchant information *via* Admin interface on browser

We will take you through step by step process and to how to install the plugin and use it right away

#### Version
1.0

#### Requirements
Before installing this plugin, we assume that the merchant has registered with Ipay88 services hand has valid credentials. The merchant's request URL needs to be white-listed before hand. The format of the url would be ```your_url.com/gateway/:order_id/ipay88/:payment_method_id``` 

##### Note: This plugin is made in the form of a rails engine. 

## Installation

  - Include it in your gem file ```gem 'spree_ignitor_ipay88', git:"https://github.com/ignitorl/spree-ignitor-ipay88.git"```
  - Run ```bundle install```
  - Copy the migrations into your application ```rake spree_ignitor_ipay88:install:migrations```
  - Run the migrations ```rake db:migrate```
  - Restart the server

## Configuration
  - Login to your Spree-based application with Administrator account. 
  - Open the Configurations > Payment Methods > New Payment Method page
  - Select the **Spree::Ipay88::PaymentMethod** as *Provider*, **Both** as *Display*, **Yes** as *Auto Capture* and **Yes** as *Active* setting. Then enter a suitable name (preferably *Ipay88 *) and press *Create* button
  - It automatically takes you to 'Edit' page where you will have to enter your *Merchant Code* and *Merchant Key* which are provided by Ipay88
  - Press *Update* and you are good to go.

## Frontend
  - Whenever the customer goes to checkout page, they should be presented with available payment gateways.
  - When they select *Ipay88*, and press * Save and Continue *, they shall be redirected to a 'Confirmation' page where Order Amount and Payment Infomration is presented. 
  - In addition they will be asked to enter their Name, Email and Contact Number which are mandatory fields.
  - The user then confirms and places order. They shall be redirected to Ipay88 payment page. 
  - After successfully completing the payment, they shall be redirected back to your application page with a success message

## Dependencies
The plugin supports

  - Spree 3.0.4
  - Rails 4.2

## Notes
  - Gems that are sourced from Github won't update automatically when you do a ```bundle install```. So in our case you have to ```bundle update spree_ignitor_ipay88`` in order to be in sync wih the current master branch

## Credits
Developed by Edutor Technologies to support their Ignitor store platform built on Spree.

##### Key contributors:  
  - Sriharsha Chintalapati 
  - Dilip Reddy

## License
Copyright© 2016 Edutor Technologies, Hyderabad, India released under **MIT License**
