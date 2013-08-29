OAuthHelper = require("../..").OAuthHelper
Browser = require "zombie"
path = require "path"
config = require "../config"


helper = new OAuthHelper(config.baseUrl, config.clientId, config.clientSecret, "http://localhost")


getAccessToken = (callback)->
    getCode = (url, cb)->
        browser = new Browser({silent: true})
        browser.visit "#{config.baseUrl}/auth/signin", ->
            browser.wait 50, ->
                browser.fill "userNameOrEmail", config.userName
                browser.fill "password", config.password
                browser.pressButton "Sign in", ->
                    browser.wait 50, ->
                        browser.visit url, ->
                            browser.wait 50, ->
                                browser.pressButton "Allow", ->
                                    browser.wait 50, ->
                                        code = browser.text ".pin-code"
                                        if code? && code.length > 0
                                            return cb null, code
                                        return cb browser.error if browser.error?
                                        cb new Error("Unknown error on getting auth code")

    helper.getAccessToken getCode, (err, token)->
        return callback err if err?
        (typeof token == "string").should.be.true
        (token.length > 0).should.be.true
        callback(null, token)


accessToken = null

module.exports = 
    getAccessToken: getAccessToken
    authorize: ->
        before (done)->
            if accessToken?
                @accessToken = accessToken
                return done()
            getAccessToken (err, token)=>
                return done err if err?
                @accessToken = accessToken = token    
                done()

