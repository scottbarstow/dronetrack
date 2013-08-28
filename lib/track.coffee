RestService = require "./restService"

class Track extends RestService
    constructor: (@baseUrl, @accessToken)->
        super("/track") 

    getPoints: (id, callback)->       
        @createRequest("#{@url}/#{id}/points").end(processResult.bind(this, callback))

    addPoints: (id, points, callback)->    
        @createRequest("#{@url}/#{id}/points", "post").send(points).end(@processResult.bind(this, callback))    

    importPointsFromFiles: (id, files, format, callback)->    
        format = format.toUpperCase()
        if format != "CSV" && format != "KML"
            return callback new Error("Format #{format || '<null>'} is not supported")   
        r = @createRequest("#{@url}/#{id}/points/import#{format}", "post")
        i = 1
        for file in files
            r = r.attach("file#{i}", file)
            i += 1
        r.end(@processResult.bind(this, callback))    
    