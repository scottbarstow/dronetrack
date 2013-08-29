superagent = require "superagent"


superagent.Request::setAccessToken = (accessToken)->
    @set("Authorization", "Bearer #{accessToken}")

    

class RestService
    constructor: (path)->
        if @baseUrl.length > 0 && @baseUrl[@baseUrl.length - 1] == "/"
            @baseUrl = @baseUrl.substr(0, @baseUrl.length - 1)
        @url = "#{@baseUrl}#{path}"
        @processResult = RestService.processResult
    
    createRequest: (url, method = "get")->
        method = method.toLowerCase();
        superagent[method](url).setAccessToken(@accessToken).set("accept", "application/json")   

    all: (query, callback)->
        if arguments.length == 1
            callback = query
            query = null
        @createRequest(@url).query(query || {}).end(@processResult.bind(this, callback))
            

    get: (id, callback)->
        @createRequest("#{@url}/#{id}").end(@processResult.bind(this, callback))
            
    create: (item, callback)->
        @createRequest(@url, "post").send(item).end(@processResult.bind(this, callback))
        
    update: (item, callback)->
        @createRequest("#{@url}/#{item.id}", "put").send(item).end(@processResult.bind(this, callback))

    remove: (id, callback)->    
        @createRequest("#{@url}/#{id}", "del").end(@processResult.bind(this, callback))

    destroy: (id, callback)->    # alias to remove
        @remove id, callback

RestService.processResult = (callback, err, res)->
    return callback err if err?
    if res.body? && Object.keys(res.body).length > 0
        r = res.body
        if res.statusCode >= 400
            return callback new Error r.error if r.error? 
            callback new Error("Http error #{res.statusCode}")    
        callback null, r    
    else
        if res.statusCode >= 400
            callback new Error(res.text)    
        else    
            callback()


module.exports = RestService       