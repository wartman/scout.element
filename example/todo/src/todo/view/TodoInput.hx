package todo.view;

import js.html.InputElement;
import js.html.Event;
import scout.element.ScoutElement;
import scout.html.Template.html;

@:element('todo-input')
class TodoInput extends ScoutElement {

  // @:attr('class') var className:String = 'todo-edit';
  @:prop var label:String = 'Create';
  @:prop var value:String = '';
  @:prop var onSubmit:(value:String)->Void;

  function handleChange(e:Event) {
    var input:InputElement = cast e.target;
    value = input.value;
  }

  function handleSubmit(e:Event) {
    e.preventDefault();
    onSubmit(value);
    value = '';
    update();
  }

  override function render() return html('
    <input 
      class="todo-edit"
      value=${value}
      @change=${handleChange}
    />
    <button 
      class="create"
      @click=${handleSubmit}
    >${label}</button>
  ');

}
