gulp = require('gulp')
browserSync = require('browser-sync')
reload = browserSync.reload
del = require('del')
runSequence = require('run-sequence')
gulpNodemon = require('gulp-nodemon')
gulpPlumber = require('gulp-plumber')
mainBowerFiles = require('main-bower-files')
gulpSass = require('gulp-sass')
gulpAutoprefixer = require('gulp-autoprefixer')
gulpMinifyCss = require('gulp-minify-css')
gulpJade = require('gulp-jade')
gulpCoffee = require('gulp-coffee')
gulpConcat = require('gulp-concat')
gulpFilter = require('gulp-filter')
gulpFlatten = require('gulp-flatten')
gulpIf = require('gulp-if')
gulpInject = require('gulp-inject')
gulpJshint = require('gulp-jshint')
gulpRename = require('gulp-rename')
gulpRev = require('gulp-rev')
gulpUglify = require('gulp-uglify')
gulpInject = require('gulp-inject')
process.env.NODE_ENV = process.env.NODE_ENV or 'development'
global.isProduction = process.env.NODE_ENV == 'production'
global.isDevelopment = process.env.NODE_ENV == 'development'
paths = require('./gulp/paths')
options = require('./gulp/pluginOptions')

createFilename = (name, ext) ->
	name + '.' + ext

gulp.task 'clean', (callback) ->
	del [
		'build'
		'vendor/**/*'
		'!vendor/**/*.custom*'
	], callback

gulp.task 'styles', ->
	outputFileName = createFilename('styles', 'css')

	gulp.src(paths.styles.custom.src)
		.pipe(gulpPlumber())
		.pipe(gulpSass(options.sass))
		.pipe(gulpAutoprefixer(options.autoprefixer))
		.pipe(gulpConcat(outputFileName))
		.pipe(gulpIf(isProduction, gulpRev()))
		.pipe(gulp.dest(paths.styles.custom.dest))
		.pipe(reload({stream: true}))

gulp.task 'scripts', ->
	outputFileName = createFilename('scripts', 'js')
	gulp.src(paths.scripts.custom.src)
		.pipe(gulpPlumber())
		.pipe(gulpCoffee(options.coffee))
		.pipe(gulpConcat(outputFileName))
		.pipe(gulpIf(isProduction, gulpUglify(options.uglify)))
		.pipe(gulpIf(isProduction, gulpRev()))
		.pipe(gulp.dest(paths.scripts.custom.dest))
		.pipe(reload({stream: true}))
		
gulp.task 'images', ->
	gulp.src(paths.images.custom.src)
		.pipe(gulpPlumber()).pipe(gulpFlatten())
		.pipe(gulp.dest(paths.images.custom.dest))
		.pipe reload(stream: true)

gulp.task 'templates', ->
	gulp.src(paths.templates.src)
		.pipe(gulpPlumber())
		.pipe(gulpJade(options.jade))
		.pipe(gulp.dest(paths.templates.dest))
		.pipe(reload({stream: true}))

gulp.task 'index', ->
	sources = gulp.src(paths.builtFiles, read: false)

	gulp.src(paths.index.src)
		.pipe(gulpPlumber())
		.pipe(gulpJade(options.jade))
		.pipe(gulpInject(sources, options.gulpInject))
		.pipe(gulp.dest(paths.index.dest))
		.pipe(reload({stream: true}))

gulp.task 'vendor', ['vendor:files'], (callback) ->
	runSequence('vendor:fonts', 'vendor:styles', 'vendor:scripts', callback)  
	return

gulp.task 'vendor:files', ->
	scripts =  gulpFilter '**/*.js'
	styles = gulpFilter '**/*.css'
	fonts = gulpFilter '**/*.{woff,ttf,svg,eot,otf}'

	gulp.src(mainBowerFiles(options.mainBowerFiles))
		.pipe(scripts)
		.pipe(gulp.dest(paths.scripts.vendor.dump))
		.pipe(scripts.restore())

		.pipe(styles)
		.pipe(gulp.dest(paths.styles.vendor.dump))
		.pipe(styles.restore())

		.pipe(fonts)
		.pipe(gulp.dest(paths.fonts.vendor.dump))
		.pipe(fonts.restore())

gulp.task 'vendor:fonts', ->
	gulp.src(paths.fonts.vendor.src)
		.pipe(gulpPlumber())
		.pipe(gulp.dest(paths.fonts.vendor.dest))
		.pipe(reload({stream: true}))

gulp.task 'vendor:styles', ->
	outputFileName = createFilename('vendor', 'css')
	gulp.src(paths.styles.vendor.src)
		.pipe(gulpPlumber())
		.pipe(gulpIf(isProduction, gulpMinifyCss(options.minifyCss)))
		.pipe(gulpConcat(outputFileName))
		.pipe(gulpIf(isProduction, gulpRev()))
		.pipe(gulp.dest(paths.styles.vendor.dest))
		.pipe(reload({stream: true}))

gulp.task 'vendor:scripts', ->
	outputFileName = createFilename('vendor', 'js')
	gulp.src(paths.scripts.vendor.src)
		.pipe(gulpPlumber())
		.pipe(gulpConcat(outputFileName))
		.pipe(gulpIf(isProduction, gulpUglify(options.uglify)))
		.pipe(gulpIf(isProduction, gulpRev()))
		.pipe(gulp.dest(paths.scripts.vendor.dest))
		.pipe(reload({stream: true}))

gulp.task 'watch', ->
	gulp.watch paths.styles.custom.src, ['styles']
	gulp.watch paths.styles.vendor.src, ['vendor:styles']
	gulp.watch paths.scripts.custom.src, ['scripts']
	gulp.watch paths.scripts.vendor.src, ['vendor:scripts']
	gulp.watch paths.fonts.vendor.src, ['vendor:fonts']
	gulp.watch [paths.styles.vendor.src, './build*.html'], reload
	gulp.watch './bower.json', ['vendor']
	gulp.watch paths.templates.src, [ 'templates' ]

gulp.task 'browser-sync', ->
	browserSync.init null, options.browserSync
	return

gulp.task 'default', ['clean'], (callback) ->
	runSequence(['styles', 'scripts', 'vendor', 'images'], ['templates', 'index'], callback)  
	return

gulp.task 'serve', ['default'], ->
	runSequence('browser-sync', 'watch') 
