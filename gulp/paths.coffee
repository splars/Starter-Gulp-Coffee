paths = 
	builtFiles: [
		'build/**/*vendor*.js'
		'build/**/*scripts*.js'
		'build/**/*vendor*.css'
		'build/**/*styles*.css'
	]
	fonts:
		vendor:
			dump: 'vendor/fonts'
			src: 'vendor/fonts/**/*.{woff,ttf,eot,otf}'
			dest: 'build/fonts'
	images:
		custom:
			src: 'app/{assets,core,layout,components,public}/**/*.{svg,png,jpg}'
			dest: 'build/images'
	index:
		src: 'app/public/index.jade'
		dest: 'build'
	styles:
		sassHelpers: [ 'app/assets/styles/helpers' ]
		vendor:
			dump: 'vendor/styles'
			src: []
			dest: 'build/styles'
		custom:
			src: [
				'app/assets/styles/**/*.scss'
				'app/**/*.scss'
			]
			dest: 'build/styles'
	scripts:
		vendor:
			dump: 'vendor/scripts'
			src: []
			dest: 'build/scripts'
		custom:
			src: [
				'app/app.module.js'
				'app/**/*.module.js'
				'app/**/*.js'
			]
			dest: 'build/scripts'
	templates:
		src: [ 'app/**/*.jade' ]
		dest: 'build/templates'

module.exports = paths
