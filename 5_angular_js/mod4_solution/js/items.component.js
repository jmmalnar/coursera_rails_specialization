(function() {
    'use strict';

    angular.module('MenuApp').component('items', {
        templateUrl: 'views/items.html',
        bindings: {
            menuItems: '<'
        }
    });

})();