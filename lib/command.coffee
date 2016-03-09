runner = ->
  pjson      = require('../package.json')
  version    = pjson.version
  livereload = require './livereload'
  resolve    = require('path').resolve
  opts       = require 'opts'
  debug      = false;
  
  opts.parse [
    {
      short: "v"
      long:  "version"
      description: "Show the version"
      required: false
      callback: ->
        console.log version
        process.exit(1)
    }
    {
      short: "p"
      long:  "port"
      description: "Specify the port"
      value: true
      required: false
    }
    {
      short: "x"
      long: "exclusions"
      description: "Exclude files by specifying an array of regular expressions. Will be appended to default value which is [/\\.git\//, /\\.svn\//, /\\.hg\//]",
      required: false,
      value: true
    }
    {
      short: "d"
      long: "debug"
      description: "Additional debugging information",
      required: false,
      callback: -> debug = true
    }
    {
      short: "e"
      long: "exts",
      description: "An array of extensions you want to observe. An example 'jade scss' (quotes are required). In addition to the defaults (html, css, js, png, gif, jpg, php, php5, py, rb, erb, and \"coffee.\").",
      required: false,
      value: true  
    }
  ].reverse(), true

  port = opts.get('port') || 35729
  exclusions = if opts.get('exclusions') then opts.get('exclusions' ).split(',' ).map((s) -> new RegExp(s)) else []
  exts = (opts.get('exts') || '').split ' '
  
  server = livereload.createServer({
    port: port
    debug: debug
    exclusions: exclusions,
    exts: exts
  })

  path = resolve(process.argv[2] || '.')
  console.log "Starting LiveReload v#{version} for #{path} on port #{port}."
  server.watch(path)

module.exports =
  run: runner
