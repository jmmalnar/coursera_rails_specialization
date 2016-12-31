(function() {
    'use strict';

    var routesConfig = function($stateProvider, $urlRouterProvider) {
        $stateProvider.state('home', {
            url: '/',
            templateUrl: 'views/home.html'
        }).state('categories', {
            url: '/categories',
            templateUrl: 'views/showCategories.html',
            controller: 'CategoriesController as categoriesCtrl',
        }).state('items', {
            url: '/items/{short_name}',
            templateUrl: 'views/showItems.html',
            controller: 'ItemsController as itemsCtrl'
        });

        $urlRouterProvider.otherwise('/');
    };

    routesConfig.$inject = ['$stateProvider', '$urlRouterProvider'];
    angular.module('MenuApp').config(routesConfig);
})();