// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

//importing simple storage contract from a different sol in the same folder
import "./SimpleStorage.sol";

//creating a new contract which creates a simple storage contract
contract StorageFactory{
    // this is a array with type SimpleStorage
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        // this is creating a variable that stores a newly created simplestorage contract which will then be stored in an array
        SimpleStorage simplestorage = new SimpleStorage();
        simpleStorageArray.push(simplestorage);

    }
    //creating a function that calls the store function from the simplestorage contract which is stored in the simplestoragearray
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        SimpleStorage simplestorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        simplestorage.store(_simpleStorageNumber);
    //this only stores the function in the simplestorage contract, it will not be able to be viewed

    }

    //this function will use the retrieve function in the simplestorage contract to view the favourite number stored in the simplestorage contract
    function sfRetrieve(uint256 _simpleStorageIndex) public view returns (uint256){
        SimpleStorage simplestorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
        return simplestorage.retrieve();

    }

}
