*** Settings ***
Documentation       Resource file for Percy on Automate

Library             ./percy_library.py


*** Variables ***
@{RESOLUTIONS}                          1920
${PERCY_MAX_PAGE_HEIGHT}                2000
${WAIT_TIME_5S}                         5


*** Keywords ***
RF Percy On Automate Screenshot
    [Documentation]    A keyword to Percy on automate screenshot for Percy Visual Testing.
    [Arguments]    ${screenshot_area}
    # Wait Until Page Contains Element    ${locator}    ${wait_time}

    ${screenshot_name}=    Set Variable    ${TEST NAME}_${screenshot_area}
    Log    "TakingScreenshot..."
    Take Full Page Screenshot    ${screenshot_name}    ${resolutions}    ${PERCY_MAX_PAGE_HEIGHT}
