import 'dart:collection';

class DataHandler {
  Queue stack = new Queue();
  bool _isComplete = false;
  String temp="";
  bool handleString(String data){
    temp = temp + data;
    for(int i = 0; i < data.length;i++){
      if(data[i] == "{"){
        addBracket(true);
      }
      else if(data[i] == "}"){
        addBracket(false);
      }
    }
    return _isComplete;
  }

  void addBracket(bool faceright){
    if(faceright) {
      stack.addLast("{");
    }
    //
    else{
      if(stack.last == "{"){
        stack.removeLast();
      }
      else{
        stack.addLast("}");
      }
    }

    if(stack.isEmpty == true){
      _isComplete = true;
    }
  }

  bool complete(){
    bool temp = _isComplete;
    if(temp == true){
      print(this.stack.length);
      _isComplete = false;
    }
    return temp;
  }

  String getDone(){
    String t = temp;
    temp = "";
    return t;
  }


}