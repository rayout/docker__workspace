var gulp = require('gulp');
var gulp_run = require('gulp-run');
var watch = require('gulp-watch');


gulp.task('make_local_env', function() {
    watch('.env.*', function() {
        gulp_run('php /var/utils/env.php -e local').exec();
    });
});