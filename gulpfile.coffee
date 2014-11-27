gulp = require('gulp')
$ = require('gulp-load-plugins')()
runSequence = require('gulp-run-sequence')
path = require('path')
util = require('gulp-util')
production = !!util.env.production

handleError  = (err) ->
  console.log(err.toString())
  $.notify.onError((error) ->
    error
  ) (err.message)
  this.emit('end')

mediaFilterExts = [
  '**/*.jpeg',
  '**/*.jpg',
  '**/*.png',
  '**/*.gif',
  '**/*.svg',
  '**/*.ttf',
  '**/*.woff',
  '**/*.woff2',
  '**/*.eot'
];

helpers = {

  prefixDirToFiles: (dir, files) ->
    if (!Array.isArray(files)) then files = [files]
    files.map((file) ->
      dir + '/' + file.replace(dir, '')
    )

  copy: (from, to, filter) ->
    filter = filter || '**/**'
    gulp.src(from)
    .pipe($.filter(filter))
    .pipe(gulp.dest(to))
     .on('error',handleError)
    .pipe($.notify(
        title: 'Gulp',
        subtitle: 'Копирование завершено!',
        message: ' ',
        onLast: true
      )
    )

  combine: (file, assets, copyFrom, copyTo, minifier, rebaseUrlRoot) ->
    ext = path.extname(file)
    rebaseUrlRoot = rebaseUrlRoot || copyFrom

    gulp.src(helpers.prefixDirToFiles(copyFrom, assets))
    .pipe($.if(ext == '.css', $.cssRebaseUrls({root: rebaseUrlRoot})))
    .pipe($.concat(file))
    .pipe($.if(production, minifier.call(this)))
    .pipe(gulp.dest(copyTo))
     .on('error',handleError)
    .pipe($.notify(
        title: 'Gulp',
        subtitle: 'Слияние в ' + copyTo + '/' + file + ' завершено!',
        message: ' ',
        onLast: true
      )
    )

}

gulp.task "connect", ->
  $.connect.server
    root: "./"
    port: 1337
    livereload: true
    
gulp.task "connect", ->
  gulp.src("./page/home.html")
  .pipe(open("", {app: "chrome", url: "http://localhost:1337"}));

gulp.task 'ejs', ->
  gulp
  .src(['page/*.ejs', 'ejs/*/*.ejs'])
  .pipe($.ejs())
  .on('error', handleError)
  .pipe(gulp.dest('page/'))
  .pipe($.connect.reload()).on('error', console.log)

gulp.task 'sass', ->
  gulp
  .src(['css/main.sass'])
  .pipe $.compass(
    css: 'css'
    sass: 'css'
    image: 'images'
  )
  .on('error', handleError)
  .pipe($.connect.reload())



gulp.task('build.css', () ->

  helpers.combine(
    'all.css',
    [
      'font/stylesheet.css',
      'css/main.css',
      'css/ip-style.css'
    ],
    './',
    '../Theme/assets',
    $.minifyCss,
    '.'
  )

)

gulp.task('copy.fonts', () ->

  helpers.copy('./font/**/**', '../Theme/assets/font', mediaFilterExts)

)

gulp.task('build.bootstrap', () ->

  helpers.combine(
    'bootstrap.js',
    [
      'vendor/bootstrap-sass/dist/js/bootstrap.js'
    ],
    './',
    '../Theme/assets',
    $.uglify
  )

)

gulp.task('build.js', () ->

  helpers.combine(
    'all.js',
    [
      'vendor/sourcebuster-js/js/sourcebuster.js'
      'js/Main.js'
    ],
    './',
    '../Theme/assets',
    $.uglify
  )

)


gulp.task('copy.images', () ->
  helpers.copy('./images/**/**', '../Theme/assets/images', mediaFilterExts)
)

gulp.task 'build', ->
  runSequence('sass', 'build.css', 'build.js', ['build.bootstrap','copy.fonts', 'copy.images'])

gulp.task 'watch', ->
  gulp.watch ['css/*.sass', 'css/**/*.sass', 'css/*.scss', 'css/**/*.scss'], ['sass']
  gulp.watch ['page/*.ejs', 'ejs/**/*.ejs'], ['ejs']

gulp.task 'default', ['connect', 'ejs', 'sass', 'watch','open']



