# Spree Ignitor Ipay88

This is a plugin which seamlessly integrates any Spree Commerce based application with Ipay88 payment gateway, a service widely used in South-East Asia. 

#### The following steps are involved
  - Including in the Gemfile of your Spree-based Rails application and running bundle installer
  -  Installing and running migrations
  -  Configuring merchant information *via* Admin interface on browser

We will take you through step by step process and to how to install the plugin and use it right away

#### Version
1.0

#### Requirements
Before installing this plugin, we assume that the merchant has registered with Ipay88 services hand has valid credentials. The merchant's request URL needs to be white-listed before hand. The format of the url would be ```your_url.com/gateway/ipay88/[:transaction_id]```  - TODO: Edit this to reflect the right url) -

#### Dependencies
The plugin supports

   - Spree 3.0.4
   - Rails 4.2

##### Note: This plugin is made in the form of a rails engine. 