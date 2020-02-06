import ballerina/config;

public function main() {
    MarketingBot marketingBot = new (
        config:getAsString("ACCESS_TOKEN"),
        config:getAsString("REFRESH_TOKEN"),
        config:getAsString("CLIENT_ID"),
        config:getAsString("CLIENT_SECRET"),
        config:getAsString("ROOT_EMAIL"),
        config:getAsString("GOOGLE_SHEET_ID"),
        config:getAsString("GOOGLE_SHEET_NAME")
    );
    marketingBot.sendReplies();
}
