gulp = require("gulp");
gulpLoadPlugins = require("gulp-load-plugins");
plg = gulpLoadPlugins();
ect = require('gulp-ect')

o =
  src: 'src'
  out: 'production'

gulp.task 'ect', ->
  gulp
  .src([o.src + '/*.ect'])
  .pipe(plg.ect())
  .pipe gulp.dest(o.out + '/')

gulp.task 'coffee', ->
  gulp
    .src([o.src + '/coffee/*.coffee'])
    .pipe(plg.coffee(bare: true))
    .pipe gulp.dest(o.out + '/js/')

gulp.task 'sass', ->
  gulp
    .src([o.src + '/sass/*.sass'])
    .pipe(plg.compass(
        css: o.out + '/css'
        sass: o.src + '/sass'
        image: o.out + '/images'
      ))

gulp.task 'default', ->
  gulp.run 'ect'
  gulp.run 'coffee'
  gulp.run 'sass'
  gulp.watch [o.src + '/*.ect'], ->
    gulp.run 'ect'
  gulp.watch [o.src + '/coffee/*.coffee'], ->
    gulp.run 'coffee'
  gulp.watch [o.src + '/sass/*.sass'], ->
    gulp.run 'sass'