var gulp = require('gulp');
var gulpConnect = require('gulp-connect');
var gulpLess = require('gulp-less');
var gulpEjs = require('gulp-ejs');
var src = 'src';

var out = 'public';

gulp.task("connect", function () {
  return gulpConnect.server({
    root: "public",
    port: 1337,
    livereload: true
  });
});

gulp.task('ejs', function () {
  return gulp.src([src + '/*.ejs'])
    .pipe(gulpEjs())
    .pipe(gulp.dest(out + '/'))
    .pipe(gulpConnect.reload());
});

gulp.task('less', function () {
  return gulp.src('./src/less/**/*.less')
    .pipe(gulpLess())
    .pipe(gulp.dest('./public/css/'));
});

gulp.task('watch', function () {
  gulp.watch([src + '/less/*.less', src + '/less/**/*.less'], ['less']);
  return gulp.watch([src + '/*.ejs', src + '/ejs/**/*.ejs'], ['ejs']);
});

gulp.task('default', ['connect', 'less', 'ejs', 'watch']);
