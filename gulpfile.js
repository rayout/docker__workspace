var gulp = require('/var/www/node_modules/gulp');
var gulp_run = require('/var/www/node_modules/gulp_run');


gulp.task('make_local_env', function() {
    gulp.watch('.env.*', function() {
        gulp_run('php /var/utils/env.php -e local').exec();
    });
});