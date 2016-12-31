(function() {
    'use strict';

    var categoriesController = function(MenuDataService) {
        var vm = this;
        vm.menuCategories = [];
    
        vm.getAllCategories = function() {
            MenuDataService.getAllCategories().then(function(response) {
                vm.menuCategories = response.data;
            }, function(error) {
                console.log('Error while trying to get all categories: ', error);
            });
        };

        vm.getAllCategories();
    }

    categoriesController.$inject = ['MenuDataService'];
    angular.module('MenuApp').controller('CategoriesController', categoriesController);
})();