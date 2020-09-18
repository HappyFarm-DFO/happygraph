/* 
 *  HappyGraph by HappyFarm
 *  VERSION: 1.0
 *  
 */

pragma solidity ^0.6.0;

contract HappyGraph {
    
    struct FRIEND{
        address friend;
    }
    
    mapping( address => FRIEND[]) public friend_requests;
    mapping( address => FRIEND[]) public friends;
    
    function send_friend_request(address guy) public returns(bool){
        friend_requests[guy].push(FRIEND(msg.sender));
        return true;
    }
    
    function accept_friend_request(address guy) public returns(bool){
        friends[msg.sender].push(FRIEND(guy));
        return true;
    }
    
    function list_friend_request(address guy) public view returns(string memory){
        string memory list;
        string memory list_temp;
        string memory temp;
        string memory temp2;
        uint counter=0;
        for(uint i=0;i<friend_requests[guy].length;i++){
            if(!isFriend(guy,friend_requests[guy][i].friend))
            temp=append("\"",toString(friend_requests[guy][i].friend),"\"");
            list_temp=list;
            if(i<friend_requests[guy].length-1){
                list=append(list_temp,temp,",");
            }else{
                list=append(list_temp,temp,"");
            }
            counter++;
        }
        temp=append("{\"requests\":\"",toString(counter),"\",\"list\":[");
        temp2=append(temp,list,"]}");
        return temp2;
    }
    
    function list_friends(address guy) public view returns(string memory){
        string memory list;
        string memory list_temp;
        string memory temp;
        string memory temp2;
        uint counter=0;
        for(uint i=0;i<friends[guy].length;i++){
            temp=append("\"",toString(friends[guy][i].friend),"\"");
            list_temp=list;
            if(i<friends[guy].length-1){
                list=append(list_temp,temp,",");
            }else{
                list=append(list_temp,temp,"");
            }
            counter++;
        }
        temp=append("{\"friends\":\"",toString(counter),"\",\"list\":[");
        temp2=append(temp,list,"]}");
        return temp2;
    }
    
    function isFriend (address guy,address friend) public view returns (bool) {
        bool isfriend=false;
        for(uint i=0;i<friends[guy].length;i++){
            if(friends[guy][i].friend==friend)isfriend=true;
            return isfriend;
        }
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
