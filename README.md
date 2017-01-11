# roku-gamp
Google Analytics Measurement Protocol for Roku Brightscript


# roku-gamp Setup

## SDK1 (non-SceneGraph)

Copy the following 3 files into your channel tree:

* [source/googleAnalytics.brs](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/source/googleAnalytics.brs)
* [source/common/generalUtils.brs](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/source/common/generalUtils.brs)
* [source/common/url.brs](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/source/common/url.brs)

Look at [main.brs](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/source/main.brs#L56) for example SDK1 usage.

## SceneGraph

Scene graph uses a Task node to wrap the SDK1 sources.

Copy the following 4 files into your channel tree:

* [components/GampTask.xml](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/components/GampTask.xml)
* [source/googleAnalytics.brs](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/source/googleAnalytics.brs)
* [source/common/generalUtils.brs](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/source/common/generalUtils.brs)
* [source/common/url.brs](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/source/common/url.brs)

Look at [GampScene.xml](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/components/GampScene.xml) for example SceneGraph usage.


# Google Analytics Service Setup

Log in to your [Google Analytics account](https://analytics.google.com/analytics/web) and navigate to the "Admin" tab.

Under the "Account" drop down, select "Create new account".

Select "Mobile app" for "What would you like to track". Fill in the other fields as appropriate. Get the tracking id and set it as the `gamobile_tracking_ids`.

Back in Google Analytics, under the tracking info section, select "User-ID". Read and agree to the tracking policy. Follow the prompts to set up a view using the User ID.


# Running the Example Channel

### Get and install the example channel:

    $ git clone https://github.com/cdthompson/roku-gamp.git
    $ cd roku-gamp/roku-gamp
    $ make ROKU_DEV_TARGET=192.168.0.100 DEVPASSWORD=passw0rd install

### Watch the Roku debug console:

    $ telnet 192.168.0.100 8085

Expected output should be:

    ------ Compiling dev 'roku-gamp' ------

    ------ Running dev 'roku-gamp' main ------
    Enabling tracking analytics
    Analytics:Screen: Home
    Analytics:Event: Registration/Complete
    Analytics:Exception:
    Analytics:Transaction: Purchase-Code

### Run the unit tests

    $ curl -d '' "http://${ROKU_DEV_TARGET}:8060/launch/dev?RunTests=true"
    
Expected output should look like:

    ******************************************************************
    ******************************************************************
    *************            Start testing               *************
    ******************************************************************
    ***   GoogleAnalyticsTestSuite: initializeSingleTIDString - Success
    ***   GoogleAnalyticsTestSuite: initializeSingleTIDroString - Fail
    ***   GoogleAnalyticsTestSuite: initializeMultipleTID - Success
    ***   GoogleAnalyticsTestSuite: sendHit - Success
    ***
    ***   Total  = 4 ; Passed  =  3 ; Failed   =  1 ; Crashes  =  0 Time spent:  1004ms
    ***
    ******************************************************************
    *************             End testing                *************
    ******************************************************************
    ******************************************************************

# License
roku-gamp is released under the MIT License.  See LICENSE file.
