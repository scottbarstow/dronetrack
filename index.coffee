superagent = require "superagent"


processResult = (callback, err, res)->
    return callback err if err?
    r = JSON.parse(res.text || "{}")
    return callback new Error r.error if r.error?
    callback null, r

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

    all: (query = null, callback)->
        @createRequest(@url).query(query || {}).end(processResult.bind(this, callback))
            

    get: (id, callback)->
        @createRequest("#{@url}/#{id}").end(processResult.bind(this, callback))
            
    create: (item, callback)->
        @createRequest(@url, "post").send(item).end(processResult.bind(this, callback))
        
    update: (item, callback)->
        @createRequest("#{@url}/#{item.id}", "put").send(item).end(processResult.bind(this, callback))

    remove: (id, callback)->    
        @createRequest("#{@url}/#{item.id}", "del").end(processResult.bind(this, callback))


class Drone extends RestService
    constructor: (@baseUrl, @accessToken)->
        super("/drone")

    addPoints: (id, trackId=null, points, callback)->    
        @createRequest("#{@url}/#{id}/points", "post").send({trackId: trackId, points: (points || [])}).end(processResult.bind(this, callback))

    importPointsFromFiles: (id, files, format, callback)->    
        format = format.toUpperCase()
        if format != "CSV" && format != "KML"
            return callback new Error("Format #{format || '<null>'} is not supported")   
        r = @createRequest("#{@url}/#{id}/import#{format}", "post")
        i = 1
        for file in files
            r = r.attach("file#{i}", file)
            i += 1
        r.end(processResult.bind(this, callback))    


class Track extends RestService
    constructor: (@baseUrl, @accessToken)->
        super("/track") 

    getPoints: (id, callback)->       
        @createRequest("#{@url}/#{id}/points").end(processResult.bind(this, callback))

    addPoints: (id, points, callback)->    
        @createRequest("#{@url}/#{id}/points", "post").send(points).end(processResult.bind(this, callback))    

    importPointsFromFiles: (id, files, format, callback)->    
        format = format.toUpperCase()
        if format != "CSV" && format != "KML"
            return callback new Error("Format #{format || '<null>'} is not supported")   
        r = @createRequest("#{@url}/#{id}/points/import#{format}", "post")
        i = 1
        for file in files
            r = r.attach("file#{i}", file)
            i += 1
        r.end(processResult.bind(this, callback))    
    


module.exports = 
      Drone: Drone
      Track: Track      