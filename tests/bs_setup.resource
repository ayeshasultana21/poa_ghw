*** Settings ***
Documentation    Suite dedicated for compatibility setup handling.
Library     OperatingSystem
Library     SeleniumLibrary


*** Variables ***
${OS_WIN}                   Windows
${OS_X}                     OS X
${OSVERSION_WIN}            10
${OSVERSION_X}              Ventura
${BROWSER_CHROME}           Chrome
${BROWSERVERSION}           latest
${BROWSER_RESOLUTION}       1920x1080
${BROWSERSTACK_IDENTIFIER}        poa_ghw


*** Keywords ***
Setup BrowserStack     # robocop: off=too-long-keyword,too-many-arguments,too-many-calls-in-keyword
    [Documentation]    Set up BrowserStack browser/session.
    VAR    ${os}            ${OS_WIN}
    VAR    ${os_version}    ${OSVERSION_WIN}
    VAR    ${browser}       ${BROWSER_CHROME}
    VAR    ${browserstackUserName}     %{BROWSERSTACK_USERNAME}
    VAR    ${browserstackAccessKey}    %{BROWSERSTACK_ACCESS_KEY}
    VAR    ${buildName}                %{BROWSERSTACK_BUILD_NAME}
    VAR    ${browserResolution}        ${BROWSER_RESOLUTION}
    VAR    ${identifier}               ${BROWSERSTACK_IDENTIFIER}

    ${bstack_options}=    Create Dictionary    os=${os}    osVersion=${os_version}    browser=${browser}
    ...    browserVersion=${browser_version}    local=true    localIdentifier=${identifier}
    ...    buildName=${buildName}    projectName=ca-integration-kit
    ...    resolution=${browserResolution}    userName=${browserstackUserName}
    ...    accessKey=${browserstackAccessKey}    maskCommands=setValues    timezone=Brunei

    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    set_capability    bstack:options    ${bstack_options}

    ${executor}=    Set Variable    https://hub.browserstack.com/wd/hub
    Create Webdriver    Remote    command_executor=${executor}    options=${options}
