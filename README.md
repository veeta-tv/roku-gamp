# NOTE!!  This library is deprecated.

Oct 18, 2017 Roku announced native support for Google Analytics on their [developer blog](https://blog.roku.com/developer/roku-analytics-component).  As a result, this library will no longer be maintained.

See [Roku Analytics Component](https://sdkdocs.roku.com/display/sdkdoc/Roku+Analytics+Component).


-----

# roku-gamp
Google Analytics Measurement Protocol for Roku Brightscript


# roku-gamp Setup

## SDK1 (non-SceneGraph)

Copy the following file into your channel tree:

* [source/googleAnalytics.brs](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/source/googleAnalytics.brs)

Look at [main.brs](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/source/main.brs#L56) for example SDK1 usage.

## SceneGraph

Scene graph uses a Task node to wrap the SDK1 sources.

Copy the following 2 files into your channel tree:

* [components/GampTask.xml](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/components/GampTask.xml)
* [source/googleAnalytics.brs](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/source/googleAnalytics.brs)

Look at [GampScene.xml](https://github.com/veeta-tv/roku-gamp/blob/master/roku-gamp/components/GampScene.xml) for example SceneGraph usage.


# Google Analytics Service Setup

Log in to your [Google Analytics account](https://analytics.google.com/analytics/web) and navigate to the "Admin" tab.

Under the "Account" drop down, select "Create new account".

Select "Mobile app" for "What would you like to track". Fill in the other fields as appropriate. Get the tracking id and set it as the `gamobile_tracking_ids`.

Back in Google Analytics, under the tracking info section, select "User-ID". Read and agree to the tracking policy. Follow the prompts to set up a view using the User ID.


# Running the Example Channel

### Makefile environment:

Substitute appropriate Roku device IP address and developer password here

    $ export ROKU_DEV_TARGET=192.168.0.100
    $ export DEVPASSWORD=passw0rd

### Run SDK1 example:

    $ make -C roku-gamp install

Expected console output should be:

    ------ Compiling dev 'roku-gamp' ------

    ------ Running dev 'roku-gamp' main ------
    Enabling tracking analytics
    [GA] Screen: Home
    ...

### Run SceneGraph example:

    $ make -C roku-gamp scenegraph

Expected console output should be:

    ------ Running dev 'roku-gamp' main ------
    Running SceneGraph example
    GampTask.init
    GampScene.init
    GampTask.execGampLoop
    ...

### Run the unit tests:

    $ make -C roku-gamp test
    
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
