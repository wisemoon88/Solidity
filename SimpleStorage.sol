// SPDX-License-Identifier: MIT

pragma solidity 0.6.0;

//this is how you start making a contract
contract SimpleStorage {
    //creating a new variable requires type and visibility
    uint256 favouriteNumber;
    bool favouriteBool;

    struct People {
        uint256 favouriteNumber;
        string name;
    }
    //this is creating an array of type People and making it public
    People[] public people;

    mapping(string => uint256) public nameToFavouriteNumber;

    //function is similar to method, executes an action with aruguments provided.  if it changes a state of the blockchain it will require a transaction
    function store(uint256 _favouriteNumber) public {
        favouriteNumber = _favouriteNumber;
    }

    //view doesnt change the state of the blockchain
    function retrieve() public view returns (uint256) {
        return favouriteNumber;
    }

    //this function adds a name and favourite number to the people array.  taking in 2 arguments
    function addPerson(string memory _name, uint256 _favouriteNumber) public {
        people.push(People(_favouriteNumber, _name));
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }

    //NOTE: deploying a contract and interacting with a contract is different.  deploying is creating a new instance of tha contract whichi will require importing the whole sol code.  interacting just requires the defined function
}
