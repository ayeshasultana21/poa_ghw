from percy import percy_screenshot
from robot.libraries.BuiltIn import BuiltIn


def take_full_page_screenshot(screenshot_name, resolutions, height):
    # Convert a list string to an int
    resolutions = [int(i) for i in resolutions]

    # get current driver instance for the snapshot
    selib = BuiltIn().get_library_instance("SeleniumLibrary")
    driver = selib.driver

    # take screenshot
    try:
        percy_screenshot(driver=driver,
                         name=screenshot_name)
        print("Screenshot might be taken")
    except Exception as e:
        print("Error taking percy screenshot")
        print(e)
