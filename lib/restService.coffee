superagent = require "superagent"


superagent.Request::setAccessToken = (accessToken)->
    @set("Authorization", "Bearer #{accessToken}")

    

class RestService
    constructor: (path)->
        if @baseUrl.length > 0 && @baseUrl[@baseUrl.length - 1] == "/"
            @baseUrl = @baseUrl.substr(0, @baseUrl.length - 1)
        @url = "#{@baseUrl}/#{path}"
    
    createRequest: (url, method = "get")->
        method = method.toLowerCase();
        superagent[method](url).setAccessToken(@accessToken).type("json")   
    processResult: (callback, err, res)->
        return callback err if err?
        r = JSON.parse(res.text || "{}")
        return callback new Error r.error if r.error?
        callback null, r    

    all: (query = null, callback)->
        @createRequest(@url).query(query || {}).end(@processResult.bind(this, callback))
            

    get: (id, callback)->
        @createRequest("#{@url}/#{id}").end(@processResult.bind(this, callback))
            
    create: (item, callback)->
        @createRequest(@url, "post").send(item).end(@processResult.bind(this, callback))
        
    update: (item, callback)->
        @createRequest("#{@url}/#{item.id}", "put").send(item).end(@processResult.bind(this, callback))

    remove: (id, callback)->    
        @createRequest("#{@url}/#{item.id}", "del").end(@processResult.bind(this, callback))

module.exports = RestService       