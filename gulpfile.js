var gulp = require('gulp');
var coffee = require('gulp-coffee');

gulp.task('default', ['coffee'], function(){
  gulp.watch('./src/*.coffee', ['coffee']);
});

gulp.task('coffee', function(){
  return gulp.src('./src/*.coffee')
    .pipe(coffee())
    .pipe(gulp.dest('./build/'));
});
