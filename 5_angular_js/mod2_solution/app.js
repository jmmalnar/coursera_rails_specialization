/**
 * Created by jmm5872 on 12/13/16.
 */

(function () {
    'use strict';

    angular.module('ShoppingListCheckOff', [])
    .controller('ToBuyController', ToBuyController)
    .controller('AlreadyBoughtController', AlreadyBoughtController)
    .service('ShoppingListCheckOffService', ShoppingListCheckOffService)

    ToBuyController.$inject = ['ShoppingListCheckOffService'];

    function ToBuyController(ShoppingListCheckOffService) {
        var toBuyItem = this;
        toBuyItem.items = ShoppingListCheckOffService.getItemsToBuy();
        toBuyItem.removeItem = function (itemIndex) {
            ShoppingListCheckOffService.removeItem(itemIndex);
        };
    }

    AlreadyBoughtController.$inject = ['ShoppingListCheckOffService'];

    function AlreadyBoughtController(ShoppingListCheckOffService) {
        var boughtItems = this;
        boughtItems.items = ShoppingListCheckOffService.getBoughtItems();
    }

    function ShoppingListCheckOffService() {
        var service = this;

        var toBuyItems = [
            { name: "cookies", quantity: 10 },
            { name: "milk(s)", quantity: 1 },
            { name: "candies", quantity: 5 },
            { name: "ice cream", quantity: 1 },
            { name: "bags of salad", quantity: 3 },
            { name: "bottles of water", quantity: 24 },
            { name: "guitars", quantity: 2 }
        ];

        var alreadyBoughtItems = [];

        service.removeItem = function (itemIndex) {
            var item = toBuyItems[itemIndex];
            alreadyBoughtItems.push(item);
            toBuyItems.splice(itemIndex, 1);
        };

        service.getItemsToBuy = function () {
            return toBuyItems;
        };

        service.getBoughtItems = function () {
            return alreadyBoughtItems;
        };

    }

})();