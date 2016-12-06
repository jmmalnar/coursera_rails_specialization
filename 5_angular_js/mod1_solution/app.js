(function () {
    'use strict';

    angular.module('LunchCheck', [])
        .controller('LunchCheckController', LunchCheckController);

    LunchCheckController.$inject = ['$scope'];

    function LunchCheckController($scope) {

        $scope.list = "";

        $scope.checkIfTooMuch = function () {
            var listArray = $scope.list.split(',').filter(function(str){
                return /\S/.test(str);
            });

            $scope.textColor = 'green';
            $scope.borderColor = 'green';

            if (listArray == '') {
                $scope.message = 'Please enter data first';
                $scope.textColor = 'red';
                $scope.borderColor = 'red';
            } else if (listArray.length <= 3) {
                $scope.message = 'Enjoy!';
            } else if (listArray.length > 3) {
                $scope.message = 'Too much!';
            }

        };

    }

})();