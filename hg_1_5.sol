/* 
 *  HappyGraph by HappyFarm
 *  VERSION: 1.5
 *  
 */

pragma solidity ^0.6.0;

contract HappyGraph {

    uint256 public citizens=0;
    mapping( address => address[]) public friend_requests;
    mapping( address => address[]) public friends;
    mapping( address =>  mapping( address => bool)) public friends_check;
    mapping( address =>  mapping( address => bool)) public friends_requesting;
    
    function send_friend_request(address guy) public returns(bool){
        friend_requests[guy].push(msg.sender);
        friends_requesting[guy][msg.sender]=true;
        return true;
    }
    
    function accept_friend_request(address guy) public returns(bool){
        if(!friends_requesting[msg.sender][guy])return false;
        friends[msg.sender].push(guy);
        friends[guy].push(msg.sender);
        citizens++;
        return true;
    }
    
    function list_friend_request(address guy) public view returns(string memory){
        string memory list;
        string memory list_temp;
        string memory temp;
        uint counter=0;
        for(uint i=0;i<friend_requests[guy].length;i++){
            if(!isFriend(guy,friend_requests[guy][i]))
            temp=append("\"",toString(friend_requests[guy][i]),"\"");
            list_temp=list;
            if(i<friend_requests[guy].length-1){
                list=append(list_temp,temp,",");
            }else{
                list=append(list_temp,temp,"");
            }
            counter++;
        }
        temp=append("{\"requests\":\"",toString(counter),"\",\"list\":[");
        list_temp=append(temp,list,"]}");
        return list_temp;
    }
    
    function list_friends(address guy) public view returns(string memory){
        string memory list;
        string memory list_temp;
        string memory temp;
        uint counter=0;
        for(uint i=0;i<friends[guy].length;i++){
            temp=append("\"",toString(friends[guy][i]),"\"");
            list_temp=list;
            if(i<friends[guy].length-1){
                list=append(list_temp,temp,",");
            }else{
                list=append(list_temp,temp,"");
            }
            counter++;
        }
        temp=append("{\"friends\":\"",toString(counter),"\",\"list\":[");
        list_temp=append(temp,list,"]}");
        return list_temp;
    }
    
    function isFriend (address guy,address friend) public view returns (bool) {
        bool isfriend=false;
        for(uint i=0;i<friends[guy].length;i++){
            if(friends[guy][i]==friend)isfriend=true;
        }
        return isfriend;
    } 
    
    function isFriend_onchain (address guy,address friend) public view returns (bool) {
        return friends_check[guy][friend];
    } 
    
    function registerFriend(address friend) public returns (bool) {
        if(!friends_requesting[msg.sender][friend])return false;
        friends_check[msg.sender][friend]=true;
        return true;
    } 
    
     function countFriends(address guy) public view returns (uint256) {
        return friends[guy].length;
    } 
    
    function countRequests(address guy) public view returns (uint256) {
        return friend_requests[guy].length;
    } 
    
    function isRequested(address guy,address friend) public view returns (bool) {
        return friends_requesting[guy][friend];
    }
    
    ///////////////////////////////////////////////////////////////////////////
       
    function append(string memory a, string memory b, string memory c) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }
    
    function toString(address account) internal pure returns(string memory) {
    return toString(abi.encodePacked(account));
    }

    function toString(uint256 value) internal pure returns(string memory) {
    return toString(abi.encodePacked(value));
    }

    function toString(bytes32 value) internal pure returns(string memory) {
    return toString(abi.encodePacked(value));
    }

    function toString(bytes memory data) internal pure returns(string memory) {
    bytes memory alphabet = "0123456789abcdef";

    bytes memory str = new bytes(2 + data.length * 2);
    str[0] = '0';
    str[1] = 'x';
    for (uint i = 0; i < data.length; i++) {
        str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
        str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
    }
    return string(str);
}
    
}