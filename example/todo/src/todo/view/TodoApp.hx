package todo.view;

import haxe.Json;
import scout.element.ScoutElement;
import scout.html.Template.html;
import todo.model.Todo;

@:element('todo-app')
class TodoApp extends ScoutElement {
  
  @:prop( attribute = 'todos' ) var todos:String = '[]';

  override function render() {
    var raw:Array<{ id:Int, content:String, completed:Bool }> = Json.parse(todos);
    trace(raw);
    var renderedTodos = [ for (data in raw)
      new Todo(data.id, data.content, data.completed),
    ];
    return html(<todo-list .todos={renderedTodos} />);
  }

}
