var gulp = require('gulp');
var gulp_run = require('gulp-run');
var watch = require('gulp-watch');


gulp.task('make_local_env', function() {
    gulp_run('ls -la').exec();
    gulp_run('ls /var/www/ -la').exec();
    watch('/var/www/.env.*', function() {
        gulp_run('php /var/utils/env.php -e local').exec();
    });
});