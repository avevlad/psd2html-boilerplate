gulp = require('gulp')
$ = require('gulp-load-plugins')()

handleError  = (err) ->
  console.log(err.toString())
  $.notify.onError((error) ->
    error
  ) (err.message)
  this.emit('end')

gulp.task "connect", ->
  $.connect.server
    root: "./"
    port: 1337
    livereload: true

gulp.task 'ejs', ->
  gulp
  .src([ 'page/*.ejs', 'ejs/*/*.ejs'])
  .pipe($.ejs())
  .on('error',handleError)
  .pipe(gulp.dest( '/page/'))
  .pipe($.connect.reload()).on('error', console.log)

gulp.task 'compass', ->
  gulp
  .src([ '/css/*.sass', '/css/*.scss'])
  .pipe $.compass(
    css:  '/css'
    sass:  '/css'
    image:  '/images'
  )
  .on('error',handleError)
  .pipe($.connect.reload())



gulp.task 'watch', ->
  gulp.watch [ '/sass/*.sass',  '/sass/**/*.sass', '/sass/*.scss',  '/sass/**/*.scss'], ['compass']
  gulp.watch [ '/*.ejs',  '/ejs/**/*.ejs'], ['ejs']

gulp.task 'default', ['connect', 'ejs', 'compass', 'watch']
