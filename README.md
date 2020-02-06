## Introduction

This sample Ballerina app provide you a basic understanding about how to use Ballerina gmail and spreadsheet connectors. Here we implemented a simple bot type of use case. We have a shop where it receives large number of emails from customer in daily basis. The shop owner does not have enough number of people to assign to manually reply to those custom queries. Instead he is going to have this app which will automatically send replies according to customer requirements.

#### This app works as follows:

The shop has to maintain a google sheet which contain the following information.

    Keyword     | Reply
    ---         | ---
    help        | Hi, valued customer, <br /> You can reach out customer service number 011-123456 or our facebook page facebook.com/ABC. <br /><br /> Thanks.
    information | Hi, valued customer, <br /> For more inforamtion about our products please refer to out website abc.com. <br /><br /> Thanks.
    promotions  | Hi, valued customer, <br /> You can find out all the current promotion details from here abc.com/promotions. <br /><br /> Thanks.

The app will retrieve all the unread messages from the given email, if these keywords exists in each email, this app will send the correcponding reply to the customer.

## Steps to run

1. Create and configure sample project in Google developer console as described below (Reference: https://github.com/wso2-ballerina/module-gmail#sample).
    1. Visit [Google API Console](https://console.developers.google.com), click **Create Project**, and follow the wizard to create a new project.
    1. Go to **Credentials -> OAuth Consent Screen**, enter a product name to be shown to users, and click **Save**.
    1. On the **Credentials** tab, click **Create Credentials** and select **OAuth Client ID**.
    1. Select an application type, enter a name for the application, and specify a redirect URI (enter https://developers.google.com/oauthplayground if you want to use 
    [OAuth 2.0 Playground](https://developers.google.com/oauthplayground) to receive the Authorization Code and obtain the 
    Access Token and Refresh Token).
    1. Click **Create**. Your Client ID and Client Secret will appear.
    1. In a separate browser window or tab, visit [OAuth 2.0 Playground](https://developers.google.com/oauthplayground). Click on the `OAuth 2.0 Configuration`
    icon in the top right corner and click on `Use your own OAuth credentials` and provide your `OAuth Client ID` and `OAuth Client Secret`.
    1. Select the required Gmail API and Google Sheets API scopes from the list of API's, and then click **Authorize APIs**.
    1. When you receive your authorization code, click **Exchange authorization code for tokens** to obtain the refresh token and access token.

1. After the above configurations, you will obtain the relavant tokens. Add the appropriate tokens to the `./Ballerina.conf` file.

    ```conf
    ACCESS_TOKEN="<ACCESS_TOKEN>"
    REFRESH_TOKEN="<REFRESH_TOKEN>"
    CLIENT_ID="<CLIENT_ID>"
    CLIENT_SECRET="<CLIENT_SECRET>"
    ROOT_EMAIL="<EMAIL_ADDRESS_OF_YOUR_APP>"
    GOOGLE_SHEET_ID="<UNIQUE_ID_OF_GOOGLE_SHEET>"
    GOOGLE_SHEET_NAME="<NAME_OF_THE_SHEET_FOR_EXAMPLE_Sheet1>"
    ```

1. Simply run the following bash script file and it will start the app.

```sh
$ sh run.sh
```

## References

1. https://ballerina.io/learn/by-example/
1. https://github.com/wso2-ballerina/module-gmail
1. https://github.com/wso2-ballerina/module-googlespreadsheet