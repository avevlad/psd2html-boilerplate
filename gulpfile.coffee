gulp = require('gulp')
$ = require('gulp-load-plugins')()
src = 'src'
out = 'public'

gulp.task "connect", ->
  $.connect.server
    root: "public"
    port: 1337
    livereload: true

gulp.task 'ejs', ->
  gulp
  .src([src + '/*.ejs'])
  .pipe($.ejs())
  .pipe(gulp.dest(out + '/'))
  .pipe($.connect.reload())

gulp.task 'compass', ->
  gulp
    .src([src + '/sass/*.sass'])
    .pipe $.compass(
        css: out + '/css'
        sass: src + '/sass'
        image: out + '/images'
      )
    .pipe($.connect.reload())

gulp.task 'coffee', ->
  gulp
    .src([src + '/coffee/*.coffee'])
    .pipe($.coffee(bare: true))
    .pipe(gulp.dest(out + '/js/'))
    .pipe($.connect.reload())

gulp.task 'watch', ->
  gulp.watch [src + '/sass/*.sass', src + '/sass/**/*.sass'], ['compass']
  gulp.watch [src + '/*.ejs', src + '/ejs/**/*.ejs'], ['ejs']
  gulp.watch [src + '/coffee/*.coffee'], ['coffee']

gulp.task 'default', ['connect', 'ejs', 'coffee', 'compass', 'watch']