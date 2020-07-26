import 'dart:collection';

class DataHandler {
  Queue stack = new Queue();
  bool isComplete = false;

  bool handleString(String data){
    for(int i = 0; i < data.length;i++){
      if(data[i] == "{"){
        addBracket(true);
      }
      else if(data[i] == "}"){
        addBracket(false);
      }
    }
    return isComplete;
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
      isComplete = true;
    }
  }

  bool complete(){
    return isComplete;
  }






}