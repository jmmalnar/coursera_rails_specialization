(function() {
    'use strict';

    angular.module('MenuApp').component('categories', {
        templateUrl: 'views/categories.html',
        bindings: {
            menuCategories: '<'
        }
    });

})();