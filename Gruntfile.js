module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    watch: {
      files: ['lib/twittr/assets/coffeescript/*', 'spec/coffeescript/*'],
      tasks: 'coffee'
    },
    coffee: {
      source: {
        expand: true,
        flatten: true,
        cwd: 'lib/twittr/assets/coffeescript/',
        src: ['*.coffee'],
        dest: 'lib/twittr/assets/javascripts/',
        ext: '.js'
      },
      test: {
        expand: true,
        flatten: true,
        cwd: 'spec/coffeescript/',
        src: ['*.coffee'],
        dest: 'spec/javascripts/',
        ext: '.js'
      }
    },
  });

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('default', 'coffee');
};
