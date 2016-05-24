# roku-gamp
Google Analytics Measurement Protocol for Roku Brightscript

It's recommended that implementers create a [Mobile Analytics](https://www.google.com/analytics/mobile/) account to capture data rather than a web site.

Requires URLEncode helper method in url.brs from the Roku SDK. A copy from the SDK has been included herein to make a complete example app.

# Google Analytics Set-Up

Log in to your [Google Analytics account](https://analytics.google.com/analytics/web) and navigate to the "Admin" tab.

Under the "Account" drop down, select "Create new account".

Select "Mobile app" for "What would you like to track". Fill in the other fields as appropriate. Get the tracking id and set it as the `gamobile_tracking_id`.

Back in Google Analytics, under the tracking info section, select "User-ID". Read and agree to the tracking policy. Follow the prompts to set up a view using the User ID.

# License
roku-gamp is released under the MIT License.  See LICENSE file.
