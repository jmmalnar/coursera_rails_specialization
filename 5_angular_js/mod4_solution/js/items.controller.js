(function() {
    'use strict';

    var itemsController = function(MenuDataService, $stateParams) {
        var vm = this;
        vm.menuItems = [];
        vm.category = $stateParams.short_name;
        
        vm.getItemsForCategory = function(categoryShortName) {
            MenuDataService.getItemsForCategory(categoryShortName).then(function(response) {
                console.log(response);
                vm.menuItems = response.data;
            }, function(error) {
                console.log(error);
            });
        }

        vm.getItemsForCategory(vm.category);
        
    }

    itemsController.$inject = ['MenuDataService', '$stateParams'];
    angular.module('MenuApp').controller('ItemsController', itemsController);
})();