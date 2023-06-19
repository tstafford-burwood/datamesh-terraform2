# Application Integrations

## Reference Architecture

![](../../../docs/concept-application-integration.png)

Google's Application Integration service is used to help facilitate the approval process for Data Stewards. Services outside of Application Integration, like Cloud Functions, Cloud Composer DAGs, and Pub/Sub are all created with Infrastructure as Code.

### New Research Initiative

As of March 1, 2023, there isn't an a Terraform resource block to perform updates to the Application Integration. Instead, this must be done manually and after a new researcher initiative has been deployed.

#### Example

![](../../../docs/google_screen_recording_2023-02-28T16-02_41.109Z.gif)

Below are the steps of deploying a new researcher initiative that's labeled `final-validation1`.

1. Launch Application Integration from the `Data-Ops` project.
1. Click on an existing Application Integration .
1. Create a new version.
1. From the <b>Task/Trigger</b> optoin, select a new Approval, and 2 Cloud Functions.
1. Hightlight one of the Cloud Functions.
    1. Rename the function: `CF Delete Files`
    1. Use gcloud to find the URL link and past it in.
1. Highlight the second Cloud Function.
    1. Rename the function: `CF Move Files`
    1. Use gcloud to find the second URL link and past it in.
1. Connect the new Approval to the 2 Cloud Functions.
    1. Highlight one of the linkes and edit.
    1. Find the condition and update: ```$`Task_20_isApproved`$ = false```
    1. Hightlight the other link and edit.
    1. Find the condition and update: ```$`Task_20_isApproved`$ = true```
    1. Rename both links accordingly
1. Highlit the Approval and update.
    1. Change the Recipients. These are the email addresses that will recieve the approval email. Emails should be that of the Data Stewards.
    1. Under <b>Custom Notification</b> and the `message` variable.
1. Link the <b>initiative-data-mapper</b> with the new Approval function.
    1. Edit the link and under condition enter: ```$initiative$ = "final_validation1"```
    >**Note:** the initiative can be found in the description of each Cloud Function.