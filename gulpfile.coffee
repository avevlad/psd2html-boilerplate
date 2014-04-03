gulp = require('gulp')
connect = require('gulp-connect')
p = require('gulp-load-plugins')()
src = 'src'
out = 'public'

gulp.task 'connect', connect.server(
  root: ['public']
  port: 1337
  livereload: true
  open:
    file: 'home.html'
    browser: 'chrome'
)

gulp.task 'ect', ->
  gulp
    .src([src + '/*.ect'])
    .pipe(p.ect())
    .pipe(gulp.dest(out + '/'))
    .pipe(connect.reload())

gulp.task 'compass', ->
  gulp
    .src([src + '/sass/*.sass'])
    .pipe p.compass(
        css: out + '/css'
        sass: src + '/sass'
        image: out + '/images'
      )
    .pipe(connect.reload())

gulp.task 'coffee', ->
  gulp
    .src([src + '/coffee/*.coffee'])
    .pipe(p.coffee(bare: true))
    .pipe(gulp.dest(out + '/js/'))
    .pipe(connect.reload())

gulp.task 'watch', ->
  gulp.watch [src + '/sass/*.sass', src + '/sass/**/*.sass'], ['compass']
  gulp.watch [src + '/*.ect', src + '/ect/**/*.ect'], ['ect']
  gulp.watch [src + '/coffee/*.coffee'], ['coffee']

gulp.task 'default', ['connect', 'ect', 'coffee', 'compass', 'watch']