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
${COMPATIBILITY_TESTS_WIN_CHROME}       %{COMPATIBILITY_TESTS_WIN_CHROME=False}
${COMPATIBILITY_TESTS_WIN_FIREFOX}      %{COMPATIBILITY_TESTS_WIN_FIREFOX=False}
${COMPATIBILITY_TESTS_WIN_EDGE}         %{COMPATIBILITY_TESTS_WIN_EDGE=False}
${COMPATIBILITY_TESTS_OSX_SAFARI}       %{COMPATIBILITY_TESTS_OSX_SAFARI=False}

*** Keywords ***
Setup BrowserStack     # robocop: off=too-long-keyword,too-many-arguments,too-many-calls-in-keyword
    [Documentation]    Set up BrowserStack browser/session.
    IF    ${COMPATIBILITY_TESTS_WIN_CHROME}
        VAR    ${os}            ${OS_WIN}
        VAR    ${os_version}    ${OSVERSION_WIN}
        VAR    ${browser}       ${BROWSER_CHROME}
    ELSE IF    ${COMPATIBILITY_TESTS_WIN_FIREFOX}
        VAR    ${os}            ${OS_WIN}
        VAR    ${os_version}    ${OSVERSION_WIN}
        VAR    ${browser}       ${BROWSER_FIREFOX}
    ELSE IF    ${COMPATIBILITY_TESTS_WIN_EDGE}
        VAR    ${os}            ${OS_WIN}
        VAR    ${os_version}    ${OSVERSION_WIN}
        VAR    ${browser}       ${BROWSER_EDGE}
    ELSE IF    ${COMPATIBILITY_TESTS_OSX_SAFARI}
        VAR    ${os}            ${OS_X}
        VAR    ${os_version}    ${OSVERSION_X}
        VAR    ${browser}       ${BROWSER_SAFARI}
    END
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
