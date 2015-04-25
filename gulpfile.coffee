gulp = require 'gulp'
browserSync = require 'browser-sync'
reload = browserSync.reload
del = require 'del'
runSequence = require 'run-sequence'
gulpNodemon = require 'gulp-nodemon'
gulpPlumber = require 'gulp-plumber'

mainBowerFiles = require 'main-bower-files'
gulpSass = require 'gulp-sass'
gulpAutoprefixer = require 'gulp-autoprefixer'
gulpMinifyCss = require 'gulp-minify-css'
gulpJade = require 'gulp-jade'
gulpCoffee = require 'gulp-coffee'
gulpConcat = require 'gulp-concat'
gulpFilter = require 'gulp-filter'
gulpIf = require 'gulp-if'
gulpInject = require 'gulp-inject'
gulpJshint = require 'gulp-jshint'
gulpRename = require 'gulp-rename'
gulpRev = require 'gulp-rev'
gulpUglify = require 'gulp-uglify'
gulpInject = require('gulp-inject')

process.env.NODE_ENV = process.env.NODE_ENV || 'development' #NODE_ENV=production gulp
isProduction = (process.env.NODE_ENV == 'production')
isDevelopment = (process.env.NODE_ENV == 'development')

paths = 
	builtFiles: [
		'build/**/*vendor*.js'
		'build/**/*scripts*.js'
		'build/**/*vendor*.css'
		'build/**/*styles*.css'
	]
	fonts: 
		vendor: 
			dump: 'app/vendor/fonts'
			src: 'app/vendor/fonts/**/*.{woff,ttf,svg,eot,otf}'
			dest: 'build/fonts'
	index:
		src: 'app/public/index.jade'
		dest: 'build'
	styles: 
		vendor: 
			dump: 'app/vendor/styles'
			src: [
				'app/vendor/styles/bootstrap.css'
				'app/vendor/styles/bootstrap-social.css'
				'app/vendor/styles/font-awesome.css'
			]
			dest: 'build/styles'
		custom:
			src: ['app/assets/styles/**/*.scss', 'app/assets/**/*.scss']
			dest: 'build/styles'	
	scripts:
		vendor: 
			dump: 'app/vendor/scripts'
			src: [
				'app/vendor/scripts/jquery.js'
				'app/vendor/scripts/underscore.js'
				'app/vendor/scripts/bootstrap.js'
				'app/vendor/scripts/backbone.js'
				'app/vendor/scripts/backbone.wreqr.js'
				'app/vendor/scripts/backbone.babysitter.js'
				'app/vendor/scripts/backbone.marionette.js'
			]
			dest: 'build/scripts'
		custom:
			src: ['app/**/*.coffee', 'app/initialize.coffee']
			dest: 'build/scripts'	
	templates:
		src: ['app/**/*.jade']
		dest: 'build/templates'

options = 
	autoprefixer: ['last 2 versions', '> 5%']
	browserSync: 
		server: 
			baseDir: 'build'
	coffee: 
		bare: true
	gulpInject:
		ignorePath: 'build'
	jade:
		pretty: isDevelopment
		locals:
			isDevelopment: isDevelopment
			isProduction: isProduction
	minifyCss:
		keepSpecialComments: 0			
	sass: 	
		outputStyle: if isProduction then 'compressed' else 'nested'
		sourceComments: 'map'
	uglify:
		mangle: false

createFilename = (name,ext)->
	name+'.'+ext

gulp.task 'clean', (callback) ->
	del(['build', 'app/vendor/**/*', '!app/vendor/**/*.custom*', ], callback)

gulp.task 'vendor-files', ->
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

gulp.task 'fonts-vendor', ->
	gulp.src(paths.fonts.vendor.src)
		.pipe(gulpPlumber())
		.pipe(gulp.dest(paths.fonts.vendor.dest))
		.pipe(reload({stream: true}))

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

gulp.task 'styles-vendor', ->
	outputFileName = createFilename('vendor', 'css')
	gulp.src(paths.styles.vendor.src)
		.pipe(gulpPlumber())
		.pipe(gulpIf(isProduction, gulpMinifyCss(options.minifyCss)))
		.pipe(gulpConcat(outputFileName))
		.pipe(gulpIf(isProduction, gulpRev()))
		.pipe(gulp.dest(paths.styles.vendor.dest))
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

gulp.task 'scripts-vendor', ->
	outputFileName = createFilename('vendor', 'js')
	gulp.src(paths.scripts.vendor.src)
		.pipe(gulpPlumber())
		.pipe(gulpConcat(outputFileName))
		.pipe(gulpIf(isProduction, gulpUglify(options.uglify)))
		.pipe(gulpIf(isProduction, gulpRev()))
		.pipe(gulp.dest(paths.scripts.vendor.dest))
		.pipe(reload({stream: true}))

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

gulp.task 'watch', ->
	gulp.watch paths.styles.custom.src, ['styles']
	gulp.watch paths.styles.vendor.src, ['styles-vendor']
	gulp.watch paths.scripts.custom.src, ['scripts']
	gulp.watch paths.scripts.vendor.src, ['scripts-vendor']
	gulp.watch [paths.styles.vendor.src, './build*.html'], reload

gulp.task 'browser-sync', ->
  browserSync.init null, options.browserSync
  return

gulp.task 'default', ['clean'], (callback) ->
	runSequence('vendor-files', ['fonts-vendor', 'styles', 'styles-vendor', 'scripts', 'scripts-vendor'], ['templates', 'index'], callback)  
	return

gulp.task 'serve', ['default'], ->
	runSequence('browser-sync', 'watch') 
