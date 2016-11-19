# roku-gamp
Google Analytics Measurement Protocol for Roku Brightscript

[googleAnalytics.brs](https://github.com/cdthompson/roku-gamp/blob/master/roku-gamp/source/googleAnalytics.brs) contains the interesting sources.  It requires url.brs and generalUtils.brs from the Roku SDK.


# Google Analytics Set-Up

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


# License
roku-gamp is released under the MIT License.  See LICENSE file.
