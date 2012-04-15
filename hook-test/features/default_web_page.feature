Feature: apache
  In order to server content
  As an administrator of the website
  I would like there to be an apache server

Scenario: default web page
  Given I visit a page on the root domain
  Then I should see 'This is the default web page for this server.'

