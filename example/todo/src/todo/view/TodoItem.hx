package todo.view;

import js.html.Event;
import scout.element.ScoutElement;
import scout.html.Template.html;
import todo.model.Todo;


@:element('todo-item', { extend: 'li' })
class TodoItem extends ScoutElement {

  // @:attr('class') var className:String = 'todo-item';
  @:prop var todo:Todo = null;

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
  
  override function render() return if (todo.editing) html('
    <todo-input
      className="edit"
      .label="update"
      .onSubmit=${updateContent}
      .value=${todo.content}
    />
  ') else html('
    <input
      class="toggle" 
      type="checkbox"
      onChange=${toggleComplete}
      isChecked=${todo.completed} 
    />
    <label>${todo.content}</label>
    <button class="edit" onClick=${_ -> toggleEditing()}>Edit</button>
    <button class="destroy" onClick=${_ -> removeItem()}>Remove</button>
  ');

}
