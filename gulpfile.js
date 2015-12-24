var gulp = require('gulp');
var gulpConnect = require('gulp-connect');
var gulpLess = require('gulp-less');
var src = 'src';

var out = 'public';

gulp.task("connect", function () {
  return gulpConnect.server({
    root: "public",
    port: 1337,
    livereload: true
  });
});

//gulp.task('ejs', function () {
//  return gulp.src([src + '/*.ejs'])
//    .pipe($.ejs())
//    .pipe(gulp.dest(out + '/'))
//    .pipe($.connect.reload());
//});
//
//gulp.task('less', function () {
//  return gulp.src([src + '/less/*.less'])
//    .pipe($.compass({
//      css: out + '/css',
//      less: src + '/less',
//      image: out + '/images'
//    }))
//    .pipe($.connect.reload());
//});
//
//gulp.task('watch', function () {
//  gulp.watch([src + '/less/*.less', src + '/less/**/*.less'], ['less']);
//  gulp.watch([src + '/*.ejs', src + '/ejs/**/*.ejs'], ['ejs']);
//  return gulp.watch([src + '/coffee/*.coffee'], ['coffee']);
//});
//
//gulp.task('default', ['connect', 'ejs', 'compass', 'watch']);
