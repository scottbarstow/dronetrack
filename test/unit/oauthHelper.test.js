// Generated by CoffeeScript 1.6.3
var auth;

auth = require("./auth");

describe("OAuthHelper", function() {
  return describe("getAccessToken()", function() {
    return it("should return access point for user", function(done) {
      return auth.getAccessToken(done);
    });
  });
});
