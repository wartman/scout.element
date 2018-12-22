package todo.view;

import js.html.Event;
import scout.element.ScoutElement;
import scout.html.Api.html;
import todo.model.Todo;
import todo.view.TodoInput;


@:element('todo-item', { extend: 'li' })
class TodoItem extends ScoutElement {

  @:attr('class') var className:String = 'todo-item';
  @:prop var todo:Todo;

  public function removeItem() {
    remove();
  }

  function toggleComplete(e:Event) {
    todo.completed = !todo.completed;
    update();
  }

  function updateContent(value:String) {
    todo.content = value;
    todo.editing = false;
    update();
  }

  function toggleEditing() {
    todo.editing = true;
    update();
  }

  override function shouldRender() {
    return todo != null;
  }
  
  override function render() return html('
    ${if (todo.editing) html('
      <todo-input
        className="edit"
        .label="update"
        .value="${todo.content}"
        .onSubmit="${updateContent}" 
      />
    ') else html ('
      <input 
        class="toggle" 
        type="checkbox" 
        on:change="${toggleComplete}"
        is:checked="${todo.completed}" 
      />
      <label>${todo.content}</label>
      <button class="edit" on:click="${_ -> toggleEditing()}">Edit</button>
      <button class="destroy" on:click="${_ -> removeItem()}">Remove</button>
    ')}
  ');

}
