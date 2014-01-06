mountFolder = (connect, dir) ->
    connect.static require("path").resolve(dir)

module.exports = (grunt) ->
    config =
        path: "app"
        liveReloadPort: 35729

    require("load-grunt-tasks") grunt
    require("connect-livereload") port: config.liveReloadPort

    grunt.initConfig
        conf: config
        watch:
            stylus:
                files: ["<%= conf.path %>/stylus/*.styl"]
                tasks: ["stylus:compile"]

            coffee:
                files: ["<%= conf.path %>/coffee/*.coffee"]
                tasks: ["coffee:compile"]

            livereload:
                files: ["<%= conf.path %>/stylus/*.styl", "<%= conf.path %>/*.html", "<%= conf.path %>/coffee/*.coffee"]
                options:
                    livereload: config.liveReloadPort
        coffee:
            compile:
                files:
                    "<%= conf.path %>/assets/scripts/common.js": ["<%= conf.path %>/coffee/*.coffee"]
        stylus:
            compile:
                files:
                    '<%= conf.path %>/assets/css/style.css': '<%= conf.path %>/stylus/main.styl'

        connect:
            options:
                port: 5555
                base: config.path
                hostname: "localhost"

            livereload:
                options:
                    middleware: (connect) ->
                        [require("connect-livereload")(), mountFolder(connect, config.path)]
        open:
            server:
                url: "http://localhost:<%= connect.options.port %>/index.html"

    grunt.registerTask "default", ["connect", "open", "watch"]
    grunt.loadNpmTasks "grunt-open"