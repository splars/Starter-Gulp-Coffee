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

module.exports = paths
