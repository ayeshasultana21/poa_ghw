*** Settings ***
Documentation       A test suite dedicated to the login page.
Resource            ./bs_setup.resource
Resource            ./percy.resource
Library    SeleniumLibrary


*** Test Cases ***
Login Page Layout
    [Documentation]    Testing the Percy Google Homepage
    Setup BrowserStack
    Go To    http://www.google.com
    Maximize Browser Window
    RF Percy On Automate Screenshot    Google_Homepage
    [Teardown]    Close Browser
