superagent = require "superagent"
RestService = require "./restService"

class OAuthHelper
    constructor: (@baseUrl, @clientId, @clientSecret, @redirectUrl)->
        if @baseUrl.length > 0 && @baseUrl[@baseUrl.length - 1] == "/"
            @baseUrl = @baseUrl.substr(0, @baseUrl.length - 1)
    getAccessToken: (getCode, callback)->
        if typeof getCode != "function"
            return callback(new Error("Parameter getCode must be function"))
        url = "#{@baseUrl}/auth/dialog?response_type=code&client_id=#{encodeURIComponent(@clientId)}&redirect_uri=#{encodeURIComponent(@redirectUrl)}"
        getCode url, (err, code)=>
            return callback err if err?
            superagent.post("#{@baseUrl}/auth/token").set("accept", "application/json").send({grant_type: "authorization_code", code: code, redirect_uri: @redirectUrl, client_id: @clientId, client_secret: @clientSecret}).end (err, res)=>
                cb = (err, r)->
                    return callback err if err?
                    callback null, r.access_token
                RestService.processResult cb, err, res


            


module.exports = OAuthHelper