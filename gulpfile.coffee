gulp = require('gulp')
$ = require('gulp-load-plugins')()
src = 'src'
out = 'public'

handleError  = (err) ->
  console.log(err.toString())
  $.notify.onError((error) ->
    error
  ) (err.message)
  this.emit('end')

gulp.task "connect", ->
  $.connect.server
    root: "public"
    port: 1337
    livereload: true

gulp.task 'ejs', ->
  gulp
  .src([src + '/*.ejs'])
  .pipe($.ejs())
  .on('error',handleError)
  .pipe(gulp.dest(out + '/'))
  .pipe($.connect.reload()).on('error', console.log)

gulp.task 'compass', ->
  gulp
  .src([src + '/sass/*.sass', '/sass/*.scss])
  .pipe $.compass(
    css: out + '/css'
    sass: src + '/sass'
    image: out + '/images'
  )
  .on('error',handleError)
  .pipe($.connect.reload())


gulp.task 'coffee', ->
  gulp
  .src([src + '/coffee/*.coffee'])
  .pipe($.coffee(bare: true))
  .on('error',handleError)
  .pipe(gulp.dest(out + '/js/'))
  .pipe($.connect.reload())


gulp.task 'watch', ->
  gulp.watch [src + '/sass/*.sass', src + '/sass/**/*.sass',src + '/sass/*.scss', src + '/sass/**/*.scss'], ['compass']
  gulp.watch [src + '/*.ejs', src + '/ejs/**/*.ejs'], ['ejs']
  gulp.watch [src + '/coffee/*.coffee'], ['coffee']

gulp.task 'default', ['connect', 'ejs', 'coffee', 'compass', 'watch']
