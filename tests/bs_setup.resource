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
${BROWSER_FIREFOX}          Firefox
${BROWSER_EDGE}             Edge
${BROWSER_SAFARI}           Safari
${BROWSERVERSION}           latest
# Careful when changing the resolution to a new one. Browser Stack has only several resolutions they support
${BROWSER_RESOLUTION}       1920x1080    # most popular browser size by our production users according to mode report
${BROWSERSTACK_IDENTIFIER}        compatibility_tests


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
    # ${result}=    Run Keyword And Ignore Error    Create Webdriver    Remote    command_executor=${executor}    options=${options}
    # Run Keyword If    '${result[0]}' == 'FAIL'    Log    WebDriver creation failed: ${result[1]}    level=ERROR
    Set Session Name    ${TEST NAME}

Set Session Name
    [Arguments]    ${session_name}
    [Documentation]    Add session name in BS automate dashboard.
    ${test_name_dict}=    Create Dictionary    name=${session_name}
    ${executor_object}=    Create Dictionary    action=setSessionName    arguments=${test_name_dict}
    ${json_executor_object}=    Evaluate    json.dumps(${executor_object})    modules=json
    ${browserstack_executor}=    Set Variable    browserstack_executor: ${json_executor_object}
    Execute Javascript    ${browserstack_executor}


Set Session Status And Close Browser
    [Documentation]    Set session status in BrowserStack dashboard.
    ${reason}=    Get Reason Based On Status
    ${status}=    Get Status Based On Status
    ${status_dict}=    Create Dictionary    status=${status}    reason=${reason}
    ${executor_object}=    Create Dictionary    action=setSessionStatus    arguments=${status_dict}
    ${json_executor_object}=    Evaluate    json.dumps(${executor_object})    modules=json
    ${browserstack_executor}=    Set Variable    browserstack_executor: ${json_executor_object}
    Execute Javascript    ${browserstack_executor}
    Close Browser


Get Reason Based On Status
    [Documentation]    Returns test status message.
    IF    '${TEST STATUS}' == 'PASS'
        RETURN    Test Passed
    ELSE
        RETURN    ${TEST MESSAGE}
    END

Get Status Based On Status
    [Documentation]    Returns PASSED/FAILED based on test status.
    IF    '${TEST STATUS}' == 'PASS'
        RETURN    PASSED
    ELSE
        RETURN    FAILED
    END