import ballerina/io;
import ballerina/encoding;
import wso2/gmail;
import wso2/gsheets4;
import ballerina/lang.'string as strings;
import ballerina/stringutils;

type MarketingBot object {
    private gmail:Client gmailClient;
    private gsheets4:Client spreadsheetClient;
    private string rootGmailAddress;
    private string sheetId;
    private string sheetName;

    function __init(
        string accessToken, 
        string refreshToken, 
        string clientId, 
        string clientSecret, 
        string rootGmailAddress,
        string sheetId,
        string sheetName
    ) {
        // Initialize gmail client
        gmail:GmailConfiguration gmailConfig = {
            oauthClientConfig: {
                accessToken: accessToken,
                refreshConfig: {
                    refreshUrl: gmail:REFRESH_URL,
                    refreshToken: refreshToken,
                    clientId: clientId,
                    clientSecret: clientSecret
                }
            }
        };
        self.gmailClient = new(gmailConfig);

        // Initialize spreadsheet client
        gsheets4:SpreadsheetConfiguration spreadsheetConfig = {
            oAuthClientConfig: {
                accessToken: accessToken,
                refreshConfig: {
                    clientId: clientId,
                    clientSecret: clientSecret,
                    refreshUrl: gsheets4:REFRESH_URL,
                    refreshToken: refreshToken
                }
            }
        };
        self.spreadsheetClient = new (spreadsheetConfig);

        // Set root gmail address to be used in every operation
        self.rootGmailAddress = rootGmailAddress;

        // Spreadsheet details: ID that identified the spreadsheet uniquely and sheet ID
        self.sheetId = sheetId;
        self.sheetName = sheetName;
    }

    function getUnreadEmails() returns @tainted string[][] {
        string inboxLabel = "INBOX";

        gmail:MsgSearchFilter searchFilter = {includeSpamTrash: false, labelIds: [inboxLabel], q: "is:unread"};
        var emailList = self.gmailClient->listMessages(self.rootGmailAddress, searchFilter);
        string[][] emailsToReply = [];

        if (emailList is gmail:MessageListPage) {
            int i = 0;
            foreach var email in emailList {
                json|error messageJson = emailList.messages[i].messageId;
                if (messageJson is json) {
                    gmail:Message|error message = self.gmailClient->readMessage(self.rootGmailAddress, <@untainted> messageJson.toJsonString().toString());
                    if (message is gmail:Message) {
                        var decodedMessage = encoding:decodeBase64Url(message.plainTextBodyPart.body.toString());
                        if (decodedMessage is byte[]) {
                            string|error messageString = strings:fromBytes(decodedMessage);
                            if (messageString is string) {
                                string[] replyContent = [message.headerFrom, messageString];
                                emailsToReply[i] = replyContent;
                            }
                        }
                    }
                }
                i += 1;
            } 
        }

        return emailsToReply;
    }

    function readGSheet(string gSheetId, string gSheetName) returns @tainted string[][] {
        var sheet = self.spreadsheetClient->getSheetValues(gSheetId, gSheetName, "A1", "B3");

        if (sheet is string[][]) {
            return sheet;
        } 
        string[][] emptySheet = [];
        return emptySheet;
    }

    function sendReplies() {
        string[][] preparedReplies = self.readGSheet(self.sheetId, self.sheetName);
        string[][] unreadEmails = self.getUnreadEmails();
        
        // preparedReplies -> [keyword, replyMessage]
        // unreadEmails -> [fromEmailAddress, emailContent]
        foreach var unreadEmail in unreadEmails {
            foreach var preparedReply in preparedReplies {
                if (stringutils:contains(unreadEmail[1], preparedReply[0])) {
                    gmail:MessageRequest messageRequest = {};
                    messageRequest.recipient = unreadEmail[0];
                    messageRequest.sender = self.rootGmailAddress;
                    messageRequest.subject = preparedReply[1];
                    
                    messageRequest.messageBody = preparedReply[1];
                    messageRequest.contentType = gmail:TEXT_PLAIN;
                    var sendMessageResponse = self.gmailClient->sendMessage(self.rootGmailAddress, <@untainted> messageRequest);
                    io:println(sendMessageResponse);
                }
            }
        }
    }
};
