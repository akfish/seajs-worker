path    = require 'path'
gulp    = require 'gulp'
gutil   = require 'gulp-util'
coffee  = require 'gulp-coffee'
connect = require 'gulp-connect'
watch   = require 'gulp-watch'

# Sources
coffee_src    = './src/**/*.coffee'
coffee_dst    = './dist'

watch_sources = ->
        gulp.watch coffee_src, ['coffee']
        
compile_coffee = ->
        gulp.src coffee_src
                .pipe coffee bare: true
                .on 'error', gutil.log
                .pipe gulp.dest coffee_dst

gulp.task 'coffee', ->
        compile_coffee()

gulp.task 'server', ['coffee'], ->
        connect.server
                livereload: true

gulp.task 'watch', ->
        watch_sources()

gulp.task 'livereload', ->
        gulp.src coffee_src, read: false
                .pipe watch()
                .pipe connect.reload()
        
gulp.task 'default', ['coffee', 'watch', 'server', 'livereload']
