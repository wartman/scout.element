package todo.view;

import scout.element.ScoutElement;
import scout.html.Template.html;
import todo.model.Todo;

@:element('todo-list')
class TodoList extends ScoutElement {

  // @:attr('class') var className:String = 'todo-list';
  @:prop var todos:Array<Todo> = [];
  var initValue:String = '';

  function makeTodo(value:String) {
    todos.push(new Todo(
      Std.string(todos.length + 1),
      value,
      false
    ));
    update();
  }

  override function render() {
    return html('
      <todo-input .label="create" .value=${initValue} .onSubmit=${makeTodo} />
      <ul class="todo-list">
        ${[ for (todo in todos) html('<todo-item .todo=${todo} />') ]}
      </ul>
    ');
  }

}
