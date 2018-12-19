package todo.model;

class Todo {
  
  public var id:String;
  public var content:String;
  public var completed:Bool;

  public function new(id, content, completed) {
    this.id = id;
    this.content = content;
    this.completed = completed;
  }

}
