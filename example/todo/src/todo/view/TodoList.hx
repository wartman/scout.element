package todo.view;

import scout.element.ScoutElement;
import scout.html.Api.html;
import todo.model.Todo;
import todo.view.TodoItem;

@:element('todo-list')
class TodoList extends ScoutElement {

  @:prop var todos:Array<Todo> = [];

  override function render() return html('
    <ul class="todo-list">
      ${[ for (todo in todos) html('<todo-item .todo="${todo}" />') ]}
    </ul>
  ');

}
