mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->
  config =
    src: "src"
    prod: "production"
    liveReloadPort: 35729

  require("load-grunt-tasks") grunt
  require("connect-livereload") port: config.liveReloadPort

  grunt.initConfig
    cfg: config
    watch:
      compass:
        files: ["<%= cfg.src %>/sass/*.sass"]
        tasks: ["compass:dist"]
      coffee:
        files: ["<%= cfg.src %>/coffee/*.coffee"]
        tasks: ["coffee:compile"]
      ect:
        files: [
          "<%= cfg.src %>/*.ect"
          "<%= cfg.src %>/ect/**/*.ect"
        ]
        tasks: ["ect:compile"]

      livereload:
        files: [
          '<%= cfg.prod %>/*.html'
          '<%= cfg.prod %>/css/*.css'
        ]
        options:
          livereload: config.liveReloadPort
    ect:
      compile:
        options:
          ext: ".ect"
          root: "src"
        cwd: "src"
        patterns: ["*.ect"]
        dest: "production"
    coffee:
      compile:
        files:
          "<%= cfg.prod %>/js/common.js": ["<%= cfg.src %>/coffee/Main.coffee"]
    compass:
      dist:
        options:
          sassDir: '<%= cfg.src %>/sass'
          cssDir: '<%= cfg.prod %>/css'
          environment: 'production'
    connect:
      options:
        port: 5555
        base: config.prod
        hostname: "localhost"
      livereload:
        options:
          middleware: (connect) ->
            [require("connect-livereload")(), mountFolder(connect, config.prod)]
    open:
      server:
        url: "http://localhost:<%= connect.options.port %>/home.html"

  grunt.registerTask "default", ["connect", "open", "watch"]
  grunt.loadNpmTasks "grunt-open"