Gulp Coffee Starter
===================

Items of Note
----------------------
  * Gulp src paths and plugin options are stored in separate objects
  * Application files should live in the `app` directory
  * Compiled files get moved to the build directory
  * `gulp serve` will clean, compile, serve, and app application files
  * Browser-sync serves files from the `build` directory when `gulp serve` is run
  * `gulp build` will clean and compile app files
  * The command `NODE_ENV=production gulp <TaskName>` will compile the app in production mode, and minify/uglify styles/scripts
  * Scripts and style paths are each grouped in the paths object by vendor (bower) and custom (your app files). Both contain src (which should contain an array of ordered files) and destination keys
  * The `gulp vendor-files` command copies only the main bower files from each bower dependency into `app/vendor`
  * Add customized 3rd party libraries to `app/vendor`, but add the word 'custom' to the file name so `gulp clean` doesn't remove the files


