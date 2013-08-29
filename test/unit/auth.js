// Generated by CoffeeScript 1.6.3
var Browser, OAuthHelper, accessToken, config, getAccessToken, helper, path;

OAuthHelper = require("../..").OAuthHelper;

Browser = require("zombie");

path = require("path");

config = require("../config");

helper = new OAuthHelper(config.baseUrl, config.clientId, config.clientSecret, "http://localhost");

getAccessToken = function(callback) {
  var getCode;
  getCode = function(url, cb) {
    var browser;
    browser = new Browser({
      silent: true
    });
    return browser.visit("" + config.baseUrl + "/auth/signin", function() {
      return browser.wait(50, function() {
        browser.fill("userNameOrEmail", config.userName);
        browser.fill("password", config.password);
        return browser.pressButton("Sign in", function() {
          return browser.wait(50, function() {
            return browser.visit(url, function() {
              return browser.wait(50, function() {
                return browser.pressButton("Allow", function() {
                  return browser.wait(50, function() {
                    var code;
                    code = browser.text(".pin-code");
                    if ((code != null) && code.length > 0) {
                      return cb(null, code);
                    }
                    if (browser.error != null) {
                      return cb(browser.error);
                    }
                    return cb(new Error("Unknown error on getting auth code"));
                  });
                });
              });
            });
          });
        });
      });
    });
  };
  return helper.getAccessToken(getCode, function(err, token) {
    if (err != null) {
      return callback(err);
    }
    (typeof token === "string").should.be["true"];
    (token.length > 0).should.be["true"];
    return callback(null, token);
  });
};

accessToken = null;

module.exports = {
  getAccessToken: getAccessToken,
  authorize: function() {
    return before(function(done) {
      var _this = this;
      if (accessToken != null) {
        this.accessToken = accessToken;
        return done();
      }
      return getAccessToken(function(err, token) {
        if (err != null) {
          return done(err);
        }
        _this.accessToken = accessToken = token;
        return done();
      });
    });
  }
};
