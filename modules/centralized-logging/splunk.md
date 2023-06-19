# Splunk sink example

The solution helps you set up a log-streaming pipeline from Stackdriver Logging to Splunk.

## Instructions

1. Enable the Splunk Logging by setting the variable `create_splunk_logs_export` to `true`.

1. Run the Terraform automation:
    ```terraform
    terraform init
    terraform apply
    ```
    You should see similar outputs as the following:
    ```bash
    Outputs
    pubsub_subscripter_splunk = "splunk-folder-subscriber@central-logging-4cc7.iam.gserviceaccount.com"
    pubsub_subscription_name_splunk = "projects/central-logging-4cc7/subscriptions/splunk-folder-subscription"
    pubsub_topic_name_splunk = "projects/central-logging-4cc7/topics/splunk-folder"
    ```

1. In the GCP console, under `IAM > Service Accounts`, find the Pub/Sub subscriber service account and create a set of JSON credentials.

1. Go to your `Splunk` web console. On the left panel, click on the big `+` squared box:

    ![screen shot 2019-01-25 at 1 28 10 pm](https://user-images.githubusercontent.com/9629314/51768142-170e0c00-20a5-11e9-9190-eac68a057e86.png)

1. Search for the `Google Cloud Platform` add-on and install it.

    ![screen shot 2019-01-25 at 1 30 00 pm](https://user-images.githubusercontent.com/9629314/51768246-65bba600-20a5-11e9-829f-2feae4f295dd.png)

    *Note: you might need to restart your Splunk instance after the installation.*

1. Click on the add-on tile and navigate to the `Configuration` tab. Under the `Google Credentials` menu item, click on `Add Credential`.

    ![screen shot 2019-01-25 at 1 34 16 pm](https://user-images.githubusercontent.com/9629314/51768443-f72b1800-20a5-11e9-955c-4c3ae6952e7f.png)

1. Copy the content of the downloaded JSON file to the popup window:

    ![screen shot 2019-01-25 at 1 37 17 pm](https://user-images.githubusercontent.com/9629314/51768595-5c7f0900-20a6-11e9-9135-d28fa4fbff20.png)

1. Switch to the `Inputs` tab, and click on `Create New Input` and select `Cloud Pub/Sub`.

1. Fill the required values from the Terraform outputs, and click `Add`:

    ![screen shot 2019-01-25 at 1 39 16 pm](https://user-images.githubusercontent.com/9629314/51768687-a1a33b00-20a6-11e9-9871-b4b6c97f29bb.png)

    *Note: If you have lost the Terraform outputs, simply run `terraform output` in this directory to see them again.*

1. Switch to the `Search` tab. You should see that Splunk ingested some events:

    ![screen shot 2019-01-25 at 1 42 25 pm](https://user-images.githubusercontent.com/9629314/51768902-33ab4380-20a7-11e9-8f91-22d4eed777e7.png)

1. **Congratulations !** Your Stackdriver-to-Splunk logging pipeline is up and running !

<!-- BEGIN TFDOC -->

<!-- END TFDOC -->