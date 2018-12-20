package todo.view;

import js.html.Event;
import scout.element.ScoutElement;
import scout.html.Api.html;
import todo.model.Todo;
import todo.view.TodoInput;

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

  // Something is wrong with the NodePart, I think, as it
  // doesn't properally remove an old Node (at least with
  // TemplateResults). Sure do need tests :V
  override function render() return html('
    <li 
      class="todo-item" 
      id="Todo-${todo.id}"
    >
      ${if (todo.editing) html('
        <todo-input
          className="edit"
          label="update" 
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
    </li>
  ');

}
