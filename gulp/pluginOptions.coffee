sourceFilePaths = require('./paths')

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
		pretty: global.isDevelopment
		locals:
			isDevelopment: global.isDevelopment
			isProduction: global.isProduction
	minifyCss: 
		keepSpecialComments: 0
	sass:
		outputStyle: if global.isProduction then 'compressed' else 'nested'
		sourceComments: 'map'
		includePaths: sourceFilePaths.styles.sassHelpers
	uglify: 
		mangle: false
  
module.exports = options
