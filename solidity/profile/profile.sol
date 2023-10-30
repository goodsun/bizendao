// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Profile  {
    address private _owner;
	mapping(address => string) private _name;
	mapping(address => string) private _profile;
 	mapping(address => bool) private _public;
	address[] private _list;

	constructor() {
		_owner = msg.sender;
	}

	function setProfile(string calldata profile, string calldata name, bool open) external {
		_name[msg.sender] = name;
		_profile[msg.sender] = profile;
		_public[msg.sender] = open;
		bool found = false;
		for(uint i=0; i<_list.length; i++){
			if(msg.sender == _list[i]){
				found = true;
			}
		}
		if(!found){
			_list.push(msg.sender);
		}
	}

	function getAll() public view returns (address[] memory, uint256){
    	return (_list, _list.length);
	}

    function getProfile(address account) public view returns (string memory,string memory, bool) {
		if(_public[account] || account == msg.sender){
			return (_profile[account],_name[account],_public[account]);
		}
        return ("","",false);
    }

	function checkProfile() external view returns (string memory,string memory, bool){
		return (_profile[msg.sender],_name[msg.sender],_public[msg.sender]);
	}

}
