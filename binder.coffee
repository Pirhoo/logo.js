_       = require('underscore')
fs      = require('fs')
config  = require('./config.json')

module.exports = (app, path, slug)->
    logo = config[slug]
    svg  = fs.readFileSync logo.src, "utf8"
    # Secure a regex
    # @src https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions#Using_Special_Characters
    escapeRegExp = (str='') -> str.replace /([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1"
    # Secure "replaceAll" method
    # @src http://stackoverflow.com/questions/1144783/replacing-all-occurrences-of-a-string-in-javascript
    replaceAll = (find, replace, str) ->
        str.replace new RegExp( escapeRegExp(find), "g"), replace
    # Just bind a GET method to this path
    app.get path, (req, resp)->
        # Extract colors from route
        colors = (color for own key, color of req.params)
        # Create an object with every color replacement
        replacements = _.object(logo.colors, colors)
        # Copy the SVG into an output variable
        output = svg
        # For each key, search and replace
        for color, replacement of replacements
            if replacement?
                # It's an heaxdecimal color
                if /(^[0-9A-F]{6}$)|(^[0-9A-F]{3}$)/i.test replacement
                    # Add a prefix
                    replacement = "#" + replacement
                # Replace the color
                output = replaceAll color, replacement, output
        # Then simply return the color
        resp.contentType "image/svg+xml"
        resp.send output
        do resp.end
