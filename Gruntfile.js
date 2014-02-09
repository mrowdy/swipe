module.exports = function(grunt) {
    'use strict';
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

		'sftp-deploy': {
		  build: {
		    auth: {
		      host: '10.10.10.5',
		      port: 22,
		      authKey: 'key1'
		    },
		    src: 'web',
		    dest: '/media/datastore/swipe/',
		    server_sep: '/'
		  }
		},
		
		watch: {
		  scripts: {
		    files: '**/*.*',
		    tasks: ['sftp-deploy'],
		  },
		}
    });
	
	grunt.loadNpmTasks('grunt-sftp-deploy');
	grunt.loadNpmTasks('grunt-contrib-watch');

    grunt.registerTask('default', ['sftp-deploy']);

};