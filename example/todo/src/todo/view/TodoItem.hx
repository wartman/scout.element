package todo.view;

import js.html.Event;
import scout.element.ScoutElement;
import scout.html.Template.html;
import todo.model.Todo;


@:element('todo-item', { extend: 'li' })
class TodoItem extends ScoutElement {

  @:attr('class') var clsName:String = 'todo-item';
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
  
  override function render() return html(<>
    { if (todo.editing) <todo-input
      className="edit"
      .label="update"
      .onSubmit={updateContent}
      .value={todo.content}
    /> else <>
      <input
        class="toggle" 
        type="checkbox"
        @change={toggleComplete}
        ?checked={todo.completed} 
      />
      <label>{todo.content}</label>
      <button class="edit" @click={_ -> toggleEditing()}>Edit</button>
      <button class="destroy" @click={_ -> removeItem()}>Remove</button>
    </> }  
  </>);

}
