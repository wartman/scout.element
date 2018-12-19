package todo.view;

import js.html.Event;
import scout.element.ScoutElement;
import scout.html.Api.html;
import todo.model.Todo;

@:element('todo-item')
class TodoItem extends ScoutElement {

  @:prop var todo:Todo = new Todo('', '', false);

  public function removeItem() {
    remove();
  }

  public function edit(e:Event) {
    e.preventDefault();

  }

  function toggleComplete(e:Event) {
    todo.completed = !todo.completed;
    update();
  }

  override function shouldRender() {
    return todo != null;
  }

  override function render() return html('
    <li 
      class="todo-item" 
      id="Todo-${todo.id}"
    >
      <input class="edit" type="text" value="${todo.content}" />
      <div class="view">
        <input 
          class="toggle" 
          type="checkbox" 
          on:change="${toggleComplete}"
          is:checked="${todo.completed}" />
        <label>${todo.content}</label>
        <button class="destroy" on:click="${_ -> removeItem()}"></button>
      </div>
    </li>
  ');

}
