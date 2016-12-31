(function() {
    'use strict';

    var menuDataService = function($http) {
        var vm = this;

        var baseUrl =  'https://davids-restaurant.herokuapp.com/';

        // Function that returns all categories
        vm.getAllCategories = function() {
            return $http.get(baseUrl + 'categories.json');
        }

        // Function that returns the items for a specific category
        vm.getItemsForCategory = function(categoryShortName) {
            return $http.get(baseUrl + 'menu_items.json?category=' + categoryShortName);
        }
    };

    menuDataService.$inject = ['$http'];
    angular.module('MenuData').service('MenuDataService', menuDataService);
})();