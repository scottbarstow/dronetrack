OAuthHelper = require("../..").OAuthHelper
Browser = require "zombie"
path = require "path"
config = require "../config"


helper = new OAuthHelper(config.baseUrl, config.clientId, config.clientSecret, "http://localhost")


describe "OAuthHelper", ->
    
    describe "getAccessToken()", ->
        it "should return access point for user", (done)->
            getCode = (url, cb)->
                browser = new Browser({silent: true})
                browser.visit "#{config.baseUrl}/auth/signin", ->
                    browser.wait 100, ->
                        browser.fill "userNameOrEmail", config.userName
                        browser.fill "password", config.password
                        browser.pressButton "Sign in", ->
                            browser.wait 100, ->
                                browser.visit url, ->
                                    browser.pressButton "Allow", ->
                                        browser.wait 100, ->
                                            code = browser.text ".pin-code"
                                            if code? && code.length > 0
                                                return cb null, code
                                            return cb browser.error if browser.error?
                                            cb new Error("Unknown error on getting auth code")

            helper.getAccessToken getCode, (err, token)->
                return done err if err?
                (typeof token == "string").should.be.true
                (token.length > 0).should.be.true
                done()
                                

                            
                
    
